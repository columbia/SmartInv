1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts@4.3.2/utils/Context.sol
5 
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 // CAUTION
37 // This version of SafeMath should only be used with Solidity 0.8 or later,
38 // because it relies on the compiler's built in overflow checks.
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations.
42  *
43  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
44  * now has built in overflow checking.
45  */
46 library SafeMath {
47     /**
48      * @dev Returns the addition of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             uint256 c = a + b;
55             if (c < a) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
62      *
63      * _Available since v3.4._
64      */
65     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b > a) return (false, 0);
68             return (true, a - b);
69         }
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80             // benefit is lost if 'b' is also tested.
81             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82             if (a == 0) return (true, 0);
83             uint256 c = a * b;
84             if (c / a != b) return (false, 0);
85             return (true, c);
86         }
87     }
88 
89     /**
90      * @dev Returns the division of two unsigned integers, with a division by zero flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             if (b == 0) return (false, 0);
97             return (true, a / b);
98         }
99     }
100 
101     /**
102      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             if (b == 0) return (false, 0);
109             return (true, a % b);
110         }
111     }
112 
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `+` operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a + b;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a - b;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a * b;
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers, reverting on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's `/` operator.
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a / b;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * reverting when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a % b;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
187      * overflow (when the result is negative).
188      *
189      * CAUTION: This function is deprecated because it requires allocating memory for the error
190      * message unnecessarily. For custom revert reasons use {trySub}.
191      *
192      * Counterpart to Solidity's `-` operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(
199         uint256 a,
200         uint256 b,
201         string memory errorMessage
202     ) internal pure returns (uint256) {
203         unchecked {
204             require(b <= a, errorMessage);
205             return a - b;
206         }
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a / b;
229         }
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * reverting with custom message when dividing by zero.
235      *
236      * CAUTION: This function is deprecated because it requires allocating memory for the error
237      * message unnecessarily. For custom revert reasons use {tryMod}.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         unchecked {
253             require(b > 0, errorMessage);
254             return a % b;
255         }
256     }
257 }
258 
259 // File: @openzeppelin/contracts@4.3.2/utils/Strings.sol
260 
261 
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev String operations.
267  */
268 library Strings {
269     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
273      */
274     function toString(uint256 value) internal pure returns (string memory) {
275         // Inspired by OraclizeAPI's implementation - MIT licence
276         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
277 
278         if (value == 0) {
279             return "0";
280         }
281         uint256 temp = value;
282         uint256 digits;
283         while (temp != 0) {
284             digits++;
285             temp /= 10;
286         }
287         bytes memory buffer = new bytes(digits);
288         while (value != 0) {
289             digits -= 1;
290             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
291             value /= 10;
292         }
293         return string(buffer);
294     }
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
298      */
299     function toHexString(uint256 value) internal pure returns (string memory) {
300         if (value == 0) {
301             return "0x00";
302         }
303         uint256 temp = value;
304         uint256 length = 0;
305         while (temp != 0) {
306             length++;
307             temp >>= 8;
308         }
309         return toHexString(value, length);
310     }
311 
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
314      */
315     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
316         bytes memory buffer = new bytes(2 * length + 2);
317         buffer[0] = "0";
318         buffer[1] = "x";
319         for (uint256 i = 2 * length + 1; i > 1; --i) {
320             buffer[i] = _HEX_SYMBOLS[value & 0xf];
321             value >>= 4;
322         }
323         require(value == 0, "Strings: hex length insufficient");
324         return string(buffer);
325     }
326 }
327 
328 // File: @openzeppelin/contracts@4.3.2/token/ERC20/IERC20.sol
329 
330 
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC20 standard as defined in the EIP.
336  */
337 interface IERC20 {
338     /**
339      * @dev Returns the amount of tokens in existence.
340      */
341     function totalSupply() external view returns (uint256);
342 
343     /**
344      * @dev Returns the amount of tokens owned by `account`.
345      */
346     function balanceOf(address account) external view returns (uint256);
347 
348     /**
349      * @dev Moves `amount` tokens from the caller's account to `recipient`.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * Emits a {Transfer} event.
354      */
355     function transfer(address recipient, uint256 amount) external returns (bool);
356 
357     /**
358      * @dev Returns the remaining number of tokens that `spender` will be
359      * allowed to spend on behalf of `owner` through {transferFrom}. This is
360      * zero by default.
361      *
362      * This value changes when {approve} or {transferFrom} are called.
363      */
364     function allowance(address owner, address spender) external view returns (uint256);
365 
366     /**
367      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * IMPORTANT: Beware that changing an allowance with this method brings the risk
372      * that someone may use both the old and the new allowance by unfortunate
373      * transaction ordering. One possible solution to mitigate this race
374      * condition is to first reduce the spender's allowance to 0 and set the
375      * desired value afterwards:
376      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
377      *
378      * Emits an {Approval} event.
379      */
380     function approve(address spender, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Moves `amount` tokens from `sender` to `recipient` using the
384      * allowance mechanism. `amount` is then deducted from the caller's
385      * allowance.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * Emits a {Transfer} event.
390      */
391     function transferFrom(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) external returns (bool);
396 
397     /**
398      * @dev Emitted when `value` tokens are moved from one account (`from`) to
399      * another (`to`).
400      *
401      * Note that `value` may be zero.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 value);
404 
405     /**
406      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
407      * a call to {approve}. `value` is the new allowance.
408      */
409     event Approval(address indexed owner, address indexed spender, uint256 value);
410 }
411 
412 
413 // File: @openzeppelin/contracts@4.3.2/token/ERC20/extensions/IERC20Metadata.sol
414 
415 
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Interface for the optional metadata functions from the ERC20 standard.
422  *
423  * _Available since v4.1._
424  */
425 interface IERC20Metadata is IERC20 {
426     /**
427      * @dev Returns the name of the token.
428      */
429     function name() external view returns (string memory);
430 
431     /**
432      * @dev Returns the symbol of the token.
433      */
434     function symbol() external view returns (string memory);
435 
436     /**
437      * @dev Returns the decimals places of the token.
438      */
439     function decimals() external view returns (uint8);
440 }
441 
442 
443 // File: @openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 
471 // File: @openzeppelin/contracts@4.3.2/utils/introspection/ERC165.sol
472 
473 
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Implementation of the {IERC165} interface.
480  *
481  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
482  * for the additional interface id that will be supported. For example:
483  *
484  * ```solidity
485  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
487  * }
488  * ```
489  *
490  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
491  */
492 abstract contract ERC165 is IERC165 {
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         return interfaceId == type(IERC165).interfaceId;
498     }
499 }
500 
501 
502 
503 // File: @openzeppelin/contracts@4.3.2/access/IAccessControl.sol
504 
505 
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev External interface of AccessControl declared to support ERC165 detection.
511  */
512 interface IAccessControl {
513     /**
514      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
515      *
516      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
517      * {RoleAdminChanged} not being emitted signaling this.
518      *
519      * _Available since v3.1._
520      */
521     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
522 
523     /**
524      * @dev Emitted when `account` is granted `role`.
525      *
526      * `sender` is the account that originated the contract call, an admin role
527      * bearer except when using {AccessControl-_setupRole}.
528      */
529     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
530 
531     /**
532      * @dev Emitted when `account` is revoked `role`.
533      *
534      * `sender` is the account that originated the contract call:
535      *   - if using `revokeRole`, it is the admin role bearer
536      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
537      */
538     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
539 
540     /**
541      * @dev Returns `true` if `account` has been granted `role`.
542      */
543     function hasRole(bytes32 role, address account) external view returns (bool);
544 
545     /**
546      * @dev Returns the admin role that controls `role`. See {grantRole} and
547      * {revokeRole}.
548      *
549      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
550      */
551     function getRoleAdmin(bytes32 role) external view returns (bytes32);
552 
553     /**
554      * @dev Grants `role` to `account`.
555      *
556      * If `account` had not been already granted `role`, emits a {RoleGranted}
557      * event.
558      *
559      * Requirements:
560      *
561      * - the caller must have ``role``'s admin role.
562      */
563     function grantRole(bytes32 role, address account) external;
564 
565     /**
566      * @dev Revokes `role` from `account`.
567      *
568      * If `account` had been granted `role`, emits a {RoleRevoked} event.
569      *
570      * Requirements:
571      *
572      * - the caller must have ``role``'s admin role.
573      */
574     function revokeRole(bytes32 role, address account) external;
575 
576     /**
577      * @dev Revokes `role` from the calling account.
578      *
579      * Roles are often managed via {grantRole} and {revokeRole}: this function's
580      * purpose is to provide a mechanism for accounts to lose their privileges
581      * if they are compromised (such as when a trusted device is misplaced).
582      *
583      * If the calling account had been granted `role`, emits a {RoleRevoked}
584      * event.
585      *
586      * Requirements:
587      *
588      * - the caller must be `account`.
589      */
590     function renounceRole(bytes32 role, address account) external;
591 }
592 
593 
594 // File: @openzeppelin/contracts@4.3.2/access/AccessControl.sol
595 
596 
597 
598 pragma solidity ^0.8.0;
599 
600 
601 
602 
603 
604 /**
605  * @dev Contract module that allows children to implement role-based access
606  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
607  * members except through off-chain means by accessing the contract event logs. Some
608  * applications may benefit from on-chain enumerability, for those cases see
609  * {AccessControlEnumerable}.
610  *
611  * Roles are referred to by their `bytes32` identifier. These should be exposed
612  * in the external API and be unique. The best way to achieve this is by
613  * using `public constant` hash digests:
614  *
615  * ```
616  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
617  * ```
618  *
619  * Roles can be used to represent a set of permissions. To restrict access to a
620  * function call, use {hasRole}:
621  *
622  * ```
623  * function foo() public {
624  *     require(hasRole(MY_ROLE, msg.sender));
625  *     ...
626  * }
627  * ```
628  *
629  * Roles can be granted and revoked dynamically via the {grantRole} and
630  * {revokeRole} functions. Each role has an associated admin role, and only
631  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
632  *
633  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
634  * that only accounts with this role will be able to grant or revoke other
635  * roles. More complex role relationships can be created by using
636  * {_setRoleAdmin}.
637  *
638  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
639  * grant and revoke this role. Extra precautions should be taken to secure
640  * accounts that have been granted it.
641  */
642 abstract contract AccessControl is Context, IAccessControl, ERC165 {
643     struct RoleData {
644         mapping(address => bool) members;
645         bytes32 adminRole;
646     }
647 
648     mapping(bytes32 => RoleData) private _roles;
649 
650     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
651 
652     /**
653      * @dev Modifier that checks that an account has a specific role. Reverts
654      * with a standardized message including the required role.
655      *
656      * The format of the revert reason is given by the following regular expression:
657      *
658      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
659      *
660      * _Available since v4.1._
661      */
662     modifier onlyRole(bytes32 role) {
663         _checkRole(role, _msgSender());
664         _;
665     }
666 
667     /**
668      * @dev See {IERC165-supportsInterface}.
669      */
670     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
671         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
672     }
673 
674     /**
675      * @dev Returns `true` if `account` has been granted `role`.
676      */
677     function hasRole(bytes32 role, address account) public view override returns (bool) {
678         return _roles[role].members[account];
679     }
680 
681     /**
682      * @dev Revert with a standard message if `account` is missing `role`.
683      *
684      * The format of the revert reason is given by the following regular expression:
685      *
686      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
687      */
688     function _checkRole(bytes32 role, address account) internal view {
689         if (!hasRole(role, account)) {
690             revert(
691                 string(
692                     abi.encodePacked(
693                         "AccessControl: account ",
694                         Strings.toHexString(uint160(account), 20),
695                         " is missing role ",
696                         Strings.toHexString(uint256(role), 32)
697                     )
698                 )
699             );
700         }
701     }
702 
703     /**
704      * @dev Returns the admin role that controls `role`. See {grantRole} and
705      * {revokeRole}.
706      *
707      * To change a role's admin, use {_setRoleAdmin}.
708      */
709     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
710         return _roles[role].adminRole;
711     }
712 
713     /**
714      * @dev Grants `role` to `account`.
715      *
716      * If `account` had not been already granted `role`, emits a {RoleGranted}
717      * event.
718      *
719      * Requirements:
720      *
721      * - the caller must have ``role``'s admin role.
722      */
723     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
724         _grantRole(role, account);
725     }
726 
727     /**
728      * @dev Revokes `role` from `account`.
729      *
730      * If `account` had been granted `role`, emits a {RoleRevoked} event.
731      *
732      * Requirements:
733      *
734      * - the caller must have ``role``'s admin role.
735      */
736     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
737         _revokeRole(role, account);
738     }
739 
740     /**
741      * @dev Revokes `role` from the calling account.
742      *
743      * Roles are often managed via {grantRole} and {revokeRole}: this function's
744      * purpose is to provide a mechanism for accounts to lose their privileges
745      * if they are compromised (such as when a trusted device is misplaced).
746      *
747      * If the calling account had been granted `role`, emits a {RoleRevoked}
748      * event.
749      *
750      * Requirements:
751      *
752      * - the caller must be `account`.
753      */
754     function renounceRole(bytes32 role, address account) public virtual override {
755         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
756 
757         _revokeRole(role, account);
758     }
759 
760     /**
761      * @dev Grants `role` to `account`.
762      *
763      * If `account` had not been already granted `role`, emits a {RoleGranted}
764      * event. Note that unlike {grantRole}, this function doesn't perform any
765      * checks on the calling account.
766      *
767      * [WARNING]
768      * ====
769      * This function should only be called from the constructor when setting
770      * up the initial roles for the system.
771      *
772      * Using this function in any other way is effectively circumventing the admin
773      * system imposed by {AccessControl}.
774      * ====
775      */
776     function _setupRole(bytes32 role, address account) internal virtual {
777         _grantRole(role, account);
778     }
779 
780     /**
781      * @dev Sets `adminRole` as ``role``'s admin role.
782      *
783      * Emits a {RoleAdminChanged} event.
784      */
785     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
786         bytes32 previousAdminRole = getRoleAdmin(role);
787         _roles[role].adminRole = adminRole;
788         emit RoleAdminChanged(role, previousAdminRole, adminRole);
789     }
790 
791     function _grantRole(bytes32 role, address account) private {
792         if (!hasRole(role, account)) {
793             _roles[role].members[account] = true;
794             emit RoleGranted(role, account, _msgSender());
795         }
796     }
797 
798     function _revokeRole(bytes32 role, address account) private {
799         if (hasRole(role, account)) {
800             _roles[role].members[account] = false;
801             emit RoleRevoked(role, account, _msgSender());
802         }
803     }
804 }
805 
806 
807 // File: @openzeppelin/contracts@4.3.2/security/Pausable.sol
808 
809 
810 
811 pragma solidity ^0.8.0;
812 
813 
814 /**
815  * @dev Contract module which allows children to implement an emergency stop
816  * mechanism that can be triggered by an authorized account.
817  *
818  * This module is used through inheritance. It will make available the
819  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
820  * the functions of your contract. Note that they will not be pausable by
821  * simply including this module, only once the modifiers are put in place.
822  */
823 abstract contract Pausable is Context {
824     /**
825      * @dev Emitted when the pause is triggered by `account`.
826      */
827     event Paused(address account);
828 
829     /**
830      * @dev Emitted when the pause is lifted by `account`.
831      */
832     event Unpaused(address account);
833 
834     bool private _paused;
835 
836     /**
837      * @dev Initializes the contract in unpaused state.
838      */
839     constructor() {
840         _paused = false;
841     }
842 
843     /**
844      * @dev Returns true if the contract is paused, and false otherwise.
845      */
846     function paused() public view virtual returns (bool) {
847         return _paused;
848     }
849 
850     /**
851      * @dev Modifier to make a function callable only when the contract is not paused.
852      *
853      * Requirements:
854      *
855      * - The contract must not be paused.
856      */
857     modifier whenNotPaused() {
858         require(!paused(), "Pausable: paused");
859         _;
860     }
861 
862     /**
863      * @dev Modifier to make a function callable only when the contract is paused.
864      *
865      * Requirements:
866      *
867      * - The contract must be paused.
868      */
869     modifier whenPaused() {
870         require(paused(), "Pausable: not paused");
871         _;
872     }
873 
874     /**
875      * @dev Triggers stopped state.
876      *
877      * Requirements:
878      *
879      * - The contract must not be paused.
880      */
881     function _pause() internal virtual whenNotPaused {
882         _paused = true;
883         emit Paused(_msgSender());
884     }
885 
886     /**
887      * @dev Returns to normal state.
888      *
889      * Requirements:
890      *
891      * - The contract must be paused.
892      */
893     function _unpause() internal virtual whenPaused {
894         _paused = false;
895         emit Unpaused(_msgSender());
896     }
897 }
898 
899 
900 
901 // File: @openzeppelin/contracts@4.3.2/token/ERC20/ERC20.sol
902 
903 
904 
905 pragma solidity ^0.8.0;
906 
907 
908 
909 
910 /**
911  * @dev Implementation of the {IERC20} interface.
912  *
913  * This implementation is agnostic to the way tokens are created. This means
914  * that a supply mechanism has to be added in a derived contract using {_mint}.
915  * For a generic mechanism see {ERC20PresetMinterPauser}.
916  *
917  * TIP: For a detailed writeup see our guide
918  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
919  * to implement supply mechanisms].
920  *
921  * We have followed general OpenZeppelin Contracts guidelines: functions revert
922  * instead returning `false` on failure. This behavior is nonetheless
923  * conventional and does not conflict with the expectations of ERC20
924  * applications.
925  *
926  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
927  * This allows applications to reconstruct the allowance for all accounts just
928  * by listening to said events. Other implementations of the EIP may not emit
929  * these events, as it isn't required by the specification.
930  *
931  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
932  * functions have been added to mitigate the well-known issues around setting
933  * allowances. See {IERC20-approve}.
934  */
935 contract ERC20 is Context, IERC20, IERC20Metadata {
936     mapping(address => uint256) private _balances;
937 
938     mapping(address => mapping(address => uint256)) private _allowances;
939 
940     uint256 private _totalSupply;
941 
942     string private _name;
943     string private _symbol;
944 
945     /**
946      * @dev Sets the values for {name} and {symbol}.
947      *
948      * The default value of {decimals} is 18. To select a different value for
949      * {decimals} you should overload it.
950      *
951      * All two of these values are immutable: they can only be set once during
952      * construction.
953      */
954     constructor(string memory name_, string memory symbol_) {
955         _name = name_;
956         _symbol = symbol_;
957     }
958 
959     /**
960      * @dev Returns the name of the token.
961      */
962     function name() public view virtual override returns (string memory) {
963         return _name;
964     }
965 
966     /**
967      * @dev Returns the symbol of the token, usually a shorter version of the
968      * name.
969      */
970     function symbol() public view virtual override returns (string memory) {
971         return _symbol;
972     }
973 
974     /**
975      * @dev Returns the number of decimals used to get its user representation.
976      * For example, if `decimals` equals `2`, a balance of `505` tokens should
977      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
978      *
979      * Tokens usually opt for a value of 18, imitating the relationship between
980      * Ether and Wei. This is the value {ERC20} uses, unless this function is
981      * overridden;
982      *
983      * NOTE: This information is only used for _display_ purposes: it in
984      * no way affects any of the arithmetic of the contract, including
985      * {IERC20-balanceOf} and {IERC20-transfer}.
986      */
987     function decimals() public view virtual override returns (uint8) {
988         return 18;
989     }
990 
991     /**
992      * @dev See {IERC20-totalSupply}.
993      */
994     function totalSupply() public view virtual override returns (uint256) {
995         return _totalSupply;
996     }
997 
998     /**
999      * @dev See {IERC20-balanceOf}.
1000      */
1001     function balanceOf(address account) public view virtual override returns (uint256) {
1002         return _balances[account];
1003     }
1004 
1005     /**
1006      * @dev See {IERC20-transfer}.
1007      *
1008      * Requirements:
1009      *
1010      * - `recipient` cannot be the zero address.
1011      * - the caller must have a balance of at least `amount`.
1012      */
1013     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1014         _transfer(_msgSender(), recipient, amount);
1015         return true;
1016     }
1017 
1018     /**
1019      * @dev See {IERC20-allowance}.
1020      */
1021     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1022         return _allowances[owner][spender];
1023     }
1024 
1025     /**
1026      * @dev See {IERC20-approve}.
1027      *
1028      * Requirements:
1029      *
1030      * - `spender` cannot be the zero address.
1031      */
1032     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1033         _approve(_msgSender(), spender, amount);
1034         return true;
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-transferFrom}.
1039      *
1040      * Emits an {Approval} event indicating the updated allowance. This is not
1041      * required by the EIP. See the note at the beginning of {ERC20}.
1042      *
1043      * Requirements:
1044      *
1045      * - `sender` and `recipient` cannot be the zero address.
1046      * - `sender` must have a balance of at least `amount`.
1047      * - the caller must have allowance for ``sender``'s tokens of at least
1048      * `amount`.
1049      */
1050     function transferFrom(
1051         address sender,
1052         address recipient,
1053         uint256 amount
1054     ) public virtual override returns (bool) {
1055         _transfer(sender, recipient, amount);
1056 
1057         uint256 currentAllowance = _allowances[sender][_msgSender()];
1058         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1059         unchecked {
1060             _approve(sender, _msgSender(), currentAllowance - amount);
1061         }
1062 
1063         return true;
1064     }
1065 
1066     /**
1067      * @dev Atomically increases the allowance granted to `spender` by the caller.
1068      *
1069      * This is an alternative to {approve} that can be used as a mitigation for
1070      * problems described in {IERC20-approve}.
1071      *
1072      * Emits an {Approval} event indicating the updated allowance.
1073      *
1074      * Requirements:
1075      *
1076      * - `spender` cannot be the zero address.
1077      */
1078     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1079         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1080         return true;
1081     }
1082 
1083     /**
1084      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1085      *
1086      * This is an alternative to {approve} that can be used as a mitigation for
1087      * problems described in {IERC20-approve}.
1088      *
1089      * Emits an {Approval} event indicating the updated allowance.
1090      *
1091      * Requirements:
1092      *
1093      * - `spender` cannot be the zero address.
1094      * - `spender` must have allowance for the caller of at least
1095      * `subtractedValue`.
1096      */
1097     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1098         uint256 currentAllowance = _allowances[_msgSender()][spender];
1099         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1100         unchecked {
1101             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1102         }
1103 
1104         return true;
1105     }
1106 
1107     /**
1108      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1109      *
1110      * This internal function is equivalent to {transfer}, and can be used to
1111      * e.g. implement automatic token fees, slashing mechanisms, etc.
1112      *
1113      * Emits a {Transfer} event.
1114      *
1115      * Requirements:
1116      *
1117      * - `sender` cannot be the zero address.
1118      * - `recipient` cannot be the zero address.
1119      * - `sender` must have a balance of at least `amount`.
1120      */
1121     function _transfer(
1122         address sender,
1123         address recipient,
1124         uint256 amount
1125     ) internal virtual {
1126         require(sender != address(0), "ERC20: transfer from the zero address");
1127         require(recipient != address(0), "ERC20: transfer to the zero address");
1128 
1129         _beforeTokenTransfer(sender, recipient, amount);
1130 
1131         uint256 senderBalance = _balances[sender];
1132         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1133         unchecked {
1134             _balances[sender] = senderBalance - amount;
1135         }
1136         _balances[recipient] += amount;
1137 
1138         emit Transfer(sender, recipient, amount);
1139 
1140         _afterTokenTransfer(sender, recipient, amount);
1141     }
1142 
1143     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1144      * the total supply.
1145      *
1146      * Emits a {Transfer} event with `from` set to the zero address.
1147      *
1148      * Requirements:
1149      *
1150      * - `account` cannot be the zero address.
1151      */
1152     function _mint(address account, uint256 amount) internal virtual {
1153         require(account != address(0), "ERC20: mint to the zero address");
1154 
1155         _beforeTokenTransfer(address(0), account, amount);
1156 
1157         _totalSupply += amount;
1158         _balances[account] += amount;
1159         emit Transfer(address(0), account, amount);
1160 
1161         _afterTokenTransfer(address(0), account, amount);
1162     }    
1163     /**
1164      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1165      *
1166      * This internal function is equivalent to `approve`, and can be used to
1167      * e.g. set automatic allowances for certain subsystems, etc.
1168      *
1169      * Emits an {Approval} event.
1170      *
1171      * Requirements:
1172      *
1173      * - `owner` cannot be the zero address.
1174      * - `spender` cannot be the zero address.
1175      */
1176     function _approve(
1177         address owner,
1178         address spender,
1179         uint256 amount
1180     ) internal virtual {
1181         require(owner != address(0), "ERC20: approve from the zero address");
1182         require(spender != address(0), "ERC20: approve to the zero address");
1183 
1184         _allowances[owner][spender] = amount;
1185         emit Approval(owner, spender, amount);
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before any transfer of tokens. This includes
1190      * minting and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1195      * will be transferred to `to`.
1196      * - when `from` is zero, `amount` tokens will be minted for `to`.
1197      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1198      * - `from` and `to` are never both zero.
1199      *
1200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1201      */
1202     function _beforeTokenTransfer(
1203         address from,
1204         address to,
1205         uint256 amount
1206     ) internal virtual {}
1207 
1208     /**
1209      * @dev Hook that is called after any transfer of tokens. This includes
1210      * minting and burning.
1211      *
1212      * Calling conditions:
1213      *
1214      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1215      * has been transferred to `to`.
1216      * - when `from` is zero, `amount` tokens have been minted for `to`.
1217      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1218      * - `from` and `to` are never both zero.
1219      *
1220      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1221      */
1222     function _afterTokenTransfer(
1223         address from,
1224         address to,
1225         uint256 amount
1226     ) internal virtual {}
1227 }
1228 
1229 
1230 // File: THE9.sol
1231 
1232 
1233 pragma solidity >=0.8.2 <0.9.0;
1234 
1235 
1236 
1237 
1238 
1239 
1240 
1241 contract THE9 is ERC20, Pausable, AccessControl {
1242     uint256 constant DEFAULT_RELEASE_TIMESTAMP = 4102444800; // 2100년 January 1일 Friday AM 12:00:00
1243     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1244     bytes32 public constant ORG_ADMIN_ROLE = keccak256("ORG_ADMIN_ROLE");
1245 
1246     struct BeneficiaryInfo {
1247         uint256 amount;
1248         uint256 releaseTime;
1249         uint256 unlockPercent;
1250         uint256 lockCycleDays;
1251         uint256 remainPercent;
1252         uint256 remainAmount;
1253     }
1254 
1255     mapping(address => BeneficiaryInfo) private _addressBeneficiaryInfo;
1256     address[] public Beneficiaries;
1257 
1258     constructor() ERC20("THE9", "THE9") {
1259         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1260         _setupRole(PAUSER_ROLE, _msgSender());
1261         _setupRole(ORG_ADMIN_ROLE, _msgSender());
1262         _mint(_msgSender(), _calcDecimal(10000000000));
1263     }
1264 
1265     event CreateAmountWithLock(address beneficiary, BeneficiaryInfo beneficiaryInfo);
1266     event UpdateAmountWithLock(address beneficiary, uint256 amount, uint256 releaseTime, BeneficiaryInfo beneficiaryInfo);
1267     event TransferAmountWithLock(address beneficiary, uint256 amount, BeneficiaryInfo beneficiaryInfo);
1268 
1269     /* public functions */
1270     function pause() public onlyRole(PAUSER_ROLE) {
1271         _pause();
1272     }
1273 
1274     function unpause() public onlyRole(PAUSER_ROLE) {
1275         _unpause();
1276     }
1277        
1278     function createAmountWithLock(address beneficiary, uint256 amount, uint256 firstReleaseTime, uint256 unlockPercent, uint256 lockCycleDays)
1279         public
1280         whenNotPaused
1281         onlyRole(ORG_ADMIN_ROLE) 
1282     {
1283         if (firstReleaseTime == 0) {
1284             firstReleaseTime = DEFAULT_RELEASE_TIMESTAMP;
1285         }
1286         assert(_beforeSaveAmountWithLock(beneficiary, firstReleaseTime, unlockPercent, lockCycleDays));
1287         
1288         if (_checkExists(beneficiary)) {
1289             updateAmountWithLock(beneficiary, amount, firstReleaseTime, unlockPercent, lockCycleDays);
1290         } else {
1291             _setInfo(
1292                 beneficiary, 
1293                 _calcDecimal(amount), 
1294                 firstReleaseTime, 
1295                 unlockPercent, 
1296                 lockCycleDays, 
1297                 100, 
1298                 _calcDecimal(amount)
1299             );
1300             Beneficiaries.push(beneficiary);
1301 
1302             emit CreateAmountWithLock(beneficiary, _getInfo(beneficiary));
1303         }
1304     }
1305 
1306     function updateAmountWithLock(address beneficiary, uint256 amount, uint256 firstReleaseTime, uint256 unlockPercent, uint256 lockCycleDays)
1307         public
1308         whenNotPaused
1309         onlyRole(ORG_ADMIN_ROLE) 
1310     {
1311         require(_checkExists(beneficiary), "THE9: beneficiary not found");
1312         
1313         if (firstReleaseTime == 0) {
1314             firstReleaseTime = DEFAULT_RELEASE_TIMESTAMP;
1315         }
1316         assert(_beforeSaveAmountWithLock(beneficiary, firstReleaseTime, unlockPercent, lockCycleDays));
1317         
1318         BeneficiaryInfo memory beforeInfo = _getInfo(beneficiary);
1319         if(beforeInfo.remainPercent > 0 && beforeInfo.remainAmount > 0) {
1320             require(_getInfo(beneficiary).remainPercent >= 100, "THE9: account to which revenue was transferred");    
1321         }
1322         
1323         _setInfo(
1324             beneficiary, 
1325             _calcDecimal(amount), 
1326             firstReleaseTime, 
1327             unlockPercent, 
1328             lockCycleDays, 
1329             100, 
1330             _calcDecimal(amount)
1331         );
1332         
1333         emit UpdateAmountWithLock(beneficiary, amount, firstReleaseTime, beforeInfo);
1334     }
1335 
1336     function transferAmountWithLock(address beneficiary)
1337         public
1338         whenNotPaused
1339         onlyRole(ORG_ADMIN_ROLE) 
1340     {
1341         require(beneficiary != address(0), "THE9: beneficiary from the zero address");
1342 
1343         // check exists
1344         require(_checkExists(beneficiary), "THE9: beneficiary not found");
1345 
1346         // check timestamp
1347         BeneficiaryInfo memory beforeInfo = _getInfo(beneficiary);
1348         require(_isReleased(beneficiary), "THE9: It hasn't been released yet");
1349         require(beforeInfo.remainAmount > 0, "THE9: No remaining amount");
1350 
1351         // remainAmount
1352         uint256 remainAmount = beforeInfo.remainAmount;
1353         uint256 remainPercent = beforeInfo.remainPercent;
1354         
1355         // check transfer available amount
1356         uint256 transferableAmount = _getTransferableAmount(beneficiary);
1357         if (transferableAmount > beforeInfo.remainAmount) {
1358             transferableAmount = beforeInfo.remainAmount;
1359             remainPercent = 0;
1360         } else {
1361             remainPercent = SafeMath.sub(remainPercent, beforeInfo.unlockPercent);
1362         }
1363 
1364         _beforeTokenTransfer(_msgSender(), beneficiary, transferableAmount);
1365 
1366         transfer(beneficiary, transferableAmount);
1367 
1368         _setInfo(
1369             beneficiary, 
1370             beforeInfo.amount, 
1371             _getNextReleaseTime(beneficiary), 
1372             beforeInfo.unlockPercent, 
1373             beforeInfo.lockCycleDays, 
1374             remainPercent, 
1375             SafeMath.sub(remainAmount, transferableAmount)
1376         );
1377         
1378         super._afterTokenTransfer(_msgSender(), beneficiary, transferableAmount);
1379         emit TransferAmountWithLock(beneficiary, transferableAmount, _getInfo(beneficiary));
1380     }
1381 
1382     function getBeneficiaryInfo(address beneficiary) 
1383         public 
1384         view 
1385         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256) 
1386     {
1387         require(beneficiary != address(0), "THE9: beneficiary from the zero address");
1388         BeneficiaryInfo memory beforeInfo = _getInfo(beneficiary);
1389         
1390         // check transfer available amount
1391         uint256 transferableAmount = _getTransferableAmount(beneficiary);
1392         if (transferableAmount > beforeInfo.remainAmount) {
1393             transferableAmount = beforeInfo.remainAmount;
1394         }
1395         
1396         return (beforeInfo.amount,
1397             beforeInfo.releaseTime,
1398             beforeInfo.unlockPercent,
1399             beforeInfo.lockCycleDays,
1400             beforeInfo.remainPercent,
1401             beforeInfo.remainAmount,
1402             transferableAmount);
1403     }
1404 
1405 
1406     /* internal functions */
1407     function _getInfo(address beneficiary)
1408         internal
1409         view
1410         returns (BeneficiaryInfo memory)
1411     {
1412         return _addressBeneficiaryInfo[beneficiary];
1413     }
1414     
1415     function _setInfo(address beneficiary, uint256 amount, uint256 releaseTime, uint256 unlockPercent, uint256 lockCycleDays, uint256 remainPercent, uint256 remainAmount)
1416         internal
1417     {
1418         _addressBeneficiaryInfo[beneficiary].amount = amount;
1419         _addressBeneficiaryInfo[beneficiary].releaseTime = releaseTime;
1420         _addressBeneficiaryInfo[beneficiary].unlockPercent = unlockPercent;
1421         _addressBeneficiaryInfo[beneficiary].lockCycleDays = lockCycleDays;
1422         _addressBeneficiaryInfo[beneficiary].remainPercent = remainPercent;
1423         _addressBeneficiaryInfo[beneficiary].remainAmount = remainAmount;
1424     }
1425     
1426     function _beforeSaveAmountWithLock(address beneficiary, uint256 firstReleaseTime, uint256 unlockPercent, uint256 lockCycleDays)
1427         internal
1428         view
1429         returns (bool)
1430     {
1431         require(beneficiary != address(0), "THE9: beneficiary from the zero address");
1432         require(unlockPercent > 0, "THE9: percentage cannot be zero");
1433         require(unlockPercent <= 100, "THE9: percentage cannot exceed 100");
1434         require(lockCycleDays > 0, "THE9: lock cycle days cannot be zero");
1435         require(firstReleaseTime > block.timestamp, "THE9: first release time is before current time");
1436         
1437         return true;
1438     }
1439     
1440     function _beforeTokenTransfer(address from, address to, uint256 amount)
1441         internal
1442         whenNotPaused
1443         override
1444     {
1445         super._beforeTokenTransfer(from, to, amount);
1446     }
1447 
1448     function _isReleased(address beneficiary) 
1449         internal 
1450         view 
1451         returns(bool) 
1452     {
1453         if (_checkExists(beneficiary)) {
1454             return block.timestamp >= _getInfo(beneficiary).releaseTime;
1455         } else {
1456             return false;
1457         }
1458     }
1459 
1460     function _getNextReleaseTime(address beneficiary) 
1461         internal 
1462         view 
1463         returns(uint256) 
1464     {
1465         return SafeMath.add(_getInfo(beneficiary).releaseTime, SafeMath.mul(_getInfo(beneficiary).lockCycleDays, 24*60*60)); // per day
1466     }
1467     
1468     function _checkExists(address beneficiary) 
1469         internal 
1470         view 
1471         returns(bool) 
1472     {
1473         if (_getInfo(beneficiary).amount > 0) {
1474             return true;
1475         } else {
1476             return false;
1477         }
1478     }
1479     
1480     function _calcDecimal(uint256 amount) 
1481         internal 
1482         view
1483         returns(uint256)
1484     {
1485         return amount * 10 ** decimals();
1486     }
1487     
1488     function _getTransferableAmount(address beneficiary)
1489         internal
1490         view
1491         returns (uint256)
1492     {
1493         if (_isReleased(beneficiary)) {
1494             return SafeMath.div(SafeMath.mul(_getInfo(beneficiary).amount, _getInfo(beneficiary).unlockPercent), 100);
1495         } else {
1496             return 0;
1497         }
1498     }
1499 }