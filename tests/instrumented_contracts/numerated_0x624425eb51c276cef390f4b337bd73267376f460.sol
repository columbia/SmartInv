1 /*
2 SPDX-License-Identifier: GPL-3.0                                                                             
3 */       
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` representation.
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
28         uint256 index = digits - 1;
29         temp = value;
30         while (temp != 0) {
31             buffer[index--] = bytes1(uint8(48 + temp % 10));
32             temp /= 10;
33         }
34         return string(buffer);
35     }
36 }
37 
38 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/EnumerableMap.sol
39 
40 
41 
42 pragma solidity >=0.6.0 <0.8.0;
43 
44 /**
45  * @dev Library for managing an enumerable variant of Solidity's
46  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
47  * type.
48  *
49  * Maps have the following properties:
50  *
51  * - Entries are added, removed, and checked for existence in constant time
52  * (O(1)).
53  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
54  *
55  * ```
56  * contract Example {
57  *     // Add the library methods
58  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
59  *
60  *     // Declare a set state variable
61  *     EnumerableMap.UintToAddressMap private myMap;
62  * }
63  * ```
64  *
65  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
66  * supported.
67  */
68 library EnumerableMap {
69     // To implement this library for multiple types with as little code
70     // repetition as possible, we write it in terms of a generic Map type with
71     // bytes32 keys and values.
72     // The Map implementation uses private functions, and user-facing
73     // implementations (such as Uint256ToAddressMap) are just wrappers around
74     // the underlying Map.
75     // This means that we can only create new EnumerableMaps for types that fit
76     // in bytes32.
77 
78     struct MapEntry {
79         bytes32 _key;
80         bytes32 _value;
81     }
82 
83     struct Map {
84         // Storage of map keys and values
85         MapEntry[] _entries;
86 
87         // Position of the entry defined by a key in the `entries` array, plus 1
88         // because index 0 means a key is not in the map.
89         mapping (bytes32 => uint256) _indexes;
90     }
91 
92     /**
93      * @dev Adds a key-value pair to a map, or updates the value for an existing
94      * key. O(1).
95      *
96      * Returns true if the key was added to the map, that is if it was not
97      * already present.
98      */
99     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
100         // We read and store the key's index to prevent multiple reads from the same storage slot
101         uint256 keyIndex = map._indexes[key];
102 
103         if (keyIndex == 0) { // Equivalent to !contains(map, key)
104             map._entries.push(MapEntry({ _key: key, _value: value }));
105             // The entry is stored at length-1, but we add 1 to all indexes
106             // and use 0 as a sentinel value
107             map._indexes[key] = map._entries.length;
108             return true;
109         } else {
110             map._entries[keyIndex - 1]._value = value;
111             return false;
112         }
113     }
114 
115     /**
116      * @dev Removes a key-value pair from a map. O(1).
117      *
118      * Returns true if the key was removed from the map, that is if it was present.
119      */
120     function _remove(Map storage map, bytes32 key) private returns (bool) {
121         // We read and store the key's index to prevent multiple reads from the same storage slot
122         uint256 keyIndex = map._indexes[key];
123 
124         if (keyIndex != 0) { // Equivalent to contains(map, key)
125             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
126             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
127             // This modifies the order of the array, as noted in {at}.
128 
129             uint256 toDeleteIndex = keyIndex - 1;
130             uint256 lastIndex = map._entries.length - 1;
131 
132             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
133             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
134 
135             MapEntry storage lastEntry = map._entries[lastIndex];
136 
137             // Move the last entry to the index where the entry to delete is
138             map._entries[toDeleteIndex] = lastEntry;
139             // Update the index for the moved entry
140             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
141 
142             // Delete the slot where the moved entry was stored
143             map._entries.pop();
144 
145             // Delete the index for the deleted slot
146             delete map._indexes[key];
147 
148             return true;
149         } else {
150             return false;
151         }
152     }
153 
154     /**
155      * @dev Returns true if the key is in the map. O(1).
156      */
157     function _contains(Map storage map, bytes32 key) private view returns (bool) {
158         return map._indexes[key] != 0;
159     }
160 
161     /**
162      * @dev Returns the number of key-value pairs in the map. O(1).
163      */
164     function _length(Map storage map) private view returns (uint256) {
165         return map._entries.length;
166     }
167 
168    /**
169     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
170     *
171     * Note that there are no guarantees on the ordering of entries inside the
172     * array, and it may change when more entries are added or removed.
173     *
174     * Requirements:
175     *
176     * - `index` must be strictly less than {length}.
177     */
178     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
179         require(map._entries.length > index, "EnumerableMap: index out of bounds");
180 
181         MapEntry storage entry = map._entries[index];
182         return (entry._key, entry._value);
183     }
184 
185     /**
186      * @dev Tries to returns the value associated with `key`.  O(1).
187      * Does not revert if `key` is not in the map.
188      */
189     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
190         uint256 keyIndex = map._indexes[key];
191         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
192         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
193     }
194 
195     /**
196      * @dev Returns the value associated with `key`.  O(1).
197      *
198      * Requirements:
199      *
200      * - `key` must be in the map.
201      */
202     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
203         uint256 keyIndex = map._indexes[key];
204         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
205         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
206     }
207 
208     /**
209      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {_tryGet}.
213      */
214     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
215         uint256 keyIndex = map._indexes[key];
216         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
217         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
218     }
219 
220     // UintToAddressMap
221 
222     struct UintToAddressMap {
223         Map _inner;
224     }
225 
226     /**
227      * @dev Adds a key-value pair to a map, or updates the value for an existing
228      * key. O(1).
229      *
230      * Returns true if the key was added to the map, that is if it was not
231      * already present.
232      */
233     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
234         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
235     }
236 
237     /**
238      * @dev Removes a value from a set. O(1).
239      *
240      * Returns true if the key was removed from the map, that is if it was present.
241      */
242     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
243         return _remove(map._inner, bytes32(key));
244     }
245 
246     /**
247      * @dev Returns true if the key is in the map. O(1).
248      */
249     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
250         return _contains(map._inner, bytes32(key));
251     }
252 
253     /**
254      * @dev Returns the number of elements in the map. O(1).
255      */
256     function length(UintToAddressMap storage map) internal view returns (uint256) {
257         return _length(map._inner);
258     }
259 
260    /**
261     * @dev Returns the element stored at position `index` in the set. O(1).
262     * Note that there are no guarantees on the ordering of values inside the
263     * array, and it may change when more values are added or removed.
264     *
265     * Requirements:
266     *
267     * - `index` must be strictly less than {length}.
268     */
269     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
270         (bytes32 key, bytes32 value) = _at(map._inner, index);
271         return (uint256(key), address(uint160(uint256(value))));
272     }
273 
274     /**
275      * @dev Tries to returns the value associated with `key`.  O(1).
276      * Does not revert if `key` is not in the map.
277      *
278      * _Available since v3.4._
279      */
280     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
281         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
282         return (success, address(uint160(uint256(value))));
283     }
284 
285     /**
286      * @dev Returns the value associated with `key`.  O(1).
287      *
288      * Requirements:
289      *
290      * - `key` must be in the map.
291      */
292     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
293         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
294     }
295 
296     /**
297      * @dev Same as {get}, with a custom error message when `key` is not in the map.
298      *
299      * CAUTION: This function is deprecated because it requires allocating memory for the error
300      * message unnecessarily. For custom revert reasons use {tryGet}.
301      */
302     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
303         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
304     }
305 }
306 
307 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/EnumerableSet.sol
308 
309 
310 
311 pragma solidity >=0.6.0 <0.8.0;
312 
313 /**
314  * @dev Library for managing
315  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
316  * types.
317  *
318  * Sets have the following properties:
319  *
320  * - Elements are added, removed, and checked for existence in constant time
321  * (O(1)).
322  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
323  *
324  * ```
325  * contract Example {
326  *     // Add the library methods
327  *     using EnumerableSet for EnumerableSet.AddressSet;
328  *
329  *     // Declare a set state variable
330  *     EnumerableSet.AddressSet private mySet;
331  * }
332  * ```
333  *
334  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
335  * and `uint256` (`UintSet`) are supported.
336  */
337 library EnumerableSet {
338     // To implement this library for multiple types with as little code
339     // repetition as possible, we write it in terms of a generic Set type with
340     // bytes32 values.
341     // The Set implementation uses private functions, and user-facing
342     // implementations (such as AddressSet) are just wrappers around the
343     // underlying Set.
344     // This means that we can only create new EnumerableSets for types that fit
345     // in bytes32.
346 
347     struct Set {
348         // Storage of set values
349         bytes32[] _values;
350 
351         // Position of the value in the `values` array, plus 1 because index 0
352         // means a value is not in the set.
353         mapping (bytes32 => uint256) _indexes;
354     }
355 
356     /**
357      * @dev Add a value to a set. O(1).
358      *
359      * Returns true if the value was added to the set, that is if it was not
360      * already present.
361      */
362     function _add(Set storage set, bytes32 value) private returns (bool) {
363         if (!_contains(set, value)) {
364             set._values.push(value);
365             // The value is stored at length-1, but we add 1 to all indexes
366             // and use 0 as a sentinel value
367             set._indexes[value] = set._values.length;
368             return true;
369         } else {
370             return false;
371         }
372     }
373 
374     /**
375      * @dev Removes a value from a set. O(1).
376      *
377      * Returns true if the value was removed from the set, that is if it was
378      * present.
379      */
380     function _remove(Set storage set, bytes32 value) private returns (bool) {
381         // We read and store the value's index to prevent multiple reads from the same storage slot
382         uint256 valueIndex = set._indexes[value];
383 
384         if (valueIndex != 0) { // Equivalent to contains(set, value)
385             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
386             // the array, and then remove the last element (sometimes called as 'swap and pop').
387             // This modifies the order of the array, as noted in {at}.
388 
389             uint256 toDeleteIndex = valueIndex - 1;
390             uint256 lastIndex = set._values.length - 1;
391 
392             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
393             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
394 
395             bytes32 lastvalue = set._values[lastIndex];
396 
397             // Move the last value to the index where the value to delete is
398             set._values[toDeleteIndex] = lastvalue;
399             // Update the index for the moved value
400             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
401 
402             // Delete the slot where the moved value was stored
403             set._values.pop();
404 
405             // Delete the index for the deleted slot
406             delete set._indexes[value];
407 
408             return true;
409         } else {
410             return false;
411         }
412     }
413 
414     /**
415      * @dev Returns true if the value is in the set. O(1).
416      */
417     function _contains(Set storage set, bytes32 value) private view returns (bool) {
418         return set._indexes[value] != 0;
419     }
420 
421     /**
422      * @dev Returns the number of values on the set. O(1).
423      */
424     function _length(Set storage set) private view returns (uint256) {
425         return set._values.length;
426     }
427 
428    /**
429     * @dev Returns the value stored at position `index` in the set. O(1).
430     *
431     * Note that there are no guarantees on the ordering of values inside the
432     * array, and it may change when more values are added or removed.
433     *
434     * Requirements:
435     *
436     * - `index` must be strictly less than {length}.
437     */
438     function _at(Set storage set, uint256 index) private view returns (bytes32) {
439         require(set._values.length > index, "EnumerableSet: index out of bounds");
440         return set._values[index];
441     }
442 
443     // Bytes32Set
444 
445     struct Bytes32Set {
446         Set _inner;
447     }
448 
449     /**
450      * @dev Add a value to a set. O(1).
451      *
452      * Returns true if the value was added to the set, that is if it was not
453      * already present.
454      */
455     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
456         return _add(set._inner, value);
457     }
458 
459     /**
460      * @dev Removes a value from a set. O(1).
461      *
462      * Returns true if the value was removed from the set, that is if it was
463      * present.
464      */
465     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
466         return _remove(set._inner, value);
467     }
468 
469     /**
470      * @dev Returns true if the value is in the set. O(1).
471      */
472     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
473         return _contains(set._inner, value);
474     }
475 
476     /**
477      * @dev Returns the number of values in the set. O(1).
478      */
479     function length(Bytes32Set storage set) internal view returns (uint256) {
480         return _length(set._inner);
481     }
482 
483    /**
484     * @dev Returns the value stored at position `index` in the set. O(1).
485     *
486     * Note that there are no guarantees on the ordering of values inside the
487     * array, and it may change when more values are added or removed.
488     *
489     * Requirements:
490     *
491     * - `index` must be strictly less than {length}.
492     */
493     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
494         return _at(set._inner, index);
495     }
496 
497     // AddressSet
498 
499     struct AddressSet {
500         Set _inner;
501     }
502 
503     /**
504      * @dev Add a value to a set. O(1).
505      *
506      * Returns true if the value was added to the set, that is if it was not
507      * already present.
508      */
509     function add(AddressSet storage set, address value) internal returns (bool) {
510         return _add(set._inner, bytes32(uint256(uint160(value))));
511     }
512 
513     /**
514      * @dev Removes a value from a set. O(1).
515      *
516      * Returns true if the value was removed from the set, that is if it was
517      * present.
518      */
519     function remove(AddressSet storage set, address value) internal returns (bool) {
520         return _remove(set._inner, bytes32(uint256(uint160(value))));
521     }
522 
523     /**
524      * @dev Returns true if the value is in the set. O(1).
525      */
526     function contains(AddressSet storage set, address value) internal view returns (bool) {
527         return _contains(set._inner, bytes32(uint256(uint160(value))));
528     }
529 
530     /**
531      * @dev Returns the number of values in the set. O(1).
532      */
533     function length(AddressSet storage set) internal view returns (uint256) {
534         return _length(set._inner);
535     }
536 
537    /**
538     * @dev Returns the value stored at position `index` in the set. O(1).
539     *
540     * Note that there are no guarantees on the ordering of values inside the
541     * array, and it may change when more values are added or removed.
542     *
543     * Requirements:
544     *
545     * - `index` must be strictly less than {length}.
546     */
547     function at(AddressSet storage set, uint256 index) internal view returns (address) {
548         return address(uint160(uint256(_at(set._inner, index))));
549     }
550 
551 
552     // UintSet
553 
554     struct UintSet {
555         Set _inner;
556     }
557 
558     /**
559      * @dev Add a value to a set. O(1).
560      *
561      * Returns true if the value was added to the set, that is if it was not
562      * already present.
563      */
564     function add(UintSet storage set, uint256 value) internal returns (bool) {
565         return _add(set._inner, bytes32(value));
566     }
567 
568     /**
569      * @dev Removes a value from a set. O(1).
570      *
571      * Returns true if the value was removed from the set, that is if it was
572      * present.
573      */
574     function remove(UintSet storage set, uint256 value) internal returns (bool) {
575         return _remove(set._inner, bytes32(value));
576     }
577 
578     /**
579      * @dev Returns true if the value is in the set. O(1).
580      */
581     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
582         return _contains(set._inner, bytes32(value));
583     }
584 
585     /**
586      * @dev Returns the number of values on the set. O(1).
587      */
588     function length(UintSet storage set) internal view returns (uint256) {
589         return _length(set._inner);
590     }
591 
592    /**
593     * @dev Returns the value stored at position `index` in the set. O(1).
594     *
595     * Note that there are no guarantees on the ordering of values inside the
596     * array, and it may change when more values are added or removed.
597     *
598     * Requirements:
599     *
600     * - `index` must be strictly less than {length}.
601     */
602     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
603         return uint256(_at(set._inner, index));
604     }
605 }
606 
607 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Address.sol
608 
609 
610 
611 pragma solidity >=0.6.2 <0.8.0;
612 
613 /**
614  * @dev Collection of functions related to the address type
615  */
616 library Address {
617     /**
618      * @dev Returns true if `account` is a contract.
619      *
620      * [IMPORTANT]
621      * ====
622      * It is unsafe to assume that an address for which this function returns
623      * false is an externally-owned account (EOA) and not a contract.
624      *
625      * Among others, `isContract` will return false for the following
626      * types of addresses:
627      *
628      *  - an externally-owned account
629      *  - a contract in construction
630      *  - an address where a contract will be created
631      *  - an address where a contract lived, but was destroyed
632      * ====
633      */
634     function isContract(address account) internal view returns (bool) {
635         // This method relies on extcodesize, which returns 0 for contracts in
636         // construction, since the code is only stored at the end of the
637         // constructor execution.
638 
639         uint256 size;
640         // solhint-disable-next-line no-inline-assembly
641         assembly { size := extcodesize(account) }
642         return size > 0;
643     }
644 
645     /**
646      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
647      * `recipient`, forwarding all available gas and reverting on errors.
648      *
649      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
650      * of certain opcodes, possibly making contracts go over the 2300 gas limit
651      * imposed by `transfer`, making them unable to receive funds via
652      * `transfer`. {sendValue} removes this limitation.
653      *
654      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
655      *
656      * IMPORTANT: because control is transferred to `recipient`, care must be
657      * taken to not create reentrancy vulnerabilities. Consider using
658      * {ReentrancyGuard} or the
659      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
660      */
661     function sendValue(address payable recipient, uint256 amount) internal {
662         require(address(this).balance >= amount, "Address: insufficient balance");
663 
664         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
665         (bool success, ) = recipient.call{ value: amount }("");
666         require(success, "Address: unable to send value, recipient may have reverted");
667     }
668 
669     /**
670      * @dev Performs a Solidity function call using a low level `call`. A
671      * plain`call` is an unsafe replacement for a function call: use this
672      * function instead.
673      *
674      * If `target` reverts with a revert reason, it is bubbled up by this
675      * function (like regular Solidity function calls).
676      *
677      * Returns the raw returned data. To convert to the expected return value,
678      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
679      *
680      * Requirements:
681      *
682      * - `target` must be a contract.
683      * - calling `target` with `data` must not revert.
684      *
685      * _Available since v3.1._
686      */
687     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
688       return functionCall(target, data, "Address: low-level call failed");
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
693      * `errorMessage` as a fallback revert reason when `target` reverts.
694      *
695      * _Available since v3.1._
696      */
697     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
698         return functionCallWithValue(target, data, 0, errorMessage);
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
703      * but also transferring `value` wei to `target`.
704      *
705      * Requirements:
706      *
707      * - the calling contract must have an ETH balance of at least `value`.
708      * - the called Solidity function must be `payable`.
709      *
710      * _Available since v3.1._
711      */
712     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
713         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
718      * with `errorMessage` as a fallback revert reason when `target` reverts.
719      *
720      * _Available since v3.1._
721      */
722     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
723         require(address(this).balance >= value, "Address: insufficient balance for call");
724         require(isContract(target), "Address: call to non-contract");
725 
726         // solhint-disable-next-line avoid-low-level-calls
727         (bool success, bytes memory returndata) = target.call{ value: value }(data);
728         return _verifyCallResult(success, returndata, errorMessage);
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
733      * but performing a static call.
734      *
735      * _Available since v3.3._
736      */
737     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
738         return functionStaticCall(target, data, "Address: low-level static call failed");
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
743      * but performing a static call.
744      *
745      * _Available since v3.3._
746      */
747     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
748         require(isContract(target), "Address: static call to non-contract");
749 
750         // solhint-disable-next-line avoid-low-level-calls
751         (bool success, bytes memory returndata) = target.staticcall(data);
752         return _verifyCallResult(success, returndata, errorMessage);
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
757      * but performing a delegate call.
758      *
759      * _Available since v3.4._
760      */
761     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
762         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
763     }
764 
765     /**
766      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
767      * but performing a delegate call.
768      *
769      * _Available since v3.4._
770      */
771     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
772         require(isContract(target), "Address: delegate call to non-contract");
773 
774         // solhint-disable-next-line avoid-low-level-calls
775         (bool success, bytes memory returndata) = target.delegatecall(data);
776         return _verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
780         if (success) {
781             return returndata;
782         } else {
783             // Look for revert reason and bubble it up if present
784             if (returndata.length > 0) {
785                 // The easiest way to bubble the revert reason is using memory via assembly
786 
787                 // solhint-disable-next-line no-inline-assembly
788                 assembly {
789                     let returndata_size := mload(returndata)
790                     revert(add(32, returndata), returndata_size)
791                 }
792             } else {
793                 revert(errorMessage);
794             }
795         }
796     }
797 }
798 
799 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol
800 
801 
802 
803 pragma solidity >=0.6.0 <0.8.0;
804 
805 /**
806  * @dev Wrappers over Solidity's arithmetic operations with added overflow
807  * checks.
808  *
809  * Arithmetic operations in Solidity wrap on overflow. This can easily result
810  * in bugs, because programmers usually assume that an overflow raises an
811  * error, which is the standard behavior in high level programming languages.
812  * `SafeMath` restores this intuition by reverting the transaction when an
813  * operation overflows.
814  *
815  * Using this library instead of the unchecked operations eliminates an entire
816  * class of bugs, so it's recommended to use it always.
817  */
818 library SafeMath {
819     /**
820      * @dev Returns the addition of two unsigned integers, with an overflow flag.
821      *
822      * _Available since v3.4._
823      */
824     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
825         uint256 c = a + b;
826         if (c < a) return (false, 0);
827         return (true, c);
828     }
829 
830     /**
831      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
832      *
833      * _Available since v3.4._
834      */
835     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
836         if (b > a) return (false, 0);
837         return (true, a - b);
838     }
839 
840     /**
841      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
842      *
843      * _Available since v3.4._
844      */
845     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
846         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
847         // benefit is lost if 'b' is also tested.
848         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
849         if (a == 0) return (true, 0);
850         uint256 c = a * b;
851         if (c / a != b) return (false, 0);
852         return (true, c);
853     }
854 
855     /**
856      * @dev Returns the division of two unsigned integers, with a division by zero flag.
857      *
858      * _Available since v3.4._
859      */
860     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
861         if (b == 0) return (false, 0);
862         return (true, a / b);
863     }
864 
865     /**
866      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
867      *
868      * _Available since v3.4._
869      */
870     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
871         if (b == 0) return (false, 0);
872         return (true, a % b);
873     }
874 
875     /**
876      * @dev Returns the addition of two unsigned integers, reverting on
877      * overflow.
878      *
879      * Counterpart to Solidity's `+` operator.
880      *
881      * Requirements:
882      *
883      * - Addition cannot overflow.
884      */
885     function add(uint256 a, uint256 b) internal pure returns (uint256) {
886         uint256 c = a + b;
887         require(c >= a, "SafeMath: addition overflow");
888         return c;
889     }
890 
891     /**
892      * @dev Returns the subtraction of two unsigned integers, reverting on
893      * overflow (when the result is negative).
894      *
895      * Counterpart to Solidity's `-` operator.
896      *
897      * Requirements:
898      *
899      * - Subtraction cannot overflow.
900      */
901     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
902         require(b <= a, "SafeMath: subtraction overflow");
903         return a - b;
904     }
905 
906     /**
907      * @dev Returns the multiplication of two unsigned integers, reverting on
908      * overflow.
909      *
910      * Counterpart to Solidity's `*` operator.
911      *
912      * Requirements:
913      *
914      * - Multiplication cannot overflow.
915      */
916     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
917         if (a == 0) return 0;
918         uint256 c = a * b;
919         require(c / a == b, "SafeMath: multiplication overflow");
920         return c;
921     }
922 
923     /**
924      * @dev Returns the integer division of two unsigned integers, reverting on
925      * division by zero. The result is rounded towards zero.
926      *
927      * Counterpart to Solidity's `/` operator. Note: this function uses a
928      * `revert` opcode (which leaves remaining gas untouched) while Solidity
929      * uses an invalid opcode to revert (consuming all remaining gas).
930      *
931      * Requirements:
932      *
933      * - The divisor cannot be zero.
934      */
935     function div(uint256 a, uint256 b) internal pure returns (uint256) {
936         require(b > 0, "SafeMath: division by zero");
937         return a / b;
938     }
939 
940     /**
941      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
942      * reverting when dividing by zero.
943      *
944      * Counterpart to Solidity's `%` operator. This function uses a `revert`
945      * opcode (which leaves remaining gas untouched) while Solidity uses an
946      * invalid opcode to revert (consuming all remaining gas).
947      *
948      * Requirements:
949      *
950      * - The divisor cannot be zero.
951      */
952     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
953         require(b > 0, "SafeMath: modulo by zero");
954         return a % b;
955     }
956 
957     /**
958      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
959      * overflow (when the result is negative).
960      *
961      * CAUTION: This function is deprecated because it requires allocating memory for the error
962      * message unnecessarily. For custom revert reasons use {trySub}.
963      *
964      * Counterpart to Solidity's `-` operator.
965      *
966      * Requirements:
967      *
968      * - Subtraction cannot overflow.
969      */
970     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
971         require(b <= a, errorMessage);
972         return a - b;
973     }
974 
975     /**
976      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
977      * division by zero. The result is rounded towards zero.
978      *
979      * CAUTION: This function is deprecated because it requires allocating memory for the error
980      * message unnecessarily. For custom revert reasons use {tryDiv}.
981      *
982      * Counterpart to Solidity's `/` operator. Note: this function uses a
983      * `revert` opcode (which leaves remaining gas untouched) while Solidity
984      * uses an invalid opcode to revert (consuming all remaining gas).
985      *
986      * Requirements:
987      *
988      * - The divisor cannot be zero.
989      */
990     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
991         require(b > 0, errorMessage);
992         return a / b;
993     }
994 
995     /**
996      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
997      * reverting with custom message when dividing by zero.
998      *
999      * CAUTION: This function is deprecated because it requires allocating memory for the error
1000      * message unnecessarily. For custom revert reasons use {tryMod}.
1001      *
1002      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1003      * opcode (which leaves remaining gas untouched) while Solidity uses an
1004      * invalid opcode to revert (consuming all remaining gas).
1005      *
1006      * Requirements:
1007      *
1008      * - The divisor cannot be zero.
1009      */
1010     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1011         require(b > 0, errorMessage);
1012         return a % b;
1013     }
1014 }
1015 
1016 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721Receiver.sol
1017 
1018 
1019 
1020 pragma solidity >=0.6.0 <0.8.0;
1021 
1022 /**
1023  * @title ERC721 token receiver interface
1024  * @dev Interface for any contract that wants to support safeTransfers
1025  * from ERC721 asset contracts.
1026  */
1027 interface IERC721Receiver {
1028     /**
1029      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1030      * by `operator` from `from`, this function is called.
1031      *
1032      * It must return its Solidity selector to confirm the token transfer.
1033      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1034      *
1035      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1036      */
1037     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1038 }
1039 
1040 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/introspection/IERC165.sol
1041 
1042 
1043 
1044 pragma solidity >=0.6.0 <0.8.0;
1045 
1046 /**
1047  * @dev Interface of the ERC165 standard, as defined in the
1048  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1049  *
1050  * Implementers can declare support of contract interfaces, which can then be
1051  * queried by others ({ERC165Checker}).
1052  *
1053  * For an implementation, see {ERC165}.
1054  */
1055 interface IERC165 {
1056     /**
1057      * @dev Returns true if this contract implements the interface defined by
1058      * `interfaceId`. See the corresponding
1059      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1060      * to learn more about how these ids are created.
1061      *
1062      * This function call must use less than 30 000 gas.
1063      */
1064     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1065 }
1066 
1067 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/introspection/ERC165.sol
1068 
1069 
1070 
1071 pragma solidity >=0.6.0 <0.8.0;
1072 
1073 
1074 /**
1075  * @dev Implementation of the {IERC165} interface.
1076  *
1077  * Contracts may inherit from this and call {_registerInterface} to declare
1078  * their support of an interface.
1079  */
1080 abstract contract ERC165 is IERC165 {
1081     /*
1082      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1083      */
1084     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1085 
1086     /**
1087      * @dev Mapping of interface ids to whether or not it's supported.
1088      */
1089     mapping(bytes4 => bool) private _supportedInterfaces;
1090 
1091     constructor () {
1092         // Derived contracts need only register support for their own interfaces,
1093         // we register support for ERC165 itself here
1094         _registerInterface(_INTERFACE_ID_ERC165);
1095     }
1096 
1097     /**
1098      * @dev See {IERC165-supportsInterface}.
1099      *
1100      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1101      */
1102     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1103         return _supportedInterfaces[interfaceId];
1104     }
1105 
1106     /**
1107      * @dev Registers the contract as an implementer of the interface defined by
1108      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1109      * registering its interface id is not required.
1110      *
1111      * See {IERC165-supportsInterface}.
1112      *
1113      * Requirements:
1114      *
1115      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1116      */
1117     function _registerInterface(bytes4 interfaceId) internal virtual {
1118         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1119         _supportedInterfaces[interfaceId] = true;
1120     }
1121 }
1122 
1123 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721.sol
1124 
1125 
1126 
1127 pragma solidity >=0.6.2 <0.8.0;
1128 
1129 
1130 /**
1131  * @dev Required interface of an ERC721 compliant contract.
1132  */
1133 interface IERC721 is IERC165 {
1134     /**
1135      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1136      */
1137     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1138 
1139     /**
1140      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1141      */
1142     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1143 
1144     /**
1145      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1146      */
1147     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1148 
1149     /**
1150      * @dev Returns the number of tokens in ``owner``'s account.
1151      */
1152     function balanceOf(address owner) external view returns (uint256 balance);
1153 
1154     /**
1155      * @dev Returns the owner of the `tokenId` token.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      */
1161     function ownerOf(uint256 tokenId) external view returns (address owner);
1162 
1163     /**
1164      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1165      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1166      *
1167      * Requirements:
1168      *
1169      * - `from` cannot be the zero address.
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must exist and be owned by `from`.
1172      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1178 
1179     /**
1180      * @dev Transfers `tokenId` token from `from` to `to`.
1181      *
1182      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1183      *
1184      * Requirements:
1185      *
1186      * - `from` cannot be the zero address.
1187      * - `to` cannot be the zero address.
1188      * - `tokenId` token must be owned by `from`.
1189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function transferFrom(address from, address to, uint256 tokenId) external;
1194 
1195     /**
1196      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1197      * The approval is cleared when the token is transferred.
1198      *
1199      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1200      *
1201      * Requirements:
1202      *
1203      * - The caller must own the token or be an approved operator.
1204      * - `tokenId` must exist.
1205      *
1206      * Emits an {Approval} event.
1207      */
1208     function approve(address to, uint256 tokenId) external;
1209 
1210     /**
1211      * @dev Returns the account approved for `tokenId` token.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      */
1217     function getApproved(uint256 tokenId) external view returns (address operator);
1218 
1219     /**
1220      * @dev Approve or remove `operator` as an operator for the caller.
1221      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1222      *
1223      * Requirements:
1224      *
1225      * - The `operator` cannot be the caller.
1226      *
1227      * Emits an {ApprovalForAll} event.
1228      */
1229     function setApprovalForAll(address operator, bool _approved) external;
1230 
1231     /**
1232      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1233      *
1234      * See {setApprovalForAll}
1235      */
1236     function isApprovedForAll(address owner, address operator) external view returns (bool);
1237 
1238     /**
1239       * @dev Safely transfers `tokenId` token from `from` to `to`.
1240       *
1241       * Requirements:
1242       *
1243       * - `from` cannot be the zero address.
1244       * - `to` cannot be the zero address.
1245       * - `tokenId` token must exist and be owned by `from`.
1246       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1247       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1248       *
1249       * Emits a {Transfer} event.
1250       */
1251     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1252 }
1253 
1254 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721Enumerable.sol
1255 
1256 
1257 
1258 pragma solidity >=0.6.2 <0.8.0;
1259 
1260 
1261 /**
1262  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1263  * @dev See https://eips.ethereum.org/EIPS/eip-721
1264  */
1265 interface IERC721Enumerable is IERC721 {
1266 
1267     /**
1268      * @dev Returns the total amount of tokens stored by the contract.
1269      */
1270     function totalSupply() external view returns (uint256);
1271 
1272     /**
1273      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1274      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1275      */
1276     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1277 
1278     /**
1279      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1280      * Use along with {totalSupply} to enumerate all tokens.
1281      */
1282     function tokenByIndex(uint256 index) external view returns (uint256);
1283 }
1284 
1285 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721Metadata.sol
1286 
1287 
1288 
1289 pragma solidity >=0.6.2 <0.8.0;
1290 
1291 
1292 /**
1293  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1294  * @dev See https://eips.ethereum.org/EIPS/eip-721
1295  */
1296 interface IERC721Metadata is IERC721 {
1297 
1298     /**
1299      * @dev Returns the token collection name.
1300      */
1301     function name() external view returns (string memory);
1302 
1303     /**
1304      * @dev Returns the token collection symbol.
1305      */
1306     function symbol() external view returns (string memory);
1307 
1308     /**
1309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1310      */
1311     function tokenURI(uint256 tokenId) external view returns (string memory);
1312 }
1313 
1314 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Context.sol
1315 
1316 
1317 
1318 pragma solidity >=0.6.0 <0.8.0;
1319 
1320 /*
1321  * @dev Provides information about the current execution context, including the
1322  * sender of the transaction and its data. While these are generally available
1323  * via msg.sender and msg.data, they should not be accessed in such a direct
1324  * manner, since when dealing with GSN meta-transactions the account sending and
1325  * paying for execution may not be the actual sender (as far as an application
1326  * is concerned).
1327  *
1328  * This contract is only required for intermediate, library-like contracts.
1329  */
1330 abstract contract Context {
1331     function _msgSender() internal view virtual returns (address payable) {
1332         return msg.sender;
1333     }
1334 
1335     function _msgData() internal view virtual returns (bytes memory) {
1336         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1337         return msg.data;
1338     }
1339 }
1340 
1341 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/access/Ownable.sol
1342 
1343 
1344 
1345 pragma solidity >=0.6.0 <0.8.0;
1346 
1347 /**
1348  * @dev Contract module which provides a basic access control mechanism, where
1349  * there is an account (an owner) that can be granted exclusive access to
1350  * specific functions.
1351  *
1352  * By default, the owner account will be the one that deploys the contract. This
1353  * can later be changed with {transferOwnership}.
1354  *
1355  * This module is used through inheritance. It will make available the modifier
1356  * `onlyOwner`, which can be applied to your functions to restrict their use to
1357  * the owner.
1358  */
1359 abstract contract Ownable is Context {
1360     address private _owner;
1361 
1362     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1363 
1364     /**
1365      * @dev Initializes the contract setting the deployer as the initial owner.
1366      */
1367     constructor () internal {
1368         address msgSender = _msgSender();
1369         _owner = msgSender;
1370         emit OwnershipTransferred(address(0), msgSender);
1371     }
1372 
1373     /**
1374      * @dev Returns the address of the current owner.
1375      */
1376     function owner() public view virtual returns (address) {
1377         return _owner;
1378     }
1379 
1380     /**
1381      * @dev Throws if called by any account other than the owner.
1382      */
1383     modifier onlyOwner() {
1384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1385         _;
1386     }
1387 
1388     /**
1389      * @dev Leaves the contract without owner. It will not be possible to call
1390      * `onlyOwner` functions anymore. Can only be called by the current owner.
1391      *
1392      * NOTE: Renouncing ownership will leave the contract without an owner,
1393      * thereby removing any functionality that is only available to the owner.
1394      */
1395     function renounceOwnership() public virtual onlyOwner {
1396         emit OwnershipTransferred(_owner, address(0));
1397         _owner = address(0);
1398     }
1399 
1400     /**
1401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1402      * Can only be called by the current owner.
1403      */
1404     function transferOwnership(address newOwner) public virtual onlyOwner {
1405         require(newOwner != address(0), "Ownable: new owner is the zero address");
1406         emit OwnershipTransferred(_owner, newOwner);
1407         _owner = newOwner;
1408     }
1409 }
1410 
1411 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/ERC721.sol
1412 
1413 
1414 
1415 pragma solidity >=0.6.0 <0.8.0;
1416 
1417 
1418 
1419 
1420 
1421 
1422 
1423 
1424 
1425 
1426 
1427 
1428 /**
1429  * @title ERC721 Non-Fungible Token Standard basic implementation
1430  * @dev see https://eips.ethereum.org/EIPS/eip-721
1431  */
1432 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1433     using SafeMath for uint256;
1434     using Address for address;
1435     using EnumerableSet for EnumerableSet.UintSet;
1436     using EnumerableMap for EnumerableMap.UintToAddressMap;
1437     using Strings for uint256;
1438 
1439     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1440     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1441     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1442 
1443     // Mapping from holder address to their (enumerable) set of owned tokens
1444     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1445 
1446     // Enumerable mapping from token ids to their owners
1447     EnumerableMap.UintToAddressMap private _tokenOwners;
1448 
1449     // Mapping from token ID to approved address
1450     mapping (uint256 => address) private _tokenApprovals;
1451 
1452     // Mapping from owner to operator approvals
1453     mapping (address => mapping (address => bool)) private _operatorApprovals;
1454 
1455     // Token name
1456     string private _name;
1457 
1458     // Token symbol
1459     string private _symbol;
1460 
1461     // Optional mapping for token URIs
1462     mapping (uint256 => string) private _tokenURIs;
1463 
1464     // Base URI
1465     string private _baseURI;
1466 
1467     /*
1468      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1469      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1470      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1471      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1472      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1473      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1474      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1475      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1476      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1477      *
1478      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1479      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1480      */
1481     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1482 
1483     /*
1484      *     bytes4(keccak256('name()')) == 0x06fdde03
1485      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1486      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1487      *
1488      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1489      */
1490     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1491 
1492     /*
1493      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1494      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1495      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1496      *
1497      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1498      */
1499     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1500 
1501     /**
1502      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1503      */
1504     constructor (string memory name_, string memory symbol_) public {
1505         _name = name_;
1506         _symbol = symbol_;
1507 
1508         // register the supported interfaces to conform to ERC721 via ERC165
1509         _registerInterface(_INTERFACE_ID_ERC721);
1510         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1511         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-balanceOf}.
1516      */
1517     function balanceOf(address owner) public view virtual override returns (uint256) {
1518         require(owner != address(0), "ERC721: balance query for the zero address");
1519         return _holderTokens[owner].length();
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-ownerOf}.
1524      */
1525     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1526         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1527     }
1528 
1529     /**
1530      * @dev See {IERC721Metadata-name}.
1531      */
1532     function name() public view virtual override returns (string memory) {
1533         return _name;
1534     }
1535 
1536     /**
1537      * @dev See {IERC721Metadata-symbol}.
1538      */
1539     function symbol() public view virtual override returns (string memory) {
1540         return _symbol;
1541     }
1542 
1543     /**
1544      * @dev See {IERC721Metadata-tokenURI}.
1545      */
1546     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1547         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1548 
1549         string memory _tokenURI = _tokenURIs[tokenId];
1550         string memory base = baseURI();
1551 
1552         // If there is no base URI, return the token URI.
1553         if (bytes(base).length == 0) {
1554             return _tokenURI;
1555         }
1556         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1557         if (bytes(_tokenURI).length > 0) {
1558             return string(abi.encodePacked(base, _tokenURI));
1559         }
1560         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1561         return string(abi.encodePacked(base, tokenId.toString()));
1562     }
1563 
1564     /**
1565     * @dev Returns the base URI set via {_setBaseURI}. This will be
1566     * automatically added as a prefix in {tokenURI} to each token's URI, or
1567     * to the token ID if no specific URI is set for that token ID.
1568     */
1569     function baseURI() public view virtual returns (string memory) {
1570         return _baseURI;
1571     }
1572 
1573     /**
1574      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1575      */
1576     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1577         return _holderTokens[owner].at(index);
1578     }
1579 
1580     /**
1581      * @dev See {IERC721Enumerable-totalSupply}.
1582      */
1583     function totalSupply() public view virtual override returns (uint256) {
1584         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1585         return _tokenOwners.length();
1586     }
1587 
1588     /**
1589      * @dev See {IERC721Enumerable-tokenByIndex}.
1590      */
1591     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1592         (uint256 tokenId, ) = _tokenOwners.at(index);
1593         return tokenId;
1594     }
1595 
1596     /**
1597      * @dev See {IERC721-approve}.
1598      */
1599     function approve(address to, uint256 tokenId) public virtual override {
1600         address owner = ERC721.ownerOf(tokenId);
1601         require(to != owner, "ERC721: approval to current owner");
1602 
1603         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1604             "ERC721: approve caller is not owner nor approved for all"
1605         );
1606 
1607         _approve(to, tokenId);
1608     }
1609 
1610     /**
1611      * @dev See {IERC721-getApproved}.
1612      */
1613     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1614         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1615 
1616         return _tokenApprovals[tokenId];
1617     }
1618 
1619     /**
1620      * @dev See {IERC721-setApprovalForAll}.
1621      */
1622     function setApprovalForAll(address operator, bool approved) public virtual override {
1623         require(operator != _msgSender(), "ERC721: approve to caller");
1624 
1625         _operatorApprovals[_msgSender()][operator] = approved;
1626         emit ApprovalForAll(_msgSender(), operator, approved);
1627     }
1628 
1629     /**
1630      * @dev See {IERC721-isApprovedForAll}.
1631      */
1632     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1633         return _operatorApprovals[owner][operator];
1634     }
1635 
1636     /**
1637      * @dev See {IERC721-transferFrom}.
1638      */
1639     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1640         //solhint-disable-next-line max-line-length
1641         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1642 
1643         _transfer(from, to, tokenId);
1644     }
1645 
1646     /**
1647      * @dev See {IERC721-safeTransferFrom}.
1648      */
1649     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1650         safeTransferFrom(from, to, tokenId, "");
1651     }
1652 
1653     /**
1654      * @dev See {IERC721-safeTransferFrom}.
1655      */
1656     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1657         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1658         _safeTransfer(from, to, tokenId, _data);
1659     }
1660 
1661     /**
1662      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1663      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1664      *
1665      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1666      *
1667      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1668      * implement alternative mechanisms to perform token transfer, such as signature-based.
1669      *
1670      * Requirements:
1671      *
1672      * - `from` cannot be the zero address.
1673      * - `to` cannot be the zero address.
1674      * - `tokenId` token must exist and be owned by `from`.
1675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1680         _transfer(from, to, tokenId);
1681         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1682     }
1683 
1684     /**
1685      * @dev Returns whether `tokenId` exists.
1686      *
1687      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1688      *
1689      * Tokens start existing when they are minted (`_mint`),
1690      * and stop existing when they are burned (`_burn`).
1691      */
1692     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1693         return _tokenOwners.contains(tokenId);
1694     }
1695 
1696     /**
1697      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1698      *
1699      * Requirements:
1700      *
1701      * - `tokenId` must exist.
1702      */
1703     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1704         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1705         address owner = ERC721.ownerOf(tokenId);
1706         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1707     }
1708 
1709     /**
1710      * @dev Safely mints `tokenId` and transfers it to `to`.
1711      *
1712      * Requirements:
1713      d*
1714      * - `tokenId` must not exist.
1715      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1716      *
1717      * Emits a {Transfer} event.
1718      */
1719     function _safeMint(address to, uint256 tokenId) internal virtual {
1720         _safeMint(to, tokenId, "");
1721     }
1722 
1723     /**
1724      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1725      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1726      */
1727     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1728         _mint(to, tokenId);
1729         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1730     }
1731 
1732     /**
1733      * @dev Mints `tokenId` and transfers it to `to`.
1734      *
1735      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1736      *
1737      * Requirements:
1738      *
1739      * - `tokenId` must not exist.
1740      * - `to` cannot be the zero address.
1741      *
1742      * Emits a {Transfer} event.
1743      */
1744     function _mint(address to, uint256 tokenId) internal virtual {
1745         require(to != address(0), "ERC721: mint to the zero address");
1746         require(!_exists(tokenId), "ERC721: token already minted");
1747 
1748         _beforeTokenTransfer(address(0), to, tokenId);
1749 
1750         _holderTokens[to].add(tokenId);
1751 
1752         _tokenOwners.set(tokenId, to);
1753 
1754         emit Transfer(address(0), to, tokenId);
1755     }
1756 
1757     /**
1758      * @dev Destroys `tokenId`.
1759      * The approval is cleared when the token is burned.
1760      *
1761      * Requirements:
1762      *
1763      * - `tokenId` must exist.
1764      *
1765      * Emits a {Transfer} event.
1766      */
1767     function _burn(uint256 tokenId) internal virtual {
1768         address owner = ERC721.ownerOf(tokenId); // internal owner
1769 
1770         _beforeTokenTransfer(owner, address(0), tokenId);
1771 
1772         // Clear approvals
1773         _approve(address(0), tokenId);
1774 
1775         // Clear metadata (if any)
1776         if (bytes(_tokenURIs[tokenId]).length != 0) {
1777             delete _tokenURIs[tokenId];
1778         }
1779 
1780         _holderTokens[owner].remove(tokenId);
1781 
1782         _tokenOwners.remove(tokenId);
1783 
1784         emit Transfer(owner, address(0), tokenId);
1785     }
1786 
1787     /**
1788      * @dev Transfers `tokenId` from `from` to `to`.
1789      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1790      *
1791      * Requirements:
1792      *
1793      * - `to` cannot be the zero address.
1794      * - `tokenId` token must be owned by `from`.
1795      *
1796      * Emits a {Transfer} event.
1797      */
1798     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1799         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1800         require(to != address(0), "ERC721: transfer to the zero address");
1801 
1802         _beforeTokenTransfer(from, to, tokenId);
1803 
1804         // Clear approvals from the previous owner
1805         _approve(address(0), tokenId);
1806 
1807         _holderTokens[from].remove(tokenId);
1808         _holderTokens[to].add(tokenId);
1809 
1810         _tokenOwners.set(tokenId, to);
1811 
1812         emit Transfer(from, to, tokenId);
1813     }
1814 
1815     /**
1816      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1817      *
1818      * Requirements:
1819      *
1820      * - `tokenId` must exist.
1821      */
1822     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1823         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1824         _tokenURIs[tokenId] = _tokenURI;
1825     }
1826 
1827     /**
1828      * @dev Internal function to set the base URI for all token IDs. It is
1829      * automatically added as a prefix to the value returned in {tokenURI},
1830      * or to the token ID if {tokenURI} is empty.
1831      */
1832     function _setBaseURI(string memory baseURI_) internal virtual {
1833         _baseURI = baseURI_;
1834     }
1835 
1836     /**
1837      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1838      * The call is not executed if the target address is not a contract.
1839      *
1840      * @param from address representing the previous owner of the given token ID
1841      * @param to target address that will receive the tokens
1842      * @param tokenId uint256 ID of the token to be transferred
1843      * @param _data bytes optional data to send along with the call
1844      * @return bool whether the call correctly returned the expected magic value
1845      */
1846     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1847         private returns (bool)
1848     {
1849         if (!to.isContract()) {
1850             return true;
1851         }
1852         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1853             IERC721Receiver(to).onERC721Received.selector,
1854             _msgSender(),
1855             from,
1856             tokenId,
1857             _data
1858         ), "ERC721: transfer to non ERC721Receiver implementer");
1859         bytes4 retval = abi.decode(returndata, (bytes4));
1860         return (retval == _ERC721_RECEIVED);
1861     }
1862 
1863     function _approve(address to, uint256 tokenId) private {
1864         _tokenApprovals[tokenId] = to;
1865         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1866     }
1867 
1868     /**
1869      * @dev Hook that is called before any token transfer. This includes minting
1870      * and burning.
1871      *
1872      * Calling conditions:
1873      *
1874      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1875      * transferred to `to`.
1876      * - When `from` is zero, `tokenId` will be minted for `to`.
1877      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1878      * - `from` cannot be the zero address.
1879      * - `to` cannot be the zero address.
1880      *
1881      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1882      */
1883     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1884 }
1885 
1886 // File: contracts/DissectedToadz.sol
1887 
1888 pragma solidity >=0.6.0 <0.8.0;
1889 
1890 /**
1891  * @title House of Horrors contract
1892  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1893  */
1894 contract DissectedToadz is ERC721, Ownable {
1895     
1896     address public withdrawAddress;
1897     bool public openMint = false;
1898     bool public onlyWhitelisted = true;
1899     address[] public whitelistedAddresses;
1900     
1901     uint256 public tokenPriceAcidWash = 100000000000000000;
1902     uint256 public tokenPriceCorrosive = 200000000000000000;
1903     uint256 public tokenPriceCenterCut = 300000000000000000;
1904     uint256 public tokenPriceTriCut = 500000000000000000;
1905     uint256 public tokenPricePassthrough = 700000000000000000;
1906     uint256 public tokenPriceAnimated = 1000000000000000000;
1907     uint256 public tokenPriceSpecial = 0;
1908     
1909     uint256 public constant maxTokensAcidWash = 40;
1910     uint256 public constant maxTokensCorrosive = 80;
1911     uint256 public constant maxTokensCenterCut = 120;
1912     uint256 public constant maxTokensTriCut = 160;
1913     uint256 public constant maxTokensPassthrough = 190;
1914     uint256 public constant maxTokensAnimated = 200;
1915     uint256 public constant maxTokensSpecial = 215;
1916 
1917     string private _contractURI;
1918     
1919     uint256 public tokenCountAcidWash=1;
1920     uint256 public tokenCountCorrosive=41;
1921     uint256 public tokenCountCenterCut=81;
1922     uint256 public tokenCountTriCut=121;
1923     uint256 public tokenCountPassthrough=161;
1924     uint256 public tokenCountAnimated=191;
1925     uint256 public tokenCountSpecial=201;
1926     
1927     constructor() public ERC721("Mint Passes: Dissected Toadz -- Commission Passes", "DTOADZ") {}
1928 
1929     //Set Base URI
1930     function setBaseURI(string memory _baseURI) external onlyOwner {
1931         _setBaseURI(_baseURI);
1932     }
1933 
1934     function flipWhitelistedState() public onlyOwner {
1935         onlyWhitelisted = !onlyWhitelisted;
1936     }
1937     
1938     function flipMintState() public onlyOwner {
1939         openMint = !openMint;
1940     }
1941 
1942     function setContractURI(string memory contractURI_) external onlyOwner {
1943         _contractURI = contractURI_;
1944     }
1945 
1946     function contractURI() public view returns (string memory) {
1947         return _contractURI;
1948     }
1949     
1950     function setWithdrawAddress(address _address) external onlyOwner {
1951         withdrawAddress = _address;
1952     }
1953 
1954     //Dev mint special tokens
1955     function mintSpecial() external onlyOwner {        
1956         for (uint256 i = 201; i < 216; i++) {
1957             _mint(msg.sender, i);
1958         }
1959     }
1960 
1961     function mintPublicAcidWash() external payable {
1962         require(tokenCountAcidWash <= maxTokensAcidWash, "minting this would exceed supply");
1963         require(msg.value >= tokenPriceAcidWash, "not enough ether sent!");
1964         require(msg.sender == tx.origin, "no contracts please!");
1965         require(openMint, "mint not open");
1966 
1967         if(onlyWhitelisted) {
1968             require(isWhitelisted(msg.sender), "you're not on the whitelist");
1969         }
1970         
1971         _safeMint(msg.sender, tokenCountAcidWash);
1972         tokenCountAcidWash++;
1973     }
1974     function mintPublicCorrosive() external payable {
1975         require(tokenCountCorrosive <= maxTokensCorrosive, "minting this would exceed supply");
1976         require(msg.value >= tokenPriceCorrosive, "not enough ether sent!");
1977         require(msg.sender == tx.origin, "no contracts please!");
1978         require(openMint, "mint not open");
1979 
1980 
1981         if(onlyWhitelisted) {
1982             require(isWhitelisted(msg.sender), "you're not on the whitelist");
1983         }
1984         
1985         _safeMint(msg.sender, tokenCountCorrosive);
1986         tokenCountCorrosive++;
1987     }
1988     function mintPublicCenterCut() external payable {
1989         require(tokenCountCenterCut <= maxTokensCenterCut, "minting this would exceed supply");
1990         require(msg.value >= tokenPriceCenterCut, "not enough ether sent!");
1991         require(msg.sender == tx.origin, "no contracts please!");
1992         require(openMint, "mint not open");
1993 
1994         if(onlyWhitelisted) {
1995             require(isWhitelisted(msg.sender), "you're not on the whitelist");
1996         }
1997         
1998         _safeMint(msg.sender, tokenCountCenterCut);
1999         tokenCountCenterCut++;
2000     }
2001     function mintPublicTriCut() external payable {
2002         require(tokenCountTriCut <= maxTokensTriCut, "minting this would exceed supply");
2003         require(msg.value >= tokenPriceTriCut, "not enough ether sent!");
2004         require(msg.sender == tx.origin, "no contracts please!");
2005         require(openMint, "mint not open");
2006 
2007         if(onlyWhitelisted) {
2008             require(isWhitelisted(msg.sender), "you're not on the whitelist");
2009         }
2010         
2011         _safeMint(msg.sender, tokenCountTriCut);
2012         tokenCountTriCut++;
2013     }
2014     function mintPublicPassthrough() external payable {
2015         require(tokenCountPassthrough <= maxTokensPassthrough, "minting this would exceed supply");
2016         require(msg.value >= tokenPricePassthrough, "not enough ether sent!");
2017         require(msg.sender == tx.origin, "no contracts please!");
2018         require(openMint, "mint not open");
2019 
2020         if(onlyWhitelisted) {
2021             require(isWhitelisted(msg.sender), "you're not on the whitelist");
2022         }
2023         
2024         _safeMint(msg.sender, tokenCountPassthrough);
2025         tokenCountPassthrough++;
2026     }
2027     function mintPublicAnimated() external payable {
2028         require(tokenCountAnimated <= maxTokensAnimated, "minting this would exceed supply");
2029         require(msg.value >= tokenPriceAnimated, "not enough ether sent!");
2030         require(msg.sender == tx.origin, "no contracts please!");
2031         require(openMint, "mint not open");
2032         
2033         if(onlyWhitelisted) {
2034             require(isWhitelisted(msg.sender), "you're not on the whitelist");
2035         }
2036         
2037         _safeMint(msg.sender, tokenCountAnimated);
2038         tokenCountAnimated++;
2039     }
2040     
2041     function isWhitelisted(address _user) public view returns (bool) {
2042         for (uint i = 0; i < whitelistedAddresses.length; i++) {
2043             if (whitelistedAddresses[i] == _user) {
2044                 return true;
2045             }
2046         }
2047         return false;
2048     }
2049     
2050     function whitelistUsers(address[] calldata _users) public onlyOwner {
2051         delete whitelistedAddresses;
2052         whitelistedAddresses = _users;
2053     }
2054     
2055     // Withdraws the balance of the contract to the team's wallet
2056     function withdraw() external onlyOwner {
2057         uint256 balance = address(this).balance;
2058         require(payable(withdrawAddress).send(balance));
2059     }
2060 
2061 }