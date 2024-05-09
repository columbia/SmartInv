1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 // Sources flattened with hardhat v2.1.2 https://hardhat.org
5 // NOTE: manually removed extraneous licence identifies and pragmas to accommodate Etherscan Verify & Publish
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.0.0
8 
9 
10 
11 
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.0.0
36 
37 
38 
39 
40 
41 /**
42  * @dev Interface of the ERC165 standard, as defined in the
43  * https://eips.ethereum.org/EIPS/eip-165[EIP].
44  *
45  * Implementers can declare support of contract interfaces, which can then be
46  * queried by others ({ERC165Checker}).
47  *
48  * For an implementation, see {ERC165}.
49  */
50 interface IERC165 {
51     /**
52      * @dev Returns true if this contract implements the interface defined by
53      * `interfaceId`. See the corresponding
54      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
55      * to learn more about how these ids are created.
56      *
57      * This function call must use less than 30 000 gas.
58      */
59     function supportsInterface(bytes4 interfaceId) external view returns (bool);
60 }
61 
62 
63 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.0.0
64 
65 
66 
67 
68 
69 /**
70  * @dev Implementation of the {IERC165} interface.
71  *
72  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
73  * for the additional interface id that will be supported. For example:
74  *
75  * ```solidity
76  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
77  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
78  * }
79  * ```
80  *
81  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
82  */
83 abstract contract ERC165 is IERC165 {
84     /**
85      * @dev See {IERC165-supportsInterface}.
86      */
87     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
88         return interfaceId == type(IERC165).interfaceId;
89     }
90 }
91 
92 
93 // File @openzeppelin/contracts/access/AccessControl.sol@v4.0.0
94 
95 
96 
97 
98 
99 
100 /**
101  * @dev External interface of AccessControl declared to support ERC165 detection.
102  */
103 interface IAccessControl {
104     function hasRole(bytes32 role, address account) external view returns (bool);
105     function getRoleAdmin(bytes32 role) external view returns (bytes32);
106     function grantRole(bytes32 role, address account) external;
107     function revokeRole(bytes32 role, address account) external;
108     function renounceRole(bytes32 role, address account) external;
109 }
110 
111 /**
112  * @dev Contract module that allows children to implement role-based access
113  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
114  * members except through off-chain means by accessing the contract event logs. Some
115  * applications may benefit from on-chain enumerability, for those cases see
116  * {AccessControlEnumerable}.
117  *
118  * Roles are referred to by their `bytes32` identifier. These should be exposed
119  * in the external API and be unique. The best way to achieve this is by
120  * using `public constant` hash digests:
121  *
122  * ```
123  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
124  * ```
125  *
126  * Roles can be used to represent a set of permissions. To restrict access to a
127  * function call, use {hasRole}:
128  *
129  * ```
130  * function foo() public {
131  *     require(hasRole(MY_ROLE, msg.sender));
132  *     ...
133  * }
134  * ```
135  *
136  * Roles can be granted and revoked dynamically via the {grantRole} and
137  * {revokeRole} functions. Each role has an associated admin role, and only
138  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
139  *
140  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
141  * that only accounts with this role will be able to grant or revoke other
142  * roles. More complex role relationships can be created by using
143  * {_setRoleAdmin}.
144  *
145  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
146  * grant and revoke this role. Extra precautions should be taken to secure
147  * accounts that have been granted it.
148  */
149 abstract contract AccessControl is Context, IAccessControl, ERC165 {
150     struct RoleData {
151         mapping (address => bool) members;
152         bytes32 adminRole;
153     }
154 
155     mapping (bytes32 => RoleData) private _roles;
156 
157     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
158 
159     /**
160      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
161      *
162      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
163      * {RoleAdminChanged} not being emitted signaling this.
164      *
165      * _Available since v3.1._
166      */
167     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
168 
169     /**
170      * @dev Emitted when `account` is granted `role`.
171      *
172      * `sender` is the account that originated the contract call, an admin role
173      * bearer except when using {_setupRole}.
174      */
175     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
176 
177     /**
178      * @dev Emitted when `account` is revoked `role`.
179      *
180      * `sender` is the account that originated the contract call:
181      *   - if using `revokeRole`, it is the admin role bearer
182      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
183      */
184     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
185 
186     /**
187      * @dev See {IERC165-supportsInterface}.
188      */
189     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
190         return interfaceId == type(IAccessControl).interfaceId
191             || super.supportsInterface(interfaceId);
192     }
193 
194     /**
195      * @dev Returns `true` if `account` has been granted `role`.
196      */
197     function hasRole(bytes32 role, address account) public view override returns (bool) {
198         return _roles[role].members[account];
199     }
200 
201     /**
202      * @dev Returns the admin role that controls `role`. See {grantRole} and
203      * {revokeRole}.
204      *
205      * To change a role's admin, use {_setRoleAdmin}.
206      */
207     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
208         return _roles[role].adminRole;
209     }
210 
211     /**
212      * @dev Grants `role` to `account`.
213      *
214      * If `account` had not been already granted `role`, emits a {RoleGranted}
215      * event.
216      *
217      * Requirements:
218      *
219      * - the caller must have ``role``'s admin role.
220      */
221     function grantRole(bytes32 role, address account) public virtual override {
222         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
223 
224         _grantRole(role, account);
225     }
226 
227     /**
228      * @dev Revokes `role` from `account`.
229      *
230      * If `account` had been granted `role`, emits a {RoleRevoked} event.
231      *
232      * Requirements:
233      *
234      * - the caller must have ``role``'s admin role.
235      */
236     function revokeRole(bytes32 role, address account) public virtual override {
237         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
238 
239         _revokeRole(role, account);
240     }
241 
242     /**
243      * @dev Revokes `role` from the calling account.
244      *
245      * Roles are often managed via {grantRole} and {revokeRole}: this function's
246      * purpose is to provide a mechanism for accounts to lose their privileges
247      * if they are compromised (such as when a trusted device is misplaced).
248      *
249      * If the calling account had been granted `role`, emits a {RoleRevoked}
250      * event.
251      *
252      * Requirements:
253      *
254      * - the caller must be `account`.
255      */
256     function renounceRole(bytes32 role, address account) public virtual override {
257         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
258 
259         _revokeRole(role, account);
260     }
261 
262     /**
263      * @dev Grants `role` to `account`.
264      *
265      * If `account` had not been already granted `role`, emits a {RoleGranted}
266      * event. Note that unlike {grantRole}, this function doesn't perform any
267      * checks on the calling account.
268      *
269      * [WARNING]
270      * ====
271      * This function should only be called from the constructor when setting
272      * up the initial roles for the system.
273      *
274      * Using this function in any other way is effectively circumventing the admin
275      * system imposed by {AccessControl}.
276      * ====
277      */
278     function _setupRole(bytes32 role, address account) internal virtual {
279         _grantRole(role, account);
280     }
281 
282     /**
283      * @dev Sets `adminRole` as ``role``'s admin role.
284      *
285      * Emits a {RoleAdminChanged} event.
286      */
287     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
288         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
289         _roles[role].adminRole = adminRole;
290     }
291 
292     function _grantRole(bytes32 role, address account) private {
293         if (!hasRole(role, account)) {
294             _roles[role].members[account] = true;
295             emit RoleGranted(role, account, _msgSender());
296         }
297     }
298 
299     function _revokeRole(bytes32 role, address account) private {
300         if (hasRole(role, account)) {
301             _roles[role].members[account] = false;
302             emit RoleRevoked(role, account, _msgSender());
303         }
304     }
305 }
306 
307 
308 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.0.0
309 
310 
311 
312 
313 
314 /**
315  * @dev Interface of the ERC20 standard as defined in the EIP.
316  */
317 interface IERC20 {
318     /**
319      * @dev Returns the amount of tokens in existence.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns the amount of tokens owned by `account`.
325      */
326     function balanceOf(address account) external view returns (uint256);
327 
328     /**
329      * @dev Moves `amount` tokens from the caller's account to `recipient`.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transfer(address recipient, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Returns the remaining number of tokens that `spender` will be
339      * allowed to spend on behalf of `owner` through {transferFrom}. This is
340      * zero by default.
341      *
342      * This value changes when {approve} or {transferFrom} are called.
343      */
344     function allowance(address owner, address spender) external view returns (uint256);
345 
346     /**
347      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * IMPORTANT: Beware that changing an allowance with this method brings the risk
352      * that someone may use both the old and the new allowance by unfortunate
353      * transaction ordering. One possible solution to mitigate this race
354      * condition is to first reduce the spender's allowance to 0 and set the
355      * desired value afterwards:
356      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357      *
358      * Emits an {Approval} event.
359      */
360     function approve(address spender, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Moves `amount` tokens from `sender` to `recipient` using the
364      * allowance mechanism. `amount` is then deducted from the caller's
365      * allowance.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Emitted when `value` tokens are moved from one account (`from`) to
375      * another (`to`).
376      *
377      * Note that `value` may be zero.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 value);
380 
381     /**
382      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
383      * a call to {approve}. `value` is the new allowance.
384      */
385     event Approval(address indexed owner, address indexed spender, uint256 value);
386 }
387 
388 
389 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.0.0
390 
391 
392 
393 
394 
395 
396 /**
397  * @dev Implementation of the {IERC20} interface.
398  *
399  * This implementation is agnostic to the way tokens are created. This means
400  * that a supply mechanism has to be added in a derived contract using {_mint}.
401  * For a generic mechanism see {ERC20PresetMinterPauser}.
402  *
403  * TIP: For a detailed writeup see our guide
404  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
405  * to implement supply mechanisms].
406  *
407  * We have followed general OpenZeppelin guidelines: functions revert instead
408  * of returning `false` on failure. This behavior is nonetheless conventional
409  * and does not conflict with the expectations of ERC20 applications.
410  *
411  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
412  * This allows applications to reconstruct the allowance for all accounts just
413  * by listening to said events. Other implementations of the EIP may not emit
414  * these events, as it isn't required by the specification.
415  *
416  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
417  * functions have been added to mitigate the well-known issues around setting
418  * allowances. See {IERC20-approve}.
419  */
420 contract ERC20 is Context, IERC20 {
421     mapping (address => uint256) private _balances;
422 
423     mapping (address => mapping (address => uint256)) private _allowances;
424 
425     uint256 private _totalSupply;
426 
427     string private _name;
428     string private _symbol;
429 
430     /**
431      * @dev Sets the values for {name} and {symbol}.
432      *
433      * The defaut value of {decimals} is 18. To select a different value for
434      * {decimals} you should overload it.
435      *
436      * All three of these values are immutable: they can only be set once during
437      * construction.
438      */
439     constructor (string memory name_, string memory symbol_) {
440         _name = name_;
441         _symbol = symbol_;
442     }
443 
444     /**
445      * @dev Returns the name of the token.
446      */
447     function name() public view virtual returns (string memory) {
448         return _name;
449     }
450 
451     /**
452      * @dev Returns the symbol of the token, usually a shorter version of the
453      * name.
454      */
455     function symbol() public view virtual returns (string memory) {
456         return _symbol;
457     }
458 
459     /**
460      * @dev Returns the number of decimals used to get its user representation.
461      * For example, if `decimals` equals `2`, a balance of `505` tokens should
462      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
463      *
464      * Tokens usually opt for a value of 18, imitating the relationship between
465      * Ether and Wei. This is the value {ERC20} uses, unless this function is
466      * overloaded;
467      *
468      * NOTE: This information is only used for _display_ purposes: it in
469      * no way affects any of the arithmetic of the contract, including
470      * {IERC20-balanceOf} and {IERC20-transfer}.
471      */
472     function decimals() public view virtual returns (uint8) {
473         return 18;
474     }
475 
476     /**
477      * @dev See {IERC20-totalSupply}.
478      */
479     function totalSupply() public view virtual override returns (uint256) {
480         return _totalSupply;
481     }
482 
483     /**
484      * @dev See {IERC20-balanceOf}.
485      */
486     function balanceOf(address account) public view virtual override returns (uint256) {
487         return _balances[account];
488     }
489 
490     /**
491      * @dev See {IERC20-transfer}.
492      *
493      * Requirements:
494      *
495      * - `recipient` cannot be the zero address.
496      * - the caller must have a balance of at least `amount`.
497      */
498     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
499         _transfer(_msgSender(), recipient, amount);
500         return true;
501     }
502 
503     /**
504      * @dev See {IERC20-allowance}.
505      */
506     function allowance(address owner, address spender) public view virtual override returns (uint256) {
507         return _allowances[owner][spender];
508     }
509 
510     /**
511      * @dev See {IERC20-approve}.
512      *
513      * Requirements:
514      *
515      * - `spender` cannot be the zero address.
516      */
517     function approve(address spender, uint256 amount) public virtual override returns (bool) {
518         _approve(_msgSender(), spender, amount);
519         return true;
520     }
521 
522     /**
523      * @dev See {IERC20-transferFrom}.
524      *
525      * Emits an {Approval} event indicating the updated allowance. This is not
526      * required by the EIP. See the note at the beginning of {ERC20}.
527      *
528      * Requirements:
529      *
530      * - `sender` and `recipient` cannot be the zero address.
531      * - `sender` must have a balance of at least `amount`.
532      * - the caller must have allowance for ``sender``'s tokens of at least
533      * `amount`.
534      */
535     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
536         _transfer(sender, recipient, amount);
537 
538         uint256 currentAllowance = _allowances[sender][_msgSender()];
539         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
540         _approve(sender, _msgSender(), currentAllowance - amount);
541 
542         return true;
543     }
544 
545     /**
546      * @dev Atomically increases the allowance granted to `spender` by the caller.
547      *
548      * This is an alternative to {approve} that can be used as a mitigation for
549      * problems described in {IERC20-approve}.
550      *
551      * Emits an {Approval} event indicating the updated allowance.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      */
557     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
558         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
559         return true;
560     }
561 
562     /**
563      * @dev Atomically decreases the allowance granted to `spender` by the caller.
564      *
565      * This is an alternative to {approve} that can be used as a mitigation for
566      * problems described in {IERC20-approve}.
567      *
568      * Emits an {Approval} event indicating the updated allowance.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      * - `spender` must have allowance for the caller of at least
574      * `subtractedValue`.
575      */
576     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
577         uint256 currentAllowance = _allowances[_msgSender()][spender];
578         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
579         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
580 
581         return true;
582     }
583 
584     /**
585      * @dev Moves tokens `amount` from `sender` to `recipient`.
586      *
587      * This is internal function is equivalent to {transfer}, and can be used to
588      * e.g. implement automatic token fees, slashing mechanisms, etc.
589      *
590      * Emits a {Transfer} event.
591      *
592      * Requirements:
593      *
594      * - `sender` cannot be the zero address.
595      * - `recipient` cannot be the zero address.
596      * - `sender` must have a balance of at least `amount`.
597      */
598     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
599         require(sender != address(0), "ERC20: transfer from the zero address");
600         require(recipient != address(0), "ERC20: transfer to the zero address");
601 
602         _beforeTokenTransfer(sender, recipient, amount);
603 
604         uint256 senderBalance = _balances[sender];
605         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
606         _balances[sender] = senderBalance - amount;
607         _balances[recipient] += amount;
608 
609         emit Transfer(sender, recipient, amount);
610     }
611 
612     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
613      * the total supply.
614      *
615      * Emits a {Transfer} event with `from` set to the zero address.
616      *
617      * Requirements:
618      *
619      * - `to` cannot be the zero address.
620      */
621     function _mint(address account, uint256 amount) internal virtual {
622         require(account != address(0), "ERC20: mint to the zero address");
623 
624         _beforeTokenTransfer(address(0), account, amount);
625 
626         _totalSupply += amount;
627         _balances[account] += amount;
628         emit Transfer(address(0), account, amount);
629     }
630 
631     /**
632      * @dev Destroys `amount` tokens from `account`, reducing the
633      * total supply.
634      *
635      * Emits a {Transfer} event with `to` set to the zero address.
636      *
637      * Requirements:
638      *
639      * - `account` cannot be the zero address.
640      * - `account` must have at least `amount` tokens.
641      */
642     function _burn(address account, uint256 amount) internal virtual {
643         require(account != address(0), "ERC20: burn from the zero address");
644 
645         _beforeTokenTransfer(account, address(0), amount);
646 
647         uint256 accountBalance = _balances[account];
648         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
649         _balances[account] = accountBalance - amount;
650         _totalSupply -= amount;
651 
652         emit Transfer(account, address(0), amount);
653     }
654 
655     /**
656      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
657      *
658      * This internal function is equivalent to `approve`, and can be used to
659      * e.g. set automatic allowances for certain subsystems, etc.
660      *
661      * Emits an {Approval} event.
662      *
663      * Requirements:
664      *
665      * - `owner` cannot be the zero address.
666      * - `spender` cannot be the zero address.
667      */
668     function _approve(address owner, address spender, uint256 amount) internal virtual {
669         require(owner != address(0), "ERC20: approve from the zero address");
670         require(spender != address(0), "ERC20: approve to the zero address");
671 
672         _allowances[owner][spender] = amount;
673         emit Approval(owner, spender, amount);
674     }
675 
676     /**
677      * @dev Hook that is called before any transfer of tokens. This includes
678      * minting and burning.
679      *
680      * Calling conditions:
681      *
682      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
683      * will be to transferred to `to`.
684      * - when `from` is zero, `amount` tokens will be minted for `to`.
685      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
686      * - `from` and `to` are never both zero.
687      *
688      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
689      */
690     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
691 }
692 
693 
694 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.0.0
695 
696 
697 
698 
699 
700 
701 /**
702  * @dev Extension of {ERC20} that allows token holders to destroy both their own
703  * tokens and those that they have an allowance for, in a way that can be
704  * recognized off-chain (via event analysis).
705  */
706 abstract contract ERC20Burnable is Context, ERC20 {
707     /**
708      * @dev Destroys `amount` tokens from the caller.
709      *
710      * See {ERC20-_burn}.
711      */
712     function burn(uint256 amount) public virtual {
713         _burn(_msgSender(), amount);
714     }
715 
716     /**
717      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
718      * allowance.
719      *
720      * See {ERC20-_burn} and {ERC20-allowance}.
721      *
722      * Requirements:
723      *
724      * - the caller must have allowance for ``accounts``'s tokens of at least
725      * `amount`.
726      */
727     function burnFrom(address account, uint256 amount) public virtual {
728         uint256 currentAllowance = allowance(account, _msgSender());
729         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
730         _approve(account, _msgSender(), currentAllowance - amount);
731         _burn(account, amount);
732     }
733 }
734 
735 
736 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.0.0
737 
738 
739 
740 
741 
742 /**
743  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
744  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
745  *
746  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
747  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
748  * need to send a transaction, and thus is not required to hold Ether at all.
749  */
750 interface IERC20Permit {
751     /**
752      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
753      * given `owner`'s signed approval.
754      *
755      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
756      * ordering also apply here.
757      *
758      * Emits an {Approval} event.
759      *
760      * Requirements:
761      *
762      * - `spender` cannot be the zero address.
763      * - `deadline` must be a timestamp in the future.
764      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
765      * over the EIP712-formatted function arguments.
766      * - the signature must use ``owner``'s current nonce (see {nonces}).
767      *
768      * For more information on the signature format, see the
769      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
770      * section].
771      */
772     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
773 
774     /**
775      * @dev Returns the current nonce for `owner`. This value must be
776      * included whenever a signature is generated for {permit}.
777      *
778      * Every successful call to {permit} increases ``owner``'s nonce by one. This
779      * prevents a signature from being used multiple times.
780      */
781     function nonces(address owner) external view returns (uint256);
782 
783     /**
784      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
785      */
786     // solhint-disable-next-line func-name-mixedcase
787     function DOMAIN_SEPARATOR() external view returns (bytes32);
788 }
789 
790 
791 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.0.0
792 
793 
794 
795 
796 
797 /**
798  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
799  *
800  * These functions can be used to verify that a message was signed by the holder
801  * of the private keys of a given address.
802  */
803 library ECDSA {
804     /**
805      * @dev Returns the address that signed a hashed message (`hash`) with
806      * `signature`. This address can then be used for verification purposes.
807      *
808      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
809      * this function rejects them by requiring the `s` value to be in the lower
810      * half order, and the `v` value to be either 27 or 28.
811      *
812      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
813      * verification to be secure: it is possible to craft signatures that
814      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
815      * this is by receiving a hash of the original message (which may otherwise
816      * be too long), and then calling {toEthSignedMessageHash} on it.
817      */
818     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
819         // Check the signature length
820         if (signature.length != 65) {
821             revert("ECDSA: invalid signature length");
822         }
823 
824         // Divide the signature in r, s and v variables
825         bytes32 r;
826         bytes32 s;
827         uint8 v;
828 
829         // ecrecover takes the signature parameters, and the only way to get them
830         // currently is to use assembly.
831         // solhint-disable-next-line no-inline-assembly
832         assembly {
833             r := mload(add(signature, 0x20))
834             s := mload(add(signature, 0x40))
835             v := byte(0, mload(add(signature, 0x60)))
836         }
837 
838         return recover(hash, v, r, s);
839     }
840 
841     /**
842      * @dev Overload of {ECDSA-recover} that receives the `v`,
843      * `r` and `s` signature fields separately.
844      */
845     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
846         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
847         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
848         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
849         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
850         //
851         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
852         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
853         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
854         // these malleable signatures as well.
855         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
856         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
857 
858         // If the signature is valid (and not malleable), return the signer address
859         address signer = ecrecover(hash, v, r, s);
860         require(signer != address(0), "ECDSA: invalid signature");
861 
862         return signer;
863     }
864 
865     /**
866      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
867      * produces hash corresponding to the one signed with the
868      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
869      * JSON-RPC method as part of EIP-191.
870      *
871      * See {recover}.
872      */
873     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
874         // 32 is the length in bytes of hash,
875         // enforced by the type signature above
876         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
877     }
878 
879     /**
880      * @dev Returns an Ethereum Signed Typed Data, created from a
881      * `domainSeparator` and a `structHash`. This produces hash corresponding
882      * to the one signed with the
883      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
884      * JSON-RPC method as part of EIP-712.
885      *
886      * See {recover}.
887      */
888     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
889         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
890     }
891 }
892 
893 
894 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.0.0
895 
896 
897 
898 
899 
900 /**
901  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
902  *
903  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
904  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
905  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
906  *
907  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
908  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
909  * ({_hashTypedDataV4}).
910  *
911  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
912  * the chain id to protect against replay attacks on an eventual fork of the chain.
913  *
914  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
915  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
916  *
917  * _Available since v3.4._
918  */
919 abstract contract EIP712 {
920     /* solhint-disable var-name-mixedcase */
921     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
922     // invalidate the cached domain separator if the chain id changes.
923     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
924     uint256 private immutable _CACHED_CHAIN_ID;
925 
926     bytes32 private immutable _HASHED_NAME;
927     bytes32 private immutable _HASHED_VERSION;
928     bytes32 private immutable _TYPE_HASH;
929     /* solhint-enable var-name-mixedcase */
930 
931     /**
932      * @dev Initializes the domain separator and parameter caches.
933      *
934      * The meaning of `name` and `version` is specified in
935      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
936      *
937      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
938      * - `version`: the current major version of the signing domain.
939      *
940      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
941      * contract upgrade].
942      */
943     constructor(string memory name, string memory version) {
944         bytes32 hashedName = keccak256(bytes(name));
945         bytes32 hashedVersion = keccak256(bytes(version));
946         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
947         _HASHED_NAME = hashedName;
948         _HASHED_VERSION = hashedVersion;
949         _CACHED_CHAIN_ID = block.chainid;
950         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
951         _TYPE_HASH = typeHash;
952     }
953 
954     /**
955      * @dev Returns the domain separator for the current chain.
956      */
957     function _domainSeparatorV4() internal view returns (bytes32) {
958         if (block.chainid == _CACHED_CHAIN_ID) {
959             return _CACHED_DOMAIN_SEPARATOR;
960         } else {
961             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
962         }
963     }
964 
965     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
966         return keccak256(
967             abi.encode(
968                 typeHash,
969                 name,
970                 version,
971                 block.chainid,
972                 address(this)
973             )
974         );
975     }
976 
977     /**
978      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
979      * function returns the hash of the fully encoded EIP712 message for this domain.
980      *
981      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
982      *
983      * ```solidity
984      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
985      *     keccak256("Mail(address to,string contents)"),
986      *     mailTo,
987      *     keccak256(bytes(mailContents))
988      * )));
989      * address signer = ECDSA.recover(digest, signature);
990      * ```
991      */
992     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
993         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
994     }
995 }
996 
997 
998 // File @openzeppelin/contracts/utils/Counters.sol@v4.0.0
999 
1000 
1001 
1002 
1003 
1004 /**
1005  * @title Counters
1006  * @author Matt Condon (@shrugs)
1007  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1008  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1009  *
1010  * Include with `using Counters for Counters.Counter;`
1011  */
1012 library Counters {
1013     struct Counter {
1014         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1015         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1016         // this feature: see https://github.com/ethereum/solidity/issues/4637
1017         uint256 _value; // default: 0
1018     }
1019 
1020     function current(Counter storage counter) internal view returns (uint256) {
1021         return counter._value;
1022     }
1023 
1024     function increment(Counter storage counter) internal {
1025         unchecked {
1026             counter._value += 1;
1027         }
1028     }
1029 
1030     function decrement(Counter storage counter) internal {
1031         uint256 value = counter._value;
1032         require(value > 0, "Counter: decrement overflow");
1033         unchecked {
1034             counter._value = value - 1;
1035         }
1036     }
1037 }
1038 
1039 
1040 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.0.0
1041 
1042 
1043 
1044 
1045 
1046 
1047 
1048 
1049 
1050 /**
1051  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1052  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1053  *
1054  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1055  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1056  * need to send a transaction, and thus is not required to hold Ether at all.
1057  *
1058  * _Available since v3.4._
1059  */
1060 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1061     using Counters for Counters.Counter;
1062 
1063     mapping (address => Counters.Counter) private _nonces;
1064 
1065     // solhint-disable-next-line var-name-mixedcase
1066     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1067 
1068     /**
1069      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1070      *
1071      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1072      */
1073     constructor(string memory name) EIP712(name, "1") {
1074     }
1075 
1076     /**
1077      * @dev See {IERC20Permit-permit}.
1078      */
1079     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1080         // solhint-disable-next-line not-rely-on-time
1081         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1082 
1083         bytes32 structHash = keccak256(
1084             abi.encode(
1085                 _PERMIT_TYPEHASH,
1086                 owner,
1087                 spender,
1088                 value,
1089                 _nonces[owner].current(),
1090                 deadline
1091             )
1092         );
1093 
1094         bytes32 hash = _hashTypedDataV4(structHash);
1095 
1096         address signer = ECDSA.recover(hash, v, r, s);
1097         require(signer == owner, "ERC20Permit: invalid signature");
1098 
1099         _nonces[owner].increment();
1100         _approve(owner, spender, value);
1101     }
1102 
1103     /**
1104      * @dev See {IERC20Permit-nonces}.
1105      */
1106     function nonces(address owner) public view override returns (uint256) {
1107         return _nonces[owner].current();
1108     }
1109 
1110     /**
1111      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1112      */
1113     // solhint-disable-next-line func-name-mixedcase
1114     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1115         return _domainSeparatorV4();
1116     }
1117 }
1118 
1119 
1120 // File contracts/IERC677.sol
1121 
1122 
1123 
1124 
1125 // adapted from LINK token https://etherscan.io/address/0x514910771af9ca656af840dff83e8264ecf986ca#code
1126 // implements https://github.com/ethereum/EIPs/issues/677
1127 interface IERC677 is IERC20 {
1128     function transferAndCall(
1129         address to,
1130         uint value,
1131         bytes calldata data
1132     ) external returns (bool success);
1133 
1134     event Transfer(
1135         address indexed from,
1136         address indexed to,
1137         uint value,
1138         bytes data
1139     );
1140 }
1141 
1142 
1143 // File contracts/IERC677Receiver.sol
1144 
1145 
1146 
1147 
1148 interface IERC677Receiver {
1149     function onTokenTransfer(
1150         address _sender,
1151         uint256 _value,
1152         bytes calldata _data
1153     ) external;
1154 }
1155 
1156 
1157 // File contracts/DATAv2.sol
1158 
1159 
1160 
1161 
1162 
1163 
1164 
1165 
1166 contract DATAv2 is ERC20Permit, ERC20Burnable, AccessControl, IERC677 {
1167     string private _name = "Streamr";
1168     string private _symbol = "DATA";
1169 
1170     event UpdatedTokenInformation(string newName, string newSymbol);
1171 
1172     // ------------------------------------------------------------------------
1173     // adapted from @openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol
1174     bytes32 constant public MINTER_ROLE = keccak256("MINTER_ROLE");
1175 
1176     constructor() ERC20("", "") ERC20Permit(_name) {
1177         // make contract deployer the role admin that can later grant the minter role
1178         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1179     }
1180 
1181     function isMinter(
1182         address minter
1183     ) public view returns (bool) {
1184         return hasRole(MINTER_ROLE, minter);
1185     }
1186 
1187     /**
1188      * @dev Creates `amount` new tokens for `to`.
1189      *
1190      * See {ERC20-_mint}.
1191      *
1192      * Requirements:
1193      *
1194      * - the caller must have the `MINTER_ROLE`.
1195      */
1196     function mint(
1197         address to,
1198         uint256 amount
1199     ) public {
1200         require(isMinter(_msgSender()), "Transaction signer is not a minter");
1201         _mint(to, amount);
1202     }
1203 
1204     // ------------------------------------------------------------------------
1205     // adapted from LINK token, see https://etherscan.io/address/0x514910771af9ca656af840dff83e8264ecf986ca#code
1206     // implements https://github.com/ethereum/EIPs/issues/677
1207     /**
1208      * @dev transfer token to a contract address with additional data if the recipient is a contact.
1209      * @param _to The address to transfer to.
1210      * @param _value The amount to be transferred.
1211      * @param _data The extra data to be passed to the receiving contract.
1212      */
1213     function transferAndCall(
1214         address _to,
1215         uint256 _value,
1216         bytes calldata _data
1217     ) public override returns (bool success) {
1218         super.transfer(_to, _value);
1219         emit Transfer(_msgSender(), _to, _value, _data);
1220 
1221         uint256 recipientCodeSize;
1222         assembly {
1223             recipientCodeSize := extcodesize(_to)
1224         }
1225         if (recipientCodeSize > 0) {
1226             IERC677Receiver receiver = IERC677Receiver(_to);
1227             receiver.onTokenTransfer(_msgSender(), _value, _data);
1228         }
1229         return true;
1230     }
1231 
1232     // ------------------------------------------------------------------------
1233     // allow admin to change the token name and symbol
1234 
1235     function setTokenInformation(string calldata newName, string calldata newSymbol) public {
1236         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Transaction signer is not an admin");
1237         _name = newName;
1238         _symbol = newSymbol;
1239         emit UpdatedTokenInformation(_name, _symbol);
1240     }
1241 
1242     /**
1243      * @dev Returns the name of the token.
1244      */
1245     function name() public view override returns (string memory) {
1246         return _name;
1247     }
1248 
1249     /**
1250      * @dev Returns the symbol of the token, usually a shorter version of the name.
1251      */
1252     function symbol() public view override returns (string memory) {
1253         return _symbol;
1254     }
1255 }