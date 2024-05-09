1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/Strings.sol
2 
3 
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
31             buffer[index--] = byte(uint8(48 + temp % 10));
32             temp /= 10;
33         }
34         return string(buffer);
35     }
36 }
37 
38 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/EnumerableMap.sol
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
186      * @dev Returns the value associated with `key`.  O(1).
187      *
188      * Requirements:
189      *
190      * - `key` must be in the map.
191      */
192     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
193         return _get(map, key, "EnumerableMap: nonexistent key");
194     }
195 
196     /**
197      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
198      */
199     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
200         uint256 keyIndex = map._indexes[key];
201         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
202         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
203     }
204 
205     // UintToAddressMap
206 
207     struct UintToAddressMap {
208         Map _inner;
209     }
210 
211     /**
212      * @dev Adds a key-value pair to a map, or updates the value for an existing
213      * key. O(1).
214      *
215      * Returns true if the key was added to the map, that is if it was not
216      * already present.
217      */
218     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
219         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
220     }
221 
222     /**
223      * @dev Removes a value from a set. O(1).
224      *
225      * Returns true if the key was removed from the map, that is if it was present.
226      */
227     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
228         return _remove(map._inner, bytes32(key));
229     }
230 
231     /**
232      * @dev Returns true if the key is in the map. O(1).
233      */
234     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
235         return _contains(map._inner, bytes32(key));
236     }
237 
238     /**
239      * @dev Returns the number of elements in the map. O(1).
240      */
241     function length(UintToAddressMap storage map) internal view returns (uint256) {
242         return _length(map._inner);
243     }
244 
245    /**
246     * @dev Returns the element stored at position `index` in the set. O(1).
247     * Note that there are no guarantees on the ordering of values inside the
248     * array, and it may change when more values are added or removed.
249     *
250     * Requirements:
251     *
252     * - `index` must be strictly less than {length}.
253     */
254     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
255         (bytes32 key, bytes32 value) = _at(map._inner, index);
256         return (uint256(key), address(uint256(value)));
257     }
258 
259     /**
260      * @dev Returns the value associated with `key`.  O(1).
261      *
262      * Requirements:
263      *
264      * - `key` must be in the map.
265      */
266     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
267         return address(uint256(_get(map._inner, bytes32(key))));
268     }
269 
270     /**
271      * @dev Same as {get}, with a custom error message when `key` is not in the map.
272      */
273     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
274         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
275     }
276 }
277 
278 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/EnumerableSet.sol
279 
280 
281 
282 pragma solidity >=0.6.0 <0.8.0;
283 
284 /**
285  * @dev Library for managing
286  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
287  * types.
288  *
289  * Sets have the following properties:
290  *
291  * - Elements are added, removed, and checked for existence in constant time
292  * (O(1)).
293  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
294  *
295  * ```
296  * contract Example {
297  *     // Add the library methods
298  *     using EnumerableSet for EnumerableSet.AddressSet;
299  *
300  *     // Declare a set state variable
301  *     EnumerableSet.AddressSet private mySet;
302  * }
303  * ```
304  *
305  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
306  * and `uint256` (`UintSet`) are supported.
307  */
308 library EnumerableSet {
309     // To implement this library for multiple types with as little code
310     // repetition as possible, we write it in terms of a generic Set type with
311     // bytes32 values.
312     // The Set implementation uses private functions, and user-facing
313     // implementations (such as AddressSet) are just wrappers around the
314     // underlying Set.
315     // This means that we can only create new EnumerableSets for types that fit
316     // in bytes32.
317 
318     struct Set {
319         // Storage of set values
320         bytes32[] _values;
321 
322         // Position of the value in the `values` array, plus 1 because index 0
323         // means a value is not in the set.
324         mapping (bytes32 => uint256) _indexes;
325     }
326 
327     /**
328      * @dev Add a value to a set. O(1).
329      *
330      * Returns true if the value was added to the set, that is if it was not
331      * already present.
332      */
333     function _add(Set storage set, bytes32 value) private returns (bool) {
334         if (!_contains(set, value)) {
335             set._values.push(value);
336             // The value is stored at length-1, but we add 1 to all indexes
337             // and use 0 as a sentinel value
338             set._indexes[value] = set._values.length;
339             return true;
340         } else {
341             return false;
342         }
343     }
344 
345     /**
346      * @dev Removes a value from a set. O(1).
347      *
348      * Returns true if the value was removed from the set, that is if it was
349      * present.
350      */
351     function _remove(Set storage set, bytes32 value) private returns (bool) {
352         // We read and store the value's index to prevent multiple reads from the same storage slot
353         uint256 valueIndex = set._indexes[value];
354 
355         if (valueIndex != 0) { // Equivalent to contains(set, value)
356             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
357             // the array, and then remove the last element (sometimes called as 'swap and pop').
358             // This modifies the order of the array, as noted in {at}.
359 
360             uint256 toDeleteIndex = valueIndex - 1;
361             uint256 lastIndex = set._values.length - 1;
362 
363             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
364             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
365 
366             bytes32 lastvalue = set._values[lastIndex];
367 
368             // Move the last value to the index where the value to delete is
369             set._values[toDeleteIndex] = lastvalue;
370             // Update the index for the moved value
371             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
372 
373             // Delete the slot where the moved value was stored
374             set._values.pop();
375 
376             // Delete the index for the deleted slot
377             delete set._indexes[value];
378 
379             return true;
380         } else {
381             return false;
382         }
383     }
384 
385     /**
386      * @dev Returns true if the value is in the set. O(1).
387      */
388     function _contains(Set storage set, bytes32 value) private view returns (bool) {
389         return set._indexes[value] != 0;
390     }
391 
392     /**
393      * @dev Returns the number of values on the set. O(1).
394      */
395     function _length(Set storage set) private view returns (uint256) {
396         return set._values.length;
397     }
398 
399    /**
400     * @dev Returns the value stored at position `index` in the set. O(1).
401     *
402     * Note that there are no guarantees on the ordering of values inside the
403     * array, and it may change when more values are added or removed.
404     *
405     * Requirements:
406     *
407     * - `index` must be strictly less than {length}.
408     */
409     function _at(Set storage set, uint256 index) private view returns (bytes32) {
410         require(set._values.length > index, "EnumerableSet: index out of bounds");
411         return set._values[index];
412     }
413 
414     // Bytes32Set
415 
416     struct Bytes32Set {
417         Set _inner;
418     }
419 
420     /**
421      * @dev Add a value to a set. O(1).
422      *
423      * Returns true if the value was added to the set, that is if it was not
424      * already present.
425      */
426     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
427         return _add(set._inner, value);
428     }
429 
430     /**
431      * @dev Removes a value from a set. O(1).
432      *
433      * Returns true if the value was removed from the set, that is if it was
434      * present.
435      */
436     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
437         return _remove(set._inner, value);
438     }
439 
440     /**
441      * @dev Returns true if the value is in the set. O(1).
442      */
443     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
444         return _contains(set._inner, value);
445     }
446 
447     /**
448      * @dev Returns the number of values in the set. O(1).
449      */
450     function length(Bytes32Set storage set) internal view returns (uint256) {
451         return _length(set._inner);
452     }
453 
454    /**
455     * @dev Returns the value stored at position `index` in the set. O(1).
456     *
457     * Note that there are no guarantees on the ordering of values inside the
458     * array, and it may change when more values are added or removed.
459     *
460     * Requirements:
461     *
462     * - `index` must be strictly less than {length}.
463     */
464     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
465         return _at(set._inner, index);
466     }
467 
468     // AddressSet
469 
470     struct AddressSet {
471         Set _inner;
472     }
473 
474     /**
475      * @dev Add a value to a set. O(1).
476      *
477      * Returns true if the value was added to the set, that is if it was not
478      * already present.
479      */
480     function add(AddressSet storage set, address value) internal returns (bool) {
481         return _add(set._inner, bytes32(uint256(value)));
482     }
483 
484     /**
485      * @dev Removes a value from a set. O(1).
486      *
487      * Returns true if the value was removed from the set, that is if it was
488      * present.
489      */
490     function remove(AddressSet storage set, address value) internal returns (bool) {
491         return _remove(set._inner, bytes32(uint256(value)));
492     }
493 
494     /**
495      * @dev Returns true if the value is in the set. O(1).
496      */
497     function contains(AddressSet storage set, address value) internal view returns (bool) {
498         return _contains(set._inner, bytes32(uint256(value)));
499     }
500 
501     /**
502      * @dev Returns the number of values in the set. O(1).
503      */
504     function length(AddressSet storage set) internal view returns (uint256) {
505         return _length(set._inner);
506     }
507 
508    /**
509     * @dev Returns the value stored at position `index` in the set. O(1).
510     *
511     * Note that there are no guarantees on the ordering of values inside the
512     * array, and it may change when more values are added or removed.
513     *
514     * Requirements:
515     *
516     * - `index` must be strictly less than {length}.
517     */
518     function at(AddressSet storage set, uint256 index) internal view returns (address) {
519         return address(uint256(_at(set._inner, index)));
520     }
521 
522 
523     // UintSet
524 
525     struct UintSet {
526         Set _inner;
527     }
528 
529     /**
530      * @dev Add a value to a set. O(1).
531      *
532      * Returns true if the value was added to the set, that is if it was not
533      * already present.
534      */
535     function add(UintSet storage set, uint256 value) internal returns (bool) {
536         return _add(set._inner, bytes32(value));
537     }
538 
539     /**
540      * @dev Removes a value from a set. O(1).
541      *
542      * Returns true if the value was removed from the set, that is if it was
543      * present.
544      */
545     function remove(UintSet storage set, uint256 value) internal returns (bool) {
546         return _remove(set._inner, bytes32(value));
547     }
548 
549     /**
550      * @dev Returns true if the value is in the set. O(1).
551      */
552     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
553         return _contains(set._inner, bytes32(value));
554     }
555 
556     /**
557      * @dev Returns the number of values on the set. O(1).
558      */
559     function length(UintSet storage set) internal view returns (uint256) {
560         return _length(set._inner);
561     }
562 
563    /**
564     * @dev Returns the value stored at position `index` in the set. O(1).
565     *
566     * Note that there are no guarantees on the ordering of values inside the
567     * array, and it may change when more values are added or removed.
568     *
569     * Requirements:
570     *
571     * - `index` must be strictly less than {length}.
572     */
573     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
574         return uint256(_at(set._inner, index));
575     }
576 }
577 
578 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/Address.sol
579 
580 
581 
582 pragma solidity >=0.6.2 <0.8.0;
583 
584 /**
585  * @dev Collection of functions related to the address type
586  */
587 library Address {
588     /**
589      * @dev Returns true if `account` is a contract.
590      *
591      * [IMPORTANT]
592      * ====
593      * It is unsafe to assume that an address for which this function returns
594      * false is an externally-owned account (EOA) and not a contract.
595      *
596      * Among others, `isContract` will return false for the following
597      * types of addresses:
598      *
599      *  - an externally-owned account
600      *  - a contract in construction
601      *  - an address where a contract will be created
602      *  - an address where a contract lived, but was destroyed
603      * ====
604      */
605     function isContract(address account) internal view returns (bool) {
606         // This method relies on extcodesize, which returns 0 for contracts in
607         // construction, since the code is only stored at the end of the
608         // constructor execution.
609 
610         uint256 size;
611         // solhint-disable-next-line no-inline-assembly
612         assembly { size := extcodesize(account) }
613         return size > 0;
614     }
615 
616     /**
617      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
618      * `recipient`, forwarding all available gas and reverting on errors.
619      *
620      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
621      * of certain opcodes, possibly making contracts go over the 2300 gas limit
622      * imposed by `transfer`, making them unable to receive funds via
623      * `transfer`. {sendValue} removes this limitation.
624      *
625      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
626      *
627      * IMPORTANT: because control is transferred to `recipient`, care must be
628      * taken to not create reentrancy vulnerabilities. Consider using
629      * {ReentrancyGuard} or the
630      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
631      */
632     function sendValue(address payable recipient, uint256 amount) internal {
633         require(address(this).balance >= amount, "Address: insufficient balance");
634 
635         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
636         (bool success, ) = recipient.call{ value: amount }("");
637         require(success, "Address: unable to send value, recipient may have reverted");
638     }
639 
640     /**
641      * @dev Performs a Solidity function call using a low level `call`. A
642      * plain`call` is an unsafe replacement for a function call: use this
643      * function instead.
644      *
645      * If `target` reverts with a revert reason, it is bubbled up by this
646      * function (like regular Solidity function calls).
647      *
648      * Returns the raw returned data. To convert to the expected return value,
649      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
650      *
651      * Requirements:
652      *
653      * - `target` must be a contract.
654      * - calling `target` with `data` must not revert.
655      *
656      * _Available since v3.1._
657      */
658     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
659       return functionCall(target, data, "Address: low-level call failed");
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
664      * `errorMessage` as a fallback revert reason when `target` reverts.
665      *
666      * _Available since v3.1._
667      */
668     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
669         return functionCallWithValue(target, data, 0, errorMessage);
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
674      * but also transferring `value` wei to `target`.
675      *
676      * Requirements:
677      *
678      * - the calling contract must have an ETH balance of at least `value`.
679      * - the called Solidity function must be `payable`.
680      *
681      * _Available since v3.1._
682      */
683     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
684         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
689      * with `errorMessage` as a fallback revert reason when `target` reverts.
690      *
691      * _Available since v3.1._
692      */
693     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
694         require(address(this).balance >= value, "Address: insufficient balance for call");
695         require(isContract(target), "Address: call to non-contract");
696 
697         // solhint-disable-next-line avoid-low-level-calls
698         (bool success, bytes memory returndata) = target.call{ value: value }(data);
699         return _verifyCallResult(success, returndata, errorMessage);
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
704      * but performing a static call.
705      *
706      * _Available since v3.3._
707      */
708     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
709         return functionStaticCall(target, data, "Address: low-level static call failed");
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
714      * but performing a static call.
715      *
716      * _Available since v3.3._
717      */
718     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
719         require(isContract(target), "Address: static call to non-contract");
720 
721         // solhint-disable-next-line avoid-low-level-calls
722         (bool success, bytes memory returndata) = target.staticcall(data);
723         return _verifyCallResult(success, returndata, errorMessage);
724     }
725 
726     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
727         if (success) {
728             return returndata;
729         } else {
730             // Look for revert reason and bubble it up if present
731             if (returndata.length > 0) {
732                 // The easiest way to bubble the revert reason is using memory via assembly
733 
734                 // solhint-disable-next-line no-inline-assembly
735                 assembly {
736                     let returndata_size := mload(returndata)
737                     revert(add(32, returndata), returndata_size)
738                 }
739             } else {
740                 revert(errorMessage);
741             }
742         }
743     }
744 }
745 
746 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/SafeMath.sol
747 
748 
749 
750 pragma solidity >=0.6.0 <0.8.0;
751 
752 /**
753  * @dev Wrappers over Solidity's arithmetic operations with added overflow
754  * checks.
755  *
756  * Arithmetic operations in Solidity wrap on overflow. This can easily result
757  * in bugs, because programmers usually assume that an overflow raises an
758  * error, which is the standard behavior in high level programming languages.
759  * `SafeMath` restores this intuition by reverting the transaction when an
760  * operation overflows.
761  *
762  * Using this library instead of the unchecked operations eliminates an entire
763  * class of bugs, so it's recommended to use it always.
764  */
765 library SafeMath {
766     /**
767      * @dev Returns the addition of two unsigned integers, reverting on
768      * overflow.
769      *
770      * Counterpart to Solidity's `+` operator.
771      *
772      * Requirements:
773      *
774      * - Addition cannot overflow.
775      */
776     function add(uint256 a, uint256 b) internal pure returns (uint256) {
777         uint256 c = a + b;
778         require(c >= a, "SafeMath: addition overflow");
779 
780         return c;
781     }
782 
783     /**
784      * @dev Returns the subtraction of two unsigned integers, reverting on
785      * overflow (when the result is negative).
786      *
787      * Counterpart to Solidity's `-` operator.
788      *
789      * Requirements:
790      *
791      * - Subtraction cannot overflow.
792      */
793     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
794         return sub(a, b, "SafeMath: subtraction overflow");
795     }
796 
797     /**
798      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
799      * overflow (when the result is negative).
800      *
801      * Counterpart to Solidity's `-` operator.
802      *
803      * Requirements:
804      *
805      * - Subtraction cannot overflow.
806      */
807     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
808         require(b <= a, errorMessage);
809         uint256 c = a - b;
810 
811         return c;
812     }
813 
814     /**
815      * @dev Returns the multiplication of two unsigned integers, reverting on
816      * overflow.
817      *
818      * Counterpart to Solidity's `*` operator.
819      *
820      * Requirements:
821      *
822      * - Multiplication cannot overflow.
823      */
824     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
825         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
826         // benefit is lost if 'b' is also tested.
827         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
828         if (a == 0) {
829             return 0;
830         }
831 
832         uint256 c = a * b;
833         require(c / a == b, "SafeMath: multiplication overflow");
834 
835         return c;
836     }
837 
838     /**
839      * @dev Returns the integer division of two unsigned integers. Reverts on
840      * division by zero. The result is rounded towards zero.
841      *
842      * Counterpart to Solidity's `/` operator. Note: this function uses a
843      * `revert` opcode (which leaves remaining gas untouched) while Solidity
844      * uses an invalid opcode to revert (consuming all remaining gas).
845      *
846      * Requirements:
847      *
848      * - The divisor cannot be zero.
849      */
850     function div(uint256 a, uint256 b) internal pure returns (uint256) {
851         return div(a, b, "SafeMath: division by zero");
852     }
853 
854     /**
855      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
856      * division by zero. The result is rounded towards zero.
857      *
858      * Counterpart to Solidity's `/` operator. Note: this function uses a
859      * `revert` opcode (which leaves remaining gas untouched) while Solidity
860      * uses an invalid opcode to revert (consuming all remaining gas).
861      *
862      * Requirements:
863      *
864      * - The divisor cannot be zero.
865      */
866     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
867         require(b > 0, errorMessage);
868         uint256 c = a / b;
869         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
870 
871         return c;
872     }
873 
874     /**
875      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
876      * Reverts when dividing by zero.
877      *
878      * Counterpart to Solidity's `%` operator. This function uses a `revert`
879      * opcode (which leaves remaining gas untouched) while Solidity uses an
880      * invalid opcode to revert (consuming all remaining gas).
881      *
882      * Requirements:
883      *
884      * - The divisor cannot be zero.
885      */
886     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
887         return mod(a, b, "SafeMath: modulo by zero");
888     }
889 
890     /**
891      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
892      * Reverts with custom message when dividing by zero.
893      *
894      * Counterpart to Solidity's `%` operator. This function uses a `revert`
895      * opcode (which leaves remaining gas untouched) while Solidity uses an
896      * invalid opcode to revert (consuming all remaining gas).
897      *
898      * Requirements:
899      *
900      * - The divisor cannot be zero.
901      */
902     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
903         require(b != 0, errorMessage);
904         return a % b;
905     }
906 }
907 
908 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC721/IERC721Receiver.sol
909 
910 
911 
912 pragma solidity >=0.6.0 <0.8.0;
913 
914 /**
915  * @title ERC721 token receiver interface
916  * @dev Interface for any contract that wants to support safeTransfers
917  * from ERC721 asset contracts.
918  */
919 interface IERC721Receiver {
920     /**
921      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
922      * by `operator` from `from`, this function is called.
923      *
924      * It must return its Solidity selector to confirm the token transfer.
925      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
926      *
927      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
928      */
929     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
930 }
931 
932 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/introspection/IERC165.sol
933 
934 
935 
936 pragma solidity >=0.6.0 <0.8.0;
937 
938 /**
939  * @dev Interface of the ERC165 standard, as defined in the
940  * https://eips.ethereum.org/EIPS/eip-165[EIP].
941  *
942  * Implementers can declare support of contract interfaces, which can then be
943  * queried by others ({ERC165Checker}).
944  *
945  * For an implementation, see {ERC165}.
946  */
947 interface IERC165 {
948     /**
949      * @dev Returns true if this contract implements the interface defined by
950      * `interfaceId`. See the corresponding
951      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
952      * to learn more about how these ids are created.
953      *
954      * This function call must use less than 30 000 gas.
955      */
956     function supportsInterface(bytes4 interfaceId) external view returns (bool);
957 }
958 
959 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/introspection/ERC165.sol
960 
961 
962 
963 pragma solidity >=0.6.0 <0.8.0;
964 
965 
966 /**
967  * @dev Implementation of the {IERC165} interface.
968  *
969  * Contracts may inherit from this and call {_registerInterface} to declare
970  * their support of an interface.
971  */
972 abstract contract ERC165 is IERC165 {
973     /*
974      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
975      */
976     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
977 
978     /**
979      * @dev Mapping of interface ids to whether or not it's supported.
980      */
981     mapping(bytes4 => bool) private _supportedInterfaces;
982 
983     constructor () internal {
984         // Derived contracts need only register support for their own interfaces,
985         // we register support for ERC165 itself here
986         _registerInterface(_INTERFACE_ID_ERC165);
987     }
988 
989     /**
990      * @dev See {IERC165-supportsInterface}.
991      *
992      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
993      */
994     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
995         return _supportedInterfaces[interfaceId];
996     }
997 
998     /**
999      * @dev Registers the contract as an implementer of the interface defined by
1000      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1001      * registering its interface id is not required.
1002      *
1003      * See {IERC165-supportsInterface}.
1004      *
1005      * Requirements:
1006      *
1007      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1008      */
1009     function _registerInterface(bytes4 interfaceId) internal virtual {
1010         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1011         _supportedInterfaces[interfaceId] = true;
1012     }
1013 }
1014 
1015 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC721/IERC721.sol
1016 
1017 
1018 
1019 pragma solidity >=0.6.2 <0.8.0;
1020 
1021 
1022 /**
1023  * @dev Required interface of an ERC721 compliant contract.
1024  */
1025 interface IERC721 is IERC165 {
1026     /**
1027      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1028      */
1029     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1030 
1031     /**
1032      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1033      */
1034     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1035 
1036     /**
1037      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1038      */
1039     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1040 
1041     /**
1042      * @dev Returns the number of tokens in ``owner``'s account.
1043      */
1044     function balanceOf(address owner) external view returns (uint256 balance);
1045 
1046     /**
1047      * @dev Returns the owner of the `tokenId` token.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      */
1053     function ownerOf(uint256 tokenId) external view returns (address owner);
1054 
1055     /**
1056      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1057      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1058      *
1059      * Requirements:
1060      *
1061      * - `from` cannot be the zero address.
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must exist and be owned by `from`.
1064      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1065      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1070 
1071     /**
1072      * @dev Transfers `tokenId` token from `from` to `to`.
1073      *
1074      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1075      *
1076      * Requirements:
1077      *
1078      * - `from` cannot be the zero address.
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must be owned by `from`.
1081      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function transferFrom(address from, address to, uint256 tokenId) external;
1086 
1087     /**
1088      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1089      * The approval is cleared when the token is transferred.
1090      *
1091      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1092      *
1093      * Requirements:
1094      *
1095      * - The caller must own the token or be an approved operator.
1096      * - `tokenId` must exist.
1097      *
1098      * Emits an {Approval} event.
1099      */
1100     function approve(address to, uint256 tokenId) external;
1101 
1102     /**
1103      * @dev Returns the account approved for `tokenId` token.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      */
1109     function getApproved(uint256 tokenId) external view returns (address operator);
1110 
1111     /**
1112      * @dev Approve or remove `operator` as an operator for the caller.
1113      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1114      *
1115      * Requirements:
1116      *
1117      * - The `operator` cannot be the caller.
1118      *
1119      * Emits an {ApprovalForAll} event.
1120      */
1121     function setApprovalForAll(address operator, bool _approved) external;
1122 
1123     /**
1124      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1125      *
1126      * See {setApprovalForAll}
1127      */
1128     function isApprovedForAll(address owner, address operator) external view returns (bool);
1129 
1130     /**
1131       * @dev Safely transfers `tokenId` token from `from` to `to`.
1132       *
1133       * Requirements:
1134       *
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137       * - `tokenId` token must exist and be owned by `from`.
1138       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1139       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1140       *
1141       * Emits a {Transfer} event.
1142       */
1143     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1144 }
1145 
1146 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC721/IERC721Enumerable.sol
1147 
1148 
1149 
1150 pragma solidity >=0.6.2 <0.8.0;
1151 
1152 
1153 /**
1154  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1155  * @dev See https://eips.ethereum.org/EIPS/eip-721
1156  */
1157 interface IERC721Enumerable is IERC721 {
1158 
1159     /**
1160      * @dev Returns the total amount of tokens stored by the contract.
1161      */
1162     function totalSupply() external view returns (uint256);
1163 
1164     /**
1165      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1166      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1167      */
1168     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1169 
1170     /**
1171      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1172      * Use along with {totalSupply} to enumerate all tokens.
1173      */
1174     function tokenByIndex(uint256 index) external view returns (uint256);
1175 }
1176 
1177 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC721/IERC721Metadata.sol
1178 
1179 
1180 
1181 pragma solidity >=0.6.2 <0.8.0;
1182 
1183 
1184 /**
1185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1186  * @dev See https://eips.ethereum.org/EIPS/eip-721
1187  */
1188 interface IERC721Metadata is IERC721 {
1189 
1190     /**
1191      * @dev Returns the token collection name.
1192      */
1193     function name() external view returns (string memory);
1194 
1195     /**
1196      * @dev Returns the token collection symbol.
1197      */
1198     function symbol() external view returns (string memory);
1199 
1200     /**
1201      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1202      */
1203     function tokenURI(uint256 tokenId) external view returns (string memory);
1204 }
1205 
1206 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/GSN/Context.sol
1207 
1208 
1209 
1210 pragma solidity >=0.6.0 <0.8.0;
1211 
1212 /*
1213  * @dev Provides information about the current execution context, including the
1214  * sender of the transaction and its data. While these are generally available
1215  * via msg.sender and msg.data, they should not be accessed in such a direct
1216  * manner, since when dealing with GSN meta-transactions the account sending and
1217  * paying for execution may not be the actual sender (as far as an application
1218  * is concerned).
1219  *
1220  * This contract is only required for intermediate, library-like contracts.
1221  */
1222 abstract contract Context {
1223     function _msgSender() internal view virtual returns (address payable) {
1224         return msg.sender;
1225     }
1226 
1227     function _msgData() internal view virtual returns (bytes memory) {
1228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1229         return msg.data;
1230     }
1231 }
1232 
1233 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/access/Ownable.sol
1234 
1235 
1236 
1237 pragma solidity >=0.6.0 <0.8.0;
1238 
1239 /**
1240  * @dev Contract module which provides a basic access control mechanism, where
1241  * there is an account (an owner) that can be granted exclusive access to
1242  * specific functions.
1243  *
1244  * By default, the owner account will be the one that deploys the contract. This
1245  * can later be changed with {transferOwnership}.
1246  *
1247  * This module is used through inheritance. It will make available the modifier
1248  * `onlyOwner`, which can be applied to your functions to restrict their use to
1249  * the owner.
1250  */
1251 abstract contract Ownable is Context {
1252     address private _owner;
1253 
1254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1255 
1256     /**
1257      * @dev Initializes the contract setting the deployer as the initial owner.
1258      */
1259     constructor () internal {
1260         address msgSender = _msgSender();
1261         _owner = msgSender;
1262         emit OwnershipTransferred(address(0), msgSender);
1263     }
1264 
1265     /**
1266      * @dev Returns the address of the current owner.
1267      */
1268     function owner() public view returns (address) {
1269         return _owner;
1270     }
1271 
1272     /**
1273      * @dev Throws if called by any account other than the owner.
1274      */
1275     modifier onlyOwner() {
1276         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1277         _;
1278     }
1279 
1280     /**
1281      * @dev Leaves the contract without owner. It will not be possible to call
1282      * `onlyOwner` functions anymore. Can only be called by the current owner.
1283      *
1284      * NOTE: Renouncing ownership will leave the contract without an owner,
1285      * thereby removing any functionality that is only available to the owner.
1286      */
1287     function renounceOwnership() public virtual onlyOwner {
1288         emit OwnershipTransferred(_owner, address(0));
1289         _owner = address(0);
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Can only be called by the current owner.
1295      */
1296     function transferOwnership(address newOwner) public virtual onlyOwner {
1297         require(newOwner != address(0), "Ownable: new owner is the zero address");
1298         emit OwnershipTransferred(_owner, newOwner);
1299         _owner = newOwner;
1300     }
1301 }
1302 
1303 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC721/ERC721.sol
1304 
1305 
1306 
1307 pragma solidity >=0.6.0 <0.8.0;
1308 
1309 
1310 
1311 
1312 
1313 
1314 
1315 
1316 
1317 
1318 
1319 
1320 /**
1321  * @title ERC721 Non-Fungible Token Standard basic implementation
1322  * @dev see https://eips.ethereum.org/EIPS/eip-721
1323  */
1324 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1325     using SafeMath for uint256;
1326     using Address for address;
1327     using EnumerableSet for EnumerableSet.UintSet;
1328     using EnumerableMap for EnumerableMap.UintToAddressMap;
1329     using Strings for uint256;
1330 
1331     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1332     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1333     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1334 
1335     // Mapping from holder address to their (enumerable) set of owned tokens
1336     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1337 
1338     // Enumerable mapping from token ids to their owners
1339     EnumerableMap.UintToAddressMap private _tokenOwners;
1340 
1341     // Mapping from token ID to approved address
1342     mapping (uint256 => address) private _tokenApprovals;
1343 
1344     // Mapping from owner to operator approvals
1345     mapping (address => mapping (address => bool)) private _operatorApprovals;
1346 
1347     // Token name
1348     string private _name;
1349 
1350     // Token symbol
1351     string private _symbol;
1352 
1353     // Optional mapping for token URIs
1354     mapping (uint256 => string) private _tokenURIs;
1355 
1356     // Base URI
1357     string private _baseURI;
1358 
1359     /*
1360      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1361      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1362      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1363      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1364      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1365      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1366      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1367      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1368      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1369      *
1370      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1371      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1372      */
1373     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1374 
1375     /*
1376      *     bytes4(keccak256('name()')) == 0x06fdde03
1377      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1378      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1379      *
1380      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1381      */
1382     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1383 
1384     /*
1385      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1386      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1387      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1388      *
1389      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1390      */
1391     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1392 
1393     /**
1394      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1395      */
1396     constructor (string memory name_, string memory symbol_) public {
1397         _name = name_;
1398         _symbol = symbol_;
1399 
1400         // register the supported interfaces to conform to ERC721 via ERC165
1401         _registerInterface(_INTERFACE_ID_ERC721);
1402         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1403         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-balanceOf}.
1408      */
1409     function balanceOf(address owner) public view override returns (uint256) {
1410         require(owner != address(0), "ERC721: balance query for the zero address");
1411 
1412         return _holderTokens[owner].length();
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-ownerOf}.
1417      */
1418     function ownerOf(uint256 tokenId) public view override returns (address) {
1419         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1420     }
1421 
1422     /**
1423      * @dev See {IERC721Metadata-name}.
1424      */
1425     function name() public view override returns (string memory) {
1426         return _name;
1427     }
1428 
1429     /**
1430      * @dev See {IERC721Metadata-symbol}.
1431      */
1432     function symbol() public view override returns (string memory) {
1433         return _symbol;
1434     }
1435 
1436     /**
1437      * @dev See {IERC721Metadata-tokenURI}.
1438      */
1439     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1440         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1441 
1442         string memory _tokenURI = _tokenURIs[tokenId];
1443 
1444         // If there is no base URI, return the token URI.
1445         if (bytes(_baseURI).length == 0) {
1446             return _tokenURI;
1447         }
1448         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1449         if (bytes(_tokenURI).length > 0) {
1450             return string(abi.encodePacked(_baseURI, _tokenURI));
1451         }
1452         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1453         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1454     }
1455 
1456     /**
1457     * @dev Returns the base URI set via {_setBaseURI}. This will be
1458     * automatically added as a prefix in {tokenURI} to each token's URI, or
1459     * to the token ID if no specific URI is set for that token ID.
1460     */
1461     function baseURI() public view returns (string memory) {
1462         return _baseURI;
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1467      */
1468     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1469         return _holderTokens[owner].at(index);
1470     }
1471 
1472     /**
1473      * @dev See {IERC721Enumerable-totalSupply}.
1474      */
1475     function totalSupply() public view override returns (uint256) {
1476         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1477         return _tokenOwners.length();
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Enumerable-tokenByIndex}.
1482      */
1483     function tokenByIndex(uint256 index) public view override returns (uint256) {
1484         (uint256 tokenId, ) = _tokenOwners.at(index);
1485         return tokenId;
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-approve}.
1490      */
1491     function approve(address to, uint256 tokenId) public virtual override {
1492         address owner = ownerOf(tokenId);
1493         require(to != owner, "ERC721: approval to current owner");
1494 
1495         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1496             "ERC721: approve caller is not owner nor approved for all"
1497         );
1498 
1499         _approve(to, tokenId);
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-getApproved}.
1504      */
1505     function getApproved(uint256 tokenId) public view override returns (address) {
1506         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1507 
1508         return _tokenApprovals[tokenId];
1509     }
1510 
1511     /**
1512      * @dev See {IERC721-setApprovalForAll}.
1513      */
1514     function setApprovalForAll(address operator, bool approved) public virtual override {
1515         require(operator != _msgSender(), "ERC721: approve to caller");
1516 
1517         _operatorApprovals[_msgSender()][operator] = approved;
1518         emit ApprovalForAll(_msgSender(), operator, approved);
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-isApprovedForAll}.
1523      */
1524     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1525         return _operatorApprovals[owner][operator];
1526     }
1527 
1528     /**
1529      * @dev See {IERC721-transferFrom}.
1530      */
1531     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1532         //solhint-disable-next-line max-line-length
1533         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1534 
1535         _transfer(from, to, tokenId);
1536     }
1537 
1538     /**
1539      * @dev See {IERC721-safeTransferFrom}.
1540      */
1541     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1542         safeTransferFrom(from, to, tokenId, "");
1543     }
1544 
1545     /**
1546      * @dev See {IERC721-safeTransferFrom}.
1547      */
1548     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1549         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1550         _safeTransfer(from, to, tokenId, _data);
1551     }
1552 
1553     /**
1554      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1555      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1556      *
1557      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1558      *
1559      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1560      * implement alternative mechanisms to perform token transfer, such as signature-based.
1561      *
1562      * Requirements:
1563      *
1564      * - `from` cannot be the zero address.
1565      * - `to` cannot be the zero address.
1566      * - `tokenId` token must exist and be owned by `from`.
1567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1568      *
1569      * Emits a {Transfer} event.
1570      */
1571     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1572         _transfer(from, to, tokenId);
1573         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1574     }
1575 
1576     /**
1577      * @dev Returns whether `tokenId` exists.
1578      *
1579      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1580      *
1581      * Tokens start existing when they are minted (`_mint`),
1582      * and stop existing when they are burned (`_burn`).
1583      */
1584     function _exists(uint256 tokenId) internal view returns (bool) {
1585         return _tokenOwners.contains(tokenId);
1586     }
1587 
1588     /**
1589      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1590      *
1591      * Requirements:
1592      *
1593      * - `tokenId` must exist.
1594      */
1595     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1596         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1597         address owner = ownerOf(tokenId);
1598         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1599     }
1600 
1601     /**
1602      * @dev Safely mints `tokenId` and transfers it to `to`.
1603      *
1604      * Requirements:
1605      d*
1606      * - `tokenId` must not exist.
1607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _safeMint(address to, uint256 tokenId) internal virtual {
1612         _safeMint(to, tokenId, "");
1613     }
1614 
1615     /**
1616      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1617      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1618      */
1619     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1620         _mint(to, tokenId);
1621         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1622     }
1623 
1624     /**
1625      * @dev Mints `tokenId` and transfers it to `to`.
1626      *
1627      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1628      *
1629      * Requirements:
1630      *
1631      * - `tokenId` must not exist.
1632      * - `to` cannot be the zero address.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function _mint(address to, uint256 tokenId) internal virtual {
1637         require(to != address(0), "ERC721: mint to the zero address");
1638         require(!_exists(tokenId), "ERC721: token already minted");
1639 
1640         _beforeTokenTransfer(address(0), to, tokenId);
1641 
1642         _holderTokens[to].add(tokenId);
1643 
1644         _tokenOwners.set(tokenId, to);
1645 
1646         emit Transfer(address(0), to, tokenId);
1647     }
1648 
1649     /**
1650      * @dev Destroys `tokenId`.
1651      * The approval is cleared when the token is burned.
1652      *
1653      * Requirements:
1654      *
1655      * - `tokenId` must exist.
1656      *
1657      * Emits a {Transfer} event.
1658      */
1659     function _burn(uint256 tokenId) internal virtual {
1660         address owner = ownerOf(tokenId);
1661 
1662         _beforeTokenTransfer(owner, address(0), tokenId);
1663 
1664         // Clear approvals
1665         _approve(address(0), tokenId);
1666 
1667         // Clear metadata (if any)
1668         if (bytes(_tokenURIs[tokenId]).length != 0) {
1669             delete _tokenURIs[tokenId];
1670         }
1671 
1672         _holderTokens[owner].remove(tokenId);
1673 
1674         _tokenOwners.remove(tokenId);
1675 
1676         emit Transfer(owner, address(0), tokenId);
1677     }
1678 
1679     /**
1680      * @dev Transfers `tokenId` from `from` to `to`.
1681      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1682      *
1683      * Requirements:
1684      *
1685      * - `to` cannot be the zero address.
1686      * - `tokenId` token must be owned by `from`.
1687      *
1688      * Emits a {Transfer} event.
1689      */
1690     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1691         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1692         require(to != address(0), "ERC721: transfer to the zero address");
1693 
1694         _beforeTokenTransfer(from, to, tokenId);
1695 
1696         // Clear approvals from the previous owner
1697         _approve(address(0), tokenId);
1698 
1699         _holderTokens[from].remove(tokenId);
1700         _holderTokens[to].add(tokenId);
1701 
1702         _tokenOwners.set(tokenId, to);
1703 
1704         emit Transfer(from, to, tokenId);
1705     }
1706 
1707     /**
1708      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1709      *
1710      * Requirements:
1711      *
1712      * - `tokenId` must exist.
1713      */
1714     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1715         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1716         _tokenURIs[tokenId] = _tokenURI;
1717     }
1718 
1719     /**
1720      * @dev Internal function to set the base URI for all token IDs. It is
1721      * automatically added as a prefix to the value returned in {tokenURI},
1722      * or to the token ID if {tokenURI} is empty.
1723      */
1724     function _setBaseURI(string memory baseURI_) internal virtual {
1725         _baseURI = baseURI_;
1726     }
1727 
1728     /**
1729      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1730      * The call is not executed if the target address is not a contract.
1731      *
1732      * @param from address representing the previous owner of the given token ID
1733      * @param to target address that will receive the tokens
1734      * @param tokenId uint256 ID of the token to be transferred
1735      * @param _data bytes optional data to send along with the call
1736      * @return bool whether the call correctly returned the expected magic value
1737      */
1738     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1739         private returns (bool)
1740     {
1741         if (!to.isContract()) {
1742             return true;
1743         }
1744         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1745             IERC721Receiver(to).onERC721Received.selector,
1746             _msgSender(),
1747             from,
1748             tokenId,
1749             _data
1750         ), "ERC721: transfer to non ERC721Receiver implementer");
1751         bytes4 retval = abi.decode(returndata, (bytes4));
1752         return (retval == _ERC721_RECEIVED);
1753     }
1754 
1755     function _approve(address to, uint256 tokenId) private {
1756         _tokenApprovals[tokenId] = to;
1757         emit Approval(ownerOf(tokenId), to, tokenId);
1758     }
1759 
1760     /**
1761      * @dev Hook that is called before any token transfer. This includes minting
1762      * and burning.
1763      *
1764      * Calling conditions:
1765      *
1766      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1767      * transferred to `to`.
1768      * - When `from` is zero, `tokenId` will be minted for `to`.
1769      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1770      * - `from` cannot be the zero address.
1771      * - `to` cannot be the zero address.
1772      *
1773      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1774      */
1775     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1776 }
1777 
1778 // File: ASNFT.sol
1779 
1780 
1781 pragma solidity 0.7.6;
1782 
1783 
1784 
1785 
1786 contract BenMezrichProject1 is ERC721, Ownable {
1787     using SafeMath for uint256;
1788 
1789     uint256 constant public MAX_SUPPLY = 6000;
1790     uint256 public maxPurchase = 2;
1791     uint256 public walletLimit = 2;
1792     uint256 public itemPrice = .06 ether;
1793 	uint256 public mintedTokens;
1794     uint256 public startingIpfsId;
1795     uint256 private _lastIpfsId;
1796     
1797     bool public isSaleActive;
1798     address public fundWallet;
1799 
1800     mapping(address => uint256) public walletMinted;
1801 
1802     modifier whenPublicSaleActive() {
1803         require(isSaleActive, "Public sale is not active");
1804         _;
1805     }
1806 
1807     constructor (string memory _tokenBaseUri, address _fundWallet) ERC721("Ben Mezrich Project 1", "BENFT1") {
1808         _setBaseURI(_tokenBaseUri);
1809         fundWallet = _fundWallet;
1810     }
1811 
1812     function mintToken(uint256 _howMany) external payable whenPublicSaleActive {
1813 	    require(_howMany > 0, "Minimum 1 tokens need to be minted");
1814 	    require(mintedTokens + _howMany <= MAX_SUPPLY, "Minting would exceed max supply");
1815 		require(itemPrice.mul(_howMany) == msg.value, "Insufficient ETH to mint");
1816         require(walletMinted[_msgSender()] + _howMany <= walletLimit, "Wallet limit exceeds");
1817         require(!_isContract(_msgSender()), "Caller cannot be contract");
1818 
1819 		for (uint256 i = 0; i < _howMany; i++) {
1820 			_mintToken(_msgSender());
1821 		}
1822 
1823         walletMinted[_msgSender()] = walletMinted[_msgSender()].add(_howMany);
1824 	}
1825 	
1826 	function _isContract(address _addr) private view returns (bool) {
1827         uint32 _size;
1828         assembly {
1829             _size := extcodesize(_addr)
1830         }
1831         return (_size > 0);
1832     }
1833     
1834     function _mintToken(address _to) private {
1835         if(mintedTokens == 0) {
1836             _lastIpfsId = random(1, MAX_SUPPLY, uint256(uint160(address(_msgSender()))) + 1);
1837             startingIpfsId = _lastIpfsId;
1838         } else {
1839             _lastIpfsId = getIpfsIdToMint();
1840         }
1841         mintedTokens++;
1842         _safeMint(_to, mintedTokens);
1843         _setTokenURI(mintedTokens, uint2str(_lastIpfsId));
1844     }
1845 
1846     function uint2str(uint256 _i) private pure returns (string memory _uintAsString) {
1847 		if (_i == 0) {
1848 			return "0";
1849 		}
1850 		uint256 j = _i;
1851 		uint256 len;
1852 		while (j != 0) {
1853 			len++;
1854 			j /= 10;
1855 		}
1856 		bytes memory bstr = new bytes(len);
1857 		uint256 k = len;
1858 		while (_i != 0) {
1859 			k = k - 1;
1860 			uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
1861 			bytes1 b1 = bytes1(temp);
1862 			bstr[k] = b1;
1863 			_i /= 10;
1864 		}
1865 		return string(bstr);
1866 	}
1867 
1868     function burn(uint256 tokenId) external virtual {
1869         require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
1870         _burn(tokenId);
1871     }
1872 
1873     function exists(uint256 _tokenId) external view returns (bool) {
1874         return _exists(_tokenId);
1875     }
1876 
1877     function isAllTokenMinted() public view returns (bool) {
1878         return mintedTokens == MAX_SUPPLY;
1879     }
1880 
1881     function getIpfsIdToMint() private view returns(uint256 _nextIpfsId) {
1882         require(!isAllTokenMinted(), "All tokens have been minted");
1883         if(_lastIpfsId == MAX_SUPPLY && mintedTokens < MAX_SUPPLY) {
1884             _nextIpfsId = 51;
1885         } else if(mintedTokens < MAX_SUPPLY) {
1886             _nextIpfsId = _lastIpfsId + 1;
1887         }
1888     }
1889 
1890     function isApprovedOrOwner(address _spender, uint256 _tokenId) external view returns (bool) {
1891         return _isApprovedOrOwner(_spender, _tokenId);
1892     }
1893 
1894     //random number
1895 	function random(
1896 		uint256 from,
1897 		uint256 to,
1898 		uint256 salty
1899 	) private view returns (uint256) {
1900 		uint256 seed =
1901 			uint256(
1902 				keccak256(
1903 					abi.encodePacked(
1904 						block.timestamp +
1905 							block.difficulty +
1906 							((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
1907 							block.gaslimit +
1908 							((uint256(keccak256(abi.encodePacked(_msgSender())))) / (block.timestamp)) +
1909 							block.number +
1910 							salty
1911 					)
1912 				)
1913 			);
1914 		return seed.mod(to - from) + from;
1915 	}
1916 
1917     function startPublicSale() external onlyOwner {
1918         isSaleActive = true;
1919     }
1920 
1921     function pausePublicSale() external onlyOwner whenPublicSaleActive {
1922         isSaleActive = false;
1923     }
1924 
1925     function modifyItemPrice(uint256 _itemPrice) external onlyOwner {
1926         itemPrice = _itemPrice;
1927     }
1928 
1929     function modifyWalletLimit(uint256 _walletLimit) external onlyOwner {
1930         walletLimit = _walletLimit;
1931     }
1932 
1933     function modifyMaxPurchase(uint256 _maxPurchase) external onlyOwner {
1934         maxPurchase = _maxPurchase;
1935     }
1936 
1937     function setFundWallet(address _fund) external onlyOwner {
1938         fundWallet = _fund;
1939     }
1940 
1941     function tokensOfOwner(address owner)
1942         public
1943         view
1944         returns (uint256[] memory)
1945     {
1946         uint256 count = balanceOf(owner);
1947         uint256[] memory ids = new uint256[](count);
1948         for (uint256 i = 0; i < count; i++) {
1949             ids[i] = tokenOfOwnerByIndex(owner, i);
1950         }
1951         return ids;
1952     }
1953 
1954     function withdrawETH(uint256 _amount) external onlyOwner {
1955         payable(fundWallet).transfer(_amount);
1956     }
1957 
1958     function setTokenURI(uint256 _tokenId, string memory _uri) external onlyOwner {
1959         _setTokenURI(_tokenId, _uri);
1960     }
1961 
1962     function setBaseURI(string memory _baseURI) external onlyOwner {
1963         _setBaseURI(_baseURI);
1964     }
1965 
1966     function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal virtual override(ERC721) {
1967         super._beforeTokenTransfer(_from, _to, _tokenId);
1968     }
1969 }