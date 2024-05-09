1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.8.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev External interface of AccessControl declared to support ERC165 detection.
12  */
13 interface IAccessControl {
14     /**
15      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
16      *
17      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
18      * {RoleAdminChanged} not being emitted signaling this.
19      *
20      * _Available since v3.1._
21      */
22     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
23 
24     /**
25      * @dev Emitted when `account` is granted `role`.
26      *
27      * `sender` is the account that originated the contract call, an admin role
28      * bearer except when using {AccessControl-_setupRole}.
29      */
30     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
31 
32     /**
33      * @dev Emitted when `account` is revoked `role`.
34      *
35      * `sender` is the account that originated the contract call:
36      *   - if using `revokeRole`, it is the admin role bearer
37      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
38      */
39     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
40 
41     /**
42      * @dev Returns `true` if `account` has been granted `role`.
43      */
44     function hasRole(bytes32 role, address account) external view returns (bool);
45 
46     /**
47      * @dev Returns the admin role that controls `role`. See {grantRole} and
48      * {revokeRole}.
49      *
50      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
51      */
52     function getRoleAdmin(bytes32 role) external view returns (bytes32);
53 
54     /**
55      * @dev Grants `role` to `account`.
56      *
57      * If `account` had not been already granted `role`, emits a {RoleGranted}
58      * event.
59      *
60      * Requirements:
61      *
62      * - the caller must have ``role``'s admin role.
63      */
64     function grantRole(bytes32 role, address account) external;
65 
66     /**
67      * @dev Revokes `role` from `account`.
68      *
69      * If `account` had been granted `role`, emits a {RoleRevoked} event.
70      *
71      * Requirements:
72      *
73      * - the caller must have ``role``'s admin role.
74      */
75     function revokeRole(bytes32 role, address account) external;
76 
77     /**
78      * @dev Revokes `role` from the calling account.
79      *
80      * Roles are often managed via {grantRole} and {revokeRole}: this function's
81      * purpose is to provide a mechanism for accounts to lose their privileges
82      * if they are compromised (such as when a trusted device is misplaced).
83      *
84      * If the calling account had been granted `role`, emits a {RoleRevoked}
85      * event.
86      *
87      * Requirements:
88      *
89      * - the caller must be `account`.
90      */
91     function renounceRole(bytes32 role, address account) external;
92 }
93 
94 
95 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Provides information about the current execution context, including the
103  * sender of the transaction and its data. While these are generally available
104  * via msg.sender and msg.data, they should not be accessed in such a direct
105  * manner, since when dealing with meta-transactions the account sending and
106  * paying for execution may not be the actual sender (as far as an application
107  * is concerned).
108  *
109  * This contract is only required for intermediate, library-like contracts.
110  */
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 
122 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Interface of the ERC165 standard, as defined in the
130  * https://eips.ethereum.org/EIPS/eip-165[EIP].
131  *
132  * Implementers can declare support of contract interfaces, which can then be
133  * queried by others ({ERC165Checker}).
134  *
135  * For an implementation, see {ERC165}.
136  */
137 interface IERC165 {
138     /**
139      * @dev Returns true if this contract implements the interface defined by
140      * `interfaceId`. See the corresponding
141      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
142      * to learn more about how these ids are created.
143      *
144      * This function call must use less than 30 000 gas.
145      */
146     function supportsInterface(bytes4 interfaceId) external view returns (bool);
147 }
148 
149 
150 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
151 
152 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Implementation of the {IERC165} interface.
158  *
159  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
160  * for the additional interface id that will be supported. For example:
161  *
162  * ```solidity
163  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
164  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
165  * }
166  * ```
167  *
168  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
169  */
170 abstract contract ERC165 is IERC165 {
171     /**
172      * @dev See {IERC165-supportsInterface}.
173      */
174     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
175         return interfaceId == type(IERC165).interfaceId;
176     }
177 }
178 
179 
180 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
181 
182 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Standard math utilities missing in the Solidity language.
188  */
189 library Math {
190     enum Rounding {
191         Down, // Toward negative infinity
192         Up, // Toward infinity
193         Zero // Toward zero
194     }
195 
196     /**
197      * @dev Returns the largest of two numbers.
198      */
199     function max(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a > b ? a : b;
201     }
202 
203     /**
204      * @dev Returns the smallest of two numbers.
205      */
206     function min(uint256 a, uint256 b) internal pure returns (uint256) {
207         return a < b ? a : b;
208     }
209 
210     /**
211      * @dev Returns the average of two numbers. The result is rounded towards
212      * zero.
213      */
214     function average(uint256 a, uint256 b) internal pure returns (uint256) {
215         // (a + b) / 2 can overflow.
216         return (a & b) + (a ^ b) / 2;
217     }
218 
219     /**
220      * @dev Returns the ceiling of the division of two numbers.
221      *
222      * This differs from standard division with `/` in that it rounds up instead
223      * of rounding down.
224      */
225     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
226         // (a + b - 1) / b can overflow on addition, so we distribute.
227         return a == 0 ? 0 : (a - 1) / b + 1;
228     }
229 
230     /**
231      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
232      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
233      * with further edits by Uniswap Labs also under MIT license.
234      */
235     function mulDiv(
236         uint256 x,
237         uint256 y,
238         uint256 denominator
239     ) internal pure returns (uint256 result) {
240         unchecked {
241             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
242             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
243             // variables such that product = prod1 * 2^256 + prod0.
244             uint256 prod0; // Least significant 256 bits of the product
245             uint256 prod1; // Most significant 256 bits of the product
246             assembly {
247                 let mm := mulmod(x, y, not(0))
248                 prod0 := mul(x, y)
249                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
250             }
251 
252             // Handle non-overflow cases, 256 by 256 division.
253             if (prod1 == 0) {
254                 return prod0 / denominator;
255             }
256 
257             // Make sure the result is less than 2^256. Also prevents denominator == 0.
258             require(denominator > prod1);
259 
260             ///////////////////////////////////////////////
261             // 512 by 256 division.
262             ///////////////////////////////////////////////
263 
264             // Make division exact by subtracting the remainder from [prod1 prod0].
265             uint256 remainder;
266             assembly {
267                 // Compute remainder using mulmod.
268                 remainder := mulmod(x, y, denominator)
269 
270                 // Subtract 256 bit number from 512 bit number.
271                 prod1 := sub(prod1, gt(remainder, prod0))
272                 prod0 := sub(prod0, remainder)
273             }
274 
275             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
276             // See https://cs.stackexchange.com/q/138556/92363.
277 
278             // Does not overflow because the denominator cannot be zero at this stage in the function.
279             uint256 twos = denominator & (~denominator + 1);
280             assembly {
281                 // Divide denominator by twos.
282                 denominator := div(denominator, twos)
283 
284                 // Divide [prod1 prod0] by twos.
285                 prod0 := div(prod0, twos)
286 
287                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
288                 twos := add(div(sub(0, twos), twos), 1)
289             }
290 
291             // Shift in bits from prod1 into prod0.
292             prod0 |= prod1 * twos;
293 
294             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
295             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
296             // four bits. That is, denominator * inv = 1 mod 2^4.
297             uint256 inverse = (3 * denominator) ^ 2;
298 
299             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
300             // in modular arithmetic, doubling the correct bits in each step.
301             inverse *= 2 - denominator * inverse; // inverse mod 2^8
302             inverse *= 2 - denominator * inverse; // inverse mod 2^16
303             inverse *= 2 - denominator * inverse; // inverse mod 2^32
304             inverse *= 2 - denominator * inverse; // inverse mod 2^64
305             inverse *= 2 - denominator * inverse; // inverse mod 2^128
306             inverse *= 2 - denominator * inverse; // inverse mod 2^256
307 
308             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
309             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
310             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
311             // is no longer required.
312             result = prod0 * inverse;
313             return result;
314         }
315     }
316 
317     /**
318      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
319      */
320     function mulDiv(
321         uint256 x,
322         uint256 y,
323         uint256 denominator,
324         Rounding rounding
325     ) internal pure returns (uint256) {
326         uint256 result = mulDiv(x, y, denominator);
327         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
328             result += 1;
329         }
330         return result;
331     }
332 
333     /**
334      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
335      *
336      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
337      */
338     function sqrt(uint256 a) internal pure returns (uint256) {
339         if (a == 0) {
340             return 0;
341         }
342 
343         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
344         //
345         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
346         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
347         //
348         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
349         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
350         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
351         //
352         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
353         uint256 result = 1 << (log2(a) >> 1);
354 
355         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
356         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
357         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
358         // into the expected uint128 result.
359         unchecked {
360             result = (result + a / result) >> 1;
361             result = (result + a / result) >> 1;
362             result = (result + a / result) >> 1;
363             result = (result + a / result) >> 1;
364             result = (result + a / result) >> 1;
365             result = (result + a / result) >> 1;
366             result = (result + a / result) >> 1;
367             return min(result, a / result);
368         }
369     }
370 
371     /**
372      * @notice Calculates sqrt(a), following the selected rounding direction.
373      */
374     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
375         unchecked {
376             uint256 result = sqrt(a);
377             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
378         }
379     }
380 
381     /**
382      * @dev Return the log in base 2, rounded down, of a positive value.
383      * Returns 0 if given 0.
384      */
385     function log2(uint256 value) internal pure returns (uint256) {
386         uint256 result = 0;
387         unchecked {
388             if (value >> 128 > 0) {
389                 value >>= 128;
390                 result += 128;
391             }
392             if (value >> 64 > 0) {
393                 value >>= 64;
394                 result += 64;
395             }
396             if (value >> 32 > 0) {
397                 value >>= 32;
398                 result += 32;
399             }
400             if (value >> 16 > 0) {
401                 value >>= 16;
402                 result += 16;
403             }
404             if (value >> 8 > 0) {
405                 value >>= 8;
406                 result += 8;
407             }
408             if (value >> 4 > 0) {
409                 value >>= 4;
410                 result += 4;
411             }
412             if (value >> 2 > 0) {
413                 value >>= 2;
414                 result += 2;
415             }
416             if (value >> 1 > 0) {
417                 result += 1;
418             }
419         }
420         return result;
421     }
422 
423     /**
424      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
425      * Returns 0 if given 0.
426      */
427     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
428         unchecked {
429             uint256 result = log2(value);
430             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
431         }
432     }
433 
434     /**
435      * @dev Return the log in base 10, rounded down, of a positive value.
436      * Returns 0 if given 0.
437      */
438     function log10(uint256 value) internal pure returns (uint256) {
439         uint256 result = 0;
440         unchecked {
441             if (value >= 10**64) {
442                 value /= 10**64;
443                 result += 64;
444             }
445             if (value >= 10**32) {
446                 value /= 10**32;
447                 result += 32;
448             }
449             if (value >= 10**16) {
450                 value /= 10**16;
451                 result += 16;
452             }
453             if (value >= 10**8) {
454                 value /= 10**8;
455                 result += 8;
456             }
457             if (value >= 10**4) {
458                 value /= 10**4;
459                 result += 4;
460             }
461             if (value >= 10**2) {
462                 value /= 10**2;
463                 result += 2;
464             }
465             if (value >= 10**1) {
466                 result += 1;
467             }
468         }
469         return result;
470     }
471 
472     /**
473      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
474      * Returns 0 if given 0.
475      */
476     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
477         unchecked {
478             uint256 result = log10(value);
479             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
480         }
481     }
482 
483     /**
484      * @dev Return the log in base 256, rounded down, of a positive value.
485      * Returns 0 if given 0.
486      *
487      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
488      */
489     function log256(uint256 value) internal pure returns (uint256) {
490         uint256 result = 0;
491         unchecked {
492             if (value >> 128 > 0) {
493                 value >>= 128;
494                 result += 16;
495             }
496             if (value >> 64 > 0) {
497                 value >>= 64;
498                 result += 8;
499             }
500             if (value >> 32 > 0) {
501                 value >>= 32;
502                 result += 4;
503             }
504             if (value >> 16 > 0) {
505                 value >>= 16;
506                 result += 2;
507             }
508             if (value >> 8 > 0) {
509                 result += 1;
510             }
511         }
512         return result;
513     }
514 
515     /**
516      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
517      * Returns 0 if given 0.
518      */
519     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
520         unchecked {
521             uint256 result = log256(value);
522             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
523         }
524     }
525 }
526 
527 
528 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
529 
530 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev String operations.
536  */
537 library Strings {
538     bytes16 private constant _SYMBOLS = "0123456789abcdef";
539     uint8 private constant _ADDRESS_LENGTH = 20;
540 
541     /**
542      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
543      */
544     function toString(uint256 value) internal pure returns (string memory) {
545         unchecked {
546             uint256 length = Math.log10(value) + 1;
547             string memory buffer = new string(length);
548             uint256 ptr;
549             /// @solidity memory-safe-assembly
550             assembly {
551                 ptr := add(buffer, add(32, length))
552             }
553             while (true) {
554                 ptr--;
555                 /// @solidity memory-safe-assembly
556                 assembly {
557                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
558                 }
559                 value /= 10;
560                 if (value == 0) break;
561             }
562             return buffer;
563         }
564     }
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
568      */
569     function toHexString(uint256 value) internal pure returns (string memory) {
570         unchecked {
571             return toHexString(value, Math.log256(value) + 1);
572         }
573     }
574 
575     /**
576      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
577      */
578     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
579         bytes memory buffer = new bytes(2 * length + 2);
580         buffer[0] = "0";
581         buffer[1] = "x";
582         for (uint256 i = 2 * length + 1; i > 1; --i) {
583             buffer[i] = _SYMBOLS[value & 0xf];
584             value >>= 4;
585         }
586         require(value == 0, "Strings: hex length insufficient");
587         return string(buffer);
588     }
589 
590     /**
591      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
592      */
593     function toHexString(address addr) internal pure returns (string memory) {
594         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
595     }
596 }
597 
598 
599 // File @openzeppelin/contracts/access/AccessControl.sol@v4.8.0
600 
601 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 
607 
608 /**
609  * @dev Contract module that allows children to implement role-based access
610  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
611  * members except through off-chain means by accessing the contract event logs. Some
612  * applications may benefit from on-chain enumerability, for those cases see
613  * {AccessControlEnumerable}.
614  *
615  * Roles are referred to by their `bytes32` identifier. These should be exposed
616  * in the external API and be unique. The best way to achieve this is by
617  * using `public constant` hash digests:
618  *
619  * ```
620  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
621  * ```
622  *
623  * Roles can be used to represent a set of permissions. To restrict access to a
624  * function call, use {hasRole}:
625  *
626  * ```
627  * function foo() public {
628  *     require(hasRole(MY_ROLE, msg.sender));
629  *     ...
630  * }
631  * ```
632  *
633  * Roles can be granted and revoked dynamically via the {grantRole} and
634  * {revokeRole} functions. Each role has an associated admin role, and only
635  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
636  *
637  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
638  * that only accounts with this role will be able to grant or revoke other
639  * roles. More complex role relationships can be created by using
640  * {_setRoleAdmin}.
641  *
642  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
643  * grant and revoke this role. Extra precautions should be taken to secure
644  * accounts that have been granted it.
645  */
646 abstract contract AccessControl is Context, IAccessControl, ERC165 {
647     struct RoleData {
648         mapping(address => bool) members;
649         bytes32 adminRole;
650     }
651 
652     mapping(bytes32 => RoleData) private _roles;
653 
654     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
655 
656     /**
657      * @dev Modifier that checks that an account has a specific role. Reverts
658      * with a standardized message including the required role.
659      *
660      * The format of the revert reason is given by the following regular expression:
661      *
662      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
663      *
664      * _Available since v4.1._
665      */
666     modifier onlyRole(bytes32 role) {
667         _checkRole(role);
668         _;
669     }
670 
671     /**
672      * @dev See {IERC165-supportsInterface}.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
676     }
677 
678     /**
679      * @dev Returns `true` if `account` has been granted `role`.
680      */
681     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
682         return _roles[role].members[account];
683     }
684 
685     /**
686      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
687      * Overriding this function changes the behavior of the {onlyRole} modifier.
688      *
689      * Format of the revert message is described in {_checkRole}.
690      *
691      * _Available since v4.6._
692      */
693     function _checkRole(bytes32 role) internal view virtual {
694         _checkRole(role, _msgSender());
695     }
696 
697     /**
698      * @dev Revert with a standard message if `account` is missing `role`.
699      *
700      * The format of the revert reason is given by the following regular expression:
701      *
702      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
703      */
704     function _checkRole(bytes32 role, address account) internal view virtual {
705         if (!hasRole(role, account)) {
706             revert(
707                 string(
708                     abi.encodePacked(
709                         "AccessControl: account ",
710                         Strings.toHexString(account),
711                         " is missing role ",
712                         Strings.toHexString(uint256(role), 32)
713                     )
714                 )
715             );
716         }
717     }
718 
719     /**
720      * @dev Returns the admin role that controls `role`. See {grantRole} and
721      * {revokeRole}.
722      *
723      * To change a role's admin, use {_setRoleAdmin}.
724      */
725     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
726         return _roles[role].adminRole;
727     }
728 
729     /**
730      * @dev Grants `role` to `account`.
731      *
732      * If `account` had not been already granted `role`, emits a {RoleGranted}
733      * event.
734      *
735      * Requirements:
736      *
737      * - the caller must have ``role``'s admin role.
738      *
739      * May emit a {RoleGranted} event.
740      */
741     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
742         _grantRole(role, account);
743     }
744 
745     /**
746      * @dev Revokes `role` from `account`.
747      *
748      * If `account` had been granted `role`, emits a {RoleRevoked} event.
749      *
750      * Requirements:
751      *
752      * - the caller must have ``role``'s admin role.
753      *
754      * May emit a {RoleRevoked} event.
755      */
756     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
757         _revokeRole(role, account);
758     }
759 
760     /**
761      * @dev Revokes `role` from the calling account.
762      *
763      * Roles are often managed via {grantRole} and {revokeRole}: this function's
764      * purpose is to provide a mechanism for accounts to lose their privileges
765      * if they are compromised (such as when a trusted device is misplaced).
766      *
767      * If the calling account had been revoked `role`, emits a {RoleRevoked}
768      * event.
769      *
770      * Requirements:
771      *
772      * - the caller must be `account`.
773      *
774      * May emit a {RoleRevoked} event.
775      */
776     function renounceRole(bytes32 role, address account) public virtual override {
777         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
778 
779         _revokeRole(role, account);
780     }
781 
782     /**
783      * @dev Grants `role` to `account`.
784      *
785      * If `account` had not been already granted `role`, emits a {RoleGranted}
786      * event. Note that unlike {grantRole}, this function doesn't perform any
787      * checks on the calling account.
788      *
789      * May emit a {RoleGranted} event.
790      *
791      * [WARNING]
792      * ====
793      * This function should only be called from the constructor when setting
794      * up the initial roles for the system.
795      *
796      * Using this function in any other way is effectively circumventing the admin
797      * system imposed by {AccessControl}.
798      * ====
799      *
800      * NOTE: This function is deprecated in favor of {_grantRole}.
801      */
802     function _setupRole(bytes32 role, address account) internal virtual {
803         _grantRole(role, account);
804     }
805 
806     /**
807      * @dev Sets `adminRole` as ``role``'s admin role.
808      *
809      * Emits a {RoleAdminChanged} event.
810      */
811     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
812         bytes32 previousAdminRole = getRoleAdmin(role);
813         _roles[role].adminRole = adminRole;
814         emit RoleAdminChanged(role, previousAdminRole, adminRole);
815     }
816 
817     /**
818      * @dev Grants `role` to `account`.
819      *
820      * Internal function without access restriction.
821      *
822      * May emit a {RoleGranted} event.
823      */
824     function _grantRole(bytes32 role, address account) internal virtual {
825         if (!hasRole(role, account)) {
826             _roles[role].members[account] = true;
827             emit RoleGranted(role, account, _msgSender());
828         }
829     }
830 
831     /**
832      * @dev Revokes `role` from `account`.
833      *
834      * Internal function without access restriction.
835      *
836      * May emit a {RoleRevoked} event.
837      */
838     function _revokeRole(bytes32 role, address account) internal virtual {
839         if (hasRole(role, account)) {
840             _roles[role].members[account] = false;
841             emit RoleRevoked(role, account, _msgSender());
842         }
843     }
844 }
845 
846 
847 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.0
848 
849 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @dev Interface of the ERC20 standard as defined in the EIP.
855  */
856 interface IERC20 {
857     /**
858      * @dev Emitted when `value` tokens are moved from one account (`from`) to
859      * another (`to`).
860      *
861      * Note that `value` may be zero.
862      */
863     event Transfer(address indexed from, address indexed to, uint256 value);
864 
865     /**
866      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
867      * a call to {approve}. `value` is the new allowance.
868      */
869     event Approval(address indexed owner, address indexed spender, uint256 value);
870 
871     /**
872      * @dev Returns the amount of tokens in existence.
873      */
874     function totalSupply() external view returns (uint256);
875 
876     /**
877      * @dev Returns the amount of tokens owned by `account`.
878      */
879     function balanceOf(address account) external view returns (uint256);
880 
881     /**
882      * @dev Moves `amount` tokens from the caller's account to `to`.
883      *
884      * Returns a boolean value indicating whether the operation succeeded.
885      *
886      * Emits a {Transfer} event.
887      */
888     function transfer(address to, uint256 amount) external returns (bool);
889 
890     /**
891      * @dev Returns the remaining number of tokens that `spender` will be
892      * allowed to spend on behalf of `owner` through {transferFrom}. This is
893      * zero by default.
894      *
895      * This value changes when {approve} or {transferFrom} are called.
896      */
897     function allowance(address owner, address spender) external view returns (uint256);
898 
899     /**
900      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
901      *
902      * Returns a boolean value indicating whether the operation succeeded.
903      *
904      * IMPORTANT: Beware that changing an allowance with this method brings the risk
905      * that someone may use both the old and the new allowance by unfortunate
906      * transaction ordering. One possible solution to mitigate this race
907      * condition is to first reduce the spender's allowance to 0 and set the
908      * desired value afterwards:
909      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
910      *
911      * Emits an {Approval} event.
912      */
913     function approve(address spender, uint256 amount) external returns (bool);
914 
915     /**
916      * @dev Moves `amount` tokens from `from` to `to` using the
917      * allowance mechanism. `amount` is then deducted from the caller's
918      * allowance.
919      *
920      * Returns a boolean value indicating whether the operation succeeded.
921      *
922      * Emits a {Transfer} event.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 amount
928     ) external returns (bool);
929 }
930 
931 
932 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.0
933 
934 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 /**
939  * @dev Interface for the optional metadata functions from the ERC20 standard.
940  *
941  * _Available since v4.1._
942  */
943 interface IERC20Metadata is IERC20 {
944     /**
945      * @dev Returns the name of the token.
946      */
947     function name() external view returns (string memory);
948 
949     /**
950      * @dev Returns the symbol of the token.
951      */
952     function symbol() external view returns (string memory);
953 
954     /**
955      * @dev Returns the decimals places of the token.
956      */
957     function decimals() external view returns (uint8);
958 }
959 
960 
961 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.0
962 
963 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 
968 
969 /**
970  * @dev Implementation of the {IERC20} interface.
971  *
972  * This implementation is agnostic to the way tokens are created. This means
973  * that a supply mechanism has to be added in a derived contract using {_mint}.
974  * For a generic mechanism see {ERC20PresetMinterPauser}.
975  *
976  * TIP: For a detailed writeup see our guide
977  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
978  * to implement supply mechanisms].
979  *
980  * We have followed general OpenZeppelin Contracts guidelines: functions revert
981  * instead returning `false` on failure. This behavior is nonetheless
982  * conventional and does not conflict with the expectations of ERC20
983  * applications.
984  *
985  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
986  * This allows applications to reconstruct the allowance for all accounts just
987  * by listening to said events. Other implementations of the EIP may not emit
988  * these events, as it isn't required by the specification.
989  *
990  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
991  * functions have been added to mitigate the well-known issues around setting
992  * allowances. See {IERC20-approve}.
993  */
994 contract ERC20 is Context, IERC20, IERC20Metadata {
995     mapping(address => uint256) private _balances;
996 
997     mapping(address => mapping(address => uint256)) private _allowances;
998 
999     uint256 private _totalSupply;
1000 
1001     string private _name;
1002     string private _symbol;
1003 
1004     /**
1005      * @dev Sets the values for {name} and {symbol}.
1006      *
1007      * The default value of {decimals} is 18. To select a different value for
1008      * {decimals} you should overload it.
1009      *
1010      * All two of these values are immutable: they can only be set once during
1011      * construction.
1012      */
1013     constructor(string memory name_, string memory symbol_) {
1014         _name = name_;
1015         _symbol = symbol_;
1016     }
1017 
1018     /**
1019      * @dev Returns the name of the token.
1020      */
1021     function name() public view virtual override returns (string memory) {
1022         return _name;
1023     }
1024 
1025     /**
1026      * @dev Returns the symbol of the token, usually a shorter version of the
1027      * name.
1028      */
1029     function symbol() public view virtual override returns (string memory) {
1030         return _symbol;
1031     }
1032 
1033     /**
1034      * @dev Returns the number of decimals used to get its user representation.
1035      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1036      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1037      *
1038      * Tokens usually opt for a value of 18, imitating the relationship between
1039      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1040      * overridden;
1041      *
1042      * NOTE: This information is only used for _display_ purposes: it in
1043      * no way affects any of the arithmetic of the contract, including
1044      * {IERC20-balanceOf} and {IERC20-transfer}.
1045      */
1046     function decimals() public view virtual override returns (uint8) {
1047         return 18;
1048     }
1049 
1050     /**
1051      * @dev See {IERC20-totalSupply}.
1052      */
1053     function totalSupply() public view virtual override returns (uint256) {
1054         return _totalSupply;
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-balanceOf}.
1059      */
1060     function balanceOf(address account) public view virtual override returns (uint256) {
1061         return _balances[account];
1062     }
1063 
1064     /**
1065      * @dev See {IERC20-transfer}.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - the caller must have a balance of at least `amount`.
1071      */
1072     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1073         address owner = _msgSender();
1074         _transfer(owner, to, amount);
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev See {IERC20-allowance}.
1080      */
1081     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1082         return _allowances[owner][spender];
1083     }
1084 
1085     /**
1086      * @dev See {IERC20-approve}.
1087      *
1088      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1089      * `transferFrom`. This is semantically equivalent to an infinite approval.
1090      *
1091      * Requirements:
1092      *
1093      * - `spender` cannot be the zero address.
1094      */
1095     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1096         address owner = _msgSender();
1097         _approve(owner, spender, amount);
1098         return true;
1099     }
1100 
1101     /**
1102      * @dev See {IERC20-transferFrom}.
1103      *
1104      * Emits an {Approval} event indicating the updated allowance. This is not
1105      * required by the EIP. See the note at the beginning of {ERC20}.
1106      *
1107      * NOTE: Does not update the allowance if the current allowance
1108      * is the maximum `uint256`.
1109      *
1110      * Requirements:
1111      *
1112      * - `from` and `to` cannot be the zero address.
1113      * - `from` must have a balance of at least `amount`.
1114      * - the caller must have allowance for ``from``'s tokens of at least
1115      * `amount`.
1116      */
1117     function transferFrom(
1118         address from,
1119         address to,
1120         uint256 amount
1121     ) public virtual override returns (bool) {
1122         address spender = _msgSender();
1123         _spendAllowance(from, spender, amount);
1124         _transfer(from, to, amount);
1125         return true;
1126     }
1127 
1128     /**
1129      * @dev Atomically increases the allowance granted to `spender` by the caller.
1130      *
1131      * This is an alternative to {approve} that can be used as a mitigation for
1132      * problems described in {IERC20-approve}.
1133      *
1134      * Emits an {Approval} event indicating the updated allowance.
1135      *
1136      * Requirements:
1137      *
1138      * - `spender` cannot be the zero address.
1139      */
1140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1141         address owner = _msgSender();
1142         _approve(owner, spender, allowance(owner, spender) + addedValue);
1143         return true;
1144     }
1145 
1146     /**
1147      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1148      *
1149      * This is an alternative to {approve} that can be used as a mitigation for
1150      * problems described in {IERC20-approve}.
1151      *
1152      * Emits an {Approval} event indicating the updated allowance.
1153      *
1154      * Requirements:
1155      *
1156      * - `spender` cannot be the zero address.
1157      * - `spender` must have allowance for the caller of at least
1158      * `subtractedValue`.
1159      */
1160     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1161         address owner = _msgSender();
1162         uint256 currentAllowance = allowance(owner, spender);
1163         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1164         unchecked {
1165             _approve(owner, spender, currentAllowance - subtractedValue);
1166         }
1167 
1168         return true;
1169     }
1170 
1171     /**
1172      * @dev Moves `amount` of tokens from `from` to `to`.
1173      *
1174      * This internal function is equivalent to {transfer}, and can be used to
1175      * e.g. implement automatic token fees, slashing mechanisms, etc.
1176      *
1177      * Emits a {Transfer} event.
1178      *
1179      * Requirements:
1180      *
1181      * - `from` cannot be the zero address.
1182      * - `to` cannot be the zero address.
1183      * - `from` must have a balance of at least `amount`.
1184      */
1185     function _transfer(
1186         address from,
1187         address to,
1188         uint256 amount
1189     ) internal virtual {
1190         require(from != address(0), "ERC20: transfer from the zero address");
1191         require(to != address(0), "ERC20: transfer to the zero address");
1192 
1193         _beforeTokenTransfer(from, to, amount);
1194 
1195         uint256 fromBalance = _balances[from];
1196         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1197         unchecked {
1198             _balances[from] = fromBalance - amount;
1199             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1200             // decrementing then incrementing.
1201             _balances[to] += amount;
1202         }
1203 
1204         emit Transfer(from, to, amount);
1205 
1206         _afterTokenTransfer(from, to, amount);
1207     }
1208 
1209     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1210      * the total supply.
1211      *
1212      * Emits a {Transfer} event with `from` set to the zero address.
1213      *
1214      * Requirements:
1215      *
1216      * - `account` cannot be the zero address.
1217      */
1218     function _mint(address account, uint256 amount) internal virtual {
1219         require(account != address(0), "ERC20: mint to the zero address");
1220 
1221         _beforeTokenTransfer(address(0), account, amount);
1222 
1223         _totalSupply += amount;
1224         unchecked {
1225             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1226             _balances[account] += amount;
1227         }
1228         emit Transfer(address(0), account, amount);
1229 
1230         _afterTokenTransfer(address(0), account, amount);
1231     }
1232 
1233     /**
1234      * @dev Destroys `amount` tokens from `account`, reducing the
1235      * total supply.
1236      *
1237      * Emits a {Transfer} event with `to` set to the zero address.
1238      *
1239      * Requirements:
1240      *
1241      * - `account` cannot be the zero address.
1242      * - `account` must have at least `amount` tokens.
1243      */
1244     function _burn(address account, uint256 amount) internal virtual {
1245         require(account != address(0), "ERC20: burn from the zero address");
1246 
1247         _beforeTokenTransfer(account, address(0), amount);
1248 
1249         uint256 accountBalance = _balances[account];
1250         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1251         unchecked {
1252             _balances[account] = accountBalance - amount;
1253             // Overflow not possible: amount <= accountBalance <= totalSupply.
1254             _totalSupply -= amount;
1255         }
1256 
1257         emit Transfer(account, address(0), amount);
1258 
1259         _afterTokenTransfer(account, address(0), amount);
1260     }
1261 
1262     /**
1263      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1264      *
1265      * This internal function is equivalent to `approve`, and can be used to
1266      * e.g. set automatic allowances for certain subsystems, etc.
1267      *
1268      * Emits an {Approval} event.
1269      *
1270      * Requirements:
1271      *
1272      * - `owner` cannot be the zero address.
1273      * - `spender` cannot be the zero address.
1274      */
1275     function _approve(
1276         address owner,
1277         address spender,
1278         uint256 amount
1279     ) internal virtual {
1280         require(owner != address(0), "ERC20: approve from the zero address");
1281         require(spender != address(0), "ERC20: approve to the zero address");
1282 
1283         _allowances[owner][spender] = amount;
1284         emit Approval(owner, spender, amount);
1285     }
1286 
1287     /**
1288      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1289      *
1290      * Does not update the allowance amount in case of infinite allowance.
1291      * Revert if not enough allowance is available.
1292      *
1293      * Might emit an {Approval} event.
1294      */
1295     function _spendAllowance(
1296         address owner,
1297         address spender,
1298         uint256 amount
1299     ) internal virtual {
1300         uint256 currentAllowance = allowance(owner, spender);
1301         if (currentAllowance != type(uint256).max) {
1302             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1303             unchecked {
1304                 _approve(owner, spender, currentAllowance - amount);
1305             }
1306         }
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before any transfer of tokens. This includes
1311      * minting and burning.
1312      *
1313      * Calling conditions:
1314      *
1315      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1316      * will be transferred to `to`.
1317      * - when `from` is zero, `amount` tokens will be minted for `to`.
1318      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1319      * - `from` and `to` are never both zero.
1320      *
1321      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1322      */
1323     function _beforeTokenTransfer(
1324         address from,
1325         address to,
1326         uint256 amount
1327     ) internal virtual {}
1328 
1329     /**
1330      * @dev Hook that is called after any transfer of tokens. This includes
1331      * minting and burning.
1332      *
1333      * Calling conditions:
1334      *
1335      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1336      * has been transferred to `to`.
1337      * - when `from` is zero, `amount` tokens have been minted for `to`.
1338      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1339      * - `from` and `to` are never both zero.
1340      *
1341      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1342      */
1343     function _afterTokenTransfer(
1344         address from,
1345         address to,
1346         uint256 amount
1347     ) internal virtual {}
1348 }
1349 
1350 
1351 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.8.0
1352 
1353 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1354 
1355 pragma solidity ^0.8.0;
1356 
1357 /**
1358  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1359  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1360  *
1361  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1362  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1363  * need to send a transaction, and thus is not required to hold Ether at all.
1364  */
1365 interface IERC20Permit {
1366     /**
1367      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1368      * given ``owner``'s signed approval.
1369      *
1370      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1371      * ordering also apply here.
1372      *
1373      * Emits an {Approval} event.
1374      *
1375      * Requirements:
1376      *
1377      * - `spender` cannot be the zero address.
1378      * - `deadline` must be a timestamp in the future.
1379      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1380      * over the EIP712-formatted function arguments.
1381      * - the signature must use ``owner``'s current nonce (see {nonces}).
1382      *
1383      * For more information on the signature format, see the
1384      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1385      * section].
1386      */
1387     function permit(
1388         address owner,
1389         address spender,
1390         uint256 value,
1391         uint256 deadline,
1392         uint8 v,
1393         bytes32 r,
1394         bytes32 s
1395     ) external;
1396 
1397     /**
1398      * @dev Returns the current nonce for `owner`. This value must be
1399      * included whenever a signature is generated for {permit}.
1400      *
1401      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1402      * prevents a signature from being used multiple times.
1403      */
1404     function nonces(address owner) external view returns (uint256);
1405 
1406     /**
1407      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1408      */
1409     // solhint-disable-next-line func-name-mixedcase
1410     function DOMAIN_SEPARATOR() external view returns (bytes32);
1411 }
1412 
1413 
1414 // File @openzeppelin/contracts/utils/Counters.sol@v4.8.0
1415 
1416 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1417 
1418 pragma solidity ^0.8.0;
1419 
1420 /**
1421  * @title Counters
1422  * @author Matt Condon (@shrugs)
1423  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1424  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1425  *
1426  * Include with `using Counters for Counters.Counter;`
1427  */
1428 library Counters {
1429     struct Counter {
1430         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1431         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1432         // this feature: see https://github.com/ethereum/solidity/issues/4637
1433         uint256 _value; // default: 0
1434     }
1435 
1436     function current(Counter storage counter) internal view returns (uint256) {
1437         return counter._value;
1438     }
1439 
1440     function increment(Counter storage counter) internal {
1441         unchecked {
1442             counter._value += 1;
1443         }
1444     }
1445 
1446     function decrement(Counter storage counter) internal {
1447         uint256 value = counter._value;
1448         require(value > 0, "Counter: decrement overflow");
1449         unchecked {
1450             counter._value = value - 1;
1451         }
1452     }
1453 
1454     function reset(Counter storage counter) internal {
1455         counter._value = 0;
1456     }
1457 }
1458 
1459 
1460 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.0
1461 
1462 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1463 
1464 pragma solidity ^0.8.0;
1465 
1466 /**
1467  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1468  *
1469  * These functions can be used to verify that a message was signed by the holder
1470  * of the private keys of a given address.
1471  */
1472 library ECDSA {
1473     enum RecoverError {
1474         NoError,
1475         InvalidSignature,
1476         InvalidSignatureLength,
1477         InvalidSignatureS,
1478         InvalidSignatureV // Deprecated in v4.8
1479     }
1480 
1481     function _throwError(RecoverError error) private pure {
1482         if (error == RecoverError.NoError) {
1483             return; // no error: do nothing
1484         } else if (error == RecoverError.InvalidSignature) {
1485             revert("ECDSA: invalid signature");
1486         } else if (error == RecoverError.InvalidSignatureLength) {
1487             revert("ECDSA: invalid signature length");
1488         } else if (error == RecoverError.InvalidSignatureS) {
1489             revert("ECDSA: invalid signature 's' value");
1490         }
1491     }
1492 
1493     /**
1494      * @dev Returns the address that signed a hashed message (`hash`) with
1495      * `signature` or error string. This address can then be used for verification purposes.
1496      *
1497      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1498      * this function rejects them by requiring the `s` value to be in the lower
1499      * half order, and the `v` value to be either 27 or 28.
1500      *
1501      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1502      * verification to be secure: it is possible to craft signatures that
1503      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1504      * this is by receiving a hash of the original message (which may otherwise
1505      * be too long), and then calling {toEthSignedMessageHash} on it.
1506      *
1507      * Documentation for signature generation:
1508      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1509      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1510      *
1511      * _Available since v4.3._
1512      */
1513     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1514         if (signature.length == 65) {
1515             bytes32 r;
1516             bytes32 s;
1517             uint8 v;
1518             // ecrecover takes the signature parameters, and the only way to get them
1519             // currently is to use assembly.
1520             /// @solidity memory-safe-assembly
1521             assembly {
1522                 r := mload(add(signature, 0x20))
1523                 s := mload(add(signature, 0x40))
1524                 v := byte(0, mload(add(signature, 0x60)))
1525             }
1526             return tryRecover(hash, v, r, s);
1527         } else {
1528             return (address(0), RecoverError.InvalidSignatureLength);
1529         }
1530     }
1531 
1532     /**
1533      * @dev Returns the address that signed a hashed message (`hash`) with
1534      * `signature`. This address can then be used for verification purposes.
1535      *
1536      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1537      * this function rejects them by requiring the `s` value to be in the lower
1538      * half order, and the `v` value to be either 27 or 28.
1539      *
1540      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1541      * verification to be secure: it is possible to craft signatures that
1542      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1543      * this is by receiving a hash of the original message (which may otherwise
1544      * be too long), and then calling {toEthSignedMessageHash} on it.
1545      */
1546     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1547         (address recovered, RecoverError error) = tryRecover(hash, signature);
1548         _throwError(error);
1549         return recovered;
1550     }
1551 
1552     /**
1553      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1554      *
1555      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1556      *
1557      * _Available since v4.3._
1558      */
1559     function tryRecover(
1560         bytes32 hash,
1561         bytes32 r,
1562         bytes32 vs
1563     ) internal pure returns (address, RecoverError) {
1564         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1565         uint8 v = uint8((uint256(vs) >> 255) + 27);
1566         return tryRecover(hash, v, r, s);
1567     }
1568 
1569     /**
1570      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1571      *
1572      * _Available since v4.2._
1573      */
1574     function recover(
1575         bytes32 hash,
1576         bytes32 r,
1577         bytes32 vs
1578     ) internal pure returns (address) {
1579         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1580         _throwError(error);
1581         return recovered;
1582     }
1583 
1584     /**
1585      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1586      * `r` and `s` signature fields separately.
1587      *
1588      * _Available since v4.3._
1589      */
1590     function tryRecover(
1591         bytes32 hash,
1592         uint8 v,
1593         bytes32 r,
1594         bytes32 s
1595     ) internal pure returns (address, RecoverError) {
1596         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1597         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1598         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1599         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1600         //
1601         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1602         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1603         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1604         // these malleable signatures as well.
1605         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1606             return (address(0), RecoverError.InvalidSignatureS);
1607         }
1608 
1609         // If the signature is valid (and not malleable), return the signer address
1610         address signer = ecrecover(hash, v, r, s);
1611         if (signer == address(0)) {
1612             return (address(0), RecoverError.InvalidSignature);
1613         }
1614 
1615         return (signer, RecoverError.NoError);
1616     }
1617 
1618     /**
1619      * @dev Overload of {ECDSA-recover} that receives the `v`,
1620      * `r` and `s` signature fields separately.
1621      */
1622     function recover(
1623         bytes32 hash,
1624         uint8 v,
1625         bytes32 r,
1626         bytes32 s
1627     ) internal pure returns (address) {
1628         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1629         _throwError(error);
1630         return recovered;
1631     }
1632 
1633     /**
1634      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1635      * produces hash corresponding to the one signed with the
1636      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1637      * JSON-RPC method as part of EIP-191.
1638      *
1639      * See {recover}.
1640      */
1641     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1642         // 32 is the length in bytes of hash,
1643         // enforced by the type signature above
1644         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1645     }
1646 
1647     /**
1648      * @dev Returns an Ethereum Signed Message, created from `s`. This
1649      * produces hash corresponding to the one signed with the
1650      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1651      * JSON-RPC method as part of EIP-191.
1652      *
1653      * See {recover}.
1654      */
1655     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1656         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1657     }
1658 
1659     /**
1660      * @dev Returns an Ethereum Signed Typed Data, created from a
1661      * `domainSeparator` and a `structHash`. This produces hash corresponding
1662      * to the one signed with the
1663      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1664      * JSON-RPC method as part of EIP-712.
1665      *
1666      * See {recover}.
1667      */
1668     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1669         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1670     }
1671 }
1672 
1673 
1674 // File @openzeppelin/contracts/utils/cryptography/EIP712.sol@v4.8.0
1675 
1676 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1677 
1678 pragma solidity ^0.8.0;
1679 
1680 /**
1681  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1682  *
1683  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1684  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1685  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1686  *
1687  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1688  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1689  * ({_hashTypedDataV4}).
1690  *
1691  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1692  * the chain id to protect against replay attacks on an eventual fork of the chain.
1693  *
1694  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1695  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1696  *
1697  * _Available since v3.4._
1698  */
1699 abstract contract EIP712 {
1700     /* solhint-disable var-name-mixedcase */
1701     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1702     // invalidate the cached domain separator if the chain id changes.
1703     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1704     uint256 private immutable _CACHED_CHAIN_ID;
1705     address private immutable _CACHED_THIS;
1706 
1707     bytes32 private immutable _HASHED_NAME;
1708     bytes32 private immutable _HASHED_VERSION;
1709     bytes32 private immutable _TYPE_HASH;
1710 
1711     /* solhint-enable var-name-mixedcase */
1712 
1713     /**
1714      * @dev Initializes the domain separator and parameter caches.
1715      *
1716      * The meaning of `name` and `version` is specified in
1717      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1718      *
1719      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1720      * - `version`: the current major version of the signing domain.
1721      *
1722      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1723      * contract upgrade].
1724      */
1725     constructor(string memory name, string memory version) {
1726         bytes32 hashedName = keccak256(bytes(name));
1727         bytes32 hashedVersion = keccak256(bytes(version));
1728         bytes32 typeHash = keccak256(
1729             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1730         );
1731         _HASHED_NAME = hashedName;
1732         _HASHED_VERSION = hashedVersion;
1733         _CACHED_CHAIN_ID = block.chainid;
1734         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1735         _CACHED_THIS = address(this);
1736         _TYPE_HASH = typeHash;
1737     }
1738 
1739     /**
1740      * @dev Returns the domain separator for the current chain.
1741      */
1742     function _domainSeparatorV4() internal view returns (bytes32) {
1743         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1744             return _CACHED_DOMAIN_SEPARATOR;
1745         } else {
1746             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1747         }
1748     }
1749 
1750     function _buildDomainSeparator(
1751         bytes32 typeHash,
1752         bytes32 nameHash,
1753         bytes32 versionHash
1754     ) private view returns (bytes32) {
1755         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1756     }
1757 
1758     /**
1759      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1760      * function returns the hash of the fully encoded EIP712 message for this domain.
1761      *
1762      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1763      *
1764      * ```solidity
1765      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1766      *     keccak256("Mail(address to,string contents)"),
1767      *     mailTo,
1768      *     keccak256(bytes(mailContents))
1769      * )));
1770      * address signer = ECDSA.recover(digest, signature);
1771      * ```
1772      */
1773     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1774         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1775     }
1776 }
1777 
1778 
1779 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.8.0
1780 
1781 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
1782 
1783 pragma solidity ^0.8.0;
1784 
1785 
1786 
1787 
1788 
1789 /**
1790  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1791  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1792  *
1793  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1794  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1795  * need to send a transaction, and thus is not required to hold Ether at all.
1796  *
1797  * _Available since v3.4._
1798  */
1799 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1800     using Counters for Counters.Counter;
1801 
1802     mapping(address => Counters.Counter) private _nonces;
1803 
1804     // solhint-disable-next-line var-name-mixedcase
1805     bytes32 private constant _PERMIT_TYPEHASH =
1806         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1807     /**
1808      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1809      * However, to ensure consistency with the upgradeable transpiler, we will continue
1810      * to reserve a slot.
1811      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1812      */
1813     // solhint-disable-next-line var-name-mixedcase
1814     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1815 
1816     /**
1817      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1818      *
1819      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1820      */
1821     constructor(string memory name) EIP712(name, "1") {}
1822 
1823     /**
1824      * @dev See {IERC20Permit-permit}.
1825      */
1826     function permit(
1827         address owner,
1828         address spender,
1829         uint256 value,
1830         uint256 deadline,
1831         uint8 v,
1832         bytes32 r,
1833         bytes32 s
1834     ) public virtual override {
1835         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1836 
1837         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1838 
1839         bytes32 hash = _hashTypedDataV4(structHash);
1840 
1841         address signer = ECDSA.recover(hash, v, r, s);
1842         require(signer == owner, "ERC20Permit: invalid signature");
1843 
1844         _approve(owner, spender, value);
1845     }
1846 
1847     /**
1848      * @dev See {IERC20Permit-nonces}.
1849      */
1850     function nonces(address owner) public view virtual override returns (uint256) {
1851         return _nonces[owner].current();
1852     }
1853 
1854     /**
1855      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1856      */
1857     // solhint-disable-next-line func-name-mixedcase
1858     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1859         return _domainSeparatorV4();
1860     }
1861 
1862     /**
1863      * @dev "Consume a nonce": return the current value and increment.
1864      *
1865      * _Available since v4.1._
1866      */
1867     function _useNonce(address owner) internal virtual returns (uint256 current) {
1868         Counters.Counter storage nonce = _nonces[owner];
1869         current = nonce.current();
1870         nonce.increment();
1871     }
1872 }
1873 
1874 
1875 // File @openzeppelin/contracts/governance/utils/IVotes.sol@v4.8.0
1876 
1877 // OpenZeppelin Contracts (last updated v4.5.0) (governance/utils/IVotes.sol)
1878 pragma solidity ^0.8.0;
1879 
1880 /**
1881  * @dev Common interface for {ERC20Votes}, {ERC721Votes}, and other {Votes}-enabled contracts.
1882  *
1883  * _Available since v4.5._
1884  */
1885 interface IVotes {
1886     /**
1887      * @dev Emitted when an account changes their delegate.
1888      */
1889     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1890 
1891     /**
1892      * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
1893      */
1894     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1895 
1896     /**
1897      * @dev Returns the current amount of votes that `account` has.
1898      */
1899     function getVotes(address account) external view returns (uint256);
1900 
1901     /**
1902      * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
1903      */
1904     function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
1905 
1906     /**
1907      * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
1908      *
1909      * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
1910      * Votes that have not been delegated are still part of total supply, even though they would not participate in a
1911      * vote.
1912      */
1913     function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
1914 
1915     /**
1916      * @dev Returns the delegate that `account` has chosen.
1917      */
1918     function delegates(address account) external view returns (address);
1919 
1920     /**
1921      * @dev Delegates votes from the sender to `delegatee`.
1922      */
1923     function delegate(address delegatee) external;
1924 
1925     /**
1926      * @dev Delegates votes from signer to `delegatee`.
1927      */
1928     function delegateBySig(
1929         address delegatee,
1930         uint256 nonce,
1931         uint256 expiry,
1932         uint8 v,
1933         bytes32 r,
1934         bytes32 s
1935     ) external;
1936 }
1937 
1938 
1939 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.8.0
1940 
1941 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCast.sol)
1942 // This file was procedurally generated from scripts/generate/templates/SafeCast.js.
1943 
1944 pragma solidity ^0.8.0;
1945 
1946 /**
1947  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1948  * checks.
1949  *
1950  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1951  * easily result in undesired exploitation or bugs, since developers usually
1952  * assume that overflows raise errors. `SafeCast` restores this intuition by
1953  * reverting the transaction when such an operation overflows.
1954  *
1955  * Using this library instead of the unchecked operations eliminates an entire
1956  * class of bugs, so it's recommended to use it always.
1957  *
1958  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1959  * all math on `uint256` and `int256` and then downcasting.
1960  */
1961 library SafeCast {
1962     /**
1963      * @dev Returns the downcasted uint248 from uint256, reverting on
1964      * overflow (when the input is greater than largest uint248).
1965      *
1966      * Counterpart to Solidity's `uint248` operator.
1967      *
1968      * Requirements:
1969      *
1970      * - input must fit into 248 bits
1971      *
1972      * _Available since v4.7._
1973      */
1974     function toUint248(uint256 value) internal pure returns (uint248) {
1975         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
1976         return uint248(value);
1977     }
1978 
1979     /**
1980      * @dev Returns the downcasted uint240 from uint256, reverting on
1981      * overflow (when the input is greater than largest uint240).
1982      *
1983      * Counterpart to Solidity's `uint240` operator.
1984      *
1985      * Requirements:
1986      *
1987      * - input must fit into 240 bits
1988      *
1989      * _Available since v4.7._
1990      */
1991     function toUint240(uint256 value) internal pure returns (uint240) {
1992         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
1993         return uint240(value);
1994     }
1995 
1996     /**
1997      * @dev Returns the downcasted uint232 from uint256, reverting on
1998      * overflow (when the input is greater than largest uint232).
1999      *
2000      * Counterpart to Solidity's `uint232` operator.
2001      *
2002      * Requirements:
2003      *
2004      * - input must fit into 232 bits
2005      *
2006      * _Available since v4.7._
2007      */
2008     function toUint232(uint256 value) internal pure returns (uint232) {
2009         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
2010         return uint232(value);
2011     }
2012 
2013     /**
2014      * @dev Returns the downcasted uint224 from uint256, reverting on
2015      * overflow (when the input is greater than largest uint224).
2016      *
2017      * Counterpart to Solidity's `uint224` operator.
2018      *
2019      * Requirements:
2020      *
2021      * - input must fit into 224 bits
2022      *
2023      * _Available since v4.2._
2024      */
2025     function toUint224(uint256 value) internal pure returns (uint224) {
2026         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
2027         return uint224(value);
2028     }
2029 
2030     /**
2031      * @dev Returns the downcasted uint216 from uint256, reverting on
2032      * overflow (when the input is greater than largest uint216).
2033      *
2034      * Counterpart to Solidity's `uint216` operator.
2035      *
2036      * Requirements:
2037      *
2038      * - input must fit into 216 bits
2039      *
2040      * _Available since v4.7._
2041      */
2042     function toUint216(uint256 value) internal pure returns (uint216) {
2043         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
2044         return uint216(value);
2045     }
2046 
2047     /**
2048      * @dev Returns the downcasted uint208 from uint256, reverting on
2049      * overflow (when the input is greater than largest uint208).
2050      *
2051      * Counterpart to Solidity's `uint208` operator.
2052      *
2053      * Requirements:
2054      *
2055      * - input must fit into 208 bits
2056      *
2057      * _Available since v4.7._
2058      */
2059     function toUint208(uint256 value) internal pure returns (uint208) {
2060         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
2061         return uint208(value);
2062     }
2063 
2064     /**
2065      * @dev Returns the downcasted uint200 from uint256, reverting on
2066      * overflow (when the input is greater than largest uint200).
2067      *
2068      * Counterpart to Solidity's `uint200` operator.
2069      *
2070      * Requirements:
2071      *
2072      * - input must fit into 200 bits
2073      *
2074      * _Available since v4.7._
2075      */
2076     function toUint200(uint256 value) internal pure returns (uint200) {
2077         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
2078         return uint200(value);
2079     }
2080 
2081     /**
2082      * @dev Returns the downcasted uint192 from uint256, reverting on
2083      * overflow (when the input is greater than largest uint192).
2084      *
2085      * Counterpart to Solidity's `uint192` operator.
2086      *
2087      * Requirements:
2088      *
2089      * - input must fit into 192 bits
2090      *
2091      * _Available since v4.7._
2092      */
2093     function toUint192(uint256 value) internal pure returns (uint192) {
2094         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
2095         return uint192(value);
2096     }
2097 
2098     /**
2099      * @dev Returns the downcasted uint184 from uint256, reverting on
2100      * overflow (when the input is greater than largest uint184).
2101      *
2102      * Counterpart to Solidity's `uint184` operator.
2103      *
2104      * Requirements:
2105      *
2106      * - input must fit into 184 bits
2107      *
2108      * _Available since v4.7._
2109      */
2110     function toUint184(uint256 value) internal pure returns (uint184) {
2111         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
2112         return uint184(value);
2113     }
2114 
2115     /**
2116      * @dev Returns the downcasted uint176 from uint256, reverting on
2117      * overflow (when the input is greater than largest uint176).
2118      *
2119      * Counterpart to Solidity's `uint176` operator.
2120      *
2121      * Requirements:
2122      *
2123      * - input must fit into 176 bits
2124      *
2125      * _Available since v4.7._
2126      */
2127     function toUint176(uint256 value) internal pure returns (uint176) {
2128         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
2129         return uint176(value);
2130     }
2131 
2132     /**
2133      * @dev Returns the downcasted uint168 from uint256, reverting on
2134      * overflow (when the input is greater than largest uint168).
2135      *
2136      * Counterpart to Solidity's `uint168` operator.
2137      *
2138      * Requirements:
2139      *
2140      * - input must fit into 168 bits
2141      *
2142      * _Available since v4.7._
2143      */
2144     function toUint168(uint256 value) internal pure returns (uint168) {
2145         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
2146         return uint168(value);
2147     }
2148 
2149     /**
2150      * @dev Returns the downcasted uint160 from uint256, reverting on
2151      * overflow (when the input is greater than largest uint160).
2152      *
2153      * Counterpart to Solidity's `uint160` operator.
2154      *
2155      * Requirements:
2156      *
2157      * - input must fit into 160 bits
2158      *
2159      * _Available since v4.7._
2160      */
2161     function toUint160(uint256 value) internal pure returns (uint160) {
2162         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
2163         return uint160(value);
2164     }
2165 
2166     /**
2167      * @dev Returns the downcasted uint152 from uint256, reverting on
2168      * overflow (when the input is greater than largest uint152).
2169      *
2170      * Counterpart to Solidity's `uint152` operator.
2171      *
2172      * Requirements:
2173      *
2174      * - input must fit into 152 bits
2175      *
2176      * _Available since v4.7._
2177      */
2178     function toUint152(uint256 value) internal pure returns (uint152) {
2179         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
2180         return uint152(value);
2181     }
2182 
2183     /**
2184      * @dev Returns the downcasted uint144 from uint256, reverting on
2185      * overflow (when the input is greater than largest uint144).
2186      *
2187      * Counterpart to Solidity's `uint144` operator.
2188      *
2189      * Requirements:
2190      *
2191      * - input must fit into 144 bits
2192      *
2193      * _Available since v4.7._
2194      */
2195     function toUint144(uint256 value) internal pure returns (uint144) {
2196         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
2197         return uint144(value);
2198     }
2199 
2200     /**
2201      * @dev Returns the downcasted uint136 from uint256, reverting on
2202      * overflow (when the input is greater than largest uint136).
2203      *
2204      * Counterpart to Solidity's `uint136` operator.
2205      *
2206      * Requirements:
2207      *
2208      * - input must fit into 136 bits
2209      *
2210      * _Available since v4.7._
2211      */
2212     function toUint136(uint256 value) internal pure returns (uint136) {
2213         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
2214         return uint136(value);
2215     }
2216 
2217     /**
2218      * @dev Returns the downcasted uint128 from uint256, reverting on
2219      * overflow (when the input is greater than largest uint128).
2220      *
2221      * Counterpart to Solidity's `uint128` operator.
2222      *
2223      * Requirements:
2224      *
2225      * - input must fit into 128 bits
2226      *
2227      * _Available since v2.5._
2228      */
2229     function toUint128(uint256 value) internal pure returns (uint128) {
2230         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
2231         return uint128(value);
2232     }
2233 
2234     /**
2235      * @dev Returns the downcasted uint120 from uint256, reverting on
2236      * overflow (when the input is greater than largest uint120).
2237      *
2238      * Counterpart to Solidity's `uint120` operator.
2239      *
2240      * Requirements:
2241      *
2242      * - input must fit into 120 bits
2243      *
2244      * _Available since v4.7._
2245      */
2246     function toUint120(uint256 value) internal pure returns (uint120) {
2247         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
2248         return uint120(value);
2249     }
2250 
2251     /**
2252      * @dev Returns the downcasted uint112 from uint256, reverting on
2253      * overflow (when the input is greater than largest uint112).
2254      *
2255      * Counterpart to Solidity's `uint112` operator.
2256      *
2257      * Requirements:
2258      *
2259      * - input must fit into 112 bits
2260      *
2261      * _Available since v4.7._
2262      */
2263     function toUint112(uint256 value) internal pure returns (uint112) {
2264         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
2265         return uint112(value);
2266     }
2267 
2268     /**
2269      * @dev Returns the downcasted uint104 from uint256, reverting on
2270      * overflow (when the input is greater than largest uint104).
2271      *
2272      * Counterpart to Solidity's `uint104` operator.
2273      *
2274      * Requirements:
2275      *
2276      * - input must fit into 104 bits
2277      *
2278      * _Available since v4.7._
2279      */
2280     function toUint104(uint256 value) internal pure returns (uint104) {
2281         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
2282         return uint104(value);
2283     }
2284 
2285     /**
2286      * @dev Returns the downcasted uint96 from uint256, reverting on
2287      * overflow (when the input is greater than largest uint96).
2288      *
2289      * Counterpart to Solidity's `uint96` operator.
2290      *
2291      * Requirements:
2292      *
2293      * - input must fit into 96 bits
2294      *
2295      * _Available since v4.2._
2296      */
2297     function toUint96(uint256 value) internal pure returns (uint96) {
2298         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
2299         return uint96(value);
2300     }
2301 
2302     /**
2303      * @dev Returns the downcasted uint88 from uint256, reverting on
2304      * overflow (when the input is greater than largest uint88).
2305      *
2306      * Counterpart to Solidity's `uint88` operator.
2307      *
2308      * Requirements:
2309      *
2310      * - input must fit into 88 bits
2311      *
2312      * _Available since v4.7._
2313      */
2314     function toUint88(uint256 value) internal pure returns (uint88) {
2315         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
2316         return uint88(value);
2317     }
2318 
2319     /**
2320      * @dev Returns the downcasted uint80 from uint256, reverting on
2321      * overflow (when the input is greater than largest uint80).
2322      *
2323      * Counterpart to Solidity's `uint80` operator.
2324      *
2325      * Requirements:
2326      *
2327      * - input must fit into 80 bits
2328      *
2329      * _Available since v4.7._
2330      */
2331     function toUint80(uint256 value) internal pure returns (uint80) {
2332         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
2333         return uint80(value);
2334     }
2335 
2336     /**
2337      * @dev Returns the downcasted uint72 from uint256, reverting on
2338      * overflow (when the input is greater than largest uint72).
2339      *
2340      * Counterpart to Solidity's `uint72` operator.
2341      *
2342      * Requirements:
2343      *
2344      * - input must fit into 72 bits
2345      *
2346      * _Available since v4.7._
2347      */
2348     function toUint72(uint256 value) internal pure returns (uint72) {
2349         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
2350         return uint72(value);
2351     }
2352 
2353     /**
2354      * @dev Returns the downcasted uint64 from uint256, reverting on
2355      * overflow (when the input is greater than largest uint64).
2356      *
2357      * Counterpart to Solidity's `uint64` operator.
2358      *
2359      * Requirements:
2360      *
2361      * - input must fit into 64 bits
2362      *
2363      * _Available since v2.5._
2364      */
2365     function toUint64(uint256 value) internal pure returns (uint64) {
2366         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
2367         return uint64(value);
2368     }
2369 
2370     /**
2371      * @dev Returns the downcasted uint56 from uint256, reverting on
2372      * overflow (when the input is greater than largest uint56).
2373      *
2374      * Counterpart to Solidity's `uint56` operator.
2375      *
2376      * Requirements:
2377      *
2378      * - input must fit into 56 bits
2379      *
2380      * _Available since v4.7._
2381      */
2382     function toUint56(uint256 value) internal pure returns (uint56) {
2383         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
2384         return uint56(value);
2385     }
2386 
2387     /**
2388      * @dev Returns the downcasted uint48 from uint256, reverting on
2389      * overflow (when the input is greater than largest uint48).
2390      *
2391      * Counterpart to Solidity's `uint48` operator.
2392      *
2393      * Requirements:
2394      *
2395      * - input must fit into 48 bits
2396      *
2397      * _Available since v4.7._
2398      */
2399     function toUint48(uint256 value) internal pure returns (uint48) {
2400         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
2401         return uint48(value);
2402     }
2403 
2404     /**
2405      * @dev Returns the downcasted uint40 from uint256, reverting on
2406      * overflow (when the input is greater than largest uint40).
2407      *
2408      * Counterpart to Solidity's `uint40` operator.
2409      *
2410      * Requirements:
2411      *
2412      * - input must fit into 40 bits
2413      *
2414      * _Available since v4.7._
2415      */
2416     function toUint40(uint256 value) internal pure returns (uint40) {
2417         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
2418         return uint40(value);
2419     }
2420 
2421     /**
2422      * @dev Returns the downcasted uint32 from uint256, reverting on
2423      * overflow (when the input is greater than largest uint32).
2424      *
2425      * Counterpart to Solidity's `uint32` operator.
2426      *
2427      * Requirements:
2428      *
2429      * - input must fit into 32 bits
2430      *
2431      * _Available since v2.5._
2432      */
2433     function toUint32(uint256 value) internal pure returns (uint32) {
2434         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
2435         return uint32(value);
2436     }
2437 
2438     /**
2439      * @dev Returns the downcasted uint24 from uint256, reverting on
2440      * overflow (when the input is greater than largest uint24).
2441      *
2442      * Counterpart to Solidity's `uint24` operator.
2443      *
2444      * Requirements:
2445      *
2446      * - input must fit into 24 bits
2447      *
2448      * _Available since v4.7._
2449      */
2450     function toUint24(uint256 value) internal pure returns (uint24) {
2451         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
2452         return uint24(value);
2453     }
2454 
2455     /**
2456      * @dev Returns the downcasted uint16 from uint256, reverting on
2457      * overflow (when the input is greater than largest uint16).
2458      *
2459      * Counterpart to Solidity's `uint16` operator.
2460      *
2461      * Requirements:
2462      *
2463      * - input must fit into 16 bits
2464      *
2465      * _Available since v2.5._
2466      */
2467     function toUint16(uint256 value) internal pure returns (uint16) {
2468         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
2469         return uint16(value);
2470     }
2471 
2472     /**
2473      * @dev Returns the downcasted uint8 from uint256, reverting on
2474      * overflow (when the input is greater than largest uint8).
2475      *
2476      * Counterpart to Solidity's `uint8` operator.
2477      *
2478      * Requirements:
2479      *
2480      * - input must fit into 8 bits
2481      *
2482      * _Available since v2.5._
2483      */
2484     function toUint8(uint256 value) internal pure returns (uint8) {
2485         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
2486         return uint8(value);
2487     }
2488 
2489     /**
2490      * @dev Converts a signed int256 into an unsigned uint256.
2491      *
2492      * Requirements:
2493      *
2494      * - input must be greater than or equal to 0.
2495      *
2496      * _Available since v3.0._
2497      */
2498     function toUint256(int256 value) internal pure returns (uint256) {
2499         require(value >= 0, "SafeCast: value must be positive");
2500         return uint256(value);
2501     }
2502 
2503     /**
2504      * @dev Returns the downcasted int248 from int256, reverting on
2505      * overflow (when the input is less than smallest int248 or
2506      * greater than largest int248).
2507      *
2508      * Counterpart to Solidity's `int248` operator.
2509      *
2510      * Requirements:
2511      *
2512      * - input must fit into 248 bits
2513      *
2514      * _Available since v4.7._
2515      */
2516     function toInt248(int256 value) internal pure returns (int248 downcasted) {
2517         downcasted = int248(value);
2518         require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
2519     }
2520 
2521     /**
2522      * @dev Returns the downcasted int240 from int256, reverting on
2523      * overflow (when the input is less than smallest int240 or
2524      * greater than largest int240).
2525      *
2526      * Counterpart to Solidity's `int240` operator.
2527      *
2528      * Requirements:
2529      *
2530      * - input must fit into 240 bits
2531      *
2532      * _Available since v4.7._
2533      */
2534     function toInt240(int256 value) internal pure returns (int240 downcasted) {
2535         downcasted = int240(value);
2536         require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
2537     }
2538 
2539     /**
2540      * @dev Returns the downcasted int232 from int256, reverting on
2541      * overflow (when the input is less than smallest int232 or
2542      * greater than largest int232).
2543      *
2544      * Counterpart to Solidity's `int232` operator.
2545      *
2546      * Requirements:
2547      *
2548      * - input must fit into 232 bits
2549      *
2550      * _Available since v4.7._
2551      */
2552     function toInt232(int256 value) internal pure returns (int232 downcasted) {
2553         downcasted = int232(value);
2554         require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
2555     }
2556 
2557     /**
2558      * @dev Returns the downcasted int224 from int256, reverting on
2559      * overflow (when the input is less than smallest int224 or
2560      * greater than largest int224).
2561      *
2562      * Counterpart to Solidity's `int224` operator.
2563      *
2564      * Requirements:
2565      *
2566      * - input must fit into 224 bits
2567      *
2568      * _Available since v4.7._
2569      */
2570     function toInt224(int256 value) internal pure returns (int224 downcasted) {
2571         downcasted = int224(value);
2572         require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
2573     }
2574 
2575     /**
2576      * @dev Returns the downcasted int216 from int256, reverting on
2577      * overflow (when the input is less than smallest int216 or
2578      * greater than largest int216).
2579      *
2580      * Counterpart to Solidity's `int216` operator.
2581      *
2582      * Requirements:
2583      *
2584      * - input must fit into 216 bits
2585      *
2586      * _Available since v4.7._
2587      */
2588     function toInt216(int256 value) internal pure returns (int216 downcasted) {
2589         downcasted = int216(value);
2590         require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
2591     }
2592 
2593     /**
2594      * @dev Returns the downcasted int208 from int256, reverting on
2595      * overflow (when the input is less than smallest int208 or
2596      * greater than largest int208).
2597      *
2598      * Counterpart to Solidity's `int208` operator.
2599      *
2600      * Requirements:
2601      *
2602      * - input must fit into 208 bits
2603      *
2604      * _Available since v4.7._
2605      */
2606     function toInt208(int256 value) internal pure returns (int208 downcasted) {
2607         downcasted = int208(value);
2608         require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
2609     }
2610 
2611     /**
2612      * @dev Returns the downcasted int200 from int256, reverting on
2613      * overflow (when the input is less than smallest int200 or
2614      * greater than largest int200).
2615      *
2616      * Counterpart to Solidity's `int200` operator.
2617      *
2618      * Requirements:
2619      *
2620      * - input must fit into 200 bits
2621      *
2622      * _Available since v4.7._
2623      */
2624     function toInt200(int256 value) internal pure returns (int200 downcasted) {
2625         downcasted = int200(value);
2626         require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
2627     }
2628 
2629     /**
2630      * @dev Returns the downcasted int192 from int256, reverting on
2631      * overflow (when the input is less than smallest int192 or
2632      * greater than largest int192).
2633      *
2634      * Counterpart to Solidity's `int192` operator.
2635      *
2636      * Requirements:
2637      *
2638      * - input must fit into 192 bits
2639      *
2640      * _Available since v4.7._
2641      */
2642     function toInt192(int256 value) internal pure returns (int192 downcasted) {
2643         downcasted = int192(value);
2644         require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
2645     }
2646 
2647     /**
2648      * @dev Returns the downcasted int184 from int256, reverting on
2649      * overflow (when the input is less than smallest int184 or
2650      * greater than largest int184).
2651      *
2652      * Counterpart to Solidity's `int184` operator.
2653      *
2654      * Requirements:
2655      *
2656      * - input must fit into 184 bits
2657      *
2658      * _Available since v4.7._
2659      */
2660     function toInt184(int256 value) internal pure returns (int184 downcasted) {
2661         downcasted = int184(value);
2662         require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
2663     }
2664 
2665     /**
2666      * @dev Returns the downcasted int176 from int256, reverting on
2667      * overflow (when the input is less than smallest int176 or
2668      * greater than largest int176).
2669      *
2670      * Counterpart to Solidity's `int176` operator.
2671      *
2672      * Requirements:
2673      *
2674      * - input must fit into 176 bits
2675      *
2676      * _Available since v4.7._
2677      */
2678     function toInt176(int256 value) internal pure returns (int176 downcasted) {
2679         downcasted = int176(value);
2680         require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
2681     }
2682 
2683     /**
2684      * @dev Returns the downcasted int168 from int256, reverting on
2685      * overflow (when the input is less than smallest int168 or
2686      * greater than largest int168).
2687      *
2688      * Counterpart to Solidity's `int168` operator.
2689      *
2690      * Requirements:
2691      *
2692      * - input must fit into 168 bits
2693      *
2694      * _Available since v4.7._
2695      */
2696     function toInt168(int256 value) internal pure returns (int168 downcasted) {
2697         downcasted = int168(value);
2698         require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
2699     }
2700 
2701     /**
2702      * @dev Returns the downcasted int160 from int256, reverting on
2703      * overflow (when the input is less than smallest int160 or
2704      * greater than largest int160).
2705      *
2706      * Counterpart to Solidity's `int160` operator.
2707      *
2708      * Requirements:
2709      *
2710      * - input must fit into 160 bits
2711      *
2712      * _Available since v4.7._
2713      */
2714     function toInt160(int256 value) internal pure returns (int160 downcasted) {
2715         downcasted = int160(value);
2716         require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
2717     }
2718 
2719     /**
2720      * @dev Returns the downcasted int152 from int256, reverting on
2721      * overflow (when the input is less than smallest int152 or
2722      * greater than largest int152).
2723      *
2724      * Counterpart to Solidity's `int152` operator.
2725      *
2726      * Requirements:
2727      *
2728      * - input must fit into 152 bits
2729      *
2730      * _Available since v4.7._
2731      */
2732     function toInt152(int256 value) internal pure returns (int152 downcasted) {
2733         downcasted = int152(value);
2734         require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
2735     }
2736 
2737     /**
2738      * @dev Returns the downcasted int144 from int256, reverting on
2739      * overflow (when the input is less than smallest int144 or
2740      * greater than largest int144).
2741      *
2742      * Counterpart to Solidity's `int144` operator.
2743      *
2744      * Requirements:
2745      *
2746      * - input must fit into 144 bits
2747      *
2748      * _Available since v4.7._
2749      */
2750     function toInt144(int256 value) internal pure returns (int144 downcasted) {
2751         downcasted = int144(value);
2752         require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
2753     }
2754 
2755     /**
2756      * @dev Returns the downcasted int136 from int256, reverting on
2757      * overflow (when the input is less than smallest int136 or
2758      * greater than largest int136).
2759      *
2760      * Counterpart to Solidity's `int136` operator.
2761      *
2762      * Requirements:
2763      *
2764      * - input must fit into 136 bits
2765      *
2766      * _Available since v4.7._
2767      */
2768     function toInt136(int256 value) internal pure returns (int136 downcasted) {
2769         downcasted = int136(value);
2770         require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
2771     }
2772 
2773     /**
2774      * @dev Returns the downcasted int128 from int256, reverting on
2775      * overflow (when the input is less than smallest int128 or
2776      * greater than largest int128).
2777      *
2778      * Counterpart to Solidity's `int128` operator.
2779      *
2780      * Requirements:
2781      *
2782      * - input must fit into 128 bits
2783      *
2784      * _Available since v3.1._
2785      */
2786     function toInt128(int256 value) internal pure returns (int128 downcasted) {
2787         downcasted = int128(value);
2788         require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
2789     }
2790 
2791     /**
2792      * @dev Returns the downcasted int120 from int256, reverting on
2793      * overflow (when the input is less than smallest int120 or
2794      * greater than largest int120).
2795      *
2796      * Counterpart to Solidity's `int120` operator.
2797      *
2798      * Requirements:
2799      *
2800      * - input must fit into 120 bits
2801      *
2802      * _Available since v4.7._
2803      */
2804     function toInt120(int256 value) internal pure returns (int120 downcasted) {
2805         downcasted = int120(value);
2806         require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
2807     }
2808 
2809     /**
2810      * @dev Returns the downcasted int112 from int256, reverting on
2811      * overflow (when the input is less than smallest int112 or
2812      * greater than largest int112).
2813      *
2814      * Counterpart to Solidity's `int112` operator.
2815      *
2816      * Requirements:
2817      *
2818      * - input must fit into 112 bits
2819      *
2820      * _Available since v4.7._
2821      */
2822     function toInt112(int256 value) internal pure returns (int112 downcasted) {
2823         downcasted = int112(value);
2824         require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
2825     }
2826 
2827     /**
2828      * @dev Returns the downcasted int104 from int256, reverting on
2829      * overflow (when the input is less than smallest int104 or
2830      * greater than largest int104).
2831      *
2832      * Counterpart to Solidity's `int104` operator.
2833      *
2834      * Requirements:
2835      *
2836      * - input must fit into 104 bits
2837      *
2838      * _Available since v4.7._
2839      */
2840     function toInt104(int256 value) internal pure returns (int104 downcasted) {
2841         downcasted = int104(value);
2842         require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
2843     }
2844 
2845     /**
2846      * @dev Returns the downcasted int96 from int256, reverting on
2847      * overflow (when the input is less than smallest int96 or
2848      * greater than largest int96).
2849      *
2850      * Counterpart to Solidity's `int96` operator.
2851      *
2852      * Requirements:
2853      *
2854      * - input must fit into 96 bits
2855      *
2856      * _Available since v4.7._
2857      */
2858     function toInt96(int256 value) internal pure returns (int96 downcasted) {
2859         downcasted = int96(value);
2860         require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
2861     }
2862 
2863     /**
2864      * @dev Returns the downcasted int88 from int256, reverting on
2865      * overflow (when the input is less than smallest int88 or
2866      * greater than largest int88).
2867      *
2868      * Counterpart to Solidity's `int88` operator.
2869      *
2870      * Requirements:
2871      *
2872      * - input must fit into 88 bits
2873      *
2874      * _Available since v4.7._
2875      */
2876     function toInt88(int256 value) internal pure returns (int88 downcasted) {
2877         downcasted = int88(value);
2878         require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
2879     }
2880 
2881     /**
2882      * @dev Returns the downcasted int80 from int256, reverting on
2883      * overflow (when the input is less than smallest int80 or
2884      * greater than largest int80).
2885      *
2886      * Counterpart to Solidity's `int80` operator.
2887      *
2888      * Requirements:
2889      *
2890      * - input must fit into 80 bits
2891      *
2892      * _Available since v4.7._
2893      */
2894     function toInt80(int256 value) internal pure returns (int80 downcasted) {
2895         downcasted = int80(value);
2896         require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
2897     }
2898 
2899     /**
2900      * @dev Returns the downcasted int72 from int256, reverting on
2901      * overflow (when the input is less than smallest int72 or
2902      * greater than largest int72).
2903      *
2904      * Counterpart to Solidity's `int72` operator.
2905      *
2906      * Requirements:
2907      *
2908      * - input must fit into 72 bits
2909      *
2910      * _Available since v4.7._
2911      */
2912     function toInt72(int256 value) internal pure returns (int72 downcasted) {
2913         downcasted = int72(value);
2914         require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
2915     }
2916 
2917     /**
2918      * @dev Returns the downcasted int64 from int256, reverting on
2919      * overflow (when the input is less than smallest int64 or
2920      * greater than largest int64).
2921      *
2922      * Counterpart to Solidity's `int64` operator.
2923      *
2924      * Requirements:
2925      *
2926      * - input must fit into 64 bits
2927      *
2928      * _Available since v3.1._
2929      */
2930     function toInt64(int256 value) internal pure returns (int64 downcasted) {
2931         downcasted = int64(value);
2932         require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
2933     }
2934 
2935     /**
2936      * @dev Returns the downcasted int56 from int256, reverting on
2937      * overflow (when the input is less than smallest int56 or
2938      * greater than largest int56).
2939      *
2940      * Counterpart to Solidity's `int56` operator.
2941      *
2942      * Requirements:
2943      *
2944      * - input must fit into 56 bits
2945      *
2946      * _Available since v4.7._
2947      */
2948     function toInt56(int256 value) internal pure returns (int56 downcasted) {
2949         downcasted = int56(value);
2950         require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
2951     }
2952 
2953     /**
2954      * @dev Returns the downcasted int48 from int256, reverting on
2955      * overflow (when the input is less than smallest int48 or
2956      * greater than largest int48).
2957      *
2958      * Counterpart to Solidity's `int48` operator.
2959      *
2960      * Requirements:
2961      *
2962      * - input must fit into 48 bits
2963      *
2964      * _Available since v4.7._
2965      */
2966     function toInt48(int256 value) internal pure returns (int48 downcasted) {
2967         downcasted = int48(value);
2968         require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
2969     }
2970 
2971     /**
2972      * @dev Returns the downcasted int40 from int256, reverting on
2973      * overflow (when the input is less than smallest int40 or
2974      * greater than largest int40).
2975      *
2976      * Counterpart to Solidity's `int40` operator.
2977      *
2978      * Requirements:
2979      *
2980      * - input must fit into 40 bits
2981      *
2982      * _Available since v4.7._
2983      */
2984     function toInt40(int256 value) internal pure returns (int40 downcasted) {
2985         downcasted = int40(value);
2986         require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
2987     }
2988 
2989     /**
2990      * @dev Returns the downcasted int32 from int256, reverting on
2991      * overflow (when the input is less than smallest int32 or
2992      * greater than largest int32).
2993      *
2994      * Counterpart to Solidity's `int32` operator.
2995      *
2996      * Requirements:
2997      *
2998      * - input must fit into 32 bits
2999      *
3000      * _Available since v3.1._
3001      */
3002     function toInt32(int256 value) internal pure returns (int32 downcasted) {
3003         downcasted = int32(value);
3004         require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
3005     }
3006 
3007     /**
3008      * @dev Returns the downcasted int24 from int256, reverting on
3009      * overflow (when the input is less than smallest int24 or
3010      * greater than largest int24).
3011      *
3012      * Counterpart to Solidity's `int24` operator.
3013      *
3014      * Requirements:
3015      *
3016      * - input must fit into 24 bits
3017      *
3018      * _Available since v4.7._
3019      */
3020     function toInt24(int256 value) internal pure returns (int24 downcasted) {
3021         downcasted = int24(value);
3022         require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
3023     }
3024 
3025     /**
3026      * @dev Returns the downcasted int16 from int256, reverting on
3027      * overflow (when the input is less than smallest int16 or
3028      * greater than largest int16).
3029      *
3030      * Counterpart to Solidity's `int16` operator.
3031      *
3032      * Requirements:
3033      *
3034      * - input must fit into 16 bits
3035      *
3036      * _Available since v3.1._
3037      */
3038     function toInt16(int256 value) internal pure returns (int16 downcasted) {
3039         downcasted = int16(value);
3040         require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
3041     }
3042 
3043     /**
3044      * @dev Returns the downcasted int8 from int256, reverting on
3045      * overflow (when the input is less than smallest int8 or
3046      * greater than largest int8).
3047      *
3048      * Counterpart to Solidity's `int8` operator.
3049      *
3050      * Requirements:
3051      *
3052      * - input must fit into 8 bits
3053      *
3054      * _Available since v3.1._
3055      */
3056     function toInt8(int256 value) internal pure returns (int8 downcasted) {
3057         downcasted = int8(value);
3058         require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
3059     }
3060 
3061     /**
3062      * @dev Converts an unsigned uint256 into a signed int256.
3063      *
3064      * Requirements:
3065      *
3066      * - input must be less than or equal to maxInt256.
3067      *
3068      * _Available since v3.0._
3069      */
3070     function toInt256(uint256 value) internal pure returns (int256) {
3071         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
3072         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
3073         return int256(value);
3074     }
3075 }
3076 
3077 
3078 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol@v4.8.0
3079 
3080 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/ERC20Votes.sol)
3081 
3082 pragma solidity ^0.8.0;
3083 
3084 
3085 
3086 
3087 
3088 /**
3089  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
3090  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
3091  *
3092  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
3093  *
3094  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
3095  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
3096  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
3097  *
3098  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
3099  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
3100  *
3101  * _Available since v4.2._
3102  */
3103 abstract contract ERC20Votes is IVotes, ERC20Permit {
3104     struct Checkpoint {
3105         uint32 fromBlock;
3106         uint224 votes;
3107     }
3108 
3109     bytes32 private constant _DELEGATION_TYPEHASH =
3110         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
3111 
3112     mapping(address => address) private _delegates;
3113     mapping(address => Checkpoint[]) private _checkpoints;
3114     Checkpoint[] private _totalSupplyCheckpoints;
3115 
3116     /**
3117      * @dev Get the `pos`-th checkpoint for `account`.
3118      */
3119     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
3120         return _checkpoints[account][pos];
3121     }
3122 
3123     /**
3124      * @dev Get number of checkpoints for `account`.
3125      */
3126     function numCheckpoints(address account) public view virtual returns (uint32) {
3127         return SafeCast.toUint32(_checkpoints[account].length);
3128     }
3129 
3130     /**
3131      * @dev Get the address `account` is currently delegating to.
3132      */
3133     function delegates(address account) public view virtual override returns (address) {
3134         return _delegates[account];
3135     }
3136 
3137     /**
3138      * @dev Gets the current votes balance for `account`
3139      */
3140     function getVotes(address account) public view virtual override returns (uint256) {
3141         uint256 pos = _checkpoints[account].length;
3142         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
3143     }
3144 
3145     /**
3146      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
3147      *
3148      * Requirements:
3149      *
3150      * - `blockNumber` must have been already mined
3151      */
3152     function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
3153         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3154         return _checkpointsLookup(_checkpoints[account], blockNumber);
3155     }
3156 
3157     /**
3158      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
3159      * It is but NOT the sum of all the delegated votes!
3160      *
3161      * Requirements:
3162      *
3163      * - `blockNumber` must have been already mined
3164      */
3165     function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
3166         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3167         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
3168     }
3169 
3170     /**
3171      * @dev Lookup a value in a list of (sorted) checkpoints.
3172      */
3173     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
3174         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
3175         //
3176         // Initially we check if the block is recent to narrow the search range.
3177         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
3178         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
3179         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
3180         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
3181         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
3182         // out of bounds (in which case we're looking too far in the past and the result is 0).
3183         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
3184         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
3185         // the same.
3186         uint256 length = ckpts.length;
3187 
3188         uint256 low = 0;
3189         uint256 high = length;
3190 
3191         if (length > 5) {
3192             uint256 mid = length - Math.sqrt(length);
3193             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
3194                 high = mid;
3195             } else {
3196                 low = mid + 1;
3197             }
3198         }
3199 
3200         while (low < high) {
3201             uint256 mid = Math.average(low, high);
3202             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
3203                 high = mid;
3204             } else {
3205                 low = mid + 1;
3206             }
3207         }
3208 
3209         return high == 0 ? 0 : _unsafeAccess(ckpts, high - 1).votes;
3210     }
3211 
3212     /**
3213      * @dev Delegate votes from the sender to `delegatee`.
3214      */
3215     function delegate(address delegatee) public virtual override {
3216         _delegate(_msgSender(), delegatee);
3217     }
3218 
3219     /**
3220      * @dev Delegates votes from signer to `delegatee`
3221      */
3222     function delegateBySig(
3223         address delegatee,
3224         uint256 nonce,
3225         uint256 expiry,
3226         uint8 v,
3227         bytes32 r,
3228         bytes32 s
3229     ) public virtual override {
3230         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
3231         address signer = ECDSA.recover(
3232             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
3233             v,
3234             r,
3235             s
3236         );
3237         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
3238         _delegate(signer, delegatee);
3239     }
3240 
3241     /**
3242      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
3243      */
3244     function _maxSupply() internal view virtual returns (uint224) {
3245         return type(uint224).max;
3246     }
3247 
3248     /**
3249      * @dev Snapshots the totalSupply after it has been increased.
3250      */
3251     function _mint(address account, uint256 amount) internal virtual override {
3252         super._mint(account, amount);
3253         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
3254 
3255         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
3256     }
3257 
3258     /**
3259      * @dev Snapshots the totalSupply after it has been decreased.
3260      */
3261     function _burn(address account, uint256 amount) internal virtual override {
3262         super._burn(account, amount);
3263 
3264         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
3265     }
3266 
3267     /**
3268      * @dev Move voting power when tokens are transferred.
3269      *
3270      * Emits a {IVotes-DelegateVotesChanged} event.
3271      */
3272     function _afterTokenTransfer(
3273         address from,
3274         address to,
3275         uint256 amount
3276     ) internal virtual override {
3277         super._afterTokenTransfer(from, to, amount);
3278 
3279         _moveVotingPower(delegates(from), delegates(to), amount);
3280     }
3281 
3282     /**
3283      * @dev Change delegation for `delegator` to `delegatee`.
3284      *
3285      * Emits events {IVotes-DelegateChanged} and {IVotes-DelegateVotesChanged}.
3286      */
3287     function _delegate(address delegator, address delegatee) internal virtual {
3288         address currentDelegate = delegates(delegator);
3289         uint256 delegatorBalance = balanceOf(delegator);
3290         _delegates[delegator] = delegatee;
3291 
3292         emit DelegateChanged(delegator, currentDelegate, delegatee);
3293 
3294         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
3295     }
3296 
3297     function _moveVotingPower(
3298         address src,
3299         address dst,
3300         uint256 amount
3301     ) private {
3302         if (src != dst && amount > 0) {
3303             if (src != address(0)) {
3304                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
3305                 emit DelegateVotesChanged(src, oldWeight, newWeight);
3306             }
3307 
3308             if (dst != address(0)) {
3309                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
3310                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
3311             }
3312         }
3313     }
3314 
3315     function _writeCheckpoint(
3316         Checkpoint[] storage ckpts,
3317         function(uint256, uint256) view returns (uint256) op,
3318         uint256 delta
3319     ) private returns (uint256 oldWeight, uint256 newWeight) {
3320         uint256 pos = ckpts.length;
3321 
3322         Checkpoint memory oldCkpt = pos == 0 ? Checkpoint(0, 0) : _unsafeAccess(ckpts, pos - 1);
3323 
3324         oldWeight = oldCkpt.votes;
3325         newWeight = op(oldWeight, delta);
3326 
3327         if (pos > 0 && oldCkpt.fromBlock == block.number) {
3328             _unsafeAccess(ckpts, pos - 1).votes = SafeCast.toUint224(newWeight);
3329         } else {
3330             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
3331         }
3332     }
3333 
3334     function _add(uint256 a, uint256 b) private pure returns (uint256) {
3335         return a + b;
3336     }
3337 
3338     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
3339         return a - b;
3340     }
3341 
3342     function _unsafeAccess(Checkpoint[] storage ckpts, uint256 pos) private pure returns (Checkpoint storage result) {
3343         assembly {
3344             mstore(0, ckpts.slot)
3345             result.slot := add(keccak256(0, 0x20), pos)
3346         }
3347     }
3348 }
3349 
3350 
3351 // File contracts/BasicAccessController.sol
3352 
3353 pragma solidity 0.8.17;
3354 
3355 abstract contract BasicAccessController is AccessControl {
3356     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
3357     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
3358 
3359     address private _addressMinter;
3360 
3361     address private _nominatedAdmin;
3362     address private _oldAdmin;
3363 
3364     /**
3365      * @dev This empty reserved space is put in place to allow future versions to add new
3366      * variables without shifting down storage in the inheritance chain.
3367      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3368      */
3369     uint256[44] private __gap;
3370 
3371     modifier onlyAdmin() {
3372         require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not Admin");
3373         _;
3374     }
3375 
3376     modifier onlyMinter() {
3377         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not Minter");
3378         _;
3379     }
3380 
3381     function setAdmin(address newAdmin) public onlyAdmin {
3382         if (newAdmin == _msgSender()) {
3383             revert("new admin must be different");
3384         }
3385         _nominatedAdmin = newAdmin;
3386         _oldAdmin = _msgSender();
3387     }
3388 
3389     function acceptAdminRole() external {
3390         if (_nominatedAdmin == address(0) || _oldAdmin == address(0)) {
3391             revert("no nominated admin");
3392         }
3393         if (_nominatedAdmin == _msgSender()) {
3394             _grantRole(ADMIN_ROLE, _msgSender());
3395             _revokeRole(ADMIN_ROLE, _oldAdmin);
3396 
3397             _nominatedAdmin = address(0);
3398             _oldAdmin = address(0);
3399         }
3400     }
3401 
3402     function renounceRole(bytes32 role, address account) public virtual override {
3403         if (hasRole(ADMIN_ROLE, msg.sender)) {
3404             revert("Admin cant use renounceRole");
3405         }
3406         require(account == _msgSender(), "can only renounce roles for self");
3407 
3408         _revokeRole(role, account);
3409     }
3410 
3411     function setMinter(address newMinter) public onlyAdmin {
3412         address oldMinter = _addressMinter;
3413         require(oldMinter != newMinter, "New minter must be different");
3414         _grantRole(MINTER_ROLE, newMinter);
3415         _revokeRole(MINTER_ROLE, oldMinter);
3416         _addressMinter = newMinter;
3417     }
3418 
3419     function getAddressMinter() public view returns (address) {
3420         return _addressMinter;
3421     }
3422 
3423     function _requireAdmin() internal view {
3424         require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not admin");
3425     }
3426 }
3427 
3428 
3429 // File contracts/ArchToken.sol
3430 
3431 pragma solidity 0.8.17;
3432 
3433 
3434 
3435 
3436 /**
3437 @title Archimedes Governance token
3438 @notice contract is ERC20Permit and ERC20Votes to allow voting
3439  **/
3440 
3441 contract ArchToken is ERC20, BasicAccessController, ERC20Permit, ERC20Votes {
3442     constructor(address _addressTreasury) ERC20("ARCH", "ARCH") ERC20Permit("ArchToken") {
3443         _mint(_addressTreasury, 100000000 ether);
3444         _grantRole(ADMIN_ROLE, _msgSender());
3445     }
3446 
3447     // The following functions are overrides required by Solidity.
3448     function _afterTokenTransfer(
3449         address from,
3450         address to,
3451         uint256 amount
3452     ) internal override(ERC20, ERC20Votes) {
3453         super._afterTokenTransfer(from, to, amount);
3454     }
3455 
3456     function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
3457         super._mint(to, amount);
3458     }
3459 
3460     function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
3461         super._burn(account, amount);
3462     }
3463 }