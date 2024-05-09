1 // File: src/contracts/interfaces/ITransferRules.sol
2 
3 
4 
5 pragma solidity 0.8.11;
6 
7 interface ITransferRules {
8     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
9     /// @param from Sending address
10     /// @param to Receiving address
11     /// @param value Amount of tokens being transferred
12     /// @return Code by which to reference message for rejection reasoning
13     function detectTransferRestriction(
14         address token,
15         address from,
16         address to,
17         uint256 value
18     ) external view returns (uint8);
19 
20     /// @notice Returns a human-readable message for a given restriction code
21     /// @param restrictionCode Identifier for looking up a message
22     /// @return Text showing the restriction's reasoning
23     function messageForTransferRestriction(uint8 restrictionCode)
24         external
25         view
26         returns (string memory);
27 
28     function checkSuccess(uint8 restrictionCode) external view returns (bool);
29 
30 }
31 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
60 
61 
62 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 
67 /**
68  * @dev Implementation of the {IERC165} interface.
69  *
70  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
71  * for the additional interface id that will be supported. For example:
72  *
73  * ```solidity
74  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
75  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
76  * }
77  * ```
78  *
79  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
80  */
81 abstract contract ERC165 is IERC165 {
82     /**
83      * @dev See {IERC165-supportsInterface}.
84      */
85     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
86         return interfaceId == type(IERC165).interfaceId;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/utils/Strings.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev String operations.
99  */
100 library Strings {
101     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
105      */
106     function toString(uint256 value) internal pure returns (string memory) {
107         // Inspired by OraclizeAPI's implementation - MIT licence
108         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
109 
110         if (value == 0) {
111             return "0";
112         }
113         uint256 temp = value;
114         uint256 digits;
115         while (temp != 0) {
116             digits++;
117             temp /= 10;
118         }
119         bytes memory buffer = new bytes(digits);
120         while (value != 0) {
121             digits -= 1;
122             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
123             value /= 10;
124         }
125         return string(buffer);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
130      */
131     function toHexString(uint256 value) internal pure returns (string memory) {
132         if (value == 0) {
133             return "0x00";
134         }
135         uint256 temp = value;
136         uint256 length = 0;
137         while (temp != 0) {
138             length++;
139             temp >>= 8;
140         }
141         return toHexString(value, length);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
146      */
147     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
148         bytes memory buffer = new bytes(2 * length + 2);
149         buffer[0] = "0";
150         buffer[1] = "x";
151         for (uint256 i = 2 * length + 1; i > 1; --i) {
152             buffer[i] = _HEX_SYMBOLS[value & 0xf];
153             value >>= 4;
154         }
155         require(value == 0, "Strings: hex length insufficient");
156         return string(buffer);
157     }
158 }
159 
160 // File: @openzeppelin/contracts/access/IAccessControl.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev External interface of AccessControl declared to support ERC165 detection.
169  */
170 interface IAccessControl {
171     /**
172      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
173      *
174      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
175      * {RoleAdminChanged} not being emitted signaling this.
176      *
177      * _Available since v3.1._
178      */
179     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
180 
181     /**
182      * @dev Emitted when `account` is granted `role`.
183      *
184      * `sender` is the account that originated the contract call, an admin role
185      * bearer except when using {AccessControl-_setupRole}.
186      */
187     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
188 
189     /**
190      * @dev Emitted when `account` is revoked `role`.
191      *
192      * `sender` is the account that originated the contract call:
193      *   - if using `revokeRole`, it is the admin role bearer
194      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
195      */
196     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
197 
198     /**
199      * @dev Returns `true` if `account` has been granted `role`.
200      */
201     function hasRole(bytes32 role, address account) external view returns (bool);
202 
203     /**
204      * @dev Returns the admin role that controls `role`. See {grantRole} and
205      * {revokeRole}.
206      *
207      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
208      */
209     function getRoleAdmin(bytes32 role) external view returns (bytes32);
210 
211     /**
212      * @dev Grants `role` to `account`.
213      *
214      * If `account` had not been already granted `role`, emits a {RoleGranted}
215      * event.
216      *
217      * Requirements:
218      *
219      * - the caller must have ``role``'s admin role.
220      */
221     function grantRole(bytes32 role, address account) external;
222 
223     /**
224      * @dev Revokes `role` from `account`.
225      *
226      * If `account` had been granted `role`, emits a {RoleRevoked} event.
227      *
228      * Requirements:
229      *
230      * - the caller must have ``role``'s admin role.
231      */
232     function revokeRole(bytes32 role, address account) external;
233 
234     /**
235      * @dev Revokes `role` from the calling account.
236      *
237      * Roles are often managed via {grantRole} and {revokeRole}: this function's
238      * purpose is to provide a mechanism for accounts to lose their privileges
239      * if they are compromised (such as when a trusted device is misplaced).
240      *
241      * If the calling account had been granted `role`, emits a {RoleRevoked}
242      * event.
243      *
244      * Requirements:
245      *
246      * - the caller must be `account`.
247      */
248     function renounceRole(bytes32 role, address account) external;
249 }
250 
251 // File: @openzeppelin/contracts/utils/Context.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Provides information about the current execution context, including the
260  * sender of the transaction and its data. While these are generally available
261  * via msg.sender and msg.data, they should not be accessed in such a direct
262  * manner, since when dealing with meta-transactions the account sending and
263  * paying for execution may not be the actual sender (as far as an application
264  * is concerned).
265  *
266  * This contract is only required for intermediate, library-like contracts.
267  */
268 abstract contract Context {
269     function _msgSender() internal view virtual returns (address) {
270         return msg.sender;
271     }
272 
273     function _msgData() internal view virtual returns (bytes calldata) {
274         return msg.data;
275     }
276 }
277 
278 // File: @openzeppelin/contracts/security/Pausable.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 
286 /**
287  * @dev Contract module which allows children to implement an emergency stop
288  * mechanism that can be triggered by an authorized account.
289  *
290  * This module is used through inheritance. It will make available the
291  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
292  * the functions of your contract. Note that they will not be pausable by
293  * simply including this module, only once the modifiers are put in place.
294  */
295 abstract contract Pausable is Context {
296     /**
297      * @dev Emitted when the pause is triggered by `account`.
298      */
299     event Paused(address account);
300 
301     /**
302      * @dev Emitted when the pause is lifted by `account`.
303      */
304     event Unpaused(address account);
305 
306     bool private _paused;
307 
308     /**
309      * @dev Initializes the contract in unpaused state.
310      */
311     constructor() {
312         _paused = false;
313     }
314 
315     /**
316      * @dev Returns true if the contract is paused, and false otherwise.
317      */
318     function paused() public view virtual returns (bool) {
319         return _paused;
320     }
321 
322     /**
323      * @dev Modifier to make a function callable only when the contract is not paused.
324      *
325      * Requirements:
326      *
327      * - The contract must not be paused.
328      */
329     modifier whenNotPaused() {
330         require(!paused(), "Pausable: paused");
331         _;
332     }
333 
334     /**
335      * @dev Modifier to make a function callable only when the contract is paused.
336      *
337      * Requirements:
338      *
339      * - The contract must be paused.
340      */
341     modifier whenPaused() {
342         require(paused(), "Pausable: not paused");
343         _;
344     }
345 
346     /**
347      * @dev Triggers stopped state.
348      *
349      * Requirements:
350      *
351      * - The contract must not be paused.
352      */
353     function _pause() internal virtual whenNotPaused {
354         _paused = true;
355         emit Paused(_msgSender());
356     }
357 
358     /**
359      * @dev Returns to normal state.
360      *
361      * Requirements:
362      *
363      * - The contract must be paused.
364      */
365     function _unpause() internal virtual whenPaused {
366         _paused = false;
367         emit Unpaused(_msgSender());
368     }
369 }
370 
371 // File: @openzeppelin/contracts/access/AccessControl.sol
372 
373 
374 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 
380 
381 
382 /**
383  * @dev Contract module that allows children to implement role-based access
384  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
385  * members except through off-chain means by accessing the contract event logs. Some
386  * applications may benefit from on-chain enumerability, for those cases see
387  * {AccessControlEnumerable}.
388  *
389  * Roles are referred to by their `bytes32` identifier. These should be exposed
390  * in the external API and be unique. The best way to achieve this is by
391  * using `public constant` hash digests:
392  *
393  * ```
394  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
395  * ```
396  *
397  * Roles can be used to represent a set of permissions. To restrict access to a
398  * function call, use {hasRole}:
399  *
400  * ```
401  * function foo() public {
402  *     require(hasRole(MY_ROLE, msg.sender));
403  *     ...
404  * }
405  * ```
406  *
407  * Roles can be granted and revoked dynamically via the {grantRole} and
408  * {revokeRole} functions. Each role has an associated admin role, and only
409  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
410  *
411  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
412  * that only accounts with this role will be able to grant or revoke other
413  * roles. More complex role relationships can be created by using
414  * {_setRoleAdmin}.
415  *
416  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
417  * grant and revoke this role. Extra precautions should be taken to secure
418  * accounts that have been granted it.
419  */
420 abstract contract AccessControl is Context, IAccessControl, ERC165 {
421     struct RoleData {
422         mapping(address => bool) members;
423         bytes32 adminRole;
424     }
425 
426     mapping(bytes32 => RoleData) private _roles;
427 
428     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
429 
430     /**
431      * @dev Modifier that checks that an account has a specific role. Reverts
432      * with a standardized message including the required role.
433      *
434      * The format of the revert reason is given by the following regular expression:
435      *
436      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
437      *
438      * _Available since v4.1._
439      */
440     modifier onlyRole(bytes32 role) {
441         _checkRole(role, _msgSender());
442         _;
443     }
444 
445     /**
446      * @dev See {IERC165-supportsInterface}.
447      */
448     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
450     }
451 
452     /**
453      * @dev Returns `true` if `account` has been granted `role`.
454      */
455     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
456         return _roles[role].members[account];
457     }
458 
459     /**
460      * @dev Revert with a standard message if `account` is missing `role`.
461      *
462      * The format of the revert reason is given by the following regular expression:
463      *
464      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
465      */
466     function _checkRole(bytes32 role, address account) internal view virtual {
467         if (!hasRole(role, account)) {
468             revert(
469                 string(
470                     abi.encodePacked(
471                         "AccessControl: account ",
472                         Strings.toHexString(uint160(account), 20),
473                         " is missing role ",
474                         Strings.toHexString(uint256(role), 32)
475                     )
476                 )
477             );
478         }
479     }
480 
481     /**
482      * @dev Returns the admin role that controls `role`. See {grantRole} and
483      * {revokeRole}.
484      *
485      * To change a role's admin, use {_setRoleAdmin}.
486      */
487     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
488         return _roles[role].adminRole;
489     }
490 
491     /**
492      * @dev Grants `role` to `account`.
493      *
494      * If `account` had not been already granted `role`, emits a {RoleGranted}
495      * event.
496      *
497      * Requirements:
498      *
499      * - the caller must have ``role``'s admin role.
500      */
501     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
502         _grantRole(role, account);
503     }
504 
505     /**
506      * @dev Revokes `role` from `account`.
507      *
508      * If `account` had been granted `role`, emits a {RoleRevoked} event.
509      *
510      * Requirements:
511      *
512      * - the caller must have ``role``'s admin role.
513      */
514     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
515         _revokeRole(role, account);
516     }
517 
518     /**
519      * @dev Revokes `role` from the calling account.
520      *
521      * Roles are often managed via {grantRole} and {revokeRole}: this function's
522      * purpose is to provide a mechanism for accounts to lose their privileges
523      * if they are compromised (such as when a trusted device is misplaced).
524      *
525      * If the calling account had been revoked `role`, emits a {RoleRevoked}
526      * event.
527      *
528      * Requirements:
529      *
530      * - the caller must be `account`.
531      */
532     function renounceRole(bytes32 role, address account) public virtual override {
533         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
534 
535         _revokeRole(role, account);
536     }
537 
538     /**
539      * @dev Grants `role` to `account`.
540      *
541      * If `account` had not been already granted `role`, emits a {RoleGranted}
542      * event. Note that unlike {grantRole}, this function doesn't perform any
543      * checks on the calling account.
544      *
545      * [WARNING]
546      * ====
547      * This function should only be called from the constructor when setting
548      * up the initial roles for the system.
549      *
550      * Using this function in any other way is effectively circumventing the admin
551      * system imposed by {AccessControl}.
552      * ====
553      *
554      * NOTE: This function is deprecated in favor of {_grantRole}.
555      */
556     function _setupRole(bytes32 role, address account) internal virtual {
557         _grantRole(role, account);
558     }
559 
560     /**
561      * @dev Sets `adminRole` as ``role``'s admin role.
562      *
563      * Emits a {RoleAdminChanged} event.
564      */
565     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
566         bytes32 previousAdminRole = getRoleAdmin(role);
567         _roles[role].adminRole = adminRole;
568         emit RoleAdminChanged(role, previousAdminRole, adminRole);
569     }
570 
571     /**
572      * @dev Grants `role` to `account`.
573      *
574      * Internal function without access restriction.
575      */
576     function _grantRole(bytes32 role, address account) internal virtual {
577         if (!hasRole(role, account)) {
578             _roles[role].members[account] = true;
579             emit RoleGranted(role, account, _msgSender());
580         }
581     }
582 
583     /**
584      * @dev Revokes `role` from `account`.
585      *
586      * Internal function without access restriction.
587      */
588     function _revokeRole(bytes32 role, address account) internal virtual {
589         if (hasRole(role, account)) {
590             _roles[role].members[account] = false;
591             emit RoleRevoked(role, account, _msgSender());
592         }
593     }
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
597 
598 
599 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev Interface of the ERC20 standard as defined in the EIP.
605  */
606 interface IERC20 {
607     /**
608      * @dev Returns the amount of tokens in existence.
609      */
610     function totalSupply() external view returns (uint256);
611 
612     /**
613      * @dev Returns the amount of tokens owned by `account`.
614      */
615     function balanceOf(address account) external view returns (uint256);
616 
617     /**
618      * @dev Moves `amount` tokens from the caller's account to `to`.
619      *
620      * Returns a boolean value indicating whether the operation succeeded.
621      *
622      * Emits a {Transfer} event.
623      */
624     function transfer(address to, uint256 amount) external returns (bool);
625 
626     /**
627      * @dev Returns the remaining number of tokens that `spender` will be
628      * allowed to spend on behalf of `owner` through {transferFrom}. This is
629      * zero by default.
630      *
631      * This value changes when {approve} or {transferFrom} are called.
632      */
633     function allowance(address owner, address spender) external view returns (uint256);
634 
635     /**
636      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
637      *
638      * Returns a boolean value indicating whether the operation succeeded.
639      *
640      * IMPORTANT: Beware that changing an allowance with this method brings the risk
641      * that someone may use both the old and the new allowance by unfortunate
642      * transaction ordering. One possible solution to mitigate this race
643      * condition is to first reduce the spender's allowance to 0 and set the
644      * desired value afterwards:
645      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
646      *
647      * Emits an {Approval} event.
648      */
649     function approve(address spender, uint256 amount) external returns (bool);
650 
651     /**
652      * @dev Moves `amount` tokens from `from` to `to` using the
653      * allowance mechanism. `amount` is then deducted from the caller's
654      * allowance.
655      *
656      * Returns a boolean value indicating whether the operation succeeded.
657      *
658      * Emits a {Transfer} event.
659      */
660     function transferFrom(
661         address from,
662         address to,
663         uint256 amount
664     ) external returns (bool);
665 
666     /**
667      * @dev Emitted when `value` tokens are moved from one account (`from`) to
668      * another (`to`).
669      *
670      * Note that `value` may be zero.
671      */
672     event Transfer(address indexed from, address indexed to, uint256 value);
673 
674     /**
675      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
676      * a call to {approve}. `value` is the new allowance.
677      */
678     event Approval(address indexed owner, address indexed spender, uint256 value);
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @dev Interface for the optional metadata functions from the ERC20 standard.
691  *
692  * _Available since v4.1._
693  */
694 interface IERC20Metadata is IERC20 {
695     /**
696      * @dev Returns the name of the token.
697      */
698     function name() external view returns (string memory);
699 
700     /**
701      * @dev Returns the symbol of the token.
702      */
703     function symbol() external view returns (string memory);
704 
705     /**
706      * @dev Returns the decimals places of the token.
707      */
708     function decimals() external view returns (uint8);
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
712 
713 
714 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 
720 
721 /**
722  * @dev Implementation of the {IERC20} interface.
723  *
724  * This implementation is agnostic to the way tokens are created. This means
725  * that a supply mechanism has to be added in a derived contract using {_mint}.
726  * For a generic mechanism see {ERC20PresetMinterPauser}.
727  *
728  * TIP: For a detailed writeup see our guide
729  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
730  * to implement supply mechanisms].
731  *
732  * We have followed general OpenZeppelin Contracts guidelines: functions revert
733  * instead returning `false` on failure. This behavior is nonetheless
734  * conventional and does not conflict with the expectations of ERC20
735  * applications.
736  *
737  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
738  * This allows applications to reconstruct the allowance for all accounts just
739  * by listening to said events. Other implementations of the EIP may not emit
740  * these events, as it isn't required by the specification.
741  *
742  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
743  * functions have been added to mitigate the well-known issues around setting
744  * allowances. See {IERC20-approve}.
745  */
746 contract ERC20 is Context, IERC20, IERC20Metadata {
747     mapping(address => uint256) private _balances;
748 
749     mapping(address => mapping(address => uint256)) private _allowances;
750 
751     uint256 private _totalSupply;
752 
753     string private _name;
754     string private _symbol;
755 
756     /**
757      * @dev Sets the values for {name} and {symbol}.
758      *
759      * The default value of {decimals} is 18. To select a different value for
760      * {decimals} you should overload it.
761      *
762      * All two of these values are immutable: they can only be set once during
763      * construction.
764      */
765     constructor(string memory name_, string memory symbol_) {
766         _name = name_;
767         _symbol = symbol_;
768     }
769 
770     /**
771      * @dev Returns the name of the token.
772      */
773     function name() public view virtual override returns (string memory) {
774         return _name;
775     }
776 
777     /**
778      * @dev Returns the symbol of the token, usually a shorter version of the
779      * name.
780      */
781     function symbol() public view virtual override returns (string memory) {
782         return _symbol;
783     }
784 
785     /**
786      * @dev Returns the number of decimals used to get its user representation.
787      * For example, if `decimals` equals `2`, a balance of `505` tokens should
788      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
789      *
790      * Tokens usually opt for a value of 18, imitating the relationship between
791      * Ether and Wei. This is the value {ERC20} uses, unless this function is
792      * overridden;
793      *
794      * NOTE: This information is only used for _display_ purposes: it in
795      * no way affects any of the arithmetic of the contract, including
796      * {IERC20-balanceOf} and {IERC20-transfer}.
797      */
798     function decimals() public view virtual override returns (uint8) {
799         return 18;
800     }
801 
802     /**
803      * @dev See {IERC20-totalSupply}.
804      */
805     function totalSupply() public view virtual override returns (uint256) {
806         return _totalSupply;
807     }
808 
809     /**
810      * @dev See {IERC20-balanceOf}.
811      */
812     function balanceOf(address account) public view virtual override returns (uint256) {
813         return _balances[account];
814     }
815 
816     /**
817      * @dev See {IERC20-transfer}.
818      *
819      * Requirements:
820      *
821      * - `to` cannot be the zero address.
822      * - the caller must have a balance of at least `amount`.
823      */
824     function transfer(address to, uint256 amount) public virtual override returns (bool) {
825         address owner = _msgSender();
826         _transfer(owner, to, amount);
827         return true;
828     }
829 
830     /**
831      * @dev See {IERC20-allowance}.
832      */
833     function allowance(address owner, address spender) public view virtual override returns (uint256) {
834         return _allowances[owner][spender];
835     }
836 
837     /**
838      * @dev See {IERC20-approve}.
839      *
840      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
841      * `transferFrom`. This is semantically equivalent to an infinite approval.
842      *
843      * Requirements:
844      *
845      * - `spender` cannot be the zero address.
846      */
847     function approve(address spender, uint256 amount) public virtual override returns (bool) {
848         address owner = _msgSender();
849         _approve(owner, spender, amount);
850         return true;
851     }
852 
853     /**
854      * @dev See {IERC20-transferFrom}.
855      *
856      * Emits an {Approval} event indicating the updated allowance. This is not
857      * required by the EIP. See the note at the beginning of {ERC20}.
858      *
859      * NOTE: Does not update the allowance if the current allowance
860      * is the maximum `uint256`.
861      *
862      * Requirements:
863      *
864      * - `from` and `to` cannot be the zero address.
865      * - `from` must have a balance of at least `amount`.
866      * - the caller must have allowance for ``from``'s tokens of at least
867      * `amount`.
868      */
869     function transferFrom(
870         address from,
871         address to,
872         uint256 amount
873     ) public virtual override returns (bool) {
874         address spender = _msgSender();
875         _spendAllowance(from, spender, amount);
876         _transfer(from, to, amount);
877         return true;
878     }
879 
880     /**
881      * @dev Atomically increases the allowance granted to `spender` by the caller.
882      *
883      * This is an alternative to {approve} that can be used as a mitigation for
884      * problems described in {IERC20-approve}.
885      *
886      * Emits an {Approval} event indicating the updated allowance.
887      *
888      * Requirements:
889      *
890      * - `spender` cannot be the zero address.
891      */
892     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
893         address owner = _msgSender();
894         _approve(owner, spender, _allowances[owner][spender] + addedValue);
895         return true;
896     }
897 
898     /**
899      * @dev Atomically decreases the allowance granted to `spender` by the caller.
900      *
901      * This is an alternative to {approve} that can be used as a mitigation for
902      * problems described in {IERC20-approve}.
903      *
904      * Emits an {Approval} event indicating the updated allowance.
905      *
906      * Requirements:
907      *
908      * - `spender` cannot be the zero address.
909      * - `spender` must have allowance for the caller of at least
910      * `subtractedValue`.
911      */
912     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
913         address owner = _msgSender();
914         uint256 currentAllowance = _allowances[owner][spender];
915         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
916         unchecked {
917             _approve(owner, spender, currentAllowance - subtractedValue);
918         }
919 
920         return true;
921     }
922 
923     /**
924      * @dev Moves `amount` of tokens from `sender` to `recipient`.
925      *
926      * This internal function is equivalent to {transfer}, and can be used to
927      * e.g. implement automatic token fees, slashing mechanisms, etc.
928      *
929      * Emits a {Transfer} event.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `from` must have a balance of at least `amount`.
936      */
937     function _transfer(
938         address from,
939         address to,
940         uint256 amount
941     ) internal virtual {
942         require(from != address(0), "ERC20: transfer from the zero address");
943         require(to != address(0), "ERC20: transfer to the zero address");
944 
945         _beforeTokenTransfer(from, to, amount);
946 
947         uint256 fromBalance = _balances[from];
948         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
949         unchecked {
950             _balances[from] = fromBalance - amount;
951         }
952         _balances[to] += amount;
953 
954         emit Transfer(from, to, amount);
955 
956         _afterTokenTransfer(from, to, amount);
957     }
958 
959     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
960      * the total supply.
961      *
962      * Emits a {Transfer} event with `from` set to the zero address.
963      *
964      * Requirements:
965      *
966      * - `account` cannot be the zero address.
967      */
968     function _mint(address account, uint256 amount) internal virtual {
969         require(account != address(0), "ERC20: mint to the zero address");
970 
971         _beforeTokenTransfer(address(0), account, amount);
972 
973         _totalSupply += amount;
974         _balances[account] += amount;
975         emit Transfer(address(0), account, amount);
976 
977         _afterTokenTransfer(address(0), account, amount);
978     }
979 
980     /**
981      * @dev Destroys `amount` tokens from `account`, reducing the
982      * total supply.
983      *
984      * Emits a {Transfer} event with `to` set to the zero address.
985      *
986      * Requirements:
987      *
988      * - `account` cannot be the zero address.
989      * - `account` must have at least `amount` tokens.
990      */
991     function _burn(address account, uint256 amount) internal virtual {
992         require(account != address(0), "ERC20: burn from the zero address");
993 
994         _beforeTokenTransfer(account, address(0), amount);
995 
996         uint256 accountBalance = _balances[account];
997         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
998         unchecked {
999             _balances[account] = accountBalance - amount;
1000         }
1001         _totalSupply -= amount;
1002 
1003         emit Transfer(account, address(0), amount);
1004 
1005         _afterTokenTransfer(account, address(0), amount);
1006     }
1007 
1008     /**
1009      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1010      *
1011      * This internal function is equivalent to `approve`, and can be used to
1012      * e.g. set automatic allowances for certain subsystems, etc.
1013      *
1014      * Emits an {Approval} event.
1015      *
1016      * Requirements:
1017      *
1018      * - `owner` cannot be the zero address.
1019      * - `spender` cannot be the zero address.
1020      */
1021     function _approve(
1022         address owner,
1023         address spender,
1024         uint256 amount
1025     ) internal virtual {
1026         require(owner != address(0), "ERC20: approve from the zero address");
1027         require(spender != address(0), "ERC20: approve to the zero address");
1028 
1029         _allowances[owner][spender] = amount;
1030         emit Approval(owner, spender, amount);
1031     }
1032 
1033     /**
1034      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1035      *
1036      * Does not update the allowance amount in case of infinite allowance.
1037      * Revert if not enough allowance is available.
1038      *
1039      * Might emit an {Approval} event.
1040      */
1041     function _spendAllowance(
1042         address owner,
1043         address spender,
1044         uint256 amount
1045     ) internal virtual {
1046         uint256 currentAllowance = allowance(owner, spender);
1047         if (currentAllowance != type(uint256).max) {
1048             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1049             unchecked {
1050                 _approve(owner, spender, currentAllowance - amount);
1051             }
1052         }
1053     }
1054 
1055     /**
1056      * @dev Hook that is called before any transfer of tokens. This includes
1057      * minting and burning.
1058      *
1059      * Calling conditions:
1060      *
1061      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1062      * will be transferred to `to`.
1063      * - when `from` is zero, `amount` tokens will be minted for `to`.
1064      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1065      * - `from` and `to` are never both zero.
1066      *
1067      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1068      */
1069     function _beforeTokenTransfer(
1070         address from,
1071         address to,
1072         uint256 amount
1073     ) internal virtual {}
1074 
1075     /**
1076      * @dev Hook that is called after any transfer of tokens. This includes
1077      * minting and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1082      * has been transferred to `to`.
1083      * - when `from` is zero, `amount` tokens have been minted for `to`.
1084      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1085      * - `from` and `to` are never both zero.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _afterTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 amount
1093     ) internal virtual {}
1094 }
1095 
1096 // File: src/contracts/RORAPrime.sol
1097 
1098 
1099 
1100 pragma solidity 0.8.11;
1101 
1102 
1103 
1104 
1105 
1106 /// @title RoRa Prime (RORAP)
1107 /// @author RoRa Holdings Corporation
1108 /// @notice ERC-20 token with Access Control and ERC-1404 transfer restrictions.
1109 /// Portions inspired by CoMakery Security Token
1110 
1111 contract RORAPrime is ERC20, Pausable, AccessControl {
1112 
1113     ITransferRules public transferRules;
1114 
1115     bytes32 public constant CONTRACT_ADMIN_ROLE = keccak256("CONTRACT_ADMIN_ROLE");
1116     bytes32 public constant PERMISSIONS_ADMIN_ROLE = keccak256("PERMISSIONS_ADMIN_ROLE");
1117     bytes32 public constant MINT_ADMIN_ROLE = keccak256("MINT_ADMIN_ROLE");
1118 
1119     mapping(address => uint256) private _permissions;
1120     mapping(address => uint256) private _timeLock;
1121 
1122     event UpgradeRules(address indexed admin, address oldRules, address newRules);
1123     event PermissionChange(address indexed admin, address indexed account, uint256 permission);
1124     event AddressTimeLock(address indexed admin, address indexed account, uint256 value);
1125 
1126     constructor (string memory name_,
1127         string memory symbol_, 
1128         uint256 totalSupply_, 
1129         address mintAdmin_,
1130         address contractAdmin_, 
1131         address reserveAddress_,
1132         address transferRules_
1133         ) ERC20(name_, symbol_) {
1134         require(contractAdmin_ != address(0), "CONTRACT ADMIN ADDRESS CANNOT BE 0x0");
1135         require(mintAdmin_ != address(0), "MINT ADMIN ADDRESS CANNOT BE 0x0");
1136         require(reserveAddress_ != address(0), "RESERVE ADDRESS CANNOT BE 0x0");
1137         require(transferRules_ != address(0), "TRANSFER RULES ADDRESS CANNOT BE 0x0");
1138         require(mintAdmin_ != contractAdmin_, "CONTRACT AND MINT ADMINS MUST BE DIFFERENT");
1139 
1140         transferRules = ITransferRules(transferRules_);
1141 
1142         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1143         _grantRole(MINT_ADMIN_ROLE, mintAdmin_);
1144         _grantRole(CONTRACT_ADMIN_ROLE, contractAdmin_);
1145         _grantRole(PERMISSIONS_ADMIN_ROLE, contractAdmin_);
1146    
1147         _setRoleAdmin(PERMISSIONS_ADMIN_ROLE, CONTRACT_ADMIN_ROLE);
1148 
1149         _mint(reserveAddress_, totalSupply_ );
1150     }
1151 
1152     function pause() external onlyRole(CONTRACT_ADMIN_ROLE) {
1153         _pause();
1154     }
1155 
1156     function unpause() external onlyRole(CONTRACT_ADMIN_ROLE) {
1157         _unpause();
1158     }
1159 
1160     function mint(address to, uint256 amount) external whenNotPaused onlyRole(MINT_ADMIN_ROLE) {
1161         _mint(to, amount);
1162     }
1163 
1164     // Ability to burn address by board decision only for regulatory requirements
1165     // Can only be called by the Mint Admin role
1166     function burn(address from, uint256 amount) external whenNotPaused onlyRole(MINT_ADMIN_ROLE) {
1167         _burn(from, amount);
1168     }
1169 
1170     function transfer(address to, uint256 amount) public override whenNotPaused returns (bool) {
1171         enforceTransferRestrictions(msg.sender, to, amount);
1172         super.transfer(to, amount);
1173         return true;
1174     }
1175 
1176     function transferFrom(address from, address to, uint256 amount) public override whenNotPaused returns (bool) {
1177         enforceTransferRestrictions(from, to, amount);
1178         super.transferFrom(from, to, amount);
1179         return true;
1180     }
1181 
1182     // Sets the transfer permission bits for a participant
1183     function setPermission(address account, uint256 permission) onlyRole(PERMISSIONS_ADMIN_ROLE)  external {
1184         require(account != address(0), "ADDRESS CAN NOT BE 0x0");
1185         _permissions[account] = permission;
1186         emit PermissionChange(msg.sender, account, permission);
1187     }
1188 
1189     function getPermission(address account) external view returns (uint256) {
1190         return _permissions[account];
1191     }
1192 
1193     // Unix timestamp is the number of seconds since the Unix epoch of 00:00:00 UTC on 1 January 1970.
1194     function setTimeLock(address account, uint256 timestamp) external onlyRole(PERMISSIONS_ADMIN_ROLE) {
1195         require(account != address(0), "ADDRESS CAN NOT BE 0x0");
1196         _timeLock[account] = timestamp;
1197         emit AddressTimeLock(msg.sender, account, timestamp);
1198     }
1199 
1200     function removeTimeLock(address account) external onlyRole(PERMISSIONS_ADMIN_ROLE) {
1201         require(account != address(0), "ADDRESS CAN NOT BE 0x0");
1202         _timeLock[account] = 0;
1203         emit AddressTimeLock(msg.sender, account, 0);
1204     }
1205 
1206     function getTimeLock(address account) external view returns(uint256 timestamp) {
1207         return _timeLock[account];
1208     }
1209 
1210     function enforceTransferRestrictions(address from, address to, uint256 value) private view {
1211         uint8 restrictionCode = detectTransferRestriction(from, to, value);
1212         require(transferRules.checkSuccess(restrictionCode), messageForTransferRestriction(restrictionCode));
1213     }
1214 
1215     function detectTransferRestriction(address from, address to, uint256 value) public view returns(uint8) {
1216         return transferRules.detectTransferRestriction(address(this), from, to, value);
1217     }
1218 
1219     function messageForTransferRestriction(uint8 restrictionCode) public view returns(string memory) {
1220         return transferRules.messageForTransferRestriction(restrictionCode);
1221     }
1222 
1223     function renounceRole(bytes32 role, address account) public override {
1224         require(role != DEFAULT_ADMIN_ROLE, "CANNOT RENOUNCE DEFAULT ADMIN ROLE");
1225         require(hasRole(role, account), "ADDRESS DOES NOT HAVE ROLE"); 
1226         super.renounceRole(role, account);
1227     }
1228 
1229     function revokeRole(bytes32 role, address account) public override onlyRole(getRoleAdmin(role)) {
1230         require(role != DEFAULT_ADMIN_ROLE, "CANNOT REVOKE DEFAULT ADMIN ROLE");
1231         require(hasRole(role, account), "ADDRESS DOES NOT HAVE ROLE"); 
1232         super.revokeRole(role, account);
1233     }
1234     function grantRole(bytes32 role, address account) public override onlyRole(getRoleAdmin(role)) {
1235         require(!hasRole(role, account), "ADDRESS ALREADY HAS ROLE"); 
1236         super.grantRole(role, account);
1237     }
1238 
1239     function upgradeTransferRules(ITransferRules newTransferRules) external onlyRole(CONTRACT_ADMIN_ROLE) {
1240         require(address(newTransferRules) != address(0x0), "ADDRESS CAN NOT BE 0x0");
1241         address oldRules = address(transferRules);
1242         transferRules = newTransferRules;
1243         emit UpgradeRules(msg.sender, oldRules, address(newTransferRules));
1244     }
1245 }