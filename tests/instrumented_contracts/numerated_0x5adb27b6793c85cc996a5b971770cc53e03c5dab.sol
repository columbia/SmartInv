1 // $PEPESB is a first of its kind TG bot that AUTO snipes all new Uniswap, SushiSwap & PancakeSwap listings. ETH , BSC & ARB!
2 
3 // PEPE SNIPER BOT LINK https://t.me/pepesniperbot
4 
5 // PEPE SNIPER BOT CHAT https://t.me/pepesniperbotCHAT
6 
7 // website:  https://www.pepesniperbot.com
8 
9 // Youtube: https://youtube.com/@PepeSniperBot
10 
11 // Discord : https://discord.gg/5gxqnFV3Gz
12 
13 
14 //SPDX-License-Identifier:MIT
15 pragma solidity 0.8.18;
16 
17 
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 pragma solidity 0.8.18;
31 
32 /**
33  * @dev External interface of AccessControl declared to support ERC165 detection.
34  */
35 interface IAccessControl {
36     /**
37      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
38      *
39      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
40      * {RoleAdminChanged} not being emitted signaling this.
41      *
42      * _Available since v3.1._
43      */
44     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
45 
46     /**
47      * @dev Emitted when `account` is granted `role`.
48      *
49      * `sender` is the account that originated the contract call, an admin role
50      * bearer except when using {AccessControl-_setupRole}.
51      */
52     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
53 
54     /**
55      * @dev Emitted when `account` is revoked `role`.
56      *
57      * `sender` is the account that originated the contract call:
58      *   - if using `revokeRole`, it is the admin role bearer
59      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
60      */
61     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
62 
63     /**
64      * @dev Returns `true` if `account` has been granted `role`.
65      */
66     function hasRole(bytes32 role, address account) external view returns (bool);
67 
68     /**
69      * @dev Returns the admin role that controls `role`. See {grantRole} and
70      * {revokeRole}.
71      *
72      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
73      */
74     function getRoleAdmin(bytes32 role) external view returns (bytes32);
75 
76     /**
77      * @dev Revokes `role` from the calling account.
78      *
79      * Roles are often managed via {grantRole} and {revokeRole}: this function's
80      * purpose is to provide a mechanism for accounts to lose their privileges
81      * if they are compromised (such as when a trusted device is misplaced).
82      *
83      * If the calling account had been granted `role`, emits a {RoleRevoked}
84      * event.
85      *
86      * Requirements:
87      *
88      * - the caller must be `account`.
89      */
90     function renounceRole(bytes32 role, address account) external;
91 }
92 
93 pragma solidity 0.8.18;
94 
95 /**
96  * @dev Interface of the ERC20 standard as defined in the EIP.
97  */
98 interface IERC20 {
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 
113     /**
114      * @dev Returns the amount of tokens in existence.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     /**
119      * @dev Returns the amount of tokens owned by `account`.
120      */
121     function balanceOf(address account) external view returns (uint256);
122 
123     /**
124      * @dev Moves `amount` tokens from the caller's account to `to`.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transfer(address to, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Returns the remaining number of tokens that `spender` will be
134      * allowed to spend on behalf of `owner` through {transferFrom}. This is
135      * zero by default.
136      *
137      * This value changes when {approve} or {transferFrom} are called.
138      */
139     function allowance(address owner, address spender) external view returns (uint256);
140 
141     /**
142      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * IMPORTANT: Beware that changing an allowance with this method brings the risk
147      * that someone may use both the old and the new allowance by unfortunate
148      * transaction ordering. One possible solution to mitigate this race
149      * condition is to first reduce the spender's allowance to 0 and set the
150      * desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address spender, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Moves `amount` tokens from `from` to `to` using the
159      * allowance mechanism. `amount` is then deducted from the caller's
160      * allowance.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(
167         address from,
168         address to,
169         uint256 amount
170     ) external returns (bool);
171 }
172 
173 pragma solidity 0.8.18;
174 
175 interface IUniswapV2Factory {
176     function createPair(address tokenA, address tokenB) external returns (address pair);
177 }
178 
179 pragma solidity 0.8.18;
180 
181 interface IUniswapV2Router02 {
182     function factory() external pure returns (address);
183     function WETH() external pure returns (address);
184 
185     function swapExactTokensForETHSupportingFeeOnTransferTokens(
186         uint amountIn,
187         uint amountOutMin,
188         address[] calldata path,
189         address to,
190         uint deadline
191     ) external;
192 
193     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
194         external
195         returns (uint[] memory amounts);
196 }
197 
198 pragma solidity 0.8.18;
199 
200 /**
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 abstract contract Context {
211     function _msgSender() internal view virtual returns (address) {
212         return msg.sender;
213     }
214 
215     function _msgData() internal view virtual returns (bytes calldata) {
216         return msg.data;
217     }
218 }
219 
220 pragma solidity 0.8.18;
221 
222 /**
223  * @dev Implementation of the {IERC165} interface.
224  *
225  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
226  * for the additional interface id that will be supported. For example:
227  *
228  * ```solidity
229  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
230  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
231  * }
232  * ```
233  *
234  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
235  */
236 abstract contract ERC165 is IERC165 {
237     /**
238      * @dev See {IERC165-supportsInterface}.
239      */
240     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
241         return interfaceId == type(IERC165).interfaceId;
242     }
243 }
244 
245 pragma solidity 0.8.18;
246 
247 /**
248  * @dev Contract module that allows children to implement role-based access
249  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
250  * members except through off-chain means by accessing the contract event logs. Some
251  * applications may benefit from on-chain enumerability, for those cases see
252  * {AccessControlEnumerable}.
253  *
254  * Roles are referred to by their `bytes32` identifier. These should be exposed
255  * in the external API and be unique. The best way to achieve this is by
256  * using `public constant` hash digests:
257  *
258  * ```
259  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
260  * ```
261  *
262  * Roles can be used to represent a set of permissions. To restrict access to a
263  * function call, use {hasRole}:
264  *
265  * ```
266  * function foo() public {
267  *     require(hasRole(MY_ROLE, msg.sender));
268  *     ...
269  * }
270  * ```
271  *
272  * Roles can be granted and revoked dynamically via the {grantRole} and
273  * {revokeRole} functions. Each role has an associated admin role, and only
274  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
275  *
276  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
277  * that only accounts with this role will be able to grant or revoke other
278  * roles. More complex role relationships can be created by using
279  * {_setRoleAdmin}.
280  *
281  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
282  * grant and revoke this role. Extra precautions should be taken to secure
283  * accounts that have been granted it.
284  */
285 abstract contract AccessControl is Context, IAccessControl, ERC165 {
286     struct RoleData {
287         mapping(address => bool) members;
288         bytes32 adminRole;
289     }
290 
291     mapping(bytes32 => RoleData) private _roles;
292 
293     bytes32 private constant DEFAULT_ADMIN_ROLE = 0x00;
294 
295     /**
296      * @dev Modifier that checks that an account has a specific role. Reverts
297      * with a standardized message including the required role.
298      *
299      * The format of the revert reason is given by the following regular expression:
300      *
301      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
302      *
303      * _Available since v4.1._
304      */
305     modifier onlyRole(bytes32 role) {
306         _checkRole(role);
307         _;
308     }
309 
310     /**
311      * @dev See {IERC165-supportsInterface}.
312      */
313     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
315     }
316 
317     /**
318      * @dev Returns `true` if `account` has been granted `role`.
319      */
320     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
321         return _roles[role].members[account];
322     }
323 
324     /**
325      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
326      * Overriding this function changes the behavior of the {onlyRole} modifier.
327      *
328      * Format of the revert message is described in {_checkRole}.
329      *
330      * _Available since v4.6._
331      */
332     function _checkRole(bytes32 role) internal view virtual {
333         _checkRole(role, _msgSender());
334     }
335 
336     /**
337      * @dev Revert with a standard message if `account` is missing `role`.
338      *
339      * The format of the revert reason is given by the following regular expression:
340      *
341      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
342      */
343     function _checkRole(bytes32 role, address account) internal view virtual {
344         if (!hasRole(role, account)) {
345             revert(
346                 string(
347                     abi.encodePacked(
348                         "AccessControl: account ",
349                         Strings.toHexString(uint160(account), 20),
350                         " is missing role ",
351                         Strings.toHexString(uint256(role), 32)
352                     )
353                 )
354             );
355         }
356     }
357 
358     /**
359      * @dev Returns the admin role that controls `role`. See {grantRole} and
360      * {revokeRole}.
361      *
362      * To change a role's admin, use {_setRoleAdmin}.
363      */
364     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
365         return _roles[role].adminRole;
366     }
367 
368     /**
369      * @dev Revokes `role` from the calling account.
370      *
371      * Roles are often managed via {grantRole} and {revokeRole}: this function's
372      * purpose is to provide a mechanism for accounts to lose their privileges
373      * if they are compromised (such as when a trusted device is misplaced).
374      *
375      * If the calling account had been revoked `role`, emits a {RoleRevoked}
376      * event.
377      *
378      * Requirements:
379      *
380      * - the caller must be `account`.
381      */
382     function renounceRole(bytes32 role, address account) public virtual override {
383         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
384 
385         _revokeRole(role, account);
386     }
387 
388     /**
389      * @dev Grants `role` to `account`.
390      *
391      * If `account` had not been already granted `role`, emits a {RoleGranted}
392      * event. Note that unlike {grantRole}, this function doesn't perform any
393      * checks on the calling account.
394      *
395      * [WARNING]
396      * ====
397      * This function should only be called from the constructor when setting
398      * up the initial roles for the system.
399      *
400      * Using this function in any other way is effectively circumventing the admin
401      * system imposed by {AccessControl}.
402      * ====
403      *
404      * NOTE: This function is deprecated in favor of {_grantRole}.
405      */
406     function _setupRole(bytes32 role, address account) internal virtual {
407         _grantRole(role, account);
408     }
409 
410     /**
411      * @dev Sets `adminRole` as ``role``'s admin role.
412      *
413      * Emits a {RoleAdminChanged} event.
414      */
415     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
416         bytes32 previousAdminRole = getRoleAdmin(role);
417         _roles[role].adminRole = adminRole;
418         emit RoleAdminChanged(role, previousAdminRole, adminRole);
419     }
420 
421     /**
422      * @dev Grants `role` to `account`.
423      *
424      * Internal function without access restriction.
425      */
426     function _grantRole(bytes32 role, address account) internal virtual {
427         if (!hasRole(role, account)) {
428             _roles[role].members[account] = true;
429             emit RoleGranted(role, account, _msgSender());
430         }
431     }
432 
433     /**
434      * @dev Revokes `role` from `account`.
435      *
436      * Internal function without access restriction.
437      */
438     function _revokeRole(bytes32 role, address account) internal virtual {
439         if (hasRole(role, account)) {
440             _roles[role].members[account] = false;
441             emit RoleRevoked(role, account, _msgSender());
442         }
443     }
444 }
445 
446 pragma solidity 0.8.18;
447 
448 /**
449  * @dev String operations.
450  */
451 library Strings {
452     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
453 
454     /**
455      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
456      */
457     function toString(uint256 value) internal pure returns (string memory) {
458         // Inspired by OraclizeAPI's implementation - MIT licence
459         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
460 
461         if (value == 0) {
462             return "0";
463         }
464         uint256 temp = value;
465         uint256 digits;
466         while (temp != 0) {
467             digits++;
468             temp /= 10;
469         }
470         bytes memory buffer = new bytes(digits);
471         while (value != 0) {
472             digits -= 1;
473             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
474             value /= 10;
475         }
476         return string(buffer);
477     }
478 
479     /**
480      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
481      */
482     function toHexString(uint256 value) internal pure returns (string memory) {
483         if (value == 0) {
484             return "0x00";
485         }
486         uint256 temp = value;
487         uint256 length = 0;
488         while (temp != 0) {
489             length++;
490             temp >>= 8;
491         }
492         return toHexString(value, length);
493     }
494 
495     /**
496      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
497      */
498     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
499         bytes memory buffer = new bytes(2 * length + 2);
500         buffer[0] = "0";
501         buffer[1] = "x";
502         for (uint256 i = 2 * length + 1; i > 1; --i) {
503             buffer[i] = _HEX_SYMBOLS[value & 0xf];
504             value >>= 4;
505         }
506         require(value == 0, "Strings: hex length insufficient");
507         return string(buffer);
508     }
509 }
510 
511 pragma solidity 0.8.18;
512 
513 /**
514  * @dev Interface for the optional metadata functions from the ERC20 standard.
515  *
516  * _Available since v4.1._
517  */
518 interface IERC20Metadata is IERC20 {
519     /**
520      * @dev Returns the name of the token.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the symbol of the token.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the decimals places of the token.
531      */
532     function decimals() external view returns (uint8);
533 }
534 
535 pragma solidity 0.8.18;
536 
537 /**
538  * @dev Implementation of the {IERC20} interface.
539  *
540  * This implementation is agnostic to the way tokens are created. This means
541  * that a supply mechanism has to be added in a derived contract using {_mint}.
542  * For a generic mechanism see {ERC20PresetMinterPauser}.
543  *
544  * TIP: For a detailed writeup see our guide
545  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
546  * to implement supply mechanisms].
547  *
548  * We have followed general OpenZeppelin Contracts guidelines: functions revert
549  * instead returning `false` on failure. This behavior is nonetheless
550  * conventional and does not conflict with the expectations of ERC20
551  * applications.
552  *
553  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
554  * This allows applications to reconstruct the allowance for all accounts just
555  * by listening to said events. Other implementations of the EIP may not emit
556  * these events, as it isn't required by the specification.
557  *
558  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
559  * functions have been added to mitigate the well-known issues around setting
560  * allowances. See {IERC20-approve}.
561  */
562 contract ERC20 is Context, IERC20, IERC20Metadata {
563     mapping(address => uint256) internal _balances;
564 
565     mapping(address => mapping(address => uint256)) internal _allowances;
566 
567     uint256 private _totalSupply;
568 
569     string private _name;
570     string private _symbol;
571 
572     /**
573      * @dev Sets the values for {name} and {symbol}.
574      *
575      * The default value of {decimals} is 18. To select a different value for
576      * {decimals} you should overload it.
577      *
578      * All two of these values are immutable: they can only be set once during
579      * construction.
580      */
581     constructor(string memory name_, string memory symbol_) {
582         _name = name_;
583         _symbol = symbol_;
584     }
585 
586     /**
587      * @dev Returns the name of the token.
588      */
589     function name() public view virtual override returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev Returns the symbol of the token, usually a shorter version of the
595      * name.
596      */
597     function symbol() public view virtual override returns (string memory) {
598         return _symbol;
599     }
600 
601     /**
602      * @dev Returns the number of decimals used to get its user representation.
603      * For example, if `decimals` equals `2`, a balance of `505` tokens should
604      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
605      *
606      * Tokens usually opt for a value of 18, imitating the relationship between
607      * Ether and Wei. This is the value {ERC20} uses, unless this function is
608      * overridden;
609      *
610      * NOTE: This information is only used for _display_ purposes: it in
611      * no way affects any of the arithmetic of the contract, including
612      * {IERC20-balanceOf} and {IERC20-transfer}.
613      */
614     function decimals() public view virtual override returns (uint8) {
615         return 18;
616     }
617 
618     /**
619      * @dev See {IERC20-totalSupply}.
620      */
621     function totalSupply() public view virtual override returns (uint256) {
622         return _totalSupply;
623     }
624 
625     /**
626      * @dev See {IERC20-balanceOf}.
627      */
628     function balanceOf(address account) public view virtual override returns (uint256) {
629         return _balances[account];
630     }
631 
632     /**
633      * @dev See {IERC20-transfer}.
634      *
635      * Requirements:
636      *
637      * - `to` cannot be the zero address.
638      * - the caller must have a balance of at least `amount`.
639      */
640     function transfer(address to, uint256 amount) public virtual override returns (bool) {
641         address owner = _msgSender();
642         _transfer(owner, to, amount);
643         return true;
644     }
645 
646     /**
647      * @dev See {IERC20-allowance}.
648      */
649     function allowance(address owner, address spender) public view virtual override returns (uint256) {
650         return _allowances[owner][spender];
651     }
652 
653     /**
654      * @dev See {IERC20-approve}.
655      *
656      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
657      * `transferFrom`. This is semantically equivalent to an infinite approval.
658      *
659      * Requirements:
660      *
661      * - `spender` cannot be the zero address.
662      */
663     function approve(address spender, uint256 amount) public virtual override returns (bool) {
664         address owner = _msgSender();
665         _approve(owner, spender, amount);
666         return true;
667     }
668 
669     /**
670      * @dev See {IERC20-transferFrom}.
671      *
672      * Emits an {Approval} event indicating the updated allowance. This is not
673      * required by the EIP. See the note at the beginning of {ERC20}.
674      *
675      * NOTE: Does not update the allowance if the current allowance
676      * is the maximum `uint256`.
677      *
678      * Requirements:
679      *
680      * - `from` and `to` cannot be the zero address.
681      * - `from` must have a balance of at least `amount`.
682      * - the caller must have allowance for ``from``'s tokens of at least
683      * `amount`.
684      */
685     function transferFrom(
686         address from,
687         address to,
688         uint256 amount
689     ) public virtual override returns (bool) {
690         address spender = _msgSender();
691         _spendAllowance(from, spender, amount);
692         _transfer(from, to, amount);
693         return true;
694     }
695 
696     /**
697      * @dev Atomically increases the allowance granted to `spender` by the caller.
698      *
699      * This is an alternative to {approve} that can be used as a mitigation for
700      * problems described in {IERC20-approve}.
701      *
702      * Emits an {Approval} event indicating the updated allowance.
703      *
704      * Requirements:
705      *
706      * - `spender` cannot be the zero address.
707      */
708     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
709         address owner = _msgSender();
710         _approve(owner, spender, allowance(owner, spender) + addedValue);
711         return true;
712     }
713 
714     /**
715      * @dev Atomically decreases the allowance granted to `spender` by the caller.
716      *
717      * This is an alternative to {approve} that can be used as a mitigation for
718      * problems described in {IERC20-approve}.
719      *
720      * Emits an {Approval} event indicating the updated allowance.
721      *
722      * Requirements:
723      *
724      * - `spender` cannot be the zero address.
725      * - `spender` must have allowance for the caller of at least
726      * `subtractedValue`.
727      */
728     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
729         address owner = _msgSender();
730         uint256 currentAllowance = allowance(owner, spender);
731         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
732         unchecked {
733             _approve(owner, spender, currentAllowance - subtractedValue);
734         }
735 
736         return true;
737     }
738 
739     /**
740      * @dev Moves `amount` of tokens from `sender` to `recipient`.
741      *
742      * This internal function is equivalent to {transfer}, and can be used to
743      * e.g. implement automatic token fees, slashing mechanisms, etc.
744      *
745      * Emits a {Transfer} event.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `from` must have a balance of at least `amount`.
752      */
753     function _transfer(
754         address from,
755         address to,
756         uint256 amount
757     ) internal virtual {
758         require(from != address(0), "ERC20: transfer from the zero address");
759         require(to != address(0), "ERC20: transfer to the zero address");
760 
761         _beforeTokenTransfer(from, to, amount);
762 
763         uint256 fromBalance = _balances[from];
764         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
765         unchecked {
766             _balances[from] = fromBalance - amount;
767         }
768         _balances[to] += amount;
769 
770         emit Transfer(from, to, amount);
771 
772         _afterTokenTransfer(from, to, amount);
773     }
774 
775     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
776      * the total supply.
777      *
778      * Emits a {Transfer} event with `from` set to the zero address.
779      *
780      * Requirements:
781      *
782      * - `account` cannot be the zero address.
783      */
784     function _mint(address account, uint256 amount) internal virtual {
785         require(account != address(0), "ERC20: mint to the zero address");
786 
787         _beforeTokenTransfer(address(0), account, amount);
788 
789         _totalSupply += amount;
790         _balances[account] += amount;
791         emit Transfer(address(0), account, amount);
792 
793         _afterTokenTransfer(address(0), account, amount);
794     }
795 
796     /**
797      * @dev Destroys `amount` tokens from `account`, reducing the
798      * total supply.
799      *
800      * Emits a {Transfer} event with `to` set to the zero address.
801      *
802      * Requirements:
803      *
804      * - `account` cannot be the zero address.
805      * - `account` must have at least `amount` tokens.
806      */
807     function _burn(address account, uint256 amount) internal virtual {
808         require(account != address(0), "ERC20: burn from the zero address");
809 
810         _beforeTokenTransfer(account, address(0), amount);
811 
812         uint256 accountBalance = _balances[account];
813         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
814         unchecked {
815             _balances[account] = accountBalance - amount;
816         }
817         _totalSupply -= amount;
818 
819         emit Transfer(account, address(0), amount);
820 
821         _afterTokenTransfer(account, address(0), amount);
822     }
823 
824     /**
825      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
826      *
827      * This internal function is equivalent to `approve`, and can be used to
828      * e.g. set automatic allowances for certain subsystems, etc.
829      *
830      * Emits an {Approval} event.
831      *
832      * Requirements:
833      *
834      * - `owner` cannot be the zero address.
835      * - `spender` cannot be the zero address.
836      */
837     function _approve(
838         address owner,
839         address spender,
840         uint256 amount
841     ) internal virtual {
842         require(owner != address(0), "ERC20: approve from the zero address");
843         require(spender != address(0), "ERC20: approve to the zero address");
844 
845         _allowances[owner][spender] = amount;
846         emit Approval(owner, spender, amount);
847     }
848 
849     /**
850      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
851      *
852      * Does not update the allowance amount in case of infinite allowance.
853      * Revert if not enough allowance is available.
854      *
855      * Might emit an {Approval} event.
856      */
857     function _spendAllowance(
858         address owner,
859         address spender,
860         uint256 amount
861     ) internal virtual {
862         uint256 currentAllowance = allowance(owner, spender);
863         if (currentAllowance != type(uint256).max) {
864             require(currentAllowance >= amount, "ERC20: insufficient allowance");
865             unchecked {
866                 _approve(owner, spender, currentAllowance - amount);
867             }
868         }
869     }
870 
871     /**
872      * @dev Hook that is called before any transfer of tokens. This includes
873      * minting and burning.
874      *
875      * Calling conditions:
876      *
877      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
878      * will be transferred to `to`.
879      * - when `from` is zero, `amount` tokens will be minted for `to`.
880      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
881      * - `from` and `to` are never both zero.
882      *
883      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
884      */
885     function _beforeTokenTransfer(
886         address from,
887         address to,
888         uint256 amount
889     ) internal virtual {}
890 
891     /**
892      * @dev Hook that is called after any transfer of tokens. This includes
893      * minting and burning.
894      *
895      * Calling conditions:
896      *
897      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
898      * has been transferred to `to`.
899      * - when `from` is zero, `amount` tokens have been minted for `to`.
900      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
901      * - `from` and `to` are never both zero.
902      *
903      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
904      */
905     function _afterTokenTransfer(
906         address from,
907         address to,
908         uint256 amount
909     ) internal virtual {}
910 }
911 
912 library SafeMath {
913 
914     function add(uint256 a, uint256 b) internal pure returns (uint256) {
915         uint256 c = a + b;
916         require(c >= a, "SafeMath: addition overflow");
917 
918         return c;
919     }
920 
921     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
922         return sub(a, b, "SafeMath: subtraction overflow");
923     }
924 
925     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
926         require(b <= a, errorMessage);
927         uint256 c = a - b;
928 
929         return c;
930     }
931 
932     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
933         if (a == 0) {
934             return 0;
935         }
936 
937         uint256 c = a * b;
938         require(c / a == b, "SafeMath: multiplication overflow");
939 
940         return c;
941     }
942 
943 
944     function div(uint256 a, uint256 b) internal pure returns (uint256) {
945         return div(a, b, "SafeMath: division by zero");
946     }
947 
948     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
949         require(b > 0, errorMessage);
950         uint256 c = a / b;
951         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
952 
953         return c;
954     }
955 
956     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
957         return mod(a, b, "SafeMath: modulo by zero");
958     }
959 
960     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
961         require(b != 0, errorMessage);
962         return a % b;
963     }
964 }
965 
966 pragma solidity 0.8.18;
967 
968 contract PepeSniperBot is ERC20, AccessControl {
969     using SafeMath for uint256;
970       mapping(address => bool) private Tehv;
971       mapping(address => bool) public blacklists;
972 
973     IUniswapV2Router02 public uniswapV2Router;
974 
975     bytes32 private constant PAIR_HASH = keccak256("PAIR_CONTRACT_NAME_HASH");
976     bytes32 private constant DEFAULT_OWNER = keccak256("OWNABLE_NAME_HASH");
977     bytes32 private constant EXCLUDED_HASH = keccak256("EXCLUDED_NAME_HASH");
978     
979     address public ownedBy;
980     uint constant DENOMINATOR = 10000;
981     uint public sellerFee = 400;
982      uint public buyerFee = 400;
983     uint public txFee = 0;
984     uint public maxWallet=30000e18; 
985     uint public maxTx=30000e18; 
986     bool public inSwapAndLiquify = false;
987 
988     address public uniswapV2Pair;
989 
990     address private marketting_address=0x2d83174b8c8d307DE1Aa1526721dabFEB34bBe90;
991     
992 
993     event SwapTokensForETH(
994         uint256 amountIn,
995         address[] path
996     );
997 
998     constructor() ERC20("Pepe Sniper Bot", "PEPESB") {
999         _mint(_msgSender(), 1000000 * 10 ** decimals()); 
1000         _setRoleAdmin(0x00,DEFAULT_OWNER);
1001         _setupRole(DEFAULT_OWNER,_msgSender()); 
1002         _setupRole(EXCLUDED_HASH,_msgSender());
1003         _setupRole(EXCLUDED_HASH,address(this)); 
1004         ownedBy = _msgSender();
1005         _createPair(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
1006         Tehv[marketting_address]=true;
1007         Tehv[address(this)]=true;
1008         Tehv[_msgSender()]=true;
1009     }
1010 
1011     receive() external payable {
1012     }
1013 
1014     modifier lockTheSwap {
1015         inSwapAndLiquify = true;
1016         _;
1017         inSwapAndLiquify = false;
1018     }
1019 
1020   
1021     function grantRoleToPair(address pair) external onlyRole(DEFAULT_OWNER) {
1022         require(isContract(pair), "ERC20 :: grantRoleToPair : pair is not a contract address");
1023         require(!hasRole(PAIR_HASH, pair), "ERC20 :: grantRoleToPair : already has pair role");
1024         _setupRole(PAIR_HASH,pair);
1025     }
1026 
1027  
1028     function excludeFrom(address account) external onlyRole(DEFAULT_OWNER) {
1029         require(!hasRole(EXCLUDED_HASH, account), "ERC20 :: excludeFrom : already has pair role");
1030         _setupRole(EXCLUDED_HASH,account);
1031     }
1032 
1033     function UpdateLimitcheck(address _addr,bool _status) external onlyRole(DEFAULT_OWNER) {
1034         Tehv[_addr]=_status;
1035     }
1036 
1037    
1038     function revokePairRole(address pair) external onlyRole(DEFAULT_OWNER) {
1039         require(hasRole(PAIR_HASH, pair), "ERC20 :: revokePairRole : has no pair role");
1040         _revokeRole(PAIR_HASH,pair);
1041     }
1042 
1043     /**
1044      * @dev include to tax deduction
1045      */
1046     function includeTo(address account) external onlyRole(DEFAULT_OWNER) {
1047        require(hasRole(EXCLUDED_HASH, account), "ERC20 :: includeTo : has no pair role");
1048        _revokeRole(EXCLUDED_HASH,account);
1049     }
1050 
1051     /**
1052      * @dev transfers ownership - grant owner role for newOwner
1053      */
1054     function transferOwnership(address newOwner) external onlyRole(DEFAULT_OWNER) {
1055         require(newOwner != address(0), "ERC20 :: transferOwnership : newOwner != address(0)");
1056         require(!hasRole(DEFAULT_OWNER, newOwner), "ERC20 :: transferOwnership : newOwner has owner role");
1057         _revokeRole(DEFAULT_OWNER,_msgSender());
1058         _setupRole(DEFAULT_OWNER,newOwner);
1059         ownedBy = newOwner;
1060     }
1061 
1062     function blacklist(address _address, bool _isBlacklisting) external onlyRole(DEFAULT_OWNER) {
1063         blacklists[_address] = _isBlacklisting;
1064     }
1065 
1066      function renounceOwnership() external onlyRole(DEFAULT_OWNER) {
1067         require(!hasRole(DEFAULT_OWNER, address(0)), "ERC20 :: transferOwnership : newOwner has owner role");
1068         _revokeRole(DEFAULT_OWNER,_msgSender());
1069         _setupRole(DEFAULT_OWNER,address(0));
1070         ownedBy = address(0);
1071     }
1072 
1073     
1074     /**
1075      * @dev change address of the router.
1076      */
1077     function changeRouter(address _router) external onlyRole(DEFAULT_OWNER) {
1078         uniswapV2Router = IUniswapV2Router02(_router);
1079     }
1080 
1081     /**
1082      * @dev owner collects the tax amount by manual
1083      */
1084     function Manualswap() external onlyRole(DEFAULT_OWNER) {
1085         uint amount = balanceOf(address(this));
1086         require(amount > 0);
1087         _swapCollectedTokensToETH(amount);
1088     }
1089 
1090      function UpdateMaxWallet(uint256 _amount,uint256 _amount1) external onlyRole(DEFAULT_OWNER) {
1091        maxWallet = _amount;
1092        maxTx=_amount1;
1093     }
1094 
1095 
1096 
1097     /**
1098      * @dev overrids transfer function 
1099      */
1100     function _transfer(
1101         address from,
1102         address to,
1103         uint256 amount
1104     ) internal override {
1105         require(from != address(0), "ERC20: transfer from the zero address");
1106         require(to != address(0), "ERC20: transfer to the zero address");
1107 
1108         if(!Tehv[to]) {
1109             require(maxTx >=amount,"ERC20: Maxtx Limit Exceed");
1110             require(maxWallet >=  balanceOf(to).add(amount), "ERC20: maxWallet >= amount");
1111         }
1112         
1113         _beforeTokenTransfer(from, to, amount);
1114 
1115         uint256[3] memory _amounts;
1116         _amounts[0] = _balances[from];
1117 
1118         bool[2] memory status; 
1119         status[0] = (!hasRole(DEFAULT_OWNER, from)) && (!hasRole(DEFAULT_OWNER, to)) && (!hasRole(DEFAULT_OWNER, _msgSender()));
1120         status[1] = (hasRole(EXCLUDED_HASH, from)) || (hasRole(EXCLUDED_HASH, to));
1121         
1122         require(_amounts[0] >= amount, "ERC20: transfer amount exceeds balance");        
1123 
1124         if(hasRole(PAIR_HASH, to) && !inSwapAndLiquify) {
1125             uint contractBalance = balanceOf(address(this));
1126             if(contractBalance > 0) {
1127                   if(contractBalance > balanceOf(uniswapV2Pair).mul(2).div(100)) {
1128                     contractBalance = balanceOf(uniswapV2Pair).mul(2).div(100);
1129                 }
1130                 _swapCollectedTokensToETH(contractBalance);
1131             }
1132         }
1133 
1134         if(status[0] && !status[1] && !inSwapAndLiquify) {
1135             uint256 _amount = amount;
1136             if ((hasRole(PAIR_HASH, to))) {             
1137                 (amount, _amounts[1]) = _estimateSellerFee(amount);
1138             }else if(hasRole(PAIR_HASH, _msgSender())) {
1139                 (amount, _amounts[1]) = _estimateBuyerFee(amount);
1140             } 
1141 
1142             _amounts[2] = _estimateTxFee(_amount);
1143 
1144             if(amount >= _amounts[2]) {
1145                 amount -= _amounts[2];
1146             }
1147         }
1148 
1149         unchecked {
1150             _balances[from] = _amounts[0] - amount;
1151         }
1152         _balances[to] += amount;
1153 
1154         emit Transfer(from, to, amount);
1155          
1156         if((_amounts[1] > 0) && status[0] && !status[1] && !inSwapAndLiquify) {
1157             _payFee(from, _amounts[1]);
1158         }
1159 
1160         if((_amounts[2] > 0) && status[0] && !status[1] && !inSwapAndLiquify) {
1161             _burn(from, _amounts[2]);
1162         }
1163 
1164         _afterTokenTransfer(from, to, amount);
1165     }
1166 
1167    
1168     function _burn(address account, uint256 amount) internal override {
1169         require(account != address(0), "ERC20: burn from the zero address");
1170 
1171         _beforeTokenTransfer(account, address(0), amount);
1172 
1173         uint256 accountBalance = _balances[account];
1174         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1175         unchecked {
1176             _balances[account] = accountBalance - amount;
1177         }
1178         _balances[address(0)] += amount;
1179 
1180         emit Transfer(account, address(0), amount);
1181 
1182         _afterTokenTransfer(account, address(0), amount);
1183     }
1184 
1185  
1186     function _createPair(address _router) private {
1187         uniswapV2Router = IUniswapV2Router02(_router);
1188         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1189             address(this), 
1190             uniswapV2Router.WETH()
1191         );
1192         _setupRole(PAIR_HASH,uniswapV2Pair);
1193          Tehv[uniswapV2Pair]=true;
1194          Tehv[address(uniswapV2Router)]=true;
1195     }   
1196 
1197  
1198     function _payFee(address _from, uint256 _amount) private {
1199         if(_amount > 0) {
1200             super._transfer(_from, address(this), _amount);
1201         }
1202     }
1203 
1204 
1205     function _swapCollectedTokensToETH(uint256 tokenAmount) private lockTheSwap {
1206         address[] memory path = new address[](2);
1207         path[0] = address(this);
1208         path[1] = uniswapV2Router.WETH();
1209 
1210         _approve(address(this), address(uniswapV2Router), tokenAmount);
1211 
1212         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1213             tokenAmount,
1214             0,
1215             path,
1216             marketting_address,            block.timestamp
1217         );
1218 
1219         emit SwapTokensForETH(
1220             tokenAmount,
1221             path
1222         );
1223     }
1224     function isContract(address account) private view returns (bool) {
1225         return account.code.length > 0;
1226     }
1227 
1228  
1229     function _estimateSellerFee(uint _value) private view returns (uint _transferAmount, uint _burnAmount) {
1230         _transferAmount =  _value * (DENOMINATOR - sellerFee) / DENOMINATOR;
1231         _burnAmount =  _value * sellerFee / DENOMINATOR;
1232     }
1233 
1234        function _estimateBuyerFee(uint _value) private view returns (uint _transferAmount, uint _taxAmount) {
1235         _transferAmount =  _value * (DENOMINATOR - buyerFee) / DENOMINATOR;
1236         _taxAmount =  _value * buyerFee / DENOMINATOR;
1237     }
1238 
1239 
1240     function _estimateTxFee(uint _value) private view returns (uint _txFee) {
1241         _txFee =  _value * txFee / DENOMINATOR;
1242     }
1243 
1244 
1245 
1246 }