1 // SPDX-License-Identifier: MIT
2 // Creator: Hanfu Labs
3 // File: contracts/ERC20.sol
4 
5 pragma solidity ^0.8.4;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Emitted when `value` tokens are moved from one account (`from`) to
23      * another (`to`).
24      *
25      * Note that `value` may be zero.
26      */
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     /**
30      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
31      * a call to {approve}. `value` is the new allowance.
32      */
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `to`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address to, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `from` to `to` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address from,
90         address to,
91         uint256 amount
92     ) external returns (bool);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 // File: contracts/EnumerableSet.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
117 
118 pragma solidity ^0.8.4;
119 
120 /**
121  * @dev Library for managing
122  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
123  * types.
124  *
125  * Sets have the following properties:
126  *
127  * - Elements are added, removed, and checked for existence in constant time
128  * (O(1)).
129  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
130  *
131  * ```
132  * contract Example {
133  *     // Add the library methods
134  *     using EnumerableSet for EnumerableSet.AddressSet;
135  *
136  *     // Declare a set state variable
137  *     EnumerableSet.AddressSet private mySet;
138  * }
139  * ```
140  *
141  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
142  * and `uint256` (`UintSet`) are supported.
143  *
144  * [WARNING]
145  * ====
146  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
147  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
148  *
149  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
150  * ====
151  */
152 library EnumerableSet {
153     // To implement this library for multiple types with as little code
154     // repetition as possible, we write it in terms of a generic Set type with
155     // bytes32 values.
156     // The Set implementation uses private functions, and user-facing
157     // implementations (such as AddressSet) are just wrappers around the
158     // underlying Set.
159     // This means that we can only create new EnumerableSets for types that fit
160     // in bytes32.
161 
162     struct Set {
163         // Storage of set values
164         bytes32[] _values;
165         // Position of the value in the `values` array, plus 1 because index 0
166         // means a value is not in the set.
167         mapping(bytes32 => uint256) _indexes;
168     }
169 
170     /**
171      * @dev Add a value to a set. O(1).
172      *
173      * Returns true if the value was added to the set, that is if it was not
174      * already present.
175      */
176     function _add(Set storage set, bytes32 value) private returns (bool) {
177         if (!_contains(set, value)) {
178             set._values.push(value);
179             // The value is stored at length-1, but we add 1 to all indexes
180             // and use 0 as a sentinel value
181             set._indexes[value] = set._values.length;
182             return true;
183         } else {
184             return false;
185         }
186     }
187 
188     /**
189      * @dev Removes a value from a set. O(1).
190      *
191      * Returns true if the value was removed from the set, that is if it was
192      * present.
193      */
194     function _remove(Set storage set, bytes32 value) private returns (bool) {
195         // We read and store the value's index to prevent multiple reads from the same storage slot
196         uint256 valueIndex = set._indexes[value];
197 
198         if (valueIndex != 0) {
199             // Equivalent to contains(set, value)
200             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
201             // the array, and then remove the last element (sometimes called as 'swap and pop').
202             // This modifies the order of the array, as noted in {at}.
203 
204             uint256 toDeleteIndex = valueIndex - 1;
205             uint256 lastIndex = set._values.length - 1;
206 
207             if (lastIndex != toDeleteIndex) {
208                 bytes32 lastValue = set._values[lastIndex];
209 
210                 // Move the last value to the index where the value to delete is
211                 set._values[toDeleteIndex] = lastValue;
212                 // Update the index for the moved value
213                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
214             }
215 
216             // Delete the slot where the moved value was stored
217             set._values.pop();
218 
219             // Delete the index for the deleted slot
220             delete set._indexes[value];
221 
222             return true;
223         } else {
224             return false;
225         }
226     }
227 
228     /**
229      * @dev Returns true if the value is in the set. O(1).
230      */
231     function _contains(Set storage set, bytes32 value) private view returns (bool) {
232         return set._indexes[value] != 0;
233     }
234 
235     /**
236      * @dev Returns the number of values on the set. O(1).
237      */
238     function _length(Set storage set) private view returns (uint256) {
239         return set._values.length;
240     }
241 
242     /**
243      * @dev Returns the value stored at position `index` in the set. O(1).
244      *
245      * Note that there are no guarantees on the ordering of values inside the
246      * array, and it may change when more values are added or removed.
247      *
248      * Requirements:
249      *
250      * - `index` must be strictly less than {length}.
251      */
252     function _at(Set storage set, uint256 index) private view returns (bytes32) {
253         return set._values[index];
254     }
255 
256     /**
257      * @dev Return the entire set in an array
258      *
259      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
260      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
261      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
262      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
263      */
264     function _values(Set storage set) private view returns (bytes32[] memory) {
265         return set._values;
266     }
267 
268     // Bytes32Set
269 
270     struct Bytes32Set {
271         Set _inner;
272     }
273 
274     /**
275      * @dev Add a value to a set. O(1).
276      *
277      * Returns true if the value was added to the set, that is if it was not
278      * already present.
279      */
280     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
281         return _add(set._inner, value);
282     }
283 
284     /**
285      * @dev Removes a value from a set. O(1).
286      *
287      * Returns true if the value was removed from the set, that is if it was
288      * present.
289      */
290     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
291         return _remove(set._inner, value);
292     }
293 
294     /**
295      * @dev Returns true if the value is in the set. O(1).
296      */
297     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
298         return _contains(set._inner, value);
299     }
300 
301     /**
302      * @dev Returns the number of values in the set. O(1).
303      */
304     function length(Bytes32Set storage set) internal view returns (uint256) {
305         return _length(set._inner);
306     }
307 
308     /**
309      * @dev Returns the value stored at position `index` in the set. O(1).
310      *
311      * Note that there are no guarantees on the ordering of values inside the
312      * array, and it may change when more values are added or removed.
313      *
314      * Requirements:
315      *
316      * - `index` must be strictly less than {length}.
317      */
318     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
319         return _at(set._inner, index);
320     }
321 
322     /**
323      * @dev Return the entire set in an array
324      *
325      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
326      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
327      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
328      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
329      */
330     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
331         return _values(set._inner);
332     }
333 
334     // AddressSet
335 
336     struct AddressSet {
337         Set _inner;
338     }
339 
340     /**
341      * @dev Add a value to a set. O(1).
342      *
343      * Returns true if the value was added to the set, that is if it was not
344      * already present.
345      */
346     function add(AddressSet storage set, address value) internal returns (bool) {
347         return _add(set._inner, bytes32(uint256(uint160(value))));
348     }
349 
350     /**
351      * @dev Removes a value from a set. O(1).
352      *
353      * Returns true if the value was removed from the set, that is if it was
354      * present.
355      */
356     function remove(AddressSet storage set, address value) internal returns (bool) {
357         return _remove(set._inner, bytes32(uint256(uint160(value))));
358     }
359 
360     /**
361      * @dev Returns true if the value is in the set. O(1).
362      */
363     function contains(AddressSet storage set, address value) internal view returns (bool) {
364         return _contains(set._inner, bytes32(uint256(uint160(value))));
365     }
366 
367     /**
368      * @dev Returns the number of values in the set. O(1).
369      */
370     function length(AddressSet storage set) internal view returns (uint256) {
371         return _length(set._inner);
372     }
373 
374     /**
375      * @dev Returns the value stored at position `index` in the set. O(1).
376      *
377      * Note that there are no guarantees on the ordering of values inside the
378      * array, and it may change when more values are added or removed.
379      *
380      * Requirements:
381      *
382      * - `index` must be strictly less than {length}.
383      */
384     function at(AddressSet storage set, uint256 index) internal view returns (address) {
385         return address(uint160(uint256(_at(set._inner, index))));
386     }
387 
388     /**
389      * @dev Return the entire set in an array
390      *
391      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
392      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
393      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
394      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
395      */
396     function values(AddressSet storage set) internal view returns (address[] memory) {
397         bytes32[] memory store = _values(set._inner);
398         address[] memory result;
399 
400         /// @solidity memory-safe-assembly
401         assembly {
402             result := store
403         }
404 
405         return result;
406     }
407 
408     // UintSet
409 
410     struct UintSet {
411         Set _inner;
412     }
413 
414     /**
415      * @dev Add a value to a set. O(1).
416      *
417      * Returns true if the value was added to the set, that is if it was not
418      * already present.
419      */
420     function add(UintSet storage set, uint256 value) internal returns (bool) {
421         return _add(set._inner, bytes32(value));
422     }
423 
424     /**
425      * @dev Removes a value from a set. O(1).
426      *
427      * Returns true if the value was removed from the set, that is if it was
428      * present.
429      */
430     function remove(UintSet storage set, uint256 value) internal returns (bool) {
431         return _remove(set._inner, bytes32(value));
432     }
433 
434     /**
435      * @dev Returns true if the value is in the set. O(1).
436      */
437     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
438         return _contains(set._inner, bytes32(value));
439     }
440 
441     /**
442      * @dev Returns the number of values on the set. O(1).
443      */
444     function length(UintSet storage set) internal view returns (uint256) {
445         return _length(set._inner);
446     }
447 
448     /**
449      * @dev Returns the value stored at position `index` in the set. O(1).
450      *
451      * Note that there are no guarantees on the ordering of values inside the
452      * array, and it may change when more values are added or removed.
453      *
454      * Requirements:
455      *
456      * - `index` must be strictly less than {length}.
457      */
458     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
459         return uint256(_at(set._inner, index));
460     }
461 
462     /**
463      * @dev Return the entire set in an array
464      *
465      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
466      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
467      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
468      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
469      */
470     function values(UintSet storage set) internal view returns (uint256[] memory) {
471         bytes32[] memory store = _values(set._inner);
472         uint256[] memory result;
473 
474         /// @solidity memory-safe-assembly
475         assembly {
476             result := store
477         }
478 
479         return result;
480     }
481 }
482 // File: contracts/EnumerableMap.sol
483 
484 
485 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableMap.sol)
486 
487 pragma solidity ^0.8.4;
488 
489 
490 /**
491  * @dev Library for managing an enumerable variant of Solidity's
492  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
493  * type.
494  *
495  * Maps have the following properties:
496  *
497  * - Entries are added, removed, and checked for existence in constant time
498  * (O(1)).
499  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
500  *
501  * ```
502  * contract Example {
503  *     // Add the library methods
504  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
505  *
506  *     // Declare a set state variable
507  *     EnumerableMap.UintToAddressMap private myMap;
508  * }
509  * ```
510  *
511  * The following map types are supported:
512  *
513  * - `uint256 -> address` (`UintToAddressMap`) since v3.0.0
514  * - `address -> uint256` (`AddressToUintMap`) since v4.6.0
515  * - `bytes32 -> bytes32` (`Bytes32ToBytes32`) since v4.6.0
516  * - `uint256 -> uint256` (`UintToUintMap`) since v4.7.0
517  * - `bytes32 -> uint256` (`Bytes32ToUintMap`) since v4.7.0
518  *
519  * [WARNING]
520  * ====
521  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
522  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
523  *
524  *  In order to clean an EnumerableMap, you can either remove all elements one by one or create a fresh instance using an array of EnumerableMap.
525  * ====
526  */
527 library EnumerableMap {
528     using EnumerableSet for EnumerableSet.Bytes32Set;
529 
530     // To implement this library for multiple types with as little code
531     // repetition as possible, we write it in terms of a generic Map type with
532     // bytes32 keys and values.
533     // The Map implementation uses private functions, and user-facing
534     // implementations (such as Uint256ToAddressMap) are just wrappers around
535     // the underlying Map.
536     // This means that we can only create new EnumerableMaps for types that fit
537     // in bytes32.
538 
539     struct Bytes32ToBytes32Map {
540         // Storage of keys
541         EnumerableSet.Bytes32Set _keys;
542         mapping(bytes32 => bytes32) _values;
543     }
544 
545     /**
546      * @dev Adds a key-value pair to a map, or updates the value for an existing
547      * key. O(1).
548      *
549      * Returns true if the key was added to the map, that is if it was not
550      * already present.
551      */
552     function set(
553         Bytes32ToBytes32Map storage map,
554         bytes32 key,
555         bytes32 value
556     ) internal returns (bool) {
557         map._values[key] = value;
558         return map._keys.add(key);
559     }
560 
561     /**
562      * @dev Removes a key-value pair from a map. O(1).
563      *
564      * Returns true if the key was removed from the map, that is if it was present.
565      */
566     function remove(Bytes32ToBytes32Map storage map, bytes32 key) internal returns (bool) {
567         delete map._values[key];
568         return map._keys.remove(key);
569     }
570 
571     /**
572      * @dev Returns true if the key is in the map. O(1).
573      */
574     function contains(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool) {
575         return map._keys.contains(key);
576     }
577 
578     /**
579      * @dev Returns the number of key-value pairs in the map. O(1).
580      */
581     function length(Bytes32ToBytes32Map storage map) internal view returns (uint256) {
582         return map._keys.length();
583     }
584 
585     /**
586      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
587      *
588      * Note that there are no guarantees on the ordering of entries inside the
589      * array, and it may change when more entries are added or removed.
590      *
591      * Requirements:
592      *
593      * - `index` must be strictly less than {length}.
594      */
595     function at(Bytes32ToBytes32Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
596         bytes32 key = map._keys.at(index);
597         return (key, map._values[key]);
598     }
599 
600     /**
601      * @dev Tries to returns the value associated with `key`.  O(1).
602      * Does not revert if `key` is not in the map.
603      */
604     function tryGet(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool, bytes32) {
605         bytes32 value = map._values[key];
606         if (value == bytes32(0)) {
607             return (contains(map, key), bytes32(0));
608         } else {
609             return (true, value);
610         }
611     }
612 
613     /**
614      * @dev Returns the value associated with `key`.  O(1).
615      *
616      * Requirements:
617      *
618      * - `key` must be in the map.
619      */
620     function get(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bytes32) {
621         bytes32 value = map._values[key];
622         require(value != 0 || contains(map, key), "EnumerableMap: nonexistent key");
623         return value;
624     }
625 
626     /**
627      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
628      *
629      * CAUTION: This function is deprecated because it requires allocating memory for the error
630      * message unnecessarily. For custom revert reasons use {_tryGet}.
631      */
632     function get(
633         Bytes32ToBytes32Map storage map,
634         bytes32 key,
635         string memory errorMessage
636     ) internal view returns (bytes32) {
637         bytes32 value = map._values[key];
638         require(value != 0 || contains(map, key), errorMessage);
639         return value;
640     }
641 
642     // UintToUintMap
643 
644     struct UintToUintMap {
645         Bytes32ToBytes32Map _inner;
646     }
647 
648     /**
649      * @dev Adds a key-value pair to a map, or updates the value for an existing
650      * key. O(1).
651      *
652      * Returns true if the key was added to the map, that is if it was not
653      * already present.
654      */
655     function set(
656         UintToUintMap storage map,
657         uint256 key,
658         uint256 value
659     ) internal returns (bool) {
660         return set(map._inner, bytes32(key), bytes32(value));
661     }
662 
663     /**
664      * @dev Removes a value from a set. O(1).
665      *
666      * Returns true if the key was removed from the map, that is if it was present.
667      */
668     function remove(UintToUintMap storage map, uint256 key) internal returns (bool) {
669         return remove(map._inner, bytes32(key));
670     }
671 
672     /**
673      * @dev Returns true if the key is in the map. O(1).
674      */
675     function contains(UintToUintMap storage map, uint256 key) internal view returns (bool) {
676         return contains(map._inner, bytes32(key));
677     }
678 
679     /**
680      * @dev Returns the number of elements in the map. O(1).
681      */
682     function length(UintToUintMap storage map) internal view returns (uint256) {
683         return length(map._inner);
684     }
685 
686     /**
687      * @dev Returns the element stored at position `index` in the set. O(1).
688      * Note that there are no guarantees on the ordering of values inside the
689      * array, and it may change when more values are added or removed.
690      *
691      * Requirements:
692      *
693      * - `index` must be strictly less than {length}.
694      */
695     function at(UintToUintMap storage map, uint256 index) internal view returns (uint256, uint256) {
696         (bytes32 key, bytes32 value) = at(map._inner, index);
697         return (uint256(key), uint256(value));
698     }
699 
700     /**
701      * @dev Tries to returns the value associated with `key`.  O(1).
702      * Does not revert if `key` is not in the map.
703      */
704     function tryGet(UintToUintMap storage map, uint256 key) internal view returns (bool, uint256) {
705         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
706         return (success, uint256(value));
707     }
708 
709     /**
710      * @dev Returns the value associated with `key`.  O(1).
711      *
712      * Requirements:
713      *
714      * - `key` must be in the map.
715      */
716     function get(UintToUintMap storage map, uint256 key) internal view returns (uint256) {
717         return uint256(get(map._inner, bytes32(key)));
718     }
719 
720     /**
721      * @dev Same as {get}, with a custom error message when `key` is not in the map.
722      *
723      * CAUTION: This function is deprecated because it requires allocating memory for the error
724      * message unnecessarily. For custom revert reasons use {tryGet}.
725      */
726     function get(
727         UintToUintMap storage map,
728         uint256 key,
729         string memory errorMessage
730     ) internal view returns (uint256) {
731         return uint256(get(map._inner, bytes32(key), errorMessage));
732     }
733 
734     // UintToAddressMap
735 
736     struct UintToAddressMap {
737         Bytes32ToBytes32Map _inner;
738     }
739 
740     /**
741      * @dev Adds a key-value pair to a map, or updates the value for an existing
742      * key. O(1).
743      *
744      * Returns true if the key was added to the map, that is if it was not
745      * already present.
746      */
747     function set(
748         UintToAddressMap storage map,
749         uint256 key,
750         address value
751     ) internal returns (bool) {
752         return set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
753     }
754 
755     /**
756      * @dev Removes a value from a set. O(1).
757      *
758      * Returns true if the key was removed from the map, that is if it was present.
759      */
760     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
761         return remove(map._inner, bytes32(key));
762     }
763 
764     /**
765      * @dev Returns true if the key is in the map. O(1).
766      */
767     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
768         return contains(map._inner, bytes32(key));
769     }
770 
771     /**
772      * @dev Returns the number of elements in the map. O(1).
773      */
774     function length(UintToAddressMap storage map) internal view returns (uint256) {
775         return length(map._inner);
776     }
777 
778     /**
779      * @dev Returns the element stored at position `index` in the set. O(1).
780      * Note that there are no guarantees on the ordering of values inside the
781      * array, and it may change when more values are added or removed.
782      *
783      * Requirements:
784      *
785      * - `index` must be strictly less than {length}.
786      */
787     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
788         (bytes32 key, bytes32 value) = at(map._inner, index);
789         return (uint256(key), address(uint160(uint256(value))));
790     }
791 
792     /**
793      * @dev Tries to returns the value associated with `key`.  O(1).
794      * Does not revert if `key` is not in the map.
795      *
796      * _Available since v3.4._
797      */
798     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
799         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
800         return (success, address(uint160(uint256(value))));
801     }
802 
803     /**
804      * @dev Returns the value associated with `key`.  O(1).
805      *
806      * Requirements:
807      *
808      * - `key` must be in the map.
809      */
810     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
811         return address(uint160(uint256(get(map._inner, bytes32(key)))));
812     }
813 
814     /**
815      * @dev Same as {get}, with a custom error message when `key` is not in the map.
816      *
817      * CAUTION: This function is deprecated because it requires allocating memory for the error
818      * message unnecessarily. For custom revert reasons use {tryGet}.
819      */
820     function get(
821         UintToAddressMap storage map,
822         uint256 key,
823         string memory errorMessage
824     ) internal view returns (address) {
825         return address(uint160(uint256(get(map._inner, bytes32(key), errorMessage))));
826     }
827 
828     // AddressToUintMap
829 
830     struct AddressToUintMap {
831         Bytes32ToBytes32Map _inner;
832     }
833 
834     /**
835      * @dev Adds a key-value pair to a map, or updates the value for an existing
836      * key. O(1).
837      *
838      * Returns true if the key was added to the map, that is if it was not
839      * already present.
840      */
841     function set(
842         AddressToUintMap storage map,
843         address key,
844         uint256 value
845     ) internal returns (bool) {
846         return set(map._inner, bytes32(uint256(uint160(key))), bytes32(value));
847     }
848 
849     /**
850      * @dev Removes a value from a set. O(1).
851      *
852      * Returns true if the key was removed from the map, that is if it was present.
853      */
854     function remove(AddressToUintMap storage map, address key) internal returns (bool) {
855         return remove(map._inner, bytes32(uint256(uint160(key))));
856     }
857 
858     /**
859      * @dev Returns true if the key is in the map. O(1).
860      */
861     function contains(AddressToUintMap storage map, address key) internal view returns (bool) {
862         return contains(map._inner, bytes32(uint256(uint160(key))));
863     }
864 
865     /**
866      * @dev Returns the number of elements in the map. O(1).
867      */
868     function length(AddressToUintMap storage map) internal view returns (uint256) {
869         return length(map._inner);
870     }
871 
872     /**
873      * @dev Returns the element stored at position `index` in the set. O(1).
874      * Note that there are no guarantees on the ordering of values inside the
875      * array, and it may change when more values are added or removed.
876      *
877      * Requirements:
878      *
879      * - `index` must be strictly less than {length}.
880      */
881     function at(AddressToUintMap storage map, uint256 index) internal view returns (address, uint256) {
882         (bytes32 key, bytes32 value) = at(map._inner, index);
883         return (address(uint160(uint256(key))), uint256(value));
884     }
885 
886     /**
887      * @dev Tries to returns the value associated with `key`.  O(1).
888      * Does not revert if `key` is not in the map.
889      */
890     function tryGet(AddressToUintMap storage map, address key) internal view returns (bool, uint256) {
891         (bool success, bytes32 value) = tryGet(map._inner, bytes32(uint256(uint160(key))));
892         return (success, uint256(value));
893     }
894 
895     /**
896      * @dev Returns the value associated with `key`.  O(1).
897      *
898      * Requirements:
899      *
900      * - `key` must be in the map.
901      */
902     function get(AddressToUintMap storage map, address key) internal view returns (uint256) {
903         return uint256(get(map._inner, bytes32(uint256(uint160(key)))));
904     }
905 
906     /**
907      * @dev Same as {get}, with a custom error message when `key` is not in the map.
908      *
909      * CAUTION: This function is deprecated because it requires allocating memory for the error
910      * message unnecessarily. For custom revert reasons use {tryGet}.
911      */
912     function get(
913         AddressToUintMap storage map,
914         address key,
915         string memory errorMessage
916     ) internal view returns (uint256) {
917         return uint256(get(map._inner, bytes32(uint256(uint160(key))), errorMessage));
918     }
919 
920     // Bytes32ToUintMap
921 
922     struct Bytes32ToUintMap {
923         Bytes32ToBytes32Map _inner;
924     }
925 
926     /**
927      * @dev Adds a key-value pair to a map, or updates the value for an existing
928      * key. O(1).
929      *
930      * Returns true if the key was added to the map, that is if it was not
931      * already present.
932      */
933     function set(
934         Bytes32ToUintMap storage map,
935         bytes32 key,
936         uint256 value
937     ) internal returns (bool) {
938         return set(map._inner, key, bytes32(value));
939     }
940 
941     /**
942      * @dev Removes a value from a set. O(1).
943      *
944      * Returns true if the key was removed from the map, that is if it was present.
945      */
946     function remove(Bytes32ToUintMap storage map, bytes32 key) internal returns (bool) {
947         return remove(map._inner, key);
948     }
949 
950     /**
951      * @dev Returns true if the key is in the map. O(1).
952      */
953     function contains(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool) {
954         return contains(map._inner, key);
955     }
956 
957     /**
958      * @dev Returns the number of elements in the map. O(1).
959      */
960     function length(Bytes32ToUintMap storage map) internal view returns (uint256) {
961         return length(map._inner);
962     }
963 
964     /**
965      * @dev Returns the element stored at position `index` in the set. O(1).
966      * Note that there are no guarantees on the ordering of values inside the
967      * array, and it may change when more values are added or removed.
968      *
969      * Requirements:
970      *
971      * - `index` must be strictly less than {length}.
972      */
973     function at(Bytes32ToUintMap storage map, uint256 index) internal view returns (bytes32, uint256) {
974         (bytes32 key, bytes32 value) = at(map._inner, index);
975         return (key, uint256(value));
976     }
977 
978     /**
979      * @dev Tries to returns the value associated with `key`.  O(1).
980      * Does not revert if `key` is not in the map.
981      */
982     function tryGet(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool, uint256) {
983         (bool success, bytes32 value) = tryGet(map._inner, key);
984         return (success, uint256(value));
985     }
986 
987     /**
988      * @dev Returns the value associated with `key`.  O(1).
989      *
990      * Requirements:
991      *
992      * - `key` must be in the map.
993      */
994     function get(Bytes32ToUintMap storage map, bytes32 key) internal view returns (uint256) {
995         return uint256(get(map._inner, key));
996     }
997 
998     /**
999      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1000      *
1001      * CAUTION: This function is deprecated because it requires allocating memory for the error
1002      * message unnecessarily. For custom revert reasons use {tryGet}.
1003      */
1004     function get(
1005         Bytes32ToUintMap storage map,
1006         bytes32 key,
1007         string memory errorMessage
1008     ) internal view returns (uint256) {
1009         return uint256(get(map._inner, key, errorMessage));
1010     }
1011 }
1012 
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
1025 
1026 /**
1027  * @dev String operations.
1028  */
1029 library Strings {
1030     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1031 
1032     /**
1033      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1034      */
1035     function toString(uint256 value) internal pure returns (string memory) {
1036         // Inspired by OraclizeAPI's implementation - MIT licence
1037         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1038 
1039         if (value == 0) {
1040             return "0";
1041         }
1042         uint256 temp = value;
1043         uint256 digits;
1044         while (temp != 0) {
1045             digits++;
1046             temp /= 10;
1047         }
1048         bytes memory buffer = new bytes(digits);
1049         while (value != 0) {
1050             digits -= 1;
1051             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1052             value /= 10;
1053         }
1054         return string(buffer);
1055     }
1056 
1057     /**
1058      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1059      */
1060     function toHexString(uint256 value) internal pure returns (string memory) {
1061         if (value == 0) {
1062             return "0x00";
1063         }
1064         uint256 temp = value;
1065         uint256 length = 0;
1066         while (temp != 0) {
1067             length++;
1068             temp >>= 8;
1069         }
1070         return toHexString(value, length);
1071     }
1072 
1073     /**
1074      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1075      */
1076     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1077         bytes memory buffer = new bytes(2 * length + 2);
1078         buffer[0] = "0";
1079         buffer[1] = "x";
1080         for (uint256 i = 2 * length + 1; i > 1; --i) {
1081             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1082             value >>= 4;
1083         }
1084         require(value == 0, "Strings: hex length insufficient");
1085         return string(buffer);
1086     }
1087 }
1088 
1089 
1090 /**
1091  * @dev Collection of functions related to the address type
1092  */
1093 library Address {
1094     /**
1095      * @dev Returns true if `account` is a contract.
1096      *
1097      * [IMPORTANT]
1098      * ====
1099      * It is unsafe to assume that an address for which this function returns
1100      * false is an externally-owned account (EOA) and not a contract.
1101      *
1102      * Among others, `isContract` will return false for the following
1103      * types of addresses:
1104      *
1105      *  - an externally-owned account
1106      *  - a contract in construction
1107      *  - an address where a contract will be created
1108      *  - an address where a contract lived, but was destroyed
1109      * ====
1110      *
1111      * [IMPORTANT]
1112      * ====
1113      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1114      *
1115      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1116      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1117      * constructor.
1118      * ====
1119      */
1120     function isContract(address account) internal view returns (bool) {
1121         // This method relies on extcodesize/address.code.length, which returns 0
1122         // for contracts in construction, since the code is only stored at the end
1123         // of the constructor execution.
1124 
1125         return account.code.length > 0;
1126     }
1127 
1128     /**
1129      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1130      * `recipient`, forwarding all available gas and reverting on errors.
1131      *
1132      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1133      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1134      * imposed by `transfer`, making them unable to receive funds via
1135      * `transfer`. {sendValue} removes this limitation.
1136      *
1137      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1138      *
1139      * IMPORTANT: because control is transferred to `recipient`, care must be
1140      * taken to not create reentrancy vulnerabilities. Consider using
1141      * {ReentrancyGuard} or the
1142      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1143      */
1144     function sendValue(address payable recipient, uint256 amount) internal {
1145         require(address(this).balance >= amount, "Address: insufficient balance");
1146 
1147         (bool success, ) = recipient.call{value: amount}("");
1148         require(success, "Address: unable to send value, recipient may have reverted");
1149     }
1150 
1151     /**
1152      * @dev Performs a Solidity function call using a low level `call`. A
1153      * plain `call` is an unsafe replacement for a function call: use this
1154      * function instead.
1155      *
1156      * If `target` reverts with a revert reason, it is bubbled up by this
1157      * function (like regular Solidity function calls).
1158      *
1159      * Returns the raw returned data. To convert to the expected return value,
1160      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1161      *
1162      * Requirements:
1163      *
1164      * - `target` must be a contract.
1165      * - calling `target` with `data` must not revert.
1166      *
1167      * _Available since v3.1._
1168      */
1169     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1170         return functionCall(target, data, "Address: low-level call failed");
1171     }
1172 
1173     /**
1174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1175      * `errorMessage` as a fallback revert reason when `target` reverts.
1176      *
1177      * _Available since v3.1._
1178      */
1179     function functionCall(
1180         address target,
1181         bytes memory data,
1182         string memory errorMessage
1183     ) internal returns (bytes memory) {
1184         return functionCallWithValue(target, data, 0, errorMessage);
1185     }
1186 
1187     /**
1188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1189      * but also transferring `value` wei to `target`.
1190      *
1191      * Requirements:
1192      *
1193      * - the calling contract must have an ETH balance of at least `value`.
1194      * - the called Solidity function must be `payable`.
1195      *
1196      * _Available since v3.1._
1197      */
1198     function functionCallWithValue(
1199         address target,
1200         bytes memory data,
1201         uint256 value
1202     ) internal returns (bytes memory) {
1203         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1204     }
1205 
1206     /**
1207      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1208      * with `errorMessage` as a fallback revert reason when `target` reverts.
1209      *
1210      * _Available since v3.1._
1211      */
1212     function functionCallWithValue(
1213         address target,
1214         bytes memory data,
1215         uint256 value,
1216         string memory errorMessage
1217     ) internal returns (bytes memory) {
1218         require(address(this).balance >= value, "Address: insufficient balance for call");
1219         require(isContract(target), "Address: call to non-contract");
1220 
1221         (bool success, bytes memory returndata) = target.call{value: value}(data);
1222         return verifyCallResult(success, returndata, errorMessage);
1223     }
1224 
1225     /**
1226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1227      * but performing a static call.
1228      *
1229      * _Available since v3.3._
1230      */
1231     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1232         return functionStaticCall(target, data, "Address: low-level static call failed");
1233     }
1234 
1235     /**
1236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1237      * but performing a static call.
1238      *
1239      * _Available since v3.3._
1240      */
1241     function functionStaticCall(
1242         address target,
1243         bytes memory data,
1244         string memory errorMessage
1245     ) internal view returns (bytes memory) {
1246         require(isContract(target), "Address: static call to non-contract");
1247 
1248         (bool success, bytes memory returndata) = target.staticcall(data);
1249         return verifyCallResult(success, returndata, errorMessage);
1250     }
1251 
1252     /**
1253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1254      * but performing a delegate call.
1255      *
1256      * _Available since v3.4._
1257      */
1258     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1259         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1260     }
1261 
1262     /**
1263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1264      * but performing a delegate call.
1265      *
1266      * _Available since v3.4._
1267      */
1268     function functionDelegateCall(
1269         address target,
1270         bytes memory data,
1271         string memory errorMessage
1272     ) internal returns (bytes memory) {
1273         require(isContract(target), "Address: delegate call to non-contract");
1274 
1275         (bool success, bytes memory returndata) = target.delegatecall(data);
1276         return verifyCallResult(success, returndata, errorMessage);
1277     }
1278 
1279     /**
1280      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1281      * revert reason using the provided one.
1282      *
1283      * _Available since v4.3._
1284      */
1285     function verifyCallResult(
1286         bool success,
1287         bytes memory returndata,
1288         string memory errorMessage
1289     ) internal pure returns (bytes memory) {
1290         if (success) {
1291             return returndata;
1292         } else {
1293             // Look for revert reason and bubble it up if present
1294             if (returndata.length > 0) {
1295                 // The easiest way to bubble the revert reason is using memory via assembly
1296 
1297                 assembly {
1298                     let returndata_size := mload(returndata)
1299                     revert(add(32, returndata), returndata_size)
1300                 }
1301             } else {
1302                 revert(errorMessage);
1303             }
1304         }
1305     }
1306 }
1307 
1308 interface IERC721Receiver {
1309     /**
1310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1311      * by `operator` from `from`, this function is called.
1312      *
1313      * It must return its Solidity selector to confirm the token transfer.
1314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1315      *
1316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1317      */
1318     function onERC721Received(
1319         address operator,
1320         address from,
1321         uint256 tokenId,
1322         bytes calldata data
1323     ) external returns (bytes4);
1324 }
1325 
1326 
1327 /**
1328  * @dev Required interface of an ERC721 compliant contract.
1329  */
1330 interface IERC721 is IERC165 {
1331     /**
1332      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1333      */
1334     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1335 
1336     /**
1337      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1338      */
1339     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1340 
1341     /**
1342      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1343      */
1344     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1345 
1346     /**
1347      * @dev Returns the number of tokens in ``owner``'s account.
1348      */
1349     function balanceOf(address owner) external view returns (uint256 balance);
1350 
1351     /**
1352      * @dev Returns the owner of the `tokenId` token.
1353      *
1354      * Requirements:
1355      *
1356      * - `tokenId` must exist.
1357      */
1358     function ownerOf(uint256 tokenId) external view returns (address owner);
1359 
1360     /**
1361      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1362      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1363      *
1364      * Requirements:
1365      *
1366      * - `from` cannot be the zero address.
1367      * - `to` cannot be the zero address.
1368      * - `tokenId` token must exist and be owned by `from`.
1369      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1370      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1371      *
1372      * Emits a {Transfer} event.
1373      */
1374     function safeTransferFrom(
1375         address from,
1376         address to,
1377         uint256 tokenId
1378     ) external;
1379 
1380     /**
1381      * @dev Transfers `tokenId` token from `from` to `to`.
1382      *
1383      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1384      *
1385      * Requirements:
1386      *
1387      * - `from` cannot be the zero address.
1388      * - `to` cannot be the zero address.
1389      * - `tokenId` token must be owned by `from`.
1390      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function transferFrom(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) external;
1399 
1400     /**
1401      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1402      * The approval is cleared when the token is transferred.
1403      *
1404      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1405      *
1406      * Requirements:
1407      *
1408      * - The caller must own the token or be an approved operator.
1409      * - `tokenId` must exist.
1410      *
1411      * Emits an {Approval} event.
1412      */
1413     function approve(address to, uint256 tokenId) external;
1414 
1415     /**
1416      * @dev Returns the account approved for `tokenId` token.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      */
1422     function getApproved(uint256 tokenId) external view returns (address operator);
1423 
1424     /**
1425      * @dev Approve or remove `operator` as an operator for the caller.
1426      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1427      *
1428      * Requirements:
1429      *
1430      * - The `operator` cannot be the caller.
1431      *
1432      * Emits an {ApprovalForAll} event.
1433      */
1434     function setApprovalForAll(address operator, bool _approved) external;
1435 
1436     /**
1437      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1438      *
1439      * See {setApprovalForAll}
1440      */
1441     function isApprovedForAll(address owner, address operator) external view returns (bool);
1442 
1443     /**
1444      * @dev Safely transfers `tokenId` token from `from` to `to`.
1445      *
1446      * Requirements:
1447      *
1448      * - `from` cannot be the zero address.
1449      * - `to` cannot be the zero address.
1450      * - `tokenId` token must exist and be owned by `from`.
1451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1452      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1453      *
1454      * Emits a {Transfer} event.
1455      */
1456     function safeTransferFrom(
1457         address from,
1458         address to,
1459         uint256 tokenId,
1460         bytes calldata data
1461     ) external;
1462 }
1463 
1464 
1465 
1466 /**
1467  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1468  * @dev See https://eips.ethereum.org/EIPS/eip-721
1469  */
1470 interface IERC721Metadata is IERC721 {
1471     /**
1472      * @dev Returns the token collection name.
1473      */
1474     function name() external view returns (string memory);
1475 
1476     /**
1477      * @dev Returns the token collection symbol.
1478      */
1479     function symbol() external view returns (string memory);
1480 
1481     /**
1482      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1483      */
1484     function tokenURI(uint256 tokenId) external view returns (string memory);
1485 }
1486 
1487 
1488 /**
1489  * @dev Implementation of the {IERC165} interface.
1490  *
1491  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1492  * for the additional interface id that will be supported. For example:
1493  *
1494  * ```solidity
1495  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1496  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1497  * }
1498  * ```
1499  *
1500  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1501  */
1502 abstract contract ERC165 is IERC165 {
1503     /**
1504      * @dev See {IERC165-supportsInterface}.
1505      */
1506     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1507         return interfaceId == type(IERC165).interfaceId;
1508     }
1509 }
1510 
1511 
1512 /**
1513  * @dev Contract module which provides a basic access control mechanism, where
1514  * there is an account (an owner) that can be granted exclusive access to
1515  * specific functions.
1516  *
1517  * By default, the owner account will be the one that deploys the contract. This
1518  * can later be changed with {transferOwnership}.
1519  *
1520  * This module is used through inheritance. It will make available the modifier
1521  * `onlyOwner`, which can be applied to your functions to restrict their use to
1522  * the owner.
1523  */
1524 abstract contract Ownable is Context {
1525     address private _owner;
1526 
1527     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1528 
1529     /**
1530      * @dev Initializes the contract setting the deployer as the initial owner.
1531      */
1532     constructor() {
1533         _transferOwnership(_msgSender());
1534     }
1535 
1536     /**
1537      * @dev Returns the address of the current owner.
1538      */
1539     function owner() public view virtual returns (address) {
1540         return _owner;
1541     }
1542 
1543     /**
1544      * @dev Throws if called by any account other than the owner.
1545      */
1546     modifier onlyOwner() {
1547         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1548         _;
1549     }
1550 
1551     /**
1552      * @dev Leaves the contract without owner. It will not be possible to call
1553      * `onlyOwner` functions anymore. Can only be called by the current owner.
1554      *
1555      * NOTE: Renouncing ownership will leave the contract without an owner,
1556      * thereby removing any functionality that is only available to the owner.
1557      */
1558     function renounceOwnership() public virtual onlyOwner {
1559         _transferOwnership(address(0));
1560     }
1561 
1562     /**
1563      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1564      * Can only be called by the current owner.
1565      */
1566     function transferOwnership(address newOwner) public virtual onlyOwner {
1567         require(newOwner != address(0), "Ownable: new owner is the zero address");
1568         _transferOwnership(newOwner);
1569     }
1570 
1571     /**
1572      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1573      * Internal function without access restriction.
1574      */
1575     function _transferOwnership(address newOwner) internal virtual {
1576         address oldOwner = _owner;
1577         _owner = newOwner;
1578         emit OwnershipTransferred(oldOwner, newOwner);
1579     }
1580 }
1581 
1582 
1583 error ApprovalCallerNotOwnerNorApproved();
1584 error ApprovalQueryForNonexistentToken();
1585 error ApproveToCaller();
1586 error ApprovalToCurrentOwner();
1587 error BalanceQueryForZeroAddress();
1588 error MintToZeroAddress();
1589 error MintZeroQuantity();
1590 error OwnerQueryForNonexistentToken();
1591 error TransferCallerNotOwnerNorApproved();
1592 error TransferFromIncorrectOwner();
1593 error TransferToNonERC721ReceiverImplementer();
1594 error TransferToZeroAddress();
1595 error URIQueryForNonexistentToken();
1596 
1597 /**
1598  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1599  * the Metadata extension. Built to optimize for lower gas during batch mints.
1600  *
1601  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1602  *
1603  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1604  *
1605  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1606  */
1607 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1608     using Address for address;
1609     using Strings for uint256;
1610 
1611     // Compiler will pack this into a single 256bit word.
1612     struct TokenOwnership {
1613         // The address of the owner.
1614         address addr;
1615         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1616         uint64 startTimestamp;
1617         // Whether the token has been burned.
1618         bool burned;
1619     }
1620 
1621     // Compiler will pack this into a single 256bit word.
1622     struct AddressData {
1623         // Realistically, 2**64-1 is more than enough.
1624         uint64 balance;
1625         // Keeps track of mint count with minimal overhead for tokenomics.
1626         uint64 numberMinted;
1627         // Keeps track of burn count with minimal overhead for tokenomics.
1628         uint64 numberBurned;
1629         // For miscellaneous variable(s) pertaining to the address
1630         // (e.g. number of whitelist mint slots used).
1631         // If there are multiple variables, please pack them into a uint64.
1632         uint64 aux;
1633     }
1634 
1635     // The tokenId of the next token to be minted.
1636     uint256 internal _currentIndex;
1637 
1638     // The number of tokens burned.
1639     uint256 internal _burnCounter;
1640 
1641     // Token name
1642     string private _name;
1643 
1644     // Token symbol
1645     string private _symbol;
1646 
1647     // Mapping from token ID to ownership details
1648     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1649     mapping(uint256 => TokenOwnership) internal _ownerships;
1650 
1651     // Mapping owner address to address data
1652     mapping(address => AddressData) private _addressData;
1653 
1654     // Mapping from token ID to approved address
1655     mapping(uint256 => address) private _tokenApprovals;
1656 
1657     // Mapping from owner to operator approvals
1658     mapping(address => mapping(address => bool)) private _operatorApprovals;
1659 
1660     constructor(string memory name_, string memory symbol_) {
1661         _name = name_;
1662         _symbol = symbol_;
1663         _currentIndex = _startTokenId();
1664     }
1665 
1666     /**
1667      * To change the starting tokenId, please override this function.
1668      */
1669     function _startTokenId() internal view virtual returns (uint256) {
1670         return 0;
1671     }
1672 
1673     /**
1674      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1675      */
1676     function totalSupply() public view returns (uint256) {
1677         // Counter underflow is impossible as _burnCounter cannot be incremented
1678         // more than _currentIndex - _startTokenId() times
1679         unchecked {
1680             return _currentIndex - _burnCounter - _startTokenId();
1681         }
1682     }
1683 
1684     /**
1685      * Returns the total amount of tokens minted in the contract.
1686      */
1687     function _totalMinted() internal view returns (uint256) {
1688         // Counter underflow is impossible as _currentIndex does not decrement,
1689         // and it is initialized to _startTokenId()
1690         unchecked {
1691             return _currentIndex - _startTokenId();
1692         }
1693     }
1694 
1695     /**
1696      * @dev See {IERC165-supportsInterface}.
1697      */
1698     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1699         return
1700             interfaceId == type(IERC721).interfaceId ||
1701             interfaceId == type(IERC721Metadata).interfaceId ||
1702             super.supportsInterface(interfaceId);
1703     }
1704 
1705     /**
1706      * @dev See {IERC721-balanceOf}.
1707      */
1708     function balanceOf(address owner) public view override returns (uint256) {
1709         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1710         return uint256(_addressData[owner].balance);
1711     }
1712 
1713     /**
1714      * Returns the number of tokens minted by `owner`.
1715      */
1716     function _numberMinted(address owner) internal view returns (uint256) {
1717         return uint256(_addressData[owner].numberMinted);
1718     }
1719 
1720     /**
1721      * Returns the number of tokens burned by or on behalf of `owner`.
1722      */
1723     function _numberBurned(address owner) internal view returns (uint256) {
1724         return uint256(_addressData[owner].numberBurned);
1725     }
1726 
1727     /**
1728      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1729      */
1730     function _getAux(address owner) internal view returns (uint64) {
1731         return _addressData[owner].aux;
1732     }
1733 
1734     /**
1735      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1736      * If there are multiple variables, please pack them into a uint64.
1737      */
1738     function _setAux(address owner, uint64 aux) internal {
1739         _addressData[owner].aux = aux;
1740     }
1741 
1742     /**
1743      * Gas spent here starts off proportional to the maximum mint batch size.
1744      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1745      */
1746     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1747         uint256 curr = tokenId;
1748 
1749         unchecked {
1750             if (_startTokenId() <= curr && curr < _currentIndex) {
1751                 TokenOwnership memory ownership = _ownerships[curr];
1752                 if (!ownership.burned) {
1753                     if (ownership.addr != address(0)) {
1754                         return ownership;
1755                     }
1756                     // Invariant:
1757                     // There will always be an ownership that has an address and is not burned
1758                     // before an ownership that does not have an address and is not burned.
1759                     // Hence, curr will not underflow.
1760                     while (true) {
1761                         curr--;
1762                         ownership = _ownerships[curr];
1763                         if (ownership.addr != address(0)) {
1764                             return ownership;
1765                         }
1766                     }
1767                 }
1768             }
1769         }
1770         revert OwnerQueryForNonexistentToken();
1771     }
1772 
1773     /**
1774      * @dev See {IERC721-ownerOf}.
1775      */
1776     function ownerOf(uint256 tokenId) public view override returns (address) {
1777         return _ownershipOf(tokenId).addr;
1778     }
1779 
1780     /**
1781      * @dev See {IERC721Metadata-name}.
1782      */
1783     function name() public view virtual override returns (string memory) {
1784         return _name;
1785     }
1786 
1787     /**
1788      * @dev See {IERC721Metadata-symbol}.
1789      */
1790     function symbol() public view virtual override returns (string memory) {
1791         return _symbol;
1792     }
1793 
1794     /**
1795      * @dev See {IERC721Metadata-tokenURI}.
1796      */
1797     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1798         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1799 
1800         string memory baseURI = _baseURI();
1801         if (_blindBoxStart() <= tokenId)
1802             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, 'blindbox.json')) : '';
1803 
1804         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1805     }
1806 
1807     function _baseURI() internal view virtual returns (string memory) {
1808         return "";
1809     }
1810 
1811     function _blindBoxStart() internal view virtual returns (uint256) {
1812         return 0;
1813     }
1814 
1815     /**
1816      * @dev See {IERC721-approve}.
1817      */
1818     function approve(address to, uint256 tokenId) public override {
1819         address owner = ERC721A.ownerOf(tokenId);
1820         if (to == owner) revert ApprovalToCurrentOwner();
1821 
1822         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1823             revert ApprovalCallerNotOwnerNorApproved();
1824         }
1825 
1826         _approve(to, tokenId, owner);
1827     }
1828 
1829     /**
1830      * @dev See {IERC721-getApproved}.
1831      */
1832     function getApproved(uint256 tokenId) public view override returns (address) {
1833         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1834 
1835         return _tokenApprovals[tokenId];
1836     }
1837 
1838     /**
1839      * @dev See {IERC721-setApprovalForAll}.
1840      */
1841     function setApprovalForAll(address operator, bool approved) public virtual override {
1842         if (operator == _msgSender()) revert ApproveToCaller();
1843 
1844         _operatorApprovals[_msgSender()][operator] = approved;
1845         emit ApprovalForAll(_msgSender(), operator, approved);
1846     }
1847 
1848     /**
1849      * @dev See {IERC721-isApprovedForAll}.
1850      */
1851     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1852         return _operatorApprovals[owner][operator];
1853     }
1854 
1855     /**
1856      * @dev See {IERC721-transferFrom}.
1857      */
1858     function transferFrom(
1859         address from,
1860         address to,
1861         uint256 tokenId
1862     ) public virtual override {
1863         _transfer(from, to, tokenId);
1864     }
1865 
1866     /**
1867      * @dev See {IERC721-safeTransferFrom}.
1868      */
1869     function safeTransferFrom(
1870         address from,
1871         address to,
1872         uint256 tokenId
1873     ) public virtual override {
1874         safeTransferFrom(from, to, tokenId, '');
1875     }
1876 
1877     /**
1878      * @dev See {IERC721-safeTransferFrom}.
1879      */
1880     function safeTransferFrom(
1881         address from,
1882         address to,
1883         uint256 tokenId,
1884         bytes memory _data
1885     ) public virtual override {
1886         _transfer(from, to, tokenId);
1887         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1888             revert TransferToNonERC721ReceiverImplementer();
1889         }
1890     }
1891 
1892     /**
1893      * @dev Returns whether `tokenId` exists.
1894      *
1895      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1896      *
1897      * Tokens start existing when they are minted (`_mint`),
1898      */
1899     function _exists(uint256 tokenId) internal view returns (bool) {
1900         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1901     }
1902 
1903     function _safeMint(address to, uint256 quantity) internal {
1904         _safeMint(to, quantity, '');
1905     }
1906 
1907     /**
1908      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1909      *
1910      * Requirements:
1911      *
1912      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1913      * - `quantity` must be greater than 0.
1914      *
1915      * Emits a {Transfer} event.
1916      */
1917     function _safeMint(
1918         address to,
1919         uint256 quantity,
1920         bytes memory _data
1921     ) internal {
1922         _mint(to, quantity, _data, true);
1923     }
1924 
1925     /**
1926      * @dev Mints `quantity` tokens and transfers them to `to`.
1927      *
1928      * Requirements:
1929      *
1930      * - `to` cannot be the zero address.
1931      * - `quantity` must be greater than 0.
1932      *
1933      * Emits a {Transfer} event.
1934      */
1935     function _mint(
1936         address to,
1937         uint256 quantity,
1938         bytes memory _data,
1939         bool safe
1940     ) internal {
1941         uint256 startTokenId = _currentIndex;
1942         if (to == address(0)) revert MintToZeroAddress();
1943         if (quantity == 0) revert MintZeroQuantity();
1944 
1945         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1946 
1947         // Overflows are incredibly unrealistic.
1948         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1949         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1950         unchecked {
1951             _addressData[to].balance += uint64(quantity);
1952             _addressData[to].numberMinted += uint64(quantity);
1953 
1954             _ownerships[startTokenId].addr = to;
1955             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1956 
1957             uint256 updatedIndex = startTokenId;
1958             uint256 end = updatedIndex + quantity;
1959 
1960             if (safe && to.isContract()) {
1961                 do {
1962                     emit Transfer(address(0), to, updatedIndex);
1963                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1964                         revert TransferToNonERC721ReceiverImplementer();
1965                     }
1966                 } while (updatedIndex != end);
1967                 // Reentrancy protection
1968                 if (_currentIndex != startTokenId) revert();
1969             } else {
1970                 do {
1971                     emit Transfer(address(0), to, updatedIndex++);
1972                 } while (updatedIndex != end);
1973             }
1974             _currentIndex = updatedIndex;
1975         }
1976         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1977     }
1978 
1979     /**
1980      * @dev Transfers `tokenId` from `from` to `to`.
1981      *
1982      * Requirements:
1983      *
1984      * - `to` cannot be the zero address.
1985      * - `tokenId` token must be owned by `from`.
1986      *
1987      * Emits a {Transfer} event.
1988      */
1989     function _transfer(
1990         address from,
1991         address to,
1992         uint256 tokenId
1993     ) private {
1994         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1995 
1996         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1997 
1998         bool isApprovedOrOwner = (_msgSender() == from ||
1999             isApprovedForAll(from, _msgSender()) ||
2000             getApproved(tokenId) == _msgSender());
2001 
2002         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2003         if (to == address(0)) revert TransferToZeroAddress();
2004 
2005         _beforeTokenTransfers(from, to, tokenId, 1);
2006 
2007         // Clear approvals from the previous owner
2008         _approve(address(0), tokenId, from);
2009 
2010         // Underflow of the sender's balance is impossible because we check for
2011         // ownership above and the recipient's balance can't realistically overflow.
2012         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2013         unchecked {
2014             _addressData[from].balance -= 1;
2015             _addressData[to].balance += 1;
2016 
2017             TokenOwnership storage currSlot = _ownerships[tokenId];
2018             currSlot.addr = to;
2019             currSlot.startTimestamp = uint64(block.timestamp);
2020 
2021             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2022             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2023             uint256 nextTokenId = tokenId + 1;
2024             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2025             if (nextSlot.addr == address(0)) {
2026                 // This will suffice for checking _exists(nextTokenId),
2027                 // as a burned slot cannot contain the zero address.
2028                 if (nextTokenId != _currentIndex) {
2029                     nextSlot.addr = from;
2030                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2031                 }
2032             }
2033         }
2034 
2035         emit Transfer(from, to, tokenId);
2036         _afterTokenTransfers(from, to, tokenId, 1);
2037     }
2038 
2039     /**
2040      * @dev This is equivalent to _burn(tokenId, false)
2041      */
2042     function _burn(uint256 tokenId) internal virtual {
2043         _burn(tokenId, false);
2044     }
2045 
2046     /**
2047      * @dev Destroys `tokenId`.
2048      * The approval is cleared when the token is burned.
2049      *
2050      * Requirements:
2051      *
2052      * - `tokenId` must exist.
2053      *
2054      * Emits a {Transfer} event.
2055      */
2056     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2057         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2058 
2059         address from = prevOwnership.addr;
2060 
2061         if (approvalCheck) {
2062             bool isApprovedOrOwner = (_msgSender() == from ||
2063                 isApprovedForAll(from, _msgSender()) ||
2064                 getApproved(tokenId) == _msgSender());
2065 
2066             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2067         }
2068 
2069         _beforeTokenTransfers(from, address(0), tokenId, 1);
2070 
2071         // Clear approvals from the previous owner
2072         _approve(address(0), tokenId, from);
2073 
2074         // Underflow of the sender's balance is impossible because we check for
2075         // ownership above and the recipient's balance can't realistically overflow.
2076         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2077         unchecked {
2078             AddressData storage addressData = _addressData[from];
2079             addressData.balance -= 1;
2080             addressData.numberBurned += 1;
2081 
2082             // Keep track of who burned the token, and the timestamp of burning.
2083             TokenOwnership storage currSlot = _ownerships[tokenId];
2084             currSlot.addr = from;
2085             currSlot.startTimestamp = uint64(block.timestamp);
2086             currSlot.burned = true;
2087 
2088             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2089             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2090             uint256 nextTokenId = tokenId + 1;
2091             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2092             if (nextSlot.addr == address(0)) {
2093                 // This will suffice for checking _exists(nextTokenId),
2094                 // as a burned slot cannot contain the zero address.
2095                 if (nextTokenId != _currentIndex) {
2096                     nextSlot.addr = from;
2097                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2098                 }
2099             }
2100         }
2101 
2102         emit Transfer(from, address(0), tokenId);
2103         _afterTokenTransfers(from, address(0), tokenId, 1);
2104 
2105         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2106         unchecked {
2107             _burnCounter++;
2108         }
2109     }
2110 
2111     /**
2112      * @dev Approve `to` to operate on `tokenId`
2113      *
2114      * Emits a {Approval} event.
2115      */
2116     function _approve(
2117         address to,
2118         uint256 tokenId,
2119         address owner
2120     ) private {
2121         _tokenApprovals[tokenId] = to;
2122         emit Approval(owner, to, tokenId);
2123     }
2124 
2125     /**
2126      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2127      *
2128      * @param from address representing the previous owner of the given token ID
2129      * @param to target address that will receive the tokens
2130      * @param tokenId uint256 ID of the token to be transferred
2131      * @param _data bytes optional data to send along with the call
2132      * @return bool whether the call correctly returned the expected magic value
2133      */
2134     function _checkContractOnERC721Received(
2135         address from,
2136         address to,
2137         uint256 tokenId,
2138         bytes memory _data
2139     ) private returns (bool) {
2140         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2141             return retval == IERC721Receiver(to).onERC721Received.selector;
2142         } catch (bytes memory reason) {
2143             if (reason.length == 0) {
2144                 revert TransferToNonERC721ReceiverImplementer();
2145             } else {
2146                 assembly {
2147                     revert(add(32, reason), mload(reason))
2148                 }
2149             }
2150         }
2151     }
2152 
2153     /**
2154      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2155      * And also called before burning one token.
2156      *
2157      * startTokenId - the first token id to be transferred
2158      * quantity - the amount to be transferred
2159      *
2160      * Calling conditions:
2161      *
2162      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2163      * transferred to `to`.
2164      * - When `from` is zero, `tokenId` will be minted for `to`.
2165      * - When `to` is zero, `tokenId` will be burned by `from`.
2166      * - `from` and `to` are never both zero.
2167      */
2168     function _beforeTokenTransfers(
2169         address from,
2170         address to,
2171         uint256 startTokenId,
2172         uint256 quantity
2173     ) internal virtual {}
2174 
2175     /**
2176      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2177      * minting.
2178      * And also called after one token has been burned.
2179      *
2180      * startTokenId - the first token id to be transferred
2181      * quantity - the amount to be transferred
2182      *
2183      * Calling conditions:
2184      *
2185      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2186      * transferred to `to`.
2187      * - When `from` is zero, `tokenId` has been minted for `to`.
2188      * - When `to` is zero, `tokenId` has been burned by `from`.
2189      * - `from` and `to` are never both zero.
2190      */
2191     function _afterTokenTransfers(
2192         address from,
2193         address to,
2194         uint256 startTokenId,
2195         uint256 quantity
2196     ) internal virtual {}
2197 }
2198 
2199 contract HanfuNFT is ERC721A, Ownable {
2200     using EnumerableMap for EnumerableMap.AddressToUintMap;
2201     address payable busyWallet;
2202     address payable busyWallet1;
2203     address payable busyWallet2;
2204     address payable busyWallet3;
2205     address payable busyWallet4;
2206 
2207     uint256 public supply = 4839;  //5200 - (120 + 241)  reserve 120 for team, reserve 80 for og
2208     mapping(address => uint256) public minted;
2209 
2210     IERC20Metadata private HFT;
2211     uint8 private stockValidFlag = 0;
2212     mapping(uint256 => EnumerableMap.AddressToUintMap) private stock;
2213     mapping(uint256 => EnumerableMap.AddressToUintMap) private stockSelling;
2214     mapping(uint256 => EnumerableMap.AddressToUintMap) private stockSellingValue;
2215     mapping(uint256 => string[]) public nftSubLink;
2216     mapping(uint256 => uint256) public nftSubLinkShowType;
2217 
2218     string private _baseTokenURI; 
2219     
2220     uint8 reservedFlag = 0;
2221     uint32 public nftSaleStage = 0;
2222     
2223     bytes32 public merkleRoot;
2224     mapping (address => uint32) private wlUsedList;
2225     uint32 wlUsedRound = 0;
2226     uint256 internal blindBoxStart = 0;
2227     
2228     modifier callerIsUser() {
2229         require(tx.origin == msg.sender, "The caller is another contract");
2230         _;
2231     }
2232 
2233     constructor(address payable _wallet, address payable _wallet1, address payable _wallet2, address payable _wallet3, address payable _wallet4) ERC721A("HanfuNFT", "HANFU") {
2234         busyWallet = _wallet;
2235         busyWallet1 = _wallet1;
2236         busyWallet2 = _wallet2;
2237         busyWallet3 = _wallet3;
2238         busyWallet4 = _wallet4;
2239     }
2240 
2241     function verifyProof(bytes memory _proof, bytes32 _root, bytes32 _leaf) public pure returns (bool) {
2242         // Check if proof length is a multiple of 32
2243         if (_proof.length % 32 != 0) return false;
2244 
2245         bytes32 proofElement;
2246         bytes32 computedHash = _leaf;
2247 
2248         for (uint256 i = 32; i <= _proof.length; i += 32) {
2249             assembly {
2250                 // Load the current element of the proof
2251                 proofElement := mload(add(_proof, i))
2252             }
2253 
2254             if (computedHash < proofElement) {
2255                 // Hash(current computed hash + current element of the proof)
2256                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
2257             } else {
2258                 // Hash(current element of the proof + current computed hash)
2259                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
2260             }
2261         }
2262 
2263         // Check if the computed hash (root) is equal to the provided root
2264         return computedHash == _root;
2265     }
2266 
2267     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2268         merkleRoot = _merkleRoot;
2269         wlUsedRound++;
2270     }
2271     
2272     function reserveHanfu() public onlyOwner {        
2273         require(reservedFlag == 0, "not allowed reserved");
2274         _safeMint(msg.sender, 120);
2275         reservedFlag = 1;
2276     }
2277 
2278     function ogDrop() public onlyOwner {
2279         _safeMint(0xb78dBB2cfE92251a4Bf29Dcd391A2cA8Cc8c4310,3); 
2280         _safeMint(0x2a842e026a36f9af2b253855B3DF5e47E2365A83,3);
2281         _safeMint(0xDF6B953AA8a2C10323d8c385c64449d75e3B812c,3);
2282         _safeMint(0x045fb828ea12d68A1734DfE81E5F9d066c1885cF,4);
2283         _safeMint(0xC3FC1492197d3C19Da46B8FE40CA08f01d2feaB4,3);
2284         _safeMint(0x0A90F733a52f5a1E0A405D2fD12df585CF63e6Ee,5);
2285         _safeMint(0xD683c0c013E1382143b364D7fb7B64c3097087af,5);
2286         _safeMint(0x8bBe9845d4e3760360694EEEC91405EE922caF61,4);
2287         _safeMint(0xDe9a9425b3CE28f66719eA606B1d1FDda210A94d,3);
2288         _safeMint(0x1e7d1ad7FE2372eF64Bd4238d47891f675C75425,3);
2289         _safeMint(0xC0C608A6E1E6B6B7ABA00D2BAE22BF4c5F51f739,5);
2290         _safeMint(0xb02FE17677071baF521f86893ae2e8d0DA7AC06c,2);
2291         _safeMint(0x7f3ACd5eb9AE7FDb51b085820db3EDB04696a6c0,2);
2292         _safeMint(0xb857b4c9693285A36705a146d9Dbe23eA8da4671,5);
2293         _safeMint(0xdE2baaa31b71Caa10782c5396ccaad24DF6Cf943,3);
2294         _safeMint(0x69358FC4B6f111C449e9eeF917335FE1e1c3408D,5);
2295         _safeMint(0x68FC110bf23fd9c20C480158b6Cd0721D9e13739,3);
2296         _safeMint(0x4bcC170AF3950Fa0C72c324edD563a566Ff6a9c2,3);
2297         _safeMint(0xbAcF53F44cbe63745fFD1071EDD541697F76f256,3);
2298         _safeMint(0xFc56c2b11c329C1fBc5Ed70a6a8eE6bd471CCe76,5);
2299         _safeMint(0x2a7F7B94B4ACd9b244675f3342c8321E8A6c3327,3);
2300         _safeMint(0x9dAea1CeA8efa3FB8CAd8f0A05aF6306512A54D1,3);
2301         _safeMint(0xA04294Ca075F369c900D6399c3D809Ee4417C5B5,5);
2302         _safeMint(0xc46dA85Da706fEB3165FA8Acb3CC44e4105923Dc,5);
2303         _safeMint(0xD9c3a1F6d84fEa2A0F8eEBe9e3E00899f07D6Ed8,5);
2304         _safeMint(0x24e16a89dFc3e86D70D739B229749D28126fF57E,5);
2305         _safeMint(0xE913C0a9Fdb0395862eE18BC8B264652A90DF0A5,5);
2306         _safeMint(0xd2B7094c390c30EE2bDC8e20a91A7fe633f65B58,5);
2307         _safeMint(0x9F11AD1fdF5FCb2CD088f66380372A065181Df8a,5);
2308         _safeMint(0x93DC9a9b45750F1b7A2b47e6Cc1C5FB2779a999e,5);
2309         _safeMint(0x2C67AAA82EcB01b3a5F42E45D9C232D945fD637b,5);
2310         _safeMint(0xBA3D5a706cAd6f6D3017A8B4B244089C45803E9D,5);
2311         _safeMint(0xcc4F719022d8eae53126d77FEB8382Eb57b19437,5);
2312         _safeMint(0x079AaDF2E92E2513606a2962ae6Eeeb7CCF286ef,5);
2313         _safeMint(0x5566188c75872D9D3DDC722096a26a86abE22016,3);
2314         _safeMint(0x14e9218dEEa10CbD6e16659887812B9862a25F3B,5);
2315         _safeMint(0x4cba67Cd2b6321b6472eF9b2637Ba3351E0A1001,5);
2316         _safeMint(0xF01AC313305543002EE4c7F28448d820a158fB65,5);
2317         _safeMint(0x7b7731ed65AFdb0c5a8F822d96B272078eC96175,5);
2318         _safeMint(0x0112Eb607B478Fd4Fea7F0B66b25865fE6527327,5);
2319         _safeMint(0x84088Ad00aACB86a71cB7F99856E51812e44a2b0,5);
2320         _safeMint(0xEF7294794cB16f7663065207a544E010A3707Abb,5);
2321         _safeMint(0x64A5d2e82A6bc529ad7aE8615946B768d128f7EF,5);
2322         _safeMint(0xCb6eA79A271f42aABA7d1D51F3Be9f8c52B8F80d,5);
2323         _safeMint(0x5C8A57817569Cba1815b017993bd17a78f6aaa3D,5);
2324         _safeMint(0x3601d7e270d2bC03c6328dF4D85C7E83D72A2729,5);
2325         _safeMint(0xE539758434308f179De457548D8cF940F0f6609B,5);
2326         _safeMint(0xcAb1AA589B944Ef56Dd7846aF934889e4B7Afc77,5);
2327         _safeMint(0xA8a9576f4Fa9a0F4440cb588Be6729ca08c6166e,5);
2328         _safeMint(0x7802cC861eb65431F6B7f33C4A4092b36529be76,5);
2329         _safeMint(0xdd21F27666b93D049744C332bBFFfaa1554dBEc7,5);
2330         _safeMint(0x964E4Dba0F4081a6c41D6183d10428F718Ff61BB,5);
2331         _safeMint(0x295a9b1c5DbfDfD734bcc2efcD06C4d3ad8837Fd,5);
2332         _safeMint(0xDd1BFdBD1019686E903DA13a0c3BC9ADcf183A89,5);
2333         _safeMint(0x056E8118F42DAc7E61B4cC00d77a97f0BA84F07c,5);
2334     }
2335 
2336     function getWlUsedFlag() public view returns(bool) {
2337         return wlUsedList[msg.sender] == wlUsedRound;
2338     }
2339 
2340     function toNextNftSaleRound() public onlyOwner {
2341         nftSaleStage++;
2342     }
2343 
2344     function getHanfuPrice() public view returns(uint256) {
2345         if (nftSaleStage < 2) {
2346             return 0;
2347         } else {
2348             return 20000000000000000; //0.020 ETH
2349         }
2350     }
2351 
2352     function getHanfuTokenPrice() public pure returns(uint256) {
2353             return 1000000000000; //0.000001 ETH
2354     }
2355 
2356     function getMaxHanfuPurchase() public view returns(uint256) {
2357         if (nftSaleStage == 0) { // gold white list
2358             return 2;
2359         } else if (nftSaleStage == 1) { //normal wihte list
2360             return 1;
2361         } else { //public issue
2362             return 20;
2363         }
2364     }
2365 
2366     function reValidWhiteList() public payable {
2367         require(39000000000000000 <= msg.value, "Ether value sent is not correct");
2368         require(wlUsedList[msg.sender] == wlUsedRound, "Not used whitelist");
2369         wlUsedList[msg.sender] = 0;
2370     }
2371 
2372     function mintHanfuWl(uint numberOfTokens, bytes memory proof) public {
2373         require(numberOfTokens <= getMaxHanfuPurchase(), "can not mint this many.");
2374         require(numberOfTokens <= supply, "NFT balance is not enough.");
2375 
2376         require(wlUsedList[msg.sender] != wlUsedRound, "Already Use Wl");
2377         require(verifyProof(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not in Whitelist");
2378         
2379         wlUsedList[msg.sender] = wlUsedRound;
2380         supply -= numberOfTokens;
2381         _safeMint(msg.sender, numberOfTokens);
2382     }
2383 
2384     function mintHanfu(uint256 numberOfTokens) external payable callerIsUser {
2385         require(nftSaleStage > 1, "not in public sale state");
2386         require(minted[msg.sender] + numberOfTokens <= getMaxHanfuPurchase(), "can not mint this many.");
2387         require(numberOfTokens <= supply, "NFT balance is not enough.");
2388         require(numberOfTokens * getHanfuPrice() <= msg.value, "balance is not enough.");
2389 
2390         minted[msg.sender] += numberOfTokens;
2391         supply -= numberOfTokens;
2392         _safeMint(msg.sender, numberOfTokens);
2393     }
2394 
2395     function setBaseURI(string calldata baseURI) external onlyOwner {
2396         _baseTokenURI = baseURI;
2397     }
2398     
2399     function _baseURI() internal view virtual override returns (string memory) {
2400         return _baseTokenURI;
2401     }
2402 
2403     function _blindBoxStart() internal view virtual override returns (uint256) {
2404         return blindBoxStart;
2405     }
2406 
2407     function setBlindBoxStart(uint _index) public onlyOwner {
2408         blindBoxStart = _index;    
2409     }
2410 
2411     function withdraw() external onlyOwner {
2412         require(address(this).balance > 0, "balance is not enough.");
2413 
2414         uint balance = address(this).balance;
2415         busyWallet3.transfer(balance);
2416     }
2417 
2418     function mintHanfuToken(uint256 numberOfTokens) external payable callerIsUser {
2419         //require(minted[msg.sender] + numberOfTokens <= getMaxHanfuPurchase(), "can not mint this many.");
2420         //require(numberOfTokens <= supply, "NFT balance is not enough.");
2421         require(numberOfTokens * getHanfuTokenPrice() <= msg.value, "balance is not enough.");
2422         HFT.transfer(msg.sender, numberOfTokens);
2423     }
2424 
2425     //function withdrawHFT() external onlyOwner {
2426     //    require(HFT.balanceOf(msg.sender) > 0, "balance is not enough.");
2427     //    HFT.transfer(msg.sender, HFT.balanceOf(msg.sender));
2428     //}
2429 
2430     function hanfuStockValid(address addr) public onlyOwner {
2431 		require(stockValidFlag == 0, "not alllowed operation");
2432 		stockValidFlag = 1;
2433 		HFT = IERC20Metadata(addr);
2434 	}
2435 
2436     function hanfuTokenDrop(address _addr, uint amount) external onlyOwner {
2437         HFT.transfer(_addr, amount);
2438     }
2439 
2440     uint256 private nftStock = 2000000; 
2441     function buyNFTStock(uint nftId, uint amount, address seller) public {
2442         if (stock[nftId].length() == 0) {
2443             stock[nftId].set(ownerOf(nftId), nftStock);
2444         } else {
2445             uint sellingAmount = stockSelling[nftId].get(seller);
2446             uint sellingValue = stockSellingValue[nftId].get(seller);
2447             uint ownAmount = stock[nftId].get(seller);
2448 
2449             require(sellingAmount >= amount, "not enough stock num");
2450             require(amount * sellingValue <= HFT.balanceOf(msg.sender), "not enough stock num");
2451             //HFT.approve(address(this), amount * sellingValue);
2452             HFT.transferFrom(msg.sender, seller, amount * sellingValue);
2453             
2454             ownAmount = ownAmount - amount;
2455             if (ownAmount > 0) {
2456                 stock[nftId].set(seller, ownAmount);
2457                 stockSelling[nftId].set(seller, sellingAmount - amount);
2458             } else {
2459                 stock[nftId].remove(seller);
2460                 stockSelling[nftId].remove(seller);
2461             }
2462 
2463             if (stock[nftId].contains(msg.sender))
2464                 amount = amount + stock[nftId].get(msg.sender);
2465             stock[nftId].set(msg.sender, amount);
2466         }
2467     }
2468 
2469     function sellNFTStock(uint nftId, uint amount, uint value) public {
2470         require(stock[nftId].get(msg.sender) >= amount, "no enough stock");
2471         
2472         if (amount == 0) {
2473             stockSelling[nftId].remove(msg.sender);
2474             stockSellingValue[nftId].remove(msg.sender);
2475         } else {
2476             stockSelling[nftId].set(msg.sender, amount);
2477             stockSellingValue[nftId].set(msg.sender, value);
2478         }
2479     }
2480 
2481     function setNFTSubLink(uint nftId, string memory link) public {
2482         require(stock[nftId].get(msg.sender) > nftStock / stock[nftId].length(), "not allowed operation");
2483         nftSubLink[nftId].push(link);
2484     }
2485 
2486     function getNFTsubLinkLength(uint nftId) public view returns(uint) {
2487         return nftSubLink[nftId].length;
2488     }
2489 
2490     function getNFTsubLink(uint nftId, uint index) public view returns(string memory) {
2491         return nftSubLink[nftId][index];
2492     }
2493 
2494     function setNFTSubLinkShowType(uint nftId, uint showType) public {
2495         require(stock[nftId].get(msg.sender) > nftStock / stock[nftId].length(), "not allowed operation");
2496         nftSubLinkShowType[nftId] = showType;
2497     }
2498 
2499     function getNFTSellingLength(uint nftId) public view returns(uint256) {
2500         return stockSelling[nftId].length();
2501     }
2502 
2503     function getNFTSellingInfo(uint nftId, uint index) public view returns(address, uint256) {
2504         return stockSelling[nftId].at(index);
2505     }
2506 
2507     function getNFTSellingValueInfo(uint nftId, uint index) public view returns(address, uint256) {
2508         return stockSellingValue[nftId].at(index);
2509     }
2510 
2511     function getNFTStockInfo(uint nftId, uint index) public view returns(address, uint256) {
2512         return stock[nftId].at(index);
2513     }
2514 
2515     fallback() external payable{}
2516     receive() external payable{}
2517 }