1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev String operations.
5  */
6 library Strings {
7     bytes16 private constant alphabet = "0123456789abcdef";
8 
9     /**
10      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
11      */
12     function toString(uint256 value) internal pure returns (string memory) {
13         // Inspired by OraclizeAPI's implementation - MIT licence
14         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
15 
16         if (value == 0) {
17             return "0";
18         }
19         uint256 temp = value;
20         uint256 digits;
21         while (temp != 0) {
22             digits++;
23             temp /= 10;
24         }
25         bytes memory buffer = new bytes(digits);
26         while (value != 0) {
27             digits -= 1;
28             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
29             value /= 10;
30         }
31         return string(buffer);
32     }
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
36      */
37     function toHexString(uint256 value) internal pure returns (string memory) {
38         if (value == 0) {
39             return "0x00";
40         }
41         uint256 temp = value;
42         uint256 length = 0;
43         while (temp != 0) {
44             length++;
45             temp >>= 8;
46         }
47         return toHexString(value, length);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
52      */
53     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
54         bytes memory buffer = new bytes(2 * length + 2);
55         buffer[0] = "0";
56         buffer[1] = "x";
57         for (uint256 i = 2 * length + 1; i > 1; --i) {
58             buffer[i] = alphabet[value & 0xf];
59             value >>= 4;
60         }
61         require(value == 0, "Strings: hex length insufficient");
62         return string(buffer);
63     }
64 
65 }
66 
67 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
68 
69 
70 
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Library for managing an enumerable variant of Solidity's
76  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
77  * type.
78  *
79  * Maps have the following properties:
80  *
81  * - Entries are added, removed, and checked for existence in constant time
82  * (O(1)).
83  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
84  *
85  * ```
86  * contract Example {
87  *     // Add the library methods
88  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
89  *
90  *     // Declare a set state variable
91  *     EnumerableMap.UintToAddressMap private myMap;
92  * }
93  * ```
94  *
95  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
96  * supported.
97  */
98 library EnumerableMap {
99     // To implement this library for multiple types with as little code
100     // repetition as possible, we write it in terms of a generic Map type with
101     // bytes32 keys and values.
102     // The Map implementation uses private functions, and user-facing
103     // implementations (such as Uint256ToAddressMap) are just wrappers around
104     // the underlying Map.
105     // This means that we can only create new EnumerableMaps for types that fit
106     // in bytes32.
107 
108     struct MapEntry {
109         bytes32 _key;
110         bytes32 _value;
111     }
112 
113     struct Map {
114         // Storage of map keys and values
115         MapEntry[] _entries;
116 
117         // Position of the entry defined by a key in the `entries` array, plus 1
118         // because index 0 means a key is not in the map.
119         mapping (bytes32 => uint256) _indexes;
120     }
121 
122     /**
123      * @dev Adds a key-value pair to a map, or updates the value for an existing
124      * key. O(1).
125      *
126      * Returns true if the key was added to the map, that is if it was not
127      * already present.
128      */
129     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
130         // We read and store the key's index to prevent multiple reads from the same storage slot
131         uint256 keyIndex = map._indexes[key];
132 
133         if (keyIndex == 0) { // Equivalent to !contains(map, key)
134             map._entries.push(MapEntry({ _key: key, _value: value }));
135             // The entry is stored at length-1, but we add 1 to all indexes
136             // and use 0 as a sentinel value
137             map._indexes[key] = map._entries.length;
138             return true;
139         } else {
140             map._entries[keyIndex - 1]._value = value;
141             return false;
142         }
143     }
144 
145     /**
146      * @dev Removes a key-value pair from a map. O(1).
147      *
148      * Returns true if the key was removed from the map, that is if it was present.
149      */
150     function _remove(Map storage map, bytes32 key) private returns (bool) {
151         // We read and store the key's index to prevent multiple reads from the same storage slot
152         uint256 keyIndex = map._indexes[key];
153 
154         if (keyIndex != 0) { // Equivalent to contains(map, key)
155             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
156             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
157             // This modifies the order of the array, as noted in {at}.
158 
159             uint256 toDeleteIndex = keyIndex - 1;
160             uint256 lastIndex = map._entries.length - 1;
161 
162             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
163             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
164 
165             MapEntry storage lastEntry = map._entries[lastIndex];
166 
167             // Move the last entry to the index where the entry to delete is
168             map._entries[toDeleteIndex] = lastEntry;
169             // Update the index for the moved entry
170             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
171 
172             // Delete the slot where the moved entry was stored
173             map._entries.pop();
174 
175             // Delete the index for the deleted slot
176             delete map._indexes[key];
177 
178             return true;
179         } else {
180             return false;
181         }
182     }
183 
184     /**
185      * @dev Returns true if the key is in the map. O(1).
186      */
187     function _contains(Map storage map, bytes32 key) private view returns (bool) {
188         return map._indexes[key] != 0;
189     }
190 
191     /**
192      * @dev Returns the number of key-value pairs in the map. O(1).
193      */
194     function _length(Map storage map) private view returns (uint256) {
195         return map._entries.length;
196     }
197 
198    /**
199     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
200     *
201     * Note that there are no guarantees on the ordering of entries inside the
202     * array, and it may change when more entries are added or removed.
203     *
204     * Requirements:
205     *
206     * - `index` must be strictly less than {length}.
207     */
208     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
209         require(map._entries.length > index, "EnumerableMap: index out of bounds");
210 
211         MapEntry storage entry = map._entries[index];
212         return (entry._key, entry._value);
213     }
214 
215     /**
216      * @dev Tries to returns the value associated with `key`.  O(1).
217      * Does not revert if `key` is not in the map.
218      */
219     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
220         uint256 keyIndex = map._indexes[key];
221         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
222         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
223     }
224 
225     /**
226      * @dev Returns the value associated with `key`.  O(1).
227      *
228      * Requirements:
229      *
230      * - `key` must be in the map.
231      */
232     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
233         uint256 keyIndex = map._indexes[key];
234         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
235         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
236     }
237 
238     /**
239      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
240      *
241      * CAUTION: This function is deprecated because it requires allocating memory for the error
242      * message unnecessarily. For custom revert reasons use {_tryGet}.
243      */
244     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
245         uint256 keyIndex = map._indexes[key];
246         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
247         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
248     }
249 
250     // UintToAddressMap
251 
252     struct UintToAddressMap {
253         Map _inner;
254     }
255 
256     /**
257      * @dev Adds a key-value pair to a map, or updates the value for an existing
258      * key. O(1).
259      *
260      * Returns true if the key was added to the map, that is if it was not
261      * already present.
262      */
263     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
264         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
265     }
266 
267     /**
268      * @dev Removes a value from a set. O(1).
269      *
270      * Returns true if the key was removed from the map, that is if it was present.
271      */
272     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
273         return _remove(map._inner, bytes32(key));
274     }
275 
276     /**
277      * @dev Returns true if the key is in the map. O(1).
278      */
279     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
280         return _contains(map._inner, bytes32(key));
281     }
282 
283     /**
284      * @dev Returns the number of elements in the map. O(1).
285      */
286     function length(UintToAddressMap storage map) internal view returns (uint256) {
287         return _length(map._inner);
288     }
289 
290    /**
291     * @dev Returns the element stored at position `index` in the set. O(1).
292     * Note that there are no guarantees on the ordering of values inside the
293     * array, and it may change when more values are added or removed.
294     *
295     * Requirements:
296     *
297     * - `index` must be strictly less than {length}.
298     */
299     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
300         (bytes32 key, bytes32 value) = _at(map._inner, index);
301         return (uint256(key), address(uint160(uint256(value))));
302     }
303 
304     /**
305      * @dev Tries to returns the value associated with `key`.  O(1).
306      * Does not revert if `key` is not in the map.
307      *
308      * _Available since v3.4._
309      */
310     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
311         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
312         return (success, address(uint160(uint256(value))));
313     }
314 
315     /**
316      * @dev Returns the value associated with `key`.  O(1).
317      *
318      * Requirements:
319      *
320      * - `key` must be in the map.
321      */
322     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
323         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
324     }
325 
326     /**
327      * @dev Same as {get}, with a custom error message when `key` is not in the map.
328      *
329      * CAUTION: This function is deprecated because it requires allocating memory for the error
330      * message unnecessarily. For custom revert reasons use {tryGet}.
331      */
332     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
333         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
334     }
335 }
336 
337 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
338 
339 
340 
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Library for managing
346  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
347  * types.
348  *
349  * Sets have the following properties:
350  *
351  * - Elements are added, removed, and checked for existence in constant time
352  * (O(1)).
353  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
354  *
355  * ```
356  * contract Example {
357  *     // Add the library methods
358  *     using EnumerableSet for EnumerableSet.AddressSet;
359  *
360  *     // Declare a set state variable
361  *     EnumerableSet.AddressSet private mySet;
362  * }
363  * ```
364  *
365  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
366  * and `uint256` (`UintSet`) are supported.
367  */
368 library EnumerableSet {
369     // To implement this library for multiple types with as little code
370     // repetition as possible, we write it in terms of a generic Set type with
371     // bytes32 values.
372     // The Set implementation uses private functions, and user-facing
373     // implementations (such as AddressSet) are just wrappers around the
374     // underlying Set.
375     // This means that we can only create new EnumerableSets for types that fit
376     // in bytes32.
377 
378     struct Set {
379         // Storage of set values
380         bytes32[] _values;
381 
382         // Position of the value in the `values` array, plus 1 because index 0
383         // means a value is not in the set.
384         mapping (bytes32 => uint256) _indexes;
385     }
386 
387     /**
388      * @dev Add a value to a set. O(1).
389      *
390      * Returns true if the value was added to the set, that is if it was not
391      * already present.
392      */
393     function _add(Set storage set, bytes32 value) private returns (bool) {
394         if (!_contains(set, value)) {
395             set._values.push(value);
396             // The value is stored at length-1, but we add 1 to all indexes
397             // and use 0 as a sentinel value
398             set._indexes[value] = set._values.length;
399             return true;
400         } else {
401             return false;
402         }
403     }
404 
405     /**
406      * @dev Removes a value from a set. O(1).
407      *
408      * Returns true if the value was removed from the set, that is if it was
409      * present.
410      */
411     function _remove(Set storage set, bytes32 value) private returns (bool) {
412         // We read and store the value's index to prevent multiple reads from the same storage slot
413         uint256 valueIndex = set._indexes[value];
414 
415         if (valueIndex != 0) { // Equivalent to contains(set, value)
416             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
417             // the array, and then remove the last element (sometimes called as 'swap and pop').
418             // This modifies the order of the array, as noted in {at}.
419 
420             uint256 toDeleteIndex = valueIndex - 1;
421             uint256 lastIndex = set._values.length - 1;
422 
423             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
424             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
425 
426             bytes32 lastvalue = set._values[lastIndex];
427 
428             // Move the last value to the index where the value to delete is
429             set._values[toDeleteIndex] = lastvalue;
430             // Update the index for the moved value
431             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
432 
433             // Delete the slot where the moved value was stored
434             set._values.pop();
435 
436             // Delete the index for the deleted slot
437             delete set._indexes[value];
438 
439             return true;
440         } else {
441             return false;
442         }
443     }
444 
445     /**
446      * @dev Returns true if the value is in the set. O(1).
447      */
448     function _contains(Set storage set, bytes32 value) private view returns (bool) {
449         return set._indexes[value] != 0;
450     }
451 
452     /**
453      * @dev Returns the number of values on the set. O(1).
454      */
455     function _length(Set storage set) private view returns (uint256) {
456         return set._values.length;
457     }
458 
459    /**
460     * @dev Returns the value stored at position `index` in the set. O(1).
461     *
462     * Note that there are no guarantees on the ordering of values inside the
463     * array, and it may change when more values are added or removed.
464     *
465     * Requirements:
466     *
467     * - `index` must be strictly less than {length}.
468     */
469     function _at(Set storage set, uint256 index) private view returns (bytes32) {
470         require(set._values.length > index, "EnumerableSet: index out of bounds");
471         return set._values[index];
472     }
473 
474     // Bytes32Set
475 
476     struct Bytes32Set {
477         Set _inner;
478     }
479 
480     /**
481      * @dev Add a value to a set. O(1).
482      *
483      * Returns true if the value was added to the set, that is if it was not
484      * already present.
485      */
486     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
487         return _add(set._inner, value);
488     }
489 
490     /**
491      * @dev Removes a value from a set. O(1).
492      *
493      * Returns true if the value was removed from the set, that is if it was
494      * present.
495      */
496     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
497         return _remove(set._inner, value);
498     }
499 
500     /**
501      * @dev Returns true if the value is in the set. O(1).
502      */
503     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
504         return _contains(set._inner, value);
505     }
506 
507     /**
508      * @dev Returns the number of values in the set. O(1).
509      */
510     function length(Bytes32Set storage set) internal view returns (uint256) {
511         return _length(set._inner);
512     }
513 
514    /**
515     * @dev Returns the value stored at position `index` in the set. O(1).
516     *
517     * Note that there are no guarantees on the ordering of values inside the
518     * array, and it may change when more values are added or removed.
519     *
520     * Requirements:
521     *
522     * - `index` must be strictly less than {length}.
523     */
524     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
525         return _at(set._inner, index);
526     }
527 
528     // AddressSet
529 
530     struct AddressSet {
531         Set _inner;
532     }
533 
534     /**
535      * @dev Add a value to a set. O(1).
536      *
537      * Returns true if the value was added to the set, that is if it was not
538      * already present.
539      */
540     function add(AddressSet storage set, address value) internal returns (bool) {
541         return _add(set._inner, bytes32(uint256(uint160(value))));
542     }
543 
544     /**
545      * @dev Removes a value from a set. O(1).
546      *
547      * Returns true if the value was removed from the set, that is if it was
548      * present.
549      */
550     function remove(AddressSet storage set, address value) internal returns (bool) {
551         return _remove(set._inner, bytes32(uint256(uint160(value))));
552     }
553 
554     /**
555      * @dev Returns true if the value is in the set. O(1).
556      */
557     function contains(AddressSet storage set, address value) internal view returns (bool) {
558         return _contains(set._inner, bytes32(uint256(uint160(value))));
559     }
560 
561     /**
562      * @dev Returns the number of values in the set. O(1).
563      */
564     function length(AddressSet storage set) internal view returns (uint256) {
565         return _length(set._inner);
566     }
567 
568    /**
569     * @dev Returns the value stored at position `index` in the set. O(1).
570     *
571     * Note that there are no guarantees on the ordering of values inside the
572     * array, and it may change when more values are added or removed.
573     *
574     * Requirements:
575     *
576     * - `index` must be strictly less than {length}.
577     */
578     function at(AddressSet storage set, uint256 index) internal view returns (address) {
579         return address(uint160(uint256(_at(set._inner, index))));
580     }
581 
582 
583     // UintSet
584 
585     struct UintSet {
586         Set _inner;
587     }
588 
589     /**
590      * @dev Add a value to a set. O(1).
591      *
592      * Returns true if the value was added to the set, that is if it was not
593      * already present.
594      */
595     function add(UintSet storage set, uint256 value) internal returns (bool) {
596         return _add(set._inner, bytes32(value));
597     }
598 
599     /**
600      * @dev Removes a value from a set. O(1).
601      *
602      * Returns true if the value was removed from the set, that is if it was
603      * present.
604      */
605     function remove(UintSet storage set, uint256 value) internal returns (bool) {
606         return _remove(set._inner, bytes32(value));
607     }
608 
609     /**
610      * @dev Returns true if the value is in the set. O(1).
611      */
612     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
613         return _contains(set._inner, bytes32(value));
614     }
615 
616     /**
617      * @dev Returns the number of values on the set. O(1).
618      */
619     function length(UintSet storage set) internal view returns (uint256) {
620         return _length(set._inner);
621     }
622 
623    /**
624     * @dev Returns the value stored at position `index` in the set. O(1).
625     *
626     * Note that there are no guarantees on the ordering of values inside the
627     * array, and it may change when more values are added or removed.
628     *
629     * Requirements:
630     *
631     * - `index` must be strictly less than {length}.
632     */
633     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
634         return uint256(_at(set._inner, index));
635     }
636 }
637 
638 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
639 
640 
641 
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Collection of functions related to the address type
647  */
648 library Address {
649     /**
650      * @dev Returns true if `account` is a contract.
651      *
652      * [IMPORTANT]
653      * ====
654      * It is unsafe to assume that an address for which this function returns
655      * false is an externally-owned account (EOA) and not a contract.
656      *
657      * Among others, `isContract` will return false for the following
658      * types of addresses:
659      *
660      *  - an externally-owned account
661      *  - a contract in construction
662      *  - an address where a contract will be created
663      *  - an address where a contract lived, but was destroyed
664      * ====
665      */
666     function isContract(address account) internal view returns (bool) {
667         // This method relies on extcodesize, which returns 0 for contracts in
668         // construction, since the code is only stored at the end of the
669         // constructor execution.
670 
671         uint256 size;
672         // solhint-disable-next-line no-inline-assembly
673         assembly { size := extcodesize(account) }
674         return size > 0;
675     }
676 
677     /**
678      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
679      * `recipient`, forwarding all available gas and reverting on errors.
680      *
681      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
682      * of certain opcodes, possibly making contracts go over the 2300 gas limit
683      * imposed by `transfer`, making them unable to receive funds via
684      * `transfer`. {sendValue} removes this limitation.
685      *
686      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
687      *
688      * IMPORTANT: because control is transferred to `recipient`, care must be
689      * taken to not create reentrancy vulnerabilities. Consider using
690      * {ReentrancyGuard} or the
691      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
692      */
693     function sendValue(address payable recipient, uint256 amount) internal {
694         require(address(this).balance >= amount, "Address: insufficient balance");
695 
696         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
697         (bool success, ) = recipient.call{ value: amount }("");
698         require(success, "Address: unable to send value, recipient may have reverted");
699     }
700 
701     /**
702      * @dev Performs a Solidity function call using a low level `call`. A
703      * plain`call` is an unsafe replacement for a function call: use this
704      * function instead.
705      *
706      * If `target` reverts with a revert reason, it is bubbled up by this
707      * function (like regular Solidity function calls).
708      *
709      * Returns the raw returned data. To convert to the expected return value,
710      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
711      *
712      * Requirements:
713      *
714      * - `target` must be a contract.
715      * - calling `target` with `data` must not revert.
716      *
717      * _Available since v3.1._
718      */
719     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
720       return functionCall(target, data, "Address: low-level call failed");
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
725      * `errorMessage` as a fallback revert reason when `target` reverts.
726      *
727      * _Available since v3.1._
728      */
729     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
730         return functionCallWithValue(target, data, 0, errorMessage);
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
735      * but also transferring `value` wei to `target`.
736      *
737      * Requirements:
738      *
739      * - the calling contract must have an ETH balance of at least `value`.
740      * - the called Solidity function must be `payable`.
741      *
742      * _Available since v3.1._
743      */
744     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
745         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
750      * with `errorMessage` as a fallback revert reason when `target` reverts.
751      *
752      * _Available since v3.1._
753      */
754     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
755         require(address(this).balance >= value, "Address: insufficient balance for call");
756         require(isContract(target), "Address: call to non-contract");
757 
758         // solhint-disable-next-line avoid-low-level-calls
759         (bool success, bytes memory returndata) = target.call{ value: value }(data);
760         return _verifyCallResult(success, returndata, errorMessage);
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
765      * but performing a static call.
766      *
767      * _Available since v3.3._
768      */
769     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
770         return functionStaticCall(target, data, "Address: low-level static call failed");
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
780         require(isContract(target), "Address: static call to non-contract");
781 
782         // solhint-disable-next-line avoid-low-level-calls
783         (bool success, bytes memory returndata) = target.staticcall(data);
784         return _verifyCallResult(success, returndata, errorMessage);
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
789      * but performing a delegate call.
790      *
791      * _Available since v3.4._
792      */
793     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
794         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
799      * but performing a delegate call.
800      *
801      * _Available since v3.4._
802      */
803     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
804         require(isContract(target), "Address: delegate call to non-contract");
805 
806         // solhint-disable-next-line avoid-low-level-calls
807         (bool success, bytes memory returndata) = target.delegatecall(data);
808         return _verifyCallResult(success, returndata, errorMessage);
809     }
810 
811     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
812         if (success) {
813             return returndata;
814         } else {
815             // Look for revert reason and bubble it up if present
816             if (returndata.length > 0) {
817                 // The easiest way to bubble the revert reason is using memory via assembly
818 
819                 // solhint-disable-next-line no-inline-assembly
820                 assembly {
821                     let returndata_size := mload(returndata)
822                     revert(add(32, returndata), returndata_size)
823                 }
824             } else {
825                 revert(errorMessage);
826             }
827         }
828     }
829 }
830 
831 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
832 
833 
834 pragma solidity ^0.8.0;
835 
836 /**
837  * @dev Interface of the ERC165 standard, as defined in the
838  * https://eips.ethereum.org/EIPS/eip-165[EIP].
839  *
840  * Implementers can declare support of contract interfaces, which can then be
841  * queried by others ({ERC165Checker}).
842  *
843  * For an implementation, see {ERC165}.
844  */
845 interface IERC165 {
846     /**
847      * @dev Returns true if this contract implements the interface defined by
848      * `interfaceId`. See the corresponding
849      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
850      * to learn more about how these ids are created.
851      *
852      * This function call must use less than 30 000 gas.
853      */
854     function supportsInterface(bytes4 interfaceId) external view returns (bool);
855 }
856 
857 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
858 
859 
860 pragma solidity ^0.8.0;
861 
862 
863 /**
864  * @dev Implementation of the {IERC165} interface.
865  *
866  * Contracts may inherit from this and call {_registerInterface} to declare
867  * their support of an interface.
868  */
869 abstract contract ERC165 is IERC165 {
870     /**
871      * @dev Mapping of interface ids to whether or not it's supported.
872      */
873     mapping(bytes4 => bool) private _supportedInterfaces;
874 
875     constructor () {
876         // Derived contracts need only register support for their own interfaces,
877         // we register support for ERC165 itself here
878         _registerInterface(type(IERC165).interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC165-supportsInterface}.
883      *
884      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
885      */
886     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
887         return _supportedInterfaces[interfaceId];
888     }
889 
890     /**
891      * @dev Registers the contract as an implementer of the interface defined by
892      * `interfaceId`. Support of the actual ERC165 interface is automatic and
893      * registering its interface id is not required.
894      *
895      * See {IERC165-supportsInterface}.
896      *
897      * Requirements:
898      *
899      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
900      */
901     function _registerInterface(bytes4 interfaceId) internal virtual {
902         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
903         _supportedInterfaces[interfaceId] = true;
904     }
905 }
906 
907 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
908 
909 
910 
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @dev Required interface of an ERC721 compliant contract.
917  */
918 interface IERC721 is IERC165 {
919     /**
920      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
921      */
922     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
923 
924     /**
925      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
926      */
927     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
928 
929     /**
930      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
931      */
932     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
933 
934     /**
935      * @dev Returns the number of tokens in ``owner``'s account.
936      */
937     function balanceOf(address owner) external view returns (uint256 balance);
938 
939     /**
940      * @dev Returns the owner of the `tokenId` token.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function ownerOf(uint256 tokenId) external view returns (address owner);
947 
948     /**
949      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
950      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
959      *
960      * Emits a {Transfer} event.
961      */
962     function safeTransferFrom(address from, address to, uint256 tokenId) external;
963 
964     /**
965      * @dev Transfers `tokenId` token from `from` to `to`.
966      *
967      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
968      *
969      * Requirements:
970      *
971      * - `from` cannot be the zero address.
972      * - `to` cannot be the zero address.
973      * - `tokenId` token must be owned by `from`.
974      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
975      *
976      * Emits a {Transfer} event.
977      */
978     function transferFrom(address from, address to, uint256 tokenId) external;
979 
980     /**
981      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
982      * The approval is cleared when the token is transferred.
983      *
984      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
985      *
986      * Requirements:
987      *
988      * - The caller must own the token or be an approved operator.
989      * - `tokenId` must exist.
990      *
991      * Emits an {Approval} event.
992      */
993     function approve(address to, uint256 tokenId) external;
994 
995     /**
996      * @dev Returns the account approved for `tokenId` token.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      */
1002     function getApproved(uint256 tokenId) external view returns (address operator);
1003 
1004     /**
1005      * @dev Approve or remove `operator` as an operator for the caller.
1006      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1007      *
1008      * Requirements:
1009      *
1010      * - The `operator` cannot be the caller.
1011      *
1012      * Emits an {ApprovalForAll} event.
1013      */
1014     function setApprovalForAll(address operator, bool _approved) external;
1015 
1016     /**
1017      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1018      *
1019      * See {setApprovalForAll}
1020      */
1021     function isApprovedForAll(address owner, address operator) external view returns (bool);
1022 
1023     /**
1024       * @dev Safely transfers `tokenId` token from `from` to `to`.
1025       *
1026       * Requirements:
1027       *
1028       * - `from` cannot be the zero address.
1029       * - `to` cannot be the zero address.
1030       * - `tokenId` token must exist and be owned by `from`.
1031       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1032       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1033       *
1034       * Emits a {Transfer} event.
1035       */
1036     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1037 }
1038 
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 /**
1043  * @title ERC721 token receiver interface
1044  * @dev Interface for any contract that wants to support safeTransfers
1045  * from ERC721 asset contracts.
1046  */
1047 interface IERC721Receiver {
1048     /**
1049      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1050      * by `operator` from `from`, this function is called.
1051      *
1052      * It must return its Solidity selector to confirm the token transfer.
1053      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1054      *
1055      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1056      */
1057     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1058 }
1059 
1060 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1061 
1062 
1063 
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 
1068 /**
1069  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1070  * @dev See https://eips.ethereum.org/EIPS/eip-721
1071  */
1072 interface IERC721Enumerable is IERC721 {
1073 
1074     /**
1075      * @dev Returns the total amount of tokens stored by the contract.
1076      */
1077     function totalSupply() external view returns (uint256);
1078 
1079     /**
1080      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1081      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1082      */
1083     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1084 
1085     /**
1086      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1087      * Use along with {totalSupply} to enumerate all tokens.
1088      */
1089     function tokenByIndex(uint256 index) external view returns (uint256);
1090 }
1091 
1092 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1093 
1094 
1095 
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 /**
1101  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1102  * @dev See https://eips.ethereum.org/EIPS/eip-721
1103  */
1104 interface IERC721Metadata is IERC721 {
1105 
1106     /**
1107      * @dev Returns the token collection name.
1108      */
1109     function name() external view returns (string memory);
1110 
1111     /**
1112      * @dev Returns the token collection symbol.
1113      */
1114     function symbol() external view returns (string memory);
1115 
1116     /**
1117      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1118      */
1119     function tokenURI(uint256 tokenId) external view returns (string memory);
1120 }
1121 
1122 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1123 
1124 
1125 
1126 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1127 
1128 
1129 
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 /*
1134  * @dev Provides information about the current execution context, including the
1135  * sender of the transaction and its data. While these are generally available
1136  * via msg.sender and msg.data, they should not be accessed in such a direct
1137  * manner, since when dealing with GSN meta-transactions the account sending and
1138  * paying for execution may not be the actual sender (as far as an application
1139  * is concerned).
1140  *
1141  * This contract is only required for intermediate, library-like contracts.
1142  */
1143 abstract contract Context {
1144     function _msgSender() internal view virtual returns (address) {
1145         return msg.sender;
1146     }
1147 
1148     function _msgData() internal view virtual returns (bytes calldata) {
1149         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1150         return msg.data;
1151     }
1152 }
1153 
1154 
1155 
1156 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1157 
1158 
1159 
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 /**
1174  * @title ERC721 Non-Fungible Token Standard basic implementation
1175  * @dev see https://eips.ethereum.org/EIPS/eip-721
1176  */
1177 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1178     using Address for address;
1179     using EnumerableSet for EnumerableSet.UintSet;
1180     using EnumerableMap for EnumerableMap.UintToAddressMap;
1181     using Strings for uint256;
1182     
1183     // Mapping from holder address to their (enumerable) set of owned tokens
1184     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1185 
1186     
1187     // Enumerable mapping from token ids to their owners
1188     EnumerableMap.UintToAddressMap private _tokenOwners;
1189 
1190     // Mapping from token ID to approved address
1191     mapping (uint256 => address) private _tokenApprovals;
1192 
1193     // Mapping from owner to operator approvals
1194     mapping (address => mapping (address => bool)) private _operatorApprovals;
1195 
1196     // Token name
1197     string private _name;
1198 
1199     // Token symbol
1200     string private _symbol;
1201 
1202     // Optional mapping for token URIs
1203     mapping (uint256 => string) private _tokenURIs;
1204 
1205     // Base URI
1206     string private _baseURI;
1207 
1208     /**
1209      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1210      */
1211     constructor (string memory name_, string memory symbol_) {
1212         _name = name_;
1213         _symbol = symbol_;
1214 
1215         // register the supported interfaces to conform to ERC721 via ERC165
1216         _registerInterface(type(IERC721).interfaceId);
1217         _registerInterface(type(IERC721Metadata).interfaceId);
1218         _registerInterface(type(IERC721Enumerable).interfaceId);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-balanceOf}.
1223      */
1224     function balanceOf(address owner) public view virtual override returns (uint256) {
1225         require(owner != address(0), "ERC721: balance query for the zero address");
1226         return _holderTokens[owner].length();
1227     }
1228     
1229     
1230 
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
1523         emit Transfer(from, to, tokenId);
1524     }
1525 
1526     /**
1527      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1528      *
1529      * Requirements:
1530      *
1531      * - `tokenId` must exist.
1532      */
1533     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1534         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1535         _tokenURIs[tokenId] = _tokenURI;
1536     }
1537 
1538     /**
1539      * @dev Internal function to set the base URI for all token IDs. It is
1540      * automatically added as a prefix to the value returned in {tokenURI},
1541      * or to the token ID if {tokenURI} is empty.
1542      */
1543     function _setBaseURI(string memory baseURI_) internal virtual {
1544         _baseURI = baseURI_;
1545     }
1546 
1547     /**
1548      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1549      * The call is not executed if the target address is not a contract.
1550      *
1551      * @param from address representing the previous owner of the given token ID
1552      * @param to target address that will receive the tokens
1553      * @param tokenId uint256 ID of the token to be transferred
1554      * @param _data bytes optional data to send along with the call
1555      * @return bool whether the call correctly returned the expected magic value
1556      */
1557     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1558         private returns (bool)
1559     {
1560         if (to.isContract()) {
1561             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1562                 return retval == IERC721Receiver(to).onERC721Received.selector;
1563             } catch (bytes memory reason) {
1564                 if (reason.length == 0) {
1565                     revert("ERC721: transfer to non ERC721Receiver implementer");
1566                 } else {
1567                     // solhint-disable-next-line no-inline-assembly
1568                     assembly {
1569                         revert(add(32, reason), mload(reason))
1570                     }
1571                 }
1572             }
1573         } else {
1574             return true;
1575         }
1576     }
1577 
1578     function _approve(address to, uint256 tokenId) private {
1579         _tokenApprovals[tokenId] = to;
1580         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1581     }
1582 
1583     /**
1584      * @dev Hook that is called before any token transfer. This includes minting
1585      * and burning.
1586      *
1587      * Calling conditions:
1588      *
1589      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1590      * transferred to `to`.
1591      * - When `from` is zero, `tokenId` will be minted for `to`.
1592      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1593      * - `from` cannot be the zero address.
1594      * - `to` cannot be the zero address.
1595      *
1596      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1597      */
1598     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1599 }
1600 
1601 
1602 
1603 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1604 
1605 
1606 
1607 
1608 pragma solidity ^0.8.0;
1609 
1610 /**
1611  * @dev Contract module which provides a basic access control mechanism, where
1612  * there is an account (an owner) that can be granted exclusive access to
1613  * specific functions.
1614  *
1615  * By default, the owner account will be the one that deploys the contract. This
1616  * can later be changed with {transferOwnership}.
1617  *
1618  * This module is used through inheritance. It will make available the modifier
1619  * `onlyOwner`, which can be applied to your functions to restrict their use to
1620  * the owner.
1621  */
1622 abstract contract Ownable is Context {
1623     address private _owner;
1624 
1625     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1626 
1627 
1628 
1629     /**
1630      * @dev Initializes the contract setting the deployer as the initial owner.
1631      */
1632     constructor () {
1633         address msgSender = _msgSender();
1634         _owner = msgSender;
1635         emit OwnershipTransferred(address(0), msgSender);
1636     }
1637 
1638     /**
1639      * @dev Returns the address of the current owner.
1640      */
1641     function owner() public view virtual returns (address) {
1642         return _owner;
1643     }
1644 
1645     /**
1646      * @dev Throws if called by any account other than the owner.
1647      */
1648     modifier onlyOwner() {
1649         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1650         _;
1651     }
1652 
1653     /**
1654      * @dev Leaves the contract without owner. It will not be possible to call
1655      * `onlyOwner` functions anymore. Can only be called by the current owner.
1656      *
1657      * NOTE: Renouncing ownership will leave the contract without an owner,
1658      * thereby removing any functionality that is only available to the owner.
1659      */
1660     function renounceOwnership() public virtual onlyOwner {
1661         emit OwnershipTransferred(_owner, address(0));
1662         _owner = address(0);
1663     }
1664 
1665     /**
1666      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1667      * Can only be called by the current owner.
1668      */
1669     function transferOwnership(address newOwner) public virtual onlyOwner {
1670         require(newOwner != address(0), "Ownable: new owner is the zero address");
1671         emit OwnershipTransferred(_owner, newOwner);
1672         _owner = newOwner;
1673     }
1674 }
1675 
1676 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1677 
1678 
1679 
1680 
1681 pragma solidity ^0.8.0;
1682 
1683 // CAUTION
1684 // This version of SafeMath should only be used with Solidity 0.8 or later,
1685 // because it relies on the compiler's built in overflow checks.
1686 
1687 /**
1688  * @dev Wrappers over Solidity's arithmetic operations.
1689  *
1690  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1691  * now has built in overflow checking.
1692  */
1693 library SafeMath {
1694     /**
1695      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1696      *
1697      * _Available since v3.4._
1698      */
1699     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1700         unchecked {
1701             uint256 c = a + b;
1702             if (c < a) return (false, 0);
1703             return (true, c);
1704         }
1705     }
1706 
1707     /**
1708      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1709      *
1710      * _Available since v3.4._
1711      */
1712     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1713         unchecked {
1714             if (b > a) return (false, 0);
1715             return (true, a - b);
1716         }
1717     }
1718 
1719     /**
1720      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1721      *
1722      * _Available since v3.4._
1723      */
1724     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1725         unchecked {
1726             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1727             // benefit is lost if 'b' is also tested.
1728             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1729             if (a == 0) return (true, 0);
1730             uint256 c = a * b;
1731             if (c / a != b) return (false, 0);
1732             return (true, c);
1733         }
1734     }
1735 
1736     /**
1737      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1738      *
1739      * _Available since v3.4._
1740      */
1741     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1742         unchecked {
1743             if (b == 0) return (false, 0);
1744             return (true, a / b);
1745         }
1746     }
1747 
1748     /**
1749      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1750      *
1751      * _Available since v3.4._
1752      */
1753     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1754         unchecked {
1755             if (b == 0) return (false, 0);
1756             return (true, a % b);
1757         }
1758     }
1759 
1760     /**
1761      * @dev Returns the addition of two unsigned integers, reverting on
1762      * overflow.
1763      *
1764      * Counterpart to Solidity's `+` operator.
1765      *
1766      * Requirements:
1767      *
1768      * - Addition cannot overflow.
1769      */
1770     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1771         return a + b;
1772     }
1773 
1774     /**
1775      * @dev Returns the subtraction of two unsigned integers, reverting on
1776      * overflow (when the result is negative).
1777      *
1778      * Counterpart to Solidity's `-` operator.
1779      *
1780      * Requirements:
1781      *
1782      * - Subtraction cannot overflow.
1783      */
1784     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1785         return a - b;
1786     }
1787 
1788     /**
1789      * @dev Returns the multiplication of two unsigned integers, reverting on
1790      * overflow.
1791      *
1792      * Counterpart to Solidity's `*` operator.
1793      *
1794      * Requirements:
1795      *
1796      * - Multiplication cannot overflow.
1797      */
1798     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1799         return a * b;
1800     }
1801 
1802     /**
1803      * @dev Returns the integer division of two unsigned integers, reverting on
1804      * division by zero. The result is rounded towards zero.
1805      *
1806      * Counterpart to Solidity's `/` operator.
1807      *
1808      * Requirements:
1809      *
1810      * - The divisor cannot be zero.
1811      */
1812     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1813         return a / b;
1814     }
1815 
1816     /**
1817      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1818      * reverting when dividing by zero.
1819      *
1820      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1821      * opcode (which leaves remaining gas untouched) while Solidity uses an
1822      * invalid opcode to revert (consuming all remaining gas).
1823      *
1824      * Requirements:
1825      *
1826      * - The divisor cannot be zero.
1827      */
1828     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1829         return a % b;
1830     }
1831 
1832     /**
1833      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1834      * overflow (when the result is negative).
1835      *
1836      * CAUTION: This function is deprecated because it requires allocating memory for the error
1837      * message unnecessarily. For custom revert reasons use {trySub}.
1838      *
1839      * Counterpart to Solidity's `-` operator.
1840      *
1841      * Requirements:
1842      *
1843      * - Subtraction cannot overflow.
1844      */
1845     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1846         unchecked {
1847             require(b <= a, errorMessage);
1848             return a - b;
1849         }
1850     }
1851 
1852     /**
1853      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1854      * division by zero. The result is rounded towards zero.
1855      *
1856      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1857      * opcode (which leaves remaining gas untouched) while Solidity uses an
1858      * invalid opcode to revert (consuming all remaining gas).
1859      *
1860      * Counterpart to Solidity's `/` operator. Note: this function uses a
1861      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1862      * uses an invalid opcode to revert (consuming all remaining gas).
1863      *
1864      * Requirements:
1865      *
1866      * - The divisor cannot be zero.
1867      */
1868     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1869         unchecked {
1870             require(b > 0, errorMessage);
1871             return a / b;
1872         }
1873     }
1874 
1875     /**
1876      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1877      * reverting with custom message when dividing by zero.
1878      *
1879      * CAUTION: This function is deprecated because it requires allocating memory for the error
1880      * message unnecessarily. For custom revert reasons use {tryMod}.
1881      *
1882      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1883      * opcode (which leaves remaining gas untouched) while Solidity uses an
1884      * invalid opcode to revert (consuming all remaining gas).
1885      *
1886      * Requirements:
1887      *
1888      * - The divisor cannot be zero.
1889      */
1890     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1891         unchecked {
1892             require(b > 0, errorMessage);
1893             return a % b;
1894         }
1895     }
1896 }
1897 
1898 
1899 //  ██████ ██       █████  ██████  ██ ████████ ██    ██ 
1900 // ██      ██      ██   ██ ██   ██ ██    ██     ██  ██  
1901 // ██      ██      ███████ ██████  ██    ██      ████   
1902 // ██      ██      ██   ██ ██   ██ ██    ██       ██    
1903 //  ██████ ███████ ██   ██ ██   ██ ██    ██       ██    
1904 //                                                
1905 // by @encapsuled_
1906 
1907 pragma solidity ^0.8.0;
1908 
1909 
1910 // SPDX-License-Identifier: MIT
1911 
1912 contract Clarity is ERC721, Ownable {
1913     using SafeMath for uint256;
1914     using Strings for uint256;
1915     uint public constant MAX_TOKENS = 1536;
1916     uint public constant RESERVED_TOKENS = 1024;
1917     uint256 public constant TOKEN_PRICE = 100000000000000000; // 0.1 ETH
1918     uint public constant DEVELOPER_SHARE = 34;
1919     uint public constant ARTIST_SHARE = 33;
1920     uint public constant ADVISOR_SHARE = 33;
1921     uint public constant SHARE_SUM = 100;
1922     address public developerAddress = 0xf049ED4da9E12c6E2a0928fA6c975eBb60C872F3;
1923     address public artistAddress = 0xb7275Da969bCa3112D1fDBa03385eD2C02002642;
1924     address public constant ADVISOR_ADDRESS = 0x0b8F4C4E7626A91460dac057eB43e0de59d5b44F;
1925     string public script;
1926     string public scriptType = "p5js";
1927     bool public saleStarted = false;
1928     bool public claimStarted = false;
1929     bool public saleLocked = false;
1930     bool public claimLocked = false;
1931     mapping (uint256 => uint256) public creationDates;
1932     mapping (uint256 => uint256) public poiClaimed;
1933     address public constant POI_ADDRESS = 0x02560112988e2495261b8ff6f9daD64ee566a324;
1934 
1935     constructor() ERC721("Clarity","Clarity")  {
1936         setBaseURI("https://api.chromorphs.xyz/clarity/json/");
1937         uint mintIndex = totalSupply().add(RESERVED_TOKENS);
1938         _safeMint(developerAddress, mintIndex);
1939         creationDates[mintIndex] = block.number;
1940     }
1941     
1942     function tokensClaimed() external view returns(uint256[] memory) {
1943         uint256[] memory ret = new uint256[](MAX_TOKENS);
1944         for (uint i = 0; i < MAX_TOKENS; i++) {
1945             ret[i] = poiClaimed[i];
1946         }
1947         return ret;
1948     }
1949     
1950     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1951         uint256 tokenCount = balanceOf(_owner);
1952         if (tokenCount == 0) {
1953             return new uint256[](0);
1954         } else {
1955             uint256[] memory result = new uint256[](tokenCount);
1956             uint256 index;
1957             for (index = 0; index < tokenCount; index++) {
1958                 result[index] = tokenOfOwnerByIndex(_owner, index);
1959             }
1960             return result;
1961         }
1962     }
1963     
1964     function tokensOfOwnerPOI(address _owner) public view returns(uint256[] memory ) {
1965         uint256 tokenCount = IERC721(POI_ADDRESS).balanceOf(_owner);
1966         if (tokenCount == 0) {
1967             return new uint256[](0);
1968         } else {
1969             uint256[] memory result = new uint256[](tokenCount);
1970             uint256 index;
1971             for (index = 0; index < tokenCount; index++) {
1972                 result[index] = IERC721Enumerable(POI_ADDRESS).tokenOfOwnerByIndex(_owner, index);
1973             }
1974             return result;
1975         }
1976     }
1977     
1978     
1979     function claimMultiple(uint256[] memory tokenIDs) public {
1980         require(claimStarted, "Claim is not possible now.");
1981         require(!claimLocked, "Claim is forever locked.");
1982         require(tokenIDs.length <= 20, "Cannot claim more than 20 at a time");
1983         require(totalSupply().add(tokenIDs.length) <= MAX_TOKENS, "Exceeds MAX_TOKENS");
1984         for (uint256 i = 0; i < tokenIDs.length; i++) {
1985             require(poiClaimed[tokenIDs[i]] == 0, "Already claimed this POI");
1986             require(IERC721(POI_ADDRESS).ownerOf(tokenIDs[i]) == msg.sender, "Not the owner of this POI");
1987             _safeMint(msg.sender, tokenIDs[i]);
1988             poiClaimed[tokenIDs[i]] = 1;
1989             creationDates[tokenIDs[i]] = block.number;
1990         }
1991     }
1992     
1993     function mint(uint256 tokensNumber) public payable {
1994         require(saleStarted, "Sale is not active");
1995         require(!saleLocked, "Sale is forever locked.");
1996         require(totalSupply().add(RESERVED_TOKENS) < MAX_TOKENS, "Sale has already ended");
1997         require(tokensNumber > 0 && tokensNumber <= 3, "Tokens amount must be between 1 and 3");
1998         require(totalSupply().add(RESERVED_TOKENS).add(tokensNumber) <= MAX_TOKENS, "Exceeds MAX_TOKENS");
1999         require(msg.value == TOKEN_PRICE.mul(tokensNumber), "Ether value sent is not correct");
2000 
2001         for (uint i = 0; i < tokensNumber; i++) {
2002             uint mintIndex = totalSupply().add(RESERVED_TOKENS);
2003             _safeMint(msg.sender, mintIndex);
2004             creationDates[mintIndex] = block.number;
2005         }
2006     }
2007     
2008     
2009     function lockSale() public onlyOwner {
2010         saleLocked = true;
2011     }
2012     
2013     function lockClaim() public onlyOwner {
2014         claimLocked = true;
2015     }
2016     
2017     function setScript(string memory _script) public onlyOwner {
2018         script = _script;
2019     }
2020     
2021     function setScriptType(string memory _scriptType) public onlyOwner {
2022         script = _scriptType;
2023     }
2024     
2025     function setDeveloperAddress(address _developerAddress) public onlyOwner {
2026         developerAddress = _developerAddress;
2027     }
2028     
2029     function setArtistAddress(address _artistAddress) public onlyOwner {
2030         artistAddress = _artistAddress;
2031     }
2032     
2033     function setBaseURI(string memory baseURI) public onlyOwner {
2034         _setBaseURI(baseURI);
2035     }
2036     
2037     function flipSaleState() public onlyOwner {
2038         saleStarted = !saleStarted;
2039     }
2040     
2041     function flipClaimState() public onlyOwner {
2042         claimStarted = !claimStarted;
2043     }
2044     
2045     function tokenHash(uint256 tokenId) public view returns(bytes32){
2046         require(_exists(tokenId), "DOES NOT EXIST");
2047         return bytes32(keccak256(abi.encodePacked(address(this), creationDates[tokenId], tokenId)));
2048     }
2049     
2050     function withdraw() public payable onlyOwner {
2051         uint256 balance = address(this).balance;
2052         uint toDeveloper = balance.mul(DEVELOPER_SHARE).div(SHARE_SUM);
2053         uint toArtist = balance.mul(ARTIST_SHARE).div(SHARE_SUM);
2054         uint toAdvisor = balance.mul(ADVISOR_SHARE).div(SHARE_SUM);
2055         payable(developerAddress).transfer(toDeveloper);
2056         payable(artistAddress).transfer(toArtist);
2057         payable(ADVISOR_ADDRESS).transfer(toAdvisor);
2058         assert(address(this).balance == 0);
2059     }
2060     
2061     function withdrawFailsafe() public payable onlyOwner {
2062         uint256 balance = address(this).balance;
2063         payable(msg.sender).transfer(balance);
2064     }
2065 }