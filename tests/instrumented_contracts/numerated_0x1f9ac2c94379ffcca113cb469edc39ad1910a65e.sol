1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Implementation of the {IERC165} interface.
40  *
41  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
42  * for the additional interface id that will be supported. For example:
43  *
44  * ```solidity
45  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
46  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
47  * }
48  * ```
49  *
50  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
51  */
52 abstract contract ERC165 is IERC165 {
53     /**
54      * @dev See {IERC165-supportsInterface}.
55      */
56     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
57         return interfaceId == type(IERC165).interfaceId;
58     }
59 }
60 
61 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
62 
63 
64 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Standard signed math utilities missing in the Solidity language.
70  */
71 library SignedMath {
72     /**
73      * @dev Returns the largest of two signed numbers.
74      */
75     function max(int256 a, int256 b) internal pure returns (int256) {
76         return a > b ? a : b;
77     }
78 
79     /**
80      * @dev Returns the smallest of two signed numbers.
81      */
82     function min(int256 a, int256 b) internal pure returns (int256) {
83         return a < b ? a : b;
84     }
85 
86     /**
87      * @dev Returns the average of two signed numbers without overflow.
88      * The result is rounded towards zero.
89      */
90     function average(int256 a, int256 b) internal pure returns (int256) {
91         // Formula from the book "Hacker's Delight"
92         int256 x = (a & b) + ((a ^ b) >> 1);
93         return x + (int256(uint256(x) >> 255) & (a ^ b));
94     }
95 
96     /**
97      * @dev Returns the absolute unsigned value of a signed value.
98      */
99     function abs(int256 n) internal pure returns (uint256) {
100         unchecked {
101             // must be unchecked in order to support `n = type(int256).min`
102             return uint256(n >= 0 ? n : -n);
103         }
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/math/Math.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Standard math utilities missing in the Solidity language.
116  */
117 library Math {
118     enum Rounding {
119         Down, // Toward negative infinity
120         Up, // Toward infinity
121         Zero // Toward zero
122     }
123 
124     /**
125      * @dev Returns the largest of two numbers.
126      */
127     function max(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a > b ? a : b;
129     }
130 
131     /**
132      * @dev Returns the smallest of two numbers.
133      */
134     function min(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a < b ? a : b;
136     }
137 
138     /**
139      * @dev Returns the average of two numbers. The result is rounded towards
140      * zero.
141      */
142     function average(uint256 a, uint256 b) internal pure returns (uint256) {
143         // (a + b) / 2 can overflow.
144         return (a & b) + (a ^ b) / 2;
145     }
146 
147     /**
148      * @dev Returns the ceiling of the division of two numbers.
149      *
150      * This differs from standard division with `/` in that it rounds up instead
151      * of rounding down.
152      */
153     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
154         // (a + b - 1) / b can overflow on addition, so we distribute.
155         return a == 0 ? 0 : (a - 1) / b + 1;
156     }
157 
158     /**
159      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
160      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
161      * with further edits by Uniswap Labs also under MIT license.
162      */
163     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
164         unchecked {
165             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
166             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
167             // variables such that product = prod1 * 2^256 + prod0.
168             uint256 prod0; // Least significant 256 bits of the product
169             uint256 prod1; // Most significant 256 bits of the product
170             assembly {
171                 let mm := mulmod(x, y, not(0))
172                 prod0 := mul(x, y)
173                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
174             }
175 
176             // Handle non-overflow cases, 256 by 256 division.
177             if (prod1 == 0) {
178                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
179                 // The surrounding unchecked block does not change this fact.
180                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
181                 return prod0 / denominator;
182             }
183 
184             // Make sure the result is less than 2^256. Also prevents denominator == 0.
185             require(denominator > prod1, "Math: mulDiv overflow");
186 
187             ///////////////////////////////////////////////
188             // 512 by 256 division.
189             ///////////////////////////////////////////////
190 
191             // Make division exact by subtracting the remainder from [prod1 prod0].
192             uint256 remainder;
193             assembly {
194                 // Compute remainder using mulmod.
195                 remainder := mulmod(x, y, denominator)
196 
197                 // Subtract 256 bit number from 512 bit number.
198                 prod1 := sub(prod1, gt(remainder, prod0))
199                 prod0 := sub(prod0, remainder)
200             }
201 
202             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
203             // See https://cs.stackexchange.com/q/138556/92363.
204 
205             // Does not overflow because the denominator cannot be zero at this stage in the function.
206             uint256 twos = denominator & (~denominator + 1);
207             assembly {
208                 // Divide denominator by twos.
209                 denominator := div(denominator, twos)
210 
211                 // Divide [prod1 prod0] by twos.
212                 prod0 := div(prod0, twos)
213 
214                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
215                 twos := add(div(sub(0, twos), twos), 1)
216             }
217 
218             // Shift in bits from prod1 into prod0.
219             prod0 |= prod1 * twos;
220 
221             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
222             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
223             // four bits. That is, denominator * inv = 1 mod 2^4.
224             uint256 inverse = (3 * denominator) ^ 2;
225 
226             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
227             // in modular arithmetic, doubling the correct bits in each step.
228             inverse *= 2 - denominator * inverse; // inverse mod 2^8
229             inverse *= 2 - denominator * inverse; // inverse mod 2^16
230             inverse *= 2 - denominator * inverse; // inverse mod 2^32
231             inverse *= 2 - denominator * inverse; // inverse mod 2^64
232             inverse *= 2 - denominator * inverse; // inverse mod 2^128
233             inverse *= 2 - denominator * inverse; // inverse mod 2^256
234 
235             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
236             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
237             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
238             // is no longer required.
239             result = prod0 * inverse;
240             return result;
241         }
242     }
243 
244     /**
245      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
246      */
247     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
248         uint256 result = mulDiv(x, y, denominator);
249         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
250             result += 1;
251         }
252         return result;
253     }
254 
255     /**
256      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
257      *
258      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
259      */
260     function sqrt(uint256 a) internal pure returns (uint256) {
261         if (a == 0) {
262             return 0;
263         }
264 
265         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
266         //
267         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
268         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
269         //
270         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
271         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
272         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
273         //
274         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
275         uint256 result = 1 << (log2(a) >> 1);
276 
277         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
278         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
279         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
280         // into the expected uint128 result.
281         unchecked {
282             result = (result + a / result) >> 1;
283             result = (result + a / result) >> 1;
284             result = (result + a / result) >> 1;
285             result = (result + a / result) >> 1;
286             result = (result + a / result) >> 1;
287             result = (result + a / result) >> 1;
288             result = (result + a / result) >> 1;
289             return min(result, a / result);
290         }
291     }
292 
293     /**
294      * @notice Calculates sqrt(a), following the selected rounding direction.
295      */
296     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
297         unchecked {
298             uint256 result = sqrt(a);
299             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
300         }
301     }
302 
303     /**
304      * @dev Return the log in base 2, rounded down, of a positive value.
305      * Returns 0 if given 0.
306      */
307     function log2(uint256 value) internal pure returns (uint256) {
308         uint256 result = 0;
309         unchecked {
310             if (value >> 128 > 0) {
311                 value >>= 128;
312                 result += 128;
313             }
314             if (value >> 64 > 0) {
315                 value >>= 64;
316                 result += 64;
317             }
318             if (value >> 32 > 0) {
319                 value >>= 32;
320                 result += 32;
321             }
322             if (value >> 16 > 0) {
323                 value >>= 16;
324                 result += 16;
325             }
326             if (value >> 8 > 0) {
327                 value >>= 8;
328                 result += 8;
329             }
330             if (value >> 4 > 0) {
331                 value >>= 4;
332                 result += 4;
333             }
334             if (value >> 2 > 0) {
335                 value >>= 2;
336                 result += 2;
337             }
338             if (value >> 1 > 0) {
339                 result += 1;
340             }
341         }
342         return result;
343     }
344 
345     /**
346      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
347      * Returns 0 if given 0.
348      */
349     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
350         unchecked {
351             uint256 result = log2(value);
352             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
353         }
354     }
355 
356     /**
357      * @dev Return the log in base 10, rounded down, of a positive value.
358      * Returns 0 if given 0.
359      */
360     function log10(uint256 value) internal pure returns (uint256) {
361         uint256 result = 0;
362         unchecked {
363             if (value >= 10 ** 64) {
364                 value /= 10 ** 64;
365                 result += 64;
366             }
367             if (value >= 10 ** 32) {
368                 value /= 10 ** 32;
369                 result += 32;
370             }
371             if (value >= 10 ** 16) {
372                 value /= 10 ** 16;
373                 result += 16;
374             }
375             if (value >= 10 ** 8) {
376                 value /= 10 ** 8;
377                 result += 8;
378             }
379             if (value >= 10 ** 4) {
380                 value /= 10 ** 4;
381                 result += 4;
382             }
383             if (value >= 10 ** 2) {
384                 value /= 10 ** 2;
385                 result += 2;
386             }
387             if (value >= 10 ** 1) {
388                 result += 1;
389             }
390         }
391         return result;
392     }
393 
394     /**
395      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
396      * Returns 0 if given 0.
397      */
398     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
399         unchecked {
400             uint256 result = log10(value);
401             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
402         }
403     }
404 
405     /**
406      * @dev Return the log in base 256, rounded down, of a positive value.
407      * Returns 0 if given 0.
408      *
409      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
410      */
411     function log256(uint256 value) internal pure returns (uint256) {
412         uint256 result = 0;
413         unchecked {
414             if (value >> 128 > 0) {
415                 value >>= 128;
416                 result += 16;
417             }
418             if (value >> 64 > 0) {
419                 value >>= 64;
420                 result += 8;
421             }
422             if (value >> 32 > 0) {
423                 value >>= 32;
424                 result += 4;
425             }
426             if (value >> 16 > 0) {
427                 value >>= 16;
428                 result += 2;
429             }
430             if (value >> 8 > 0) {
431                 result += 1;
432             }
433         }
434         return result;
435     }
436 
437     /**
438      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
439      * Returns 0 if given 0.
440      */
441     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
442         unchecked {
443             uint256 result = log256(value);
444             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/utils/Strings.sol
450 
451 
452 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 
457 
458 /**
459  * @dev String operations.
460  */
461 library Strings {
462     bytes16 private constant _SYMBOLS = "0123456789abcdef";
463     uint8 private constant _ADDRESS_LENGTH = 20;
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
467      */
468     function toString(uint256 value) internal pure returns (string memory) {
469         unchecked {
470             uint256 length = Math.log10(value) + 1;
471             string memory buffer = new string(length);
472             uint256 ptr;
473             /// @solidity memory-safe-assembly
474             assembly {
475                 ptr := add(buffer, add(32, length))
476             }
477             while (true) {
478                 ptr--;
479                 /// @solidity memory-safe-assembly
480                 assembly {
481                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
482                 }
483                 value /= 10;
484                 if (value == 0) break;
485             }
486             return buffer;
487         }
488     }
489 
490     /**
491      * @dev Converts a `int256` to its ASCII `string` decimal representation.
492      */
493     function toString(int256 value) internal pure returns (string memory) {
494         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
495     }
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
499      */
500     function toHexString(uint256 value) internal pure returns (string memory) {
501         unchecked {
502             return toHexString(value, Math.log256(value) + 1);
503         }
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
508      */
509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
510         bytes memory buffer = new bytes(2 * length + 2);
511         buffer[0] = "0";
512         buffer[1] = "x";
513         for (uint256 i = 2 * length + 1; i > 1; --i) {
514             buffer[i] = _SYMBOLS[value & 0xf];
515             value >>= 4;
516         }
517         require(value == 0, "Strings: hex length insufficient");
518         return string(buffer);
519     }
520 
521     /**
522      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
523      */
524     function toHexString(address addr) internal pure returns (string memory) {
525         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
526     }
527 
528     /**
529      * @dev Returns true if the two strings are equal.
530      */
531     function equal(string memory a, string memory b) internal pure returns (bool) {
532         return keccak256(bytes(a)) == keccak256(bytes(b));
533     }
534 }
535 
536 // File: @openzeppelin/contracts/access/IAccessControl.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev External interface of AccessControl declared to support ERC165 detection.
545  */
546 interface IAccessControl {
547     /**
548      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
549      *
550      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
551      * {RoleAdminChanged} not being emitted signaling this.
552      *
553      * _Available since v3.1._
554      */
555     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
556 
557     /**
558      * @dev Emitted when `account` is granted `role`.
559      *
560      * `sender` is the account that originated the contract call, an admin role
561      * bearer except when using {AccessControl-_setupRole}.
562      */
563     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
564 
565     /**
566      * @dev Emitted when `account` is revoked `role`.
567      *
568      * `sender` is the account that originated the contract call:
569      *   - if using `revokeRole`, it is the admin role bearer
570      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
571      */
572     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
573 
574     /**
575      * @dev Returns `true` if `account` has been granted `role`.
576      */
577     function hasRole(bytes32 role, address account) external view returns (bool);
578 
579     /**
580      * @dev Returns the admin role that controls `role`. See {grantRole} and
581      * {revokeRole}.
582      *
583      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
584      */
585     function getRoleAdmin(bytes32 role) external view returns (bytes32);
586 
587     /**
588      * @dev Grants `role` to `account`.
589      *
590      * If `account` had not been already granted `role`, emits a {RoleGranted}
591      * event.
592      *
593      * Requirements:
594      *
595      * - the caller must have ``role``'s admin role.
596      */
597     function grantRole(bytes32 role, address account) external;
598 
599     /**
600      * @dev Revokes `role` from `account`.
601      *
602      * If `account` had been granted `role`, emits a {RoleRevoked} event.
603      *
604      * Requirements:
605      *
606      * - the caller must have ``role``'s admin role.
607      */
608     function revokeRole(bytes32 role, address account) external;
609 
610     /**
611      * @dev Revokes `role` from the calling account.
612      *
613      * Roles are often managed via {grantRole} and {revokeRole}: this function's
614      * purpose is to provide a mechanism for accounts to lose their privileges
615      * if they are compromised (such as when a trusted device is misplaced).
616      *
617      * If the calling account had been granted `role`, emits a {RoleRevoked}
618      * event.
619      *
620      * Requirements:
621      *
622      * - the caller must be `account`.
623      */
624     function renounceRole(bytes32 role, address account) external;
625 }
626 
627 // File: @openzeppelin/contracts/utils/Context.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Provides information about the current execution context, including the
636  * sender of the transaction and its data. While these are generally available
637  * via msg.sender and msg.data, they should not be accessed in such a direct
638  * manner, since when dealing with meta-transactions the account sending and
639  * paying for execution may not be the actual sender (as far as an application
640  * is concerned).
641  *
642  * This contract is only required for intermediate, library-like contracts.
643  */
644 abstract contract Context {
645     function _msgSender() internal view virtual returns (address) {
646         return msg.sender;
647     }
648 
649     function _msgData() internal view virtual returns (bytes calldata) {
650         return msg.data;
651     }
652 }
653 
654 // File: @openzeppelin/contracts/access/AccessControl.sol
655 
656 
657 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 
662 
663 
664 
665 /**
666  * @dev Contract module that allows children to implement role-based access
667  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
668  * members except through off-chain means by accessing the contract event logs. Some
669  * applications may benefit from on-chain enumerability, for those cases see
670  * {AccessControlEnumerable}.
671  *
672  * Roles are referred to by their `bytes32` identifier. These should be exposed
673  * in the external API and be unique. The best way to achieve this is by
674  * using `public constant` hash digests:
675  *
676  * ```solidity
677  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
678  * ```
679  *
680  * Roles can be used to represent a set of permissions. To restrict access to a
681  * function call, use {hasRole}:
682  *
683  * ```solidity
684  * function foo() public {
685  *     require(hasRole(MY_ROLE, msg.sender));
686  *     ...
687  * }
688  * ```
689  *
690  * Roles can be granted and revoked dynamically via the {grantRole} and
691  * {revokeRole} functions. Each role has an associated admin role, and only
692  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
693  *
694  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
695  * that only accounts with this role will be able to grant or revoke other
696  * roles. More complex role relationships can be created by using
697  * {_setRoleAdmin}.
698  *
699  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
700  * grant and revoke this role. Extra precautions should be taken to secure
701  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
702  * to enforce additional security measures for this role.
703  */
704 abstract contract AccessControl is Context, IAccessControl, ERC165 {
705     struct RoleData {
706         mapping(address => bool) members;
707         bytes32 adminRole;
708     }
709 
710     mapping(bytes32 => RoleData) private _roles;
711 
712     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
713 
714     /**
715      * @dev Modifier that checks that an account has a specific role. Reverts
716      * with a standardized message including the required role.
717      *
718      * The format of the revert reason is given by the following regular expression:
719      *
720      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
721      *
722      * _Available since v4.1._
723      */
724     modifier onlyRole(bytes32 role) {
725         _checkRole(role);
726         _;
727     }
728 
729     /**
730      * @dev See {IERC165-supportsInterface}.
731      */
732     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
733         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev Returns `true` if `account` has been granted `role`.
738      */
739     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
740         return _roles[role].members[account];
741     }
742 
743     /**
744      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
745      * Overriding this function changes the behavior of the {onlyRole} modifier.
746      *
747      * Format of the revert message is described in {_checkRole}.
748      *
749      * _Available since v4.6._
750      */
751     function _checkRole(bytes32 role) internal view virtual {
752         _checkRole(role, _msgSender());
753     }
754 
755     /**
756      * @dev Revert with a standard message if `account` is missing `role`.
757      *
758      * The format of the revert reason is given by the following regular expression:
759      *
760      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
761      */
762     function _checkRole(bytes32 role, address account) internal view virtual {
763         if (!hasRole(role, account)) {
764             revert(
765                 string(
766                     abi.encodePacked(
767                         "AccessControl: account ",
768                         Strings.toHexString(account),
769                         " is missing role ",
770                         Strings.toHexString(uint256(role), 32)
771                     )
772                 )
773             );
774         }
775     }
776 
777     /**
778      * @dev Returns the admin role that controls `role`. See {grantRole} and
779      * {revokeRole}.
780      *
781      * To change a role's admin, use {_setRoleAdmin}.
782      */
783     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
784         return _roles[role].adminRole;
785     }
786 
787     /**
788      * @dev Grants `role` to `account`.
789      *
790      * If `account` had not been already granted `role`, emits a {RoleGranted}
791      * event.
792      *
793      * Requirements:
794      *
795      * - the caller must have ``role``'s admin role.
796      *
797      * May emit a {RoleGranted} event.
798      */
799     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
800         _grantRole(role, account);
801     }
802 
803     /**
804      * @dev Revokes `role` from `account`.
805      *
806      * If `account` had been granted `role`, emits a {RoleRevoked} event.
807      *
808      * Requirements:
809      *
810      * - the caller must have ``role``'s admin role.
811      *
812      * May emit a {RoleRevoked} event.
813      */
814     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
815         _revokeRole(role, account);
816     }
817 
818     /**
819      * @dev Revokes `role` from the calling account.
820      *
821      * Roles are often managed via {grantRole} and {revokeRole}: this function's
822      * purpose is to provide a mechanism for accounts to lose their privileges
823      * if they are compromised (such as when a trusted device is misplaced).
824      *
825      * If the calling account had been revoked `role`, emits a {RoleRevoked}
826      * event.
827      *
828      * Requirements:
829      *
830      * - the caller must be `account`.
831      *
832      * May emit a {RoleRevoked} event.
833      */
834     function renounceRole(bytes32 role, address account) public virtual override {
835         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
836 
837         _revokeRole(role, account);
838     }
839 
840     /**
841      * @dev Grants `role` to `account`.
842      *
843      * If `account` had not been already granted `role`, emits a {RoleGranted}
844      * event. Note that unlike {grantRole}, this function doesn't perform any
845      * checks on the calling account.
846      *
847      * May emit a {RoleGranted} event.
848      *
849      * [WARNING]
850      * ====
851      * This function should only be called from the constructor when setting
852      * up the initial roles for the system.
853      *
854      * Using this function in any other way is effectively circumventing the admin
855      * system imposed by {AccessControl}.
856      * ====
857      *
858      * NOTE: This function is deprecated in favor of {_grantRole}.
859      */
860     function _setupRole(bytes32 role, address account) internal virtual {
861         _grantRole(role, account);
862     }
863 
864     /**
865      * @dev Sets `adminRole` as ``role``'s admin role.
866      *
867      * Emits a {RoleAdminChanged} event.
868      */
869     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
870         bytes32 previousAdminRole = getRoleAdmin(role);
871         _roles[role].adminRole = adminRole;
872         emit RoleAdminChanged(role, previousAdminRole, adminRole);
873     }
874 
875     /**
876      * @dev Grants `role` to `account`.
877      *
878      * Internal function without access restriction.
879      *
880      * May emit a {RoleGranted} event.
881      */
882     function _grantRole(bytes32 role, address account) internal virtual {
883         if (!hasRole(role, account)) {
884             _roles[role].members[account] = true;
885             emit RoleGranted(role, account, _msgSender());
886         }
887     }
888 
889     /**
890      * @dev Revokes `role` from `account`.
891      *
892      * Internal function without access restriction.
893      *
894      * May emit a {RoleRevoked} event.
895      */
896     function _revokeRole(bytes32 role, address account) internal virtual {
897         if (hasRole(role, account)) {
898             _roles[role].members[account] = false;
899             emit RoleRevoked(role, account, _msgSender());
900         }
901     }
902 }
903 
904 // File: @openzeppelin/contracts/security/Pausable.sol
905 
906 
907 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @dev Contract module which allows children to implement an emergency stop
914  * mechanism that can be triggered by an authorized account.
915  *
916  * This module is used through inheritance. It will make available the
917  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
918  * the functions of your contract. Note that they will not be pausable by
919  * simply including this module, only once the modifiers are put in place.
920  */
921 abstract contract Pausable is Context {
922     /**
923      * @dev Emitted when the pause is triggered by `account`.
924      */
925     event Paused(address account);
926 
927     /**
928      * @dev Emitted when the pause is lifted by `account`.
929      */
930     event Unpaused(address account);
931 
932     bool private _paused;
933 
934     /**
935      * @dev Initializes the contract in unpaused state.
936      */
937     constructor() {
938         _paused = false;
939     }
940 
941     /**
942      * @dev Modifier to make a function callable only when the contract is not paused.
943      *
944      * Requirements:
945      *
946      * - The contract must not be paused.
947      */
948     modifier whenNotPaused() {
949         _requireNotPaused();
950         _;
951     }
952 
953     /**
954      * @dev Modifier to make a function callable only when the contract is paused.
955      *
956      * Requirements:
957      *
958      * - The contract must be paused.
959      */
960     modifier whenPaused() {
961         _requirePaused();
962         _;
963     }
964 
965     /**
966      * @dev Returns true if the contract is paused, and false otherwise.
967      */
968     function paused() public view virtual returns (bool) {
969         return _paused;
970     }
971 
972     /**
973      * @dev Throws if the contract is paused.
974      */
975     function _requireNotPaused() internal view virtual {
976         require(!paused(), "Pausable: paused");
977     }
978 
979     /**
980      * @dev Throws if the contract is not paused.
981      */
982     function _requirePaused() internal view virtual {
983         require(paused(), "Pausable: not paused");
984     }
985 
986     /**
987      * @dev Triggers stopped state.
988      *
989      * Requirements:
990      *
991      * - The contract must not be paused.
992      */
993     function _pause() internal virtual whenNotPaused {
994         _paused = true;
995         emit Paused(_msgSender());
996     }
997 
998     /**
999      * @dev Returns to normal state.
1000      *
1001      * Requirements:
1002      *
1003      * - The contract must be paused.
1004      */
1005     function _unpause() internal virtual whenPaused {
1006         _paused = false;
1007         emit Unpaused(_msgSender());
1008     }
1009 }
1010 
1011 // File: WhitelistPausable.sol
1012 
1013 
1014 pragma solidity ^0.8.9;
1015 
1016 
1017 abstract contract WhitelistPausable is Pausable
1018 {
1019     address[] private _whitelistKeys;
1020     mapping(address => bool) private _whitelist;
1021 
1022     event WhitelistAdded(address indexed account, address indexed sender);
1023     event WhitelistRemoved(address indexed account, address indexed sender);
1024     event WhitelistReseted(address indexed sender);
1025     
1026     modifier whenNotPausedWithAccount(address account) {
1027         _requireNotPaused(account);
1028         _;
1029     }
1030 
1031     function _addWhitelist(address account) internal virtual {
1032         _whitelist[account] = true;
1033         _whitelistKeys.push(account);
1034         emit WhitelistAdded(account, _msgSender());
1035     }
1036 
1037     function _removeWhitelist(address account) internal virtual {
1038         _whitelist[account] = false;
1039         _whitelistKeys.push(account);
1040         emit WhitelistRemoved(account, _msgSender());
1041     }
1042 
1043 
1044     function _resetWhitelist() internal virtual {
1045         for (uint i=0; i< _whitelistKeys.length ; i++){
1046             _whitelist[_whitelistKeys[i]] = false;
1047         }
1048         emit WhitelistReseted(_msgSender());
1049     }
1050 
1051     function getWhitelist(address account) public view virtual returns (bool) {
1052         return _whitelist[account];
1053     }
1054 
1055     /**
1056      * @dev Throws if the contract is paused.
1057      */
1058     function _requireNotPaused(address account) internal view virtual {
1059         require(!paused() || getWhitelist(account), "Pausable: paused");
1060     }
1061 
1062     /**
1063      * @dev Throws if the contract is not paused.
1064      */
1065     function _requirePaused(address account) internal view virtual {
1066         require(paused() && !getWhitelist(account), "Pausable: not paused");
1067     }
1068 
1069 }
1070 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1071 
1072 
1073 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1074 
1075 pragma solidity ^0.8.0;
1076 
1077 /**
1078  * @dev Interface of the ERC20 standard as defined in the EIP.
1079  */
1080 interface IERC20 {
1081     /**
1082      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1083      * another (`to`).
1084      *
1085      * Note that `value` may be zero.
1086      */
1087     event Transfer(address indexed from, address indexed to, uint256 value);
1088 
1089     /**
1090      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1091      * a call to {approve}. `value` is the new allowance.
1092      */
1093     event Approval(address indexed owner, address indexed spender, uint256 value);
1094 
1095     /**
1096      * @dev Returns the amount of tokens in existence.
1097      */
1098     function totalSupply() external view returns (uint256);
1099 
1100     /**
1101      * @dev Returns the amount of tokens owned by `account`.
1102      */
1103     function balanceOf(address account) external view returns (uint256);
1104 
1105     /**
1106      * @dev Moves `amount` tokens from the caller's account to `to`.
1107      *
1108      * Returns a boolean value indicating whether the operation succeeded.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function transfer(address to, uint256 amount) external returns (bool);
1113 
1114     /**
1115      * @dev Returns the remaining number of tokens that `spender` will be
1116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1117      * zero by default.
1118      *
1119      * This value changes when {approve} or {transferFrom} are called.
1120      */
1121     function allowance(address owner, address spender) external view returns (uint256);
1122 
1123     /**
1124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1125      *
1126      * Returns a boolean value indicating whether the operation succeeded.
1127      *
1128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1129      * that someone may use both the old and the new allowance by unfortunate
1130      * transaction ordering. One possible solution to mitigate this race
1131      * condition is to first reduce the spender's allowance to 0 and set the
1132      * desired value afterwards:
1133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1134      *
1135      * Emits an {Approval} event.
1136      */
1137     function approve(address spender, uint256 amount) external returns (bool);
1138 
1139     /**
1140      * @dev Moves `amount` tokens from `from` to `to` using the
1141      * allowance mechanism. `amount` is then deducted from the caller's
1142      * allowance.
1143      *
1144      * Returns a boolean value indicating whether the operation succeeded.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1149 }
1150 
1151 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1152 
1153 
1154 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 
1159 /**
1160  * @dev Interface for the optional metadata functions from the ERC20 standard.
1161  *
1162  * _Available since v4.1._
1163  */
1164 interface IERC20Metadata is IERC20 {
1165     /**
1166      * @dev Returns the name of the token.
1167      */
1168     function name() external view returns (string memory);
1169 
1170     /**
1171      * @dev Returns the symbol of the token.
1172      */
1173     function symbol() external view returns (string memory);
1174 
1175     /**
1176      * @dev Returns the decimals places of the token.
1177      */
1178     function decimals() external view returns (uint8);
1179 }
1180 
1181 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1182 
1183 
1184 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 
1189 
1190 
1191 /**
1192  * @dev Implementation of the {IERC20} interface.
1193  *
1194  * This implementation is agnostic to the way tokens are created. This means
1195  * that a supply mechanism has to be added in a derived contract using {_mint}.
1196  * For a generic mechanism see {ERC20PresetMinterPauser}.
1197  *
1198  * TIP: For a detailed writeup see our guide
1199  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1200  * to implement supply mechanisms].
1201  *
1202  * The default value of {decimals} is 18. To change this, you should override
1203  * this function so it returns a different value.
1204  *
1205  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1206  * instead returning `false` on failure. This behavior is nonetheless
1207  * conventional and does not conflict with the expectations of ERC20
1208  * applications.
1209  *
1210  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1211  * This allows applications to reconstruct the allowance for all accounts just
1212  * by listening to said events. Other implementations of the EIP may not emit
1213  * these events, as it isn't required by the specification.
1214  *
1215  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1216  * functions have been added to mitigate the well-known issues around setting
1217  * allowances. See {IERC20-approve}.
1218  */
1219 contract ERC20 is Context, IERC20, IERC20Metadata {
1220     mapping(address => uint256) private _balances;
1221 
1222     mapping(address => mapping(address => uint256)) private _allowances;
1223 
1224     uint256 private _totalSupply;
1225 
1226     string private _name;
1227     string private _symbol;
1228 
1229     /**
1230      * @dev Sets the values for {name} and {symbol}.
1231      *
1232      * All two of these values are immutable: they can only be set once during
1233      * construction.
1234      */
1235     constructor(string memory name_, string memory symbol_) {
1236         _name = name_;
1237         _symbol = symbol_;
1238     }
1239 
1240     /**
1241      * @dev Returns the name of the token.
1242      */
1243     function name() public view virtual override returns (string memory) {
1244         return _name;
1245     }
1246 
1247     /**
1248      * @dev Returns the symbol of the token, usually a shorter version of the
1249      * name.
1250      */
1251     function symbol() public view virtual override returns (string memory) {
1252         return _symbol;
1253     }
1254 
1255     /**
1256      * @dev Returns the number of decimals used to get its user representation.
1257      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1258      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1259      *
1260      * Tokens usually opt for a value of 18, imitating the relationship between
1261      * Ether and Wei. This is the default value returned by this function, unless
1262      * it's overridden.
1263      *
1264      * NOTE: This information is only used for _display_ purposes: it in
1265      * no way affects any of the arithmetic of the contract, including
1266      * {IERC20-balanceOf} and {IERC20-transfer}.
1267      */
1268     function decimals() public view virtual override returns (uint8) {
1269         return 18;
1270     }
1271 
1272     /**
1273      * @dev See {IERC20-totalSupply}.
1274      */
1275     function totalSupply() public view virtual override returns (uint256) {
1276         return _totalSupply;
1277     }
1278 
1279     /**
1280      * @dev See {IERC20-balanceOf}.
1281      */
1282     function balanceOf(address account) public view virtual override returns (uint256) {
1283         return _balances[account];
1284     }
1285 
1286     /**
1287      * @dev See {IERC20-transfer}.
1288      *
1289      * Requirements:
1290      *
1291      * - `to` cannot be the zero address.
1292      * - the caller must have a balance of at least `amount`.
1293      */
1294     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1295         address owner = _msgSender();
1296         _transfer(owner, to, amount);
1297         return true;
1298     }
1299 
1300     /**
1301      * @dev See {IERC20-allowance}.
1302      */
1303     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1304         return _allowances[owner][spender];
1305     }
1306 
1307     /**
1308      * @dev See {IERC20-approve}.
1309      *
1310      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1311      * `transferFrom`. This is semantically equivalent to an infinite approval.
1312      *
1313      * Requirements:
1314      *
1315      * - `spender` cannot be the zero address.
1316      */
1317     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1318         address owner = _msgSender();
1319         _approve(owner, spender, amount);
1320         return true;
1321     }
1322 
1323     /**
1324      * @dev See {IERC20-transferFrom}.
1325      *
1326      * Emits an {Approval} event indicating the updated allowance. This is not
1327      * required by the EIP. See the note at the beginning of {ERC20}.
1328      *
1329      * NOTE: Does not update the allowance if the current allowance
1330      * is the maximum `uint256`.
1331      *
1332      * Requirements:
1333      *
1334      * - `from` and `to` cannot be the zero address.
1335      * - `from` must have a balance of at least `amount`.
1336      * - the caller must have allowance for ``from``'s tokens of at least
1337      * `amount`.
1338      */
1339     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1340         address spender = _msgSender();
1341         _spendAllowance(from, spender, amount);
1342         _transfer(from, to, amount);
1343         return true;
1344     }
1345 
1346     /**
1347      * @dev Atomically increases the allowance granted to `spender` by the caller.
1348      *
1349      * This is an alternative to {approve} that can be used as a mitigation for
1350      * problems described in {IERC20-approve}.
1351      *
1352      * Emits an {Approval} event indicating the updated allowance.
1353      *
1354      * Requirements:
1355      *
1356      * - `spender` cannot be the zero address.
1357      */
1358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1359         address owner = _msgSender();
1360         _approve(owner, spender, allowance(owner, spender) + addedValue);
1361         return true;
1362     }
1363 
1364     /**
1365      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1366      *
1367      * This is an alternative to {approve} that can be used as a mitigation for
1368      * problems described in {IERC20-approve}.
1369      *
1370      * Emits an {Approval} event indicating the updated allowance.
1371      *
1372      * Requirements:
1373      *
1374      * - `spender` cannot be the zero address.
1375      * - `spender` must have allowance for the caller of at least
1376      * `subtractedValue`.
1377      */
1378     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1379         address owner = _msgSender();
1380         uint256 currentAllowance = allowance(owner, spender);
1381         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1382         unchecked {
1383             _approve(owner, spender, currentAllowance - subtractedValue);
1384         }
1385 
1386         return true;
1387     }
1388 
1389     /**
1390      * @dev Moves `amount` of tokens from `from` to `to`.
1391      *
1392      * This internal function is equivalent to {transfer}, and can be used to
1393      * e.g. implement automatic token fees, slashing mechanisms, etc.
1394      *
1395      * Emits a {Transfer} event.
1396      *
1397      * Requirements:
1398      *
1399      * - `from` cannot be the zero address.
1400      * - `to` cannot be the zero address.
1401      * - `from` must have a balance of at least `amount`.
1402      */
1403     function _transfer(address from, address to, uint256 amount) internal virtual {
1404         require(from != address(0), "ERC20: transfer from the zero address");
1405         require(to != address(0), "ERC20: transfer to the zero address");
1406 
1407         _beforeTokenTransfer(from, to, amount);
1408 
1409         uint256 fromBalance = _balances[from];
1410         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1411         unchecked {
1412             _balances[from] = fromBalance - amount;
1413             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1414             // decrementing then incrementing.
1415             _balances[to] += amount;
1416         }
1417 
1418         emit Transfer(from, to, amount);
1419 
1420         _afterTokenTransfer(from, to, amount);
1421     }
1422 
1423     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1424      * the total supply.
1425      *
1426      * Emits a {Transfer} event with `from` set to the zero address.
1427      *
1428      * Requirements:
1429      *
1430      * - `account` cannot be the zero address.
1431      */
1432     function _mint(address account, uint256 amount) internal virtual {
1433         require(account != address(0), "ERC20: mint to the zero address");
1434 
1435         _beforeTokenTransfer(address(0), account, amount);
1436 
1437         _totalSupply += amount;
1438         unchecked {
1439             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1440             _balances[account] += amount;
1441         }
1442         emit Transfer(address(0), account, amount);
1443 
1444         _afterTokenTransfer(address(0), account, amount);
1445     }
1446 
1447     /**
1448      * @dev Destroys `amount` tokens from `account`, reducing the
1449      * total supply.
1450      *
1451      * Emits a {Transfer} event with `to` set to the zero address.
1452      *
1453      * Requirements:
1454      *
1455      * - `account` cannot be the zero address.
1456      * - `account` must have at least `amount` tokens.
1457      */
1458     function _burn(address account, uint256 amount) internal virtual {
1459         require(account != address(0), "ERC20: burn from the zero address");
1460 
1461         _beforeTokenTransfer(account, address(0), amount);
1462 
1463         uint256 accountBalance = _balances[account];
1464         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1465         unchecked {
1466             _balances[account] = accountBalance - amount;
1467             // Overflow not possible: amount <= accountBalance <= totalSupply.
1468             _totalSupply -= amount;
1469         }
1470 
1471         emit Transfer(account, address(0), amount);
1472 
1473         _afterTokenTransfer(account, address(0), amount);
1474     }
1475 
1476     /**
1477      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1478      *
1479      * This internal function is equivalent to `approve`, and can be used to
1480      * e.g. set automatic allowances for certain subsystems, etc.
1481      *
1482      * Emits an {Approval} event.
1483      *
1484      * Requirements:
1485      *
1486      * - `owner` cannot be the zero address.
1487      * - `spender` cannot be the zero address.
1488      */
1489     function _approve(address owner, address spender, uint256 amount) internal virtual {
1490         require(owner != address(0), "ERC20: approve from the zero address");
1491         require(spender != address(0), "ERC20: approve to the zero address");
1492 
1493         _allowances[owner][spender] = amount;
1494         emit Approval(owner, spender, amount);
1495     }
1496 
1497     /**
1498      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1499      *
1500      * Does not update the allowance amount in case of infinite allowance.
1501      * Revert if not enough allowance is available.
1502      *
1503      * Might emit an {Approval} event.
1504      */
1505     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1506         uint256 currentAllowance = allowance(owner, spender);
1507         if (currentAllowance != type(uint256).max) {
1508             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1509             unchecked {
1510                 _approve(owner, spender, currentAllowance - amount);
1511             }
1512         }
1513     }
1514 
1515     /**
1516      * @dev Hook that is called before any transfer of tokens. This includes
1517      * minting and burning.
1518      *
1519      * Calling conditions:
1520      *
1521      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1522      * will be transferred to `to`.
1523      * - when `from` is zero, `amount` tokens will be minted for `to`.
1524      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1525      * - `from` and `to` are never both zero.
1526      *
1527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1528      */
1529     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1530 
1531     /**
1532      * @dev Hook that is called after any transfer of tokens. This includes
1533      * minting and burning.
1534      *
1535      * Calling conditions:
1536      *
1537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1538      * has been transferred to `to`.
1539      * - when `from` is zero, `amount` tokens have been minted for `to`.
1540      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1541      * - `from` and `to` are never both zero.
1542      *
1543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1544      */
1545     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1546 }
1547 
1548 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1549 
1550 
1551 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1552 
1553 pragma solidity ^0.8.0;
1554 
1555 
1556 
1557 /**
1558  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1559  * tokens and those that they have an allowance for, in a way that can be
1560  * recognized off-chain (via event analysis).
1561  */
1562 abstract contract ERC20Burnable is Context, ERC20 {
1563     /**
1564      * @dev Destroys `amount` tokens from the caller.
1565      *
1566      * See {ERC20-_burn}.
1567      */
1568     function burn(uint256 amount) public virtual {
1569         _burn(_msgSender(), amount);
1570     }
1571 
1572     /**
1573      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1574      * allowance.
1575      *
1576      * See {ERC20-_burn} and {ERC20-allowance}.
1577      *
1578      * Requirements:
1579      *
1580      * - the caller must have allowance for ``accounts``'s tokens of at least
1581      * `amount`.
1582      */
1583     function burnFrom(address account, uint256 amount) public virtual {
1584         _spendAllowance(account, _msgSender(), amount);
1585         _burn(account, amount);
1586     }
1587 }
1588 
1589 // File: PausableToken.sol
1590 
1591 
1592 pragma solidity ^0.8.9;
1593 
1594 
1595 
1596 
1597 
1598 
1599 contract PausableToken is ERC20, ERC20Burnable, WhitelistPausable, AccessControl {
1600     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1601     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1602 
1603     constructor() ERC20("X Bird", "XBD") {
1604         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1605         _grantRole(PAUSER_ROLE, msg.sender);
1606         _grantRole(MINTER_ROLE, msg.sender);
1607     }
1608 
1609     function pause() public onlyRole(PAUSER_ROLE) {
1610         _pause();
1611     }
1612 
1613     function unpause() public onlyRole(PAUSER_ROLE) {
1614         _unpause();
1615     }
1616 
1617     function addWhitelist(address account) public onlyRole(PAUSER_ROLE) {
1618         _addWhitelist(account);
1619     }
1620 
1621     function removeWhitelist(address account) public onlyRole(PAUSER_ROLE) {
1622         _removeWhitelist(account);
1623     }
1624     
1625     function resetWhitelist() public onlyRole(PAUSER_ROLE) {
1626         _resetWhitelist();
1627     }
1628     
1629 
1630     function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
1631         _mint(to, amount);
1632     }
1633 
1634     function _beforeTokenTransfer(address from, address to, uint256 amount)
1635         internal
1636         whenNotPausedWithAccount(from)
1637         override
1638     {
1639         super._beforeTokenTransfer(from, to, amount);
1640     }
1641 }