1 // File: @openzeppelin/contracts/access/IAccessControl.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 // File: @openzeppelin/contracts/utils/Context.sol
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/math/Math.sol
119 
120 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Standard math utilities missing in the Solidity language.
126  */
127 library Math {
128     enum Rounding {
129         Down, // Toward negative infinity
130         Up, // Toward infinity
131         Zero // Toward zero
132     }
133 
134     /**
135      * @dev Returns the largest of two numbers.
136      */
137     function max(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a > b ? a : b;
139     }
140 
141     /**
142      * @dev Returns the smallest of two numbers.
143      */
144     function min(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a < b ? a : b;
146     }
147 
148     /**
149      * @dev Returns the average of two numbers. The result is rounded towards
150      * zero.
151      */
152     function average(uint256 a, uint256 b) internal pure returns (uint256) {
153         // (a + b) / 2 can overflow.
154         return (a & b) + (a ^ b) / 2;
155     }
156 
157     /**
158      * @dev Returns the ceiling of the division of two numbers.
159      *
160      * This differs from standard division with `/` in that it rounds up instead
161      * of rounding down.
162      */
163     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
164         // (a + b - 1) / b can overflow on addition, so we distribute.
165         return a == 0 ? 0 : (a - 1) / b + 1;
166     }
167 
168     /**
169      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
170      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
171      * with further edits by Uniswap Labs also under MIT license.
172      */
173     function mulDiv(
174         uint256 x,
175         uint256 y,
176         uint256 denominator
177     ) internal pure returns (uint256 result) {
178         unchecked {
179             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
180             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
181             // variables such that product = prod1 * 2^256 + prod0.
182             uint256 prod0; // Least significant 256 bits of the product
183             uint256 prod1; // Most significant 256 bits of the product
184             assembly {
185                 let mm := mulmod(x, y, not(0))
186                 prod0 := mul(x, y)
187                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
188             }
189 
190             // Handle non-overflow cases, 256 by 256 division.
191             if (prod1 == 0) {
192                 return prod0 / denominator;
193             }
194 
195             // Make sure the result is less than 2^256. Also prevents denominator == 0.
196             require(denominator > prod1);
197 
198             ///////////////////////////////////////////////
199             // 512 by 256 division.
200             ///////////////////////////////////////////////
201 
202             // Make division exact by subtracting the remainder from [prod1 prod0].
203             uint256 remainder;
204             assembly {
205                 // Compute remainder using mulmod.
206                 remainder := mulmod(x, y, denominator)
207 
208                 // Subtract 256 bit number from 512 bit number.
209                 prod1 := sub(prod1, gt(remainder, prod0))
210                 prod0 := sub(prod0, remainder)
211             }
212 
213             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
214             // See https://cs.stackexchange.com/q/138556/92363.
215 
216             // Does not overflow because the denominator cannot be zero at this stage in the function.
217             uint256 twos = denominator & (~denominator + 1);
218             assembly {
219                 // Divide denominator by twos.
220                 denominator := div(denominator, twos)
221 
222                 // Divide [prod1 prod0] by twos.
223                 prod0 := div(prod0, twos)
224 
225                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
226                 twos := add(div(sub(0, twos), twos), 1)
227             }
228 
229             // Shift in bits from prod1 into prod0.
230             prod0 |= prod1 * twos;
231 
232             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
233             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
234             // four bits. That is, denominator * inv = 1 mod 2^4.
235             uint256 inverse = (3 * denominator) ^ 2;
236 
237             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
238             // in modular arithmetic, doubling the correct bits in each step.
239             inverse *= 2 - denominator * inverse; // inverse mod 2^8
240             inverse *= 2 - denominator * inverse; // inverse mod 2^16
241             inverse *= 2 - denominator * inverse; // inverse mod 2^32
242             inverse *= 2 - denominator * inverse; // inverse mod 2^64
243             inverse *= 2 - denominator * inverse; // inverse mod 2^128
244             inverse *= 2 - denominator * inverse; // inverse mod 2^256
245 
246             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
247             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
248             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
249             // is no longer required.
250             result = prod0 * inverse;
251             return result;
252         }
253     }
254 
255     /**
256      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
257      */
258     function mulDiv(
259         uint256 x,
260         uint256 y,
261         uint256 denominator,
262         Rounding rounding
263     ) internal pure returns (uint256) {
264         uint256 result = mulDiv(x, y, denominator);
265         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
266             result += 1;
267         }
268         return result;
269     }
270 
271     /**
272      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
273      *
274      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
275      */
276     function sqrt(uint256 a) internal pure returns (uint256) {
277         if (a == 0) {
278             return 0;
279         }
280 
281         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
282         //
283         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
284         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
285         //
286         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
287         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
288         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
289         //
290         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
291         uint256 result = 1 << (log2(a) >> 1);
292 
293         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
294         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
295         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
296         // into the expected uint128 result.
297         unchecked {
298             result = (result + a / result) >> 1;
299             result = (result + a / result) >> 1;
300             result = (result + a / result) >> 1;
301             result = (result + a / result) >> 1;
302             result = (result + a / result) >> 1;
303             result = (result + a / result) >> 1;
304             result = (result + a / result) >> 1;
305             return min(result, a / result);
306         }
307     }
308 
309     /**
310      * @notice Calculates sqrt(a), following the selected rounding direction.
311      */
312     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
313         unchecked {
314             uint256 result = sqrt(a);
315             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
316         }
317     }
318 
319     /**
320      * @dev Return the log in base 2, rounded down, of a positive value.
321      * Returns 0 if given 0.
322      */
323     function log2(uint256 value) internal pure returns (uint256) {
324         uint256 result = 0;
325         unchecked {
326             if (value >> 128 > 0) {
327                 value >>= 128;
328                 result += 128;
329             }
330             if (value >> 64 > 0) {
331                 value >>= 64;
332                 result += 64;
333             }
334             if (value >> 32 > 0) {
335                 value >>= 32;
336                 result += 32;
337             }
338             if (value >> 16 > 0) {
339                 value >>= 16;
340                 result += 16;
341             }
342             if (value >> 8 > 0) {
343                 value >>= 8;
344                 result += 8;
345             }
346             if (value >> 4 > 0) {
347                 value >>= 4;
348                 result += 4;
349             }
350             if (value >> 2 > 0) {
351                 value >>= 2;
352                 result += 2;
353             }
354             if (value >> 1 > 0) {
355                 result += 1;
356             }
357         }
358         return result;
359     }
360 
361     /**
362      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
363      * Returns 0 if given 0.
364      */
365     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
366         unchecked {
367             uint256 result = log2(value);
368             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
369         }
370     }
371 
372     /**
373      * @dev Return the log in base 10, rounded down, of a positive value.
374      * Returns 0 if given 0.
375      */
376     function log10(uint256 value) internal pure returns (uint256) {
377         uint256 result = 0;
378         unchecked {
379             if (value >= 10**64) {
380                 value /= 10**64;
381                 result += 64;
382             }
383             if (value >= 10**32) {
384                 value /= 10**32;
385                 result += 32;
386             }
387             if (value >= 10**16) {
388                 value /= 10**16;
389                 result += 16;
390             }
391             if (value >= 10**8) {
392                 value /= 10**8;
393                 result += 8;
394             }
395             if (value >= 10**4) {
396                 value /= 10**4;
397                 result += 4;
398             }
399             if (value >= 10**2) {
400                 value /= 10**2;
401                 result += 2;
402             }
403             if (value >= 10**1) {
404                 result += 1;
405             }
406         }
407         return result;
408     }
409 
410     /**
411      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
412      * Returns 0 if given 0.
413      */
414     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
415         unchecked {
416             uint256 result = log10(value);
417             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
418         }
419     }
420 
421     /**
422      * @dev Return the log in base 256, rounded down, of a positive value.
423      * Returns 0 if given 0.
424      *
425      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
426      */
427     function log256(uint256 value) internal pure returns (uint256) {
428         uint256 result = 0;
429         unchecked {
430             if (value >> 128 > 0) {
431                 value >>= 128;
432                 result += 16;
433             }
434             if (value >> 64 > 0) {
435                 value >>= 64;
436                 result += 8;
437             }
438             if (value >> 32 > 0) {
439                 value >>= 32;
440                 result += 4;
441             }
442             if (value >> 16 > 0) {
443                 value >>= 16;
444                 result += 2;
445             }
446             if (value >> 8 > 0) {
447                 result += 1;
448             }
449         }
450         return result;
451     }
452 
453     /**
454      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
455      * Returns 0 if given 0.
456      */
457     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
458         unchecked {
459             uint256 result = log256(value);
460             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/utils/Strings.sol
466 
467 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev String operations.
473  */
474 library Strings {
475     bytes16 private constant _SYMBOLS = "0123456789abcdef";
476     uint8 private constant _ADDRESS_LENGTH = 20;
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
480      */
481     function toString(uint256 value) internal pure returns (string memory) {
482         unchecked {
483             uint256 length = Math.log10(value) + 1;
484             string memory buffer = new string(length);
485             uint256 ptr;
486             /// @solidity memory-safe-assembly
487             assembly {
488                 ptr := add(buffer, add(32, length))
489             }
490             while (true) {
491                 ptr--;
492                 /// @solidity memory-safe-assembly
493                 assembly {
494                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
495                 }
496                 value /= 10;
497                 if (value == 0) break;
498             }
499             return buffer;
500         }
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
505      */
506     function toHexString(uint256 value) internal pure returns (string memory) {
507         unchecked {
508             return toHexString(value, Math.log256(value) + 1);
509         }
510     }
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
514      */
515     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
516         bytes memory buffer = new bytes(2 * length + 2);
517         buffer[0] = "0";
518         buffer[1] = "x";
519         for (uint256 i = 2 * length + 1; i > 1; --i) {
520             buffer[i] = _SYMBOLS[value & 0xf];
521             value >>= 4;
522         }
523         require(value == 0, "Strings: hex length insufficient");
524         return string(buffer);
525     }
526 
527     /**
528      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
529      */
530     function toHexString(address addr) internal pure returns (string memory) {
531         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Interface of the ERC165 standard, as defined in the
543  * https://eips.ethereum.org/EIPS/eip-165[EIP].
544  *
545  * Implementers can declare support of contract interfaces, which can then be
546  * queried by others ({ERC165Checker}).
547  *
548  * For an implementation, see {ERC165}.
549  */
550 interface IERC165 {
551     /**
552      * @dev Returns true if this contract implements the interface defined by
553      * `interfaceId`. See the corresponding
554      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
555      * to learn more about how these ids are created.
556      *
557      * This function call must use less than 30 000 gas.
558      */
559     function supportsInterface(bytes4 interfaceId) external view returns (bool);
560 }
561 
562 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
563 
564 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev Implementation of the {IERC165} interface.
570  *
571  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
572  * for the additional interface id that will be supported. For example:
573  *
574  * ```solidity
575  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
577  * }
578  * ```
579  *
580  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
581  */
582 abstract contract ERC165 is IERC165 {
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587         return interfaceId == type(IERC165).interfaceId;
588     }
589 }
590 
591 // File: @openzeppelin/contracts/access/AccessControl.sol
592 
593 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 
599 
600 /**
601  * @dev Contract module that allows children to implement role-based access
602  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
603  * members except through off-chain means by accessing the contract event logs. Some
604  * applications may benefit from on-chain enumerability, for those cases see
605  * {AccessControlEnumerable}.
606  *
607  * Roles are referred to by their `bytes32` identifier. These should be exposed
608  * in the external API and be unique. The best way to achieve this is by
609  * using `public constant` hash digests:
610  *
611  * ```
612  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
613  * ```
614  *
615  * Roles can be used to represent a set of permissions. To restrict access to a
616  * function call, use {hasRole}:
617  *
618  * ```
619  * function foo() public {
620  *     require(hasRole(MY_ROLE, msg.sender));
621  *     ...
622  * }
623  * ```
624  *
625  * Roles can be granted and revoked dynamically via the {grantRole} and
626  * {revokeRole} functions. Each role has an associated admin role, and only
627  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
628  *
629  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
630  * that only accounts with this role will be able to grant or revoke other
631  * roles. More complex role relationships can be created by using
632  * {_setRoleAdmin}.
633  *
634  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
635  * grant and revoke this role. Extra precautions should be taken to secure
636  * accounts that have been granted it.
637  */
638 abstract contract AccessControl is Context, IAccessControl, ERC165 {
639     struct RoleData {
640         mapping(address => bool) members;
641         bytes32 adminRole;
642     }
643 
644     mapping(bytes32 => RoleData) private _roles;
645 
646     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
647 
648     /**
649      * @dev Modifier that checks that an account has a specific role. Reverts
650      * with a standardized message including the required role.
651      *
652      * The format of the revert reason is given by the following regular expression:
653      *
654      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
655      *
656      * _Available since v4.1._
657      */
658     modifier onlyRole(bytes32 role) {
659         _checkRole(role);
660         _;
661     }
662 
663     /**
664      * @dev See {IERC165-supportsInterface}.
665      */
666     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
667         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
668     }
669 
670     /**
671      * @dev Returns `true` if `account` has been granted `role`.
672      */
673     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
674         return _roles[role].members[account];
675     }
676 
677     /**
678      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
679      * Overriding this function changes the behavior of the {onlyRole} modifier.
680      *
681      * Format of the revert message is described in {_checkRole}.
682      *
683      * _Available since v4.6._
684      */
685     function _checkRole(bytes32 role) internal view virtual {
686         _checkRole(role, _msgSender());
687     }
688 
689     /**
690      * @dev Revert with a standard message if `account` is missing `role`.
691      *
692      * The format of the revert reason is given by the following regular expression:
693      *
694      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
695      */
696     function _checkRole(bytes32 role, address account) internal view virtual {
697         if (!hasRole(role, account)) {
698             revert(
699                 string(
700                     abi.encodePacked(
701                         "AccessControl: account ",
702                         Strings.toHexString(account),
703                         " is missing role ",
704                         Strings.toHexString(uint256(role), 32)
705                     )
706                 )
707             );
708         }
709     }
710 
711     /**
712      * @dev Returns the admin role that controls `role`. See {grantRole} and
713      * {revokeRole}.
714      *
715      * To change a role's admin, use {_setRoleAdmin}.
716      */
717     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
718         return _roles[role].adminRole;
719     }
720 
721     /**
722      * @dev Grants `role` to `account`.
723      *
724      * If `account` had not been already granted `role`, emits a {RoleGranted}
725      * event.
726      *
727      * Requirements:
728      *
729      * - the caller must have ``role``'s admin role.
730      *
731      * May emit a {RoleGranted} event.
732      */
733     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
734         _grantRole(role, account);
735     }
736 
737     /**
738      * @dev Revokes `role` from `account`.
739      *
740      * If `account` had been granted `role`, emits a {RoleRevoked} event.
741      *
742      * Requirements:
743      *
744      * - the caller must have ``role``'s admin role.
745      *
746      * May emit a {RoleRevoked} event.
747      */
748     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
749         _revokeRole(role, account);
750     }
751 
752     /**
753      * @dev Revokes `role` from the calling account.
754      *
755      * Roles are often managed via {grantRole} and {revokeRole}: this function's
756      * purpose is to provide a mechanism for accounts to lose their privileges
757      * if they are compromised (such as when a trusted device is misplaced).
758      *
759      * If the calling account had been revoked `role`, emits a {RoleRevoked}
760      * event.
761      *
762      * Requirements:
763      *
764      * - the caller must be `account`.
765      *
766      * May emit a {RoleRevoked} event.
767      */
768     function renounceRole(bytes32 role, address account) public virtual override {
769         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
770 
771         _revokeRole(role, account);
772     }
773 
774     /**
775      * @dev Grants `role` to `account`.
776      *
777      * If `account` had not been already granted `role`, emits a {RoleGranted}
778      * event. Note that unlike {grantRole}, this function doesn't perform any
779      * checks on the calling account.
780      *
781      * May emit a {RoleGranted} event.
782      *
783      * [WARNING]
784      * ====
785      * This function should only be called from the constructor when setting
786      * up the initial roles for the system.
787      *
788      * Using this function in any other way is effectively circumventing the admin
789      * system imposed by {AccessControl}.
790      * ====
791      *
792      * NOTE: This function is deprecated in favor of {_grantRole}.
793      */
794     function _setupRole(bytes32 role, address account) internal virtual {
795         _grantRole(role, account);
796     }
797 
798     /**
799      * @dev Sets `adminRole` as ``role``'s admin role.
800      *
801      * Emits a {RoleAdminChanged} event.
802      */
803     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
804         bytes32 previousAdminRole = getRoleAdmin(role);
805         _roles[role].adminRole = adminRole;
806         emit RoleAdminChanged(role, previousAdminRole, adminRole);
807     }
808 
809     /**
810      * @dev Grants `role` to `account`.
811      *
812      * Internal function without access restriction.
813      *
814      * May emit a {RoleGranted} event.
815      */
816     function _grantRole(bytes32 role, address account) internal virtual {
817         if (!hasRole(role, account)) {
818             _roles[role].members[account] = true;
819             emit RoleGranted(role, account, _msgSender());
820         }
821     }
822 
823     /**
824      * @dev Revokes `role` from `account`.
825      *
826      * Internal function without access restriction.
827      *
828      * May emit a {RoleRevoked} event.
829      */
830     function _revokeRole(bytes32 role, address account) internal virtual {
831         if (hasRole(role, account)) {
832             _roles[role].members[account] = false;
833             emit RoleRevoked(role, account, _msgSender());
834         }
835     }
836 }
837 
838 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
839 
840 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev Contract module that helps prevent reentrant calls to a function.
846  *
847  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
848  * available, which can be applied to functions to make sure there are no nested
849  * (reentrant) calls to them.
850  *
851  * Note that because there is a single `nonReentrant` guard, functions marked as
852  * `nonReentrant` may not call one another. This can be worked around by making
853  * those functions `private`, and then adding `external` `nonReentrant` entry
854  * points to them.
855  *
856  * TIP: If you would like to learn more about reentrancy and alternative ways
857  * to protect against it, check out our blog post
858  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
859  */
860 abstract contract ReentrancyGuard {
861     // Booleans are more expensive than uint256 or any type that takes up a full
862     // word because each write operation emits an extra SLOAD to first read the
863     // slot's contents, replace the bits taken up by the boolean, and then write
864     // back. This is the compiler's defense against contract upgrades and
865     // pointer aliasing, and it cannot be disabled.
866 
867     // The values being non-zero value makes deployment a bit more expensive,
868     // but in exchange the refund on every call to nonReentrant will be lower in
869     // amount. Since refunds are capped to a percentage of the total
870     // transaction's gas, it is best to keep them low in cases like this one, to
871     // increase the likelihood of the full refund coming into effect.
872     uint256 private constant _NOT_ENTERED = 1;
873     uint256 private constant _ENTERED = 2;
874 
875     uint256 private _status;
876 
877     constructor() {
878         _status = _NOT_ENTERED;
879     }
880 
881     /**
882      * @dev Prevents a contract from calling itself, directly or indirectly.
883      * Calling a `nonReentrant` function from another `nonReentrant`
884      * function is not supported. It is possible to prevent this from happening
885      * by making the `nonReentrant` function external, and making it call a
886      * `private` function that does the actual work.
887      */
888     modifier nonReentrant() {
889         _nonReentrantBefore();
890         _;
891         _nonReentrantAfter();
892     }
893 
894     function _nonReentrantBefore() private {
895         // On the first call to nonReentrant, _status will be _NOT_ENTERED
896         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
897 
898         // Any calls to nonReentrant after this point will fail
899         _status = _ENTERED;
900     }
901 
902     function _nonReentrantAfter() private {
903         // By storing the original value once again, a refund is triggered (see
904         // https://eips.ethereum.org/EIPS/eip-2200)
905         _status = _NOT_ENTERED;
906     }
907 }
908 
909 // File: @openzeppelin/contracts/security/Pausable.sol
910 
911 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
912 
913 pragma solidity ^0.8.0;
914 
915 /**
916  * @dev Contract module which allows children to implement an emergency stop
917  * mechanism that can be triggered by an authorized account.
918  *
919  * This module is used through inheritance. It will make available the
920  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
921  * the functions of your contract. Note that they will not be pausable by
922  * simply including this module, only once the modifiers are put in place.
923  */
924 abstract contract Pausable is Context {
925     /**
926      * @dev Emitted when the pause is triggered by `account`.
927      */
928     event Paused(address account);
929 
930     /**
931      * @dev Emitted when the pause is lifted by `account`.
932      */
933     event Unpaused(address account);
934 
935     bool private _paused;
936 
937     /**
938      * @dev Initializes the contract in unpaused state.
939      */
940     constructor() {
941         _paused = false;
942     }
943 
944     /**
945      * @dev Modifier to make a function callable only when the contract is not paused.
946      *
947      * Requirements:
948      *
949      * - The contract must not be paused.
950      */
951     modifier whenNotPaused() {
952         _requireNotPaused();
953         _;
954     }
955 
956     /**
957      * @dev Modifier to make a function callable only when the contract is paused.
958      *
959      * Requirements:
960      *
961      * - The contract must be paused.
962      */
963     modifier whenPaused() {
964         _requirePaused();
965         _;
966     }
967 
968     /**
969      * @dev Returns true if the contract is paused, and false otherwise.
970      */
971     function paused() public view virtual returns (bool) {
972         return _paused;
973     }
974 
975     /**
976      * @dev Throws if the contract is paused.
977      */
978     function _requireNotPaused() internal view virtual {
979         require(!paused(), "Pausable: paused");
980     }
981 
982     /**
983      * @dev Throws if the contract is not paused.
984      */
985     function _requirePaused() internal view virtual {
986         require(paused(), "Pausable: not paused");
987     }
988 
989     /**
990      * @dev Triggers stopped state.
991      *
992      * Requirements:
993      *
994      * - The contract must not be paused.
995      */
996     function _pause() internal virtual whenNotPaused {
997         _paused = true;
998         emit Paused(_msgSender());
999     }
1000 
1001     /**
1002      * @dev Returns to normal state.
1003      *
1004      * Requirements:
1005      *
1006      * - The contract must be paused.
1007      */
1008     function _unpause() internal virtual whenPaused {
1009         _paused = false;
1010         emit Unpaused(_msgSender());
1011     }
1012 }
1013 
1014 // File: contracts/interfaces/IDepositExecute.sol
1015 
1016 pragma solidity 0.8.17;
1017 
1018 /**
1019     @title Interface for handler contracts that support deposits and deposit executions.
1020     @author ChainSafe Systems.
1021  */
1022 interface IDepositExecute {
1023     /**
1024         @notice It is intended that deposit are made using the Bridge contract.
1025         @param resourceID ID of the resource that is being bridged.
1026         @param destinationChainID Chain ID deposit is expected to be bridged to.
1027         @param depositNonce This value is generated as an ID by the Bridge contract.
1028         @param depositer Address of account making the deposit in the Bridge contract.
1029         @param data Consists of additional data needed for a specific deposit.
1030      */
1031     function deposit(bytes32 resourceID, uint8 destinationChainID, uint64 depositNonce, address depositer, bytes calldata data) external payable;
1032 
1033     /**
1034         @notice It is intended that proposals are executed by the Bridge contract.
1035         @param resourceID ID of the resource that is being bridged.
1036         @param data Consists of additional data needed for a specific deposit execution.
1037      */
1038     function executeProposal(bytes32 resourceID, bytes calldata data) external;
1039 }
1040 
1041 // File: contracts/interfaces/IBridge.sol
1042 
1043 pragma solidity 0.8.17;
1044 
1045 /**
1046     @title Interface for Bridge contract.
1047     @author ChainSafe Systems.
1048  */
1049 interface IBridge {
1050     /**
1051         @notice Exposing getter for {_chainID} instead of forcing the use of call.
1052         @return uint8 The {_chainID} that is currently set for the Bridge contract.
1053      */
1054     function _chainID() external returns (uint8);
1055 
1056     /**
1057         @notice Exposing getter for {_fee} instead of forcing the use of call.
1058         @return uint256 The {_fee} that is currently set for the Bridge contract.
1059      */
1060     function _fee() external returns (uint256);
1061 }
1062 
1063 // File: contracts/interfaces/IERCHandler.sol
1064 
1065 pragma solidity 0.8.17;
1066 
1067 /**
1068     @title Interface to be used with handlers that support ERC20s and ERC721s.
1069     @author ChainSafe Systems.
1070  */
1071 interface IERCHandler {
1072     /**
1073         @notice Correlates {resourceID} with {contractAddress}.
1074         @param resourceID ResourceID to be used when making deposits.
1075         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
1076      */
1077     function setResource(bytes32 resourceID, address contractAddress) external;
1078     /**
1079         @notice Marks {contractAddress} as mintable/burnable.
1080         @param contractAddress Address of contract to be used when making or executing deposits.
1081      */
1082     function setBurnable(address contractAddress) external;
1083     /**
1084         @notice Used to manually release funds {native tokens} from Native safes.
1085         @param recipient Address to release tokens to.
1086         @param amount The amount of native token to release.
1087      */
1088     function withdraw(address recipient, uint256 amount) external;
1089     /**
1090         @notice Used to manually release funds {erc20 tokens, nft} from ERC safes.
1091         @param tokenAddress Address of token contract to release
1092         @param recipient Address to release tokens to.
1093         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to release.
1094      */
1095     function withdrawToken(address tokenAddress, address recipient, uint256 amountOrTokenID) external;
1096 }
1097 
1098 // File: contracts/interfaces/IGenericHandler.sol
1099 
1100 pragma solidity 0.8.17;
1101 
1102 /**
1103     @title Interface for handler that handles generic deposits and deposit executions.
1104     @author ChainSafe Systems.
1105  */
1106 interface IGenericHandler {
1107     /**
1108         @notice Correlates {resourceID} with {contractAddress}, {depositFunctionSig}, and {executeFunctionSig}.
1109         @param resourceID ResourceID to be used when making deposits.
1110         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
1111         @param depositFunctionSig Function signature of method to be called in {contractAddress} when a deposit is made.
1112         @param executeFunctionSig Function signature of method to be called in {contractAddress} when a deposit is executed.
1113      */
1114     function setResource(bytes32 resourceID, address contractAddress, bytes4 depositFunctionSig, bytes4 executeFunctionSig) external;
1115 }
1116 
1117 // File: contracts/Bridge.sol
1118 
1119 pragma solidity 0.8.17;
1120 
1121 
1122 
1123 
1124 
1125 
1126 
1127 /**
1128     @title Facilitates deposits, creation and votiing of deposit proposals, and deposit executions.
1129     @author ChainSafe Systems.
1130  */
1131 contract Bridge is Pausable, AccessControl, ReentrancyGuard {
1132     uint8   public _chainID;
1133     uint256 public _totalRelayers;
1134     uint256 public _totalProposals;
1135     uint256 public _fee;
1136     uint256 public _maxFee;
1137     uint256 public _expiry;
1138 
1139     enum Vote {No, Yes}
1140 
1141     enum ProposalStatus {Inactive, Active, Passed, Executed, Cancelled}
1142 
1143     struct Proposal {
1144         bytes32 _resourceID;
1145         bytes32 _dataHash;
1146         address[] _yesVotes;
1147         address[] _noVotes;
1148         ProposalStatus _status;
1149         uint256 _proposedBlock;
1150     }
1151 
1152     // destinationChainID => number of deposits
1153     mapping(uint8 => uint64) public _depositCounts;
1154     // resourceID => handler address
1155     mapping(bytes32 => address) public _resourceIDToHandlerAddress;
1156     // depositNonce => destinationChainID => bytes
1157     mapping(uint64 => mapping(uint8 => bytes)) public _depositRecords;
1158     // destinationChainID + depositNonce => dataHash => Proposal
1159     mapping(uint72 => mapping(bytes32 => Proposal)) public _proposals;
1160     // destinationChainID + depositNonce => dataHash => relayerAddress => bool
1161     mapping(uint72 => mapping(bytes32 => mapping(address => bool))) public _hasVotedOnProposal;
1162     // chainID => bool
1163     mapping(uint8 => bool) public _chainIDWhitelist;
1164 
1165     event RelayerThresholdChanged(uint indexed newThreshold);
1166     event RelayerAdded(address indexed relayer);
1167     event RelayerRemoved(address indexed relayer);
1168     event ChainIDWhitelisted(uint8 indexed chainID);
1169     event ChainIDUnwhitelisted(uint8 indexed chainID);
1170     event Deposit(
1171         uint8   indexed destinationChainID,
1172         bytes32 indexed resourceID,
1173         uint64  indexed depositNonce
1174     );
1175     event ProposalEvent(
1176         uint8           indexed originChainID,
1177         uint64          indexed depositNonce,
1178         ProposalStatus  indexed status,
1179         bytes32 resourceID,
1180         bytes32 dataHash
1181     );
1182 
1183     event ProposalVote(
1184         uint8   indexed originChainID,
1185         uint64  indexed depositNonce,
1186         ProposalStatus indexed status,
1187         bytes32 resourceID
1188     );
1189 
1190     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
1191 
1192     modifier onlyAdmin() {
1193         _onlyAdmin();
1194         _;
1195     }
1196 
1197     modifier onlyAdminOrRelayer() {
1198         _onlyAdminOrRelayer();
1199         _;
1200     }
1201 
1202     modifier onlyRelayers() {
1203         _onlyRelayers();
1204         _;
1205     }
1206 
1207     function _onlyAdminOrRelayer() private {
1208         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(RELAYER_ROLE, msg.sender),
1209             "sender is not relayer or admin");
1210     }
1211 
1212     function _onlyAdmin() private {
1213         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "sender doesn't have admin role");
1214     }
1215 
1216     function _onlyRelayers() private {
1217         require(hasRole(RELAYER_ROLE, msg.sender), "sender doesn't have relayer role");
1218     }
1219 
1220     /**
1221         @notice Initializes Bridge, creates and grants {msg.sender} the admin role,
1222         creates and grants {initialRelayers} the relayer role.
1223         @param chainID ID of chain the Bridge contract exists on.
1224         @param initialRelayers Addresses that should be initially granted the relayer role.
1225         @param fee Amount in wei to pay to deposit.
1226         @param maxFee Max. value for fee.
1227         @param expiry Number of blocks max before a deposit proposal is considered expired
1228         @param initialChainIDWhitelist List of Chain Ids that user can bridge their funds to
1229      */
1230     constructor (uint8 chainID, address[] memory initialRelayers, uint256 fee, uint256 maxFee, uint256 expiry, uint8[] memory initialChainIDWhitelist) {
1231         require(fee <= maxFee, "Fee exceeds max fee");
1232         _chainID = chainID;
1233         _fee = fee;
1234         _maxFee = maxFee;
1235         _expiry = expiry;
1236 
1237         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1238         _setRoleAdmin(RELAYER_ROLE, DEFAULT_ADMIN_ROLE);
1239 
1240         for (uint i; i < initialRelayers.length; i++) {
1241             grantRole(RELAYER_ROLE, initialRelayers[i]);
1242             _totalRelayers++;
1243         }
1244 
1245         for (uint8 i; i < initialChainIDWhitelist.length; i++) {
1246             require(initialChainIDWhitelist[i] != chainID, "Initial whitelisted chainID cannot be Id of chain the Bridge exists on");
1247             _chainIDWhitelist[initialChainIDWhitelist[i]] = true;
1248             emit ChainIDWhitelisted(initialChainIDWhitelist[i]);
1249         }
1250     }
1251 
1252     /**
1253         @notice Returns true if {relayer} has the relayer role.
1254         @param relayer Address to check.
1255      */
1256     function isRelayer(address relayer) external view returns (bool) {
1257         return hasRole(RELAYER_ROLE, relayer);
1258     }
1259 
1260     /**
1261         @notice Removes admin role from {msg.sender} and grants it to {newAdmin}.
1262         @notice Only callable by an address that currently has the admin role.
1263         @param newAdmin Address that admin role will be granted to.
1264      */
1265     function renounceAdmin(address newAdmin) external onlyAdmin {
1266         grantRole(DEFAULT_ADMIN_ROLE, newAdmin);
1267         renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
1268     }
1269 
1270     /**
1271         @notice Pauses deposits, proposal creation and voting, and deposit executions.
1272         @notice Only callable by an address that currently has the admin role.
1273      */
1274     function adminPauseTransfers() external onlyAdmin {
1275         _pause();
1276     }
1277 
1278     /**
1279         @notice Unpauses deposits, proposal creation and voting, and deposit executions.
1280         @notice Only callable by an address that currently has the admin role.
1281      */
1282     function adminUnpauseTransfers() external onlyAdmin {
1283         _unpause();
1284     }
1285 
1286     /**
1287         @notice Adds a new chainID to the whitelist
1288         @notice Only callable by an address that currently has the admin role.
1289         @param chainID New chain ID to add to whitelist
1290         @notice Emits {ChainIDWhitelisted} event.
1291      */
1292     function adminWhitelistChainID(uint8 chainID) external onlyAdmin {
1293         require(_chainID != chainID, "chainID cannot be ID of chain the Bridge exists on");
1294         require(!_chainIDWhitelist[chainID], "Chain ID already whitelisted");
1295         _chainIDWhitelist[chainID] = true;
1296         emit ChainIDWhitelisted(chainID);
1297     }
1298 
1299     /**
1300         @notice Removes existing chainID from the whitelist
1301         @notice Only callable by an address that currently has the admin role.
1302         @param chainID Chain ID to remove from whitelist
1303         @notice Emits {ChainIDUnwhitelisted} event.
1304      */
1305     function adminUnwhitelistChainID(uint8 chainID) external onlyAdmin {
1306         require(_chainIDWhitelist[chainID], "Chain ID not whitelisted");
1307         _chainIDWhitelist[chainID] = false;
1308         emit ChainIDUnwhitelisted(chainID);
1309     }
1310 
1311     /**
1312         @notice Returns true if {chainID} is whitelisted
1313         @param chainID chain ID to check.
1314      */
1315     function isChainIDWhitelisted(uint8 chainID) external view returns (bool) {
1316         return _chainIDWhitelist[chainID];
1317     }
1318 
1319     /**
1320         @notice Grants {relayerAddress} the relayer role and increases {_totalRelayer} count.
1321         @notice Only callable by an address that currently has the admin role.
1322         @param relayerAddress Address of relayer to be added.
1323         @notice Emits {RelayerAdded} event.
1324      */
1325     function adminAddRelayer(address relayerAddress) external onlyAdmin {
1326         require(!hasRole(RELAYER_ROLE, relayerAddress), "addr already has relayer role!");
1327         grantRole(RELAYER_ROLE, relayerAddress);
1328         emit RelayerAdded(relayerAddress);
1329         _totalRelayers++;
1330     }
1331 
1332     /**
1333         @notice Removes relayer role for {relayerAddress} and decreases {_totalRelayer} count.
1334         @notice Only callable by an address that currently has the admin role.
1335         @param relayerAddress Address of relayer to be removed.
1336         @notice Emits {RelayerRemoved} event.
1337      */
1338     function adminRemoveRelayer(address relayerAddress) external onlyAdmin {
1339         require(hasRole(RELAYER_ROLE, relayerAddress), "addr doesn't have relayer role!");
1340         revokeRole(RELAYER_ROLE, relayerAddress);
1341         emit RelayerRemoved(relayerAddress);
1342         _totalRelayers--;
1343     }
1344 
1345     /**
1346         @notice Sets a new resource for handler contracts that use the IERCHandler interface,
1347         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
1348         @notice Only callable by an address that currently has the admin role.
1349         @param handlerAddress Address of handler resource will be set for.
1350         @param resourceID ResourceID to be used when making deposits.
1351         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
1352      */
1353     function adminSetResource(address handlerAddress, bytes32 resourceID, address tokenAddress) external onlyAdmin {
1354         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
1355         IERCHandler handler = IERCHandler(handlerAddress);
1356         handler.setResource(resourceID, tokenAddress);
1357     }
1358 
1359     /**
1360         @notice Sets a new resource for handler contracts that use the IGenericHandler interface,
1361         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
1362         @notice Only callable by an address that currently has the admin role.
1363         @param handlerAddress Address of handler resource will be set for.
1364         @param resourceID ResourceID to be used when making deposits.
1365         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
1366      */
1367     function adminSetGenericResource(
1368         address handlerAddress,
1369         bytes32 resourceID,
1370         address contractAddress,
1371         bytes4 depositFunctionSig,
1372         bytes4 executeFunctionSig
1373     ) external onlyAdmin {
1374         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
1375         IGenericHandler handler = IGenericHandler(handlerAddress);
1376         handler.setResource(resourceID, contractAddress, depositFunctionSig, executeFunctionSig);
1377     }
1378 
1379     /**
1380         @notice Sets a resource as burnable for handler contracts that use the IERCHandler interface.
1381         @notice Only callable by an address that currently has the admin role.
1382         @param handlerAddress Address of handler resource will be set for.
1383         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
1384      */
1385     function adminSetBurnable(address handlerAddress, address tokenAddress) external onlyAdmin {
1386         IERCHandler handler = IERCHandler(handlerAddress);
1387         handler.setBurnable(tokenAddress);
1388     }
1389 
1390     /**
1391         @notice Returns a proposal.
1392         @param originChainID Chain ID deposit originated from.
1393         @param depositNonce ID of proposal generated by proposal's origin Bridge contract.
1394         @param dataHash Hash of data to be provided when deposit proposal is executed.
1395         @return Proposal which consists of:
1396         - _dataHash Hash of data to be provided when deposit proposal is executed.
1397         - _yesVotes Number of votes in favor of proposal.
1398         - _noVotes Number of votes against proposal.
1399         - _status Current status of proposal.
1400      */
1401     function getProposal(uint8 originChainID, uint64 depositNonce, bytes32 dataHash) external view returns (Proposal memory) {
1402         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(originChainID);
1403         return _proposals[nonceAndID][dataHash];
1404     }
1405 
1406     /**
1407         @notice Changes deposit fee.
1408         @notice Only callable by admin.
1409         @param newFee Value {_fee} will be updated to.
1410      */
1411     function adminChangeFee(uint newFee) external onlyAdmin {
1412         require(_fee != newFee, "Current fee is equal to new fee");
1413         require(newFee <= _maxFee, "New fee exceeds max fee");
1414         _fee = newFee;
1415     }
1416 
1417     /**
1418         @notice Used to manually withdraw funds(native token) from ERC safes.
1419         @param handlerAddress Address of handler to withdraw from.
1420         @param recipient Address to withdraw tokens to.
1421         @param amount The amount of native token to release.
1422      */
1423     function adminWithdraw(
1424         address handlerAddress,
1425         address recipient,
1426         uint256 amount
1427     ) external onlyAdmin nonReentrant {
1428         IERCHandler handler = IERCHandler(handlerAddress);
1429         handler.withdraw(recipient, amount);
1430     }
1431 
1432     /**
1433         @notice Used to manually withdraw funds(ERC20 & ERC721) from ERC safes.
1434         @param handlerAddress Address of handler to withdraw from.
1435         @param tokenAddress Address of token to withdraw.
1436         @param recipient Address to withdraw tokens to.
1437         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to withdraw.
1438      */
1439     function adminWithdrawToken(
1440         address handlerAddress,
1441         address tokenAddress,
1442         address recipient,
1443         uint256 amountOrTokenID
1444     ) external onlyAdmin nonReentrant {
1445         IERCHandler handler = IERCHandler(handlerAddress);
1446         handler.withdrawToken(tokenAddress, recipient, amountOrTokenID);
1447     }
1448 
1449     /**
1450         @notice Initiates a transfer using a specified handler contract.
1451         @notice Only callable when Bridge is not paused.
1452         @param destinationChainID ID of chain deposit will be bridged to.
1453         @param resourceID ResourceID used to find address of handler to be used for deposit.
1454         @param data Additional data to be passed to specified handler.
1455         @notice Emits {Deposit} event.
1456      */
1457     function deposit(uint8 destinationChainID, bytes32 resourceID, bytes calldata data) external payable whenNotPaused {
1458         require(destinationChainID != _chainID, "DestinationChainID cannot be the same as current Bridge chainID");
1459         require(_chainIDWhitelist[destinationChainID], "DestinationChainID not whitelisted");
1460         require(msg.value >= _fee, "Value too small to pay Fee");
1461 
1462         address handler = _resourceIDToHandlerAddress[resourceID];
1463         require(handler != address(0), "ResourceID not mapped to handler");
1464 
1465         uint64 depositNonce = ++_depositCounts[destinationChainID];
1466         _depositRecords[depositNonce][destinationChainID] = data;
1467 
1468         IDepositExecute depositHandler = IDepositExecute(handler);
1469 
1470         depositHandler.deposit{value: msg.value - _fee}(resourceID, destinationChainID, depositNonce, msg.sender, data);
1471 
1472         emit Deposit(destinationChainID, resourceID, depositNonce);
1473     }
1474 
1475     /**
1476         @notice When called, {msg.sender} will be marked as voting in favor of proposal.
1477         @notice Only callable by relayers when Bridge is not paused.
1478         @param chainID ID of chain deposit originated from.
1479         @param depositNonce ID of deposited generated by origin Bridge contract.
1480         @param dataHash Hash of data provided when deposit was made.
1481         @notice Proposal must not have already been passed or executed.
1482         @notice {msg.sender} must not have already voted on proposal.
1483         @notice Emits {ProposalEvent} event with status indicating the proposal status.
1484         @notice Emits {ProposalVote} event.
1485      */
1486     function voteProposal(uint8 chainID, uint64 depositNonce, bytes32 resourceID, bytes32 dataHash) external onlyRelayers whenNotPaused {
1487 
1488         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1489         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1490 
1491         require(_resourceIDToHandlerAddress[resourceID] != address(0), "no handler for resourceID");
1492         require(uint(proposal._status) <= 1, "proposal already passed/executed/cancelled");
1493         require(!_hasVotedOnProposal[nonceAndID][dataHash][msg.sender], "relayer already voted");
1494 
1495         if (uint(proposal._status) == 0) {
1496             ++_totalProposals;
1497             _proposals[nonceAndID][dataHash] = Proposal({
1498                 _resourceID : resourceID,
1499                 _dataHash : dataHash,
1500                 _yesVotes : new address[](1),
1501                 _noVotes : new address[](0),
1502                 _status : ProposalStatus.Active,
1503                 _proposedBlock : block.number
1504                 });
1505 
1506             proposal._yesVotes[0] = msg.sender;
1507             emit ProposalEvent(chainID, depositNonce, ProposalStatus.Active, resourceID, dataHash);
1508         } else {
1509             if ((block.number - proposal._proposedBlock) > _expiry) {
1510                 // if the number of blocks that has passed since this proposal was
1511                 // submitted exceeds the expiry threshold set, cancel the proposal
1512                 proposal._status = ProposalStatus.Cancelled;
1513                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, resourceID, dataHash);
1514             } else {
1515                 require(dataHash == proposal._dataHash, "datahash mismatch");
1516                 proposal._yesVotes.push(msg.sender);
1517 
1518 
1519             }
1520 
1521         }
1522         if (proposal._status != ProposalStatus.Cancelled) {
1523             _hasVotedOnProposal[nonceAndID][dataHash][msg.sender] = true;
1524             emit ProposalVote(chainID, depositNonce, proposal._status, resourceID);
1525 
1526             // If _totalRelayers is 1, then auto finalize
1527             // or if quorum() has been reached
1528             if (_totalRelayers == 1 || proposal._yesVotes.length >= quorum()) {
1529                 proposal._status = ProposalStatus.Passed;
1530 
1531                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Passed, resourceID, dataHash);
1532             }
1533         }
1534 
1535     }
1536 
1537     /**
1538         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1539         @notice Only callable by relayers when Bridge is not paused.
1540         @param chainID ID of chain deposit originated from.
1541         @param depositNonce ID of deposited generated by origin Bridge contract.
1542         @param dataHash Hash of data originally provided when deposit was made.
1543         @notice Proposal must be past expiry threshold.
1544         @notice Emits {ProposalEvent} event with status {Cancelled}.
1545      */
1546     function cancelProposal(uint8 chainID, uint64 depositNonce, bytes32 dataHash) external onlyAdminOrRelayer {
1547         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1548         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1549 
1550         require(proposal._status != ProposalStatus.Cancelled, "Proposal already cancelled");
1551         require((block.number - proposal._proposedBlock) > _expiry, "Proposal not at expiry threshold");
1552 
1553         proposal._status = ProposalStatus.Cancelled;
1554         emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, proposal._resourceID, proposal._dataHash);
1555 
1556     }
1557 
1558     /**
1559         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1560         @notice Only callable by relayers when Bridge is not paused.
1561         @param chainID ID of chain deposit originated from.
1562         @param resourceID ResourceID to be used when making deposits.
1563         @param depositNonce ID of deposited generated by origin Bridge contract.
1564         @param data Data originally provided when deposit was made.
1565         @notice Proposal must have Passed status.
1566         @notice Hash of {data} must equal proposal's {dataHash}.
1567         @notice Emits {ProposalEvent} event with status {Executed}.
1568      */
1569     function executeProposal(uint8 chainID, uint64 depositNonce, bytes calldata data, bytes32 resourceID) external onlyRelayers whenNotPaused {
1570         address handler = _resourceIDToHandlerAddress[resourceID];
1571         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1572         bytes32 dataHash = keccak256(abi.encodePacked(handler, data));
1573         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1574 
1575         require(proposal._status != ProposalStatus.Inactive, "proposal is not active");
1576         require(proposal._status == ProposalStatus.Passed, "proposal already transferred");
1577         require(dataHash == proposal._dataHash, "data doesn't match datahash");
1578 
1579         proposal._status = ProposalStatus.Executed;
1580 
1581         IDepositExecute depositHandler = IDepositExecute(_resourceIDToHandlerAddress[proposal._resourceID]);
1582         depositHandler.executeProposal(proposal._resourceID, data);
1583 
1584         emit ProposalEvent(chainID, depositNonce, proposal._status, proposal._resourceID, proposal._dataHash);
1585     }
1586 
1587     /**
1588         @notice Transfers eth in the contract to the specified addresses. The parameters addrs and amounts are mapped 1-1.
1589         This means that the address at index 0 for addrs will receive the amount (in WEI) from amounts at index 0.
1590         @param addrs Array of addresses to transfer {amounts} to.
1591         @param amounts Array of amonuts to transfer to {addrs}.
1592      */
1593     function transferFunds(address payable[] calldata addrs, uint[] calldata amounts) external onlyAdmin {
1594         for (uint i = 0; i < addrs.length; i++) {
1595             addrs[i].call{value: amounts[i]}("");
1596         }
1597     }
1598 
1599     /**
1600         @notice Returns quorum necessary to pass a proposal
1601      */
1602     function quorum() public view returns (uint256) {
1603         return _totalRelayers * 2 / 3;
1604     }
1605 
1606     /**
1607         @notice Used for "locking" native tokens.
1608      */
1609     receive() external payable onlyAdmin { }
1610 
1611 }