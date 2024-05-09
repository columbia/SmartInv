1 // SPDX-License-Identifier: CONSTANTLY WANTS TO MAKE THE WORLD BEAUTIFUL
2 
3 // ///..//*..//..//,..////////#,,,,,,,,,,,,,,,,,&&&&&,**(*./,///*%(.%,,%*,#%/%#(///
4 // *#%%%%%%%%%%/%/////*&@@(*#(#,,,,,,,,,,,,,,,,,@@@@@/***,./,///%./%#(%.#%/.(.*////
5 // *******%%%%(/(/(/(/******#(#,,,,,,,,,,,,,,,,,********((#((@%%.........%@@@@@@@@@
6 // #############%%%%%%%%%%%%%,,,,,,,,,,,,,,,,,**,*,/.**,,///////####%####,.///,*%*,
7 // .*,%,%./%#%(./,(,(*#*#*#*,,,**.,,,********//(****//(#((#(@@@@@*@@@@@&&&&&***&&&&
8 // /.%((%,*#&%% %.%%#&@&&&.%,*#*,,,.*,,******,,,,,,,,,##,....,,,,*,,,,,,,,,,%*%,,&&
9 
10 //  █████╗ ██████╗ ████████╗ ██████╗ ██╗     ██╗██╗  ██╗██╗  ██╗██╗  ██╗
11 // ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝ ██║     ██║╚██╗██╔╝╚██╗██╔╝╚██╗██╔╝
12 // ███████║██████╔╝   ██║   ██║  ███╗██║     ██║ ╚███╔╝  ╚███╔╝  ╚███╔╝ 
13 // ██╔══██║██╔══██╗   ██║   ██║   ██║██║     ██║ ██╔██╗  ██╔██╗  ██╔██╗ 
14 // ██║  ██║██║  ██║   ██║   ╚██████╔╝███████╗██║██╔╝ ██╗██╔╝ ██╗██╔╝ ██╗
15 // ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
16                                                                      
17 //  ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗               
18 // ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝               
19 // ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗               
20 // ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║               
21 // ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║               
22 //  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝               
23                                                                                            
24 // ,*//%@@@*%%(##@@@@&&&&&/,,//.(%@@@##%@##########%&**/,,,@@@@@@@@@@&&&&#######***
25 // ,*(/%@@@#*,/**((((((((&/,,/.**,,,,%%/,%%%%%&#%%&&&%%%#,,@@@@@@@@@@&&&&#######///
26 // ,...%@@@@@@@@@,,,,,,,,@/,,@&**,,,,##/,,/%%%&*/(//,/*/(,,@@@@@@@@@@&&&%....../***
27 // ,,,(##########((((&@@@@,,,*&**,,,,,,,,*##/#*//////*,**,,@@@@@@@@@@@@@%(%***%&&#%
28 // ,,,(############,,,,,,,,,,(#/&,,,,,,,,(*,/,(*%%%((%%##@@@@@@@@@@@@@@@&@@@/*#@&#(
29 // ,***/((%##%(//((#((##((((,,/*.%,/%/#*(*(*(#(#///####.,///(////(#./(/////*(#/////                                                                                                                                           
30 
31 // first official GLICPIXXXVER002 on-chain remix project 
32 
33 // by berk aka princesscamel aka guerrilla pimp minion god bastard
34 
35 // @berkozdemir - berkozdemir.com - linktr.ee/0xberk - twitter.com/berkozdemir
36 // https://artglixxx.io/
37 // https://glicpixxx.love/
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev String operations.
43  */
44 library Strings {
45     bytes16 private constant alphabet = "0123456789abcdef";
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
49      */
50     function toString(uint256 value) internal pure returns (string memory) {
51         // Inspired by OraclizeAPI's implementation - MIT licence
52         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
53 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
74      */
75     function toHexString(uint256 value) internal pure returns (string memory) {
76         if (value == 0) {
77             return "0x00";
78         }
79         uint256 temp = value;
80         uint256 length = 0;
81         while (temp != 0) {
82             length++;
83             temp >>= 8;
84         }
85         return toHexString(value, length);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
90      */
91     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
92         bytes memory buffer = new bytes(2 * length + 2);
93         buffer[0] = "0";
94         buffer[1] = "x";
95         for (uint256 i = 2 * length + 1; i > 1; --i) {
96             buffer[i] = alphabet[value & 0xf];
97             value >>= 4;
98         }
99         require(value == 0, "Strings: hex length insufficient");
100         return string(buffer);
101     }
102 
103 }
104 
105 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
106 
107 
108 
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Library for managing an enumerable variant of Solidity's
114  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
115  * type.
116  *
117  * Maps have the following properties:
118  *
119  * - Entries are added, removed, and checked for existence in constant time
120  * (O(1)).
121  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
122  *
123  * ```
124  * contract Example {
125  *     // Add the library methods
126  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
127  *
128  *     // Declare a set state variable
129  *     EnumerableMap.UintToAddressMap private myMap;
130  * }
131  * ```
132  *
133  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
134  * supported.
135  */
136 library EnumerableMap {
137     // To implement this library for multiple types with as little code
138     // repetition as possible, we write it in terms of a generic Map type with
139     // bytes32 keys and values.
140     // The Map implementation uses private functions, and user-facing
141     // implementations (such as Uint256ToAddressMap) are just wrappers around
142     // the underlying Map.
143     // This means that we can only create new EnumerableMaps for types that fit
144     // in bytes32.
145 
146     struct MapEntry {
147         bytes32 _key;
148         bytes32 _value;
149     }
150 
151     struct Map {
152         // Storage of map keys and values
153         MapEntry[] _entries;
154 
155         // Position of the entry defined by a key in the `entries` array, plus 1
156         // because index 0 means a key is not in the map.
157         mapping (bytes32 => uint256) _indexes;
158     }
159 
160     /**
161      * @dev Adds a key-value pair to a map, or updates the value for an existing
162      * key. O(1).
163      *
164      * Returns true if the key was added to the map, that is if it was not
165      * already present.
166      */
167     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
168         // We read and store the key's index to prevent multiple reads from the same storage slot
169         uint256 keyIndex = map._indexes[key];
170 
171         if (keyIndex == 0) { // Equivalent to !contains(map, key)
172             map._entries.push(MapEntry({ _key: key, _value: value }));
173             // The entry is stored at length-1, but we add 1 to all indexes
174             // and use 0 as a sentinel value
175             map._indexes[key] = map._entries.length;
176             return true;
177         } else {
178             map._entries[keyIndex - 1]._value = value;
179             return false;
180         }
181     }
182 
183     /**
184      * @dev Removes a key-value pair from a map. O(1).
185      *
186      * Returns true if the key was removed from the map, that is if it was present.
187      */
188     function _remove(Map storage map, bytes32 key) private returns (bool) {
189         // We read and store the key's index to prevent multiple reads from the same storage slot
190         uint256 keyIndex = map._indexes[key];
191 
192         if (keyIndex != 0) { // Equivalent to contains(map, key)
193             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
194             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
195             // This modifies the order of the array, as noted in {at}.
196 
197             uint256 toDeleteIndex = keyIndex - 1;
198             uint256 lastIndex = map._entries.length - 1;
199 
200             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
201             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
202 
203             MapEntry storage lastEntry = map._entries[lastIndex];
204 
205             // Move the last entry to the index where the entry to delete is
206             map._entries[toDeleteIndex] = lastEntry;
207             // Update the index for the moved entry
208             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
209 
210             // Delete the slot where the moved entry was stored
211             map._entries.pop();
212 
213             // Delete the index for the deleted slot
214             delete map._indexes[key];
215 
216             return true;
217         } else {
218             return false;
219         }
220     }
221 
222     /**
223      * @dev Returns true if the key is in the map. O(1).
224      */
225     function _contains(Map storage map, bytes32 key) private view returns (bool) {
226         return map._indexes[key] != 0;
227     }
228 
229     /**
230      * @dev Returns the number of key-value pairs in the map. O(1).
231      */
232     function _length(Map storage map) private view returns (uint256) {
233         return map._entries.length;
234     }
235 
236    /**
237     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
238     *
239     * Note that there are no guarantees on the ordering of entries inside the
240     * array, and it may change when more entries are added or removed.
241     *
242     * Requirements:
243     *
244     * - `index` must be strictly less than {length}.
245     */
246     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
247         require(map._entries.length > index, "EnumerableMap: index out of bounds");
248 
249         MapEntry storage entry = map._entries[index];
250         return (entry._key, entry._value);
251     }
252 
253     /**
254      * @dev Tries to returns the value associated with `key`.  O(1).
255      * Does not revert if `key` is not in the map.
256      */
257     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
258         uint256 keyIndex = map._indexes[key];
259         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
260         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
261     }
262 
263     /**
264      * @dev Returns the value associated with `key`.  O(1).
265      *
266      * Requirements:
267      *
268      * - `key` must be in the map.
269      */
270     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
271         uint256 keyIndex = map._indexes[key];
272         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
273         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
274     }
275 
276     /**
277      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
278      *
279      * CAUTION: This function is deprecated because it requires allocating memory for the error
280      * message unnecessarily. For custom revert reasons use {_tryGet}.
281      */
282     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
283         uint256 keyIndex = map._indexes[key];
284         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
285         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
286     }
287 
288     // UintToAddressMap
289 
290     struct UintToAddressMap {
291         Map _inner;
292     }
293 
294     /**
295      * @dev Adds a key-value pair to a map, or updates the value for an existing
296      * key. O(1).
297      *
298      * Returns true if the key was added to the map, that is if it was not
299      * already present.
300      */
301     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
302         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
303     }
304 
305     /**
306      * @dev Removes a value from a set. O(1).
307      *
308      * Returns true if the key was removed from the map, that is if it was present.
309      */
310     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
311         return _remove(map._inner, bytes32(key));
312     }
313 
314     /**
315      * @dev Returns true if the key is in the map. O(1).
316      */
317     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
318         return _contains(map._inner, bytes32(key));
319     }
320 
321     /**
322      * @dev Returns the number of elements in the map. O(1).
323      */
324     function length(UintToAddressMap storage map) internal view returns (uint256) {
325         return _length(map._inner);
326     }
327 
328    /**
329     * @dev Returns the element stored at position `index` in the set. O(1).
330     * Note that there are no guarantees on the ordering of values inside the
331     * array, and it may change when more values are added or removed.
332     *
333     * Requirements:
334     *
335     * - `index` must be strictly less than {length}.
336     */
337     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
338         (bytes32 key, bytes32 value) = _at(map._inner, index);
339         return (uint256(key), address(uint160(uint256(value))));
340     }
341 
342     /**
343      * @dev Tries to returns the value associated with `key`.  O(1).
344      * Does not revert if `key` is not in the map.
345      *
346      * _Available since v3.4._
347      */
348     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
349         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
350         return (success, address(uint160(uint256(value))));
351     }
352 
353     /**
354      * @dev Returns the value associated with `key`.  O(1).
355      *
356      * Requirements:
357      *
358      * - `key` must be in the map.
359      */
360     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
361         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
362     }
363 
364     /**
365      * @dev Same as {get}, with a custom error message when `key` is not in the map.
366      *
367      * CAUTION: This function is deprecated because it requires allocating memory for the error
368      * message unnecessarily. For custom revert reasons use {tryGet}.
369      */
370     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
371         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
372     }
373 }
374 
375 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
376 
377 
378 
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev Library for managing
384  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
385  * types.
386  *
387  * Sets have the following properties:
388  *
389  * - Elements are added, removed, and checked for existence in constant time
390  * (O(1)).
391  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
392  *
393  * ```
394  * contract Example {
395  *     // Add the library methods
396  *     using EnumerableSet for EnumerableSet.AddressSet;
397  *
398  *     // Declare a set state variable
399  *     EnumerableSet.AddressSet private mySet;
400  * }
401  * ```
402  *
403  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
404  * and `uint256` (`UintSet`) are supported.
405  */
406 library EnumerableSet {
407     // To implement this library for multiple types with as little code
408     // repetition as possible, we write it in terms of a generic Set type with
409     // bytes32 values.
410     // The Set implementation uses private functions, and user-facing
411     // implementations (such as AddressSet) are just wrappers around the
412     // underlying Set.
413     // This means that we can only create new EnumerableSets for types that fit
414     // in bytes32.
415 
416     struct Set {
417         // Storage of set values
418         bytes32[] _values;
419 
420         // Position of the value in the `values` array, plus 1 because index 0
421         // means a value is not in the set.
422         mapping (bytes32 => uint256) _indexes;
423     }
424 
425     /**
426      * @dev Add a value to a set. O(1).
427      *
428      * Returns true if the value was added to the set, that is if it was not
429      * already present.
430      */
431     function _add(Set storage set, bytes32 value) private returns (bool) {
432         if (!_contains(set, value)) {
433             set._values.push(value);
434             // The value is stored at length-1, but we add 1 to all indexes
435             // and use 0 as a sentinel value
436             set._indexes[value] = set._values.length;
437             return true;
438         } else {
439             return false;
440         }
441     }
442 
443     /**
444      * @dev Removes a value from a set. O(1).
445      *
446      * Returns true if the value was removed from the set, that is if it was
447      * present.
448      */
449     function _remove(Set storage set, bytes32 value) private returns (bool) {
450         // We read and store the value's index to prevent multiple reads from the same storage slot
451         uint256 valueIndex = set._indexes[value];
452 
453         if (valueIndex != 0) { // Equivalent to contains(set, value)
454             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
455             // the array, and then remove the last element (sometimes called as 'swap and pop').
456             // This modifies the order of the array, as noted in {at}.
457 
458             uint256 toDeleteIndex = valueIndex - 1;
459             uint256 lastIndex = set._values.length - 1;
460 
461             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
462             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
463 
464             bytes32 lastvalue = set._values[lastIndex];
465 
466             // Move the last value to the index where the value to delete is
467             set._values[toDeleteIndex] = lastvalue;
468             // Update the index for the moved value
469             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
470 
471             // Delete the slot where the moved value was stored
472             set._values.pop();
473 
474             // Delete the index for the deleted slot
475             delete set._indexes[value];
476 
477             return true;
478         } else {
479             return false;
480         }
481     }
482 
483     /**
484      * @dev Returns true if the value is in the set. O(1).
485      */
486     function _contains(Set storage set, bytes32 value) private view returns (bool) {
487         return set._indexes[value] != 0;
488     }
489 
490     /**
491      * @dev Returns the number of values on the set. O(1).
492      */
493     function _length(Set storage set) private view returns (uint256) {
494         return set._values.length;
495     }
496 
497    /**
498     * @dev Returns the value stored at position `index` in the set. O(1).
499     *
500     * Note that there are no guarantees on the ordering of values inside the
501     * array, and it may change when more values are added or removed.
502     *
503     * Requirements:
504     *
505     * - `index` must be strictly less than {length}.
506     */
507     function _at(Set storage set, uint256 index) private view returns (bytes32) {
508         require(set._values.length > index, "EnumerableSet: index out of bounds");
509         return set._values[index];
510     }
511 
512     // Bytes32Set
513 
514     struct Bytes32Set {
515         Set _inner;
516     }
517 
518     /**
519      * @dev Add a value to a set. O(1).
520      *
521      * Returns true if the value was added to the set, that is if it was not
522      * already present.
523      */
524     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
525         return _add(set._inner, value);
526     }
527 
528     /**
529      * @dev Removes a value from a set. O(1).
530      *
531      * Returns true if the value was removed from the set, that is if it was
532      * present.
533      */
534     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
535         return _remove(set._inner, value);
536     }
537 
538     /**
539      * @dev Returns true if the value is in the set. O(1).
540      */
541     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
542         return _contains(set._inner, value);
543     }
544 
545     /**
546      * @dev Returns the number of values in the set. O(1).
547      */
548     function length(Bytes32Set storage set) internal view returns (uint256) {
549         return _length(set._inner);
550     }
551 
552    /**
553     * @dev Returns the value stored at position `index` in the set. O(1).
554     *
555     * Note that there are no guarantees on the ordering of values inside the
556     * array, and it may change when more values are added or removed.
557     *
558     * Requirements:
559     *
560     * - `index` must be strictly less than {length}.
561     */
562     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
563         return _at(set._inner, index);
564     }
565 
566     // AddressSet
567 
568     struct AddressSet {
569         Set _inner;
570     }
571 
572     /**
573      * @dev Add a value to a set. O(1).
574      *
575      * Returns true if the value was added to the set, that is if it was not
576      * already present.
577      */
578     function add(AddressSet storage set, address value) internal returns (bool) {
579         return _add(set._inner, bytes32(uint256(uint160(value))));
580     }
581 
582     /**
583      * @dev Removes a value from a set. O(1).
584      *
585      * Returns true if the value was removed from the set, that is if it was
586      * present.
587      */
588     function remove(AddressSet storage set, address value) internal returns (bool) {
589         return _remove(set._inner, bytes32(uint256(uint160(value))));
590     }
591 
592     /**
593      * @dev Returns true if the value is in the set. O(1).
594      */
595     function contains(AddressSet storage set, address value) internal view returns (bool) {
596         return _contains(set._inner, bytes32(uint256(uint160(value))));
597     }
598 
599     /**
600      * @dev Returns the number of values in the set. O(1).
601      */
602     function length(AddressSet storage set) internal view returns (uint256) {
603         return _length(set._inner);
604     }
605 
606    /**
607     * @dev Returns the value stored at position `index` in the set. O(1).
608     *
609     * Note that there are no guarantees on the ordering of values inside the
610     * array, and it may change when more values are added or removed.
611     *
612     * Requirements:
613     *
614     * - `index` must be strictly less than {length}.
615     */
616     function at(AddressSet storage set, uint256 index) internal view returns (address) {
617         return address(uint160(uint256(_at(set._inner, index))));
618     }
619 
620 
621     // UintSet
622 
623     struct UintSet {
624         Set _inner;
625     }
626 
627     /**
628      * @dev Add a value to a set. O(1).
629      *
630      * Returns true if the value was added to the set, that is if it was not
631      * already present.
632      */
633     function add(UintSet storage set, uint256 value) internal returns (bool) {
634         return _add(set._inner, bytes32(value));
635     }
636 
637     /**
638      * @dev Removes a value from a set. O(1).
639      *
640      * Returns true if the value was removed from the set, that is if it was
641      * present.
642      */
643     function remove(UintSet storage set, uint256 value) internal returns (bool) {
644         return _remove(set._inner, bytes32(value));
645     }
646 
647     /**
648      * @dev Returns true if the value is in the set. O(1).
649      */
650     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
651         return _contains(set._inner, bytes32(value));
652     }
653 
654     /**
655      * @dev Returns the number of values on the set. O(1).
656      */
657     function length(UintSet storage set) internal view returns (uint256) {
658         return _length(set._inner);
659     }
660 
661    /**
662     * @dev Returns the value stored at position `index` in the set. O(1).
663     *
664     * Note that there are no guarantees on the ordering of values inside the
665     * array, and it may change when more values are added or removed.
666     *
667     * Requirements:
668     *
669     * - `index` must be strictly less than {length}.
670     */
671     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
672         return uint256(_at(set._inner, index));
673     }
674 }
675 
676 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
677 
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev Collection of functions related to the address type
685  */
686 library Address {
687     /**
688      * @dev Returns true if `account` is a contract.
689      *
690      * [IMPORTANT]
691      * ====
692      * It is unsafe to assume that an address for which this function returns
693      * false is an externally-owned account (EOA) and not a contract.
694      *
695      * Among others, `isContract` will return false for the following
696      * types of addresses:
697      *
698      *  - an externally-owned account
699      *  - a contract in construction
700      *  - an address where a contract will be created
701      *  - an address where a contract lived, but was destroyed
702      * ====
703      */
704     function isContract(address account) internal view returns (bool) {
705         // This method relies on extcodesize, which returns 0 for contracts in
706         // construction, since the code is only stored at the end of the
707         // constructor execution.
708 
709         uint256 size;
710         // solhint-disable-next-line no-inline-assembly
711         assembly { size := extcodesize(account) }
712         return size > 0;
713     }
714 
715     /**
716      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
717      * `recipient`, forwarding all available gas and reverting on errors.
718      *
719      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
720      * of certain opcodes, possibly making contracts go over the 2300 gas limit
721      * imposed by `transfer`, making them unable to receive funds via
722      * `transfer`. {sendValue} removes this limitation.
723      *
724      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
725      *
726      * IMPORTANT: because control is transferred to `recipient`, care must be
727      * taken to not create reentrancy vulnerabilities. Consider using
728      * {ReentrancyGuard} or the
729      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
730      */
731     function sendValue(address payable recipient, uint256 amount) internal {
732         require(address(this).balance >= amount, "Address: insufficient balance");
733 
734         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
735         (bool success, ) = recipient.call{ value: amount }("");
736         require(success, "Address: unable to send value, recipient may have reverted");
737     }
738 
739     /**
740      * @dev Performs a Solidity function call using a low level `call`. A
741      * plain`call` is an unsafe replacement for a function call: use this
742      * function instead.
743      *
744      * If `target` reverts with a revert reason, it is bubbled up by this
745      * function (like regular Solidity function calls).
746      *
747      * Returns the raw returned data. To convert to the expected return value,
748      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
749      *
750      * Requirements:
751      *
752      * - `target` must be a contract.
753      * - calling `target` with `data` must not revert.
754      *
755      * _Available since v3.1._
756      */
757     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
758       return functionCall(target, data, "Address: low-level call failed");
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
763      * `errorMessage` as a fallback revert reason when `target` reverts.
764      *
765      * _Available since v3.1._
766      */
767     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
768         return functionCallWithValue(target, data, 0, errorMessage);
769     }
770 
771     /**
772      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
773      * but also transferring `value` wei to `target`.
774      *
775      * Requirements:
776      *
777      * - the calling contract must have an ETH balance of at least `value`.
778      * - the called Solidity function must be `payable`.
779      *
780      * _Available since v3.1._
781      */
782     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
783         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
788      * with `errorMessage` as a fallback revert reason when `target` reverts.
789      *
790      * _Available since v3.1._
791      */
792     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
793         require(address(this).balance >= value, "Address: insufficient balance for call");
794         require(isContract(target), "Address: call to non-contract");
795 
796         // solhint-disable-next-line avoid-low-level-calls
797         (bool success, bytes memory returndata) = target.call{ value: value }(data);
798         return _verifyCallResult(success, returndata, errorMessage);
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
803      * but performing a static call.
804      *
805      * _Available since v3.3._
806      */
807     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
808         return functionStaticCall(target, data, "Address: low-level static call failed");
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
813      * but performing a static call.
814      *
815      * _Available since v3.3._
816      */
817     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
818         require(isContract(target), "Address: static call to non-contract");
819 
820         // solhint-disable-next-line avoid-low-level-calls
821         (bool success, bytes memory returndata) = target.staticcall(data);
822         return _verifyCallResult(success, returndata, errorMessage);
823     }
824 
825     /**
826      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
827      * but performing a delegate call.
828      *
829      * _Available since v3.4._
830      */
831     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
832         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
837      * but performing a delegate call.
838      *
839      * _Available since v3.4._
840      */
841     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
842         require(isContract(target), "Address: delegate call to non-contract");
843 
844         // solhint-disable-next-line avoid-low-level-calls
845         (bool success, bytes memory returndata) = target.delegatecall(data);
846         return _verifyCallResult(success, returndata, errorMessage);
847     }
848 
849     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
850         if (success) {
851             return returndata;
852         } else {
853             // Look for revert reason and bubble it up if present
854             if (returndata.length > 0) {
855                 // The easiest way to bubble the revert reason is using memory via assembly
856 
857                 // solhint-disable-next-line no-inline-assembly
858                 assembly {
859                     let returndata_size := mload(returndata)
860                     revert(add(32, returndata), returndata_size)
861                 }
862             } else {
863                 revert(errorMessage);
864             }
865         }
866     }
867 }
868 
869 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
870 
871 
872 pragma solidity ^0.8.0;
873 
874 /**
875  * @dev Interface of the ERC165 standard, as defined in the
876  * https://eips.ethereum.org/EIPS/eip-165[EIP].
877  *
878  * Implementers can declare support of contract interfaces, which can then be
879  * queried by others ({ERC165Checker}).
880  *
881  * For an implementation, see {ERC165}.
882  */
883 interface IERC165 {
884     /**
885      * @dev Returns true if this contract implements the interface defined by
886      * `interfaceId`. See the corresponding
887      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
888      * to learn more about how these ids are created.
889      *
890      * This function call must use less than 30 000 gas.
891      */
892     function supportsInterface(bytes4 interfaceId) external view returns (bool);
893 }
894 
895 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
896 
897 
898 pragma solidity ^0.8.0;
899 
900 
901 /**
902  * @dev Implementation of the {IERC165} interface.
903  *
904  * Contracts may inherit from this and call {_registerInterface} to declare
905  * their support of an interface.
906  */
907 abstract contract ERC165 is IERC165 {
908     /**
909      * @dev Mapping of interface ids to whether or not it's supported.
910      */
911     mapping(bytes4 => bool) private _supportedInterfaces;
912 
913     constructor () {
914         // Derived contracts need only register support for their own interfaces,
915         // we register support for ERC165 itself here
916         _registerInterface(type(IERC165).interfaceId);
917     }
918 
919     /**
920      * @dev See {IERC165-supportsInterface}.
921      *
922      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
923      */
924     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
925         return _supportedInterfaces[interfaceId];
926     }
927 
928     /**
929      * @dev Registers the contract as an implementer of the interface defined by
930      * `interfaceId`. Support of the actual ERC165 interface is automatic and
931      * registering its interface id is not required.
932      *
933      * See {IERC165-supportsInterface}.
934      *
935      * Requirements:
936      *
937      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
938      */
939     function _registerInterface(bytes4 interfaceId) internal virtual {
940         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
941         _supportedInterfaces[interfaceId] = true;
942     }
943 }
944 
945 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
946 
947 
948 
949 
950 pragma solidity ^0.8.0;
951 
952 
953 /**
954  * @dev Required interface of an ERC721 compliant contract.
955  */
956 interface IERC721 is IERC165 {
957     /**
958      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
959      */
960     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
961 
962     /**
963      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
964      */
965     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
966 
967     /**
968      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
969      */
970     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
971 
972     /**
973      * @dev Returns the number of tokens in ``owner``'s account.
974      */
975     function balanceOf(address owner) external view returns (uint256 balance);
976 
977     /**
978      * @dev Returns the owner of the `tokenId` token.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function ownerOf(uint256 tokenId) external view returns (address owner);
985 
986     /**
987      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
988      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
989      *
990      * Requirements:
991      *
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must exist and be owned by `from`.
995      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
996      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1001 
1002     /**
1003      * @dev Transfers `tokenId` token from `from` to `to`.
1004      *
1005      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1006      *
1007      * Requirements:
1008      *
1009      * - `from` cannot be the zero address.
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function transferFrom(address from, address to, uint256 tokenId) external;
1017 
1018     /**
1019      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1020      * The approval is cleared when the token is transferred.
1021      *
1022      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1023      *
1024      * Requirements:
1025      *
1026      * - The caller must own the token or be an approved operator.
1027      * - `tokenId` must exist.
1028      *
1029      * Emits an {Approval} event.
1030      */
1031     function approve(address to, uint256 tokenId) external;
1032 
1033     /**
1034      * @dev Returns the account approved for `tokenId` token.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must exist.
1039      */
1040     function getApproved(uint256 tokenId) external view returns (address operator);
1041 
1042     /**
1043      * @dev Approve or remove `operator` as an operator for the caller.
1044      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1045      *
1046      * Requirements:
1047      *
1048      * - The `operator` cannot be the caller.
1049      *
1050      * Emits an {ApprovalForAll} event.
1051      */
1052     function setApprovalForAll(address operator, bool _approved) external;
1053 
1054     /**
1055      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1056      *
1057      * See {setApprovalForAll}
1058      */
1059     function isApprovedForAll(address owner, address operator) external view returns (bool);
1060 
1061     /**
1062       * @dev Safely transfers `tokenId` token from `from` to `to`.
1063       *
1064       * Requirements:
1065       *
1066       * - `from` cannot be the zero address.
1067       * - `to` cannot be the zero address.
1068       * - `tokenId` token must exist and be owned by `from`.
1069       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1070       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071       *
1072       * Emits a {Transfer} event.
1073       */
1074     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1075 }
1076 
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 /**
1081  * @title ERC721 token receiver interface
1082  * @dev Interface for any contract that wants to support safeTransfers
1083  * from ERC721 asset contracts.
1084  */
1085 interface IERC721Receiver {
1086     /**
1087      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1088      * by `operator` from `from`, this function is called.
1089      *
1090      * It must return its Solidity selector to confirm the token transfer.
1091      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1092      *
1093      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1094      */
1095     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1096 }
1097 
1098 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1099 
1100 
1101 
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 
1106 /**
1107  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1108  * @dev See https://eips.ethereum.org/EIPS/eip-721
1109  */
1110 interface IERC721Enumerable is IERC721 {
1111 
1112     /**
1113      * @dev Returns the total amount of tokens stored by the contract.
1114      */
1115     function totalSupply() external view returns (uint256);
1116 
1117     /**
1118      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1119      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1120      */
1121     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1122 
1123     /**
1124      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1125      * Use along with {totalSupply} to enumerate all tokens.
1126      */
1127     function tokenByIndex(uint256 index) external view returns (uint256);
1128 }
1129 
1130 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1131 
1132 
1133 
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 
1138 /**
1139  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1140  * @dev See https://eips.ethereum.org/EIPS/eip-721
1141  */
1142 interface IERC721Metadata is IERC721 {
1143 
1144     /**
1145      * @dev Returns the token collection name.
1146      */
1147     function name() external view returns (string memory);
1148 
1149     /**
1150      * @dev Returns the token collection symbol.
1151      */
1152     function symbol() external view returns (string memory);
1153 
1154     /**
1155      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1156      */
1157     function tokenURI(uint256 tokenId) external view returns (string memory);
1158 }
1159 
1160 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1161 
1162 
1163 
1164 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1165 
1166 
1167 
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 /*
1172  * @dev Provides information about the current execution context, including the
1173  * sender of the transaction and its data. While these are generally available
1174  * via msg.sender and msg.data, they should not be accessed in such a direct
1175  * manner, since when dealing with GSN meta-transactions the account sending and
1176  * paying for execution may not be the actual sender (as far as an application
1177  * is concerned).
1178  *
1179  * This contract is only required for intermediate, library-like contracts.
1180  */
1181 abstract contract Context {
1182     function _msgSender() internal view virtual returns (address) {
1183         return msg.sender;
1184     }
1185 
1186     function _msgData() internal view virtual returns (bytes calldata) {
1187         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1188         return msg.data;
1189     }
1190 }
1191 
1192 
1193 
1194 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1195 
1196 
1197 
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 
1202 /**
1203  * @title ERC721 Non-Fungible Token Standard basic implementation
1204  * @dev see https://eips.ethereum.org/EIPS/eip-721
1205  */
1206 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1207     using Address for address;
1208     using EnumerableSet for EnumerableSet.UintSet;
1209     using EnumerableMap for EnumerableMap.UintToAddressMap;
1210     using Strings for uint256;
1211     
1212     // Mapping from holder address to their (enumerable) set of owned tokens
1213     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1214 
1215     
1216     // Enumerable mapping from token ids to their owners
1217     EnumerableMap.UintToAddressMap private _tokenOwners;
1218 
1219     // Mapping from token ID to approved address
1220     mapping (uint256 => address) private _tokenApprovals;
1221 
1222     // Mapping from owner to operator approvals
1223     mapping (address => mapping (address => bool)) private _operatorApprovals;
1224 
1225     // Token name
1226     string private _name;
1227 
1228     // Token symbol
1229     string private _symbol;
1230 
1231     // Optional mapping for token URIs
1232     mapping (uint256 => string) private _tokenURIs;
1233 
1234     // Base URI
1235     string private _baseURI;
1236 
1237     /**
1238      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1239      */
1240     constructor (string memory name_, string memory symbol_) {
1241         _name = name_;
1242         _symbol = symbol_;
1243 
1244         // register the supported interfaces to conform to ERC721 via ERC165
1245         _registerInterface(type(IERC721).interfaceId);
1246         _registerInterface(type(IERC721Metadata).interfaceId);
1247         _registerInterface(type(IERC721Enumerable).interfaceId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-balanceOf}.
1252      */
1253     function balanceOf(address owner) public view virtual override returns (uint256) {
1254         require(owner != address(0), "ERC721: balance query for the zero address");
1255         return _holderTokens[owner].length();
1256     }
1257     
1258     
1259 
1260     
1261  
1262     
1263     /**
1264      * @dev See {IERC721-ownerOf}.
1265      */
1266     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1267         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Metadata-name}.
1272      */
1273     function name() public view virtual override returns (string memory) {
1274         return _name;
1275     }
1276 
1277     /**
1278      * @dev See {IERC721Metadata-symbol}.
1279      */
1280     function symbol() public view virtual override returns (string memory) {
1281         return _symbol;
1282     }
1283 
1284     /**
1285      * @dev See {IERC721Metadata-tokenURI}.
1286      */
1287     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1288         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1289 
1290         string memory _tokenURI = _tokenURIs[tokenId];
1291         string memory base = baseURI();
1292 
1293         // If there is no base URI, return the token URI.
1294         if (bytes(base).length == 0) {
1295             return _tokenURI;
1296         }
1297         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1298         if (bytes(_tokenURI).length > 0) {
1299             return string(abi.encodePacked(base, _tokenURI));
1300         }
1301         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1302         return string(abi.encodePacked(base, tokenId.toString()));
1303     }
1304 
1305     /**
1306     * @dev Returns the base URI set via {_setBaseURI}. This will be
1307     * automatically added as a prefix in {tokenURI} to each token's URI, or
1308     * to the token ID if no specific URI is set for that token ID.
1309     */
1310     function baseURI() public view virtual returns (string memory) {
1311         return _baseURI;
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1316      */
1317     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1318         return _holderTokens[owner].at(index);
1319     }
1320 
1321     /**
1322      * @dev See {IERC721Enumerable-totalSupply}.
1323      */
1324     function totalSupply() public view virtual override returns (uint256) {
1325         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1326         return _tokenOwners.length();
1327     }
1328 
1329     /**
1330      * @dev See {IERC721Enumerable-tokenByIndex}.
1331      */
1332     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1333         (uint256 tokenId, ) = _tokenOwners.at(index);
1334         return tokenId;
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-approve}.
1339      */
1340     function approve(address to, uint256 tokenId) public virtual override {
1341         address owner = ERC721.ownerOf(tokenId);
1342         require(to != owner, "ERC721: approval to current owner");
1343 
1344         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1345             "ERC721: approve caller is not owner nor approved for all"
1346         );
1347 
1348         _approve(to, tokenId);
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-getApproved}.
1353      */
1354     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1355         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1356 
1357         return _tokenApprovals[tokenId];
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-setApprovalForAll}.
1362      */
1363     function setApprovalForAll(address operator, bool approved) public virtual override {
1364         require(operator != _msgSender(), "ERC721: approve to caller");
1365 
1366         _operatorApprovals[_msgSender()][operator] = approved;
1367         emit ApprovalForAll(_msgSender(), operator, approved);
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-isApprovedForAll}.
1372      */
1373     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1374         return _operatorApprovals[owner][operator];
1375     }
1376 
1377     /**
1378      * @dev See {IERC721-transferFrom}.
1379      */
1380     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1381         //solhint-disable-next-line max-line-length
1382         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1383 
1384         _transfer(from, to, tokenId);
1385     }
1386 
1387     /**
1388      * @dev See {IERC721-safeTransferFrom}.
1389      */
1390     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1391         safeTransferFrom(from, to, tokenId, "");
1392     }
1393 
1394     /**
1395      * @dev See {IERC721-safeTransferFrom}.
1396      */
1397     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1398         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1399         _safeTransfer(from, to, tokenId, _data);
1400     }
1401 
1402     /**
1403      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1404      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1405      *
1406      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1407      *
1408      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1409      * implement alternative mechanisms to perform token transfer, such as signature-based.
1410      *
1411      * Requirements:
1412      *
1413      * - `from` cannot be the zero address.
1414      * - `to` cannot be the zero address.
1415      * - `tokenId` token must exist and be owned by `from`.
1416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1417      *
1418      * Emits a {Transfer} event.
1419      */
1420     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1421         _transfer(from, to, tokenId);
1422         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1423     }
1424 
1425     /**
1426      * @dev Returns whether `tokenId` exists.
1427      *
1428      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1429      *
1430      * Tokens start existing when they are minted (`_mint`),
1431      * and stop existing when they are burned (`_burn`).
1432      */
1433     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1434         return _tokenOwners.contains(tokenId);
1435     }
1436 
1437     /**
1438      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1439      *
1440      * Requirements:
1441      *
1442      * - `tokenId` must exist.
1443      */
1444     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1445         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1446         address owner = ERC721.ownerOf(tokenId);
1447         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1448     }
1449 
1450     /**
1451      * @dev Safely mints `tokenId` and transfers it to `to`.
1452      *
1453      * Requirements:
1454      d*
1455      * - `tokenId` must not exist.
1456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _safeMint(address to, uint256 tokenId) internal virtual {
1461         _safeMint(to, tokenId, "");
1462     }
1463 
1464     /**
1465      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1466      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1467      */
1468     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1469         _mint(to, tokenId);
1470         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1471     }
1472 
1473     /**
1474      * @dev Mints `tokenId` and transfers it to `to`.
1475      *
1476      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1477      *
1478      * Requirements:
1479      *
1480      * - `tokenId` must not exist.
1481      * - `to` cannot be the zero address.
1482      *
1483      * Emits a {Transfer} event.
1484      */
1485     function _mint(address to, uint256 tokenId) internal virtual {
1486         require(to != address(0), "ERC721: mint to the zero address");
1487         require(!_exists(tokenId), "ERC721: token already minted");
1488 
1489         _beforeTokenTransfer(address(0), to, tokenId);
1490 
1491         _holderTokens[to].add(tokenId);
1492 
1493         _tokenOwners.set(tokenId, to);
1494 
1495         emit Transfer(address(0), to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev Destroys `tokenId`.
1500      * The approval is cleared when the token is burned.
1501      *
1502      * Requirements:
1503      *
1504      * - `tokenId` must exist.
1505      *
1506      * Emits a {Transfer} event.
1507      */
1508     function _burn(uint256 tokenId) internal virtual {
1509         address owner = ERC721.ownerOf(tokenId); // internal owner
1510 
1511         _beforeTokenTransfer(owner, address(0), tokenId);
1512 
1513         // Clear approvals
1514         _approve(address(0), tokenId);
1515 
1516         // Clear metadata (if any)
1517         if (bytes(_tokenURIs[tokenId]).length != 0) {
1518             delete _tokenURIs[tokenId];
1519         }
1520 
1521         _holderTokens[owner].remove(tokenId);
1522 
1523         _tokenOwners.remove(tokenId);
1524 
1525         emit Transfer(owner, address(0), tokenId);
1526     }
1527 
1528     /**
1529      * @dev Transfers `tokenId` from `from` to `to`.
1530      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1531      *
1532      * Requirements:
1533      *
1534      * - `to` cannot be the zero address.
1535      * - `tokenId` token must be owned by `from`.
1536      *
1537      * Emits a {Transfer} event.
1538      */
1539     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1540         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1541         require(to != address(0), "ERC721: transfer to the zero address");
1542 
1543         _beforeTokenTransfer(from, to, tokenId);
1544 
1545         // Clear approvals from the previous owner
1546         _approve(address(0), tokenId);
1547 
1548         _holderTokens[from].remove(tokenId);
1549         _holderTokens[to].add(tokenId);
1550 
1551         _tokenOwners.set(tokenId, to);
1552         emit Transfer(from, to, tokenId);
1553     }
1554 
1555     /**
1556      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1557      *
1558      * Requirements:
1559      *
1560      * - `tokenId` must exist.
1561      */
1562     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1563         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1564         _tokenURIs[tokenId] = _tokenURI;
1565     }
1566 
1567     /**
1568      * @dev Internal function to set the base URI for all token IDs. It is
1569      * automatically added as a prefix to the value returned in {tokenURI},
1570      * or to the token ID if {tokenURI} is empty.
1571      */
1572     function _setBaseURI(string memory baseURI_) internal virtual {
1573         _baseURI = baseURI_;
1574     }
1575 
1576     /**
1577      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1578      * The call is not executed if the target address is not a contract.
1579      *
1580      * @param from address representing the previous owner of the given token ID
1581      * @param to target address that will receive the tokens
1582      * @param tokenId uint256 ID of the token to be transferred
1583      * @param _data bytes optional data to send along with the call
1584      * @return bool whether the call correctly returned the expected magic value
1585      */
1586     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1587         private returns (bool)
1588     {
1589         if (to.isContract()) {
1590             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1591                 return retval == IERC721Receiver(to).onERC721Received.selector;
1592             } catch (bytes memory reason) {
1593                 if (reason.length == 0) {
1594                     revert("ERC721: transfer to non ERC721Receiver implementer");
1595                 } else {
1596                     // solhint-disable-next-line no-inline-assembly
1597                     assembly {
1598                         revert(add(32, reason), mload(reason))
1599                     }
1600                 }
1601             }
1602         } else {
1603             return true;
1604         }
1605     }
1606 
1607     function _approve(address to, uint256 tokenId) private {
1608         _tokenApprovals[tokenId] = to;
1609         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1610     }
1611 
1612     /**
1613      * @dev Hook that is called before any token transfer. This includes minting
1614      * and burning.
1615      *
1616      * Calling conditions:
1617      *
1618      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1619      * transferred to `to`.
1620      * - When `from` is zero, `tokenId` will be minted for `to`.
1621      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1622      * - `from` cannot be the zero address.
1623      * - `to` cannot be the zero address.
1624      *
1625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1626      */
1627     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1628 }
1629 
1630 
1631 
1632 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1633 
1634 
1635 
1636 
1637 pragma solidity ^0.8.0;
1638 
1639 /**
1640  * @dev Contract module which provides a basic access control mechanism, where
1641  * there is an account (an owner) that can be granted exclusive access to
1642  * specific functions.
1643  *
1644  * By default, the owner account will be the one that deploys the contract. This
1645  * can later be changed with {transferOwnership}.
1646  *
1647  * This module is used through inheritance. It will make available the modifier
1648  * `onlyOwner`, which can be applied to your functions to restrict their use to
1649  * the owner.
1650  */
1651 abstract contract Ownable is Context {
1652     address private _owner;
1653 
1654     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1655 
1656 
1657 
1658     /**
1659      * @dev Initializes the contract setting the deployer as the initial owner.
1660      */
1661     constructor () {
1662         address msgSender = _msgSender();
1663         _owner = msgSender;
1664         emit OwnershipTransferred(address(0), msgSender);
1665     }
1666 
1667     /**
1668      * @dev Returns the address of the current owner.
1669      */
1670     function owner() public view virtual returns (address) {
1671         return _owner;
1672     }
1673 
1674     /**
1675      * @dev Throws if called by any account other than the owner.
1676      */
1677     modifier onlyOwner() {
1678         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1679         _;
1680     }
1681 
1682     /**
1683      * @dev Leaves the contract without owner. It will not be possible to call
1684      * `onlyOwner` functions anymore. Can only be called by the current owner.
1685      *
1686      * NOTE: Renouncing ownership will leave the contract without an owner,
1687      * thereby removing any functionality that is only available to the owner.
1688      */
1689     function renounceOwnership() public virtual onlyOwner {
1690         emit OwnershipTransferred(_owner, address(0));
1691         _owner = address(0);
1692     }
1693 
1694     /**
1695      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1696      * Can only be called by the current owner.
1697      */
1698     function transferOwnership(address newOwner) public virtual onlyOwner {
1699         require(newOwner != address(0), "Ownable: new owner is the zero address");
1700         emit OwnershipTransferred(_owner, newOwner);
1701         _owner = newOwner;
1702     }
1703 }
1704 
1705 
1706 pragma solidity ^0.8.0;
1707 
1708 /// @title IERC2981Royalties
1709 /// @dev Interface for the ERC2981 - Token Royalty standard
1710 interface IERC2981Royalties {
1711     /// @notice Called with the sale price to determine how much royalty
1712     //          is owed and to whom.
1713     /// @param _tokenId - the NFT asset queried for royalty information
1714     /// @param _value - the sale price of the NFT asset specified by _tokenId
1715     /// @return _receiver - address of who should be sent the royalty payment
1716     /// @return _royaltyAmount - the royalty payment amount for value sale price
1717     function royaltyInfo(uint256 _tokenId, uint256 _value)
1718         external
1719         view
1720         returns (address _receiver, uint256 _royaltyAmount);
1721 }
1722 
1723 pragma solidity ^0.8.0;
1724 
1725 /**
1726  * @dev Interface of GLIXTOKEN.
1727  */
1728 interface IGLIX {
1729     function balanceOf(address account) external view returns (uint256);
1730     function mint(address to, uint256 amount) external returns(bool);
1731     function burn(address from, uint256 amount) external returns(bool);
1732     function minterPermissionCheck(address _address) external view returns(bool);
1733     function burnerPermissionCheck(address _address) external view returns(bool);
1734 }
1735 
1736 pragma solidity ^0.8.0;
1737 
1738 contract ARTGLIXXX is ERC165, IERC2981Royalties, ERC721, Ownable {
1739 
1740     using Strings for uint256;
1741 
1742     uint public constant TOTAL_GLICPIXXX = 11500;
1743     bool public mintOpen;
1744 
1745     mapping (uint256 => uint256) public creationDates;
1746     mapping (uint256 => address) public creators;
1747 
1748     string public GENERATOR_ADDRESS;
1749 
1750     uint public BASE_MINT_PRICE = 100 ether; // 100 GLIX PER GENERATION
1751 
1752     address private GLICPIXXXVER002_ADDRESS = 0x1C60841b70821dcA733c9B1a26dBe1a33338bD43;
1753     address private GLIXTOKEN_ADDRESS = 0x4e09d18baa1dA0b396d1A48803956FAc01c28E88;
1754 
1755     IERC721 GLICPIXXXVER002 = IERC721(GLICPIXXXVER002_ADDRESS);
1756     IGLIX GLIXTOKEN = IGLIX(GLIXTOKEN_ADDRESS);
1757 
1758     mapping(address => uint256) public balanceELDEST;
1759     mapping(uint256 => uint256) public ARTGLIXXX_NEXT_GEN;
1760 
1761     mapping(address => uint256) public GLIXREWARDS;
1762 	mapping(address => uint256) public GLIX_LAST_UPDATE;
1763 
1764     uint public DAILY_YIELD_RATE = 10 ether; // 10 $GLIX PER DAY
1765     uint public YIELD_END = block.timestamp + 315360000; // yield will go on for 10 years
1766 
1767     event RewardPaid(address indexed user, uint256 reward);
1768     event Mint(address indexed user, uint256 tokenId, uint256 Generation);
1769 
1770     // string public script;
1771 
1772     struct ProjectInfo {
1773         uint projectId;
1774         string name;
1775         string description;
1776         string license;
1777         string artist;
1778         string script;
1779         address royaltyReceiver;
1780         uint royaltyAmount;
1781     }
1782 
1783     ProjectInfo public projectInfo;
1784 
1785     constructor() ERC721("ARTGLIXXX GENESIS","ARTGLIXXX")  {
1786 
1787         setBaseURI("https://server.artglixxx.io/api/project/0/token/");
1788         setGeneratorAddress("https://server.artglixxx.io/generate/project/0/token/");
1789 
1790         projectInfo = ProjectInfo(
1791             0,
1792             "ARTGLIXXX GENESIS",
1793             "ARTGLIXXX GENESIS is the first badass on-chain remix collection of GLICPIXXX. Holding mouse on canvas and moving on x-axis changes the frame rate.",
1794             "Your ARTGLIXXX, your call. An ARTGLIXXX comes with full non-commercial/commercial rights.",
1795             "Berk aka Princess Camel aka Guerilla Pimp Minion God Bastard",
1796             "class Random{constructor(e){this.seed=e}random_dec(){return this.seed^=this.seed<<13,this.seed^=this.seed>>17,this.seed^=this.seed<<5,(this.seed<0?1+~this.seed:this.seed)%1e3/1e3}random_between(e,a){return e+(a-e)*this.random_dec()}random_int(e,a){return Math.floor(this.random_between(e,a+1))}random_choice(e){return e[Math.floor(this.random_between(0,.99*e.length))]}random_exp(e,a,n){return floor(map(Math.exp(map(this.random_between(0,999),0,1e3,0,n)),Math.exp(0),Math.exp(n),e,a+1))}}function hue2rgb(e,a,n){return n<0&&(n+=1),n>1&&(n-=1),n<1/6?e+6*(a-e)*n:n<.5?a:n<2/3?e+(a-e)*(2/3-n)*6:e}function changeHue(e,a,n,r){var t=rgbToHSL(e,a,n);return t.h+=r,t.h>360?t.h-=360:t.h<0&&(t.h+=360),hslToRGB(t)}function rgbToHSL(e,a,n){e/=255,a/=255,n/=255;var r=Math.max(e,a,n),t=Math.min(e,a,n),o=r-t,i=(r+t)/2;return{h:0==o?0:r==e?(a-n)/o%6*60:r==a?60*((n-e)/o+2):60*((e-a)/o+4),s:0==o?0:o/(1-Math.abs(2*i-1)),l:i}}function hslToRGB(e){var a,n,r,t=e.h,o=e.s,i=e.l,m=(1-Math.abs(2*i-1))*o,s=m*(1-Math.abs(t/60%2-1)),d=i-m/2;return t<60?(a=m,n=s,r=0):t<120?(a=s,n=m,r=0):t<180?(a=0,n=m,r=s):t<240?(a=0,n=s,r=m):t<300?(a=s,n=0,r=m):(a=m,n=0,r=s),[a=normalize_rgb_value(a,d),n=normalize_rgb_value(n,d),r=normalize_rgb_value(r,d)]}function normalize_rgb_value(e,a){return(e=Math.floor(255*(e+a)))<0&&(e=0),e}function hueShift(e,a){e.loadPixels();for(var n=0;n<e.pixels.length;n+=4){let r=changeHue(e.pixels[n],e.pixels[n+1],e.pixels[n+2],a);e.pixels[n]=r[0],e.pixels[n+1]=r[1],e.pixels[n+2]=r[2]}e.updatePixels()}function componentToHex(e){var a=e.toString(16);return 1==a.length?'0'+a:a}const rgbtohex=(e,a,n)=>'#'+componentToHex(e)+componentToHex(a)+componentToHex(n);let tokenData=window.tokenHash,seed=parseInt(tokenData.slice(0,16),16),rng=new Random(seed);var SIZE;let glicpixxxOrigin=window.glicpixxxOrigin,filenames=window.imagesList.split(',');var images=[];let params={},oncee=!1;function preload(){for(let e in filenames)images.push(loadImage(filenames[e]))}function setup(){params.GRIDS=rng.random_exp(1,16,2),params.DRAW_MODE=rng.random_exp(1,6,2),params.IMAGE_FILTER=rng.random_exp(0,7,2),5!=params.IMAGE_FILTER&&6!=params.IMAGE_FILTER||(params.HUE_DEGREE=rng.random_int(1,360)),params.ROTATE_MODE=rng.random_exp(0,3,1.5),1==params.ROTATE_MODE?params.ROTATE_N=[...new Set(Array.apply(0,new Array(rng.random_int(1,4))).map(e=>rng.random_int(1,45)))]:2!=params.ROTATE_MODE&&3!=params.ROTATE_MODE||(params.ROTATE_N=rng.random_int(1,45)),params.bgcolor=rgbtohex(rng.random_int(0,255),rng.random_int(0,255),rng.random_int(0,255)),SIZE=Math.min(window.innerHeight,window.innerWidth),createCanvas(SIZE,SIZE),background(params.bgcolor)}function draw(){noSmooth(),mouseIsPressed?frameRate(map(mouseX,0,SIZE,5,60,!0)):frameRate(60);let e=width/params.GRIDS;angleMode(DEGREES),rot=0;for(let a=0;a<params.GRIDS;a++)for(let n=0;n<params.GRIDS;n++){let r=rng.random_choice(images);rotateMe(params.ROTATE_MODE,params.ROTATE_N),applyFilter(params.IMAGE_FILTER,r),DRAW_MODE(params.DRAW_MODE,r,e,n,a)}}function DRAW_MODE(e,a,n,r,t){switch(e){case 1:imageMode(CENTER),image(a,n*r+n/2,n*t+n/2,rng.random_between(0,n),rng.random_between(0,n));break;case 2:imageMode(CORNER),image(a,n*r,n*t,rng.random_between(0,n),rng.random_between(0,n));break;case 3:imageMode(CORNERS),image(a,n*r+rng.random_between(0,n),n*t+rng.random_between(0,n),n*r+rng.random_between(0,n),n*t+rng.random_between(0,n));break;case 4:imageMode(CENTER),image(a,n*r+rng.random_between(0,n),n*t+rng.random_between(0,n),n*r+rng.random_between(0,n),n*t+rng.random_between(0,n));break;case 5:imageMode(CORNER),image(a,n*r+rng.random_between(0,n),n*t+rng.random_between(0,n),n*r+rng.random_between(0,n),n*t+rng.random_between(0,n));break;case 6:imageMode(CORNERS),image(a,rng.random_between(0,SIZE),rng.random_between(0,SIZE),rng.random_between(0,SIZE),rng.random_between(0,SIZE))}}function applyFilter(e,a,n){switch(e){case 1:0==oncee&&(a.filter(INVERT),oncee=!0);break;case 2:a.filter(INVERT);break;case 3:a.filter(POSTERIZE,4);break;case 4:a.filter(POSTERIZE,2),a.filter(INVERT);break;case 5:0==oncee&&(hueShift(a,params.HUE_DEGREE),oncee=!0);break;case 6:hueShift(a,params.HUE_DEGREE);break;case 7:a.filter(GRAY)}}function rotateMe(e,a){switch(e){case 1:rotate(rng.random_choice(a));break;case 2:rotate(rng.random_between(1,a));break;case 3:rotate(a)}}",
1797             0xe49381184A49CD2A48e4b09a979524e672Fdd10E, // glicpixyz.eth
1798             500 // %5 royalty
1799         );
1800     
1801     }
1802 
1803     /// @inheritdoc	ERC165
1804     function supportsInterface(bytes4 interfaceId)
1805         public
1806         view
1807         virtual
1808         override
1809         returns (bool)
1810     {
1811         return
1812             interfaceId == type(IERC2981Royalties).interfaceId ||
1813             super.supportsInterface(interfaceId);
1814     }
1815 
1816     /// @inheritdoc	IERC2981Royalties
1817     function royaltyInfo(uint256, uint256 value)
1818         external
1819         view
1820         override
1821         returns (address receiver, uint256 royaltyAmount)
1822     {
1823         receiver = projectInfo.royaltyReceiver;
1824         royaltyAmount = (value * projectInfo.royaltyAmount) / 10000;
1825     }
1826 
1827     /**
1828      * @dev Returns the array of token IDs of an address.
1829      */
1830     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1831         uint256 tokenCount = balanceOf(_owner);
1832         if (tokenCount == 0) {
1833             // Return an empty array
1834             return new uint256[](0);
1835         } else {
1836             uint256[] memory result = new uint256[](tokenCount);
1837             uint256 index;
1838             for (index = 0; index < tokenCount; index++) {
1839                 result[index] = tokenOfOwnerByIndex(_owner, index);
1840             }
1841             return result;
1842         }
1843     }
1844 
1845     /**
1846      * @dev Unique hash for token to generate the deterministic artwork.
1847      */
1848     function tokenHash(uint256 tokenId) public view returns(bytes32){
1849         require(_exists(tokenId), "DOES NOT EXIST");
1850         return bytes32(keccak256(abi.encodePacked(address(this), creationDates[tokenId], creators[tokenId], tokenId)));
1851     }
1852     
1853     /**
1854      * @dev Url to view generative art
1855      */
1856     function generatorAddress(uint256 tokenId) public view returns (string memory) {
1857         require(_exists(tokenId), "DOES NOT EXIST");
1858         return string(abi.encodePacked(GENERATOR_ADDRESS, tokenId.toString()));
1859     }
1860 
1861     /**
1862      * @dev Calculates the amount of $GLIX to be burned to mint an ARTGLIXXX.
1863      */
1864     function calculateMint(uint _id) public view returns(uint) {
1865         return ARTGLIXXX_NEXT_GEN[_id % TOTAL_GLICPIXXX] * BASE_MINT_PRICE;
1866     }
1867 
1868     /**
1869      * @dev Minting function
1870      */
1871     function generateARTGLIXXX(address _to, uint _glicpixxxId) public {
1872         require(mintOpen == true, "Minting isn't open");
1873         require(GLICPIXXXVER002.ownerOf(_glicpixxxId) == msg.sender, "Not owner of GLICPIXXX");
1874         uint gen = ARTGLIXXX_NEXT_GEN[_glicpixxxId];
1875         if (gen > 0) {
1876             GLIXTOKEN.burn(msg.sender, gen * BASE_MINT_PRICE);       
1877         }
1878         uint mintIndex = _glicpixxxId + (TOTAL_GLICPIXXX * gen);
1879         _safeMint(_to, mintIndex);
1880         emit Mint(_to, mintIndex, gen);
1881         creationDates[mintIndex] = block.number;
1882         creators[mintIndex] = msg.sender;
1883         if (gen == 0){
1884             updateGlixRewardOnMint(_to);
1885             balanceELDEST[_to]++;
1886         }
1887         ARTGLIXXX_NEXT_GEN[_glicpixxxId]++;
1888     }
1889 
1890     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1891 		return a < b ? a : b;
1892 	}
1893 
1894     function exists(uint256 tokenId) external view returns (bool) {
1895         return _exists(tokenId);
1896     }
1897 
1898     /**
1899      * @dev As the function name says.
1900      */
1901     function getTokenGeneration(uint256 tokenId) external view returns (uint256) {
1902         require(_exists(tokenId));
1903         return tokenId / TOTAL_GLICPIXXX;
1904     }
1905 
1906     /**
1907      * @dev Returns the amount of $GLIX address can claim at the moment.
1908      */
1909     function getTotalClaimable(address _user) external view returns (uint256) {
1910         uint256 time = min(block.timestamp, YIELD_END);
1911 		uint256 timerUser = GLIX_LAST_UPDATE[_user];
1912 		if (timerUser > 0)
1913 			return GLIXREWARDS[_user] + (balanceELDEST[_user] * DAILY_YIELD_RATE * (time - timerUser) / 86400);
1914         else
1915             return 0;
1916     }
1917 
1918 	// updated_amount = (balanceELDEST(user) * base_rate * delta / 86400) + amount * initial rate
1919     /**
1920      * @dev Called inside mint function
1921      */
1922 	function updateGlixRewardOnMint(address _user) internal {
1923 		uint256 time = min(block.timestamp, YIELD_END);
1924 		uint256 timerUser = GLIX_LAST_UPDATE[_user];
1925 		if (timerUser > 0)
1926 			GLIXREWARDS[_user] += (balanceELDEST[_user] * DAILY_YIELD_RATE * (time - timerUser) / 86400);
1927         if (timerUser != YIELD_END)
1928 		    GLIX_LAST_UPDATE[_user] = time;
1929 	}
1930 
1931 	/**
1932      * @dev Called on transfers
1933      */
1934 	function updateGlixReward(address _from, address _to, uint256 _tokenId) internal {
1935 		if (_tokenId < TOTAL_GLICPIXXX) {
1936 			uint256 time = min(block.timestamp, YIELD_END);
1937 			uint256 timerFrom = GLIX_LAST_UPDATE[_from];
1938 			if (timerFrom > 0)
1939 				GLIXREWARDS[_from] += (balanceELDEST[_from] * DAILY_YIELD_RATE * (time - timerFrom) / 86400);
1940 			if (timerFrom != YIELD_END)
1941 				GLIX_LAST_UPDATE[_from] = time;
1942 			if (_to != address(0)) {
1943 				uint256 timerTo = GLIX_LAST_UPDATE[_to];
1944 				if (timerTo > 0)
1945 					GLIXREWARDS[_to] += (balanceELDEST[_to] * DAILY_YIELD_RATE * (time - timerTo) / 86400);
1946 				if (timerTo != YIELD_END)
1947 					GLIX_LAST_UPDATE[_to] = time;
1948 			}
1949 		}
1950 	}
1951 
1952     /**
1953      * @dev Calculates the current claimable $GLIX and mints to the address
1954      */
1955     function getReward() public {
1956         updateGlixReward(msg.sender, address(0), 0);
1957 		uint256 reward = GLIXREWARDS[msg.sender];
1958 		if (reward > 0) {
1959 			GLIXREWARDS[msg.sender] = 0;
1960 			GLIXTOKEN.mint(msg.sender, reward);
1961 			emit RewardPaid(msg.sender, reward);
1962 		}
1963 	}
1964 
1965     function transferFrom(address from, address to, uint256 tokenId) public override {
1966 		updateGlixReward(from, to, tokenId);
1967 		if (tokenId < TOTAL_GLICPIXXX)
1968 		{
1969 			balanceELDEST[from]--;
1970 			balanceELDEST[to]++;
1971 		}
1972 		ERC721.transferFrom(from, to, tokenId);
1973 	}
1974 
1975     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
1976 		updateGlixReward(from, to, tokenId);
1977 		if (tokenId < TOTAL_GLICPIXXX)
1978 		{
1979 			balanceELDEST[from]--;
1980 			balanceELDEST[to]++;
1981 		}
1982 		ERC721.safeTransferFrom(from, to, tokenId, _data);
1983 	}
1984 
1985     // ONLYOWNER FUNCTIONS
1986         
1987     /**
1988      * @dev Sets URL to view the token art.
1989      */
1990     function setGeneratorAddress(string memory _address) public onlyOwner {
1991         GENERATOR_ADDRESS = _address;
1992     }
1993 
1994     /**
1995      * @dev Set base metadata URI.
1996      */
1997     function setBaseURI(string memory baseURI) public onlyOwner {
1998         _setBaseURI(baseURI);
1999     }
2000     
2001     /**
2002      * @dev Pause/resume NFT mints.
2003      */
2004     function toggleMint() public onlyOwner {
2005         mintOpen = !mintOpen;
2006     }
2007 
2008     function changeProjectName(string memory _name) public onlyOwner {
2009         projectInfo.name = _name;
2010     }
2011 
2012     function changeProjectDescription(string memory _description) public onlyOwner {
2013         projectInfo.description = _description;
2014     }
2015     
2016     function changeProjectArtistName(string memory _artist) public onlyOwner {
2017         projectInfo.artist = _artist;
2018     }
2019 
2020     function changeProjectLicense(string memory _license) public onlyOwner {
2021         projectInfo.license = _license;
2022     }
2023     
2024     function changeProjectRoyaltyReceiver(address _royaltyReceiver) public onlyOwner {
2025         projectInfo.royaltyReceiver = _royaltyReceiver;
2026     }
2027 
2028     function changeProjectRoyaltyAmount(uint _royaltyAmount) public onlyOwner {
2029         require (_royaltyAmount < 2500);
2030         projectInfo.royaltyAmount = _royaltyAmount;
2031     }
2032 
2033     function changeProjectScript(string memory _script) public onlyOwner {
2034         projectInfo.script = _script;
2035     }
2036     
2037 }