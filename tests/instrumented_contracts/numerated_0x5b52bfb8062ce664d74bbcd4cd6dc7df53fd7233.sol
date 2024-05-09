1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /*
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
96         return msg.data;
97     }
98 }
99 
100 /**
101  * @dev Implementation of the {IERC20} interface.
102  *
103  * This implementation is agnostic to the way tokens are created. This means
104  * that a supply mechanism has to be added in a derived contract using {_mint}.
105  * For a generic mechanism see {ERC20PresetMinterPauser}.
106  *
107  * TIP: For a detailed writeup see our guide
108  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
109  * to implement supply mechanisms].
110  *
111  * We have followed general OpenZeppelin guidelines: functions revert instead
112  * of returning `false` on failure. This behavior is nonetheless conventional
113  * and does not conflict with the expectations of ERC20 applications.
114  *
115  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
116  * This allows applications to reconstruct the allowance for all accounts just
117  * by listening to said events. Other implementations of the EIP may not emit
118  * these events, as it isn't required by the specification.
119  *
120  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
121  * functions have been added to mitigate the well-known issues around setting
122  * allowances. See {IERC20-approve}.
123  */
124 contract ERC20 is Context, IERC20 {
125     mapping (address => uint256) private _balances;
126 
127     mapping (address => mapping (address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     string private _name;
132     string private _symbol;
133 
134     /**
135      * @dev Sets the values for {name} and {symbol}.
136      *
137      * The defaut value of {decimals} is 18. To select a different value for
138      * {decimals} you should overload it.
139      *
140      * All three of these values are immutable: they can only be set once during
141      * construction.
142      */
143     constructor (string memory name_, string memory symbol_) {
144         _name = name_;
145         _symbol = symbol_;
146     }
147 
148     /**
149      * @dev Returns the name of the token.
150      */
151     function name() public view virtual returns (string memory) {
152         return _name;
153     }
154 
155     /**
156      * @dev Returns the symbol of the token, usually a shorter version of the
157      * name.
158      */
159     function symbol() public view virtual returns (string memory) {
160         return _symbol;
161     }
162 
163     /**
164      * @dev Returns the number of decimals used to get its user representation.
165      * For example, if `decimals` equals `2`, a balance of `505` tokens should
166      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
167      *
168      * Tokens usually opt for a value of 18, imitating the relationship between
169      * Ether and Wei. This is the value {ERC20} uses, unless this function is
170      * overloaded;
171      *
172      * NOTE: This information is only used for _display_ purposes: it in
173      * no way affects any of the arithmetic of the contract, including
174      * {IERC20-balanceOf} and {IERC20-transfer}.
175      */
176     function decimals() public view virtual returns (uint8) {
177         return 18;
178     }
179 
180     /**
181      * @dev See {IERC20-totalSupply}.
182      */
183     function totalSupply() public view virtual override returns (uint256) {
184         return _totalSupply;
185     }
186 
187     /**
188      * @dev See {IERC20-balanceOf}.
189      */
190     function balanceOf(address account) public view virtual override returns (uint256) {
191         return _balances[account];
192     }
193 
194     /**
195      * @dev See {IERC20-transfer}.
196      *
197      * Requirements:
198      *
199      * - `recipient` cannot be the zero address.
200      * - the caller must have a balance of at least `amount`.
201      */
202     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     /**
208      * @dev See {IERC20-allowance}.
209      */
210     function allowance(address owner, address spender) public view virtual override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     /**
215      * @dev See {IERC20-approve}.
216      *
217      * Requirements:
218      *
219      * - `spender` cannot be the zero address.
220      */
221     function approve(address spender, uint256 amount) public virtual override returns (bool) {
222         _approve(_msgSender(), spender, amount);
223         return true;
224     }
225 
226     /**
227      * @dev See {IERC20-transferFrom}.
228      *
229      * Emits an {Approval} event indicating the updated allowance. This is not
230      * required by the EIP. See the note at the beginning of {ERC20}.
231      *
232      * Requirements:
233      *
234      * - `sender` and `recipient` cannot be the zero address.
235      * - `sender` must have a balance of at least `amount`.
236      * - the caller must have allowance for ``sender``'s tokens of at least
237      * `amount`.
238      */
239     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
240         _transfer(sender, recipient, amount);
241 
242         uint256 currentAllowance = _allowances[sender][_msgSender()];
243         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
244         _approve(sender, _msgSender(), currentAllowance - amount);
245 
246         return true;
247     }
248 
249     /**
250      * @dev Atomically increases the allowance granted to `spender` by the caller.
251      *
252      * This is an alternative to {approve} that can be used as a mitigation for
253      * problems described in {IERC20-approve}.
254      *
255      * Emits an {Approval} event indicating the updated allowance.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
262         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
263         return true;
264     }
265 
266     /**
267      * @dev Atomically decreases the allowance granted to `spender` by the caller.
268      *
269      * This is an alternative to {approve} that can be used as a mitigation for
270      * problems described in {IERC20-approve}.
271      *
272      * Emits an {Approval} event indicating the updated allowance.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      * - `spender` must have allowance for the caller of at least
278      * `subtractedValue`.
279      */
280     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
281         uint256 currentAllowance = _allowances[_msgSender()][spender];
282         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
283         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
284 
285         return true;
286     }
287 
288     /**
289      * @dev Moves tokens `amount` from `sender` to `recipient`.
290      *
291      * This is internal function is equivalent to {transfer}, and can be used to
292      * e.g. implement automatic token fees, slashing mechanisms, etc.
293      *
294      * Emits a {Transfer} event.
295      *
296      * Requirements:
297      *
298      * - `sender` cannot be the zero address.
299      * - `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `amount`.
301      */
302     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
303         require(sender != address(0), "ERC20: transfer from the zero address");
304         require(recipient != address(0), "ERC20: transfer to the zero address");
305 
306         _beforeTokenTransfer(sender, recipient, amount);
307 
308         uint256 senderBalance = _balances[sender];
309         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
310         _balances[sender] = senderBalance - amount;
311         _balances[recipient] += amount;
312 
313         emit Transfer(sender, recipient, amount);
314     }
315 
316     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
317      * the total supply.
318      *
319      * Emits a {Transfer} event with `from` set to the zero address.
320      *
321      * Requirements:
322      *
323      * - `to` cannot be the zero address.
324      */
325     function _mint(address account, uint256 amount) internal virtual {
326         require(account != address(0), "ERC20: mint to the zero address");
327 
328         _beforeTokenTransfer(address(0), account, amount);
329 
330         _totalSupply += amount;
331         _balances[account] += amount;
332         emit Transfer(address(0), account, amount);
333     }
334 
335     /**
336      * @dev Destroys `amount` tokens from `account`, reducing the
337      * total supply.
338      *
339      * Emits a {Transfer} event with `to` set to the zero address.
340      *
341      * Requirements:
342      *
343      * - `account` cannot be the zero address.
344      * - `account` must have at least `amount` tokens.
345      */
346     function _burn(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: burn from the zero address");
348 
349         _beforeTokenTransfer(account, address(0), amount);
350 
351         uint256 accountBalance = _balances[account];
352         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
353         _balances[account] = accountBalance - amount;
354         _totalSupply -= amount;
355 
356         emit Transfer(account, address(0), amount);
357     }
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
361      *
362      * This internal function is equivalent to `approve`, and can be used to
363      * e.g. set automatic allowances for certain subsystems, etc.
364      *
365      * Emits an {Approval} event.
366      *
367      * Requirements:
368      *
369      * - `owner` cannot be the zero address.
370      * - `spender` cannot be the zero address.
371      */
372     function _approve(address owner, address spender, uint256 amount) internal virtual {
373         require(owner != address(0), "ERC20: approve from the zero address");
374         require(spender != address(0), "ERC20: approve to the zero address");
375 
376         _allowances[owner][spender] = amount;
377         emit Approval(owner, spender, amount);
378     }
379 
380     /**
381      * @dev Hook that is called before any transfer of tokens. This includes
382      * minting and burning.
383      *
384      * Calling conditions:
385      *
386      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
387      * will be to transferred to `to`.
388      * - when `from` is zero, `amount` tokens will be minted for `to`.
389      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
390      * - `from` and `to` are never both zero.
391      *
392      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
393      */
394     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
395 }
396 
397 /**
398  * @dev Interface of the ERC165 standard, as defined in the
399  * https://eips.ethereum.org/EIPS/eip-165[EIP].
400  *
401  * Implementers can declare support of contract interfaces, which can then be
402  * queried by others ({ERC165Checker}).
403  *
404  * For an implementation, see {ERC165}.
405  */
406 interface IERC165 {
407     /**
408      * @dev Returns true if this contract implements the interface defined by
409      * `interfaceId`. See the corresponding
410      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
411      * to learn more about how these ids are created.
412      *
413      * This function call must use less than 30 000 gas.
414      */
415     function supportsInterface(bytes4 interfaceId) external view returns (bool);
416 }
417 
418 /**
419  * @dev Implementation of the {IERC165} interface.
420  *
421  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
422  * for the additional interface id that will be supported. For example:
423  *
424  * ```solidity
425  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
426  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
427  * }
428  * ```
429  *
430  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
431  */
432 abstract contract ERC165 is IERC165 {
433     /**
434      * @dev See {IERC165-supportsInterface}.
435      */
436     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
437         return interfaceId == type(IERC165).interfaceId;
438     }
439 }
440 
441 /**
442  * @dev External interface of AccessControl declared to support ERC165 detection.
443  */
444 interface IAccessControl {
445     function hasRole(bytes32 role, address account) external view returns (bool);
446     function getRoleAdmin(bytes32 role) external view returns (bytes32);
447     function grantRole(bytes32 role, address account) external;
448     function revokeRole(bytes32 role, address account) external;
449     function renounceRole(bytes32 role, address account) external;
450 }
451 
452 /**
453  * @dev Contract module that allows children to implement role-based access
454  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
455  * members except through off-chain means by accessing the contract event logs. Some
456  * applications may benefit from on-chain enumerability, for those cases see
457  * {AccessControlEnumerable}.
458  *
459  * Roles are referred to by their `bytes32` identifier. These should be exposed
460  * in the external API and be unique. The best way to achieve this is by
461  * using `public constant` hash digests:
462  *
463  * ```
464  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
465  * ```
466  *
467  * Roles can be used to represent a set of permissions. To restrict access to a
468  * function call, use {hasRole}:
469  *
470  * ```
471  * function foo() public {
472  *     require(hasRole(MY_ROLE, msg.sender));
473  *     ...
474  * }
475  * ```
476  *
477  * Roles can be granted and revoked dynamically via the {grantRole} and
478  * {revokeRole} functions. Each role has an associated admin role, and only
479  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
480  *
481  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
482  * that only accounts with this role will be able to grant or revoke other
483  * roles. More complex role relationships can be created by using
484  * {_setRoleAdmin}.
485  *
486  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
487  * grant and revoke this role. Extra precautions should be taken to secure
488  * accounts that have been granted it.
489  */
490 abstract contract AccessControl is Context, IAccessControl, ERC165 {
491     struct RoleData {
492         mapping (address => bool) members;
493         bytes32 adminRole;
494     }
495 
496     mapping (bytes32 => RoleData) private _roles;
497 
498     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
499 
500     /**
501      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
502      *
503      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
504      * {RoleAdminChanged} not being emitted signaling this.
505      *
506      * _Available since v3.1._
507      */
508     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
509 
510     /**
511      * @dev Emitted when `account` is granted `role`.
512      *
513      * `sender` is the account that originated the contract call, an admin role
514      * bearer except when using {_setupRole}.
515      */
516     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
517 
518     /**
519      * @dev Emitted when `account` is revoked `role`.
520      *
521      * `sender` is the account that originated the contract call:
522      *   - if using `revokeRole`, it is the admin role bearer
523      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
524      */
525     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
526 
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IAccessControl).interfaceId
532             || super.supportsInterface(interfaceId);
533     }
534 
535     /**
536      * @dev Returns `true` if `account` has been granted `role`.
537      */
538     function hasRole(bytes32 role, address account) public view override returns (bool) {
539         return _roles[role].members[account];
540     }
541 
542     /**
543      * @dev Returns the admin role that controls `role`. See {grantRole} and
544      * {revokeRole}.
545      *
546      * To change a role's admin, use {_setRoleAdmin}.
547      */
548     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
549         return _roles[role].adminRole;
550     }
551 
552     /**
553      * @dev Grants `role` to `account`.
554      *
555      * If `account` had not been already granted `role`, emits a {RoleGranted}
556      * event.
557      *
558      * Requirements:
559      *
560      * - the caller must have ``role``'s admin role.
561      */
562     function grantRole(bytes32 role, address account) public virtual override {
563         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
564 
565         _grantRole(role, account);
566     }
567 
568     /**
569      * @dev Revokes `role` from `account`.
570      *
571      * If `account` had been granted `role`, emits a {RoleRevoked} event.
572      *
573      * Requirements:
574      *
575      * - the caller must have ``role``'s admin role.
576      */
577     function revokeRole(bytes32 role, address account) public virtual override {
578         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
579 
580         _revokeRole(role, account);
581     }
582 
583     /**
584      * @dev Revokes `role` from the calling account.
585      *
586      * Roles are often managed via {grantRole} and {revokeRole}: this function's
587      * purpose is to provide a mechanism for accounts to lose their privileges
588      * if they are compromised (such as when a trusted device is misplaced).
589      *
590      * If the calling account had been granted `role`, emits a {RoleRevoked}
591      * event.
592      *
593      * Requirements:
594      *
595      * - the caller must be `account`.
596      */
597     function renounceRole(bytes32 role, address account) public virtual override {
598         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
599 
600         _revokeRole(role, account);
601     }
602 
603     /**
604      * @dev Grants `role` to `account`.
605      *
606      * If `account` had not been already granted `role`, emits a {RoleGranted}
607      * event. Note that unlike {grantRole}, this function doesn't perform any
608      * checks on the calling account.
609      *
610      * [WARNING]
611      * ====
612      * This function should only be called from the constructor when setting
613      * up the initial roles for the system.
614      *
615      * Using this function in any other way is effectively circumventing the admin
616      * system imposed by {AccessControl}.
617      * ====
618      */
619     function _setupRole(bytes32 role, address account) internal virtual {
620         _grantRole(role, account);
621     }
622 
623     /**
624      * @dev Sets `adminRole` as ``role``'s admin role.
625      *
626      * Emits a {RoleAdminChanged} event.
627      */
628     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
629         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
630         _roles[role].adminRole = adminRole;
631     }
632 
633     function _grantRole(bytes32 role, address account) private {
634         if (!hasRole(role, account)) {
635             _roles[role].members[account] = true;
636             emit RoleGranted(role, account, _msgSender());
637         }
638     }
639 
640     function _revokeRole(bytes32 role, address account) private {
641         if (hasRole(role, account)) {
642             _roles[role].members[account] = false;
643             emit RoleRevoked(role, account, _msgSender());
644         }
645     }
646 }
647 
648 /**
649  * @dev Library for managing
650  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
651  * types.
652  *
653  * Sets have the following properties:
654  *
655  * - Elements are added, removed, and checked for existence in constant time
656  * (O(1)).
657  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
658  *
659  * ```
660  * contract Example {
661  *     // Add the library methods
662  *     using EnumerableSet for EnumerableSet.AddressSet;
663  *
664  *     // Declare a set state variable
665  *     EnumerableSet.AddressSet private mySet;
666  * }
667  * ```
668  *
669  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
670  * and `uint256` (`UintSet`) are supported.
671  */
672 library EnumerableSet {
673     // To implement this library for multiple types with as little code
674     // repetition as possible, we write it in terms of a generic Set type with
675     // bytes32 values.
676     // The Set implementation uses private functions, and user-facing
677     // implementations (such as AddressSet) are just wrappers around the
678     // underlying Set.
679     // This means that we can only create new EnumerableSets for types that fit
680     // in bytes32.
681 
682     struct Set {
683         // Storage of set values
684         bytes32[] _values;
685 
686         // Position of the value in the `values` array, plus 1 because index 0
687         // means a value is not in the set.
688         mapping (bytes32 => uint256) _indexes;
689     }
690 
691     /**
692      * @dev Add a value to a set. O(1).
693      *
694      * Returns true if the value was added to the set, that is if it was not
695      * already present.
696      */
697     function _add(Set storage set, bytes32 value) private returns (bool) {
698         if (!_contains(set, value)) {
699             set._values.push(value);
700             // The value is stored at length-1, but we add 1 to all indexes
701             // and use 0 as a sentinel value
702             set._indexes[value] = set._values.length;
703             return true;
704         } else {
705             return false;
706         }
707     }
708 
709     /**
710      * @dev Removes a value from a set. O(1).
711      *
712      * Returns true if the value was removed from the set, that is if it was
713      * present.
714      */
715     function _remove(Set storage set, bytes32 value) private returns (bool) {
716         // We read and store the value's index to prevent multiple reads from the same storage slot
717         uint256 valueIndex = set._indexes[value];
718 
719         if (valueIndex != 0) { // Equivalent to contains(set, value)
720             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
721             // the array, and then remove the last element (sometimes called as 'swap and pop').
722             // This modifies the order of the array, as noted in {at}.
723 
724             uint256 toDeleteIndex = valueIndex - 1;
725             uint256 lastIndex = set._values.length - 1;
726 
727             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
728             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
729 
730             bytes32 lastvalue = set._values[lastIndex];
731 
732             // Move the last value to the index where the value to delete is
733             set._values[toDeleteIndex] = lastvalue;
734             // Update the index for the moved value
735             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
736 
737             // Delete the slot where the moved value was stored
738             set._values.pop();
739 
740             // Delete the index for the deleted slot
741             delete set._indexes[value];
742 
743             return true;
744         } else {
745             return false;
746         }
747     }
748 
749     /**
750      * @dev Returns true if the value is in the set. O(1).
751      */
752     function _contains(Set storage set, bytes32 value) private view returns (bool) {
753         return set._indexes[value] != 0;
754     }
755 
756     /**
757      * @dev Returns the number of values on the set. O(1).
758      */
759     function _length(Set storage set) private view returns (uint256) {
760         return set._values.length;
761     }
762 
763    /**
764     * @dev Returns the value stored at position `index` in the set. O(1).
765     *
766     * Note that there are no guarantees on the ordering of values inside the
767     * array, and it may change when more values are added or removed.
768     *
769     * Requirements:
770     *
771     * - `index` must be strictly less than {length}.
772     */
773     function _at(Set storage set, uint256 index) private view returns (bytes32) {
774         require(set._values.length > index, "EnumerableSet: index out of bounds");
775         return set._values[index];
776     }
777 
778     // Bytes32Set
779 
780     struct Bytes32Set {
781         Set _inner;
782     }
783 
784     /**
785      * @dev Add a value to a set. O(1).
786      *
787      * Returns true if the value was added to the set, that is if it was not
788      * already present.
789      */
790     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
791         return _add(set._inner, value);
792     }
793 
794     /**
795      * @dev Removes a value from a set. O(1).
796      *
797      * Returns true if the value was removed from the set, that is if it was
798      * present.
799      */
800     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
801         return _remove(set._inner, value);
802     }
803 
804     /**
805      * @dev Returns true if the value is in the set. O(1).
806      */
807     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
808         return _contains(set._inner, value);
809     }
810 
811     /**
812      * @dev Returns the number of values in the set. O(1).
813      */
814     function length(Bytes32Set storage set) internal view returns (uint256) {
815         return _length(set._inner);
816     }
817 
818    /**
819     * @dev Returns the value stored at position `index` in the set. O(1).
820     *
821     * Note that there are no guarantees on the ordering of values inside the
822     * array, and it may change when more values are added or removed.
823     *
824     * Requirements:
825     *
826     * - `index` must be strictly less than {length}.
827     */
828     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
829         return _at(set._inner, index);
830     }
831 
832     // AddressSet
833 
834     struct AddressSet {
835         Set _inner;
836     }
837 
838     /**
839      * @dev Add a value to a set. O(1).
840      *
841      * Returns true if the value was added to the set, that is if it was not
842      * already present.
843      */
844     function add(AddressSet storage set, address value) internal returns (bool) {
845         return _add(set._inner, bytes32(uint256(uint160(value))));
846     }
847 
848     /**
849      * @dev Removes a value from a set. O(1).
850      *
851      * Returns true if the value was removed from the set, that is if it was
852      * present.
853      */
854     function remove(AddressSet storage set, address value) internal returns (bool) {
855         return _remove(set._inner, bytes32(uint256(uint160(value))));
856     }
857 
858     /**
859      * @dev Returns true if the value is in the set. O(1).
860      */
861     function contains(AddressSet storage set, address value) internal view returns (bool) {
862         return _contains(set._inner, bytes32(uint256(uint160(value))));
863     }
864 
865     /**
866      * @dev Returns the number of values in the set. O(1).
867      */
868     function length(AddressSet storage set) internal view returns (uint256) {
869         return _length(set._inner);
870     }
871 
872    /**
873     * @dev Returns the value stored at position `index` in the set. O(1).
874     *
875     * Note that there are no guarantees on the ordering of values inside the
876     * array, and it may change when more values are added or removed.
877     *
878     * Requirements:
879     *
880     * - `index` must be strictly less than {length}.
881     */
882     function at(AddressSet storage set, uint256 index) internal view returns (address) {
883         return address(uint160(uint256(_at(set._inner, index))));
884     }
885 
886 
887     // UintSet
888 
889     struct UintSet {
890         Set _inner;
891     }
892 
893     /**
894      * @dev Add a value to a set. O(1).
895      *
896      * Returns true if the value was added to the set, that is if it was not
897      * already present.
898      */
899     function add(UintSet storage set, uint256 value) internal returns (bool) {
900         return _add(set._inner, bytes32(value));
901     }
902 
903     /**
904      * @dev Removes a value from a set. O(1).
905      *
906      * Returns true if the value was removed from the set, that is if it was
907      * present.
908      */
909     function remove(UintSet storage set, uint256 value) internal returns (bool) {
910         return _remove(set._inner, bytes32(value));
911     }
912 
913     /**
914      * @dev Returns true if the value is in the set. O(1).
915      */
916     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
917         return _contains(set._inner, bytes32(value));
918     }
919 
920     /**
921      * @dev Returns the number of values on the set. O(1).
922      */
923     function length(UintSet storage set) internal view returns (uint256) {
924         return _length(set._inner);
925     }
926 
927    /**
928     * @dev Returns the value stored at position `index` in the set. O(1).
929     *
930     * Note that there are no guarantees on the ordering of values inside the
931     * array, and it may change when more values are added or removed.
932     *
933     * Requirements:
934     *
935     * - `index` must be strictly less than {length}.
936     */
937     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
938         return uint256(_at(set._inner, index));
939     }
940 }
941 
942 /**
943  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
944  */
945 interface IAccessControlEnumerable {
946     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
947     function getRoleMemberCount(bytes32 role) external view returns (uint256);
948 }
949 
950 /**
951  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
952  */
953 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
954     using EnumerableSet for EnumerableSet.AddressSet;
955 
956     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
962         return interfaceId == type(IAccessControlEnumerable).interfaceId
963             || super.supportsInterface(interfaceId);
964     }
965 
966     /**
967      * @dev Returns one of the accounts that have `role`. `index` must be a
968      * value between 0 and {getRoleMemberCount}, non-inclusive.
969      *
970      * Role bearers are not sorted in any particular way, and their ordering may
971      * change at any point.
972      *
973      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
974      * you perform all queries on the same block. See the following
975      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
976      * for more information.
977      */
978     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
979         return _roleMembers[role].at(index);
980     }
981 
982     /**
983      * @dev Returns the number of accounts that have `role`. Can be used
984      * together with {getRoleMember} to enumerate all bearers of a role.
985      */
986     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
987         return _roleMembers[role].length();
988     }
989 
990     /**
991      * @dev Overload {grantRole} to track enumerable memberships
992      */
993     function grantRole(bytes32 role, address account) public virtual override {
994         super.grantRole(role, account);
995         _roleMembers[role].add(account);
996     }
997 
998     /**
999      * @dev Overload {revokeRole} to track enumerable memberships
1000      */
1001     function revokeRole(bytes32 role, address account) public virtual override {
1002         super.revokeRole(role, account);
1003         _roleMembers[role].remove(account);
1004     }
1005 
1006     /**
1007      * @dev Overload {renounceRole} to track enumerable memberships
1008      */
1009     function renounceRole(bytes32 role, address account) public virtual override {
1010         super.renounceRole(role, account);
1011         _roleMembers[role].remove(account);
1012     }
1013 
1014     /**
1015      * @dev Overload {_setupRole} to track enumerable memberships
1016      */
1017     function _setupRole(bytes32 role, address account) internal virtual override {
1018         super._setupRole(role, account);
1019         _roleMembers[role].add(account);
1020     }
1021 }
1022 
1023 contract ZENIQToken is Context, AccessControlEnumerable, ERC20 {
1024     bytes32 public constant BRIDGE_ROLE = keccak256("BRIDGE_ROLE");
1025 
1026     function burnFrom(address account, uint256 amount) public virtual {
1027         require(hasRole(BRIDGE_ROLE, _msgSender()), "ZENIQ: burning not allowed");
1028         uint256 currentAllowance = allowance(account, _msgSender());
1029         require(currentAllowance >= amount, "ZENIQ: burn amount exceeds allowance");
1030         _approve(account, _msgSender(), currentAllowance - amount);
1031         _burn(account, amount);
1032     }
1033 
1034     function mint(address to, uint256 amount) public virtual {
1035         require(hasRole(BRIDGE_ROLE, _msgSender()), "ZENIQ: minting not allowed");
1036         _mint(to, amount);
1037     }
1038 
1039     constructor() ERC20("ZENIQ", "ZENIQ") {
1040         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1041         _setupRole(BRIDGE_ROLE, _msgSender());
1042     }
1043 
1044     function burn(uint256 amount) public virtual {
1045         require(hasRole(BRIDGE_ROLE, _msgSender()), "ZENIQ: burning not allowed");
1046         _burn(_msgSender(), amount);
1047     }
1048 }