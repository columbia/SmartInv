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
270 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
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
393 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
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
474     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
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
485     function _checkRole(bytes32 role, address account) internal view virtual {
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
506     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
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
618 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
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
637      * @dev Moves `amount` tokens from the caller's account to `to`.
638      *
639      * Returns a boolean value indicating whether the operation succeeded.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transfer(address to, uint256 amount) external returns (bool);
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
671      * @dev Moves `amount` tokens from `from` to `to` using the
672      * allowance mechanism. `amount` is then deducted from the caller's
673      * allowance.
674      *
675      * Returns a boolean value indicating whether the operation succeeded.
676      *
677      * Emits a {Transfer} event.
678      */
679     function transferFrom(
680         address from,
681         address to,
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
733 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
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
840      * - `to` cannot be the zero address.
841      * - the caller must have a balance of at least `amount`.
842      */
843     function transfer(address to, uint256 amount) public virtual override returns (bool) {
844         address owner = _msgSender();
845         _transfer(owner, to, amount);
846         return true;
847     }
848 
849     /**
850      * @dev See {IERC20-allowance}.
851      */
852     function allowance(address owner, address spender) public view virtual override returns (uint256) {
853         return _allowances[owner][spender];
854     }
855 
856     /**
857      * @dev See {IERC20-approve}.
858      *
859      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
860      * `transferFrom`. This is semantically equivalent to an infinite approval.
861      *
862      * Requirements:
863      *
864      * - `spender` cannot be the zero address.
865      */
866     function approve(address spender, uint256 amount) public virtual override returns (bool) {
867         address owner = _msgSender();
868         _approve(owner, spender, amount);
869         return true;
870     }
871 
872     /**
873      * @dev See {IERC20-transferFrom}.
874      *
875      * Emits an {Approval} event indicating the updated allowance. This is not
876      * required by the EIP. See the note at the beginning of {ERC20}.
877      *
878      * NOTE: Does not update the allowance if the current allowance
879      * is the maximum `uint256`.
880      *
881      * Requirements:
882      *
883      * - `from` and `to` cannot be the zero address.
884      * - `from` must have a balance of at least `amount`.
885      * - the caller must have allowance for ``from``'s tokens of at least
886      * `amount`.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 amount
892     ) public virtual override returns (bool) {
893         address spender = _msgSender();
894         _spendAllowance(from, spender, amount);
895         _transfer(from, to, amount);
896         return true;
897     }
898 
899     /**
900      * @dev Atomically increases the allowance granted to `spender` by the caller.
901      *
902      * This is an alternative to {approve} that can be used as a mitigation for
903      * problems described in {IERC20-approve}.
904      *
905      * Emits an {Approval} event indicating the updated allowance.
906      *
907      * Requirements:
908      *
909      * - `spender` cannot be the zero address.
910      */
911     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
912         address owner = _msgSender();
913         _approve(owner, spender, _allowances[owner][spender] + addedValue);
914         return true;
915     }
916 
917     /**
918      * @dev Atomically decreases the allowance granted to `spender` by the caller.
919      *
920      * This is an alternative to {approve} that can be used as a mitigation for
921      * problems described in {IERC20-approve}.
922      *
923      * Emits an {Approval} event indicating the updated allowance.
924      *
925      * Requirements:
926      *
927      * - `spender` cannot be the zero address.
928      * - `spender` must have allowance for the caller of at least
929      * `subtractedValue`.
930      */
931     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
932         address owner = _msgSender();
933         uint256 currentAllowance = _allowances[owner][spender];
934         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
935         unchecked {
936             _approve(owner, spender, currentAllowance - subtractedValue);
937         }
938 
939         return true;
940     }
941 
942     /**
943      * @dev Moves `amount` of tokens from `sender` to `recipient`.
944      *
945      * This internal function is equivalent to {transfer}, and can be used to
946      * e.g. implement automatic token fees, slashing mechanisms, etc.
947      *
948      * Emits a {Transfer} event.
949      *
950      * Requirements:
951      *
952      * - `from` cannot be the zero address.
953      * - `to` cannot be the zero address.
954      * - `from` must have a balance of at least `amount`.
955      */
956     function _transfer(
957         address from,
958         address to,
959         uint256 amount
960     ) internal virtual {
961         require(from != address(0), "ERC20: transfer from the zero address");
962         require(to != address(0), "ERC20: transfer to the zero address");
963 
964         _beforeTokenTransfer(from, to, amount);
965 
966         uint256 fromBalance = _balances[from];
967         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
968         unchecked {
969             _balances[from] = fromBalance - amount;
970         }
971         _balances[to] += amount;
972 
973         emit Transfer(from, to, amount);
974 
975         _afterTokenTransfer(from, to, amount);
976     }
977 
978     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
979      * the total supply.
980      *
981      * Emits a {Transfer} event with `from` set to the zero address.
982      *
983      * Requirements:
984      *
985      * - `account` cannot be the zero address.
986      */
987     function _mint(address account, uint256 amount) internal virtual {
988         require(account != address(0), "ERC20: mint to the zero address");
989 
990         _beforeTokenTransfer(address(0), account, amount);
991 
992         _totalSupply += amount;
993         _balances[account] += amount;
994         emit Transfer(address(0), account, amount);
995 
996         _afterTokenTransfer(address(0), account, amount);
997     }
998 
999     /**
1000      * @dev Destroys `amount` tokens from `account`, reducing the
1001      * total supply.
1002      *
1003      * Emits a {Transfer} event with `to` set to the zero address.
1004      *
1005      * Requirements:
1006      *
1007      * - `account` cannot be the zero address.
1008      * - `account` must have at least `amount` tokens.
1009      */
1010     function _burn(address account, uint256 amount) internal virtual {
1011         require(account != address(0), "ERC20: burn from the zero address");
1012 
1013         _beforeTokenTransfer(account, address(0), amount);
1014 
1015         uint256 accountBalance = _balances[account];
1016         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1017         unchecked {
1018             _balances[account] = accountBalance - amount;
1019         }
1020         _totalSupply -= amount;
1021 
1022         emit Transfer(account, address(0), amount);
1023 
1024         _afterTokenTransfer(account, address(0), amount);
1025     }
1026 
1027     /**
1028      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1029      *
1030      * This internal function is equivalent to `approve`, and can be used to
1031      * e.g. set automatic allowances for certain subsystems, etc.
1032      *
1033      * Emits an {Approval} event.
1034      *
1035      * Requirements:
1036      *
1037      * - `owner` cannot be the zero address.
1038      * - `spender` cannot be the zero address.
1039      */
1040     function _approve(
1041         address owner,
1042         address spender,
1043         uint256 amount
1044     ) internal virtual {
1045         require(owner != address(0), "ERC20: approve from the zero address");
1046         require(spender != address(0), "ERC20: approve to the zero address");
1047 
1048         _allowances[owner][spender] = amount;
1049         emit Approval(owner, spender, amount);
1050     }
1051 
1052     /**
1053      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1054      *
1055      * Does not update the allowance amount in case of infinite allowance.
1056      * Revert if not enough allowance is available.
1057      *
1058      * Might emit an {Approval} event.
1059      */
1060     function _spendAllowance(
1061         address owner,
1062         address spender,
1063         uint256 amount
1064     ) internal virtual {
1065         uint256 currentAllowance = allowance(owner, spender);
1066         if (currentAllowance != type(uint256).max) {
1067             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1068             unchecked {
1069                 _approve(owner, spender, currentAllowance - amount);
1070             }
1071         }
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any transfer of tokens. This includes
1076      * minting and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1081      * will be transferred to `to`.
1082      * - when `from` is zero, `amount` tokens will be minted for `to`.
1083      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1084      * - `from` and `to` are never both zero.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 amount
1092     ) internal virtual {}
1093 
1094     /**
1095      * @dev Hook that is called after any transfer of tokens. This includes
1096      * minting and burning.
1097      *
1098      * Calling conditions:
1099      *
1100      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1101      * has been transferred to `to`.
1102      * - when `from` is zero, `amount` tokens have been minted for `to`.
1103      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1104      * - `from` and `to` are never both zero.
1105      *
1106      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1107      */
1108     function _afterTokenTransfer(
1109         address from,
1110         address to,
1111         uint256 amount
1112     ) internal virtual {}
1113 }
1114 
1115 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol
1116 
1117 
1118 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 
1123 
1124 
1125 /**
1126  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1127  * total supply at the time are recorded for later access.
1128  *
1129  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1130  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1131  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1132  * used to create an efficient ERC20 forking mechanism.
1133  *
1134  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1135  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1136  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1137  * and the account address.
1138  *
1139  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1140  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
1141  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1142  *
1143  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1144  * alternative consider {ERC20Votes}.
1145  *
1146  * ==== Gas Costs
1147  *
1148  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1149  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1150  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1151  *
1152  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1153  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1154  * transfers will have normal cost until the next snapshot, and so on.
1155  */
1156 
1157 abstract contract ERC20Snapshot is ERC20 {
1158     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1159     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1160 
1161     using Arrays for uint256[];
1162     using Counters for Counters.Counter;
1163 
1164     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1165     // Snapshot struct, but that would impede usage of functions that work on an array.
1166     struct Snapshots {
1167         uint256[] ids;
1168         uint256[] values;
1169     }
1170 
1171     mapping(address => Snapshots) private _accountBalanceSnapshots;
1172     Snapshots private _totalSupplySnapshots;
1173 
1174     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1175     Counters.Counter private _currentSnapshotId;
1176 
1177     /**
1178      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1179      */
1180     event Snapshot(uint256 id);
1181 
1182     /**
1183      * @dev Creates a new snapshot and returns its snapshot id.
1184      *
1185      * Emits a {Snapshot} event that contains the same id.
1186      *
1187      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1188      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1189      *
1190      * [WARNING]
1191      * ====
1192      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1193      * you must consider that it can potentially be used by attackers in two ways.
1194      *
1195      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1196      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1197      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1198      * section above.
1199      *
1200      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1201      * ====
1202      */
1203     function _snapshot() internal virtual returns (uint256) {
1204         _currentSnapshotId.increment();
1205 
1206         uint256 currentId = _getCurrentSnapshotId();
1207         emit Snapshot(currentId);
1208         return currentId;
1209     }
1210 
1211     /**
1212      * @dev Get the current snapshotId
1213      */
1214     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1215         return _currentSnapshotId.current();
1216     }
1217 
1218     /**
1219      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1220      */
1221     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1222         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1223 
1224         return snapshotted ? value : balanceOf(account);
1225     }
1226 
1227     /**
1228      * @dev Retrieves the total supply at the time `snapshotId` was created.
1229      */
1230     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1231         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1232 
1233         return snapshotted ? value : totalSupply();
1234     }
1235 
1236     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1237     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1238     function _beforeTokenTransfer(
1239         address from,
1240         address to,
1241         uint256 amount
1242     ) internal virtual override {
1243         super._beforeTokenTransfer(from, to, amount);
1244 
1245         if (from == address(0)) {
1246             // mint
1247             _updateAccountSnapshot(to);
1248             _updateTotalSupplySnapshot();
1249         } else if (to == address(0)) {
1250             // burn
1251             _updateAccountSnapshot(from);
1252             _updateTotalSupplySnapshot();
1253         } else {
1254             // transfer
1255             _updateAccountSnapshot(from);
1256             _updateAccountSnapshot(to);
1257         }
1258     }
1259 
1260     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1261         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1262         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1263 
1264         // When a valid snapshot is queried, there are three possibilities:
1265         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1266         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1267         //  to this id is the current one.
1268         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1269         //  requested id, and its value is the one to return.
1270         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1271         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1272         //  larger than the requested one.
1273         //
1274         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1275         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1276         // exactly this.
1277 
1278         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1279 
1280         if (index == snapshots.ids.length) {
1281             return (false, 0);
1282         } else {
1283             return (true, snapshots.values[index]);
1284         }
1285     }
1286 
1287     function _updateAccountSnapshot(address account) private {
1288         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1289     }
1290 
1291     function _updateTotalSupplySnapshot() private {
1292         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1293     }
1294 
1295     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1296         uint256 currentId = _getCurrentSnapshotId();
1297         if (_lastSnapshotId(snapshots.ids) < currentId) {
1298             snapshots.ids.push(currentId);
1299             snapshots.values.push(currentValue);
1300         }
1301     }
1302 
1303     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1304         if (ids.length == 0) {
1305             return 0;
1306         } else {
1307             return ids[ids.length - 1];
1308         }
1309     }
1310 }
1311 
1312 // File: GOM2/GOM2.sol
1313 
1314 
1315 pragma solidity ^0.8.13;
1316 
1317 
1318 
1319 contract GoMoney2 is ERC20Snapshot, AccessControl {
1320     
1321     bytes32 public constant FREEZE_ROLE = keccak256("FREEZE_ROLE");
1322     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1323 
1324     constructor() payable ERC20('GoMoney2', 'GOM2') {
1325         _mint(msg.sender, 1000000000 * uint(10) ** decimals());
1326         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1327         _setupRole(FREEZE_ROLE, msg.sender);
1328         _setupRole(SNAPSHOT_ROLE, msg.sender);
1329     }
1330 
1331     mapping (address => bool) public frozen;
1332 
1333     event Freeze(address holder);
1334     event Unfreeze(address holder);
1335 
1336     modifier notFrozen(address holder) {
1337         require(!frozen[holder]);
1338         _;
1339     }
1340 
1341     function decimals() public view virtual override returns (uint8) {
1342         return 18;
1343     }
1344 
1345     function transfer(
1346         address to,
1347         uint256 value
1348     ) notFrozen(msg.sender) public override returns (bool) {
1349         _transfer(msg.sender, to, value);
1350         return true;
1351     }
1352 
1353     function transferFrom(
1354         address from, 
1355         address to, 
1356         uint256 amount
1357     ) notFrozen(from) public override returns (bool) {
1358         require(allowance(from, to) >= amount);
1359         _transfer(from, to, amount);
1360         return true;
1361     }
1362 
1363     function burn(uint256 amount) notFrozen(msg.sender) public onlyRole(DEFAULT_ADMIN_ROLE) {
1364         _burn(msg.sender, amount);
1365     }
1366 
1367     function freezeAccount(address _holder) public onlyRole(FREEZE_ROLE) returns (bool) {
1368         require(!frozen[_holder]);
1369         frozen[_holder] = true;
1370         emit Freeze(_holder);
1371         return true;
1372     }
1373 
1374     function unfreezeAccount(address _holder) public onlyRole(FREEZE_ROLE) returns (bool) {
1375         require(frozen[_holder]);
1376         frozen[_holder] = false;
1377         emit Unfreeze(_holder);
1378         return true;
1379     }
1380 
1381     function snapshot() public onlyRole(SNAPSHOT_ROLE) returns (uint256) {
1382         uint256 snapshotId = _snapshot();
1383         emit Snapshot(snapshotId);
1384         return snapshotId;
1385     }
1386 }