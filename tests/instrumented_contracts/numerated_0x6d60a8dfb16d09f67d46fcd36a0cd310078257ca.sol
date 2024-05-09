1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Standard math utilities missing in the Solidity language.
31  */
32 library Math {
33     enum Rounding {
34         Down, // Toward negative infinity
35         Up, // Toward infinity
36         Zero // Toward zero
37     }
38 
39     /**
40      * @dev Returns the largest of two numbers.
41      */
42     function max(uint256 a, uint256 b) internal pure returns (uint256) {
43         return a > b ? a : b;
44     }
45 
46     /**
47      * @dev Returns the smallest of two numbers.
48      */
49     function min(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a < b ? a : b;
51     }
52 
53     /**
54      * @dev Returns the average of two numbers. The result is rounded towards
55      * zero.
56      */
57     function average(uint256 a, uint256 b) internal pure returns (uint256) {
58         // (a + b) / 2 can overflow.
59         return (a & b) + (a ^ b) / 2;
60     }
61 
62     /**
63      * @dev Returns the ceiling of the division of two numbers.
64      *
65      * This differs from standard division with `/` in that it rounds up instead
66      * of rounding down.
67      */
68     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
69         // (a + b - 1) / b can overflow on addition, so we distribute.
70         return a == 0 ? 0 : (a - 1) / b + 1;
71     }
72 
73     /**
74      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
75      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
76      * with further edits by Uniswap Labs also under MIT license.
77      */
78     function mulDiv(
79         uint256 x,
80         uint256 y,
81         uint256 denominator
82     ) internal pure returns (uint256 result) {
83         unchecked {
84             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
85             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
86             // variables such that product = prod1 * 2^256 + prod0.
87             uint256 prod0; // Least significant 256 bits of the product
88             uint256 prod1; // Most significant 256 bits of the product
89             assembly {
90                 let mm := mulmod(x, y, not(0))
91                 prod0 := mul(x, y)
92                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
93             }
94 
95             // Handle non-overflow cases, 256 by 256 division.
96             if (prod1 == 0) {
97                 return prod0 / denominator;
98             }
99 
100             // Make sure the result is less than 2^256. Also prevents denominator == 0.
101             require(denominator > prod1);
102 
103             ///////////////////////////////////////////////
104             // 512 by 256 division.
105             ///////////////////////////////////////////////
106 
107             // Make division exact by subtracting the remainder from [prod1 prod0].
108             uint256 remainder;
109             assembly {
110                 // Compute remainder using mulmod.
111                 remainder := mulmod(x, y, denominator)
112 
113                 // Subtract 256 bit number from 512 bit number.
114                 prod1 := sub(prod1, gt(remainder, prod0))
115                 prod0 := sub(prod0, remainder)
116             }
117 
118             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
119             // See https://cs.stackexchange.com/q/138556/92363.
120 
121             // Does not overflow because the denominator cannot be zero at this stage in the function.
122             uint256 twos = denominator & (~denominator + 1);
123             assembly {
124                 // Divide denominator by twos.
125                 denominator := div(denominator, twos)
126 
127                 // Divide [prod1 prod0] by twos.
128                 prod0 := div(prod0, twos)
129 
130                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
131                 twos := add(div(sub(0, twos), twos), 1)
132             }
133 
134             // Shift in bits from prod1 into prod0.
135             prod0 |= prod1 * twos;
136 
137             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
138             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
139             // four bits. That is, denominator * inv = 1 mod 2^4.
140             uint256 inverse = (3 * denominator) ^ 2;
141 
142             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
143             // in modular arithmetic, doubling the correct bits in each step.
144             inverse *= 2 - denominator * inverse; // inverse mod 2^8
145             inverse *= 2 - denominator * inverse; // inverse mod 2^16
146             inverse *= 2 - denominator * inverse; // inverse mod 2^32
147             inverse *= 2 - denominator * inverse; // inverse mod 2^64
148             inverse *= 2 - denominator * inverse; // inverse mod 2^128
149             inverse *= 2 - denominator * inverse; // inverse mod 2^256
150 
151             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
152             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
153             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
154             // is no longer required.
155             result = prod0 * inverse;
156             return result;
157         }
158     }
159 
160     /**
161      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
162      */
163     function mulDiv(
164         uint256 x,
165         uint256 y,
166         uint256 denominator,
167         Rounding rounding
168     ) internal pure returns (uint256) {
169         uint256 result = mulDiv(x, y, denominator);
170         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
171             result += 1;
172         }
173         return result;
174     }
175 
176     /**
177      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
178      *
179      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
180      */
181     function sqrt(uint256 a) internal pure returns (uint256) {
182         if (a == 0) {
183             return 0;
184         }
185 
186         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
187         //
188         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
189         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
190         //
191         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
192         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
193         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
194         //
195         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
196         uint256 result = 1 << (log2(a) >> 1);
197 
198         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
199         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
200         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
201         // into the expected uint128 result.
202         unchecked {
203             result = (result + a / result) >> 1;
204             result = (result + a / result) >> 1;
205             result = (result + a / result) >> 1;
206             result = (result + a / result) >> 1;
207             result = (result + a / result) >> 1;
208             result = (result + a / result) >> 1;
209             result = (result + a / result) >> 1;
210             return min(result, a / result);
211         }
212     }
213 
214     /**
215      * @notice Calculates sqrt(a), following the selected rounding direction.
216      */
217     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
218         unchecked {
219             uint256 result = sqrt(a);
220             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
221         }
222     }
223 
224     /**
225      * @dev Return the log in base 2, rounded down, of a positive value.
226      * Returns 0 if given 0.
227      */
228     function log2(uint256 value) internal pure returns (uint256) {
229         uint256 result = 0;
230         unchecked {
231             if (value >> 128 > 0) {
232                 value >>= 128;
233                 result += 128;
234             }
235             if (value >> 64 > 0) {
236                 value >>= 64;
237                 result += 64;
238             }
239             if (value >> 32 > 0) {
240                 value >>= 32;
241                 result += 32;
242             }
243             if (value >> 16 > 0) {
244                 value >>= 16;
245                 result += 16;
246             }
247             if (value >> 8 > 0) {
248                 value >>= 8;
249                 result += 8;
250             }
251             if (value >> 4 > 0) {
252                 value >>= 4;
253                 result += 4;
254             }
255             if (value >> 2 > 0) {
256                 value >>= 2;
257                 result += 2;
258             }
259             if (value >> 1 > 0) {
260                 result += 1;
261             }
262         }
263         return result;
264     }
265 
266     /**
267      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
268      * Returns 0 if given 0.
269      */
270     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
271         unchecked {
272             uint256 result = log2(value);
273             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
274         }
275     }
276 
277     /**
278      * @dev Return the log in base 10, rounded down, of a positive value.
279      * Returns 0 if given 0.
280      */
281     function log10(uint256 value) internal pure returns (uint256) {
282         uint256 result = 0;
283         unchecked {
284             if (value >= 10**64) {
285                 value /= 10**64;
286                 result += 64;
287             }
288             if (value >= 10**32) {
289                 value /= 10**32;
290                 result += 32;
291             }
292             if (value >= 10**16) {
293                 value /= 10**16;
294                 result += 16;
295             }
296             if (value >= 10**8) {
297                 value /= 10**8;
298                 result += 8;
299             }
300             if (value >= 10**4) {
301                 value /= 10**4;
302                 result += 4;
303             }
304             if (value >= 10**2) {
305                 value /= 10**2;
306                 result += 2;
307             }
308             if (value >= 10**1) {
309                 result += 1;
310             }
311         }
312         return result;
313     }
314 
315     /**
316      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
317      * Returns 0 if given 0.
318      */
319     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
320         unchecked {
321             uint256 result = log10(value);
322             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
323         }
324     }
325 
326     /**
327      * @dev Return the log in base 256, rounded down, of a positive value.
328      * Returns 0 if given 0.
329      *
330      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
331      */
332     function log256(uint256 value) internal pure returns (uint256) {
333         uint256 result = 0;
334         unchecked {
335             if (value >> 128 > 0) {
336                 value >>= 128;
337                 result += 16;
338             }
339             if (value >> 64 > 0) {
340                 value >>= 64;
341                 result += 8;
342             }
343             if (value >> 32 > 0) {
344                 value >>= 32;
345                 result += 4;
346             }
347             if (value >> 16 > 0) {
348                 value >>= 16;
349                 result += 2;
350             }
351             if (value >> 8 > 0) {
352                 result += 1;
353             }
354         }
355         return result;
356     }
357 
358     /**
359      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
360      * Returns 0 if given 0.
361      */
362     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
363         unchecked {
364             uint256 result = log256(value);
365             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
366         }
367     }
368 }
369 
370 
371 
372 
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Implementation of the {IERC165} interface.
379  *
380  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
381  * for the additional interface id that will be supported. For example:
382  *
383  * ```solidity
384  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
385  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
386  * }
387  * ```
388  *
389  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
390  */
391 abstract contract ERC165 is IERC165 {
392     /**
393      * @dev See {IERC165-supportsInterface}.
394      */
395     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
396         return interfaceId == type(IERC165).interfaceId;
397     }
398 }
399 
400 
401 
402 
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev String operations.
409  */
410 library Strings {
411     bytes16 private constant _SYMBOLS = "0123456789abcdef";
412     uint8 private constant _ADDRESS_LENGTH = 20;
413 
414     /**
415      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
416      */
417     function toString(uint256 value) internal pure returns (string memory) {
418         unchecked {
419             uint256 length = Math.log10(value) + 1;
420             string memory buffer = new string(length);
421             uint256 ptr;
422             /// @solidity memory-safe-assembly
423             assembly {
424                 ptr := add(buffer, add(32, length))
425             }
426             while (true) {
427                 ptr--;
428                 /// @solidity memory-safe-assembly
429                 assembly {
430                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
431                 }
432                 value /= 10;
433                 if (value == 0) break;
434             }
435             return buffer;
436         }
437     }
438 
439     /**
440      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
441      */
442     function toHexString(uint256 value) internal pure returns (string memory) {
443         unchecked {
444             return toHexString(value, Math.log256(value) + 1);
445         }
446     }
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
450      */
451     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
452         bytes memory buffer = new bytes(2 * length + 2);
453         buffer[0] = "0";
454         buffer[1] = "x";
455         for (uint256 i = 2 * length + 1; i > 1; --i) {
456             buffer[i] = _SYMBOLS[value & 0xf];
457             value >>= 4;
458         }
459         require(value == 0, "Strings: hex length insufficient");
460         return string(buffer);
461     }
462 
463     /**
464      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
465      */
466     function toHexString(address addr) internal pure returns (string memory) {
467         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
468     }
469 }
470 
471 
472 
473 
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Provides information about the current execution context, including the
479  * sender of the transaction and its data. While these are generally available
480  * via msg.sender and msg.data, they should not be accessed in such a direct
481  * manner, since when dealing with meta-transactions the account sending and
482  * paying for execution may not be the actual sender (as far as an application
483  * is concerned).
484  *
485  * This contract is only required for intermediate, library-like contracts.
486  */
487 abstract contract Context {
488     function _msgSender() internal view virtual returns (address) {
489         return msg.sender;
490     }
491 
492     function _msgData() internal view virtual returns (bytes calldata) {
493         return msg.data;
494     }
495 }
496 
497 
498 
499 
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev External interface of AccessControl declared to support ERC165 detection.
505  */
506 interface IAccessControl {
507     /**
508      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
509      *
510      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
511      * {RoleAdminChanged} not being emitted signaling this.
512      *
513      * _Available since v3.1._
514      */
515     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
516 
517     /**
518      * @dev Emitted when `account` is granted `role`.
519      *
520      * `sender` is the account that originated the contract call, an admin role
521      * bearer except when using {AccessControl-_setupRole}.
522      */
523     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
524 
525     /**
526      * @dev Emitted when `account` is revoked `role`.
527      *
528      * `sender` is the account that originated the contract call:
529      *   - if using `revokeRole`, it is the admin role bearer
530      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
531      */
532     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
533 
534     /**
535      * @dev Returns `true` if `account` has been granted `role`.
536      */
537     function hasRole(bytes32 role, address account) external view returns (bool);
538 
539     /**
540      * @dev Returns the admin role that controls `role`. See {grantRole} and
541      * {revokeRole}.
542      *
543      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
544      */
545     function getRoleAdmin(bytes32 role) external view returns (bytes32);
546 
547     /**
548      * @dev Grants `role` to `account`.
549      *
550      * If `account` had not been already granted `role`, emits a {RoleGranted}
551      * event.
552      *
553      * Requirements:
554      *
555      * - the caller must have ``role``'s admin role.
556      */
557     function grantRole(bytes32 role, address account) external;
558 
559     /**
560      * @dev Revokes `role` from `account`.
561      *
562      * If `account` had been granted `role`, emits a {RoleRevoked} event.
563      *
564      * Requirements:
565      *
566      * - the caller must have ``role``'s admin role.
567      */
568     function revokeRole(bytes32 role, address account) external;
569 
570     /**
571      * @dev Revokes `role` from the calling account.
572      *
573      * Roles are often managed via {grantRole} and {revokeRole}: this function's
574      * purpose is to provide a mechanism for accounts to lose their privileges
575      * if they are compromised (such as when a trusted device is misplaced).
576      *
577      * If the calling account had been granted `role`, emits a {RoleRevoked}
578      * event.
579      *
580      * Requirements:
581      *
582      * - the caller must be `account`.
583      */
584     function renounceRole(bytes32 role, address account) external;
585 }
586 
587 
588 
589 
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Library for managing
595  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
596  * types.
597  *
598  * Sets have the following properties:
599  *
600  * - Elements are added, removed, and checked for existence in constant time
601  * (O(1)).
602  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
603  *
604  * ```
605  * contract Example {
606  *     // Add the library methods
607  *     using EnumerableSet for EnumerableSet.AddressSet;
608  *
609  *     // Declare a set state variable
610  *     EnumerableSet.AddressSet private mySet;
611  * }
612  * ```
613  *
614  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
615  * and `uint256` (`UintSet`) are supported.
616  *
617  * [WARNING]
618  * ====
619  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
620  * unusable.
621  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
622  *
623  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
624  * array of EnumerableSet.
625  * ====
626  */
627 library EnumerableSet {
628     // To implement this library for multiple types with as little code
629     // repetition as possible, we write it in terms of a generic Set type with
630     // bytes32 values.
631     // The Set implementation uses private functions, and user-facing
632     // implementations (such as AddressSet) are just wrappers around the
633     // underlying Set.
634     // This means that we can only create new EnumerableSets for types that fit
635     // in bytes32.
636 
637     struct Set {
638         // Storage of set values
639         bytes32[] _values;
640         // Position of the value in the `values` array, plus 1 because index 0
641         // means a value is not in the set.
642         mapping(bytes32 => uint256) _indexes;
643     }
644 
645     /**
646      * @dev Add a value to a set. O(1).
647      *
648      * Returns true if the value was added to the set, that is if it was not
649      * already present.
650      */
651     function _add(Set storage set, bytes32 value) private returns (bool) {
652         if (!_contains(set, value)) {
653             set._values.push(value);
654             // The value is stored at length-1, but we add 1 to all indexes
655             // and use 0 as a sentinel value
656             set._indexes[value] = set._values.length;
657             return true;
658         } else {
659             return false;
660         }
661     }
662 
663     /**
664      * @dev Removes a value from a set. O(1).
665      *
666      * Returns true if the value was removed from the set, that is if it was
667      * present.
668      */
669     function _remove(Set storage set, bytes32 value) private returns (bool) {
670         // We read and store the value's index to prevent multiple reads from the same storage slot
671         uint256 valueIndex = set._indexes[value];
672 
673         if (valueIndex != 0) {
674             // Equivalent to contains(set, value)
675             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
676             // the array, and then remove the last element (sometimes called as 'swap and pop').
677             // This modifies the order of the array, as noted in {at}.
678 
679             uint256 toDeleteIndex = valueIndex - 1;
680             uint256 lastIndex = set._values.length - 1;
681 
682             if (lastIndex != toDeleteIndex) {
683                 bytes32 lastValue = set._values[lastIndex];
684 
685                 // Move the last value to the index where the value to delete is
686                 set._values[toDeleteIndex] = lastValue;
687                 // Update the index for the moved value
688                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
689             }
690 
691             // Delete the slot where the moved value was stored
692             set._values.pop();
693 
694             // Delete the index for the deleted slot
695             delete set._indexes[value];
696 
697             return true;
698         } else {
699             return false;
700         }
701     }
702 
703     /**
704      * @dev Returns true if the value is in the set. O(1).
705      */
706     function _contains(Set storage set, bytes32 value) private view returns (bool) {
707         return set._indexes[value] != 0;
708     }
709 
710     /**
711      * @dev Returns the number of values on the set. O(1).
712      */
713     function _length(Set storage set) private view returns (uint256) {
714         return set._values.length;
715     }
716 
717     /**
718      * @dev Returns the value stored at position `index` in the set. O(1).
719      *
720      * Note that there are no guarantees on the ordering of values inside the
721      * array, and it may change when more values are added or removed.
722      *
723      * Requirements:
724      *
725      * - `index` must be strictly less than {length}.
726      */
727     function _at(Set storage set, uint256 index) private view returns (bytes32) {
728         return set._values[index];
729     }
730 
731     /**
732      * @dev Return the entire set in an array
733      *
734      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
735      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
736      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
737      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
738      */
739     function _values(Set storage set) private view returns (bytes32[] memory) {
740         return set._values;
741     }
742 
743     // Bytes32Set
744 
745     struct Bytes32Set {
746         Set _inner;
747     }
748 
749     /**
750      * @dev Add a value to a set. O(1).
751      *
752      * Returns true if the value was added to the set, that is if it was not
753      * already present.
754      */
755     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
756         return _add(set._inner, value);
757     }
758 
759     /**
760      * @dev Removes a value from a set. O(1).
761      *
762      * Returns true if the value was removed from the set, that is if it was
763      * present.
764      */
765     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
766         return _remove(set._inner, value);
767     }
768 
769     /**
770      * @dev Returns true if the value is in the set. O(1).
771      */
772     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
773         return _contains(set._inner, value);
774     }
775 
776     /**
777      * @dev Returns the number of values in the set. O(1).
778      */
779     function length(Bytes32Set storage set) internal view returns (uint256) {
780         return _length(set._inner);
781     }
782 
783     /**
784      * @dev Returns the value stored at position `index` in the set. O(1).
785      *
786      * Note that there are no guarantees on the ordering of values inside the
787      * array, and it may change when more values are added or removed.
788      *
789      * Requirements:
790      *
791      * - `index` must be strictly less than {length}.
792      */
793     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
794         return _at(set._inner, index);
795     }
796 
797     /**
798      * @dev Return the entire set in an array
799      *
800      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
801      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
802      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
803      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
804      */
805     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
806         bytes32[] memory store = _values(set._inner);
807         bytes32[] memory result;
808 
809         /// @solidity memory-safe-assembly
810         assembly {
811             result := store
812         }
813 
814         return result;
815     }
816 
817     // AddressSet
818 
819     struct AddressSet {
820         Set _inner;
821     }
822 
823     /**
824      * @dev Add a value to a set. O(1).
825      *
826      * Returns true if the value was added to the set, that is if it was not
827      * already present.
828      */
829     function add(AddressSet storage set, address value) internal returns (bool) {
830         return _add(set._inner, bytes32(uint256(uint160(value))));
831     }
832 
833     /**
834      * @dev Removes a value from a set. O(1).
835      *
836      * Returns true if the value was removed from the set, that is if it was
837      * present.
838      */
839     function remove(AddressSet storage set, address value) internal returns (bool) {
840         return _remove(set._inner, bytes32(uint256(uint160(value))));
841     }
842 
843     /**
844      * @dev Returns true if the value is in the set. O(1).
845      */
846     function contains(AddressSet storage set, address value) internal view returns (bool) {
847         return _contains(set._inner, bytes32(uint256(uint160(value))));
848     }
849 
850     /**
851      * @dev Returns the number of values in the set. O(1).
852      */
853     function length(AddressSet storage set) internal view returns (uint256) {
854         return _length(set._inner);
855     }
856 
857     /**
858      * @dev Returns the value stored at position `index` in the set. O(1).
859      *
860      * Note that there are no guarantees on the ordering of values inside the
861      * array, and it may change when more values are added or removed.
862      *
863      * Requirements:
864      *
865      * - `index` must be strictly less than {length}.
866      */
867     function at(AddressSet storage set, uint256 index) internal view returns (address) {
868         return address(uint160(uint256(_at(set._inner, index))));
869     }
870 
871     /**
872      * @dev Return the entire set in an array
873      *
874      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
875      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
876      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
877      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
878      */
879     function values(AddressSet storage set) internal view returns (address[] memory) {
880         bytes32[] memory store = _values(set._inner);
881         address[] memory result;
882 
883         /// @solidity memory-safe-assembly
884         assembly {
885             result := store
886         }
887 
888         return result;
889     }
890 
891     // UintSet
892 
893     struct UintSet {
894         Set _inner;
895     }
896 
897     /**
898      * @dev Add a value to a set. O(1).
899      *
900      * Returns true if the value was added to the set, that is if it was not
901      * already present.
902      */
903     function add(UintSet storage set, uint256 value) internal returns (bool) {
904         return _add(set._inner, bytes32(value));
905     }
906 
907     /**
908      * @dev Removes a value from a set. O(1).
909      *
910      * Returns true if the value was removed from the set, that is if it was
911      * present.
912      */
913     function remove(UintSet storage set, uint256 value) internal returns (bool) {
914         return _remove(set._inner, bytes32(value));
915     }
916 
917     /**
918      * @dev Returns true if the value is in the set. O(1).
919      */
920     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
921         return _contains(set._inner, bytes32(value));
922     }
923 
924     /**
925      * @dev Returns the number of values in the set. O(1).
926      */
927     function length(UintSet storage set) internal view returns (uint256) {
928         return _length(set._inner);
929     }
930 
931     /**
932      * @dev Returns the value stored at position `index` in the set. O(1).
933      *
934      * Note that there are no guarantees on the ordering of values inside the
935      * array, and it may change when more values are added or removed.
936      *
937      * Requirements:
938      *
939      * - `index` must be strictly less than {length}.
940      */
941     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
942         return uint256(_at(set._inner, index));
943     }
944 
945     /**
946      * @dev Return the entire set in an array
947      *
948      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
949      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
950      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
951      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
952      */
953     function values(UintSet storage set) internal view returns (uint256[] memory) {
954         bytes32[] memory store = _values(set._inner);
955         uint256[] memory result;
956 
957         /// @solidity memory-safe-assembly
958         assembly {
959             result := store
960         }
961 
962         return result;
963     }
964 }
965 
966 
967 
968 
969 
970 pragma solidity ^0.8.0;
971 
972 
973 /**
974  * @dev Contract module that allows children to implement role-based access
975  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
976  * members except through off-chain means by accessing the contract event logs. Some
977  * applications may benefit from on-chain enumerability, for those cases see
978  * {AccessControlEnumerable}.
979  *
980  * Roles are referred to by their `bytes32` identifier. These should be exposed
981  * in the external API and be unique. The best way to achieve this is by
982  * using `public constant` hash digests:
983  *
984  * ```
985  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
986  * ```
987  *
988  * Roles can be used to represent a set of permissions. To restrict access to a
989  * function call, use {hasRole}:
990  *
991  * ```
992  * function foo() public {
993  *     require(hasRole(MY_ROLE, msg.sender));
994  *     ...
995  * }
996  * ```
997  *
998  * Roles can be granted and revoked dynamically via the {grantRole} and
999  * {revokeRole} functions. Each role has an associated admin role, and only
1000  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1001  *
1002  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1003  * that only accounts with this role will be able to grant or revoke other
1004  * roles. More complex role relationships can be created by using
1005  * {_setRoleAdmin}.
1006  *
1007  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1008  * grant and revoke this role. Extra precautions should be taken to secure
1009  * accounts that have been granted it.
1010  */
1011 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1012     struct RoleData {
1013         mapping(address => bool) members;
1014         bytes32 adminRole;
1015     }
1016 
1017     mapping(bytes32 => RoleData) private _roles;
1018 
1019     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1020 
1021     /**
1022      * @dev Modifier that checks that an account has a specific role. Reverts
1023      * with a standardized message including the required role.
1024      *
1025      * The format of the revert reason is given by the following regular expression:
1026      *
1027      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1028      *
1029      * _Available since v4.1._
1030      */
1031     modifier onlyRole(bytes32 role) {
1032         _checkRole(role);
1033         _;
1034     }
1035 
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1040         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1041     }
1042 
1043     /**
1044      * @dev Returns `true` if `account` has been granted `role`.
1045      */
1046     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1047         return _roles[role].members[account];
1048     }
1049 
1050     /**
1051      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1052      * Overriding this function changes the behavior of the {onlyRole} modifier.
1053      *
1054      * Format of the revert message is described in {_checkRole}.
1055      *
1056      * _Available since v4.6._
1057      */
1058     function _checkRole(bytes32 role) internal view virtual {
1059         _checkRole(role, _msgSender());
1060     }
1061 
1062     /**
1063      * @dev Revert with a standard message if `account` is missing `role`.
1064      *
1065      * The format of the revert reason is given by the following regular expression:
1066      *
1067      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1068      */
1069     function _checkRole(bytes32 role, address account) internal view virtual {
1070         if (!hasRole(role, account)) {
1071             revert(
1072                 string(
1073                     abi.encodePacked(
1074                         "AccessControl: account ",
1075                         Strings.toHexString(account),
1076                         " is missing role ",
1077                         Strings.toHexString(uint256(role), 32)
1078                     )
1079                 )
1080             );
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the admin role that controls `role`. See {grantRole} and
1086      * {revokeRole}.
1087      *
1088      * To change a role's admin, use {_setRoleAdmin}.
1089      */
1090     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1091         return _roles[role].adminRole;
1092     }
1093 
1094     /**
1095      * @dev Grants `role` to `account`.
1096      *
1097      * If `account` had not been already granted `role`, emits a {RoleGranted}
1098      * event.
1099      *
1100      * Requirements:
1101      *
1102      * - the caller must have ``role``'s admin role.
1103      *
1104      * May emit a {RoleGranted} event.
1105      */
1106     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1107         _grantRole(role, account);
1108     }
1109 
1110     /**
1111      * @dev Revokes `role` from `account`.
1112      *
1113      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1114      *
1115      * Requirements:
1116      *
1117      * - the caller must have ``role``'s admin role.
1118      *
1119      * May emit a {RoleRevoked} event.
1120      */
1121     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1122         _revokeRole(role, account);
1123     }
1124 
1125     /**
1126      * @dev Revokes `role` from the calling account.
1127      *
1128      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1129      * purpose is to provide a mechanism for accounts to lose their privileges
1130      * if they are compromised (such as when a trusted device is misplaced).
1131      *
1132      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1133      * event.
1134      *
1135      * Requirements:
1136      *
1137      * - the caller must be `account`.
1138      *
1139      * May emit a {RoleRevoked} event.
1140      */
1141     function renounceRole(bytes32 role, address account) public virtual override {
1142         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1143 
1144         _revokeRole(role, account);
1145     }
1146 
1147     /**
1148      * @dev Grants `role` to `account`.
1149      *
1150      * If `account` had not been already granted `role`, emits a {RoleGranted}
1151      * event. Note that unlike {grantRole}, this function doesn't perform any
1152      * checks on the calling account.
1153      *
1154      * May emit a {RoleGranted} event.
1155      *
1156      * [WARNING]
1157      * ====
1158      * This function should only be called from the constructor when setting
1159      * up the initial roles for the system.
1160      *
1161      * Using this function in any other way is effectively circumventing the admin
1162      * system imposed by {AccessControl}.
1163      * ====
1164      *
1165      * NOTE: This function is deprecated in favor of {_grantRole}.
1166      */
1167     function _setupRole(bytes32 role, address account) internal virtual {
1168         _grantRole(role, account);
1169     }
1170 
1171     /**
1172      * @dev Sets `adminRole` as ``role``'s admin role.
1173      *
1174      * Emits a {RoleAdminChanged} event.
1175      */
1176     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1177         bytes32 previousAdminRole = getRoleAdmin(role);
1178         _roles[role].adminRole = adminRole;
1179         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1180     }
1181 
1182     /**
1183      * @dev Grants `role` to `account`.
1184      *
1185      * Internal function without access restriction.
1186      *
1187      * May emit a {RoleGranted} event.
1188      */
1189     function _grantRole(bytes32 role, address account) internal virtual {
1190         if (!hasRole(role, account)) {
1191             _roles[role].members[account] = true;
1192             emit RoleGranted(role, account, _msgSender());
1193         }
1194     }
1195 
1196     /**
1197      * @dev Revokes `role` from `account`.
1198      *
1199      * Internal function without access restriction.
1200      *
1201      * May emit a {RoleRevoked} event.
1202      */
1203     function _revokeRole(bytes32 role, address account) internal virtual {
1204         if (hasRole(role, account)) {
1205             _roles[role].members[account] = false;
1206             emit RoleRevoked(role, account, _msgSender());
1207         }
1208     }
1209 }
1210 
1211 
1212 
1213 
1214 /** 
1215  *  SourceUnit: /Users/sami/Documents/GitHub/CIX/contracts/CIX.sol
1216 */
1217             
1218 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1219 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 ////import "./IAccessControl.sol";
1224 
1225 /**
1226  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1227  */
1228 interface IAccessControlEnumerable is IAccessControl {
1229     /**
1230      * @dev Returns one of the accounts that have `role`. `index` must be a
1231      * value between 0 and {getRoleMemberCount}, non-inclusive.
1232      *
1233      * Role bearers are not sorted in any particular way, and their ordering may
1234      * change at any point.
1235      *
1236      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1237      * you perform all queries on the same block. See the following
1238      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1239      * for more information.
1240      */
1241     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1242 
1243     /**
1244      * @dev Returns the number of accounts that have `role`. Can be used
1245      * together with {getRoleMember} to enumerate all bearers of a role.
1246      */
1247     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1248 }
1249 
1250 
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 /**
1255  * @dev Interface of the ERC20 standard as defined in the EIP.
1256  */
1257 interface IERC20 {
1258     /**
1259      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1260      * another (`to`).
1261      *
1262      * Note that `value` may be zero.
1263      */
1264     event Transfer(address indexed from, address indexed to, uint256 value);
1265 
1266     /**
1267      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1268      * a call to {approve}. `value` is the new allowance.
1269      */
1270     event Approval(address indexed owner, address indexed spender, uint256 value);
1271 
1272     /**
1273      * @dev Returns the amount of tokens in existence.
1274      */
1275     function totalSupply() external view returns (uint256);
1276 
1277     /**
1278      * @dev Returns the amount of tokens owned by `account`.
1279      */
1280     function balanceOf(address account) external view returns (uint256);
1281 
1282     /**
1283      * @dev Moves `amount` tokens from the caller's account to `to`.
1284      *
1285      * Returns a boolean value indicating whether the operation succeeded.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function transfer(address to, uint256 amount) external returns (bool);
1290 
1291     /**
1292      * @dev Returns the remaining number of tokens that `spender` will be
1293      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1294      * zero by default.
1295      *
1296      * This value changes when {approve} or {transferFrom} are called.
1297      */
1298     function allowance(address owner, address spender) external view returns (uint256);
1299 
1300     /**
1301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1302      *
1303      * Returns a boolean value indicating whether the operation succeeded.
1304      *
1305      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
1306      * that someone may use both the old and the new allowance by unfortunate
1307      * transaction ordering. One possible solution to mitigate this race
1308      * condition is to first reduce the spender's allowance to 0 and set the
1309      * desired value afterwards:
1310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1311      *
1312      * Emits an {Approval} event.
1313      */
1314     function approve(address spender, uint256 amount) external returns (bool);
1315 
1316     /**
1317      * @dev Moves `amount` tokens from `from` to `to` using the
1318      * allowance mechanism. `amount` is then deducted from the caller's
1319      * allowance.
1320      *
1321      * Returns a boolean value indicating whether the operation succeeded.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function transferFrom(
1326         address from,
1327         address to,
1328         uint256 amount
1329     ) external returns (bool);
1330 }
1331 
1332 
1333 
1334 
1335 pragma solidity ^0.8.0;
1336 
1337 
1338 /**
1339  * @dev Interface for the optional metadata functions from the ERC20 standard.
1340  *
1341  * _Available since v4.1._
1342  */
1343 interface IERC20Metadata is IERC20 {
1344     /**
1345      * @dev Returns the name of the token.
1346      */
1347     function name() external view returns (string memory);
1348 
1349     /**
1350      * @dev Returns the symbol of the token.
1351      */
1352     function symbol() external view returns (string memory);
1353 
1354     /**
1355      * @dev Returns the decimals places of the token.
1356      */
1357     function decimals() external view returns (uint8);
1358 }
1359 
1360 
1361 
1362 pragma solidity ^0.8.0;
1363 
1364 
1365 /**
1366  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1367  */
1368 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1369     using EnumerableSet for EnumerableSet.AddressSet;
1370 
1371     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1372 
1373     /**
1374      * @dev See {IERC165-supportsInterface}.
1375      */
1376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1377         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1378     }
1379 
1380     /**
1381      * @dev Returns one of the accounts that have `role`. `index` must be a
1382      * value between 0 and {getRoleMemberCount}, non-inclusive.
1383      *
1384      * Role bearers are not sorted in any particular way, and their ordering may
1385      * change at any point.
1386      *
1387      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1388      * you perform all queries on the same block. See the following
1389      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1390      * for more information.
1391      */
1392     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1393         return _roleMembers[role].at(index);
1394     }
1395 
1396     /**
1397      * @dev Returns the number of accounts that have `role`. Can be used
1398      * together with {getRoleMember} to enumerate all bearers of a role.
1399      */
1400     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1401         return _roleMembers[role].length();
1402     }
1403 
1404     /**
1405      * @dev Overload {_grantRole} to track enumerable memberships
1406      */
1407     function _grantRole(bytes32 role, address account) internal virtual override {
1408         super._grantRole(role, account);
1409         _roleMembers[role].add(account);
1410     }
1411 
1412     /**
1413      * @dev Overload {_revokeRole} to track enumerable memberships
1414      */
1415     function _revokeRole(bytes32 role, address account) internal virtual override {
1416         super._revokeRole(role, account);
1417         _roleMembers[role].remove(account);
1418     }
1419 }
1420 
1421 
1422 
1423 
1424 pragma solidity ^0.8.0;
1425 
1426 
1427 /**
1428  * @dev Implementation of the {IERC20} interface.
1429  *
1430  * This implementation is agnostic to the way tokens are created. This means
1431  * that a supply mechanism has to be added in a derived contract using {_mint}.
1432  * For a generic mechanism see {ERC20PresetMinterPauser}.
1433  *
1434  * TIP: For a detailed writeup see our guide
1435  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1436  * to implement supply mechanisms].
1437  *
1438  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1439  * instead returning `false` on failure. This behavior is nonetheless
1440  * conventional and does not conflict with the expectations of ERC20
1441  * applications.
1442  *
1443  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1444  * This allows applications to reconstruct the allowance for all accounts just
1445  * by listening to said events. Other implementations of the EIP may not emit
1446  * these events, as it isn't required by the specification.
1447  *
1448  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1449  * functions have been added to mitigate the well-known issues around setting
1450  * allowances. See {IERC20-approve}.
1451  */
1452 contract ERC20 is Context, IERC20, IERC20Metadata {
1453     mapping(address => uint256) private _balances;
1454 
1455     mapping(address => mapping(address => uint256)) private _allowances;
1456 
1457     uint256 private _totalSupply;
1458 
1459     string private _name;
1460     string private _symbol;
1461 
1462     /**
1463      * @dev Sets the values for {name} and {symbol}.
1464      *
1465      * The default value of {decimals} is 18. To select a different value for
1466      * {decimals} you should overload it.
1467      *
1468      * All two of these values are immutable: they can only be set once during
1469      * construction.
1470      */
1471     constructor(string memory name_, string memory symbol_) {
1472         _name = name_;
1473         _symbol = symbol_;
1474     }
1475 
1476     /**
1477      * @dev Returns the name of the token.
1478      */
1479     function name() public view virtual override returns (string memory) {
1480         return _name;
1481     }
1482 
1483     /**
1484      * @dev Returns the symbol of the token, usually a shorter version of the
1485      * name.
1486      */
1487     function symbol() public view virtual override returns (string memory) {
1488         return _symbol;
1489     }
1490 
1491     /**
1492      * @dev Returns the number of decimals used to get its user representation.
1493      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1494      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1495      *
1496      * Tokens usually opt for a value of 18, imitating the relationship between
1497      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1498      * overridden;
1499      *
1500      * NOTE: This information is only used for _display_ purposes: it in
1501      * no way affects any of the arithmetic of the contract, including
1502      * {IERC20-balanceOf} and {IERC20-transfer}.
1503      */
1504     function decimals() public view virtual override returns (uint8) {
1505         return 18;
1506     }
1507 
1508     /**
1509      * @dev See {IERC20-totalSupply}.
1510      */
1511     function totalSupply() public view virtual override returns (uint256) {
1512         return _totalSupply;
1513     }
1514 
1515     /**
1516      * @dev See {IERC20-balanceOf}.
1517      */
1518     function balanceOf(address account) public view virtual override returns (uint256) {
1519         return _balances[account];
1520     }
1521 
1522     /**
1523      * @dev See {IERC20-transfer}.
1524      *
1525      * Requirements:
1526      *
1527      * - `to` cannot be the zero address.
1528      * - the caller must have a balance of at least `amount`.
1529      */
1530     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1531         address owner = _msgSender();
1532         _transfer(owner, to, amount);
1533         return true;
1534     }
1535 
1536     /**
1537      * @dev See {IERC20-allowance}.
1538      */
1539     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1540         return _allowances[owner][spender];
1541     }
1542 
1543     /**
1544      * @dev See {IERC20-approve}.
1545      *
1546      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1547      * `transferFrom`. This is semantically equivalent to an infinite approval.
1548      *
1549      * Requirements:
1550      *
1551      * - `spender` cannot be the zero address.
1552      */
1553     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1554         address owner = _msgSender();
1555         _approve(owner, spender, amount);
1556         return true;
1557     }
1558 
1559     /**
1560      * @dev See {IERC20-transferFrom}.
1561      *
1562      * Emits an {Approval} event indicating the updated allowance. This is not
1563      * required by the EIP. See the note at the beginning of {ERC20}.
1564      *
1565      * NOTE: Does not update the allowance if the current allowance
1566      * is the maximum `uint256`.
1567      *
1568      * Requirements:
1569      *
1570      * - `from` and `to` cannot be the zero address.
1571      * - `from` must have a balance of at least `amount`.
1572      * - the caller must have allowance for ``from``'s tokens of at least
1573      * `amount`.
1574      */
1575     function transferFrom(
1576         address from,
1577         address to,
1578         uint256 amount
1579     ) public virtual override returns (bool) {
1580         address spender = _msgSender();
1581         _spendAllowance(from, spender, amount);
1582         _transfer(from, to, amount);
1583         return true;
1584     }
1585 
1586     /**
1587      * @dev Atomically increases the allowance granted to `spender` by the caller.
1588      *
1589      * This is an alternative to {approve} that can be used as a mitigation for
1590      * problems described in {IERC20-approve}.
1591      *
1592      * Emits an {Approval} event indicating the updated allowance.
1593      *
1594      * Requirements:
1595      *
1596      * - `spender` cannot be the zero address.
1597      */
1598     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1599         address owner = _msgSender();
1600         _approve(owner, spender, allowance(owner, spender) + addedValue);
1601         return true;
1602     }
1603 
1604     /**
1605      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1606      *
1607      * This is an alternative to {approve} that can be used as a mitigation for
1608      * problems described in {IERC20-approve}.
1609      *
1610      * Emits an {Approval} event indicating the updated allowance.
1611      *
1612      * Requirements:
1613      *
1614      * - `spender` cannot be the zero address.
1615      * - `spender` must have allowance for the caller of at least
1616      * `subtractedValue`.
1617      */
1618     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1619         address owner = _msgSender();
1620         uint256 currentAllowance = allowance(owner, spender);
1621         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1622         unchecked {
1623             _approve(owner, spender, currentAllowance - subtractedValue);
1624         }
1625 
1626         return true;
1627     }
1628 
1629     /**
1630      * @dev Moves `amount` of tokens from `from` to `to`.
1631      *
1632      * This internal function is equivalent to {transfer}, and can be used to
1633      * e.g. implement automatic token fees, slashing mechanisms, etc.
1634      *
1635      * Emits a {Transfer} event.
1636      *
1637      * Requirements:
1638      *
1639      * - `from` cannot be the zero address.
1640      * - `to` cannot be the zero address.
1641      * - `from` must have a balance of at least `amount`.
1642      */
1643     function _transfer(
1644         address from,
1645         address to,
1646         uint256 amount
1647     ) internal virtual {
1648         require(from != address(0), "ERC20: transfer from the zero address");
1649         require(to != address(0), "ERC20: transfer to the zero address");
1650 
1651         _beforeTokenTransfer(from, to, amount);
1652 
1653         uint256 fromBalance = _balances[from];
1654         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1655         unchecked {
1656             _balances[from] = fromBalance - amount;
1657             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1658             // decrementing then incrementing.
1659             _balances[to] += amount;
1660         }
1661 
1662         emit Transfer(from, to, amount);
1663 
1664         _afterTokenTransfer(from, to, amount);
1665     }
1666 
1667     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1668      * the total supply.
1669      *
1670      * Emits a {Transfer} event with `from` set to the zero address.
1671      *
1672      * Requirements:
1673      *
1674      * - `account` cannot be the zero address.
1675      */
1676     function _mint(address account, uint256 amount) internal virtual {
1677         require(account != address(0), "ERC20: mint to the zero address");
1678 
1679         _beforeTokenTransfer(address(0), account, amount);
1680 
1681         _totalSupply += amount;
1682         unchecked {
1683             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1684             _balances[account] += amount;
1685         }
1686         emit Transfer(address(0), account, amount);
1687 
1688         _afterTokenTransfer(address(0), account, amount);
1689     }
1690 
1691     /**
1692      * @dev Destroys `amount` tokens from `account`, reducing the
1693      * total supply.
1694      *
1695      * Emits a {Transfer} event with `to` set to the zero address.
1696      *
1697      * Requirements:
1698      *
1699      * - `account` cannot be the zero address.
1700      * - `account` must have at least `amount` tokens.
1701      */
1702     function _burn(address account, uint256 amount) internal virtual {
1703         require(account != address(0), "ERC20: burn from the zero address");
1704 
1705         _beforeTokenTransfer(account, address(0), amount);
1706 
1707         uint256 accountBalance = _balances[account];
1708         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1709         unchecked {
1710             _balances[account] = accountBalance - amount;
1711             // Overflow not possible: amount <= accountBalance <= totalSupply.
1712             _totalSupply -= amount;
1713         }
1714 
1715         emit Transfer(account, address(0), amount);
1716 
1717         _afterTokenTransfer(account, address(0), amount);
1718     }
1719 
1720     /**
1721      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1722      *
1723      * This internal function is equivalent to `approve`, and can be used to
1724      * e.g. set automatic allowances for certain subsystems, etc.
1725      *
1726      * Emits an {Approval} event.
1727      *
1728      * Requirements:
1729      *
1730      * - `owner` cannot be the zero address.
1731      * - `spender` cannot be the zero address.
1732      */
1733     function _approve(
1734         address owner,
1735         address spender,
1736         uint256 amount
1737     ) internal virtual {
1738         require(owner != address(0), "ERC20: approve from the zero address");
1739         require(spender != address(0), "ERC20: approve to the zero address");
1740 
1741         _allowances[owner][spender] = amount;
1742         emit Approval(owner, spender, amount);
1743     }
1744 
1745     /**
1746      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1747      *
1748      * Does not update the allowance amount in case of infinite allowance.
1749      * Revert if not enough allowance is available.
1750      *
1751      * Might emit an {Approval} event.
1752      */
1753     function _spendAllowance(
1754         address owner,
1755         address spender,
1756         uint256 amount
1757     ) internal virtual {
1758         uint256 currentAllowance = allowance(owner, spender);
1759         if (currentAllowance != type(uint256).max) {
1760             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1761             unchecked {
1762                 _approve(owner, spender, currentAllowance - amount);
1763             }
1764         }
1765     }
1766 
1767     /**
1768      * @dev Hook that is called before any transfer of tokens. This includes
1769      * minting and burning.
1770      *
1771      * Calling conditions:
1772      *
1773      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1774      * will be transferred to `to`.
1775      * - when `from` is zero, `amount` tokens will be minted for `to`.
1776      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1777      * - `from` and `to` are never both zero.
1778      *
1779      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1780      */
1781     function _beforeTokenTransfer(
1782         address from,
1783         address to,
1784         uint256 amount
1785     ) internal virtual {}
1786 
1787     /**
1788      * @dev Hook that is called after any transfer of tokens. This includes
1789      * minting and burning.
1790      *
1791      * Calling conditions:
1792      *
1793      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1794      * has been transferred to `to`.
1795      * - when `from` is zero, `amount` tokens have been minted for `to`.
1796      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1797      * - `from` and `to` are never both zero.
1798      *
1799      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1800      */
1801     function _afterTokenTransfer(
1802         address from,
1803         address to,
1804         uint256 amount
1805     ) internal virtual {}
1806 }
1807 
1808 
1809 pragma solidity ^0.8.9;
1810 
1811 
1812 contract CIX is ERC20, AccessControlEnumerable {
1813     bytes32 public constant BURNER = bytes32(uint256(1));
1814     bytes32 public constant MINTER = bytes32(uint256(2));
1815 
1816     constructor(
1817         address admin,
1818         address minter,
1819         address burner
1820     ) ERC20("Centurion Invest Token", "CIX") {
1821         _grantRole(DEFAULT_ADMIN_ROLE, admin);
1822         _grantRole(BURNER, burner);
1823         _grantRole(MINTER, minter);
1824         _mint(_msgSender(), 2400000000 * 10**uint256(decimals()));
1825     }
1826 
1827     function burn(address account, uint256 amount) external onlyRole(BURNER) {
1828         require(
1829             _msgSender() == account,
1830             "ERC20: burn account different from message sender"
1831         );
1832         _burn(account, amount);
1833     }
1834 
1835     function mint(address to, uint256 amount) external onlyRole(MINTER) {
1836         _mint(to, amount);
1837     }
1838 }