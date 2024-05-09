1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/utils/Strings.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev String operations.
36  */
37 library Strings {
38     bytes16 private constant alphabet = "0123456789abcdef";
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
42      */
43     function toString(uint256 value) internal pure returns (string memory) {
44         // Inspired by OraclizeAPI's implementation - MIT licence
45         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
46 
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
67      */
68     function toHexString(uint256 value) internal pure returns (string memory) {
69         if (value == 0) {
70             return "0x00";
71         }
72         uint256 temp = value;
73         uint256 length = 0;
74         while (temp != 0) {
75             length++;
76             temp >>= 8;
77         }
78         return toHexString(value, length);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
83      */
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = alphabet[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 
96 }
97 
98 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
99 
100 
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Interface of the ERC165 standard, as defined in the
106  * https://eips.ethereum.org/EIPS/eip-165[EIP].
107  *
108  * Implementers can declare support of contract interfaces, which can then be
109  * queried by others ({ERC165Checker}).
110  *
111  * For an implementation, see {ERC165}.
112  */
113 interface IERC165 {
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30 000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 }
124 
125 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
126 
127 
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Implementation of the {IERC165} interface.
134  *
135  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
136  * for the additional interface id that will be supported. For example:
137  *
138  * ```solidity
139  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
140  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
141  * }
142  * ```
143  *
144  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
145  */
146 abstract contract ERC165 is IERC165 {
147     /**
148      * @dev See {IERC165-supportsInterface}.
149      */
150     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
151         return interfaceId == type(IERC165).interfaceId;
152     }
153 }
154 
155 // File: @openzeppelin/contracts/access/AccessControl.sol
156 
157 
158 
159 pragma solidity ^0.8.0;
160 
161 
162 
163 
164 /**
165  * @dev External interface of AccessControl declared to support ERC165 detection.
166  */
167 interface IAccessControl {
168     function hasRole(bytes32 role, address account) external view returns (bool);
169     function getRoleAdmin(bytes32 role) external view returns (bytes32);
170     function grantRole(bytes32 role, address account) external;
171     function revokeRole(bytes32 role, address account) external;
172     function renounceRole(bytes32 role, address account) external;
173 }
174 
175 /**
176  * @dev Contract module that allows children to implement role-based access
177  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
178  * members except through off-chain means by accessing the contract event logs. Some
179  * applications may benefit from on-chain enumerability, for those cases see
180  * {AccessControlEnumerable}.
181  *
182  * Roles are referred to by their `bytes32` identifier. These should be exposed
183  * in the external API and be unique. The best way to achieve this is by
184  * using `public constant` hash digests:
185  *
186  * ```
187  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
188  * ```
189  *
190  * Roles can be used to represent a set of permissions. To restrict access to a
191  * function call, use {hasRole}:
192  *
193  * ```
194  * function foo() public {
195  *     require(hasRole(MY_ROLE, msg.sender));
196  *     ...
197  * }
198  * ```
199  *
200  * Roles can be granted and revoked dynamically via the {grantRole} and
201  * {revokeRole} functions. Each role has an associated admin role, and only
202  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
203  *
204  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
205  * that only accounts with this role will be able to grant or revoke other
206  * roles. More complex role relationships can be created by using
207  * {_setRoleAdmin}.
208  *
209  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
210  * grant and revoke this role. Extra precautions should be taken to secure
211  * accounts that have been granted it.
212  */
213 abstract contract AccessControl is Context, IAccessControl, ERC165 {
214     struct RoleData {
215         mapping (address => bool) members;
216         bytes32 adminRole;
217     }
218 
219     mapping (bytes32 => RoleData) private _roles;
220 
221     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
222 
223     /**
224      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
225      *
226      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
227      * {RoleAdminChanged} not being emitted signaling this.
228      *
229      * _Available since v3.1._
230      */
231     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
232 
233     /**
234      * @dev Emitted when `account` is granted `role`.
235      *
236      * `sender` is the account that originated the contract call, an admin role
237      * bearer except when using {_setupRole}.
238      */
239     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
240 
241     /**
242      * @dev Emitted when `account` is revoked `role`.
243      *
244      * `sender` is the account that originated the contract call:
245      *   - if using `revokeRole`, it is the admin role bearer
246      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
247      */
248     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
249 
250     /**
251      * @dev Modifier that checks that an account has a specific role. Reverts
252      * with a standardized message including the required role.
253      *
254      * The format of the revert reason is given by the following regular expression:
255      *
256      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
257      *
258      * _Available since v4.1._
259      */
260     modifier onlyRole(bytes32 role) {
261         _checkRole(role, _msgSender());
262         _;
263     }
264 
265     /**
266      * @dev See {IERC165-supportsInterface}.
267      */
268     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
269         return interfaceId == type(IAccessControl).interfaceId
270             || super.supportsInterface(interfaceId);
271     }
272 
273     /**
274      * @dev Returns `true` if `account` has been granted `role`.
275      */
276     function hasRole(bytes32 role, address account) public view override returns (bool) {
277         return _roles[role].members[account];
278     }
279 
280     /**
281      * @dev Revert with a standard message if `account` is missing `role`.
282      *
283      * The format of the revert reason is given by the following regular expression:
284      *
285      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
286      */
287     function _checkRole(bytes32 role, address account) internal view {
288         if(!hasRole(role, account)) {
289             revert(string(abi.encodePacked(
290                 "AccessControl: account ",
291                 Strings.toHexString(uint160(account), 20),
292                 " is missing role ",
293                 Strings.toHexString(uint256(role), 32)
294             )));
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
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @dev Interface of the ERC20 standard as defined in the EIP.
408  */
409 interface IERC20 {
410     /**
411      * @dev Returns the amount of tokens in existence.
412      */
413     function totalSupply() external view returns (uint256);
414 
415     /**
416      * @dev Returns the amount of tokens owned by `account`.
417      */
418     function balanceOf(address account) external view returns (uint256);
419 
420     /**
421      * @dev Moves `amount` tokens from the caller's account to `recipient`.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transfer(address recipient, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Returns the remaining number of tokens that `spender` will be
431      * allowed to spend on behalf of `owner` through {transferFrom}. This is
432      * zero by default.
433      *
434      * This value changes when {approve} or {transferFrom} are called.
435      */
436     function allowance(address owner, address spender) external view returns (uint256);
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * IMPORTANT: Beware that changing an allowance with this method brings the risk
444      * that someone may use both the old and the new allowance by unfortunate
445      * transaction ordering. One possible solution to mitigate this race
446      * condition is to first reduce the spender's allowance to 0 and set the
447      * desired value afterwards:
448      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
449      *
450      * Emits an {Approval} event.
451      */
452     function approve(address spender, uint256 amount) external returns (bool);
453 
454     /**
455      * @dev Moves `amount` tokens from `sender` to `recipient` using the
456      * allowance mechanism. `amount` is then deducted from the caller's
457      * allowance.
458      *
459      * Returns a boolean value indicating whether the operation succeeded.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
464 
465     /**
466      * @dev Emitted when `value` tokens are moved from one account (`from`) to
467      * another (`to`).
468      *
469      * Note that `value` may be zero.
470      */
471     event Transfer(address indexed from, address indexed to, uint256 value);
472 
473     /**
474      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
475      * a call to {approve}. `value` is the new allowance.
476      */
477     event Approval(address indexed owner, address indexed spender, uint256 value);
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
481 
482 
483 
484 pragma solidity ^0.8.0;
485 
486 
487 /**
488  * @dev Interface for the optional metadata functions from the ERC20 standard.
489  *
490  * _Available since v4.1._
491  */
492 interface IERC20Metadata is IERC20 {
493     /**
494      * @dev Returns the name of the token.
495      */
496     function name() external view returns (string memory);
497 
498     /**
499      * @dev Returns the symbol of the token.
500      */
501     function symbol() external view returns (string memory);
502 
503     /**
504      * @dev Returns the decimals places of the token.
505      */
506     function decimals() external view returns (uint8);
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 
516 
517 
518 /**
519  * @dev Implementation of the {IERC20} interface.
520  *
521  * This implementation is agnostic to the way tokens are created. This means
522  * that a supply mechanism has to be added in a derived contract using {_mint}.
523  * For a generic mechanism see {ERC20PresetMinterPauser}.
524  *
525  * TIP: For a detailed writeup see our guide
526  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
527  * to implement supply mechanisms].
528  *
529  * We have followed general OpenZeppelin guidelines: functions revert instead
530  * of returning `false` on failure. This behavior is nonetheless conventional
531  * and does not conflict with the expectations of ERC20 applications.
532  *
533  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
534  * This allows applications to reconstruct the allowance for all accounts just
535  * by listening to said events. Other implementations of the EIP may not emit
536  * these events, as it isn't required by the specification.
537  *
538  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
539  * functions have been added to mitigate the well-known issues around setting
540  * allowances. See {IERC20-approve}.
541  */
542 contract ERC20 is Context, IERC20, IERC20Metadata {
543     mapping (address => uint256) private _balances;
544 
545     mapping (address => mapping (address => uint256)) private _allowances;
546 
547     uint256 private _totalSupply;
548 
549     string private _name;
550     string private _symbol;
551 
552     /**
553      * @dev Sets the values for {name} and {symbol}.
554      *
555      * The defaut value of {decimals} is 18. To select a different value for
556      * {decimals} you should overload it.
557      *
558      * All two of these values are immutable: they can only be set once during
559      * construction.
560      */
561     constructor (string memory name_, string memory symbol_) {
562         _name = name_;
563         _symbol = symbol_;
564     }
565 
566     /**
567      * @dev Returns the name of the token.
568      */
569     function name() public view virtual override returns (string memory) {
570         return _name;
571     }
572 
573     /**
574      * @dev Returns the symbol of the token, usually a shorter version of the
575      * name.
576      */
577     function symbol() public view virtual override returns (string memory) {
578         return _symbol;
579     }
580 
581     /**
582      * @dev Returns the number of decimals used to get its user representation.
583      * For example, if `decimals` equals `2`, a balance of `505` tokens should
584      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
585      *
586      * Tokens usually opt for a value of 18, imitating the relationship between
587      * Ether and Wei. This is the value {ERC20} uses, unless this function is
588      * overridden;
589      *
590      * NOTE: This information is only used for _display_ purposes: it in
591      * no way affects any of the arithmetic of the contract, including
592      * {IERC20-balanceOf} and {IERC20-transfer}.
593      */
594     function decimals() public view virtual override returns (uint8) {
595         return 18;
596     }
597 
598     /**
599      * @dev See {IERC20-totalSupply}.
600      */
601     function totalSupply() public view virtual override returns (uint256) {
602         return _totalSupply;
603     }
604 
605     /**
606      * @dev See {IERC20-balanceOf}.
607      */
608     function balanceOf(address account) public view virtual override returns (uint256) {
609         return _balances[account];
610     }
611 
612     /**
613      * @dev See {IERC20-transfer}.
614      *
615      * Requirements:
616      *
617      * - `recipient` cannot be the zero address.
618      * - the caller must have a balance of at least `amount`.
619      */
620     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
621         _transfer(_msgSender(), recipient, amount);
622         return true;
623     }
624 
625     /**
626      * @dev See {IERC20-allowance}.
627      */
628     function allowance(address owner, address spender) public view virtual override returns (uint256) {
629         return _allowances[owner][spender];
630     }
631 
632     /**
633      * @dev See {IERC20-approve}.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      */
639     function approve(address spender, uint256 amount) public virtual override returns (bool) {
640         _approve(_msgSender(), spender, amount);
641         return true;
642     }
643 
644     /**
645      * @dev See {IERC20-transferFrom}.
646      *
647      * Emits an {Approval} event indicating the updated allowance. This is not
648      * required by the EIP. See the note at the beginning of {ERC20}.
649      *
650      * Requirements:
651      *
652      * - `sender` and `recipient` cannot be the zero address.
653      * - `sender` must have a balance of at least `amount`.
654      * - the caller must have allowance for ``sender``'s tokens of at least
655      * `amount`.
656      */
657     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
658         _transfer(sender, recipient, amount);
659 
660         uint256 currentAllowance = _allowances[sender][_msgSender()];
661         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
662         _approve(sender, _msgSender(), currentAllowance - amount);
663 
664         return true;
665     }
666 
667     /**
668      * @dev Atomically increases the allowance granted to `spender` by the caller.
669      *
670      * This is an alternative to {approve} that can be used as a mitigation for
671      * problems described in {IERC20-approve}.
672      *
673      * Emits an {Approval} event indicating the updated allowance.
674      *
675      * Requirements:
676      *
677      * - `spender` cannot be the zero address.
678      */
679     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
680         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
681         return true;
682     }
683 
684     /**
685      * @dev Atomically decreases the allowance granted to `spender` by the caller.
686      *
687      * This is an alternative to {approve} that can be used as a mitigation for
688      * problems described in {IERC20-approve}.
689      *
690      * Emits an {Approval} event indicating the updated allowance.
691      *
692      * Requirements:
693      *
694      * - `spender` cannot be the zero address.
695      * - `spender` must have allowance for the caller of at least
696      * `subtractedValue`.
697      */
698     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
699         uint256 currentAllowance = _allowances[_msgSender()][spender];
700         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
701         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
702 
703         return true;
704     }
705 
706     /**
707      * @dev Moves tokens `amount` from `sender` to `recipient`.
708      *
709      * This is internal function is equivalent to {transfer}, and can be used to
710      * e.g. implement automatic token fees, slashing mechanisms, etc.
711      *
712      * Emits a {Transfer} event.
713      *
714      * Requirements:
715      *
716      * - `sender` cannot be the zero address.
717      * - `recipient` cannot be the zero address.
718      * - `sender` must have a balance of at least `amount`.
719      */
720     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
721         require(sender != address(0), "ERC20: transfer from the zero address");
722         require(recipient != address(0), "ERC20: transfer to the zero address");
723 
724         _beforeTokenTransfer(sender, recipient, amount);
725 
726         uint256 senderBalance = _balances[sender];
727         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
728         _balances[sender] = senderBalance - amount;
729         _balances[recipient] += amount;
730 
731         emit Transfer(sender, recipient, amount);
732     }
733 
734     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
735      * the total supply.
736      *
737      * Emits a {Transfer} event with `from` set to the zero address.
738      *
739      * Requirements:
740      *
741      * - `to` cannot be the zero address.
742      */
743     function _mint(address account, uint256 amount) internal virtual {
744         require(account != address(0), "ERC20: mint to the zero address");
745 
746         _beforeTokenTransfer(address(0), account, amount);
747 
748         _totalSupply += amount;
749         _balances[account] += amount;
750         emit Transfer(address(0), account, amount);
751     }
752 
753     /**
754      * @dev Destroys `amount` tokens from `account`, reducing the
755      * total supply.
756      *
757      * Emits a {Transfer} event with `to` set to the zero address.
758      *
759      * Requirements:
760      *
761      * - `account` cannot be the zero address.
762      * - `account` must have at least `amount` tokens.
763      */
764     function _burn(address account, uint256 amount) internal virtual {
765         require(account != address(0), "ERC20: burn from the zero address");
766 
767         _beforeTokenTransfer(account, address(0), amount);
768 
769         uint256 accountBalance = _balances[account];
770         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
771         _balances[account] = accountBalance - amount;
772         _totalSupply -= amount;
773 
774         emit Transfer(account, address(0), amount);
775     }
776 
777     /**
778      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
779      *
780      * This internal function is equivalent to `approve`, and can be used to
781      * e.g. set automatic allowances for certain subsystems, etc.
782      *
783      * Emits an {Approval} event.
784      *
785      * Requirements:
786      *
787      * - `owner` cannot be the zero address.
788      * - `spender` cannot be the zero address.
789      */
790     function _approve(address owner, address spender, uint256 amount) internal virtual {
791         require(owner != address(0), "ERC20: approve from the zero address");
792         require(spender != address(0), "ERC20: approve to the zero address");
793 
794         _allowances[owner][spender] = amount;
795         emit Approval(owner, spender, amount);
796     }
797 
798     /**
799      * @dev Hook that is called before any transfer of tokens. This includes
800      * minting and burning.
801      *
802      * Calling conditions:
803      *
804      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
805      * will be to transferred to `to`.
806      * - when `from` is zero, `amount` tokens will be minted for `to`.
807      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
808      * - `from` and `to` are never both zero.
809      *
810      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
811      */
812     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
813 }
814 
815 // File: @openzeppelin/contracts/access/Ownable.sol
816 
817 
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev Contract module which provides a basic access control mechanism, where
823  * there is an account (an owner) that can be granted exclusive access to
824  * specific functions.
825  *
826  * By default, the owner account will be the one that deploys the contract. This
827  * can later be changed with {transferOwnership}.
828  *
829  * This module is used through inheritance. It will make available the modifier
830  * `onlyOwner`, which can be applied to your functions to restrict their use to
831  * the owner.
832  */
833 abstract contract Ownable is Context {
834     address private _owner;
835 
836     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
837 
838     /**
839      * @dev Initializes the contract setting the deployer as the initial owner.
840      */
841     constructor () {
842         address msgSender = _msgSender();
843         _owner = msgSender;
844         emit OwnershipTransferred(address(0), msgSender);
845     }
846 
847     /**
848      * @dev Returns the address of the current owner.
849      */
850     function owner() public view virtual returns (address) {
851         return _owner;
852     }
853 
854     /**
855      * @dev Throws if called by any account other than the owner.
856      */
857     modifier onlyOwner() {
858         require(owner() == _msgSender(), "Ownable: caller is not the owner");
859         _;
860     }
861 
862     /**
863      * @dev Leaves the contract without owner. It will not be possible to call
864      * `onlyOwner` functions anymore. Can only be called by the current owner.
865      *
866      * NOTE: Renouncing ownership will leave the contract without an owner,
867      * thereby removing any functionality that is only available to the owner.
868      */
869     function renounceOwnership() public virtual onlyOwner {
870         emit OwnershipTransferred(_owner, address(0));
871         _owner = address(0);
872     }
873 
874     /**
875      * @dev Transfers ownership of the contract to a new account (`newOwner`).
876      * Can only be called by the current owner.
877      */
878     function transferOwnership(address newOwner) public virtual onlyOwner {
879         require(newOwner != address(0), "Ownable: new owner is the zero address");
880         emit OwnershipTransferred(_owner, newOwner);
881         _owner = newOwner;
882     }
883 }
884 
885 // File: @openzeppelin/contracts/security/Pausable.sol
886 
887 
888 
889 pragma solidity ^0.8.0;
890 
891 
892 /**
893  * @dev Contract module which allows children to implement an emergency stop
894  * mechanism that can be triggered by an authorized account.
895  *
896  * This module is used through inheritance. It will make available the
897  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
898  * the functions of your contract. Note that they will not be pausable by
899  * simply including this module, only once the modifiers are put in place.
900  */
901 abstract contract Pausable is Context {
902     /**
903      * @dev Emitted when the pause is triggered by `account`.
904      */
905     event Paused(address account);
906 
907     /**
908      * @dev Emitted when the pause is lifted by `account`.
909      */
910     event Unpaused(address account);
911 
912     bool private _paused;
913 
914     /**
915      * @dev Initializes the contract in unpaused state.
916      */
917     constructor () {
918         _paused = false;
919     }
920 
921     /**
922      * @dev Returns true if the contract is paused, and false otherwise.
923      */
924     function paused() public view virtual returns (bool) {
925         return _paused;
926     }
927 
928     /**
929      * @dev Modifier to make a function callable only when the contract is not paused.
930      *
931      * Requirements:
932      *
933      * - The contract must not be paused.
934      */
935     modifier whenNotPaused() {
936         require(!paused(), "Pausable: paused");
937         _;
938     }
939 
940     /**
941      * @dev Modifier to make a function callable only when the contract is paused.
942      *
943      * Requirements:
944      *
945      * - The contract must be paused.
946      */
947     modifier whenPaused() {
948         require(paused(), "Pausable: not paused");
949         _;
950     }
951 
952     /**
953      * @dev Triggers stopped state.
954      *
955      * Requirements:
956      *
957      * - The contract must not be paused.
958      */
959     function _pause() internal virtual whenNotPaused {
960         _paused = true;
961         emit Paused(_msgSender());
962     }
963 
964     /**
965      * @dev Returns to normal state.
966      *
967      * Requirements:
968      *
969      * - The contract must be paused.
970      */
971     function _unpause() internal virtual whenPaused {
972         _paused = false;
973         emit Unpaused(_msgSender());
974     }
975 }
976 
977 // File: contracts/Stratos.sol
978 
979 
980 pragma solidity ^0.8.0;
981 
982 
983 
984 
985 
986 contract DSAuth is Ownable, AccessControl {
987     bytes32 public constant MINT_BURN_ROLE = keccak256("MINT_BURN_ROLE");
988 
989     // setOwner transfers the STOS token contract ownership to another address
990     // along with grant new owner MINT_BURN_ROLE role and remove MINT_BURN_ROLE from old owner
991     // note: call transferOwnerShip will only change ownership without other roles
992     function setOwner(address newOwner) public onlyOwner {
993         require(newOwner != owner(), "New owner and current owner need to be different");
994 
995         address oldOwner = owner();
996 
997         transferOwnership(newOwner);
998 
999         _grantAccess(MINT_BURN_ROLE, newOwner);
1000         _revokeAccess(MINT_BURN_ROLE, oldOwner);
1001 
1002         _setupRole(DEFAULT_ADMIN_ROLE, newOwner);
1003         _revokeAccess(DEFAULT_ADMIN_ROLE, oldOwner);
1004 
1005         emit OwnershipTransferred(oldOwner, newOwner);
1006     }
1007 
1008     // setAuthority performs the same action as grantMintBurnRole
1009     // we need setAuthority() only because the backward compatibility with previous version contract
1010     function setAuthority(address authorityAddress) public onlyOwner {
1011         grantMintBurnRole(authorityAddress);
1012     }
1013 
1014     // grantMintBurnRole grants the MINT_BURN_ROLE role to an address
1015     function grantMintBurnRole(address account) public onlyOwner {
1016         _grantAccess(MINT_BURN_ROLE, account);
1017     }
1018 
1019     // revokeMintBurnRole revokes the MINT_BURN_ROLE role from an address
1020     function revokeMintBurnRole(address account) public onlyOwner {
1021         _revokeAccess(MINT_BURN_ROLE, account);
1022     }
1023 
1024     // internal function _grantAccess grants account with given role
1025     function _grantAccess(bytes32 role, address account) internal {
1026         grantRole(role, account);
1027 
1028         emit RoleGranted(role, account, owner());
1029     }
1030 
1031     // internal function _revokeAccess revokes account with given role
1032     function _revokeAccess(bytes32 role, address account) internal {
1033         if (DEFAULT_ADMIN_ROLE == role) {
1034             require(account != owner(), "owner cant revoke himself from admin role");
1035         }
1036 
1037         revokeRole(role, account);
1038 
1039         emit RoleRevoked(role, account, owner());
1040     }
1041 }
1042 
1043 contract DSStop is Pausable, Ownable {
1044     // we need stopped() only because the backward compatibility with previous version contract
1045     // stopped = paused
1046     function stopped() public view returns (bool) {
1047         return paused();
1048     }
1049 
1050     function stop() public onlyOwner {
1051         _pause();
1052 
1053         emit Paused(owner());
1054     }
1055 
1056     function start() public onlyOwner {
1057         _unpause();
1058 
1059         emit Unpaused(owner());
1060     }
1061 }
1062 
1063 contract Stratos is ERC20("Stratos Token", "STOS"), DSAuth, DSStop {
1064 
1065     event Mint(address indexed guy, uint wad);
1066     event Burn(address indexed guy, uint wad);
1067 
1068     uint256 MAX_SUPPLY = 1 * 10 ** 8 * 10 ** 18; // 100,000,000 STOS Token Max Supply
1069 
1070     // deployer address is the default admin(owner)
1071     // deployer address is the first address with MINT_BURN_ROLE role
1072     constructor () {
1073         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1074         _grantAccess(MINT_BURN_ROLE, msg.sender);
1075     }
1076 
1077     function approve(address guy, uint wad) public override whenNotPaused returns (bool) {
1078         return super.approve(guy, wad);
1079     }
1080 
1081     function transferFrom(address src, address dst, uint wad) public override whenNotPaused returns (bool) {
1082         return super.transferFrom(src, dst, wad);
1083     }
1084 
1085     function transfer(address dst, uint wad) public override whenNotPaused returns (bool) {
1086         return super.transfer(dst, wad);
1087     }
1088 
1089     function mint(address guy, uint wad) public whenNotPaused {
1090         require(hasRole(MINT_BURN_ROLE, msg.sender), "Caller is not allowed to mint");
1091         require(totalSupply() + wad <= MAX_SUPPLY, "Exceeds STOS token max totalSupply");
1092 
1093         _mint(guy, wad);
1094 
1095         emit Mint(guy, wad);
1096     }
1097 
1098     function burn(address guy, uint wad) public whenNotPaused {
1099         require(hasRole(MINT_BURN_ROLE, msg.sender), "Caller is not allowed to burn");
1100 
1101         _burn(guy, wad);
1102 
1103         emit Burn(guy, wad);
1104     }
1105 
1106     function redeem(uint amount) public onlyOwner {
1107         require(balanceOf(address(this)) >= amount, "redeem can not exceed the balance");
1108 
1109         _transfer(address(this), owner(), amount);
1110     }
1111 }