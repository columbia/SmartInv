1 // ███████╗ ██████╗ ██████╗ ████████╗ ██████╗  ██████╗ ██╗        ██╗ ██████╗ 
2 // ██╔════╝██╔════╝██╔═══██╗╚══██╔══╝██╔═══██╗██╔═══██╗██║        ██║██╔═══██╗
3 // █████╗  ██║     ██║   ██║   ██║   ██║   ██║██║   ██║██║        ██║██║   ██║
4 // ██╔══╝  ██║     ██║   ██║   ██║   ██║   ██║██║   ██║██║        ██║██║   ██║
5 // ███████╗╚██████╗╚██████╔╝   ██║   ╚██████╔╝╚██████╔╝███████╗██╗██║╚██████╔╝
6 // ╚══════╝ ╚═════╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝╚═╝ ╚═════╝ 
7                                                                            
8                                                                       
9 // File: @openzeppelin\contracts\utils\math\SafeMath.sol
10 
11 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 // CAUTION
16 // This version of SafeMath should only be used with Solidity 0.8 or later,
17 // because it relies on the compiler's built in overflow checks.
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations.
21  *
22  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
23  * now has built in overflow checking.
24  */
25 library SafeMath {
26     /**
27      * @dev Returns the addition of two unsigned integers, with an overflow flag.
28      *
29      * _Available since v3.4._
30      */
31     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {
33             uint256 c = a + b;
34             if (c < a) return (false, 0);
35             return (true, c);
36         }
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b > a) return (false, 0);
47             return (true, a - b);
48         }
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
53      *
54      * _Available since v3.4._
55      */
56     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59             // benefit is lost if 'b' is also tested.
60             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
61             if (a == 0) return (true, 0);
62             uint256 c = a * b;
63             if (c / a != b) return (false, 0);
64             return (true, c);
65         }
66     }
67 
68     /**
69      * @dev Returns the division of two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b == 0) return (false, 0);
76             return (true, a / b);
77         }
78     }
79 
80     /**
81      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
82      *
83      * _Available since v3.4._
84      */
85     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             if (b == 0) return (false, 0);
88             return (true, a % b);
89         }
90     }
91 
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a + b;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      *
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a - b;
118     }
119 
120     /**
121      * @dev Returns the multiplication of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `*` operator.
125      *
126      * Requirements:
127      *
128      * - Multiplication cannot overflow.
129      */
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a * b;
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers, reverting on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator.
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function div(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a / b;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * reverting when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         return a % b;
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * CAUTION: This function is deprecated because it requires allocating memory for the error
169      * message unnecessarily. For custom revert reasons use {trySub}.
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         unchecked {
179             require(b <= a, errorMessage);
180             return a - b;
181         }
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a % b;
222         }
223     }
224 }
225 
226 // File: @openzeppelin\contracts\utils\structs\EnumerableSet.sol
227 
228 // OpenZeppelin Contracts (last updated v4.9.0) (utils/structs/EnumerableSet.sol)
229 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Library for managing
235  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
236  * types.
237  *
238  * Sets have the following properties:
239  *
240  * - Elements are added, removed, and checked for existence in constant time
241  * (O(1)).
242  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
243  *
244  * ```solidity
245  * contract Example {
246  *     // Add the library methods
247  *     using EnumerableSet for EnumerableSet.AddressSet;
248  *
249  *     // Declare a set state variable
250  *     EnumerableSet.AddressSet private mySet;
251  * }
252  * ```
253  *
254  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
255  * and `uint256` (`UintSet`) are supported.
256  *
257  * [WARNING]
258  * ====
259  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
260  * unusable.
261  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
262  *
263  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
264  * array of EnumerableSet.
265  * ====
266  */
267 library EnumerableSet {
268     // To implement this library for multiple types with as little code
269     // repetition as possible, we write it in terms of a generic Set type with
270     // bytes32 values.
271     // The Set implementation uses private functions, and user-facing
272     // implementations (such as AddressSet) are just wrappers around the
273     // underlying Set.
274     // This means that we can only create new EnumerableSets for types that fit
275     // in bytes32.
276 
277     struct Set {
278         // Storage of set values
279         bytes32[] _values;
280         // Position of the value in the `values` array, plus 1 because index 0
281         // means a value is not in the set.
282         mapping(bytes32 => uint256) _indexes;
283     }
284 
285     /**
286      * @dev Add a value to a set. O(1).
287      *
288      * Returns true if the value was added to the set, that is if it was not
289      * already present.
290      */
291     function _add(Set storage set, bytes32 value) private returns (bool) {
292         if (!_contains(set, value)) {
293             set._values.push(value);
294             // The value is stored at length-1, but we add 1 to all indexes
295             // and use 0 as a sentinel value
296             set._indexes[value] = set._values.length;
297             return true;
298         } else {
299             return false;
300         }
301     }
302 
303     /**
304      * @dev Removes a value from a set. O(1).
305      *
306      * Returns true if the value was removed from the set, that is if it was
307      * present.
308      */
309     function _remove(Set storage set, bytes32 value) private returns (bool) {
310         // We read and store the value's index to prevent multiple reads from the same storage slot
311         uint256 valueIndex = set._indexes[value];
312 
313         if (valueIndex != 0) {
314             // Equivalent to contains(set, value)
315             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
316             // the array, and then remove the last element (sometimes called as 'swap and pop').
317             // This modifies the order of the array, as noted in {at}.
318 
319             uint256 toDeleteIndex = valueIndex - 1;
320             uint256 lastIndex = set._values.length - 1;
321 
322             if (lastIndex != toDeleteIndex) {
323                 bytes32 lastValue = set._values[lastIndex];
324 
325                 // Move the last value to the index where the value to delete is
326                 set._values[toDeleteIndex] = lastValue;
327                 // Update the index for the moved value
328                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
329             }
330 
331             // Delete the slot where the moved value was stored
332             set._values.pop();
333 
334             // Delete the index for the deleted slot
335             delete set._indexes[value];
336 
337             return true;
338         } else {
339             return false;
340         }
341     }
342 
343     /**
344      * @dev Returns true if the value is in the set. O(1).
345      */
346     function _contains(Set storage set, bytes32 value) private view returns (bool) {
347         return set._indexes[value] != 0;
348     }
349 
350     /**
351      * @dev Returns the number of values on the set. O(1).
352      */
353     function _length(Set storage set) private view returns (uint256) {
354         return set._values.length;
355     }
356 
357     /**
358      * @dev Returns the value stored at position `index` in the set. O(1).
359      *
360      * Note that there are no guarantees on the ordering of values inside the
361      * array, and it may change when more values are added or removed.
362      *
363      * Requirements:
364      *
365      * - `index` must be strictly less than {length}.
366      */
367     function _at(Set storage set, uint256 index) private view returns (bytes32) {
368         return set._values[index];
369     }
370 
371     /**
372      * @dev Return the entire set in an array
373      *
374      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
375      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
376      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
377      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
378      */
379     function _values(Set storage set) private view returns (bytes32[] memory) {
380         return set._values;
381     }
382 
383     // Bytes32Set
384 
385     struct Bytes32Set {
386         Set _inner;
387     }
388 
389     /**
390      * @dev Add a value to a set. O(1).
391      *
392      * Returns true if the value was added to the set, that is if it was not
393      * already present.
394      */
395     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
396         return _add(set._inner, value);
397     }
398 
399     /**
400      * @dev Removes a value from a set. O(1).
401      *
402      * Returns true if the value was removed from the set, that is if it was
403      * present.
404      */
405     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
406         return _remove(set._inner, value);
407     }
408 
409     /**
410      * @dev Returns true if the value is in the set. O(1).
411      */
412     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
413         return _contains(set._inner, value);
414     }
415 
416     /**
417      * @dev Returns the number of values in the set. O(1).
418      */
419     function length(Bytes32Set storage set) internal view returns (uint256) {
420         return _length(set._inner);
421     }
422 
423     /**
424      * @dev Returns the value stored at position `index` in the set. O(1).
425      *
426      * Note that there are no guarantees on the ordering of values inside the
427      * array, and it may change when more values are added or removed.
428      *
429      * Requirements:
430      *
431      * - `index` must be strictly less than {length}.
432      */
433     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
434         return _at(set._inner, index);
435     }
436 
437     /**
438      * @dev Return the entire set in an array
439      *
440      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
441      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
442      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
443      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
444      */
445     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
446         bytes32[] memory store = _values(set._inner);
447         bytes32[] memory result;
448 
449         /// @solidity memory-safe-assembly
450         assembly {
451             result := store
452         }
453 
454         return result;
455     }
456 
457     // AddressSet
458 
459     struct AddressSet {
460         Set _inner;
461     }
462 
463     /**
464      * @dev Add a value to a set. O(1).
465      *
466      * Returns true if the value was added to the set, that is if it was not
467      * already present.
468      */
469     function add(AddressSet storage set, address value) internal returns (bool) {
470         return _add(set._inner, bytes32(uint256(uint160(value))));
471     }
472 
473     /**
474      * @dev Removes a value from a set. O(1).
475      *
476      * Returns true if the value was removed from the set, that is if it was
477      * present.
478      */
479     function remove(AddressSet storage set, address value) internal returns (bool) {
480         return _remove(set._inner, bytes32(uint256(uint160(value))));
481     }
482 
483     /**
484      * @dev Returns true if the value is in the set. O(1).
485      */
486     function contains(AddressSet storage set, address value) internal view returns (bool) {
487         return _contains(set._inner, bytes32(uint256(uint160(value))));
488     }
489 
490     /**
491      * @dev Returns the number of values in the set. O(1).
492      */
493     function length(AddressSet storage set) internal view returns (uint256) {
494         return _length(set._inner);
495     }
496 
497     /**
498      * @dev Returns the value stored at position `index` in the set. O(1).
499      *
500      * Note that there are no guarantees on the ordering of values inside the
501      * array, and it may change when more values are added or removed.
502      *
503      * Requirements:
504      *
505      * - `index` must be strictly less than {length}.
506      */
507     function at(AddressSet storage set, uint256 index) internal view returns (address) {
508         return address(uint160(uint256(_at(set._inner, index))));
509     }
510 
511     /**
512      * @dev Return the entire set in an array
513      *
514      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
515      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
516      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
517      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
518      */
519     function values(AddressSet storage set) internal view returns (address[] memory) {
520         bytes32[] memory store = _values(set._inner);
521         address[] memory result;
522 
523         /// @solidity memory-safe-assembly
524         assembly {
525             result := store
526         }
527 
528         return result;
529     }
530 
531     // UintSet
532 
533     struct UintSet {
534         Set _inner;
535     }
536 
537     /**
538      * @dev Add a value to a set. O(1).
539      *
540      * Returns true if the value was added to the set, that is if it was not
541      * already present.
542      */
543     function add(UintSet storage set, uint256 value) internal returns (bool) {
544         return _add(set._inner, bytes32(value));
545     }
546 
547     /**
548      * @dev Removes a value from a set. O(1).
549      *
550      * Returns true if the value was removed from the set, that is if it was
551      * present.
552      */
553     function remove(UintSet storage set, uint256 value) internal returns (bool) {
554         return _remove(set._inner, bytes32(value));
555     }
556 
557     /**
558      * @dev Returns true if the value is in the set. O(1).
559      */
560     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
561         return _contains(set._inner, bytes32(value));
562     }
563 
564     /**
565      * @dev Returns the number of values in the set. O(1).
566      */
567     function length(UintSet storage set) internal view returns (uint256) {
568         return _length(set._inner);
569     }
570 
571     /**
572      * @dev Returns the value stored at position `index` in the set. O(1).
573      *
574      * Note that there are no guarantees on the ordering of values inside the
575      * array, and it may change when more values are added or removed.
576      *
577      * Requirements:
578      *
579      * - `index` must be strictly less than {length}.
580      */
581     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
582         return uint256(_at(set._inner, index));
583     }
584 
585     /**
586      * @dev Return the entire set in an array
587      *
588      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
589      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
590      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
591      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
592      */
593     function values(UintSet storage set) internal view returns (uint256[] memory) {
594         bytes32[] memory store = _values(set._inner);
595         uint256[] memory result;
596 
597         /// @solidity memory-safe-assembly
598         assembly {
599             result := store
600         }
601 
602         return result;
603     }
604 }
605 
606 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
607 
608 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Interface of the ERC20 standard as defined in the EIP.
614  */
615 interface IERC20 {
616     /**
617      * @dev Emitted when `value` tokens are moved from one account (`from`) to
618      * another (`to`).
619      *
620      * Note that `value` may be zero.
621      */
622     event Transfer(address indexed from, address indexed to, uint256 value);
623 
624     /**
625      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
626      * a call to {approve}. `value` is the new allowance.
627      */
628     event Approval(address indexed owner, address indexed spender, uint256 value);
629 
630     /**
631      * @dev Returns the amount of tokens in existence.
632      */
633     function totalSupply() external view returns (uint256);
634 
635     /**
636      * @dev Returns the amount of tokens owned by `account`.
637      */
638     function balanceOf(address account) external view returns (uint256);
639 
640     /**
641      * @dev Moves `amount` tokens from the caller's account to `to`.
642      *
643      * Returns a boolean value indicating whether the operation succeeded.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transfer(address to, uint256 amount) external returns (bool);
648 
649     /**
650      * @dev Returns the remaining number of tokens that `spender` will be
651      * allowed to spend on behalf of `owner` through {transferFrom}. This is
652      * zero by default.
653      *
654      * This value changes when {approve} or {transferFrom} are called.
655      */
656     function allowance(address owner, address spender) external view returns (uint256);
657 
658     /**
659      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
660      *
661      * Returns a boolean value indicating whether the operation succeeded.
662      *
663      * IMPORTANT: Beware that changing an allowance with this method brings the risk
664      * that someone may use both the old and the new allowance by unfortunate
665      * transaction ordering. One possible solution to mitigate this race
666      * condition is to first reduce the spender's allowance to 0 and set the
667      * desired value afterwards:
668      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address spender, uint256 amount) external returns (bool);
673 
674     /**
675      * @dev Moves `amount` tokens from `from` to `to` using the
676      * allowance mechanism. `amount` is then deducted from the caller's
677      * allowance.
678      *
679      * Returns a boolean value indicating whether the operation succeeded.
680      *
681      * Emits a {Transfer} event.
682      */
683     function transferFrom(address from, address to, uint256 amount) external returns (bool);
684 }
685 
686 // File: @openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Interface for the optional metadata functions from the ERC20 standard.
694  *
695  * _Available since v4.1._
696  */
697 interface IERC20Metadata is IERC20 {
698     /**
699      * @dev Returns the name of the token.
700      */
701     function name() external view returns (string memory);
702 
703     /**
704      * @dev Returns the symbol of the token.
705      */
706     function symbol() external view returns (string memory);
707 
708     /**
709      * @dev Returns the decimals places of the token.
710      */
711     function decimals() external view returns (uint8);
712 }
713 
714 // File: @openzeppelin\contracts\utils\Context.sol
715 
716 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @dev Provides information about the current execution context, including the
722  * sender of the transaction and its data. While these are generally available
723  * via msg.sender and msg.data, they should not be accessed in such a direct
724  * manner, since when dealing with meta-transactions the account sending and
725  * paying for execution may not be the actual sender (as far as an application
726  * is concerned).
727  *
728  * This contract is only required for intermediate, library-like contracts.
729  */
730 abstract contract Context {
731     function _msgSender() internal view virtual returns (address) {
732         return msg.sender;
733     }
734 
735     function _msgData() internal view virtual returns (bytes calldata) {
736         return msg.data;
737     }
738 }
739 
740 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
741 
742 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 
747 
748 /**
749  * @dev Implementation of the {IERC20} interface.
750  *
751  * This implementation is agnostic to the way tokens are created. This means
752  * that a supply mechanism has to be added in a derived contract using {_mint}.
753  * For a generic mechanism see {ERC20PresetMinterPauser}.
754  *
755  * TIP: For a detailed writeup see our guide
756  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
757  * to implement supply mechanisms].
758  *
759  * The default value of {decimals} is 18. To change this, you should override
760  * this function so it returns a different value.
761  *
762  * We have followed general OpenZeppelin Contracts guidelines: functions revert
763  * instead returning `false` on failure. This behavior is nonetheless
764  * conventional and does not conflict with the expectations of ERC20
765  * applications.
766  *
767  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
768  * This allows applications to reconstruct the allowance for all accounts just
769  * by listening to said events. Other implementations of the EIP may not emit
770  * these events, as it isn't required by the specification.
771  *
772  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
773  * functions have been added to mitigate the well-known issues around setting
774  * allowances. See {IERC20-approve}.
775  */
776 contract ERC20 is Context, IERC20, IERC20Metadata {
777     mapping(address => uint256) private _balances;
778 
779     mapping(address => mapping(address => uint256)) private _allowances;
780 
781     uint256 private _totalSupply;
782 
783     string private _name;
784     string private _symbol;
785 
786     /**
787      * @dev Sets the values for {name} and {symbol}.
788      *
789      * All two of these values are immutable: they can only be set once during
790      * construction.
791      */
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795     }
796 
797     /**
798      * @dev Returns the name of the token.
799      */
800     function name() public view virtual override returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev Returns the symbol of the token, usually a shorter version of the
806      * name.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev Returns the number of decimals used to get its user representation.
814      * For example, if `decimals` equals `2`, a balance of `505` tokens should
815      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
816      *
817      * Tokens usually opt for a value of 18, imitating the relationship between
818      * Ether and Wei. This is the default value returned by this function, unless
819      * it's overridden.
820      *
821      * NOTE: This information is only used for _display_ purposes: it in
822      * no way affects any of the arithmetic of the contract, including
823      * {IERC20-balanceOf} and {IERC20-transfer}.
824      */
825     function decimals() public view virtual override returns (uint8) {
826         return 18;
827     }
828 
829     /**
830      * @dev See {IERC20-totalSupply}.
831      */
832     function totalSupply() public view virtual override returns (uint256) {
833         return _totalSupply;
834     }
835 
836     /**
837      * @dev See {IERC20-balanceOf}.
838      */
839     function balanceOf(address account) public view virtual override returns (uint256) {
840         return _balances[account];
841     }
842 
843     /**
844      * @dev See {IERC20-transfer}.
845      *
846      * Requirements:
847      *
848      * - `to` cannot be the zero address.
849      * - the caller must have a balance of at least `amount`.
850      */
851     function transfer(address to, uint256 amount) public virtual override returns (bool) {
852         address owner = _msgSender();
853         _transfer(owner, to, amount);
854         return true;
855     }
856 
857     /**
858      * @dev See {IERC20-allowance}.
859      */
860     function allowance(address owner, address spender) public view virtual override returns (uint256) {
861         return _allowances[owner][spender];
862     }
863 
864     /**
865      * @dev See {IERC20-approve}.
866      *
867      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
868      * `transferFrom`. This is semantically equivalent to an infinite approval.
869      *
870      * Requirements:
871      *
872      * - `spender` cannot be the zero address.
873      */
874     function approve(address spender, uint256 amount) public virtual override returns (bool) {
875         address owner = _msgSender();
876         _approve(owner, spender, amount);
877         return true;
878     }
879 
880     /**
881      * @dev See {IERC20-transferFrom}.
882      *
883      * Emits an {Approval} event indicating the updated allowance. This is not
884      * required by the EIP. See the note at the beginning of {ERC20}.
885      *
886      * NOTE: Does not update the allowance if the current allowance
887      * is the maximum `uint256`.
888      *
889      * Requirements:
890      *
891      * - `from` and `to` cannot be the zero address.
892      * - `from` must have a balance of at least `amount`.
893      * - the caller must have allowance for ``from``'s tokens of at least
894      * `amount`.
895      */
896     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
897         address spender = _msgSender();
898         _spendAllowance(from, spender, amount);
899         _transfer(from, to, amount);
900         return true;
901     }
902 
903     /**
904      * @dev Atomically increases the allowance granted to `spender` by the caller.
905      *
906      * This is an alternative to {approve} that can be used as a mitigation for
907      * problems described in {IERC20-approve}.
908      *
909      * Emits an {Approval} event indicating the updated allowance.
910      *
911      * Requirements:
912      *
913      * - `spender` cannot be the zero address.
914      */
915     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
916         address owner = _msgSender();
917         _approve(owner, spender, allowance(owner, spender) + addedValue);
918         return true;
919     }
920 
921     /**
922      * @dev Atomically decreases the allowance granted to `spender` by the caller.
923      *
924      * This is an alternative to {approve} that can be used as a mitigation for
925      * problems described in {IERC20-approve}.
926      *
927      * Emits an {Approval} event indicating the updated allowance.
928      *
929      * Requirements:
930      *
931      * - `spender` cannot be the zero address.
932      * - `spender` must have allowance for the caller of at least
933      * `subtractedValue`.
934      */
935     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
936         address owner = _msgSender();
937         uint256 currentAllowance = allowance(owner, spender);
938         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
939         unchecked {
940             _approve(owner, spender, currentAllowance - subtractedValue);
941         }
942 
943         return true;
944     }
945 
946     /**
947      * @dev Moves `amount` of tokens from `from` to `to`.
948      *
949      * This internal function is equivalent to {transfer}, and can be used to
950      * e.g. implement automatic token fees, slashing mechanisms, etc.
951      *
952      * Emits a {Transfer} event.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `from` must have a balance of at least `amount`.
959      */
960     function _transfer(address from, address to, uint256 amount) internal virtual {
961         require(from != address(0), "ERC20: transfer from the zero address");
962         require(to != address(0), "ERC20: transfer to the zero address");
963 
964         _beforeTokenTransfer(from, to, amount);
965 
966         uint256 fromBalance = _balances[from];
967         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
968         unchecked {
969             _balances[from] = fromBalance - amount;
970             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
971             // decrementing then incrementing.
972             _balances[to] += amount;
973         }
974 
975         emit Transfer(from, to, amount);
976 
977         _afterTokenTransfer(from, to, amount);
978     }
979 
980     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
981      * the total supply.
982      *
983      * Emits a {Transfer} event with `from` set to the zero address.
984      *
985      * Requirements:
986      *
987      * - `account` cannot be the zero address.
988      */
989     function _mint(address account, uint256 amount) internal virtual {
990         require(account != address(0), "ERC20: mint to the zero address");
991 
992         _beforeTokenTransfer(address(0), account, amount);
993 
994         _totalSupply += amount;
995         unchecked {
996             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
997             _balances[account] += amount;
998         }
999         emit Transfer(address(0), account, amount);
1000 
1001         _afterTokenTransfer(address(0), account, amount);
1002     }
1003 
1004     /**
1005      * @dev Destroys `amount` tokens from `account`, reducing the
1006      * total supply.
1007      *
1008      * Emits a {Transfer} event with `to` set to the zero address.
1009      *
1010      * Requirements:
1011      *
1012      * - `account` cannot be the zero address.
1013      * - `account` must have at least `amount` tokens.
1014      */
1015     function _burn(address account, uint256 amount) internal virtual {
1016         require(account != address(0), "ERC20: burn from the zero address");
1017 
1018         _beforeTokenTransfer(account, address(0), amount);
1019 
1020         uint256 accountBalance = _balances[account];
1021         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1022         unchecked {
1023             _balances[account] = accountBalance - amount;
1024             // Overflow not possible: amount <= accountBalance <= totalSupply.
1025             _totalSupply -= amount;
1026         }
1027 
1028         emit Transfer(account, address(0), amount);
1029 
1030         _afterTokenTransfer(account, address(0), amount);
1031     }
1032 
1033     /**
1034      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1035      *
1036      * This internal function is equivalent to `approve`, and can be used to
1037      * e.g. set automatic allowances for certain subsystems, etc.
1038      *
1039      * Emits an {Approval} event.
1040      *
1041      * Requirements:
1042      *
1043      * - `owner` cannot be the zero address.
1044      * - `spender` cannot be the zero address.
1045      */
1046     function _approve(address owner, address spender, uint256 amount) internal virtual {
1047         require(owner != address(0), "ERC20: approve from the zero address");
1048         require(spender != address(0), "ERC20: approve to the zero address");
1049 
1050         _allowances[owner][spender] = amount;
1051         emit Approval(owner, spender, amount);
1052     }
1053 
1054     /**
1055      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1056      *
1057      * Does not update the allowance amount in case of infinite allowance.
1058      * Revert if not enough allowance is available.
1059      *
1060      * Might emit an {Approval} event.
1061      */
1062     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1063         uint256 currentAllowance = allowance(owner, spender);
1064         if (currentAllowance != type(uint256).max) {
1065             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1066             unchecked {
1067                 _approve(owner, spender, currentAllowance - amount);
1068             }
1069         }
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before any transfer of tokens. This includes
1074      * minting and burning.
1075      *
1076      * Calling conditions:
1077      *
1078      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1079      * will be transferred to `to`.
1080      * - when `from` is zero, `amount` tokens will be minted for `to`.
1081      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1082      * - `from` and `to` are never both zero.
1083      *
1084      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1085      */
1086     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1087 
1088     /**
1089      * @dev Hook that is called after any transfer of tokens. This includes
1090      * minting and burning.
1091      *
1092      * Calling conditions:
1093      *
1094      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1095      * has been transferred to `to`.
1096      * - when `from` is zero, `amount` tokens have been minted for `to`.
1097      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1098      * - `from` and `to` are never both zero.
1099      *
1100      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1101      */
1102     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1103 }
1104 
1105 // File: @openzeppelin\contracts\access\Ownable.sol
1106 
1107 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 /**
1112  * @dev Contract module which provides a basic access control mechanism, where
1113  * there is an account (an owner) that can be granted exclusive access to
1114  * specific functions.
1115  *
1116  * By default, the owner account will be the one that deploys the contract. This
1117  * can later be changed with {transferOwnership}.
1118  *
1119  * This module is used through inheritance. It will make available the modifier
1120  * `onlyOwner`, which can be applied to your functions to restrict their use to
1121  * the owner.
1122  */
1123 abstract contract Ownable is Context {
1124     address private _owner;
1125 
1126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1127 
1128     /**
1129      * @dev Initializes the contract setting the deployer as the initial owner.
1130      */
1131     constructor() {
1132         _transferOwnership(_msgSender());
1133     }
1134 
1135     /**
1136      * @dev Throws if called by any account other than the owner.
1137      */
1138     modifier onlyOwner() {
1139         _checkOwner();
1140         _;
1141     }
1142 
1143     /**
1144      * @dev Returns the address of the current owner.
1145      */
1146     function owner() public view virtual returns (address) {
1147         return _owner;
1148     }
1149 
1150     /**
1151      * @dev Throws if the sender is not the owner.
1152      */
1153     function _checkOwner() internal view virtual {
1154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1155     }
1156 
1157     /**
1158      * @dev Leaves the contract without owner. It will not be possible to call
1159      * `onlyOwner` functions. Can only be called by the current owner.
1160      *
1161      * NOTE: Renouncing ownership will leave the contract without an owner,
1162      * thereby disabling any functionality that is only available to the owner.
1163      */
1164     function renounceOwnership() public virtual onlyOwner {
1165         _transferOwnership(address(0));
1166     }
1167 
1168     /**
1169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1170      * Can only be called by the current owner.
1171      */
1172     function transferOwnership(address newOwner) public virtual onlyOwner {
1173         require(newOwner != address(0), "Ownable: new owner is the zero address");
1174         _transferOwnership(newOwner);
1175     }
1176 
1177     /**
1178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1179      * Internal function without access restriction.
1180      */
1181     function _transferOwnership(address newOwner) internal virtual {
1182         address oldOwner = _owner;
1183         _owner = newOwner;
1184         emit OwnershipTransferred(oldOwner, newOwner);
1185     }
1186 }
1187 
1188 // File: contracts\IUniswapV2Router01.sol
1189 
1190 pragma solidity >=0.6.2;
1191 
1192 interface IUniswapV2Router01 {
1193     function factory() external pure returns (address);
1194     function WETH() external pure returns (address);
1195 
1196     function addLiquidity(
1197         address tokenA,
1198         address tokenB,
1199         uint amountADesired,
1200         uint amountBDesired,
1201         uint amountAMin,
1202         uint amountBMin,
1203         address to,
1204         uint deadline
1205     ) external returns (uint amountA, uint amountB, uint liquidity);
1206     function addLiquidityETH(
1207         address token,
1208         uint amountTokenDesired,
1209         uint amountTokenMin,
1210         uint amountETHMin,
1211         address to,
1212         uint deadline
1213     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1214     function removeLiquidity(
1215         address tokenA,
1216         address tokenB,
1217         uint liquidity,
1218         uint amountAMin,
1219         uint amountBMin,
1220         address to,
1221         uint deadline
1222     ) external returns (uint amountA, uint amountB);
1223     function removeLiquidityETH(
1224         address token,
1225         uint liquidity,
1226         uint amountTokenMin,
1227         uint amountETHMin,
1228         address to,
1229         uint deadline
1230     ) external returns (uint amountToken, uint amountETH);
1231     function removeLiquidityWithPermit(
1232         address tokenA,
1233         address tokenB,
1234         uint liquidity,
1235         uint amountAMin,
1236         uint amountBMin,
1237         address to,
1238         uint deadline,
1239         bool approveMax, uint8 v, bytes32 r, bytes32 s
1240     ) external returns (uint amountA, uint amountB);
1241     function removeLiquidityETHWithPermit(
1242         address token,
1243         uint liquidity,
1244         uint amountTokenMin,
1245         uint amountETHMin,
1246         address to,
1247         uint deadline,
1248         bool approveMax, uint8 v, bytes32 r, bytes32 s
1249     ) external returns (uint amountToken, uint amountETH);
1250     function swapExactTokensForTokens(
1251         uint amountIn,
1252         uint amountOutMin,
1253         address[] calldata path,
1254         address to,
1255         uint deadline
1256     ) external returns (uint[] memory amounts);
1257     function swapTokensForExactTokens(
1258         uint amountOut,
1259         uint amountInMax,
1260         address[] calldata path,
1261         address to,
1262         uint deadline
1263     ) external returns (uint[] memory amounts);
1264     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1265         external
1266         payable
1267         returns (uint[] memory amounts);
1268     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1269         external
1270         returns (uint[] memory amounts);
1271     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1272         external
1273         returns (uint[] memory amounts);
1274     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1275         external
1276         payable
1277         returns (uint[] memory amounts);
1278 
1279     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1280     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1281     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1282     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1283     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1284 }
1285 
1286 // File: contracts\IUniswapV2Router02.sol
1287 
1288 pragma solidity >=0.6.2;
1289 interface IUniswapV2Router02 is IUniswapV2Router01 {
1290     function removeLiquidityETHSupportingFeeOnTransferTokens(
1291         address token,
1292         uint liquidity,
1293         uint amountTokenMin,
1294         uint amountETHMin,
1295         address to,
1296         uint deadline
1297     ) external returns (uint amountETH);
1298     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1299         address token,
1300         uint liquidity,
1301         uint amountTokenMin,
1302         uint amountETHMin,
1303         address to,
1304         uint deadline,
1305         bool approveMax, uint8 v, bytes32 r, bytes32 s
1306     ) external returns (uint amountETH);
1307 
1308     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1309         uint amountIn,
1310         uint amountOutMin,
1311         address[] calldata path,
1312         address to,
1313         uint deadline
1314     ) external;
1315     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1316         uint amountOutMin,
1317         address[] calldata path,
1318         address to,
1319         uint deadline
1320     ) external payable;
1321     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1322         uint amountIn,
1323         uint amountOutMin,
1324         address[] calldata path,
1325         address to,
1326         uint deadline
1327     ) external;
1328 }
1329 
1330 // File: contracts\IUniswapV2Factory.sol
1331 
1332 pragma solidity >=0.5.0;
1333 
1334 interface IUniswapV2Factory {
1335     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1336 
1337     function feeTo() external view returns (address);
1338     function feeToSetter() external view returns (address);
1339 
1340     function getPair(address tokenA, address tokenB) external view returns (address pair);
1341     function allPairs(uint) external view returns (address pair);
1342     function allPairsLength() external view returns (uint);
1343 
1344     function createPair(address tokenA, address tokenB) external returns (address pair);
1345 
1346     function setFeeTo(address) external;
1347     function setFeeToSetter(address) external;
1348 }
1349 
1350 // File: contracts\IUniswapV2Pair.sol
1351 
1352 pragma solidity >=0.5.0;
1353 
1354 interface IUniswapV2Pair {
1355     event Approval(address indexed owner, address indexed spender, uint value);
1356     event Transfer(address indexed from, address indexed to, uint value);
1357 
1358     function name() external pure returns (string memory);
1359     function symbol() external pure returns (string memory);
1360     function decimals() external pure returns (uint8);
1361     function totalSupply() external view returns (uint);
1362     function balanceOf(address owner) external view returns (uint);
1363     function allowance(address owner, address spender) external view returns (uint);
1364 
1365     function approve(address spender, uint value) external returns (bool);
1366     function transfer(address to, uint value) external returns (bool);
1367     function transferFrom(address from, address to, uint value) external returns (bool);
1368 
1369     function DOMAIN_SEPARATOR() external view returns (bytes32);
1370     function PERMIT_TYPEHASH() external pure returns (bytes32);
1371     function nonces(address owner) external view returns (uint);
1372 
1373     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1374 
1375     event Mint(address indexed sender, uint amount0, uint amount1);
1376     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1377     event Swap(
1378         address indexed sender,
1379         uint amount0In,
1380         uint amount1In,
1381         uint amount0Out,
1382         uint amount1Out,
1383         address indexed to
1384     );
1385     event Sync(uint112 reserve0, uint112 reserve1);
1386 
1387     function MINIMUM_LIQUIDITY() external pure returns (uint);
1388     function factory() external view returns (address);
1389     function token0() external view returns (address);
1390     function token1() external view returns (address);
1391     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1392     function price0CumulativeLast() external view returns (uint);
1393     function price1CumulativeLast() external view returns (uint);
1394     function kLast() external view returns (uint);
1395 
1396     function mint(address to) external returns (uint liquidity);
1397     function burn(address to) external returns (uint amount0, uint amount1);
1398     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1399     function skim(address to) external;
1400     function sync() external;
1401 
1402     function initialize(address, address) external;
1403 }
1404 
1405 // File: contracts\EcoTool.sol
1406 
1407 // SPDX-License-Identifier: UNLICENSED
1408 pragma solidity ^0.8.0;
1409 contract EcoTool is Ownable, ERC20 {
1410     using SafeMath for uint256;
1411     using EnumerableSet for EnumerableSet.AddressSet;
1412 
1413     uint256 public initToken = 100000000 * 1e18;
1414 
1415     IUniswapV2Router02 public uniswapV2Router;
1416     IUniswapV2Factory public factory;
1417     EnumerableSet.AddressSet private _pairs;
1418     address public foundationAddress;
1419     address public ryspAddress; // Real Yield Sharing Pool
1420     uint public foundationPercent = 50;
1421 
1422     uint256 public buyFee = 5;
1423     uint256 public sellFee = 5;
1424     bool inSwap = false;
1425 
1426     mapping(address => bool) public isExcludedFromFee;
1427     uint256 public checkBot = 6400000 * 1e18;
1428     uint256 public numTokensSellToAddToETH = 80000 * 1e18;
1429     uint256 public maxTokenSellToAddToETH = 2000000 * 1e18;
1430 
1431     uint256 public blockBotDuration = 30;
1432     uint256 public blockBotTime;
1433     bool private initialized;
1434 
1435     constructor(string memory name, string memory symbol, address _router) ERC20(name, symbol) {
1436         _mint(_msgSender(), initToken);
1437         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1438         uniswapV2Router = _uniswapV2Router;
1439         factory = IUniswapV2Factory(_uniswapV2Router.factory());
1440         foundationAddress = address(0x5aC11C8697E018a69F932DD6C2D7179fE5278146);
1441         ryspAddress = address(0xE50d196808559Cb53123506BCBCBbc3F6CD2e460);
1442         isExcludedFromFee[_msgSender()] = true;
1443         isExcludedFromFee[foundationAddress] = true;
1444     }
1445 
1446     modifier lockTheSwap() {
1447         inSwap = true;
1448         _;
1449         inSwap = false;
1450     }
1451 
1452     function initializePair() external onlyOwner {
1453         require(!initialized, "Already initialized");
1454         address pair = factory.createPair(uniswapV2Router.WETH(), address(this));
1455         _pairs.add(pair);
1456         initialized = true;
1457     }
1458 
1459     function burn(uint256 amount) public {
1460         _burn(_msgSender(), amount);
1461     }
1462 
1463     function _transfer(
1464         address sender,
1465         address recipient,
1466         uint256 amount
1467     ) internal virtual override {
1468         uint256 transferFee;
1469         //check fee
1470         if(!isExcludedFromFee[sender] && isPair(recipient)) {
1471             transferFee = sellFee;
1472         } else if(!isExcludedFromFee[recipient] && isPair(sender)) {
1473             transferFee = buyFee;
1474         }
1475 
1476         //is bot
1477         if (
1478             blockBotTime > block.timestamp &&
1479             amount > checkBot &&
1480             sender != address(this) &&
1481             recipient != address(this) &&
1482             isPair(sender)
1483         ) {
1484             transferFee = 80;
1485         }
1486 
1487         //add liquid
1488         if (blockBotTime == 0 && transferFee > 0 && amount > 0) {
1489             blockBotTime = block.timestamp + blockBotDuration;
1490         }
1491 
1492         if (inSwap) {
1493             super._transfer(sender, recipient, amount);
1494             return;
1495         }
1496 
1497         if (transferFee > 0 && sender != address(this) && recipient != address(this)) {
1498             uint256 _fee = amount.mul(transferFee).div(100);
1499             super._transfer(sender, address(this), _fee);
1500             amount = amount.sub(_fee);
1501         } else {
1502             callToTreasury();
1503         }
1504 
1505         super._transfer(sender, recipient, amount);
1506     }
1507 
1508     function callToTreasury() internal lockTheSwap {
1509         uint256 balanceThis = balanceOf(address(this));
1510 
1511         if (balanceThis > numTokensSellToAddToETH) {
1512             if(balanceThis > maxTokenSellToAddToETH) balanceThis = maxTokenSellToAddToETH;
1513             swapTokensForETH(balanceThis);
1514         }
1515     }
1516 
1517     function swapTokensForETH(uint256 tokenAmount) private {
1518         address[] memory path = new address[](2);
1519         path[0] = address(this);
1520         path[1] = uniswapV2Router.WETH();
1521 
1522         _approve(address(this), address(uniswapV2Router), tokenAmount);
1523 
1524         uniswapV2Router.swapExactTokensForETH(tokenAmount, 0, path, address(this), block.timestamp);
1525         uint256 ethBalance = address(this).balance;
1526         uint ethToFoundation = ethBalance * foundationPercent / 100;
1527         payable(address(foundationAddress)).call{value: ethToFoundation}("");
1528         payable(address(ryspAddress)).call{value: ethBalance-ethToFoundation}("");
1529     }
1530 
1531     function setExcludeFromFee(address _address, bool _status) external onlyOwner {
1532         require(_address != address(0), "0x is not accepted here");
1533         require(isExcludedFromFee[_address] != _status, "Status was set");
1534         isExcludedFromFee[_address] = _status;
1535     }
1536 
1537     function changeFoundationWallet(address _foundationWallet) external {
1538         require(_msgSender() == foundationAddress, "Only Foundation Wallet!");
1539         require(_foundationWallet != address(0), "0x is not accepted here");
1540 
1541         foundationAddress = _foundationWallet;
1542     }
1543 
1544     function changeRyspAddress(address _ryspAddress) external {
1545         require(_msgSender() == ryspAddress, "Only Rysp Wallet!");
1546         require(_ryspAddress != address(0), "0x is not accepted here");
1547 
1548         ryspAddress = _ryspAddress;
1549     }
1550 
1551     function changeNumTokensSellToAddToETH(uint256 _numTokensSellToAddToETH) external onlyOwner {
1552         require(_numTokensSellToAddToETH != 0, "_numTokensSellToAddToETH !=0");
1553         numTokensSellToAddToETH = _numTokensSellToAddToETH;
1554     }
1555 
1556     function changeFoundationPercent(uint256 _foundationPercent) external onlyOwner {
1557         require(_foundationPercent <=100, "_foundationPercent <= 100");
1558         foundationPercent = _foundationPercent;
1559     }
1560 
1561     function isPair(address account) public view returns (bool) {
1562         return _pairs.contains(account);
1563     }
1564 
1565     function addPair(address pair) public onlyOwner returns (bool) {
1566         require(pair != address(0), "ECOTOOL: pair is the zero address");
1567         return _pairs.add(pair);
1568     }
1569 
1570     function delPair(address pair) public onlyOwner returns (bool) {
1571         require(pair != address(0), "ECOTOOL: pair is the zero address");
1572         return _pairs.remove(pair);
1573     }
1574 
1575     function getMinterLength() public view returns (uint256) {
1576         return _pairs.length();
1577     }
1578 
1579     function getPair(uint256 index) public view returns (address) {
1580         require(index <= _pairs.length() - 1, "ECOTOOL: index out of bounds");
1581         return _pairs.at(index);
1582     }
1583 
1584     // receive eth
1585     receive() external payable {}
1586 
1587 }