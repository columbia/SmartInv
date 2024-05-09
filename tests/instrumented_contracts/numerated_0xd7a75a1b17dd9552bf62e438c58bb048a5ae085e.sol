1 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
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
231 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Standard math utilities missing in the Solidity language.
240  */
241 library Math {
242     /**
243      * @dev Returns the largest of two numbers.
244      */
245     function max(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a >= b ? a : b;
247     }
248 
249     /**
250      * @dev Returns the smallest of two numbers.
251      */
252     function min(uint256 a, uint256 b) internal pure returns (uint256) {
253         return a < b ? a : b;
254     }
255 
256     /**
257      * @dev Returns the average of two numbers. The result is rounded towards
258      * zero.
259      */
260     function average(uint256 a, uint256 b) internal pure returns (uint256) {
261         // (a + b) / 2 can overflow.
262         return (a & b) + (a ^ b) / 2;
263     }
264 
265     /**
266      * @dev Returns the ceiling of the division of two numbers.
267      *
268      * This differs from standard division with `/` in that it rounds up instead
269      * of rounding down.
270      */
271     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
272         // (a + b - 1) / b can overflow on addition, so we distribute.
273         return a / b + (a % b == 0 ? 0 : 1);
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Library for managing
286  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
287  * types.
288  *
289  * Sets have the following properties:
290  *
291  * - Elements are added, removed, and checked for existence in constant time
292  * (O(1)).
293  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
294  *
295  * ```
296  * contract Example {
297  *     // Add the library methods
298  *     using EnumerableSet for EnumerableSet.AddressSet;
299  *
300  *     // Declare a set state variable
301  *     EnumerableSet.AddressSet private mySet;
302  * }
303  * ```
304  *
305  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
306  * and `uint256` (`UintSet`) are supported.
307  */
308 library EnumerableSet {
309     // To implement this library for multiple types with as little code
310     // repetition as possible, we write it in terms of a generic Set type with
311     // bytes32 values.
312     // The Set implementation uses private functions, and user-facing
313     // implementations (such as AddressSet) are just wrappers around the
314     // underlying Set.
315     // This means that we can only create new EnumerableSets for types that fit
316     // in bytes32.
317 
318     struct Set {
319         // Storage of set values
320         bytes32[] _values;
321         // Position of the value in the `values` array, plus 1 because index 0
322         // means a value is not in the set.
323         mapping(bytes32 => uint256) _indexes;
324     }
325 
326     /**
327      * @dev Add a value to a set. O(1).
328      *
329      * Returns true if the value was added to the set, that is if it was not
330      * already present.
331      */
332     function _add(Set storage set, bytes32 value) private returns (bool) {
333         if (!_contains(set, value)) {
334             set._values.push(value);
335             // The value is stored at length-1, but we add 1 to all indexes
336             // and use 0 as a sentinel value
337             set._indexes[value] = set._values.length;
338             return true;
339         } else {
340             return false;
341         }
342     }
343 
344     /**
345      * @dev Removes a value from a set. O(1).
346      *
347      * Returns true if the value was removed from the set, that is if it was
348      * present.
349      */
350     function _remove(Set storage set, bytes32 value) private returns (bool) {
351         // We read and store the value's index to prevent multiple reads from the same storage slot
352         uint256 valueIndex = set._indexes[value];
353 
354         if (valueIndex != 0) {
355             // Equivalent to contains(set, value)
356             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
357             // the array, and then remove the last element (sometimes called as 'swap and pop').
358             // This modifies the order of the array, as noted in {at}.
359 
360             uint256 toDeleteIndex = valueIndex - 1;
361             uint256 lastIndex = set._values.length - 1;
362 
363             if (lastIndex != toDeleteIndex) {
364                 bytes32 lastvalue = set._values[lastIndex];
365 
366                 // Move the last value to the index where the value to delete is
367                 set._values[toDeleteIndex] = lastvalue;
368                 // Update the index for the moved value
369                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
370             }
371 
372             // Delete the slot where the moved value was stored
373             set._values.pop();
374 
375             // Delete the index for the deleted slot
376             delete set._indexes[value];
377 
378             return true;
379         } else {
380             return false;
381         }
382     }
383 
384     /**
385      * @dev Returns true if the value is in the set. O(1).
386      */
387     function _contains(Set storage set, bytes32 value) private view returns (bool) {
388         return set._indexes[value] != 0;
389     }
390 
391     /**
392      * @dev Returns the number of values on the set. O(1).
393      */
394     function _length(Set storage set) private view returns (uint256) {
395         return set._values.length;
396     }
397 
398     /**
399      * @dev Returns the value stored at position `index` in the set. O(1).
400      *
401      * Note that there are no guarantees on the ordering of values inside the
402      * array, and it may change when more values are added or removed.
403      *
404      * Requirements:
405      *
406      * - `index` must be strictly less than {length}.
407      */
408     function _at(Set storage set, uint256 index) private view returns (bytes32) {
409         return set._values[index];
410     }
411 
412     /**
413      * @dev Return the entire set in an array
414      *
415      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
416      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
417      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
418      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
419      */
420     function _values(Set storage set) private view returns (bytes32[] memory) {
421         return set._values;
422     }
423 
424     // Bytes32Set
425 
426     struct Bytes32Set {
427         Set _inner;
428     }
429 
430     /**
431      * @dev Add a value to a set. O(1).
432      *
433      * Returns true if the value was added to the set, that is if it was not
434      * already present.
435      */
436     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
437         return _add(set._inner, value);
438     }
439 
440     /**
441      * @dev Removes a value from a set. O(1).
442      *
443      * Returns true if the value was removed from the set, that is if it was
444      * present.
445      */
446     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
447         return _remove(set._inner, value);
448     }
449 
450     /**
451      * @dev Returns true if the value is in the set. O(1).
452      */
453     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
454         return _contains(set._inner, value);
455     }
456 
457     /**
458      * @dev Returns the number of values in the set. O(1).
459      */
460     function length(Bytes32Set storage set) internal view returns (uint256) {
461         return _length(set._inner);
462     }
463 
464     /**
465      * @dev Returns the value stored at position `index` in the set. O(1).
466      *
467      * Note that there are no guarantees on the ordering of values inside the
468      * array, and it may change when more values are added or removed.
469      *
470      * Requirements:
471      *
472      * - `index` must be strictly less than {length}.
473      */
474     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
475         return _at(set._inner, index);
476     }
477 
478     /**
479      * @dev Return the entire set in an array
480      *
481      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
482      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
483      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
484      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
485      */
486     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
487         return _values(set._inner);
488     }
489 
490     // AddressSet
491 
492     struct AddressSet {
493         Set _inner;
494     }
495 
496     /**
497      * @dev Add a value to a set. O(1).
498      *
499      * Returns true if the value was added to the set, that is if it was not
500      * already present.
501      */
502     function add(AddressSet storage set, address value) internal returns (bool) {
503         return _add(set._inner, bytes32(uint256(uint160(value))));
504     }
505 
506     /**
507      * @dev Removes a value from a set. O(1).
508      *
509      * Returns true if the value was removed from the set, that is if it was
510      * present.
511      */
512     function remove(AddressSet storage set, address value) internal returns (bool) {
513         return _remove(set._inner, bytes32(uint256(uint160(value))));
514     }
515 
516     /**
517      * @dev Returns true if the value is in the set. O(1).
518      */
519     function contains(AddressSet storage set, address value) internal view returns (bool) {
520         return _contains(set._inner, bytes32(uint256(uint160(value))));
521     }
522 
523     /**
524      * @dev Returns the number of values in the set. O(1).
525      */
526     function length(AddressSet storage set) internal view returns (uint256) {
527         return _length(set._inner);
528     }
529 
530     /**
531      * @dev Returns the value stored at position `index` in the set. O(1).
532      *
533      * Note that there are no guarantees on the ordering of values inside the
534      * array, and it may change when more values are added or removed.
535      *
536      * Requirements:
537      *
538      * - `index` must be strictly less than {length}.
539      */
540     function at(AddressSet storage set, uint256 index) internal view returns (address) {
541         return address(uint160(uint256(_at(set._inner, index))));
542     }
543 
544     /**
545      * @dev Return the entire set in an array
546      *
547      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
548      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
549      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
550      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
551      */
552     function values(AddressSet storage set) internal view returns (address[] memory) {
553         bytes32[] memory store = _values(set._inner);
554         address[] memory result;
555 
556         assembly {
557             result := store
558         }
559 
560         return result;
561     }
562 
563     // UintSet
564 
565     struct UintSet {
566         Set _inner;
567     }
568 
569     /**
570      * @dev Add a value to a set. O(1).
571      *
572      * Returns true if the value was added to the set, that is if it was not
573      * already present.
574      */
575     function add(UintSet storage set, uint256 value) internal returns (bool) {
576         return _add(set._inner, bytes32(value));
577     }
578 
579     /**
580      * @dev Removes a value from a set. O(1).
581      *
582      * Returns true if the value was removed from the set, that is if it was
583      * present.
584      */
585     function remove(UintSet storage set, uint256 value) internal returns (bool) {
586         return _remove(set._inner, bytes32(value));
587     }
588 
589     /**
590      * @dev Returns true if the value is in the set. O(1).
591      */
592     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
593         return _contains(set._inner, bytes32(value));
594     }
595 
596     /**
597      * @dev Returns the number of values on the set. O(1).
598      */
599     function length(UintSet storage set) internal view returns (uint256) {
600         return _length(set._inner);
601     }
602 
603     /**
604      * @dev Returns the value stored at position `index` in the set. O(1).
605      *
606      * Note that there are no guarantees on the ordering of values inside the
607      * array, and it may change when more values are added or removed.
608      *
609      * Requirements:
610      *
611      * - `index` must be strictly less than {length}.
612      */
613     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
614         return uint256(_at(set._inner, index));
615     }
616 
617     /**
618      * @dev Return the entire set in an array
619      *
620      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
621      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
622      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
623      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
624      */
625     function values(UintSet storage set) internal view returns (uint256[] memory) {
626         bytes32[] memory store = _values(set._inner);
627         uint256[] memory result;
628 
629         assembly {
630             result := store
631         }
632 
633         return result;
634     }
635 }
636 
637 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev String operations.
646  */
647 library Strings {
648     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
652      */
653     function toString(uint256 value) internal pure returns (string memory) {
654         // Inspired by OraclizeAPI's implementation - MIT licence
655         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
656 
657         if (value == 0) {
658             return "0";
659         }
660         uint256 temp = value;
661         uint256 digits;
662         while (temp != 0) {
663             digits++;
664             temp /= 10;
665         }
666         bytes memory buffer = new bytes(digits);
667         while (value != 0) {
668             digits -= 1;
669             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
670             value /= 10;
671         }
672         return string(buffer);
673     }
674 
675     /**
676      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
677      */
678     function toHexString(uint256 value) internal pure returns (string memory) {
679         if (value == 0) {
680             return "0x00";
681         }
682         uint256 temp = value;
683         uint256 length = 0;
684         while (temp != 0) {
685             length++;
686             temp >>= 8;
687         }
688         return toHexString(value, length);
689     }
690 
691     /**
692      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
693      */
694     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
695         bytes memory buffer = new bytes(2 * length + 2);
696         buffer[0] = "0";
697         buffer[1] = "x";
698         for (uint256 i = 2 * length + 1; i > 1; --i) {
699             buffer[i] = _HEX_SYMBOLS[value & 0xf];
700             value >>= 4;
701         }
702         require(value == 0, "Strings: hex length insufficient");
703         return string(buffer);
704     }
705 }
706 
707 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
711 
712 pragma solidity ^0.8.1;
713 
714 /**
715  * @dev Collection of functions related to the address type
716  */
717 library Address {
718     /**
719      * @dev Returns true if `account` is a contract.
720      *
721      * [IMPORTANT]
722      * ====
723      * It is unsafe to assume that an address for which this function returns
724      * false is an externally-owned account (EOA) and not a contract.
725      *
726      * Among others, `isContract` will return false for the following
727      * types of addresses:
728      *
729      *  - an externally-owned account
730      *  - a contract in construction
731      *  - an address where a contract will be created
732      *  - an address where a contract lived, but was destroyed
733      * ====
734      *
735      * [IMPORTANT]
736      * ====
737      * You shouldn't rely on `isContract` to protect against flash loan attacks!
738      *
739      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
740      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
741      * constructor.
742      * ====
743      */
744     function isContract(address account) internal view returns (bool) {
745         // This method relies on extcodesize/address.code.length, which returns 0
746         // for contracts in construction, since the code is only stored at the end
747         // of the constructor execution.
748 
749         return account.code.length > 0;
750     }
751 
752     /**
753      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
754      * `recipient`, forwarding all available gas and reverting on errors.
755      *
756      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
757      * of certain opcodes, possibly making contracts go over the 2300 gas limit
758      * imposed by `transfer`, making them unable to receive funds via
759      * `transfer`. {sendValue} removes this limitation.
760      *
761      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
762      *
763      * IMPORTANT: because control is transferred to `recipient`, care must be
764      * taken to not create reentrancy vulnerabilities. Consider using
765      * {ReentrancyGuard} or the
766      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
767      */
768     function sendValue(address payable recipient, uint256 amount) internal {
769         require(address(this).balance >= amount, "Address: insufficient balance");
770 
771         (bool success, ) = recipient.call{value: amount}("");
772         require(success, "Address: unable to send value, recipient may have reverted");
773     }
774 
775     /**
776      * @dev Performs a Solidity function call using a low level `call`. A
777      * plain `call` is an unsafe replacement for a function call: use this
778      * function instead.
779      *
780      * If `target` reverts with a revert reason, it is bubbled up by this
781      * function (like regular Solidity function calls).
782      *
783      * Returns the raw returned data. To convert to the expected return value,
784      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
785      *
786      * Requirements:
787      *
788      * - `target` must be a contract.
789      * - calling `target` with `data` must not revert.
790      *
791      * _Available since v3.1._
792      */
793     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
794         return functionCall(target, data, "Address: low-level call failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
799      * `errorMessage` as a fallback revert reason when `target` reverts.
800      *
801      * _Available since v3.1._
802      */
803     function functionCall(
804         address target,
805         bytes memory data,
806         string memory errorMessage
807     ) internal returns (bytes memory) {
808         return functionCallWithValue(target, data, 0, errorMessage);
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
813      * but also transferring `value` wei to `target`.
814      *
815      * Requirements:
816      *
817      * - the calling contract must have an ETH balance of at least `value`.
818      * - the called Solidity function must be `payable`.
819      *
820      * _Available since v3.1._
821      */
822     function functionCallWithValue(
823         address target,
824         bytes memory data,
825         uint256 value
826     ) internal returns (bytes memory) {
827         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
832      * with `errorMessage` as a fallback revert reason when `target` reverts.
833      *
834      * _Available since v3.1._
835      */
836     function functionCallWithValue(
837         address target,
838         bytes memory data,
839         uint256 value,
840         string memory errorMessage
841     ) internal returns (bytes memory) {
842         require(address(this).balance >= value, "Address: insufficient balance for call");
843         require(isContract(target), "Address: call to non-contract");
844 
845         (bool success, bytes memory returndata) = target.call{value: value}(data);
846         return verifyCallResult(success, returndata, errorMessage);
847     }
848 
849     /**
850      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
851      * but performing a static call.
852      *
853      * _Available since v3.3._
854      */
855     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
856         return functionStaticCall(target, data, "Address: low-level static call failed");
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
861      * but performing a static call.
862      *
863      * _Available since v3.3._
864      */
865     function functionStaticCall(
866         address target,
867         bytes memory data,
868         string memory errorMessage
869     ) internal view returns (bytes memory) {
870         require(isContract(target), "Address: static call to non-contract");
871 
872         (bool success, bytes memory returndata) = target.staticcall(data);
873         return verifyCallResult(success, returndata, errorMessage);
874     }
875 
876     /**
877      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
878      * but performing a delegate call.
879      *
880      * _Available since v3.4._
881      */
882     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
883         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
888      * but performing a delegate call.
889      *
890      * _Available since v3.4._
891      */
892     function functionDelegateCall(
893         address target,
894         bytes memory data,
895         string memory errorMessage
896     ) internal returns (bytes memory) {
897         require(isContract(target), "Address: delegate call to non-contract");
898 
899         (bool success, bytes memory returndata) = target.delegatecall(data);
900         return verifyCallResult(success, returndata, errorMessage);
901     }
902 
903     /**
904      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
905      * revert reason using the provided one.
906      *
907      * _Available since v4.3._
908      */
909     function verifyCallResult(
910         bool success,
911         bytes memory returndata,
912         string memory errorMessage
913     ) internal pure returns (bytes memory) {
914         if (success) {
915             return returndata;
916         } else {
917             // Look for revert reason and bubble it up if present
918             if (returndata.length > 0) {
919                 // The easiest way to bubble the revert reason is using memory via assembly
920 
921                 assembly {
922                     let returndata_size := mload(returndata)
923                     revert(add(32, returndata), returndata_size)
924                 }
925             } else {
926                 revert(errorMessage);
927             }
928         }
929     }
930 }
931 
932 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
933 
934 
935 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 /**
940  * @title ERC721 token receiver interface
941  * @dev Interface for any contract that wants to support safeTransfers
942  * from ERC721 asset contracts.
943  */
944 interface IERC721Receiver {
945     /**
946      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
947      * by `operator` from `from`, this function is called.
948      *
949      * It must return its Solidity selector to confirm the token transfer.
950      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
951      *
952      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
953      */
954     function onERC721Received(
955         address operator,
956         address from,
957         uint256 tokenId,
958         bytes calldata data
959     ) external returns (bytes4);
960 }
961 
962 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 /**
970  * @dev Interface of the ERC165 standard, as defined in the
971  * https://eips.ethereum.org/EIPS/eip-165[EIP].
972  *
973  * Implementers can declare support of contract interfaces, which can then be
974  * queried by others ({ERC165Checker}).
975  *
976  * For an implementation, see {ERC165}.
977  */
978 interface IERC165 {
979     /**
980      * @dev Returns true if this contract implements the interface defined by
981      * `interfaceId`. See the corresponding
982      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
983      * to learn more about how these ids are created.
984      *
985      * This function call must use less than 30 000 gas.
986      */
987     function supportsInterface(bytes4 interfaceId) external view returns (bool);
988 }
989 
990 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
991 
992 
993 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
994 
995 pragma solidity ^0.8.0;
996 
997 
998 /**
999  * @dev Implementation of the {IERC165} interface.
1000  *
1001  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1002  * for the additional interface id that will be supported. For example:
1003  *
1004  * ```solidity
1005  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1006  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1007  * }
1008  * ```
1009  *
1010  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1011  */
1012 abstract contract ERC165 is IERC165 {
1013     /**
1014      * @dev See {IERC165-supportsInterface}.
1015      */
1016     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1017         return interfaceId == type(IERC165).interfaceId;
1018     }
1019 }
1020 
1021 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1022 
1023 
1024 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 
1029 /**
1030  * @dev Required interface of an ERC721 compliant contract.
1031  */
1032 interface IERC721 is IERC165 {
1033     /**
1034      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1035      */
1036     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1037 
1038     /**
1039      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1040      */
1041     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1042 
1043     /**
1044      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1045      */
1046     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1047 
1048     /**
1049      * @dev Returns the number of tokens in ``owner``'s account.
1050      */
1051     function balanceOf(address owner) external view returns (uint256 balance);
1052 
1053     /**
1054      * @dev Returns the owner of the `tokenId` token.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      */
1060     function ownerOf(uint256 tokenId) external view returns (address owner);
1061 
1062     /**
1063      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1064      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1065      *
1066      * Requirements:
1067      *
1068      * - `from` cannot be the zero address.
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must exist and be owned by `from`.
1071      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1072      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) external;
1081 
1082     /**
1083      * @dev Transfers `tokenId` token from `from` to `to`.
1084      *
1085      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1086      *
1087      * Requirements:
1088      *
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must be owned by `from`.
1092      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function transferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) external;
1101 
1102     /**
1103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1104      * The approval is cleared when the token is transferred.
1105      *
1106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1107      *
1108      * Requirements:
1109      *
1110      * - The caller must own the token or be an approved operator.
1111      * - `tokenId` must exist.
1112      *
1113      * Emits an {Approval} event.
1114      */
1115     function approve(address to, uint256 tokenId) external;
1116 
1117     /**
1118      * @dev Returns the account approved for `tokenId` token.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must exist.
1123      */
1124     function getApproved(uint256 tokenId) external view returns (address operator);
1125 
1126     /**
1127      * @dev Approve or remove `operator` as an operator for the caller.
1128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1129      *
1130      * Requirements:
1131      *
1132      * - The `operator` cannot be the caller.
1133      *
1134      * Emits an {ApprovalForAll} event.
1135      */
1136     function setApprovalForAll(address operator, bool _approved) external;
1137 
1138     /**
1139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1140      *
1141      * See {setApprovalForAll}
1142      */
1143     function isApprovedForAll(address owner, address operator) external view returns (bool);
1144 
1145     /**
1146      * @dev Safely transfers `tokenId` token from `from` to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `from` cannot be the zero address.
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must exist and be owned by `from`.
1153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function safeTransferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes calldata data
1163     ) external;
1164 }
1165 
1166 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1167 
1168 
1169 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 /**
1175  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1176  * @dev See https://eips.ethereum.org/EIPS/eip-721
1177  */
1178 interface IERC721Enumerable is IERC721 {
1179     /**
1180      * @dev Returns the total amount of tokens stored by the contract.
1181      */
1182     function totalSupply() external view returns (uint256);
1183 
1184     /**
1185      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1186      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1187      */
1188     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1189 
1190     /**
1191      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1192      * Use along with {totalSupply} to enumerate all tokens.
1193      */
1194     function tokenByIndex(uint256 index) external view returns (uint256);
1195 }
1196 
1197 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1198 
1199 
1200 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1201 
1202 pragma solidity ^0.8.0;
1203 
1204 
1205 /**
1206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1207  * @dev See https://eips.ethereum.org/EIPS/eip-721
1208  */
1209 interface IERC721Metadata is IERC721 {
1210     /**
1211      * @dev Returns the token collection name.
1212      */
1213     function name() external view returns (string memory);
1214 
1215     /**
1216      * @dev Returns the token collection symbol.
1217      */
1218     function symbol() external view returns (string memory);
1219 
1220     /**
1221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1222      */
1223     function tokenURI(uint256 tokenId) external view returns (string memory);
1224 }
1225 
1226 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
1227 
1228 
1229 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 /**
1234  * @dev Contract module that helps prevent reentrant calls to a function.
1235  *
1236  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1237  * available, which can be applied to functions to make sure there are no nested
1238  * (reentrant) calls to them.
1239  *
1240  * Note that because there is a single `nonReentrant` guard, functions marked as
1241  * `nonReentrant` may not call one another. This can be worked around by making
1242  * those functions `private`, and then adding `external` `nonReentrant` entry
1243  * points to them.
1244  *
1245  * TIP: If you would like to learn more about reentrancy and alternative ways
1246  * to protect against it, check out our blog post
1247  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1248  */
1249 abstract contract ReentrancyGuard {
1250     // Booleans are more expensive than uint256 or any type that takes up a full
1251     // word because each write operation emits an extra SLOAD to first read the
1252     // slot's contents, replace the bits taken up by the boolean, and then write
1253     // back. This is the compiler's defense against contract upgrades and
1254     // pointer aliasing, and it cannot be disabled.
1255 
1256     // The values being non-zero value makes deployment a bit more expensive,
1257     // but in exchange the refund on every call to nonReentrant will be lower in
1258     // amount. Since refunds are capped to a percentage of the total
1259     // transaction's gas, it is best to keep them low in cases like this one, to
1260     // increase the likelihood of the full refund coming into effect.
1261     uint256 private constant _NOT_ENTERED = 1;
1262     uint256 private constant _ENTERED = 2;
1263 
1264     uint256 private _status;
1265 
1266     constructor() {
1267         _status = _NOT_ENTERED;
1268     }
1269 
1270     /**
1271      * @dev Prevents a contract from calling itself, directly or indirectly.
1272      * Calling a `nonReentrant` function from another `nonReentrant`
1273      * function is not supported. It is possible to prevent this from happening
1274      * by making the `nonReentrant` function external, and making it call a
1275      * `private` function that does the actual work.
1276      */
1277     modifier nonReentrant() {
1278         // On the first call to nonReentrant, _notEntered will be true
1279         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1280 
1281         // Any calls to nonReentrant after this point will fail
1282         _status = _ENTERED;
1283 
1284         _;
1285 
1286         // By storing the original value once again, a refund is triggered (see
1287         // https://eips.ethereum.org/EIPS/eip-2200)
1288         _status = _NOT_ENTERED;
1289     }
1290 }
1291 
1292 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
1293 
1294 
1295 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1296 
1297 pragma solidity ^0.8.0;
1298 
1299 /**
1300  * @title Counters
1301  * @author Matt Condon (@shrugs)
1302  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1303  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1304  *
1305  * Include with `using Counters for Counters.Counter;`
1306  */
1307 library Counters {
1308     struct Counter {
1309         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1310         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1311         // this feature: see https://github.com/ethereum/solidity/issues/4637
1312         uint256 _value; // default: 0
1313     }
1314 
1315     function current(Counter storage counter) internal view returns (uint256) {
1316         return counter._value;
1317     }
1318 
1319     function increment(Counter storage counter) internal {
1320         unchecked {
1321             counter._value += 1;
1322         }
1323     }
1324 
1325     function decrement(Counter storage counter) internal {
1326         uint256 value = counter._value;
1327         require(value > 0, "Counter: decrement overflow");
1328         unchecked {
1329             counter._value = value - 1;
1330         }
1331     }
1332 
1333     function reset(Counter storage counter) internal {
1334         counter._value = 0;
1335     }
1336 }
1337 
1338 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1339 
1340 
1341 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 /**
1346  * @dev Provides information about the current execution context, including the
1347  * sender of the transaction and its data. While these are generally available
1348  * via msg.sender and msg.data, they should not be accessed in such a direct
1349  * manner, since when dealing with meta-transactions the account sending and
1350  * paying for execution may not be the actual sender (as far as an application
1351  * is concerned).
1352  *
1353  * This contract is only required for intermediate, library-like contracts.
1354  */
1355 abstract contract Context {
1356     function _msgSender() internal view virtual returns (address) {
1357         return msg.sender;
1358     }
1359 
1360     function _msgData() internal view virtual returns (bytes calldata) {
1361         return msg.data;
1362     }
1363 }
1364 
1365 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1366 
1367 
1368 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 
1373 
1374 
1375 
1376 
1377 
1378 
1379 /**
1380  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1381  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1382  * {ERC721Enumerable}.
1383  */
1384 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1385     using Address for address;
1386     using Strings for uint256;
1387 
1388     // Token name
1389     string private _name;
1390 
1391     // Token symbol
1392     string private _symbol;
1393 
1394     // Mapping from token ID to owner address
1395     mapping(uint256 => address) private _owners;
1396 
1397     // Mapping owner address to token count
1398     mapping(address => uint256) private _balances;
1399 
1400     // Mapping from token ID to approved address
1401     mapping(uint256 => address) private _tokenApprovals;
1402 
1403     // Mapping from owner to operator approvals
1404     mapping(address => mapping(address => bool)) private _operatorApprovals;
1405 
1406     /**
1407      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1408      */
1409     constructor(string memory name_, string memory symbol_) {
1410         _name = name_;
1411         _symbol = symbol_;
1412     }
1413 
1414     /**
1415      * @dev See {IERC165-supportsInterface}.
1416      */
1417     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1418         return
1419             interfaceId == type(IERC721).interfaceId ||
1420             interfaceId == type(IERC721Metadata).interfaceId ||
1421             super.supportsInterface(interfaceId);
1422     }
1423 
1424     /**
1425      * @dev See {IERC721-balanceOf}.
1426      */
1427     function balanceOf(address owner) public view virtual override returns (uint256) {
1428         require(owner != address(0), "ERC721: balance query for the zero address");
1429         return _balances[owner];
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-ownerOf}.
1434      */
1435     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1436         address owner = _owners[tokenId];
1437         require(owner != address(0), "ERC721: owner query for nonexistent token");
1438         return owner;
1439     }
1440 
1441     /**
1442      * @dev See {IERC721Metadata-name}.
1443      */
1444     function name() public view virtual override returns (string memory) {
1445         return _name;
1446     }
1447 
1448     /**
1449      * @dev See {IERC721Metadata-symbol}.
1450      */
1451     function symbol() public view virtual override returns (string memory) {
1452         return _symbol;
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Metadata-tokenURI}.
1457      */
1458     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1459         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1460 
1461         string memory baseURI = _baseURI();
1462         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1463     }
1464 
1465     /**
1466      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1467      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1468      * by default, can be overridden in child contracts.
1469      */
1470     function _baseURI() internal view virtual returns (string memory) {
1471         return "";
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-approve}.
1476      */
1477     function approve(address to, uint256 tokenId) public virtual override {
1478         address owner = ERC721.ownerOf(tokenId);
1479         require(to != owner, "ERC721: approval to current owner");
1480 
1481         require(
1482             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1483             "ERC721: approve caller is not owner nor approved for all"
1484         );
1485 
1486         _approve(to, tokenId);
1487     }
1488 
1489     /**
1490      * @dev See {IERC721-getApproved}.
1491      */
1492     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1493         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1494 
1495         return _tokenApprovals[tokenId];
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-setApprovalForAll}.
1500      */
1501     function setApprovalForAll(address operator, bool approved) public virtual override {
1502         _setApprovalForAll(_msgSender(), operator, approved);
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-isApprovedForAll}.
1507      */
1508     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1509         return _operatorApprovals[owner][operator];
1510     }
1511 
1512     /**
1513      * @dev See {IERC721-transferFrom}.
1514      */
1515     function transferFrom(
1516         address from,
1517         address to,
1518         uint256 tokenId
1519     ) public virtual override {
1520         //solhint-disable-next-line max-line-length
1521         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1522 
1523         _transfer(from, to, tokenId);
1524     }
1525 
1526     /**
1527      * @dev See {IERC721-safeTransferFrom}.
1528      */
1529     function safeTransferFrom(
1530         address from,
1531         address to,
1532         uint256 tokenId
1533     ) public virtual override {
1534         safeTransferFrom(from, to, tokenId, "");
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-safeTransferFrom}.
1539      */
1540     function safeTransferFrom(
1541         address from,
1542         address to,
1543         uint256 tokenId,
1544         bytes memory _data
1545     ) public virtual override {
1546         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1547         _safeTransfer(from, to, tokenId, _data);
1548     }
1549 
1550     /**
1551      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1552      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1553      *
1554      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1555      *
1556      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1557      * implement alternative mechanisms to perform token transfer, such as signature-based.
1558      *
1559      * Requirements:
1560      *
1561      * - `from` cannot be the zero address.
1562      * - `to` cannot be the zero address.
1563      * - `tokenId` token must exist and be owned by `from`.
1564      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1565      *
1566      * Emits a {Transfer} event.
1567      */
1568     function _safeTransfer(
1569         address from,
1570         address to,
1571         uint256 tokenId,
1572         bytes memory _data
1573     ) internal virtual {
1574         _transfer(from, to, tokenId);
1575         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1576     }
1577 
1578     /**
1579      * @dev Returns whether `tokenId` exists.
1580      *
1581      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1582      *
1583      * Tokens start existing when they are minted (`_mint`),
1584      * and stop existing when they are burned (`_burn`).
1585      */
1586     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1587         return _owners[tokenId] != address(0);
1588     }
1589 
1590     /**
1591      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1592      *
1593      * Requirements:
1594      *
1595      * - `tokenId` must exist.
1596      */
1597     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1598         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1599         address owner = ERC721.ownerOf(tokenId);
1600         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1601     }
1602 
1603     /**
1604      * @dev Safely mints `tokenId` and transfers it to `to`.
1605      *
1606      * Requirements:
1607      *
1608      * - `tokenId` must not exist.
1609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1610      *
1611      * Emits a {Transfer} event.
1612      */
1613     function _safeMint(address to, uint256 tokenId) internal virtual {
1614         _safeMint(to, tokenId, "");
1615     }
1616 
1617     /**
1618      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1619      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1620      */
1621     function _safeMint(
1622         address to,
1623         uint256 tokenId,
1624         bytes memory _data
1625     ) internal virtual {
1626         _mint(to, tokenId);
1627         require(
1628             _checkOnERC721Received(address(0), to, tokenId, _data),
1629             "ERC721: transfer to non ERC721Receiver implementer"
1630         );
1631     }
1632 
1633     /**
1634      * @dev Mints `tokenId` and transfers it to `to`.
1635      *
1636      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1637      *
1638      * Requirements:
1639      *
1640      * - `tokenId` must not exist.
1641      * - `to` cannot be the zero address.
1642      *
1643      * Emits a {Transfer} event.
1644      */
1645     function _mint(address to, uint256 tokenId) internal virtual {
1646         require(to != address(0), "ERC721: mint to the zero address");
1647         require(!_exists(tokenId), "ERC721: token already minted");
1648 
1649         _beforeTokenTransfer(address(0), to, tokenId);
1650 
1651         _balances[to] += 1;
1652         _owners[tokenId] = to;
1653 
1654         emit Transfer(address(0), to, tokenId);
1655 
1656         _afterTokenTransfer(address(0), to, tokenId);
1657     }
1658 
1659     /**
1660      * @dev Destroys `tokenId`.
1661      * The approval is cleared when the token is burned.
1662      *
1663      * Requirements:
1664      *
1665      * - `tokenId` must exist.
1666      *
1667      * Emits a {Transfer} event.
1668      */
1669     function _burn(uint256 tokenId) internal virtual {
1670         address owner = ERC721.ownerOf(tokenId);
1671 
1672         _beforeTokenTransfer(owner, address(0), tokenId);
1673 
1674         // Clear approvals
1675         _approve(address(0), tokenId);
1676 
1677         _balances[owner] -= 1;
1678         delete _owners[tokenId];
1679 
1680         emit Transfer(owner, address(0), tokenId);
1681 
1682         _afterTokenTransfer(owner, address(0), tokenId);
1683     }
1684 
1685     /**
1686      * @dev Transfers `tokenId` from `from` to `to`.
1687      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1688      *
1689      * Requirements:
1690      *
1691      * - `to` cannot be the zero address.
1692      * - `tokenId` token must be owned by `from`.
1693      *
1694      * Emits a {Transfer} event.
1695      */
1696     function _transfer(
1697         address from,
1698         address to,
1699         uint256 tokenId
1700     ) internal virtual {
1701         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1702         require(to != address(0), "ERC721: transfer to the zero address");
1703 
1704         _beforeTokenTransfer(from, to, tokenId);
1705 
1706         // Clear approvals from the previous owner
1707         _approve(address(0), tokenId);
1708 
1709         _balances[from] -= 1;
1710         _balances[to] += 1;
1711         _owners[tokenId] = to;
1712 
1713         emit Transfer(from, to, tokenId);
1714 
1715         _afterTokenTransfer(from, to, tokenId);
1716     }
1717 
1718     /**
1719      * @dev Approve `to` to operate on `tokenId`
1720      *
1721      * Emits a {Approval} event.
1722      */
1723     function _approve(address to, uint256 tokenId) internal virtual {
1724         _tokenApprovals[tokenId] = to;
1725         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1726     }
1727 
1728     /**
1729      * @dev Approve `operator` to operate on all of `owner` tokens
1730      *
1731      * Emits a {ApprovalForAll} event.
1732      */
1733     function _setApprovalForAll(
1734         address owner,
1735         address operator,
1736         bool approved
1737     ) internal virtual {
1738         require(owner != operator, "ERC721: approve to caller");
1739         _operatorApprovals[owner][operator] = approved;
1740         emit ApprovalForAll(owner, operator, approved);
1741     }
1742 
1743     /**
1744      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1745      * The call is not executed if the target address is not a contract.
1746      *
1747      * @param from address representing the previous owner of the given token ID
1748      * @param to target address that will receive the tokens
1749      * @param tokenId uint256 ID of the token to be transferred
1750      * @param _data bytes optional data to send along with the call
1751      * @return bool whether the call correctly returned the expected magic value
1752      */
1753     function _checkOnERC721Received(
1754         address from,
1755         address to,
1756         uint256 tokenId,
1757         bytes memory _data
1758     ) private returns (bool) {
1759         if (to.isContract()) {
1760             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1761                 return retval == IERC721Receiver.onERC721Received.selector;
1762             } catch (bytes memory reason) {
1763                 if (reason.length == 0) {
1764                     revert("ERC721: transfer to non ERC721Receiver implementer");
1765                 } else {
1766                     assembly {
1767                         revert(add(32, reason), mload(reason))
1768                     }
1769                 }
1770             }
1771         } else {
1772             return true;
1773         }
1774     }
1775 
1776     /**
1777      * @dev Hook that is called before any token transfer. This includes minting
1778      * and burning.
1779      *
1780      * Calling conditions:
1781      *
1782      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1783      * transferred to `to`.
1784      * - When `from` is zero, `tokenId` will be minted for `to`.
1785      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1786      * - `from` and `to` are never both zero.
1787      *
1788      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1789      */
1790     function _beforeTokenTransfer(
1791         address from,
1792         address to,
1793         uint256 tokenId
1794     ) internal virtual {}
1795 
1796     /**
1797      * @dev Hook that is called after any transfer of tokens. This includes
1798      * minting and burning.
1799      *
1800      * Calling conditions:
1801      *
1802      * - when `from` and `to` are both non-zero.
1803      * - `from` and `to` are never both zero.
1804      *
1805      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1806      */
1807     function _afterTokenTransfer(
1808         address from,
1809         address to,
1810         uint256 tokenId
1811     ) internal virtual {}
1812 }
1813 
1814 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1815 
1816 
1817 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1818 
1819 pragma solidity ^0.8.0;
1820 
1821 
1822 
1823 /**
1824  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1825  * enumerability of all the token ids in the contract as well as all token ids owned by each
1826  * account.
1827  */
1828 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1829     // Mapping from owner to list of owned token IDs
1830     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1831 
1832     // Mapping from token ID to index of the owner tokens list
1833     mapping(uint256 => uint256) private _ownedTokensIndex;
1834 
1835     // Array with all token ids, used for enumeration
1836     uint256[] private _allTokens;
1837 
1838     // Mapping from token id to position in the allTokens array
1839     mapping(uint256 => uint256) private _allTokensIndex;
1840 
1841     /**
1842      * @dev See {IERC165-supportsInterface}.
1843      */
1844     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1845         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1846     }
1847 
1848     /**
1849      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1850      */
1851     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1852         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1853         return _ownedTokens[owner][index];
1854     }
1855 
1856     /**
1857      * @dev See {IERC721Enumerable-totalSupply}.
1858      */
1859     function totalSupply() public view virtual override returns (uint256) {
1860         return _allTokens.length;
1861     }
1862 
1863     /**
1864      * @dev See {IERC721Enumerable-tokenByIndex}.
1865      */
1866     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1867         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1868         return _allTokens[index];
1869     }
1870 
1871     /**
1872      * @dev Hook that is called before any token transfer. This includes minting
1873      * and burning.
1874      *
1875      * Calling conditions:
1876      *
1877      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1878      * transferred to `to`.
1879      * - When `from` is zero, `tokenId` will be minted for `to`.
1880      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1881      * - `from` cannot be the zero address.
1882      * - `to` cannot be the zero address.
1883      *
1884      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1885      */
1886     function _beforeTokenTransfer(
1887         address from,
1888         address to,
1889         uint256 tokenId
1890     ) internal virtual override {
1891         super._beforeTokenTransfer(from, to, tokenId);
1892 
1893         if (from == address(0)) {
1894             _addTokenToAllTokensEnumeration(tokenId);
1895         } else if (from != to) {
1896             _removeTokenFromOwnerEnumeration(from, tokenId);
1897         }
1898         if (to == address(0)) {
1899             _removeTokenFromAllTokensEnumeration(tokenId);
1900         } else if (to != from) {
1901             _addTokenToOwnerEnumeration(to, tokenId);
1902         }
1903     }
1904 
1905     /**
1906      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1907      * @param to address representing the new owner of the given token ID
1908      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1909      */
1910     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1911         uint256 length = ERC721.balanceOf(to);
1912         _ownedTokens[to][length] = tokenId;
1913         _ownedTokensIndex[tokenId] = length;
1914     }
1915 
1916     /**
1917      * @dev Private function to add a token to this extension's token tracking data structures.
1918      * @param tokenId uint256 ID of the token to be added to the tokens list
1919      */
1920     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1921         _allTokensIndex[tokenId] = _allTokens.length;
1922         _allTokens.push(tokenId);
1923     }
1924 
1925     /**
1926      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1927      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1928      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1929      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1930      * @param from address representing the previous owner of the given token ID
1931      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1932      */
1933     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1934         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1935         // then delete the last slot (swap and pop).
1936 
1937         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1938         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1939 
1940         // When the token to delete is the last token, the swap operation is unnecessary
1941         if (tokenIndex != lastTokenIndex) {
1942             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1943 
1944             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1945             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1946         }
1947 
1948         // This also deletes the contents at the last position of the array
1949         delete _ownedTokensIndex[tokenId];
1950         delete _ownedTokens[from][lastTokenIndex];
1951     }
1952 
1953     /**
1954      * @dev Private function to remove a token from this extension's token tracking data structures.
1955      * This has O(1) time complexity, but alters the order of the _allTokens array.
1956      * @param tokenId uint256 ID of the token to be removed from the tokens list
1957      */
1958     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1959         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1960         // then delete the last slot (swap and pop).
1961 
1962         uint256 lastTokenIndex = _allTokens.length - 1;
1963         uint256 tokenIndex = _allTokensIndex[tokenId];
1964 
1965         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1966         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1967         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1968         uint256 lastTokenId = _allTokens[lastTokenIndex];
1969 
1970         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1971         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1972 
1973         // This also deletes the contents at the last position of the array
1974         delete _allTokensIndex[tokenId];
1975         _allTokens.pop();
1976     }
1977 }
1978 
1979 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1980 
1981 
1982 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1983 
1984 pragma solidity ^0.8.0;
1985 
1986 
1987 /**
1988  * @dev Contract module which provides a basic access control mechanism, where
1989  * there is an account (an owner) that can be granted exclusive access to
1990  * specific functions.
1991  *
1992  * By default, the owner account will be the one that deploys the contract. This
1993  * can later be changed with {transferOwnership}.
1994  *
1995  * This module is used through inheritance. It will make available the modifier
1996  * `onlyOwner`, which can be applied to your functions to restrict their use to
1997  * the owner.
1998  */
1999 abstract contract Ownable is Context {
2000     address private _owner;
2001 
2002     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2003 
2004     /**
2005      * @dev Initializes the contract setting the deployer as the initial owner.
2006      */
2007     constructor() {
2008         _transferOwnership(_msgSender());
2009     }
2010 
2011     /**
2012      * @dev Returns the address of the current owner.
2013      */
2014     function owner() public view virtual returns (address) {
2015         return _owner;
2016     }
2017 
2018     /**
2019      * @dev Throws if called by any account other than the owner.
2020      */
2021     modifier onlyOwner() {
2022         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2023         _;
2024     }
2025 
2026     /**
2027      * @dev Leaves the contract without owner. It will not be possible to call
2028      * `onlyOwner` functions anymore. Can only be called by the current owner.
2029      *
2030      * NOTE: Renouncing ownership will leave the contract without an owner,
2031      * thereby removing any functionality that is only available to the owner.
2032      */
2033     function renounceOwnership() public virtual onlyOwner {
2034         _transferOwnership(address(0));
2035     }
2036 
2037     /**
2038      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2039      * Can only be called by the current owner.
2040      */
2041     function transferOwnership(address newOwner) public virtual onlyOwner {
2042         require(newOwner != address(0), "Ownable: new owner is the zero address");
2043         _transferOwnership(newOwner);
2044     }
2045 
2046     /**
2047      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2048      * Internal function without access restriction.
2049      */
2050     function _transferOwnership(address newOwner) internal virtual {
2051         address oldOwner = _owner;
2052         _owner = newOwner;
2053         emit OwnershipTransferred(oldOwner, newOwner);
2054     }
2055 }
2056 
2057 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
2058 
2059 
2060 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
2061 
2062 pragma solidity ^0.8.0;
2063 
2064 /**
2065  * @dev Interface of the ERC20 standard as defined in the EIP.
2066  */
2067 interface IERC20 {
2068     /**
2069      * @dev Returns the amount of tokens in existence.
2070      */
2071     function totalSupply() external view returns (uint256);
2072 
2073     /**
2074      * @dev Returns the amount of tokens owned by `account`.
2075      */
2076     function balanceOf(address account) external view returns (uint256);
2077 
2078     /**
2079      * @dev Moves `amount` tokens from the caller's account to `recipient`.
2080      *
2081      * Returns a boolean value indicating whether the operation succeeded.
2082      *
2083      * Emits a {Transfer} event.
2084      */
2085     function transfer(address recipient, uint256 amount) external returns (bool);
2086 
2087     /**
2088      * @dev Returns the remaining number of tokens that `spender` will be
2089      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2090      * zero by default.
2091      *
2092      * This value changes when {approve} or {transferFrom} are called.
2093      */
2094     function allowance(address owner, address spender) external view returns (uint256);
2095 
2096     /**
2097      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2098      *
2099      * Returns a boolean value indicating whether the operation succeeded.
2100      *
2101      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2102      * that someone may use both the old and the new allowance by unfortunate
2103      * transaction ordering. One possible solution to mitigate this race
2104      * condition is to first reduce the spender's allowance to 0 and set the
2105      * desired value afterwards:
2106      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2107      *
2108      * Emits an {Approval} event.
2109      */
2110     function approve(address spender, uint256 amount) external returns (bool);
2111 
2112     /**
2113      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2114      * allowance mechanism. `amount` is then deducted from the caller's
2115      * allowance.
2116      *
2117      * Returns a boolean value indicating whether the operation succeeded.
2118      *
2119      * Emits a {Transfer} event.
2120      */
2121     function transferFrom(
2122         address sender,
2123         address recipient,
2124         uint256 amount
2125     ) external returns (bool);
2126 
2127     /**
2128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2129      * another (`to`).
2130      *
2131      * Note that `value` may be zero.
2132      */
2133     event Transfer(address indexed from, address indexed to, uint256 value);
2134 
2135     /**
2136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2137      * a call to {approve}. `value` is the new allowance.
2138      */
2139     event Approval(address indexed owner, address indexed spender, uint256 value);
2140 }
2141 
2142 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
2143 
2144 
2145 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2146 
2147 pragma solidity ^0.8.0;
2148 
2149 
2150 /**
2151  * @dev Interface for the optional metadata functions from the ERC20 standard.
2152  *
2153  * _Available since v4.1._
2154  */
2155 interface IERC20Metadata is IERC20 {
2156     /**
2157      * @dev Returns the name of the token.
2158      */
2159     function name() external view returns (string memory);
2160 
2161     /**
2162      * @dev Returns the symbol of the token.
2163      */
2164     function symbol() external view returns (string memory);
2165 
2166     /**
2167      * @dev Returns the decimals places of the token.
2168      */
2169     function decimals() external view returns (uint8);
2170 }
2171 
2172 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
2173 
2174 
2175 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
2176 
2177 pragma solidity ^0.8.0;
2178 
2179 
2180 
2181 
2182 /**
2183  * @dev Implementation of the {IERC20} interface.
2184  *
2185  * This implementation is agnostic to the way tokens are created. This means
2186  * that a supply mechanism has to be added in a derived contract using {_mint}.
2187  * For a generic mechanism see {ERC20PresetMinterPauser}.
2188  *
2189  * TIP: For a detailed writeup see our guide
2190  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2191  * to implement supply mechanisms].
2192  *
2193  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2194  * instead returning `false` on failure. This behavior is nonetheless
2195  * conventional and does not conflict with the expectations of ERC20
2196  * applications.
2197  *
2198  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2199  * This allows applications to reconstruct the allowance for all accounts just
2200  * by listening to said events. Other implementations of the EIP may not emit
2201  * these events, as it isn't required by the specification.
2202  *
2203  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2204  * functions have been added to mitigate the well-known issues around setting
2205  * allowances. See {IERC20-approve}.
2206  */
2207 contract ERC20 is Context, IERC20, IERC20Metadata {
2208     mapping(address => uint256) private _balances;
2209 
2210     mapping(address => mapping(address => uint256)) private _allowances;
2211 
2212     uint256 private _totalSupply;
2213 
2214     string private _name;
2215     string private _symbol;
2216 
2217     /**
2218      * @dev Sets the values for {name} and {symbol}.
2219      *
2220      * The default value of {decimals} is 18. To select a different value for
2221      * {decimals} you should overload it.
2222      *
2223      * All two of these values are immutable: they can only be set once during
2224      * construction.
2225      */
2226     constructor(string memory name_, string memory symbol_) {
2227         _name = name_;
2228         _symbol = symbol_;
2229     }
2230 
2231     /**
2232      * @dev Returns the name of the token.
2233      */
2234     function name() public view virtual override returns (string memory) {
2235         return _name;
2236     }
2237 
2238     /**
2239      * @dev Returns the symbol of the token, usually a shorter version of the
2240      * name.
2241      */
2242     function symbol() public view virtual override returns (string memory) {
2243         return _symbol;
2244     }
2245 
2246     /**
2247      * @dev Returns the number of decimals used to get its user representation.
2248      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2249      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2250      *
2251      * Tokens usually opt for a value of 18, imitating the relationship between
2252      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2253      * overridden;
2254      *
2255      * NOTE: This information is only used for _display_ purposes: it in
2256      * no way affects any of the arithmetic of the contract, including
2257      * {IERC20-balanceOf} and {IERC20-transfer}.
2258      */
2259     function decimals() public view virtual override returns (uint8) {
2260         return 18;
2261     }
2262 
2263     /**
2264      * @dev See {IERC20-totalSupply}.
2265      */
2266     function totalSupply() public view virtual override returns (uint256) {
2267         return _totalSupply;
2268     }
2269 
2270     /**
2271      * @dev See {IERC20-balanceOf}.
2272      */
2273     function balanceOf(address account) public view virtual override returns (uint256) {
2274         return _balances[account];
2275     }
2276 
2277     /**
2278      * @dev See {IERC20-transfer}.
2279      *
2280      * Requirements:
2281      *
2282      * - `recipient` cannot be the zero address.
2283      * - the caller must have a balance of at least `amount`.
2284      */
2285     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2286         _transfer(_msgSender(), recipient, amount);
2287         return true;
2288     }
2289 
2290     /**
2291      * @dev See {IERC20-allowance}.
2292      */
2293     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2294         return _allowances[owner][spender];
2295     }
2296 
2297     /**
2298      * @dev See {IERC20-approve}.
2299      *
2300      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2301      * `transferFrom`. This is semantically equivalent to an infinite approval.
2302      *
2303      * Requirements:
2304      *
2305      * - `spender` cannot be the zero address.
2306      */
2307     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2308         _approve(_msgSender(), spender, amount);
2309         return true;
2310     }
2311 
2312     /**
2313      * @dev See {IERC20-transferFrom}.
2314      *
2315      * Emits an {Approval} event indicating the updated allowance. This is not
2316      * required by the EIP. See the note at the beginning of {ERC20}.
2317      *
2318      * NOTE: Does not update the allowance if the current allowance
2319      * is the maximum `uint256`.
2320      *
2321      * Requirements:
2322      *
2323      * - `sender` and `recipient` cannot be the zero address.
2324      * - `sender` must have a balance of at least `amount`.
2325      * - the caller must have allowance for ``sender``'s tokens of at least
2326      * `amount`.
2327      */
2328     function transferFrom(
2329         address sender,
2330         address recipient,
2331         uint256 amount
2332     ) public virtual override returns (bool) {
2333         uint256 currentAllowance = _allowances[sender][_msgSender()];
2334         if (currentAllowance != type(uint256).max) {
2335             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
2336             unchecked {
2337                 _approve(sender, _msgSender(), currentAllowance - amount);
2338             }
2339         }
2340 
2341         _transfer(sender, recipient, amount);
2342 
2343         return true;
2344     }
2345 
2346     /**
2347      * @dev Atomically increases the allowance granted to `spender` by the caller.
2348      *
2349      * This is an alternative to {approve} that can be used as a mitigation for
2350      * problems described in {IERC20-approve}.
2351      *
2352      * Emits an {Approval} event indicating the updated allowance.
2353      *
2354      * Requirements:
2355      *
2356      * - `spender` cannot be the zero address.
2357      */
2358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
2360         return true;
2361     }
2362 
2363     /**
2364      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2365      *
2366      * This is an alternative to {approve} that can be used as a mitigation for
2367      * problems described in {IERC20-approve}.
2368      *
2369      * Emits an {Approval} event indicating the updated allowance.
2370      *
2371      * Requirements:
2372      *
2373      * - `spender` cannot be the zero address.
2374      * - `spender` must have allowance for the caller of at least
2375      * `subtractedValue`.
2376      */
2377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2378         uint256 currentAllowance = _allowances[_msgSender()][spender];
2379         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2380         unchecked {
2381             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
2382         }
2383 
2384         return true;
2385     }
2386 
2387     /**
2388      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2389      *
2390      * This internal function is equivalent to {transfer}, and can be used to
2391      * e.g. implement automatic token fees, slashing mechanisms, etc.
2392      *
2393      * Emits a {Transfer} event.
2394      *
2395      * Requirements:
2396      *
2397      * - `sender` cannot be the zero address.
2398      * - `recipient` cannot be the zero address.
2399      * - `sender` must have a balance of at least `amount`.
2400      */
2401     function _transfer(
2402         address sender,
2403         address recipient,
2404         uint256 amount
2405     ) internal virtual {
2406         require(sender != address(0), "ERC20: transfer from the zero address");
2407         require(recipient != address(0), "ERC20: transfer to the zero address");
2408 
2409         _beforeTokenTransfer(sender, recipient, amount);
2410 
2411         uint256 senderBalance = _balances[sender];
2412         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
2413         unchecked {
2414             _balances[sender] = senderBalance - amount;
2415         }
2416         _balances[recipient] += amount;
2417 
2418         emit Transfer(sender, recipient, amount);
2419 
2420         _afterTokenTransfer(sender, recipient, amount);
2421     }
2422 
2423     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2424      * the total supply.
2425      *
2426      * Emits a {Transfer} event with `from` set to the zero address.
2427      *
2428      * Requirements:
2429      *
2430      * - `account` cannot be the zero address.
2431      */
2432     function _mint(address account, uint256 amount) internal virtual {
2433         require(account != address(0), "ERC20: mint to the zero address");
2434 
2435         _beforeTokenTransfer(address(0), account, amount);
2436 
2437         _totalSupply += amount;
2438         _balances[account] += amount;
2439         emit Transfer(address(0), account, amount);
2440 
2441         _afterTokenTransfer(address(0), account, amount);
2442     }
2443 
2444     /**
2445      * @dev Destroys `amount` tokens from `account`, reducing the
2446      * total supply.
2447      *
2448      * Emits a {Transfer} event with `to` set to the zero address.
2449      *
2450      * Requirements:
2451      *
2452      * - `account` cannot be the zero address.
2453      * - `account` must have at least `amount` tokens.
2454      */
2455     function _burn(address account, uint256 amount) internal virtual {
2456         require(account != address(0), "ERC20: burn from the zero address");
2457 
2458         _beforeTokenTransfer(account, address(0), amount);
2459 
2460         uint256 accountBalance = _balances[account];
2461         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2462         unchecked {
2463             _balances[account] = accountBalance - amount;
2464         }
2465         _totalSupply -= amount;
2466 
2467         emit Transfer(account, address(0), amount);
2468 
2469         _afterTokenTransfer(account, address(0), amount);
2470     }
2471 
2472     /**
2473      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2474      *
2475      * This internal function is equivalent to `approve`, and can be used to
2476      * e.g. set automatic allowances for certain subsystems, etc.
2477      *
2478      * Emits an {Approval} event.
2479      *
2480      * Requirements:
2481      *
2482      * - `owner` cannot be the zero address.
2483      * - `spender` cannot be the zero address.
2484      */
2485     function _approve(
2486         address owner,
2487         address spender,
2488         uint256 amount
2489     ) internal virtual {
2490         require(owner != address(0), "ERC20: approve from the zero address");
2491         require(spender != address(0), "ERC20: approve to the zero address");
2492 
2493         _allowances[owner][spender] = amount;
2494         emit Approval(owner, spender, amount);
2495     }
2496 
2497     /**
2498      * @dev Hook that is called before any transfer of tokens. This includes
2499      * minting and burning.
2500      *
2501      * Calling conditions:
2502      *
2503      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2504      * will be transferred to `to`.
2505      * - when `from` is zero, `amount` tokens will be minted for `to`.
2506      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2507      * - `from` and `to` are never both zero.
2508      *
2509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2510      */
2511     function _beforeTokenTransfer(
2512         address from,
2513         address to,
2514         uint256 amount
2515     ) internal virtual {}
2516 
2517     /**
2518      * @dev Hook that is called after any transfer of tokens. This includes
2519      * minting and burning.
2520      *
2521      * Calling conditions:
2522      *
2523      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2524      * has been transferred to `to`.
2525      * - when `from` is zero, `amount` tokens have been minted for `to`.
2526      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2527      * - `from` and `to` are never both zero.
2528      *
2529      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2530      */
2531     function _afterTokenTransfer(
2532         address from,
2533         address to,
2534         uint256 amount
2535     ) internal virtual {}
2536 }
2537 
2538 // File: cosmicToken.sol
2539 
2540 pragma solidity 0.8.7;
2541 
2542 
2543 
2544 interface IDuck {
2545 	function balanceOG(address _user) external view returns(uint256);
2546 }
2547 
2548 contract CosmicToken is ERC20("CosmicUtilityToken", "CUT") 
2549 {
2550    
2551     using SafeMath for uint256;
2552    
2553     uint256 public totalTokensBurned = 0;
2554     address[] internal stakeholders;
2555     address  payable private owner;
2556     
2557 
2558     //token Genesis per day
2559     uint256 constant public GENESIS_RATE = 20 ether; 
2560     
2561     //token duck per day
2562     uint256 constant public DUCK_RATE = 5 ether; 
2563     
2564     //token for  genesis minting
2565 	uint256 constant public GENESIS_ISSUANCE = 280 ether;
2566 	
2567 	//token for duck minting
2568 	uint256 constant public DUCK_ISSUANCE = 70 ether;
2569 	
2570 	
2571 	
2572 	// Tue Mar 18 2031 17:46:47 GMT+0000
2573 	uint256 constant public END = 1931622407;
2574 
2575 	mapping(address => uint256) public rewards;
2576 	mapping(address => uint256) public lastUpdate;
2577 	
2578 	
2579     IDuck public ducksContract;
2580    
2581     constructor(address initDuckContract) 
2582     {
2583         owner = payable(msg.sender);
2584         ducksContract = IDuck(initDuckContract);
2585 
2586 		_mint(msg.sender, (1000000 * 10 ** 18));
2587 		_mint(0xb93329bB93F52362E97Fd5F953f98Ebed1438Cd8, (1000000 * 10 ** 18));
2588 
2589 		_mint(0x83e02c9f0ec019f75d3B7E6Ac193109c9e7224EA, (1000000 * 10 ** 18));
2590     }
2591    
2592 
2593     function WhoOwns() public view returns (address) {
2594         return owner;
2595     }
2596    
2597     modifier Owned {
2598          require(msg.sender == owner);
2599          _;
2600  }
2601    
2602     function getContractAddress() public view returns (address) {
2603         return address(this);
2604     }
2605 
2606 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
2607 		return a < b ? a : b;
2608 	}    
2609 	
2610 	modifier contractAddressOnly
2611     {
2612          require(msg.sender == address(ducksContract));
2613          _;
2614     }
2615     
2616    	// called when minting many NFTs
2617 	function updateRewardOnMint(address _user, uint256 _tokenId) external contractAddressOnly
2618 	{
2619 	    if(_tokenId <= 1000)
2620 		{
2621             _mint(_user,GENESIS_ISSUANCE);	  	        
2622 		}
2623 		else if(_tokenId >= 1001)
2624 		{
2625             _mint(_user,DUCK_ISSUANCE);	  	        	        
2626 		}
2627 	}
2628 	
2629 
2630 	function getReward(address _to, uint256 totalPayout) external contractAddressOnly
2631 	{
2632 		_mint(_to, (totalPayout * 10 ** 18));
2633 		
2634 	}
2635 	
2636 	function burn(address _from, uint256 _amount) external 
2637 	{
2638 	    require(msg.sender == _from, "You do not own these tokens");
2639 		_burn(_from, _amount);
2640 		totalTokensBurned += _amount;
2641 	}
2642 
2643 
2644   
2645    
2646 }
2647 // File: cosmicLabs.sol
2648 
2649 pragma solidity 0.8.7;
2650 
2651 
2652 
2653 
2654 
2655 contract CosmicLabs is ERC721Enumerable, IERC721Receiver, Ownable {
2656    
2657    using Strings for uint256;
2658    using EnumerableSet for EnumerableSet.UintSet;
2659    
2660     CosmicToken public cosmictoken;
2661     
2662     using Counters for Counters.Counter;
2663     Counters.Counter private _tokenIdTracker;
2664     
2665     string public baseURI;
2666     string public baseExtension = ".json";
2667 
2668     
2669     uint public maxGenesisTx = 4;
2670     uint public maxDuckTx = 20;
2671     
2672     
2673     uint public maxSupply = 9000;
2674     uint public genesisSupply = 1000;
2675     
2676     uint256 public price = 0.05 ether;
2677    
2678 
2679     bool public GensisSaleOpen = true;
2680     bool public GenesisFreeMintOpen = false;
2681     bool public DuckMintOpen = false;
2682     
2683     
2684     
2685     modifier isSaleOpen
2686     {
2687          require(GensisSaleOpen == true);
2688          _;
2689     }
2690     
2691     modifier isFreeMintOpen
2692     {
2693          require(GenesisFreeMintOpen == true);
2694          _;
2695     }
2696     
2697     modifier isDuckMintOpen
2698     {
2699          require(DuckMintOpen == true);
2700          _;
2701     }
2702     
2703 
2704     
2705     function switchFromFreeToDuckMint() public onlyOwner
2706     {
2707         GenesisFreeMintOpen = false;
2708         DuckMintOpen = true;
2709     }
2710     
2711     
2712     
2713     event mint(address to, uint total);
2714     event withdraw(uint total);
2715     event giveawayNft(address to, uint tokenID);
2716     
2717     mapping(address => uint256) public balanceOG;
2718     
2719     mapping(address => uint256) public maxWalletGenesisTX;
2720     mapping(address => uint256) public maxWalletDuckTX;
2721     
2722     mapping(address => EnumerableSet.UintSet) private _deposits;
2723     
2724     
2725     mapping(uint256 => uint256) public _deposit_blocks;
2726     
2727     mapping(address => bool) public addressStaked;
2728     
2729     //ID - Days staked;
2730     mapping(uint256 => uint256) public IDvsDaysStaked;
2731     mapping (address => uint256) public whitelistMintAmount;
2732     
2733 
2734    address internal communityWallet = 0xea25545d846ecF4999C2875bC77dE5B5151Fa633;
2735    
2736     constructor(string memory _initBaseURI) ERC721("Cosmic Labs", "CLABS")
2737     {
2738         setBaseURI(_initBaseURI);
2739 
2740         for(uint256 i; i<5; i++)
2741         {
2742             _tokenIdTracker.increment();
2743             _safeMint(msg.sender, totalToken());
2744             _tokenIdTracker.increment();
2745             _safeMint(0xb93329bB93F52362E97Fd5F953f98Ebed1438Cd8, totalToken());
2746             _tokenIdTracker.increment();
2747             _safeMint(0x83e02c9f0ec019f75d3B7E6Ac193109c9e7224EA, totalToken());
2748             
2749         }
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
3040 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Capped.sol
3041 
3042 
3043 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Capped.sol)
3044 
3045 pragma solidity ^0.8.0;
3046 
3047 
3048 /**
3049  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
3050  */
3051 abstract contract ERC20Capped is ERC20 {
3052     uint256 private immutable _cap;
3053 
3054     /**
3055      * @dev Sets the value of the `cap`. This value is immutable, it can only be
3056      * set once during construction.
3057      */
3058     constructor(uint256 cap_) {
3059         require(cap_ > 0, "ERC20Capped: cap is 0");
3060         _cap = cap_;
3061     }
3062 
3063     /**
3064      * @dev Returns the cap on the token's total supply.
3065      */
3066     function cap() public view virtual returns (uint256) {
3067         return _cap;
3068     }
3069 
3070     /**
3071      * @dev See {ERC20-_mint}.
3072      */
3073     function _mint(address account, uint256 amount) internal virtual override {
3074         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
3075         super._mint(account, amount);
3076     }
3077 }
3078 
3079 // File: newToken.sol
3080 
3081 pragma solidity 0.8.7;
3082 
3083 
3084 
3085 
3086 
3087 
3088 
3089 /// SPDX-License-Identifier: UNLICENSED
3090 
3091 /*
3092    ____ ___  ____  __  __ ___ ____   _   _ _____ ___ _     ___ _______   __  _____ ___  _  _______ _   _ 
3093   / ___/ _ \/ ___||  \/  |_ _/ ___| | | | |_   _|_ _| |   |_ _|_   _\ \ / / |_   _/ _ \| |/ / ____| \ | |
3094  | |  | | | \___ \| |\/| || | |     | | | | | |  | || |    | |  | |  \ V /    | || | | | ' /|  _| |  \| |
3095  | |__| |_| |___) | |  | || | |___  | |_| | | |  | || |___ | |  | |   | |     | || |_| | . \| |___| |\  |
3096   \____\___/|____/|_|  |_|___\____|  \___/  |_| |___|_____|___| |_|   |_|     |_| \___/|_|\_\_____|_| \_|
3097                                                                                                          
3098 */
3099 
3100 contract CosmicUtilityToken is ERC20Capped, Ownable, ReentrancyGuard {
3101 
3102 
3103     mapping (uint256 => uint256) public tokenIdEarned;
3104 
3105     uint256 public totalTokensBurned = 0;
3106 
3107     uint256 constant public GENESIS_RATE = 0.01388888888 ether; 
3108     uint256 constant public DUCK_RATE = 0.00347222222 ether;
3109 
3110     uint256 contractStarted;
3111 
3112     bool public stakingStarted = false;
3113 
3114     CosmicLabs public cosmicLabs;
3115     CosmicToken public cosmicToken;
3116 
3117     constructor(address CLABS, address CUT) ERC20("Cosmic Utility Token", "CUT") ERC20Capped(87600000 * 10 ** 18)
3118     {
3119         cosmicLabs = CosmicLabs(CLABS);
3120         cosmicToken = CosmicToken(CUT);
3121     }
3122 
3123     function teamMint(uint256 totalAmount) public onlyOwner
3124     {
3125         _mint(msg.sender, (totalAmount * 10 ** 18));
3126     }
3127 
3128     function startStaking() public onlyOwner
3129     {
3130         contractStarted = block.timestamp;
3131         stakingStarted = true;
3132     }
3133 
3134     modifier hasStakingStarted
3135     {
3136          require(stakingStarted == true);
3137          _;
3138     }
3139     modifier hasBridgeClosed
3140     {
3141          require(stakingStarted == false);
3142          _;
3143     }
3144 
3145     //Bridge for old CUT
3146 
3147     function bridgeOldTokens() public nonReentrant hasBridgeClosed
3148     {
3149         uint256 howManyTokens = cosmicToken.balanceOf(msg.sender);
3150         
3151         cosmicToken.transferFrom(msg.sender, address(this), howManyTokens);
3152 
3153         //20% extra
3154         uint256 extraCommision = (howManyTokens * 20) / 100;
3155 
3156         _mint(msg.sender, (howManyTokens + extraCommision));
3157         
3158     }
3159 
3160     function burnOldCut() external onlyOwner {
3161         cosmicToken.burn(address(this), cosmicToken.balanceOf(address(this)));
3162     }
3163 
3164 
3165     //Reward functions
3166 
3167     function claimRewards() public nonReentrant hasStakingStarted
3168     {
3169         _mint(msg.sender, tokensAccumulated());
3170         
3171         uint256[] memory temp = cosmicLabs.walletOfOwner(msg.sender);
3172         for(uint256 i=0; i<temp.length;i++)
3173         {
3174             tokenIdEarned[temp[i]] = block.timestamp;
3175         }
3176     }
3177 
3178     function tokensAccumulated() public view returns(uint256)
3179     {
3180         uint256[] memory temp = cosmicLabs.walletOfOwner(msg.sender);
3181 
3182         uint256 totalTokensEarned;
3183 
3184         for(uint256 i=0; i<temp.length;i++)
3185         {
3186             if(temp[i] <= 1)
3187             {
3188                 totalTokensEarned += (howManyMinStaked(temp[i]) * GENESIS_RATE);
3189             }
3190             else
3191             {
3192                 totalTokensEarned += (howManyMinStaked(temp[i]) * DUCK_RATE);
3193             }
3194         }
3195 
3196         return totalTokensEarned;
3197 
3198     }
3199 
3200     function howManyMinStaked(uint256 tokenId) public view returns(uint256)
3201     {
3202         uint256 timeCalc;
3203 
3204         if(tokenIdEarned[tokenId] == 0)
3205         {
3206             timeCalc = block.timestamp - contractStarted;
3207         }
3208         else
3209         {
3210             timeCalc = block.timestamp - tokenIdEarned[tokenId];
3211         }
3212         
3213         uint256 returnMins = timeCalc / 60;
3214        
3215         return returnMins;
3216     }
3217 
3218     function burn(address _from, uint256 _amount) external 
3219 	{
3220 	    require(msg.sender == _from, "You do not own these tokens");
3221 		_burn(_from, _amount);
3222 		totalTokensBurned += _amount;
3223 	}
3224 
3225     
3226 }