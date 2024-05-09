1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.8.2
4 
5 // License-Identifier: MIT
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
95 // File @openzeppelin/contracts/utils/Context.sol@v4.8.2
96 
97 // License-Identifier: MIT
98 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         return msg.data;
119     }
120 }
121 
122 
123 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.2
124 
125 // License-Identifier: MIT
126 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Interface of the ERC165 standard, as defined in the
132  * https://eips.ethereum.org/EIPS/eip-165[EIP].
133  *
134  * Implementers can declare support of contract interfaces, which can then be
135  * queried by others ({ERC165Checker}).
136  *
137  * For an implementation, see {ERC165}.
138  */
139 interface IERC165 {
140     /**
141      * @dev Returns true if this contract implements the interface defined by
142      * `interfaceId`. See the corresponding
143      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
144      * to learn more about how these ids are created.
145      *
146      * This function call must use less than 30 000 gas.
147      */
148     function supportsInterface(bytes4 interfaceId) external view returns (bool);
149 }
150 
151 
152 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.2
153 
154 // License-Identifier: MIT
155 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Implementation of the {IERC165} interface.
161  *
162  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
163  * for the additional interface id that will be supported. For example:
164  *
165  * ```solidity
166  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
167  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
168  * }
169  * ```
170  *
171  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
172  */
173 abstract contract ERC165 is IERC165 {
174     /**
175      * @dev See {IERC165-supportsInterface}.
176      */
177     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
178         return interfaceId == type(IERC165).interfaceId;
179     }
180 }
181 
182 
183 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.2
184 
185 // License-Identifier: MIT
186 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Standard math utilities missing in the Solidity language.
192  */
193 library Math {
194     enum Rounding {
195         Down, // Toward negative infinity
196         Up, // Toward infinity
197         Zero // Toward zero
198     }
199 
200     /**
201      * @dev Returns the largest of two numbers.
202      */
203     function max(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a > b ? a : b;
205     }
206 
207     /**
208      * @dev Returns the smallest of two numbers.
209      */
210     function min(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a < b ? a : b;
212     }
213 
214     /**
215      * @dev Returns the average of two numbers. The result is rounded towards
216      * zero.
217      */
218     function average(uint256 a, uint256 b) internal pure returns (uint256) {
219         // (a + b) / 2 can overflow.
220         return (a & b) + (a ^ b) / 2;
221     }
222 
223     /**
224      * @dev Returns the ceiling of the division of two numbers.
225      *
226      * This differs from standard division with `/` in that it rounds up instead
227      * of rounding down.
228      */
229     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
230         // (a + b - 1) / b can overflow on addition, so we distribute.
231         return a == 0 ? 0 : (a - 1) / b + 1;
232     }
233 
234     /**
235      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
236      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
237      * with further edits by Uniswap Labs also under MIT license.
238      */
239     function mulDiv(
240         uint256 x,
241         uint256 y,
242         uint256 denominator
243     ) internal pure returns (uint256 result) {
244         unchecked {
245             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
246             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
247             // variables such that product = prod1 * 2^256 + prod0.
248             uint256 prod0; // Least significant 256 bits of the product
249             uint256 prod1; // Most significant 256 bits of the product
250             assembly {
251                 let mm := mulmod(x, y, not(0))
252                 prod0 := mul(x, y)
253                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
254             }
255 
256             // Handle non-overflow cases, 256 by 256 division.
257             if (prod1 == 0) {
258                 return prod0 / denominator;
259             }
260 
261             // Make sure the result is less than 2^256. Also prevents denominator == 0.
262             require(denominator > prod1);
263 
264             ///////////////////////////////////////////////
265             // 512 by 256 division.
266             ///////////////////////////////////////////////
267 
268             // Make division exact by subtracting the remainder from [prod1 prod0].
269             uint256 remainder;
270             assembly {
271                 // Compute remainder using mulmod.
272                 remainder := mulmod(x, y, denominator)
273 
274                 // Subtract 256 bit number from 512 bit number.
275                 prod1 := sub(prod1, gt(remainder, prod0))
276                 prod0 := sub(prod0, remainder)
277             }
278 
279             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
280             // See https://cs.stackexchange.com/q/138556/92363.
281 
282             // Does not overflow because the denominator cannot be zero at this stage in the function.
283             uint256 twos = denominator & (~denominator + 1);
284             assembly {
285                 // Divide denominator by twos.
286                 denominator := div(denominator, twos)
287 
288                 // Divide [prod1 prod0] by twos.
289                 prod0 := div(prod0, twos)
290 
291                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
292                 twos := add(div(sub(0, twos), twos), 1)
293             }
294 
295             // Shift in bits from prod1 into prod0.
296             prod0 |= prod1 * twos;
297 
298             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
299             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
300             // four bits. That is, denominator * inv = 1 mod 2^4.
301             uint256 inverse = (3 * denominator) ^ 2;
302 
303             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
304             // in modular arithmetic, doubling the correct bits in each step.
305             inverse *= 2 - denominator * inverse; // inverse mod 2^8
306             inverse *= 2 - denominator * inverse; // inverse mod 2^16
307             inverse *= 2 - denominator * inverse; // inverse mod 2^32
308             inverse *= 2 - denominator * inverse; // inverse mod 2^64
309             inverse *= 2 - denominator * inverse; // inverse mod 2^128
310             inverse *= 2 - denominator * inverse; // inverse mod 2^256
311 
312             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
313             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
314             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
315             // is no longer required.
316             result = prod0 * inverse;
317             return result;
318         }
319     }
320 
321     /**
322      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
323      */
324     function mulDiv(
325         uint256 x,
326         uint256 y,
327         uint256 denominator,
328         Rounding rounding
329     ) internal pure returns (uint256) {
330         uint256 result = mulDiv(x, y, denominator);
331         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
332             result += 1;
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
339      *
340      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
341      */
342     function sqrt(uint256 a) internal pure returns (uint256) {
343         if (a == 0) {
344             return 0;
345         }
346 
347         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
348         //
349         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
350         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
351         //
352         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
353         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
354         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
355         //
356         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
357         uint256 result = 1 << (log2(a) >> 1);
358 
359         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
360         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
361         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
362         // into the expected uint128 result.
363         unchecked {
364             result = (result + a / result) >> 1;
365             result = (result + a / result) >> 1;
366             result = (result + a / result) >> 1;
367             result = (result + a / result) >> 1;
368             result = (result + a / result) >> 1;
369             result = (result + a / result) >> 1;
370             result = (result + a / result) >> 1;
371             return min(result, a / result);
372         }
373     }
374 
375     /**
376      * @notice Calculates sqrt(a), following the selected rounding direction.
377      */
378     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
379         unchecked {
380             uint256 result = sqrt(a);
381             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
382         }
383     }
384 
385     /**
386      * @dev Return the log in base 2, rounded down, of a positive value.
387      * Returns 0 if given 0.
388      */
389     function log2(uint256 value) internal pure returns (uint256) {
390         uint256 result = 0;
391         unchecked {
392             if (value >> 128 > 0) {
393                 value >>= 128;
394                 result += 128;
395             }
396             if (value >> 64 > 0) {
397                 value >>= 64;
398                 result += 64;
399             }
400             if (value >> 32 > 0) {
401                 value >>= 32;
402                 result += 32;
403             }
404             if (value >> 16 > 0) {
405                 value >>= 16;
406                 result += 16;
407             }
408             if (value >> 8 > 0) {
409                 value >>= 8;
410                 result += 8;
411             }
412             if (value >> 4 > 0) {
413                 value >>= 4;
414                 result += 4;
415             }
416             if (value >> 2 > 0) {
417                 value >>= 2;
418                 result += 2;
419             }
420             if (value >> 1 > 0) {
421                 result += 1;
422             }
423         }
424         return result;
425     }
426 
427     /**
428      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
429      * Returns 0 if given 0.
430      */
431     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
432         unchecked {
433             uint256 result = log2(value);
434             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
435         }
436     }
437 
438     /**
439      * @dev Return the log in base 10, rounded down, of a positive value.
440      * Returns 0 if given 0.
441      */
442     function log10(uint256 value) internal pure returns (uint256) {
443         uint256 result = 0;
444         unchecked {
445             if (value >= 10**64) {
446                 value /= 10**64;
447                 result += 64;
448             }
449             if (value >= 10**32) {
450                 value /= 10**32;
451                 result += 32;
452             }
453             if (value >= 10**16) {
454                 value /= 10**16;
455                 result += 16;
456             }
457             if (value >= 10**8) {
458                 value /= 10**8;
459                 result += 8;
460             }
461             if (value >= 10**4) {
462                 value /= 10**4;
463                 result += 4;
464             }
465             if (value >= 10**2) {
466                 value /= 10**2;
467                 result += 2;
468             }
469             if (value >= 10**1) {
470                 result += 1;
471             }
472         }
473         return result;
474     }
475 
476     /**
477      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
478      * Returns 0 if given 0.
479      */
480     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
481         unchecked {
482             uint256 result = log10(value);
483             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
484         }
485     }
486 
487     /**
488      * @dev Return the log in base 256, rounded down, of a positive value.
489      * Returns 0 if given 0.
490      *
491      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
492      */
493     function log256(uint256 value) internal pure returns (uint256) {
494         uint256 result = 0;
495         unchecked {
496             if (value >> 128 > 0) {
497                 value >>= 128;
498                 result += 16;
499             }
500             if (value >> 64 > 0) {
501                 value >>= 64;
502                 result += 8;
503             }
504             if (value >> 32 > 0) {
505                 value >>= 32;
506                 result += 4;
507             }
508             if (value >> 16 > 0) {
509                 value >>= 16;
510                 result += 2;
511             }
512             if (value >> 8 > 0) {
513                 result += 1;
514             }
515         }
516         return result;
517     }
518 
519     /**
520      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
521      * Returns 0 if given 0.
522      */
523     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
524         unchecked {
525             uint256 result = log256(value);
526             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
527         }
528     }
529 }
530 
531 
532 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.2
533 
534 // License-Identifier: MIT
535 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev String operations.
541  */
542 library Strings {
543     bytes16 private constant _SYMBOLS = "0123456789abcdef";
544     uint8 private constant _ADDRESS_LENGTH = 20;
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
548      */
549     function toString(uint256 value) internal pure returns (string memory) {
550         unchecked {
551             uint256 length = Math.log10(value) + 1;
552             string memory buffer = new string(length);
553             uint256 ptr;
554             /// @solidity memory-safe-assembly
555             assembly {
556                 ptr := add(buffer, add(32, length))
557             }
558             while (true) {
559                 ptr--;
560                 /// @solidity memory-safe-assembly
561                 assembly {
562                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
563                 }
564                 value /= 10;
565                 if (value == 0) break;
566             }
567             return buffer;
568         }
569     }
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
573      */
574     function toHexString(uint256 value) internal pure returns (string memory) {
575         unchecked {
576             return toHexString(value, Math.log256(value) + 1);
577         }
578     }
579 
580     /**
581      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
582      */
583     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
584         bytes memory buffer = new bytes(2 * length + 2);
585         buffer[0] = "0";
586         buffer[1] = "x";
587         for (uint256 i = 2 * length + 1; i > 1; --i) {
588             buffer[i] = _SYMBOLS[value & 0xf];
589             value >>= 4;
590         }
591         require(value == 0, "Strings: hex length insufficient");
592         return string(buffer);
593     }
594 
595     /**
596      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
597      */
598     function toHexString(address addr) internal pure returns (string memory) {
599         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
600     }
601 }
602 
603 
604 // File @openzeppelin/contracts/access/AccessControl.sol@v4.8.2
605 
606 // License-Identifier: MIT
607 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 
613 
614 /**
615  * @dev Contract module that allows children to implement role-based access
616  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
617  * members except through off-chain means by accessing the contract event logs. Some
618  * applications may benefit from on-chain enumerability, for those cases see
619  * {AccessControlEnumerable}.
620  *
621  * Roles are referred to by their `bytes32` identifier. These should be exposed
622  * in the external API and be unique. The best way to achieve this is by
623  * using `public constant` hash digests:
624  *
625  * ```
626  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
627  * ```
628  *
629  * Roles can be used to represent a set of permissions. To restrict access to a
630  * function call, use {hasRole}:
631  *
632  * ```
633  * function foo() public {
634  *     require(hasRole(MY_ROLE, msg.sender));
635  *     ...
636  * }
637  * ```
638  *
639  * Roles can be granted and revoked dynamically via the {grantRole} and
640  * {revokeRole} functions. Each role has an associated admin role, and only
641  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
642  *
643  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
644  * that only accounts with this role will be able to grant or revoke other
645  * roles. More complex role relationships can be created by using
646  * {_setRoleAdmin}.
647  *
648  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
649  * grant and revoke this role. Extra precautions should be taken to secure
650  * accounts that have been granted it.
651  */
652 abstract contract AccessControl is Context, IAccessControl, ERC165 {
653     struct RoleData {
654         mapping(address => bool) members;
655         bytes32 adminRole;
656     }
657 
658     mapping(bytes32 => RoleData) private _roles;
659 
660     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
661 
662     /**
663      * @dev Modifier that checks that an account has a specific role. Reverts
664      * with a standardized message including the required role.
665      *
666      * The format of the revert reason is given by the following regular expression:
667      *
668      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
669      *
670      * _Available since v4.1._
671      */
672     modifier onlyRole(bytes32 role) {
673         _checkRole(role);
674         _;
675     }
676 
677     /**
678      * @dev See {IERC165-supportsInterface}.
679      */
680     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
682     }
683 
684     /**
685      * @dev Returns `true` if `account` has been granted `role`.
686      */
687     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
688         return _roles[role].members[account];
689     }
690 
691     /**
692      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
693      * Overriding this function changes the behavior of the {onlyRole} modifier.
694      *
695      * Format of the revert message is described in {_checkRole}.
696      *
697      * _Available since v4.6._
698      */
699     function _checkRole(bytes32 role) internal view virtual {
700         _checkRole(role, _msgSender());
701     }
702 
703     /**
704      * @dev Revert with a standard message if `account` is missing `role`.
705      *
706      * The format of the revert reason is given by the following regular expression:
707      *
708      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
709      */
710     function _checkRole(bytes32 role, address account) internal view virtual {
711         if (!hasRole(role, account)) {
712             revert(
713                 string(
714                     abi.encodePacked(
715                         "AccessControl: account ",
716                         Strings.toHexString(account),
717                         " is missing role ",
718                         Strings.toHexString(uint256(role), 32)
719                     )
720                 )
721             );
722         }
723     }
724 
725     /**
726      * @dev Returns the admin role that controls `role`. See {grantRole} and
727      * {revokeRole}.
728      *
729      * To change a role's admin, use {_setRoleAdmin}.
730      */
731     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
732         return _roles[role].adminRole;
733     }
734 
735     /**
736      * @dev Grants `role` to `account`.
737      *
738      * If `account` had not been already granted `role`, emits a {RoleGranted}
739      * event.
740      *
741      * Requirements:
742      *
743      * - the caller must have ``role``'s admin role.
744      *
745      * May emit a {RoleGranted} event.
746      */
747     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
748         _grantRole(role, account);
749     }
750 
751     /**
752      * @dev Revokes `role` from `account`.
753      *
754      * If `account` had been granted `role`, emits a {RoleRevoked} event.
755      *
756      * Requirements:
757      *
758      * - the caller must have ``role``'s admin role.
759      *
760      * May emit a {RoleRevoked} event.
761      */
762     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
763         _revokeRole(role, account);
764     }
765 
766     /**
767      * @dev Revokes `role` from the calling account.
768      *
769      * Roles are often managed via {grantRole} and {revokeRole}: this function's
770      * purpose is to provide a mechanism for accounts to lose their privileges
771      * if they are compromised (such as when a trusted device is misplaced).
772      *
773      * If the calling account had been revoked `role`, emits a {RoleRevoked}
774      * event.
775      *
776      * Requirements:
777      *
778      * - the caller must be `account`.
779      *
780      * May emit a {RoleRevoked} event.
781      */
782     function renounceRole(bytes32 role, address account) public virtual override {
783         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
784 
785         _revokeRole(role, account);
786     }
787 
788     /**
789      * @dev Grants `role` to `account`.
790      *
791      * If `account` had not been already granted `role`, emits a {RoleGranted}
792      * event. Note that unlike {grantRole}, this function doesn't perform any
793      * checks on the calling account.
794      *
795      * May emit a {RoleGranted} event.
796      *
797      * [WARNING]
798      * ====
799      * This function should only be called from the constructor when setting
800      * up the initial roles for the system.
801      *
802      * Using this function in any other way is effectively circumventing the admin
803      * system imposed by {AccessControl}.
804      * ====
805      *
806      * NOTE: This function is deprecated in favor of {_grantRole}.
807      */
808     function _setupRole(bytes32 role, address account) internal virtual {
809         _grantRole(role, account);
810     }
811 
812     /**
813      * @dev Sets `adminRole` as ``role``'s admin role.
814      *
815      * Emits a {RoleAdminChanged} event.
816      */
817     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
818         bytes32 previousAdminRole = getRoleAdmin(role);
819         _roles[role].adminRole = adminRole;
820         emit RoleAdminChanged(role, previousAdminRole, adminRole);
821     }
822 
823     /**
824      * @dev Grants `role` to `account`.
825      *
826      * Internal function without access restriction.
827      *
828      * May emit a {RoleGranted} event.
829      */
830     function _grantRole(bytes32 role, address account) internal virtual {
831         if (!hasRole(role, account)) {
832             _roles[role].members[account] = true;
833             emit RoleGranted(role, account, _msgSender());
834         }
835     }
836 
837     /**
838      * @dev Revokes `role` from `account`.
839      *
840      * Internal function without access restriction.
841      *
842      * May emit a {RoleRevoked} event.
843      */
844     function _revokeRole(bytes32 role, address account) internal virtual {
845         if (hasRole(role, account)) {
846             _roles[role].members[account] = false;
847             emit RoleRevoked(role, account, _msgSender());
848         }
849     }
850 }
851 
852 
853 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.2
854 
855 // License-Identifier: MIT
856 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
857 
858 pragma solidity ^0.8.0;
859 
860 /**
861  * @dev Contract module which provides a basic access control mechanism, where
862  * there is an account (an owner) that can be granted exclusive access to
863  * specific functions.
864  *
865  * By default, the owner account will be the one that deploys the contract. This
866  * can later be changed with {transferOwnership}.
867  *
868  * This module is used through inheritance. It will make available the modifier
869  * `onlyOwner`, which can be applied to your functions to restrict their use to
870  * the owner.
871  */
872 abstract contract Ownable is Context {
873     address private _owner;
874 
875     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
876 
877     /**
878      * @dev Initializes the contract setting the deployer as the initial owner.
879      */
880     constructor() {
881         _transferOwnership(_msgSender());
882     }
883 
884     /**
885      * @dev Throws if called by any account other than the owner.
886      */
887     modifier onlyOwner() {
888         _checkOwner();
889         _;
890     }
891 
892     /**
893      * @dev Returns the address of the current owner.
894      */
895     function owner() public view virtual returns (address) {
896         return _owner;
897     }
898 
899     /**
900      * @dev Throws if the sender is not the owner.
901      */
902     function _checkOwner() internal view virtual {
903         require(owner() == _msgSender(), "Ownable: caller is not the owner");
904     }
905 
906     /**
907      * @dev Leaves the contract without owner. It will not be possible to call
908      * `onlyOwner` functions anymore. Can only be called by the current owner.
909      *
910      * NOTE: Renouncing ownership will leave the contract without an owner,
911      * thereby removing any functionality that is only available to the owner.
912      */
913     function renounceOwnership() public virtual onlyOwner {
914         _transferOwnership(address(0));
915     }
916 
917     /**
918      * @dev Transfers ownership of the contract to a new account (`newOwner`).
919      * Can only be called by the current owner.
920      */
921     function transferOwnership(address newOwner) public virtual onlyOwner {
922         require(newOwner != address(0), "Ownable: new owner is the zero address");
923         _transferOwnership(newOwner);
924     }
925 
926     /**
927      * @dev Transfers ownership of the contract to a new account (`newOwner`).
928      * Internal function without access restriction.
929      */
930     function _transferOwnership(address newOwner) internal virtual {
931         address oldOwner = _owner;
932         _owner = newOwner;
933         emit OwnershipTransferred(oldOwner, newOwner);
934     }
935 }
936 
937 
938 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.2
939 
940 // License-Identifier: MIT
941 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 /**
946  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
947  *
948  * These functions can be used to verify that a message was signed by the holder
949  * of the private keys of a given address.
950  */
951 library ECDSA {
952     enum RecoverError {
953         NoError,
954         InvalidSignature,
955         InvalidSignatureLength,
956         InvalidSignatureS,
957         InvalidSignatureV // Deprecated in v4.8
958     }
959 
960     function _throwError(RecoverError error) private pure {
961         if (error == RecoverError.NoError) {
962             return; // no error: do nothing
963         } else if (error == RecoverError.InvalidSignature) {
964             revert("ECDSA: invalid signature");
965         } else if (error == RecoverError.InvalidSignatureLength) {
966             revert("ECDSA: invalid signature length");
967         } else if (error == RecoverError.InvalidSignatureS) {
968             revert("ECDSA: invalid signature 's' value");
969         }
970     }
971 
972     /**
973      * @dev Returns the address that signed a hashed message (`hash`) with
974      * `signature` or error string. This address can then be used for verification purposes.
975      *
976      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
977      * this function rejects them by requiring the `s` value to be in the lower
978      * half order, and the `v` value to be either 27 or 28.
979      *
980      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
981      * verification to be secure: it is possible to craft signatures that
982      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
983      * this is by receiving a hash of the original message (which may otherwise
984      * be too long), and then calling {toEthSignedMessageHash} on it.
985      *
986      * Documentation for signature generation:
987      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
988      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
989      *
990      * _Available since v4.3._
991      */
992     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
993         if (signature.length == 65) {
994             bytes32 r;
995             bytes32 s;
996             uint8 v;
997             // ecrecover takes the signature parameters, and the only way to get them
998             // currently is to use assembly.
999             /// @solidity memory-safe-assembly
1000             assembly {
1001                 r := mload(add(signature, 0x20))
1002                 s := mload(add(signature, 0x40))
1003                 v := byte(0, mload(add(signature, 0x60)))
1004             }
1005             return tryRecover(hash, v, r, s);
1006         } else {
1007             return (address(0), RecoverError.InvalidSignatureLength);
1008         }
1009     }
1010 
1011     /**
1012      * @dev Returns the address that signed a hashed message (`hash`) with
1013      * `signature`. This address can then be used for verification purposes.
1014      *
1015      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1016      * this function rejects them by requiring the `s` value to be in the lower
1017      * half order, and the `v` value to be either 27 or 28.
1018      *
1019      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1020      * verification to be secure: it is possible to craft signatures that
1021      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1022      * this is by receiving a hash of the original message (which may otherwise
1023      * be too long), and then calling {toEthSignedMessageHash} on it.
1024      */
1025     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1026         (address recovered, RecoverError error) = tryRecover(hash, signature);
1027         _throwError(error);
1028         return recovered;
1029     }
1030 
1031     /**
1032      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1033      *
1034      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1035      *
1036      * _Available since v4.3._
1037      */
1038     function tryRecover(
1039         bytes32 hash,
1040         bytes32 r,
1041         bytes32 vs
1042     ) internal pure returns (address, RecoverError) {
1043         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1044         uint8 v = uint8((uint256(vs) >> 255) + 27);
1045         return tryRecover(hash, v, r, s);
1046     }
1047 
1048     /**
1049      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1050      *
1051      * _Available since v4.2._
1052      */
1053     function recover(
1054         bytes32 hash,
1055         bytes32 r,
1056         bytes32 vs
1057     ) internal pure returns (address) {
1058         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1059         _throwError(error);
1060         return recovered;
1061     }
1062 
1063     /**
1064      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1065      * `r` and `s` signature fields separately.
1066      *
1067      * _Available since v4.3._
1068      */
1069     function tryRecover(
1070         bytes32 hash,
1071         uint8 v,
1072         bytes32 r,
1073         bytes32 s
1074     ) internal pure returns (address, RecoverError) {
1075         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1076         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1077         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1078         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1079         //
1080         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1081         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1082         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1083         // these malleable signatures as well.
1084         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1085             return (address(0), RecoverError.InvalidSignatureS);
1086         }
1087 
1088         // If the signature is valid (and not malleable), return the signer address
1089         address signer = ecrecover(hash, v, r, s);
1090         if (signer == address(0)) {
1091             return (address(0), RecoverError.InvalidSignature);
1092         }
1093 
1094         return (signer, RecoverError.NoError);
1095     }
1096 
1097     /**
1098      * @dev Overload of {ECDSA-recover} that receives the `v`,
1099      * `r` and `s` signature fields separately.
1100      */
1101     function recover(
1102         bytes32 hash,
1103         uint8 v,
1104         bytes32 r,
1105         bytes32 s
1106     ) internal pure returns (address) {
1107         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1108         _throwError(error);
1109         return recovered;
1110     }
1111 
1112     /**
1113      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1114      * produces hash corresponding to the one signed with the
1115      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1116      * JSON-RPC method as part of EIP-191.
1117      *
1118      * See {recover}.
1119      */
1120     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1121         // 32 is the length in bytes of hash,
1122         // enforced by the type signature above
1123         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1124     }
1125 
1126     /**
1127      * @dev Returns an Ethereum Signed Message, created from `s`. This
1128      * produces hash corresponding to the one signed with the
1129      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1130      * JSON-RPC method as part of EIP-191.
1131      *
1132      * See {recover}.
1133      */
1134     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1135         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1136     }
1137 
1138     /**
1139      * @dev Returns an Ethereum Signed Typed Data, created from a
1140      * `domainSeparator` and a `structHash`. This produces hash corresponding
1141      * to the one signed with the
1142      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1143      * JSON-RPC method as part of EIP-712.
1144      *
1145      * See {recover}.
1146      */
1147     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1148         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1149     }
1150 }
1151 
1152 
1153 // File erc721a/contracts/IERC721A.sol@v4.2.3
1154 
1155 // License-Identifier: MIT
1156 // ERC721A Contracts v4.2.3
1157 // Creator: Chiru Labs
1158 
1159 pragma solidity ^0.8.4;
1160 
1161 /**
1162  * @dev Interface of ERC721A.
1163  */
1164 interface IERC721A {
1165     /**
1166      * The caller must own the token or be an approved operator.
1167      */
1168     error ApprovalCallerNotOwnerNorApproved();
1169 
1170     /**
1171      * The token does not exist.
1172      */
1173     error ApprovalQueryForNonexistentToken();
1174 
1175     /**
1176      * Cannot query the balance for the zero address.
1177      */
1178     error BalanceQueryForZeroAddress();
1179 
1180     /**
1181      * Cannot mint to the zero address.
1182      */
1183     error MintToZeroAddress();
1184 
1185     /**
1186      * The quantity of tokens minted must be more than zero.
1187      */
1188     error MintZeroQuantity();
1189 
1190     /**
1191      * The token does not exist.
1192      */
1193     error OwnerQueryForNonexistentToken();
1194 
1195     /**
1196      * The caller must own the token or be an approved operator.
1197      */
1198     error TransferCallerNotOwnerNorApproved();
1199 
1200     /**
1201      * The token must be owned by `from`.
1202      */
1203     error TransferFromIncorrectOwner();
1204 
1205     /**
1206      * Cannot safely transfer to a contract that does not implement the
1207      * ERC721Receiver interface.
1208      */
1209     error TransferToNonERC721ReceiverImplementer();
1210 
1211     /**
1212      * Cannot transfer to the zero address.
1213      */
1214     error TransferToZeroAddress();
1215 
1216     /**
1217      * The token does not exist.
1218      */
1219     error URIQueryForNonexistentToken();
1220 
1221     /**
1222      * The `quantity` minted with ERC2309 exceeds the safety limit.
1223      */
1224     error MintERC2309QuantityExceedsLimit();
1225 
1226     /**
1227      * The `extraData` cannot be set on an unintialized ownership slot.
1228      */
1229     error OwnershipNotInitializedForExtraData();
1230 
1231     // =============================================================
1232     //                            STRUCTS
1233     // =============================================================
1234 
1235     struct TokenOwnership {
1236         // The address of the owner.
1237         address addr;
1238         // Stores the start time of ownership with minimal overhead for tokenomics.
1239         uint64 startTimestamp;
1240         // Whether the token has been burned.
1241         bool burned;
1242         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1243         uint24 extraData;
1244     }
1245 
1246     // =============================================================
1247     //                         TOKEN COUNTERS
1248     // =============================================================
1249 
1250     /**
1251      * @dev Returns the total number of tokens in existence.
1252      * Burned tokens will reduce the count.
1253      * To get the total number of tokens minted, please see {_totalMinted}.
1254      */
1255     function totalSupply() external view returns (uint256);
1256 
1257     // =============================================================
1258     //                            IERC165
1259     // =============================================================
1260 
1261     /**
1262      * @dev Returns true if this contract implements the interface defined by
1263      * `interfaceId`. See the corresponding
1264      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1265      * to learn more about how these ids are created.
1266      *
1267      * This function call must use less than 30000 gas.
1268      */
1269     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1270 
1271     // =============================================================
1272     //                            IERC721
1273     // =============================================================
1274 
1275     /**
1276      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1277      */
1278     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1279 
1280     /**
1281      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1282      */
1283     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1284 
1285     /**
1286      * @dev Emitted when `owner` enables or disables
1287      * (`approved`) `operator` to manage all of its assets.
1288      */
1289     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1290 
1291     /**
1292      * @dev Returns the number of tokens in `owner`'s account.
1293      */
1294     function balanceOf(address owner) external view returns (uint256 balance);
1295 
1296     /**
1297      * @dev Returns the owner of the `tokenId` token.
1298      *
1299      * Requirements:
1300      *
1301      * - `tokenId` must exist.
1302      */
1303     function ownerOf(uint256 tokenId) external view returns (address owner);
1304 
1305     /**
1306      * @dev Safely transfers `tokenId` token from `from` to `to`,
1307      * checking first that contract recipients are aware of the ERC721 protocol
1308      * to prevent tokens from being forever locked.
1309      *
1310      * Requirements:
1311      *
1312      * - `from` cannot be the zero address.
1313      * - `to` cannot be the zero address.
1314      * - `tokenId` token must exist and be owned by `from`.
1315      * - If the caller is not `from`, it must be have been allowed to move
1316      * this token by either {approve} or {setApprovalForAll}.
1317      * - If `to` refers to a smart contract, it must implement
1318      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1319      *
1320      * Emits a {Transfer} event.
1321      */
1322     function safeTransferFrom(
1323         address from,
1324         address to,
1325         uint256 tokenId,
1326         bytes calldata data
1327     ) external payable;
1328 
1329     /**
1330      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1331      */
1332     function safeTransferFrom(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) external payable;
1337 
1338     /**
1339      * @dev Transfers `tokenId` from `from` to `to`.
1340      *
1341      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1342      * whenever possible.
1343      *
1344      * Requirements:
1345      *
1346      * - `from` cannot be the zero address.
1347      * - `to` cannot be the zero address.
1348      * - `tokenId` token must be owned by `from`.
1349      * - If the caller is not `from`, it must be approved to move this token
1350      * by either {approve} or {setApprovalForAll}.
1351      *
1352      * Emits a {Transfer} event.
1353      */
1354     function transferFrom(
1355         address from,
1356         address to,
1357         uint256 tokenId
1358     ) external payable;
1359 
1360     /**
1361      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1362      * The approval is cleared when the token is transferred.
1363      *
1364      * Only a single account can be approved at a time, so approving the
1365      * zero address clears previous approvals.
1366      *
1367      * Requirements:
1368      *
1369      * - The caller must own the token or be an approved operator.
1370      * - `tokenId` must exist.
1371      *
1372      * Emits an {Approval} event.
1373      */
1374     function approve(address to, uint256 tokenId) external payable;
1375 
1376     /**
1377      * @dev Approve or remove `operator` as an operator for the caller.
1378      * Operators can call {transferFrom} or {safeTransferFrom}
1379      * for any token owned by the caller.
1380      *
1381      * Requirements:
1382      *
1383      * - The `operator` cannot be the caller.
1384      *
1385      * Emits an {ApprovalForAll} event.
1386      */
1387     function setApprovalForAll(address operator, bool _approved) external;
1388 
1389     /**
1390      * @dev Returns the account approved for `tokenId` token.
1391      *
1392      * Requirements:
1393      *
1394      * - `tokenId` must exist.
1395      */
1396     function getApproved(uint256 tokenId) external view returns (address operator);
1397 
1398     /**
1399      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1400      *
1401      * See {setApprovalForAll}.
1402      */
1403     function isApprovedForAll(address owner, address operator) external view returns (bool);
1404 
1405     // =============================================================
1406     //                        IERC721Metadata
1407     // =============================================================
1408 
1409     /**
1410      * @dev Returns the token collection name.
1411      */
1412     function name() external view returns (string memory);
1413 
1414     /**
1415      * @dev Returns the token collection symbol.
1416      */
1417     function symbol() external view returns (string memory);
1418 
1419     /**
1420      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1421      */
1422     function tokenURI(uint256 tokenId) external view returns (string memory);
1423 
1424     // =============================================================
1425     //                           IERC2309
1426     // =============================================================
1427 
1428     /**
1429      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1430      * (inclusive) is transferred from `from` to `to`, as defined in the
1431      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1432      *
1433      * See {_mintERC2309} for more details.
1434      */
1435     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1436 }
1437 
1438 
1439 // File erc721a/contracts/ERC721A.sol@v4.2.3
1440 
1441 // License-Identifier: MIT
1442 // ERC721A Contracts v4.2.3
1443 // Creator: Chiru Labs
1444 
1445 pragma solidity ^0.8.4;
1446 
1447 /**
1448  * @dev Interface of ERC721 token receiver.
1449  */
1450 interface ERC721A__IERC721Receiver {
1451     function onERC721Received(
1452         address operator,
1453         address from,
1454         uint256 tokenId,
1455         bytes calldata data
1456     ) external returns (bytes4);
1457 }
1458 
1459 /**
1460  * @title ERC721A
1461  *
1462  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1463  * Non-Fungible Token Standard, including the Metadata extension.
1464  * Optimized for lower gas during batch mints.
1465  *
1466  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1467  * starting from `_startTokenId()`.
1468  *
1469  * Assumptions:
1470  *
1471  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1472  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1473  */
1474 contract ERC721A is IERC721A {
1475     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1476     struct TokenApprovalRef {
1477         address value;
1478     }
1479 
1480     // =============================================================
1481     //                           CONSTANTS
1482     // =============================================================
1483 
1484     // Mask of an entry in packed address data.
1485     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1486 
1487     // The bit position of `numberMinted` in packed address data.
1488     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1489 
1490     // The bit position of `numberBurned` in packed address data.
1491     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1492 
1493     // The bit position of `aux` in packed address data.
1494     uint256 private constant _BITPOS_AUX = 192;
1495 
1496     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1497     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1498 
1499     // The bit position of `startTimestamp` in packed ownership.
1500     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1501 
1502     // The bit mask of the `burned` bit in packed ownership.
1503     uint256 private constant _BITMASK_BURNED = 1 << 224;
1504 
1505     // The bit position of the `nextInitialized` bit in packed ownership.
1506     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1507 
1508     // The bit mask of the `nextInitialized` bit in packed ownership.
1509     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1510 
1511     // The bit position of `extraData` in packed ownership.
1512     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1513 
1514     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1515     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1516 
1517     // The mask of the lower 160 bits for addresses.
1518     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1519 
1520     // The maximum `quantity` that can be minted with {_mintERC2309}.
1521     // This limit is to prevent overflows on the address data entries.
1522     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1523     // is required to cause an overflow, which is unrealistic.
1524     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1525 
1526     // The `Transfer` event signature is given by:
1527     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1528     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1529         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1530 
1531     // =============================================================
1532     //                            STORAGE
1533     // =============================================================
1534 
1535     // The next token ID to be minted.
1536     uint256 private _currentIndex;
1537 
1538     // The number of tokens burned.
1539     uint256 private _burnCounter;
1540 
1541     // Token name
1542     string private _name;
1543 
1544     // Token symbol
1545     string private _symbol;
1546 
1547     // Mapping from token ID to ownership details
1548     // An empty struct value does not necessarily mean the token is unowned.
1549     // See {_packedOwnershipOf} implementation for details.
1550     //
1551     // Bits Layout:
1552     // - [0..159]   `addr`
1553     // - [160..223] `startTimestamp`
1554     // - [224]      `burned`
1555     // - [225]      `nextInitialized`
1556     // - [232..255] `extraData`
1557     mapping(uint256 => uint256) private _packedOwnerships;
1558 
1559     // Mapping owner address to address data.
1560     //
1561     // Bits Layout:
1562     // - [0..63]    `balance`
1563     // - [64..127]  `numberMinted`
1564     // - [128..191] `numberBurned`
1565     // - [192..255] `aux`
1566     mapping(address => uint256) private _packedAddressData;
1567 
1568     // Mapping from token ID to approved address.
1569     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1570 
1571     // Mapping from owner to operator approvals
1572     mapping(address => mapping(address => bool)) private _operatorApprovals;
1573 
1574     // =============================================================
1575     //                          CONSTRUCTOR
1576     // =============================================================
1577 
1578     constructor(string memory name_, string memory symbol_) {
1579         _name = name_;
1580         _symbol = symbol_;
1581         _currentIndex = _startTokenId();
1582     }
1583 
1584     // =============================================================
1585     //                   TOKEN COUNTING OPERATIONS
1586     // =============================================================
1587 
1588     /**
1589      * @dev Returns the starting token ID.
1590      * To change the starting token ID, please override this function.
1591      */
1592     function _startTokenId() internal view virtual returns (uint256) {
1593         return 0;
1594     }
1595 
1596     /**
1597      * @dev Returns the next token ID to be minted.
1598      */
1599     function _nextTokenId() internal view virtual returns (uint256) {
1600         return _currentIndex;
1601     }
1602 
1603     /**
1604      * @dev Returns the total number of tokens in existence.
1605      * Burned tokens will reduce the count.
1606      * To get the total number of tokens minted, please see {_totalMinted}.
1607      */
1608     function totalSupply() public view virtual override returns (uint256) {
1609         // Counter underflow is impossible as _burnCounter cannot be incremented
1610         // more than `_currentIndex - _startTokenId()` times.
1611         unchecked {
1612             return _currentIndex - _burnCounter - _startTokenId();
1613         }
1614     }
1615 
1616     /**
1617      * @dev Returns the total amount of tokens minted in the contract.
1618      */
1619     function _totalMinted() internal view virtual returns (uint256) {
1620         // Counter underflow is impossible as `_currentIndex` does not decrement,
1621         // and it is initialized to `_startTokenId()`.
1622         unchecked {
1623             return _currentIndex - _startTokenId();
1624         }
1625     }
1626 
1627     /**
1628      * @dev Returns the total number of tokens burned.
1629      */
1630     function _totalBurned() internal view virtual returns (uint256) {
1631         return _burnCounter;
1632     }
1633 
1634     // =============================================================
1635     //                    ADDRESS DATA OPERATIONS
1636     // =============================================================
1637 
1638     /**
1639      * @dev Returns the number of tokens in `owner`'s account.
1640      */
1641     function balanceOf(address owner) public view virtual override returns (uint256) {
1642         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1643         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1644     }
1645 
1646     /**
1647      * Returns the number of tokens minted by `owner`.
1648      */
1649     function _numberMinted(address owner) internal view returns (uint256) {
1650         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1651     }
1652 
1653     /**
1654      * Returns the number of tokens burned by or on behalf of `owner`.
1655      */
1656     function _numberBurned(address owner) internal view returns (uint256) {
1657         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1658     }
1659 
1660     /**
1661      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1662      */
1663     function _getAux(address owner) internal view returns (uint64) {
1664         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1665     }
1666 
1667     /**
1668      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1669      * If there are multiple variables, please pack them into a uint64.
1670      */
1671     function _setAux(address owner, uint64 aux) internal virtual {
1672         uint256 packed = _packedAddressData[owner];
1673         uint256 auxCasted;
1674         // Cast `aux` with assembly to avoid redundant masking.
1675         assembly {
1676             auxCasted := aux
1677         }
1678         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1679         _packedAddressData[owner] = packed;
1680     }
1681 
1682     // =============================================================
1683     //                            IERC165
1684     // =============================================================
1685 
1686     /**
1687      * @dev Returns true if this contract implements the interface defined by
1688      * `interfaceId`. See the corresponding
1689      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1690      * to learn more about how these ids are created.
1691      *
1692      * This function call must use less than 30000 gas.
1693      */
1694     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1695         // The interface IDs are constants representing the first 4 bytes
1696         // of the XOR of all function selectors in the interface.
1697         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1698         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1699         return
1700             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1701             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1702             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1703     }
1704 
1705     // =============================================================
1706     //                        IERC721Metadata
1707     // =============================================================
1708 
1709     /**
1710      * @dev Returns the token collection name.
1711      */
1712     function name() public view virtual override returns (string memory) {
1713         return _name;
1714     }
1715 
1716     /**
1717      * @dev Returns the token collection symbol.
1718      */
1719     function symbol() public view virtual override returns (string memory) {
1720         return _symbol;
1721     }
1722 
1723     /**
1724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1725      */
1726     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1727         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1728 
1729         string memory baseURI = _baseURI();
1730         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1731     }
1732 
1733     /**
1734      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1735      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1736      * by default, it can be overridden in child contracts.
1737      */
1738     function _baseURI() internal view virtual returns (string memory) {
1739         return '';
1740     }
1741 
1742     // =============================================================
1743     //                     OWNERSHIPS OPERATIONS
1744     // =============================================================
1745 
1746     /**
1747      * @dev Returns the owner of the `tokenId` token.
1748      *
1749      * Requirements:
1750      *
1751      * - `tokenId` must exist.
1752      */
1753     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1754         return address(uint160(_packedOwnershipOf(tokenId)));
1755     }
1756 
1757     /**
1758      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1759      * It gradually moves to O(1) as tokens get transferred around over time.
1760      */
1761     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1762         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1763     }
1764 
1765     /**
1766      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1767      */
1768     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1769         return _unpackedOwnership(_packedOwnerships[index]);
1770     }
1771 
1772     /**
1773      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1774      */
1775     function _initializeOwnershipAt(uint256 index) internal virtual {
1776         if (_packedOwnerships[index] == 0) {
1777             _packedOwnerships[index] = _packedOwnershipOf(index);
1778         }
1779     }
1780 
1781     /**
1782      * Returns the packed ownership data of `tokenId`.
1783      */
1784     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1785         uint256 curr = tokenId;
1786 
1787         unchecked {
1788             if (_startTokenId() <= curr)
1789                 if (curr < _currentIndex) {
1790                     uint256 packed = _packedOwnerships[curr];
1791                     // If not burned.
1792                     if (packed & _BITMASK_BURNED == 0) {
1793                         // Invariant:
1794                         // There will always be an initialized ownership slot
1795                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1796                         // before an unintialized ownership slot
1797                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1798                         // Hence, `curr` will not underflow.
1799                         //
1800                         // We can directly compare the packed value.
1801                         // If the address is zero, packed will be zero.
1802                         while (packed == 0) {
1803                             packed = _packedOwnerships[--curr];
1804                         }
1805                         return packed;
1806                     }
1807                 }
1808         }
1809         revert OwnerQueryForNonexistentToken();
1810     }
1811 
1812     /**
1813      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1814      */
1815     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1816         ownership.addr = address(uint160(packed));
1817         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1818         ownership.burned = packed & _BITMASK_BURNED != 0;
1819         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1820     }
1821 
1822     /**
1823      * @dev Packs ownership data into a single uint256.
1824      */
1825     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1826         assembly {
1827             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1828             owner := and(owner, _BITMASK_ADDRESS)
1829             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1830             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1831         }
1832     }
1833 
1834     /**
1835      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1836      */
1837     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1838         // For branchless setting of the `nextInitialized` flag.
1839         assembly {
1840             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1841             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1842         }
1843     }
1844 
1845     // =============================================================
1846     //                      APPROVAL OPERATIONS
1847     // =============================================================
1848 
1849     /**
1850      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1851      * The approval is cleared when the token is transferred.
1852      *
1853      * Only a single account can be approved at a time, so approving the
1854      * zero address clears previous approvals.
1855      *
1856      * Requirements:
1857      *
1858      * - The caller must own the token or be an approved operator.
1859      * - `tokenId` must exist.
1860      *
1861      * Emits an {Approval} event.
1862      */
1863     function approve(address to, uint256 tokenId) public payable virtual override {
1864         address owner = ownerOf(tokenId);
1865 
1866         if (_msgSenderERC721A() != owner)
1867             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1868                 revert ApprovalCallerNotOwnerNorApproved();
1869             }
1870 
1871         _tokenApprovals[tokenId].value = to;
1872         emit Approval(owner, to, tokenId);
1873     }
1874 
1875     /**
1876      * @dev Returns the account approved for `tokenId` token.
1877      *
1878      * Requirements:
1879      *
1880      * - `tokenId` must exist.
1881      */
1882     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1883         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1884 
1885         return _tokenApprovals[tokenId].value;
1886     }
1887 
1888     /**
1889      * @dev Approve or remove `operator` as an operator for the caller.
1890      * Operators can call {transferFrom} or {safeTransferFrom}
1891      * for any token owned by the caller.
1892      *
1893      * Requirements:
1894      *
1895      * - The `operator` cannot be the caller.
1896      *
1897      * Emits an {ApprovalForAll} event.
1898      */
1899     function setApprovalForAll(address operator, bool approved) public virtual override {
1900         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1901         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1902     }
1903 
1904     /**
1905      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1906      *
1907      * See {setApprovalForAll}.
1908      */
1909     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1910         return _operatorApprovals[owner][operator];
1911     }
1912 
1913     /**
1914      * @dev Returns whether `tokenId` exists.
1915      *
1916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1917      *
1918      * Tokens start existing when they are minted. See {_mint}.
1919      */
1920     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1921         return
1922             _startTokenId() <= tokenId &&
1923             tokenId < _currentIndex && // If within bounds,
1924             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1925     }
1926 
1927     /**
1928      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1929      */
1930     function _isSenderApprovedOrOwner(
1931         address approvedAddress,
1932         address owner,
1933         address msgSender
1934     ) private pure returns (bool result) {
1935         assembly {
1936             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1937             owner := and(owner, _BITMASK_ADDRESS)
1938             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1939             msgSender := and(msgSender, _BITMASK_ADDRESS)
1940             // `msgSender == owner || msgSender == approvedAddress`.
1941             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1942         }
1943     }
1944 
1945     /**
1946      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1947      */
1948     function _getApprovedSlotAndAddress(uint256 tokenId)
1949         private
1950         view
1951         returns (uint256 approvedAddressSlot, address approvedAddress)
1952     {
1953         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1954         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1955         assembly {
1956             approvedAddressSlot := tokenApproval.slot
1957             approvedAddress := sload(approvedAddressSlot)
1958         }
1959     }
1960 
1961     // =============================================================
1962     //                      TRANSFER OPERATIONS
1963     // =============================================================
1964 
1965     /**
1966      * @dev Transfers `tokenId` from `from` to `to`.
1967      *
1968      * Requirements:
1969      *
1970      * - `from` cannot be the zero address.
1971      * - `to` cannot be the zero address.
1972      * - `tokenId` token must be owned by `from`.
1973      * - If the caller is not `from`, it must be approved to move this token
1974      * by either {approve} or {setApprovalForAll}.
1975      *
1976      * Emits a {Transfer} event.
1977      */
1978     function transferFrom(
1979         address from,
1980         address to,
1981         uint256 tokenId
1982     ) public payable virtual override {
1983         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1984 
1985         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1986 
1987         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1988 
1989         // The nested ifs save around 20+ gas over a compound boolean condition.
1990         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1991             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1992 
1993         if (to == address(0)) revert TransferToZeroAddress();
1994 
1995         _beforeTokenTransfers(from, to, tokenId, 1);
1996 
1997         // Clear approvals from the previous owner.
1998         assembly {
1999             if approvedAddress {
2000                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2001                 sstore(approvedAddressSlot, 0)
2002             }
2003         }
2004 
2005         // Underflow of the sender's balance is impossible because we check for
2006         // ownership above and the recipient's balance can't realistically overflow.
2007         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2008         unchecked {
2009             // We can directly increment and decrement the balances.
2010             --_packedAddressData[from]; // Updates: `balance -= 1`.
2011             ++_packedAddressData[to]; // Updates: `balance += 1`.
2012 
2013             // Updates:
2014             // - `address` to the next owner.
2015             // - `startTimestamp` to the timestamp of transfering.
2016             // - `burned` to `false`.
2017             // - `nextInitialized` to `true`.
2018             _packedOwnerships[tokenId] = _packOwnershipData(
2019                 to,
2020                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2021             );
2022 
2023             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2024             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2025                 uint256 nextTokenId = tokenId + 1;
2026                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2027                 if (_packedOwnerships[nextTokenId] == 0) {
2028                     // If the next slot is within bounds.
2029                     if (nextTokenId != _currentIndex) {
2030                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2031                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2032                     }
2033                 }
2034             }
2035         }
2036 
2037         emit Transfer(from, to, tokenId);
2038         _afterTokenTransfers(from, to, tokenId, 1);
2039     }
2040 
2041     /**
2042      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2043      */
2044     function safeTransferFrom(
2045         address from,
2046         address to,
2047         uint256 tokenId
2048     ) public payable virtual override {
2049         safeTransferFrom(from, to, tokenId, '');
2050     }
2051 
2052     /**
2053      * @dev Safely transfers `tokenId` token from `from` to `to`.
2054      *
2055      * Requirements:
2056      *
2057      * - `from` cannot be the zero address.
2058      * - `to` cannot be the zero address.
2059      * - `tokenId` token must exist and be owned by `from`.
2060      * - If the caller is not `from`, it must be approved to move this token
2061      * by either {approve} or {setApprovalForAll}.
2062      * - If `to` refers to a smart contract, it must implement
2063      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2064      *
2065      * Emits a {Transfer} event.
2066      */
2067     function safeTransferFrom(
2068         address from,
2069         address to,
2070         uint256 tokenId,
2071         bytes memory _data
2072     ) public payable virtual override {
2073         transferFrom(from, to, tokenId);
2074         if (to.code.length != 0)
2075             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2076                 revert TransferToNonERC721ReceiverImplementer();
2077             }
2078     }
2079 
2080     /**
2081      * @dev Hook that is called before a set of serially-ordered token IDs
2082      * are about to be transferred. This includes minting.
2083      * And also called before burning one token.
2084      *
2085      * `startTokenId` - the first token ID to be transferred.
2086      * `quantity` - the amount to be transferred.
2087      *
2088      * Calling conditions:
2089      *
2090      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2091      * transferred to `to`.
2092      * - When `from` is zero, `tokenId` will be minted for `to`.
2093      * - When `to` is zero, `tokenId` will be burned by `from`.
2094      * - `from` and `to` are never both zero.
2095      */
2096     function _beforeTokenTransfers(
2097         address from,
2098         address to,
2099         uint256 startTokenId,
2100         uint256 quantity
2101     ) internal virtual {}
2102 
2103     /**
2104      * @dev Hook that is called after a set of serially-ordered token IDs
2105      * have been transferred. This includes minting.
2106      * And also called after one token has been burned.
2107      *
2108      * `startTokenId` - the first token ID to be transferred.
2109      * `quantity` - the amount to be transferred.
2110      *
2111      * Calling conditions:
2112      *
2113      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2114      * transferred to `to`.
2115      * - When `from` is zero, `tokenId` has been minted for `to`.
2116      * - When `to` is zero, `tokenId` has been burned by `from`.
2117      * - `from` and `to` are never both zero.
2118      */
2119     function _afterTokenTransfers(
2120         address from,
2121         address to,
2122         uint256 startTokenId,
2123         uint256 quantity
2124     ) internal virtual {}
2125 
2126     /**
2127      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2128      *
2129      * `from` - Previous owner of the given token ID.
2130      * `to` - Target address that will receive the token.
2131      * `tokenId` - Token ID to be transferred.
2132      * `_data` - Optional data to send along with the call.
2133      *
2134      * Returns whether the call correctly returned the expected magic value.
2135      */
2136     function _checkContractOnERC721Received(
2137         address from,
2138         address to,
2139         uint256 tokenId,
2140         bytes memory _data
2141     ) private returns (bool) {
2142         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2143             bytes4 retval
2144         ) {
2145             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2146         } catch (bytes memory reason) {
2147             if (reason.length == 0) {
2148                 revert TransferToNonERC721ReceiverImplementer();
2149             } else {
2150                 assembly {
2151                     revert(add(32, reason), mload(reason))
2152                 }
2153             }
2154         }
2155     }
2156 
2157     // =============================================================
2158     //                        MINT OPERATIONS
2159     // =============================================================
2160 
2161     /**
2162      * @dev Mints `quantity` tokens and transfers them to `to`.
2163      *
2164      * Requirements:
2165      *
2166      * - `to` cannot be the zero address.
2167      * - `quantity` must be greater than 0.
2168      *
2169      * Emits a {Transfer} event for each mint.
2170      */
2171     function _mint(address to, uint256 quantity) internal virtual {
2172         uint256 startTokenId = _currentIndex;
2173         if (quantity == 0) revert MintZeroQuantity();
2174 
2175         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2176 
2177         // Overflows are incredibly unrealistic.
2178         // `balance` and `numberMinted` have a maximum limit of 2**64.
2179         // `tokenId` has a maximum limit of 2**256.
2180         unchecked {
2181             // Updates:
2182             // - `balance += quantity`.
2183             // - `numberMinted += quantity`.
2184             //
2185             // We can directly add to the `balance` and `numberMinted`.
2186             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2187 
2188             // Updates:
2189             // - `address` to the owner.
2190             // - `startTimestamp` to the timestamp of minting.
2191             // - `burned` to `false`.
2192             // - `nextInitialized` to `quantity == 1`.
2193             _packedOwnerships[startTokenId] = _packOwnershipData(
2194                 to,
2195                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2196             );
2197 
2198             uint256 toMasked;
2199             uint256 end = startTokenId + quantity;
2200 
2201             // Use assembly to loop and emit the `Transfer` event for gas savings.
2202             // The duplicated `log4` removes an extra check and reduces stack juggling.
2203             // The assembly, together with the surrounding Solidity code, have been
2204             // delicately arranged to nudge the compiler into producing optimized opcodes.
2205             assembly {
2206                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2207                 toMasked := and(to, _BITMASK_ADDRESS)
2208                 // Emit the `Transfer` event.
2209                 log4(
2210                     0, // Start of data (0, since no data).
2211                     0, // End of data (0, since no data).
2212                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2213                     0, // `address(0)`.
2214                     toMasked, // `to`.
2215                     startTokenId // `tokenId`.
2216                 )
2217 
2218                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2219                 // that overflows uint256 will make the loop run out of gas.
2220                 // The compiler will optimize the `iszero` away for performance.
2221                 for {
2222                     let tokenId := add(startTokenId, 1)
2223                 } iszero(eq(tokenId, end)) {
2224                     tokenId := add(tokenId, 1)
2225                 } {
2226                     // Emit the `Transfer` event. Similar to above.
2227                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2228                 }
2229             }
2230             if (toMasked == 0) revert MintToZeroAddress();
2231 
2232             _currentIndex = end;
2233         }
2234         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2235     }
2236 
2237     /**
2238      * @dev Mints `quantity` tokens and transfers them to `to`.
2239      *
2240      * This function is intended for efficient minting only during contract creation.
2241      *
2242      * It emits only one {ConsecutiveTransfer} as defined in
2243      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2244      * instead of a sequence of {Transfer} event(s).
2245      *
2246      * Calling this function outside of contract creation WILL make your contract
2247      * non-compliant with the ERC721 standard.
2248      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2249      * {ConsecutiveTransfer} event is only permissible during contract creation.
2250      *
2251      * Requirements:
2252      *
2253      * - `to` cannot be the zero address.
2254      * - `quantity` must be greater than 0.
2255      *
2256      * Emits a {ConsecutiveTransfer} event.
2257      */
2258     function _mintERC2309(address to, uint256 quantity) internal virtual {
2259         uint256 startTokenId = _currentIndex;
2260         if (to == address(0)) revert MintToZeroAddress();
2261         if (quantity == 0) revert MintZeroQuantity();
2262         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2263 
2264         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2265 
2266         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2267         unchecked {
2268             // Updates:
2269             // - `balance += quantity`.
2270             // - `numberMinted += quantity`.
2271             //
2272             // We can directly add to the `balance` and `numberMinted`.
2273             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2274 
2275             // Updates:
2276             // - `address` to the owner.
2277             // - `startTimestamp` to the timestamp of minting.
2278             // - `burned` to `false`.
2279             // - `nextInitialized` to `quantity == 1`.
2280             _packedOwnerships[startTokenId] = _packOwnershipData(
2281                 to,
2282                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2283             );
2284 
2285             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2286 
2287             _currentIndex = startTokenId + quantity;
2288         }
2289         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2290     }
2291 
2292     /**
2293      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2294      *
2295      * Requirements:
2296      *
2297      * - If `to` refers to a smart contract, it must implement
2298      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2299      * - `quantity` must be greater than 0.
2300      *
2301      * See {_mint}.
2302      *
2303      * Emits a {Transfer} event for each mint.
2304      */
2305     function _safeMint(
2306         address to,
2307         uint256 quantity,
2308         bytes memory _data
2309     ) internal virtual {
2310         _mint(to, quantity);
2311 
2312         unchecked {
2313             if (to.code.length != 0) {
2314                 uint256 end = _currentIndex;
2315                 uint256 index = end - quantity;
2316                 do {
2317                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2318                         revert TransferToNonERC721ReceiverImplementer();
2319                     }
2320                 } while (index < end);
2321                 // Reentrancy protection.
2322                 if (_currentIndex != end) revert();
2323             }
2324         }
2325     }
2326 
2327     /**
2328      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2329      */
2330     function _safeMint(address to, uint256 quantity) internal virtual {
2331         _safeMint(to, quantity, '');
2332     }
2333 
2334     // =============================================================
2335     //                        BURN OPERATIONS
2336     // =============================================================
2337 
2338     /**
2339      * @dev Equivalent to `_burn(tokenId, false)`.
2340      */
2341     function _burn(uint256 tokenId) internal virtual {
2342         _burn(tokenId, false);
2343     }
2344 
2345     /**
2346      * @dev Destroys `tokenId`.
2347      * The approval is cleared when the token is burned.
2348      *
2349      * Requirements:
2350      *
2351      * - `tokenId` must exist.
2352      *
2353      * Emits a {Transfer} event.
2354      */
2355     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2356         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2357 
2358         address from = address(uint160(prevOwnershipPacked));
2359 
2360         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2361 
2362         if (approvalCheck) {
2363             // The nested ifs save around 20+ gas over a compound boolean condition.
2364             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2365                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2366         }
2367 
2368         _beforeTokenTransfers(from, address(0), tokenId, 1);
2369 
2370         // Clear approvals from the previous owner.
2371         assembly {
2372             if approvedAddress {
2373                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2374                 sstore(approvedAddressSlot, 0)
2375             }
2376         }
2377 
2378         // Underflow of the sender's balance is impossible because we check for
2379         // ownership above and the recipient's balance can't realistically overflow.
2380         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2381         unchecked {
2382             // Updates:
2383             // - `balance -= 1`.
2384             // - `numberBurned += 1`.
2385             //
2386             // We can directly decrement the balance, and increment the number burned.
2387             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2388             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2389 
2390             // Updates:
2391             // - `address` to the last owner.
2392             // - `startTimestamp` to the timestamp of burning.
2393             // - `burned` to `true`.
2394             // - `nextInitialized` to `true`.
2395             _packedOwnerships[tokenId] = _packOwnershipData(
2396                 from,
2397                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2398             );
2399 
2400             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2401             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2402                 uint256 nextTokenId = tokenId + 1;
2403                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2404                 if (_packedOwnerships[nextTokenId] == 0) {
2405                     // If the next slot is within bounds.
2406                     if (nextTokenId != _currentIndex) {
2407                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2408                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2409                     }
2410                 }
2411             }
2412         }
2413 
2414         emit Transfer(from, address(0), tokenId);
2415         _afterTokenTransfers(from, address(0), tokenId, 1);
2416 
2417         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2418         unchecked {
2419             _burnCounter++;
2420         }
2421     }
2422 
2423     // =============================================================
2424     //                     EXTRA DATA OPERATIONS
2425     // =============================================================
2426 
2427     /**
2428      * @dev Directly sets the extra data for the ownership data `index`.
2429      */
2430     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2431         uint256 packed = _packedOwnerships[index];
2432         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2433         uint256 extraDataCasted;
2434         // Cast `extraData` with assembly to avoid redundant masking.
2435         assembly {
2436             extraDataCasted := extraData
2437         }
2438         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2439         _packedOwnerships[index] = packed;
2440     }
2441 
2442     /**
2443      * @dev Called during each token transfer to set the 24bit `extraData` field.
2444      * Intended to be overridden by the cosumer contract.
2445      *
2446      * `previousExtraData` - the value of `extraData` before transfer.
2447      *
2448      * Calling conditions:
2449      *
2450      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2451      * transferred to `to`.
2452      * - When `from` is zero, `tokenId` will be minted for `to`.
2453      * - When `to` is zero, `tokenId` will be burned by `from`.
2454      * - `from` and `to` are never both zero.
2455      */
2456     function _extraData(
2457         address from,
2458         address to,
2459         uint24 previousExtraData
2460     ) internal view virtual returns (uint24) {}
2461 
2462     /**
2463      * @dev Returns the next extra data for the packed ownership data.
2464      * The returned result is shifted into position.
2465      */
2466     function _nextExtraData(
2467         address from,
2468         address to,
2469         uint256 prevOwnershipPacked
2470     ) private view returns (uint256) {
2471         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2472         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2473     }
2474 
2475     // =============================================================
2476     //                       OTHER OPERATIONS
2477     // =============================================================
2478 
2479     /**
2480      * @dev Returns the message sender (defaults to `msg.sender`).
2481      *
2482      * If you are writing GSN compatible contracts, you need to override this function.
2483      */
2484     function _msgSenderERC721A() internal view virtual returns (address) {
2485         return msg.sender;
2486     }
2487 
2488     /**
2489      * @dev Converts a uint256 to its ASCII string decimal representation.
2490      */
2491     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2492         assembly {
2493             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2494             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2495             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2496             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2497             let m := add(mload(0x40), 0xa0)
2498             // Update the free memory pointer to allocate.
2499             mstore(0x40, m)
2500             // Assign the `str` to the end.
2501             str := sub(m, 0x20)
2502             // Zeroize the slot after the string.
2503             mstore(str, 0)
2504 
2505             // Cache the end of the memory to calculate the length later.
2506             let end := str
2507 
2508             // We write the string from rightmost digit to leftmost digit.
2509             // The following is essentially a do-while loop that also handles the zero case.
2510             // prettier-ignore
2511             for { let temp := value } 1 {} {
2512                 str := sub(str, 1)
2513                 // Write the character to the pointer.
2514                 // The ASCII index of the '0' character is 48.
2515                 mstore8(str, add(48, mod(temp, 10)))
2516                 // Keep dividing `temp` until zero.
2517                 temp := div(temp, 10)
2518                 // prettier-ignore
2519                 if iszero(temp) { break }
2520             }
2521 
2522             let length := sub(end, str)
2523             // Move the pointer 32 bytes leftwards to make room for the length.
2524             str := sub(str, 0x20)
2525             // Store the length.
2526             mstore(str, length)
2527         }
2528     }
2529 }
2530 
2531 
2532 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.2.3
2533 
2534 // License-Identifier: MIT
2535 // ERC721A Contracts v4.2.3
2536 // Creator: Chiru Labs
2537 
2538 pragma solidity ^0.8.4;
2539 
2540 /**
2541  * @dev Interface of ERC721AQueryable.
2542  */
2543 interface IERC721AQueryable is IERC721A {
2544     /**
2545      * Invalid query range (`start` >= `stop`).
2546      */
2547     error InvalidQueryRange();
2548 
2549     /**
2550      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2551      *
2552      * If the `tokenId` is out of bounds:
2553      *
2554      * - `addr = address(0)`
2555      * - `startTimestamp = 0`
2556      * - `burned = false`
2557      * - `extraData = 0`
2558      *
2559      * If the `tokenId` is burned:
2560      *
2561      * - `addr = <Address of owner before token was burned>`
2562      * - `startTimestamp = <Timestamp when token was burned>`
2563      * - `burned = true`
2564      * - `extraData = <Extra data when token was burned>`
2565      *
2566      * Otherwise:
2567      *
2568      * - `addr = <Address of owner>`
2569      * - `startTimestamp = <Timestamp of start of ownership>`
2570      * - `burned = false`
2571      * - `extraData = <Extra data at start of ownership>`
2572      */
2573     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2574 
2575     /**
2576      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2577      * See {ERC721AQueryable-explicitOwnershipOf}
2578      */
2579     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2580 
2581     /**
2582      * @dev Returns an array of token IDs owned by `owner`,
2583      * in the range [`start`, `stop`)
2584      * (i.e. `start <= tokenId < stop`).
2585      *
2586      * This function allows for tokens to be queried if the collection
2587      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2588      *
2589      * Requirements:
2590      *
2591      * - `start < stop`
2592      */
2593     function tokensOfOwnerIn(
2594         address owner,
2595         uint256 start,
2596         uint256 stop
2597     ) external view returns (uint256[] memory);
2598 
2599     /**
2600      * @dev Returns an array of token IDs owned by `owner`.
2601      *
2602      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2603      * It is meant to be called off-chain.
2604      *
2605      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2606      * multiple smaller scans if the collection is large enough to cause
2607      * an out-of-gas error (10K collections should be fine).
2608      */
2609     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2610 }
2611 
2612 
2613 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.2.3
2614 
2615 // License-Identifier: MIT
2616 // ERC721A Contracts v4.2.3
2617 // Creator: Chiru Labs
2618 
2619 pragma solidity ^0.8.4;
2620 
2621 
2622 /**
2623  * @title ERC721AQueryable.
2624  *
2625  * @dev ERC721A subclass with convenience query functions.
2626  */
2627 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2628     /**
2629      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2630      *
2631      * If the `tokenId` is out of bounds:
2632      *
2633      * - `addr = address(0)`
2634      * - `startTimestamp = 0`
2635      * - `burned = false`
2636      * - `extraData = 0`
2637      *
2638      * If the `tokenId` is burned:
2639      *
2640      * - `addr = <Address of owner before token was burned>`
2641      * - `startTimestamp = <Timestamp when token was burned>`
2642      * - `burned = true`
2643      * - `extraData = <Extra data when token was burned>`
2644      *
2645      * Otherwise:
2646      *
2647      * - `addr = <Address of owner>`
2648      * - `startTimestamp = <Timestamp of start of ownership>`
2649      * - `burned = false`
2650      * - `extraData = <Extra data at start of ownership>`
2651      */
2652     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2653         TokenOwnership memory ownership;
2654         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2655             return ownership;
2656         }
2657         ownership = _ownershipAt(tokenId);
2658         if (ownership.burned) {
2659             return ownership;
2660         }
2661         return _ownershipOf(tokenId);
2662     }
2663 
2664     /**
2665      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2666      * See {ERC721AQueryable-explicitOwnershipOf}
2667      */
2668     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2669         external
2670         view
2671         virtual
2672         override
2673         returns (TokenOwnership[] memory)
2674     {
2675         unchecked {
2676             uint256 tokenIdsLength = tokenIds.length;
2677             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2678             for (uint256 i; i != tokenIdsLength; ++i) {
2679                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2680             }
2681             return ownerships;
2682         }
2683     }
2684 
2685     /**
2686      * @dev Returns an array of token IDs owned by `owner`,
2687      * in the range [`start`, `stop`)
2688      * (i.e. `start <= tokenId < stop`).
2689      *
2690      * This function allows for tokens to be queried if the collection
2691      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2692      *
2693      * Requirements:
2694      *
2695      * - `start < stop`
2696      */
2697     function tokensOfOwnerIn(
2698         address owner,
2699         uint256 start,
2700         uint256 stop
2701     ) external view virtual override returns (uint256[] memory) {
2702         unchecked {
2703             if (start >= stop) revert InvalidQueryRange();
2704             uint256 tokenIdsIdx;
2705             uint256 stopLimit = _nextTokenId();
2706             // Set `start = max(start, _startTokenId())`.
2707             if (start < _startTokenId()) {
2708                 start = _startTokenId();
2709             }
2710             // Set `stop = min(stop, stopLimit)`.
2711             if (stop > stopLimit) {
2712                 stop = stopLimit;
2713             }
2714             uint256 tokenIdsMaxLength = balanceOf(owner);
2715             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2716             // to cater for cases where `balanceOf(owner)` is too big.
2717             if (start < stop) {
2718                 uint256 rangeLength = stop - start;
2719                 if (rangeLength < tokenIdsMaxLength) {
2720                     tokenIdsMaxLength = rangeLength;
2721                 }
2722             } else {
2723                 tokenIdsMaxLength = 0;
2724             }
2725             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2726             if (tokenIdsMaxLength == 0) {
2727                 return tokenIds;
2728             }
2729             // We need to call `explicitOwnershipOf(start)`,
2730             // because the slot at `start` may not be initialized.
2731             TokenOwnership memory ownership = explicitOwnershipOf(start);
2732             address currOwnershipAddr;
2733             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2734             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2735             if (!ownership.burned) {
2736                 currOwnershipAddr = ownership.addr;
2737             }
2738             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2739                 ownership = _ownershipAt(i);
2740                 if (ownership.burned) {
2741                     continue;
2742                 }
2743                 if (ownership.addr != address(0)) {
2744                     currOwnershipAddr = ownership.addr;
2745                 }
2746                 if (currOwnershipAddr == owner) {
2747                     tokenIds[tokenIdsIdx++] = i;
2748                 }
2749             }
2750             // Downsize the array to fit.
2751             assembly {
2752                 mstore(tokenIds, tokenIdsIdx)
2753             }
2754             return tokenIds;
2755         }
2756     }
2757 
2758     /**
2759      * @dev Returns an array of token IDs owned by `owner`.
2760      *
2761      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2762      * It is meant to be called off-chain.
2763      *
2764      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2765      * multiple smaller scans if the collection is large enough to cause
2766      * an out-of-gas error (10K collections should be fine).
2767      */
2768     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2769         unchecked {
2770             uint256 tokenIdsIdx;
2771             address currOwnershipAddr;
2772             uint256 tokenIdsLength = balanceOf(owner);
2773             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2774             TokenOwnership memory ownership;
2775             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2776                 ownership = _ownershipAt(i);
2777                 if (ownership.burned) {
2778                     continue;
2779                 }
2780                 if (ownership.addr != address(0)) {
2781                     currOwnershipAddr = ownership.addr;
2782                 }
2783                 if (currOwnershipAddr == owner) {
2784                     tokenIds[tokenIdsIdx++] = i;
2785                 }
2786             }
2787             return tokenIds;
2788         }
2789     }
2790 }
2791 
2792 
2793 // File operator-filter-registry/src/lib/Constants.sol@v1.4.0
2794 
2795 // License-Identifier: MIT
2796 pragma solidity ^0.8.17;
2797 
2798 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2799 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2800 
2801 
2802 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.4.0
2803 
2804 // License-Identifier: MIT
2805 pragma solidity ^0.8.13;
2806 
2807 interface IOperatorFilterRegistry {
2808     /**
2809      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
2810      *         true if supplied registrant address is not registered.
2811      */
2812     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2813 
2814     /**
2815      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
2816      */
2817     function register(address registrant) external;
2818 
2819     /**
2820      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
2821      */
2822     function registerAndSubscribe(address registrant, address subscription) external;
2823 
2824     /**
2825      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
2826      *         address without subscribing.
2827      */
2828     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2829 
2830     /**
2831      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
2832      *         Note that this does not remove any filtered addresses or codeHashes.
2833      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
2834      */
2835     function unregister(address addr) external;
2836 
2837     /**
2838      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
2839      */
2840     function updateOperator(address registrant, address operator, bool filtered) external;
2841 
2842     /**
2843      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
2844      */
2845     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2846 
2847     /**
2848      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
2849      */
2850     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2851 
2852     /**
2853      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
2854      */
2855     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2856 
2857     /**
2858      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
2859      *         subscription if present.
2860      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
2861      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
2862      *         used.
2863      */
2864     function subscribe(address registrant, address registrantToSubscribe) external;
2865 
2866     /**
2867      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
2868      */
2869     function unsubscribe(address registrant, bool copyExistingEntries) external;
2870 
2871     /**
2872      * @notice Get the subscription address of a given registrant, if any.
2873      */
2874     function subscriptionOf(address addr) external returns (address registrant);
2875 
2876     /**
2877      * @notice Get the set of addresses subscribed to a given registrant.
2878      *         Note that order is not guaranteed as updates are made.
2879      */
2880     function subscribers(address registrant) external returns (address[] memory);
2881 
2882     /**
2883      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
2884      *         Note that order is not guaranteed as updates are made.
2885      */
2886     function subscriberAt(address registrant, uint256 index) external returns (address);
2887 
2888     /**
2889      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
2890      */
2891     function copyEntriesOf(address registrant, address registrantToCopy) external;
2892 
2893     /**
2894      * @notice Returns true if operator is filtered by a given address or its subscription.
2895      */
2896     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2897 
2898     /**
2899      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
2900      */
2901     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2902 
2903     /**
2904      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2905      */
2906     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2907 
2908     /**
2909      * @notice Returns a list of filtered operators for a given address or its subscription.
2910      */
2911     function filteredOperators(address addr) external returns (address[] memory);
2912 
2913     /**
2914      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2915      *         Note that order is not guaranteed as updates are made.
2916      */
2917     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2918 
2919     /**
2920      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2921      *         its subscription.
2922      *         Note that order is not guaranteed as updates are made.
2923      */
2924     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2925 
2926     /**
2927      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2928      *         its subscription.
2929      *         Note that order is not guaranteed as updates are made.
2930      */
2931     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2932 
2933     /**
2934      * @notice Returns true if an address has registered
2935      */
2936     function isRegistered(address addr) external returns (bool);
2937 
2938     /**
2939      * @dev Convenience method to compute the code hash of an arbitrary contract
2940      */
2941     function codeHashOf(address addr) external returns (bytes32);
2942 }
2943 
2944 
2945 // File operator-filter-registry/src/UpdatableOperatorFilterer.sol@v1.4.0
2946 
2947 // License-Identifier: MIT
2948 pragma solidity ^0.8.13;
2949 
2950 /**
2951  * @title  UpdatableOperatorFilterer
2952  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2953  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
2954  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
2955  *         which will bypass registry checks.
2956  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
2957  *         on-chain, eg, if the registry is revoked or bypassed.
2958  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2959  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2960  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2961  */
2962 abstract contract UpdatableOperatorFilterer {
2963     /// @dev Emitted when an operator is not allowed.
2964     error OperatorNotAllowed(address operator);
2965     /// @dev Emitted when someone other than the owner is trying to call an only owner function.
2966     error OnlyOwner();
2967 
2968     event OperatorFilterRegistryAddressUpdated(address newRegistry);
2969 
2970     IOperatorFilterRegistry public operatorFilterRegistry;
2971 
2972     /// @dev The constructor that is called when the contract is being deployed.
2973     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
2974         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
2975         operatorFilterRegistry = registry;
2976         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2977         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2978         // order for the modifier to filter addresses.
2979         if (address(registry).code.length > 0) {
2980             if (subscribe) {
2981                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2982             } else {
2983                 if (subscriptionOrRegistrantToCopy != address(0)) {
2984                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2985                 } else {
2986                     registry.register(address(this));
2987                 }
2988             }
2989         }
2990     }
2991 
2992     /**
2993      * @dev A helper function to check if the operator is allowed.
2994      */
2995     modifier onlyAllowedOperator(address from) virtual {
2996         // Allow spending tokens from addresses with balance
2997         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2998         // from an EOA.
2999         if (from != msg.sender) {
3000             _checkFilterOperator(msg.sender);
3001         }
3002         _;
3003     }
3004 
3005     /**
3006      * @dev A helper function to check if the operator approval is allowed.
3007      */
3008     modifier onlyAllowedOperatorApproval(address operator) virtual {
3009         _checkFilterOperator(operator);
3010         _;
3011     }
3012 
3013     /**
3014      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
3015      *         address, checks will be bypassed. OnlyOwner.
3016      */
3017     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
3018         if (msg.sender != owner()) {
3019             revert OnlyOwner();
3020         }
3021         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
3022         emit OperatorFilterRegistryAddressUpdated(newRegistry);
3023     }
3024 
3025     /**
3026      * @dev Assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract.
3027      */
3028     function owner() public view virtual returns (address);
3029 
3030     /**
3031      * @dev A helper function to check if the operator is allowed.
3032      */
3033     function _checkFilterOperator(address operator) internal view virtual {
3034         IOperatorFilterRegistry registry = operatorFilterRegistry;
3035         // Check registry code length to facilitate testing in environments without a deployed registry.
3036         if (address(registry) != address(0) && address(registry).code.length > 0) {
3037             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
3038             // may specify their own OperatorFilterRegistry implementations, which may behave differently
3039             if (!registry.isOperatorAllowed(address(this), operator)) {
3040                 revert OperatorNotAllowed(operator);
3041             }
3042         }
3043     }
3044 }
3045 
3046 
3047 // File operator-filter-registry/src/RevokableOperatorFilterer.sol@v1.4.0
3048 
3049 // License-Identifier: MIT
3050 pragma solidity ^0.8.13;
3051 
3052 
3053 /**
3054  * @title  RevokableOperatorFilterer
3055  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
3056  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
3057  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
3058  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
3059  *         address cannot be further updated.
3060  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
3061  *         on-chain, eg, if the registry is revoked or bypassed.
3062  */
3063 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
3064     /// @dev Emitted when the registry has already been revoked.
3065     error RegistryHasBeenRevoked();
3066     /// @dev Emitted when the initial registry address is attempted to be set to the zero address.
3067     error InitialRegistryAddressCannotBeZeroAddress();
3068 
3069     event OperatorFilterRegistryRevoked();
3070 
3071     bool public isOperatorFilterRegistryRevoked;
3072 
3073     /// @dev The constructor that is called when the contract is being deployed.
3074     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
3075         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
3076     {
3077         // don't allow creating a contract with a permanently revoked registry
3078         if (_registry == address(0)) {
3079             revert InitialRegistryAddressCannotBeZeroAddress();
3080         }
3081     }
3082 
3083     /**
3084      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
3085      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
3086      */
3087     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
3088         if (msg.sender != owner()) {
3089             revert OnlyOwner();
3090         }
3091         // if registry has been revoked, do not allow further updates
3092         if (isOperatorFilterRegistryRevoked) {
3093             revert RegistryHasBeenRevoked();
3094         }
3095 
3096         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
3097         emit OperatorFilterRegistryAddressUpdated(newRegistry);
3098     }
3099 
3100     /**
3101      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
3102      */
3103     function revokeOperatorFilterRegistry() public {
3104         if (msg.sender != owner()) {
3105             revert OnlyOwner();
3106         }
3107         // if registry has been revoked, do not allow further updates
3108         if (isOperatorFilterRegistryRevoked) {
3109             revert RegistryHasBeenRevoked();
3110         }
3111 
3112         // set to zero address to bypass checks
3113         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
3114         isOperatorFilterRegistryRevoked = true;
3115         emit OperatorFilterRegistryRevoked();
3116     }
3117 }
3118 
3119 
3120 // File operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol@v1.4.0
3121 
3122 // License-Identifier: MIT
3123 pragma solidity ^0.8.13;
3124 
3125 
3126 /**
3127  * @title  RevokableDefaultOperatorFilterer
3128  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
3129  *         Note that OpenSea will disable creator earnings enforcement if filtered operators begin fulfilling orders
3130  *         on-chain, eg, if the registry is revoked or bypassed.
3131  */
3132 
3133 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
3134     /// @dev The constructor that is called when the contract is being deployed.
3135     constructor()
3136         RevokableOperatorFilterer(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS, CANONICAL_CORI_SUBSCRIPTION, true)
3137     {}
3138 }
3139 
3140 
3141 // File src/oasis/IApprovalProxy.sol
3142 
3143 // License-Identifier: MIT
3144 pragma solidity ^0.8.0;
3145 
3146 interface IApprovalProxy {
3147     function setApprovalForAll(
3148         address _owner,
3149         address _spender,
3150         bool _approved
3151     ) external;
3152 
3153     function isApprovedForAll(
3154         address _owner,
3155         address _spender,
3156         bool _approved
3157     ) external view returns (bool);
3158 }
3159 
3160 
3161 // File src/oasis/INFTOasis.sol
3162 
3163 // License-Identifier: MIT
3164 pragma solidity ^0.8.0;
3165 
3166 interface INFTOasis {
3167     function mint(address to, uint256 tokenId) external;
3168 
3169     function mint(
3170         address[] memory _toList,
3171         uint256[] memory tokenIdList
3172     ) external;
3173 
3174     function mintFor(address to, uint256 tokenId) external;
3175 
3176     function exists(uint256 tokenId) external view returns (bool);
3177 
3178     function setBaseURI(string memory __baseURI) external;
3179 }
3180 
3181 
3182 // File src/oasis/NFTOasisA.sol
3183 
3184 // License-Identifier: MIT
3185 pragma solidity ^0.8.4;
3186 
3187 
3188 
3189 
3190 
3191 contract NFTOasisA is ERC721AQueryable, INFTOasis, AccessControl, Ownable {
3192     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
3193 
3194     // `_baseURI` は関数で定義されているため、例外的な変数名の `baseURI_` にする.
3195     string internal baseURI_;
3196     string internal _tokenURIExtension;
3197 
3198     uint256 internal _totalOwner;
3199     uint256 internal _totalAirDrop;
3200 
3201     IApprovalProxy public approvalProxy;
3202 
3203     event UpdateApprovalProxy(address _newProxyContract);
3204 
3205     /**
3206      * @dev コンストラクタ.
3207      */
3208     constructor(
3209         string memory name_,
3210         string memory symbol_
3211     ) ERC721A(name_, symbol_) {
3212         _setRoleAdmin(MINTER_ROLE, MINTER_ROLE);
3213         _setupRole(MINTER_ROLE, _msgSender());
3214         _tokenURIExtension = ".json";
3215     }
3216 
3217     /**
3218      * @dev `1` からはじめる.
3219      */
3220     function _startTokenId() internal view virtual override returns (uint256) {
3221         return 1;
3222     }
3223 
3224     /**
3225      * @dev `to` に対してトークンを1つmintする. `tokenId` は無視される.
3226      */
3227     function mint(address to, uint256 /* tokenId */) public virtual {
3228         // 既存機能との互換性を保つため `tokenId` を受け入れるが、実際の処理では無視します。
3229         require(
3230             hasRole(MINTER_ROLE, _msgSender()),
3231             "ERC721Mintble: must have minter role to mint"
3232         );
3233 
3234         // `tokenId` を無視して、token を 1つだけmintする
3235         // (ここで指定する値は、tokenIdではなく発行量になる)
3236         _mint(to, 1);
3237         _totalAirDrop += 1;
3238     }
3239 
3240     /**
3241      * @dev `receivers` に対してトークンを1つずつmintする. `tokenIds` は無視される.
3242      */
3243     function mint(
3244         address[] memory receivers,
3245         uint256[] memory /* tokenIds */
3246     ) external virtual {
3247         // 既存機能との互換性を保つため `tokenIds` を受け入れるが、実際の処理では無視される
3248         // 使用しないので `tokenIds` の長さも検査しない
3249         for (uint256 i = 0; i < receivers.length; i++) {
3250             mint(receivers[i], 1);
3251         }
3252     }
3253 
3254     /**
3255      * @dev `to` に対してトークンを1つmintする. `tokenId` は無視される.
3256      */
3257     function mintFor(address to, uint256 tokenId) public virtual {
3258         mint(to, tokenId);
3259     }
3260 
3261     /**
3262      * @dev airdrop - 主に運営チームの確保用に使用するmint.
3263      */
3264     function doAirDrop(
3265         address receiver,
3266         uint256 quantity
3267     ) public virtual onlyOwner {
3268         _mint(receiver, quantity);
3269         _totalAirDrop += quantity;
3270     }
3271 
3272     /**
3273      * @dev transferの前処理.
3274      */
3275     function _beforeTokenTransfers(
3276         address from,
3277         address to,
3278         uint256 /* startTokenId */,
3279         uint256 /* quantity */
3280     ) internal virtual override {
3281         // 新規保有者が増えた時はカウントアップ
3282         if (to != address(0) && balanceOf(to) == 0) {
3283             unchecked {
3284                 _totalOwner++;
3285             }
3286         }
3287         // 既存の保有者の保有数が `0` になる時はカウントダウン
3288         if (from != address(0) && balanceOf(from) == 1 && _totalOwner > 0) {
3289             unchecked {
3290                 _totalOwner--;
3291             }
3292         }
3293     }
3294 
3295     /**
3296      * @dev NFTを保有しているオーナー数を返します.
3297      */
3298     function totalOwner() external view virtual returns (uint256) {
3299         return _totalOwner;
3300     }
3301 
3302     /**
3303      * @dev '支払いなし'で配布したNFT数を返します.
3304      */
3305     function totalAirDrop() external view virtual returns (uint256) {
3306         return _totalAirDrop;
3307     }
3308 
3309     /**
3310      * @dev `tokenId` に紐づくオーナー情報を返します.
3311      */
3312     function ownershipOf(
3313         uint256 tokenId
3314     ) external view virtual returns (TokenOwnership memory) {
3315         return _ownershipOf(tokenId);
3316     }
3317 
3318     /**
3319      * @dev `tokenId` が発行されていれば true を返します.
3320      */
3321     function exists(uint256 tokenId) external view virtual returns (bool) {
3322         return _exists(tokenId);
3323     }
3324 
3325     /**
3326      * @dev `tokenId` に対応するURIを返します.
3327      */
3328     function tokenURI(
3329         uint256 tokenId
3330     ) public view virtual override(ERC721A, IERC721A) returns (string memory) {
3331         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
3332 
3333         string memory baseURI = _baseURI();
3334 
3335         return
3336             bytes(baseURI).length != 0
3337                 ? string(
3338                     abi.encodePacked(
3339                         baseURI,
3340                         _toString(tokenId),
3341                         _tokenURIExtension
3342                     )
3343                 )
3344                 : "";
3345     }
3346 
3347     /**
3348      * @dev baseURIを変更する.
3349      */
3350     function setBaseURI(string calldata __baseURI) external virtual onlyOwner {
3351         baseURI_ = __baseURI;
3352     }
3353 
3354     /**
3355      * @dev tokenURIに付与する拡張子を変更する.
3356      */
3357     function setTokenURIExtension(
3358         string memory tokenURIExtension_
3359     ) external virtual onlyOwner {
3360         _tokenURIExtension = tokenURIExtension_;
3361     }
3362 
3363     /**
3364      * @dev `approvalProxy` を変更します.
3365      */
3366     function setApprovalProxy(address proxy) external virtual onlyOwner {
3367         approvalProxy = IApprovalProxy(proxy);
3368         emit UpdateApprovalProxy(proxy);
3369     }
3370 
3371     /**
3372      * @dev `operator` に権限がある場合は true を返します.
3373      */
3374     function isApprovedForAll(
3375         address owner_,
3376         address operator
3377     ) public view virtual override(ERC721A, IERC721A) returns (bool) {
3378         bool approved = super.isApprovedForAll(owner_, operator);
3379         if (address(approvalProxy) != address(0x0)) {
3380             return approvalProxy.isApprovedForAll(owner_, operator, approved);
3381         }
3382         return approved;
3383     }
3384 
3385     /**
3386      * @dev `operator` の権限を設定します.
3387      */
3388     function setApprovalForAll(
3389         address operator,
3390         bool approved
3391     ) public virtual override(ERC721A, IERC721A) {
3392         if (
3393             address(approvalProxy) != address(0x0) && operator.code.length > 0
3394         ) {
3395             approvalProxy.setApprovalForAll(msg.sender, operator, approved);
3396         }
3397         super.setApprovalForAll(operator, approved);
3398     }
3399 
3400     /**
3401      * @dev `interfaceId` をサポートしている場合は true を返します.
3402      */
3403     function supportsInterface(
3404         bytes4 interfaceId
3405     )
3406         public
3407         view
3408         virtual
3409         override(ERC721A, AccessControl, IERC721A)
3410         returns (bool)
3411     {
3412         return
3413             AccessControl.supportsInterface(interfaceId) ||
3414             ERC721A.supportsInterface(interfaceId);
3415     }
3416 
3417     /**
3418      * @dev baseURIを返します.
3419      */
3420     function _baseURI() internal view virtual override returns (string memory) {
3421         if (bytes(baseURI_).length > 0) {
3422             return baseURI_;
3423         }
3424 
3425         return
3426             string(
3427                 abi.encodePacked(
3428                     "https://nft.financie.io/metadata/",
3429                     symbol(),
3430                     "/"
3431                 )
3432             );
3433     }
3434 }
3435 
3436 
3437 // File src/Kamitsubaki.sol
3438 
3439 // License-Identifier: MIT
3440 pragma solidity ^0.8.17;
3441 
3442 
3443 
3444 
3445 contract Kamitsubaki is NFTOasisA, RevokableDefaultOperatorFilterer {
3446     // -------------------------
3447     // event
3448     // -------------------------
3449     event UpdateSupplyLimit(address sender, uint256 newSupplyLimit);
3450     event UpdateQuantityLimit(address sender, uint256 newQuantityLimit);
3451     event UpdateAllowListSalePrice(
3452         address sender,
3453         uint256 newAllowListSalePrice
3454     );
3455     event UpdatePayoutAddress(address sender, address newPayoutAddress);
3456     event UpdateSaleState(address sender, uint8 newSaleState);
3457 
3458     // -------------------------
3459     // error
3460     // -------------------------
3461     error MintQuantityExceedsLimitPerAddress();
3462     error MintSupplyExceedsLimit();
3463     error MintInvalidBodySigner();
3464     error MintInvalidHeadSigner();
3465     error MintInvalidValue();
3466     error NotOpenPreSaleOrNotOwner();
3467     error NotOpenPublicSaleOrNotOwner();
3468 
3469     // -------------------------
3470     // struct
3471     // -------------------------
3472     struct MintTicket {
3473         uint256 quantityLimit;
3474         bytes uuid;
3475         bytes headSignature;
3476         bytes bodySignature;
3477         address bodySigner;
3478         address receiver;
3479     }
3480 
3481     struct State {
3482         uint256 totalSupply;
3483         uint256 totalOwner;
3484         uint256 totalAirDrop;
3485         uint256 salePrice;
3486         uint256 supplyLimit;
3487         uint256 quantityLimit;
3488         address owner;
3489         address payoutAddress;
3490         bool isOpenedPreSale;
3491         bool isOpenedPublicSale;
3492         string name;
3493         string symbol;
3494     }
3495 
3496     struct AddressProps {
3497         uint256 balance;
3498         uint256 mintCount;
3499         uint256 publicSaleMintCount;
3500         uint256 allowListSaleMintCount;
3501     }
3502 
3503     // -------------------------
3504     // variable
3505     // -------------------------
3506     uint256 public salePrice;
3507     uint256 public supplyLimit;
3508     uint256 public quantityLimit;
3509     address payable public payoutAddress;
3510     uint8 internal _saleState;
3511 
3512     /**
3513      * @dev コンストラクタ.
3514      */
3515     constructor(
3516         string memory name_,
3517         string memory symbol_,
3518         uint256 salePrice_,
3519         uint256 supplyLimit_,
3520         uint256 quantityLimit_,
3521         address payoutAddress_
3522     ) NFTOasisA(name_, symbol_) {
3523         salePrice = salePrice_;
3524         supplyLimit = supplyLimit_;
3525         quantityLimit = quantityLimit_;
3526         if (address(0) != payoutAddress_) {
3527             payoutAddress = payable(payoutAddress_);
3528         } else {
3529             payoutAddress = payable(msg.sender);
3530         }
3531         _saleState = 0;
3532     }
3533 
3534     modifier whenOpenPreSaleOrOwner() {
3535         bool isOpenedPreSale = _saleState == 1 || _saleState == 3;
3536         if (!isOpenedPreSale && owner() != _msgSender())
3537             revert NotOpenPreSaleOrNotOwner();
3538         _;
3539     }
3540 
3541     modifier whenOpenPublicSaleOrOwner() {
3542         bool isOpenedPublicSale = _saleState == 2 || _saleState == 3;
3543         if (!isOpenedPublicSale && owner() != _msgSender())
3544             revert NotOpenPublicSaleOrNotOwner();
3545         _;
3546     }
3547 
3548     /**
3549      * @dev 供給上限を変更します.
3550      */
3551     function setSupplyLimit(uint256 supplyLimit_) external onlyOwner {
3552         supplyLimit = supplyLimit_;
3553         emit UpdateSupplyLimit(msg.sender, supplyLimit_);
3554     }
3555 
3556     /**
3557      * @dev 公開販売の1アドレスあたりのmint数上限を変更します.
3558      */
3559     function setQuantityLimit(uint256 quantityLimit_) external onlyOwner {
3560         quantityLimit = quantityLimit_;
3561         emit UpdateQuantityLimit(msg.sender, quantityLimit_);
3562     }
3563 
3564     /**
3565      * @dev 価格を変更します.
3566      */
3567     function setSalePrice(uint256 salePrice_) external onlyOwner {
3568         salePrice = salePrice_;
3569         emit UpdateAllowListSalePrice(msg.sender, salePrice_);
3570     }
3571 
3572     /**
3573      * @dev 支払い先アドレスを変更します.
3574      */
3575     function setPayoutAddress(address payoutAddress_) external onlyOwner {
3576         require(payoutAddress_ != address(0));
3577         payoutAddress = payable(payoutAddress_);
3578         emit UpdatePayoutAddress(msg.sender, payoutAddress_);
3579     }
3580 
3581     /**
3582      * @dev 販売状態を変更します.
3583      */
3584     function setSaleState(uint8 saleState_) external onlyOwner {
3585         // 0 ... close both pre sale and public sale.
3586         // 1 ... open pre sale (mint for allow list).
3587         // 2 ... open public sale (mint for public sale).
3588         // 3 ... open both pre sale and public sale.
3589         require(
3590             saleState_ == 0 ||
3591                 saleState_ == 1 ||
3592                 saleState_ == 2 ||
3593                 saleState_ == 3
3594         );
3595         _saleState = saleState_;
3596         emit UpdateSaleState(msg.sender, saleState_);
3597     }
3598 
3599     /**
3600      * @dev コントラクトの状態を返します.
3601      */
3602     function getState() external view returns (State memory) {
3603         bool isOpenedPreSale = _saleState == 1 || _saleState == 3;
3604         bool isOpenedPublicSale = _saleState == 2 || _saleState == 3;
3605         return
3606             State(
3607                 totalSupply(),
3608                 _totalOwner,
3609                 _totalAirDrop,
3610                 salePrice,
3611                 supplyLimit,
3612                 quantityLimit,
3613                 owner(),
3614                 payoutAddress,
3615                 isOpenedPreSale,
3616                 isOpenedPublicSale,
3617                 name(),
3618                 symbol()
3619             );
3620     }
3621 
3622     function _mint(address to, uint256 quantity) internal override {
3623         if (totalSupply() + quantity > supplyLimit)
3624             revert MintSupplyExceedsLimit();
3625 
3626         super._mint(to, quantity);
3627     }
3628 
3629     /**
3630      * @dev `owner_` の情報を返します.
3631      */
3632     function addressProps(
3633         address owner_
3634     ) external view returns (AddressProps memory) {
3635         return
3636             AddressProps(
3637                 balanceOf(owner_),
3638                 _numberMinted(owner_),
3639                 mintCountForPublicSale(owner_),
3640                 mintCountForAllowListSale(owner_)
3641             );
3642     }
3643 
3644     /**
3645      * @dev 公開販売用mint.
3646      */
3647     function mintForPublicSale(
3648         uint256 quantity
3649     ) external payable whenOpenPublicSaleOrOwner {
3650         uint64 mintCount = mintCountForPublicSale(msg.sender);
3651         if (mintCount + quantity > quantityLimit)
3652             revert MintQuantityExceedsLimitPerAddress();
3653         if (msg.value != (salePrice * quantity)) revert MintInvalidValue();
3654 
3655         _mint(msg.sender, quantity);
3656         unchecked {
3657             mintCount += uint64(quantity);
3658         }
3659         setMintCountForPublicSale(msg.sender, mintCount);
3660 
3661         (bool success, ) = payoutAddress.call{value: msg.value}("");
3662         require(success, "Transfer failed.");
3663     }
3664 
3665     /**
3666      * @dev AL販売用mint.
3667      */
3668     function mintForAllowListSale(
3669         MintTicket calldata mintTicket,
3670         uint256 quantity
3671     ) external payable whenOpenPreSaleOrOwner {
3672         uint64 mintCount = mintCountForAllowListSale(mintTicket.receiver);
3673         if (mintCount + quantity > mintTicket.quantityLimit)
3674             revert MintQuantityExceedsLimitPerAddress();
3675         if (msg.value != (salePrice * quantity)) revert MintInvalidValue();
3676 
3677         (address headSigner, address bodySigner) = _recoverSigners(mintTicket);
3678         if (headSigner != owner()) revert MintInvalidHeadSigner();
3679         if (bodySigner != mintTicket.bodySigner) revert MintInvalidBodySigner();
3680 
3681         _mint(mintTicket.receiver, quantity);
3682         unchecked {
3683             mintCount += uint64(quantity);
3684         }
3685         setMintCountForAllowListSale(mintTicket.receiver, mintCount);
3686 
3687         (bool success, ) = payoutAddress.call{value: msg.value}("");
3688         require(success, "Transfer failed.");
3689     }
3690 
3691     /**
3692      * @dev ALでmintした数を返す.
3693      */
3694     function mintCountForAllowListSale(
3695         address owner_
3696     ) public view returns (uint64) {
3697         // Auxフィールドの前半32bitがALのmint数
3698         return uint64((_getAux(owner_) & 0x00000000FFFFFFFF));
3699     }
3700 
3701     /**
3702      * @dev 公開販売でmintした数を返す.
3703      */
3704     function mintCountForPublicSale(
3705         address owner_
3706     ) public view returns (uint64) {
3707         // Auxフィールドの後半32bitが販売のmint数
3708         return uint64(_getAux(owner_) >> 32);
3709     }
3710 
3711     /**
3712      * @dev ALでmintした数を設定する.
3713      */
3714     function setMintCountForAllowListSale(
3715         address owner_,
3716         uint64 count
3717     ) internal {
3718         uint64 countForPublicSale = mintCountForPublicSale(owner_);
3719         _setAux(owner_, (countForPublicSale << 32) | count);
3720     }
3721 
3722     /**
3723      * @dev 公開販売でmintした数を設定する.
3724      */
3725     function setMintCountForPublicSale(address owner_, uint64 count) internal {
3726         uint64 countForAllowListSale = mintCountForAllowListSale(owner_);
3727         _setAux(owner_, (count << 32) | countForAllowListSale);
3728     }
3729 
3730     /**
3731      * @dev 署名者のアドレスをリカバリーして返す.
3732      */
3733     function _recoverSigners(
3734         MintTicket calldata mintTicket
3735     ) private pure returns (address, address) {
3736         bytes32 headHash = ECDSA.toEthSignedMessageHash(
3737             keccak256(abi.encodePacked(mintTicket.bodySigner))
3738         );
3739         address headSigner = ECDSA.recover(headHash, mintTicket.headSignature);
3740 
3741         bytes32 bodyHash = ECDSA.toEthSignedMessageHash(
3742             keccak256(
3743                 abi.encodePacked(
3744                     mintTicket.receiver,
3745                     mintTicket.uuid,
3746                     mintTicket.quantityLimit
3747                 )
3748             )
3749         );
3750         address bodySigner = ECDSA.recover(bodyHash, mintTicket.bodySignature);
3751 
3752         return (headSigner, bodySigner);
3753     }
3754 
3755     /**
3756      * @dev See {IERC721-setApprovalForAll}.
3757      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3758      */
3759     function setApprovalForAll(
3760         address operator,
3761         bool approved
3762     ) public override onlyAllowedOperatorApproval(operator) {
3763         super.setApprovalForAll(operator, approved);
3764     }
3765 
3766     /**
3767      * @dev See {IERC721-approve}.
3768      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3769      */
3770     function approve(
3771         address operator,
3772         uint256 tokenId
3773     )
3774         public
3775         payable
3776         override(ERC721A, IERC721A)
3777         onlyAllowedOperatorApproval(operator)
3778     {
3779         super.approve(operator, tokenId);
3780     }
3781 
3782     /**
3783      * @dev See {IERC721-transferFrom}.
3784      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3785      */
3786     function transferFrom(
3787         address from,
3788         address to,
3789         uint256 tokenId
3790     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3791         super.transferFrom(from, to, tokenId);
3792     }
3793 
3794     /**
3795      * @dev See {IERC721-safeTransferFrom}.
3796      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3797      */
3798     function safeTransferFrom(
3799         address from,
3800         address to,
3801         uint256 tokenId
3802     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3803         super.safeTransferFrom(from, to, tokenId);
3804     }
3805 
3806     /**
3807      * @dev See {IERC721-safeTransferFrom}.
3808      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
3809      */
3810     function safeTransferFrom(
3811         address from,
3812         address to,
3813         uint256 tokenId,
3814         bytes memory data
3815     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3816         super.safeTransferFrom(from, to, tokenId, data);
3817     }
3818 
3819     /**
3820      * @dev Returns the owner of the ERC721 token contract.
3821      */
3822     function owner()
3823         public
3824         view
3825         virtual
3826         override(Ownable, UpdatableOperatorFilterer)
3827         returns (address)
3828     {
3829         return Ownable.owner();
3830     }
3831 }
3832 
3833 
3834 // File src/ResidentGenesis.sol
3835 
3836 // SPDX-License-Identifier: MIT
3837 pragma solidity ^0.8.17;
3838 
3839 contract ResidentGenesis is Kamitsubaki {
3840     constructor()
3841         Kamitsubaki(
3842             // name
3843             "KAMITSUBAKIRG",
3844             // symbol
3845             "KRG",
3846             // allowListSalePrice(unit: wei)
3847             // 0.1 ETH -> 100000000000000000 wei
3848             135000000000000000,
3849             // supplyLimit
3850             5000,
3851             // quantityLimit for PublicSale
3852             2,
3853             // payoutAddress
3854             address(0xe8b9110CA629e2222D9503718eB9e7B954827A2D)
3855         )
3856     {}
3857 }