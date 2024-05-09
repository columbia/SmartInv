1 // ChainRings.com - Generative NFT Collection
2 // This contract is forked from https://github.com/canersevince/ChainPots repository.
3 
4 
5 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
6 
7 
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant alphabet = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = alphabet[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73 }
74 
75 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
76 
77 
78 
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Library for managing an enumerable variant of Solidity's
84  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
85  * type.
86  *
87  * Maps have the following properties:
88  *
89  * - Entries are added, removed, and checked for existence in constant time
90  * (O(1)).
91  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
92  *
93  * ```
94  * contract Example {
95  *     // Add the library methods
96  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
97  *
98  *     // Declare a set state variable
99  *     EnumerableMap.UintToAddressMap private myMap;
100  * }
101  * ```
102  *
103  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
104  * supported.
105  */
106 library EnumerableMap {
107     // To implement this library for multiple types with as little code
108     // repetition as possible, we write it in terms of a generic Map type with
109     // bytes32 keys and values.
110     // The Map implementation uses private functions, and user-facing
111     // implementations (such as Uint256ToAddressMap) are just wrappers around
112     // the underlying Map.
113     // This means that we can only create new EnumerableMaps for types that fit
114     // in bytes32.
115 
116     struct MapEntry {
117         bytes32 _key;
118         bytes32 _value;
119     }
120 
121     struct Map {
122         // Storage of map keys and values
123         MapEntry[] _entries;
124 
125         // Position of the entry defined by a key in the `entries` array, plus 1
126         // because index 0 means a key is not in the map.
127         mapping (bytes32 => uint256) _indexes;
128     }
129 
130     /**
131      * @dev Adds a key-value pair to a map, or updates the value for an existing
132      * key. O(1).
133      *
134      * Returns true if the key was added to the map, that is if it was not
135      * already present.
136      */
137     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
138         // We read and store the key's index to prevent multiple reads from the same storage slot
139         uint256 keyIndex = map._indexes[key];
140 
141         if (keyIndex == 0) { // Equivalent to !contains(map, key)
142             map._entries.push(MapEntry({ _key: key, _value: value }));
143             // The entry is stored at length-1, but we add 1 to all indexes
144             // and use 0 as a sentinel value
145             map._indexes[key] = map._entries.length;
146             return true;
147         } else {
148             map._entries[keyIndex - 1]._value = value;
149             return false;
150         }
151     }
152 
153     /**
154      * @dev Removes a key-value pair from a map. O(1).
155      *
156      * Returns true if the key was removed from the map, that is if it was present.
157      */
158     function _remove(Map storage map, bytes32 key) private returns (bool) {
159         // We read and store the key's index to prevent multiple reads from the same storage slot
160         uint256 keyIndex = map._indexes[key];
161 
162         if (keyIndex != 0) { // Equivalent to contains(map, key)
163             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
164             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
165             // This modifies the order of the array, as noted in {at}.
166 
167             uint256 toDeleteIndex = keyIndex - 1;
168             uint256 lastIndex = map._entries.length - 1;
169 
170             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
171             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
172 
173             MapEntry storage lastEntry = map._entries[lastIndex];
174 
175             // Move the last entry to the index where the entry to delete is
176             map._entries[toDeleteIndex] = lastEntry;
177             // Update the index for the moved entry
178             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
179 
180             // Delete the slot where the moved entry was stored
181             map._entries.pop();
182 
183             // Delete the index for the deleted slot
184             delete map._indexes[key];
185 
186             return true;
187         } else {
188             return false;
189         }
190     }
191 
192     /**
193      * @dev Returns true if the key is in the map. O(1).
194      */
195     function _contains(Map storage map, bytes32 key) private view returns (bool) {
196         return map._indexes[key] != 0;
197     }
198 
199     /**
200      * @dev Returns the number of key-value pairs in the map. O(1).
201      */
202     function _length(Map storage map) private view returns (uint256) {
203         return map._entries.length;
204     }
205 
206     /**
207      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
208      *
209      * Note that there are no guarantees on the ordering of entries inside the
210      * array, and it may change when more entries are added or removed.
211      *
212      * Requirements:
213      *
214      * - `index` must be strictly less than {length}.
215      */
216     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
217         require(map._entries.length > index, "EnumerableMap: index out of bounds");
218 
219         MapEntry storage entry = map._entries[index];
220         return (entry._key, entry._value);
221     }
222 
223     /**
224      * @dev Tries to returns the value associated with `key`.  O(1).
225      * Does not revert if `key` is not in the map.
226      */
227     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
228         uint256 keyIndex = map._indexes[key];
229         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
230         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
231     }
232 
233     /**
234      * @dev Returns the value associated with `key`.  O(1).
235      *
236      * Requirements:
237      *
238      * - `key` must be in the map.
239      */
240     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
241         uint256 keyIndex = map._indexes[key];
242         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
243         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
244     }
245 
246     /**
247      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
248      *
249      * CAUTION: This function is deprecated because it requires allocating memory for the error
250      * message unnecessarily. For custom revert reasons use {_tryGet}.
251      */
252     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
253         uint256 keyIndex = map._indexes[key];
254         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
255         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
256     }
257 
258     // UintToAddressMap
259 
260     struct UintToAddressMap {
261         Map _inner;
262     }
263 
264     /**
265      * @dev Adds a key-value pair to a map, or updates the value for an existing
266      * key. O(1).
267      *
268      * Returns true if the key was added to the map, that is if it was not
269      * already present.
270      */
271     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
272         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
273     }
274 
275     /**
276      * @dev Removes a value from a set. O(1).
277      *
278      * Returns true if the key was removed from the map, that is if it was present.
279      */
280     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
281         return _remove(map._inner, bytes32(key));
282     }
283 
284     /**
285      * @dev Returns true if the key is in the map. O(1).
286      */
287     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
288         return _contains(map._inner, bytes32(key));
289     }
290 
291     /**
292      * @dev Returns the number of elements in the map. O(1).
293      */
294     function length(UintToAddressMap storage map) internal view returns (uint256) {
295         return _length(map._inner);
296     }
297 
298     /**
299      * @dev Returns the element stored at position `index` in the set. O(1).
300      * Note that there are no guarantees on the ordering of values inside the
301      * array, and it may change when more values are added or removed.
302      *
303      * Requirements:
304      *
305      * - `index` must be strictly less than {length}.
306      */
307     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
308         (bytes32 key, bytes32 value) = _at(map._inner, index);
309         return (uint256(key), address(uint160(uint256(value))));
310     }
311 
312     /**
313      * @dev Tries to returns the value associated with `key`.  O(1).
314      * Does not revert if `key` is not in the map.
315      *
316      * _Available since v3.4._
317      */
318     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
319         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
320         return (success, address(uint160(uint256(value))));
321     }
322 
323     /**
324      * @dev Returns the value associated with `key`.  O(1).
325      *
326      * Requirements:
327      *
328      * - `key` must be in the map.
329      */
330     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
331         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
332     }
333 
334     /**
335      * @dev Same as {get}, with a custom error message when `key` is not in the map.
336      *
337      * CAUTION: This function is deprecated because it requires allocating memory for the error
338      * message unnecessarily. For custom revert reasons use {tryGet}.
339      */
340     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
341         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
342     }
343 }
344 
345 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
346 
347 
348 
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev Library for managing
354  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
355  * types.
356  *
357  * Sets have the following properties:
358  *
359  * - Elements are added, removed, and checked for existence in constant time
360  * (O(1)).
361  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
362  *
363  * ```
364  * contract Example {
365  *     // Add the library methods
366  *     using EnumerableSet for EnumerableSet.AddressSet;
367  *
368  *     // Declare a set state variable
369  *     EnumerableSet.AddressSet private mySet;
370  * }
371  * ```
372  *
373  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
374  * and `uint256` (`UintSet`) are supported.
375  */
376 library EnumerableSet {
377     // To implement this library for multiple types with as little code
378     // repetition as possible, we write it in terms of a generic Set type with
379     // bytes32 values.
380     // The Set implementation uses private functions, and user-facing
381     // implementations (such as AddressSet) are just wrappers around the
382     // underlying Set.
383     // This means that we can only create new EnumerableSets for types that fit
384     // in bytes32.
385 
386     struct Set {
387         // Storage of set values
388         bytes32[] _values;
389 
390         // Position of the value in the `values` array, plus 1 because index 0
391         // means a value is not in the set.
392         mapping (bytes32 => uint256) _indexes;
393     }
394 
395     /**
396      * @dev Add a value to a set. O(1).
397      *
398      * Returns true if the value was added to the set, that is if it was not
399      * already present.
400      */
401     function _add(Set storage set, bytes32 value) private returns (bool) {
402         if (!_contains(set, value)) {
403             set._values.push(value);
404             // The value is stored at length-1, but we add 1 to all indexes
405             // and use 0 as a sentinel value
406             set._indexes[value] = set._values.length;
407             return true;
408         } else {
409             return false;
410         }
411     }
412 
413     /**
414      * @dev Removes a value from a set. O(1).
415      *
416      * Returns true if the value was removed from the set, that is if it was
417      * present.
418      */
419     function _remove(Set storage set, bytes32 value) private returns (bool) {
420         // We read and store the value's index to prevent multiple reads from the same storage slot
421         uint256 valueIndex = set._indexes[value];
422 
423         if (valueIndex != 0) { // Equivalent to contains(set, value)
424             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
425             // the array, and then remove the last element (sometimes called as 'swap and pop').
426             // This modifies the order of the array, as noted in {at}.
427 
428             uint256 toDeleteIndex = valueIndex - 1;
429             uint256 lastIndex = set._values.length - 1;
430 
431             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
432             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
433 
434             bytes32 lastvalue = set._values[lastIndex];
435 
436             // Move the last value to the index where the value to delete is
437             set._values[toDeleteIndex] = lastvalue;
438             // Update the index for the moved value
439             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
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
469      *
470      * Note that there are no guarantees on the ordering of values inside the
471      * array, and it may change when more values are added or removed.
472      *
473      * Requirements:
474      *
475      * - `index` must be strictly less than {length}.
476      */
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
524      *
525      * Note that there are no guarantees on the ordering of values inside the
526      * array, and it may change when more values are added or removed.
527      *
528      * Requirements:
529      *
530      * - `index` must be strictly less than {length}.
531      */
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
578      *
579      * Note that there are no guarantees on the ordering of values inside the
580      * array, and it may change when more values are added or removed.
581      *
582      * Requirements:
583      *
584      * - `index` must be strictly less than {length}.
585      */
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
633      *
634      * Note that there are no guarantees on the ordering of values inside the
635      * array, and it may change when more values are added or removed.
636      *
637      * Requirements:
638      *
639      * - `index` must be strictly less than {length}.
640      */
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
681         assembly { size := extcodesize(account) }
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
705         (bool success, ) = recipient.call{ value: amount }("");
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
767         (bool success, bytes memory returndata) = target.call{ value: value }(data);
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
819     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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
1157         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1158         return msg.data;
1159     }
1160 }
1161 
1162 
1163 
1164 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1165 
1166 
1167 
1168 
1169 pragma solidity ^0.8.0;
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
1180 
1181 /**
1182  * @title ERC721 Non-Fungible Token Standard basic implementation
1183  * @dev see https://eips.ethereum.org/EIPS/eip-721
1184  */
1185 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1186     using Address for address;
1187     using EnumerableSet for EnumerableSet.UintSet;
1188     using EnumerableMap for EnumerableMap.UintToAddressMap;
1189     using Strings for uint256;
1190 
1191     // Mapping from holder address to their (enumerable) set of owned tokens
1192     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1193 
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
1239 
1240 
1241 
1242     /**
1243      * @dev See {IERC721-ownerOf}.
1244      */
1245     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1246         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1247     }
1248 
1249     /**
1250      * @dev See {IERC721Metadata-name}.
1251      */
1252     function name() public view virtual override returns (string memory) {
1253         return _name;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Metadata-symbol}.
1258      */
1259     function symbol() public view virtual override returns (string memory) {
1260         return _symbol;
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Metadata-tokenURI}.
1265      */
1266     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1267         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1268 
1269         string memory _tokenURI = _tokenURIs[tokenId];
1270         string memory base = baseURI();
1271 
1272         // If there is no base URI, return the token URI.
1273         if (bytes(base).length == 0) {
1274             return _tokenURI;
1275         }
1276         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1277         if (bytes(_tokenURI).length > 0) {
1278             return string(abi.encodePacked(base, _tokenURI));
1279         }
1280         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1281         return string(abi.encodePacked(base, tokenId.toString()));
1282     }
1283 
1284     /**
1285     * @dev Returns the base URI set via {_setBaseURI}. This will be
1286     * automatically added as a prefix in {tokenURI} to each token's URI, or
1287     * to the token ID if no specific URI is set for that token ID.
1288     */
1289     function baseURI() public view virtual returns (string memory) {
1290         return _baseURI;
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1295      */
1296     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1297         return _holderTokens[owner].at(index);
1298     }
1299 
1300     /**
1301      * @dev See {IERC721Enumerable-totalSupply}.
1302      */
1303     function totalSupply() public view virtual override returns (uint256) {
1304         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1305         return _tokenOwners.length();
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Enumerable-tokenByIndex}.
1310      */
1311     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1312         (uint256 tokenId, ) = _tokenOwners.at(index);
1313         return tokenId;
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-approve}.
1318      */
1319     function approve(address to, uint256 tokenId) public virtual override {
1320         address owner = ERC721.ownerOf(tokenId);
1321         require(to != owner, "ERC721: approval to current owner");
1322 
1323         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1324             "ERC721: approve caller is not owner nor approved for all"
1325         );
1326 
1327         _approve(to, tokenId);
1328     }
1329 
1330     /**
1331      * @dev See {IERC721-getApproved}.
1332      */
1333     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1334         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1335 
1336         return _tokenApprovals[tokenId];
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-setApprovalForAll}.
1341      */
1342     function setApprovalForAll(address operator, bool approved) public virtual override {
1343         require(operator != _msgSender(), "ERC721: approve to caller");
1344 
1345         _operatorApprovals[_msgSender()][operator] = approved;
1346         emit ApprovalForAll(_msgSender(), operator, approved);
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-isApprovedForAll}.
1351      */
1352     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1353         return _operatorApprovals[owner][operator];
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-transferFrom}.
1358      */
1359     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1360         //solhint-disable-next-line max-line-length
1361         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1362 
1363         _transfer(from, to, tokenId);
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-safeTransferFrom}.
1368      */
1369     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1370         safeTransferFrom(from, to, tokenId, "");
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-safeTransferFrom}.
1375      */
1376     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1377         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1378         _safeTransfer(from, to, tokenId, _data);
1379     }
1380 
1381     /**
1382      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1383      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1384      *
1385      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1386      *
1387      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1388      * implement alternative mechanisms to perform token transfer, such as signature-based.
1389      *
1390      * Requirements:
1391      *
1392      * - `from` cannot be the zero address.
1393      * - `to` cannot be the zero address.
1394      * - `tokenId` token must exist and be owned by `from`.
1395      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1396      *
1397      * Emits a {Transfer} event.
1398      */
1399     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1400         _transfer(from, to, tokenId);
1401         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1402     }
1403 
1404     /**
1405      * @dev Returns whether `tokenId` exists.
1406      *
1407      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1408      *
1409      * Tokens start existing when they are minted (`_mint`),
1410      * and stop existing when they are burned (`_burn`).
1411      */
1412     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1413         return _tokenOwners.contains(tokenId);
1414     }
1415 
1416     /**
1417      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must exist.
1422      */
1423     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1424         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1425         address owner = ERC721.ownerOf(tokenId);
1426         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1427     }
1428 
1429     /**
1430      * @dev Safely mints `tokenId` and transfers it to `to`.
1431      *
1432      * Requirements:
1433      d*
1434      * - `tokenId` must not exist.
1435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1436      *
1437      * Emits a {Transfer} event.
1438      */
1439     function _safeMint(address to, uint256 tokenId) internal virtual {
1440         _safeMint(to, tokenId, "");
1441     }
1442 
1443     /**
1444      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1445      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1446      */
1447     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1448         _mint(to, tokenId);
1449         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1450     }
1451 
1452     /**
1453      * @dev Mints `tokenId` and transfers it to `to`.
1454      *
1455      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1456      *
1457      * Requirements:
1458      *
1459      * - `tokenId` must not exist.
1460      * - `to` cannot be the zero address.
1461      *
1462      * Emits a {Transfer} event.
1463      */
1464     function _mint(address to, uint256 tokenId) internal virtual {
1465         require(to != address(0), "ERC721: mint to the zero address");
1466         require(!_exists(tokenId), "ERC721: token already minted");
1467 
1468         _beforeTokenTransfer(address(0), to, tokenId);
1469 
1470         _holderTokens[to].add(tokenId);
1471 
1472         _tokenOwners.set(tokenId, to);
1473 
1474         emit Transfer(address(0), to, tokenId);
1475     }
1476 
1477     /**
1478      * @dev Destroys `tokenId`.
1479      * The approval is cleared when the token is burned.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must exist.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function _burn(uint256 tokenId) internal virtual {
1488         address owner = ERC721.ownerOf(tokenId); // internal owner
1489 
1490         _beforeTokenTransfer(owner, address(0), tokenId);
1491 
1492         // Clear approvals
1493         _approve(address(0), tokenId);
1494 
1495         // Clear metadata (if any)
1496         if (bytes(_tokenURIs[tokenId]).length != 0) {
1497             delete _tokenURIs[tokenId];
1498         }
1499 
1500         _holderTokens[owner].remove(tokenId);
1501 
1502         _tokenOwners.remove(tokenId);
1503 
1504         emit Transfer(owner, address(0), tokenId);
1505     }
1506 
1507     /**
1508      * @dev Transfers `tokenId` from `from` to `to`.
1509      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1510      *
1511      * Requirements:
1512      *
1513      * - `to` cannot be the zero address.
1514      * - `tokenId` token must be owned by `from`.
1515      *
1516      * Emits a {Transfer} event.
1517      */
1518     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1519         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1520         require(to != address(0), "ERC721: transfer to the zero address");
1521 
1522         _beforeTokenTransfer(from, to, tokenId);
1523 
1524         // Clear approvals from the previous owner
1525         _approve(address(0), tokenId);
1526 
1527         _holderTokens[from].remove(tokenId);
1528         _holderTokens[to].add(tokenId);
1529 
1530         _tokenOwners.set(tokenId, to);
1531         emit Transfer(from, to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must exist.
1540      */
1541     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1542         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1543         _tokenURIs[tokenId] = _tokenURI;
1544     }
1545 
1546     /**
1547      * @dev Internal function to set the base URI for all token IDs. It is
1548      * automatically added as a prefix to the value returned in {tokenURI},
1549      * or to the token ID if {tokenURI} is empty.
1550      */
1551     function _setBaseURI(string memory baseURI_) internal virtual {
1552         _baseURI = baseURI_;
1553     }
1554 
1555     /**
1556      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1557      * The call is not executed if the target address is not a contract.
1558      *
1559      * @param from address representing the previous owner of the given token ID
1560      * @param to target address that will receive the tokens
1561      * @param tokenId uint256 ID of the token to be transferred
1562      * @param _data bytes optional data to send along with the call
1563      * @return bool whether the call correctly returned the expected magic value
1564      */
1565     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1566     private returns (bool)
1567     {
1568         if (to.isContract()) {
1569             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1570                 return retval == IERC721Receiver(to).onERC721Received.selector;
1571             } catch (bytes memory reason) {
1572                 if (reason.length == 0) {
1573                     revert("ERC721: transfer to non ERC721Receiver implementer");
1574                 } else {
1575                     // solhint-disable-next-line no-inline-assembly
1576                     assembly {
1577                         revert(add(32, reason), mload(reason))
1578                     }
1579                 }
1580             }
1581         } else {
1582             return true;
1583         }
1584     }
1585 
1586     function _approve(address to, uint256 tokenId) private {
1587         _tokenApprovals[tokenId] = to;
1588         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1589     }
1590 
1591     /**
1592      * @dev Hook that is called before any token transfer. This includes minting
1593      * and burning.
1594      *
1595      * Calling conditions:
1596      *
1597      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1598      * transferred to `to`.
1599      * - When `from` is zero, `tokenId` will be minted for `to`.
1600      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1601      * - `from` cannot be the zero address.
1602      * - `to` cannot be the zero address.
1603      *
1604      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1605      */
1606     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1607 }
1608 
1609 
1610 
1611 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1612 
1613 
1614 
1615 
1616 pragma solidity ^0.8.0;
1617 
1618 /**
1619  * @dev Contract module which provides a basic access control mechanism, where
1620  * there is an account (an owner) that can be granted exclusive access to
1621  * specific functions.
1622  *
1623  * By default, the owner account will be the one that deploys the contract. This
1624  * can later be changed with {transferOwnership}.
1625  *
1626  * This module is used through inheritance. It will make available the modifier
1627  * `onlyOwner`, which can be applied to your functions to restrict their use to
1628  * the owner.
1629  */
1630 abstract contract Ownable is Context {
1631     address private _owner;
1632 
1633     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1634 
1635 
1636 
1637     /**
1638      * @dev Initializes the contract setting the deployer as the initial owner.
1639      */
1640     constructor () {
1641         address msgSender = _msgSender();
1642         _owner = msgSender;
1643         emit OwnershipTransferred(address(0), msgSender);
1644     }
1645 
1646     /**
1647      * @dev Returns the address of the current owner.
1648      */
1649     function owner() public view virtual returns (address) {
1650         return _owner;
1651     }
1652 
1653     /**
1654      * @dev Throws if called by any account other than the owner.
1655      */
1656     modifier onlyOwner() {
1657         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1658         _;
1659     }
1660 
1661     /**
1662      * @dev Leaves the contract without owner. It will not be possible to call
1663      * `onlyOwner` functions anymore. Can only be called by the current owner.
1664      *
1665      * NOTE: Renouncing ownership will leave the contract without an owner,
1666      * thereby removing any functionality that is only available to the owner.
1667      */
1668     function renounceOwnership() public virtual onlyOwner {
1669         emit OwnershipTransferred(_owner, address(0));
1670         _owner = address(0);
1671     }
1672 
1673     /**
1674      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1675      * Can only be called by the current owner.
1676      */
1677     function transferOwnership(address newOwner) public virtual onlyOwner {
1678         require(newOwner != address(0), "Ownable: new owner is the zero address");
1679         emit OwnershipTransferred(_owner, newOwner);
1680         _owner = newOwner;
1681     }
1682 }
1683 
1684 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1685 
1686 
1687 
1688 
1689 pragma solidity ^0.8.0;
1690 
1691 // CAUTION
1692 // This version of SafeMath should only be used with Solidity 0.8 or later,
1693 // because it relies on the compiler's built in overflow checks.
1694 
1695 /**
1696  * @dev Wrappers over Solidity's arithmetic operations.
1697  *
1698  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1699  * now has built in overflow checking.
1700  */
1701 library SafeMath {
1702     /**
1703      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1704      *
1705      * _Available since v3.4._
1706      */
1707     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1708         unchecked {
1709         uint256 c = a + b;
1710         if (c < a) return (false, 0);
1711         return (true, c);
1712     }
1713 }
1714 
1715 /**
1716  * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1717  *
1718  * _Available since v3.4._
1719  */
1720 function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1721 unchecked {
1722 if (b > a) return (false, 0);
1723 return (true, a - b);
1724 }
1725 }
1726 
1727 /**
1728  * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1729  *
1730  * _Available since v3.4._
1731  */
1732 function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1733 unchecked {
1734 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1735 // benefit is lost if 'b' is also tested.
1736 // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1737 if (a == 0) return (true, 0);
1738 uint256 c = a * b;
1739 if (c / a != b) return (false, 0);
1740 return (true, c);
1741 }
1742 }
1743 
1744 /**
1745  * @dev Returns the division of two unsigned integers, with a division by zero flag.
1746  *
1747  * _Available since v3.4._
1748  */
1749 function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1750 unchecked {
1751 if (b == 0) return (false, 0);
1752 return (true, a / b);
1753 }
1754 }
1755 
1756 /**
1757  * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1758  *
1759  * _Available since v3.4._
1760  */
1761 function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1762 unchecked {
1763 if (b == 0) return (false, 0);
1764 return (true, a % b);
1765 }
1766 }
1767 
1768 /**
1769  * @dev Returns the addition of two unsigned integers, reverting on
1770  * overflow.
1771  *
1772  * Counterpart to Solidity's `+` operator.
1773  *
1774  * Requirements:
1775  *
1776  * - Addition cannot overflow.
1777  */
1778 function add(uint256 a, uint256 b) internal pure returns (uint256) {
1779 return a + b;
1780 }
1781 
1782 /**
1783  * @dev Returns the subtraction of two unsigned integers, reverting on
1784  * overflow (when the result is negative).
1785  *
1786  * Counterpart to Solidity's `-` operator.
1787  *
1788  * Requirements:
1789  *
1790  * - Subtraction cannot overflow.
1791  */
1792 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1793 return a - b;
1794 }
1795 
1796 /**
1797  * @dev Returns the multiplication of two unsigned integers, reverting on
1798  * overflow.
1799  *
1800  * Counterpart to Solidity's `*` operator.
1801  *
1802  * Requirements:
1803  *
1804  * - Multiplication cannot overflow.
1805  */
1806 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1807 return a * b;
1808 }
1809 
1810 /**
1811  * @dev Returns the integer division of two unsigned integers, reverting on
1812  * division by zero. The result is rounded towards zero.
1813  *
1814  * Counterpart to Solidity's `/` operator.
1815  *
1816  * Requirements:
1817  *
1818  * - The divisor cannot be zero.
1819  */
1820 function div(uint256 a, uint256 b) internal pure returns (uint256) {
1821 return a / b;
1822 }
1823 
1824 /**
1825  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1826  * reverting when dividing by zero.
1827  *
1828  * Counterpart to Solidity's `%` operator. This function uses a `revert`
1829  * opcode (which leaves remaining gas untouched) while Solidity uses an
1830  * invalid opcode to revert (consuming all remaining gas).
1831  *
1832  * Requirements:
1833  *
1834  * - The divisor cannot be zero.
1835  */
1836 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1837 return a % b;
1838 }
1839 
1840 /**
1841  * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1842  * overflow (when the result is negative).
1843  *
1844  * CAUTION: This function is deprecated because it requires allocating memory for the error
1845  * message unnecessarily. For custom revert reasons use {trySub}.
1846  *
1847  * Counterpart to Solidity's `-` operator.
1848  *
1849  * Requirements:
1850  *
1851  * - Subtraction cannot overflow.
1852  */
1853 function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1854 unchecked {
1855 require(b <= a, errorMessage);
1856 return a - b;
1857 }
1858 }
1859 
1860 /**
1861  * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1862  * division by zero. The result is rounded towards zero.
1863  *
1864  * Counterpart to Solidity's `%` operator. This function uses a `revert`
1865  * opcode (which leaves remaining gas untouched) while Solidity uses an
1866  * invalid opcode to revert (consuming all remaining gas).
1867  *
1868  * Counterpart to Solidity's `/` operator. Note: this function uses a
1869  * `revert` opcode (which leaves remaining gas untouched) while Solidity
1870  * uses an invalid opcode to revert (consuming all remaining gas).
1871  *
1872  * Requirements:
1873  *
1874  * - The divisor cannot be zero.
1875  */
1876 function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1877 unchecked {
1878 require(b > 0, errorMessage);
1879 return a / b;
1880 }
1881 }
1882 
1883 /**
1884  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1885  * reverting with custom message when dividing by zero.
1886  *
1887  * CAUTION: This function is deprecated because it requires allocating memory for the error
1888  * message unnecessarily. For custom revert reasons use {tryMod}.
1889  *
1890  * Counterpart to Solidity's `%` operator. This function uses a `revert`
1891  * opcode (which leaves remaining gas untouched) while Solidity uses an
1892  * invalid opcode to revert (consuming all remaining gas).
1893  *
1894  * Requirements:
1895  *
1896  * - The divisor cannot be zero.
1897  */
1898 function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1899 unchecked {
1900 require(b > 0, errorMessage);
1901 return a % b;
1902 }
1903 }
1904 }
1905 
1906 
1907 
1908 
1909 
1910 
1911 pragma solidity ^0.8.0;
1912 
1913 
1914 // SPDX-License-Identifier: UNLICENSED
1915 
1916 contract ChainRings is ERC721, Ownable {
1917 using SafeMath for uint256;
1918 using Strings for uint256;
1919 uint public constant MAX_RINGS = 1024;
1920 bool public hasSaleStarted = false;
1921 mapping (uint256 => uint256) public creationDates;
1922 mapping (uint256 => address) public creators;
1923 
1924 // these will be set in future
1925 string public METADATA_PROVENANCE_HASH = "";
1926 string public GENERATOR_ADDRESS = "https://chainrings.com/generator/";
1927 string public IPFS_GENERATOR_ADDRESS = "";
1928 string public SCRIPT = "";
1929 // e.s added minter address to hash algorithm
1930 constructor() ERC721("ChainRings","CRING")  {
1931 setBaseURI("https://chainrings.art/api/token/");
1932 _safeMint(msg.sender, 0);
1933 creationDates[0] = block.number;
1934 creators[0] = msg.sender;
1935 SCRIPT = "class Random{constructor(e){this.seed=e}random_dec(){return this.seed^=this.seed<<13,this.seed^=this.seed>>17,this.seed^=this.seed<<5,(this.seed<0?1+~this.seed:this.seed)%1e3/1e3}random_between(e,a){return e+(a-e)*this.random_dec()}random_int(e,a){return Math.floor(this.random_between(e,a+1))}random_choice(e){return e[Math.floor(this.random_between(0,.99*e.length))]}}let s$,tokenData=window.tokenHash,seed=parseInt(tokenData.slice(0,16),16),rng=new Random(seed),palettes=['e54b4b-ffa987-f7ebe8-444140-1e1e24','a6ebc9-61ff7e-5eeb5b-62ab37-393424','95f9e3-69ebd0-49d49d-558564-564946','97f9f9-a4def9-c1e0f7-cfbae1-c59fc9','ddd1c7-c2cfb2-8db580-7e8987-4b4a67','250902-38040e-640d14-800e13-ad2831','333333-839788-eee0cb-baa898-bfd7ea','585123-eec170-f2a65a-f58549-772f1a','fbf5f3-e28413-000022-de3c4b-c42847','0fa3b1-d9e5d6-eddea4-f7a072-ff9b42','10002b-240046-5a189a-9d4edd-e0aaff','0466c8-023e7d-001845-33415c-7d8597','861657-a64253-d56aa0-bbdbb4-fcf0cc','493843-61988e-a0b2a6-cbbfbb-eabda8','031d44-04395e-70a288-dab785-d5896f','ff0a54-ff5c8a-ff85a1-fbb1bd-f7cad0','463f3a-8a817c-bcb8b1-f4f3ee-e0afa0','dd6e42-e8dab2-4f6d7a-c0d6df-eaeaea','ffd6ff-e7c6ff-c8b6ff-b8c0ff-bbd0ff','aa8f66-ed9b40-ffeedb-61c9a8-ba3b46','a57548-fcd7ad-f6c28b-5296a5-82ddf0','713e5a-63a375-edc79b-d57a66-ca6680','114b5f-456990-e4fde1-f45b69-6b2737','edf2fb-e2eafc-ccdbfd-c1d3fe-abc4ff','9cafb7-ead2ac-fe938c-e6b89c-4281a4','7bdff2-b2f7ef-eff7f6-f7d6e0-f2b5d4','ffcdb2-ffb4a2-e5989b-b5838d-6d6875','f2d7ee-d3bcc0-a5668b-69306d-0e103d','ffbe0b-fb5607-ff006e-8338ec-3a86ff','9b5de5-f15bb5-fee440-00bbf9-00f5d4','fee440-f15bb5-9b5de5-00bbf9-00f5d4','181a99-5d93cc-454593-e05328-e28976','F61067-5E239D-00F0B5-6DECAF-F4F4ED','f8f9fa-dee2e6-adb5bd-495057-212529','212529-000000-adb5bd-495057-f8f9fa'].map(e=>e.split('-').map(e=>'#'+e)),palette=rng.random_choice(palettes),viewport=Math.min(window.innerHeight,window.innerWidth),w=viewport,h=viewport,row=rng.random_int(5,30),rows=row,offset=w/row,cols=rng.random_int(row-row/3,30),radius=w/row,Rstroke=w/500,cellColors=[],cellShapes=[],total=rows*cols,maxHeight=radius*rows,t$=0,tempFrame=0,isThicc=!1,rotation$=rng.random_between(0,1);function stroke$(){return isThicc?++tempFrame>=1e3?(isThicc=!1,Math.max(Rstroke,tempFrame/10)):Math.max(Rstroke,tempFrame/10):(tempFrame=Math.abs(tempFrame-1),Math.max(Rstroke,tempFrame/10))}function setup(){s$=rng.random_between(.001,.004),frameRate(36),noiseSeed(seed),createCanvas(w,h);for(let e=0;e<row*cols;e++)cellColors[e]=rng.random_choice(palette.slice(0,palette.length-1)),cellShapes[e]=rng.random_between(0,1)}function draw(){rotation$<.4?translate(0,0-offset/2):rotation$<.6?(rotate(-PI/2),scale(-1),translate(0,-w-offset/2)):rotation$<.8?(rotate(-PI),translate(-w,-w-radius/2)):(rotate(-PI/2),translate(-w,-offset/2)),background(palette[palette.length-1]),noFill(),strokeWeight(stroke$());for(let e=0;e<cols;e++){const a=width/(cols-1)*e;let t=(t$+(cols-e)/(2*cols)+1)%1;t=Math.sin(map(cos(t*TWO_PI),-1,1,0,1)/1*(Math.PI/2));for(let f=0;f<rows;f++){const d=f/rows*t*maxHeight+offset;if(stroke(cellColors[f*e]),cellShapes[f*e]>.95)push(),fill(cellColors[f*e]),ellipse(a,d,radius),pop();else if(cellShapes[f*e]>.7){if(cellShapes[f*e]>.72){push();let e=color(rng.random_choice(palette)),a=color(rng.random_choice(palette));fill(lerpColor(e,a,Math.abs(100*sin(100*frameCount)))),noStroke(),pop()}rect(a-radius/2,d-radius/2,radius,radius,100*Math.abs(sin(frameCount/100)))}else ellipse(a,d,radius)}}(t$+=s$)>=1&&(t$=0)}function mouseClicked(){isThicc=!isThicc}";
1936 }
1937 
1938 function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1939 uint256 tokenCount = balanceOf(_owner);
1940 if (tokenCount == 0) {
1941 // Return an empty array
1942 return new uint256[](0);
1943 } else {
1944 uint256[] memory result = new uint256[](tokenCount);
1945 uint256 index;
1946 for (index = 0; index < tokenCount; index++) {
1947 result[index] = tokenOfOwnerByIndex(_owner, index);
1948 }
1949 return result;
1950 }
1951 }
1952 
1953 function calculatePrice() public view returns (uint256) {
1954 return 50000000000000000;
1955 }
1956 
1957 function mintRings(uint256 maxRINGS) public payable {
1958 require(totalSupply() < MAX_RINGS, "Sale has already ended");
1959 require(maxRINGS > 0 && maxRINGS <= 10, "You can claim minimum 1, maximum 10 rings");
1960 require(totalSupply().add(maxRINGS) <= MAX_RINGS, "Exceeds MAX_RINGS");
1961 require(msg.value >= calculatePrice().mul(maxRINGS), "Ether value sent is below the price");
1962 
1963 for (uint i = 0; i < maxRINGS; i++) {
1964 uint mintIndex = totalSupply();
1965 _safeMint(msg.sender, mintIndex);
1966 creationDates[mintIndex] = block.number;
1967 creators[mintIndex] = msg.sender;
1968 }
1969 }
1970 
1971 // ONLYOWNER FUNCTIONS
1972 
1973 function setProvenanceHash(string memory _hash) public onlyOwner {
1974 METADATA_PROVENANCE_HASH = _hash;
1975 }
1976 
1977 function setGeneratorIPFSHash(string memory _hash) public onlyOwner {
1978 IPFS_GENERATOR_ADDRESS = _hash;
1979 }
1980 
1981 function setBaseURI(string memory baseURI) public onlyOwner {
1982 _setBaseURI(baseURI);
1983 }
1984 
1985 function startDrop() public onlyOwner {
1986 hasSaleStarted = true;
1987 }
1988 
1989 function pauseDrop() public onlyOwner {
1990 hasSaleStarted = false;
1991 }
1992 
1993 function withdrawAll() public payable onlyOwner {
1994 require(payable(msg.sender).send(address(this).balance));
1995 }
1996 
1997 function tokenHash(uint256 tokenId) public view returns(bytes32){
1998 require(_exists(tokenId), "DOES NOT EXIST");
1999 return bytes32(keccak256(abi.encodePacked(address(this), creationDates[tokenId], creators[tokenId], tokenId)));
2000 }
2001 
2002 function generatorAddress(uint256 tokenId) public view returns (string memory) {
2003 require(_exists(tokenId), "DOES NOT EXIST");
2004 return string(abi.encodePacked(GENERATOR_ADDRESS, tokenId.toString()));
2005 }
2006 
2007 //e.s added this. could be useful
2008 
2009 function IPFSgeneratorAddress(uint256 tokenId) public view returns (string memory) {
2010 require(_exists(tokenId), "DOES NOT EXIST");
2011 return string(abi.encodePacked(IPFS_GENERATOR_ADDRESS, tokenId.toString()));
2012 }
2013 }