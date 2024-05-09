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
1417 /**
1418  * @title ERC721 Non-Fungible Token Standard basic implementation
1419  * @dev see https://eips.ethereum.org/EIPS/eip-721
1420  */
1421 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1422     using SafeMath for uint256;
1423     using Address for address;
1424     using EnumerableSet for EnumerableSet.UintSet;
1425     using EnumerableMap for EnumerableMap.UintToAddressMap;
1426     using Strings for uint256;
1427 
1428     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1429     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1430     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1431 
1432     // Mapping from holder address to their (enumerable) set of owned tokens
1433     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1434 
1435     // Enumerable mapping from token ids to their owners
1436     EnumerableMap.UintToAddressMap private _tokenOwners;
1437 
1438     // Mapping from token ID to approved address
1439     mapping (uint256 => address) private _tokenApprovals;
1440 
1441     // Mapping from owner to operator approvals
1442     mapping (address => mapping (address => bool)) private _operatorApprovals;
1443 
1444     // Token name
1445     string private _name;
1446 
1447     // Token symbol
1448     string private _symbol;
1449 
1450     // Optional mapping for token URIs
1451     mapping (uint256 => string) private _tokenURIs;
1452 
1453     // Base URI
1454     string private _baseURI;
1455 
1456     /*
1457      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1458      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1459      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1460      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1461      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1462      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1463      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1464      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1465      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1466      *
1467      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1468      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1469      */
1470     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1471 
1472     /*
1473      *     bytes4(keccak256('name()')) == 0x06fdde03
1474      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1475      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1476      *
1477      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1478      */
1479     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1480 
1481     /*
1482      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1483      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1484      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1485      *
1486      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1487      */
1488     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1489 
1490     /**
1491      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1492      */
1493     constructor (string memory name_, string memory symbol_) public {
1494         _name = name_;
1495         _symbol = symbol_;
1496 
1497         // register the supported interfaces to conform to ERC721 via ERC165
1498         _registerInterface(_INTERFACE_ID_ERC721);
1499         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1500         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-balanceOf}.
1505      */
1506     function balanceOf(address owner) public view virtual override returns (uint256) {
1507         require(owner != address(0), "ERC721: balance query for the zero address");
1508         return _holderTokens[owner].length();
1509     }
1510 
1511     /**
1512      * @dev See {IERC721-ownerOf}.
1513      */
1514     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1515         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1516     }
1517 
1518     /**
1519      * @dev See {IERC721Metadata-name}.
1520      */
1521     function name() public view virtual override returns (string memory) {
1522         return _name;
1523     }
1524 
1525     /**
1526      * @dev See {IERC721Metadata-symbol}.
1527      */
1528     function symbol() public view virtual override returns (string memory) {
1529         return _symbol;
1530     }
1531 
1532     /**
1533      * @dev See {IERC721Metadata-tokenURI}.
1534      */
1535     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1536         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1537 
1538         string memory _tokenURI = _tokenURIs[tokenId];
1539         string memory base = baseURI();
1540 
1541         // If there is no base URI, return the token URI.
1542         if (bytes(base).length == 0) {
1543             return _tokenURI;
1544         }
1545         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1546         if (bytes(_tokenURI).length > 0) {
1547             return string(abi.encodePacked(base, _tokenURI));
1548         }
1549         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1550         return string(abi.encodePacked(base, tokenId.toString()));
1551     }
1552 
1553     /**
1554     * @dev Returns the base URI set via {_setBaseURI}. This will be
1555     * automatically added as a prefix in {tokenURI} to each token's URI, or
1556     * to the token ID if no specific URI is set for that token ID.
1557     */
1558     function baseURI() public view virtual returns (string memory) {
1559         return _baseURI;
1560     }
1561 
1562     /**
1563      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1564      */
1565     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1566         return _holderTokens[owner].at(index);
1567     }
1568 
1569     /**
1570      * @dev See {IERC721Enumerable-totalSupply}.
1571      */
1572     function totalSupply() public view virtual override returns (uint256) {
1573         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1574         return _tokenOwners.length();
1575     }
1576 
1577     /**
1578      * @dev See {IERC721Enumerable-tokenByIndex}.
1579      */
1580     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1581         (uint256 tokenId, ) = _tokenOwners.at(index);
1582         return tokenId;
1583     }
1584 
1585     /**
1586      * @dev See {IERC721-approve}.
1587      */
1588     function approve(address to, uint256 tokenId) public virtual override {
1589         address owner = ERC721.ownerOf(tokenId);
1590         require(to != owner, "ERC721: approval to current owner");
1591 
1592         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1593             "ERC721: approve caller is not owner nor approved for all"
1594         );
1595 
1596         _approve(to, tokenId);
1597     }
1598 
1599     /**
1600      * @dev See {IERC721-getApproved}.
1601      */
1602     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1603         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1604 
1605         return _tokenApprovals[tokenId];
1606     }
1607 
1608     /**
1609      * @dev See {IERC721-setApprovalForAll}.
1610      */
1611     function setApprovalForAll(address operator, bool approved) public virtual override {
1612         require(operator != _msgSender(), "ERC721: approve to caller");
1613 
1614         _operatorApprovals[_msgSender()][operator] = approved;
1615         emit ApprovalForAll(_msgSender(), operator, approved);
1616     }
1617 
1618     /**
1619      * @dev See {IERC721-isApprovedForAll}.
1620      */
1621     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1622         return _operatorApprovals[owner][operator];
1623     }
1624 
1625     /**
1626      * @dev See {IERC721-transferFrom}.
1627      */
1628     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1629         //solhint-disable-next-line max-line-length
1630         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1631 
1632         _transfer(from, to, tokenId);
1633     }
1634 
1635     /**
1636      * @dev See {IERC721-safeTransferFrom}.
1637      */
1638     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1639         safeTransferFrom(from, to, tokenId, "");
1640     }
1641 
1642     /**
1643      * @dev See {IERC721-safeTransferFrom}.
1644      */
1645     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1646         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1647         _safeTransfer(from, to, tokenId, _data);
1648     }
1649 
1650     /**
1651      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1652      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1653      *
1654      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1655      *
1656      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1657      * implement alternative mechanisms to perform token transfer, such as signature-based.
1658      *
1659      * Requirements:
1660      *
1661      * - `from` cannot be the zero address.
1662      * - `to` cannot be the zero address.
1663      * - `tokenId` token must exist and be owned by `from`.
1664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1665      *
1666      * Emits a {Transfer} event.
1667      */
1668     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1669         _transfer(from, to, tokenId);
1670         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1671     }
1672 
1673     /**
1674      * @dev Returns whether `tokenId` exists.
1675      *
1676      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1677      *
1678      * Tokens start existing when they are minted (`_mint`),
1679      * and stop existing when they are burned (`_burn`).
1680      */
1681     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1682         return _tokenOwners.contains(tokenId);
1683     }
1684 
1685     /**
1686      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      */
1692     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1693         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1694         address owner = ERC721.ownerOf(tokenId);
1695         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1696     }
1697 
1698     /**
1699      * @dev Safely mints `tokenId` and transfers it to `to`.
1700      *
1701      * Requirements:
1702      d*
1703      * - `tokenId` must not exist.
1704      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1705      *
1706      * Emits a {Transfer} event.
1707      */
1708     function _safeMint(address to, uint256 tokenId) internal virtual {
1709         _safeMint(to, tokenId, "");
1710     }
1711 
1712     /**
1713      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1714      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1715      */
1716     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1717         _mint(to, tokenId);
1718         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1719     }
1720 
1721     /**
1722      * @dev Mints `tokenId` and transfers it to `to`.
1723      *
1724      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1725      *
1726      * Requirements:
1727      *
1728      * - `tokenId` must not exist.
1729      * - `to` cannot be the zero address.
1730      *
1731      * Emits a {Transfer} event.
1732      */
1733     function _mint(address to, uint256 tokenId) internal virtual {
1734         require(to != address(0), "ERC721: mint to the zero address");
1735         require(!_exists(tokenId), "ERC721: token already minted");
1736 
1737         _beforeTokenTransfer(address(0), to, tokenId);
1738 
1739         _holderTokens[to].add(tokenId);
1740 
1741         _tokenOwners.set(tokenId, to);
1742 
1743         emit Transfer(address(0), to, tokenId);
1744     }
1745 
1746     /**
1747      * @dev Destroys `tokenId`.
1748      * The approval is cleared when the token is burned.
1749      *
1750      * Requirements:
1751      *
1752      * - `tokenId` must exist.
1753      *
1754      * Emits a {Transfer} event.
1755      */
1756     function _burn(uint256 tokenId) internal virtual {
1757         address owner = ERC721.ownerOf(tokenId); // internal owner
1758 
1759         _beforeTokenTransfer(owner, address(0), tokenId);
1760 
1761         // Clear approvals
1762         _approve(address(0), tokenId);
1763 
1764         // Clear metadata (if any)
1765         if (bytes(_tokenURIs[tokenId]).length != 0) {
1766             delete _tokenURIs[tokenId];
1767         }
1768 
1769         _holderTokens[owner].remove(tokenId);
1770 
1771         _tokenOwners.remove(tokenId);
1772 
1773         emit Transfer(owner, address(0), tokenId);
1774     }
1775 
1776     /**
1777      * @dev Transfers `tokenId` from `from` to `to`.
1778      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1779      *
1780      * Requirements:
1781      *
1782      * - `to` cannot be the zero address.
1783      * - `tokenId` token must be owned by `from`.
1784      *
1785      * Emits a {Transfer} event.
1786      */
1787     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1788         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1789         require(to != address(0), "ERC721: transfer to the zero address");
1790 
1791         _beforeTokenTransfer(from, to, tokenId);
1792 
1793         // Clear approvals from the previous owner
1794         _approve(address(0), tokenId);
1795 
1796         _holderTokens[from].remove(tokenId);
1797         _holderTokens[to].add(tokenId);
1798 
1799         _tokenOwners.set(tokenId, to);
1800 
1801         emit Transfer(from, to, tokenId);
1802     }
1803 
1804     /**
1805      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1806      *
1807      * Requirements:
1808      *
1809      * - `tokenId` must exist.
1810      */
1811     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1812         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1813         _tokenURIs[tokenId] = _tokenURI;
1814     }
1815 
1816     /**
1817      * @dev Internal function to set the base URI for all token IDs. It is
1818      * automatically added as a prefix to the value returned in {tokenURI},
1819      * or to the token ID if {tokenURI} is empty.
1820      */
1821     function _setBaseURI(string memory baseURI_) internal virtual {
1822         _baseURI = baseURI_;
1823     }
1824 
1825     /**
1826      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1827      * The call is not executed if the target address is not a contract.
1828      *
1829      * @param from address representing the previous owner of the given token ID
1830      * @param to target address that will receive the tokens
1831      * @param tokenId uint256 ID of the token to be transferred
1832      * @param _data bytes optional data to send along with the call
1833      * @return bool whether the call correctly returned the expected magic value
1834      */
1835     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1836         private returns (bool)
1837     {
1838         if (!to.isContract()) {
1839             return true;
1840         }
1841         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1842             IERC721Receiver(to).onERC721Received.selector,
1843             _msgSender(),
1844             from,
1845             tokenId,
1846             _data
1847         ), "ERC721: transfer to non ERC721Receiver implementer");
1848         bytes4 retval = abi.decode(returndata, (bytes4));
1849         return (retval == _ERC721_RECEIVED);
1850     }
1851 
1852     function _approve(address to, uint256 tokenId) private {
1853         _tokenApprovals[tokenId] = to;
1854         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1855     }
1856 
1857     /**
1858      * @dev Hook that is called before any token transfer. This includes minting
1859      * and burning.
1860      *
1861      * Calling conditions:
1862      *
1863      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1864      * transferred to `to`.
1865      * - When `from` is zero, `tokenId` will be minted for `to`.
1866      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1867      * - `from` cannot be the zero address.
1868      * - `to` cannot be the zero address.
1869      *
1870      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1871      */
1872     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1873 }
1874 
1875 pragma solidity ^0.7.0;
1876 
1877 /**
1878  * @title Counters
1879  * @author Matt Condon (@shrugs)
1880  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1881  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1882  *
1883  * Include with `using Counters for Counters.Counter;`
1884  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1885  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1886  * directly accessed.
1887  */
1888 library Counters {
1889     using SafeMath for uint256;
1890 
1891     struct Counter {
1892         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1893         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1894         // this feature: see https://github.com/ethereum/solidity/issues/4637
1895         uint256 _value; // default: 0
1896     }
1897 
1898     function current(Counter storage counter) internal view returns (uint256) {
1899         return counter._value;
1900     }
1901 
1902     function increment(Counter storage counter) internal {
1903         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1904         counter._value += 1;
1905     }
1906 
1907     function decrement(Counter storage counter) internal {
1908         counter._value = counter._value.sub(1);
1909     }
1910 }
1911 
1912 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/payment/PaymentSplitter.sol
1913 
1914 
1915 
1916 pragma solidity >=0.6.0 <0.8.0;
1917 
1918 
1919 
1920 
1921 /**
1922  * @title PaymentSplitter
1923  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1924  * that the Ether will be split in this way, since it is handled transparently by the contract.
1925  *
1926  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1927  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1928  * an amount proportional to the percentage of total shares they were assigned.
1929  *
1930  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1931  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1932  * function.
1933  */
1934 contract PaymentSplitter is Context {
1935     using SafeMath for uint256;
1936 
1937     event PayeeAdded(address account, uint256 shares);
1938     event PaymentReleased(address to, uint256 amount);
1939     event PaymentReceived(address from, uint256 amount);
1940 
1941     uint256 private _totalShares;
1942     uint256 private _totalReleased;
1943 
1944     mapping(address => uint256) private _shares;
1945     mapping(address => uint256) private _released;
1946     address[] private _payees;
1947 
1948     /**
1949      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1950      * the matching position in the `shares` array.
1951      *
1952      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1953      * duplicates in `payees`.
1954      */
1955     constructor () public payable {}
1956 
1957     /**
1958      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1959      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1960      * reliability of the events, and not the actual splitting of Ether.
1961      *
1962      * To learn more about this see the Solidity documentation for
1963      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1964      * functions].
1965      */
1966     receive () external payable virtual {
1967         emit PaymentReceived(_msgSender(), msg.value);
1968     }
1969 
1970     /**
1971      * @dev Getter for the total shares held by payees.
1972      */
1973     function totalShares() public view returns (uint256) {
1974         return _totalShares;
1975     }
1976 
1977     /**
1978      * @dev Getter for the total amount of Ether already released.
1979      */
1980     function totalReleased() public view returns (uint256) {
1981         return _totalReleased;
1982     }
1983 
1984     /**
1985      * @dev Getter for the amount of shares held by an account.
1986      */
1987     function shares(address account) public view returns (uint256) {
1988         return _shares[account];
1989     }
1990 
1991     /**
1992      * @dev Getter for the amount of Ether already released to a payee.
1993      */
1994     function released(address account) public view returns (uint256) {
1995         return _released[account];
1996     }
1997 
1998     /**
1999      * @dev Getter for the address of the payee number `index`.
2000      */
2001     function payee(uint256 index) public view returns (address) {
2002         return _payees[index];
2003     }
2004 
2005     /**
2006      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2007      * total shares and their previous withdrawals.
2008      */
2009     function release(address payable account) public virtual {
2010         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2011 
2012         uint256 totalReceived = address(this).balance.add(_totalReleased);
2013         uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(_released[account]);
2014 
2015         require(payment != 0, "PaymentSplitter: account is not due payment");
2016 
2017         _released[account] = _released[account].add(payment);
2018         _totalReleased = _totalReleased.add(payment);
2019 
2020         Address.sendValue(account, payment);
2021         emit PaymentReleased(account, payment);
2022     }
2023 
2024     /**
2025      * @dev Add a new payee to the contract.
2026      * @param account The address of the payee to add.
2027      * @param shares_ The number of shares owned by the payee.
2028      */
2029     function _addPayee(address account, uint256 shares_) internal {
2030         require(account != address(0), "PaymentSplitter: account is the zero address");
2031         require(shares_ > 0, "PaymentSplitter: shares are 0");
2032         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2033 
2034         _payees.push(account);
2035         _shares[account] = shares_;
2036         _totalShares = _totalShares.add(shares_);
2037         emit PayeeAdded(account, shares_);
2038     }
2039 }
2040 
2041 // File: contracts/NobiToadz
2042 
2043 pragma solidity >=0.6.0 <0.8.0;
2044 
2045 /**
2046  * @title NobiToadz contract
2047  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2048  */
2049 contract NobiToadz is ERC721, Ownable, PaymentSplitter {
2050     using Counters for Counters.Counter;
2051     
2052     Counters.Counter private _tokenIdCounter;
2053     bool public openMint = false;
2054     
2055     bool private initialized = false;
2056     
2057     uint256 public tokenPrice = .042 ether;
2058     
2059     uint256 public constant maxTokens = 3957;
2060 
2061     uint256 public devTokenCount = 3957;
2062 
2063     string private _contractURI;
2064     
2065     uint256 public maxMintsPerTx = 5;
2066     
2067     constructor() public ERC721("NobiToadz", "NOBI") {}
2068 
2069     //Set Base URI
2070     function setBaseURI(string memory _baseURI) external onlyOwner {
2071         _setBaseURI(_baseURI);
2072     }
2073     
2074     function flipMintState() public onlyOwner {
2075         openMint = !openMint;
2076     }
2077 
2078     function initializePaymentSplitter (address[] memory payees, uint256[] memory shares_) external onlyOwner {
2079         require (!initialized, "Payment Split Already Initialized!");
2080         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2081         require(payees.length > 0, "PaymentSplitter: no payees");
2082 
2083         for (uint256 i = 0; i < payees.length; i++) {
2084             _addPayee(payees[i], shares_[i]);
2085         }
2086         initialized=true;
2087     }
2088     
2089     function mintDev(uint256 quantity) external onlyOwner {
2090         for (uint256 i = 0; i < quantity; i++) {
2091             _safeMint(msg.sender, devTokenCount++);
2092         }
2093     }
2094     
2095     function mint(uint256 quantity) external payable {
2096         require(totalSupply() + quantity <= maxTokens, "minting this many would exceed supply");
2097         require(quantity <= maxMintsPerTx, "trying to mint too many at a time");
2098         require(msg.value >= tokenPrice * quantity, "not enough ether sent");
2099         require(openMint, "mint not open");
2100         for (uint256 i = 0; i < quantity; i++) {
2101             safeMint(msg.sender);
2102         }
2103     }
2104 
2105     function safeMint(address to) internal {
2106         uint256 tokenId = _tokenIdCounter.current();
2107         _tokenIdCounter.increment();
2108         _safeMint(to, tokenId);
2109     }
2110 
2111     function totalSupply() public view override returns (uint) {
2112         return _tokenIdCounter.current() + devTokenCount - 3957;
2113     }
2114 
2115     function setPrice(uint newPrice) external onlyOwner {
2116         tokenPrice = newPrice;
2117     }
2118 }