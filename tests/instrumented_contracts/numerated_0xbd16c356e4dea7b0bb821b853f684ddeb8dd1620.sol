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
1068 // Part: PixaTokenContract
1069 
1070 contract PixaTokenContract {
1071     function burn(uint256 amount) public virtual {
1072     }
1073     function transfer(address recipient, uint256 initamount) public virtual returns (bool) {
1074     }    
1075 
1076 }
1077 
1078 // Part: PixaWizardsContract
1079 
1080 contract PixaWizardsContract {
1081     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1082     }
1083     function balanceOf(address owner) public view returns (uint256) {
1084     }
1085 }
1086 
1087 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ERC165
1088 
1089 /**
1090  * @dev Implementation of the {IERC165} interface.
1091  *
1092  * Contracts may inherit from this and call {_registerInterface} to declare
1093  * their support of an interface.
1094  */
1095 abstract contract ERC165 is IERC165 {
1096     /*
1097      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1098      */
1099     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1100 
1101     /**
1102      * @dev Mapping of interface ids to whether or not it's supported.
1103      */
1104     mapping(bytes4 => bool) private _supportedInterfaces;
1105 
1106     constructor () internal {
1107         // Derived contracts need only register support for their own interfaces,
1108         // we register support for ERC165 itself here
1109         _registerInterface(_INTERFACE_ID_ERC165);
1110     }
1111 
1112     /**
1113      * @dev See {IERC165-supportsInterface}.
1114      *
1115      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1116      */
1117     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1118         return _supportedInterfaces[interfaceId];
1119     }
1120 
1121     /**
1122      * @dev Registers the contract as an implementer of the interface defined by
1123      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1124      * registering its interface id is not required.
1125      *
1126      * See {IERC165-supportsInterface}.
1127      *
1128      * Requirements:
1129      *
1130      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1131      */
1132     function _registerInterface(bytes4 interfaceId) internal virtual {
1133         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1134         _supportedInterfaces[interfaceId] = true;
1135     }
1136 }
1137 
1138 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC721
1139 
1140 /**
1141  * @dev Required interface of an ERC721 compliant contract.
1142  */
1143 interface IERC721 is IERC165 {
1144     /**
1145      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1146      */
1147     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1148 
1149     /**
1150      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1151      */
1152     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1153 
1154     /**
1155      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1156      */
1157     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1158 
1159     /**
1160      * @dev Returns the number of tokens in ``owner``'s account.
1161      */
1162     function balanceOf(address owner) external view returns (uint256 balance);
1163 
1164     /**
1165      * @dev Returns the owner of the `tokenId` token.
1166      *
1167      * Requirements:
1168      *
1169      * - `tokenId` must exist.
1170      */
1171     function ownerOf(uint256 tokenId) external view returns (address owner);
1172 
1173     /**
1174      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1175      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1176      *
1177      * Requirements:
1178      *
1179      * - `from` cannot be the zero address.
1180      * - `to` cannot be the zero address.
1181      * - `tokenId` token must exist and be owned by `from`.
1182      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1188 
1189     /**
1190      * @dev Transfers `tokenId` token from `from` to `to`.
1191      *
1192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1193      *
1194      * Requirements:
1195      *
1196      * - `from` cannot be the zero address.
1197      * - `to` cannot be the zero address.
1198      * - `tokenId` token must be owned by `from`.
1199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function transferFrom(address from, address to, uint256 tokenId) external;
1204 
1205     /**
1206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1207      * The approval is cleared when the token is transferred.
1208      *
1209      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1210      *
1211      * Requirements:
1212      *
1213      * - The caller must own the token or be an approved operator.
1214      * - `tokenId` must exist.
1215      *
1216      * Emits an {Approval} event.
1217      */
1218     function approve(address to, uint256 tokenId) external;
1219 
1220     /**
1221      * @dev Returns the account approved for `tokenId` token.
1222      *
1223      * Requirements:
1224      *
1225      * - `tokenId` must exist.
1226      */
1227     function getApproved(uint256 tokenId) external view returns (address operator);
1228 
1229     /**
1230      * @dev Approve or remove `operator` as an operator for the caller.
1231      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1232      *
1233      * Requirements:
1234      *
1235      * - The `operator` cannot be the caller.
1236      *
1237      * Emits an {ApprovalForAll} event.
1238      */
1239     function setApprovalForAll(address operator, bool _approved) external;
1240 
1241     /**
1242      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1243      *
1244      * See {setApprovalForAll}
1245      */
1246     function isApprovedForAll(address owner, address operator) external view returns (bool);
1247 
1248     /**
1249       * @dev Safely transfers `tokenId` token from `from` to `to`.
1250       *
1251       * Requirements:
1252       *
1253       * - `from` cannot be the zero address.
1254       * - `to` cannot be the zero address.
1255       * - `tokenId` token must exist and be owned by `from`.
1256       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1257       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1258       *
1259       * Emits a {Transfer} event.
1260       */
1261     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1262 }
1263 
1264 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC721Enumerable
1265 
1266 /**
1267  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1268  * @dev See https://eips.ethereum.org/EIPS/eip-721
1269  */
1270 interface IERC721Enumerable is IERC721 {
1271 
1272     /**
1273      * @dev Returns the total amount of tokens stored by the contract.
1274      */
1275     function totalSupply() external view returns (uint256);
1276 
1277     /**
1278      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1279      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1280      */
1281     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1282 
1283     /**
1284      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1285      * Use along with {totalSupply} to enumerate all tokens.
1286      */
1287     function tokenByIndex(uint256 index) external view returns (uint256);
1288 }
1289 
1290 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC721Metadata
1291 
1292 /**
1293  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1294  * @dev See https://eips.ethereum.org/EIPS/eip-721
1295  */
1296 interface IERC721Metadata is IERC721 {
1297 
1298     /**
1299      * @dev Returns the token collection name.
1300      */
1301     function name() external view returns (string memory);
1302 
1303     /**
1304      * @dev Returns the token collection symbol.
1305      */
1306     function symbol() external view returns (string memory);
1307 
1308     /**
1309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1310      */
1311     function tokenURI(uint256 tokenId) external view returns (string memory);
1312 }
1313 
1314 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ERC721
1315 
1316 /**
1317  * @title ERC721 Non-Fungible Token Standard basic implementation
1318  * @dev see https://eips.ethereum.org/EIPS/eip-721
1319  */
1320 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1321     using SafeMath for uint256;
1322     using Address for address;
1323     using EnumerableSet for EnumerableSet.UintSet;
1324     using EnumerableMap for EnumerableMap.UintToAddressMap;
1325     using Strings for uint256;
1326 
1327     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1328     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1329     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1330 
1331     // Mapping from holder address to their (enumerable) set of owned tokens
1332     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1333 
1334     // Enumerable mapping from token ids to their owners
1335     EnumerableMap.UintToAddressMap private _tokenOwners;
1336 
1337     // Mapping from token ID to approved address
1338     mapping (uint256 => address) private _tokenApprovals;
1339 
1340     // Mapping from owner to operator approvals
1341     mapping (address => mapping (address => bool)) private _operatorApprovals;
1342 
1343     // Token name
1344     string private _name;
1345 
1346     // Token symbol
1347     string private _symbol;
1348 
1349     // Optional mapping for token URIs
1350     mapping (uint256 => string) private _tokenURIs;
1351 
1352     // Base URI
1353     string private _baseURI;
1354 
1355     /*
1356      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1357      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1358      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1359      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1360      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1361      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1362      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1363      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1364      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1365      *
1366      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1367      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1368      */
1369     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1370 
1371     /*
1372      *     bytes4(keccak256('name()')) == 0x06fdde03
1373      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1374      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1375      *
1376      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1377      */
1378     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1379 
1380     /*
1381      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1382      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1383      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1384      *
1385      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1386      */
1387     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1388 
1389     /**
1390      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1391      */
1392     constructor (string memory name_, string memory symbol_) public {
1393         _name = name_;
1394         _symbol = symbol_;
1395 
1396         // register the supported interfaces to conform to ERC721 via ERC165
1397         _registerInterface(_INTERFACE_ID_ERC721);
1398         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1399         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-balanceOf}.
1404      */
1405     function balanceOf(address owner) public view virtual override returns (uint256) {
1406         require(owner != address(0), "ERC721: balance query for the zero address");
1407         return _holderTokens[owner].length();
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-ownerOf}.
1412      */
1413     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1414         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1415     }
1416 
1417     /**
1418      * @dev See {IERC721Metadata-name}.
1419      */
1420     function name() public view virtual override returns (string memory) {
1421         return _name;
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Metadata-symbol}.
1426      */
1427     function symbol() public view virtual override returns (string memory) {
1428         return _symbol;
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Metadata-tokenURI}.
1433      */
1434     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1435         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1436 
1437         string memory _tokenURI = _tokenURIs[tokenId];
1438         string memory base = baseURI();
1439 
1440         // If there is no base URI, return the token URI.
1441         if (bytes(base).length == 0) {
1442             return _tokenURI;
1443         }
1444         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1445         if (bytes(_tokenURI).length > 0) {
1446             return string(abi.encodePacked(base, _tokenURI));
1447         }
1448         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1449         return string(abi.encodePacked(base, tokenId.toString()));
1450     }
1451 
1452     /**
1453     * @dev Returns the base URI set via {_setBaseURI}. This will be
1454     * automatically added as a prefix in {tokenURI} to each token's URI, or
1455     * to the token ID if no specific URI is set for that token ID.
1456     */
1457     function baseURI() public view virtual returns (string memory) {
1458         return _baseURI;
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1463      */
1464     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1465         return _holderTokens[owner].at(index);
1466     }
1467 
1468     /**
1469      * @dev See {IERC721Enumerable-totalSupply}.
1470      */
1471     function totalSupply() public view virtual override returns (uint256) {
1472         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1473         return _tokenOwners.length();
1474     }
1475 
1476     /**
1477      * @dev See {IERC721Enumerable-tokenByIndex}.
1478      */
1479     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1480         (uint256 tokenId, ) = _tokenOwners.at(index);
1481         return tokenId;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-approve}.
1486      */
1487     function approve(address to, uint256 tokenId) public virtual override {
1488         address owner = ERC721.ownerOf(tokenId);
1489         require(to != owner, "ERC721: approval to current owner");
1490 
1491         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1492             "ERC721: approve caller is not owner nor approved for all"
1493         );
1494 
1495         _approve(to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-getApproved}.
1500      */
1501     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1502         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1503 
1504         return _tokenApprovals[tokenId];
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-setApprovalForAll}.
1509      */
1510     function setApprovalForAll(address operator, bool approved) public virtual override {
1511         require(operator != _msgSender(), "ERC721: approve to caller");
1512 
1513         _operatorApprovals[_msgSender()][operator] = approved;
1514         emit ApprovalForAll(_msgSender(), operator, approved);
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-isApprovedForAll}.
1519      */
1520     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1521         return _operatorApprovals[owner][operator];
1522     }
1523 
1524     /**
1525      * @dev See {IERC721-transferFrom}.
1526      */
1527     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1528         //solhint-disable-next-line max-line-length
1529         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1530 
1531         _transfer(from, to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721-safeTransferFrom}.
1536      */
1537     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1538         safeTransferFrom(from, to, tokenId, "");
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-safeTransferFrom}.
1543      */
1544     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1545         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1546         _safeTransfer(from, to, tokenId, _data);
1547     }
1548 
1549     /**
1550      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1551      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1552      *
1553      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1554      *
1555      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1556      * implement alternative mechanisms to perform token transfer, such as signature-based.
1557      *
1558      * Requirements:
1559      *
1560      * - `from` cannot be the zero address.
1561      * - `to` cannot be the zero address.
1562      * - `tokenId` token must exist and be owned by `from`.
1563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1568         _transfer(from, to, tokenId);
1569         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1570     }
1571 
1572     /**
1573      * @dev Returns whether `tokenId` exists.
1574      *
1575      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1576      *
1577      * Tokens start existing when they are minted (`_mint`),
1578      * and stop existing when they are burned (`_burn`).
1579      */
1580     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1581         return _tokenOwners.contains(tokenId);
1582     }
1583 
1584     /**
1585      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1586      *
1587      * Requirements:
1588      *
1589      * - `tokenId` must exist.
1590      */
1591     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1592         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1593         address owner = ERC721.ownerOf(tokenId);
1594         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1595     }
1596 
1597     /**
1598      * @dev Safely mints `tokenId` and transfers it to `to`.
1599      *
1600      * Requirements:
1601      d*
1602      * - `tokenId` must not exist.
1603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1604      *
1605      * Emits a {Transfer} event.
1606      */
1607     function _safeMint(address to, uint256 tokenId) internal virtual {
1608         _safeMint(to, tokenId, "");
1609     }
1610 
1611     /**
1612      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1613      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1614      */
1615     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1616         _mint(to, tokenId);
1617         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1618     }
1619 
1620     /**
1621      * @dev Mints `tokenId` and transfers it to `to`.
1622      *
1623      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1624      *
1625      * Requirements:
1626      *
1627      * - `tokenId` must not exist.
1628      * - `to` cannot be the zero address.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function _mint(address to, uint256 tokenId) internal virtual {
1633         require(to != address(0), "ERC721: mint to the zero address");
1634         require(!_exists(tokenId), "ERC721: token already minted");
1635 
1636         _beforeTokenTransfer(address(0), to, tokenId);
1637 
1638         _holderTokens[to].add(tokenId);
1639 
1640         _tokenOwners.set(tokenId, to);
1641 
1642         emit Transfer(address(0), to, tokenId);
1643     }
1644 
1645     /**
1646      * @dev Destroys `tokenId`.
1647      * The approval is cleared when the token is burned.
1648      *
1649      * Requirements:
1650      *
1651      * - `tokenId` must exist.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function _burn(uint256 tokenId) internal virtual {
1656         address owner = ERC721.ownerOf(tokenId); // internal owner
1657 
1658         _beforeTokenTransfer(owner, address(0), tokenId);
1659 
1660         // Clear approvals
1661         _approve(address(0), tokenId);
1662 
1663         // Clear metadata (if any)
1664         if (bytes(_tokenURIs[tokenId]).length != 0) {
1665             delete _tokenURIs[tokenId];
1666         }
1667 
1668         _holderTokens[owner].remove(tokenId);
1669 
1670         _tokenOwners.remove(tokenId);
1671 
1672         emit Transfer(owner, address(0), tokenId);
1673     }
1674 
1675     /**
1676      * @dev Transfers `tokenId` from `from` to `to`.
1677      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1678      *
1679      * Requirements:
1680      *
1681      * - `to` cannot be the zero address.
1682      * - `tokenId` token must be owned by `from`.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1687         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1688         require(to != address(0), "ERC721: transfer to the zero address");
1689 
1690         _beforeTokenTransfer(from, to, tokenId);
1691 
1692         // Clear approvals from the previous owner
1693         _approve(address(0), tokenId);
1694 
1695         _holderTokens[from].remove(tokenId);
1696         _holderTokens[to].add(tokenId);
1697 
1698         _tokenOwners.set(tokenId, to);
1699 
1700         emit Transfer(from, to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1705      *
1706      * Requirements:
1707      *
1708      * - `tokenId` must exist.
1709      */
1710     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1711         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1712         _tokenURIs[tokenId] = _tokenURI;
1713     }
1714 
1715     /**
1716      * @dev Internal function to set the base URI for all token IDs. It is
1717      * automatically added as a prefix to the value returned in {tokenURI},
1718      * or to the token ID if {tokenURI} is empty.
1719      */
1720     function _setBaseURI(string memory baseURI_) internal virtual {
1721         _baseURI = baseURI_;
1722     }
1723 
1724     /**
1725      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1726      * The call is not executed if the target address is not a contract.
1727      *
1728      * @param from address representing the previous owner of the given token ID
1729      * @param to target address that will receive the tokens
1730      * @param tokenId uint256 ID of the token to be transferred
1731      * @param _data bytes optional data to send along with the call
1732      * @return bool whether the call correctly returned the expected magic value
1733      */
1734     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1735         private returns (bool)
1736     {
1737         if (!to.isContract()) {
1738             return true;
1739         }
1740         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1741             IERC721Receiver(to).onERC721Received.selector,
1742             _msgSender(),
1743             from,
1744             tokenId,
1745             _data
1746         ), "ERC721: transfer to non ERC721Receiver implementer");
1747         bytes4 retval = abi.decode(returndata, (bytes4));
1748         return (retval == _ERC721_RECEIVED);
1749     }
1750 
1751     function _approve(address to, uint256 tokenId) private {
1752         _tokenApprovals[tokenId] = to;
1753         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1754     }
1755 
1756     /**
1757      * @dev Hook that is called before any token transfer. This includes minting
1758      * and burning.
1759      *
1760      * Calling conditions:
1761      *
1762      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1763      * transferred to `to`.
1764      * - When `from` is zero, `tokenId` will be minted for `to`.
1765      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1766      * - `from` cannot be the zero address.
1767      * - `to` cannot be the zero address.
1768      *
1769      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1770      */
1771     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1772 }
1773 
1774 // File: WizarDAO.sol
1775 
1776 contract WizarDAO is ERC721 {
1777     address private _owner = 0x5c2B89CBeC1a4996Aa5e81f3dFf8505ABeC6B34c;
1778     uint256 public tokenCounter = 0;
1779     bool public claimStatus = false;
1780     bool public pixavotingopen = false;
1781     bool public ethvotingopen = false;
1782     bool public daoLock = true; // if false, PixaLyfe still has control.
1783     bool public emergLock = true; // shuts down all functionality with DAO. Only works if daoLock is true. false = locked down.
1784     address payable wallet = 0x5c2B89CBeC1a4996Aa5e81f3dFf8505ABeC6B34c;
1785     address public wizardaddress = 0xc6b0B290176AaaB958441Dcb0c64ad057cBc39a0;
1786     address public pixaaddress = 0xeaf211cD484118a23AD71C3F9073189C43d1311c;
1787     address public rewardsContract = 0x717e63BF905fF0f433333B6f0a289b66462Cd8a1;
1788     address public pixarecipient;
1789     address payable pixainitiator;
1790     address payable ethinitiator;
1791     address payable ethrecipient;
1792     uint256 public pixaamount;
1793     uint256 public ethamount;
1794     string public pixareason;
1795     string public ethreason;
1796     uint256 public pixavotecount = 0;
1797     uint256 public ethvotecount = 0;
1798     uint256 public pixavoteamount = 10000;
1799     uint256 public ethvoteamount = 10000;
1800     string public wizardaoURI = "ipfs://QmTx79NMtkvK1HDnQT8noe1gZAHffvK24jT6MaUg6DPTx4";
1801     uint256 public burnAmount = 500; // this is the amount of $PIXA initially burned weekly from the WizarDAO wallet. DAO token owners can adjust this once per week.
1802     uint256 public rewardAmount = 2000; // amount of $PIXA leaving the WizarDAO wallet to the rewards contract. DAO token owners can adjust this once per week.
1803     uint256 public burnCap = 21;
1804     uint256 public rewardCap = 21;
1805     uint256 public txnReward = 1000;
1806     uint256 public newTimeFrame = 0;
1807     uint256 public newRewardsTimeFrame = 0;
1808     uint256 public pixatimestamp = 0;
1809     uint256 public ethtimestamp = 0;
1810     uint256 public pixacooldown = 0;
1811     uint256 public ethcooldown = 0;
1812     uint256 public weekly = 604800;
1813     mapping(uint256 => bool) public wizlist;
1814     mapping(uint256 => uint256) public burnvote;
1815     mapping(uint256 => uint256) public transvote;
1816     mapping(uint256 => uint256) public ethtransvote;
1817     mapping(uint256 => uint256) public rewardvote;
1818     constructor () public ERC721 ("The WizarDAO", "WAO"){
1819     }
1820 
1821     function claimTokenLoop() public {
1822         require(claimStatus);
1823         PixaWizardsContract nfts = PixaWizardsContract(wizardaddress);
1824         uint256 numNFTs = nfts.balanceOf(msg.sender);
1825         require(numNFTs > 0);
1826         for (uint256 i = 0; i < numNFTs; i++) {
1827             uint256 wizId = nfts.tokenOfOwnerByIndex(msg.sender, i);
1828             if (wizlist[wizId]) {
1829                 continue;
1830             }
1831             wizlist[wizId] = true;
1832             _safeMint(msg.sender, tokenCounter);
1833             _setTokenURI(tokenCounter, wizardaoURI);
1834             tokenCounter = tokenCounter + 1;
1835         }
1836     }
1837 
1838     function claimToken() public {
1839         require(claimStatus);
1840         PixaWizardsContract nfts = PixaWizardsContract(wizardaddress);
1841         uint256 numNFTs = nfts.balanceOf(msg.sender);
1842         require(numNFTs > 0);
1843         for (uint256 i = 0; i < numNFTs; i++) {
1844             uint256 wizId = nfts.tokenOfOwnerByIndex(msg.sender, i);
1845             if (wizlist[wizId]) {
1846                 continue;
1847            }
1848             wizlist[wizId] = true;
1849             i = i+numNFTs;
1850             _safeMint(msg.sender, tokenCounter);
1851             _setTokenURI(tokenCounter, wizardaoURI);
1852             tokenCounter = tokenCounter + 1;
1853         }
1854     }
1855 
1856 
1857     // burn rate //////////////////////////////////////////
1858 
1859     function weeklyBurn() public {
1860         require(block.timestamp > newTimeFrame);
1861         require(emergLock);
1862         require(balanceOf(msg.sender) > 0);
1863         PixaTokenContract pixa = PixaTokenContract(pixaaddress);
1864         pixa.burn(burnAmount);
1865         pixa.transfer(msg.sender, txnReward);
1866         newTimeFrame = block.timestamp + weekly;
1867     }
1868 
1869     function burnVoting(uint256 personalBurn) public {
1870         require(personalBurn > 0);
1871         require(personalBurn < burnCap);
1872         require(emergLock);
1873         require(balanceOf(msg.sender) > 0);
1874         uint256 numNFTs = balanceOf(msg.sender);
1875         for (uint256 i = 0; i < numNFTs; i++) {
1876             uint256 daoId = tokenOfOwnerByIndex(msg.sender, i);
1877             if (burnvote[daoId] > block.timestamp) {
1878                 continue;
1879             }
1880             burnvote[daoId] = block.timestamp + weekly;
1881 
1882             if (burnAmount > 200) {
1883                 burnAmount = personalBurn + burnAmount - 10;
1884             } else {
1885                 burnAmount = burnAmount + 10;
1886             }
1887         }
1888     }
1889 
1890     // Rewards rate //////////////////////////////////////////////
1891 
1892     function weeklyRewards() public {
1893         require(block.timestamp > newRewardsTimeFrame);
1894         require(emergLock);
1895         require(balanceOf(msg.sender) > 0);
1896         PixaTokenContract pixa = PixaTokenContract(pixaaddress);
1897         pixa.transfer(rewardsContract, rewardAmount);
1898         pixa.transfer(msg.sender, txnReward);
1899         newRewardsTimeFrame = block.timestamp + weekly;
1900     }
1901 
1902     function rewardsVoting(uint256 personalRewards) public {
1903         require(personalRewards > 0);
1904         require(personalRewards < rewardCap);
1905         require(emergLock);
1906         require(balanceOf(msg.sender) > 0);
1907         uint256 numNFTs = balanceOf(msg.sender);
1908         for (uint256 i = 0; i < numNFTs; i++) {
1909             uint256 daoId = tokenOfOwnerByIndex(msg.sender, i);
1910             if (rewardvote[daoId] > block.timestamp) {
1911                 continue;
1912             }
1913             rewardvote[daoId] = block.timestamp + weekly;
1914 
1915             if (rewardAmount > 200) {
1916                 rewardAmount = personalRewards + rewardAmount - 10;
1917             } else {
1918                 rewardAmount = rewardAmount + 10;
1919             }
1920         }
1921     }
1922 
1923     // PIXA transfer voting /////////////////////////////////////
1924 
1925     function proposeTransferPixa(address payable recipient, uint256 amount, string memory reason) public payable {
1926         require(emergLock);
1927         require(balanceOf(msg.sender) > 0);
1928         require(msg.value == 100000000000000000);
1929         require(pixacooldown < block.timestamp);
1930 
1931         pixaamount = amount;
1932         pixarecipient = recipient;
1933         pixareason = reason;
1934         pixainitiator = msg.sender;
1935         pixatimestamp = block.timestamp + weekly; // 1 week minimum voting period
1936         pixavotingopen = true; // flip toggle to open voting
1937     }
1938 
1939     function votingTransferPixa(bool tvote) public {
1940         require(emergLock);
1941         require(pixavotingopen);
1942         require(balanceOf(msg.sender) > 0);
1943         uint256 numNFTs = balanceOf(msg.sender);
1944         for (uint256 i = 0; i < numNFTs; i++) {
1945             uint256 daoId = tokenOfOwnerByIndex(msg.sender, i);
1946             if (transvote[daoId] > block.timestamp) {
1947                 continue;
1948             }
1949             transvote[daoId] = block.timestamp + weekly;
1950             pixavotecount = pixavotecount + 1;
1951 
1952             if (tvote) {
1953                 pixavoteamount = pixavoteamount + 1;
1954             }
1955             else {
1956                 pixavoteamount = pixavoteamount - 1;
1957             }
1958         }
1959     }
1960 
1961     function initiateTransferPixa() public {
1962         require(emergLock);
1963         require(balanceOf(msg.sender) > 0);
1964         require(pixavotecount > 100);
1965         require(block.timestamp > pixatimestamp);
1966         require(100000000000000000 <= getBalance()); // make sure enough eth to pay back initiator
1967         
1968         if (pixavoteamount > 10000) {
1969             PixaTokenContract pixa = PixaTokenContract(pixaaddress);
1970             pixa.transfer(pixarecipient, pixaamount);
1971             pixa.transfer(pixainitiator, 500);//bonus pixa for successful vote
1972             pixa.transfer(msg.sender, 100) ; //bonus for ending the vote   
1973             pixainitiator.transfer(100000000000000000); //return eth for successful vote                
1974 
1975             pixavoteamount = 10000;
1976             pixavotecount = 0;
1977             pixavotingopen = false;
1978             pixacooldown = block.timestamp + weekly; // week long cool down between votes
1979             pixareason = "blank";
1980 
1981         }
1982         else {
1983             PixaTokenContract pixa = PixaTokenContract(pixaaddress);
1984             pixa.transfer(msg.sender, 100); // bonus for ending the vote
1985 
1986             pixavoteamount = 10000;
1987             pixavotecount = 0;
1988             pixavotingopen = false;
1989             pixacooldown = block.timestamp + weekly; // week long cool down between votes
1990             pixareason = "blank";
1991         } 
1992 
1993     }
1994 
1995     // ETH transfer voting /////////////////////////////////////////////////
1996 
1997     function proposeTransferEth(address payable recipient, uint256 amount, string memory reason) public payable {
1998         require(emergLock);
1999         require(balanceOf(msg.sender) > 0);
2000         require(msg.value == 100000000000000000);
2001         require(ethcooldown < block.timestamp);
2002 
2003         ethamount = amount;
2004         ethrecipient = recipient;
2005         ethreason = reason;
2006         ethinitiator = msg.sender;
2007         ethtimestamp = block.timestamp + weekly; // 1 week minimum voting period
2008         ethvotingopen = true; // flip toggle to open voting
2009     }
2010 
2011     function votingTransferEth(bool tvote) public {
2012         require(emergLock);
2013         require(ethvotingopen);
2014         require(balanceOf(msg.sender) > 0);
2015         uint256 numNFTs = balanceOf(msg.sender);
2016         for (uint256 i = 0; i < numNFTs; i++) {
2017             uint256 daoId = tokenOfOwnerByIndex(msg.sender, i);
2018             if (ethtransvote[daoId] > block.timestamp) {
2019                 continue;
2020             }
2021             ethtransvote[daoId] = block.timestamp + weekly;
2022             ethvotecount = ethvotecount + 1;
2023 
2024             if (tvote) {
2025                 ethvoteamount = ethvoteamount + 1;
2026             }
2027             else {
2028                 ethvoteamount = ethvoteamount - 1;
2029             }
2030         }
2031     }
2032 
2033     function initiateTransferEth() public {
2034         require(emergLock);
2035         require(balanceOf(msg.sender) > 0);
2036         require(ethvotecount > 100);
2037         require(block.timestamp > ethtimestamp);
2038         require(100000000000000000 <= getBalance()); // make sure enough eth to pay back initiator
2039         
2040         if (ethvoteamount > 10000) {
2041             PixaTokenContract pixa = PixaTokenContract(pixaaddress);
2042             ethrecipient.transfer(ethamount);
2043             pixa.transfer(ethinitiator, 500);//bonus pixa for successful vote
2044             pixa.transfer(msg.sender, 100) ; //bonus for ending the vote   
2045             ethinitiator.transfer(100000000000000000); //return eth for successful vote                
2046 
2047             ethvoteamount = 10000;
2048             ethvotecount = 0;
2049             ethvotingopen = false;
2050             ethcooldown = block.timestamp + weekly; // week long cool down between votes
2051             ethreason = "blank";
2052 
2053         }
2054         else {
2055             PixaTokenContract pixa = PixaTokenContract(pixaaddress);
2056             pixa.transfer(msg.sender, 100); // bonus for ending the vote
2057 
2058             ethvoteamount = 10000;
2059             ethvotecount = 0;
2060             ethvotingopen = false;
2061             ethcooldown = block.timestamp + weekly; // week long cool down between votes
2062             ethreason = "blank";
2063         } 
2064 
2065     }
2066 
2067     // Allow access to other WizarDAO contracts to DAO eth and $PIXA supply /////////////////////////////////
2068 
2069     function setRewardsContract(address newcontract) public {
2070         require(daoLock);
2071         require(msg.sender == wallet);
2072         rewardsContract = newcontract;
2073     }
2074 
2075     function changeDaoURI(string memory inputURI) public {
2076         require(daoLock);
2077         require(msg.sender == wallet);
2078         wizardaoURI = inputURI;
2079     }
2080 
2081     function startClaim() public {
2082         require(daoLock);
2083         require(msg.sender == wallet);
2084         claimStatus = true;
2085     }
2086 
2087     function stopClaim() public {
2088         require(daoLock);
2089         require(msg.sender == wallet);
2090         claimStatus = false;
2091     }
2092         
2093     function engageEmergLock() public {
2094         require(daoLock);
2095         require(msg.sender == wallet);
2096         emergLock = false;
2097     }
2098 
2099     function stopEmergLock() public {
2100         require(daoLock);
2101         require(msg.sender == wallet);
2102         emergLock = true;
2103     }
2104 
2105     function lockDAO() public {
2106         require(msg.sender == wallet);
2107         daoLock = false;
2108     }
2109 
2110     function getBalance() public view returns (uint256) {
2111         return address(this).balance;
2112     }
2113 
2114     function withdrawAmount(uint256 amount, uint256 transferpamount) public {
2115         require(daoLock);
2116         require(emergLock);
2117         require(msg.sender == wallet);
2118         require(amount <= getBalance());
2119         msg.sender.transfer(amount);
2120         PixaTokenContract pixa = PixaTokenContract(pixaaddress);
2121         pixa.transfer(msg.sender, transferpamount);
2122     }    
2123 
2124     function owner() public view virtual returns (address) {
2125         return _owner;
2126     }
2127 
2128     function _setOwner(address newOwner) private {
2129         require(msg.sender == wallet);
2130         address oldOwner = _owner;
2131         _owner = newOwner;
2132     }
2133 
2134     receive() external payable {
2135     }
2136 
2137 }
