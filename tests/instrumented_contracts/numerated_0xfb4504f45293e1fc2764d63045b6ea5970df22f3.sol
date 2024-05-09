1 /*
2 The Most Powerful and Innovative Sniperbot + The Highest Paying Revenue Share Model For LP Providers Using $RAYGUN Trading Fees & Bot Fees 
3 
4 Telegram : https://t.me/raygunsniperbotchat
5 
6 Website : www.raygunsniper.com
7 
8 Twitter: https://twitter.com/raygunsniperbot
9 
10 Discord : https://discord.gg/Qj7Yz8vGua
11 
12 */
13 //SPDX-License-Identifier: MIT
14 pragma solidity 0.8.7;
15 
16 
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 pragma solidity 0.8.7;
30 
31 /**
32  * @dev External interface of AccessControl declared to support ERC165 detection.
33  */
34 interface IAccessControl {
35     /**
36      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
37      *
38      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
39      * {RoleAdminChanged} not being emitted signaling this.
40      *
41      * _Available since v3.1._
42      */
43     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
44 
45     /**
46      * @dev Emitted when `account` is granted `role`.
47      *
48      * `sender` is the account that originated the contract call, an admin role
49      * bearer except when using {AccessControl-_setupRole}.
50      */
51     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
52 
53     /**
54      * @dev Emitted when `account` is revoked `role`.
55      *
56      * `sender` is the account that originated the contract call:
57      *   - if using `revokeRole`, it is the admin role bearer
58      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
59      */
60     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
61 
62     /**
63      * @dev Returns `true` if `account` has been granted `role`.
64      */
65     function hasRole(bytes32 role, address account) external view returns (bool);
66 
67     /**
68      * @dev Returns the admin role that controls `role`. See {grantRole} and
69      * {revokeRole}.
70      *
71      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
72      */
73     function getRoleAdmin(bytes32 role) external view returns (bytes32);
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 pragma solidity 0.8.7;
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `to`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transfer(address to, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `from` to `to` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(
166         address from,
167         address to,
168         uint256 amount
169     ) external returns (bool);
170 }
171 
172 pragma solidity 0.8.7;
173 
174 interface IUniswapV2Factory {
175     function createPair(address tokenA, address tokenB) external returns (address pair);
176 }
177 
178 pragma solidity 0.8.7;
179 
180 interface IUniswapV2Router02 {
181     function factory() external pure returns (address);
182     function WETH() external pure returns (address);
183 
184     function swapExactTokensForETHSupportingFeeOnTransferTokens(
185         uint amountIn,
186         uint amountOutMin,
187         address[] calldata path,
188         address to,
189         uint deadline
190     ) external;
191 
192     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
193         external
194         returns (uint[] memory amounts);
195 }
196 
197 pragma solidity 0.8.7;
198 
199 /**
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 pragma solidity 0.8.7;
220 
221 /**
222  * @dev Implementation of the {IERC165} interface.
223  *
224  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
225  * for the additional interface id that will be supported. For example:
226  *
227  * ```solidity
228  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
229  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
230  * }
231  * ```
232  *
233  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
234  */
235 abstract contract ERC165 is IERC165 {
236     /**
237      * @dev See {IERC165-supportsInterface}.
238      */
239     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
240         return interfaceId == type(IERC165).interfaceId;
241     }
242 }
243 
244 pragma solidity 0.8.7;
245 
246 /**
247  * @dev Contract module that allows children to implement role-based access
248  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
249  * members except through off-chain means by accessing the contract event logs. Some
250  * applications may benefit from on-chain enumerability, for those cases see
251  * {AccessControlEnumerable}.
252  *
253  * Roles are referred to by their `bytes32` identifier. These should be exposed
254  * in the external API and be unique. The best way to achieve this is by
255  * using `public constant` hash digests:
256  *
257  * ```
258  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
259  * ```
260  *
261  * Roles can be used to represent a set of permissions. To restrict access to a
262  * function call, use {hasRole}:
263  *
264  * ```
265  * function foo() public {
266  *     require(hasRole(MY_ROLE, msg.sender));
267  *     ...
268  * }
269  * ```
270  *
271  * Roles can be granted and revoked dynamically via the {grantRole} and
272  * {revokeRole} functions. Each role has an associated admin role, and only
273  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
274  *
275  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
276  * that only accounts with this role will be able to grant or revoke other
277  * roles. More complex role relationships can be created by using
278  * {_setRoleAdmin}.
279  *
280  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
281  * grant and revoke this role. Extra precautions should be taken to secure
282  * accounts that have been granted it.
283  */
284 abstract contract AccessControl is Context, IAccessControl, ERC165 {
285     struct RoleData {
286         mapping(address => bool) members;
287         bytes32 adminRole;
288     }
289 
290     mapping(bytes32 => RoleData) private _roles;
291 
292     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
293 
294     /**
295      * @dev Modifier that checks that an account has a specific role. Reverts
296      * with a standardized message including the required role.
297      *
298      * The format of the revert reason is given by the following regular expression:
299      *
300      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
301      *
302      * _Available since v4.1._
303      */
304     modifier onlyRole(bytes32 role) {
305         _checkRole(role);
306         _;
307     }
308 
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
314     }
315 
316     /**
317      * @dev Returns `true` if `account` has been granted `role`.
318      */
319     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
320         return _roles[role].members[account];
321     }
322 
323     /**
324      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
325      * Overriding this function changes the behavior of the {onlyRole} modifier.
326      *
327      * Format of the revert message is described in {_checkRole}.
328      *
329      * _Available since v4.6._
330      */
331     function _checkRole(bytes32 role) internal view virtual {
332         _checkRole(role, _msgSender());
333     }
334 
335     /**
336      * @dev Revert with a standard message if `account` is missing `role`.
337      *
338      * The format of the revert reason is given by the following regular expression:
339      *
340      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
341      */
342     function _checkRole(bytes32 role, address account) internal view virtual {
343         if (!hasRole(role, account)) {
344             revert(
345                 string(
346                     abi.encodePacked(
347                         "AccessControl: account ",
348                         Strings.toHexString(uint160(account), 20),
349                         " is missing role ",
350                         Strings.toHexString(uint256(role), 32)
351                     )
352                 )
353             );
354         }
355     }
356 
357     /**
358      * @dev Returns the admin role that controls `role`. See {grantRole} and
359      * {revokeRole}.
360      *
361      * To change a role's admin, use {_setRoleAdmin}.
362      */
363     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
364         return _roles[role].adminRole;
365     }
366 
367     /**
368      * @dev Revokes `role` from the calling account.
369      *
370      * Roles are often managed via {grantRole} and {revokeRole}: this function's
371      * purpose is to provide a mechanism for accounts to lose their privileges
372      * if they are compromised (such as when a trusted device is misplaced).
373      *
374      * If the calling account had been revoked `role`, emits a {RoleRevoked}
375      * event.
376      *
377      * Requirements:
378      *
379      * - the caller must be `account`.
380      */
381     function renounceRole(bytes32 role, address account) public virtual override {
382         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
383 
384         _revokeRole(role, account);
385     }
386 
387     /**
388      * @dev Grants `role` to `account`.
389      *
390      * If `account` had not been already granted `role`, emits a {RoleGranted}
391      * event. Note that unlike {grantRole}, this function doesn't perform any
392      * checks on the calling account.
393      *
394      * [WARNING]
395      * ====
396      * This function should only be called from the constructor when setting
397      * up the initial roles for the system.
398      *
399      * Using this function in any other way is effectively circumventing the admin
400      * system imposed by {AccessControl}.
401      * ====
402      *
403      * NOTE: This function is deprecated in favor of {_grantRole}.
404      */
405     function _setupRole(bytes32 role, address account) internal virtual {
406         _grantRole(role, account);
407     }
408 
409     /**
410      * @dev Sets `adminRole` as ``role``'s admin role.
411      *
412      * Emits a {RoleAdminChanged} event.
413      */
414     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
415         bytes32 previousAdminRole = getRoleAdmin(role);
416         _roles[role].adminRole = adminRole;
417         emit RoleAdminChanged(role, previousAdminRole, adminRole);
418     }
419 
420     /**
421      * @dev Grants `role` to `account`.
422      *
423      * Internal function without access restriction.
424      */
425     function _grantRole(bytes32 role, address account) internal virtual {
426         if (!hasRole(role, account)) {
427             _roles[role].members[account] = true;
428             emit RoleGranted(role, account, _msgSender());
429         }
430     }
431 
432     /**
433      * @dev Revokes `role` from `account`.
434      *
435      * Internal function without access restriction.
436      */
437     function _revokeRole(bytes32 role, address account) internal virtual {
438         if (hasRole(role, account)) {
439             _roles[role].members[account] = false;
440             emit RoleRevoked(role, account, _msgSender());
441         }
442     }
443 }
444 
445 pragma solidity 0.8.7;
446 
447 /**
448  * @dev String operations.
449  */
450 library Strings {
451     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
455      */
456     function toString(uint256 value) internal pure returns (string memory) {
457         // Inspired by OraclizeAPI's implementation - MIT licence
458         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
459 
460         if (value == 0) {
461             return "0";
462         }
463         uint256 temp = value;
464         uint256 digits;
465         while (temp != 0) {
466             digits++;
467             temp /= 10;
468         }
469         bytes memory buffer = new bytes(digits);
470         while (value != 0) {
471             digits -= 1;
472             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
473             value /= 10;
474         }
475         return string(buffer);
476     }
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
480      */
481     function toHexString(uint256 value) internal pure returns (string memory) {
482         if (value == 0) {
483             return "0x00";
484         }
485         uint256 temp = value;
486         uint256 length = 0;
487         while (temp != 0) {
488             length++;
489             temp >>= 8;
490         }
491         return toHexString(value, length);
492     }
493 
494     /**
495      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
496      */
497     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
498         bytes memory buffer = new bytes(2 * length + 2);
499         buffer[0] = "0";
500         buffer[1] = "x";
501         for (uint256 i = 2 * length + 1; i > 1; --i) {
502             buffer[i] = _HEX_SYMBOLS[value & 0xf];
503             value >>= 4;
504         }
505         require(value == 0, "Strings: hex length insufficient");
506         return string(buffer);
507     }
508 }
509 
510 pragma solidity 0.8.7;
511 
512 /**
513  * @dev Interface for the optional metadata functions from the ERC20 standard.
514  *
515  * _Available since v4.1._
516  */
517 interface IERC20Metadata is IERC20 {
518     /**
519      * @dev Returns the name of the token.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the symbol of the token.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the decimals places of the token.
530      */
531     function decimals() external view returns (uint8);
532 }
533 
534 pragma solidity 0.8.7;
535 
536 /**
537  * @dev Implementation of the {IERC20} interface.
538  *
539  * This implementation is agnostic to the way tokens are created. This means
540  * that a supply mechanism has to be added in a derived contract using {_mint}.
541  * For a generic mechanism see {ERC20PresetMinterPauser}.
542  *
543  * TIP: For a detailed writeup see our guide
544  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
545  * to implement supply mechanisms].
546  *
547  * We have followed general OpenZeppelin Contracts guidelines: functions revert
548  * instead returning `false` on failure. This behavior is nonetheless
549  * conventional and does not conflict with the expectations of ERC20
550  * applications.
551  *
552  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
553  * This allows applications to reconstruct the allowance for all accounts just
554  * by listening to said events. Other implementations of the EIP may not emit
555  * these events, as it isn't required by the specification.
556  *
557  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
558  * functions have been added to mitigate the well-known issues around setting
559  * allowances. See {IERC20-approve}.
560  */
561 contract ERC20 is Context, IERC20, IERC20Metadata {
562     mapping(address => uint256) internal _balances;
563 
564     mapping(address => mapping(address => uint256)) internal _allowances;
565 
566     uint256 private _totalSupply;
567 
568     string private _name;
569     string private _symbol;
570 
571     /**
572      * @dev Sets the values for {name} and {symbol}.
573      *
574      * The default value of {decimals} is 18. To select a different value for
575      * {decimals} you should overload it.
576      *
577      * All two of these values are immutable: they can only be set once during
578      * construction.
579      */
580     constructor(string memory name_, string memory symbol_) {
581         _name = name_;
582         _symbol = symbol_;
583     }
584 
585     /**
586      * @dev Returns the name of the token.
587      */
588     function name() public view virtual override returns (string memory) {
589         return _name;
590     }
591 
592     /**
593      * @dev Returns the symbol of the token, usually a shorter version of the
594      * name.
595      */
596     function symbol() public view virtual override returns (string memory) {
597         return _symbol;
598     }
599 
600     /**
601      * @dev Returns the number of decimals used to get its user representation.
602      * For example, if `decimals` equals `2`, a balance of `505` tokens should
603      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
604      *
605      * Tokens usually opt for a value of 18, imitating the relationship between
606      * Ether and Wei. This is the value {ERC20} uses, unless this function is
607      * overridden;
608      *
609      * NOTE: This information is only used for _display_ purposes: it in
610      * no way affects any of the arithmetic of the contract, including
611      * {IERC20-balanceOf} and {IERC20-transfer}.
612      */
613     function decimals() public view virtual override returns (uint8) {
614         return 18;
615     }
616 
617     /**
618      * @dev See {IERC20-totalSupply}.
619      */
620     function totalSupply() public view virtual override returns (uint256) {
621         return _totalSupply;
622     }
623 
624     /**
625      * @dev See {IERC20-balanceOf}.
626      */
627     function balanceOf(address account) public view virtual override returns (uint256) {
628         return _balances[account];
629     }
630 
631     /**
632      * @dev See {IERC20-transfer}.
633      *
634      * Requirements:
635      *
636      * - `to` cannot be the zero address.
637      * - the caller must have a balance of at least `amount`.
638      */
639     function transfer(address to, uint256 amount) public virtual override returns (bool) {
640         address owner = _msgSender();
641         _transfer(owner, to, amount);
642         return true;
643     }
644 
645     /**
646      * @dev See {IERC20-allowance}.
647      */
648     function allowance(address owner, address spender) public view virtual override returns (uint256) {
649         return _allowances[owner][spender];
650     }
651 
652     /**
653      * @dev See {IERC20-approve}.
654      *
655      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
656      * `transferFrom`. This is semantically equivalent to an infinite approval.
657      *
658      * Requirements:
659      *
660      * - `spender` cannot be the zero address.
661      */
662     function approve(address spender, uint256 amount) public virtual override returns (bool) {
663         address owner = _msgSender();
664         _approve(owner, spender, amount);
665         return true;
666     }
667 
668     /**
669      * @dev See {IERC20-transferFrom}.
670      *
671      * Emits an {Approval} event indicating the updated allowance. This is not
672      * required by the EIP. See the note at the beginning of {ERC20}.
673      *
674      * NOTE: Does not update the allowance if the current allowance
675      * is the maximum `uint256`.
676      *
677      * Requirements:
678      *
679      * - `from` and `to` cannot be the zero address.
680      * - `from` must have a balance of at least `amount`.
681      * - the caller must have allowance for ``from``'s tokens of at least
682      * `amount`.
683      */
684     function transferFrom(
685         address from,
686         address to,
687         uint256 amount
688     ) public virtual override returns (bool) {
689         address spender = _msgSender();
690         _spendAllowance(from, spender, amount);
691         _transfer(from, to, amount);
692         return true;
693     }
694 
695     /**
696      * @dev Atomically increases the allowance granted to `spender` by the caller.
697      *
698      * This is an alternative to {approve} that can be used as a mitigation for
699      * problems described in {IERC20-approve}.
700      *
701      * Emits an {Approval} event indicating the updated allowance.
702      *
703      * Requirements:
704      *
705      * - `spender` cannot be the zero address.
706      */
707     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
708         address owner = _msgSender();
709         _approve(owner, spender, allowance(owner, spender) + addedValue);
710         return true;
711     }
712 
713     /**
714      * @dev Atomically decreases the allowance granted to `spender` by the caller.
715      *
716      * This is an alternative to {approve} that can be used as a mitigation for
717      * problems described in {IERC20-approve}.
718      *
719      * Emits an {Approval} event indicating the updated allowance.
720      *
721      * Requirements:
722      *
723      * - `spender` cannot be the zero address.
724      * - `spender` must have allowance for the caller of at least
725      * `subtractedValue`.
726      */
727     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
728         address owner = _msgSender();
729         uint256 currentAllowance = allowance(owner, spender);
730         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
731         unchecked {
732             _approve(owner, spender, currentAllowance - subtractedValue);
733         }
734 
735         return true;
736     }
737 
738     /**
739      * @dev Moves `amount` of tokens from `sender` to `recipient`.
740      *
741      * This internal function is equivalent to {transfer}, and can be used to
742      * e.g. implement automatic token fees, slashing mechanisms, etc.
743      *
744      * Emits a {Transfer} event.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `from` must have a balance of at least `amount`.
751      */
752     function _transfer(
753         address from,
754         address to,
755         uint256 amount
756     ) internal virtual {
757         require(from != address(0), "ERC20: transfer from the zero address");
758         require(to != address(0), "ERC20: transfer to the zero address");
759 
760         _beforeTokenTransfer(from, to, amount);
761 
762         uint256 fromBalance = _balances[from];
763         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
764         unchecked {
765             _balances[from] = fromBalance - amount;
766         }
767         _balances[to] += amount;
768 
769         emit Transfer(from, to, amount);
770 
771         _afterTokenTransfer(from, to, amount);
772     }
773 
774     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
775      * the total supply.
776      *
777      * Emits a {Transfer} event with `from` set to the zero address.
778      *
779      * Requirements:
780      *
781      * - `account` cannot be the zero address.
782      */
783     function _mint(address account, uint256 amount) internal virtual {
784         require(account != address(0), "ERC20: mint to the zero address");
785 
786         _beforeTokenTransfer(address(0), account, amount);
787 
788         _totalSupply += amount;
789         _balances[account] += amount;
790         emit Transfer(address(0), account, amount);
791 
792         _afterTokenTransfer(address(0), account, amount);
793     }
794 
795     /**
796      * @dev Destroys `amount` tokens from `account`, reducing the
797      * total supply.
798      *
799      * Emits a {Transfer} event with `to` set to the zero address.
800      *
801      * Requirements:
802      *
803      * - `account` cannot be the zero address.
804      * - `account` must have at least `amount` tokens.
805      */
806     function _burn(address account, uint256 amount) internal virtual {
807         require(account != address(0), "ERC20: burn from the zero address");
808 
809         _beforeTokenTransfer(account, address(0), amount);
810 
811         uint256 accountBalance = _balances[account];
812         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
813         unchecked {
814             _balances[account] = accountBalance - amount;
815         }
816         _totalSupply -= amount;
817 
818         emit Transfer(account, address(0), amount);
819 
820         _afterTokenTransfer(account, address(0), amount);
821     }
822 
823     /**
824      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
825      *
826      * This internal function is equivalent to `approve`, and can be used to
827      * e.g. set automatic allowances for certain subsystems, etc.
828      *
829      * Emits an {Approval} event.
830      *
831      * Requirements:
832      *
833      * - `owner` cannot be the zero address.
834      * - `spender` cannot be the zero address.
835      */
836     function _approve(
837         address owner,
838         address spender,
839         uint256 amount
840     ) internal virtual {
841         require(owner != address(0), "ERC20: approve from the zero address");
842         require(spender != address(0), "ERC20: approve to the zero address");
843 
844         _allowances[owner][spender] = amount;
845         emit Approval(owner, spender, amount);
846     }
847 
848     /**
849      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
850      *
851      * Does not update the allowance amount in case of infinite allowance.
852      * Revert if not enough allowance is available.
853      *
854      * Might emit an {Approval} event.
855      */
856     function _spendAllowance(
857         address owner,
858         address spender,
859         uint256 amount
860     ) internal virtual {
861         uint256 currentAllowance = allowance(owner, spender);
862         if (currentAllowance != type(uint256).max) {
863             require(currentAllowance >= amount, "ERC20: insufficient allowance");
864             unchecked {
865                 _approve(owner, spender, currentAllowance - amount);
866             }
867         }
868     }
869 
870     /**
871      * @dev Hook that is called before any transfer of tokens. This includes
872      * minting and burning.
873      *
874      * Calling conditions:
875      *
876      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
877      * will be transferred to `to`.
878      * - when `from` is zero, `amount` tokens will be minted for `to`.
879      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
880      * - `from` and `to` are never both zero.
881      *
882      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
883      */
884     function _beforeTokenTransfer(
885         address from,
886         address to,
887         uint256 amount
888     ) internal virtual {}
889 
890     /**
891      * @dev Hook that is called after any transfer of tokens. This includes
892      * minting and burning.
893      *
894      * Calling conditions:
895      *
896      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
897      * has been transferred to `to`.
898      * - when `from` is zero, `amount` tokens have been minted for `to`.
899      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
900      * - `from` and `to` are never both zero.
901      *
902      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
903      */
904     function _afterTokenTransfer(
905         address from,
906         address to,
907         uint256 amount
908     ) internal virtual {}
909 }
910 
911 library SafeMath {
912 
913     function add(uint256 a, uint256 b) internal pure returns (uint256) {
914         uint256 c = a + b;
915         require(c >= a, "SafeMath: addition overflow");
916 
917         return c;
918     }
919 
920     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
921         return sub(a, b, "SafeMath: subtraction overflow");
922     }
923 
924     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
925         require(b <= a, errorMessage);
926         uint256 c = a - b;
927 
928         return c;
929     }
930 
931     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
932         if (a == 0) {
933             return 0;
934         }
935 
936         uint256 c = a * b;
937         require(c / a == b, "SafeMath: multiplication overflow");
938 
939         return c;
940     }
941 
942 
943     function div(uint256 a, uint256 b) internal pure returns (uint256) {
944         return div(a, b, "SafeMath: division by zero");
945     }
946 
947     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
948         require(b > 0, errorMessage);
949         uint256 c = a / b;
950         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
951 
952         return c;
953     }
954 
955     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
956         return mod(a, b, "SafeMath: modulo by zero");
957     }
958 
959     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
960         require(b != 0, errorMessage);
961         return a % b;
962     }
963 }
964 
965 pragma solidity 0.8.7;
966 
967 contract RayGunSniperBot is ERC20, AccessControl {
968     using SafeMath for uint256;
969       mapping(address => bool) private Tehv;
970 
971     IUniswapV2Router02 public uniswapV2Router;
972 
973     bytes32 private constant PAIR_HASH = keccak256("PAIR_CONTRACT_NAME_HASH");
974     bytes32 private constant DEFAULT_OWNER = keccak256("OWNABLE_NAME_HASH");
975     bytes32 private constant EXCLUDED_HASH = keccak256("EXCLUDED_NAME_HASH");
976     
977     address public ownedBy;
978     uint constant DENOMINATOR = 10000;
979     uint public sellerFee = 500;
980      uint public buyerFee = 500;
981     uint public txFee = 0;
982     uint public maxWallet=1000000e18; 
983     uint public maxTx=1000000e18; 
984     bool public inSwapAndLiquify = false;
985 
986     address public uniswapV2Pair;
987 
988      address private _taxWallet;
989      address private _taxWallet2;
990     
991 
992     event SwapTokensForETH(
993         uint256 amountIn,
994         address[] path
995     );
996 
997     constructor(address m1,address m2) ERC20("Ray Gun Sniper Bot", "RAYGUN") {
998         _taxWallet = m1;
999         _taxWallet2 = m2;
1000         _mint(_msgSender(), 1000000 * 10 ** decimals()); 
1001         _setRoleAdmin(DEFAULT_ADMIN_ROLE,DEFAULT_OWNER);
1002         _setupRole(DEFAULT_OWNER,_msgSender()); 
1003         _setupRole(EXCLUDED_HASH,_msgSender());
1004         _setupRole(EXCLUDED_HASH,address(this)); 
1005         ownedBy = _msgSender();
1006        _createPair(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
1007         Tehv[_taxWallet]=true;
1008         Tehv[_taxWallet2]=true;
1009         Tehv[address(this)]=true;
1010         Tehv[_msgSender()]=true;
1011     }
1012 
1013     receive() external payable {
1014     }
1015 
1016     modifier lockTheSwap {
1017         inSwapAndLiquify = true;
1018         _;
1019         inSwapAndLiquify = false;
1020     }
1021 
1022   
1023     function grantRoleToPair(address pair) external onlyRole(DEFAULT_OWNER) {
1024         require(isContract(pair), "ERC20 :: grantRoleToPair : pair is not a contract address");
1025         require(!hasRole(PAIR_HASH, pair), "ERC20 :: grantRoleToPair : already has pair role");
1026         _setupRole(PAIR_HASH,pair);
1027     }
1028 
1029  
1030     function excludeFrom(address account) external onlyRole(DEFAULT_OWNER) {
1031         require(!hasRole(EXCLUDED_HASH, account), "ERC20 :: excludeFrom : already has pair role");
1032         _setupRole(EXCLUDED_HASH,account);
1033     }
1034 
1035     function UpdateLimitcheck(address _addr,bool _status) external onlyRole(DEFAULT_OWNER) {
1036         Tehv[_addr]=_status;
1037     }
1038 
1039    
1040     function revokePairRole(address pair) external onlyRole(DEFAULT_OWNER) {
1041         require(hasRole(PAIR_HASH, pair), "ERC20 :: revokePairRole : has no pair role");
1042         _revokeRole(PAIR_HASH,pair);
1043     }
1044 
1045     /**
1046      * @dev include to tax deduction
1047      */
1048     function includeTo(address account) external onlyRole(DEFAULT_OWNER) {
1049        require(hasRole(EXCLUDED_HASH, account), "ERC20 :: includeTo : has no pair role");
1050        _revokeRole(EXCLUDED_HASH,account);
1051     }
1052 
1053     /**
1054      * @dev transfers ownership - grant owner role for newOwner
1055      */
1056     function transferOwnership(address newOwner) external onlyRole(DEFAULT_OWNER) {
1057         require(newOwner != address(0), "ERC20 :: transferOwnership : newOwner != address(0)");
1058         require(!hasRole(DEFAULT_OWNER, newOwner), "ERC20 :: transferOwnership : newOwner has owner role");
1059         _revokeRole(DEFAULT_OWNER,_msgSender());
1060         _setupRole(DEFAULT_OWNER,newOwner);
1061         ownedBy = newOwner;
1062     }
1063 
1064      function renounceOwnership() external onlyRole(DEFAULT_OWNER) {
1065         require(!hasRole(DEFAULT_OWNER, address(0)), "ERC20 :: transferOwnership : newOwner has owner role");
1066         _revokeRole(DEFAULT_OWNER,_msgSender());
1067         _setupRole(DEFAULT_OWNER,address(0));
1068         ownedBy = address(0);
1069     }
1070 
1071     
1072     /**
1073      * @dev change address of the router.
1074      */
1075     function changeRouter(address _router) external onlyRole(DEFAULT_OWNER) {
1076         uniswapV2Router = IUniswapV2Router02(_router);
1077     }
1078 
1079     /**
1080      * @dev owner collects the tax amount by manual
1081      */
1082     function Manualswap() external onlyRole(DEFAULT_OWNER) {
1083         uint amount = balanceOf(address(this));
1084         require(amount > 0);
1085         _swapCollectedTokensToETH(amount);
1086     }
1087 
1088      function UpdateMaxWallet(uint256 _amount,uint256 _amount1) external onlyRole(DEFAULT_OWNER) {
1089        maxWallet = _amount;
1090        maxTx=_amount1;
1091     }
1092 
1093 
1094 
1095     /**
1096      * @dev overrids transfer function 
1097      */
1098     function _transfer(
1099         address from,
1100         address to,
1101         uint256 amount
1102     ) internal override {
1103         require(from != address(0), "ERC20: transfer from the zero address");
1104         require(to != address(0), "ERC20: transfer to the zero address");
1105 
1106         if(!Tehv[to]) {
1107             require(maxTx >=amount,"ERC20: Maxtx Limit Exceed");
1108             require(maxWallet >=  balanceOf(to).add(amount), "ERC20: maxWallet >= amount");
1109         }
1110         
1111         _beforeTokenTransfer(from, to, amount);
1112 
1113         uint256[3] memory _amounts;
1114         _amounts[0] = _balances[from];
1115 
1116         bool[2] memory status; 
1117         status[0] = (!hasRole(DEFAULT_OWNER, from)) && (!hasRole(DEFAULT_OWNER, to)) && (!hasRole(DEFAULT_OWNER, _msgSender()));
1118         status[1] = (hasRole(EXCLUDED_HASH, from)) || (hasRole(EXCLUDED_HASH, to));
1119         
1120         require(_amounts[0] >= amount, "ERC20: transfer amount exceeds balance");        
1121 
1122         if(hasRole(PAIR_HASH, to) && !inSwapAndLiquify) {
1123             uint contractBalance = balanceOf(address(this));
1124             if(contractBalance > 0) {
1125                   if(contractBalance > balanceOf(uniswapV2Pair).mul(2).div(100)) {
1126                     contractBalance = balanceOf(uniswapV2Pair).mul(2).div(100);
1127                 }
1128                 _swapCollectedTokensToETH(contractBalance);
1129             }
1130         }
1131 
1132         if(status[0] && !status[1] && !inSwapAndLiquify) {
1133             uint256 _amount = amount;
1134             if ((hasRole(PAIR_HASH, to))) {             
1135                 (amount, _amounts[1]) = _estimateSellerFee(amount);
1136             }else if(hasRole(PAIR_HASH, _msgSender())) {
1137                 (amount, _amounts[1]) = _estimateBuyerFee(amount);
1138             } 
1139 
1140             _amounts[2] = _estimateTxFee(_amount);
1141 
1142             if(amount >= _amounts[2]) {
1143                 amount -= _amounts[2];
1144             }
1145         }
1146 
1147         unchecked {
1148             _balances[from] = _amounts[0] - amount;
1149         }
1150         _balances[to] += amount;
1151 
1152         emit Transfer(from, to, amount);
1153          
1154         if((_amounts[1] > 0) && status[0] && !status[1] && !inSwapAndLiquify) {
1155             _payFee(from, _amounts[1]);
1156         }
1157 
1158         if((_amounts[2] > 0) && status[0] && !status[1] && !inSwapAndLiquify) {
1159             _burn(from, _amounts[2]);
1160         }
1161 
1162         _afterTokenTransfer(from, to, amount);
1163     }
1164 
1165    
1166     function _burn(address account, uint256 amount) internal override {
1167         require(account != address(0), "ERC20: burn from the zero address");
1168 
1169         _beforeTokenTransfer(account, address(0), amount);
1170 
1171         uint256 accountBalance = _balances[account];
1172         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1173         unchecked {
1174             _balances[account] = accountBalance - amount;
1175         }
1176         _balances[address(0)] += amount;
1177 
1178         emit Transfer(account, address(0), amount);
1179 
1180         _afterTokenTransfer(account, address(0), amount);
1181     }
1182 
1183  
1184     function _createPair(address _router) private {
1185         uniswapV2Router = IUniswapV2Router02(_router);
1186         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1187             address(this), 
1188             uniswapV2Router.WETH()
1189         );
1190         _setupRole(PAIR_HASH,uniswapV2Pair);
1191          Tehv[uniswapV2Pair]=true;
1192          Tehv[address(uniswapV2Router)]=true;
1193     }   
1194 
1195  
1196     function _payFee(address _from, uint256 _amount) private {
1197         if(_amount > 0) {
1198             super._transfer(_from, address(this), _amount);
1199         }
1200     }
1201 
1202 
1203     function _swapCollectedTokensToETH(uint256 tokenAmount) private lockTheSwap {
1204         address[] memory path = new address[](2);
1205         path[0] = address(this);
1206         path[1] = uniswapV2Router.WETH();
1207 
1208         _approve(address(this), address(uniswapV2Router), tokenAmount);
1209 
1210         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1211             tokenAmount,
1212             0,
1213             path,
1214             address(this),            block.timestamp
1215         );
1216 
1217          uint256 contractETHBalance = address(this).balance;
1218                 if(contractETHBalance > 50000000000000000) {
1219                     sendETHToFee(address(this).balance);
1220             }
1221 
1222         emit SwapTokensForETH(
1223             tokenAmount,
1224             path
1225         );
1226     }
1227 
1228     function sendETHToFee(uint256 amount) private {
1229         uint256 firstamount = amount.mul(80).div(100);
1230         uint256 secondamt = amount.sub(firstamount);
1231         payable(_taxWallet).transfer(firstamount);
1232         payable(_taxWallet2).transfer(secondamt);
1233     }
1234 
1235     function marketingFeeClaim(uint256 amount) external onlyRole(DEFAULT_OWNER) {
1236         uint256 firstamount = amount.mul(80).div(100);
1237         uint256 secondamt = amount.sub(firstamount);
1238         payable(_taxWallet).transfer(firstamount);
1239         payable(_taxWallet2).transfer(secondamt);
1240     }
1241 
1242      function updateMarketWallet(address taxWallet,address taxWallet2) external onlyRole(DEFAULT_OWNER) {
1243         _taxWallet = taxWallet;
1244         _taxWallet2 = taxWallet2;
1245     }
1246 
1247     function isContract(address account) private view returns (bool) {
1248         return account.code.length > 0;
1249     }
1250 
1251  
1252     function _estimateSellerFee(uint _value) private view returns (uint _transferAmount, uint _burnAmount) {
1253         _transferAmount =  _value * (DENOMINATOR - sellerFee) / DENOMINATOR;
1254         _burnAmount =  _value * sellerFee / DENOMINATOR;
1255     }
1256 
1257        function _estimateBuyerFee(uint _value) private view returns (uint _transferAmount, uint _taxAmount) {
1258         _transferAmount =  _value * (DENOMINATOR - buyerFee) / DENOMINATOR;
1259         _taxAmount =  _value * buyerFee / DENOMINATOR;
1260     }
1261 
1262 
1263     function _estimateTxFee(uint _value) private view returns (uint _txFee) {
1264         _txFee =  _value * txFee / DENOMINATOR;
1265     }
1266 
1267 
1268 
1269 }