1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant alphabet = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = alphabet[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 
67 }
68 
69 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
70 
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Library for managing an enumerable variant of Solidity's
78  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
79  * type.
80  *
81  * Maps have the following properties:
82  *
83  * - Entries are added, removed, and checked for existence in constant time
84  * (O(1)).
85  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
86  *
87  * ```
88  * contract Example {
89  *     // Add the library methods
90  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
91  *
92  *     // Declare a set state variable
93  *     EnumerableMap.UintToAddressMap private myMap;
94  * }
95  * ```
96  *
97  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
98  * supported.
99  */
100 library EnumerableMap {
101     // To implement this library for multiple types with as little code
102     // repetition as possible, we write it in terms of a generic Map type with
103     // bytes32 keys and values.
104     // The Map implementation uses private functions, and user-facing
105     // implementations (such as Uint256ToAddressMap) are just wrappers around
106     // the underlying Map.
107     // This means that we can only create new EnumerableMaps for types that fit
108     // in bytes32.
109 
110     struct MapEntry {
111         bytes32 _key;
112         bytes32 _value;
113     }
114 
115     struct Map {
116         // Storage of map keys and values
117         MapEntry[] _entries;
118 
119         // Position of the entry defined by a key in the `entries` array, plus 1
120         // because index 0 means a key is not in the map.
121         mapping (bytes32 => uint256) _indexes;
122     }
123 
124     /**
125      * @dev Adds a key-value pair to a map, or updates the value for an existing
126      * key. O(1).
127      *
128      * Returns true if the key was added to the map, that is if it was not
129      * already present.
130      */
131     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
132         // We read and store the key's index to prevent multiple reads from the same storage slot
133         uint256 keyIndex = map._indexes[key];
134 
135         if (keyIndex == 0) { // Equivalent to !contains(map, key)
136             map._entries.push(MapEntry({ _key: key, _value: value }));
137             // The entry is stored at length-1, but we add 1 to all indexes
138             // and use 0 as a sentinel value
139             map._indexes[key] = map._entries.length;
140             return true;
141         } else {
142             map._entries[keyIndex - 1]._value = value;
143             return false;
144         }
145     }
146 
147     /**
148      * @dev Removes a key-value pair from a map. O(1).
149      *
150      * Returns true if the key was removed from the map, that is if it was present.
151      */
152     function _remove(Map storage map, bytes32 key) private returns (bool) {
153         // We read and store the key's index to prevent multiple reads from the same storage slot
154         uint256 keyIndex = map._indexes[key];
155 
156         if (keyIndex != 0) { // Equivalent to contains(map, key)
157             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
158             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
159             // This modifies the order of the array, as noted in {at}.
160 
161             uint256 toDeleteIndex = keyIndex - 1;
162             uint256 lastIndex = map._entries.length - 1;
163 
164             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
165             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
166 
167             MapEntry storage lastEntry = map._entries[lastIndex];
168 
169             // Move the last entry to the index where the entry to delete is
170             map._entries[toDeleteIndex] = lastEntry;
171             // Update the index for the moved entry
172             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
173 
174             // Delete the slot where the moved entry was stored
175             map._entries.pop();
176 
177             // Delete the index for the deleted slot
178             delete map._indexes[key];
179 
180             return true;
181         } else {
182             return false;
183         }
184     }
185 
186     /**
187      * @dev Returns true if the key is in the map. O(1).
188      */
189     function _contains(Map storage map, bytes32 key) private view returns (bool) {
190         return map._indexes[key] != 0;
191     }
192 
193     /**
194      * @dev Returns the number of key-value pairs in the map. O(1).
195      */
196     function _length(Map storage map) private view returns (uint256) {
197         return map._entries.length;
198     }
199 
200    /**
201     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
202     *
203     * Note that there are no guarantees on the ordering of entries inside the
204     * array, and it may change when more entries are added or removed.
205     *
206     * Requirements:
207     *
208     * - `index` must be strictly less than {length}.
209     */
210     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
211         require(map._entries.length > index, "EnumerableMap: index out of bounds");
212 
213         MapEntry storage entry = map._entries[index];
214         return (entry._key, entry._value);
215     }
216 
217     /**
218      * @dev Tries to returns the value associated with `key`.  O(1).
219      * Does not revert if `key` is not in the map.
220      */
221     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
222         uint256 keyIndex = map._indexes[key];
223         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
224         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
225     }
226 
227     /**
228      * @dev Returns the value associated with `key`.  O(1).
229      *
230      * Requirements:
231      *
232      * - `key` must be in the map.
233      */
234     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
235         uint256 keyIndex = map._indexes[key];
236         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
237         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
238     }
239 
240     /**
241      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
242      *
243      * CAUTION: This function is deprecated because it requires allocating memory for the error
244      * message unnecessarily. For custom revert reasons use {_tryGet}.
245      */
246     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
247         uint256 keyIndex = map._indexes[key];
248         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
249         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
250     }
251 
252     // UintToAddressMap
253 
254     struct UintToAddressMap {
255         Map _inner;
256     }
257 
258     /**
259      * @dev Adds a key-value pair to a map, or updates the value for an existing
260      * key. O(1).
261      *
262      * Returns true if the key was added to the map, that is if it was not
263      * already present.
264      */
265     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
266         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
267     }
268 
269     /**
270      * @dev Removes a value from a set. O(1).
271      *
272      * Returns true if the key was removed from the map, that is if it was present.
273      */
274     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
275         return _remove(map._inner, bytes32(key));
276     }
277 
278     /**
279      * @dev Returns true if the key is in the map. O(1).
280      */
281     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
282         return _contains(map._inner, bytes32(key));
283     }
284 
285     /**
286      * @dev Returns the number of elements in the map. O(1).
287      */
288     function length(UintToAddressMap storage map) internal view returns (uint256) {
289         return _length(map._inner);
290     }
291 
292    /**
293     * @dev Returns the element stored at position `index` in the set. O(1).
294     * Note that there are no guarantees on the ordering of values inside the
295     * array, and it may change when more values are added or removed.
296     *
297     * Requirements:
298     *
299     * - `index` must be strictly less than {length}.
300     */
301     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
302         (bytes32 key, bytes32 value) = _at(map._inner, index);
303         return (uint256(key), address(uint160(uint256(value))));
304     }
305 
306     /**
307      * @dev Tries to returns the value associated with `key`.  O(1).
308      * Does not revert if `key` is not in the map.
309      *
310      * _Available since v3.4._
311      */
312     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
313         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
314         return (success, address(uint160(uint256(value))));
315     }
316 
317     /**
318      * @dev Returns the value associated with `key`.  O(1).
319      *
320      * Requirements:
321      *
322      * - `key` must be in the map.
323      */
324     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
325         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
326     }
327 
328     /**
329      * @dev Same as {get}, with a custom error message when `key` is not in the map.
330      *
331      * CAUTION: This function is deprecated because it requires allocating memory for the error
332      * message unnecessarily. For custom revert reasons use {tryGet}.
333      */
334     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
335         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
336     }
337 }
338 
339 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
340 
341 
342 
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Library for managing
348  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
349  * types.
350  *
351  * Sets have the following properties:
352  *
353  * - Elements are added, removed, and checked for existence in constant time
354  * (O(1)).
355  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
356  *
357  * ```
358  * contract Example {
359  *     // Add the library methods
360  *     using EnumerableSet for EnumerableSet.AddressSet;
361  *
362  *     // Declare a set state variable
363  *     EnumerableSet.AddressSet private mySet;
364  * }
365  * ```
366  *
367  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
368  * and `uint256` (`UintSet`) are supported.
369  */
370 library EnumerableSet {
371     // To implement this library for multiple types with as little code
372     // repetition as possible, we write it in terms of a generic Set type with
373     // bytes32 values.
374     // The Set implementation uses private functions, and user-facing
375     // implementations (such as AddressSet) are just wrappers around the
376     // underlying Set.
377     // This means that we can only create new EnumerableSets for types that fit
378     // in bytes32.
379 
380     struct Set {
381         // Storage of set values
382         bytes32[] _values;
383 
384         // Position of the value in the `values` array, plus 1 because index 0
385         // means a value is not in the set.
386         mapping (bytes32 => uint256) _indexes;
387     }
388 
389     /**
390      * @dev Add a value to a set. O(1).
391      *
392      * Returns true if the value was added to the set, that is if it was not
393      * already present.
394      */
395     function _add(Set storage set, bytes32 value) private returns (bool) {
396         if (!_contains(set, value)) {
397             set._values.push(value);
398             // The value is stored at length-1, but we add 1 to all indexes
399             // and use 0 as a sentinel value
400             set._indexes[value] = set._values.length;
401             return true;
402         } else {
403             return false;
404         }
405     }
406 
407     /**
408      * @dev Removes a value from a set. O(1).
409      *
410      * Returns true if the value was removed from the set, that is if it was
411      * present.
412      */
413     function _remove(Set storage set, bytes32 value) private returns (bool) {
414         // We read and store the value's index to prevent multiple reads from the same storage slot
415         uint256 valueIndex = set._indexes[value];
416 
417         if (valueIndex != 0) { // Equivalent to contains(set, value)
418             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
419             // the array, and then remove the last element (sometimes called as 'swap and pop').
420             // This modifies the order of the array, as noted in {at}.
421 
422             uint256 toDeleteIndex = valueIndex - 1;
423             uint256 lastIndex = set._values.length - 1;
424 
425             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
426             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
427 
428             bytes32 lastvalue = set._values[lastIndex];
429 
430             // Move the last value to the index where the value to delete is
431             set._values[toDeleteIndex] = lastvalue;
432             // Update the index for the moved value
433             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
434 
435             // Delete the slot where the moved value was stored
436             set._values.pop();
437 
438             // Delete the index for the deleted slot
439             delete set._indexes[value];
440 
441             return true;
442         } else {
443             return false;
444         }
445     }
446 
447     /**
448      * @dev Returns true if the value is in the set. O(1).
449      */
450     function _contains(Set storage set, bytes32 value) private view returns (bool) {
451         return set._indexes[value] != 0;
452     }
453 
454     /**
455      * @dev Returns the number of values on the set. O(1).
456      */
457     function _length(Set storage set) private view returns (uint256) {
458         return set._values.length;
459     }
460 
461    /**
462     * @dev Returns the value stored at position `index` in the set. O(1).
463     *
464     * Note that there are no guarantees on the ordering of values inside the
465     * array, and it may change when more values are added or removed.
466     *
467     * Requirements:
468     *
469     * - `index` must be strictly less than {length}.
470     */
471     function _at(Set storage set, uint256 index) private view returns (bytes32) {
472         require(set._values.length > index, "EnumerableSet: index out of bounds");
473         return set._values[index];
474     }
475 
476     // Bytes32Set
477 
478     struct Bytes32Set {
479         Set _inner;
480     }
481 
482     /**
483      * @dev Add a value to a set. O(1).
484      *
485      * Returns true if the value was added to the set, that is if it was not
486      * already present.
487      */
488     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
489         return _add(set._inner, value);
490     }
491 
492     /**
493      * @dev Removes a value from a set. O(1).
494      *
495      * Returns true if the value was removed from the set, that is if it was
496      * present.
497      */
498     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
499         return _remove(set._inner, value);
500     }
501 
502     /**
503      * @dev Returns true if the value is in the set. O(1).
504      */
505     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
506         return _contains(set._inner, value);
507     }
508 
509     /**
510      * @dev Returns the number of values in the set. O(1).
511      */
512     function length(Bytes32Set storage set) internal view returns (uint256) {
513         return _length(set._inner);
514     }
515 
516    /**
517     * @dev Returns the value stored at position `index` in the set. O(1).
518     *
519     * Note that there are no guarantees on the ordering of values inside the
520     * array, and it may change when more values are added or removed.
521     *
522     * Requirements:
523     *
524     * - `index` must be strictly less than {length}.
525     */
526     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
527         return _at(set._inner, index);
528     }
529 
530     // AddressSet
531 
532     struct AddressSet {
533         Set _inner;
534     }
535 
536     /**
537      * @dev Add a value to a set. O(1).
538      *
539      * Returns true if the value was added to the set, that is if it was not
540      * already present.
541      */
542     function add(AddressSet storage set, address value) internal returns (bool) {
543         return _add(set._inner, bytes32(uint256(uint160(value))));
544     }
545 
546     /**
547      * @dev Removes a value from a set. O(1).
548      *
549      * Returns true if the value was removed from the set, that is if it was
550      * present.
551      */
552     function remove(AddressSet storage set, address value) internal returns (bool) {
553         return _remove(set._inner, bytes32(uint256(uint160(value))));
554     }
555 
556     /**
557      * @dev Returns true if the value is in the set. O(1).
558      */
559     function contains(AddressSet storage set, address value) internal view returns (bool) {
560         return _contains(set._inner, bytes32(uint256(uint160(value))));
561     }
562 
563     /**
564      * @dev Returns the number of values in the set. O(1).
565      */
566     function length(AddressSet storage set) internal view returns (uint256) {
567         return _length(set._inner);
568     }
569 
570    /**
571     * @dev Returns the value stored at position `index` in the set. O(1).
572     *
573     * Note that there are no guarantees on the ordering of values inside the
574     * array, and it may change when more values are added or removed.
575     *
576     * Requirements:
577     *
578     * - `index` must be strictly less than {length}.
579     */
580     function at(AddressSet storage set, uint256 index) internal view returns (address) {
581         return address(uint160(uint256(_at(set._inner, index))));
582     }
583 
584 
585     // UintSet
586 
587     struct UintSet {
588         Set _inner;
589     }
590 
591     /**
592      * @dev Add a value to a set. O(1).
593      *
594      * Returns true if the value was added to the set, that is if it was not
595      * already present.
596      */
597     function add(UintSet storage set, uint256 value) internal returns (bool) {
598         return _add(set._inner, bytes32(value));
599     }
600 
601     /**
602      * @dev Removes a value from a set. O(1).
603      *
604      * Returns true if the value was removed from the set, that is if it was
605      * present.
606      */
607     function remove(UintSet storage set, uint256 value) internal returns (bool) {
608         return _remove(set._inner, bytes32(value));
609     }
610 
611     /**
612      * @dev Returns true if the value is in the set. O(1).
613      */
614     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
615         return _contains(set._inner, bytes32(value));
616     }
617 
618     /**
619      * @dev Returns the number of values on the set. O(1).
620      */
621     function length(UintSet storage set) internal view returns (uint256) {
622         return _length(set._inner);
623     }
624 
625    /**
626     * @dev Returns the value stored at position `index` in the set. O(1).
627     *
628     * Note that there are no guarantees on the ordering of values inside the
629     * array, and it may change when more values are added or removed.
630     *
631     * Requirements:
632     *
633     * - `index` must be strictly less than {length}.
634     */
635     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
636         return uint256(_at(set._inner, index));
637     }
638 }
639 
640 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
641 
642 
643 
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @dev Collection of functions related to the address type
649  */
650 library Address {
651     /**
652      * @dev Returns true if `account` is a contract.
653      *
654      * [IMPORTANT]
655      * ====
656      * It is unsafe to assume that an address for which this function returns
657      * false is an externally-owned account (EOA) and not a contract.
658      *
659      * Among others, `isContract` will return false for the following
660      * types of addresses:
661      *
662      *  - an externally-owned account
663      *  - a contract in construction
664      *  - an address where a contract will be created
665      *  - an address where a contract lived, but was destroyed
666      * ====
667      */
668     function isContract(address account) internal view returns (bool) {
669         // This method relies on extcodesize, which returns 0 for contracts in
670         // construction, since the code is only stored at the end of the
671         // constructor execution.
672 
673         uint256 size;
674         // solhint-disable-next-line no-inline-assembly
675         assembly { size := extcodesize(account) }
676         return size > 0;
677     }
678 
679     /**
680      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
681      * `recipient`, forwarding all available gas and reverting on errors.
682      *
683      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
684      * of certain opcodes, possibly making contracts go over the 2300 gas limit
685      * imposed by `transfer`, making them unable to receive funds via
686      * `transfer`. {sendValue} removes this limitation.
687      *
688      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
689      *
690      * IMPORTANT: because control is transferred to `recipient`, care must be
691      * taken to not create reentrancy vulnerabilities. Consider using
692      * {ReentrancyGuard} or the
693      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
694      */
695     function sendValue(address payable recipient, uint256 amount) internal {
696         require(address(this).balance >= amount, "Address: insufficient balance");
697 
698         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
699         (bool success, ) = recipient.call{ value: amount }("");
700         require(success, "Address: unable to send value, recipient may have reverted");
701     }
702 
703     /**
704      * @dev Performs a Solidity function call using a low level `call`. A
705      * plain`call` is an unsafe replacement for a function call: use this
706      * function instead.
707      *
708      * If `target` reverts with a revert reason, it is bubbled up by this
709      * function (like regular Solidity function calls).
710      *
711      * Returns the raw returned data. To convert to the expected return value,
712      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
713      *
714      * Requirements:
715      *
716      * - `target` must be a contract.
717      * - calling `target` with `data` must not revert.
718      *
719      * _Available since v3.1._
720      */
721     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
722       return functionCall(target, data, "Address: low-level call failed");
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
727      * `errorMessage` as a fallback revert reason when `target` reverts.
728      *
729      * _Available since v3.1._
730      */
731     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
732         return functionCallWithValue(target, data, 0, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but also transferring `value` wei to `target`.
738      *
739      * Requirements:
740      *
741      * - the calling contract must have an ETH balance of at least `value`.
742      * - the called Solidity function must be `payable`.
743      *
744      * _Available since v3.1._
745      */
746     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
747         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
752      * with `errorMessage` as a fallback revert reason when `target` reverts.
753      *
754      * _Available since v3.1._
755      */
756     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
757         require(address(this).balance >= value, "Address: insufficient balance for call");
758         require(isContract(target), "Address: call to non-contract");
759 
760         // solhint-disable-next-line avoid-low-level-calls
761         (bool success, bytes memory returndata) = target.call{ value: value }(data);
762         return _verifyCallResult(success, returndata, errorMessage);
763     }
764 
765     /**
766      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
767      * but performing a static call.
768      *
769      * _Available since v3.3._
770      */
771     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
772         return functionStaticCall(target, data, "Address: low-level static call failed");
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
777      * but performing a static call.
778      *
779      * _Available since v3.3._
780      */
781     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
782         require(isContract(target), "Address: static call to non-contract");
783 
784         // solhint-disable-next-line avoid-low-level-calls
785         (bool success, bytes memory returndata) = target.staticcall(data);
786         return _verifyCallResult(success, returndata, errorMessage);
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
791      * but performing a delegate call.
792      *
793      * _Available since v3.4._
794      */
795     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
796         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
801      * but performing a delegate call.
802      *
803      * _Available since v3.4._
804      */
805     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
806         require(isContract(target), "Address: delegate call to non-contract");
807 
808         // solhint-disable-next-line avoid-low-level-calls
809         (bool success, bytes memory returndata) = target.delegatecall(data);
810         return _verifyCallResult(success, returndata, errorMessage);
811     }
812 
813     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
814         if (success) {
815             return returndata;
816         } else {
817             // Look for revert reason and bubble it up if present
818             if (returndata.length > 0) {
819                 // The easiest way to bubble the revert reason is using memory via assembly
820 
821                 // solhint-disable-next-line no-inline-assembly
822                 assembly {
823                     let returndata_size := mload(returndata)
824                     revert(add(32, returndata), returndata_size)
825                 }
826             } else {
827                 revert(errorMessage);
828             }
829         }
830     }
831 }
832 
833 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
834 
835 
836 pragma solidity ^0.8.0;
837 
838 /**
839  * @dev Interface of the ERC165 standard, as defined in the
840  * https://eips.ethereum.org/EIPS/eip-165[EIP].
841  *
842  * Implementers can declare support of contract interfaces, which can then be
843  * queried by others ({ERC165Checker}).
844  *
845  * For an implementation, see {ERC165}.
846  */
847 interface IERC165 {
848     /**
849      * @dev Returns true if this contract implements the interface defined by
850      * `interfaceId`. See the corresponding
851      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
852      * to learn more about how these ids are created.
853      *
854      * This function call must use less than 30 000 gas.
855      */
856     function supportsInterface(bytes4 interfaceId) external view returns (bool);
857 }
858 
859 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
860 
861 
862 pragma solidity ^0.8.0;
863 
864 
865 /**
866  * @dev Implementation of the {IERC165} interface.
867  *
868  * Contracts may inherit from this and call {_registerInterface} to declare
869  * their support of an interface.
870  */
871 abstract contract ERC165 is IERC165 {
872     /**
873      * @dev Mapping of interface ids to whether or not it's supported.
874      */
875     mapping(bytes4 => bool) private _supportedInterfaces;
876 
877     constructor () {
878         // Derived contracts need only register support for their own interfaces,
879         // we register support for ERC165 itself here
880         _registerInterface(type(IERC165).interfaceId);
881     }
882 
883     /**
884      * @dev See {IERC165-supportsInterface}.
885      *
886      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
887      */
888     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
889         return _supportedInterfaces[interfaceId];
890     }
891 
892     /**
893      * @dev Registers the contract as an implementer of the interface defined by
894      * `interfaceId`. Support of the actual ERC165 interface is automatic and
895      * registering its interface id is not required.
896      *
897      * See {IERC165-supportsInterface}.
898      *
899      * Requirements:
900      *
901      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
902      */
903     function _registerInterface(bytes4 interfaceId) internal virtual {
904         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
905         _supportedInterfaces[interfaceId] = true;
906     }
907 }
908 
909 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
910 
911 
912 
913 
914 pragma solidity ^0.8.0;
915 
916 
917 /**
918  * @dev Required interface of an ERC721 compliant contract.
919  */
920 interface IERC721 is IERC165 {
921     /**
922      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
923      */
924     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
925 
926     /**
927      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
928      */
929     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
930 
931     /**
932      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
933      */
934     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
935 
936     /**
937      * @dev Returns the number of tokens in ``owner``'s account.
938      */
939     function balanceOf(address owner) external view returns (uint256 balance);
940 
941     /**
942      * @dev Returns the owner of the `tokenId` token.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function ownerOf(uint256 tokenId) external view returns (address owner);
949 
950     /**
951      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
952      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must exist and be owned by `from`.
959      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function safeTransferFrom(address from, address to, uint256 tokenId) external;
965 
966     /**
967      * @dev Transfers `tokenId` token from `from` to `to`.
968      *
969      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
970      *
971      * Requirements:
972      *
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
977      *
978      * Emits a {Transfer} event.
979      */
980     function transferFrom(address from, address to, uint256 tokenId) external;
981 
982     /**
983      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
984      * The approval is cleared when the token is transferred.
985      *
986      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
987      *
988      * Requirements:
989      *
990      * - The caller must own the token or be an approved operator.
991      * - `tokenId` must exist.
992      *
993      * Emits an {Approval} event.
994      */
995     function approve(address to, uint256 tokenId) external;
996 
997     /**
998      * @dev Returns the account approved for `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function getApproved(uint256 tokenId) external view returns (address operator);
1005 
1006     /**
1007      * @dev Approve or remove `operator` as an operator for the caller.
1008      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1009      *
1010      * Requirements:
1011      *
1012      * - The `operator` cannot be the caller.
1013      *
1014      * Emits an {ApprovalForAll} event.
1015      */
1016     function setApprovalForAll(address operator, bool _approved) external;
1017 
1018     /**
1019      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1020      *
1021      * See {setApprovalForAll}
1022      */
1023     function isApprovedForAll(address owner, address operator) external view returns (bool);
1024 
1025     /**
1026       * @dev Safely transfers `tokenId` token from `from` to `to`.
1027       *
1028       * Requirements:
1029       *
1030       * - `from` cannot be the zero address.
1031       * - `to` cannot be the zero address.
1032       * - `tokenId` token must exist and be owned by `from`.
1033       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1034       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1035       *
1036       * Emits a {Transfer} event.
1037       */
1038     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1039 }
1040 
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 /**
1045  * @title ERC721 token receiver interface
1046  * @dev Interface for any contract that wants to support safeTransfers
1047  * from ERC721 asset contracts.
1048  */
1049 interface IERC721Receiver {
1050     /**
1051      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1052      * by `operator` from `from`, this function is called.
1053      *
1054      * It must return its Solidity selector to confirm the token transfer.
1055      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1056      *
1057      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1058      */
1059     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1060 }
1061 
1062 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1063 
1064 
1065 
1066 
1067 pragma solidity ^0.8.0;
1068 
1069 
1070 /**
1071  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1072  * @dev See https://eips.ethereum.org/EIPS/eip-721
1073  */
1074 interface IERC721Enumerable is IERC721 {
1075 
1076     /**
1077      * @dev Returns the total amount of tokens stored by the contract.
1078      */
1079     function totalSupply() external view returns (uint256);
1080 
1081     /**
1082      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1083      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1084      */
1085     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1086 
1087     /**
1088      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1089      * Use along with {totalSupply} to enumerate all tokens.
1090      */
1091     function tokenByIndex(uint256 index) external view returns (uint256);
1092 }
1093 
1094 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1095 
1096 
1097 
1098 
1099 pragma solidity ^0.8.0;
1100 
1101 
1102 /**
1103  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1104  * @dev See https://eips.ethereum.org/EIPS/eip-721
1105  */
1106 interface IERC721Metadata is IERC721 {
1107 
1108     /**
1109      * @dev Returns the token collection name.
1110      */
1111     function name() external view returns (string memory);
1112 
1113     /**
1114      * @dev Returns the token collection symbol.
1115      */
1116     function symbol() external view returns (string memory);
1117 
1118     /**
1119      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1120      */
1121     function tokenURI(uint256 tokenId) external view returns (string memory);
1122 }
1123 
1124 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1125 
1126 
1127 
1128 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1129 
1130 
1131 
1132 
1133 pragma solidity ^0.8.0;
1134 
1135 /*
1136  * @dev Provides information about the current execution context, including the
1137  * sender of the transaction and its data. While these are generally available
1138  * via msg.sender and msg.data, they should not be accessed in such a direct
1139  * manner, since when dealing with GSN meta-transactions the account sending and
1140  * paying for execution may not be the actual sender (as far as an application
1141  * is concerned).
1142  *
1143  * This contract is only required for intermediate, library-like contracts.
1144  */
1145 abstract contract Context {
1146     function _msgSender() internal view virtual returns (address) {
1147         return msg.sender;
1148     }
1149 
1150     function _msgData() internal view virtual returns (bytes calldata) {
1151         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1152         return msg.data;
1153     }
1154 }
1155 
1156 
1157 
1158 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1159 
1160 
1161 
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 /**
1176  * @title ERC721 Non-Fungible Token Standard basic implementation
1177  * @dev see https://eips.ethereum.org/EIPS/eip-721
1178  */
1179 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1180     using Address for address;
1181     using EnumerableSet for EnumerableSet.UintSet;
1182     using EnumerableMap for EnumerableMap.UintToAddressMap;
1183     using Strings for uint256;
1184 
1185     // Mapping from holder address to their (enumerable) set of owned tokens
1186     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1187 
1188     // Enumerable mapping from token ids to their owners
1189     EnumerableMap.UintToAddressMap private _tokenOwners;
1190 
1191     // Mapping from token ID to approved address
1192     mapping (uint256 => address) private _tokenApprovals;
1193 
1194     // Mapping from owner to operator approvals
1195     mapping (address => mapping (address => bool)) private _operatorApprovals;
1196 
1197     // Token name
1198     string private _name;
1199 
1200     // Token symbol
1201     string private _symbol;
1202 
1203     // Optional mapping for token URIs
1204     mapping (uint256 => string) private _tokenURIs;
1205 
1206     // Base URI
1207     string private _baseURI;
1208 
1209     /**
1210      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1211      */
1212     constructor (string memory name_, string memory symbol_) {
1213         _name = name_;
1214         _symbol = symbol_;
1215 
1216         // register the supported interfaces to conform to ERC721 via ERC165
1217         _registerInterface(type(IERC721).interfaceId);
1218         _registerInterface(type(IERC721Metadata).interfaceId);
1219         _registerInterface(type(IERC721Enumerable).interfaceId);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-balanceOf}.
1224      */
1225     function balanceOf(address owner) public view virtual override returns (uint256) {
1226         require(owner != address(0), "ERC721: balance query for the zero address");
1227         return _holderTokens[owner].length();
1228     }
1229     
1230 
1231     
1232     /**
1233      * @dev See {IERC721-ownerOf}.
1234      */
1235     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1236         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-name}.
1241      */
1242     function name() public view virtual override returns (string memory) {
1243         return _name;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-symbol}.
1248      */
1249     function symbol() public view virtual override returns (string memory) {
1250         return _symbol;
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Metadata-tokenURI}.
1255      */
1256     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1257         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1258 
1259         string memory _tokenURI = _tokenURIs[tokenId];
1260         string memory base = baseURI();
1261 
1262         // If there is no base URI, return the token URI.
1263         if (bytes(base).length == 0) {
1264             return _tokenURI;
1265         }
1266         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1267         if (bytes(_tokenURI).length > 0) {
1268             return string(abi.encodePacked(base, _tokenURI));
1269         }
1270         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1271         return string(abi.encodePacked(base, tokenId.toString()));
1272     }
1273 
1274     /**
1275     * @dev Returns the base URI set via {_setBaseURI}. This will be
1276     * automatically added as a prefix in {tokenURI} to each token's URI, or
1277     * to the token ID if no specific URI is set for that token ID.
1278     */
1279     function baseURI() public view virtual returns (string memory) {
1280         return _baseURI;
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1285      */
1286     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1287         return _holderTokens[owner].at(index);
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-totalSupply}.
1292      */
1293     function totalSupply() public view virtual override returns (uint256) {
1294         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1295         return _tokenOwners.length();
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Enumerable-tokenByIndex}.
1300      */
1301     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1302         (uint256 tokenId, ) = _tokenOwners.at(index);
1303         return tokenId;
1304     }
1305 
1306     /**
1307      * @dev See {IERC721-approve}.
1308      */
1309     function approve(address to, uint256 tokenId) public virtual override {
1310         address owner = ERC721.ownerOf(tokenId);
1311         require(to != owner, "ERC721: approval to current owner");
1312 
1313         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1314             "ERC721: approve caller is not owner nor approved for all"
1315         );
1316 
1317         _approve(to, tokenId);
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-getApproved}.
1322      */
1323     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1324         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1325 
1326         return _tokenApprovals[tokenId];
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-setApprovalForAll}.
1331      */
1332     function setApprovalForAll(address operator, bool approved) public virtual override {
1333         require(operator != _msgSender(), "ERC721: approve to caller");
1334 
1335         _operatorApprovals[_msgSender()][operator] = approved;
1336         emit ApprovalForAll(_msgSender(), operator, approved);
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-isApprovedForAll}.
1341      */
1342     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1343         return _operatorApprovals[owner][operator];
1344     }
1345 
1346     /**
1347      * @dev See {IERC721-transferFrom}.
1348      */
1349     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1350         //solhint-disable-next-line max-line-length
1351         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1352 
1353         _transfer(from, to, tokenId);
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-safeTransferFrom}.
1358      */
1359     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1360         safeTransferFrom(from, to, tokenId, "");
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-safeTransferFrom}.
1365      */
1366     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1367         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1368         _safeTransfer(from, to, tokenId, _data);
1369     }
1370 
1371     /**
1372      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1373      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1374      *
1375      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1376      *
1377      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1378      * implement alternative mechanisms to perform token transfer, such as signature-based.
1379      *
1380      * Requirements:
1381      *
1382      * - `from` cannot be the zero address.
1383      * - `to` cannot be the zero address.
1384      * - `tokenId` token must exist and be owned by `from`.
1385      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1386      *
1387      * Emits a {Transfer} event.
1388      */
1389     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1390         _transfer(from, to, tokenId);
1391         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1392     }
1393 
1394     /**
1395      * @dev Returns whether `tokenId` exists.
1396      *
1397      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1398      *
1399      * Tokens start existing when they are minted (`_mint`),
1400      * and stop existing when they are burned (`_burn`).
1401      */
1402     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1403         return _tokenOwners.contains(tokenId);
1404     }
1405 
1406     /**
1407      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1408      *
1409      * Requirements:
1410      *
1411      * - `tokenId` must exist.
1412      */
1413     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1414         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1415         address owner = ERC721.ownerOf(tokenId);
1416         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1417     }
1418 
1419     /**
1420      * @dev Safely mints `tokenId` and transfers it to `to`.
1421      *
1422      * Requirements:
1423      d*
1424      * - `tokenId` must not exist.
1425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _safeMint(address to, uint256 tokenId) internal virtual {
1430         _safeMint(to, tokenId, "");
1431     }
1432 
1433     /**
1434      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1435      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1436      */
1437     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1438         _mint(to, tokenId);
1439         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1440     }
1441 
1442     /**
1443      * @dev Mints `tokenId` and transfers it to `to`.
1444      *
1445      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1446      *
1447      * Requirements:
1448      *
1449      * - `tokenId` must not exist.
1450      * - `to` cannot be the zero address.
1451      *
1452      * Emits a {Transfer} event.
1453      */
1454     function _mint(address to, uint256 tokenId) internal virtual {
1455         require(to != address(0), "ERC721: mint to the zero address");
1456         require(!_exists(tokenId), "ERC721: token already minted");
1457 
1458         _beforeTokenTransfer(address(0), to, tokenId);
1459 
1460         _holderTokens[to].add(tokenId);
1461 
1462         _tokenOwners.set(tokenId, to);
1463 
1464         emit Transfer(address(0), to, tokenId);
1465     }
1466 
1467     /**
1468      * @dev Destroys `tokenId`.
1469      * The approval is cleared when the token is burned.
1470      *
1471      * Requirements:
1472      *
1473      * - `tokenId` must exist.
1474      *
1475      * Emits a {Transfer} event.
1476      */
1477     function _burn(uint256 tokenId) internal virtual {
1478         address owner = ERC721.ownerOf(tokenId); // internal owner
1479 
1480         _beforeTokenTransfer(owner, address(0), tokenId);
1481 
1482         // Clear approvals
1483         _approve(address(0), tokenId);
1484 
1485         // Clear metadata (if any)
1486         if (bytes(_tokenURIs[tokenId]).length != 0) {
1487             delete _tokenURIs[tokenId];
1488         }
1489 
1490         _holderTokens[owner].remove(tokenId);
1491 
1492         _tokenOwners.remove(tokenId);
1493 
1494         emit Transfer(owner, address(0), tokenId);
1495     }
1496 
1497     /**
1498      * @dev Transfers `tokenId` from `from` to `to`.
1499      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1500      *
1501      * Requirements:
1502      *
1503      * - `to` cannot be the zero address.
1504      * - `tokenId` token must be owned by `from`.
1505      *
1506      * Emits a {Transfer} event.
1507      */
1508     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1509         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1510         require(to != address(0), "ERC721: transfer to the zero address");
1511 
1512         _beforeTokenTransfer(from, to, tokenId);
1513 
1514         // Clear approvals from the previous owner
1515         _approve(address(0), tokenId);
1516 
1517         _holderTokens[from].remove(tokenId);
1518         _holderTokens[to].add(tokenId);
1519 
1520         _tokenOwners.set(tokenId, to);
1521 
1522         emit Transfer(from, to, tokenId);
1523     }
1524 
1525     /**
1526      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1527      *
1528      * Requirements:
1529      *
1530      * - `tokenId` must exist.
1531      */
1532     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1533         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1534         _tokenURIs[tokenId] = _tokenURI;
1535     }
1536 
1537     /**
1538      * @dev Internal function to set the base URI for all token IDs. It is
1539      * automatically added as a prefix to the value returned in {tokenURI},
1540      * or to the token ID if {tokenURI} is empty.
1541      */
1542     function _setBaseURI(string memory baseURI_) internal virtual {
1543         _baseURI = baseURI_;
1544     }
1545 
1546     /**
1547      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1548      * The call is not executed if the target address is not a contract.
1549      *
1550      * @param from address representing the previous owner of the given token ID
1551      * @param to target address that will receive the tokens
1552      * @param tokenId uint256 ID of the token to be transferred
1553      * @param _data bytes optional data to send along with the call
1554      * @return bool whether the call correctly returned the expected magic value
1555      */
1556     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1557         private returns (bool)
1558     {
1559         if (to.isContract()) {
1560             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1561                 return retval == IERC721Receiver(to).onERC721Received.selector;
1562             } catch (bytes memory reason) {
1563                 if (reason.length == 0) {
1564                     revert("ERC721: transfer to non ERC721Receiver implementer");
1565                 } else {
1566                     // solhint-disable-next-line no-inline-assembly
1567                     assembly {
1568                         revert(add(32, reason), mload(reason))
1569                     }
1570                 }
1571             }
1572         } else {
1573             return true;
1574         }
1575     }
1576 
1577     function _approve(address to, uint256 tokenId) private {
1578         _tokenApprovals[tokenId] = to;
1579         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1580     }
1581 
1582     /**
1583      * @dev Hook that is called before any token transfer. This includes minting
1584      * and burning.
1585      *
1586      * Calling conditions:
1587      *
1588      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1589      * transferred to `to`.
1590      * - When `from` is zero, `tokenId` will be minted for `to`.
1591      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1592      * - `from` cannot be the zero address.
1593      * - `to` cannot be the zero address.
1594      *
1595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1596      */
1597     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1598 }
1599 
1600 
1601 
1602 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1603 
1604 
1605 
1606 
1607 pragma solidity ^0.8.0;
1608 
1609 /**
1610  * @dev Contract module which provides a basic access control mechanism, where
1611  * there is an account (an owner) that can be granted exclusive access to
1612  * specific functions.
1613  *
1614  * By default, the owner account will be the one that deploys the contract. This
1615  * can later be changed with {transferOwnership}.
1616  *
1617  * This module is used through inheritance. It will make available the modifier
1618  * `onlyOwner`, which can be applied to your functions to restrict their use to
1619  * the owner.
1620  */
1621 abstract contract Ownable is Context {
1622     address private _owner;
1623 
1624     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1625 
1626     /**
1627      * @dev Initializes the contract setting the deployer as the initial owner.
1628      */
1629     constructor () {
1630         address msgSender = _msgSender();
1631         _owner = msgSender;
1632         emit OwnershipTransferred(address(0), msgSender);
1633     }
1634 
1635     /**
1636      * @dev Returns the address of the current owner.
1637      */
1638     function owner() public view virtual returns (address) {
1639         return _owner;
1640     }
1641 
1642     /**
1643      * @dev Throws if called by any account other than the owner.
1644      */
1645     modifier onlyOwner() {
1646         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1647         _;
1648     }
1649 
1650     /**
1651      * @dev Leaves the contract without owner. It will not be possible to call
1652      * `onlyOwner` functions anymore. Can only be called by the current owner.
1653      *
1654      * NOTE: Renouncing ownership will leave the contract without an owner,
1655      * thereby removing any functionality that is only available to the owner.
1656      */
1657     function renounceOwnership() public virtual onlyOwner {
1658         emit OwnershipTransferred(_owner, address(0));
1659         _owner = address(0);
1660     }
1661 
1662     /**
1663      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1664      * Can only be called by the current owner.
1665      */
1666     function transferOwnership(address newOwner) public virtual onlyOwner {
1667         require(newOwner != address(0), "Ownable: new owner is the zero address");
1668         emit OwnershipTransferred(_owner, newOwner);
1669         _owner = newOwner;
1670     }
1671 }
1672 
1673 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1674 
1675 
1676 
1677 
1678 pragma solidity ^0.8.0;
1679 
1680 // CAUTION
1681 // This version of SafeMath should only be used with Solidity 0.8 or later,
1682 // because it relies on the compiler's built in overflow checks.
1683 
1684 /**
1685  * @dev Wrappers over Solidity's arithmetic operations.
1686  *
1687  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1688  * now has built in overflow checking.
1689  */
1690 library SafeMath {
1691     /**
1692      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1693      *
1694      * _Available since v3.4._
1695      */
1696     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1697         unchecked {
1698             uint256 c = a + b;
1699             if (c < a) return (false, 0);
1700             return (true, c);
1701         }
1702     }
1703 
1704     /**
1705      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1706      *
1707      * _Available since v3.4._
1708      */
1709     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1710         unchecked {
1711             if (b > a) return (false, 0);
1712             return (true, a - b);
1713         }
1714     }
1715 
1716     /**
1717      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1718      *
1719      * _Available since v3.4._
1720      */
1721     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1722         unchecked {
1723             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1724             // benefit is lost if 'b' is also tested.
1725             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1726             if (a == 0) return (true, 0);
1727             uint256 c = a * b;
1728             if (c / a != b) return (false, 0);
1729             return (true, c);
1730         }
1731     }
1732 
1733     /**
1734      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1735      *
1736      * _Available since v3.4._
1737      */
1738     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1739         unchecked {
1740             if (b == 0) return (false, 0);
1741             return (true, a / b);
1742         }
1743     }
1744 
1745     /**
1746      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1747      *
1748      * _Available since v3.4._
1749      */
1750     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1751         unchecked {
1752             if (b == 0) return (false, 0);
1753             return (true, a % b);
1754         }
1755     }
1756 
1757     /**
1758      * @dev Returns the addition of two unsigned integers, reverting on
1759      * overflow.
1760      *
1761      * Counterpart to Solidity's `+` operator.
1762      *
1763      * Requirements:
1764      *
1765      * - Addition cannot overflow.
1766      */
1767     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1768         return a + b;
1769     }
1770 
1771     /**
1772      * @dev Returns the subtraction of two unsigned integers, reverting on
1773      * overflow (when the result is negative).
1774      *
1775      * Counterpart to Solidity's `-` operator.
1776      *
1777      * Requirements:
1778      *
1779      * - Subtraction cannot overflow.
1780      */
1781     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1782         return a - b;
1783     }
1784 
1785     /**
1786      * @dev Returns the multiplication of two unsigned integers, reverting on
1787      * overflow.
1788      *
1789      * Counterpart to Solidity's `*` operator.
1790      *
1791      * Requirements:
1792      *
1793      * - Multiplication cannot overflow.
1794      */
1795     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1796         return a * b;
1797     }
1798 
1799     /**
1800      * @dev Returns the integer division of two unsigned integers, reverting on
1801      * division by zero. The result is rounded towards zero.
1802      *
1803      * Counterpart to Solidity's `/` operator.
1804      *
1805      * Requirements:
1806      *
1807      * - The divisor cannot be zero.
1808      */
1809     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1810         return a / b;
1811     }
1812 
1813     /**
1814      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1815      * reverting when dividing by zero.
1816      *
1817      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1818      * opcode (which leaves remaining gas untouched) while Solidity uses an
1819      * invalid opcode to revert (consuming all remaining gas).
1820      *
1821      * Requirements:
1822      *
1823      * - The divisor cannot be zero.
1824      */
1825     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1826         return a % b;
1827     }
1828 
1829     /**
1830      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1831      * overflow (when the result is negative).
1832      *
1833      * CAUTION: This function is deprecated because it requires allocating memory for the error
1834      * message unnecessarily. For custom revert reasons use {trySub}.
1835      *
1836      * Counterpart to Solidity's `-` operator.
1837      *
1838      * Requirements:
1839      *
1840      * - Subtraction cannot overflow.
1841      */
1842     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1843         unchecked {
1844             require(b <= a, errorMessage);
1845             return a - b;
1846         }
1847     }
1848 
1849     /**
1850      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1851      * division by zero. The result is rounded towards zero.
1852      *
1853      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1854      * opcode (which leaves remaining gas untouched) while Solidity uses an
1855      * invalid opcode to revert (consuming all remaining gas).
1856      *
1857      * Counterpart to Solidity's `/` operator. Note: this function uses a
1858      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1859      * uses an invalid opcode to revert (consuming all remaining gas).
1860      *
1861      * Requirements:
1862      *
1863      * - The divisor cannot be zero.
1864      */
1865     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1866         unchecked {
1867             require(b > 0, errorMessage);
1868             return a / b;
1869         }
1870     }
1871 
1872     /**
1873      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1874      * reverting with custom message when dividing by zero.
1875      *
1876      * CAUTION: This function is deprecated because it requires allocating memory for the error
1877      * message unnecessarily. For custom revert reasons use {tryMod}.
1878      *
1879      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1880      * opcode (which leaves remaining gas untouched) while Solidity uses an
1881      * invalid opcode to revert (consuming all remaining gas).
1882      *
1883      * Requirements:
1884      *
1885      * - The divisor cannot be zero.
1886      */
1887     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1888         unchecked {
1889             require(b > 0, errorMessage);
1890             return a % b;
1891         }
1892     }
1893 }
1894 
1895 
1896 pragma solidity ^0.8.0;
1897 
1898 
1899 contract UnitedPunksUnion is ERC721, Ownable {
1900     
1901     using SafeMath for uint256;
1902     uint public constant MAX_UNITEDPUNKSUNION = 13666;
1903     bool public hasSaleStarted = true;
1904     uint public constant UNITEDPUNKSUNION_PRICE = 30000000000000000;
1905 
1906     string public METADATA_PROVENANCE_HASH = "";
1907     
1908     constructor() ERC721("UnitedPunksUnion","UPU")  { }
1909     
1910     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1911         uint256 tokenCount = balanceOf(_owner);
1912         if (tokenCount == 0) {
1913             // Return an empty array
1914             return new uint256[](0);
1915         } else {
1916             uint256[] memory result = new uint256[](tokenCount);
1917             uint256 index;
1918             for (index = 0; index < tokenCount; index++) {
1919                 result[index] = tokenOfOwnerByIndex(_owner, index);
1920             }
1921             return result;
1922         }
1923     }
1924     
1925    function buy(uint256 numPunks) public payable {
1926         require(totalSupply() < MAX_UNITEDPUNKSUNION, "Sale has already ended");
1927         require(numPunks > 0 && numPunks <= 20, "You can adopt minimum 1, maximum 20 United Union Punks");
1928         require(totalSupply().add(numPunks) <= MAX_UNITEDPUNKSUNION, "Exceeds MAX_UNITEDPUNKSUNION");
1929         require(msg.value >= UNITEDPUNKSUNION_PRICE.mul(numPunks), "Ether value sent is below the price");
1930 
1931         for (uint i = 0; i < numPunks; i++) {
1932             uint mintIndex = totalSupply();
1933             _safeMint(msg.sender, mintIndex);
1934         }
1935 
1936     }
1937         function getPrice(uint _count) public view returns (uint256) {
1938         uint256 returnVal = 0;
1939         if(totalSupply() <= MAX_UNITEDPUNKSUNION ){
1940            returnVal = UNITEDPUNKSUNION_PRICE * _count; // 0.03 ETH
1941         }
1942 
1943         return returnVal;
1944     }
1945 
1946     // ONLYOWNER FUNCTIONS
1947     
1948     function setProvenanceHash(string memory _hash) public onlyOwner {
1949         METADATA_PROVENANCE_HASH = _hash;
1950     }
1951     
1952 function giveGift(address _address, uint numPunks) public onlyOwner {
1953         uint mintIndex = totalSupply();
1954         require(mintIndex < 240);
1955         require(totalSupply().add(numPunks) <= 240, "Exceeds MAX_UNITEDPUNKSUNION");
1956         for (uint i = 0; i < numPunks; i++) {
1957             _safeMint(_address, mintIndex + i);
1958         }
1959     }
1960     
1961     function setBaseURI(string memory baseURI) public onlyOwner {
1962         _setBaseURI(baseURI);
1963     }
1964     
1965     function startDrop() public onlyOwner {
1966         hasSaleStarted = true;
1967     }
1968     
1969     function pauseDrop() public onlyOwner {
1970         hasSaleStarted = false;
1971     }
1972     
1973     function withdraw() public payable onlyOwner {
1974         require(payable(msg.sender).send(address(this).balance));
1975     }
1976     
1977 }
1978 
1979 // Upgraded United CryptoPunks Smart Contract "United Punks Union"
1980 // Punks not dead!
1981 // Special thanks to @berkozdemir @mmtiglioglu