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
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
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
53     constructor () internal {
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
97 // File: @openzeppelin/contracts/utils/Strings.sol
98 
99 pragma solidity >=0.6.0 <0.8.0;
100 
101 /**
102  * @dev String operations.
103  */
104 library Strings {
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` representation.
107      */
108     function toString(uint256 value) internal pure returns (string memory) {
109         // Inspired by OraclizeAPI's implementation - MIT licence
110         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
111 
112         if (value == 0) {
113             return "0";
114         }
115         uint256 temp = value;
116         uint256 digits;
117         while (temp != 0) {
118             digits++;
119             temp /= 10;
120         }
121         bytes memory buffer = new bytes(digits);
122         uint256 index = digits - 1;
123         temp = value;
124         while (temp != 0) {
125             buffer[index--] = bytes1(uint8(48 + temp % 10));
126             temp /= 10;
127         }
128         return string(buffer);
129     }
130 }
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
399 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
400 
401 pragma solidity >=0.6.0 <0.8.0;
402 
403 /**
404  * @dev Library for managing
405  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
406  * types.
407  *
408  * Sets have the following properties:
409  *
410  * - Elements are added, removed, and checked for existence in constant time
411  * (O(1)).
412  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
413  *
414  * ```
415  * contract Example {
416  *     // Add the library methods
417  *     using EnumerableSet for EnumerableSet.AddressSet;
418  *
419  *     // Declare a set state variable
420  *     EnumerableSet.AddressSet private mySet;
421  * }
422  * ```
423  *
424  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
425  * and `uint256` (`UintSet`) are supported.
426  */
427 library EnumerableSet {
428     // To implement this library for multiple types with as little code
429     // repetition as possible, we write it in terms of a generic Set type with
430     // bytes32 values.
431     // The Set implementation uses private functions, and user-facing
432     // implementations (such as AddressSet) are just wrappers around the
433     // underlying Set.
434     // This means that we can only create new EnumerableSets for types that fit
435     // in bytes32.
436 
437     struct Set {
438         // Storage of set values
439         bytes32[] _values;
440 
441         // Position of the value in the `values` array, plus 1 because index 0
442         // means a value is not in the set.
443         mapping (bytes32 => uint256) _indexes;
444     }
445 
446     /**
447      * @dev Add a value to a set. O(1).
448      *
449      * Returns true if the value was added to the set, that is if it was not
450      * already present.
451      */
452     function _add(Set storage set, bytes32 value) private returns (bool) {
453         if (!_contains(set, value)) {
454             set._values.push(value);
455             // The value is stored at length-1, but we add 1 to all indexes
456             // and use 0 as a sentinel value
457             set._indexes[value] = set._values.length;
458             return true;
459         } else {
460             return false;
461         }
462     }
463 
464     /**
465      * @dev Removes a value from a set. O(1).
466      *
467      * Returns true if the value was removed from the set, that is if it was
468      * present.
469      */
470     function _remove(Set storage set, bytes32 value) private returns (bool) {
471         // We read and store the value's index to prevent multiple reads from the same storage slot
472         uint256 valueIndex = set._indexes[value];
473 
474         if (valueIndex != 0) { // Equivalent to contains(set, value)
475             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
476             // the array, and then remove the last element (sometimes called as 'swap and pop').
477             // This modifies the order of the array, as noted in {at}.
478 
479             uint256 toDeleteIndex = valueIndex - 1;
480             uint256 lastIndex = set._values.length - 1;
481 
482             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
483             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
484 
485             bytes32 lastvalue = set._values[lastIndex];
486 
487             // Move the last value to the index where the value to delete is
488             set._values[toDeleteIndex] = lastvalue;
489             // Update the index for the moved value
490             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
491 
492             // Delete the slot where the moved value was stored
493             set._values.pop();
494 
495             // Delete the index for the deleted slot
496             delete set._indexes[value];
497 
498             return true;
499         } else {
500             return false;
501         }
502     }
503 
504     /**
505      * @dev Returns true if the value is in the set. O(1).
506      */
507     function _contains(Set storage set, bytes32 value) private view returns (bool) {
508         return set._indexes[value] != 0;
509     }
510 
511     /**
512      * @dev Returns the number of values on the set. O(1).
513      */
514     function _length(Set storage set) private view returns (uint256) {
515         return set._values.length;
516     }
517 
518    /**
519     * @dev Returns the value stored at position `index` in the set. O(1).
520     *
521     * Note that there are no guarantees on the ordering of values inside the
522     * array, and it may change when more values are added or removed.
523     *
524     * Requirements:
525     *
526     * - `index` must be strictly less than {length}.
527     */
528     function _at(Set storage set, uint256 index) private view returns (bytes32) {
529         require(set._values.length > index, "EnumerableSet: index out of bounds");
530         return set._values[index];
531     }
532 
533     // Bytes32Set
534 
535     struct Bytes32Set {
536         Set _inner;
537     }
538 
539     /**
540      * @dev Add a value to a set. O(1).
541      *
542      * Returns true if the value was added to the set, that is if it was not
543      * already present.
544      */
545     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
546         return _add(set._inner, value);
547     }
548 
549     /**
550      * @dev Removes a value from a set. O(1).
551      *
552      * Returns true if the value was removed from the set, that is if it was
553      * present.
554      */
555     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
556         return _remove(set._inner, value);
557     }
558 
559     /**
560      * @dev Returns true if the value is in the set. O(1).
561      */
562     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
563         return _contains(set._inner, value);
564     }
565 
566     /**
567      * @dev Returns the number of values in the set. O(1).
568      */
569     function length(Bytes32Set storage set) internal view returns (uint256) {
570         return _length(set._inner);
571     }
572 
573    /**
574     * @dev Returns the value stored at position `index` in the set. O(1).
575     *
576     * Note that there are no guarantees on the ordering of values inside the
577     * array, and it may change when more values are added or removed.
578     *
579     * Requirements:
580     *
581     * - `index` must be strictly less than {length}.
582     */
583     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
584         return _at(set._inner, index);
585     }
586 
587     // AddressSet
588 
589     struct AddressSet {
590         Set _inner;
591     }
592 
593     /**
594      * @dev Add a value to a set. O(1).
595      *
596      * Returns true if the value was added to the set, that is if it was not
597      * already present.
598      */
599     function add(AddressSet storage set, address value) internal returns (bool) {
600         return _add(set._inner, bytes32(uint256(uint160(value))));
601     }
602 
603     /**
604      * @dev Removes a value from a set. O(1).
605      *
606      * Returns true if the value was removed from the set, that is if it was
607      * present.
608      */
609     function remove(AddressSet storage set, address value) internal returns (bool) {
610         return _remove(set._inner, bytes32(uint256(uint160(value))));
611     }
612 
613     /**
614      * @dev Returns true if the value is in the set. O(1).
615      */
616     function contains(AddressSet storage set, address value) internal view returns (bool) {
617         return _contains(set._inner, bytes32(uint256(uint160(value))));
618     }
619 
620     /**
621      * @dev Returns the number of values in the set. O(1).
622      */
623     function length(AddressSet storage set) internal view returns (uint256) {
624         return _length(set._inner);
625     }
626 
627    /**
628     * @dev Returns the value stored at position `index` in the set. O(1).
629     *
630     * Note that there are no guarantees on the ordering of values inside the
631     * array, and it may change when more values are added or removed.
632     *
633     * Requirements:
634     *
635     * - `index` must be strictly less than {length}.
636     */
637     function at(AddressSet storage set, uint256 index) internal view returns (address) {
638         return address(uint160(uint256(_at(set._inner, index))));
639     }
640 
641 
642     // UintSet
643 
644     struct UintSet {
645         Set _inner;
646     }
647 
648     /**
649      * @dev Add a value to a set. O(1).
650      *
651      * Returns true if the value was added to the set, that is if it was not
652      * already present.
653      */
654     function add(UintSet storage set, uint256 value) internal returns (bool) {
655         return _add(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Removes a value from a set. O(1).
660      *
661      * Returns true if the value was removed from the set, that is if it was
662      * present.
663      */
664     function remove(UintSet storage set, uint256 value) internal returns (bool) {
665         return _remove(set._inner, bytes32(value));
666     }
667 
668     /**
669      * @dev Returns true if the value is in the set. O(1).
670      */
671     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
672         return _contains(set._inner, bytes32(value));
673     }
674 
675     /**
676      * @dev Returns the number of values on the set. O(1).
677      */
678     function length(UintSet storage set) internal view returns (uint256) {
679         return _length(set._inner);
680     }
681 
682    /**
683     * @dev Returns the value stored at position `index` in the set. O(1).
684     *
685     * Note that there are no guarantees on the ordering of values inside the
686     * array, and it may change when more values are added or removed.
687     *
688     * Requirements:
689     *
690     * - `index` must be strictly less than {length}.
691     */
692     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
693         return uint256(_at(set._inner, index));
694     }
695 }
696 
697 // File: @openzeppelin/contracts/utils/Address.sol
698 
699 pragma solidity >=0.6.2 <0.8.0;
700 
701 /**
702  * @dev Collection of functions related to the address type
703  */
704 library Address {
705     /**
706      * @dev Returns true if `account` is a contract.
707      *
708      * [IMPORTANT]
709      * ====
710      * It is unsafe to assume that an address for which this function returns
711      * false is an externally-owned account (EOA) and not a contract.
712      *
713      * Among others, `isContract` will return false for the following
714      * types of addresses:
715      *
716      *  - an externally-owned account
717      *  - a contract in construction
718      *  - an address where a contract will be created
719      *  - an address where a contract lived, but was destroyed
720      * ====
721      */
722     function isContract(address account) internal view returns (bool) {
723         // This method relies on extcodesize, which returns 0 for contracts in
724         // construction, since the code is only stored at the end of the
725         // constructor execution.
726 
727         uint256 size;
728         // solhint-disable-next-line no-inline-assembly
729         assembly { size := extcodesize(account) }
730         return size > 0;
731     }
732 
733     /**
734      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
735      * `recipient`, forwarding all available gas and reverting on errors.
736      *
737      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
738      * of certain opcodes, possibly making contracts go over the 2300 gas limit
739      * imposed by `transfer`, making them unable to receive funds via
740      * `transfer`. {sendValue} removes this limitation.
741      *
742      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
743      *
744      * IMPORTANT: because control is transferred to `recipient`, care must be
745      * taken to not create reentrancy vulnerabilities. Consider using
746      * {ReentrancyGuard} or the
747      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
748      */
749     function sendValue(address payable recipient, uint256 amount) internal {
750         require(address(this).balance >= amount, "Address: insufficient balance");
751 
752         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
753         (bool success, ) = recipient.call{ value: amount }("");
754         require(success, "Address: unable to send value, recipient may have reverted");
755     }
756 
757     /**
758      * @dev Performs a Solidity function call using a low level `call`. A
759      * plain`call` is an unsafe replacement for a function call: use this
760      * function instead.
761      *
762      * If `target` reverts with a revert reason, it is bubbled up by this
763      * function (like regular Solidity function calls).
764      *
765      * Returns the raw returned data. To convert to the expected return value,
766      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
767      *
768      * Requirements:
769      *
770      * - `target` must be a contract.
771      * - calling `target` with `data` must not revert.
772      *
773      * _Available since v3.1._
774      */
775     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
776       return functionCall(target, data, "Address: low-level call failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
781      * `errorMessage` as a fallback revert reason when `target` reverts.
782      *
783      * _Available since v3.1._
784      */
785     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
786         return functionCallWithValue(target, data, 0, errorMessage);
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
791      * but also transferring `value` wei to `target`.
792      *
793      * Requirements:
794      *
795      * - the calling contract must have an ETH balance of at least `value`.
796      * - the called Solidity function must be `payable`.
797      *
798      * _Available since v3.1._
799      */
800     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
801         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
806      * with `errorMessage` as a fallback revert reason when `target` reverts.
807      *
808      * _Available since v3.1._
809      */
810     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
811         require(address(this).balance >= value, "Address: insufficient balance for call");
812         require(isContract(target), "Address: call to non-contract");
813 
814         // solhint-disable-next-line avoid-low-level-calls
815         (bool success, bytes memory returndata) = target.call{ value: value }(data);
816         return _verifyCallResult(success, returndata, errorMessage);
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
821      * but performing a static call.
822      *
823      * _Available since v3.3._
824      */
825     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
826         return functionStaticCall(target, data, "Address: low-level static call failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
831      * but performing a static call.
832      *
833      * _Available since v3.3._
834      */
835     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
836         require(isContract(target), "Address: static call to non-contract");
837 
838         // solhint-disable-next-line avoid-low-level-calls
839         (bool success, bytes memory returndata) = target.staticcall(data);
840         return _verifyCallResult(success, returndata, errorMessage);
841     }
842 
843     /**
844      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
845      * but performing a delegate call.
846      *
847      * _Available since v3.4._
848      */
849     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
850         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
855      * but performing a delegate call.
856      *
857      * _Available since v3.4._
858      */
859     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
860         require(isContract(target), "Address: delegate call to non-contract");
861 
862         // solhint-disable-next-line avoid-low-level-calls
863         (bool success, bytes memory returndata) = target.delegatecall(data);
864         return _verifyCallResult(success, returndata, errorMessage);
865     }
866 
867     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
868         if (success) {
869             return returndata;
870         } else {
871             // Look for revert reason and bubble it up if present
872             if (returndata.length > 0) {
873                 // The easiest way to bubble the revert reason is using memory via assembly
874 
875                 // solhint-disable-next-line no-inline-assembly
876                 assembly {
877                     let returndata_size := mload(returndata)
878                     revert(add(32, returndata), returndata_size)
879                 }
880             } else {
881                 revert(errorMessage);
882             }
883         }
884     }
885 }
886 
887 // File: @openzeppelin/contracts/math/SafeMath.sol
888 
889 pragma solidity >=0.6.0 <0.8.0;
890 
891 /**
892  * @dev Wrappers over Solidity's arithmetic operations with added overflow
893  * checks.
894  *
895  * Arithmetic operations in Solidity wrap on overflow. This can easily result
896  * in bugs, because programmers usually assume that an overflow raises an
897  * error, which is the standard behavior in high level programming languages.
898  * `SafeMath` restores this intuition by reverting the transaction when an
899  * operation overflows.
900  *
901  * Using this library instead of the unchecked operations eliminates an entire
902  * class of bugs, so it's recommended to use it always.
903  */
904 library SafeMath {
905     /**
906      * @dev Returns the addition of two unsigned integers, with an overflow flag.
907      *
908      * _Available since v3.4._
909      */
910     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
911         uint256 c = a + b;
912         if (c < a) return (false, 0);
913         return (true, c);
914     }
915 
916     /**
917      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
918      *
919      * _Available since v3.4._
920      */
921     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
922         if (b > a) return (false, 0);
923         return (true, a - b);
924     }
925 
926     /**
927      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
928      *
929      * _Available since v3.4._
930      */
931     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
932         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
933         // benefit is lost if 'b' is also tested.
934         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
935         if (a == 0) return (true, 0);
936         uint256 c = a * b;
937         if (c / a != b) return (false, 0);
938         return (true, c);
939     }
940 
941     /**
942      * @dev Returns the division of two unsigned integers, with a division by zero flag.
943      *
944      * _Available since v3.4._
945      */
946     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
947         if (b == 0) return (false, 0);
948         return (true, a / b);
949     }
950 
951     /**
952      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
953      *
954      * _Available since v3.4._
955      */
956     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
957         if (b == 0) return (false, 0);
958         return (true, a % b);
959     }
960 
961     /**
962      * @dev Returns the addition of two unsigned integers, reverting on
963      * overflow.
964      *
965      * Counterpart to Solidity's `+` operator.
966      *
967      * Requirements:
968      *
969      * - Addition cannot overflow.
970      */
971     function add(uint256 a, uint256 b) internal pure returns (uint256) {
972         uint256 c = a + b;
973         require(c >= a, "SafeMath: addition overflow");
974         return c;
975     }
976 
977     /**
978      * @dev Returns the subtraction of two unsigned integers, reverting on
979      * overflow (when the result is negative).
980      *
981      * Counterpart to Solidity's `-` operator.
982      *
983      * Requirements:
984      *
985      * - Subtraction cannot overflow.
986      */
987     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
988         require(b <= a, "SafeMath: subtraction overflow");
989         return a - b;
990     }
991 
992     /**
993      * @dev Returns the multiplication of two unsigned integers, reverting on
994      * overflow.
995      *
996      * Counterpart to Solidity's `*` operator.
997      *
998      * Requirements:
999      *
1000      * - Multiplication cannot overflow.
1001      */
1002     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1003         if (a == 0) return 0;
1004         uint256 c = a * b;
1005         require(c / a == b, "SafeMath: multiplication overflow");
1006         return c;
1007     }
1008 
1009     /**
1010      * @dev Returns the integer division of two unsigned integers, reverting on
1011      * division by zero. The result is rounded towards zero.
1012      *
1013      * Counterpart to Solidity's `/` operator. Note: this function uses a
1014      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1015      * uses an invalid opcode to revert (consuming all remaining gas).
1016      *
1017      * Requirements:
1018      *
1019      * - The divisor cannot be zero.
1020      */
1021     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1022         require(b > 0, "SafeMath: division by zero");
1023         return a / b;
1024     }
1025 
1026     /**
1027      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1028      * reverting when dividing by zero.
1029      *
1030      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1031      * opcode (which leaves remaining gas untouched) while Solidity uses an
1032      * invalid opcode to revert (consuming all remaining gas).
1033      *
1034      * Requirements:
1035      *
1036      * - The divisor cannot be zero.
1037      */
1038     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1039         require(b > 0, "SafeMath: modulo by zero");
1040         return a % b;
1041     }
1042 
1043     /**
1044      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1045      * overflow (when the result is negative).
1046      *
1047      * CAUTION: This function is deprecated because it requires allocating memory for the error
1048      * message unnecessarily. For custom revert reasons use {trySub}.
1049      *
1050      * Counterpart to Solidity's `-` operator.
1051      *
1052      * Requirements:
1053      *
1054      * - Subtraction cannot overflow.
1055      */
1056     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1057         require(b <= a, errorMessage);
1058         return a - b;
1059     }
1060 
1061     /**
1062      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1063      * division by zero. The result is rounded towards zero.
1064      *
1065      * CAUTION: This function is deprecated because it requires allocating memory for the error
1066      * message unnecessarily. For custom revert reasons use {tryDiv}.
1067      *
1068      * Counterpart to Solidity's `/` operator. Note: this function uses a
1069      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1070      * uses an invalid opcode to revert (consuming all remaining gas).
1071      *
1072      * Requirements:
1073      *
1074      * - The divisor cannot be zero.
1075      */
1076     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1077         require(b > 0, errorMessage);
1078         return a / b;
1079     }
1080 
1081     /**
1082      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1083      * reverting with custom message when dividing by zero.
1084      *
1085      * CAUTION: This function is deprecated because it requires allocating memory for the error
1086      * message unnecessarily. For custom revert reasons use {tryMod}.
1087      *
1088      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1089      * opcode (which leaves remaining gas untouched) while Solidity uses an
1090      * invalid opcode to revert (consuming all remaining gas).
1091      *
1092      * Requirements:
1093      *
1094      * - The divisor cannot be zero.
1095      */
1096     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1097         require(b > 0, errorMessage);
1098         return a % b;
1099     }
1100 }
1101 
1102 // File: @openzeppelin/contracts/introspection/IERC165.sol
1103 
1104 pragma solidity >=0.6.0 <0.8.0;
1105 
1106 /**
1107  * @dev Interface of the ERC165 standard, as defined in the
1108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1109  *
1110  * Implementers can declare support of contract interfaces, which can then be
1111  * queried by others ({ERC165Checker}).
1112  *
1113  * For an implementation, see {ERC165}.
1114  */
1115 interface IERC165 {
1116     /**
1117      * @dev Returns true if this contract implements the interface defined by
1118      * `interfaceId`. See the corresponding
1119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1120      * to learn more about how these ids are created.
1121      *
1122      * This function call must use less than 30 000 gas.
1123      */
1124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1125 }
1126 
1127 // File: @openzeppelin/contracts/introspection/ERC165.sol
1128 
1129 pragma solidity >=0.6.0 <0.8.0;
1130 
1131 
1132 /**
1133  * @dev Implementation of the {IERC165} interface.
1134  *
1135  * Contracts may inherit from this and call {_registerInterface} to declare
1136  * their support of an interface.
1137  */
1138 abstract contract ERC165 is IERC165 {
1139     /*
1140      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1141      */
1142     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1143 
1144     /**
1145      * @dev Mapping of interface ids to whether or not it's supported.
1146      */
1147     mapping(bytes4 => bool) private _supportedInterfaces;
1148 
1149     constructor () internal {
1150         // Derived contracts need only register support for their own interfaces,
1151         // we register support for ERC165 itself here
1152         _registerInterface(_INTERFACE_ID_ERC165);
1153     }
1154 
1155     /**
1156      * @dev See {IERC165-supportsInterface}.
1157      *
1158      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1159      */
1160     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1161         return _supportedInterfaces[interfaceId];
1162     }
1163 
1164     /**
1165      * @dev Registers the contract as an implementer of the interface defined by
1166      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1167      * registering its interface id is not required.
1168      *
1169      * See {IERC165-supportsInterface}.
1170      *
1171      * Requirements:
1172      *
1173      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1174      */
1175     function _registerInterface(bytes4 interfaceId) internal virtual {
1176         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1177         _supportedInterfaces[interfaceId] = true;
1178     }
1179 }
1180 
1181 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1182 
1183 pragma solidity >=0.6.0 <0.8.0;
1184 
1185 /**
1186  * @title ERC721 token receiver interface
1187  * @dev Interface for any contract that wants to support safeTransfers
1188  * from ERC721 asset contracts.
1189  */
1190 interface IERC721Receiver {
1191     /**
1192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1193      * by `operator` from `from`, this function is called.
1194      *
1195      * It must return its Solidity selector to confirm the token transfer.
1196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1197      *
1198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1199      */
1200     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1201 }
1202 
1203 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1204 
1205 pragma solidity >=0.6.2 <0.8.0;
1206 
1207 
1208 /**
1209  * @dev Required interface of an ERC721 compliant contract.
1210  */
1211 interface IERC721 is IERC165 {
1212     /**
1213      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1214      */
1215     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1216 
1217     /**
1218      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1219      */
1220     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1221 
1222     /**
1223      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1224      */
1225     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1226 
1227     /**
1228      * @dev Returns the number of tokens in ``owner``'s account.
1229      */
1230     function balanceOf(address owner) external view returns (uint256 balance);
1231 
1232     /**
1233      * @dev Returns the owner of the `tokenId` token.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      */
1239     function ownerOf(uint256 tokenId) external view returns (address owner);
1240 
1241     /**
1242      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1243      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1244      *
1245      * Requirements:
1246      *
1247      * - `from` cannot be the zero address.
1248      * - `to` cannot be the zero address.
1249      * - `tokenId` token must exist and be owned by `from`.
1250      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1256 
1257     /**
1258      * @dev Transfers `tokenId` token from `from` to `to`.
1259      *
1260      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1261      *
1262      * Requirements:
1263      *
1264      * - `from` cannot be the zero address.
1265      * - `to` cannot be the zero address.
1266      * - `tokenId` token must be owned by `from`.
1267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function transferFrom(address from, address to, uint256 tokenId) external;
1272 
1273     /**
1274      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1275      * The approval is cleared when the token is transferred.
1276      *
1277      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1278      *
1279      * Requirements:
1280      *
1281      * - The caller must own the token or be an approved operator.
1282      * - `tokenId` must exist.
1283      *
1284      * Emits an {Approval} event.
1285      */
1286     function approve(address to, uint256 tokenId) external;
1287 
1288     /**
1289      * @dev Returns the account approved for `tokenId` token.
1290      *
1291      * Requirements:
1292      *
1293      * - `tokenId` must exist.
1294      */
1295     function getApproved(uint256 tokenId) external view returns (address operator);
1296 
1297     /**
1298      * @dev Approve or remove `operator` as an operator for the caller.
1299      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1300      *
1301      * Requirements:
1302      *
1303      * - The `operator` cannot be the caller.
1304      *
1305      * Emits an {ApprovalForAll} event.
1306      */
1307     function setApprovalForAll(address operator, bool _approved) external;
1308 
1309     /**
1310      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1311      *
1312      * See {setApprovalForAll}
1313      */
1314     function isApprovedForAll(address owner, address operator) external view returns (bool);
1315 
1316     /**
1317       * @dev Safely transfers `tokenId` token from `from` to `to`.
1318       *
1319       * Requirements:
1320       *
1321       * - `from` cannot be the zero address.
1322       * - `to` cannot be the zero address.
1323       * - `tokenId` token must exist and be owned by `from`.
1324       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1325       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1326       *
1327       * Emits a {Transfer} event.
1328       */
1329     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1330 }
1331 
1332 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
1333 
1334 pragma solidity >=0.6.2 <0.8.0;
1335 
1336 
1337 /**
1338  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1339  * @dev See https://eips.ethereum.org/EIPS/eip-721
1340  */
1341 interface IERC721Enumerable is IERC721 {
1342 
1343     /**
1344      * @dev Returns the total amount of tokens stored by the contract.
1345      */
1346     function totalSupply() external view returns (uint256);
1347 
1348     /**
1349      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1350      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1351      */
1352     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1353 
1354     /**
1355      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1356      * Use along with {totalSupply} to enumerate all tokens.
1357      */
1358     function tokenByIndex(uint256 index) external view returns (uint256);
1359 }
1360 
1361 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1362 
1363 pragma solidity >=0.6.2 <0.8.0;
1364 
1365 
1366 /**
1367  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1368  * @dev See https://eips.ethereum.org/EIPS/eip-721
1369  */
1370 interface IERC721Metadata is IERC721 {
1371 
1372     /**
1373      * @dev Returns the token collection name.
1374      */
1375     function name() external view returns (string memory);
1376 
1377     /**
1378      * @dev Returns the token collection symbol.
1379      */
1380     function symbol() external view returns (string memory);
1381 
1382     /**
1383      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1384      */
1385     function tokenURI(uint256 tokenId) external view returns (string memory);
1386 }
1387 
1388 
1389 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1390 
1391 pragma solidity >=0.6.0 <0.8.0;
1392 
1393 /**
1394  * @title ERC721 Non-Fungible Token Standard basic implementation
1395  * @dev see https://eips.ethereum.org/EIPS/eip-721
1396  */
1397 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1398     using SafeMath for uint256;
1399     using Address for address;
1400     using EnumerableSet for EnumerableSet.UintSet;
1401     using EnumerableMap for EnumerableMap.UintToAddressMap;
1402     using Strings for uint256;
1403 
1404     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1405     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1406     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1407 
1408     // Mapping from holder address to their (enumerable) set of owned tokens
1409     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1410 
1411     // Enumerable mapping from token ids to their owners
1412     EnumerableMap.UintToAddressMap private _tokenOwners;
1413 
1414     // Mapping from token ID to approved address
1415     mapping (uint256 => address) private _tokenApprovals;
1416 
1417     // Mapping from owner to operator approvals
1418     mapping (address => mapping (address => bool)) private _operatorApprovals;
1419 
1420     // Token name
1421     string private _name;
1422 
1423     // Token symbol
1424     string private _symbol;
1425 
1426     // Optional mapping for token URIs
1427     mapping (uint256 => string) private _tokenURIs;
1428 
1429     // Base URI
1430     string private _baseURI;
1431 
1432     /*
1433      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1434      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1435      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1436      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1437      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1438      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1439      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1440      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1441      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1442      *
1443      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1444      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1445      */
1446     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1447 
1448     /*
1449      *     bytes4(keccak256('name()')) == 0x06fdde03
1450      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1451      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1452      *
1453      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1454      */
1455     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1456 
1457     /*
1458      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1459      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1460      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1461      *
1462      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1463      */
1464     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1465 
1466     /**
1467      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1468      */
1469     constructor (string memory name_, string memory symbol_) public {
1470         _name = name_;
1471         _symbol = symbol_;
1472 
1473         // register the supported interfaces to conform to ERC721 via ERC165
1474         _registerInterface(_INTERFACE_ID_ERC721);
1475         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1476         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1477     }
1478 
1479     /**
1480      * @dev See {IERC721-balanceOf}.
1481      */
1482     function balanceOf(address owner) public view virtual override returns (uint256) {
1483         require(owner != address(0), "ERC721: balance query for the zero address");
1484         return _holderTokens[owner].length();
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-ownerOf}.
1489      */
1490     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1491         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1492     }
1493 
1494     /**
1495      * @dev See {IERC721Metadata-name}.
1496      */
1497     function name() public view virtual override returns (string memory) {
1498         return _name;
1499     }
1500 
1501     /**
1502      * @dev See {IERC721Metadata-symbol}.
1503      */
1504     function symbol() public view virtual override returns (string memory) {
1505         return _symbol;
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Metadata-tokenURI}.
1510      */
1511     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1512         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1513 
1514         string memory _tokenURI = _tokenURIs[tokenId];
1515         string memory base = baseURI();
1516 
1517         // If there is no base URI, return the token URI.
1518         if (bytes(base).length == 0) {
1519             return _tokenURI;
1520         }
1521         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1522         if (bytes(_tokenURI).length > 0) {
1523             return string(abi.encodePacked(base, _tokenURI));
1524         }
1525         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1526         return string(abi.encodePacked(base, tokenId.toString()));
1527     }
1528 
1529     /**
1530     * @dev Returns the base URI set via {_setBaseURI}. This will be
1531     * automatically added as a prefix in {tokenURI} to each token's URI, or
1532     * to the token ID if no specific URI is set for that token ID.
1533     */
1534     function baseURI() public view virtual returns (string memory) {
1535         return _baseURI;
1536     }
1537 
1538     /**
1539      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1540      */
1541     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1542         return _holderTokens[owner].at(index);
1543     }
1544 
1545     /**
1546      * @dev See {IERC721Enumerable-totalSupply}.
1547      */
1548     function totalSupply() public view virtual override returns (uint256) {
1549         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1550         return _tokenOwners.length();
1551     }
1552 
1553     /**
1554      * @dev See {IERC721Enumerable-tokenByIndex}.
1555      */
1556     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1557         (uint256 tokenId, ) = _tokenOwners.at(index);
1558         return tokenId;
1559     }
1560 
1561     /**
1562      * @dev See {IERC721-approve}.
1563      */
1564     function approve(address to, uint256 tokenId) public virtual override {
1565         address owner = ERC721.ownerOf(tokenId);
1566         require(to != owner, "ERC721: approval to current owner");
1567 
1568         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1569             "ERC721: approve caller is not owner nor approved for all"
1570         );
1571 
1572         _approve(to, tokenId);
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-getApproved}.
1577      */
1578     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1579         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1580 
1581         return _tokenApprovals[tokenId];
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-setApprovalForAll}.
1586      */
1587     function setApprovalForAll(address operator, bool approved) public virtual override {
1588         require(operator != _msgSender(), "ERC721: approve to caller");
1589 
1590         _operatorApprovals[_msgSender()][operator] = approved;
1591         emit ApprovalForAll(_msgSender(), operator, approved);
1592     }
1593 
1594     /**
1595      * @dev See {IERC721-isApprovedForAll}.
1596      */
1597     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1598         return _operatorApprovals[owner][operator];
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-transferFrom}.
1603      */
1604     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1605         //solhint-disable-next-line max-line-length
1606         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1607 
1608         _transfer(from, to, tokenId);
1609     }
1610 
1611     /**
1612      * @dev See {IERC721-safeTransferFrom}.
1613      */
1614     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1615         safeTransferFrom(from, to, tokenId, "");
1616     }
1617 
1618     /**
1619      * @dev See {IERC721-safeTransferFrom}.
1620      */
1621     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1622         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1623         _safeTransfer(from, to, tokenId, _data);
1624     }
1625 
1626     /**
1627      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1628      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1629      *
1630      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1631      *
1632      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1633      * implement alternative mechanisms to perform token transfer, such as signature-based.
1634      *
1635      * Requirements:
1636      *
1637      * - `from` cannot be the zero address.
1638      * - `to` cannot be the zero address.
1639      * - `tokenId` token must exist and be owned by `from`.
1640      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1645         _transfer(from, to, tokenId);
1646         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1647     }
1648 
1649     /**
1650      * @dev Returns whether `tokenId` exists.
1651      *
1652      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1653      *
1654      * Tokens start existing when they are minted (`_mint`),
1655      * and stop existing when they are burned (`_burn`).
1656      */
1657     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1658         return _tokenOwners.contains(tokenId);
1659     }
1660 
1661     /**
1662      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1663      *
1664      * Requirements:
1665      *
1666      * - `tokenId` must exist.
1667      */
1668     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1669         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1670         address owner = ERC721.ownerOf(tokenId);
1671         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1672     }
1673 
1674     /**
1675      * @dev Safely mints `tokenId` and transfers it to `to`.
1676      *
1677      * Requirements:
1678      d*
1679      * - `tokenId` must not exist.
1680      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function _safeMint(address to, uint256 tokenId) internal virtual {
1685         _safeMint(to, tokenId, "");
1686     }
1687 
1688     /**
1689      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1690      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1691      */
1692     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1693         _mint(to, tokenId);
1694         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1695     }
1696 
1697     /**
1698      * @dev Mints `tokenId` and transfers it to `to`.
1699      *
1700      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1701      *
1702      * Requirements:
1703      *
1704      * - `tokenId` must not exist.
1705      * - `to` cannot be the zero address.
1706      *
1707      * Emits a {Transfer} event.
1708      */
1709     function _mint(address to, uint256 tokenId) internal virtual {
1710         require(to != address(0), "ERC721: mint to the zero address");
1711         require(!_exists(tokenId), "ERC721: token already minted");
1712 
1713         _beforeTokenTransfer(address(0), to, tokenId);
1714 
1715         _holderTokens[to].add(tokenId);
1716 
1717         _tokenOwners.set(tokenId, to);
1718 
1719         emit Transfer(address(0), to, tokenId);
1720     }
1721 
1722     /**
1723      * @dev Destroys `tokenId`.
1724      * The approval is cleared when the token is burned.
1725      *
1726      * Requirements:
1727      *
1728      * - `tokenId` must exist.
1729      *
1730      * Emits a {Transfer} event.
1731      */
1732     function _burn(uint256 tokenId) internal virtual {
1733         address owner = ERC721.ownerOf(tokenId); // internal owner
1734 
1735         _beforeTokenTransfer(owner, address(0), tokenId);
1736 
1737         // Clear approvals
1738         _approve(address(0), tokenId);
1739 
1740         // Clear metadata (if any)
1741         if (bytes(_tokenURIs[tokenId]).length != 0) {
1742             delete _tokenURIs[tokenId];
1743         }
1744 
1745         _holderTokens[owner].remove(tokenId);
1746 
1747         _tokenOwners.remove(tokenId);
1748 
1749         emit Transfer(owner, address(0), tokenId);
1750     }
1751 
1752     /**
1753      * @dev Transfers `tokenId` from `from` to `to`.
1754      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1755      *
1756      * Requirements:
1757      *
1758      * - `to` cannot be the zero address.
1759      * - `tokenId` token must be owned by `from`.
1760      *
1761      * Emits a {Transfer} event.
1762      */
1763     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1764         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1765         require(to != address(0), "ERC721: transfer to the zero address");
1766 
1767         _beforeTokenTransfer(from, to, tokenId);
1768 
1769         // Clear approvals from the previous owner
1770         _approve(address(0), tokenId);
1771 
1772         _holderTokens[from].remove(tokenId);
1773         _holderTokens[to].add(tokenId);
1774 
1775         _tokenOwners.set(tokenId, to);
1776 
1777         emit Transfer(from, to, tokenId);
1778     }
1779 
1780     /**
1781      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1782      *
1783      * Requirements:
1784      *
1785      * - `tokenId` must exist.
1786      */
1787     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1788         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1789         _tokenURIs[tokenId] = _tokenURI;
1790     }
1791 
1792     /**
1793      * @dev Internal function to set the base URI for all token IDs. It is
1794      * automatically added as a prefix to the value returned in {tokenURI},
1795      * or to the token ID if {tokenURI} is empty.
1796      */
1797     function _setBaseURI(string memory baseURI_) internal virtual {
1798         _baseURI = baseURI_;
1799     }
1800 
1801     /**
1802      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1803      * The call is not executed if the target address is not a contract.
1804      *
1805      * @param from address representing the previous owner of the given token ID
1806      * @param to target address that will receive the tokens
1807      * @param tokenId uint256 ID of the token to be transferred
1808      * @param _data bytes optional data to send along with the call
1809      * @return bool whether the call correctly returned the expected magic value
1810      */
1811     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1812         private returns (bool)
1813     {
1814         if (!to.isContract()) {
1815             return true;
1816         }
1817         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1818             IERC721Receiver(to).onERC721Received.selector,
1819             _msgSender(),
1820             from,
1821             tokenId,
1822             _data
1823         ), "ERC721: transfer to non ERC721Receiver implementer");
1824         bytes4 retval = abi.decode(returndata, (bytes4));
1825         return (retval == _ERC721_RECEIVED);
1826     }
1827 
1828     /**
1829      * @dev Approve `to` to operate on `tokenId`
1830      *
1831      * Emits an {Approval} event.
1832      */
1833     function _approve(address to, uint256 tokenId) internal virtual {
1834         _tokenApprovals[tokenId] = to;
1835         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1836     }
1837 
1838     /**
1839      * @dev Hook that is called before any token transfer. This includes minting
1840      * and burning.
1841      *
1842      * Calling conditions:
1843      *
1844      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1845      * transferred to `to`.
1846      * - When `from` is zero, `tokenId` will be minted for `to`.
1847      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1848      * - `from` cannot be the zero address.
1849      * - `to` cannot be the zero address.
1850      *
1851      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1852      */
1853     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1854 }
1855 
1856 // File: contracts/Voxies.sol
1857 
1858 // contracts/Voxies.sol
1859 pragma solidity ^0.7.0;
1860 
1861 
1862 
1863 // Inspired/Copied fromm BGANPUNKS V2 (bastardganpunks.club)
1864 contract Voxies is ERC721, Ownable {
1865     using SafeMath for uint256;
1866     uint public constant MAX_VOXIES = 10000;
1867     bool public hasSaleStarted = false;
1868     
1869     // The IPFS hash for all Voxies concatenated *might* stored here once all Voxies are issued
1870     string public METADATA_PROVENANCE_HASH = "";
1871 
1872     // Truth.　
1873     string public constant R = "Voxies are the cutest combination of voxels and blockchain technology!";
1874 
1875     constructor(string memory baseURI) ERC721("Voxies","VOXIES")  {
1876         setBaseURI(baseURI);
1877     }
1878     
1879     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1880         uint256 tokenCount = balanceOf(_owner);
1881         if (tokenCount == 0) {
1882             // Return an empty array
1883             return new uint256[](0);
1884         } else {
1885             uint256[] memory result = new uint256[](tokenCount);
1886             uint256 index;
1887             for (index = 0; index < tokenCount; index++) {
1888                 result[index] = tokenOfOwnerByIndex(_owner, index);
1889             }
1890             return result;
1891         }
1892     }
1893     
1894     function calculatePrice() public view returns (uint256) {
1895         require(hasSaleStarted == true, "Sale hasn't started");
1896         require(totalSupply() < MAX_VOXIES, "All Voxies have been sold");
1897 
1898         uint currentSupply = totalSupply();
1899         if (currentSupply >= 9900) {
1900             return 1000000000000000000;        // 9900 - 10000: 1.00 ETH
1901         } else if (currentSupply >= 9500) {
1902             return 640000000000000000;         // 9500 - 9900:  0.64 ETH
1903         } else if (currentSupply >= 7500) {
1904             return 320000000000000000;         // 7500 - 9500:  0.32 ETH
1905         } else if (currentSupply >= 3500) {
1906             return 160000000000000000;         // 3500 - 7500:  0.16 ETH
1907         } else if (currentSupply >= 1500) {
1908             return 80000000000000000;          // 1500 - 3500:  0.08 ETH 
1909         } else if (currentSupply >= 500) {
1910             return 40000000000000000;          // 500 - 1500:   0.04 ETH 
1911         } else {
1912             return 20000000000000000;          // 0 - 500:     0.02 ETH
1913         }
1914     }
1915 
1916     function calculatePriceForToken(uint _id) public view returns (uint256) {
1917         require(_id < MAX_VOXIES, "Id is bigger than the max number of voxies");
1918 
1919         if (_id >= 9900) {
1920             return 1000000000000000000;        // 9900 - 10000: 1.00 ETH
1921         } else if (_id >= 9500) {
1922             return 640000000000000000;         // 9500 - 9900:  0.64 ETH
1923         } else if (_id >= 7500) {
1924             return 320000000000000000;         // 7500 - 9500:  0.32 ETH
1925         } else if (_id >= 3500) {
1926             return 160000000000000000;         // 3500 - 7500:  0.16 ETH
1927         } else if (_id >= 1500) {
1928             return 80000000000000000;          // 1500 - 3500:  0.08 ETH 
1929         } else if (_id >= 500) {
1930             return 40000000000000000;          // 500- 1500:   0.04 ETH 
1931         } else {
1932             return 20000000000000000;          // 0 - 500:     0.02 ETH
1933         }
1934     }
1935     
1936    function adoptVoxie(uint256 numVoxies) public payable {
1937         require(totalSupply() < MAX_VOXIES, "All Voxies have been sold");
1938         require(numVoxies > 0 && numVoxies <= 20, "You can adopt minimum 1, maximum 20 Voxies");
1939         require(totalSupply().add(numVoxies) <= MAX_VOXIES, "Exceeds MAX_VOXIES");
1940         require(msg.value >= calculatePrice().mul(numVoxies), "Ether value sent is below the price");
1941 
1942         for (uint i = 0; i < numVoxies; i++) {
1943             uint mintIndex = totalSupply();
1944             _safeMint(msg.sender, mintIndex);
1945         }
1946     }
1947     
1948     // God Mode
1949     function setProvenanceHash(string memory _hash) public onlyOwner {
1950         METADATA_PROVENANCE_HASH = _hash;
1951     }
1952     
1953     function setBaseURI(string memory baseURI) public onlyOwner {
1954         _setBaseURI(baseURI);
1955     }
1956     
1957     function startSale() public onlyOwner {
1958         hasSaleStarted = true;
1959     }
1960     function pauseSale() public onlyOwner {
1961         hasSaleStarted = false;
1962     }
1963     
1964     function withdrawAll() public payable onlyOwner {
1965         require(payable(msg.sender).send(address(this).balance));
1966     }
1967 
1968     function reserveGiveaway(uint256 numVoxies) public onlyOwner {
1969         uint currentSupply = totalSupply();
1970         require(totalSupply().add(numVoxies) <= 30, "Exceeded giveaway supply");
1971         uint256 index;
1972         // Reserved for giveaways and donations to the community
1973         for (index = 0; index < numVoxies; index++) {
1974             _safeMint(owner(), currentSupply + index);
1975         }
1976     }
1977 }