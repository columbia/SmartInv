1 // quadrums.art - Generative NFT Collection
2 
3 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
4 
5 pragma solidity 0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant alphabet = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length)
58         internal
59         pure
60         returns (string memory)
61     {
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
72 }
73 
74 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
75 
76 pragma solidity 0.8.0;
77 
78 /**
79  * @dev Library for managing an enumerable variant of Solidity's
80  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
81  * type.
82  *
83  * Maps have the following properties:
84  *
85  * - Entries are added, removed, and checked for existence in constant time
86  * (O(1)).
87  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
88  *
89  * ```
90  * contract Example {
91  *     // Add the library methods
92  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
93  *
94  *     // Declare a set state variable
95  *     EnumerableMap.UintToAddressMap private myMap;
96  * }
97  * ```
98  *
99  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
100  * supported.
101  */
102 library EnumerableMap {
103     // To implement this library for multiple types with as little code
104     // repetition as possible, we write it in terms of a generic Map type with
105     // bytes32 keys and values.
106     // The Map implementation uses private functions, and user-facing
107     // implementations (such as Uint256ToAddressMap) are just wrappers around
108     // the underlying Map.
109     // This means that we can only create new EnumerableMaps for types that fit
110     // in bytes32.
111 
112     struct MapEntry {
113         bytes32 _key;
114         bytes32 _value;
115     }
116 
117     struct Map {
118         // Storage of map keys and values
119         MapEntry[] _entries;
120         // Position of the entry defined by a key in the `entries` array, plus 1
121         // because index 0 means a key is not in the map.
122         mapping(bytes32 => uint256) _indexes;
123     }
124 
125     /**
126      * @dev Adds a key-value pair to a map, or updates the value for an existing
127      * key. O(1).
128      *
129      * Returns true if the key was added to the map, that is if it was not
130      * already present.
131      */
132     function _set(
133         Map storage map,
134         bytes32 key,
135         bytes32 value
136     ) private returns (bool) {
137         // We read and store the key's index to prevent multiple reads from the same storage slot
138         uint256 keyIndex = map._indexes[key];
139 
140         if (keyIndex == 0) {
141             // Equivalent to !contains(map, key)
142             map._entries.push(MapEntry({_key: key, _value: value}));
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
162         if (keyIndex != 0) {
163             // Equivalent to contains(map, key)
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
196     function _contains(Map storage map, bytes32 key)
197         private
198         view
199         returns (bool)
200     {
201         return map._indexes[key] != 0;
202     }
203 
204     /**
205      * @dev Returns the number of key-value pairs in the map. O(1).
206      */
207     function _length(Map storage map) private view returns (uint256) {
208         return map._entries.length;
209     }
210 
211     /**
212      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
213      *
214      * Note that there are no guarantees on the ordering of entries inside the
215      * array, and it may change when more entries are added or removed.
216      *
217      * Requirements:
218      *
219      * - `index` must be strictly less than {length}.
220      */
221     function _at(Map storage map, uint256 index)
222         private
223         view
224         returns (bytes32, bytes32)
225     {
226         require(
227             map._entries.length > index,
228             "EnumerableMap: index out of bounds"
229         );
230 
231         MapEntry storage entry = map._entries[index];
232         return (entry._key, entry._value);
233     }
234 
235     /**
236      * @dev Tries to returns the value associated with `key`.  O(1).
237      * Does not revert if `key` is not in the map.
238      */
239     function _tryGet(Map storage map, bytes32 key)
240         private
241         view
242         returns (bool, bytes32)
243     {
244         uint256 keyIndex = map._indexes[key];
245         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
246         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
247     }
248 
249     /**
250      * @dev Returns the value associated with `key`.  O(1).
251      *
252      * Requirements:
253      *
254      * - `key` must be in the map.
255      */
256     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
257         uint256 keyIndex = map._indexes[key];
258         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
259         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
260     }
261 
262     /**
263      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
264      *
265      * CAUTION: This function is deprecated because it requires allocating memory for the error
266      * message unnecessarily. For custom revert reasons use {_tryGet}.
267      */
268     function _get(
269         Map storage map,
270         bytes32 key,
271         string memory errorMessage
272     ) private view returns (bytes32) {
273         uint256 keyIndex = map._indexes[key];
274         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
275         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
276     }
277 
278     // UintToAddressMap
279 
280     struct UintToAddressMap {
281         Map _inner;
282     }
283 
284     /**
285      * @dev Adds a key-value pair to a map, or updates the value for an existing
286      * key. O(1).
287      *
288      * Returns true if the key was added to the map, that is if it was not
289      * already present.
290      */
291     function set(
292         UintToAddressMap storage map,
293         uint256 key,
294         address value
295     ) internal returns (bool) {
296         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
297     }
298 
299     /**
300      * @dev Removes a value from a set. O(1).
301      *
302      * Returns true if the key was removed from the map, that is if it was present.
303      */
304     function remove(UintToAddressMap storage map, uint256 key)
305         internal
306         returns (bool)
307     {
308         return _remove(map._inner, bytes32(key));
309     }
310 
311     /**
312      * @dev Returns true if the key is in the map. O(1).
313      */
314     function contains(UintToAddressMap storage map, uint256 key)
315         internal
316         view
317         returns (bool)
318     {
319         return _contains(map._inner, bytes32(key));
320     }
321 
322     /**
323      * @dev Returns the number of elements in the map. O(1).
324      */
325     function length(UintToAddressMap storage map)
326         internal
327         view
328         returns (uint256)
329     {
330         return _length(map._inner);
331     }
332 
333     /**
334      * @dev Returns the element stored at position `index` in the set. O(1).
335      * Note that there are no guarantees on the ordering of values inside the
336      * array, and it may change when more values are added or removed.
337      *
338      * Requirements:
339      *
340      * - `index` must be strictly less than {length}.
341      */
342     function at(UintToAddressMap storage map, uint256 index)
343         internal
344         view
345         returns (uint256, address)
346     {
347         (bytes32 key, bytes32 value) = _at(map._inner, index);
348         return (uint256(key), address(uint160(uint256(value))));
349     }
350 
351     /**
352      * @dev Tries to returns the value associated with `key`.  O(1).
353      * Does not revert if `key` is not in the map.
354      *
355      * _Available since v3.4._
356      */
357     function tryGet(UintToAddressMap storage map, uint256 key)
358         internal
359         view
360         returns (bool, address)
361     {
362         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
363         return (success, address(uint160(uint256(value))));
364     }
365 
366     /**
367      * @dev Returns the value associated with `key`.  O(1).
368      *
369      * Requirements:
370      *
371      * - `key` must be in the map.
372      */
373     function get(UintToAddressMap storage map, uint256 key)
374         internal
375         view
376         returns (address)
377     {
378         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
379     }
380 
381     /**
382      * @dev Same as {get}, with a custom error message when `key` is not in the map.
383      *
384      * CAUTION: This function is deprecated because it requires allocating memory for the error
385      * message unnecessarily. For custom revert reasons use {tryGet}.
386      */
387     function get(
388         UintToAddressMap storage map,
389         uint256 key,
390         string memory errorMessage
391     ) internal view returns (address) {
392         return
393             address(
394                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
395             );
396     }
397 }
398 
399 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
400 
401 pragma solidity 0.8.0;
402 
403 /**
404  * @dev Library for managing
405  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
406  * types.
407  *
408  * Sets have the following properties:
409  *
410  * - Elements are added, removed, and checked for existence in constant time
411  * (O(1)).
412  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
413  *
414  * ```
415  * contract Example {
416  *     // Add the library methods
417  *     using EnumerableSet for EnumerableSet.AddressSet;
418  *
419  *     // Declare a set state variable
420  *     EnumerableSet.AddressSet private mySet;
421  * }
422  * ```
423  *
424  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
425  * and `uint256` (`UintSet`) are supported.
426  */
427 library EnumerableSet {
428     // To implement this library for multiple types with as little code
429     // repetition as possible, we write it in terms of a generic Set type with
430     // bytes32 values.
431     // The Set implementation uses private functions, and user-facing
432     // implementations (such as AddressSet) are just wrappers around the
433     // underlying Set.
434     // This means that we can only create new EnumerableSets for types that fit
435     // in bytes32.
436 
437     struct Set {
438         // Storage of set values
439         bytes32[] _values;
440         // Position of the value in the `values` array, plus 1 because index 0
441         // means a value is not in the set.
442         mapping(bytes32 => uint256) _indexes;
443     }
444 
445     /**
446      * @dev Add a value to a set. O(1).
447      *
448      * Returns true if the value was added to the set, that is if it was not
449      * already present.
450      */
451     function _add(Set storage set, bytes32 value) private returns (bool) {
452         if (!_contains(set, value)) {
453             set._values.push(value);
454             // The value is stored at length-1, but we add 1 to all indexes
455             // and use 0 as a sentinel value
456             set._indexes[value] = set._values.length;
457             return true;
458         } else {
459             return false;
460         }
461     }
462 
463     /**
464      * @dev Removes a value from a set. O(1).
465      *
466      * Returns true if the value was removed from the set, that is if it was
467      * present.
468      */
469     function _remove(Set storage set, bytes32 value) private returns (bool) {
470         // We read and store the value's index to prevent multiple reads from the same storage slot
471         uint256 valueIndex = set._indexes[value];
472 
473         if (valueIndex != 0) {
474             // Equivalent to contains(set, value)
475             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
476             // the array, and then remove the last element (sometimes called as 'swap and pop').
477             // This modifies the order of the array, as noted in {at}.
478 
479             uint256 toDeleteIndex = valueIndex - 1;
480             uint256 lastIndex = set._values.length - 1;
481 
482             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
483             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
484 
485             bytes32 lastvalue = set._values[lastIndex];
486 
487             // Move the last value to the index where the value to delete is
488             set._values[toDeleteIndex] = lastvalue;
489             // Update the index for the moved value
490             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
491 
492             // Delete the slot where the moved value was stored
493             set._values.pop();
494 
495             // Delete the index for the deleted slot
496             delete set._indexes[value];
497 
498             return true;
499         } else {
500             return false;
501         }
502     }
503 
504     /**
505      * @dev Returns true if the value is in the set. O(1).
506      */
507     function _contains(Set storage set, bytes32 value)
508         private
509         view
510         returns (bool)
511     {
512         return set._indexes[value] != 0;
513     }
514 
515     /**
516      * @dev Returns the number of values on the set. O(1).
517      */
518     function _length(Set storage set) private view returns (uint256) {
519         return set._values.length;
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
532     function _at(Set storage set, uint256 index)
533         private
534         view
535         returns (bytes32)
536     {
537         require(
538             set._values.length > index,
539             "EnumerableSet: index out of bounds"
540         );
541         return set._values[index];
542     }
543 
544     // Bytes32Set
545 
546     struct Bytes32Set {
547         Set _inner;
548     }
549 
550     /**
551      * @dev Add a value to a set. O(1).
552      *
553      * Returns true if the value was added to the set, that is if it was not
554      * already present.
555      */
556     function add(Bytes32Set storage set, bytes32 value)
557         internal
558         returns (bool)
559     {
560         return _add(set._inner, value);
561     }
562 
563     /**
564      * @dev Removes a value from a set. O(1).
565      *
566      * Returns true if the value was removed from the set, that is if it was
567      * present.
568      */
569     function remove(Bytes32Set storage set, bytes32 value)
570         internal
571         returns (bool)
572     {
573         return _remove(set._inner, value);
574     }
575 
576     /**
577      * @dev Returns true if the value is in the set. O(1).
578      */
579     function contains(Bytes32Set storage set, bytes32 value)
580         internal
581         view
582         returns (bool)
583     {
584         return _contains(set._inner, value);
585     }
586 
587     /**
588      * @dev Returns the number of values in the set. O(1).
589      */
590     function length(Bytes32Set storage set) internal view returns (uint256) {
591         return _length(set._inner);
592     }
593 
594     /**
595      * @dev Returns the value stored at position `index` in the set. O(1).
596      *
597      * Note that there are no guarantees on the ordering of values inside the
598      * array, and it may change when more values are added or removed.
599      *
600      * Requirements:
601      *
602      * - `index` must be strictly less than {length}.
603      */
604     function at(Bytes32Set storage set, uint256 index)
605         internal
606         view
607         returns (bytes32)
608     {
609         return _at(set._inner, index);
610     }
611 
612     // AddressSet
613 
614     struct AddressSet {
615         Set _inner;
616     }
617 
618     /**
619      * @dev Add a value to a set. O(1).
620      *
621      * Returns true if the value was added to the set, that is if it was not
622      * already present.
623      */
624     function add(AddressSet storage set, address value)
625         internal
626         returns (bool)
627     {
628         return _add(set._inner, bytes32(uint256(uint160(value))));
629     }
630 
631     /**
632      * @dev Removes a value from a set. O(1).
633      *
634      * Returns true if the value was removed from the set, that is if it was
635      * present.
636      */
637     function remove(AddressSet storage set, address value)
638         internal
639         returns (bool)
640     {
641         return _remove(set._inner, bytes32(uint256(uint160(value))));
642     }
643 
644     /**
645      * @dev Returns true if the value is in the set. O(1).
646      */
647     function contains(AddressSet storage set, address value)
648         internal
649         view
650         returns (bool)
651     {
652         return _contains(set._inner, bytes32(uint256(uint160(value))));
653     }
654 
655     /**
656      * @dev Returns the number of values in the set. O(1).
657      */
658     function length(AddressSet storage set) internal view returns (uint256) {
659         return _length(set._inner);
660     }
661 
662     /**
663      * @dev Returns the value stored at position `index` in the set. O(1).
664      *
665      * Note that there are no guarantees on the ordering of values inside the
666      * array, and it may change when more values are added or removed.
667      *
668      * Requirements:
669      *
670      * - `index` must be strictly less than {length}.
671      */
672     function at(AddressSet storage set, uint256 index)
673         internal
674         view
675         returns (address)
676     {
677         return address(uint160(uint256(_at(set._inner, index))));
678     }
679 
680     // UintSet
681 
682     struct UintSet {
683         Set _inner;
684     }
685 
686     /**
687      * @dev Add a value to a set. O(1).
688      *
689      * Returns true if the value was added to the set, that is if it was not
690      * already present.
691      */
692     function add(UintSet storage set, uint256 value) internal returns (bool) {
693         return _add(set._inner, bytes32(value));
694     }
695 
696     /**
697      * @dev Removes a value from a set. O(1).
698      *
699      * Returns true if the value was removed from the set, that is if it was
700      * present.
701      */
702     function remove(UintSet storage set, uint256 value)
703         internal
704         returns (bool)
705     {
706         return _remove(set._inner, bytes32(value));
707     }
708 
709     /**
710      * @dev Returns true if the value is in the set. O(1).
711      */
712     function contains(UintSet storage set, uint256 value)
713         internal
714         view
715         returns (bool)
716     {
717         return _contains(set._inner, bytes32(value));
718     }
719 
720     /**
721      * @dev Returns the number of values on the set. O(1).
722      */
723     function length(UintSet storage set) internal view returns (uint256) {
724         return _length(set._inner);
725     }
726 
727     /**
728      * @dev Returns the value stored at position `index` in the set. O(1).
729      *
730      * Note that there are no guarantees on the ordering of values inside the
731      * array, and it may change when more values are added or removed.
732      *
733      * Requirements:
734      *
735      * - `index` must be strictly less than {length}.
736      */
737     function at(UintSet storage set, uint256 index)
738         internal
739         view
740         returns (uint256)
741     {
742         return uint256(_at(set._inner, index));
743     }
744 }
745 
746 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
747 
748 pragma solidity 0.8.0;
749 
750 /**
751  * @dev Collection of functions related to the address type
752  */
753 library Address {
754     /**
755      * @dev Returns true if `account` is a contract.
756      *
757      * [IMPORTANT]
758      * ====
759      * It is unsafe to assume that an address for which this function returns
760      * false is an externally-owned account (EOA) and not a contract.
761      *
762      * Among others, `isContract` will return false for the following
763      * types of addresses:
764      *
765      *  - an externally-owned account
766      *  - a contract in construction
767      *  - an address where a contract will be created
768      *  - an address where a contract lived, but was destroyed
769      * ====
770      */
771     function isContract(address account) internal view returns (bool) {
772         // This method relies on extcodesize, which returns 0 for contracts in
773         // construction, since the code is only stored at the end of the
774         // constructor execution.
775 
776         uint256 size;
777         // solhint-disable-next-line no-inline-assembly
778         assembly {
779             size := extcodesize(account)
780         }
781         return size > 0;
782     }
783 
784     /**
785      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
786      * `recipient`, forwarding all available gas and reverting on errors.
787      *
788      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
789      * of certain opcodes, possibly making contracts go over the 2300 gas limit
790      * imposed by `transfer`, making them unable to receive funds via
791      * `transfer`. {sendValue} removes this limitation.
792      *
793      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
794      *
795      * IMPORTANT: because control is transferred to `recipient`, care must be
796      * taken to not create reentrancy vulnerabilities. Consider using
797      * {ReentrancyGuard} or the
798      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
799      */
800     function sendValue(address payable recipient, uint256 amount) internal {
801         require(
802             address(this).balance >= amount,
803             "Address: insufficient balance"
804         );
805 
806         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
807         (bool success, ) = recipient.call{value: amount}("");
808         require(
809             success,
810             "Address: unable to send value, recipient may have reverted"
811         );
812     }
813 
814     /**
815      * @dev Performs a Solidity function call using a low level `call`. A
816      * plain`call` is an unsafe replacement for a function call: use this
817      * function instead.
818      *
819      * If `target` reverts with a revert reason, it is bubbled up by this
820      * function (like regular Solidity function calls).
821      *
822      * Returns the raw returned data. To convert to the expected return value,
823      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
824      *
825      * Requirements:
826      *
827      * - `target` must be a contract.
828      * - calling `target` with `data` must not revert.
829      *
830      * _Available since v3.1._
831      */
832     function functionCall(address target, bytes memory data)
833         internal
834         returns (bytes memory)
835     {
836         return functionCall(target, data, "Address: low-level call failed");
837     }
838 
839     /**
840      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
841      * `errorMessage` as a fallback revert reason when `target` reverts.
842      *
843      * _Available since v3.1._
844      */
845     function functionCall(
846         address target,
847         bytes memory data,
848         string memory errorMessage
849     ) internal returns (bytes memory) {
850         return functionCallWithValue(target, data, 0, errorMessage);
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
855      * but also transferring `value` wei to `target`.
856      *
857      * Requirements:
858      *
859      * - the calling contract must have an ETH balance of at least `value`.
860      * - the called Solidity function must be `payable`.
861      *
862      * _Available since v3.1._
863      */
864     function functionCallWithValue(
865         address target,
866         bytes memory data,
867         uint256 value
868     ) internal returns (bytes memory) {
869         return
870             functionCallWithValue(
871                 target,
872                 data,
873                 value,
874                 "Address: low-level call with value failed"
875             );
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
880      * with `errorMessage` as a fallback revert reason when `target` reverts.
881      *
882      * _Available since v3.1._
883      */
884     function functionCallWithValue(
885         address target,
886         bytes memory data,
887         uint256 value,
888         string memory errorMessage
889     ) internal returns (bytes memory) {
890         require(
891             address(this).balance >= value,
892             "Address: insufficient balance for call"
893         );
894         require(isContract(target), "Address: call to non-contract");
895 
896         // solhint-disable-next-line avoid-low-level-calls
897         (bool success, bytes memory returndata) = target.call{value: value}(
898             data
899         );
900         return _verifyCallResult(success, returndata, errorMessage);
901     }
902 
903     /**
904      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
905      * but performing a static call.
906      *
907      * _Available since v3.3._
908      */
909     function functionStaticCall(address target, bytes memory data)
910         internal
911         view
912         returns (bytes memory)
913     {
914         return
915             functionStaticCall(
916                 target,
917                 data,
918                 "Address: low-level static call failed"
919             );
920     }
921 
922     /**
923      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
924      * but performing a static call.
925      *
926      * _Available since v3.3._
927      */
928     function functionStaticCall(
929         address target,
930         bytes memory data,
931         string memory errorMessage
932     ) internal view returns (bytes memory) {
933         require(isContract(target), "Address: static call to non-contract");
934 
935         // solhint-disable-next-line avoid-low-level-calls
936         (bool success, bytes memory returndata) = target.staticcall(data);
937         return _verifyCallResult(success, returndata, errorMessage);
938     }
939 
940     /**
941      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
942      * but performing a delegate call.
943      *
944      * _Available since v3.4._
945      */
946     function functionDelegateCall(address target, bytes memory data)
947         internal
948         returns (bytes memory)
949     {
950         return
951             functionDelegateCall(
952                 target,
953                 data,
954                 "Address: low-level delegate call failed"
955             );
956     }
957 
958     /**
959      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
960      * but performing a delegate call.
961      *
962      * _Available since v3.4._
963      */
964     function functionDelegateCall(
965         address target,
966         bytes memory data,
967         string memory errorMessage
968     ) internal returns (bytes memory) {
969         require(isContract(target), "Address: delegate call to non-contract");
970 
971         // solhint-disable-next-line avoid-low-level-calls
972         (bool success, bytes memory returndata) = target.delegatecall(data);
973         return _verifyCallResult(success, returndata, errorMessage);
974     }
975 
976     function _verifyCallResult(
977         bool success,
978         bytes memory returndata,
979         string memory errorMessage
980     ) private pure returns (bytes memory) {
981         if (success) {
982             return returndata;
983         } else {
984             // Look for revert reason and bubble it up if present
985             if (returndata.length > 0) {
986                 // The easiest way to bubble the revert reason is using memory via assembly
987 
988                 // solhint-disable-next-line no-inline-assembly
989                 assembly {
990                     let returndata_size := mload(returndata)
991                     revert(add(32, returndata), returndata_size)
992                 }
993             } else {
994                 revert(errorMessage);
995             }
996         }
997     }
998 }
999 
1000 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
1001 
1002 pragma solidity 0.8.0;
1003 
1004 /**
1005  * @dev Interface of the ERC165 standard, as defined in the
1006  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1007  *
1008  * Implementers can declare support of contract interfaces, which can then be
1009  * queried by others ({ERC165Checker}).
1010  *
1011  * For an implementation, see {ERC165}.
1012  */
1013 interface IERC165 {
1014     /**
1015      * @dev Returns true if this contract implements the interface defined by
1016      * `interfaceId`. See the corresponding
1017      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1018      * to learn more about how these ids are created.
1019      *
1020      * This function call must use less than 30 000 gas.
1021      */
1022     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1023 }
1024 
1025 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
1026 
1027 pragma solidity 0.8.0;
1028 
1029 /**
1030  * @dev Implementation of the {IERC165} interface.
1031  *
1032  * Contracts may inherit from this and call {_registerInterface} to declare
1033  * their support of an interface.
1034  */
1035 abstract contract ERC165 is IERC165 {
1036     /**
1037      * @dev Mapping of interface ids to whether or not it's supported.
1038      */
1039     mapping(bytes4 => bool) private _supportedInterfaces;
1040 
1041     constructor() {
1042         // Derived contracts need only register support for their own interfaces,
1043         // we register support for ERC165 itself here
1044         _registerInterface(type(IERC165).interfaceId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      *
1050      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1051      */
1052     function supportsInterface(bytes4 interfaceId)
1053         public
1054         view
1055         virtual
1056         override
1057         returns (bool)
1058     {
1059         return _supportedInterfaces[interfaceId];
1060     }
1061 
1062     /**
1063      * @dev Registers the contract as an implementer of the interface defined by
1064      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1065      * registering its interface id is not required.
1066      *
1067      * See {IERC165-supportsInterface}.
1068      *
1069      * Requirements:
1070      *
1071      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1072      */
1073     function _registerInterface(bytes4 interfaceId) internal virtual {
1074         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1075         _supportedInterfaces[interfaceId] = true;
1076     }
1077 }
1078 
1079 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
1080 
1081 pragma solidity 0.8.0;
1082 
1083 /**
1084  * @dev Required interface of an ERC721 compliant contract.
1085  */
1086 interface IERC721 is IERC165 {
1087     /**
1088      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1089      */
1090     event Transfer(
1091         address indexed from,
1092         address indexed to,
1093         uint256 indexed tokenId
1094     );
1095 
1096     /**
1097      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1098      */
1099     event Approval(
1100         address indexed owner,
1101         address indexed approved,
1102         uint256 indexed tokenId
1103     );
1104 
1105     /**
1106      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1107      */
1108     event ApprovalForAll(
1109         address indexed owner,
1110         address indexed operator,
1111         bool approved
1112     );
1113 
1114     /**
1115      * @dev Returns the number of tokens in ``owner``'s account.
1116      */
1117     function balanceOf(address owner) external view returns (uint256 balance);
1118 
1119     /**
1120      * @dev Returns the owner of the `tokenId` token.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must exist.
1125      */
1126     function ownerOf(uint256 tokenId) external view returns (address owner);
1127 
1128     /**
1129      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1130      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1131      *
1132      * Requirements:
1133      *
1134      * - `from` cannot be the zero address.
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must exist and be owned by `from`.
1137      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function safeTransferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) external;
1147 
1148     /**
1149      * @dev Transfers `tokenId` token from `from` to `to`.
1150      *
1151      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1152      *
1153      * Requirements:
1154      *
1155      * - `from` cannot be the zero address.
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must be owned by `from`.
1158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function transferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) external;
1167 
1168     /**
1169      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1170      * The approval is cleared when the token is transferred.
1171      *
1172      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1173      *
1174      * Requirements:
1175      *
1176      * - The caller must own the token or be an approved operator.
1177      * - `tokenId` must exist.
1178      *
1179      * Emits an {Approval} event.
1180      */
1181     function approve(address to, uint256 tokenId) external;
1182 
1183     /**
1184      * @dev Returns the account approved for `tokenId` token.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      */
1190     function getApproved(uint256 tokenId)
1191         external
1192         view
1193         returns (address operator);
1194 
1195     /**
1196      * @dev Approve or remove `operator` as an operator for the caller.
1197      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1198      *
1199      * Requirements:
1200      *
1201      * - The `operator` cannot be the caller.
1202      *
1203      * Emits an {ApprovalForAll} event.
1204      */
1205     function setApprovalForAll(address operator, bool _approved) external;
1206 
1207     /**
1208      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1209      *
1210      * See {setApprovalForAll}
1211      */
1212     function isApprovedForAll(address owner, address operator)
1213         external
1214         view
1215         returns (bool);
1216 
1217     /**
1218      * @dev Safely transfers `tokenId` token from `from` to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - `from` cannot be the zero address.
1223      * - `to` cannot be the zero address.
1224      * - `tokenId` token must exist and be owned by `from`.
1225      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1226      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1227      *
1228      * Emits a {Transfer} event.
1229      */
1230     function safeTransferFrom(
1231         address from,
1232         address to,
1233         uint256 tokenId,
1234         bytes calldata data
1235     ) external;
1236 }
1237 
1238 pragma solidity 0.8.0;
1239 
1240 /**
1241  * @title ERC721 token receiver interface
1242  * @dev Interface for any contract that wants to support safeTransfers
1243  * from ERC721 asset contracts.
1244  */
1245 interface IERC721Receiver {
1246     /**
1247      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1248      * by `operator` from `from`, this function is called.
1249      *
1250      * It must return its Solidity selector to confirm the token transfer.
1251      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1252      *
1253      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1254      */
1255     function onERC721Received(
1256         address operator,
1257         address from,
1258         uint256 tokenId,
1259         bytes calldata data
1260     ) external returns (bytes4);
1261 }
1262 
1263 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1264 
1265 pragma solidity 0.8.0;
1266 
1267 /**
1268  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1269  * @dev See https://eips.ethereum.org/EIPS/eip-721
1270  */
1271 interface IERC721Enumerable is IERC721 {
1272     /**
1273      * @dev Returns the total amount of tokens stored by the contract.
1274      */
1275     function totalSupply() external view returns (uint256);
1276 
1277     /**
1278      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1279      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1280      */
1281     function tokenOfOwnerByIndex(address owner, uint256 index)
1282         external
1283         view
1284         returns (uint256 tokenId);
1285 
1286     /**
1287      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1288      * Use along with {totalSupply} to enumerate all tokens.
1289      */
1290     function tokenByIndex(uint256 index) external view returns (uint256);
1291 }
1292 
1293 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1294 
1295 pragma solidity 0.8.0;
1296 
1297 /**
1298  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1299  * @dev See https://eips.ethereum.org/EIPS/eip-721
1300  */
1301 interface IERC721Metadata is IERC721 {
1302     /**
1303      * @dev Returns the token collection name.
1304      */
1305     function name() external view returns (string memory);
1306 
1307     /**
1308      * @dev Returns the token collection symbol.
1309      */
1310     function symbol() external view returns (string memory);
1311 
1312     /**
1313      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1314      */
1315     function tokenURI(uint256 tokenId) external view returns (string memory);
1316 }
1317 
1318 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1319 
1320 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1321 
1322 pragma solidity 0.8.0;
1323 
1324 /*
1325  * @dev Provides information about the current execution context, including the
1326  * sender of the transaction and its data. While these are generally available
1327  * via msg.sender and msg.data, they should not be accessed in such a direct
1328  * manner, since when dealing with GSN meta-transactions the account sending and
1329  * paying for execution may not be the actual sender (as far as an application
1330  * is concerned).
1331  *
1332  * This contract is only required for intermediate, library-like contracts.
1333  */
1334 abstract contract Context {
1335     function _msgSender() internal view virtual returns (address) {
1336         return msg.sender;
1337     }
1338 
1339     function _msgData() internal view virtual returns (bytes calldata) {
1340         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1341         return msg.data;
1342     }
1343 }
1344 
1345 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1346 
1347 pragma solidity 0.8.0;
1348 
1349 /**
1350  * @title ERC721 Non-Fungible Token Standard basic implementation
1351  * @dev see https://eips.ethereum.org/EIPS/eip-721
1352  */
1353 contract ERC721 is
1354     Context,
1355     ERC165,
1356     IERC721,
1357     IERC721Metadata,
1358     IERC721Enumerable
1359 {
1360     using Address for address;
1361     using EnumerableSet for EnumerableSet.UintSet;
1362     using EnumerableMap for EnumerableMap.UintToAddressMap;
1363     using Strings for uint256;
1364 
1365     // Mapping from holder address to their (enumerable) set of owned tokens
1366     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1367 
1368     // Enumerable mapping from token ids to their owners
1369     EnumerableMap.UintToAddressMap private _tokenOwners;
1370 
1371     // Mapping from token ID to approved address
1372     mapping(uint256 => address) private _tokenApprovals;
1373 
1374     // Mapping from owner to operator approvals
1375     mapping(address => mapping(address => bool)) private _operatorApprovals;
1376 
1377     // Token name
1378     string private _name;
1379 
1380     // Token symbol
1381     string private _symbol;
1382 
1383     // Optional mapping for token URIs
1384     mapping(uint256 => string) private _tokenURIs;
1385 
1386     // Base URI
1387     string private _baseURI;
1388 
1389     /**
1390      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1391      */
1392     constructor(string memory name_, string memory symbol_) {
1393         _name = name_;
1394         _symbol = symbol_;
1395 
1396         // register the supported interfaces to conform to ERC721 via ERC165
1397         _registerInterface(type(IERC721).interfaceId);
1398         _registerInterface(type(IERC721Metadata).interfaceId);
1399         _registerInterface(type(IERC721Enumerable).interfaceId);
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-balanceOf}.
1404      */
1405     function balanceOf(address owner)
1406         public
1407         view
1408         virtual
1409         override
1410         returns (uint256)
1411     {
1412         require(
1413             owner != address(0),
1414             "ERC721: balance query for the zero address"
1415         );
1416         return _holderTokens[owner].length();
1417     }
1418 
1419     /**
1420      * @dev See {IERC721-ownerOf}.
1421      */
1422     function ownerOf(uint256 tokenId)
1423         public
1424         view
1425         virtual
1426         override
1427         returns (address)
1428     {
1429         return
1430             _tokenOwners.get(
1431                 tokenId,
1432                 "ERC721: owner query for nonexistent token"
1433             );
1434     }
1435 
1436     /**
1437      * @dev See {IERC721Metadata-name}.
1438      */
1439     function name() public view virtual override returns (string memory) {
1440         return _name;
1441     }
1442 
1443     /**
1444      * @dev See {IERC721Metadata-symbol}.
1445      */
1446     function symbol() public view virtual override returns (string memory) {
1447         return _symbol;
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Metadata-tokenURI}.
1452      */
1453     function tokenURI(uint256 tokenId)
1454         public
1455         view
1456         virtual
1457         override
1458         returns (string memory)
1459     {
1460         require(
1461             _exists(tokenId),
1462             "ERC721Metadata: URI query for nonexistent token"
1463         );
1464 
1465         string memory _tokenURI = _tokenURIs[tokenId];
1466         string memory base = baseURI();
1467 
1468         // If there is no base URI, return the token URI.
1469         if (bytes(base).length == 0) {
1470             return _tokenURI;
1471         }
1472         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1473         if (bytes(_tokenURI).length > 0) {
1474             return string(abi.encodePacked(base, _tokenURI));
1475         }
1476         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1477         return string(abi.encodePacked(base, tokenId.toString()));
1478     }
1479 
1480     /**
1481      * @dev Returns the base URI set via {_setBaseURI}. This will be
1482      * automatically added as a prefix in {tokenURI} to each token's URI, or
1483      * to the token ID if no specific URI is set for that token ID.
1484      */
1485     function baseURI() public view virtual returns (string memory) {
1486         return _baseURI;
1487     }
1488 
1489     /**
1490      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1491      */
1492     function tokenOfOwnerByIndex(address owner, uint256 index)
1493         public
1494         view
1495         virtual
1496         override
1497         returns (uint256)
1498     {
1499         return _holderTokens[owner].at(index);
1500     }
1501 
1502     /**
1503      * @dev See {IERC721Enumerable-totalSupply}.
1504      */
1505     function totalSupply() public view virtual override returns (uint256) {
1506         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1507         return _tokenOwners.length();
1508     }
1509 
1510     /**
1511      * @dev See {IERC721Enumerable-tokenByIndex}.
1512      */
1513     function tokenByIndex(uint256 index)
1514         public
1515         view
1516         virtual
1517         override
1518         returns (uint256)
1519     {
1520         (uint256 tokenId, ) = _tokenOwners.at(index);
1521         return tokenId;
1522     }
1523 
1524     /**
1525      * @dev See {IERC721-approve}.
1526      */
1527     function approve(address to, uint256 tokenId) public virtual override {
1528         address owner = ERC721.ownerOf(tokenId);
1529         require(to != owner, "ERC721: approval to current owner");
1530 
1531         require(
1532             _msgSender() == owner ||
1533                 ERC721.isApprovedForAll(owner, _msgSender()),
1534             "ERC721: approve caller is not owner nor approved for all"
1535         );
1536 
1537         _approve(to, tokenId);
1538     }
1539 
1540     /**
1541      * @dev See {IERC721-getApproved}.
1542      */
1543     function getApproved(uint256 tokenId)
1544         public
1545         view
1546         virtual
1547         override
1548         returns (address)
1549     {
1550         require(
1551             _exists(tokenId),
1552             "ERC721: approved query for nonexistent token"
1553         );
1554 
1555         return _tokenApprovals[tokenId];
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-setApprovalForAll}.
1560      */
1561     function setApprovalForAll(address operator, bool approved)
1562         public
1563         virtual
1564         override
1565     {
1566         require(operator != _msgSender(), "ERC721: approve to caller");
1567 
1568         _operatorApprovals[_msgSender()][operator] = approved;
1569         emit ApprovalForAll(_msgSender(), operator, approved);
1570     }
1571 
1572     /**
1573      * @dev See {IERC721-isApprovedForAll}.
1574      */
1575     function isApprovedForAll(address owner, address operator)
1576         public
1577         view
1578         virtual
1579         override
1580         returns (bool)
1581     {
1582         return _operatorApprovals[owner][operator];
1583     }
1584 
1585     /**
1586      * @dev See {IERC721-transferFrom}.
1587      */
1588     function transferFrom(
1589         address from,
1590         address to,
1591         uint256 tokenId
1592     ) public virtual override {
1593         //solhint-disable-next-line max-line-length
1594         require(
1595             _isApprovedOrOwner(_msgSender(), tokenId),
1596             "ERC721: transfer caller is not owner nor approved"
1597         );
1598 
1599         _transfer(from, to, tokenId);
1600     }
1601 
1602     /**
1603      * @dev See {IERC721-safeTransferFrom}.
1604      */
1605     function safeTransferFrom(
1606         address from,
1607         address to,
1608         uint256 tokenId
1609     ) public virtual override {
1610         safeTransferFrom(from, to, tokenId, "");
1611     }
1612 
1613     /**
1614      * @dev See {IERC721-safeTransferFrom}.
1615      */
1616     function safeTransferFrom(
1617         address from,
1618         address to,
1619         uint256 tokenId,
1620         bytes memory _data
1621     ) public virtual override {
1622         require(
1623             _isApprovedOrOwner(_msgSender(), tokenId),
1624             "ERC721: transfer caller is not owner nor approved"
1625         );
1626         _safeTransfer(from, to, tokenId, _data);
1627     }
1628 
1629     /**
1630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1632      *
1633      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1634      *
1635      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1636      * implement alternative mechanisms to perform token transfer, such as signature-based.
1637      *
1638      * Requirements:
1639      *
1640      * - `from` cannot be the zero address.
1641      * - `to` cannot be the zero address.
1642      * - `tokenId` token must exist and be owned by `from`.
1643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1644      *
1645      * Emits a {Transfer} event.
1646      */
1647     function _safeTransfer(
1648         address from,
1649         address to,
1650         uint256 tokenId,
1651         bytes memory _data
1652     ) internal virtual {
1653         _transfer(from, to, tokenId);
1654         require(
1655             _checkOnERC721Received(from, to, tokenId, _data),
1656             "ERC721: transfer to non ERC721Receiver implementer"
1657         );
1658     }
1659 
1660     /**
1661      * @dev Returns whether `tokenId` exists.
1662      *
1663      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1664      *
1665      * Tokens start existing when they are minted (`_mint`),
1666      * and stop existing when they are burned (`_burn`).
1667      */
1668     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1669         return _tokenOwners.contains(tokenId);
1670     }
1671 
1672     /**
1673      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1674      *
1675      * Requirements:
1676      *
1677      * - `tokenId` must exist.
1678      */
1679     function _isApprovedOrOwner(address spender, uint256 tokenId)
1680         internal
1681         view
1682         virtual
1683         returns (bool)
1684     {
1685         require(
1686             _exists(tokenId),
1687             "ERC721: operator query for nonexistent token"
1688         );
1689         address owner = ERC721.ownerOf(tokenId);
1690         return (spender == owner ||
1691             getApproved(tokenId) == spender ||
1692             ERC721.isApprovedForAll(owner, spender));
1693     }
1694 
1695     /**
1696      * @dev Safely mints `tokenId` and transfers it to `to`.
1697      *
1698      * Requirements:
1699      d*
1700      * - `tokenId` must not exist.
1701      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1702      *
1703      * Emits a {Transfer} event.
1704      */
1705     function _safeMint(address to, uint256 tokenId) internal virtual {
1706         _safeMint(to, tokenId, "");
1707     }
1708 
1709     /**
1710      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1711      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1712      */
1713     function _safeMint(
1714         address to,
1715         uint256 tokenId,
1716         bytes memory _data
1717     ) internal virtual {
1718         _mint(to, tokenId);
1719         require(
1720             _checkOnERC721Received(address(0), to, tokenId, _data),
1721             "ERC721: transfer to non ERC721Receiver implementer"
1722         );
1723     }
1724 
1725     /**
1726      * @dev Mints `tokenId` and transfers it to `to`.
1727      *
1728      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1729      *
1730      * Requirements:
1731      *
1732      * - `tokenId` must not exist.
1733      * - `to` cannot be the zero address.
1734      *
1735      * Emits a {Transfer} event.
1736      */
1737     function _mint(address to, uint256 tokenId) internal virtual {
1738         require(to != address(0), "ERC721: mint to the zero address");
1739         require(!_exists(tokenId), "ERC721: token already minted");
1740 
1741         _beforeTokenTransfer(address(0), to, tokenId);
1742 
1743         _holderTokens[to].add(tokenId);
1744 
1745         _tokenOwners.set(tokenId, to);
1746 
1747         emit Transfer(address(0), to, tokenId);
1748     }
1749 
1750     /**
1751      * @dev Destroys `tokenId`.
1752      * The approval is cleared when the token is burned.
1753      *
1754      * Requirements:
1755      *
1756      * - `tokenId` must exist.
1757      *
1758      * Emits a {Transfer} event.
1759      */
1760     function _burn(uint256 tokenId) internal virtual {
1761         address owner = ERC721.ownerOf(tokenId); // internal owner
1762 
1763         _beforeTokenTransfer(owner, address(0), tokenId);
1764 
1765         // Clear approvals
1766         _approve(address(0), tokenId);
1767 
1768         // Clear metadata (if any)
1769         if (bytes(_tokenURIs[tokenId]).length != 0) {
1770             delete _tokenURIs[tokenId];
1771         }
1772 
1773         _holderTokens[owner].remove(tokenId);
1774 
1775         _tokenOwners.remove(tokenId);
1776 
1777         emit Transfer(owner, address(0), tokenId);
1778     }
1779 
1780     /**
1781      * @dev Transfers `tokenId` from `from` to `to`.
1782      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1783      *
1784      * Requirements:
1785      *
1786      * - `to` cannot be the zero address.
1787      * - `tokenId` token must be owned by `from`.
1788      *
1789      * Emits a {Transfer} event.
1790      */
1791     function _transfer(
1792         address from,
1793         address to,
1794         uint256 tokenId
1795     ) internal virtual {
1796         require(
1797             ERC721.ownerOf(tokenId) == from,
1798             "ERC721: transfer of token that is not own"
1799         ); // internal owner
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
1811         emit Transfer(from, to, tokenId);
1812     }
1813 
1814     /**
1815      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1816      *
1817      * Requirements:
1818      *
1819      * - `tokenId` must exist.
1820      */
1821     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1822         internal
1823         virtual
1824     {
1825         require(
1826             _exists(tokenId),
1827             "ERC721Metadata: URI set of nonexistent token"
1828         );
1829         _tokenURIs[tokenId] = _tokenURI;
1830     }
1831 
1832     /**
1833      * @dev Internal function to set the base URI for all token IDs. It is
1834      * automatically added as a prefix to the value returned in {tokenURI},
1835      * or to the token ID if {tokenURI} is empty.
1836      */
1837     function _setBaseURI(string memory baseURI_) internal virtual {
1838         _baseURI = baseURI_;
1839     }
1840 
1841     /**
1842      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1843      * The call is not executed if the target address is not a contract.
1844      *
1845      * @param from address representing the previous owner of the given token ID
1846      * @param to target address that will receive the tokens
1847      * @param tokenId uint256 ID of the token to be transferred
1848      * @param _data bytes optional data to send along with the call
1849      * @return bool whether the call correctly returned the expected magic value
1850      */
1851     function _checkOnERC721Received(
1852         address from,
1853         address to,
1854         uint256 tokenId,
1855         bytes memory _data
1856     ) private returns (bool) {
1857         if (to.isContract()) {
1858             try
1859                 IERC721Receiver(to).onERC721Received(
1860                     _msgSender(),
1861                     from,
1862                     tokenId,
1863                     _data
1864                 )
1865             returns (bytes4 retval) {
1866                 return retval == IERC721Receiver(to).onERC721Received.selector;
1867             } catch (bytes memory reason) {
1868                 if (reason.length == 0) {
1869                     revert(
1870                         "ERC721: transfer to non ERC721Receiver implementer"
1871                     );
1872                 } else {
1873                     // solhint-disable-next-line no-inline-assembly
1874                     assembly {
1875                         revert(add(32, reason), mload(reason))
1876                     }
1877                 }
1878             }
1879         } else {
1880             return true;
1881         }
1882     }
1883 
1884     function _approve(address to, uint256 tokenId) private {
1885         _tokenApprovals[tokenId] = to;
1886         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1887     }
1888 
1889     /**
1890      * @dev Hook that is called before any token transfer. This includes minting
1891      * and burning.
1892      *
1893      * Calling conditions:
1894      *
1895      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1896      * transferred to `to`.
1897      * - When `from` is zero, `tokenId` will be minted for `to`.
1898      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1899      * - `from` cannot be the zero address.
1900      * - `to` cannot be the zero address.
1901      *
1902      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1903      */
1904     function _beforeTokenTransfer(
1905         address from,
1906         address to,
1907         uint256 tokenId
1908     ) internal virtual {}
1909 }
1910 
1911 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1912 
1913 pragma solidity 0.8.0;
1914 
1915 /**
1916  * @dev Contract module which provides a basic access control mechanism, where
1917  * there is an account (an owner) that can be granted exclusive access to
1918  * specific functions.
1919  *
1920  * By default, the owner account will be the one that deploys the contract. This
1921  * can later be changed with {transferOwnership}.
1922  *
1923  * This module is used through inheritance. It will make available the modifier
1924  * `onlyOwner`, which can be applied to your functions to restrict their use to
1925  * the owner.
1926  */
1927 abstract contract Ownable is Context {
1928     address private _owner;
1929 
1930     event OwnershipTransferred(
1931         address indexed previousOwner,
1932         address indexed newOwner
1933     );
1934 
1935     /**
1936      * @dev Initializes the contract setting the deployer as the initial owner.
1937      */
1938     constructor() {
1939         address msgSender = _msgSender();
1940         _owner = msgSender;
1941         emit OwnershipTransferred(address(0), msgSender);
1942     }
1943 
1944     /**
1945      * @dev Returns the address of the current owner.
1946      */
1947     function owner() public view virtual returns (address) {
1948         return _owner;
1949     }
1950 
1951     /**
1952      * @dev Throws if called by any account other than the owner.
1953      */
1954     modifier onlyOwner() {
1955         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1956         _;
1957     }
1958 
1959     /**
1960      * @dev Leaves the contract without owner. It will not be possible to call
1961      * `onlyOwner` functions anymore. Can only be called by the current owner.
1962      *
1963      * NOTE: Renouncing ownership will leave the contract without an owner,
1964      * thereby removing any functionality that is only available to the owner.
1965      */
1966     function renounceOwnership() public virtual onlyOwner {
1967         emit OwnershipTransferred(_owner, address(0));
1968         _owner = address(0);
1969     }
1970 
1971     /**
1972      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1973      * Can only be called by the current owner.
1974      */
1975     function transferOwnership(address newOwner) public virtual onlyOwner {
1976         require(
1977             newOwner != address(0),
1978             "Ownable: new owner is the zero address"
1979         );
1980         emit OwnershipTransferred(_owner, newOwner);
1981         _owner = newOwner;
1982     }
1983 }
1984 
1985 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1986 
1987 pragma solidity 0.8.0;
1988 
1989 // CAUTION
1990 // This version of SafeMath should only be used with Solidity 0.8 or later,
1991 // because it relies on the compiler's built in overflow checks.
1992 
1993 /**
1994  * @dev Wrappers over Solidity's arithmetic operations.
1995  *
1996  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1997  * now has built in overflow checking.
1998  */
1999 library SafeMath {
2000     /**
2001      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2002      *
2003      * _Available since v3.4._
2004      */
2005     function tryAdd(uint256 a, uint256 b)
2006         internal
2007         pure
2008         returns (bool, uint256)
2009     {
2010         unchecked {
2011             uint256 c = a + b;
2012             if (c < a) return (false, 0);
2013             return (true, c);
2014         }
2015     }
2016 
2017     /**
2018      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
2019      *
2020      * _Available since v3.4._
2021      */
2022     function trySub(uint256 a, uint256 b)
2023         internal
2024         pure
2025         returns (bool, uint256)
2026     {
2027         unchecked {
2028             if (b > a) return (false, 0);
2029             return (true, a - b);
2030         }
2031     }
2032 
2033     /**
2034      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2035      *
2036      * _Available since v3.4._
2037      */
2038     function tryMul(uint256 a, uint256 b)
2039         internal
2040         pure
2041         returns (bool, uint256)
2042     {
2043         unchecked {
2044             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2045             // benefit is lost if 'b' is also tested.
2046             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2047             if (a == 0) return (true, 0);
2048             uint256 c = a * b;
2049             if (c / a != b) return (false, 0);
2050             return (true, c);
2051         }
2052     }
2053 
2054     /**
2055      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2056      *
2057      * _Available since v3.4._
2058      */
2059     function tryDiv(uint256 a, uint256 b)
2060         internal
2061         pure
2062         returns (bool, uint256)
2063     {
2064         unchecked {
2065             if (b == 0) return (false, 0);
2066             return (true, a / b);
2067         }
2068     }
2069 
2070     /**
2071      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2072      *
2073      * _Available since v3.4._
2074      */
2075     function tryMod(uint256 a, uint256 b)
2076         internal
2077         pure
2078         returns (bool, uint256)
2079     {
2080         unchecked {
2081             if (b == 0) return (false, 0);
2082             return (true, a % b);
2083         }
2084     }
2085 
2086     /**
2087      * @dev Returns the addition of two unsigned integers, reverting on
2088      * overflow.
2089      *
2090      * Counterpart to Solidity's `+` operator.
2091      *
2092      * Requirements:
2093      *
2094      * - Addition cannot overflow.
2095      */
2096     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2097         return a + b;
2098     }
2099 
2100     /**
2101      * @dev Returns the subtraction of two unsigned integers, reverting on
2102      * overflow (when the result is negative).
2103      *
2104      * Counterpart to Solidity's `-` operator.
2105      *
2106      * Requirements:
2107      *
2108      * - Subtraction cannot overflow.
2109      */
2110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2111         return a - b;
2112     }
2113 
2114     /**
2115      * @dev Returns the multiplication of two unsigned integers, reverting on
2116      * overflow.
2117      *
2118      * Counterpart to Solidity's `*` operator.
2119      *
2120      * Requirements:
2121      *
2122      * - Multiplication cannot overflow.
2123      */
2124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2125         return a * b;
2126     }
2127 
2128     /**
2129      * @dev Returns the integer division of two unsigned integers, reverting on
2130      * division by zero. The result is rounded towards zero.
2131      *
2132      * Counterpart to Solidity's `/` operator.
2133      *
2134      * Requirements:
2135      *
2136      * - The divisor cannot be zero.
2137      */
2138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2139         return a / b;
2140     }
2141 
2142     /**
2143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2144      * reverting when dividing by zero.
2145      *
2146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2147      * opcode (which leaves remaining gas untouched) while Solidity uses an
2148      * invalid opcode to revert (consuming all remaining gas).
2149      *
2150      * Requirements:
2151      *
2152      * - The divisor cannot be zero.
2153      */
2154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2155         return a % b;
2156     }
2157 
2158     /**
2159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2160      * overflow (when the result is negative).
2161      *
2162      * CAUTION: This function is deprecated because it requires allocating memory for the error
2163      * message unnecessarily. For custom revert reasons use {trySub}.
2164      *
2165      * Counterpart to Solidity's `-` operator.
2166      *
2167      * Requirements:
2168      *
2169      * - Subtraction cannot overflow.
2170      */
2171     function sub(
2172         uint256 a,
2173         uint256 b,
2174         string memory errorMessage
2175     ) internal pure returns (uint256) {
2176         unchecked {
2177             require(b <= a, errorMessage);
2178             return a - b;
2179         }
2180     }
2181 
2182     /**
2183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2184      * division by zero. The result is rounded towards zero.
2185      *
2186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2187      * opcode (which leaves remaining gas untouched) while Solidity uses an
2188      * invalid opcode to revert (consuming all remaining gas).
2189      *
2190      * Counterpart to Solidity's `/` operator. Note: this function uses a
2191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2192      * uses an invalid opcode to revert (consuming all remaining gas).
2193      *
2194      * Requirements:
2195      *
2196      * - The divisor cannot be zero.
2197      */
2198     function div(
2199         uint256 a,
2200         uint256 b,
2201         string memory errorMessage
2202     ) internal pure returns (uint256) {
2203         unchecked {
2204             require(b > 0, errorMessage);
2205             return a / b;
2206         }
2207     }
2208 
2209     /**
2210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2211      * reverting with custom message when dividing by zero.
2212      *
2213      * CAUTION: This function is deprecated because it requires allocating memory for the error
2214      * message unnecessarily. For custom revert reasons use {tryMod}.
2215      *
2216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2217      * opcode (which leaves remaining gas untouched) while Solidity uses an
2218      * invalid opcode to revert (consuming all remaining gas).
2219      *
2220      * Requirements:
2221      *
2222      * - The divisor cannot be zero.
2223      */
2224     function mod(
2225         uint256 a,
2226         uint256 b,
2227         string memory errorMessage
2228     ) internal pure returns (uint256) {
2229         unchecked {
2230             require(b > 0, errorMessage);
2231             return a % b;
2232         }
2233     }
2234 }
2235 
2236 pragma solidity 0.8.0;
2237 
2238 // SPDX-License-Identifier: UNLICENSED
2239 
2240 contract Quadrums is ERC721, Ownable {
2241     using SafeMath for uint256;
2242     using Strings for uint256;
2243     uint256 public constant MAX_QUADRUMS = 1024;
2244     bool public hasSaleStarted = false;
2245     mapping(uint256 => uint256) public creationDates;
2246     mapping(uint256 => address) public creators;
2247 
2248     // these will be set in future
2249     string public METADATA_PROVENANCE_HASH = "";
2250     string public GENERATOR_ADDRESS =
2251         "https://quadrums.art/api/generator/";
2252     string public IPFS_GENERATOR_ADDRESS = "";
2253     string public SCRIPT = "";
2254     // e.s added minter address to hash algorithm
2255     constructor() ERC721("Quadrums", "QDRMS") {
2256         setBaseURI("https://quadrums.art/api/token/");
2257         _safeMint(msg.sender, 1);
2258         creationDates[0] = block.number;
2259         creators[0] = msg.sender;
2260         SCRIPT = "";
2261     }
2262 
2263     function tokensOfOwner(address _owner)
2264         external
2265         view
2266         returns (uint256[] memory)
2267     {
2268         uint256 tokenCount = balanceOf(_owner);
2269         if (tokenCount == 0) {
2270             // Return an empty array
2271             return new uint256[](0);
2272         } else {
2273             uint256[] memory result = new uint256[](tokenCount);
2274             uint256 index;
2275             for (index = 0; index < tokenCount; index++) {
2276                 result[index] = tokenOfOwnerByIndex(_owner, index);
2277             }
2278             return result;
2279         }
2280     }
2281 
2282     function calculatePrice() public pure returns (uint256) {
2283         return 40000000000000000;
2284     }
2285 
2286     function mint(uint256 maxQuadrums) public payable {
2287         require(totalSupply() < MAX_QUADRUMS, "Sale has already ended");
2288         require(
2289             maxQuadrums > 0 && maxQuadrums <= 10,
2290             "You can claim minimum 1, maximum 10"
2291         );
2292         require(
2293             totalSupply().add(maxQuadrums) <= MAX_QUADRUMS,
2294             "Exceeds MAX_QUADRUMS"
2295         );
2296         require(
2297             msg.value >= calculatePrice().mul(maxQuadrums),
2298             "Ether value sent is below the price"
2299         );
2300 
2301         for (uint256 i = 0; i < maxQuadrums; i++) {
2302             uint256 mintIndex = totalSupply();
2303             _safeMint(msg.sender, mintIndex + 1);
2304             creationDates[mintIndex] = block.number;
2305             creators[mintIndex] = msg.sender;
2306         }
2307     }
2308 
2309     // ONLYOWNER FUNCTIONS
2310 
2311     function setProvenanceHash(string memory _hash) public onlyOwner {
2312         METADATA_PROVENANCE_HASH = _hash;
2313     }
2314 
2315     function setGeneratorIPFSHash(string memory _hash) public onlyOwner {
2316         IPFS_GENERATOR_ADDRESS = _hash;
2317     }
2318 
2319     function setBaseURI(string memory baseURI) public onlyOwner {
2320         _setBaseURI(baseURI);
2321     }
2322 
2323     function startDrop() public onlyOwner {
2324         hasSaleStarted = true;
2325     }
2326 
2327     function pauseDrop() public onlyOwner {
2328         hasSaleStarted = false;
2329     }
2330 
2331     function withdrawAll() public payable onlyOwner {
2332         require(payable(msg.sender).send(address(this).balance));
2333     }
2334 
2335     function tokenHash(uint256 tokenId) public view returns (bytes32) {
2336         require(_exists(tokenId), "DOES NOT EXIST");
2337         return
2338             bytes32(
2339                 keccak256(
2340                     abi.encodePacked(
2341                         address(this),
2342                         creationDates[tokenId],
2343                         creators[tokenId],
2344                         tokenId
2345                     )
2346                 )
2347             );
2348     }
2349 
2350     function generatorAddress(uint256 tokenId)
2351         public
2352         view
2353         returns (string memory)
2354     {
2355         require(_exists(tokenId), "DOES NOT EXIST");
2356         return string(abi.encodePacked(GENERATOR_ADDRESS, tokenId.toString()));
2357     }
2358 
2359     function IPFSgeneratorAddress(uint256 tokenId)
2360         public
2361         view
2362         returns (string memory)
2363     {
2364         require(_exists(tokenId), "DOES NOT EXIST");
2365         return
2366             string(
2367                 abi.encodePacked(IPFS_GENERATOR_ADDRESS, tokenId.toString())
2368             );
2369     }
2370 }