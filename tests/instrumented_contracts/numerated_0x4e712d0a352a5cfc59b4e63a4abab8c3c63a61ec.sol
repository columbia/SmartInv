1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Interface of the ERC20 standard as defined in the EIP.
240  */
241 interface IERC20 {
242     /**
243      * @dev Returns the amount of tokens in existence.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns the amount of tokens owned by `account`.
249      */
250     function balanceOf(address account) external view returns (uint256);
251 
252     /**
253      * @dev Moves `amount` tokens from the caller's account to `to`.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transfer(address to, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Returns the remaining number of tokens that `spender` will be
263      * allowed to spend on behalf of `owner` through {transferFrom}. This is
264      * zero by default.
265      *
266      * This value changes when {approve} or {transferFrom} are called.
267      */
268     function allowance(address owner, address spender) external view returns (uint256);
269 
270     /**
271      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * IMPORTANT: Beware that changing an allowance with this method brings the risk
276      * that someone may use both the old and the new allowance by unfortunate
277      * transaction ordering. One possible solution to mitigate this race
278      * condition is to first reduce the spender's allowance to 0 and set the
279      * desired value afterwards:
280      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address spender, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Moves `amount` tokens from `from` to `to` using the
288      * allowance mechanism. `amount` is then deducted from the caller's
289      * allowance.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(
296         address from,
297         address to,
298         uint256 amount
299     ) external returns (bool);
300 
301     /**
302      * @dev Emitted when `value` tokens are moved from one account (`from`) to
303      * another (`to`).
304      *
305      * Note that `value` may be zero.
306      */
307     event Transfer(address indexed from, address indexed to, uint256 value);
308 
309     /**
310      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
311      * a call to {approve}. `value` is the new allowance.
312      */
313     event Approval(address indexed owner, address indexed spender, uint256 value);
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 
324 /**
325  * @dev Interface for the optional metadata functions from the ERC20 standard.
326  *
327  * _Available since v4.1._
328  */
329 interface IERC20Metadata is IERC20 {
330     /**
331      * @dev Returns the name of the token.
332      */
333     function name() external view returns (string memory);
334 
335     /**
336      * @dev Returns the symbol of the token.
337      */
338     function symbol() external view returns (string memory);
339 
340     /**
341      * @dev Returns the decimals places of the token.
342      */
343     function decimals() external view returns (uint8);
344 }
345 
346 // File: @openzeppelin/contracts/utils/math/Math.sol
347 
348 
349 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Standard math utilities missing in the Solidity language.
355  */
356 library Math {
357     /**
358      * @dev Returns the largest of two numbers.
359      */
360     function max(uint256 a, uint256 b) internal pure returns (uint256) {
361         return a >= b ? a : b;
362     }
363 
364     /**
365      * @dev Returns the smallest of two numbers.
366      */
367     function min(uint256 a, uint256 b) internal pure returns (uint256) {
368         return a < b ? a : b;
369     }
370 
371     /**
372      * @dev Returns the average of two numbers. The result is rounded towards
373      * zero.
374      */
375     function average(uint256 a, uint256 b) internal pure returns (uint256) {
376         // (a + b) / 2 can overflow.
377         return (a & b) + (a ^ b) / 2;
378     }
379 
380     /**
381      * @dev Returns the ceiling of the division of two numbers.
382      *
383      * This differs from standard division with `/` in that it rounds up instead
384      * of rounding down.
385      */
386     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
387         // (a + b - 1) / b can overflow on addition, so we distribute.
388         return a / b + (a % b == 0 ? 0 : 1);
389     }
390 }
391 
392 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev Library for managing
401  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
402  * types.
403  *
404  * Sets have the following properties:
405  *
406  * - Elements are added, removed, and checked for existence in constant time
407  * (O(1)).
408  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
409  *
410  * ```
411  * contract Example {
412  *     // Add the library methods
413  *     using EnumerableSet for EnumerableSet.AddressSet;
414  *
415  *     // Declare a set state variable
416  *     EnumerableSet.AddressSet private mySet;
417  * }
418  * ```
419  *
420  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
421  * and `uint256` (`UintSet`) are supported.
422  */
423 library EnumerableSet {
424     // To implement this library for multiple types with as little code
425     // repetition as possible, we write it in terms of a generic Set type with
426     // bytes32 values.
427     // The Set implementation uses private functions, and user-facing
428     // implementations (such as AddressSet) are just wrappers around the
429     // underlying Set.
430     // This means that we can only create new EnumerableSets for types that fit
431     // in bytes32.
432 
433     struct Set {
434         // Storage of set values
435         bytes32[] _values;
436         // Position of the value in the `values` array, plus 1 because index 0
437         // means a value is not in the set.
438         mapping(bytes32 => uint256) _indexes;
439     }
440 
441     /**
442      * @dev Add a value to a set. O(1).
443      *
444      * Returns true if the value was added to the set, that is if it was not
445      * already present.
446      */
447     function _add(Set storage set, bytes32 value) private returns (bool) {
448         if (!_contains(set, value)) {
449             set._values.push(value);
450             // The value is stored at length-1, but we add 1 to all indexes
451             // and use 0 as a sentinel value
452             set._indexes[value] = set._values.length;
453             return true;
454         } else {
455             return false;
456         }
457     }
458 
459     /**
460      * @dev Removes a value from a set. O(1).
461      *
462      * Returns true if the value was removed from the set, that is if it was
463      * present.
464      */
465     function _remove(Set storage set, bytes32 value) private returns (bool) {
466         // We read and store the value's index to prevent multiple reads from the same storage slot
467         uint256 valueIndex = set._indexes[value];
468 
469         if (valueIndex != 0) {
470             // Equivalent to contains(set, value)
471             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
472             // the array, and then remove the last element (sometimes called as 'swap and pop').
473             // This modifies the order of the array, as noted in {at}.
474 
475             uint256 toDeleteIndex = valueIndex - 1;
476             uint256 lastIndex = set._values.length - 1;
477 
478             if (lastIndex != toDeleteIndex) {
479                 bytes32 lastvalue = set._values[lastIndex];
480 
481                 // Move the last value to the index where the value to delete is
482                 set._values[toDeleteIndex] = lastvalue;
483                 // Update the index for the moved value
484                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
485             }
486 
487             // Delete the slot where the moved value was stored
488             set._values.pop();
489 
490             // Delete the index for the deleted slot
491             delete set._indexes[value];
492 
493             return true;
494         } else {
495             return false;
496         }
497     }
498 
499     /**
500      * @dev Returns true if the value is in the set. O(1).
501      */
502     function _contains(Set storage set, bytes32 value) private view returns (bool) {
503         return set._indexes[value] != 0;
504     }
505 
506     /**
507      * @dev Returns the number of values on the set. O(1).
508      */
509     function _length(Set storage set) private view returns (uint256) {
510         return set._values.length;
511     }
512 
513     /**
514      * @dev Returns the value stored at position `index` in the set. O(1).
515      *
516      * Note that there are no guarantees on the ordering of values inside the
517      * array, and it may change when more values are added or removed.
518      *
519      * Requirements:
520      *
521      * - `index` must be strictly less than {length}.
522      */
523     function _at(Set storage set, uint256 index) private view returns (bytes32) {
524         return set._values[index];
525     }
526 
527     /**
528      * @dev Return the entire set in an array
529      *
530      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
531      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
532      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
533      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
534      */
535     function _values(Set storage set) private view returns (bytes32[] memory) {
536         return set._values;
537     }
538 
539     // Bytes32Set
540 
541     struct Bytes32Set {
542         Set _inner;
543     }
544 
545     /**
546      * @dev Add a value to a set. O(1).
547      *
548      * Returns true if the value was added to the set, that is if it was not
549      * already present.
550      */
551     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
552         return _add(set._inner, value);
553     }
554 
555     /**
556      * @dev Removes a value from a set. O(1).
557      *
558      * Returns true if the value was removed from the set, that is if it was
559      * present.
560      */
561     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
562         return _remove(set._inner, value);
563     }
564 
565     /**
566      * @dev Returns true if the value is in the set. O(1).
567      */
568     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
569         return _contains(set._inner, value);
570     }
571 
572     /**
573      * @dev Returns the number of values in the set. O(1).
574      */
575     function length(Bytes32Set storage set) internal view returns (uint256) {
576         return _length(set._inner);
577     }
578 
579     /**
580      * @dev Returns the value stored at position `index` in the set. O(1).
581      *
582      * Note that there are no guarantees on the ordering of values inside the
583      * array, and it may change when more values are added or removed.
584      *
585      * Requirements:
586      *
587      * - `index` must be strictly less than {length}.
588      */
589     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
590         return _at(set._inner, index);
591     }
592 
593     /**
594      * @dev Return the entire set in an array
595      *
596      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
597      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
598      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
599      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
600      */
601     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
602         return _values(set._inner);
603     }
604 
605     // AddressSet
606 
607     struct AddressSet {
608         Set _inner;
609     }
610 
611     /**
612      * @dev Add a value to a set. O(1).
613      *
614      * Returns true if the value was added to the set, that is if it was not
615      * already present.
616      */
617     function add(AddressSet storage set, address value) internal returns (bool) {
618         return _add(set._inner, bytes32(uint256(uint160(value))));
619     }
620 
621     /**
622      * @dev Removes a value from a set. O(1).
623      *
624      * Returns true if the value was removed from the set, that is if it was
625      * present.
626      */
627     function remove(AddressSet storage set, address value) internal returns (bool) {
628         return _remove(set._inner, bytes32(uint256(uint160(value))));
629     }
630 
631     /**
632      * @dev Returns true if the value is in the set. O(1).
633      */
634     function contains(AddressSet storage set, address value) internal view returns (bool) {
635         return _contains(set._inner, bytes32(uint256(uint160(value))));
636     }
637 
638     /**
639      * @dev Returns the number of values in the set. O(1).
640      */
641     function length(AddressSet storage set) internal view returns (uint256) {
642         return _length(set._inner);
643     }
644 
645     /**
646      * @dev Returns the value stored at position `index` in the set. O(1).
647      *
648      * Note that there are no guarantees on the ordering of values inside the
649      * array, and it may change when more values are added or removed.
650      *
651      * Requirements:
652      *
653      * - `index` must be strictly less than {length}.
654      */
655     function at(AddressSet storage set, uint256 index) internal view returns (address) {
656         return address(uint160(uint256(_at(set._inner, index))));
657     }
658 
659     /**
660      * @dev Return the entire set in an array
661      *
662      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
663      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
664      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
665      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
666      */
667     function values(AddressSet storage set) internal view returns (address[] memory) {
668         bytes32[] memory store = _values(set._inner);
669         address[] memory result;
670 
671         assembly {
672             result := store
673         }
674 
675         return result;
676     }
677 
678     // UintSet
679 
680     struct UintSet {
681         Set _inner;
682     }
683 
684     /**
685      * @dev Add a value to a set. O(1).
686      *
687      * Returns true if the value was added to the set, that is if it was not
688      * already present.
689      */
690     function add(UintSet storage set, uint256 value) internal returns (bool) {
691         return _add(set._inner, bytes32(value));
692     }
693 
694     /**
695      * @dev Removes a value from a set. O(1).
696      *
697      * Returns true if the value was removed from the set, that is if it was
698      * present.
699      */
700     function remove(UintSet storage set, uint256 value) internal returns (bool) {
701         return _remove(set._inner, bytes32(value));
702     }
703 
704     /**
705      * @dev Returns true if the value is in the set. O(1).
706      */
707     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
708         return _contains(set._inner, bytes32(value));
709     }
710 
711     /**
712      * @dev Returns the number of values on the set. O(1).
713      */
714     function length(UintSet storage set) internal view returns (uint256) {
715         return _length(set._inner);
716     }
717 
718     /**
719      * @dev Returns the value stored at position `index` in the set. O(1).
720      *
721      * Note that there are no guarantees on the ordering of values inside the
722      * array, and it may change when more values are added or removed.
723      *
724      * Requirements:
725      *
726      * - `index` must be strictly less than {length}.
727      */
728     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
729         return uint256(_at(set._inner, index));
730     }
731 
732     /**
733      * @dev Return the entire set in an array
734      *
735      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
736      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
737      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
738      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
739      */
740     function values(UintSet storage set) internal view returns (uint256[] memory) {
741         bytes32[] memory store = _values(set._inner);
742         uint256[] memory result;
743 
744         assembly {
745             result := store
746         }
747 
748         return result;
749     }
750 }
751 
752 // File: @openzeppelin/contracts/utils/Strings.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @dev String operations.
761  */
762 library Strings {
763     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
764 
765     /**
766      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
767      */
768     function toString(uint256 value) internal pure returns (string memory) {
769         // Inspired by OraclizeAPI's implementation - MIT licence
770         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
771 
772         if (value == 0) {
773             return "0";
774         }
775         uint256 temp = value;
776         uint256 digits;
777         while (temp != 0) {
778             digits++;
779             temp /= 10;
780         }
781         bytes memory buffer = new bytes(digits);
782         while (value != 0) {
783             digits -= 1;
784             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
785             value /= 10;
786         }
787         return string(buffer);
788     }
789 
790     /**
791      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
792      */
793     function toHexString(uint256 value) internal pure returns (string memory) {
794         if (value == 0) {
795             return "0x00";
796         }
797         uint256 temp = value;
798         uint256 length = 0;
799         while (temp != 0) {
800             length++;
801             temp >>= 8;
802         }
803         return toHexString(value, length);
804     }
805 
806     /**
807      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
808      */
809     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
810         bytes memory buffer = new bytes(2 * length + 2);
811         buffer[0] = "0";
812         buffer[1] = "x";
813         for (uint256 i = 2 * length + 1; i > 1; --i) {
814             buffer[i] = _HEX_SYMBOLS[value & 0xf];
815             value >>= 4;
816         }
817         require(value == 0, "Strings: hex length insufficient");
818         return string(buffer);
819     }
820 }
821 
822 // File: @openzeppelin/contracts/utils/Address.sol
823 
824 
825 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
826 
827 pragma solidity ^0.8.1;
828 
829 /**
830  * @dev Collection of functions related to the address type
831  */
832 library Address {
833     /**
834      * @dev Returns true if `account` is a contract.
835      *
836      * [IMPORTANT]
837      * ====
838      * It is unsafe to assume that an address for which this function returns
839      * false is an externally-owned account (EOA) and not a contract.
840      *
841      * Among others, `isContract` will return false for the following
842      * types of addresses:
843      *
844      *  - an externally-owned account
845      *  - a contract in construction
846      *  - an address where a contract will be created
847      *  - an address where a contract lived, but was destroyed
848      * ====
849      *
850      * [IMPORTANT]
851      * ====
852      * You shouldn't rely on `isContract` to protect against flash loan attacks!
853      *
854      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
855      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
856      * constructor.
857      * ====
858      */
859     function isContract(address account) internal view returns (bool) {
860         // This method relies on extcodesize/address.code.length, which returns 0
861         // for contracts in construction, since the code is only stored at the end
862         // of the constructor execution.
863 
864         return account.code.length > 0;
865     }
866 
867     /**
868      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
869      * `recipient`, forwarding all available gas and reverting on errors.
870      *
871      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
872      * of certain opcodes, possibly making contracts go over the 2300 gas limit
873      * imposed by `transfer`, making them unable to receive funds via
874      * `transfer`. {sendValue} removes this limitation.
875      *
876      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
877      *
878      * IMPORTANT: because control is transferred to `recipient`, care must be
879      * taken to not create reentrancy vulnerabilities. Consider using
880      * {ReentrancyGuard} or the
881      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
882      */
883     function sendValue(address payable recipient, uint256 amount) internal {
884         require(address(this).balance >= amount, "Address: insufficient balance");
885 
886         (bool success, ) = recipient.call{value: amount}("");
887         require(success, "Address: unable to send value, recipient may have reverted");
888     }
889 
890     /**
891      * @dev Performs a Solidity function call using a low level `call`. A
892      * plain `call` is an unsafe replacement for a function call: use this
893      * function instead.
894      *
895      * If `target` reverts with a revert reason, it is bubbled up by this
896      * function (like regular Solidity function calls).
897      *
898      * Returns the raw returned data. To convert to the expected return value,
899      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
900      *
901      * Requirements:
902      *
903      * - `target` must be a contract.
904      * - calling `target` with `data` must not revert.
905      *
906      * _Available since v3.1._
907      */
908     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
909         return functionCall(target, data, "Address: low-level call failed");
910     }
911 
912     /**
913      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
914      * `errorMessage` as a fallback revert reason when `target` reverts.
915      *
916      * _Available since v3.1._
917      */
918     function functionCall(
919         address target,
920         bytes memory data,
921         string memory errorMessage
922     ) internal returns (bytes memory) {
923         return functionCallWithValue(target, data, 0, errorMessage);
924     }
925 
926     /**
927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
928      * but also transferring `value` wei to `target`.
929      *
930      * Requirements:
931      *
932      * - the calling contract must have an ETH balance of at least `value`.
933      * - the called Solidity function must be `payable`.
934      *
935      * _Available since v3.1._
936      */
937     function functionCallWithValue(
938         address target,
939         bytes memory data,
940         uint256 value
941     ) internal returns (bytes memory) {
942         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
943     }
944 
945     /**
946      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
947      * with `errorMessage` as a fallback revert reason when `target` reverts.
948      *
949      * _Available since v3.1._
950      */
951     function functionCallWithValue(
952         address target,
953         bytes memory data,
954         uint256 value,
955         string memory errorMessage
956     ) internal returns (bytes memory) {
957         require(address(this).balance >= value, "Address: insufficient balance for call");
958         require(isContract(target), "Address: call to non-contract");
959 
960         (bool success, bytes memory returndata) = target.call{value: value}(data);
961         return verifyCallResult(success, returndata, errorMessage);
962     }
963 
964     /**
965      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
966      * but performing a static call.
967      *
968      * _Available since v3.3._
969      */
970     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
971         return functionStaticCall(target, data, "Address: low-level static call failed");
972     }
973 
974     /**
975      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
976      * but performing a static call.
977      *
978      * _Available since v3.3._
979      */
980     function functionStaticCall(
981         address target,
982         bytes memory data,
983         string memory errorMessage
984     ) internal view returns (bytes memory) {
985         require(isContract(target), "Address: static call to non-contract");
986 
987         (bool success, bytes memory returndata) = target.staticcall(data);
988         return verifyCallResult(success, returndata, errorMessage);
989     }
990 
991     /**
992      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
993      * but performing a delegate call.
994      *
995      * _Available since v3.4._
996      */
997     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
998         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
999     }
1000 
1001     /**
1002      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1003      * but performing a delegate call.
1004      *
1005      * _Available since v3.4._
1006      */
1007     function functionDelegateCall(
1008         address target,
1009         bytes memory data,
1010         string memory errorMessage
1011     ) internal returns (bytes memory) {
1012         require(isContract(target), "Address: delegate call to non-contract");
1013 
1014         (bool success, bytes memory returndata) = target.delegatecall(data);
1015         return verifyCallResult(success, returndata, errorMessage);
1016     }
1017 
1018     /**
1019      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1020      * revert reason using the provided one.
1021      *
1022      * _Available since v4.3._
1023      */
1024     function verifyCallResult(
1025         bool success,
1026         bytes memory returndata,
1027         string memory errorMessage
1028     ) internal pure returns (bytes memory) {
1029         if (success) {
1030             return returndata;
1031         } else {
1032             // Look for revert reason and bubble it up if present
1033             if (returndata.length > 0) {
1034                 // The easiest way to bubble the revert reason is using memory via assembly
1035 
1036                 assembly {
1037                     let returndata_size := mload(returndata)
1038                     revert(add(32, returndata), returndata_size)
1039                 }
1040             } else {
1041                 revert(errorMessage);
1042             }
1043         }
1044     }
1045 }
1046 
1047 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1048 
1049 
1050 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 /**
1055  * @title ERC721 token receiver interface
1056  * @dev Interface for any contract that wants to support safeTransfers
1057  * from ERC721 asset contracts.
1058  */
1059 interface IERC721Receiver {
1060     /**
1061      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1062      * by `operator` from `from`, this function is called.
1063      *
1064      * It must return its Solidity selector to confirm the token transfer.
1065      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1066      *
1067      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1068      */
1069     function onERC721Received(
1070         address operator,
1071         address from,
1072         uint256 tokenId,
1073         bytes calldata data
1074     ) external returns (bytes4);
1075 }
1076 
1077 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1078 
1079 
1080 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1081 
1082 pragma solidity ^0.8.0;
1083 
1084 /**
1085  * @dev Interface of the ERC165 standard, as defined in the
1086  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1087  *
1088  * Implementers can declare support of contract interfaces, which can then be
1089  * queried by others ({ERC165Checker}).
1090  *
1091  * For an implementation, see {ERC165}.
1092  */
1093 interface IERC165 {
1094     /**
1095      * @dev Returns true if this contract implements the interface defined by
1096      * `interfaceId`. See the corresponding
1097      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1098      * to learn more about how these ids are created.
1099      *
1100      * This function call must use less than 30 000 gas.
1101      */
1102     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1103 }
1104 
1105 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1106 
1107 
1108 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1109 
1110 pragma solidity ^0.8.0;
1111 
1112 
1113 /**
1114  * @dev Implementation of the {IERC165} interface.
1115  *
1116  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1117  * for the additional interface id that will be supported. For example:
1118  *
1119  * ```solidity
1120  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1121  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1122  * }
1123  * ```
1124  *
1125  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1126  */
1127 abstract contract ERC165 is IERC165 {
1128     /**
1129      * @dev See {IERC165-supportsInterface}.
1130      */
1131     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1132         return interfaceId == type(IERC165).interfaceId;
1133     }
1134 }
1135 
1136 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1137 
1138 
1139 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 
1144 /**
1145  * @dev Required interface of an ERC721 compliant contract.
1146  */
1147 interface IERC721 is IERC165 {
1148     /**
1149      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1150      */
1151     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1152 
1153     /**
1154      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1155      */
1156     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1157 
1158     /**
1159      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1160      */
1161     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1162 
1163     /**
1164      * @dev Returns the number of tokens in ``owner``'s account.
1165      */
1166     function balanceOf(address owner) external view returns (uint256 balance);
1167 
1168     /**
1169      * @dev Returns the owner of the `tokenId` token.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      */
1175     function ownerOf(uint256 tokenId) external view returns (address owner);
1176 
1177     /**
1178      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1179      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1180      *
1181      * Requirements:
1182      *
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      * - `tokenId` token must exist and be owned by `from`.
1186      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function safeTransferFrom(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) external;
1196 
1197     /**
1198      * @dev Transfers `tokenId` token from `from` to `to`.
1199      *
1200      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1201      *
1202      * Requirements:
1203      *
1204      * - `from` cannot be the zero address.
1205      * - `to` cannot be the zero address.
1206      * - `tokenId` token must be owned by `from`.
1207      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function transferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) external;
1216 
1217     /**
1218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1219      * The approval is cleared when the token is transferred.
1220      *
1221      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1222      *
1223      * Requirements:
1224      *
1225      * - The caller must own the token or be an approved operator.
1226      * - `tokenId` must exist.
1227      *
1228      * Emits an {Approval} event.
1229      */
1230     function approve(address to, uint256 tokenId) external;
1231 
1232     /**
1233      * @dev Returns the account approved for `tokenId` token.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      */
1239     function getApproved(uint256 tokenId) external view returns (address operator);
1240 
1241     /**
1242      * @dev Approve or remove `operator` as an operator for the caller.
1243      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1244      *
1245      * Requirements:
1246      *
1247      * - The `operator` cannot be the caller.
1248      *
1249      * Emits an {ApprovalForAll} event.
1250      */
1251     function setApprovalForAll(address operator, bool _approved) external;
1252 
1253     /**
1254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1255      *
1256      * See {setApprovalForAll}
1257      */
1258     function isApprovedForAll(address owner, address operator) external view returns (bool);
1259 
1260     /**
1261      * @dev Safely transfers `tokenId` token from `from` to `to`.
1262      *
1263      * Requirements:
1264      *
1265      * - `from` cannot be the zero address.
1266      * - `to` cannot be the zero address.
1267      * - `tokenId` token must exist and be owned by `from`.
1268      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function safeTransferFrom(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes calldata data
1278     ) external;
1279 }
1280 
1281 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1282 
1283 
1284 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 
1289 /**
1290  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1291  * @dev See https://eips.ethereum.org/EIPS/eip-721
1292  */
1293 interface IERC721Enumerable is IERC721 {
1294     /**
1295      * @dev Returns the total amount of tokens stored by the contract.
1296      */
1297     function totalSupply() external view returns (uint256);
1298 
1299     /**
1300      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1301      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1302      */
1303     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1304 
1305     /**
1306      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1307      * Use along with {totalSupply} to enumerate all tokens.
1308      */
1309     function tokenByIndex(uint256 index) external view returns (uint256);
1310 }
1311 
1312 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1313 
1314 
1315 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 /**
1321  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1322  * @dev See https://eips.ethereum.org/EIPS/eip-721
1323  */
1324 interface IERC721Metadata is IERC721 {
1325     /**
1326      * @dev Returns the token collection name.
1327      */
1328     function name() external view returns (string memory);
1329 
1330     /**
1331      * @dev Returns the token collection symbol.
1332      */
1333     function symbol() external view returns (string memory);
1334 
1335     /**
1336      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1337      */
1338     function tokenURI(uint256 tokenId) external view returns (string memory);
1339 }
1340 
1341 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1342 
1343 
1344 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1345 
1346 pragma solidity ^0.8.0;
1347 
1348 /**
1349  * @dev Contract module that helps prevent reentrant calls to a function.
1350  *
1351  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1352  * available, which can be applied to functions to make sure there are no nested
1353  * (reentrant) calls to them.
1354  *
1355  * Note that because there is a single `nonReentrant` guard, functions marked as
1356  * `nonReentrant` may not call one another. This can be worked around by making
1357  * those functions `private`, and then adding `external` `nonReentrant` entry
1358  * points to them.
1359  *
1360  * TIP: If you would like to learn more about reentrancy and alternative ways
1361  * to protect against it, check out our blog post
1362  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1363  */
1364 abstract contract ReentrancyGuard {
1365     // Booleans are more expensive than uint256 or any type that takes up a full
1366     // word because each write operation emits an extra SLOAD to first read the
1367     // slot's contents, replace the bits taken up by the boolean, and then write
1368     // back. This is the compiler's defense against contract upgrades and
1369     // pointer aliasing, and it cannot be disabled.
1370 
1371     // The values being non-zero value makes deployment a bit more expensive,
1372     // but in exchange the refund on every call to nonReentrant will be lower in
1373     // amount. Since refunds are capped to a percentage of the total
1374     // transaction's gas, it is best to keep them low in cases like this one, to
1375     // increase the likelihood of the full refund coming into effect.
1376     uint256 private constant _NOT_ENTERED = 1;
1377     uint256 private constant _ENTERED = 2;
1378 
1379     uint256 private _status;
1380 
1381     constructor() {
1382         _status = _NOT_ENTERED;
1383     }
1384 
1385     /**
1386      * @dev Prevents a contract from calling itself, directly or indirectly.
1387      * Calling a `nonReentrant` function from another `nonReentrant`
1388      * function is not supported. It is possible to prevent this from happening
1389      * by making the `nonReentrant` function external, and making it call a
1390      * `private` function that does the actual work.
1391      */
1392     modifier nonReentrant() {
1393         // On the first call to nonReentrant, _notEntered will be true
1394         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1395 
1396         // Any calls to nonReentrant after this point will fail
1397         _status = _ENTERED;
1398 
1399         _;
1400 
1401         // By storing the original value once again, a refund is triggered (see
1402         // https://eips.ethereum.org/EIPS/eip-2200)
1403         _status = _NOT_ENTERED;
1404     }
1405 }
1406 
1407 // File: @openzeppelin/contracts/utils/Counters.sol
1408 
1409 
1410 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 /**
1415  * @title Counters
1416  * @author Matt Condon (@shrugs)
1417  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1418  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1419  *
1420  * Include with `using Counters for Counters.Counter;`
1421  */
1422 library Counters {
1423     struct Counter {
1424         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1425         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1426         // this feature: see https://github.com/ethereum/solidity/issues/4637
1427         uint256 _value; // default: 0
1428     }
1429 
1430     function current(Counter storage counter) internal view returns (uint256) {
1431         return counter._value;
1432     }
1433 
1434     function increment(Counter storage counter) internal {
1435         unchecked {
1436             counter._value += 1;
1437         }
1438     }
1439 
1440     function decrement(Counter storage counter) internal {
1441         uint256 value = counter._value;
1442         require(value > 0, "Counter: decrement overflow");
1443         unchecked {
1444             counter._value = value - 1;
1445         }
1446     }
1447 
1448     function reset(Counter storage counter) internal {
1449         counter._value = 0;
1450     }
1451 }
1452 
1453 // File: @openzeppelin/contracts/utils/Context.sol
1454 
1455 
1456 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1457 
1458 pragma solidity ^0.8.0;
1459 
1460 /**
1461  * @dev Provides information about the current execution context, including the
1462  * sender of the transaction and its data. While these are generally available
1463  * via msg.sender and msg.data, they should not be accessed in such a direct
1464  * manner, since when dealing with meta-transactions the account sending and
1465  * paying for execution may not be the actual sender (as far as an application
1466  * is concerned).
1467  *
1468  * This contract is only required for intermediate, library-like contracts.
1469  */
1470 abstract contract Context {
1471     function _msgSender() internal view virtual returns (address) {
1472         return msg.sender;
1473     }
1474 
1475     function _msgData() internal view virtual returns (bytes calldata) {
1476         return msg.data;
1477     }
1478 }
1479 
1480 // File: ERC721A.sol
1481 
1482 
1483 // Creators: locationtba.eth, 2pmflow.eth
1484 
1485 pragma solidity ^0.8.0;
1486 
1487 
1488 
1489 
1490 
1491 
1492 
1493 
1494 
1495 /**
1496  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1497  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1498  *
1499  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1500  *
1501  * Does not support burning tokens to address(0).
1502  */
1503 contract ERC721A is
1504   Context,
1505   ERC165,
1506   IERC721,
1507   IERC721Metadata,
1508   IERC721Enumerable
1509 {
1510   using Address for address;
1511   using Strings for uint256;
1512 
1513   struct TokenOwnership {
1514     address addr;
1515     uint64 startTimestamp;
1516   }
1517 
1518   struct AddressData {
1519     uint128 balance;
1520     uint128 numberMinted;
1521   }
1522 
1523   uint256 private currentIndex = 0;
1524 
1525   uint256 internal immutable maxBatchSize;
1526 
1527   // Token name
1528   string private _name;
1529 
1530   // Token symbol
1531   string private _symbol;
1532 
1533   // Mapping from token ID to ownership details
1534   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1535   mapping(uint256 => TokenOwnership) private _ownerships;
1536 
1537   // Mapping owner address to address data
1538   mapping(address => AddressData) private _addressData;
1539 
1540   // Mapping from token ID to approved address
1541   mapping(uint256 => address) private _tokenApprovals;
1542 
1543   // Mapping from owner to operator approvals
1544   mapping(address => mapping(address => bool)) private _operatorApprovals;
1545 
1546   /**
1547    * @dev
1548    * `maxBatchSize` refers to how much a minter can mint at a time.
1549    */
1550   constructor(
1551     string memory name_,
1552     string memory symbol_,
1553     uint256 maxBatchSize_
1554   ) {
1555     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1556     _name = name_;
1557     _symbol = symbol_;
1558     maxBatchSize = maxBatchSize_;
1559   }
1560 
1561   /**
1562    * @dev See {IERC721Enumerable-totalSupply}.
1563    */
1564   function totalSupply() public view override returns (uint256) {
1565     return currentIndex;
1566   }
1567 
1568   /**
1569    * @dev See {IERC721Enumerable-tokenByIndex}.
1570    */
1571   function tokenByIndex(uint256 index) public view override returns (uint256) {
1572     require(index < totalSupply(), "ERC721A: global index out of bounds");
1573     return index;
1574   }
1575 
1576   /**
1577    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1578    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1579    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1580    */
1581   function tokenOfOwnerByIndex(address owner, uint256 index)
1582     public
1583     view
1584     override
1585     returns (uint256)
1586   {
1587     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1588     uint256 numMintedSoFar = totalSupply();
1589     uint256 tokenIdsIdx = 0;
1590     address currOwnershipAddr = address(0);
1591     for (uint256 i = 0; i < numMintedSoFar; i++) {
1592       TokenOwnership memory ownership = _ownerships[i];
1593       if (ownership.addr != address(0)) {
1594         currOwnershipAddr = ownership.addr;
1595       }
1596       if (currOwnershipAddr == owner) {
1597         if (tokenIdsIdx == index) {
1598           return i;
1599         }
1600         tokenIdsIdx++;
1601       }
1602     }
1603     revert("ERC721A: unable to get token of owner by index");
1604   }
1605 
1606   /**
1607    * @dev See {IERC165-supportsInterface}.
1608    */
1609   function supportsInterface(bytes4 interfaceId)
1610     public
1611     view
1612     virtual
1613     override(ERC165, IERC165)
1614     returns (bool)
1615   {
1616     return
1617       interfaceId == type(IERC721).interfaceId ||
1618       interfaceId == type(IERC721Metadata).interfaceId ||
1619       interfaceId == type(IERC721Enumerable).interfaceId ||
1620       super.supportsInterface(interfaceId);
1621   }
1622 
1623   /**
1624    * @dev See {IERC721-balanceOf}.
1625    */
1626   function balanceOf(address owner) public view override returns (uint256) {
1627     require(owner != address(0), "ERC721A: balance query for the zero address");
1628     return uint256(_addressData[owner].balance);
1629   }
1630 
1631   function _numberMinted(address owner) internal view returns (uint256) {
1632     require(
1633       owner != address(0),
1634       "ERC721A: number minted query for the zero address"
1635     );
1636     return uint256(_addressData[owner].numberMinted);
1637   }
1638 
1639   function ownershipOf(uint256 tokenId)
1640     internal
1641     view
1642     returns (TokenOwnership memory)
1643   {
1644     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1645 
1646     uint256 lowestTokenToCheck;
1647     if (tokenId >= maxBatchSize) {
1648       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1649     }
1650 
1651     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1652       TokenOwnership memory ownership = _ownerships[curr];
1653       if (ownership.addr != address(0)) {
1654         return ownership;
1655       }
1656     }
1657 
1658     revert("ERC721A: unable to determine the owner of token");
1659   }
1660 
1661   /**
1662    * @dev See {IERC721-ownerOf}.
1663    */
1664   function ownerOf(uint256 tokenId) public view override returns (address) {
1665     return ownershipOf(tokenId).addr;
1666   }
1667 
1668   /**
1669    * @dev See {IERC721Metadata-name}.
1670    */
1671   function name() public view virtual override returns (string memory) {
1672     return _name;
1673   }
1674 
1675   /**
1676    * @dev See {IERC721Metadata-symbol}.
1677    */
1678   function symbol() public view virtual override returns (string memory) {
1679     return _symbol;
1680   }
1681 
1682   /**
1683    * @dev See {IERC721Metadata-tokenURI}.
1684    */
1685   function tokenURI(uint256 tokenId)
1686     public
1687     view
1688     virtual
1689     override
1690     returns (string memory)
1691   {
1692     require(
1693       _exists(tokenId),
1694       "ERC721Metadata: URI query for nonexistent token"
1695     );
1696 
1697     string memory baseURI = _baseURI();
1698     return
1699       bytes(baseURI).length > 0
1700         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1701         : "";
1702   }
1703 
1704   /**
1705    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1706    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1707    * by default, can be overriden in child contracts.
1708    */
1709   function _baseURI() internal view virtual returns (string memory) {
1710     return "";
1711   }
1712 
1713   /**
1714    * @dev See {IERC721-approve}.
1715    */
1716   function approve(address to, uint256 tokenId) public override {
1717     address owner = ERC721A.ownerOf(tokenId);
1718     require(to != owner, "ERC721A: approval to current owner");
1719 
1720     require(
1721       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1722       "ERC721A: approve caller is not owner nor approved for all"
1723     );
1724 
1725     _approve(to, tokenId, owner);
1726   }
1727 
1728   /**
1729    * @dev See {IERC721-getApproved}.
1730    */
1731   function getApproved(uint256 tokenId) public view override returns (address) {
1732     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1733 
1734     return _tokenApprovals[tokenId];
1735   }
1736 
1737   /**
1738    * @dev See {IERC721-setApprovalForAll}.
1739    */
1740   function setApprovalForAll(address operator, bool approved) public override {
1741     require(operator != _msgSender(), "ERC721A: approve to caller");
1742 
1743     _operatorApprovals[_msgSender()][operator] = approved;
1744     emit ApprovalForAll(_msgSender(), operator, approved);
1745   }
1746 
1747   /**
1748    * @dev See {IERC721-isApprovedForAll}.
1749    */
1750   function isApprovedForAll(address owner, address operator)
1751     public
1752     view
1753     virtual
1754     override
1755     returns (bool)
1756   {
1757     return _operatorApprovals[owner][operator];
1758   }
1759 
1760   /**
1761    * @dev See {IERC721-transferFrom}.
1762    */
1763   function transferFrom(
1764     address from,
1765     address to,
1766     uint256 tokenId
1767   ) public virtual override {
1768     _transfer(from, to, tokenId);
1769   }
1770 
1771   /**
1772    * @dev See {IERC721-safeTransferFrom}.
1773    */
1774   function safeTransferFrom(
1775     address from,
1776     address to,
1777     uint256 tokenId
1778   ) public virtual override {
1779     safeTransferFrom(from, to, tokenId, "");
1780   }
1781 
1782   /**
1783    * @dev See {IERC721-safeTransferFrom}.
1784    */
1785   function safeTransferFrom(
1786     address from,
1787     address to,
1788     uint256 tokenId,
1789     bytes memory _data
1790   ) public virtual override {
1791     _transfer(from, to, tokenId);
1792     require(
1793       _checkOnERC721Received(from, to, tokenId, _data),
1794       "ERC721A: transfer to non ERC721Receiver implementer"
1795     );
1796   }
1797 
1798   /**
1799    * @dev Returns whether `tokenId` exists.
1800    *
1801    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1802    *
1803    * Tokens start existing when they are minted (`_mint`),
1804    */
1805   function _exists(uint256 tokenId) internal view returns (bool) {
1806     return tokenId < currentIndex;
1807   }
1808 
1809   function _safeMint(address to, uint256 quantity) internal {
1810     _safeMint(to, quantity, "");
1811   }
1812 
1813   /**
1814    * @dev Mints `quantity` tokens and transfers them to `to`.
1815    *
1816    * Requirements:
1817    *
1818    * - `to` cannot be the zero address.
1819    * - `quantity` cannot be larger than the max batch size.
1820    *
1821    * Emits a {Transfer} event.
1822    */
1823   function _safeMint(
1824     address to,
1825     uint256 quantity,
1826     bytes memory _data
1827   ) internal virtual {
1828     uint256 startTokenId = currentIndex;
1829     require(to != address(0), "ERC721A: mint to the zero address");
1830     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1831     require(!_exists(startTokenId), "ERC721A: token already minted");
1832     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1833 
1834     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1835 
1836     AddressData memory addressData = _addressData[to];
1837     _addressData[to] = AddressData(
1838       addressData.balance + uint128(quantity),
1839       addressData.numberMinted + uint128(quantity)
1840     );
1841     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1842 
1843     uint256 updatedIndex = startTokenId;
1844 
1845     for (uint256 i = 0; i < quantity; i++) {
1846       emit Transfer(address(0), to, updatedIndex);
1847       require(
1848         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1849         "ERC721A: transfer to non ERC721Receiver implementer"
1850       );
1851       updatedIndex++;
1852     }
1853 
1854     currentIndex = updatedIndex;
1855     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1856   }
1857 
1858   /**
1859    * @dev Transfers `tokenId` from `from` to `to`.
1860    *
1861    * Requirements:
1862    *
1863    * - `to` cannot be the zero address.
1864    * - `tokenId` token must be owned by `from`.
1865    *
1866    * Emits a {Transfer} event.
1867    */
1868   function _transfer(
1869     address from,
1870     address to,
1871     uint256 tokenId
1872   ) private {
1873     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1874 
1875     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1876       getApproved(tokenId) == _msgSender() ||
1877       isApprovedForAll(prevOwnership.addr, _msgSender()));
1878 
1879     require(
1880       isApprovedOrOwner,
1881       "ERC721A: transfer caller is not owner nor approved"
1882     );
1883 
1884     require(
1885       prevOwnership.addr == from,
1886       "ERC721A: transfer from incorrect owner"
1887     );
1888     require(to != address(0), "ERC721A: transfer to the zero address");
1889 
1890     _beforeTokenTransfers(from, to, tokenId, 1);
1891 
1892     // Clear approvals from the previous owner
1893     _approve(address(0), tokenId, prevOwnership.addr);
1894 
1895     _addressData[from].balance -= 1;
1896     _addressData[to].balance += 1;
1897     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1898 
1899     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1900     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1901     uint256 nextTokenId = tokenId + 1;
1902     if (_ownerships[nextTokenId].addr == address(0)) {
1903       if (_exists(nextTokenId)) {
1904         _ownerships[nextTokenId] = TokenOwnership(
1905           prevOwnership.addr,
1906           prevOwnership.startTimestamp
1907         );
1908       }
1909     }
1910 
1911     emit Transfer(from, to, tokenId);
1912     _afterTokenTransfers(from, to, tokenId, 1);
1913   }
1914 
1915   /**
1916    * @dev Approve `to` to operate on `tokenId`
1917    *
1918    * Emits a {Approval} event.
1919    */
1920   function _approve(
1921     address to,
1922     uint256 tokenId,
1923     address owner
1924   ) private {
1925     _tokenApprovals[tokenId] = to;
1926     emit Approval(owner, to, tokenId);
1927   }
1928 
1929   uint256 public nextOwnerToExplicitlySet = 0;
1930 
1931   /**
1932    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1933    */
1934   function _setOwnersExplicit(uint256 quantity) internal {
1935     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1936     require(quantity > 0, "quantity must be nonzero");
1937     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1938     if (endIndex > currentIndex - 1) {
1939       endIndex = currentIndex - 1;
1940     }
1941     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1942     require(_exists(endIndex), "not enough minted yet for this cleanup");
1943     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1944       if (_ownerships[i].addr == address(0)) {
1945         TokenOwnership memory ownership = ownershipOf(i);
1946         _ownerships[i] = TokenOwnership(
1947           ownership.addr,
1948           ownership.startTimestamp
1949         );
1950       }
1951     }
1952     nextOwnerToExplicitlySet = endIndex + 1;
1953   }
1954 
1955   /**
1956    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1957    * The call is not executed if the target address is not a contract.
1958    *
1959    * @param from address representing the previous owner of the given token ID
1960    * @param to target address that will receive the tokens
1961    * @param tokenId uint256 ID of the token to be transferred
1962    * @param _data bytes optional data to send along with the call
1963    * @return bool whether the call correctly returned the expected magic value
1964    */
1965   function _checkOnERC721Received(
1966     address from,
1967     address to,
1968     uint256 tokenId,
1969     bytes memory _data
1970   ) private returns (bool) {
1971     if (to.isContract()) {
1972       try
1973         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1974       returns (bytes4 retval) {
1975         return retval == IERC721Receiver(to).onERC721Received.selector;
1976       } catch (bytes memory reason) {
1977         if (reason.length == 0) {
1978           revert("ERC721A: transfer to non ERC721Receiver implementer");
1979         } else {
1980           assembly {
1981             revert(add(32, reason), mload(reason))
1982           }
1983         }
1984       }
1985     } else {
1986       return true;
1987     }
1988   }
1989 
1990   /**
1991    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1992    *
1993    * startTokenId - the first token id to be transferred
1994    * quantity - the amount to be transferred
1995    *
1996    * Calling conditions:
1997    *
1998    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1999    * transferred to `to`.
2000    * - When `from` is zero, `tokenId` will be minted for `to`.
2001    */
2002   function _beforeTokenTransfers(
2003     address from,
2004     address to,
2005     uint256 startTokenId,
2006     uint256 quantity
2007   ) internal virtual {}
2008 
2009   /**
2010    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2011    * minting.
2012    *
2013    * startTokenId - the first token id to be transferred
2014    * quantity - the amount to be transferred
2015    *
2016    * Calling conditions:
2017    *
2018    * - when `from` and `to` are both non-zero.
2019    * - `from` and `to` are never both zero.
2020    */
2021   function _afterTokenTransfers(
2022     address from,
2023     address to,
2024     uint256 startTokenId,
2025     uint256 quantity
2026   ) internal virtual {}
2027 }
2028 
2029 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2030 
2031 
2032 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
2033 
2034 pragma solidity ^0.8.0;
2035 
2036 
2037 
2038 
2039 /**
2040  * @dev Implementation of the {IERC20} interface.
2041  *
2042  * This implementation is agnostic to the way tokens are created. This means
2043  * that a supply mechanism has to be added in a derived contract using {_mint}.
2044  * For a generic mechanism see {ERC20PresetMinterPauser}.
2045  *
2046  * TIP: For a detailed writeup see our guide
2047  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2048  * to implement supply mechanisms].
2049  *
2050  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2051  * instead returning `false` on failure. This behavior is nonetheless
2052  * conventional and does not conflict with the expectations of ERC20
2053  * applications.
2054  *
2055  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2056  * This allows applications to reconstruct the allowance for all accounts just
2057  * by listening to said events. Other implementations of the EIP may not emit
2058  * these events, as it isn't required by the specification.
2059  *
2060  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2061  * functions have been added to mitigate the well-known issues around setting
2062  * allowances. See {IERC20-approve}.
2063  */
2064 contract ERC20 is Context, IERC20, IERC20Metadata {
2065     mapping(address => uint256) private _balances;
2066 
2067     mapping(address => mapping(address => uint256)) private _allowances;
2068 
2069     uint256 private _totalSupply;
2070 
2071     string private _name;
2072     string private _symbol;
2073 
2074     /**
2075      * @dev Sets the values for {name} and {symbol}.
2076      *
2077      * The default value of {decimals} is 18. To select a different value for
2078      * {decimals} you should overload it.
2079      *
2080      * All two of these values are immutable: they can only be set once during
2081      * construction.
2082      */
2083     constructor(string memory name_, string memory symbol_) {
2084         _name = name_;
2085         _symbol = symbol_;
2086     }
2087 
2088     /**
2089      * @dev Returns the name of the token.
2090      */
2091     function name() public view virtual override returns (string memory) {
2092         return _name;
2093     }
2094 
2095     /**
2096      * @dev Returns the symbol of the token, usually a shorter version of the
2097      * name.
2098      */
2099     function symbol() public view virtual override returns (string memory) {
2100         return _symbol;
2101     }
2102 
2103     /**
2104      * @dev Returns the number of decimals used to get its user representation.
2105      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2106      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2107      *
2108      * Tokens usually opt for a value of 18, imitating the relationship between
2109      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2110      * overridden;
2111      *
2112      * NOTE: This information is only used for _display_ purposes: it in
2113      * no way affects any of the arithmetic of the contract, including
2114      * {IERC20-balanceOf} and {IERC20-transfer}.
2115      */
2116     function decimals() public view virtual override returns (uint8) {
2117         return 18;
2118     }
2119 
2120     /**
2121      * @dev See {IERC20-totalSupply}.
2122      */
2123     function totalSupply() public view virtual override returns (uint256) {
2124         return _totalSupply;
2125     }
2126 
2127     /**
2128      * @dev See {IERC20-balanceOf}.
2129      */
2130     function balanceOf(address account) public view virtual override returns (uint256) {
2131         return _balances[account];
2132     }
2133 
2134     /**
2135      * @dev See {IERC20-transfer}.
2136      *
2137      * Requirements:
2138      *
2139      * - `to` cannot be the zero address.
2140      * - the caller must have a balance of at least `amount`.
2141      */
2142     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2143         address owner = _msgSender();
2144         _transfer(owner, to, amount);
2145         return true;
2146     }
2147 
2148     /**
2149      * @dev See {IERC20-allowance}.
2150      */
2151     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2152         return _allowances[owner][spender];
2153     }
2154 
2155     /**
2156      * @dev See {IERC20-approve}.
2157      *
2158      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2159      * `transferFrom`. This is semantically equivalent to an infinite approval.
2160      *
2161      * Requirements:
2162      *
2163      * - `spender` cannot be the zero address.
2164      */
2165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2166         address owner = _msgSender();
2167         _approve(owner, spender, amount);
2168         return true;
2169     }
2170 
2171     /**
2172      * @dev See {IERC20-transferFrom}.
2173      *
2174      * Emits an {Approval} event indicating the updated allowance. This is not
2175      * required by the EIP. See the note at the beginning of {ERC20}.
2176      *
2177      * NOTE: Does not update the allowance if the current allowance
2178      * is the maximum `uint256`.
2179      *
2180      * Requirements:
2181      *
2182      * - `from` and `to` cannot be the zero address.
2183      * - `from` must have a balance of at least `amount`.
2184      * - the caller must have allowance for ``from``'s tokens of at least
2185      * `amount`.
2186      */
2187     function transferFrom(
2188         address from,
2189         address to,
2190         uint256 amount
2191     ) public virtual override returns (bool) {
2192         address spender = _msgSender();
2193         _spendAllowance(from, spender, amount);
2194         _transfer(from, to, amount);
2195         return true;
2196     }
2197 
2198     /**
2199      * @dev Atomically increases the allowance granted to `spender` by the caller.
2200      *
2201      * This is an alternative to {approve} that can be used as a mitigation for
2202      * problems described in {IERC20-approve}.
2203      *
2204      * Emits an {Approval} event indicating the updated allowance.
2205      *
2206      * Requirements:
2207      *
2208      * - `spender` cannot be the zero address.
2209      */
2210     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2211         address owner = _msgSender();
2212         _approve(owner, spender, _allowances[owner][spender] + addedValue);
2213         return true;
2214     }
2215 
2216     /**
2217      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2218      *
2219      * This is an alternative to {approve} that can be used as a mitigation for
2220      * problems described in {IERC20-approve}.
2221      *
2222      * Emits an {Approval} event indicating the updated allowance.
2223      *
2224      * Requirements:
2225      *
2226      * - `spender` cannot be the zero address.
2227      * - `spender` must have allowance for the caller of at least
2228      * `subtractedValue`.
2229      */
2230     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2231         address owner = _msgSender();
2232         uint256 currentAllowance = _allowances[owner][spender];
2233         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2234         unchecked {
2235             _approve(owner, spender, currentAllowance - subtractedValue);
2236         }
2237 
2238         return true;
2239     }
2240 
2241     /**
2242      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2243      *
2244      * This internal function is equivalent to {transfer}, and can be used to
2245      * e.g. implement automatic token fees, slashing mechanisms, etc.
2246      *
2247      * Emits a {Transfer} event.
2248      *
2249      * Requirements:
2250      *
2251      * - `from` cannot be the zero address.
2252      * - `to` cannot be the zero address.
2253      * - `from` must have a balance of at least `amount`.
2254      */
2255     function _transfer(
2256         address from,
2257         address to,
2258         uint256 amount
2259     ) internal virtual {
2260         require(from != address(0), "ERC20: transfer from the zero address");
2261         require(to != address(0), "ERC20: transfer to the zero address");
2262 
2263         _beforeTokenTransfer(from, to, amount);
2264 
2265         uint256 fromBalance = _balances[from];
2266         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2267         unchecked {
2268             _balances[from] = fromBalance - amount;
2269         }
2270         _balances[to] += amount;
2271 
2272         emit Transfer(from, to, amount);
2273 
2274         _afterTokenTransfer(from, to, amount);
2275     }
2276 
2277     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2278      * the total supply.
2279      *
2280      * Emits a {Transfer} event with `from` set to the zero address.
2281      *
2282      * Requirements:
2283      *
2284      * - `account` cannot be the zero address.
2285      */
2286     function _mint(address account, uint256 amount) internal virtual {
2287         require(account != address(0), "ERC20: mint to the zero address");
2288 
2289         _beforeTokenTransfer(address(0), account, amount);
2290 
2291         _totalSupply += amount;
2292         _balances[account] += amount;
2293         emit Transfer(address(0), account, amount);
2294 
2295         _afterTokenTransfer(address(0), account, amount);
2296     }
2297 
2298     /**
2299      * @dev Destroys `amount` tokens from `account`, reducing the
2300      * total supply.
2301      *
2302      * Emits a {Transfer} event with `to` set to the zero address.
2303      *
2304      * Requirements:
2305      *
2306      * - `account` cannot be the zero address.
2307      * - `account` must have at least `amount` tokens.
2308      */
2309     function _burn(address account, uint256 amount) internal virtual {
2310         require(account != address(0), "ERC20: burn from the zero address");
2311 
2312         _beforeTokenTransfer(account, address(0), amount);
2313 
2314         uint256 accountBalance = _balances[account];
2315         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2316         unchecked {
2317             _balances[account] = accountBalance - amount;
2318         }
2319         _totalSupply -= amount;
2320 
2321         emit Transfer(account, address(0), amount);
2322 
2323         _afterTokenTransfer(account, address(0), amount);
2324     }
2325 
2326     /**
2327      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2328      *
2329      * This internal function is equivalent to `approve`, and can be used to
2330      * e.g. set automatic allowances for certain subsystems, etc.
2331      *
2332      * Emits an {Approval} event.
2333      *
2334      * Requirements:
2335      *
2336      * - `owner` cannot be the zero address.
2337      * - `spender` cannot be the zero address.
2338      */
2339     function _approve(
2340         address owner,
2341         address spender,
2342         uint256 amount
2343     ) internal virtual {
2344         require(owner != address(0), "ERC20: approve from the zero address");
2345         require(spender != address(0), "ERC20: approve to the zero address");
2346 
2347         _allowances[owner][spender] = amount;
2348         emit Approval(owner, spender, amount);
2349     }
2350 
2351     /**
2352      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
2353      *
2354      * Does not update the allowance amount in case of infinite allowance.
2355      * Revert if not enough allowance is available.
2356      *
2357      * Might emit an {Approval} event.
2358      */
2359     function _spendAllowance(
2360         address owner,
2361         address spender,
2362         uint256 amount
2363     ) internal virtual {
2364         uint256 currentAllowance = allowance(owner, spender);
2365         if (currentAllowance != type(uint256).max) {
2366             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2367             unchecked {
2368                 _approve(owner, spender, currentAllowance - amount);
2369             }
2370         }
2371     }
2372 
2373     /**
2374      * @dev Hook that is called before any transfer of tokens. This includes
2375      * minting and burning.
2376      *
2377      * Calling conditions:
2378      *
2379      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2380      * will be transferred to `to`.
2381      * - when `from` is zero, `amount` tokens will be minted for `to`.
2382      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2383      * - `from` and `to` are never both zero.
2384      *
2385      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2386      */
2387     function _beforeTokenTransfer(
2388         address from,
2389         address to,
2390         uint256 amount
2391     ) internal virtual {}
2392 
2393     /**
2394      * @dev Hook that is called after any transfer of tokens. This includes
2395      * minting and burning.
2396      *
2397      * Calling conditions:
2398      *
2399      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2400      * has been transferred to `to`.
2401      * - when `from` is zero, `amount` tokens have been minted for `to`.
2402      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2403      * - `from` and `to` are never both zero.
2404      *
2405      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2406      */
2407     function _afterTokenTransfer(
2408         address from,
2409         address to,
2410         uint256 amount
2411     ) internal virtual {}
2412 }
2413 
2414 // File: cosmicToken.sol
2415 
2416 pragma solidity 0.8.7;
2417 
2418 
2419 
2420 interface IDuck {
2421 	function balanceOG(address _user) external view returns(uint256);
2422 }
2423 
2424 contract CosmicToken is ERC20("CosmicUtilityToken", "CUT") 
2425 {
2426    
2427     using SafeMath for uint256;
2428    
2429     uint256 public totalTokensBurned = 0;
2430     address[] internal stakeholders;
2431     address  payable private owner;
2432     
2433 
2434     //token Genesis per day
2435     uint256 constant public GENESIS_RATE = 20 ether; 
2436     
2437     //token duck per day
2438     uint256 constant public DUCK_RATE = 5 ether; 
2439     
2440     //token for  genesis minting
2441 	uint256 constant public GENESIS_ISSUANCE = 280 ether;
2442 	
2443 	//token for duck minting
2444 	uint256 constant public DUCK_ISSUANCE = 70 ether;
2445 	
2446 	
2447 	
2448 	// Tue Mar 18 2031 17:46:47 GMT+0000
2449 	uint256 constant public END = 1931622407;
2450 
2451 	mapping(address => uint256) public rewards;
2452 	mapping(address => uint256) public lastUpdate;
2453 	
2454 	
2455     IDuck public ducksContract;
2456    
2457     constructor(address initDuckContract) 
2458     {
2459         owner = payable(msg.sender);
2460         ducksContract = IDuck(initDuckContract);
2461     }
2462    
2463 
2464     function WhoOwns() public view returns (address) {
2465         return owner;
2466     }
2467    
2468     modifier Owned {
2469          require(msg.sender == owner);
2470          _;
2471  }
2472    
2473     function getContractAddress() public view returns (address) {
2474         return address(this);
2475     }
2476 
2477 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
2478 		return a < b ? a : b;
2479 	}    
2480 	
2481 	modifier contractAddressOnly
2482     {
2483          require(msg.sender == address(ducksContract));
2484          _;
2485     }
2486     
2487    	// called when minting many NFTs
2488 	function updateRewardOnMint(address _user, uint256 _tokenId) external contractAddressOnly
2489 	{
2490 	    if(_tokenId <= 1000)
2491 		{
2492             _mint(_user,GENESIS_ISSUANCE);	  	        
2493 		}
2494 		else if(_tokenId >= 1001)
2495 		{
2496             _mint(_user,DUCK_ISSUANCE);	  	        	        
2497 		}
2498 	}
2499 	
2500 
2501 	function getReward(address _to, uint256 totalPayout) external contractAddressOnly
2502 	{
2503 		_mint(_to, (totalPayout * 10 ** 18));
2504 		
2505 	}
2506 	
2507 	function burn(address _from, uint256 _amount) external 
2508 	{
2509 	    require(msg.sender == _from, "You do not own these tokens");
2510 		_burn(_from, _amount);
2511 		totalTokensBurned += _amount;
2512 	}
2513 
2514 
2515   
2516    
2517 }
2518 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2519 
2520 
2521 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
2522 
2523 pragma solidity ^0.8.0;
2524 
2525 
2526 
2527 
2528 
2529 
2530 
2531 
2532 /**
2533  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2534  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2535  * {ERC721Enumerable}.
2536  */
2537 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2538     using Address for address;
2539     using Strings for uint256;
2540 
2541     // Token name
2542     string private _name;
2543 
2544     // Token symbol
2545     string private _symbol;
2546 
2547     // Mapping from token ID to owner address
2548     mapping(uint256 => address) private _owners;
2549 
2550     // Mapping owner address to token count
2551     mapping(address => uint256) private _balances;
2552 
2553     // Mapping from token ID to approved address
2554     mapping(uint256 => address) private _tokenApprovals;
2555 
2556     // Mapping from owner to operator approvals
2557     mapping(address => mapping(address => bool)) private _operatorApprovals;
2558 
2559     /**
2560      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2561      */
2562     constructor(string memory name_, string memory symbol_) {
2563         _name = name_;
2564         _symbol = symbol_;
2565     }
2566 
2567     /**
2568      * @dev See {IERC165-supportsInterface}.
2569      */
2570     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2571         return
2572             interfaceId == type(IERC721).interfaceId ||
2573             interfaceId == type(IERC721Metadata).interfaceId ||
2574             super.supportsInterface(interfaceId);
2575     }
2576 
2577     /**
2578      * @dev See {IERC721-balanceOf}.
2579      */
2580     function balanceOf(address owner) public view virtual override returns (uint256) {
2581         require(owner != address(0), "ERC721: balance query for the zero address");
2582         return _balances[owner];
2583     }
2584 
2585     /**
2586      * @dev See {IERC721-ownerOf}.
2587      */
2588     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2589         address owner = _owners[tokenId];
2590         require(owner != address(0), "ERC721: owner query for nonexistent token");
2591         return owner;
2592     }
2593 
2594     /**
2595      * @dev See {IERC721Metadata-name}.
2596      */
2597     function name() public view virtual override returns (string memory) {
2598         return _name;
2599     }
2600 
2601     /**
2602      * @dev See {IERC721Metadata-symbol}.
2603      */
2604     function symbol() public view virtual override returns (string memory) {
2605         return _symbol;
2606     }
2607 
2608     /**
2609      * @dev See {IERC721Metadata-tokenURI}.
2610      */
2611     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2612         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2613 
2614         string memory baseURI = _baseURI();
2615         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2616     }
2617 
2618     /**
2619      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2620      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2621      * by default, can be overriden in child contracts.
2622      */
2623     function _baseURI() internal view virtual returns (string memory) {
2624         return "";
2625     }
2626 
2627     /**
2628      * @dev See {IERC721-approve}.
2629      */
2630     function approve(address to, uint256 tokenId) public virtual override {
2631         address owner = ERC721.ownerOf(tokenId);
2632         require(to != owner, "ERC721: approval to current owner");
2633 
2634         require(
2635             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2636             "ERC721: approve caller is not owner nor approved for all"
2637         );
2638 
2639         _approve(to, tokenId);
2640     }
2641 
2642     /**
2643      * @dev See {IERC721-getApproved}.
2644      */
2645     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2646         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2647 
2648         return _tokenApprovals[tokenId];
2649     }
2650 
2651     /**
2652      * @dev See {IERC721-setApprovalForAll}.
2653      */
2654     function setApprovalForAll(address operator, bool approved) public virtual override {
2655         _setApprovalForAll(_msgSender(), operator, approved);
2656     }
2657 
2658     /**
2659      * @dev See {IERC721-isApprovedForAll}.
2660      */
2661     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2662         return _operatorApprovals[owner][operator];
2663     }
2664 
2665     /**
2666      * @dev See {IERC721-transferFrom}.
2667      */
2668     function transferFrom(
2669         address from,
2670         address to,
2671         uint256 tokenId
2672     ) public virtual override {
2673         //solhint-disable-next-line max-line-length
2674         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2675 
2676         _transfer(from, to, tokenId);
2677     }
2678 
2679     /**
2680      * @dev See {IERC721-safeTransferFrom}.
2681      */
2682     function safeTransferFrom(
2683         address from,
2684         address to,
2685         uint256 tokenId
2686     ) public virtual override {
2687         safeTransferFrom(from, to, tokenId, "");
2688     }
2689 
2690     /**
2691      * @dev See {IERC721-safeTransferFrom}.
2692      */
2693     function safeTransferFrom(
2694         address from,
2695         address to,
2696         uint256 tokenId,
2697         bytes memory _data
2698     ) public virtual override {
2699         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2700         _safeTransfer(from, to, tokenId, _data);
2701     }
2702 
2703     /**
2704      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2705      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2706      *
2707      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2708      *
2709      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2710      * implement alternative mechanisms to perform token transfer, such as signature-based.
2711      *
2712      * Requirements:
2713      *
2714      * - `from` cannot be the zero address.
2715      * - `to` cannot be the zero address.
2716      * - `tokenId` token must exist and be owned by `from`.
2717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2718      *
2719      * Emits a {Transfer} event.
2720      */
2721     function _safeTransfer(
2722         address from,
2723         address to,
2724         uint256 tokenId,
2725         bytes memory _data
2726     ) internal virtual {
2727         _transfer(from, to, tokenId);
2728         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2729     }
2730 
2731     /**
2732      * @dev Returns whether `tokenId` exists.
2733      *
2734      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2735      *
2736      * Tokens start existing when they are minted (`_mint`),
2737      * and stop existing when they are burned (`_burn`).
2738      */
2739     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2740         return _owners[tokenId] != address(0);
2741     }
2742 
2743     /**
2744      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2745      *
2746      * Requirements:
2747      *
2748      * - `tokenId` must exist.
2749      */
2750     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2751         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2752         address owner = ERC721.ownerOf(tokenId);
2753         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2754     }
2755 
2756     /**
2757      * @dev Safely mints `tokenId` and transfers it to `to`.
2758      *
2759      * Requirements:
2760      *
2761      * - `tokenId` must not exist.
2762      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2763      *
2764      * Emits a {Transfer} event.
2765      */
2766     function _safeMint(address to, uint256 tokenId) internal virtual {
2767         _safeMint(to, tokenId, "");
2768     }
2769 
2770     /**
2771      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2772      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2773      */
2774     function _safeMint(
2775         address to,
2776         uint256 tokenId,
2777         bytes memory _data
2778     ) internal virtual {
2779         _mint(to, tokenId);
2780         require(
2781             _checkOnERC721Received(address(0), to, tokenId, _data),
2782             "ERC721: transfer to non ERC721Receiver implementer"
2783         );
2784     }
2785 
2786     /**
2787      * @dev Mints `tokenId` and transfers it to `to`.
2788      *
2789      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2790      *
2791      * Requirements:
2792      *
2793      * - `tokenId` must not exist.
2794      * - `to` cannot be the zero address.
2795      *
2796      * Emits a {Transfer} event.
2797      */
2798     function _mint(address to, uint256 tokenId) internal virtual {
2799         require(to != address(0), "ERC721: mint to the zero address");
2800         require(!_exists(tokenId), "ERC721: token already minted");
2801 
2802         _beforeTokenTransfer(address(0), to, tokenId);
2803 
2804         _balances[to] += 1;
2805         _owners[tokenId] = to;
2806 
2807         emit Transfer(address(0), to, tokenId);
2808 
2809         _afterTokenTransfer(address(0), to, tokenId);
2810     }
2811 
2812     /**
2813      * @dev Destroys `tokenId`.
2814      * The approval is cleared when the token is burned.
2815      *
2816      * Requirements:
2817      *
2818      * - `tokenId` must exist.
2819      *
2820      * Emits a {Transfer} event.
2821      */
2822     function _burn(uint256 tokenId) internal virtual {
2823         address owner = ERC721.ownerOf(tokenId);
2824 
2825         _beforeTokenTransfer(owner, address(0), tokenId);
2826 
2827         // Clear approvals
2828         _approve(address(0), tokenId);
2829 
2830         _balances[owner] -= 1;
2831         delete _owners[tokenId];
2832 
2833         emit Transfer(owner, address(0), tokenId);
2834 
2835         _afterTokenTransfer(owner, address(0), tokenId);
2836     }
2837 
2838     /**
2839      * @dev Transfers `tokenId` from `from` to `to`.
2840      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2841      *
2842      * Requirements:
2843      *
2844      * - `to` cannot be the zero address.
2845      * - `tokenId` token must be owned by `from`.
2846      *
2847      * Emits a {Transfer} event.
2848      */
2849     function _transfer(
2850         address from,
2851         address to,
2852         uint256 tokenId
2853     ) internal virtual {
2854         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2855         require(to != address(0), "ERC721: transfer to the zero address");
2856 
2857         _beforeTokenTransfer(from, to, tokenId);
2858 
2859         // Clear approvals from the previous owner
2860         _approve(address(0), tokenId);
2861 
2862         _balances[from] -= 1;
2863         _balances[to] += 1;
2864         _owners[tokenId] = to;
2865 
2866         emit Transfer(from, to, tokenId);
2867 
2868         _afterTokenTransfer(from, to, tokenId);
2869     }
2870 
2871     /**
2872      * @dev Approve `to` to operate on `tokenId`
2873      *
2874      * Emits a {Approval} event.
2875      */
2876     function _approve(address to, uint256 tokenId) internal virtual {
2877         _tokenApprovals[tokenId] = to;
2878         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2879     }
2880 
2881     /**
2882      * @dev Approve `operator` to operate on all of `owner` tokens
2883      *
2884      * Emits a {ApprovalForAll} event.
2885      */
2886     function _setApprovalForAll(
2887         address owner,
2888         address operator,
2889         bool approved
2890     ) internal virtual {
2891         require(owner != operator, "ERC721: approve to caller");
2892         _operatorApprovals[owner][operator] = approved;
2893         emit ApprovalForAll(owner, operator, approved);
2894     }
2895 
2896     /**
2897      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2898      * The call is not executed if the target address is not a contract.
2899      *
2900      * @param from address representing the previous owner of the given token ID
2901      * @param to target address that will receive the tokens
2902      * @param tokenId uint256 ID of the token to be transferred
2903      * @param _data bytes optional data to send along with the call
2904      * @return bool whether the call correctly returned the expected magic value
2905      */
2906     function _checkOnERC721Received(
2907         address from,
2908         address to,
2909         uint256 tokenId,
2910         bytes memory _data
2911     ) private returns (bool) {
2912         if (to.isContract()) {
2913             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2914                 return retval == IERC721Receiver.onERC721Received.selector;
2915             } catch (bytes memory reason) {
2916                 if (reason.length == 0) {
2917                     revert("ERC721: transfer to non ERC721Receiver implementer");
2918                 } else {
2919                     assembly {
2920                         revert(add(32, reason), mload(reason))
2921                     }
2922                 }
2923             }
2924         } else {
2925             return true;
2926         }
2927     }
2928 
2929     /**
2930      * @dev Hook that is called before any token transfer. This includes minting
2931      * and burning.
2932      *
2933      * Calling conditions:
2934      *
2935      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2936      * transferred to `to`.
2937      * - When `from` is zero, `tokenId` will be minted for `to`.
2938      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2939      * - `from` and `to` are never both zero.
2940      *
2941      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2942      */
2943     function _beforeTokenTransfer(
2944         address from,
2945         address to,
2946         uint256 tokenId
2947     ) internal virtual {}
2948 
2949     /**
2950      * @dev Hook that is called after any transfer of tokens. This includes
2951      * minting and burning.
2952      *
2953      * Calling conditions:
2954      *
2955      * - when `from` and `to` are both non-zero.
2956      * - `from` and `to` are never both zero.
2957      *
2958      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2959      */
2960     function _afterTokenTransfer(
2961         address from,
2962         address to,
2963         uint256 tokenId
2964     ) internal virtual {}
2965 }
2966 
2967 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2968 
2969 
2970 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2971 
2972 pragma solidity ^0.8.0;
2973 
2974 
2975 
2976 /**
2977  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2978  * enumerability of all the token ids in the contract as well as all token ids owned by each
2979  * account.
2980  */
2981 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2982     // Mapping from owner to list of owned token IDs
2983     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2984 
2985     // Mapping from token ID to index of the owner tokens list
2986     mapping(uint256 => uint256) private _ownedTokensIndex;
2987 
2988     // Array with all token ids, used for enumeration
2989     uint256[] private _allTokens;
2990 
2991     // Mapping from token id to position in the allTokens array
2992     mapping(uint256 => uint256) private _allTokensIndex;
2993 
2994     /**
2995      * @dev See {IERC165-supportsInterface}.
2996      */
2997     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2998         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2999     }
3000 
3001     /**
3002      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3003      */
3004     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3005         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3006         return _ownedTokens[owner][index];
3007     }
3008 
3009     /**
3010      * @dev See {IERC721Enumerable-totalSupply}.
3011      */
3012     function totalSupply() public view virtual override returns (uint256) {
3013         return _allTokens.length;
3014     }
3015 
3016     /**
3017      * @dev See {IERC721Enumerable-tokenByIndex}.
3018      */
3019     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3020         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3021         return _allTokens[index];
3022     }
3023 
3024     /**
3025      * @dev Hook that is called before any token transfer. This includes minting
3026      * and burning.
3027      *
3028      * Calling conditions:
3029      *
3030      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3031      * transferred to `to`.
3032      * - When `from` is zero, `tokenId` will be minted for `to`.
3033      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3034      * - `from` cannot be the zero address.
3035      * - `to` cannot be the zero address.
3036      *
3037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3038      */
3039     function _beforeTokenTransfer(
3040         address from,
3041         address to,
3042         uint256 tokenId
3043     ) internal virtual override {
3044         super._beforeTokenTransfer(from, to, tokenId);
3045 
3046         if (from == address(0)) {
3047             _addTokenToAllTokensEnumeration(tokenId);
3048         } else if (from != to) {
3049             _removeTokenFromOwnerEnumeration(from, tokenId);
3050         }
3051         if (to == address(0)) {
3052             _removeTokenFromAllTokensEnumeration(tokenId);
3053         } else if (to != from) {
3054             _addTokenToOwnerEnumeration(to, tokenId);
3055         }
3056     }
3057 
3058     /**
3059      * @dev Private function to add a token to this extension's ownership-tracking data structures.
3060      * @param to address representing the new owner of the given token ID
3061      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
3062      */
3063     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
3064         uint256 length = ERC721.balanceOf(to);
3065         _ownedTokens[to][length] = tokenId;
3066         _ownedTokensIndex[tokenId] = length;
3067     }
3068 
3069     /**
3070      * @dev Private function to add a token to this extension's token tracking data structures.
3071      * @param tokenId uint256 ID of the token to be added to the tokens list
3072      */
3073     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
3074         _allTokensIndex[tokenId] = _allTokens.length;
3075         _allTokens.push(tokenId);
3076     }
3077 
3078     /**
3079      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
3080      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
3081      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
3082      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
3083      * @param from address representing the previous owner of the given token ID
3084      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
3085      */
3086     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3087         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3088         // then delete the last slot (swap and pop).
3089 
3090         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
3091         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3092 
3093         // When the token to delete is the last token, the swap operation is unnecessary
3094         if (tokenIndex != lastTokenIndex) {
3095             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3096 
3097             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3098             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3099         }
3100 
3101         // This also deletes the contents at the last position of the array
3102         delete _ownedTokensIndex[tokenId];
3103         delete _ownedTokens[from][lastTokenIndex];
3104     }
3105 
3106     /**
3107      * @dev Private function to remove a token from this extension's token tracking data structures.
3108      * This has O(1) time complexity, but alters the order of the _allTokens array.
3109      * @param tokenId uint256 ID of the token to be removed from the tokens list
3110      */
3111     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3112         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3113         // then delete the last slot (swap and pop).
3114 
3115         uint256 lastTokenIndex = _allTokens.length - 1;
3116         uint256 tokenIndex = _allTokensIndex[tokenId];
3117 
3118         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3119         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3120         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3121         uint256 lastTokenId = _allTokens[lastTokenIndex];
3122 
3123         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3124         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3125 
3126         // This also deletes the contents at the last position of the array
3127         delete _allTokensIndex[tokenId];
3128         _allTokens.pop();
3129     }
3130 }
3131 
3132 // File: @openzeppelin/contracts/access/Ownable.sol
3133 
3134 
3135 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
3136 
3137 pragma solidity ^0.8.0;
3138 
3139 
3140 /**
3141  * @dev Contract module which provides a basic access control mechanism, where
3142  * there is an account (an owner) that can be granted exclusive access to
3143  * specific functions.
3144  *
3145  * By default, the owner account will be the one that deploys the contract. This
3146  * can later be changed with {transferOwnership}.
3147  *
3148  * This module is used through inheritance. It will make available the modifier
3149  * `onlyOwner`, which can be applied to your functions to restrict their use to
3150  * the owner.
3151  */
3152 abstract contract Ownable is Context {
3153     address private _owner;
3154 
3155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3156 
3157     /**
3158      * @dev Initializes the contract setting the deployer as the initial owner.
3159      */
3160     constructor() {
3161         _transferOwnership(_msgSender());
3162     }
3163 
3164     /**
3165      * @dev Returns the address of the current owner.
3166      */
3167     function owner() public view virtual returns (address) {
3168         return _owner;
3169     }
3170 
3171     /**
3172      * @dev Throws if called by any account other than the owner.
3173      */
3174     modifier onlyOwner() {
3175         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3176         _;
3177     }
3178 
3179     /**
3180      * @dev Leaves the contract without owner. It will not be possible to call
3181      * `onlyOwner` functions anymore. Can only be called by the current owner.
3182      *
3183      * NOTE: Renouncing ownership will leave the contract without an owner,
3184      * thereby removing any functionality that is only available to the owner.
3185      */
3186     function renounceOwnership() public virtual onlyOwner {
3187         _transferOwnership(address(0));
3188     }
3189 
3190     /**
3191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3192      * Can only be called by the current owner.
3193      */
3194     function transferOwnership(address newOwner) public virtual onlyOwner {
3195         require(newOwner != address(0), "Ownable: new owner is the zero address");
3196         _transferOwnership(newOwner);
3197     }
3198 
3199     /**
3200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3201      * Internal function without access restriction.
3202      */
3203     function _transferOwnership(address newOwner) internal virtual {
3204         address oldOwner = _owner;
3205         _owner = newOwner;
3206         emit OwnershipTransferred(oldOwner, newOwner);
3207     }
3208 }
3209 
3210 // File: cosmicLabs.sol
3211 
3212 pragma solidity 0.8.7;
3213 
3214 
3215 
3216 contract CosmicLabs is ERC721Enumerable, IERC721Receiver, Ownable {
3217    
3218    using Strings for uint256;
3219    using EnumerableSet for EnumerableSet.UintSet;
3220    
3221     CosmicToken public cosmictoken;
3222     
3223     using Counters for Counters.Counter;
3224     Counters.Counter private _tokenIdTracker;
3225     
3226     string public baseURI;
3227     string public baseExtension = ".json";
3228 
3229     
3230     uint public maxGenesisTx = 4;
3231     uint public maxDuckTx = 20;
3232     
3233     
3234     uint public maxSupply = 9000;
3235     uint public genesisSupply = 1000;
3236     
3237     uint256 public price = 0.05 ether;
3238    
3239 
3240     bool public GensisSaleOpen = true;
3241     bool public GenesisFreeMintOpen = false;
3242     bool public DuckMintOpen = false;
3243     
3244     
3245     
3246     modifier isSaleOpen
3247     {
3248          require(GensisSaleOpen == true);
3249          _;
3250     }
3251     
3252     modifier isFreeMintOpen
3253     {
3254          require(GenesisFreeMintOpen == true);
3255          _;
3256     }
3257     
3258     modifier isDuckMintOpen
3259     {
3260          require(DuckMintOpen == true);
3261          _;
3262     }
3263     
3264 
3265     
3266     function switchFromFreeToDuckMint() public onlyOwner
3267     {
3268         GenesisFreeMintOpen = false;
3269         DuckMintOpen = true;
3270     }
3271     
3272     
3273     
3274     event mint(address to, uint total);
3275     event withdraw(uint total);
3276     event giveawayNft(address to, uint tokenID);
3277     
3278     mapping(address => uint256) public balanceOG;
3279     
3280     mapping(address => uint256) public maxWalletGenesisTX;
3281     mapping(address => uint256) public maxWalletDuckTX;
3282     
3283     mapping(address => EnumerableSet.UintSet) private _deposits;
3284     
3285     
3286     mapping(uint256 => uint256) public _deposit_blocks;
3287     
3288     mapping(address => bool) public addressStaked;
3289     
3290     //ID - Days staked;
3291     mapping(uint256 => uint256) public IDvsDaysStaked;
3292     mapping (address => uint256) public whitelistMintAmount;
3293     
3294 
3295    address internal communityWallet = 0xea25545d846ecF4999C2875bC77dE5B5151Fa633;
3296    
3297     constructor(string memory _initBaseURI) ERC721("Cosmic Labs", "CLABS")
3298     {
3299         setBaseURI(_initBaseURI);
3300     }
3301    
3302    
3303     function setPrice(uint256 newPrice) external onlyOwner {
3304         price = newPrice;
3305     }
3306    
3307     
3308     function setYieldToken(address _yield) external onlyOwner {
3309 		cosmictoken = CosmicToken(_yield);
3310 	}
3311 	
3312 	function totalToken() public view returns (uint256) {
3313             return _tokenIdTracker.current();
3314     }
3315     
3316     modifier communityWalletOnly
3317     {
3318          require(msg.sender == communityWallet);
3319          _;
3320     }
3321     	
3322 	function communityDuckMint(uint256 amountForAirdrops) public onlyOwner
3323 	{
3324         for(uint256 i; i<amountForAirdrops; i++)
3325         {
3326              _tokenIdTracker.increment();
3327             _safeMint(communityWallet, totalToken());
3328         }
3329 	}
3330 
3331     function GenesisSale(uint8 mintTotal) public payable isSaleOpen
3332     {
3333         uint256 totalMinted = maxWalletGenesisTX[msg.sender];
3334         totalMinted = totalMinted + mintTotal;
3335         
3336         require(mintTotal >= 1 && mintTotal <= maxGenesisTx, "Mint Amount Incorrect");
3337         require(totalToken() < genesisSupply, "SOLD OUT!");
3338         require(maxWalletGenesisTX[msg.sender] <= maxGenesisTx, "You've maxed your limit!");
3339         require(msg.value >= price * mintTotal, "Minting a Genesis Costs 0.05 Ether Each!");
3340         require(totalMinted <= maxGenesisTx, "You'll surpass your limit!");
3341         
3342         
3343         for(uint8 i=0;i<mintTotal;i++)
3344         {
3345             whitelistMintAmount[msg.sender] += 1;
3346             maxWalletGenesisTX[msg.sender] += 1;
3347             _tokenIdTracker.increment();
3348             _safeMint(msg.sender, totalToken());
3349             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
3350             emit mint(msg.sender, totalToken());
3351         }
3352         
3353         if(totalToken() == genesisSupply)
3354         {
3355             GensisSaleOpen = false;
3356             GenesisFreeMintOpen = true;
3357         }
3358        
3359     }	
3360 
3361     function GenesisFreeMint(uint8 mintTotal)public payable isFreeMintOpen
3362     {
3363         require(whitelistMintAmount[msg.sender] > 0, "You don't have any free mints!");
3364         require(totalToken() < maxSupply, "SOLD OUT!");
3365         require(mintTotal <= whitelistMintAmount[msg.sender], "You are passing your limit!");
3366         
3367         for(uint8 i=0;i<mintTotal;i++)
3368         {
3369             whitelistMintAmount[msg.sender] -= 1;
3370             _tokenIdTracker.increment();
3371             _safeMint(msg.sender, totalToken());
3372             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
3373             emit mint(msg.sender, totalToken());
3374         }
3375     }
3376 	
3377 
3378     function DuckSale(uint8 mintTotal)public payable isDuckMintOpen
3379     {
3380         uint256 totalMinted = maxWalletDuckTX[msg.sender];
3381         totalMinted = totalMinted + mintTotal;        
3382     
3383         require(mintTotal >= 1 && mintTotal <= maxDuckTx, "Mint Amount Incorrect");
3384         require(msg.value >= price * mintTotal, "Minting a Duck Costs 0.05 Ether Each!");
3385         require(totalToken() < maxSupply, "SOLD OUT!");
3386         require(maxWalletDuckTX[msg.sender] <= maxDuckTx, "You've maxed your limit!");
3387         require(totalMinted <= maxDuckTx, "You'll surpass your limit!");
3388         
3389         for(uint8 i=0;i<mintTotal;i++)
3390         {
3391             maxWalletDuckTX[msg.sender] += 1;
3392             _tokenIdTracker.increment();
3393             _safeMint(msg.sender, totalToken());
3394             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
3395             emit mint(msg.sender, totalToken());
3396         }
3397         
3398         if(totalToken() == maxSupply)
3399         {
3400             DuckMintOpen = false;
3401         }
3402     }
3403    
3404    
3405     function airdropNft(address airdropPatricipent, uint16 tokenID) public payable communityWalletOnly
3406     {
3407         _transfer(msg.sender, airdropPatricipent, tokenID);
3408         emit giveawayNft(airdropPatricipent, tokenID);
3409     }
3410     
3411     function airdropMany(address[] memory airdropPatricipents) public payable communityWalletOnly
3412     {
3413         uint256[] memory tempWalletOfUser = this.walletOfOwner(msg.sender);
3414         
3415         require(tempWalletOfUser.length >= airdropPatricipents.length, "You dont have enough tokens to airdrop all!");
3416         
3417        for(uint256 i=0; i<airdropPatricipents.length; i++)
3418        {
3419             _transfer(msg.sender, airdropPatricipents[i], tempWalletOfUser[i]);
3420             emit giveawayNft(airdropPatricipents[i], tempWalletOfUser[i]);
3421        }
3422 
3423     }    
3424     
3425     function withdrawContractEther(address payable recipient) external onlyOwner
3426     {
3427         emit withdraw(getBalance());
3428         recipient.transfer(getBalance());
3429     }
3430     function getBalance() public view returns(uint)
3431     {
3432         return address(this).balance;
3433     }
3434    
3435     function _baseURI() internal view virtual override returns (string memory) {
3436         return baseURI;
3437     }
3438    
3439     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3440         baseURI = _newBaseURI;
3441     }
3442    
3443     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
3444     {
3445         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3446 
3447         string memory currentBaseURI = _baseURI();
3448         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
3449     }
3450     
3451 	function getReward(uint256 CalculatedPayout) internal
3452 	{
3453 		cosmictoken.getReward(msg.sender, CalculatedPayout);
3454 	}    
3455     
3456     //Staking Functions
3457     function depositStake(uint256[] calldata tokenIds) external {
3458         
3459         require(isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
3460         
3461         
3462         for (uint256 i; i < tokenIds.length; i++) {
3463             safeTransferFrom(
3464                 msg.sender,
3465                 address(this),
3466                 tokenIds[i],
3467                 ''
3468             );
3469             
3470             _deposits[msg.sender].add(tokenIds[i]);
3471             addressStaked[msg.sender] = true;
3472             
3473             
3474             _deposit_blocks[tokenIds[i]] = block.timestamp;
3475             
3476 
3477             IDvsDaysStaked[tokenIds[i]] = block.timestamp;
3478         }
3479         
3480     }
3481     function withdrawStake(uint256[] calldata tokenIds) external {
3482         
3483         require(isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
3484         
3485         for (uint256 i; i < tokenIds.length; i++) {
3486             require(
3487                 _deposits[msg.sender].contains(tokenIds[i]),
3488                 'Token not deposited'
3489             );
3490             
3491             cosmictoken.getReward(msg.sender,totalRewardsToPay(tokenIds[i]));
3492             
3493             _deposits[msg.sender].remove(tokenIds[i]);
3494              _deposit_blocks[tokenIds[i]] = 0;
3495             addressStaked[msg.sender] = false;
3496             IDvsDaysStaked[tokenIds[i]] = block.timestamp;
3497             
3498             this.safeTransferFrom(
3499                 address(this),
3500                 msg.sender,
3501                 tokenIds[i],
3502                 ''
3503             );
3504         }
3505     }
3506 
3507     
3508     function viewRewards() external view returns (uint256)
3509     {
3510         uint256 payout = 0;
3511         
3512         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
3513         {
3514             payout = payout + totalRewardsToPay(_deposits[msg.sender].at(i));
3515         }
3516         return payout;
3517     }
3518     
3519     function claimRewards() external
3520     {
3521         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
3522         {
3523             cosmictoken.getReward(msg.sender, totalRewardsToPay(_deposits[msg.sender].at(i)));
3524             IDvsDaysStaked[_deposits[msg.sender].at(i)] = block.timestamp;
3525         }
3526     }   
3527     
3528     function totalRewardsToPay(uint256 tokenId) internal view returns(uint256)
3529     {
3530         uint256 payout = 0;
3531         
3532         if(tokenId > 0 && tokenId <= genesisSupply)
3533         {
3534             payout = howManyDaysStaked(tokenId) * 20;
3535         }
3536         else if (tokenId > genesisSupply && tokenId <= maxSupply)
3537         {
3538             payout = howManyDaysStaked(tokenId) * 5;
3539         }
3540         
3541         return payout;
3542     }
3543     
3544     function howManyDaysStaked(uint256 tokenId) public view returns(uint256)
3545     {
3546         
3547         require(
3548             _deposits[msg.sender].contains(tokenId),
3549             'Token not deposited'
3550         );
3551         
3552         uint256 returndays;
3553         uint256 timeCalc = block.timestamp - IDvsDaysStaked[tokenId];
3554         returndays = timeCalc / 86400;
3555        
3556         return returndays;
3557     }
3558     
3559     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
3560         uint256 tokenCount = balanceOf(_owner);
3561 
3562         uint256[] memory tokensId = new uint256[](tokenCount);
3563         for (uint256 i = 0; i < tokenCount; i++) {
3564             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
3565         }
3566 
3567         return tokensId;
3568     }
3569     
3570     function returnStakedTokens() public view returns (uint256[] memory)
3571     {
3572         return _deposits[msg.sender].values();
3573     }
3574     
3575     function totalTokensInWallet() public view returns(uint256)
3576     {
3577         return cosmictoken.balanceOf(msg.sender);
3578     }
3579     
3580    
3581     function onERC721Received(
3582         address,
3583         address,
3584         uint256,
3585         bytes calldata
3586     ) external pure override returns (bytes4) {
3587         return IERC721Receiver.onERC721Received.selector;
3588     }
3589 }
3590 // File: cosmicFusion.sol
3591 
3592 
3593 pragma solidity 0.8.7;
3594 
3595 
3596 
3597 
3598 
3599 
3600 
3601 contract CosmicFusion is ERC721A, Ownable, ReentrancyGuard
3602 {
3603     using Address for address;
3604     using Strings for uint256;
3605     using Counters for Counters.Counter;
3606 
3607     Counters.Counter private _tokenIdTracker;
3608 
3609     string public baseURI;
3610     string public baseExtension = ".json";
3611 
3612     mapping (uint256 => address) public fusionIndexToAddress;
3613     mapping (uint256 => bool) public hasFused;
3614 
3615     CosmicLabs public cosmicLabs;
3616 
3617     constructor() ERC721A("Cosmic Fusion", "CFUSION", 100) 
3618     {
3619         
3620     }
3621 
3622     function setCosmicLabsAddress(address clabsAddress) public onlyOwner
3623     {
3624         cosmicLabs = CosmicLabs(clabsAddress);
3625     }
3626 
3627     modifier onlySender {
3628         require(msg.sender == tx.origin);
3629         _;
3630     }
3631 
3632     function teamMint(uint256 amount) public onlyOwner nonReentrant
3633     {
3634         for(uint i=0;i<amount;i++)
3635         {
3636             fusionIndexToAddress[_tokenIdTracker.current()] = msg.sender;
3637             _tokenIdTracker.increment();
3638         }
3639         _safeMint(msg.sender, amount);
3640     }
3641 
3642     function FuseDucks(uint256[] memory tokenIds) public payable nonReentrant
3643     {
3644         require(tokenIds.length % 2 == 0, "Odd amount of Ducks Selected");
3645 
3646         for(uint256 i=0; i<tokenIds.length; i++)
3647         {
3648             require(tokenIds[i] >= 1001 , "You selected a Genesis");
3649             require(!hasFused[tokenIds[i]], "These ducks have already fused!");
3650             cosmicLabs.transferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD ,tokenIds[i]);
3651             hasFused[tokenIds[i]] = true;
3652         }
3653 
3654         uint256 fuseAmount = tokenIds.length / 2;
3655         
3656         for(uint256 i=0; i<fuseAmount; i++)
3657         {
3658             fusionIndexToAddress[_tokenIdTracker.current()] = msg.sender;
3659             _tokenIdTracker.increment();
3660         }
3661         _safeMint(msg.sender, fuseAmount);
3662         
3663     }
3664 
3665 
3666     function _withdraw(address payable address_, uint256 amount_) internal {
3667         (bool success, ) = payable(address_).call{value: amount_}("");
3668         require(success, "Transfer failed");
3669     }
3670 
3671     function withdrawEther() external onlyOwner {
3672         _withdraw(payable(msg.sender), address(this).balance);
3673     }
3674 
3675     function withdrawEtherTo(address payable to_) external onlyOwner {
3676         _withdraw(to_, address(this).balance);
3677     }
3678     
3679     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3680         baseURI = _newBaseURI;
3681     }
3682     function _baseURI() internal view virtual override returns (string memory) {
3683         return baseURI;
3684     }   
3685     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
3686     {
3687         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3688 
3689         string memory currentBaseURI = _baseURI();
3690         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
3691     }
3692 
3693     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
3694         uint256 _balance = balanceOf(address_);
3695         uint256[] memory _tokens = new uint256[] (_balance);
3696         uint256 _index;
3697         uint256 _loopThrough = totalSupply();
3698         for (uint256 i = 0; i < _loopThrough; i++) {
3699             bool _exists = _exists(i);
3700             if (_exists) {
3701                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
3702             }
3703             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
3704         }
3705         return _tokens;
3706     }
3707 
3708     function transferFrom(address from, address to, uint256 tokenId) public  override {
3709         fusionIndexToAddress[tokenId] = to;
3710 		ERC721A.transferFrom(from, to, tokenId);
3711 	}
3712 
3713 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public  override {
3714         fusionIndexToAddress[tokenId] = to;
3715 		ERC721A.safeTransferFrom(from, to, tokenId, _data);
3716 	}
3717 
3718 
3719     
3720 }
3721 // File: ERC20I.sol
3722 
3723 
3724 pragma solidity ^0.8.0;
3725 
3726 /*
3727     ERC20I (ERC20 0xInuarashi Edition)
3728     Minified and Gas Optimized
3729     Contributors: 0xInuarashi (Message to Martians, Anonymice), 0xBasset (Ether Orcs)
3730 */
3731 
3732 contract ERC20I {
3733     // Token Params
3734     string public name;
3735     string public symbol;
3736     constructor(string memory name_, string memory symbol_) {
3737         name = name_;
3738         symbol = symbol_;
3739     }
3740 
3741     // Decimals
3742     uint8 public constant decimals = 18;
3743 
3744     // Supply
3745     uint256 public totalSupply;
3746     
3747     // Mappings of Balances
3748     mapping(address => uint256) public balanceOf;
3749     mapping(address => mapping(address => uint256)) public allowance;
3750 
3751     // Events
3752     event Transfer(address indexed from, address indexed to, uint256 value);
3753     event Approval(address indexed owner, address indexed spender, uint256 value);
3754 
3755     // Internal Functions
3756     function _mint(address to_, uint256 amount_) internal virtual {
3757         totalSupply += amount_;
3758         balanceOf[to_] += amount_;
3759         emit Transfer(address(0x0), to_, amount_);
3760     }
3761     function _burn(address from_, uint256 amount_) internal virtual {
3762         balanceOf[from_] -= amount_;
3763         totalSupply -= amount_;
3764         emit Transfer(from_, address(0x0), amount_);
3765     }
3766     function _approve(address owner_, address spender_, uint256 amount_) internal virtual {
3767         allowance[owner_][spender_] = amount_;
3768         emit Approval(owner_, spender_, amount_);
3769     }
3770 
3771     // Public Functions
3772     function approve(address spender_, uint256 amount_) public virtual returns (bool) {
3773         _approve(msg.sender, spender_, amount_);
3774         return true;
3775     }
3776     function transfer(address to_, uint256 amount_) public virtual returns (bool) {
3777         balanceOf[msg.sender] -= amount_;
3778         balanceOf[to_] += amount_;
3779         emit Transfer(msg.sender, to_, amount_);
3780         return true;
3781     }
3782     function transferFrom(address from_, address to_, uint256 amount_) public virtual returns (bool) {
3783         if (allowance[from_][msg.sender] != type(uint256).max) {
3784             allowance[from_][msg.sender] -= amount_; }
3785         balanceOf[from_] -= amount_;
3786         balanceOf[to_] += amount_;
3787         emit Transfer(from_, to_, amount_);
3788         return true;
3789     }
3790 
3791     // 0xInuarashi Custom Functions
3792     function multiTransfer(address[] memory to_, uint256[] memory amounts_) public virtual {
3793         require(to_.length == amounts_.length, "ERC20I: To and Amounts length Mismatch!");
3794         for (uint256 i = 0; i < to_.length; i++) {
3795             transfer(to_[i], amounts_[i]);
3796         }
3797     }
3798     function multiTransferFrom(address[] memory from_, address[] memory to_, uint256[] memory amounts_) public virtual {
3799         require(from_.length == to_.length && from_.length == amounts_.length, "ERC20I: From, To, and Amounts length Mismatch!");
3800         for (uint256 i = 0; i < from_.length; i++) {
3801             transferFrom(from_[i], to_[i], amounts_[i]);
3802         }
3803     }
3804 
3805     function burn(uint256 amount_) external virtual {
3806         _burn(msg.sender, amount_);
3807     }
3808     function burnFrom(address from_, uint256 amount_) public virtual {
3809         uint256 _currentAllowance = allowance[from_][msg.sender];
3810         require(_currentAllowance >= amount_, "ERC20IBurnable: Burn amount requested exceeds allowance!");
3811 
3812         if (allowance[from_][msg.sender] != type(uint256).max) {
3813             allowance[from_][msg.sender] -= amount_; }
3814 
3815         _burn(from_, amount_);
3816     }
3817 }
3818 // File: newCut.sol
3819 
3820 pragma solidity 0.8.7;
3821 
3822 
3823 
3824 
3825 
3826 
3827 
3828 
3829 /// SPDX-License-Identifier: UNLICENSED
3830 
3831 contract CosmicUtilityToken is ERC20I, Ownable, ReentrancyGuard {
3832 
3833 
3834     mapping (uint256 => uint256) public tokenIdEarned;
3835     mapping (uint256 => uint256) public fusionEarned;
3836 
3837     uint256 public GENESIS_RATE = 0.02777777777 ether;
3838     uint256 public FUSION_RATE = 12 ether;
3839 
3840     //  Sat Feb 22 2022 05:00:00 GMT+0000
3841     uint256 public startTime = 1645506000;
3842 
3843     //	Sat Feb 22 2025 05:00:00 GMT+0000
3844     uint256 public constant endTimeFusion = 1740200400;
3845     
3846     uint256 public totalTokensBurned = 0;
3847 
3848     mapping (address => bool) public firstClaim;
3849 
3850     mapping(uint256 => uint256) public fusionToTimestamp;
3851 
3852     CosmicLabs public cosmicLabs;
3853     CosmicToken public cosmicToken;
3854     CosmicFusion public cosmicFusion;
3855 
3856     constructor(address CLABS, address CUT) ERC20I("Cosmic Utility Token", "CUT")
3857     {
3858         cosmicLabs = CosmicLabs(CLABS);
3859         cosmicToken = CosmicToken(CUT);
3860     }
3861 
3862     function setFusionContract(address fusionContract) public onlyOwner
3863     {
3864         cosmicFusion = CosmicFusion(fusionContract);
3865     }
3866     function setCosmicLabsContract(address clabsContract) public onlyOwner
3867     {
3868         cosmicLabs = CosmicLabs(clabsContract);
3869     }
3870     function changeGenesis_Rate(uint256 _incoming) public onlyOwner
3871     {
3872         GENESIS_RATE = _incoming;
3873     }
3874 
3875     function changeFusion_Rate(uint256 _incoming) public onlyOwner
3876     {
3877         FUSION_RATE = _incoming;
3878     }
3879 
3880     function teamMint(uint256 totalAmount) public onlyOwner stakingEnded
3881     {
3882         _mint(msg.sender, (totalAmount * 10 ** 18));
3883     }
3884     
3885     //migrate old cut to new cut
3886     modifier hasMigrated
3887     {
3888         require(firstClaim[msg.sender] == false);
3889         _;
3890     }
3891     modifier stakingEnded
3892     {
3893         require(block.timestamp < endTimeFusion);
3894         _;
3895     }
3896     function migrateCut() public nonReentrant hasMigrated stakingEnded
3897     {
3898         uint256 howManyTokens = cosmicToken.balanceOf(msg.sender);
3899         uint256 extraCommision = (howManyTokens * 10) / 100;
3900 
3901         cosmicToken.transferFrom(msg.sender, address(this), howManyTokens);
3902 
3903         firstClaim[msg.sender] = true;
3904         _mint(msg.sender, (howManyTokens + extraCommision));
3905     }
3906 
3907     //Genesis Ducks functions
3908 
3909     function claimRewards(uint256[] memory nftsToClaim) public nonReentrant stakingEnded
3910     {
3911         for(uint256 i=0;i<nftsToClaim.length;i++)
3912         {
3913             require(cosmicLabs.ownerOf(nftsToClaim[i]) == msg.sender, "You are not the owner of these tokens");
3914         }
3915 
3916         _mint(msg.sender, tokensAccumulated(nftsToClaim));
3917         
3918         for(uint256 i=0; i<nftsToClaim.length;i++)
3919         {
3920             tokenIdEarned[nftsToClaim[i]] = block.timestamp;
3921         }
3922     }
3923 
3924     function tokensAccumulated(uint256[] memory nftsToCheck) public view returns(uint256)
3925     {
3926         uint256 totalTokensEarned;
3927 
3928         for(uint256 i=0; i<nftsToCheck.length;i++)
3929         {
3930             if(nftsToCheck[i] <= 1000)
3931             {
3932                 totalTokensEarned += (howManyMinStaked(nftsToCheck[i]) * GENESIS_RATE);
3933             }
3934         }
3935 
3936         return totalTokensEarned;
3937 
3938     }
3939 
3940     function howManyMinStaked(uint256 tokenId) public view returns(uint256)
3941     {
3942         uint256 timeCalc;
3943 
3944         if(tokenIdEarned[tokenId] == 0)
3945         {
3946             timeCalc = block.timestamp - startTime;
3947         }
3948         else
3949         {
3950             timeCalc = block.timestamp - tokenIdEarned[tokenId];
3951         }
3952         
3953         uint256 returnMins = timeCalc / 60;
3954        
3955         return returnMins;
3956     }
3957 
3958     //fusion passive staking methods
3959     function getPendingTokensFusion(uint256 tokenId_) public view returns (uint256) {
3960         uint256 _timestamp = fusionToTimestamp[tokenId_] == 0 ?
3961             startTime : fusionToTimestamp[tokenId_] > endTimeFusion ? 
3962             endTimeFusion : fusionToTimestamp[tokenId_];
3963         uint256 _currentTimeOrEnd = block.timestamp > endTimeFusion ?
3964             endTimeFusion : block.timestamp;
3965         uint256 _timeElapsed = _currentTimeOrEnd - _timestamp;
3966 
3967         return (_timeElapsed * FUSION_RATE) / 1 days;
3968     }
3969     function getPendingTokensManyFusion(uint256[] memory tokenIds_) public view 
3970     returns (uint256) {
3971         uint256 _pendingTokens;
3972         for (uint256 i = 0; i < tokenIds_.length; i++) {
3973             _pendingTokens += getPendingTokensFusion(tokenIds_[i]);
3974         }
3975         return _pendingTokens;
3976     }
3977 
3978     function claimFusion(address to_, uint256[] memory tokenIds_) external {
3979         require(tokenIds_.length > 0, 
3980             "You must claim at least 1 Fusion!");
3981 
3982         uint256 _pendingTokens = tokenIds_.length > 1 ?
3983             getPendingTokensManyFusion(tokenIds_) :
3984             getPendingTokensFusion(tokenIds_[0]);
3985         
3986         // Run loop to update timestamp for each fusion
3987         for (uint256 i = 0; i < tokenIds_.length; i++) {
3988             require(to_ == cosmicFusion.fusionIndexToAddress(tokenIds_[i]),
3989                 "claim(): to_ is not owner of Cosmic Fusion!");
3990 
3991             fusionToTimestamp[tokenIds_[i]] = block.timestamp;
3992         }
3993         
3994         _mint(to_, _pendingTokens);
3995     }
3996 
3997     function getPendingTokensOfAddress(address address_) public view returns (uint256) {
3998         uint256[] memory _tokensOfAddress = cosmicFusion.walletOfOwner(address_);
3999         return getPendingTokensManyFusion(_tokensOfAddress);
4000     }
4001   
4002 
4003     //deflationary 
4004     function burn(address _from, uint256 _amount) external 
4005 	{
4006 	    require(msg.sender == _from, "You do not own these tokens");
4007 		_burn(_from, _amount);
4008 		totalTokensBurned += _amount;
4009 	}
4010 
4011     function burnFrom(address _from, uint256 _amount) public override
4012     {
4013         ERC20I.burnFrom(_from, _amount);
4014     }
4015 
4016     
4017 }