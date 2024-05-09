1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.6.0;
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
38 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/utils/EnumerableMap.sol
39 
40 
41 
42 pragma solidity ^0.6.0;
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
278 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/utils/EnumerableSet.sol
279 
280 
281 
282 pragma solidity ^0.6.0;
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
305  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
306  * (`UintSet`) are supported.
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
414     // AddressSet
415 
416     struct AddressSet {
417         Set _inner;
418     }
419 
420     /**
421      * @dev Add a value to a set. O(1).
422      *
423      * Returns true if the value was added to the set, that is if it was not
424      * already present.
425      */
426     function add(AddressSet storage set, address value) internal returns (bool) {
427         return _add(set._inner, bytes32(uint256(value)));
428     }
429 
430     /**
431      * @dev Removes a value from a set. O(1).
432      *
433      * Returns true if the value was removed from the set, that is if it was
434      * present.
435      */
436     function remove(AddressSet storage set, address value) internal returns (bool) {
437         return _remove(set._inner, bytes32(uint256(value)));
438     }
439 
440     /**
441      * @dev Returns true if the value is in the set. O(1).
442      */
443     function contains(AddressSet storage set, address value) internal view returns (bool) {
444         return _contains(set._inner, bytes32(uint256(value)));
445     }
446 
447     /**
448      * @dev Returns the number of values in the set. O(1).
449      */
450     function length(AddressSet storage set) internal view returns (uint256) {
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
464     function at(AddressSet storage set, uint256 index) internal view returns (address) {
465         return address(uint256(_at(set._inner, index)));
466     }
467 
468 
469     // UintSet
470 
471     struct UintSet {
472         Set _inner;
473     }
474 
475     /**
476      * @dev Add a value to a set. O(1).
477      *
478      * Returns true if the value was added to the set, that is if it was not
479      * already present.
480      */
481     function add(UintSet storage set, uint256 value) internal returns (bool) {
482         return _add(set._inner, bytes32(value));
483     }
484 
485     /**
486      * @dev Removes a value from a set. O(1).
487      *
488      * Returns true if the value was removed from the set, that is if it was
489      * present.
490      */
491     function remove(UintSet storage set, uint256 value) internal returns (bool) {
492         return _remove(set._inner, bytes32(value));
493     }
494 
495     /**
496      * @dev Returns true if the value is in the set. O(1).
497      */
498     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
499         return _contains(set._inner, bytes32(value));
500     }
501 
502     /**
503      * @dev Returns the number of values on the set. O(1).
504      */
505     function length(UintSet storage set) internal view returns (uint256) {
506         return _length(set._inner);
507     }
508 
509    /**
510     * @dev Returns the value stored at position `index` in the set. O(1).
511     *
512     * Note that there are no guarantees on the ordering of values inside the
513     * array, and it may change when more values are added or removed.
514     *
515     * Requirements:
516     *
517     * - `index` must be strictly less than {length}.
518     */
519     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
520         return uint256(_at(set._inner, index));
521     }
522 }
523 
524 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/utils/Address.sol
525 
526 
527 
528 pragma solidity ^0.6.2;
529 
530 /**
531  * @dev Collection of functions related to the address type
532  */
533 library Address {
534     /**
535      * @dev Returns true if `account` is a contract.
536      *
537      * [IMPORTANT]
538      * ====
539      * It is unsafe to assume that an address for which this function returns
540      * false is an externally-owned account (EOA) and not a contract.
541      *
542      * Among others, `isContract` will return false for the following
543      * types of addresses:
544      *
545      *  - an externally-owned account
546      *  - a contract in construction
547      *  - an address where a contract will be created
548      *  - an address where a contract lived, but was destroyed
549      * ====
550      */
551     function isContract(address account) internal view returns (bool) {
552         // This method relies in extcodesize, which returns 0 for contracts in
553         // construction, since the code is only stored at the end of the
554         // constructor execution.
555 
556         uint256 size;
557         // solhint-disable-next-line no-inline-assembly
558         assembly { size := extcodesize(account) }
559         return size > 0;
560     }
561 
562     /**
563      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
564      * `recipient`, forwarding all available gas and reverting on errors.
565      *
566      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
567      * of certain opcodes, possibly making contracts go over the 2300 gas limit
568      * imposed by `transfer`, making them unable to receive funds via
569      * `transfer`. {sendValue} removes this limitation.
570      *
571      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
572      *
573      * IMPORTANT: because control is transferred to `recipient`, care must be
574      * taken to not create reentrancy vulnerabilities. Consider using
575      * {ReentrancyGuard} or the
576      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
577      */
578     function sendValue(address payable recipient, uint256 amount) internal {
579         require(address(this).balance >= amount, "Address: insufficient balance");
580 
581         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
582         (bool success, ) = recipient.call{ value: amount }("");
583         require(success, "Address: unable to send value, recipient may have reverted");
584     }
585 
586     /**
587      * @dev Performs a Solidity function call using a low level `call`. A
588      * plain`call` is an unsafe replacement for a function call: use this
589      * function instead.
590      *
591      * If `target` reverts with a revert reason, it is bubbled up by this
592      * function (like regular Solidity function calls).
593      *
594      * Returns the raw returned data. To convert to the expected return value,
595      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
596      *
597      * Requirements:
598      *
599      * - `target` must be a contract.
600      * - calling `target` with `data` must not revert.
601      *
602      * _Available since v3.1._
603      */
604     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
605       return functionCall(target, data, "Address: low-level call failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
610      * `errorMessage` as a fallback revert reason when `target` reverts.
611      *
612      * _Available since v3.1._
613      */
614     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
615         return _functionCallWithValue(target, data, 0, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but also transferring `value` wei to `target`.
621      *
622      * Requirements:
623      *
624      * - the calling contract must have an ETH balance of at least `value`.
625      * - the called Solidity function must be `payable`.
626      *
627      * _Available since v3.1._
628      */
629     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
630         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
635      * with `errorMessage` as a fallback revert reason when `target` reverts.
636      *
637      * _Available since v3.1._
638      */
639     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
640         require(address(this).balance >= value, "Address: insufficient balance for call");
641         return _functionCallWithValue(target, data, value, errorMessage);
642     }
643 
644     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
645         require(isContract(target), "Address: call to non-contract");
646 
647         // solhint-disable-next-line avoid-low-level-calls
648         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
649         if (success) {
650             return returndata;
651         } else {
652             // Look for revert reason and bubble it up if present
653             if (returndata.length > 0) {
654                 // The easiest way to bubble the revert reason is using memory via assembly
655 
656                 // solhint-disable-next-line no-inline-assembly
657                 assembly {
658                     let returndata_size := mload(returndata)
659                     revert(add(32, returndata), returndata_size)
660                 }
661             } else {
662                 revert(errorMessage);
663             }
664         }
665     }
666 }
667 
668 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/math/SafeMath.sol
669 
670 
671 
672 pragma solidity ^0.6.0;
673 
674 /**
675  * @dev Wrappers over Solidity's arithmetic operations with added overflow
676  * checks.
677  *
678  * Arithmetic operations in Solidity wrap on overflow. This can easily result
679  * in bugs, because programmers usually assume that an overflow raises an
680  * error, which is the standard behavior in high level programming languages.
681  * `SafeMath` restores this intuition by reverting the transaction when an
682  * operation overflows.
683  *
684  * Using this library instead of the unchecked operations eliminates an entire
685  * class of bugs, so it's recommended to use it always.
686  */
687 library SafeMath {
688     /**
689      * @dev Returns the addition of two unsigned integers, reverting on
690      * overflow.
691      *
692      * Counterpart to Solidity's `+` operator.
693      *
694      * Requirements:
695      *
696      * - Addition cannot overflow.
697      */
698     function add(uint256 a, uint256 b) internal pure returns (uint256) {
699         uint256 c = a + b;
700         require(c >= a, "SafeMath: addition overflow");
701 
702         return c;
703     }
704 
705     /**
706      * @dev Returns the subtraction of two unsigned integers, reverting on
707      * overflow (when the result is negative).
708      *
709      * Counterpart to Solidity's `-` operator.
710      *
711      * Requirements:
712      *
713      * - Subtraction cannot overflow.
714      */
715     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
716         return sub(a, b, "SafeMath: subtraction overflow");
717     }
718 
719     /**
720      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
721      * overflow (when the result is negative).
722      *
723      * Counterpart to Solidity's `-` operator.
724      *
725      * Requirements:
726      *
727      * - Subtraction cannot overflow.
728      */
729     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
730         require(b <= a, errorMessage);
731         uint256 c = a - b;
732 
733         return c;
734     }
735 
736     /**
737      * @dev Returns the multiplication of two unsigned integers, reverting on
738      * overflow.
739      *
740      * Counterpart to Solidity's `*` operator.
741      *
742      * Requirements:
743      *
744      * - Multiplication cannot overflow.
745      */
746     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
747         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
748         // benefit is lost if 'b' is also tested.
749         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
750         if (a == 0) {
751             return 0;
752         }
753 
754         uint256 c = a * b;
755         require(c / a == b, "SafeMath: multiplication overflow");
756 
757         return c;
758     }
759 
760     /**
761      * @dev Returns the integer division of two unsigned integers. Reverts on
762      * division by zero. The result is rounded towards zero.
763      *
764      * Counterpart to Solidity's `/` operator. Note: this function uses a
765      * `revert` opcode (which leaves remaining gas untouched) while Solidity
766      * uses an invalid opcode to revert (consuming all remaining gas).
767      *
768      * Requirements:
769      *
770      * - The divisor cannot be zero.
771      */
772     function div(uint256 a, uint256 b) internal pure returns (uint256) {
773         return div(a, b, "SafeMath: division by zero");
774     }
775 
776     /**
777      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
778      * division by zero. The result is rounded towards zero.
779      *
780      * Counterpart to Solidity's `/` operator. Note: this function uses a
781      * `revert` opcode (which leaves remaining gas untouched) while Solidity
782      * uses an invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
789         require(b > 0, errorMessage);
790         uint256 c = a / b;
791         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
792 
793         return c;
794     }
795 
796     /**
797      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
798      * Reverts when dividing by zero.
799      *
800      * Counterpart to Solidity's `%` operator. This function uses a `revert`
801      * opcode (which leaves remaining gas untouched) while Solidity uses an
802      * invalid opcode to revert (consuming all remaining gas).
803      *
804      * Requirements:
805      *
806      * - The divisor cannot be zero.
807      */
808     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
809         return mod(a, b, "SafeMath: modulo by zero");
810     }
811 
812     /**
813      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
814      * Reverts with custom message when dividing by zero.
815      *
816      * Counterpart to Solidity's `%` operator. This function uses a `revert`
817      * opcode (which leaves remaining gas untouched) while Solidity uses an
818      * invalid opcode to revert (consuming all remaining gas).
819      *
820      * Requirements:
821      *
822      * - The divisor cannot be zero.
823      */
824     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
825         require(b != 0, errorMessage);
826         return a % b;
827     }
828 }
829 
830 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/utils/Counters.sol
831 
832 
833 
834 pragma solidity ^0.6.0;
835 
836 
837 /**
838  * @title Counters
839  * @author Matt Condon (@shrugs)
840  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
841  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
842  *
843  * Include with `using Counters for Counters.Counter;`
844  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
845  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
846  * directly accessed.
847  */
848 library Counters {
849     using SafeMath for uint256;
850 
851     struct Counter {
852         // This variable should never be directly accessed by users of the library: interactions must be restricted to
853         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
854         // this feature: see https://github.com/ethereum/solidity/issues/4637
855         uint256 _value; // default: 0
856     }
857 
858     function current(Counter storage counter) internal view returns (uint256) {
859         return counter._value;
860     }
861 
862     function increment(Counter storage counter) internal {
863         // The {SafeMath} overflow check can be skipped here, see the comment at the top
864         counter._value += 1;
865     }
866 
867     function decrement(Counter storage counter) internal {
868         counter._value = counter._value.sub(1);
869     }
870 }
871 
872 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/token/ERC721/IERC721Receiver.sol
873 
874 
875 
876 pragma solidity ^0.6.0;
877 
878 /**
879  * @title ERC721 token receiver interface
880  * @dev Interface for any contract that wants to support safeTransfers
881  * from ERC721 asset contracts.
882  */
883 interface IERC721Receiver {
884     /**
885      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
886      * by `operator` from `from`, this function is called.
887      *
888      * It must return its Solidity selector to confirm the token transfer.
889      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
890      *
891      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
892      */
893     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
894     external returns (bytes4);
895 }
896 
897 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/introspection/IERC165.sol
898 
899 
900 
901 pragma solidity ^0.6.0;
902 
903 /**
904  * @dev Interface of the ERC165 standard, as defined in the
905  * https://eips.ethereum.org/EIPS/eip-165[EIP].
906  *
907  * Implementers can declare support of contract interfaces, which can then be
908  * queried by others ({ERC165Checker}).
909  *
910  * For an implementation, see {ERC165}.
911  */
912 interface IERC165 {
913     /**
914      * @dev Returns true if this contract implements the interface defined by
915      * `interfaceId`. See the corresponding
916      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
917      * to learn more about how these ids are created.
918      *
919      * This function call must use less than 30 000 gas.
920      */
921     function supportsInterface(bytes4 interfaceId) external view returns (bool);
922 }
923 
924 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/introspection/ERC165.sol
925 
926 
927 
928 pragma solidity ^0.6.0;
929 
930 
931 /**
932  * @dev Implementation of the {IERC165} interface.
933  *
934  * Contracts may inherit from this and call {_registerInterface} to declare
935  * their support of an interface.
936  */
937 contract ERC165 is IERC165 {
938     /*
939      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
940      */
941     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
942 
943     /**
944      * @dev Mapping of interface ids to whether or not it's supported.
945      */
946     mapping(bytes4 => bool) private _supportedInterfaces;
947 
948     constructor () internal {
949         // Derived contracts need only register support for their own interfaces,
950         // we register support for ERC165 itself here
951         _registerInterface(_INTERFACE_ID_ERC165);
952     }
953 
954     /**
955      * @dev See {IERC165-supportsInterface}.
956      *
957      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
958      */
959     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
960         return _supportedInterfaces[interfaceId];
961     }
962 
963     /**
964      * @dev Registers the contract as an implementer of the interface defined by
965      * `interfaceId`. Support of the actual ERC165 interface is automatic and
966      * registering its interface id is not required.
967      *
968      * See {IERC165-supportsInterface}.
969      *
970      * Requirements:
971      *
972      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
973      */
974     function _registerInterface(bytes4 interfaceId) internal virtual {
975         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
976         _supportedInterfaces[interfaceId] = true;
977     }
978 }
979 
980 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/token/ERC721/IERC721.sol
981 
982 
983 
984 pragma solidity ^0.6.2;
985 
986 
987 /**
988  * @dev Required interface of an ERC721 compliant contract.
989  */
990 interface IERC721 is IERC165 {
991     /**
992      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
993      */
994     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
995 
996     /**
997      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
998      */
999     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1000 
1001     /**
1002      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1003      */
1004     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1005 
1006     /**
1007      * @dev Returns the number of tokens in ``owner``'s account.
1008      */
1009     function balanceOf(address owner) external view returns (uint256 balance);
1010 
1011     /**
1012      * @dev Returns the owner of the `tokenId` token.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      */
1018     function ownerOf(uint256 tokenId) external view returns (address owner);
1019 
1020     /**
1021      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1022      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1023      *
1024      * Requirements:
1025      *
1026      * - `from` cannot be the zero address.
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must exist and be owned by `from`.
1029      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1030      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1035 
1036     /**
1037      * @dev Transfers `tokenId` token from `from` to `to`.
1038      *
1039      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1040      *
1041      * Requirements:
1042      *
1043      * - `from` cannot be the zero address.
1044      * - `to` cannot be the zero address.
1045      * - `tokenId` token must be owned by `from`.
1046      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function transferFrom(address from, address to, uint256 tokenId) external;
1051 
1052     /**
1053      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1054      * The approval is cleared when the token is transferred.
1055      *
1056      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1057      *
1058      * Requirements:
1059      *
1060      * - The caller must own the token or be an approved operator.
1061      * - `tokenId` must exist.
1062      *
1063      * Emits an {Approval} event.
1064      */
1065     function approve(address to, uint256 tokenId) external;
1066 
1067     /**
1068      * @dev Returns the account approved for `tokenId` token.
1069      *
1070      * Requirements:
1071      *
1072      * - `tokenId` must exist.
1073      */
1074     function getApproved(uint256 tokenId) external view returns (address operator);
1075 
1076     /**
1077      * @dev Approve or remove `operator` as an operator for the caller.
1078      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1079      *
1080      * Requirements:
1081      *
1082      * - The `operator` cannot be the caller.
1083      *
1084      * Emits an {ApprovalForAll} event.
1085      */
1086     function setApprovalForAll(address operator, bool _approved) external;
1087 
1088     /**
1089      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1090      *
1091      * See {setApprovalForAll}
1092      */
1093     function isApprovedForAll(address owner, address operator) external view returns (bool);
1094 
1095     /**
1096       * @dev Safely transfers `tokenId` token from `from` to `to`.
1097       *
1098       * Requirements:
1099       *
1100      * - `from` cannot be the zero address.
1101      * - `to` cannot be the zero address.
1102       * - `tokenId` token must exist and be owned by `from`.
1103       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1104       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1105       *
1106       * Emits a {Transfer} event.
1107       */
1108     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1109 }
1110 
1111 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/token/ERC721/IERC721Enumerable.sol
1112 
1113 
1114 
1115 pragma solidity ^0.6.2;
1116 
1117 
1118 /**
1119  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1120  * @dev See https://eips.ethereum.org/EIPS/eip-721
1121  */
1122 interface IERC721Enumerable is IERC721 {
1123 
1124     /**
1125      * @dev Returns the total amount of tokens stored by the contract.
1126      */
1127     function totalSupply() external view returns (uint256);
1128 
1129     /**
1130      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1131      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1132      */
1133     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1134 
1135     /**
1136      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1137      * Use along with {totalSupply} to enumerate all tokens.
1138      */
1139     function tokenByIndex(uint256 index) external view returns (uint256);
1140 }
1141 
1142 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/token/ERC721/IERC721Metadata.sol
1143 
1144 
1145 
1146 pragma solidity ^0.6.2;
1147 
1148 
1149 /**
1150  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1151  * @dev See https://eips.ethereum.org/EIPS/eip-721
1152  */
1153 interface IERC721Metadata is IERC721 {
1154 
1155     /**
1156      * @dev Returns the token collection name.
1157      */
1158     function name() external view returns (string memory);
1159 
1160     /**
1161      * @dev Returns the token collection symbol.
1162      */
1163     function symbol() external view returns (string memory);
1164 
1165     /**
1166      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1167      */
1168     function tokenURI(uint256 tokenId) external view returns (string memory);
1169 }
1170 
1171 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/GSN/Context.sol
1172 
1173 
1174 
1175 pragma solidity ^0.6.0;
1176 
1177 /*
1178  * @dev Provides information about the current execution context, including the
1179  * sender of the transaction and its data. While these are generally available
1180  * via msg.sender and msg.data, they should not be accessed in such a direct
1181  * manner, since when dealing with GSN meta-transactions the account sending and
1182  * paying for execution may not be the actual sender (as far as an application
1183  * is concerned).
1184  *
1185  * This contract is only required for intermediate, library-like contracts.
1186  */
1187 abstract contract Context {
1188     function _msgSender() internal view virtual returns (address payable) {
1189         return msg.sender;
1190     }
1191 
1192     function _msgData() internal view virtual returns (bytes memory) {
1193         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1194         return msg.data;
1195     }
1196 }
1197 
1198 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/access/Ownable.sol
1199 
1200 
1201 
1202 pragma solidity ^0.6.0;
1203 
1204 /**
1205  * @dev Contract module which provides a basic access control mechanism, where
1206  * there is an account (an owner) that can be granted exclusive access to
1207  * specific functions.
1208  *
1209  * By default, the owner account will be the one that deploys the contract. This
1210  * can later be changed with {transferOwnership}.
1211  *
1212  * This module is used through inheritance. It will make available the modifier
1213  * `onlyOwner`, which can be applied to your functions to restrict their use to
1214  * the owner.
1215  */
1216 contract Ownable is Context {
1217     address private _owner;
1218 
1219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1220 
1221     /**
1222      * @dev Initializes the contract setting the deployer as the initial owner.
1223      */
1224     constructor () internal {
1225         address msgSender = _msgSender();
1226         _owner = msgSender;
1227         emit OwnershipTransferred(address(0), msgSender);
1228     }
1229 
1230     /**
1231      * @dev Returns the address of the current owner.
1232      */
1233     function owner() public view returns (address) {
1234         return _owner;
1235     }
1236 
1237     /**
1238      * @dev Throws if called by any account other than the owner.
1239      */
1240     modifier onlyOwner() {
1241         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1242         _;
1243     }
1244 
1245     /**
1246      * @dev Leaves the contract without owner. It will not be possible to call
1247      * `onlyOwner` functions anymore. Can only be called by the current owner.
1248      *
1249      * NOTE: Renouncing ownership will leave the contract without an owner,
1250      * thereby removing any functionality that is only available to the owner.
1251      */
1252     function renounceOwnership() public virtual onlyOwner {
1253         emit OwnershipTransferred(_owner, address(0));
1254         _owner = address(0);
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Can only be called by the current owner.
1260      */
1261     function transferOwnership(address newOwner) public virtual onlyOwner {
1262         require(newOwner != address(0), "Ownable: new owner is the zero address");
1263         emit OwnershipTransferred(_owner, newOwner);
1264         _owner = newOwner;
1265     }
1266 }
1267 
1268 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0/contracts/token/ERC721/ERC721.sol
1269 
1270 
1271 
1272 pragma solidity ^0.6.0;
1273 
1274 
1275 
1276 
1277 
1278 
1279 
1280 
1281 
1282 
1283 
1284 
1285 /**
1286  * @title ERC721 Non-Fungible Token Standard basic implementation
1287  * @dev see https://eips.ethereum.org/EIPS/eip-721
1288  */
1289 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1290     using SafeMath for uint256;
1291     using Address for address;
1292     using EnumerableSet for EnumerableSet.UintSet;
1293     using EnumerableMap for EnumerableMap.UintToAddressMap;
1294     using Strings for uint256;
1295 
1296     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1297     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1298     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1299 
1300     // Mapping from holder address to their (enumerable) set of owned tokens
1301     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1302 
1303     // Enumerable mapping from token ids to their owners
1304     EnumerableMap.UintToAddressMap private _tokenOwners;
1305 
1306     // Mapping from token ID to approved address
1307     mapping (uint256 => address) private _tokenApprovals;
1308 
1309     // Mapping from owner to operator approvals
1310     mapping (address => mapping (address => bool)) private _operatorApprovals;
1311 
1312     // Token name
1313     string private _name;
1314 
1315     // Token symbol
1316     string private _symbol;
1317 
1318     // Optional mapping for token URIs
1319     mapping (uint256 => string) private _tokenURIs;
1320 
1321     // Base URI
1322     string private _baseURI;
1323 
1324     /*
1325      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1326      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1327      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1328      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1329      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1330      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1331      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1332      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1333      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1334      *
1335      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1336      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1337      */
1338     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1339 
1340     /*
1341      *     bytes4(keccak256('name()')) == 0x06fdde03
1342      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1343      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1344      *
1345      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1346      */
1347     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1348 
1349     /*
1350      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1351      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1352      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1353      *
1354      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1355      */
1356     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1357 
1358     /**
1359      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1360      */
1361     constructor (string memory name, string memory symbol) public {
1362         _name = name;
1363         _symbol = symbol;
1364 
1365         // register the supported interfaces to conform to ERC721 via ERC165
1366         _registerInterface(_INTERFACE_ID_ERC721);
1367         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1368         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-balanceOf}.
1373      */
1374     function balanceOf(address owner) public view override returns (uint256) {
1375         require(owner != address(0), "ERC721: balance query for the zero address");
1376 
1377         return _holderTokens[owner].length();
1378     }
1379 
1380     /**
1381      * @dev See {IERC721-ownerOf}.
1382      */
1383     function ownerOf(uint256 tokenId) public view override returns (address) {
1384         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1385     }
1386 
1387     /**
1388      * @dev See {IERC721Metadata-name}.
1389      */
1390     function name() public view override returns (string memory) {
1391         return _name;
1392     }
1393 
1394     /**
1395      * @dev See {IERC721Metadata-symbol}.
1396      */
1397     function symbol() public view override returns (string memory) {
1398         return _symbol;
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Metadata-tokenURI}.
1403      */
1404     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1405         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1406 
1407         string memory _tokenURI = _tokenURIs[tokenId];
1408 
1409         // If there is no base URI, return the token URI.
1410         if (bytes(_baseURI).length == 0) {
1411             return _tokenURI;
1412         }
1413         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1414         if (bytes(_tokenURI).length > 0) {
1415             return string(abi.encodePacked(_baseURI, _tokenURI));
1416         }
1417         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1418         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1419     }
1420 
1421     /**
1422     * @dev Returns the base URI set via {_setBaseURI}. This will be
1423     * automatically added as a prefix in {tokenURI} to each token's URI, or
1424     * to the token ID if no specific URI is set for that token ID.
1425     */
1426     function baseURI() public view returns (string memory) {
1427         return _baseURI;
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1432      */
1433     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1434         return _holderTokens[owner].at(index);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721Enumerable-totalSupply}.
1439      */
1440     function totalSupply() public view override returns (uint256) {
1441         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1442         return _tokenOwners.length();
1443     }
1444 
1445     /**
1446      * @dev See {IERC721Enumerable-tokenByIndex}.
1447      */
1448     function tokenByIndex(uint256 index) public view override returns (uint256) {
1449         (uint256 tokenId, ) = _tokenOwners.at(index);
1450         return tokenId;
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-approve}.
1455      */
1456     function approve(address to, uint256 tokenId) public virtual override {
1457         address owner = ownerOf(tokenId);
1458         require(to != owner, "ERC721: approval to current owner");
1459 
1460         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1461             "ERC721: approve caller is not owner nor approved for all"
1462         );
1463 
1464         _approve(to, tokenId);
1465     }
1466 
1467     /**
1468      * @dev See {IERC721-getApproved}.
1469      */
1470     function getApproved(uint256 tokenId) public view override returns (address) {
1471         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1472 
1473         return _tokenApprovals[tokenId];
1474     }
1475 
1476     /**
1477      * @dev See {IERC721-setApprovalForAll}.
1478      */
1479     function setApprovalForAll(address operator, bool approved) public virtual override {
1480         require(operator != _msgSender(), "ERC721: approve to caller");
1481 
1482         _operatorApprovals[_msgSender()][operator] = approved;
1483         emit ApprovalForAll(_msgSender(), operator, approved);
1484     }
1485 
1486     /**
1487      * @dev See {IERC721-isApprovedForAll}.
1488      */
1489     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1490         return _operatorApprovals[owner][operator];
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-transferFrom}.
1495      */
1496     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1497         //solhint-disable-next-line max-line-length
1498         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1499 
1500         _transfer(from, to, tokenId);
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-safeTransferFrom}.
1505      */
1506     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1507         safeTransferFrom(from, to, tokenId, "");
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-safeTransferFrom}.
1512      */
1513     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1514         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1515         _safeTransfer(from, to, tokenId, _data);
1516     }
1517 
1518     /**
1519      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1520      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1521      *
1522      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1523      *
1524      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1525      * implement alternative mechanisms to perform token transfer, such as signature-based.
1526      *
1527      * Requirements:
1528      *
1529      * - `from` cannot be the zero address.
1530      * - `to` cannot be the zero address.
1531      * - `tokenId` token must exist and be owned by `from`.
1532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1537         _transfer(from, to, tokenId);
1538         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1539     }
1540 
1541     /**
1542      * @dev Returns whether `tokenId` exists.
1543      *
1544      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1545      *
1546      * Tokens start existing when they are minted (`_mint`),
1547      * and stop existing when they are burned (`_burn`).
1548      */
1549     function _exists(uint256 tokenId) internal view returns (bool) {
1550         return _tokenOwners.contains(tokenId);
1551     }
1552 
1553     /**
1554      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1555      *
1556      * Requirements:
1557      *
1558      * - `tokenId` must exist.
1559      */
1560     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1561         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1562         address owner = ownerOf(tokenId);
1563         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1564     }
1565 
1566     /**
1567      * @dev Safely mints `tokenId` and transfers it to `to`.
1568      *
1569      * Requirements:
1570      d*
1571      * - `tokenId` must not exist.
1572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _safeMint(address to, uint256 tokenId) internal virtual {
1577         _safeMint(to, tokenId, "");
1578     }
1579 
1580     /**
1581      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1582      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1583      */
1584     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1585         _mint(to, tokenId);
1586         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1587     }
1588 
1589     /**
1590      * @dev Mints `tokenId` and transfers it to `to`.
1591      *
1592      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1593      *
1594      * Requirements:
1595      *
1596      * - `tokenId` must not exist.
1597      * - `to` cannot be the zero address.
1598      *
1599      * Emits a {Transfer} event.
1600      */
1601     function _mint(address to, uint256 tokenId) internal virtual {
1602         require(to != address(0), "ERC721: mint to the zero address");
1603         require(!_exists(tokenId), "ERC721: token already minted");
1604 
1605         _beforeTokenTransfer(address(0), to, tokenId);
1606 
1607         _holderTokens[to].add(tokenId);
1608 
1609         _tokenOwners.set(tokenId, to);
1610 
1611         emit Transfer(address(0), to, tokenId);
1612     }
1613 
1614     /**
1615      * @dev Destroys `tokenId`.
1616      * The approval is cleared when the token is burned.
1617      *
1618      * Requirements:
1619      *
1620      * - `tokenId` must exist.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _burn(uint256 tokenId) internal virtual {
1625         address owner = ownerOf(tokenId);
1626 
1627         _beforeTokenTransfer(owner, address(0), tokenId);
1628 
1629         // Clear approvals
1630         _approve(address(0), tokenId);
1631 
1632         // Clear metadata (if any)
1633         if (bytes(_tokenURIs[tokenId]).length != 0) {
1634             delete _tokenURIs[tokenId];
1635         }
1636 
1637         _holderTokens[owner].remove(tokenId);
1638 
1639         _tokenOwners.remove(tokenId);
1640 
1641         emit Transfer(owner, address(0), tokenId);
1642     }
1643 
1644     /**
1645      * @dev Transfers `tokenId` from `from` to `to`.
1646      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1647      *
1648      * Requirements:
1649      *
1650      * - `to` cannot be the zero address.
1651      * - `tokenId` token must be owned by `from`.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1656         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1657         require(to != address(0), "ERC721: transfer to the zero address");
1658 
1659         _beforeTokenTransfer(from, to, tokenId);
1660 
1661         // Clear approvals from the previous owner
1662         _approve(address(0), tokenId);
1663 
1664         _holderTokens[from].remove(tokenId);
1665         _holderTokens[to].add(tokenId);
1666 
1667         _tokenOwners.set(tokenId, to);
1668 
1669         emit Transfer(from, to, tokenId);
1670     }
1671 
1672     /**
1673      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1674      *
1675      * Requirements:
1676      *
1677      * - `tokenId` must exist.
1678      */
1679     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1680         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1681         _tokenURIs[tokenId] = _tokenURI;
1682     }
1683 
1684     /**
1685      * @dev Internal function to set the base URI for all token IDs. It is
1686      * automatically added as a prefix to the value returned in {tokenURI},
1687      * or to the token ID if {tokenURI} is empty.
1688      */
1689     function _setBaseURI(string memory baseURI_) internal virtual {
1690         _baseURI = baseURI_;
1691     }
1692 
1693     /**
1694      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1695      * The call is not executed if the target address is not a contract.
1696      *
1697      * @param from address representing the previous owner of the given token ID
1698      * @param to target address that will receive the tokens
1699      * @param tokenId uint256 ID of the token to be transferred
1700      * @param _data bytes optional data to send along with the call
1701      * @return bool whether the call correctly returned the expected magic value
1702      */
1703     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1704         private returns (bool)
1705     {
1706         if (!to.isContract()) {
1707             return true;
1708         }
1709         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1710             IERC721Receiver(to).onERC721Received.selector,
1711             _msgSender(),
1712             from,
1713             tokenId,
1714             _data
1715         ), "ERC721: transfer to non ERC721Receiver implementer");
1716         bytes4 retval = abi.decode(returndata, (bytes4));
1717         return (retval == _ERC721_RECEIVED);
1718     }
1719 
1720     function _approve(address to, uint256 tokenId) private {
1721         _tokenApprovals[tokenId] = to;
1722         emit Approval(ownerOf(tokenId), to, tokenId);
1723     }
1724 
1725     /**
1726      * @dev Hook that is called before any token transfer. This includes minting
1727      * and burning.
1728      *
1729      * Calling conditions:
1730      *
1731      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1732      * transferred to `to`.
1733      * - When `from` is zero, `tokenId` will be minted for `to`.
1734      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1735      * - `from` cannot be the zero address.
1736      * - `to` cannot be the zero address.
1737      *
1738      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1739      */
1740     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1741 }
1742 
1743 // File: WatchSkin.sol
1744 
1745 
1746 
1747 pragma solidity ^0.6.2;
1748 
1749 
1750 
1751 
1752 contract WatchSkins is Ownable, ERC721 {
1753     using Counters for Counters.Counter;
1754     Counters.Counter public _tokenIds;
1755 
1756     event BaseURIChange(string baseURI);
1757 
1758     constructor () public ERC721("WATCH SKINS", "SKINS")
1759     {
1760         setBaseURI("https://ipfs.io/ipfs/");   // Eg: https://ipfs.io/ipfs/
1761     }
1762 
1763     /**
1764      * @dev Sets the base URI for the registry metadata
1765      * @param holder Address for the holder
1766      * @param tokenURI url for the skin
1767      */
1768     function createItem(address holder, string memory tokenURI)
1769         public
1770         returns (uint256)
1771     {
1772         _tokenIds.increment();
1773         uint256 newItemId = _tokenIds.current();
1774         _mint(holder, newItemId);
1775         _setTokenURI(newItemId, tokenURI);
1776 
1777         return newItemId;
1778     }
1779 
1780     /**
1781      * @dev Sets the base URI for the skin metadata
1782      * @param _baseUri baseURL for the skin metadata
1783      */
1784     function setBaseURI(string memory _baseUri) public onlyOwner {
1785         _setBaseURI(_baseUri);
1786         emit BaseURIChange(_baseUri);
1787     }
1788 }