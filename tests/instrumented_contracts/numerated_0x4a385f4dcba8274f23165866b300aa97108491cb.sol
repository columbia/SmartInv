1 // Sources flattened with hardhat v2.12.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.9.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
30 
31 // File @openzeppelin/contracts/utils/math/Math.sol@v4.9.2
32 
33 // 
34 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Standard math utilities missing in the Solidity language.
40  */
41 library Math {
42     enum Rounding {
43         Down, // Toward negative infinity
44         Up, // Toward infinity
45         Zero // Toward zero
46     }
47 
48     /**
49      * @dev Returns the largest of two numbers.
50      */
51     function max(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a > b ? a : b;
53     }
54 
55     /**
56      * @dev Returns the smallest of two numbers.
57      */
58     function min(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a < b ? a : b;
60     }
61 
62     /**
63      * @dev Returns the average of two numbers. The result is rounded towards
64      * zero.
65      */
66     function average(uint256 a, uint256 b) internal pure returns (uint256) {
67         // (a + b) / 2 can overflow.
68         return (a & b) + (a ^ b) / 2;
69     }
70 
71     /**
72      * @dev Returns the ceiling of the division of two numbers.
73      *
74      * This differs from standard division with `/` in that it rounds up instead
75      * of rounding down.
76      */
77     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
78         // (a + b - 1) / b can overflow on addition, so we distribute.
79         return a == 0 ? 0 : (a - 1) / b + 1;
80     }
81 
82     /**
83      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
84      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
85      * with further edits by Uniswap Labs also under MIT license.
86      */
87     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
88         unchecked {
89             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
90             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
91             // variables such that product = prod1 * 2^256 + prod0.
92             uint256 prod0; // Least significant 256 bits of the product
93             uint256 prod1; // Most significant 256 bits of the product
94             assembly {
95                 let mm := mulmod(x, y, not(0))
96                 prod0 := mul(x, y)
97                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
98             }
99 
100             // Handle non-overflow cases, 256 by 256 division.
101             if (prod1 == 0) {
102                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
103                 // The surrounding unchecked block does not change this fact.
104                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
105                 return prod0 / denominator;
106             }
107 
108             // Make sure the result is less than 2^256. Also prevents denominator == 0.
109             require(denominator > prod1, "Math: mulDiv overflow");
110 
111             ///////////////////////////////////////////////
112             // 512 by 256 division.
113             ///////////////////////////////////////////////
114 
115             // Make division exact by subtracting the remainder from [prod1 prod0].
116             uint256 remainder;
117             assembly {
118                 // Compute remainder using mulmod.
119                 remainder := mulmod(x, y, denominator)
120 
121                 // Subtract 256 bit number from 512 bit number.
122                 prod1 := sub(prod1, gt(remainder, prod0))
123                 prod0 := sub(prod0, remainder)
124             }
125 
126             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
127             // See https://cs.stackexchange.com/q/138556/92363.
128 
129             // Does not overflow because the denominator cannot be zero at this stage in the function.
130             uint256 twos = denominator & (~denominator + 1);
131             assembly {
132                 // Divide denominator by twos.
133                 denominator := div(denominator, twos)
134 
135                 // Divide [prod1 prod0] by twos.
136                 prod0 := div(prod0, twos)
137 
138                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
139                 twos := add(div(sub(0, twos), twos), 1)
140             }
141 
142             // Shift in bits from prod1 into prod0.
143             prod0 |= prod1 * twos;
144 
145             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
146             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
147             // four bits. That is, denominator * inv = 1 mod 2^4.
148             uint256 inverse = (3 * denominator) ^ 2;
149 
150             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
151             // in modular arithmetic, doubling the correct bits in each step.
152             inverse *= 2 - denominator * inverse; // inverse mod 2^8
153             inverse *= 2 - denominator * inverse; // inverse mod 2^16
154             inverse *= 2 - denominator * inverse; // inverse mod 2^32
155             inverse *= 2 - denominator * inverse; // inverse mod 2^64
156             inverse *= 2 - denominator * inverse; // inverse mod 2^128
157             inverse *= 2 - denominator * inverse; // inverse mod 2^256
158 
159             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
160             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
161             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
162             // is no longer required.
163             result = prod0 * inverse;
164             return result;
165         }
166     }
167 
168     /**
169      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
170      */
171     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
172         uint256 result = mulDiv(x, y, denominator);
173         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
174             result += 1;
175         }
176         return result;
177     }
178 
179     /**
180      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
181      *
182      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
183      */
184     function sqrt(uint256 a) internal pure returns (uint256) {
185         if (a == 0) {
186             return 0;
187         }
188 
189         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
190         //
191         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
192         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
193         //
194         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
195         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
196         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
197         //
198         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
199         uint256 result = 1 << (log2(a) >> 1);
200 
201         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
202         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
203         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
204         // into the expected uint128 result.
205         unchecked {
206             result = (result + a / result) >> 1;
207             result = (result + a / result) >> 1;
208             result = (result + a / result) >> 1;
209             result = (result + a / result) >> 1;
210             result = (result + a / result) >> 1;
211             result = (result + a / result) >> 1;
212             result = (result + a / result) >> 1;
213             return min(result, a / result);
214         }
215     }
216 
217     /**
218      * @notice Calculates sqrt(a), following the selected rounding direction.
219      */
220     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
221         unchecked {
222             uint256 result = sqrt(a);
223             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
224         }
225     }
226 
227     /**
228      * @dev Return the log in base 2, rounded down, of a positive value.
229      * Returns 0 if given 0.
230      */
231     function log2(uint256 value) internal pure returns (uint256) {
232         uint256 result = 0;
233         unchecked {
234             if (value >> 128 > 0) {
235                 value >>= 128;
236                 result += 128;
237             }
238             if (value >> 64 > 0) {
239                 value >>= 64;
240                 result += 64;
241             }
242             if (value >> 32 > 0) {
243                 value >>= 32;
244                 result += 32;
245             }
246             if (value >> 16 > 0) {
247                 value >>= 16;
248                 result += 16;
249             }
250             if (value >> 8 > 0) {
251                 value >>= 8;
252                 result += 8;
253             }
254             if (value >> 4 > 0) {
255                 value >>= 4;
256                 result += 4;
257             }
258             if (value >> 2 > 0) {
259                 value >>= 2;
260                 result += 2;
261             }
262             if (value >> 1 > 0) {
263                 result += 1;
264             }
265         }
266         return result;
267     }
268 
269     /**
270      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
271      * Returns 0 if given 0.
272      */
273     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
274         unchecked {
275             uint256 result = log2(value);
276             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
277         }
278     }
279 
280     /**
281      * @dev Return the log in base 10, rounded down, of a positive value.
282      * Returns 0 if given 0.
283      */
284     function log10(uint256 value) internal pure returns (uint256) {
285         uint256 result = 0;
286         unchecked {
287             if (value >= 10 ** 64) {
288                 value /= 10 ** 64;
289                 result += 64;
290             }
291             if (value >= 10 ** 32) {
292                 value /= 10 ** 32;
293                 result += 32;
294             }
295             if (value >= 10 ** 16) {
296                 value /= 10 ** 16;
297                 result += 16;
298             }
299             if (value >= 10 ** 8) {
300                 value /= 10 ** 8;
301                 result += 8;
302             }
303             if (value >= 10 ** 4) {
304                 value /= 10 ** 4;
305                 result += 4;
306             }
307             if (value >= 10 ** 2) {
308                 value /= 10 ** 2;
309                 result += 2;
310             }
311             if (value >= 10 ** 1) {
312                 result += 1;
313             }
314         }
315         return result;
316     }
317 
318     /**
319      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
320      * Returns 0 if given 0.
321      */
322     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
323         unchecked {
324             uint256 result = log10(value);
325             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
326         }
327     }
328 
329     /**
330      * @dev Return the log in base 256, rounded down, of a positive value.
331      * Returns 0 if given 0.
332      *
333      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
334      */
335     function log256(uint256 value) internal pure returns (uint256) {
336         uint256 result = 0;
337         unchecked {
338             if (value >> 128 > 0) {
339                 value >>= 128;
340                 result += 16;
341             }
342             if (value >> 64 > 0) {
343                 value >>= 64;
344                 result += 8;
345             }
346             if (value >> 32 > 0) {
347                 value >>= 32;
348                 result += 4;
349             }
350             if (value >> 16 > 0) {
351                 value >>= 16;
352                 result += 2;
353             }
354             if (value >> 8 > 0) {
355                 result += 1;
356             }
357         }
358         return result;
359     }
360 
361     /**
362      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
363      * Returns 0 if given 0.
364      */
365     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
366         unchecked {
367             uint256 result = log256(value);
368             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
369         }
370     }
371 }
372 
373 
374 // File @openzeppelin/contracts/utils/math/SignedMath.sol@v4.9.2
375 
376 // 
377 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev Standard signed math utilities missing in the Solidity language.
383  */
384 library SignedMath {
385     /**
386      * @dev Returns the largest of two signed numbers.
387      */
388     function max(int256 a, int256 b) internal pure returns (int256) {
389         return a > b ? a : b;
390     }
391 
392     /**
393      * @dev Returns the smallest of two signed numbers.
394      */
395     function min(int256 a, int256 b) internal pure returns (int256) {
396         return a < b ? a : b;
397     }
398 
399     /**
400      * @dev Returns the average of two signed numbers without overflow.
401      * The result is rounded towards zero.
402      */
403     function average(int256 a, int256 b) internal pure returns (int256) {
404         // Formula from the book "Hacker's Delight"
405         int256 x = (a & b) + ((a ^ b) >> 1);
406         return x + (int256(uint256(x) >> 255) & (a ^ b));
407     }
408 
409     /**
410      * @dev Returns the absolute unsigned value of a signed value.
411      */
412     function abs(int256 n) internal pure returns (uint256) {
413         unchecked {
414             // must be unchecked in order to support `n = type(int256).min`
415             return uint256(n >= 0 ? n : -n);
416         }
417     }
418 }
419 
420 
421 // File @openzeppelin/contracts/utils/Strings.sol@v4.9.2
422 
423 // 
424 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev String operations.
431  */
432 library Strings {
433     bytes16 private constant _SYMBOLS = "0123456789abcdef";
434     uint8 private constant _ADDRESS_LENGTH = 20;
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
438      */
439     function toString(uint256 value) internal pure returns (string memory) {
440         unchecked {
441             uint256 length = Math.log10(value) + 1;
442             string memory buffer = new string(length);
443             uint256 ptr;
444             /// @solidity memory-safe-assembly
445             assembly {
446                 ptr := add(buffer, add(32, length))
447             }
448             while (true) {
449                 ptr--;
450                 /// @solidity memory-safe-assembly
451                 assembly {
452                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
453                 }
454                 value /= 10;
455                 if (value == 0) break;
456             }
457             return buffer;
458         }
459     }
460 
461     /**
462      * @dev Converts a `int256` to its ASCII `string` decimal representation.
463      */
464     function toString(int256 value) internal pure returns (string memory) {
465         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
466     }
467 
468     /**
469      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
470      */
471     function toHexString(uint256 value) internal pure returns (string memory) {
472         unchecked {
473             return toHexString(value, Math.log256(value) + 1);
474         }
475     }
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
479      */
480     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
481         bytes memory buffer = new bytes(2 * length + 2);
482         buffer[0] = "0";
483         buffer[1] = "x";
484         for (uint256 i = 2 * length + 1; i > 1; --i) {
485             buffer[i] = _SYMBOLS[value & 0xf];
486             value >>= 4;
487         }
488         require(value == 0, "Strings: hex length insufficient");
489         return string(buffer);
490     }
491 
492     /**
493      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
494      */
495     function toHexString(address addr) internal pure returns (string memory) {
496         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
497     }
498 
499     /**
500      * @dev Returns true if the two strings are equal.
501      */
502     function equal(string memory a, string memory b) internal pure returns (bool) {
503         return keccak256(bytes(a)) == keccak256(bytes(b));
504     }
505 }
506 
507 
508 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.2
509 
510 // 
511 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Interface of the ERC165 standard, as defined in the
517  * https://eips.ethereum.org/EIPS/eip-165[EIP].
518  *
519  * Implementers can declare support of contract interfaces, which can then be
520  * queried by others ({ERC165Checker}).
521  *
522  * For an implementation, see {ERC165}.
523  */
524 interface IERC165 {
525     /**
526      * @dev Returns true if this contract implements the interface defined by
527      * `interfaceId`. See the corresponding
528      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
529      * to learn more about how these ids are created.
530      *
531      * This function call must use less than 30 000 gas.
532      */
533     function supportsInterface(bytes4 interfaceId) external view returns (bool);
534 }
535 
536 
537 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.2
538 
539 // 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Implementation of the {IERC165} interface.
546  *
547  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
548  * for the additional interface id that will be supported. For example:
549  *
550  * ```solidity
551  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
553  * }
554  * ```
555  *
556  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
557  */
558 abstract contract ERC165 is IERC165 {
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         return interfaceId == type(IERC165).interfaceId;
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.9.2
569 
570 // 
571 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev External interface of AccessControl declared to support ERC165 detection.
577  */
578 interface IAccessControl {
579     /**
580      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
581      *
582      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
583      * {RoleAdminChanged} not being emitted signaling this.
584      *
585      * _Available since v3.1._
586      */
587     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
588 
589     /**
590      * @dev Emitted when `account` is granted `role`.
591      *
592      * `sender` is the account that originated the contract call, an admin role
593      * bearer except when using {AccessControl-_setupRole}.
594      */
595     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
596 
597     /**
598      * @dev Emitted when `account` is revoked `role`.
599      *
600      * `sender` is the account that originated the contract call:
601      *   - if using `revokeRole`, it is the admin role bearer
602      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
603      */
604     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
605 
606     /**
607      * @dev Returns `true` if `account` has been granted `role`.
608      */
609     function hasRole(bytes32 role, address account) external view returns (bool);
610 
611     /**
612      * @dev Returns the admin role that controls `role`. See {grantRole} and
613      * {revokeRole}.
614      *
615      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
616      */
617     function getRoleAdmin(bytes32 role) external view returns (bytes32);
618 
619     /**
620      * @dev Grants `role` to `account`.
621      *
622      * If `account` had not been already granted `role`, emits a {RoleGranted}
623      * event.
624      *
625      * Requirements:
626      *
627      * - the caller must have ``role``'s admin role.
628      */
629     function grantRole(bytes32 role, address account) external;
630 
631     /**
632      * @dev Revokes `role` from `account`.
633      *
634      * If `account` had been granted `role`, emits a {RoleRevoked} event.
635      *
636      * Requirements:
637      *
638      * - the caller must have ``role``'s admin role.
639      */
640     function revokeRole(bytes32 role, address account) external;
641 
642     /**
643      * @dev Revokes `role` from the calling account.
644      *
645      * Roles are often managed via {grantRole} and {revokeRole}: this function's
646      * purpose is to provide a mechanism for accounts to lose their privileges
647      * if they are compromised (such as when a trusted device is misplaced).
648      *
649      * If the calling account had been granted `role`, emits a {RoleRevoked}
650      * event.
651      *
652      * Requirements:
653      *
654      * - the caller must be `account`.
655      */
656     function renounceRole(bytes32 role, address account) external;
657 }
658 
659 
660 // File @openzeppelin/contracts/access/AccessControl.sol@v4.9.2
661 
662 // 
663 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 
669 
670 /**
671  * @dev Contract module that allows children to implement role-based access
672  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
673  * members except through off-chain means by accessing the contract event logs. Some
674  * applications may benefit from on-chain enumerability, for those cases see
675  * {AccessControlEnumerable}.
676  *
677  * Roles are referred to by their `bytes32` identifier. These should be exposed
678  * in the external API and be unique. The best way to achieve this is by
679  * using `public constant` hash digests:
680  *
681  * ```solidity
682  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
683  * ```
684  *
685  * Roles can be used to represent a set of permissions. To restrict access to a
686  * function call, use {hasRole}:
687  *
688  * ```solidity
689  * function foo() public {
690  *     require(hasRole(MY_ROLE, msg.sender));
691  *     ...
692  * }
693  * ```
694  *
695  * Roles can be granted and revoked dynamically via the {grantRole} and
696  * {revokeRole} functions. Each role has an associated admin role, and only
697  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
698  *
699  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
700  * that only accounts with this role will be able to grant or revoke other
701  * roles. More complex role relationships can be created by using
702  * {_setRoleAdmin}.
703  *
704  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
705  * grant and revoke this role. Extra precautions should be taken to secure
706  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
707  * to enforce additional security measures for this role.
708  */
709 abstract contract AccessControl is Context, IAccessControl, ERC165 {
710     struct RoleData {
711         mapping(address => bool) members;
712         bytes32 adminRole;
713     }
714 
715     mapping(bytes32 => RoleData) private _roles;
716 
717     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
718 
719     /**
720      * @dev Modifier that checks that an account has a specific role. Reverts
721      * with a standardized message including the required role.
722      *
723      * The format of the revert reason is given by the following regular expression:
724      *
725      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
726      *
727      * _Available since v4.1._
728      */
729     modifier onlyRole(bytes32 role) {
730         _checkRole(role);
731         _;
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
739     }
740 
741     /**
742      * @dev Returns `true` if `account` has been granted `role`.
743      */
744     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
745         return _roles[role].members[account];
746     }
747 
748     /**
749      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
750      * Overriding this function changes the behavior of the {onlyRole} modifier.
751      *
752      * Format of the revert message is described in {_checkRole}.
753      *
754      * _Available since v4.6._
755      */
756     function _checkRole(bytes32 role) internal view virtual {
757         _checkRole(role, _msgSender());
758     }
759 
760     /**
761      * @dev Revert with a standard message if `account` is missing `role`.
762      *
763      * The format of the revert reason is given by the following regular expression:
764      *
765      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
766      */
767     function _checkRole(bytes32 role, address account) internal view virtual {
768         if (!hasRole(role, account)) {
769             revert(
770                 string(
771                     abi.encodePacked(
772                         "AccessControl: account ",
773                         Strings.toHexString(account),
774                         " is missing role ",
775                         Strings.toHexString(uint256(role), 32)
776                     )
777                 )
778             );
779         }
780     }
781 
782     /**
783      * @dev Returns the admin role that controls `role`. See {grantRole} and
784      * {revokeRole}.
785      *
786      * To change a role's admin, use {_setRoleAdmin}.
787      */
788     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
789         return _roles[role].adminRole;
790     }
791 
792     /**
793      * @dev Grants `role` to `account`.
794      *
795      * If `account` had not been already granted `role`, emits a {RoleGranted}
796      * event.
797      *
798      * Requirements:
799      *
800      * - the caller must have ``role``'s admin role.
801      *
802      * May emit a {RoleGranted} event.
803      */
804     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
805         _grantRole(role, account);
806     }
807 
808     /**
809      * @dev Revokes `role` from `account`.
810      *
811      * If `account` had been granted `role`, emits a {RoleRevoked} event.
812      *
813      * Requirements:
814      *
815      * - the caller must have ``role``'s admin role.
816      *
817      * May emit a {RoleRevoked} event.
818      */
819     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
820         _revokeRole(role, account);
821     }
822 
823     /**
824      * @dev Revokes `role` from the calling account.
825      *
826      * Roles are often managed via {grantRole} and {revokeRole}: this function's
827      * purpose is to provide a mechanism for accounts to lose their privileges
828      * if they are compromised (such as when a trusted device is misplaced).
829      *
830      * If the calling account had been revoked `role`, emits a {RoleRevoked}
831      * event.
832      *
833      * Requirements:
834      *
835      * - the caller must be `account`.
836      *
837      * May emit a {RoleRevoked} event.
838      */
839     function renounceRole(bytes32 role, address account) public virtual override {
840         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
841 
842         _revokeRole(role, account);
843     }
844 
845     /**
846      * @dev Grants `role` to `account`.
847      *
848      * If `account` had not been already granted `role`, emits a {RoleGranted}
849      * event. Note that unlike {grantRole}, this function doesn't perform any
850      * checks on the calling account.
851      *
852      * May emit a {RoleGranted} event.
853      *
854      * [WARNING]
855      * ====
856      * This function should only be called from the constructor when setting
857      * up the initial roles for the system.
858      *
859      * Using this function in any other way is effectively circumventing the admin
860      * system imposed by {AccessControl}.
861      * ====
862      *
863      * NOTE: This function is deprecated in favor of {_grantRole}.
864      */
865     function _setupRole(bytes32 role, address account) internal virtual {
866         _grantRole(role, account);
867     }
868 
869     /**
870      * @dev Sets `adminRole` as ``role``'s admin role.
871      *
872      * Emits a {RoleAdminChanged} event.
873      */
874     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
875         bytes32 previousAdminRole = getRoleAdmin(role);
876         _roles[role].adminRole = adminRole;
877         emit RoleAdminChanged(role, previousAdminRole, adminRole);
878     }
879 
880     /**
881      * @dev Grants `role` to `account`.
882      *
883      * Internal function without access restriction.
884      *
885      * May emit a {RoleGranted} event.
886      */
887     function _grantRole(bytes32 role, address account) internal virtual {
888         if (!hasRole(role, account)) {
889             _roles[role].members[account] = true;
890             emit RoleGranted(role, account, _msgSender());
891         }
892     }
893 
894     /**
895      * @dev Revokes `role` from `account`.
896      *
897      * Internal function without access restriction.
898      *
899      * May emit a {RoleRevoked} event.
900      */
901     function _revokeRole(bytes32 role, address account) internal virtual {
902         if (hasRole(role, account)) {
903             _roles[role].members[account] = false;
904             emit RoleRevoked(role, account, _msgSender());
905         }
906     }
907 }
908 
909 
910 // File contracts/Roles.sol
911 
912 // 
913 pragma solidity >0.8.0;
914 
915 contract Roles is AccessControl {
916     error NotAuthorizedError(address sender);
917 
918     constructor(address _owner) {
919         _setupRole(DEFAULT_ADMIN_ROLE, _owner);
920     }
921 
922     modifier onlyOwner() {
923         if (!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
924             revert NotAuthorizedError(_msgSender());
925         }
926         _;
927     }
928 }
929 
930 
931 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.2
932 
933 // 
934 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 /**
939  * @dev Interface of the ERC20 standard as defined in the EIP.
940  */
941 interface IERC20 {
942     /**
943      * @dev Emitted when `value` tokens are moved from one account (`from`) to
944      * another (`to`).
945      *
946      * Note that `value` may be zero.
947      */
948     event Transfer(address indexed from, address indexed to, uint256 value);
949 
950     /**
951      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
952      * a call to {approve}. `value` is the new allowance.
953      */
954     event Approval(address indexed owner, address indexed spender, uint256 value);
955 
956     /**
957      * @dev Returns the amount of tokens in existence.
958      */
959     function totalSupply() external view returns (uint256);
960 
961     /**
962      * @dev Returns the amount of tokens owned by `account`.
963      */
964     function balanceOf(address account) external view returns (uint256);
965 
966     /**
967      * @dev Moves `amount` tokens from the caller's account to `to`.
968      *
969      * Returns a boolean value indicating whether the operation succeeded.
970      *
971      * Emits a {Transfer} event.
972      */
973     function transfer(address to, uint256 amount) external returns (bool);
974 
975     /**
976      * @dev Returns the remaining number of tokens that `spender` will be
977      * allowed to spend on behalf of `owner` through {transferFrom}. This is
978      * zero by default.
979      *
980      * This value changes when {approve} or {transferFrom} are called.
981      */
982     function allowance(address owner, address spender) external view returns (uint256);
983 
984     /**
985      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
986      *
987      * Returns a boolean value indicating whether the operation succeeded.
988      *
989      * IMPORTANT: Beware that changing an allowance with this method brings the risk
990      * that someone may use both the old and the new allowance by unfortunate
991      * transaction ordering. One possible solution to mitigate this race
992      * condition is to first reduce the spender's allowance to 0 and set the
993      * desired value afterwards:
994      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
995      *
996      * Emits an {Approval} event.
997      */
998     function approve(address spender, uint256 amount) external returns (bool);
999 
1000     /**
1001      * @dev Moves `amount` tokens from `from` to `to` using the
1002      * allowance mechanism. `amount` is then deducted from the caller's
1003      * allowance.
1004      *
1005      * Returns a boolean value indicating whether the operation succeeded.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1010 }
1011 
1012 
1013 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.2
1014 
1015 // 
1016 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 /**
1021  * @dev Interface for the optional metadata functions from the ERC20 standard.
1022  *
1023  * _Available since v4.1._
1024  */
1025 interface IERC20Metadata is IERC20 {
1026     /**
1027      * @dev Returns the name of the token.
1028      */
1029     function name() external view returns (string memory);
1030 
1031     /**
1032      * @dev Returns the symbol of the token.
1033      */
1034     function symbol() external view returns (string memory);
1035 
1036     /**
1037      * @dev Returns the decimals places of the token.
1038      */
1039     function decimals() external view returns (uint8);
1040 }
1041 
1042 
1043 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.2
1044 
1045 // 
1046 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1047 
1048 pragma solidity ^0.8.0;
1049 
1050 
1051 
1052 /**
1053  * @dev Implementation of the {IERC20} interface.
1054  *
1055  * This implementation is agnostic to the way tokens are created. This means
1056  * that a supply mechanism has to be added in a derived contract using {_mint}.
1057  * For a generic mechanism see {ERC20PresetMinterPauser}.
1058  *
1059  * TIP: For a detailed writeup see our guide
1060  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1061  * to implement supply mechanisms].
1062  *
1063  * The default value of {decimals} is 18. To change this, you should override
1064  * this function so it returns a different value.
1065  *
1066  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1067  * instead returning `false` on failure. This behavior is nonetheless
1068  * conventional and does not conflict with the expectations of ERC20
1069  * applications.
1070  *
1071  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1072  * This allows applications to reconstruct the allowance for all accounts just
1073  * by listening to said events. Other implementations of the EIP may not emit
1074  * these events, as it isn't required by the specification.
1075  *
1076  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1077  * functions have been added to mitigate the well-known issues around setting
1078  * allowances. See {IERC20-approve}.
1079  */
1080 contract ERC20 is Context, IERC20, IERC20Metadata {
1081     mapping(address => uint256) private _balances;
1082 
1083     mapping(address => mapping(address => uint256)) private _allowances;
1084 
1085     uint256 private _totalSupply;
1086 
1087     string private _name;
1088     string private _symbol;
1089 
1090     /**
1091      * @dev Sets the values for {name} and {symbol}.
1092      *
1093      * All two of these values are immutable: they can only be set once during
1094      * construction.
1095      */
1096     constructor(string memory name_, string memory symbol_) {
1097         _name = name_;
1098         _symbol = symbol_;
1099     }
1100 
1101     /**
1102      * @dev Returns the name of the token.
1103      */
1104     function name() public view virtual override returns (string memory) {
1105         return _name;
1106     }
1107 
1108     /**
1109      * @dev Returns the symbol of the token, usually a shorter version of the
1110      * name.
1111      */
1112     function symbol() public view virtual override returns (string memory) {
1113         return _symbol;
1114     }
1115 
1116     /**
1117      * @dev Returns the number of decimals used to get its user representation.
1118      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1119      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1120      *
1121      * Tokens usually opt for a value of 18, imitating the relationship between
1122      * Ether and Wei. This is the default value returned by this function, unless
1123      * it's overridden.
1124      *
1125      * NOTE: This information is only used for _display_ purposes: it in
1126      * no way affects any of the arithmetic of the contract, including
1127      * {IERC20-balanceOf} and {IERC20-transfer}.
1128      */
1129     function decimals() public view virtual override returns (uint8) {
1130         return 18;
1131     }
1132 
1133     /**
1134      * @dev See {IERC20-totalSupply}.
1135      */
1136     function totalSupply() public view virtual override returns (uint256) {
1137         return _totalSupply;
1138     }
1139 
1140     /**
1141      * @dev See {IERC20-balanceOf}.
1142      */
1143     function balanceOf(address account) public view virtual override returns (uint256) {
1144         return _balances[account];
1145     }
1146 
1147     /**
1148      * @dev See {IERC20-transfer}.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - the caller must have a balance of at least `amount`.
1154      */
1155     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1156         address owner = _msgSender();
1157         _transfer(owner, to, amount);
1158         return true;
1159     }
1160 
1161     /**
1162      * @dev See {IERC20-allowance}.
1163      */
1164     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1165         return _allowances[owner][spender];
1166     }
1167 
1168     /**
1169      * @dev See {IERC20-approve}.
1170      *
1171      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1172      * `transferFrom`. This is semantically equivalent to an infinite approval.
1173      *
1174      * Requirements:
1175      *
1176      * - `spender` cannot be the zero address.
1177      */
1178     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1179         address owner = _msgSender();
1180         _approve(owner, spender, amount);
1181         return true;
1182     }
1183 
1184     /**
1185      * @dev See {IERC20-transferFrom}.
1186      *
1187      * Emits an {Approval} event indicating the updated allowance. This is not
1188      * required by the EIP. See the note at the beginning of {ERC20}.
1189      *
1190      * NOTE: Does not update the allowance if the current allowance
1191      * is the maximum `uint256`.
1192      *
1193      * Requirements:
1194      *
1195      * - `from` and `to` cannot be the zero address.
1196      * - `from` must have a balance of at least `amount`.
1197      * - the caller must have allowance for ``from``'s tokens of at least
1198      * `amount`.
1199      */
1200     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1201         address spender = _msgSender();
1202         _spendAllowance(from, spender, amount);
1203         _transfer(from, to, amount);
1204         return true;
1205     }
1206 
1207     /**
1208      * @dev Atomically increases the allowance granted to `spender` by the caller.
1209      *
1210      * This is an alternative to {approve} that can be used as a mitigation for
1211      * problems described in {IERC20-approve}.
1212      *
1213      * Emits an {Approval} event indicating the updated allowance.
1214      *
1215      * Requirements:
1216      *
1217      * - `spender` cannot be the zero address.
1218      */
1219     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1220         address owner = _msgSender();
1221         _approve(owner, spender, allowance(owner, spender) + addedValue);
1222         return true;
1223     }
1224 
1225     /**
1226      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1227      *
1228      * This is an alternative to {approve} that can be used as a mitigation for
1229      * problems described in {IERC20-approve}.
1230      *
1231      * Emits an {Approval} event indicating the updated allowance.
1232      *
1233      * Requirements:
1234      *
1235      * - `spender` cannot be the zero address.
1236      * - `spender` must have allowance for the caller of at least
1237      * `subtractedValue`.
1238      */
1239     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1240         address owner = _msgSender();
1241         uint256 currentAllowance = allowance(owner, spender);
1242         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1243         unchecked {
1244             _approve(owner, spender, currentAllowance - subtractedValue);
1245         }
1246 
1247         return true;
1248     }
1249 
1250     /**
1251      * @dev Moves `amount` of tokens from `from` to `to`.
1252      *
1253      * This internal function is equivalent to {transfer}, and can be used to
1254      * e.g. implement automatic token fees, slashing mechanisms, etc.
1255      *
1256      * Emits a {Transfer} event.
1257      *
1258      * Requirements:
1259      *
1260      * - `from` cannot be the zero address.
1261      * - `to` cannot be the zero address.
1262      * - `from` must have a balance of at least `amount`.
1263      */
1264     function _transfer(address from, address to, uint256 amount) internal virtual {
1265         require(from != address(0), "ERC20: transfer from the zero address");
1266         require(to != address(0), "ERC20: transfer to the zero address");
1267 
1268         _beforeTokenTransfer(from, to, amount);
1269 
1270         uint256 fromBalance = _balances[from];
1271         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1272         unchecked {
1273             _balances[from] = fromBalance - amount;
1274             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1275             // decrementing then incrementing.
1276             _balances[to] += amount;
1277         }
1278 
1279         emit Transfer(from, to, amount);
1280 
1281         _afterTokenTransfer(from, to, amount);
1282     }
1283 
1284     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1285      * the total supply.
1286      *
1287      * Emits a {Transfer} event with `from` set to the zero address.
1288      *
1289      * Requirements:
1290      *
1291      * - `account` cannot be the zero address.
1292      */
1293     function _mint(address account, uint256 amount) internal virtual {
1294         require(account != address(0), "ERC20: mint to the zero address");
1295 
1296         _beforeTokenTransfer(address(0), account, amount);
1297 
1298         _totalSupply += amount;
1299         unchecked {
1300             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1301             _balances[account] += amount;
1302         }
1303         emit Transfer(address(0), account, amount);
1304 
1305         _afterTokenTransfer(address(0), account, amount);
1306     }
1307 
1308     /**
1309      * @dev Destroys `amount` tokens from `account`, reducing the
1310      * total supply.
1311      *
1312      * Emits a {Transfer} event with `to` set to the zero address.
1313      *
1314      * Requirements:
1315      *
1316      * - `account` cannot be the zero address.
1317      * - `account` must have at least `amount` tokens.
1318      */
1319     function _burn(address account, uint256 amount) internal virtual {
1320         require(account != address(0), "ERC20: burn from the zero address");
1321 
1322         _beforeTokenTransfer(account, address(0), amount);
1323 
1324         uint256 accountBalance = _balances[account];
1325         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1326         unchecked {
1327             _balances[account] = accountBalance - amount;
1328             // Overflow not possible: amount <= accountBalance <= totalSupply.
1329             _totalSupply -= amount;
1330         }
1331 
1332         emit Transfer(account, address(0), amount);
1333 
1334         _afterTokenTransfer(account, address(0), amount);
1335     }
1336 
1337     /**
1338      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1339      *
1340      * This internal function is equivalent to `approve`, and can be used to
1341      * e.g. set automatic allowances for certain subsystems, etc.
1342      *
1343      * Emits an {Approval} event.
1344      *
1345      * Requirements:
1346      *
1347      * - `owner` cannot be the zero address.
1348      * - `spender` cannot be the zero address.
1349      */
1350     function _approve(address owner, address spender, uint256 amount) internal virtual {
1351         require(owner != address(0), "ERC20: approve from the zero address");
1352         require(spender != address(0), "ERC20: approve to the zero address");
1353 
1354         _allowances[owner][spender] = amount;
1355         emit Approval(owner, spender, amount);
1356     }
1357 
1358     /**
1359      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1360      *
1361      * Does not update the allowance amount in case of infinite allowance.
1362      * Revert if not enough allowance is available.
1363      *
1364      * Might emit an {Approval} event.
1365      */
1366     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1367         uint256 currentAllowance = allowance(owner, spender);
1368         if (currentAllowance != type(uint256).max) {
1369             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1370             unchecked {
1371                 _approve(owner, spender, currentAllowance - amount);
1372             }
1373         }
1374     }
1375 
1376     /**
1377      * @dev Hook that is called before any transfer of tokens. This includes
1378      * minting and burning.
1379      *
1380      * Calling conditions:
1381      *
1382      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1383      * will be transferred to `to`.
1384      * - when `from` is zero, `amount` tokens will be minted for `to`.
1385      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1386      * - `from` and `to` are never both zero.
1387      *
1388      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1389      */
1390     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1391 
1392     /**
1393      * @dev Hook that is called after any transfer of tokens. This includes
1394      * minting and burning.
1395      *
1396      * Calling conditions:
1397      *
1398      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1399      * has been transferred to `to`.
1400      * - when `from` is zero, `amount` tokens have been minted for `to`.
1401      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1402      * - `from` and `to` are never both zero.
1403      *
1404      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1405      */
1406     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1407 }
1408 
1409 
1410 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.9.2
1411 
1412 // 
1413 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 /**
1418  * @dev Contract module that helps prevent reentrant calls to a function.
1419  *
1420  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1421  * available, which can be applied to functions to make sure there are no nested
1422  * (reentrant) calls to them.
1423  *
1424  * Note that because there is a single `nonReentrant` guard, functions marked as
1425  * `nonReentrant` may not call one another. This can be worked around by making
1426  * those functions `private`, and then adding `external` `nonReentrant` entry
1427  * points to them.
1428  *
1429  * TIP: If you would like to learn more about reentrancy and alternative ways
1430  * to protect against it, check out our blog post
1431  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1432  */
1433 abstract contract ReentrancyGuard {
1434     // Booleans are more expensive than uint256 or any type that takes up a full
1435     // word because each write operation emits an extra SLOAD to first read the
1436     // slot's contents, replace the bits taken up by the boolean, and then write
1437     // back. This is the compiler's defense against contract upgrades and
1438     // pointer aliasing, and it cannot be disabled.
1439 
1440     // The values being non-zero value makes deployment a bit more expensive,
1441     // but in exchange the refund on every call to nonReentrant will be lower in
1442     // amount. Since refunds are capped to a percentage of the total
1443     // transaction's gas, it is best to keep them low in cases like this one, to
1444     // increase the likelihood of the full refund coming into effect.
1445     uint256 private constant _NOT_ENTERED = 1;
1446     uint256 private constant _ENTERED = 2;
1447 
1448     uint256 private _status;
1449 
1450     constructor() {
1451         _status = _NOT_ENTERED;
1452     }
1453 
1454     /**
1455      * @dev Prevents a contract from calling itself, directly or indirectly.
1456      * Calling a `nonReentrant` function from another `nonReentrant`
1457      * function is not supported. It is possible to prevent this from happening
1458      * by making the `nonReentrant` function external, and making it call a
1459      * `private` function that does the actual work.
1460      */
1461     modifier nonReentrant() {
1462         _nonReentrantBefore();
1463         _;
1464         _nonReentrantAfter();
1465     }
1466 
1467     function _nonReentrantBefore() private {
1468         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1469         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1470 
1471         // Any calls to nonReentrant after this point will fail
1472         _status = _ENTERED;
1473     }
1474 
1475     function _nonReentrantAfter() private {
1476         // By storing the original value once again, a refund is triggered (see
1477         // https://eips.ethereum.org/EIPS/eip-2200)
1478         _status = _NOT_ENTERED;
1479     }
1480 
1481     /**
1482      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1483      * `nonReentrant` function in the call stack.
1484      */
1485     function _reentrancyGuardEntered() internal view returns (bool) {
1486         return _status == _ENTERED;
1487     }
1488 }
1489 
1490 
1491 // File @openzeppelin/contracts/security/Pausable.sol@v4.9.2
1492 
1493 // 
1494 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1495 
1496 pragma solidity ^0.8.0;
1497 
1498 /**
1499  * @dev Contract module which allows children to implement an emergency stop
1500  * mechanism that can be triggered by an authorized account.
1501  *
1502  * This module is used through inheritance. It will make available the
1503  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1504  * the functions of your contract. Note that they will not be pausable by
1505  * simply including this module, only once the modifiers are put in place.
1506  */
1507 abstract contract Pausable is Context {
1508     /**
1509      * @dev Emitted when the pause is triggered by `account`.
1510      */
1511     event Paused(address account);
1512 
1513     /**
1514      * @dev Emitted when the pause is lifted by `account`.
1515      */
1516     event Unpaused(address account);
1517 
1518     bool private _paused;
1519 
1520     /**
1521      * @dev Initializes the contract in unpaused state.
1522      */
1523     constructor() {
1524         _paused = false;
1525     }
1526 
1527     /**
1528      * @dev Modifier to make a function callable only when the contract is not paused.
1529      *
1530      * Requirements:
1531      *
1532      * - The contract must not be paused.
1533      */
1534     modifier whenNotPaused() {
1535         _requireNotPaused();
1536         _;
1537     }
1538 
1539     /**
1540      * @dev Modifier to make a function callable only when the contract is paused.
1541      *
1542      * Requirements:
1543      *
1544      * - The contract must be paused.
1545      */
1546     modifier whenPaused() {
1547         _requirePaused();
1548         _;
1549     }
1550 
1551     /**
1552      * @dev Returns true if the contract is paused, and false otherwise.
1553      */
1554     function paused() public view virtual returns (bool) {
1555         return _paused;
1556     }
1557 
1558     /**
1559      * @dev Throws if the contract is paused.
1560      */
1561     function _requireNotPaused() internal view virtual {
1562         require(!paused(), "Pausable: paused");
1563     }
1564 
1565     /**
1566      * @dev Throws if the contract is not paused.
1567      */
1568     function _requirePaused() internal view virtual {
1569         require(paused(), "Pausable: not paused");
1570     }
1571 
1572     /**
1573      * @dev Triggers stopped state.
1574      *
1575      * Requirements:
1576      *
1577      * - The contract must not be paused.
1578      */
1579     function _pause() internal virtual whenNotPaused {
1580         _paused = true;
1581         emit Paused(_msgSender());
1582     }
1583 
1584     /**
1585      * @dev Returns to normal state.
1586      *
1587      * Requirements:
1588      *
1589      * - The contract must be paused.
1590      */
1591     function _unpause() internal virtual whenPaused {
1592         _paused = false;
1593         emit Unpaused(_msgSender());
1594     }
1595 }
1596 
1597 
1598 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.9.2
1599 
1600 // 
1601 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 /**
1607  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1608  * tokens and those that they have an allowance for, in a way that can be
1609  * recognized off-chain (via event analysis).
1610  */
1611 abstract contract ERC20Burnable is Context, ERC20 {
1612     /**
1613      * @dev Destroys `amount` tokens from the caller.
1614      *
1615      * See {ERC20-_burn}.
1616      */
1617     function burn(uint256 amount) public virtual {
1618         _burn(_msgSender(), amount);
1619     }
1620 
1621     /**
1622      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1623      * allowance.
1624      *
1625      * See {ERC20-_burn} and {ERC20-allowance}.
1626      *
1627      * Requirements:
1628      *
1629      * - the caller must have allowance for ``accounts``'s tokens of at least
1630      * `amount`.
1631      */
1632     function burnFrom(address account, uint256 amount) public virtual {
1633         _spendAllowance(account, _msgSender(), amount);
1634         _burn(account, amount);
1635     }
1636 }
1637 
1638 
1639 // File contracts/HomelessDog.sol
1640 
1641 // 
1642 pragma solidity ^0.8.9;
1643 interface IHomelessCard {
1644     function mint(address to, uint256 value) external payable;
1645 }
1646 
1647 contract HomelessDog is ERC20, ERC20Burnable, Roles, Pausable, ReentrancyGuard {
1648     uint256 public round = 1;
1649     uint256 public mintCount;
1650     uint256 public currentThreshold = 20;
1651     uint256 public totalThreshold = 20;
1652     uint256 public tokenAmount;
1653     uint256 public shareAmount;
1654 
1655     uint256 public constant UNIT = 10 ** 18;
1656     uint256 public fee = 2;
1657     address public swapAddr;
1658     address public lpOwner;
1659     bool public lock;
1660     uint256 public unlockTimestamp;
1661     address public recipient;
1662     address public homelessCard;
1663     address public NonfungiblePositionManager;
1664 
1665     constructor() ERC20("HomelessDog", "HDT") Roles(_msgSender()) {
1666         tokenAmount = 1000 * UNIT;
1667         shareAmount = (10 ** 8 * UNIT) / totalThreshold;
1668         _mint(_msgSender(), 8 * 10 ** 10 * UNIT);
1669     }
1670 
1671     function pause() public onlyOwner {
1672         _pause();
1673     }
1674 
1675     function unpause() public onlyOwner {
1676         _unpause();
1677     }
1678 
1679     function setFee(uint256 fee_) external onlyOwner {
1680         require(fee_ < 10, "fee < 10");
1681         fee = fee_;
1682     }
1683 
1684     function setSwapAddrAndLock(address swapAddr_, address lpOwner_) external onlyOwner {
1685         require(!lock, "locked");
1686         lock = true;
1687         unlockTimestamp = block.timestamp + 90 days;
1688         swapAddr = swapAddr_;
1689         lpOwner = lpOwner_;
1690     }
1691 
1692     function setHomelessCard(address homelessCard_) external onlyOwner {
1693         homelessCard = homelessCard_;
1694     }
1695 
1696     function setNonfungiblePositionManager(address NonfungiblePositionManager_) external onlyOwner {
1697         NonfungiblePositionManager = NonfungiblePositionManager_;
1698     }
1699 
1700     function setRecipient(address recipient_) external onlyOwner {
1701         recipient = recipient_;
1702     }
1703 
1704     function withdrawEth() external nonReentrant onlyOwner {
1705         require(address(this).balance > 0, "balance is zero");
1706         require(recipient != address(0), "recipient is zero");
1707         (bool success, ) = recipient.call{value: address(this).balance}("");
1708         require(success, "Unable to send value");
1709     }
1710 
1711     function mint() external payable nonReentrant whenNotPaused {
1712         require(msg.value == 0.1 ether, "Need to pay 0.1 eth");
1713         require(totalSupply() < 10 ** 35, "finish");
1714         (uint256 _tokenAmount, uint256 _shareAmount) = calculate();
1715         _mint(_msgSender(), _tokenAmount);
1716         IHomelessCard(homelessCard).mint{value: 0.05 ether}(_msgSender(), _shareAmount);
1717     }
1718 
1719     function calculate() internal returns (uint256 _tokenAmount, uint256 _shareAmount) {
1720         ++mintCount;
1721         _tokenAmount = tokenAmount;
1722         _shareAmount = shareAmount;
1723         if (mintCount >= totalThreshold) {
1724             currentThreshold = (currentThreshold * 3) / 2;
1725             totalThreshold += currentThreshold;
1726             ++round;
1727             tokenAmount = (tokenAmount * 31) / 20;
1728             shareAmount = (10 ** 8 * UNIT) / totalThreshold;
1729         }
1730     }
1731 
1732     function _transfer(address from, address to, uint256 amount) internal override {
1733         if (to == lpOwner && lock) {
1734             require(block.timestamp > unlockTimestamp, "forbidden");
1735         }
1736 
1737         if (from == swapAddr && to != NonfungiblePositionManager && fee > 0) {
1738             uint256 feeAmount = (amount * fee) / 100;
1739             amount -= feeAmount;
1740             super._transfer(from, address(this), feeAmount);
1741         }
1742         super._transfer(from, to, amount);
1743     }
1744 
1745     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override whenNotPaused {
1746         super._beforeTokenTransfer(from, to, amount);
1747     }
1748 }