1 // Sources flattened with hardhat v2.15.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.9.1
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
95 // File @openzeppelin/contracts/utils/Context.sol@v4.9.1
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
122 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.1
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
150 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.1
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
180 // File @openzeppelin/contracts/utils/math/Math.sol@v4.9.1
181 
182 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
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
235     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
236         unchecked {
237             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
238             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
239             // variables such that product = prod1 * 2^256 + prod0.
240             uint256 prod0; // Least significant 256 bits of the product
241             uint256 prod1; // Most significant 256 bits of the product
242             assembly {
243                 let mm := mulmod(x, y, not(0))
244                 prod0 := mul(x, y)
245                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
246             }
247 
248             // Handle non-overflow cases, 256 by 256 division.
249             if (prod1 == 0) {
250                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
251                 // The surrounding unchecked block does not change this fact.
252                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
253                 return prod0 / denominator;
254             }
255 
256             // Make sure the result is less than 2^256. Also prevents denominator == 0.
257             require(denominator > prod1, "Math: mulDiv overflow");
258 
259             ///////////////////////////////////////////////
260             // 512 by 256 division.
261             ///////////////////////////////////////////////
262 
263             // Make division exact by subtracting the remainder from [prod1 prod0].
264             uint256 remainder;
265             assembly {
266                 // Compute remainder using mulmod.
267                 remainder := mulmod(x, y, denominator)
268 
269                 // Subtract 256 bit number from 512 bit number.
270                 prod1 := sub(prod1, gt(remainder, prod0))
271                 prod0 := sub(prod0, remainder)
272             }
273 
274             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
275             // See https://cs.stackexchange.com/q/138556/92363.
276 
277             // Does not overflow because the denominator cannot be zero at this stage in the function.
278             uint256 twos = denominator & (~denominator + 1);
279             assembly {
280                 // Divide denominator by twos.
281                 denominator := div(denominator, twos)
282 
283                 // Divide [prod1 prod0] by twos.
284                 prod0 := div(prod0, twos)
285 
286                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
287                 twos := add(div(sub(0, twos), twos), 1)
288             }
289 
290             // Shift in bits from prod1 into prod0.
291             prod0 |= prod1 * twos;
292 
293             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
294             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
295             // four bits. That is, denominator * inv = 1 mod 2^4.
296             uint256 inverse = (3 * denominator) ^ 2;
297 
298             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
299             // in modular arithmetic, doubling the correct bits in each step.
300             inverse *= 2 - denominator * inverse; // inverse mod 2^8
301             inverse *= 2 - denominator * inverse; // inverse mod 2^16
302             inverse *= 2 - denominator * inverse; // inverse mod 2^32
303             inverse *= 2 - denominator * inverse; // inverse mod 2^64
304             inverse *= 2 - denominator * inverse; // inverse mod 2^128
305             inverse *= 2 - denominator * inverse; // inverse mod 2^256
306 
307             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
308             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
309             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
310             // is no longer required.
311             result = prod0 * inverse;
312             return result;
313         }
314     }
315 
316     /**
317      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
318      */
319     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
320         uint256 result = mulDiv(x, y, denominator);
321         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
322             result += 1;
323         }
324         return result;
325     }
326 
327     /**
328      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
329      *
330      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
331      */
332     function sqrt(uint256 a) internal pure returns (uint256) {
333         if (a == 0) {
334             return 0;
335         }
336 
337         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
338         //
339         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
340         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
341         //
342         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
343         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
344         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
345         //
346         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
347         uint256 result = 1 << (log2(a) >> 1);
348 
349         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
350         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
351         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
352         // into the expected uint128 result.
353         unchecked {
354             result = (result + a / result) >> 1;
355             result = (result + a / result) >> 1;
356             result = (result + a / result) >> 1;
357             result = (result + a / result) >> 1;
358             result = (result + a / result) >> 1;
359             result = (result + a / result) >> 1;
360             result = (result + a / result) >> 1;
361             return min(result, a / result);
362         }
363     }
364 
365     /**
366      * @notice Calculates sqrt(a), following the selected rounding direction.
367      */
368     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
369         unchecked {
370             uint256 result = sqrt(a);
371             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
372         }
373     }
374 
375     /**
376      * @dev Return the log in base 2, rounded down, of a positive value.
377      * Returns 0 if given 0.
378      */
379     function log2(uint256 value) internal pure returns (uint256) {
380         uint256 result = 0;
381         unchecked {
382             if (value >> 128 > 0) {
383                 value >>= 128;
384                 result += 128;
385             }
386             if (value >> 64 > 0) {
387                 value >>= 64;
388                 result += 64;
389             }
390             if (value >> 32 > 0) {
391                 value >>= 32;
392                 result += 32;
393             }
394             if (value >> 16 > 0) {
395                 value >>= 16;
396                 result += 16;
397             }
398             if (value >> 8 > 0) {
399                 value >>= 8;
400                 result += 8;
401             }
402             if (value >> 4 > 0) {
403                 value >>= 4;
404                 result += 4;
405             }
406             if (value >> 2 > 0) {
407                 value >>= 2;
408                 result += 2;
409             }
410             if (value >> 1 > 0) {
411                 result += 1;
412             }
413         }
414         return result;
415     }
416 
417     /**
418      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
419      * Returns 0 if given 0.
420      */
421     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
422         unchecked {
423             uint256 result = log2(value);
424             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
425         }
426     }
427 
428     /**
429      * @dev Return the log in base 10, rounded down, of a positive value.
430      * Returns 0 if given 0.
431      */
432     function log10(uint256 value) internal pure returns (uint256) {
433         uint256 result = 0;
434         unchecked {
435             if (value >= 10 ** 64) {
436                 value /= 10 ** 64;
437                 result += 64;
438             }
439             if (value >= 10 ** 32) {
440                 value /= 10 ** 32;
441                 result += 32;
442             }
443             if (value >= 10 ** 16) {
444                 value /= 10 ** 16;
445                 result += 16;
446             }
447             if (value >= 10 ** 8) {
448                 value /= 10 ** 8;
449                 result += 8;
450             }
451             if (value >= 10 ** 4) {
452                 value /= 10 ** 4;
453                 result += 4;
454             }
455             if (value >= 10 ** 2) {
456                 value /= 10 ** 2;
457                 result += 2;
458             }
459             if (value >= 10 ** 1) {
460                 result += 1;
461             }
462         }
463         return result;
464     }
465 
466     /**
467      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
468      * Returns 0 if given 0.
469      */
470     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
471         unchecked {
472             uint256 result = log10(value);
473             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
474         }
475     }
476 
477     /**
478      * @dev Return the log in base 256, rounded down, of a positive value.
479      * Returns 0 if given 0.
480      *
481      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
482      */
483     function log256(uint256 value) internal pure returns (uint256) {
484         uint256 result = 0;
485         unchecked {
486             if (value >> 128 > 0) {
487                 value >>= 128;
488                 result += 16;
489             }
490             if (value >> 64 > 0) {
491                 value >>= 64;
492                 result += 8;
493             }
494             if (value >> 32 > 0) {
495                 value >>= 32;
496                 result += 4;
497             }
498             if (value >> 16 > 0) {
499                 value >>= 16;
500                 result += 2;
501             }
502             if (value >> 8 > 0) {
503                 result += 1;
504             }
505         }
506         return result;
507     }
508 
509     /**
510      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
511      * Returns 0 if given 0.
512      */
513     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
514         unchecked {
515             uint256 result = log256(value);
516             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
517         }
518     }
519 }
520 
521 
522 // File @openzeppelin/contracts/utils/math/SignedMath.sol@v4.9.1
523 
524 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Standard signed math utilities missing in the Solidity language.
530  */
531 library SignedMath {
532     /**
533      * @dev Returns the largest of two signed numbers.
534      */
535     function max(int256 a, int256 b) internal pure returns (int256) {
536         return a > b ? a : b;
537     }
538 
539     /**
540      * @dev Returns the smallest of two signed numbers.
541      */
542     function min(int256 a, int256 b) internal pure returns (int256) {
543         return a < b ? a : b;
544     }
545 
546     /**
547      * @dev Returns the average of two signed numbers without overflow.
548      * The result is rounded towards zero.
549      */
550     function average(int256 a, int256 b) internal pure returns (int256) {
551         // Formula from the book "Hacker's Delight"
552         int256 x = (a & b) + ((a ^ b) >> 1);
553         return x + (int256(uint256(x) >> 255) & (a ^ b));
554     }
555 
556     /**
557      * @dev Returns the absolute unsigned value of a signed value.
558      */
559     function abs(int256 n) internal pure returns (uint256) {
560         unchecked {
561             // must be unchecked in order to support `n = type(int256).min`
562             return uint256(n >= 0 ? n : -n);
563         }
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts/utils/Strings.sol@v4.9.1
569 
570 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @dev String operations.
577  */
578 library Strings {
579     bytes16 private constant _SYMBOLS = "0123456789abcdef";
580     uint8 private constant _ADDRESS_LENGTH = 20;
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
584      */
585     function toString(uint256 value) internal pure returns (string memory) {
586         unchecked {
587             uint256 length = Math.log10(value) + 1;
588             string memory buffer = new string(length);
589             uint256 ptr;
590             /// @solidity memory-safe-assembly
591             assembly {
592                 ptr := add(buffer, add(32, length))
593             }
594             while (true) {
595                 ptr--;
596                 /// @solidity memory-safe-assembly
597                 assembly {
598                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
599                 }
600                 value /= 10;
601                 if (value == 0) break;
602             }
603             return buffer;
604         }
605     }
606 
607     /**
608      * @dev Converts a `int256` to its ASCII `string` decimal representation.
609      */
610     function toString(int256 value) internal pure returns (string memory) {
611         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
612     }
613 
614     /**
615      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
616      */
617     function toHexString(uint256 value) internal pure returns (string memory) {
618         unchecked {
619             return toHexString(value, Math.log256(value) + 1);
620         }
621     }
622 
623     /**
624      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
625      */
626     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
627         bytes memory buffer = new bytes(2 * length + 2);
628         buffer[0] = "0";
629         buffer[1] = "x";
630         for (uint256 i = 2 * length + 1; i > 1; --i) {
631             buffer[i] = _SYMBOLS[value & 0xf];
632             value >>= 4;
633         }
634         require(value == 0, "Strings: hex length insufficient");
635         return string(buffer);
636     }
637 
638     /**
639      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
640      */
641     function toHexString(address addr) internal pure returns (string memory) {
642         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
643     }
644 
645     /**
646      * @dev Returns true if the two strings are equal.
647      */
648     function equal(string memory a, string memory b) internal pure returns (bool) {
649         return keccak256(bytes(a)) == keccak256(bytes(b));
650     }
651 }
652 
653 
654 // File @openzeppelin/contracts/access/AccessControl.sol@v4.9.1
655 
656 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 
661 
662 
663 /**
664  * @dev Contract module that allows children to implement role-based access
665  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
666  * members except through off-chain means by accessing the contract event logs. Some
667  * applications may benefit from on-chain enumerability, for those cases see
668  * {AccessControlEnumerable}.
669  *
670  * Roles are referred to by their `bytes32` identifier. These should be exposed
671  * in the external API and be unique. The best way to achieve this is by
672  * using `public constant` hash digests:
673  *
674  * ```solidity
675  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
676  * ```
677  *
678  * Roles can be used to represent a set of permissions. To restrict access to a
679  * function call, use {hasRole}:
680  *
681  * ```solidity
682  * function foo() public {
683  *     require(hasRole(MY_ROLE, msg.sender));
684  *     ...
685  * }
686  * ```
687  *
688  * Roles can be granted and revoked dynamically via the {grantRole} and
689  * {revokeRole} functions. Each role has an associated admin role, and only
690  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
691  *
692  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
693  * that only accounts with this role will be able to grant or revoke other
694  * roles. More complex role relationships can be created by using
695  * {_setRoleAdmin}.
696  *
697  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
698  * grant and revoke this role. Extra precautions should be taken to secure
699  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
700  * to enforce additional security measures for this role.
701  */
702 abstract contract AccessControl is Context, IAccessControl, ERC165 {
703     struct RoleData {
704         mapping(address => bool) members;
705         bytes32 adminRole;
706     }
707 
708     mapping(bytes32 => RoleData) private _roles;
709 
710     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
711 
712     /**
713      * @dev Modifier that checks that an account has a specific role. Reverts
714      * with a standardized message including the required role.
715      *
716      * The format of the revert reason is given by the following regular expression:
717      *
718      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
719      *
720      * _Available since v4.1._
721      */
722     modifier onlyRole(bytes32 role) {
723         _checkRole(role);
724         _;
725     }
726 
727     /**
728      * @dev See {IERC165-supportsInterface}.
729      */
730     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
731         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
732     }
733 
734     /**
735      * @dev Returns `true` if `account` has been granted `role`.
736      */
737     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
738         return _roles[role].members[account];
739     }
740 
741     /**
742      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
743      * Overriding this function changes the behavior of the {onlyRole} modifier.
744      *
745      * Format of the revert message is described in {_checkRole}.
746      *
747      * _Available since v4.6._
748      */
749     function _checkRole(bytes32 role) internal view virtual {
750         _checkRole(role, _msgSender());
751     }
752 
753     /**
754      * @dev Revert with a standard message if `account` is missing `role`.
755      *
756      * The format of the revert reason is given by the following regular expression:
757      *
758      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
759      */
760     function _checkRole(bytes32 role, address account) internal view virtual {
761         if (!hasRole(role, account)) {
762             revert(
763                 string(
764                     abi.encodePacked(
765                         "AccessControl: account ",
766                         Strings.toHexString(account),
767                         " is missing role ",
768                         Strings.toHexString(uint256(role), 32)
769                     )
770                 )
771             );
772         }
773     }
774 
775     /**
776      * @dev Returns the admin role that controls `role`. See {grantRole} and
777      * {revokeRole}.
778      *
779      * To change a role's admin, use {_setRoleAdmin}.
780      */
781     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
782         return _roles[role].adminRole;
783     }
784 
785     /**
786      * @dev Grants `role` to `account`.
787      *
788      * If `account` had not been already granted `role`, emits a {RoleGranted}
789      * event.
790      *
791      * Requirements:
792      *
793      * - the caller must have ``role``'s admin role.
794      *
795      * May emit a {RoleGranted} event.
796      */
797     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
798         _grantRole(role, account);
799     }
800 
801     /**
802      * @dev Revokes `role` from `account`.
803      *
804      * If `account` had been granted `role`, emits a {RoleRevoked} event.
805      *
806      * Requirements:
807      *
808      * - the caller must have ``role``'s admin role.
809      *
810      * May emit a {RoleRevoked} event.
811      */
812     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
813         _revokeRole(role, account);
814     }
815 
816     /**
817      * @dev Revokes `role` from the calling account.
818      *
819      * Roles are often managed via {grantRole} and {revokeRole}: this function's
820      * purpose is to provide a mechanism for accounts to lose their privileges
821      * if they are compromised (such as when a trusted device is misplaced).
822      *
823      * If the calling account had been revoked `role`, emits a {RoleRevoked}
824      * event.
825      *
826      * Requirements:
827      *
828      * - the caller must be `account`.
829      *
830      * May emit a {RoleRevoked} event.
831      */
832     function renounceRole(bytes32 role, address account) public virtual override {
833         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
834 
835         _revokeRole(role, account);
836     }
837 
838     /**
839      * @dev Grants `role` to `account`.
840      *
841      * If `account` had not been already granted `role`, emits a {RoleGranted}
842      * event. Note that unlike {grantRole}, this function doesn't perform any
843      * checks on the calling account.
844      *
845      * May emit a {RoleGranted} event.
846      *
847      * [WARNING]
848      * ====
849      * This function should only be called from the constructor when setting
850      * up the initial roles for the system.
851      *
852      * Using this function in any other way is effectively circumventing the admin
853      * system imposed by {AccessControl}.
854      * ====
855      *
856      * NOTE: This function is deprecated in favor of {_grantRole}.
857      */
858     function _setupRole(bytes32 role, address account) internal virtual {
859         _grantRole(role, account);
860     }
861 
862     /**
863      * @dev Sets `adminRole` as ``role``'s admin role.
864      *
865      * Emits a {RoleAdminChanged} event.
866      */
867     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
868         bytes32 previousAdminRole = getRoleAdmin(role);
869         _roles[role].adminRole = adminRole;
870         emit RoleAdminChanged(role, previousAdminRole, adminRole);
871     }
872 
873     /**
874      * @dev Grants `role` to `account`.
875      *
876      * Internal function without access restriction.
877      *
878      * May emit a {RoleGranted} event.
879      */
880     function _grantRole(bytes32 role, address account) internal virtual {
881         if (!hasRole(role, account)) {
882             _roles[role].members[account] = true;
883             emit RoleGranted(role, account, _msgSender());
884         }
885     }
886 
887     /**
888      * @dev Revokes `role` from `account`.
889      *
890      * Internal function without access restriction.
891      *
892      * May emit a {RoleRevoked} event.
893      */
894     function _revokeRole(bytes32 role, address account) internal virtual {
895         if (hasRole(role, account)) {
896             _roles[role].members[account] = false;
897             emit RoleRevoked(role, account, _msgSender());
898         }
899     }
900 }
901 
902 
903 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.1
904 
905 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
906 
907 pragma solidity ^0.8.0;
908 
909 /**
910  * @dev Interface of the ERC20 standard as defined in the EIP.
911  */
912 interface IERC20 {
913     /**
914      * @dev Emitted when `value` tokens are moved from one account (`from`) to
915      * another (`to`).
916      *
917      * Note that `value` may be zero.
918      */
919     event Transfer(address indexed from, address indexed to, uint256 value);
920 
921     /**
922      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
923      * a call to {approve}. `value` is the new allowance.
924      */
925     event Approval(address indexed owner, address indexed spender, uint256 value);
926 
927     /**
928      * @dev Returns the amount of tokens in existence.
929      */
930     function totalSupply() external view returns (uint256);
931 
932     /**
933      * @dev Returns the amount of tokens owned by `account`.
934      */
935     function balanceOf(address account) external view returns (uint256);
936 
937     /**
938      * @dev Moves `amount` tokens from the caller's account to `to`.
939      *
940      * Returns a boolean value indicating whether the operation succeeded.
941      *
942      * Emits a {Transfer} event.
943      */
944     function transfer(address to, uint256 amount) external returns (bool);
945 
946     /**
947      * @dev Returns the remaining number of tokens that `spender` will be
948      * allowed to spend on behalf of `owner` through {transferFrom}. This is
949      * zero by default.
950      *
951      * This value changes when {approve} or {transferFrom} are called.
952      */
953     function allowance(address owner, address spender) external view returns (uint256);
954 
955     /**
956      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
957      *
958      * Returns a boolean value indicating whether the operation succeeded.
959      *
960      * IMPORTANT: Beware that changing an allowance with this method brings the risk
961      * that someone may use both the old and the new allowance by unfortunate
962      * transaction ordering. One possible solution to mitigate this race
963      * condition is to first reduce the spender's allowance to 0 and set the
964      * desired value afterwards:
965      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
966      *
967      * Emits an {Approval} event.
968      */
969     function approve(address spender, uint256 amount) external returns (bool);
970 
971     /**
972      * @dev Moves `amount` tokens from `from` to `to` using the
973      * allowance mechanism. `amount` is then deducted from the caller's
974      * allowance.
975      *
976      * Returns a boolean value indicating whether the operation succeeded.
977      *
978      * Emits a {Transfer} event.
979      */
980     function transferFrom(address from, address to, uint256 amount) external returns (bool);
981 }
982 
983 
984 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.1
985 
986 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev Interface for the optional metadata functions from the ERC20 standard.
992  *
993  * _Available since v4.1._
994  */
995 interface IERC20Metadata is IERC20 {
996     /**
997      * @dev Returns the name of the token.
998      */
999     function name() external view returns (string memory);
1000 
1001     /**
1002      * @dev Returns the symbol of the token.
1003      */
1004     function symbol() external view returns (string memory);
1005 
1006     /**
1007      * @dev Returns the decimals places of the token.
1008      */
1009     function decimals() external view returns (uint8);
1010 }
1011 
1012 
1013 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.1
1014 
1015 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 
1020 
1021 /**
1022  * @dev Implementation of the {IERC20} interface.
1023  *
1024  * This implementation is agnostic to the way tokens are created. This means
1025  * that a supply mechanism has to be added in a derived contract using {_mint}.
1026  * For a generic mechanism see {ERC20PresetMinterPauser}.
1027  *
1028  * TIP: For a detailed writeup see our guide
1029  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1030  * to implement supply mechanisms].
1031  *
1032  * The default value of {decimals} is 18. To change this, you should override
1033  * this function so it returns a different value.
1034  *
1035  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1036  * instead returning `false` on failure. This behavior is nonetheless
1037  * conventional and does not conflict with the expectations of ERC20
1038  * applications.
1039  *
1040  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1041  * This allows applications to reconstruct the allowance for all accounts just
1042  * by listening to said events. Other implementations of the EIP may not emit
1043  * these events, as it isn't required by the specification.
1044  *
1045  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1046  * functions have been added to mitigate the well-known issues around setting
1047  * allowances. See {IERC20-approve}.
1048  */
1049 contract ERC20 is Context, IERC20, IERC20Metadata {
1050     mapping(address => uint256) private _balances;
1051 
1052     mapping(address => mapping(address => uint256)) private _allowances;
1053 
1054     uint256 private _totalSupply;
1055 
1056     string private _name;
1057     string private _symbol;
1058 
1059     /**
1060      * @dev Sets the values for {name} and {symbol}.
1061      *
1062      * All two of these values are immutable: they can only be set once during
1063      * construction.
1064      */
1065     constructor(string memory name_, string memory symbol_) {
1066         _name = name_;
1067         _symbol = symbol_;
1068     }
1069 
1070     /**
1071      * @dev Returns the name of the token.
1072      */
1073     function name() public view virtual override returns (string memory) {
1074         return _name;
1075     }
1076 
1077     /**
1078      * @dev Returns the symbol of the token, usually a shorter version of the
1079      * name.
1080      */
1081     function symbol() public view virtual override returns (string memory) {
1082         return _symbol;
1083     }
1084 
1085     /**
1086      * @dev Returns the number of decimals used to get its user representation.
1087      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1088      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1089      *
1090      * Tokens usually opt for a value of 18, imitating the relationship between
1091      * Ether and Wei. This is the default value returned by this function, unless
1092      * it's overridden.
1093      *
1094      * NOTE: This information is only used for _display_ purposes: it in
1095      * no way affects any of the arithmetic of the contract, including
1096      * {IERC20-balanceOf} and {IERC20-transfer}.
1097      */
1098     function decimals() public view virtual override returns (uint8) {
1099         return 18;
1100     }
1101 
1102     /**
1103      * @dev See {IERC20-totalSupply}.
1104      */
1105     function totalSupply() public view virtual override returns (uint256) {
1106         return _totalSupply;
1107     }
1108 
1109     /**
1110      * @dev See {IERC20-balanceOf}.
1111      */
1112     function balanceOf(address account) public view virtual override returns (uint256) {
1113         return _balances[account];
1114     }
1115 
1116     /**
1117      * @dev See {IERC20-transfer}.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - the caller must have a balance of at least `amount`.
1123      */
1124     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1125         address owner = _msgSender();
1126         _transfer(owner, to, amount);
1127         return true;
1128     }
1129 
1130     /**
1131      * @dev See {IERC20-allowance}.
1132      */
1133     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1134         return _allowances[owner][spender];
1135     }
1136 
1137     /**
1138      * @dev See {IERC20-approve}.
1139      *
1140      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1141      * `transferFrom`. This is semantically equivalent to an infinite approval.
1142      *
1143      * Requirements:
1144      *
1145      * - `spender` cannot be the zero address.
1146      */
1147     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1148         address owner = _msgSender();
1149         _approve(owner, spender, amount);
1150         return true;
1151     }
1152 
1153     /**
1154      * @dev See {IERC20-transferFrom}.
1155      *
1156      * Emits an {Approval} event indicating the updated allowance. This is not
1157      * required by the EIP. See the note at the beginning of {ERC20}.
1158      *
1159      * NOTE: Does not update the allowance if the current allowance
1160      * is the maximum `uint256`.
1161      *
1162      * Requirements:
1163      *
1164      * - `from` and `to` cannot be the zero address.
1165      * - `from` must have a balance of at least `amount`.
1166      * - the caller must have allowance for ``from``'s tokens of at least
1167      * `amount`.
1168      */
1169     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1170         address spender = _msgSender();
1171         _spendAllowance(from, spender, amount);
1172         _transfer(from, to, amount);
1173         return true;
1174     }
1175 
1176     /**
1177      * @dev Atomically increases the allowance granted to `spender` by the caller.
1178      *
1179      * This is an alternative to {approve} that can be used as a mitigation for
1180      * problems described in {IERC20-approve}.
1181      *
1182      * Emits an {Approval} event indicating the updated allowance.
1183      *
1184      * Requirements:
1185      *
1186      * - `spender` cannot be the zero address.
1187      */
1188     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1189         address owner = _msgSender();
1190         _approve(owner, spender, allowance(owner, spender) + addedValue);
1191         return true;
1192     }
1193 
1194     /**
1195      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1196      *
1197      * This is an alternative to {approve} that can be used as a mitigation for
1198      * problems described in {IERC20-approve}.
1199      *
1200      * Emits an {Approval} event indicating the updated allowance.
1201      *
1202      * Requirements:
1203      *
1204      * - `spender` cannot be the zero address.
1205      * - `spender` must have allowance for the caller of at least
1206      * `subtractedValue`.
1207      */
1208     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1209         address owner = _msgSender();
1210         uint256 currentAllowance = allowance(owner, spender);
1211         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1212         unchecked {
1213             _approve(owner, spender, currentAllowance - subtractedValue);
1214         }
1215 
1216         return true;
1217     }
1218 
1219     /**
1220      * @dev Moves `amount` of tokens from `from` to `to`.
1221      *
1222      * This internal function is equivalent to {transfer}, and can be used to
1223      * e.g. implement automatic token fees, slashing mechanisms, etc.
1224      *
1225      * Emits a {Transfer} event.
1226      *
1227      * Requirements:
1228      *
1229      * - `from` cannot be the zero address.
1230      * - `to` cannot be the zero address.
1231      * - `from` must have a balance of at least `amount`.
1232      */
1233     function _transfer(address from, address to, uint256 amount) internal virtual {
1234         require(from != address(0), "ERC20: transfer from the zero address");
1235         require(to != address(0), "ERC20: transfer to the zero address");
1236 
1237         _beforeTokenTransfer(from, to, amount);
1238 
1239         uint256 fromBalance = _balances[from];
1240         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1241         unchecked {
1242             _balances[from] = fromBalance - amount;
1243             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1244             // decrementing then incrementing.
1245             _balances[to] += amount;
1246         }
1247 
1248         emit Transfer(from, to, amount);
1249 
1250         _afterTokenTransfer(from, to, amount);
1251     }
1252 
1253     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1254      * the total supply.
1255      *
1256      * Emits a {Transfer} event with `from` set to the zero address.
1257      *
1258      * Requirements:
1259      *
1260      * - `account` cannot be the zero address.
1261      */
1262     function _mint(address account, uint256 amount) internal virtual {
1263         require(account != address(0), "ERC20: mint to the zero address");
1264 
1265         _beforeTokenTransfer(address(0), account, amount);
1266 
1267         _totalSupply += amount;
1268         unchecked {
1269             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1270             _balances[account] += amount;
1271         }
1272         emit Transfer(address(0), account, amount);
1273 
1274         _afterTokenTransfer(address(0), account, amount);
1275     }
1276 
1277     /**
1278      * @dev Destroys `amount` tokens from `account`, reducing the
1279      * total supply.
1280      *
1281      * Emits a {Transfer} event with `to` set to the zero address.
1282      *
1283      * Requirements:
1284      *
1285      * - `account` cannot be the zero address.
1286      * - `account` must have at least `amount` tokens.
1287      */
1288     function _burn(address account, uint256 amount) internal virtual {
1289         require(account != address(0), "ERC20: burn from the zero address");
1290 
1291         _beforeTokenTransfer(account, address(0), amount);
1292 
1293         uint256 accountBalance = _balances[account];
1294         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1295         unchecked {
1296             _balances[account] = accountBalance - amount;
1297             // Overflow not possible: amount <= accountBalance <= totalSupply.
1298             _totalSupply -= amount;
1299         }
1300 
1301         emit Transfer(account, address(0), amount);
1302 
1303         _afterTokenTransfer(account, address(0), amount);
1304     }
1305 
1306     /**
1307      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1308      *
1309      * This internal function is equivalent to `approve`, and can be used to
1310      * e.g. set automatic allowances for certain subsystems, etc.
1311      *
1312      * Emits an {Approval} event.
1313      *
1314      * Requirements:
1315      *
1316      * - `owner` cannot be the zero address.
1317      * - `spender` cannot be the zero address.
1318      */
1319     function _approve(address owner, address spender, uint256 amount) internal virtual {
1320         require(owner != address(0), "ERC20: approve from the zero address");
1321         require(spender != address(0), "ERC20: approve to the zero address");
1322 
1323         _allowances[owner][spender] = amount;
1324         emit Approval(owner, spender, amount);
1325     }
1326 
1327     /**
1328      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1329      *
1330      * Does not update the allowance amount in case of infinite allowance.
1331      * Revert if not enough allowance is available.
1332      *
1333      * Might emit an {Approval} event.
1334      */
1335     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1336         uint256 currentAllowance = allowance(owner, spender);
1337         if (currentAllowance != type(uint256).max) {
1338             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1339             unchecked {
1340                 _approve(owner, spender, currentAllowance - amount);
1341             }
1342         }
1343     }
1344 
1345     /**
1346      * @dev Hook that is called before any transfer of tokens. This includes
1347      * minting and burning.
1348      *
1349      * Calling conditions:
1350      *
1351      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1352      * will be transferred to `to`.
1353      * - when `from` is zero, `amount` tokens will be minted for `to`.
1354      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1355      * - `from` and `to` are never both zero.
1356      *
1357      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1358      */
1359     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1360 
1361     /**
1362      * @dev Hook that is called after any transfer of tokens. This includes
1363      * minting and burning.
1364      *
1365      * Calling conditions:
1366      *
1367      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1368      * has been transferred to `to`.
1369      * - when `from` is zero, `amount` tokens have been minted for `to`.
1370      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1371      * - `from` and `to` are never both zero.
1372      *
1373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1374      */
1375     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1376 }
1377 
1378 
1379 // File contracts/XNPToken.sol
1380 
1381   pragma solidity ^0.8.0;
1382   contract XNPToken is ERC20, AccessControl {
1383     string private __name = "ExenPay Token";
1384     string private __symbol = "XNP";
1385     uint8 private __decimals = 2;
1386     uint private __INITIAL_SUPPLY = 1500000000;
1387     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1388     event Burned(address addr, uint256 amount);
1389 
1390     constructor() public ERC20(__name, __symbol) {
1391         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1392         _setupRole(BURNER_ROLE, msg.sender);
1393         _mint(msg.sender, __INITIAL_SUPPLY);
1394     }
1395 
1396     function burn(address from, uint256 amount) public {
1397         require(hasRole(BURNER_ROLE, _msgSender()), "XNP Token: Caller is not a burner");
1398         _burn(from, amount);
1399         emit Burned(from, amount);
1400     }
1401 
1402     function decimals() public view virtual override returns (uint8) {
1403         return __decimals;
1404     }
1405   }