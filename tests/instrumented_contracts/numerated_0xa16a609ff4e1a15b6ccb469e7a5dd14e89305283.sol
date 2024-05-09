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
393 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
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
460         _checkRole(role);
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
479      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
480      * Overriding this function changes the behavior of the {onlyRole} modifier.
481      *
482      * Format of the revert message is described in {_checkRole}.
483      *
484      * _Available since v4.6._
485      */
486     function _checkRole(bytes32 role) internal view virtual {
487         _checkRole(role, _msgSender());
488     }
489 
490     /**
491      * @dev Revert with a standard message if `account` is missing `role`.
492      *
493      * The format of the revert reason is given by the following regular expression:
494      *
495      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
496      */
497     function _checkRole(bytes32 role, address account) internal view virtual {
498         if (!hasRole(role, account)) {
499             revert(
500                 string(
501                     abi.encodePacked(
502                         "AccessControl: account ",
503                         Strings.toHexString(uint160(account), 20),
504                         " is missing role ",
505                         Strings.toHexString(uint256(role), 32)
506                     )
507                 )
508             );
509         }
510     }
511 
512     /**
513      * @dev Returns the admin role that controls `role`. See {grantRole} and
514      * {revokeRole}.
515      *
516      * To change a role's admin, use {_setRoleAdmin}.
517      */
518     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
519         return _roles[role].adminRole;
520     }
521 
522     /**
523      * @dev Grants `role` to `account`.
524      *
525      * If `account` had not been already granted `role`, emits a {RoleGranted}
526      * event.
527      *
528      * Requirements:
529      *
530      * - the caller must have ``role``'s admin role.
531      */
532     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
533         _grantRole(role, account);
534     }
535 
536     /**
537      * @dev Revokes `role` from `account`.
538      *
539      * If `account` had been granted `role`, emits a {RoleRevoked} event.
540      *
541      * Requirements:
542      *
543      * - the caller must have ``role``'s admin role.
544      */
545     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
546         _revokeRole(role, account);
547     }
548 
549     /**
550      * @dev Revokes `role` from the calling account.
551      *
552      * Roles are often managed via {grantRole} and {revokeRole}: this function's
553      * purpose is to provide a mechanism for accounts to lose their privileges
554      * if they are compromised (such as when a trusted device is misplaced).
555      *
556      * If the calling account had been revoked `role`, emits a {RoleRevoked}
557      * event.
558      *
559      * Requirements:
560      *
561      * - the caller must be `account`.
562      */
563     function renounceRole(bytes32 role, address account) public virtual override {
564         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
565 
566         _revokeRole(role, account);
567     }
568 
569     /**
570      * @dev Grants `role` to `account`.
571      *
572      * If `account` had not been already granted `role`, emits a {RoleGranted}
573      * event. Note that unlike {grantRole}, this function doesn't perform any
574      * checks on the calling account.
575      *
576      * [WARNING]
577      * ====
578      * This function should only be called from the constructor when setting
579      * up the initial roles for the system.
580      *
581      * Using this function in any other way is effectively circumventing the admin
582      * system imposed by {AccessControl}.
583      * ====
584      *
585      * NOTE: This function is deprecated in favor of {_grantRole}.
586      */
587     function _setupRole(bytes32 role, address account) internal virtual {
588         _grantRole(role, account);
589     }
590 
591     /**
592      * @dev Sets `adminRole` as ``role``'s admin role.
593      *
594      * Emits a {RoleAdminChanged} event.
595      */
596     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
597         bytes32 previousAdminRole = getRoleAdmin(role);
598         _roles[role].adminRole = adminRole;
599         emit RoleAdminChanged(role, previousAdminRole, adminRole);
600     }
601 
602     /**
603      * @dev Grants `role` to `account`.
604      *
605      * Internal function without access restriction.
606      */
607     function _grantRole(bytes32 role, address account) internal virtual {
608         if (!hasRole(role, account)) {
609             _roles[role].members[account] = true;
610             emit RoleGranted(role, account, _msgSender());
611         }
612     }
613 
614     /**
615      * @dev Revokes `role` from `account`.
616      *
617      * Internal function without access restriction.
618      */
619     function _revokeRole(bytes32 role, address account) internal virtual {
620         if (hasRole(role, account)) {
621             _roles[role].members[account] = false;
622             emit RoleRevoked(role, account, _msgSender());
623         }
624     }
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
628 
629 
630 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Interface of the ERC20 standard as defined in the EIP.
636  */
637 interface IERC20 {
638     /**
639      * @dev Emitted when `value` tokens are moved from one account (`from`) to
640      * another (`to`).
641      *
642      * Note that `value` may be zero.
643      */
644     event Transfer(address indexed from, address indexed to, uint256 value);
645 
646     /**
647      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
648      * a call to {approve}. `value` is the new allowance.
649      */
650     event Approval(address indexed owner, address indexed spender, uint256 value);
651 
652     /**
653      * @dev Returns the amount of tokens in existence.
654      */
655     function totalSupply() external view returns (uint256);
656 
657     /**
658      * @dev Returns the amount of tokens owned by `account`.
659      */
660     function balanceOf(address account) external view returns (uint256);
661 
662     /**
663      * @dev Moves `amount` tokens from the caller's account to `to`.
664      *
665      * Returns a boolean value indicating whether the operation succeeded.
666      *
667      * Emits a {Transfer} event.
668      */
669     function transfer(address to, uint256 amount) external returns (bool);
670 
671     /**
672      * @dev Returns the remaining number of tokens that `spender` will be
673      * allowed to spend on behalf of `owner` through {transferFrom}. This is
674      * zero by default.
675      *
676      * This value changes when {approve} or {transferFrom} are called.
677      */
678     function allowance(address owner, address spender) external view returns (uint256);
679 
680     /**
681      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
682      *
683      * Returns a boolean value indicating whether the operation succeeded.
684      *
685      * IMPORTANT: Beware that changing an allowance with this method brings the risk
686      * that someone may use both the old and the new allowance by unfortunate
687      * transaction ordering. One possible solution to mitigate this race
688      * condition is to first reduce the spender's allowance to 0 and set the
689      * desired value afterwards:
690      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
691      *
692      * Emits an {Approval} event.
693      */
694     function approve(address spender, uint256 amount) external returns (bool);
695 
696     /**
697      * @dev Moves `amount` tokens from `from` to `to` using the
698      * allowance mechanism. `amount` is then deducted from the caller's
699      * allowance.
700      *
701      * Returns a boolean value indicating whether the operation succeeded.
702      *
703      * Emits a {Transfer} event.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 amount
709     ) external returns (bool);
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @dev Interface for the optional metadata functions from the ERC20 standard.
722  *
723  * _Available since v4.1._
724  */
725 interface IERC20Metadata is IERC20 {
726     /**
727      * @dev Returns the name of the token.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the symbol of the token.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the decimals places of the token.
738      */
739     function decimals() external view returns (uint8);
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
743 
744 
745 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 
751 
752 /**
753  * @dev Implementation of the {IERC20} interface.
754  *
755  * This implementation is agnostic to the way tokens are created. This means
756  * that a supply mechanism has to be added in a derived contract using {_mint}.
757  * For a generic mechanism see {ERC20PresetMinterPauser}.
758  *
759  * TIP: For a detailed writeup see our guide
760  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
761  * to implement supply mechanisms].
762  *
763  * We have followed general OpenZeppelin Contracts guidelines: functions revert
764  * instead returning `false` on failure. This behavior is nonetheless
765  * conventional and does not conflict with the expectations of ERC20
766  * applications.
767  *
768  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
769  * This allows applications to reconstruct the allowance for all accounts just
770  * by listening to said events. Other implementations of the EIP may not emit
771  * these events, as it isn't required by the specification.
772  *
773  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
774  * functions have been added to mitigate the well-known issues around setting
775  * allowances. See {IERC20-approve}.
776  */
777 contract ERC20 is Context, IERC20, IERC20Metadata {
778     mapping(address => uint256) private _balances;
779 
780     mapping(address => mapping(address => uint256)) private _allowances;
781 
782     uint256 private _totalSupply;
783 
784     string private _name;
785     string private _symbol;
786 
787     /**
788      * @dev Sets the values for {name} and {symbol}.
789      *
790      * The default value of {decimals} is 18. To select a different value for
791      * {decimals} you should overload it.
792      *
793      * All two of these values are immutable: they can only be set once during
794      * construction.
795      */
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     /**
802      * @dev Returns the name of the token.
803      */
804     function name() public view virtual override returns (string memory) {
805         return _name;
806     }
807 
808     /**
809      * @dev Returns the symbol of the token, usually a shorter version of the
810      * name.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev Returns the number of decimals used to get its user representation.
818      * For example, if `decimals` equals `2`, a balance of `505` tokens should
819      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
820      *
821      * Tokens usually opt for a value of 18, imitating the relationship between
822      * Ether and Wei. This is the value {ERC20} uses, unless this function is
823      * overridden;
824      *
825      * NOTE: This information is only used for _display_ purposes: it in
826      * no way affects any of the arithmetic of the contract, including
827      * {IERC20-balanceOf} and {IERC20-transfer}.
828      */
829     function decimals() public view virtual override returns (uint8) {
830         return 18;
831     }
832 
833     /**
834      * @dev See {IERC20-totalSupply}.
835      */
836     function totalSupply() public view virtual override returns (uint256) {
837         return _totalSupply;
838     }
839 
840     /**
841      * @dev See {IERC20-balanceOf}.
842      */
843     function balanceOf(address account) public view virtual override returns (uint256) {
844         return _balances[account];
845     }
846 
847     /**
848      * @dev See {IERC20-transfer}.
849      *
850      * Requirements:
851      *
852      * - `to` cannot be the zero address.
853      * - the caller must have a balance of at least `amount`.
854      */
855     function transfer(address to, uint256 amount) public virtual override returns (bool) {
856         address owner = _msgSender();
857         _transfer(owner, to, amount);
858         return true;
859     }
860 
861     /**
862      * @dev See {IERC20-allowance}.
863      */
864     function allowance(address owner, address spender) public view virtual override returns (uint256) {
865         return _allowances[owner][spender];
866     }
867 
868     /**
869      * @dev See {IERC20-approve}.
870      *
871      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
872      * `transferFrom`. This is semantically equivalent to an infinite approval.
873      *
874      * Requirements:
875      *
876      * - `spender` cannot be the zero address.
877      */
878     function approve(address spender, uint256 amount) public virtual override returns (bool) {
879         address owner = _msgSender();
880         _approve(owner, spender, amount);
881         return true;
882     }
883 
884     /**
885      * @dev See {IERC20-transferFrom}.
886      *
887      * Emits an {Approval} event indicating the updated allowance. This is not
888      * required by the EIP. See the note at the beginning of {ERC20}.
889      *
890      * NOTE: Does not update the allowance if the current allowance
891      * is the maximum `uint256`.
892      *
893      * Requirements:
894      *
895      * - `from` and `to` cannot be the zero address.
896      * - `from` must have a balance of at least `amount`.
897      * - the caller must have allowance for ``from``'s tokens of at least
898      * `amount`.
899      */
900     function transferFrom(
901         address from,
902         address to,
903         uint256 amount
904     ) public virtual override returns (bool) {
905         address spender = _msgSender();
906         _spendAllowance(from, spender, amount);
907         _transfer(from, to, amount);
908         return true;
909     }
910 
911     /**
912      * @dev Atomically increases the allowance granted to `spender` by the caller.
913      *
914      * This is an alternative to {approve} that can be used as a mitigation for
915      * problems described in {IERC20-approve}.
916      *
917      * Emits an {Approval} event indicating the updated allowance.
918      *
919      * Requirements:
920      *
921      * - `spender` cannot be the zero address.
922      */
923     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
924         address owner = _msgSender();
925         _approve(owner, spender, allowance(owner, spender) + addedValue);
926         return true;
927     }
928 
929     /**
930      * @dev Atomically decreases the allowance granted to `spender` by the caller.
931      *
932      * This is an alternative to {approve} that can be used as a mitigation for
933      * problems described in {IERC20-approve}.
934      *
935      * Emits an {Approval} event indicating the updated allowance.
936      *
937      * Requirements:
938      *
939      * - `spender` cannot be the zero address.
940      * - `spender` must have allowance for the caller of at least
941      * `subtractedValue`.
942      */
943     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
944         address owner = _msgSender();
945         uint256 currentAllowance = allowance(owner, spender);
946         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
947         unchecked {
948             _approve(owner, spender, currentAllowance - subtractedValue);
949         }
950 
951         return true;
952     }
953 
954     /**
955      * @dev Moves `amount` of tokens from `sender` to `recipient`.
956      *
957      * This internal function is equivalent to {transfer}, and can be used to
958      * e.g. implement automatic token fees, slashing mechanisms, etc.
959      *
960      * Emits a {Transfer} event.
961      *
962      * Requirements:
963      *
964      * - `from` cannot be the zero address.
965      * - `to` cannot be the zero address.
966      * - `from` must have a balance of at least `amount`.
967      */
968     function _transfer(
969         address from,
970         address to,
971         uint256 amount
972     ) internal virtual {
973         require(from != address(0), "ERC20: transfer from the zero address");
974         require(to != address(0), "ERC20: transfer to the zero address");
975 
976         _beforeTokenTransfer(from, to, amount);
977 
978         uint256 fromBalance = _balances[from];
979         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
980         unchecked {
981             _balances[from] = fromBalance - amount;
982         }
983         _balances[to] += amount;
984 
985         emit Transfer(from, to, amount);
986 
987         _afterTokenTransfer(from, to, amount);
988     }
989 
990     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
991      * the total supply.
992      *
993      * Emits a {Transfer} event with `from` set to the zero address.
994      *
995      * Requirements:
996      *
997      * - `account` cannot be the zero address.
998      */
999     function _mint(address account, uint256 amount) internal virtual {
1000         require(account != address(0), "ERC20: mint to the zero address");
1001 
1002         _beforeTokenTransfer(address(0), account, amount);
1003 
1004         _totalSupply += amount;
1005         _balances[account] += amount;
1006         emit Transfer(address(0), account, amount);
1007 
1008         _afterTokenTransfer(address(0), account, amount);
1009     }
1010 
1011     /**
1012      * @dev Destroys `amount` tokens from `account`, reducing the
1013      * total supply.
1014      *
1015      * Emits a {Transfer} event with `to` set to the zero address.
1016      *
1017      * Requirements:
1018      *
1019      * - `account` cannot be the zero address.
1020      * - `account` must have at least `amount` tokens.
1021      */
1022     function _burn(address account, uint256 amount) internal virtual {
1023         require(account != address(0), "ERC20: burn from the zero address");
1024 
1025         _beforeTokenTransfer(account, address(0), amount);
1026 
1027         uint256 accountBalance = _balances[account];
1028         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1029         unchecked {
1030             _balances[account] = accountBalance - amount;
1031         }
1032         _totalSupply -= amount;
1033 
1034         emit Transfer(account, address(0), amount);
1035 
1036         _afterTokenTransfer(account, address(0), amount);
1037     }
1038 
1039     /**
1040      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1041      *
1042      * This internal function is equivalent to `approve`, and can be used to
1043      * e.g. set automatic allowances for certain subsystems, etc.
1044      *
1045      * Emits an {Approval} event.
1046      *
1047      * Requirements:
1048      *
1049      * - `owner` cannot be the zero address.
1050      * - `spender` cannot be the zero address.
1051      */
1052     function _approve(
1053         address owner,
1054         address spender,
1055         uint256 amount
1056     ) internal virtual {
1057         require(owner != address(0), "ERC20: approve from the zero address");
1058         require(spender != address(0), "ERC20: approve to the zero address");
1059 
1060         _allowances[owner][spender] = amount;
1061         emit Approval(owner, spender, amount);
1062     }
1063 
1064     /**
1065      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1066      *
1067      * Does not update the allowance amount in case of infinite allowance.
1068      * Revert if not enough allowance is available.
1069      *
1070      * Might emit an {Approval} event.
1071      */
1072     function _spendAllowance(
1073         address owner,
1074         address spender,
1075         uint256 amount
1076     ) internal virtual {
1077         uint256 currentAllowance = allowance(owner, spender);
1078         if (currentAllowance != type(uint256).max) {
1079             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1080             unchecked {
1081                 _approve(owner, spender, currentAllowance - amount);
1082             }
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before any transfer of tokens. This includes
1088      * minting and burning.
1089      *
1090      * Calling conditions:
1091      *
1092      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1093      * will be transferred to `to`.
1094      * - when `from` is zero, `amount` tokens will be minted for `to`.
1095      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1096      * - `from` and `to` are never both zero.
1097      *
1098      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1099      */
1100     function _beforeTokenTransfer(
1101         address from,
1102         address to,
1103         uint256 amount
1104     ) internal virtual {}
1105 
1106     /**
1107      * @dev Hook that is called after any transfer of tokens. This includes
1108      * minting and burning.
1109      *
1110      * Calling conditions:
1111      *
1112      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1113      * has been transferred to `to`.
1114      * - when `from` is zero, `amount` tokens have been minted for `to`.
1115      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1116      * - `from` and `to` are never both zero.
1117      *
1118      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1119      */
1120     function _afterTokenTransfer(
1121         address from,
1122         address to,
1123         uint256 amount
1124     ) internal virtual {}
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol
1128 
1129 
1130 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/extensions/ERC20Snapshot.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 
1136 
1137 /**
1138  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1139  * total supply at the time are recorded for later access.
1140  *
1141  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1142  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1143  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1144  * used to create an efficient ERC20 forking mechanism.
1145  *
1146  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1147  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1148  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1149  * and the account address.
1150  *
1151  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1152  * return `block.number` will trigger the creation of snapshot at the beginning of each new block. When overriding this
1153  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1154  *
1155  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1156  * alternative consider {ERC20Votes}.
1157  *
1158  * ==== Gas Costs
1159  *
1160  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1161  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1162  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1163  *
1164  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1165  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1166  * transfers will have normal cost until the next snapshot, and so on.
1167  */
1168 
1169 abstract contract ERC20Snapshot is ERC20 {
1170     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1171     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1172 
1173     using Arrays for uint256[];
1174     using Counters for Counters.Counter;
1175 
1176     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1177     // Snapshot struct, but that would impede usage of functions that work on an array.
1178     struct Snapshots {
1179         uint256[] ids;
1180         uint256[] values;
1181     }
1182 
1183     mapping(address => Snapshots) private _accountBalanceSnapshots;
1184     Snapshots private _totalSupplySnapshots;
1185 
1186     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1187     Counters.Counter private _currentSnapshotId;
1188 
1189     /**
1190      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1191      */
1192     event Snapshot(uint256 id);
1193 
1194     /**
1195      * @dev Creates a new snapshot and returns its snapshot id.
1196      *
1197      * Emits a {Snapshot} event that contains the same id.
1198      *
1199      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1200      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1201      *
1202      * [WARNING]
1203      * ====
1204      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1205      * you must consider that it can potentially be used by attackers in two ways.
1206      *
1207      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1208      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1209      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1210      * section above.
1211      *
1212      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1213      * ====
1214      */
1215     function _snapshot() internal virtual returns (uint256) {
1216         _currentSnapshotId.increment();
1217 
1218         uint256 currentId = _getCurrentSnapshotId();
1219         emit Snapshot(currentId);
1220         return currentId;
1221     }
1222 
1223     /**
1224      * @dev Get the current snapshotId
1225      */
1226     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1227         return _currentSnapshotId.current();
1228     }
1229 
1230     /**
1231      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1232      */
1233     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1234         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1235 
1236         return snapshotted ? value : balanceOf(account);
1237     }
1238 
1239     /**
1240      * @dev Retrieves the total supply at the time `snapshotId` was created.
1241      */
1242     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1243         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1244 
1245         return snapshotted ? value : totalSupply();
1246     }
1247 
1248     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1249     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1250     function _beforeTokenTransfer(
1251         address from,
1252         address to,
1253         uint256 amount
1254     ) internal virtual override {
1255         super._beforeTokenTransfer(from, to, amount);
1256 
1257         if (from == address(0)) {
1258             // mint
1259             _updateAccountSnapshot(to);
1260             _updateTotalSupplySnapshot();
1261         } else if (to == address(0)) {
1262             // burn
1263             _updateAccountSnapshot(from);
1264             _updateTotalSupplySnapshot();
1265         } else {
1266             // transfer
1267             _updateAccountSnapshot(from);
1268             _updateAccountSnapshot(to);
1269         }
1270     }
1271 
1272     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1273         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1274         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1275 
1276         // When a valid snapshot is queried, there are three possibilities:
1277         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1278         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1279         //  to this id is the current one.
1280         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1281         //  requested id, and its value is the one to return.
1282         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1283         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1284         //  larger than the requested one.
1285         //
1286         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1287         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1288         // exactly this.
1289 
1290         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1291 
1292         if (index == snapshots.ids.length) {
1293             return (false, 0);
1294         } else {
1295             return (true, snapshots.values[index]);
1296         }
1297     }
1298 
1299     function _updateAccountSnapshot(address account) private {
1300         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1301     }
1302 
1303     function _updateTotalSupplySnapshot() private {
1304         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1305     }
1306 
1307     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1308         uint256 currentId = _getCurrentSnapshotId();
1309         if (_lastSnapshotId(snapshots.ids) < currentId) {
1310             snapshots.ids.push(currentId);
1311             snapshots.values.push(currentValue);
1312         }
1313     }
1314 
1315     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1316         if (ids.length == 0) {
1317             return 0;
1318         } else {
1319             return ids[ids.length - 1];
1320         }
1321     }
1322 }
1323 
1324 // File: contracts/SPUMEToken.sol
1325 
1326 
1327 pragma solidity ^0.8.7;
1328 
1329 
1330 
1331 contract SPUMEToken is ERC20Snapshot, AccessControl{
1332     // Create snapshot role
1333     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1334 
1335     constructor(uint256 initialSupply) ERC20("Spume", "SPUME"){
1336         _mint(msg.sender, initialSupply);
1337         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1338     }
1339 
1340     function snapshot() public returns (uint256){
1341         require(hasRole(SNAPSHOT_ROLE, msg.sender), "AccessControl: sender must have role SNAPSHOT_ROLE");
1342         return _snapshot();
1343     }
1344 }