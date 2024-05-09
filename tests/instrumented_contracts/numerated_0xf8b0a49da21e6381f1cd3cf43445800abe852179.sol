1 /*
2 SPDX-License-Identifier: GPL-3.0                                                                             
3                                          @@@@@@@@@@@@@@@@@@@@@@                    
4                                     @@@@       @@@@@@@@@@@@@@@@@@@@             
5                                   @@@@       @@@@           ***  @@@@           
6                                /@@@@       @@@@             ***    @@           
7                                /@@      @@@@@               ***    @@           
8                            @@@@@@@@@@@@@@@@@@               ***    @@           
9                        @@@@@@              @@@@@@**.      **       @@           
10                        @@                      @@@@#******       @@@@           
11                   @@@@@                          @@@@@@@@@@@@@@                 
12                   @@   @@       @@             @@@@/      @@@@@                 
13                   @@                       @@@@@@           @@@@@               
14                   @@@@@             @@@@@@@@@@@             @@@@@               
15                     @@@@@         @@@@                    @@@@@                 
16                        @@@@@@@@@@@@@@@@@@@@@@@@    /@@@@@@@@                    
17                     @@@@@@@       @@@@@@@@@  @@@@@@@@@  @@                      
18               @@@@@@@@@    @@@@@@@@@         @@         @@                      
19          @@@@@         @@@@                    @@@@@@@    @@@@@@@      */       
20          
21 
22 
23 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Strings.sol
24 
25 
26 
27 pragma solidity >=0.6.0 <0.8.0;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         uint256 index = digits - 1;
51         temp = value;
52         while (temp != 0) {
53             buffer[index--] = bytes1(uint8(48 + temp % 10));
54             temp /= 10;
55         }
56         return string(buffer);
57     }
58 }
59 
60 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/EnumerableMap.sol
61 
62 
63 
64 pragma solidity >=0.6.0 <0.8.0;
65 
66 /**
67  * @dev Library for managing an enumerable variant of Solidity's
68  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
69  * type.
70  *
71  * Maps have the following properties:
72  *
73  * - Entries are added, removed, and checked for existence in constant time
74  * (O(1)).
75  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
76  *
77  * ```
78  * contract Example {
79  *     // Add the library methods
80  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
81  *
82  *     // Declare a set state variable
83  *     EnumerableMap.UintToAddressMap private myMap;
84  * }
85  * ```
86  *
87  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
88  * supported.
89  */
90 library EnumerableMap {
91     // To implement this library for multiple types with as little code
92     // repetition as possible, we write it in terms of a generic Map type with
93     // bytes32 keys and values.
94     // The Map implementation uses private functions, and user-facing
95     // implementations (such as Uint256ToAddressMap) are just wrappers around
96     // the underlying Map.
97     // This means that we can only create new EnumerableMaps for types that fit
98     // in bytes32.
99 
100     struct MapEntry {
101         bytes32 _key;
102         bytes32 _value;
103     }
104 
105     struct Map {
106         // Storage of map keys and values
107         MapEntry[] _entries;
108 
109         // Position of the entry defined by a key in the `entries` array, plus 1
110         // because index 0 means a key is not in the map.
111         mapping (bytes32 => uint256) _indexes;
112     }
113 
114     /**
115      * @dev Adds a key-value pair to a map, or updates the value for an existing
116      * key. O(1).
117      *
118      * Returns true if the key was added to the map, that is if it was not
119      * already present.
120      */
121     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
122         // We read and store the key's index to prevent multiple reads from the same storage slot
123         uint256 keyIndex = map._indexes[key];
124 
125         if (keyIndex == 0) { // Equivalent to !contains(map, key)
126             map._entries.push(MapEntry({ _key: key, _value: value }));
127             // The entry is stored at length-1, but we add 1 to all indexes
128             // and use 0 as a sentinel value
129             map._indexes[key] = map._entries.length;
130             return true;
131         } else {
132             map._entries[keyIndex - 1]._value = value;
133             return false;
134         }
135     }
136 
137     /**
138      * @dev Removes a key-value pair from a map. O(1).
139      *
140      * Returns true if the key was removed from the map, that is if it was present.
141      */
142     function _remove(Map storage map, bytes32 key) private returns (bool) {
143         // We read and store the key's index to prevent multiple reads from the same storage slot
144         uint256 keyIndex = map._indexes[key];
145 
146         if (keyIndex != 0) { // Equivalent to contains(map, key)
147             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
148             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
149             // This modifies the order of the array, as noted in {at}.
150 
151             uint256 toDeleteIndex = keyIndex - 1;
152             uint256 lastIndex = map._entries.length - 1;
153 
154             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
155             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
156 
157             MapEntry storage lastEntry = map._entries[lastIndex];
158 
159             // Move the last entry to the index where the entry to delete is
160             map._entries[toDeleteIndex] = lastEntry;
161             // Update the index for the moved entry
162             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
163 
164             // Delete the slot where the moved entry was stored
165             map._entries.pop();
166 
167             // Delete the index for the deleted slot
168             delete map._indexes[key];
169 
170             return true;
171         } else {
172             return false;
173         }
174     }
175 
176     /**
177      * @dev Returns true if the key is in the map. O(1).
178      */
179     function _contains(Map storage map, bytes32 key) private view returns (bool) {
180         return map._indexes[key] != 0;
181     }
182 
183     /**
184      * @dev Returns the number of key-value pairs in the map. O(1).
185      */
186     function _length(Map storage map) private view returns (uint256) {
187         return map._entries.length;
188     }
189 
190    /**
191     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
192     *
193     * Note that there are no guarantees on the ordering of entries inside the
194     * array, and it may change when more entries are added or removed.
195     *
196     * Requirements:
197     *
198     * - `index` must be strictly less than {length}.
199     */
200     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
201         require(map._entries.length > index, "EnumerableMap: index out of bounds");
202 
203         MapEntry storage entry = map._entries[index];
204         return (entry._key, entry._value);
205     }
206 
207     /**
208      * @dev Tries to returns the value associated with `key`.  O(1).
209      * Does not revert if `key` is not in the map.
210      */
211     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
212         uint256 keyIndex = map._indexes[key];
213         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
214         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
215     }
216 
217     /**
218      * @dev Returns the value associated with `key`.  O(1).
219      *
220      * Requirements:
221      *
222      * - `key` must be in the map.
223      */
224     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
225         uint256 keyIndex = map._indexes[key];
226         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
227         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
228     }
229 
230     /**
231      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
232      *
233      * CAUTION: This function is deprecated because it requires allocating memory for the error
234      * message unnecessarily. For custom revert reasons use {_tryGet}.
235      */
236     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
237         uint256 keyIndex = map._indexes[key];
238         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
239         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
240     }
241 
242     // UintToAddressMap
243 
244     struct UintToAddressMap {
245         Map _inner;
246     }
247 
248     /**
249      * @dev Adds a key-value pair to a map, or updates the value for an existing
250      * key. O(1).
251      *
252      * Returns true if the key was added to the map, that is if it was not
253      * already present.
254      */
255     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
256         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
257     }
258 
259     /**
260      * @dev Removes a value from a set. O(1).
261      *
262      * Returns true if the key was removed from the map, that is if it was present.
263      */
264     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
265         return _remove(map._inner, bytes32(key));
266     }
267 
268     /**
269      * @dev Returns true if the key is in the map. O(1).
270      */
271     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
272         return _contains(map._inner, bytes32(key));
273     }
274 
275     /**
276      * @dev Returns the number of elements in the map. O(1).
277      */
278     function length(UintToAddressMap storage map) internal view returns (uint256) {
279         return _length(map._inner);
280     }
281 
282    /**
283     * @dev Returns the element stored at position `index` in the set. O(1).
284     * Note that there are no guarantees on the ordering of values inside the
285     * array, and it may change when more values are added or removed.
286     *
287     * Requirements:
288     *
289     * - `index` must be strictly less than {length}.
290     */
291     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
292         (bytes32 key, bytes32 value) = _at(map._inner, index);
293         return (uint256(key), address(uint160(uint256(value))));
294     }
295 
296     /**
297      * @dev Tries to returns the value associated with `key`.  O(1).
298      * Does not revert if `key` is not in the map.
299      *
300      * _Available since v3.4._
301      */
302     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
303         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
304         return (success, address(uint160(uint256(value))));
305     }
306 
307     /**
308      * @dev Returns the value associated with `key`.  O(1).
309      *
310      * Requirements:
311      *
312      * - `key` must be in the map.
313      */
314     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
315         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
316     }
317 
318     /**
319      * @dev Same as {get}, with a custom error message when `key` is not in the map.
320      *
321      * CAUTION: This function is deprecated because it requires allocating memory for the error
322      * message unnecessarily. For custom revert reasons use {tryGet}.
323      */
324     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
325         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
326     }
327 }
328 
329 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/EnumerableSet.sol
330 
331 
332 
333 pragma solidity >=0.6.0 <0.8.0;
334 
335 /**
336  * @dev Library for managing
337  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
338  * types.
339  *
340  * Sets have the following properties:
341  *
342  * - Elements are added, removed, and checked for existence in constant time
343  * (O(1)).
344  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
345  *
346  * ```
347  * contract Example {
348  *     // Add the library methods
349  *     using EnumerableSet for EnumerableSet.AddressSet;
350  *
351  *     // Declare a set state variable
352  *     EnumerableSet.AddressSet private mySet;
353  * }
354  * ```
355  *
356  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
357  * and `uint256` (`UintSet`) are supported.
358  */
359 library EnumerableSet {
360     // To implement this library for multiple types with as little code
361     // repetition as possible, we write it in terms of a generic Set type with
362     // bytes32 values.
363     // The Set implementation uses private functions, and user-facing
364     // implementations (such as AddressSet) are just wrappers around the
365     // underlying Set.
366     // This means that we can only create new EnumerableSets for types that fit
367     // in bytes32.
368 
369     struct Set {
370         // Storage of set values
371         bytes32[] _values;
372 
373         // Position of the value in the `values` array, plus 1 because index 0
374         // means a value is not in the set.
375         mapping (bytes32 => uint256) _indexes;
376     }
377 
378     /**
379      * @dev Add a value to a set. O(1).
380      *
381      * Returns true if the value was added to the set, that is if it was not
382      * already present.
383      */
384     function _add(Set storage set, bytes32 value) private returns (bool) {
385         if (!_contains(set, value)) {
386             set._values.push(value);
387             // The value is stored at length-1, but we add 1 to all indexes
388             // and use 0 as a sentinel value
389             set._indexes[value] = set._values.length;
390             return true;
391         } else {
392             return false;
393         }
394     }
395 
396     /**
397      * @dev Removes a value from a set. O(1).
398      *
399      * Returns true if the value was removed from the set, that is if it was
400      * present.
401      */
402     function _remove(Set storage set, bytes32 value) private returns (bool) {
403         // We read and store the value's index to prevent multiple reads from the same storage slot
404         uint256 valueIndex = set._indexes[value];
405 
406         if (valueIndex != 0) { // Equivalent to contains(set, value)
407             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
408             // the array, and then remove the last element (sometimes called as 'swap and pop').
409             // This modifies the order of the array, as noted in {at}.
410 
411             uint256 toDeleteIndex = valueIndex - 1;
412             uint256 lastIndex = set._values.length - 1;
413 
414             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
415             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
416 
417             bytes32 lastvalue = set._values[lastIndex];
418 
419             // Move the last value to the index where the value to delete is
420             set._values[toDeleteIndex] = lastvalue;
421             // Update the index for the moved value
422             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
423 
424             // Delete the slot where the moved value was stored
425             set._values.pop();
426 
427             // Delete the index for the deleted slot
428             delete set._indexes[value];
429 
430             return true;
431         } else {
432             return false;
433         }
434     }
435 
436     /**
437      * @dev Returns true if the value is in the set. O(1).
438      */
439     function _contains(Set storage set, bytes32 value) private view returns (bool) {
440         return set._indexes[value] != 0;
441     }
442 
443     /**
444      * @dev Returns the number of values on the set. O(1).
445      */
446     function _length(Set storage set) private view returns (uint256) {
447         return set._values.length;
448     }
449 
450    /**
451     * @dev Returns the value stored at position `index` in the set. O(1).
452     *
453     * Note that there are no guarantees on the ordering of values inside the
454     * array, and it may change when more values are added or removed.
455     *
456     * Requirements:
457     *
458     * - `index` must be strictly less than {length}.
459     */
460     function _at(Set storage set, uint256 index) private view returns (bytes32) {
461         require(set._values.length > index, "EnumerableSet: index out of bounds");
462         return set._values[index];
463     }
464 
465     // Bytes32Set
466 
467     struct Bytes32Set {
468         Set _inner;
469     }
470 
471     /**
472      * @dev Add a value to a set. O(1).
473      *
474      * Returns true if the value was added to the set, that is if it was not
475      * already present.
476      */
477     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
478         return _add(set._inner, value);
479     }
480 
481     /**
482      * @dev Removes a value from a set. O(1).
483      *
484      * Returns true if the value was removed from the set, that is if it was
485      * present.
486      */
487     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
488         return _remove(set._inner, value);
489     }
490 
491     /**
492      * @dev Returns true if the value is in the set. O(1).
493      */
494     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
495         return _contains(set._inner, value);
496     }
497 
498     /**
499      * @dev Returns the number of values in the set. O(1).
500      */
501     function length(Bytes32Set storage set) internal view returns (uint256) {
502         return _length(set._inner);
503     }
504 
505    /**
506     * @dev Returns the value stored at position `index` in the set. O(1).
507     *
508     * Note that there are no guarantees on the ordering of values inside the
509     * array, and it may change when more values are added or removed.
510     *
511     * Requirements:
512     *
513     * - `index` must be strictly less than {length}.
514     */
515     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
516         return _at(set._inner, index);
517     }
518 
519     // AddressSet
520 
521     struct AddressSet {
522         Set _inner;
523     }
524 
525     /**
526      * @dev Add a value to a set. O(1).
527      *
528      * Returns true if the value was added to the set, that is if it was not
529      * already present.
530      */
531     function add(AddressSet storage set, address value) internal returns (bool) {
532         return _add(set._inner, bytes32(uint256(uint160(value))));
533     }
534 
535     /**
536      * @dev Removes a value from a set. O(1).
537      *
538      * Returns true if the value was removed from the set, that is if it was
539      * present.
540      */
541     function remove(AddressSet storage set, address value) internal returns (bool) {
542         return _remove(set._inner, bytes32(uint256(uint160(value))));
543     }
544 
545     /**
546      * @dev Returns true if the value is in the set. O(1).
547      */
548     function contains(AddressSet storage set, address value) internal view returns (bool) {
549         return _contains(set._inner, bytes32(uint256(uint160(value))));
550     }
551 
552     /**
553      * @dev Returns the number of values in the set. O(1).
554      */
555     function length(AddressSet storage set) internal view returns (uint256) {
556         return _length(set._inner);
557     }
558 
559    /**
560     * @dev Returns the value stored at position `index` in the set. O(1).
561     *
562     * Note that there are no guarantees on the ordering of values inside the
563     * array, and it may change when more values are added or removed.
564     *
565     * Requirements:
566     *
567     * - `index` must be strictly less than {length}.
568     */
569     function at(AddressSet storage set, uint256 index) internal view returns (address) {
570         return address(uint160(uint256(_at(set._inner, index))));
571     }
572 
573 
574     // UintSet
575 
576     struct UintSet {
577         Set _inner;
578     }
579 
580     /**
581      * @dev Add a value to a set. O(1).
582      *
583      * Returns true if the value was added to the set, that is if it was not
584      * already present.
585      */
586     function add(UintSet storage set, uint256 value) internal returns (bool) {
587         return _add(set._inner, bytes32(value));
588     }
589 
590     /**
591      * @dev Removes a value from a set. O(1).
592      *
593      * Returns true if the value was removed from the set, that is if it was
594      * present.
595      */
596     function remove(UintSet storage set, uint256 value) internal returns (bool) {
597         return _remove(set._inner, bytes32(value));
598     }
599 
600     /**
601      * @dev Returns true if the value is in the set. O(1).
602      */
603     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
604         return _contains(set._inner, bytes32(value));
605     }
606 
607     /**
608      * @dev Returns the number of values on the set. O(1).
609      */
610     function length(UintSet storage set) internal view returns (uint256) {
611         return _length(set._inner);
612     }
613 
614    /**
615     * @dev Returns the value stored at position `index` in the set. O(1).
616     *
617     * Note that there are no guarantees on the ordering of values inside the
618     * array, and it may change when more values are added or removed.
619     *
620     * Requirements:
621     *
622     * - `index` must be strictly less than {length}.
623     */
624     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
625         return uint256(_at(set._inner, index));
626     }
627 }
628 
629 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Address.sol
630 
631 
632 
633 pragma solidity >=0.6.2 <0.8.0;
634 
635 /**
636  * @dev Collection of functions related to the address type
637  */
638 library Address {
639     /**
640      * @dev Returns true if `account` is a contract.
641      *
642      * [IMPORTANT]
643      * ====
644      * It is unsafe to assume that an address for which this function returns
645      * false is an externally-owned account (EOA) and not a contract.
646      *
647      * Among others, `isContract` will return false for the following
648      * types of addresses:
649      *
650      *  - an externally-owned account
651      *  - a contract in construction
652      *  - an address where a contract will be created
653      *  - an address where a contract lived, but was destroyed
654      * ====
655      */
656     function isContract(address account) internal view returns (bool) {
657         // This method relies on extcodesize, which returns 0 for contracts in
658         // construction, since the code is only stored at the end of the
659         // constructor execution.
660 
661         uint256 size;
662         // solhint-disable-next-line no-inline-assembly
663         assembly { size := extcodesize(account) }
664         return size > 0;
665     }
666 
667     /**
668      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
669      * `recipient`, forwarding all available gas and reverting on errors.
670      *
671      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
672      * of certain opcodes, possibly making contracts go over the 2300 gas limit
673      * imposed by `transfer`, making them unable to receive funds via
674      * `transfer`. {sendValue} removes this limitation.
675      *
676      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
677      *
678      * IMPORTANT: because control is transferred to `recipient`, care must be
679      * taken to not create reentrancy vulnerabilities. Consider using
680      * {ReentrancyGuard} or the
681      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
682      */
683     function sendValue(address payable recipient, uint256 amount) internal {
684         require(address(this).balance >= amount, "Address: insufficient balance");
685 
686         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
687         (bool success, ) = recipient.call{ value: amount }("");
688         require(success, "Address: unable to send value, recipient may have reverted");
689     }
690 
691     /**
692      * @dev Performs a Solidity function call using a low level `call`. A
693      * plain`call` is an unsafe replacement for a function call: use this
694      * function instead.
695      *
696      * If `target` reverts with a revert reason, it is bubbled up by this
697      * function (like regular Solidity function calls).
698      *
699      * Returns the raw returned data. To convert to the expected return value,
700      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
701      *
702      * Requirements:
703      *
704      * - `target` must be a contract.
705      * - calling `target` with `data` must not revert.
706      *
707      * _Available since v3.1._
708      */
709     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
710       return functionCall(target, data, "Address: low-level call failed");
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
715      * `errorMessage` as a fallback revert reason when `target` reverts.
716      *
717      * _Available since v3.1._
718      */
719     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
720         return functionCallWithValue(target, data, 0, errorMessage);
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
725      * but also transferring `value` wei to `target`.
726      *
727      * Requirements:
728      *
729      * - the calling contract must have an ETH balance of at least `value`.
730      * - the called Solidity function must be `payable`.
731      *
732      * _Available since v3.1._
733      */
734     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
735         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
740      * with `errorMessage` as a fallback revert reason when `target` reverts.
741      *
742      * _Available since v3.1._
743      */
744     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
745         require(address(this).balance >= value, "Address: insufficient balance for call");
746         require(isContract(target), "Address: call to non-contract");
747 
748         // solhint-disable-next-line avoid-low-level-calls
749         (bool success, bytes memory returndata) = target.call{ value: value }(data);
750         return _verifyCallResult(success, returndata, errorMessage);
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
755      * but performing a static call.
756      *
757      * _Available since v3.3._
758      */
759     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
760         return functionStaticCall(target, data, "Address: low-level static call failed");
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
765      * but performing a static call.
766      *
767      * _Available since v3.3._
768      */
769     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
770         require(isContract(target), "Address: static call to non-contract");
771 
772         // solhint-disable-next-line avoid-low-level-calls
773         (bool success, bytes memory returndata) = target.staticcall(data);
774         return _verifyCallResult(success, returndata, errorMessage);
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
779      * but performing a delegate call.
780      *
781      * _Available since v3.4._
782      */
783     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
784         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
789      * but performing a delegate call.
790      *
791      * _Available since v3.4._
792      */
793     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
794         require(isContract(target), "Address: delegate call to non-contract");
795 
796         // solhint-disable-next-line avoid-low-level-calls
797         (bool success, bytes memory returndata) = target.delegatecall(data);
798         return _verifyCallResult(success, returndata, errorMessage);
799     }
800 
801     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
802         if (success) {
803             return returndata;
804         } else {
805             // Look for revert reason and bubble it up if present
806             if (returndata.length > 0) {
807                 // The easiest way to bubble the revert reason is using memory via assembly
808 
809                 // solhint-disable-next-line no-inline-assembly
810                 assembly {
811                     let returndata_size := mload(returndata)
812                     revert(add(32, returndata), returndata_size)
813                 }
814             } else {
815                 revert(errorMessage);
816             }
817         }
818     }
819 }
820 
821 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol
822 
823 
824 
825 pragma solidity >=0.6.0 <0.8.0;
826 
827 /**
828  * @dev Wrappers over Solidity's arithmetic operations with added overflow
829  * checks.
830  *
831  * Arithmetic operations in Solidity wrap on overflow. This can easily result
832  * in bugs, because programmers usually assume that an overflow raises an
833  * error, which is the standard behavior in high level programming languages.
834  * `SafeMath` restores this intuition by reverting the transaction when an
835  * operation overflows.
836  *
837  * Using this library instead of the unchecked operations eliminates an entire
838  * class of bugs, so it's recommended to use it always.
839  */
840 library SafeMath {
841     /**
842      * @dev Returns the addition of two unsigned integers, with an overflow flag.
843      *
844      * _Available since v3.4._
845      */
846     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
847         uint256 c = a + b;
848         if (c < a) return (false, 0);
849         return (true, c);
850     }
851 
852     /**
853      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
854      *
855      * _Available since v3.4._
856      */
857     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
858         if (b > a) return (false, 0);
859         return (true, a - b);
860     }
861 
862     /**
863      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
864      *
865      * _Available since v3.4._
866      */
867     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
868         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
869         // benefit is lost if 'b' is also tested.
870         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
871         if (a == 0) return (true, 0);
872         uint256 c = a * b;
873         if (c / a != b) return (false, 0);
874         return (true, c);
875     }
876 
877     /**
878      * @dev Returns the division of two unsigned integers, with a division by zero flag.
879      *
880      * _Available since v3.4._
881      */
882     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
883         if (b == 0) return (false, 0);
884         return (true, a / b);
885     }
886 
887     /**
888      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
889      *
890      * _Available since v3.4._
891      */
892     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
893         if (b == 0) return (false, 0);
894         return (true, a % b);
895     }
896 
897     /**
898      * @dev Returns the addition of two unsigned integers, reverting on
899      * overflow.
900      *
901      * Counterpart to Solidity's `+` operator.
902      *
903      * Requirements:
904      *
905      * - Addition cannot overflow.
906      */
907     function add(uint256 a, uint256 b) internal pure returns (uint256) {
908         uint256 c = a + b;
909         require(c >= a, "SafeMath: addition overflow");
910         return c;
911     }
912 
913     /**
914      * @dev Returns the subtraction of two unsigned integers, reverting on
915      * overflow (when the result is negative).
916      *
917      * Counterpart to Solidity's `-` operator.
918      *
919      * Requirements:
920      *
921      * - Subtraction cannot overflow.
922      */
923     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
924         require(b <= a, "SafeMath: subtraction overflow");
925         return a - b;
926     }
927 
928     /**
929      * @dev Returns the multiplication of two unsigned integers, reverting on
930      * overflow.
931      *
932      * Counterpart to Solidity's `*` operator.
933      *
934      * Requirements:
935      *
936      * - Multiplication cannot overflow.
937      */
938     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
939         if (a == 0) return 0;
940         uint256 c = a * b;
941         require(c / a == b, "SafeMath: multiplication overflow");
942         return c;
943     }
944 
945     /**
946      * @dev Returns the integer division of two unsigned integers, reverting on
947      * division by zero. The result is rounded towards zero.
948      *
949      * Counterpart to Solidity's `/` operator. Note: this function uses a
950      * `revert` opcode (which leaves remaining gas untouched) while Solidity
951      * uses an invalid opcode to revert (consuming all remaining gas).
952      *
953      * Requirements:
954      *
955      * - The divisor cannot be zero.
956      */
957     function div(uint256 a, uint256 b) internal pure returns (uint256) {
958         require(b > 0, "SafeMath: division by zero");
959         return a / b;
960     }
961 
962     /**
963      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
964      * reverting when dividing by zero.
965      *
966      * Counterpart to Solidity's `%` operator. This function uses a `revert`
967      * opcode (which leaves remaining gas untouched) while Solidity uses an
968      * invalid opcode to revert (consuming all remaining gas).
969      *
970      * Requirements:
971      *
972      * - The divisor cannot be zero.
973      */
974     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
975         require(b > 0, "SafeMath: modulo by zero");
976         return a % b;
977     }
978 
979     /**
980      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
981      * overflow (when the result is negative).
982      *
983      * CAUTION: This function is deprecated because it requires allocating memory for the error
984      * message unnecessarily. For custom revert reasons use {trySub}.
985      *
986      * Counterpart to Solidity's `-` operator.
987      *
988      * Requirements:
989      *
990      * - Subtraction cannot overflow.
991      */
992     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
993         require(b <= a, errorMessage);
994         return a - b;
995     }
996 
997     /**
998      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
999      * division by zero. The result is rounded towards zero.
1000      *
1001      * CAUTION: This function is deprecated because it requires allocating memory for the error
1002      * message unnecessarily. For custom revert reasons use {tryDiv}.
1003      *
1004      * Counterpart to Solidity's `/` operator. Note: this function uses a
1005      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1006      * uses an invalid opcode to revert (consuming all remaining gas).
1007      *
1008      * Requirements:
1009      *
1010      * - The divisor cannot be zero.
1011      */
1012     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1013         require(b > 0, errorMessage);
1014         return a / b;
1015     }
1016 
1017     /**
1018      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1019      * reverting with custom message when dividing by zero.
1020      *
1021      * CAUTION: This function is deprecated because it requires allocating memory for the error
1022      * message unnecessarily. For custom revert reasons use {tryMod}.
1023      *
1024      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1025      * opcode (which leaves remaining gas untouched) while Solidity uses an
1026      * invalid opcode to revert (consuming all remaining gas).
1027      *
1028      * Requirements:
1029      *
1030      * - The divisor cannot be zero.
1031      */
1032     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1033         require(b > 0, errorMessage);
1034         return a % b;
1035     }
1036 }
1037 
1038 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721Receiver.sol
1039 
1040 
1041 
1042 pragma solidity >=0.6.0 <0.8.0;
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
1062 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/introspection/IERC165.sol
1063 
1064 
1065 
1066 pragma solidity >=0.6.0 <0.8.0;
1067 
1068 /**
1069  * @dev Interface of the ERC165 standard, as defined in the
1070  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1071  *
1072  * Implementers can declare support of contract interfaces, which can then be
1073  * queried by others ({ERC165Checker}).
1074  *
1075  * For an implementation, see {ERC165}.
1076  */
1077 interface IERC165 {
1078     /**
1079      * @dev Returns true if this contract implements the interface defined by
1080      * `interfaceId`. See the corresponding
1081      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1082      * to learn more about how these ids are created.
1083      *
1084      * This function call must use less than 30 000 gas.
1085      */
1086     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1087 }
1088 
1089 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/introspection/ERC165.sol
1090 
1091 
1092 
1093 pragma solidity >=0.6.0 <0.8.0;
1094 
1095 
1096 /**
1097  * @dev Implementation of the {IERC165} interface.
1098  *
1099  * Contracts may inherit from this and call {_registerInterface} to declare
1100  * their support of an interface.
1101  */
1102 abstract contract ERC165 is IERC165 {
1103     /*
1104      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1105      */
1106     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1107 
1108     /**
1109      * @dev Mapping of interface ids to whether or not it's supported.
1110      */
1111     mapping(bytes4 => bool) private _supportedInterfaces;
1112 
1113     constructor () {
1114         // Derived contracts need only register support for their own interfaces,
1115         // we register support for ERC165 itself here
1116         _registerInterface(_INTERFACE_ID_ERC165);
1117     }
1118 
1119     /**
1120      * @dev See {IERC165-supportsInterface}.
1121      *
1122      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1123      */
1124     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1125         return _supportedInterfaces[interfaceId];
1126     }
1127 
1128     /**
1129      * @dev Registers the contract as an implementer of the interface defined by
1130      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1131      * registering its interface id is not required.
1132      *
1133      * See {IERC165-supportsInterface}.
1134      *
1135      * Requirements:
1136      *
1137      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1138      */
1139     function _registerInterface(bytes4 interfaceId) internal virtual {
1140         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1141         _supportedInterfaces[interfaceId] = true;
1142     }
1143 }
1144 
1145 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721.sol
1146 
1147 
1148 
1149 pragma solidity >=0.6.2 <0.8.0;
1150 
1151 
1152 /**
1153  * @dev Required interface of an ERC721 compliant contract.
1154  */
1155 interface IERC721 is IERC165 {
1156     /**
1157      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1158      */
1159     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1160 
1161     /**
1162      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1163      */
1164     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1165 
1166     /**
1167      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1168      */
1169     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1170 
1171     /**
1172      * @dev Returns the number of tokens in ``owner``'s account.
1173      */
1174     function balanceOf(address owner) external view returns (uint256 balance);
1175 
1176     /**
1177      * @dev Returns the owner of the `tokenId` token.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      */
1183     function ownerOf(uint256 tokenId) external view returns (address owner);
1184 
1185     /**
1186      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1187      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1188      *
1189      * Requirements:
1190      *
1191      * - `from` cannot be the zero address.
1192      * - `to` cannot be the zero address.
1193      * - `tokenId` token must exist and be owned by `from`.
1194      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1200 
1201     /**
1202      * @dev Transfers `tokenId` token from `from` to `to`.
1203      *
1204      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1205      *
1206      * Requirements:
1207      *
1208      * - `from` cannot be the zero address.
1209      * - `to` cannot be the zero address.
1210      * - `tokenId` token must be owned by `from`.
1211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function transferFrom(address from, address to, uint256 tokenId) external;
1216 
1217     /**
1218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1219      * The approval is cleared when the token is transferred.
1220      *
1221      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1222      *
1223      * Requirements:
1224      *
1225      * - The caller must own the token or be an approved operator.
1226      * - `tokenId` must exist.
1227      *
1228      * Emits an {Approval} event.
1229      */
1230     function approve(address to, uint256 tokenId) external;
1231 
1232     /**
1233      * @dev Returns the account approved for `tokenId` token.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      */
1239     function getApproved(uint256 tokenId) external view returns (address operator);
1240 
1241     /**
1242      * @dev Approve or remove `operator` as an operator for the caller.
1243      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1244      *
1245      * Requirements:
1246      *
1247      * - The `operator` cannot be the caller.
1248      *
1249      * Emits an {ApprovalForAll} event.
1250      */
1251     function setApprovalForAll(address operator, bool _approved) external;
1252 
1253     /**
1254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1255      *
1256      * See {setApprovalForAll}
1257      */
1258     function isApprovedForAll(address owner, address operator) external view returns (bool);
1259 
1260     /**
1261       * @dev Safely transfers `tokenId` token from `from` to `to`.
1262       *
1263       * Requirements:
1264       *
1265       * - `from` cannot be the zero address.
1266       * - `to` cannot be the zero address.
1267       * - `tokenId` token must exist and be owned by `from`.
1268       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1269       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1270       *
1271       * Emits a {Transfer} event.
1272       */
1273     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1274 }
1275 
1276 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721Enumerable.sol
1277 
1278 
1279 
1280 pragma solidity >=0.6.2 <0.8.0;
1281 
1282 
1283 /**
1284  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1285  * @dev See https://eips.ethereum.org/EIPS/eip-721
1286  */
1287 interface IERC721Enumerable is IERC721 {
1288 
1289     /**
1290      * @dev Returns the total amount of tokens stored by the contract.
1291      */
1292     function totalSupply() external view returns (uint256);
1293 
1294     /**
1295      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1296      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1297      */
1298     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1299 
1300     /**
1301      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1302      * Use along with {totalSupply} to enumerate all tokens.
1303      */
1304     function tokenByIndex(uint256 index) external view returns (uint256);
1305 }
1306 
1307 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/IERC721Metadata.sol
1308 
1309 
1310 
1311 pragma solidity >=0.6.2 <0.8.0;
1312 
1313 
1314 /**
1315  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1316  * @dev See https://eips.ethereum.org/EIPS/eip-721
1317  */
1318 interface IERC721Metadata is IERC721 {
1319 
1320     /**
1321      * @dev Returns the token collection name.
1322      */
1323     function name() external view returns (string memory);
1324 
1325     /**
1326      * @dev Returns the token collection symbol.
1327      */
1328     function symbol() external view returns (string memory);
1329 
1330     /**
1331      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1332      */
1333     function tokenURI(uint256 tokenId) external view returns (string memory);
1334 }
1335 
1336 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Context.sol
1337 
1338 
1339 
1340 pragma solidity >=0.6.0 <0.8.0;
1341 
1342 /*
1343  * @dev Provides information about the current execution context, including the
1344  * sender of the transaction and its data. While these are generally available
1345  * via msg.sender and msg.data, they should not be accessed in such a direct
1346  * manner, since when dealing with GSN meta-transactions the account sending and
1347  * paying for execution may not be the actual sender (as far as an application
1348  * is concerned).
1349  *
1350  * This contract is only required for intermediate, library-like contracts.
1351  */
1352 abstract contract Context {
1353     function _msgSender() internal view virtual returns (address payable) {
1354         return msg.sender;
1355     }
1356 
1357     function _msgData() internal view virtual returns (bytes memory) {
1358         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1359         return msg.data;
1360     }
1361 }
1362 
1363 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/payment/PaymentSplitter.sol
1364 
1365 
1366 
1367 pragma solidity >=0.6.0 <0.8.0;
1368 
1369 
1370 
1371 
1372 /**
1373  * @title PaymentSplitter
1374  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1375  * that the Ether will be split in this way, since it is handled transparently by the contract.
1376  *
1377  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1378  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1379  * an amount proportional to the percentage of total shares they were assigned.
1380  *
1381  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1382  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1383  * function.
1384  */
1385 contract PaymentSplitter is Context {
1386     using SafeMath for uint256;
1387 
1388     event PayeeAdded(address account, uint256 shares);
1389     event PaymentReleased(address to, uint256 amount);
1390     event PaymentReceived(address from, uint256 amount);
1391 
1392     uint256 private _totalShares;
1393     uint256 private _totalReleased;
1394 
1395     mapping(address => uint256) private _shares;
1396     mapping(address => uint256) private _released;
1397     address[] private _payees;
1398 
1399     /**
1400      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1401      * the matching position in the `shares` array.
1402      *
1403      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1404      * duplicates in `payees`.
1405      */
1406     constructor () public payable {}
1407 
1408     /**
1409      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1410      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1411      * reliability of the events, and not the actual splitting of Ether.
1412      *
1413      * To learn more about this see the Solidity documentation for
1414      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1415      * functions].
1416      */
1417     receive () external payable virtual {
1418         emit PaymentReceived(_msgSender(), msg.value);
1419     }
1420 
1421     /**
1422      * @dev Getter for the total shares held by payees.
1423      */
1424     function totalShares() public view returns (uint256) {
1425         return _totalShares;
1426     }
1427 
1428     /**
1429      * @dev Getter for the total amount of Ether already released.
1430      */
1431     function totalReleased() public view returns (uint256) {
1432         return _totalReleased;
1433     }
1434 
1435     /**
1436      * @dev Getter for the amount of shares held by an account.
1437      */
1438     function shares(address account) public view returns (uint256) {
1439         return _shares[account];
1440     }
1441 
1442     /**
1443      * @dev Getter for the amount of Ether already released to a payee.
1444      */
1445     function released(address account) public view returns (uint256) {
1446         return _released[account];
1447     }
1448 
1449     /**
1450      * @dev Getter for the address of the payee number `index`.
1451      */
1452     function payee(uint256 index) public view returns (address) {
1453         return _payees[index];
1454     }
1455 
1456     /**
1457      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1458      * total shares and their previous withdrawals.
1459      */
1460     function release(address payable account) public virtual {
1461         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1462 
1463         uint256 totalReceived = address(this).balance.add(_totalReleased);
1464         uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(_released[account]);
1465 
1466         require(payment != 0, "PaymentSplitter: account is not due payment");
1467 
1468         _released[account] = _released[account].add(payment);
1469         _totalReleased = _totalReleased.add(payment);
1470 
1471         Address.sendValue(account, payment);
1472         emit PaymentReleased(account, payment);
1473     }
1474 
1475     /**
1476      * @dev Add a new payee to the contract.
1477      * @param account The address of the payee to add.
1478      * @param shares_ The number of shares owned by the payee.
1479      */
1480     function _addPayee(address account, uint256 shares_) internal {
1481         require(account != address(0), "PaymentSplitter: account is the zero address");
1482         require(shares_ > 0, "PaymentSplitter: shares are 0");
1483         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1484 
1485         _payees.push(account);
1486         _shares[account] = shares_;
1487         _totalShares = _totalShares.add(shares_);
1488         emit PayeeAdded(account, shares_);
1489     }
1490 }
1491 
1492 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/access/Ownable.sol
1493 
1494 
1495 
1496 pragma solidity >=0.6.0 <0.8.0;
1497 
1498 /**
1499  * @dev Contract module which provides a basic access control mechanism, where
1500  * there is an account (an owner) that can be granted exclusive access to
1501  * specific functions.
1502  *
1503  * By default, the owner account will be the one that deploys the contract. This
1504  * can later be changed with {transferOwnership}.
1505  *
1506  * This module is used through inheritance. It will make available the modifier
1507  * `onlyOwner`, which can be applied to your functions to restrict their use to
1508  * the owner.
1509  */
1510 abstract contract Ownable is Context {
1511     address private _owner;
1512 
1513     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1514 
1515     /**
1516      * @dev Initializes the contract setting the deployer as the initial owner.
1517      */
1518     constructor () internal {
1519         address msgSender = _msgSender();
1520         _owner = msgSender;
1521         emit OwnershipTransferred(address(0), msgSender);
1522     }
1523 
1524     /**
1525      * @dev Returns the address of the current owner.
1526      */
1527     function owner() public view virtual returns (address) {
1528         return _owner;
1529     }
1530 
1531     /**
1532      * @dev Throws if called by any account other than the owner.
1533      */
1534     modifier onlyOwner() {
1535         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1536         _;
1537     }
1538 
1539     /**
1540      * @dev Leaves the contract without owner. It will not be possible to call
1541      * `onlyOwner` functions anymore. Can only be called by the current owner.
1542      *
1543      * NOTE: Renouncing ownership will leave the contract without an owner,
1544      * thereby removing any functionality that is only available to the owner.
1545      */
1546     function renounceOwnership() public virtual onlyOwner {
1547         emit OwnershipTransferred(_owner, address(0));
1548         _owner = address(0);
1549     }
1550 
1551     /**
1552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1553      * Can only be called by the current owner.
1554      */
1555     function transferOwnership(address newOwner) public virtual onlyOwner {
1556         require(newOwner != address(0), "Ownable: new owner is the zero address");
1557         emit OwnershipTransferred(_owner, newOwner);
1558         _owner = newOwner;
1559     }
1560 }
1561 
1562 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC721/ERC721.sol
1563 
1564 
1565 
1566 pragma solidity >=0.6.0 <0.8.0;
1567 
1568 
1569 
1570 
1571 
1572 
1573 
1574 
1575 
1576 
1577 
1578 
1579 /**
1580  * @title ERC721 Non-Fungible Token Standard basic implementation
1581  * @dev see https://eips.ethereum.org/EIPS/eip-721
1582  */
1583 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1584     using SafeMath for uint256;
1585     using Address for address;
1586     using EnumerableSet for EnumerableSet.UintSet;
1587     using EnumerableMap for EnumerableMap.UintToAddressMap;
1588     using Strings for uint256;
1589 
1590     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1591     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1592     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1593 
1594     // Mapping from holder address to their (enumerable) set of owned tokens
1595     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1596 
1597     // Enumerable mapping from token ids to their owners
1598     EnumerableMap.UintToAddressMap private _tokenOwners;
1599 
1600     // Mapping from token ID to approved address
1601     mapping (uint256 => address) private _tokenApprovals;
1602 
1603     // Mapping from owner to operator approvals
1604     mapping (address => mapping (address => bool)) private _operatorApprovals;
1605 
1606     // Token name
1607     string private _name;
1608 
1609     // Token symbol
1610     string private _symbol;
1611 
1612     // Optional mapping for token URIs
1613     mapping (uint256 => string) private _tokenURIs;
1614 
1615     // Base URI
1616     string private _baseURI;
1617 
1618     /*
1619      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1620      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1621      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1622      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1623      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1624      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1625      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1626      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1627      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1628      *
1629      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1630      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1631      */
1632     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1633 
1634     /*
1635      *     bytes4(keccak256('name()')) == 0x06fdde03
1636      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1637      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1638      *
1639      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1640      */
1641     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1642 
1643     /*
1644      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1645      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1646      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1647      *
1648      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1649      */
1650     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1651 
1652     /**
1653      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1654      */
1655     constructor (string memory name_, string memory symbol_) public {
1656         _name = name_;
1657         _symbol = symbol_;
1658 
1659         // register the supported interfaces to conform to ERC721 via ERC165
1660         _registerInterface(_INTERFACE_ID_ERC721);
1661         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1662         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1663     }
1664 
1665     /**
1666      * @dev See {IERC721-balanceOf}.
1667      */
1668     function balanceOf(address owner) public view virtual override returns (uint256) {
1669         require(owner != address(0), "ERC721: balance query for the zero address");
1670         return _holderTokens[owner].length();
1671     }
1672 
1673     /**
1674      * @dev See {IERC721-ownerOf}.
1675      */
1676     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1677         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1678     }
1679 
1680     /**
1681      * @dev See {IERC721Metadata-name}.
1682      */
1683     function name() public view virtual override returns (string memory) {
1684         return _name;
1685     }
1686 
1687     /**
1688      * @dev See {IERC721Metadata-symbol}.
1689      */
1690     function symbol() public view virtual override returns (string memory) {
1691         return _symbol;
1692     }
1693 
1694     /**
1695      * @dev See {IERC721Metadata-tokenURI}.
1696      */
1697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1698         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1699 
1700         string memory _tokenURI = _tokenURIs[tokenId];
1701         string memory base = baseURI();
1702 
1703         // If there is no base URI, return the token URI.
1704         if (bytes(base).length == 0) {
1705             return _tokenURI;
1706         }
1707         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1708         if (bytes(_tokenURI).length > 0) {
1709             return string(abi.encodePacked(base, _tokenURI));
1710         }
1711         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1712         return string(abi.encodePacked(base, tokenId.toString()));
1713     }
1714 
1715     /**
1716     * @dev Returns the base URI set via {_setBaseURI}. This will be
1717     * automatically added as a prefix in {tokenURI} to each token's URI, or
1718     * to the token ID if no specific URI is set for that token ID.
1719     */
1720     function baseURI() public view virtual returns (string memory) {
1721         return _baseURI;
1722     }
1723 
1724     /**
1725      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1726      */
1727     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1728         return _holderTokens[owner].at(index);
1729     }
1730 
1731     /**
1732      * @dev See {IERC721Enumerable-totalSupply}.
1733      */
1734     function totalSupply() public view virtual override returns (uint256) {
1735         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1736         return _tokenOwners.length();
1737     }
1738 
1739     /**
1740      * @dev See {IERC721Enumerable-tokenByIndex}.
1741      */
1742     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1743         (uint256 tokenId, ) = _tokenOwners.at(index);
1744         return tokenId;
1745     }
1746 
1747     /**
1748      * @dev See {IERC721-approve}.
1749      */
1750     function approve(address to, uint256 tokenId) public virtual override {
1751         address owner = ERC721.ownerOf(tokenId);
1752         require(to != owner, "ERC721: approval to current owner");
1753 
1754         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1755             "ERC721: approve caller is not owner nor approved for all"
1756         );
1757 
1758         _approve(to, tokenId);
1759     }
1760 
1761     /**
1762      * @dev See {IERC721-getApproved}.
1763      */
1764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1765         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1766 
1767         return _tokenApprovals[tokenId];
1768     }
1769 
1770     /**
1771      * @dev See {IERC721-setApprovalForAll}.
1772      */
1773     function setApprovalForAll(address operator, bool approved) public virtual override {
1774         require(operator != _msgSender(), "ERC721: approve to caller");
1775 
1776         _operatorApprovals[_msgSender()][operator] = approved;
1777         emit ApprovalForAll(_msgSender(), operator, approved);
1778     }
1779 
1780     /**
1781      * @dev See {IERC721-isApprovedForAll}.
1782      */
1783     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1784         return _operatorApprovals[owner][operator];
1785     }
1786 
1787     /**
1788      * @dev See {IERC721-transferFrom}.
1789      */
1790     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1791         //solhint-disable-next-line max-line-length
1792         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1793 
1794         _transfer(from, to, tokenId);
1795     }
1796 
1797     /**
1798      * @dev See {IERC721-safeTransferFrom}.
1799      */
1800     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1801         safeTransferFrom(from, to, tokenId, "");
1802     }
1803 
1804     /**
1805      * @dev See {IERC721-safeTransferFrom}.
1806      */
1807     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1808         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1809         _safeTransfer(from, to, tokenId, _data);
1810     }
1811 
1812     /**
1813      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1814      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1815      *
1816      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1817      *
1818      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1819      * implement alternative mechanisms to perform token transfer, such as signature-based.
1820      *
1821      * Requirements:
1822      *
1823      * - `from` cannot be the zero address.
1824      * - `to` cannot be the zero address.
1825      * - `tokenId` token must exist and be owned by `from`.
1826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1827      *
1828      * Emits a {Transfer} event.
1829      */
1830     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1831         _transfer(from, to, tokenId);
1832         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1833     }
1834 
1835     /**
1836      * @dev Returns whether `tokenId` exists.
1837      *
1838      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1839      *
1840      * Tokens start existing when they are minted (`_mint`),
1841      * and stop existing when they are burned (`_burn`).
1842      */
1843     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1844         return _tokenOwners.contains(tokenId);
1845     }
1846 
1847     /**
1848      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1849      *
1850      * Requirements:
1851      *
1852      * - `tokenId` must exist.
1853      */
1854     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1855         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1856         address owner = ERC721.ownerOf(tokenId);
1857         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1858     }
1859 
1860     /**
1861      * @dev Safely mints `tokenId` and transfers it to `to`.
1862      *
1863      * Requirements:
1864      d*
1865      * - `tokenId` must not exist.
1866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1867      *
1868      * Emits a {Transfer} event.
1869      */
1870     function _safeMint(address to, uint256 tokenId) internal virtual {
1871         _safeMint(to, tokenId, "");
1872     }
1873 
1874     /**
1875      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1876      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1877      */
1878     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1879         _mint(to, tokenId);
1880         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1881     }
1882 
1883     /**
1884      * @dev Mints `tokenId` and transfers it to `to`.
1885      *
1886      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1887      *
1888      * Requirements:
1889      *
1890      * - `tokenId` must not exist.
1891      * - `to` cannot be the zero address.
1892      *
1893      * Emits a {Transfer} event.
1894      */
1895     function _mint(address to, uint256 tokenId) internal virtual {
1896         require(to != address(0), "ERC721: mint to the zero address");
1897         require(!_exists(tokenId), "ERC721: token already minted");
1898 
1899         _beforeTokenTransfer(address(0), to, tokenId);
1900 
1901         _holderTokens[to].add(tokenId);
1902 
1903         _tokenOwners.set(tokenId, to);
1904 
1905         emit Transfer(address(0), to, tokenId);
1906     }
1907 
1908     /**
1909      * @dev Destroys `tokenId`.
1910      * The approval is cleared when the token is burned.
1911      *
1912      * Requirements:
1913      *
1914      * - `tokenId` must exist.
1915      *
1916      * Emits a {Transfer} event.
1917      */
1918     function _burn(uint256 tokenId) internal virtual {
1919         address owner = ERC721.ownerOf(tokenId); // internal owner
1920 
1921         _beforeTokenTransfer(owner, address(0), tokenId);
1922 
1923         // Clear approvals
1924         _approve(address(0), tokenId);
1925 
1926         // Clear metadata (if any)
1927         if (bytes(_tokenURIs[tokenId]).length != 0) {
1928             delete _tokenURIs[tokenId];
1929         }
1930 
1931         _holderTokens[owner].remove(tokenId);
1932 
1933         _tokenOwners.remove(tokenId);
1934 
1935         emit Transfer(owner, address(0), tokenId);
1936     }
1937 
1938     /**
1939      * @dev Transfers `tokenId` from `from` to `to`.
1940      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1941      *
1942      * Requirements:
1943      *
1944      * - `to` cannot be the zero address.
1945      * - `tokenId` token must be owned by `from`.
1946      *
1947      * Emits a {Transfer} event.
1948      */
1949     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1950         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1951         require(to != address(0), "ERC721: transfer to the zero address");
1952 
1953         _beforeTokenTransfer(from, to, tokenId);
1954 
1955         // Clear approvals from the previous owner
1956         _approve(address(0), tokenId);
1957 
1958         _holderTokens[from].remove(tokenId);
1959         _holderTokens[to].add(tokenId);
1960 
1961         _tokenOwners.set(tokenId, to);
1962 
1963         emit Transfer(from, to, tokenId);
1964     }
1965 
1966     /**
1967      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1968      *
1969      * Requirements:
1970      *
1971      * - `tokenId` must exist.
1972      */
1973     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1974         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1975         _tokenURIs[tokenId] = _tokenURI;
1976     }
1977 
1978     /**
1979      * @dev Internal function to set the base URI for all token IDs. It is
1980      * automatically added as a prefix to the value returned in {tokenURI},
1981      * or to the token ID if {tokenURI} is empty.
1982      */
1983     function _setBaseURI(string memory baseURI_) internal virtual {
1984         _baseURI = baseURI_;
1985     }
1986 
1987     /**
1988      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1989      * The call is not executed if the target address is not a contract.
1990      *
1991      * @param from address representing the previous owner of the given token ID
1992      * @param to target address that will receive the tokens
1993      * @param tokenId uint256 ID of the token to be transferred
1994      * @param _data bytes optional data to send along with the call
1995      * @return bool whether the call correctly returned the expected magic value
1996      */
1997     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1998         private returns (bool)
1999     {
2000         if (!to.isContract()) {
2001             return true;
2002         }
2003         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2004             IERC721Receiver(to).onERC721Received.selector,
2005             _msgSender(),
2006             from,
2007             tokenId,
2008             _data
2009         ), "ERC721: transfer to non ERC721Receiver implementer");
2010         bytes4 retval = abi.decode(returndata, (bytes4));
2011         return (retval == _ERC721_RECEIVED);
2012     }
2013 
2014     function _approve(address to, uint256 tokenId) private {
2015         _tokenApprovals[tokenId] = to;
2016         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2017     }
2018 
2019     /**
2020      * @dev Hook that is called before any token transfer. This includes minting
2021      * and burning.
2022      *
2023      * Calling conditions:
2024      *
2025      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2026      * transferred to `to`.
2027      * - When `from` is zero, `tokenId` will be minted for `to`.
2028      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2029      * - `from` cannot be the zero address.
2030      * - `to` cannot be the zero address.
2031      *
2032      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2033      */
2034     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2035 }
2036 
2037 // File: contracts/CryptoFlyz.sol
2038                                                                              
2039 /*                                       @@@@@@@@@@@@@@@@@@@@@@                    
2040                                     @@@@       @@@@@@@@@@@@@@@@@@@@             
2041                                   @@@@       @@@@           ***  @@@@           
2042                                /@@@@       @@@@             ***    @@           
2043                                /@@      @@@@@               ***    @@           
2044                            @@@@@@@@@@@@@@@@@@               ***    @@           
2045                        @@@@@@              @@@@@@**.      **       @@           
2046                        @@                      @@@@#******       @@@@           
2047                   @@@@@                          @@@@@@@@@@@@@@                 
2048                   @@   @@       @@             @@@@/      @@@@@                 
2049                   @@                       @@@@@@           @@@@@               
2050                   @@@@@             @@@@@@@@@@@             @@@@@               
2051                     @@@@@         @@@@                    @@@@@                 
2052                        @@@@@@@@@@@@@@@@@@@@@@@@    /@@@@@@@@                    
2053                     @@@@@@@       @@@@@@@@@  @@@@@@@@@  @@                      
2054               @@@@@@@@@    @@@@@@@@@         @@         @@                      
2055          @@@@@         @@@@                    @@@@@@@    @@@@@@@      */       
2056                                                            
2057 pragma solidity >=0.6.0 <0.8.0;
2058 interface nftInterface {
2059     function ownerOf(uint256 tokenId) external view returns (address owner);
2060     function balanceOf(address owner) external view virtual returns (uint256);
2061     function tokenOfOwnerByIndex(address owner, uint256 index) external view virtual returns (uint256);
2062 }
2063 
2064 pragma solidity >=0.6.0 <0.8.0;
2065 
2066 /**
2067  * @title CryptoFlyz contract
2068  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2069  */
2070 contract CryptoFlyz is ERC721, Ownable, PaymentSplitter {
2071 
2072     bool public mintIsActive = true;
2073     uint256 public tokenPrice = 0;
2074     uint256 public publicTokenPrice = 42000000000000000;
2075     uint256 public constant maxTokens = 7025;
2076     uint256 public constant maxMintsPerTx = 10;
2077     string private _contractURI;
2078     uint256 public tokenCount=1;
2079     bool public devMintLocked = false;
2080     bool private initialized = false;
2081     bool public publicMintLocked = true;
2082 
2083     //Parent NFT Contract
2084     //mainnet address
2085 	address public nftAddress = 0x1CB1A5e65610AEFF2551A50f76a87a7d3fB649C6;
2086 	//rinkeby address
2087 	//address public nftAddress = 0x70BC4cCb9bC9eF1B7E9dc465a38EEbc5d73740FB;
2088     nftInterface nftContract = nftInterface(nftAddress);
2089 
2090     constructor() public ERC721("CryptoFlyz", "FLYZ") {}
2091 
2092     function initializePaymentSplitter (address[] memory payees, uint256[] memory shares_) external onlyOwner {
2093         require (!initialized, "Payment Split Already Initialized!");
2094         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2095         require(payees.length > 0, "PaymentSplitter: no payees");
2096 
2097         for (uint256 i = 0; i < payees.length; i++) {
2098             _addPayee(payees[i], shares_[i]);
2099         }
2100         initialized=true;
2101     }
2102 
2103     //Set Base URI
2104     function setBaseURI(string memory _baseURI) external onlyOwner {
2105         _setBaseURI(_baseURI);
2106     }
2107 
2108     function flipMintState() public onlyOwner {
2109         mintIsActive = !mintIsActive;
2110     }
2111 
2112     function setContractURI(string memory contractURI_) external onlyOwner {
2113         _contractURI = contractURI_;
2114     }
2115 
2116     function contractURI() public view returns (string memory) {
2117         return _contractURI;
2118     }
2119 
2120     //Private sale minting (reserved for Toadz)
2121     function mintWithToad(uint256 nftId) external {
2122         require(mintIsActive, "CryptoFlyz must be active to mint");
2123         require(tokenCount - 1 + 1 <= maxTokens, "Minting would exceed supply");
2124         require(nftContract.ownerOf(nftId) == msg.sender, "Not the owner of this Toad");
2125         if (nftId >= 1000000) {
2126             uint256 newID = SafeMath.div(nftId, 1000000);
2127             newID = SafeMath.add(newID, 6969);
2128             require(!_exists(newID), "This Toad has already been used.");
2129             _safeMint(msg.sender, newID);
2130             tokenCount++;
2131         } else {
2132             require(!_exists(nftId), "This Toad has already been used.");
2133             _safeMint(msg.sender, nftId);
2134             tokenCount++;
2135         }
2136     }
2137 
2138     function multiMintWithnft(uint256 [] memory nftIds) public {
2139         require(mintIsActive, "CryptoFlyz must be active to mint");
2140         for (uint i=0; i< nftIds.length; i++) {
2141             require(nftContract.ownerOf(nftIds[i]) == msg.sender, "Not the owner of this Toad");
2142             if (nftIds[i] >= 1000000) {
2143                 uint256 newID = SafeMath.div(nftIds[i], 1000000);
2144                 newID = SafeMath.add(newID, 6969);
2145                 if(_exists(newID)) {
2146                     continue;
2147                 } else {
2148                     _mint(msg.sender, newID);
2149                     tokenCount++;
2150                 }
2151             } else {
2152                 if(_exists(nftIds[i])) {
2153                     continue;
2154                 } else {
2155                     _mint(msg.sender, nftIds[i]);
2156                     tokenCount++;
2157                 }
2158             }
2159         }
2160     }
2161 
2162     function mintAllToadz() external {
2163         require(mintIsActive, "CryptoFlyz must be active to mint");
2164         uint256 balance = nftContract.balanceOf(msg.sender);
2165         uint256 [] storage lot;
2166         for (uint i = 0; i < balance; i++) {
2167             lot.push(nftContract.tokenOfOwnerByIndex(msg.sender, i));
2168         }
2169         multiMintWithnft(lot);
2170     }
2171 
2172     //Dev mint special tokens
2173     function mintSpecial(uint256 [] memory specialId) external onlyOwner {        
2174         require (!devMintLocked, "Dev Mint Permanently Locked");
2175         for (uint256 i = 0; i < specialId.length; i++) {
2176             require (specialId[i]!=0);
2177             _mint(msg.sender,specialId[i]);
2178         }
2179     }
2180 
2181     function lockDevMint() public onlyOwner {
2182         devMintLocked = true;
2183     }
2184 
2185     function unlockPublicMint() public onlyOwner {
2186         publicMintLocked = false;
2187     }
2188 
2189     function updatePublicPrice(uint256 newPrice) public onlyOwner {
2190         publicTokenPrice = newPrice;
2191     }
2192 
2193     function mintPublic(uint256 quantity) external payable {
2194         require(quantity <= maxMintsPerTx, "trying to mint too many at a time!");
2195         require(tokenCount - 1 + quantity <= maxTokens, "minting this many would exceed supply");
2196         require(msg.value >= publicTokenPrice * quantity, "not enough ether sent!");
2197         require(msg.sender == tx.origin, "no contracts please!");
2198         require(!publicMintLocked, "minting is not open to the public yet!");
2199 
2200         uint256 i = 0;
2201         for (uint256 j = 1; j < maxTokens + 1; j++) {
2202             if (i == quantity) {
2203                 break;
2204             }
2205             else {
2206                 if (!_exists(j) && i < quantity) {
2207                     _safeMint(msg.sender, j);
2208                     i++;
2209                     tokenCount++;
2210                 }
2211             }
2212         }
2213     }
2214     
2215     function multiMintPublic(uint256 [] memory nftIds, uint256 quantity) external payable {
2216         require(quantity <= maxMintsPerTx, "trying to mint too many at a time!");
2217         require(tokenCount - 1 + quantity <= maxTokens, "minting this many would exceed supply");
2218         require(msg.value >= publicTokenPrice * quantity, "not enough ether sent!");
2219         require(msg.sender == tx.origin, "no contracts please!");
2220         require(!publicMintLocked, "minting is not open to the public yet!");
2221         for (uint i=0; i< nftIds.length; i++) {
2222             if (nftIds[i] >= 1000000) {
2223                 uint256 newID = SafeMath.div(nftIds[i], 1000000);
2224                 newID = SafeMath.add(newID, 6969);
2225                 if(_exists(newID)) {
2226                     continue;
2227                 } else {
2228                     _safeMint(msg.sender, newID);
2229                     tokenCount++;
2230                 }
2231             } else {
2232                 if(_exists(nftIds[i])) {
2233                     continue;
2234                 } else {
2235                     _safeMint(msg.sender, nftIds[i]);
2236                     tokenCount++;
2237                 }
2238             }
2239         }
2240     }
2241 
2242 }