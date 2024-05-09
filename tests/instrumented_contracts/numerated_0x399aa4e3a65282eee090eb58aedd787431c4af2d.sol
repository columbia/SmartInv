1 // RedemptionNFT.art  created by memorycollect0r. generative art stored on Ethereum
2 
3 
4 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
5 
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant alphabet = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = alphabet[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72 }
73 
74 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
75 
76 
77 
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Library for managing an enumerable variant of Solidity's
83  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
84  * type.
85  *
86  * Maps have the following properties:
87  *
88  * - Entries are added, removed, and checked for existence in constant time
89  * (O(1)).
90  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
91  *
92  * ```
93  * contract Example {
94  *     // Add the library methods
95  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
96  *
97  *     // Declare a set state variable
98  *     EnumerableMap.UintToAddressMap private myMap;
99  * }
100  * ```
101  *
102  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
103  * supported.
104  */
105 library EnumerableMap {
106     // To implement this library for multiple types with as little code
107     // repetition as possible, we write it in terms of a generic Map type with
108     // bytes32 keys and values.
109     // The Map implementation uses private functions, and user-facing
110     // implementations (such as Uint256ToAddressMap) are just wrappers around
111     // the underlying Map.
112     // This means that we can only create new EnumerableMaps for types that fit
113     // in bytes32.
114 
115     struct MapEntry {
116         bytes32 _key;
117         bytes32 _value;
118     }
119 
120     struct Map {
121         // Storage of map keys and values
122         MapEntry[] _entries;
123 
124         // Position of the entry defined by a key in the `entries` array, plus 1
125         // because index 0 means a key is not in the map.
126         mapping (bytes32 => uint256) _indexes;
127     }
128 
129     /**
130      * @dev Adds a key-value pair to a map, or updates the value for an existing
131      * key. O(1).
132      *
133      * Returns true if the key was added to the map, that is if it was not
134      * already present.
135      */
136     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
137         // We read and store the key's index to prevent multiple reads from the same storage slot
138         uint256 keyIndex = map._indexes[key];
139 
140         if (keyIndex == 0) { // Equivalent to !contains(map, key)
141             map._entries.push(MapEntry({ _key: key, _value: value }));
142             // The entry is stored at length-1, but we add 1 to all indexes
143             // and use 0 as a sentinel value
144             map._indexes[key] = map._entries.length;
145             return true;
146         } else {
147             map._entries[keyIndex - 1]._value = value;
148             return false;
149         }
150     }
151 
152     /**
153      * @dev Removes a key-value pair from a map. O(1).
154      *
155      * Returns true if the key was removed from the map, that is if it was present.
156      */
157     function _remove(Map storage map, bytes32 key) private returns (bool) {
158         // We read and store the key's index to prevent multiple reads from the same storage slot
159         uint256 keyIndex = map._indexes[key];
160 
161         if (keyIndex != 0) { // Equivalent to contains(map, key)
162             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
163             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
164             // This modifies the order of the array, as noted in {at}.
165 
166             uint256 toDeleteIndex = keyIndex - 1;
167             uint256 lastIndex = map._entries.length - 1;
168 
169             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
170             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
171 
172             MapEntry storage lastEntry = map._entries[lastIndex];
173 
174             // Move the last entry to the index where the entry to delete is
175             map._entries[toDeleteIndex] = lastEntry;
176             // Update the index for the moved entry
177             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
178 
179             // Delete the slot where the moved entry was stored
180             map._entries.pop();
181 
182             // Delete the index for the deleted slot
183             delete map._indexes[key];
184 
185             return true;
186         } else {
187             return false;
188         }
189     }
190 
191     /**
192      * @dev Returns true if the key is in the map. O(1).
193      */
194     function _contains(Map storage map, bytes32 key) private view returns (bool) {
195         return map._indexes[key] != 0;
196     }
197 
198     /**
199      * @dev Returns the number of key-value pairs in the map. O(1).
200      */
201     function _length(Map storage map) private view returns (uint256) {
202         return map._entries.length;
203     }
204 
205    /**
206     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
207     *
208     * Note that there are no guarantees on the ordering of entries inside the
209     * array, and it may change when more entries are added or removed.
210     *
211     * Requirements:
212     *
213     * - `index` must be strictly less than {length}.
214     */
215     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
216         require(map._entries.length > index, "EnumerableMap: index out of bounds");
217 
218         MapEntry storage entry = map._entries[index];
219         return (entry._key, entry._value);
220     }
221 
222     /**
223      * @dev Tries to returns the value associated with `key`.  O(1).
224      * Does not revert if `key` is not in the map.
225      */
226     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
227         uint256 keyIndex = map._indexes[key];
228         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
229         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
230     }
231 
232     /**
233      * @dev Returns the value associated with `key`.  O(1).
234      *
235      * Requirements:
236      *
237      * - `key` must be in the map.
238      */
239     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
240         uint256 keyIndex = map._indexes[key];
241         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
242         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
243     }
244 
245     /**
246      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
247      *
248      * CAUTION: This function is deprecated because it requires allocating memory for the error
249      * message unnecessarily. For custom revert reasons use {_tryGet}.
250      */
251     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
252         uint256 keyIndex = map._indexes[key];
253         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
254         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
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
297    /**
298     * @dev Returns the element stored at position `index` in the set. O(1).
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
391         mapping (bytes32 => uint256) _indexes;
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
422         if (valueIndex != 0) { // Equivalent to contains(set, value)
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
438             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
439 
440             // Delete the slot where the moved value was stored
441             set._values.pop();
442 
443             // Delete the index for the deleted slot
444             delete set._indexes[value];
445 
446             return true;
447         } else {
448             return false;
449         }
450     }
451 
452     /**
453      * @dev Returns true if the value is in the set. O(1).
454      */
455     function _contains(Set storage set, bytes32 value) private view returns (bool) {
456         return set._indexes[value] != 0;
457     }
458 
459     /**
460      * @dev Returns the number of values on the set. O(1).
461      */
462     function _length(Set storage set) private view returns (uint256) {
463         return set._values.length;
464     }
465 
466    /**
467     * @dev Returns the value stored at position `index` in the set. O(1).
468     *
469     * Note that there are no guarantees on the ordering of values inside the
470     * array, and it may change when more values are added or removed.
471     *
472     * Requirements:
473     *
474     * - `index` must be strictly less than {length}.
475     */
476     function _at(Set storage set, uint256 index) private view returns (bytes32) {
477         require(set._values.length > index, "EnumerableSet: index out of bounds");
478         return set._values[index];
479     }
480 
481     // Bytes32Set
482 
483     struct Bytes32Set {
484         Set _inner;
485     }
486 
487     /**
488      * @dev Add a value to a set. O(1).
489      *
490      * Returns true if the value was added to the set, that is if it was not
491      * already present.
492      */
493     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
494         return _add(set._inner, value);
495     }
496 
497     /**
498      * @dev Removes a value from a set. O(1).
499      *
500      * Returns true if the value was removed from the set, that is if it was
501      * present.
502      */
503     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
504         return _remove(set._inner, value);
505     }
506 
507     /**
508      * @dev Returns true if the value is in the set. O(1).
509      */
510     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
511         return _contains(set._inner, value);
512     }
513 
514     /**
515      * @dev Returns the number of values in the set. O(1).
516      */
517     function length(Bytes32Set storage set) internal view returns (uint256) {
518         return _length(set._inner);
519     }
520 
521    /**
522     * @dev Returns the value stored at position `index` in the set. O(1).
523     *
524     * Note that there are no guarantees on the ordering of values inside the
525     * array, and it may change when more values are added or removed.
526     *
527     * Requirements:
528     *
529     * - `index` must be strictly less than {length}.
530     */
531     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
532         return _at(set._inner, index);
533     }
534 
535     // AddressSet
536 
537     struct AddressSet {
538         Set _inner;
539     }
540 
541     /**
542      * @dev Add a value to a set. O(1).
543      *
544      * Returns true if the value was added to the set, that is if it was not
545      * already present.
546      */
547     function add(AddressSet storage set, address value) internal returns (bool) {
548         return _add(set._inner, bytes32(uint256(uint160(value))));
549     }
550 
551     /**
552      * @dev Removes a value from a set. O(1).
553      *
554      * Returns true if the value was removed from the set, that is if it was
555      * present.
556      */
557     function remove(AddressSet storage set, address value) internal returns (bool) {
558         return _remove(set._inner, bytes32(uint256(uint160(value))));
559     }
560 
561     /**
562      * @dev Returns true if the value is in the set. O(1).
563      */
564     function contains(AddressSet storage set, address value) internal view returns (bool) {
565         return _contains(set._inner, bytes32(uint256(uint160(value))));
566     }
567 
568     /**
569      * @dev Returns the number of values in the set. O(1).
570      */
571     function length(AddressSet storage set) internal view returns (uint256) {
572         return _length(set._inner);
573     }
574 
575    /**
576     * @dev Returns the value stored at position `index` in the set. O(1).
577     *
578     * Note that there are no guarantees on the ordering of values inside the
579     * array, and it may change when more values are added or removed.
580     *
581     * Requirements:
582     *
583     * - `index` must be strictly less than {length}.
584     */
585     function at(AddressSet storage set, uint256 index) internal view returns (address) {
586         return address(uint160(uint256(_at(set._inner, index))));
587     }
588 
589 
590     // UintSet
591 
592     struct UintSet {
593         Set _inner;
594     }
595 
596     /**
597      * @dev Add a value to a set. O(1).
598      *
599      * Returns true if the value was added to the set, that is if it was not
600      * already present.
601      */
602     function add(UintSet storage set, uint256 value) internal returns (bool) {
603         return _add(set._inner, bytes32(value));
604     }
605 
606     /**
607      * @dev Removes a value from a set. O(1).
608      *
609      * Returns true if the value was removed from the set, that is if it was
610      * present.
611      */
612     function remove(UintSet storage set, uint256 value) internal returns (bool) {
613         return _remove(set._inner, bytes32(value));
614     }
615 
616     /**
617      * @dev Returns true if the value is in the set. O(1).
618      */
619     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
620         return _contains(set._inner, bytes32(value));
621     }
622 
623     /**
624      * @dev Returns the number of values on the set. O(1).
625      */
626     function length(UintSet storage set) internal view returns (uint256) {
627         return _length(set._inner);
628     }
629 
630    /**
631     * @dev Returns the value stored at position `index` in the set. O(1).
632     *
633     * Note that there are no guarantees on the ordering of values inside the
634     * array, and it may change when more values are added or removed.
635     *
636     * Requirements:
637     *
638     * - `index` must be strictly less than {length}.
639     */
640     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
641         return uint256(_at(set._inner, index));
642     }
643 }
644 
645 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
646 
647 
648 
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Collection of functions related to the address type
654  */
655 library Address {
656     /**
657      * @dev Returns true if `account` is a contract.
658      *
659      * [IMPORTANT]
660      * ====
661      * It is unsafe to assume that an address for which this function returns
662      * false is an externally-owned account (EOA) and not a contract.
663      *
664      * Among others, `isContract` will return false for the following
665      * types of addresses:
666      *
667      *  - an externally-owned account
668      *  - a contract in construction
669      *  - an address where a contract will be created
670      *  - an address where a contract lived, but was destroyed
671      * ====
672      */
673     function isContract(address account) internal view returns (bool) {
674         // This method relies on extcodesize, which returns 0 for contracts in
675         // construction, since the code is only stored at the end of the
676         // constructor execution.
677 
678         uint256 size;
679         // solhint-disable-next-line no-inline-assembly
680         assembly { size := extcodesize(account) }
681         return size > 0;
682     }
683 
684     /**
685      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
686      * `recipient`, forwarding all available gas and reverting on errors.
687      *
688      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
689      * of certain opcodes, possibly making contracts go over the 2300 gas limit
690      * imposed by `transfer`, making them unable to receive funds via
691      * `transfer`. {sendValue} removes this limitation.
692      *
693      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
694      *
695      * IMPORTANT: because control is transferred to `recipient`, care must be
696      * taken to not create reentrancy vulnerabilities. Consider using
697      * {ReentrancyGuard} or the
698      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
699      */
700     function sendValue(address payable recipient, uint256 amount) internal {
701         require(address(this).balance >= amount, "Address: insufficient balance");
702 
703         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
704         (bool success, ) = recipient.call{ value: amount }("");
705         require(success, "Address: unable to send value, recipient may have reverted");
706     }
707 
708     /**
709      * @dev Performs a Solidity function call using a low level `call`. A
710      * plain`call` is an unsafe replacement for a function call: use this
711      * function instead.
712      *
713      * If `target` reverts with a revert reason, it is bubbled up by this
714      * function (like regular Solidity function calls).
715      *
716      * Returns the raw returned data. To convert to the expected return value,
717      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
718      *
719      * Requirements:
720      *
721      * - `target` must be a contract.
722      * - calling `target` with `data` must not revert.
723      *
724      * _Available since v3.1._
725      */
726     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
727       return functionCall(target, data, "Address: low-level call failed");
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
732      * `errorMessage` as a fallback revert reason when `target` reverts.
733      *
734      * _Available since v3.1._
735      */
736     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
737         return functionCallWithValue(target, data, 0, errorMessage);
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
742      * but also transferring `value` wei to `target`.
743      *
744      * Requirements:
745      *
746      * - the calling contract must have an ETH balance of at least `value`.
747      * - the called Solidity function must be `payable`.
748      *
749      * _Available since v3.1._
750      */
751     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
752         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
757      * with `errorMessage` as a fallback revert reason when `target` reverts.
758      *
759      * _Available since v3.1._
760      */
761     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
762         require(address(this).balance >= value, "Address: insufficient balance for call");
763         require(isContract(target), "Address: call to non-contract");
764 
765         // solhint-disable-next-line avoid-low-level-calls
766         (bool success, bytes memory returndata) = target.call{ value: value }(data);
767         return _verifyCallResult(success, returndata, errorMessage);
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
772      * but performing a static call.
773      *
774      * _Available since v3.3._
775      */
776     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
777         return functionStaticCall(target, data, "Address: low-level static call failed");
778     }
779 
780     /**
781      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
782      * but performing a static call.
783      *
784      * _Available since v3.3._
785      */
786     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
787         require(isContract(target), "Address: static call to non-contract");
788 
789         // solhint-disable-next-line avoid-low-level-calls
790         (bool success, bytes memory returndata) = target.staticcall(data);
791         return _verifyCallResult(success, returndata, errorMessage);
792     }
793 
794     /**
795      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
796      * but performing a delegate call.
797      *
798      * _Available since v3.4._
799      */
800     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
801         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
806      * but performing a delegate call.
807      *
808      * _Available since v3.4._
809      */
810     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
811         require(isContract(target), "Address: delegate call to non-contract");
812 
813         // solhint-disable-next-line avoid-low-level-calls
814         (bool success, bytes memory returndata) = target.delegatecall(data);
815         return _verifyCallResult(success, returndata, errorMessage);
816     }
817 
818     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
819         if (success) {
820             return returndata;
821         } else {
822             // Look for revert reason and bubble it up if present
823             if (returndata.length > 0) {
824                 // The easiest way to bubble the revert reason is using memory via assembly
825 
826                 // solhint-disable-next-line no-inline-assembly
827                 assembly {
828                     let returndata_size := mload(returndata)
829                     revert(add(32, returndata), returndata_size)
830                 }
831             } else {
832                 revert(errorMessage);
833             }
834         }
835     }
836 }
837 
838 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
839 
840 
841 pragma solidity ^0.8.0;
842 
843 /**
844  * @dev Interface of the ERC165 standard, as defined in the
845  * https://eips.ethereum.org/EIPS/eip-165[EIP].
846  *
847  * Implementers can declare support of contract interfaces, which can then be
848  * queried by others ({ERC165Checker}).
849  *
850  * For an implementation, see {ERC165}.
851  */
852 interface IERC165 {
853     /**
854      * @dev Returns true if this contract implements the interface defined by
855      * `interfaceId`. See the corresponding
856      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
857      * to learn more about how these ids are created.
858      *
859      * This function call must use less than 30 000 gas.
860      */
861     function supportsInterface(bytes4 interfaceId) external view returns (bool);
862 }
863 
864 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
865 
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @dev Implementation of the {IERC165} interface.
872  *
873  * Contracts may inherit from this and call {_registerInterface} to declare
874  * their support of an interface.
875  */
876 abstract contract ERC165 is IERC165 {
877     /**
878      * @dev Mapping of interface ids to whether or not it's supported.
879      */
880     mapping(bytes4 => bool) private _supportedInterfaces;
881 
882     constructor () {
883         // Derived contracts need only register support for their own interfaces,
884         // we register support for ERC165 itself here
885         _registerInterface(type(IERC165).interfaceId);
886     }
887 
888     /**
889      * @dev See {IERC165-supportsInterface}.
890      *
891      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
892      */
893     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
894         return _supportedInterfaces[interfaceId];
895     }
896 
897     /**
898      * @dev Registers the contract as an implementer of the interface defined by
899      * `interfaceId`. Support of the actual ERC165 interface is automatic and
900      * registering its interface id is not required.
901      *
902      * See {IERC165-supportsInterface}.
903      *
904      * Requirements:
905      *
906      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
907      */
908     function _registerInterface(bytes4 interfaceId) internal virtual {
909         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
910         _supportedInterfaces[interfaceId] = true;
911     }
912 }
913 
914 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
915 
916 
917 
918 
919 pragma solidity ^0.8.0;
920 
921 
922 /**
923  * @dev Required interface of an ERC721 compliant contract.
924  */
925 interface IERC721 is IERC165 {
926     /**
927      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
928      */
929     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
930 
931     /**
932      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
933      */
934     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
935 
936     /**
937      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
938      */
939     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
940 
941     /**
942      * @dev Returns the number of tokens in ``owner``'s account.
943      */
944     function balanceOf(address owner) external view returns (uint256 balance);
945 
946     /**
947      * @dev Returns the owner of the `tokenId` token.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must exist.
952      */
953     function ownerOf(uint256 tokenId) external view returns (address owner);
954 
955     /**
956      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
957      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
958      *
959      * Requirements:
960      *
961      * - `from` cannot be the zero address.
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must exist and be owned by `from`.
964      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function safeTransferFrom(address from, address to, uint256 tokenId) external;
970 
971     /**
972      * @dev Transfers `tokenId` token from `from` to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
975      *
976      * Requirements:
977      *
978      * - `from` cannot be the zero address.
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must be owned by `from`.
981      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
982      *
983      * Emits a {Transfer} event.
984      */
985     function transferFrom(address from, address to, uint256 tokenId) external;
986 
987     /**
988      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
989      * The approval is cleared when the token is transferred.
990      *
991      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
992      *
993      * Requirements:
994      *
995      * - The caller must own the token or be an approved operator.
996      * - `tokenId` must exist.
997      *
998      * Emits an {Approval} event.
999      */
1000     function approve(address to, uint256 tokenId) external;
1001 
1002     /**
1003      * @dev Returns the account approved for `tokenId` token.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      */
1009     function getApproved(uint256 tokenId) external view returns (address operator);
1010 
1011     /**
1012      * @dev Approve or remove `operator` as an operator for the caller.
1013      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1014      *
1015      * Requirements:
1016      *
1017      * - The `operator` cannot be the caller.
1018      *
1019      * Emits an {ApprovalForAll} event.
1020      */
1021     function setApprovalForAll(address operator, bool _approved) external;
1022 
1023     /**
1024      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1025      *
1026      * See {setApprovalForAll}
1027      */
1028     function isApprovedForAll(address owner, address operator) external view returns (bool);
1029 
1030     /**
1031       * @dev Safely transfers `tokenId` token from `from` to `to`.
1032       *
1033       * Requirements:
1034       *
1035       * - `from` cannot be the zero address.
1036       * - `to` cannot be the zero address.
1037       * - `tokenId` token must exist and be owned by `from`.
1038       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1039       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040       *
1041       * Emits a {Transfer} event.
1042       */
1043     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1044 }
1045 
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 /**
1050  * @title ERC721 token receiver interface
1051  * @dev Interface for any contract that wants to support safeTransfers
1052  * from ERC721 asset contracts.
1053  */
1054 interface IERC721Receiver {
1055     /**
1056      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1057      * by `operator` from `from`, this function is called.
1058      *
1059      * It must return its Solidity selector to confirm the token transfer.
1060      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1061      *
1062      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1063      */
1064     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1065 }
1066 
1067 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1068 
1069 
1070 
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 
1075 /**
1076  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1077  * @dev See https://eips.ethereum.org/EIPS/eip-721
1078  */
1079 interface IERC721Enumerable is IERC721 {
1080 
1081     /**
1082      * @dev Returns the total amount of tokens stored by the contract.
1083      */
1084     function totalSupply() external view returns (uint256);
1085 
1086     /**
1087      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1088      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1089      */
1090     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1091 
1092     /**
1093      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1094      * Use along with {totalSupply} to enumerate all tokens.
1095      */
1096     function tokenByIndex(uint256 index) external view returns (uint256);
1097 }
1098 
1099 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1100 
1101 
1102 
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 
1107 /**
1108  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1109  * @dev See https://eips.ethereum.org/EIPS/eip-721
1110  */
1111 interface IERC721Metadata is IERC721 {
1112 
1113     /**
1114      * @dev Returns the token collection name.
1115      */
1116     function name() external view returns (string memory);
1117 
1118     /**
1119      * @dev Returns the token collection symbol.
1120      */
1121     function symbol() external view returns (string memory);
1122 
1123     /**
1124      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1125      */
1126     function tokenURI(uint256 tokenId) external view returns (string memory);
1127 }
1128 
1129 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1130 
1131 
1132 
1133 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1134 
1135 
1136 
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 /*
1141  * @dev Provides information about the current execution context, including the
1142  * sender of the transaction and its data. While these are generally available
1143  * via msg.sender and msg.data, they should not be accessed in such a direct
1144  * manner, since when dealing with GSN meta-transactions the account sending and
1145  * paying for execution may not be the actual sender (as far as an application
1146  * is concerned).
1147  *
1148  * This contract is only required for intermediate, library-like contracts.
1149  */
1150 abstract contract Context {
1151     function _msgSender() internal view virtual returns (address) {
1152         return msg.sender;
1153     }
1154 
1155     function _msgData() internal view virtual returns (bytes calldata) {
1156         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1157         return msg.data;
1158     }
1159 }
1160 
1161 
1162 
1163 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1164 
1165 
1166 
1167 
1168 pragma solidity ^0.8.0;
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
1179 
1180 /**
1181  * @title ERC721 Non-Fungible Token Standard basic implementation
1182  * @dev see https://eips.ethereum.org/EIPS/eip-721
1183  */
1184 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1185     using Address for address;
1186     using EnumerableSet for EnumerableSet.UintSet;
1187     using EnumerableMap for EnumerableMap.UintToAddressMap;
1188     using Strings for uint256;
1189     
1190     // Mapping from holder address to their (enumerable) set of owned tokens
1191     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1192 
1193     
1194     // Enumerable mapping from token ids to their owners
1195     EnumerableMap.UintToAddressMap private _tokenOwners;
1196 
1197     // Mapping from token ID to approved address
1198     mapping (uint256 => address) private _tokenApprovals;
1199 
1200     // Mapping from owner to operator approvals
1201     mapping (address => mapping (address => bool)) private _operatorApprovals;
1202 
1203     // Token name
1204     string private _name;
1205 
1206     // Token symbol
1207     string private _symbol;
1208 
1209     // Optional mapping for token URIs
1210     mapping (uint256 => string) private _tokenURIs;
1211 
1212     // Base URI
1213     string private _baseURI;
1214 
1215     /**
1216      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1217      */
1218     constructor (string memory name_, string memory symbol_) {
1219         _name = name_;
1220         _symbol = symbol_;
1221 
1222         // register the supported interfaces to conform to ERC721 via ERC165
1223         _registerInterface(type(IERC721).interfaceId);
1224         _registerInterface(type(IERC721Metadata).interfaceId);
1225         _registerInterface(type(IERC721Enumerable).interfaceId);
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-balanceOf}.
1230      */
1231     function balanceOf(address owner) public view virtual override returns (uint256) {
1232         require(owner != address(0), "ERC721: balance query for the zero address");
1233         return _holderTokens[owner].length();
1234     }
1235     
1236     
1237 
1238     
1239  
1240     
1241     /**
1242      * @dev See {IERC721-ownerOf}.
1243      */
1244     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1245         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Metadata-name}.
1250      */
1251     function name() public view virtual override returns (string memory) {
1252         return _name;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Metadata-symbol}.
1257      */
1258     function symbol() public view virtual override returns (string memory) {
1259         return _symbol;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Metadata-tokenURI}.
1264      */
1265     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1266         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1267 
1268         string memory _tokenURI = _tokenURIs[tokenId];
1269         string memory base = baseURI();
1270 
1271         // If there is no base URI, return the token URI.
1272         if (bytes(base).length == 0) {
1273             return _tokenURI;
1274         }
1275         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1276         if (bytes(_tokenURI).length > 0) {
1277             return string(abi.encodePacked(base, _tokenURI));
1278         }
1279         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1280         return string(abi.encodePacked(base, tokenId.toString()));
1281     }
1282 
1283     /**
1284     * @dev Returns the base URI set via {_setBaseURI}. This will be
1285     * automatically added as a prefix in {tokenURI} to each token's URI, or
1286     * to the token ID if no specific URI is set for that token ID.
1287     */
1288     function baseURI() public view virtual returns (string memory) {
1289         return _baseURI;
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1294      */
1295     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1296         return _holderTokens[owner].at(index);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Enumerable-totalSupply}.
1301      */
1302     function totalSupply() public view virtual override returns (uint256) {
1303         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1304         return _tokenOwners.length();
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-tokenByIndex}.
1309      */
1310     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1311         (uint256 tokenId, ) = _tokenOwners.at(index);
1312         return tokenId;
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-approve}.
1317      */
1318     function approve(address to, uint256 tokenId) public virtual override {
1319         address owner = ERC721.ownerOf(tokenId);
1320         require(to != owner, "ERC721: approval to current owner");
1321 
1322         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1323             "ERC721: approve caller is not owner nor approved for all"
1324         );
1325 
1326         _approve(to, tokenId);
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-getApproved}.
1331      */
1332     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1333         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1334 
1335         return _tokenApprovals[tokenId];
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-setApprovalForAll}.
1340      */
1341     function setApprovalForAll(address operator, bool approved) public virtual override {
1342         require(operator != _msgSender(), "ERC721: approve to caller");
1343 
1344         _operatorApprovals[_msgSender()][operator] = approved;
1345         emit ApprovalForAll(_msgSender(), operator, approved);
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-isApprovedForAll}.
1350      */
1351     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1352         return _operatorApprovals[owner][operator];
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-transferFrom}.
1357      */
1358     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1359         //solhint-disable-next-line max-line-length
1360         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1361 
1362         _transfer(from, to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-safeTransferFrom}.
1367      */
1368     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1369         safeTransferFrom(from, to, tokenId, "");
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-safeTransferFrom}.
1374      */
1375     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1376         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1377         _safeTransfer(from, to, tokenId, _data);
1378     }
1379 
1380     /**
1381      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1383      *
1384      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1385      *
1386      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1387      * implement alternative mechanisms to perform token transfer, such as signature-based.
1388      *
1389      * Requirements:
1390      *
1391      * - `from` cannot be the zero address.
1392      * - `to` cannot be the zero address.
1393      * - `tokenId` token must exist and be owned by `from`.
1394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1395      *
1396      * Emits a {Transfer} event.
1397      */
1398     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1399         _transfer(from, to, tokenId);
1400         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1401     }
1402 
1403     /**
1404      * @dev Returns whether `tokenId` exists.
1405      *
1406      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1407      *
1408      * Tokens start existing when they are minted (`_mint`),
1409      * and stop existing when they are burned (`_burn`).
1410      */
1411     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1412         return _tokenOwners.contains(tokenId);
1413     }
1414 
1415     /**
1416      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      */
1422     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1423         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1424         address owner = ERC721.ownerOf(tokenId);
1425         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1426     }
1427 
1428     /**
1429      * @dev Safely mints `tokenId` and transfers it to `to`.
1430      *
1431      * Requirements:
1432      d*
1433      * - `tokenId` must not exist.
1434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function _safeMint(address to, uint256 tokenId) internal virtual {
1439         _safeMint(to, tokenId, "");
1440     }
1441 
1442     /**
1443      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1444      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1445      */
1446     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1447         _mint(to, tokenId);
1448         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1449     }
1450 
1451     /**
1452      * @dev Mints `tokenId` and transfers it to `to`.
1453      *
1454      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1455      *
1456      * Requirements:
1457      *
1458      * - `tokenId` must not exist.
1459      * - `to` cannot be the zero address.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function _mint(address to, uint256 tokenId) internal virtual {
1464         require(to != address(0), "ERC721: mint to the zero address");
1465         require(!_exists(tokenId), "ERC721: token already minted");
1466 
1467         _beforeTokenTransfer(address(0), to, tokenId);
1468 
1469         _holderTokens[to].add(tokenId);
1470 
1471         _tokenOwners.set(tokenId, to);
1472 
1473         emit Transfer(address(0), to, tokenId);
1474     }
1475 
1476     /**
1477      * @dev Destroys `tokenId`.
1478      * The approval is cleared when the token is burned.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _burn(uint256 tokenId) internal virtual {
1487         address owner = ERC721.ownerOf(tokenId); // internal owner
1488 
1489         _beforeTokenTransfer(owner, address(0), tokenId);
1490 
1491         // Clear approvals
1492         _approve(address(0), tokenId);
1493 
1494         // Clear metadata (if any)
1495         if (bytes(_tokenURIs[tokenId]).length != 0) {
1496             delete _tokenURIs[tokenId];
1497         }
1498 
1499         _holderTokens[owner].remove(tokenId);
1500 
1501         _tokenOwners.remove(tokenId);
1502 
1503         emit Transfer(owner, address(0), tokenId);
1504     }
1505 
1506     /**
1507      * @dev Transfers `tokenId` from `from` to `to`.
1508      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1509      *
1510      * Requirements:
1511      *
1512      * - `to` cannot be the zero address.
1513      * - `tokenId` token must be owned by `from`.
1514      *
1515      * Emits a {Transfer} event.
1516      */
1517     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1518         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1519         require(to != address(0), "ERC721: transfer to the zero address");
1520 
1521         _beforeTokenTransfer(from, to, tokenId);
1522 
1523         // Clear approvals from the previous owner
1524         _approve(address(0), tokenId);
1525 
1526         _holderTokens[from].remove(tokenId);
1527         _holderTokens[to].add(tokenId);
1528 
1529         _tokenOwners.set(tokenId, to);
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
1634 
1635 
1636     /**
1637      * @dev Initializes the contract setting the deployer as the initial owner.
1638      */
1639     constructor () {
1640         address msgSender = _msgSender();
1641         _owner = msgSender;
1642         emit OwnershipTransferred(address(0), msgSender);
1643     }
1644 
1645     /**
1646      * @dev Returns the address of the current owner.
1647      */
1648     function owner() public view virtual returns (address) {
1649         return _owner;
1650     }
1651 
1652     /**
1653      * @dev Throws if called by any account other than the owner.
1654      */
1655     modifier onlyOwner() {
1656         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1657         _;
1658     }
1659 
1660     /**
1661      * @dev Leaves the contract without owner. It will not be possible to call
1662      * `onlyOwner` functions anymore. Can only be called by the current owner.
1663      *
1664      * NOTE: Renouncing ownership will leave the contract without an owner,
1665      * thereby removing any functionality that is only available to the owner.
1666      */
1667     function renounceOwnership() public virtual onlyOwner {
1668         emit OwnershipTransferred(_owner, address(0));
1669         _owner = address(0);
1670     }
1671 
1672     /**
1673      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1674      * Can only be called by the current owner.
1675      */
1676     function transferOwnership(address newOwner) public virtual onlyOwner {
1677         require(newOwner != address(0), "Ownable: new owner is the zero address");
1678         emit OwnershipTransferred(_owner, newOwner);
1679         _owner = newOwner;
1680     }
1681 }
1682 
1683 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1684 
1685 
1686 
1687 
1688 pragma solidity ^0.8.0;
1689 
1690 // CAUTION
1691 // This version of SafeMath should only be used with Solidity 0.8 or later,
1692 // because it relies on the compiler's built in overflow checks.
1693 
1694 /**
1695  * @dev Wrappers over Solidity's arithmetic operations.
1696  *
1697  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1698  * now has built in overflow checking.
1699  */
1700 library SafeMath {
1701     /**
1702      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1703      *
1704      * _Available since v3.4._
1705      */
1706     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1707         unchecked {
1708             uint256 c = a + b;
1709             if (c < a) return (false, 0);
1710             return (true, c);
1711         }
1712     }
1713 
1714     /**
1715      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1716      *
1717      * _Available since v3.4._
1718      */
1719     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1720         unchecked {
1721             if (b > a) return (false, 0);
1722             return (true, a - b);
1723         }
1724     }
1725 
1726     /**
1727      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1728      *
1729      * _Available since v3.4._
1730      */
1731     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1732         unchecked {
1733             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1734             // benefit is lost if 'b' is also tested.
1735             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1736             if (a == 0) return (true, 0);
1737             uint256 c = a * b;
1738             if (c / a != b) return (false, 0);
1739             return (true, c);
1740         }
1741     }
1742 
1743     /**
1744      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1745      *
1746      * _Available since v3.4._
1747      */
1748     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1749         unchecked {
1750             if (b == 0) return (false, 0);
1751             return (true, a / b);
1752         }
1753     }
1754 
1755     /**
1756      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1757      *
1758      * _Available since v3.4._
1759      */
1760     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1761         unchecked {
1762             if (b == 0) return (false, 0);
1763             return (true, a % b);
1764         }
1765     }
1766 
1767     /**
1768      * @dev Returns the addition of two unsigned integers, reverting on
1769      * overflow.
1770      *
1771      * Counterpart to Solidity's `+` operator.
1772      *
1773      * Requirements:
1774      *
1775      * - Addition cannot overflow.
1776      */
1777     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1778         return a + b;
1779     }
1780 
1781     /**
1782      * @dev Returns the subtraction of two unsigned integers, reverting on
1783      * overflow (when the result is negative).
1784      *
1785      * Counterpart to Solidity's `-` operator.
1786      *
1787      * Requirements:
1788      *
1789      * - Subtraction cannot overflow.
1790      */
1791     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1792         return a - b;
1793     }
1794 
1795     /**
1796      * @dev Returns the multiplication of two unsigned integers, reverting on
1797      * overflow.
1798      *
1799      * Counterpart to Solidity's `*` operator.
1800      *
1801      * Requirements:
1802      *
1803      * - Multiplication cannot overflow.
1804      */
1805     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1806         return a * b;
1807     }
1808 
1809     /**
1810      * @dev Returns the integer division of two unsigned integers, reverting on
1811      * division by zero. The result is rounded towards zero.
1812      *
1813      * Counterpart to Solidity's `/` operator.
1814      *
1815      * Requirements:
1816      *
1817      * - The divisor cannot be zero.
1818      */
1819     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1820         return a / b;
1821     }
1822 
1823     /**
1824      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1825      * reverting when dividing by zero.
1826      *
1827      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1828      * opcode (which leaves remaining gas untouched) while Solidity uses an
1829      * invalid opcode to revert (consuming all remaining gas).
1830      *
1831      * Requirements:
1832      *
1833      * - The divisor cannot be zero.
1834      */
1835     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1836         return a % b;
1837     }
1838 
1839     /**
1840      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1841      * overflow (when the result is negative).
1842      *
1843      * CAUTION: This function is deprecated because it requires allocating memory for the error
1844      * message unnecessarily. For custom revert reasons use {trySub}.
1845      *
1846      * Counterpart to Solidity's `-` operator.
1847      *
1848      * Requirements:
1849      *
1850      * - Subtraction cannot overflow.
1851      */
1852     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1853         unchecked {
1854             require(b <= a, errorMessage);
1855             return a - b;
1856         }
1857     }
1858 
1859     /**
1860      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1861      * division by zero. The result is rounded towards zero.
1862      *
1863      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1864      * opcode (which leaves remaining gas untouched) while Solidity uses an
1865      * invalid opcode to revert (consuming all remaining gas).
1866      *
1867      * Counterpart to Solidity's `/` operator. Note: this function uses a
1868      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1869      * uses an invalid opcode to revert (consuming all remaining gas).
1870      *
1871      * Requirements:
1872      *
1873      * - The divisor cannot be zero.
1874      */
1875     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1876         unchecked {
1877             require(b > 0, errorMessage);
1878             return a / b;
1879         }
1880     }
1881 
1882     /**
1883      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1884      * reverting with custom message when dividing by zero.
1885      *
1886      * CAUTION: This function is deprecated because it requires allocating memory for the error
1887      * message unnecessarily. For custom revert reasons use {tryMod}.
1888      *
1889      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1890      * opcode (which leaves remaining gas untouched) while Solidity uses an
1891      * invalid opcode to revert (consuming all remaining gas).
1892      *
1893      * Requirements:
1894      *
1895      * - The divisor cannot be zero.
1896      */
1897     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1898         unchecked {
1899             require(b > 0, errorMessage);
1900             return a % b;
1901         }
1902     }
1903 }
1904 
1905 
1906 
1907 
1908 
1909 
1910 pragma solidity ^0.8.0;
1911 
1912 
1913 // SPDX-License-Identifier: UNLICENSED
1914 
1915 contract Redemption is ERC721, Ownable {
1916     using SafeMath for uint256;
1917     using Strings for uint256;
1918     uint public constant MAX_TOKENS = 1024;
1919     bool public hasSaleStarted = false;
1920     mapping (uint256 => uint256) public creationDates;
1921     mapping (uint256 => address) public creators;
1922     string public METADATA_PROVENANCE_HASH = "";
1923     string public GENERATOR_ADDRESS = "https://redemptionnft.art/generator/";
1924     string public IPFS_GENERATOR_ADDRESS = "";
1925     string public script = "";
1926 
1927     constructor() ERC721("Redemption","RDP")  {
1928         setBaseURI("https://redemptionnft.art/api/token/");
1929         _safeMint(msg.sender, 0);
1930         creationDates[0] = block.number;
1931         creators[0] = msg.sender;
1932         script = "class Random{constructor(e){this.seed=e}random_dec(){return this.seed^=this.seed<<13,this.seed^=this.seed>>17,this.seed^=this.seed<<5,(this.seed<0?1+~this.seed:this.seed)%1e3/1e3}random_between(e,t){return e+(t-e)*this.random_dec()}random_int(e,t){return Math.floor(this.random_between(e,t+1))}random_choice(e){return e[Math.floor(this.random_between(0,.99*e.length))]}}let tiles,tileWidth,tileHeight,palette,tokenData=window.tokenHash,seed=parseInt(tokenData.slice(0,16),16),rng=new Random(seed),VP=Math.min(window.innerHeight,window.innerWidth),WIDTH=VP,HEIGHT=VP,randomness=[],palettes=['FDFDFD-EAEAEA-D8D8D8-C6C6C6-B4B4B4','d3d4d9-4b88a2-bb0a21-252627-fff9fb','c8ffbe-edffab-ba9593-89608e-623b5a','ff9f1c-ffbf69-ffffff-cbf3f0-2ec4b6','555358-5f6062-7b7263-c6ca53-c9dcb3','540d6e-ee4266-ffd23f-f3fcf0-1f271b','1e91d6-0072bb-8fc93a-e4cc37-e18335','ea7af4-b43e8f-6200b3-3b0086-290628','5b5b5b-7d7c7a-c9c19f-edf7d2-edf7b5','333333-839788-eee0cb-baa898-bfd7ea','585123-eec170-f2a65a-f58549-772f1a','fbf5f3-e28413-000022-de3c4b-c42847','0fa3b1-d9e5d6-eddea4-f7a072-ff9b42','10002b-240046-5a189a-9d4edd-e0aaff','0466c8-023e7d-001845-33415c-7d8597','861657-a64253-d56aa0-bbdbb4-fcf0cc','493843-61988e-a0b2a6-cbbfbb-eabda8','031d44-04395e-70a288-dab785-d5896f','ff0a54-ff5c8a-ff85a1-fbb1bd-f7cad0','463f3a-8a817c-bcb8b1-f4f3ee-e0afa0','dd6e42-e8dab2-4f6d7a-c0d6df-eaeaea','ffd6ff-e7c6ff-c8b6ff-b8c0ff-bbd0ff','aa8f66-ed9b40-ffeedb-61c9a8-ba3b46','a57548-fcd7ad-f6c28b-5296a5-82ddf0','713e5a-63a375-edc79b-d57a66-ca6680','114b5f-456990-e4fde1-f45b69-6b2737','edf2fb-e2eafc-ccdbfd-c1d3fe-abc4ff','9cafb7-ead2ac-fe938c-e6b89c-4281a4','7bdff2-b2f7ef-eff7f6-f7d6e0-f2b5d4','ffcdb2-ffb4a2-e5989b-b5838d-6d6875','f2d7ee-d3bcc0-a5668b-69306d-0e103d','ffbe0b-fb5607-ff006e-8338ec-3a86ff','9b5de5-f15bb5-fee440-00bbf9-00f5d4','fee440-f15bb5-9b5de5-00bbf9-00f5d4','181a99-5d93cc-454593-e05328-e28976','F61067-5E239D-00F0B5-6DECAF-F4F4ED','f8f9fa-dee2e6-adb5bd-495057-212529','212529-000000-adb5bd-495057-f8f9fa'].map(e=>e.split('-').map(e=>'#'+e)),tileColors=[],arc$=[],arc$2=[],isFlipping=[],isRounded=!1,radius=0,offs=[],cellColors=[],psuedoFrame=1;function setup(){noiseSeed(seed),randomSeed(seed),createCanvas(WIDTH,HEIGHT),frameRate(60),colorMode(RGB),palette=rng.random_choice(palettes),background(palette[0]),stroke(palette[0]),strokeWeight(0),tiles=rng.random_int(2,16),tileWidth=WIDTH/tiles,tileHeight=HEIGHT/tiles;for(let e=0;e<=tiles;e++){let e=new Array(tiles).fill(null),t=new Array(tiles).fill(null),i=new Array(tiles).fill(null);for(let d=0;d<tiles;d++)e[d]=rng.random_between(0,1),t[d]=palette[rng.random_int(1,4)],i[d]=rng.random_choice(palette);randomness.push(e),tileColors.push(t),cellColors.push(i),isFlipping.push(rng.random_choice([!0,!1])),offs.push(rng.random_between(0,1)),arc$.push(rng.random_choice([45,60])),arc$2.push(rng.random_choice([PI,PI+QUARTER_PI,2*PI]))}noStroke()}function draw(){background(palette[0]);for(let e=0;e<=tiles;e++){for(let t=0;t<tiles;t++){if(fill(cellColors[e][t]),isRounded&&radius>.03?radius-=.02:radius+=.02,push(),fill(tileColors[e][t]),randomness[e][t]>.9)isFlipping[e]?arc(e*tileWidth-tileWidth/2,t*tileHeight+tileWidth/2,.75*tileWidth,.75*tileHeight,.01*radius+offs[e]+mouseX/200,.01*-radius+offs[e]+mouseX/200):arc(e*tileWidth-tileWidth/2,t*tileHeight+tileWidth/2,.75*tileWidth,.75*tileHeight,arc$[e]+offs[e],arc$2[e]+offs[e]);else if(randomness[e][t]>.6)if(randomness[e][t]>.75)if(mouseIsPressed){push();let i=color(tileColors[e][t]);i.setAlpha(256-sin(psuedoFrame/20)*psuedoFrame*7),fill(i),ellipse(e*tileWidth-tileWidth/2,t*tileHeight+tileHeight/2,tileWidth),pop()}else ellipse(e*tileWidth-tileWidth/2,t*tileHeight+tileHeight/2,tileWidth);else randomness[e][t]>.68?arc(e*tileWidth-tileWidth/2,t*tileHeight+tileWidth/2,.75*tileWidth,.75*tileHeight,0,-PI,CHORD):arc(e*tileWidth-tileWidth/2,t*tileHeight+tileWidth/2,.75*tileWidth,.75*tileHeight,PI,TWO_PI,CHORD);else randomness[e][t]>.3?randomness[e][t]>.5?rect(e*tileWidth-tileWidth,t*tileHeight,tileWidth,tileHeight,radius):rect(e*tileWidth-tileWidth,t*tileHeight,tileWidth,tileHeight):randomness[e][t]>.2?triangle(e*tileWidth-tileWidth,t*tileHeight+tileHeight,e*tileWidth,t*tileHeight+tileHeight,e*tileWidth,t*tileHeight):triangle(e*tileWidth-tileWidth,t*tileHeight+tileHeight,e*tileWidth,t*tileHeight,e*tileWidth-tileWidth,t*tileHeight);pop()}radius<=.1?(isRounded=!1,radius=.1):radius>99&&(isRounded=!0,radius=99)}mouseIsPressed?(stroke(palette[0]),strokeWeight(WIDTH/500+40*sin(psuedoFrame/100)),psuedoFrame++):(noStroke(),strokeWeight(0),psuedoFrame=1)}";
1933     }
1934     
1935     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1936         uint256 tokenCount = balanceOf(_owner);
1937         if (tokenCount == 0) {
1938             // Return an empty array
1939             return new uint256[](0);
1940         } else {
1941             uint256[] memory result = new uint256[](tokenCount);
1942             uint256 index;
1943             for (index = 0; index < tokenCount; index++) {
1944                 result[index] = tokenOfOwnerByIndex(_owner, index);
1945             }
1946             return result;
1947         }
1948     }
1949     
1950     function calculatePrice() public view returns (uint256) {
1951         return 35000000000000000;
1952     }
1953     
1954    function mintToken(uint256 maxTOKENS) public payable {
1955         require(totalSupply() < MAX_TOKENS, "Sale has already ended");
1956         require(maxTOKENS > 0 && maxTOKENS <= 10, "You can claim minimum 1, maximum 10 tokens");
1957         require(totalSupply().add(maxTOKENS) <= MAX_TOKENS, "Exceeds MAX_TOKENS");
1958         require(msg.value >= calculatePrice().mul(maxTOKENS), "Ether value sent is below the price");
1959         
1960         for (uint i = 0; i < maxTOKENS; i++) {
1961             uint mintIndex = totalSupply();
1962             _safeMint(msg.sender, mintIndex);
1963             creationDates[mintIndex] = block.number;
1964             creators[mintIndex] = msg.sender;
1965         }
1966     }
1967     
1968     // ONLYOWNER FUNCTIONS
1969     
1970     function setProvenanceHash(string memory _hash) public onlyOwner {
1971         METADATA_PROVENANCE_HASH = _hash;
1972     }
1973     
1974     function setGeneratorIPFSHash(string memory _hash) public onlyOwner {
1975         IPFS_GENERATOR_ADDRESS = _hash;
1976     }
1977     
1978     function setBaseURI(string memory baseURI) public onlyOwner {
1979         _setBaseURI(baseURI);
1980     }
1981     
1982     function startDrop() public onlyOwner {
1983         hasSaleStarted = true;
1984     }
1985     
1986     function pauseDrop() public onlyOwner {
1987         hasSaleStarted = false;
1988     }
1989     
1990     function withdrawAll() public payable onlyOwner {
1991         require(payable(msg.sender).send(address(this).balance));
1992     }
1993     
1994     function tokenHash(uint256 tokenId) public view returns(bytes32){
1995         require(_exists(tokenId), "DOES NOT EXIST");
1996         return bytes32(keccak256(abi.encodePacked(address(this), creationDates[tokenId], creators[tokenId], tokenId)));
1997     }
1998     
1999     function generatorAddress(uint256 tokenId) public view returns (string memory) {
2000         require(_exists(tokenId), "DOES NOT EXIST");
2001         return string(abi.encodePacked(GENERATOR_ADDRESS, tokenId.toString()));
2002     }
2003     
2004     //a contributor added this. could be usefull.
2005     
2006     function IPFSgeneratorAddress(uint256 tokenId) public view returns (string memory) {
2007         require(_exists(tokenId), "DOES NOT EXIST");
2008         return string(abi.encodePacked(IPFS_GENERATOR_ADDRESS, tokenId.toString()));
2009     }
2010 }