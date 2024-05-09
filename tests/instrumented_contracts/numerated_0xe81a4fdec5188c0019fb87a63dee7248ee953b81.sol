1 // Thank you to BGAN Punks / https://bastardganpunks.club/ for this contract.
2 // xo Ciel 
3 
4 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
5 
6 // SPDX-License-Identifier: MIT
7 
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant alphabet = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = alphabet[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 
74 }
75 
76 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
77 
78 
79 
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Library for managing an enumerable variant of Solidity's
85  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
86  * type.
87  *
88  * Maps have the following properties:
89  *
90  * - Entries are added, removed, and checked for existence in constant time
91  * (O(1)).
92  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
93  *
94  * ```
95  * contract Example {
96  *     // Add the library methods
97  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
98  *
99  *     // Declare a set state variable
100  *     EnumerableMap.UintToAddressMap private myMap;
101  * }
102  * ```
103  *
104  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
105  * supported.
106  */
107 library EnumerableMap {
108     // To implement this library for multiple types with as little code
109     // repetition as possible, we write it in terms of a generic Map type with
110     // bytes32 keys and values.
111     // The Map implementation uses private functions, and user-facing
112     // implementations (such as Uint256ToAddressMap) are just wrappers around
113     // the underlying Map.
114     // This means that we can only create new EnumerableMaps for types that fit
115     // in bytes32.
116 
117     struct MapEntry {
118         bytes32 _key;
119         bytes32 _value;
120     }
121 
122     struct Map {
123         // Storage of map keys and values
124         MapEntry[] _entries;
125 
126         // Position of the entry defined by a key in the `entries` array, plus 1
127         // because index 0 means a key is not in the map.
128         mapping (bytes32 => uint256) _indexes;
129     }
130 
131     /**
132      * @dev Adds a key-value pair to a map, or updates the value for an existing
133      * key. O(1).
134      *
135      * Returns true if the key was added to the map, that is if it was not
136      * already present.
137      */
138     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
139         // We read and store the key's index to prevent multiple reads from the same storage slot
140         uint256 keyIndex = map._indexes[key];
141 
142         if (keyIndex == 0) { // Equivalent to !contains(map, key)
143             map._entries.push(MapEntry({ _key: key, _value: value }));
144             // The entry is stored at length-1, but we add 1 to all indexes
145             // and use 0 as a sentinel value
146             map._indexes[key] = map._entries.length;
147             return true;
148         } else {
149             map._entries[keyIndex - 1]._value = value;
150             return false;
151         }
152     }
153 
154     /**
155      * @dev Removes a key-value pair from a map. O(1).
156      *
157      * Returns true if the key was removed from the map, that is if it was present.
158      */
159     function _remove(Map storage map, bytes32 key) private returns (bool) {
160         // We read and store the key's index to prevent multiple reads from the same storage slot
161         uint256 keyIndex = map._indexes[key];
162 
163         if (keyIndex != 0) { // Equivalent to contains(map, key)
164             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
165             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
166             // This modifies the order of the array, as noted in {at}.
167 
168             uint256 toDeleteIndex = keyIndex - 1;
169             uint256 lastIndex = map._entries.length - 1;
170 
171             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
172             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
173 
174             MapEntry storage lastEntry = map._entries[lastIndex];
175 
176             // Move the last entry to the index where the entry to delete is
177             map._entries[toDeleteIndex] = lastEntry;
178             // Update the index for the moved entry
179             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
180 
181             // Delete the slot where the moved entry was stored
182             map._entries.pop();
183 
184             // Delete the index for the deleted slot
185             delete map._indexes[key];
186 
187             return true;
188         } else {
189             return false;
190         }
191     }
192 
193     /**
194      * @dev Returns true if the key is in the map. O(1).
195      */
196     function _contains(Map storage map, bytes32 key) private view returns (bool) {
197         return map._indexes[key] != 0;
198     }
199 
200     /**
201      * @dev Returns the number of key-value pairs in the map. O(1).
202      */
203     function _length(Map storage map) private view returns (uint256) {
204         return map._entries.length;
205     }
206 
207    /**
208     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
209     *
210     * Note that there are no guarantees on the ordering of entries inside the
211     * array, and it may change when more entries are added or removed.
212     *
213     * Requirements:
214     *
215     * - `index` must be strictly less than {length}.
216     */
217     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
218         require(map._entries.length > index, "EnumerableMap: index out of bounds");
219 
220         MapEntry storage entry = map._entries[index];
221         return (entry._key, entry._value);
222     }
223 
224     /**
225      * @dev Tries to returns the value associated with `key`.  O(1).
226      * Does not revert if `key` is not in the map.
227      */
228     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
229         uint256 keyIndex = map._indexes[key];
230         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
231         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
232     }
233 
234     /**
235      * @dev Returns the value associated with `key`.  O(1).
236      *
237      * Requirements:
238      *
239      * - `key` must be in the map.
240      */
241     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
242         uint256 keyIndex = map._indexes[key];
243         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
244         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
245     }
246 
247     /**
248      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
249      *
250      * CAUTION: This function is deprecated because it requires allocating memory for the error
251      * message unnecessarily. For custom revert reasons use {_tryGet}.
252      */
253     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
254         uint256 keyIndex = map._indexes[key];
255         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
256         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
257     }
258 
259     // UintToAddressMap
260 
261     struct UintToAddressMap {
262         Map _inner;
263     }
264 
265     /**
266      * @dev Adds a key-value pair to a map, or updates the value for an existing
267      * key. O(1).
268      *
269      * Returns true if the key was added to the map, that is if it was not
270      * already present.
271      */
272     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
273         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
274     }
275 
276     /**
277      * @dev Removes a value from a set. O(1).
278      *
279      * Returns true if the key was removed from the map, that is if it was present.
280      */
281     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
282         return _remove(map._inner, bytes32(key));
283     }
284 
285     /**
286      * @dev Returns true if the key is in the map. O(1).
287      */
288     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
289         return _contains(map._inner, bytes32(key));
290     }
291 
292     /**
293      * @dev Returns the number of elements in the map. O(1).
294      */
295     function length(UintToAddressMap storage map) internal view returns (uint256) {
296         return _length(map._inner);
297     }
298 
299    /**
300     * @dev Returns the element stored at position `index` in the set. O(1).
301     * Note that there are no guarantees on the ordering of values inside the
302     * array, and it may change when more values are added or removed.
303     *
304     * Requirements:
305     *
306     * - `index` must be strictly less than {length}.
307     */
308     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
309         (bytes32 key, bytes32 value) = _at(map._inner, index);
310         return (uint256(key), address(uint160(uint256(value))));
311     }
312 
313     /**
314      * @dev Tries to returns the value associated with `key`.  O(1).
315      * Does not revert if `key` is not in the map.
316      *
317      * _Available since v3.4._
318      */
319     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
320         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
321         return (success, address(uint160(uint256(value))));
322     }
323 
324     /**
325      * @dev Returns the value associated with `key`.  O(1).
326      *
327      * Requirements:
328      *
329      * - `key` must be in the map.
330      */
331     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
332         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
333     }
334 
335     /**
336      * @dev Same as {get}, with a custom error message when `key` is not in the map.
337      *
338      * CAUTION: This function is deprecated because it requires allocating memory for the error
339      * message unnecessarily. For custom revert reasons use {tryGet}.
340      */
341     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
342         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
343     }
344 }
345 
346 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
347 
348 
349 
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Library for managing
355  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
356  * types.
357  *
358  * Sets have the following properties:
359  *
360  * - Elements are added, removed, and checked for existence in constant time
361  * (O(1)).
362  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
363  *
364  * ```
365  * contract Example {
366  *     // Add the library methods
367  *     using EnumerableSet for EnumerableSet.AddressSet;
368  *
369  *     // Declare a set state variable
370  *     EnumerableSet.AddressSet private mySet;
371  * }
372  * ```
373  *
374  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
375  * and `uint256` (`UintSet`) are supported.
376  */
377 library EnumerableSet {
378     // To implement this library for multiple types with as little code
379     // repetition as possible, we write it in terms of a generic Set type with
380     // bytes32 values.
381     // The Set implementation uses private functions, and user-facing
382     // implementations (such as AddressSet) are just wrappers around the
383     // underlying Set.
384     // This means that we can only create new EnumerableSets for types that fit
385     // in bytes32.
386 
387     struct Set {
388         // Storage of set values
389         bytes32[] _values;
390 
391         // Position of the value in the `values` array, plus 1 because index 0
392         // means a value is not in the set.
393         mapping (bytes32 => uint256) _indexes;
394     }
395 
396     /**
397      * @dev Add a value to a set. O(1).
398      *
399      * Returns true if the value was added to the set, that is if it was not
400      * already present.
401      */
402     function _add(Set storage set, bytes32 value) private returns (bool) {
403         if (!_contains(set, value)) {
404             set._values.push(value);
405             // The value is stored at length-1, but we add 1 to all indexes
406             // and use 0 as a sentinel value
407             set._indexes[value] = set._values.length;
408             return true;
409         } else {
410             return false;
411         }
412     }
413 
414     /**
415      * @dev Removes a value from a set. O(1).
416      *
417      * Returns true if the value was removed from the set, that is if it was
418      * present.
419      */
420     function _remove(Set storage set, bytes32 value) private returns (bool) {
421         // We read and store the value's index to prevent multiple reads from the same storage slot
422         uint256 valueIndex = set._indexes[value];
423 
424         if (valueIndex != 0) { // Equivalent to contains(set, value)
425             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
426             // the array, and then remove the last element (sometimes called as 'swap and pop').
427             // This modifies the order of the array, as noted in {at}.
428 
429             uint256 toDeleteIndex = valueIndex - 1;
430             uint256 lastIndex = set._values.length - 1;
431 
432             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
433             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
434 
435             bytes32 lastvalue = set._values[lastIndex];
436 
437             // Move the last value to the index where the value to delete is
438             set._values[toDeleteIndex] = lastvalue;
439             // Update the index for the moved value
440             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
441 
442             // Delete the slot where the moved value was stored
443             set._values.pop();
444 
445             // Delete the index for the deleted slot
446             delete set._indexes[value];
447 
448             return true;
449         } else {
450             return false;
451         }
452     }
453 
454     /**
455      * @dev Returns true if the value is in the set. O(1).
456      */
457     function _contains(Set storage set, bytes32 value) private view returns (bool) {
458         return set._indexes[value] != 0;
459     }
460 
461     /**
462      * @dev Returns the number of values on the set. O(1).
463      */
464     function _length(Set storage set) private view returns (uint256) {
465         return set._values.length;
466     }
467 
468    /**
469     * @dev Returns the value stored at position `index` in the set. O(1).
470     *
471     * Note that there are no guarantees on the ordering of values inside the
472     * array, and it may change when more values are added or removed.
473     *
474     * Requirements:
475     *
476     * - `index` must be strictly less than {length}.
477     */
478     function _at(Set storage set, uint256 index) private view returns (bytes32) {
479         require(set._values.length > index, "EnumerableSet: index out of bounds");
480         return set._values[index];
481     }
482 
483     // Bytes32Set
484 
485     struct Bytes32Set {
486         Set _inner;
487     }
488 
489     /**
490      * @dev Add a value to a set. O(1).
491      *
492      * Returns true if the value was added to the set, that is if it was not
493      * already present.
494      */
495     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
496         return _add(set._inner, value);
497     }
498 
499     /**
500      * @dev Removes a value from a set. O(1).
501      *
502      * Returns true if the value was removed from the set, that is if it was
503      * present.
504      */
505     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
506         return _remove(set._inner, value);
507     }
508 
509     /**
510      * @dev Returns true if the value is in the set. O(1).
511      */
512     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
513         return _contains(set._inner, value);
514     }
515 
516     /**
517      * @dev Returns the number of values in the set. O(1).
518      */
519     function length(Bytes32Set storage set) internal view returns (uint256) {
520         return _length(set._inner);
521     }
522 
523    /**
524     * @dev Returns the value stored at position `index` in the set. O(1).
525     *
526     * Note that there are no guarantees on the ordering of values inside the
527     * array, and it may change when more values are added or removed.
528     *
529     * Requirements:
530     *
531     * - `index` must be strictly less than {length}.
532     */
533     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
534         return _at(set._inner, index);
535     }
536 
537     // AddressSet
538 
539     struct AddressSet {
540         Set _inner;
541     }
542 
543     /**
544      * @dev Add a value to a set. O(1).
545      *
546      * Returns true if the value was added to the set, that is if it was not
547      * already present.
548      */
549     function add(AddressSet storage set, address value) internal returns (bool) {
550         return _add(set._inner, bytes32(uint256(uint160(value))));
551     }
552 
553     /**
554      * @dev Removes a value from a set. O(1).
555      *
556      * Returns true if the value was removed from the set, that is if it was
557      * present.
558      */
559     function remove(AddressSet storage set, address value) internal returns (bool) {
560         return _remove(set._inner, bytes32(uint256(uint160(value))));
561     }
562 
563     /**
564      * @dev Returns true if the value is in the set. O(1).
565      */
566     function contains(AddressSet storage set, address value) internal view returns (bool) {
567         return _contains(set._inner, bytes32(uint256(uint160(value))));
568     }
569 
570     /**
571      * @dev Returns the number of values in the set. O(1).
572      */
573     function length(AddressSet storage set) internal view returns (uint256) {
574         return _length(set._inner);
575     }
576 
577    /**
578     * @dev Returns the value stored at position `index` in the set. O(1).
579     *
580     * Note that there are no guarantees on the ordering of values inside the
581     * array, and it may change when more values are added or removed.
582     *
583     * Requirements:
584     *
585     * - `index` must be strictly less than {length}.
586     */
587     function at(AddressSet storage set, uint256 index) internal view returns (address) {
588         return address(uint160(uint256(_at(set._inner, index))));
589     }
590 
591 
592     // UintSet
593 
594     struct UintSet {
595         Set _inner;
596     }
597 
598     /**
599      * @dev Add a value to a set. O(1).
600      *
601      * Returns true if the value was added to the set, that is if it was not
602      * already present.
603      */
604     function add(UintSet storage set, uint256 value) internal returns (bool) {
605         return _add(set._inner, bytes32(value));
606     }
607 
608     /**
609      * @dev Removes a value from a set. O(1).
610      *
611      * Returns true if the value was removed from the set, that is if it was
612      * present.
613      */
614     function remove(UintSet storage set, uint256 value) internal returns (bool) {
615         return _remove(set._inner, bytes32(value));
616     }
617 
618     /**
619      * @dev Returns true if the value is in the set. O(1).
620      */
621     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
622         return _contains(set._inner, bytes32(value));
623     }
624 
625     /**
626      * @dev Returns the number of values on the set. O(1).
627      */
628     function length(UintSet storage set) internal view returns (uint256) {
629         return _length(set._inner);
630     }
631 
632    /**
633     * @dev Returns the value stored at position `index` in the set. O(1).
634     *
635     * Note that there are no guarantees on the ordering of values inside the
636     * array, and it may change when more values are added or removed.
637     *
638     * Requirements:
639     *
640     * - `index` must be strictly less than {length}.
641     */
642     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
643         return uint256(_at(set._inner, index));
644     }
645 }
646 
647 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
648 
649 
650 
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Collection of functions related to the address type
656  */
657 library Address {
658     /**
659      * @dev Returns true if `account` is a contract.
660      *
661      * [IMPORTANT]
662      * ====
663      * It is unsafe to assume that an address for which this function returns
664      * false is an externally-owned account (EOA) and not a contract.
665      *
666      * Among others, `isContract` will return false for the following
667      * types of addresses:
668      *
669      *  - an externally-owned account
670      *  - a contract in construction
671      *  - an address where a contract will be created
672      *  - an address where a contract lived, but was destroyed
673      * ====
674      */
675     function isContract(address account) internal view returns (bool) {
676         // This method relies on extcodesize, which returns 0 for contracts in
677         // construction, since the code is only stored at the end of the
678         // constructor execution.
679 
680         uint256 size;
681         // solhint-disable-next-line no-inline-assembly
682         assembly { size := extcodesize(account) }
683         return size > 0;
684     }
685 
686     /**
687      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
688      * `recipient`, forwarding all available gas and reverting on errors.
689      *
690      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
691      * of certain opcodes, possibly making contracts go over the 2300 gas limit
692      * imposed by `transfer`, making them unable to receive funds via
693      * `transfer`. {sendValue} removes this limitation.
694      *
695      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
696      *
697      * IMPORTANT: because control is transferred to `recipient`, care must be
698      * taken to not create reentrancy vulnerabilities. Consider using
699      * {ReentrancyGuard} or the
700      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
701      */
702     function sendValue(address payable recipient, uint256 amount) internal {
703         require(address(this).balance >= amount, "Address: insufficient balance");
704 
705         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
706         (bool success, ) = recipient.call{ value: amount }("");
707         require(success, "Address: unable to send value, recipient may have reverted");
708     }
709 
710     /**
711      * @dev Performs a Solidity function call using a low level `call`. A
712      * plain`call` is an unsafe replacement for a function call: use this
713      * function instead.
714      *
715      * If `target` reverts with a revert reason, it is bubbled up by this
716      * function (like regular Solidity function calls).
717      *
718      * Returns the raw returned data. To convert to the expected return value,
719      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
720      *
721      * Requirements:
722      *
723      * - `target` must be a contract.
724      * - calling `target` with `data` must not revert.
725      *
726      * _Available since v3.1._
727      */
728     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
729       return functionCall(target, data, "Address: low-level call failed");
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
734      * `errorMessage` as a fallback revert reason when `target` reverts.
735      *
736      * _Available since v3.1._
737      */
738     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
739         return functionCallWithValue(target, data, 0, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but also transferring `value` wei to `target`.
745      *
746      * Requirements:
747      *
748      * - the calling contract must have an ETH balance of at least `value`.
749      * - the called Solidity function must be `payable`.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
754         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
759      * with `errorMessage` as a fallback revert reason when `target` reverts.
760      *
761      * _Available since v3.1._
762      */
763     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
764         require(address(this).balance >= value, "Address: insufficient balance for call");
765         require(isContract(target), "Address: call to non-contract");
766 
767         // solhint-disable-next-line avoid-low-level-calls
768         (bool success, bytes memory returndata) = target.call{ value: value }(data);
769         return _verifyCallResult(success, returndata, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but performing a static call.
775      *
776      * _Available since v3.3._
777      */
778     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
779         return functionStaticCall(target, data, "Address: low-level static call failed");
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
784      * but performing a static call.
785      *
786      * _Available since v3.3._
787      */
788     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
789         require(isContract(target), "Address: static call to non-contract");
790 
791         // solhint-disable-next-line avoid-low-level-calls
792         (bool success, bytes memory returndata) = target.staticcall(data);
793         return _verifyCallResult(success, returndata, errorMessage);
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
798      * but performing a delegate call.
799      *
800      * _Available since v3.4._
801      */
802     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
803         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
808      * but performing a delegate call.
809      *
810      * _Available since v3.4._
811      */
812     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
813         require(isContract(target), "Address: delegate call to non-contract");
814 
815         // solhint-disable-next-line avoid-low-level-calls
816         (bool success, bytes memory returndata) = target.delegatecall(data);
817         return _verifyCallResult(success, returndata, errorMessage);
818     }
819 
820     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
821         if (success) {
822             return returndata;
823         } else {
824             // Look for revert reason and bubble it up if present
825             if (returndata.length > 0) {
826                 // The easiest way to bubble the revert reason is using memory via assembly
827 
828                 // solhint-disable-next-line no-inline-assembly
829                 assembly {
830                     let returndata_size := mload(returndata)
831                     revert(add(32, returndata), returndata_size)
832                 }
833             } else {
834                 revert(errorMessage);
835             }
836         }
837     }
838 }
839 
840 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
841 
842 
843 pragma solidity ^0.8.0;
844 
845 /**
846  * @dev Interface of the ERC165 standard, as defined in the
847  * https://eips.ethereum.org/EIPS/eip-165[EIP].
848  *
849  * Implementers can declare support of contract interfaces, which can then be
850  * queried by others ({ERC165Checker}).
851  *
852  * For an implementation, see {ERC165}.
853  */
854 interface IERC165 {
855     /**
856      * @dev Returns true if this contract implements the interface defined by
857      * `interfaceId`. See the corresponding
858      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
859      * to learn more about how these ids are created.
860      *
861      * This function call must use less than 30 000 gas.
862      */
863     function supportsInterface(bytes4 interfaceId) external view returns (bool);
864 }
865 
866 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
867 
868 
869 pragma solidity ^0.8.0;
870 
871 
872 /**
873  * @dev Implementation of the {IERC165} interface.
874  *
875  * Contracts may inherit from this and call {_registerInterface} to declare
876  * their support of an interface.
877  */
878 abstract contract ERC165 is IERC165 {
879     /**
880      * @dev Mapping of interface ids to whether or not it's supported.
881      */
882     mapping(bytes4 => bool) private _supportedInterfaces;
883 
884     constructor () {
885         // Derived contracts need only register support for their own interfaces,
886         // we register support for ERC165 itself here
887         _registerInterface(type(IERC165).interfaceId);
888     }
889 
890     /**
891      * @dev See {IERC165-supportsInterface}.
892      *
893      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
894      */
895     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
896         return _supportedInterfaces[interfaceId];
897     }
898 
899     /**
900      * @dev Registers the contract as an implementer of the interface defined by
901      * `interfaceId`. Support of the actual ERC165 interface is automatic and
902      * registering its interface id is not required.
903      *
904      * See {IERC165-supportsInterface}.
905      *
906      * Requirements:
907      *
908      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
909      */
910     function _registerInterface(bytes4 interfaceId) internal virtual {
911         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
912         _supportedInterfaces[interfaceId] = true;
913     }
914 }
915 
916 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
917 
918 
919 
920 
921 pragma solidity ^0.8.0;
922 
923 
924 /**
925  * @dev Required interface of an ERC721 compliant contract.
926  */
927 interface IERC721 is IERC165 {
928     /**
929      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
930      */
931     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
932 
933     /**
934      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
935      */
936     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
937 
938     /**
939      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
940      */
941     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
942 
943     /**
944      * @dev Returns the number of tokens in ``owner``'s account.
945      */
946     function balanceOf(address owner) external view returns (uint256 balance);
947 
948     /**
949      * @dev Returns the owner of the `tokenId` token.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must exist.
954      */
955     function ownerOf(uint256 tokenId) external view returns (address owner);
956 
957     /**
958      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
959      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
960      *
961      * Requirements:
962      *
963      * - `from` cannot be the zero address.
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must exist and be owned by `from`.
966      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
967      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
968      *
969      * Emits a {Transfer} event.
970      */
971     function safeTransferFrom(address from, address to, uint256 tokenId) external;
972 
973     /**
974      * @dev Transfers `tokenId` token from `from` to `to`.
975      *
976      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
977      *
978      * Requirements:
979      *
980      * - `from` cannot be the zero address.
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
984      *
985      * Emits a {Transfer} event.
986      */
987     function transferFrom(address from, address to, uint256 tokenId) external;
988 
989     /**
990      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
991      * The approval is cleared when the token is transferred.
992      *
993      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
994      *
995      * Requirements:
996      *
997      * - The caller must own the token or be an approved operator.
998      * - `tokenId` must exist.
999      *
1000      * Emits an {Approval} event.
1001      */
1002     function approve(address to, uint256 tokenId) external;
1003 
1004     /**
1005      * @dev Returns the account approved for `tokenId` token.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      */
1011     function getApproved(uint256 tokenId) external view returns (address operator);
1012 
1013     /**
1014      * @dev Approve or remove `operator` as an operator for the caller.
1015      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1016      *
1017      * Requirements:
1018      *
1019      * - The `operator` cannot be the caller.
1020      *
1021      * Emits an {ApprovalForAll} event.
1022      */
1023     function setApprovalForAll(address operator, bool _approved) external;
1024 
1025     /**
1026      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1027      *
1028      * See {setApprovalForAll}
1029      */
1030     function isApprovedForAll(address owner, address operator) external view returns (bool);
1031 
1032     /**
1033       * @dev Safely transfers `tokenId` token from `from` to `to`.
1034       *
1035       * Requirements:
1036       *
1037       * - `from` cannot be the zero address.
1038       * - `to` cannot be the zero address.
1039       * - `tokenId` token must exist and be owned by `from`.
1040       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1041       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1042       *
1043       * Emits a {Transfer} event.
1044       */
1045     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1046 }
1047 
1048 
1049 pragma solidity ^0.8.0;
1050 
1051 /**
1052  * @title ERC721 token receiver interface
1053  * @dev Interface for any contract that wants to support safeTransfers
1054  * from ERC721 asset contracts.
1055  */
1056 interface IERC721Receiver {
1057     /**
1058      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1059      * by `operator` from `from`, this function is called.
1060      *
1061      * It must return its Solidity selector to confirm the token transfer.
1062      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1063      *
1064      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1065      */
1066     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1067 }
1068 
1069 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1070 
1071 
1072 
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 
1077 /**
1078  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1079  * @dev See https://eips.ethereum.org/EIPS/eip-721
1080  */
1081 interface IERC721Enumerable is IERC721 {
1082 
1083     /**
1084      * @dev Returns the total amount of tokens stored by the contract.
1085      */
1086     function totalSupply() external view returns (uint256);
1087 
1088     /**
1089      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1090      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1091      */
1092     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1093 
1094     /**
1095      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1096      * Use along with {totalSupply} to enumerate all tokens.
1097      */
1098     function tokenByIndex(uint256 index) external view returns (uint256);
1099 }
1100 
1101 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1102 
1103 
1104 
1105 
1106 pragma solidity ^0.8.0;
1107 
1108 
1109 /**
1110  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1111  * @dev See https://eips.ethereum.org/EIPS/eip-721
1112  */
1113 interface IERC721Metadata is IERC721 {
1114 
1115     /**
1116      * @dev Returns the token collection name.
1117      */
1118     function name() external view returns (string memory);
1119 
1120     /**
1121      * @dev Returns the token collection symbol.
1122      */
1123     function symbol() external view returns (string memory);
1124 
1125     /**
1126      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1127      */
1128     function tokenURI(uint256 tokenId) external view returns (string memory);
1129 }
1130 
1131 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1132 
1133 
1134 
1135 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1136 
1137 
1138 
1139 
1140 pragma solidity ^0.8.0;
1141 
1142 /*
1143  * @dev Provides information about the current execution context, including the
1144  * sender of the transaction and its data. While these are generally available
1145  * via msg.sender and msg.data, they should not be accessed in such a direct
1146  * manner, since when dealing with GSN meta-transactions the account sending and
1147  * paying for execution may not be the actual sender (as far as an application
1148  * is concerned).
1149  *
1150  * This contract is only required for intermediate, library-like contracts.
1151  */
1152 abstract contract Context {
1153     function _msgSender() internal view virtual returns (address) {
1154         return msg.sender;
1155     }
1156 
1157     function _msgData() internal view virtual returns (bytes calldata) {
1158         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1159         return msg.data;
1160     }
1161 }
1162 
1163 
1164 
1165 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1166 
1167 
1168 
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 
1181 
1182 /**
1183  * @title ERC721 Non-Fungible Token Standard basic implementation
1184  * @dev see https://eips.ethereum.org/EIPS/eip-721
1185  */
1186 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1187     using Address for address;
1188     using EnumerableSet for EnumerableSet.UintSet;
1189     using EnumerableMap for EnumerableMap.UintToAddressMap;
1190     using Strings for uint256;
1191 
1192     // Mapping from holder address to their (enumerable) set of owned tokens
1193     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1194 
1195     // Enumerable mapping from token ids to their owners
1196     EnumerableMap.UintToAddressMap private _tokenOwners;
1197 
1198     // Mapping from token ID to approved address
1199     mapping (uint256 => address) private _tokenApprovals;
1200 
1201     // Mapping from owner to operator approvals
1202     mapping (address => mapping (address => bool)) private _operatorApprovals;
1203 
1204     // Token name
1205     string private _name;
1206 
1207     // Token symbol
1208     string private _symbol;
1209 
1210     // Optional mapping for token URIs
1211     mapping (uint256 => string) private _tokenURIs;
1212 
1213     // Base URI
1214     string private _baseURI;
1215 
1216     /**
1217      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1218      */
1219     constructor (string memory name_, string memory symbol_) {
1220         _name = name_;
1221         _symbol = symbol_;
1222 
1223         // register the supported interfaces to conform to ERC721 via ERC165
1224         _registerInterface(type(IERC721).interfaceId);
1225         _registerInterface(type(IERC721Metadata).interfaceId);
1226         _registerInterface(type(IERC721Enumerable).interfaceId);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-balanceOf}.
1231      */
1232     function balanceOf(address owner) public view virtual override returns (uint256) {
1233         require(owner != address(0), "ERC721: balance query for the zero address");
1234         return _holderTokens[owner].length();
1235     }
1236     
1237 
1238     
1239     /**
1240      * @dev See {IERC721-ownerOf}.
1241      */
1242     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1243         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-name}.
1248      */
1249     function name() public view virtual override returns (string memory) {
1250         return _name;
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Metadata-symbol}.
1255      */
1256     function symbol() public view virtual override returns (string memory) {
1257         return _symbol;
1258     }
1259 
1260     /**
1261      * @dev See {IERC721Metadata-tokenURI}.
1262      */
1263     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1264         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1265 
1266         string memory _tokenURI = _tokenURIs[tokenId];
1267         string memory base = baseURI();
1268 
1269         // If there is no base URI, return the token URI.
1270         if (bytes(base).length == 0) {
1271             return _tokenURI;
1272         }
1273         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1274         if (bytes(_tokenURI).length > 0) {
1275             return string(abi.encodePacked(base, _tokenURI));
1276         }
1277         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1278         return string(abi.encodePacked(base, tokenId.toString()));
1279     }
1280 
1281     /**
1282     * @dev Returns the base URI set via {_setBaseURI}. This will be
1283     * automatically added as a prefix in {tokenURI} to each token's URI, or
1284     * to the token ID if no specific URI is set for that token ID.
1285     */
1286     function baseURI() public view virtual returns (string memory) {
1287         return _baseURI;
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1292      */
1293     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1294         return _holderTokens[owner].at(index);
1295     }
1296 
1297     /**
1298      * @dev See {IERC721Enumerable-totalSupply}.
1299      */
1300     function totalSupply() public view virtual override returns (uint256) {
1301         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1302         return _tokenOwners.length();
1303     }
1304 
1305     /**
1306      * @dev See {IERC721Enumerable-tokenByIndex}.
1307      */
1308     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1309         (uint256 tokenId, ) = _tokenOwners.at(index);
1310         return tokenId;
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-approve}.
1315      */
1316     function approve(address to, uint256 tokenId) public virtual override {
1317         address owner = ERC721.ownerOf(tokenId);
1318         require(to != owner, "ERC721: approval to current owner");
1319 
1320         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1321             "ERC721: approve caller is not owner nor approved for all"
1322         );
1323 
1324         _approve(to, tokenId);
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-getApproved}.
1329      */
1330     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1331         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1332 
1333         return _tokenApprovals[tokenId];
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-setApprovalForAll}.
1338      */
1339     function setApprovalForAll(address operator, bool approved) public virtual override {
1340         require(operator != _msgSender(), "ERC721: approve to caller");
1341 
1342         _operatorApprovals[_msgSender()][operator] = approved;
1343         emit ApprovalForAll(_msgSender(), operator, approved);
1344     }
1345 
1346     /**
1347      * @dev See {IERC721-isApprovedForAll}.
1348      */
1349     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1350         return _operatorApprovals[owner][operator];
1351     }
1352 
1353     /**
1354      * @dev See {IERC721-transferFrom}.
1355      */
1356     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1357         //solhint-disable-next-line max-line-length
1358         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1359 
1360         _transfer(from, to, tokenId);
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-safeTransferFrom}.
1365      */
1366     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1367         safeTransferFrom(from, to, tokenId, "");
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-safeTransferFrom}.
1372      */
1373     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1374         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1375         _safeTransfer(from, to, tokenId, _data);
1376     }
1377 
1378     /**
1379      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1380      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1381      *
1382      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1383      *
1384      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1385      * implement alternative mechanisms to perform token transfer, such as signature-based.
1386      *
1387      * Requirements:
1388      *
1389      * - `from` cannot be the zero address.
1390      * - `to` cannot be the zero address.
1391      * - `tokenId` token must exist and be owned by `from`.
1392      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1393      *
1394      * Emits a {Transfer} event.
1395      */
1396     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1397         _transfer(from, to, tokenId);
1398         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1399     }
1400 
1401     /**
1402      * @dev Returns whether `tokenId` exists.
1403      *
1404      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1405      *
1406      * Tokens start existing when they are minted (`_mint`),
1407      * and stop existing when they are burned (`_burn`).
1408      */
1409     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1410         return _tokenOwners.contains(tokenId);
1411     }
1412 
1413     /**
1414      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1415      *
1416      * Requirements:
1417      *
1418      * - `tokenId` must exist.
1419      */
1420     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1421         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1422         address owner = ERC721.ownerOf(tokenId);
1423         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1424     }
1425 
1426     /**
1427      * @dev Safely mints `tokenId` and transfers it to `to`.
1428      *
1429      * Requirements:
1430      d*
1431      * - `tokenId` must not exist.
1432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _safeMint(address to, uint256 tokenId) internal virtual {
1437         _safeMint(to, tokenId, "");
1438     }
1439 
1440     /**
1441      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1442      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1443      */
1444     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1445         _mint(to, tokenId);
1446         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1447     }
1448 
1449     /**
1450      * @dev Mints `tokenId` and transfers it to `to`.
1451      *
1452      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1453      *
1454      * Requirements:
1455      *
1456      * - `tokenId` must not exist.
1457      * - `to` cannot be the zero address.
1458      *
1459      * Emits a {Transfer} event.
1460      */
1461     function _mint(address to, uint256 tokenId) internal virtual {
1462         require(to != address(0), "ERC721: mint to the zero address");
1463         require(!_exists(tokenId), "ERC721: token already minted");
1464 
1465         _beforeTokenTransfer(address(0), to, tokenId);
1466 
1467         _holderTokens[to].add(tokenId);
1468 
1469         _tokenOwners.set(tokenId, to);
1470 
1471         emit Transfer(address(0), to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev Destroys `tokenId`.
1476      * The approval is cleared when the token is burned.
1477      *
1478      * Requirements:
1479      *
1480      * - `tokenId` must exist.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function _burn(uint256 tokenId) internal virtual {
1485         address owner = ERC721.ownerOf(tokenId); // internal owner
1486 
1487         _beforeTokenTransfer(owner, address(0), tokenId);
1488 
1489         // Clear approvals
1490         _approve(address(0), tokenId);
1491 
1492         // Clear metadata (if any)
1493         if (bytes(_tokenURIs[tokenId]).length != 0) {
1494             delete _tokenURIs[tokenId];
1495         }
1496 
1497         _holderTokens[owner].remove(tokenId);
1498 
1499         _tokenOwners.remove(tokenId);
1500 
1501         emit Transfer(owner, address(0), tokenId);
1502     }
1503 
1504     /**
1505      * @dev Transfers `tokenId` from `from` to `to`.
1506      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1507      *
1508      * Requirements:
1509      *
1510      * - `to` cannot be the zero address.
1511      * - `tokenId` token must be owned by `from`.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1516         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1517         require(to != address(0), "ERC721: transfer to the zero address");
1518 
1519         _beforeTokenTransfer(from, to, tokenId);
1520 
1521         // Clear approvals from the previous owner
1522         _approve(address(0), tokenId);
1523 
1524         _holderTokens[from].remove(tokenId);
1525         _holderTokens[to].add(tokenId);
1526 
1527         _tokenOwners.set(tokenId, to);
1528 
1529         emit Transfer(from, to, tokenId);
1530     }
1531 
1532     /**
1533      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1534      *
1535      * Requirements:
1536      *
1537      * - `tokenId` must exist.
1538      */
1539     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1540         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1541         _tokenURIs[tokenId] = _tokenURI;
1542     }
1543 
1544     /**
1545      * @dev Internal function to set the base URI for all token IDs. It is
1546      * automatically added as a prefix to the value returned in {tokenURI},
1547      * or to the token ID if {tokenURI} is empty.
1548      */
1549     function _setBaseURI(string memory baseURI_) internal virtual {
1550         _baseURI = baseURI_;
1551     }
1552 
1553     /**
1554      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1555      * The call is not executed if the target address is not a contract.
1556      *
1557      * @param from address representing the previous owner of the given token ID
1558      * @param to target address that will receive the tokens
1559      * @param tokenId uint256 ID of the token to be transferred
1560      * @param _data bytes optional data to send along with the call
1561      * @return bool whether the call correctly returned the expected magic value
1562      */
1563     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1564         private returns (bool)
1565     {
1566         if (to.isContract()) {
1567             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1568                 return retval == IERC721Receiver(to).onERC721Received.selector;
1569             } catch (bytes memory reason) {
1570                 if (reason.length == 0) {
1571                     revert("ERC721: transfer to non ERC721Receiver implementer");
1572                 } else {
1573                     // solhint-disable-next-line no-inline-assembly
1574                     assembly {
1575                         revert(add(32, reason), mload(reason))
1576                     }
1577                 }
1578             }
1579         } else {
1580             return true;
1581         }
1582     }
1583 
1584     function _approve(address to, uint256 tokenId) private {
1585         _tokenApprovals[tokenId] = to;
1586         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1587     }
1588 
1589     /**
1590      * @dev Hook that is called before any token transfer. This includes minting
1591      * and burning.
1592      *
1593      * Calling conditions:
1594      *
1595      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1596      * transferred to `to`.
1597      * - When `from` is zero, `tokenId` will be minted for `to`.
1598      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1599      * - `from` cannot be the zero address.
1600      * - `to` cannot be the zero address.
1601      *
1602      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1603      */
1604     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1605 }
1606 
1607 
1608 
1609 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1610 
1611 
1612 
1613 
1614 pragma solidity ^0.8.0;
1615 
1616 /**
1617  * @dev Contract module which provides a basic access control mechanism, where
1618  * there is an account (an owner) that can be granted exclusive access to
1619  * specific functions.
1620  *
1621  * By default, the owner account will be the one that deploys the contract. This
1622  * can later be changed with {transferOwnership}.
1623  *
1624  * This module is used through inheritance. It will make available the modifier
1625  * `onlyOwner`, which can be applied to your functions to restrict their use to
1626  * the owner.
1627  */
1628 abstract contract Ownable is Context {
1629     address private _owner;
1630 
1631     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1632 
1633     /**
1634      * @dev Initializes the contract setting the deployer as the initial owner.
1635      */
1636     constructor () {
1637         address msgSender = _msgSender();
1638         _owner = msgSender;
1639         emit OwnershipTransferred(address(0), msgSender);
1640     }
1641 
1642     /**
1643      * @dev Returns the address of the current owner.
1644      */
1645     function owner() public view virtual returns (address) {
1646         return _owner;
1647     }
1648 
1649     /**
1650      * @dev Throws if called by any account other than the owner.
1651      */
1652     modifier onlyOwner() {
1653         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1654         _;
1655     }
1656 
1657     /**
1658      * @dev Leaves the contract without owner. It will not be possible to call
1659      * `onlyOwner` functions anymore. Can only be called by the current owner.
1660      *
1661      * NOTE: Renouncing ownership will leave the contract without an owner,
1662      * thereby removing any functionality that is only available to the owner.
1663      */
1664     function renounceOwnership() public virtual onlyOwner {
1665         emit OwnershipTransferred(_owner, address(0));
1666         _owner = address(0);
1667     }
1668 
1669     /**
1670      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1671      * Can only be called by the current owner.
1672      */
1673     function transferOwnership(address newOwner) public virtual onlyOwner {
1674         require(newOwner != address(0), "Ownable: new owner is the zero address");
1675         emit OwnershipTransferred(_owner, newOwner);
1676         _owner = newOwner;
1677     }
1678 }
1679 
1680 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1681 
1682 
1683 
1684 
1685 pragma solidity ^0.8.0;
1686 
1687 // CAUTION
1688 // This version of SafeMath should only be used with Solidity 0.8 or later,
1689 // because it relies on the compiler's built in overflow checks.
1690 
1691 /**
1692  * @dev Wrappers over Solidity's arithmetic operations.
1693  *
1694  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1695  * now has built in overflow checking.
1696  */
1697 library SafeMath {
1698     /**
1699      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1700      *
1701      * _Available since v3.4._
1702      */
1703     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1704         unchecked {
1705             uint256 c = a + b;
1706             if (c < a) return (false, 0);
1707             return (true, c);
1708         }
1709     }
1710 
1711     /**
1712      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1713      *
1714      * _Available since v3.4._
1715      */
1716     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1717         unchecked {
1718             if (b > a) return (false, 0);
1719             return (true, a - b);
1720         }
1721     }
1722 
1723     /**
1724      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1725      *
1726      * _Available since v3.4._
1727      */
1728     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1729         unchecked {
1730             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1731             // benefit is lost if 'b' is also tested.
1732             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1733             if (a == 0) return (true, 0);
1734             uint256 c = a * b;
1735             if (c / a != b) return (false, 0);
1736             return (true, c);
1737         }
1738     }
1739 
1740     /**
1741      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1742      *
1743      * _Available since v3.4._
1744      */
1745     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1746         unchecked {
1747             if (b == 0) return (false, 0);
1748             return (true, a / b);
1749         }
1750     }
1751 
1752     /**
1753      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1754      *
1755      * _Available since v3.4._
1756      */
1757     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1758         unchecked {
1759             if (b == 0) return (false, 0);
1760             return (true, a % b);
1761         }
1762     }
1763 
1764     /**
1765      * @dev Returns the addition of two unsigned integers, reverting on
1766      * overflow.
1767      *
1768      * Counterpart to Solidity's `+` operator.
1769      *
1770      * Requirements:
1771      *
1772      * - Addition cannot overflow.
1773      */
1774     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1775         return a + b;
1776     }
1777 
1778     /**
1779      * @dev Returns the subtraction of two unsigned integers, reverting on
1780      * overflow (when the result is negative).
1781      *
1782      * Counterpart to Solidity's `-` operator.
1783      *
1784      * Requirements:
1785      *
1786      * - Subtraction cannot overflow.
1787      */
1788     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1789         return a - b;
1790     }
1791 
1792     /**
1793      * @dev Returns the multiplication of two unsigned integers, reverting on
1794      * overflow.
1795      *
1796      * Counterpart to Solidity's `*` operator.
1797      *
1798      * Requirements:
1799      *
1800      * - Multiplication cannot overflow.
1801      */
1802     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1803         return a * b;
1804     }
1805 
1806     /**
1807      * @dev Returns the integer division of two unsigned integers, reverting on
1808      * division by zero. The result is rounded towards zero.
1809      *
1810      * Counterpart to Solidity's `/` operator.
1811      *
1812      * Requirements:
1813      *
1814      * - The divisor cannot be zero.
1815      */
1816     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1817         return a / b;
1818     }
1819 
1820     /**
1821      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1822      * reverting when dividing by zero.
1823      *
1824      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1825      * opcode (which leaves remaining gas untouched) while Solidity uses an
1826      * invalid opcode to revert (consuming all remaining gas).
1827      *
1828      * Requirements:
1829      *
1830      * - The divisor cannot be zero.
1831      */
1832     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1833         return a % b;
1834     }
1835 
1836     /**
1837      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1838      * overflow (when the result is negative).
1839      *
1840      * CAUTION: This function is deprecated because it requires allocating memory for the error
1841      * message unnecessarily. For custom revert reasons use {trySub}.
1842      *
1843      * Counterpart to Solidity's `-` operator.
1844      *
1845      * Requirements:
1846      *
1847      * - Subtraction cannot overflow.
1848      */
1849     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1850         unchecked {
1851             require(b <= a, errorMessage);
1852             return a - b;
1853         }
1854     }
1855 
1856     /**
1857      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1858      * division by zero. The result is rounded towards zero.
1859      *
1860      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1861      * opcode (which leaves remaining gas untouched) while Solidity uses an
1862      * invalid opcode to revert (consuming all remaining gas).
1863      *
1864      * Counterpart to Solidity's `/` operator. Note: this function uses a
1865      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1866      * uses an invalid opcode to revert (consuming all remaining gas).
1867      *
1868      * Requirements:
1869      *
1870      * - The divisor cannot be zero.
1871      */
1872     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1873         unchecked {
1874             require(b > 0, errorMessage);
1875             return a / b;
1876         }
1877     }
1878 
1879     /**
1880      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1881      * reverting with custom message when dividing by zero.
1882      *
1883      * CAUTION: This function is deprecated because it requires allocating memory for the error
1884      * message unnecessarily. For custom revert reasons use {tryMod}.
1885      *
1886      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1887      * opcode (which leaves remaining gas untouched) while Solidity uses an
1888      * invalid opcode to revert (consuming all remaining gas).
1889      *
1890      * Requirements:
1891      *
1892      * - The divisor cannot be zero.
1893      */
1894     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1895         unchecked {
1896             require(b > 0, errorMessage);
1897             return a % b;
1898         }
1899     }
1900 }
1901 
1902 // File: astrocryptids_v3.sol
1903 
1904 
1905 
1906 
1907 
1908 pragma solidity ^0.8.0;
1909 
1910 
1911 
1912 
1913 
1914 contract ASTROCRYPTIDS is ERC721, Ownable {
1915     using SafeMath for uint256;
1916     uint public constant MAX_ASTROCRYPTIDS = 16180;
1917     bool public hasSaleStarted = false;
1918     
1919     // IPFS of all tokens will live here when all Astrocryptids are finalized. Thank you BGAN Punks.
1920     string public METADATA_PROVENANCE_HASH = "";
1921     
1922     
1923     constructor() ERC721("ASTROCRYPTIDS","ASTROCRYPTIDS")  {
1924         setBaseURI("https://astrocryptids.com/api/test/json/");
1925         
1926         // Ciel
1927         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 0);
1928         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 1);
1929         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 2);
1930         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 3);
1931         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 4);
1932         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 5);
1933         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 6);
1934         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 7);
1935         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 8);
1936         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 9);
1937         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 10);
1938         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 11);
1939         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 12);
1940         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 13);
1941         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 14);
1942         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 15);
1943         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 16);
1944         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 17);
1945         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 18);
1946         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 19);
1947         
1948         // Supported Astrocryptids
1949         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 20);
1950         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 21);
1951         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 22);
1952         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 23);
1953         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 24);
1954         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 25);
1955         
1956         // Giveaway
1957         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 26);
1958         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 27);
1959         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 28);
1960         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 29);
1961         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 30);
1962         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 31);
1963         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 32);
1964         _safeMint(address(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4), 33);
1965     }
1966     
1967 
1968    
1969     
1970 
1971     
1972     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1973         uint256 tokenCount = balanceOf(_owner);
1974         if (tokenCount == 0) {
1975             // Return an empty array
1976             return new uint256[](0);
1977         } else {
1978             uint256[] memory result = new uint256[](tokenCount);
1979             uint256 index;
1980             for (index = 0; index < tokenCount; index++) {
1981                 result[index] = tokenOfOwnerByIndex(_owner, index);
1982             }
1983             return result;
1984         }
1985     }
1986     
1987     function calculatePrice() public view returns (uint256) {
1988         require(hasSaleStarted == true, "Sale hasn't started");
1989 
1990         require(totalSupply() < MAX_ASTROCRYPTIDS, "Sale has already ended");
1991 
1992         uint currentSupply = totalSupply();
1993         if (currentSupply >= 6180) {
1994             return 20000000000000000; // 6180 - 16179: 0.02 ETH
1995         } else {
1996             return 10000000000000000; // 0 - 6179: 0.01 ETH
1997         }
1998         
1999     }
2000     
2001      function calculatePriceTest(uint _id) public view returns (uint256) {
2002 
2003 
2004         require(_id < MAX_ASTROCRYPTIDS, "Sale has already ended");
2005 
2006         if (_id >= 6180) {
2007             return 20000000000000000; // 6180 - 16179: 0.02 ETH
2008         } else {
2009             return 10000000000000000; // 0 - 6179: 0.01 ETH
2010         }
2011         
2012     }
2013     
2014    function adoptASTROCRYPTID(uint256 numAstrocryptids) public payable {
2015         require(totalSupply() < MAX_ASTROCRYPTIDS, "Sale has already ended");
2016         require(numAstrocryptids > 0 && numAstrocryptids <= 25, "You can adopt minimum 1, maximum 25 astrocryptids");
2017         require(totalSupply().add(numAstrocryptids) <= MAX_ASTROCRYPTIDS, "Exceeds MAX_ASTROCRYPTIDS");
2018         require(msg.value >= calculatePrice().mul(numAstrocryptids), "Ether value sent is below the price");
2019 
2020         for (uint i = 0; i < numAstrocryptids; i++) {
2021             uint mintIndex = totalSupply();
2022             _safeMint(msg.sender, mintIndex);
2023         }
2024 
2025     }
2026     
2027     // ONLYOWNER FUNCTIONS
2028     
2029     function setProvenanceHash(string memory _hash) public onlyOwner {
2030         METADATA_PROVENANCE_HASH = _hash;
2031     }
2032     
2033     function setBaseURI(string memory baseURI) public onlyOwner {
2034         _setBaseURI(baseURI);
2035     }
2036     
2037     function startDrop() public onlyOwner {
2038         hasSaleStarted = true;
2039     }
2040     function pauseDrop() public onlyOwner {
2041         hasSaleStarted = false;
2042     }
2043     
2044     
2045     function withdrawAll() public payable onlyOwner {
2046         require(payable(msg.sender).send(address(this).balance));
2047     }
2048     
2049 
2050 
2051 }