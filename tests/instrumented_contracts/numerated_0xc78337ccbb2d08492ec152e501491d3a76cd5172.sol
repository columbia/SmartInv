1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-07
3 */
4 
5 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant alphabet = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = alphabet[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 
75 }
76 
77 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
78 
79 
80 
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev Library for managing an enumerable variant of Solidity's
86  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
87  * type.
88  *
89  * Maps have the following properties:
90  *
91  * - Entries are added, removed, and checked for existence in constant time
92  * (O(1)).
93  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
94  *
95  * ```
96  * contract Example {
97  *     // Add the library methods
98  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
99  *
100  *     // Declare a set state variable
101  *     EnumerableMap.UintToAddressMap private myMap;
102  * }
103  * ```
104  *
105  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
106  * supported.
107  */
108 library EnumerableMap {
109     // To implement this library for multiple types with as little code
110     // repetition as possible, we write it in terms of a generic Map type with
111     // bytes32 keys and values.
112     // The Map implementation uses private functions, and user-facing
113     // implementations (such as Uint256ToAddressMap) are just wrappers around
114     // the underlying Map.
115     // This means that we can only create new EnumerableMaps for types that fit
116     // in bytes32.
117 
118     struct MapEntry {
119         bytes32 _key;
120         bytes32 _value;
121     }
122 
123     struct Map {
124         // Storage of map keys and values
125         MapEntry[] _entries;
126 
127         // Position of the entry defined by a key in the `entries` array, plus 1
128         // because index 0 means a key is not in the map.
129         mapping (bytes32 => uint256) _indexes;
130     }
131 
132     /**
133      * @dev Adds a key-value pair to a map, or updates the value for an existing
134      * key. O(1).
135      *
136      * Returns true if the key was added to the map, that is if it was not
137      * already present.
138      */
139     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
140         // We read and store the key's index to prevent multiple reads from the same storage slot
141         uint256 keyIndex = map._indexes[key];
142 
143         if (keyIndex == 0) { // Equivalent to !contains(map, key)
144             map._entries.push(MapEntry({ _key: key, _value: value }));
145             // The entry is stored at length-1, but we add 1 to all indexes
146             // and use 0 as a sentinel value
147             map._indexes[key] = map._entries.length;
148             return true;
149         } else {
150             map._entries[keyIndex - 1]._value = value;
151             return false;
152         }
153     }
154 
155     /**
156      * @dev Removes a key-value pair from a map. O(1).
157      *
158      * Returns true if the key was removed from the map, that is if it was present.
159      */
160     function _remove(Map storage map, bytes32 key) private returns (bool) {
161         // We read and store the key's index to prevent multiple reads from the same storage slot
162         uint256 keyIndex = map._indexes[key];
163 
164         if (keyIndex != 0) { // Equivalent to contains(map, key)
165             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
166             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
167             // This modifies the order of the array, as noted in {at}.
168 
169             uint256 toDeleteIndex = keyIndex - 1;
170             uint256 lastIndex = map._entries.length - 1;
171 
172             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
173             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
174 
175             MapEntry storage lastEntry = map._entries[lastIndex];
176 
177             // Move the last entry to the index where the entry to delete is
178             map._entries[toDeleteIndex] = lastEntry;
179             // Update the index for the moved entry
180             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
181 
182             // Delete the slot where the moved entry was stored
183             map._entries.pop();
184 
185             // Delete the index for the deleted slot
186             delete map._indexes[key];
187 
188             return true;
189         } else {
190             return false;
191         }
192     }
193 
194     /**
195      * @dev Returns true if the key is in the map. O(1).
196      */
197     function _contains(Map storage map, bytes32 key) private view returns (bool) {
198         return map._indexes[key] != 0;
199     }
200 
201     /**
202      * @dev Returns the number of key-value pairs in the map. O(1).
203      */
204     function _length(Map storage map) private view returns (uint256) {
205         return map._entries.length;
206     }
207 
208    /**
209     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
210     *
211     * Note that there are no guarantees on the ordering of entries inside the
212     * array, and it may change when more entries are added or removed.
213     *
214     * Requirements:
215     *
216     * - `index` must be strictly less than {length}.
217     */
218     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
219         require(map._entries.length > index, "EnumerableMap: index out of bounds");
220 
221         MapEntry storage entry = map._entries[index];
222         return (entry._key, entry._value);
223     }
224 
225     /**
226      * @dev Tries to returns the value associated with `key`.  O(1).
227      * Does not revert if `key` is not in the map.
228      */
229     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
230         uint256 keyIndex = map._indexes[key];
231         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
232         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
233     }
234 
235     /**
236      * @dev Returns the value associated with `key`.  O(1).
237      *
238      * Requirements:
239      *
240      * - `key` must be in the map.
241      */
242     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
243         uint256 keyIndex = map._indexes[key];
244         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
245         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
246     }
247 
248     /**
249      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
250      *
251      * CAUTION: This function is deprecated because it requires allocating memory for the error
252      * message unnecessarily. For custom revert reasons use {_tryGet}.
253      */
254     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
255         uint256 keyIndex = map._indexes[key];
256         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
257         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
258     }
259 
260     // UintToAddressMap
261 
262     struct UintToAddressMap {
263         Map _inner;
264     }
265 
266     /**
267      * @dev Adds a key-value pair to a map, or updates the value for an existing
268      * key. O(1).
269      *
270      * Returns true if the key was added to the map, that is if it was not
271      * already present.
272      */
273     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
274         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
275     }
276 
277     /**
278      * @dev Removes a value from a set. O(1).
279      *
280      * Returns true if the key was removed from the map, that is if it was present.
281      */
282     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
283         return _remove(map._inner, bytes32(key));
284     }
285 
286     /**
287      * @dev Returns true if the key is in the map. O(1).
288      */
289     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
290         return _contains(map._inner, bytes32(key));
291     }
292 
293     /**
294      * @dev Returns the number of elements in the map. O(1).
295      */
296     function length(UintToAddressMap storage map) internal view returns (uint256) {
297         return _length(map._inner);
298     }
299 
300    /**
301     * @dev Returns the element stored at position `index` in the set. O(1).
302     * Note that there are no guarantees on the ordering of values inside the
303     * array, and it may change when more values are added or removed.
304     *
305     * Requirements:
306     *
307     * - `index` must be strictly less than {length}.
308     */
309     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
310         (bytes32 key, bytes32 value) = _at(map._inner, index);
311         return (uint256(key), address(uint160(uint256(value))));
312     }
313 
314     /**
315      * @dev Tries to returns the value associated with `key`.  O(1).
316      * Does not revert if `key` is not in the map.
317      *
318      * _Available since v3.4._
319      */
320     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
321         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
322         return (success, address(uint160(uint256(value))));
323     }
324 
325     /**
326      * @dev Returns the value associated with `key`.  O(1).
327      *
328      * Requirements:
329      *
330      * - `key` must be in the map.
331      */
332     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
333         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
334     }
335 
336     /**
337      * @dev Same as {get}, with a custom error message when `key` is not in the map.
338      *
339      * CAUTION: This function is deprecated because it requires allocating memory for the error
340      * message unnecessarily. For custom revert reasons use {tryGet}.
341      */
342     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
343         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
344     }
345 }
346 
347 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
348 
349 
350 
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Library for managing
356  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
357  * types.
358  *
359  * Sets have the following properties:
360  *
361  * - Elements are added, removed, and checked for existence in constant time
362  * (O(1)).
363  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
364  *
365  * ```
366  * contract Example {
367  *     // Add the library methods
368  *     using EnumerableSet for EnumerableSet.AddressSet;
369  *
370  *     // Declare a set state variable
371  *     EnumerableSet.AddressSet private mySet;
372  * }
373  * ```
374  *
375  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
376  * and `uint256` (`UintSet`) are supported.
377  */
378 library EnumerableSet {
379     // To implement this library for multiple types with as little code
380     // repetition as possible, we write it in terms of a generic Set type with
381     // bytes32 values.
382     // The Set implementation uses private functions, and user-facing
383     // implementations (such as AddressSet) are just wrappers around the
384     // underlying Set.
385     // This means that we can only create new EnumerableSets for types that fit
386     // in bytes32.
387 
388     struct Set {
389         // Storage of set values
390         bytes32[] _values;
391 
392         // Position of the value in the `values` array, plus 1 because index 0
393         // means a value is not in the set.
394         mapping (bytes32 => uint256) _indexes;
395     }
396 
397     /**
398      * @dev Add a value to a set. O(1).
399      *
400      * Returns true if the value was added to the set, that is if it was not
401      * already present.
402      */
403     function _add(Set storage set, bytes32 value) private returns (bool) {
404         if (!_contains(set, value)) {
405             set._values.push(value);
406             // The value is stored at length-1, but we add 1 to all indexes
407             // and use 0 as a sentinel value
408             set._indexes[value] = set._values.length;
409             return true;
410         } else {
411             return false;
412         }
413     }
414 
415     /**
416      * @dev Removes a value from a set. O(1).
417      *
418      * Returns true if the value was removed from the set, that is if it was
419      * present.
420      */
421     function _remove(Set storage set, bytes32 value) private returns (bool) {
422         // We read and store the value's index to prevent multiple reads from the same storage slot
423         uint256 valueIndex = set._indexes[value];
424 
425         if (valueIndex != 0) { // Equivalent to contains(set, value)
426             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
427             // the array, and then remove the last element (sometimes called as 'swap and pop').
428             // This modifies the order of the array, as noted in {at}.
429 
430             uint256 toDeleteIndex = valueIndex - 1;
431             uint256 lastIndex = set._values.length - 1;
432 
433             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
434             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
435 
436             bytes32 lastvalue = set._values[lastIndex];
437 
438             // Move the last value to the index where the value to delete is
439             set._values[toDeleteIndex] = lastvalue;
440             // Update the index for the moved value
441             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
442 
443             // Delete the slot where the moved value was stored
444             set._values.pop();
445 
446             // Delete the index for the deleted slot
447             delete set._indexes[value];
448 
449             return true;
450         } else {
451             return false;
452         }
453     }
454 
455     /**
456      * @dev Returns true if the value is in the set. O(1).
457      */
458     function _contains(Set storage set, bytes32 value) private view returns (bool) {
459         return set._indexes[value] != 0;
460     }
461 
462     /**
463      * @dev Returns the number of values on the set. O(1).
464      */
465     function _length(Set storage set) private view returns (uint256) {
466         return set._values.length;
467     }
468 
469    /**
470     * @dev Returns the value stored at position `index` in the set. O(1).
471     *
472     * Note that there are no guarantees on the ordering of values inside the
473     * array, and it may change when more values are added or removed.
474     *
475     * Requirements:
476     *
477     * - `index` must be strictly less than {length}.
478     */
479     function _at(Set storage set, uint256 index) private view returns (bytes32) {
480         require(set._values.length > index, "EnumerableSet: index out of bounds");
481         return set._values[index];
482     }
483 
484     // Bytes32Set
485 
486     struct Bytes32Set {
487         Set _inner;
488     }
489 
490     /**
491      * @dev Add a value to a set. O(1).
492      *
493      * Returns true if the value was added to the set, that is if it was not
494      * already present.
495      */
496     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
497         return _add(set._inner, value);
498     }
499 
500     /**
501      * @dev Removes a value from a set. O(1).
502      *
503      * Returns true if the value was removed from the set, that is if it was
504      * present.
505      */
506     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
507         return _remove(set._inner, value);
508     }
509 
510     /**
511      * @dev Returns true if the value is in the set. O(1).
512      */
513     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
514         return _contains(set._inner, value);
515     }
516 
517     /**
518      * @dev Returns the number of values in the set. O(1).
519      */
520     function length(Bytes32Set storage set) internal view returns (uint256) {
521         return _length(set._inner);
522     }
523 
524    /**
525     * @dev Returns the value stored at position `index` in the set. O(1).
526     *
527     * Note that there are no guarantees on the ordering of values inside the
528     * array, and it may change when more values are added or removed.
529     *
530     * Requirements:
531     *
532     * - `index` must be strictly less than {length}.
533     */
534     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
535         return _at(set._inner, index);
536     }
537 
538     // AddressSet
539 
540     struct AddressSet {
541         Set _inner;
542     }
543 
544     /**
545      * @dev Add a value to a set. O(1).
546      *
547      * Returns true if the value was added to the set, that is if it was not
548      * already present.
549      */
550     function add(AddressSet storage set, address value) internal returns (bool) {
551         return _add(set._inner, bytes32(uint256(uint160(value))));
552     }
553 
554     /**
555      * @dev Removes a value from a set. O(1).
556      *
557      * Returns true if the value was removed from the set, that is if it was
558      * present.
559      */
560     function remove(AddressSet storage set, address value) internal returns (bool) {
561         return _remove(set._inner, bytes32(uint256(uint160(value))));
562     }
563 
564     /**
565      * @dev Returns true if the value is in the set. O(1).
566      */
567     function contains(AddressSet storage set, address value) internal view returns (bool) {
568         return _contains(set._inner, bytes32(uint256(uint160(value))));
569     }
570 
571     /**
572      * @dev Returns the number of values in the set. O(1).
573      */
574     function length(AddressSet storage set) internal view returns (uint256) {
575         return _length(set._inner);
576     }
577 
578    /**
579     * @dev Returns the value stored at position `index` in the set. O(1).
580     *
581     * Note that there are no guarantees on the ordering of values inside the
582     * array, and it may change when more values are added or removed.
583     *
584     * Requirements:
585     *
586     * - `index` must be strictly less than {length}.
587     */
588     function at(AddressSet storage set, uint256 index) internal view returns (address) {
589         return address(uint160(uint256(_at(set._inner, index))));
590     }
591 
592 
593     // UintSet
594 
595     struct UintSet {
596         Set _inner;
597     }
598 
599     /**
600      * @dev Add a value to a set. O(1).
601      *
602      * Returns true if the value was added to the set, that is if it was not
603      * already present.
604      */
605     function add(UintSet storage set, uint256 value) internal returns (bool) {
606         return _add(set._inner, bytes32(value));
607     }
608 
609     /**
610      * @dev Removes a value from a set. O(1).
611      *
612      * Returns true if the value was removed from the set, that is if it was
613      * present.
614      */
615     function remove(UintSet storage set, uint256 value) internal returns (bool) {
616         return _remove(set._inner, bytes32(value));
617     }
618 
619     /**
620      * @dev Returns true if the value is in the set. O(1).
621      */
622     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
623         return _contains(set._inner, bytes32(value));
624     }
625 
626     /**
627      * @dev Returns the number of values on the set. O(1).
628      */
629     function length(UintSet storage set) internal view returns (uint256) {
630         return _length(set._inner);
631     }
632 
633    /**
634     * @dev Returns the value stored at position `index` in the set. O(1).
635     *
636     * Note that there are no guarantees on the ordering of values inside the
637     * array, and it may change when more values are added or removed.
638     *
639     * Requirements:
640     *
641     * - `index` must be strictly less than {length}.
642     */
643     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
644         return uint256(_at(set._inner, index));
645     }
646 }
647 
648 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
649 
650 
651 
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @dev Collection of functions related to the address type
657  */
658 library Address {
659     /**
660      * @dev Returns true if `account` is a contract.
661      *
662      * [IMPORTANT]
663      * ====
664      * It is unsafe to assume that an address for which this function returns
665      * false is an externally-owned account (EOA) and not a contract.
666      *
667      * Among others, `isContract` will return false for the following
668      * types of addresses:
669      *
670      *  - an externally-owned account
671      *  - a contract in construction
672      *  - an address where a contract will be created
673      *  - an address where a contract lived, but was destroyed
674      * ====
675      */
676     function isContract(address account) internal view returns (bool) {
677         // This method relies on extcodesize, which returns 0 for contracts in
678         // construction, since the code is only stored at the end of the
679         // constructor execution.
680 
681         uint256 size;
682         // solhint-disable-next-line no-inline-assembly
683         assembly { size := extcodesize(account) }
684         return size > 0;
685     }
686 
687     /**
688      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
689      * `recipient`, forwarding all available gas and reverting on errors.
690      *
691      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
692      * of certain opcodes, possibly making contracts go over the 2300 gas limit
693      * imposed by `transfer`, making them unable to receive funds via
694      * `transfer`. {sendValue} removes this limitation.
695      *
696      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
697      *
698      * IMPORTANT: because control is transferred to `recipient`, care must be
699      * taken to not create reentrancy vulnerabilities. Consider using
700      * {ReentrancyGuard} or the
701      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
702      */
703     function sendValue(address payable recipient, uint256 amount) internal {
704         require(address(this).balance >= amount, "Address: insufficient balance");
705 
706         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
707         (bool success, ) = recipient.call{ value: amount }("");
708         require(success, "Address: unable to send value, recipient may have reverted");
709     }
710 
711     /**
712      * @dev Performs a Solidity function call using a low level `call`. A
713      * plain`call` is an unsafe replacement for a function call: use this
714      * function instead.
715      *
716      * If `target` reverts with a revert reason, it is bubbled up by this
717      * function (like regular Solidity function calls).
718      *
719      * Returns the raw returned data. To convert to the expected return value,
720      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
721      *
722      * Requirements:
723      *
724      * - `target` must be a contract.
725      * - calling `target` with `data` must not revert.
726      *
727      * _Available since v3.1._
728      */
729     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
730       return functionCall(target, data, "Address: low-level call failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
735      * `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
740         return functionCallWithValue(target, data, 0, errorMessage);
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
745      * but also transferring `value` wei to `target`.
746      *
747      * Requirements:
748      *
749      * - the calling contract must have an ETH balance of at least `value`.
750      * - the called Solidity function must be `payable`.
751      *
752      * _Available since v3.1._
753      */
754     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
755         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
760      * with `errorMessage` as a fallback revert reason when `target` reverts.
761      *
762      * _Available since v3.1._
763      */
764     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
765         require(address(this).balance >= value, "Address: insufficient balance for call");
766         require(isContract(target), "Address: call to non-contract");
767 
768         // solhint-disable-next-line avoid-low-level-calls
769         (bool success, bytes memory returndata) = target.call{ value: value }(data);
770         return _verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
780         return functionStaticCall(target, data, "Address: low-level static call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
785      * but performing a static call.
786      *
787      * _Available since v3.3._
788      */
789     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
790         require(isContract(target), "Address: static call to non-contract");
791 
792         // solhint-disable-next-line avoid-low-level-calls
793         (bool success, bytes memory returndata) = target.staticcall(data);
794         return _verifyCallResult(success, returndata, errorMessage);
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
799      * but performing a delegate call.
800      *
801      * _Available since v3.4._
802      */
803     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
804         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
809      * but performing a delegate call.
810      *
811      * _Available since v3.4._
812      */
813     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
814         require(isContract(target), "Address: delegate call to non-contract");
815 
816         // solhint-disable-next-line avoid-low-level-calls
817         (bool success, bytes memory returndata) = target.delegatecall(data);
818         return _verifyCallResult(success, returndata, errorMessage);
819     }
820 
821     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
822         if (success) {
823             return returndata;
824         } else {
825             // Look for revert reason and bubble it up if present
826             if (returndata.length > 0) {
827                 // The easiest way to bubble the revert reason is using memory via assembly
828 
829                 // solhint-disable-next-line no-inline-assembly
830                 assembly {
831                     let returndata_size := mload(returndata)
832                     revert(add(32, returndata), returndata_size)
833                 }
834             } else {
835                 revert(errorMessage);
836             }
837         }
838     }
839 }
840 
841 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
842 
843 
844 pragma solidity ^0.8.0;
845 
846 /**
847  * @dev Interface of the ERC165 standard, as defined in the
848  * https://eips.ethereum.org/EIPS/eip-165[EIP].
849  *
850  * Implementers can declare support of contract interfaces, which can then be
851  * queried by others ({ERC165Checker}).
852  *
853  * For an implementation, see {ERC165}.
854  */
855 interface IERC165 {
856     /**
857      * @dev Returns true if this contract implements the interface defined by
858      * `interfaceId`. See the corresponding
859      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
860      * to learn more about how these ids are created.
861      *
862      * This function call must use less than 30 000 gas.
863      */
864     function supportsInterface(bytes4 interfaceId) external view returns (bool);
865 }
866 
867 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
868 
869 
870 pragma solidity ^0.8.0;
871 
872 
873 /**
874  * @dev Implementation of the {IERC165} interface.
875  *
876  * Contracts may inherit from this and call {_registerInterface} to declare
877  * their support of an interface.
878  */
879 abstract contract ERC165 is IERC165 {
880     /**
881      * @dev Mapping of interface ids to whether or not it's supported.
882      */
883     mapping(bytes4 => bool) private _supportedInterfaces;
884 
885     constructor () {
886         // Derived contracts need only register support for their own interfaces,
887         // we register support for ERC165 itself here
888         _registerInterface(type(IERC165).interfaceId);
889     }
890 
891     /**
892      * @dev See {IERC165-supportsInterface}.
893      *
894      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
895      */
896     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
897         return _supportedInterfaces[interfaceId];
898     }
899 
900     /**
901      * @dev Registers the contract as an implementer of the interface defined by
902      * `interfaceId`. Support of the actual ERC165 interface is automatic and
903      * registering its interface id is not required.
904      *
905      * See {IERC165-supportsInterface}.
906      *
907      * Requirements:
908      *
909      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
910      */
911     function _registerInterface(bytes4 interfaceId) internal virtual {
912         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
913         _supportedInterfaces[interfaceId] = true;
914     }
915 }
916 
917 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
918 
919 
920 
921 
922 pragma solidity ^0.8.0;
923 
924 
925 /**
926  * @dev Required interface of an ERC721 compliant contract.
927  */
928 interface IERC721 is IERC165 {
929     /**
930      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
931      */
932     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
933 
934     /**
935      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
936      */
937     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
938 
939     /**
940      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
941      */
942     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
943 
944     /**
945      * @dev Returns the number of tokens in ``owner``'s account.
946      */
947     function balanceOf(address owner) external view returns (uint256 balance);
948 
949     /**
950      * @dev Returns the owner of the `tokenId` token.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function ownerOf(uint256 tokenId) external view returns (address owner);
957 
958     /**
959      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
960      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
961      *
962      * Requirements:
963      *
964      * - `from` cannot be the zero address.
965      * - `to` cannot be the zero address.
966      * - `tokenId` token must exist and be owned by `from`.
967      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function safeTransferFrom(address from, address to, uint256 tokenId) external;
973 
974     /**
975      * @dev Transfers `tokenId` token from `from` to `to`.
976      *
977      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
978      *
979      * Requirements:
980      *
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must be owned by `from`.
984      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
985      *
986      * Emits a {Transfer} event.
987      */
988     function transferFrom(address from, address to, uint256 tokenId) external;
989 
990     /**
991      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
992      * The approval is cleared when the token is transferred.
993      *
994      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
995      *
996      * Requirements:
997      *
998      * - The caller must own the token or be an approved operator.
999      * - `tokenId` must exist.
1000      *
1001      * Emits an {Approval} event.
1002      */
1003     function approve(address to, uint256 tokenId) external;
1004 
1005     /**
1006      * @dev Returns the account approved for `tokenId` token.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      */
1012     function getApproved(uint256 tokenId) external view returns (address operator);
1013 
1014     /**
1015      * @dev Approve or remove `operator` as an operator for the caller.
1016      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1017      *
1018      * Requirements:
1019      *
1020      * - The `operator` cannot be the caller.
1021      *
1022      * Emits an {ApprovalForAll} event.
1023      */
1024     function setApprovalForAll(address operator, bool _approved) external;
1025 
1026     /**
1027      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1028      *
1029      * See {setApprovalForAll}
1030      */
1031     function isApprovedForAll(address owner, address operator) external view returns (bool);
1032 
1033     /**
1034       * @dev Safely transfers `tokenId` token from `from` to `to`.
1035       *
1036       * Requirements:
1037       *
1038       * - `from` cannot be the zero address.
1039       * - `to` cannot be the zero address.
1040       * - `tokenId` token must exist and be owned by `from`.
1041       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1042       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1043       *
1044       * Emits a {Transfer} event.
1045       */
1046     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1047 }
1048 
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 /**
1053  * @title ERC721 token receiver interface
1054  * @dev Interface for any contract that wants to support safeTransfers
1055  * from ERC721 asset contracts.
1056  */
1057 interface IERC721Receiver {
1058     /**
1059      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1060      * by `operator` from `from`, this function is called.
1061      *
1062      * It must return its Solidity selector to confirm the token transfer.
1063      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1064      *
1065      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1066      */
1067     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1068 }
1069 
1070 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1071 
1072 
1073 
1074 
1075 pragma solidity ^0.8.0;
1076 
1077 
1078 /**
1079  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1080  * @dev See https://eips.ethereum.org/EIPS/eip-721
1081  */
1082 interface IERC721Enumerable is IERC721 {
1083 
1084     /**
1085      * @dev Returns the total amount of tokens stored by the contract.
1086      */
1087     function totalSupply() external view returns (uint256);
1088 
1089     /**
1090      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1091      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1092      */
1093     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1094 
1095     /**
1096      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1097      * Use along with {totalSupply} to enumerate all tokens.
1098      */
1099     function tokenByIndex(uint256 index) external view returns (uint256);
1100 }
1101 
1102 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1103 
1104 
1105 
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Metadata is IERC721 {
1115 
1116     /**
1117      * @dev Returns the token collection name.
1118      */
1119     function name() external view returns (string memory);
1120 
1121     /**
1122      * @dev Returns the token collection symbol.
1123      */
1124     function symbol() external view returns (string memory);
1125 
1126     /**
1127      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1128      */
1129     function tokenURI(uint256 tokenId) external view returns (string memory);
1130 }
1131 
1132 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1133 
1134 
1135 
1136 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1137 
1138 
1139 
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 /*
1144  * @dev Provides information about the current execution context, including the
1145  * sender of the transaction and its data. While these are generally available
1146  * via msg.sender and msg.data, they should not be accessed in such a direct
1147  * manner, since when dealing with GSN meta-transactions the account sending and
1148  * paying for execution may not be the actual sender (as far as an application
1149  * is concerned).
1150  *
1151  * This contract is only required for intermediate, library-like contracts.
1152  */
1153 abstract contract Context {
1154     function _msgSender() internal view virtual returns (address) {
1155         return msg.sender;
1156     }
1157 
1158     function _msgData() internal view virtual returns (bytes calldata) {
1159         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1160         return msg.data;
1161     }
1162 }
1163 
1164 
1165 
1166 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1167 
1168 
1169 
1170 
1171 pragma solidity ^0.8.0;
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
1182 
1183 /**
1184  * @title ERC721 Non-Fungible Token Standard basic implementation
1185  * @dev see https://eips.ethereum.org/EIPS/eip-721
1186  */
1187 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1188     using Address for address;
1189     using EnumerableSet for EnumerableSet.UintSet;
1190     using EnumerableMap for EnumerableMap.UintToAddressMap;
1191     using Strings for uint256;
1192 
1193     // Mapping from holder address to their (enumerable) set of owned tokens
1194     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1195 
1196     // Enumerable mapping from token ids to their owners
1197     EnumerableMap.UintToAddressMap private _tokenOwners;
1198 
1199     // Mapping from token ID to approved address
1200     mapping (uint256 => address) private _tokenApprovals;
1201 
1202     // Mapping from owner to operator approvals
1203     mapping (address => mapping (address => bool)) private _operatorApprovals;
1204 
1205     // Token name
1206     string private _name;
1207 
1208     // Token symbol
1209     string private _symbol;
1210 
1211     // Optional mapping for token URIs
1212     mapping (uint256 => string) private _tokenURIs;
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
1238 
1239     
1240     /**
1241      * @dev See {IERC721-ownerOf}.
1242      */
1243     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1244         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1245     }
1246 
1247     /**
1248      * @dev See {IERC721Metadata-name}.
1249      */
1250     function name() public view virtual override returns (string memory) {
1251         return _name;
1252     }
1253 
1254     /**
1255      * @dev See {IERC721Metadata-symbol}.
1256      */
1257     function symbol() public view virtual override returns (string memory) {
1258         return _symbol;
1259     }
1260 
1261     /**
1262      * @dev See {IERC721Metadata-tokenURI}.
1263      */
1264     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1265         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1266 
1267         string memory _tokenURI = _tokenURIs[tokenId];
1268         string memory base = baseURI();
1269 
1270         // If there is no base URI, return the token URI.
1271         if (bytes(base).length == 0) {
1272             return _tokenURI;
1273         }
1274         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1275         if (bytes(_tokenURI).length > 0) {
1276             return string(abi.encodePacked(base, _tokenURI));
1277         }
1278         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1279         return string(abi.encodePacked(base, tokenId.toString()));
1280     }
1281 
1282     /**
1283     * @dev Returns the base URI set via {_setBaseURI}. This will be
1284     * automatically added as a prefix in {tokenURI} to each token's URI, or
1285     * to the token ID if no specific URI is set for that token ID.
1286     */
1287     function baseURI() public view virtual returns (string memory) {
1288         return _baseURI;
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1293      */
1294     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1295         return _holderTokens[owner].at(index);
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Enumerable-totalSupply}.
1300      */
1301     function totalSupply() public view virtual override returns (uint256) {
1302         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1303         return _tokenOwners.length();
1304     }
1305 
1306     /**
1307      * @dev See {IERC721Enumerable-tokenByIndex}.
1308      */
1309     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1310         (uint256 tokenId, ) = _tokenOwners.at(index);
1311         return tokenId;
1312     }
1313 
1314     /**
1315      * @dev See {IERC721-approve}.
1316      */
1317     function approve(address to, uint256 tokenId) public virtual override {
1318         address owner = ERC721.ownerOf(tokenId);
1319         require(to != owner, "ERC721: approval to current owner");
1320 
1321         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1322             "ERC721: approve caller is not owner nor approved for all"
1323         );
1324 
1325         _approve(to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-getApproved}.
1330      */
1331     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1332         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1333 
1334         return _tokenApprovals[tokenId];
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-setApprovalForAll}.
1339      */
1340     function setApprovalForAll(address operator, bool approved) public virtual override {
1341         require(operator != _msgSender(), "ERC721: approve to caller");
1342 
1343         _operatorApprovals[_msgSender()][operator] = approved;
1344         emit ApprovalForAll(_msgSender(), operator, approved);
1345     }
1346 
1347     /**
1348      * @dev See {IERC721-isApprovedForAll}.
1349      */
1350     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1351         return _operatorApprovals[owner][operator];
1352     }
1353 
1354     /**
1355      * @dev See {IERC721-transferFrom}.
1356      */
1357     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1358         //solhint-disable-next-line max-line-length
1359         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1360 
1361         _transfer(from, to, tokenId);
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-safeTransferFrom}.
1366      */
1367     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1368         safeTransferFrom(from, to, tokenId, "");
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-safeTransferFrom}.
1373      */
1374     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1375         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1376         _safeTransfer(from, to, tokenId, _data);
1377     }
1378 
1379     /**
1380      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1381      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1382      *
1383      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1384      *
1385      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1386      * implement alternative mechanisms to perform token transfer, such as signature-based.
1387      *
1388      * Requirements:
1389      *
1390      * - `from` cannot be the zero address.
1391      * - `to` cannot be the zero address.
1392      * - `tokenId` token must exist and be owned by `from`.
1393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1398         _transfer(from, to, tokenId);
1399         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1400     }
1401 
1402     /**
1403      * @dev Returns whether `tokenId` exists.
1404      *
1405      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1406      *
1407      * Tokens start existing when they are minted (`_mint`),
1408      * and stop existing when they are burned (`_burn`).
1409      */
1410     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1411         return _tokenOwners.contains(tokenId);
1412     }
1413 
1414     /**
1415      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1416      *
1417      * Requirements:
1418      *
1419      * - `tokenId` must exist.
1420      */
1421     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1422         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1423         address owner = ERC721.ownerOf(tokenId);
1424         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1425     }
1426 
1427     /**
1428      * @dev Safely mints `tokenId` and transfers it to `to`.
1429      *
1430      * Requirements:
1431      d*
1432      * - `tokenId` must not exist.
1433      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1434      *
1435      * Emits a {Transfer} event.
1436      */
1437     function _safeMint(address to, uint256 tokenId) internal virtual {
1438         _safeMint(to, tokenId, "");
1439     }
1440 
1441     /**
1442      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1443      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1444      */
1445     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1446         _mint(to, tokenId);
1447         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1448     }
1449 
1450     /**
1451      * @dev Mints `tokenId` and transfers it to `to`.
1452      *
1453      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1454      *
1455      * Requirements:
1456      *
1457      * - `tokenId` must not exist.
1458      * - `to` cannot be the zero address.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _mint(address to, uint256 tokenId) internal virtual {
1463         require(to != address(0), "ERC721: mint to the zero address");
1464         require(!_exists(tokenId), "ERC721: token already minted");
1465 
1466         _beforeTokenTransfer(address(0), to, tokenId);
1467 
1468         _holderTokens[to].add(tokenId);
1469 
1470         _tokenOwners.set(tokenId, to);
1471 
1472         emit Transfer(address(0), to, tokenId);
1473     }
1474 
1475     /**
1476      * @dev Destroys `tokenId`.
1477      * The approval is cleared when the token is burned.
1478      *
1479      * Requirements:
1480      *
1481      * - `tokenId` must exist.
1482      *
1483      * Emits a {Transfer} event.
1484      */
1485     function _burn(uint256 tokenId) internal virtual {
1486         address owner = ERC721.ownerOf(tokenId); // internal owner
1487 
1488         _beforeTokenTransfer(owner, address(0), tokenId);
1489 
1490         // Clear approvals
1491         _approve(address(0), tokenId);
1492 
1493         // Clear metadata (if any)
1494         if (bytes(_tokenURIs[tokenId]).length != 0) {
1495             delete _tokenURIs[tokenId];
1496         }
1497 
1498         _holderTokens[owner].remove(tokenId);
1499 
1500         _tokenOwners.remove(tokenId);
1501 
1502         emit Transfer(owner, address(0), tokenId);
1503     }
1504 
1505     /**
1506      * @dev Transfers `tokenId` from `from` to `to`.
1507      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1508      *
1509      * Requirements:
1510      *
1511      * - `to` cannot be the zero address.
1512      * - `tokenId` token must be owned by `from`.
1513      *
1514      * Emits a {Transfer} event.
1515      */
1516     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1517         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
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
1529 
1530         emit Transfer(from, to, tokenId);
1531     }
1532 
1533     /**
1534      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1535      *
1536      * Requirements:
1537      *
1538      * - `tokenId` must exist.
1539      */
1540     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1541         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1542         _tokenURIs[tokenId] = _tokenURI;
1543     }
1544 
1545     /**
1546      * @dev Internal function to set the base URI for all token IDs. It is
1547      * automatically added as a prefix to the value returned in {tokenURI},
1548      * or to the token ID if {tokenURI} is empty.
1549      */
1550     function _setBaseURI(string memory baseURI_) internal virtual {
1551         _baseURI = baseURI_;
1552     }
1553 
1554     /**
1555      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1556      * The call is not executed if the target address is not a contract.
1557      *
1558      * @param from address representing the previous owner of the given token ID
1559      * @param to target address that will receive the tokens
1560      * @param tokenId uint256 ID of the token to be transferred
1561      * @param _data bytes optional data to send along with the call
1562      * @return bool whether the call correctly returned the expected magic value
1563      */
1564     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1565         private returns (bool)
1566     {
1567         if (to.isContract()) {
1568             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1569                 return retval == IERC721Receiver(to).onERC721Received.selector;
1570             } catch (bytes memory reason) {
1571                 if (reason.length == 0) {
1572                     revert("ERC721: transfer to non ERC721Receiver implementer");
1573                 } else {
1574                     // solhint-disable-next-line no-inline-assembly
1575                     assembly {
1576                         revert(add(32, reason), mload(reason))
1577                     }
1578                 }
1579             }
1580         } else {
1581             return true;
1582         }
1583     }
1584 
1585     function _approve(address to, uint256 tokenId) private {
1586         _tokenApprovals[tokenId] = to;
1587         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
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
1605     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1606 }
1607 
1608 
1609 
1610 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1611 
1612 
1613 
1614 
1615 pragma solidity ^0.8.0;
1616 
1617 /**
1618  * @dev Contract module which provides a basic access control mechanism, where
1619  * there is an account (an owner) that can be granted exclusive access to
1620  * specific functions.
1621  *
1622  * By default, the owner account will be the one that deploys the contract. This
1623  * can later be changed with {transferOwnership}.
1624  *
1625  * This module is used through inheritance. It will make available the modifier
1626  * `onlyOwner`, which can be applied to your functions to restrict their use to
1627  * the owner.
1628  */
1629 abstract contract Ownable is Context {
1630     address private _owner;
1631 
1632     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1633 
1634     /**
1635      * @dev Initializes the contract setting the deployer as the initial owner.
1636      */
1637     constructor () {
1638         address msgSender = _msgSender();
1639         _owner = msgSender;
1640         emit OwnershipTransferred(address(0), msgSender);
1641     }
1642 
1643     /**
1644      * @dev Returns the address of the current owner.
1645      */
1646     function owner() public view virtual returns (address) {
1647         return _owner;
1648     }
1649 
1650     /**
1651      * @dev Throws if called by any account other than the owner.
1652      */
1653     modifier onlyOwner() {
1654         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1655         _;
1656     }
1657 
1658     /**
1659      * @dev Leaves the contract without owner. It will not be possible to call
1660      * `onlyOwner` functions anymore. Can only be called by the current owner.
1661      *
1662      * NOTE: Renouncing ownership will leave the contract without an owner,
1663      * thereby removing any functionality that is only available to the owner.
1664      */
1665     function renounceOwnership() public virtual onlyOwner {
1666         emit OwnershipTransferred(_owner, address(0));
1667         _owner = address(0);
1668     }
1669 
1670     /**
1671      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1672      * Can only be called by the current owner.
1673      */
1674     function transferOwnership(address newOwner) public virtual onlyOwner {
1675         require(newOwner != address(0), "Ownable: new owner is the zero address");
1676         emit OwnershipTransferred(_owner, newOwner);
1677         _owner = newOwner;
1678     }
1679 }
1680 
1681 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1682 
1683 
1684 
1685 
1686 pragma solidity ^0.8.0;
1687 
1688 // CAUTION
1689 // This version of SafeMath should only be used with Solidity 0.8 or later,
1690 // because it relies on the compiler's built in overflow checks.
1691 
1692 /**
1693  * @dev Wrappers over Solidity's arithmetic operations.
1694  *
1695  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1696  * now has built in overflow checking.
1697  */
1698 library SafeMath {
1699     /**
1700      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1701      *
1702      * _Available since v3.4._
1703      */
1704     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1705         unchecked {
1706             uint256 c = a + b;
1707             if (c < a) return (false, 0);
1708             return (true, c);
1709         }
1710     }
1711 
1712     /**
1713      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1714      *
1715      * _Available since v3.4._
1716      */
1717     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1718         unchecked {
1719             if (b > a) return (false, 0);
1720             return (true, a - b);
1721         }
1722     }
1723 
1724     /**
1725      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1726      *
1727      * _Available since v3.4._
1728      */
1729     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1730         unchecked {
1731             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1732             // benefit is lost if 'b' is also tested.
1733             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1734             if (a == 0) return (true, 0);
1735             uint256 c = a * b;
1736             if (c / a != b) return (false, 0);
1737             return (true, c);
1738         }
1739     }
1740 
1741     /**
1742      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1743      *
1744      * _Available since v3.4._
1745      */
1746     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1747         unchecked {
1748             if (b == 0) return (false, 0);
1749             return (true, a / b);
1750         }
1751     }
1752 
1753     /**
1754      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1755      *
1756      * _Available since v3.4._
1757      */
1758     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1759         unchecked {
1760             if (b == 0) return (false, 0);
1761             return (true, a % b);
1762         }
1763     }
1764 
1765     /**
1766      * @dev Returns the addition of two unsigned integers, reverting on
1767      * overflow.
1768      *
1769      * Counterpart to Solidity's `+` operator.
1770      *
1771      * Requirements:
1772      *
1773      * - Addition cannot overflow.
1774      */
1775     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1776         return a + b;
1777     }
1778 
1779     /**
1780      * @dev Returns the subtraction of two unsigned integers, reverting on
1781      * overflow (when the result is negative).
1782      *
1783      * Counterpart to Solidity's `-` operator.
1784      *
1785      * Requirements:
1786      *
1787      * - Subtraction cannot overflow.
1788      */
1789     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1790         return a - b;
1791     }
1792 
1793     /**
1794      * @dev Returns the multiplication of two unsigned integers, reverting on
1795      * overflow.
1796      *
1797      * Counterpart to Solidity's `*` operator.
1798      *
1799      * Requirements:
1800      *
1801      * - Multiplication cannot overflow.
1802      */
1803     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1804         return a * b;
1805     }
1806 
1807     /**
1808      * @dev Returns the integer division of two unsigned integers, reverting on
1809      * division by zero. The result is rounded towards zero.
1810      *
1811      * Counterpart to Solidity's `/` operator.
1812      *
1813      * Requirements:
1814      *
1815      * - The divisor cannot be zero.
1816      */
1817     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1818         return a / b;
1819     }
1820 
1821     /**
1822      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1823      * reverting when dividing by zero.
1824      *
1825      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1826      * opcode (which leaves remaining gas untouched) while Solidity uses an
1827      * invalid opcode to revert (consuming all remaining gas).
1828      *
1829      * Requirements:
1830      *
1831      * - The divisor cannot be zero.
1832      */
1833     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1834         return a % b;
1835     }
1836 
1837     /**
1838      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1839      * overflow (when the result is negative).
1840      *
1841      * CAUTION: This function is deprecated because it requires allocating memory for the error
1842      * message unnecessarily. For custom revert reasons use {trySub}.
1843      *
1844      * Counterpart to Solidity's `-` operator.
1845      *
1846      * Requirements:
1847      *
1848      * - Subtraction cannot overflow.
1849      */
1850     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1851         unchecked {
1852             require(b <= a, errorMessage);
1853             return a - b;
1854         }
1855     }
1856 
1857     /**
1858      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1859      * division by zero. The result is rounded towards zero.
1860      *
1861      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1862      * opcode (which leaves remaining gas untouched) while Solidity uses an
1863      * invalid opcode to revert (consuming all remaining gas).
1864      *
1865      * Counterpart to Solidity's `/` operator. Note: this function uses a
1866      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1867      * uses an invalid opcode to revert (consuming all remaining gas).
1868      *
1869      * Requirements:
1870      *
1871      * - The divisor cannot be zero.
1872      */
1873     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1874         unchecked {
1875             require(b > 0, errorMessage);
1876             return a / b;
1877         }
1878     }
1879 
1880     /**
1881      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1882      * reverting with custom message when dividing by zero.
1883      *
1884      * CAUTION: This function is deprecated because it requires allocating memory for the error
1885      * message unnecessarily. For custom revert reasons use {tryMod}.
1886      *
1887      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1888      * opcode (which leaves remaining gas untouched) while Solidity uses an
1889      * invalid opcode to revert (consuming all remaining gas).
1890      *
1891      * Requirements:
1892      *
1893      * - The divisor cannot be zero.
1894      */
1895     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1896         unchecked {
1897             require(b > 0, errorMessage);
1898             return a % b;
1899         }
1900     }
1901 }
1902 
1903 
1904 pragma solidity ^0.8.0;
1905 
1906 
1907 
1908 
1909 
1910 contract JABBAFORMS is ERC721, Ownable {
1911     using SafeMath for uint256;
1912     uint public constant MAX_JABBAS = 4849;
1913     bool public hasSaleStarted = false;
1914     
1915     // THE IPFS HASH OF ALL TOKEN DATAS WILL BE ADDED HERE WHEN ALL JABBA FORMS ARE FINALIZED.
1916     string public METADATA_PROVENANCE_HASH = "";
1917     
1918     
1919     constructor() ERC721("J48BAFORMS","JABBA")  {
1920         setBaseURI("https://j48baforms.io/api/");
1921         
1922 		//Givaways
1923         _safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 0);
1924         _safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 1);
1925         _safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 2);
1926         _safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 3);
1927 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 4);
1928 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 5);
1929 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 6);
1930 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 7);
1931 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 8);
1932 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 9);
1933 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 10);
1934 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 11);
1935 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 12);
1936 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 13);
1937 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 14);
1938 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 15);
1939 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 16);
1940 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 17);
1941 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 18);
1942 		_safeMint(address(0x79004C1a3aCe472d75358ceCeB1d7E47Ef98BF10), 19);
1943 
1944 		//sudoscum
1945 		_safeMint(address(0xaA9f066554e18d3a6b660786aaFEA8e9a8630555), 20);
1946 		_safeMint(address(0xaA9f066554e18d3a6b660786aaFEA8e9a8630555), 21);
1947 		_safeMint(address(0xaA9f066554e18d3a6b660786aaFEA8e9a8630555), 22);
1948 		_safeMint(address(0xaA9f066554e18d3a6b660786aaFEA8e9a8630555), 23);
1949 		_safeMint(address(0xaA9f066554e18d3a6b660786aaFEA8e9a8630555), 24);
1950 		
1951 		//PM
1952 		_safeMint(address(0x8af39F909679793D2FA5A78e2766E6EF131ECDE2), 25);
1953 		_safeMint(address(0x8af39F909679793D2FA5A78e2766E6EF131ECDE2), 26);
1954 		_safeMint(address(0x8af39F909679793D2FA5A78e2766E6EF131ECDE2), 27);
1955 		
1956 		//BERK
1957 		_safeMint(address(0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5), 28);
1958 		
1959 		//Justin
1960 		_safeMint(address(0x84F5DE49Bf77dEC3D6b6D69dc05fa80207262D5A), 29);
1961 		_safeMint(address(0x84F5DE49Bf77dEC3D6b6D69dc05fa80207262D5A), 30);
1962         
1963     }
1964     
1965 
1966     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1967         uint256 tokenCount = balanceOf(_owner);
1968         if (tokenCount == 0) {
1969             // Return an empty array
1970             return new uint256[](0);
1971         } else {
1972             uint256[] memory result = new uint256[](tokenCount);
1973             uint256 index;
1974             for (index = 0; index < tokenCount; index++) {
1975                 result[index] = tokenOfOwnerByIndex(_owner, index);
1976             }
1977             return result;
1978         }
1979     }
1980     
1981     function calculatePrice() public view returns (uint256) {
1982         require(hasSaleStarted == true, "Sale hasn't started");
1983 
1984         require(totalSupply() < MAX_JABBAS, "Sale has already ended");
1985 
1986         uint currentSupply = totalSupply();
1987         require(currentSupply < MAX_JABBAS, "Sale has already ended");
1988 
1989         if (currentSupply <= 500) {
1990             return 80000000000000000; // 0.08 ETH
1991         } else if (currentSupply <= 1600) {
1992             return 140000000000000000; // 0.14 ETH
1993         } else if (currentSupply <= 2648) {
1994             return 250000000000000000; // 0.25 ETH
1995         } else if (currentSupply <= 3648) {
1996             return 330000000000000000; // 0.33 ETH
1997         } else if (currentSupply <= 4148) {
1998             return 400000000000000000; // 0.4 ETH
1999         } else if (currentSupply <= 4648) {
2000             return 500000000000000000; // 0.5 ETH
2001         } else if (currentSupply <= 4847) {
2002             return 600000000000000000; // 0.6 ETH
2003         } else {
2004             return 1000000000000000000; // 1 ETH
2005         }
2006         
2007     }
2008 
2009      function calculatePriceTest(uint _id) public view returns (uint256) {
2010 
2011 
2012         require(_id < MAX_JABBAS, "Sale has already ended");
2013 
2014         if (_id <= 500) {
2015             return 80000000000000000; // 0.08 ETH
2016         } else if (_id <= 1600) {
2017             return 140000000000000000; // 0.14 ETH
2018         } else if (_id <= 2648) {
2019             return 250000000000000000; // 0.25 ETH
2020         } else if (_id <= 3648) {
2021             return 330000000000000000; // 0.33 ETH
2022         } else if (_id <= 4148) {
2023             return 400000000000000000; // 0.4 ETH
2024         } else if (_id <= 4648) {
2025             return 500000000000000000; // 0.5 ETH
2026         } else if (_id <= 4847) {
2027             return 600000000000000000; // 0.6 ETH
2028         } else {
2029             return 1000000000000000000; // 1 ETH
2030         }
2031         
2032     }
2033     
2034    function adoptJABBA(uint256 numJabbas) public payable {
2035         require(totalSupply() < MAX_JABBAS, "Sale has already ended");
2036         require(numJabbas > 0 && numJabbas <= 20, "You can adopt minimum 1, maximum 20 jabba forms");
2037         require(totalSupply().add(numJabbas) <= MAX_JABBAS, "Exceeds MAX_JABBAS");
2038         require(msg.value >= calculatePrice().mul(numJabbas), "Ether value sent is below the price");
2039 
2040         for (uint i = 0; i < numJabbas; i++) {
2041             uint mintIndex = totalSupply();
2042             _safeMint(msg.sender, mintIndex);
2043         }
2044 
2045     }
2046     
2047     // ONLYOWNER FUNCTIONS
2048     
2049     function setProvenanceHash(string memory _hash) public onlyOwner {
2050         METADATA_PROVENANCE_HASH = _hash;
2051     }
2052     
2053     function setBaseURI(string memory baseURI) public onlyOwner {
2054         _setBaseURI(baseURI);
2055     }
2056     
2057     function startDrop() public onlyOwner {
2058         hasSaleStarted = true;
2059     }
2060     function pauseDrop() public onlyOwner {
2061         hasSaleStarted = false;
2062     }
2063     
2064     
2065     function withdrawAll() public payable onlyOwner {
2066         require(payable(msg.sender).send(address(this).balance));
2067     }
2068     
2069 
2070 
2071 }