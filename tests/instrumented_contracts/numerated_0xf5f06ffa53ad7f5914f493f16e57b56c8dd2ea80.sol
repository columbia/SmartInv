1 pragma solidity 0.8.6;
2 
3 /**
4 * @title Jelly Token:
5 *     
6 *              ,,,,
7 *            g@@@@@@K
8 *           ]@@@@@@@@P
9 *            $@@@@@@@"                   ]@@@  ]@@@
10 *             "*NNM"                     ]@@@  ]@@@
11 *                                        ]@@@  ]@@@
12 *             ,g@@@g        ,,gg@gg,     ]@@@  ]@@@ ,ggg          ,ggg
13 *            @@@@@@@@p    g@@@BPMBB@@W   ]@@@  ]@@@  $@@@        ,@@@P
14 *           ]@@@@@@@@@   @@@P      ]@@@  ]@@@  ]@@@   $@@g      ,@@@P
15 *           ]@@@@@@@@@  $@@D,,,,,,,,]@@@ ]@@@  ]@@@   '@@@p     @@@C
16 *           ]@@@@@@@@@  @@@@NNNNNNNNNNNN ]@@@  ]@@@    "@@@p   @@@P
17 *           ]@@@@@@@@@  ]@@K             ]@@@  ]@@@     '@@@, @@@P
18 *            @@@@@@@@@   %@@@,    ,g@@@  ]@@@  ]@@@      ^@@@@@@C
19 *            "@@@@@@@@    "N@@@@@@@@N*   ]@@@  ]@@@       "*@@@P
20 *             "B@@@@@@        "**""       '''   '''        @@@P
21 *    ,gg@@g    "B@@@P                                     @@@P
22 *   @@@@@@@@p    B@@'                                    @@@P
23 *   @@@@@@@@P    ]@h                                    RNNP
24 *   'B@@@@@@     $P
25 *       "NE@@@p"'          
26 *         
27 *
28 */
29 
30 /** 
31 * @author ProfWobble & Jiggle
32 * @dev
33 *  - Ability for holders to burn (destroy) their tokens
34 *  - Minter role that allows for token minting
35 *  - Token transfers paused on deployment (Jelly not set yet!). 
36 *  - An operator role that allows for transfers of unset tokens.
37 *  - SetJelly() function that allows $JELLY to transfer when ready. 
38 *
39 */
40 
41 
42 
43 /**
44  * @dev Provides information about the current execution context, including the
45  * sender of the transaction and its data. While these are generally available
46  * via msg.sender and msg.data, they should not be accessed in such a direct
47  * manner, since when dealing with meta-transactions the account sending and
48  * paying for execution may not be the actual sender (as far as an application
49  * is concerned).
50  *
51  * This contract is only required for intermediate, library-like contracts.
52  */
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         return msg.data;
60     }
61 }
62 
63 
64 /**
65  * @dev External interface of AccessControl declared to support ERC165 detection.
66  */
67 interface IAccessControl {
68     function hasRole(bytes32 role, address account) external view returns (bool);
69 
70     function getRoleAdmin(bytes32 role) external view returns (bytes32);
71 
72     function grantRole(bytes32 role, address account) external;
73 
74     function revokeRole(bytes32 role, address account) external;
75 
76     function renounceRole(bytes32 role, address account) external;
77 }
78 
79 
80 /**
81  * @dev Interface of the ERC165 standard, as defined in the
82  * https://eips.ethereum.org/EIPS/eip-165[EIP].
83  *
84  * Implementers can declare support of contract interfaces, which can then be
85  * queried by others ({ERC165Checker}).
86  *
87  * For an implementation, see {ERC165}.
88  */
89 interface IERC165 {
90     /**
91      * @dev Returns true if this contract implements the interface defined by
92      * `interfaceId`. See the corresponding
93      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
94      * to learn more about how these ids are created.
95      *
96      * This function call must use less than 30 000 gas.
97      */
98     function supportsInterface(bytes4 interfaceId) external view returns (bool);
99 }
100 
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface OZIERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 
181 /**
182  * @dev String operations.
183  */
184 library Strings {
185     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
186 
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
189      */
190     function toString(uint256 value) internal pure returns (string memory) {
191         // Inspired by OraclizeAPI's implementation - MIT licence
192         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
193 
194         if (value == 0) {
195             return "0";
196         }
197         uint256 temp = value;
198         uint256 digits;
199         while (temp != 0) {
200             digits++;
201             temp /= 10;
202         }
203         bytes memory buffer = new bytes(digits);
204         while (value != 0) {
205             digits -= 1;
206             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
207             value /= 10;
208         }
209         return string(buffer);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
214      */
215     function toHexString(uint256 value) internal pure returns (string memory) {
216         if (value == 0) {
217             return "0x00";
218         }
219         uint256 temp = value;
220         uint256 length = 0;
221         while (temp != 0) {
222             length++;
223             temp >>= 8;
224         }
225         return toHexString(value, length);
226     }
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
230      */
231     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
232         bytes memory buffer = new bytes(2 * length + 2);
233         buffer[0] = "0";
234         buffer[1] = "x";
235         for (uint256 i = 2 * length + 1; i > 1; --i) {
236             buffer[i] = _HEX_SYMBOLS[value & 0xf];
237             value >>= 4;
238         }
239         require(value == 0, "Strings: hex length insufficient");
240         return string(buffer);
241     }
242 }
243 
244 
245 /**
246  * @dev Implementation of the {IERC165} interface.
247  *
248  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
249  * for the additional interface id that will be supported. For example:
250  *
251  * ```solidity
252  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
253  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
254  * }
255  * ```
256  *
257  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
258  */
259 abstract contract ERC165 is IERC165 {
260     /**
261      * @dev See {IERC165-supportsInterface}.
262      */
263     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
264         return interfaceId == type(IERC165).interfaceId;
265     }
266 }
267 
268 // Part: IERC20Metadata
269 
270 /**
271  * @dev Interface for the optional metadata functions from the ERC20 standard.
272  *
273  * _Available since v4.1._
274  */
275 interface IERC20Metadata is OZIERC20 {
276     /**
277      * @dev Returns the name of the token.
278      */
279     function name() external view returns (string memory);
280 
281     /**
282      * @dev Returns the symbol of the token.
283      */
284     function symbol() external view returns (string memory);
285 
286     /**
287      * @dev Returns the decimals places of the token.
288      */
289     function decimals() external view returns (uint8);
290 }
291 
292 
293 /**
294  * @dev Contract module which allows children to implement an emergency stop
295  * mechanism that can be triggered by an authorized account.
296  *
297  * This module is used through inheritance. It will make available the
298  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
299  * the functions of your contract. Note that they will not be pausable by
300  * simply including this module, only once the modifiers are put in place.
301  */
302 abstract contract Pausable is Context {
303     /**
304      * @dev Emitted when the pause is triggered by `account`.
305      */
306     event Paused(address account);
307 
308     /**
309      * @dev Emitted when the pause is lifted by `account`.
310      */
311     event Unpaused(address account);
312 
313     bool private _paused;
314 
315     /**
316      * @dev Initializes the contract in unpaused state.
317      */
318     constructor() {
319         _paused = false;
320     }
321 
322     /**
323      * @dev Returns true if the contract is paused, and false otherwise.
324      */
325     function paused() public view virtual returns (bool) {
326         return _paused;
327     }
328 
329     /**
330      * @dev Modifier to make a function callable only when the contract is not paused.
331      *
332      * Requirements:
333      *
334      * - The contract must not be paused.
335      */
336     modifier whenNotPaused() {
337         require(!paused(), "Pausable: paused");
338         _;
339     }
340 
341     /**
342      * @dev Modifier to make a function callable only when the contract is paused.
343      *
344      * Requirements:
345      *
346      * - The contract must be paused.
347      */
348     modifier whenPaused() {
349         require(paused(), "Pausable: not paused");
350         _;
351     }
352 
353     /**
354      * @dev Triggers stopped state.
355      *
356      * Requirements:
357      *
358      * - The contract must not be paused.
359      */
360     function _pause() internal virtual whenNotPaused {
361         _paused = true;
362         emit Paused(_msgSender());
363     }
364 
365     /**
366      * @dev Returns to normal state.
367      *
368      * Requirements:
369      *
370      * - The contract must be paused.
371      */
372     function _unpause() internal virtual whenPaused {
373         _paused = false;
374         emit Unpaused(_msgSender());
375     }
376 }
377 
378 
379 /**
380  * @dev Contract module that allows children to implement role-based access
381  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
382  * members except through off-chain means by accessing the contract event logs. Some
383  * applications may benefit from on-chain enumerability, for those cases see
384  * {AccessControlEnumerable}.
385  *
386  * Roles are referred to by their `bytes32` identifier. These should be exposed
387  * in the external API and be unique. The best way to achieve this is by
388  * using `public constant` hash digests:
389  *
390  * ```
391  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
392  * ```
393  *
394  * Roles can be used to represent a set of permissions. To restrict access to a
395  * function call, use {hasRole}:
396  *
397  * ```
398  * function foo() public {
399  *     require(hasRole(MY_ROLE, msg.sender));
400  *     ...
401  * }
402  * ```
403  *
404  * Roles can be granted and revoked dynamically via the {grantRole} and
405  * {revokeRole} functions. Each role has an associated admin role, and only
406  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
407  *
408  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
409  * that only accounts with this role will be able to grant or revoke other
410  * roles. More complex role relationships can be created by using
411  * {_setRoleAdmin}.
412  *
413  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
414  * grant and revoke this role. Extra precautions should be taken to secure
415  * accounts that have been granted it.
416  */
417 abstract contract AccessControl is Context, IAccessControl, ERC165 {
418     struct RoleData {
419         mapping(address => bool) members;
420         bytes32 adminRole;
421     }
422 
423     mapping(bytes32 => RoleData) private _roles;
424 
425     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
426 
427     /**
428      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
429      *
430      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
431      * {RoleAdminChanged} not being emitted signaling this.
432      *
433      * _Available since v3.1._
434      */
435     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
436 
437     /**
438      * @dev Emitted when `account` is granted `role`.
439      *
440      * `sender` is the account that originated the contract call, an admin role
441      * bearer except when using {_setupRole}.
442      */
443     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
444 
445     /**
446      * @dev Emitted when `account` is revoked `role`.
447      *
448      * `sender` is the account that originated the contract call:
449      *   - if using `revokeRole`, it is the admin role bearer
450      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
451      */
452     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
453 
454     /**
455      * @dev Modifier that checks that an account has a specific role. Reverts
456      * with a standardized message including the required role.
457      *
458      * The format of the revert reason is given by the following regular expression:
459      *
460      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
461      *
462      * _Available since v4.1._
463      */
464     modifier onlyRole(bytes32 role) {
465         _checkRole(role, _msgSender());
466         _;
467     }
468 
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      */
472     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
474     }
475 
476     /**
477      * @dev Returns `true` if `account` has been granted `role`.
478      */
479     function hasRole(bytes32 role, address account) public view override returns (bool) {
480         return _roles[role].members[account];
481     }
482 
483     /**
484      * @dev Revert with a standard message if `account` is missing `role`.
485      *
486      * The format of the revert reason is given by the following regular expression:
487      *
488      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
489      */
490     function _checkRole(bytes32 role, address account) internal view {
491         if (!hasRole(role, account)) {
492             revert(
493                 string(
494                     abi.encodePacked(
495                         "AccessControl: account ",
496                         Strings.toHexString(uint160(account), 20),
497                         " is missing role ",
498                         Strings.toHexString(uint256(role), 32)
499                     )
500                 )
501             );
502         }
503     }
504 
505     /**
506      * @dev Returns the admin role that controls `role`. See {grantRole} and
507      * {revokeRole}.
508      *
509      * To change a role's admin, use {_setRoleAdmin}.
510      */
511     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
512         return _roles[role].adminRole;
513     }
514 
515     /**
516      * @dev Grants `role` to `account`.
517      *
518      * If `account` had not been already granted `role`, emits a {RoleGranted}
519      * event.
520      *
521      * Requirements:
522      *
523      * - the caller must have ``role``'s admin role.
524      */
525     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
526         _grantRole(role, account);
527     }
528 
529     /**
530      * @dev Revokes `role` from `account`.
531      *
532      * If `account` had been granted `role`, emits a {RoleRevoked} event.
533      *
534      * Requirements:
535      *
536      * - the caller must have ``role``'s admin role.
537      */
538     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
539         _revokeRole(role, account);
540     }
541 
542     /**
543      * @dev Revokes `role` from the calling account.
544      *
545      * Roles are often managed via {grantRole} and {revokeRole}: this function's
546      * purpose is to provide a mechanism for accounts to lose their privileges
547      * if they are compromised (such as when a trusted device is misplaced).
548      *
549      * If the calling account had been granted `role`, emits a {RoleRevoked}
550      * event.
551      *
552      * Requirements:
553      *
554      * - the caller must be `account`.
555      */
556     function renounceRole(bytes32 role, address account) public virtual override {
557         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
558 
559         _revokeRole(role, account);
560     }
561 
562     /**
563      * @dev Grants `role` to `account`.
564      *
565      * If `account` had not been already granted `role`, emits a {RoleGranted}
566      * event. Note that unlike {grantRole}, this function doesn't perform any
567      * checks on the calling account.
568      *
569      * [WARNING]
570      * ====
571      * This function should only be called from the constructor when setting
572      * up the initial roles for the system.
573      *
574      * Using this function in any other way is effectively circumventing the admin
575      * system imposed by {AccessControl}.
576      * ====
577      */
578     function _setupRole(bytes32 role, address account) internal virtual {
579         _grantRole(role, account);
580     }
581 
582     /**
583      * @dev Sets `adminRole` as ``role``'s admin role.
584      *
585      * Emits a {RoleAdminChanged} event.
586      */
587     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
588         bytes32 previousAdminRole = getRoleAdmin(role);
589         _roles[role].adminRole = adminRole;
590         emit RoleAdminChanged(role, previousAdminRole, adminRole);
591     }
592 
593     function _grantRole(bytes32 role, address account) private {
594         if (!hasRole(role, account)) {
595             _roles[role].members[account] = true;
596             emit RoleGranted(role, account, _msgSender());
597         }
598     }
599 
600     function _revokeRole(bytes32 role, address account) private {
601         if (hasRole(role, account)) {
602             _roles[role].members[account] = false;
603             emit RoleRevoked(role, account, _msgSender());
604         }
605     }
606 }
607 
608 
609 /**
610  * @dev Implementation of the {IERC20} interface.
611  *
612  * This implementation is agnostic to the way tokens are created. This means
613  * that a supply mechanism has to be added in a derived contract using {_mint}.
614  * For a generic mechanism see {ERC20PresetMinterPauser}.
615  *
616  * TIP: For a detailed writeup see our guide
617  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
618  * to implement supply mechanisms].
619  *
620  * We have followed general OpenZeppelin Contracts guidelines: functions revert
621  * instead returning `false` on failure. This behavior is nonetheless
622  * conventional and does not conflict with the expectations of ERC20
623  * applications.
624  *
625  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
626  * This allows applications to reconstruct the allowance for all accounts just
627  * by listening to said events. Other implementations of the EIP may not emit
628  * these events, as it isn't required by the specification.
629  *
630  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
631  * functions have been added to mitigate the well-known issues around setting
632  * allowances. See {IERC20-approve}.
633  */
634 contract ERC20 is Context, OZIERC20, IERC20Metadata {
635     mapping(address => uint256) private _balances;
636 
637     mapping(address => mapping(address => uint256)) private _allowances;
638 
639     uint256 private _totalSupply;
640 
641     // PW: Changed to internal here to be able to setJelly()
642     string internal _name;
643     string internal _symbol;
644 
645     /**
646      * @dev Sets the values for {name} and {symbol}.
647      *
648      * The default value of {decimals} is 18. To select a different value for
649      * {decimals} you should overload it.
650      *
651      * All two of these values are immutable: they can only be set once during
652      * construction.
653      */
654     constructor(string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657     }
658 
659     /**
660      * @dev Returns the name of the token.
661      */
662     function name() public view virtual override returns (string memory) {
663         return _name;
664     }
665 
666     /**
667      * @dev Returns the symbol of the token, usually a shorter version of the
668      * name.
669      */
670     function symbol() public view virtual override returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @dev Returns the number of decimals used to get its user representation.
676      * For example, if `decimals` equals `2`, a balance of `505` tokens should
677      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
678      *
679      * Tokens usually opt for a value of 18, imitating the relationship between
680      * Ether and Wei. This is the value {ERC20} uses, unless this function is
681      * overridden;
682      *
683      * NOTE: This information is only used for _display_ purposes: it in
684      * no way affects any of the arithmetic of the contract, including
685      * {IERC20-balanceOf} and {IERC20-transfer}.
686      */
687     function decimals() public view virtual override returns (uint8) {
688         return 18;
689     }
690 
691     /**
692      * @dev See {IERC20-totalSupply}.
693      */
694     function totalSupply() public view virtual override returns (uint256) {
695         return _totalSupply;
696     }
697 
698     /**
699      * @dev See {IERC20-balanceOf}.
700      */
701     function balanceOf(address account) public view virtual override returns (uint256) {
702         return _balances[account];
703     }
704 
705     /**
706      * @dev See {IERC20-transfer}.
707      *
708      * Requirements:
709      *
710      * - `recipient` cannot be the zero address.
711      * - the caller must have a balance of at least `amount`.
712      */
713     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
714         _transfer(_msgSender(), recipient, amount);
715         return true;
716     }
717 
718     /**
719      * @dev See {IERC20-allowance}.
720      */
721     function allowance(address owner, address spender) public view virtual override returns (uint256) {
722         return _allowances[owner][spender];
723     }
724 
725     /**
726      * @dev See {IERC20-approve}.
727      *
728      * Requirements:
729      *
730      * - `spender` cannot be the zero address.
731      */
732     function approve(address spender, uint256 amount) public virtual override returns (bool) {
733         _approve(_msgSender(), spender, amount);
734         return true;
735     }
736 
737     /**
738      * @dev See {IERC20-transferFrom}.
739      *
740      * Emits an {Approval} event indicating the updated allowance. This is not
741      * required by the EIP. See the note at the beginning of {ERC20}.
742      *
743      * Requirements:
744      *
745      * - `sender` and `recipient` cannot be the zero address.
746      * - `sender` must have a balance of at least `amount`.
747      * - the caller must have allowance for ``sender``'s tokens of at least
748      * `amount`.
749      */
750     function transferFrom(
751         address sender,
752         address recipient,
753         uint256 amount
754     ) public virtual override returns (bool) {
755         _transfer(sender, recipient, amount);
756 
757         uint256 currentAllowance = _allowances[sender][_msgSender()];
758         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
759         unchecked {
760             _approve(sender, _msgSender(), currentAllowance - amount);
761         }
762 
763         return true;
764     }
765 
766     /**
767      * @dev Atomically increases the allowance granted to `spender` by the caller.
768      *
769      * This is an alternative to {approve} that can be used as a mitigation for
770      * problems described in {IERC20-approve}.
771      *
772      * Emits an {Approval} event indicating the updated allowance.
773      *
774      * Requirements:
775      *
776      * - `spender` cannot be the zero address.
777      */
778     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
779         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
780         return true;
781     }
782 
783     /**
784      * @dev Atomically decreases the allowance granted to `spender` by the caller.
785      *
786      * This is an alternative to {approve} that can be used as a mitigation for
787      * problems described in {IERC20-approve}.
788      *
789      * Emits an {Approval} event indicating the updated allowance.
790      *
791      * Requirements:
792      *
793      * - `spender` cannot be the zero address.
794      * - `spender` must have allowance for the caller of at least
795      * `subtractedValue`.
796      */
797     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
798         uint256 currentAllowance = _allowances[_msgSender()][spender];
799         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
800         unchecked {
801             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
802         }
803 
804         return true;
805     }
806 
807     /**
808      * @dev Moves `amount` of tokens from `sender` to `recipient`.
809      *
810      * This internal function is equivalent to {transfer}, and can be used to
811      * e.g. implement automatic token fees, slashing mechanisms, etc.
812      *
813      * Emits a {Transfer} event.
814      *
815      * Requirements:
816      *
817      * - `sender` cannot be the zero address.
818      * - `recipient` cannot be the zero address.
819      * - `sender` must have a balance of at least `amount`.
820      */
821     function _transfer(
822         address sender,
823         address recipient,
824         uint256 amount
825     ) internal virtual {
826         require(sender != address(0), "ERC20: transfer from the zero address");
827         require(recipient != address(0), "ERC20: transfer to the zero address");
828 
829         _beforeTokenTransfer(sender, recipient, amount);
830 
831         uint256 senderBalance = _balances[sender];
832         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
833         unchecked {
834             _balances[sender] = senderBalance - amount;
835         }
836         _balances[recipient] += amount;
837 
838         emit Transfer(sender, recipient, amount);
839 
840         _afterTokenTransfer(sender, recipient, amount);
841     }
842 
843     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
844      * the total supply.
845      *
846      * Emits a {Transfer} event with `from` set to the zero address.
847      *
848      * Requirements:
849      *
850      * - `account` cannot be the zero address.
851      */
852     function _mint(address account, uint256 amount) internal virtual {
853         require(account != address(0), "ERC20: mint to the zero address");
854 
855         _beforeTokenTransfer(address(0), account, amount);
856 
857         _totalSupply += amount;
858         _balances[account] += amount;
859         emit Transfer(address(0), account, amount);
860 
861         _afterTokenTransfer(address(0), account, amount);
862     }
863 
864     /**
865      * @dev Destroys `amount` tokens from `account`, reducing the
866      * total supply.
867      *
868      * Emits a {Transfer} event with `to` set to the zero address.
869      *
870      * Requirements:
871      *
872      * - `account` cannot be the zero address.
873      * - `account` must have at least `amount` tokens.
874      */
875     function _burn(address account, uint256 amount) internal virtual {
876         require(account != address(0), "ERC20: burn from the zero address");
877 
878         _beforeTokenTransfer(account, address(0), amount);
879 
880         uint256 accountBalance = _balances[account];
881         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
882         unchecked {
883             _balances[account] = accountBalance - amount;
884         }
885         _totalSupply -= amount;
886 
887         emit Transfer(account, address(0), amount);
888 
889         _afterTokenTransfer(account, address(0), amount);
890     }
891 
892     /**
893      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
894      *
895      * This internal function is equivalent to `approve`, and can be used to
896      * e.g. set automatic allowances for certain subsystems, etc.
897      *
898      * Emits an {Approval} event.
899      *
900      * Requirements:
901      *
902      * - `owner` cannot be the zero address.
903      * - `spender` cannot be the zero address.
904      */
905     function _approve(
906         address owner,
907         address spender,
908         uint256 amount
909     ) internal virtual {
910         require(owner != address(0), "ERC20: approve from the zero address");
911         require(spender != address(0), "ERC20: approve to the zero address");
912 
913         _allowances[owner][spender] = amount;
914         emit Approval(owner, spender, amount);
915     }
916 
917     /**
918      * @dev Hook that is called before any transfer of tokens. This includes
919      * minting and burning.
920      *
921      * Calling conditions:
922      *
923      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
924      * will be transferred to `to`.
925      * - when `from` is zero, `amount` tokens will be minted for `to`.
926      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
927      * - `from` and `to` are never both zero.
928      *
929      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
930      */
931     function _beforeTokenTransfer(
932         address from,
933         address to,
934         uint256 amount
935     ) internal virtual {}
936 
937     /**
938      * @dev Hook that is called after any transfer of tokens. This includes
939      * minting and burning.
940      *
941      * Calling conditions:
942      *
943      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
944      * has been transferred to `to`.
945      * - when `from` is zero, `amount` tokens have been minted for `to`.
946      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
947      * - `from` and `to` are never both zero.
948      *
949      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
950      */
951     function _afterTokenTransfer(
952         address from,
953         address to,
954         uint256 amount
955     ) internal virtual {}
956 }
957 
958 
959 contract JellyAdminAccess is AccessControl {
960 
961     /// @dev Whether access is initialised.
962     bool private initAccess;
963 
964     /// @notice Events for adding and removing various roles.
965     event AdminRoleGranted(
966         address indexed beneficiary,
967         address indexed caller
968     );
969 
970     event AdminRoleRemoved(
971         address indexed beneficiary,
972         address indexed caller
973     );
974 
975 
976     /// @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses.
977     constructor() {
978         initAccessControls(_msgSender());
979     }
980 
981     /**
982      * @notice Initializes access controls.
983      * @param _admin Admins address.
984      */
985     function initAccessControls(address _admin) public {
986         require(!initAccess, "Already initialised");
987         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
988         initAccess = true;
989     }
990 
991     /////////////
992     // Lookups //
993     /////////////
994 
995     /**
996      * @notice Used to check whether an address has the admin role.
997      * @param _address EOA or contract being checked.
998      * @return bool True if the account has the role or false if it does not.
999      */
1000     function hasAdminRole(address _address) public  view returns (bool) {
1001         return hasRole(DEFAULT_ADMIN_ROLE, _address);
1002     }
1003 
1004     ///////////////
1005     // Modifiers //
1006     ///////////////
1007 
1008     /**
1009      * @notice Grants the admin role to an address.
1010      * @dev The sender must have the admin role.
1011      * @param _address EOA or contract receiving the new role.
1012      */
1013     function addAdminRole(address _address) external {
1014         grantRole(DEFAULT_ADMIN_ROLE, _address);
1015         emit AdminRoleGranted(_address, _msgSender());
1016     }
1017 
1018     /**
1019      * @notice Removes the admin role from an address.
1020      * @dev The sender must have the admin role.
1021      * @param _address EOA or contract affected.
1022      */
1023     function removeAdminRole(address _address) external {
1024         revokeRole(DEFAULT_ADMIN_ROLE, _address);
1025         emit AdminRoleRemoved(_address, _msgSender());
1026     }
1027 }
1028 
1029 
1030 contract JellyOperatorAccess is JellyAdminAccess {
1031     /// @notice Role definitions
1032     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
1033 
1034     /// @notice Events for adding and removing various roles
1035 
1036     event OperatorRoleGranted(
1037         address indexed beneficiary,
1038         address indexed caller
1039     );
1040 
1041     event OperatorRoleRemoved(
1042         address indexed beneficiary,
1043         address indexed caller
1044     );
1045 
1046 
1047     constructor()  {
1048     }
1049 
1050 
1051     /////////////
1052     // Lookups //
1053     /////////////
1054 
1055     /**
1056      * @notice Used to check whether an address has the operator role
1057      * @param _address EOA or contract being checked
1058      * @return bool True if the account has the role or false if it does not
1059      */
1060     function hasOperatorRole(address _address) public view returns (bool) {
1061         return hasRole(OPERATOR_ROLE, _address);
1062     }
1063 
1064     ///////////////
1065     // Modifiers //
1066     ///////////////
1067 
1068     /**
1069      * @notice Grants the operator role to an address
1070      * @dev The sender must have the admin role
1071      * @param _address EOA or contract receiving the new role
1072      */
1073     function addOperatorRole(address _address) external {
1074         grantRole(OPERATOR_ROLE, _address);
1075         emit OperatorRoleGranted(_address, _msgSender());
1076     }
1077 
1078     /**
1079      * @notice Removes the operator role from an address
1080      * @dev The sender must have the admin role
1081      * @param _address EOA or contract affected
1082      */
1083     function removeOperatorRole(address _address) external {
1084         revokeRole(OPERATOR_ROLE, _address);
1085         emit OperatorRoleRemoved(_address, _msgSender());
1086     }
1087 
1088 
1089 }
1090 
1091 
1092 contract JellyMinterAccess is JellyOperatorAccess {
1093     /// @notice Role definitions
1094     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1095 
1096     /// @notice Events for adding and removing various roles
1097 
1098     event MinterRoleGranted(
1099         address indexed beneficiary,
1100         address indexed caller
1101     );
1102 
1103     event MinterRoleRemoved(
1104         address indexed beneficiary,
1105         address indexed caller
1106     );
1107 
1108     constructor()  {
1109     }
1110 
1111 
1112     /////////////
1113     // Lookups //
1114     /////////////
1115 
1116     /**
1117      * @notice Used to check whether an address has the minter role
1118      * @param _address EOA or contract being checked
1119      * @return bool True if the account has the role or false if it does not
1120      */
1121     function hasMinterRole(address _address) public view returns (bool) {
1122         return hasRole(MINTER_ROLE, _address);
1123     }
1124 
1125     ///////////////
1126     // Modifiers //
1127     ///////////////
1128 
1129     /**
1130      * @notice Grants the minter role to an address
1131      * @dev The sender must have the admin role
1132      * @param _address EOA or contract receiving the new role
1133      */
1134     function addMinterRole(address _address) external {
1135         grantRole(MINTER_ROLE, _address);
1136         emit MinterRoleGranted(_address, _msgSender());
1137     }
1138 
1139     /**
1140      * @notice Removes the minter role from an address
1141      * @dev The sender must have the admin role
1142      * @param _address EOA or contract affected
1143      */
1144     function removeMinterRole(address _address) external {
1145         revokeRole(MINTER_ROLE, _address);
1146         emit MinterRoleRemoved(_address, _msgSender());
1147     }
1148 
1149 
1150 }
1151 
1152 /**
1153  * @dev Jelly {ERC20} token:
1154  *
1155  *  - A minter role that allows for token minting
1156  *  - Ability for holders to burn (destroy) their tokens
1157  *  - Token transfers paused on deployment (unset jelly). 
1158  *  - An operator role that allows for transfers of unset tokens.
1159  *  - SetJelly() function that allows for $JELLY to trade freely. 
1160  *
1161  */
1162 
1163 contract Jelly is ERC20, Pausable, JellyMinterAccess {
1164 
1165     uint public cap;
1166     event CapUpdated(uint256 cap);
1167     event JellySet();
1168 
1169     /**
1170      * @dev Grants `DEFAULT_ADMIN_ROLE` to the account that deploys the contract 
1171      *      and `OPERATOR_ROLE` to the vault to be able to move those tokens.
1172     */
1173     constructor(string memory _name, string memory _symbol, address _vault, uint256 _initialSupply, uint256 _cap) ERC20(_name,_symbol) {
1174         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1175         _setupRole(OPERATOR_ROLE, _vault);
1176         require(_cap >= _initialSupply, "Cap exceeded");
1177         cap = _cap;
1178         _mint(_vault, _initialSupply);
1179         _pause();
1180     }
1181 
1182     /**
1183      * @dev Serves $JELLY when the time is just right.
1184      */
1185     function setJelly() external {
1186         require(
1187             hasAdminRole(_msgSender()),
1188             "JELLY.setJelly: Sender must be admin"
1189         );
1190         _unpause();
1191         emit JellySet();
1192     }
1193 
1194     /**
1195      * @dev Sets the hard cap on token supply. 
1196      */
1197     function setCap(uint _cap) external  {
1198         require(
1199             hasAdminRole(_msgSender()),
1200             "JELLY.setCap: Sender must be admin"
1201         );
1202         require( _cap >= totalSupply(), "JELLY: Cap less than totalSupply");
1203         cap = _cap;
1204         emit CapUpdated(cap);
1205     }
1206 
1207     /**
1208      * @dev Checks if Jelly is ready yet. 
1209      */
1210     function canTransfer(
1211         address _from
1212     ) external view returns (bool _status) {
1213         return (!paused() || hasOperatorRole(_msgSender()));
1214     }
1215 
1216     /**
1217      * @dev Returns the amount a user is permitted to mint. 
1218      */
1219     function availableToMint() external view returns (uint256 tokens) {
1220         if (hasMinterRole(_msgSender())) {
1221             if (cap > 0) {
1222                 tokens = cap - totalSupply();
1223             } 
1224         } 
1225     }
1226 
1227     /**
1228      * @dev Creates `amount` new tokens for `to`.
1229      */
1230     function mint(address to, uint256 amount) public {
1231         require(to != address(0), "JELLY: no mint to zero address");
1232         require(hasMinterRole(_msgSender()), "JELLY: must have minter role to mint");
1233         require(totalSupply() + amount <= cap, "Cap exceeded");
1234         _mint(to, amount);
1235     }
1236 
1237     /**
1238      * @dev Destroys `amount` tokens from the caller.
1239      */
1240     function burn(uint256 amount) public {
1241         _burn(_msgSender(), amount);
1242     }
1243 
1244     /**
1245      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1246      *      allowance.
1247      */
1248     function burnFrom(address account, uint256 amount) public {
1249         uint256 currentAllowance = allowance(account, _msgSender());
1250         require(currentAllowance >= amount, "JELLY: burn amount exceeds allowance");
1251         unchecked {
1252             _approve(account, _msgSender(), currentAllowance - amount);
1253         }
1254         _burn(account, amount);
1255     }
1256 
1257     /**
1258      * @dev Requires hasOperatorRole for token transfers before Jelly has been set. 
1259      */
1260     function _beforeTokenTransfer(
1261         address from,
1262         address to,
1263         uint256 amount
1264     ) internal override {
1265         if (paused()) {
1266             require(hasOperatorRole(_msgSender()), "JELLY: tokens cannot be transferred until setJelly has been executed");
1267         }
1268     }
1269 }