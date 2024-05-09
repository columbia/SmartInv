1 // Sources flattened with hardhat v2.2.0 https://hardhat.org
2 
3 // File contracts/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 // File contracts/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
84 
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 
109 // File contracts/openzeppelin-contracts/contracts/utils/Context.sol
110 
111 
112 pragma solidity ^0.8.0;
113 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 
136 // File contracts/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
137 
138 
139 pragma solidity ^0.8.0;
140 
141 
142 
143 /**
144  * @dev Implementation of the {IERC20} interface.
145  *
146  * This implementation is agnostic to the way tokens are created. This means
147  * that a supply mechanism has to be added in a derived contract using {_mint}.
148  * For a generic mechanism see {ERC20PresetMinterPauser}.
149  *
150  * TIP: For a detailed writeup see our guide
151  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
152  * to implement supply mechanisms].
153  *
154  * We have followed general OpenZeppelin guidelines: functions revert instead
155  * of returning `false` on failure. This behavior is nonetheless conventional
156  * and does not conflict with the expectations of ERC20 applications.
157  *
158  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
159  * This allows applications to reconstruct the allowance for all accounts just
160  * by listening to said events. Other implementations of the EIP may not emit
161  * these events, as it isn't required by the specification.
162  *
163  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
164  * functions have been added to mitigate the well-known issues around setting
165  * allowances. See {IERC20-approve}.
166  */
167 contract ERC20 is Context, IERC20, IERC20Metadata {
168     mapping (address => uint256) private _balances;
169 
170     mapping (address => mapping (address => uint256)) private _allowances;
171 
172     uint256 private _totalSupply;
173 
174     string private _name;
175     string private _symbol;
176 
177     /**
178      * @dev Sets the values for {name} and {symbol}.
179      *
180      * The defaut value of {decimals} is 18. To select a different value for
181      * {decimals} you should overload it.
182      *
183      * All two of these values are immutable: they can only be set once during
184      * construction.
185      */
186     constructor (string memory name_, string memory symbol_) {
187         _name = name_;
188         _symbol = symbol_;
189     }
190 
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() public view virtual override returns (string memory) {
195         return _name;
196     }
197 
198     /**
199      * @dev Returns the symbol of the token, usually a shorter version of the
200      * name.
201      */
202     function symbol() public view virtual override returns (string memory) {
203         return _symbol;
204     }
205 
206     /**
207      * @dev Returns the number of decimals used to get its user representation.
208      * For example, if `decimals` equals `2`, a balance of `505` tokens should
209      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
210      *
211      * Tokens usually opt for a value of 18, imitating the relationship between
212      * Ether and Wei. This is the value {ERC20} uses, unless this function is
213      * overridden;
214      *
215      * NOTE: This information is only used for _display_ purposes: it in
216      * no way affects any of the arithmetic of the contract, including
217      * {IERC20-balanceOf} and {IERC20-transfer}.
218      */
219     function decimals() public view virtual override returns (uint8) {
220         return 18;
221     }
222 
223     /**
224      * @dev See {IERC20-totalSupply}.
225      */
226     function totalSupply() public view virtual override returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231      * @dev See {IERC20-balanceOf}.
232      */
233     function balanceOf(address account) public view virtual override returns (uint256) {
234         return _balances[account];
235     }
236 
237     /**
238      * @dev See {IERC20-transfer}.
239      *
240      * Requirements:
241      *
242      * - `recipient` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
246         _transfer(_msgSender(), recipient, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-allowance}.
252      */
253     function allowance(address owner, address spender) public view virtual override returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     /**
258      * @dev See {IERC20-approve}.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function approve(address spender, uint256 amount) public virtual override returns (bool) {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-transferFrom}.
271      *
272      * Emits an {Approval} event indicating the updated allowance. This is not
273      * required by the EIP. See the note at the beginning of {ERC20}.
274      *
275      * Requirements:
276      *
277      * - `sender` and `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `amount`.
279      * - the caller must have allowance for ``sender``'s tokens of at least
280      * `amount`.
281      */
282     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
283         _transfer(sender, recipient, amount);
284 
285         uint256 currentAllowance = _allowances[sender][_msgSender()];
286         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
287         _approve(sender, _msgSender(), currentAllowance - amount);
288 
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to {approve} that can be used as a mitigation for
296      * problems described in {IERC20-approve}.
297      *
298      * Emits an {Approval} event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
305         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
324         uint256 currentAllowance = _allowances[_msgSender()][spender];
325         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
326         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
327 
328         return true;
329     }
330 
331     /**
332      * @dev Moves tokens `amount` from `sender` to `recipient`.
333      *
334      * This is internal function is equivalent to {transfer}, and can be used to
335      * e.g. implement automatic token fees, slashing mechanisms, etc.
336      *
337      * Emits a {Transfer} event.
338      *
339      * Requirements:
340      *
341      * - `sender` cannot be the zero address.
342      * - `recipient` cannot be the zero address.
343      * - `sender` must have a balance of at least `amount`.
344      */
345     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         _beforeTokenTransfer(sender, recipient, amount);
350 
351         uint256 senderBalance = _balances[sender];
352         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
353         _balances[sender] = senderBalance - amount;
354         _balances[recipient] += amount;
355 
356         emit Transfer(sender, recipient, amount);
357     }
358 
359     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
360      * the total supply.
361      *
362      * Emits a {Transfer} event with `from` set to the zero address.
363      *
364      * Requirements:
365      *
366      * - `to` cannot be the zero address.
367      */
368     function _mint(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: mint to the zero address");
370 
371         _beforeTokenTransfer(address(0), account, amount);
372 
373         _totalSupply += amount;
374         _balances[account] += amount;
375         emit Transfer(address(0), account, amount);
376     }
377 
378     /**
379      * @dev Destroys `amount` tokens from `account`, reducing the
380      * total supply.
381      *
382      * Emits a {Transfer} event with `to` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      * - `account` must have at least `amount` tokens.
388      */
389     function _burn(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: burn from the zero address");
391 
392         _beforeTokenTransfer(account, address(0), amount);
393 
394         uint256 accountBalance = _balances[account];
395         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
396         _balances[account] = accountBalance - amount;
397         _totalSupply -= amount;
398 
399         emit Transfer(account, address(0), amount);
400     }
401 
402     /**
403      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
404      *
405      * This internal function is equivalent to `approve`, and can be used to
406      * e.g. set automatic allowances for certain subsystems, etc.
407      *
408      * Emits an {Approval} event.
409      *
410      * Requirements:
411      *
412      * - `owner` cannot be the zero address.
413      * - `spender` cannot be the zero address.
414      */
415     function _approve(address owner, address spender, uint256 amount) internal virtual {
416         require(owner != address(0), "ERC20: approve from the zero address");
417         require(spender != address(0), "ERC20: approve to the zero address");
418 
419         _allowances[owner][spender] = amount;
420         emit Approval(owner, spender, amount);
421     }
422 
423     /**
424      * @dev Hook that is called before any transfer of tokens. This includes
425      * minting and burning.
426      *
427      * Calling conditions:
428      *
429      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
430      * will be to transferred to `to`.
431      * - when `from` is zero, `amount` tokens will be minted for `to`.
432      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
433      * - `from` and `to` are never both zero.
434      *
435      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
436      */
437     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
438 }
439 
440 
441 // File contracts/openzeppelin-contracts/contracts/utils/Strings.sol
442 
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev String operations.
448  */
449 library Strings {
450     bytes16 private constant alphabet = "0123456789abcdef";
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
454      */
455     function toString(uint256 value) internal pure returns (string memory) {
456         // Inspired by OraclizeAPI's implementation - MIT licence
457         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
458 
459         if (value == 0) {
460             return "0";
461         }
462         uint256 temp = value;
463         uint256 digits;
464         while (temp != 0) {
465             digits++;
466             temp /= 10;
467         }
468         bytes memory buffer = new bytes(digits);
469         while (value != 0) {
470             digits -= 1;
471             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
472             value /= 10;
473         }
474         return string(buffer);
475     }
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
479      */
480     function toHexString(uint256 value) internal pure returns (string memory) {
481         if (value == 0) {
482             return "0x00";
483         }
484         uint256 temp = value;
485         uint256 length = 0;
486         while (temp != 0) {
487             length++;
488             temp >>= 8;
489         }
490         return toHexString(value, length);
491     }
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
495      */
496     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
497         bytes memory buffer = new bytes(2 * length + 2);
498         buffer[0] = "0";
499         buffer[1] = "x";
500         for (uint256 i = 2 * length + 1; i > 1; --i) {
501             buffer[i] = alphabet[value & 0xf];
502             value >>= 4;
503         }
504         require(value == 0, "Strings: hex length insufficient");
505         return string(buffer);
506     }
507 
508 }
509 
510 
511 // File contracts/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
512 
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 
538 // File contracts/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
539 
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         return interfaceId == type(IERC165).interfaceId;
563     }
564 }
565 
566 
567 // File contracts/openzeppelin-contracts/contracts/access/AccessControl.sol
568 
569 
570 pragma solidity ^0.8.0;
571 
572 
573 
574 /**
575  * @dev External interface of AccessControl declared to support ERC165 detection.
576  */
577 interface IAccessControl {
578     function hasRole(bytes32 role, address account) external view returns (bool);
579     function getRoleAdmin(bytes32 role) external view returns (bytes32);
580     function grantRole(bytes32 role, address account) external;
581     function revokeRole(bytes32 role, address account) external;
582     function renounceRole(bytes32 role, address account) external;
583 }
584 
585 /**
586  * @dev Contract module that allows children to implement role-based access
587  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
588  * members except through off-chain means by accessing the contract event logs. Some
589  * applications may benefit from on-chain enumerability, for those cases see
590  * {AccessControlEnumerable}.
591  *
592  * Roles are referred to by their `bytes32` identifier. These should be exposed
593  * in the external API and be unique. The best way to achieve this is by
594  * using `public constant` hash digests:
595  *
596  * ```
597  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
598  * ```
599  *
600  * Roles can be used to represent a set of permissions. To restrict access to a
601  * function call, use {hasRole}:
602  *
603  * ```
604  * function foo() public {
605  *     require(hasRole(MY_ROLE, msg.sender));
606  *     ...
607  * }
608  * ```
609  *
610  * Roles can be granted and revoked dynamically via the {grantRole} and
611  * {revokeRole} functions. Each role has an associated admin role, and only
612  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
613  *
614  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
615  * that only accounts with this role will be able to grant or revoke other
616  * roles. More complex role relationships can be created by using
617  * {_setRoleAdmin}.
618  *
619  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
620  * grant and revoke this role. Extra precautions should be taken to secure
621  * accounts that have been granted it.
622  */
623 abstract contract AccessControl is Context, IAccessControl, ERC165 {
624     struct RoleData {
625         mapping (address => bool) members;
626         bytes32 adminRole;
627     }
628 
629     mapping (bytes32 => RoleData) private _roles;
630 
631     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
632 
633     /**
634      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
635      *
636      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
637      * {RoleAdminChanged} not being emitted signaling this.
638      *
639      * _Available since v3.1._
640      */
641     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
642 
643     /**
644      * @dev Emitted when `account` is granted `role`.
645      *
646      * `sender` is the account that originated the contract call, an admin role
647      * bearer except when using {_setupRole}.
648      */
649     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
650 
651     /**
652      * @dev Emitted when `account` is revoked `role`.
653      *
654      * `sender` is the account that originated the contract call:
655      *   - if using `revokeRole`, it is the admin role bearer
656      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
657      */
658     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
659 
660     /**
661      * @dev Modifier that checks that an account has a specific role. Reverts
662      * with a standardized message including the required role.
663      *
664      * The format of the revert reason is given by the following regular expression:
665      *
666      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
667      */
668     modifier onlyRole(bytes32 role) {
669         _checkRole(role, _msgSender());
670         _;
671     }
672 
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677         return interfaceId == type(IAccessControl).interfaceId
678             || super.supportsInterface(interfaceId);
679     }
680 
681     /**
682      * @dev Returns `true` if `account` has been granted `role`.
683      */
684     function hasRole(bytes32 role, address account) public view override returns (bool) {
685         return _roles[role].members[account];
686     }
687 
688     /**
689      * @dev Revert with a standard message if `account` is missing `role`.
690      *
691      * The format of the revert reason is given by the following regular expression:
692      *
693      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
694      */
695     function _checkRole(bytes32 role, address account) internal view {
696         if(!hasRole(role, account)) {
697             revert(string(abi.encodePacked(
698                 "AccessControl: account ",
699                 Strings.toHexString(uint160(account), 20),
700                 " is missing role ",
701                 Strings.toHexString(uint256(role), 32)
702             )));
703         }
704     }
705 
706     /**
707      * @dev Returns the admin role that controls `role`. See {grantRole} and
708      * {revokeRole}.
709      *
710      * To change a role's admin, use {_setRoleAdmin}.
711      */
712     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
713         return _roles[role].adminRole;
714     }
715 
716     /**
717      * @dev Grants `role` to `account`.
718      *
719      * If `account` had not been already granted `role`, emits a {RoleGranted}
720      * event.
721      *
722      * Requirements:
723      *
724      * - the caller must have ``role``'s admin role.
725      */
726     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
727         _grantRole(role, account);
728     }
729 
730     /**
731      * @dev Revokes `role` from `account`.
732      *
733      * If `account` had been granted `role`, emits a {RoleRevoked} event.
734      *
735      * Requirements:
736      *
737      * - the caller must have ``role``'s admin role.
738      */
739     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
740         _revokeRole(role, account);
741     }
742 
743     /**
744      * @dev Revokes `role` from the calling account.
745      *
746      * Roles are often managed via {grantRole} and {revokeRole}: this function's
747      * purpose is to provide a mechanism for accounts to lose their privileges
748      * if they are compromised (such as when a trusted device is misplaced).
749      *
750      * If the calling account had been granted `role`, emits a {RoleRevoked}
751      * event.
752      *
753      * Requirements:
754      *
755      * - the caller must be `account`.
756      */
757     function renounceRole(bytes32 role, address account) public virtual override {
758         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
759 
760         _revokeRole(role, account);
761     }
762 
763     /**
764      * @dev Grants `role` to `account`.
765      *
766      * If `account` had not been already granted `role`, emits a {RoleGranted}
767      * event. Note that unlike {grantRole}, this function doesn't perform any
768      * checks on the calling account.
769      *
770      * [WARNING]
771      * ====
772      * This function should only be called from the constructor when setting
773      * up the initial roles for the system.
774      *
775      * Using this function in any other way is effectively circumventing the admin
776      * system imposed by {AccessControl}.
777      * ====
778      */
779     function _setupRole(bytes32 role, address account) internal virtual {
780         _grantRole(role, account);
781     }
782 
783     /**
784      * @dev Sets `adminRole` as ``role``'s admin role.
785      *
786      * Emits a {RoleAdminChanged} event.
787      */
788     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
789         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
790         _roles[role].adminRole = adminRole;
791     }
792 
793     function _grantRole(bytes32 role, address account) private {
794         if (!hasRole(role, account)) {
795             _roles[role].members[account] = true;
796             emit RoleGranted(role, account, _msgSender());
797         }
798     }
799 
800     function _revokeRole(bytes32 role, address account) private {
801         if (hasRole(role, account)) {
802             _roles[role].members[account] = false;
803             emit RoleRevoked(role, account, _msgSender());
804         }
805     }
806 }
807 
808 
809 // File contracts/openzeppelin-contracts/contracts/access/Ownable.sol
810 
811 
812 pragma solidity ^0.8.0;
813 
814 /**
815  * @dev Contract module which provides a basic access control mechanism, where
816  * there is an account (an owner) that can be granted exclusive access to
817  * specific functions.
818  *
819  * By default, the owner account will be the one that deploys the contract. This
820  * can later be changed with {transferOwnership}.
821  *
822  * This module is used through inheritance. It will make available the modifier
823  * `onlyOwner`, which can be applied to your functions to restrict their use to
824  * the owner.
825  */
826 abstract contract Ownable is Context {
827     address private _owner;
828 
829     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
830 
831     /**
832      * @dev Initializes the contract setting the deployer as the initial owner.
833      */
834     constructor () {
835         address msgSender = _msgSender();
836         _owner = msgSender;
837         emit OwnershipTransferred(address(0), msgSender);
838     }
839 
840     /**
841      * @dev Returns the address of the current owner.
842      */
843     function owner() public view virtual returns (address) {
844         return _owner;
845     }
846 
847     /**
848      * @dev Throws if called by any account other than the owner.
849      */
850     modifier onlyOwner() {
851         require(owner() == _msgSender(), "Ownable: caller is not the owner");
852         _;
853     }
854 
855     /**
856      * @dev Leaves the contract without owner. It will not be possible to call
857      * `onlyOwner` functions anymore. Can only be called by the current owner.
858      *
859      * NOTE: Renouncing ownership will leave the contract without an owner,
860      * thereby removing any functionality that is only available to the owner.
861      */
862     function renounceOwnership() public virtual onlyOwner {
863         emit OwnershipTransferred(_owner, address(0));
864         _owner = address(0);
865     }
866 
867     /**
868      * @dev Transfers ownership of the contract to a new account (`newOwner`).
869      * Can only be called by the current owner.
870      */
871     function transferOwnership(address newOwner) public virtual onlyOwner {
872         require(newOwner != address(0), "Ownable: new owner is the zero address");
873         emit OwnershipTransferred(_owner, newOwner);
874         _owner = newOwner;
875     }
876 }
877 
878 
879 // File contracts/openzeppelin-contracts/contracts/security/Pausable.sol
880 
881 
882 pragma solidity ^0.8.0;
883 
884 /**
885  * @dev Contract module which allows children to implement an emergency stop
886  * mechanism that can be triggered by an authorized account.
887  *
888  * This module is used through inheritance. It will make available the
889  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
890  * the functions of your contract. Note that they will not be pausable by
891  * simply including this module, only once the modifiers are put in place.
892  */
893 abstract contract Pausable is Context {
894     /**
895      * @dev Emitted when the pause is triggered by `account`.
896      */
897     event Paused(address account);
898 
899     /**
900      * @dev Emitted when the pause is lifted by `account`.
901      */
902     event Unpaused(address account);
903 
904     bool private _paused;
905 
906     /**
907      * @dev Initializes the contract in unpaused state.
908      */
909     constructor () {
910         _paused = false;
911     }
912 
913     /**
914      * @dev Returns true if the contract is paused, and false otherwise.
915      */
916     function paused() public view virtual returns (bool) {
917         return _paused;
918     }
919 
920     /**
921      * @dev Modifier to make a function callable only when the contract is not paused.
922      *
923      * Requirements:
924      *
925      * - The contract must not be paused.
926      */
927     modifier whenNotPaused() {
928         require(!paused(), "Pausable: paused");
929         _;
930     }
931 
932     /**
933      * @dev Modifier to make a function callable only when the contract is paused.
934      *
935      * Requirements:
936      *
937      * - The contract must be paused.
938      */
939     modifier whenPaused() {
940         require(paused(), "Pausable: not paused");
941         _;
942     }
943 
944     /**
945      * @dev Triggers stopped state.
946      *
947      * Requirements:
948      *
949      * - The contract must not be paused.
950      */
951     function _pause() internal virtual whenNotPaused {
952         _paused = true;
953         emit Paused(_msgSender());
954     }
955 
956     /**
957      * @dev Returns to normal state.
958      *
959      * Requirements:
960      *
961      * - The contract must be paused.
962      */
963     function _unpause() internal virtual whenPaused {
964         _paused = false;
965         emit Unpaused(_msgSender());
966     }
967 }
968 
969 
970 // File contracts/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Pausable.sol
971 
972 
973 pragma solidity ^0.8.0;
974 
975 
976 /**
977  * @dev ERC20 token with pausable token transfers, minting and burning.
978  *
979  * Useful for scenarios such as preventing trades until the end of an evaluation
980  * period, or having an emergency switch for freezing all token transfers in the
981  * event of a large bug.
982  */
983 abstract contract ERC20Pausable is ERC20, Pausable {
984     /**
985      * @dev See {ERC20-_beforeTokenTransfer}.
986      *
987      * Requirements:
988      *
989      * - the contract must not be paused.
990      */
991     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
992         super._beforeTokenTransfer(from, to, amount);
993 
994         require(!paused(), "ERC20Pausable: token transfer while paused");
995     }
996 }
997 
998 
999 // File contracts/uni-v2.sol
1000 
1001 // SPDX-License-Identifier: MIT
1002 pragma solidity ^0.8.0;
1003 
1004 
1005 
1006 
1007 contract meowToken is ERC20, AccessControl, Ownable, Pausable {
1008 
1009     constructor() ERC20("PUSSY-liq", "MEOW") {
1010         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1011         _mint(msg.sender, 1e23);
1012     }
1013 
1014     function pause() public onlyOwner{
1015         _pause();
1016     }
1017 
1018     function unpause() public onlyOwner{
1019         _unpause();
1020     }
1021 }