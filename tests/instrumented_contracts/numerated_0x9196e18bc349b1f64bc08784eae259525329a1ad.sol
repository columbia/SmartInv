1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-22
3 */
4 
5 // Sources flattened with hardhat v2.2.0 https://hardhat.org
6 
7 // File contracts/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 // File contracts/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
88 
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 // File contracts/openzeppelin-contracts/contracts/utils/Context.sol
114 
115 
116 pragma solidity ^0.8.0;
117 
118 /*
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
135         return msg.data;
136     }
137 }
138 
139 
140 // File contracts/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
141 
142 
143 pragma solidity ^0.8.0;
144 
145 
146 
147 /**
148  * @dev Implementation of the {IERC20} interface.
149  *
150  * This implementation is agnostic to the way tokens are created. This means
151  * that a supply mechanism has to be added in a derived contract using {_mint}.
152  * For a generic mechanism see {ERC20PresetMinterPauser}.
153  *
154  * TIP: For a detailed writeup see our guide
155  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
156  * to implement supply mechanisms].
157  *
158  * We have followed general OpenZeppelin guidelines: functions revert instead
159  * of returning `false` on failure. This behavior is nonetheless conventional
160  * and does not conflict with the expectations of ERC20 applications.
161  *
162  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
163  * This allows applications to reconstruct the allowance for all accounts just
164  * by listening to said events. Other implementations of the EIP may not emit
165  * these events, as it isn't required by the specification.
166  *
167  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
168  * functions have been added to mitigate the well-known issues around setting
169  * allowances. See {IERC20-approve}.
170  */
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     mapping (address => uint256) private _balances;
173 
174     mapping (address => mapping (address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     string private _name;
179     string private _symbol;
180 
181     /**
182      * @dev Sets the values for {name} and {symbol}.
183      *
184      * The defaut value of {decimals} is 18. To select a different value for
185      * {decimals} you should overload it.
186      *
187      * All two of these values are immutable: they can only be set once during
188      * construction.
189      */
190     constructor (string memory name_, string memory symbol_) {
191         _name = name_;
192         _symbol = symbol_;
193     }
194 
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     /**
203      * @dev Returns the symbol of the token, usually a shorter version of the
204      * name.
205      */
206     function symbol() public view virtual override returns (string memory) {
207         return _symbol;
208     }
209 
210     /**
211      * @dev Returns the number of decimals used to get its user representation.
212      * For example, if `decimals` equals `2`, a balance of `505` tokens should
213      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
214      *
215      * Tokens usually opt for a value of 18, imitating the relationship between
216      * Ether and Wei. This is the value {ERC20} uses, unless this function is
217      * overridden;
218      *
219      * NOTE: This information is only used for _display_ purposes: it in
220      * no way affects any of the arithmetic of the contract, including
221      * {IERC20-balanceOf} and {IERC20-transfer}.
222      */
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `recipient` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-allowance}.
256      */
257     function allowance(address owner, address spender) public view virtual override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     /**
262      * @dev See {IERC20-approve}.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 amount) public virtual override returns (bool) {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-transferFrom}.
275      *
276      * Emits an {Approval} event indicating the updated allowance. This is not
277      * required by the EIP. See the note at the beginning of {ERC20}.
278      *
279      * Requirements:
280      *
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `amount`.
283      * - the caller must have allowance for ``sender``'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
287         _transfer(sender, recipient, amount);
288 
289         uint256 currentAllowance = _allowances[sender][_msgSender()];
290         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
291         _approve(sender, _msgSender(), currentAllowance - amount);
292 
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
328         uint256 currentAllowance = _allowances[_msgSender()][spender];
329         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
330         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
331 
332         return true;
333     }
334 
335     /**
336      * @dev Moves tokens `amount` from `sender` to `recipient`.
337      *
338      * This is internal function is equivalent to {transfer}, and can be used to
339      * e.g. implement automatic token fees, slashing mechanisms, etc.
340      *
341      * Emits a {Transfer} event.
342      *
343      * Requirements:
344      *
345      * - `sender` cannot be the zero address.
346      * - `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      */
349     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
350         require(sender != address(0), "ERC20: transfer from the zero address");
351         require(recipient != address(0), "ERC20: transfer to the zero address");
352 
353         _beforeTokenTransfer(sender, recipient, amount);
354 
355         uint256 senderBalance = _balances[sender];
356         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
357         _balances[sender] = senderBalance - amount;
358         _balances[recipient] += amount;
359 
360         emit Transfer(sender, recipient, amount);
361     }
362 
363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
364      * the total supply.
365      *
366      * Emits a {Transfer} event with `from` set to the zero address.
367      *
368      * Requirements:
369      *
370      * - `to` cannot be the zero address.
371      */
372     function _mint(address account, uint256 amount) internal virtual {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _beforeTokenTransfer(address(0), account, amount);
376 
377         _totalSupply += amount;
378         _balances[account] += amount;
379         emit Transfer(address(0), account, amount);
380     }
381 
382     /**
383      * @dev Destroys `amount` tokens from `account`, reducing the
384      * total supply.
385      *
386      * Emits a {Transfer} event with `to` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      * - `account` must have at least `amount` tokens.
392      */
393     function _burn(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: burn from the zero address");
395 
396         _beforeTokenTransfer(account, address(0), amount);
397 
398         uint256 accountBalance = _balances[account];
399         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
400         _balances[account] = accountBalance - amount;
401         _totalSupply -= amount;
402 
403         emit Transfer(account, address(0), amount);
404     }
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
408      *
409      * This internal function is equivalent to `approve`, and can be used to
410      * e.g. set automatic allowances for certain subsystems, etc.
411      *
412      * Emits an {Approval} event.
413      *
414      * Requirements:
415      *
416      * - `owner` cannot be the zero address.
417      * - `spender` cannot be the zero address.
418      */
419     function _approve(address owner, address spender, uint256 amount) internal virtual {
420         require(owner != address(0), "ERC20: approve from the zero address");
421         require(spender != address(0), "ERC20: approve to the zero address");
422 
423         _allowances[owner][spender] = amount;
424         emit Approval(owner, spender, amount);
425     }
426 
427     /**
428      * @dev Hook that is called before any transfer of tokens. This includes
429      * minting and burning.
430      *
431      * Calling conditions:
432      *
433      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
434      * will be to transferred to `to`.
435      * - when `from` is zero, `amount` tokens will be minted for `to`.
436      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
437      * - `from` and `to` are never both zero.
438      *
439      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
440      */
441     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
442 }
443 
444 
445 // File contracts/openzeppelin-contracts/contracts/utils/Strings.sol
446 
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev String operations.
452  */
453 library Strings {
454     bytes16 private constant alphabet = "0123456789abcdef";
455 
456     /**
457      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
458      */
459     function toString(uint256 value) internal pure returns (string memory) {
460         // Inspired by OraclizeAPI's implementation - MIT licence
461         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
462 
463         if (value == 0) {
464             return "0";
465         }
466         uint256 temp = value;
467         uint256 digits;
468         while (temp != 0) {
469             digits++;
470             temp /= 10;
471         }
472         bytes memory buffer = new bytes(digits);
473         while (value != 0) {
474             digits -= 1;
475             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
476             value /= 10;
477         }
478         return string(buffer);
479     }
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
483      */
484     function toHexString(uint256 value) internal pure returns (string memory) {
485         if (value == 0) {
486             return "0x00";
487         }
488         uint256 temp = value;
489         uint256 length = 0;
490         while (temp != 0) {
491             length++;
492             temp >>= 8;
493         }
494         return toHexString(value, length);
495     }
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
499      */
500     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
501         bytes memory buffer = new bytes(2 * length + 2);
502         buffer[0] = "0";
503         buffer[1] = "x";
504         for (uint256 i = 2 * length + 1; i > 1; --i) {
505             buffer[i] = alphabet[value & 0xf];
506             value >>= 4;
507         }
508         require(value == 0, "Strings: hex length insufficient");
509         return string(buffer);
510     }
511 
512 }
513 
514 
515 // File contracts/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
516 
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Interface of the ERC165 standard, as defined in the
522  * https://eips.ethereum.org/EIPS/eip-165[EIP].
523  *
524  * Implementers can declare support of contract interfaces, which can then be
525  * queried by others ({ERC165Checker}).
526  *
527  * For an implementation, see {ERC165}.
528  */
529 interface IERC165 {
530     /**
531      * @dev Returns true if this contract implements the interface defined by
532      * `interfaceId`. See the corresponding
533      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
534      * to learn more about how these ids are created.
535      *
536      * This function call must use less than 30 000 gas.
537      */
538     function supportsInterface(bytes4 interfaceId) external view returns (bool);
539 }
540 
541 
542 // File contracts/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Implementation of the {IERC165} interface.
549  *
550  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
551  * for the additional interface id that will be supported. For example:
552  *
553  * ```solidity
554  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
556  * }
557  * ```
558  *
559  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
560  */
561 abstract contract ERC165 is IERC165 {
562     /**
563      * @dev See {IERC165-supportsInterface}.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566         return interfaceId == type(IERC165).interfaceId;
567     }
568 }
569 
570 
571 // File contracts/openzeppelin-contracts/contracts/access/AccessControl.sol
572 
573 
574 pragma solidity ^0.8.0;
575 
576 
577 
578 /**
579  * @dev External interface of AccessControl declared to support ERC165 detection.
580  */
581 interface IAccessControl {
582     function hasRole(bytes32 role, address account) external view returns (bool);
583     function getRoleAdmin(bytes32 role) external view returns (bytes32);
584     function grantRole(bytes32 role, address account) external;
585     function revokeRole(bytes32 role, address account) external;
586     function renounceRole(bytes32 role, address account) external;
587 }
588 
589 /**
590  * @dev Contract module that allows children to implement role-based access
591  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
592  * members except through off-chain means by accessing the contract event logs. Some
593  * applications may benefit from on-chain enumerability, for those cases see
594  * {AccessControlEnumerable}.
595  *
596  * Roles are referred to by their `bytes32` identifier. These should be exposed
597  * in the external API and be unique. The best way to achieve this is by
598  * using `public constant` hash digests:
599  *
600  * ```
601  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
602  * ```
603  *
604  * Roles can be used to represent a set of permissions. To restrict access to a
605  * function call, use {hasRole}:
606  *
607  * ```
608  * function foo() public {
609  *     require(hasRole(MY_ROLE, msg.sender));
610  *     ...
611  * }
612  * ```
613  *
614  * Roles can be granted and revoked dynamically via the {grantRole} and
615  * {revokeRole} functions. Each role has an associated admin role, and only
616  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
617  *
618  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
619  * that only accounts with this role will be able to grant or revoke other
620  * roles. More complex role relationships can be created by using
621  * {_setRoleAdmin}.
622  *
623  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
624  * grant and revoke this role. Extra precautions should be taken to secure
625  * accounts that have been granted it.
626  */
627 abstract contract AccessControl is Context, IAccessControl, ERC165 {
628     struct RoleData {
629         mapping (address => bool) members;
630         bytes32 adminRole;
631     }
632 
633     mapping (bytes32 => RoleData) private _roles;
634 
635     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
636 
637     /**
638      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
639      *
640      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
641      * {RoleAdminChanged} not being emitted signaling this.
642      *
643      * _Available since v3.1._
644      */
645     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
646 
647     /**
648      * @dev Emitted when `account` is granted `role`.
649      *
650      * `sender` is the account that originated the contract call, an admin role
651      * bearer except when using {_setupRole}.
652      */
653     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
654 
655     /**
656      * @dev Emitted when `account` is revoked `role`.
657      *
658      * `sender` is the account that originated the contract call:
659      *   - if using `revokeRole`, it is the admin role bearer
660      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
661      */
662     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
663 
664     /**
665      * @dev Modifier that checks that an account has a specific role. Reverts
666      * with a standardized message including the required role.
667      *
668      * The format of the revert reason is given by the following regular expression:
669      *
670      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
671      */
672     modifier onlyRole(bytes32 role) {
673         _checkRole(role, _msgSender());
674         _;
675     }
676 
677     /**
678      * @dev See {IERC165-supportsInterface}.
679      */
680     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681         return interfaceId == type(IAccessControl).interfaceId
682             || super.supportsInterface(interfaceId);
683     }
684 
685     /**
686      * @dev Returns `true` if `account` has been granted `role`.
687      */
688     function hasRole(bytes32 role, address account) public view override returns (bool) {
689         return _roles[role].members[account];
690     }
691 
692     /**
693      * @dev Revert with a standard message if `account` is missing `role`.
694      *
695      * The format of the revert reason is given by the following regular expression:
696      *
697      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
698      */
699     function _checkRole(bytes32 role, address account) internal view {
700         if(!hasRole(role, account)) {
701             revert(string(abi.encodePacked(
702                 "AccessControl: account ",
703                 Strings.toHexString(uint160(account), 20),
704                 " is missing role ",
705                 Strings.toHexString(uint256(role), 32)
706             )));
707         }
708     }
709 
710     /**
711      * @dev Returns the admin role that controls `role`. See {grantRole} and
712      * {revokeRole}.
713      *
714      * To change a role's admin, use {_setRoleAdmin}.
715      */
716     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
717         return _roles[role].adminRole;
718     }
719 
720     /**
721      * @dev Grants `role` to `account`.
722      *
723      * If `account` had not been already granted `role`, emits a {RoleGranted}
724      * event.
725      *
726      * Requirements:
727      *
728      * - the caller must have ``role``'s admin role.
729      */
730     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
731         _grantRole(role, account);
732     }
733 
734     /**
735      * @dev Revokes `role` from `account`.
736      *
737      * If `account` had been granted `role`, emits a {RoleRevoked} event.
738      *
739      * Requirements:
740      *
741      * - the caller must have ``role``'s admin role.
742      */
743     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
744         _revokeRole(role, account);
745     }
746 
747     /**
748      * @dev Revokes `role` from the calling account.
749      *
750      * Roles are often managed via {grantRole} and {revokeRole}: this function's
751      * purpose is to provide a mechanism for accounts to lose their privileges
752      * if they are compromised (such as when a trusted device is misplaced).
753      *
754      * If the calling account had been granted `role`, emits a {RoleRevoked}
755      * event.
756      *
757      * Requirements:
758      *
759      * - the caller must be `account`.
760      */
761     function renounceRole(bytes32 role, address account) public virtual override {
762         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
763 
764         _revokeRole(role, account);
765     }
766 
767     /**
768      * @dev Grants `role` to `account`.
769      *
770      * If `account` had not been already granted `role`, emits a {RoleGranted}
771      * event. Note that unlike {grantRole}, this function doesn't perform any
772      * checks on the calling account.
773      *
774      * [WARNING]
775      * ====
776      * This function should only be called from the constructor when setting
777      * up the initial roles for the system.
778      *
779      * Using this function in any other way is effectively circumventing the admin
780      * system imposed by {AccessControl}.
781      * ====
782      */
783     function _setupRole(bytes32 role, address account) internal virtual {
784         _grantRole(role, account);
785     }
786 
787     /**
788      * @dev Sets `adminRole` as ``role``'s admin role.
789      *
790      * Emits a {RoleAdminChanged} event.
791      */
792     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
793         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
794         _roles[role].adminRole = adminRole;
795     }
796 
797     function _grantRole(bytes32 role, address account) private {
798         if (!hasRole(role, account)) {
799             _roles[role].members[account] = true;
800             emit RoleGranted(role, account, _msgSender());
801         }
802     }
803 
804     function _revokeRole(bytes32 role, address account) private {
805         if (hasRole(role, account)) {
806             _roles[role].members[account] = false;
807             emit RoleRevoked(role, account, _msgSender());
808         }
809     }
810 }
811 
812 
813 // File contracts/openzeppelin-contracts/contracts/access/Ownable.sol
814 
815 
816 pragma solidity ^0.8.0;
817 
818 /**
819  * @dev Contract module which provides a basic access control mechanism, where
820  * there is an account (an owner) that can be granted exclusive access to
821  * specific functions.
822  *
823  * By default, the owner account will be the one that deploys the contract. This
824  * can later be changed with {transferOwnership}.
825  *
826  * This module is used through inheritance. It will make available the modifier
827  * `onlyOwner`, which can be applied to your functions to restrict their use to
828  * the owner.
829  */
830 abstract contract Ownable is Context {
831     address private _owner;
832 
833     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
834 
835     /**
836      * @dev Initializes the contract setting the deployer as the initial owner.
837      */
838     constructor () {
839         address msgSender = _msgSender();
840         _owner = msgSender;
841         emit OwnershipTransferred(address(0), msgSender);
842     }
843 
844     /**
845      * @dev Returns the address of the current owner.
846      */
847     function owner() public view virtual returns (address) {
848         return _owner;
849     }
850 
851     /**
852      * @dev Throws if called by any account other than the owner.
853      */
854     modifier onlyOwner() {
855         require(owner() == _msgSender(), "Ownable: caller is not the owner");
856         _;
857     }
858 
859     /**
860      * @dev Leaves the contract without owner. It will not be possible to call
861      * `onlyOwner` functions anymore. Can only be called by the current owner.
862      *
863      * NOTE: Renouncing ownership will leave the contract without an owner,
864      * thereby removing any functionality that is only available to the owner.
865      */
866     function renounceOwnership() public virtual onlyOwner {
867         emit OwnershipTransferred(_owner, address(0));
868         _owner = address(0);
869     }
870 
871     /**
872      * @dev Transfers ownership of the contract to a new account (`newOwner`).
873      * Can only be called by the current owner.
874      */
875     function transferOwnership(address newOwner) public virtual onlyOwner {
876         require(newOwner != address(0), "Ownable: new owner is the zero address");
877         emit OwnershipTransferred(_owner, newOwner);
878         _owner = newOwner;
879     }
880 }
881 
882 
883 // File contracts/openzeppelin-contracts/contracts/security/Pausable.sol
884 
885 
886 pragma solidity ^0.8.0;
887 
888 /**
889  * @dev Contract module which allows children to implement an emergency stop
890  * mechanism that can be triggered by an authorized account.
891  *
892  * This module is used through inheritance. It will make available the
893  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
894  * the functions of your contract. Note that they will not be pausable by
895  * simply including this module, only once the modifiers are put in place.
896  */
897 abstract contract Pausable is Context {
898     /**
899      * @dev Emitted when the pause is triggered by `account`.
900      */
901     event Paused(address account);
902 
903     /**
904      * @dev Emitted when the pause is lifted by `account`.
905      */
906     event Unpaused(address account);
907 
908     bool private _paused;
909 
910     /**
911      * @dev Initializes the contract in unpaused state.
912      */
913     constructor () {
914         _paused = false;
915     }
916 
917     /**
918      * @dev Returns true if the contract is paused, and false otherwise.
919      */
920     function paused() public view virtual returns (bool) {
921         return _paused;
922     }
923 
924     /**
925      * @dev Modifier to make a function callable only when the contract is not paused.
926      *
927      * Requirements:
928      *
929      * - The contract must not be paused.
930      */
931     modifier whenNotPaused() {
932         require(!paused(), "Pausable: paused");
933         _;
934     }
935 
936     /**
937      * @dev Modifier to make a function callable only when the contract is paused.
938      *
939      * Requirements:
940      *
941      * - The contract must be paused.
942      */
943     modifier whenPaused() {
944         require(paused(), "Pausable: not paused");
945         _;
946     }
947 
948     /**
949      * @dev Triggers stopped state.
950      *
951      * Requirements:
952      *
953      * - The contract must not be paused.
954      */
955     function _pause() internal virtual whenNotPaused {
956         _paused = true;
957         emit Paused(_msgSender());
958     }
959 
960     /**
961      * @dev Returns to normal state.
962      *
963      * Requirements:
964      *
965      * - The contract must be paused.
966      */
967     function _unpause() internal virtual whenPaused {
968         _paused = false;
969         emit Unpaused(_msgSender());
970     }
971 }
972 
973 
974 // File contracts/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Pausable.sol
975 
976 
977 pragma solidity ^0.8.0;
978 
979 
980 /**
981  * @dev ERC20 token with pausable token transfers, minting and burning.
982  *
983  * Useful for scenarios such as preventing trades until the end of an evaluation
984  * period, or having an emergency switch for freezing all token transfers in the
985  * event of a large bug.
986  */
987 abstract contract ERC20Pausable is ERC20, Pausable {
988     /**
989      * @dev See {ERC20-_beforeTokenTransfer}.
990      *
991      * Requirements:
992      *
993      * - the contract must not be paused.
994      */
995     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
996         super._beforeTokenTransfer(from, to, amount);
997 
998         require(!paused(), "ERC20Pausable: token transfer while paused");
999     }
1000 }
1001 
1002 
1003 // File contracts/uni-v2.sol
1004 
1005 // SPDX-License-Identifier: MIT
1006 pragma solidity ^0.8.0;
1007 
1008 
1009 
1010 
1011 contract meowToken is ERC20, AccessControl, Ownable, Pausable {
1012 
1013     constructor() ERC20("PUSSY token", "PUSSY") {
1014         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1015         _mint(msg.sender, 420e27);
1016     }
1017 
1018     function pause() public onlyOwner{
1019         _pause();
1020     }
1021 
1022     function unpause() public onlyOwner{
1023         _unpause();
1024     }
1025 }