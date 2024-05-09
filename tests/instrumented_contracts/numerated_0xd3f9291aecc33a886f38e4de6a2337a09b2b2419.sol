1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.12.6 https://hardhat.org
3 
4 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.8.1
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev External interface of AccessControl declared to support ERC165 detection.
13  */
14 interface IAccessControl {
15     /**
16      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
17      *
18      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
19      * {RoleAdminChanged} not being emitted signaling this.
20      *
21      * _Available since v3.1._
22      */
23     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
24 
25     /**
26      * @dev Emitted when `account` is granted `role`.
27      *
28      * `sender` is the account that originated the contract call, an admin role
29      * bearer except when using {AccessControl-_setupRole}.
30      */
31     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
32 
33     /**
34      * @dev Emitted when `account` is revoked `role`.
35      *
36      * `sender` is the account that originated the contract call:
37      *   - if using `revokeRole`, it is the admin role bearer
38      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
39      */
40     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
41 
42     /**
43      * @dev Returns `true` if `account` has been granted `role`.
44      */
45     function hasRole(bytes32 role, address account) external view returns (bool);
46 
47     /**
48      * @dev Returns the admin role that controls `role`. See {grantRole} and
49      * {revokeRole}.
50      *
51      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
52      */
53     function getRoleAdmin(bytes32 role) external view returns (bytes32);
54 
55     /**
56      * @dev Grants `role` to `account`.
57      *
58      * If `account` had not been already granted `role`, emits a {RoleGranted}
59      * event.
60      *
61      * Requirements:
62      *
63      * - the caller must have ``role``'s admin role.
64      */
65     function grantRole(bytes32 role, address account) external;
66 
67     /**
68      * @dev Revokes `role` from `account`.
69      *
70      * If `account` had been granted `role`, emits a {RoleRevoked} event.
71      *
72      * Requirements:
73      *
74      * - the caller must have ``role``'s admin role.
75      */
76     function revokeRole(bytes32 role, address account) external;
77 
78     /**
79      * @dev Revokes `role` from the calling account.
80      *
81      * Roles are often managed via {grantRole} and {revokeRole}: this function's
82      * purpose is to provide a mechanism for accounts to lose their privileges
83      * if they are compromised (such as when a trusted device is misplaced).
84      *
85      * If the calling account had been granted `role`, emits a {RoleRevoked}
86      * event.
87      *
88      * Requirements:
89      *
90      * - the caller must be `account`.
91      */
92     function renounceRole(bytes32 role, address account) external;
93 }
94 
95 
96 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         return msg.data;
120     }
121 }
122 
123 
124 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.1
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Interface of the ERC165 standard, as defined in the
133  * https://eips.ethereum.org/EIPS/eip-165[EIP].
134  *
135  * Implementers can declare support of contract interfaces, which can then be
136  * queried by others ({ERC165Checker}).
137  *
138  * For an implementation, see {ERC165}.
139  */
140 interface IERC165 {
141     /**
142      * @dev Returns true if this contract implements the interface defined by
143      * `interfaceId`. See the corresponding
144      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
145      * to learn more about how these ids are created.
146      *
147      * This function call must use less than 30 000 gas.
148      */
149     function supportsInterface(bytes4 interfaceId) external view returns (bool);
150 }
151 
152 
153 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.1
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev Implementation of the {IERC165} interface.
162  *
163  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
164  * for the additional interface id that will be supported. For example:
165  *
166  * ```solidity
167  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
168  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
169  * }
170  * ```
171  *
172  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
173  */
174 abstract contract ERC165 is IERC165 {
175     /**
176      * @dev See {IERC165-supportsInterface}.
177      */
178     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
179         return interfaceId == type(IERC165).interfaceId;
180     }
181 }
182 
183 
184 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.1
185 
186 
187 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Standard math utilities missing in the Solidity language.
193  */
194 library Math {
195     enum Rounding {
196         Down, // Toward negative infinity
197         Up, // Toward infinity
198         Zero // Toward zero
199     }
200 
201     /**
202      * @dev Returns the largest of two numbers.
203      */
204     function max(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a > b ? a : b;
206     }
207 
208     /**
209      * @dev Returns the smallest of two numbers.
210      */
211     function min(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a < b ? a : b;
213     }
214 
215     /**
216      * @dev Returns the average of two numbers. The result is rounded towards
217      * zero.
218      */
219     function average(uint256 a, uint256 b) internal pure returns (uint256) {
220         // (a + b) / 2 can overflow.
221         return (a & b) + (a ^ b) / 2;
222     }
223 
224     /**
225      * @dev Returns the ceiling of the division of two numbers.
226      *
227      * This differs from standard division with `/` in that it rounds up instead
228      * of rounding down.
229      */
230     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
231         // (a + b - 1) / b can overflow on addition, so we distribute.
232         return a == 0 ? 0 : (a - 1) / b + 1;
233     }
234 
235     /**
236      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
237      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
238      * with further edits by Uniswap Labs also under MIT license.
239      */
240     function mulDiv(
241         uint256 x,
242         uint256 y,
243         uint256 denominator
244     ) internal pure returns (uint256 result) {
245         unchecked {
246             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
247             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
248             // variables such that product = prod1 * 2^256 + prod0.
249             uint256 prod0; // Least significant 256 bits of the product
250             uint256 prod1; // Most significant 256 bits of the product
251             assembly {
252                 let mm := mulmod(x, y, not(0))
253                 prod0 := mul(x, y)
254                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
255             }
256 
257             // Handle non-overflow cases, 256 by 256 division.
258             if (prod1 == 0) {
259                 return prod0 / denominator;
260             }
261 
262             // Make sure the result is less than 2^256. Also prevents denominator == 0.
263             require(denominator > prod1);
264 
265             ///////////////////////////////////////////////
266             // 512 by 256 division.
267             ///////////////////////////////////////////////
268 
269             // Make division exact by subtracting the remainder from [prod1 prod0].
270             uint256 remainder;
271             assembly {
272                 // Compute remainder using mulmod.
273                 remainder := mulmod(x, y, denominator)
274 
275                 // Subtract 256 bit number from 512 bit number.
276                 prod1 := sub(prod1, gt(remainder, prod0))
277                 prod0 := sub(prod0, remainder)
278             }
279 
280             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
281             // See https://cs.stackexchange.com/q/138556/92363.
282 
283             // Does not overflow because the denominator cannot be zero at this stage in the function.
284             uint256 twos = denominator & (~denominator + 1);
285             assembly {
286                 // Divide denominator by twos.
287                 denominator := div(denominator, twos)
288 
289                 // Divide [prod1 prod0] by twos.
290                 prod0 := div(prod0, twos)
291 
292                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
293                 twos := add(div(sub(0, twos), twos), 1)
294             }
295 
296             // Shift in bits from prod1 into prod0.
297             prod0 |= prod1 * twos;
298 
299             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
300             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
301             // four bits. That is, denominator * inv = 1 mod 2^4.
302             uint256 inverse = (3 * denominator) ^ 2;
303 
304             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
305             // in modular arithmetic, doubling the correct bits in each step.
306             inverse *= 2 - denominator * inverse; // inverse mod 2^8
307             inverse *= 2 - denominator * inverse; // inverse mod 2^16
308             inverse *= 2 - denominator * inverse; // inverse mod 2^32
309             inverse *= 2 - denominator * inverse; // inverse mod 2^64
310             inverse *= 2 - denominator * inverse; // inverse mod 2^128
311             inverse *= 2 - denominator * inverse; // inverse mod 2^256
312 
313             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
314             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
315             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
316             // is no longer required.
317             result = prod0 * inverse;
318             return result;
319         }
320     }
321 
322     /**
323      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
324      */
325     function mulDiv(
326         uint256 x,
327         uint256 y,
328         uint256 denominator,
329         Rounding rounding
330     ) internal pure returns (uint256) {
331         uint256 result = mulDiv(x, y, denominator);
332         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
333             result += 1;
334         }
335         return result;
336     }
337 
338     /**
339      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
340      *
341      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
342      */
343     function sqrt(uint256 a) internal pure returns (uint256) {
344         if (a == 0) {
345             return 0;
346         }
347 
348         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
349         //
350         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
351         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
352         //
353         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
354         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
355         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
356         //
357         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
358         uint256 result = 1 << (log2(a) >> 1);
359 
360         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
361         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
362         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
363         // into the expected uint128 result.
364         unchecked {
365             result = (result + a / result) >> 1;
366             result = (result + a / result) >> 1;
367             result = (result + a / result) >> 1;
368             result = (result + a / result) >> 1;
369             result = (result + a / result) >> 1;
370             result = (result + a / result) >> 1;
371             result = (result + a / result) >> 1;
372             return min(result, a / result);
373         }
374     }
375 
376     /**
377      * @notice Calculates sqrt(a), following the selected rounding direction.
378      */
379     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
380         unchecked {
381             uint256 result = sqrt(a);
382             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
383         }
384     }
385 
386     /**
387      * @dev Return the log in base 2, rounded down, of a positive value.
388      * Returns 0 if given 0.
389      */
390     function log2(uint256 value) internal pure returns (uint256) {
391         uint256 result = 0;
392         unchecked {
393             if (value >> 128 > 0) {
394                 value >>= 128;
395                 result += 128;
396             }
397             if (value >> 64 > 0) {
398                 value >>= 64;
399                 result += 64;
400             }
401             if (value >> 32 > 0) {
402                 value >>= 32;
403                 result += 32;
404             }
405             if (value >> 16 > 0) {
406                 value >>= 16;
407                 result += 16;
408             }
409             if (value >> 8 > 0) {
410                 value >>= 8;
411                 result += 8;
412             }
413             if (value >> 4 > 0) {
414                 value >>= 4;
415                 result += 4;
416             }
417             if (value >> 2 > 0) {
418                 value >>= 2;
419                 result += 2;
420             }
421             if (value >> 1 > 0) {
422                 result += 1;
423             }
424         }
425         return result;
426     }
427 
428     /**
429      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
430      * Returns 0 if given 0.
431      */
432     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
433         unchecked {
434             uint256 result = log2(value);
435             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
436         }
437     }
438 
439     /**
440      * @dev Return the log in base 10, rounded down, of a positive value.
441      * Returns 0 if given 0.
442      */
443     function log10(uint256 value) internal pure returns (uint256) {
444         uint256 result = 0;
445         unchecked {
446             if (value >= 10**64) {
447                 value /= 10**64;
448                 result += 64;
449             }
450             if (value >= 10**32) {
451                 value /= 10**32;
452                 result += 32;
453             }
454             if (value >= 10**16) {
455                 value /= 10**16;
456                 result += 16;
457             }
458             if (value >= 10**8) {
459                 value /= 10**8;
460                 result += 8;
461             }
462             if (value >= 10**4) {
463                 value /= 10**4;
464                 result += 4;
465             }
466             if (value >= 10**2) {
467                 value /= 10**2;
468                 result += 2;
469             }
470             if (value >= 10**1) {
471                 result += 1;
472             }
473         }
474         return result;
475     }
476 
477     /**
478      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
479      * Returns 0 if given 0.
480      */
481     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
482         unchecked {
483             uint256 result = log10(value);
484             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
485         }
486     }
487 
488     /**
489      * @dev Return the log in base 256, rounded down, of a positive value.
490      * Returns 0 if given 0.
491      *
492      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
493      */
494     function log256(uint256 value) internal pure returns (uint256) {
495         uint256 result = 0;
496         unchecked {
497             if (value >> 128 > 0) {
498                 value >>= 128;
499                 result += 16;
500             }
501             if (value >> 64 > 0) {
502                 value >>= 64;
503                 result += 8;
504             }
505             if (value >> 32 > 0) {
506                 value >>= 32;
507                 result += 4;
508             }
509             if (value >> 16 > 0) {
510                 value >>= 16;
511                 result += 2;
512             }
513             if (value >> 8 > 0) {
514                 result += 1;
515             }
516         }
517         return result;
518     }
519 
520     /**
521      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
522      * Returns 0 if given 0.
523      */
524     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
525         unchecked {
526             uint256 result = log256(value);
527             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
528         }
529     }
530 }
531 
532 
533 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.1
534 
535 
536 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev String operations.
542  */
543 library Strings {
544     bytes16 private constant _SYMBOLS = "0123456789abcdef";
545     uint8 private constant _ADDRESS_LENGTH = 20;
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
549      */
550     function toString(uint256 value) internal pure returns (string memory) {
551         unchecked {
552             uint256 length = Math.log10(value) + 1;
553             string memory buffer = new string(length);
554             uint256 ptr;
555             /// @solidity memory-safe-assembly
556             assembly {
557                 ptr := add(buffer, add(32, length))
558             }
559             while (true) {
560                 ptr--;
561                 /// @solidity memory-safe-assembly
562                 assembly {
563                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
564                 }
565                 value /= 10;
566                 if (value == 0) break;
567             }
568             return buffer;
569         }
570     }
571 
572     /**
573      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
574      */
575     function toHexString(uint256 value) internal pure returns (string memory) {
576         unchecked {
577             return toHexString(value, Math.log256(value) + 1);
578         }
579     }
580 
581     /**
582      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
583      */
584     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
585         bytes memory buffer = new bytes(2 * length + 2);
586         buffer[0] = "0";
587         buffer[1] = "x";
588         for (uint256 i = 2 * length + 1; i > 1; --i) {
589             buffer[i] = _SYMBOLS[value & 0xf];
590             value >>= 4;
591         }
592         require(value == 0, "Strings: hex length insufficient");
593         return string(buffer);
594     }
595 
596     /**
597      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
598      */
599     function toHexString(address addr) internal pure returns (string memory) {
600         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
601     }
602 }
603 
604 
605 // File @openzeppelin/contracts/access/AccessControl.sol@v4.8.1
606 
607 
608 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 
613 
614 
615 /**
616  * @dev Contract module that allows children to implement role-based access
617  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
618  * members except through off-chain means by accessing the contract event logs. Some
619  * applications may benefit from on-chain enumerability, for those cases see
620  * {AccessControlEnumerable}.
621  *
622  * Roles are referred to by their `bytes32` identifier. These should be exposed
623  * in the external API and be unique. The best way to achieve this is by
624  * using `public constant` hash digests:
625  *
626  * ```
627  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
628  * ```
629  *
630  * Roles can be used to represent a set of permissions. To restrict access to a
631  * function call, use {hasRole}:
632  *
633  * ```
634  * function foo() public {
635  *     require(hasRole(MY_ROLE, msg.sender));
636  *     ...
637  * }
638  * ```
639  *
640  * Roles can be granted and revoked dynamically via the {grantRole} and
641  * {revokeRole} functions. Each role has an associated admin role, and only
642  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
643  *
644  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
645  * that only accounts with this role will be able to grant or revoke other
646  * roles. More complex role relationships can be created by using
647  * {_setRoleAdmin}.
648  *
649  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
650  * grant and revoke this role. Extra precautions should be taken to secure
651  * accounts that have been granted it.
652  */
653 abstract contract AccessControl is Context, IAccessControl, ERC165 {
654     struct RoleData {
655         mapping(address => bool) members;
656         bytes32 adminRole;
657     }
658 
659     mapping(bytes32 => RoleData) private _roles;
660 
661     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
662 
663     /**
664      * @dev Modifier that checks that an account has a specific role. Reverts
665      * with a standardized message including the required role.
666      *
667      * The format of the revert reason is given by the following regular expression:
668      *
669      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
670      *
671      * _Available since v4.1._
672      */
673     modifier onlyRole(bytes32 role) {
674         _checkRole(role);
675         _;
676     }
677 
678     /**
679      * @dev See {IERC165-supportsInterface}.
680      */
681     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
683     }
684 
685     /**
686      * @dev Returns `true` if `account` has been granted `role`.
687      */
688     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
689         return _roles[role].members[account];
690     }
691 
692     /**
693      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
694      * Overriding this function changes the behavior of the {onlyRole} modifier.
695      *
696      * Format of the revert message is described in {_checkRole}.
697      *
698      * _Available since v4.6._
699      */
700     function _checkRole(bytes32 role) internal view virtual {
701         _checkRole(role, _msgSender());
702     }
703 
704     /**
705      * @dev Revert with a standard message if `account` is missing `role`.
706      *
707      * The format of the revert reason is given by the following regular expression:
708      *
709      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
710      */
711     function _checkRole(bytes32 role, address account) internal view virtual {
712         if (!hasRole(role, account)) {
713             revert(
714                 string(
715                     abi.encodePacked(
716                         "AccessControl: account ",
717                         Strings.toHexString(account),
718                         " is missing role ",
719                         Strings.toHexString(uint256(role), 32)
720                     )
721                 )
722             );
723         }
724     }
725 
726     /**
727      * @dev Returns the admin role that controls `role`. See {grantRole} and
728      * {revokeRole}.
729      *
730      * To change a role's admin, use {_setRoleAdmin}.
731      */
732     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
733         return _roles[role].adminRole;
734     }
735 
736     /**
737      * @dev Grants `role` to `account`.
738      *
739      * If `account` had not been already granted `role`, emits a {RoleGranted}
740      * event.
741      *
742      * Requirements:
743      *
744      * - the caller must have ``role``'s admin role.
745      *
746      * May emit a {RoleGranted} event.
747      */
748     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
749         _grantRole(role, account);
750     }
751 
752     /**
753      * @dev Revokes `role` from `account`.
754      *
755      * If `account` had been granted `role`, emits a {RoleRevoked} event.
756      *
757      * Requirements:
758      *
759      * - the caller must have ``role``'s admin role.
760      *
761      * May emit a {RoleRevoked} event.
762      */
763     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
764         _revokeRole(role, account);
765     }
766 
767     /**
768      * @dev Revokes `role` from the calling account.
769      *
770      * Roles are often managed via {grantRole} and {revokeRole}: this function's
771      * purpose is to provide a mechanism for accounts to lose their privileges
772      * if they are compromised (such as when a trusted device is misplaced).
773      *
774      * If the calling account had been revoked `role`, emits a {RoleRevoked}
775      * event.
776      *
777      * Requirements:
778      *
779      * - the caller must be `account`.
780      *
781      * May emit a {RoleRevoked} event.
782      */
783     function renounceRole(bytes32 role, address account) public virtual override {
784         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
785 
786         _revokeRole(role, account);
787     }
788 
789     /**
790      * @dev Grants `role` to `account`.
791      *
792      * If `account` had not been already granted `role`, emits a {RoleGranted}
793      * event. Note that unlike {grantRole}, this function doesn't perform any
794      * checks on the calling account.
795      *
796      * May emit a {RoleGranted} event.
797      *
798      * [WARNING]
799      * ====
800      * This function should only be called from the constructor when setting
801      * up the initial roles for the system.
802      *
803      * Using this function in any other way is effectively circumventing the admin
804      * system imposed by {AccessControl}.
805      * ====
806      *
807      * NOTE: This function is deprecated in favor of {_grantRole}.
808      */
809     function _setupRole(bytes32 role, address account) internal virtual {
810         _grantRole(role, account);
811     }
812 
813     /**
814      * @dev Sets `adminRole` as ``role``'s admin role.
815      *
816      * Emits a {RoleAdminChanged} event.
817      */
818     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
819         bytes32 previousAdminRole = getRoleAdmin(role);
820         _roles[role].adminRole = adminRole;
821         emit RoleAdminChanged(role, previousAdminRole, adminRole);
822     }
823 
824     /**
825      * @dev Grants `role` to `account`.
826      *
827      * Internal function without access restriction.
828      *
829      * May emit a {RoleGranted} event.
830      */
831     function _grantRole(bytes32 role, address account) internal virtual {
832         if (!hasRole(role, account)) {
833             _roles[role].members[account] = true;
834             emit RoleGranted(role, account, _msgSender());
835         }
836     }
837 
838     /**
839      * @dev Revokes `role` from `account`.
840      *
841      * Internal function without access restriction.
842      *
843      * May emit a {RoleRevoked} event.
844      */
845     function _revokeRole(bytes32 role, address account) internal virtual {
846         if (hasRole(role, account)) {
847             _roles[role].members[account] = false;
848             emit RoleRevoked(role, account, _msgSender());
849         }
850     }
851 }
852 
853 
854 // File @openzeppelin/contracts/security/Pausable.sol@v4.8.1
855 
856 
857 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 /**
862  * @dev Contract module which allows children to implement an emergency stop
863  * mechanism that can be triggered by an authorized account.
864  *
865  * This module is used through inheritance. It will make available the
866  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
867  * the functions of your contract. Note that they will not be pausable by
868  * simply including this module, only once the modifiers are put in place.
869  */
870 abstract contract Pausable is Context {
871     /**
872      * @dev Emitted when the pause is triggered by `account`.
873      */
874     event Paused(address account);
875 
876     /**
877      * @dev Emitted when the pause is lifted by `account`.
878      */
879     event Unpaused(address account);
880 
881     bool private _paused;
882 
883     /**
884      * @dev Initializes the contract in unpaused state.
885      */
886     constructor() {
887         _paused = false;
888     }
889 
890     /**
891      * @dev Modifier to make a function callable only when the contract is not paused.
892      *
893      * Requirements:
894      *
895      * - The contract must not be paused.
896      */
897     modifier whenNotPaused() {
898         _requireNotPaused();
899         _;
900     }
901 
902     /**
903      * @dev Modifier to make a function callable only when the contract is paused.
904      *
905      * Requirements:
906      *
907      * - The contract must be paused.
908      */
909     modifier whenPaused() {
910         _requirePaused();
911         _;
912     }
913 
914     /**
915      * @dev Returns true if the contract is paused, and false otherwise.
916      */
917     function paused() public view virtual returns (bool) {
918         return _paused;
919     }
920 
921     /**
922      * @dev Throws if the contract is paused.
923      */
924     function _requireNotPaused() internal view virtual {
925         require(!paused(), "Pausable: paused");
926     }
927 
928     /**
929      * @dev Throws if the contract is not paused.
930      */
931     function _requirePaused() internal view virtual {
932         require(paused(), "Pausable: not paused");
933     }
934 
935     /**
936      * @dev Triggers stopped state.
937      *
938      * Requirements:
939      *
940      * - The contract must not be paused.
941      */
942     function _pause() internal virtual whenNotPaused {
943         _paused = true;
944         emit Paused(_msgSender());
945     }
946 
947     /**
948      * @dev Returns to normal state.
949      *
950      * Requirements:
951      *
952      * - The contract must be paused.
953      */
954     function _unpause() internal virtual whenPaused {
955         _paused = false;
956         emit Unpaused(_msgSender());
957     }
958 }
959 
960 
961 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.1
962 
963 
964 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 /**
969  * @dev Required interface of an ERC721 compliant contract.
970  */
971 interface IERC721 is IERC165 {
972     /**
973      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
974      */
975     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
976 
977     /**
978      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
979      */
980     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
981 
982     /**
983      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
984      */
985     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
986 
987     /**
988      * @dev Returns the number of tokens in ``owner``'s account.
989      */
990     function balanceOf(address owner) external view returns (uint256 balance);
991 
992     /**
993      * @dev Returns the owner of the `tokenId` token.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      */
999     function ownerOf(uint256 tokenId) external view returns (address owner);
1000 
1001     /**
1002      * @dev Safely transfers `tokenId` token from `from` to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must exist and be owned by `from`.
1009      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1010      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes calldata data
1019     ) external;
1020 
1021     /**
1022      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1023      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1024      *
1025      * Requirements:
1026      *
1027      * - `from` cannot be the zero address.
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must exist and be owned by `from`.
1030      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1031      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) external;
1040 
1041     /**
1042      * @dev Transfers `tokenId` token from `from` to `to`.
1043      *
1044      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1045      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1046      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1047      *
1048      * Requirements:
1049      *
1050      * - `from` cannot be the zero address.
1051      * - `to` cannot be the zero address.
1052      * - `tokenId` token must be owned by `from`.
1053      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function transferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) external;
1062 
1063     /**
1064      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1065      * The approval is cleared when the token is transferred.
1066      *
1067      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1068      *
1069      * Requirements:
1070      *
1071      * - The caller must own the token or be an approved operator.
1072      * - `tokenId` must exist.
1073      *
1074      * Emits an {Approval} event.
1075      */
1076     function approve(address to, uint256 tokenId) external;
1077 
1078     /**
1079      * @dev Approve or remove `operator` as an operator for the caller.
1080      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1081      *
1082      * Requirements:
1083      *
1084      * - The `operator` cannot be the caller.
1085      *
1086      * Emits an {ApprovalForAll} event.
1087      */
1088     function setApprovalForAll(address operator, bool _approved) external;
1089 
1090     /**
1091      * @dev Returns the account approved for `tokenId` token.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must exist.
1096      */
1097     function getApproved(uint256 tokenId) external view returns (address operator);
1098 
1099     /**
1100      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1101      *
1102      * See {setApprovalForAll}
1103      */
1104     function isApprovedForAll(address owner, address operator) external view returns (bool);
1105 }
1106 
1107 
1108 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.1
1109 
1110 
1111 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 /**
1116  * @title ERC721 token receiver interface
1117  * @dev Interface for any contract that wants to support safeTransfers
1118  * from ERC721 asset contracts.
1119  */
1120 interface IERC721Receiver {
1121     /**
1122      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1123      * by `operator` from `from`, this function is called.
1124      *
1125      * It must return its Solidity selector to confirm the token transfer.
1126      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1127      *
1128      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1129      */
1130     function onERC721Received(
1131         address operator,
1132         address from,
1133         uint256 tokenId,
1134         bytes calldata data
1135     ) external returns (bytes4);
1136 }
1137 
1138 
1139 // File @openzeppelin/contracts/utils/Address.sol@v4.8.1
1140 
1141 
1142 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1143 
1144 pragma solidity ^0.8.1;
1145 
1146 /**
1147  * @dev Collection of functions related to the address type
1148  */
1149 library Address {
1150     /**
1151      * @dev Returns true if `account` is a contract.
1152      *
1153      * [IMPORTANT]
1154      * ====
1155      * It is unsafe to assume that an address for which this function returns
1156      * false is an externally-owned account (EOA) and not a contract.
1157      *
1158      * Among others, `isContract` will return false for the following
1159      * types of addresses:
1160      *
1161      *  - an externally-owned account
1162      *  - a contract in construction
1163      *  - an address where a contract will be created
1164      *  - an address where a contract lived, but was destroyed
1165      * ====
1166      *
1167      * [IMPORTANT]
1168      * ====
1169      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1170      *
1171      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1172      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1173      * constructor.
1174      * ====
1175      */
1176     function isContract(address account) internal view returns (bool) {
1177         // This method relies on extcodesize/address.code.length, which returns 0
1178         // for contracts in construction, since the code is only stored at the end
1179         // of the constructor execution.
1180 
1181         return account.code.length > 0;
1182     }
1183 
1184     /**
1185      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1186      * `recipient`, forwarding all available gas and reverting on errors.
1187      *
1188      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1189      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1190      * imposed by `transfer`, making them unable to receive funds via
1191      * `transfer`. {sendValue} removes this limitation.
1192      *
1193      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1194      *
1195      * IMPORTANT: because control is transferred to `recipient`, care must be
1196      * taken to not create reentrancy vulnerabilities. Consider using
1197      * {ReentrancyGuard} or the
1198      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1199      */
1200     function sendValue(address payable recipient, uint256 amount) internal {
1201         require(address(this).balance >= amount, "Address: insufficient balance");
1202 
1203         (bool success, ) = recipient.call{value: amount}("");
1204         require(success, "Address: unable to send value, recipient may have reverted");
1205     }
1206 
1207     /**
1208      * @dev Performs a Solidity function call using a low level `call`. A
1209      * plain `call` is an unsafe replacement for a function call: use this
1210      * function instead.
1211      *
1212      * If `target` reverts with a revert reason, it is bubbled up by this
1213      * function (like regular Solidity function calls).
1214      *
1215      * Returns the raw returned data. To convert to the expected return value,
1216      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1217      *
1218      * Requirements:
1219      *
1220      * - `target` must be a contract.
1221      * - calling `target` with `data` must not revert.
1222      *
1223      * _Available since v3.1._
1224      */
1225     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1226         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1227     }
1228 
1229     /**
1230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1231      * `errorMessage` as a fallback revert reason when `target` reverts.
1232      *
1233      * _Available since v3.1._
1234      */
1235     function functionCall(
1236         address target,
1237         bytes memory data,
1238         string memory errorMessage
1239     ) internal returns (bytes memory) {
1240         return functionCallWithValue(target, data, 0, errorMessage);
1241     }
1242 
1243     /**
1244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1245      * but also transferring `value` wei to `target`.
1246      *
1247      * Requirements:
1248      *
1249      * - the calling contract must have an ETH balance of at least `value`.
1250      * - the called Solidity function must be `payable`.
1251      *
1252      * _Available since v3.1._
1253      */
1254     function functionCallWithValue(
1255         address target,
1256         bytes memory data,
1257         uint256 value
1258     ) internal returns (bytes memory) {
1259         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1260     }
1261 
1262     /**
1263      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1264      * with `errorMessage` as a fallback revert reason when `target` reverts.
1265      *
1266      * _Available since v3.1._
1267      */
1268     function functionCallWithValue(
1269         address target,
1270         bytes memory data,
1271         uint256 value,
1272         string memory errorMessage
1273     ) internal returns (bytes memory) {
1274         require(address(this).balance >= value, "Address: insufficient balance for call");
1275         (bool success, bytes memory returndata) = target.call{value: value}(data);
1276         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1277     }
1278 
1279     /**
1280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1281      * but performing a static call.
1282      *
1283      * _Available since v3.3._
1284      */
1285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1286         return functionStaticCall(target, data, "Address: low-level static call failed");
1287     }
1288 
1289     /**
1290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1291      * but performing a static call.
1292      *
1293      * _Available since v3.3._
1294      */
1295     function functionStaticCall(
1296         address target,
1297         bytes memory data,
1298         string memory errorMessage
1299     ) internal view returns (bytes memory) {
1300         (bool success, bytes memory returndata) = target.staticcall(data);
1301         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1302     }
1303 
1304     /**
1305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1306      * but performing a delegate call.
1307      *
1308      * _Available since v3.4._
1309      */
1310     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1311         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1312     }
1313 
1314     /**
1315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1316      * but performing a delegate call.
1317      *
1318      * _Available since v3.4._
1319      */
1320     function functionDelegateCall(
1321         address target,
1322         bytes memory data,
1323         string memory errorMessage
1324     ) internal returns (bytes memory) {
1325         (bool success, bytes memory returndata) = target.delegatecall(data);
1326         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1327     }
1328 
1329     /**
1330      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1331      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1332      *
1333      * _Available since v4.8._
1334      */
1335     function verifyCallResultFromTarget(
1336         address target,
1337         bool success,
1338         bytes memory returndata,
1339         string memory errorMessage
1340     ) internal view returns (bytes memory) {
1341         if (success) {
1342             if (returndata.length == 0) {
1343                 // only check isContract if the call was successful and the return data is empty
1344                 // otherwise we already know that it was a contract
1345                 require(isContract(target), "Address: call to non-contract");
1346             }
1347             return returndata;
1348         } else {
1349             _revert(returndata, errorMessage);
1350         }
1351     }
1352 
1353     /**
1354      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1355      * revert reason or using the provided one.
1356      *
1357      * _Available since v4.3._
1358      */
1359     function verifyCallResult(
1360         bool success,
1361         bytes memory returndata,
1362         string memory errorMessage
1363     ) internal pure returns (bytes memory) {
1364         if (success) {
1365             return returndata;
1366         } else {
1367             _revert(returndata, errorMessage);
1368         }
1369     }
1370 
1371     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1372         // Look for revert reason and bubble it up if present
1373         if (returndata.length > 0) {
1374             // The easiest way to bubble the revert reason is using memory via assembly
1375             /// @solidity memory-safe-assembly
1376             assembly {
1377                 let returndata_size := mload(returndata)
1378                 revert(add(32, returndata), returndata_size)
1379             }
1380         } else {
1381             revert(errorMessage);
1382         }
1383     }
1384 }
1385 
1386 
1387 // File contracts/interfaces/IVault.sol
1388 
1389 
1390 pragma solidity ^0.8.9;
1391 
1392 interface IVault {
1393     
1394     function withdrawERC721(address nft, address to, uint256 tokenId) external;
1395     
1396     function batchWithdrawERC721(address nft, address[] calldata to, uint256[] calldata tokenIds) external;
1397 }
1398 
1399 
1400 // File contracts/Escrow.sol
1401 
1402 
1403 pragma solidity ^0.8.9;
1404 
1405 
1406 
1407 
1408 
1409 contract Escrow is 
1410     Pausable,
1411     AccessControl,
1412     IERC721Receiver
1413 {
1414     using Address for address;
1415 
1416     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
1417 
1418     IERC721 public nft;
1419     IVault public vault;
1420 
1421     // user => tokenID
1422     mapping(address => uint256 ) public ledger;
1423 
1424     event Deposit(address indexed sender, address indexed from, uint256 tokenID);
1425     event Withdraw(address indexed sender, address indexed to, uint256 tokenID);
1426 
1427     modifier onlyNFT(address token) {
1428         require(token.isContract(), "Only CA");
1429         require(token == address(nft), "nonSupport");
1430         _;
1431     }
1432 
1433     modifier whenNotHold(address from) {
1434         require(ledger[from] == 0, "Already holding");
1435         _;
1436     }
1437 
1438     modifier onlyOwner(address from, uint256 tokenID) {
1439         _onlyOwner(from, tokenID);
1440         _;
1441     }
1442 
1443     function _onlyOwner(address from, uint256 tokenID) internal view {
1444         require(ledger[from] != 0 && ledger[from] == tokenID, "Only Owner");
1445     }
1446 
1447     constructor(
1448         address admin,
1449         address operator,
1450         IERC721 token
1451     ) {
1452         nft = token;
1453         _grantRole(DEFAULT_ADMIN_ROLE, admin);
1454         _grantRole(OPERATOR_ROLE, operator);
1455     }
1456 
1457     function updateVault(IVault pool) external onlyRole(OPERATOR_ROLE) {
1458         vault = pool;
1459     }
1460 
1461     function pause() public onlyRole(OPERATOR_ROLE) {
1462         _pause();
1463     }
1464 
1465     function unpause() public onlyRole(OPERATOR_ROLE) {
1466         _unpause();
1467     }
1468 
1469     function deposit(uint256 tokenID) external whenNotPaused() whenNotHold(msg.sender) {
1470         require(tokenID > 0, "tokenID can not be zero");
1471         recordLedger(msg.sender, tokenID);
1472         IERC721(nft).safeTransferFrom(msg.sender, address(vault), tokenID);
1473         emit Deposit(msg.sender, msg.sender, tokenID);
1474     }
1475 
1476     function withdraw(uint256 tokenID) external whenNotPaused() onlyOwner(msg.sender, tokenID) {
1477         recordLedger(msg.sender, 0);
1478         IVault(vault).withdrawERC721(address(nft), msg.sender, tokenID);
1479         emit Withdraw(msg.sender, msg.sender, tokenID);
1480     }
1481 
1482     function onERC721Received (
1483         address sender,
1484         address from,
1485         uint256 tokenID,
1486         bytes memory
1487     ) public virtual override whenNotPaused() onlyNFT(msg.sender) whenNotHold(from) returns (bytes4) {
1488         require(tokenID > 0, "tokenID can not be zero");
1489         recordLedger(from, tokenID);
1490         IERC721(nft).safeTransferFrom(address(this), address(vault), tokenID);
1491         emit Deposit(sender, from, tokenID);
1492         return this.onERC721Received.selector;
1493     }
1494 
1495     function recordLedger(address owner, uint256 tokenID) internal {
1496         ledger[owner] = tokenID;
1497     }
1498 
1499     function EmergencyWithdrawVault (
1500         address[] calldata to,
1501         uint256[] calldata tokenID
1502     ) onlyRole(DEFAULT_ADMIN_ROLE) external {
1503         
1504         require(tokenID.length == to.length, "Array length must equal. ");
1505 
1506         for( uint256 i = 0; i < tokenID.length; i++ ) {
1507             _onlyOwner(to[i], tokenID[i]);
1508             recordLedger(to[i], 0);
1509             emit Withdraw(msg.sender, to[i], tokenID[i]);
1510         }
1511 
1512         IVault(vault).batchWithdrawERC721(address(nft), to, tokenID);
1513     }
1514 
1515     function EmergencyWithdraw (
1516         address token,
1517         address to,
1518         uint256[] calldata tokenID
1519     ) onlyRole(DEFAULT_ADMIN_ROLE) external {
1520         for (uint256 i = 0; i < tokenID.length; i++) {
1521             IERC721(token).safeTransferFrom(address(this), to, tokenID[i]);
1522         }
1523     }
1524 }