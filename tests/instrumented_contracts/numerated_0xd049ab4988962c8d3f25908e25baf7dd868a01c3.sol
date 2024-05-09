1 // KAMAGANG ETH CONTRACT
2 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant alphabet = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = alphabet[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 
69 }
70 
71 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
72 
73 
74 
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Library for managing an enumerable variant of Solidity's
80  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
81  * type.
82  *
83  * Maps have the following properties:
84  *
85  * - Entries are added, removed, and checked for existence in constant time
86  * (O(1)).
87  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
88  *
89  * ```
90  * contract Example {
91  *     // Add the library methods
92  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
93  *
94  *     // Declare a set state variable
95  *     EnumerableMap.UintToAddressMap private myMap;
96  * }
97  * ```
98  *
99  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
100  * supported.
101  */
102 library EnumerableMap {
103     // To implement this library for multiple types with as little code
104     // repetition as possible, we write it in terms of a generic Map type with
105     // bytes32 keys and values.
106     // The Map implementation uses private functions, and user-facing
107     // implementations (such as Uint256ToAddressMap) are just wrappers around
108     // the underlying Map.
109     // This means that we can only create new EnumerableMaps for types that fit
110     // in bytes32.
111 
112     struct MapEntry {
113         bytes32 _key;
114         bytes32 _value;
115     }
116 
117     struct Map {
118         // Storage of map keys and values
119         MapEntry[] _entries;
120 
121         // Position of the entry defined by a key in the `entries` array, plus 1
122         // because index 0 means a key is not in the map.
123         mapping (bytes32 => uint256) _indexes;
124     }
125 
126     /**
127      * @dev Adds a key-value pair to a map, or updates the value for an existing
128      * key. O(1).
129      *
130      * Returns true if the key was added to the map, that is if it was not
131      * already present.
132      */
133     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
134         // We read and store the key's index to prevent multiple reads from the same storage slot
135         uint256 keyIndex = map._indexes[key];
136 
137         if (keyIndex == 0) { // Equivalent to !contains(map, key)
138             map._entries.push(MapEntry({ _key: key, _value: value }));
139             // The entry is stored at length-1, but we add 1 to all indexes
140             // and use 0 as a sentinel value
141             map._indexes[key] = map._entries.length;
142             return true;
143         } else {
144             map._entries[keyIndex - 1]._value = value;
145             return false;
146         }
147     }
148 
149     /**
150      * @dev Removes a key-value pair from a map. O(1).
151      *
152      * Returns true if the key was removed from the map, that is if it was present.
153      */
154     function _remove(Map storage map, bytes32 key) private returns (bool) {
155         // We read and store the key's index to prevent multiple reads from the same storage slot
156         uint256 keyIndex = map._indexes[key];
157 
158         if (keyIndex != 0) { // Equivalent to contains(map, key)
159             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
160             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
161             // This modifies the order of the array, as noted in {at}.
162 
163             uint256 toDeleteIndex = keyIndex - 1;
164             uint256 lastIndex = map._entries.length - 1;
165 
166             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
167             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
168 
169             MapEntry storage lastEntry = map._entries[lastIndex];
170 
171             // Move the last entry to the index where the entry to delete is
172             map._entries[toDeleteIndex] = lastEntry;
173             // Update the index for the moved entry
174             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
175 
176             // Delete the slot where the moved entry was stored
177             map._entries.pop();
178 
179             // Delete the index for the deleted slot
180             delete map._indexes[key];
181 
182             return true;
183         } else {
184             return false;
185         }
186     }
187 
188     /**
189      * @dev Returns true if the key is in the map. O(1).
190      */
191     function _contains(Map storage map, bytes32 key) private view returns (bool) {
192         return map._indexes[key] != 0;
193     }
194 
195     /**
196      * @dev Returns the number of key-value pairs in the map. O(1).
197      */
198     function _length(Map storage map) private view returns (uint256) {
199         return map._entries.length;
200     }
201 
202    /**
203     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
204     *
205     * Note that there are no guarantees on the ordering of entries inside the
206     * array, and it may change when more entries are added or removed.
207     *
208     * Requirements:
209     *
210     * - `index` must be strictly less than {length}.
211     */
212     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
213         require(map._entries.length > index, "EnumerableMap: index out of bounds");
214 
215         MapEntry storage entry = map._entries[index];
216         return (entry._key, entry._value);
217     }
218 
219     /**
220      * @dev Tries to returns the value associated with `key`.  O(1).
221      * Does not revert if `key` is not in the map.
222      */
223     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
224         uint256 keyIndex = map._indexes[key];
225         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
226         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
227     }
228 
229     /**
230      * @dev Returns the value associated with `key`.  O(1).
231      *
232      * Requirements:
233      *
234      * - `key` must be in the map.
235      */
236     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
237         uint256 keyIndex = map._indexes[key];
238         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
239         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
240     }
241 
242     /**
243      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
244      *
245      * CAUTION: This function is deprecated because it requires allocating memory for the error
246      * message unnecessarily. For custom revert reasons use {_tryGet}.
247      */
248     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
249         uint256 keyIndex = map._indexes[key];
250         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
251         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
252     }
253 
254     // UintToAddressMap
255 
256     struct UintToAddressMap {
257         Map _inner;
258     }
259 
260     /**
261      * @dev Adds a key-value pair to a map, or updates the value for an existing
262      * key. O(1).
263      *
264      * Returns true if the key was added to the map, that is if it was not
265      * already present.
266      */
267     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
268         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
269     }
270 
271     /**
272      * @dev Removes a value from a set. O(1).
273      *
274      * Returns true if the key was removed from the map, that is if it was present.
275      */
276     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
277         return _remove(map._inner, bytes32(key));
278     }
279 
280     /**
281      * @dev Returns true if the key is in the map. O(1).
282      */
283     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
284         return _contains(map._inner, bytes32(key));
285     }
286 
287     /**
288      * @dev Returns the number of elements in the map. O(1).
289      */
290     function length(UintToAddressMap storage map) internal view returns (uint256) {
291         return _length(map._inner);
292     }
293 
294    /**
295     * @dev Returns the element stored at position `index` in the set. O(1).
296     * Note that there are no guarantees on the ordering of values inside the
297     * array, and it may change when more values are added or removed.
298     *
299     * Requirements:
300     *
301     * - `index` must be strictly less than {length}.
302     */
303     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
304         (bytes32 key, bytes32 value) = _at(map._inner, index);
305         return (uint256(key), address(uint160(uint256(value))));
306     }
307 
308     /**
309      * @dev Tries to returns the value associated with `key`.  O(1).
310      * Does not revert if `key` is not in the map.
311      *
312      * _Available since v3.4._
313      */
314     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
315         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
316         return (success, address(uint160(uint256(value))));
317     }
318 
319     /**
320      * @dev Returns the value associated with `key`.  O(1).
321      *
322      * Requirements:
323      *
324      * - `key` must be in the map.
325      */
326     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
327         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
328     }
329 
330     /**
331      * @dev Same as {get}, with a custom error message when `key` is not in the map.
332      *
333      * CAUTION: This function is deprecated because it requires allocating memory for the error
334      * message unnecessarily. For custom revert reasons use {tryGet}.
335      */
336     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
337         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
338     }
339 }
340 
341 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
342 
343 
344 
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @dev Library for managing
350  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
351  * types.
352  *
353  * Sets have the following properties:
354  *
355  * - Elements are added, removed, and checked for existence in constant time
356  * (O(1)).
357  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
358  *
359  * ```
360  * contract Example {
361  *     // Add the library methods
362  *     using EnumerableSet for EnumerableSet.AddressSet;
363  *
364  *     // Declare a set state variable
365  *     EnumerableSet.AddressSet private mySet;
366  * }
367  * ```
368  *
369  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
370  * and `uint256` (`UintSet`) are supported.
371  */
372 library EnumerableSet {
373     // To implement this library for multiple types with as little code
374     // repetition as possible, we write it in terms of a generic Set type with
375     // bytes32 values.
376     // The Set implementation uses private functions, and user-facing
377     // implementations (such as AddressSet) are just wrappers around the
378     // underlying Set.
379     // This means that we can only create new EnumerableSets for types that fit
380     // in bytes32.
381 
382     struct Set {
383         // Storage of set values
384         bytes32[] _values;
385 
386         // Position of the value in the `values` array, plus 1 because index 0
387         // means a value is not in the set.
388         mapping (bytes32 => uint256) _indexes;
389     }
390 
391     /**
392      * @dev Add a value to a set. O(1).
393      *
394      * Returns true if the value was added to the set, that is if it was not
395      * already present.
396      */
397     function _add(Set storage set, bytes32 value) private returns (bool) {
398         if (!_contains(set, value)) {
399             set._values.push(value);
400             // The value is stored at length-1, but we add 1 to all indexes
401             // and use 0 as a sentinel value
402             set._indexes[value] = set._values.length;
403             return true;
404         } else {
405             return false;
406         }
407     }
408 
409     /**
410      * @dev Removes a value from a set. O(1).
411      *
412      * Returns true if the value was removed from the set, that is if it was
413      * present.
414      */
415     function _remove(Set storage set, bytes32 value) private returns (bool) {
416         // We read and store the value's index to prevent multiple reads from the same storage slot
417         uint256 valueIndex = set._indexes[value];
418 
419         if (valueIndex != 0) { // Equivalent to contains(set, value)
420             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
421             // the array, and then remove the last element (sometimes called as 'swap and pop').
422             // This modifies the order of the array, as noted in {at}.
423 
424             uint256 toDeleteIndex = valueIndex - 1;
425             uint256 lastIndex = set._values.length - 1;
426 
427             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
428             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
429 
430             bytes32 lastvalue = set._values[lastIndex];
431 
432             // Move the last value to the index where the value to delete is
433             set._values[toDeleteIndex] = lastvalue;
434             // Update the index for the moved value
435             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
436 
437             // Delete the slot where the moved value was stored
438             set._values.pop();
439 
440             // Delete the index for the deleted slot
441             delete set._indexes[value];
442 
443             return true;
444         } else {
445             return false;
446         }
447     }
448 
449     /**
450      * @dev Returns true if the value is in the set. O(1).
451      */
452     function _contains(Set storage set, bytes32 value) private view returns (bool) {
453         return set._indexes[value] != 0;
454     }
455 
456     /**
457      * @dev Returns the number of values on the set. O(1).
458      */
459     function _length(Set storage set) private view returns (uint256) {
460         return set._values.length;
461     }
462 
463    /**
464     * @dev Returns the value stored at position `index` in the set. O(1).
465     *
466     * Note that there are no guarantees on the ordering of values inside the
467     * array, and it may change when more values are added or removed.
468     *
469     * Requirements:
470     *
471     * - `index` must be strictly less than {length}.
472     */
473     function _at(Set storage set, uint256 index) private view returns (bytes32) {
474         require(set._values.length > index, "EnumerableSet: index out of bounds");
475         return set._values[index];
476     }
477 
478     // Bytes32Set
479 
480     struct Bytes32Set {
481         Set _inner;
482     }
483 
484     /**
485      * @dev Add a value to a set. O(1).
486      *
487      * Returns true if the value was added to the set, that is if it was not
488      * already present.
489      */
490     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
491         return _add(set._inner, value);
492     }
493 
494     /**
495      * @dev Removes a value from a set. O(1).
496      *
497      * Returns true if the value was removed from the set, that is if it was
498      * present.
499      */
500     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
501         return _remove(set._inner, value);
502     }
503 
504     /**
505      * @dev Returns true if the value is in the set. O(1).
506      */
507     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
508         return _contains(set._inner, value);
509     }
510 
511     /**
512      * @dev Returns the number of values in the set. O(1).
513      */
514     function length(Bytes32Set storage set) internal view returns (uint256) {
515         return _length(set._inner);
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
528     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
529         return _at(set._inner, index);
530     }
531 
532     // AddressSet
533 
534     struct AddressSet {
535         Set _inner;
536     }
537 
538     /**
539      * @dev Add a value to a set. O(1).
540      *
541      * Returns true if the value was added to the set, that is if it was not
542      * already present.
543      */
544     function add(AddressSet storage set, address value) internal returns (bool) {
545         return _add(set._inner, bytes32(uint256(uint160(value))));
546     }
547 
548     /**
549      * @dev Removes a value from a set. O(1).
550      *
551      * Returns true if the value was removed from the set, that is if it was
552      * present.
553      */
554     function remove(AddressSet storage set, address value) internal returns (bool) {
555         return _remove(set._inner, bytes32(uint256(uint160(value))));
556     }
557 
558     /**
559      * @dev Returns true if the value is in the set. O(1).
560      */
561     function contains(AddressSet storage set, address value) internal view returns (bool) {
562         return _contains(set._inner, bytes32(uint256(uint160(value))));
563     }
564 
565     /**
566      * @dev Returns the number of values in the set. O(1).
567      */
568     function length(AddressSet storage set) internal view returns (uint256) {
569         return _length(set._inner);
570     }
571 
572    /**
573     * @dev Returns the value stored at position `index` in the set. O(1).
574     *
575     * Note that there are no guarantees on the ordering of values inside the
576     * array, and it may change when more values are added or removed.
577     *
578     * Requirements:
579     *
580     * - `index` must be strictly less than {length}.
581     */
582     function at(AddressSet storage set, uint256 index) internal view returns (address) {
583         return address(uint160(uint256(_at(set._inner, index))));
584     }
585 
586 
587     // UintSet
588 
589     struct UintSet {
590         Set _inner;
591     }
592 
593     /**
594      * @dev Add a value to a set. O(1).
595      *
596      * Returns true if the value was added to the set, that is if it was not
597      * already present.
598      */
599     function add(UintSet storage set, uint256 value) internal returns (bool) {
600         return _add(set._inner, bytes32(value));
601     }
602 
603     /**
604      * @dev Removes a value from a set. O(1).
605      *
606      * Returns true if the value was removed from the set, that is if it was
607      * present.
608      */
609     function remove(UintSet storage set, uint256 value) internal returns (bool) {
610         return _remove(set._inner, bytes32(value));
611     }
612 
613     /**
614      * @dev Returns true if the value is in the set. O(1).
615      */
616     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
617         return _contains(set._inner, bytes32(value));
618     }
619 
620     /**
621      * @dev Returns the number of values on the set. O(1).
622      */
623     function length(UintSet storage set) internal view returns (uint256) {
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
637     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
638         return uint256(_at(set._inner, index));
639     }
640 }
641 
642 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
643 
644 
645 
646 
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Collection of functions related to the address type
651  */
652 library Address {
653     /**
654      * @dev Returns true if `account` is a contract.
655      *
656      * [IMPORTANT]
657      * ====
658      * It is unsafe to assume that an address for which this function returns
659      * false is an externally-owned account (EOA) and not a contract.
660      *
661      * Among others, `isContract` will return false for the following
662      * types of addresses:
663      *
664      *  - an externally-owned account
665      *  - a contract in construction
666      *  - an address where a contract will be created
667      *  - an address where a contract lived, but was destroyed
668      * ====
669      */
670     function isContract(address account) internal view returns (bool) {
671         // This method relies on extcodesize, which returns 0 for contracts in
672         // construction, since the code is only stored at the end of the
673         // constructor execution.
674 
675         uint256 size;
676         // solhint-disable-next-line no-inline-assembly
677         assembly { size := extcodesize(account) }
678         return size > 0;
679     }
680 
681     /**
682      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
683      * `recipient`, forwarding all available gas and reverting on errors.
684      *
685      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
686      * of certain opcodes, possibly making contracts go over the 2300 gas limit
687      * imposed by `transfer`, making them unable to receive funds via
688      * `transfer`. {sendValue} removes this limitation.
689      *
690      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
691      *
692      * IMPORTANT: because control is transferred to `recipient`, care must be
693      * taken to not create reentrancy vulnerabilities. Consider using
694      * {ReentrancyGuard} or the
695      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
696      */
697     function sendValue(address payable recipient, uint256 amount) internal {
698         require(address(this).balance >= amount, "Address: insufficient balance");
699 
700         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
701         (bool success, ) = recipient.call{ value: amount }("");
702         require(success, "Address: unable to send value, recipient may have reverted");
703     }
704 
705     /**
706      * @dev Performs a Solidity function call using a low level `call`. A
707      * plain`call` is an unsafe replacement for a function call: use this
708      * function instead.
709      *
710      * If `target` reverts with a revert reason, it is bubbled up by this
711      * function (like regular Solidity function calls).
712      *
713      * Returns the raw returned data. To convert to the expected return value,
714      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
715      *
716      * Requirements:
717      *
718      * - `target` must be a contract.
719      * - calling `target` with `data` must not revert.
720      *
721      * _Available since v3.1._
722      */
723     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
724       return functionCall(target, data, "Address: low-level call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
729      * `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
734         return functionCallWithValue(target, data, 0, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but also transferring `value` wei to `target`.
740      *
741      * Requirements:
742      *
743      * - the calling contract must have an ETH balance of at least `value`.
744      * - the called Solidity function must be `payable`.
745      *
746      * _Available since v3.1._
747      */
748     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
749         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
754      * with `errorMessage` as a fallback revert reason when `target` reverts.
755      *
756      * _Available since v3.1._
757      */
758     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
759         require(address(this).balance >= value, "Address: insufficient balance for call");
760         require(isContract(target), "Address: call to non-contract");
761 
762         // solhint-disable-next-line avoid-low-level-calls
763         (bool success, bytes memory returndata) = target.call{ value: value }(data);
764         return _verifyCallResult(success, returndata, errorMessage);
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
769      * but performing a static call.
770      *
771      * _Available since v3.3._
772      */
773     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
774         return functionStaticCall(target, data, "Address: low-level static call failed");
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
779      * but performing a static call.
780      *
781      * _Available since v3.3._
782      */
783     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
784         require(isContract(target), "Address: static call to non-contract");
785 
786         // solhint-disable-next-line avoid-low-level-calls
787         (bool success, bytes memory returndata) = target.staticcall(data);
788         return _verifyCallResult(success, returndata, errorMessage);
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
793      * but performing a delegate call.
794      *
795      * _Available since v3.4._
796      */
797     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
798         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
803      * but performing a delegate call.
804      *
805      * _Available since v3.4._
806      */
807     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
808         require(isContract(target), "Address: delegate call to non-contract");
809 
810         // solhint-disable-next-line avoid-low-level-calls
811         (bool success, bytes memory returndata) = target.delegatecall(data);
812         return _verifyCallResult(success, returndata, errorMessage);
813     }
814 
815     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
816         if (success) {
817             return returndata;
818         } else {
819             // Look for revert reason and bubble it up if present
820             if (returndata.length > 0) {
821                 // The easiest way to bubble the revert reason is using memory via assembly
822 
823                 // solhint-disable-next-line no-inline-assembly
824                 assembly {
825                     let returndata_size := mload(returndata)
826                     revert(add(32, returndata), returndata_size)
827                 }
828             } else {
829                 revert(errorMessage);
830             }
831         }
832     }
833 }
834 
835 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
836 
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @dev Interface of the ERC165 standard, as defined in the
842  * https://eips.ethereum.org/EIPS/eip-165[EIP].
843  *
844  * Implementers can declare support of contract interfaces, which can then be
845  * queried by others ({ERC165Checker}).
846  *
847  * For an implementation, see {ERC165}.
848  */
849 interface IERC165 {
850     /**
851      * @dev Returns true if this contract implements the interface defined by
852      * `interfaceId`. See the corresponding
853      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
854      * to learn more about how these ids are created.
855      *
856      * This function call must use less than 30 000 gas.
857      */
858     function supportsInterface(bytes4 interfaceId) external view returns (bool);
859 }
860 
861 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
862 
863 
864 pragma solidity ^0.8.0;
865 
866 
867 /**
868  * @dev Implementation of the {IERC165} interface.
869  *
870  * Contracts may inherit from this and call {_registerInterface} to declare
871  * their support of an interface.
872  */
873 abstract contract ERC165 is IERC165 {
874     /**
875      * @dev Mapping of interface ids to whether or not it's supported.
876      */
877     mapping(bytes4 => bool) private _supportedInterfaces;
878 
879     constructor () {
880         // Derived contracts need only register support for their own interfaces,
881         // we register support for ERC165 itself here
882         _registerInterface(type(IERC165).interfaceId);
883     }
884 
885     /**
886      * @dev See {IERC165-supportsInterface}.
887      *
888      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
889      */
890     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
891         return _supportedInterfaces[interfaceId];
892     }
893 
894     /**
895      * @dev Registers the contract as an implementer of the interface defined by
896      * `interfaceId`. Support of the actual ERC165 interface is automatic and
897      * registering its interface id is not required.
898      *
899      * See {IERC165-supportsInterface}.
900      *
901      * Requirements:
902      *
903      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
904      */
905     function _registerInterface(bytes4 interfaceId) internal virtual {
906         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
907         _supportedInterfaces[interfaceId] = true;
908     }
909 }
910 
911 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
912 
913 
914 
915 
916 pragma solidity ^0.8.0;
917 
918 
919 /**
920  * @dev Required interface of an ERC721 compliant contract.
921  */
922 interface IERC721 is IERC165 {
923     /**
924      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
925      */
926     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
927 
928     /**
929      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
930      */
931     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
932 
933     /**
934      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
935      */
936     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
937 
938     /**
939      * @dev Returns the number of tokens in ``owner``'s account.
940      */
941     function balanceOf(address owner) external view returns (uint256 balance);
942 
943     /**
944      * @dev Returns the owner of the `tokenId` token.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must exist.
949      */
950     function ownerOf(uint256 tokenId) external view returns (address owner);
951 
952     /**
953      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
954      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
955      *
956      * Requirements:
957      *
958      * - `from` cannot be the zero address.
959      * - `to` cannot be the zero address.
960      * - `tokenId` token must exist and be owned by `from`.
961      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
962      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
963      *
964      * Emits a {Transfer} event.
965      */
966     function safeTransferFrom(address from, address to, uint256 tokenId) external;
967 
968     /**
969      * @dev Transfers `tokenId` token from `from` to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must be owned by `from`.
978      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
979      *
980      * Emits a {Transfer} event.
981      */
982     function transferFrom(address from, address to, uint256 tokenId) external;
983 
984     /**
985      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
986      * The approval is cleared when the token is transferred.
987      *
988      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
989      *
990      * Requirements:
991      *
992      * - The caller must own the token or be an approved operator.
993      * - `tokenId` must exist.
994      *
995      * Emits an {Approval} event.
996      */
997     function approve(address to, uint256 tokenId) external;
998 
999     /**
1000      * @dev Returns the account approved for `tokenId` token.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      */
1006     function getApproved(uint256 tokenId) external view returns (address operator);
1007 
1008     /**
1009      * @dev Approve or remove `operator` as an operator for the caller.
1010      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1011      *
1012      * Requirements:
1013      *
1014      * - The `operator` cannot be the caller.
1015      *
1016      * Emits an {ApprovalForAll} event.
1017      */
1018     function setApprovalForAll(address operator, bool _approved) external;
1019 
1020     /**
1021      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1022      *
1023      * See {setApprovalForAll}
1024      */
1025     function isApprovedForAll(address owner, address operator) external view returns (bool);
1026 
1027     /**
1028       * @dev Safely transfers `tokenId` token from `from` to `to`.
1029       *
1030       * Requirements:
1031       *
1032       * - `from` cannot be the zero address.
1033       * - `to` cannot be the zero address.
1034       * - `tokenId` token must exist and be owned by `from`.
1035       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1036       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037       *
1038       * Emits a {Transfer} event.
1039       */
1040     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1041 }
1042 
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 /**
1047  * @title ERC721 token receiver interface
1048  * @dev Interface for any contract that wants to support safeTransfers
1049  * from ERC721 asset contracts.
1050  */
1051 interface IERC721Receiver {
1052     /**
1053      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1054      * by `operator` from `from`, this function is called.
1055      *
1056      * It must return its Solidity selector to confirm the token transfer.
1057      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1058      *
1059      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1060      */
1061     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1062 }
1063 
1064 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1065 
1066 
1067 
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 
1072 /**
1073  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1074  * @dev See https://eips.ethereum.org/EIPS/eip-721
1075  */
1076 interface IERC721Enumerable is IERC721 {
1077 
1078     /**
1079      * @dev Returns the total amount of tokens stored by the contract.
1080      */
1081     function totalSupply() external view returns (uint256);
1082 
1083     /**
1084      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1085      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1086      */
1087     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1088 
1089     /**
1090      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1091      * Use along with {totalSupply} to enumerate all tokens.
1092      */
1093     function tokenByIndex(uint256 index) external view returns (uint256);
1094 }
1095 
1096 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1097 
1098 
1099 
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 
1104 /**
1105  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1106  * @dev See https://eips.ethereum.org/EIPS/eip-721
1107  */
1108 interface IERC721Metadata is IERC721 {
1109 
1110     /**
1111      * @dev Returns the token collection name.
1112      */
1113     function name() external view returns (string memory);
1114 
1115     /**
1116      * @dev Returns the token collection symbol.
1117      */
1118     function symbol() external view returns (string memory);
1119 
1120     /**
1121      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1122      */
1123     function tokenURI(uint256 tokenId) external view returns (string memory);
1124 }
1125 
1126 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1127 
1128 
1129 
1130 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1131 
1132 
1133 
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 /*
1138  * @dev Provides information about the current execution context, including the
1139  * sender of the transaction and its data. While these are generally available
1140  * via msg.sender and msg.data, they should not be accessed in such a direct
1141  * manner, since when dealing with GSN meta-transactions the account sending and
1142  * paying for execution may not be the actual sender (as far as an application
1143  * is concerned).
1144  *
1145  * This contract is only required for intermediate, library-like contracts.
1146  */
1147 abstract contract Context {
1148     function _msgSender() internal view virtual returns (address) {
1149         return msg.sender;
1150     }
1151 
1152     function _msgData() internal view virtual returns (bytes calldata) {
1153         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1154         return msg.data;
1155     }
1156 }
1157 
1158 
1159 
1160 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1161 
1162 
1163 
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 
1177 /**
1178  * @title ERC721 Non-Fungible Token Standard basic implementation
1179  * @dev see https://eips.ethereum.org/EIPS/eip-721
1180  */
1181 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1182     using Address for address;
1183     using EnumerableSet for EnumerableSet.UintSet;
1184     using EnumerableMap for EnumerableMap.UintToAddressMap;
1185     using Strings for uint256;
1186 
1187     // Mapping from holder address to their (enumerable) set of owned tokens
1188     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1189 
1190     // Enumerable mapping from token ids to their owners
1191     EnumerableMap.UintToAddressMap private _tokenOwners;
1192 
1193     // Mapping from token ID to approved address
1194     mapping (uint256 => address) private _tokenApprovals;
1195 
1196     // Mapping from owner to operator approvals
1197     mapping (address => mapping (address => bool)) private _operatorApprovals;
1198 
1199     // Token name
1200     string private _name;
1201 
1202     // Token symbol
1203     string private _symbol;
1204 
1205     // Optional mapping for token URIs
1206     mapping (uint256 => string) private _tokenURIs;
1207 
1208     // Base URI
1209     string private _baseURI;
1210 
1211     /**
1212      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1213      */
1214     constructor (string memory name_, string memory symbol_) {
1215         _name = name_;
1216         _symbol = symbol_;
1217 
1218         // register the supported interfaces to conform to ERC721 via ERC165
1219         _registerInterface(type(IERC721).interfaceId);
1220         _registerInterface(type(IERC721Metadata).interfaceId);
1221         _registerInterface(type(IERC721Enumerable).interfaceId);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-balanceOf}.
1226      */
1227     function balanceOf(address owner) public view virtual override returns (uint256) {
1228         require(owner != address(0), "ERC721: balance query for the zero address");
1229         return _holderTokens[owner].length();
1230     }
1231     
1232 
1233     
1234     /**
1235      * @dev See {IERC721-ownerOf}.
1236      */
1237     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1238         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Metadata-name}.
1243      */
1244     function name() public view virtual override returns (string memory) {
1245         return _name;
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Metadata-symbol}.
1250      */
1251     function symbol() public view virtual override returns (string memory) {
1252         return _symbol;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Metadata-tokenURI}.
1257      */
1258     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1259         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1260 
1261         string memory _tokenURI = _tokenURIs[tokenId];
1262         string memory base = baseURI();
1263 
1264         // If there is no base URI, return the token URI.
1265         if (bytes(base).length == 0) {
1266             return _tokenURI;
1267         }
1268         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1269         if (bytes(_tokenURI).length > 0) {
1270             return string(abi.encodePacked(base, _tokenURI));
1271         }
1272         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1273         return string(abi.encodePacked(base, tokenId.toString()));
1274     }
1275 
1276     /**
1277     * @dev Returns the base URI set via {_setBaseURI}. This will be
1278     * automatically added as a prefix in {tokenURI} to each token's URI, or
1279     * to the token ID if no specific URI is set for that token ID.
1280     */
1281     function baseURI() public view virtual returns (string memory) {
1282         return _baseURI;
1283     }
1284 
1285     /**
1286      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1287      */
1288     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1289         return _holderTokens[owner].at(index);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Enumerable-totalSupply}.
1294      */
1295     function totalSupply() public view virtual override returns (uint256) {
1296         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1297         return _tokenOwners.length();
1298     }
1299 
1300     /**
1301      * @dev See {IERC721Enumerable-tokenByIndex}.
1302      */
1303     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1304         (uint256 tokenId, ) = _tokenOwners.at(index);
1305         return tokenId;
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-approve}.
1310      */
1311     function approve(address to, uint256 tokenId) public virtual override {
1312         address owner = ERC721.ownerOf(tokenId);
1313         require(to != owner, "ERC721: approval to current owner");
1314 
1315         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1316             "ERC721: approve caller is not owner nor approved for all"
1317         );
1318 
1319         _approve(to, tokenId);
1320     }
1321 
1322     /**
1323      * @dev See {IERC721-getApproved}.
1324      */
1325     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1326         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1327 
1328         return _tokenApprovals[tokenId];
1329     }
1330 
1331     /**
1332      * @dev See {IERC721-setApprovalForAll}.
1333      */
1334     function setApprovalForAll(address operator, bool approved) public virtual override {
1335         require(operator != _msgSender(), "ERC721: approve to caller");
1336 
1337         _operatorApprovals[_msgSender()][operator] = approved;
1338         emit ApprovalForAll(_msgSender(), operator, approved);
1339     }
1340 
1341     /**
1342      * @dev See {IERC721-isApprovedForAll}.
1343      */
1344     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1345         return _operatorApprovals[owner][operator];
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-transferFrom}.
1350      */
1351     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1352         //solhint-disable-next-line max-line-length
1353         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1354 
1355         _transfer(from, to, tokenId);
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-safeTransferFrom}.
1360      */
1361     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1362         safeTransferFrom(from, to, tokenId, "");
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-safeTransferFrom}.
1367      */
1368     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1369         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1370         _safeTransfer(from, to, tokenId, _data);
1371     }
1372 
1373     /**
1374      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1375      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1376      *
1377      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1378      *
1379      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1380      * implement alternative mechanisms to perform token transfer, such as signature-based.
1381      *
1382      * Requirements:
1383      *
1384      * - `from` cannot be the zero address.
1385      * - `to` cannot be the zero address.
1386      * - `tokenId` token must exist and be owned by `from`.
1387      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1392         _transfer(from, to, tokenId);
1393         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1394     }
1395 
1396     /**
1397      * @dev Returns whether `tokenId` exists.
1398      *
1399      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1400      *
1401      * Tokens start existing when they are minted (`_mint`),
1402      * and stop existing when they are burned (`_burn`).
1403      */
1404     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1405         return _tokenOwners.contains(tokenId);
1406     }
1407 
1408     /**
1409      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1410      *
1411      * Requirements:
1412      *
1413      * - `tokenId` must exist.
1414      */
1415     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1416         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1417         address owner = ERC721.ownerOf(tokenId);
1418         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1419     }
1420 
1421     /**
1422      * @dev Safely mints `tokenId` and transfers it to `to`.
1423      *
1424      * Requirements:
1425      d*
1426      * - `tokenId` must not exist.
1427      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _safeMint(address to, uint256 tokenId) internal virtual {
1432         _safeMint(to, tokenId, "");
1433     }
1434 
1435     /**
1436      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1437      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1438      */
1439     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1440         _mint(to, tokenId);
1441         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1442     }
1443 
1444     /**
1445      * @dev Mints `tokenId` and transfers it to `to`.
1446      *
1447      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1448      *
1449      * Requirements:
1450      *
1451      * - `tokenId` must not exist.
1452      * - `to` cannot be the zero address.
1453      *
1454      * Emits a {Transfer} event.
1455      */
1456     function _mint(address to, uint256 tokenId) internal virtual {
1457         require(to != address(0), "ERC721: mint to the zero address");
1458         require(!_exists(tokenId), "ERC721: token already minted");
1459 
1460         _beforeTokenTransfer(address(0), to, tokenId);
1461 
1462         _holderTokens[to].add(tokenId);
1463 
1464         _tokenOwners.set(tokenId, to);
1465 
1466         emit Transfer(address(0), to, tokenId);
1467     }
1468 
1469     /**
1470      * @dev Destroys `tokenId`.
1471      * The approval is cleared when the token is burned.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function _burn(uint256 tokenId) internal virtual {
1480         address owner = ERC721.ownerOf(tokenId); // internal owner
1481 
1482         _beforeTokenTransfer(owner, address(0), tokenId);
1483 
1484         // Clear approvals
1485         _approve(address(0), tokenId);
1486 
1487         // Clear metadata (if any)
1488         if (bytes(_tokenURIs[tokenId]).length != 0) {
1489             delete _tokenURIs[tokenId];
1490         }
1491 
1492         _holderTokens[owner].remove(tokenId);
1493 
1494         _tokenOwners.remove(tokenId);
1495 
1496         emit Transfer(owner, address(0), tokenId);
1497     }
1498 
1499     /**
1500      * @dev Transfers `tokenId` from `from` to `to`.
1501      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1502      *
1503      * Requirements:
1504      *
1505      * - `to` cannot be the zero address.
1506      * - `tokenId` token must be owned by `from`.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1511         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1512         require(to != address(0), "ERC721: transfer to the zero address");
1513 
1514         _beforeTokenTransfer(from, to, tokenId);
1515 
1516         // Clear approvals from the previous owner
1517         _approve(address(0), tokenId);
1518 
1519         _holderTokens[from].remove(tokenId);
1520         _holderTokens[to].add(tokenId);
1521 
1522         _tokenOwners.set(tokenId, to);
1523 
1524         emit Transfer(from, to, tokenId);
1525     }
1526 
1527     /**
1528      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must exist.
1533      */
1534     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1535         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1536         _tokenURIs[tokenId] = _tokenURI;
1537     }
1538 
1539     /**
1540      * @dev Internal function to set the base URI for all token IDs. It is
1541      * automatically added as a prefix to the value returned in {tokenURI},
1542      * or to the token ID if {tokenURI} is empty.
1543      */
1544     function _setBaseURI(string memory baseURI_) internal virtual {
1545         _baseURI = baseURI_;
1546     }
1547 
1548     /**
1549      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1550      * The call is not executed if the target address is not a contract.
1551      *
1552      * @param from address representing the previous owner of the given token ID
1553      * @param to target address that will receive the tokens
1554      * @param tokenId uint256 ID of the token to be transferred
1555      * @param _data bytes optional data to send along with the call
1556      * @return bool whether the call correctly returned the expected magic value
1557      */
1558     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1559         private returns (bool)
1560     {
1561         if (to.isContract()) {
1562             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1563                 return retval == IERC721Receiver(to).onERC721Received.selector;
1564             } catch (bytes memory reason) {
1565                 if (reason.length == 0) {
1566                     revert("ERC721: transfer to non ERC721Receiver implementer");
1567                 } else {
1568                     // solhint-disable-next-line no-inline-assembly
1569                     assembly {
1570                         revert(add(32, reason), mload(reason))
1571                     }
1572                 }
1573             }
1574         } else {
1575             return true;
1576         }
1577     }
1578 
1579     function _approve(address to, uint256 tokenId) private {
1580         _tokenApprovals[tokenId] = to;
1581         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1582     }
1583 
1584     /**
1585      * @dev Hook that is called before any token transfer. This includes minting
1586      * and burning.
1587      *
1588      * Calling conditions:
1589      *
1590      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1591      * transferred to `to`.
1592      * - When `from` is zero, `tokenId` will be minted for `to`.
1593      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1594      * - `from` cannot be the zero address.
1595      * - `to` cannot be the zero address.
1596      *
1597      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1598      */
1599     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1600 }
1601 
1602 
1603 
1604 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1605 
1606 
1607 
1608 
1609 pragma solidity ^0.8.0;
1610 
1611 /**
1612  * @dev Contract module which provides a basic access control mechanism, where
1613  * there is an account (an owner) that can be granted exclusive access to
1614  * specific functions.
1615  *
1616  * By default, the owner account will be the one that deploys the contract. This
1617  * can later be changed with {transferOwnership}.
1618  *
1619  * This module is used through inheritance. It will make available the modifier
1620  * `onlyOwner`, which can be applied to your functions to restrict their use to
1621  * the owner.
1622  */
1623 abstract contract Ownable is Context {
1624     address private _owner;
1625 
1626     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1627 
1628     /**
1629      * @dev Initializes the contract setting the deployer as the initial owner.
1630      */
1631     constructor () {
1632         address msgSender = _msgSender();
1633         _owner = msgSender;
1634         emit OwnershipTransferred(address(0), msgSender);
1635     }
1636 
1637     /**
1638      * @dev Returns the address of the current owner.
1639      */
1640     function owner() public view virtual returns (address) {
1641         return _owner;
1642     }
1643 
1644     /**
1645      * @dev Throws if called by any account other than the owner.
1646      */
1647     modifier onlyOwner() {
1648         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1649         _;
1650     }
1651 
1652     /**
1653      * @dev Leaves the contract without owner. It will not be possible to call
1654      * `onlyOwner` functions anymore. Can only be called by the current owner.
1655      *
1656      * NOTE: Renouncing ownership will leave the contract without an owner,
1657      * thereby removing any functionality that is only available to the owner.
1658      */
1659     function renounceOwnership() public virtual onlyOwner {
1660         emit OwnershipTransferred(_owner, address(0));
1661         _owner = address(0);
1662     }
1663 
1664     /**
1665      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1666      * Can only be called by the current owner.
1667      */
1668     function transferOwnership(address newOwner) public virtual onlyOwner {
1669         require(newOwner != address(0), "Ownable: new owner is the zero address");
1670         emit OwnershipTransferred(_owner, newOwner);
1671         _owner = newOwner;
1672     }
1673 }
1674 
1675 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1676 
1677 
1678 
1679 
1680 pragma solidity ^0.8.0;
1681 
1682 // CAUTION
1683 // This version of SafeMath should only be used with Solidity 0.8 or later,
1684 // because it relies on the compiler's built in overflow checks.
1685 
1686 /**
1687  * @dev Wrappers over Solidity's arithmetic operations.
1688  *
1689  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1690  * now has built in overflow checking.
1691  */
1692 library SafeMath {
1693     /**
1694      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1695      *
1696      * _Available since v3.4._
1697      */
1698     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1699         unchecked {
1700             uint256 c = a + b;
1701             if (c < a) return (false, 0);
1702             return (true, c);
1703         }
1704     }
1705 
1706     /**
1707      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1708      *
1709      * _Available since v3.4._
1710      */
1711     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1712         unchecked {
1713             if (b > a) return (false, 0);
1714             return (true, a - b);
1715         }
1716     }
1717 
1718     /**
1719      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1720      *
1721      * _Available since v3.4._
1722      */
1723     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1724         unchecked {
1725             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1726             // benefit is lost if 'b' is also tested.
1727             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1728             if (a == 0) return (true, 0);
1729             uint256 c = a * b;
1730             if (c / a != b) return (false, 0);
1731             return (true, c);
1732         }
1733     }
1734 
1735     /**
1736      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1737      *
1738      * _Available since v3.4._
1739      */
1740     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1741         unchecked {
1742             if (b == 0) return (false, 0);
1743             return (true, a / b);
1744         }
1745     }
1746 
1747     /**
1748      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1749      *
1750      * _Available since v3.4._
1751      */
1752     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1753         unchecked {
1754             if (b == 0) return (false, 0);
1755             return (true, a % b);
1756         }
1757     }
1758 
1759     /**
1760      * @dev Returns the addition of two unsigned integers, reverting on
1761      * overflow.
1762      *
1763      * Counterpart to Solidity's `+` operator.
1764      *
1765      * Requirements:
1766      *
1767      * - Addition cannot overflow.
1768      */
1769     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1770         return a + b;
1771     }
1772 
1773     /**
1774      * @dev Returns the subtraction of two unsigned integers, reverting on
1775      * overflow (when the result is negative).
1776      *
1777      * Counterpart to Solidity's `-` operator.
1778      *
1779      * Requirements:
1780      *
1781      * - Subtraction cannot overflow.
1782      */
1783     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1784         return a - b;
1785     }
1786 
1787     /**
1788      * @dev Returns the multiplication of two unsigned integers, reverting on
1789      * overflow.
1790      *
1791      * Counterpart to Solidity's `*` operator.
1792      *
1793      * Requirements:
1794      *
1795      * - Multiplication cannot overflow.
1796      */
1797     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1798         return a * b;
1799     }
1800 
1801     /**
1802      * @dev Returns the integer division of two unsigned integers, reverting on
1803      * division by zero. The result is rounded towards zero.
1804      *
1805      * Counterpart to Solidity's `/` operator.
1806      *
1807      * Requirements:
1808      *
1809      * - The divisor cannot be zero.
1810      */
1811     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1812         return a / b;
1813     }
1814 
1815     /**
1816      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1817      * reverting when dividing by zero.
1818      *
1819      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1820      * opcode (which leaves remaining gas untouched) while Solidity uses an
1821      * invalid opcode to revert (consuming all remaining gas).
1822      *
1823      * Requirements:
1824      *
1825      * - The divisor cannot be zero.
1826      */
1827     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1828         return a % b;
1829     }
1830 
1831     /**
1832      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1833      * overflow (when the result is negative).
1834      *
1835      * CAUTION: This function is deprecated because it requires allocating memory for the error
1836      * message unnecessarily. For custom revert reasons use {trySub}.
1837      *
1838      * Counterpart to Solidity's `-` operator.
1839      *
1840      * Requirements:
1841      *
1842      * - Subtraction cannot overflow.
1843      */
1844     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1845         unchecked {
1846             require(b <= a, errorMessage);
1847             return a - b;
1848         }
1849     }
1850 
1851     /**
1852      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1853      * division by zero. The result is rounded towards zero.
1854      *
1855      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1856      * opcode (which leaves remaining gas untouched) while Solidity uses an
1857      * invalid opcode to revert (consuming all remaining gas).
1858      *
1859      * Counterpart to Solidity's `/` operator. Note: this function uses a
1860      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1861      * uses an invalid opcode to revert (consuming all remaining gas).
1862      *
1863      * Requirements:
1864      *
1865      * - The divisor cannot be zero.
1866      */
1867     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1868         unchecked {
1869             require(b > 0, errorMessage);
1870             return a / b;
1871         }
1872     }
1873 
1874     /**
1875      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1876      * reverting with custom message when dividing by zero.
1877      *
1878      * CAUTION: This function is deprecated because it requires allocating memory for the error
1879      * message unnecessarily. For custom revert reasons use {tryMod}.
1880      *
1881      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1882      * opcode (which leaves remaining gas untouched) while Solidity uses an
1883      * invalid opcode to revert (consuming all remaining gas).
1884      *
1885      * Requirements:
1886      *
1887      * - The divisor cannot be zero.
1888      */
1889     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1890         unchecked {
1891             require(b > 0, errorMessage);
1892             return a % b;
1893         }
1894     }
1895 }
1896 
1897 // File: browser/KAMA.sol
1898 
1899 
1900 
1901 
1902 
1903 pragma solidity ^0.8.0;
1904 
1905 
1906 contract Kamagang is ERC721, Ownable {
1907     using SafeMath for uint256;
1908     uint public constant MAX_KAMAS = 3163;
1909     bool public hasSaleStarted = false;
1910     // THE IPFS HASH OF ALL TOKEN DATAS WILL BE ADDED HERE WHEN ALL KAMAS ARE FINALIZED.
1911     string public METADATA_PROVENANCE_HASH = "";
1912     uint256 public nextTokenId = 0;
1913     address[] public oldHolders;
1914 
1915     constructor() ERC721("Kamagang","KAMA")  {
1916         
1917         setBaseURI("https://www.kamagang.com/api/token/");
1918         oldHolders = [
1919             0x1d2D8fc9540E73906c6fae482FC241468B20691f,            
1920             0x1d2D8fc9540E73906c6fae482FC241468B20691f,            
1921             0xfCAD2eB79692c2Aa0BCBaf3D3E29615dDa94FE6d,            
1922             0x8c46C00FC633e1e73254bEC5A7364235976aDbF5,            
1923             0xd62A5C591992f0965332AF7D8a4f054802454f76,            
1924             0xc5E5ec38de39c632f67EbF9795CD1d7D12331799,            
1925             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1926             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1927             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1928             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1929             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1930             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1931             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1932             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1933             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1934             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1935             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1936             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1937             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1938             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1939             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1940             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1941             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1942             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1943             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1944             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1945             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1946             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1947             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1948             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1949             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1950             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1951             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1952             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1953             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1954             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1955             0xc5E5ec38de39c632f67EbF9795CD1d7D12331799,            
1956             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1957             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1958             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1959             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1960             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1961             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1962             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1963             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1964             0xAC8E926E3ADf2887A12e11a233661b4a53879B07,            
1965             0x0343Fa23A3AC5A8CeA8b6605a9C0D26330C7f8aA,            
1966             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1967             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1968             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1969             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1970             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1971             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1972             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1973             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1974             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1975             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1976             0xd62A5C591992f0965332AF7D8a4f054802454f76,            
1977             0xd62A5C591992f0965332AF7D8a4f054802454f76,            
1978             0xd62A5C591992f0965332AF7D8a4f054802454f76,            
1979             0xa20c32005968D0Af6EF2dd8bE949Da175C0c8a8E,            
1980             0xa20c32005968D0Af6EF2dd8bE949Da175C0c8a8E,            
1981             0x7Dd44cD59D0320a8A2A0a6F521BFE767108dD2E3,            
1982             0xa20c32005968D0Af6EF2dd8bE949Da175C0c8a8E,            
1983             0xA175029BFf19B26B4A2E6da68e8bb909d6005fec,            
1984             0xa20c32005968D0Af6EF2dd8bE949Da175C0c8a8E,            
1985             0xa20c32005968D0Af6EF2dd8bE949Da175C0c8a8E,            
1986             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1987             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1988             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1989             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1990             0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5,            
1991             0x8191A2e4721CA4f2f4533c3c12B628f141fF2c19,            
1992             0xf9a3e0fF980D6197BE4701AFEC1C1c074b6eC146,            
1993             0x5d6013a802E7E29e60a46492D5eCCf0B5Da75735,            
1994             0xfCAD2eB79692c2Aa0BCBaf3D3E29615dDa94FE6d,            
1995             0x750364CcecC0250C2160b5e1Cc9F9AFdAA99138b,            
1996             0xcbF3f36a83b80C546C7e56AbD7fBb547946b6eD4,            
1997             0xa32f90B21D11561D31ff604745907aCc77Fb67e3,            
1998             0xD8ed7ADfB9884203d7f50F2F2AbF29d3285AB3DF,            
1999             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2000             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2001             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2002             0x8b3347FD0B8C3a619d1f1FDc90CAF4F335c03742,            
2003             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2004             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2005             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2006             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2007             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2008             0xB349150d6270152ca24064ec78ce8C7d7Af9f203,            
2009             0xB349150d6270152ca24064ec78ce8C7d7Af9f203,            
2010             0xB349150d6270152ca24064ec78ce8C7d7Af9f203,            
2011             0xB349150d6270152ca24064ec78ce8C7d7Af9f203,            
2012             0xDd343C671AbB706D8E4f5dA9CD9662753E44A01E,            
2013             0x99896B3481e4b819B45e8dfB1512036951Edf49a,            
2014             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2015             0x7Dd44cD59D0320a8A2A0a6F521BFE767108dD2E3,            
2016             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2017             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2018             0x9254F7f72BC6294AD6569d1aB78139121DB880F6,            
2019             0x63f0EcB088F9D47C56E10a76f03d356eB40956a9,            
2020             0x826F51B323e83F2e2799055b7E39b1661a056059,            
2021             0x826F51B323e83F2e2799055b7E39b1661a056059,            
2022             0xc5a7140A46501F0A7326Aa5719b41Df931bDa8ED,            
2023             0xc5a7140A46501F0A7326Aa5719b41Df931bDa8ED,            
2024             0xc5a7140A46501F0A7326Aa5719b41Df931bDa8ED,            
2025             0xae9083B40cb144E7f07de92b7255DFbe820326dC,            
2026             0xc5a7140A46501F0A7326Aa5719b41Df931bDa8ED,           
2027             0xae9083B40cb144E7f07de92b7255DFbe820326dC,            
2028             0x7Dd44cD59D0320a8A2A0a6F521BFE767108dD2E3,            
2029             0x16eFE37c0c557D4B1D8EB76d11E13616d2b52eAF,            
2030             0xcf9741bBcE8Ba8EC2b0dC8F23399a0BcF5C019D5,            
2031             0xD8ed7ADfB9884203d7f50F2F2AbF29d3285AB3DF,            
2032             0x5d6013a802E7E29e60a46492D5eCCf0B5Da75735,            
2033             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2034             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2035             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2036             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2037             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2038             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2039             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2040             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2041             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2042             0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c,            
2043             0x20Ee31efB8e96d346CeB065b993494D136368E96,            
2044             0x4178A094Bff80C56A10583502Fa1a70191f6B49D,            
2045             0x63580Ae170368E647dC9894B11a7E2FC63de5847,            
2046             0xA0ab8Eddf14a5174688E2eb1bdb69CDF377142C3,            
2047             0xA0ab8Eddf14a5174688E2eb1bdb69CDF377142C3,            
2048             0x36de990133D36d7E3DF9a820aA3eDE5a2320De71,            
2049             0x58615313079FdD02eb240a11fbBFf1dadb00007e,            
2050             0xC1c0e9750fAB87ac871eA40D005063F3750fe143,            
2051             0xC1c0e9750fAB87ac871eA40D005063F3750fe143,            
2052             0xC1c0e9750fAB87ac871eA40D005063F3750fe143,            
2053             0x0a38C3a976B169574bD16412b654c1Ee0DB92e1B,            
2054             0x0a38C3a976B169574bD16412b654c1Ee0DB92e1B,            
2055             0x0a38C3a976B169574bD16412b654c1Ee0DB92e1B,            
2056             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2057             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2058             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2059             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2060             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2061             0x9FF5ad420c4DAf1eeA5331081b5b5c07EF12D82C,            
2062             0x9FF5ad420c4DAf1eeA5331081b5b5c07EF12D82C,            
2063             0x9FF5ad420c4DAf1eeA5331081b5b5c07EF12D82C,            
2064             0x9FF5ad420c4DAf1eeA5331081b5b5c07EF12D82C,            
2065             0x9FF5ad420c4DAf1eeA5331081b5b5c07EF12D82C,            
2066             0xcbF3f36a83b80C546C7e56AbD7fBb547946b6eD4,            
2067             0xbA178AE12DAa78dE6592847cF8bb26508aE5D5Db,            
2068             0xbA178AE12DAa78dE6592847cF8bb26508aE5D5Db,            
2069             0xbA178AE12DAa78dE6592847cF8bb26508aE5D5Db,            
2070             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,            
2071             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,            
2072             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,            
2073             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,            
2074             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,            
2075             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2076             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2077             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2078             0x8595ea60a434FcfAa00b6f42aDFa663276f85B59,            
2079             0xC5B0662b034dDd10cC068768cb6AaEA120944506,            
2080             0xC5B0662b034dDd10cC068768cb6AaEA120944506,            
2081             0xC5B0662b034dDd10cC068768cb6AaEA120944506,            
2082             0xC5B0662b034dDd10cC068768cb6AaEA120944506,            
2083             0xC5B0662b034dDd10cC068768cb6AaEA120944506,            
2084             0x786a567eb7928fA25ed4b32a19982313FE89C743,            
2085             0x786a567eb7928fA25ed4b32a19982313FE89C743,            
2086             0x786a567eb7928fA25ed4b32a19982313FE89C743,            
2087             0x786a567eb7928fA25ed4b32a19982313FE89C743,            
2088             0x786a567eb7928fA25ed4b32a19982313FE89C743,            
2089             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2090             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2091             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2092             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,           
2093             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2094             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,            
2095             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,          
2096             0xCFB2130a8f7a6882D0327Cc8e065CFc3d0B778b8,         
2097             0xd26A2bd8A59eA00bD836142cc6BE9717361a3b51,         
2098             0x5CD03E51b435517a53E5dF8978beCcd7A3aB6440,       
2099             0xBcE3BD3b206946AbBe094903Ae2B4244B52fb4e9,      
2100             0x750364CcecC0250C2160b5e1Cc9F9AFdAA99138b,      
2101             0xd26A2bd8A59eA00bD836142cc6BE9717361a3b51,       
2102             0x3EA60Fdca9b6D6F7dE6489d2B5F76677F1ECDf3b,       
2103             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,       
2104             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,       
2105             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,        
2106             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,        
2107             0x45b4eab523faf62B319Bf1b02F94Ac00E54d6F23,        
2108             0xe3127F4333C652097183F37f05926162d531A9ba,      
2109             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,      
2110             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,        
2111             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,           
2112             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,      
2113             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,           
2114             0x4a35D36E9E481F22a2eAD65486Eb4f3269A4B5e1,          
2115             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,         
2116             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,         
2117             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,        
2118             0xb669b9E2613d7c3dF3F7E05521dc9721a9A92D10,        
2119             0x750364CcecC0250C2160b5e1Cc9F9AFdAA99138b,         
2120             0xA80F4b0E958BB28BFE4b77770DFfcd95037a9989,         
2121             0x75B0955d5727148816479881B7dD4cC646aF27bb,           
2122             0x75B0955d5727148816479881B7dD4cC646aF27bb,          
2123             0x9628f7ac6e49279405565205dfA114B5c241a5Bb,        
2124             0xb278ada59e7Af95a0c3DE7699d8946b853f1e38a,        
2125             0x308660A88F8D628971F836383422fE2621ede60A,       
2126             0xE6Fd5dD7A626902FF3B5B59eE055D47797DB3b11,        
2127             0xE6Fd5dD7A626902FF3B5B59eE055D47797DB3b11,       
2128             0xE6Fd5dD7A626902FF3B5B59eE055D47797DB3b11,        
2129             0x6DfE68FF6cEAf97FeFE79545A5827ce39C2CcD62,        
2130             0x6DfE68FF6cEAf97FeFE79545A5827ce39C2CcD62,        
2131             0x6DfE68FF6cEAf97FeFE79545A5827ce39C2CcD62,        
2132             0x6DfE68FF6cEAf97FeFE79545A5827ce39C2CcD62,        
2133             0x6DfE68FF6cEAf97FeFE79545A5827ce39C2CcD62,         
2134             0x10b112108AA41262D05cE64967554252879BDCAa,         
2135             0x300da191248a500b2174aeD992d6697BF97F9139,          
2136             0x28DDbE460253cd0828FcE66b7E239052aBeC3d02,         
2137             0x28DDbE460253cd0828FcE66b7E239052aBeC3d02,          
2138             0x28DDbE460253cd0828FcE66b7E239052aBeC3d02,          
2139             0x308660A88F8D628971F836383422fE2621ede60A,          
2140             0x308660A88F8D628971F836383422fE2621ede60A,         
2141             0x308660A88F8D628971F836383422fE2621ede60A,         
2142             0x308660A88F8D628971F836383422fE2621ede60A,        
2143             0x445311e44db62Edc5762AcCA9BbDdbd0977e9aed,       
2144             0x639BB215b1B243561A9F19c13A1dB3DB0919Fd60,      
2145             0xa581019241c6d81a4d0abF083c3Ec003AeE31a01,    
2146             0xd815FEaeb858838690440F7298Eb0465b27a7Ff4,    
2147             0x1e309e568b808A38BB3DdFd1AED8D0A70D435A06,    
2148             0x77F1894552a6336bd0Fb2F0e904D30858f67Cfa4,   
2149             0x1264f7D54798C1898611CB07FeA0389eEa7235D0,   
2150             0x1256E7992564AB22e332532472c916Bd8D1e1Ca7,    
2151             0x1256E7992564AB22e332532472c916Bd8D1e1Ca7,     
2152             0x1256E7992564AB22e332532472c916Bd8D1e1Ca7,     
2153             0x1256E7992564AB22e332532472c916Bd8D1e1Ca7,     
2154             0xd513236eA9CacA4F1b520F76A525bAb7619813c8,     
2155             0xd513236eA9CacA4F1b520F76A525bAb7619813c8,     
2156             0x2C3Ef1f3DF0bf1409aF53f8Fc0BaFdfe60318e01,       
2157             0x2C3Ef1f3DF0bf1409aF53f8Fc0BaFdfe60318e01,         
2158             0x2C3Ef1f3DF0bf1409aF53f8Fc0BaFdfe60318e01,         
2159             0x2C3Ef1f3DF0bf1409aF53f8Fc0BaFdfe60318e01,      
2160             0x318b1b4816520603894a3C1464cC7Bb444d92143,       
2161             0xa20c32005968D0Af6EF2dd8bE949Da175C0c8a8E,      
2162             0xa20c32005968D0Af6EF2dd8bE949Da175C0c8a8E,       
2163             0x2C3Ef1f3DF0bf1409aF53f8Fc0BaFdfe60318e01,       
2164             0xf5dCb2a47f738d8bA39F9Fa2DdC7592f268a262A,        
2165             0xf5dCb2a47f738d8bA39F9Fa2DdC7592f268a262A,        
2166             0xf5dCb2a47f738d8bA39F9Fa2DdC7592f268a262A,      
2167             0xf5dCb2a47f738d8bA39F9Fa2DdC7592f268a262A,     
2168             0xe987767226b681939d07749ed192870f9101A1d1,     
2169             0x6439543a2fF1d78d25ABDc8DAa75bb004e210183,     
2170             0xfCAD2eB79692c2Aa0BCBaf3D3E29615dDa94FE6d,     
2171             0xD8ed7ADfB9884203d7f50F2F2AbF29d3285AB3DF,    
2172             0x63f0EcB088F9D47C56E10a76f03d356eB40956a9,     
2173             0xe4657aF058E3f844919c3ee713DF09c3F2949447,    
2174             0xe4657aF058E3f844919c3ee713DF09c3F2949447
2175         ];
2176         
2177         }
2178     
2179 
2180     
2181     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2182         uint256 tokenCount = balanceOf(_owner);
2183         if (tokenCount == 0) {
2184             // Return an empty array
2185             return new uint256[](0);
2186         } else {
2187             uint256[] memory result = new uint256[](tokenCount);
2188             uint256 index;
2189             for (index = 0; index < tokenCount; index++) {
2190                 result[index] = tokenOfOwnerByIndex(_owner, index);
2191             }
2192             return result;
2193         }
2194     }
2195     
2196 
2197     function calculatePrice() public view returns (uint256) {
2198         require(hasSaleStarted == true, "Sale hasn't started");
2199         require(totalSupply() < MAX_KAMAS, "Sale has already ended");
2200         //return 9e16; //0.09ETH
2201         return 90000000000000000; //0.09ETH
2202     }
2203 
2204     
2205    function mintKAMA(uint256 numKamas) public payable {
2206         require(totalSupply() < MAX_KAMAS, "Sale has already ended");
2207         require(numKamas > 0 && numKamas <= 20, "You can adopt minimum 1, maximum 20 KAMAS");
2208         require(totalSupply().add(numKamas) <= MAX_KAMAS, "Exceeds MAX_KAMAS");
2209         require(msg.value >= calculatePrice().mul(numKamas), "Ether value sent is below the price");
2210 
2211         for (uint i = 0; i < numKamas; i++) {
2212             uint mintIndex = totalSupply();
2213             _safeMint(msg.sender, mintIndex);
2214             nextTokenId++; //FIXFIXFIXFIX
2215         }
2216 
2217     }
2218 
2219 
2220     // ONLYOWNER FUNCTIONS
2221     
2222     function setProvenanceHash(string memory _hash) public onlyOwner {
2223         METADATA_PROVENANCE_HASH = _hash;
2224     }
2225     
2226     function setBaseURI(string memory baseURI) public onlyOwner {
2227         _setBaseURI(baseURI);
2228     }
2229     
2230     function startDrop() public onlyOwner {
2231         hasSaleStarted = true;
2232     }
2233     
2234     function pauseDrop() public onlyOwner {
2235         hasSaleStarted = false;
2236     }
2237     
2238     function withdrawAll() public payable onlyOwner {
2239         require(payable(msg.sender).send(address(this).balance));
2240     }
2241     
2242     function migrate1() public onlyOwner  {
2243         for(uint256 i= 0; i < 50; i++) {
2244             _safeMint(address(oldHolders[i]),  i);
2245         }
2246     }
2247     
2248     function migrate2() public onlyOwner  {
2249         for(uint256 i= 50; i < 100; i++) {
2250             _safeMint(address(oldHolders[i]),  i);
2251         }
2252     }
2253     
2254     function migrate3() public onlyOwner  {
2255          for(uint256 i = 100; i < 150; i++) {
2256             _safeMint(address(oldHolders[i]),  i);
2257         }
2258     }
2259     
2260     function migrate4() public onlyOwner  {
2261         for(uint256 i = 150; i < 200; i++) {
2262             _safeMint(address(oldHolders[i]),  i);
2263         }
2264     }
2265     
2266     function migrate5() public onlyOwner  {
2267         for(uint256 i = 200; i < oldHolders.length; i++) {
2268             _safeMint(address(oldHolders[i]),  i);
2269         }
2270     }
2271 }