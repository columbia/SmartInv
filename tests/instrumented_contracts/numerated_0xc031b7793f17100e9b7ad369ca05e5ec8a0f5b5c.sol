1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 pragma solidity >=0.6.0 <0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor () internal {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 
96 // File: @openzeppelin/contracts/utils/Strings.sol
97 
98 pragma solidity >=0.6.0 <0.8.0;
99 
100 /**
101  * @dev String operations.
102  */
103 library Strings {
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` representation.
106      */
107     function toString(uint256 value) internal pure returns (string memory) {
108         // Inspired by OraclizeAPI's implementation - MIT licence
109         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
110 
111         if (value == 0) {
112             return "0";
113         }
114         uint256 temp = value;
115         uint256 digits;
116         while (temp != 0) {
117             digits++;
118             temp /= 10;
119         }
120         bytes memory buffer = new bytes(digits);
121         uint256 index = digits - 1;
122         temp = value;
123         while (temp != 0) {
124             buffer[index--] = bytes1(uint8(48 + temp % 10));
125             temp /= 10;
126         }
127         return string(buffer);
128     }
129 }
130 
131 
132 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
133 
134 pragma solidity >=0.6.0 <0.8.0;
135 
136 /**
137  * @dev Library for managing an enumerable variant of Solidity's
138  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
139  * type.
140  *
141  * Maps have the following properties:
142  *
143  * - Entries are added, removed, and checked for existence in constant time
144  * (O(1)).
145  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
146  *
147  * ```
148  * contract Example {
149  *     // Add the library methods
150  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
151  *
152  *     // Declare a set state variable
153  *     EnumerableMap.UintToAddressMap private myMap;
154  * }
155  * ```
156  *
157  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
158  * supported.
159  */
160 library EnumerableMap {
161     // To implement this library for multiple types with as little code
162     // repetition as possible, we write it in terms of a generic Map type with
163     // bytes32 keys and values.
164     // The Map implementation uses private functions, and user-facing
165     // implementations (such as Uint256ToAddressMap) are just wrappers around
166     // the underlying Map.
167     // This means that we can only create new EnumerableMaps for types that fit
168     // in bytes32.
169 
170     struct MapEntry {
171         bytes32 _key;
172         bytes32 _value;
173     }
174 
175     struct Map {
176         // Storage of map keys and values
177         MapEntry[] _entries;
178 
179         // Position of the entry defined by a key in the `entries` array, plus 1
180         // because index 0 means a key is not in the map.
181         mapping (bytes32 => uint256) _indexes;
182     }
183 
184     /**
185      * @dev Adds a key-value pair to a map, or updates the value for an existing
186      * key. O(1).
187      *
188      * Returns true if the key was added to the map, that is if it was not
189      * already present.
190      */
191     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
192         // We read and store the key's index to prevent multiple reads from the same storage slot
193         uint256 keyIndex = map._indexes[key];
194 
195         if (keyIndex == 0) { // Equivalent to !contains(map, key)
196             map._entries.push(MapEntry({ _key: key, _value: value }));
197             // The entry is stored at length-1, but we add 1 to all indexes
198             // and use 0 as a sentinel value
199             map._indexes[key] = map._entries.length;
200             return true;
201         } else {
202             map._entries[keyIndex - 1]._value = value;
203             return false;
204         }
205     }
206 
207     /**
208      * @dev Removes a key-value pair from a map. O(1).
209      *
210      * Returns true if the key was removed from the map, that is if it was present.
211      */
212     function _remove(Map storage map, bytes32 key) private returns (bool) {
213         // We read and store the key's index to prevent multiple reads from the same storage slot
214         uint256 keyIndex = map._indexes[key];
215 
216         if (keyIndex != 0) { // Equivalent to contains(map, key)
217             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
218             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
219             // This modifies the order of the array, as noted in {at}.
220 
221             uint256 toDeleteIndex = keyIndex - 1;
222             uint256 lastIndex = map._entries.length - 1;
223 
224             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
225             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
226 
227             MapEntry storage lastEntry = map._entries[lastIndex];
228 
229             // Move the last entry to the index where the entry to delete is
230             map._entries[toDeleteIndex] = lastEntry;
231             // Update the index for the moved entry
232             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
233 
234             // Delete the slot where the moved entry was stored
235             map._entries.pop();
236 
237             // Delete the index for the deleted slot
238             delete map._indexes[key];
239 
240             return true;
241         } else {
242             return false;
243         }
244     }
245 
246     /**
247      * @dev Returns true if the key is in the map. O(1).
248      */
249     function _contains(Map storage map, bytes32 key) private view returns (bool) {
250         return map._indexes[key] != 0;
251     }
252 
253     /**
254      * @dev Returns the number of key-value pairs in the map. O(1).
255      */
256     function _length(Map storage map) private view returns (uint256) {
257         return map._entries.length;
258     }
259 
260    /**
261     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
262     *
263     * Note that there are no guarantees on the ordering of entries inside the
264     * array, and it may change when more entries are added or removed.
265     *
266     * Requirements:
267     *
268     * - `index` must be strictly less than {length}.
269     */
270     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
271         require(map._entries.length > index, "EnumerableMap: index out of bounds");
272 
273         MapEntry storage entry = map._entries[index];
274         return (entry._key, entry._value);
275     }
276 
277     /**
278      * @dev Tries to returns the value associated with `key`.  O(1).
279      * Does not revert if `key` is not in the map.
280      */
281     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
282         uint256 keyIndex = map._indexes[key];
283         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
284         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
285     }
286 
287     /**
288      * @dev Returns the value associated with `key`.  O(1).
289      *
290      * Requirements:
291      *
292      * - `key` must be in the map.
293      */
294     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
295         uint256 keyIndex = map._indexes[key];
296         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
297         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
298     }
299 
300     /**
301      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
302      *
303      * CAUTION: This function is deprecated because it requires allocating memory for the error
304      * message unnecessarily. For custom revert reasons use {_tryGet}.
305      */
306     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
307         uint256 keyIndex = map._indexes[key];
308         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
309         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
310     }
311 
312     // UintToAddressMap
313 
314     struct UintToAddressMap {
315         Map _inner;
316     }
317 
318     /**
319      * @dev Adds a key-value pair to a map, or updates the value for an existing
320      * key. O(1).
321      *
322      * Returns true if the key was added to the map, that is if it was not
323      * already present.
324      */
325     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
326         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
327     }
328 
329     /**
330      * @dev Removes a value from a set. O(1).
331      *
332      * Returns true if the key was removed from the map, that is if it was present.
333      */
334     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
335         return _remove(map._inner, bytes32(key));
336     }
337 
338     /**
339      * @dev Returns true if the key is in the map. O(1).
340      */
341     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
342         return _contains(map._inner, bytes32(key));
343     }
344 
345     /**
346      * @dev Returns the number of elements in the map. O(1).
347      */
348     function length(UintToAddressMap storage map) internal view returns (uint256) {
349         return _length(map._inner);
350     }
351 
352    /**
353     * @dev Returns the element stored at position `index` in the set. O(1).
354     * Note that there are no guarantees on the ordering of values inside the
355     * array, and it may change when more values are added or removed.
356     *
357     * Requirements:
358     *
359     * - `index` must be strictly less than {length}.
360     */
361     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
362         (bytes32 key, bytes32 value) = _at(map._inner, index);
363         return (uint256(key), address(uint160(uint256(value))));
364     }
365 
366     /**
367      * @dev Tries to returns the value associated with `key`.  O(1).
368      * Does not revert if `key` is not in the map.
369      *
370      * _Available since v3.4._
371      */
372     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
373         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
374         return (success, address(uint160(uint256(value))));
375     }
376 
377     /**
378      * @dev Returns the value associated with `key`.  O(1).
379      *
380      * Requirements:
381      *
382      * - `key` must be in the map.
383      */
384     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
385         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
386     }
387 
388     /**
389      * @dev Same as {get}, with a custom error message when `key` is not in the map.
390      *
391      * CAUTION: This function is deprecated because it requires allocating memory for the error
392      * message unnecessarily. For custom revert reasons use {tryGet}.
393      */
394     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
395         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
396     }
397 }
398 
399 
400 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
401 
402 pragma solidity >=0.6.0 <0.8.0;
403 
404 /**
405  * @dev Library for managing
406  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
407  * types.
408  *
409  * Sets have the following properties:
410  *
411  * - Elements are added, removed, and checked for existence in constant time
412  * (O(1)).
413  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
414  *
415  * ```
416  * contract Example {
417  *     // Add the library methods
418  *     using EnumerableSet for EnumerableSet.AddressSet;
419  *
420  *     // Declare a set state variable
421  *     EnumerableSet.AddressSet private mySet;
422  * }
423  * ```
424  *
425  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
426  * and `uint256` (`UintSet`) are supported.
427  */
428 library EnumerableSet {
429     // To implement this library for multiple types with as little code
430     // repetition as possible, we write it in terms of a generic Set type with
431     // bytes32 values.
432     // The Set implementation uses private functions, and user-facing
433     // implementations (such as AddressSet) are just wrappers around the
434     // underlying Set.
435     // This means that we can only create new EnumerableSets for types that fit
436     // in bytes32.
437 
438     struct Set {
439         // Storage of set values
440         bytes32[] _values;
441 
442         // Position of the value in the `values` array, plus 1 because index 0
443         // means a value is not in the set.
444         mapping (bytes32 => uint256) _indexes;
445     }
446 
447     /**
448      * @dev Add a value to a set. O(1).
449      *
450      * Returns true if the value was added to the set, that is if it was not
451      * already present.
452      */
453     function _add(Set storage set, bytes32 value) private returns (bool) {
454         if (!_contains(set, value)) {
455             set._values.push(value);
456             // The value is stored at length-1, but we add 1 to all indexes
457             // and use 0 as a sentinel value
458             set._indexes[value] = set._values.length;
459             return true;
460         } else {
461             return false;
462         }
463     }
464 
465     /**
466      * @dev Removes a value from a set. O(1).
467      *
468      * Returns true if the value was removed from the set, that is if it was
469      * present.
470      */
471     function _remove(Set storage set, bytes32 value) private returns (bool) {
472         // We read and store the value's index to prevent multiple reads from the same storage slot
473         uint256 valueIndex = set._indexes[value];
474 
475         if (valueIndex != 0) { // Equivalent to contains(set, value)
476             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
477             // the array, and then remove the last element (sometimes called as 'swap and pop').
478             // This modifies the order of the array, as noted in {at}.
479 
480             uint256 toDeleteIndex = valueIndex - 1;
481             uint256 lastIndex = set._values.length - 1;
482 
483             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
484             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
485 
486             bytes32 lastvalue = set._values[lastIndex];
487 
488             // Move the last value to the index where the value to delete is
489             set._values[toDeleteIndex] = lastvalue;
490             // Update the index for the moved value
491             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
492 
493             // Delete the slot where the moved value was stored
494             set._values.pop();
495 
496             // Delete the index for the deleted slot
497             delete set._indexes[value];
498 
499             return true;
500         } else {
501             return false;
502         }
503     }
504 
505     /**
506      * @dev Returns true if the value is in the set. O(1).
507      */
508     function _contains(Set storage set, bytes32 value) private view returns (bool) {
509         return set._indexes[value] != 0;
510     }
511 
512     /**
513      * @dev Returns the number of values on the set. O(1).
514      */
515     function _length(Set storage set) private view returns (uint256) {
516         return set._values.length;
517     }
518 
519    /**
520     * @dev Returns the value stored at position `index` in the set. O(1).
521     *
522     * Note that there are no guarantees on the ordering of values inside the
523     * array, and it may change when more values are added or removed.
524     *
525     * Requirements:
526     *
527     * - `index` must be strictly less than {length}.
528     */
529     function _at(Set storage set, uint256 index) private view returns (bytes32) {
530         require(set._values.length > index, "EnumerableSet: index out of bounds");
531         return set._values[index];
532     }
533 
534     // Bytes32Set
535 
536     struct Bytes32Set {
537         Set _inner;
538     }
539 
540     /**
541      * @dev Add a value to a set. O(1).
542      *
543      * Returns true if the value was added to the set, that is if it was not
544      * already present.
545      */
546     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
547         return _add(set._inner, value);
548     }
549 
550     /**
551      * @dev Removes a value from a set. O(1).
552      *
553      * Returns true if the value was removed from the set, that is if it was
554      * present.
555      */
556     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
557         return _remove(set._inner, value);
558     }
559 
560     /**
561      * @dev Returns true if the value is in the set. O(1).
562      */
563     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
564         return _contains(set._inner, value);
565     }
566 
567     /**
568      * @dev Returns the number of values in the set. O(1).
569      */
570     function length(Bytes32Set storage set) internal view returns (uint256) {
571         return _length(set._inner);
572     }
573 
574    /**
575     * @dev Returns the value stored at position `index` in the set. O(1).
576     *
577     * Note that there are no guarantees on the ordering of values inside the
578     * array, and it may change when more values are added or removed.
579     *
580     * Requirements:
581     *
582     * - `index` must be strictly less than {length}.
583     */
584     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
585         return _at(set._inner, index);
586     }
587 
588     // AddressSet
589 
590     struct AddressSet {
591         Set _inner;
592     }
593 
594     /**
595      * @dev Add a value to a set. O(1).
596      *
597      * Returns true if the value was added to the set, that is if it was not
598      * already present.
599      */
600     function add(AddressSet storage set, address value) internal returns (bool) {
601         return _add(set._inner, bytes32(uint256(uint160(value))));
602     }
603 
604     /**
605      * @dev Removes a value from a set. O(1).
606      *
607      * Returns true if the value was removed from the set, that is if it was
608      * present.
609      */
610     function remove(AddressSet storage set, address value) internal returns (bool) {
611         return _remove(set._inner, bytes32(uint256(uint160(value))));
612     }
613 
614     /**
615      * @dev Returns true if the value is in the set. O(1).
616      */
617     function contains(AddressSet storage set, address value) internal view returns (bool) {
618         return _contains(set._inner, bytes32(uint256(uint160(value))));
619     }
620 
621     /**
622      * @dev Returns the number of values in the set. O(1).
623      */
624     function length(AddressSet storage set) internal view returns (uint256) {
625         return _length(set._inner);
626     }
627 
628    /**
629     * @dev Returns the value stored at position `index` in the set. O(1).
630     *
631     * Note that there are no guarantees on the ordering of values inside the
632     * array, and it may change when more values are added or removed.
633     *
634     * Requirements:
635     *
636     * - `index` must be strictly less than {length}.
637     */
638     function at(AddressSet storage set, uint256 index) internal view returns (address) {
639         return address(uint160(uint256(_at(set._inner, index))));
640     }
641 
642 
643     // UintSet
644 
645     struct UintSet {
646         Set _inner;
647     }
648 
649     /**
650      * @dev Add a value to a set. O(1).
651      *
652      * Returns true if the value was added to the set, that is if it was not
653      * already present.
654      */
655     function add(UintSet storage set, uint256 value) internal returns (bool) {
656         return _add(set._inner, bytes32(value));
657     }
658 
659     /**
660      * @dev Removes a value from a set. O(1).
661      *
662      * Returns true if the value was removed from the set, that is if it was
663      * present.
664      */
665     function remove(UintSet storage set, uint256 value) internal returns (bool) {
666         return _remove(set._inner, bytes32(value));
667     }
668 
669     /**
670      * @dev Returns true if the value is in the set. O(1).
671      */
672     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
673         return _contains(set._inner, bytes32(value));
674     }
675 
676     /**
677      * @dev Returns the number of values on the set. O(1).
678      */
679     function length(UintSet storage set) internal view returns (uint256) {
680         return _length(set._inner);
681     }
682 
683    /**
684     * @dev Returns the value stored at position `index` in the set. O(1).
685     *
686     * Note that there are no guarantees on the ordering of values inside the
687     * array, and it may change when more values are added or removed.
688     *
689     * Requirements:
690     *
691     * - `index` must be strictly less than {length}.
692     */
693     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
694         return uint256(_at(set._inner, index));
695     }
696 }
697 
698 
699 // File: @openzeppelin/contracts/utils/Address.sol
700 
701 pragma solidity >=0.6.2 <0.8.0;
702 
703 /**
704  * @dev Collection of functions related to the address type
705  */
706 library Address {
707     /**
708      * @dev Returns true if `account` is a contract.
709      *
710      * [IMPORTANT]
711      * ====
712      * It is unsafe to assume that an address for which this function returns
713      * false is an externally-owned account (EOA) and not a contract.
714      *
715      * Among others, `isContract` will return false for the following
716      * types of addresses:
717      *
718      *  - an externally-owned account
719      *  - a contract in construction
720      *  - an address where a contract will be created
721      *  - an address where a contract lived, but was destroyed
722      * ====
723      */
724     function isContract(address account) internal view returns (bool) {
725         // This method relies on extcodesize, which returns 0 for contracts in
726         // construction, since the code is only stored at the end of the
727         // constructor execution.
728 
729         uint256 size;
730         // solhint-disable-next-line no-inline-assembly
731         assembly { size := extcodesize(account) }
732         return size > 0;
733     }
734 
735     /**
736      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
737      * `recipient`, forwarding all available gas and reverting on errors.
738      *
739      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
740      * of certain opcodes, possibly making contracts go over the 2300 gas limit
741      * imposed by `transfer`, making them unable to receive funds via
742      * `transfer`. {sendValue} removes this limitation.
743      *
744      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
745      *
746      * IMPORTANT: because control is transferred to `recipient`, care must be
747      * taken to not create reentrancy vulnerabilities. Consider using
748      * {ReentrancyGuard} or the
749      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
750      */
751     function sendValue(address payable recipient, uint256 amount) internal {
752         require(address(this).balance >= amount, "Address: insufficient balance");
753 
754         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
755         (bool success, ) = recipient.call{ value: amount }("");
756         require(success, "Address: unable to send value, recipient may have reverted");
757     }
758 
759     /**
760      * @dev Performs a Solidity function call using a low level `call`. A
761      * plain`call` is an unsafe replacement for a function call: use this
762      * function instead.
763      *
764      * If `target` reverts with a revert reason, it is bubbled up by this
765      * function (like regular Solidity function calls).
766      *
767      * Returns the raw returned data. To convert to the expected return value,
768      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
769      *
770      * Requirements:
771      *
772      * - `target` must be a contract.
773      * - calling `target` with `data` must not revert.
774      *
775      * _Available since v3.1._
776      */
777     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
778       return functionCall(target, data, "Address: low-level call failed");
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
783      * `errorMessage` as a fallback revert reason when `target` reverts.
784      *
785      * _Available since v3.1._
786      */
787     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
788         return functionCallWithValue(target, data, 0, errorMessage);
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
793      * but also transferring `value` wei to `target`.
794      *
795      * Requirements:
796      *
797      * - the calling contract must have an ETH balance of at least `value`.
798      * - the called Solidity function must be `payable`.
799      *
800      * _Available since v3.1._
801      */
802     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
803         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
808      * with `errorMessage` as a fallback revert reason when `target` reverts.
809      *
810      * _Available since v3.1._
811      */
812     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
813         require(address(this).balance >= value, "Address: insufficient balance for call");
814         require(isContract(target), "Address: call to non-contract");
815 
816         // solhint-disable-next-line avoid-low-level-calls
817         (bool success, bytes memory returndata) = target.call{ value: value }(data);
818         return _verifyCallResult(success, returndata, errorMessage);
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
823      * but performing a static call.
824      *
825      * _Available since v3.3._
826      */
827     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
828         return functionStaticCall(target, data, "Address: low-level static call failed");
829     }
830 
831     /**
832      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
833      * but performing a static call.
834      *
835      * _Available since v3.3._
836      */
837     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
838         require(isContract(target), "Address: static call to non-contract");
839 
840         // solhint-disable-next-line avoid-low-level-calls
841         (bool success, bytes memory returndata) = target.staticcall(data);
842         return _verifyCallResult(success, returndata, errorMessage);
843     }
844 
845     /**
846      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
847      * but performing a delegate call.
848      *
849      * _Available since v3.4._
850      */
851     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
852         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
853     }
854 
855     /**
856      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
857      * but performing a delegate call.
858      *
859      * _Available since v3.4._
860      */
861     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
862         require(isContract(target), "Address: delegate call to non-contract");
863 
864         // solhint-disable-next-line avoid-low-level-calls
865         (bool success, bytes memory returndata) = target.delegatecall(data);
866         return _verifyCallResult(success, returndata, errorMessage);
867     }
868 
869     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
870         if (success) {
871             return returndata;
872         } else {
873             // Look for revert reason and bubble it up if present
874             if (returndata.length > 0) {
875                 // The easiest way to bubble the revert reason is using memory via assembly
876 
877                 // solhint-disable-next-line no-inline-assembly
878                 assembly {
879                     let returndata_size := mload(returndata)
880                     revert(add(32, returndata), returndata_size)
881                 }
882             } else {
883                 revert(errorMessage);
884             }
885         }
886     }
887 }
888 
889 
890 // File: @openzeppelin/contracts/math/SafeMath.sol
891 
892 pragma solidity >=0.6.0 <0.8.0;
893 
894 /**
895  * @dev Wrappers over Solidity's arithmetic operations with added overflow
896  * checks.
897  *
898  * Arithmetic operations in Solidity wrap on overflow. This can easily result
899  * in bugs, because programmers usually assume that an overflow raises an
900  * error, which is the standard behavior in high level programming languages.
901  * `SafeMath` restores this intuition by reverting the transaction when an
902  * operation overflows.
903  *
904  * Using this library instead of the unchecked operations eliminates an entire
905  * class of bugs, so it's recommended to use it always.
906  */
907 library SafeMath {
908     /**
909      * @dev Returns the addition of two unsigned integers, with an overflow flag.
910      *
911      * _Available since v3.4._
912      */
913     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
914         uint256 c = a + b;
915         if (c < a) return (false, 0);
916         return (true, c);
917     }
918 
919     /**
920      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
921      *
922      * _Available since v3.4._
923      */
924     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
925         if (b > a) return (false, 0);
926         return (true, a - b);
927     }
928 
929     /**
930      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
931      *
932      * _Available since v3.4._
933      */
934     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
935         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
936         // benefit is lost if 'b' is also tested.
937         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
938         if (a == 0) return (true, 0);
939         uint256 c = a * b;
940         if (c / a != b) return (false, 0);
941         return (true, c);
942     }
943 
944     /**
945      * @dev Returns the division of two unsigned integers, with a division by zero flag.
946      *
947      * _Available since v3.4._
948      */
949     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
950         if (b == 0) return (false, 0);
951         return (true, a / b);
952     }
953 
954     /**
955      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
956      *
957      * _Available since v3.4._
958      */
959     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
960         if (b == 0) return (false, 0);
961         return (true, a % b);
962     }
963 
964     /**
965      * @dev Returns the addition of two unsigned integers, reverting on
966      * overflow.
967      *
968      * Counterpart to Solidity's `+` operator.
969      *
970      * Requirements:
971      *
972      * - Addition cannot overflow.
973      */
974     function add(uint256 a, uint256 b) internal pure returns (uint256) {
975         uint256 c = a + b;
976         require(c >= a, "SafeMath: addition overflow");
977         return c;
978     }
979 
980     /**
981      * @dev Returns the subtraction of two unsigned integers, reverting on
982      * overflow (when the result is negative).
983      *
984      * Counterpart to Solidity's `-` operator.
985      *
986      * Requirements:
987      *
988      * - Subtraction cannot overflow.
989      */
990     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
991         require(b <= a, "SafeMath: subtraction overflow");
992         return a - b;
993     }
994 
995     /**
996      * @dev Returns the multiplication of two unsigned integers, reverting on
997      * overflow.
998      *
999      * Counterpart to Solidity's `*` operator.
1000      *
1001      * Requirements:
1002      *
1003      * - Multiplication cannot overflow.
1004      */
1005     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1006         if (a == 0) return 0;
1007         uint256 c = a * b;
1008         require(c / a == b, "SafeMath: multiplication overflow");
1009         return c;
1010     }
1011 
1012     /**
1013      * @dev Returns the integer division of two unsigned integers, reverting on
1014      * division by zero. The result is rounded towards zero.
1015      *
1016      * Counterpart to Solidity's `/` operator. Note: this function uses a
1017      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1018      * uses an invalid opcode to revert (consuming all remaining gas).
1019      *
1020      * Requirements:
1021      *
1022      * - The divisor cannot be zero.
1023      */
1024     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1025         require(b > 0, "SafeMath: division by zero");
1026         return a / b;
1027     }
1028 
1029     /**
1030      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1031      * reverting when dividing by zero.
1032      *
1033      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1034      * opcode (which leaves remaining gas untouched) while Solidity uses an
1035      * invalid opcode to revert (consuming all remaining gas).
1036      *
1037      * Requirements:
1038      *
1039      * - The divisor cannot be zero.
1040      */
1041     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1042         require(b > 0, "SafeMath: modulo by zero");
1043         return a % b;
1044     }
1045 
1046     /**
1047      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1048      * overflow (when the result is negative).
1049      *
1050      * CAUTION: This function is deprecated because it requires allocating memory for the error
1051      * message unnecessarily. For custom revert reasons use {trySub}.
1052      *
1053      * Counterpart to Solidity's `-` operator.
1054      *
1055      * Requirements:
1056      *
1057      * - Subtraction cannot overflow.
1058      */
1059     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1060         require(b <= a, errorMessage);
1061         return a - b;
1062     }
1063 
1064     /**
1065      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1066      * division by zero. The result is rounded towards zero.
1067      *
1068      * CAUTION: This function is deprecated because it requires allocating memory for the error
1069      * message unnecessarily. For custom revert reasons use {tryDiv}.
1070      *
1071      * Counterpart to Solidity's `/` operator. Note: this function uses a
1072      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1073      * uses an invalid opcode to revert (consuming all remaining gas).
1074      *
1075      * Requirements:
1076      *
1077      * - The divisor cannot be zero.
1078      */
1079     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1080         require(b > 0, errorMessage);
1081         return a / b;
1082     }
1083 
1084     /**
1085      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1086      * reverting with custom message when dividing by zero.
1087      *
1088      * CAUTION: This function is deprecated because it requires allocating memory for the error
1089      * message unnecessarily. For custom revert reasons use {tryMod}.
1090      *
1091      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1092      * opcode (which leaves remaining gas untouched) while Solidity uses an
1093      * invalid opcode to revert (consuming all remaining gas).
1094      *
1095      * Requirements:
1096      *
1097      * - The divisor cannot be zero.
1098      */
1099     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1100         require(b > 0, errorMessage);
1101         return a % b;
1102     }
1103 }
1104 
1105 
1106 // File: @openzeppelin/contracts/introspection/IERC165.sol
1107 
1108 pragma solidity >=0.6.0 <0.8.0;
1109 
1110 /**
1111  * @dev Interface of the ERC165 standard, as defined in the
1112  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1113  *
1114  * Implementers can declare support of contract interfaces, which can then be
1115  * queried by others ({ERC165Checker}).
1116  *
1117  * For an implementation, see {ERC165}.
1118  */
1119 interface IERC165 {
1120     /**
1121      * @dev Returns true if this contract implements the interface defined by
1122      * `interfaceId`. See the corresponding
1123      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1124      * to learn more about how these ids are created.
1125      *
1126      * This function call must use less than 30 000 gas.
1127      */
1128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1129 }
1130 
1131 
1132 // File: @openzeppelin/contracts/introspection/ERC165.sol
1133 
1134 pragma solidity >=0.6.0 <0.8.0;
1135 
1136 /**
1137  * @dev Implementation of the {IERC165} interface.
1138  *
1139  * Contracts may inherit from this and call {_registerInterface} to declare
1140  * their support of an interface.
1141  */
1142 abstract contract ERC165 is IERC165 {
1143     /*
1144      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1145      */
1146     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1147 
1148     /**
1149      * @dev Mapping of interface ids to whether or not it's supported.
1150      */
1151     mapping(bytes4 => bool) private _supportedInterfaces;
1152 
1153     constructor () internal {
1154         // Derived contracts need only register support for their own interfaces,
1155         // we register support for ERC165 itself here
1156         _registerInterface(_INTERFACE_ID_ERC165);
1157     }
1158 
1159     /**
1160      * @dev See {IERC165-supportsInterface}.
1161      *
1162      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1163      */
1164     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1165         return _supportedInterfaces[interfaceId];
1166     }
1167 
1168     /**
1169      * @dev Registers the contract as an implementer of the interface defined by
1170      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1171      * registering its interface id is not required.
1172      *
1173      * See {IERC165-supportsInterface}.
1174      *
1175      * Requirements:
1176      *
1177      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1178      */
1179     function _registerInterface(bytes4 interfaceId) internal virtual {
1180         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1181         _supportedInterfaces[interfaceId] = true;
1182     }
1183 }
1184 
1185 
1186 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1187 
1188 pragma solidity >=0.6.0 <0.8.0;
1189 
1190 /**
1191  * @title ERC721 token receiver interface
1192  * @dev Interface for any contract that wants to support safeTransfers
1193  * from ERC721 asset contracts.
1194  */
1195 interface IERC721Receiver {
1196     /**
1197      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1198      * by `operator` from `from`, this function is called.
1199      *
1200      * It must return its Solidity selector to confirm the token transfer.
1201      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1202      *
1203      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1204      */
1205     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1206 }
1207 
1208 
1209 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1210 
1211 pragma solidity >=0.6.2 <0.8.0;
1212 
1213 /**
1214  * @dev Required interface of an ERC721 compliant contract.
1215  */
1216 interface IERC721 is IERC165 {
1217     /**
1218      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1219      */
1220     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1221 
1222     /**
1223      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1224      */
1225     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1226 
1227     /**
1228      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1229      */
1230     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1231 
1232     /**
1233      * @dev Returns the number of tokens in ``owner``'s account.
1234      */
1235     function balanceOf(address owner) external view returns (uint256 balance);
1236 
1237     /**
1238      * @dev Returns the owner of the `tokenId` token.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      */
1244     function ownerOf(uint256 tokenId) external view returns (address owner);
1245 
1246     /**
1247      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1248      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1249      *
1250      * Requirements:
1251      *
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must exist and be owned by `from`.
1255      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1261 
1262     /**
1263      * @dev Transfers `tokenId` token from `from` to `to`.
1264      *
1265      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1266      *
1267      * Requirements:
1268      *
1269      * - `from` cannot be the zero address.
1270      * - `to` cannot be the zero address.
1271      * - `tokenId` token must be owned by `from`.
1272      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function transferFrom(address from, address to, uint256 tokenId) external;
1277 
1278     /**
1279      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1280      * The approval is cleared when the token is transferred.
1281      *
1282      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1283      *
1284      * Requirements:
1285      *
1286      * - The caller must own the token or be an approved operator.
1287      * - `tokenId` must exist.
1288      *
1289      * Emits an {Approval} event.
1290      */
1291     function approve(address to, uint256 tokenId) external;
1292 
1293     /**
1294      * @dev Returns the account approved for `tokenId` token.
1295      *
1296      * Requirements:
1297      *
1298      * - `tokenId` must exist.
1299      */
1300     function getApproved(uint256 tokenId) external view returns (address operator);
1301 
1302     /**
1303      * @dev Approve or remove `operator` as an operator for the caller.
1304      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1305      *
1306      * Requirements:
1307      *
1308      * - The `operator` cannot be the caller.
1309      *
1310      * Emits an {ApprovalForAll} event.
1311      */
1312     function setApprovalForAll(address operator, bool _approved) external;
1313 
1314     /**
1315      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1316      *
1317      * See {setApprovalForAll}
1318      */
1319     function isApprovedForAll(address owner, address operator) external view returns (bool);
1320 
1321     /**
1322       * @dev Safely transfers `tokenId` token from `from` to `to`.
1323       *
1324       * Requirements:
1325       *
1326       * - `from` cannot be the zero address.
1327       * - `to` cannot be the zero address.
1328       * - `tokenId` token must exist and be owned by `from`.
1329       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1330       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1331       *
1332       * Emits a {Transfer} event.
1333       */
1334     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1335 }
1336 
1337 
1338 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
1339 
1340 pragma solidity >=0.6.2 <0.8.0;
1341 
1342 /**
1343  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1344  * @dev See https://eips.ethereum.org/EIPS/eip-721
1345  */
1346 interface IERC721Enumerable is IERC721 {
1347 
1348     /**
1349      * @dev Returns the total amount of tokens stored by the contract.
1350      */
1351     function totalSupply() external view returns (uint256);
1352 
1353     /**
1354      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1355      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1356      */
1357     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1358 
1359     /**
1360      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1361      * Use along with {totalSupply} to enumerate all tokens.
1362      */
1363     function tokenByIndex(uint256 index) external view returns (uint256);
1364 }
1365 
1366 
1367 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1368 
1369 pragma solidity >=0.6.2 <0.8.0;
1370 
1371 /**
1372  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1373  * @dev See https://eips.ethereum.org/EIPS/eip-721
1374  */
1375 interface IERC721Metadata is IERC721 {
1376 
1377     /**
1378      * @dev Returns the token collection name.
1379      */
1380     function name() external view returns (string memory);
1381 
1382     /**
1383      * @dev Returns the token collection symbol.
1384      */
1385     function symbol() external view returns (string memory);
1386 
1387     /**
1388      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1389      */
1390     function tokenURI(uint256 tokenId) external view returns (string memory);
1391 }
1392 
1393 
1394 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1395 
1396 pragma solidity >=0.6.0 <0.8.0;
1397 
1398 /**
1399  * @title ERC721 Non-Fungible Token Standard basic implementation
1400  * @dev see https://eips.ethereum.org/EIPS/eip-721
1401  */
1402 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1403     using SafeMath for uint256;
1404     using Address for address;
1405     using EnumerableSet for EnumerableSet.UintSet;
1406     using EnumerableMap for EnumerableMap.UintToAddressMap;
1407     using Strings for uint256;
1408 
1409     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1410     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1411     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1412 
1413     // Mapping from holder address to their (enumerable) set of owned tokens
1414     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1415 
1416     // Enumerable mapping from token ids to their owners
1417     EnumerableMap.UintToAddressMap private _tokenOwners;
1418 
1419     // Mapping from token ID to approved address
1420     mapping (uint256 => address) private _tokenApprovals;
1421 
1422     // Mapping from owner to operator approvals
1423     mapping (address => mapping (address => bool)) private _operatorApprovals;
1424 
1425     // Token name
1426     string private _name;
1427 
1428     // Token symbol
1429     string private _symbol;
1430 
1431     // Optional mapping for token URIs
1432     mapping (uint256 => string) private _tokenURIs;
1433 
1434     // Base URI
1435     string private _baseURI;
1436 
1437     /*
1438      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1439      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1440      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1441      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1442      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1443      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1444      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1445      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1446      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1447      *
1448      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1449      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1450      */
1451     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1452 
1453     /*
1454      *     bytes4(keccak256('name()')) == 0x06fdde03
1455      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1456      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1457      *
1458      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1459      */
1460     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1461 
1462     /*
1463      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1464      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1465      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1466      *
1467      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1468      */
1469     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1470 
1471     /**
1472      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1473      */
1474     constructor (string memory name_, string memory symbol_) public {
1475         _name = name_;
1476         _symbol = symbol_;
1477 
1478         // register the supported interfaces to conform to ERC721 via ERC165
1479         _registerInterface(_INTERFACE_ID_ERC721);
1480         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1481         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-balanceOf}.
1486      */
1487     function balanceOf(address owner) public view virtual override returns (uint256) {
1488         require(owner != address(0), "ERC721: balance query for the zero address");
1489         return _holderTokens[owner].length();
1490     }
1491 
1492     /**
1493      * @dev See {IERC721-ownerOf}.
1494      */
1495     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1496         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Metadata-name}.
1501      */
1502     function name() public view virtual override returns (string memory) {
1503         return _name;
1504     }
1505 
1506     /**
1507      * @dev See {IERC721Metadata-symbol}.
1508      */
1509     function symbol() public view virtual override returns (string memory) {
1510         return _symbol;
1511     }
1512 
1513     /**
1514      * @dev See {IERC721Metadata-tokenURI}.
1515      */
1516     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1517         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1518 
1519         string memory _tokenURI = _tokenURIs[tokenId];
1520         string memory base = baseURI();
1521 
1522         // If there is no base URI, return the token URI.
1523         if (bytes(base).length == 0) {
1524             return _tokenURI;
1525         }
1526         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1527         if (bytes(_tokenURI).length > 0) {
1528             return string(abi.encodePacked(base, _tokenURI));
1529         }
1530         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1531         return string(abi.encodePacked(base, tokenId.toString()));
1532     }
1533 
1534     /**
1535     * @dev Returns the base URI set via {_setBaseURI}. This will be
1536     * automatically added as a prefix in {tokenURI} to each token's URI, or
1537     * to the token ID if no specific URI is set for that token ID.
1538     */
1539     function baseURI() public view virtual returns (string memory) {
1540         return _baseURI;
1541     }
1542 
1543     /**
1544      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1545      */
1546     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1547         return _holderTokens[owner].at(index);
1548     }
1549 
1550     /**
1551      * @dev See {IERC721Enumerable-totalSupply}.
1552      */
1553     function totalSupply() public view virtual override returns (uint256) {
1554         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1555         return _tokenOwners.length();
1556     }
1557 
1558     /**
1559      * @dev See {IERC721Enumerable-tokenByIndex}.
1560      */
1561     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1562         (uint256 tokenId, ) = _tokenOwners.at(index);
1563         return tokenId;
1564     }
1565 
1566     /**
1567      * @dev See {IERC721-approve}.
1568      */
1569     function approve(address to, uint256 tokenId) public virtual override {
1570         address owner = ERC721.ownerOf(tokenId);
1571         require(to != owner, "ERC721: approval to current owner");
1572 
1573         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1574             "ERC721: approve caller is not owner nor approved for all"
1575         );
1576 
1577         _approve(to, tokenId);
1578     }
1579 
1580     /**
1581      * @dev See {IERC721-getApproved}.
1582      */
1583     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1584         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1585 
1586         return _tokenApprovals[tokenId];
1587     }
1588 
1589     /**
1590      * @dev See {IERC721-setApprovalForAll}.
1591      */
1592     function setApprovalForAll(address operator, bool approved) public virtual override {
1593         require(operator != _msgSender(), "ERC721: approve to caller");
1594 
1595         _operatorApprovals[_msgSender()][operator] = approved;
1596         emit ApprovalForAll(_msgSender(), operator, approved);
1597     }
1598 
1599     /**
1600      * @dev See {IERC721-isApprovedForAll}.
1601      */
1602     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1603         return _operatorApprovals[owner][operator];
1604     }
1605 
1606     /**
1607      * @dev See {IERC721-transferFrom}.
1608      */
1609     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1610         //solhint-disable-next-line max-line-length
1611         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1612 
1613         _transfer(from, to, tokenId);
1614     }
1615 
1616     /**
1617      * @dev See {IERC721-safeTransferFrom}.
1618      */
1619     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1620         safeTransferFrom(from, to, tokenId, "");
1621     }
1622 
1623     /**
1624      * @dev See {IERC721-safeTransferFrom}.
1625      */
1626     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1627         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1628         _safeTransfer(from, to, tokenId, _data);
1629     }
1630 
1631     /**
1632      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1633      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1634      *
1635      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1636      *
1637      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1638      * implement alternative mechanisms to perform token transfer, such as signature-based.
1639      *
1640      * Requirements:
1641      *
1642      * - `from` cannot be the zero address.
1643      * - `to` cannot be the zero address.
1644      * - `tokenId` token must exist and be owned by `from`.
1645      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1646      *
1647      * Emits a {Transfer} event.
1648      */
1649     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1650         _transfer(from, to, tokenId);
1651         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1652     }
1653 
1654     /**
1655      * @dev Returns whether `tokenId` exists.
1656      *
1657      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1658      *
1659      * Tokens start existing when they are minted (`_mint`),
1660      * and stop existing when they are burned (`_burn`).
1661      */
1662     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1663         return _tokenOwners.contains(tokenId);
1664     }
1665 
1666     /**
1667      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1668      *
1669      * Requirements:
1670      *
1671      * - `tokenId` must exist.
1672      */
1673     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1674         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1675         address owner = ERC721.ownerOf(tokenId);
1676         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1677     }
1678 
1679     /**
1680      * @dev Safely mints `tokenId` and transfers it to `to`.
1681      *
1682      * Requirements:
1683      d*
1684      * - `tokenId` must not exist.
1685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1686      *
1687      * Emits a {Transfer} event.
1688      */
1689     function _safeMint(address to, uint256 tokenId) internal virtual {
1690         _safeMint(to, tokenId, "");
1691     }
1692 
1693     /**
1694      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1695      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1696      */
1697     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1698         _mint(to, tokenId);
1699         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1700     }
1701 
1702     /**
1703      * @dev Mints `tokenId` and transfers it to `to`.
1704      *
1705      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1706      *
1707      * Requirements:
1708      *
1709      * - `tokenId` must not exist.
1710      * - `to` cannot be the zero address.
1711      *
1712      * Emits a {Transfer} event.
1713      */
1714     function _mint(address to, uint256 tokenId) internal virtual {
1715         require(to != address(0), "ERC721: mint to the zero address");
1716         require(!_exists(tokenId), "ERC721: token already minted");
1717 
1718         _beforeTokenTransfer(address(0), to, tokenId);
1719 
1720         _holderTokens[to].add(tokenId);
1721 
1722         _tokenOwners.set(tokenId, to);
1723 
1724         emit Transfer(address(0), to, tokenId);
1725     }
1726 
1727     /**
1728      * @dev Destroys `tokenId`.
1729      * The approval is cleared when the token is burned.
1730      *
1731      * Requirements:
1732      *
1733      * - `tokenId` must exist.
1734      *
1735      * Emits a {Transfer} event.
1736      */
1737     function _burn(uint256 tokenId) internal virtual {
1738         address owner = ERC721.ownerOf(tokenId); // internal owner
1739 
1740         _beforeTokenTransfer(owner, address(0), tokenId);
1741 
1742         // Clear approvals
1743         _approve(address(0), tokenId);
1744 
1745         // Clear metadata (if any)
1746         if (bytes(_tokenURIs[tokenId]).length != 0) {
1747             delete _tokenURIs[tokenId];
1748         }
1749 
1750         _holderTokens[owner].remove(tokenId);
1751 
1752         _tokenOwners.remove(tokenId);
1753 
1754         emit Transfer(owner, address(0), tokenId);
1755     }
1756 
1757     /**
1758      * @dev Transfers `tokenId` from `from` to `to`.
1759      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1760      *
1761      * Requirements:
1762      *
1763      * - `to` cannot be the zero address.
1764      * - `tokenId` token must be owned by `from`.
1765      *
1766      * Emits a {Transfer} event.
1767      */
1768     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1769         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1770         require(to != address(0), "ERC721: transfer to the zero address");
1771 
1772         _beforeTokenTransfer(from, to, tokenId);
1773 
1774         // Clear approvals from the previous owner
1775         _approve(address(0), tokenId);
1776 
1777         _holderTokens[from].remove(tokenId);
1778         _holderTokens[to].add(tokenId);
1779 
1780         _tokenOwners.set(tokenId, to);
1781 
1782         emit Transfer(from, to, tokenId);
1783     }
1784 
1785     /**
1786      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1787      *
1788      * Requirements:
1789      *
1790      * - `tokenId` must exist.
1791      */
1792     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1793         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1794         _tokenURIs[tokenId] = _tokenURI;
1795     }
1796 
1797     /**
1798      * @dev Internal function to set the base URI for all token IDs. It is
1799      * automatically added as a prefix to the value returned in {tokenURI},
1800      * or to the token ID if {tokenURI} is empty.
1801      */
1802     function _setBaseURI(string memory baseURI_) internal virtual {
1803         _baseURI = baseURI_;
1804     }
1805 
1806     /**
1807      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1808      * The call is not executed if the target address is not a contract.
1809      *
1810      * @param from address representing the previous owner of the given token ID
1811      * @param to target address that will receive the tokens
1812      * @param tokenId uint256 ID of the token to be transferred
1813      * @param _data bytes optional data to send along with the call
1814      * @return bool whether the call correctly returned the expected magic value
1815      */
1816     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1817         private returns (bool)
1818     {
1819         if (!to.isContract()) {
1820             return true;
1821         }
1822         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1823             IERC721Receiver(to).onERC721Received.selector,
1824             _msgSender(),
1825             from,
1826             tokenId,
1827             _data
1828         ), "ERC721: transfer to non ERC721Receiver implementer");
1829         bytes4 retval = abi.decode(returndata, (bytes4));
1830         return (retval == _ERC721_RECEIVED);
1831     }
1832 
1833     /**
1834      * @dev Approve `to` to operate on `tokenId`
1835      *
1836      * Emits an {Approval} event.
1837      */
1838     function _approve(address to, uint256 tokenId) internal virtual {
1839         _tokenApprovals[tokenId] = to;
1840         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1841     }
1842 
1843     /**
1844      * @dev Hook that is called before any token transfer. This includes minting
1845      * and burning.
1846      *
1847      * Calling conditions:
1848      *
1849      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1850      * transferred to `to`.
1851      * - When `from` is zero, `tokenId` will be minted for `to`.
1852      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1853      * - `from` cannot be the zero address.
1854      * - `to` cannot be the zero address.
1855      *
1856      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1857      */
1858     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1859 }
1860 
1861 
1862 /**
1863  * @title WeaponizedCountries contract
1864  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1865  */
1866 contract WeaponizedCountries is ERC721, Ownable {
1867     using SafeMath for uint256;
1868     uint256 public constant MAX_Supply = 5188;
1869     uint256 private scopeIndex = 0;
1870     uint256 public price = 25000000000000000; // 0.025 Eth
1871 
1872     bool public hasSaleStarted = false;
1873 
1874     mapping(uint256 => uint256) swappedIDs;
1875     
1876     mapping(address => uint256) userCredit;
1877 
1878     // The IPFS hash for all WeaponizedCountries concatenated stored here
1879     string public METADATA_PROVENANCE_HASH = "4d315de108610def833cc7cb4acfe91af29600ba6370039dd535d21ec4193a24";
1880 
1881     constructor(string memory baseURI) ERC721("WeaponizedCountries","WC")  {
1882         setBaseURI(baseURI);
1883     }
1884 
1885     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1886         uint256 tokenCount = balanceOf(_owner);
1887         if (tokenCount == 0) {
1888             // Return an empty array
1889             return new uint256[](0);
1890         } else {
1891             uint256[] memory result = new uint256[](tokenCount);
1892             uint256 index;
1893             for (index = 0; index < tokenCount; index++) {
1894                 result[index] = tokenOfOwnerByIndex(_owner, index);
1895             }
1896             return result;
1897         }
1898     }
1899 
1900     function genID() private returns(uint256) {
1901         uint256 scope = MAX_Supply-scopeIndex;
1902         uint256 swap;
1903         uint256 result;
1904 
1905         uint256 i = randomNumber() % scope;
1906 
1907         //Setup the value to swap in for the selected ID
1908         if (swappedIDs[scope-1] == 0){
1909             swap = scope-1;
1910         } else {
1911             swap = swappedIDs[scope-1];
1912         }
1913 
1914         //Select a random ID, swap it out with an unselected one then shorten the selection range by 1
1915         if (swappedIDs[i] == 0){
1916             result = i;
1917             swappedIDs[i] = swap;
1918         } else {
1919             result = swappedIDs[i];
1920             swappedIDs[i] = swap;
1921         }
1922         return result+1;
1923     }
1924 
1925     function randomNumber() private view returns(uint256){
1926         return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
1927     }
1928 
1929     function mint(uint256 numWeaponizedCountries) public payable {
1930         require(hasSaleStarted == true, "Sale hasn't started");
1931         require(totalSupply().add(numWeaponizedCountries) <= MAX_Supply, "Exceeds MAX_Supply");
1932         
1933         if (totalSupply() >= 1000){
1934             require(numWeaponizedCountries > 0 && numWeaponizedCountries <= 24, "You can mint minimum 1, maximum 24 WeaponizedCountries");
1935             
1936             if (numWeaponizedCountries == 24) {
1937                 require(msg.value >= price.mul(numWeaponizedCountries).mul(20).div(24), "Ether value sent is below the price");
1938             } else if (numWeaponizedCountries >= 7) {
1939                 require(msg.value >= price.mul(numWeaponizedCountries).mul(6).div(7), "Ether value sent is below the price");
1940             } else {
1941                 require(msg.value >= price.mul(numWeaponizedCountries), "Ether value sent is below the price");
1942             }
1943             
1944         }else {
1945             require(numWeaponizedCountries == 1, "You can only mint 1 FREE WeaponizedCountries per transaction");
1946         }
1947         
1948         
1949         for (uint i = 0; i < numWeaponizedCountries; i++) {
1950             _safeMint(msg.sender, genID());
1951             scopeIndex++;
1952         }
1953     }
1954     
1955     function mintCredit() public {
1956         require(hasSaleStarted == true, "Sale hasn't started");
1957         require(totalSupply().add(1) <= MAX_Supply, "Exceeds MAX_Supply");
1958         require(userCredit[msg.sender] >= 1, "No Credits");
1959 
1960         _safeMint(msg.sender, genID());
1961         scopeIndex++;
1962         userCredit[msg.sender] -= 1;
1963     }
1964 
1965     function balanceOfCredit(address owner) public view virtual returns (uint256) {
1966         require(owner != address(0), "ERC721: balance query for the zero address");
1967         return userCredit[owner];
1968     }
1969 
1970     // Owner Functions
1971 
1972     function setBaseURI(string memory baseURI) public onlyOwner {
1973         _setBaseURI(baseURI);
1974     }
1975 
1976     function startSale() public onlyOwner {
1977         hasSaleStarted = true;
1978     }
1979     
1980     function pauseSale() public onlyOwner {
1981         hasSaleStarted = false;
1982     }
1983 
1984     function withdrawAll() public onlyOwner {
1985         msg.sender.transfer(address(this).balance);
1986     }
1987     
1988     function addCredit(address owner, uint256 credits) public onlyOwner {
1989         userCredit[owner] += credits;
1990     }
1991 }