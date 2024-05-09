1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 interface IBEP20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the token decimals.
13      */
14     function decimals() external view returns (uint8);
15 
16     /**
17      * @dev Returns the token symbol.
18      */
19     function symbol() external view returns (string memory);
20 
21     /**
22      * @dev Returns the token name.
23      */
24     function name() external view returns (string memory);
25 
26     /**
27      * @dev Returns the bep token owner.
28      */
29     function getOwner() external view returns (address);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address _owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 pragma solidity ^0.8.0;
97 
98 
99 /**
100  * @dev Implementation of the {IERC20} interface.
101  *
102  * This implementation is agnostic to the way tokens are created. This means
103  * that a supply mechanism has to be added in a derived contract using {_mint}.
104  * For a generic mechanism see {ERC20PresetMinterPauser}.
105  *
106  * TIP: For a detailed writeup see our guide
107  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
108  * to implement supply mechanisms].
109  *
110  * We have followed general OpenZeppelin guidelines: functions revert instead
111  * of returning `false` on failure. This behavior is nonetheless conventional
112  * and does not conflict with the expectations of ERC20 applications.
113  *
114  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
115  * This allows applications to reconstruct the allowance for all accounts just
116  * by listening to said events. Other implementations of the EIP may not emit
117  * these events, as it isn't required by the specification.
118  *
119  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
120  * functions have been added to mitigate the well-known issues around setting
121  * allowances. See {IERC20-approve}.
122  */
123 contract BEP20 is IBEP20 {
124     mapping (address => uint256) private _balances;
125 
126     mapping (address => mapping (address => uint256)) private _allowances;
127 
128     uint256 private _totalSupply;
129 
130     string private _name;
131     string private _symbol;
132     address private _owner;
133 
134     /**
135      * @dev Sets the values for {name} and {symbol}.
136      *
137      * The defaut value of {decimals} is 18. To select a different value for
138      * {decimals} you should overload it.
139      *
140      * All two of these values are immutable: they can only be set once during
141      * construction.
142      */
143     constructor (string memory name_, string memory symbol_) {
144         _name = name_;
145         _symbol = symbol_;
146         _owner = msg.sender;
147     }
148 
149     function setOwner(address newOwner) public virtual {
150         require(msg.sender == getOwner(), "Not owner");
151         _owner = newOwner;
152     }
153 
154     function getOwner() public view virtual override returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Returns the name of the token.
160      */
161     function name() public view virtual override returns (string memory) {
162         return _name;
163     }
164 
165     /**
166      * @dev Returns the symbol of the token, usually a shorter version of the
167      * name.
168      */
169     function symbol() public view virtual override returns (string memory) {
170         return _symbol;
171     }
172 
173     /**
174      * @dev Returns the number of decimals used to get its user representation.
175      * For example, if `decimals` equals `2`, a balance of `505` tokens should
176      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
177      *
178      * Tokens usually opt for a value of 18, imitating the relationship between
179      * Ether and Wei. This is the value {ERC20} uses, unless this function is
180      * overridden;
181      *
182      * NOTE: This information is only used for _display_ purposes: it in
183      * no way affects any of the arithmetic of the contract, including
184      * {IERC20-balanceOf} and {IERC20-transfer}.
185      */
186     function decimals() public view virtual override returns (uint8) {
187         return 8;
188     }
189 
190     /**
191      * @dev See {IERC20-totalSupply}.
192      */
193     function totalSupply() public view virtual override returns (uint256) {
194         return _totalSupply;
195     }
196 
197     /**
198      * @dev See {IERC20-balanceOf}.
199      */
200     function balanceOf(address account) public view virtual override returns (uint256) {
201         return _balances[account];
202     }
203 
204     /**
205      * @dev See {IERC20-transfer}.
206      *
207      * Requirements:
208      *
209      * - `recipient` cannot be the zero address.
210      * - the caller must have a balance of at least `amount`.
211      */
212     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
213         _transfer(msg.sender, recipient, amount);
214         return true;
215     }
216 
217     /**
218      * @dev See {IERC20-allowance}.
219      */
220     function allowance(address owner, address spender) public view virtual override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     /**
225      * @dev See {IERC20-approve}.
226      *
227      * Requirements:
228      *
229      * - `spender` cannot be the zero address.
230      */
231     function approve(address spender, uint256 amount) public virtual override returns (bool) {
232         _approve(msg.sender, spender, amount);
233         return true;
234     }
235 
236     /**
237      * @dev See {IERC20-transferFrom}.
238      *
239      * Emits an {Approval} event indicating the updated allowance. This is not
240      * required by the EIP. See the note at the beginning of {ERC20}.
241      *
242      * Requirements:
243      *
244      * - `sender` and `recipient` cannot be the zero address.
245      * - `sender` must have a balance of at least `amount`.
246      * - the caller must have allowance for ``sender``'s tokens of at least
247      * `amount`.
248      */
249     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
250         _transfer(sender, recipient, amount);
251 
252         uint256 currentAllowance = _allowances[sender][msg.sender];
253         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
254         _approve(sender, msg.sender, currentAllowance - amount);
255 
256         return true;
257     }
258 
259     /**
260      * @dev Atomically increases the allowance granted to `spender` by the caller.
261      *
262      * This is an alternative to {approve} that can be used as a mitigation for
263      * problems described in {IERC20-approve}.
264      *
265      * Emits an {Approval} event indicating the updated allowance.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
272         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
273         return true;
274     }
275 
276     /**
277      * @dev Atomically decreases the allowance granted to `spender` by the caller.
278      *
279      * This is an alternative to {approve} that can be used as a mitigation for
280      * problems described in {IERC20-approve}.
281      *
282      * Emits an {Approval} event indicating the updated allowance.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      * - `spender` must have allowance for the caller of at least
288      * `subtractedValue`.
289      */
290     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
291         uint256 currentAllowance = _allowances[msg.sender][spender];
292         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
293         _approve(msg.sender, spender, currentAllowance - subtractedValue);
294 
295         return true;
296     }
297 
298     /**
299      * @dev Moves tokens `amount` from `sender` to `recipient`.
300      *
301      * This is internal function is equivalent to {transfer}, and can be used to
302      * e.g. implement automatic token fees, slashing mechanisms, etc.
303      *
304      * Emits a {Transfer} event.
305      *
306      * Requirements:
307      *
308      * - `sender` cannot be the zero address.
309      * - `recipient` cannot be the zero address.
310      * - `sender` must have a balance of at least `amount`.
311      */
312     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
313         require(sender != address(0), "ERC20: transfer from the zero address");
314         require(recipient != address(0), "ERC20: transfer to the zero address");
315 
316         _beforeTokenTransfer(sender, recipient, amount);
317 
318         uint256 senderBalance = _balances[sender];
319         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
320         _balances[sender] = senderBalance - amount;
321         _balances[recipient] += amount;
322 
323         emit Transfer(sender, recipient, amount);
324     }
325 
326     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
327      * the total supply.
328      *
329      * Emits a {Transfer} event with `from` set to the zero address.
330      *
331      * Requirements:
332      *
333      * - `to` cannot be the zero address.
334      */
335     function _mint(address account, uint256 amount) internal virtual {
336         require(account != address(0), "ERC20: mint to the zero address");
337 
338         _beforeTokenTransfer(address(0), account, amount);
339 
340         _totalSupply += amount;
341         _balances[account] += amount;
342         emit Transfer(address(0), account, amount);
343     }
344 
345     /**
346      * @dev Destroys `amount` tokens from `account`, reducing the
347      * total supply.
348      *
349      * Emits a {Transfer} event with `to` set to the zero address.
350      *
351      * Requirements:
352      *
353      * - `account` cannot be the zero address.
354      * - `account` must have at least `amount` tokens.
355      */
356     function _burn(address account, uint256 amount) internal virtual {
357         require(account != address(0), "ERC20: burn from the zero address");
358 
359         _beforeTokenTransfer(account, address(0), amount);
360 
361         uint256 accountBalance = _balances[account];
362         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
363         _balances[account] = accountBalance - amount;
364         _totalSupply -= amount;
365 
366         emit Transfer(account, address(0), amount);
367     }
368 
369     /**
370      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
371      *
372      * This internal function is equivalent to `approve`, and can be used to
373      * e.g. set automatic allowances for certain subsystems, etc.
374      *
375      * Emits an {Approval} event.
376      *
377      * Requirements:
378      *
379      * - `owner` cannot be the zero address.
380      * - `spender` cannot be the zero address.
381      */
382     function _approve(address owner, address spender, uint256 amount) internal virtual {
383         require(owner != address(0), "ERC20: approve from the zero address");
384         require(spender != address(0), "ERC20: approve to the zero address");
385 
386         _allowances[owner][spender] = amount;
387         emit Approval(owner, spender, amount);
388     }
389 
390     /**
391      * @dev Hook that is called before any transfer of tokens. This includes
392      * minting and burning.
393      *
394      * Calling conditions:
395      *
396      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
397      * will be to transferred to `to`.
398      * - when `from` is zero, `amount` tokens will be minted for `to`.
399      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
400      * - `from` and `to` are never both zero.
401      *
402      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
403      */
404     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
405 }
406 
407 pragma solidity 0.8.6;
408 
409 
410 abstract contract Burnable is BEP20 {
411 
412     event Redeem(uint256 amount, string grlcAddress);
413 
414     /**
415      * @dev Redeem ERC20 into GRLC
416      */
417     function redeem(uint256 amount, string memory grlcAddress) public virtual {
418         _burn(msg.sender, amount);
419         emit Redeem(amount, grlcAddress);
420     }
421 
422     /**
423      * @dev Destroys `amount` tokens from the caller.
424      *
425      * See {ERC20-_burn}.
426      */
427     function burn(uint256 amount) public virtual {
428         _burn(msg.sender, amount);
429     }
430 
431     /**
432      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
433      * allowance.
434      *
435      * See {ERC20-_burn} and {ERC20-allowance}.
436      *
437      * Requirements:
438      *
439      * - the caller must have allowance for ``accounts``'s tokens of at least
440      * `amount`.
441      */
442     function burnFrom(address account, uint256 amount) public virtual {
443         uint256 currentAllowance = allowance(account, msg.sender);
444         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
445         _approve(account, msg.sender, currentAllowance - amount);
446         _burn(account, amount);
447     }
448 
449 }
450 
451 pragma solidity ^0.8.0;
452 
453 /*
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
470         return msg.data;
471     }
472 }
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @dev String operations.
478  */
479 library Strings {
480     bytes16 private constant alphabet = "0123456789abcdef";
481 
482     /**
483      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
484      */
485     function toString(uint256 value) internal pure returns (string memory) {
486         // Inspired by OraclizeAPI's implementation - MIT licence
487         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
488 
489         if (value == 0) {
490             return "0";
491         }
492         uint256 temp = value;
493         uint256 digits;
494         while (temp != 0) {
495             digits++;
496             temp /= 10;
497         }
498         bytes memory buffer = new bytes(digits);
499         while (value != 0) {
500             digits -= 1;
501             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
502             value /= 10;
503         }
504         return string(buffer);
505     }
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
509      */
510     function toHexString(uint256 value) internal pure returns (string memory) {
511         if (value == 0) {
512             return "0x00";
513         }
514         uint256 temp = value;
515         uint256 length = 0;
516         while (temp != 0) {
517             length++;
518             temp >>= 8;
519         }
520         return toHexString(value, length);
521     }
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
525      */
526     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
527         bytes memory buffer = new bytes(2 * length + 2);
528         buffer[0] = "0";
529         buffer[1] = "x";
530         for (uint256 i = 2 * length + 1; i > 1; --i) {
531             buffer[i] = alphabet[value & 0xf];
532             value >>= 4;
533         }
534         require(value == 0, "Strings: hex length insufficient");
535         return string(buffer);
536     }
537 
538 }
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev Interface of the ERC165 standard, as defined in the
544  * https://eips.ethereum.org/EIPS/eip-165[EIP].
545  *
546  * Implementers can declare support of contract interfaces, which can then be
547  * queried by others ({ERC165Checker}).
548  *
549  * For an implementation, see {ERC165}.
550  */
551 interface IERC165 {
552     /**
553      * @dev Returns true if this contract implements the interface defined by
554      * `interfaceId`. See the corresponding
555      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
556      * to learn more about how these ids are created.
557      *
558      * This function call must use less than 30 000 gas.
559      */
560     function supportsInterface(bytes4 interfaceId) external view returns (bool);
561 }
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev Implementation of the {IERC165} interface.
567  *
568  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
569  * for the additional interface id that will be supported. For example:
570  *
571  * ```solidity
572  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
573  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
574  * }
575  * ```
576  *
577  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
578  */
579 abstract contract ERC165 is IERC165 {
580     /**
581      * @dev See {IERC165-supportsInterface}.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
584         return interfaceId == type(IERC165).interfaceId;
585     }
586 }
587 
588 /**
589  * @dev External interface of AccessControl declared to support ERC165 detection.
590  */
591 interface IAccessControl {
592     function hasRole(bytes32 role, address account) external view returns (bool);
593     function getRoleAdmin(bytes32 role) external view returns (bytes32);
594     function grantRole(bytes32 role, address account) external;
595     function revokeRole(bytes32 role, address account) external;
596     function renounceRole(bytes32 role, address account) external;
597 }
598 
599 /**
600  * @dev Contract module that allows children to implement role-based access
601  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
602  * members except through off-chain means by accessing the contract event logs. Some
603  * applications may benefit from on-chain enumerability, for those cases see
604  * {AccessControlEnumerable}.
605  *
606  * Roles are referred to by their `bytes32` identifier. These should be exposed
607  * in the external API and be unique. The best way to achieve this is by
608  * using `public constant` hash digests:
609  *
610  * ```
611  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
612  * ```
613  *
614  * Roles can be used to represent a set of permissions. To restrict access to a
615  * function call, use {hasRole}:
616  *
617  * ```
618  * function foo() public {
619  *     require(hasRole(MY_ROLE, msg.sender));
620  *     ...
621  * }
622  * ```
623  *
624  * Roles can be granted and revoked dynamically via the {grantRole} and
625  * {revokeRole} functions. Each role has an associated admin role, and only
626  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
627  *
628  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
629  * that only accounts with this role will be able to grant or revoke other
630  * roles. More complex role relationships can be created by using
631  * {_setRoleAdmin}.
632  *
633  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
634  * grant and revoke this role. Extra precautions should be taken to secure
635  * accounts that have been granted it.
636  */
637 abstract contract AccessControl is Context, IAccessControl, ERC165 {
638     struct RoleData {
639         mapping (address => bool) members;
640         bytes32 adminRole;
641     }
642 
643     mapping (bytes32 => RoleData) private _roles;
644 
645     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
646 
647     /**
648      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
649      *
650      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
651      * {RoleAdminChanged} not being emitted signaling this.
652      *
653      * _Available since v3.1._
654      */
655     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
656 
657     /**
658      * @dev Emitted when `account` is granted `role`.
659      *
660      * `sender` is the account that originated the contract call, an admin role
661      * bearer except when using {_setupRole}.
662      */
663     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
664 
665     /**
666      * @dev Emitted when `account` is revoked `role`.
667      *
668      * `sender` is the account that originated the contract call:
669      *   - if using `revokeRole`, it is the admin role bearer
670      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
671      */
672     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
673 
674     /**
675      * @dev Modifier that checks that an account has a specific role. Reverts
676      * with a standardized message including the required role.
677      *
678      * The format of the revert reason is given by the following regular expression:
679      *
680      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
681      *
682      * _Available since v4.1._
683      */
684     modifier onlyRole(bytes32 role) {
685         _checkRole(role, _msgSender());
686         _;
687     }
688 
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IAccessControl).interfaceId
694             || super.supportsInterface(interfaceId);
695     }
696 
697     /**
698      * @dev Returns `true` if `account` has been granted `role`.
699      */
700     function hasRole(bytes32 role, address account) public view override returns (bool) {
701         return _roles[role].members[account];
702     }
703 
704     /**
705      * @dev Revert with a standard message if `account` is missing `role`.
706      *
707      * The format of the revert reason is given by the following regular expression:
708      *
709      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
710      */
711     function _checkRole(bytes32 role, address account) internal view {
712         if(!hasRole(role, account)) {
713             revert(string(abi.encodePacked(
714                 "AccessControl: account ",
715                 Strings.toHexString(uint160(account), 20),
716                 " is missing role ",
717                 Strings.toHexString(uint256(role), 32)
718             )));
719         }
720     }
721 
722     /**
723      * @dev Returns the admin role that controls `role`. See {grantRole} and
724      * {revokeRole}.
725      *
726      * To change a role's admin, use {_setRoleAdmin}.
727      */
728     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
729         return _roles[role].adminRole;
730     }
731 
732     /**
733      * @dev Grants `role` to `account`.
734      *
735      * If `account` had not been already granted `role`, emits a {RoleGranted}
736      * event.
737      *
738      * Requirements:
739      *
740      * - the caller must have ``role``'s admin role.
741      */
742     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
743         _grantRole(role, account);
744     }
745 
746     /**
747      * @dev Revokes `role` from `account`.
748      *
749      * If `account` had been granted `role`, emits a {RoleRevoked} event.
750      *
751      * Requirements:
752      *
753      * - the caller must have ``role``'s admin role.
754      */
755     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
756         _revokeRole(role, account);
757     }
758 
759     /**
760      * @dev Revokes `role` from the calling account.
761      *
762      * Roles are often managed via {grantRole} and {revokeRole}: this function's
763      * purpose is to provide a mechanism for accounts to lose their privileges
764      * if they are compromised (such as when a trusted device is misplaced).
765      *
766      * If the calling account had been granted `role`, emits a {RoleRevoked}
767      * event.
768      *
769      * Requirements:
770      *
771      * - the caller must be `account`.
772      */
773     function renounceRole(bytes32 role, address account) public virtual override {
774         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
775 
776         _revokeRole(role, account);
777     }
778 
779     /**
780      * @dev Grants `role` to `account`.
781      *
782      * If `account` had not been already granted `role`, emits a {RoleGranted}
783      * event. Note that unlike {grantRole}, this function doesn't perform any
784      * checks on the calling account.
785      *
786      * [WARNING]
787      * ====
788      * This function should only be called from the constructor when setting
789      * up the initial roles for the system.
790      *
791      * Using this function in any other way is effectively circumventing the admin
792      * system imposed by {AccessControl}.
793      * ====
794      */
795     function _setupRole(bytes32 role, address account) internal virtual {
796         _grantRole(role, account);
797     }
798 
799     /**
800      * @dev Sets `adminRole` as ``role``'s admin role.
801      *
802      * Emits a {RoleAdminChanged} event.
803      */
804     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
805         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
806         _roles[role].adminRole = adminRole;
807     }
808 
809     function _grantRole(bytes32 role, address account) private {
810         if (!hasRole(role, account)) {
811             _roles[role].members[account] = true;
812             emit RoleGranted(role, account, _msgSender());
813         }
814     }
815 
816     function _revokeRole(bytes32 role, address account) private {
817         if (hasRole(role, account)) {
818             _roles[role].members[account] = false;
819             emit RoleRevoked(role, account, _msgSender());
820         }
821     }
822 }
823 
824 pragma solidity ^0.8.4;
825 
826 contract WGRLC is Burnable, AccessControl {
827 
828     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
829 
830     constructor(string memory name, string memory symbol) BEP20(name, symbol) {
831         _setupRole(MINTER_ROLE, msg.sender);
832         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
833     }
834 
835     function mint(uint256 amount) public virtual {
836         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
837         _mint(msg.sender, amount);
838     }
839 
840     function mintTo(address account, uint256 amount) public virtual {
841         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
842         _mint(account, amount);
843     }
844 
845 }