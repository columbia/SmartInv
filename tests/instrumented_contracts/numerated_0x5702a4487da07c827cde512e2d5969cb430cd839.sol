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
60 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev Standard signed math utilities missing in the Solidity language.
69  */
70 library SignedMath {
71     /**
72      * @dev Returns the largest of two signed numbers.
73      */
74     function max(int256 a, int256 b) internal pure returns (int256) {
75         return a > b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the smallest of two signed numbers.
80      */
81     function min(int256 a, int256 b) internal pure returns (int256) {
82         return a < b ? a : b;
83     }
84 
85     /**
86      * @dev Returns the average of two signed numbers without overflow.
87      * The result is rounded towards zero.
88      */
89     function average(int256 a, int256 b) internal pure returns (int256) {
90         // Formula from the book "Hacker's Delight"
91         int256 x = (a & b) + ((a ^ b) >> 1);
92         return x + (int256(uint256(x) >> 255) & (a ^ b));
93     }
94 
95     /**
96      * @dev Returns the absolute unsigned value of a signed value.
97      */
98     function abs(int256 n) internal pure returns (uint256) {
99         unchecked {
100             // must be unchecked in order to support `n = type(int256).min`
101             return uint256(n >= 0 ? n : -n);
102         }
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/math/Math.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Standard math utilities missing in the Solidity language.
115  */
116 library Math {
117     enum Rounding {
118         Down, // Toward negative infinity
119         Up, // Toward infinity
120         Zero // Toward zero
121     }
122 
123     /**
124      * @dev Returns the largest of two numbers.
125      */
126     function max(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a > b ? a : b;
128     }
129 
130     /**
131      * @dev Returns the smallest of two numbers.
132      */
133     function min(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a < b ? a : b;
135     }
136 
137     /**
138      * @dev Returns the average of two numbers. The result is rounded towards
139      * zero.
140      */
141     function average(uint256 a, uint256 b) internal pure returns (uint256) {
142         // (a + b) / 2 can overflow.
143         return (a & b) + (a ^ b) / 2;
144     }
145 
146     /**
147      * @dev Returns the ceiling of the division of two numbers.
148      *
149      * This differs from standard division with `/` in that it rounds up instead
150      * of rounding down.
151      */
152     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
153         // (a + b - 1) / b can overflow on addition, so we distribute.
154         return a == 0 ? 0 : (a - 1) / b + 1;
155     }
156 
157     /**
158      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
159      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
160      * with further edits by Uniswap Labs also under MIT license.
161      */
162     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
163         unchecked {
164             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
165             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
166             // variables such that product = prod1 * 2^256 + prod0.
167             uint256 prod0; // Least significant 256 bits of the product
168             uint256 prod1; // Most significant 256 bits of the product
169             assembly {
170                 let mm := mulmod(x, y, not(0))
171                 prod0 := mul(x, y)
172                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
173             }
174 
175             // Handle non-overflow cases, 256 by 256 division.
176             if (prod1 == 0) {
177                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
178                 // The surrounding unchecked block does not change this fact.
179                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
180                 return prod0 / denominator;
181             }
182 
183             // Make sure the result is less than 2^256. Also prevents denominator == 0.
184             require(denominator > prod1, "Math: mulDiv overflow");
185 
186             ///////////////////////////////////////////////
187             // 512 by 256 division.
188             ///////////////////////////////////////////////
189 
190             // Make division exact by subtracting the remainder from [prod1 prod0].
191             uint256 remainder;
192             assembly {
193                 // Compute remainder using mulmod.
194                 remainder := mulmod(x, y, denominator)
195 
196                 // Subtract 256 bit number from 512 bit number.
197                 prod1 := sub(prod1, gt(remainder, prod0))
198                 prod0 := sub(prod0, remainder)
199             }
200 
201             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
202             // See https://cs.stackexchange.com/q/138556/92363.
203 
204             // Does not overflow because the denominator cannot be zero at this stage in the function.
205             uint256 twos = denominator & (~denominator + 1);
206             assembly {
207                 // Divide denominator by twos.
208                 denominator := div(denominator, twos)
209 
210                 // Divide [prod1 prod0] by twos.
211                 prod0 := div(prod0, twos)
212 
213                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
214                 twos := add(div(sub(0, twos), twos), 1)
215             }
216 
217             // Shift in bits from prod1 into prod0.
218             prod0 |= prod1 * twos;
219 
220             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
221             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
222             // four bits. That is, denominator * inv = 1 mod 2^4.
223             uint256 inverse = (3 * denominator) ^ 2;
224 
225             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
226             // in modular arithmetic, doubling the correct bits in each step.
227             inverse *= 2 - denominator * inverse; // inverse mod 2^8
228             inverse *= 2 - denominator * inverse; // inverse mod 2^16
229             inverse *= 2 - denominator * inverse; // inverse mod 2^32
230             inverse *= 2 - denominator * inverse; // inverse mod 2^64
231             inverse *= 2 - denominator * inverse; // inverse mod 2^128
232             inverse *= 2 - denominator * inverse; // inverse mod 2^256
233 
234             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
235             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
236             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
237             // is no longer required.
238             result = prod0 * inverse;
239             return result;
240         }
241     }
242 
243     /**
244      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
245      */
246     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
247         uint256 result = mulDiv(x, y, denominator);
248         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
249             result += 1;
250         }
251         return result;
252     }
253 
254     /**
255      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
256      *
257      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
258      */
259     function sqrt(uint256 a) internal pure returns (uint256) {
260         if (a == 0) {
261             return 0;
262         }
263 
264         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
265         //
266         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
267         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
268         //
269         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
270         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
271         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
272         //
273         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
274         uint256 result = 1 << (log2(a) >> 1);
275 
276         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
277         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
278         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
279         // into the expected uint128 result.
280         unchecked {
281             result = (result + a / result) >> 1;
282             result = (result + a / result) >> 1;
283             result = (result + a / result) >> 1;
284             result = (result + a / result) >> 1;
285             result = (result + a / result) >> 1;
286             result = (result + a / result) >> 1;
287             result = (result + a / result) >> 1;
288             return min(result, a / result);
289         }
290     }
291 
292     /**
293      * @notice Calculates sqrt(a), following the selected rounding direction.
294      */
295     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
296         unchecked {
297             uint256 result = sqrt(a);
298             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
299         }
300     }
301 
302     /**
303      * @dev Return the log in base 2, rounded down, of a positive value.
304      * Returns 0 if given 0.
305      */
306     function log2(uint256 value) internal pure returns (uint256) {
307         uint256 result = 0;
308         unchecked {
309             if (value >> 128 > 0) {
310                 value >>= 128;
311                 result += 128;
312             }
313             if (value >> 64 > 0) {
314                 value >>= 64;
315                 result += 64;
316             }
317             if (value >> 32 > 0) {
318                 value >>= 32;
319                 result += 32;
320             }
321             if (value >> 16 > 0) {
322                 value >>= 16;
323                 result += 16;
324             }
325             if (value >> 8 > 0) {
326                 value >>= 8;
327                 result += 8;
328             }
329             if (value >> 4 > 0) {
330                 value >>= 4;
331                 result += 4;
332             }
333             if (value >> 2 > 0) {
334                 value >>= 2;
335                 result += 2;
336             }
337             if (value >> 1 > 0) {
338                 result += 1;
339             }
340         }
341         return result;
342     }
343 
344     /**
345      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
346      * Returns 0 if given 0.
347      */
348     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
349         unchecked {
350             uint256 result = log2(value);
351             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
352         }
353     }
354 
355     /**
356      * @dev Return the log in base 10, rounded down, of a positive value.
357      * Returns 0 if given 0.
358      */
359     function log10(uint256 value) internal pure returns (uint256) {
360         uint256 result = 0;
361         unchecked {
362             if (value >= 10 ** 64) {
363                 value /= 10 ** 64;
364                 result += 64;
365             }
366             if (value >= 10 ** 32) {
367                 value /= 10 ** 32;
368                 result += 32;
369             }
370             if (value >= 10 ** 16) {
371                 value /= 10 ** 16;
372                 result += 16;
373             }
374             if (value >= 10 ** 8) {
375                 value /= 10 ** 8;
376                 result += 8;
377             }
378             if (value >= 10 ** 4) {
379                 value /= 10 ** 4;
380                 result += 4;
381             }
382             if (value >= 10 ** 2) {
383                 value /= 10 ** 2;
384                 result += 2;
385             }
386             if (value >= 10 ** 1) {
387                 result += 1;
388             }
389         }
390         return result;
391     }
392 
393     /**
394      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
395      * Returns 0 if given 0.
396      */
397     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
398         unchecked {
399             uint256 result = log10(value);
400             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
401         }
402     }
403 
404     /**
405      * @dev Return the log in base 256, rounded down, of a positive value.
406      * Returns 0 if given 0.
407      *
408      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
409      */
410     function log256(uint256 value) internal pure returns (uint256) {
411         uint256 result = 0;
412         unchecked {
413             if (value >> 128 > 0) {
414                 value >>= 128;
415                 result += 16;
416             }
417             if (value >> 64 > 0) {
418                 value >>= 64;
419                 result += 8;
420             }
421             if (value >> 32 > 0) {
422                 value >>= 32;
423                 result += 4;
424             }
425             if (value >> 16 > 0) {
426                 value >>= 16;
427                 result += 2;
428             }
429             if (value >> 8 > 0) {
430                 result += 1;
431             }
432         }
433         return result;
434     }
435 
436     /**
437      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
438      * Returns 0 if given 0.
439      */
440     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
441         unchecked {
442             uint256 result = log256(value);
443             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
444         }
445     }
446 }
447 
448 // File: @openzeppelin/contracts/utils/Strings.sol
449 
450 
451 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 
457 /**
458  * @dev String operations.
459  */
460 library Strings {
461     bytes16 private constant _SYMBOLS = "0123456789abcdef";
462     uint8 private constant _ADDRESS_LENGTH = 20;
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
466      */
467     function toString(uint256 value) internal pure returns (string memory) {
468         unchecked {
469             uint256 length = Math.log10(value) + 1;
470             string memory buffer = new string(length);
471             uint256 ptr;
472             /// @solidity memory-safe-assembly
473             assembly {
474                 ptr := add(buffer, add(32, length))
475             }
476             while (true) {
477                 ptr--;
478                 /// @solidity memory-safe-assembly
479                 assembly {
480                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
481                 }
482                 value /= 10;
483                 if (value == 0) break;
484             }
485             return buffer;
486         }
487     }
488 
489     /**
490      * @dev Converts a `int256` to its ASCII `string` decimal representation.
491      */
492     function toString(int256 value) internal pure returns (string memory) {
493         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
494     }
495 
496     /**
497      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
498      */
499     function toHexString(uint256 value) internal pure returns (string memory) {
500         unchecked {
501             return toHexString(value, Math.log256(value) + 1);
502         }
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
507      */
508     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
509         bytes memory buffer = new bytes(2 * length + 2);
510         buffer[0] = "0";
511         buffer[1] = "x";
512         for (uint256 i = 2 * length + 1; i > 1; --i) {
513             buffer[i] = _SYMBOLS[value & 0xf];
514             value >>= 4;
515         }
516         require(value == 0, "Strings: hex length insufficient");
517         return string(buffer);
518     }
519 
520     /**
521      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
522      */
523     function toHexString(address addr) internal pure returns (string memory) {
524         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
525     }
526 
527     /**
528      * @dev Returns true if the two strings are equal.
529      */
530     function equal(string memory a, string memory b) internal pure returns (bool) {
531         return keccak256(bytes(a)) == keccak256(bytes(b));
532     }
533 }
534 
535 // File: @openzeppelin/contracts/access/IAccessControl.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev External interface of AccessControl declared to support ERC165 detection.
544  */
545 interface IAccessControl {
546     /**
547      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
548      *
549      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
550      * {RoleAdminChanged} not being emitted signaling this.
551      *
552      * _Available since v3.1._
553      */
554     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
555 
556     /**
557      * @dev Emitted when `account` is granted `role`.
558      *
559      * `sender` is the account that originated the contract call, an admin role
560      * bearer except when using {AccessControl-_setupRole}.
561      */
562     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
563 
564     /**
565      * @dev Emitted when `account` is revoked `role`.
566      *
567      * `sender` is the account that originated the contract call:
568      *   - if using `revokeRole`, it is the admin role bearer
569      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
570      */
571     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
572 
573     /**
574      * @dev Returns `true` if `account` has been granted `role`.
575      */
576     function hasRole(bytes32 role, address account) external view returns (bool);
577 
578     /**
579      * @dev Returns the admin role that controls `role`. See {grantRole} and
580      * {revokeRole}.
581      *
582      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
583      */
584     function getRoleAdmin(bytes32 role) external view returns (bytes32);
585 
586     /**
587      * @dev Grants `role` to `account`.
588      *
589      * If `account` had not been already granted `role`, emits a {RoleGranted}
590      * event.
591      *
592      * Requirements:
593      *
594      * - the caller must have ``role``'s admin role.
595      */
596     function grantRole(bytes32 role, address account) external;
597 
598     /**
599      * @dev Revokes `role` from `account`.
600      *
601      * If `account` had been granted `role`, emits a {RoleRevoked} event.
602      *
603      * Requirements:
604      *
605      * - the caller must have ``role``'s admin role.
606      */
607     function revokeRole(bytes32 role, address account) external;
608 
609     /**
610      * @dev Revokes `role` from the calling account.
611      *
612      * Roles are often managed via {grantRole} and {revokeRole}: this function's
613      * purpose is to provide a mechanism for accounts to lose their privileges
614      * if they are compromised (such as when a trusted device is misplaced).
615      *
616      * If the calling account had been granted `role`, emits a {RoleRevoked}
617      * event.
618      *
619      * Requirements:
620      *
621      * - the caller must be `account`.
622      */
623     function renounceRole(bytes32 role, address account) external;
624 }
625 
626 // File: @openzeppelin/contracts/utils/Context.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Provides information about the current execution context, including the
635  * sender of the transaction and its data. While these are generally available
636  * via msg.sender and msg.data, they should not be accessed in such a direct
637  * manner, since when dealing with meta-transactions the account sending and
638  * paying for execution may not be the actual sender (as far as an application
639  * is concerned).
640  *
641  * This contract is only required for intermediate, library-like contracts.
642  */
643 abstract contract Context {
644     function _msgSender() internal view virtual returns (address) {
645         return msg.sender;
646     }
647 
648     function _msgData() internal view virtual returns (bytes calldata) {
649         return msg.data;
650     }
651 }
652 
653 // File: @openzeppelin/contracts/access/AccessControl.sol
654 
655 
656 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 
661 
662 
663 
664 /**
665  * @dev Contract module that allows children to implement role-based access
666  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
667  * members except through off-chain means by accessing the contract event logs. Some
668  * applications may benefit from on-chain enumerability, for those cases see
669  * {AccessControlEnumerable}.
670  *
671  * Roles are referred to by their `bytes32` identifier. These should be exposed
672  * in the external API and be unique. The best way to achieve this is by
673  * using `public constant` hash digests:
674  *
675  * ```solidity
676  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
677  * ```
678  *
679  * Roles can be used to represent a set of permissions. To restrict access to a
680  * function call, use {hasRole}:
681  *
682  * ```solidity
683  * function foo() public {
684  *     require(hasRole(MY_ROLE, msg.sender));
685  *     ...
686  * }
687  * ```
688  *
689  * Roles can be granted and revoked dynamically via the {grantRole} and
690  * {revokeRole} functions. Each role has an associated admin role, and only
691  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
692  *
693  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
694  * that only accounts with this role will be able to grant or revoke other
695  * roles. More complex role relationships can be created by using
696  * {_setRoleAdmin}.
697  *
698  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
699  * grant and revoke this role. Extra precautions should be taken to secure
700  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
701  * to enforce additional security measures for this role.
702  */
703 abstract contract AccessControl is Context, IAccessControl, ERC165 {
704     struct RoleData {
705         mapping(address => bool) members;
706         bytes32 adminRole;
707     }
708 
709     mapping(bytes32 => RoleData) private _roles;
710 
711     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
712 
713     /**
714      * @dev Modifier that checks that an account has a specific role. Reverts
715      * with a standardized message including the required role.
716      *
717      * The format of the revert reason is given by the following regular expression:
718      *
719      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
720      *
721      * _Available since v4.1._
722      */
723     modifier onlyRole(bytes32 role) {
724         _checkRole(role);
725         _;
726     }
727 
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
732         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev Returns `true` if `account` has been granted `role`.
737      */
738     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
739         return _roles[role].members[account];
740     }
741 
742     /**
743      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
744      * Overriding this function changes the behavior of the {onlyRole} modifier.
745      *
746      * Format of the revert message is described in {_checkRole}.
747      *
748      * _Available since v4.6._
749      */
750     function _checkRole(bytes32 role) internal view virtual {
751         _checkRole(role, _msgSender());
752     }
753 
754     /**
755      * @dev Revert with a standard message if `account` is missing `role`.
756      *
757      * The format of the revert reason is given by the following regular expression:
758      *
759      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
760      */
761     function _checkRole(bytes32 role, address account) internal view virtual {
762         if (!hasRole(role, account)) {
763             revert(
764                 string(
765                     abi.encodePacked(
766                         "AccessControl: account ",
767                         Strings.toHexString(account),
768                         " is missing role ",
769                         Strings.toHexString(uint256(role), 32)
770                     )
771                 )
772             );
773         }
774     }
775 
776     /**
777      * @dev Returns the admin role that controls `role`. See {grantRole} and
778      * {revokeRole}.
779      *
780      * To change a role's admin, use {_setRoleAdmin}.
781      */
782     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
783         return _roles[role].adminRole;
784     }
785 
786     /**
787      * @dev Grants `role` to `account`.
788      *
789      * If `account` had not been already granted `role`, emits a {RoleGranted}
790      * event.
791      *
792      * Requirements:
793      *
794      * - the caller must have ``role``'s admin role.
795      *
796      * May emit a {RoleGranted} event.
797      */
798     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
799         _grantRole(role, account);
800     }
801 
802     /**
803      * @dev Revokes `role` from `account`.
804      *
805      * If `account` had been granted `role`, emits a {RoleRevoked} event.
806      *
807      * Requirements:
808      *
809      * - the caller must have ``role``'s admin role.
810      *
811      * May emit a {RoleRevoked} event.
812      */
813     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
814         _revokeRole(role, account);
815     }
816 
817     /**
818      * @dev Revokes `role` from the calling account.
819      *
820      * Roles are often managed via {grantRole} and {revokeRole}: this function's
821      * purpose is to provide a mechanism for accounts to lose their privileges
822      * if they are compromised (such as when a trusted device is misplaced).
823      *
824      * If the calling account had been revoked `role`, emits a {RoleRevoked}
825      * event.
826      *
827      * Requirements:
828      *
829      * - the caller must be `account`.
830      *
831      * May emit a {RoleRevoked} event.
832      */
833     function renounceRole(bytes32 role, address account) public virtual override {
834         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
835 
836         _revokeRole(role, account);
837     }
838 
839     /**
840      * @dev Grants `role` to `account`.
841      *
842      * If `account` had not been already granted `role`, emits a {RoleGranted}
843      * event. Note that unlike {grantRole}, this function doesn't perform any
844      * checks on the calling account.
845      *
846      * May emit a {RoleGranted} event.
847      *
848      * [WARNING]
849      * ====
850      * This function should only be called from the constructor when setting
851      * up the initial roles for the system.
852      *
853      * Using this function in any other way is effectively circumventing the admin
854      * system imposed by {AccessControl}.
855      * ====
856      *
857      * NOTE: This function is deprecated in favor of {_grantRole}.
858      */
859     function _setupRole(bytes32 role, address account) internal virtual {
860         _grantRole(role, account);
861     }
862 
863     /**
864      * @dev Sets `adminRole` as ``role``'s admin role.
865      *
866      * Emits a {RoleAdminChanged} event.
867      */
868     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
869         bytes32 previousAdminRole = getRoleAdmin(role);
870         _roles[role].adminRole = adminRole;
871         emit RoleAdminChanged(role, previousAdminRole, adminRole);
872     }
873 
874     /**
875      * @dev Grants `role` to `account`.
876      *
877      * Internal function without access restriction.
878      *
879      * May emit a {RoleGranted} event.
880      */
881     function _grantRole(bytes32 role, address account) internal virtual {
882         if (!hasRole(role, account)) {
883             _roles[role].members[account] = true;
884             emit RoleGranted(role, account, _msgSender());
885         }
886     }
887 
888     /**
889      * @dev Revokes `role` from `account`.
890      *
891      * Internal function without access restriction.
892      *
893      * May emit a {RoleRevoked} event.
894      */
895     function _revokeRole(bytes32 role, address account) internal virtual {
896         if (hasRole(role, account)) {
897             _roles[role].members[account] = false;
898             emit RoleRevoked(role, account, _msgSender());
899         }
900     }
901 }
902 
903 // File: @openzeppelin/contracts/security/Pausable.sol
904 
905 
906 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 
911 /**
912  * @dev Contract module which allows children to implement an emergency stop
913  * mechanism that can be triggered by an authorized account.
914  *
915  * This module is used through inheritance. It will make available the
916  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
917  * the functions of your contract. Note that they will not be pausable by
918  * simply including this module, only once the modifiers are put in place.
919  */
920 abstract contract Pausable is Context {
921     /**
922      * @dev Emitted when the pause is triggered by `account`.
923      */
924     event Paused(address account);
925 
926     /**
927      * @dev Emitted when the pause is lifted by `account`.
928      */
929     event Unpaused(address account);
930 
931     bool private _paused;
932 
933     /**
934      * @dev Initializes the contract in unpaused state.
935      */
936     constructor() {
937         _paused = false;
938     }
939 
940     /**
941      * @dev Modifier to make a function callable only when the contract is not paused.
942      *
943      * Requirements:
944      *
945      * - The contract must not be paused.
946      */
947     modifier whenNotPaused() {
948         _requireNotPaused();
949         _;
950     }
951 
952     /**
953      * @dev Modifier to make a function callable only when the contract is paused.
954      *
955      * Requirements:
956      *
957      * - The contract must be paused.
958      */
959     modifier whenPaused() {
960         _requirePaused();
961         _;
962     }
963 
964     /**
965      * @dev Returns true if the contract is paused, and false otherwise.
966      */
967     function paused() public view virtual returns (bool) {
968         return _paused;
969     }
970 
971     /**
972      * @dev Throws if the contract is paused.
973      */
974     function _requireNotPaused() internal view virtual {
975         require(!paused(), "Pausable: paused");
976     }
977 
978     /**
979      * @dev Throws if the contract is not paused.
980      */
981     function _requirePaused() internal view virtual {
982         require(paused(), "Pausable: not paused");
983     }
984 
985     /**
986      * @dev Triggers stopped state.
987      *
988      * Requirements:
989      *
990      * - The contract must not be paused.
991      */
992     function _pause() internal virtual whenNotPaused {
993         _paused = true;
994         emit Paused(_msgSender());
995     }
996 
997     /**
998      * @dev Returns to normal state.
999      *
1000      * Requirements:
1001      *
1002      * - The contract must be paused.
1003      */
1004     function _unpause() internal virtual whenPaused {
1005         _paused = false;
1006         emit Unpaused(_msgSender());
1007     }
1008 }
1009 
1010 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1011 
1012 
1013 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 /**
1018  * @dev Interface of the ERC20 standard as defined in the EIP.
1019  */
1020 interface IERC20 {
1021     /**
1022      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1023      * another (`to`).
1024      *
1025      * Note that `value` may be zero.
1026      */
1027     event Transfer(address indexed from, address indexed to, uint256 value);
1028 
1029     /**
1030      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1031      * a call to {approve}. `value` is the new allowance.
1032      */
1033     event Approval(address indexed owner, address indexed spender, uint256 value);
1034 
1035     /**
1036      * @dev Returns the amount of tokens in existence.
1037      */
1038     function totalSupply() external view returns (uint256);
1039 
1040     /**
1041      * @dev Returns the amount of tokens owned by `account`.
1042      */
1043     function balanceOf(address account) external view returns (uint256);
1044 
1045     /**
1046      * @dev Moves `amount` tokens from the caller's account to `to`.
1047      *
1048      * Returns a boolean value indicating whether the operation succeeded.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function transfer(address to, uint256 amount) external returns (bool);
1053 
1054     /**
1055      * @dev Returns the remaining number of tokens that `spender` will be
1056      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1057      * zero by default.
1058      *
1059      * This value changes when {approve} or {transferFrom} are called.
1060      */
1061     function allowance(address owner, address spender) external view returns (uint256);
1062 
1063     /**
1064      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1065      *
1066      * Returns a boolean value indicating whether the operation succeeded.
1067      *
1068      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1069      * that someone may use both the old and the new allowance by unfortunate
1070      * transaction ordering. One possible solution to mitigate this race
1071      * condition is to first reduce the spender's allowance to 0 and set the
1072      * desired value afterwards:
1073      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1074      *
1075      * Emits an {Approval} event.
1076      */
1077     function approve(address spender, uint256 amount) external returns (bool);
1078 
1079     /**
1080      * @dev Moves `amount` tokens from `from` to `to` using the
1081      * allowance mechanism. `amount` is then deducted from the caller's
1082      * allowance.
1083      *
1084      * Returns a boolean value indicating whether the operation succeeded.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1089 }
1090 
1091 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1092 
1093 
1094 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1095 
1096 pragma solidity ^0.8.0;
1097 
1098 
1099 /**
1100  * @dev Interface for the optional metadata functions from the ERC20 standard.
1101  *
1102  * _Available since v4.1._
1103  */
1104 interface IERC20Metadata is IERC20 {
1105     /**
1106      * @dev Returns the name of the token.
1107      */
1108     function name() external view returns (string memory);
1109 
1110     /**
1111      * @dev Returns the symbol of the token.
1112      */
1113     function symbol() external view returns (string memory);
1114 
1115     /**
1116      * @dev Returns the decimals places of the token.
1117      */
1118     function decimals() external view returns (uint8);
1119 }
1120 
1121 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1122 
1123 
1124 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 
1129 
1130 
1131 /**
1132  * @dev Implementation of the {IERC20} interface.
1133  *
1134  * This implementation is agnostic to the way tokens are created. This means
1135  * that a supply mechanism has to be added in a derived contract using {_mint}.
1136  * For a generic mechanism see {ERC20PresetMinterPauser}.
1137  *
1138  * TIP: For a detailed writeup see our guide
1139  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1140  * to implement supply mechanisms].
1141  *
1142  * The default value of {decimals} is 18. To change this, you should override
1143  * this function so it returns a different value.
1144  *
1145  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1146  * instead returning `false` on failure. This behavior is nonetheless
1147  * conventional and does not conflict with the expectations of ERC20
1148  * applications.
1149  *
1150  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1151  * This allows applications to reconstruct the allowance for all accounts just
1152  * by listening to said events. Other implementations of the EIP may not emit
1153  * these events, as it isn't required by the specification.
1154  *
1155  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1156  * functions have been added to mitigate the well-known issues around setting
1157  * allowances. See {IERC20-approve}.
1158  */
1159 contract ERC20 is Context, IERC20, IERC20Metadata {
1160     mapping(address => uint256) private _balances;
1161 
1162     mapping(address => mapping(address => uint256)) private _allowances;
1163 
1164     uint256 private _totalSupply;
1165 
1166     string private _name;
1167     string private _symbol;
1168 
1169     /**
1170      * @dev Sets the values for {name} and {symbol}.
1171      *
1172      * All two of these values are immutable: they can only be set once during
1173      * construction.
1174      */
1175     constructor(string memory name_, string memory symbol_) {
1176         _name = name_;
1177         _symbol = symbol_;
1178     }
1179 
1180     /**
1181      * @dev Returns the name of the token.
1182      */
1183     function name() public view virtual override returns (string memory) {
1184         return _name;
1185     }
1186 
1187     /**
1188      * @dev Returns the symbol of the token, usually a shorter version of the
1189      * name.
1190      */
1191     function symbol() public view virtual override returns (string memory) {
1192         return _symbol;
1193     }
1194 
1195     /**
1196      * @dev Returns the number of decimals used to get its user representation.
1197      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1198      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1199      *
1200      * Tokens usually opt for a value of 18, imitating the relationship between
1201      * Ether and Wei. This is the default value returned by this function, unless
1202      * it's overridden.
1203      *
1204      * NOTE: This information is only used for _display_ purposes: it in
1205      * no way affects any of the arithmetic of the contract, including
1206      * {IERC20-balanceOf} and {IERC20-transfer}.
1207      */
1208     function decimals() public view virtual override returns (uint8) {
1209         return 18;
1210     }
1211 
1212     /**
1213      * @dev See {IERC20-totalSupply}.
1214      */
1215     function totalSupply() public view virtual override returns (uint256) {
1216         return _totalSupply;
1217     }
1218 
1219     /**
1220      * @dev See {IERC20-balanceOf}.
1221      */
1222     function balanceOf(address account) public view virtual override returns (uint256) {
1223         return _balances[account];
1224     }
1225 
1226     /**
1227      * @dev See {IERC20-transfer}.
1228      *
1229      * Requirements:
1230      *
1231      * - `to` cannot be the zero address.
1232      * - the caller must have a balance of at least `amount`.
1233      */
1234     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1235         address owner = _msgSender();
1236         _transfer(owner, to, amount);
1237         return true;
1238     }
1239 
1240     /**
1241      * @dev See {IERC20-allowance}.
1242      */
1243     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1244         return _allowances[owner][spender];
1245     }
1246 
1247     /**
1248      * @dev See {IERC20-approve}.
1249      *
1250      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1251      * `transferFrom`. This is semantically equivalent to an infinite approval.
1252      *
1253      * Requirements:
1254      *
1255      * - `spender` cannot be the zero address.
1256      */
1257     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1258         address owner = _msgSender();
1259         _approve(owner, spender, amount);
1260         return true;
1261     }
1262 
1263     /**
1264      * @dev See {IERC20-transferFrom}.
1265      *
1266      * Emits an {Approval} event indicating the updated allowance. This is not
1267      * required by the EIP. See the note at the beginning of {ERC20}.
1268      *
1269      * NOTE: Does not update the allowance if the current allowance
1270      * is the maximum `uint256`.
1271      *
1272      * Requirements:
1273      *
1274      * - `from` and `to` cannot be the zero address.
1275      * - `from` must have a balance of at least `amount`.
1276      * - the caller must have allowance for ``from``'s tokens of at least
1277      * `amount`.
1278      */
1279     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1280         address spender = _msgSender();
1281         _spendAllowance(from, spender, amount);
1282         _transfer(from, to, amount);
1283         return true;
1284     }
1285 
1286     /**
1287      * @dev Atomically increases the allowance granted to `spender` by the caller.
1288      *
1289      * This is an alternative to {approve} that can be used as a mitigation for
1290      * problems described in {IERC20-approve}.
1291      *
1292      * Emits an {Approval} event indicating the updated allowance.
1293      *
1294      * Requirements:
1295      *
1296      * - `spender` cannot be the zero address.
1297      */
1298     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1299         address owner = _msgSender();
1300         _approve(owner, spender, allowance(owner, spender) + addedValue);
1301         return true;
1302     }
1303 
1304     /**
1305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1306      *
1307      * This is an alternative to {approve} that can be used as a mitigation for
1308      * problems described in {IERC20-approve}.
1309      *
1310      * Emits an {Approval} event indicating the updated allowance.
1311      *
1312      * Requirements:
1313      *
1314      * - `spender` cannot be the zero address.
1315      * - `spender` must have allowance for the caller of at least
1316      * `subtractedValue`.
1317      */
1318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1319         address owner = _msgSender();
1320         uint256 currentAllowance = allowance(owner, spender);
1321         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1322         unchecked {
1323             _approve(owner, spender, currentAllowance - subtractedValue);
1324         }
1325 
1326         return true;
1327     }
1328 
1329     /**
1330      * @dev Moves `amount` of tokens from `from` to `to`.
1331      *
1332      * This internal function is equivalent to {transfer}, and can be used to
1333      * e.g. implement automatic token fees, slashing mechanisms, etc.
1334      *
1335      * Emits a {Transfer} event.
1336      *
1337      * Requirements:
1338      *
1339      * - `from` cannot be the zero address.
1340      * - `to` cannot be the zero address.
1341      * - `from` must have a balance of at least `amount`.
1342      */
1343     function _transfer(address from, address to, uint256 amount) internal virtual {
1344         require(from != address(0), "ERC20: transfer from the zero address");
1345         require(to != address(0), "ERC20: transfer to the zero address");
1346 
1347         _beforeTokenTransfer(from, to, amount);
1348 
1349         uint256 fromBalance = _balances[from];
1350         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1351         unchecked {
1352             _balances[from] = fromBalance - amount;
1353             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1354             // decrementing then incrementing.
1355             _balances[to] += amount;
1356         }
1357 
1358         emit Transfer(from, to, amount);
1359 
1360         _afterTokenTransfer(from, to, amount);
1361     }
1362 
1363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1364      * the total supply.
1365      *
1366      * Emits a {Transfer} event with `from` set to the zero address.
1367      *
1368      * Requirements:
1369      *
1370      * - `account` cannot be the zero address.
1371      */
1372     function _mint(address account, uint256 amount) internal virtual {
1373         require(account != address(0), "ERC20: mint to the zero address");
1374 
1375         _beforeTokenTransfer(address(0), account, amount);
1376 
1377         _totalSupply += amount;
1378         unchecked {
1379             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1380             _balances[account] += amount;
1381         }
1382         emit Transfer(address(0), account, amount);
1383 
1384         _afterTokenTransfer(address(0), account, amount);
1385     }
1386 
1387     /**
1388      * @dev Destroys `amount` tokens from `account`, reducing the
1389      * total supply.
1390      *
1391      * Emits a {Transfer} event with `to` set to the zero address.
1392      *
1393      * Requirements:
1394      *
1395      * - `account` cannot be the zero address.
1396      * - `account` must have at least `amount` tokens.
1397      */
1398     function _burn(address account, uint256 amount) internal virtual {
1399         require(account != address(0), "ERC20: burn from the zero address");
1400 
1401         _beforeTokenTransfer(account, address(0), amount);
1402 
1403         uint256 accountBalance = _balances[account];
1404         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1405         unchecked {
1406             _balances[account] = accountBalance - amount;
1407             // Overflow not possible: amount <= accountBalance <= totalSupply.
1408             _totalSupply -= amount;
1409         }
1410 
1411         emit Transfer(account, address(0), amount);
1412 
1413         _afterTokenTransfer(account, address(0), amount);
1414     }
1415 
1416     /**
1417      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1418      *
1419      * This internal function is equivalent to `approve`, and can be used to
1420      * e.g. set automatic allowances for certain subsystems, etc.
1421      *
1422      * Emits an {Approval} event.
1423      *
1424      * Requirements:
1425      *
1426      * - `owner` cannot be the zero address.
1427      * - `spender` cannot be the zero address.
1428      */
1429     function _approve(address owner, address spender, uint256 amount) internal virtual {
1430         require(owner != address(0), "ERC20: approve from the zero address");
1431         require(spender != address(0), "ERC20: approve to the zero address");
1432 
1433         _allowances[owner][spender] = amount;
1434         emit Approval(owner, spender, amount);
1435     }
1436 
1437     /**
1438      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1439      *
1440      * Does not update the allowance amount in case of infinite allowance.
1441      * Revert if not enough allowance is available.
1442      *
1443      * Might emit an {Approval} event.
1444      */
1445     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1446         uint256 currentAllowance = allowance(owner, spender);
1447         if (currentAllowance != type(uint256).max) {
1448             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1449             unchecked {
1450                 _approve(owner, spender, currentAllowance - amount);
1451             }
1452         }
1453     }
1454 
1455     /**
1456      * @dev Hook that is called before any transfer of tokens. This includes
1457      * minting and burning.
1458      *
1459      * Calling conditions:
1460      *
1461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1462      * will be transferred to `to`.
1463      * - when `from` is zero, `amount` tokens will be minted for `to`.
1464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1465      * - `from` and `to` are never both zero.
1466      *
1467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1468      */
1469     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1470 
1471     /**
1472      * @dev Hook that is called after any transfer of tokens. This includes
1473      * minting and burning.
1474      *
1475      * Calling conditions:
1476      *
1477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1478      * has been transferred to `to`.
1479      * - when `from` is zero, `amount` tokens have been minted for `to`.
1480      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1481      * - `from` and `to` are never both zero.
1482      *
1483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1484      */
1485     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1486 }
1487 
1488 // File: contracts/ERBB.sol
1489 
1490 
1491 
1492 pragma solidity ^0.8.4;
1493 
1494 
1495 
1496 
1497 contract ERBB is ERC20, Pausable, AccessControl {
1498     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1499     bytes32 public constant UNPAUSER_ROLE = keccak256("UNPAUSER_ROLE");
1500     bytes32 public constant SERVICE_ROLE = keccak256("SERVICE_ROLE");
1501 
1502     uint256 public maxSupply;
1503 
1504     constructor(address admin, address pauser, address unpauser, address service) ERC20("Exchange Request for Bitbon", "ERBB") {
1505         _grantRole(DEFAULT_ADMIN_ROLE, admin);
1506         _grantRole(PAUSER_ROLE, pauser);
1507         _grantRole(UNPAUSER_ROLE, unpauser);
1508         _grantRole(SERVICE_ROLE, service);
1509 
1510         maxSupply = 100000000 * 10**decimals();
1511     }
1512 
1513     function pause() public onlyRole(PAUSER_ROLE) {
1514         _pause();
1515     }
1516 
1517     function unpause() public onlyRole(UNPAUSER_ROLE) {
1518         _unpause();
1519     }
1520 
1521     function decimals() public pure override returns (uint8) {
1522         return 27;
1523     }
1524 
1525     function mint(address account, uint256 amount) external whenNotPaused onlyRole(SERVICE_ROLE) {
1526         require(
1527             totalSupply() + amount <= maxSupply,
1528             "mint amount exceeds max supply amount for token"
1529         );
1530         require(
1531             amount <= 10000 * 10**decimals(),
1532             "can't mint more than 10000 ERBB"
1533         );
1534 
1535         _mint(account, amount);
1536     }
1537 
1538     function burn(address account, uint256 amount) internal whenNotPaused {
1539         _burn(account, amount);
1540     }
1541 
1542     function transfer(address to, uint256 amount) public override whenNotPaused returns (bool) {
1543         if (to == address(this) || to == address(0)) {
1544             burn(msg.sender, amount);
1545             return true;
1546         }
1547 
1548         return super.transfer(to, amount);
1549     }
1550 }