1 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
231 
232 
233 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Interface of the ERC20 standard as defined in the EIP.
239  */
240 interface IERC20 {
241     /**
242      * @dev Returns the amount of tokens in existence.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns the amount of tokens owned by `account`.
248      */
249     function balanceOf(address account) external view returns (uint256);
250 
251     /**
252      * @dev Moves `amount` tokens from the caller's account to `recipient`.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transfer(address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Returns the remaining number of tokens that `spender` will be
262      * allowed to spend on behalf of `owner` through {transferFrom}. This is
263      * zero by default.
264      *
265      * This value changes when {approve} or {transferFrom} are called.
266      */
267     function allowance(address owner, address spender) external view returns (uint256);
268 
269     /**
270      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * IMPORTANT: Beware that changing an allowance with this method brings the risk
275      * that someone may use both the old and the new allowance by unfortunate
276      * transaction ordering. One possible solution to mitigate this race
277      * condition is to first reduce the spender's allowance to 0 and set the
278      * desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address spender, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Moves `amount` tokens from `sender` to `recipient` using the
287      * allowance mechanism. `amount` is then deducted from the caller's
288      * allowance.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) external returns (bool);
299 
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 }
314 
315 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
316 
317 
318 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Interface for the optional metadata functions from the ERC20 standard.
325  *
326  * _Available since v4.1._
327  */
328 interface IERC20Metadata is IERC20 {
329     /**
330      * @dev Returns the name of the token.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the symbol of the token.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the decimals places of the token.
341      */
342     function decimals() external view returns (uint8);
343 }
344 
345 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
346 
347 
348 // OpenZeppelin Contracts v4.3.2 (utils/Counters.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @title Counters
354  * @author Matt Condon (@shrugs)
355  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
356  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
357  *
358  * Include with `using Counters for Counters.Counter;`
359  */
360 library Counters {
361     struct Counter {
362         // This variable should never be directly accessed by users of the library: interactions must be restricted to
363         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
364         // this feature: see https://github.com/ethereum/solidity/issues/4637
365         uint256 _value; // default: 0
366     }
367 
368     function current(Counter storage counter) internal view returns (uint256) {
369         return counter._value;
370     }
371 
372     function increment(Counter storage counter) internal {
373         unchecked {
374             counter._value += 1;
375         }
376     }
377 
378     function decrement(Counter storage counter) internal {
379         uint256 value = counter._value;
380         require(value > 0, "Counter: decrement overflow");
381         unchecked {
382             counter._value = value - 1;
383         }
384     }
385 
386     function reset(Counter storage counter) internal {
387         counter._value = 0;
388     }
389 }
390 
391 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
392 
393 
394 // OpenZeppelin Contracts v4.3.2 (utils/math/Math.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @dev Standard math utilities missing in the Solidity language.
400  */
401 library Math {
402     /**
403      * @dev Returns the largest of two numbers.
404      */
405     function max(uint256 a, uint256 b) internal pure returns (uint256) {
406         return a >= b ? a : b;
407     }
408 
409     /**
410      * @dev Returns the smallest of two numbers.
411      */
412     function min(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a < b ? a : b;
414     }
415 
416     /**
417      * @dev Returns the average of two numbers. The result is rounded towards
418      * zero.
419      */
420     function average(uint256 a, uint256 b) internal pure returns (uint256) {
421         // (a + b) / 2 can overflow.
422         return (a & b) + (a ^ b) / 2;
423     }
424 
425     /**
426      * @dev Returns the ceiling of the division of two numbers.
427      *
428      * This differs from standard division with `/` in that it rounds up instead
429      * of rounding down.
430      */
431     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
432         // (a + b - 1) / b can overflow on addition, so we distribute.
433         return a / b + (a % b == 0 ? 0 : 1);
434     }
435 }
436 
437 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
438 
439 
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev Library for managing
445  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
446  * types.
447  *
448  * Sets have the following properties:
449  *
450  * - Elements are added, removed, and checked for existence in constant time
451  * (O(1)).
452  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
453  *
454  * ```
455  * contract Example {
456  *     // Add the library methods
457  *     using EnumerableSet for EnumerableSet.AddressSet;
458  *
459  *     // Declare a set state variable
460  *     EnumerableSet.AddressSet private mySet;
461  * }
462  * ```
463  *
464  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
465  * and `uint256` (`UintSet`) are supported.
466  */
467 library EnumerableSet {
468     // To implement this library for multiple types with as little code
469     // repetition as possible, we write it in terms of a generic Set type with
470     // bytes32 values.
471     // The Set implementation uses private functions, and user-facing
472     // implementations (such as AddressSet) are just wrappers around the
473     // underlying Set.
474     // This means that we can only create new EnumerableSets for types that fit
475     // in bytes32.
476 
477     struct Set {
478         // Storage of set values
479         bytes32[] _values;
480         // Position of the value in the `values` array, plus 1 because index 0
481         // means a value is not in the set.
482         mapping(bytes32 => uint256) _indexes;
483     }
484 
485     /**
486      * @dev Add a value to a set. O(1).
487      *
488      * Returns true if the value was added to the set, that is if it was not
489      * already present.
490      */
491     function _add(Set storage set, bytes32 value) private returns (bool) {
492         if (!_contains(set, value)) {
493             set._values.push(value);
494             // The value is stored at length-1, but we add 1 to all indexes
495             // and use 0 as a sentinel value
496             set._indexes[value] = set._values.length;
497             return true;
498         } else {
499             return false;
500         }
501     }
502 
503     /**
504      * @dev Removes a value from a set. O(1).
505      *
506      * Returns true if the value was removed from the set, that is if it was
507      * present.
508      */
509     function _remove(Set storage set, bytes32 value) private returns (bool) {
510         // We read and store the value's index to prevent multiple reads from the same storage slot
511         uint256 valueIndex = set._indexes[value];
512 
513         if (valueIndex != 0) {
514             // Equivalent to contains(set, value)
515             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
516             // the array, and then remove the last element (sometimes called as 'swap and pop').
517             // This modifies the order of the array, as noted in {at}.
518 
519             uint256 toDeleteIndex = valueIndex - 1;
520             uint256 lastIndex = set._values.length - 1;
521 
522             if (lastIndex != toDeleteIndex) {
523                 bytes32 lastvalue = set._values[lastIndex];
524 
525                 // Move the last value to the index where the value to delete is
526                 set._values[toDeleteIndex] = lastvalue;
527                 // Update the index for the moved value
528                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
529             }
530 
531             // Delete the slot where the moved value was stored
532             set._values.pop();
533 
534             // Delete the index for the deleted slot
535             delete set._indexes[value];
536 
537             return true;
538         } else {
539             return false;
540         }
541     }
542 
543     /**
544      * @dev Returns true if the value is in the set. O(1).
545      */
546     function _contains(Set storage set, bytes32 value) private view returns (bool) {
547         return set._indexes[value] != 0;
548     }
549 
550     /**
551      * @dev Returns the number of values on the set. O(1).
552      */
553     function _length(Set storage set) private view returns (uint256) {
554         return set._values.length;
555     }
556 
557     /**
558      * @dev Returns the value stored at position `index` in the set. O(1).
559      *
560      * Note that there are no guarantees on the ordering of values inside the
561      * array, and it may change when more values are added or removed.
562      *
563      * Requirements:
564      *
565      * - `index` must be strictly less than {length}.
566      */
567     function _at(Set storage set, uint256 index) private view returns (bytes32) {
568         return set._values[index];
569     }
570 
571     /**
572      * @dev Return the entire set in an array
573      *
574      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
575      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
576      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
577      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
578      */
579     function _values(Set storage set) private view returns (bytes32[] memory) {
580         return set._values;
581     }
582 
583     // Bytes32Set
584 
585     struct Bytes32Set {
586         Set _inner;
587     }
588 
589     /**
590      * @dev Add a value to a set. O(1).
591      *
592      * Returns true if the value was added to the set, that is if it was not
593      * already present.
594      */
595     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
596         return _add(set._inner, value);
597     }
598 
599     /**
600      * @dev Removes a value from a set. O(1).
601      *
602      * Returns true if the value was removed from the set, that is if it was
603      * present.
604      */
605     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
606         return _remove(set._inner, value);
607     }
608 
609     /**
610      * @dev Returns true if the value is in the set. O(1).
611      */
612     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
613         return _contains(set._inner, value);
614     }
615 
616     /**
617      * @dev Returns the number of values in the set. O(1).
618      */
619     function length(Bytes32Set storage set) internal view returns (uint256) {
620         return _length(set._inner);
621     }
622 
623     /**
624      * @dev Returns the value stored at position `index` in the set. O(1).
625      *
626      * Note that there are no guarantees on the ordering of values inside the
627      * array, and it may change when more values are added or removed.
628      *
629      * Requirements:
630      *
631      * - `index` must be strictly less than {length}.
632      */
633     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
634         return _at(set._inner, index);
635     }
636 
637     /**
638      * @dev Return the entire set in an array
639      *
640      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
641      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
642      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
643      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
644      */
645     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
646         return _values(set._inner);
647     }
648 
649     // AddressSet
650 
651     struct AddressSet {
652         Set _inner;
653     }
654 
655     /**
656      * @dev Add a value to a set. O(1).
657      *
658      * Returns true if the value was added to the set, that is if it was not
659      * already present.
660      */
661     function add(AddressSet storage set, address value) internal returns (bool) {
662         return _add(set._inner, bytes32(uint256(uint160(value))));
663     }
664 
665     /**
666      * @dev Removes a value from a set. O(1).
667      *
668      * Returns true if the value was removed from the set, that is if it was
669      * present.
670      */
671     function remove(AddressSet storage set, address value) internal returns (bool) {
672         return _remove(set._inner, bytes32(uint256(uint160(value))));
673     }
674 
675     /**
676      * @dev Returns true if the value is in the set. O(1).
677      */
678     function contains(AddressSet storage set, address value) internal view returns (bool) {
679         return _contains(set._inner, bytes32(uint256(uint160(value))));
680     }
681 
682     /**
683      * @dev Returns the number of values in the set. O(1).
684      */
685     function length(AddressSet storage set) internal view returns (uint256) {
686         return _length(set._inner);
687     }
688 
689     /**
690      * @dev Returns the value stored at position `index` in the set. O(1).
691      *
692      * Note that there are no guarantees on the ordering of values inside the
693      * array, and it may change when more values are added or removed.
694      *
695      * Requirements:
696      *
697      * - `index` must be strictly less than {length}.
698      */
699     function at(AddressSet storage set, uint256 index) internal view returns (address) {
700         return address(uint160(uint256(_at(set._inner, index))));
701     }
702 
703     /**
704      * @dev Return the entire set in an array
705      *
706      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
707      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
708      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
709      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
710      */
711     function values(AddressSet storage set) internal view returns (address[] memory) {
712         bytes32[] memory store = _values(set._inner);
713         address[] memory result;
714 
715         assembly {
716             result := store
717         }
718 
719         return result;
720     }
721 
722     // UintSet
723 
724     struct UintSet {
725         Set _inner;
726     }
727 
728     /**
729      * @dev Add a value to a set. O(1).
730      *
731      * Returns true if the value was added to the set, that is if it was not
732      * already present.
733      */
734     function add(UintSet storage set, uint256 value) internal returns (bool) {
735         return _add(set._inner, bytes32(value));
736     }
737 
738     /**
739      * @dev Removes a value from a set. O(1).
740      *
741      * Returns true if the value was removed from the set, that is if it was
742      * present.
743      */
744     function remove(UintSet storage set, uint256 value) internal returns (bool) {
745         return _remove(set._inner, bytes32(value));
746     }
747 
748     /**
749      * @dev Returns true if the value is in the set. O(1).
750      */
751     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
752         return _contains(set._inner, bytes32(value));
753     }
754 
755     /**
756      * @dev Returns the number of values on the set. O(1).
757      */
758     function length(UintSet storage set) internal view returns (uint256) {
759         return _length(set._inner);
760     }
761 
762     /**
763      * @dev Returns the value stored at position `index` in the set. O(1).
764      *
765      * Note that there are no guarantees on the ordering of values inside the
766      * array, and it may change when more values are added or removed.
767      *
768      * Requirements:
769      *
770      * - `index` must be strictly less than {length}.
771      */
772     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
773         return uint256(_at(set._inner, index));
774     }
775 
776     /**
777      * @dev Return the entire set in an array
778      *
779      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
780      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
781      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
782      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
783      */
784     function values(UintSet storage set) internal view returns (uint256[] memory) {
785         bytes32[] memory store = _values(set._inner);
786         uint256[] memory result;
787 
788         assembly {
789             result := store
790         }
791 
792         return result;
793     }
794 }
795 
796 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
797 
798 
799 // OpenZeppelin Contracts v4.3.2 (utils/Strings.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @dev String operations.
805  */
806 library Strings {
807     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
808 
809     /**
810      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
811      */
812     function toString(uint256 value) internal pure returns (string memory) {
813         // Inspired by OraclizeAPI's implementation - MIT licence
814         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
815 
816         if (value == 0) {
817             return "0";
818         }
819         uint256 temp = value;
820         uint256 digits;
821         while (temp != 0) {
822             digits++;
823             temp /= 10;
824         }
825         bytes memory buffer = new bytes(digits);
826         while (value != 0) {
827             digits -= 1;
828             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
829             value /= 10;
830         }
831         return string(buffer);
832     }
833 
834     /**
835      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
836      */
837     function toHexString(uint256 value) internal pure returns (string memory) {
838         if (value == 0) {
839             return "0x00";
840         }
841         uint256 temp = value;
842         uint256 length = 0;
843         while (temp != 0) {
844             length++;
845             temp >>= 8;
846         }
847         return toHexString(value, length);
848     }
849 
850     /**
851      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
852      */
853     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
854         bytes memory buffer = new bytes(2 * length + 2);
855         buffer[0] = "0";
856         buffer[1] = "x";
857         for (uint256 i = 2 * length + 1; i > 1; --i) {
858             buffer[i] = _HEX_SYMBOLS[value & 0xf];
859             value >>= 4;
860         }
861         require(value == 0, "Strings: hex length insufficient");
862         return string(buffer);
863     }
864 }
865 
866 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
867 
868 
869 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 /**
874  * @dev Provides information about the current execution context, including the
875  * sender of the transaction and its data. While these are generally available
876  * via msg.sender and msg.data, they should not be accessed in such a direct
877  * manner, since when dealing with meta-transactions the account sending and
878  * paying for execution may not be the actual sender (as far as an application
879  * is concerned).
880  *
881  * This contract is only required for intermediate, library-like contracts.
882  */
883 abstract contract Context {
884     function _msgSender() internal view virtual returns (address) {
885         return msg.sender;
886     }
887 
888     function _msgData() internal view virtual returns (bytes calldata) {
889         return msg.data;
890     }
891 }
892 
893 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
894 
895 
896 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 
901 
902 
903 /**
904  * @dev Implementation of the {IERC20} interface.
905  *
906  * This implementation is agnostic to the way tokens are created. This means
907  * that a supply mechanism has to be added in a derived contract using {_mint}.
908  * For a generic mechanism see {ERC20PresetMinterPauser}.
909  *
910  * TIP: For a detailed writeup see our guide
911  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
912  * to implement supply mechanisms].
913  *
914  * We have followed general OpenZeppelin Contracts guidelines: functions revert
915  * instead returning `false` on failure. This behavior is nonetheless
916  * conventional and does not conflict with the expectations of ERC20
917  * applications.
918  *
919  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
920  * This allows applications to reconstruct the allowance for all accounts just
921  * by listening to said events. Other implementations of the EIP may not emit
922  * these events, as it isn't required by the specification.
923  *
924  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
925  * functions have been added to mitigate the well-known issues around setting
926  * allowances. See {IERC20-approve}.
927  */
928 contract ERC20 is Context, IERC20, IERC20Metadata {
929     mapping(address => uint256) private _balances;
930 
931     mapping(address => mapping(address => uint256)) private _allowances;
932 
933     uint256 private _totalSupply;
934 
935     string private _name;
936     string private _symbol;
937 
938     /**
939      * @dev Sets the values for {name} and {symbol}.
940      *
941      * The default value of {decimals} is 18. To select a different value for
942      * {decimals} you should overload it.
943      *
944      * All two of these values are immutable: they can only be set once during
945      * construction.
946      */
947     constructor(string memory name_, string memory symbol_) {
948         _name = name_;
949         _symbol = symbol_;
950     }
951 
952     /**
953      * @dev Returns the name of the token.
954      */
955     function name() public view virtual override returns (string memory) {
956         return _name;
957     }
958 
959     /**
960      * @dev Returns the symbol of the token, usually a shorter version of the
961      * name.
962      */
963     function symbol() public view virtual override returns (string memory) {
964         return _symbol;
965     }
966 
967     /**
968      * @dev Returns the number of decimals used to get its user representation.
969      * For example, if `decimals` equals `2`, a balance of `505` tokens should
970      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
971      *
972      * Tokens usually opt for a value of 18, imitating the relationship between
973      * Ether and Wei. This is the value {ERC20} uses, unless this function is
974      * overridden;
975      *
976      * NOTE: This information is only used for _display_ purposes: it in
977      * no way affects any of the arithmetic of the contract, including
978      * {IERC20-balanceOf} and {IERC20-transfer}.
979      */
980     function decimals() public view virtual override returns (uint8) {
981         return 18;
982     }
983 
984     /**
985      * @dev See {IERC20-totalSupply}.
986      */
987     function totalSupply() public view virtual override returns (uint256) {
988         return _totalSupply;
989     }
990 
991     /**
992      * @dev See {IERC20-balanceOf}.
993      */
994     function balanceOf(address account) public view virtual override returns (uint256) {
995         return _balances[account];
996     }
997 
998     /**
999      * @dev See {IERC20-transfer}.
1000      *
1001      * Requirements:
1002      *
1003      * - `recipient` cannot be the zero address.
1004      * - the caller must have a balance of at least `amount`.
1005      */
1006     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1007         _transfer(_msgSender(), recipient, amount);
1008         return true;
1009     }
1010 
1011     /**
1012      * @dev See {IERC20-allowance}.
1013      */
1014     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1015         return _allowances[owner][spender];
1016     }
1017 
1018     /**
1019      * @dev See {IERC20-approve}.
1020      *
1021      * Requirements:
1022      *
1023      * - `spender` cannot be the zero address.
1024      */
1025     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1026         _approve(_msgSender(), spender, amount);
1027         return true;
1028     }
1029 
1030     /**
1031      * @dev See {IERC20-transferFrom}.
1032      *
1033      * Emits an {Approval} event indicating the updated allowance. This is not
1034      * required by the EIP. See the note at the beginning of {ERC20}.
1035      *
1036      * Requirements:
1037      *
1038      * - `sender` and `recipient` cannot be the zero address.
1039      * - `sender` must have a balance of at least `amount`.
1040      * - the caller must have allowance for ``sender``'s tokens of at least
1041      * `amount`.
1042      */
1043     function transferFrom(
1044         address sender,
1045         address recipient,
1046         uint256 amount
1047     ) public virtual override returns (bool) {
1048         _transfer(sender, recipient, amount);
1049 
1050         uint256 currentAllowance = _allowances[sender][_msgSender()];
1051         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1052         unchecked {
1053             _approve(sender, _msgSender(), currentAllowance - amount);
1054         }
1055 
1056         return true;
1057     }
1058 
1059     /**
1060      * @dev Atomically increases the allowance granted to `spender` by the caller.
1061      *
1062      * This is an alternative to {approve} that can be used as a mitigation for
1063      * problems described in {IERC20-approve}.
1064      *
1065      * Emits an {Approval} event indicating the updated allowance.
1066      *
1067      * Requirements:
1068      *
1069      * - `spender` cannot be the zero address.
1070      */
1071     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1072         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1073         return true;
1074     }
1075 
1076     /**
1077      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1078      *
1079      * This is an alternative to {approve} that can be used as a mitigation for
1080      * problems described in {IERC20-approve}.
1081      *
1082      * Emits an {Approval} event indicating the updated allowance.
1083      *
1084      * Requirements:
1085      *
1086      * - `spender` cannot be the zero address.
1087      * - `spender` must have allowance for the caller of at least
1088      * `subtractedValue`.
1089      */
1090     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1091         uint256 currentAllowance = _allowances[_msgSender()][spender];
1092         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1093         unchecked {
1094             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1095         }
1096 
1097         return true;
1098     }
1099 
1100     /**
1101      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1102      *
1103      * This internal function is equivalent to {transfer}, and can be used to
1104      * e.g. implement automatic token fees, slashing mechanisms, etc.
1105      *
1106      * Emits a {Transfer} event.
1107      *
1108      * Requirements:
1109      *
1110      * - `sender` cannot be the zero address.
1111      * - `recipient` cannot be the zero address.
1112      * - `sender` must have a balance of at least `amount`.
1113      */
1114     function _transfer(
1115         address sender,
1116         address recipient,
1117         uint256 amount
1118     ) internal virtual {
1119         require(sender != address(0), "ERC20: transfer from the zero address");
1120         require(recipient != address(0), "ERC20: transfer to the zero address");
1121 
1122         _beforeTokenTransfer(sender, recipient, amount);
1123 
1124         uint256 senderBalance = _balances[sender];
1125         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1126         unchecked {
1127             _balances[sender] = senderBalance - amount;
1128         }
1129         _balances[recipient] += amount;
1130 
1131         emit Transfer(sender, recipient, amount);
1132 
1133         _afterTokenTransfer(sender, recipient, amount);
1134     }
1135 
1136     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1137      * the total supply.
1138      *
1139      * Emits a {Transfer} event with `from` set to the zero address.
1140      *
1141      * Requirements:
1142      *
1143      * - `account` cannot be the zero address.
1144      */
1145     function _mint(address account, uint256 amount) internal virtual {
1146         require(account != address(0), "ERC20: mint to the zero address");
1147 
1148         _beforeTokenTransfer(address(0), account, amount);
1149 
1150         _totalSupply += amount;
1151         _balances[account] += amount;
1152         emit Transfer(address(0), account, amount);
1153 
1154         _afterTokenTransfer(address(0), account, amount);
1155     }
1156 
1157     /**
1158      * @dev Destroys `amount` tokens from `account`, reducing the
1159      * total supply.
1160      *
1161      * Emits a {Transfer} event with `to` set to the zero address.
1162      *
1163      * Requirements:
1164      *
1165      * - `account` cannot be the zero address.
1166      * - `account` must have at least `amount` tokens.
1167      */
1168     function _burn(address account, uint256 amount) internal virtual {
1169         require(account != address(0), "ERC20: burn from the zero address");
1170 
1171         _beforeTokenTransfer(account, address(0), amount);
1172 
1173         uint256 accountBalance = _balances[account];
1174         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1175         unchecked {
1176             _balances[account] = accountBalance - amount;
1177         }
1178         _totalSupply -= amount;
1179 
1180         emit Transfer(account, address(0), amount);
1181 
1182         _afterTokenTransfer(account, address(0), amount);
1183     }
1184 
1185     /**
1186      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1187      *
1188      * This internal function is equivalent to `approve`, and can be used to
1189      * e.g. set automatic allowances for certain subsystems, etc.
1190      *
1191      * Emits an {Approval} event.
1192      *
1193      * Requirements:
1194      *
1195      * - `owner` cannot be the zero address.
1196      * - `spender` cannot be the zero address.
1197      */
1198     function _approve(
1199         address owner,
1200         address spender,
1201         uint256 amount
1202     ) internal virtual {
1203         require(owner != address(0), "ERC20: approve from the zero address");
1204         require(spender != address(0), "ERC20: approve to the zero address");
1205 
1206         _allowances[owner][spender] = amount;
1207         emit Approval(owner, spender, amount);
1208     }
1209 
1210     /**
1211      * @dev Hook that is called before any transfer of tokens. This includes
1212      * minting and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1217      * will be transferred to `to`.
1218      * - when `from` is zero, `amount` tokens will be minted for `to`.
1219      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1220      * - `from` and `to` are never both zero.
1221      *
1222      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1223      */
1224     function _beforeTokenTransfer(
1225         address from,
1226         address to,
1227         uint256 amount
1228     ) internal virtual {}
1229 
1230     /**
1231      * @dev Hook that is called after any transfer of tokens. This includes
1232      * minting and burning.
1233      *
1234      * Calling conditions:
1235      *
1236      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1237      * has been transferred to `to`.
1238      * - when `from` is zero, `amount` tokens have been minted for `to`.
1239      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1240      * - `from` and `to` are never both zero.
1241      *
1242      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1243      */
1244     function _afterTokenTransfer(
1245         address from,
1246         address to,
1247         uint256 amount
1248     ) internal virtual {}
1249 }
1250 
1251 // File: Artifacts/cosmicToken.sol
1252 
1253 pragma solidity 0.8.7;
1254 
1255 
1256 
1257 interface IDuck {
1258 	function balanceOG(address _user) external view returns(uint256);
1259 }
1260 
1261 contract CosmicToken is ERC20("CosmicUtilityToken", "CUT") 
1262 {
1263    
1264     using SafeMath for uint256;
1265    
1266     uint256 public totalTokensBurned = 0;
1267     address[] internal stakeholders;
1268     address  payable private owner;
1269     
1270 
1271     //token Genesis per day
1272     uint256 constant public GENESIS_RATE = 20 ether; 
1273     
1274     //token duck per day
1275     uint256 constant public DUCK_RATE = 5 ether; 
1276     
1277     //token for  genesis minting
1278 	uint256 constant public GENESIS_ISSUANCE = 280 ether;
1279 	
1280 	//token for duck minting
1281 	uint256 constant public DUCK_ISSUANCE = 70 ether;
1282 	
1283 	
1284 	
1285 	// Tue Mar 18 2031 17:46:47 GMT+0000
1286 	uint256 constant public END = 1931622407;
1287 
1288 	mapping(address => uint256) public rewards;
1289 	mapping(address => uint256) public lastUpdate;
1290 	
1291 	
1292     IDuck public ducksContract;
1293    
1294     constructor(address initDuckContract) 
1295     {
1296         owner = payable(msg.sender);
1297         ducksContract = IDuck(initDuckContract);
1298     }
1299    
1300 
1301     function WhoOwns() public view returns (address) {
1302         return owner;
1303     }
1304    
1305     modifier Owned {
1306          require(msg.sender == owner);
1307          _;
1308  }
1309    
1310     function getContractAddress() public view returns (address) {
1311         return address(this);
1312     }
1313 
1314 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
1315 		return a < b ? a : b;
1316 	}    
1317 	
1318 	modifier contractAddressOnly
1319     {
1320          require(msg.sender == address(ducksContract));
1321          _;
1322     }
1323     
1324    	// called when minting many NFTs
1325 	function updateRewardOnMint(address _user, uint256 _tokenId) external contractAddressOnly
1326 	{
1327 	    if(_tokenId <= 1000)
1328 		{
1329             _mint(_user,GENESIS_ISSUANCE);	  	        
1330 		}
1331 		else if(_tokenId >= 1001)
1332 		{
1333             _mint(_user,DUCK_ISSUANCE);	  	        	        
1334 		}
1335 	}
1336 	
1337 
1338 	function getReward(address _to, uint256 totalPayout) external contractAddressOnly
1339 	{
1340 		_mint(_to, (totalPayout * 10 ** 18));
1341 		
1342 	}
1343 	
1344 	function burn(address _from, uint256 _amount) external 
1345 	{
1346 	    require(msg.sender == _from, "You do not own these tokens");
1347 		_burn(_from, _amount);
1348 		totalTokensBurned += _amount;
1349 	}
1350 
1351 
1352   
1353    
1354 }
1355 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1356 
1357 
1358 // OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)
1359 
1360 pragma solidity ^0.8.0;
1361 
1362 
1363 /**
1364  * @dev Contract module which provides a basic access control mechanism, where
1365  * there is an account (an owner) that can be granted exclusive access to
1366  * specific functions.
1367  *
1368  * By default, the owner account will be the one that deploys the contract. This
1369  * can later be changed with {transferOwnership}.
1370  *
1371  * This module is used through inheritance. It will make available the modifier
1372  * `onlyOwner`, which can be applied to your functions to restrict their use to
1373  * the owner.
1374  */
1375 abstract contract Ownable is Context {
1376     address private _owner;
1377 
1378     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1379 
1380     /**
1381      * @dev Initializes the contract setting the deployer as the initial owner.
1382      */
1383     constructor() {
1384         _transferOwnership(_msgSender());
1385     }
1386 
1387     /**
1388      * @dev Returns the address of the current owner.
1389      */
1390     function owner() public view virtual returns (address) {
1391         return _owner;
1392     }
1393 
1394     /**
1395      * @dev Throws if called by any account other than the owner.
1396      */
1397     modifier onlyOwner() {
1398         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1399         _;
1400     }
1401 
1402     /**
1403      * @dev Leaves the contract without owner. It will not be possible to call
1404      * `onlyOwner` functions anymore. Can only be called by the current owner.
1405      *
1406      * NOTE: Renouncing ownership will leave the contract without an owner,
1407      * thereby removing any functionality that is only available to the owner.
1408      */
1409     function renounceOwnership() public virtual onlyOwner {
1410         _transferOwnership(address(0));
1411     }
1412 
1413     /**
1414      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1415      * Can only be called by the current owner.
1416      */
1417     function transferOwnership(address newOwner) public virtual onlyOwner {
1418         require(newOwner != address(0), "Ownable: new owner is the zero address");
1419         _transferOwnership(newOwner);
1420     }
1421 
1422     /**
1423      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1424      * Internal function without access restriction.
1425      */
1426     function _transferOwnership(address newOwner) internal virtual {
1427         address oldOwner = _owner;
1428         _owner = newOwner;
1429         emit OwnershipTransferred(oldOwner, newOwner);
1430     }
1431 }
1432 
1433 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1434 
1435 
1436 // OpenZeppelin Contracts v4.3.2 (utils/Address.sol)
1437 
1438 pragma solidity ^0.8.0;
1439 
1440 /**
1441  * @dev Collection of functions related to the address type
1442  */
1443 library Address {
1444     /**
1445      * @dev Returns true if `account` is a contract.
1446      *
1447      * [IMPORTANT]
1448      * ====
1449      * It is unsafe to assume that an address for which this function returns
1450      * false is an externally-owned account (EOA) and not a contract.
1451      *
1452      * Among others, `isContract` will return false for the following
1453      * types of addresses:
1454      *
1455      *  - an externally-owned account
1456      *  - a contract in construction
1457      *  - an address where a contract will be created
1458      *  - an address where a contract lived, but was destroyed
1459      * ====
1460      */
1461     function isContract(address account) internal view returns (bool) {
1462         // This method relies on extcodesize, which returns 0 for contracts in
1463         // construction, since the code is only stored at the end of the
1464         // constructor execution.
1465 
1466         uint256 size;
1467         assembly {
1468             size := extcodesize(account)
1469         }
1470         return size > 0;
1471     }
1472 
1473     /**
1474      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1475      * `recipient`, forwarding all available gas and reverting on errors.
1476      *
1477      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1478      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1479      * imposed by `transfer`, making them unable to receive funds via
1480      * `transfer`. {sendValue} removes this limitation.
1481      *
1482      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1483      *
1484      * IMPORTANT: because control is transferred to `recipient`, care must be
1485      * taken to not create reentrancy vulnerabilities. Consider using
1486      * {ReentrancyGuard} or the
1487      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1488      */
1489     function sendValue(address payable recipient, uint256 amount) internal {
1490         require(address(this).balance >= amount, "Address: insufficient balance");
1491 
1492         (bool success, ) = recipient.call{value: amount}("");
1493         require(success, "Address: unable to send value, recipient may have reverted");
1494     }
1495 
1496     /**
1497      * @dev Performs a Solidity function call using a low level `call`. A
1498      * plain `call` is an unsafe replacement for a function call: use this
1499      * function instead.
1500      *
1501      * If `target` reverts with a revert reason, it is bubbled up by this
1502      * function (like regular Solidity function calls).
1503      *
1504      * Returns the raw returned data. To convert to the expected return value,
1505      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1506      *
1507      * Requirements:
1508      *
1509      * - `target` must be a contract.
1510      * - calling `target` with `data` must not revert.
1511      *
1512      * _Available since v3.1._
1513      */
1514     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1515         return functionCall(target, data, "Address: low-level call failed");
1516     }
1517 
1518     /**
1519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1520      * `errorMessage` as a fallback revert reason when `target` reverts.
1521      *
1522      * _Available since v3.1._
1523      */
1524     function functionCall(
1525         address target,
1526         bytes memory data,
1527         string memory errorMessage
1528     ) internal returns (bytes memory) {
1529         return functionCallWithValue(target, data, 0, errorMessage);
1530     }
1531 
1532     /**
1533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1534      * but also transferring `value` wei to `target`.
1535      *
1536      * Requirements:
1537      *
1538      * - the calling contract must have an ETH balance of at least `value`.
1539      * - the called Solidity function must be `payable`.
1540      *
1541      * _Available since v3.1._
1542      */
1543     function functionCallWithValue(
1544         address target,
1545         bytes memory data,
1546         uint256 value
1547     ) internal returns (bytes memory) {
1548         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1549     }
1550 
1551     /**
1552      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1553      * with `errorMessage` as a fallback revert reason when `target` reverts.
1554      *
1555      * _Available since v3.1._
1556      */
1557     function functionCallWithValue(
1558         address target,
1559         bytes memory data,
1560         uint256 value,
1561         string memory errorMessage
1562     ) internal returns (bytes memory) {
1563         require(address(this).balance >= value, "Address: insufficient balance for call");
1564         require(isContract(target), "Address: call to non-contract");
1565 
1566         (bool success, bytes memory returndata) = target.call{value: value}(data);
1567         return verifyCallResult(success, returndata, errorMessage);
1568     }
1569 
1570     /**
1571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1572      * but performing a static call.
1573      *
1574      * _Available since v3.3._
1575      */
1576     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1577         return functionStaticCall(target, data, "Address: low-level static call failed");
1578     }
1579 
1580     /**
1581      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1582      * but performing a static call.
1583      *
1584      * _Available since v3.3._
1585      */
1586     function functionStaticCall(
1587         address target,
1588         bytes memory data,
1589         string memory errorMessage
1590     ) internal view returns (bytes memory) {
1591         require(isContract(target), "Address: static call to non-contract");
1592 
1593         (bool success, bytes memory returndata) = target.staticcall(data);
1594         return verifyCallResult(success, returndata, errorMessage);
1595     }
1596 
1597     /**
1598      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1599      * but performing a delegate call.
1600      *
1601      * _Available since v3.4._
1602      */
1603     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1604         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1605     }
1606 
1607     /**
1608      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1609      * but performing a delegate call.
1610      *
1611      * _Available since v3.4._
1612      */
1613     function functionDelegateCall(
1614         address target,
1615         bytes memory data,
1616         string memory errorMessage
1617     ) internal returns (bytes memory) {
1618         require(isContract(target), "Address: delegate call to non-contract");
1619 
1620         (bool success, bytes memory returndata) = target.delegatecall(data);
1621         return verifyCallResult(success, returndata, errorMessage);
1622     }
1623 
1624     /**
1625      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1626      * revert reason using the provided one.
1627      *
1628      * _Available since v4.3._
1629      */
1630     function verifyCallResult(
1631         bool success,
1632         bytes memory returndata,
1633         string memory errorMessage
1634     ) internal pure returns (bytes memory) {
1635         if (success) {
1636             return returndata;
1637         } else {
1638             // Look for revert reason and bubble it up if present
1639             if (returndata.length > 0) {
1640                 // The easiest way to bubble the revert reason is using memory via assembly
1641 
1642                 assembly {
1643                     let returndata_size := mload(returndata)
1644                     revert(add(32, returndata), returndata_size)
1645                 }
1646             } else {
1647                 revert(errorMessage);
1648             }
1649         }
1650     }
1651 }
1652 
1653 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1654 
1655 
1656 // OpenZeppelin Contracts v4.3.2 (token/ERC721/IERC721Receiver.sol)
1657 
1658 pragma solidity ^0.8.0;
1659 
1660 /**
1661  * @title ERC721 token receiver interface
1662  * @dev Interface for any contract that wants to support safeTransfers
1663  * from ERC721 asset contracts.
1664  */
1665 interface IERC721Receiver {
1666     /**
1667      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1668      * by `operator` from `from`, this function is called.
1669      *
1670      * It must return its Solidity selector to confirm the token transfer.
1671      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1672      *
1673      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1674      */
1675     function onERC721Received(
1676         address operator,
1677         address from,
1678         uint256 tokenId,
1679         bytes calldata data
1680     ) external returns (bytes4);
1681 }
1682 
1683 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1684 
1685 
1686 // OpenZeppelin Contracts v4.3.2 (utils/introspection/IERC165.sol)
1687 
1688 pragma solidity ^0.8.0;
1689 
1690 /**
1691  * @dev Interface of the ERC165 standard, as defined in the
1692  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1693  *
1694  * Implementers can declare support of contract interfaces, which can then be
1695  * queried by others ({ERC165Checker}).
1696  *
1697  * For an implementation, see {ERC165}.
1698  */
1699 interface IERC165 {
1700     /**
1701      * @dev Returns true if this contract implements the interface defined by
1702      * `interfaceId`. See the corresponding
1703      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1704      * to learn more about how these ids are created.
1705      *
1706      * This function call must use less than 30 000 gas.
1707      */
1708     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1709 }
1710 
1711 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1712 
1713 
1714 // OpenZeppelin Contracts v4.3.2 (utils/introspection/ERC165.sol)
1715 
1716 pragma solidity ^0.8.0;
1717 
1718 
1719 /**
1720  * @dev Implementation of the {IERC165} interface.
1721  *
1722  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1723  * for the additional interface id that will be supported. For example:
1724  *
1725  * ```solidity
1726  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1727  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1728  * }
1729  * ```
1730  *
1731  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1732  */
1733 abstract contract ERC165 is IERC165 {
1734     /**
1735      * @dev See {IERC165-supportsInterface}.
1736      */
1737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1738         return interfaceId == type(IERC165).interfaceId;
1739     }
1740 }
1741 
1742 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1743 
1744 
1745 // OpenZeppelin Contracts v4.3.2 (token/ERC721/IERC721.sol)
1746 
1747 pragma solidity ^0.8.0;
1748 
1749 
1750 /**
1751  * @dev Required interface of an ERC721 compliant contract.
1752  */
1753 interface IERC721 is IERC165 {
1754     /**
1755      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1756      */
1757     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1758 
1759     /**
1760      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1761      */
1762     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1763 
1764     /**
1765      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1766      */
1767     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1768 
1769     /**
1770      * @dev Returns the number of tokens in ``owner``'s account.
1771      */
1772     function balanceOf(address owner) external view returns (uint256 balance);
1773 
1774     /**
1775      * @dev Returns the owner of the `tokenId` token.
1776      *
1777      * Requirements:
1778      *
1779      * - `tokenId` must exist.
1780      */
1781     function ownerOf(uint256 tokenId) external view returns (address owner);
1782 
1783     /**
1784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1786      *
1787      * Requirements:
1788      *
1789      * - `from` cannot be the zero address.
1790      * - `to` cannot be the zero address.
1791      * - `tokenId` token must exist and be owned by `from`.
1792      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1794      *
1795      * Emits a {Transfer} event.
1796      */
1797     function safeTransferFrom(
1798         address from,
1799         address to,
1800         uint256 tokenId
1801     ) external;
1802 
1803     /**
1804      * @dev Transfers `tokenId` token from `from` to `to`.
1805      *
1806      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1807      *
1808      * Requirements:
1809      *
1810      * - `from` cannot be the zero address.
1811      * - `to` cannot be the zero address.
1812      * - `tokenId` token must be owned by `from`.
1813      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1814      *
1815      * Emits a {Transfer} event.
1816      */
1817     function transferFrom(
1818         address from,
1819         address to,
1820         uint256 tokenId
1821     ) external;
1822 
1823     /**
1824      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1825      * The approval is cleared when the token is transferred.
1826      *
1827      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1828      *
1829      * Requirements:
1830      *
1831      * - The caller must own the token or be an approved operator.
1832      * - `tokenId` must exist.
1833      *
1834      * Emits an {Approval} event.
1835      */
1836     function approve(address to, uint256 tokenId) external;
1837 
1838     /**
1839      * @dev Returns the account approved for `tokenId` token.
1840      *
1841      * Requirements:
1842      *
1843      * - `tokenId` must exist.
1844      */
1845     function getApproved(uint256 tokenId) external view returns (address operator);
1846 
1847     /**
1848      * @dev Approve or remove `operator` as an operator for the caller.
1849      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1850      *
1851      * Requirements:
1852      *
1853      * - The `operator` cannot be the caller.
1854      *
1855      * Emits an {ApprovalForAll} event.
1856      */
1857     function setApprovalForAll(address operator, bool _approved) external;
1858 
1859     /**
1860      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1861      *
1862      * See {setApprovalForAll}
1863      */
1864     function isApprovedForAll(address owner, address operator) external view returns (bool);
1865 
1866     /**
1867      * @dev Safely transfers `tokenId` token from `from` to `to`.
1868      *
1869      * Requirements:
1870      *
1871      * - `from` cannot be the zero address.
1872      * - `to` cannot be the zero address.
1873      * - `tokenId` token must exist and be owned by `from`.
1874      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1875      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1876      *
1877      * Emits a {Transfer} event.
1878      */
1879     function safeTransferFrom(
1880         address from,
1881         address to,
1882         uint256 tokenId,
1883         bytes calldata data
1884     ) external;
1885 }
1886 
1887 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1888 
1889 
1890 // OpenZeppelin Contracts v4.3.2 (token/ERC721/extensions/IERC721Enumerable.sol)
1891 
1892 pragma solidity ^0.8.0;
1893 
1894 
1895 /**
1896  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1897  * @dev See https://eips.ethereum.org/EIPS/eip-721
1898  */
1899 interface IERC721Enumerable is IERC721 {
1900     /**
1901      * @dev Returns the total amount of tokens stored by the contract.
1902      */
1903     function totalSupply() external view returns (uint256);
1904 
1905     /**
1906      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1907      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1908      */
1909     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1910 
1911     /**
1912      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1913      * Use along with {totalSupply} to enumerate all tokens.
1914      */
1915     function tokenByIndex(uint256 index) external view returns (uint256);
1916 }
1917 
1918 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1919 
1920 
1921 // OpenZeppelin Contracts v4.3.2 (token/ERC721/extensions/IERC721Metadata.sol)
1922 
1923 pragma solidity ^0.8.0;
1924 
1925 
1926 /**
1927  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1928  * @dev See https://eips.ethereum.org/EIPS/eip-721
1929  */
1930 interface IERC721Metadata is IERC721 {
1931     /**
1932      * @dev Returns the token collection name.
1933      */
1934     function name() external view returns (string memory);
1935 
1936     /**
1937      * @dev Returns the token collection symbol.
1938      */
1939     function symbol() external view returns (string memory);
1940 
1941     /**
1942      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1943      */
1944     function tokenURI(uint256 tokenId) external view returns (string memory);
1945 }
1946 
1947 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1948 
1949 
1950 // OpenZeppelin Contracts v4.3.2 (token/ERC721/ERC721.sol)
1951 
1952 pragma solidity ^0.8.0;
1953 
1954 
1955 
1956 
1957 
1958 
1959 
1960 
1961 /**
1962  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1963  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1964  * {ERC721Enumerable}.
1965  */
1966 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1967     using Address for address;
1968     using Strings for uint256;
1969 
1970     // Token name
1971     string private _name;
1972 
1973     // Token symbol
1974     string private _symbol;
1975 
1976     // Mapping from token ID to owner address
1977     mapping(uint256 => address) private _owners;
1978 
1979     // Mapping owner address to token count
1980     mapping(address => uint256) private _balances;
1981 
1982     // Mapping from token ID to approved address
1983     mapping(uint256 => address) private _tokenApprovals;
1984 
1985     // Mapping from owner to operator approvals
1986     mapping(address => mapping(address => bool)) private _operatorApprovals;
1987 
1988     /**
1989      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1990      */
1991     constructor(string memory name_, string memory symbol_) {
1992         _name = name_;
1993         _symbol = symbol_;
1994     }
1995 
1996     /**
1997      * @dev See {IERC165-supportsInterface}.
1998      */
1999     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2000         return
2001             interfaceId == type(IERC721).interfaceId ||
2002             interfaceId == type(IERC721Metadata).interfaceId ||
2003             super.supportsInterface(interfaceId);
2004     }
2005 
2006     /**
2007      * @dev See {IERC721-balanceOf}.
2008      */
2009     function balanceOf(address owner) public view virtual override returns (uint256) {
2010         require(owner != address(0), "ERC721: balance query for the zero address");
2011         return _balances[owner];
2012     }
2013 
2014     /**
2015      * @dev See {IERC721-ownerOf}.
2016      */
2017     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2018         address owner = _owners[tokenId];
2019         require(owner != address(0), "ERC721: owner query for nonexistent token");
2020         return owner;
2021     }
2022 
2023     /**
2024      * @dev See {IERC721Metadata-name}.
2025      */
2026     function name() public view virtual override returns (string memory) {
2027         return _name;
2028     }
2029 
2030     /**
2031      * @dev See {IERC721Metadata-symbol}.
2032      */
2033     function symbol() public view virtual override returns (string memory) {
2034         return _symbol;
2035     }
2036 
2037     /**
2038      * @dev See {IERC721Metadata-tokenURI}.
2039      */
2040     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2041         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2042 
2043         string memory baseURI = _baseURI();
2044         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2045     }
2046 
2047     /**
2048      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2049      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2050      * by default, can be overriden in child contracts.
2051      */
2052     function _baseURI() internal view virtual returns (string memory) {
2053         return "";
2054     }
2055 
2056     /**
2057      * @dev See {IERC721-approve}.
2058      */
2059     function approve(address to, uint256 tokenId) public virtual override {
2060         address owner = ERC721.ownerOf(tokenId);
2061         require(to != owner, "ERC721: approval to current owner");
2062 
2063         require(
2064             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2065             "ERC721: approve caller is not owner nor approved for all"
2066         );
2067 
2068         _approve(to, tokenId);
2069     }
2070 
2071     /**
2072      * @dev See {IERC721-getApproved}.
2073      */
2074     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2075         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2076 
2077         return _tokenApprovals[tokenId];
2078     }
2079 
2080     /**
2081      * @dev See {IERC721-setApprovalForAll}.
2082      */
2083     function setApprovalForAll(address operator, bool approved) public virtual override {
2084         _setApprovalForAll(_msgSender(), operator, approved);
2085     }
2086 
2087     /**
2088      * @dev See {IERC721-isApprovedForAll}.
2089      */
2090     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2091         return _operatorApprovals[owner][operator];
2092     }
2093 
2094     /**
2095      * @dev See {IERC721-transferFrom}.
2096      */
2097     function transferFrom(
2098         address from,
2099         address to,
2100         uint256 tokenId
2101     ) public virtual override {
2102         //solhint-disable-next-line max-line-length
2103         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2104 
2105         _transfer(from, to, tokenId);
2106     }
2107 
2108     /**
2109      * @dev See {IERC721-safeTransferFrom}.
2110      */
2111     function safeTransferFrom(
2112         address from,
2113         address to,
2114         uint256 tokenId
2115     ) public virtual override {
2116         safeTransferFrom(from, to, tokenId, "");
2117     }
2118 
2119     /**
2120      * @dev See {IERC721-safeTransferFrom}.
2121      */
2122     function safeTransferFrom(
2123         address from,
2124         address to,
2125         uint256 tokenId,
2126         bytes memory _data
2127     ) public virtual override {
2128         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2129         _safeTransfer(from, to, tokenId, _data);
2130     }
2131 
2132     /**
2133      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2134      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2135      *
2136      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2137      *
2138      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2139      * implement alternative mechanisms to perform token transfer, such as signature-based.
2140      *
2141      * Requirements:
2142      *
2143      * - `from` cannot be the zero address.
2144      * - `to` cannot be the zero address.
2145      * - `tokenId` token must exist and be owned by `from`.
2146      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2147      *
2148      * Emits a {Transfer} event.
2149      */
2150     function _safeTransfer(
2151         address from,
2152         address to,
2153         uint256 tokenId,
2154         bytes memory _data
2155     ) internal virtual {
2156         _transfer(from, to, tokenId);
2157         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2158     }
2159 
2160     /**
2161      * @dev Returns whether `tokenId` exists.
2162      *
2163      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2164      *
2165      * Tokens start existing when they are minted (`_mint`),
2166      * and stop existing when they are burned (`_burn`).
2167      */
2168     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2169         return _owners[tokenId] != address(0);
2170     }
2171 
2172     /**
2173      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2174      *
2175      * Requirements:
2176      *
2177      * - `tokenId` must exist.
2178      */
2179     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2180         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2181         address owner = ERC721.ownerOf(tokenId);
2182         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2183     }
2184 
2185     /**
2186      * @dev Safely mints `tokenId` and transfers it to `to`.
2187      *
2188      * Requirements:
2189      *
2190      * - `tokenId` must not exist.
2191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2192      *
2193      * Emits a {Transfer} event.
2194      */
2195     function _safeMint(address to, uint256 tokenId) internal virtual {
2196         _safeMint(to, tokenId, "");
2197     }
2198 
2199     /**
2200      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2201      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2202      */
2203     function _safeMint(
2204         address to,
2205         uint256 tokenId,
2206         bytes memory _data
2207     ) internal virtual {
2208         _mint(to, tokenId);
2209         require(
2210             _checkOnERC721Received(address(0), to, tokenId, _data),
2211             "ERC721: transfer to non ERC721Receiver implementer"
2212         );
2213     }
2214 
2215     /**
2216      * @dev Mints `tokenId` and transfers it to `to`.
2217      *
2218      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2219      *
2220      * Requirements:
2221      *
2222      * - `tokenId` must not exist.
2223      * - `to` cannot be the zero address.
2224      *
2225      * Emits a {Transfer} event.
2226      */
2227     function _mint(address to, uint256 tokenId) internal virtual {
2228         require(to != address(0), "ERC721: mint to the zero address");
2229         require(!_exists(tokenId), "ERC721: token already minted");
2230 
2231         _beforeTokenTransfer(address(0), to, tokenId);
2232 
2233         _balances[to] += 1;
2234         _owners[tokenId] = to;
2235 
2236         emit Transfer(address(0), to, tokenId);
2237     }
2238 
2239     /**
2240      * @dev Destroys `tokenId`.
2241      * The approval is cleared when the token is burned.
2242      *
2243      * Requirements:
2244      *
2245      * - `tokenId` must exist.
2246      *
2247      * Emits a {Transfer} event.
2248      */
2249     function _burn(uint256 tokenId) internal virtual {
2250         address owner = ERC721.ownerOf(tokenId);
2251 
2252         _beforeTokenTransfer(owner, address(0), tokenId);
2253 
2254         // Clear approvals
2255         _approve(address(0), tokenId);
2256 
2257         _balances[owner] -= 1;
2258         delete _owners[tokenId];
2259 
2260         emit Transfer(owner, address(0), tokenId);
2261     }
2262 
2263     /**
2264      * @dev Transfers `tokenId` from `from` to `to`.
2265      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2266      *
2267      * Requirements:
2268      *
2269      * - `to` cannot be the zero address.
2270      * - `tokenId` token must be owned by `from`.
2271      *
2272      * Emits a {Transfer} event.
2273      */
2274     function _transfer(
2275         address from,
2276         address to,
2277         uint256 tokenId
2278     ) internal virtual {
2279         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2280         require(to != address(0), "ERC721: transfer to the zero address");
2281 
2282         _beforeTokenTransfer(from, to, tokenId);
2283 
2284         // Clear approvals from the previous owner
2285         _approve(address(0), tokenId);
2286 
2287         _balances[from] -= 1;
2288         _balances[to] += 1;
2289         _owners[tokenId] = to;
2290 
2291         emit Transfer(from, to, tokenId);
2292     }
2293 
2294     /**
2295      * @dev Approve `to` to operate on `tokenId`
2296      *
2297      * Emits a {Approval} event.
2298      */
2299     function _approve(address to, uint256 tokenId) internal virtual {
2300         _tokenApprovals[tokenId] = to;
2301         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2302     }
2303 
2304     /**
2305      * @dev Approve `operator` to operate on all of `owner` tokens
2306      *
2307      * Emits a {ApprovalForAll} event.
2308      */
2309     function _setApprovalForAll(
2310         address owner,
2311         address operator,
2312         bool approved
2313     ) internal virtual {
2314         require(owner != operator, "ERC721: approve to caller");
2315         _operatorApprovals[owner][operator] = approved;
2316         emit ApprovalForAll(owner, operator, approved);
2317     }
2318 
2319     /**
2320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2321      * The call is not executed if the target address is not a contract.
2322      *
2323      * @param from address representing the previous owner of the given token ID
2324      * @param to target address that will receive the tokens
2325      * @param tokenId uint256 ID of the token to be transferred
2326      * @param _data bytes optional data to send along with the call
2327      * @return bool whether the call correctly returned the expected magic value
2328      */
2329     function _checkOnERC721Received(
2330         address from,
2331         address to,
2332         uint256 tokenId,
2333         bytes memory _data
2334     ) private returns (bool) {
2335         if (to.isContract()) {
2336             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2337                 return retval == IERC721Receiver.onERC721Received.selector;
2338             } catch (bytes memory reason) {
2339                 if (reason.length == 0) {
2340                     revert("ERC721: transfer to non ERC721Receiver implementer");
2341                 } else {
2342                     assembly {
2343                         revert(add(32, reason), mload(reason))
2344                     }
2345                 }
2346             }
2347         } else {
2348             return true;
2349         }
2350     }
2351 
2352     /**
2353      * @dev Hook that is called before any token transfer. This includes minting
2354      * and burning.
2355      *
2356      * Calling conditions:
2357      *
2358      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2359      * transferred to `to`.
2360      * - When `from` is zero, `tokenId` will be minted for `to`.
2361      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2362      * - `from` and `to` are never both zero.
2363      *
2364      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2365      */
2366     function _beforeTokenTransfer(
2367         address from,
2368         address to,
2369         uint256 tokenId
2370     ) internal virtual {}
2371 }
2372 
2373 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2374 
2375 
2376 // OpenZeppelin Contracts v4.3.2 (token/ERC721/extensions/ERC721Enumerable.sol)
2377 
2378 pragma solidity ^0.8.0;
2379 
2380 
2381 
2382 /**
2383  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2384  * enumerability of all the token ids in the contract as well as all token ids owned by each
2385  * account.
2386  */
2387 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2388     // Mapping from owner to list of owned token IDs
2389     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2390 
2391     // Mapping from token ID to index of the owner tokens list
2392     mapping(uint256 => uint256) private _ownedTokensIndex;
2393 
2394     // Array with all token ids, used for enumeration
2395     uint256[] private _allTokens;
2396 
2397     // Mapping from token id to position in the allTokens array
2398     mapping(uint256 => uint256) private _allTokensIndex;
2399 
2400     /**
2401      * @dev See {IERC165-supportsInterface}.
2402      */
2403     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2404         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2405     }
2406 
2407     /**
2408      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2409      */
2410     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2411         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2412         return _ownedTokens[owner][index];
2413     }
2414 
2415     /**
2416      * @dev See {IERC721Enumerable-totalSupply}.
2417      */
2418     function totalSupply() public view virtual override returns (uint256) {
2419         return _allTokens.length;
2420     }
2421 
2422     /**
2423      * @dev See {IERC721Enumerable-tokenByIndex}.
2424      */
2425     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2426         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2427         return _allTokens[index];
2428     }
2429 
2430     /**
2431      * @dev Hook that is called before any token transfer. This includes minting
2432      * and burning.
2433      *
2434      * Calling conditions:
2435      *
2436      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2437      * transferred to `to`.
2438      * - When `from` is zero, `tokenId` will be minted for `to`.
2439      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2440      * - `from` cannot be the zero address.
2441      * - `to` cannot be the zero address.
2442      *
2443      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2444      */
2445     function _beforeTokenTransfer(
2446         address from,
2447         address to,
2448         uint256 tokenId
2449     ) internal virtual override {
2450         super._beforeTokenTransfer(from, to, tokenId);
2451 
2452         if (from == address(0)) {
2453             _addTokenToAllTokensEnumeration(tokenId);
2454         } else if (from != to) {
2455             _removeTokenFromOwnerEnumeration(from, tokenId);
2456         }
2457         if (to == address(0)) {
2458             _removeTokenFromAllTokensEnumeration(tokenId);
2459         } else if (to != from) {
2460             _addTokenToOwnerEnumeration(to, tokenId);
2461         }
2462     }
2463 
2464     /**
2465      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2466      * @param to address representing the new owner of the given token ID
2467      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2468      */
2469     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2470         uint256 length = ERC721.balanceOf(to);
2471         _ownedTokens[to][length] = tokenId;
2472         _ownedTokensIndex[tokenId] = length;
2473     }
2474 
2475     /**
2476      * @dev Private function to add a token to this extension's token tracking data structures.
2477      * @param tokenId uint256 ID of the token to be added to the tokens list
2478      */
2479     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2480         _allTokensIndex[tokenId] = _allTokens.length;
2481         _allTokens.push(tokenId);
2482     }
2483 
2484     /**
2485      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2486      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2487      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2488      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2489      * @param from address representing the previous owner of the given token ID
2490      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2491      */
2492     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2493         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2494         // then delete the last slot (swap and pop).
2495 
2496         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2497         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2498 
2499         // When the token to delete is the last token, the swap operation is unnecessary
2500         if (tokenIndex != lastTokenIndex) {
2501             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2502 
2503             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2504             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2505         }
2506 
2507         // This also deletes the contents at the last position of the array
2508         delete _ownedTokensIndex[tokenId];
2509         delete _ownedTokens[from][lastTokenIndex];
2510     }
2511 
2512     /**
2513      * @dev Private function to remove a token from this extension's token tracking data structures.
2514      * This has O(1) time complexity, but alters the order of the _allTokens array.
2515      * @param tokenId uint256 ID of the token to be removed from the tokens list
2516      */
2517     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2518         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2519         // then delete the last slot (swap and pop).
2520 
2521         uint256 lastTokenIndex = _allTokens.length - 1;
2522         uint256 tokenIndex = _allTokensIndex[tokenId];
2523 
2524         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2525         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2526         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2527         uint256 lastTokenId = _allTokens[lastTokenIndex];
2528 
2529         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2530         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2531 
2532         // This also deletes the contents at the last position of the array
2533         delete _allTokensIndex[tokenId];
2534         _allTokens.pop();
2535     }
2536 }
2537 
2538 // File: Artifacts/cosmicLabs.sol
2539 
2540 pragma solidity 0.8.7;
2541 
2542 
2543 
2544 
2545 
2546 
2547 
2548 
2549 
2550 /// SPDX-License-Identifier: UNLICENSED
2551 
2552 contract CosmicLabs is ERC721Enumerable, IERC721Receiver, Ownable {
2553    
2554    using Strings for uint256;
2555    using EnumerableSet for EnumerableSet.UintSet;
2556    
2557     CosmicToken public cosmictoken;
2558     
2559     using Counters for Counters.Counter;
2560     Counters.Counter private _tokenIdTracker;
2561     
2562     string public baseURI;
2563     string public baseExtension = ".json";
2564 
2565     
2566     uint public maxGenesisTx = 4;
2567     uint public maxDuckTx = 20;
2568     
2569     
2570     uint public maxSupply = 9000;
2571     uint public genesisSupply = 1000;
2572     
2573     uint256 public price = 0.05 ether;
2574    
2575 
2576     bool public GensisSaleOpen = true;
2577     bool public GenesisFreeMintOpen = false;
2578     bool public DuckMintOpen = false;
2579     
2580     
2581     
2582     modifier isSaleOpen
2583     {
2584          require(GensisSaleOpen == true);
2585          _;
2586     }
2587     
2588     modifier isFreeMintOpen
2589     {
2590          require(GenesisFreeMintOpen == true);
2591          _;
2592     }
2593     
2594     modifier isDuckMintOpen
2595     {
2596          require(DuckMintOpen == true);
2597          _;
2598     }
2599     
2600 
2601     
2602     function switchFromFreeToDuckMint() public onlyOwner
2603     {
2604         GenesisFreeMintOpen = false;
2605         DuckMintOpen = true;
2606     }
2607     
2608     
2609     
2610     event mint(address to, uint total);
2611     event withdraw(uint total);
2612     event giveawayNft(address to, uint tokenID);
2613     
2614     mapping(address => uint256) public balanceOG;
2615     
2616     mapping(address => uint256) public maxWalletGenesisTX;
2617     mapping(address => uint256) public maxWalletDuckTX;
2618     
2619     mapping(address => EnumerableSet.UintSet) private _deposits;
2620     
2621     
2622     mapping(uint256 => uint256) public _deposit_blocks;
2623     
2624     mapping(address => bool) public addressStaked;
2625     
2626     //ID - Days staked;
2627     mapping(uint256 => uint256) public IDvsDaysStaked;
2628     mapping (address => uint256) public whitelistMintAmount;
2629     
2630 
2631    address internal communityWallet = 0xea25545d846ecF4999C2875bC77dE5B5151Fa633;
2632    
2633     constructor(string memory _initBaseURI) ERC721("Cosmic Labs", "CLABS")
2634     {
2635         setBaseURI(_initBaseURI);
2636     }
2637    
2638    
2639     function setPrice(uint256 newPrice) external onlyOwner {
2640         price = newPrice;
2641     }
2642    
2643     
2644     function setYieldToken(address _yield) external onlyOwner {
2645 		cosmictoken = CosmicToken(_yield);
2646 	}
2647 	
2648 	function totalToken() public view returns (uint256) {
2649             return _tokenIdTracker.current();
2650     }
2651     
2652     modifier communityWalletOnly
2653     {
2654          require(msg.sender == communityWallet);
2655          _;
2656     }
2657     	
2658 	function communityDuckMint(uint256 amountForAirdrops) public onlyOwner
2659 	{
2660         for(uint256 i; i<amountForAirdrops; i++)
2661         {
2662              _tokenIdTracker.increment();
2663             _safeMint(communityWallet, totalToken());
2664         }
2665 	}
2666 
2667     function GenesisSale(uint8 mintTotal) public payable isSaleOpen
2668     {
2669         uint256 totalMinted = maxWalletGenesisTX[msg.sender];
2670         totalMinted = totalMinted + mintTotal;
2671         
2672         require(mintTotal >= 1 && mintTotal <= maxGenesisTx, "Mint Amount Incorrect");
2673         require(totalToken() < genesisSupply, "SOLD OUT!");
2674         require(maxWalletGenesisTX[msg.sender] <= maxGenesisTx, "You've maxed your limit!");
2675         require(msg.value >= price * mintTotal, "Minting a Genesis Costs 0.05 Ether Each!");
2676         require(totalMinted <= maxGenesisTx, "You'll surpass your limit!");
2677         
2678         
2679         for(uint8 i=0;i<mintTotal;i++)
2680         {
2681             whitelistMintAmount[msg.sender] += 1;
2682             maxWalletGenesisTX[msg.sender] += 1;
2683             _tokenIdTracker.increment();
2684             _safeMint(msg.sender, totalToken());
2685             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
2686             emit mint(msg.sender, totalToken());
2687         }
2688         
2689         if(totalToken() == genesisSupply)
2690         {
2691             GensisSaleOpen = false;
2692             GenesisFreeMintOpen = true;
2693         }
2694        
2695     }	
2696 
2697     function GenesisFreeMint(uint8 mintTotal)public payable isFreeMintOpen
2698     {
2699         require(whitelistMintAmount[msg.sender] > 0, "You don't have any free mints!");
2700         require(totalToken() < maxSupply, "SOLD OUT!");
2701         require(mintTotal <= whitelistMintAmount[msg.sender], "You are passing your limit!");
2702         
2703         for(uint8 i=0;i<mintTotal;i++)
2704         {
2705             whitelistMintAmount[msg.sender] -= 1;
2706             _tokenIdTracker.increment();
2707             _safeMint(msg.sender, totalToken());
2708             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
2709             emit mint(msg.sender, totalToken());
2710         }
2711     }
2712 	
2713 
2714     function DuckSale(uint8 mintTotal)public payable isDuckMintOpen
2715     {
2716         uint256 totalMinted = maxWalletDuckTX[msg.sender];
2717         totalMinted = totalMinted + mintTotal;        
2718     
2719         require(mintTotal >= 1 && mintTotal <= maxDuckTx, "Mint Amount Incorrect");
2720         require(msg.value >= price * mintTotal, "Minting a Duck Costs 0.05 Ether Each!");
2721         require(totalToken() < maxSupply, "SOLD OUT!");
2722         require(maxWalletDuckTX[msg.sender] <= maxDuckTx, "You've maxed your limit!");
2723         require(totalMinted <= maxDuckTx, "You'll surpass your limit!");
2724         
2725         for(uint8 i=0;i<mintTotal;i++)
2726         {
2727             maxWalletDuckTX[msg.sender] += 1;
2728             _tokenIdTracker.increment();
2729             _safeMint(msg.sender, totalToken());
2730             cosmictoken.updateRewardOnMint(msg.sender, totalToken());
2731             emit mint(msg.sender, totalToken());
2732         }
2733         
2734         if(totalToken() == maxSupply)
2735         {
2736             DuckMintOpen = false;
2737         }
2738     }
2739    
2740    
2741     function airdropNft(address airdropPatricipent, uint16 tokenID) public payable communityWalletOnly
2742     {
2743         _transfer(msg.sender, airdropPatricipent, tokenID);
2744         emit giveawayNft(airdropPatricipent, tokenID);
2745     }
2746     
2747     function airdropMany(address[] memory airdropPatricipents) public payable communityWalletOnly
2748     {
2749         uint256[] memory tempWalletOfUser = this.walletOfOwner(msg.sender);
2750         
2751         require(tempWalletOfUser.length >= airdropPatricipents.length, "You dont have enough tokens to airdrop all!");
2752         
2753        for(uint256 i=0; i<airdropPatricipents.length; i++)
2754        {
2755             _transfer(msg.sender, airdropPatricipents[i], tempWalletOfUser[i]);
2756             emit giveawayNft(airdropPatricipents[i], tempWalletOfUser[i]);
2757        }
2758 
2759     }    
2760     
2761     function withdrawContractEther(address payable recipient) external onlyOwner
2762     {
2763         emit withdraw(getBalance());
2764         recipient.transfer(getBalance());
2765     }
2766     function getBalance() public view returns(uint)
2767     {
2768         return address(this).balance;
2769     }
2770    
2771     function _baseURI() internal view virtual override returns (string memory) {
2772         return baseURI;
2773     }
2774    
2775     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2776         baseURI = _newBaseURI;
2777     }
2778    
2779     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2780     {
2781         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2782 
2783         string memory currentBaseURI = _baseURI();
2784         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2785     }
2786     
2787 	function getReward(uint256 CalculatedPayout) internal
2788 	{
2789 		cosmictoken.getReward(msg.sender, CalculatedPayout);
2790 	}    
2791     
2792     //Staking Functions
2793     function depositStake(uint256[] calldata tokenIds) external {
2794         
2795         require(isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
2796         
2797         
2798         for (uint256 i; i < tokenIds.length; i++) {
2799             safeTransferFrom(
2800                 msg.sender,
2801                 address(this),
2802                 tokenIds[i],
2803                 ''
2804             );
2805             
2806             _deposits[msg.sender].add(tokenIds[i]);
2807             addressStaked[msg.sender] = true;
2808             
2809             
2810             _deposit_blocks[tokenIds[i]] = block.timestamp;
2811             
2812 
2813             IDvsDaysStaked[tokenIds[i]] = block.timestamp;
2814         }
2815         
2816     }
2817     function withdrawStake(uint256[] calldata tokenIds) external {
2818         
2819         require(isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
2820         
2821         for (uint256 i; i < tokenIds.length; i++) {
2822             require(
2823                 _deposits[msg.sender].contains(tokenIds[i]),
2824                 'Token not deposited'
2825             );
2826             
2827             cosmictoken.getReward(msg.sender,totalRewardsToPay(tokenIds[i]));
2828             
2829             _deposits[msg.sender].remove(tokenIds[i]);
2830              _deposit_blocks[tokenIds[i]] = 0;
2831             addressStaked[msg.sender] = false;
2832             IDvsDaysStaked[tokenIds[i]] = block.timestamp;
2833             
2834             this.safeTransferFrom(
2835                 address(this),
2836                 msg.sender,
2837                 tokenIds[i],
2838                 ''
2839             );
2840         }
2841     }
2842 
2843     
2844     function viewRewards() external view returns (uint256)
2845     {
2846         uint256 payout = 0;
2847         
2848         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
2849         {
2850             payout = payout + totalRewardsToPay(_deposits[msg.sender].at(i));
2851         }
2852         return payout;
2853     }
2854     
2855     function claimRewards() external
2856     {
2857         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
2858         {
2859             cosmictoken.getReward(msg.sender, totalRewardsToPay(_deposits[msg.sender].at(i)));
2860             IDvsDaysStaked[_deposits[msg.sender].at(i)] = block.timestamp;
2861         }
2862     }   
2863     
2864     function totalRewardsToPay(uint256 tokenId) internal view returns(uint256)
2865     {
2866         uint256 payout = 0;
2867         
2868         if(tokenId > 0 && tokenId <= genesisSupply)
2869         {
2870             payout = howManyDaysStaked(tokenId) * 20;
2871         }
2872         else if (tokenId > genesisSupply && tokenId <= maxSupply)
2873         {
2874             payout = howManyDaysStaked(tokenId) * 5;
2875         }
2876         
2877         return payout;
2878     }
2879     
2880     function howManyDaysStaked(uint256 tokenId) public view returns(uint256)
2881     {
2882         
2883         require(
2884             _deposits[msg.sender].contains(tokenId),
2885             'Token not deposited'
2886         );
2887         
2888         uint256 returndays;
2889         uint256 timeCalc = block.timestamp - IDvsDaysStaked[tokenId];
2890         returndays = timeCalc / 86400;
2891        
2892         return returndays;
2893     }
2894     
2895     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
2896         uint256 tokenCount = balanceOf(_owner);
2897 
2898         uint256[] memory tokensId = new uint256[](tokenCount);
2899         for (uint256 i = 0; i < tokenCount; i++) {
2900             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2901         }
2902 
2903         return tokensId;
2904     }
2905     
2906     function returnStakedTokens() public view returns (uint256[] memory)
2907     {
2908         return _deposits[msg.sender].values();
2909     }
2910     
2911     function totalTokensInWallet() public view returns(uint256)
2912     {
2913         return cosmictoken.balanceOf(msg.sender);
2914     }
2915     
2916    
2917     function onERC721Received(
2918         address,
2919         address,
2920         uint256,
2921         bytes calldata
2922     ) external pure override returns (bytes4) {
2923         return IERC721Receiver.onERC721Received.selector;
2924     }
2925 }