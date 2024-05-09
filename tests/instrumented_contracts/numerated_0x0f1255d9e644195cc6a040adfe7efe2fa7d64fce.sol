1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.6;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Context
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with GSN meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address payable) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes memory) {
213         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
214         return msg.data;
215     }
216 }
217 
218 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/EnumerableMap
219 
220 /**
221  * @dev Library for managing an enumerable variant of Solidity's
222  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
223  * type.
224  *
225  * Maps have the following properties:
226  *
227  * - Entries are added, removed, and checked for existence in constant time
228  * (O(1)).
229  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
230  *
231  * ```
232  * contract Example {
233  *     // Add the library methods
234  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
235  *
236  *     // Declare a set state variable
237  *     EnumerableMap.UintToAddressMap private myMap;
238  * }
239  * ```
240  *
241  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
242  * supported.
243  */
244 library EnumerableMap {
245     // To implement this library for multiple types with as little code
246     // repetition as possible, we write it in terms of a generic Map type with
247     // bytes32 keys and values.
248     // The Map implementation uses private functions, and user-facing
249     // implementations (such as Uint256ToAddressMap) are just wrappers around
250     // the underlying Map.
251     // This means that we can only create new EnumerableMaps for types that fit
252     // in bytes32.
253 
254     struct MapEntry {
255         bytes32 _key;
256         bytes32 _value;
257     }
258 
259     struct Map {
260         // Storage of map keys and values
261         MapEntry[] _entries;
262 
263         // Position of the entry defined by a key in the `entries` array, plus 1
264         // because index 0 means a key is not in the map.
265         mapping (bytes32 => uint256) _indexes;
266     }
267 
268     /**
269      * @dev Adds a key-value pair to a map, or updates the value for an existing
270      * key. O(1).
271      *
272      * Returns true if the key was added to the map, that is if it was not
273      * already present.
274      */
275     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
276         // We read and store the key's index to prevent multiple reads from the same storage slot
277         uint256 keyIndex = map._indexes[key];
278 
279         if (keyIndex == 0) { // Equivalent to !contains(map, key)
280             map._entries.push(MapEntry({ _key: key, _value: value }));
281             // The entry is stored at length-1, but we add 1 to all indexes
282             // and use 0 as a sentinel value
283             map._indexes[key] = map._entries.length;
284             return true;
285         } else {
286             map._entries[keyIndex - 1]._value = value;
287             return false;
288         }
289     }
290 
291     /**
292      * @dev Removes a key-value pair from a map. O(1).
293      *
294      * Returns true if the key was removed from the map, that is if it was present.
295      */
296     function _remove(Map storage map, bytes32 key) private returns (bool) {
297         // We read and store the key's index to prevent multiple reads from the same storage slot
298         uint256 keyIndex = map._indexes[key];
299 
300         if (keyIndex != 0) { // Equivalent to contains(map, key)
301             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
302             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
303             // This modifies the order of the array, as noted in {at}.
304 
305             uint256 toDeleteIndex = keyIndex - 1;
306             uint256 lastIndex = map._entries.length - 1;
307 
308             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
309             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
310 
311             MapEntry storage lastEntry = map._entries[lastIndex];
312 
313             // Move the last entry to the index where the entry to delete is
314             map._entries[toDeleteIndex] = lastEntry;
315             // Update the index for the moved entry
316             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
317 
318             // Delete the slot where the moved entry was stored
319             map._entries.pop();
320 
321             // Delete the index for the deleted slot
322             delete map._indexes[key];
323 
324             return true;
325         } else {
326             return false;
327         }
328     }
329 
330     /**
331      * @dev Returns true if the key is in the map. O(1).
332      */
333     function _contains(Map storage map, bytes32 key) private view returns (bool) {
334         return map._indexes[key] != 0;
335     }
336 
337     /**
338      * @dev Returns the number of key-value pairs in the map. O(1).
339      */
340     function _length(Map storage map) private view returns (uint256) {
341         return map._entries.length;
342     }
343 
344    /**
345     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
346     *
347     * Note that there are no guarantees on the ordering of entries inside the
348     * array, and it may change when more entries are added or removed.
349     *
350     * Requirements:
351     *
352     * - `index` must be strictly less than {length}.
353     */
354     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
355         require(map._entries.length > index, "EnumerableMap: index out of bounds");
356 
357         MapEntry storage entry = map._entries[index];
358         return (entry._key, entry._value);
359     }
360 
361     /**
362      * @dev Tries to returns the value associated with `key`.  O(1).
363      * Does not revert if `key` is not in the map.
364      */
365     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
366         uint256 keyIndex = map._indexes[key];
367         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
368         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
369     }
370 
371     /**
372      * @dev Returns the value associated with `key`.  O(1).
373      *
374      * Requirements:
375      *
376      * - `key` must be in the map.
377      */
378     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
379         uint256 keyIndex = map._indexes[key];
380         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
381         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
382     }
383 
384     /**
385      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
386      *
387      * CAUTION: This function is deprecated because it requires allocating memory for the error
388      * message unnecessarily. For custom revert reasons use {_tryGet}.
389      */
390     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
391         uint256 keyIndex = map._indexes[key];
392         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
393         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
394     }
395 
396     // UintToAddressMap
397 
398     struct UintToAddressMap {
399         Map _inner;
400     }
401 
402     /**
403      * @dev Adds a key-value pair to a map, or updates the value for an existing
404      * key. O(1).
405      *
406      * Returns true if the key was added to the map, that is if it was not
407      * already present.
408      */
409     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
410         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
411     }
412 
413     /**
414      * @dev Removes a value from a set. O(1).
415      *
416      * Returns true if the key was removed from the map, that is if it was present.
417      */
418     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
419         return _remove(map._inner, bytes32(key));
420     }
421 
422     /**
423      * @dev Returns true if the key is in the map. O(1).
424      */
425     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
426         return _contains(map._inner, bytes32(key));
427     }
428 
429     /**
430      * @dev Returns the number of elements in the map. O(1).
431      */
432     function length(UintToAddressMap storage map) internal view returns (uint256) {
433         return _length(map._inner);
434     }
435 
436    /**
437     * @dev Returns the element stored at position `index` in the set. O(1).
438     * Note that there are no guarantees on the ordering of values inside the
439     * array, and it may change when more values are added or removed.
440     *
441     * Requirements:
442     *
443     * - `index` must be strictly less than {length}.
444     */
445     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
446         (bytes32 key, bytes32 value) = _at(map._inner, index);
447         return (uint256(key), address(uint160(uint256(value))));
448     }
449 
450     /**
451      * @dev Tries to returns the value associated with `key`.  O(1).
452      * Does not revert if `key` is not in the map.
453      *
454      * _Available since v3.4._
455      */
456     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
457         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
458         return (success, address(uint160(uint256(value))));
459     }
460 
461     /**
462      * @dev Returns the value associated with `key`.  O(1).
463      *
464      * Requirements:
465      *
466      * - `key` must be in the map.
467      */
468     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
469         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
470     }
471 
472     /**
473      * @dev Same as {get}, with a custom error message when `key` is not in the map.
474      *
475      * CAUTION: This function is deprecated because it requires allocating memory for the error
476      * message unnecessarily. For custom revert reasons use {tryGet}.
477      */
478     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
479         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
480     }
481 }
482 
483 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/EnumerableSet
484 
485 /**
486  * @dev Library for managing
487  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
488  * types.
489  *
490  * Sets have the following properties:
491  *
492  * - Elements are added, removed, and checked for existence in constant time
493  * (O(1)).
494  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
495  *
496  * ```
497  * contract Example {
498  *     // Add the library methods
499  *     using EnumerableSet for EnumerableSet.AddressSet;
500  *
501  *     // Declare a set state variable
502  *     EnumerableSet.AddressSet private mySet;
503  * }
504  * ```
505  *
506  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
507  * and `uint256` (`UintSet`) are supported.
508  */
509 library EnumerableSet {
510     // To implement this library for multiple types with as little code
511     // repetition as possible, we write it in terms of a generic Set type with
512     // bytes32 values.
513     // The Set implementation uses private functions, and user-facing
514     // implementations (such as AddressSet) are just wrappers around the
515     // underlying Set.
516     // This means that we can only create new EnumerableSets for types that fit
517     // in bytes32.
518 
519     struct Set {
520         // Storage of set values
521         bytes32[] _values;
522 
523         // Position of the value in the `values` array, plus 1 because index 0
524         // means a value is not in the set.
525         mapping (bytes32 => uint256) _indexes;
526     }
527 
528     /**
529      * @dev Add a value to a set. O(1).
530      *
531      * Returns true if the value was added to the set, that is if it was not
532      * already present.
533      */
534     function _add(Set storage set, bytes32 value) private returns (bool) {
535         if (!_contains(set, value)) {
536             set._values.push(value);
537             // The value is stored at length-1, but we add 1 to all indexes
538             // and use 0 as a sentinel value
539             set._indexes[value] = set._values.length;
540             return true;
541         } else {
542             return false;
543         }
544     }
545 
546     /**
547      * @dev Removes a value from a set. O(1).
548      *
549      * Returns true if the value was removed from the set, that is if it was
550      * present.
551      */
552     function _remove(Set storage set, bytes32 value) private returns (bool) {
553         // We read and store the value's index to prevent multiple reads from the same storage slot
554         uint256 valueIndex = set._indexes[value];
555 
556         if (valueIndex != 0) { // Equivalent to contains(set, value)
557             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
558             // the array, and then remove the last element (sometimes called as 'swap and pop').
559             // This modifies the order of the array, as noted in {at}.
560 
561             uint256 toDeleteIndex = valueIndex - 1;
562             uint256 lastIndex = set._values.length - 1;
563 
564             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
565             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
566 
567             bytes32 lastvalue = set._values[lastIndex];
568 
569             // Move the last value to the index where the value to delete is
570             set._values[toDeleteIndex] = lastvalue;
571             // Update the index for the moved value
572             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
573 
574             // Delete the slot where the moved value was stored
575             set._values.pop();
576 
577             // Delete the index for the deleted slot
578             delete set._indexes[value];
579 
580             return true;
581         } else {
582             return false;
583         }
584     }
585 
586     /**
587      * @dev Returns true if the value is in the set. O(1).
588      */
589     function _contains(Set storage set, bytes32 value) private view returns (bool) {
590         return set._indexes[value] != 0;
591     }
592 
593     /**
594      * @dev Returns the number of values on the set. O(1).
595      */
596     function _length(Set storage set) private view returns (uint256) {
597         return set._values.length;
598     }
599 
600    /**
601     * @dev Returns the value stored at position `index` in the set. O(1).
602     *
603     * Note that there are no guarantees on the ordering of values inside the
604     * array, and it may change when more values are added or removed.
605     *
606     * Requirements:
607     *
608     * - `index` must be strictly less than {length}.
609     */
610     function _at(Set storage set, uint256 index) private view returns (bytes32) {
611         require(set._values.length > index, "EnumerableSet: index out of bounds");
612         return set._values[index];
613     }
614 
615     // Bytes32Set
616 
617     struct Bytes32Set {
618         Set _inner;
619     }
620 
621     /**
622      * @dev Add a value to a set. O(1).
623      *
624      * Returns true if the value was added to the set, that is if it was not
625      * already present.
626      */
627     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
628         return _add(set._inner, value);
629     }
630 
631     /**
632      * @dev Removes a value from a set. O(1).
633      *
634      * Returns true if the value was removed from the set, that is if it was
635      * present.
636      */
637     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
638         return _remove(set._inner, value);
639     }
640 
641     /**
642      * @dev Returns true if the value is in the set. O(1).
643      */
644     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
645         return _contains(set._inner, value);
646     }
647 
648     /**
649      * @dev Returns the number of values in the set. O(1).
650      */
651     function length(Bytes32Set storage set) internal view returns (uint256) {
652         return _length(set._inner);
653     }
654 
655    /**
656     * @dev Returns the value stored at position `index` in the set. O(1).
657     *
658     * Note that there are no guarantees on the ordering of values inside the
659     * array, and it may change when more values are added or removed.
660     *
661     * Requirements:
662     *
663     * - `index` must be strictly less than {length}.
664     */
665     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
666         return _at(set._inner, index);
667     }
668 
669     // AddressSet
670 
671     struct AddressSet {
672         Set _inner;
673     }
674 
675     /**
676      * @dev Add a value to a set. O(1).
677      *
678      * Returns true if the value was added to the set, that is if it was not
679      * already present.
680      */
681     function add(AddressSet storage set, address value) internal returns (bool) {
682         return _add(set._inner, bytes32(uint256(uint160(value))));
683     }
684 
685     /**
686      * @dev Removes a value from a set. O(1).
687      *
688      * Returns true if the value was removed from the set, that is if it was
689      * present.
690      */
691     function remove(AddressSet storage set, address value) internal returns (bool) {
692         return _remove(set._inner, bytes32(uint256(uint160(value))));
693     }
694 
695     /**
696      * @dev Returns true if the value is in the set. O(1).
697      */
698     function contains(AddressSet storage set, address value) internal view returns (bool) {
699         return _contains(set._inner, bytes32(uint256(uint160(value))));
700     }
701 
702     /**
703      * @dev Returns the number of values in the set. O(1).
704      */
705     function length(AddressSet storage set) internal view returns (uint256) {
706         return _length(set._inner);
707     }
708 
709    /**
710     * @dev Returns the value stored at position `index` in the set. O(1).
711     *
712     * Note that there are no guarantees on the ordering of values inside the
713     * array, and it may change when more values are added or removed.
714     *
715     * Requirements:
716     *
717     * - `index` must be strictly less than {length}.
718     */
719     function at(AddressSet storage set, uint256 index) internal view returns (address) {
720         return address(uint160(uint256(_at(set._inner, index))));
721     }
722 
723 
724     // UintSet
725 
726     struct UintSet {
727         Set _inner;
728     }
729 
730     /**
731      * @dev Add a value to a set. O(1).
732      *
733      * Returns true if the value was added to the set, that is if it was not
734      * already present.
735      */
736     function add(UintSet storage set, uint256 value) internal returns (bool) {
737         return _add(set._inner, bytes32(value));
738     }
739 
740     /**
741      * @dev Removes a value from a set. O(1).
742      *
743      * Returns true if the value was removed from the set, that is if it was
744      * present.
745      */
746     function remove(UintSet storage set, uint256 value) internal returns (bool) {
747         return _remove(set._inner, bytes32(value));
748     }
749 
750     /**
751      * @dev Returns true if the value is in the set. O(1).
752      */
753     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
754         return _contains(set._inner, bytes32(value));
755     }
756 
757     /**
758      * @dev Returns the number of values on the set. O(1).
759      */
760     function length(UintSet storage set) internal view returns (uint256) {
761         return _length(set._inner);
762     }
763 
764    /**
765     * @dev Returns the value stored at position `index` in the set. O(1).
766     *
767     * Note that there are no guarantees on the ordering of values inside the
768     * array, and it may change when more values are added or removed.
769     *
770     * Requirements:
771     *
772     * - `index` must be strictly less than {length}.
773     */
774     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
775         return uint256(_at(set._inner, index));
776     }
777 }
778 
779 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC165
780 
781 /**
782  * @dev Interface of the ERC165 standard, as defined in the
783  * https://eips.ethereum.org/EIPS/eip-165[EIP].
784  *
785  * Implementers can declare support of contract interfaces, which can then be
786  * queried by others ({ERC165Checker}).
787  *
788  * For an implementation, see {ERC165}.
789  */
790 interface IERC165 {
791     /**
792      * @dev Returns true if this contract implements the interface defined by
793      * `interfaceId`. See the corresponding
794      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
795      * to learn more about how these ids are created.
796      *
797      * This function call must use less than 30 000 gas.
798      */
799     function supportsInterface(bytes4 interfaceId) external view returns (bool);
800 }
801 
802 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC721Receiver
803 
804 /**
805  * @title ERC721 token receiver interface
806  * @dev Interface for any contract that wants to support safeTransfers
807  * from ERC721 asset contracts.
808  */
809 interface IERC721Receiver {
810     /**
811      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
812      * by `operator` from `from`, this function is called.
813      *
814      * It must return its Solidity selector to confirm the token transfer.
815      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
816      *
817      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
818      */
819     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
820 }
821 
822 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/SafeMath
823 
824 /**
825  * @dev Wrappers over Solidity's arithmetic operations with added overflow
826  * checks.
827  *
828  * Arithmetic operations in Solidity wrap on overflow. This can easily result
829  * in bugs, because programmers usually assume that an overflow raises an
830  * error, which is the standard behavior in high level programming languages.
831  * `SafeMath` restores this intuition by reverting the transaction when an
832  * operation overflows.
833  *
834  * Using this library instead of the unchecked operations eliminates an entire
835  * class of bugs, so it's recommended to use it always.
836  */
837 library SafeMath {
838     /**
839      * @dev Returns the addition of two unsigned integers, with an overflow flag.
840      *
841      * _Available since v3.4._
842      */
843     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
844         uint256 c = a + b;
845         if (c < a) return (false, 0);
846         return (true, c);
847     }
848 
849     /**
850      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
851      *
852      * _Available since v3.4._
853      */
854     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
855         if (b > a) return (false, 0);
856         return (true, a - b);
857     }
858 
859     /**
860      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
861      *
862      * _Available since v3.4._
863      */
864     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
865         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
866         // benefit is lost if 'b' is also tested.
867         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
868         if (a == 0) return (true, 0);
869         uint256 c = a * b;
870         if (c / a != b) return (false, 0);
871         return (true, c);
872     }
873 
874     /**
875      * @dev Returns the division of two unsigned integers, with a division by zero flag.
876      *
877      * _Available since v3.4._
878      */
879     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
880         if (b == 0) return (false, 0);
881         return (true, a / b);
882     }
883 
884     /**
885      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
886      *
887      * _Available since v3.4._
888      */
889     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
890         if (b == 0) return (false, 0);
891         return (true, a % b);
892     }
893 
894     /**
895      * @dev Returns the addition of two unsigned integers, reverting on
896      * overflow.
897      *
898      * Counterpart to Solidity's `+` operator.
899      *
900      * Requirements:
901      *
902      * - Addition cannot overflow.
903      */
904     function add(uint256 a, uint256 b) internal pure returns (uint256) {
905         uint256 c = a + b;
906         require(c >= a, "SafeMath: addition overflow");
907         return c;
908     }
909 
910     /**
911      * @dev Returns the subtraction of two unsigned integers, reverting on
912      * overflow (when the result is negative).
913      *
914      * Counterpart to Solidity's `-` operator.
915      *
916      * Requirements:
917      *
918      * - Subtraction cannot overflow.
919      */
920     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
921         require(b <= a, "SafeMath: subtraction overflow");
922         return a - b;
923     }
924 
925     /**
926      * @dev Returns the multiplication of two unsigned integers, reverting on
927      * overflow.
928      *
929      * Counterpart to Solidity's `*` operator.
930      *
931      * Requirements:
932      *
933      * - Multiplication cannot overflow.
934      */
935     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
936         if (a == 0) return 0;
937         uint256 c = a * b;
938         require(c / a == b, "SafeMath: multiplication overflow");
939         return c;
940     }
941 
942     /**
943      * @dev Returns the integer division of two unsigned integers, reverting on
944      * division by zero. The result is rounded towards zero.
945      *
946      * Counterpart to Solidity's `/` operator. Note: this function uses a
947      * `revert` opcode (which leaves remaining gas untouched) while Solidity
948      * uses an invalid opcode to revert (consuming all remaining gas).
949      *
950      * Requirements:
951      *
952      * - The divisor cannot be zero.
953      */
954     function div(uint256 a, uint256 b) internal pure returns (uint256) {
955         require(b > 0, "SafeMath: division by zero");
956         return a / b;
957     }
958 
959     /**
960      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
961      * reverting when dividing by zero.
962      *
963      * Counterpart to Solidity's `%` operator. This function uses a `revert`
964      * opcode (which leaves remaining gas untouched) while Solidity uses an
965      * invalid opcode to revert (consuming all remaining gas).
966      *
967      * Requirements:
968      *
969      * - The divisor cannot be zero.
970      */
971     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
972         require(b > 0, "SafeMath: modulo by zero");
973         return a % b;
974     }
975 
976     /**
977      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
978      * overflow (when the result is negative).
979      *
980      * CAUTION: This function is deprecated because it requires allocating memory for the error
981      * message unnecessarily. For custom revert reasons use {trySub}.
982      *
983      * Counterpart to Solidity's `-` operator.
984      *
985      * Requirements:
986      *
987      * - Subtraction cannot overflow.
988      */
989     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
990         require(b <= a, errorMessage);
991         return a - b;
992     }
993 
994     /**
995      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
996      * division by zero. The result is rounded towards zero.
997      *
998      * CAUTION: This function is deprecated because it requires allocating memory for the error
999      * message unnecessarily. For custom revert reasons use {tryDiv}.
1000      *
1001      * Counterpart to Solidity's `/` operator. Note: this function uses a
1002      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1003      * uses an invalid opcode to revert (consuming all remaining gas).
1004      *
1005      * Requirements:
1006      *
1007      * - The divisor cannot be zero.
1008      */
1009     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1010         require(b > 0, errorMessage);
1011         return a / b;
1012     }
1013 
1014     /**
1015      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1016      * reverting with custom message when dividing by zero.
1017      *
1018      * CAUTION: This function is deprecated because it requires allocating memory for the error
1019      * message unnecessarily. For custom revert reasons use {tryMod}.
1020      *
1021      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1022      * opcode (which leaves remaining gas untouched) while Solidity uses an
1023      * invalid opcode to revert (consuming all remaining gas).
1024      *
1025      * Requirements:
1026      *
1027      * - The divisor cannot be zero.
1028      */
1029     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1030         require(b > 0, errorMessage);
1031         return a % b;
1032     }
1033 }
1034 
1035 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Strings
1036 
1037 /**
1038  * @dev String operations.
1039  */
1040 library Strings {
1041     /**
1042      * @dev Converts a `uint256` to its ASCII `string` representation.
1043      */
1044     function toString(uint256 value) internal pure returns (string memory) {
1045         // Inspired by OraclizeAPI's implementation - MIT licence
1046         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1047 
1048         if (value == 0) {
1049             return "0";
1050         }
1051         uint256 temp = value;
1052         uint256 digits;
1053         while (temp != 0) {
1054             digits++;
1055             temp /= 10;
1056         }
1057         bytes memory buffer = new bytes(digits);
1058         uint256 index = digits - 1;
1059         temp = value;
1060         while (temp != 0) {
1061             buffer[index--] = bytes1(uint8(48 + temp % 10));
1062             temp /= 10;
1063         }
1064         return string(buffer);
1065     }
1066 }
1067 
1068 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ERC165
1069 
1070 /**
1071  * @dev Implementation of the {IERC165} interface.
1072  *
1073  * Contracts may inherit from this and call {_registerInterface} to declare
1074  * their support of an interface.
1075  */
1076 abstract contract ERC165 is IERC165 {
1077     /*
1078      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1079      */
1080     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1081 
1082     /**
1083      * @dev Mapping of interface ids to whether or not it's supported.
1084      */
1085     mapping(bytes4 => bool) private _supportedInterfaces;
1086 
1087     constructor () internal {
1088         // Derived contracts need only register support for their own interfaces,
1089         // we register support for ERC165 itself here
1090         _registerInterface(_INTERFACE_ID_ERC165);
1091     }
1092 
1093     /**
1094      * @dev See {IERC165-supportsInterface}.
1095      *
1096      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1097      */
1098     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1099         return _supportedInterfaces[interfaceId];
1100     }
1101 
1102     /**
1103      * @dev Registers the contract as an implementer of the interface defined by
1104      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1105      * registering its interface id is not required.
1106      *
1107      * See {IERC165-supportsInterface}.
1108      *
1109      * Requirements:
1110      *
1111      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1112      */
1113     function _registerInterface(bytes4 interfaceId) internal virtual {
1114         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1115         _supportedInterfaces[interfaceId] = true;
1116     }
1117 }
1118 
1119 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC721
1120 
1121 /**
1122  * @dev Required interface of an ERC721 compliant contract.
1123  */
1124 interface IERC721 is IERC165 {
1125     /**
1126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1127      */
1128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1129 
1130     /**
1131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1132      */
1133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1134 
1135     /**
1136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1137      */
1138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1139 
1140     /**
1141      * @dev Returns the number of tokens in ``owner``'s account.
1142      */
1143     function balanceOf(address owner) external view returns (uint256 balance);
1144 
1145     /**
1146      * @dev Returns the owner of the `tokenId` token.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must exist.
1151      */
1152     function ownerOf(uint256 tokenId) external view returns (address owner);
1153 
1154     /**
1155      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1156      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1157      *
1158      * Requirements:
1159      *
1160      * - `from` cannot be the zero address.
1161      * - `to` cannot be the zero address.
1162      * - `tokenId` token must exist and be owned by `from`.
1163      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1169 
1170     /**
1171      * @dev Transfers `tokenId` token from `from` to `to`.
1172      *
1173      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1174      *
1175      * Requirements:
1176      *
1177      * - `from` cannot be the zero address.
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function transferFrom(address from, address to, uint256 tokenId) external;
1185 
1186     /**
1187      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1188      * The approval is cleared when the token is transferred.
1189      *
1190      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1191      *
1192      * Requirements:
1193      *
1194      * - The caller must own the token or be an approved operator.
1195      * - `tokenId` must exist.
1196      *
1197      * Emits an {Approval} event.
1198      */
1199     function approve(address to, uint256 tokenId) external;
1200 
1201     /**
1202      * @dev Returns the account approved for `tokenId` token.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must exist.
1207      */
1208     function getApproved(uint256 tokenId) external view returns (address operator);
1209 
1210     /**
1211      * @dev Approve or remove `operator` as an operator for the caller.
1212      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1213      *
1214      * Requirements:
1215      *
1216      * - The `operator` cannot be the caller.
1217      *
1218      * Emits an {ApprovalForAll} event.
1219      */
1220     function setApprovalForAll(address operator, bool _approved) external;
1221 
1222     /**
1223      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1224      *
1225      * See {setApprovalForAll}
1226      */
1227     function isApprovedForAll(address owner, address operator) external view returns (bool);
1228 
1229     /**
1230       * @dev Safely transfers `tokenId` token from `from` to `to`.
1231       *
1232       * Requirements:
1233       *
1234       * - `from` cannot be the zero address.
1235       * - `to` cannot be the zero address.
1236       * - `tokenId` token must exist and be owned by `from`.
1237       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1238       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1239       *
1240       * Emits a {Transfer} event.
1241       */
1242     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1243 }
1244 
1245 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC721Enumerable
1246 
1247 /**
1248  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1249  * @dev See https://eips.ethereum.org/EIPS/eip-721
1250  */
1251 interface IERC721Enumerable is IERC721 {
1252 
1253     /**
1254      * @dev Returns the total amount of tokens stored by the contract.
1255      */
1256     function totalSupply() external view returns (uint256);
1257 
1258     /**
1259      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1260      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1261      */
1262     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1263 
1264     /**
1265      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1266      * Use along with {totalSupply} to enumerate all tokens.
1267      */
1268     function tokenByIndex(uint256 index) external view returns (uint256);
1269 }
1270 
1271 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC721Metadata
1272 
1273 /**
1274  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1275  * @dev See https://eips.ethereum.org/EIPS/eip-721
1276  */
1277 interface IERC721Metadata is IERC721 {
1278 
1279     /**
1280      * @dev Returns the token collection name.
1281      */
1282     function name() external view returns (string memory);
1283 
1284     /**
1285      * @dev Returns the token collection symbol.
1286      */
1287     function symbol() external view returns (string memory);
1288 
1289     /**
1290      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1291      */
1292     function tokenURI(uint256 tokenId) external view returns (string memory);
1293 }
1294 
1295 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ERC721
1296 
1297 /**
1298  * @title ERC721 Non-Fungible Token Standard basic implementation
1299  * @dev see https://eips.ethereum.org/EIPS/eip-721
1300  */
1301 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1302     using SafeMath for uint256;
1303     using Address for address;
1304     using EnumerableSet for EnumerableSet.UintSet;
1305     using EnumerableMap for EnumerableMap.UintToAddressMap;
1306     using Strings for uint256;
1307 
1308     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1309     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1310     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1311 
1312     // Mapping from holder address to their (enumerable) set of owned tokens
1313     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1314 
1315     // Enumerable mapping from token ids to their owners
1316     EnumerableMap.UintToAddressMap private _tokenOwners;
1317 
1318     // Mapping from token ID to approved address
1319     mapping (uint256 => address) private _tokenApprovals;
1320 
1321     // Mapping from owner to operator approvals
1322     mapping (address => mapping (address => bool)) private _operatorApprovals;
1323 
1324     // Token name
1325     string private _name;
1326 
1327     // Token symbol
1328     string private _symbol;
1329 
1330     // Optional mapping for token URIs
1331     mapping (uint256 => string) private _tokenURIs;
1332 
1333     // Base URI
1334     string private _baseURI;
1335 
1336     /*
1337      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1338      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1339      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1340      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1341      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1342      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1343      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1344      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1345      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1346      *
1347      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1348      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1349      */
1350     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1351 
1352     /*
1353      *     bytes4(keccak256('name()')) == 0x06fdde03
1354      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1355      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1356      *
1357      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1358      */
1359     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1360 
1361     /*
1362      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1363      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1364      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1365      *
1366      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1367      */
1368     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1369 
1370     /**
1371      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1372      */
1373     constructor (string memory name_, string memory symbol_) public {
1374         _name = name_;
1375         _symbol = symbol_;
1376 
1377         // register the supported interfaces to conform to ERC721 via ERC165
1378         _registerInterface(_INTERFACE_ID_ERC721);
1379         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1380         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-balanceOf}.
1385      */
1386     function balanceOf(address owner) public view virtual override returns (uint256) {
1387         require(owner != address(0), "ERC721: balance query for the zero address");
1388         return _holderTokens[owner].length();
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-ownerOf}.
1393      */
1394     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1395         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1396     }
1397 
1398     /**
1399      * @dev See {IERC721Metadata-name}.
1400      */
1401     function name() public view virtual override returns (string memory) {
1402         return _name;
1403     }
1404 
1405     /**
1406      * @dev See {IERC721Metadata-symbol}.
1407      */
1408     function symbol() public view virtual override returns (string memory) {
1409         return _symbol;
1410     }
1411 
1412     /**
1413      * @dev See {IERC721Metadata-tokenURI}.
1414      */
1415     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1416         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1417 
1418         string memory _tokenURI = _tokenURIs[tokenId];
1419         string memory base = baseURI();
1420 
1421         // If there is no base URI, return the token URI.
1422         if (bytes(base).length == 0) {
1423             return _tokenURI;
1424         }
1425         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1426         if (bytes(_tokenURI).length > 0) {
1427             return string(abi.encodePacked(base, _tokenURI));
1428         }
1429         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1430         return string(abi.encodePacked(base, tokenId.toString()));
1431     }
1432 
1433     /**
1434     * @dev Returns the base URI set via {_setBaseURI}. This will be
1435     * automatically added as a prefix in {tokenURI} to each token's URI, or
1436     * to the token ID if no specific URI is set for that token ID.
1437     */
1438     function baseURI() public view virtual returns (string memory) {
1439         return _baseURI;
1440     }
1441 
1442     /**
1443      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1444      */
1445     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1446         return _holderTokens[owner].at(index);
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Enumerable-totalSupply}.
1451      */
1452     function totalSupply() public view virtual override returns (uint256) {
1453         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1454         return _tokenOwners.length();
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Enumerable-tokenByIndex}.
1459      */
1460     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1461         (uint256 tokenId, ) = _tokenOwners.at(index);
1462         return tokenId;
1463     }
1464 
1465     /**
1466      * @dev See {IERC721-approve}.
1467      */
1468     function approve(address to, uint256 tokenId) public virtual override {
1469         address owner = ERC721.ownerOf(tokenId);
1470         require(to != owner, "ERC721: approval to current owner");
1471 
1472         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1473             "ERC721: approve caller is not owner nor approved for all"
1474         );
1475 
1476         _approve(to, tokenId);
1477     }
1478 
1479     /**
1480      * @dev See {IERC721-getApproved}.
1481      */
1482     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1483         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1484 
1485         return _tokenApprovals[tokenId];
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-setApprovalForAll}.
1490      */
1491     function setApprovalForAll(address operator, bool approved) public virtual override {
1492         require(operator != _msgSender(), "ERC721: approve to caller");
1493 
1494         _operatorApprovals[_msgSender()][operator] = approved;
1495         emit ApprovalForAll(_msgSender(), operator, approved);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-isApprovedForAll}.
1500      */
1501     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1502         return _operatorApprovals[owner][operator];
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-transferFrom}.
1507      */
1508     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1509         //solhint-disable-next-line max-line-length
1510         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1511 
1512         _transfer(from, to, tokenId);
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-safeTransferFrom}.
1517      */
1518     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1519         safeTransferFrom(from, to, tokenId, "");
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-safeTransferFrom}.
1524      */
1525     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1526         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1527         _safeTransfer(from, to, tokenId, _data);
1528     }
1529 
1530     /**
1531      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1532      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1533      *
1534      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1535      *
1536      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1537      * implement alternative mechanisms to perform token transfer, such as signature-based.
1538      *
1539      * Requirements:
1540      *
1541      * - `from` cannot be the zero address.
1542      * - `to` cannot be the zero address.
1543      * - `tokenId` token must exist and be owned by `from`.
1544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1545      *
1546      * Emits a {Transfer} event.
1547      */
1548     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1549         _transfer(from, to, tokenId);
1550         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1551     }
1552 
1553     /**
1554      * @dev Returns whether `tokenId` exists.
1555      *
1556      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1557      *
1558      * Tokens start existing when they are minted (`_mint`),
1559      * and stop existing when they are burned (`_burn`).
1560      */
1561     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1562         return _tokenOwners.contains(tokenId);
1563     }
1564 
1565     /**
1566      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1567      *
1568      * Requirements:
1569      *
1570      * - `tokenId` must exist.
1571      */
1572     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1573         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1574         address owner = ERC721.ownerOf(tokenId);
1575         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1576     }
1577 
1578     /**
1579      * @dev Safely mints `tokenId` and transfers it to `to`.
1580      *
1581      * Requirements:
1582      d*
1583      * - `tokenId` must not exist.
1584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function _safeMint(address to, uint256 tokenId) internal virtual {
1589         _safeMint(to, tokenId, "");
1590     }
1591 
1592     /**
1593      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1594      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1595      */
1596     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1597         _mint(to, tokenId);
1598         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1599     }
1600 
1601     /**
1602      * @dev Mints `tokenId` and transfers it to `to`.
1603      *
1604      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1605      *
1606      * Requirements:
1607      *
1608      * - `tokenId` must not exist.
1609      * - `to` cannot be the zero address.
1610      *
1611      * Emits a {Transfer} event.
1612      */
1613     function _mint(address to, uint256 tokenId) internal virtual {
1614         require(to != address(0), "ERC721: mint to the zero address");
1615         require(!_exists(tokenId), "ERC721: token already minted");
1616 
1617         _beforeTokenTransfer(address(0), to, tokenId);
1618 
1619         _holderTokens[to].add(tokenId);
1620 
1621         _tokenOwners.set(tokenId, to);
1622 
1623         emit Transfer(address(0), to, tokenId);
1624     }
1625 
1626     /**
1627      * @dev Destroys `tokenId`.
1628      * The approval is cleared when the token is burned.
1629      *
1630      * Requirements:
1631      *
1632      * - `tokenId` must exist.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function _burn(uint256 tokenId) internal virtual {
1637         address owner = ERC721.ownerOf(tokenId); // internal owner
1638 
1639         _beforeTokenTransfer(owner, address(0), tokenId);
1640 
1641         // Clear approvals
1642         _approve(address(0), tokenId);
1643 
1644         // Clear metadata (if any)
1645         if (bytes(_tokenURIs[tokenId]).length != 0) {
1646             delete _tokenURIs[tokenId];
1647         }
1648 
1649         _holderTokens[owner].remove(tokenId);
1650 
1651         _tokenOwners.remove(tokenId);
1652 
1653         emit Transfer(owner, address(0), tokenId);
1654     }
1655 
1656     /**
1657      * @dev Transfers `tokenId` from `from` to `to`.
1658      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1659      *
1660      * Requirements:
1661      *
1662      * - `to` cannot be the zero address.
1663      * - `tokenId` token must be owned by `from`.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1668         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1669         require(to != address(0), "ERC721: transfer to the zero address");
1670 
1671         _beforeTokenTransfer(from, to, tokenId);
1672 
1673         // Clear approvals from the previous owner
1674         _approve(address(0), tokenId);
1675 
1676         _holderTokens[from].remove(tokenId);
1677         _holderTokens[to].add(tokenId);
1678 
1679         _tokenOwners.set(tokenId, to);
1680 
1681         emit Transfer(from, to, tokenId);
1682     }
1683 
1684     /**
1685      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1686      *
1687      * Requirements:
1688      *
1689      * - `tokenId` must exist.
1690      */
1691     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1692         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1693         _tokenURIs[tokenId] = _tokenURI;
1694     }
1695 
1696     /**
1697      * @dev Internal function to set the base URI for all token IDs. It is
1698      * automatically added as a prefix to the value returned in {tokenURI},
1699      * or to the token ID if {tokenURI} is empty.
1700      */
1701     function _setBaseURI(string memory baseURI_) internal virtual {
1702         _baseURI = baseURI_;
1703     }
1704 
1705     /**
1706      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1707      * The call is not executed if the target address is not a contract.
1708      *
1709      * @param from address representing the previous owner of the given token ID
1710      * @param to target address that will receive the tokens
1711      * @param tokenId uint256 ID of the token to be transferred
1712      * @param _data bytes optional data to send along with the call
1713      * @return bool whether the call correctly returned the expected magic value
1714      */
1715     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1716         private returns (bool)
1717     {
1718         if (!to.isContract()) {
1719             return true;
1720         }
1721         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1722             IERC721Receiver(to).onERC721Received.selector,
1723             _msgSender(),
1724             from,
1725             tokenId,
1726             _data
1727         ), "ERC721: transfer to non ERC721Receiver implementer");
1728         bytes4 retval = abi.decode(returndata, (bytes4));
1729         return (retval == _ERC721_RECEIVED);
1730     }
1731 
1732     function _approve(address to, uint256 tokenId) private {
1733         _tokenApprovals[tokenId] = to;
1734         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1735     }
1736 
1737     /**
1738      * @dev Hook that is called before any token transfer. This includes minting
1739      * and burning.
1740      *
1741      * Calling conditions:
1742      *
1743      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1744      * transferred to `to`.
1745      * - When `from` is zero, `tokenId` will be minted for `to`.
1746      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1747      * - `from` cannot be the zero address.
1748      * - `to` cannot be the zero address.
1749      *
1750      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1751      */
1752     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1753 }
1754 
1755 // File: Relics.sol
1756 
1757 contract Relics is ERC721 {
1758     address private _owner;
1759     uint256 public tokenCounter;
1760     bool public saleStatus = false;
1761     bool public collectionLock = true; // if true, can keep minting (not locked) 
1762     address payable wallet = 0x5c2B89CBeC1a4996Aa5e81f3dFf8505ABeC6B34c;
1763     string public relicURI = "nothingtostart";
1764     constructor () public ERC721 ("Relics of the PixaVerse", "ROTP"){
1765         tokenCounter = 1;
1766         _setOwner(wallet);
1767     }
1768 
1769     function mintRelic() public {
1770         require(saleStatus);
1771         require(collectionLock);
1772         _safeMint(msg.sender, tokenCounter);
1773         _setTokenURI(tokenCounter, relicURI);
1774         tokenCounter = tokenCounter + 1;
1775     }
1776 
1777     function ownermintRelic() public {
1778         require(msg.sender == wallet);
1779         require(collectionLock);        
1780         _safeMint(msg.sender, tokenCounter);
1781         _setTokenURI(tokenCounter, relicURI);
1782         tokenCounter = tokenCounter + 1;
1783     }
1784 
1785     function changeRelicURI(string memory inputURI) public {
1786         require(msg.sender == wallet);
1787         relicURI = inputURI;
1788     }
1789 
1790     function startSale() public {
1791         require(msg.sender == wallet);
1792         saleStatus = true;
1793     }
1794 
1795     function stopSale() public {
1796         require(msg.sender == wallet);
1797         saleStatus = false;
1798     }
1799 
1800     function lockcollection() public {
1801         require(msg.sender == wallet);
1802         collectionLock = false;
1803     }
1804 
1805     function getBalance() public view returns (uint256) {
1806         return address(this).balance;
1807     }
1808 
1809     function withdrawAmount(uint256 amount) public {
1810         require(msg.sender == wallet);
1811         require(amount <= getBalance());
1812         msg.sender.transfer(amount);
1813     }    
1814 
1815     function owner() public view virtual returns (address) {
1816         return _owner;
1817     }
1818 
1819     /**
1820      * @dev Throws if called by any account other than the owner.
1821      */
1822     modifier onlyOwner() {
1823         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1824         _;
1825     }
1826 
1827     /**
1828      * @dev Leaves the contract without owner. It will not be possible to call
1829      * `onlyOwner` functions anymore. Can only be called by the current owner.
1830      *
1831      * NOTE: Renouncing ownership will leave the contract without an owner,
1832      * thereby removing any functionality that is only available to the owner.
1833      */
1834     function renounceOwnership() public virtual onlyOwner {
1835         _setOwner(address(0));
1836     }
1837 
1838     /**
1839      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1840      * Can only be called by the current owner.
1841      */
1842     function transferOwnership(address newOwner) public virtual onlyOwner {
1843         require(newOwner != address(0), "Ownable: new owner is the zero address");
1844         _setOwner(newOwner);
1845     }
1846 
1847     function _setOwner(address newOwner) private {
1848         require(msg.sender == wallet);
1849         address oldOwner = _owner;
1850         _owner = newOwner;
1851     }
1852 
1853 }
