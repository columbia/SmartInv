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
752 // File: @openzeppelin/contracts/utils/Counters.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @title Counters
761  * @author Matt Condon (@shrugs)
762  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
763  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
764  *
765  * Include with `using Counters for Counters.Counter;`
766  */
767 library Counters {
768     struct Counter {
769         // This variable should never be directly accessed by users of the library: interactions must be restricted to
770         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
771         // this feature: see https://github.com/ethereum/solidity/issues/4637
772         uint256 _value; // default: 0
773     }
774 
775     function current(Counter storage counter) internal view returns (uint256) {
776         return counter._value;
777     }
778 
779     function increment(Counter storage counter) internal {
780         unchecked {
781             counter._value += 1;
782         }
783     }
784 
785     function decrement(Counter storage counter) internal {
786         uint256 value = counter._value;
787         require(value > 0, "Counter: decrement overflow");
788         unchecked {
789             counter._value = value - 1;
790         }
791     }
792 
793     function reset(Counter storage counter) internal {
794         counter._value = 0;
795     }
796 }
797 
798 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
799 
800 
801 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
802 
803 pragma solidity ^0.8.0;
804 
805 /**
806  * @dev Contract module that helps prevent reentrant calls to a function.
807  *
808  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
809  * available, which can be applied to functions to make sure there are no nested
810  * (reentrant) calls to them.
811  *
812  * Note that because there is a single `nonReentrant` guard, functions marked as
813  * `nonReentrant` may not call one another. This can be worked around by making
814  * those functions `private`, and then adding `external` `nonReentrant` entry
815  * points to them.
816  *
817  * TIP: If you would like to learn more about reentrancy and alternative ways
818  * to protect against it, check out our blog post
819  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
820  */
821 abstract contract ReentrancyGuard {
822     // Booleans are more expensive than uint256 or any type that takes up a full
823     // word because each write operation emits an extra SLOAD to first read the
824     // slot's contents, replace the bits taken up by the boolean, and then write
825     // back. This is the compiler's defense against contract upgrades and
826     // pointer aliasing, and it cannot be disabled.
827 
828     // The values being non-zero value makes deployment a bit more expensive,
829     // but in exchange the refund on every call to nonReentrant will be lower in
830     // amount. Since refunds are capped to a percentage of the total
831     // transaction's gas, it is best to keep them low in cases like this one, to
832     // increase the likelihood of the full refund coming into effect.
833     uint256 private constant _NOT_ENTERED = 1;
834     uint256 private constant _ENTERED = 2;
835 
836     uint256 private _status;
837 
838     constructor() {
839         _status = _NOT_ENTERED;
840     }
841 
842     /**
843      * @dev Prevents a contract from calling itself, directly or indirectly.
844      * Calling a `nonReentrant` function from another `nonReentrant`
845      * function is not supported. It is possible to prevent this from happening
846      * by making the `nonReentrant` function external, and making it call a
847      * `private` function that does the actual work.
848      */
849     modifier nonReentrant() {
850         // On the first call to nonReentrant, _notEntered will be true
851         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
852 
853         // Any calls to nonReentrant after this point will fail
854         _status = _ENTERED;
855 
856         _;
857 
858         // By storing the original value once again, a refund is triggered (see
859         // https://eips.ethereum.org/EIPS/eip-2200)
860         _status = _NOT_ENTERED;
861     }
862 }
863 
864 // File: @openzeppelin/contracts/utils/Strings.sol
865 
866 
867 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
868 
869 pragma solidity ^0.8.0;
870 
871 /**
872  * @dev String operations.
873  */
874 library Strings {
875     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
876 
877     /**
878      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
879      */
880     function toString(uint256 value) internal pure returns (string memory) {
881         // Inspired by OraclizeAPI's implementation - MIT licence
882         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
883 
884         if (value == 0) {
885             return "0";
886         }
887         uint256 temp = value;
888         uint256 digits;
889         while (temp != 0) {
890             digits++;
891             temp /= 10;
892         }
893         bytes memory buffer = new bytes(digits);
894         while (value != 0) {
895             digits -= 1;
896             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
897             value /= 10;
898         }
899         return string(buffer);
900     }
901 
902     /**
903      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
904      */
905     function toHexString(uint256 value) internal pure returns (string memory) {
906         if (value == 0) {
907             return "0x00";
908         }
909         uint256 temp = value;
910         uint256 length = 0;
911         while (temp != 0) {
912             length++;
913             temp >>= 8;
914         }
915         return toHexString(value, length);
916     }
917 
918     /**
919      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
920      */
921     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
922         bytes memory buffer = new bytes(2 * length + 2);
923         buffer[0] = "0";
924         buffer[1] = "x";
925         for (uint256 i = 2 * length + 1; i > 1; --i) {
926             buffer[i] = _HEX_SYMBOLS[value & 0xf];
927             value >>= 4;
928         }
929         require(value == 0, "Strings: hex length insufficient");
930         return string(buffer);
931     }
932 }
933 
934 // File: @openzeppelin/contracts/utils/Context.sol
935 
936 
937 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 /**
942  * @dev Provides information about the current execution context, including the
943  * sender of the transaction and its data. While these are generally available
944  * via msg.sender and msg.data, they should not be accessed in such a direct
945  * manner, since when dealing with meta-transactions the account sending and
946  * paying for execution may not be the actual sender (as far as an application
947  * is concerned).
948  *
949  * This contract is only required for intermediate, library-like contracts.
950  */
951 abstract contract Context {
952     function _msgSender() internal view virtual returns (address) {
953         return msg.sender;
954     }
955 
956     function _msgData() internal view virtual returns (bytes calldata) {
957         return msg.data;
958     }
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
962 
963 
964 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 
969 
970 
971 /**
972  * @dev Implementation of the {IERC20} interface.
973  *
974  * This implementation is agnostic to the way tokens are created. This means
975  * that a supply mechanism has to be added in a derived contract using {_mint}.
976  * For a generic mechanism see {ERC20PresetMinterPauser}.
977  *
978  * TIP: For a detailed writeup see our guide
979  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
980  * to implement supply mechanisms].
981  *
982  * We have followed general OpenZeppelin Contracts guidelines: functions revert
983  * instead returning `false` on failure. This behavior is nonetheless
984  * conventional and does not conflict with the expectations of ERC20
985  * applications.
986  *
987  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
988  * This allows applications to reconstruct the allowance for all accounts just
989  * by listening to said events. Other implementations of the EIP may not emit
990  * these events, as it isn't required by the specification.
991  *
992  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
993  * functions have been added to mitigate the well-known issues around setting
994  * allowances. See {IERC20-approve}.
995  */
996 contract ERC20 is Context, IERC20, IERC20Metadata {
997     mapping(address => uint256) private _balances;
998 
999     mapping(address => mapping(address => uint256)) private _allowances;
1000 
1001     uint256 private _totalSupply;
1002 
1003     string private _name;
1004     string private _symbol;
1005 
1006     /**
1007      * @dev Sets the values for {name} and {symbol}.
1008      *
1009      * The default value of {decimals} is 18. To select a different value for
1010      * {decimals} you should overload it.
1011      *
1012      * All two of these values are immutable: they can only be set once during
1013      * construction.
1014      */
1015     constructor(string memory name_, string memory symbol_) {
1016         _name = name_;
1017         _symbol = symbol_;
1018     }
1019 
1020     /**
1021      * @dev Returns the name of the token.
1022      */
1023     function name() public view virtual override returns (string memory) {
1024         return _name;
1025     }
1026 
1027     /**
1028      * @dev Returns the symbol of the token, usually a shorter version of the
1029      * name.
1030      */
1031     function symbol() public view virtual override returns (string memory) {
1032         return _symbol;
1033     }
1034 
1035     /**
1036      * @dev Returns the number of decimals used to get its user representation.
1037      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1038      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1039      *
1040      * Tokens usually opt for a value of 18, imitating the relationship between
1041      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1042      * overridden;
1043      *
1044      * NOTE: This information is only used for _display_ purposes: it in
1045      * no way affects any of the arithmetic of the contract, including
1046      * {IERC20-balanceOf} and {IERC20-transfer}.
1047      */
1048     function decimals() public view virtual override returns (uint8) {
1049         return 18;
1050     }
1051 
1052     /**
1053      * @dev See {IERC20-totalSupply}.
1054      */
1055     function totalSupply() public view virtual override returns (uint256) {
1056         return _totalSupply;
1057     }
1058 
1059     /**
1060      * @dev See {IERC20-balanceOf}.
1061      */
1062     function balanceOf(address account) public view virtual override returns (uint256) {
1063         return _balances[account];
1064     }
1065 
1066     /**
1067      * @dev See {IERC20-transfer}.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - the caller must have a balance of at least `amount`.
1073      */
1074     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1075         address owner = _msgSender();
1076         _transfer(owner, to, amount);
1077         return true;
1078     }
1079 
1080     /**
1081      * @dev See {IERC20-allowance}.
1082      */
1083     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1084         return _allowances[owner][spender];
1085     }
1086 
1087     /**
1088      * @dev See {IERC20-approve}.
1089      *
1090      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1091      * `transferFrom`. This is semantically equivalent to an infinite approval.
1092      *
1093      * Requirements:
1094      *
1095      * - `spender` cannot be the zero address.
1096      */
1097     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1098         address owner = _msgSender();
1099         _approve(owner, spender, amount);
1100         return true;
1101     }
1102 
1103     /**
1104      * @dev See {IERC20-transferFrom}.
1105      *
1106      * Emits an {Approval} event indicating the updated allowance. This is not
1107      * required by the EIP. See the note at the beginning of {ERC20}.
1108      *
1109      * NOTE: Does not update the allowance if the current allowance
1110      * is the maximum `uint256`.
1111      *
1112      * Requirements:
1113      *
1114      * - `from` and `to` cannot be the zero address.
1115      * - `from` must have a balance of at least `amount`.
1116      * - the caller must have allowance for ``from``'s tokens of at least
1117      * `amount`.
1118      */
1119     function transferFrom(
1120         address from,
1121         address to,
1122         uint256 amount
1123     ) public virtual override returns (bool) {
1124         address spender = _msgSender();
1125         _spendAllowance(from, spender, amount);
1126         _transfer(from, to, amount);
1127         return true;
1128     }
1129 
1130     /**
1131      * @dev Atomically increases the allowance granted to `spender` by the caller.
1132      *
1133      * This is an alternative to {approve} that can be used as a mitigation for
1134      * problems described in {IERC20-approve}.
1135      *
1136      * Emits an {Approval} event indicating the updated allowance.
1137      *
1138      * Requirements:
1139      *
1140      * - `spender` cannot be the zero address.
1141      */
1142     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1143         address owner = _msgSender();
1144         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1145         return true;
1146     }
1147 
1148     /**
1149      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1150      *
1151      * This is an alternative to {approve} that can be used as a mitigation for
1152      * problems described in {IERC20-approve}.
1153      *
1154      * Emits an {Approval} event indicating the updated allowance.
1155      *
1156      * Requirements:
1157      *
1158      * - `spender` cannot be the zero address.
1159      * - `spender` must have allowance for the caller of at least
1160      * `subtractedValue`.
1161      */
1162     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1163         address owner = _msgSender();
1164         uint256 currentAllowance = _allowances[owner][spender];
1165         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1166         unchecked {
1167             _approve(owner, spender, currentAllowance - subtractedValue);
1168         }
1169 
1170         return true;
1171     }
1172 
1173     /**
1174      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1175      *
1176      * This internal function is equivalent to {transfer}, and can be used to
1177      * e.g. implement automatic token fees, slashing mechanisms, etc.
1178      *
1179      * Emits a {Transfer} event.
1180      *
1181      * Requirements:
1182      *
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      * - `from` must have a balance of at least `amount`.
1186      */
1187     function _transfer(
1188         address from,
1189         address to,
1190         uint256 amount
1191     ) internal virtual {
1192         require(from != address(0), "ERC20: transfer from the zero address");
1193         require(to != address(0), "ERC20: transfer to the zero address");
1194 
1195         _beforeTokenTransfer(from, to, amount);
1196 
1197         uint256 fromBalance = _balances[from];
1198         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1199         unchecked {
1200             _balances[from] = fromBalance - amount;
1201         }
1202         _balances[to] += amount;
1203 
1204         emit Transfer(from, to, amount);
1205 
1206         _afterTokenTransfer(from, to, amount);
1207     }
1208 
1209     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1210      * the total supply.
1211      *
1212      * Emits a {Transfer} event with `from` set to the zero address.
1213      *
1214      * Requirements:
1215      *
1216      * - `account` cannot be the zero address.
1217      */
1218     function _mint(address account, uint256 amount) internal virtual {
1219         require(account != address(0), "ERC20: mint to the zero address");
1220 
1221         _beforeTokenTransfer(address(0), account, amount);
1222 
1223         _totalSupply += amount;
1224         _balances[account] += amount;
1225         emit Transfer(address(0), account, amount);
1226 
1227         _afterTokenTransfer(address(0), account, amount);
1228     }
1229 
1230     /**
1231      * @dev Destroys `amount` tokens from `account`, reducing the
1232      * total supply.
1233      *
1234      * Emits a {Transfer} event with `to` set to the zero address.
1235      *
1236      * Requirements:
1237      *
1238      * - `account` cannot be the zero address.
1239      * - `account` must have at least `amount` tokens.
1240      */
1241     function _burn(address account, uint256 amount) internal virtual {
1242         require(account != address(0), "ERC20: burn from the zero address");
1243 
1244         _beforeTokenTransfer(account, address(0), amount);
1245 
1246         uint256 accountBalance = _balances[account];
1247         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1248         unchecked {
1249             _balances[account] = accountBalance - amount;
1250         }
1251         _totalSupply -= amount;
1252 
1253         emit Transfer(account, address(0), amount);
1254 
1255         _afterTokenTransfer(account, address(0), amount);
1256     }
1257 
1258     /**
1259      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1260      *
1261      * This internal function is equivalent to `approve`, and can be used to
1262      * e.g. set automatic allowances for certain subsystems, etc.
1263      *
1264      * Emits an {Approval} event.
1265      *
1266      * Requirements:
1267      *
1268      * - `owner` cannot be the zero address.
1269      * - `spender` cannot be the zero address.
1270      */
1271     function _approve(
1272         address owner,
1273         address spender,
1274         uint256 amount
1275     ) internal virtual {
1276         require(owner != address(0), "ERC20: approve from the zero address");
1277         require(spender != address(0), "ERC20: approve to the zero address");
1278 
1279         _allowances[owner][spender] = amount;
1280         emit Approval(owner, spender, amount);
1281     }
1282 
1283     /**
1284      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1285      *
1286      * Does not update the allowance amount in case of infinite allowance.
1287      * Revert if not enough allowance is available.
1288      *
1289      * Might emit an {Approval} event.
1290      */
1291     function _spendAllowance(
1292         address owner,
1293         address spender,
1294         uint256 amount
1295     ) internal virtual {
1296         uint256 currentAllowance = allowance(owner, spender);
1297         if (currentAllowance != type(uint256).max) {
1298             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1299             unchecked {
1300                 _approve(owner, spender, currentAllowance - amount);
1301             }
1302         }
1303     }
1304 
1305     /**
1306      * @dev Hook that is called before any transfer of tokens. This includes
1307      * minting and burning.
1308      *
1309      * Calling conditions:
1310      *
1311      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1312      * will be transferred to `to`.
1313      * - when `from` is zero, `amount` tokens will be minted for `to`.
1314      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1315      * - `from` and `to` are never both zero.
1316      *
1317      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1318      */
1319     function _beforeTokenTransfer(
1320         address from,
1321         address to,
1322         uint256 amount
1323     ) internal virtual {}
1324 
1325     /**
1326      * @dev Hook that is called after any transfer of tokens. This includes
1327      * minting and burning.
1328      *
1329      * Calling conditions:
1330      *
1331      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1332      * has been transferred to `to`.
1333      * - when `from` is zero, `amount` tokens have been minted for `to`.
1334      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1335      * - `from` and `to` are never both zero.
1336      *
1337      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1338      */
1339     function _afterTokenTransfer(
1340         address from,
1341         address to,
1342         uint256 amount
1343     ) internal virtual {}
1344 }
1345 
1346 // File: cosmicToken.sol
1347 
1348 pragma solidity 0.8.7;
1349 
1350 interface IDuck {
1351 	function balanceOG(address _user) external view returns(uint256);
1352 }
1353 
1354 contract CosmicToken is ERC20("CosmicUtilityToken", "CUT") 
1355 {
1356    
1357     using SafeMath for uint256;
1358    
1359     uint256 public totalTokensBurned = 0;
1360     address[] internal stakeholders;
1361     address  payable private owner;
1362     
1363 
1364     //token Genesis per day
1365     uint256 constant public GENESIS_RATE = 20 ether; 
1366     
1367     //token duck per day
1368     uint256 constant public DUCK_RATE = 5 ether; 
1369     
1370     //token for  genesis minting
1371 	uint256 constant public GENESIS_ISSUANCE = 280 ether;
1372 	
1373 	//token for duck minting
1374 	uint256 constant public DUCK_ISSUANCE = 70 ether;
1375 	
1376 	
1377 	
1378 	// Tue Mar 18 2031 17:46:47 GMT+0000
1379 	uint256 constant public END = 1931622407;
1380 
1381 	mapping(address => uint256) public rewards;
1382 	mapping(address => uint256) public lastUpdate;
1383 	
1384 	
1385     IDuck public ducksContract;
1386    
1387     constructor(address initDuckContract) 
1388     {
1389         owner = payable(msg.sender);
1390         ducksContract = IDuck(initDuckContract);
1391     }
1392    
1393 
1394     function WhoOwns() public view returns (address) {
1395         return owner;
1396     }
1397    
1398     modifier Owned {
1399          require(msg.sender == owner);
1400          _;
1401  }
1402    
1403     function getContractAddress() public view returns (address) {
1404         return address(this);
1405     }
1406 
1407 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
1408 		return a < b ? a : b;
1409 	}    
1410 	
1411 	modifier contractAddressOnly
1412     {
1413          require(msg.sender == address(ducksContract));
1414          _;
1415     }
1416     
1417    	// called when minting many NFTs
1418 	function updateRewardOnMint(address _user, uint256 _tokenId) external contractAddressOnly
1419 	{
1420 	    if(_tokenId <= 1000)
1421 		{
1422             _mint(_user,GENESIS_ISSUANCE);	  	        
1423 		}
1424 		else if(_tokenId >= 1001)
1425 		{
1426             _mint(_user,DUCK_ISSUANCE);	  	        	        
1427 		}
1428 	}
1429 	
1430 
1431 	function getReward(address _to, uint256 totalPayout) external contractAddressOnly
1432 	{
1433 		_mint(_to, (totalPayout * 10 ** 18));
1434 		
1435 	}
1436 	
1437 	function burn(address _from, uint256 _amount) external 
1438 	{
1439 	    require(msg.sender == _from, "You do not own these tokens");
1440 		_burn(_from, _amount);
1441 		totalTokensBurned += _amount;
1442 	}
1443 
1444 
1445   
1446    
1447 }
1448 // File: @openzeppelin/contracts/access/Ownable.sol
1449 
1450 
1451 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1452 
1453 pragma solidity ^0.8.0;
1454 
1455 
1456 /**
1457  * @dev Contract module which provides a basic access control mechanism, where
1458  * there is an account (an owner) that can be granted exclusive access to
1459  * specific functions.
1460  *
1461  * By default, the owner account will be the one that deploys the contract. This
1462  * can later be changed with {transferOwnership}.
1463  *
1464  * This module is used through inheritance. It will make available the modifier
1465  * `onlyOwner`, which can be applied to your functions to restrict their use to
1466  * the owner.
1467  */
1468 abstract contract Ownable is Context {
1469     address private _owner;
1470 
1471     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1472 
1473     /**
1474      * @dev Initializes the contract setting the deployer as the initial owner.
1475      */
1476     constructor() {
1477         _transferOwnership(_msgSender());
1478     }
1479 
1480     /**
1481      * @dev Returns the address of the current owner.
1482      */
1483     function owner() public view virtual returns (address) {
1484         return _owner;
1485     }
1486 
1487     /**
1488      * @dev Throws if called by any account other than the owner.
1489      */
1490     modifier onlyOwner() {
1491         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1492         _;
1493     }
1494 
1495     /**
1496      * @dev Leaves the contract without owner. It will not be possible to call
1497      * `onlyOwner` functions anymore. Can only be called by the current owner.
1498      *
1499      * NOTE: Renouncing ownership will leave the contract without an owner,
1500      * thereby removing any functionality that is only available to the owner.
1501      */
1502     function renounceOwnership() public virtual onlyOwner {
1503         _transferOwnership(address(0));
1504     }
1505 
1506     /**
1507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1508      * Can only be called by the current owner.
1509      */
1510     function transferOwnership(address newOwner) public virtual onlyOwner {
1511         require(newOwner != address(0), "Ownable: new owner is the zero address");
1512         _transferOwnership(newOwner);
1513     }
1514 
1515     /**
1516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1517      * Internal function without access restriction.
1518      */
1519     function _transferOwnership(address newOwner) internal virtual {
1520         address oldOwner = _owner;
1521         _owner = newOwner;
1522         emit OwnershipTransferred(oldOwner, newOwner);
1523     }
1524 }
1525 
1526 // File: @openzeppelin/contracts/utils/Address.sol
1527 
1528 
1529 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1530 
1531 pragma solidity ^0.8.1;
1532 
1533 /**
1534  * @dev Collection of functions related to the address type
1535  */
1536 library Address {
1537     /**
1538      * @dev Returns true if `account` is a contract.
1539      *
1540      * [IMPORTANT]
1541      * ====
1542      * It is unsafe to assume that an address for which this function returns
1543      * false is an externally-owned account (EOA) and not a contract.
1544      *
1545      * Among others, `isContract` will return false for the following
1546      * types of addresses:
1547      *
1548      *  - an externally-owned account
1549      *  - a contract in construction
1550      *  - an address where a contract will be created
1551      *  - an address where a contract lived, but was destroyed
1552      * ====
1553      *
1554      * [IMPORTANT]
1555      * ====
1556      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1557      *
1558      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1559      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1560      * constructor.
1561      * ====
1562      */
1563     function isContract(address account) internal view returns (bool) {
1564         // This method relies on extcodesize/address.code.length, which returns 0
1565         // for contracts in construction, since the code is only stored at the end
1566         // of the constructor execution.
1567 
1568         return account.code.length > 0;
1569     }
1570 
1571     /**
1572      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1573      * `recipient`, forwarding all available gas and reverting on errors.
1574      *
1575      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1576      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1577      * imposed by `transfer`, making them unable to receive funds via
1578      * `transfer`. {sendValue} removes this limitation.
1579      *
1580      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1581      *
1582      * IMPORTANT: because control is transferred to `recipient`, care must be
1583      * taken to not create reentrancy vulnerabilities. Consider using
1584      * {ReentrancyGuard} or the
1585      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1586      */
1587     function sendValue(address payable recipient, uint256 amount) internal {
1588         require(address(this).balance >= amount, "Address: insufficient balance");
1589 
1590         (bool success, ) = recipient.call{value: amount}("");
1591         require(success, "Address: unable to send value, recipient may have reverted");
1592     }
1593 
1594     /**
1595      * @dev Performs a Solidity function call using a low level `call`. A
1596      * plain `call` is an unsafe replacement for a function call: use this
1597      * function instead.
1598      *
1599      * If `target` reverts with a revert reason, it is bubbled up by this
1600      * function (like regular Solidity function calls).
1601      *
1602      * Returns the raw returned data. To convert to the expected return value,
1603      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1604      *
1605      * Requirements:
1606      *
1607      * - `target` must be a contract.
1608      * - calling `target` with `data` must not revert.
1609      *
1610      * _Available since v3.1._
1611      */
1612     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1613         return functionCall(target, data, "Address: low-level call failed");
1614     }
1615 
1616     /**
1617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1618      * `errorMessage` as a fallback revert reason when `target` reverts.
1619      *
1620      * _Available since v3.1._
1621      */
1622     function functionCall(
1623         address target,
1624         bytes memory data,
1625         string memory errorMessage
1626     ) internal returns (bytes memory) {
1627         return functionCallWithValue(target, data, 0, errorMessage);
1628     }
1629 
1630     /**
1631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1632      * but also transferring `value` wei to `target`.
1633      *
1634      * Requirements:
1635      *
1636      * - the calling contract must have an ETH balance of at least `value`.
1637      * - the called Solidity function must be `payable`.
1638      *
1639      * _Available since v3.1._
1640      */
1641     function functionCallWithValue(
1642         address target,
1643         bytes memory data,
1644         uint256 value
1645     ) internal returns (bytes memory) {
1646         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1647     }
1648 
1649     /**
1650      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1651      * with `errorMessage` as a fallback revert reason when `target` reverts.
1652      *
1653      * _Available since v3.1._
1654      */
1655     function functionCallWithValue(
1656         address target,
1657         bytes memory data,
1658         uint256 value,
1659         string memory errorMessage
1660     ) internal returns (bytes memory) {
1661         require(address(this).balance >= value, "Address: insufficient balance for call");
1662         require(isContract(target), "Address: call to non-contract");
1663 
1664         (bool success, bytes memory returndata) = target.call{value: value}(data);
1665         return verifyCallResult(success, returndata, errorMessage);
1666     }
1667 
1668     /**
1669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1670      * but performing a static call.
1671      *
1672      * _Available since v3.3._
1673      */
1674     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1675         return functionStaticCall(target, data, "Address: low-level static call failed");
1676     }
1677 
1678     /**
1679      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1680      * but performing a static call.
1681      *
1682      * _Available since v3.3._
1683      */
1684     function functionStaticCall(
1685         address target,
1686         bytes memory data,
1687         string memory errorMessage
1688     ) internal view returns (bytes memory) {
1689         require(isContract(target), "Address: static call to non-contract");
1690 
1691         (bool success, bytes memory returndata) = target.staticcall(data);
1692         return verifyCallResult(success, returndata, errorMessage);
1693     }
1694 
1695     /**
1696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1697      * but performing a delegate call.
1698      *
1699      * _Available since v3.4._
1700      */
1701     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1702         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1703     }
1704 
1705     /**
1706      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1707      * but performing a delegate call.
1708      *
1709      * _Available since v3.4._
1710      */
1711     function functionDelegateCall(
1712         address target,
1713         bytes memory data,
1714         string memory errorMessage
1715     ) internal returns (bytes memory) {
1716         require(isContract(target), "Address: delegate call to non-contract");
1717 
1718         (bool success, bytes memory returndata) = target.delegatecall(data);
1719         return verifyCallResult(success, returndata, errorMessage);
1720     }
1721 
1722     /**
1723      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1724      * revert reason using the provided one.
1725      *
1726      * _Available since v4.3._
1727      */
1728     function verifyCallResult(
1729         bool success,
1730         bytes memory returndata,
1731         string memory errorMessage
1732     ) internal pure returns (bytes memory) {
1733         if (success) {
1734             return returndata;
1735         } else {
1736             // Look for revert reason and bubble it up if present
1737             if (returndata.length > 0) {
1738                 // The easiest way to bubble the revert reason is using memory via assembly
1739 
1740                 assembly {
1741                     let returndata_size := mload(returndata)
1742                     revert(add(32, returndata), returndata_size)
1743                 }
1744             } else {
1745                 revert(errorMessage);
1746             }
1747         }
1748     }
1749 }
1750 
1751 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1752 
1753 
1754 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1755 
1756 pragma solidity ^0.8.0;
1757 
1758 /**
1759  * @title ERC721 token receiver interface
1760  * @dev Interface for any contract that wants to support safeTransfers
1761  * from ERC721 asset contracts.
1762  */
1763 interface IERC721Receiver {
1764     /**
1765      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1766      * by `operator` from `from`, this function is called.
1767      *
1768      * It must return its Solidity selector to confirm the token transfer.
1769      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1770      *
1771      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1772      */
1773     function onERC721Received(
1774         address operator,
1775         address from,
1776         uint256 tokenId,
1777         bytes calldata data
1778     ) external returns (bytes4);
1779 }
1780 
1781 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1782 
1783 
1784 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1785 
1786 pragma solidity ^0.8.0;
1787 
1788 /**
1789  * @dev Interface of the ERC165 standard, as defined in the
1790  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1791  *
1792  * Implementers can declare support of contract interfaces, which can then be
1793  * queried by others ({ERC165Checker}).
1794  *
1795  * For an implementation, see {ERC165}.
1796  */
1797 interface IERC165 {
1798     /**
1799      * @dev Returns true if this contract implements the interface defined by
1800      * `interfaceId`. See the corresponding
1801      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1802      * to learn more about how these ids are created.
1803      *
1804      * This function call must use less than 30 000 gas.
1805      */
1806     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1807 }
1808 
1809 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1810 
1811 
1812 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1813 
1814 pragma solidity ^0.8.0;
1815 
1816 
1817 /**
1818  * @dev Implementation of the {IERC165} interface.
1819  *
1820  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1821  * for the additional interface id that will be supported. For example:
1822  *
1823  * ```solidity
1824  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1825  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1826  * }
1827  * ```
1828  *
1829  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1830  */
1831 abstract contract ERC165 is IERC165 {
1832     /**
1833      * @dev See {IERC165-supportsInterface}.
1834      */
1835     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1836         return interfaceId == type(IERC165).interfaceId;
1837     }
1838 }
1839 
1840 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1841 
1842 
1843 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1844 
1845 pragma solidity ^0.8.0;
1846 
1847 
1848 /**
1849  * @dev Required interface of an ERC721 compliant contract.
1850  */
1851 interface IERC721 is IERC165 {
1852     /**
1853      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1854      */
1855     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1856 
1857     /**
1858      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1859      */
1860     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1861 
1862     /**
1863      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1864      */
1865     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1866 
1867     /**
1868      * @dev Returns the number of tokens in ``owner``'s account.
1869      */
1870     function balanceOf(address owner) external view returns (uint256 balance);
1871 
1872     /**
1873      * @dev Returns the owner of the `tokenId` token.
1874      *
1875      * Requirements:
1876      *
1877      * - `tokenId` must exist.
1878      */
1879     function ownerOf(uint256 tokenId) external view returns (address owner);
1880 
1881     /**
1882      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1883      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1884      *
1885      * Requirements:
1886      *
1887      * - `from` cannot be the zero address.
1888      * - `to` cannot be the zero address.
1889      * - `tokenId` token must exist and be owned by `from`.
1890      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1892      *
1893      * Emits a {Transfer} event.
1894      */
1895     function safeTransferFrom(
1896         address from,
1897         address to,
1898         uint256 tokenId
1899     ) external;
1900 
1901     /**
1902      * @dev Transfers `tokenId` token from `from` to `to`.
1903      *
1904      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1905      *
1906      * Requirements:
1907      *
1908      * - `from` cannot be the zero address.
1909      * - `to` cannot be the zero address.
1910      * - `tokenId` token must be owned by `from`.
1911      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1912      *
1913      * Emits a {Transfer} event.
1914      */
1915     function transferFrom(
1916         address from,
1917         address to,
1918         uint256 tokenId
1919     ) external;
1920 
1921     /**
1922      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1923      * The approval is cleared when the token is transferred.
1924      *
1925      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1926      *
1927      * Requirements:
1928      *
1929      * - The caller must own the token or be an approved operator.
1930      * - `tokenId` must exist.
1931      *
1932      * Emits an {Approval} event.
1933      */
1934     function approve(address to, uint256 tokenId) external;
1935 
1936     /**
1937      * @dev Returns the account approved for `tokenId` token.
1938      *
1939      * Requirements:
1940      *
1941      * - `tokenId` must exist.
1942      */
1943     function getApproved(uint256 tokenId) external view returns (address operator);
1944 
1945     /**
1946      * @dev Approve or remove `operator` as an operator for the caller.
1947      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1948      *
1949      * Requirements:
1950      *
1951      * - The `operator` cannot be the caller.
1952      *
1953      * Emits an {ApprovalForAll} event.
1954      */
1955     function setApprovalForAll(address operator, bool _approved) external;
1956 
1957     /**
1958      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1959      *
1960      * See {setApprovalForAll}
1961      */
1962     function isApprovedForAll(address owner, address operator) external view returns (bool);
1963 
1964     /**
1965      * @dev Safely transfers `tokenId` token from `from` to `to`.
1966      *
1967      * Requirements:
1968      *
1969      * - `from` cannot be the zero address.
1970      * - `to` cannot be the zero address.
1971      * - `tokenId` token must exist and be owned by `from`.
1972      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1973      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1974      *
1975      * Emits a {Transfer} event.
1976      */
1977     function safeTransferFrom(
1978         address from,
1979         address to,
1980         uint256 tokenId,
1981         bytes calldata data
1982     ) external;
1983 }
1984 
1985 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1986 
1987 
1988 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1989 
1990 pragma solidity ^0.8.0;
1991 
1992 
1993 /**
1994  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1995  * @dev See https://eips.ethereum.org/EIPS/eip-721
1996  */
1997 interface IERC721Enumerable is IERC721 {
1998     /**
1999      * @dev Returns the total amount of tokens stored by the contract.
2000      */
2001     function totalSupply() external view returns (uint256);
2002 
2003     /**
2004      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2005      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2006      */
2007     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
2008 
2009     /**
2010      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2011      * Use along with {totalSupply} to enumerate all tokens.
2012      */
2013     function tokenByIndex(uint256 index) external view returns (uint256);
2014 }
2015 
2016 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2017 
2018 
2019 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2020 
2021 pragma solidity ^0.8.0;
2022 
2023 
2024 /**
2025  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2026  * @dev See https://eips.ethereum.org/EIPS/eip-721
2027  */
2028 interface IERC721Metadata is IERC721 {
2029     /**
2030      * @dev Returns the token collection name.
2031      */
2032     function name() external view returns (string memory);
2033 
2034     /**
2035      * @dev Returns the token collection symbol.
2036      */
2037     function symbol() external view returns (string memory);
2038 
2039     /**
2040      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2041      */
2042     function tokenURI(uint256 tokenId) external view returns (string memory);
2043 }
2044 
2045 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2046 
2047 
2048 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
2049 
2050 pragma solidity ^0.8.0;
2051 
2052 
2053 
2054 
2055 
2056 
2057 
2058 
2059 /**
2060  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2061  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2062  * {ERC721Enumerable}.
2063  */
2064 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2065     using Address for address;
2066     using Strings for uint256;
2067 
2068     // Token name
2069     string private _name;
2070 
2071     // Token symbol
2072     string private _symbol;
2073 
2074     // Mapping from token ID to owner address
2075     mapping(uint256 => address) private _owners;
2076 
2077     // Mapping owner address to token count
2078     mapping(address => uint256) private _balances;
2079 
2080     // Mapping from token ID to approved address
2081     mapping(uint256 => address) private _tokenApprovals;
2082 
2083     // Mapping from owner to operator approvals
2084     mapping(address => mapping(address => bool)) private _operatorApprovals;
2085 
2086     /**
2087      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2088      */
2089     constructor(string memory name_, string memory symbol_) {
2090         _name = name_;
2091         _symbol = symbol_;
2092     }
2093 
2094     /**
2095      * @dev See {IERC165-supportsInterface}.
2096      */
2097     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2098         return
2099             interfaceId == type(IERC721).interfaceId ||
2100             interfaceId == type(IERC721Metadata).interfaceId ||
2101             super.supportsInterface(interfaceId);
2102     }
2103 
2104     /**
2105      * @dev See {IERC721-balanceOf}.
2106      */
2107     function balanceOf(address owner) public view virtual override returns (uint256) {
2108         require(owner != address(0), "ERC721: balance query for the zero address");
2109         return _balances[owner];
2110     }
2111 
2112     /**
2113      * @dev See {IERC721-ownerOf}.
2114      */
2115     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2116         address owner = _owners[tokenId];
2117         require(owner != address(0), "ERC721: owner query for nonexistent token");
2118         return owner;
2119     }
2120 
2121     /**
2122      * @dev See {IERC721Metadata-name}.
2123      */
2124     function name() public view virtual override returns (string memory) {
2125         return _name;
2126     }
2127 
2128     /**
2129      * @dev See {IERC721Metadata-symbol}.
2130      */
2131     function symbol() public view virtual override returns (string memory) {
2132         return _symbol;
2133     }
2134 
2135     /**
2136      * @dev See {IERC721Metadata-tokenURI}.
2137      */
2138     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2139         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2140 
2141         string memory baseURI = _baseURI();
2142         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2143     }
2144 
2145     /**
2146      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2147      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2148      * by default, can be overriden in child contracts.
2149      */
2150     function _baseURI() internal view virtual returns (string memory) {
2151         return "";
2152     }
2153 
2154     /**
2155      * @dev See {IERC721-approve}.
2156      */
2157     function approve(address to, uint256 tokenId) public virtual override {
2158         address owner = ERC721.ownerOf(tokenId);
2159         require(to != owner, "ERC721: approval to current owner");
2160 
2161         require(
2162             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2163             "ERC721: approve caller is not owner nor approved for all"
2164         );
2165 
2166         _approve(to, tokenId);
2167     }
2168 
2169     /**
2170      * @dev See {IERC721-getApproved}.
2171      */
2172     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2173         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2174 
2175         return _tokenApprovals[tokenId];
2176     }
2177 
2178     /**
2179      * @dev See {IERC721-setApprovalForAll}.
2180      */
2181     function setApprovalForAll(address operator, bool approved) public virtual override {
2182         _setApprovalForAll(_msgSender(), operator, approved);
2183     }
2184 
2185     /**
2186      * @dev See {IERC721-isApprovedForAll}.
2187      */
2188     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2189         return _operatorApprovals[owner][operator];
2190     }
2191 
2192     /**
2193      * @dev See {IERC721-transferFrom}.
2194      */
2195     function transferFrom(
2196         address from,
2197         address to,
2198         uint256 tokenId
2199     ) public virtual override {
2200         //solhint-disable-next-line max-line-length
2201         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2202 
2203         _transfer(from, to, tokenId);
2204     }
2205 
2206     /**
2207      * @dev See {IERC721-safeTransferFrom}.
2208      */
2209     function safeTransferFrom(
2210         address from,
2211         address to,
2212         uint256 tokenId
2213     ) public virtual override {
2214         safeTransferFrom(from, to, tokenId, "");
2215     }
2216 
2217     /**
2218      * @dev See {IERC721-safeTransferFrom}.
2219      */
2220     function safeTransferFrom(
2221         address from,
2222         address to,
2223         uint256 tokenId,
2224         bytes memory _data
2225     ) public virtual override {
2226         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2227         _safeTransfer(from, to, tokenId, _data);
2228     }
2229 
2230     /**
2231      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2232      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2233      *
2234      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2235      *
2236      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2237      * implement alternative mechanisms to perform token transfer, such as signature-based.
2238      *
2239      * Requirements:
2240      *
2241      * - `from` cannot be the zero address.
2242      * - `to` cannot be the zero address.
2243      * - `tokenId` token must exist and be owned by `from`.
2244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2245      *
2246      * Emits a {Transfer} event.
2247      */
2248     function _safeTransfer(
2249         address from,
2250         address to,
2251         uint256 tokenId,
2252         bytes memory _data
2253     ) internal virtual {
2254         _transfer(from, to, tokenId);
2255         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2256     }
2257 
2258     /**
2259      * @dev Returns whether `tokenId` exists.
2260      *
2261      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2262      *
2263      * Tokens start existing when they are minted (`_mint`),
2264      * and stop existing when they are burned (`_burn`).
2265      */
2266     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2267         return _owners[tokenId] != address(0);
2268     }
2269 
2270     /**
2271      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2272      *
2273      * Requirements:
2274      *
2275      * - `tokenId` must exist.
2276      */
2277     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2278         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2279         address owner = ERC721.ownerOf(tokenId);
2280         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2281     }
2282 
2283     /**
2284      * @dev Safely mints `tokenId` and transfers it to `to`.
2285      *
2286      * Requirements:
2287      *
2288      * - `tokenId` must not exist.
2289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2290      *
2291      * Emits a {Transfer} event.
2292      */
2293     function _safeMint(address to, uint256 tokenId) internal virtual {
2294         _safeMint(to, tokenId, "");
2295     }
2296 
2297     /**
2298      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2299      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2300      */
2301     function _safeMint(
2302         address to,
2303         uint256 tokenId,
2304         bytes memory _data
2305     ) internal virtual {
2306         _mint(to, tokenId);
2307         require(
2308             _checkOnERC721Received(address(0), to, tokenId, _data),
2309             "ERC721: transfer to non ERC721Receiver implementer"
2310         );
2311     }
2312 
2313     /**
2314      * @dev Mints `tokenId` and transfers it to `to`.
2315      *
2316      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2317      *
2318      * Requirements:
2319      *
2320      * - `tokenId` must not exist.
2321      * - `to` cannot be the zero address.
2322      *
2323      * Emits a {Transfer} event.
2324      */
2325     function _mint(address to, uint256 tokenId) internal virtual {
2326         require(to != address(0), "ERC721: mint to the zero address");
2327         require(!_exists(tokenId), "ERC721: token already minted");
2328 
2329         _beforeTokenTransfer(address(0), to, tokenId);
2330 
2331         _balances[to] += 1;
2332         _owners[tokenId] = to;
2333 
2334         emit Transfer(address(0), to, tokenId);
2335 
2336         _afterTokenTransfer(address(0), to, tokenId);
2337     }
2338 
2339     /**
2340      * @dev Destroys `tokenId`.
2341      * The approval is cleared when the token is burned.
2342      *
2343      * Requirements:
2344      *
2345      * - `tokenId` must exist.
2346      *
2347      * Emits a {Transfer} event.
2348      */
2349     function _burn(uint256 tokenId) internal virtual {
2350         address owner = ERC721.ownerOf(tokenId);
2351 
2352         _beforeTokenTransfer(owner, address(0), tokenId);
2353 
2354         // Clear approvals
2355         _approve(address(0), tokenId);
2356 
2357         _balances[owner] -= 1;
2358         delete _owners[tokenId];
2359 
2360         emit Transfer(owner, address(0), tokenId);
2361 
2362         _afterTokenTransfer(owner, address(0), tokenId);
2363     }
2364 
2365     /**
2366      * @dev Transfers `tokenId` from `from` to `to`.
2367      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2368      *
2369      * Requirements:
2370      *
2371      * - `to` cannot be the zero address.
2372      * - `tokenId` token must be owned by `from`.
2373      *
2374      * Emits a {Transfer} event.
2375      */
2376     function _transfer(
2377         address from,
2378         address to,
2379         uint256 tokenId
2380     ) internal virtual {
2381         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2382         require(to != address(0), "ERC721: transfer to the zero address");
2383 
2384         _beforeTokenTransfer(from, to, tokenId);
2385 
2386         // Clear approvals from the previous owner
2387         _approve(address(0), tokenId);
2388 
2389         _balances[from] -= 1;
2390         _balances[to] += 1;
2391         _owners[tokenId] = to;
2392 
2393         emit Transfer(from, to, tokenId);
2394 
2395         _afterTokenTransfer(from, to, tokenId);
2396     }
2397 
2398     /**
2399      * @dev Approve `to` to operate on `tokenId`
2400      *
2401      * Emits a {Approval} event.
2402      */
2403     function _approve(address to, uint256 tokenId) internal virtual {
2404         _tokenApprovals[tokenId] = to;
2405         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2406     }
2407 
2408     /**
2409      * @dev Approve `operator` to operate on all of `owner` tokens
2410      *
2411      * Emits a {ApprovalForAll} event.
2412      */
2413     function _setApprovalForAll(
2414         address owner,
2415         address operator,
2416         bool approved
2417     ) internal virtual {
2418         require(owner != operator, "ERC721: approve to caller");
2419         _operatorApprovals[owner][operator] = approved;
2420         emit ApprovalForAll(owner, operator, approved);
2421     }
2422 
2423     /**
2424      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2425      * The call is not executed if the target address is not a contract.
2426      *
2427      * @param from address representing the previous owner of the given token ID
2428      * @param to target address that will receive the tokens
2429      * @param tokenId uint256 ID of the token to be transferred
2430      * @param _data bytes optional data to send along with the call
2431      * @return bool whether the call correctly returned the expected magic value
2432      */
2433     function _checkOnERC721Received(
2434         address from,
2435         address to,
2436         uint256 tokenId,
2437         bytes memory _data
2438     ) private returns (bool) {
2439         if (to.isContract()) {
2440             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2441                 return retval == IERC721Receiver.onERC721Received.selector;
2442             } catch (bytes memory reason) {
2443                 if (reason.length == 0) {
2444                     revert("ERC721: transfer to non ERC721Receiver implementer");
2445                 } else {
2446                     assembly {
2447                         revert(add(32, reason), mload(reason))
2448                     }
2449                 }
2450             }
2451         } else {
2452             return true;
2453         }
2454     }
2455 
2456     /**
2457      * @dev Hook that is called before any token transfer. This includes minting
2458      * and burning.
2459      *
2460      * Calling conditions:
2461      *
2462      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2463      * transferred to `to`.
2464      * - When `from` is zero, `tokenId` will be minted for `to`.
2465      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2466      * - `from` and `to` are never both zero.
2467      *
2468      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2469      */
2470     function _beforeTokenTransfer(
2471         address from,
2472         address to,
2473         uint256 tokenId
2474     ) internal virtual {}
2475 
2476     /**
2477      * @dev Hook that is called after any transfer of tokens. This includes
2478      * minting and burning.
2479      *
2480      * Calling conditions:
2481      *
2482      * - when `from` and `to` are both non-zero.
2483      * - `from` and `to` are never both zero.
2484      *
2485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2486      */
2487     function _afterTokenTransfer(
2488         address from,
2489         address to,
2490         uint256 tokenId
2491     ) internal virtual {}
2492 }
2493 
2494 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2495 
2496 
2497 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2498 
2499 pragma solidity ^0.8.0;
2500 
2501 
2502 
2503 /**
2504  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2505  * enumerability of all the token ids in the contract as well as all token ids owned by each
2506  * account.
2507  */
2508 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2509     // Mapping from owner to list of owned token IDs
2510     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2511 
2512     // Mapping from token ID to index of the owner tokens list
2513     mapping(uint256 => uint256) private _ownedTokensIndex;
2514 
2515     // Array with all token ids, used for enumeration
2516     uint256[] private _allTokens;
2517 
2518     // Mapping from token id to position in the allTokens array
2519     mapping(uint256 => uint256) private _allTokensIndex;
2520 
2521     /**
2522      * @dev See {IERC165-supportsInterface}.
2523      */
2524     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2525         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2526     }
2527 
2528     /**
2529      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2530      */
2531     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2532         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2533         return _ownedTokens[owner][index];
2534     }
2535 
2536     /**
2537      * @dev See {IERC721Enumerable-totalSupply}.
2538      */
2539     function totalSupply() public view virtual override returns (uint256) {
2540         return _allTokens.length;
2541     }
2542 
2543     /**
2544      * @dev See {IERC721Enumerable-tokenByIndex}.
2545      */
2546     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2547         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2548         return _allTokens[index];
2549     }
2550 
2551     /**
2552      * @dev Hook that is called before any token transfer. This includes minting
2553      * and burning.
2554      *
2555      * Calling conditions:
2556      *
2557      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2558      * transferred to `to`.
2559      * - When `from` is zero, `tokenId` will be minted for `to`.
2560      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2561      * - `from` cannot be the zero address.
2562      * - `to` cannot be the zero address.
2563      *
2564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2565      */
2566     function _beforeTokenTransfer(
2567         address from,
2568         address to,
2569         uint256 tokenId
2570     ) internal virtual override {
2571         super._beforeTokenTransfer(from, to, tokenId);
2572 
2573         if (from == address(0)) {
2574             _addTokenToAllTokensEnumeration(tokenId);
2575         } else if (from != to) {
2576             _removeTokenFromOwnerEnumeration(from, tokenId);
2577         }
2578         if (to == address(0)) {
2579             _removeTokenFromAllTokensEnumeration(tokenId);
2580         } else if (to != from) {
2581             _addTokenToOwnerEnumeration(to, tokenId);
2582         }
2583     }
2584 
2585     /**
2586      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2587      * @param to address representing the new owner of the given token ID
2588      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2589      */
2590     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2591         uint256 length = ERC721.balanceOf(to);
2592         _ownedTokens[to][length] = tokenId;
2593         _ownedTokensIndex[tokenId] = length;
2594     }
2595 
2596     /**
2597      * @dev Private function to add a token to this extension's token tracking data structures.
2598      * @param tokenId uint256 ID of the token to be added to the tokens list
2599      */
2600     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2601         _allTokensIndex[tokenId] = _allTokens.length;
2602         _allTokens.push(tokenId);
2603     }
2604 
2605     /**
2606      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2607      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2608      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2609      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2610      * @param from address representing the previous owner of the given token ID
2611      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2612      */
2613     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2614         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2615         // then delete the last slot (swap and pop).
2616 
2617         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2618         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2619 
2620         // When the token to delete is the last token, the swap operation is unnecessary
2621         if (tokenIndex != lastTokenIndex) {
2622             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2623 
2624             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2625             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2626         }
2627 
2628         // This also deletes the contents at the last position of the array
2629         delete _ownedTokensIndex[tokenId];
2630         delete _ownedTokens[from][lastTokenIndex];
2631     }
2632 
2633     /**
2634      * @dev Private function to remove a token from this extension's token tracking data structures.
2635      * This has O(1) time complexity, but alters the order of the _allTokens array.
2636      * @param tokenId uint256 ID of the token to be removed from the tokens list
2637      */
2638     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2639         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2640         // then delete the last slot (swap and pop).
2641 
2642         uint256 lastTokenIndex = _allTokens.length - 1;
2643         uint256 tokenIndex = _allTokensIndex[tokenId];
2644 
2645         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2646         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2647         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2648         uint256 lastTokenId = _allTokens[lastTokenIndex];
2649 
2650         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2651         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2652 
2653         // This also deletes the contents at the last position of the array
2654         delete _allTokensIndex[tokenId];
2655         _allTokens.pop();
2656     }
2657 }
2658 
2659 // File: cosmicLabs.sol
2660 
2661 pragma solidity 0.8.7;
2662 
2663 
2664 /// SPDX-License-Identifier: UNLICENSED
2665 
2666 contract CosmicLabs is ERC721Enumerable, IERC721Receiver, Ownable {
2667    
2668    using Strings for uint256;
2669    using EnumerableSet for EnumerableSet.UintSet;
2670    
2671     CosmicToken public cosmictoken;
2672     
2673     using Counters for Counters.Counter;
2674     Counters.Counter private _tokenIdTracker;
2675     
2676     string public baseURI;
2677     string public baseExtension = ".json";
2678 
2679     
2680     uint public maxGenesisTx = 4;
2681     uint public maxDuckTx = 20;
2682     
2683     
2684     uint public maxSupply = 9000;
2685     uint public genesisSupply = 1000;
2686     
2687     uint256 public price = 0.05 ether;
2688    
2689 
2690     bool public GensisSaleOpen = true;
2691     bool public GenesisFreeMintOpen = false;
2692     bool public DuckMintOpen = false;
2693     
2694     
2695     
2696     modifier isSaleOpen
2697     {
2698          require(GensisSaleOpen == true);
2699          _;
2700     }
2701     
2702     modifier isFreeMintOpen
2703     {
2704          require(GenesisFreeMintOpen == true);
2705          _;
2706     }
2707     
2708     modifier isDuckMintOpen
2709     {
2710          require(DuckMintOpen == true);
2711          _;
2712     }
2713     
2714 
2715     
2716     function switchFromFreeToDuckMint() public onlyOwner
2717     {
2718         GenesisFreeMintOpen = false;
2719         DuckMintOpen = true;
2720     }
2721     
2722     
2723     
2724     event mint(address to, uint total);
2725     event withdraw(uint total);
2726     event giveawayNft(address to, uint tokenID);
2727     
2728     mapping(address => uint256) public balanceOG;
2729     
2730     mapping(address => uint256) public maxWalletGenesisTX;
2731     mapping(address => uint256) public maxWalletDuckTX;
2732     
2733     mapping(address => EnumerableSet.UintSet) private _deposits;
2734     
2735     
2736     mapping(uint256 => uint256) public _deposit_blocks;
2737     
2738     mapping(address => bool) public addressStaked;
2739     
2740     //ID - Days staked;
2741     mapping(uint256 => uint256) public IDvsDaysStaked;
2742     mapping (address => uint256) public whitelistMintAmount;
2743     
2744 
2745    address internal communityWallet = 0xea25545d846ecF4999C2875bC77dE5B5151Fa633;
2746    
2747     constructor(string memory _initBaseURI) ERC721("Cosmic Labs", "CLABS")
2748     {
2749         setBaseURI(_initBaseURI);
2750     }
2751    
2752    
2753     function setPrice(uint256 newPrice) external onlyOwner {
2754         price = newPrice;
2755     }
2756    
2757     
2758     function setYieldToken(address _yield) external onlyOwner {
2759 		cosmictoken = CosmicToken(_yield);
2760 	}
2761 	
2762 	function totalToken() public view returns (uint256) {
2763             return _tokenIdTracker.current();
2764     }
2765     
2766     modifier communityWalletOnly
2767     {
2768          require(msg.sender == communityWallet);
2769          _;
2770     }
2771     	
2772 	function communityDuckMint(uint256 amountForAirdrops) public onlyOwner
2773 	{
2774         for(uint256 i; i<amountForAirdrops; i++)
2775         {
2776              _tokenIdTracker.increment();
2777             _safeMint(communityWallet, totalToken());
2778         }
2779 	}
2780 
2781     function GenesisSale(uint8 mintTotal) public payable isSaleOpen
2782     {
2783         uint256 totalMinted = maxWalletGenesisTX[msg.sender];
2784         totalMinted = totalMinted + mintTotal;
2785         
2786         require(mintTotal >= 1 && mintTotal <= maxGenesisTx, "Mint Amount Incorrect");
2787         require(totalToken() < genesisSupply, "SOLD OUT!");
2788         require(maxWalletGenesisTX[msg.sender] <= maxGenesisTx, "You've maxed your limit!");
2789         require(msg.value >= price * mintTotal, "Minting a Genesis Costs 0.05 Ether Each!");
2790         require(totalMinted <= maxGenesisTx, "You'll surpass your limit!");
2791         
2792         
2793         for(uint8 i=0;i<mintTotal;i++)
2794         {
2795             whitelistMintAmount[msg.sender] += 1;
2796             maxWalletGenesisTX[msg.sender] += 1;
2797             _tokenIdTracker.increment();
2798             _safeMint(msg.sender, totalToken());
2799             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
2800             emit mint(msg.sender, totalToken());
2801         }
2802         
2803         if(totalToken() == genesisSupply)
2804         {
2805             GensisSaleOpen = false;
2806             GenesisFreeMintOpen = true;
2807         }
2808        
2809     }	
2810 
2811     function GenesisFreeMint(uint8 mintTotal)public payable isFreeMintOpen
2812     {
2813         require(whitelistMintAmount[msg.sender] > 0, "You don't have any free mints!");
2814         require(totalToken() < maxSupply, "SOLD OUT!");
2815         require(mintTotal <= whitelistMintAmount[msg.sender], "You are passing your limit!");
2816         
2817         for(uint8 i=0;i<mintTotal;i++)
2818         {
2819             whitelistMintAmount[msg.sender] -= 1;
2820             _tokenIdTracker.increment();
2821             _safeMint(msg.sender, totalToken());
2822             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
2823             emit mint(msg.sender, totalToken());
2824         }
2825     }
2826 	
2827 
2828     function DuckSale(uint8 mintTotal)public payable isDuckMintOpen
2829     {
2830         uint256 totalMinted = maxWalletDuckTX[msg.sender];
2831         totalMinted = totalMinted + mintTotal;        
2832     
2833         require(mintTotal >= 1 && mintTotal <= maxDuckTx, "Mint Amount Incorrect");
2834         require(msg.value >= price * mintTotal, "Minting a Duck Costs 0.05 Ether Each!");
2835         require(totalToken() < maxSupply, "SOLD OUT!");
2836         require(maxWalletDuckTX[msg.sender] <= maxDuckTx, "You've maxed your limit!");
2837         require(totalMinted <= maxDuckTx, "You'll surpass your limit!");
2838         
2839         for(uint8 i=0;i<mintTotal;i++)
2840         {
2841             maxWalletDuckTX[msg.sender] += 1;
2842             _tokenIdTracker.increment();
2843             _safeMint(msg.sender, totalToken());
2844             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
2845             emit mint(msg.sender, totalToken());
2846         }
2847         
2848         if(totalToken() == maxSupply)
2849         {
2850             DuckMintOpen = false;
2851         }
2852     }
2853    
2854    
2855     function airdropNft(address airdropPatricipent, uint16 tokenID) public payable communityWalletOnly
2856     {
2857         _transfer(msg.sender, airdropPatricipent, tokenID);
2858         emit giveawayNft(airdropPatricipent, tokenID);
2859     }
2860     
2861     function airdropMany(address[] memory airdropPatricipents) public payable communityWalletOnly
2862     {
2863         uint256[] memory tempWalletOfUser = this.walletOfOwner(msg.sender);
2864         
2865         require(tempWalletOfUser.length >= airdropPatricipents.length, "You dont have enough tokens to airdrop all!");
2866         
2867        for(uint256 i=0; i<airdropPatricipents.length; i++)
2868        {
2869             _transfer(msg.sender, airdropPatricipents[i], tempWalletOfUser[i]);
2870             emit giveawayNft(airdropPatricipents[i], tempWalletOfUser[i]);
2871        }
2872 
2873     }    
2874     
2875     function withdrawContractEther(address payable recipient) external onlyOwner
2876     {
2877         emit withdraw(getBalance());
2878         recipient.transfer(getBalance());
2879     }
2880     function getBalance() public view returns(uint)
2881     {
2882         return address(this).balance;
2883     }
2884    
2885     function _baseURI() internal view virtual override returns (string memory) {
2886         return baseURI;
2887     }
2888    
2889     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2890         baseURI = _newBaseURI;
2891     }
2892    
2893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2894     {
2895         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2896 
2897         string memory currentBaseURI = _baseURI();
2898         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2899     }
2900     
2901 	function getReward(uint256 CalculatedPayout) internal
2902 	{
2903 		cosmictoken.getReward(msg.sender, CalculatedPayout);
2904 	}    
2905     
2906     //Staking Functions
2907     function depositStake(uint256[] calldata tokenIds) external {
2908         
2909         require(isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
2910         
2911         
2912         for (uint256 i; i < tokenIds.length; i++) {
2913             safeTransferFrom(
2914                 msg.sender,
2915                 address(this),
2916                 tokenIds[i],
2917                 ''
2918             );
2919             
2920             _deposits[msg.sender].add(tokenIds[i]);
2921             addressStaked[msg.sender] = true;
2922             
2923             
2924             _deposit_blocks[tokenIds[i]] = block.timestamp;
2925             
2926 
2927             IDvsDaysStaked[tokenIds[i]] = block.timestamp;
2928         }
2929         
2930     }
2931     function withdrawStake(uint256[] calldata tokenIds) external {
2932         
2933         require(isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
2934         
2935         for (uint256 i; i < tokenIds.length; i++) {
2936             require(
2937                 _deposits[msg.sender].contains(tokenIds[i]),
2938                 'Token not deposited'
2939             );
2940             
2941             cosmictoken.getReward(msg.sender,totalRewardsToPay(tokenIds[i]));
2942             
2943             _deposits[msg.sender].remove(tokenIds[i]);
2944              _deposit_blocks[tokenIds[i]] = 0;
2945             addressStaked[msg.sender] = false;
2946             IDvsDaysStaked[tokenIds[i]] = block.timestamp;
2947             
2948             this.safeTransferFrom(
2949                 address(this),
2950                 msg.sender,
2951                 tokenIds[i],
2952                 ''
2953             );
2954         }
2955     }
2956 
2957     
2958     function viewRewards() external view returns (uint256)
2959     {
2960         uint256 payout = 0;
2961         
2962         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
2963         {
2964             payout = payout + totalRewardsToPay(_deposits[msg.sender].at(i));
2965         }
2966         return payout;
2967     }
2968     
2969     function claimRewards() external
2970     {
2971         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
2972         {
2973             cosmictoken.getReward(msg.sender, totalRewardsToPay(_deposits[msg.sender].at(i)));
2974             IDvsDaysStaked[_deposits[msg.sender].at(i)] = block.timestamp;
2975         }
2976     }   
2977     
2978     function totalRewardsToPay(uint256 tokenId) internal view returns(uint256)
2979     {
2980         uint256 payout = 0;
2981         
2982         if(tokenId > 0 && tokenId <= genesisSupply)
2983         {
2984             payout = howManyDaysStaked(tokenId) * 20;
2985         }
2986         else if (tokenId > genesisSupply && tokenId <= maxSupply)
2987         {
2988             payout = howManyDaysStaked(tokenId) * 5;
2989         }
2990         
2991         return payout;
2992     }
2993     
2994     function howManyDaysStaked(uint256 tokenId) public view returns(uint256)
2995     {
2996         
2997         require(
2998             _deposits[msg.sender].contains(tokenId),
2999             'Token not deposited'
3000         );
3001         
3002         uint256 returndays;
3003         uint256 timeCalc = block.timestamp - IDvsDaysStaked[tokenId];
3004         returndays = timeCalc / 86400;
3005        
3006         return returndays;
3007     }
3008     
3009     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
3010         uint256 tokenCount = balanceOf(_owner);
3011 
3012         uint256[] memory tokensId = new uint256[](tokenCount);
3013         for (uint256 i = 0; i < tokenCount; i++) {
3014             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
3015         }
3016 
3017         return tokensId;
3018     }
3019     
3020     function returnStakedTokens() public view returns (uint256[] memory)
3021     {
3022         return _deposits[msg.sender].values();
3023     }
3024     
3025     function totalTokensInWallet() public view returns(uint256)
3026     {
3027         return cosmictoken.balanceOf(msg.sender);
3028     }
3029     
3030    
3031     function onERC721Received(
3032         address,
3033         address,
3034         uint256,
3035         bytes calldata
3036     ) external pure override returns (bytes4) {
3037         return IERC721Receiver.onERC721Received.selector;
3038     }
3039 }
3040 // File: ERC721A.sol
3041 
3042 
3043 // Creators: locationtba.eth, 2pmflow.eth
3044 
3045 pragma solidity ^0.8.0;
3046 
3047 
3048 
3049 
3050 
3051 
3052 
3053 
3054 
3055 /**
3056  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
3057  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
3058  *
3059  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
3060  *
3061  * Does not support burning tokens to address(0).
3062  */
3063 contract ERC721A is
3064   Context,
3065   ERC165,
3066   IERC721,
3067   IERC721Metadata,
3068   IERC721Enumerable
3069 {
3070   using Address for address;
3071   using Strings for uint256;
3072 
3073   struct TokenOwnership {
3074     address addr;
3075     uint64 startTimestamp;
3076   }
3077 
3078   struct AddressData {
3079     uint128 balance;
3080     uint128 numberMinted;
3081   }
3082 
3083   uint256 private currentIndex = 0;
3084 
3085   uint256 internal immutable maxBatchSize;
3086 
3087   // Token name
3088   string private _name;
3089 
3090   // Token symbol
3091   string private _symbol;
3092 
3093   // Mapping from token ID to ownership details
3094   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
3095   mapping(uint256 => TokenOwnership) private _ownerships;
3096 
3097   // Mapping owner address to address data
3098   mapping(address => AddressData) private _addressData;
3099 
3100   // Mapping from token ID to approved address
3101   mapping(uint256 => address) private _tokenApprovals;
3102 
3103   // Mapping from owner to operator approvals
3104   mapping(address => mapping(address => bool)) private _operatorApprovals;
3105 
3106   /**
3107    * @dev
3108    * `maxBatchSize` refers to how much a minter can mint at a time.
3109    */
3110   constructor(
3111     string memory name_,
3112     string memory symbol_,
3113     uint256 maxBatchSize_
3114   ) {
3115     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
3116     _name = name_;
3117     _symbol = symbol_;
3118     maxBatchSize = maxBatchSize_;
3119   }
3120 
3121   /**
3122    * @dev See {IERC721Enumerable-totalSupply}.
3123    */
3124   function totalSupply() public view override returns (uint256) {
3125     return currentIndex;
3126   }
3127 
3128   /**
3129    * @dev See {IERC721Enumerable-tokenByIndex}.
3130    */
3131   function tokenByIndex(uint256 index) public view override returns (uint256) {
3132     require(index < totalSupply(), "ERC721A: global index out of bounds");
3133     return index;
3134   }
3135 
3136   /**
3137    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3138    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
3139    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
3140    */
3141   function tokenOfOwnerByIndex(address owner, uint256 index)
3142     public
3143     view
3144     override
3145     returns (uint256)
3146   {
3147     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
3148     uint256 numMintedSoFar = totalSupply();
3149     uint256 tokenIdsIdx = 0;
3150     address currOwnershipAddr = address(0);
3151     for (uint256 i = 0; i < numMintedSoFar; i++) {
3152       TokenOwnership memory ownership = _ownerships[i];
3153       if (ownership.addr != address(0)) {
3154         currOwnershipAddr = ownership.addr;
3155       }
3156       if (currOwnershipAddr == owner) {
3157         if (tokenIdsIdx == index) {
3158           return i;
3159         }
3160         tokenIdsIdx++;
3161       }
3162     }
3163     revert("ERC721A: unable to get token of owner by index");
3164   }
3165 
3166   /**
3167    * @dev See {IERC165-supportsInterface}.
3168    */
3169   function supportsInterface(bytes4 interfaceId)
3170     public
3171     view
3172     virtual
3173     override(ERC165, IERC165)
3174     returns (bool)
3175   {
3176     return
3177       interfaceId == type(IERC721).interfaceId ||
3178       interfaceId == type(IERC721Metadata).interfaceId ||
3179       interfaceId == type(IERC721Enumerable).interfaceId ||
3180       super.supportsInterface(interfaceId);
3181   }
3182 
3183   /**
3184    * @dev See {IERC721-balanceOf}.
3185    */
3186   function balanceOf(address owner) public view override returns (uint256) {
3187     require(owner != address(0), "ERC721A: balance query for the zero address");
3188     return uint256(_addressData[owner].balance);
3189   }
3190 
3191   function _numberMinted(address owner) internal view returns (uint256) {
3192     require(
3193       owner != address(0),
3194       "ERC721A: number minted query for the zero address"
3195     );
3196     return uint256(_addressData[owner].numberMinted);
3197   }
3198 
3199   function ownershipOf(uint256 tokenId)
3200     internal
3201     view
3202     returns (TokenOwnership memory)
3203   {
3204     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
3205 
3206     uint256 lowestTokenToCheck;
3207     if (tokenId >= maxBatchSize) {
3208       lowestTokenToCheck = tokenId - maxBatchSize + 1;
3209     }
3210 
3211     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
3212       TokenOwnership memory ownership = _ownerships[curr];
3213       if (ownership.addr != address(0)) {
3214         return ownership;
3215       }
3216     }
3217 
3218     revert("ERC721A: unable to determine the owner of token");
3219   }
3220 
3221   /**
3222    * @dev See {IERC721-ownerOf}.
3223    */
3224   function ownerOf(uint256 tokenId) public view override returns (address) {
3225     return ownershipOf(tokenId).addr;
3226   }
3227 
3228   /**
3229    * @dev See {IERC721Metadata-name}.
3230    */
3231   function name() public view virtual override returns (string memory) {
3232     return _name;
3233   }
3234 
3235   /**
3236    * @dev See {IERC721Metadata-symbol}.
3237    */
3238   function symbol() public view virtual override returns (string memory) {
3239     return _symbol;
3240   }
3241 
3242   /**
3243    * @dev See {IERC721Metadata-tokenURI}.
3244    */
3245   function tokenURI(uint256 tokenId)
3246     public
3247     view
3248     virtual
3249     override
3250     returns (string memory)
3251   {
3252     require(
3253       _exists(tokenId),
3254       "ERC721Metadata: URI query for nonexistent token"
3255     );
3256 
3257     string memory baseURI = _baseURI();
3258     return
3259       bytes(baseURI).length > 0
3260         ? string(abi.encodePacked(baseURI, tokenId.toString()))
3261         : "";
3262   }
3263 
3264   /**
3265    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3266    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3267    * by default, can be overriden in child contracts.
3268    */
3269   function _baseURI() internal view virtual returns (string memory) {
3270     return "";
3271   }
3272 
3273   /**
3274    * @dev See {IERC721-approve}.
3275    */
3276   function approve(address to, uint256 tokenId) public override {
3277     address owner = ERC721A.ownerOf(tokenId);
3278     require(to != owner, "ERC721A: approval to current owner");
3279 
3280     require(
3281       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3282       "ERC721A: approve caller is not owner nor approved for all"
3283     );
3284 
3285     _approve(to, tokenId, owner);
3286   }
3287 
3288   /**
3289    * @dev See {IERC721-getApproved}.
3290    */
3291   function getApproved(uint256 tokenId) public view override returns (address) {
3292     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
3293 
3294     return _tokenApprovals[tokenId];
3295   }
3296 
3297   /**
3298    * @dev See {IERC721-setApprovalForAll}.
3299    */
3300   function setApprovalForAll(address operator, bool approved) public override {
3301     require(operator != _msgSender(), "ERC721A: approve to caller");
3302 
3303     _operatorApprovals[_msgSender()][operator] = approved;
3304     emit ApprovalForAll(_msgSender(), operator, approved);
3305   }
3306 
3307   /**
3308    * @dev See {IERC721-isApprovedForAll}.
3309    */
3310   function isApprovedForAll(address owner, address operator)
3311     public
3312     view
3313     virtual
3314     override
3315     returns (bool)
3316   {
3317     return _operatorApprovals[owner][operator];
3318   }
3319 
3320   /**
3321    * @dev See {IERC721-transferFrom}.
3322    */
3323   function transferFrom(
3324     address from,
3325     address to,
3326     uint256 tokenId
3327   ) public virtual override {
3328     _transfer(from, to, tokenId);
3329   }
3330 
3331   /**
3332    * @dev See {IERC721-safeTransferFrom}.
3333    */
3334   function safeTransferFrom(
3335     address from,
3336     address to,
3337     uint256 tokenId
3338   ) public virtual override {
3339     safeTransferFrom(from, to, tokenId, "");
3340   }
3341 
3342   /**
3343    * @dev See {IERC721-safeTransferFrom}.
3344    */
3345   function safeTransferFrom(
3346     address from,
3347     address to,
3348     uint256 tokenId,
3349     bytes memory _data
3350   ) public virtual override {
3351     _transfer(from, to, tokenId);
3352     require(
3353       _checkOnERC721Received(from, to, tokenId, _data),
3354       "ERC721A: transfer to non ERC721Receiver implementer"
3355     );
3356   }
3357 
3358   /**
3359    * @dev Returns whether `tokenId` exists.
3360    *
3361    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3362    *
3363    * Tokens start existing when they are minted (`_mint`),
3364    */
3365   function _exists(uint256 tokenId) internal view returns (bool) {
3366     return tokenId < currentIndex;
3367   }
3368 
3369   function _safeMint(address to, uint256 quantity) internal {
3370     _safeMint(to, quantity, "");
3371   }
3372 
3373   /**
3374    * @dev Mints `quantity` tokens and transfers them to `to`.
3375    *
3376    * Requirements:
3377    *
3378    * - `to` cannot be the zero address.
3379    * - `quantity` cannot be larger than the max batch size.
3380    *
3381    * Emits a {Transfer} event.
3382    */
3383   function _safeMint(
3384     address to,
3385     uint256 quantity,
3386     bytes memory _data
3387   ) internal virtual {
3388     uint256 startTokenId = currentIndex;
3389     require(to != address(0), "ERC721A: mint to the zero address");
3390     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
3391     require(!_exists(startTokenId), "ERC721A: token already minted");
3392     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
3393 
3394     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
3395 
3396     AddressData memory addressData = _addressData[to];
3397     _addressData[to] = AddressData(
3398       addressData.balance + uint128(quantity),
3399       addressData.numberMinted + uint128(quantity)
3400     );
3401     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
3402 
3403     uint256 updatedIndex = startTokenId;
3404 
3405     for (uint256 i = 0; i < quantity; i++) {
3406       emit Transfer(address(0), to, updatedIndex);
3407       require(
3408         _checkOnERC721Received(address(0), to, updatedIndex, _data),
3409         "ERC721A: transfer to non ERC721Receiver implementer"
3410       );
3411       updatedIndex++;
3412     }
3413 
3414     currentIndex = updatedIndex;
3415     _afterTokenTransfers(address(0), to, startTokenId, quantity);
3416   }
3417 
3418   /**
3419    * @dev Transfers `tokenId` from `from` to `to`.
3420    *
3421    * Requirements:
3422    *
3423    * - `to` cannot be the zero address.
3424    * - `tokenId` token must be owned by `from`.
3425    *
3426    * Emits a {Transfer} event.
3427    */
3428   function _transfer(
3429     address from,
3430     address to,
3431     uint256 tokenId
3432   ) private {
3433     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
3434 
3435     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
3436       getApproved(tokenId) == _msgSender() ||
3437       isApprovedForAll(prevOwnership.addr, _msgSender()));
3438 
3439     require(
3440       isApprovedOrOwner,
3441       "ERC721A: transfer caller is not owner nor approved"
3442     );
3443 
3444     require(
3445       prevOwnership.addr == from,
3446       "ERC721A: transfer from incorrect owner"
3447     );
3448     require(to != address(0), "ERC721A: transfer to the zero address");
3449 
3450     _beforeTokenTransfers(from, to, tokenId, 1);
3451 
3452     // Clear approvals from the previous owner
3453     _approve(address(0), tokenId, prevOwnership.addr);
3454 
3455     _addressData[from].balance -= 1;
3456     _addressData[to].balance += 1;
3457     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
3458 
3459     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
3460     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
3461     uint256 nextTokenId = tokenId + 1;
3462     if (_ownerships[nextTokenId].addr == address(0)) {
3463       if (_exists(nextTokenId)) {
3464         _ownerships[nextTokenId] = TokenOwnership(
3465           prevOwnership.addr,
3466           prevOwnership.startTimestamp
3467         );
3468       }
3469     }
3470 
3471     emit Transfer(from, to, tokenId);
3472     _afterTokenTransfers(from, to, tokenId, 1);
3473   }
3474 
3475   /**
3476    * @dev Approve `to` to operate on `tokenId`
3477    *
3478    * Emits a {Approval} event.
3479    */
3480   function _approve(
3481     address to,
3482     uint256 tokenId,
3483     address owner
3484   ) private {
3485     _tokenApprovals[tokenId] = to;
3486     emit Approval(owner, to, tokenId);
3487   }
3488 
3489   uint256 public nextOwnerToExplicitlySet = 0;
3490 
3491   /**
3492    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
3493    */
3494   function _setOwnersExplicit(uint256 quantity) internal {
3495     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
3496     require(quantity > 0, "quantity must be nonzero");
3497     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
3498     if (endIndex > currentIndex - 1) {
3499       endIndex = currentIndex - 1;
3500     }
3501     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
3502     require(_exists(endIndex), "not enough minted yet for this cleanup");
3503     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
3504       if (_ownerships[i].addr == address(0)) {
3505         TokenOwnership memory ownership = ownershipOf(i);
3506         _ownerships[i] = TokenOwnership(
3507           ownership.addr,
3508           ownership.startTimestamp
3509         );
3510       }
3511     }
3512     nextOwnerToExplicitlySet = endIndex + 1;
3513   }
3514 
3515   /**
3516    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3517    * The call is not executed if the target address is not a contract.
3518    *
3519    * @param from address representing the previous owner of the given token ID
3520    * @param to target address that will receive the tokens
3521    * @param tokenId uint256 ID of the token to be transferred
3522    * @param _data bytes optional data to send along with the call
3523    * @return bool whether the call correctly returned the expected magic value
3524    */
3525   function _checkOnERC721Received(
3526     address from,
3527     address to,
3528     uint256 tokenId,
3529     bytes memory _data
3530   ) private returns (bool) {
3531     if (to.isContract()) {
3532       try
3533         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
3534       returns (bytes4 retval) {
3535         return retval == IERC721Receiver(to).onERC721Received.selector;
3536       } catch (bytes memory reason) {
3537         if (reason.length == 0) {
3538           revert("ERC721A: transfer to non ERC721Receiver implementer");
3539         } else {
3540           assembly {
3541             revert(add(32, reason), mload(reason))
3542           }
3543         }
3544       }
3545     } else {
3546       return true;
3547     }
3548   }
3549 
3550   /**
3551    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
3552    *
3553    * startTokenId - the first token id to be transferred
3554    * quantity - the amount to be transferred
3555    *
3556    * Calling conditions:
3557    *
3558    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3559    * transferred to `to`.
3560    * - When `from` is zero, `tokenId` will be minted for `to`.
3561    */
3562   function _beforeTokenTransfers(
3563     address from,
3564     address to,
3565     uint256 startTokenId,
3566     uint256 quantity
3567   ) internal virtual {}
3568 
3569   /**
3570    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3571    * minting.
3572    *
3573    * startTokenId - the first token id to be transferred
3574    * quantity - the amount to be transferred
3575    *
3576    * Calling conditions:
3577    *
3578    * - when `from` and `to` are both non-zero.
3579    * - `from` and `to` are never both zero.
3580    */
3581   function _afterTokenTransfers(
3582     address from,
3583     address to,
3584     uint256 startTokenId,
3585     uint256 quantity
3586   ) internal virtual {}
3587 }
3588 
3589 // File: cosmicFusion.sol
3590 
3591 
3592 pragma solidity 0.8.7;
3593 
3594 
3595 
3596 
3597 
3598 
3599 
3600 contract CosmicFusion is ERC721A, Ownable, ReentrancyGuard
3601 {
3602     using Address for address;
3603     using Strings for uint256;
3604     using Counters for Counters.Counter;
3605 
3606     Counters.Counter private _tokenIdTracker;
3607 
3608     string public baseURI;
3609     string public baseExtension = ".json";
3610 
3611     mapping (uint256 => address) public fusionIndexToAddress;
3612     mapping (uint256 => bool) public hasFused;
3613 
3614     CosmicLabs public cosmicLabs;
3615 
3616     constructor() ERC721A("Cosmic Fusion", "CFUSION", 100) 
3617     {
3618         
3619     }
3620 
3621     function setCosmicLabsAddress(address clabsAddress) public onlyOwner
3622     {
3623         cosmicLabs = CosmicLabs(clabsAddress);
3624     }
3625 
3626     modifier onlySender {
3627         require(msg.sender == tx.origin);
3628         _;
3629     }
3630 
3631     function teamMint(uint256 amount) public onlyOwner nonReentrant
3632     {
3633         for(uint i=0;i<amount;i++)
3634         {
3635             fusionIndexToAddress[_tokenIdTracker.current()] = msg.sender;
3636             _tokenIdTracker.increment();
3637         }
3638         _safeMint(msg.sender, amount);
3639     }
3640 
3641     function FuseDucks(uint256[] memory tokenIds) public payable nonReentrant
3642     {
3643         require(tokenIds.length % 2 == 0, "Odd amount of Ducks Selected");
3644 
3645         for(uint256 i=0; i<tokenIds.length; i++)
3646         {
3647             require(tokenIds[i] >= 1001 , "You selected a Genesis");
3648             require(!hasFused[tokenIds[i]], "These ducks have already fused!");
3649             cosmicLabs.transferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD ,tokenIds[i]);
3650             hasFused[tokenIds[i]] = true;
3651         }
3652 
3653         uint256 fuseAmount = tokenIds.length / 2;
3654         
3655         for(uint256 i=0; i<fuseAmount; i++)
3656         {
3657             fusionIndexToAddress[_tokenIdTracker.current()] = msg.sender;
3658             _tokenIdTracker.increment();
3659         }
3660         _safeMint(msg.sender, fuseAmount);
3661         
3662     }
3663 
3664 
3665     function _withdraw(address payable address_, uint256 amount_) internal {
3666         (bool success, ) = payable(address_).call{value: amount_}("");
3667         require(success, "Transfer failed");
3668     }
3669 
3670     function withdrawEther() external onlyOwner {
3671         _withdraw(payable(msg.sender), address(this).balance);
3672     }
3673 
3674     function withdrawEtherTo(address payable to_) external onlyOwner {
3675         _withdraw(to_, address(this).balance);
3676     }
3677     
3678     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3679         baseURI = _newBaseURI;
3680     }
3681     function _baseURI() internal view virtual override returns (string memory) {
3682         return baseURI;
3683     }   
3684     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
3685     {
3686         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3687 
3688         string memory currentBaseURI = _baseURI();
3689         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
3690     }
3691 
3692     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
3693         uint256 _balance = balanceOf(address_);
3694         uint256[] memory _tokens = new uint256[] (_balance);
3695         uint256 _index;
3696         uint256 _loopThrough = totalSupply();
3697         for (uint256 i = 0; i < _loopThrough; i++) {
3698             bool _exists = _exists(i);
3699             if (_exists) {
3700                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
3701             }
3702             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
3703         }
3704         return _tokens;
3705     }
3706 
3707     function transferFrom(address from, address to, uint256 tokenId) public  override {
3708         fusionIndexToAddress[tokenId] = to;
3709 		ERC721A.transferFrom(from, to, tokenId);
3710 	}
3711 
3712 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public  override {
3713         fusionIndexToAddress[tokenId] = to;
3714 		ERC721A.safeTransferFrom(from, to, tokenId, _data);
3715 	}
3716 
3717 
3718     
3719 }