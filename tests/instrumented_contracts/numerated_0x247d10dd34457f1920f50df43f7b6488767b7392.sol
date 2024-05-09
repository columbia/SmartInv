1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
106 
107 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
108 
109 /**
110  * @dev External interface of AccessControl declared to support ERC165 detection.
111  */
112 interface IAccessControl {
113     /**
114      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
115      *
116      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
117      * {RoleAdminChanged} not being emitted signaling this.
118      *
119      * _Available since v3.1._
120      */
121     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
122 
123     /**
124      * @dev Emitted when `account` is granted `role`.
125      *
126      * `sender` is the account that originated the contract call, an admin role
127      * bearer except when using {AccessControl-_setupRole}.
128      */
129     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
130 
131     /**
132      * @dev Emitted when `account` is revoked `role`.
133      *
134      * `sender` is the account that originated the contract call:
135      *   - if using `revokeRole`, it is the admin role bearer
136      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
137      */
138     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
139 
140     /**
141      * @dev Returns `true` if `account` has been granted `role`.
142      */
143     function hasRole(bytes32 role, address account) external view returns (bool);
144 
145     /**
146      * @dev Returns the admin role that controls `role`. See {grantRole} and
147      * {revokeRole}.
148      *
149      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
150      */
151     function getRoleAdmin(bytes32 role) external view returns (bytes32);
152 
153     /**
154      * @dev Grants `role` to `account`.
155      *
156      * If `account` had not been already granted `role`, emits a {RoleGranted}
157      * event.
158      *
159      * Requirements:
160      *
161      * - the caller must have ``role``'s admin role.
162      */
163     function grantRole(bytes32 role, address account) external;
164 
165     /**
166      * @dev Revokes `role` from `account`.
167      *
168      * If `account` had been granted `role`, emits a {RoleRevoked} event.
169      *
170      * Requirements:
171      *
172      * - the caller must have ``role``'s admin role.
173      */
174     function revokeRole(bytes32 role, address account) external;
175 
176     /**
177      * @dev Revokes `role` from the calling account.
178      *
179      * Roles are often managed via {grantRole} and {revokeRole}: this function's
180      * purpose is to provide a mechanism for accounts to lose their privileges
181      * if they are compromised (such as when a trusted device is misplaced).
182      *
183      * If the calling account had been granted `role`, emits a {RoleRevoked}
184      * event.
185      *
186      * Requirements:
187      *
188      * - the caller must be `account`.
189      */
190     function renounceRole(bytes32 role, address account) external;
191 }
192 
193 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
194 
195 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
196 
197 /**
198  * @dev Standard math utilities missing in the Solidity language.
199  */
200 library Math {
201     enum Rounding {
202         Down, // Toward negative infinity
203         Up, // Toward infinity
204         Zero // Toward zero
205     }
206 
207     /**
208      * @dev Returns the largest of two numbers.
209      */
210     function max(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a > b ? a : b;
212     }
213 
214     /**
215      * @dev Returns the smallest of two numbers.
216      */
217     function min(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a < b ? a : b;
219     }
220 
221     /**
222      * @dev Returns the average of two numbers. The result is rounded towards
223      * zero.
224      */
225     function average(uint256 a, uint256 b) internal pure returns (uint256) {
226         // (a + b) / 2 can overflow.
227         return (a & b) + (a ^ b) / 2;
228     }
229 
230     /**
231      * @dev Returns the ceiling of the division of two numbers.
232      *
233      * This differs from standard division with `/` in that it rounds up instead
234      * of rounding down.
235      */
236     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
237         // (a + b - 1) / b can overflow on addition, so we distribute.
238         return a == 0 ? 0 : (a - 1) / b + 1;
239     }
240 
241     /**
242      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
243      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
244      * with further edits by Uniswap Labs also under MIT license.
245      */
246     function mulDiv(
247         uint256 x,
248         uint256 y,
249         uint256 denominator
250     ) internal pure returns (uint256 result) {
251         unchecked {
252             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
253             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
254             // variables such that product = prod1 * 2^256 + prod0.
255             uint256 prod0; // Least significant 256 bits of the product
256             uint256 prod1; // Most significant 256 bits of the product
257             assembly {
258                 let mm := mulmod(x, y, not(0))
259                 prod0 := mul(x, y)
260                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
261             }
262 
263             // Handle non-overflow cases, 256 by 256 division.
264             if (prod1 == 0) {
265                 return prod0 / denominator;
266             }
267 
268             // Make sure the result is less than 2^256. Also prevents denominator == 0.
269             require(denominator > prod1);
270 
271             ///////////////////////////////////////////////
272             // 512 by 256 division.
273             ///////////////////////////////////////////////
274 
275             // Make division exact by subtracting the remainder from [prod1 prod0].
276             uint256 remainder;
277             assembly {
278                 // Compute remainder using mulmod.
279                 remainder := mulmod(x, y, denominator)
280 
281                 // Subtract 256 bit number from 512 bit number.
282                 prod1 := sub(prod1, gt(remainder, prod0))
283                 prod0 := sub(prod0, remainder)
284             }
285 
286             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
287             // See https://cs.stackexchange.com/q/138556/92363.
288 
289             // Does not overflow because the denominator cannot be zero at this stage in the function.
290             uint256 twos = denominator & (~denominator + 1);
291             assembly {
292                 // Divide denominator by twos.
293                 denominator := div(denominator, twos)
294 
295                 // Divide [prod1 prod0] by twos.
296                 prod0 := div(prod0, twos)
297 
298                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
299                 twos := add(div(sub(0, twos), twos), 1)
300             }
301 
302             // Shift in bits from prod1 into prod0.
303             prod0 |= prod1 * twos;
304 
305             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
306             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
307             // four bits. That is, denominator * inv = 1 mod 2^4.
308             uint256 inverse = (3 * denominator) ^ 2;
309 
310             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
311             // in modular arithmetic, doubling the correct bits in each step.
312             inverse *= 2 - denominator * inverse; // inverse mod 2^8
313             inverse *= 2 - denominator * inverse; // inverse mod 2^16
314             inverse *= 2 - denominator * inverse; // inverse mod 2^32
315             inverse *= 2 - denominator * inverse; // inverse mod 2^64
316             inverse *= 2 - denominator * inverse; // inverse mod 2^128
317             inverse *= 2 - denominator * inverse; // inverse mod 2^256
318 
319             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
320             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
321             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
322             // is no longer required.
323             result = prod0 * inverse;
324             return result;
325         }
326     }
327 
328     /**
329      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
330      */
331     function mulDiv(
332         uint256 x,
333         uint256 y,
334         uint256 denominator,
335         Rounding rounding
336     ) internal pure returns (uint256) {
337         uint256 result = mulDiv(x, y, denominator);
338         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
339             result += 1;
340         }
341         return result;
342     }
343 
344     /**
345      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
346      *
347      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
348      */
349     function sqrt(uint256 a) internal pure returns (uint256) {
350         if (a == 0) {
351             return 0;
352         }
353 
354         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
355         //
356         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
357         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
358         //
359         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
360         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
361         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
362         //
363         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
364         uint256 result = 1 << (log2(a) >> 1);
365 
366         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
367         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
368         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
369         // into the expected uint128 result.
370         unchecked {
371             result = (result + a / result) >> 1;
372             result = (result + a / result) >> 1;
373             result = (result + a / result) >> 1;
374             result = (result + a / result) >> 1;
375             result = (result + a / result) >> 1;
376             result = (result + a / result) >> 1;
377             result = (result + a / result) >> 1;
378             return min(result, a / result);
379         }
380     }
381 
382     /**
383      * @notice Calculates sqrt(a), following the selected rounding direction.
384      */
385     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
386         unchecked {
387             uint256 result = sqrt(a);
388             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
389         }
390     }
391 
392     /**
393      * @dev Return the log in base 2, rounded down, of a positive value.
394      * Returns 0 if given 0.
395      */
396     function log2(uint256 value) internal pure returns (uint256) {
397         uint256 result = 0;
398         unchecked {
399             if (value >> 128 > 0) {
400                 value >>= 128;
401                 result += 128;
402             }
403             if (value >> 64 > 0) {
404                 value >>= 64;
405                 result += 64;
406             }
407             if (value >> 32 > 0) {
408                 value >>= 32;
409                 result += 32;
410             }
411             if (value >> 16 > 0) {
412                 value >>= 16;
413                 result += 16;
414             }
415             if (value >> 8 > 0) {
416                 value >>= 8;
417                 result += 8;
418             }
419             if (value >> 4 > 0) {
420                 value >>= 4;
421                 result += 4;
422             }
423             if (value >> 2 > 0) {
424                 value >>= 2;
425                 result += 2;
426             }
427             if (value >> 1 > 0) {
428                 result += 1;
429             }
430         }
431         return result;
432     }
433 
434     /**
435      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
436      * Returns 0 if given 0.
437      */
438     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
439         unchecked {
440             uint256 result = log2(value);
441             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
442         }
443     }
444 
445     /**
446      * @dev Return the log in base 10, rounded down, of a positive value.
447      * Returns 0 if given 0.
448      */
449     function log10(uint256 value) internal pure returns (uint256) {
450         uint256 result = 0;
451         unchecked {
452             if (value >= 10**64) {
453                 value /= 10**64;
454                 result += 64;
455             }
456             if (value >= 10**32) {
457                 value /= 10**32;
458                 result += 32;
459             }
460             if (value >= 10**16) {
461                 value /= 10**16;
462                 result += 16;
463             }
464             if (value >= 10**8) {
465                 value /= 10**8;
466                 result += 8;
467             }
468             if (value >= 10**4) {
469                 value /= 10**4;
470                 result += 4;
471             }
472             if (value >= 10**2) {
473                 value /= 10**2;
474                 result += 2;
475             }
476             if (value >= 10**1) {
477                 result += 1;
478             }
479         }
480         return result;
481     }
482 
483     /**
484      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
485      * Returns 0 if given 0.
486      */
487     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
488         unchecked {
489             uint256 result = log10(value);
490             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
491         }
492     }
493 
494     /**
495      * @dev Return the log in base 256, rounded down, of a positive value.
496      * Returns 0 if given 0.
497      *
498      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
499      */
500     function log256(uint256 value) internal pure returns (uint256) {
501         uint256 result = 0;
502         unchecked {
503             if (value >> 128 > 0) {
504                 value >>= 128;
505                 result += 16;
506             }
507             if (value >> 64 > 0) {
508                 value >>= 64;
509                 result += 8;
510             }
511             if (value >> 32 > 0) {
512                 value >>= 32;
513                 result += 4;
514             }
515             if (value >> 16 > 0) {
516                 value >>= 16;
517                 result += 2;
518             }
519             if (value >> 8 > 0) {
520                 result += 1;
521             }
522         }
523         return result;
524     }
525 
526     /**
527      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
528      * Returns 0 if given 0.
529      */
530     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
531         unchecked {
532             uint256 result = log256(value);
533             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
534         }
535     }
536 }
537 
538 library Strings {
539     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
540     uint8 private constant _ADDRESS_LENGTH = 20;
541 
542     /**
543      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
544      */
545     function toString(uint256 value) internal pure returns (string memory) {
546         // Inspired by OraclizeAPI's implementation - MIT licence
547         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
548 
549         if (value == 0) {
550             return "0";
551         }
552         uint256 temp = value;
553         uint256 digits;
554         while (temp != 0) {
555             digits++;
556             temp /= 10;
557         }
558         bytes memory buffer = new bytes(digits);
559         while (value != 0) {
560             digits -= 1;
561             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
562             value /= 10;
563         }
564         return string(buffer);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
569      */
570     function toHexString(uint256 value) internal pure returns (string memory) {
571         if (value == 0) {
572             return "0x00";
573         }
574         uint256 temp = value;
575         uint256 length = 0;
576         while (temp != 0) {
577             length++;
578             temp >>= 8;
579         }
580         return toHexString(value, length);
581     }
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
585      */
586     function toHexString(uint256 value, uint256 length)
587         internal
588         pure
589         returns (string memory)
590     {
591         bytes memory buffer = new bytes(2 * length + 2);
592         buffer[0] = "0";
593         buffer[1] = "x";
594         for (uint256 i = 2 * length + 1; i > 1; --i) {
595             buffer[i] = _HEX_SYMBOLS[value & 0xf];
596             value >>= 4;
597         }
598         require(value == 0, "Strings: hex length insufficient");
599         return string(buffer);
600     }
601 
602     /**
603      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
604      */
605     function toHexString(address addr) internal pure returns (string memory) {
606         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
607     }
608 }
609 
610 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
611 
612 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
613 
614 /**
615  * @dev Interface of the ERC165 standard, as defined in the
616  * https://eips.ethereum.org/EIPS/eip-165[EIP].
617  *
618  * Implementers can declare support of contract interfaces, which can then be
619  * queried by others ({ERC165Checker}).
620  *
621  * For an implementation, see {ERC165}.
622  */
623 interface IERC165 {
624     /**
625      * @dev Returns true if this contract implements the interface defined by
626      * `interfaceId`. See the corresponding
627      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
628      * to learn more about how these ids are created.
629      *
630      * This function call must use less than 30 000 gas.
631      */
632     function supportsInterface(bytes4 interfaceId) external view returns (bool);
633 }
634 
635 /**
636  * @dev Implementation of the {IERC165} interface.
637  *
638  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
639  * for the additional interface id that will be supported. For example:
640  *
641  * ```solidity
642  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
643  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
644  * }
645  * ```
646  *
647  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
648  */
649 abstract contract ERC165 is IERC165 {
650     /**
651      * @dev See {IERC165-supportsInterface}.
652      */
653     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
654         return interfaceId == type(IERC165).interfaceId;
655     }
656 }
657 
658 /**
659  * @dev Contract module that allows children to implement role-based access
660  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
661  * members except through off-chain means by accessing the contract event logs. Some
662  * applications may benefit from on-chain enumerability, for those cases see
663  * {AccessControlEnumerable}.
664  *
665  * Roles are referred to by their `bytes32` identifier. These should be exposed
666  * in the external API and be unique. The best way to achieve this is by
667  * using `public constant` hash digests:
668  *
669  * ```
670  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
671  * ```
672  *
673  * Roles can be used to represent a set of permissions. To restrict access to a
674  * function call, use {hasRole}:
675  *
676  * ```
677  * function foo() public {
678  *     require(hasRole(MY_ROLE, msg.sender));
679  *     ...
680  * }
681  * ```
682  *
683  * Roles can be granted and revoked dynamically via the {grantRole} and
684  * {revokeRole} functions. Each role has an associated admin role, and only
685  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
686  *
687  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
688  * that only accounts with this role will be able to grant or revoke other
689  * roles. More complex role relationships can be created by using
690  * {_setRoleAdmin}.
691  *
692  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
693  * grant and revoke this role. Extra precautions should be taken to secure
694  * accounts that have been granted it.
695  */
696 abstract contract AccessControl is Context, IAccessControl, ERC165 {
697     struct RoleData {
698         mapping(address => bool) members;
699         bytes32 adminRole;
700     }
701 
702     mapping(bytes32 => RoleData) private _roles;
703 
704     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
705 
706     /**
707      * @dev Modifier that checks that an account has a specific role. Reverts
708      * with a standardized message including the required role.
709      *
710      * The format of the revert reason is given by the following regular expression:
711      *
712      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
713      *
714      * _Available since v4.1._
715      */
716     modifier onlyRole(bytes32 role) {
717         _checkRole(role);
718         _;
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
725         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
726     }
727 
728     /**
729      * @dev Returns `true` if `account` has been granted `role`.
730      */
731     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
732         return _roles[role].members[account];
733     }
734 
735     /**
736      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
737      * Overriding this function changes the behavior of the {onlyRole} modifier.
738      *
739      * Format of the revert message is described in {_checkRole}.
740      *
741      * _Available since v4.6._
742      */
743     function _checkRole(bytes32 role) internal view virtual {
744         _checkRole(role, _msgSender());
745     }
746 
747     /**
748      * @dev Revert with a standard message if `account` is missing `role`.
749      *
750      * The format of the revert reason is given by the following regular expression:
751      *
752      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
753      */
754     function _checkRole(bytes32 role, address account) internal view virtual {
755         if (!hasRole(role, account)) {
756             revert(
757                 string(
758                     abi.encodePacked(
759                         "AccessControl: account ",
760                         Strings.toHexString(account),
761                         " is missing role ",
762                         Strings.toHexString(uint256(role), 32)
763                     )
764                 )
765             );
766         }
767     }
768 
769     /**
770      * @dev Returns the admin role that controls `role`. See {grantRole} and
771      * {revokeRole}.
772      *
773      * To change a role's admin, use {_setRoleAdmin}.
774      */
775     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
776         return _roles[role].adminRole;
777     }
778 
779     /**
780      * @dev Grants `role` to `account`.
781      *
782      * If `account` had not been already granted `role`, emits a {RoleGranted}
783      * event.
784      *
785      * Requirements:
786      *
787      * - the caller must have ``role``'s admin role.
788      *
789      * May emit a {RoleGranted} event.
790      */
791     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
792         _grantRole(role, account);
793     }
794 
795     /**
796      * @dev Revokes `role` from `account`.
797      *
798      * If `account` had been granted `role`, emits a {RoleRevoked} event.
799      *
800      * Requirements:
801      *
802      * - the caller must have ``role``'s admin role.
803      *
804      * May emit a {RoleRevoked} event.
805      */
806     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
807         _revokeRole(role, account);
808     }
809 
810     /**
811      * @dev Revokes `role` from the calling account.
812      *
813      * Roles are often managed via {grantRole} and {revokeRole}: this function's
814      * purpose is to provide a mechanism for accounts to lose their privileges
815      * if they are compromised (such as when a trusted device is misplaced).
816      *
817      * If the calling account had been revoked `role`, emits a {RoleRevoked}
818      * event.
819      *
820      * Requirements:
821      *
822      * - the caller must be `account`.
823      *
824      * May emit a {RoleRevoked} event.
825      */
826     function renounceRole(bytes32 role, address account) public virtual override {
827         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
828 
829         _revokeRole(role, account);
830     }
831 
832     /**
833      * @dev Grants `role` to `account`.
834      *
835      * If `account` had not been already granted `role`, emits a {RoleGranted}
836      * event. Note that unlike {grantRole}, this function doesn't perform any
837      * checks on the calling account.
838      *
839      * May emit a {RoleGranted} event.
840      *
841      * [WARNING]
842      * ====
843      * This function should only be called from the constructor when setting
844      * up the initial roles for the system.
845      *
846      * Using this function in any other way is effectively circumventing the admin
847      * system imposed by {AccessControl}.
848      * ====
849      *
850      * NOTE: This function is deprecated in favor of {_grantRole}.
851      */
852     function _setupRole(bytes32 role, address account) internal virtual {
853         _grantRole(role, account);
854     }
855 
856     /**
857      * @dev Sets `adminRole` as ``role``'s admin role.
858      *
859      * Emits a {RoleAdminChanged} event.
860      */
861     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
862         bytes32 previousAdminRole = getRoleAdmin(role);
863         _roles[role].adminRole = adminRole;
864         emit RoleAdminChanged(role, previousAdminRole, adminRole);
865     }
866 
867     /**
868      * @dev Grants `role` to `account`.
869      *
870      * Internal function without access restriction.
871      *
872      * May emit a {RoleGranted} event.
873      */
874     function _grantRole(bytes32 role, address account) internal virtual {
875         if (!hasRole(role, account)) {
876             _roles[role].members[account] = true;
877             emit RoleGranted(role, account, _msgSender());
878         }
879     }
880 
881     /**
882      * @dev Revokes `role` from `account`.
883      *
884      * Internal function without access restriction.
885      *
886      * May emit a {RoleRevoked} event.
887      */
888     function _revokeRole(bytes32 role, address account) internal virtual {
889         if (hasRole(role, account)) {
890             _roles[role].members[account] = false;
891             emit RoleRevoked(role, account, _msgSender());
892         }
893     }
894 }
895 
896 interface IBatchERC721 {
897     error InvalidApprovalZeroAddress();
898     error CallerNotOwnerOrApprovedOperator();
899     error TransferToNonERC721ReceiverImplementer();
900     error InvalidTransferToZeroAddress();
901     error MintZeroTokenId();
902     error TokenNotOwnedByFromAddress();
903     error QueryNonExistentToken();
904     error QueryBalanceOfZeroAddress();
905     error QueryBurnedToken();
906 }
907 
908 // https://eips.ethereum.org/EIPS/eip-721, http://erc721.org/
909 
910 
911 /// @title ERC-721 Non-Fungible Token Standard
912 /// @dev See https://eips.ethereum.org/EIPS/eip-721
913 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
914 interface IERC721 /* is ERC165 */ {
915     /// @dev This emits when ownership of any NFT changes by any mechanism.
916     ///  This event emits when NFTs are created (`from` == 0) and destroyed
917     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
918     ///  may be created and assigned without emitting Transfer. At the time of
919     ///  any transfer, the approved address for that NFT (if any) is reset to none.
920     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
921 
922     /// @dev This emits when the approved address for an NFT is changed or
923     ///  reaffirmed. The zero address indicates there is no approved address.
924     ///  When a Transfer event emits, this also indicates that the approved
925     ///  address for that NFT (if any) is reset to none.
926     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
927 
928     /// @dev This emits when an operator is enabled or disabled for an owner.
929     ///  The operator can manage all NFTs of the owner.
930     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
931 
932     /// @notice Transfers the ownership of an NFT from one address to another address
933     /// @dev Throws unless `msg.sender` is the current owner, an authorized
934     ///  operator, or the approved address for this NFT. Throws if `_from` is
935     ///  not the current owner. Throws if `_to` is the zero address. Throws if
936     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
937     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
938     ///  `onERC721Received` on `_to` and throws if the return value is not
939     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
940     /// @param _from The current owner of the NFT
941     /// @param _to The new owner
942     /// @param _tokenId The NFT to transfer
943     /// @param data Additional data with no specified format, sent in call to `_to`
944     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external;
945 
946     /// @notice Transfers the ownership of an NFT from one address to another address
947     /// @dev This works identically to the other function with an extra data parameter,
948     ///  except this function just sets data to "".
949     /// @param _from The current owner of the NFT
950     /// @param _to The new owner
951     /// @param _tokenId The NFT to transfer
952     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
953 
954     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
955     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
956     ///  THEY MAY BE PERMANENTLY LOST
957     /// @dev Throws unless `msg.sender` is the current owner, an authorized
958     ///  operator, or the approved address for this NFT. Throws if `_from` is
959     ///  not the current owner. Throws if `_to` is the zero address. Throws if
960     ///  `_tokenId` is not a valid NFT.
961     /// @param _from The current owner of the NFT
962     /// @param _to The new owner
963     /// @param _tokenId The NFT to transfer
964     function transferFrom(address _from, address _to, uint256 _tokenId) external;
965 
966     /// @notice Change or reaffirm the approved address for an NFT
967     /// @dev The zero address indicates there is no approved address.
968     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
969     ///  operator of the current owner.
970     /// @param _approved The new approved NFT controller
971     /// @param _tokenId The NFT to approve
972     function approve(address _approved, uint256 _tokenId) external;
973 
974     /// @notice Enable or disable approval for a third party ("operator") to manage
975     ///  all of `msg.sender`'s assets
976     /// @dev Emits the ApprovalForAll event. The contract MUST allow
977     ///  multiple operators per owner.
978     /// @param _operator Address to add to the set of authorized operators
979     /// @param _approved True if the operator is approved, false to revoke approval
980     function setApprovalForAll(address _operator, bool _approved) external;
981 
982     /// @notice Count all NFTs assigned to an owner
983     /// @dev NFTs assigned to the zero address are considered invalid, and this
984     ///  function throws for queries about the zero address.
985     /// @param _owner An address for whom to query the balance
986     /// @return The number of NFTs owned by `_owner`, possibly zero
987     function balanceOf(address _owner) external view returns (uint256);
988 
989     /// @notice Find the owner of an NFT
990     /// @dev NFTs assigned to zero address are considered invalid, and queries
991     ///  about them do throw.
992     /// @param _tokenId The identifier for an NFT
993     /// @return The address of the owner of the NFT
994     function ownerOf(uint256 _tokenId) external view returns (address);
995 
996     /// @notice Get the approved address for a single NFT
997     /// @dev Throws if `_tokenId` is not a valid NFT.
998     /// @param _tokenId The NFT to find the approved address for
999     /// @return The approved address for this NFT, or the zero address if there is none
1000     function getApproved(uint256 _tokenId) external view returns (address);
1001 
1002     /// @notice Query if an address is an authorized operator for another address
1003     /// @param _owner The address that owns the NFTs
1004     /// @param _operator The address that acts on behalf of the owner
1005     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
1006     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
1007 }
1008 
1009 interface IERC2309 {
1010     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
1011 }
1012 
1013 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
1014 interface IERC721Receiver {
1015     /// @notice Handle the receipt of an NFT
1016     /// @dev The ERC721 smart contract calls this function on the recipient
1017     ///  after a `transfer`. This function MAY throw to revert and reject the
1018     ///  transfer. Return of other than the magic value MUST result in the
1019     ///  transaction being reverted.
1020     ///  Note: the contract address is always the message sender.
1021     /// @param _operator The address which called `safeTransferFrom` function
1022     /// @param _from The address which previously owned the token
1023     /// @param _tokenId The NFT identifier which is being transferred
1024     /// @param _data Additional data with no specified format
1025     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1026     ///  unless throwing
1027     function onERC721Received(
1028         address _operator,
1029         address _from,
1030         uint256 _tokenId,
1031         bytes calldata _data
1032     )
1033         external
1034         returns (bytes4);
1035 }
1036 
1037 contract BatchERC721 is IERC165, IERC721, IERC2309, IBatchERC721 {
1038     bytes4 private constant ERC165_INTERFACE_ID = 0x01ffc9a7;
1039     bytes4 private constant ERC721_INTERFACE_ID = 0x80ac58cd;
1040     bytes4 private constant ERC721_RECEIVER_INTERFACE_ID = 0x150b7a02;
1041     bytes4 private constant ERC721_METADATA_INTERFACE_ID = 0x5b5e139f;
1042 
1043     string public baseURI;
1044     string internal uriExtension;
1045     string private _name;
1046     string private _symbol;
1047 
1048     uint256 private nextTokenId;
1049     uint256 private startingTokenId;
1050     uint256 private burnCounter;
1051 
1052     mapping(uint256 => address) private tokenOwnersOrdered;
1053     mapping(uint256 => bool) private unorderedOwner;
1054     mapping(uint256 => address) private tokenOwners;
1055     mapping(uint256 => address) private tokenOperators;
1056     mapping(uint256 => bool) private burnedTokens;
1057     mapping(address => uint256) private balances;
1058     mapping(address => mapping(address => bool)) private operators;
1059 
1060     constructor(
1061         string memory name_,
1062         string memory symbol_,
1063         uint256 startingTokenId_
1064     ) {
1065         _name = name_;
1066         _symbol = symbol_;
1067         nextTokenId = startingTokenId = startingTokenId_;
1068     }
1069 
1070     /// @notice Change or reaffirm the approved address for an NFT
1071     /// @dev The zero address indicates there is no approved address.
1072     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
1073     ///  operator of the current owner.
1074     /// @param _approved The new approved NFT controller
1075     /// @param _tokenId The NFT to approve
1076     function approve(address _approved, uint256 _tokenId) external {
1077         _beforeSetApproval(_approved, true);
1078         if (_approved == address(0)) revert InvalidApprovalZeroAddress();
1079         address owner = ownerOf(_tokenId);
1080         if (
1081             owner != msg.sender &&
1082             !operators[msg.sender][_approved] &&
1083             tokenOperators[_tokenId] != msg.sender
1084         ) revert CallerNotOwnerOrApprovedOperator();
1085 
1086         if (!unorderedOwner[_tokenId]) {
1087             tokenOwners[_tokenId] = owner;
1088             unorderedOwner[_tokenId] = true;
1089         }
1090         tokenOperators[_tokenId] = _approved;
1091 
1092         emit Approval(msg.sender, _approved, _tokenId);
1093         _afterSetApproval(_approved, true);
1094     }
1095 
1096     /// @notice Enable or disable approval for a third party ("operator") to manage
1097     ///  all of `msg.sender`'s assets
1098     /// @dev Emits the ApprovalForAll event. The contract MUST allow
1099     ///  multiple operators per owner.
1100     /// @param _operator Address to add to the set of authorized operators
1101     /// @param _approved True if the operator is approved, false to revoke approval
1102     function setApprovalForAll(address _operator, bool _approved) external {
1103         _beforeSetApproval(_operator, _approved);
1104         operators[msg.sender][_operator] = _approved;
1105 
1106         emit ApprovalForAll(msg.sender, _operator, _approved);
1107         _afterSetApproval(_operator, _approved);
1108     }
1109 
1110     /// @notice Get the approved address for a single NFT
1111     /// @dev Throws if `_tokenId` is not a valid NFT.
1112     /// @param _tokenId The NFT to find the approved address for
1113     /// @return The approved address for this NFT, or the zero address if there is none
1114     function getApproved(uint256 _tokenId) external view returns (address) {
1115         return ownerOf(_tokenId);
1116     }
1117 
1118     /// @notice Query if an address is an authorized operator for another address
1119     /// @param _owner The address that owns the NFTs
1120     /// @param _operator The address that acts on behalf of the owner
1121     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
1122     function isApprovedForAll(address _owner, address _operator)
1123         external
1124         view
1125         returns (bool)
1126     {
1127         return operators[_owner][_operator];
1128     }
1129 
1130     /// @notice Name for NFTs in this contract
1131     function name() external view returns (string memory) {
1132         return _name;
1133     }
1134 
1135     /// @notice An abbreviated name for NFTs in this contract
1136     function symbol() external view returns (string memory) {
1137         return _symbol;
1138     }
1139 
1140     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1141     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
1142     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
1143     ///  Metadata JSON Schema".
1144     function tokenURI(uint256 _tokenId)
1145         external
1146         view
1147         virtual
1148         returns (string memory)
1149     {
1150         if (_tokenId < startingTokenId || _tokenId > nextTokenId - 1)
1151             revert QueryNonExistentToken();
1152         return
1153             bytes(baseURI).length > 0
1154                 ? string.concat(
1155                     baseURI,
1156                     Strings.toString(_tokenId),
1157                     uriExtension
1158                 )
1159                 : "";
1160     }
1161 
1162     /// @notice Count NFTs tracked by this contract
1163     /// @return A count of valid NFTs tracked by this contract, where each one of
1164     ///  them has an assigned and queryable owner not equal to the zero address
1165     function totalSupply() external view returns (uint256) {
1166         return nextTokenId - startingTokenId - burnCounter;
1167     }
1168 
1169     /// @notice Count all NFTs assigned to an owner
1170     /// @dev NFTs assigned to the zero address are considered invalid, and this
1171     ///  function throws for queries about the zero address.
1172     /// @param _owner An address for whom to query the balance
1173     /// @return The number of NFTs owned by `_owner`, possibly zero
1174     function balanceOf(address _owner) external view returns (uint256) {
1175         if (_owner == address(0)) revert QueryBalanceOfZeroAddress();
1176         return balances[_owner];
1177     }
1178 
1179     /// @notice Verify whether a token exists and has not been burned
1180     /// @param _tokenId The token id
1181     /// @return bool
1182     function exists(uint256 _tokenId) external view returns (bool) {
1183         return
1184             _tokenId >= startingTokenId &&
1185             _tokenId < nextTokenId &&
1186             !burnedTokens[_tokenId];
1187     }
1188 
1189     /// @notice Transfers the ownership of an NFT from one address to another address
1190     /// @dev This works identically to the other function with an extra data parameter,
1191     ///  except this function just sets data to "".
1192     /// @param _from The current owner of the NFT
1193     /// @param _to The new owner
1194     /// @param _tokenId The NFT to transfer
1195     function safeTransferFrom(
1196         address _from,
1197         address _to,
1198         uint256 _tokenId
1199     ) public {
1200         safeTransferFrom(_from, _to, _tokenId, "");
1201     }
1202 
1203     /// @notice Transfers the ownership of an NFT from one address to another address
1204     /// @dev Throws unless `msg.sender` is the current owner, an authorized
1205     ///  operator, or the approved address for this NFT. Throws if `_from` is
1206     ///  not the current owner. Throws if `_to` is the zero address. Throws if
1207     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
1208     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
1209     ///  `onERC721Received` on `_to` and throws if the return value is not
1210     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
1211     /// @param _from The current owner of the NFT
1212     /// @param _to The new owner
1213     /// @param _tokenId The NFT to transfer
1214     /// @param data Additional data with no specified format, sent in call to `_to`
1215     function safeTransferFrom(
1216         address _from,
1217         address _to,
1218         uint256 _tokenId,
1219         bytes memory data
1220     ) public {
1221         transferFrom(_from, _to, _tokenId);
1222         if (_to.code.length > 0) {
1223             _checkERC721Received(_from, _to, _tokenId, data);
1224         }
1225     }
1226 
1227     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
1228     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
1229     ///  THEY MAY BE PERMANENTLY LOST
1230     /// @dev Throws unless `msg.sender` is the current owner, an authorized
1231     ///  operator, or the approved address for this NFT. Throws if `_from` is
1232     ///  not the current owner. Throws if `_to` is the zero address. Throws if
1233     ///  `_tokenId` is not a valid NFT.
1234     /// @param _from The current owner of the NFT
1235     /// @param _to The new owner
1236     /// @param _tokenId The NFT to transfer
1237     function transferFrom(
1238         address _from,
1239         address _to,
1240         uint256 _tokenId
1241     ) public {
1242         if (_tokenId < startingTokenId || _tokenId > nextTokenId - 1)
1243             revert QueryNonExistentToken();
1244         address owner = ownerOf(_tokenId);
1245 
1246         if (owner != _from) revert TokenNotOwnedByFromAddress();
1247         if (
1248             owner != msg.sender &&
1249             !operators[_from][msg.sender] &&
1250             tokenOperators[_tokenId] != msg.sender
1251         ) revert CallerNotOwnerOrApprovedOperator();
1252         if (_to == address(0)) revert InvalidTransferToZeroAddress();
1253 
1254         _beforeTokenTransfer(_from, _to, _tokenId);
1255 
1256         balances[_from] -= 1;
1257         balances[_to] += 1;
1258 
1259         tokenOperators[_tokenId] = address(0);
1260         tokenOwners[_tokenId] = _to;
1261         unorderedOwner[_tokenId] = true;
1262 
1263         emit Transfer(_from, _to, _tokenId);
1264 
1265         _afterTokenTransfer(_from, _to, _tokenId);
1266     }
1267 
1268     /// @notice Find the owner of an NFT
1269     /// @dev NFTs assigned to zero address are considered invalid, and queries
1270     ///  about them do throw.
1271     /// @param _tokenId The identifier for an NFT
1272     /// @return The address of the owner of the NFT
1273     function ownerOf(uint256 _tokenId) public view returns (address) {
1274         if (_tokenId < startingTokenId || _tokenId > nextTokenId)
1275             revert QueryNonExistentToken();
1276         if (burnedTokens[_tokenId]) revert QueryBurnedToken();
1277         return
1278             unorderedOwner[_tokenId]
1279                 ? tokenOwners[_tokenId]
1280                 : _ownerOf(_tokenId);
1281     }
1282 
1283     /**
1284      * @dev See {IERC165-supportsInterface}.
1285      */
1286     function supportsInterface(bytes4 interfaceId)
1287         public
1288         view
1289         virtual
1290         returns (bool)
1291     {
1292         return
1293             interfaceId == ERC165_INTERFACE_ID ||
1294             interfaceId == ERC721_INTERFACE_ID ||
1295             interfaceId == ERC721_RECEIVER_INTERFACE_ID ||
1296             interfaceId == ERC721_METADATA_INTERFACE_ID;
1297     }
1298 
1299     /// @notice Find the owner of an NFT
1300     /// @dev Does not revert if token is burned, this is used to query via multi-call
1301     /// @param _tokenId The identifier for an NFT
1302     /// @return The address of the owner of the NFT
1303     function unsafeOwnerOf(uint256 _tokenId) public view returns (address) {
1304         if (burnedTokens[_tokenId]) return address(0);
1305         return
1306             unorderedOwner[_tokenId]
1307                 ? tokenOwners[_tokenId]
1308                 : _ownerOf(_tokenId);
1309     }
1310 
1311     function _mint2309(address _to, uint256 _quantity) internal {
1312         if (_to == address(0)) revert InvalidTransferToZeroAddress();
1313         if (_quantity == 0) revert MintZeroTokenId();
1314         unchecked {
1315             balances[_to] += _quantity;
1316             uint256 newTotal = nextTokenId + _quantity;
1317 
1318             tokenOwnersOrdered[nextTokenId] = _to;
1319             nextTokenId = newTotal;
1320         }
1321 
1322         emit ConsecutiveTransfer(
1323             startingTokenId,
1324             nextTokenId - 1,
1325             address(0),
1326             _to
1327         );
1328     }
1329 
1330     /// @notice Same as calling {_mint} and then checking for IERC721Receiver
1331     function safeMint(address _to, uint256 _quantity) internal {
1332         safeMint(_to, _quantity, "");
1333     }
1334 
1335     /// @notice Same as calling {_mint} and then checking for IERC721Receiver
1336     function safeMint(
1337         address _to,
1338         uint256 _quantity,
1339         bytes memory _data
1340     ) internal {
1341         _mint(_to, _quantity);
1342         uint256 currentTokenId = nextTokenId - 1;
1343         unchecked {
1344             if (_to.code.length != 0) {
1345                 uint256 tokenId = nextTokenId - _quantity - 1;
1346                 do {
1347                     if (
1348                         !_checkERC721Received(address(0), _to, ++tokenId, _data)
1349                     ) {
1350                         revert TransferToNonERC721ReceiverImplementer();
1351                     }
1352                 } while (tokenId < currentTokenId);
1353             }
1354         }
1355     }
1356 
1357     /// @notice Mint a quantity of NFTs to an address
1358     /// @dev Saves the first token id minted by the address to a map of
1359     ///      used to verify ownership initially.
1360     ///      {tokenOwnersOrdered} will be used to find the owner unless the token
1361     ///      has been transfered. In that case, it will be available in {tokenOwners} instead.
1362     ///      This is done to reduce gas requirements of minting while keeping on-chain lookups
1363     ///      cheaper as tokens are transfered around. It helps with the burning of tokens.
1364     /// @param _to Receiver address
1365     /// @param _quantity The quantity to be minted
1366     function _mint(address _to, uint256 _quantity) internal {
1367         if (_to == address(0)) revert InvalidTransferToZeroAddress();
1368         if (_quantity == 0) revert MintZeroTokenId();
1369         unchecked {
1370             balances[_to] += _quantity;
1371             uint256 newTotal = nextTokenId + _quantity;
1372 
1373             for (uint256 i = nextTokenId; i < newTotal; i++) {
1374                 emit Transfer(address(0), _to, i);
1375             }
1376 
1377             tokenOwnersOrdered[nextTokenId] = _to;
1378             nextTokenId = newTotal;
1379         }
1380     }
1381 
1382     /// @notice Same as calling {_burn} without a from address or approval check
1383     function _burn(uint256 _tokenId) internal {
1384         _burn(_tokenId, msg.sender);
1385     }
1386 
1387     /// @notice Same as calling {_burn} without approval check
1388     function _burn(uint256 _tokenId, address _from) internal {
1389         _burn(_tokenId, _from, false);
1390     }
1391 
1392     /// @notice Burn an NFT
1393     /// @dev Checks ownership of the token
1394     /// @param _tokenId The token id
1395     /// @param _from The owner address
1396     /// @param _approvalCheck Check if the caller is owner or an approved operator
1397     function _burn(
1398         uint256 _tokenId,
1399         address _from,
1400         bool _approvalCheck
1401     ) internal {
1402         if (_tokenId < startingTokenId || _tokenId > nextTokenId - 1)
1403             revert QueryNonExistentToken();
1404         address owner = ownerOf(_tokenId);
1405         if (owner != _from) revert TokenNotOwnedByFromAddress();
1406         if (_approvalCheck) {
1407             if (
1408                 owner != msg.sender &&
1409                 !operators[_from][msg.sender] &&
1410                 tokenOperators[_tokenId] != msg.sender
1411             ) revert CallerNotOwnerOrApprovedOperator();
1412         }
1413 
1414         balances[_from]--;
1415         burnCounter++;
1416         burnedTokens[_tokenId] = true;
1417 
1418         tokenOperators[_tokenId] = address(0);
1419 
1420         emit Transfer(_from, address(0), _tokenId);
1421     }
1422 
1423     /// @notice Before Approval Hook
1424     /// @param _operator Operator
1425     /// @param _approved Approved
1426     /* solhint-disable no-empty-blocks */
1427     function _beforeSetApproval(address _operator, bool _approved)
1428         internal
1429         virtual
1430     {}
1431 
1432     /* solhint-disable no-empty-blocks */
1433 
1434     /// @notice Before Approval Hook
1435     /// @param _operator Operator
1436     /// @param _approved Approved
1437     /* solhint-disable no-empty-blocks */
1438     function _afterSetApproval(address _operator, bool _approved)
1439         internal
1440         virtual
1441     {}
1442 
1443     /* solhint-disable no-empty-blocks */
1444 
1445     /// @notice Before Token Transfer Hook
1446     /// @param from Token owner
1447     /// @param to Receiver
1448     /// @param tokenId The token id
1449     /* solhint-disable no-empty-blocks */
1450     function _beforeTokenTransfer(
1451         address from,
1452         address to,
1453         uint256 tokenId
1454     ) internal virtual {}
1455 
1456     /* solhint-disable no-empty-blocks */
1457 
1458     /// @notice After Token Transfer Hook
1459     /// @param from Token owner
1460     /// @param to Receiver
1461     /// @param tokenId The token id
1462     /* solhint-disable no-empty-blocks */
1463     function _afterTokenTransfer(
1464         address from,
1465         address to,
1466         uint256 tokenId
1467     ) internal virtual {}
1468 
1469     /* solhint-disable no-empty-blocks */
1470 
1471     /// @notice Checking if the receiving contract implements IERC721Receiver
1472     /// @param from Token owner
1473     /// @param to Receiver
1474     /// @param tokenId The token id
1475     /// @param _data Extra data
1476     function _checkERC721Received(
1477         address from,
1478         address to,
1479         uint256 tokenId,
1480         bytes memory _data
1481     ) internal returns (bool) {
1482         try
1483             IERC721Receiver(to).onERC721Received(
1484                 msg.sender,
1485                 from,
1486                 tokenId,
1487                 _data
1488             )
1489         returns (bytes4 retval) {
1490             return retval == IERC721Receiver(to).onERC721Received.selector;
1491         } catch (bytes memory reason) {
1492             if (reason.length == 0) {
1493                 revert TransferToNonERC721ReceiverImplementer();
1494             } else {
1495                 assembly {
1496                     revert(add(32, reason), mload(reason))
1497                 }
1498             }
1499         }
1500     }
1501 
1502     /// @notice Count NFTs minted by this contract
1503     /// @dev Includes burned tokens
1504     /// @return A count of valid NFTs tracked by this contract, where each one of
1505     ///  them has an assigned and queryable owner not equal to the zero address
1506     function _totalMinted() internal view returns (uint256) {
1507         return nextTokenId - startingTokenId;
1508     }
1509 
1510     /// @notice Find the owner of an NFT
1511     /// @dev This function should only be called from {ownerOf(_tokenId)}
1512     ///      This iterates through the original minters since they are ordered
1513     ///      If an owner is address(0), it keeps looking for the owner by checking the
1514     ///      previous tokens. If minter A minted 10, then the first token will have the address
1515     ///      and the rest will have address(0)
1516     /// @param _tokenId The identifier for an NFT
1517     /// @return The address of the owner of the NFT
1518     function _ownerOf(uint256 _tokenId)
1519         internal
1520         view
1521         virtual
1522         returns (address)
1523     {
1524         uint256 curr = _tokenId;
1525         unchecked {
1526             address owner;
1527             // Invariant:
1528             // There will always be an ownership that has an address and is not burned
1529             // before an ownership that does not have an address and is not burned.
1530             // Hence, curr will not underflow.
1531             while (owner == address(0)) {
1532                 if (!unorderedOwner[curr]) {
1533                     owner = tokenOwnersOrdered[curr];
1534                 }
1535                 curr--;
1536             }
1537             return owner;
1538         }
1539     }
1540 }
1541 
1542 interface IOperatorFilter {
1543     function mayTransfer(address operator) external view returns (bool);
1544 }
1545 
1546 abstract contract ERC721OperatorFilter is BatchERC721, Ownable, AccessControl {
1547     IOperatorFilter private operatorFilter_;
1548 
1549     constructor(
1550         string memory name_,
1551         string memory symbol_,
1552         uint256 startingTokenId_,
1553         address filter
1554     ) Ownable() BatchERC721(name_, symbol_, startingTokenId_) AccessControl() {
1555         operatorFilter_ = IOperatorFilter(filter);
1556     }
1557 
1558     function setOperatorFilter(IOperatorFilter filter) public onlyRole(DEFAULT_ADMIN_ROLE) {
1559         operatorFilter_ = filter;
1560     }
1561 
1562     function operatorFilter() public view returns (IOperatorFilter) {
1563         return operatorFilter_;
1564     }
1565 
1566     function supportsInterface(bytes4 interfaceId)
1567         public
1568         view
1569         virtual
1570         override(BatchERC721, AccessControl)
1571         returns (bool)
1572     {
1573         return
1574             interfaceId == type(AccessControl).interfaceId ||
1575             BatchERC721.supportsInterface(interfaceId);
1576     }
1577 
1578     function _beforeTokenTransfer(
1579         address from,
1580         address to,
1581         uint256 tokenId
1582     ) internal virtual override(BatchERC721) {
1583         if (
1584             from != address(0) &&
1585             to != address(0) &&
1586             !_mayTransfer(msg.sender, tokenId)
1587         ) {
1588             revert("ERC721OperatorFilter: illegal operator");
1589         }
1590         super._beforeTokenTransfer(from, to, tokenId);
1591     }
1592 
1593     function _beforeSetApproval(address _operator, bool _approved) internal virtual override {
1594         if(_approved && !_mayOperate(_operator)) revert("ERC721OperatorFilter: illegal operator");
1595         super._beforeSetApproval(_operator, _approved);
1596     }
1597 
1598     function _mayOperate(address operator)
1599         private
1600         view
1601         returns (bool)
1602     {
1603         IOperatorFilter filter = operatorFilter_;
1604         return filter.mayTransfer(operator);
1605     }
1606 
1607     function _mayTransfer(address operator, uint256 tokenId)
1608         private
1609         view
1610         returns (bool)
1611     {
1612         IOperatorFilter filter = operatorFilter_;
1613         if (address(filter) == address(0)) return true;
1614         if (operator == ownerOf(tokenId)) return true;
1615         return filter.mayTransfer(msg.sender);
1616     }
1617 }
1618 
1619 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1620 
1621 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1622 
1623 /**
1624  * @dev Interface for the NFT Royalty Standard.
1625  *
1626  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1627  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1628  *
1629  * _Available since v4.5._
1630  */
1631 interface IERC2981 is IERC165 {
1632     /**
1633      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1634      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1635      */
1636     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1637         external
1638         view
1639         returns (address receiver, uint256 royaltyAmount);
1640 }
1641 
1642 /**
1643  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1644  *
1645  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1646  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1647  *
1648  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1649  * fee is specified in basis points by default.
1650  *
1651  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1652  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1653  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1654  *
1655  * _Available since v4.5._
1656  */
1657 abstract contract ERC2981 is IERC2981, ERC165 {
1658     struct RoyaltyInfo {
1659         address receiver;
1660         uint96 royaltyFraction;
1661     }
1662 
1663     RoyaltyInfo private _defaultRoyaltyInfo;
1664     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1665 
1666     /**
1667      * @dev See {IERC165-supportsInterface}.
1668      */
1669     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1670         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1671     }
1672 
1673     /**
1674      * @inheritdoc IERC2981
1675      */
1676     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1677         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1678 
1679         if (royalty.receiver == address(0)) {
1680             royalty = _defaultRoyaltyInfo;
1681         }
1682 
1683         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1684 
1685         return (royalty.receiver, royaltyAmount);
1686     }
1687 
1688     /**
1689      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1690      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1691      * override.
1692      */
1693     function _feeDenominator() internal pure virtual returns (uint96) {
1694         return 10000;
1695     }
1696 
1697     /**
1698      * @dev Sets the royalty information that all ids in this contract will default to.
1699      *
1700      * Requirements:
1701      *
1702      * - `receiver` cannot be the zero address.
1703      * - `feeNumerator` cannot be greater than the fee denominator.
1704      */
1705     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1706         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1707         require(receiver != address(0), "ERC2981: invalid receiver");
1708 
1709         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1710     }
1711 
1712     /**
1713      * @dev Removes default royalty information.
1714      */
1715     function _deleteDefaultRoyalty() internal virtual {
1716         delete _defaultRoyaltyInfo;
1717     }
1718 
1719     /**
1720      * @dev Sets the royalty information for a specific token id, overriding the global default.
1721      *
1722      * Requirements:
1723      *
1724      * - `receiver` cannot be the zero address.
1725      * - `feeNumerator` cannot be greater than the fee denominator.
1726      */
1727     function _setTokenRoyalty(
1728         uint256 tokenId,
1729         address receiver,
1730         uint96 feeNumerator
1731     ) internal virtual {
1732         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1733         require(receiver != address(0), "ERC2981: Invalid parameters");
1734 
1735         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1736     }
1737 
1738     /**
1739      * @dev Resets royalty information for the token id back to the global default.
1740      */
1741     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1742         delete _tokenRoyaltyInfo[tokenId];
1743     }
1744 }
1745 
1746 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1747 
1748 /**
1749  * @dev These functions deal with verification of Merkle Tree proofs.
1750  *
1751  * The proofs can be generated using the JavaScript library
1752  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1753  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1754  *
1755  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1756  *
1757  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1758  * hashing, or use a hash function other than keccak256 for hashing leaves.
1759  * This is because the concatenation of a sorted pair of internal nodes in
1760  * the merkle tree could be reinterpreted as a leaf value.
1761  */
1762 library MerkleProof {
1763     /**
1764      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1765      * defined by `root`. For this, a `proof` must be provided, containing
1766      * sibling hashes on the branch from the leaf to the root of the tree. Each
1767      * pair of leaves and each pair of pre-images are assumed to be sorted.
1768      */
1769     function verify(
1770         bytes32[] memory proof,
1771         bytes32 root,
1772         bytes32 leaf
1773     ) internal pure returns (bool) {
1774         return processProof(proof, leaf) == root;
1775     }
1776 
1777     /**
1778      * @dev Calldata version of {verify}
1779      *
1780      * _Available since v4.7._
1781      */
1782     function verifyCalldata(
1783         bytes32[] calldata proof,
1784         bytes32 root,
1785         bytes32 leaf
1786     ) internal pure returns (bool) {
1787         return processProofCalldata(proof, leaf) == root;
1788     }
1789 
1790     /**
1791      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1792      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1793      * hash matches the root of the tree. When processing the proof, the pairs
1794      * of leafs & pre-images are assumed to be sorted.
1795      *
1796      * _Available since v4.4._
1797      */
1798     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1799         bytes32 computedHash = leaf;
1800         for (uint256 i = 0; i < proof.length; i++) {
1801             computedHash = _hashPair(computedHash, proof[i]);
1802         }
1803         return computedHash;
1804     }
1805 
1806     /**
1807      * @dev Calldata version of {processProof}
1808      *
1809      * _Available since v4.7._
1810      */
1811     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1812         bytes32 computedHash = leaf;
1813         for (uint256 i = 0; i < proof.length; i++) {
1814             computedHash = _hashPair(computedHash, proof[i]);
1815         }
1816         return computedHash;
1817     }
1818 
1819     /**
1820      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1821      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1822      *
1823      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1824      *
1825      * _Available since v4.7._
1826      */
1827     function multiProofVerify(
1828         bytes32[] memory proof,
1829         bool[] memory proofFlags,
1830         bytes32 root,
1831         bytes32[] memory leaves
1832     ) internal pure returns (bool) {
1833         return processMultiProof(proof, proofFlags, leaves) == root;
1834     }
1835 
1836     /**
1837      * @dev Calldata version of {multiProofVerify}
1838      *
1839      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1840      *
1841      * _Available since v4.7._
1842      */
1843     function multiProofVerifyCalldata(
1844         bytes32[] calldata proof,
1845         bool[] calldata proofFlags,
1846         bytes32 root,
1847         bytes32[] memory leaves
1848     ) internal pure returns (bool) {
1849         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1850     }
1851 
1852     /**
1853      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1854      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1855      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1856      * respectively.
1857      *
1858      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1859      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1860      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1861      *
1862      * _Available since v4.7._
1863      */
1864     function processMultiProof(
1865         bytes32[] memory proof,
1866         bool[] memory proofFlags,
1867         bytes32[] memory leaves
1868     ) internal pure returns (bytes32 merkleRoot) {
1869         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1870         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1871         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1872         // the merkle tree.
1873         uint256 leavesLen = leaves.length;
1874         uint256 totalHashes = proofFlags.length;
1875 
1876         // Check proof validity.
1877         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1878 
1879         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1880         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1881         bytes32[] memory hashes = new bytes32[](totalHashes);
1882         uint256 leafPos = 0;
1883         uint256 hashPos = 0;
1884         uint256 proofPos = 0;
1885         // At each step, we compute the next hash using two values:
1886         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1887         //   get the next hash.
1888         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1889         //   `proof` array.
1890         for (uint256 i = 0; i < totalHashes; i++) {
1891             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1892             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1893             hashes[i] = _hashPair(a, b);
1894         }
1895 
1896         if (totalHashes > 0) {
1897             return hashes[totalHashes - 1];
1898         } else if (leavesLen > 0) {
1899             return leaves[0];
1900         } else {
1901             return proof[0];
1902         }
1903     }
1904 
1905     /**
1906      * @dev Calldata version of {processMultiProof}.
1907      *
1908      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1909      *
1910      * _Available since v4.7._
1911      */
1912     function processMultiProofCalldata(
1913         bytes32[] calldata proof,
1914         bool[] calldata proofFlags,
1915         bytes32[] memory leaves
1916     ) internal pure returns (bytes32 merkleRoot) {
1917         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1918         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1919         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1920         // the merkle tree.
1921         uint256 leavesLen = leaves.length;
1922         uint256 totalHashes = proofFlags.length;
1923 
1924         // Check proof validity.
1925         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1926 
1927         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1928         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1929         bytes32[] memory hashes = new bytes32[](totalHashes);
1930         uint256 leafPos = 0;
1931         uint256 hashPos = 0;
1932         uint256 proofPos = 0;
1933         // At each step, we compute the next hash using two values:
1934         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1935         //   get the next hash.
1936         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1937         //   `proof` array.
1938         for (uint256 i = 0; i < totalHashes; i++) {
1939             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1940             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1941             hashes[i] = _hashPair(a, b);
1942         }
1943 
1944         if (totalHashes > 0) {
1945             return hashes[totalHashes - 1];
1946         } else if (leavesLen > 0) {
1947             return leaves[0];
1948         } else {
1949             return proof[0];
1950         }
1951     }
1952 
1953     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1954         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1955     }
1956 
1957     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1958         /// @solidity memory-safe-assembly
1959         assembly {
1960             mstore(0x00, a)
1961             mstore(0x20, b)
1962             value := keccak256(0x00, 0x40)
1963         }
1964     }
1965 }
1966 
1967 interface IMortiverse {
1968     error InvalidETHQuantity();
1969     error MaxSupply();
1970     error NonExistentTokenURI();
1971     error WithdrawTransfer();
1972     error NotInAllowlist();
1973     error ExceedsMintAllowance();
1974     error InvalidURI();
1975     error LengthsMismatch();
1976     error NotAllowlistPhase();
1977     error NotPublicPhase();
1978     error PublicSaleMustStartAfterAllowlist();
1979     error NewAllowanceLowerThanActual();
1980     error IllegalOperator();
1981 }
1982 
1983 contract Mortiverse is
1984     ERC721OperatorFilter,
1985     ERC2981,
1986     IMortiverse
1987 {
1988     struct SaleConfig {
1989         uint128 allowlist;
1990         uint128 publicSale;
1991     }
1992 
1993     enum Phase {
1994         CLOSED,
1995         ALLOWLIST,
1996         PUBLIC,
1997         OVER
1998     }
1999 
2000     uint256 public constant TOTAL_SUPPLY = 5555;
2001     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
2002 
2003     string public contractURI = "ipfs://QmR2y7P2m9cbmtc31LskvVcbn2qxJPWNE4EvrioJJjPukJ";
2004 
2005     uint256 public price = 0.029 ether;
2006     uint256 public mintAllowance = 2;
2007 
2008     bytes32 public allowlistMerkleRoot;
2009 
2010     mapping(address => uint256) private mints;
2011 
2012     SaleConfig public saleConfig;
2013 
2014     modifier isMintable(uint256 quantity) {
2015         if (price * quantity != msg.value) {
2016             revert InvalidETHQuantity();
2017         }
2018         if (_totalMinted() + quantity > TOTAL_SUPPLY) {
2019             revert MaxSupply();
2020         }
2021         if (mints[msg.sender] + quantity > mintAllowance) {
2022             revert ExceedsMintAllowance();
2023         }
2024         _;
2025     }
2026 
2027     constructor(
2028         address owner_,
2029         address manager_,
2030         uint256 initialQty_,
2031         address filter_
2032     ) ERC721OperatorFilter("Mortiverse", "MORTI", 1, filter_) {
2033         baseURI = "ipfs://QmWpxg6xzYgZhdzoejrp8HFxUppr8sPQaV6kE5XasfuZeX/";
2034         uriExtension = ".json";
2035         _grantRole(DEFAULT_ADMIN_ROLE, owner_);
2036         _grantRole(DEFAULT_ADMIN_ROLE, manager_);
2037         _grantRole(MANAGER_ROLE, owner_);
2038         _grantRole(MANAGER_ROLE, manager_);
2039         _setDefaultRoyalty(owner_, 750);
2040         saleConfig = SaleConfig(1665763200, 1665777600);
2041         if(initialQty_ > 0) {
2042             _mint2309(owner_, initialQty_);
2043         }
2044         _transferOwnership(manager_);
2045     }
2046 
2047     function allowlistMint(bytes32[] calldata merkleProof, uint256 quantity)
2048         external
2049         payable
2050         isMintable(quantity)
2051     {
2052         if (currentPhase() != Phase.ALLOWLIST) revert NotAllowlistPhase();
2053         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2054         if (!MerkleProof.verify(merkleProof, allowlistMerkleRoot, leaf)) {
2055             revert NotInAllowlist();
2056         }
2057         mints[msg.sender] += quantity;
2058         safeMint(msg.sender, quantity);
2059     }
2060 
2061     function mint(uint256 quantity) external payable isMintable(quantity) {
2062         if (currentPhase() != Phase.PUBLIC) revert NotPublicPhase();
2063         mints[msg.sender] += quantity;
2064         safeMint(msg.sender, quantity);
2065     }
2066 
2067     function ownerMint(address recipient, uint256 quantity)
2068         external
2069         onlyRole(DEFAULT_ADMIN_ROLE)
2070     {
2071         safeMint(recipient, quantity);
2072     }
2073 
2074     function airdrop(
2075         address[] calldata receivers,
2076         uint256[] calldata quantities
2077     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
2078         if (receivers.length != quantities.length) revert LengthsMismatch();
2079         uint256 total;
2080         for (uint256 i = 0; i < quantities.length; i++) {
2081             total += quantities[i];
2082         }
2083         if (_totalMinted() + total > TOTAL_SUPPLY) revert MaxSupply();
2084         for (uint256 i = 0; i < receivers.length; i++) {
2085             safeMint(receivers[i], quantities[i]);
2086         }
2087     }
2088 
2089     function setContractURI(string calldata _contractURI)
2090         external
2091         onlyRole(MANAGER_ROLE)
2092     {
2093         if (bytes(_contractURI).length == 0) {
2094             revert InvalidURI();
2095         }
2096         contractURI = _contractURI;
2097     }
2098 
2099     function setBaseURI(string calldata _baseURI)
2100         external
2101         onlyRole(MANAGER_ROLE)
2102     {
2103         if (bytes(_baseURI).length == 0) {
2104             revert InvalidURI();
2105         }
2106         baseURI = _baseURI;
2107     }
2108 
2109     function setURIExtension(string calldata _extension)
2110         external
2111         onlyRole(MANAGER_ROLE)
2112     {
2113         if (bytes(_extension).length == 0) {
2114             uriExtension = "";
2115         }
2116         uriExtension = _extension;
2117     }
2118 
2119     function setSaleConfig(uint128 allowlistTimestamp, uint128 publicTimestamp)
2120         external
2121         onlyRole(MANAGER_ROLE)
2122     {
2123         if (allowlistTimestamp >= publicTimestamp)
2124             revert PublicSaleMustStartAfterAllowlist();
2125         saleConfig = SaleConfig(allowlistTimestamp, publicTimestamp);
2126     }
2127 
2128     function setAllowlistRoot(bytes32 merkleRoot)
2129         external
2130         onlyRole(MANAGER_ROLE)
2131     {
2132         allowlistMerkleRoot = merkleRoot;
2133     }
2134 
2135     function setDefaultAdmin() external onlyOwner {
2136         _grantRole(DEFAULT_ADMIN_ROLE, owner());
2137     }
2138 
2139     function withdrawPayments(address payable payee)
2140         external
2141         onlyRole(DEFAULT_ADMIN_ROLE)
2142     {
2143         uint256 balance = address(this).balance;
2144         (bool transferTx, ) = payee.call{value: balance}(""); // solhint-disable-line avoid-low-level-calls
2145         if (!transferTx) {
2146             revert WithdrawTransfer();
2147         }
2148     }
2149 
2150     /// @notice Sets the royalty information that all ids in this contract will default to.
2151     /// @dev Explain to a developer any extra details
2152     /// @param receiver cannot be the zero address.
2153     /// @param feeNumerator cannot be greater than the fee denominator.
2154     function setDefaultRoyalty(address receiver, uint96 feeNumerator)
2155         external
2156         onlyRole(DEFAULT_ADMIN_ROLE)
2157     {
2158         _setDefaultRoyalty(receiver, feeNumerator);
2159     }
2160 
2161     // @notice Sets the royalty information that token ids.
2162     /// @dev to Resets royalty information set _feeNumerator to 0
2163     /// @param tokenId the specific token id to Sets the royalty information for
2164     /// @param receiver the address that will receive the royalty
2165     /// @param feeNumerator cannot be greater than the fee denominator other case revert with InvalidFeeNumerator
2166     function setTokenRoyalty(
2167         uint256 tokenId,
2168         address receiver,
2169         uint96 feeNumerator
2170     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
2171         _setTokenRoyalty(tokenId, receiver, feeNumerator);
2172     }
2173 
2174     function setMintAllowance(uint256 allowance) external onlyRole(MANAGER_ROLE) {
2175         if(allowance <= mintAllowance) revert NewAllowanceLowerThanActual();
2176         mintAllowance = allowance;
2177     }
2178 
2179     function setPrice(uint256 newPrice) external onlyRole(MANAGER_ROLE) {
2180         price = newPrice;
2181     }
2182 
2183     // solhint-disable not-rely-on-time
2184     function currentPhase() public view returns (Phase) {
2185         if (_totalMinted() == TOTAL_SUPPLY) {
2186             return Phase.OVER;
2187         } else if (block.timestamp > saleConfig.publicSale) {
2188             return Phase.PUBLIC;
2189         } else if (block.timestamp > saleConfig.allowlist) {
2190             return Phase.ALLOWLIST;
2191         } else {
2192             return Phase.CLOSED;
2193         }
2194     }
2195     // solhint-enable
2196 
2197     function userAllowance(address user) public view returns (uint256) {
2198         return mintAllowance - mints[user];
2199     }
2200 
2201     function supportsInterface(bytes4 interfaceId)
2202         public
2203         view
2204         virtual
2205         override(ERC721OperatorFilter, ERC2981)
2206         returns (bool)
2207     {
2208         return
2209             interfaceId == 0x2a55205a || // ERC165 Interface ID for ERC2981
2210             ERC721OperatorFilter.supportsInterface(interfaceId);
2211     }
2212 }