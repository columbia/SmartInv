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
119         mapping(bytes32 => uint256) _indexes;
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
133         if (keyIndex == 0) {// Equivalent to !contains(map, key)
134             map._entries.push(MapEntry({_key : key, _value : value}));
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
154         if (keyIndex != 0) {// Equivalent to contains(map, key)
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
170             map._indexes[lastEntry._key] = toDeleteIndex + 1;
171             // All indexes are 1-based
172 
173             // Delete the slot where the moved entry was stored
174             map._entries.pop();
175 
176             // Delete the index for the deleted slot
177             delete map._indexes[key];
178 
179             return true;
180         } else {
181             return false;
182         }
183     }
184 
185     /**
186      * @dev Returns true if the key is in the map. O(1).
187      */
188     function _contains(Map storage map, bytes32 key) private view returns (bool) {
189         return map._indexes[key] != 0;
190     }
191 
192     /**
193      * @dev Returns the number of key-value pairs in the map. O(1).
194      */
195     function _length(Map storage map) private view returns (uint256) {
196         return map._entries.length;
197     }
198 
199     /**
200      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
201     *
202     * Note that there are no guarantees on the ordering of entries inside the
203     * array, and it may change when more entries are added or removed.
204     *
205     * Requirements:
206     *
207     * - `index` must be strictly less than {length}.
208     */
209     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
210         require(map._entries.length > index, "EnumerableMap: index out of bounds");
211 
212         MapEntry storage entry = map._entries[index];
213         return (entry._key, entry._value);
214     }
215 
216     /**
217      * @dev Tries to returns the value associated with `key`.  O(1).
218      * Does not revert if `key` is not in the map.
219      */
220     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
221         uint256 keyIndex = map._indexes[key];
222         if (keyIndex == 0) return (false, 0);
223         // Equivalent to contains(map, key)
224         return (true, map._entries[keyIndex - 1]._value);
225         // All indexes are 1-based
226     }
227 
228     /**
229      * @dev Returns the value associated with `key`.  O(1).
230      *
231      * Requirements:
232      *
233      * - `key` must be in the map.
234      */
235     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
236         uint256 keyIndex = map._indexes[key];
237         require(keyIndex != 0, "EnumerableMap: nonexistent key");
238         // Equivalent to contains(map, key)
239         return map._entries[keyIndex - 1]._value;
240         // All indexes are 1-based
241     }
242 
243     /**
244      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {_tryGet}.
248      */
249     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
250         uint256 keyIndex = map._indexes[key];
251         require(keyIndex != 0, errorMessage);
252         // Equivalent to contains(map, key)
253         return map._entries[keyIndex - 1]._value;
254         // All indexes are 1-based
255     }
256 
257     // UintToAddressMap
258 
259     struct UintToAddressMap {
260         Map _inner;
261     }
262 
263     /**
264      * @dev Adds a key-value pair to a map, or updates the value for an existing
265      * key. O(1).
266      *
267      * Returns true if the key was added to the map, that is if it was not
268      * already present.
269      */
270     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
271         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
272     }
273 
274     /**
275      * @dev Removes a value from a set. O(1).
276      *
277      * Returns true if the key was removed from the map, that is if it was present.
278      */
279     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
280         return _remove(map._inner, bytes32(key));
281     }
282 
283     /**
284      * @dev Returns true if the key is in the map. O(1).
285      */
286     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
287         return _contains(map._inner, bytes32(key));
288     }
289 
290     /**
291      * @dev Returns the number of elements in the map. O(1).
292      */
293     function length(UintToAddressMap storage map) internal view returns (uint256) {
294         return _length(map._inner);
295     }
296 
297     /**
298      * @dev Returns the element stored at position `index` in the set. O(1).
299     * Note that there are no guarantees on the ordering of values inside the
300     * array, and it may change when more values are added or removed.
301     *
302     * Requirements:
303     *
304     * - `index` must be strictly less than {length}.
305     */
306     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
307         (bytes32 key, bytes32 value) = _at(map._inner, index);
308         return (uint256(key), address(uint160(uint256(value))));
309     }
310 
311     /**
312      * @dev Tries to returns the value associated with `key`.  O(1).
313      * Does not revert if `key` is not in the map.
314      *
315      * _Available since v3.4._
316      */
317     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
318         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
319         return (success, address(uint160(uint256(value))));
320     }
321 
322     /**
323      * @dev Returns the value associated with `key`.  O(1).
324      *
325      * Requirements:
326      *
327      * - `key` must be in the map.
328      */
329     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
330         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
331     }
332 
333     /**
334      * @dev Same as {get}, with a custom error message when `key` is not in the map.
335      *
336      * CAUTION: This function is deprecated because it requires allocating memory for the error
337      * message unnecessarily. For custom revert reasons use {tryGet}.
338      */
339     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
340         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
341     }
342 }
343 
344 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
345 
346 
347 
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Library for managing
353  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
354  * types.
355  *
356  * Sets have the following properties:
357  *
358  * - Elements are added, removed, and checked for existence in constant time
359  * (O(1)).
360  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
361  *
362  * ```
363  * contract Example {
364  *     // Add the library methods
365  *     using EnumerableSet for EnumerableSet.AddressSet;
366  *
367  *     // Declare a set state variable
368  *     EnumerableSet.AddressSet private mySet;
369  * }
370  * ```
371  *
372  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
373  * and `uint256` (`UintSet`) are supported.
374  */
375 library EnumerableSet {
376     // To implement this library for multiple types with as little code
377     // repetition as possible, we write it in terms of a generic Set type with
378     // bytes32 values.
379     // The Set implementation uses private functions, and user-facing
380     // implementations (such as AddressSet) are just wrappers around the
381     // underlying Set.
382     // This means that we can only create new EnumerableSets for types that fit
383     // in bytes32.
384 
385     struct Set {
386         // Storage of set values
387         bytes32[] _values;
388 
389         // Position of the value in the `values` array, plus 1 because index 0
390         // means a value is not in the set.
391         mapping(bytes32 => uint256) _indexes;
392     }
393 
394     /**
395      * @dev Add a value to a set. O(1).
396      *
397      * Returns true if the value was added to the set, that is if it was not
398      * already present.
399      */
400     function _add(Set storage set, bytes32 value) private returns (bool) {
401         if (!_contains(set, value)) {
402             set._values.push(value);
403             // The value is stored at length-1, but we add 1 to all indexes
404             // and use 0 as a sentinel value
405             set._indexes[value] = set._values.length;
406             return true;
407         } else {
408             return false;
409         }
410     }
411 
412     /**
413      * @dev Removes a value from a set. O(1).
414      *
415      * Returns true if the value was removed from the set, that is if it was
416      * present.
417      */
418     function _remove(Set storage set, bytes32 value) private returns (bool) {
419         // We read and store the value's index to prevent multiple reads from the same storage slot
420         uint256 valueIndex = set._indexes[value];
421 
422         if (valueIndex != 0) {// Equivalent to contains(set, value)
423             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
424             // the array, and then remove the last element (sometimes called as 'swap and pop').
425             // This modifies the order of the array, as noted in {at}.
426 
427             uint256 toDeleteIndex = valueIndex - 1;
428             uint256 lastIndex = set._values.length - 1;
429 
430             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
431             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
432 
433             bytes32 lastvalue = set._values[lastIndex];
434 
435             // Move the last value to the index where the value to delete is
436             set._values[toDeleteIndex] = lastvalue;
437             // Update the index for the moved value
438             set._indexes[lastvalue] = toDeleteIndex + 1;
439             // All indexes are 1-based
440 
441             // Delete the slot where the moved value was stored
442             set._values.pop();
443 
444             // Delete the index for the deleted slot
445             delete set._indexes[value];
446 
447             return true;
448         } else {
449             return false;
450         }
451     }
452 
453     /**
454      * @dev Returns true if the value is in the set. O(1).
455      */
456     function _contains(Set storage set, bytes32 value) private view returns (bool) {
457         return set._indexes[value] != 0;
458     }
459 
460     /**
461      * @dev Returns the number of values on the set. O(1).
462      */
463     function _length(Set storage set) private view returns (uint256) {
464         return set._values.length;
465     }
466 
467     /**
468      * @dev Returns the value stored at position `index` in the set. O(1).
469     *
470     * Note that there are no guarantees on the ordering of values inside the
471     * array, and it may change when more values are added or removed.
472     *
473     * Requirements:
474     *
475     * - `index` must be strictly less than {length}.
476     */
477     function _at(Set storage set, uint256 index) private view returns (bytes32) {
478         require(set._values.length > index, "EnumerableSet: index out of bounds");
479         return set._values[index];
480     }
481 
482     // Bytes32Set
483 
484     struct Bytes32Set {
485         Set _inner;
486     }
487 
488     /**
489      * @dev Add a value to a set. O(1).
490      *
491      * Returns true if the value was added to the set, that is if it was not
492      * already present.
493      */
494     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
495         return _add(set._inner, value);
496     }
497 
498     /**
499      * @dev Removes a value from a set. O(1).
500      *
501      * Returns true if the value was removed from the set, that is if it was
502      * present.
503      */
504     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
505         return _remove(set._inner, value);
506     }
507 
508     /**
509      * @dev Returns true if the value is in the set. O(1).
510      */
511     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
512         return _contains(set._inner, value);
513     }
514 
515     /**
516      * @dev Returns the number of values in the set. O(1).
517      */
518     function length(Bytes32Set storage set) internal view returns (uint256) {
519         return _length(set._inner);
520     }
521 
522     /**
523      * @dev Returns the value stored at position `index` in the set. O(1).
524     *
525     * Note that there are no guarantees on the ordering of values inside the
526     * array, and it may change when more values are added or removed.
527     *
528     * Requirements:
529     *
530     * - `index` must be strictly less than {length}.
531     */
532     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
533         return _at(set._inner, index);
534     }
535 
536     // AddressSet
537 
538     struct AddressSet {
539         Set _inner;
540     }
541 
542     /**
543      * @dev Add a value to a set. O(1).
544      *
545      * Returns true if the value was added to the set, that is if it was not
546      * already present.
547      */
548     function add(AddressSet storage set, address value) internal returns (bool) {
549         return _add(set._inner, bytes32(uint256(uint160(value))));
550     }
551 
552     /**
553      * @dev Removes a value from a set. O(1).
554      *
555      * Returns true if the value was removed from the set, that is if it was
556      * present.
557      */
558     function remove(AddressSet storage set, address value) internal returns (bool) {
559         return _remove(set._inner, bytes32(uint256(uint160(value))));
560     }
561 
562     /**
563      * @dev Returns true if the value is in the set. O(1).
564      */
565     function contains(AddressSet storage set, address value) internal view returns (bool) {
566         return _contains(set._inner, bytes32(uint256(uint160(value))));
567     }
568 
569     /**
570      * @dev Returns the number of values in the set. O(1).
571      */
572     function length(AddressSet storage set) internal view returns (uint256) {
573         return _length(set._inner);
574     }
575 
576     /**
577      * @dev Returns the value stored at position `index` in the set. O(1).
578     *
579     * Note that there are no guarantees on the ordering of values inside the
580     * array, and it may change when more values are added or removed.
581     *
582     * Requirements:
583     *
584     * - `index` must be strictly less than {length}.
585     */
586     function at(AddressSet storage set, uint256 index) internal view returns (address) {
587         return address(uint160(uint256(_at(set._inner, index))));
588     }
589 
590 
591     // UintSet
592 
593     struct UintSet {
594         Set _inner;
595     }
596 
597     /**
598      * @dev Add a value to a set. O(1).
599      *
600      * Returns true if the value was added to the set, that is if it was not
601      * already present.
602      */
603     function add(UintSet storage set, uint256 value) internal returns (bool) {
604         return _add(set._inner, bytes32(value));
605     }
606 
607     /**
608      * @dev Removes a value from a set. O(1).
609      *
610      * Returns true if the value was removed from the set, that is if it was
611      * present.
612      */
613     function remove(UintSet storage set, uint256 value) internal returns (bool) {
614         return _remove(set._inner, bytes32(value));
615     }
616 
617     /**
618      * @dev Returns true if the value is in the set. O(1).
619      */
620     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
621         return _contains(set._inner, bytes32(value));
622     }
623 
624     /**
625      * @dev Returns the number of values on the set. O(1).
626      */
627     function length(UintSet storage set) internal view returns (uint256) {
628         return _length(set._inner);
629     }
630 
631     /**
632      * @dev Returns the value stored at position `index` in the set. O(1).
633     *
634     * Note that there are no guarantees on the ordering of values inside the
635     * array, and it may change when more values are added or removed.
636     *
637     * Requirements:
638     *
639     * - `index` must be strictly less than {length}.
640     */
641     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
642         return uint256(_at(set._inner, index));
643     }
644 }
645 
646 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
647 
648 
649 
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @dev Collection of functions related to the address type
655  */
656 library Address {
657     /**
658      * @dev Returns true if `account` is a contract.
659      *
660      * [IMPORTANT]
661      * ====
662      * It is unsafe to assume that an address for which this function returns
663      * false is an externally-owned account (EOA) and not a contract.
664      *
665      * Among others, `isContract` will return false for the following
666      * types of addresses:
667      *
668      *  - an externally-owned account
669      *  - a contract in construction
670      *  - an address where a contract will be created
671      *  - an address where a contract lived, but was destroyed
672      * ====
673      */
674     function isContract(address account) internal view returns (bool) {
675         // This method relies on extcodesize, which returns 0 for contracts in
676         // construction, since the code is only stored at the end of the
677         // constructor execution.
678 
679         uint256 size;
680         // solhint-disable-next-line no-inline-assembly
681         assembly {size := extcodesize(account)}
682         return size > 0;
683     }
684 
685     /**
686      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
687      * `recipient`, forwarding all available gas and reverting on errors.
688      *
689      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
690      * of certain opcodes, possibly making contracts go over the 2300 gas limit
691      * imposed by `transfer`, making them unable to receive funds via
692      * `transfer`. {sendValue} removes this limitation.
693      *
694      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
695      *
696      * IMPORTANT: because control is transferred to `recipient`, care must be
697      * taken to not create reentrancy vulnerabilities. Consider using
698      * {ReentrancyGuard} or the
699      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
700      */
701     function sendValue(address payable recipient, uint256 amount) internal {
702         require(address(this).balance >= amount, "Address: insufficient balance");
703 
704         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
705         (bool success,) = recipient.call{value : amount}("");
706         require(success, "Address: unable to send value, recipient may have reverted");
707     }
708 
709     /**
710      * @dev Performs a Solidity function call using a low level `call`. A
711      * plain`call` is an unsafe replacement for a function call: use this
712      * function instead.
713      *
714      * If `target` reverts with a revert reason, it is bubbled up by this
715      * function (like regular Solidity function calls).
716      *
717      * Returns the raw returned data. To convert to the expected return value,
718      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
719      *
720      * Requirements:
721      *
722      * - `target` must be a contract.
723      * - calling `target` with `data` must not revert.
724      *
725      * _Available since v3.1._
726      */
727     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
728         return functionCall(target, data, "Address: low-level call failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
733      * `errorMessage` as a fallback revert reason when `target` reverts.
734      *
735      * _Available since v3.1._
736      */
737     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
738         return functionCallWithValue(target, data, 0, errorMessage);
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
743      * but also transferring `value` wei to `target`.
744      *
745      * Requirements:
746      *
747      * - the calling contract must have an ETH balance of at least `value`.
748      * - the called Solidity function must be `payable`.
749      *
750      * _Available since v3.1._
751      */
752     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
753         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
758      * with `errorMessage` as a fallback revert reason when `target` reverts.
759      *
760      * _Available since v3.1._
761      */
762     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
763         require(address(this).balance >= value, "Address: insufficient balance for call");
764         require(isContract(target), "Address: call to non-contract");
765 
766         // solhint-disable-next-line avoid-low-level-calls
767         (bool success, bytes memory returndata) = target.call{value : value}(data);
768         return _verifyCallResult(success, returndata, errorMessage);
769     }
770 
771     /**
772      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
773      * but performing a static call.
774      *
775      * _Available since v3.3._
776      */
777     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
778         return functionStaticCall(target, data, "Address: low-level static call failed");
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
783      * but performing a static call.
784      *
785      * _Available since v3.3._
786      */
787     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
788         require(isContract(target), "Address: static call to non-contract");
789 
790         // solhint-disable-next-line avoid-low-level-calls
791         (bool success, bytes memory returndata) = target.staticcall(data);
792         return _verifyCallResult(success, returndata, errorMessage);
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
797      * but performing a delegate call.
798      *
799      * _Available since v3.4._
800      */
801     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
802         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
803     }
804 
805     /**
806      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
807      * but performing a delegate call.
808      *
809      * _Available since v3.4._
810      */
811     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
812         require(isContract(target), "Address: delegate call to non-contract");
813 
814         // solhint-disable-next-line avoid-low-level-calls
815         (bool success, bytes memory returndata) = target.delegatecall(data);
816         return _verifyCallResult(success, returndata, errorMessage);
817     }
818 
819     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
820         if (success) {
821             return returndata;
822         } else {
823             // Look for revert reason and bubble it up if present
824             if (returndata.length > 0) {
825                 // The easiest way to bubble the revert reason is using memory via assembly
826 
827                 // solhint-disable-next-line no-inline-assembly
828                 assembly {
829                     let returndata_size := mload(returndata)
830                     revert(add(32, returndata), returndata_size)
831                 }
832             } else {
833                 revert(errorMessage);
834             }
835         }
836     }
837 }
838 
839 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
840 
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev Interface of the ERC165 standard, as defined in the
846  * https://eips.ethereum.org/EIPS/eip-165[EIP].
847  *
848  * Implementers can declare support of contract interfaces, which can then be
849  * queried by others ({ERC165Checker}).
850  *
851  * For an implementation, see {ERC165}.
852  */
853 interface IERC165 {
854     /**
855      * @dev Returns true if this contract implements the interface defined by
856      * `interfaceId`. See the corresponding
857      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
858      * to learn more about how these ids are created.
859      *
860      * This function call must use less than 30 000 gas.
861      */
862     function supportsInterface(bytes4 interfaceId) external view returns (bool);
863 }
864 
865 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
866 
867 
868 pragma solidity ^0.8.0;
869 
870 
871 /**
872  * @dev Implementation of the {IERC165} interface.
873  *
874  * Contracts may inherit from this and call {_registerInterface} to declare
875  * their support of an interface.
876  */
877 abstract contract ERC165 is IERC165 {
878     /**
879      * @dev Mapping of interface ids to whether or not it's supported.
880      */
881     mapping(bytes4 => bool) private _supportedInterfaces;
882 
883     constructor () {
884         // Derived contracts need only register support for their own interfaces,
885         // we register support for ERC165 itself here
886         _registerInterface(type(IERC165).interfaceId);
887     }
888 
889     /**
890      * @dev See {IERC165-supportsInterface}.
891      *
892      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
893      */
894     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
895         return _supportedInterfaces[interfaceId];
896     }
897 
898     /**
899      * @dev Registers the contract as an implementer of the interface defined by
900      * `interfaceId`. Support of the actual ERC165 interface is automatic and
901      * registering its interface id is not required.
902      *
903      * See {IERC165-supportsInterface}.
904      *
905      * Requirements:
906      *
907      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
908      */
909     function _registerInterface(bytes4 interfaceId) internal virtual {
910         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
911         _supportedInterfaces[interfaceId] = true;
912     }
913 }
914 
915 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
916 
917 
918 
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @dev Required interface of an ERC721 compliant contract.
925  */
926 interface IERC721 is IERC165 {
927     /**
928      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
929      */
930     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
931 
932     /**
933      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
934      */
935     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
936 
937     /**
938      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
939      */
940     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
941 
942     /**
943      * @dev Returns the number of tokens in ``owner``'s account.
944      */
945     function balanceOf(address owner) external view returns (uint256 balance);
946 
947     /**
948      * @dev Returns the owner of the `tokenId` token.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function ownerOf(uint256 tokenId) external view returns (address owner);
955 
956     /**
957      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
958      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
959      *
960      * Requirements:
961      *
962      * - `from` cannot be the zero address.
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must exist and be owned by `from`.
965      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
967      *
968      * Emits a {Transfer} event.
969      */
970     function safeTransferFrom(address from, address to, uint256 tokenId) external;
971 
972     /**
973      * @dev Transfers `tokenId` token from `from` to `to`.
974      *
975      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must be owned by `from`.
982      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
983      *
984      * Emits a {Transfer} event.
985      */
986     function transferFrom(address from, address to, uint256 tokenId) external;
987 
988     /**
989      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
990      * The approval is cleared when the token is transferred.
991      *
992      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
993      *
994      * Requirements:
995      *
996      * - The caller must own the token or be an approved operator.
997      * - `tokenId` must exist.
998      *
999      * Emits an {Approval} event.
1000      */
1001     function approve(address to, uint256 tokenId) external;
1002 
1003     /**
1004      * @dev Returns the account approved for `tokenId` token.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must exist.
1009      */
1010     function getApproved(uint256 tokenId) external view returns (address operator);
1011 
1012     /**
1013      * @dev Approve or remove `operator` as an operator for the caller.
1014      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1015      *
1016      * Requirements:
1017      *
1018      * - The `operator` cannot be the caller.
1019      *
1020      * Emits an {ApprovalForAll} event.
1021      */
1022     function setApprovalForAll(address operator, bool _approved) external;
1023 
1024     /**
1025      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1026      *
1027      * See {setApprovalForAll}
1028      */
1029     function isApprovedForAll(address owner, address operator) external view returns (bool);
1030 
1031     /**
1032       * @dev Safely transfers `tokenId` token from `from` to `to`.
1033       *
1034       * Requirements:
1035       *
1036       * - `from` cannot be the zero address.
1037       * - `to` cannot be the zero address.
1038       * - `tokenId` token must exist and be owned by `from`.
1039       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1040       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1041       *
1042       * Emits a {Transfer} event.
1043       */
1044     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1045 }
1046 
1047 
1048 pragma solidity ^0.8.0;
1049 
1050 /**
1051  * @title ERC721 token receiver interface
1052  * @dev Interface for any contract that wants to support safeTransfers
1053  * from ERC721 asset contracts.
1054  */
1055 interface IERC721Receiver {
1056     /**
1057      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1058      * by `operator` from `from`, this function is called.
1059      *
1060      * It must return its Solidity selector to confirm the token transfer.
1061      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1062      *
1063      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1064      */
1065     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1066 }
1067 
1068 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1069 
1070 
1071 
1072 
1073 pragma solidity ^0.8.0;
1074 
1075 
1076 /**
1077  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1078  * @dev See https://eips.ethereum.org/EIPS/eip-721
1079  */
1080 interface IERC721Enumerable is IERC721 {
1081 
1082     /**
1083      * @dev Returns the total amount of tokens stored by the contract.
1084      */
1085     function totalSupply() external view returns (uint256);
1086 
1087     /**
1088      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1089      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1090      */
1091     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1092 
1093     /**
1094      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1095      * Use along with {totalSupply} to enumerate all tokens.
1096      */
1097     function tokenByIndex(uint256 index) external view returns (uint256);
1098 }
1099 
1100 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1101 
1102 
1103 
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 
1108 /**
1109  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1110  * @dev See https://eips.ethereum.org/EIPS/eip-721
1111  */
1112 interface IERC721Metadata is IERC721 {
1113 
1114     /**
1115      * @dev Returns the token collection name.
1116      */
1117     function name() external view returns (string memory);
1118 
1119     /**
1120      * @dev Returns the token collection symbol.
1121      */
1122     function symbol() external view returns (string memory);
1123 
1124     /**
1125      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1126      */
1127     function tokenURI(uint256 tokenId) external view returns (string memory);
1128 }
1129 
1130 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1131 
1132 
1133 
1134 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1135 
1136 
1137 
1138 
1139 pragma solidity ^0.8.0;
1140 
1141 /*
1142  * @dev Provides information about the current execution context, including the
1143  * sender of the transaction and its data. While these are generally available
1144  * via msg.sender and msg.data, they should not be accessed in such a direct
1145  * manner, since when dealing with GSN meta-transactions the account sending and
1146  * paying for execution may not be the actual sender (as far as an application
1147  * is concerned).
1148  *
1149  * This contract is only required for intermediate, library-like contracts.
1150  */
1151 abstract contract Context {
1152     function _msgSender() internal view virtual returns (address) {
1153         return msg.sender;
1154     }
1155 
1156     function _msgData() internal view virtual returns (bytes calldata) {
1157         this;
1158         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
1193     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1194 
1195 
1196     // Enumerable mapping from token ids to their owners
1197     EnumerableMap.UintToAddressMap private _tokenOwners;
1198 
1199     // Mapping from token ID to approved address
1200     mapping(uint256 => address) private _tokenApprovals;
1201 
1202     // Mapping from owner to operator approvals
1203     mapping(address => mapping(address => bool)) private _operatorApprovals;
1204 
1205     // Token name
1206     string private _name;
1207 
1208     // Token symbol
1209     string private _symbol;
1210 
1211     // Optional mapping for token URIs
1212     mapping(uint256 => string) private _tokenURIs;
1213 
1214     // Base URI
1215     string private _baseURI;
1216 
1217     /**
1218      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1219      */
1220     constructor (string memory name_, string memory symbol_) {
1221         _name = name_;
1222         _symbol = symbol_;
1223 
1224         // register the supported interfaces to conform to ERC721 via ERC165
1225         _registerInterface(type(IERC721).interfaceId);
1226         _registerInterface(type(IERC721Metadata).interfaceId);
1227         _registerInterface(type(IERC721Enumerable).interfaceId);
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-balanceOf}.
1232      */
1233     function balanceOf(address owner) public view virtual override returns (uint256) {
1234         require(owner != address(0), "ERC721: balance query for the zero address");
1235         return _holderTokens[owner].length();
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-ownerOf}.
1240      */
1241     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1242         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-name}.
1247      */
1248     function name() public view virtual override returns (string memory) {
1249         return _name;
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Metadata-symbol}.
1254      */
1255     function symbol() public view virtual override returns (string memory) {
1256         return _symbol;
1257     }
1258 
1259     /**
1260      * @dev See {IERC721Metadata-tokenURI}.
1261      */
1262     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1263         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1264 
1265         string memory _tokenURI = _tokenURIs[tokenId];
1266         string memory base = baseURI();
1267 
1268         // If there is no base URI, return the token URI.
1269         if (bytes(base).length == 0) {
1270             return _tokenURI;
1271         }
1272         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1273         if (bytes(_tokenURI).length > 0) {
1274             return string(abi.encodePacked(base, _tokenURI));
1275         }
1276         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1277         return string(abi.encodePacked(base, tokenId.toString()));
1278     }
1279 
1280     /**
1281     * @dev Returns the base URI set via {_setBaseURI}. This will be
1282     * automatically added as a prefix in {tokenURI} to each token's URI, or
1283     * to the token ID if no specific URI is set for that token ID.
1284     */
1285     function baseURI() public view virtual returns (string memory) {
1286         return _baseURI;
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1291      */
1292     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1293         return _holderTokens[owner].at(index);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Enumerable-totalSupply}.
1298      */
1299     function totalSupply() public view virtual override returns (uint256) {
1300         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1301         return _tokenOwners.length();
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Enumerable-tokenByIndex}.
1306      */
1307     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1308         (uint256 tokenId,) = _tokenOwners.at(index);
1309         return tokenId;
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-approve}.
1314      */
1315     function approve(address to, uint256 tokenId) public virtual override {
1316         address owner = ERC721.ownerOf(tokenId);
1317         require(to != owner, "ERC721: approval to current owner");
1318 
1319         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1320             "ERC721: approve caller is not owner nor approved for all"
1321         );
1322 
1323         _approve(to, tokenId);
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-getApproved}.
1328      */
1329     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1330         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1331 
1332         return _tokenApprovals[tokenId];
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-setApprovalForAll}.
1337      */
1338     function setApprovalForAll(address operator, bool approved) public virtual override {
1339         require(operator != _msgSender(), "ERC721: approve to caller");
1340 
1341         _operatorApprovals[_msgSender()][operator] = approved;
1342         emit ApprovalForAll(_msgSender(), operator, approved);
1343     }
1344 
1345     /**
1346      * @dev See {IERC721-isApprovedForAll}.
1347      */
1348     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1349         return _operatorApprovals[owner][operator];
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-transferFrom}.
1354      */
1355     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1356         //solhint-disable-next-line max-line-length
1357         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1358 
1359         _transfer(from, to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-safeTransferFrom}.
1364      */
1365     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1366         safeTransferFrom(from, to, tokenId, "");
1367     }
1368 
1369     /**
1370      * @dev See {IERC721-safeTransferFrom}.
1371      */
1372     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1373         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1374         _safeTransfer(from, to, tokenId, _data);
1375     }
1376 
1377     /**
1378      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1379      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1380      *
1381      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1382      *
1383      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1384      * implement alternative mechanisms to perform token transfer, such as signature-based.
1385      *
1386      * Requirements:
1387      *
1388      * - `from` cannot be the zero address.
1389      * - `to` cannot be the zero address.
1390      * - `tokenId` token must exist and be owned by `from`.
1391      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1396         _transfer(from, to, tokenId);
1397         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1398     }
1399 
1400     /**
1401      * @dev Returns whether `tokenId` exists.
1402      *
1403      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1404      *
1405      * Tokens start existing when they are minted (`_mint`),
1406      * and stop existing when they are burned (`_burn`).
1407      */
1408     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1409         return _tokenOwners.contains(tokenId);
1410     }
1411 
1412     /**
1413      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      */
1419     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1420         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1421         address owner = ERC721.ownerOf(tokenId);
1422         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1423     }
1424 
1425     /**
1426      * @dev Safely mints `tokenId` and transfers it to `to`.
1427      *
1428      * Requirements:
1429      d*
1430      * - `tokenId` must not exist.
1431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function _safeMint(address to, uint256 tokenId) internal virtual {
1436         _safeMint(to, tokenId, "");
1437     }
1438 
1439     /**
1440      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1441      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1442      */
1443     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1444         _mint(to, tokenId);
1445         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1446     }
1447 
1448     /**
1449      * @dev Mints `tokenId` and transfers it to `to`.
1450      *
1451      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1452      *
1453      * Requirements:
1454      *
1455      * - `tokenId` must not exist.
1456      * - `to` cannot be the zero address.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _mint(address to, uint256 tokenId) internal virtual {
1461         require(to != address(0), "ERC721: mint to the zero address");
1462         require(!_exists(tokenId), "ERC721: token already minted");
1463 
1464         _beforeTokenTransfer(address(0), to, tokenId);
1465 
1466         _holderTokens[to].add(tokenId);
1467 
1468         _tokenOwners.set(tokenId, to);
1469 
1470         emit Transfer(address(0), to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev Destroys `tokenId`.
1475      * The approval is cleared when the token is burned.
1476      *
1477      * Requirements:
1478      *
1479      * - `tokenId` must exist.
1480      *
1481      * Emits a {Transfer} event.
1482      */
1483     function _burn(uint256 tokenId) internal virtual {
1484         address owner = ERC721.ownerOf(tokenId);
1485         // internal owner
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
1516         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1517         // internal owner
1518         require(to != address(0), "ERC721: transfer to the zero address");
1519 
1520         _beforeTokenTransfer(from, to, tokenId);
1521 
1522         // Clear approvals from the previous owner
1523         _approve(address(0), tokenId);
1524 
1525         _holderTokens[from].remove(tokenId);
1526         _holderTokens[to].add(tokenId);
1527 
1528         _tokenOwners.set(tokenId, to);
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
1564     private returns (bool)
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
1586         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1587         // internal owner
1588     }
1589 
1590     /**
1591      * @dev Hook that is called before any token transfer. This includes minting
1592      * and burning.
1593      *
1594      * Calling conditions:
1595      *
1596      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1597      * transferred to `to`.
1598      * - When `from` is zero, `tokenId` will be minted for `to`.
1599      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1600      * - `from` cannot be the zero address.
1601      * - `to` cannot be the zero address.
1602      *
1603      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1604      */
1605     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
1606 }
1607 
1608 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1609 
1610 pragma solidity ^0.8.0;
1611 
1612 /**
1613  * @dev Contract module which provides a basic access control mechanism, where
1614  * there is an account (an owner) that can be granted exclusive access to
1615  * specific functions.
1616  *
1617  * By default, the owner account will be the one that deploys the contract. This
1618  * can later be changed with {transferOwnership}.
1619  *
1620  * This module is used through inheritance. It will make available the modifier
1621  * `onlyOwner`, which can be applied to your functions to restrict their use to
1622  * the owner.
1623  */
1624 abstract contract Ownable is Context {
1625     address private _owner;
1626 
1627     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1628 
1629 
1630 
1631     /**
1632      * @dev Initializes the contract setting the deployer as the initial owner.
1633      */
1634     constructor () {
1635         address msgSender = _msgSender();
1636         _owner = msgSender;
1637         emit OwnershipTransferred(address(0), msgSender);
1638     }
1639 
1640     /**
1641      * @dev Returns the address of the current owner.
1642      */
1643     function owner() public view virtual returns (address) {
1644         return _owner;
1645     }
1646 
1647     /**
1648      * @dev Throws if called by any account other than the owner.
1649      */
1650     modifier onlyOwner() {
1651         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1652         _;
1653     }
1654 
1655     /**
1656      * @dev Leaves the contract without owner. It will not be possible to call
1657      * `onlyOwner` functions anymore. Can only be called by the current owner.
1658      *
1659      * NOTE: Renouncing ownership will leave the contract without an owner,
1660      * thereby removing any functionality that is only available to the owner.
1661      */
1662     function renounceOwnership() public virtual onlyOwner {
1663         emit OwnershipTransferred(_owner, address(0));
1664         _owner = address(0);
1665     }
1666 
1667     /**
1668      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1669      * Can only be called by the current owner.
1670      */
1671     function transferOwnership(address newOwner) public virtual onlyOwner {
1672         require(newOwner != address(0), "Ownable: new owner is the zero address");
1673         emit OwnershipTransferred(_owner, newOwner);
1674         _owner = newOwner;
1675     }
1676 }
1677 
1678 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
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
1699     unchecked {
1700         uint256 c = a + b;
1701         if (c < a) return (false, 0);
1702         return (true, c);
1703     }
1704     }
1705 
1706     /**
1707      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1708      *
1709      * _Available since v3.4._
1710      */
1711     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1712     unchecked {
1713         if (b > a) return (false, 0);
1714         return (true, a - b);
1715     }
1716     }
1717 
1718     /**
1719      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1720      *
1721      * _Available since v3.4._
1722      */
1723     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1724     unchecked {
1725         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1726         // benefit is lost if 'b' is also tested.
1727         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1728         if (a == 0) return (true, 0);
1729         uint256 c = a * b;
1730         if (c / a != b) return (false, 0);
1731         return (true, c);
1732     }
1733     }
1734 
1735     /**
1736      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1737      *
1738      * _Available since v3.4._
1739      */
1740     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1741     unchecked {
1742         if (b == 0) return (false, 0);
1743         return (true, a / b);
1744     }
1745     }
1746 
1747     /**
1748      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1749      *
1750      * _Available since v3.4._
1751      */
1752     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1753     unchecked {
1754         if (b == 0) return (false, 0);
1755         return (true, a % b);
1756     }
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
1845     unchecked {
1846         require(b <= a, errorMessage);
1847         return a - b;
1848     }
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
1868     unchecked {
1869         require(b > 0, errorMessage);
1870         return a / b;
1871     }
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
1890     unchecked {
1891         require(b > 0, errorMessage);
1892         return a % b;
1893     }
1894     }
1895 }
1896 
1897 pragma solidity ^0.8.0;
1898 
1899 // SPDX-License-Identifier: UNLICENSED
1900 
1901 contract Primera is ERC721, Ownable {
1902     using SafeMath for uint256;
1903     using Strings for uint256;
1904     uint public constant MAX_TOKENS = 400;
1905     bool public hasSaleStarted = false;
1906     mapping(uint256 => uint256) public creationDates;
1907     mapping(uint256 => address) public creators;
1908     string public METADATA_PROVENANCE_HASH = "";
1909     string public GENERATOR_ADDRESS = "https://mystudios.io/pieces/primera.php?number=";
1910     uint256 private price = 90000000000000000;
1911     mapping(uint256 => string) public script;
1912 
1913     constructor() ERC721("Primera by Mitchell and Yun", "PRMA")  {
1914         setBaseURI("https://mystudios.io/api/primera.php?number=");
1915         _safeMint(msg.sender, 0);
1916         creationDates[0] = block.number;
1917         creators[0] = msg.sender;
1918         price = 90000000000000000;
1919     }
1920 
1921     function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
1922         uint256 tokenCount = balanceOf(_owner);
1923         if (tokenCount == 0) {
1924             return new uint256[](0);
1925         } else {
1926             uint256[] memory result = new uint256[](tokenCount);
1927             uint256 index;
1928             for (index = 0; index < tokenCount; index++) {
1929                 result[index] = tokenOfOwnerByIndex(_owner, index);
1930             }
1931             return result;
1932         }
1933     }
1934 
1935     function getPrice() public view returns (uint256) {
1936         return price;
1937     }
1938 
1939     function mintToken(uint256 maxTOKENS) public payable {
1940         require(totalSupply() < MAX_TOKENS, "Sale has already ended");
1941         require(maxTOKENS > 0 && maxTOKENS <= 10, "You can claim minimum 1, maximum 10 tokens");
1942         require(totalSupply().add(maxTOKENS) <= MAX_TOKENS, "Exceeds MAX_TOKENS");
1943         require(msg.value >= getPrice().mul(maxTOKENS), "Ether value sent is below the price");
1944         
1945         for (uint i = 0; i < maxTOKENS; i++) {
1946             uint mintIndex = totalSupply();
1947             _safeMint(msg.sender, mintIndex);
1948             creationDates[mintIndex] = block.number;
1949             creators[mintIndex] = msg.sender;
1950         }
1951     }
1952 
1953     function addScriptChunk(uint256 index, string memory _chunk) public onlyOwner {
1954         script[index]=_chunk;
1955     }
1956 
1957     function getScriptChunk(uint256 index) public view returns (string memory){
1958         return script[index];
1959     }
1960 
1961     function removeScriptChunk(uint256 index) public onlyOwner {
1962         delete script[index];
1963     }
1964 
1965     function setProvenanceHash(string memory _hash) public onlyOwner {
1966         METADATA_PROVENANCE_HASH = _hash;
1967     }
1968 
1969     function setBaseURI(string memory baseURI) public onlyOwner {
1970         _setBaseURI(baseURI);
1971     }
1972 
1973     function startDrop() public onlyOwner {
1974         hasSaleStarted = true;
1975     }
1976 
1977     function setPrice(uint256 newPrice) public onlyOwner {
1978         price = newPrice;
1979     }
1980 
1981     function pauseDrop() public onlyOwner {
1982         hasSaleStarted = false;
1983     }
1984 
1985     function withdrawAll() public payable onlyOwner {
1986         require(payable(msg.sender).send(address(this).balance));
1987     }
1988 
1989     function tokenHash(uint256 tokenId) public view returns (bytes32){
1990         require(_exists(tokenId), "DOES NOT EXIST");
1991         return bytes32(keccak256(abi.encodePacked(address(this), creationDates[tokenId], creators[tokenId], tokenId)));
1992     }
1993 
1994     function generatorAddress(uint256 tokenId) public view returns (string memory) {
1995         require(_exists(tokenId), "DOES NOT EXIST");
1996         return string(abi.encodePacked(GENERATOR_ADDRESS, tokenId.toString()));
1997     }
1998 }