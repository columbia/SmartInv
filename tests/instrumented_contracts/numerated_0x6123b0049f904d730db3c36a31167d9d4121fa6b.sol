1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 interface IERC20Metadata is IERC20 {
79     /**
80      * @dev Returns the name of the token.
81      */
82     function name() external view returns (string memory);
83 
84     /**
85      * @dev Returns the symbol of the token.
86      */
87     function symbol() external view returns (string memory);
88 
89     /**
90      * @dev Returns the decimals places of the token.
91      */
92     function decimals() external view returns (uint8);
93 }
94 
95 
96 /*
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes calldata) {
112         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
113         return msg.data;
114     }
115 }
116 
117 /**
118  * @dev Implementation of the {IERC20} interface.
119  *
120  * This implementation is agnostic to the way tokens are created. This means
121  * that a supply mechanism has to be added in a derived contract using {_mint}.
122  * For a generic mechanism see {ERC20PresetMinterPauser}.
123  *
124  * TIP: For a detailed writeup see our guide
125  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
126  * to implement supply mechanisms].
127  *
128  * We have followed general OpenZeppelin guidelines: functions revert instead
129  * of returning `false` on failure. This behavior is nonetheless conventional
130  * and does not conflict with the expectations of ERC20 applications.
131  *
132  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
133  * This allows applications to reconstruct the allowance for all accounts just
134  * by listening to said events. Other implementations of the EIP may not emit
135  * these events, as it isn't required by the specification.
136  *
137  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
138  * functions have been added to mitigate the well-known issues around setting
139  * allowances. See {IERC20-approve}.
140  */
141 contract ERC20 is Context, IERC20, IERC20Metadata {
142     mapping (address => uint256) private _balances;
143 
144     mapping (address => mapping (address => uint256)) private _allowances;
145 
146     uint256 private _totalSupply;
147 
148     string private _name;
149     string private _symbol;
150 
151     /**
152      * @dev Sets the values for {name} and {symbol}.
153      *
154      * The defaut value of {decimals} is 18. To select a different value for
155      * {decimals} you should overload it.
156      *
157      * All two of these values are immutable: they can only be set once during
158      * construction.
159      */
160     constructor (string memory name_, string memory symbol_) {
161         _name = name_;
162         _symbol = symbol_;
163     }
164 
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() public view virtual override returns (string memory) {
169         return _name;
170     }
171 
172     /**
173      * @dev Returns the symbol of the token, usually a shorter version of the
174      * name.
175      */
176     function symbol() public view virtual override returns (string memory) {
177         return _symbol;
178     }
179 
180     /**
181      * @dev Returns the number of decimals used to get its user representation.
182      * For example, if `decimals` equals `2`, a balance of `505` tokens should
183      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
184      *
185      * Tokens usually opt for a value of 18, imitating the relationship between
186      * Ether and Wei. This is the value {ERC20} uses, unless this function is
187      * overridden;
188      *
189      * NOTE: This information is only used for _display_ purposes: it in
190      * no way affects any of the arithmetic of the contract, including
191      * {IERC20-balanceOf} and {IERC20-transfer}.
192      */
193     function decimals() public view virtual override returns (uint8) {
194         return 18;
195     }
196 
197     /**
198      * @dev See {IERC20-totalSupply}.
199      */
200     function totalSupply() public view virtual override returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See {IERC20-balanceOf}.
206      */
207     function balanceOf(address account) public view virtual override returns (uint256) {
208         return _balances[account];
209     }
210 
211     /**
212      * @dev See {IERC20-transfer}.
213      *
214      * Requirements:
215      *
216      * - `recipient` cannot be the zero address.
217      * - the caller must have a balance of at least `amount`.
218      */
219     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     /**
225      * @dev See {IERC20-allowance}.
226      */
227     function allowance(address owner, address spender) public view virtual override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     /**
232      * @dev See {IERC20-approve}.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      */
238     function approve(address spender, uint256 amount) public virtual override returns (bool) {
239         _approve(_msgSender(), spender, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See {IERC20-transferFrom}.
245      *
246      * Emits an {Approval} event indicating the updated allowance. This is not
247      * required by the EIP. See the note at the beginning of {ERC20}.
248      *
249      * Requirements:
250      *
251      * - `sender` and `recipient` cannot be the zero address.
252      * - `sender` must have a balance of at least `amount`.
253      * - the caller must have allowance for ``sender``'s tokens of at least
254      * `amount`.
255      */
256     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
257         _transfer(sender, recipient, amount);
258 
259         uint256 currentAllowance = _allowances[sender][_msgSender()];
260         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
261         _approve(sender, _msgSender(), currentAllowance - amount);
262 
263         return true;
264     }
265 
266     /**
267      * @dev Atomically increases the allowance granted to `spender` by the caller.
268      *
269      * This is an alternative to {approve} that can be used as a mitigation for
270      * problems described in {IERC20-approve}.
271      *
272      * Emits an {Approval} event indicating the updated allowance.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
279         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
280         return true;
281     }
282 
283     /**
284      * @dev Atomically decreases the allowance granted to `spender` by the caller.
285      *
286      * This is an alternative to {approve} that can be used as a mitigation for
287      * problems described in {IERC20-approve}.
288      *
289      * Emits an {Approval} event indicating the updated allowance.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      * - `spender` must have allowance for the caller of at least
295      * `subtractedValue`.
296      */
297     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
298         uint256 currentAllowance = _allowances[_msgSender()][spender];
299         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
300         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
301 
302         return true;
303     }
304 
305     /**
306      * @dev Moves tokens `amount` from `sender` to `recipient`.
307      *
308      * This is internal function is equivalent to {transfer}, and can be used to
309      * e.g. implement automatic token fees, slashing mechanisms, etc.
310      *
311      * Emits a {Transfer} event.
312      *
313      * Requirements:
314      *
315      * - `sender` cannot be the zero address.
316      * - `recipient` cannot be the zero address.
317      * - `sender` must have a balance of at least `amount`.
318      */
319     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322 
323         _beforeTokenTransfer(sender, recipient, amount);
324 
325         uint256 senderBalance = _balances[sender];
326         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
327         _balances[sender] = senderBalance - amount;
328         _balances[recipient] += amount;
329 
330         emit Transfer(sender, recipient, amount);
331     }
332 
333     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
334      * the total supply.
335      *
336      * Emits a {Transfer} event with `from` set to the zero address.
337      *
338      * Requirements:
339      *
340      * - `to` cannot be the zero address.
341      */
342     function _mint(address account, uint256 amount) internal virtual {
343         require(account != address(0), "ERC20: mint to the zero address");
344 
345         _beforeTokenTransfer(address(0), account, amount);
346 
347         _totalSupply += amount;
348         _balances[account] += amount;
349         emit Transfer(address(0), account, amount);
350     }
351 
352     /**
353      * @dev Destroys `amount` tokens from `account`, reducing the
354      * total supply.
355      *
356      * Emits a {Transfer} event with `to` set to the zero address.
357      *
358      * Requirements:
359      *
360      * - `account` cannot be the zero address.
361      * - `account` must have at least `amount` tokens.
362      */
363     function _burn(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20: burn from the zero address");
365 
366         _beforeTokenTransfer(account, address(0), amount);
367 
368         uint256 accountBalance = _balances[account];
369         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
370         _balances[account] = accountBalance - amount;
371         _totalSupply -= amount;
372 
373         emit Transfer(account, address(0), amount);
374     }
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
378      *
379      * This internal function is equivalent to `approve`, and can be used to
380      * e.g. set automatic allowances for certain subsystems, etc.
381      *
382      * Emits an {Approval} event.
383      *
384      * Requirements:
385      *
386      * - `owner` cannot be the zero address.
387      * - `spender` cannot be the zero address.
388      */
389     function _approve(address owner, address spender, uint256 amount) internal virtual {
390         require(owner != address(0), "ERC20: approve from the zero address");
391         require(spender != address(0), "ERC20: approve to the zero address");
392 
393         _allowances[owner][spender] = amount;
394         emit Approval(owner, spender, amount);
395     }
396 
397     /**
398      * @dev Hook that is called before any transfer of tokens. This includes
399      * minting and burning.
400      *
401      * Calling conditions:
402      *
403      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
404      * will be to transferred to `to`.
405      * - when `from` is zero, `amount` tokens will be minted for `to`.
406      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
407      * - `from` and `to` are never both zero.
408      *
409      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
410      */
411     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
412 }
413 
414 
415 /**
416  * @dev String operations.
417  */
418 library Strings {
419     bytes16 private constant alphabet = "0123456789abcdef";
420 
421     /**
422      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
423      */
424     function toString(uint256 value) internal pure returns (string memory) {
425         // Inspired by OraclizeAPI's implementation - MIT licence
426         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
427 
428         if (value == 0) {
429             return "0";
430         }
431         uint256 temp = value;
432         uint256 digits;
433         while (temp != 0) {
434             digits++;
435             temp /= 10;
436         }
437         bytes memory buffer = new bytes(digits);
438         while (value != 0) {
439             digits -= 1;
440             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
441             value /= 10;
442         }
443         return string(buffer);
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
448      */
449     function toHexString(uint256 value) internal pure returns (string memory) {
450         if (value == 0) {
451             return "0x00";
452         }
453         uint256 temp = value;
454         uint256 length = 0;
455         while (temp != 0) {
456             length++;
457             temp >>= 8;
458         }
459         return toHexString(value, length);
460     }
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
464      */
465     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
466         bytes memory buffer = new bytes(2 * length + 2);
467         buffer[0] = "0";
468         buffer[1] = "x";
469         for (uint256 i = 2 * length + 1; i > 1; --i) {
470             buffer[i] = alphabet[value & 0xf];
471             value >>= 4;
472         }
473         require(value == 0, "Strings: hex length insufficient");
474         return string(buffer);
475     }
476 
477 }
478 
479 
480 
481 /**
482  * @dev External interface of AccessControl declared to support ERC165 detection.
483  */
484 interface IAccessControl {
485     function hasRole(bytes32 role, address account) external view returns (bool);
486     function getRoleAdmin(bytes32 role) external view returns (bytes32);
487     function grantRole(bytes32 role, address account) external;
488     function revokeRole(bytes32 role, address account) external;
489     function renounceRole(bytes32 role, address account) external;
490 }
491 
492 interface IERC165 {
493     /**
494      * @dev Returns true if this contract implements the interface defined by
495      * `interfaceId`. See the corresponding
496      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
497      * to learn more about how these ids are created.
498      *
499      * This function call must use less than 30 000 gas.
500      */
501     function supportsInterface(bytes4 interfaceId) external view returns (bool);
502 }
503 
504 
505 abstract contract ERC165 is IERC165 {
506     /**
507      * @dev See {IERC165-supportsInterface}.
508      */
509     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510         return interfaceId == type(IERC165).interfaceId;
511     }
512 }
513 
514 /**
515  * @dev Contract module that allows children to implement role-based access
516  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
517  * members except through off-chain means by accessing the contract event logs. Some
518  * applications may benefit from on-chain enumerability, for those cases see
519  * {AccessControlEnumerable}.
520  *
521  * Roles are referred to by their `bytes32` identifier. These should be exposed
522  * in the external API and be unique. The best way to achieve this is by
523  * using `public constant` hash digests:
524  *
525  * ```
526  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
527  * ```
528  *
529  * Roles can be used to represent a set of permissions. To restrict access to a
530  * function call, use {hasRole}:
531  *
532  * ```
533  * function foo() public {
534  *     require(hasRole(MY_ROLE, msg.sender));
535  *     ...
536  * }
537  * ```
538  *
539  * Roles can be granted and revoked dynamically via the {grantRole} and
540  * {revokeRole} functions. Each role has an associated admin role, and only
541  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
542  *
543  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
544  * that only accounts with this role will be able to grant or revoke other
545  * roles. More complex role relationships can be created by using
546  * {_setRoleAdmin}.
547  *
548  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
549  * grant and revoke this role. Extra precautions should be taken to secure
550  * accounts that have been granted it.
551  */
552 abstract contract AccessControl is Context, IAccessControl, ERC165 {
553     struct RoleData {
554         mapping (address => bool) members;
555         bytes32 adminRole;
556     }
557 
558     mapping (bytes32 => RoleData) private _roles;
559 
560     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
561 
562     /**
563      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
564      *
565      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
566      * {RoleAdminChanged} not being emitted signaling this.
567      *
568      * _Available since v3.1._
569      */
570     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
571 
572     /**
573      * @dev Emitted when `account` is granted `role`.
574      *
575      * `sender` is the account that originated the contract call, an admin role
576      * bearer except when using {_setupRole}.
577      */
578     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
579 
580     /**
581      * @dev Emitted when `account` is revoked `role`.
582      *
583      * `sender` is the account that originated the contract call:
584      *   - if using `revokeRole`, it is the admin role bearer
585      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
586      */
587     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
588 
589     /**
590      * @dev Modifier that checks that an account has a specific role. Reverts
591      * with a standardized message including the required role.
592      *
593      * The format of the revert reason is given by the following regular expression:
594      *
595      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
596      *
597      * _Available since v4.1._
598      */
599     modifier onlyRole(bytes32 role) {
600         _checkRole(role, _msgSender());
601         _;
602     }
603 
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608         return interfaceId == type(IAccessControl).interfaceId
609             || super.supportsInterface(interfaceId);
610     }
611 
612     /**
613      * @dev Returns `true` if `account` has been granted `role`.
614      */
615     function hasRole(bytes32 role, address account) public view override returns (bool) {
616         return _roles[role].members[account];
617     }
618 
619     /**
620      * @dev Revert with a standard message if `account` is missing `role`.
621      *
622      * The format of the revert reason is given by the following regular expression:
623      *
624      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
625      */
626     function _checkRole(bytes32 role, address account) internal view {
627         if(!hasRole(role, account)) {
628             revert(string(abi.encodePacked(
629                 "AccessControl: account ",
630                 Strings.toHexString(uint160(account), 20),
631                 " is missing role ",
632                 Strings.toHexString(uint256(role), 32)
633             )));
634         }
635     }
636 
637     /**
638      * @dev Returns the admin role that controls `role`. See {grantRole} and
639      * {revokeRole}.
640      *
641      * To change a role's admin, use {_setRoleAdmin}.
642      */
643     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
644         return _roles[role].adminRole;
645     }
646 
647     /**
648      * @dev Grants `role` to `account`.
649      *
650      * If `account` had not been already granted `role`, emits a {RoleGranted}
651      * event.
652      *
653      * Requirements:
654      *
655      * - the caller must have ``role``'s admin role.
656      */
657     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
658         _grantRole(role, account);
659     }
660 
661     /**
662      * @dev Revokes `role` from `account`.
663      *
664      * If `account` had been granted `role`, emits a {RoleRevoked} event.
665      *
666      * Requirements:
667      *
668      * - the caller must have ``role``'s admin role.
669      */
670     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
671         _revokeRole(role, account);
672     }
673 
674     /**
675      * @dev Revokes `role` from the calling account.
676      *
677      * Roles are often managed via {grantRole} and {revokeRole}: this function's
678      * purpose is to provide a mechanism for accounts to lose their privileges
679      * if they are compromised (such as when a trusted device is misplaced).
680      *
681      * If the calling account had been granted `role`, emits a {RoleRevoked}
682      * event.
683      *
684      * Requirements:
685      *
686      * - the caller must be `account`.
687      */
688     function renounceRole(bytes32 role, address account) public virtual override {
689         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
690 
691         _revokeRole(role, account);
692     }
693 
694     /**
695      * @dev Grants `role` to `account`.
696      *
697      * If `account` had not been already granted `role`, emits a {RoleGranted}
698      * event. Note that unlike {grantRole}, this function doesn't perform any
699      * checks on the calling account.
700      *
701      * [WARNING]
702      * ====
703      * This function should only be called from the constructor when setting
704      * up the initial roles for the system.
705      *
706      * Using this function in any other way is effectively circumventing the admin
707      * system imposed by {AccessControl}.
708      * ====
709      */
710     function _setupRole(bytes32 role, address account) internal virtual {
711         _grantRole(role, account);
712     }
713 
714     /**
715      * @dev Sets `adminRole` as ``role``'s admin role.
716      *
717      * Emits a {RoleAdminChanged} event.
718      */
719     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
720         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
721         _roles[role].adminRole = adminRole;
722     }
723 
724     function _grantRole(bytes32 role, address account) private {
725         if (!hasRole(role, account)) {
726             _roles[role].members[account] = true;
727             emit RoleGranted(role, account, _msgSender());
728         }
729     }
730 
731     function _revokeRole(bytes32 role, address account) private {
732         if (hasRole(role, account)) {
733             _roles[role].members[account] = false;
734             emit RoleRevoked(role, account, _msgSender());
735         }
736     }
737 }
738 
739 
740 
741 /**
742  * RIBBON FINANCE: STRUCTURED PRODUCTS FOR THE PEOPLE
743  */
744 contract RibbonToken is AccessControl, ERC20 {
745     /// @dev The identifier of the role which maintains other roles.
746     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
747     /// @dev The identifier of the role which allows accounts to mint tokens.
748     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
749     /// @dev The identifier of the role which allows special transfer privileges.
750     bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER");
751 
752     /// @dev bool flag of whether transfer is currently allowed for all people.
753     bool public transfersAllowed = false;
754 
755     constructor(
756         string memory name,
757         string memory symbol,
758         uint256 totalSupply,
759         address beneficiary
760     ) ERC20(name, symbol) {
761         // We are minting initialSupply number of tokens
762         _mint(beneficiary, totalSupply);
763         // Add beneficiary as minter
764         _setupRole(MINTER_ROLE, beneficiary);
765         // Add beneficiary as transferer
766         _setupRole(TRANSFER_ROLE, beneficiary);
767         // Add beneficiary as admin
768         _setupRole(ADMIN_ROLE, beneficiary);
769         // Set ADMIN role as admin of transfer role
770         _setRoleAdmin(TRANSFER_ROLE, ADMIN_ROLE);
771     }
772 
773     /// @dev A modifier which checks that the caller has the minter role.
774     modifier onlyMinter() {
775         require(hasRole(MINTER_ROLE, msg.sender), "RibbonToken: only minter");
776         _;
777     }
778 
779     /// @dev A modifier which checks that the caller has the admin role.
780     modifier onlyAdmin() {
781         require(hasRole(ADMIN_ROLE, msg.sender), "RibbonToken: only admin");
782         _;
783     }
784 
785     /// @dev A modifier which checks that the caller has transfer privileges.
786     modifier onlyTransferer(address from) {
787         require(
788             transfersAllowed ||
789                 from == address(0) ||
790                 hasRole(TRANSFER_ROLE, msg.sender),
791             "RibbonToken: no transfer privileges"
792         );
793         _;
794     }
795 
796     /// @dev Mints tokens to a recipient.
797     ///
798     /// This function reverts if the caller does not have the minter role.
799     function mint(address _recipient, uint256 _amount) external onlyMinter {
800         _mint(_recipient, _amount);
801     }
802 
803     /// @dev Toggles transfer allowed flag.
804     ///
805     /// This function reverts if the caller does not have the admin role.
806     function setTransfersAllowed(bool _transfersAllowed) external onlyAdmin {
807         transfersAllowed = _transfersAllowed;
808         emit TransfersAllowed(transfersAllowed);
809     }
810 
811     /// @dev Hook that is called before any transfer of tokens.
812     function _beforeTokenTransfer(
813         address from,
814         address to,
815         uint256 amount
816     ) internal virtual override onlyTransferer(from) {}
817 
818     /// @dev Emitted when transfer toggle is switched
819     event TransfersAllowed(bool transfersAllowed);
820 }