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
626 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
627 
628 
629 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Interface of the ERC20 standard as defined in the EIP.
635  */
636 interface IERC20 {
637     /**
638      * @dev Emitted when `value` tokens are moved from one account (`from`) to
639      * another (`to`).
640      *
641      * Note that `value` may be zero.
642      */
643     event Transfer(address indexed from, address indexed to, uint256 value);
644 
645     /**
646      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
647      * a call to {approve}. `value` is the new allowance.
648      */
649     event Approval(address indexed owner, address indexed spender, uint256 value);
650 
651     /**
652      * @dev Returns the amount of tokens in existence.
653      */
654     function totalSupply() external view returns (uint256);
655 
656     /**
657      * @dev Returns the amount of tokens owned by `account`.
658      */
659     function balanceOf(address account) external view returns (uint256);
660 
661     /**
662      * @dev Moves `amount` tokens from the caller's account to `to`.
663      *
664      * Returns a boolean value indicating whether the operation succeeded.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transfer(address to, uint256 amount) external returns (bool);
669 
670     /**
671      * @dev Returns the remaining number of tokens that `spender` will be
672      * allowed to spend on behalf of `owner` through {transferFrom}. This is
673      * zero by default.
674      *
675      * This value changes when {approve} or {transferFrom} are called.
676      */
677     function allowance(address owner, address spender) external view returns (uint256);
678 
679     /**
680      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
681      *
682      * Returns a boolean value indicating whether the operation succeeded.
683      *
684      * IMPORTANT: Beware that changing an allowance with this method brings the risk
685      * that someone may use both the old and the new allowance by unfortunate
686      * transaction ordering. One possible solution to mitigate this race
687      * condition is to first reduce the spender's allowance to 0 and set the
688      * desired value afterwards:
689      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
690      *
691      * Emits an {Approval} event.
692      */
693     function approve(address spender, uint256 amount) external returns (bool);
694 
695     /**
696      * @dev Moves `amount` tokens from `from` to `to` using the
697      * allowance mechanism. `amount` is then deducted from the caller's
698      * allowance.
699      *
700      * Returns a boolean value indicating whether the operation succeeded.
701      *
702      * Emits a {Transfer} event.
703      */
704     function transferFrom(address from, address to, uint256 amount) external returns (bool);
705 }
706 
707 // File: @openzeppelin/contracts/utils/Context.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 /**
715  * @dev Provides information about the current execution context, including the
716  * sender of the transaction and its data. While these are generally available
717  * via msg.sender and msg.data, they should not be accessed in such a direct
718  * manner, since when dealing with meta-transactions the account sending and
719  * paying for execution may not be the actual sender (as far as an application
720  * is concerned).
721  *
722  * This contract is only required for intermediate, library-like contracts.
723  */
724 abstract contract Context {
725     function _msgSender() internal view virtual returns (address) {
726         return msg.sender;
727     }
728 
729     function _msgData() internal view virtual returns (bytes calldata) {
730         return msg.data;
731     }
732 }
733 
734 // File: @openzeppelin/contracts/access/AccessControl.sol
735 
736 
737 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 
742 
743 
744 
745 /**
746  * @dev Contract module that allows children to implement role-based access
747  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
748  * members except through off-chain means by accessing the contract event logs. Some
749  * applications may benefit from on-chain enumerability, for those cases see
750  * {AccessControlEnumerable}.
751  *
752  * Roles are referred to by their `bytes32` identifier. These should be exposed
753  * in the external API and be unique. The best way to achieve this is by
754  * using `public constant` hash digests:
755  *
756  * ```solidity
757  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
758  * ```
759  *
760  * Roles can be used to represent a set of permissions. To restrict access to a
761  * function call, use {hasRole}:
762  *
763  * ```solidity
764  * function foo() public {
765  *     require(hasRole(MY_ROLE, msg.sender));
766  *     ...
767  * }
768  * ```
769  *
770  * Roles can be granted and revoked dynamically via the {grantRole} and
771  * {revokeRole} functions. Each role has an associated admin role, and only
772  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
773  *
774  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
775  * that only accounts with this role will be able to grant or revoke other
776  * roles. More complex role relationships can be created by using
777  * {_setRoleAdmin}.
778  *
779  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
780  * grant and revoke this role. Extra precautions should be taken to secure
781  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
782  * to enforce additional security measures for this role.
783  */
784 abstract contract AccessControl is Context, IAccessControl, ERC165 {
785     struct RoleData {
786         mapping(address => bool) members;
787         bytes32 adminRole;
788     }
789 
790     mapping(bytes32 => RoleData) private _roles;
791 
792     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
793 
794     /**
795      * @dev Modifier that checks that an account has a specific role. Reverts
796      * with a standardized message including the required role.
797      *
798      * The format of the revert reason is given by the following regular expression:
799      *
800      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
801      *
802      * _Available since v4.1._
803      */
804     modifier onlyRole(bytes32 role) {
805         _checkRole(role);
806         _;
807     }
808 
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
813         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
814     }
815 
816     /**
817      * @dev Returns `true` if `account` has been granted `role`.
818      */
819     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
820         return _roles[role].members[account];
821     }
822 
823     /**
824      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
825      * Overriding this function changes the behavior of the {onlyRole} modifier.
826      *
827      * Format of the revert message is described in {_checkRole}.
828      *
829      * _Available since v4.6._
830      */
831     function _checkRole(bytes32 role) internal view virtual {
832         _checkRole(role, _msgSender());
833     }
834 
835     /**
836      * @dev Revert with a standard message if `account` is missing `role`.
837      *
838      * The format of the revert reason is given by the following regular expression:
839      *
840      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
841      */
842     function _checkRole(bytes32 role, address account) internal view virtual {
843         if (!hasRole(role, account)) {
844             revert(
845                 string(
846                     abi.encodePacked(
847                         "AccessControl: account ",
848                         Strings.toHexString(account),
849                         " is missing role ",
850                         Strings.toHexString(uint256(role), 32)
851                     )
852                 )
853             );
854         }
855     }
856 
857     /**
858      * @dev Returns the admin role that controls `role`. See {grantRole} and
859      * {revokeRole}.
860      *
861      * To change a role's admin, use {_setRoleAdmin}.
862      */
863     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
864         return _roles[role].adminRole;
865     }
866 
867     /**
868      * @dev Grants `role` to `account`.
869      *
870      * If `account` had not been already granted `role`, emits a {RoleGranted}
871      * event.
872      *
873      * Requirements:
874      *
875      * - the caller must have ``role``'s admin role.
876      *
877      * May emit a {RoleGranted} event.
878      */
879     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
880         _grantRole(role, account);
881     }
882 
883     /**
884      * @dev Revokes `role` from `account`.
885      *
886      * If `account` had been granted `role`, emits a {RoleRevoked} event.
887      *
888      * Requirements:
889      *
890      * - the caller must have ``role``'s admin role.
891      *
892      * May emit a {RoleRevoked} event.
893      */
894     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
895         _revokeRole(role, account);
896     }
897 
898     /**
899      * @dev Revokes `role` from the calling account.
900      *
901      * Roles are often managed via {grantRole} and {revokeRole}: this function's
902      * purpose is to provide a mechanism for accounts to lose their privileges
903      * if they are compromised (such as when a trusted device is misplaced).
904      *
905      * If the calling account had been revoked `role`, emits a {RoleRevoked}
906      * event.
907      *
908      * Requirements:
909      *
910      * - the caller must be `account`.
911      *
912      * May emit a {RoleRevoked} event.
913      */
914     function renounceRole(bytes32 role, address account) public virtual override {
915         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
916 
917         _revokeRole(role, account);
918     }
919 
920     /**
921      * @dev Grants `role` to `account`.
922      *
923      * If `account` had not been already granted `role`, emits a {RoleGranted}
924      * event. Note that unlike {grantRole}, this function doesn't perform any
925      * checks on the calling account.
926      *
927      * May emit a {RoleGranted} event.
928      *
929      * [WARNING]
930      * ====
931      * This function should only be called from the constructor when setting
932      * up the initial roles for the system.
933      *
934      * Using this function in any other way is effectively circumventing the admin
935      * system imposed by {AccessControl}.
936      * ====
937      *
938      * NOTE: This function is deprecated in favor of {_grantRole}.
939      */
940     function _setupRole(bytes32 role, address account) internal virtual {
941         _grantRole(role, account);
942     }
943 
944     /**
945      * @dev Sets `adminRole` as ``role``'s admin role.
946      *
947      * Emits a {RoleAdminChanged} event.
948      */
949     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
950         bytes32 previousAdminRole = getRoleAdmin(role);
951         _roles[role].adminRole = adminRole;
952         emit RoleAdminChanged(role, previousAdminRole, adminRole);
953     }
954 
955     /**
956      * @dev Grants `role` to `account`.
957      *
958      * Internal function without access restriction.
959      *
960      * May emit a {RoleGranted} event.
961      */
962     function _grantRole(bytes32 role, address account) internal virtual {
963         if (!hasRole(role, account)) {
964             _roles[role].members[account] = true;
965             emit RoleGranted(role, account, _msgSender());
966         }
967     }
968 
969     /**
970      * @dev Revokes `role` from `account`.
971      *
972      * Internal function without access restriction.
973      *
974      * May emit a {RoleRevoked} event.
975      */
976     function _revokeRole(bytes32 role, address account) internal virtual {
977         if (hasRole(role, account)) {
978             _roles[role].members[account] = false;
979             emit RoleRevoked(role, account, _msgSender());
980         }
981     }
982 }
983 
984 // File: @openzeppelin/contracts/access/Ownable.sol
985 
986 
987 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
988 
989 pragma solidity ^0.8.0;
990 
991 
992 /**
993  * @dev Contract module which provides a basic access control mechanism, where
994  * there is an account (an owner) that can be granted exclusive access to
995  * specific functions.
996  *
997  * By default, the owner account will be the one that deploys the contract. This
998  * can later be changed with {transferOwnership}.
999  *
1000  * This module is used through inheritance. It will make available the modifier
1001  * `onlyOwner`, which can be applied to your functions to restrict their use to
1002  * the owner.
1003  */
1004 abstract contract Ownable is Context {
1005     address private _owner;
1006 
1007     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1008 
1009     /**
1010      * @dev Initializes the contract setting the deployer as the initial owner.
1011      */
1012     constructor() {
1013         _transferOwnership(_msgSender());
1014     }
1015 
1016     /**
1017      * @dev Throws if called by any account other than the owner.
1018      */
1019     modifier onlyOwner() {
1020         _checkOwner();
1021         _;
1022     }
1023 
1024     /**
1025      * @dev Returns the address of the current owner.
1026      */
1027     function owner() public view virtual returns (address) {
1028         return _owner;
1029     }
1030 
1031     /**
1032      * @dev Throws if the sender is not the owner.
1033      */
1034     function _checkOwner() internal view virtual {
1035         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1036     }
1037 
1038     /**
1039      * @dev Leaves the contract without owner. It will not be possible to call
1040      * `onlyOwner` functions. Can only be called by the current owner.
1041      *
1042      * NOTE: Renouncing ownership will leave the contract without an owner,
1043      * thereby disabling any functionality that is only available to the owner.
1044      */
1045     function renounceOwnership() public virtual onlyOwner {
1046         _transferOwnership(address(0));
1047     }
1048 
1049     /**
1050      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1051      * Can only be called by the current owner.
1052      */
1053     function transferOwnership(address newOwner) public virtual onlyOwner {
1054         require(newOwner != address(0), "Ownable: new owner is the zero address");
1055         _transferOwnership(newOwner);
1056     }
1057 
1058     /**
1059      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1060      * Internal function without access restriction.
1061      */
1062     function _transferOwnership(address newOwner) internal virtual {
1063         address oldOwner = _owner;
1064         _owner = newOwner;
1065         emit OwnershipTransferred(oldOwner, newOwner);
1066     }
1067 }
1068 
1069 // File: contracts/Money.sol
1070 
1071 
1072 
1073 pragma solidity =0.8.19;
1074 
1075 
1076 
1077 
1078 //////////////////////////////////////////////////////////////////////////////////////////
1079 //                                  INTERFACES                                          //
1080 //////////////////////////////////////////////////////////////////////////////////////////
1081 
1082 interface IFactoryV2 {
1083     event PairCreated(
1084         address indexed token0,
1085         address indexed token1,
1086         address lpPair,
1087         uint
1088     );
1089 
1090     function getPair(
1091         address tokenA,
1092         address tokenB
1093     ) external view returns (address lpPair);
1094 
1095     function createPair(
1096         address tokenA,
1097         address tokenB
1098     ) external returns (address lpPair);
1099 }
1100 
1101 interface IV2Pair {
1102     function factory() external view returns (address);
1103 
1104     function getReserves()
1105         external
1106         view
1107         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1108 
1109     function sync() external;
1110 }
1111 
1112 interface IRouter01 {
1113     function factory() external pure returns (address);
1114 
1115     function WETH() external pure returns (address);
1116 
1117     function addLiquidityETH(
1118         address token,
1119         uint amountTokenDesired,
1120         uint amountTokenMin,
1121         uint amountETHMin,
1122         address to,
1123         uint deadline
1124     )
1125         external
1126         payable
1127         returns (uint amountToken, uint amountETH, uint liquidity);
1128 
1129     function addLiquidity(
1130         address tokenA,
1131         address tokenB,
1132         uint amountADesired,
1133         uint amountBDesired,
1134         uint amountAMin,
1135         uint amountBMin,
1136         address to,
1137         uint deadline
1138     ) external returns (uint amountA, uint amountB, uint liquidity);
1139 
1140     function swapExactETHForTokens(
1141         uint amountOutMin,
1142         address[] calldata path,
1143         address to,
1144         uint deadline
1145     ) external payable returns (uint[] memory amounts);
1146 
1147     function getAmountsOut(
1148         uint amountIn,
1149         address[] calldata path
1150     ) external view returns (uint[] memory amounts);
1151 
1152     function getAmountsIn(
1153         uint amountOut,
1154         address[] calldata path
1155     ) external view returns (uint[] memory amounts);
1156 }
1157 
1158 interface IRouter02 is IRouter01 {
1159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1160         uint amountIn,
1161         uint amountOutMin,
1162         address[] calldata path,
1163         address to,
1164         uint deadline
1165     ) external;
1166 
1167     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1168         uint amountOutMin,
1169         address[] calldata path,
1170         address to,
1171         uint deadline
1172     ) external payable;
1173 
1174     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1175         uint amountIn,
1176         uint amountOutMin,
1177         address[] calldata path,
1178         address to,
1179         uint deadline
1180     ) external;
1181 
1182     function swapExactTokensForTokens(
1183         uint amountIn,
1184         uint amountOutMin,
1185         address[] calldata path,
1186         address to,
1187         uint deadline
1188     ) external returns (uint[] memory amounts);
1189 }
1190 
1191 //////////////////////////////////////////////////////////////////////////////////////////
1192 //                                  MAIN                                                //
1193 //////////////////////////////////////////////////////////////////////////////////////////
1194 
1195 contract Money is Context, Ownable, AccessControl, IERC20 {
1196     bytes32 public constant JANNY_ROLE = keccak256("JANNY_ROLE");
1197 
1198     function totalSupply() external view override returns (uint256) {
1199         return _totalSupply;
1200     }
1201 
1202     function decimals() external pure returns (uint8) {
1203         return _decimals;
1204     }
1205 
1206     function symbol() external pure returns (string memory) {
1207         return _symbol;
1208     }
1209 
1210     function name() external pure returns (string memory) {
1211         return _name;
1212     }
1213 
1214     function getOwner() external view returns (address) {
1215         return owner();
1216     }
1217 
1218     function allowance(
1219         address holder,
1220         address spender
1221     ) external view override returns (uint256) {
1222         return allowances[holder][spender];
1223     }
1224 
1225     function balanceOf(address account) public view override returns (uint256) {
1226         return balance[account];
1227     }
1228 
1229     mapping(address => mapping(address => uint256)) private allowances;
1230     mapping(address => bool) private isNoTax;
1231     mapping(address => bool) private isLpPair;
1232     mapping(address => uint256) private balance;
1233 
1234     uint256 private swapThreshold = _totalSupply / 5_000;
1235 
1236     uint256 public _totalSupply = 1_000_000_000 * 10 ** 18;
1237     uint256 public originalSupply = _totalSupply;
1238     uint256 public buyTax = 275;
1239     uint256 public sellTax = 275;
1240     uint256 public constant taxDenominator = 10_000;
1241     address payable private devFundsAddress =
1242         payable(0x2447bA7d0996FaE5214bCEc6a2d4e6C3b1B18C07);
1243 
1244     uint256 private devAllocation = 30;
1245     uint256 private burnAllocation = 70;
1246 
1247     IRouter02 public swapRouter;
1248     string private constant _name = "MONEY";
1249     string private constant _symbol = "MONEY";
1250     uint8 private constant _decimals = 18;
1251     bool public isTradingEnabled;
1252     bool private inSwap;
1253     bool public taxCanChange = true;
1254 
1255     modifier inSwapFlag() {
1256         inSwap = true;
1257         _;
1258         inSwap = false;
1259     }
1260 
1261     event EnableTrading();
1262     event AddLpPair(address indexed newLpPair);
1263     event ChangeThreshold(uint256 indexed newThreshold);
1264     event ChangeDevFundsAddress(address indexed newAddress);
1265     event ChangeTaxes(uint256 indexed buyTax, uint256 indexed sellTax);
1266     event Burned(uint256 indexed tokensBurned);
1267     event NewSwapRouter(address indexed newRouter);
1268     event ToggleNoTaxAccount(address indexed account, bool enabled);
1269     event TotalSupplyChange(uint256 indexed totalSupply);
1270     event RemoveLpPair(address indexed pairToRemove);
1271 
1272     constructor() {
1273         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1274         _grantRole(JANNY_ROLE, msg.sender);
1275         isNoTax[msg.sender] = true;
1276         isNoTax[address(this)] = true;
1277 
1278         swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1279         balance[msg.sender] = _totalSupply;
1280         emit Transfer(address(0), msg.sender, _totalSupply);
1281     }
1282 
1283     receive() external payable {}
1284 
1285     ///@notice Locks the taxes permanently.
1286     function lockTaxes() external onlyOwner {
1287         taxCanChange = false;
1288     }
1289 
1290     function setSwapRouter(
1291         address newRouter,
1292         address newLpPair
1293     ) external onlyOwner {
1294         require(newRouter != address(0), "Zero Address");
1295         require(newLpPair != address(0), "Zero Address");
1296         require(newRouter != address(swapRouter), "Same router");
1297         swapRouter = IRouter02(newRouter);
1298         isLpPair[newLpPair] = true;
1299         _approve(msg.sender, address(swapRouter), type(uint256).max);
1300         _approve(address(this), address(swapRouter), type(uint256).max);
1301         emit AddLpPair(newLpPair);
1302         emit NewSwapRouter(newRouter);
1303     }
1304 
1305     function setSwapThreshold(
1306         uint256 newDenominator
1307     ) external onlyRole(JANNY_ROLE) {
1308         swapThreshold = _totalSupply / newDenominator;
1309         emit ChangeThreshold(swapThreshold);
1310     }
1311 
1312     function transfer(
1313         address recipient,
1314         uint256 amount
1315     ) public override returns (bool) {
1316         _transfer(msg.sender, recipient, amount);
1317         return true;
1318     }
1319 
1320     function approve(
1321         address spender,
1322         uint256 amount
1323     ) external override returns (bool) {
1324         _approve(msg.sender, spender, amount);
1325         return true;
1326     }
1327 
1328     function _approve(
1329         address sender,
1330         address spender,
1331         uint256 amount
1332     ) internal {
1333         require(sender != address(0), "Zero Address");
1334         require(spender != address(0), "Zero Address");
1335 
1336         allowances[sender][spender] = amount;
1337     }
1338 
1339     function transferFrom(
1340         address sender,
1341         address recipient,
1342         uint256 amount
1343     ) external override returns (bool) {
1344         if (allowances[sender][msg.sender] != type(uint256).max) {
1345             allowances[sender][msg.sender] -= amount;
1346         }
1347 
1348         return _transfer(sender, recipient, amount);
1349     }
1350 
1351     function isNoTaxAccount(address account) external view returns (bool) {
1352         return isNoTax[account];
1353     }
1354 
1355     function addNoTaxAccount(
1356         address account,
1357         bool enabled
1358     ) public onlyRole(JANNY_ROLE) {
1359         isNoTax[account] = enabled;
1360         emit ToggleNoTaxAccount(account, enabled);
1361     }
1362 
1363     function isLimitedAddress(
1364         address _in,
1365         address _out
1366     ) internal view returns (bool) {
1367         bool isLimited = _in != owner() &&
1368             _out != owner() &&
1369             tx.origin != owner() &&
1370             msg.sender != owner() &&
1371             _out != address(0) &&
1372             _out != address(this);
1373         return isLimited;
1374     }
1375 
1376     function isBuy(address _in, address _out) internal view returns (bool) {
1377         bool _isBuy = !isLpPair[_out] && isLpPair[_in];
1378         return _isBuy;
1379     }
1380 
1381     function isSell(address _in, address _out) internal view returns (bool) {
1382         bool _isSell = isLpPair[_out] && !isLpPair[_in];
1383         return _isSell;
1384     }
1385 
1386     function addLpPair(address newPair) external onlyRole(JANNY_ROLE) {
1387         isLpPair[newPair] = true;
1388         _approve(msg.sender, address(swapRouter), type(uint256).max);
1389         _approve(address(this), address(swapRouter), type(uint256).max);
1390         emit AddLpPair(newPair);
1391     }
1392 
1393     function removeLpPair(address pairToRemove) external onlyRole(JANNY_ROLE) {
1394         isLpPair[pairToRemove] = false;
1395         emit RemoveLpPair(pairToRemove);
1396     }
1397 
1398     function _transfer(
1399         address from,
1400         address to,
1401         uint256 amount
1402     ) internal returns (bool) {
1403         bool takeTax = true;
1404         require(to != address(0), "Transfer to the zero address");
1405         require(from != address(0), "Transfer from the zero address");
1406         require(amount > 0, "Transfer amount must be greater than zero");
1407 
1408         if (isLimitedAddress(from, to)) {
1409             require(isTradingEnabled, "Trading is not enabled");
1410         }
1411 
1412         if (isNoTax[from] || isNoTax[to]) {
1413             takeTax = false;
1414         }
1415         balance[from] -= amount;
1416         uint256 amountAfterFee = (takeTax)
1417             ? _takeTaxes(from, isBuy(from, to), isSell(from, to), amount)
1418             : amount;
1419         balance[to] += amountAfterFee;
1420         emit Transfer(from, to, amountAfterFee);
1421 
1422         return true;
1423     }
1424 
1425     function changeDevFundsAddress(address newAddress) external onlyOwner {
1426         devFundsAddress = payable(newAddress);
1427         emit ChangeDevFundsAddress(newAddress);
1428     }
1429 
1430     function _takeTaxes(
1431         address from,
1432         bool _isBuy,
1433         bool _isSell,
1434         uint256 amount
1435     ) internal returns (uint256) {
1436         uint256 tax;
1437         if (_isBuy) tax = buyTax;
1438         else if (_isSell) tax = sellTax;
1439         if (tax == 0) return amount;
1440         uint256 taxAmount = (amount * tax) / taxDenominator;
1441         if (taxAmount > 0) {
1442             balance[address(this)] += taxAmount;
1443             emit Transfer(from, address(this), taxAmount);
1444         }
1445         return amount - taxAmount;
1446     }
1447 
1448     function _internalSwap(
1449         uint256 tokensToSwap
1450     ) internal inSwapFlag returns (bool) {
1451         address[] memory path = new address[](2);
1452         path[0] = address(this);
1453         path[1] = swapRouter.WETH();
1454 
1455         if (
1456             allowances[address(this)][address(swapRouter)] != type(uint256).max
1457         ) {
1458             allowances[address(this)][address(swapRouter)] = type(uint256).max;
1459         }
1460 
1461         swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1462             tokensToSwap,
1463             0,
1464             path,
1465             address(this),
1466             block.timestamp
1467         );
1468 
1469         return true;
1470     }
1471 
1472     ///@notice Taxes are in basis points.
1473     function changeTaxes(
1474         uint256 _buyTax,
1475         uint256 _sellTax
1476     ) external onlyRole(JANNY_ROLE) {
1477         require(taxCanChange, "Tax cannot be changed");
1478         require(_buyTax % 25 == 0, "Tax must be modulo 25");
1479         require(_sellTax % 25 == 0, "Tax must be modulo 25");
1480         require((_sellTax <= 2000) && (_buyTax <= 2000), "Tax out of bounds");
1481 
1482         buyTax = _buyTax;
1483         sellTax = _sellTax;
1484         emit ChangeTaxes(buyTax, sellTax);
1485     }
1486 
1487     function enableTrading() external onlyOwner {
1488         require(!isTradingEnabled, "Trading already enabled");
1489         isTradingEnabled = true;
1490         emit EnableTrading();
1491     }
1492 
1493     ///@notice Calls the burn function and swaps the dev allocation for ETH.
1494     function thresholdUpkeep() external {
1495         uint256 contractTokenBalance = balanceOf(address(this));
1496         uint256 devAmount = (contractTokenBalance * devAllocation) / 100;
1497         uint256 burnAmount = (contractTokenBalance * burnAllocation) / 100;
1498         if (contractTokenBalance >= swapThreshold) {
1499             _internalSwap(devAmount);
1500             _burn(burnAmount);
1501         }
1502     }
1503 
1504     ///@notice Same as public burn but only for the Janny.
1505     function jannyUpkeep() external onlyRole(JANNY_ROLE) {
1506         uint256 contractTokenBalance = balanceOf(address(this));
1507         uint256 devAmount = (contractTokenBalance * devAllocation) / 100;
1508         uint256 burnAmount = (contractTokenBalance * burnAllocation) / 100;
1509         _internalSwap(devAmount);
1510         _burn(burnAmount);
1511     }
1512 
1513     function manualExtraction(uint256 gasAmount) external {
1514         bool success;
1515         uint256 amountETH = address(this).balance;
1516         if (gasAmount == 0) {
1517             gasAmount = 35000;
1518         }
1519         if (amountETH > 0)
1520             (success, ) = devFundsAddress.call{
1521                 value: amountETH,
1522                 gas: gasAmount
1523             }("");
1524     }
1525 
1526     function _burn(uint256 amount) internal returns (bool) {
1527         balance[address(this)] -= amount;
1528         _totalSupply -= amount;
1529         emit Burned(amount);
1530         emit TotalSupplyChange(_totalSupply);
1531         return true;
1532     }
1533 }