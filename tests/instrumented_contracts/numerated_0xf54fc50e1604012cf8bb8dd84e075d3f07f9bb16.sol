1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/Context.sol
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
27 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/access/Ownable.sol
28 
29 // SPDX-License-Identifier: MIT
30 
31 pragma solidity ^0.7.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/Strings.sol
98 
99 
100 
101 pragma solidity ^0.7.0;
102 
103 /**
104  * @dev String operations.
105  */
106 library Strings {
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` representation.
109      */
110     function toString(uint256 value) internal pure returns (string memory) {
111         // Inspired by OraclizeAPI's implementation - MIT licence
112         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
113 
114         if (value == 0) {
115             return "0";
116         }
117         uint256 temp = value;
118         uint256 digits;
119         while (temp != 0) {
120             digits++;
121             temp /= 10;
122         }
123         bytes memory buffer = new bytes(digits);
124         uint256 index = digits - 1;
125         temp = value;
126         while (temp != 0) {
127             buffer[index--] = bytes1(uint8(48 + temp % 10));
128             temp /= 10;
129         }
130         return string(buffer);
131     }
132 }
133 
134 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/EnumerableMap.sol
135 
136 
137 
138 pragma solidity ^0.7.0;
139 
140 /**
141  * @dev Library for managing an enumerable variant of Solidity's
142  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
143  * type.
144  *
145  * Maps have the following properties:
146  *
147  * - Entries are added, removed, and checked for existence in constant time
148  * (O(1)).
149  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
150  *
151  * ```
152  * contract Example {
153  *     // Add the library methods
154  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
155  *
156  *     // Declare a set state variable
157  *     EnumerableMap.UintToAddressMap private myMap;
158  * }
159  * ```
160  *
161  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
162  * supported.
163  */
164 library EnumerableMap {
165     // To implement this library for multiple types with as little code
166     // repetition as possible, we write it in terms of a generic Map type with
167     // bytes32 keys and values.
168     // The Map implementation uses private functions, and user-facing
169     // implementations (such as Uint256ToAddressMap) are just wrappers around
170     // the underlying Map.
171     // This means that we can only create new EnumerableMaps for types that fit
172     // in bytes32.
173 
174     struct MapEntry {
175         bytes32 _key;
176         bytes32 _value;
177     }
178 
179     struct Map {
180         // Storage of map keys and values
181         MapEntry[] _entries;
182 
183         // Position of the entry defined by a key in the `entries` array, plus 1
184         // because index 0 means a key is not in the map.
185         mapping (bytes32 => uint256) _indexes;
186     }
187 
188     /**
189      * @dev Adds a key-value pair to a map, or updates the value for an existing
190      * key. O(1).
191      *
192      * Returns true if the key was added to the map, that is if it was not
193      * already present.
194      */
195     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
196         // We read and store the key's index to prevent multiple reads from the same storage slot
197         uint256 keyIndex = map._indexes[key];
198 
199         if (keyIndex == 0) { // Equivalent to !contains(map, key)
200             map._entries.push(MapEntry({ _key: key, _value: value }));
201             // The entry is stored at length-1, but we add 1 to all indexes
202             // and use 0 as a sentinel value
203             map._indexes[key] = map._entries.length;
204             return true;
205         } else {
206             map._entries[keyIndex - 1]._value = value;
207             return false;
208         }
209     }
210 
211     /**
212      * @dev Removes a key-value pair from a map. O(1).
213      *
214      * Returns true if the key was removed from the map, that is if it was present.
215      */
216     function _remove(Map storage map, bytes32 key) private returns (bool) {
217         // We read and store the key's index to prevent multiple reads from the same storage slot
218         uint256 keyIndex = map._indexes[key];
219 
220         if (keyIndex != 0) { // Equivalent to contains(map, key)
221             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
222             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
223             // This modifies the order of the array, as noted in {at}.
224 
225             uint256 toDeleteIndex = keyIndex - 1;
226             uint256 lastIndex = map._entries.length - 1;
227 
228             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
229             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
230 
231             MapEntry storage lastEntry = map._entries[lastIndex];
232 
233             // Move the last entry to the index where the entry to delete is
234             map._entries[toDeleteIndex] = lastEntry;
235             // Update the index for the moved entry
236             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
237 
238             // Delete the slot where the moved entry was stored
239             map._entries.pop();
240 
241             // Delete the index for the deleted slot
242             delete map._indexes[key];
243 
244             return true;
245         } else {
246             return false;
247         }
248     }
249 
250     /**
251      * @dev Returns true if the key is in the map. O(1).
252      */
253     function _contains(Map storage map, bytes32 key) private view returns (bool) {
254         return map._indexes[key] != 0;
255     }
256 
257     /**
258      * @dev Returns the number of key-value pairs in the map. O(1).
259      */
260     function _length(Map storage map) private view returns (uint256) {
261         return map._entries.length;
262     }
263 
264    /**
265     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
266     *
267     * Note that there are no guarantees on the ordering of entries inside the
268     * array, and it may change when more entries are added or removed.
269     *
270     * Requirements:
271     *
272     * - `index` must be strictly less than {length}.
273     */
274     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
275         require(map._entries.length > index, "EnumerableMap: index out of bounds");
276 
277         MapEntry storage entry = map._entries[index];
278         return (entry._key, entry._value);
279     }
280 
281     /**
282      * @dev Tries to returns the value associated with `key`.  O(1).
283      * Does not revert if `key` is not in the map.
284      */
285     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
286         uint256 keyIndex = map._indexes[key];
287         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
288         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
289     }
290 
291     /**
292      * @dev Returns the value associated with `key`.  O(1).
293      *
294      * Requirements:
295      *
296      * - `key` must be in the map.
297      */
298     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
299         uint256 keyIndex = map._indexes[key];
300         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
301         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
302     }
303 
304     /**
305      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
306      *
307      * CAUTION: This function is deprecated because it requires allocating memory for the error
308      * message unnecessarily. For custom revert reasons use {_tryGet}.
309      */
310     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
311         uint256 keyIndex = map._indexes[key];
312         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
313         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
314     }
315 
316     // UintToAddressMap
317 
318     struct UintToAddressMap {
319         Map _inner;
320     }
321 
322     /**
323      * @dev Adds a key-value pair to a map, or updates the value for an existing
324      * key. O(1).
325      *
326      * Returns true if the key was added to the map, that is if it was not
327      * already present.
328      */
329     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
330         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
331     }
332 
333     /**
334      * @dev Removes a value from a set. O(1).
335      *
336      * Returns true if the key was removed from the map, that is if it was present.
337      */
338     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
339         return _remove(map._inner, bytes32(key));
340     }
341 
342     /**
343      * @dev Returns true if the key is in the map. O(1).
344      */
345     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
346         return _contains(map._inner, bytes32(key));
347     }
348 
349     /**
350      * @dev Returns the number of elements in the map. O(1).
351      */
352     function length(UintToAddressMap storage map) internal view returns (uint256) {
353         return _length(map._inner);
354     }
355 
356    /**
357     * @dev Returns the element stored at position `index` in the set. O(1).
358     * Note that there are no guarantees on the ordering of values inside the
359     * array, and it may change when more values are added or removed.
360     *
361     * Requirements:
362     *
363     * - `index` must be strictly less than {length}.
364     */
365     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
366         (bytes32 key, bytes32 value) = _at(map._inner, index);
367         return (uint256(key), address(uint160(uint256(value))));
368     }
369 
370     /**
371      * @dev Tries to returns the value associated with `key`.  O(1).
372      * Does not revert if `key` is not in the map.
373      *
374      * _Available since v3.4._
375      */
376     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
377         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
378         return (success, address(uint160(uint256(value))));
379     }
380 
381     /**
382      * @dev Returns the value associated with `key`.  O(1).
383      *
384      * Requirements:
385      *
386      * - `key` must be in the map.
387      */
388     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
389         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
390     }
391 
392     /**
393      * @dev Same as {get}, with a custom error message when `key` is not in the map.
394      *
395      * CAUTION: This function is deprecated because it requires allocating memory for the error
396      * message unnecessarily. For custom revert reasons use {tryGet}.
397      */
398     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
399         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
400     }
401 }
402 
403 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/EnumerableSet.sol
404 
405 
406 
407 pragma solidity ^0.7.0;
408 
409 /**
410  * @dev Library for managing
411  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
412  * types.
413  *
414  * Sets have the following properties:
415  *
416  * - Elements are added, removed, and checked for existence in constant time
417  * (O(1)).
418  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
419  *
420  * ```
421  * contract Example {
422  *     // Add the library methods
423  *     using EnumerableSet for EnumerableSet.AddressSet;
424  *
425  *     // Declare a set state variable
426  *     EnumerableSet.AddressSet private mySet;
427  * }
428  * ```
429  *
430  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
431  * and `uint256` (`UintSet`) are supported.
432  */
433 library EnumerableSet {
434     // To implement this library for multiple types with as little code
435     // repetition as possible, we write it in terms of a generic Set type with
436     // bytes32 values.
437     // The Set implementation uses private functions, and user-facing
438     // implementations (such as AddressSet) are just wrappers around the
439     // underlying Set.
440     // This means that we can only create new EnumerableSets for types that fit
441     // in bytes32.
442 
443     struct Set {
444         // Storage of set values
445         bytes32[] _values;
446 
447         // Position of the value in the `values` array, plus 1 because index 0
448         // means a value is not in the set.
449         mapping (bytes32 => uint256) _indexes;
450     }
451 
452     /**
453      * @dev Add a value to a set. O(1).
454      *
455      * Returns true if the value was added to the set, that is if it was not
456      * already present.
457      */
458     function _add(Set storage set, bytes32 value) private returns (bool) {
459         if (!_contains(set, value)) {
460             set._values.push(value);
461             // The value is stored at length-1, but we add 1 to all indexes
462             // and use 0 as a sentinel value
463             set._indexes[value] = set._values.length;
464             return true;
465         } else {
466             return false;
467         }
468     }
469 
470     /**
471      * @dev Removes a value from a set. O(1).
472      *
473      * Returns true if the value was removed from the set, that is if it was
474      * present.
475      */
476     function _remove(Set storage set, bytes32 value) private returns (bool) {
477         // We read and store the value's index to prevent multiple reads from the same storage slot
478         uint256 valueIndex = set._indexes[value];
479 
480         if (valueIndex != 0) { // Equivalent to contains(set, value)
481             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
482             // the array, and then remove the last element (sometimes called as 'swap and pop').
483             // This modifies the order of the array, as noted in {at}.
484 
485             uint256 toDeleteIndex = valueIndex - 1;
486             uint256 lastIndex = set._values.length - 1;
487 
488             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
489             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
490 
491             bytes32 lastvalue = set._values[lastIndex];
492 
493             // Move the last value to the index where the value to delete is
494             set._values[toDeleteIndex] = lastvalue;
495             // Update the index for the moved value
496             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
497 
498             // Delete the slot where the moved value was stored
499             set._values.pop();
500 
501             // Delete the index for the deleted slot
502             delete set._indexes[value];
503 
504             return true;
505         } else {
506             return false;
507         }
508     }
509 
510     /**
511      * @dev Returns true if the value is in the set. O(1).
512      */
513     function _contains(Set storage set, bytes32 value) private view returns (bool) {
514         return set._indexes[value] != 0;
515     }
516 
517     /**
518      * @dev Returns the number of values on the set. O(1).
519      */
520     function _length(Set storage set) private view returns (uint256) {
521         return set._values.length;
522     }
523 
524    /**
525     * @dev Returns the value stored at position `index` in the set. O(1).
526     *
527     * Note that there are no guarantees on the ordering of values inside the
528     * array, and it may change when more values are added or removed.
529     *
530     * Requirements:
531     *
532     * - `index` must be strictly less than {length}.
533     */
534     function _at(Set storage set, uint256 index) private view returns (bytes32) {
535         require(set._values.length > index, "EnumerableSet: index out of bounds");
536         return set._values[index];
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
579    /**
580     * @dev Returns the value stored at position `index` in the set. O(1).
581     *
582     * Note that there are no guarantees on the ordering of values inside the
583     * array, and it may change when more values are added or removed.
584     *
585     * Requirements:
586     *
587     * - `index` must be strictly less than {length}.
588     */
589     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
590         return _at(set._inner, index);
591     }
592 
593     // AddressSet
594 
595     struct AddressSet {
596         Set _inner;
597     }
598 
599     /**
600      * @dev Add a value to a set. O(1).
601      *
602      * Returns true if the value was added to the set, that is if it was not
603      * already present.
604      */
605     function add(AddressSet storage set, address value) internal returns (bool) {
606         return _add(set._inner, bytes32(uint256(uint160(value))));
607     }
608 
609     /**
610      * @dev Removes a value from a set. O(1).
611      *
612      * Returns true if the value was removed from the set, that is if it was
613      * present.
614      */
615     function remove(AddressSet storage set, address value) internal returns (bool) {
616         return _remove(set._inner, bytes32(uint256(uint160(value))));
617     }
618 
619     /**
620      * @dev Returns true if the value is in the set. O(1).
621      */
622     function contains(AddressSet storage set, address value) internal view returns (bool) {
623         return _contains(set._inner, bytes32(uint256(uint160(value))));
624     }
625 
626     /**
627      * @dev Returns the number of values in the set. O(1).
628      */
629     function length(AddressSet storage set) internal view returns (uint256) {
630         return _length(set._inner);
631     }
632 
633    /**
634     * @dev Returns the value stored at position `index` in the set. O(1).
635     *
636     * Note that there are no guarantees on the ordering of values inside the
637     * array, and it may change when more values are added or removed.
638     *
639     * Requirements:
640     *
641     * - `index` must be strictly less than {length}.
642     */
643     function at(AddressSet storage set, uint256 index) internal view returns (address) {
644         return address(uint160(uint256(_at(set._inner, index))));
645     }
646 
647 
648     // UintSet
649 
650     struct UintSet {
651         Set _inner;
652     }
653 
654     /**
655      * @dev Add a value to a set. O(1).
656      *
657      * Returns true if the value was added to the set, that is if it was not
658      * already present.
659      */
660     function add(UintSet storage set, uint256 value) internal returns (bool) {
661         return _add(set._inner, bytes32(value));
662     }
663 
664     /**
665      * @dev Removes a value from a set. O(1).
666      *
667      * Returns true if the value was removed from the set, that is if it was
668      * present.
669      */
670     function remove(UintSet storage set, uint256 value) internal returns (bool) {
671         return _remove(set._inner, bytes32(value));
672     }
673 
674     /**
675      * @dev Returns true if the value is in the set. O(1).
676      */
677     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
678         return _contains(set._inner, bytes32(value));
679     }
680 
681     /**
682      * @dev Returns the number of values on the set. O(1).
683      */
684     function length(UintSet storage set) internal view returns (uint256) {
685         return _length(set._inner);
686     }
687 
688    /**
689     * @dev Returns the value stored at position `index` in the set. O(1).
690     *
691     * Note that there are no guarantees on the ordering of values inside the
692     * array, and it may change when more values are added or removed.
693     *
694     * Requirements:
695     *
696     * - `index` must be strictly less than {length}.
697     */
698     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
699         return uint256(_at(set._inner, index));
700     }
701 }
702 
703 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/Address.sol
704 
705 
706 
707 pragma solidity ^0.7.0;
708 
709 /**
710  * @dev Collection of functions related to the address type
711  */
712 library Address {
713     /**
714      * @dev Returns true if `account` is a contract.
715      *
716      * [IMPORTANT]
717      * ====
718      * It is unsafe to assume that an address for which this function returns
719      * false is an externally-owned account (EOA) and not a contract.
720      *
721      * Among others, `isContract` will return false for the following
722      * types of addresses:
723      *
724      *  - an externally-owned account
725      *  - a contract in construction
726      *  - an address where a contract will be created
727      *  - an address where a contract lived, but was destroyed
728      * ====
729      */
730     function isContract(address account) internal view returns (bool) {
731         // This method relies on extcodesize, which returns 0 for contracts in
732         // construction, since the code is only stored at the end of the
733         // constructor execution.
734 
735         uint256 size;
736         // solhint-disable-next-line no-inline-assembly
737         assembly { size := extcodesize(account) }
738         return size > 0;
739     }
740 
741     /**
742      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
743      * `recipient`, forwarding all available gas and reverting on errors.
744      *
745      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
746      * of certain opcodes, possibly making contracts go over the 2300 gas limit
747      * imposed by `transfer`, making them unable to receive funds via
748      * `transfer`. {sendValue} removes this limitation.
749      *
750      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
751      *
752      * IMPORTANT: because control is transferred to `recipient`, care must be
753      * taken to not create reentrancy vulnerabilities. Consider using
754      * {ReentrancyGuard} or the
755      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
756      */
757     function sendValue(address payable recipient, uint256 amount) internal {
758         require(address(this).balance >= amount, "Address: insufficient balance");
759 
760         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
761         (bool success, ) = recipient.call{ value: amount }("");
762         require(success, "Address: unable to send value, recipient may have reverted");
763     }
764 
765     /**
766      * @dev Performs a Solidity function call using a low level `call`. A
767      * plain`call` is an unsafe replacement for a function call: use this
768      * function instead.
769      *
770      * If `target` reverts with a revert reason, it is bubbled up by this
771      * function (like regular Solidity function calls).
772      *
773      * Returns the raw returned data. To convert to the expected return value,
774      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
775      *
776      * Requirements:
777      *
778      * - `target` must be a contract.
779      * - calling `target` with `data` must not revert.
780      *
781      * _Available since v3.1._
782      */
783     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
784       return functionCall(target, data, "Address: low-level call failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
789      * `errorMessage` as a fallback revert reason when `target` reverts.
790      *
791      * _Available since v3.1._
792      */
793     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
794         return functionCallWithValue(target, data, 0, errorMessage);
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
799      * but also transferring `value` wei to `target`.
800      *
801      * Requirements:
802      *
803      * - the calling contract must have an ETH balance of at least `value`.
804      * - the called Solidity function must be `payable`.
805      *
806      * _Available since v3.1._
807      */
808     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
809         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
814      * with `errorMessage` as a fallback revert reason when `target` reverts.
815      *
816      * _Available since v3.1._
817      */
818     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
819         require(address(this).balance >= value, "Address: insufficient balance for call");
820         require(isContract(target), "Address: call to non-contract");
821 
822         // solhint-disable-next-line avoid-low-level-calls
823         (bool success, bytes memory returndata) = target.call{ value: value }(data);
824         return _verifyCallResult(success, returndata, errorMessage);
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
829      * but performing a static call.
830      *
831      * _Available since v3.3._
832      */
833     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
834         return functionStaticCall(target, data, "Address: low-level static call failed");
835     }
836 
837     /**
838      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
839      * but performing a static call.
840      *
841      * _Available since v3.3._
842      */
843     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
844         require(isContract(target), "Address: static call to non-contract");
845 
846         // solhint-disable-next-line avoid-low-level-calls
847         (bool success, bytes memory returndata) = target.staticcall(data);
848         return _verifyCallResult(success, returndata, errorMessage);
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
853      * but performing a delegate call.
854      *
855      * _Available since v3.4._
856      */
857     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
858         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
863      * but performing a delegate call.
864      *
865      * _Available since v3.4._
866      */
867     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
868         require(isContract(target), "Address: delegate call to non-contract");
869 
870         // solhint-disable-next-line avoid-low-level-calls
871         (bool success, bytes memory returndata) = target.delegatecall(data);
872         return _verifyCallResult(success, returndata, errorMessage);
873     }
874 
875     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
876         if (success) {
877             return returndata;
878         } else {
879             // Look for revert reason and bubble it up if present
880             if (returndata.length > 0) {
881                 // The easiest way to bubble the revert reason is using memory via assembly
882 
883                 // solhint-disable-next-line no-inline-assembly
884                 assembly {
885                     let returndata_size := mload(returndata)
886                     revert(add(32, returndata), returndata_size)
887                 }
888             } else {
889                 revert(errorMessage);
890             }
891         }
892     }
893 }
894 
895 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/math/SafeMath.sol
896 
897 
898 
899 pragma solidity ^0.7.0;
900 
901 /**
902  * @dev Wrappers over Solidity's arithmetic operations with added overflow
903  * checks.
904  *
905  * Arithmetic operations in Solidity wrap on overflow. This can easily result
906  * in bugs, because programmers usually assume that an overflow raises an
907  * error, which is the standard behavior in high level programming languages.
908  * `SafeMath` restores this intuition by reverting the transaction when an
909  * operation overflows.
910  *
911  * Using this library instead of the unchecked operations eliminates an entire
912  * class of bugs, so it's recommended to use it always.
913  */
914 library SafeMath {
915     /**
916      * @dev Returns the addition of two unsigned integers, with an overflow flag.
917      *
918      * _Available since v3.4._
919      */
920     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
921         uint256 c = a + b;
922         if (c < a) return (false, 0);
923         return (true, c);
924     }
925 
926     /**
927      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
928      *
929      * _Available since v3.4._
930      */
931     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
932         if (b > a) return (false, 0);
933         return (true, a - b);
934     }
935 
936     /**
937      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
938      *
939      * _Available since v3.4._
940      */
941     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
942         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
943         // benefit is lost if 'b' is also tested.
944         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
945         if (a == 0) return (true, 0);
946         uint256 c = a * b;
947         if (c / a != b) return (false, 0);
948         return (true, c);
949     }
950 
951     /**
952      * @dev Returns the division of two unsigned integers, with a division by zero flag.
953      *
954      * _Available since v3.4._
955      */
956     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
957         if (b == 0) return (false, 0);
958         return (true, a / b);
959     }
960 
961     /**
962      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
963      *
964      * _Available since v3.4._
965      */
966     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
967         if (b == 0) return (false, 0);
968         return (true, a % b);
969     }
970 
971     /**
972      * @dev Returns the addition of two unsigned integers, reverting on
973      * overflow.
974      *
975      * Counterpart to Solidity's `+` operator.
976      *
977      * Requirements:
978      *
979      * - Addition cannot overflow.
980      */
981     function add(uint256 a, uint256 b) internal pure returns (uint256) {
982         uint256 c = a + b;
983         require(c >= a, "SafeMath: addition overflow");
984         return c;
985     }
986 
987     /**
988      * @dev Returns the subtraction of two unsigned integers, reverting on
989      * overflow (when the result is negative).
990      *
991      * Counterpart to Solidity's `-` operator.
992      *
993      * Requirements:
994      *
995      * - Subtraction cannot overflow.
996      */
997     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
998         require(b <= a, "SafeMath: subtraction overflow");
999         return a - b;
1000     }
1001 
1002     /**
1003      * @dev Returns the multiplication of two unsigned integers, reverting on
1004      * overflow.
1005      *
1006      * Counterpart to Solidity's `*` operator.
1007      *
1008      * Requirements:
1009      *
1010      * - Multiplication cannot overflow.
1011      */
1012     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1013         if (a == 0) return 0;
1014         uint256 c = a * b;
1015         require(c / a == b, "SafeMath: multiplication overflow");
1016         return c;
1017     }
1018 
1019     /**
1020      * @dev Returns the integer division of two unsigned integers, reverting on
1021      * division by zero. The result is rounded towards zero.
1022      *
1023      * Counterpart to Solidity's `/` operator. Note: this function uses a
1024      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1025      * uses an invalid opcode to revert (consuming all remaining gas).
1026      *
1027      * Requirements:
1028      *
1029      * - The divisor cannot be zero.
1030      */
1031     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1032         require(b > 0, "SafeMath: division by zero");
1033         return a / b;
1034     }
1035 
1036     /**
1037      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1038      * reverting when dividing by zero.
1039      *
1040      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1041      * opcode (which leaves remaining gas untouched) while Solidity uses an
1042      * invalid opcode to revert (consuming all remaining gas).
1043      *
1044      * Requirements:
1045      *
1046      * - The divisor cannot be zero.
1047      */
1048     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1049         require(b > 0, "SafeMath: modulo by zero");
1050         return a % b;
1051     }
1052 
1053     /**
1054      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1055      * overflow (when the result is negative).
1056      *
1057      * CAUTION: This function is deprecated because it requires allocating memory for the error
1058      * message unnecessarily. For custom revert reasons use {trySub}.
1059      *
1060      * Counterpart to Solidity's `-` operator.
1061      *
1062      * Requirements:
1063      *
1064      * - Subtraction cannot overflow.
1065      */
1066     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1067         require(b <= a, errorMessage);
1068         return a - b;
1069     }
1070 
1071     /**
1072      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1073      * division by zero. The result is rounded towards zero.
1074      *
1075      * CAUTION: This function is deprecated because it requires allocating memory for the error
1076      * message unnecessarily. For custom revert reasons use {tryDiv}.
1077      *
1078      * Counterpart to Solidity's `/` operator. Note: this function uses a
1079      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1080      * uses an invalid opcode to revert (consuming all remaining gas).
1081      *
1082      * Requirements:
1083      *
1084      * - The divisor cannot be zero.
1085      */
1086     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1087         require(b > 0, errorMessage);
1088         return a / b;
1089     }
1090 
1091     /**
1092      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1093      * reverting with custom message when dividing by zero.
1094      *
1095      * CAUTION: This function is deprecated because it requires allocating memory for the error
1096      * message unnecessarily. For custom revert reasons use {tryMod}.
1097      *
1098      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1099      * opcode (which leaves remaining gas untouched) while Solidity uses an
1100      * invalid opcode to revert (consuming all remaining gas).
1101      *
1102      * Requirements:
1103      *
1104      * - The divisor cannot be zero.
1105      */
1106     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1107         require(b > 0, errorMessage);
1108         return a % b;
1109     }
1110 }
1111 
1112 
1113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/introspection/IERC165.sol
1114 
1115 
1116 
1117 pragma solidity ^0.7.0;
1118 
1119 /**
1120  * @dev Interface of the ERC165 standard, as defined in the
1121  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1122  *
1123  * Implementers can declare support of contract interfaces, which can then be
1124  * queried by others ({ERC165Checker}).
1125  *
1126  * For an implementation, see {ERC165}.
1127  */
1128 interface IERC165 {
1129     /**
1130      * @dev Returns true if this contract implements the interface defined by
1131      * `interfaceId`. See the corresponding
1132      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1133      * to learn more about how these ids are created.
1134      *
1135      * This function call must use less than 30 000 gas.
1136      */
1137     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1138 }
1139 
1140 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/introspection/ERC165.sol
1141 
1142 
1143 
1144 pragma solidity ^0.7.0;
1145 
1146 
1147 /**
1148  * @dev Implementation of the {IERC165} interface.
1149  *
1150  * Contracts may inherit from this and call {_registerInterface} to declare
1151  * their support of an interface.
1152  */
1153 abstract contract ERC165 is IERC165 {
1154     /*
1155      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1156      */
1157     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1158 
1159     /**
1160      * @dev Mapping of interface ids to whether or not it's supported.
1161      */
1162     mapping(bytes4 => bool) private _supportedInterfaces;
1163 
1164     constructor () {
1165         // Derived contracts need only register support for their own interfaces,
1166         // we register support for ERC165 itself here
1167         _registerInterface(_INTERFACE_ID_ERC165);
1168     }
1169 
1170     /**
1171      * @dev See {IERC165-supportsInterface}.
1172      *
1173      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1174      */
1175     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1176         return _supportedInterfaces[interfaceId];
1177     }
1178 
1179     /**
1180      * @dev Registers the contract as an implementer of the interface defined by
1181      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1182      * registering its interface id is not required.
1183      *
1184      * See {IERC165-supportsInterface}.
1185      *
1186      * Requirements:
1187      *
1188      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1189      */
1190     function _registerInterface(bytes4 interfaceId) internal virtual {
1191         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1192         _supportedInterfaces[interfaceId] = true;
1193     }
1194 }
1195 
1196 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721Receiver.sol
1197 
1198 
1199 
1200 pragma solidity ^0.7.0;
1201 
1202 /**
1203  * @title ERC721 token receiver interface
1204  * @dev Interface for any contract that wants to support safeTransfers
1205  * from ERC721 asset contracts.
1206  */
1207 interface IERC721Receiver {
1208     /**
1209      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1210      * by `operator` from `from`, this function is called.
1211      *
1212      * It must return its Solidity selector to confirm the token transfer.
1213      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1214      *
1215      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1216      */
1217     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1218 }
1219 
1220 
1221 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721.sol
1222 
1223 
1224 
1225 pragma solidity ^0.7.0;
1226 
1227 
1228 /**
1229  * @dev Required interface of an ERC721 compliant contract.
1230  */
1231 interface IERC721 is IERC165 {
1232     /**
1233      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1234      */
1235     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1236 
1237     /**
1238      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1239      */
1240     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1241 
1242     /**
1243      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1244      */
1245     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1246 
1247     /**
1248      * @dev Returns the number of tokens in ``owner``'s account.
1249      */
1250     function balanceOf(address owner) external view returns (uint256 balance);
1251 
1252     /**
1253      * @dev Returns the owner of the `tokenId` token.
1254      *
1255      * Requirements:
1256      *
1257      * - `tokenId` must exist.
1258      */
1259     function ownerOf(uint256 tokenId) external view returns (address owner);
1260 
1261     /**
1262      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1263      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1264      *
1265      * Requirements:
1266      *
1267      * - `from` cannot be the zero address.
1268      * - `to` cannot be the zero address.
1269      * - `tokenId` token must exist and be owned by `from`.
1270      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1276 
1277     /**
1278      * @dev Transfers `tokenId` token from `from` to `to`.
1279      *
1280      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1281      *
1282      * Requirements:
1283      *
1284      * - `from` cannot be the zero address.
1285      * - `to` cannot be the zero address.
1286      * - `tokenId` token must be owned by `from`.
1287      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function transferFrom(address from, address to, uint256 tokenId) external;
1292 
1293     /**
1294      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1295      * The approval is cleared when the token is transferred.
1296      *
1297      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1298      *
1299      * Requirements:
1300      *
1301      * - The caller must own the token or be an approved operator.
1302      * - `tokenId` must exist.
1303      *
1304      * Emits an {Approval} event.
1305      */
1306     function approve(address to, uint256 tokenId) external;
1307 
1308     /**
1309      * @dev Returns the account approved for `tokenId` token.
1310      *
1311      * Requirements:
1312      *
1313      * - `tokenId` must exist.
1314      */
1315     function getApproved(uint256 tokenId) external view returns (address operator);
1316 
1317     /**
1318      * @dev Approve or remove `operator` as an operator for the caller.
1319      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1320      *
1321      * Requirements:
1322      *
1323      * - The `operator` cannot be the caller.
1324      *
1325      * Emits an {ApprovalForAll} event.
1326      */
1327     function setApprovalForAll(address operator, bool _approved) external;
1328 
1329     /**
1330      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1331      *
1332      * See {setApprovalForAll}
1333      */
1334     function isApprovedForAll(address owner, address operator) external view returns (bool);
1335 
1336     /**
1337       * @dev Safely transfers `tokenId` token from `from` to `to`.
1338       *
1339       * Requirements:
1340       *
1341       * - `from` cannot be the zero address.
1342       * - `to` cannot be the zero address.
1343       * - `tokenId` token must exist and be owned by `from`.
1344       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1345       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1346       *
1347       * Emits a {Transfer} event.
1348       */
1349     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1350 }
1351 
1352 
1353 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721Enumerable.sol
1354 
1355 
1356 
1357 pragma solidity ^0.7.0;
1358 
1359 
1360 /**
1361  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1362  * @dev See https://eips.ethereum.org/EIPS/eip-721
1363  */
1364 interface IERC721Enumerable is IERC721 {
1365 
1366     /**
1367      * @dev Returns the total amount of tokens stored by the contract.
1368      */
1369     function totalSupply() external view returns (uint256);
1370 
1371     /**
1372      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1373      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1374      */
1375     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1376 
1377     /**
1378      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1379      * Use along with {totalSupply} to enumerate all tokens.
1380      */
1381     function tokenByIndex(uint256 index) external view returns (uint256);
1382 }
1383 
1384 
1385 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721Metadata.sol
1386 
1387 
1388 
1389 pragma solidity ^0.7.0;
1390 
1391 
1392 /**
1393  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1394  * @dev See https://eips.ethereum.org/EIPS/eip-721
1395  */
1396 interface IERC721Metadata is IERC721 {
1397 
1398     /**
1399      * @dev Returns the token collection name.
1400      */
1401     function name() external view returns (string memory);
1402 
1403     /**
1404      * @dev Returns the token collection symbol.
1405      */
1406     function symbol() external view returns (string memory);
1407 
1408     /**
1409      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1410      */
1411     function tokenURI(uint256 tokenId) external view returns (string memory);
1412 }
1413 
1414 
1415 
1416 
1417 
1418 
1419 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/ERC721.sol
1420 
1421 
1422 
1423 pragma solidity ^0.7.0;
1424 
1425 
1426 /**
1427  * @title ERC721 Non-Fungible Token Standard basic implementation
1428  * @dev see https://eips.ethereum.org/EIPS/eip-721
1429  */
1430 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1431     using SafeMath for uint256;
1432     using Address for address;
1433     using EnumerableSet for EnumerableSet.UintSet;
1434     using EnumerableMap for EnumerableMap.UintToAddressMap;
1435     using Strings for uint256;
1436 
1437     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1438     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1439     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1440 
1441     // Mapping from holder address to their (enumerable) set of owned tokens
1442     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1443 
1444     // Enumerable mapping from token ids to their owners
1445     EnumerableMap.UintToAddressMap private _tokenOwners;
1446 
1447     // Mapping from token ID to approved address
1448     mapping (uint256 => address) private _tokenApprovals;
1449 
1450     // Mapping from owner to operator approvals
1451     mapping (address => mapping (address => bool)) private _operatorApprovals;
1452 
1453     // Token name
1454     string private _name;
1455 
1456     // Token symbol
1457     string private _symbol;
1458 
1459     // Optional mapping for token URIs
1460     mapping (uint256 => string) private _tokenURIs;
1461 
1462     // Base URI
1463     string private _baseURI;
1464 
1465     /*
1466      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1467      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1468      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1469      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1470      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1471      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1472      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1473      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1474      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1475      *
1476      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1477      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1478      */
1479     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1480 
1481     /*
1482      *     bytes4(keccak256('name()')) == 0x06fdde03
1483      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1484      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1485      *
1486      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1487      */
1488     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1489 
1490     /*
1491      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1492      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1493      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1494      *
1495      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1496      */
1497     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1498 
1499     /**
1500      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1501      */
1502     constructor (string memory name_, string memory symbol_) {
1503         _name = name_;
1504         _symbol = symbol_;
1505 
1506         // register the supported interfaces to conform to ERC721 via ERC165
1507         _registerInterface(_INTERFACE_ID_ERC721);
1508         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1509         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1510     }
1511 
1512     /**
1513      * @dev See {IERC721-balanceOf}.
1514      */
1515     function balanceOf(address owner) public view virtual override returns (uint256) {
1516         require(owner != address(0), "ERC721: balance query for the zero address");
1517         return _holderTokens[owner].length();
1518     }
1519 
1520     /**
1521      * @dev See {IERC721-ownerOf}.
1522      */
1523     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1524         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Metadata-name}.
1529      */
1530     function name() public view virtual override returns (string memory) {
1531         return _name;
1532     }
1533 
1534     /**
1535      * @dev See {IERC721Metadata-symbol}.
1536      */
1537     function symbol() public view virtual override returns (string memory) {
1538         return _symbol;
1539     }
1540 
1541     /**
1542      * @dev See {IERC721Metadata-tokenURI}.
1543      */
1544     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1545         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1546 
1547         string memory _tokenURI = _tokenURIs[tokenId];
1548         string memory base = baseURI();
1549 
1550         // If there is no base URI, return the token URI.
1551         if (bytes(base).length == 0) {
1552             return _tokenURI;
1553         }
1554         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1555         if (bytes(_tokenURI).length > 0) {
1556             return string(abi.encodePacked(base, _tokenURI));
1557         }
1558         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1559         return string(abi.encodePacked(base, tokenId.toString()));
1560     }
1561 
1562     /**
1563     * @dev Returns the base URI set via {_setBaseURI}. This will be
1564     * automatically added as a prefix in {tokenURI} to each token's URI, or
1565     * to the token ID if no specific URI is set for that token ID.
1566     */
1567     function baseURI() public view virtual returns (string memory) {
1568         return _baseURI;
1569     }
1570 
1571     /**
1572      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1573      */
1574     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1575         return _holderTokens[owner].at(index);
1576     }
1577 
1578     /**
1579      * @dev See {IERC721Enumerable-totalSupply}.
1580      */
1581     function totalSupply() public view virtual override returns (uint256) {
1582         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1583         return _tokenOwners.length();
1584     }
1585 
1586     /**
1587      * @dev See {IERC721Enumerable-tokenByIndex}.
1588      */
1589     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1590         (uint256 tokenId, ) = _tokenOwners.at(index);
1591         return tokenId;
1592     }
1593 
1594     /**
1595      * @dev See {IERC721-approve}.
1596      */
1597     function approve(address to, uint256 tokenId) public virtual override {
1598         address owner = ERC721.ownerOf(tokenId);
1599         require(to != owner, "ERC721: approval to current owner");
1600 
1601         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1602             "ERC721: approve caller is not owner nor approved for all"
1603         );
1604 
1605         _approve(to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev See {IERC721-getApproved}.
1610      */
1611     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1612         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1613 
1614         return _tokenApprovals[tokenId];
1615     }
1616 
1617     /**
1618      * @dev See {IERC721-setApprovalForAll}.
1619      */
1620     function setApprovalForAll(address operator, bool approved) public virtual override {
1621         require(operator != _msgSender(), "ERC721: approve to caller");
1622 
1623         _operatorApprovals[_msgSender()][operator] = approved;
1624         emit ApprovalForAll(_msgSender(), operator, approved);
1625     }
1626 
1627     /**
1628      * @dev See {IERC721-isApprovedForAll}.
1629      */
1630     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1631         return _operatorApprovals[owner][operator];
1632     }
1633 
1634     /**
1635      * @dev See {IERC721-transferFrom}.
1636      */
1637     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1638         //solhint-disable-next-line max-line-length
1639         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1640 
1641         _transfer(from, to, tokenId);
1642     }
1643 
1644     /**
1645      * @dev See {IERC721-safeTransferFrom}.
1646      */
1647     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1648         safeTransferFrom(from, to, tokenId, "");
1649     }
1650 
1651     /**
1652      * @dev See {IERC721-safeTransferFrom}.
1653      */
1654     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1655         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1656         _safeTransfer(from, to, tokenId, _data);
1657     }
1658 
1659     /**
1660      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1661      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1662      *
1663      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1664      *
1665      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1666      * implement alternative mechanisms to perform token transfer, such as signature-based.
1667      *
1668      * Requirements:
1669      *
1670      * - `from` cannot be the zero address.
1671      * - `to` cannot be the zero address.
1672      * - `tokenId` token must exist and be owned by `from`.
1673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1678         _transfer(from, to, tokenId);
1679         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1680     }
1681 
1682     /**
1683      * @dev Returns whether `tokenId` exists.
1684      *
1685      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1686      *
1687      * Tokens start existing when they are minted (`_mint`),
1688      * and stop existing when they are burned (`_burn`).
1689      */
1690     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1691         return _tokenOwners.contains(tokenId);
1692     }
1693 
1694     /**
1695      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1696      *
1697      * Requirements:
1698      *
1699      * - `tokenId` must exist.
1700      */
1701     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1702         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1703         address owner = ERC721.ownerOf(tokenId);
1704         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1705     }
1706 
1707     /**
1708      * @dev Safely mints `tokenId` and transfers it to `to`.
1709      *
1710      * Requirements:
1711      d*
1712      * - `tokenId` must not exist.
1713      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1714      *
1715      * Emits a {Transfer} event.
1716      */
1717     function _safeMint(address to, uint256 tokenId) internal virtual {
1718         _safeMint(to, tokenId, "");
1719     }
1720 
1721     /**
1722      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1723      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1724      */
1725     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1726         _mint(to, tokenId);
1727         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1728     }
1729 
1730     /**
1731      * @dev Mints `tokenId` and transfers it to `to`.
1732      *
1733      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1734      *
1735      * Requirements:
1736      *
1737      * - `tokenId` must not exist.
1738      * - `to` cannot be the zero address.
1739      *
1740      * Emits a {Transfer} event.
1741      */
1742     function _mint(address to, uint256 tokenId) internal virtual {
1743         require(to != address(0), "ERC721: mint to the zero address");
1744         require(!_exists(tokenId), "ERC721: token already minted");
1745 
1746         _beforeTokenTransfer(address(0), to, tokenId);
1747 
1748         _holderTokens[to].add(tokenId);
1749 
1750         _tokenOwners.set(tokenId, to);
1751 
1752         emit Transfer(address(0), to, tokenId);
1753     }
1754 
1755     /**
1756      * @dev Destroys `tokenId`.
1757      * The approval is cleared when the token is burned.
1758      *
1759      * Requirements:
1760      *
1761      * - `tokenId` must exist.
1762      *
1763      * Emits a {Transfer} event.
1764      */
1765     function _burn(uint256 tokenId) internal virtual {
1766         address owner = ERC721.ownerOf(tokenId); // internal owner
1767 
1768         _beforeTokenTransfer(owner, address(0), tokenId);
1769 
1770         // Clear approvals
1771         _approve(address(0), tokenId);
1772 
1773         // Clear metadata (if any)
1774         if (bytes(_tokenURIs[tokenId]).length != 0) {
1775             delete _tokenURIs[tokenId];
1776         }
1777 
1778         _holderTokens[owner].remove(tokenId);
1779 
1780         _tokenOwners.remove(tokenId);
1781 
1782         emit Transfer(owner, address(0), tokenId);
1783     }
1784 
1785     /**
1786      * @dev Transfers `tokenId` from `from` to `to`.
1787      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1788      *
1789      * Requirements:
1790      *
1791      * - `to` cannot be the zero address.
1792      * - `tokenId` token must be owned by `from`.
1793      *
1794      * Emits a {Transfer} event.
1795      */
1796     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1797         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1798         require(to != address(0), "ERC721: transfer to the zero address");
1799 
1800         _beforeTokenTransfer(from, to, tokenId);
1801 
1802         // Clear approvals from the previous owner
1803         _approve(address(0), tokenId);
1804 
1805         _holderTokens[from].remove(tokenId);
1806         _holderTokens[to].add(tokenId);
1807 
1808         _tokenOwners.set(tokenId, to);
1809 
1810         emit Transfer(from, to, tokenId);
1811     }
1812 
1813     /**
1814      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1815      *
1816      * Requirements:
1817      *
1818      * - `tokenId` must exist.
1819      */
1820     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1821         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1822         _tokenURIs[tokenId] = _tokenURI;
1823     }
1824 
1825     /**
1826      * @dev Internal function to set the base URI for all token IDs. It is
1827      * automatically added as a prefix to the value returned in {tokenURI},
1828      * or to the token ID if {tokenURI} is empty.
1829      */
1830     function _setBaseURI(string memory baseURI_) internal virtual {
1831         _baseURI = baseURI_;
1832     }
1833 
1834     /**
1835      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1836      * The call is not executed if the target address is not a contract.
1837      *
1838      * @param from address representing the previous owner of the given token ID
1839      * @param to target address that will receive the tokens
1840      * @param tokenId uint256 ID of the token to be transferred
1841      * @param _data bytes optional data to send along with the call
1842      * @return bool whether the call correctly returned the expected magic value
1843      */
1844     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1845         private returns (bool)
1846     {
1847         if (!to.isContract()) {
1848             return true;
1849         }
1850         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1851             IERC721Receiver(to).onERC721Received.selector,
1852             _msgSender(),
1853             from,
1854             tokenId,
1855             _data
1856         ), "ERC721: transfer to non ERC721Receiver implementer");
1857         bytes4 retval = abi.decode(returndata, (bytes4));
1858         return (retval == _ERC721_RECEIVED);
1859     }
1860 
1861     function _approve(address to, uint256 tokenId) private {
1862         _tokenApprovals[tokenId] = to;
1863         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1864     }
1865 
1866     /**
1867      * @dev Hook that is called before any token transfer. This includes minting
1868      * and burning.
1869      *
1870      * Calling conditions:
1871      *
1872      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1873      * transferred to `to`.
1874      * - When `from` is zero, `tokenId` will be minted for `to`.
1875      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1876      * - `from` cannot be the zero address.
1877      * - `to` cannot be the zero address.
1878      *
1879      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1880      */
1881     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1882 }
1883 
1884 // File: contracts/RUUMZ.sol
1885 
1886 
1887 
1888 
1889 
1890 
1891 pragma solidity ^0.7.0;
1892 
1893 /**
1894  * @title RuumzContract contract
1895  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1896  */
1897 contract RuumzContract is ERC721, Ownable {
1898     using SafeMath for uint256;
1899 
1900     uint256 public constant ruumPrice = 60000000000000000; //0.06 ETH
1901 
1902     uint256 public constant maxRuumzPurchase = 10;
1903 
1904     uint256 public constant maxRuumz = 10000;
1905 
1906     bool public saleIsActive = true;
1907 
1908     constructor(
1909         string memory name,
1910         string memory symbol
1911     ) ERC721(name, symbol) {
1912     }
1913 
1914     function withdraw() public onlyOwner {
1915         uint256 balance = address(this).balance;
1916         msg.sender.transfer(balance);
1917     }
1918 
1919     /**
1920      * Set some Ruumz aside
1921      */
1922     function reserveRuumz(uint256 numberOfTokens) public onlyOwner {
1923         uint256 supply = totalSupply();
1924         uint256 i;
1925         for (i = 0; i < numberOfTokens; i++) {
1926             _safeMint(msg.sender, supply + i);
1927         }
1928     }
1929 
1930     function setBaseURI(string memory baseURI) public onlyOwner {
1931         _setBaseURI(baseURI);
1932     }
1933 
1934     /*
1935      * Pause sale if active, make active if paused
1936      */
1937     function flipSaleState() public onlyOwner {
1938         saleIsActive = !saleIsActive;
1939     }
1940     /**
1941      * Mints Ruumz
1942      */
1943     function mintRuum(uint256 numberOfTokens) public payable {
1944         require(saleIsActive, "Sale must be active to mint a Ruum");
1945         require(
1946             numberOfTokens <= maxRuumzPurchase,
1947             "Can only mint 10 Ruumz at a time"
1948         );
1949         require(
1950             totalSupply().add(numberOfTokens) <= maxRuumz,
1951             "Purchase would exceed max supply of Ruumz"
1952         );
1953         require(
1954             ruumPrice.mul(numberOfTokens) <= msg.value,
1955             "Ether value sent is not correct"
1956         );
1957 
1958         for (uint256 i = 0; i < numberOfTokens; i++) {
1959             uint256 index = totalSupply();
1960             if (totalSupply() < maxRuumz) {
1961                 _safeMint(msg.sender, index);
1962             }
1963         }
1964     }
1965 }