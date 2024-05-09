1 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
10  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
11  *
12  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
13  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
14  * need to send a transaction, and thus is not required to hold Ether at all.
15  */
16 interface IERC20Permit {
17     /**
18      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
19      * given ``owner``'s signed approval.
20      *
21      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
22      * ordering also apply here.
23      *
24      * Emits an {Approval} event.
25      *
26      * Requirements:
27      *
28      * - `spender` cannot be the zero address.
29      * - `deadline` must be a timestamp in the future.
30      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
31      * over the EIP712-formatted function arguments.
32      * - the signature must use ``owner``'s current nonce (see {nonces}).
33      *
34      * For more information on the signature format, see the
35      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
36      * section].
37      */
38     function permit(
39         address owner,
40         address spender,
41         uint256 value,
42         uint256 deadline,
43         uint8 v,
44         bytes32 r,
45         bytes32 s
46     ) external;
47 
48     /**
49      * @dev Returns the current nonce for `owner`. This value must be
50      * included whenever a signature is generated for {permit}.
51      *
52      * Every successful call to {permit} increases ``owner``'s nonce by one. This
53      * prevents a signature from being used multiple times.
54      */
55     function nonces(address owner) external view returns (uint256);
56 
57     /**
58      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
59      */
60     // solhint-disable-next-line func-name-mixedcase
61     function DOMAIN_SEPARATOR() external view returns (bytes32);
62 }
63 
64 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Interface of the ERC20 standard as defined in the EIP.
73  */
74 interface IERC20 {
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98 
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `to`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address to, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `from` to `to` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(address from, address to, uint256 amount) external returns (bool);
143 }
144 
145 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.9.0) (utils/structs/EnumerableSet.sol)
149 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Library for managing
155  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
156  * types.
157  *
158  * Sets have the following properties:
159  *
160  * - Elements are added, removed, and checked for existence in constant time
161  * (O(1)).
162  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
163  *
164  * ```solidity
165  * contract Example {
166  *     // Add the library methods
167  *     using EnumerableSet for EnumerableSet.AddressSet;
168  *
169  *     // Declare a set state variable
170  *     EnumerableSet.AddressSet private mySet;
171  * }
172  * ```
173  *
174  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
175  * and `uint256` (`UintSet`) are supported.
176  *
177  * [WARNING]
178  * ====
179  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
180  * unusable.
181  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
182  *
183  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
184  * array of EnumerableSet.
185  * ====
186  */
187 library EnumerableSet {
188     // To implement this library for multiple types with as little code
189     // repetition as possible, we write it in terms of a generic Set type with
190     // bytes32 values.
191     // The Set implementation uses private functions, and user-facing
192     // implementations (such as AddressSet) are just wrappers around the
193     // underlying Set.
194     // This means that we can only create new EnumerableSets for types that fit
195     // in bytes32.
196 
197     struct Set {
198         // Storage of set values
199         bytes32[] _values;
200         // Position of the value in the `values` array, plus 1 because index 0
201         // means a value is not in the set.
202         mapping(bytes32 => uint256) _indexes;
203     }
204 
205     /**
206      * @dev Add a value to a set. O(1).
207      *
208      * Returns true if the value was added to the set, that is if it was not
209      * already present.
210      */
211     function _add(Set storage set, bytes32 value) private returns (bool) {
212         if (!_contains(set, value)) {
213             set._values.push(value);
214             // The value is stored at length-1, but we add 1 to all indexes
215             // and use 0 as a sentinel value
216             set._indexes[value] = set._values.length;
217             return true;
218         } else {
219             return false;
220         }
221     }
222 
223     /**
224      * @dev Removes a value from a set. O(1).
225      *
226      * Returns true if the value was removed from the set, that is if it was
227      * present.
228      */
229     function _remove(Set storage set, bytes32 value) private returns (bool) {
230         // We read and store the value's index to prevent multiple reads from the same storage slot
231         uint256 valueIndex = set._indexes[value];
232 
233         if (valueIndex != 0) {
234             // Equivalent to contains(set, value)
235             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
236             // the array, and then remove the last element (sometimes called as 'swap and pop').
237             // This modifies the order of the array, as noted in {at}.
238 
239             uint256 toDeleteIndex = valueIndex - 1;
240             uint256 lastIndex = set._values.length - 1;
241 
242             if (lastIndex != toDeleteIndex) {
243                 bytes32 lastValue = set._values[lastIndex];
244 
245                 // Move the last value to the index where the value to delete is
246                 set._values[toDeleteIndex] = lastValue;
247                 // Update the index for the moved value
248                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
249             }
250 
251             // Delete the slot where the moved value was stored
252             set._values.pop();
253 
254             // Delete the index for the deleted slot
255             delete set._indexes[value];
256 
257             return true;
258         } else {
259             return false;
260         }
261     }
262 
263     /**
264      * @dev Returns true if the value is in the set. O(1).
265      */
266     function _contains(Set storage set, bytes32 value) private view returns (bool) {
267         return set._indexes[value] != 0;
268     }
269 
270     /**
271      * @dev Returns the number of values on the set. O(1).
272      */
273     function _length(Set storage set) private view returns (uint256) {
274         return set._values.length;
275     }
276 
277     /**
278      * @dev Returns the value stored at position `index` in the set. O(1).
279      *
280      * Note that there are no guarantees on the ordering of values inside the
281      * array, and it may change when more values are added or removed.
282      *
283      * Requirements:
284      *
285      * - `index` must be strictly less than {length}.
286      */
287     function _at(Set storage set, uint256 index) private view returns (bytes32) {
288         return set._values[index];
289     }
290 
291     /**
292      * @dev Return the entire set in an array
293      *
294      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
295      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
296      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
297      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
298      */
299     function _values(Set storage set) private view returns (bytes32[] memory) {
300         return set._values;
301     }
302 
303     // Bytes32Set
304 
305     struct Bytes32Set {
306         Set _inner;
307     }
308 
309     /**
310      * @dev Add a value to a set. O(1).
311      *
312      * Returns true if the value was added to the set, that is if it was not
313      * already present.
314      */
315     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
316         return _add(set._inner, value);
317     }
318 
319     /**
320      * @dev Removes a value from a set. O(1).
321      *
322      * Returns true if the value was removed from the set, that is if it was
323      * present.
324      */
325     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
326         return _remove(set._inner, value);
327     }
328 
329     /**
330      * @dev Returns true if the value is in the set. O(1).
331      */
332     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
333         return _contains(set._inner, value);
334     }
335 
336     /**
337      * @dev Returns the number of values in the set. O(1).
338      */
339     function length(Bytes32Set storage set) internal view returns (uint256) {
340         return _length(set._inner);
341     }
342 
343     /**
344      * @dev Returns the value stored at position `index` in the set. O(1).
345      *
346      * Note that there are no guarantees on the ordering of values inside the
347      * array, and it may change when more values are added or removed.
348      *
349      * Requirements:
350      *
351      * - `index` must be strictly less than {length}.
352      */
353     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
354         return _at(set._inner, index);
355     }
356 
357     /**
358      * @dev Return the entire set in an array
359      *
360      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
361      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
362      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
363      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
364      */
365     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
366         bytes32[] memory store = _values(set._inner);
367         bytes32[] memory result;
368 
369         /// @solidity memory-safe-assembly
370         assembly {
371             result := store
372         }
373 
374         return result;
375     }
376 
377     // AddressSet
378 
379     struct AddressSet {
380         Set _inner;
381     }
382 
383     /**
384      * @dev Add a value to a set. O(1).
385      *
386      * Returns true if the value was added to the set, that is if it was not
387      * already present.
388      */
389     function add(AddressSet storage set, address value) internal returns (bool) {
390         return _add(set._inner, bytes32(uint256(uint160(value))));
391     }
392 
393     /**
394      * @dev Removes a value from a set. O(1).
395      *
396      * Returns true if the value was removed from the set, that is if it was
397      * present.
398      */
399     function remove(AddressSet storage set, address value) internal returns (bool) {
400         return _remove(set._inner, bytes32(uint256(uint160(value))));
401     }
402 
403     /**
404      * @dev Returns true if the value is in the set. O(1).
405      */
406     function contains(AddressSet storage set, address value) internal view returns (bool) {
407         return _contains(set._inner, bytes32(uint256(uint160(value))));
408     }
409 
410     /**
411      * @dev Returns the number of values in the set. O(1).
412      */
413     function length(AddressSet storage set) internal view returns (uint256) {
414         return _length(set._inner);
415     }
416 
417     /**
418      * @dev Returns the value stored at position `index` in the set. O(1).
419      *
420      * Note that there are no guarantees on the ordering of values inside the
421      * array, and it may change when more values are added or removed.
422      *
423      * Requirements:
424      *
425      * - `index` must be strictly less than {length}.
426      */
427     function at(AddressSet storage set, uint256 index) internal view returns (address) {
428         return address(uint160(uint256(_at(set._inner, index))));
429     }
430 
431     /**
432      * @dev Return the entire set in an array
433      *
434      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
435      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
436      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
437      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
438      */
439     function values(AddressSet storage set) internal view returns (address[] memory) {
440         bytes32[] memory store = _values(set._inner);
441         address[] memory result;
442 
443         /// @solidity memory-safe-assembly
444         assembly {
445             result := store
446         }
447 
448         return result;
449     }
450 
451     // UintSet
452 
453     struct UintSet {
454         Set _inner;
455     }
456 
457     /**
458      * @dev Add a value to a set. O(1).
459      *
460      * Returns true if the value was added to the set, that is if it was not
461      * already present.
462      */
463     function add(UintSet storage set, uint256 value) internal returns (bool) {
464         return _add(set._inner, bytes32(value));
465     }
466 
467     /**
468      * @dev Removes a value from a set. O(1).
469      *
470      * Returns true if the value was removed from the set, that is if it was
471      * present.
472      */
473     function remove(UintSet storage set, uint256 value) internal returns (bool) {
474         return _remove(set._inner, bytes32(value));
475     }
476 
477     /**
478      * @dev Returns true if the value is in the set. O(1).
479      */
480     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
481         return _contains(set._inner, bytes32(value));
482     }
483 
484     /**
485      * @dev Returns the number of values in the set. O(1).
486      */
487     function length(UintSet storage set) internal view returns (uint256) {
488         return _length(set._inner);
489     }
490 
491     /**
492      * @dev Returns the value stored at position `index` in the set. O(1).
493      *
494      * Note that there are no guarantees on the ordering of values inside the
495      * array, and it may change when more values are added or removed.
496      *
497      * Requirements:
498      *
499      * - `index` must be strictly less than {length}.
500      */
501     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
502         return uint256(_at(set._inner, index));
503     }
504 
505     /**
506      * @dev Return the entire set in an array
507      *
508      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
509      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
510      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
511      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
512      */
513     function values(UintSet storage set) internal view returns (uint256[] memory) {
514         bytes32[] memory store = _values(set._inner);
515         uint256[] memory result;
516 
517         /// @solidity memory-safe-assembly
518         assembly {
519             result := store
520         }
521 
522         return result;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @dev Interface of the ERC165 standard, as defined in the
535  * https://eips.ethereum.org/EIPS/eip-165[EIP].
536  *
537  * Implementers can declare support of contract interfaces, which can then be
538  * queried by others ({ERC165Checker}).
539  *
540  * For an implementation, see {ERC165}.
541  */
542 interface IERC165 {
543     /**
544      * @dev Returns true if this contract implements the interface defined by
545      * `interfaceId`. See the corresponding
546      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
547      * to learn more about how these ids are created.
548      *
549      * This function call must use less than 30 000 gas.
550      */
551     function supportsInterface(bytes4 interfaceId) external view returns (bool);
552 }
553 
554 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Implementation of the {IERC165} interface.
564  *
565  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
566  * for the additional interface id that will be supported. For example:
567  *
568  * ```solidity
569  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
571  * }
572  * ```
573  *
574  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
575  */
576 abstract contract ERC165 is IERC165 {
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
581         return interfaceId == type(IERC165).interfaceId;
582     }
583 }
584 
585 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
586 
587 
588 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Standard signed math utilities missing in the Solidity language.
594  */
595 library SignedMath {
596     /**
597      * @dev Returns the largest of two signed numbers.
598      */
599     function max(int256 a, int256 b) internal pure returns (int256) {
600         return a > b ? a : b;
601     }
602 
603     /**
604      * @dev Returns the smallest of two signed numbers.
605      */
606     function min(int256 a, int256 b) internal pure returns (int256) {
607         return a < b ? a : b;
608     }
609 
610     /**
611      * @dev Returns the average of two signed numbers without overflow.
612      * The result is rounded towards zero.
613      */
614     function average(int256 a, int256 b) internal pure returns (int256) {
615         // Formula from the book "Hacker's Delight"
616         int256 x = (a & b) + ((a ^ b) >> 1);
617         return x + (int256(uint256(x) >> 255) & (a ^ b));
618     }
619 
620     /**
621      * @dev Returns the absolute unsigned value of a signed value.
622      */
623     function abs(int256 n) internal pure returns (uint256) {
624         unchecked {
625             // must be unchecked in order to support `n = type(int256).min`
626             return uint256(n >= 0 ? n : -n);
627         }
628     }
629 }
630 
631 // File: @openzeppelin/contracts/utils/math/Math.sol
632 
633 
634 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Standard math utilities missing in the Solidity language.
640  */
641 library Math {
642     enum Rounding {
643         Down, // Toward negative infinity
644         Up, // Toward infinity
645         Zero // Toward zero
646     }
647 
648     /**
649      * @dev Returns the largest of two numbers.
650      */
651     function max(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a > b ? a : b;
653     }
654 
655     /**
656      * @dev Returns the smallest of two numbers.
657      */
658     function min(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a < b ? a : b;
660     }
661 
662     /**
663      * @dev Returns the average of two numbers. The result is rounded towards
664      * zero.
665      */
666     function average(uint256 a, uint256 b) internal pure returns (uint256) {
667         // (a + b) / 2 can overflow.
668         return (a & b) + (a ^ b) / 2;
669     }
670 
671     /**
672      * @dev Returns the ceiling of the division of two numbers.
673      *
674      * This differs from standard division with `/` in that it rounds up instead
675      * of rounding down.
676      */
677     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
678         // (a + b - 1) / b can overflow on addition, so we distribute.
679         return a == 0 ? 0 : (a - 1) / b + 1;
680     }
681 
682     /**
683      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
684      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
685      * with further edits by Uniswap Labs also under MIT license.
686      */
687     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
688         unchecked {
689             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
690             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
691             // variables such that product = prod1 * 2^256 + prod0.
692             uint256 prod0; // Least significant 256 bits of the product
693             uint256 prod1; // Most significant 256 bits of the product
694             assembly {
695                 let mm := mulmod(x, y, not(0))
696                 prod0 := mul(x, y)
697                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
698             }
699 
700             // Handle non-overflow cases, 256 by 256 division.
701             if (prod1 == 0) {
702                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
703                 // The surrounding unchecked block does not change this fact.
704                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
705                 return prod0 / denominator;
706             }
707 
708             // Make sure the result is less than 2^256. Also prevents denominator == 0.
709             require(denominator > prod1, "Math: mulDiv overflow");
710 
711             ///////////////////////////////////////////////
712             // 512 by 256 division.
713             ///////////////////////////////////////////////
714 
715             // Make division exact by subtracting the remainder from [prod1 prod0].
716             uint256 remainder;
717             assembly {
718                 // Compute remainder using mulmod.
719                 remainder := mulmod(x, y, denominator)
720 
721                 // Subtract 256 bit number from 512 bit number.
722                 prod1 := sub(prod1, gt(remainder, prod0))
723                 prod0 := sub(prod0, remainder)
724             }
725 
726             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
727             // See https://cs.stackexchange.com/q/138556/92363.
728 
729             // Does not overflow because the denominator cannot be zero at this stage in the function.
730             uint256 twos = denominator & (~denominator + 1);
731             assembly {
732                 // Divide denominator by twos.
733                 denominator := div(denominator, twos)
734 
735                 // Divide [prod1 prod0] by twos.
736                 prod0 := div(prod0, twos)
737 
738                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
739                 twos := add(div(sub(0, twos), twos), 1)
740             }
741 
742             // Shift in bits from prod1 into prod0.
743             prod0 |= prod1 * twos;
744 
745             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
746             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
747             // four bits. That is, denominator * inv = 1 mod 2^4.
748             uint256 inverse = (3 * denominator) ^ 2;
749 
750             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
751             // in modular arithmetic, doubling the correct bits in each step.
752             inverse *= 2 - denominator * inverse; // inverse mod 2^8
753             inverse *= 2 - denominator * inverse; // inverse mod 2^16
754             inverse *= 2 - denominator * inverse; // inverse mod 2^32
755             inverse *= 2 - denominator * inverse; // inverse mod 2^64
756             inverse *= 2 - denominator * inverse; // inverse mod 2^128
757             inverse *= 2 - denominator * inverse; // inverse mod 2^256
758 
759             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
760             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
761             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
762             // is no longer required.
763             result = prod0 * inverse;
764             return result;
765         }
766     }
767 
768     /**
769      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
770      */
771     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
772         uint256 result = mulDiv(x, y, denominator);
773         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
774             result += 1;
775         }
776         return result;
777     }
778 
779     /**
780      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
781      *
782      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
783      */
784     function sqrt(uint256 a) internal pure returns (uint256) {
785         if (a == 0) {
786             return 0;
787         }
788 
789         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
790         //
791         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
792         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
793         //
794         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
795         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
796         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
797         //
798         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
799         uint256 result = 1 << (log2(a) >> 1);
800 
801         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
802         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
803         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
804         // into the expected uint128 result.
805         unchecked {
806             result = (result + a / result) >> 1;
807             result = (result + a / result) >> 1;
808             result = (result + a / result) >> 1;
809             result = (result + a / result) >> 1;
810             result = (result + a / result) >> 1;
811             result = (result + a / result) >> 1;
812             result = (result + a / result) >> 1;
813             return min(result, a / result);
814         }
815     }
816 
817     /**
818      * @notice Calculates sqrt(a), following the selected rounding direction.
819      */
820     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
821         unchecked {
822             uint256 result = sqrt(a);
823             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
824         }
825     }
826 
827     /**
828      * @dev Return the log in base 2, rounded down, of a positive value.
829      * Returns 0 if given 0.
830      */
831     function log2(uint256 value) internal pure returns (uint256) {
832         uint256 result = 0;
833         unchecked {
834             if (value >> 128 > 0) {
835                 value >>= 128;
836                 result += 128;
837             }
838             if (value >> 64 > 0) {
839                 value >>= 64;
840                 result += 64;
841             }
842             if (value >> 32 > 0) {
843                 value >>= 32;
844                 result += 32;
845             }
846             if (value >> 16 > 0) {
847                 value >>= 16;
848                 result += 16;
849             }
850             if (value >> 8 > 0) {
851                 value >>= 8;
852                 result += 8;
853             }
854             if (value >> 4 > 0) {
855                 value >>= 4;
856                 result += 4;
857             }
858             if (value >> 2 > 0) {
859                 value >>= 2;
860                 result += 2;
861             }
862             if (value >> 1 > 0) {
863                 result += 1;
864             }
865         }
866         return result;
867     }
868 
869     /**
870      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
871      * Returns 0 if given 0.
872      */
873     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
874         unchecked {
875             uint256 result = log2(value);
876             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
877         }
878     }
879 
880     /**
881      * @dev Return the log in base 10, rounded down, of a positive value.
882      * Returns 0 if given 0.
883      */
884     function log10(uint256 value) internal pure returns (uint256) {
885         uint256 result = 0;
886         unchecked {
887             if (value >= 10 ** 64) {
888                 value /= 10 ** 64;
889                 result += 64;
890             }
891             if (value >= 10 ** 32) {
892                 value /= 10 ** 32;
893                 result += 32;
894             }
895             if (value >= 10 ** 16) {
896                 value /= 10 ** 16;
897                 result += 16;
898             }
899             if (value >= 10 ** 8) {
900                 value /= 10 ** 8;
901                 result += 8;
902             }
903             if (value >= 10 ** 4) {
904                 value /= 10 ** 4;
905                 result += 4;
906             }
907             if (value >= 10 ** 2) {
908                 value /= 10 ** 2;
909                 result += 2;
910             }
911             if (value >= 10 ** 1) {
912                 result += 1;
913             }
914         }
915         return result;
916     }
917 
918     /**
919      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
920      * Returns 0 if given 0.
921      */
922     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
923         unchecked {
924             uint256 result = log10(value);
925             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
926         }
927     }
928 
929     /**
930      * @dev Return the log in base 256, rounded down, of a positive value.
931      * Returns 0 if given 0.
932      *
933      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
934      */
935     function log256(uint256 value) internal pure returns (uint256) {
936         uint256 result = 0;
937         unchecked {
938             if (value >> 128 > 0) {
939                 value >>= 128;
940                 result += 16;
941             }
942             if (value >> 64 > 0) {
943                 value >>= 64;
944                 result += 8;
945             }
946             if (value >> 32 > 0) {
947                 value >>= 32;
948                 result += 4;
949             }
950             if (value >> 16 > 0) {
951                 value >>= 16;
952                 result += 2;
953             }
954             if (value >> 8 > 0) {
955                 result += 1;
956             }
957         }
958         return result;
959     }
960 
961     /**
962      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
963      * Returns 0 if given 0.
964      */
965     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
966         unchecked {
967             uint256 result = log256(value);
968             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
969         }
970     }
971 }
972 
973 // File: @openzeppelin/contracts/utils/Strings.sol
974 
975 
976 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
977 
978 pragma solidity ^0.8.0;
979 
980 
981 
982 /**
983  * @dev String operations.
984  */
985 library Strings {
986     bytes16 private constant _SYMBOLS = "0123456789abcdef";
987     uint8 private constant _ADDRESS_LENGTH = 20;
988 
989     /**
990      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
991      */
992     function toString(uint256 value) internal pure returns (string memory) {
993         unchecked {
994             uint256 length = Math.log10(value) + 1;
995             string memory buffer = new string(length);
996             uint256 ptr;
997             /// @solidity memory-safe-assembly
998             assembly {
999                 ptr := add(buffer, add(32, length))
1000             }
1001             while (true) {
1002                 ptr--;
1003                 /// @solidity memory-safe-assembly
1004                 assembly {
1005                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1006                 }
1007                 value /= 10;
1008                 if (value == 0) break;
1009             }
1010             return buffer;
1011         }
1012     }
1013 
1014     /**
1015      * @dev Converts a `int256` to its ASCII `string` decimal representation.
1016      */
1017     function toString(int256 value) internal pure returns (string memory) {
1018         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
1019     }
1020 
1021     /**
1022      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1023      */
1024     function toHexString(uint256 value) internal pure returns (string memory) {
1025         unchecked {
1026             return toHexString(value, Math.log256(value) + 1);
1027         }
1028     }
1029 
1030     /**
1031      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1032      */
1033     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1034         bytes memory buffer = new bytes(2 * length + 2);
1035         buffer[0] = "0";
1036         buffer[1] = "x";
1037         for (uint256 i = 2 * length + 1; i > 1; --i) {
1038             buffer[i] = _SYMBOLS[value & 0xf];
1039             value >>= 4;
1040         }
1041         require(value == 0, "Strings: hex length insufficient");
1042         return string(buffer);
1043     }
1044 
1045     /**
1046      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1047      */
1048     function toHexString(address addr) internal pure returns (string memory) {
1049         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1050     }
1051 
1052     /**
1053      * @dev Returns true if the two strings are equal.
1054      */
1055     function equal(string memory a, string memory b) internal pure returns (bool) {
1056         return keccak256(bytes(a)) == keccak256(bytes(b));
1057     }
1058 }
1059 
1060 // File: @openzeppelin/contracts/utils/Context.sol
1061 
1062 
1063 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 /**
1068  * @dev Provides information about the current execution context, including the
1069  * sender of the transaction and its data. While these are generally available
1070  * via msg.sender and msg.data, they should not be accessed in such a direct
1071  * manner, since when dealing with meta-transactions the account sending and
1072  * paying for execution may not be the actual sender (as far as an application
1073  * is concerned).
1074  *
1075  * This contract is only required for intermediate, library-like contracts.
1076  */
1077 abstract contract Context {
1078     function _msgSender() internal view virtual returns (address) {
1079         return msg.sender;
1080     }
1081 
1082     function _msgData() internal view virtual returns (bytes calldata) {
1083         return msg.data;
1084     }
1085 }
1086 
1087 // File: @openzeppelin/contracts/access/IAccessControl.sol
1088 
1089 
1090 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 /**
1095  * @dev External interface of AccessControl declared to support ERC165 detection.
1096  */
1097 interface IAccessControl {
1098     /**
1099      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1100      *
1101      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1102      * {RoleAdminChanged} not being emitted signaling this.
1103      *
1104      * _Available since v3.1._
1105      */
1106     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1107 
1108     /**
1109      * @dev Emitted when `account` is granted `role`.
1110      *
1111      * `sender` is the account that originated the contract call, an admin role
1112      * bearer except when using {AccessControl-_setupRole}.
1113      */
1114     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1115 
1116     /**
1117      * @dev Emitted when `account` is revoked `role`.
1118      *
1119      * `sender` is the account that originated the contract call:
1120      *   - if using `revokeRole`, it is the admin role bearer
1121      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1122      */
1123     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1124 
1125     /**
1126      * @dev Returns `true` if `account` has been granted `role`.
1127      */
1128     function hasRole(bytes32 role, address account) external view returns (bool);
1129 
1130     /**
1131      * @dev Returns the admin role that controls `role`. See {grantRole} and
1132      * {revokeRole}.
1133      *
1134      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1135      */
1136     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1137 
1138     /**
1139      * @dev Grants `role` to `account`.
1140      *
1141      * If `account` had not been already granted `role`, emits a {RoleGranted}
1142      * event.
1143      *
1144      * Requirements:
1145      *
1146      * - the caller must have ``role``'s admin role.
1147      */
1148     function grantRole(bytes32 role, address account) external;
1149 
1150     /**
1151      * @dev Revokes `role` from `account`.
1152      *
1153      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1154      *
1155      * Requirements:
1156      *
1157      * - the caller must have ``role``'s admin role.
1158      */
1159     function revokeRole(bytes32 role, address account) external;
1160 
1161     /**
1162      * @dev Revokes `role` from the calling account.
1163      *
1164      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1165      * purpose is to provide a mechanism for accounts to lose their privileges
1166      * if they are compromised (such as when a trusted device is misplaced).
1167      *
1168      * If the calling account had been granted `role`, emits a {RoleRevoked}
1169      * event.
1170      *
1171      * Requirements:
1172      *
1173      * - the caller must be `account`.
1174      */
1175     function renounceRole(bytes32 role, address account) external;
1176 }
1177 
1178 // File: @openzeppelin/contracts/access/AccessControl.sol
1179 
1180 
1181 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 
1186 
1187 
1188 
1189 /**
1190  * @dev Contract module that allows children to implement role-based access
1191  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1192  * members except through off-chain means by accessing the contract event logs. Some
1193  * applications may benefit from on-chain enumerability, for those cases see
1194  * {AccessControlEnumerable}.
1195  *
1196  * Roles are referred to by their `bytes32` identifier. These should be exposed
1197  * in the external API and be unique. The best way to achieve this is by
1198  * using `public constant` hash digests:
1199  *
1200  * ```solidity
1201  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1202  * ```
1203  *
1204  * Roles can be used to represent a set of permissions. To restrict access to a
1205  * function call, use {hasRole}:
1206  *
1207  * ```solidity
1208  * function foo() public {
1209  *     require(hasRole(MY_ROLE, msg.sender));
1210  *     ...
1211  * }
1212  * ```
1213  *
1214  * Roles can be granted and revoked dynamically via the {grantRole} and
1215  * {revokeRole} functions. Each role has an associated admin role, and only
1216  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1217  *
1218  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1219  * that only accounts with this role will be able to grant or revoke other
1220  * roles. More complex role relationships can be created by using
1221  * {_setRoleAdmin}.
1222  *
1223  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1224  * grant and revoke this role. Extra precautions should be taken to secure
1225  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1226  * to enforce additional security measures for this role.
1227  */
1228 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1229     struct RoleData {
1230         mapping(address => bool) members;
1231         bytes32 adminRole;
1232     }
1233 
1234     mapping(bytes32 => RoleData) private _roles;
1235 
1236     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1237 
1238     /**
1239      * @dev Modifier that checks that an account has a specific role. Reverts
1240      * with a standardized message including the required role.
1241      *
1242      * The format of the revert reason is given by the following regular expression:
1243      *
1244      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1245      *
1246      * _Available since v4.1._
1247      */
1248     modifier onlyRole(bytes32 role) {
1249         _checkRole(role);
1250         _;
1251     }
1252 
1253     /**
1254      * @dev See {IERC165-supportsInterface}.
1255      */
1256     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1257         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1258     }
1259 
1260     /**
1261      * @dev Returns `true` if `account` has been granted `role`.
1262      */
1263     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1264         return _roles[role].members[account];
1265     }
1266 
1267     /**
1268      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1269      * Overriding this function changes the behavior of the {onlyRole} modifier.
1270      *
1271      * Format of the revert message is described in {_checkRole}.
1272      *
1273      * _Available since v4.6._
1274      */
1275     function _checkRole(bytes32 role) internal view virtual {
1276         _checkRole(role, _msgSender());
1277     }
1278 
1279     /**
1280      * @dev Revert with a standard message if `account` is missing `role`.
1281      *
1282      * The format of the revert reason is given by the following regular expression:
1283      *
1284      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1285      */
1286     function _checkRole(bytes32 role, address account) internal view virtual {
1287         if (!hasRole(role, account)) {
1288             revert(
1289                 string(
1290                     abi.encodePacked(
1291                         "AccessControl: account ",
1292                         Strings.toHexString(account),
1293                         " is missing role ",
1294                         Strings.toHexString(uint256(role), 32)
1295                     )
1296                 )
1297             );
1298         }
1299     }
1300 
1301     /**
1302      * @dev Returns the admin role that controls `role`. See {grantRole} and
1303      * {revokeRole}.
1304      *
1305      * To change a role's admin, use {_setRoleAdmin}.
1306      */
1307     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1308         return _roles[role].adminRole;
1309     }
1310 
1311     /**
1312      * @dev Grants `role` to `account`.
1313      *
1314      * If `account` had not been already granted `role`, emits a {RoleGranted}
1315      * event.
1316      *
1317      * Requirements:
1318      *
1319      * - the caller must have ``role``'s admin role.
1320      *
1321      * May emit a {RoleGranted} event.
1322      */
1323     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1324         _grantRole(role, account);
1325     }
1326 
1327     /**
1328      * @dev Revokes `role` from `account`.
1329      *
1330      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1331      *
1332      * Requirements:
1333      *
1334      * - the caller must have ``role``'s admin role.
1335      *
1336      * May emit a {RoleRevoked} event.
1337      */
1338     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1339         _revokeRole(role, account);
1340     }
1341 
1342     /**
1343      * @dev Revokes `role` from the calling account.
1344      *
1345      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1346      * purpose is to provide a mechanism for accounts to lose their privileges
1347      * if they are compromised (such as when a trusted device is misplaced).
1348      *
1349      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1350      * event.
1351      *
1352      * Requirements:
1353      *
1354      * - the caller must be `account`.
1355      *
1356      * May emit a {RoleRevoked} event.
1357      */
1358     function renounceRole(bytes32 role, address account) public virtual override {
1359         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1360 
1361         _revokeRole(role, account);
1362     }
1363 
1364     /**
1365      * @dev Grants `role` to `account`.
1366      *
1367      * If `account` had not been already granted `role`, emits a {RoleGranted}
1368      * event. Note that unlike {grantRole}, this function doesn't perform any
1369      * checks on the calling account.
1370      *
1371      * May emit a {RoleGranted} event.
1372      *
1373      * [WARNING]
1374      * ====
1375      * This function should only be called from the constructor when setting
1376      * up the initial roles for the system.
1377      *
1378      * Using this function in any other way is effectively circumventing the admin
1379      * system imposed by {AccessControl}.
1380      * ====
1381      *
1382      * NOTE: This function is deprecated in favor of {_grantRole}.
1383      */
1384     function _setupRole(bytes32 role, address account) internal virtual {
1385         _grantRole(role, account);
1386     }
1387 
1388     /**
1389      * @dev Sets `adminRole` as ``role``'s admin role.
1390      *
1391      * Emits a {RoleAdminChanged} event.
1392      */
1393     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1394         bytes32 previousAdminRole = getRoleAdmin(role);
1395         _roles[role].adminRole = adminRole;
1396         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1397     }
1398 
1399     /**
1400      * @dev Grants `role` to `account`.
1401      *
1402      * Internal function without access restriction.
1403      *
1404      * May emit a {RoleGranted} event.
1405      */
1406     function _grantRole(bytes32 role, address account) internal virtual {
1407         if (!hasRole(role, account)) {
1408             _roles[role].members[account] = true;
1409             emit RoleGranted(role, account, _msgSender());
1410         }
1411     }
1412 
1413     /**
1414      * @dev Revokes `role` from `account`.
1415      *
1416      * Internal function without access restriction.
1417      *
1418      * May emit a {RoleRevoked} event.
1419      */
1420     function _revokeRole(bytes32 role, address account) internal virtual {
1421         if (hasRole(role, account)) {
1422             _roles[role].members[account] = false;
1423             emit RoleRevoked(role, account, _msgSender());
1424         }
1425     }
1426 }
1427 
1428 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
1429 
1430 
1431 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1432 
1433 pragma solidity ^0.8.0;
1434 
1435 
1436 /**
1437  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1438  */
1439 interface IAccessControlEnumerable is IAccessControl {
1440     /**
1441      * @dev Returns one of the accounts that have `role`. `index` must be a
1442      * value between 0 and {getRoleMemberCount}, non-inclusive.
1443      *
1444      * Role bearers are not sorted in any particular way, and their ordering may
1445      * change at any point.
1446      *
1447      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1448      * you perform all queries on the same block. See the following
1449      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1450      * for more information.
1451      */
1452     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1453 
1454     /**
1455      * @dev Returns the number of accounts that have `role`. Can be used
1456      * together with {getRoleMember} to enumerate all bearers of a role.
1457      */
1458     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1459 }
1460 
1461 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1462 
1463 
1464 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1465 
1466 pragma solidity ^0.8.0;
1467 
1468 
1469 
1470 
1471 /**
1472  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1473  */
1474 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1475     using EnumerableSet for EnumerableSet.AddressSet;
1476 
1477     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1478 
1479     /**
1480      * @dev See {IERC165-supportsInterface}.
1481      */
1482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1483         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1484     }
1485 
1486     /**
1487      * @dev Returns one of the accounts that have `role`. `index` must be a
1488      * value between 0 and {getRoleMemberCount}, non-inclusive.
1489      *
1490      * Role bearers are not sorted in any particular way, and their ordering may
1491      * change at any point.
1492      *
1493      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1494      * you perform all queries on the same block. See the following
1495      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1496      * for more information.
1497      */
1498     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1499         return _roleMembers[role].at(index);
1500     }
1501 
1502     /**
1503      * @dev Returns the number of accounts that have `role`. Can be used
1504      * together with {getRoleMember} to enumerate all bearers of a role.
1505      */
1506     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1507         return _roleMembers[role].length();
1508     }
1509 
1510     /**
1511      * @dev Overload {_grantRole} to track enumerable memberships
1512      */
1513     function _grantRole(bytes32 role, address account) internal virtual override {
1514         super._grantRole(role, account);
1515         _roleMembers[role].add(account);
1516     }
1517 
1518     /**
1519      * @dev Overload {_revokeRole} to track enumerable memberships
1520      */
1521     function _revokeRole(bytes32 role, address account) internal virtual override {
1522         super._revokeRole(role, account);
1523         _roleMembers[role].remove(account);
1524     }
1525 }
1526 
1527 // File: @openzeppelin/contracts/utils/Address.sol
1528 
1529 
1530 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
1531 
1532 pragma solidity ^0.8.1;
1533 
1534 /**
1535  * @dev Collection of functions related to the address type
1536  */
1537 library Address {
1538     /**
1539      * @dev Returns true if `account` is a contract.
1540      *
1541      * [IMPORTANT]
1542      * ====
1543      * It is unsafe to assume that an address for which this function returns
1544      * false is an externally-owned account (EOA) and not a contract.
1545      *
1546      * Among others, `isContract` will return false for the following
1547      * types of addresses:
1548      *
1549      *  - an externally-owned account
1550      *  - a contract in construction
1551      *  - an address where a contract will be created
1552      *  - an address where a contract lived, but was destroyed
1553      *
1554      * Furthermore, `isContract` will also return true if the target contract within
1555      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
1556      * which only has an effect at the end of a transaction.
1557      * ====
1558      *
1559      * [IMPORTANT]
1560      * ====
1561      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1562      *
1563      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1564      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1565      * constructor.
1566      * ====
1567      */
1568     function isContract(address account) internal view returns (bool) {
1569         // This method relies on extcodesize/address.code.length, which returns 0
1570         // for contracts in construction, since the code is only stored at the end
1571         // of the constructor execution.
1572 
1573         return account.code.length > 0;
1574     }
1575 
1576     /**
1577      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1578      * `recipient`, forwarding all available gas and reverting on errors.
1579      *
1580      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1581      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1582      * imposed by `transfer`, making them unable to receive funds via
1583      * `transfer`. {sendValue} removes this limitation.
1584      *
1585      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1586      *
1587      * IMPORTANT: because control is transferred to `recipient`, care must be
1588      * taken to not create reentrancy vulnerabilities. Consider using
1589      * {ReentrancyGuard} or the
1590      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1591      */
1592     function sendValue(address payable recipient, uint256 amount) internal {
1593         require(address(this).balance >= amount, "Address: insufficient balance");
1594 
1595         (bool success, ) = recipient.call{value: amount}("");
1596         require(success, "Address: unable to send value, recipient may have reverted");
1597     }
1598 
1599     /**
1600      * @dev Performs a Solidity function call using a low level `call`. A
1601      * plain `call` is an unsafe replacement for a function call: use this
1602      * function instead.
1603      *
1604      * If `target` reverts with a revert reason, it is bubbled up by this
1605      * function (like regular Solidity function calls).
1606      *
1607      * Returns the raw returned data. To convert to the expected return value,
1608      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1609      *
1610      * Requirements:
1611      *
1612      * - `target` must be a contract.
1613      * - calling `target` with `data` must not revert.
1614      *
1615      * _Available since v3.1._
1616      */
1617     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1618         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1619     }
1620 
1621     /**
1622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1623      * `errorMessage` as a fallback revert reason when `target` reverts.
1624      *
1625      * _Available since v3.1._
1626      */
1627     function functionCall(
1628         address target,
1629         bytes memory data,
1630         string memory errorMessage
1631     ) internal returns (bytes memory) {
1632         return functionCallWithValue(target, data, 0, errorMessage);
1633     }
1634 
1635     /**
1636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1637      * but also transferring `value` wei to `target`.
1638      *
1639      * Requirements:
1640      *
1641      * - the calling contract must have an ETH balance of at least `value`.
1642      * - the called Solidity function must be `payable`.
1643      *
1644      * _Available since v3.1._
1645      */
1646     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1647         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1648     }
1649 
1650     /**
1651      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1652      * with `errorMessage` as a fallback revert reason when `target` reverts.
1653      *
1654      * _Available since v3.1._
1655      */
1656     function functionCallWithValue(
1657         address target,
1658         bytes memory data,
1659         uint256 value,
1660         string memory errorMessage
1661     ) internal returns (bytes memory) {
1662         require(address(this).balance >= value, "Address: insufficient balance for call");
1663         (bool success, bytes memory returndata) = target.call{value: value}(data);
1664         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1665     }
1666 
1667     /**
1668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1669      * but performing a static call.
1670      *
1671      * _Available since v3.3._
1672      */
1673     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1674         return functionStaticCall(target, data, "Address: low-level static call failed");
1675     }
1676 
1677     /**
1678      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1679      * but performing a static call.
1680      *
1681      * _Available since v3.3._
1682      */
1683     function functionStaticCall(
1684         address target,
1685         bytes memory data,
1686         string memory errorMessage
1687     ) internal view returns (bytes memory) {
1688         (bool success, bytes memory returndata) = target.staticcall(data);
1689         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1690     }
1691 
1692     /**
1693      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1694      * but performing a delegate call.
1695      *
1696      * _Available since v3.4._
1697      */
1698     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1699         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1700     }
1701 
1702     /**
1703      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1704      * but performing a delegate call.
1705      *
1706      * _Available since v3.4._
1707      */
1708     function functionDelegateCall(
1709         address target,
1710         bytes memory data,
1711         string memory errorMessage
1712     ) internal returns (bytes memory) {
1713         (bool success, bytes memory returndata) = target.delegatecall(data);
1714         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1715     }
1716 
1717     /**
1718      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1719      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1720      *
1721      * _Available since v4.8._
1722      */
1723     function verifyCallResultFromTarget(
1724         address target,
1725         bool success,
1726         bytes memory returndata,
1727         string memory errorMessage
1728     ) internal view returns (bytes memory) {
1729         if (success) {
1730             if (returndata.length == 0) {
1731                 // only check isContract if the call was successful and the return data is empty
1732                 // otherwise we already know that it was a contract
1733                 require(isContract(target), "Address: call to non-contract");
1734             }
1735             return returndata;
1736         } else {
1737             _revert(returndata, errorMessage);
1738         }
1739     }
1740 
1741     /**
1742      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1743      * revert reason or using the provided one.
1744      *
1745      * _Available since v4.3._
1746      */
1747     function verifyCallResult(
1748         bool success,
1749         bytes memory returndata,
1750         string memory errorMessage
1751     ) internal pure returns (bytes memory) {
1752         if (success) {
1753             return returndata;
1754         } else {
1755             _revert(returndata, errorMessage);
1756         }
1757     }
1758 
1759     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1760         // Look for revert reason and bubble it up if present
1761         if (returndata.length > 0) {
1762             // The easiest way to bubble the revert reason is using memory via assembly
1763             /// @solidity memory-safe-assembly
1764             assembly {
1765                 let returndata_size := mload(returndata)
1766                 revert(add(32, returndata), returndata_size)
1767             }
1768         } else {
1769             revert(errorMessage);
1770         }
1771     }
1772 }
1773 
1774 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1775 
1776 
1777 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/SafeERC20.sol)
1778 
1779 pragma solidity ^0.8.0;
1780 
1781 
1782 
1783 
1784 /**
1785  * @title SafeERC20
1786  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1787  * contract returns false). Tokens that return no value (and instead revert or
1788  * throw on failure) are also supported, non-reverting calls are assumed to be
1789  * successful.
1790  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1791  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1792  */
1793 library SafeERC20 {
1794     using Address for address;
1795 
1796     /**
1797      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
1798      * non-reverting calls are assumed to be successful.
1799      */
1800     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1801         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1802     }
1803 
1804     /**
1805      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
1806      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
1807      */
1808     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1809         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1810     }
1811 
1812     /**
1813      * @dev Deprecated. This function has issues similar to the ones found in
1814      * {IERC20-approve}, and its usage is discouraged.
1815      *
1816      * Whenever possible, use {safeIncreaseAllowance} and
1817      * {safeDecreaseAllowance} instead.
1818      */
1819     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1820         // safeApprove should only be called when setting an initial allowance,
1821         // or when resetting it to zero. To increase and decrease it, use
1822         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1823         require(
1824             (value == 0) || (token.allowance(address(this), spender) == 0),
1825             "SafeERC20: approve from non-zero to non-zero allowance"
1826         );
1827         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1828     }
1829 
1830     /**
1831      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
1832      * non-reverting calls are assumed to be successful.
1833      */
1834     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1835         uint256 oldAllowance = token.allowance(address(this), spender);
1836         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
1837     }
1838 
1839     /**
1840      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
1841      * non-reverting calls are assumed to be successful.
1842      */
1843     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1844         unchecked {
1845             uint256 oldAllowance = token.allowance(address(this), spender);
1846             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1847             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
1848         }
1849     }
1850 
1851     /**
1852      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
1853      * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
1854      * 0 before setting it to a non-zero value.
1855      */
1856     function forceApprove(IERC20 token, address spender, uint256 value) internal {
1857         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
1858 
1859         if (!_callOptionalReturnBool(token, approvalCall)) {
1860             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
1861             _callOptionalReturn(token, approvalCall);
1862         }
1863     }
1864 
1865     /**
1866      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
1867      * Revert on invalid signature.
1868      */
1869     function safePermit(
1870         IERC20Permit token,
1871         address owner,
1872         address spender,
1873         uint256 value,
1874         uint256 deadline,
1875         uint8 v,
1876         bytes32 r,
1877         bytes32 s
1878     ) internal {
1879         uint256 nonceBefore = token.nonces(owner);
1880         token.permit(owner, spender, value, deadline, v, r, s);
1881         uint256 nonceAfter = token.nonces(owner);
1882         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1883     }
1884 
1885     /**
1886      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1887      * on the return value: the return value is optional (but if data is returned, it must not be false).
1888      * @param token The token targeted by the call.
1889      * @param data The call data (encoded using abi.encode or one of its variants).
1890      */
1891     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1892         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1893         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1894         // the target address contains contract code and also asserts for success in the low-level call.
1895 
1896         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1897         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1898     }
1899 
1900     /**
1901      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1902      * on the return value: the return value is optional (but if data is returned, it must not be false).
1903      * @param token The token targeted by the call.
1904      * @param data The call data (encoded using abi.encode or one of its variants).
1905      *
1906      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
1907      */
1908     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
1909         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1910         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
1911         // and not revert is the subcall reverts.
1912 
1913         (bool success, bytes memory returndata) = address(token).call(data);
1914         return
1915             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
1916     }
1917 }
1918 
1919 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1920 
1921 
1922 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
1923 
1924 pragma solidity ^0.8.0;
1925 
1926 /**
1927  * @dev Contract module that helps prevent reentrant calls to a function.
1928  *
1929  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1930  * available, which can be applied to functions to make sure there are no nested
1931  * (reentrant) calls to them.
1932  *
1933  * Note that because there is a single `nonReentrant` guard, functions marked as
1934  * `nonReentrant` may not call one another. This can be worked around by making
1935  * those functions `private`, and then adding `external` `nonReentrant` entry
1936  * points to them.
1937  *
1938  * TIP: If you would like to learn more about reentrancy and alternative ways
1939  * to protect against it, check out our blog post
1940  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1941  */
1942 abstract contract ReentrancyGuard {
1943     // Booleans are more expensive than uint256 or any type that takes up a full
1944     // word because each write operation emits an extra SLOAD to first read the
1945     // slot's contents, replace the bits taken up by the boolean, and then write
1946     // back. This is the compiler's defense against contract upgrades and
1947     // pointer aliasing, and it cannot be disabled.
1948 
1949     // The values being non-zero value makes deployment a bit more expensive,
1950     // but in exchange the refund on every call to nonReentrant will be lower in
1951     // amount. Since refunds are capped to a percentage of the total
1952     // transaction's gas, it is best to keep them low in cases like this one, to
1953     // increase the likelihood of the full refund coming into effect.
1954     uint256 private constant _NOT_ENTERED = 1;
1955     uint256 private constant _ENTERED = 2;
1956 
1957     uint256 private _status;
1958 
1959     constructor() {
1960         _status = _NOT_ENTERED;
1961     }
1962 
1963     /**
1964      * @dev Prevents a contract from calling itself, directly or indirectly.
1965      * Calling a `nonReentrant` function from another `nonReentrant`
1966      * function is not supported. It is possible to prevent this from happening
1967      * by making the `nonReentrant` function external, and making it call a
1968      * `private` function that does the actual work.
1969      */
1970     modifier nonReentrant() {
1971         _nonReentrantBefore();
1972         _;
1973         _nonReentrantAfter();
1974     }
1975 
1976     function _nonReentrantBefore() private {
1977         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1978         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1979 
1980         // Any calls to nonReentrant after this point will fail
1981         _status = _ENTERED;
1982     }
1983 
1984     function _nonReentrantAfter() private {
1985         // By storing the original value once again, a refund is triggered (see
1986         // https://eips.ethereum.org/EIPS/eip-2200)
1987         _status = _NOT_ENTERED;
1988     }
1989 
1990     /**
1991      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1992      * `nonReentrant` function in the call stack.
1993      */
1994     function _reentrancyGuardEntered() internal view returns (bool) {
1995         return _status == _ENTERED;
1996     }
1997 }
1998 
1999 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2000 
2001 
2002 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
2003 
2004 pragma solidity ^0.8.0;
2005 
2006 // CAUTION
2007 // This version of SafeMath should only be used with Solidity 0.8 or later,
2008 // because it relies on the compiler's built in overflow checks.
2009 
2010 /**
2011  * @dev Wrappers over Solidity's arithmetic operations.
2012  *
2013  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
2014  * now has built in overflow checking.
2015  */
2016 library SafeMath {
2017     /**
2018      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2019      *
2020      * _Available since v3.4._
2021      */
2022     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2023         unchecked {
2024             uint256 c = a + b;
2025             if (c < a) return (false, 0);
2026             return (true, c);
2027         }
2028     }
2029 
2030     /**
2031      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
2032      *
2033      * _Available since v3.4._
2034      */
2035     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2036         unchecked {
2037             if (b > a) return (false, 0);
2038             return (true, a - b);
2039         }
2040     }
2041 
2042     /**
2043      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2044      *
2045      * _Available since v3.4._
2046      */
2047     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2048         unchecked {
2049             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2050             // benefit is lost if 'b' is also tested.
2051             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2052             if (a == 0) return (true, 0);
2053             uint256 c = a * b;
2054             if (c / a != b) return (false, 0);
2055             return (true, c);
2056         }
2057     }
2058 
2059     /**
2060      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2061      *
2062      * _Available since v3.4._
2063      */
2064     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2065         unchecked {
2066             if (b == 0) return (false, 0);
2067             return (true, a / b);
2068         }
2069     }
2070 
2071     /**
2072      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2073      *
2074      * _Available since v3.4._
2075      */
2076     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2077         unchecked {
2078             if (b == 0) return (false, 0);
2079             return (true, a % b);
2080         }
2081     }
2082 
2083     /**
2084      * @dev Returns the addition of two unsigned integers, reverting on
2085      * overflow.
2086      *
2087      * Counterpart to Solidity's `+` operator.
2088      *
2089      * Requirements:
2090      *
2091      * - Addition cannot overflow.
2092      */
2093     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2094         return a + b;
2095     }
2096 
2097     /**
2098      * @dev Returns the subtraction of two unsigned integers, reverting on
2099      * overflow (when the result is negative).
2100      *
2101      * Counterpart to Solidity's `-` operator.
2102      *
2103      * Requirements:
2104      *
2105      * - Subtraction cannot overflow.
2106      */
2107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2108         return a - b;
2109     }
2110 
2111     /**
2112      * @dev Returns the multiplication of two unsigned integers, reverting on
2113      * overflow.
2114      *
2115      * Counterpart to Solidity's `*` operator.
2116      *
2117      * Requirements:
2118      *
2119      * - Multiplication cannot overflow.
2120      */
2121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2122         return a * b;
2123     }
2124 
2125     /**
2126      * @dev Returns the integer division of two unsigned integers, reverting on
2127      * division by zero. The result is rounded towards zero.
2128      *
2129      * Counterpart to Solidity's `/` operator.
2130      *
2131      * Requirements:
2132      *
2133      * - The divisor cannot be zero.
2134      */
2135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2136         return a / b;
2137     }
2138 
2139     /**
2140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2141      * reverting when dividing by zero.
2142      *
2143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2144      * opcode (which leaves remaining gas untouched) while Solidity uses an
2145      * invalid opcode to revert (consuming all remaining gas).
2146      *
2147      * Requirements:
2148      *
2149      * - The divisor cannot be zero.
2150      */
2151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2152         return a % b;
2153     }
2154 
2155     /**
2156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2157      * overflow (when the result is negative).
2158      *
2159      * CAUTION: This function is deprecated because it requires allocating memory for the error
2160      * message unnecessarily. For custom revert reasons use {trySub}.
2161      *
2162      * Counterpart to Solidity's `-` operator.
2163      *
2164      * Requirements:
2165      *
2166      * - Subtraction cannot overflow.
2167      */
2168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
2169         unchecked {
2170             require(b <= a, errorMessage);
2171             return a - b;
2172         }
2173     }
2174 
2175     /**
2176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2177      * division by zero. The result is rounded towards zero.
2178      *
2179      * Counterpart to Solidity's `/` operator. Note: this function uses a
2180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2181      * uses an invalid opcode to revert (consuming all remaining gas).
2182      *
2183      * Requirements:
2184      *
2185      * - The divisor cannot be zero.
2186      */
2187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
2188         unchecked {
2189             require(b > 0, errorMessage);
2190             return a / b;
2191         }
2192     }
2193 
2194     /**
2195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2196      * reverting with custom message when dividing by zero.
2197      *
2198      * CAUTION: This function is deprecated because it requires allocating memory for the error
2199      * message unnecessarily. For custom revert reasons use {tryMod}.
2200      *
2201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2202      * opcode (which leaves remaining gas untouched) while Solidity uses an
2203      * invalid opcode to revert (consuming all remaining gas).
2204      *
2205      * Requirements:
2206      *
2207      * - The divisor cannot be zero.
2208      */
2209     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
2210         unchecked {
2211             require(b > 0, errorMessage);
2212             return a % b;
2213         }
2214     }
2215 }
2216 
2217 // File: contracts/feral_flips.sol
2218 
2219 
2220 pragma solidity ^0.8.0;
2221 
2222 
2223 
2224 
2225 
2226 
2227 
2228 
2229 contract FeralFlipsMarket is AccessControlEnumerable, ReentrancyGuard {
2230     using SafeMath for uint256;
2231     using SafeERC20 for IERC20;
2232 
2233     bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2234 
2235     event Deposit(address indexed depositor, uint256 amount);
2236 
2237     event AdminAdded(address indexed admin);
2238     event AdminRemoved(address indexed admin);
2239     event Withdrawal(address indexed user, uint256 amount);
2240     event WithdrawalRequested(address indexed user, uint256 amount);
2241 
2242     address private deployer;
2243     uint256 private depositBalance;
2244     mapping(address => uint256) private nonces;
2245     mapping(address => uint256) private lastWithdrawal;
2246 
2247     IERC20 public token;
2248 
2249     constructor(address _tokenAddress) {
2250         deployer = msg.sender;
2251         token = IERC20(_tokenAddress);
2252         _setupRole(ADMIN_ROLE, deployer);
2253         _setupRole(DEFAULT_ADMIN_ROLE, deployer);
2254     }
2255 
2256     modifier onlyAdmin() {
2257         require(
2258             hasRole(ADMIN_ROLE, msg.sender),
2259             "Only admins can call this function."
2260         );
2261         _;
2262     }
2263 
2264     function addAdmin(address _newAdmin) public onlyAdmin {
2265         grantRole(ADMIN_ROLE, _newAdmin);
2266         emit AdminAdded(_newAdmin);
2267     }
2268 
2269     function removeAdmin(address _admin) public onlyAdmin {
2270         revokeRole(ADMIN_ROLE, _admin);
2271         emit AdminRemoved(_admin);
2272     }
2273 
2274     function deposit(uint256 _amount) public nonReentrant {
2275         require(_amount > 0, "Deposit amount must be greater than zero.");
2276         require(
2277             token.balanceOf(msg.sender) >= _amount,
2278             "Insufficient balance."
2279         );
2280         require(
2281             token.allowance(msg.sender, address(this)) >= _amount,
2282             "Token allowance not set or insufficient."
2283         );
2284 
2285         token.safeTransferFrom(msg.sender, address(this), _amount);
2286 
2287         depositBalance = depositBalance.add(_amount);
2288         emit Deposit(msg.sender, _amount);
2289     }
2290 
2291     function withdraw(
2292         uint256 _amount,
2293         uint256 _nonce,
2294         bytes memory _signature
2295     ) public nonReentrant {
2296         require(_amount > 0, "Withdrawal amount must be greater than zero.");
2297         require(depositBalance >= _amount, "Insufficient contract balance.");
2298         require(nonces[msg.sender] + 1 == _nonce, "Invalid nonce.");
2299         require(
2300             lastWithdrawal[msg.sender] + 1 days <= block.timestamp,
2301             "You can only withdraw once every 24 hours"
2302         );
2303 
2304         bytes32 message = keccak256(
2305             abi.encodePacked(
2306                 "\x19Ethereum Signed Message:\n32",
2307                 keccak256(abi.encode(msg.sender, _amount, _nonce))
2308             )
2309         );
2310 
2311         address actualSigner = recoverSigner(message, _signature);
2312         require(
2313             hasRole(ADMIN_ROLE, actualSigner),
2314             "Invalid signature from non-admin."
2315         );
2316 
2317         nonces[msg.sender] = _nonce;
2318         token.safeTransfer(msg.sender, _amount);
2319         depositBalance = depositBalance.sub(_amount);
2320         lastWithdrawal[msg.sender] = block.timestamp;
2321 
2322         emit Withdrawal(msg.sender, _amount);
2323     }
2324 
2325     function recoverSigner(
2326         bytes32 _message,
2327         bytes memory _signature
2328     ) internal pure returns (address) {
2329         require(_signature.length == 65, "Invalid signature length");
2330         bytes32 r;
2331         bytes32 s;
2332         uint8 v;
2333 
2334         assembly {
2335             r := mload(add(_signature, 32))
2336             s := mload(add(_signature, 64))
2337             v := byte(0, mload(add(_signature, 96)))
2338         }
2339 
2340         if (v < 27) {
2341             v += 27;
2342         }
2343 
2344         return ecrecover(_message, v, r, s);
2345     }
2346 
2347     function adminWithdraw(uint256 _amount) public onlyAdmin nonReentrant {
2348         require(_amount > 0, "Withdrawal amount must be greater than zero.");
2349         require(
2350             token.balanceOf(address(this)) >= _amount,
2351             "Insufficient contract balance."
2352         );
2353 
2354         token.safeTransfer(msg.sender, _amount);
2355         depositBalance = depositBalance.sub(_amount);
2356 
2357         emit Withdrawal(msg.sender, _amount);
2358     }
2359 
2360     function isAdmin(address _address) public view onlyAdmin returns (bool) {
2361         return hasRole(ADMIN_ROLE, _address);
2362     }
2363 
2364     function getNonce(address user) public view onlyAdmin returns (uint256) {
2365         return nonces[user];
2366     }
2367 
2368     function getDeployer() public view onlyAdmin returns (address) {
2369         return deployer;
2370     }
2371 
2372     function getDepositBalance() public view onlyAdmin returns (uint256) {
2373         return depositBalance;
2374     }
2375 
2376     function getLastWithdrawalTime(
2377         address _user
2378     ) public view returns (uint256) {
2379         return lastWithdrawal[_user];
2380     }
2381 
2382     function getAdminRole() public view onlyAdmin returns (bytes32) {
2383         return ADMIN_ROLE;
2384     }
2385 }