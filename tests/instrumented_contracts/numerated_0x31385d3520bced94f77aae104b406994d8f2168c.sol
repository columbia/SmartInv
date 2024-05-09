1 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant alphabet = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = alphabet[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71 }
72 
73 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
74 
75 
76 
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Library for managing an enumerable variant of Solidity's
82  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
83  * type.
84  *
85  * Maps have the following properties:
86  *
87  * - Entries are added, removed, and checked for existence in constant time
88  * (O(1)).
89  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
90  *
91  * ```
92  * contract Example {
93  *     // Add the library methods
94  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
95  *
96  *     // Declare a set state variable
97  *     EnumerableMap.UintToAddressMap private myMap;
98  * }
99  * ```
100  *
101  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
102  * supported.
103  */
104 library EnumerableMap {
105     // To implement this library for multiple types with as little code
106     // repetition as possible, we write it in terms of a generic Map type with
107     // bytes32 keys and values.
108     // The Map implementation uses private functions, and user-facing
109     // implementations (such as Uint256ToAddressMap) are just wrappers around
110     // the underlying Map.
111     // This means that we can only create new EnumerableMaps for types that fit
112     // in bytes32.
113 
114     struct MapEntry {
115         bytes32 _key;
116         bytes32 _value;
117     }
118 
119     struct Map {
120         // Storage of map keys and values
121         MapEntry[] _entries;
122 
123         // Position of the entry defined by a key in the `entries` array, plus 1
124         // because index 0 means a key is not in the map.
125         mapping (bytes32 => uint256) _indexes;
126     }
127 
128     /**
129      * @dev Adds a key-value pair to a map, or updates the value for an existing
130      * key. O(1).
131      *
132      * Returns true if the key was added to the map, that is if it was not
133      * already present.
134      */
135     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
136         // We read and store the key's index to prevent multiple reads from the same storage slot
137         uint256 keyIndex = map._indexes[key];
138 
139         if (keyIndex == 0) { // Equivalent to !contains(map, key)
140             map._entries.push(MapEntry({ _key: key, _value: value }));
141             // The entry is stored at length-1, but we add 1 to all indexes
142             // and use 0 as a sentinel value
143             map._indexes[key] = map._entries.length;
144             return true;
145         } else {
146             map._entries[keyIndex - 1]._value = value;
147             return false;
148         }
149     }
150 
151     /**
152      * @dev Removes a key-value pair from a map. O(1).
153      *
154      * Returns true if the key was removed from the map, that is if it was present.
155      */
156     function _remove(Map storage map, bytes32 key) private returns (bool) {
157         // We read and store the key's index to prevent multiple reads from the same storage slot
158         uint256 keyIndex = map._indexes[key];
159 
160         if (keyIndex != 0) { // Equivalent to contains(map, key)
161             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
162             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
163             // This modifies the order of the array, as noted in {at}.
164 
165             uint256 toDeleteIndex = keyIndex - 1;
166             uint256 lastIndex = map._entries.length - 1;
167 
168             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
169             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
170 
171             MapEntry storage lastEntry = map._entries[lastIndex];
172 
173             // Move the last entry to the index where the entry to delete is
174             map._entries[toDeleteIndex] = lastEntry;
175             // Update the index for the moved entry
176             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
177 
178             // Delete the slot where the moved entry was stored
179             map._entries.pop();
180 
181             // Delete the index for the deleted slot
182             delete map._indexes[key];
183 
184             return true;
185         } else {
186             return false;
187         }
188     }
189 
190     /**
191      * @dev Returns true if the key is in the map. O(1).
192      */
193     function _contains(Map storage map, bytes32 key) private view returns (bool) {
194         return map._indexes[key] != 0;
195     }
196 
197     /**
198      * @dev Returns the number of key-value pairs in the map. O(1).
199      */
200     function _length(Map storage map) private view returns (uint256) {
201         return map._entries.length;
202     }
203 
204    /**
205     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
206     *
207     * Note that there are no guarantees on the ordering of entries inside the
208     * array, and it may change when more entries are added or removed.
209     *
210     * Requirements:
211     *
212     * - `index` must be strictly less than {length}.
213     */
214     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
215         require(map._entries.length > index, "EnumerableMap: index out of bounds");
216 
217         MapEntry storage entry = map._entries[index];
218         return (entry._key, entry._value);
219     }
220 
221     /**
222      * @dev Tries to returns the value associated with `key`.  O(1).
223      * Does not revert if `key` is not in the map.
224      */
225     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
226         uint256 keyIndex = map._indexes[key];
227         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
228         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
229     }
230 
231     /**
232      * @dev Returns the value associated with `key`.  O(1).
233      *
234      * Requirements:
235      *
236      * - `key` must be in the map.
237      */
238     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
239         uint256 keyIndex = map._indexes[key];
240         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
241         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
242     }
243 
244     /**
245      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
246      *
247      * CAUTION: This function is deprecated because it requires allocating memory for the error
248      * message unnecessarily. For custom revert reasons use {_tryGet}.
249      */
250     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
251         uint256 keyIndex = map._indexes[key];
252         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
253         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
254     }
255 
256     // UintToAddressMap
257 
258     struct UintToAddressMap {
259         Map _inner;
260     }
261 
262     /**
263      * @dev Adds a key-value pair to a map, or updates the value for an existing
264      * key. O(1).
265      *
266      * Returns true if the key was added to the map, that is if it was not
267      * already present.
268      */
269     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
270         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
271     }
272 
273     /**
274      * @dev Removes a value from a set. O(1).
275      *
276      * Returns true if the key was removed from the map, that is if it was present.
277      */
278     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
279         return _remove(map._inner, bytes32(key));
280     }
281 
282     /**
283      * @dev Returns true if the key is in the map. O(1).
284      */
285     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
286         return _contains(map._inner, bytes32(key));
287     }
288 
289     /**
290      * @dev Returns the number of elements in the map. O(1).
291      */
292     function length(UintToAddressMap storage map) internal view returns (uint256) {
293         return _length(map._inner);
294     }
295 
296    /**
297     * @dev Returns the element stored at position `index` in the set. O(1).
298     * Note that there are no guarantees on the ordering of values inside the
299     * array, and it may change when more values are added or removed.
300     *
301     * Requirements:
302     *
303     * - `index` must be strictly less than {length}.
304     */
305     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
306         (bytes32 key, bytes32 value) = _at(map._inner, index);
307         return (uint256(key), address(uint160(uint256(value))));
308     }
309 
310     /**
311      * @dev Tries to returns the value associated with `key`.  O(1).
312      * Does not revert if `key` is not in the map.
313      *
314      * _Available since v3.4._
315      */
316     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
317         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
318         return (success, address(uint160(uint256(value))));
319     }
320 
321     /**
322      * @dev Returns the value associated with `key`.  O(1).
323      *
324      * Requirements:
325      *
326      * - `key` must be in the map.
327      */
328     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
329         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
330     }
331 
332     /**
333      * @dev Same as {get}, with a custom error message when `key` is not in the map.
334      *
335      * CAUTION: This function is deprecated because it requires allocating memory for the error
336      * message unnecessarily. For custom revert reasons use {tryGet}.
337      */
338     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
339         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
340     }
341 }
342 
343 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
344 
345 
346 
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Library for managing
352  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
353  * types.
354  *
355  * Sets have the following properties:
356  *
357  * - Elements are added, removed, and checked for existence in constant time
358  * (O(1)).
359  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
360  *
361  * ```
362  * contract Example {
363  *     // Add the library methods
364  *     using EnumerableSet for EnumerableSet.AddressSet;
365  *
366  *     // Declare a set state variable
367  *     EnumerableSet.AddressSet private mySet;
368  * }
369  * ```
370  *
371  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
372  * and `uint256` (`UintSet`) are supported.
373  */
374 library EnumerableSet {
375     // To implement this library for multiple types with as little code
376     // repetition as possible, we write it in terms of a generic Set type with
377     // bytes32 values.
378     // The Set implementation uses private functions, and user-facing
379     // implementations (such as AddressSet) are just wrappers around the
380     // underlying Set.
381     // This means that we can only create new EnumerableSets for types that fit
382     // in bytes32.
383 
384     struct Set {
385         // Storage of set values
386         bytes32[] _values;
387 
388         // Position of the value in the `values` array, plus 1 because index 0
389         // means a value is not in the set.
390         mapping (bytes32 => uint256) _indexes;
391     }
392 
393     /**
394      * @dev Add a value to a set. O(1).
395      *
396      * Returns true if the value was added to the set, that is if it was not
397      * already present.
398      */
399     function _add(Set storage set, bytes32 value) private returns (bool) {
400         if (!_contains(set, value)) {
401             set._values.push(value);
402             // The value is stored at length-1, but we add 1 to all indexes
403             // and use 0 as a sentinel value
404             set._indexes[value] = set._values.length;
405             return true;
406         } else {
407             return false;
408         }
409     }
410 
411     /**
412      * @dev Removes a value from a set. O(1).
413      *
414      * Returns true if the value was removed from the set, that is if it was
415      * present.
416      */
417     function _remove(Set storage set, bytes32 value) private returns (bool) {
418         // We read and store the value's index to prevent multiple reads from the same storage slot
419         uint256 valueIndex = set._indexes[value];
420 
421         if (valueIndex != 0) { // Equivalent to contains(set, value)
422             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
423             // the array, and then remove the last element (sometimes called as 'swap and pop').
424             // This modifies the order of the array, as noted in {at}.
425 
426             uint256 toDeleteIndex = valueIndex - 1;
427             uint256 lastIndex = set._values.length - 1;
428 
429             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
430             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
431 
432             bytes32 lastvalue = set._values[lastIndex];
433 
434             // Move the last value to the index where the value to delete is
435             set._values[toDeleteIndex] = lastvalue;
436             // Update the index for the moved value
437             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
438 
439             // Delete the slot where the moved value was stored
440             set._values.pop();
441 
442             // Delete the index for the deleted slot
443             delete set._indexes[value];
444 
445             return true;
446         } else {
447             return false;
448         }
449     }
450 
451     /**
452      * @dev Returns true if the value is in the set. O(1).
453      */
454     function _contains(Set storage set, bytes32 value) private view returns (bool) {
455         return set._indexes[value] != 0;
456     }
457 
458     /**
459      * @dev Returns the number of values on the set. O(1).
460      */
461     function _length(Set storage set) private view returns (uint256) {
462         return set._values.length;
463     }
464 
465    /**
466     * @dev Returns the value stored at position `index` in the set. O(1).
467     *
468     * Note that there are no guarantees on the ordering of values inside the
469     * array, and it may change when more values are added or removed.
470     *
471     * Requirements:
472     *
473     * - `index` must be strictly less than {length}.
474     */
475     function _at(Set storage set, uint256 index) private view returns (bytes32) {
476         require(set._values.length > index, "EnumerableSet: index out of bounds");
477         return set._values[index];
478     }
479 
480     // Bytes32Set
481 
482     struct Bytes32Set {
483         Set _inner;
484     }
485 
486     /**
487      * @dev Add a value to a set. O(1).
488      *
489      * Returns true if the value was added to the set, that is if it was not
490      * already present.
491      */
492     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
493         return _add(set._inner, value);
494     }
495 
496     /**
497      * @dev Removes a value from a set. O(1).
498      *
499      * Returns true if the value was removed from the set, that is if it was
500      * present.
501      */
502     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
503         return _remove(set._inner, value);
504     }
505 
506     /**
507      * @dev Returns true if the value is in the set. O(1).
508      */
509     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
510         return _contains(set._inner, value);
511     }
512 
513     /**
514      * @dev Returns the number of values in the set. O(1).
515      */
516     function length(Bytes32Set storage set) internal view returns (uint256) {
517         return _length(set._inner);
518     }
519 
520    /**
521     * @dev Returns the value stored at position `index` in the set. O(1).
522     *
523     * Note that there are no guarantees on the ordering of values inside the
524     * array, and it may change when more values are added or removed.
525     *
526     * Requirements:
527     *
528     * - `index` must be strictly less than {length}.
529     */
530     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
531         return _at(set._inner, index);
532     }
533 
534     // AddressSet
535 
536     struct AddressSet {
537         Set _inner;
538     }
539 
540     /**
541      * @dev Add a value to a set. O(1).
542      *
543      * Returns true if the value was added to the set, that is if it was not
544      * already present.
545      */
546     function add(AddressSet storage set, address value) internal returns (bool) {
547         return _add(set._inner, bytes32(uint256(uint160(value))));
548     }
549 
550     /**
551      * @dev Removes a value from a set. O(1).
552      *
553      * Returns true if the value was removed from the set, that is if it was
554      * present.
555      */
556     function remove(AddressSet storage set, address value) internal returns (bool) {
557         return _remove(set._inner, bytes32(uint256(uint160(value))));
558     }
559 
560     /**
561      * @dev Returns true if the value is in the set. O(1).
562      */
563     function contains(AddressSet storage set, address value) internal view returns (bool) {
564         return _contains(set._inner, bytes32(uint256(uint160(value))));
565     }
566 
567     /**
568      * @dev Returns the number of values in the set. O(1).
569      */
570     function length(AddressSet storage set) internal view returns (uint256) {
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
584     function at(AddressSet storage set, uint256 index) internal view returns (address) {
585         return address(uint160(uint256(_at(set._inner, index))));
586     }
587 
588 
589     // UintSet
590 
591     struct UintSet {
592         Set _inner;
593     }
594 
595     /**
596      * @dev Add a value to a set. O(1).
597      *
598      * Returns true if the value was added to the set, that is if it was not
599      * already present.
600      */
601     function add(UintSet storage set, uint256 value) internal returns (bool) {
602         return _add(set._inner, bytes32(value));
603     }
604 
605     /**
606      * @dev Removes a value from a set. O(1).
607      *
608      * Returns true if the value was removed from the set, that is if it was
609      * present.
610      */
611     function remove(UintSet storage set, uint256 value) internal returns (bool) {
612         return _remove(set._inner, bytes32(value));
613     }
614 
615     /**
616      * @dev Returns true if the value is in the set. O(1).
617      */
618     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
619         return _contains(set._inner, bytes32(value));
620     }
621 
622     /**
623      * @dev Returns the number of values on the set. O(1).
624      */
625     function length(UintSet storage set) internal view returns (uint256) {
626         return _length(set._inner);
627     }
628 
629    /**
630     * @dev Returns the value stored at position `index` in the set. O(1).
631     *
632     * Note that there are no guarantees on the ordering of values inside the
633     * array, and it may change when more values are added or removed.
634     *
635     * Requirements:
636     *
637     * - `index` must be strictly less than {length}.
638     */
639     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
640         return uint256(_at(set._inner, index));
641     }
642 }
643 
644 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
645 
646 
647 
648 
649 pragma solidity ^0.8.0;
650 
651 /**
652  * @dev Collection of functions related to the address type
653  */
654 library Address {
655     /**
656      * @dev Returns true if `account` is a contract.
657      *
658      * [IMPORTANT]
659      * ====
660      * It is unsafe to assume that an address for which this function returns
661      * false is an externally-owned account (EOA) and not a contract.
662      *
663      * Among others, `isContract` will return false for the following
664      * types of addresses:
665      *
666      *  - an externally-owned account
667      *  - a contract in construction
668      *  - an address where a contract will be created
669      *  - an address where a contract lived, but was destroyed
670      * ====
671      */
672     function isContract(address account) internal view returns (bool) {
673         // This method relies on extcodesize, which returns 0 for contracts in
674         // construction, since the code is only stored at the end of the
675         // constructor execution.
676 
677         uint256 size;
678         // solhint-disable-next-line no-inline-assembly
679         assembly { size := extcodesize(account) }
680         return size > 0;
681     }
682 
683     /**
684      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
685      * `recipient`, forwarding all available gas and reverting on errors.
686      *
687      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
688      * of certain opcodes, possibly making contracts go over the 2300 gas limit
689      * imposed by `transfer`, making them unable to receive funds via
690      * `transfer`. {sendValue} removes this limitation.
691      *
692      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
693      *
694      * IMPORTANT: because control is transferred to `recipient`, care must be
695      * taken to not create reentrancy vulnerabilities. Consider using
696      * {ReentrancyGuard} or the
697      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
698      */
699     function sendValue(address payable recipient, uint256 amount) internal {
700         require(address(this).balance >= amount, "Address: insufficient balance");
701 
702         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
703         (bool success, ) = recipient.call{ value: amount }("");
704         require(success, "Address: unable to send value, recipient may have reverted");
705     }
706 
707     /**
708      * @dev Performs a Solidity function call using a low level `call`. A
709      * plain`call` is an unsafe replacement for a function call: use this
710      * function instead.
711      *
712      * If `target` reverts with a revert reason, it is bubbled up by this
713      * function (like regular Solidity function calls).
714      *
715      * Returns the raw returned data. To convert to the expected return value,
716      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
717      *
718      * Requirements:
719      *
720      * - `target` must be a contract.
721      * - calling `target` with `data` must not revert.
722      *
723      * _Available since v3.1._
724      */
725     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
726       return functionCall(target, data, "Address: low-level call failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
731      * `errorMessage` as a fallback revert reason when `target` reverts.
732      *
733      * _Available since v3.1._
734      */
735     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
736         return functionCallWithValue(target, data, 0, errorMessage);
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
741      * but also transferring `value` wei to `target`.
742      *
743      * Requirements:
744      *
745      * - the calling contract must have an ETH balance of at least `value`.
746      * - the called Solidity function must be `payable`.
747      *
748      * _Available since v3.1._
749      */
750     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
751         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
756      * with `errorMessage` as a fallback revert reason when `target` reverts.
757      *
758      * _Available since v3.1._
759      */
760     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
761         require(address(this).balance >= value, "Address: insufficient balance for call");
762         require(isContract(target), "Address: call to non-contract");
763 
764         // solhint-disable-next-line avoid-low-level-calls
765         (bool success, bytes memory returndata) = target.call{ value: value }(data);
766         return _verifyCallResult(success, returndata, errorMessage);
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
771      * but performing a static call.
772      *
773      * _Available since v3.3._
774      */
775     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
776         return functionStaticCall(target, data, "Address: low-level static call failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
786         require(isContract(target), "Address: static call to non-contract");
787 
788         // solhint-disable-next-line avoid-low-level-calls
789         (bool success, bytes memory returndata) = target.staticcall(data);
790         return _verifyCallResult(success, returndata, errorMessage);
791     }
792 
793     /**
794      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
795      * but performing a delegate call.
796      *
797      * _Available since v3.4._
798      */
799     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
800         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
801     }
802 
803     /**
804      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
805      * but performing a delegate call.
806      *
807      * _Available since v3.4._
808      */
809     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
810         require(isContract(target), "Address: delegate call to non-contract");
811 
812         // solhint-disable-next-line avoid-low-level-calls
813         (bool success, bytes memory returndata) = target.delegatecall(data);
814         return _verifyCallResult(success, returndata, errorMessage);
815     }
816 
817     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
818         if (success) {
819             return returndata;
820         } else {
821             // Look for revert reason and bubble it up if present
822             if (returndata.length > 0) {
823                 // The easiest way to bubble the revert reason is using memory via assembly
824 
825                 // solhint-disable-next-line no-inline-assembly
826                 assembly {
827                     let returndata_size := mload(returndata)
828                     revert(add(32, returndata), returndata_size)
829                 }
830             } else {
831                 revert(errorMessage);
832             }
833         }
834     }
835 }
836 
837 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
838 
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @dev Interface of the ERC165 standard, as defined in the
844  * https://eips.ethereum.org/EIPS/eip-165[EIP].
845  *
846  * Implementers can declare support of contract interfaces, which can then be
847  * queried by others ({ERC165Checker}).
848  *
849  * For an implementation, see {ERC165}.
850  */
851 interface IERC165 {
852     /**
853      * @dev Returns true if this contract implements the interface defined by
854      * `interfaceId`. See the corresponding
855      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
856      * to learn more about how these ids are created.
857      *
858      * This function call must use less than 30 000 gas.
859      */
860     function supportsInterface(bytes4 interfaceId) external view returns (bool);
861 }
862 
863 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
864 
865 
866 pragma solidity ^0.8.0;
867 
868 
869 /**
870  * @dev Implementation of the {IERC165} interface.
871  *
872  * Contracts may inherit from this and call {_registerInterface} to declare
873  * their support of an interface.
874  */
875 abstract contract ERC165 is IERC165 {
876     /**
877      * @dev Mapping of interface ids to whether or not it's supported.
878      */
879     mapping(bytes4 => bool) private _supportedInterfaces;
880 
881     constructor () {
882         // Derived contracts need only register support for their own interfaces,
883         // we register support for ERC165 itself here
884         _registerInterface(type(IERC165).interfaceId);
885     }
886 
887     /**
888      * @dev See {IERC165-supportsInterface}.
889      *
890      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
891      */
892     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
893         return _supportedInterfaces[interfaceId];
894     }
895 
896     /**
897      * @dev Registers the contract as an implementer of the interface defined by
898      * `interfaceId`. Support of the actual ERC165 interface is automatic and
899      * registering its interface id is not required.
900      *
901      * See {IERC165-supportsInterface}.
902      *
903      * Requirements:
904      *
905      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
906      */
907     function _registerInterface(bytes4 interfaceId) internal virtual {
908         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
909         _supportedInterfaces[interfaceId] = true;
910     }
911 }
912 
913 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
914 
915 
916 
917 
918 pragma solidity ^0.8.0;
919 
920 
921 /**
922  * @dev Required interface of an ERC721 compliant contract.
923  */
924 interface IERC721 is IERC165 {
925     /**
926      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
927      */
928     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
929 
930     /**
931      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
932      */
933     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
934 
935     /**
936      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
937      */
938     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
939 
940     /**
941      * @dev Returns the number of tokens in ``owner``'s account.
942      */
943     function balanceOf(address owner) external view returns (uint256 balance);
944 
945     /**
946      * @dev Returns the owner of the `tokenId` token.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      */
952     function ownerOf(uint256 tokenId) external view returns (address owner);
953 
954     /**
955      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
956      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
957      *
958      * Requirements:
959      *
960      * - `from` cannot be the zero address.
961      * - `to` cannot be the zero address.
962      * - `tokenId` token must exist and be owned by `from`.
963      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
965      *
966      * Emits a {Transfer} event.
967      */
968     function safeTransferFrom(address from, address to, uint256 tokenId) external;
969 
970     /**
971      * @dev Transfers `tokenId` token from `from` to `to`.
972      *
973      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
974      *
975      * Requirements:
976      *
977      * - `from` cannot be the zero address.
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must be owned by `from`.
980      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
981      *
982      * Emits a {Transfer} event.
983      */
984     function transferFrom(address from, address to, uint256 tokenId) external;
985 
986     /**
987      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
988      * The approval is cleared when the token is transferred.
989      *
990      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
991      *
992      * Requirements:
993      *
994      * - The caller must own the token or be an approved operator.
995      * - `tokenId` must exist.
996      *
997      * Emits an {Approval} event.
998      */
999     function approve(address to, uint256 tokenId) external;
1000 
1001     /**
1002      * @dev Returns the account approved for `tokenId` token.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      */
1008     function getApproved(uint256 tokenId) external view returns (address operator);
1009 
1010     /**
1011      * @dev Approve or remove `operator` as an operator for the caller.
1012      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1013      *
1014      * Requirements:
1015      *
1016      * - The `operator` cannot be the caller.
1017      *
1018      * Emits an {ApprovalForAll} event.
1019      */
1020     function setApprovalForAll(address operator, bool _approved) external;
1021 
1022     /**
1023      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1024      *
1025      * See {setApprovalForAll}
1026      */
1027     function isApprovedForAll(address owner, address operator) external view returns (bool);
1028 
1029     /**
1030       * @dev Safely transfers `tokenId` token from `from` to `to`.
1031       *
1032       * Requirements:
1033       *
1034       * - `from` cannot be the zero address.
1035       * - `to` cannot be the zero address.
1036       * - `tokenId` token must exist and be owned by `from`.
1037       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1038       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1039       *
1040       * Emits a {Transfer} event.
1041       */
1042     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1043 }
1044 
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 /**
1049  * @title ERC721 token receiver interface
1050  * @dev Interface for any contract that wants to support safeTransfers
1051  * from ERC721 asset contracts.
1052  */
1053 interface IERC721Receiver {
1054     /**
1055      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1056      * by `operator` from `from`, this function is called.
1057      *
1058      * It must return its Solidity selector to confirm the token transfer.
1059      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1060      *
1061      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1062      */
1063     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1064 }
1065 
1066 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1067 
1068 
1069 
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 
1074 /**
1075  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1076  * @dev See https://eips.ethereum.org/EIPS/eip-721
1077  */
1078 interface IERC721Enumerable is IERC721 {
1079 
1080     /**
1081      * @dev Returns the total amount of tokens stored by the contract.
1082      */
1083     function totalSupply() external view returns (uint256);
1084 
1085     /**
1086      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1087      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1088      */
1089     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1090 
1091     /**
1092      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1093      * Use along with {totalSupply} to enumerate all tokens.
1094      */
1095     function tokenByIndex(uint256 index) external view returns (uint256);
1096 }
1097 
1098 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1099 
1100 
1101 
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 
1106 /**
1107  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1108  * @dev See https://eips.ethereum.org/EIPS/eip-721
1109  */
1110 interface IERC721Metadata is IERC721 {
1111 
1112     /**
1113      * @dev Returns the token collection name.
1114      */
1115     function name() external view returns (string memory);
1116 
1117     /**
1118      * @dev Returns the token collection symbol.
1119      */
1120     function symbol() external view returns (string memory);
1121 
1122     /**
1123      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1124      */
1125     function tokenURI(uint256 tokenId) external view returns (string memory);
1126 }
1127 
1128 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1129 
1130 
1131 
1132 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1133 
1134 
1135 
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 /*
1140  * @dev Provides information about the current execution context, including the
1141  * sender of the transaction and its data. While these are generally available
1142  * via msg.sender and msg.data, they should not be accessed in such a direct
1143  * manner, since when dealing with GSN meta-transactions the account sending and
1144  * paying for execution may not be the actual sender (as far as an application
1145  * is concerned).
1146  *
1147  * This contract is only required for intermediate, library-like contracts.
1148  */
1149 abstract contract Context {
1150     function _msgSender() internal view virtual returns (address) {
1151         return msg.sender;
1152     }
1153 
1154     function _msgData() internal view virtual returns (bytes calldata) {
1155         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1156         return msg.data;
1157     }
1158 }
1159 
1160 
1161 
1162 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1163 
1164 
1165 
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 /**
1180  * @title ERC721 Non-Fungible Token Standard basic implementation
1181  * @dev see https://eips.ethereum.org/EIPS/eip-721
1182  */
1183 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1184     using Address for address;
1185     using EnumerableSet for EnumerableSet.UintSet;
1186     using EnumerableMap for EnumerableMap.UintToAddressMap;
1187     using Strings for uint256;
1188 
1189     // Mapping from holder address to their (enumerable) set of owned tokens
1190     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1191 
1192     // Enumerable mapping from token ids to their owners
1193     EnumerableMap.UintToAddressMap private _tokenOwners;
1194 
1195     // Mapping from token ID to approved address
1196     mapping (uint256 => address) private _tokenApprovals;
1197 
1198     // Mapping from owner to operator approvals
1199     mapping (address => mapping (address => bool)) private _operatorApprovals;
1200 
1201     // Token name
1202     string private _name;
1203 
1204     // Token symbol
1205     string private _symbol;
1206 
1207     // Optional mapping for token URIs
1208     mapping (uint256 => string) private _tokenURIs;
1209 
1210     // Base URI
1211     string private _baseURI;
1212 
1213     /**
1214      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1215      */
1216     constructor (string memory name_, string memory symbol_) {
1217         _name = name_;
1218         _symbol = symbol_;
1219 
1220         // register the supported interfaces to conform to ERC721 via ERC165
1221         _registerInterface(type(IERC721).interfaceId);
1222         _registerInterface(type(IERC721Metadata).interfaceId);
1223         _registerInterface(type(IERC721Enumerable).interfaceId);
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-balanceOf}.
1228      */
1229     function balanceOf(address owner) public view virtual override returns (uint256) {
1230         require(owner != address(0), "ERC721: balance query for the zero address");
1231         return _holderTokens[owner].length();
1232     }
1233     
1234 
1235     
1236     /**
1237      * @dev See {IERC721-ownerOf}.
1238      */
1239     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1240         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Metadata-name}.
1245      */
1246     function name() public view virtual override returns (string memory) {
1247         return _name;
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Metadata-symbol}.
1252      */
1253     function symbol() public view virtual override returns (string memory) {
1254         return _symbol;
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Metadata-tokenURI}.
1259      */
1260     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1261         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1262 
1263         string memory _tokenURI = _tokenURIs[tokenId];
1264         string memory base = baseURI();
1265 
1266         // If there is no base URI, return the token URI.
1267         if (bytes(base).length == 0) {
1268             return _tokenURI;
1269         }
1270         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1271         if (bytes(_tokenURI).length > 0) {
1272             return string(abi.encodePacked(base, _tokenURI));
1273         }
1274         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1275         return string(abi.encodePacked(base, tokenId.toString()));
1276     }
1277 
1278     /**
1279     * @dev Returns the base URI set via {_setBaseURI}. This will be
1280     * automatically added as a prefix in {tokenURI} to each token's URI, or
1281     * to the token ID if no specific URI is set for that token ID.
1282     */
1283     function baseURI() public view virtual returns (string memory) {
1284         return _baseURI;
1285     }
1286 
1287     /**
1288      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1289      */
1290     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1291         return _holderTokens[owner].at(index);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-totalSupply}.
1296      */
1297     function totalSupply() public view virtual override returns (uint256) {
1298         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1299         return _tokenOwners.length();
1300     }
1301 
1302     /**
1303      * @dev See {IERC721Enumerable-tokenByIndex}.
1304      */
1305     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1306         (uint256 tokenId, ) = _tokenOwners.at(index);
1307         return tokenId;
1308     }
1309 
1310     /**
1311      * @dev See {IERC721-approve}.
1312      */
1313     function approve(address to, uint256 tokenId) public virtual override {
1314         address owner = ERC721.ownerOf(tokenId);
1315         require(to != owner, "ERC721: approval to current owner");
1316 
1317         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1318             "ERC721: approve caller is not owner nor approved for all"
1319         );
1320 
1321         _approve(to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev See {IERC721-getApproved}.
1326      */
1327     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1328         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1329 
1330         return _tokenApprovals[tokenId];
1331     }
1332 
1333     /**
1334      * @dev See {IERC721-setApprovalForAll}.
1335      */
1336     function setApprovalForAll(address operator, bool approved) public virtual override {
1337         require(operator != _msgSender(), "ERC721: approve to caller");
1338 
1339         _operatorApprovals[_msgSender()][operator] = approved;
1340         emit ApprovalForAll(_msgSender(), operator, approved);
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-isApprovedForAll}.
1345      */
1346     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1347         return _operatorApprovals[owner][operator];
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-transferFrom}.
1352      */
1353     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1354         //solhint-disable-next-line max-line-length
1355         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1356 
1357         _transfer(from, to, tokenId);
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-safeTransferFrom}.
1362      */
1363     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1364         safeTransferFrom(from, to, tokenId, "");
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-safeTransferFrom}.
1369      */
1370     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1371         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1372         _safeTransfer(from, to, tokenId, _data);
1373     }
1374 
1375     /**
1376      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1377      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1378      *
1379      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1380      *
1381      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1382      * implement alternative mechanisms to perform token transfer, such as signature-based.
1383      *
1384      * Requirements:
1385      *
1386      * - `from` cannot be the zero address.
1387      * - `to` cannot be the zero address.
1388      * - `tokenId` token must exist and be owned by `from`.
1389      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1394         _transfer(from, to, tokenId);
1395         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1396     }
1397 
1398     /**
1399      * @dev Returns whether `tokenId` exists.
1400      *
1401      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1402      *
1403      * Tokens start existing when they are minted (`_mint`),
1404      * and stop existing when they are burned (`_burn`).
1405      */
1406     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1407         return _tokenOwners.contains(tokenId);
1408     }
1409 
1410     /**
1411      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1412      *
1413      * Requirements:
1414      *
1415      * - `tokenId` must exist.
1416      */
1417     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1418         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1419         address owner = ERC721.ownerOf(tokenId);
1420         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1421     }
1422 
1423     /**
1424      * @dev Safely mints `tokenId` and transfers it to `to`.
1425      *
1426      * Requirements:
1427      d*
1428      * - `tokenId` must not exist.
1429      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1430      *
1431      * Emits a {Transfer} event.
1432      */
1433     function _safeMint(address to, uint256 tokenId) internal virtual {
1434         _safeMint(to, tokenId, "");
1435     }
1436 
1437     /**
1438      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1439      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1440      */
1441     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1442         _mint(to, tokenId);
1443         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1444     }
1445 
1446     /**
1447      * @dev Mints `tokenId` and transfers it to `to`.
1448      *
1449      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must not exist.
1454      * - `to` cannot be the zero address.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _mint(address to, uint256 tokenId) internal virtual {
1459         require(to != address(0), "ERC721: mint to the zero address");
1460         require(!_exists(tokenId), "ERC721: token already minted");
1461 
1462         _beforeTokenTransfer(address(0), to, tokenId);
1463 
1464         _holderTokens[to].add(tokenId);
1465 
1466         _tokenOwners.set(tokenId, to);
1467 
1468         emit Transfer(address(0), to, tokenId);
1469     }
1470 
1471     /**
1472      * @dev Destroys `tokenId`.
1473      * The approval is cleared when the token is burned.
1474      *
1475      * Requirements:
1476      *
1477      * - `tokenId` must exist.
1478      *
1479      * Emits a {Transfer} event.
1480      */
1481     function _burn(uint256 tokenId) internal virtual {
1482         address owner = ERC721.ownerOf(tokenId); // internal owner
1483 
1484         _beforeTokenTransfer(owner, address(0), tokenId);
1485 
1486         // Clear approvals
1487         _approve(address(0), tokenId);
1488 
1489         // Clear metadata (if any)
1490         if (bytes(_tokenURIs[tokenId]).length != 0) {
1491             delete _tokenURIs[tokenId];
1492         }
1493 
1494         _holderTokens[owner].remove(tokenId);
1495 
1496         _tokenOwners.remove(tokenId);
1497 
1498         emit Transfer(owner, address(0), tokenId);
1499     }
1500 
1501     /**
1502      * @dev Transfers `tokenId` from `from` to `to`.
1503      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1504      *
1505      * Requirements:
1506      *
1507      * - `to` cannot be the zero address.
1508      * - `tokenId` token must be owned by `from`.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1513         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1514         require(to != address(0), "ERC721: transfer to the zero address");
1515 
1516         _beforeTokenTransfer(from, to, tokenId);
1517 
1518         // Clear approvals from the previous owner
1519         _approve(address(0), tokenId);
1520 
1521         _holderTokens[from].remove(tokenId);
1522         _holderTokens[to].add(tokenId);
1523 
1524         _tokenOwners.set(tokenId, to);
1525 
1526         emit Transfer(from, to, tokenId);
1527     }
1528 
1529     /**
1530      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1531      *
1532      * Requirements:
1533      *
1534      * - `tokenId` must exist.
1535      */
1536     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1537         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1538         _tokenURIs[tokenId] = _tokenURI;
1539     }
1540 
1541     /**
1542      * @dev Internal function to set the base URI for all token IDs. It is
1543      * automatically added as a prefix to the value returned in {tokenURI},
1544      * or to the token ID if {tokenURI} is empty.
1545      */
1546     function _setBaseURI(string memory baseURI_) internal virtual {
1547         _baseURI = baseURI_;
1548     }
1549 
1550     /**
1551      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1552      * The call is not executed if the target address is not a contract.
1553      *
1554      * @param from address representing the previous owner of the given token ID
1555      * @param to target address that will receive the tokens
1556      * @param tokenId uint256 ID of the token to be transferred
1557      * @param _data bytes optional data to send along with the call
1558      * @return bool whether the call correctly returned the expected magic value
1559      */
1560     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1561         private returns (bool)
1562     {
1563         if (to.isContract()) {
1564             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1565                 return retval == IERC721Receiver(to).onERC721Received.selector;
1566             } catch (bytes memory reason) {
1567                 if (reason.length == 0) {
1568                     revert("ERC721: transfer to non ERC721Receiver implementer");
1569                 } else {
1570                     // solhint-disable-next-line no-inline-assembly
1571                     assembly {
1572                         revert(add(32, reason), mload(reason))
1573                     }
1574                 }
1575             }
1576         } else {
1577             return true;
1578         }
1579     }
1580 
1581     function _approve(address to, uint256 tokenId) private {
1582         _tokenApprovals[tokenId] = to;
1583         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1584     }
1585 
1586     /**
1587      * @dev Hook that is called before any token transfer. This includes minting
1588      * and burning.
1589      *
1590      * Calling conditions:
1591      *
1592      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1593      * transferred to `to`.
1594      * - When `from` is zero, `tokenId` will be minted for `to`.
1595      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1596      * - `from` cannot be the zero address.
1597      * - `to` cannot be the zero address.
1598      *
1599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1600      */
1601     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1602 }
1603 
1604 
1605 
1606 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1607 
1608 
1609 
1610 
1611 pragma solidity ^0.8.0;
1612 
1613 /**
1614  * @dev Contract module which provides a basic access control mechanism, where
1615  * there is an account (an owner) that can be granted exclusive access to
1616  * specific functions.
1617  *
1618  * By default, the owner account will be the one that deploys the contract. This
1619  * can later be changed with {transferOwnership}.
1620  *
1621  * This module is used through inheritance. It will make available the modifier
1622  * `onlyOwner`, which can be applied to your functions to restrict their use to
1623  * the owner.
1624  */
1625 abstract contract Ownable is Context {
1626     address private _owner;
1627 
1628     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1629 
1630     /**
1631      * @dev Initializes the contract setting the deployer as the initial owner.
1632      */
1633     constructor () {
1634         address msgSender = _msgSender();
1635         _owner = msgSender;
1636         emit OwnershipTransferred(address(0), msgSender);
1637     }
1638 
1639     /**
1640      * @dev Returns the address of the current owner.
1641      */
1642     function owner() public view virtual returns (address) {
1643         return _owner;
1644     }
1645 
1646     /**
1647      * @dev Throws if called by any account other than the owner.
1648      */
1649     modifier onlyOwner() {
1650         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1651         _;
1652     }
1653 
1654     /**
1655      * @dev Leaves the contract without owner. It will not be possible to call
1656      * `onlyOwner` functions anymore. Can only be called by the current owner.
1657      *
1658      * NOTE: Renouncing ownership will leave the contract without an owner,
1659      * thereby removing any functionality that is only available to the owner.
1660      */
1661     function renounceOwnership() public virtual onlyOwner {
1662         emit OwnershipTransferred(_owner, address(0));
1663         _owner = address(0);
1664     }
1665 
1666     /**
1667      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1668      * Can only be called by the current owner.
1669      */
1670     function transferOwnership(address newOwner) public virtual onlyOwner {
1671         require(newOwner != address(0), "Ownable: new owner is the zero address");
1672         emit OwnershipTransferred(_owner, newOwner);
1673         _owner = newOwner;
1674     }
1675 }
1676 
1677 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1678 
1679 
1680 
1681 
1682 pragma solidity ^0.8.0;
1683 
1684 // CAUTION
1685 // This version of SafeMath should only be used with Solidity 0.8 or later,
1686 // because it relies on the compiler's built in overflow checks.
1687 
1688 /**
1689  * @dev Wrappers over Solidity's arithmetic operations.
1690  *
1691  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1692  * now has built in overflow checking.
1693  */
1694 library SafeMath {
1695     /**
1696      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1697      *
1698      * _Available since v3.4._
1699      */
1700     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1701         unchecked {
1702             uint256 c = a + b;
1703             if (c < a) return (false, 0);
1704             return (true, c);
1705         }
1706     }
1707 
1708     /**
1709      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1710      *
1711      * _Available since v3.4._
1712      */
1713     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1714         unchecked {
1715             if (b > a) return (false, 0);
1716             return (true, a - b);
1717         }
1718     }
1719 
1720     /**
1721      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1722      *
1723      * _Available since v3.4._
1724      */
1725     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1726         unchecked {
1727             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1728             // benefit is lost if 'b' is also tested.
1729             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1730             if (a == 0) return (true, 0);
1731             uint256 c = a * b;
1732             if (c / a != b) return (false, 0);
1733             return (true, c);
1734         }
1735     }
1736 
1737     /**
1738      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1739      *
1740      * _Available since v3.4._
1741      */
1742     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1743         unchecked {
1744             if (b == 0) return (false, 0);
1745             return (true, a / b);
1746         }
1747     }
1748 
1749     /**
1750      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1751      *
1752      * _Available since v3.4._
1753      */
1754     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1755         unchecked {
1756             if (b == 0) return (false, 0);
1757             return (true, a % b);
1758         }
1759     }
1760 
1761     /**
1762      * @dev Returns the addition of two unsigned integers, reverting on
1763      * overflow.
1764      *
1765      * Counterpart to Solidity's `+` operator.
1766      *
1767      * Requirements:
1768      *
1769      * - Addition cannot overflow.
1770      */
1771     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1772         return a + b;
1773     }
1774 
1775     /**
1776      * @dev Returns the subtraction of two unsigned integers, reverting on
1777      * overflow (when the result is negative).
1778      *
1779      * Counterpart to Solidity's `-` operator.
1780      *
1781      * Requirements:
1782      *
1783      * - Subtraction cannot overflow.
1784      */
1785     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1786         return a - b;
1787     }
1788 
1789     /**
1790      * @dev Returns the multiplication of two unsigned integers, reverting on
1791      * overflow.
1792      *
1793      * Counterpart to Solidity's `*` operator.
1794      *
1795      * Requirements:
1796      *
1797      * - Multiplication cannot overflow.
1798      */
1799     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1800         return a * b;
1801     }
1802 
1803     /**
1804      * @dev Returns the integer division of two unsigned integers, reverting on
1805      * division by zero. The result is rounded towards zero.
1806      *
1807      * Counterpart to Solidity's `/` operator.
1808      *
1809      * Requirements:
1810      *
1811      * - The divisor cannot be zero.
1812      */
1813     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1814         return a / b;
1815     }
1816 
1817     /**
1818      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1819      * reverting when dividing by zero.
1820      *
1821      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1822      * opcode (which leaves remaining gas untouched) while Solidity uses an
1823      * invalid opcode to revert (consuming all remaining gas).
1824      *
1825      * Requirements:
1826      *
1827      * - The divisor cannot be zero.
1828      */
1829     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1830         return a % b;
1831     }
1832 
1833     /**
1834      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1835      * overflow (when the result is negative).
1836      *
1837      * CAUTION: This function is deprecated because it requires allocating memory for the error
1838      * message unnecessarily. For custom revert reasons use {trySub}.
1839      *
1840      * Counterpart to Solidity's `-` operator.
1841      *
1842      * Requirements:
1843      *
1844      * - Subtraction cannot overflow.
1845      */
1846     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1847         unchecked {
1848             require(b <= a, errorMessage);
1849             return a - b;
1850         }
1851     }
1852 
1853     /**
1854      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1855      * division by zero. The result is rounded towards zero.
1856      *
1857      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1858      * opcode (which leaves remaining gas untouched) while Solidity uses an
1859      * invalid opcode to revert (consuming all remaining gas).
1860      *
1861      * Counterpart to Solidity's `/` operator. Note: this function uses a
1862      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1863      * uses an invalid opcode to revert (consuming all remaining gas).
1864      *
1865      * Requirements:
1866      *
1867      * - The divisor cannot be zero.
1868      */
1869     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1870         unchecked {
1871             require(b > 0, errorMessage);
1872             return a / b;
1873         }
1874     }
1875 
1876     /**
1877      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1878      * reverting with custom message when dividing by zero.
1879      *
1880      * CAUTION: This function is deprecated because it requires allocating memory for the error
1881      * message unnecessarily. For custom revert reasons use {tryMod}.
1882      *
1883      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1884      * opcode (which leaves remaining gas untouched) while Solidity uses an
1885      * invalid opcode to revert (consuming all remaining gas).
1886      *
1887      * Requirements:
1888      *
1889      * - The divisor cannot be zero.
1890      */
1891     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1892         unchecked {
1893             require(b > 0, errorMessage);
1894             return a % b;
1895         }
1896     }
1897 }
1898 
1899 // File: browser/BGAN.sol
1900 
1901 
1902 
1903 
1904 
1905 pragma solidity ^0.8.0;
1906 
1907 
1908 
1909 
1910 
1911 contract BGANPUNKSV2 is ERC721, Ownable {
1912     using SafeMath for uint256;
1913     uint public constant MAX_BASTARDS = 11305;
1914     bool public hasSaleStarted = false;
1915     
1916     // THE IPFS HASH OF ALL TOKEN DATAS WILL BE ADDED HERE WHEN ALL BASTARDS ARE FINALIZED.
1917     string public METADATA_PROVENANCE_HASH = "";
1918     
1919     
1920     constructor() ERC721("BASTARD GAN PUNKS V2","BGANPUNKV2")  {
1921         setBaseURI("https://bastardganpunks.club/api/");
1922         
1923         // TO BERK
1924         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 0);
1925         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 1);
1926         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 2);
1927         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 3);
1928         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 4);
1929         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 5);
1930         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 6);
1931         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 7);
1932         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 8);
1933         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 9);
1934         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 10);
1935         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 11);
1936         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 12);
1937         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 13);
1938         
1939         // CANER
1940         _safeMint(address(0xc5E5ec38de39c632f67EbF9795CD1d7D12331799), 14);
1941         _safeMint(address(0xc5E5ec38de39c632f67EbF9795CD1d7D12331799), 15);
1942         _safeMint(address(0xc5E5ec38de39c632f67EbF9795CD1d7D12331799), 16);
1943         
1944         // GOKHAN
1945         _safeMint(address(0x36de990133D36d7E3DF9a820aA3eDE5a2320De71), 17);
1946         _safeMint(address(0x36de990133D36d7E3DF9a820aA3eDE5a2320De71), 18);
1947         
1948         // HALE
1949         _safeMint(address(0x58615313079FdD02eb240a11fbBFf1dadb00007e), 19);
1950         
1951         // SEDA
1952         _safeMint(address(0xfCAD2eB79692c2Aa0BCBaf3D3E29615dDa94FE6d), 20);
1953         _safeMint(address(0xfCAD2eB79692c2Aa0BCBaf3D3E29615dDa94FE6d), 21);
1954         _safeMint(address(0xfCAD2eB79692c2Aa0BCBaf3D3E29615dDa94FE6d), 22);
1955         
1956         // SAJIDA
1957         _safeMint(address(0x61C4a38D7e9ea4095FA7D507CF72Bf61eb5e1556), 23);
1958         _safeMint(address(0x61C4a38D7e9ea4095FA7D507CF72Bf61eb5e1556), 24);
1959         _safeMint(address(0x61C4a38D7e9ea4095FA7D507CF72Bf61eb5e1556), 25);
1960         
1961         // SAMET
1962         _safeMint(address(0xd956c14c8016c55344B3429ccDF2cDf9cc4362DD), 26);
1963         _safeMint(address(0xd956c14c8016c55344B3429ccDF2cDf9cc4362DD), 27);
1964         
1965         // ISIK
1966         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 28);
1967         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 29);
1968         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 30);
1969         
1970         // GIVEAWAY
1971         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 31);
1972         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 32);
1973         _safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 33);
1974     }
1975     
1976 
1977    
1978     
1979 
1980     
1981     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1982         uint256 tokenCount = balanceOf(_owner);
1983         if (tokenCount == 0) {
1984             // Return an empty array
1985             return new uint256[](0);
1986         } else {
1987             uint256[] memory result = new uint256[](tokenCount);
1988             uint256 index;
1989             for (index = 0; index < tokenCount; index++) {
1990                 result[index] = tokenOfOwnerByIndex(_owner, index);
1991             }
1992             return result;
1993         }
1994     }
1995     
1996     function calculatePrice() public view returns (uint256) {
1997         require(hasSaleStarted == true, "Sale hasn't started");
1998 
1999         require(totalSupply() < MAX_BASTARDS, "Sale has already ended");
2000 
2001         uint currentSupply = totalSupply();
2002         if (currentSupply == 11304) {
2003             return 10000000000000000000;
2004         } else if (currentSupply >= 11300) {
2005             return 3000000000000000000;
2006         } else if (currentSupply >= 11000) {
2007             return 854000000000000000 + (((currentSupply - 11000) / 50) * ((10 ** 16)));
2008         } else if (currentSupply >= 10000) {
2009             return 769000000000000000 + (((currentSupply - 10000) / 100) * ((10 ** 14) * 85));
2010         } else if (currentSupply >= 5000) {
2011             return 394000000000000000 + (((currentSupply - 5000) / 100) * ((10 ** 14) * 75));
2012         } else {
2013             return 69000000000000000 + ((currentSupply / 100) * ((10 ** 14) * 65));
2014         }
2015         
2016     }
2017     
2018      function calculatePriceTest(uint _id) public view returns (uint256) {
2019 
2020 
2021         require(_id < MAX_BASTARDS, "Sale has already ended");
2022 
2023         if (_id == 11304) {
2024             return 10000000000000000000;
2025         } else if (_id >= 11300) {
2026             return 3000000000000000000;
2027         } else if (_id >= 11000) {
2028             return 854000000000000000 + (((_id - 11000) / 50) * ((10 ** 16)));
2029         } else if (_id >= 10000) {
2030             return 769000000000000000 + (((_id - 10000) / 100) * ((10 ** 14) * 85));
2031         } else if (_id >= 5000) {
2032             return 394000000000000000 + (((_id - 5000) / 100) * ((10 ** 14) * 75));
2033         } else {
2034             return 69000000000000000 + ((_id / 100) * ((10 ** 14) * 65));
2035         }
2036         
2037     }
2038     
2039    function adoptBASTARD(uint256 numBastards) public payable {
2040         require(totalSupply() < MAX_BASTARDS, "Sale has already ended");
2041         require(numBastards > 0 && numBastards <= 20, "You can adopt minimum 1, maximum 20 bastards");
2042         require(totalSupply().add(numBastards) <= MAX_BASTARDS, "Exceeds MAX_BASTARDS");
2043         require(msg.value >= calculatePrice().mul(numBastards), "Ether value sent is below the price");
2044 
2045         for (uint i = 0; i < numBastards; i++) {
2046             uint mintIndex = totalSupply();
2047             _safeMint(msg.sender, mintIndex);
2048         }
2049 
2050     }
2051     
2052     // ONLYOWNER FUNCTIONS
2053     
2054     function setProvenanceHash(string memory _hash) public onlyOwner {
2055         METADATA_PROVENANCE_HASH = _hash;
2056     }
2057     
2058     function setBaseURI(string memory baseURI) public onlyOwner {
2059         _setBaseURI(baseURI);
2060     }
2061     
2062     function startDrop() public onlyOwner {
2063         hasSaleStarted = true;
2064     }
2065     function pauseDrop() public onlyOwner {
2066         hasSaleStarted = false;
2067     }
2068     
2069     
2070     function withdrawAll() public payable onlyOwner {
2071         require(payable(msg.sender).send(address(this).balance));
2072     }
2073     
2074 
2075 
2076 }