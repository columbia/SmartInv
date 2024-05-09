1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/structs/EnumerableSet.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for managing
10  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
11  * types.
12  *
13  * Sets have the following properties:
14  *
15  * - Elements are added, removed, and checked for existence in constant time
16  * (O(1)).
17  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
18  *
19  * ```
20  * contract Example {
21  *     // Add the library methods
22  *     using EnumerableSet for EnumerableSet.AddressSet;
23  *
24  *     // Declare a set state variable
25  *     EnumerableSet.AddressSet private mySet;
26  * }
27  * ```
28  *
29  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
30  * and `uint256` (`UintSet`) are supported.
31  */
32 library EnumerableSet {
33     // To implement this library for multiple types with as little code
34     // repetition as possible, we write it in terms of a generic Set type with
35     // bytes32 values.
36     // The Set implementation uses private functions, and user-facing
37     // implementations (such as AddressSet) are just wrappers around the
38     // underlying Set.
39     // This means that we can only create new EnumerableSets for types that fit
40     // in bytes32.
41 
42     struct Set {
43         // Storage of set values
44         bytes32[] _values;
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping(bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) {
79             // Equivalent to contains(set, value)
80             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
81             // the array, and then remove the last element (sometimes called as 'swap and pop').
82             // This modifies the order of the array, as noted in {at}.
83 
84             uint256 toDeleteIndex = valueIndex - 1;
85             uint256 lastIndex = set._values.length - 1;
86 
87             if (lastIndex != toDeleteIndex) {
88                 bytes32 lastvalue = set._values[lastIndex];
89 
90                 // Move the last value to the index where the value to delete is
91                 set._values[toDeleteIndex] = lastvalue;
92                 // Update the index for the moved value
93                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
94             }
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value) private view returns (bool) {
112         return set._indexes[value] != 0;
113     }
114 
115     /**
116      * @dev Returns the number of values on the set. O(1).
117      */
118     function _length(Set storage set) private view returns (uint256) {
119         return set._values.length;
120     }
121 
122     /**
123      * @dev Returns the value stored at position `index` in the set. O(1).
124      *
125      * Note that there are no guarantees on the ordering of values inside the
126      * array, and it may change when more values are added or removed.
127      *
128      * Requirements:
129      *
130      * - `index` must be strictly less than {length}.
131      */
132     function _at(Set storage set, uint256 index) private view returns (bytes32) {
133         return set._values[index];
134     }
135 
136     /**
137      * @dev Return the entire set in an array
138      *
139      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
140      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
141      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
142      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
143      */
144     function _values(Set storage set) private view returns (bytes32[] memory) {
145         return set._values;
146     }
147 
148     // Bytes32Set
149 
150     struct Bytes32Set {
151         Set _inner;
152     }
153 
154     /**
155      * @dev Add a value to a set. O(1).
156      *
157      * Returns true if the value was added to the set, that is if it was not
158      * already present.
159      */
160     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
161         return _add(set._inner, value);
162     }
163 
164     /**
165      * @dev Removes a value from a set. O(1).
166      *
167      * Returns true if the value was removed from the set, that is if it was
168      * present.
169      */
170     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
171         return _remove(set._inner, value);
172     }
173 
174     /**
175      * @dev Returns true if the value is in the set. O(1).
176      */
177     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
178         return _contains(set._inner, value);
179     }
180 
181     /**
182      * @dev Returns the number of values in the set. O(1).
183      */
184     function length(Bytes32Set storage set) internal view returns (uint256) {
185         return _length(set._inner);
186     }
187 
188     /**
189      * @dev Returns the value stored at position `index` in the set. O(1).
190      *
191      * Note that there are no guarantees on the ordering of values inside the
192      * array, and it may change when more values are added or removed.
193      *
194      * Requirements:
195      *
196      * - `index` must be strictly less than {length}.
197      */
198     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
199         return _at(set._inner, index);
200     }
201 
202     /**
203      * @dev Return the entire set in an array
204      *
205      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
206      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
207      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
208      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
209      */
210     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
211         return _values(set._inner);
212     }
213 
214     // AddressSet
215 
216     struct AddressSet {
217         Set _inner;
218     }
219 
220     /**
221      * @dev Add a value to a set. O(1).
222      *
223      * Returns true if the value was added to the set, that is if it was not
224      * already present.
225      */
226     function add(AddressSet storage set, address value) internal returns (bool) {
227         return _add(set._inner, bytes32(uint256(uint160(value))));
228     }
229 
230     /**
231      * @dev Removes a value from a set. O(1).
232      *
233      * Returns true if the value was removed from the set, that is if it was
234      * present.
235      */
236     function remove(AddressSet storage set, address value) internal returns (bool) {
237         return _remove(set._inner, bytes32(uint256(uint160(value))));
238     }
239 
240     /**
241      * @dev Returns true if the value is in the set. O(1).
242      */
243     function contains(AddressSet storage set, address value) internal view returns (bool) {
244         return _contains(set._inner, bytes32(uint256(uint160(value))));
245     }
246 
247     /**
248      * @dev Returns the number of values in the set. O(1).
249      */
250     function length(AddressSet storage set) internal view returns (uint256) {
251         return _length(set._inner);
252     }
253 
254     /**
255      * @dev Returns the value stored at position `index` in the set. O(1).
256      *
257      * Note that there are no guarantees on the ordering of values inside the
258      * array, and it may change when more values are added or removed.
259      *
260      * Requirements:
261      *
262      * - `index` must be strictly less than {length}.
263      */
264     function at(AddressSet storage set, uint256 index) internal view returns (address) {
265         return address(uint160(uint256(_at(set._inner, index))));
266     }
267 
268     /**
269      * @dev Return the entire set in an array
270      *
271      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
272      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
273      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
274      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
275      */
276     function values(AddressSet storage set) internal view returns (address[] memory) {
277         bytes32[] memory store = _values(set._inner);
278         address[] memory result;
279 
280         assembly {
281             result := store
282         }
283 
284         return result;
285     }
286 
287     // UintSet
288 
289     struct UintSet {
290         Set _inner;
291     }
292 
293     /**
294      * @dev Add a value to a set. O(1).
295      *
296      * Returns true if the value was added to the set, that is if it was not
297      * already present.
298      */
299     function add(UintSet storage set, uint256 value) internal returns (bool) {
300         return _add(set._inner, bytes32(value));
301     }
302 
303     /**
304      * @dev Removes a value from a set. O(1).
305      *
306      * Returns true if the value was removed from the set, that is if it was
307      * present.
308      */
309     function remove(UintSet storage set, uint256 value) internal returns (bool) {
310         return _remove(set._inner, bytes32(value));
311     }
312 
313     /**
314      * @dev Returns true if the value is in the set. O(1).
315      */
316     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
317         return _contains(set._inner, bytes32(value));
318     }
319 
320     /**
321      * @dev Returns the number of values on the set. O(1).
322      */
323     function length(UintSet storage set) internal view returns (uint256) {
324         return _length(set._inner);
325     }
326 
327     /**
328      * @dev Returns the value stored at position `index` in the set. O(1).
329      *
330      * Note that there are no guarantees on the ordering of values inside the
331      * array, and it may change when more values are added or removed.
332      *
333      * Requirements:
334      *
335      * - `index` must be strictly less than {length}.
336      */
337     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
338         return uint256(_at(set._inner, index));
339     }
340 
341     /**
342      * @dev Return the entire set in an array
343      *
344      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
345      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
346      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
347      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
348      */
349     function values(UintSet storage set) internal view returns (uint256[] memory) {
350         bytes32[] memory store = _values(set._inner);
351         uint256[] memory result;
352 
353         assembly {
354             result := store
355         }
356 
357         return result;
358     }
359 }
360 
361 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 // CAUTION
369 // This version of SafeMath should only be used with Solidity 0.8 or later,
370 // because it relies on the compiler's built in overflow checks.
371 
372 /**
373  * @dev Wrappers over Solidity's arithmetic operations.
374  *
375  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
376  * now has built in overflow checking.
377  */
378 library SafeMath {
379     /**
380      * @dev Returns the addition of two unsigned integers, with an overflow flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
385         unchecked {
386             uint256 c = a + b;
387             if (c < a) return (false, 0);
388             return (true, c);
389         }
390     }
391 
392     /**
393      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
394      *
395      * _Available since v3.4._
396      */
397     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
398         unchecked {
399             if (b > a) return (false, 0);
400             return (true, a - b);
401         }
402     }
403 
404     /**
405      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
406      *
407      * _Available since v3.4._
408      */
409     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
410         unchecked {
411             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
412             // benefit is lost if 'b' is also tested.
413             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
414             if (a == 0) return (true, 0);
415             uint256 c = a * b;
416             if (c / a != b) return (false, 0);
417             return (true, c);
418         }
419     }
420 
421     /**
422      * @dev Returns the division of two unsigned integers, with a division by zero flag.
423      *
424      * _Available since v3.4._
425      */
426     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
427         unchecked {
428             if (b == 0) return (false, 0);
429             return (true, a / b);
430         }
431     }
432 
433     /**
434      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
435      *
436      * _Available since v3.4._
437      */
438     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
439         unchecked {
440             if (b == 0) return (false, 0);
441             return (true, a % b);
442         }
443     }
444 
445     /**
446      * @dev Returns the addition of two unsigned integers, reverting on
447      * overflow.
448      *
449      * Counterpart to Solidity's `+` operator.
450      *
451      * Requirements:
452      *
453      * - Addition cannot overflow.
454      */
455     function add(uint256 a, uint256 b) internal pure returns (uint256) {
456         return a + b;
457     }
458 
459     /**
460      * @dev Returns the subtraction of two unsigned integers, reverting on
461      * overflow (when the result is negative).
462      *
463      * Counterpart to Solidity's `-` operator.
464      *
465      * Requirements:
466      *
467      * - Subtraction cannot overflow.
468      */
469     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
470         return a - b;
471     }
472 
473     /**
474      * @dev Returns the multiplication of two unsigned integers, reverting on
475      * overflow.
476      *
477      * Counterpart to Solidity's `*` operator.
478      *
479      * Requirements:
480      *
481      * - Multiplication cannot overflow.
482      */
483     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
484         return a * b;
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers, reverting on
489      * division by zero. The result is rounded towards zero.
490      *
491      * Counterpart to Solidity's `/` operator.
492      *
493      * Requirements:
494      *
495      * - The divisor cannot be zero.
496      */
497     function div(uint256 a, uint256 b) internal pure returns (uint256) {
498         return a / b;
499     }
500 
501     /**
502      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
503      * reverting when dividing by zero.
504      *
505      * Counterpart to Solidity's `%` operator. This function uses a `revert`
506      * opcode (which leaves remaining gas untouched) while Solidity uses an
507      * invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
514         return a % b;
515     }
516 
517     /**
518      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
519      * overflow (when the result is negative).
520      *
521      * CAUTION: This function is deprecated because it requires allocating memory for the error
522      * message unnecessarily. For custom revert reasons use {trySub}.
523      *
524      * Counterpart to Solidity's `-` operator.
525      *
526      * Requirements:
527      *
528      * - Subtraction cannot overflow.
529      */
530     function sub(
531         uint256 a,
532         uint256 b,
533         string memory errorMessage
534     ) internal pure returns (uint256) {
535         unchecked {
536             require(b <= a, errorMessage);
537             return a - b;
538         }
539     }
540 
541     /**
542      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
543      * division by zero. The result is rounded towards zero.
544      *
545      * Counterpart to Solidity's `/` operator. Note: this function uses a
546      * `revert` opcode (which leaves remaining gas untouched) while Solidity
547      * uses an invalid opcode to revert (consuming all remaining gas).
548      *
549      * Requirements:
550      *
551      * - The divisor cannot be zero.
552      */
553     function div(
554         uint256 a,
555         uint256 b,
556         string memory errorMessage
557     ) internal pure returns (uint256) {
558         unchecked {
559             require(b > 0, errorMessage);
560             return a / b;
561         }
562     }
563 
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566      * reverting with custom message when dividing by zero.
567      *
568      * CAUTION: This function is deprecated because it requires allocating memory for the error
569      * message unnecessarily. For custom revert reasons use {tryMod}.
570      *
571      * Counterpart to Solidity's `%` operator. This function uses a `revert`
572      * opcode (which leaves remaining gas untouched) while Solidity uses an
573      * invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function mod(
580         uint256 a,
581         uint256 b,
582         string memory errorMessage
583     ) internal pure returns (uint256) {
584         unchecked {
585             require(b > 0, errorMessage);
586             return a % b;
587         }
588     }
589 }
590 
591 // File: @openzeppelin/contracts/utils/math/Math.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.0 (utils/math/Math.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev Standard math utilities missing in the Solidity language.
600  */
601 library Math {
602     /**
603      * @dev Returns the largest of two numbers.
604      */
605     function max(uint256 a, uint256 b) internal pure returns (uint256) {
606         return a >= b ? a : b;
607     }
608 
609     /**
610      * @dev Returns the smallest of two numbers.
611      */
612     function min(uint256 a, uint256 b) internal pure returns (uint256) {
613         return a < b ? a : b;
614     }
615 
616     /**
617      * @dev Returns the average of two numbers. The result is rounded towards
618      * zero.
619      */
620     function average(uint256 a, uint256 b) internal pure returns (uint256) {
621         // (a + b) / 2 can overflow.
622         return (a & b) + (a ^ b) / 2;
623     }
624 
625     /**
626      * @dev Returns the ceiling of the division of two numbers.
627      *
628      * This differs from standard division with `/` in that it rounds up instead
629      * of rounding down.
630      */
631     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
632         // (a + b - 1) / b can overflow on addition, so we distribute.
633         return a / b + (a % b == 0 ? 0 : 1);
634     }
635 }
636 
637 // File: @openzeppelin/contracts/utils/Address.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Collection of functions related to the address type
646  */
647 library Address {
648     /**
649      * @dev Returns true if `account` is a contract.
650      *
651      * [IMPORTANT]
652      * ====
653      * It is unsafe to assume that an address for which this function returns
654      * false is an externally-owned account (EOA) and not a contract.
655      *
656      * Among others, `isContract` will return false for the following
657      * types of addresses:
658      *
659      *  - an externally-owned account
660      *  - a contract in construction
661      *  - an address where a contract will be created
662      *  - an address where a contract lived, but was destroyed
663      * ====
664      */
665     function isContract(address account) internal view returns (bool) {
666         // This method relies on extcodesize, which returns 0 for contracts in
667         // construction, since the code is only stored at the end of the
668         // constructor execution.
669 
670         uint256 size;
671         assembly {
672             size := extcodesize(account)
673         }
674         return size > 0;
675     }
676 
677     /**
678      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
679      * `recipient`, forwarding all available gas and reverting on errors.
680      *
681      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
682      * of certain opcodes, possibly making contracts go over the 2300 gas limit
683      * imposed by `transfer`, making them unable to receive funds via
684      * `transfer`. {sendValue} removes this limitation.
685      *
686      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
687      *
688      * IMPORTANT: because control is transferred to `recipient`, care must be
689      * taken to not create reentrancy vulnerabilities. Consider using
690      * {ReentrancyGuard} or the
691      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
692      */
693     function sendValue(address payable recipient, uint256 amount) internal {
694         require(address(this).balance >= amount, "Address: insufficient balance");
695 
696         (bool success, ) = recipient.call{value: amount}("");
697         require(success, "Address: unable to send value, recipient may have reverted");
698     }
699 
700     /**
701      * @dev Performs a Solidity function call using a low level `call`. A
702      * plain `call` is an unsafe replacement for a function call: use this
703      * function instead.
704      *
705      * If `target` reverts with a revert reason, it is bubbled up by this
706      * function (like regular Solidity function calls).
707      *
708      * Returns the raw returned data. To convert to the expected return value,
709      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
710      *
711      * Requirements:
712      *
713      * - `target` must be a contract.
714      * - calling `target` with `data` must not revert.
715      *
716      * _Available since v3.1._
717      */
718     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
719         return functionCall(target, data, "Address: low-level call failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
724      * `errorMessage` as a fallback revert reason when `target` reverts.
725      *
726      * _Available since v3.1._
727      */
728     function functionCall(
729         address target,
730         bytes memory data,
731         string memory errorMessage
732     ) internal returns (bytes memory) {
733         return functionCallWithValue(target, data, 0, errorMessage);
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
738      * but also transferring `value` wei to `target`.
739      *
740      * Requirements:
741      *
742      * - the calling contract must have an ETH balance of at least `value`.
743      * - the called Solidity function must be `payable`.
744      *
745      * _Available since v3.1._
746      */
747     function functionCallWithValue(
748         address target,
749         bytes memory data,
750         uint256 value
751     ) internal returns (bytes memory) {
752         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
757      * with `errorMessage` as a fallback revert reason when `target` reverts.
758      *
759      * _Available since v3.1._
760      */
761     function functionCallWithValue(
762         address target,
763         bytes memory data,
764         uint256 value,
765         string memory errorMessage
766     ) internal returns (bytes memory) {
767         require(address(this).balance >= value, "Address: insufficient balance for call");
768         require(isContract(target), "Address: call to non-contract");
769 
770         (bool success, bytes memory returndata) = target.call{value: value}(data);
771         return verifyCallResult(success, returndata, errorMessage);
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
776      * but performing a static call.
777      *
778      * _Available since v3.3._
779      */
780     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
781         return functionStaticCall(target, data, "Address: low-level static call failed");
782     }
783 
784     /**
785      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
786      * but performing a static call.
787      *
788      * _Available since v3.3._
789      */
790     function functionStaticCall(
791         address target,
792         bytes memory data,
793         string memory errorMessage
794     ) internal view returns (bytes memory) {
795         require(isContract(target), "Address: static call to non-contract");
796 
797         (bool success, bytes memory returndata) = target.staticcall(data);
798         return verifyCallResult(success, returndata, errorMessage);
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
803      * but performing a delegate call.
804      *
805      * _Available since v3.4._
806      */
807     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
808         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
813      * but performing a delegate call.
814      *
815      * _Available since v3.4._
816      */
817     function functionDelegateCall(
818         address target,
819         bytes memory data,
820         string memory errorMessage
821     ) internal returns (bytes memory) {
822         require(isContract(target), "Address: delegate call to non-contract");
823 
824         (bool success, bytes memory returndata) = target.delegatecall(data);
825         return verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
830      * revert reason using the provided one.
831      *
832      * _Available since v4.3._
833      */
834     function verifyCallResult(
835         bool success,
836         bytes memory returndata,
837         string memory errorMessage
838     ) internal pure returns (bytes memory) {
839         if (success) {
840             return returndata;
841         } else {
842             // Look for revert reason and bubble it up if present
843             if (returndata.length > 0) {
844                 // The easiest way to bubble the revert reason is using memory via assembly
845 
846                 assembly {
847                     let returndata_size := mload(returndata)
848                     revert(add(32, returndata), returndata_size)
849                 }
850             } else {
851                 revert(errorMessage);
852             }
853         }
854     }
855 }
856 
857 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
858 
859 
860 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
861 
862 pragma solidity ^0.8.0;
863 
864 /**
865  * @title ERC721 token receiver interface
866  * @dev Interface for any contract that wants to support safeTransfers
867  * from ERC721 asset contracts.
868  */
869 interface IERC721Receiver {
870     /**
871      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
872      * by `operator` from `from`, this function is called.
873      *
874      * It must return its Solidity selector to confirm the token transfer.
875      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
876      *
877      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
878      */
879     function onERC721Received(
880         address operator,
881         address from,
882         uint256 tokenId,
883         bytes calldata data
884     ) external returns (bytes4);
885 }
886 
887 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 /**
895  * @dev Interface of the ERC165 standard, as defined in the
896  * https://eips.ethereum.org/EIPS/eip-165[EIP].
897  *
898  * Implementers can declare support of contract interfaces, which can then be
899  * queried by others ({ERC165Checker}).
900  *
901  * For an implementation, see {ERC165}.
902  */
903 interface IERC165 {
904     /**
905      * @dev Returns true if this contract implements the interface defined by
906      * `interfaceId`. See the corresponding
907      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
908      * to learn more about how these ids are created.
909      *
910      * This function call must use less than 30 000 gas.
911      */
912     function supportsInterface(bytes4 interfaceId) external view returns (bool);
913 }
914 
915 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @dev Required interface of an ERC721 compliant contract.
925  */
926 interface IERC721 is IERC165 {
927     /**
928      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
929      */
930     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
931 
932     /**
933      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
934      */
935     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
936 
937     /**
938      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
939      */
940     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
941 
942     /**
943      * @dev Returns the number of tokens in ``owner``'s account.
944      */
945     function balanceOf(address owner) external view returns (uint256 balance);
946 
947     /**
948      * @dev Returns the owner of the `tokenId` token.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function ownerOf(uint256 tokenId) external view returns (address owner);
955 
956     /**
957      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
958      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
959      *
960      * Requirements:
961      *
962      * - `from` cannot be the zero address.
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must exist and be owned by `from`.
965      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
967      *
968      * Emits a {Transfer} event.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId
974     ) external;
975 
976     /**
977      * @dev Transfers `tokenId` token from `from` to `to`.
978      *
979      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
980      *
981      * Requirements:
982      *
983      * - `from` cannot be the zero address.
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must be owned by `from`.
986      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
987      *
988      * Emits a {Transfer} event.
989      */
990     function transferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) external;
995 
996     /**
997      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
998      * The approval is cleared when the token is transferred.
999      *
1000      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1001      *
1002      * Requirements:
1003      *
1004      * - The caller must own the token or be an approved operator.
1005      * - `tokenId` must exist.
1006      *
1007      * Emits an {Approval} event.
1008      */
1009     function approve(address to, uint256 tokenId) external;
1010 
1011     /**
1012      * @dev Returns the account approved for `tokenId` token.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      */
1018     function getApproved(uint256 tokenId) external view returns (address operator);
1019 
1020     /**
1021      * @dev Approve or remove `operator` as an operator for the caller.
1022      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1023      *
1024      * Requirements:
1025      *
1026      * - The `operator` cannot be the caller.
1027      *
1028      * Emits an {ApprovalForAll} event.
1029      */
1030     function setApprovalForAll(address operator, bool _approved) external;
1031 
1032     /**
1033      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1034      *
1035      * See {setApprovalForAll}
1036      */
1037     function isApprovedForAll(address owner, address operator) external view returns (bool);
1038 
1039     /**
1040      * @dev Safely transfers `tokenId` token from `from` to `to`.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must exist and be owned by `from`.
1047      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes calldata data
1057     ) external;
1058 }
1059 
1060 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1061 
1062 
1063 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 
1068 /**
1069  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1070  * @dev See https://eips.ethereum.org/EIPS/eip-721
1071  */
1072 interface IERC721Enumerable is IERC721 {
1073     /**
1074      * @dev Returns the total amount of tokens stored by the contract.
1075      */
1076     function totalSupply() external view returns (uint256);
1077 
1078     /**
1079      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1080      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1081      */
1082     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1083 
1084     /**
1085      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1086      * Use along with {totalSupply} to enumerate all tokens.
1087      */
1088     function tokenByIndex(uint256 index) external view returns (uint256);
1089 }
1090 
1091 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1092 
1093 
1094 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
1095 
1096 pragma solidity ^0.8.0;
1097 
1098 /**
1099  * @dev Interface of the ERC20 standard as defined in the EIP.
1100  */
1101 interface IERC20 {
1102     /**
1103      * @dev Returns the amount of tokens in existence.
1104      */
1105     function totalSupply() external view returns (uint256);
1106 
1107     /**
1108      * @dev Returns the amount of tokens owned by `account`.
1109      */
1110     function balanceOf(address account) external view returns (uint256);
1111 
1112     /**
1113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1114      *
1115      * Returns a boolean value indicating whether the operation succeeded.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function transfer(address recipient, uint256 amount) external returns (bool);
1120 
1121     /**
1122      * @dev Returns the remaining number of tokens that `spender` will be
1123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1124      * zero by default.
1125      *
1126      * This value changes when {approve} or {transferFrom} are called.
1127      */
1128     function allowance(address owner, address spender) external view returns (uint256);
1129 
1130     /**
1131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1132      *
1133      * Returns a boolean value indicating whether the operation succeeded.
1134      *
1135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1136      * that someone may use both the old and the new allowance by unfortunate
1137      * transaction ordering. One possible solution to mitigate this race
1138      * condition is to first reduce the spender's allowance to 0 and set the
1139      * desired value afterwards:
1140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1141      *
1142      * Emits an {Approval} event.
1143      */
1144     function approve(address spender, uint256 amount) external returns (bool);
1145 
1146     /**
1147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1148      * allowance mechanism. `amount` is then deducted from the caller's
1149      * allowance.
1150      *
1151      * Returns a boolean value indicating whether the operation succeeded.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function transferFrom(
1156         address sender,
1157         address recipient,
1158         uint256 amount
1159     ) external returns (bool);
1160 
1161     /**
1162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1163      * another (`to`).
1164      *
1165      * Note that `value` may be zero.
1166      */
1167     event Transfer(address indexed from, address indexed to, uint256 value);
1168 
1169     /**
1170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1171      * a call to {approve}. `value` is the new allowance.
1172      */
1173     event Approval(address indexed owner, address indexed spender, uint256 value);
1174 }
1175 
1176 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1177 
1178 
1179 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 /**
1184  * @dev Contract module that helps prevent reentrant calls to a function.
1185  *
1186  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1187  * available, which can be applied to functions to make sure there are no nested
1188  * (reentrant) calls to them.
1189  *
1190  * Note that because there is a single `nonReentrant` guard, functions marked as
1191  * `nonReentrant` may not call one another. This can be worked around by making
1192  * those functions `private`, and then adding `external` `nonReentrant` entry
1193  * points to them.
1194  *
1195  * TIP: If you would like to learn more about reentrancy and alternative ways
1196  * to protect against it, check out our blog post
1197  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1198  */
1199 abstract contract ReentrancyGuard {
1200     // Booleans are more expensive than uint256 or any type that takes up a full
1201     // word because each write operation emits an extra SLOAD to first read the
1202     // slot's contents, replace the bits taken up by the boolean, and then write
1203     // back. This is the compiler's defense against contract upgrades and
1204     // pointer aliasing, and it cannot be disabled.
1205 
1206     // The values being non-zero value makes deployment a bit more expensive,
1207     // but in exchange the refund on every call to nonReentrant will be lower in
1208     // amount. Since refunds are capped to a percentage of the total
1209     // transaction's gas, it is best to keep them low in cases like this one, to
1210     // increase the likelihood of the full refund coming into effect.
1211     uint256 private constant _NOT_ENTERED = 1;
1212     uint256 private constant _ENTERED = 2;
1213 
1214     uint256 private _status;
1215 
1216     constructor() {
1217         _status = _NOT_ENTERED;
1218     }
1219 
1220     /**
1221      * @dev Prevents a contract from calling itself, directly or indirectly.
1222      * Calling a `nonReentrant` function from another `nonReentrant`
1223      * function is not supported. It is possible to prevent this from happening
1224      * by making the `nonReentrant` function external, and making it call a
1225      * `private` function that does the actual work.
1226      */
1227     modifier nonReentrant() {
1228         // On the first call to nonReentrant, _notEntered will be true
1229         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1230 
1231         // Any calls to nonReentrant after this point will fail
1232         _status = _ENTERED;
1233 
1234         _;
1235 
1236         // By storing the original value once again, a refund is triggered (see
1237         // https://eips.ethereum.org/EIPS/eip-2200)
1238         _status = _NOT_ENTERED;
1239     }
1240 }
1241 
1242 // File: @openzeppelin/contracts/utils/Context.sol
1243 
1244 
1245 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 /**
1250  * @dev Provides information about the current execution context, including the
1251  * sender of the transaction and its data. While these are generally available
1252  * via msg.sender and msg.data, they should not be accessed in such a direct
1253  * manner, since when dealing with meta-transactions the account sending and
1254  * paying for execution may not be the actual sender (as far as an application
1255  * is concerned).
1256  *
1257  * This contract is only required for intermediate, library-like contracts.
1258  */
1259 abstract contract Context {
1260     function _msgSender() internal view virtual returns (address) {
1261         return msg.sender;
1262     }
1263 
1264     function _msgData() internal view virtual returns (bytes calldata) {
1265         return msg.data;
1266     }
1267 }
1268 
1269 // File: @openzeppelin/contracts/security/Pausable.sol
1270 
1271 
1272 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
1273 
1274 pragma solidity ^0.8.0;
1275 
1276 
1277 /**
1278  * @dev Contract module which allows children to implement an emergency stop
1279  * mechanism that can be triggered by an authorized account.
1280  *
1281  * This module is used through inheritance. It will make available the
1282  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1283  * the functions of your contract. Note that they will not be pausable by
1284  * simply including this module, only once the modifiers are put in place.
1285  */
1286 abstract contract Pausable is Context {
1287     /**
1288      * @dev Emitted when the pause is triggered by `account`.
1289      */
1290     event Paused(address account);
1291 
1292     /**
1293      * @dev Emitted when the pause is lifted by `account`.
1294      */
1295     event Unpaused(address account);
1296 
1297     bool private _paused;
1298 
1299     /**
1300      * @dev Initializes the contract in unpaused state.
1301      */
1302     constructor() {
1303         _paused = false;
1304     }
1305 
1306     /**
1307      * @dev Returns true if the contract is paused, and false otherwise.
1308      */
1309     function paused() public view virtual returns (bool) {
1310         return _paused;
1311     }
1312 
1313     /**
1314      * @dev Modifier to make a function callable only when the contract is not paused.
1315      *
1316      * Requirements:
1317      *
1318      * - The contract must not be paused.
1319      */
1320     modifier whenNotPaused() {
1321         require(!paused(), "Pausable: paused");
1322         _;
1323     }
1324 
1325     /**
1326      * @dev Modifier to make a function callable only when the contract is paused.
1327      *
1328      * Requirements:
1329      *
1330      * - The contract must be paused.
1331      */
1332     modifier whenPaused() {
1333         require(paused(), "Pausable: not paused");
1334         _;
1335     }
1336 
1337     /**
1338      * @dev Triggers stopped state.
1339      *
1340      * Requirements:
1341      *
1342      * - The contract must not be paused.
1343      */
1344     function _pause() internal virtual whenNotPaused {
1345         _paused = true;
1346         emit Paused(_msgSender());
1347     }
1348 
1349     /**
1350      * @dev Returns to normal state.
1351      *
1352      * Requirements:
1353      *
1354      * - The contract must be paused.
1355      */
1356     function _unpause() internal virtual whenPaused {
1357         _paused = false;
1358         emit Unpaused(_msgSender());
1359     }
1360 }
1361 
1362 // File: @openzeppelin/contracts/access/Ownable.sol
1363 
1364 
1365 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1366 
1367 pragma solidity ^0.8.0;
1368 
1369 
1370 /**
1371  * @dev Contract module which provides a basic access control mechanism, where
1372  * there is an account (an owner) that can be granted exclusive access to
1373  * specific functions.
1374  *
1375  * By default, the owner account will be the one that deploys the contract. This
1376  * can later be changed with {transferOwnership}.
1377  *
1378  * This module is used through inheritance. It will make available the modifier
1379  * `onlyOwner`, which can be applied to your functions to restrict their use to
1380  * the owner.
1381  */
1382 abstract contract Ownable is Context {
1383     address private _owner;
1384 
1385     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1386 
1387     /**
1388      * @dev Initializes the contract setting the deployer as the initial owner.
1389      */
1390     constructor() {
1391         _transferOwnership(_msgSender());
1392     }
1393 
1394     /**
1395      * @dev Returns the address of the current owner.
1396      */
1397     function owner() public view virtual returns (address) {
1398         return _owner;
1399     }
1400 
1401     /**
1402      * @dev Throws if called by any account other than the owner.
1403      */
1404     modifier onlyOwner() {
1405         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1406         _;
1407     }
1408 
1409     /**
1410      * @dev Leaves the contract without owner. It will not be possible to call
1411      * `onlyOwner` functions anymore. Can only be called by the current owner.
1412      *
1413      * NOTE: Renouncing ownership will leave the contract without an owner,
1414      * thereby removing any functionality that is only available to the owner.
1415      */
1416     function renounceOwnership() public virtual onlyOwner {
1417         _transferOwnership(address(0));
1418     }
1419 
1420     /**
1421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1422      * Can only be called by the current owner.
1423      */
1424     function transferOwnership(address newOwner) public virtual onlyOwner {
1425         require(newOwner != address(0), "Ownable: new owner is the zero address");
1426         _transferOwnership(newOwner);
1427     }
1428 
1429     /**
1430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1431      * Internal function without access restriction.
1432      */
1433     function _transferOwnership(address newOwner) internal virtual {
1434         address oldOwner = _owner;
1435         _owner = newOwner;
1436         emit OwnershipTransferred(oldOwner, newOwner);
1437     }
1438 }
1439 
1440 // File: contracts/CompanionFarm.sol
1441 
1442 
1443 
1444 pragma solidity ^0.8.10;
1445 
1446 
1447 
1448 
1449 
1450 
1451 
1452 
1453 
1454 
1455 
1456 contract CompanionFarm is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1457     using EnumerableSet for EnumerableSet.UintSet;
1458 
1459     // Vault and $COMPANIONSHIP addresses
1460     address public compboxAddress;
1461     address public compshipAddress;
1462 
1463     // $COMPANIONSHIP rewards expiration
1464     uint256 public expiration;
1465 
1466     // Rate governs how often you receive $COMPANIONSHIP
1467     uint256 public rewardRate;
1468 
1469     // Track staked companions and last reward date
1470     mapping(address => EnumerableSet.UintSet) private _deposits;
1471     mapping(address => mapping(uint256 => uint256)) public _lastClaimBlocks;
1472 
1473     constructor(
1474         address _compboxAddress,
1475         address _compshipAddress,
1476         uint256 _rewardRate,
1477         uint256 _expiration
1478     ) {
1479         compboxAddress = _compboxAddress;
1480         compshipAddress = _compshipAddress;
1481         rewardRate = _rewardRate;
1482         expiration = block.number + _expiration;
1483         _pause();
1484     }
1485 
1486     // List staked companions
1487     function depositsOf(address account)
1488         external
1489         view
1490         returns (uint256[] memory)
1491     {
1492         EnumerableSet.UintSet storage depositSet = _deposits[account];
1493         uint256[] memory tokenIds = new uint256[](depositSet.length());
1494 
1495         for (uint256 i; i < depositSet.length(); i++) {
1496             tokenIds[i] = depositSet.at(i);
1497         }
1498 
1499         return tokenIds;
1500     }
1501 
1502     // Calculate reward for all staked companions
1503     function calculateRewards(address account, uint256[] memory tokenIds)
1504         public
1505         view
1506         returns (uint256[] memory rewards)
1507     {
1508         rewards = new uint256[](tokenIds.length);
1509 
1510         for (uint256 i; i < tokenIds.length; i++) {
1511             uint256 tokenId = tokenIds[i];
1512             rewards[i] =
1513                 rewardRate *
1514                 (_deposits[account].contains(tokenId) ? 1 : 0) *
1515                 (Math.min(block.number, expiration) -
1516                     _lastClaimBlocks[account][tokenId]);
1517         }
1518 
1519         return rewards;
1520     }
1521 
1522     // Calculate reward for specific companions
1523     function calculateReward(address account, uint256 tokenId)
1524         public
1525         view
1526         returns (uint256)
1527     {
1528         require(
1529             Math.min(block.number, expiration) >
1530                 _lastClaimBlocks[account][tokenId],
1531             "staking rewards have ended"
1532         );
1533         return
1534             rewardRate *
1535             (_deposits[account].contains(tokenId) ? 1 : 0) *
1536             (Math.min(block.number, expiration) -
1537                 _lastClaimBlocks[account][tokenId]);
1538     }
1539 
1540     // Claim rewards for all staked companions
1541     function claimRewards(uint256[] calldata tokenIds) public whenNotPaused {
1542         uint256 reward;
1543         uint256 blockCur = Math.min(block.number, expiration);
1544 
1545         for (uint256 i; i < tokenIds.length; i++) {
1546             reward += calculateReward(msg.sender, tokenIds[i]);
1547             _lastClaimBlocks[msg.sender][tokenIds[i]] = blockCur;
1548         }
1549 
1550         if (reward > 0) {
1551             IERC20(compshipAddress).transfer(msg.sender, reward);
1552         }
1553     }
1554 
1555     // Stake companions (deposit ERD721)
1556     function deposit(uint256[] calldata tokenIds) external whenNotPaused {
1557         require(msg.sender != compboxAddress, "invalid address for staking");
1558         claimRewards(tokenIds);
1559 
1560         for (uint256 i; i < tokenIds.length; i++) {
1561             IERC721(compboxAddress).safeTransferFrom(
1562                 msg.sender,
1563                 address(this),
1564                 tokenIds[i],
1565                 ""
1566             );
1567             _deposits[msg.sender].add(tokenIds[i]);
1568         }
1569     }
1570 
1571     // Unstake companions (withdrawal ERC721)
1572     function withdraw(uint256[] calldata tokenIds)
1573         external
1574         whenNotPaused
1575         nonReentrant
1576     {
1577         claimRewards(tokenIds);
1578         for (uint256 i; i < tokenIds.length; i++) {
1579             require(
1580                 _deposits[msg.sender].contains(tokenIds[i]),
1581                 "zombie not staked or not owned"
1582             );
1583             _deposits[msg.sender].remove(tokenIds[i]);
1584             IERC721(compboxAddress).safeTransferFrom(
1585                 address(this),
1586                 msg.sender,
1587                 tokenIds[i],
1588                 ""
1589             );
1590         }
1591     }
1592 
1593     // (Owner) Withdrawal COMPANIONSHIP
1594     function withdrawTokens() external onlyOwner {
1595         uint256 tokenSupply = IERC20(compshipAddress).balanceOf(address(this));
1596         IERC20(compshipAddress).transfer(msg.sender, tokenSupply);
1597     }
1598 
1599     // (Owner) Set a multiplier for how many tokens to earn each time a block passes.
1600     function setRate(uint256 _rewardRate) public onlyOwner {
1601         rewardRate = _rewardRate;
1602     }
1603 
1604     // (Owner) Set this to a block to disable the ability to continue accruing tokens past that block number.
1605     function setExpiration(uint256 _expiration) public onlyOwner {
1606         expiration = block.number + _expiration;
1607     }
1608 
1609     // (Owner) Public accessor methods for pausing
1610     function pause() public onlyOwner {
1611         _pause();
1612     }
1613 
1614     function unpause() public onlyOwner {
1615         _unpause();
1616     }
1617 
1618     // Support ERC721 transfer
1619     function onERC721Received(
1620         address,
1621         address,
1622         uint256,
1623         bytes calldata
1624     ) external pure override returns (bytes4) {
1625         return IERC721Receiver.onERC721Received.selector;
1626     }
1627 }