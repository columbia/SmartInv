1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.15;
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
538 /**
539  * @dev String operations.
540  */
541 library Strings {
542     bytes16 private constant _SYMBOLS = "0123456789abcdef";
543     uint8 private constant _ADDRESS_LENGTH = 20;
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
547      */
548     function toString(uint256 value) internal pure returns (string memory) {
549         unchecked {
550             uint256 length = Math.log10(value) + 1;
551             string memory buffer = new string(length);
552             uint256 ptr;
553             /// @solidity memory-safe-assembly
554             assembly {
555                 ptr := add(buffer, add(32, length))
556             }
557             while (true) {
558                 ptr--;
559                 /// @solidity memory-safe-assembly
560                 assembly {
561                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
562                 }
563                 value /= 10;
564                 if (value == 0) break;
565             }
566             return buffer;
567         }
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
572      */
573     function toHexString(uint256 value) internal pure returns (string memory) {
574         unchecked {
575             return toHexString(value, Math.log256(value) + 1);
576         }
577     }
578 
579     /**
580      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
581      */
582     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
583         bytes memory buffer = new bytes(2 * length + 2);
584         buffer[0] = "0";
585         buffer[1] = "x";
586         for (uint256 i = 2 * length + 1; i > 1; --i) {
587             buffer[i] = _SYMBOLS[value & 0xf];
588             value >>= 4;
589         }
590         require(value == 0, "Strings: hex length insufficient");
591         return string(buffer);
592     }
593 
594     /**
595      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
596      */
597     function toHexString(address addr) internal pure returns (string memory) {
598         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
599     }
600 }
601 
602 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
603 
604 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
605 
606 /**
607  * @dev Interface of the ERC165 standard, as defined in the
608  * https://eips.ethereum.org/EIPS/eip-165[EIP].
609  *
610  * Implementers can declare support of contract interfaces, which can then be
611  * queried by others ({ERC165Checker}).
612  *
613  * For an implementation, see {ERC165}.
614  */
615 interface IERC165 {
616     /**
617      * @dev Returns true if this contract implements the interface defined by
618      * `interfaceId`. See the corresponding
619      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
620      * to learn more about how these ids are created.
621      *
622      * This function call must use less than 30 000 gas.
623      */
624     function supportsInterface(bytes4 interfaceId) external view returns (bool);
625 }
626 
627 /**
628  * @dev Implementation of the {IERC165} interface.
629  *
630  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
631  * for the additional interface id that will be supported. For example:
632  *
633  * ```solidity
634  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
635  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
636  * }
637  * ```
638  *
639  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
640  */
641 abstract contract ERC165 is IERC165 {
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
646         return interfaceId == type(IERC165).interfaceId;
647     }
648 }
649 
650 /**
651  * @dev Contract module that allows children to implement role-based access
652  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
653  * members except through off-chain means by accessing the contract event logs. Some
654  * applications may benefit from on-chain enumerability, for those cases see
655  * {AccessControlEnumerable}.
656  *
657  * Roles are referred to by their `bytes32` identifier. These should be exposed
658  * in the external API and be unique. The best way to achieve this is by
659  * using `public constant` hash digests:
660  *
661  * ```
662  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
663  * ```
664  *
665  * Roles can be used to represent a set of permissions. To restrict access to a
666  * function call, use {hasRole}:
667  *
668  * ```
669  * function foo() public {
670  *     require(hasRole(MY_ROLE, msg.sender));
671  *     ...
672  * }
673  * ```
674  *
675  * Roles can be granted and revoked dynamically via the {grantRole} and
676  * {revokeRole} functions. Each role has an associated admin role, and only
677  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
678  *
679  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
680  * that only accounts with this role will be able to grant or revoke other
681  * roles. More complex role relationships can be created by using
682  * {_setRoleAdmin}.
683  *
684  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
685  * grant and revoke this role. Extra precautions should be taken to secure
686  * accounts that have been granted it.
687  */
688 abstract contract AccessControl is Context, IAccessControl, ERC165 {
689     struct RoleData {
690         mapping(address => bool) members;
691         bytes32 adminRole;
692     }
693 
694     mapping(bytes32 => RoleData) private _roles;
695 
696     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
697 
698     /**
699      * @dev Modifier that checks that an account has a specific role. Reverts
700      * with a standardized message including the required role.
701      *
702      * The format of the revert reason is given by the following regular expression:
703      *
704      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
705      *
706      * _Available since v4.1._
707      */
708     modifier onlyRole(bytes32 role) {
709         _checkRole(role);
710         _;
711     }
712 
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
718     }
719 
720     /**
721      * @dev Returns `true` if `account` has been granted `role`.
722      */
723     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
724         return _roles[role].members[account];
725     }
726 
727     /**
728      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
729      * Overriding this function changes the behavior of the {onlyRole} modifier.
730      *
731      * Format of the revert message is described in {_checkRole}.
732      *
733      * _Available since v4.6._
734      */
735     function _checkRole(bytes32 role) internal view virtual {
736         _checkRole(role, _msgSender());
737     }
738 
739     /**
740      * @dev Revert with a standard message if `account` is missing `role`.
741      *
742      * The format of the revert reason is given by the following regular expression:
743      *
744      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
745      */
746     function _checkRole(bytes32 role, address account) internal view virtual {
747         if (!hasRole(role, account)) {
748             revert(
749                 string(
750                     abi.encodePacked(
751                         "AccessControl: account ",
752                         Strings.toHexString(account),
753                         " is missing role ",
754                         Strings.toHexString(uint256(role), 32)
755                     )
756                 )
757             );
758         }
759     }
760 
761     /**
762      * @dev Returns the admin role that controls `role`. See {grantRole} and
763      * {revokeRole}.
764      *
765      * To change a role's admin, use {_setRoleAdmin}.
766      */
767     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
768         return _roles[role].adminRole;
769     }
770 
771     /**
772      * @dev Grants `role` to `account`.
773      *
774      * If `account` had not been already granted `role`, emits a {RoleGranted}
775      * event.
776      *
777      * Requirements:
778      *
779      * - the caller must have ``role``'s admin role.
780      *
781      * May emit a {RoleGranted} event.
782      */
783     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
784         _grantRole(role, account);
785     }
786 
787     /**
788      * @dev Revokes `role` from `account`.
789      *
790      * If `account` had been granted `role`, emits a {RoleRevoked} event.
791      *
792      * Requirements:
793      *
794      * - the caller must have ``role``'s admin role.
795      *
796      * May emit a {RoleRevoked} event.
797      */
798     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
799         _revokeRole(role, account);
800     }
801 
802     /**
803      * @dev Revokes `role` from the calling account.
804      *
805      * Roles are often managed via {grantRole} and {revokeRole}: this function's
806      * purpose is to provide a mechanism for accounts to lose their privileges
807      * if they are compromised (such as when a trusted device is misplaced).
808      *
809      * If the calling account had been revoked `role`, emits a {RoleRevoked}
810      * event.
811      *
812      * Requirements:
813      *
814      * - the caller must be `account`.
815      *
816      * May emit a {RoleRevoked} event.
817      */
818     function renounceRole(bytes32 role, address account) public virtual override {
819         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
820 
821         _revokeRole(role, account);
822     }
823 
824     /**
825      * @dev Grants `role` to `account`.
826      *
827      * If `account` had not been already granted `role`, emits a {RoleGranted}
828      * event. Note that unlike {grantRole}, this function doesn't perform any
829      * checks on the calling account.
830      *
831      * May emit a {RoleGranted} event.
832      *
833      * [WARNING]
834      * ====
835      * This function should only be called from the constructor when setting
836      * up the initial roles for the system.
837      *
838      * Using this function in any other way is effectively circumventing the admin
839      * system imposed by {AccessControl}.
840      * ====
841      *
842      * NOTE: This function is deprecated in favor of {_grantRole}.
843      */
844     function _setupRole(bytes32 role, address account) internal virtual {
845         _grantRole(role, account);
846     }
847 
848     /**
849      * @dev Sets `adminRole` as ``role``'s admin role.
850      *
851      * Emits a {RoleAdminChanged} event.
852      */
853     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
854         bytes32 previousAdminRole = getRoleAdmin(role);
855         _roles[role].adminRole = adminRole;
856         emit RoleAdminChanged(role, previousAdminRole, adminRole);
857     }
858 
859     /**
860      * @dev Grants `role` to `account`.
861      *
862      * Internal function without access restriction.
863      *
864      * May emit a {RoleGranted} event.
865      */
866     function _grantRole(bytes32 role, address account) internal virtual {
867         if (!hasRole(role, account)) {
868             _roles[role].members[account] = true;
869             emit RoleGranted(role, account, _msgSender());
870         }
871     }
872 
873     /**
874      * @dev Revokes `role` from `account`.
875      *
876      * Internal function without access restriction.
877      *
878      * May emit a {RoleRevoked} event.
879      */
880     function _revokeRole(bytes32 role, address account) internal virtual {
881         if (hasRole(role, account)) {
882             _roles[role].members[account] = false;
883             emit RoleRevoked(role, account, _msgSender());
884         }
885     }
886 }
887 
888 // ERC721A Contracts v4.2.3
889 // Creator: Chiru Labs
890 
891 // ERC721A Contracts v4.2.3
892 // Creator: Chiru Labs
893 
894 /**
895  * @dev Interface of ERC721A.
896  */
897 interface IERC721A {
898     /**
899      * The caller must own the token or be an approved operator.
900      */
901     error ApprovalCallerNotOwnerNorApproved();
902 
903     /**
904      * The token does not exist.
905      */
906     error ApprovalQueryForNonexistentToken();
907 
908     /**
909      * Cannot query the balance for the zero address.
910      */
911     error BalanceQueryForZeroAddress();
912 
913     /**
914      * Cannot mint to the zero address.
915      */
916     error MintToZeroAddress();
917 
918     /**
919      * The quantity of tokens minted must be more than zero.
920      */
921     error MintZeroQuantity();
922 
923     /**
924      * The token does not exist.
925      */
926     error OwnerQueryForNonexistentToken();
927 
928     /**
929      * The caller must own the token or be an approved operator.
930      */
931     error TransferCallerNotOwnerNorApproved();
932 
933     /**
934      * The token must be owned by `from`.
935      */
936     error TransferFromIncorrectOwner();
937 
938     /**
939      * Cannot safely transfer to a contract that does not implement the
940      * ERC721Receiver interface.
941      */
942     error TransferToNonERC721ReceiverImplementer();
943 
944     /**
945      * Cannot transfer to the zero address.
946      */
947     error TransferToZeroAddress();
948 
949     /**
950      * The token does not exist.
951      */
952     error URIQueryForNonexistentToken();
953 
954     /**
955      * The `quantity` minted with ERC2309 exceeds the safety limit.
956      */
957     error MintERC2309QuantityExceedsLimit();
958 
959     /**
960      * The `extraData` cannot be set on an unintialized ownership slot.
961      */
962     error OwnershipNotInitializedForExtraData();
963 
964     // =============================================================
965     //                            STRUCTS
966     // =============================================================
967 
968     struct TokenOwnership {
969         // The address of the owner.
970         address addr;
971         // Stores the start time of ownership with minimal overhead for tokenomics.
972         uint64 startTimestamp;
973         // Whether the token has been burned.
974         bool burned;
975         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
976         uint24 extraData;
977     }
978 
979     // =============================================================
980     //                         TOKEN COUNTERS
981     // =============================================================
982 
983     /**
984      * @dev Returns the total number of tokens in existence.
985      * Burned tokens will reduce the count.
986      * To get the total number of tokens minted, please see {_totalMinted}.
987      */
988     function totalSupply() external view returns (uint256);
989 
990     // =============================================================
991     //                            IERC165
992     // =============================================================
993 
994     /**
995      * @dev Returns true if this contract implements the interface defined by
996      * `interfaceId`. See the corresponding
997      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
998      * to learn more about how these ids are created.
999      *
1000      * This function call must use less than 30000 gas.
1001      */
1002     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1003 
1004     // =============================================================
1005     //                            IERC721
1006     // =============================================================
1007 
1008     /**
1009      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1010      */
1011     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1012 
1013     /**
1014      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1015      */
1016     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1017 
1018     /**
1019      * @dev Emitted when `owner` enables or disables
1020      * (`approved`) `operator` to manage all of its assets.
1021      */
1022     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1023 
1024     /**
1025      * @dev Returns the number of tokens in `owner`'s account.
1026      */
1027     function balanceOf(address owner) external view returns (uint256 balance);
1028 
1029     /**
1030      * @dev Returns the owner of the `tokenId` token.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      */
1036     function ownerOf(uint256 tokenId) external view returns (address owner);
1037 
1038     /**
1039      * @dev Safely transfers `tokenId` token from `from` to `to`,
1040      * checking first that contract recipients are aware of the ERC721 protocol
1041      * to prevent tokens from being forever locked.
1042      *
1043      * Requirements:
1044      *
1045      * - `from` cannot be the zero address.
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must exist and be owned by `from`.
1048      * - If the caller is not `from`, it must be have been allowed to move
1049      * this token by either {approve} or {setApprovalForAll}.
1050      * - If `to` refers to a smart contract, it must implement
1051      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes calldata data
1060     ) external payable;
1061 
1062     /**
1063      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) external payable;
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *
1074      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1075      * whenever possible.
1076      *
1077      * Requirements:
1078      *
1079      * - `from` cannot be the zero address.
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must be owned by `from`.
1082      * - If the caller is not `from`, it must be approved to move this token
1083      * by either {approve} or {setApprovalForAll}.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function transferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) external payable;
1092 
1093     /**
1094      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1095      * The approval is cleared when the token is transferred.
1096      *
1097      * Only a single account can be approved at a time, so approving the
1098      * zero address clears previous approvals.
1099      *
1100      * Requirements:
1101      *
1102      * - The caller must own the token or be an approved operator.
1103      * - `tokenId` must exist.
1104      *
1105      * Emits an {Approval} event.
1106      */
1107     function approve(address to, uint256 tokenId) external payable;
1108 
1109     /**
1110      * @dev Approve or remove `operator` as an operator for the caller.
1111      * Operators can call {transferFrom} or {safeTransferFrom}
1112      * for any token owned by the caller.
1113      *
1114      * Requirements:
1115      *
1116      * - The `operator` cannot be the caller.
1117      *
1118      * Emits an {ApprovalForAll} event.
1119      */
1120     function setApprovalForAll(address operator, bool _approved) external;
1121 
1122     /**
1123      * @dev Returns the account approved for `tokenId` token.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must exist.
1128      */
1129     function getApproved(uint256 tokenId) external view returns (address operator);
1130 
1131     /**
1132      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1133      *
1134      * See {setApprovalForAll}.
1135      */
1136     function isApprovedForAll(address owner, address operator) external view returns (bool);
1137 
1138     // =============================================================
1139     //                        IERC721Metadata
1140     // =============================================================
1141 
1142     /**
1143      * @dev Returns the token collection name.
1144      */
1145     function name() external view returns (string memory);
1146 
1147     /**
1148      * @dev Returns the token collection symbol.
1149      */
1150     function symbol() external view returns (string memory);
1151 
1152     /**
1153      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1154      */
1155     function tokenURI(uint256 tokenId) external view returns (string memory);
1156 
1157     // =============================================================
1158     //                           IERC2309
1159     // =============================================================
1160 
1161     /**
1162      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1163      * (inclusive) is transferred from `from` to `to`, as defined in the
1164      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1165      *
1166      * See {_mintERC2309} for more details.
1167      */
1168     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1169 }
1170 
1171 /**
1172  * @dev Interface of ERC721 token receiver.
1173  */
1174 interface ERC721A__IERC721Receiver {
1175     function onERC721Received(
1176         address operator,
1177         address from,
1178         uint256 tokenId,
1179         bytes calldata data
1180     ) external returns (bytes4);
1181 }
1182 
1183 /**
1184  * @title ERC721A
1185  *
1186  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1187  * Non-Fungible Token Standard, including the Metadata extension.
1188  * Optimized for lower gas during batch mints.
1189  *
1190  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1191  * starting from `_startTokenId()`.
1192  *
1193  * Assumptions:
1194  *
1195  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1196  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1197  */
1198 contract ERC721A is IERC721A {
1199     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1200     struct TokenApprovalRef {
1201         address value;
1202     }
1203 
1204     // =============================================================
1205     //                           CONSTANTS
1206     // =============================================================
1207 
1208     // Mask of an entry in packed address data.
1209     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1210 
1211     // The bit position of `numberMinted` in packed address data.
1212     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1213 
1214     // The bit position of `numberBurned` in packed address data.
1215     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1216 
1217     // The bit position of `aux` in packed address data.
1218     uint256 private constant _BITPOS_AUX = 192;
1219 
1220     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1221     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1222 
1223     // The bit position of `startTimestamp` in packed ownership.
1224     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1225 
1226     // The bit mask of the `burned` bit in packed ownership.
1227     uint256 private constant _BITMASK_BURNED = 1 << 224;
1228 
1229     // The bit position of the `nextInitialized` bit in packed ownership.
1230     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1231 
1232     // The bit mask of the `nextInitialized` bit in packed ownership.
1233     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1234 
1235     // The bit position of `extraData` in packed ownership.
1236     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1237 
1238     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1239     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1240 
1241     // The mask of the lower 160 bits for addresses.
1242     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1243 
1244     // The maximum `quantity` that can be minted with {_mintERC2309}.
1245     // This limit is to prevent overflows on the address data entries.
1246     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1247     // is required to cause an overflow, which is unrealistic.
1248     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1249 
1250     // The `Transfer` event signature is given by:
1251     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1252     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1253         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1254 
1255     // =============================================================
1256     //                            STORAGE
1257     // =============================================================
1258 
1259     // The next token ID to be minted.
1260     uint256 private _currentIndex;
1261 
1262     // The number of tokens burned.
1263     uint256 private _burnCounter;
1264 
1265     // Token name
1266     string private _name;
1267 
1268     // Token symbol
1269     string private _symbol;
1270 
1271     // Mapping from token ID to ownership details
1272     // An empty struct value does not necessarily mean the token is unowned.
1273     // See {_packedOwnershipOf} implementation for details.
1274     //
1275     // Bits Layout:
1276     // - [0..159]   `addr`
1277     // - [160..223] `startTimestamp`
1278     // - [224]      `burned`
1279     // - [225]      `nextInitialized`
1280     // - [232..255] `extraData`
1281     mapping(uint256 => uint256) private _packedOwnerships;
1282 
1283     // Mapping owner address to address data.
1284     //
1285     // Bits Layout:
1286     // - [0..63]    `balance`
1287     // - [64..127]  `numberMinted`
1288     // - [128..191] `numberBurned`
1289     // - [192..255] `aux`
1290     mapping(address => uint256) private _packedAddressData;
1291 
1292     // Mapping from token ID to approved address.
1293     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1294 
1295     // Mapping from owner to operator approvals
1296     mapping(address => mapping(address => bool)) private _operatorApprovals;
1297 
1298     // =============================================================
1299     //                          CONSTRUCTOR
1300     // =============================================================
1301 
1302     constructor(string memory name_, string memory symbol_) {
1303         _name = name_;
1304         _symbol = symbol_;
1305         _currentIndex = _startTokenId();
1306     }
1307 
1308     // =============================================================
1309     //                   TOKEN COUNTING OPERATIONS
1310     // =============================================================
1311 
1312     /**
1313      * @dev Returns the starting token ID.
1314      * To change the starting token ID, please override this function.
1315      */
1316     function _startTokenId() internal view virtual returns (uint256) {
1317         return 0;
1318     }
1319 
1320     /**
1321      * @dev Returns the next token ID to be minted.
1322      */
1323     function _nextTokenId() internal view virtual returns (uint256) {
1324         return _currentIndex;
1325     }
1326 
1327     /**
1328      * @dev Returns the total number of tokens in existence.
1329      * Burned tokens will reduce the count.
1330      * To get the total number of tokens minted, please see {_totalMinted}.
1331      */
1332     function totalSupply() public view virtual override returns (uint256) {
1333         // Counter underflow is impossible as _burnCounter cannot be incremented
1334         // more than `_currentIndex - _startTokenId()` times.
1335         unchecked {
1336             return _currentIndex - _burnCounter - _startTokenId();
1337         }
1338     }
1339 
1340     /**
1341      * @dev Returns the total amount of tokens minted in the contract.
1342      */
1343     function _totalMinted() internal view virtual returns (uint256) {
1344         // Counter underflow is impossible as `_currentIndex` does not decrement,
1345         // and it is initialized to `_startTokenId()`.
1346         unchecked {
1347             return _currentIndex - _startTokenId();
1348         }
1349     }
1350 
1351     /**
1352      * @dev Returns the total number of tokens burned.
1353      */
1354     function _totalBurned() internal view virtual returns (uint256) {
1355         return _burnCounter;
1356     }
1357 
1358     // =============================================================
1359     //                    ADDRESS DATA OPERATIONS
1360     // =============================================================
1361 
1362     /**
1363      * @dev Returns the number of tokens in `owner`'s account.
1364      */
1365     function balanceOf(address owner) public view virtual override returns (uint256) {
1366         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1367         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1368     }
1369 
1370     /**
1371      * Returns the number of tokens minted by `owner`.
1372      */
1373     function _numberMinted(address owner) internal view returns (uint256) {
1374         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1375     }
1376 
1377     /**
1378      * Returns the number of tokens burned by or on behalf of `owner`.
1379      */
1380     function _numberBurned(address owner) internal view returns (uint256) {
1381         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1382     }
1383 
1384     /**
1385      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1386      */
1387     function _getAux(address owner) internal view returns (uint64) {
1388         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1389     }
1390 
1391     /**
1392      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1393      * If there are multiple variables, please pack them into a uint64.
1394      */
1395     function _setAux(address owner, uint64 aux) internal virtual {
1396         uint256 packed = _packedAddressData[owner];
1397         uint256 auxCasted;
1398         // Cast `aux` with assembly to avoid redundant masking.
1399         assembly {
1400             auxCasted := aux
1401         }
1402         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1403         _packedAddressData[owner] = packed;
1404     }
1405 
1406     // =============================================================
1407     //                            IERC165
1408     // =============================================================
1409 
1410     /**
1411      * @dev Returns true if this contract implements the interface defined by
1412      * `interfaceId`. See the corresponding
1413      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1414      * to learn more about how these ids are created.
1415      *
1416      * This function call must use less than 30000 gas.
1417      */
1418     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1419         // The interface IDs are constants representing the first 4 bytes
1420         // of the XOR of all function selectors in the interface.
1421         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1422         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1423         return
1424             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1425             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1426             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1427     }
1428 
1429     // =============================================================
1430     //                        IERC721Metadata
1431     // =============================================================
1432 
1433     /**
1434      * @dev Returns the token collection name.
1435      */
1436     function name() public view virtual override returns (string memory) {
1437         return _name;
1438     }
1439 
1440     /**
1441      * @dev Returns the token collection symbol.
1442      */
1443     function symbol() public view virtual override returns (string memory) {
1444         return _symbol;
1445     }
1446 
1447     /**
1448      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1449      */
1450     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1451         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1452 
1453         string memory baseURI = _baseURI();
1454         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1455     }
1456 
1457     /**
1458      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1459      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1460      * by default, it can be overridden in child contracts.
1461      */
1462     function _baseURI() internal view virtual returns (string memory) {
1463         return '';
1464     }
1465 
1466     // =============================================================
1467     //                     OWNERSHIPS OPERATIONS
1468     // =============================================================
1469 
1470     /**
1471      * @dev Returns the owner of the `tokenId` token.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      */
1477     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1478         return address(uint160(_packedOwnershipOf(tokenId)));
1479     }
1480 
1481     /**
1482      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1483      * It gradually moves to O(1) as tokens get transferred around over time.
1484      */
1485     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1486         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1487     }
1488 
1489     /**
1490      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1491      */
1492     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1493         return _unpackedOwnership(_packedOwnerships[index]);
1494     }
1495 
1496     /**
1497      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1498      */
1499     function _initializeOwnershipAt(uint256 index) internal virtual {
1500         if (_packedOwnerships[index] == 0) {
1501             _packedOwnerships[index] = _packedOwnershipOf(index);
1502         }
1503     }
1504 
1505     /**
1506      * Returns the packed ownership data of `tokenId`.
1507      */
1508     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1509         uint256 curr = tokenId;
1510 
1511         unchecked {
1512             if (_startTokenId() <= curr)
1513                 if (curr < _currentIndex) {
1514                     uint256 packed = _packedOwnerships[curr];
1515                     // If not burned.
1516                     if (packed & _BITMASK_BURNED == 0) {
1517                         // Invariant:
1518                         // There will always be an initialized ownership slot
1519                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1520                         // before an unintialized ownership slot
1521                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1522                         // Hence, `curr` will not underflow.
1523                         //
1524                         // We can directly compare the packed value.
1525                         // If the address is zero, packed will be zero.
1526                         while (packed == 0) {
1527                             packed = _packedOwnerships[--curr];
1528                         }
1529                         return packed;
1530                     }
1531                 }
1532         }
1533         revert OwnerQueryForNonexistentToken();
1534     }
1535 
1536     /**
1537      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1538      */
1539     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1540         ownership.addr = address(uint160(packed));
1541         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1542         ownership.burned = packed & _BITMASK_BURNED != 0;
1543         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1544     }
1545 
1546     /**
1547      * @dev Packs ownership data into a single uint256.
1548      */
1549     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1550         assembly {
1551             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1552             owner := and(owner, _BITMASK_ADDRESS)
1553             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1554             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1555         }
1556     }
1557 
1558     /**
1559      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1560      */
1561     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1562         // For branchless setting of the `nextInitialized` flag.
1563         assembly {
1564             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1565             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1566         }
1567     }
1568 
1569     // =============================================================
1570     //                      APPROVAL OPERATIONS
1571     // =============================================================
1572 
1573     /**
1574      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1575      * The approval is cleared when the token is transferred.
1576      *
1577      * Only a single account can be approved at a time, so approving the
1578      * zero address clears previous approvals.
1579      *
1580      * Requirements:
1581      *
1582      * - The caller must own the token or be an approved operator.
1583      * - `tokenId` must exist.
1584      *
1585      * Emits an {Approval} event.
1586      */
1587     function approve(address to, uint256 tokenId) public payable virtual override {
1588         address owner = ownerOf(tokenId);
1589 
1590         if (_msgSenderERC721A() != owner)
1591             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1592                 revert ApprovalCallerNotOwnerNorApproved();
1593             }
1594 
1595         _tokenApprovals[tokenId].value = to;
1596         emit Approval(owner, to, tokenId);
1597     }
1598 
1599     /**
1600      * @dev Returns the account approved for `tokenId` token.
1601      *
1602      * Requirements:
1603      *
1604      * - `tokenId` must exist.
1605      */
1606     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1607         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1608 
1609         return _tokenApprovals[tokenId].value;
1610     }
1611 
1612     /**
1613      * @dev Approve or remove `operator` as an operator for the caller.
1614      * Operators can call {transferFrom} or {safeTransferFrom}
1615      * for any token owned by the caller.
1616      *
1617      * Requirements:
1618      *
1619      * - The `operator` cannot be the caller.
1620      *
1621      * Emits an {ApprovalForAll} event.
1622      */
1623     function setApprovalForAll(address operator, bool approved) public virtual override {
1624         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1625         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1626     }
1627 
1628     /**
1629      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1630      *
1631      * See {setApprovalForAll}.
1632      */
1633     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1634         return _operatorApprovals[owner][operator];
1635     }
1636 
1637     /**
1638      * @dev Returns whether `tokenId` exists.
1639      *
1640      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1641      *
1642      * Tokens start existing when they are minted. See {_mint}.
1643      */
1644     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1645         return
1646             _startTokenId() <= tokenId &&
1647             tokenId < _currentIndex && // If within bounds,
1648             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1649     }
1650 
1651     /**
1652      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1653      */
1654     function _isSenderApprovedOrOwner(
1655         address approvedAddress,
1656         address owner,
1657         address msgSender
1658     ) private pure returns (bool result) {
1659         assembly {
1660             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1661             owner := and(owner, _BITMASK_ADDRESS)
1662             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1663             msgSender := and(msgSender, _BITMASK_ADDRESS)
1664             // `msgSender == owner || msgSender == approvedAddress`.
1665             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1666         }
1667     }
1668 
1669     /**
1670      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1671      */
1672     function _getApprovedSlotAndAddress(uint256 tokenId)
1673         private
1674         view
1675         returns (uint256 approvedAddressSlot, address approvedAddress)
1676     {
1677         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1678         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1679         assembly {
1680             approvedAddressSlot := tokenApproval.slot
1681             approvedAddress := sload(approvedAddressSlot)
1682         }
1683     }
1684 
1685     // =============================================================
1686     //                      TRANSFER OPERATIONS
1687     // =============================================================
1688 
1689     /**
1690      * @dev Transfers `tokenId` from `from` to `to`.
1691      *
1692      * Requirements:
1693      *
1694      * - `from` cannot be the zero address.
1695      * - `to` cannot be the zero address.
1696      * - `tokenId` token must be owned by `from`.
1697      * - If the caller is not `from`, it must be approved to move this token
1698      * by either {approve} or {setApprovalForAll}.
1699      *
1700      * Emits a {Transfer} event.
1701      */
1702     function transferFrom(
1703         address from,
1704         address to,
1705         uint256 tokenId
1706     ) public payable virtual override {
1707         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1708 
1709         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1710 
1711         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1712 
1713         // The nested ifs save around 20+ gas over a compound boolean condition.
1714         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1715             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1716 
1717         if (to == address(0)) revert TransferToZeroAddress();
1718 
1719         _beforeTokenTransfers(from, to, tokenId, 1);
1720 
1721         // Clear approvals from the previous owner.
1722         assembly {
1723             if approvedAddress {
1724                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1725                 sstore(approvedAddressSlot, 0)
1726             }
1727         }
1728 
1729         // Underflow of the sender's balance is impossible because we check for
1730         // ownership above and the recipient's balance can't realistically overflow.
1731         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1732         unchecked {
1733             // We can directly increment and decrement the balances.
1734             --_packedAddressData[from]; // Updates: `balance -= 1`.
1735             ++_packedAddressData[to]; // Updates: `balance += 1`.
1736 
1737             // Updates:
1738             // - `address` to the next owner.
1739             // - `startTimestamp` to the timestamp of transfering.
1740             // - `burned` to `false`.
1741             // - `nextInitialized` to `true`.
1742             _packedOwnerships[tokenId] = _packOwnershipData(
1743                 to,
1744                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1745             );
1746 
1747             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1748             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1749                 uint256 nextTokenId = tokenId + 1;
1750                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1751                 if (_packedOwnerships[nextTokenId] == 0) {
1752                     // If the next slot is within bounds.
1753                     if (nextTokenId != _currentIndex) {
1754                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1755                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1756                     }
1757                 }
1758             }
1759         }
1760 
1761         emit Transfer(from, to, tokenId);
1762         _afterTokenTransfers(from, to, tokenId, 1);
1763     }
1764 
1765     /**
1766      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1767      */
1768     function safeTransferFrom(
1769         address from,
1770         address to,
1771         uint256 tokenId
1772     ) public payable virtual override {
1773         safeTransferFrom(from, to, tokenId, '');
1774     }
1775 
1776     /**
1777      * @dev Safely transfers `tokenId` token from `from` to `to`.
1778      *
1779      * Requirements:
1780      *
1781      * - `from` cannot be the zero address.
1782      * - `to` cannot be the zero address.
1783      * - `tokenId` token must exist and be owned by `from`.
1784      * - If the caller is not `from`, it must be approved to move this token
1785      * by either {approve} or {setApprovalForAll}.
1786      * - If `to` refers to a smart contract, it must implement
1787      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1788      *
1789      * Emits a {Transfer} event.
1790      */
1791     function safeTransferFrom(
1792         address from,
1793         address to,
1794         uint256 tokenId,
1795         bytes memory _data
1796     ) public payable virtual override {
1797         transferFrom(from, to, tokenId);
1798         if (to.code.length != 0)
1799             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1800                 revert TransferToNonERC721ReceiverImplementer();
1801             }
1802     }
1803 
1804     /**
1805      * @dev Hook that is called before a set of serially-ordered token IDs
1806      * are about to be transferred. This includes minting.
1807      * And also called before burning one token.
1808      *
1809      * `startTokenId` - the first token ID to be transferred.
1810      * `quantity` - the amount to be transferred.
1811      *
1812      * Calling conditions:
1813      *
1814      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1815      * transferred to `to`.
1816      * - When `from` is zero, `tokenId` will be minted for `to`.
1817      * - When `to` is zero, `tokenId` will be burned by `from`.
1818      * - `from` and `to` are never both zero.
1819      */
1820     function _beforeTokenTransfers(
1821         address from,
1822         address to,
1823         uint256 startTokenId,
1824         uint256 quantity
1825     ) internal virtual {}
1826 
1827     /**
1828      * @dev Hook that is called after a set of serially-ordered token IDs
1829      * have been transferred. This includes minting.
1830      * And also called after one token has been burned.
1831      *
1832      * `startTokenId` - the first token ID to be transferred.
1833      * `quantity` - the amount to be transferred.
1834      *
1835      * Calling conditions:
1836      *
1837      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1838      * transferred to `to`.
1839      * - When `from` is zero, `tokenId` has been minted for `to`.
1840      * - When `to` is zero, `tokenId` has been burned by `from`.
1841      * - `from` and `to` are never both zero.
1842      */
1843     function _afterTokenTransfers(
1844         address from,
1845         address to,
1846         uint256 startTokenId,
1847         uint256 quantity
1848     ) internal virtual {}
1849 
1850     /**
1851      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1852      *
1853      * `from` - Previous owner of the given token ID.
1854      * `to` - Target address that will receive the token.
1855      * `tokenId` - Token ID to be transferred.
1856      * `_data` - Optional data to send along with the call.
1857      *
1858      * Returns whether the call correctly returned the expected magic value.
1859      */
1860     function _checkContractOnERC721Received(
1861         address from,
1862         address to,
1863         uint256 tokenId,
1864         bytes memory _data
1865     ) private returns (bool) {
1866         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1867             bytes4 retval
1868         ) {
1869             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1870         } catch (bytes memory reason) {
1871             if (reason.length == 0) {
1872                 revert TransferToNonERC721ReceiverImplementer();
1873             } else {
1874                 assembly {
1875                     revert(add(32, reason), mload(reason))
1876                 }
1877             }
1878         }
1879     }
1880 
1881     // =============================================================
1882     //                        MINT OPERATIONS
1883     // =============================================================
1884 
1885     /**
1886      * @dev Mints `quantity` tokens and transfers them to `to`.
1887      *
1888      * Requirements:
1889      *
1890      * - `to` cannot be the zero address.
1891      * - `quantity` must be greater than 0.
1892      *
1893      * Emits a {Transfer} event for each mint.
1894      */
1895     function _mint(address to, uint256 quantity) internal virtual {
1896         uint256 startTokenId = _currentIndex;
1897         if (quantity == 0) revert MintZeroQuantity();
1898 
1899         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1900 
1901         // Overflows are incredibly unrealistic.
1902         // `balance` and `numberMinted` have a maximum limit of 2**64.
1903         // `tokenId` has a maximum limit of 2**256.
1904         unchecked {
1905             // Updates:
1906             // - `balance += quantity`.
1907             // - `numberMinted += quantity`.
1908             //
1909             // We can directly add to the `balance` and `numberMinted`.
1910             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1911 
1912             // Updates:
1913             // - `address` to the owner.
1914             // - `startTimestamp` to the timestamp of minting.
1915             // - `burned` to `false`.
1916             // - `nextInitialized` to `quantity == 1`.
1917             _packedOwnerships[startTokenId] = _packOwnershipData(
1918                 to,
1919                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1920             );
1921 
1922             uint256 toMasked;
1923             uint256 end = startTokenId + quantity;
1924 
1925             // Use assembly to loop and emit the `Transfer` event for gas savings.
1926             // The duplicated `log4` removes an extra check and reduces stack juggling.
1927             // The assembly, together with the surrounding Solidity code, have been
1928             // delicately arranged to nudge the compiler into producing optimized opcodes.
1929             assembly {
1930                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1931                 toMasked := and(to, _BITMASK_ADDRESS)
1932                 // Emit the `Transfer` event.
1933                 log4(
1934                     0, // Start of data (0, since no data).
1935                     0, // End of data (0, since no data).
1936                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1937                     0, // `address(0)`.
1938                     toMasked, // `to`.
1939                     startTokenId // `tokenId`.
1940                 )
1941 
1942                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1943                 // that overflows uint256 will make the loop run out of gas.
1944                 // The compiler will optimize the `iszero` away for performance.
1945                 for {
1946                     let tokenId := add(startTokenId, 1)
1947                 } iszero(eq(tokenId, end)) {
1948                     tokenId := add(tokenId, 1)
1949                 } {
1950                     // Emit the `Transfer` event. Similar to above.
1951                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1952                 }
1953             }
1954             if (toMasked == 0) revert MintToZeroAddress();
1955 
1956             _currentIndex = end;
1957         }
1958         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1959     }
1960 
1961     /**
1962      * @dev Mints `quantity` tokens and transfers them to `to`.
1963      *
1964      * This function is intended for efficient minting only during contract creation.
1965      *
1966      * It emits only one {ConsecutiveTransfer} as defined in
1967      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1968      * instead of a sequence of {Transfer} event(s).
1969      *
1970      * Calling this function outside of contract creation WILL make your contract
1971      * non-compliant with the ERC721 standard.
1972      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1973      * {ConsecutiveTransfer} event is only permissible during contract creation.
1974      *
1975      * Requirements:
1976      *
1977      * - `to` cannot be the zero address.
1978      * - `quantity` must be greater than 0.
1979      *
1980      * Emits a {ConsecutiveTransfer} event.
1981      */
1982     function _mintERC2309(address to, uint256 quantity) internal virtual {
1983         uint256 startTokenId = _currentIndex;
1984         if (to == address(0)) revert MintToZeroAddress();
1985         if (quantity == 0) revert MintZeroQuantity();
1986         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1987 
1988         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1989 
1990         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1991         unchecked {
1992             // Updates:
1993             // - `balance += quantity`.
1994             // - `numberMinted += quantity`.
1995             //
1996             // We can directly add to the `balance` and `numberMinted`.
1997             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1998 
1999             // Updates:
2000             // - `address` to the owner.
2001             // - `startTimestamp` to the timestamp of minting.
2002             // - `burned` to `false`.
2003             // - `nextInitialized` to `quantity == 1`.
2004             _packedOwnerships[startTokenId] = _packOwnershipData(
2005                 to,
2006                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2007             );
2008 
2009             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2010 
2011             _currentIndex = startTokenId + quantity;
2012         }
2013         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2014     }
2015 
2016     /**
2017      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2018      *
2019      * Requirements:
2020      *
2021      * - If `to` refers to a smart contract, it must implement
2022      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2023      * - `quantity` must be greater than 0.
2024      *
2025      * See {_mint}.
2026      *
2027      * Emits a {Transfer} event for each mint.
2028      */
2029     function _safeMint(
2030         address to,
2031         uint256 quantity,
2032         bytes memory _data
2033     ) internal virtual {
2034         _mint(to, quantity);
2035 
2036         unchecked {
2037             if (to.code.length != 0) {
2038                 uint256 end = _currentIndex;
2039                 uint256 index = end - quantity;
2040                 do {
2041                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2042                         revert TransferToNonERC721ReceiverImplementer();
2043                     }
2044                 } while (index < end);
2045                 // Reentrancy protection.
2046                 if (_currentIndex != end) revert();
2047             }
2048         }
2049     }
2050 
2051     /**
2052      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2053      */
2054     function _safeMint(address to, uint256 quantity) internal virtual {
2055         _safeMint(to, quantity, '');
2056     }
2057 
2058     // =============================================================
2059     //                        BURN OPERATIONS
2060     // =============================================================
2061 
2062     /**
2063      * @dev Equivalent to `_burn(tokenId, false)`.
2064      */
2065     function _burn(uint256 tokenId) internal virtual {
2066         _burn(tokenId, false);
2067     }
2068 
2069     /**
2070      * @dev Destroys `tokenId`.
2071      * The approval is cleared when the token is burned.
2072      *
2073      * Requirements:
2074      *
2075      * - `tokenId` must exist.
2076      *
2077      * Emits a {Transfer} event.
2078      */
2079     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2080         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2081 
2082         address from = address(uint160(prevOwnershipPacked));
2083 
2084         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2085 
2086         if (approvalCheck) {
2087             // The nested ifs save around 20+ gas over a compound boolean condition.
2088             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2089                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2090         }
2091 
2092         _beforeTokenTransfers(from, address(0), tokenId, 1);
2093 
2094         // Clear approvals from the previous owner.
2095         assembly {
2096             if approvedAddress {
2097                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2098                 sstore(approvedAddressSlot, 0)
2099             }
2100         }
2101 
2102         // Underflow of the sender's balance is impossible because we check for
2103         // ownership above and the recipient's balance can't realistically overflow.
2104         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2105         unchecked {
2106             // Updates:
2107             // - `balance -= 1`.
2108             // - `numberBurned += 1`.
2109             //
2110             // We can directly decrement the balance, and increment the number burned.
2111             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2112             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2113 
2114             // Updates:
2115             // - `address` to the last owner.
2116             // - `startTimestamp` to the timestamp of burning.
2117             // - `burned` to `true`.
2118             // - `nextInitialized` to `true`.
2119             _packedOwnerships[tokenId] = _packOwnershipData(
2120                 from,
2121                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2122             );
2123 
2124             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2125             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2126                 uint256 nextTokenId = tokenId + 1;
2127                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2128                 if (_packedOwnerships[nextTokenId] == 0) {
2129                     // If the next slot is within bounds.
2130                     if (nextTokenId != _currentIndex) {
2131                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2132                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2133                     }
2134                 }
2135             }
2136         }
2137 
2138         emit Transfer(from, address(0), tokenId);
2139         _afterTokenTransfers(from, address(0), tokenId, 1);
2140 
2141         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2142         unchecked {
2143             _burnCounter++;
2144         }
2145     }
2146 
2147     // =============================================================
2148     //                     EXTRA DATA OPERATIONS
2149     // =============================================================
2150 
2151     /**
2152      * @dev Directly sets the extra data for the ownership data `index`.
2153      */
2154     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2155         uint256 packed = _packedOwnerships[index];
2156         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2157         uint256 extraDataCasted;
2158         // Cast `extraData` with assembly to avoid redundant masking.
2159         assembly {
2160             extraDataCasted := extraData
2161         }
2162         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2163         _packedOwnerships[index] = packed;
2164     }
2165 
2166     /**
2167      * @dev Called during each token transfer to set the 24bit `extraData` field.
2168      * Intended to be overridden by the cosumer contract.
2169      *
2170      * `previousExtraData` - the value of `extraData` before transfer.
2171      *
2172      * Calling conditions:
2173      *
2174      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2175      * transferred to `to`.
2176      * - When `from` is zero, `tokenId` will be minted for `to`.
2177      * - When `to` is zero, `tokenId` will be burned by `from`.
2178      * - `from` and `to` are never both zero.
2179      */
2180     function _extraData(
2181         address from,
2182         address to,
2183         uint24 previousExtraData
2184     ) internal view virtual returns (uint24) {}
2185 
2186     /**
2187      * @dev Returns the next extra data for the packed ownership data.
2188      * The returned result is shifted into position.
2189      */
2190     function _nextExtraData(
2191         address from,
2192         address to,
2193         uint256 prevOwnershipPacked
2194     ) private view returns (uint256) {
2195         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2196         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2197     }
2198 
2199     // =============================================================
2200     //                       OTHER OPERATIONS
2201     // =============================================================
2202 
2203     /**
2204      * @dev Returns the message sender (defaults to `msg.sender`).
2205      *
2206      * If you are writing GSN compatible contracts, you need to override this function.
2207      */
2208     function _msgSenderERC721A() internal view virtual returns (address) {
2209         return msg.sender;
2210     }
2211 
2212     /**
2213      * @dev Converts a uint256 to its ASCII string decimal representation.
2214      */
2215     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2216         assembly {
2217             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2218             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2219             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2220             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2221             let m := add(mload(0x40), 0xa0)
2222             // Update the free memory pointer to allocate.
2223             mstore(0x40, m)
2224             // Assign the `str` to the end.
2225             str := sub(m, 0x20)
2226             // Zeroize the slot after the string.
2227             mstore(str, 0)
2228 
2229             // Cache the end of the memory to calculate the length later.
2230             let end := str
2231 
2232             // We write the string from rightmost digit to leftmost digit.
2233             // The following is essentially a do-while loop that also handles the zero case.
2234             // prettier-ignore
2235             for { let temp := value } 1 {} {
2236                 str := sub(str, 1)
2237                 // Write the character to the pointer.
2238                 // The ASCII index of the '0' character is 48.
2239                 mstore8(str, add(48, mod(temp, 10)))
2240                 // Keep dividing `temp` until zero.
2241                 temp := div(temp, 10)
2242                 // prettier-ignore
2243                 if iszero(temp) { break }
2244             }
2245 
2246             let length := sub(end, str)
2247             // Move the pointer 32 bytes leftwards to make room for the length.
2248             str := sub(str, 0x20)
2249             // Store the length.
2250             mstore(str, length)
2251         }
2252     }
2253 }
2254 
2255 interface IOperatorFilter {
2256     function mayTransfer(address operator) external view returns (bool);
2257 }
2258 
2259 abstract contract ERC721OperatorFilter is ERC721A, Ownable, AccessControl {
2260     IOperatorFilter private operatorFilter_;
2261 
2262     constructor(
2263         string memory name_,
2264         string memory symbol_,
2265         address filter
2266     ) Ownable() ERC721A(name_, symbol_) AccessControl() {
2267         operatorFilter_ = IOperatorFilter(filter);
2268     }
2269 
2270     function setOperatorFilter(IOperatorFilter filter) public onlyRole(DEFAULT_ADMIN_ROLE) {
2271         operatorFilter_ = filter;
2272     }
2273 
2274     function operatorFilter() public view returns (IOperatorFilter) {
2275         return operatorFilter_;
2276     }
2277 
2278     function supportsInterface(bytes4 interfaceId)
2279         public
2280         view
2281         virtual
2282         override(ERC721A, AccessControl)
2283         returns (bool)
2284     {
2285         return
2286             interfaceId == type(AccessControl).interfaceId ||
2287             ERC721A.supportsInterface(interfaceId);
2288     }
2289 
2290     function _beforeTokenTransfers(
2291         address from,
2292         address to,
2293         uint256 startTokenId,
2294         uint256 quantity
2295     ) internal virtual override(ERC721A) {
2296         if (
2297             from != address(0) &&
2298             to != address(0) &&
2299             !_mayTransfer(msg.sender, startTokenId)
2300         ) {
2301             revert("ERC721OperatorFilter: illegal operator");
2302         }
2303         super._beforeTokenTransfers(from, to, startTokenId, quantity);
2304     }
2305 
2306     function _mayTransfer(address operator, uint256 tokenId)
2307         private
2308         view
2309         returns (bool)
2310     {
2311         IOperatorFilter filter = operatorFilter_;
2312         if (address(filter) == address(0)) return true;
2313         if (operator == ownerOf(tokenId)) return true;
2314         return filter.mayTransfer(msg.sender);
2315     }
2316 }
2317 
2318 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2319 
2320 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2321 
2322 /**
2323  * @dev Interface for the NFT Royalty Standard.
2324  *
2325  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2326  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2327  *
2328  * _Available since v4.5._
2329  */
2330 interface IERC2981 is IERC165 {
2331     /**
2332      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2333      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2334      */
2335     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2336         external
2337         view
2338         returns (address receiver, uint256 royaltyAmount);
2339 }
2340 
2341 /**
2342  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2343  *
2344  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2345  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2346  *
2347  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2348  * fee is specified in basis points by default.
2349  *
2350  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2351  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2352  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2353  *
2354  * _Available since v4.5._
2355  */
2356 abstract contract ERC2981 is IERC2981, ERC165 {
2357     struct RoyaltyInfo {
2358         address receiver;
2359         uint96 royaltyFraction;
2360     }
2361 
2362     RoyaltyInfo private _defaultRoyaltyInfo;
2363     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2364 
2365     /**
2366      * @dev See {IERC165-supportsInterface}.
2367      */
2368     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2369         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2370     }
2371 
2372     /**
2373      * @inheritdoc IERC2981
2374      */
2375     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2376         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2377 
2378         if (royalty.receiver == address(0)) {
2379             royalty = _defaultRoyaltyInfo;
2380         }
2381 
2382         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2383 
2384         return (royalty.receiver, royaltyAmount);
2385     }
2386 
2387     /**
2388      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2389      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2390      * override.
2391      */
2392     function _feeDenominator() internal pure virtual returns (uint96) {
2393         return 10000;
2394     }
2395 
2396     /**
2397      * @dev Sets the royalty information that all ids in this contract will default to.
2398      *
2399      * Requirements:
2400      *
2401      * - `receiver` cannot be the zero address.
2402      * - `feeNumerator` cannot be greater than the fee denominator.
2403      */
2404     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2405         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2406         require(receiver != address(0), "ERC2981: invalid receiver");
2407 
2408         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2409     }
2410 
2411     /**
2412      * @dev Removes default royalty information.
2413      */
2414     function _deleteDefaultRoyalty() internal virtual {
2415         delete _defaultRoyaltyInfo;
2416     }
2417 
2418     /**
2419      * @dev Sets the royalty information for a specific token id, overriding the global default.
2420      *
2421      * Requirements:
2422      *
2423      * - `receiver` cannot be the zero address.
2424      * - `feeNumerator` cannot be greater than the fee denominator.
2425      */
2426     function _setTokenRoyalty(
2427         uint256 tokenId,
2428         address receiver,
2429         uint96 feeNumerator
2430     ) internal virtual {
2431         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2432         require(receiver != address(0), "ERC2981: Invalid parameters");
2433 
2434         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2435     }
2436 
2437     /**
2438      * @dev Resets royalty information for the token id back to the global default.
2439      */
2440     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2441         delete _tokenRoyaltyInfo[tokenId];
2442     }
2443 }
2444 
2445 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
2446 
2447 /**
2448  * @dev These functions deal with verification of Merkle Tree proofs.
2449  *
2450  * The proofs can be generated using the JavaScript library
2451  * https://github.com/miguelmota/merkletreejs[merkletreejs].
2452  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
2453  *
2454  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
2455  *
2456  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2457  * hashing, or use a hash function other than keccak256 for hashing leaves.
2458  * This is because the concatenation of a sorted pair of internal nodes in
2459  * the merkle tree could be reinterpreted as a leaf value.
2460  */
2461 library MerkleProof {
2462     /**
2463      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2464      * defined by `root`. For this, a `proof` must be provided, containing
2465      * sibling hashes on the branch from the leaf to the root of the tree. Each
2466      * pair of leaves and each pair of pre-images are assumed to be sorted.
2467      */
2468     function verify(
2469         bytes32[] memory proof,
2470         bytes32 root,
2471         bytes32 leaf
2472     ) internal pure returns (bool) {
2473         return processProof(proof, leaf) == root;
2474     }
2475 
2476     /**
2477      * @dev Calldata version of {verify}
2478      *
2479      * _Available since v4.7._
2480      */
2481     function verifyCalldata(
2482         bytes32[] calldata proof,
2483         bytes32 root,
2484         bytes32 leaf
2485     ) internal pure returns (bool) {
2486         return processProofCalldata(proof, leaf) == root;
2487     }
2488 
2489     /**
2490      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2491      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2492      * hash matches the root of the tree. When processing the proof, the pairs
2493      * of leafs & pre-images are assumed to be sorted.
2494      *
2495      * _Available since v4.4._
2496      */
2497     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2498         bytes32 computedHash = leaf;
2499         for (uint256 i = 0; i < proof.length; i++) {
2500             computedHash = _hashPair(computedHash, proof[i]);
2501         }
2502         return computedHash;
2503     }
2504 
2505     /**
2506      * @dev Calldata version of {processProof}
2507      *
2508      * _Available since v4.7._
2509      */
2510     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2511         bytes32 computedHash = leaf;
2512         for (uint256 i = 0; i < proof.length; i++) {
2513             computedHash = _hashPair(computedHash, proof[i]);
2514         }
2515         return computedHash;
2516     }
2517 
2518     /**
2519      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2520      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2521      *
2522      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2523      *
2524      * _Available since v4.7._
2525      */
2526     function multiProofVerify(
2527         bytes32[] memory proof,
2528         bool[] memory proofFlags,
2529         bytes32 root,
2530         bytes32[] memory leaves
2531     ) internal pure returns (bool) {
2532         return processMultiProof(proof, proofFlags, leaves) == root;
2533     }
2534 
2535     /**
2536      * @dev Calldata version of {multiProofVerify}
2537      *
2538      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2539      *
2540      * _Available since v4.7._
2541      */
2542     function multiProofVerifyCalldata(
2543         bytes32[] calldata proof,
2544         bool[] calldata proofFlags,
2545         bytes32 root,
2546         bytes32[] memory leaves
2547     ) internal pure returns (bool) {
2548         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2549     }
2550 
2551     /**
2552      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2553      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2554      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2555      * respectively.
2556      *
2557      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2558      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2559      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2560      *
2561      * _Available since v4.7._
2562      */
2563     function processMultiProof(
2564         bytes32[] memory proof,
2565         bool[] memory proofFlags,
2566         bytes32[] memory leaves
2567     ) internal pure returns (bytes32 merkleRoot) {
2568         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2569         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2570         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2571         // the merkle tree.
2572         uint256 leavesLen = leaves.length;
2573         uint256 totalHashes = proofFlags.length;
2574 
2575         // Check proof validity.
2576         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2577 
2578         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2579         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2580         bytes32[] memory hashes = new bytes32[](totalHashes);
2581         uint256 leafPos = 0;
2582         uint256 hashPos = 0;
2583         uint256 proofPos = 0;
2584         // At each step, we compute the next hash using two values:
2585         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2586         //   get the next hash.
2587         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2588         //   `proof` array.
2589         for (uint256 i = 0; i < totalHashes; i++) {
2590             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2591             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2592             hashes[i] = _hashPair(a, b);
2593         }
2594 
2595         if (totalHashes > 0) {
2596             return hashes[totalHashes - 1];
2597         } else if (leavesLen > 0) {
2598             return leaves[0];
2599         } else {
2600             return proof[0];
2601         }
2602     }
2603 
2604     /**
2605      * @dev Calldata version of {processMultiProof}.
2606      *
2607      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2608      *
2609      * _Available since v4.7._
2610      */
2611     function processMultiProofCalldata(
2612         bytes32[] calldata proof,
2613         bool[] calldata proofFlags,
2614         bytes32[] memory leaves
2615     ) internal pure returns (bytes32 merkleRoot) {
2616         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2617         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2618         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2619         // the merkle tree.
2620         uint256 leavesLen = leaves.length;
2621         uint256 totalHashes = proofFlags.length;
2622 
2623         // Check proof validity.
2624         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2625 
2626         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2627         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2628         bytes32[] memory hashes = new bytes32[](totalHashes);
2629         uint256 leafPos = 0;
2630         uint256 hashPos = 0;
2631         uint256 proofPos = 0;
2632         // At each step, we compute the next hash using two values:
2633         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2634         //   get the next hash.
2635         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2636         //   `proof` array.
2637         for (uint256 i = 0; i < totalHashes; i++) {
2638             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2639             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2640             hashes[i] = _hashPair(a, b);
2641         }
2642 
2643         if (totalHashes > 0) {
2644             return hashes[totalHashes - 1];
2645         } else if (leavesLen > 0) {
2646             return leaves[0];
2647         } else {
2648             return proof[0];
2649         }
2650     }
2651 
2652     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2653         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2654     }
2655 
2656     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2657         /// @solidity memory-safe-assembly
2658         assembly {
2659             mstore(0x00, a)
2660             mstore(0x20, b)
2661             value := keccak256(0x00, 0x40)
2662         }
2663     }
2664 }
2665 
2666 interface IMortiverse {
2667     error InvalidETHQuantity();
2668     error MaxSupply();
2669     error NonExistentTokenURI();
2670     error WithdrawTransfer();
2671     error NotInAllowlist();
2672     error ExceedsMintAllowance();
2673     error InvalidURI();
2674     error LengthsMismatch();
2675     error NotAllowlistPhase();
2676     error NotPublicPhase();
2677     error PublicSaleMustStartAfterAllowlist();
2678     error NewAllowanceLowerThanActual();
2679     error IllegalOperator();
2680 }
2681 
2682 contract Mortiverse is
2683     ERC721OperatorFilter,
2684     ERC2981,
2685     IMortiverse
2686 {
2687     struct SaleConfig {
2688         uint128 allowlist;
2689         uint128 publicSale;
2690     }
2691 
2692     enum Phase {
2693         CLOSED,
2694         ALLOWLIST,
2695         PUBLIC,
2696         OVER
2697     }
2698 
2699     uint256 public constant TOTAL_SUPPLY = 5555;
2700     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
2701 
2702     string public contractURI = "ipfs://QmR2y7P2m9cbmtc31LskvVcbn2qxJPWNE4EvrioJJjPukJ";
2703     string public baseURI = "ipfs://QmWpxg6xzYgZhdzoejrp8HFxUppr8sPQaV6kE5XasfuZeX/";
2704 
2705     uint256 public price = 0.029 ether;
2706     uint256 public mintAllowance = 2;
2707 
2708     bytes32 public allowlistMerkleRoot;
2709 
2710     SaleConfig public saleConfig;
2711 
2712     modifier isMintable(uint256 quantity) {
2713         if (price * quantity != msg.value) {
2714             revert InvalidETHQuantity();
2715         }
2716         if (_totalMinted() + quantity > TOTAL_SUPPLY) {
2717             revert MaxSupply();
2718         }
2719         if (_getAux(msg.sender) + quantity > mintAllowance) {
2720             revert ExceedsMintAllowance();
2721         }
2722         _;
2723     }
2724 
2725     constructor(
2726         address owner_,
2727         address manager_,
2728         uint256 initialQty_,
2729         address filter_
2730     ) ERC721OperatorFilter("Mortiverse", "MORTI", filter_) {
2731         _grantRole(DEFAULT_ADMIN_ROLE, owner_);
2732         _grantRole(DEFAULT_ADMIN_ROLE, manager_);
2733         _grantRole(MANAGER_ROLE, owner_);
2734         _grantRole(MANAGER_ROLE, manager_);
2735         _setDefaultRoyalty(owner_, 750);
2736         saleConfig = SaleConfig(1665779000, 1665789000);
2737         if(initialQty_ > 0) {
2738             _mintERC2309(owner_, initialQty_);
2739         }
2740         _transferOwnership(manager_);
2741     }
2742 
2743     function allowlistMint(bytes32[] calldata merkleProof, uint64 quantity)
2744         external
2745         payable
2746         isMintable(quantity)
2747     {
2748         if (currentPhase() != Phase.ALLOWLIST) revert NotAllowlistPhase();
2749         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2750         if (!MerkleProof.verify(merkleProof, allowlistMerkleRoot, leaf)) {
2751             revert NotInAllowlist();
2752         }
2753         _setAux(msg.sender, _getAux(msg.sender) + quantity);
2754         _safeMint(msg.sender, quantity);
2755     }
2756 
2757     function mint(uint64 quantity) external payable isMintable(quantity) {
2758         if (currentPhase() != Phase.PUBLIC) revert NotPublicPhase();
2759         _setAux(msg.sender, _getAux(msg.sender) + quantity);
2760         _safeMint(msg.sender, quantity);
2761     }
2762 
2763     function ownerMint(address recipient, uint256 quantity)
2764         external
2765         onlyRole(DEFAULT_ADMIN_ROLE)
2766     {
2767         _safeMint(recipient, quantity);
2768     }
2769 
2770     function airdrop(
2771         address[] calldata receivers,
2772         uint256[] calldata quantities
2773     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
2774         if (receivers.length != quantities.length) revert LengthsMismatch();
2775         uint256 total;
2776         for (uint256 i = 0; i < quantities.length; i++) {
2777             total += quantities[i];
2778         }
2779         if (_totalMinted() + total > TOTAL_SUPPLY) revert MaxSupply();
2780         for (uint256 i = 0; i < receivers.length; i++) {
2781             _safeMint(receivers[i], quantities[i]);
2782         }
2783     }
2784 
2785     function setContractURI(string calldata _contractURI)
2786         external
2787         onlyRole(MANAGER_ROLE)
2788     {
2789         if (bytes(_contractURI).length == 0) {
2790             revert InvalidURI();
2791         }
2792         contractURI = _contractURI;
2793     }
2794 
2795     function setBaseURI(string calldata _baseURI)
2796         external
2797         onlyRole(MANAGER_ROLE)
2798     {
2799         if (bytes(_baseURI).length == 0) {
2800             revert InvalidURI();
2801         }
2802         baseURI = _baseURI;
2803     }
2804 
2805     function setSaleConfig(uint128 allowlistTimestamp, uint128 publicTimestamp)
2806         external
2807         onlyRole(MANAGER_ROLE)
2808     {
2809         if (allowlistTimestamp >= publicTimestamp)
2810             revert PublicSaleMustStartAfterAllowlist();
2811         saleConfig = SaleConfig(allowlistTimestamp, publicTimestamp);
2812     }
2813 
2814     function setAllowlistRoot(bytes32 merkleRoot)
2815         external
2816         onlyRole(MANAGER_ROLE)
2817     {
2818         allowlistMerkleRoot = merkleRoot;
2819     }
2820 
2821     function setDefaultAdmin() external onlyOwner {
2822         _grantRole(DEFAULT_ADMIN_ROLE, owner());
2823     }
2824 
2825     function withdrawPayments(address payable payee)
2826         external
2827         onlyRole(DEFAULT_ADMIN_ROLE)
2828     {
2829         uint256 balance = address(this).balance;
2830         (bool transferTx, ) = payee.call{value: balance}(""); // solhint-disable-line avoid-low-level-calls
2831         if (!transferTx) {
2832             revert WithdrawTransfer();
2833         }
2834     }
2835 
2836     /// @notice Sets the royalty information that all ids in this contract will default to.
2837     /// @dev Explain to a developer any extra details
2838     /// @param receiver cannot be the zero address.
2839     /// @param feeNumerator cannot be greater than the fee denominator.
2840     function setDefaultRoyalty(address receiver, uint96 feeNumerator)
2841         external
2842         onlyRole(DEFAULT_ADMIN_ROLE)
2843     {
2844         _setDefaultRoyalty(receiver, feeNumerator);
2845     }
2846 
2847     // @notice Sets the royalty information that token ids.
2848     /// @dev to Resets royalty information set _feeNumerator to 0
2849     /// @param tokenId the specific token id to Sets the royalty information for
2850     /// @param receiver the address that will receive the royalty
2851     /// @param feeNumerator cannot be greater than the fee denominator other case revert with InvalidFeeNumerator
2852     function setTokenRoyalty(
2853         uint256 tokenId,
2854         address receiver,
2855         uint96 feeNumerator
2856     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
2857         _setTokenRoyalty(tokenId, receiver, feeNumerator);
2858     }
2859 
2860     function setMintAllowance(uint256 allowance) external onlyRole(MANAGER_ROLE) {
2861         if(allowance <= mintAllowance) revert NewAllowanceLowerThanActual();
2862         mintAllowance = allowance;
2863     }
2864 
2865     function setPrice(uint256 newPrice) external onlyRole(MANAGER_ROLE) {
2866         price = newPrice;
2867     }
2868 
2869     function supportsInterface(bytes4 interfaceId)
2870         public
2871         view
2872         virtual
2873         override(ERC721OperatorFilter, ERC2981)
2874         returns (bool)
2875     {
2876         return
2877             interfaceId == 0x2a55205a || // ERC165 Interface ID for ERC2981
2878             ERC721OperatorFilter.supportsInterface(interfaceId);
2879     }
2880 
2881     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2882         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2883 
2884         return bytes(baseURI).length != 0 ? string(abi.encodePacked(string(abi.encodePacked(baseURI, _toString(tokenId))),".json")) : "";
2885     }
2886 
2887     // solhint-disable not-rely-on-time
2888     function currentPhase() public view returns (Phase) {
2889         if (_totalMinted() == TOTAL_SUPPLY) {
2890             return Phase.OVER;
2891         } else if (block.timestamp > saleConfig.publicSale) {
2892             return Phase.PUBLIC;
2893         } else if (block.timestamp > saleConfig.allowlist) {
2894             return Phase.ALLOWLIST;
2895         } else {
2896             return Phase.CLOSED;
2897         }
2898     }
2899     // solhint-enable
2900 
2901     function userAllowance(address user) public view returns (uint256) {
2902         return mintAllowance - _getAux(user);
2903     }
2904 
2905     function _startTokenId() internal view virtual override returns (uint256) {
2906         return 1;
2907     }
2908 }