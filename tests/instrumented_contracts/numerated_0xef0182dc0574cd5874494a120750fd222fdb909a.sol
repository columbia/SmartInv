1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/Address
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
195 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/Context
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
218 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/EnumerableMap
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
483 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/EnumerableSet
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
779 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/IERC165
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
802 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/IERC721Receiver
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
822 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/SafeMath
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
1035 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/Strings
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
1068 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/ERC165
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
1087     constructor () {
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
1119 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/IERC721
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
1245 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/Ownable
1246 
1247 /**
1248  * @dev Contract module which provides a basic access control mechanism, where
1249  * there is an account (an owner) that can be granted exclusive access to
1250  * specific functions.
1251  *
1252  * By default, the owner account will be the one that deploys the contract. This
1253  * can later be changed with {transferOwnership}.
1254  *
1255  * This module is used through inheritance. It will make available the modifier
1256  * `onlyOwner`, which can be applied to your functions to restrict their use to
1257  * the owner.
1258  */
1259 abstract contract Ownable is Context {
1260     address private _owner;
1261 
1262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1263 
1264     /**
1265      * @dev Initializes the contract setting the deployer as the initial owner.
1266      */
1267     constructor () {
1268         address msgSender = _msgSender();
1269         _owner = msgSender;
1270         emit OwnershipTransferred(address(0), msgSender);
1271     }
1272 
1273     /**
1274      * @dev Returns the address of the current owner.
1275      */
1276     function owner() public view virtual returns (address) {
1277         return _owner;
1278     }
1279 
1280     /**
1281      * @dev Throws if called by any account other than the owner.
1282      */
1283     modifier onlyOwner() {
1284         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1285         _;
1286     }
1287 
1288     /**
1289      * @dev Leaves the contract without owner. It will not be possible to call
1290      * `onlyOwner` functions anymore. Can only be called by the current owner.
1291      *
1292      * NOTE: Renouncing ownership will leave the contract without an owner,
1293      * thereby removing any functionality that is only available to the owner.
1294      */
1295     function renounceOwnership() public virtual onlyOwner {
1296         emit OwnershipTransferred(_owner, address(0));
1297         _owner = address(0);
1298     }
1299 
1300     /**
1301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1302      * Can only be called by the current owner.
1303      */
1304     function transferOwnership(address newOwner) public virtual onlyOwner {
1305         require(newOwner != address(0), "Ownable: new owner is the zero address");
1306         emit OwnershipTransferred(_owner, newOwner);
1307         _owner = newOwner;
1308     }
1309 }
1310 
1311 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/IERC721Enumerable
1312 
1313 /**
1314  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1315  * @dev See https://eips.ethereum.org/EIPS/eip-721
1316  */
1317 interface IERC721Enumerable is IERC721 {
1318 
1319     /**
1320      * @dev Returns the total amount of tokens stored by the contract.
1321      */
1322     function totalSupply() external view returns (uint256);
1323 
1324     /**
1325      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1326      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1327      */
1328     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1329 
1330     /**
1331      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1332      * Use along with {totalSupply} to enumerate all tokens.
1333      */
1334     function tokenByIndex(uint256 index) external view returns (uint256);
1335 }
1336 
1337 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/IERC721Metadata
1338 
1339 /**
1340  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1341  * @dev See https://eips.ethereum.org/EIPS/eip-721
1342  */
1343 interface IERC721Metadata is IERC721 {
1344 
1345     /**
1346      * @dev Returns the token collection name.
1347      */
1348     function name() external view returns (string memory);
1349 
1350     /**
1351      * @dev Returns the token collection symbol.
1352      */
1353     function symbol() external view returns (string memory);
1354 
1355     /**
1356      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1357      */
1358     function tokenURI(uint256 tokenId) external view returns (string memory);
1359 }
1360 
1361 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0-solc-0.7/ERC721
1362 
1363 /**
1364  * @title ERC721 Non-Fungible Token Standard basic implementation
1365  * @dev see https://eips.ethereum.org/EIPS/eip-721
1366  */
1367 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1368     using SafeMath for uint256;
1369     using Address for address;
1370     using EnumerableSet for EnumerableSet.UintSet;
1371     using EnumerableMap for EnumerableMap.UintToAddressMap;
1372     using Strings for uint256;
1373 
1374     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1375     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1376     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1377 
1378     // Mapping from holder address to their (enumerable) set of owned tokens
1379     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1380 
1381     // Enumerable mapping from token ids to their owners
1382     EnumerableMap.UintToAddressMap private _tokenOwners;
1383 
1384     // Mapping from token ID to approved address
1385     mapping (uint256 => address) private _tokenApprovals;
1386 
1387     // Mapping from owner to operator approvals
1388     mapping (address => mapping (address => bool)) private _operatorApprovals;
1389 
1390     // Token name
1391     string private _name;
1392 
1393     // Token symbol
1394     string private _symbol;
1395 
1396     // Optional mapping for token URIs
1397     mapping (uint256 => string) private _tokenURIs;
1398 
1399     // Base URI
1400     string private _baseURI;
1401 
1402     /*
1403      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1404      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1405      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1406      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1407      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1408      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1409      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1410      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1411      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1412      *
1413      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1414      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1415      */
1416     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1417 
1418     /*
1419      *     bytes4(keccak256('name()')) == 0x06fdde03
1420      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1421      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1422      *
1423      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1424      */
1425     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1426 
1427     /*
1428      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1429      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1430      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1431      *
1432      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1433      */
1434     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1435 
1436     /**
1437      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1438      */
1439     constructor (string memory name_, string memory symbol_) {
1440         _name = name_;
1441         _symbol = symbol_;
1442 
1443         // register the supported interfaces to conform to ERC721 via ERC165
1444         _registerInterface(_INTERFACE_ID_ERC721);
1445         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1446         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-balanceOf}.
1451      */
1452     function balanceOf(address owner) public view virtual override returns (uint256) {
1453         require(owner != address(0), "ERC721: balance query for the zero address");
1454         return _holderTokens[owner].length();
1455     }
1456 
1457     /**
1458      * @dev See {IERC721-ownerOf}.
1459      */
1460     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1461         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Metadata-name}.
1466      */
1467     function name() public view virtual override returns (string memory) {
1468         return _name;
1469     }
1470 
1471     /**
1472      * @dev See {IERC721Metadata-symbol}.
1473      */
1474     function symbol() public view virtual override returns (string memory) {
1475         return _symbol;
1476     }
1477 
1478     /**
1479      * @dev See {IERC721Metadata-tokenURI}.
1480      */
1481     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1482         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1483 
1484         string memory _tokenURI = _tokenURIs[tokenId];
1485         string memory base = baseURI();
1486 
1487         // If there is no base URI, return the token URI.
1488         if (bytes(base).length == 0) {
1489             return _tokenURI;
1490         }
1491         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1492         if (bytes(_tokenURI).length > 0) {
1493             return string(abi.encodePacked(base, _tokenURI));
1494         }
1495         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1496         return string(abi.encodePacked(base, tokenId.toString()));
1497     }
1498 
1499     /**
1500     * @dev Returns the base URI set via {_setBaseURI}. This will be
1501     * automatically added as a prefix in {tokenURI} to each token's URI, or
1502     * to the token ID if no specific URI is set for that token ID.
1503     */
1504     function baseURI() public view virtual returns (string memory) {
1505         return _baseURI;
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1510      */
1511     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1512         return _holderTokens[owner].at(index);
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-totalSupply}.
1517      */
1518     function totalSupply() public view virtual override returns (uint256) {
1519         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1520         return _tokenOwners.length();
1521     }
1522 
1523     /**
1524      * @dev See {IERC721Enumerable-tokenByIndex}.
1525      */
1526     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1527         (uint256 tokenId, ) = _tokenOwners.at(index);
1528         return tokenId;
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-approve}.
1533      */
1534     function approve(address to, uint256 tokenId) public virtual override {
1535         address owner = ERC721.ownerOf(tokenId);
1536         require(to != owner, "ERC721: approval to current owner");
1537 
1538         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1539             "ERC721: approve caller is not owner nor approved for all"
1540         );
1541 
1542         _approve(to, tokenId);
1543     }
1544 
1545     /**
1546      * @dev See {IERC721-getApproved}.
1547      */
1548     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1549         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1550 
1551         return _tokenApprovals[tokenId];
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-setApprovalForAll}.
1556      */
1557     function setApprovalForAll(address operator, bool approved) public virtual override {
1558         require(operator != _msgSender(), "ERC721: approve to caller");
1559 
1560         _operatorApprovals[_msgSender()][operator] = approved;
1561         emit ApprovalForAll(_msgSender(), operator, approved);
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-isApprovedForAll}.
1566      */
1567     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1568         return _operatorApprovals[owner][operator];
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-transferFrom}.
1573      */
1574     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1575         //solhint-disable-next-line max-line-length
1576         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1577 
1578         _transfer(from, to, tokenId);
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-safeTransferFrom}.
1583      */
1584     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1585         safeTransferFrom(from, to, tokenId, "");
1586     }
1587 
1588     /**
1589      * @dev See {IERC721-safeTransferFrom}.
1590      */
1591     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1592         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1593         _safeTransfer(from, to, tokenId, _data);
1594     }
1595 
1596     /**
1597      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1599      *
1600      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1601      *
1602      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1603      * implement alternative mechanisms to perform token transfer, such as signature-based.
1604      *
1605      * Requirements:
1606      *
1607      * - `from` cannot be the zero address.
1608      * - `to` cannot be the zero address.
1609      * - `tokenId` token must exist and be owned by `from`.
1610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1615         _transfer(from, to, tokenId);
1616         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1617     }
1618 
1619     /**
1620      * @dev Returns whether `tokenId` exists.
1621      *
1622      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1623      *
1624      * Tokens start existing when they are minted (`_mint`),
1625      * and stop existing when they are burned (`_burn`).
1626      */
1627     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1628         return _tokenOwners.contains(tokenId);
1629     }
1630 
1631     /**
1632      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1633      *
1634      * Requirements:
1635      *
1636      * - `tokenId` must exist.
1637      */
1638     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1639         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1640         address owner = ERC721.ownerOf(tokenId);
1641         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1642     }
1643 
1644     /**
1645      * @dev Safely mints `tokenId` and transfers it to `to`.
1646      *
1647      * Requirements:
1648      d*
1649      * - `tokenId` must not exist.
1650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1651      *
1652      * Emits a {Transfer} event.
1653      */
1654     function _safeMint(address to, uint256 tokenId) internal virtual {
1655         _safeMint(to, tokenId, "");
1656     }
1657 
1658     /**
1659      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1660      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1661      */
1662     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1663         _mint(to, tokenId);
1664         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1665     }
1666 
1667     /**
1668      * @dev Mints `tokenId` and transfers it to `to`.
1669      *
1670      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1671      *
1672      * Requirements:
1673      *
1674      * - `tokenId` must not exist.
1675      * - `to` cannot be the zero address.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _mint(address to, uint256 tokenId) internal virtual {
1680         require(to != address(0), "ERC721: mint to the zero address");
1681         require(!_exists(tokenId), "ERC721: token already minted");
1682 
1683         _beforeTokenTransfer(address(0), to, tokenId);
1684 
1685         _holderTokens[to].add(tokenId);
1686 
1687         _tokenOwners.set(tokenId, to);
1688 
1689         emit Transfer(address(0), to, tokenId);
1690     }
1691 
1692     /**
1693      * @dev Destroys `tokenId`.
1694      * The approval is cleared when the token is burned.
1695      *
1696      * Requirements:
1697      *
1698      * - `tokenId` must exist.
1699      *
1700      * Emits a {Transfer} event.
1701      */
1702     function _burn(uint256 tokenId) internal virtual {
1703         address owner = ERC721.ownerOf(tokenId); // internal owner
1704 
1705         _beforeTokenTransfer(owner, address(0), tokenId);
1706 
1707         // Clear approvals
1708         _approve(address(0), tokenId);
1709 
1710         // Clear metadata (if any)
1711         if (bytes(_tokenURIs[tokenId]).length != 0) {
1712             delete _tokenURIs[tokenId];
1713         }
1714 
1715         _holderTokens[owner].remove(tokenId);
1716 
1717         _tokenOwners.remove(tokenId);
1718 
1719         emit Transfer(owner, address(0), tokenId);
1720     }
1721 
1722     /**
1723      * @dev Transfers `tokenId` from `from` to `to`.
1724      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1725      *
1726      * Requirements:
1727      *
1728      * - `to` cannot be the zero address.
1729      * - `tokenId` token must be owned by `from`.
1730      *
1731      * Emits a {Transfer} event.
1732      */
1733     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1734         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1735         require(to != address(0), "ERC721: transfer to the zero address");
1736 
1737         _beforeTokenTransfer(from, to, tokenId);
1738 
1739         // Clear approvals from the previous owner
1740         _approve(address(0), tokenId);
1741 
1742         _holderTokens[from].remove(tokenId);
1743         _holderTokens[to].add(tokenId);
1744 
1745         _tokenOwners.set(tokenId, to);
1746 
1747         emit Transfer(from, to, tokenId);
1748     }
1749 
1750     /**
1751      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1752      *
1753      * Requirements:
1754      *
1755      * - `tokenId` must exist.
1756      */
1757     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1758         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1759         _tokenURIs[tokenId] = _tokenURI;
1760     }
1761 
1762     /**
1763      * @dev Internal function to set the base URI for all token IDs. It is
1764      * automatically added as a prefix to the value returned in {tokenURI},
1765      * or to the token ID if {tokenURI} is empty.
1766      */
1767     function _setBaseURI(string memory baseURI_) internal virtual {
1768         _baseURI = baseURI_;
1769     }
1770 
1771     /**
1772      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1773      * The call is not executed if the target address is not a contract.
1774      *
1775      * @param from address representing the previous owner of the given token ID
1776      * @param to target address that will receive the tokens
1777      * @param tokenId uint256 ID of the token to be transferred
1778      * @param _data bytes optional data to send along with the call
1779      * @return bool whether the call correctly returned the expected magic value
1780      */
1781     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1782         private returns (bool)
1783     {
1784         if (!to.isContract()) {
1785             return true;
1786         }
1787         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1788             IERC721Receiver(to).onERC721Received.selector,
1789             _msgSender(),
1790             from,
1791             tokenId,
1792             _data
1793         ), "ERC721: transfer to non ERC721Receiver implementer");
1794         bytes4 retval = abi.decode(returndata, (bytes4));
1795         return (retval == _ERC721_RECEIVED);
1796     }
1797 
1798     function _approve(address to, uint256 tokenId) private {
1799         _tokenApprovals[tokenId] = to;
1800         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1801     }
1802 
1803     /**
1804      * @dev Hook that is called before any token transfer. This includes minting
1805      * and burning.
1806      *
1807      * Calling conditions:
1808      *
1809      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1810      * transferred to `to`.
1811      * - When `from` is zero, `tokenId` will be minted for `to`.
1812      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1813      * - `from` cannot be the zero address.
1814      * - `to` cannot be the zero address.
1815      *
1816      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1817      */
1818     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1819 }
1820 
1821 // File: RumbleKongLeague.sol
1822 
1823 contract RumbleKongLeague is ERC721, Ownable {
1824     using SafeMath for uint256;
1825 
1826     string public RKL_PROVENANCE;
1827 
1828     uint256 public constant kongPrice = 0.08 ether;
1829 
1830     uint256 public constant maxKongPurchase = 20;
1831 
1832     uint256 public constant MAX_KONGS = 10_000;
1833 
1834     uint256 public REVEAL_TIMESTAMP;
1835 
1836     bool public saleIsActive = false;
1837 
1838     uint256 public startingIndexBlock;
1839 
1840     uint256 public startingIndex;
1841 
1842     bool private alreadyReserved = false;
1843 
1844     constructor(uint256 saleStart) ERC721("RumbleKongLeague", "RKL") {
1845         REVEAL_TIMESTAMP = saleStart + 86400;
1846     }
1847 
1848     function mintKong(uint256 numberOfTokens) external payable {
1849         _verifyMintKong(numberOfTokens);
1850         for (uint256 i = 0; i < numberOfTokens; i++) {
1851             uint256 mintIndex = totalSupply();
1852             if (mintIndex < MAX_KONGS) {
1853                 _safeMint(msg.sender, mintIndex);
1854             }
1855         }
1856         _setStartingIndexBlock();
1857     }
1858 
1859     function setStartingIndex() external {
1860         _verifySetStartingIndex();
1861         bytes32 hashOfBlock = blockhash(startingIndexBlock);
1862         startingIndex = uint256(hashOfBlock) % MAX_KONGS;
1863         if (hashOfBlock == bytes32(0)) {
1864             startingIndex = uint256(blockhash(block.number - 1)) % MAX_KONGS;
1865         }
1866         if (startingIndex == 0) {
1867             startingIndex = startingIndex.add(1);
1868         }
1869     }
1870 
1871     function _verifyMintKong(uint256 numberOfTokens) private {
1872         require(saleIsActive, "sale not active");
1873         require(numberOfTokens <= maxKongPurchase, "minting more than 20");
1874         require(
1875             totalSupply().add(numberOfTokens) <= MAX_KONGS,
1876             "purchase exceeds max supply"
1877         );
1878         require(
1879             kongPrice.mul(numberOfTokens) <= msg.value,
1880             "not enough ether sent"
1881         );
1882     }
1883 
1884     function _setStartingIndexBlock() private {
1885         if (
1886             startingIndexBlock == 0 &&
1887             (totalSupply() == MAX_KONGS || block.timestamp >= REVEAL_TIMESTAMP)
1888         ) {
1889             startingIndexBlock = block.number;
1890         }
1891     }
1892 
1893     function _verifySetStartingIndex() private {
1894         require(startingIndex == 0, "starting index is already set");
1895         require(startingIndexBlock != 0, "starting index block must be set");
1896     }
1897 
1898     function setRevealTimestamp(uint256 revealTimeStamp) external onlyOwner {
1899         REVEAL_TIMESTAMP = revealTimeStamp;
1900     }
1901 
1902     function setProvenanceHash(string memory provenanceHash)
1903         external
1904         onlyOwner
1905     {
1906         RKL_PROVENANCE = provenanceHash;
1907     }
1908 
1909     function setBaseURI(string memory baseURI) external onlyOwner {
1910         _setBaseURI(baseURI);
1911     }
1912 
1913     function flipSaleState() external onlyOwner {
1914         saleIsActive = !saleIsActive;
1915     }
1916 
1917     function emergencySetStartingIndexBlock() external onlyOwner {
1918         require(startingIndex == 0, "starting index is already set");
1919         startingIndexBlock = block.number;
1920     }
1921 
1922     function withdraw() external onlyOwner {
1923         uint256 balance = address(this).balance;
1924         msg.sender.transfer(balance);
1925     }
1926 
1927     function reserveKongs() external onlyOwner {
1928         require(!alreadyReserved, "cant reserve multiple times");
1929         for (uint256 i = 0; i < 30; i++) {
1930             _safeMint(msg.sender, i);
1931         }
1932         alreadyReserved = true;
1933     }
1934 }
