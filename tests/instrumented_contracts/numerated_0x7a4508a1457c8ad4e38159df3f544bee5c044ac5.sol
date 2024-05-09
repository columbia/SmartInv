1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/access/Ownable.sol
2 // SPDX-License-Identifier: MIT
3 
4 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/Context.sol
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 pragma solidity ^0.7.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(
93             newOwner != address(0),
94             "Ownable: new owner is the zero address"
95         );
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/Strings.sol
102 
103 pragma solidity ^0.7.0;
104 
105 /**
106  * @dev String operations.
107  */
108 library Strings {
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` representation.
111      */
112     function toString(uint256 value) internal pure returns (string memory) {
113         // Inspired by OraclizeAPI's implementation - MIT licence
114         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
115 
116         if (value == 0) {
117             return "0";
118         }
119         uint256 temp = value;
120         uint256 digits;
121         while (temp != 0) {
122             digits++;
123             temp /= 10;
124         }
125         bytes memory buffer = new bytes(digits);
126         uint256 index = digits - 1;
127         temp = value;
128         while (temp != 0) {
129             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
130             temp /= 10;
131         }
132         return string(buffer);
133     }
134 }
135 
136 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/EnumerableMap.sol
137 
138 pragma solidity ^0.7.0;
139 
140 /**
141  * @dev Library for managing an enumerable variant of Solidity's
142  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
143  * type.
144  *
145  * Maps have the following properties:
146  *
147  * - Entries are added, removed, and checked for existence in constant time
148  * (O(1)).
149  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
150  *
151  * ```
152  * contract Example {
153  *     // Add the library methods
154  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
155  *
156  *     // Declare a set state variable
157  *     EnumerableMap.UintToAddressMap private myMap;
158  * }
159  * ```
160  *
161  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
162  * supported.
163  */
164 library EnumerableMap {
165     // To implement this library for multiple types with as little code
166     // repetition as possible, we write it in terms of a generic Map type with
167     // bytes32 keys and values.
168     // The Map implementation uses private functions, and user-facing
169     // implementations (such as Uint256ToAddressMap) are just wrappers around
170     // the underlying Map.
171     // This means that we can only create new EnumerableMaps for types that fit
172     // in bytes32.
173 
174     struct MapEntry {
175         bytes32 _key;
176         bytes32 _value;
177     }
178 
179     struct Map {
180         // Storage of map keys and values
181         MapEntry[] _entries;
182         // Position of the entry defined by a key in the `entries` array, plus 1
183         // because index 0 means a key is not in the map.
184         mapping(bytes32 => uint256) _indexes;
185     }
186 
187     /**
188      * @dev Adds a key-value pair to a map, or updates the value for an existing
189      * key. O(1).
190      *
191      * Returns true if the key was added to the map, that is if it was not
192      * already present.
193      */
194     function _set(
195         Map storage map,
196         bytes32 key,
197         bytes32 value
198     ) private returns (bool) {
199         // We read and store the key's index to prevent multiple reads from the same storage slot
200         uint256 keyIndex = map._indexes[key];
201 
202         if (keyIndex == 0) {
203             // Equivalent to !contains(map, key)
204             map._entries.push(MapEntry({_key: key, _value: value}));
205             // The entry is stored at length-1, but we add 1 to all indexes
206             // and use 0 as a sentinel value
207             map._indexes[key] = map._entries.length;
208             return true;
209         } else {
210             map._entries[keyIndex - 1]._value = value;
211             return false;
212         }
213     }
214 
215     /**
216      * @dev Removes a key-value pair from a map. O(1).
217      *
218      * Returns true if the key was removed from the map, that is if it was present.
219      */
220     function _remove(Map storage map, bytes32 key) private returns (bool) {
221         // We read and store the key's index to prevent multiple reads from the same storage slot
222         uint256 keyIndex = map._indexes[key];
223 
224         if (keyIndex != 0) {
225             // Equivalent to contains(map, key)
226             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
227             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
228             // This modifies the order of the array, as noted in {at}.
229 
230             uint256 toDeleteIndex = keyIndex - 1;
231             uint256 lastIndex = map._entries.length - 1;
232 
233             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
234             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
235 
236             MapEntry storage lastEntry = map._entries[lastIndex];
237 
238             // Move the last entry to the index where the entry to delete is
239             map._entries[toDeleteIndex] = lastEntry;
240             // Update the index for the moved entry
241             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
242 
243             // Delete the slot where the moved entry was stored
244             map._entries.pop();
245 
246             // Delete the index for the deleted slot
247             delete map._indexes[key];
248 
249             return true;
250         } else {
251             return false;
252         }
253     }
254 
255     /**
256      * @dev Returns true if the key is in the map. O(1).
257      */
258     function _contains(Map storage map, bytes32 key)
259         private
260         view
261         returns (bool)
262     {
263         return map._indexes[key] != 0;
264     }
265 
266     /**
267      * @dev Returns the number of key-value pairs in the map. O(1).
268      */
269     function _length(Map storage map) private view returns (uint256) {
270         return map._entries.length;
271     }
272 
273     /**
274      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
275      *
276      * Note that there are no guarantees on the ordering of entries inside the
277      * array, and it may change when more entries are added or removed.
278      *
279      * Requirements:
280      *
281      * - `index` must be strictly less than {length}.
282      */
283     function _at(Map storage map, uint256 index)
284         private
285         view
286         returns (bytes32, bytes32)
287     {
288         require(
289             map._entries.length > index,
290             "EnumerableMap: index out of bounds"
291         );
292 
293         MapEntry storage entry = map._entries[index];
294         return (entry._key, entry._value);
295     }
296 
297     /**
298      * @dev Tries to returns the value associated with `key`.  O(1).
299      * Does not revert if `key` is not in the map.
300      */
301     function _tryGet(Map storage map, bytes32 key)
302         private
303         view
304         returns (bool, bytes32)
305     {
306         uint256 keyIndex = map._indexes[key];
307         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
308         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
309     }
310 
311     /**
312      * @dev Returns the value associated with `key`.  O(1).
313      *
314      * Requirements:
315      *
316      * - `key` must be in the map.
317      */
318     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
319         uint256 keyIndex = map._indexes[key];
320         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
321         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
322     }
323 
324     /**
325      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
326      *
327      * CAUTION: This function is deprecated because it requires allocating memory for the error
328      * message unnecessarily. For custom revert reasons use {_tryGet}.
329      */
330     function _get(
331         Map storage map,
332         bytes32 key,
333         string memory errorMessage
334     ) private view returns (bytes32) {
335         uint256 keyIndex = map._indexes[key];
336         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
337         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
338     }
339 
340     // UintToAddressMap
341 
342     struct UintToAddressMap {
343         Map _inner;
344     }
345 
346     /**
347      * @dev Adds a key-value pair to a map, or updates the value for an existing
348      * key. O(1).
349      *
350      * Returns true if the key was added to the map, that is if it was not
351      * already present.
352      */
353     function set(
354         UintToAddressMap storage map,
355         uint256 key,
356         address value
357     ) internal returns (bool) {
358         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
359     }
360 
361     /**
362      * @dev Removes a value from a set. O(1).
363      *
364      * Returns true if the key was removed from the map, that is if it was present.
365      */
366     function remove(UintToAddressMap storage map, uint256 key)
367         internal
368         returns (bool)
369     {
370         return _remove(map._inner, bytes32(key));
371     }
372 
373     /**
374      * @dev Returns true if the key is in the map. O(1).
375      */
376     function contains(UintToAddressMap storage map, uint256 key)
377         internal
378         view
379         returns (bool)
380     {
381         return _contains(map._inner, bytes32(key));
382     }
383 
384     /**
385      * @dev Returns the number of elements in the map. O(1).
386      */
387     function length(UintToAddressMap storage map)
388         internal
389         view
390         returns (uint256)
391     {
392         return _length(map._inner);
393     }
394 
395     /**
396      * @dev Returns the element stored at position `index` in the set. O(1).
397      * Note that there are no guarantees on the ordering of values inside the
398      * array, and it may change when more values are added or removed.
399      *
400      * Requirements:
401      *
402      * - `index` must be strictly less than {length}.
403      */
404     function at(UintToAddressMap storage map, uint256 index)
405         internal
406         view
407         returns (uint256, address)
408     {
409         (bytes32 key, bytes32 value) = _at(map._inner, index);
410         return (uint256(key), address(uint160(uint256(value))));
411     }
412 
413     /**
414      * @dev Tries to returns the value associated with `key`.  O(1).
415      * Does not revert if `key` is not in the map.
416      *
417      * _Available since v3.4._
418      */
419     function tryGet(UintToAddressMap storage map, uint256 key)
420         internal
421         view
422         returns (bool, address)
423     {
424         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
425         return (success, address(uint160(uint256(value))));
426     }
427 
428     /**
429      * @dev Returns the value associated with `key`.  O(1).
430      *
431      * Requirements:
432      *
433      * - `key` must be in the map.
434      */
435     function get(UintToAddressMap storage map, uint256 key)
436         internal
437         view
438         returns (address)
439     {
440         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
441     }
442 
443     /**
444      * @dev Same as {get}, with a custom error message when `key` is not in the map.
445      *
446      * CAUTION: This function is deprecated because it requires allocating memory for the error
447      * message unnecessarily. For custom revert reasons use {tryGet}.
448      */
449     function get(
450         UintToAddressMap storage map,
451         uint256 key,
452         string memory errorMessage
453     ) internal view returns (address) {
454         return
455             address(
456                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
457             );
458     }
459 }
460 
461 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/EnumerableSet.sol
462 
463 pragma solidity ^0.7.0;
464 
465 /**
466  * @dev Library for managing
467  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
468  * types.
469  *
470  * Sets have the following properties:
471  *
472  * - Elements are added, removed, and checked for existence in constant time
473  * (O(1)).
474  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
475  *
476  * ```
477  * contract Example {
478  *     // Add the library methods
479  *     using EnumerableSet for EnumerableSet.AddressSet;
480  *
481  *     // Declare a set state variable
482  *     EnumerableSet.AddressSet private mySet;
483  * }
484  * ```
485  *
486  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
487  * and `uint256` (`UintSet`) are supported.
488  */
489 library EnumerableSet {
490     // To implement this library for multiple types with as little code
491     // repetition as possible, we write it in terms of a generic Set type with
492     // bytes32 values.
493     // The Set implementation uses private functions, and user-facing
494     // implementations (such as AddressSet) are just wrappers around the
495     // underlying Set.
496     // This means that we can only create new EnumerableSets for types that fit
497     // in bytes32.
498 
499     struct Set {
500         // Storage of set values
501         bytes32[] _values;
502         // Position of the value in the `values` array, plus 1 because index 0
503         // means a value is not in the set.
504         mapping(bytes32 => uint256) _indexes;
505     }
506 
507     /**
508      * @dev Add a value to a set. O(1).
509      *
510      * Returns true if the value was added to the set, that is if it was not
511      * already present.
512      */
513     function _add(Set storage set, bytes32 value) private returns (bool) {
514         if (!_contains(set, value)) {
515             set._values.push(value);
516             // The value is stored at length-1, but we add 1 to all indexes
517             // and use 0 as a sentinel value
518             set._indexes[value] = set._values.length;
519             return true;
520         } else {
521             return false;
522         }
523     }
524 
525     /**
526      * @dev Removes a value from a set. O(1).
527      *
528      * Returns true if the value was removed from the set, that is if it was
529      * present.
530      */
531     function _remove(Set storage set, bytes32 value) private returns (bool) {
532         // We read and store the value's index to prevent multiple reads from the same storage slot
533         uint256 valueIndex = set._indexes[value];
534 
535         if (valueIndex != 0) {
536             // Equivalent to contains(set, value)
537             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
538             // the array, and then remove the last element (sometimes called as 'swap and pop').
539             // This modifies the order of the array, as noted in {at}.
540 
541             uint256 toDeleteIndex = valueIndex - 1;
542             uint256 lastIndex = set._values.length - 1;
543 
544             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
545             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
546 
547             bytes32 lastvalue = set._values[lastIndex];
548 
549             // Move the last value to the index where the value to delete is
550             set._values[toDeleteIndex] = lastvalue;
551             // Update the index for the moved value
552             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
553 
554             // Delete the slot where the moved value was stored
555             set._values.pop();
556 
557             // Delete the index for the deleted slot
558             delete set._indexes[value];
559 
560             return true;
561         } else {
562             return false;
563         }
564     }
565 
566     /**
567      * @dev Returns true if the value is in the set. O(1).
568      */
569     function _contains(Set storage set, bytes32 value)
570         private
571         view
572         returns (bool)
573     {
574         return set._indexes[value] != 0;
575     }
576 
577     /**
578      * @dev Returns the number of values on the set. O(1).
579      */
580     function _length(Set storage set) private view returns (uint256) {
581         return set._values.length;
582     }
583 
584     /**
585      * @dev Returns the value stored at position `index` in the set. O(1).
586      *
587      * Note that there are no guarantees on the ordering of values inside the
588      * array, and it may change when more values are added or removed.
589      *
590      * Requirements:
591      *
592      * - `index` must be strictly less than {length}.
593      */
594     function _at(Set storage set, uint256 index)
595         private
596         view
597         returns (bytes32)
598     {
599         require(
600             set._values.length > index,
601             "EnumerableSet: index out of bounds"
602         );
603         return set._values[index];
604     }
605 
606     // Bytes32Set
607 
608     struct Bytes32Set {
609         Set _inner;
610     }
611 
612     /**
613      * @dev Add a value to a set. O(1).
614      *
615      * Returns true if the value was added to the set, that is if it was not
616      * already present.
617      */
618     function add(Bytes32Set storage set, bytes32 value)
619         internal
620         returns (bool)
621     {
622         return _add(set._inner, value);
623     }
624 
625     /**
626      * @dev Removes a value from a set. O(1).
627      *
628      * Returns true if the value was removed from the set, that is if it was
629      * present.
630      */
631     function remove(Bytes32Set storage set, bytes32 value)
632         internal
633         returns (bool)
634     {
635         return _remove(set._inner, value);
636     }
637 
638     /**
639      * @dev Returns true if the value is in the set. O(1).
640      */
641     function contains(Bytes32Set storage set, bytes32 value)
642         internal
643         view
644         returns (bool)
645     {
646         return _contains(set._inner, value);
647     }
648 
649     /**
650      * @dev Returns the number of values in the set. O(1).
651      */
652     function length(Bytes32Set storage set) internal view returns (uint256) {
653         return _length(set._inner);
654     }
655 
656     /**
657      * @dev Returns the value stored at position `index` in the set. O(1).
658      *
659      * Note that there are no guarantees on the ordering of values inside the
660      * array, and it may change when more values are added or removed.
661      *
662      * Requirements:
663      *
664      * - `index` must be strictly less than {length}.
665      */
666     function at(Bytes32Set storage set, uint256 index)
667         internal
668         view
669         returns (bytes32)
670     {
671         return _at(set._inner, index);
672     }
673 
674     // AddressSet
675 
676     struct AddressSet {
677         Set _inner;
678     }
679 
680     /**
681      * @dev Add a value to a set. O(1).
682      *
683      * Returns true if the value was added to the set, that is if it was not
684      * already present.
685      */
686     function add(AddressSet storage set, address value)
687         internal
688         returns (bool)
689     {
690         return _add(set._inner, bytes32(uint256(uint160(value))));
691     }
692 
693     /**
694      * @dev Removes a value from a set. O(1).
695      *
696      * Returns true if the value was removed from the set, that is if it was
697      * present.
698      */
699     function remove(AddressSet storage set, address value)
700         internal
701         returns (bool)
702     {
703         return _remove(set._inner, bytes32(uint256(uint160(value))));
704     }
705 
706     /**
707      * @dev Returns true if the value is in the set. O(1).
708      */
709     function contains(AddressSet storage set, address value)
710         internal
711         view
712         returns (bool)
713     {
714         return _contains(set._inner, bytes32(uint256(uint160(value))));
715     }
716 
717     /**
718      * @dev Returns the number of values in the set. O(1).
719      */
720     function length(AddressSet storage set) internal view returns (uint256) {
721         return _length(set._inner);
722     }
723 
724     /**
725      * @dev Returns the value stored at position `index` in the set. O(1).
726      *
727      * Note that there are no guarantees on the ordering of values inside the
728      * array, and it may change when more values are added or removed.
729      *
730      * Requirements:
731      *
732      * - `index` must be strictly less than {length}.
733      */
734     function at(AddressSet storage set, uint256 index)
735         internal
736         view
737         returns (address)
738     {
739         return address(uint160(uint256(_at(set._inner, index))));
740     }
741 
742     // UintSet
743 
744     struct UintSet {
745         Set _inner;
746     }
747 
748     /**
749      * @dev Add a value to a set. O(1).
750      *
751      * Returns true if the value was added to the set, that is if it was not
752      * already present.
753      */
754     function add(UintSet storage set, uint256 value) internal returns (bool) {
755         return _add(set._inner, bytes32(value));
756     }
757 
758     /**
759      * @dev Removes a value from a set. O(1).
760      *
761      * Returns true if the value was removed from the set, that is if it was
762      * present.
763      */
764     function remove(UintSet storage set, uint256 value)
765         internal
766         returns (bool)
767     {
768         return _remove(set._inner, bytes32(value));
769     }
770 
771     /**
772      * @dev Returns true if the value is in the set. O(1).
773      */
774     function contains(UintSet storage set, uint256 value)
775         internal
776         view
777         returns (bool)
778     {
779         return _contains(set._inner, bytes32(value));
780     }
781 
782     /**
783      * @dev Returns the number of values on the set. O(1).
784      */
785     function length(UintSet storage set) internal view returns (uint256) {
786         return _length(set._inner);
787     }
788 
789     /**
790      * @dev Returns the value stored at position `index` in the set. O(1).
791      *
792      * Note that there are no guarantees on the ordering of values inside the
793      * array, and it may change when more values are added or removed.
794      *
795      * Requirements:
796      *
797      * - `index` must be strictly less than {length}.
798      */
799     function at(UintSet storage set, uint256 index)
800         internal
801         view
802         returns (uint256)
803     {
804         return uint256(_at(set._inner, index));
805     }
806 }
807 
808 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/Address.sol
809 
810 pragma solidity ^0.7.0;
811 
812 /**
813  * @dev Collection of functions related to the address type
814  */
815 library Address {
816     /**
817      * @dev Returns true if `account` is a contract.
818      *
819      * [IMPORTANT]
820      * ====
821      * It is unsafe to assume that an address for which this function returns
822      * false is an externally-owned account (EOA) and not a contract.
823      *
824      * Among others, `isContract` will return false for the following
825      * types of addresses:
826      *
827      *  - an externally-owned account
828      *  - a contract in construction
829      *  - an address where a contract will be created
830      *  - an address where a contract lived, but was destroyed
831      * ====
832      */
833     function isContract(address account) internal view returns (bool) {
834         // This method relies on extcodesize, which returns 0 for contracts in
835         // construction, since the code is only stored at the end of the
836         // constructor execution.
837 
838         uint256 size;
839         // solhint-disable-next-line no-inline-assembly
840         assembly {
841             size := extcodesize(account)
842         }
843         return size > 0;
844     }
845 
846     /**
847      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
848      * `recipient`, forwarding all available gas and reverting on errors.
849      *
850      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
851      * of certain opcodes, possibly making contracts go over the 2300 gas limit
852      * imposed by `transfer`, making them unable to receive funds via
853      * `transfer`. {sendValue} removes this limitation.
854      *
855      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
856      *
857      * IMPORTANT: because control is transferred to `recipient`, care must be
858      * taken to not create reentrancy vulnerabilities. Consider using
859      * {ReentrancyGuard} or the
860      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
861      */
862     function sendValue(address payable recipient, uint256 amount) internal {
863         require(
864             address(this).balance >= amount,
865             "Address: insufficient balance"
866         );
867 
868         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
869         (bool success, ) = recipient.call{value: amount}("");
870         require(
871             success,
872             "Address: unable to send value, recipient may have reverted"
873         );
874     }
875 
876     /**
877      * @dev Performs a Solidity function call using a low level `call`. A
878      * plain`call` is an unsafe replacement for a function call: use this
879      * function instead.
880      *
881      * If `target` reverts with a revert reason, it is bubbled up by this
882      * function (like regular Solidity function calls).
883      *
884      * Returns the raw returned data. To convert to the expected return value,
885      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
886      *
887      * Requirements:
888      *
889      * - `target` must be a contract.
890      * - calling `target` with `data` must not revert.
891      *
892      * _Available since v3.1._
893      */
894     function functionCall(address target, bytes memory data)
895         internal
896         returns (bytes memory)
897     {
898         return functionCall(target, data, "Address: low-level call failed");
899     }
900 
901     /**
902      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
903      * `errorMessage` as a fallback revert reason when `target` reverts.
904      *
905      * _Available since v3.1._
906      */
907     function functionCall(
908         address target,
909         bytes memory data,
910         string memory errorMessage
911     ) internal returns (bytes memory) {
912         return functionCallWithValue(target, data, 0, errorMessage);
913     }
914 
915     /**
916      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
917      * but also transferring `value` wei to `target`.
918      *
919      * Requirements:
920      *
921      * - the calling contract must have an ETH balance of at least `value`.
922      * - the called Solidity function must be `payable`.
923      *
924      * _Available since v3.1._
925      */
926     function functionCallWithValue(
927         address target,
928         bytes memory data,
929         uint256 value
930     ) internal returns (bytes memory) {
931         return
932             functionCallWithValue(
933                 target,
934                 data,
935                 value,
936                 "Address: low-level call with value failed"
937             );
938     }
939 
940     /**
941      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
942      * with `errorMessage` as a fallback revert reason when `target` reverts.
943      *
944      * _Available since v3.1._
945      */
946     function functionCallWithValue(
947         address target,
948         bytes memory data,
949         uint256 value,
950         string memory errorMessage
951     ) internal returns (bytes memory) {
952         require(
953             address(this).balance >= value,
954             "Address: insufficient balance for call"
955         );
956         require(isContract(target), "Address: call to non-contract");
957 
958         // solhint-disable-next-line avoid-low-level-calls
959         (bool success, bytes memory returndata) = target.call{value: value}(
960             data
961         );
962         return _verifyCallResult(success, returndata, errorMessage);
963     }
964 
965     /**
966      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
967      * but performing a static call.
968      *
969      * _Available since v3.3._
970      */
971     function functionStaticCall(address target, bytes memory data)
972         internal
973         view
974         returns (bytes memory)
975     {
976         return
977             functionStaticCall(
978                 target,
979                 data,
980                 "Address: low-level static call failed"
981             );
982     }
983 
984     /**
985      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
986      * but performing a static call.
987      *
988      * _Available since v3.3._
989      */
990     function functionStaticCall(
991         address target,
992         bytes memory data,
993         string memory errorMessage
994     ) internal view returns (bytes memory) {
995         require(isContract(target), "Address: static call to non-contract");
996 
997         // solhint-disable-next-line avoid-low-level-calls
998         (bool success, bytes memory returndata) = target.staticcall(data);
999         return _verifyCallResult(success, returndata, errorMessage);
1000     }
1001 
1002     /**
1003      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1004      * but performing a delegate call.
1005      *
1006      * _Available since v3.4._
1007      */
1008     function functionDelegateCall(address target, bytes memory data)
1009         internal
1010         returns (bytes memory)
1011     {
1012         return
1013             functionDelegateCall(
1014                 target,
1015                 data,
1016                 "Address: low-level delegate call failed"
1017             );
1018     }
1019 
1020     /**
1021      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1022      * but performing a delegate call.
1023      *
1024      * _Available since v3.4._
1025      */
1026     function functionDelegateCall(
1027         address target,
1028         bytes memory data,
1029         string memory errorMessage
1030     ) internal returns (bytes memory) {
1031         require(isContract(target), "Address: delegate call to non-contract");
1032 
1033         // solhint-disable-next-line avoid-low-level-calls
1034         (bool success, bytes memory returndata) = target.delegatecall(data);
1035         return _verifyCallResult(success, returndata, errorMessage);
1036     }
1037 
1038     function _verifyCallResult(
1039         bool success,
1040         bytes memory returndata,
1041         string memory errorMessage
1042     ) private pure returns (bytes memory) {
1043         if (success) {
1044             return returndata;
1045         } else {
1046             // Look for revert reason and bubble it up if present
1047             if (returndata.length > 0) {
1048                 // The easiest way to bubble the revert reason is using memory via assembly
1049 
1050                 // solhint-disable-next-line no-inline-assembly
1051                 assembly {
1052                     let returndata_size := mload(returndata)
1053                     revert(add(32, returndata), returndata_size)
1054                 }
1055             } else {
1056                 revert(errorMessage);
1057             }
1058         }
1059     }
1060 }
1061 
1062 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/math/SafeMath.sol
1063 
1064 pragma solidity ^0.7.0;
1065 
1066 /**
1067  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1068  * checks.
1069  *
1070  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1071  * in bugs, because programmers usually assume that an overflow raises an
1072  * error, which is the standard behavior in high level programming languages.
1073  * `SafeMath` restores this intuition by reverting the transaction when an
1074  * operation overflows.
1075  *
1076  * Using this library instead of the unchecked operations eliminates an entire
1077  * class of bugs, so it's recommended to use it always.
1078  */
1079 library SafeMath {
1080     /**
1081      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1082      *
1083      * _Available since v3.4._
1084      */
1085     function tryAdd(uint256 a, uint256 b)
1086         internal
1087         pure
1088         returns (bool, uint256)
1089     {
1090         uint256 c = a + b;
1091         if (c < a) return (false, 0);
1092         return (true, c);
1093     }
1094 
1095     /**
1096      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1097      *
1098      * _Available since v3.4._
1099      */
1100     function trySub(uint256 a, uint256 b)
1101         internal
1102         pure
1103         returns (bool, uint256)
1104     {
1105         if (b > a) return (false, 0);
1106         return (true, a - b);
1107     }
1108 
1109     /**
1110      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1111      *
1112      * _Available since v3.4._
1113      */
1114     function tryMul(uint256 a, uint256 b)
1115         internal
1116         pure
1117         returns (bool, uint256)
1118     {
1119         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1120         // benefit is lost if 'b' is also tested.
1121         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1122         if (a == 0) return (true, 0);
1123         uint256 c = a * b;
1124         if (c / a != b) return (false, 0);
1125         return (true, c);
1126     }
1127 
1128     /**
1129      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1130      *
1131      * _Available since v3.4._
1132      */
1133     function tryDiv(uint256 a, uint256 b)
1134         internal
1135         pure
1136         returns (bool, uint256)
1137     {
1138         if (b == 0) return (false, 0);
1139         return (true, a / b);
1140     }
1141 
1142     /**
1143      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1144      *
1145      * _Available since v3.4._
1146      */
1147     function tryMod(uint256 a, uint256 b)
1148         internal
1149         pure
1150         returns (bool, uint256)
1151     {
1152         if (b == 0) return (false, 0);
1153         return (true, a % b);
1154     }
1155 
1156     /**
1157      * @dev Returns the addition of two unsigned integers, reverting on
1158      * overflow.
1159      *
1160      * Counterpart to Solidity's `+` operator.
1161      *
1162      * Requirements:
1163      *
1164      * - Addition cannot overflow.
1165      */
1166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1167         uint256 c = a + b;
1168         require(c >= a, "SafeMath: addition overflow");
1169         return c;
1170     }
1171 
1172     /**
1173      * @dev Returns the subtraction of two unsigned integers, reverting on
1174      * overflow (when the result is negative).
1175      *
1176      * Counterpart to Solidity's `-` operator.
1177      *
1178      * Requirements:
1179      *
1180      * - Subtraction cannot overflow.
1181      */
1182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1183         require(b <= a, "SafeMath: subtraction overflow");
1184         return a - b;
1185     }
1186 
1187     /**
1188      * @dev Returns the multiplication of two unsigned integers, reverting on
1189      * overflow.
1190      *
1191      * Counterpart to Solidity's `*` operator.
1192      *
1193      * Requirements:
1194      *
1195      * - Multiplication cannot overflow.
1196      */
1197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1198         if (a == 0) return 0;
1199         uint256 c = a * b;
1200         require(c / a == b, "SafeMath: multiplication overflow");
1201         return c;
1202     }
1203 
1204     /**
1205      * @dev Returns the integer division of two unsigned integers, reverting on
1206      * division by zero. The result is rounded towards zero.
1207      *
1208      * Counterpart to Solidity's `/` operator. Note: this function uses a
1209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1210      * uses an invalid opcode to revert (consuming all remaining gas).
1211      *
1212      * Requirements:
1213      *
1214      * - The divisor cannot be zero.
1215      */
1216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1217         require(b > 0, "SafeMath: division by zero");
1218         return a / b;
1219     }
1220 
1221     /**
1222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1223      * reverting when dividing by zero.
1224      *
1225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1226      * opcode (which leaves remaining gas untouched) while Solidity uses an
1227      * invalid opcode to revert (consuming all remaining gas).
1228      *
1229      * Requirements:
1230      *
1231      * - The divisor cannot be zero.
1232      */
1233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1234         require(b > 0, "SafeMath: modulo by zero");
1235         return a % b;
1236     }
1237 
1238     /**
1239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1240      * overflow (when the result is negative).
1241      *
1242      * CAUTION: This function is deprecated because it requires allocating memory for the error
1243      * message unnecessarily. For custom revert reasons use {trySub}.
1244      *
1245      * Counterpart to Solidity's `-` operator.
1246      *
1247      * Requirements:
1248      *
1249      * - Subtraction cannot overflow.
1250      */
1251     function sub(
1252         uint256 a,
1253         uint256 b,
1254         string memory errorMessage
1255     ) internal pure returns (uint256) {
1256         require(b <= a, errorMessage);
1257         return a - b;
1258     }
1259 
1260     /**
1261      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1262      * division by zero. The result is rounded towards zero.
1263      *
1264      * CAUTION: This function is deprecated because it requires allocating memory for the error
1265      * message unnecessarily. For custom revert reasons use {tryDiv}.
1266      *
1267      * Counterpart to Solidity's `/` operator. Note: this function uses a
1268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1269      * uses an invalid opcode to revert (consuming all remaining gas).
1270      *
1271      * Requirements:
1272      *
1273      * - The divisor cannot be zero.
1274      */
1275     function div(
1276         uint256 a,
1277         uint256 b,
1278         string memory errorMessage
1279     ) internal pure returns (uint256) {
1280         require(b > 0, errorMessage);
1281         return a / b;
1282     }
1283 
1284     /**
1285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1286      * reverting with custom message when dividing by zero.
1287      *
1288      * CAUTION: This function is deprecated because it requires allocating memory for the error
1289      * message unnecessarily. For custom revert reasons use {tryMod}.
1290      *
1291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1292      * opcode (which leaves remaining gas untouched) while Solidity uses an
1293      * invalid opcode to revert (consuming all remaining gas).
1294      *
1295      * Requirements:
1296      *
1297      * - The divisor cannot be zero.
1298      */
1299     function mod(
1300         uint256 a,
1301         uint256 b,
1302         string memory errorMessage
1303     ) internal pure returns (uint256) {
1304         require(b > 0, errorMessage);
1305         return a % b;
1306     }
1307 }
1308 
1309 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/introspection/IERC165.sol
1310 
1311 pragma solidity ^0.7.0;
1312 
1313 /**
1314  * @dev Interface of the ERC165 standard, as defined in the
1315  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1316  *
1317  * Implementers can declare support of contract interfaces, which can then be
1318  * queried by others ({ERC165Checker}).
1319  *
1320  * For an implementation, see {ERC165}.
1321  */
1322 interface IERC165 {
1323     /**
1324      * @dev Returns true if this contract implements the interface defined by
1325      * `interfaceId`. See the corresponding
1326      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1327      * to learn more about how these ids are created.
1328      *
1329      * This function call must use less than 30 000 gas.
1330      */
1331     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1332 }
1333 
1334 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/introspection/ERC165.sol
1335 
1336 pragma solidity ^0.7.0;
1337 
1338 /**
1339  * @dev Implementation of the {IERC165} interface.
1340  *
1341  * Contracts may inherit from this and call {_registerInterface} to declare
1342  * their support of an interface.
1343  */
1344 abstract contract ERC165 is IERC165 {
1345     /*
1346      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1347      */
1348     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1349 
1350     /**
1351      * @dev Mapping of interface ids to whether or not it's supported.
1352      */
1353     mapping(bytes4 => bool) private _supportedInterfaces;
1354 
1355     constructor() {
1356         // Derived contracts need only register support for their own interfaces,
1357         // we register support for ERC165 itself here
1358         _registerInterface(_INTERFACE_ID_ERC165);
1359     }
1360 
1361     /**
1362      * @dev See {IERC165-supportsInterface}.
1363      *
1364      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1365      */
1366     function supportsInterface(bytes4 interfaceId)
1367         public
1368         view
1369         virtual
1370         override
1371         returns (bool)
1372     {
1373         return _supportedInterfaces[interfaceId];
1374     }
1375 
1376     /**
1377      * @dev Registers the contract as an implementer of the interface defined by
1378      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1379      * registering its interface id is not required.
1380      *
1381      * See {IERC165-supportsInterface}.
1382      *
1383      * Requirements:
1384      *
1385      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1386      */
1387     function _registerInterface(bytes4 interfaceId) internal virtual {
1388         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1389         _supportedInterfaces[interfaceId] = true;
1390     }
1391 }
1392 
1393 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721Receiver.sol
1394 
1395 pragma solidity ^0.7.0;
1396 
1397 /**
1398  * @title ERC721 token receiver interface
1399  * @dev Interface for any contract that wants to support safeTransfers
1400  * from ERC721 asset contracts.
1401  */
1402 interface IERC721Receiver {
1403     /**
1404      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1405      * by `operator` from `from`, this function is called.
1406      *
1407      * It must return its Solidity selector to confirm the token transfer.
1408      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1409      *
1410      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1411      */
1412     function onERC721Received(
1413         address operator,
1414         address from,
1415         uint256 tokenId,
1416         bytes calldata data
1417     ) external returns (bytes4);
1418 }
1419 
1420 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721.sol
1421 
1422 pragma solidity ^0.7.0;
1423 
1424 /**
1425  * @dev Required interface of an ERC721 compliant contract.
1426  */
1427 interface IERC721 is IERC165 {
1428     /**
1429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1430      */
1431     event Transfer(
1432         address indexed from,
1433         address indexed to,
1434         uint256 indexed tokenId
1435     );
1436 
1437     /**
1438      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1439      */
1440     event Approval(
1441         address indexed owner,
1442         address indexed approved,
1443         uint256 indexed tokenId
1444     );
1445 
1446     /**
1447      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1448      */
1449     event ApprovalForAll(
1450         address indexed owner,
1451         address indexed operator,
1452         bool approved
1453     );
1454 
1455     /**
1456      * @dev Returns the number of tokens in ``owner``'s account.
1457      */
1458     function balanceOf(address owner) external view returns (uint256 balance);
1459 
1460     /**
1461      * @dev Returns the owner of the `tokenId` token.
1462      *
1463      * Requirements:
1464      *
1465      * - `tokenId` must exist.
1466      */
1467     function ownerOf(uint256 tokenId) external view returns (address owner);
1468 
1469     /**
1470      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1471      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1472      *
1473      * Requirements:
1474      *
1475      * - `from` cannot be the zero address.
1476      * - `to` cannot be the zero address.
1477      * - `tokenId` token must exist and be owned by `from`.
1478      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1479      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1480      *
1481      * Emits a {Transfer} event.
1482      */
1483     function safeTransferFrom(
1484         address from,
1485         address to,
1486         uint256 tokenId
1487     ) external;
1488 
1489     /**
1490      * @dev Transfers `tokenId` token from `from` to `to`.
1491      *
1492      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1493      *
1494      * Requirements:
1495      *
1496      * - `from` cannot be the zero address.
1497      * - `to` cannot be the zero address.
1498      * - `tokenId` token must be owned by `from`.
1499      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function transferFrom(
1504         address from,
1505         address to,
1506         uint256 tokenId
1507     ) external;
1508 
1509     /**
1510      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1511      * The approval is cleared when the token is transferred.
1512      *
1513      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1514      *
1515      * Requirements:
1516      *
1517      * - The caller must own the token or be an approved operator.
1518      * - `tokenId` must exist.
1519      *
1520      * Emits an {Approval} event.
1521      */
1522     function approve(address to, uint256 tokenId) external;
1523 
1524     /**
1525      * @dev Returns the account approved for `tokenId` token.
1526      *
1527      * Requirements:
1528      *
1529      * - `tokenId` must exist.
1530      */
1531     function getApproved(uint256 tokenId)
1532         external
1533         view
1534         returns (address operator);
1535 
1536     /**
1537      * @dev Approve or remove `operator` as an operator for the caller.
1538      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1539      *
1540      * Requirements:
1541      *
1542      * - The `operator` cannot be the caller.
1543      *
1544      * Emits an {ApprovalForAll} event.
1545      */
1546     function setApprovalForAll(address operator, bool _approved) external;
1547 
1548     /**
1549      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1550      *
1551      * See {setApprovalForAll}
1552      */
1553     function isApprovedForAll(address owner, address operator)
1554         external
1555         view
1556         returns (bool);
1557 
1558     /**
1559      * @dev Safely transfers `tokenId` token from `from` to `to`.
1560      *
1561      * Requirements:
1562      *
1563      * - `from` cannot be the zero address.
1564      * - `to` cannot be the zero address.
1565      * - `tokenId` token must exist and be owned by `from`.
1566      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1568      *
1569      * Emits a {Transfer} event.
1570      */
1571     function safeTransferFrom(
1572         address from,
1573         address to,
1574         uint256 tokenId,
1575         bytes calldata data
1576     ) external;
1577 }
1578 
1579 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721Enumerable.sol
1580 
1581 pragma solidity ^0.7.0;
1582 
1583 /**
1584  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1585  * @dev See https://eips.ethereum.org/EIPS/eip-721
1586  */
1587 interface IERC721Enumerable is IERC721 {
1588     /**
1589      * @dev Returns the total amount of tokens stored by the contract.
1590      */
1591     function totalSupply() external view returns (uint256);
1592 
1593     /**
1594      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1595      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1596      */
1597     function tokenOfOwnerByIndex(address owner, uint256 index)
1598         external
1599         view
1600         returns (uint256 tokenId);
1601 
1602     /**
1603      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1604      * Use along with {totalSupply} to enumerate all tokens.
1605      */
1606     function tokenByIndex(uint256 index) external view returns (uint256);
1607 }
1608 
1609 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/IERC721Metadata.sol
1610 
1611 pragma solidity ^0.7.0;
1612 
1613 /**
1614  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1615  * @dev See https://eips.ethereum.org/EIPS/eip-721
1616  */
1617 interface IERC721Metadata is IERC721 {
1618     /**
1619      * @dev Returns the token collection name.
1620      */
1621     function name() external view returns (string memory);
1622 
1623     /**
1624      * @dev Returns the token collection symbol.
1625      */
1626     function symbol() external view returns (string memory);
1627 
1628     /**
1629      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1630      */
1631     function tokenURI(uint256 tokenId) external view returns (string memory);
1632 }
1633 
1634 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC721/ERC721.sol
1635 
1636 pragma solidity ^0.7.0;
1637 
1638 /**
1639  * @title ERC721 Non-Fungible Token Standard basic implementation
1640  * @dev see https://eips.ethereum.org/EIPS/eip-721
1641  */
1642 contract ERC721 is
1643     Context,
1644     ERC165,
1645     IERC721,
1646     IERC721Metadata,
1647     IERC721Enumerable
1648 {
1649     using SafeMath for uint256;
1650     using Address for address;
1651     using EnumerableSet for EnumerableSet.UintSet;
1652     using EnumerableMap for EnumerableMap.UintToAddressMap;
1653     using Strings for uint256;
1654 
1655     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1656     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1657     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1658 
1659     // Mapping from holder address to their (enumerable) set of owned tokens
1660     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1661 
1662     // Enumerable mapping from token ids to their owners
1663     EnumerableMap.UintToAddressMap private _tokenOwners;
1664 
1665     // Mapping from token ID to approved address
1666     mapping(uint256 => address) private _tokenApprovals;
1667 
1668     // Mapping from owner to operator approvals
1669     mapping(address => mapping(address => bool)) private _operatorApprovals;
1670 
1671     // Token name
1672     string private _name;
1673 
1674     // Token symbol
1675     string private _symbol;
1676 
1677     // Optional mapping for token URIs
1678     mapping(uint256 => string) private _tokenURIs;
1679 
1680     // Base URI
1681     string private _baseURI;
1682 
1683     /*
1684      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1685      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1686      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1687      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1688      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1689      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1690      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1691      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1692      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1693      *
1694      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1695      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1696      */
1697     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1698 
1699     /*
1700      *     bytes4(keccak256('name()')) == 0x06fdde03
1701      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1702      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1703      *
1704      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1705      */
1706     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1707 
1708     /*
1709      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1710      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1711      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1712      *
1713      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1714      */
1715     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1716 
1717     /**
1718      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1719      */
1720     constructor(string memory name_, string memory symbol_) {
1721         _name = name_;
1722         _symbol = symbol_;
1723 
1724         // register the supported interfaces to conform to ERC721 via ERC165
1725         _registerInterface(_INTERFACE_ID_ERC721);
1726         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1727         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1728     }
1729 
1730     /**
1731      * @dev See {IERC721-balanceOf}.
1732      */
1733     function balanceOf(address owner)
1734         public
1735         view
1736         virtual
1737         override
1738         returns (uint256)
1739     {
1740         require(
1741             owner != address(0),
1742             "ERC721: balance query for the zero address"
1743         );
1744         return _holderTokens[owner].length();
1745     }
1746 
1747     /**
1748      * @dev See {IERC721-ownerOf}.
1749      */
1750     function ownerOf(uint256 tokenId)
1751         public
1752         view
1753         virtual
1754         override
1755         returns (address)
1756     {
1757         return
1758             _tokenOwners.get(
1759                 tokenId,
1760                 "ERC721: owner query for nonexistent token"
1761             );
1762     }
1763 
1764     /**
1765      * @dev See {IERC721Metadata-name}.
1766      */
1767     function name() public view virtual override returns (string memory) {
1768         return _name;
1769     }
1770 
1771     /**
1772      * @dev See {IERC721Metadata-symbol}.
1773      */
1774     function symbol() public view virtual override returns (string memory) {
1775         return _symbol;
1776     }
1777 
1778     /**
1779      * @dev See {IERC721Metadata-tokenURI}.
1780      */
1781     function tokenURI(uint256 tokenId)
1782         public
1783         view
1784         virtual
1785         override
1786         returns (string memory)
1787     {
1788         require(
1789             _exists(tokenId),
1790             "ERC721Metadata: URI query for nonexistent token"
1791         );
1792 
1793         string memory _tokenURI = _tokenURIs[tokenId];
1794         string memory base = baseURI();
1795 
1796         // If there is no base URI, return the token URI.
1797         if (bytes(base).length == 0) {
1798             return _tokenURI;
1799         }
1800         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1801         if (bytes(_tokenURI).length > 0) {
1802             return string(abi.encodePacked(base, _tokenURI));
1803         }
1804         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1805         return string(abi.encodePacked(base, tokenId.toString()));
1806     }
1807 
1808     /**
1809      * @dev Returns the base URI set via {_setBaseURI}. This will be
1810      * automatically added as a prefix in {tokenURI} to each token's URI, or
1811      * to the token ID if no specific URI is set for that token ID.
1812      */
1813     function baseURI() public view virtual returns (string memory) {
1814         return _baseURI;
1815     }
1816 
1817     /**
1818      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1819      */
1820     function tokenOfOwnerByIndex(address owner, uint256 index)
1821         public
1822         view
1823         virtual
1824         override
1825         returns (uint256)
1826     {
1827         return _holderTokens[owner].at(index);
1828     }
1829 
1830     /**
1831      * @dev See {IERC721Enumerable-totalSupply}.
1832      */
1833     function totalSupply() public view virtual override returns (uint256) {
1834         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1835         return _tokenOwners.length();
1836     }
1837 
1838     /**
1839      * @dev See {IERC721Enumerable-tokenByIndex}.
1840      */
1841     function tokenByIndex(uint256 index)
1842         public
1843         view
1844         virtual
1845         override
1846         returns (uint256)
1847     {
1848         (uint256 tokenId, ) = _tokenOwners.at(index);
1849         return tokenId;
1850     }
1851 
1852     /**
1853      * @dev See {IERC721-approve}.
1854      */
1855     function approve(address to, uint256 tokenId) public virtual override {
1856         address owner = ERC721.ownerOf(tokenId);
1857         require(to != owner, "ERC721: approval to current owner");
1858 
1859         require(
1860             _msgSender() == owner ||
1861                 ERC721.isApprovedForAll(owner, _msgSender()),
1862             "ERC721: approve caller is not owner nor approved for all"
1863         );
1864 
1865         _approve(to, tokenId);
1866     }
1867 
1868     /**
1869      * @dev See {IERC721-getApproved}.
1870      */
1871     function getApproved(uint256 tokenId)
1872         public
1873         view
1874         virtual
1875         override
1876         returns (address)
1877     {
1878         require(
1879             _exists(tokenId),
1880             "ERC721: approved query for nonexistent token"
1881         );
1882 
1883         return _tokenApprovals[tokenId];
1884     }
1885 
1886     /**
1887      * @dev See {IERC721-setApprovalForAll}.
1888      */
1889     function setApprovalForAll(address operator, bool approved)
1890         public
1891         virtual
1892         override
1893     {
1894         require(operator != _msgSender(), "ERC721: approve to caller");
1895 
1896         _operatorApprovals[_msgSender()][operator] = approved;
1897         emit ApprovalForAll(_msgSender(), operator, approved);
1898     }
1899 
1900     /**
1901      * @dev See {IERC721-isApprovedForAll}.
1902      */
1903     function isApprovedForAll(address owner, address operator)
1904         public
1905         view
1906         virtual
1907         override
1908         returns (bool)
1909     {
1910         return _operatorApprovals[owner][operator];
1911     }
1912 
1913     /**
1914      * @dev See {IERC721-transferFrom}.
1915      */
1916     function transferFrom(
1917         address from,
1918         address to,
1919         uint256 tokenId
1920     ) public virtual override {
1921         //solhint-disable-next-line max-line-length
1922         require(
1923             _isApprovedOrOwner(_msgSender(), tokenId),
1924             "ERC721: transfer caller is not owner nor approved"
1925         );
1926 
1927         _transfer(from, to, tokenId);
1928     }
1929 
1930     /**
1931      * @dev See {IERC721-safeTransferFrom}.
1932      */
1933     function safeTransferFrom(
1934         address from,
1935         address to,
1936         uint256 tokenId
1937     ) public virtual override {
1938         safeTransferFrom(from, to, tokenId, "");
1939     }
1940 
1941     /**
1942      * @dev See {IERC721-safeTransferFrom}.
1943      */
1944     function safeTransferFrom(
1945         address from,
1946         address to,
1947         uint256 tokenId,
1948         bytes memory _data
1949     ) public virtual override {
1950         require(
1951             _isApprovedOrOwner(_msgSender(), tokenId),
1952             "ERC721: transfer caller is not owner nor approved"
1953         );
1954         _safeTransfer(from, to, tokenId, _data);
1955     }
1956 
1957     /**
1958      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1959      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1960      *
1961      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1962      *
1963      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1964      * implement alternative mechanisms to perform token transfer, such as signature-based.
1965      *
1966      * Requirements:
1967      *
1968      * - `from` cannot be the zero address.
1969      * - `to` cannot be the zero address.
1970      * - `tokenId` token must exist and be owned by `from`.
1971      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1972      *
1973      * Emits a {Transfer} event.
1974      */
1975     function _safeTransfer(
1976         address from,
1977         address to,
1978         uint256 tokenId,
1979         bytes memory _data
1980     ) internal virtual {
1981         _transfer(from, to, tokenId);
1982         require(
1983             _checkOnERC721Received(from, to, tokenId, _data),
1984             "ERC721: transfer to non ERC721Receiver implementer"
1985         );
1986     }
1987 
1988     /**
1989      * @dev Returns whether `tokenId` exists.
1990      *
1991      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1992      *
1993      * Tokens start existing when they are minted (`_mint`),
1994      * and stop existing when they are burned (`_burn`).
1995      */
1996     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1997         return _tokenOwners.contains(tokenId);
1998     }
1999 
2000     /**
2001      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2002      *
2003      * Requirements:
2004      *
2005      * - `tokenId` must exist.
2006      */
2007     function _isApprovedOrOwner(address spender, uint256 tokenId)
2008         internal
2009         view
2010         virtual
2011         returns (bool)
2012     {
2013         require(
2014             _exists(tokenId),
2015             "ERC721: operator query for nonexistent token"
2016         );
2017         address owner = ERC721.ownerOf(tokenId);
2018         return (spender == owner ||
2019             getApproved(tokenId) == spender ||
2020             ERC721.isApprovedForAll(owner, spender));
2021     }
2022 
2023     /**
2024      * @dev Safely mints `tokenId` and transfers it to `to`.
2025      *
2026      * Requirements:
2027      d*
2028      * - `tokenId` must not exist.
2029      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2030      *
2031      * Emits a {Transfer} event.
2032      */
2033     function _safeMint(address to, uint256 tokenId) internal virtual {
2034         _safeMint(to, tokenId, "");
2035     }
2036 
2037     /**
2038      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2039      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2040      */
2041     function _safeMint(
2042         address to,
2043         uint256 tokenId,
2044         bytes memory _data
2045     ) internal virtual {
2046         _mint(to, tokenId);
2047         require(
2048             _checkOnERC721Received(address(0), to, tokenId, _data),
2049             "ERC721: transfer to non ERC721Receiver implementer"
2050         );
2051     }
2052 
2053     /**
2054      * @dev Mints `tokenId` and transfers it to `to`.
2055      *
2056      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2057      *
2058      * Requirements:
2059      *
2060      * - `tokenId` must not exist.
2061      * - `to` cannot be the zero address.
2062      *
2063      * Emits a {Transfer} event.
2064      */
2065     function _mint(address to, uint256 tokenId) internal virtual {
2066         require(to != address(0), "ERC721: mint to the zero address");
2067         require(!_exists(tokenId), "ERC721: token already minted");
2068 
2069         _beforeTokenTransfer(address(0), to, tokenId);
2070 
2071         _holderTokens[to].add(tokenId);
2072 
2073         _tokenOwners.set(tokenId, to);
2074 
2075         emit Transfer(address(0), to, tokenId);
2076     }
2077 
2078     /**
2079      * @dev Destroys `tokenId`.
2080      * The approval is cleared when the token is burned.
2081      *
2082      * Requirements:
2083      *
2084      * - `tokenId` must exist.
2085      *
2086      * Emits a {Transfer} event.
2087      */
2088     function _burn(uint256 tokenId) internal virtual {
2089         address owner = ERC721.ownerOf(tokenId); // internal owner
2090 
2091         _beforeTokenTransfer(owner, address(0), tokenId);
2092 
2093         // Clear approvals
2094         _approve(address(0), tokenId);
2095 
2096         // Clear metadata (if any)
2097         if (bytes(_tokenURIs[tokenId]).length != 0) {
2098             delete _tokenURIs[tokenId];
2099         }
2100 
2101         _holderTokens[owner].remove(tokenId);
2102 
2103         _tokenOwners.remove(tokenId);
2104 
2105         emit Transfer(owner, address(0), tokenId);
2106     }
2107 
2108     /**
2109      * @dev Transfers `tokenId` from `from` to `to`.
2110      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2111      *
2112      * Requirements:
2113      *
2114      * - `to` cannot be the zero address.
2115      * - `tokenId` token must be owned by `from`.
2116      *
2117      * Emits a {Transfer} event.
2118      */
2119     function _transfer(
2120         address from,
2121         address to,
2122         uint256 tokenId
2123     ) internal virtual {
2124         require(
2125             ERC721.ownerOf(tokenId) == from,
2126             "ERC721: transfer of token that is not own"
2127         ); // internal owner
2128         require(to != address(0), "ERC721: transfer to the zero address");
2129 
2130         _beforeTokenTransfer(from, to, tokenId);
2131 
2132         // Clear approvals from the previous owner
2133         _approve(address(0), tokenId);
2134 
2135         _holderTokens[from].remove(tokenId);
2136         _holderTokens[to].add(tokenId);
2137 
2138         _tokenOwners.set(tokenId, to);
2139 
2140         emit Transfer(from, to, tokenId);
2141     }
2142 
2143     /**
2144      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2145      *
2146      * Requirements:
2147      *
2148      * - `tokenId` must exist.
2149      */
2150     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2151         internal
2152         virtual
2153     {
2154         require(
2155             _exists(tokenId),
2156             "ERC721Metadata: URI set of nonexistent token"
2157         );
2158         _tokenURIs[tokenId] = _tokenURI;
2159     }
2160 
2161     /**
2162      * @dev Internal function to set the base URI for all token IDs. It is
2163      * automatically added as a prefix to the value returned in {tokenURI},
2164      * or to the token ID if {tokenURI} is empty.
2165      */
2166     function _setBaseURI(string memory baseURI_) internal virtual {
2167         _baseURI = baseURI_;
2168     }
2169 
2170     /**
2171      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2172      * The call is not executed if the target address is not a contract.
2173      *
2174      * @param from address representing the previous owner of the given token ID
2175      * @param to target address that will receive the tokens
2176      * @param tokenId uint256 ID of the token to be transferred
2177      * @param _data bytes optional data to send along with the call
2178      * @return bool whether the call correctly returned the expected magic value
2179      */
2180     function _checkOnERC721Received(
2181         address from,
2182         address to,
2183         uint256 tokenId,
2184         bytes memory _data
2185     ) private returns (bool) {
2186         if (!to.isContract()) {
2187             return true;
2188         }
2189         bytes memory returndata = to.functionCall(
2190             abi.encodeWithSelector(
2191                 IERC721Receiver(to).onERC721Received.selector,
2192                 _msgSender(),
2193                 from,
2194                 tokenId,
2195                 _data
2196             ),
2197             "ERC721: transfer to non ERC721Receiver implementer"
2198         );
2199         bytes4 retval = abi.decode(returndata, (bytes4));
2200         return (retval == _ERC721_RECEIVED);
2201     }
2202 
2203     function _approve(address to, uint256 tokenId) private {
2204         _tokenApprovals[tokenId] = to;
2205         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2206     }
2207 
2208     /**
2209      * @dev Hook that is called before any token transfer. This includes minting
2210      * and burning.
2211      *
2212      * Calling conditions:
2213      *
2214      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2215      * transferred to `to`.
2216      * - When `from` is zero, `tokenId` will be minted for `to`.
2217      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2218      * - `from` cannot be the zero address.
2219      * - `to` cannot be the zero address.
2220      *
2221      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2222      */
2223     function _beforeTokenTransfer(
2224         address from,
2225         address to,
2226         uint256 tokenId
2227     ) internal virtual {}
2228 }
2229 
2230 // File: contracts/Neighborz.sol
2231 
2232 pragma solidity ^0.7.0;
2233 
2234 /**
2235  * @title NeighborzContract contract
2236  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2237  */
2238 contract NeighborzContract is ERC721, Ownable {
2239     using SafeMath for uint256;
2240 
2241     bool public claimIsActive = false;
2242 
2243     bool public saleIsActive = false;
2244 
2245     bool public saleIsActiveForRuumHolders = false;
2246 
2247     address public constant RUUMZ = 0xf54fc50E1604012CF8BB8dD84E075D3F07f9bB16;
2248 
2249     uint256 public constant neighborPrice = 30000000000000000;
2250 
2251     uint256 public constant neighborPriceForRuumzHolders = 20000000000000000;
2252 
2253     uint256 public maxNeighbor = 10000;
2254 
2255     uint256 public constant maxNeighborPurchase = 20;
2256 
2257     uint256 public neighborIndex = 3560;
2258 
2259     constructor(string memory name, string memory symbol)
2260         ERC721(name, symbol)
2261     {}
2262 
2263     function withdraw() public onlyOwner {
2264         uint256 balance = address(this).balance;
2265         msg.sender.transfer(balance);
2266     }
2267 
2268     function setBaseURI(string memory baseURI) public onlyOwner {
2269         _setBaseURI(baseURI);
2270     }
2271 
2272     function flipSaleState() public onlyOwner {
2273         saleIsActive = !saleIsActive;
2274     }
2275 
2276     function flipClaimState() public onlyOwner {
2277         claimIsActive = !claimIsActive;
2278     }
2279 
2280     function flipSaleStateForRuumHolders() public onlyOwner {
2281         saleIsActiveForRuumHolders = !saleIsActiveForRuumHolders;
2282     }
2283 
2284     function tokensOfOwner(address _owner)
2285         external
2286         view
2287         returns (uint256[] memory)
2288     {
2289         uint256 tokenCount = balanceOf(_owner);
2290         if (tokenCount == 0) {
2291             return new uint256[](0);
2292         } else {
2293             uint256[] memory result = new uint256[](tokenCount);
2294             uint256 index;
2295             for (index = 0; index < tokenCount; index++) {
2296                 result[index] = tokenOfOwnerByIndex(_owner, index);
2297             }
2298             return result;
2299         }
2300     }
2301 
2302     function numberOfMintableTokens(address user)
2303         public
2304         view
2305         returns (uint256 mintableTokenNumber)
2306     {
2307         uint256 mintableTokens = 0;
2308         for (uint256 i = 0; i < IERC721Enumerable(RUUMZ).balanceOf(user); i++) {
2309             uint256 tokenId = IERC721Enumerable(RUUMZ).tokenOfOwnerByIndex(
2310                 user,
2311                 i
2312             );
2313             if (!isNeighborClaimed(tokenId)) mintableTokens++;
2314         }
2315         return mintableTokens;
2316     }
2317 
2318     /**
2319      * Claims Neighborz
2320      */
2321     function claimNeighborz(uint256 numberOfTokens) public {
2322         require(claimIsActive, "Claim has not started yet");
2323         require(numberOfTokens > 0, "You can't claim 0 companions");
2324 
2325         uint256 j = 0;
2326         for (
2327             uint256 i = 0;
2328             i < IERC721Enumerable(RUUMZ).balanceOf(msg.sender);
2329             i++
2330         ) {
2331             uint256 tokenId = IERC721Enumerable(RUUMZ).tokenOfOwnerByIndex(
2332                 msg.sender,
2333                 i
2334             );
2335             if (!isNeighborClaimed(tokenId)) {
2336                 _safeMint(msg.sender, tokenId);
2337                 j++;
2338             }
2339             if (j == numberOfTokens) {
2340                 break;
2341             }
2342         }
2343     }
2344 
2345     /**
2346      * Mints Neighborz
2347      */
2348     function mintNeighborz(uint256 numberOfTokens) public payable {
2349         require(saleIsActive, "Sale must be active to mint a Neighbor");
2350         require(
2351             numberOfTokens <= maxNeighborPurchase,
2352             "Can only mint 20 Neighborz at a time"
2353         );
2354         require(
2355             totalSupply().add(numberOfTokens) <= maxNeighbor,
2356             "Purchase would exceed max supply of Neighborz"
2357         );
2358         require(
2359             neighborPrice.mul(numberOfTokens) <= msg.value,
2360             "Ether value sent is not correct"
2361         );
2362 
2363         for (uint256 i = 0; i < numberOfTokens; i++) {
2364             if (totalSupply() < maxNeighbor) {
2365                 _safeMint(msg.sender, neighborIndex);
2366                 neighborIndex++;
2367             }
2368         }
2369     }
2370 
2371     /**
2372      * Mints Neighborz for RUUM holders
2373      */
2374     function mintNeighborzForRuumHolders(uint256 numberOfTokens)
2375         public
2376         payable
2377     {
2378         require(
2379             saleIsActiveForRuumHolders,
2380             "Sale must be active to mint a Neighbor"
2381         );
2382         require(
2383             numberOfTokens <= maxNeighborPurchase,
2384             "Can only mint 20 Neighborz at a time"
2385         );
2386         require(
2387             totalSupply().add(numberOfTokens) <= maxNeighbor,
2388             "Purchase would exceed max supply of Neighborz"
2389         );
2390         require(
2391             IERC721Enumerable(RUUMZ).balanceOf(msg.sender) > 0,
2392             "You have to be a RUUMZ holder to be able to mint on presale"
2393         );
2394         require(
2395             neighborPriceForRuumzHolders.mul(numberOfTokens) <= msg.value,
2396             "Ether value sent is not correct"
2397         );
2398 
2399         for (uint256 i = 0; i < numberOfTokens; i++) {
2400             if (totalSupply() < maxNeighbor) {
2401                 _safeMint(msg.sender, neighborIndex);
2402                 neighborIndex++;
2403             }
2404         }
2405     }
2406 
2407     function isNeighborClaimed(uint256 tokenId) public view returns (bool) {
2408         return _exists(tokenId);
2409     }
2410 }