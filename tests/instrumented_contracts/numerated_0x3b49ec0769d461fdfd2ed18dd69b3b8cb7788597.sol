1 /**
2  *Submitted for verification at Etherscan.io on 24/09/2021
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 
8 
9 // ███╗░░░███╗░█████╗░███╗░░██╗░██████╗████████╗███████╗██████╗░  ███╗░░░███╗░█████╗░░██████╗██╗░░██╗
10 // ████╗░████║██╔══██╗████╗░██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗  ████╗░████║██╔══██╗██╔════╝██║░░██║
11 // ██╔████╔██║██║░░██║██╔██╗██║╚█████╗░░░░██║░░░█████╗░░██████╔╝  ██╔████╔██║███████║╚█████╗░███████║
12 // ██║╚██╔╝██║██║░░██║██║╚████║░╚═══██╗░░░██║░░░██╔══╝░░██╔══██╗  ██║╚██╔╝██║██╔══██║░╚═══██╗██╔══██║
13 // ██║░╚═╝░██║╚█████╔╝██║░╚███║██████╔╝░░░██║░░░███████╗██║░░██║  ██║░╚═╝░██║██║░░██║██████╔╝██║░░██║
14 // ╚═╝░░░░░╚═╝░╚════╝░╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝  ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝
15 
16 pragma solidity >=0.6.0 <0.8.0;
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 
40 // File: @openzeppelin/contracts/access/Ownable.sol
41 
42 pragma solidity >=0.6.0 <0.8.0;
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor () internal {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 
109 // File: @openzeppelin/contracts/utils/Strings.sol
110 
111 pragma solidity >=0.6.0 <0.8.0;
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` representation.
119      */
120     function toString(uint256 value) internal pure returns (string memory) {
121         // Inspired by OraclizeAPI's implementation - MIT licence
122         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
123 
124         if (value == 0) {
125             return "0";
126         }
127         uint256 temp = value;
128         uint256 digits;
129         while (temp != 0) {
130             digits++;
131             temp /= 10;
132         }
133         bytes memory buffer = new bytes(digits);
134         uint256 index = digits - 1;
135         temp = value;
136         while (temp != 0) {
137             buffer[index--] = bytes1(uint8(48 + temp % 10));
138             temp /= 10;
139         }
140         return string(buffer);
141     }
142 }
143 
144 
145 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
146 
147 pragma solidity >=0.6.0 <0.8.0;
148 
149 /**
150  * @dev Library for managing an enumerable variant of Solidity's
151  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
152  * type.
153  *
154  * Maps have the following properties:
155  *
156  * - Entries are added, removed, and checked for existence in constant time
157  * (O(1)).
158  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
159  *
160  * ```
161  * contract Example {
162  *     // Add the library methods
163  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
164  *
165  *     // Declare a set state variable
166  *     EnumerableMap.UintToAddressMap private myMap;
167  * }
168  * ```
169  *
170  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
171  * supported.
172  */
173 library EnumerableMap {
174     // To implement this library for multiple types with as little code
175     // repetition as possible, we write it in terms of a generic Map type with
176     // bytes32 keys and values.
177     // The Map implementation uses private functions, and user-facing
178     // implementations (such as Uint256ToAddressMap) are just wrappers around
179     // the underlying Map.
180     // This means that we can only create new EnumerableMaps for types that fit
181     // in bytes32.
182 
183     struct MapEntry {
184         bytes32 _key;
185         bytes32 _value;
186     }
187 
188     struct Map {
189         // Storage of map keys and values
190         MapEntry[] _entries;
191 
192         // Position of the entry defined by a key in the `entries` array, plus 1
193         // because index 0 means a key is not in the map.
194         mapping (bytes32 => uint256) _indexes;
195     }
196 
197     /**
198      * @dev Adds a key-value pair to a map, or updates the value for an existing
199      * key. O(1).
200      *
201      * Returns true if the key was added to the map, that is if it was not
202      * already present.
203      */
204     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
205         // We read and store the key's index to prevent multiple reads from the same storage slot
206         uint256 keyIndex = map._indexes[key];
207 
208         if (keyIndex == 0) { // Equivalent to !contains(map, key)
209             map._entries.push(MapEntry({ _key: key, _value: value }));
210             // The entry is stored at length-1, but we add 1 to all indexes
211             // and use 0 as a sentinel value
212             map._indexes[key] = map._entries.length;
213             return true;
214         } else {
215             map._entries[keyIndex - 1]._value = value;
216             return false;
217         }
218     }
219 
220     /**
221      * @dev Removes a key-value pair from a map. O(1).
222      *
223      * Returns true if the key was removed from the map, that is if it was present.
224      */
225     function _remove(Map storage map, bytes32 key) private returns (bool) {
226         // We read and store the key's index to prevent multiple reads from the same storage slot
227         uint256 keyIndex = map._indexes[key];
228 
229         if (keyIndex != 0) { // Equivalent to contains(map, key)
230             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
231             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
232             // This modifies the order of the array, as noted in {at}.
233 
234             uint256 toDeleteIndex = keyIndex - 1;
235             uint256 lastIndex = map._entries.length - 1;
236 
237             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
238             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
239 
240             MapEntry storage lastEntry = map._entries[lastIndex];
241 
242             // Move the last entry to the index where the entry to delete is
243             map._entries[toDeleteIndex] = lastEntry;
244             // Update the index for the moved entry
245             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
246 
247             // Delete the slot where the moved entry was stored
248             map._entries.pop();
249 
250             // Delete the index for the deleted slot
251             delete map._indexes[key];
252 
253             return true;
254         } else {
255             return false;
256         }
257     }
258 
259     /**
260      * @dev Returns true if the key is in the map. O(1).
261      */
262     function _contains(Map storage map, bytes32 key) private view returns (bool) {
263         return map._indexes[key] != 0;
264     }
265 
266     /**
267      * @dev Returns the number of key-value pairs in the map. O(1).
268      */
269     function _length(Map storage map) private view returns (uint256) {
270         return map._entries.length;
271     }
272 
273    /**
274     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
275     *
276     * Note that there are no guarantees on the ordering of entries inside the
277     * array, and it may change when more entries are added or removed.
278     *
279     * Requirements:
280     *
281     * - `index` must be strictly less than {length}.
282     */
283     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
284         require(map._entries.length > index, "EnumerableMap: index out of bounds");
285 
286         MapEntry storage entry = map._entries[index];
287         return (entry._key, entry._value);
288     }
289 
290     /**
291      * @dev Tries to returns the value associated with `key`.  O(1).
292      * Does not revert if `key` is not in the map.
293      */
294     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
295         uint256 keyIndex = map._indexes[key];
296         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
297         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
298     }
299 
300     /**
301      * @dev Returns the value associated with `key`.  O(1).
302      *
303      * Requirements:
304      *
305      * - `key` must be in the map.
306      */
307     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
308         uint256 keyIndex = map._indexes[key];
309         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
310         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
311     }
312 
313     /**
314      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
315      *
316      * CAUTION: This function is deprecated because it requires allocating memory for the error
317      * message unnecessarily. For custom revert reasons use {_tryGet}.
318      */
319     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
320         uint256 keyIndex = map._indexes[key];
321         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
322         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
323     }
324 
325     // UintToAddressMap
326 
327     struct UintToAddressMap {
328         Map _inner;
329     }
330 
331     /**
332      * @dev Adds a key-value pair to a map, or updates the value for an existing
333      * key. O(1).
334      *
335      * Returns true if the key was added to the map, that is if it was not
336      * already present.
337      */
338     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
339         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
340     }
341 
342     /**
343      * @dev Removes a value from a set. O(1).
344      *
345      * Returns true if the key was removed from the map, that is if it was present.
346      */
347     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
348         return _remove(map._inner, bytes32(key));
349     }
350 
351     /**
352      * @dev Returns true if the key is in the map. O(1).
353      */
354     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
355         return _contains(map._inner, bytes32(key));
356     }
357 
358     /**
359      * @dev Returns the number of elements in the map. O(1).
360      */
361     function length(UintToAddressMap storage map) internal view returns (uint256) {
362         return _length(map._inner);
363     }
364 
365    /**
366     * @dev Returns the element stored at position `index` in the set. O(1).
367     * Note that there are no guarantees on the ordering of values inside the
368     * array, and it may change when more values are added or removed.
369     *
370     * Requirements:
371     *
372     * - `index` must be strictly less than {length}.
373     */
374     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
375         (bytes32 key, bytes32 value) = _at(map._inner, index);
376         return (uint256(key), address(uint160(uint256(value))));
377     }
378 
379     /**
380      * @dev Tries to returns the value associated with `key`.  O(1).
381      * Does not revert if `key` is not in the map.
382      *
383      * _Available since v3.4._
384      */
385     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
386         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
387         return (success, address(uint160(uint256(value))));
388     }
389 
390     /**
391      * @dev Returns the value associated with `key`.  O(1).
392      *
393      * Requirements:
394      *
395      * - `key` must be in the map.
396      */
397     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
398         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
399     }
400 
401     /**
402      * @dev Same as {get}, with a custom error message when `key` is not in the map.
403      *
404      * CAUTION: This function is deprecated because it requires allocating memory for the error
405      * message unnecessarily. For custom revert reasons use {tryGet}.
406      */
407     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
408         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
409     }
410 }
411 
412 
413 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
414 
415 pragma solidity >=0.6.0 <0.8.0;
416 
417 /**
418  * @dev Library for managing
419  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
420  * types.
421  *
422  * Sets have the following properties:
423  *
424  * - Elements are added, removed, and checked for existence in constant time
425  * (O(1)).
426  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
427  *
428  * ```
429  * contract Example {
430  *     // Add the library methods
431  *     using EnumerableSet for EnumerableSet.AddressSet;
432  *
433  *     // Declare a set state variable
434  *     EnumerableSet.AddressSet private mySet;
435  * }
436  * ```
437  *
438  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
439  * and `uint256` (`UintSet`) are supported.
440  */
441 library EnumerableSet {
442     // To implement this library for multiple types with as little code
443     // repetition as possible, we write it in terms of a generic Set type with
444     // bytes32 values.
445     // The Set implementation uses private functions, and user-facing
446     // implementations (such as AddressSet) are just wrappers around the
447     // underlying Set.
448     // This means that we can only create new EnumerableSets for types that fit
449     // in bytes32.
450 
451     struct Set {
452         // Storage of set values
453         bytes32[] _values;
454 
455         // Position of the value in the `values` array, plus 1 because index 0
456         // means a value is not in the set.
457         mapping (bytes32 => uint256) _indexes;
458     }
459 
460     /**
461      * @dev Add a value to a set. O(1).
462      *
463      * Returns true if the value was added to the set, that is if it was not
464      * already present.
465      */
466     function _add(Set storage set, bytes32 value) private returns (bool) {
467         if (!_contains(set, value)) {
468             set._values.push(value);
469             // The value is stored at length-1, but we add 1 to all indexes
470             // and use 0 as a sentinel value
471             set._indexes[value] = set._values.length;
472             return true;
473         } else {
474             return false;
475         }
476     }
477 
478     /**
479      * @dev Removes a value from a set. O(1).
480      *
481      * Returns true if the value was removed from the set, that is if it was
482      * present.
483      */
484     function _remove(Set storage set, bytes32 value) private returns (bool) {
485         // We read and store the value's index to prevent multiple reads from the same storage slot
486         uint256 valueIndex = set._indexes[value];
487 
488         if (valueIndex != 0) { // Equivalent to contains(set, value)
489             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
490             // the array, and then remove the last element (sometimes called as 'swap and pop').
491             // This modifies the order of the array, as noted in {at}.
492 
493             uint256 toDeleteIndex = valueIndex - 1;
494             uint256 lastIndex = set._values.length - 1;
495 
496             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
497             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
498 
499             bytes32 lastvalue = set._values[lastIndex];
500 
501             // Move the last value to the index where the value to delete is
502             set._values[toDeleteIndex] = lastvalue;
503             // Update the index for the moved value
504             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
505 
506             // Delete the slot where the moved value was stored
507             set._values.pop();
508 
509             // Delete the index for the deleted slot
510             delete set._indexes[value];
511 
512             return true;
513         } else {
514             return false;
515         }
516     }
517 
518     /**
519      * @dev Returns true if the value is in the set. O(1).
520      */
521     function _contains(Set storage set, bytes32 value) private view returns (bool) {
522         return set._indexes[value] != 0;
523     }
524 
525     /**
526      * @dev Returns the number of values on the set. O(1).
527      */
528     function _length(Set storage set) private view returns (uint256) {
529         return set._values.length;
530     }
531 
532    /**
533     * @dev Returns the value stored at position `index` in the set. O(1).
534     *
535     * Note that there are no guarantees on the ordering of values inside the
536     * array, and it may change when more values are added or removed.
537     *
538     * Requirements:
539     *
540     * - `index` must be strictly less than {length}.
541     */
542     function _at(Set storage set, uint256 index) private view returns (bytes32) {
543         require(set._values.length > index, "EnumerableSet: index out of bounds");
544         return set._values[index];
545     }
546 
547     // Bytes32Set
548 
549     struct Bytes32Set {
550         Set _inner;
551     }
552 
553     /**
554      * @dev Add a value to a set. O(1).
555      *
556      * Returns true if the value was added to the set, that is if it was not
557      * already present.
558      */
559     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
560         return _add(set._inner, value);
561     }
562 
563     /**
564      * @dev Removes a value from a set. O(1).
565      *
566      * Returns true if the value was removed from the set, that is if it was
567      * present.
568      */
569     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
570         return _remove(set._inner, value);
571     }
572 
573     /**
574      * @dev Returns true if the value is in the set. O(1).
575      */
576     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
577         return _contains(set._inner, value);
578     }
579 
580     /**
581      * @dev Returns the number of values in the set. O(1).
582      */
583     function length(Bytes32Set storage set) internal view returns (uint256) {
584         return _length(set._inner);
585     }
586 
587    /**
588     * @dev Returns the value stored at position `index` in the set. O(1).
589     *
590     * Note that there are no guarantees on the ordering of values inside the
591     * array, and it may change when more values are added or removed.
592     *
593     * Requirements:
594     *
595     * - `index` must be strictly less than {length}.
596     */
597     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
598         return _at(set._inner, index);
599     }
600 
601     // AddressSet
602 
603     struct AddressSet {
604         Set _inner;
605     }
606 
607     /**
608      * @dev Add a value to a set. O(1).
609      *
610      * Returns true if the value was added to the set, that is if it was not
611      * already present.
612      */
613     function add(AddressSet storage set, address value) internal returns (bool) {
614         return _add(set._inner, bytes32(uint256(uint160(value))));
615     }
616 
617     /**
618      * @dev Removes a value from a set. O(1).
619      *
620      * Returns true if the value was removed from the set, that is if it was
621      * present.
622      */
623     function remove(AddressSet storage set, address value) internal returns (bool) {
624         return _remove(set._inner, bytes32(uint256(uint160(value))));
625     }
626 
627     /**
628      * @dev Returns true if the value is in the set. O(1).
629      */
630     function contains(AddressSet storage set, address value) internal view returns (bool) {
631         return _contains(set._inner, bytes32(uint256(uint160(value))));
632     }
633 
634     /**
635      * @dev Returns the number of values in the set. O(1).
636      */
637     function length(AddressSet storage set) internal view returns (uint256) {
638         return _length(set._inner);
639     }
640 
641    /**
642     * @dev Returns the value stored at position `index` in the set. O(1).
643     *
644     * Note that there are no guarantees on the ordering of values inside the
645     * array, and it may change when more values are added or removed.
646     *
647     * Requirements:
648     *
649     * - `index` must be strictly less than {length}.
650     */
651     function at(AddressSet storage set, uint256 index) internal view returns (address) {
652         return address(uint160(uint256(_at(set._inner, index))));
653     }
654 
655 
656     // UintSet
657 
658     struct UintSet {
659         Set _inner;
660     }
661 
662     /**
663      * @dev Add a value to a set. O(1).
664      *
665      * Returns true if the value was added to the set, that is if it was not
666      * already present.
667      */
668     function add(UintSet storage set, uint256 value) internal returns (bool) {
669         return _add(set._inner, bytes32(value));
670     }
671 
672     /**
673      * @dev Removes a value from a set. O(1).
674      *
675      * Returns true if the value was removed from the set, that is if it was
676      * present.
677      */
678     function remove(UintSet storage set, uint256 value) internal returns (bool) {
679         return _remove(set._inner, bytes32(value));
680     }
681 
682     /**
683      * @dev Returns true if the value is in the set. O(1).
684      */
685     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
686         return _contains(set._inner, bytes32(value));
687     }
688 
689     /**
690      * @dev Returns the number of values on the set. O(1).
691      */
692     function length(UintSet storage set) internal view returns (uint256) {
693         return _length(set._inner);
694     }
695 
696    /**
697     * @dev Returns the value stored at position `index` in the set. O(1).
698     *
699     * Note that there are no guarantees on the ordering of values inside the
700     * array, and it may change when more values are added or removed.
701     *
702     * Requirements:
703     *
704     * - `index` must be strictly less than {length}.
705     */
706     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
707         return uint256(_at(set._inner, index));
708     }
709 }
710 
711 
712 // File: @openzeppelin/contracts/utils/Address.sol
713 
714 pragma solidity >=0.6.2 <0.8.0;
715 
716 /**
717  * @dev Collection of functions related to the address type
718  */
719 library Address {
720     /**
721      * @dev Returns true if `account` is a contract.
722      *
723      * [IMPORTANT]
724      * ====
725      * It is unsafe to assume that an address for which this function returns
726      * false is an externally-owned account (EOA) and not a contract.
727      *
728      * Among others, `isContract` will return false for the following
729      * types of addresses:
730      *
731      *  - an externally-owned account
732      *  - a contract in construction
733      *  - an address where a contract will be created
734      *  - an address where a contract lived, but was destroyed
735      * ====
736      */
737     function isContract(address account) internal view returns (bool) {
738         // This method relies on extcodesize, which returns 0 for contracts in
739         // construction, since the code is only stored at the end of the
740         // constructor execution.
741 
742         uint256 size;
743         // solhint-disable-next-line no-inline-assembly
744         assembly { size := extcodesize(account) }
745         return size > 0;
746     }
747 
748     /**
749      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
750      * `recipient`, forwarding all available gas and reverting on errors.
751      *
752      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
753      * of certain opcodes, possibly making contracts go over the 2300 gas limit
754      * imposed by `transfer`, making them unable to receive funds via
755      * `transfer`. {sendValue} removes this limitation.
756      *
757      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
758      *
759      * IMPORTANT: because control is transferred to `recipient`, care must be
760      * taken to not create reentrancy vulnerabilities. Consider using
761      * {ReentrancyGuard} or the
762      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
763      */
764     function sendValue(address payable recipient, uint256 amount) internal {
765         require(address(this).balance >= amount, "Address: insufficient balance");
766 
767         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
768         (bool success, ) = recipient.call{ value: amount }("");
769         require(success, "Address: unable to send value, recipient may have reverted");
770     }
771 
772     /**
773      * @dev Performs a Solidity function call using a low level `call`. A
774      * plain`call` is an unsafe replacement for a function call: use this
775      * function instead.
776      *
777      * If `target` reverts with a revert reason, it is bubbled up by this
778      * function (like regular Solidity function calls).
779      *
780      * Returns the raw returned data. To convert to the expected return value,
781      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
782      *
783      * Requirements:
784      *
785      * - `target` must be a contract.
786      * - calling `target` with `data` must not revert.
787      *
788      * _Available since v3.1._
789      */
790     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
791       return functionCall(target, data, "Address: low-level call failed");
792     }
793 
794     /**
795      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
796      * `errorMessage` as a fallback revert reason when `target` reverts.
797      *
798      * _Available since v3.1._
799      */
800     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
801         return functionCallWithValue(target, data, 0, errorMessage);
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
806      * but also transferring `value` wei to `target`.
807      *
808      * Requirements:
809      *
810      * - the calling contract must have an ETH balance of at least `value`.
811      * - the called Solidity function must be `payable`.
812      *
813      * _Available since v3.1._
814      */
815     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
816         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
821      * with `errorMessage` as a fallback revert reason when `target` reverts.
822      *
823      * _Available since v3.1._
824      */
825     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
826         require(address(this).balance >= value, "Address: insufficient balance for call");
827         require(isContract(target), "Address: call to non-contract");
828 
829         // solhint-disable-next-line avoid-low-level-calls
830         (bool success, bytes memory returndata) = target.call{ value: value }(data);
831         return _verifyCallResult(success, returndata, errorMessage);
832     }
833 
834     /**
835      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
836      * but performing a static call.
837      *
838      * _Available since v3.3._
839      */
840     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
841         return functionStaticCall(target, data, "Address: low-level static call failed");
842     }
843 
844     /**
845      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
846      * but performing a static call.
847      *
848      * _Available since v3.3._
849      */
850     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
851         require(isContract(target), "Address: static call to non-contract");
852 
853         // solhint-disable-next-line avoid-low-level-calls
854         (bool success, bytes memory returndata) = target.staticcall(data);
855         return _verifyCallResult(success, returndata, errorMessage);
856     }
857 
858     /**
859      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
860      * but performing a delegate call.
861      *
862      * _Available since v3.4._
863      */
864     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
865         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
866     }
867 
868     /**
869      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
870      * but performing a delegate call.
871      *
872      * _Available since v3.4._
873      */
874     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
875         require(isContract(target), "Address: delegate call to non-contract");
876 
877         // solhint-disable-next-line avoid-low-level-calls
878         (bool success, bytes memory returndata) = target.delegatecall(data);
879         return _verifyCallResult(success, returndata, errorMessage);
880     }
881 
882     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
883         if (success) {
884             return returndata;
885         } else {
886             // Look for revert reason and bubble it up if present
887             if (returndata.length > 0) {
888                 // The easiest way to bubble the revert reason is using memory via assembly
889 
890                 // solhint-disable-next-line no-inline-assembly
891                 assembly {
892                     let returndata_size := mload(returndata)
893                     revert(add(32, returndata), returndata_size)
894                 }
895             } else {
896                 revert(errorMessage);
897             }
898         }
899     }
900 }
901 
902 
903 // File: @openzeppelin/contracts/math/SafeMath.sol
904 
905 pragma solidity >=0.6.0 <0.8.0;
906 
907 /**
908  * @dev Wrappers over Solidity's arithmetic operations with added overflow
909  * checks.
910  *
911  * Arithmetic operations in Solidity wrap on overflow. This can easily result
912  * in bugs, because programmers usually assume that an overflow raises an
913  * error, which is the standard behavior in high level programming languages.
914  * `SafeMath` restores this intuition by reverting the transaction when an
915  * operation overflows.
916  *
917  * Using this library instead of the unchecked operations eliminates an entire
918  * class of bugs, so it's recommended to use it always.
919  */
920 library SafeMath {
921     /**
922      * @dev Returns the addition of two unsigned integers, with an overflow flag.
923      *
924      * _Available since v3.4._
925      */
926     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
927         uint256 c = a + b;
928         if (c < a) return (false, 0);
929         return (true, c);
930     }
931 
932     /**
933      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
934      *
935      * _Available since v3.4._
936      */
937     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
938         if (b > a) return (false, 0);
939         return (true, a - b);
940     }
941 
942     /**
943      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
944      *
945      * _Available since v3.4._
946      */
947     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
948         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
949         // benefit is lost if 'b' is also tested.
950         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
951         if (a == 0) return (true, 0);
952         uint256 c = a * b;
953         if (c / a != b) return (false, 0);
954         return (true, c);
955     }
956 
957     /**
958      * @dev Returns the division of two unsigned integers, with a division by zero flag.
959      *
960      * _Available since v3.4._
961      */
962     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
963         if (b == 0) return (false, 0);
964         return (true, a / b);
965     }
966 
967     /**
968      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
969      *
970      * _Available since v3.4._
971      */
972     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
973         if (b == 0) return (false, 0);
974         return (true, a % b);
975     }
976 
977     /**
978      * @dev Returns the addition of two unsigned integers, reverting on
979      * overflow.
980      *
981      * Counterpart to Solidity's `+` operator.
982      *
983      * Requirements:
984      *
985      * - Addition cannot overflow.
986      */
987     function add(uint256 a, uint256 b) internal pure returns (uint256) {
988         uint256 c = a + b;
989         require(c >= a, "SafeMath: addition overflow");
990         return c;
991     }
992 
993     /**
994      * @dev Returns the subtraction of two unsigned integers, reverting on
995      * overflow (when the result is negative).
996      *
997      * Counterpart to Solidity's `-` operator.
998      *
999      * Requirements:
1000      *
1001      * - Subtraction cannot overflow.
1002      */
1003     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1004         require(b <= a, "SafeMath: subtraction overflow");
1005         return a - b;
1006     }
1007 
1008     /**
1009      * @dev Returns the multiplication of two unsigned integers, reverting on
1010      * overflow.
1011      *
1012      * Counterpart to Solidity's `*` operator.
1013      *
1014      * Requirements:
1015      *
1016      * - Multiplication cannot overflow.
1017      */
1018     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1019         if (a == 0) return 0;
1020         uint256 c = a * b;
1021         require(c / a == b, "SafeMath: multiplication overflow");
1022         return c;
1023     }
1024 
1025     /**
1026      * @dev Returns the integer division of two unsigned integers, reverting on
1027      * division by zero. The result is rounded towards zero.
1028      *
1029      * Counterpart to Solidity's `/` operator. Note: this function uses a
1030      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1031      * uses an invalid opcode to revert (consuming all remaining gas).
1032      *
1033      * Requirements:
1034      *
1035      * - The divisor cannot be zero.
1036      */
1037     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1038         require(b > 0, "SafeMath: division by zero");
1039         return a / b;
1040     }
1041 
1042     /**
1043      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1044      * reverting when dividing by zero.
1045      *
1046      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1047      * opcode (which leaves remaining gas untouched) while Solidity uses an
1048      * invalid opcode to revert (consuming all remaining gas).
1049      *
1050      * Requirements:
1051      *
1052      * - The divisor cannot be zero.
1053      */
1054     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1055         require(b > 0, "SafeMath: modulo by zero");
1056         return a % b;
1057     }
1058 
1059     /**
1060      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1061      * overflow (when the result is negative).
1062      *
1063      * CAUTION: This function is deprecated because it requires allocating memory for the error
1064      * message unnecessarily. For custom revert reasons use {trySub}.
1065      *
1066      * Counterpart to Solidity's `-` operator.
1067      *
1068      * Requirements:
1069      *
1070      * - Subtraction cannot overflow.
1071      */
1072     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1073         require(b <= a, errorMessage);
1074         return a - b;
1075     }
1076 
1077     /**
1078      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1079      * division by zero. The result is rounded towards zero.
1080      *
1081      * CAUTION: This function is deprecated because it requires allocating memory for the error
1082      * message unnecessarily. For custom revert reasons use {tryDiv}.
1083      *
1084      * Counterpart to Solidity's `/` operator. Note: this function uses a
1085      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1086      * uses an invalid opcode to revert (consuming all remaining gas).
1087      *
1088      * Requirements:
1089      *
1090      * - The divisor cannot be zero.
1091      */
1092     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1093         require(b > 0, errorMessage);
1094         return a / b;
1095     }
1096 
1097     /**
1098      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1099      * reverting with custom message when dividing by zero.
1100      *
1101      * CAUTION: This function is deprecated because it requires allocating memory for the error
1102      * message unnecessarily. For custom revert reasons use {tryMod}.
1103      *
1104      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1105      * opcode (which leaves remaining gas untouched) while Solidity uses an
1106      * invalid opcode to revert (consuming all remaining gas).
1107      *
1108      * Requirements:
1109      *
1110      * - The divisor cannot be zero.
1111      */
1112     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1113         require(b > 0, errorMessage);
1114         return a % b;
1115     }
1116 }
1117 
1118 
1119 // File: @openzeppelin/contracts/introspection/IERC165.sol
1120 
1121 pragma solidity >=0.6.0 <0.8.0;
1122 
1123 /**
1124  * @dev Interface of the ERC165 standard, as defined in the
1125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1126  *
1127  * Implementers can declare support of contract interfaces, which can then be
1128  * queried by others ({ERC165Checker}).
1129  *
1130  * For an implementation, see {ERC165}.
1131  */
1132 interface IERC165 {
1133     /**
1134      * @dev Returns true if this contract implements the interface defined by
1135      * `interfaceId`. See the corresponding
1136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1137      * to learn more about how these ids are created.
1138      *
1139      * This function call must use less than 30 000 gas.
1140      */
1141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1142 }
1143 
1144 
1145 // File: @openzeppelin/contracts/introspection/ERC165.sol
1146 
1147 pragma solidity >=0.6.0 <0.8.0;
1148 
1149 /**
1150  * @dev Implementation of the {IERC165} interface.
1151  *
1152  * Contracts may inherit from this and call {_registerInterface} to declare
1153  * their support of an interface.
1154  */
1155 abstract contract ERC165 is IERC165 {
1156     /*
1157      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1158      */
1159     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1160 
1161     /**
1162      * @dev Mapping of interface ids to whether or not it's supported.
1163      */
1164     mapping(bytes4 => bool) private _supportedInterfaces;
1165 
1166     constructor () internal {
1167         // Derived contracts need only register support for their own interfaces,
1168         // we register support for ERC165 itself here
1169         _registerInterface(_INTERFACE_ID_ERC165);
1170     }
1171 
1172     /**
1173      * @dev See {IERC165-supportsInterface}.
1174      *
1175      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1176      */
1177     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1178         return _supportedInterfaces[interfaceId];
1179     }
1180 
1181     /**
1182      * @dev Registers the contract as an implementer of the interface defined by
1183      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1184      * registering its interface id is not required.
1185      *
1186      * See {IERC165-supportsInterface}.
1187      *
1188      * Requirements:
1189      *
1190      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1191      */
1192     function _registerInterface(bytes4 interfaceId) internal virtual {
1193         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1194         _supportedInterfaces[interfaceId] = true;
1195     }
1196 }
1197 
1198 
1199 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1200 
1201 pragma solidity >=0.6.0 <0.8.0;
1202 
1203 /**
1204  * @title ERC721 token receiver interface
1205  * @dev Interface for any contract that wants to support safeTransfers
1206  * from ERC721 asset contracts.
1207  */
1208 interface IERC721Receiver {
1209     /**
1210      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1211      * by `operator` from `from`, this function is called.
1212      *
1213      * It must return its Solidity selector to confirm the token transfer.
1214      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1215      *
1216      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1217      */
1218     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1219 }
1220 
1221 
1222 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1223 
1224 pragma solidity >=0.6.2 <0.8.0;
1225 
1226 /**
1227  * @dev Required interface of an ERC721 compliant contract.
1228  */
1229 interface IERC721 is IERC165 {
1230     /**
1231      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1232      */
1233     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1234 
1235     /**
1236      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1237      */
1238     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1239 
1240     /**
1241      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1242      */
1243     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1244 
1245     /**
1246      * @dev Returns the number of tokens in ``owner``'s account.
1247      */
1248     function balanceOf(address owner) external view returns (uint256 balance);
1249 
1250     /**
1251      * @dev Returns the owner of the `tokenId` token.
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must exist.
1256      */
1257     function ownerOf(uint256 tokenId) external view returns (address owner);
1258 
1259     /**
1260      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1261      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1262      *
1263      * Requirements:
1264      *
1265      * - `from` cannot be the zero address.
1266      * - `to` cannot be the zero address.
1267      * - `tokenId` token must exist and be owned by `from`.
1268      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1274 
1275     /**
1276      * @dev Transfers `tokenId` token from `from` to `to`.
1277      *
1278      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1279      *
1280      * Requirements:
1281      *
1282      * - `from` cannot be the zero address.
1283      * - `to` cannot be the zero address.
1284      * - `tokenId` token must be owned by `from`.
1285      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function transferFrom(address from, address to, uint256 tokenId) external;
1290 
1291     /**
1292      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1293      * The approval is cleared when the token is transferred.
1294      *
1295      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1296      *
1297      * Requirements:
1298      *
1299      * - The caller must own the token or be an approved operator.
1300      * - `tokenId` must exist.
1301      *
1302      * Emits an {Approval} event.
1303      */
1304     function approve(address to, uint256 tokenId) external;
1305 
1306     /**
1307      * @dev Returns the account approved for `tokenId` token.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      */
1313     function getApproved(uint256 tokenId) external view returns (address operator);
1314 
1315     /**
1316      * @dev Approve or remove `operator` as an operator for the caller.
1317      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1318      *
1319      * Requirements:
1320      *
1321      * - The `operator` cannot be the caller.
1322      *
1323      * Emits an {ApprovalForAll} event.
1324      */
1325     function setApprovalForAll(address operator, bool _approved) external;
1326 
1327     /**
1328      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1329      *
1330      * See {setApprovalForAll}
1331      */
1332     function isApprovedForAll(address owner, address operator) external view returns (bool);
1333 
1334     /**
1335       * @dev Safely transfers `tokenId` token from `from` to `to`.
1336       *
1337       * Requirements:
1338       *
1339       * - `from` cannot be the zero address.
1340       * - `to` cannot be the zero address.
1341       * - `tokenId` token must exist and be owned by `from`.
1342       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1343       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1344       *
1345       * Emits a {Transfer} event.
1346       */
1347     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1348 }
1349 
1350 
1351 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
1352 
1353 pragma solidity >=0.6.2 <0.8.0;
1354 
1355 /**
1356  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1357  * @dev See https://eips.ethereum.org/EIPS/eip-721
1358  */
1359 interface IERC721Enumerable is IERC721 {
1360 
1361     /**
1362      * @dev Returns the total amount of tokens stored by the contract.
1363      */
1364     function totalSupply() external view returns (uint256);
1365 
1366     /**
1367      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1368      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1369      */
1370     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1371 
1372     /**
1373      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1374      * Use along with {totalSupply} to enumerate all tokens.
1375      */
1376     function tokenByIndex(uint256 index) external view returns (uint256);
1377 }
1378 
1379 
1380 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1381 
1382 pragma solidity >=0.6.2 <0.8.0;
1383 
1384 /**
1385  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1386  * @dev See https://eips.ethereum.org/EIPS/eip-721
1387  */
1388 interface IERC721Metadata is IERC721 {
1389 
1390     /**
1391      * @dev Returns the token collection name.
1392      */
1393     function name() external view returns (string memory);
1394 
1395     /**
1396      * @dev Returns the token collection symbol.
1397      */
1398     function symbol() external view returns (string memory);
1399 
1400     /**
1401      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1402      */
1403     function tokenURI(uint256 tokenId) external view returns (string memory);
1404 }
1405 
1406 
1407 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1408 
1409 pragma solidity >=0.6.0 <0.8.0;
1410 
1411 /**
1412  * @title ERC721 Non-Fungible Token Standard basic implementation
1413  * @dev see https://eips.ethereum.org/EIPS/eip-721
1414  */
1415 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1416     using SafeMath for uint256;
1417     using Address for address;
1418     using EnumerableSet for EnumerableSet.UintSet;
1419     using EnumerableMap for EnumerableMap.UintToAddressMap;
1420     using Strings for uint256;
1421 
1422     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1423     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1424     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1425 
1426     // Mapping from holder address to their (enumerable) set of owned tokens
1427     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1428 
1429     // Enumerable mapping from token ids to their owners
1430     EnumerableMap.UintToAddressMap private _tokenOwners;
1431 
1432     // Mapping from token ID to approved address
1433     mapping (uint256 => address) private _tokenApprovals;
1434 
1435     // Mapping from owner to operator approvals
1436     mapping (address => mapping (address => bool)) private _operatorApprovals;
1437 
1438     // Token name
1439     string private _name;
1440 
1441     // Token symbol
1442     string private _symbol;
1443 
1444     // Optional mapping for token URIs
1445     mapping (uint256 => string) private _tokenURIs;
1446 
1447     // Base URI
1448     string private _baseURI;
1449 
1450     /*
1451      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1452      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1453      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1454      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1455      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1456      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1457      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1458      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1459      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1460      *
1461      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1462      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1463      */
1464     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1465 
1466     /*
1467      *     bytes4(keccak256('name()')) == 0x06fdde03
1468      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1469      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1470      *
1471      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1472      */
1473     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1474 
1475     /*
1476      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1477      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1478      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1479      *
1480      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1481      */
1482     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1483 
1484     /**
1485      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1486      */
1487     constructor (string memory name_, string memory symbol_) public {
1488         _name = name_;
1489         _symbol = symbol_;
1490 
1491         // register the supported interfaces to conform to ERC721 via ERC165
1492         _registerInterface(_INTERFACE_ID_ERC721);
1493         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1494         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1495     }
1496 
1497     /**
1498      * @dev See {IERC721-balanceOf}.
1499      */
1500     function balanceOf(address owner) public view virtual override returns (uint256) {
1501         require(owner != address(0), "ERC721: balance query for the zero address");
1502         return _holderTokens[owner].length();
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-ownerOf}.
1507      */
1508     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1509         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1510     }
1511 
1512     /**
1513      * @dev See {IERC721Metadata-name}.
1514      */
1515     function name() public view virtual override returns (string memory) {
1516         return _name;
1517     }
1518 
1519     /**
1520      * @dev See {IERC721Metadata-symbol}.
1521      */
1522     function symbol() public view virtual override returns (string memory) {
1523         return _symbol;
1524     }
1525 
1526     /**
1527      * @dev See {IERC721Metadata-tokenURI}.
1528      */
1529     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1530         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1531 
1532         string memory _tokenURI = _tokenURIs[tokenId];
1533         string memory base = baseURI();
1534 
1535         // If there is no base URI, return the token URI.
1536         if (bytes(base).length == 0) {
1537             return _tokenURI;
1538         }
1539         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1540         if (bytes(_tokenURI).length > 0) {
1541             return string(abi.encodePacked(base, _tokenURI));
1542         }
1543         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1544         return string(abi.encodePacked(base, tokenId.toString()));
1545     }
1546 
1547     /**
1548     * @dev Returns the base URI set via {_setBaseURI}. This will be
1549     * automatically added as a prefix in {tokenURI} to each token's URI, or
1550     * to the token ID if no specific URI is set for that token ID.
1551     */
1552     function baseURI() public view virtual returns (string memory) {
1553         return _baseURI;
1554     }
1555 
1556     /**
1557      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1558      */
1559     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1560         return _holderTokens[owner].at(index);
1561     }
1562 
1563     /**
1564      * @dev See {IERC721Enumerable-totalSupply}.
1565      */
1566     function totalSupply() public view virtual override returns (uint256) {
1567         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1568         return _tokenOwners.length();
1569     }
1570 
1571     /**
1572      * @dev See {IERC721Enumerable-tokenByIndex}.
1573      */
1574     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1575         (uint256 tokenId, ) = _tokenOwners.at(index);
1576         return tokenId;
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-approve}.
1581      */
1582     function approve(address to, uint256 tokenId) public virtual override {
1583         address owner = ERC721.ownerOf(tokenId);
1584         require(to != owner, "ERC721: approval to current owner");
1585 
1586         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1587             "ERC721: approve caller is not owner nor approved for all"
1588         );
1589 
1590         _approve(to, tokenId);
1591     }
1592 
1593     /**
1594      * @dev See {IERC721-getApproved}.
1595      */
1596     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1597         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1598 
1599         return _tokenApprovals[tokenId];
1600     }
1601 
1602     /**
1603      * @dev See {IERC721-setApprovalForAll}.
1604      */
1605     function setApprovalForAll(address operator, bool approved) public virtual override {
1606         require(operator != _msgSender(), "ERC721: approve to caller");
1607 
1608         _operatorApprovals[_msgSender()][operator] = approved;
1609         emit ApprovalForAll(_msgSender(), operator, approved);
1610     }
1611 
1612     /**
1613      * @dev See {IERC721-isApprovedForAll}.
1614      */
1615     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1616         return _operatorApprovals[owner][operator];
1617     }
1618 
1619     /**
1620      * @dev See {IERC721-transferFrom}.
1621      */
1622     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1623         //solhint-disable-next-line max-line-length
1624         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1625 
1626         _transfer(from, to, tokenId);
1627     }
1628 
1629     /**
1630      * @dev See {IERC721-safeTransferFrom}.
1631      */
1632     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1633         safeTransferFrom(from, to, tokenId, "");
1634     }
1635 
1636     /**
1637      * @dev See {IERC721-safeTransferFrom}.
1638      */
1639     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1640         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1641         _safeTransfer(from, to, tokenId, _data);
1642     }
1643 
1644     /**
1645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1647      *
1648      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1649      *
1650      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1651      * implement alternative mechanisms to perform token transfer, such as signature-based.
1652      *
1653      * Requirements:
1654      *
1655      * - `from` cannot be the zero address.
1656      * - `to` cannot be the zero address.
1657      * - `tokenId` token must exist and be owned by `from`.
1658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1659      *
1660      * Emits a {Transfer} event.
1661      */
1662     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1663         _transfer(from, to, tokenId);
1664         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1665     }
1666 
1667     /**
1668      * @dev Returns whether `tokenId` exists.
1669      *
1670      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1671      *
1672      * Tokens start existing when they are minted (`_mint`),
1673      * and stop existing when they are burned (`_burn`).
1674      */
1675     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1676         return _tokenOwners.contains(tokenId);
1677     }
1678 
1679     /**
1680      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must exist.
1685      */
1686     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1687         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1688         address owner = ERC721.ownerOf(tokenId);
1689         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1690     }
1691 
1692     /**
1693      * @dev Safely mints `tokenId` and transfers it to `to`.
1694      *
1695      * Requirements:
1696      d*
1697      * - `tokenId` must not exist.
1698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1699      *
1700      * Emits a {Transfer} event.
1701      */
1702     function _safeMint(address to, uint256 tokenId) internal virtual {
1703         _safeMint(to, tokenId, "");
1704     }
1705 
1706     /**
1707      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1708      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1709      */
1710     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1711         _mint(to, tokenId);
1712         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1713     }
1714 
1715     /**
1716      * @dev Mints `tokenId` and transfers it to `to`.
1717      *
1718      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1719      *
1720      * Requirements:
1721      *
1722      * - `tokenId` must not exist.
1723      * - `to` cannot be the zero address.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function _mint(address to, uint256 tokenId) internal virtual {
1728         require(to != address(0), "ERC721: mint to the zero address");
1729         require(!_exists(tokenId), "ERC721: token already minted");
1730 
1731         _beforeTokenTransfer(address(0), to, tokenId);
1732 
1733         _holderTokens[to].add(tokenId);
1734 
1735         _tokenOwners.set(tokenId, to);
1736 
1737         emit Transfer(address(0), to, tokenId);
1738     }
1739 
1740     /**
1741      * @dev Destroys `tokenId`.
1742      * The approval is cleared when the token is burned.
1743      *
1744      * Requirements:
1745      *
1746      * - `tokenId` must exist.
1747      *
1748      * Emits a {Transfer} event.
1749      */
1750     function _burn(uint256 tokenId) internal virtual {
1751         address owner = ERC721.ownerOf(tokenId); // internal owner
1752 
1753         _beforeTokenTransfer(owner, address(0), tokenId);
1754 
1755         // Clear approvals
1756         _approve(address(0), tokenId);
1757 
1758         // Clear metadata (if any)
1759         if (bytes(_tokenURIs[tokenId]).length != 0) {
1760             delete _tokenURIs[tokenId];
1761         }
1762 
1763         _holderTokens[owner].remove(tokenId);
1764 
1765         _tokenOwners.remove(tokenId);
1766 
1767         emit Transfer(owner, address(0), tokenId);
1768     }
1769 
1770     /**
1771      * @dev Transfers `tokenId` from `from` to `to`.
1772      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1773      *
1774      * Requirements:
1775      *
1776      * - `to` cannot be the zero address.
1777      * - `tokenId` token must be owned by `from`.
1778      *
1779      * Emits a {Transfer} event.
1780      */
1781     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1782         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1783         require(to != address(0), "ERC721: transfer to the zero address");
1784 
1785         _beforeTokenTransfer(from, to, tokenId);
1786 
1787         // Clear approvals from the previous owner
1788         _approve(address(0), tokenId);
1789 
1790         _holderTokens[from].remove(tokenId);
1791         _holderTokens[to].add(tokenId);
1792 
1793         _tokenOwners.set(tokenId, to);
1794 
1795         emit Transfer(from, to, tokenId);
1796     }
1797 
1798     /**
1799      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1800      *
1801      * Requirements:
1802      *
1803      * - `tokenId` must exist.
1804      */
1805     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1806         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1807         _tokenURIs[tokenId] = _tokenURI;
1808     }
1809 
1810     /**
1811      * @dev Internal function to set the base URI for all token IDs. It is
1812      * automatically added as a prefix to the value returned in {tokenURI},
1813      * or to the token ID if {tokenURI} is empty.
1814      */
1815     function _setBaseURI(string memory baseURI_) internal virtual {
1816         _baseURI = baseURI_;
1817     }
1818 
1819     /**
1820      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1821      * The call is not executed if the target address is not a contract.
1822      *
1823      * @param from address representing the previous owner of the given token ID
1824      * @param to target address that will receive the tokens
1825      * @param tokenId uint256 ID of the token to be transferred
1826      * @param _data bytes optional data to send along with the call
1827      * @return bool whether the call correctly returned the expected magic value
1828      */
1829     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1830         private returns (bool)
1831     {
1832         if (!to.isContract()) {
1833             return true;
1834         }
1835         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1836             IERC721Receiver(to).onERC721Received.selector,
1837             _msgSender(),
1838             from,
1839             tokenId,
1840             _data
1841         ), "ERC721: transfer to non ERC721Receiver implementer");
1842         bytes4 retval = abi.decode(returndata, (bytes4));
1843         return (retval == _ERC721_RECEIVED);
1844     }
1845 
1846     /**
1847      * @dev Approve `to` to operate on `tokenId`
1848      *
1849      * Emits an {Approval} event.
1850      */
1851     function _approve(address to, uint256 tokenId) internal virtual {
1852         _tokenApprovals[tokenId] = to;
1853         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1854     }
1855 
1856     /**
1857      * @dev Hook that is called before any token transfer. This includes minting
1858      * and burning.
1859      *
1860      * Calling conditions:
1861      *
1862      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1863      * transferred to `to`.
1864      * - When `from` is zero, `tokenId` will be minted for `to`.
1865      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1866      * - `from` cannot be the zero address.
1867      * - `to` cannot be the zero address.
1868      *
1869      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1870      */
1871     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1872 }
1873 
1874 
1875 /**
1876  * @title MonsterMash contract
1877  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1878  */
1879 contract MonsterMash is ERC721, Ownable {
1880     using SafeMath for uint256;
1881     uint256 public constant MAX_Supply = 10000;
1882     uint256 private scopeIndex = 0;
1883     uint256 public price = 80000000000000000; // 0.08 Eth
1884     uint256 public reservedTokens = 0; // reserve tokens go here
1885     uint256 public mintedPresaleTokens = 0;
1886     bool public flagreserve = false;
1887 
1888     bool public hasSaleStarted = false;
1889     bool public hasPresaleStarted = false;
1890 
1891     mapping(uint256 => uint256) swappedIDs;
1892     
1893     mapping(address => uint256) userCredit;
1894    
1895    // Whitelisting
1896    uint256 public allowListMaxMint = 5;
1897    uint256 public allowListMaxReserve = 50;
1898     
1899     mapping(address => bool) private _allowList;
1900     mapping(address => uint256) private _allowListClaimed;
1901     
1902 
1903     constructor(string memory baseURI) ERC721("MonsterMash","MM")  {
1904         setBaseURI(baseURI);
1905     }
1906     
1907     //   WHITELIST FNS
1908     
1909     function addToAllowList(address[] calldata addresses) external  onlyOwner {
1910       for (uint256 i = 0; i < addresses.length; i++) {
1911       require(addresses[i] != address(0), "Can't add the null address");
1912 
1913       _allowList[addresses[i]] = true;
1914       /**
1915       * @dev We don't want to reset _allowListClaimed count
1916       * if we try to add someone more than once.
1917       */
1918       _allowListClaimed[addresses[i]] > 0 ? _allowListClaimed[addresses[i]] : 0;
1919     }
1920   }
1921 
1922   function onAllowList(address addr) external view  returns (bool) {
1923     return _allowList[addr];
1924   }
1925 
1926   function removeFromAllowList(address[] calldata addresses) external  onlyOwner {
1927     for (uint256 i = 0; i < addresses.length; i++) {
1928       require(addresses[i] != address(0), "Can't add the null address");
1929 
1930       /// @dev We don't want to reset possible _allowListClaimed numbers.
1931       _allowList[addresses[i]] = false;
1932     }
1933   }
1934 
1935   /**
1936   * @dev We want to be able to distinguish tokens bought during isAllowListActive
1937   * and tokens bought outside of isAllowListActive
1938   */
1939   function allowListClaimedBy(address owner) external view  returns (uint256){
1940     require(owner != address(0), 'Zero address not on Allow List');
1941 
1942     return _allowListClaimed[owner];
1943   }
1944   
1945   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1946 
1947     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1948         uint256 tokenCount = balanceOf(_owner);
1949         if (tokenCount == 0) {
1950             
1951             return new uint256[](0);
1952         } else {
1953             uint256[] memory result = new uint256[](tokenCount);
1954             uint256 index;
1955             for (index = 0; index < tokenCount; index++) {
1956                 result[index] = tokenOfOwnerByIndex(_owner, index);
1957             }
1958             return result;
1959         }
1960     }
1961 
1962     function genID() private returns(uint256) {
1963         uint256 scope = MAX_Supply-scopeIndex;
1964         uint256 swap;
1965         uint256 result;
1966 
1967         uint256 i = randomNumber() % scope;
1968 
1969         //Setup the value to swap in for the selected ID
1970         if (swappedIDs[scope-1] == 0){
1971             swap = scope-1;
1972         } else {
1973             swap = swappedIDs[scope-1];
1974         }
1975 
1976         //Select a random ID, swap it out with an unselected one then shorten the selection range by 1
1977         if (swappedIDs[i] == 0){
1978             result = i;
1979             swappedIDs[i] = swap;
1980         } else {
1981             result = swappedIDs[i];
1982             swappedIDs[i] = swap;
1983         }
1984         return result+1;
1985     }
1986 
1987     
1988     function randomNumber() private view returns(uint256){
1989         return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
1990     }
1991 
1992     function mint(uint256 numberOfTokens) public payable  {
1993         require(hasSaleStarted == true, "Sale hasn't started");
1994         require(numberOfTokens <= 20, "Can only mint 20 tokens at a time");
1995         require(totalSupply().add(numberOfTokens) <= MAX_Supply, "Exceeds MAX_Supply");
1996         require(price.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1997         
1998         
1999         for (uint i = 0; i < numberOfTokens; i++) {
2000             _safeMint(msg.sender, genID());
2001             scopeIndex++;
2002         }
2003     }
2004     
2005     // whitelist Mint function
2006     
2007     function mintWhitelist(uint256 numberOfTokens) public payable {
2008         require(hasPresaleStarted == true, "Presale hasn't started");
2009         require(totalSupply().add(numberOfTokens) <= MAX_Supply, "Exceeds MAX_Supply");
2010         require(price.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2011         require(_allowList[msg.sender], 'You are not on the White List');
2012         require(numberOfTokens <= allowListMaxMint, 'Cannot purchase this many tokens');
2013         require(mintedPresaleTokens + numberOfTokens <= 4000, 'Total Purchase exceeds max allowed');
2014         
2015         for (uint i = 0; i < numberOfTokens; i++) {
2016             _allowListClaimed[msg.sender] += 1;
2017             _safeMint(msg.sender, genID());
2018             scopeIndex++;
2019             mintedPresaleTokens++;
2020         }
2021     }
2022     
2023     // Mint Reserved tokens
2024     
2025     function mintReservedTokens(address user) external  onlyOwner  {
2026       
2027         require(flagreserve == false, 'Reserved Allocated tokens');
2028         
2029         for (uint i = 0; i < 50; i++) {
2030             _safeMint(user, genID());
2031             scopeIndex++;
2032            
2033         }
2034         flagreserve =true;
2035     }
2036     
2037     function getScopeIndex() public view returns(uint256) {
2038         return scopeIndex;
2039     }
2040     
2041     function mintCredit() public {
2042         require(hasSaleStarted == true, "Sale hasn't started");
2043         require(totalSupply().add(1) <= MAX_Supply, "Exceeds MAX_Supply");
2044         require(userCredit[msg.sender] >= 1, "No Credits");
2045 
2046         _safeMint(msg.sender, genID());
2047         scopeIndex++;
2048         userCredit[msg.sender] -= 1;
2049     }
2050 
2051     function balanceOfCredit(address owner) public view virtual returns (uint256) {
2052         require(owner != address(0), "ERC721: balance query for the zero address");
2053         return userCredit[owner];
2054     }
2055 
2056     // Owner Functions
2057 
2058     function setBaseURI(string memory baseURI) public onlyOwner {
2059         _setBaseURI(baseURI);
2060     }
2061 
2062     function startSale() public onlyOwner {
2063         hasSaleStarted = true;
2064     }
2065     
2066     function pauseSale() public onlyOwner {
2067         hasSaleStarted = false;
2068     }
2069     
2070     function startPresale() public onlyOwner {
2071         hasPresaleStarted = true;
2072     }
2073     
2074     function pausePresale() public onlyOwner {
2075         hasPresaleStarted = false;
2076     }
2077 
2078     function withdrawAll() public onlyOwner {
2079         msg.sender.transfer(address(this).balance);
2080     }
2081     
2082     function addCredit(address owner, uint256 credits) public onlyOwner {
2083         userCredit[owner] += credits;
2084     }
2085 }