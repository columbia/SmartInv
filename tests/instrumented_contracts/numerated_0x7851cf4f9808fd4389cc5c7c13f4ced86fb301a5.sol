1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: contracts/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  */
44 abstract contract OperatorFilterer {
45     error OperatorNotAllowed(address operator);
46 
47     IOperatorFilterRegistry constant OPERATOR_FILTER_REGISTRY =
48         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
49 
50     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
51         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
52         // will not revert, but the contract will need to be registered with the registry once it is deployed in
53         // order for the modifier to filter addresses.
54         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
55             if (subscribe) {
56                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
57             } else {
58                 if (subscriptionOrRegistrantToCopy != address(0)) {
59                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
60                 } else {
61                     OPERATOR_FILTER_REGISTRY.register(address(this));
62                 }
63             }
64         }
65     }
66 
67     modifier onlyAllowedOperator(address from) virtual {
68         // Check registry code length to facilitate testing in environments without a deployed registry.
69         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
70             // Allow spending tokens from addresses with balance
71             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
72             // from an EOA.
73             if (from == msg.sender) {
74                 _;
75                 return;
76             }
77             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
78                 revert OperatorNotAllowed(msg.sender);
79             }
80         }
81         _;
82     }
83 
84     modifier onlyAllowedOperatorApproval(address operator) virtual {
85         // Check registry code length to facilitate testing in environments without a deployed registry.
86         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
87             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
88                 revert OperatorNotAllowed(operator);
89             }
90         }
91         _;
92     }
93 }
94 
95 // File: contracts/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Library for managing
120  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
121  * types.
122  *
123  * Sets have the following properties:
124  *
125  * - Elements are added, removed, and checked for existence in constant time
126  * (O(1)).
127  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
128  *
129  * ```
130  * contract Example {
131  *     // Add the library methods
132  *     using EnumerableSet for EnumerableSet.AddressSet;
133  *
134  *     // Declare a set state variable
135  *     EnumerableSet.AddressSet private mySet;
136  * }
137  * ```
138  *
139  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
140  * and `uint256` (`UintSet`) are supported.
141  *
142  * [WARNING]
143  * ====
144  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
145  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
146  *
147  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
148  * ====
149  */
150 library EnumerableSet {
151     // To implement this library for multiple types with as little code
152     // repetition as possible, we write it in terms of a generic Set type with
153     // bytes32 values.
154     // The Set implementation uses private functions, and user-facing
155     // implementations (such as AddressSet) are just wrappers around the
156     // underlying Set.
157     // This means that we can only create new EnumerableSets for types that fit
158     // in bytes32.
159 
160     struct Set {
161         // Storage of set values
162         bytes32[] _values;
163         // Position of the value in the `values` array, plus 1 because index 0
164         // means a value is not in the set.
165         mapping(bytes32 => uint256) _indexes;
166     }
167 
168     /**
169      * @dev Add a value to a set. O(1).
170      *
171      * Returns true if the value was added to the set, that is if it was not
172      * already present.
173      */
174     function _add(Set storage set, bytes32 value) private returns (bool) {
175         if (!_contains(set, value)) {
176             set._values.push(value);
177             // The value is stored at length-1, but we add 1 to all indexes
178             // and use 0 as a sentinel value
179             set._indexes[value] = set._values.length;
180             return true;
181         } else {
182             return false;
183         }
184     }
185 
186     /**
187      * @dev Removes a value from a set. O(1).
188      *
189      * Returns true if the value was removed from the set, that is if it was
190      * present.
191      */
192     function _remove(Set storage set, bytes32 value) private returns (bool) {
193         // We read and store the value's index to prevent multiple reads from the same storage slot
194         uint256 valueIndex = set._indexes[value];
195 
196         if (valueIndex != 0) {
197             // Equivalent to contains(set, value)
198             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
199             // the array, and then remove the last element (sometimes called as 'swap and pop').
200             // This modifies the order of the array, as noted in {at}.
201 
202             uint256 toDeleteIndex = valueIndex - 1;
203             uint256 lastIndex = set._values.length - 1;
204 
205             if (lastIndex != toDeleteIndex) {
206                 bytes32 lastValue = set._values[lastIndex];
207 
208                 // Move the last value to the index where the value to delete is
209                 set._values[toDeleteIndex] = lastValue;
210                 // Update the index for the moved value
211                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
212             }
213 
214             // Delete the slot where the moved value was stored
215             set._values.pop();
216 
217             // Delete the index for the deleted slot
218             delete set._indexes[value];
219 
220             return true;
221         } else {
222             return false;
223         }
224     }
225 
226     /**
227      * @dev Returns true if the value is in the set. O(1).
228      */
229     function _contains(Set storage set, bytes32 value) private view returns (bool) {
230         return set._indexes[value] != 0;
231     }
232 
233     /**
234      * @dev Returns the number of values on the set. O(1).
235      */
236     function _length(Set storage set) private view returns (uint256) {
237         return set._values.length;
238     }
239 
240     /**
241      * @dev Returns the value stored at position `index` in the set. O(1).
242      *
243      * Note that there are no guarantees on the ordering of values inside the
244      * array, and it may change when more values are added or removed.
245      *
246      * Requirements:
247      *
248      * - `index` must be strictly less than {length}.
249      */
250     function _at(Set storage set, uint256 index) private view returns (bytes32) {
251         return set._values[index];
252     }
253 
254     /**
255      * @dev Return the entire set in an array
256      *
257      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
258      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
259      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
260      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
261      */
262     function _values(Set storage set) private view returns (bytes32[] memory) {
263         return set._values;
264     }
265 
266     // Bytes32Set
267 
268     struct Bytes32Set {
269         Set _inner;
270     }
271 
272     /**
273      * @dev Add a value to a set. O(1).
274      *
275      * Returns true if the value was added to the set, that is if it was not
276      * already present.
277      */
278     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
279         return _add(set._inner, value);
280     }
281 
282     /**
283      * @dev Removes a value from a set. O(1).
284      *
285      * Returns true if the value was removed from the set, that is if it was
286      * present.
287      */
288     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
289         return _remove(set._inner, value);
290     }
291 
292     /**
293      * @dev Returns true if the value is in the set. O(1).
294      */
295     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
296         return _contains(set._inner, value);
297     }
298 
299     /**
300      * @dev Returns the number of values in the set. O(1).
301      */
302     function length(Bytes32Set storage set) internal view returns (uint256) {
303         return _length(set._inner);
304     }
305 
306     /**
307      * @dev Returns the value stored at position `index` in the set. O(1).
308      *
309      * Note that there are no guarantees on the ordering of values inside the
310      * array, and it may change when more values are added or removed.
311      *
312      * Requirements:
313      *
314      * - `index` must be strictly less than {length}.
315      */
316     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
317         return _at(set._inner, index);
318     }
319 
320     /**
321      * @dev Return the entire set in an array
322      *
323      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
324      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
325      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
326      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
327      */
328     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
329         return _values(set._inner);
330     }
331 
332     // AddressSet
333 
334     struct AddressSet {
335         Set _inner;
336     }
337 
338     /**
339      * @dev Add a value to a set. O(1).
340      *
341      * Returns true if the value was added to the set, that is if it was not
342      * already present.
343      */
344     function add(AddressSet storage set, address value) internal returns (bool) {
345         return _add(set._inner, bytes32(uint256(uint160(value))));
346     }
347 
348     /**
349      * @dev Removes a value from a set. O(1).
350      *
351      * Returns true if the value was removed from the set, that is if it was
352      * present.
353      */
354     function remove(AddressSet storage set, address value) internal returns (bool) {
355         return _remove(set._inner, bytes32(uint256(uint160(value))));
356     }
357 
358     /**
359      * @dev Returns true if the value is in the set. O(1).
360      */
361     function contains(AddressSet storage set, address value) internal view returns (bool) {
362         return _contains(set._inner, bytes32(uint256(uint160(value))));
363     }
364 
365     /**
366      * @dev Returns the number of values in the set. O(1).
367      */
368     function length(AddressSet storage set) internal view returns (uint256) {
369         return _length(set._inner);
370     }
371 
372     /**
373      * @dev Returns the value stored at position `index` in the set. O(1).
374      *
375      * Note that there are no guarantees on the ordering of values inside the
376      * array, and it may change when more values are added or removed.
377      *
378      * Requirements:
379      *
380      * - `index` must be strictly less than {length}.
381      */
382     function at(AddressSet storage set, uint256 index) internal view returns (address) {
383         return address(uint160(uint256(_at(set._inner, index))));
384     }
385 
386     /**
387      * @dev Return the entire set in an array
388      *
389      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
390      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
391      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
392      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
393      */
394     function values(AddressSet storage set) internal view returns (address[] memory) {
395         bytes32[] memory store = _values(set._inner);
396         address[] memory result;
397 
398         /// @solidity memory-safe-assembly
399         assembly {
400             result := store
401         }
402 
403         return result;
404     }
405 
406     // UintSet
407 
408     struct UintSet {
409         Set _inner;
410     }
411 
412     /**
413      * @dev Add a value to a set. O(1).
414      *
415      * Returns true if the value was added to the set, that is if it was not
416      * already present.
417      */
418     function add(UintSet storage set, uint256 value) internal returns (bool) {
419         return _add(set._inner, bytes32(value));
420     }
421 
422     /**
423      * @dev Removes a value from a set. O(1).
424      *
425      * Returns true if the value was removed from the set, that is if it was
426      * present.
427      */
428     function remove(UintSet storage set, uint256 value) internal returns (bool) {
429         return _remove(set._inner, bytes32(value));
430     }
431 
432     /**
433      * @dev Returns true if the value is in the set. O(1).
434      */
435     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
436         return _contains(set._inner, bytes32(value));
437     }
438 
439     /**
440      * @dev Returns the number of values on the set. O(1).
441      */
442     function length(UintSet storage set) internal view returns (uint256) {
443         return _length(set._inner);
444     }
445 
446     /**
447      * @dev Returns the value stored at position `index` in the set. O(1).
448      *
449      * Note that there are no guarantees on the ordering of values inside the
450      * array, and it may change when more values are added or removed.
451      *
452      * Requirements:
453      *
454      * - `index` must be strictly less than {length}.
455      */
456     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
457         return uint256(_at(set._inner, index));
458     }
459 
460     /**
461      * @dev Return the entire set in an array
462      *
463      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
464      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
465      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
466      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
467      */
468     function values(UintSet storage set) internal view returns (uint256[] memory) {
469         bytes32[] memory store = _values(set._inner);
470         uint256[] memory result;
471 
472         /// @solidity memory-safe-assembly
473         assembly {
474             result := store
475         }
476 
477         return result;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
482 
483 
484 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 // CAUTION
489 // This version of SafeMath should only be used with Solidity 0.8 or later,
490 // because it relies on the compiler's built in overflow checks.
491 
492 /**
493  * @dev Wrappers over Solidity's arithmetic operations.
494  *
495  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
496  * now has built in overflow checking.
497  */
498 library SafeMath {
499     /**
500      * @dev Returns the addition of two unsigned integers, with an overflow flag.
501      *
502      * _Available since v3.4._
503      */
504     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
505         unchecked {
506             uint256 c = a + b;
507             if (c < a) return (false, 0);
508             return (true, c);
509         }
510     }
511 
512     /**
513      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
514      *
515      * _Available since v3.4._
516      */
517     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
518         unchecked {
519             if (b > a) return (false, 0);
520             return (true, a - b);
521         }
522     }
523 
524     /**
525      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
526      *
527      * _Available since v3.4._
528      */
529     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
530         unchecked {
531             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
532             // benefit is lost if 'b' is also tested.
533             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
534             if (a == 0) return (true, 0);
535             uint256 c = a * b;
536             if (c / a != b) return (false, 0);
537             return (true, c);
538         }
539     }
540 
541     /**
542      * @dev Returns the division of two unsigned integers, with a division by zero flag.
543      *
544      * _Available since v3.4._
545      */
546     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
547         unchecked {
548             if (b == 0) return (false, 0);
549             return (true, a / b);
550         }
551     }
552 
553     /**
554      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
555      *
556      * _Available since v3.4._
557      */
558     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
559         unchecked {
560             if (b == 0) return (false, 0);
561             return (true, a % b);
562         }
563     }
564 
565     /**
566      * @dev Returns the addition of two unsigned integers, reverting on
567      * overflow.
568      *
569      * Counterpart to Solidity's `+` operator.
570      *
571      * Requirements:
572      *
573      * - Addition cannot overflow.
574      */
575     function add(uint256 a, uint256 b) internal pure returns (uint256) {
576         return a + b;
577     }
578 
579     /**
580      * @dev Returns the subtraction of two unsigned integers, reverting on
581      * overflow (when the result is negative).
582      *
583      * Counterpart to Solidity's `-` operator.
584      *
585      * Requirements:
586      *
587      * - Subtraction cannot overflow.
588      */
589     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
590         return a - b;
591     }
592 
593     /**
594      * @dev Returns the multiplication of two unsigned integers, reverting on
595      * overflow.
596      *
597      * Counterpart to Solidity's `*` operator.
598      *
599      * Requirements:
600      *
601      * - Multiplication cannot overflow.
602      */
603     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
604         return a * b;
605     }
606 
607     /**
608      * @dev Returns the integer division of two unsigned integers, reverting on
609      * division by zero. The result is rounded towards zero.
610      *
611      * Counterpart to Solidity's `/` operator.
612      *
613      * Requirements:
614      *
615      * - The divisor cannot be zero.
616      */
617     function div(uint256 a, uint256 b) internal pure returns (uint256) {
618         return a / b;
619     }
620 
621     /**
622      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
623      * reverting when dividing by zero.
624      *
625      * Counterpart to Solidity's `%` operator. This function uses a `revert`
626      * opcode (which leaves remaining gas untouched) while Solidity uses an
627      * invalid opcode to revert (consuming all remaining gas).
628      *
629      * Requirements:
630      *
631      * - The divisor cannot be zero.
632      */
633     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
634         return a % b;
635     }
636 
637     /**
638      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
639      * overflow (when the result is negative).
640      *
641      * CAUTION: This function is deprecated because it requires allocating memory for the error
642      * message unnecessarily. For custom revert reasons use {trySub}.
643      *
644      * Counterpart to Solidity's `-` operator.
645      *
646      * Requirements:
647      *
648      * - Subtraction cannot overflow.
649      */
650     function sub(
651         uint256 a,
652         uint256 b,
653         string memory errorMessage
654     ) internal pure returns (uint256) {
655         unchecked {
656             require(b <= a, errorMessage);
657             return a - b;
658         }
659     }
660 
661     /**
662      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
663      * division by zero. The result is rounded towards zero.
664      *
665      * Counterpart to Solidity's `/` operator. Note: this function uses a
666      * `revert` opcode (which leaves remaining gas untouched) while Solidity
667      * uses an invalid opcode to revert (consuming all remaining gas).
668      *
669      * Requirements:
670      *
671      * - The divisor cannot be zero.
672      */
673     function div(
674         uint256 a,
675         uint256 b,
676         string memory errorMessage
677     ) internal pure returns (uint256) {
678         unchecked {
679             require(b > 0, errorMessage);
680             return a / b;
681         }
682     }
683 
684     /**
685      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
686      * reverting with custom message when dividing by zero.
687      *
688      * CAUTION: This function is deprecated because it requires allocating memory for the error
689      * message unnecessarily. For custom revert reasons use {tryMod}.
690      *
691      * Counterpart to Solidity's `%` operator. This function uses a `revert`
692      * opcode (which leaves remaining gas untouched) while Solidity uses an
693      * invalid opcode to revert (consuming all remaining gas).
694      *
695      * Requirements:
696      *
697      * - The divisor cannot be zero.
698      */
699     function mod(
700         uint256 a,
701         uint256 b,
702         string memory errorMessage
703     ) internal pure returns (uint256) {
704         unchecked {
705             require(b > 0, errorMessage);
706             return a % b;
707         }
708     }
709 }
710 
711 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @dev Contract module that helps prevent reentrant calls to a function.
720  *
721  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
722  * available, which can be applied to functions to make sure there are no nested
723  * (reentrant) calls to them.
724  *
725  * Note that because there is a single `nonReentrant` guard, functions marked as
726  * `nonReentrant` may not call one another. This can be worked around by making
727  * those functions `private`, and then adding `external` `nonReentrant` entry
728  * points to them.
729  *
730  * TIP: If you would like to learn more about reentrancy and alternative ways
731  * to protect against it, check out our blog post
732  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
733  */
734 abstract contract ReentrancyGuard {
735     // Booleans are more expensive than uint256 or any type that takes up a full
736     // word because each write operation emits an extra SLOAD to first read the
737     // slot's contents, replace the bits taken up by the boolean, and then write
738     // back. This is the compiler's defense against contract upgrades and
739     // pointer aliasing, and it cannot be disabled.
740 
741     // The values being non-zero value makes deployment a bit more expensive,
742     // but in exchange the refund on every call to nonReentrant will be lower in
743     // amount. Since refunds are capped to a percentage of the total
744     // transaction's gas, it is best to keep them low in cases like this one, to
745     // increase the likelihood of the full refund coming into effect.
746     uint256 private constant _NOT_ENTERED = 1;
747     uint256 private constant _ENTERED = 2;
748 
749     uint256 private _status;
750 
751     constructor() {
752         _status = _NOT_ENTERED;
753     }
754 
755     /**
756      * @dev Prevents a contract from calling itself, directly or indirectly.
757      * Calling a `nonReentrant` function from another `nonReentrant`
758      * function is not supported. It is possible to prevent this from happening
759      * by making the `nonReentrant` function external, and making it call a
760      * `private` function that does the actual work.
761      */
762     modifier nonReentrant() {
763         // On the first call to nonReentrant, _notEntered will be true
764         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
765 
766         // Any calls to nonReentrant after this point will fail
767         _status = _ENTERED;
768 
769         _;
770 
771         // By storing the original value once again, a refund is triggered (see
772         // https://eips.ethereum.org/EIPS/eip-2200)
773         _status = _NOT_ENTERED;
774     }
775 }
776 
777 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
778 
779 
780 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
781 
782 pragma solidity ^0.8.0;
783 
784 /**
785  * @dev These functions deal with verification of Merkle Tree proofs.
786  *
787  * The proofs can be generated using the JavaScript library
788  * https://github.com/miguelmota/merkletreejs[merkletreejs].
789  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
790  *
791  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
792  *
793  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
794  * hashing, or use a hash function other than keccak256 for hashing leaves.
795  * This is because the concatenation of a sorted pair of internal nodes in
796  * the merkle tree could be reinterpreted as a leaf value.
797  */
798 library MerkleProof {
799     /**
800      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
801      * defined by `root`. For this, a `proof` must be provided, containing
802      * sibling hashes on the branch from the leaf to the root of the tree. Each
803      * pair of leaves and each pair of pre-images are assumed to be sorted.
804      */
805     function verify(
806         bytes32[] memory proof,
807         bytes32 root,
808         bytes32 leaf
809     ) internal pure returns (bool) {
810         return processProof(proof, leaf) == root;
811     }
812 
813     /**
814      * @dev Calldata version of {verify}
815      *
816      * _Available since v4.7._
817      */
818     function verifyCalldata(
819         bytes32[] calldata proof,
820         bytes32 root,
821         bytes32 leaf
822     ) internal pure returns (bool) {
823         return processProofCalldata(proof, leaf) == root;
824     }
825 
826     /**
827      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
828      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
829      * hash matches the root of the tree. When processing the proof, the pairs
830      * of leafs & pre-images are assumed to be sorted.
831      *
832      * _Available since v4.4._
833      */
834     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
835         bytes32 computedHash = leaf;
836         for (uint256 i = 0; i < proof.length; i++) {
837             computedHash = _hashPair(computedHash, proof[i]);
838         }
839         return computedHash;
840     }
841 
842     /**
843      * @dev Calldata version of {processProof}
844      *
845      * _Available since v4.7._
846      */
847     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
848         bytes32 computedHash = leaf;
849         for (uint256 i = 0; i < proof.length; i++) {
850             computedHash = _hashPair(computedHash, proof[i]);
851         }
852         return computedHash;
853     }
854 
855     /**
856      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
857      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
858      *
859      * _Available since v4.7._
860      */
861     function multiProofVerify(
862         bytes32[] memory proof,
863         bool[] memory proofFlags,
864         bytes32 root,
865         bytes32[] memory leaves
866     ) internal pure returns (bool) {
867         return processMultiProof(proof, proofFlags, leaves) == root;
868     }
869 
870     /**
871      * @dev Calldata version of {multiProofVerify}
872      *
873      * _Available since v4.7._
874      */
875     function multiProofVerifyCalldata(
876         bytes32[] calldata proof,
877         bool[] calldata proofFlags,
878         bytes32 root,
879         bytes32[] memory leaves
880     ) internal pure returns (bool) {
881         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
882     }
883 
884     /**
885      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
886      * consuming from one or the other at each step according to the instructions given by
887      * `proofFlags`.
888      *
889      * _Available since v4.7._
890      */
891     function processMultiProof(
892         bytes32[] memory proof,
893         bool[] memory proofFlags,
894         bytes32[] memory leaves
895     ) internal pure returns (bytes32 merkleRoot) {
896         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
897         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
898         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
899         // the merkle tree.
900         uint256 leavesLen = leaves.length;
901         uint256 totalHashes = proofFlags.length;
902 
903         // Check proof validity.
904         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
905 
906         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
907         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
908         bytes32[] memory hashes = new bytes32[](totalHashes);
909         uint256 leafPos = 0;
910         uint256 hashPos = 0;
911         uint256 proofPos = 0;
912         // At each step, we compute the next hash using two values:
913         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
914         //   get the next hash.
915         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
916         //   `proof` array.
917         for (uint256 i = 0; i < totalHashes; i++) {
918             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
919             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
920             hashes[i] = _hashPair(a, b);
921         }
922 
923         if (totalHashes > 0) {
924             return hashes[totalHashes - 1];
925         } else if (leavesLen > 0) {
926             return leaves[0];
927         } else {
928             return proof[0];
929         }
930     }
931 
932     /**
933      * @dev Calldata version of {processMultiProof}
934      *
935      * _Available since v4.7._
936      */
937     function processMultiProofCalldata(
938         bytes32[] calldata proof,
939         bool[] calldata proofFlags,
940         bytes32[] memory leaves
941     ) internal pure returns (bytes32 merkleRoot) {
942         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
943         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
944         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
945         // the merkle tree.
946         uint256 leavesLen = leaves.length;
947         uint256 totalHashes = proofFlags.length;
948 
949         // Check proof validity.
950         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
951 
952         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
953         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
954         bytes32[] memory hashes = new bytes32[](totalHashes);
955         uint256 leafPos = 0;
956         uint256 hashPos = 0;
957         uint256 proofPos = 0;
958         // At each step, we compute the next hash using two values:
959         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
960         //   get the next hash.
961         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
962         //   `proof` array.
963         for (uint256 i = 0; i < totalHashes; i++) {
964             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
965             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
966             hashes[i] = _hashPair(a, b);
967         }
968 
969         if (totalHashes > 0) {
970             return hashes[totalHashes - 1];
971         } else if (leavesLen > 0) {
972             return leaves[0];
973         } else {
974             return proof[0];
975         }
976     }
977 
978     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
979         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
980     }
981 
982     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
983         /// @solidity memory-safe-assembly
984         assembly {
985             mstore(0x00, a)
986             mstore(0x20, b)
987             value := keccak256(0x00, 0x40)
988         }
989     }
990 }
991 
992 // File: @openzeppelin/contracts/utils/Strings.sol
993 
994 
995 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
996 
997 pragma solidity ^0.8.0;
998 
999 /**
1000  * @dev String operations.
1001  */
1002 library Strings {
1003     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1004     uint8 private constant _ADDRESS_LENGTH = 20;
1005 
1006     /**
1007      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1008      */
1009     function toString(uint256 value) internal pure returns (string memory) {
1010         // Inspired by OraclizeAPI's implementation - MIT licence
1011         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1012 
1013         if (value == 0) {
1014             return "0";
1015         }
1016         uint256 temp = value;
1017         uint256 digits;
1018         while (temp != 0) {
1019             digits++;
1020             temp /= 10;
1021         }
1022         bytes memory buffer = new bytes(digits);
1023         while (value != 0) {
1024             digits -= 1;
1025             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1026             value /= 10;
1027         }
1028         return string(buffer);
1029     }
1030 
1031     /**
1032      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1033      */
1034     function toHexString(uint256 value) internal pure returns (string memory) {
1035         if (value == 0) {
1036             return "0x00";
1037         }
1038         uint256 temp = value;
1039         uint256 length = 0;
1040         while (temp != 0) {
1041             length++;
1042             temp >>= 8;
1043         }
1044         return toHexString(value, length);
1045     }
1046 
1047     /**
1048      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1049      */
1050     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1051         bytes memory buffer = new bytes(2 * length + 2);
1052         buffer[0] = "0";
1053         buffer[1] = "x";
1054         for (uint256 i = 2 * length + 1; i > 1; --i) {
1055             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1056             value >>= 4;
1057         }
1058         require(value == 0, "Strings: hex length insufficient");
1059         return string(buffer);
1060     }
1061 
1062     /**
1063      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1064      */
1065     function toHexString(address addr) internal pure returns (string memory) {
1066         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1067     }
1068 }
1069 
1070 // File: @openzeppelin/contracts/utils/Context.sol
1071 
1072 
1073 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1074 
1075 pragma solidity ^0.8.0;
1076 
1077 /**
1078  * @dev Provides information about the current execution context, including the
1079  * sender of the transaction and its data. While these are generally available
1080  * via msg.sender and msg.data, they should not be accessed in such a direct
1081  * manner, since when dealing with meta-transactions the account sending and
1082  * paying for execution may not be the actual sender (as far as an application
1083  * is concerned).
1084  *
1085  * This contract is only required for intermediate, library-like contracts.
1086  */
1087 abstract contract Context {
1088     function _msgSender() internal view virtual returns (address) {
1089         return msg.sender;
1090     }
1091 
1092     function _msgData() internal view virtual returns (bytes calldata) {
1093         return msg.data;
1094     }
1095 }
1096 
1097 // File: @openzeppelin/contracts/access/Ownable.sol
1098 
1099 
1100 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1101 
1102 pragma solidity ^0.8.0;
1103 
1104 
1105 /**
1106  * @dev Contract module which provides a basic access control mechanism, where
1107  * there is an account (an owner) that can be granted exclusive access to
1108  * specific functions.
1109  *
1110  * By default, the owner account will be the one that deploys the contract. This
1111  * can later be changed with {transferOwnership}.
1112  *
1113  * This module is used through inheritance. It will make available the modifier
1114  * `onlyOwner`, which can be applied to your functions to restrict their use to
1115  * the owner.
1116  */
1117 abstract contract Ownable is Context {
1118     address private _owner;
1119 
1120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1121 
1122     /**
1123      * @dev Initializes the contract setting the deployer as the initial owner.
1124      */
1125     constructor() {
1126         _transferOwnership(_msgSender());
1127     }
1128 
1129     /**
1130      * @dev Throws if called by any account other than the owner.
1131      */
1132     modifier onlyOwner() {
1133         _checkOwner();
1134         _;
1135     }
1136 
1137     /**
1138      * @dev Returns the address of the current owner.
1139      */
1140     function owner() public view virtual returns (address) {
1141         return _owner;
1142     }
1143 
1144     /**
1145      * @dev Throws if the sender is not the owner.
1146      */
1147     function _checkOwner() internal view virtual {
1148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1149     }
1150 
1151     /**
1152      * @dev Leaves the contract without owner. It will not be possible to call
1153      * `onlyOwner` functions anymore. Can only be called by the current owner.
1154      *
1155      * NOTE: Renouncing ownership will leave the contract without an owner,
1156      * thereby removing any functionality that is only available to the owner.
1157      */
1158     function renounceOwnership() public virtual onlyOwner {
1159         _transferOwnership(address(0));
1160     }
1161 
1162     /**
1163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1164      * Can only be called by the current owner.
1165      */
1166     function transferOwnership(address newOwner) public virtual onlyOwner {
1167         require(newOwner != address(0), "Ownable: new owner is the zero address");
1168         _transferOwnership(newOwner);
1169     }
1170 
1171     /**
1172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1173      * Internal function without access restriction.
1174      */
1175     function _transferOwnership(address newOwner) internal virtual {
1176         address oldOwner = _owner;
1177         _owner = newOwner;
1178         emit OwnershipTransferred(oldOwner, newOwner);
1179     }
1180 }
1181 
1182 // File: @openzeppelin/contracts/utils/Address.sol
1183 
1184 
1185 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1186 
1187 pragma solidity ^0.8.1;
1188 
1189 /**
1190  * @dev Collection of functions related to the address type
1191  */
1192 library Address {
1193     /**
1194      * @dev Returns true if `account` is a contract.
1195      *
1196      * [IMPORTANT]
1197      * ====
1198      * It is unsafe to assume that an address for which this function returns
1199      * false is an externally-owned account (EOA) and not a contract.
1200      *
1201      * Among others, `isContract` will return false for the following
1202      * types of addresses:
1203      *
1204      *  - an externally-owned account
1205      *  - a contract in construction
1206      *  - an address where a contract will be created
1207      *  - an address where a contract lived, but was destroyed
1208      * ====
1209      *
1210      * [IMPORTANT]
1211      * ====
1212      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1213      *
1214      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1215      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1216      * constructor.
1217      * ====
1218      */
1219     function isContract(address account) internal view returns (bool) {
1220         // This method relies on extcodesize/address.code.length, which returns 0
1221         // for contracts in construction, since the code is only stored at the end
1222         // of the constructor execution.
1223 
1224         return account.code.length > 0;
1225     }
1226 
1227     /**
1228      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1229      * `recipient`, forwarding all available gas and reverting on errors.
1230      *
1231      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1232      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1233      * imposed by `transfer`, making them unable to receive funds via
1234      * `transfer`. {sendValue} removes this limitation.
1235      *
1236      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1237      *
1238      * IMPORTANT: because control is transferred to `recipient`, care must be
1239      * taken to not create reentrancy vulnerabilities. Consider using
1240      * {ReentrancyGuard} or the
1241      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1242      */
1243     function sendValue(address payable recipient, uint256 amount) internal {
1244         require(address(this).balance >= amount, "Address: insufficient balance");
1245 
1246         (bool success, ) = recipient.call{value: amount}("");
1247         require(success, "Address: unable to send value, recipient may have reverted");
1248     }
1249 
1250     /**
1251      * @dev Performs a Solidity function call using a low level `call`. A
1252      * plain `call` is an unsafe replacement for a function call: use this
1253      * function instead.
1254      *
1255      * If `target` reverts with a revert reason, it is bubbled up by this
1256      * function (like regular Solidity function calls).
1257      *
1258      * Returns the raw returned data. To convert to the expected return value,
1259      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1260      *
1261      * Requirements:
1262      *
1263      * - `target` must be a contract.
1264      * - calling `target` with `data` must not revert.
1265      *
1266      * _Available since v3.1._
1267      */
1268     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1269         return functionCall(target, data, "Address: low-level call failed");
1270     }
1271 
1272     /**
1273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1274      * `errorMessage` as a fallback revert reason when `target` reverts.
1275      *
1276      * _Available since v3.1._
1277      */
1278     function functionCall(
1279         address target,
1280         bytes memory data,
1281         string memory errorMessage
1282     ) internal returns (bytes memory) {
1283         return functionCallWithValue(target, data, 0, errorMessage);
1284     }
1285 
1286     /**
1287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1288      * but also transferring `value` wei to `target`.
1289      *
1290      * Requirements:
1291      *
1292      * - the calling contract must have an ETH balance of at least `value`.
1293      * - the called Solidity function must be `payable`.
1294      *
1295      * _Available since v3.1._
1296      */
1297     function functionCallWithValue(
1298         address target,
1299         bytes memory data,
1300         uint256 value
1301     ) internal returns (bytes memory) {
1302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1303     }
1304 
1305     /**
1306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1307      * with `errorMessage` as a fallback revert reason when `target` reverts.
1308      *
1309      * _Available since v3.1._
1310      */
1311     function functionCallWithValue(
1312         address target,
1313         bytes memory data,
1314         uint256 value,
1315         string memory errorMessage
1316     ) internal returns (bytes memory) {
1317         require(address(this).balance >= value, "Address: insufficient balance for call");
1318         require(isContract(target), "Address: call to non-contract");
1319 
1320         (bool success, bytes memory returndata) = target.call{value: value}(data);
1321         return verifyCallResult(success, returndata, errorMessage);
1322     }
1323 
1324     /**
1325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1326      * but performing a static call.
1327      *
1328      * _Available since v3.3._
1329      */
1330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1331         return functionStaticCall(target, data, "Address: low-level static call failed");
1332     }
1333 
1334     /**
1335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1336      * but performing a static call.
1337      *
1338      * _Available since v3.3._
1339      */
1340     function functionStaticCall(
1341         address target,
1342         bytes memory data,
1343         string memory errorMessage
1344     ) internal view returns (bytes memory) {
1345         require(isContract(target), "Address: static call to non-contract");
1346 
1347         (bool success, bytes memory returndata) = target.staticcall(data);
1348         return verifyCallResult(success, returndata, errorMessage);
1349     }
1350 
1351     /**
1352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1353      * but performing a delegate call.
1354      *
1355      * _Available since v3.4._
1356      */
1357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1359     }
1360 
1361     /**
1362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1363      * but performing a delegate call.
1364      *
1365      * _Available since v3.4._
1366      */
1367     function functionDelegateCall(
1368         address target,
1369         bytes memory data,
1370         string memory errorMessage
1371     ) internal returns (bytes memory) {
1372         require(isContract(target), "Address: delegate call to non-contract");
1373 
1374         (bool success, bytes memory returndata) = target.delegatecall(data);
1375         return verifyCallResult(success, returndata, errorMessage);
1376     }
1377 
1378     /**
1379      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1380      * revert reason using the provided one.
1381      *
1382      * _Available since v4.3._
1383      */
1384     function verifyCallResult(
1385         bool success,
1386         bytes memory returndata,
1387         string memory errorMessage
1388     ) internal pure returns (bytes memory) {
1389         if (success) {
1390             return returndata;
1391         } else {
1392             // Look for revert reason and bubble it up if present
1393             if (returndata.length > 0) {
1394                 // The easiest way to bubble the revert reason is using memory via assembly
1395                 /// @solidity memory-safe-assembly
1396                 assembly {
1397                     let returndata_size := mload(returndata)
1398                     revert(add(32, returndata), returndata_size)
1399                 }
1400             } else {
1401                 revert(errorMessage);
1402             }
1403         }
1404     }
1405 }
1406 
1407 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1408 
1409 
1410 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 /**
1415  * @dev Interface of the ERC165 standard, as defined in the
1416  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1417  *
1418  * Implementers can declare support of contract interfaces, which can then be
1419  * queried by others ({ERC165Checker}).
1420  *
1421  * For an implementation, see {ERC165}.
1422  */
1423 interface IERC165 {
1424     /**
1425      * @dev Returns true if this contract implements the interface defined by
1426      * `interfaceId`. See the corresponding
1427      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1428      * to learn more about how these ids are created.
1429      *
1430      * This function call must use less than 30 000 gas.
1431      */
1432     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1433 }
1434 
1435 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1436 
1437 
1438 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1439 
1440 pragma solidity ^0.8.0;
1441 
1442 
1443 /**
1444  * @dev Required interface of an ERC721 compliant contract.
1445  */
1446 interface IERC721 is IERC165 {
1447     /**
1448      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1449      */
1450     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1451 
1452     /**
1453      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1454      */
1455     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1456 
1457     /**
1458      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1459      */
1460     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1461 
1462     /**
1463      * @dev Returns the number of tokens in ``owner``'s account.
1464      */
1465     function balanceOf(address owner) external view returns (uint256 balance);
1466 
1467     /**
1468      * @dev Returns the owner of the `tokenId` token.
1469      *
1470      * Requirements:
1471      *
1472      * - `tokenId` must exist.
1473      */
1474     function ownerOf(uint256 tokenId) external view returns (address owner);
1475 
1476     /**
1477      * @dev Safely transfers `tokenId` token from `from` to `to`.
1478      *
1479      * Requirements:
1480      *
1481      * - `from` cannot be the zero address.
1482      * - `to` cannot be the zero address.
1483      * - `tokenId` token must exist and be owned by `from`.
1484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function safeTransferFrom(
1490         address from,
1491         address to,
1492         uint256 tokenId,
1493         bytes calldata data
1494     ) external;
1495 
1496     /**
1497      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1498      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1499      *
1500      * Requirements:
1501      *
1502      * - `from` cannot be the zero address.
1503      * - `to` cannot be the zero address.
1504      * - `tokenId` token must exist and be owned by `from`.
1505      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function safeTransferFrom(
1511         address from,
1512         address to,
1513         uint256 tokenId
1514     ) external;
1515 
1516     /**
1517      * @dev Transfers `tokenId` token from `from` to `to`.
1518      *
1519      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1520      *
1521      * Requirements:
1522      *
1523      * - `from` cannot be the zero address.
1524      * - `to` cannot be the zero address.
1525      * - `tokenId` token must be owned by `from`.
1526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function transferFrom(
1531         address from,
1532         address to,
1533         uint256 tokenId
1534     ) external;
1535 
1536     /**
1537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1538      * The approval is cleared when the token is transferred.
1539      *
1540      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1541      *
1542      * Requirements:
1543      *
1544      * - The caller must own the token or be an approved operator.
1545      * - `tokenId` must exist.
1546      *
1547      * Emits an {Approval} event.
1548      */
1549     function approve(address to, uint256 tokenId) external;
1550 
1551     /**
1552      * @dev Approve or remove `operator` as an operator for the caller.
1553      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1554      *
1555      * Requirements:
1556      *
1557      * - The `operator` cannot be the caller.
1558      *
1559      * Emits an {ApprovalForAll} event.
1560      */
1561     function setApprovalForAll(address operator, bool _approved) external;
1562 
1563     /**
1564      * @dev Returns the account approved for `tokenId` token.
1565      *
1566      * Requirements:
1567      *
1568      * - `tokenId` must exist.
1569      */
1570     function getApproved(uint256 tokenId) external view returns (address operator);
1571 
1572     /**
1573      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1574      *
1575      * See {setApprovalForAll}
1576      */
1577     function isApprovedForAll(address owner, address operator) external view returns (bool);
1578 }
1579 
1580 // File: @openzeppelin/contracts/interfaces/IERC721.sol
1581 
1582 
1583 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
1584 
1585 pragma solidity ^0.8.0;
1586 
1587 
1588 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1589 
1590 
1591 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1592 
1593 pragma solidity ^0.8.0;
1594 
1595 
1596 /**
1597  * @dev Interface for the NFT Royalty Standard.
1598  *
1599  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1600  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1601  *
1602  * _Available since v4.5._
1603  */
1604 interface IERC2981 is IERC165 {
1605     /**
1606      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1607      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1608      */
1609     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1610         external
1611         view
1612         returns (address receiver, uint256 royaltyAmount);
1613 }
1614 
1615 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1616 
1617 
1618 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1619 
1620 pragma solidity ^0.8.0;
1621 
1622 
1623 /**
1624  * @dev Implementation of the {IERC165} interface.
1625  *
1626  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1627  * for the additional interface id that will be supported. For example:
1628  *
1629  * ```solidity
1630  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1631  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1632  * }
1633  * ```
1634  *
1635  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1636  */
1637 abstract contract ERC165 is IERC165 {
1638     /**
1639      * @dev See {IERC165-supportsInterface}.
1640      */
1641     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1642         return interfaceId == type(IERC165).interfaceId;
1643     }
1644 }
1645 
1646 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1647 
1648 
1649 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1650 
1651 pragma solidity ^0.8.0;
1652 
1653 
1654 
1655 /**
1656  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1657  *
1658  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1659  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1660  *
1661  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1662  * fee is specified in basis points by default.
1663  *
1664  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1665  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1666  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1667  *
1668  * _Available since v4.5._
1669  */
1670 abstract contract ERC2981 is IERC2981, ERC165 {
1671     struct RoyaltyInfo {
1672         address receiver;
1673         uint96 royaltyFraction;
1674     }
1675 
1676     RoyaltyInfo private _defaultRoyaltyInfo;
1677     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1678 
1679     /**
1680      * @dev See {IERC165-supportsInterface}.
1681      */
1682     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1683         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1684     }
1685 
1686     /**
1687      * @inheritdoc IERC2981
1688      */
1689     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1690         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1691 
1692         if (royalty.receiver == address(0)) {
1693             royalty = _defaultRoyaltyInfo;
1694         }
1695 
1696         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1697 
1698         return (royalty.receiver, royaltyAmount);
1699     }
1700 
1701     /**
1702      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1703      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1704      * override.
1705      */
1706     function _feeDenominator() internal pure virtual returns (uint96) {
1707         return 10000;
1708     }
1709 
1710     /**
1711      * @dev Sets the royalty information that all ids in this contract will default to.
1712      *
1713      * Requirements:
1714      *
1715      * - `receiver` cannot be the zero address.
1716      * - `feeNumerator` cannot be greater than the fee denominator.
1717      */
1718     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1719         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1720         require(receiver != address(0), "ERC2981: invalid receiver");
1721 
1722         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1723     }
1724 
1725     /**
1726      * @dev Removes default royalty information.
1727      */
1728     function _deleteDefaultRoyalty() internal virtual {
1729         delete _defaultRoyaltyInfo;
1730     }
1731 
1732     /**
1733      * @dev Sets the royalty information for a specific token id, overriding the global default.
1734      *
1735      * Requirements:
1736      *
1737      * - `receiver` cannot be the zero address.
1738      * - `feeNumerator` cannot be greater than the fee denominator.
1739      */
1740     function _setTokenRoyalty(
1741         uint256 tokenId,
1742         address receiver,
1743         uint96 feeNumerator
1744     ) internal virtual {
1745         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1746         require(receiver != address(0), "ERC2981: Invalid parameters");
1747 
1748         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1749     }
1750 
1751     /**
1752      * @dev Resets royalty information for the token id back to the global default.
1753      */
1754     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1755         delete _tokenRoyaltyInfo[tokenId];
1756     }
1757 }
1758 
1759 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1760 
1761 
1762 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1763 
1764 pragma solidity ^0.8.0;
1765 
1766 
1767 /**
1768  * @dev _Available since v3.1._
1769  */
1770 interface IERC1155Receiver is IERC165 {
1771     /**
1772      * @dev Handles the receipt of a single ERC1155 token type. This function is
1773      * called at the end of a `safeTransferFrom` after the balance has been updated.
1774      *
1775      * NOTE: To accept the transfer, this must return
1776      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1777      * (i.e. 0xf23a6e61, or its own function selector).
1778      *
1779      * @param operator The address which initiated the transfer (i.e. msg.sender)
1780      * @param from The address which previously owned the token
1781      * @param id The ID of the token being transferred
1782      * @param value The amount of tokens being transferred
1783      * @param data Additional data with no specified format
1784      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1785      */
1786     function onERC1155Received(
1787         address operator,
1788         address from,
1789         uint256 id,
1790         uint256 value,
1791         bytes calldata data
1792     ) external returns (bytes4);
1793 
1794     /**
1795      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1796      * is called at the end of a `safeBatchTransferFrom` after the balances have
1797      * been updated.
1798      *
1799      * NOTE: To accept the transfer(s), this must return
1800      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1801      * (i.e. 0xbc197c81, or its own function selector).
1802      *
1803      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1804      * @param from The address which previously owned the token
1805      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1806      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1807      * @param data Additional data with no specified format
1808      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1809      */
1810     function onERC1155BatchReceived(
1811         address operator,
1812         address from,
1813         uint256[] calldata ids,
1814         uint256[] calldata values,
1815         bytes calldata data
1816     ) external returns (bytes4);
1817 }
1818 
1819 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1820 
1821 
1822 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1823 
1824 pragma solidity ^0.8.0;
1825 
1826 
1827 /**
1828  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1829  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1830  *
1831  * _Available since v3.1._
1832  */
1833 interface IERC1155 is IERC165 {
1834     /**
1835      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1836      */
1837     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1838 
1839     /**
1840      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1841      * transfers.
1842      */
1843     event TransferBatch(
1844         address indexed operator,
1845         address indexed from,
1846         address indexed to,
1847         uint256[] ids,
1848         uint256[] values
1849     );
1850 
1851     /**
1852      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1853      * `approved`.
1854      */
1855     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1856 
1857     /**
1858      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1859      *
1860      * If an {URI} event was emitted for `id`, the standard
1861      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1862      * returned by {IERC1155MetadataURI-uri}.
1863      */
1864     event URI(string value, uint256 indexed id);
1865 
1866     /**
1867      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1868      *
1869      * Requirements:
1870      *
1871      * - `account` cannot be the zero address.
1872      */
1873     function balanceOf(address account, uint256 id) external view returns (uint256);
1874 
1875     /**
1876      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1877      *
1878      * Requirements:
1879      *
1880      * - `accounts` and `ids` must have the same length.
1881      */
1882     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1883         external
1884         view
1885         returns (uint256[] memory);
1886 
1887     /**
1888      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1889      *
1890      * Emits an {ApprovalForAll} event.
1891      *
1892      * Requirements:
1893      *
1894      * - `operator` cannot be the caller.
1895      */
1896     function setApprovalForAll(address operator, bool approved) external;
1897 
1898     /**
1899      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1900      *
1901      * See {setApprovalForAll}.
1902      */
1903     function isApprovedForAll(address account, address operator) external view returns (bool);
1904 
1905     /**
1906      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1907      *
1908      * Emits a {TransferSingle} event.
1909      *
1910      * Requirements:
1911      *
1912      * - `to` cannot be the zero address.
1913      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1914      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1915      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1916      * acceptance magic value.
1917      */
1918     function safeTransferFrom(
1919         address from,
1920         address to,
1921         uint256 id,
1922         uint256 amount,
1923         bytes calldata data
1924     ) external;
1925 
1926     /**
1927      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1928      *
1929      * Emits a {TransferBatch} event.
1930      *
1931      * Requirements:
1932      *
1933      * - `ids` and `amounts` must have the same length.
1934      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1935      * acceptance magic value.
1936      */
1937     function safeBatchTransferFrom(
1938         address from,
1939         address to,
1940         uint256[] calldata ids,
1941         uint256[] calldata amounts,
1942         bytes calldata data
1943     ) external;
1944 }
1945 
1946 // File: @openzeppelin/contracts/interfaces/IERC1155.sol
1947 
1948 
1949 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1155.sol)
1950 
1951 pragma solidity ^0.8.0;
1952 
1953 
1954 // File: contracts/IBOX.sol
1955 
1956 
1957 pragma solidity ^0.8.17;
1958 
1959 
1960 interface IBOX is IERC1155{
1961 
1962     function burn(address account,uint256 id,uint256 value) external ;
1963 }
1964 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1965 
1966 
1967 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1968 
1969 pragma solidity ^0.8.0;
1970 
1971 
1972 /**
1973  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1974  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1975  *
1976  * _Available since v3.1._
1977  */
1978 interface IERC1155MetadataURI is IERC1155 {
1979     /**
1980      * @dev Returns the URI for token type `id`.
1981      *
1982      * If the `\{id\}` substring is present in the URI, it must be replaced by
1983      * clients with the actual token type ID.
1984      */
1985     function uri(uint256 id) external view returns (string memory);
1986 }
1987 
1988 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1989 
1990 
1991 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1992 
1993 pragma solidity ^0.8.0;
1994 
1995 
1996 
1997 
1998 
1999 
2000 
2001 /**
2002  * @dev Implementation of the basic standard multi-token.
2003  * See https://eips.ethereum.org/EIPS/eip-1155
2004  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
2005  *
2006  * _Available since v3.1._
2007  */
2008 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
2009     using Address for address;
2010 
2011     // Mapping from token ID to account balances
2012     mapping(uint256 => mapping(address => uint256)) private _balances;
2013 
2014     // Mapping from account to operator approvals
2015     mapping(address => mapping(address => bool)) private _operatorApprovals;
2016 
2017     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
2018     string private _uri;
2019 
2020     /**
2021      * @dev See {_setURI}.
2022      */
2023     constructor(string memory uri_) {
2024         _setURI(uri_);
2025     }
2026 
2027     /**
2028      * @dev See {IERC165-supportsInterface}.
2029      */
2030     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2031         return
2032             interfaceId == type(IERC1155).interfaceId ||
2033             interfaceId == type(IERC1155MetadataURI).interfaceId ||
2034             super.supportsInterface(interfaceId);
2035     }
2036 
2037     /**
2038      * @dev See {IERC1155MetadataURI-uri}.
2039      *
2040      * This implementation returns the same URI for *all* token types. It relies
2041      * on the token type ID substitution mechanism
2042      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
2043      *
2044      * Clients calling this function must replace the `\{id\}` substring with the
2045      * actual token type ID.
2046      */
2047     function uri(uint256) public view virtual override returns (string memory) {
2048         return _uri;
2049     }
2050 
2051     /**
2052      * @dev See {IERC1155-balanceOf}.
2053      *
2054      * Requirements:
2055      *
2056      * - `account` cannot be the zero address.
2057      */
2058     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
2059         require(account != address(0), "ERC1155: address zero is not a valid owner");
2060         return _balances[id][account];
2061     }
2062 
2063     /**
2064      * @dev See {IERC1155-balanceOfBatch}.
2065      *
2066      * Requirements:
2067      *
2068      * - `accounts` and `ids` must have the same length.
2069      */
2070     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
2071         public
2072         view
2073         virtual
2074         override
2075         returns (uint256[] memory)
2076     {
2077         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
2078 
2079         uint256[] memory batchBalances = new uint256[](accounts.length);
2080 
2081         for (uint256 i = 0; i < accounts.length; ++i) {
2082             batchBalances[i] = balanceOf(accounts[i], ids[i]);
2083         }
2084 
2085         return batchBalances;
2086     }
2087 
2088     /**
2089      * @dev See {IERC1155-setApprovalForAll}.
2090      */
2091     function setApprovalForAll(address operator, bool approved) public virtual override {
2092         _setApprovalForAll(_msgSender(), operator, approved);
2093     }
2094 
2095     /**
2096      * @dev See {IERC1155-isApprovedForAll}.
2097      */
2098     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
2099         return _operatorApprovals[account][operator];
2100     }
2101 
2102     /**
2103      * @dev See {IERC1155-safeTransferFrom}.
2104      */
2105     function safeTransferFrom(
2106         address from,
2107         address to,
2108         uint256 id,
2109         uint256 amount,
2110         bytes memory data
2111     ) public virtual override {
2112         require(
2113             from == _msgSender() || isApprovedForAll(from, _msgSender()),
2114             "ERC1155: caller is not token owner nor approved"
2115         );
2116         _safeTransferFrom(from, to, id, amount, data);
2117     }
2118 
2119     /**
2120      * @dev See {IERC1155-safeBatchTransferFrom}.
2121      */
2122     function safeBatchTransferFrom(
2123         address from,
2124         address to,
2125         uint256[] memory ids,
2126         uint256[] memory amounts,
2127         bytes memory data
2128     ) public virtual override {
2129         require(
2130             from == _msgSender() || isApprovedForAll(from, _msgSender()),
2131             "ERC1155: caller is not token owner nor approved"
2132         );
2133         _safeBatchTransferFrom(from, to, ids, amounts, data);
2134     }
2135 
2136     /**
2137      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
2138      *
2139      * Emits a {TransferSingle} event.
2140      *
2141      * Requirements:
2142      *
2143      * - `to` cannot be the zero address.
2144      * - `from` must have a balance of tokens of type `id` of at least `amount`.
2145      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2146      * acceptance magic value.
2147      */
2148     function _safeTransferFrom(
2149         address from,
2150         address to,
2151         uint256 id,
2152         uint256 amount,
2153         bytes memory data
2154     ) internal virtual {
2155         require(to != address(0), "ERC1155: transfer to the zero address");
2156 
2157         address operator = _msgSender();
2158         uint256[] memory ids = _asSingletonArray(id);
2159         uint256[] memory amounts = _asSingletonArray(amount);
2160 
2161         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
2162 
2163         uint256 fromBalance = _balances[id][from];
2164         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
2165         unchecked {
2166             _balances[id][from] = fromBalance - amount;
2167         }
2168         _balances[id][to] += amount;
2169 
2170         emit TransferSingle(operator, from, to, id, amount);
2171 
2172         _afterTokenTransfer(operator, from, to, ids, amounts, data);
2173 
2174         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
2175     }
2176 
2177     /**
2178      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
2179      *
2180      * Emits a {TransferBatch} event.
2181      *
2182      * Requirements:
2183      *
2184      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2185      * acceptance magic value.
2186      */
2187     function _safeBatchTransferFrom(
2188         address from,
2189         address to,
2190         uint256[] memory ids,
2191         uint256[] memory amounts,
2192         bytes memory data
2193     ) internal virtual {
2194         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2195         require(to != address(0), "ERC1155: transfer to the zero address");
2196 
2197         address operator = _msgSender();
2198 
2199         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
2200 
2201         for (uint256 i = 0; i < ids.length; ++i) {
2202             uint256 id = ids[i];
2203             uint256 amount = amounts[i];
2204 
2205             uint256 fromBalance = _balances[id][from];
2206             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
2207             unchecked {
2208                 _balances[id][from] = fromBalance - amount;
2209             }
2210             _balances[id][to] += amount;
2211         }
2212 
2213         emit TransferBatch(operator, from, to, ids, amounts);
2214 
2215         _afterTokenTransfer(operator, from, to, ids, amounts, data);
2216 
2217         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
2218     }
2219 
2220     /**
2221      * @dev Sets a new URI for all token types, by relying on the token type ID
2222      * substitution mechanism
2223      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
2224      *
2225      * By this mechanism, any occurrence of the `\{id\}` substring in either the
2226      * URI or any of the amounts in the JSON file at said URI will be replaced by
2227      * clients with the token type ID.
2228      *
2229      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
2230      * interpreted by clients as
2231      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
2232      * for token type ID 0x4cce0.
2233      *
2234      * See {uri}.
2235      *
2236      * Because these URIs cannot be meaningfully represented by the {URI} event,
2237      * this function emits no events.
2238      */
2239     function _setURI(string memory newuri) internal virtual {
2240         _uri = newuri;
2241     }
2242 
2243     /**
2244      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
2245      *
2246      * Emits a {TransferSingle} event.
2247      *
2248      * Requirements:
2249      *
2250      * - `to` cannot be the zero address.
2251      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2252      * acceptance magic value.
2253      */
2254     function _mint(
2255         address to,
2256         uint256 id,
2257         uint256 amount,
2258         bytes memory data
2259     ) internal virtual {
2260         require(to != address(0), "ERC1155: mint to the zero address");
2261 
2262         address operator = _msgSender();
2263         uint256[] memory ids = _asSingletonArray(id);
2264         uint256[] memory amounts = _asSingletonArray(amount);
2265 
2266         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2267 
2268         _balances[id][to] += amount;
2269         emit TransferSingle(operator, address(0), to, id, amount);
2270 
2271         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2272 
2273         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
2274     }
2275 
2276     /**
2277      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
2278      *
2279      * Emits a {TransferBatch} event.
2280      *
2281      * Requirements:
2282      *
2283      * - `ids` and `amounts` must have the same length.
2284      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2285      * acceptance magic value.
2286      */
2287     function _mintBatch(
2288         address to,
2289         uint256[] memory ids,
2290         uint256[] memory amounts,
2291         bytes memory data
2292     ) internal virtual {
2293         require(to != address(0), "ERC1155: mint to the zero address");
2294         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2295 
2296         address operator = _msgSender();
2297 
2298         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2299 
2300         for (uint256 i = 0; i < ids.length; i++) {
2301             _balances[ids[i]][to] += amounts[i];
2302         }
2303 
2304         emit TransferBatch(operator, address(0), to, ids, amounts);
2305 
2306         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2307 
2308         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
2309     }
2310 
2311     /**
2312      * @dev Destroys `amount` tokens of token type `id` from `from`
2313      *
2314      * Emits a {TransferSingle} event.
2315      *
2316      * Requirements:
2317      *
2318      * - `from` cannot be the zero address.
2319      * - `from` must have at least `amount` tokens of token type `id`.
2320      */
2321     function _burn(
2322         address from,
2323         uint256 id,
2324         uint256 amount
2325     ) internal virtual {
2326         require(from != address(0), "ERC1155: burn from the zero address");
2327 
2328         address operator = _msgSender();
2329         uint256[] memory ids = _asSingletonArray(id);
2330         uint256[] memory amounts = _asSingletonArray(amount);
2331 
2332         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2333 
2334         uint256 fromBalance = _balances[id][from];
2335         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2336         unchecked {
2337             _balances[id][from] = fromBalance - amount;
2338         }
2339 
2340         emit TransferSingle(operator, from, address(0), id, amount);
2341 
2342         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2343     }
2344 
2345     /**
2346      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
2347      *
2348      * Emits a {TransferBatch} event.
2349      *
2350      * Requirements:
2351      *
2352      * - `ids` and `amounts` must have the same length.
2353      */
2354     function _burnBatch(
2355         address from,
2356         uint256[] memory ids,
2357         uint256[] memory amounts
2358     ) internal virtual {
2359         require(from != address(0), "ERC1155: burn from the zero address");
2360         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2361 
2362         address operator = _msgSender();
2363 
2364         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2365 
2366         for (uint256 i = 0; i < ids.length; i++) {
2367             uint256 id = ids[i];
2368             uint256 amount = amounts[i];
2369 
2370             uint256 fromBalance = _balances[id][from];
2371             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2372             unchecked {
2373                 _balances[id][from] = fromBalance - amount;
2374             }
2375         }
2376 
2377         emit TransferBatch(operator, from, address(0), ids, amounts);
2378 
2379         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2380     }
2381 
2382     /**
2383      * @dev Approve `operator` to operate on all of `owner` tokens
2384      *
2385      * Emits an {ApprovalForAll} event.
2386      */
2387     function _setApprovalForAll(
2388         address owner,
2389         address operator,
2390         bool approved
2391     ) internal virtual {
2392         require(owner != operator, "ERC1155: setting approval status for self");
2393         _operatorApprovals[owner][operator] = approved;
2394         emit ApprovalForAll(owner, operator, approved);
2395     }
2396 
2397     /**
2398      * @dev Hook that is called before any token transfer. This includes minting
2399      * and burning, as well as batched variants.
2400      *
2401      * The same hook is called on both single and batched variants. For single
2402      * transfers, the length of the `ids` and `amounts` arrays will be 1.
2403      *
2404      * Calling conditions (for each `id` and `amount` pair):
2405      *
2406      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2407      * of token type `id` will be  transferred to `to`.
2408      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2409      * for `to`.
2410      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2411      * will be burned.
2412      * - `from` and `to` are never both zero.
2413      * - `ids` and `amounts` have the same, non-zero length.
2414      *
2415      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2416      */
2417     function _beforeTokenTransfer(
2418         address operator,
2419         address from,
2420         address to,
2421         uint256[] memory ids,
2422         uint256[] memory amounts,
2423         bytes memory data
2424     ) internal virtual {}
2425 
2426     /**
2427      * @dev Hook that is called after any token transfer. This includes minting
2428      * and burning, as well as batched variants.
2429      *
2430      * The same hook is called on both single and batched variants. For single
2431      * transfers, the length of the `id` and `amount` arrays will be 1.
2432      *
2433      * Calling conditions (for each `id` and `amount` pair):
2434      *
2435      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2436      * of token type `id` will be  transferred to `to`.
2437      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2438      * for `to`.
2439      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2440      * will be burned.
2441      * - `from` and `to` are never both zero.
2442      * - `ids` and `amounts` have the same, non-zero length.
2443      *
2444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2445      */
2446     function _afterTokenTransfer(
2447         address operator,
2448         address from,
2449         address to,
2450         uint256[] memory ids,
2451         uint256[] memory amounts,
2452         bytes memory data
2453     ) internal virtual {}
2454 
2455     function _doSafeTransferAcceptanceCheck(
2456         address operator,
2457         address from,
2458         address to,
2459         uint256 id,
2460         uint256 amount,
2461         bytes memory data
2462     ) private {
2463         if (to.isContract()) {
2464             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
2465                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2466                     revert("ERC1155: ERC1155Receiver rejected tokens");
2467                 }
2468             } catch Error(string memory reason) {
2469                 revert(reason);
2470             } catch {
2471                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2472             }
2473         }
2474     }
2475 
2476     function _doSafeBatchTransferAcceptanceCheck(
2477         address operator,
2478         address from,
2479         address to,
2480         uint256[] memory ids,
2481         uint256[] memory amounts,
2482         bytes memory data
2483     ) private {
2484         if (to.isContract()) {
2485             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
2486                 bytes4 response
2487             ) {
2488                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
2489                     revert("ERC1155: ERC1155Receiver rejected tokens");
2490                 }
2491             } catch Error(string memory reason) {
2492                 revert(reason);
2493             } catch {
2494                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2495             }
2496         }
2497     }
2498 
2499     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
2500         uint256[] memory array = new uint256[](1);
2501         array[0] = element;
2502 
2503         return array;
2504     }
2505 }
2506 
2507 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol
2508 
2509 
2510 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155URIStorage.sol)
2511 
2512 pragma solidity ^0.8.0;
2513 
2514 
2515 
2516 /**
2517  * @dev ERC1155 token with storage based token URI management.
2518  * Inspired by the ERC721URIStorage extension
2519  *
2520  * _Available since v4.6._
2521  */
2522 abstract contract ERC1155URIStorage is ERC1155 {
2523     using Strings for uint256;
2524 
2525     // Optional base URI
2526     string private _baseURI = "";
2527 
2528     // Optional mapping for token URIs
2529     mapping(uint256 => string) private _tokenURIs;
2530 
2531     /**
2532      * @dev See {IERC1155MetadataURI-uri}.
2533      *
2534      * This implementation returns the concatenation of the `_baseURI`
2535      * and the token-specific uri if the latter is set
2536      *
2537      * This enables the following behaviors:
2538      *
2539      * - if `_tokenURIs[tokenId]` is set, then the result is the concatenation
2540      *   of `_baseURI` and `_tokenURIs[tokenId]` (keep in mind that `_baseURI`
2541      *   is empty per default);
2542      *
2543      * - if `_tokenURIs[tokenId]` is NOT set then we fallback to `super.uri()`
2544      *   which in most cases will contain `ERC1155._uri`;
2545      *
2546      * - if `_tokenURIs[tokenId]` is NOT set, and if the parents do not have a
2547      *   uri value set, then the result is empty.
2548      */
2549     function uri(uint256 tokenId) public view virtual override returns (string memory) {
2550         string memory tokenURI = _tokenURIs[tokenId];
2551 
2552         // If token URI is set, concatenate base URI and tokenURI (via abi.encodePacked).
2553         return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
2554     }
2555 
2556     /**
2557      * @dev Sets `tokenURI` as the tokenURI of `tokenId`.
2558      */
2559     function _setURI(uint256 tokenId, string memory tokenURI) internal virtual {
2560         _tokenURIs[tokenId] = tokenURI;
2561         emit URI(uri(tokenId), tokenId);
2562     }
2563 
2564     /**
2565      * @dev Sets `baseURI` as the `_baseURI` for all tokens
2566      */
2567     function _setBaseURI(string memory baseURI) internal virtual {
2568         _baseURI = baseURI;
2569     }
2570 }
2571 
2572 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
2573 
2574 
2575 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
2576 
2577 pragma solidity ^0.8.0;
2578 
2579 
2580 /**
2581  * @dev Extension of ERC1155 that adds tracking of total supply per id.
2582  *
2583  * Useful for scenarios where Fungible and Non-fungible tokens have to be
2584  * clearly identified. Note: While a totalSupply of 1 might mean the
2585  * corresponding is an NFT, there is no guarantees that no other token with the
2586  * same id are not going to be minted.
2587  */
2588 abstract contract ERC1155Supply is ERC1155 {
2589     mapping(uint256 => uint256) private _totalSupply;
2590 
2591     /**
2592      * @dev Total amount of tokens in with a given id.
2593      */
2594     function totalSupply(uint256 id) public view virtual returns (uint256) {
2595         return _totalSupply[id];
2596     }
2597 
2598     /**
2599      * @dev Indicates whether any token exist with a given id, or not.
2600      */
2601     function exists(uint256 id) public view virtual returns (bool) {
2602         return ERC1155Supply.totalSupply(id) > 0;
2603     }
2604 
2605     /**
2606      * @dev See {ERC1155-_beforeTokenTransfer}.
2607      */
2608     function _beforeTokenTransfer(
2609         address operator,
2610         address from,
2611         address to,
2612         uint256[] memory ids,
2613         uint256[] memory amounts,
2614         bytes memory data
2615     ) internal virtual override {
2616         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2617 
2618         if (from == address(0)) {
2619             for (uint256 i = 0; i < ids.length; ++i) {
2620                 _totalSupply[ids[i]] += amounts[i];
2621             }
2622         }
2623 
2624         if (to == address(0)) {
2625             for (uint256 i = 0; i < ids.length; ++i) {
2626                 uint256 id = ids[i];
2627                 uint256 amount = amounts[i];
2628                 uint256 supply = _totalSupply[id];
2629                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
2630                 unchecked {
2631                     _totalSupply[id] = supply - amount;
2632                 }
2633             }
2634         }
2635     }
2636 }
2637 
2638 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
2639 
2640 
2641 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
2642 
2643 pragma solidity ^0.8.0;
2644 
2645 
2646 /**
2647  * @dev Extension of {ERC1155} that allows token holders to destroy both their
2648  * own tokens and those that they have been approved to use.
2649  *
2650  * _Available since v3.1._
2651  */
2652 abstract contract ERC1155Burnable is ERC1155 {
2653     function burn(
2654         address account,
2655         uint256 id,
2656         uint256 value
2657     ) public virtual {
2658         require(
2659             account == _msgSender() || isApprovedForAll(account, _msgSender()),
2660             "ERC1155: caller is not token owner or approved"
2661         );
2662 
2663         _burn(account, id, value);
2664     }
2665 
2666     function burnBatch(
2667         address account,
2668         uint256[] memory ids,
2669         uint256[] memory values
2670     ) public virtual {
2671         require(
2672             account == _msgSender() || isApprovedForAll(account, _msgSender()),
2673             "ERC1155: caller is not token owner or approved"
2674         );
2675 
2676         _burnBatch(account, ids, values);
2677     }
2678 }
2679 
2680 // File: contracts/HypeGear.sol
2681 
2682 
2683 pragma solidity ^0.8.17;
2684 
2685 //@author PZ
2686 //@title HypeGearBox
2687 
2688 
2689 
2690 
2691 
2692 
2693 
2694 
2695 
2696 
2697 
2698 
2699 
2700 
2701 
2702 contract HypeGear is ERC1155,
2703     ERC1155Burnable,
2704     ERC1155Supply,
2705     ERC1155URIStorage,
2706     ERC2981,
2707     Ownable,
2708     ReentrancyGuard,
2709     IERC1155Receiver,
2710     DefaultOperatorFilterer {
2711 
2712     using MerkleProof for bytes32[];
2713     using SafeMath for uint256;
2714     using EnumerableSet for EnumerableSet.UintSet;
2715 
2716     
2717 
2718     uint256 public constant GENESIS = 0;
2719 
2720     uint256 public constant NORMAL = 0;
2721 
2722     uint256 public constant GOLD = 1;
2723 
2724     uint256 public constant ONE = 1;
2725 
2726     mapping(uint256 => uint256) public maxSupply;
2727 
2728     mapping(address => mapping(uint256 => uint256)) private _count;
2729 
2730     EnumerableSet.UintSet private genesisSet;
2731 
2732     string private _name;
2733 
2734     string private _symbol;
2735 
2736     mapping(uint256 => bytes32) private merkleRootMap;
2737 
2738     mapping(uint256 => uint256) private priceMap;
2739 
2740     bool public _active;
2741 
2742     bool public freemint_active;
2743 
2744     uint256 public freemint_round;
2745 
2746     uint256 public freemint_id;
2747 
2748     uint256 public freemint_num;
2749 
2750     mapping(uint256=>mapping(address=>bool)) private freeMintMap;
2751 
2752     IERC721 immutable HYPE_SAINTS;
2753     IBOX immutable HYPE_GEAR_BOX;
2754     address payable public immutable withdrawAddress;
2755 
2756 
2757 
2758     constructor(
2759         string memory name_,
2760         string memory symbol_,
2761         address _hypeGearBox,
2762         address _hypeSaints,
2763         address royalty_,
2764         uint96 royaltyFee_,
2765         string memory uri_,
2766         address payable _withdrawAddress
2767     ) ERC1155(uri_) {
2768         require(_withdrawAddress != address(0));
2769         withdrawAddress = _withdrawAddress;
2770 
2771         _name = name_;
2772         _symbol = symbol_;
2773         HYPE_SAINTS = IERC721(_hypeSaints);
2774         HYPE_GEAR_BOX = IBOX(_hypeGearBox);
2775         _active = false;
2776         _setDefaultRoyalty(royalty_, royaltyFee_);
2777     }
2778 
2779     modifier callerIsUser() {
2780         require(tx.origin == msg.sender, "The caller is another contract");
2781         _;
2782     }
2783 
2784     function onERC1155Received(
2785         address,
2786         address,
2787         uint256,
2788         uint256,
2789         bytes memory
2790     ) public virtual override returns (bytes4) {
2791         return this.onERC1155Received.selector;
2792     }
2793 
2794     function onERC1155BatchReceived(
2795         address,
2796         address,
2797         uint256[] memory,
2798         uint256[] memory,
2799         bytes memory
2800     ) public virtual override returns (bytes4) {
2801         return this.onERC1155BatchReceived.selector;
2802     }
2803 
2804 
2805     
2806 
2807     function kolMint(address[] memory _team, uint256 amount,uint256 _id) external onlyOwner {
2808         
2809         for (uint256 i = 0; i < _team.length; i++) {
2810             _mint(_team[i], _id,amount,"");
2811         }
2812     }
2813 
2814     function freeMint() external nonReentrant {
2815         require(freemint_active, "free mint not active");
2816         require(freemint_id > 0,"freemint id is not right");
2817         require(freemint_num > 0,"freemint amount is not enought");
2818         require(!freeMintMap[freemint_round][msg.sender],"you can only mint one");
2819         require(totalSupply(freemint_id) + ONE <= maxSupply[freemint_id], "Max supply exceeded");
2820         
2821         _mint(msg.sender, freemint_id,ONE,"");
2822         freemint_num = freemint_num - 1;
2823         freeMintMap[freemint_round][msg.sender] = true;
2824     }
2825 
2826     function genesisMint(uint256[] memory _hypeSaintIds) external callerIsUser nonReentrant {
2827         require(_active, "Not active");
2828         require(totalSupply(0) + _hypeSaintIds.length <= maxSupply[0], "Max supply exceeded");
2829         for (uint256 i = 0; i < _hypeSaintIds.length; i++) {
2830             require(msg.sender == HYPE_SAINTS.ownerOf(_hypeSaintIds[i]),"you do not have this HypeSaints!");
2831             require(!genesisSet.contains(_hypeSaintIds[i]),"This HypeSaint has claimed genesis HypeGear");
2832             _mint(msg.sender,0,1,"");
2833             genesisSet.add(_hypeSaintIds[i]);
2834         }
2835     }
2836 
2837     function openBox(uint256 _boxType) external callerIsUser nonReentrant {
2838         require(_active, "Not active");
2839         require(HYPE_GEAR_BOX.balanceOf(msg.sender,_boxType) == 1,"you do not have HypeGearBox!");
2840 
2841         if (_boxType == NORMAL) {
2842             _mint(msg.sender,1,1,"");
2843         } else {
2844             _mint(msg.sender,2,1,"");
2845         } 
2846         
2847         HYPE_GEAR_BOX.burn(msg.sender,_boxType,1);
2848     }
2849 
2850 
2851 
2852     function whitelistMint(bytes32[] calldata _proof,uint256 _id) external payable callerIsUser nonReentrant {
2853         require(_active, "Not active");
2854         require(priceMap[_id] <= msg.value, "The value sent is not correct");
2855         require(isWhiteListed(msg.sender, _proof,_id), "Not whitelisted");
2856         require(_count[msg.sender][_id] < 1, "You can only mint one HypeGear on the Whitelist");
2857         require(totalSupply(_id) + ONE <= maxSupply[_id], "Max supply exceeded");
2858 
2859         _mint(msg.sender, _id,ONE,"");
2860         _count[msg.sender][_id] = 1;
2861         
2862     }
2863 
2864 
2865 
2866     function getActive() external view returns (bool) {
2867         return _active;
2868     }
2869 
2870     function setActive(bool active) external onlyOwner {
2871         _active = active;
2872     }
2873 
2874     function setFreeMintActive(bool _freeMintActive) external onlyOwner {
2875         freemint_active = _freeMintActive;
2876         if (_freeMintActive) {
2877             freemint_round = freemint_round.add(1);
2878         }
2879         
2880     }
2881 
2882     function setFreeMintId(uint256 _freeMintId) external onlyOwner {
2883         freemint_id = _freeMintId;
2884     }
2885 
2886     function setFreeMintNum(uint256 _freeMintNum) external onlyOwner {
2887         freemint_num = _freeMintNum;
2888     }
2889 
2890     function getGenesisSet() public view returns(uint256[] memory) {
2891         return genesisSet.values();
2892     }
2893 
2894     function setSupply(uint256 _id,uint256 _supply) external onlyOwner {
2895         maxSupply[_id] = _supply;
2896     }
2897 
2898     function getMaxSupply(uint256 _id) public view returns(uint256) {
2899         return maxSupply[_id];
2900     }
2901 
2902     function setPrice(uint256 _id,uint256 _price) external onlyOwner {
2903         priceMap[_id] = _price;
2904     }
2905 
2906     function getPrice(uint256 _id) public view returns(uint256) {
2907         return priceMap[_id];
2908     }
2909 
2910     //Whitelist
2911     function setMerkleRoot(bytes32 merkleRoot_,uint256 _id) external onlyOwner {
2912         merkleRootMap[_id] = merkleRoot_;
2913     }
2914     
2915     function getMerkleRoot(uint256 _id) public view returns(bytes32) {
2916         return merkleRootMap[_id];
2917     }
2918 
2919     function isWhiteListed(address _account, bytes32[] calldata _proof,uint256 _id) internal view returns(bool) {
2920         return _verify(leaf(_account), _proof,_id);
2921     }
2922 
2923     function leaf(address _account) internal pure returns(bytes32) {
2924         return keccak256(abi.encodePacked(_account));
2925     }
2926 
2927     function _verify(bytes32 _leaf, bytes32[] memory _proof,uint256 _id) internal view returns(bool) {
2928         return MerkleProof.verify(_proof, merkleRootMap[_id], _leaf);
2929     }  
2930 
2931     
2932 
2933     function setURI(string memory uri_) external onlyOwner {
2934         super._setBaseURI(uri_);
2935     }
2936 
2937     function setURI(uint256 tokenId, string memory tokenURI) external onlyOwner {
2938         super._setURI(tokenId,tokenURI);
2939     }
2940 
2941     function uri(uint256 tokenId) public view override(ERC1155, ERC1155URIStorage) returns (string memory) {
2942     return ERC1155URIStorage.uri(tokenId);
2943     }
2944 
2945     function _beforeTokenTransfer(
2946         address operator,
2947         address from,
2948         address to,
2949         uint256[] memory ids,
2950         uint256[] memory amounts,
2951         bytes memory data
2952     ) internal override(ERC1155, ERC1155Supply) {
2953         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2954     }
2955 
2956     function supportsInterface(bytes4 interfaceId)
2957         public
2958         view
2959         override(ERC1155, ERC2981,IERC165)
2960         returns (bool)
2961     {
2962         return super.supportsInterface(interfaceId);
2963     }
2964 
2965     function withdraw() external onlyOwner {
2966         (bool success, ) = withdrawAddress.call{value: address(this).balance}("");
2967         require(success, "Transfer failed.");
2968     }
2969 
2970 }