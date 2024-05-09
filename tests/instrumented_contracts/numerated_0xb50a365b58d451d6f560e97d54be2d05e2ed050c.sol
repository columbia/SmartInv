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
60 // File: @openzeppelin/contracts/utils/math/Math.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev Standard math utilities missing in the Solidity language.
69  */
70 library Math {
71     enum Rounding {
72         Down, // Toward negative infinity
73         Up, // Toward infinity
74         Zero // Toward zero
75     }
76 
77     /**
78      * @dev Returns the largest of two numbers.
79      */
80     function max(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a > b ? a : b;
82     }
83 
84     /**
85      * @dev Returns the smallest of two numbers.
86      */
87     function min(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a < b ? a : b;
89     }
90 
91     /**
92      * @dev Returns the average of two numbers. The result is rounded towards
93      * zero.
94      */
95     function average(uint256 a, uint256 b) internal pure returns (uint256) {
96         // (a + b) / 2 can overflow.
97         return (a & b) + (a ^ b) / 2;
98     }
99 
100     /**
101      * @dev Returns the ceiling of the division of two numbers.
102      *
103      * This differs from standard division with `/` in that it rounds up instead
104      * of rounding down.
105      */
106     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
107         // (a + b - 1) / b can overflow on addition, so we distribute.
108         return a == 0 ? 0 : (a - 1) / b + 1;
109     }
110 
111     /**
112      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
113      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
114      * with further edits by Uniswap Labs also under MIT license.
115      */
116     function mulDiv(
117         uint256 x,
118         uint256 y,
119         uint256 denominator
120     ) internal pure returns (uint256 result) {
121         unchecked {
122             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
123             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
124             // variables such that product = prod1 * 2^256 + prod0.
125             uint256 prod0; // Least significant 256 bits of the product
126             uint256 prod1; // Most significant 256 bits of the product
127             assembly {
128                 let mm := mulmod(x, y, not(0))
129                 prod0 := mul(x, y)
130                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
131             }
132 
133             // Handle non-overflow cases, 256 by 256 division.
134             if (prod1 == 0) {
135                 return prod0 / denominator;
136             }
137 
138             // Make sure the result is less than 2^256. Also prevents denominator == 0.
139             require(denominator > prod1);
140 
141             ///////////////////////////////////////////////
142             // 512 by 256 division.
143             ///////////////////////////////////////////////
144 
145             // Make division exact by subtracting the remainder from [prod1 prod0].
146             uint256 remainder;
147             assembly {
148                 // Compute remainder using mulmod.
149                 remainder := mulmod(x, y, denominator)
150 
151                 // Subtract 256 bit number from 512 bit number.
152                 prod1 := sub(prod1, gt(remainder, prod0))
153                 prod0 := sub(prod0, remainder)
154             }
155 
156             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
157             // See https://cs.stackexchange.com/q/138556/92363.
158 
159             // Does not overflow because the denominator cannot be zero at this stage in the function.
160             uint256 twos = denominator & (~denominator + 1);
161             assembly {
162                 // Divide denominator by twos.
163                 denominator := div(denominator, twos)
164 
165                 // Divide [prod1 prod0] by twos.
166                 prod0 := div(prod0, twos)
167 
168                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
169                 twos := add(div(sub(0, twos), twos), 1)
170             }
171 
172             // Shift in bits from prod1 into prod0.
173             prod0 |= prod1 * twos;
174 
175             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
176             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
177             // four bits. That is, denominator * inv = 1 mod 2^4.
178             uint256 inverse = (3 * denominator) ^ 2;
179 
180             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
181             // in modular arithmetic, doubling the correct bits in each step.
182             inverse *= 2 - denominator * inverse; // inverse mod 2^8
183             inverse *= 2 - denominator * inverse; // inverse mod 2^16
184             inverse *= 2 - denominator * inverse; // inverse mod 2^32
185             inverse *= 2 - denominator * inverse; // inverse mod 2^64
186             inverse *= 2 - denominator * inverse; // inverse mod 2^128
187             inverse *= 2 - denominator * inverse; // inverse mod 2^256
188 
189             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
190             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
191             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
192             // is no longer required.
193             result = prod0 * inverse;
194             return result;
195         }
196     }
197 
198     /**
199      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
200      */
201     function mulDiv(
202         uint256 x,
203         uint256 y,
204         uint256 denominator,
205         Rounding rounding
206     ) internal pure returns (uint256) {
207         uint256 result = mulDiv(x, y, denominator);
208         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
209             result += 1;
210         }
211         return result;
212     }
213 
214     /**
215      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
216      *
217      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
218      */
219     function sqrt(uint256 a) internal pure returns (uint256) {
220         if (a == 0) {
221             return 0;
222         }
223 
224         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
225         //
226         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
227         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
228         //
229         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
230         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
231         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
232         //
233         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
234         uint256 result = 1 << (log2(a) >> 1);
235 
236         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
237         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
238         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
239         // into the expected uint128 result.
240         unchecked {
241             result = (result + a / result) >> 1;
242             result = (result + a / result) >> 1;
243             result = (result + a / result) >> 1;
244             result = (result + a / result) >> 1;
245             result = (result + a / result) >> 1;
246             result = (result + a / result) >> 1;
247             result = (result + a / result) >> 1;
248             return min(result, a / result);
249         }
250     }
251 
252     /**
253      * @notice Calculates sqrt(a), following the selected rounding direction.
254      */
255     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
256         unchecked {
257             uint256 result = sqrt(a);
258             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
259         }
260     }
261 
262     /**
263      * @dev Return the log in base 2, rounded down, of a positive value.
264      * Returns 0 if given 0.
265      */
266     function log2(uint256 value) internal pure returns (uint256) {
267         uint256 result = 0;
268         unchecked {
269             if (value >> 128 > 0) {
270                 value >>= 128;
271                 result += 128;
272             }
273             if (value >> 64 > 0) {
274                 value >>= 64;
275                 result += 64;
276             }
277             if (value >> 32 > 0) {
278                 value >>= 32;
279                 result += 32;
280             }
281             if (value >> 16 > 0) {
282                 value >>= 16;
283                 result += 16;
284             }
285             if (value >> 8 > 0) {
286                 value >>= 8;
287                 result += 8;
288             }
289             if (value >> 4 > 0) {
290                 value >>= 4;
291                 result += 4;
292             }
293             if (value >> 2 > 0) {
294                 value >>= 2;
295                 result += 2;
296             }
297             if (value >> 1 > 0) {
298                 result += 1;
299             }
300         }
301         return result;
302     }
303 
304     /**
305      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
306      * Returns 0 if given 0.
307      */
308     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
309         unchecked {
310             uint256 result = log2(value);
311             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
312         }
313     }
314 
315     /**
316      * @dev Return the log in base 10, rounded down, of a positive value.
317      * Returns 0 if given 0.
318      */
319     function log10(uint256 value) internal pure returns (uint256) {
320         uint256 result = 0;
321         unchecked {
322             if (value >= 10**64) {
323                 value /= 10**64;
324                 result += 64;
325             }
326             if (value >= 10**32) {
327                 value /= 10**32;
328                 result += 32;
329             }
330             if (value >= 10**16) {
331                 value /= 10**16;
332                 result += 16;
333             }
334             if (value >= 10**8) {
335                 value /= 10**8;
336                 result += 8;
337             }
338             if (value >= 10**4) {
339                 value /= 10**4;
340                 result += 4;
341             }
342             if (value >= 10**2) {
343                 value /= 10**2;
344                 result += 2;
345             }
346             if (value >= 10**1) {
347                 result += 1;
348             }
349         }
350         return result;
351     }
352 
353     /**
354      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
355      * Returns 0 if given 0.
356      */
357     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
358         unchecked {
359             uint256 result = log10(value);
360             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
361         }
362     }
363 
364     /**
365      * @dev Return the log in base 256, rounded down, of a positive value.
366      * Returns 0 if given 0.
367      *
368      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
369      */
370     function log256(uint256 value) internal pure returns (uint256) {
371         uint256 result = 0;
372         unchecked {
373             if (value >> 128 > 0) {
374                 value >>= 128;
375                 result += 16;
376             }
377             if (value >> 64 > 0) {
378                 value >>= 64;
379                 result += 8;
380             }
381             if (value >> 32 > 0) {
382                 value >>= 32;
383                 result += 4;
384             }
385             if (value >> 16 > 0) {
386                 value >>= 16;
387                 result += 2;
388             }
389             if (value >> 8 > 0) {
390                 result += 1;
391             }
392         }
393         return result;
394     }
395 
396     /**
397      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
398      * Returns 0 if given 0.
399      */
400     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
401         unchecked {
402             uint256 result = log256(value);
403             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
404         }
405     }
406 }
407 
408 // File: @openzeppelin/contracts/utils/Strings.sol
409 
410 
411 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 
416 /**
417  * @dev String operations.
418  */
419 library Strings {
420     bytes16 private constant _SYMBOLS = "0123456789abcdef";
421     uint8 private constant _ADDRESS_LENGTH = 20;
422 
423     /**
424      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
425      */
426     function toString(uint256 value) internal pure returns (string memory) {
427         unchecked {
428             uint256 length = Math.log10(value) + 1;
429             string memory buffer = new string(length);
430             uint256 ptr;
431             /// @solidity memory-safe-assembly
432             assembly {
433                 ptr := add(buffer, add(32, length))
434             }
435             while (true) {
436                 ptr--;
437                 /// @solidity memory-safe-assembly
438                 assembly {
439                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
440                 }
441                 value /= 10;
442                 if (value == 0) break;
443             }
444             return buffer;
445         }
446     }
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
450      */
451     function toHexString(uint256 value) internal pure returns (string memory) {
452         unchecked {
453             return toHexString(value, Math.log256(value) + 1);
454         }
455     }
456 
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
459      */
460     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
461         bytes memory buffer = new bytes(2 * length + 2);
462         buffer[0] = "0";
463         buffer[1] = "x";
464         for (uint256 i = 2 * length + 1; i > 1; --i) {
465             buffer[i] = _SYMBOLS[value & 0xf];
466             value >>= 4;
467         }
468         require(value == 0, "Strings: hex length insufficient");
469         return string(buffer);
470     }
471 
472     /**
473      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
474      */
475     function toHexString(address addr) internal pure returns (string memory) {
476         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
477     }
478 }
479 
480 // File: @openzeppelin/contracts/access/IAccessControl.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev External interface of AccessControl declared to support ERC165 detection.
489  */
490 interface IAccessControl {
491     /**
492      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
493      *
494      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
495      * {RoleAdminChanged} not being emitted signaling this.
496      *
497      * _Available since v3.1._
498      */
499     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
500 
501     /**
502      * @dev Emitted when `account` is granted `role`.
503      *
504      * `sender` is the account that originated the contract call, an admin role
505      * bearer except when using {AccessControl-_setupRole}.
506      */
507     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
508 
509     /**
510      * @dev Emitted when `account` is revoked `role`.
511      *
512      * `sender` is the account that originated the contract call:
513      *   - if using `revokeRole`, it is the admin role bearer
514      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
515      */
516     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
517 
518     /**
519      * @dev Returns `true` if `account` has been granted `role`.
520      */
521     function hasRole(bytes32 role, address account) external view returns (bool);
522 
523     /**
524      * @dev Returns the admin role that controls `role`. See {grantRole} and
525      * {revokeRole}.
526      *
527      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
528      */
529     function getRoleAdmin(bytes32 role) external view returns (bytes32);
530 
531     /**
532      * @dev Grants `role` to `account`.
533      *
534      * If `account` had not been already granted `role`, emits a {RoleGranted}
535      * event.
536      *
537      * Requirements:
538      *
539      * - the caller must have ``role``'s admin role.
540      */
541     function grantRole(bytes32 role, address account) external;
542 
543     /**
544      * @dev Revokes `role` from `account`.
545      *
546      * If `account` had been granted `role`, emits a {RoleRevoked} event.
547      *
548      * Requirements:
549      *
550      * - the caller must have ``role``'s admin role.
551      */
552     function revokeRole(bytes32 role, address account) external;
553 
554     /**
555      * @dev Revokes `role` from the calling account.
556      *
557      * Roles are often managed via {grantRole} and {revokeRole}: this function's
558      * purpose is to provide a mechanism for accounts to lose their privileges
559      * if they are compromised (such as when a trusted device is misplaced).
560      *
561      * If the calling account had been granted `role`, emits a {RoleRevoked}
562      * event.
563      *
564      * Requirements:
565      *
566      * - the caller must be `account`.
567      */
568     function renounceRole(bytes32 role, address account) external;
569 }
570 
571 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
572 
573 
574 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 // CAUTION
579 // This version of SafeMath should only be used with Solidity 0.8 or later,
580 // because it relies on the compiler's built in overflow checks.
581 
582 /**
583  * @dev Wrappers over Solidity's arithmetic operations.
584  *
585  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
586  * now has built in overflow checking.
587  */
588 library SafeMath {
589     /**
590      * @dev Returns the addition of two unsigned integers, with an overflow flag.
591      *
592      * _Available since v3.4._
593      */
594     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
595         unchecked {
596             uint256 c = a + b;
597             if (c < a) return (false, 0);
598             return (true, c);
599         }
600     }
601 
602     /**
603      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
604      *
605      * _Available since v3.4._
606      */
607     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             if (b > a) return (false, 0);
610             return (true, a - b);
611         }
612     }
613 
614     /**
615      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
622             // benefit is lost if 'b' is also tested.
623             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
624             if (a == 0) return (true, 0);
625             uint256 c = a * b;
626             if (c / a != b) return (false, 0);
627             return (true, c);
628         }
629     }
630 
631     /**
632      * @dev Returns the division of two unsigned integers, with a division by zero flag.
633      *
634      * _Available since v3.4._
635      */
636     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b == 0) return (false, 0);
639             return (true, a / b);
640         }
641     }
642 
643     /**
644      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
645      *
646      * _Available since v3.4._
647      */
648     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             if (b == 0) return (false, 0);
651             return (true, a % b);
652         }
653     }
654 
655     /**
656      * @dev Returns the addition of two unsigned integers, reverting on
657      * overflow.
658      *
659      * Counterpart to Solidity's `+` operator.
660      *
661      * Requirements:
662      *
663      * - Addition cannot overflow.
664      */
665     function add(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a + b;
667     }
668 
669     /**
670      * @dev Returns the subtraction of two unsigned integers, reverting on
671      * overflow (when the result is negative).
672      *
673      * Counterpart to Solidity's `-` operator.
674      *
675      * Requirements:
676      *
677      * - Subtraction cannot overflow.
678      */
679     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a - b;
681     }
682 
683     /**
684      * @dev Returns the multiplication of two unsigned integers, reverting on
685      * overflow.
686      *
687      * Counterpart to Solidity's `*` operator.
688      *
689      * Requirements:
690      *
691      * - Multiplication cannot overflow.
692      */
693     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a * b;
695     }
696 
697     /**
698      * @dev Returns the integer division of two unsigned integers, reverting on
699      * division by zero. The result is rounded towards zero.
700      *
701      * Counterpart to Solidity's `/` operator.
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function div(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a / b;
709     }
710 
711     /**
712      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
713      * reverting when dividing by zero.
714      *
715      * Counterpart to Solidity's `%` operator. This function uses a `revert`
716      * opcode (which leaves remaining gas untouched) while Solidity uses an
717      * invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
724         return a % b;
725     }
726 
727     /**
728      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
729      * overflow (when the result is negative).
730      *
731      * CAUTION: This function is deprecated because it requires allocating memory for the error
732      * message unnecessarily. For custom revert reasons use {trySub}.
733      *
734      * Counterpart to Solidity's `-` operator.
735      *
736      * Requirements:
737      *
738      * - Subtraction cannot overflow.
739      */
740     function sub(
741         uint256 a,
742         uint256 b,
743         string memory errorMessage
744     ) internal pure returns (uint256) {
745         unchecked {
746             require(b <= a, errorMessage);
747             return a - b;
748         }
749     }
750 
751     /**
752      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
753      * division by zero. The result is rounded towards zero.
754      *
755      * Counterpart to Solidity's `/` operator. Note: this function uses a
756      * `revert` opcode (which leaves remaining gas untouched) while Solidity
757      * uses an invalid opcode to revert (consuming all remaining gas).
758      *
759      * Requirements:
760      *
761      * - The divisor cannot be zero.
762      */
763     function div(
764         uint256 a,
765         uint256 b,
766         string memory errorMessage
767     ) internal pure returns (uint256) {
768         unchecked {
769             require(b > 0, errorMessage);
770             return a / b;
771         }
772     }
773 
774     /**
775      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
776      * reverting with custom message when dividing by zero.
777      *
778      * CAUTION: This function is deprecated because it requires allocating memory for the error
779      * message unnecessarily. For custom revert reasons use {tryMod}.
780      *
781      * Counterpart to Solidity's `%` operator. This function uses a `revert`
782      * opcode (which leaves remaining gas untouched) while Solidity uses an
783      * invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function mod(
790         uint256 a,
791         uint256 b,
792         string memory errorMessage
793     ) internal pure returns (uint256) {
794         unchecked {
795             require(b > 0, errorMessage);
796             return a % b;
797         }
798     }
799 }
800 
801 // File: @openzeppelin/contracts/utils/Context.sol
802 
803 
804 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
805 
806 pragma solidity ^0.8.0;
807 
808 /**
809  * @dev Provides information about the current execution context, including the
810  * sender of the transaction and its data. While these are generally available
811  * via msg.sender and msg.data, they should not be accessed in such a direct
812  * manner, since when dealing with meta-transactions the account sending and
813  * paying for execution may not be the actual sender (as far as an application
814  * is concerned).
815  *
816  * This contract is only required for intermediate, library-like contracts.
817  */
818 abstract contract Context {
819     function _msgSender() internal view virtual returns (address) {
820         return msg.sender;
821     }
822 
823     function _msgData() internal view virtual returns (bytes calldata) {
824         return msg.data;
825     }
826 }
827 
828 // File: @openzeppelin/contracts/access/AccessControl.sol
829 
830 
831 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 
836 
837 
838 
839 /**
840  * @dev Contract module that allows children to implement role-based access
841  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
842  * members except through off-chain means by accessing the contract event logs. Some
843  * applications may benefit from on-chain enumerability, for those cases see
844  * {AccessControlEnumerable}.
845  *
846  * Roles are referred to by their `bytes32` identifier. These should be exposed
847  * in the external API and be unique. The best way to achieve this is by
848  * using `public constant` hash digests:
849  *
850  * ```
851  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
852  * ```
853  *
854  * Roles can be used to represent a set of permissions. To restrict access to a
855  * function call, use {hasRole}:
856  *
857  * ```
858  * function foo() public {
859  *     require(hasRole(MY_ROLE, msg.sender));
860  *     ...
861  * }
862  * ```
863  *
864  * Roles can be granted and revoked dynamically via the {grantRole} and
865  * {revokeRole} functions. Each role has an associated admin role, and only
866  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
867  *
868  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
869  * that only accounts with this role will be able to grant or revoke other
870  * roles. More complex role relationships can be created by using
871  * {_setRoleAdmin}.
872  *
873  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
874  * grant and revoke this role. Extra precautions should be taken to secure
875  * accounts that have been granted it.
876  */
877 abstract contract AccessControl is Context, IAccessControl, ERC165 {
878     struct RoleData {
879         mapping(address => bool) members;
880         bytes32 adminRole;
881     }
882 
883     mapping(bytes32 => RoleData) private _roles;
884 
885     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
886 
887     /**
888      * @dev Modifier that checks that an account has a specific role. Reverts
889      * with a standardized message including the required role.
890      *
891      * The format of the revert reason is given by the following regular expression:
892      *
893      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
894      *
895      * _Available since v4.1._
896      */
897     modifier onlyRole(bytes32 role) {
898         _checkRole(role);
899         _;
900     }
901 
902     /**
903      * @dev See {IERC165-supportsInterface}.
904      */
905     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
906         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
907     }
908 
909     /**
910      * @dev Returns `true` if `account` has been granted `role`.
911      */
912     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
913         return _roles[role].members[account];
914     }
915 
916     /**
917      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
918      * Overriding this function changes the behavior of the {onlyRole} modifier.
919      *
920      * Format of the revert message is described in {_checkRole}.
921      *
922      * _Available since v4.6._
923      */
924     function _checkRole(bytes32 role) internal view virtual {
925         _checkRole(role, _msgSender());
926     }
927 
928     /**
929      * @dev Revert with a standard message if `account` is missing `role`.
930      *
931      * The format of the revert reason is given by the following regular expression:
932      *
933      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
934      */
935     function _checkRole(bytes32 role, address account) internal view virtual {
936         if (!hasRole(role, account)) {
937             revert(
938                 string(
939                     abi.encodePacked(
940                         "AccessControl: account ",
941                         Strings.toHexString(account),
942                         " is missing role ",
943                         Strings.toHexString(uint256(role), 32)
944                     )
945                 )
946             );
947         }
948     }
949 
950     /**
951      * @dev Returns the admin role that controls `role`. See {grantRole} and
952      * {revokeRole}.
953      *
954      * To change a role's admin, use {_setRoleAdmin}.
955      */
956     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
957         return _roles[role].adminRole;
958     }
959 
960     /**
961      * @dev Grants `role` to `account`.
962      *
963      * If `account` had not been already granted `role`, emits a {RoleGranted}
964      * event.
965      *
966      * Requirements:
967      *
968      * - the caller must have ``role``'s admin role.
969      *
970      * May emit a {RoleGranted} event.
971      */
972     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
973         _grantRole(role, account);
974     }
975 
976     /**
977      * @dev Revokes `role` from `account`.
978      *
979      * If `account` had been granted `role`, emits a {RoleRevoked} event.
980      *
981      * Requirements:
982      *
983      * - the caller must have ``role``'s admin role.
984      *
985      * May emit a {RoleRevoked} event.
986      */
987     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
988         _revokeRole(role, account);
989     }
990 
991     /**
992      * @dev Revokes `role` from the calling account.
993      *
994      * Roles are often managed via {grantRole} and {revokeRole}: this function's
995      * purpose is to provide a mechanism for accounts to lose their privileges
996      * if they are compromised (such as when a trusted device is misplaced).
997      *
998      * If the calling account had been revoked `role`, emits a {RoleRevoked}
999      * event.
1000      *
1001      * Requirements:
1002      *
1003      * - the caller must be `account`.
1004      *
1005      * May emit a {RoleRevoked} event.
1006      */
1007     function renounceRole(bytes32 role, address account) public virtual override {
1008         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1009 
1010         _revokeRole(role, account);
1011     }
1012 
1013     /**
1014      * @dev Grants `role` to `account`.
1015      *
1016      * If `account` had not been already granted `role`, emits a {RoleGranted}
1017      * event. Note that unlike {grantRole}, this function doesn't perform any
1018      * checks on the calling account.
1019      *
1020      * May emit a {RoleGranted} event.
1021      *
1022      * [WARNING]
1023      * ====
1024      * This function should only be called from the constructor when setting
1025      * up the initial roles for the system.
1026      *
1027      * Using this function in any other way is effectively circumventing the admin
1028      * system imposed by {AccessControl}.
1029      * ====
1030      *
1031      * NOTE: This function is deprecated in favor of {_grantRole}.
1032      */
1033     function _setupRole(bytes32 role, address account) internal virtual {
1034         _grantRole(role, account);
1035     }
1036 
1037     /**
1038      * @dev Sets `adminRole` as ``role``'s admin role.
1039      *
1040      * Emits a {RoleAdminChanged} event.
1041      */
1042     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1043         bytes32 previousAdminRole = getRoleAdmin(role);
1044         _roles[role].adminRole = adminRole;
1045         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1046     }
1047 
1048     /**
1049      * @dev Grants `role` to `account`.
1050      *
1051      * Internal function without access restriction.
1052      *
1053      * May emit a {RoleGranted} event.
1054      */
1055     function _grantRole(bytes32 role, address account) internal virtual {
1056         if (!hasRole(role, account)) {
1057             _roles[role].members[account] = true;
1058             emit RoleGranted(role, account, _msgSender());
1059         }
1060     }
1061 
1062     /**
1063      * @dev Revokes `role` from `account`.
1064      *
1065      * Internal function without access restriction.
1066      *
1067      * May emit a {RoleRevoked} event.
1068      */
1069     function _revokeRole(bytes32 role, address account) internal virtual {
1070         if (hasRole(role, account)) {
1071             _roles[role].members[account] = false;
1072             emit RoleRevoked(role, account, _msgSender());
1073         }
1074     }
1075 }
1076 
1077 // File: @openzeppelin/contracts/access/Ownable.sol
1078 
1079 
1080 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1081 
1082 pragma solidity ^0.8.0;
1083 
1084 
1085 /**
1086  * @dev Contract module which provides a basic access control mechanism, where
1087  * there is an account (an owner) that can be granted exclusive access to
1088  * specific functions.
1089  *
1090  * By default, the owner account will be the one that deploys the contract. This
1091  * can later be changed with {transferOwnership}.
1092  *
1093  * This module is used through inheritance. It will make available the modifier
1094  * `onlyOwner`, which can be applied to your functions to restrict their use to
1095  * the owner.
1096  */
1097 abstract contract Ownable is Context {
1098     address private _owner;
1099 
1100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1101 
1102     /**
1103      * @dev Initializes the contract setting the deployer as the initial owner.
1104      */
1105     constructor() {
1106         _transferOwnership(_msgSender());
1107     }
1108 
1109     /**
1110      * @dev Throws if called by any account other than the owner.
1111      */
1112     modifier onlyOwner() {
1113         _checkOwner();
1114         _;
1115     }
1116 
1117     /**
1118      * @dev Returns the address of the current owner.
1119      */
1120     function owner() public view virtual returns (address) {
1121         return _owner;
1122     }
1123 
1124     /**
1125      * @dev Throws if the sender is not the owner.
1126      */
1127     function _checkOwner() internal view virtual {
1128         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1129     }
1130 
1131     /**
1132      * @dev Leaves the contract without owner. It will not be possible to call
1133      * `onlyOwner` functions anymore. Can only be called by the current owner.
1134      *
1135      * NOTE: Renouncing ownership will leave the contract without an owner,
1136      * thereby removing any functionality that is only available to the owner.
1137      */
1138     function renounceOwnership() public virtual onlyOwner {
1139         _transferOwnership(address(0));
1140     }
1141 
1142     /**
1143      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1144      * Can only be called by the current owner.
1145      */
1146     function transferOwnership(address newOwner) public virtual onlyOwner {
1147         require(newOwner != address(0), "Ownable: new owner is the zero address");
1148         _transferOwnership(newOwner);
1149     }
1150 
1151     /**
1152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1153      * Internal function without access restriction.
1154      */
1155     function _transferOwnership(address newOwner) internal virtual {
1156         address oldOwner = _owner;
1157         _owner = newOwner;
1158         emit OwnershipTransferred(oldOwner, newOwner);
1159     }
1160 }
1161 
1162 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1163 
1164 
1165 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 /**
1170  * @dev Interface of the ERC20 standard as defined in the EIP.
1171  */
1172 interface IERC20 {
1173     /**
1174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1175      * another (`to`).
1176      *
1177      * Note that `value` may be zero.
1178      */
1179     event Transfer(address indexed from, address indexed to, uint256 value);
1180 
1181     /**
1182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1183      * a call to {approve}. `value` is the new allowance.
1184      */
1185     event Approval(address indexed owner, address indexed spender, uint256 value);
1186 
1187     /**
1188      * @dev Returns the amount of tokens in existence.
1189      */
1190     function totalSupply() external view returns (uint256);
1191 
1192     /**
1193      * @dev Returns the amount of tokens owned by `account`.
1194      */
1195     function balanceOf(address account) external view returns (uint256);
1196 
1197     /**
1198      * @dev Moves `amount` tokens from the caller's account to `to`.
1199      *
1200      * Returns a boolean value indicating whether the operation succeeded.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function transfer(address to, uint256 amount) external returns (bool);
1205 
1206     /**
1207      * @dev Returns the remaining number of tokens that `spender` will be
1208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1209      * zero by default.
1210      *
1211      * This value changes when {approve} or {transferFrom} are called.
1212      */
1213     function allowance(address owner, address spender) external view returns (uint256);
1214 
1215     /**
1216      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1217      *
1218      * Returns a boolean value indicating whether the operation succeeded.
1219      *
1220      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1221      * that someone may use both the old and the new allowance by unfortunate
1222      * transaction ordering. One possible solution to mitigate this race
1223      * condition is to first reduce the spender's allowance to 0 and set the
1224      * desired value afterwards:
1225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1226      *
1227      * Emits an {Approval} event.
1228      */
1229     function approve(address spender, uint256 amount) external returns (bool);
1230 
1231     /**
1232      * @dev Moves `amount` tokens from `from` to `to` using the
1233      * allowance mechanism. `amount` is then deducted from the caller's
1234      * allowance.
1235      *
1236      * Returns a boolean value indicating whether the operation succeeded.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function transferFrom(
1241         address from,
1242         address to,
1243         uint256 amount
1244     ) external returns (bool);
1245 }
1246 
1247 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1248 
1249 
1250 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 
1255 /**
1256  * @dev Interface for the optional metadata functions from the ERC20 standard.
1257  *
1258  * _Available since v4.1._
1259  */
1260 interface IERC20Metadata is IERC20 {
1261     /**
1262      * @dev Returns the name of the token.
1263      */
1264     function name() external view returns (string memory);
1265 
1266     /**
1267      * @dev Returns the symbol of the token.
1268      */
1269     function symbol() external view returns (string memory);
1270 
1271     /**
1272      * @dev Returns the decimals places of the token.
1273      */
1274     function decimals() external view returns (uint8);
1275 }
1276 
1277 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1278 
1279 
1280 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 
1285 
1286 
1287 /**
1288  * @dev Implementation of the {IERC20} interface.
1289  *
1290  * This implementation is agnostic to the way tokens are created. This means
1291  * that a supply mechanism has to be added in a derived contract using {_mint}.
1292  * For a generic mechanism see {ERC20PresetMinterPauser}.
1293  *
1294  * TIP: For a detailed writeup see our guide
1295  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1296  * to implement supply mechanisms].
1297  *
1298  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1299  * instead returning `false` on failure. This behavior is nonetheless
1300  * conventional and does not conflict with the expectations of ERC20
1301  * applications.
1302  *
1303  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1304  * This allows applications to reconstruct the allowance for all accounts just
1305  * by listening to said events. Other implementations of the EIP may not emit
1306  * these events, as it isn't required by the specification.
1307  *
1308  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1309  * functions have been added to mitigate the well-known issues around setting
1310  * allowances. See {IERC20-approve}.
1311  */
1312 contract ERC20 is Context, IERC20, IERC20Metadata {
1313     mapping(address => uint256) private _balances;
1314 
1315     mapping(address => mapping(address => uint256)) private _allowances;
1316 
1317     uint256 private _totalSupply;
1318 
1319     string private _name;
1320     string private _symbol;
1321 
1322     /**
1323      * @dev Sets the values for {name} and {symbol}.
1324      *
1325      * The default value of {decimals} is 18. To select a different value for
1326      * {decimals} you should overload it.
1327      *
1328      * All two of these values are immutable: they can only be set once during
1329      * construction.
1330      */
1331     constructor(string memory name_, string memory symbol_) {
1332         _name = name_;
1333         _symbol = symbol_;
1334     }
1335 
1336     /**
1337      * @dev Returns the name of the token.
1338      */
1339     function name() public view virtual override returns (string memory) {
1340         return _name;
1341     }
1342 
1343     /**
1344      * @dev Returns the symbol of the token, usually a shorter version of the
1345      * name.
1346      */
1347     function symbol() public view virtual override returns (string memory) {
1348         return _symbol;
1349     }
1350 
1351     /**
1352      * @dev Returns the number of decimals used to get its user representation.
1353      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1354      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1355      *
1356      * Tokens usually opt for a value of 18, imitating the relationship between
1357      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1358      * overridden;
1359      *
1360      * NOTE: This information is only used for _display_ purposes: it in
1361      * no way affects any of the arithmetic of the contract, including
1362      * {IERC20-balanceOf} and {IERC20-transfer}.
1363      */
1364     function decimals() public view virtual override returns (uint8) {
1365         return 18;
1366     }
1367 
1368     /**
1369      * @dev See {IERC20-totalSupply}.
1370      */
1371     function totalSupply() public view virtual override returns (uint256) {
1372         return _totalSupply;
1373     }
1374 
1375     /**
1376      * @dev See {IERC20-balanceOf}.
1377      */
1378     function balanceOf(address account) public view virtual override returns (uint256) {
1379         return _balances[account];
1380     }
1381 
1382     /**
1383      * @dev See {IERC20-transfer}.
1384      *
1385      * Requirements:
1386      *
1387      * - `to` cannot be the zero address.
1388      * - the caller must have a balance of at least `amount`.
1389      */
1390     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1391         address owner = _msgSender();
1392         _transfer(owner, to, amount);
1393         return true;
1394     }
1395 
1396     /**
1397      * @dev See {IERC20-allowance}.
1398      */
1399     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1400         return _allowances[owner][spender];
1401     }
1402 
1403     /**
1404      * @dev See {IERC20-approve}.
1405      *
1406      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1407      * `transferFrom`. This is semantically equivalent to an infinite approval.
1408      *
1409      * Requirements:
1410      *
1411      * - `spender` cannot be the zero address.
1412      */
1413     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1414         address owner = _msgSender();
1415         _approve(owner, spender, amount);
1416         return true;
1417     }
1418 
1419     /**
1420      * @dev See {IERC20-transferFrom}.
1421      *
1422      * Emits an {Approval} event indicating the updated allowance. This is not
1423      * required by the EIP. See the note at the beginning of {ERC20}.
1424      *
1425      * NOTE: Does not update the allowance if the current allowance
1426      * is the maximum `uint256`.
1427      *
1428      * Requirements:
1429      *
1430      * - `from` and `to` cannot be the zero address.
1431      * - `from` must have a balance of at least `amount`.
1432      * - the caller must have allowance for ``from``'s tokens of at least
1433      * `amount`.
1434      */
1435     function transferFrom(
1436         address from,
1437         address to,
1438         uint256 amount
1439     ) public virtual override returns (bool) {
1440         address spender = _msgSender();
1441         _spendAllowance(from, spender, amount);
1442         _transfer(from, to, amount);
1443         return true;
1444     }
1445 
1446     /**
1447      * @dev Atomically increases the allowance granted to `spender` by the caller.
1448      *
1449      * This is an alternative to {approve} that can be used as a mitigation for
1450      * problems described in {IERC20-approve}.
1451      *
1452      * Emits an {Approval} event indicating the updated allowance.
1453      *
1454      * Requirements:
1455      *
1456      * - `spender` cannot be the zero address.
1457      */
1458     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1459         address owner = _msgSender();
1460         _approve(owner, spender, allowance(owner, spender) + addedValue);
1461         return true;
1462     }
1463 
1464     /**
1465      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1466      *
1467      * This is an alternative to {approve} that can be used as a mitigation for
1468      * problems described in {IERC20-approve}.
1469      *
1470      * Emits an {Approval} event indicating the updated allowance.
1471      *
1472      * Requirements:
1473      *
1474      * - `spender` cannot be the zero address.
1475      * - `spender` must have allowance for the caller of at least
1476      * `subtractedValue`.
1477      */
1478     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1479         address owner = _msgSender();
1480         uint256 currentAllowance = allowance(owner, spender);
1481         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1482         unchecked {
1483             _approve(owner, spender, currentAllowance - subtractedValue);
1484         }
1485 
1486         return true;
1487     }
1488 
1489     /**
1490      * @dev Moves `amount` of tokens from `from` to `to`.
1491      *
1492      * This internal function is equivalent to {transfer}, and can be used to
1493      * e.g. implement automatic token fees, slashing mechanisms, etc.
1494      *
1495      * Emits a {Transfer} event.
1496      *
1497      * Requirements:
1498      *
1499      * - `from` cannot be the zero address.
1500      * - `to` cannot be the zero address.
1501      * - `from` must have a balance of at least `amount`.
1502      */
1503     function _transfer(
1504         address from,
1505         address to,
1506         uint256 amount
1507     ) internal virtual {
1508         require(from != address(0), "ERC20: transfer from the zero address");
1509         require(to != address(0), "ERC20: transfer to the zero address");
1510 
1511         _beforeTokenTransfer(from, to, amount);
1512 
1513         uint256 fromBalance = _balances[from];
1514         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1515         unchecked {
1516             _balances[from] = fromBalance - amount;
1517             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1518             // decrementing then incrementing.
1519             _balances[to] += amount;
1520         }
1521 
1522         emit Transfer(from, to, amount);
1523 
1524         _afterTokenTransfer(from, to, amount);
1525     }
1526 
1527     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1528      * the total supply.
1529      *
1530      * Emits a {Transfer} event with `from` set to the zero address.
1531      *
1532      * Requirements:
1533      *
1534      * - `account` cannot be the zero address.
1535      */
1536     function _mint(address account, uint256 amount) internal virtual {
1537         require(account != address(0), "ERC20: mint to the zero address");
1538 
1539         _beforeTokenTransfer(address(0), account, amount);
1540 
1541         _totalSupply += amount;
1542         unchecked {
1543             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1544             _balances[account] += amount;
1545         }
1546         emit Transfer(address(0), account, amount);
1547 
1548         _afterTokenTransfer(address(0), account, amount);
1549     }
1550 
1551     /**
1552      * @dev Destroys `amount` tokens from `account`, reducing the
1553      * total supply.
1554      *
1555      * Emits a {Transfer} event with `to` set to the zero address.
1556      *
1557      * Requirements:
1558      *
1559      * - `account` cannot be the zero address.
1560      * - `account` must have at least `amount` tokens.
1561      */
1562     function _burn(address account, uint256 amount) internal virtual {
1563         require(account != address(0), "ERC20: burn from the zero address");
1564 
1565         _beforeTokenTransfer(account, address(0), amount);
1566 
1567         uint256 accountBalance = _balances[account];
1568         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1569         unchecked {
1570             _balances[account] = accountBalance - amount;
1571             // Overflow not possible: amount <= accountBalance <= totalSupply.
1572             _totalSupply -= amount;
1573         }
1574 
1575         emit Transfer(account, address(0), amount);
1576 
1577         _afterTokenTransfer(account, address(0), amount);
1578     }
1579 
1580     /**
1581      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1582      *
1583      * This internal function is equivalent to `approve`, and can be used to
1584      * e.g. set automatic allowances for certain subsystems, etc.
1585      *
1586      * Emits an {Approval} event.
1587      *
1588      * Requirements:
1589      *
1590      * - `owner` cannot be the zero address.
1591      * - `spender` cannot be the zero address.
1592      */
1593     function _approve(
1594         address owner,
1595         address spender,
1596         uint256 amount
1597     ) internal virtual {
1598         require(owner != address(0), "ERC20: approve from the zero address");
1599         require(spender != address(0), "ERC20: approve to the zero address");
1600 
1601         _allowances[owner][spender] = amount;
1602         emit Approval(owner, spender, amount);
1603     }
1604 
1605     /**
1606      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1607      *
1608      * Does not update the allowance amount in case of infinite allowance.
1609      * Revert if not enough allowance is available.
1610      *
1611      * Might emit an {Approval} event.
1612      */
1613     function _spendAllowance(
1614         address owner,
1615         address spender,
1616         uint256 amount
1617     ) internal virtual {
1618         uint256 currentAllowance = allowance(owner, spender);
1619         if (currentAllowance != type(uint256).max) {
1620             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1621             unchecked {
1622                 _approve(owner, spender, currentAllowance - amount);
1623             }
1624         }
1625     }
1626 
1627     /**
1628      * @dev Hook that is called before any transfer of tokens. This includes
1629      * minting and burning.
1630      *
1631      * Calling conditions:
1632      *
1633      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1634      * will be transferred to `to`.
1635      * - when `from` is zero, `amount` tokens will be minted for `to`.
1636      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1637      * - `from` and `to` are never both zero.
1638      *
1639      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1640      */
1641     function _beforeTokenTransfer(
1642         address from,
1643         address to,
1644         uint256 amount
1645     ) internal virtual {}
1646 
1647     /**
1648      * @dev Hook that is called after any transfer of tokens. This includes
1649      * minting and burning.
1650      *
1651      * Calling conditions:
1652      *
1653      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1654      * has been transferred to `to`.
1655      * - when `from` is zero, `amount` tokens have been minted for `to`.
1656      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1657      * - `from` and `to` are never both zero.
1658      *
1659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1660      */
1661     function _afterTokenTransfer(
1662         address from,
1663         address to,
1664         uint256 amount
1665     ) internal virtual {}
1666 }
1667 
1668 // File: TOKEN\Matcheth.sol
1669 
1670 
1671 
1672 pragma solidity ^0.8.0;
1673 
1674 
1675 
1676 
1677 
1678 contract Matcheth is ERC20,Ownable,AccessControl{
1679     
1680     using SafeMath for uint256;
1681     //ido开关
1682     bool public idoSwitch1=true;
1683 
1684     bool public idoSwitch2=false;
1685     //提币开关
1686     bool public withdaw1=false;
1687 
1688     bool public withdaw2=false;
1689 
1690     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1691 
1692     mapping(address => bool) private whiteList;
1693 
1694     mapping(address=>uint256) public idoToBuy1;
1695 
1696     uint256 public idoBuyTotal1;
1697 
1698     mapping (address=>uint256) public idoAlreadyGet1;
1699 
1700     mapping(address=>uint256) public idoToBuy2;
1701 
1702     uint256 public idoBuyTotal2;
1703 
1704     mapping (address=>uint256) public idoAlreadyGet2;
1705 
1706     uint256 idoCount1=60000000000 * 10 ** decimals();
1707     
1708     uint256 idoCount2=360000000000 * 10 ** decimals();
1709 
1710     uint256 public minBuy=1*10**16;
1711 
1712     uint256 public maxBuy=1*10**18;
1713 
1714     mapping (address=>uint256) public alreadyBack;
1715     
1716     address holdAddress;
1717 
1718     constructor() ERC20("MATCHETH", "MATCH") {
1719         address admin=0x75d9E48653D372a4c5BEa74a7D7FDF50c1A1f322;
1720         holdAddress=admin;
1721         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1722         _grantRole(MANAGER_ROLE, admin);
1723         _mint(admin, 600000000000 * 10 ** decimals());
1724         whiteList[admin]=true;
1725         //transferOwnership(admin);
1726     }
1727     
1728     function getWhitelist(address account) public view returns(bool) {
1729         return whiteList[account];
1730     }
1731     
1732     function setWhiteList(address[] calldata _addresses,bool _b)external onlyRole(MANAGER_ROLE){
1733         for(uint256 i=0;i<_addresses.length;i++){
1734             if(_addresses[i]!=address(0)){
1735                 whiteList[_addresses[i]]=_b;
1736             }
1737         }
1738     }
1739 
1740     function withdawOwner(uint256 amount) external onlyRole(MANAGER_ROLE){
1741         payable(msg.sender).transfer(amount);
1742     }
1743     
1744     function errorToken(address _token) external onlyRole(MANAGER_ROLE){
1745         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1746     }
1747     
1748     function setSwitch(bool _ido1,bool _ido2) external onlyRole(MANAGER_ROLE){
1749         idoSwitch1=_ido1;
1750         idoSwitch2=_ido2;
1751     }
1752     
1753     function setWithdaw(bool _withdaw1,bool _withdaw2) external onlyRole(MANAGER_ROLE){
1754         withdaw1=_withdaw1;
1755         withdaw2=_withdaw2;
1756     }
1757     
1758     function setMinMaxBuy(uint256 _minBuy,uint256 _maxBuy) external onlyRole(MANAGER_ROLE){
1759         minBuy=_minBuy;
1760         maxBuy=_maxBuy;
1761     }
1762 
1763     function ido1()payable external{
1764         require(whiteList[msg.sender], "not in white list");
1765         require(idoSwitch1, "not open");
1766         require(!isContract(msg.sender),"address not Alow");
1767         uint256 amountTobuy = msg.value;
1768         require(idoToBuy1[msg.sender]+amountTobuy<=maxBuy,"max ido");
1769         require(amountTobuy >= minBuy, "You need to send some Ether");
1770         idoToBuy1[msg.sender]+=amountTobuy;
1771         idoBuyTotal1+=amountTobuy;
1772         //payable(holdAddress).transfer(amountTobuy);
1773     }
1774 
1775     //获取可领取的数量
1776     function withdrawIdoCount1()public view returns(uint256){
1777         uint256 result=idoToBuy1[msg.sender]*idoCount1/idoBuyTotal1;
1778         if(result>idoAlreadyGet1[msg.sender]){
1779             return result-idoAlreadyGet1[msg.sender];
1780         }
1781         return 0;
1782     }
1783     //提取ido后的代币
1784     function withdrawIdo1()public{
1785         require(withdaw1, "not open");
1786         require(!idoSwitch1, "ido not close");
1787         uint256 toGet=withdrawIdoCount1();
1788         require(toGet>0, "not alow");
1789         ERC20(this).transfer(msg.sender,toGet);
1790         idoAlreadyGet1[msg.sender]+=toGet;
1791     }
1792     //计算能返回的eth
1793     function claimEthBalance()public view returns(uint256){
1794         if(!withdaw1){
1795             return 0;
1796         }else if(idoSwitch1){
1797             return 0;
1798         }
1799         if(idoBuyTotal1<=15*maxBuy){
1800             return 0;
1801         }else{
1802             uint256 backCount=idoToBuy1[msg.sender]*(idoBuyTotal1-maxBuy*15)/idoBuyTotal1;
1803             if(alreadyBack[msg.sender]>backCount){
1804                 return 0;
1805             }else{
1806                 return backCount-alreadyBack[msg.sender];
1807             }
1808         }
1809     }
1810     
1811     function claimEth()public{
1812         require(withdaw1, "not open");
1813         require(!idoSwitch1, "ido not close");
1814         uint256 toGet=claimEthBalance();
1815         require(toGet>0, "not alow");
1816         payable(msg.sender).transfer(toGet);
1817         alreadyBack[msg.sender]+=toGet;
1818     }
1819 
1820     function ido2()payable external{
1821         require(idoSwitch2, "not open");
1822         require(!isContract(msg.sender),"not Alow");
1823         //require(idoToBuy2[msg.sender]==0,"already join");
1824         uint256 amountTobuy = msg.value;
1825         require(amountTobuy >= minBuy, "You need to send some Ether");
1826         idoToBuy2[msg.sender]+=amountTobuy;
1827         idoBuyTotal2+=amountTobuy;
1828         payable(holdAddress).transfer(amountTobuy);
1829     }
1830 
1831     //获取可领取的数量
1832     function withdrawIdoCount2()public view returns(uint256){
1833         uint256 result=idoToBuy2[msg.sender]*idoCount2/idoBuyTotal2;
1834         if(result>idoAlreadyGet2[msg.sender]){
1835             return result-idoAlreadyGet2[msg.sender];
1836         }
1837         return 0;
1838     }
1839     //提取ido后的代币
1840     function withdrawIdo2()public{
1841         require(withdaw2, "not open");
1842         require(!idoSwitch2, "ido not close");
1843         uint256 toGet=withdrawIdoCount2();
1844         require(toGet>0, "not alow");
1845         ERC20(this).transfer(msg.sender,toGet);
1846         idoAlreadyGet2[msg.sender]+=toGet;
1847     }
1848    
1849     receive() external payable {}
1850     function isContract(address account) internal view returns (bool) {
1851         uint256 size;
1852         assembly {
1853             size := extcodesize(account)
1854         }
1855         return size > 0;
1856     }
1857     
1858     function decimals() public view virtual override returns (uint8) {
1859         return 18;
1860     }
1861     
1862 }