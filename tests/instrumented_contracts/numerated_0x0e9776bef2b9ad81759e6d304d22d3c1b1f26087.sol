1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
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
29 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Implementation of the {IERC165} interface.
39  *
40  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
41  * for the additional interface id that will be supported. For example:
42  *
43  * ```solidity
44  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
46  * }
47  * ```
48  *
49  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
50  */
51 abstract contract ERC165 is IERC165 {
52     /**
53      * @dev See {IERC165-supportsInterface}.
54      */
55     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
56         return interfaceId == type(IERC165).interfaceId;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/utils/Strings.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev String operations.
69  */
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
75      */
76     function toString(uint256 value) internal pure returns (string memory) {
77         // Inspired by OraclizeAPI's implementation - MIT licence
78         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
79 
80         if (value == 0) {
81             return "0";
82         }
83         uint256 temp = value;
84         uint256 digits;
85         while (temp != 0) {
86             digits++;
87             temp /= 10;
88         }
89         bytes memory buffer = new bytes(digits);
90         while (value != 0) {
91             digits -= 1;
92             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
93             value /= 10;
94         }
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
100      */
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
116      */
117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
118         bytes memory buffer = new bytes(2 * length + 2);
119         buffer[0] = "0";
120         buffer[1] = "x";
121         for (uint256 i = 2 * length + 1; i > 1; --i) {
122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
123             value >>= 4;
124         }
125         require(value == 0, "Strings: hex length insufficient");
126         return string(buffer);
127     }
128 }
129 
130 // File: @openzeppelin/contracts/access/IAccessControl.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev External interface of AccessControl declared to support ERC165 detection.
139  */
140 interface IAccessControl {
141     /**
142      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
143      *
144      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
145      * {RoleAdminChanged} not being emitted signaling this.
146      *
147      * _Available since v3.1._
148      */
149     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
150 
151     /**
152      * @dev Emitted when `account` is granted `role`.
153      *
154      * `sender` is the account that originated the contract call, an admin role
155      * bearer except when using {AccessControl-_setupRole}.
156      */
157     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
158 
159     /**
160      * @dev Emitted when `account` is revoked `role`.
161      *
162      * `sender` is the account that originated the contract call:
163      *   - if using `revokeRole`, it is the admin role bearer
164      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
165      */
166     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
167 
168     /**
169      * @dev Returns `true` if `account` has been granted `role`.
170      */
171     function hasRole(bytes32 role, address account) external view returns (bool);
172 
173     /**
174      * @dev Returns the admin role that controls `role`. See {grantRole} and
175      * {revokeRole}.
176      *
177      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
178      */
179     function getRoleAdmin(bytes32 role) external view returns (bytes32);
180 
181     /**
182      * @dev Grants `role` to `account`.
183      *
184      * If `account` had not been already granted `role`, emits a {RoleGranted}
185      * event.
186      *
187      * Requirements:
188      *
189      * - the caller must have ``role``'s admin role.
190      */
191     function grantRole(bytes32 role, address account) external;
192 
193     /**
194      * @dev Revokes `role` from `account`.
195      *
196      * If `account` had been granted `role`, emits a {RoleRevoked} event.
197      *
198      * Requirements:
199      *
200      * - the caller must have ``role``'s admin role.
201      */
202     function revokeRole(bytes32 role, address account) external;
203 
204     /**
205      * @dev Revokes `role` from the calling account.
206      *
207      * Roles are often managed via {grantRole} and {revokeRole}: this function's
208      * purpose is to provide a mechanism for accounts to lose their privileges
209      * if they are compromised (such as when a trusted device is misplaced).
210      *
211      * If the calling account had been granted `role`, emits a {RoleRevoked}
212      * event.
213      *
214      * Requirements:
215      *
216      * - the caller must be `account`.
217      */
218     function renounceRole(bytes32 role, address account) external;
219 }
220 
221 // File: @openzeppelin/contracts/utils/Counters.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @title Counters
230  * @author Matt Condon (@shrugs)
231  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
232  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
233  *
234  * Include with `using Counters for Counters.Counter;`
235  */
236 library Counters {
237     struct Counter {
238         // This variable should never be directly accessed by users of the library: interactions must be restricted to
239         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
240         // this feature: see https://github.com/ethereum/solidity/issues/4637
241         uint256 _value; // default: 0
242     }
243 
244     function current(Counter storage counter) internal view returns (uint256) {
245         return counter._value;
246     }
247 
248     function increment(Counter storage counter) internal {
249         unchecked {
250             counter._value += 1;
251         }
252     }
253 
254     function decrement(Counter storage counter) internal {
255         uint256 value = counter._value;
256         require(value > 0, "Counter: decrement overflow");
257         unchecked {
258             counter._value = value - 1;
259         }
260     }
261 
262     function reset(Counter storage counter) internal {
263         counter._value = 0;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/utils/math/Math.sol
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev Standard math utilities missing in the Solidity language.
276  */
277 library Math {
278     /**
279      * @dev Returns the largest of two numbers.
280      */
281     function max(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a >= b ? a : b;
283     }
284 
285     /**
286      * @dev Returns the smallest of two numbers.
287      */
288     function min(uint256 a, uint256 b) internal pure returns (uint256) {
289         return a < b ? a : b;
290     }
291 
292     /**
293      * @dev Returns the average of two numbers. The result is rounded towards
294      * zero.
295      */
296     function average(uint256 a, uint256 b) internal pure returns (uint256) {
297         // (a + b) / 2 can overflow.
298         return (a & b) + (a ^ b) / 2;
299     }
300 
301     /**
302      * @dev Returns the ceiling of the division of two numbers.
303      *
304      * This differs from standard division with `/` in that it rounds up instead
305      * of rounding down.
306      */
307     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
308         // (a + b - 1) / b can overflow on addition, so we distribute.
309         return a / b + (a % b == 0 ? 0 : 1);
310     }
311 }
312 
313 // File: @openzeppelin/contracts/utils/Arrays.sol
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 
321 /**
322  * @dev Collection of functions related to array types.
323  */
324 library Arrays {
325     /**
326      * @dev Searches a sorted `array` and returns the first index that contains
327      * a value greater or equal to `element`. If no such index exists (i.e. all
328      * values in the array are strictly less than `element`), the array length is
329      * returned. Time complexity O(log n).
330      *
331      * `array` is expected to be sorted in ascending order, and to contain no
332      * repeated elements.
333      */
334     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
335         if (array.length == 0) {
336             return 0;
337         }
338 
339         uint256 low = 0;
340         uint256 high = array.length;
341 
342         while (low < high) {
343             uint256 mid = Math.average(low, high);
344 
345             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
346             // because Math.average rounds down (it does integer division with truncation).
347             if (array[mid] > element) {
348                 high = mid;
349             } else {
350                 low = mid + 1;
351             }
352         }
353 
354         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
355         if (low > 0 && array[low - 1] == element) {
356             return low - 1;
357         } else {
358             return low;
359         }
360     }
361 }
362 
363 // File: @openzeppelin/contracts/utils/Context.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Provides information about the current execution context, including the
372  * sender of the transaction and its data. While these are generally available
373  * via msg.sender and msg.data, they should not be accessed in such a direct
374  * manner, since when dealing with meta-transactions the account sending and
375  * paying for execution may not be the actual sender (as far as an application
376  * is concerned).
377  *
378  * This contract is only required for intermediate, library-like contracts.
379  */
380 abstract contract Context {
381     function _msgSender() internal view virtual returns (address) {
382         return msg.sender;
383     }
384 
385     function _msgData() internal view virtual returns (bytes calldata) {
386         return msg.data;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/access/AccessControl.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 
399 
400 
401 /**
402  * @dev Contract module that allows children to implement role-based access
403  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
404  * members except through off-chain means by accessing the contract event logs. Some
405  * applications may benefit from on-chain enumerability, for those cases see
406  * {AccessControlEnumerable}.
407  *
408  * Roles are referred to by their `bytes32` identifier. These should be exposed
409  * in the external API and be unique. The best way to achieve this is by
410  * using `public constant` hash digests:
411  *
412  * ```
413  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
414  * ```
415  *
416  * Roles can be used to represent a set of permissions. To restrict access to a
417  * function call, use {hasRole}:
418  *
419  * ```
420  * function foo() public {
421  *     require(hasRole(MY_ROLE, msg.sender));
422  *     ...
423  * }
424  * ```
425  *
426  * Roles can be granted and revoked dynamically via the {grantRole} and
427  * {revokeRole} functions. Each role has an associated admin role, and only
428  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
429  *
430  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
431  * that only accounts with this role will be able to grant or revoke other
432  * roles. More complex role relationships can be created by using
433  * {_setRoleAdmin}.
434  *
435  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
436  * grant and revoke this role. Extra precautions should be taken to secure
437  * accounts that have been granted it.
438  */
439 abstract contract AccessControl is Context, IAccessControl, ERC165 {
440     struct RoleData {
441         mapping(address => bool) members;
442         bytes32 adminRole;
443     }
444 
445     mapping(bytes32 => RoleData) private _roles;
446 
447     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
448 
449     /**
450      * @dev Modifier that checks that an account has a specific role. Reverts
451      * with a standardized message including the required role.
452      *
453      * The format of the revert reason is given by the following regular expression:
454      *
455      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
456      *
457      * _Available since v4.1._
458      */
459     modifier onlyRole(bytes32 role) {
460         _checkRole(role, _msgSender());
461         _;
462     }
463 
464     /**
465      * @dev See {IERC165-supportsInterface}.
466      */
467     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
469     }
470 
471     /**
472      * @dev Returns `true` if `account` has been granted `role`.
473      */
474     function hasRole(bytes32 role, address account) public view override returns (bool) {
475         return _roles[role].members[account];
476     }
477 
478     /**
479      * @dev Revert with a standard message if `account` is missing `role`.
480      *
481      * The format of the revert reason is given by the following regular expression:
482      *
483      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
484      */
485     function _checkRole(bytes32 role, address account) internal view {
486         if (!hasRole(role, account)) {
487             revert(
488                 string(
489                     abi.encodePacked(
490                         "AccessControl: account ",
491                         Strings.toHexString(uint160(account), 20),
492                         " is missing role ",
493                         Strings.toHexString(uint256(role), 32)
494                     )
495                 )
496             );
497         }
498     }
499 
500     /**
501      * @dev Returns the admin role that controls `role`. See {grantRole} and
502      * {revokeRole}.
503      *
504      * To change a role's admin, use {_setRoleAdmin}.
505      */
506     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
507         return _roles[role].adminRole;
508     }
509 
510     /**
511      * @dev Grants `role` to `account`.
512      *
513      * If `account` had not been already granted `role`, emits a {RoleGranted}
514      * event.
515      *
516      * Requirements:
517      *
518      * - the caller must have ``role``'s admin role.
519      */
520     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
521         _grantRole(role, account);
522     }
523 
524     /**
525      * @dev Revokes `role` from `account`.
526      *
527      * If `account` had been granted `role`, emits a {RoleRevoked} event.
528      *
529      * Requirements:
530      *
531      * - the caller must have ``role``'s admin role.
532      */
533     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
534         _revokeRole(role, account);
535     }
536 
537     /**
538      * @dev Revokes `role` from the calling account.
539      *
540      * Roles are often managed via {grantRole} and {revokeRole}: this function's
541      * purpose is to provide a mechanism for accounts to lose their privileges
542      * if they are compromised (such as when a trusted device is misplaced).
543      *
544      * If the calling account had been revoked `role`, emits a {RoleRevoked}
545      * event.
546      *
547      * Requirements:
548      *
549      * - the caller must be `account`.
550      */
551     function renounceRole(bytes32 role, address account) public virtual override {
552         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
553 
554         _revokeRole(role, account);
555     }
556 
557     /**
558      * @dev Grants `role` to `account`.
559      *
560      * If `account` had not been already granted `role`, emits a {RoleGranted}
561      * event. Note that unlike {grantRole}, this function doesn't perform any
562      * checks on the calling account.
563      *
564      * [WARNING]
565      * ====
566      * This function should only be called from the constructor when setting
567      * up the initial roles for the system.
568      *
569      * Using this function in any other way is effectively circumventing the admin
570      * system imposed by {AccessControl}.
571      * ====
572      *
573      * NOTE: This function is deprecated in favor of {_grantRole}.
574      */
575     function _setupRole(bytes32 role, address account) internal virtual {
576         _grantRole(role, account);
577     }
578 
579     /**
580      * @dev Sets `adminRole` as ``role``'s admin role.
581      *
582      * Emits a {RoleAdminChanged} event.
583      */
584     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
585         bytes32 previousAdminRole = getRoleAdmin(role);
586         _roles[role].adminRole = adminRole;
587         emit RoleAdminChanged(role, previousAdminRole, adminRole);
588     }
589 
590     /**
591      * @dev Grants `role` to `account`.
592      *
593      * Internal function without access restriction.
594      */
595     function _grantRole(bytes32 role, address account) internal virtual {
596         if (!hasRole(role, account)) {
597             _roles[role].members[account] = true;
598             emit RoleGranted(role, account, _msgSender());
599         }
600     }
601 
602     /**
603      * @dev Revokes `role` from `account`.
604      *
605      * Internal function without access restriction.
606      */
607     function _revokeRole(bytes32 role, address account) internal virtual {
608         if (hasRole(role, account)) {
609             _roles[role].members[account] = false;
610             emit RoleRevoked(role, account, _msgSender());
611         }
612     }
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Interface of the ERC20 standard as defined in the EIP.
624  */
625 interface IERC20 {
626     /**
627      * @dev Returns the amount of tokens in existence.
628      */
629     function totalSupply() external view returns (uint256);
630 
631     /**
632      * @dev Returns the amount of tokens owned by `account`.
633      */
634     function balanceOf(address account) external view returns (uint256);
635 
636     /**
637      * @dev Moves `amount` tokens from the caller's account to `recipient`.
638      *
639      * Returns a boolean value indicating whether the operation succeeded.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transfer(address recipient, uint256 amount) external returns (bool);
644 
645     /**
646      * @dev Returns the remaining number of tokens that `spender` will be
647      * allowed to spend on behalf of `owner` through {transferFrom}. This is
648      * zero by default.
649      *
650      * This value changes when {approve} or {transferFrom} are called.
651      */
652     function allowance(address owner, address spender) external view returns (uint256);
653 
654     /**
655      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
656      *
657      * Returns a boolean value indicating whether the operation succeeded.
658      *
659      * IMPORTANT: Beware that changing an allowance with this method brings the risk
660      * that someone may use both the old and the new allowance by unfortunate
661      * transaction ordering. One possible solution to mitigate this race
662      * condition is to first reduce the spender's allowance to 0 and set the
663      * desired value afterwards:
664      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
665      *
666      * Emits an {Approval} event.
667      */
668     function approve(address spender, uint256 amount) external returns (bool);
669 
670     /**
671      * @dev Moves `amount` tokens from `sender` to `recipient` using the
672      * allowance mechanism. `amount` is then deducted from the caller's
673      * allowance.
674      *
675      * Returns a boolean value indicating whether the operation succeeded.
676      *
677      * Emits a {Transfer} event.
678      */
679     function transferFrom(
680         address sender,
681         address recipient,
682         uint256 amount
683     ) external returns (bool);
684 
685     /**
686      * @dev Emitted when `value` tokens are moved from one account (`from`) to
687      * another (`to`).
688      *
689      * Note that `value` may be zero.
690      */
691     event Transfer(address indexed from, address indexed to, uint256 value);
692 
693     /**
694      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
695      * a call to {approve}. `value` is the new allowance.
696      */
697     event Approval(address indexed owner, address indexed spender, uint256 value);
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @dev Interface for the optional metadata functions from the ERC20 standard.
710  *
711  * _Available since v4.1._
712  */
713 interface IERC20Metadata is IERC20 {
714     /**
715      * @dev Returns the name of the token.
716      */
717     function name() external view returns (string memory);
718 
719     /**
720      * @dev Returns the symbol of the token.
721      */
722     function symbol() external view returns (string memory);
723 
724     /**
725      * @dev Returns the decimals places of the token.
726      */
727     function decimals() external view returns (uint8);
728 }
729 
730 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 
739 
740 /**
741  * @dev Implementation of the {IERC20} interface.
742  *
743  * This implementation is agnostic to the way tokens are created. This means
744  * that a supply mechanism has to be added in a derived contract using {_mint}.
745  * For a generic mechanism see {ERC20PresetMinterPauser}.
746  *
747  * TIP: For a detailed writeup see our guide
748  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
749  * to implement supply mechanisms].
750  *
751  * We have followed general OpenZeppelin Contracts guidelines: functions revert
752  * instead returning `false` on failure. This behavior is nonetheless
753  * conventional and does not conflict with the expectations of ERC20
754  * applications.
755  *
756  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
757  * This allows applications to reconstruct the allowance for all accounts just
758  * by listening to said events. Other implementations of the EIP may not emit
759  * these events, as it isn't required by the specification.
760  *
761  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
762  * functions have been added to mitigate the well-known issues around setting
763  * allowances. See {IERC20-approve}.
764  */
765 contract ERC20 is Context, IERC20, IERC20Metadata {
766     mapping(address => uint256) private _balances;
767 
768     mapping(address => mapping(address => uint256)) private _allowances;
769 
770     uint256 private _totalSupply;
771 
772     string private _name;
773     string private _symbol;
774 
775     /**
776      * @dev Sets the values for {name} and {symbol}.
777      *
778      * The default value of {decimals} is 18. To select a different value for
779      * {decimals} you should overload it.
780      *
781      * All two of these values are immutable: they can only be set once during
782      * construction.
783      */
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787     }
788 
789     /**
790      * @dev Returns the name of the token.
791      */
792     function name() public view virtual override returns (string memory) {
793         return _name;
794     }
795 
796     /**
797      * @dev Returns the symbol of the token, usually a shorter version of the
798      * name.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev Returns the number of decimals used to get its user representation.
806      * For example, if `decimals` equals `2`, a balance of `505` tokens should
807      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
808      *
809      * Tokens usually opt for a value of 18, imitating the relationship between
810      * Ether and Wei. This is the value {ERC20} uses, unless this function is
811      * overridden;
812      *
813      * NOTE: This information is only used for _display_ purposes: it in
814      * no way affects any of the arithmetic of the contract, including
815      * {IERC20-balanceOf} and {IERC20-transfer}.
816      */
817     function decimals() public view virtual override returns (uint8) {
818         return 18;
819     }
820 
821     /**
822      * @dev See {IERC20-totalSupply}.
823      */
824     function totalSupply() public view virtual override returns (uint256) {
825         return _totalSupply;
826     }
827 
828     /**
829      * @dev See {IERC20-balanceOf}.
830      */
831     function balanceOf(address account) public view virtual override returns (uint256) {
832         return _balances[account];
833     }
834 
835     /**
836      * @dev See {IERC20-transfer}.
837      *
838      * Requirements:
839      *
840      * - `recipient` cannot be the zero address.
841      * - the caller must have a balance of at least `amount`.
842      */
843     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
844         _transfer(_msgSender(), recipient, amount);
845         return true;
846     }
847 
848     /**
849      * @dev See {IERC20-allowance}.
850      */
851     function allowance(address owner, address spender) public view virtual override returns (uint256) {
852         return _allowances[owner][spender];
853     }
854 
855     /**
856      * @dev See {IERC20-approve}.
857      *
858      * Requirements:
859      *
860      * - `spender` cannot be the zero address.
861      */
862     function approve(address spender, uint256 amount) public virtual override returns (bool) {
863         _approve(_msgSender(), spender, amount);
864         return true;
865     }
866 
867     /**
868      * @dev See {IERC20-transferFrom}.
869      *
870      * Emits an {Approval} event indicating the updated allowance. This is not
871      * required by the EIP. See the note at the beginning of {ERC20}.
872      *
873      * Requirements:
874      *
875      * - `sender` and `recipient` cannot be the zero address.
876      * - `sender` must have a balance of at least `amount`.
877      * - the caller must have allowance for ``sender``'s tokens of at least
878      * `amount`.
879      */
880     function transferFrom(
881         address sender,
882         address recipient,
883         uint256 amount
884     ) public virtual override returns (bool) {
885         _transfer(sender, recipient, amount);
886 
887         uint256 currentAllowance = _allowances[sender][_msgSender()];
888         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
889         unchecked {
890             _approve(sender, _msgSender(), currentAllowance - amount);
891         }
892 
893         return true;
894     }
895 
896     /**
897      * @dev Atomically increases the allowance granted to `spender` by the caller.
898      *
899      * This is an alternative to {approve} that can be used as a mitigation for
900      * problems described in {IERC20-approve}.
901      *
902      * Emits an {Approval} event indicating the updated allowance.
903      *
904      * Requirements:
905      *
906      * - `spender` cannot be the zero address.
907      */
908     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
909         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
910         return true;
911     }
912 
913     /**
914      * @dev Atomically decreases the allowance granted to `spender` by the caller.
915      *
916      * This is an alternative to {approve} that can be used as a mitigation for
917      * problems described in {IERC20-approve}.
918      *
919      * Emits an {Approval} event indicating the updated allowance.
920      *
921      * Requirements:
922      *
923      * - `spender` cannot be the zero address.
924      * - `spender` must have allowance for the caller of at least
925      * `subtractedValue`.
926      */
927     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
928         uint256 currentAllowance = _allowances[_msgSender()][spender];
929         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
930         unchecked {
931             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
932         }
933 
934         return true;
935     }
936 
937     /**
938      * @dev Moves `amount` of tokens from `sender` to `recipient`.
939      *
940      * This internal function is equivalent to {transfer}, and can be used to
941      * e.g. implement automatic token fees, slashing mechanisms, etc.
942      *
943      * Emits a {Transfer} event.
944      *
945      * Requirements:
946      *
947      * - `sender` cannot be the zero address.
948      * - `recipient` cannot be the zero address.
949      * - `sender` must have a balance of at least `amount`.
950      */
951     function _transfer(
952         address sender,
953         address recipient,
954         uint256 amount
955     ) internal virtual {
956         require(sender != address(0), "ERC20: transfer from the zero address");
957         require(recipient != address(0), "ERC20: transfer to the zero address");
958 
959         _beforeTokenTransfer(sender, recipient, amount);
960 
961         uint256 senderBalance = _balances[sender];
962         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
963         unchecked {
964             _balances[sender] = senderBalance - amount;
965         }
966         _balances[recipient] += amount;
967 
968         emit Transfer(sender, recipient, amount);
969 
970         _afterTokenTransfer(sender, recipient, amount);
971     }
972 
973     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
974      * the total supply.
975      *
976      * Emits a {Transfer} event with `from` set to the zero address.
977      *
978      * Requirements:
979      *
980      * - `account` cannot be the zero address.
981      */
982     function _mint(address account, uint256 amount) internal virtual {
983         require(account != address(0), "ERC20: mint to the zero address");
984 
985         _beforeTokenTransfer(address(0), account, amount);
986 
987         _totalSupply += amount;
988         _balances[account] += amount;
989         emit Transfer(address(0), account, amount);
990 
991         _afterTokenTransfer(address(0), account, amount);
992     }
993 
994     /**
995      * @dev Destroys `amount` tokens from `account`, reducing the
996      * total supply.
997      *
998      * Emits a {Transfer} event with `to` set to the zero address.
999      *
1000      * Requirements:
1001      *
1002      * - `account` cannot be the zero address.
1003      * - `account` must have at least `amount` tokens.
1004      */
1005     function _burn(address account, uint256 amount) internal virtual {
1006         require(account != address(0), "ERC20: burn from the zero address");
1007 
1008         _beforeTokenTransfer(account, address(0), amount);
1009 
1010         uint256 accountBalance = _balances[account];
1011         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1012         unchecked {
1013             _balances[account] = accountBalance - amount;
1014         }
1015         _totalSupply -= amount;
1016 
1017         emit Transfer(account, address(0), amount);
1018 
1019         _afterTokenTransfer(account, address(0), amount);
1020     }
1021 
1022     /**
1023      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1024      *
1025      * This internal function is equivalent to `approve`, and can be used to
1026      * e.g. set automatic allowances for certain subsystems, etc.
1027      *
1028      * Emits an {Approval} event.
1029      *
1030      * Requirements:
1031      *
1032      * - `owner` cannot be the zero address.
1033      * - `spender` cannot be the zero address.
1034      */
1035     function _approve(
1036         address owner,
1037         address spender,
1038         uint256 amount
1039     ) internal virtual {
1040         require(owner != address(0), "ERC20: approve from the zero address");
1041         require(spender != address(0), "ERC20: approve to the zero address");
1042 
1043         _allowances[owner][spender] = amount;
1044         emit Approval(owner, spender, amount);
1045     }
1046 
1047     /**
1048      * @dev Hook that is called before any transfer of tokens. This includes
1049      * minting and burning.
1050      *
1051      * Calling conditions:
1052      *
1053      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1054      * will be transferred to `to`.
1055      * - when `from` is zero, `amount` tokens will be minted for `to`.
1056      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1057      * - `from` and `to` are never both zero.
1058      *
1059      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1060      */
1061     function _beforeTokenTransfer(
1062         address from,
1063         address to,
1064         uint256 amount
1065     ) internal virtual {}
1066 
1067     /**
1068      * @dev Hook that is called after any transfer of tokens. This includes
1069      * minting and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1074      * has been transferred to `to`.
1075      * - when `from` is zero, `amount` tokens have been minted for `to`.
1076      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1077      * - `from` and `to` are never both zero.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _afterTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 amount
1085     ) internal virtual {}
1086 }
1087 
1088 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol
1089 
1090 
1091 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
1092 
1093 pragma solidity ^0.8.9;
1094 
1095 
1096 
1097 
1098 /**
1099  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1100  * total supply at the time are recorded for later access.
1101  *
1102  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1103  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1104  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1105  * used to create an efficient ERC20 forking mechanism.
1106  *
1107  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1108  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1109  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1110  * and the account address.
1111  *
1112  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1113  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
1114  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1115  *
1116  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1117  * alternative consider {ERC20Votes}.
1118  *
1119  * ==== Gas Costs
1120  *
1121  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1122  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1123  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1124  *
1125  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1126  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1127  * transfers will have normal cost until the next snapshot, and so on.
1128  */
1129 
1130 abstract contract ERC20Snapshot is ERC20 {
1131     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1132     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1133 
1134     using Arrays for uint256[];
1135     using Counters for Counters.Counter;
1136 
1137     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1138     // Snapshot struct, but that would impede usage of functions that work on an array.
1139     struct Snapshots {
1140         uint256[] ids;
1141         uint256[] values;
1142     }
1143 
1144     mapping(address => Snapshots) private _accountBalanceSnapshots;
1145     Snapshots private _totalSupplySnapshots;
1146 
1147     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1148     Counters.Counter private _currentSnapshotId;
1149 
1150     /**
1151      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1152      */
1153     event Snapshot(uint256 id);
1154 
1155     /**
1156      * @dev Creates a new snapshot and returns its snapshot id.
1157      *
1158      * Emits a {Snapshot} event that contains the same id.
1159      *
1160      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1161      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1162      *
1163      * [WARNING]
1164      * ====
1165      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1166      * you must consider that it can potentially be used by attackers in two ways.
1167      *
1168      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1169      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1170      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1171      * section above.
1172      *
1173      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1174      * ====
1175      */
1176     function _snapshot() internal virtual returns (uint256) {
1177         _currentSnapshotId.increment();
1178 
1179         uint256 currentId = _getCurrentSnapshotId();
1180         emit Snapshot(currentId);
1181         return currentId;
1182     }
1183 
1184     /**
1185      * @dev Get the current snapshotId
1186      */
1187     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1188         return _currentSnapshotId.current();
1189     }
1190 
1191     /**
1192      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1193      */
1194     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1195         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1196 
1197         return snapshotted ? value : balanceOf(account);
1198     }
1199 
1200     /**
1201      * @dev Retrieves the total supply at the time `snapshotId` was created.
1202      */
1203     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1204         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1205 
1206         return snapshotted ? value : totalSupply();
1207     }
1208 
1209     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1210     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1211     function _beforeTokenTransfer(
1212         address from,
1213         address to,
1214         uint256 amount
1215     ) internal virtual override {
1216         super._beforeTokenTransfer(from, to, amount);
1217 
1218         if (from == address(0)) {
1219             // mint
1220             _updateAccountSnapshot(to);
1221             _updateTotalSupplySnapshot();
1222         } else if (to == address(0)) {
1223             // burn
1224             _updateAccountSnapshot(from);
1225             _updateTotalSupplySnapshot();
1226         } else {
1227             // transfer
1228             _updateAccountSnapshot(from);
1229             _updateAccountSnapshot(to);
1230         }
1231     }
1232 
1233     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1234         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1235         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1236 
1237         // When a valid snapshot is queried, there are three possibilities:
1238         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1239         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1240         //  to this id is the current one.
1241         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1242         //  requested id, and its value is the one to return.
1243         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1244         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1245         //  larger than the requested one.
1246         //
1247         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1248         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1249         // exactly this.
1250 
1251         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1252 
1253         if (index == snapshots.ids.length) {
1254             return (false, 0);
1255         } else {
1256             return (true, snapshots.values[index]);
1257         }
1258     }
1259 
1260     function _updateAccountSnapshot(address account) private {
1261         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1262     }
1263 
1264     function _updateTotalSupplySnapshot() private {
1265         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1266     }
1267 
1268     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1269         uint256 currentId = _getCurrentSnapshotId();
1270         if (_lastSnapshotId(snapshots.ids) < currentId) {
1271             snapshots.ids.push(currentId);
1272             snapshots.values.push(currentValue);
1273         }
1274     }
1275 
1276     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1277         if (ids.length == 0) {
1278             return 0;
1279         } else {
1280             return ids[ids.length - 1];
1281         }
1282     }
1283 }
1284 
1285 // File: contracts/spume.sol
1286 
1287 
1288 pragma solidity ^0.8.9;
1289 
1290 
1291 
1292 contract SPUMEToken is ERC20Snapshot, AccessControl{
1293     // Create snapshot role
1294     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1295 
1296     constructor(uint256 initialSupply) ERC20("Spume", "SPUME"){
1297         _mint(msg.sender, initialSupply);
1298         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1299     }
1300 
1301     function snapshot() public returns (uint256){
1302         require(hasRole(SNAPSHOT_ROLE, msg.sender), "AccessControl: sender must have role SNAPSHOT_ROLE");
1303         return _snapshot();
1304     }
1305 }