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
83 pragma solidity ^0.8.0;
84 
85 /*
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
107 
108 pragma solidity ^0.8.0;
109 
110 
111 
112 /**
113  * @dev Implementation of the {IERC20} interface.
114  *
115  * This implementation is agnostic to the way tokens are created. This means
116  * that a supply mechanism has to be added in a derived contract using {_mint}.
117  * For a generic mechanism see {ERC20PresetMinterPauser}.
118  *
119  * TIP: For a detailed writeup see our guide
120  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
121  * to implement supply mechanisms].
122  *
123  * We have followed general OpenZeppelin guidelines: functions revert instead
124  * of returning `false` on failure. This behavior is nonetheless conventional
125  * and does not conflict with the expectations of ERC20 applications.
126  *
127  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
128  * This allows applications to reconstruct the allowance for all accounts just
129  * by listening to said events. Other implementations of the EIP may not emit
130  * these events, as it isn't required by the specification.
131  *
132  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
133  * functions have been added to mitigate the well-known issues around setting
134  * allowances. See {IERC20-approve}.
135  */
136 contract ERC20 is Context, IERC20 {
137     mapping (address => uint256) private _balances;
138 
139     mapping (address => mapping (address => uint256)) private _allowances;
140 
141     uint256 private _totalSupply;
142 
143     string private _name;
144     string private _symbol;
145 
146     /**
147      * @dev Sets the values for {name} and {symbol}.
148      *
149      * The defaut value of {decimals} is 18. To select a different value for
150      * {decimals} you should overload it.
151      *
152      * All three of these values are immutable: they can only be set once during
153      * construction.
154      */
155     constructor (string memory name_, string memory symbol_) {
156         _name = name_;
157         _symbol = symbol_;
158     }
159 
160     /**
161      * @dev Returns the name of the token.
162      */
163     function name() public view virtual returns (string memory) {
164         return _name;
165     }
166 
167     /**
168      * @dev Returns the symbol of the token, usually a shorter version of the
169      * name.
170      */
171     function symbol() public view virtual returns (string memory) {
172         return _symbol;
173     }
174 
175     /**
176      * @dev Returns the number of decimals used to get its user representation.
177      * For example, if `decimals` equals `2`, a balance of `505` tokens should
178      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
179      *
180      * Tokens usually opt for a value of 18, imitating the relationship between
181      * Ether and Wei. This is the value {ERC20} uses, unless this function is
182      * overloaded;
183      *
184      * NOTE: This information is only used for _display_ purposes: it in
185      * no way affects any of the arithmetic of the contract, including
186      * {IERC20-balanceOf} and {IERC20-transfer}.
187      */
188     function decimals() public view virtual returns (uint8) {
189         return 18;
190     }
191 
192     /**
193      * @dev See {IERC20-totalSupply}.
194      */
195     function totalSupply() public view virtual override returns (uint256) {
196         return _totalSupply;
197     }
198 
199     /**
200      * @dev See {IERC20-balanceOf}.
201      */
202     function balanceOf(address account) public view virtual override returns (uint256) {
203         return _balances[account];
204     }
205 
206     /**
207      * @dev See {IERC20-transfer}.
208      *
209      * Requirements:
210      *
211      * - `recipient` cannot be the zero address.
212      * - the caller must have a balance of at least `amount`.
213      */
214     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     /**
220      * @dev See {IERC20-allowance}.
221      */
222     function allowance(address owner, address spender) public view virtual override returns (uint256) {
223         return _allowances[owner][spender];
224     }
225 
226     /**
227      * @dev See {IERC20-approve}.
228      *
229      * Requirements:
230      *
231      * - `spender` cannot be the zero address.
232      */
233     function approve(address spender, uint256 amount) public virtual override returns (bool) {
234         _approve(_msgSender(), spender, amount);
235         return true;
236     }
237 
238     /**
239      * @dev See {IERC20-transferFrom}.
240      *
241      * Emits an {Approval} event indicating the updated allowance. This is not
242      * required by the EIP. See the note at the beginning of {ERC20}.
243      *
244      * Requirements:
245      *
246      * - `sender` and `recipient` cannot be the zero address.
247      * - `sender` must have a balance of at least `amount`.
248      * - the caller must have allowance for ``sender``'s tokens of at least
249      * `amount`.
250      */
251     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
252         _transfer(sender, recipient, amount);
253 
254         uint256 currentAllowance = _allowances[sender][_msgSender()];
255         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
256         _approve(sender, _msgSender(), currentAllowance - amount);
257 
258         return true;
259     }
260 
261     /**
262      * @dev Atomically increases the allowance granted to `spender` by the caller.
263      *
264      * This is an alternative to {approve} that can be used as a mitigation for
265      * problems described in {IERC20-approve}.
266      *
267      * Emits an {Approval} event indicating the updated allowance.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
274         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
275         return true;
276     }
277 
278     /**
279      * @dev Atomically decreases the allowance granted to `spender` by the caller.
280      *
281      * This is an alternative to {approve} that can be used as a mitigation for
282      * problems described in {IERC20-approve}.
283      *
284      * Emits an {Approval} event indicating the updated allowance.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      * - `spender` must have allowance for the caller of at least
290      * `subtractedValue`.
291      */
292     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
293         uint256 currentAllowance = _allowances[_msgSender()][spender];
294         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
295         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
296 
297         return true;
298     }
299 
300     /**
301      * @dev Moves tokens `amount` from `sender` to `recipient`.
302      *
303      * This is internal function is equivalent to {transfer}, and can be used to
304      * e.g. implement automatic token fees, slashing mechanisms, etc.
305      *
306      * Emits a {Transfer} event.
307      *
308      * Requirements:
309      *
310      * - `sender` cannot be the zero address.
311      * - `recipient` cannot be the zero address.
312      * - `sender` must have a balance of at least `amount`.
313      */
314     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
315         require(sender != address(0), "ERC20: transfer from the zero address");
316         require(recipient != address(0), "ERC20: transfer to the zero address");
317 
318         _beforeTokenTransfer(sender, recipient, amount);
319 
320         uint256 senderBalance = _balances[sender];
321         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
322         _balances[sender] = senderBalance - amount;
323         _balances[recipient] += amount;
324 
325         emit Transfer(sender, recipient, amount);
326     }
327 
328     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
329      * the total supply.
330      *
331      * Emits a {Transfer} event with `from` set to the zero address.
332      *
333      * Requirements:
334      *
335      * - `to` cannot be the zero address.
336      */
337     function _mint(address account, uint256 amount) internal virtual {
338         require(account != address(0), "ERC20: mint to the zero address");
339 
340         _beforeTokenTransfer(address(0), account, amount);
341 
342         _totalSupply += amount;
343         _balances[account] += amount;
344         emit Transfer(address(0), account, amount);
345     }
346 
347     /**
348      * @dev Destroys `amount` tokens from `account`, reducing the
349      * total supply.
350      *
351      * Emits a {Transfer} event with `to` set to the zero address.
352      *
353      * Requirements:
354      *
355      * - `account` cannot be the zero address.
356      * - `account` must have at least `amount` tokens.
357      */
358     function _burn(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: burn from the zero address");
360 
361         _beforeTokenTransfer(account, address(0), amount);
362 
363         uint256 accountBalance = _balances[account];
364         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
365         _balances[account] = accountBalance - amount;
366         _totalSupply -= amount;
367 
368         emit Transfer(account, address(0), amount);
369     }
370 
371     /**
372      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
373      *
374      * This internal function is equivalent to `approve`, and can be used to
375      * e.g. set automatic allowances for certain subsystems, etc.
376      *
377      * Emits an {Approval} event.
378      *
379      * Requirements:
380      *
381      * - `owner` cannot be the zero address.
382      * - `spender` cannot be the zero address.
383      */
384     function _approve(address owner, address spender, uint256 amount) internal virtual {
385         require(owner != address(0), "ERC20: approve from the zero address");
386         require(spender != address(0), "ERC20: approve to the zero address");
387 
388         _allowances[owner][spender] = amount;
389         emit Approval(owner, spender, amount);
390     }
391 
392     /**
393      * @dev Hook that is called before any transfer of tokens. This includes
394      * minting and burning.
395      *
396      * Calling conditions:
397      *
398      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
399      * will be to transferred to `to`.
400      * - when `from` is zero, `amount` tokens will be minted for `to`.
401      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
402      * - `from` and `to` are never both zero.
403      *
404      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
405      */
406     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
416  */
417 abstract contract ERC20Capped is ERC20 {
418     uint256 immutable private _cap;
419 
420     /**
421      * @dev Sets the value of the `cap`. This value is immutable, it can only be
422      * set once during construction.
423      */
424     constructor (uint256 cap_) {
425         require(cap_ > 0, "ERC20Capped: cap is 0");
426         _cap = cap_;
427     }
428 
429     /**
430      * @dev Returns the cap on the token's total supply.
431      */
432     function cap() public view virtual returns (uint256) {
433         return _cap;
434     }
435 
436     /**
437      * @dev See {ERC20-_mint}.
438      */
439     function _mint(address account, uint256 amount) internal virtual override {
440         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
441         super._mint(account, amount);
442     }
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
446 
447 pragma solidity ^0.8.0;
448 
449 
450 
451 /**
452  * @dev Extension of {ERC20} that allows token holders to destroy both their own
453  * tokens and those that they have an allowance for, in a way that can be
454  * recognized off-chain (via event analysis).
455  */
456 abstract contract ERC20Burnable is Context, ERC20 {
457     /**
458      * @dev Destroys `amount` tokens from the caller.
459      *
460      * See {ERC20-_burn}.
461      */
462     function burn(uint256 amount) public virtual {
463         _burn(_msgSender(), amount);
464     }
465 
466     /**
467      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
468      * allowance.
469      *
470      * See {ERC20-_burn} and {ERC20-allowance}.
471      *
472      * Requirements:
473      *
474      * - the caller must have allowance for ``accounts``'s tokens of at least
475      * `amount`.
476      */
477     function burnFrom(address account, uint256 amount) public virtual {
478         uint256 currentAllowance = allowance(account, _msgSender());
479         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
480         _approve(account, _msgSender(), currentAllowance - amount);
481         _burn(account, amount);
482     }
483 }
484 
485 // File: @openzeppelin/contracts/security/Pausable.sol
486 
487 pragma solidity ^0.8.0;
488 
489 
490 /**
491  * @dev Contract module which allows children to implement an emergency stop
492  * mechanism that can be triggered by an authorized account.
493  *
494  * This module is used through inheritance. It will make available the
495  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
496  * the functions of your contract. Note that they will not be pausable by
497  * simply including this module, only once the modifiers are put in place.
498  */
499 abstract contract Pausable is Context {
500     /**
501      * @dev Emitted when the pause is triggered by `account`.
502      */
503     event Paused(address account);
504 
505     /**
506      * @dev Emitted when the pause is lifted by `account`.
507      */
508     event Unpaused(address account);
509 
510     bool private _paused;
511 
512     /**
513      * @dev Initializes the contract in unpaused state.
514      */
515     constructor () {
516         _paused = false;
517     }
518 
519     /**
520      * @dev Returns true if the contract is paused, and false otherwise.
521      */
522     function paused() public view virtual returns (bool) {
523         return _paused;
524     }
525 
526     /**
527      * @dev Modifier to make a function callable only when the contract is not paused.
528      *
529      * Requirements:
530      *
531      * - The contract must not be paused.
532      */
533     modifier whenNotPaused() {
534         require(!paused(), "Pausable: paused");
535         _;
536     }
537 
538     /**
539      * @dev Modifier to make a function callable only when the contract is paused.
540      *
541      * Requirements:
542      *
543      * - The contract must be paused.
544      */
545     modifier whenPaused() {
546         require(paused(), "Pausable: not paused");
547         _;
548     }
549 
550     /**
551      * @dev Triggers stopped state.
552      *
553      * Requirements:
554      *
555      * - The contract must not be paused.
556      */
557     function _pause() internal virtual whenNotPaused {
558         _paused = true;
559         emit Paused(_msgSender());
560     }
561 
562     /**
563      * @dev Returns to normal state.
564      *
565      * Requirements:
566      *
567      * - The contract must be paused.
568      */
569     function _unpause() internal virtual whenPaused {
570         _paused = false;
571         emit Unpaused(_msgSender());
572     }
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 /**
582  * @dev ERC20 token with pausable token transfers, minting and burning.
583  *
584  * Useful for scenarios such as preventing trades until the end of an evaluation
585  * period, or having an emergency switch for freezing all token transfers in the
586  * event of a large bug.
587  */
588 abstract contract ERC20Pausable is ERC20, Pausable {
589     /**
590      * @dev See {ERC20-_beforeTokenTransfer}.
591      *
592      * Requirements:
593      *
594      * - the contract must not be paused.
595      */
596     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
597         super._beforeTokenTransfer(from, to, amount);
598 
599         require(!paused(), "ERC20Pausable: token transfer while paused");
600     }
601 }
602 
603 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Interface of the ERC165 standard, as defined in the
609  * https://eips.ethereum.org/EIPS/eip-165[EIP].
610  *
611  * Implementers can declare support of contract interfaces, which can then be
612  * queried by others ({ERC165Checker}).
613  *
614  * For an implementation, see {ERC165}.
615  */
616 interface IERC165 {
617     /**
618      * @dev Returns true if this contract implements the interface defined by
619      * `interfaceId`. See the corresponding
620      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
621      * to learn more about how these ids are created.
622      *
623      * This function call must use less than 30 000 gas.
624      */
625     function supportsInterface(bytes4 interfaceId) external view returns (bool);
626 }
627 
628 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
629 
630 pragma solidity ^0.8.0;
631 
632 
633 /**
634  * @dev Implementation of the {IERC165} interface.
635  *
636  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
637  * for the additional interface id that will be supported. For example:
638  *
639  * ```solidity
640  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
641  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
642  * }
643  * ```
644  *
645  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
646  */
647 abstract contract ERC165 is IERC165 {
648     /**
649      * @dev See {IERC165-supportsInterface}.
650      */
651     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
652         return interfaceId == type(IERC165).interfaceId;
653     }
654 }
655 
656 // File: @openzeppelin/contracts/access/AccessControl.sol
657 
658 pragma solidity ^0.8.0;
659 
660 
661 
662 /**
663  * @dev External interface of AccessControl declared to support ERC165 detection.
664  */
665 interface IAccessControl {
666     function hasRole(bytes32 role, address account) external view returns (bool);
667     function getRoleAdmin(bytes32 role) external view returns (bytes32);
668     function grantRole(bytes32 role, address account) external;
669     function revokeRole(bytes32 role, address account) external;
670     function renounceRole(bytes32 role, address account) external;
671 }
672 
673 /**
674  * @dev Contract module that allows children to implement role-based access
675  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
676  * members except through off-chain means by accessing the contract event logs. Some
677  * applications may benefit from on-chain enumerability, for those cases see
678  * {AccessControlEnumerable}.
679  *
680  * Roles are referred to by their `bytes32` identifier. These should be exposed
681  * in the external API and be unique. The best way to achieve this is by
682  * using `public constant` hash digests:
683  *
684  * ```
685  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
686  * ```
687  *
688  * Roles can be used to represent a set of permissions. To restrict access to a
689  * function call, use {hasRole}:
690  *
691  * ```
692  * function foo() public {
693  *     require(hasRole(MY_ROLE, msg.sender));
694  *     ...
695  * }
696  * ```
697  *
698  * Roles can be granted and revoked dynamically via the {grantRole} and
699  * {revokeRole} functions. Each role has an associated admin role, and only
700  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
701  *
702  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
703  * that only accounts with this role will be able to grant or revoke other
704  * roles. More complex role relationships can be created by using
705  * {_setRoleAdmin}.
706  *
707  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
708  * grant and revoke this role. Extra precautions should be taken to secure
709  * accounts that have been granted it.
710  */
711 abstract contract AccessControl is Context, IAccessControl, ERC165 {
712     struct RoleData {
713         mapping (address => bool) members;
714         bytes32 adminRole;
715     }
716 
717     mapping (bytes32 => RoleData) private _roles;
718 
719     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
720 
721     /**
722      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
723      *
724      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
725      * {RoleAdminChanged} not being emitted signaling this.
726      *
727      * _Available since v3.1._
728      */
729     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
730 
731     /**
732      * @dev Emitted when `account` is granted `role`.
733      *
734      * `sender` is the account that originated the contract call, an admin role
735      * bearer except when using {_setupRole}.
736      */
737     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
738 
739     /**
740      * @dev Emitted when `account` is revoked `role`.
741      *
742      * `sender` is the account that originated the contract call:
743      *   - if using `revokeRole`, it is the admin role bearer
744      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
745      */
746     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
747 
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752         return interfaceId == type(IAccessControl).interfaceId
753             || super.supportsInterface(interfaceId);
754     }
755 
756     /**
757      * @dev Returns `true` if `account` has been granted `role`.
758      */
759     function hasRole(bytes32 role, address account) public view override returns (bool) {
760         return _roles[role].members[account];
761     }
762 
763     /**
764      * @dev Returns the admin role that controls `role`. See {grantRole} and
765      * {revokeRole}.
766      *
767      * To change a role's admin, use {_setRoleAdmin}.
768      */
769     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
770         return _roles[role].adminRole;
771     }
772 
773     /**
774      * @dev Grants `role` to `account`.
775      *
776      * If `account` had not been already granted `role`, emits a {RoleGranted}
777      * event.
778      *
779      * Requirements:
780      *
781      * - the caller must have ``role``'s admin role.
782      */
783     function grantRole(bytes32 role, address account) public virtual override {
784         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
785 
786         _grantRole(role, account);
787     }
788 
789     /**
790      * @dev Revokes `role` from `account`.
791      *
792      * If `account` had been granted `role`, emits a {RoleRevoked} event.
793      *
794      * Requirements:
795      *
796      * - the caller must have ``role``'s admin role.
797      */
798     function revokeRole(bytes32 role, address account) public virtual override {
799         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
800 
801         _revokeRole(role, account);
802     }
803 
804     /**
805      * @dev Revokes `role` from the calling account.
806      *
807      * Roles are often managed via {grantRole} and {revokeRole}: this function's
808      * purpose is to provide a mechanism for accounts to lose their privileges
809      * if they are compromised (such as when a trusted device is misplaced).
810      *
811      * If the calling account had been granted `role`, emits a {RoleRevoked}
812      * event.
813      *
814      * Requirements:
815      *
816      * - the caller must be `account`.
817      */
818     function renounceRole(bytes32 role, address account) public virtual override {
819         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
820 
821         _revokeRole(role, account);
822     }
823 
824     /**
825      * @dev Grants `role` to `account`.
826      *
827      * If `account` had not been already granted `role`, emits a {RoleGranted}
828      * event. Note that unlike {grantRole}, this function doesn't perform any
829      * checks on the calling account.
830      *
831      * [WARNING]
832      * ====
833      * This function should only be called from the constructor when setting
834      * up the initial roles for the system.
835      *
836      * Using this function in any other way is effectively circumventing the admin
837      * system imposed by {AccessControl}.
838      * ====
839      */
840     function _setupRole(bytes32 role, address account) internal virtual {
841         _grantRole(role, account);
842     }
843 
844     /**
845      * @dev Sets `adminRole` as ``role``'s admin role.
846      *
847      * Emits a {RoleAdminChanged} event.
848      */
849     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
850         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
851         _roles[role].adminRole = adminRole;
852     }
853 
854     function _grantRole(bytes32 role, address account) private {
855         if (!hasRole(role, account)) {
856             _roles[role].members[account] = true;
857             emit RoleGranted(role, account, _msgSender());
858         }
859     }
860 
861     function _revokeRole(bytes32 role, address account) private {
862         if (hasRole(role, account)) {
863             _roles[role].members[account] = false;
864             emit RoleRevoked(role, account, _msgSender());
865         }
866     }
867 }
868 
869 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
870 
871 pragma solidity ^0.8.0;
872 
873 /**
874  * @dev Library for managing
875  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
876  * types.
877  *
878  * Sets have the following properties:
879  *
880  * - Elements are added, removed, and checked for existence in constant time
881  * (O(1)).
882  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
883  *
884  * ```
885  * contract Example {
886  *     // Add the library methods
887  *     using EnumerableSet for EnumerableSet.AddressSet;
888  *
889  *     // Declare a set state variable
890  *     EnumerableSet.AddressSet private mySet;
891  * }
892  * ```
893  *
894  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
895  * and `uint256` (`UintSet`) are supported.
896  */
897 library EnumerableSet {
898     // To implement this library for multiple types with as little code
899     // repetition as possible, we write it in terms of a generic Set type with
900     // bytes32 values.
901     // The Set implementation uses private functions, and user-facing
902     // implementations (such as AddressSet) are just wrappers around the
903     // underlying Set.
904     // This means that we can only create new EnumerableSets for types that fit
905     // in bytes32.
906 
907     struct Set {
908         // Storage of set values
909         bytes32[] _values;
910 
911         // Position of the value in the `values` array, plus 1 because index 0
912         // means a value is not in the set.
913         mapping (bytes32 => uint256) _indexes;
914     }
915 
916     /**
917      * @dev Add a value to a set. O(1).
918      *
919      * Returns true if the value was added to the set, that is if it was not
920      * already present.
921      */
922     function _add(Set storage set, bytes32 value) private returns (bool) {
923         if (!_contains(set, value)) {
924             set._values.push(value);
925             // The value is stored at length-1, but we add 1 to all indexes
926             // and use 0 as a sentinel value
927             set._indexes[value] = set._values.length;
928             return true;
929         } else {
930             return false;
931         }
932     }
933 
934     /**
935      * @dev Removes a value from a set. O(1).
936      *
937      * Returns true if the value was removed from the set, that is if it was
938      * present.
939      */
940     function _remove(Set storage set, bytes32 value) private returns (bool) {
941         // We read and store the value's index to prevent multiple reads from the same storage slot
942         uint256 valueIndex = set._indexes[value];
943 
944         if (valueIndex != 0) { // Equivalent to contains(set, value)
945             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
946             // the array, and then remove the last element (sometimes called as 'swap and pop').
947             // This modifies the order of the array, as noted in {at}.
948 
949             uint256 toDeleteIndex = valueIndex - 1;
950             uint256 lastIndex = set._values.length - 1;
951 
952             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
953             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
954 
955             bytes32 lastvalue = set._values[lastIndex];
956 
957             // Move the last value to the index where the value to delete is
958             set._values[toDeleteIndex] = lastvalue;
959             // Update the index for the moved value
960             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
961 
962             // Delete the slot where the moved value was stored
963             set._values.pop();
964 
965             // Delete the index for the deleted slot
966             delete set._indexes[value];
967 
968             return true;
969         } else {
970             return false;
971         }
972     }
973 
974     /**
975      * @dev Returns true if the value is in the set. O(1).
976      */
977     function _contains(Set storage set, bytes32 value) private view returns (bool) {
978         return set._indexes[value] != 0;
979     }
980 
981     /**
982      * @dev Returns the number of values on the set. O(1).
983      */
984     function _length(Set storage set) private view returns (uint256) {
985         return set._values.length;
986     }
987 
988    /**
989     * @dev Returns the value stored at position `index` in the set. O(1).
990     *
991     * Note that there are no guarantees on the ordering of values inside the
992     * array, and it may change when more values are added or removed.
993     *
994     * Requirements:
995     *
996     * - `index` must be strictly less than {length}.
997     */
998     function _at(Set storage set, uint256 index) private view returns (bytes32) {
999         require(set._values.length > index, "EnumerableSet: index out of bounds");
1000         return set._values[index];
1001     }
1002 
1003     // Bytes32Set
1004 
1005     struct Bytes32Set {
1006         Set _inner;
1007     }
1008 
1009     /**
1010      * @dev Add a value to a set. O(1).
1011      *
1012      * Returns true if the value was added to the set, that is if it was not
1013      * already present.
1014      */
1015     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1016         return _add(set._inner, value);
1017     }
1018 
1019     /**
1020      * @dev Removes a value from a set. O(1).
1021      *
1022      * Returns true if the value was removed from the set, that is if it was
1023      * present.
1024      */
1025     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1026         return _remove(set._inner, value);
1027     }
1028 
1029     /**
1030      * @dev Returns true if the value is in the set. O(1).
1031      */
1032     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1033         return _contains(set._inner, value);
1034     }
1035 
1036     /**
1037      * @dev Returns the number of values in the set. O(1).
1038      */
1039     function length(Bytes32Set storage set) internal view returns (uint256) {
1040         return _length(set._inner);
1041     }
1042 
1043    /**
1044     * @dev Returns the value stored at position `index` in the set. O(1).
1045     *
1046     * Note that there are no guarantees on the ordering of values inside the
1047     * array, and it may change when more values are added or removed.
1048     *
1049     * Requirements:
1050     *
1051     * - `index` must be strictly less than {length}.
1052     */
1053     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1054         return _at(set._inner, index);
1055     }
1056 
1057     // AddressSet
1058 
1059     struct AddressSet {
1060         Set _inner;
1061     }
1062 
1063     /**
1064      * @dev Add a value to a set. O(1).
1065      *
1066      * Returns true if the value was added to the set, that is if it was not
1067      * already present.
1068      */
1069     function add(AddressSet storage set, address value) internal returns (bool) {
1070         return _add(set._inner, bytes32(uint256(uint160(value))));
1071     }
1072 
1073     /**
1074      * @dev Removes a value from a set. O(1).
1075      *
1076      * Returns true if the value was removed from the set, that is if it was
1077      * present.
1078      */
1079     function remove(AddressSet storage set, address value) internal returns (bool) {
1080         return _remove(set._inner, bytes32(uint256(uint160(value))));
1081     }
1082 
1083     /**
1084      * @dev Returns true if the value is in the set. O(1).
1085      */
1086     function contains(AddressSet storage set, address value) internal view returns (bool) {
1087         return _contains(set._inner, bytes32(uint256(uint160(value))));
1088     }
1089 
1090     /**
1091      * @dev Returns the number of values in the set. O(1).
1092      */
1093     function length(AddressSet storage set) internal view returns (uint256) {
1094         return _length(set._inner);
1095     }
1096 
1097    /**
1098     * @dev Returns the value stored at position `index` in the set. O(1).
1099     *
1100     * Note that there are no guarantees on the ordering of values inside the
1101     * array, and it may change when more values are added or removed.
1102     *
1103     * Requirements:
1104     *
1105     * - `index` must be strictly less than {length}.
1106     */
1107     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1108         return address(uint160(uint256(_at(set._inner, index))));
1109     }
1110 
1111 
1112     // UintSet
1113 
1114     struct UintSet {
1115         Set _inner;
1116     }
1117 
1118     /**
1119      * @dev Add a value to a set. O(1).
1120      *
1121      * Returns true if the value was added to the set, that is if it was not
1122      * already present.
1123      */
1124     function add(UintSet storage set, uint256 value) internal returns (bool) {
1125         return _add(set._inner, bytes32(value));
1126     }
1127 
1128     /**
1129      * @dev Removes a value from a set. O(1).
1130      *
1131      * Returns true if the value was removed from the set, that is if it was
1132      * present.
1133      */
1134     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1135         return _remove(set._inner, bytes32(value));
1136     }
1137 
1138     /**
1139      * @dev Returns true if the value is in the set. O(1).
1140      */
1141     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1142         return _contains(set._inner, bytes32(value));
1143     }
1144 
1145     /**
1146      * @dev Returns the number of values on the set. O(1).
1147      */
1148     function length(UintSet storage set) internal view returns (uint256) {
1149         return _length(set._inner);
1150     }
1151 
1152    /**
1153     * @dev Returns the value stored at position `index` in the set. O(1).
1154     *
1155     * Note that there are no guarantees on the ordering of values inside the
1156     * array, and it may change when more values are added or removed.
1157     *
1158     * Requirements:
1159     *
1160     * - `index` must be strictly less than {length}.
1161     */
1162     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1163         return uint256(_at(set._inner, index));
1164     }
1165 }
1166 
1167 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 
1173 /**
1174  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1175  */
1176 interface IAccessControlEnumerable {
1177     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1178     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1179 }
1180 
1181 /**
1182  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1183  */
1184 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1185     using EnumerableSet for EnumerableSet.AddressSet;
1186 
1187     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1188 
1189     /**
1190      * @dev See {IERC165-supportsInterface}.
1191      */
1192     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1193         return interfaceId == type(IAccessControlEnumerable).interfaceId
1194             || super.supportsInterface(interfaceId);
1195     }
1196 
1197     /**
1198      * @dev Returns one of the accounts that have `role`. `index` must be a
1199      * value between 0 and {getRoleMemberCount}, non-inclusive.
1200      *
1201      * Role bearers are not sorted in any particular way, and their ordering may
1202      * change at any point.
1203      *
1204      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1205      * you perform all queries on the same block. See the following
1206      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1207      * for more information.
1208      */
1209     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1210         return _roleMembers[role].at(index);
1211     }
1212 
1213     /**
1214      * @dev Returns the number of accounts that have `role`. Can be used
1215      * together with {getRoleMember} to enumerate all bearers of a role.
1216      */
1217     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1218         return _roleMembers[role].length();
1219     }
1220 
1221     /**
1222      * @dev Overload {grantRole} to track enumerable memberships
1223      */
1224     function grantRole(bytes32 role, address account) public virtual override {
1225         super.grantRole(role, account);
1226         _roleMembers[role].add(account);
1227     }
1228 
1229     /**
1230      * @dev Overload {revokeRole} to track enumerable memberships
1231      */
1232     function revokeRole(bytes32 role, address account) public virtual override {
1233         super.revokeRole(role, account);
1234         _roleMembers[role].remove(account);
1235     }
1236 
1237     /**
1238      * @dev Overload {renounceRole} to track enumerable memberships
1239      */
1240     function renounceRole(bytes32 role, address account) public virtual override {
1241         super.renounceRole(role, account);
1242         _roleMembers[role].remove(account);
1243     }
1244 
1245     /**
1246      * @dev Overload {_setupRole} to track enumerable memberships
1247      */
1248     function _setupRole(bytes32 role, address account) internal virtual override {
1249         super._setupRole(role, account);
1250         _roleMembers[role].add(account);
1251     }
1252 }
1253 
1254 // File: @openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 
1259 
1260 
1261 
1262 
1263 /**
1264  * @dev {ERC20} token, including:
1265  *
1266  *  - ability for holders to burn (destroy) their tokens
1267  *  - a minter role that allows for token minting (creation)
1268  *  - a pauser role that allows to stop all token transfers
1269  *
1270  * This contract uses {AccessControl} to lock permissioned functions using the
1271  * different roles - head to its documentation for details.
1272  *
1273  * The account that deploys the contract will be granted the minter and pauser
1274  * roles, as well as the default admin role, which will let it grant both minter
1275  * and pauser roles to other accounts.
1276  * 
1277  * Author: Kevin Huang
1278  */
1279 contract ERC20PresetMinterPauser is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable {
1280     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1281     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1282 
1283     /**
1284      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1285      * account that deploys the contract.
1286      *
1287      * See {ERC20-constructor}.
1288      */
1289     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
1290         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1291 
1292         _setupRole(MINTER_ROLE, _msgSender());
1293         _setupRole(PAUSER_ROLE, _msgSender());
1294     }
1295 
1296     /**
1297      * @dev Creates `amount` new tokens for `to`.
1298      *
1299      * See {ERC20-_mint}.
1300      *
1301      * Requirements:
1302      *
1303      * - the caller must have the `MINTER_ROLE`.
1304      */
1305     function mint(address to, uint256 amount) public virtual {
1306         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1307         _mint(to, amount);
1308     }
1309 
1310     /**
1311      * @dev Pauses all token transfers.
1312      *
1313      * See {ERC20Pausable} and {Pausable-_pause}.
1314      *
1315      * Requirements:
1316      *
1317      * - the caller must have the `PAUSER_ROLE`.
1318      */
1319     function pause() public virtual {
1320         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1321         _pause();
1322     }
1323 
1324     /**
1325      * @dev Unpauses all token transfers.
1326      *
1327      * See {ERC20Pausable} and {Pausable-_unpause}.
1328      *
1329      * Requirements:
1330      *
1331      * - the caller must have the `PAUSER_ROLE`.
1332      */
1333     function unpause() public virtual {
1334         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1335         _unpause();
1336     }
1337 
1338     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1339         super._beforeTokenTransfer(from, to, amount);
1340     }
1341 }
1342 
1343 // File: contracts/SPAY.sol
1344 
1345 // contracts/MyNFT.sol
1346 pragma solidity ^0.8.0;
1347 
1348 
1349 
1350 contract SPAY is ERC20PresetMinterPauser, ERC20Capped {
1351 
1352     constructor()
1353         ERC20PresetMinterPauser("SpaceY Token", "SPAY")
1354         ERC20Capped(25000000 * (10**uint256(18)))
1355     {}
1356 
1357     function _beforeTokenTransfer(
1358         address from,
1359         address to,
1360         uint256 amount
1361     ) internal virtual override(ERC20, ERC20PresetMinterPauser) {
1362         super._beforeTokenTransfer(from, to, amount);
1363     }
1364 
1365     function _mint(
1366         address account,
1367         uint256 amount
1368     ) internal virtual override(ERC20, ERC20Capped) {
1369         super._mint(account, amount);
1370     }
1371 }