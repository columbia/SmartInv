1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC165 standard, as defined in the
27  * https://eips.ethereum.org/EIPS/eip-165[EIP].
28  *
29  * Implementers can declare support of contract interfaces, which can then be
30  * queried by others ({ERC165Checker}).
31  *
32  * For an implementation, see {ERC165}.
33  */
34 interface IERC165 {
35     /**
36      * @dev Returns true if this contract implements the interface defined by
37      * `interfaceId`. See the corresponding
38      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
39      * to learn more about how these ids are created.
40      *
41      * This function call must use less than 30 000 gas.
42      */
43     function supportsInterface(bytes4 interfaceId) external view returns (bool);
44 }
45 
46 /**
47  * @dev Collection of functions related to the address type
48  */
49 library Address {
50     /**
51      * @dev Returns true if `account` is a contract.
52      *
53      * [IMPORTANT]
54      * ====
55      * It is unsafe to assume that an address for which this function returns
56      * false is an externally-owned account (EOA) and not a contract.
57      *
58      * Among others, `isContract` will return false for the following
59      * types of addresses:
60      *
61      *  - an externally-owned account
62      *  - a contract in construction
63      *  - an address where a contract will be created
64      *  - an address where a contract lived, but was destroyed
65      * ====
66      */
67     function isContract(address account) internal view returns (bool) {
68         // This method relies on extcodesize, which returns 0 for contracts in
69         // construction, since the code is only stored at the end of the
70         // constructor execution.
71 
72         uint256 size;
73         // solhint-disable-next-line no-inline-assembly
74         assembly { size := extcodesize(account) }
75         return size > 0;
76     }
77 
78     /**
79      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
80      * `recipient`, forwarding all available gas and reverting on errors.
81      *
82      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
83      * of certain opcodes, possibly making contracts go over the 2300 gas limit
84      * imposed by `transfer`, making them unable to receive funds via
85      * `transfer`. {sendValue} removes this limitation.
86      *
87      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
88      *
89      * IMPORTANT: because control is transferred to `recipient`, care must be
90      * taken to not create reentrancy vulnerabilities. Consider using
91      * {ReentrancyGuard} or the
92      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
93      */
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     /**
103      * @dev Performs a Solidity function call using a low level `call`. A
104      * plain`call` is an unsafe replacement for a function call: use this
105      * function instead.
106      *
107      * If `target` reverts with a revert reason, it is bubbled up by this
108      * function (like regular Solidity function calls).
109      *
110      * Returns the raw returned data. To convert to the expected return value,
111      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
112      *
113      * Requirements:
114      *
115      * - `target` must be a contract.
116      * - calling `target` with `data` must not revert.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
121       return functionCall(target, data, "Address: low-level call failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
126      * `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, 0, errorMessage);
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
136      * but also transferring `value` wei to `target`.
137      *
138      * Requirements:
139      *
140      * - the calling contract must have an ETH balance of at least `value`.
141      * - the called Solidity function must be `payable`.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
151      * with `errorMessage` as a fallback revert reason when `target` reverts.
152      *
153      * _Available since v3.1._
154      */
155     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
156         require(address(this).balance >= value, "Address: insufficient balance for call");
157         require(isContract(target), "Address: call to non-contract");
158 
159         // solhint-disable-next-line avoid-low-level-calls
160         (bool success, bytes memory returndata) = target.call{ value: value }(data);
161         return _verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
171         return functionStaticCall(target, data, "Address: low-level static call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
181         require(isContract(target), "Address: static call to non-contract");
182 
183         // solhint-disable-next-line avoid-low-level-calls
184         (bool success, bytes memory returndata) = target.staticcall(data);
185         return _verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         // solhint-disable-next-line avoid-low-level-calls
208         (bool success, bytes memory returndata) = target.delegatecall(data);
209         return _verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
213         if (success) {
214             return returndata;
215         } else {
216             // Look for revert reason and bubble it up if present
217             if (returndata.length > 0) {
218                 // The easiest way to bubble the revert reason is using memory via assembly
219 
220                 // solhint-disable-next-line no-inline-assembly
221                 assembly {
222                     let returndata_size := mload(returndata)
223                     revert(add(32, returndata), returndata_size)
224                 }
225             } else {
226                 revert(errorMessage);
227             }
228         }
229     }
230 }
231 
232 /**
233  * @dev Library for managing
234  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
235  * types.
236  *
237  * Sets have the following properties:
238  *
239  * - Elements are added, removed, and checked for existence in constant time
240  * (O(1)).
241  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
242  *
243  * ```
244  * contract Example {
245  *     // Add the library methods
246  *     using EnumerableSet for EnumerableSet.AddressSet;
247  *
248  *     // Declare a set state variable
249  *     EnumerableSet.AddressSet private mySet;
250  * }
251  * ```
252  *
253  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
254  * and `uint256` (`UintSet`) are supported.
255  */
256 library EnumerableSet {
257     // To implement this library for multiple types with as little code
258     // repetition as possible, we write it in terms of a generic Set type with
259     // bytes32 values.
260     // The Set implementation uses private functions, and user-facing
261     // implementations (such as AddressSet) are just wrappers around the
262     // underlying Set.
263     // This means that we can only create new EnumerableSets for types that fit
264     // in bytes32.
265 
266     struct Set {
267         // Storage of set values
268         bytes32[] _values;
269 
270         // Position of the value in the `values` array, plus 1 because index 0
271         // means a value is not in the set.
272         mapping (bytes32 => uint256) _indexes;
273     }
274 
275     /**
276      * @dev Add a value to a set. O(1).
277      *
278      * Returns true if the value was added to the set, that is if it was not
279      * already present.
280      */
281     function _add(Set storage set, bytes32 value) private returns (bool) {
282         if (!_contains(set, value)) {
283             set._values.push(value);
284             // The value is stored at length-1, but we add 1 to all indexes
285             // and use 0 as a sentinel value
286             set._indexes[value] = set._values.length;
287             return true;
288         } else {
289             return false;
290         }
291     }
292 
293     /**
294      * @dev Removes a value from a set. O(1).
295      *
296      * Returns true if the value was removed from the set, that is if it was
297      * present.
298      */
299     function _remove(Set storage set, bytes32 value) private returns (bool) {
300         // We read and store the value's index to prevent multiple reads from the same storage slot
301         uint256 valueIndex = set._indexes[value];
302 
303         if (valueIndex != 0) { // Equivalent to contains(set, value)
304             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
305             // the array, and then remove the last element (sometimes called as 'swap and pop').
306             // This modifies the order of the array, as noted in {at}.
307 
308             uint256 toDeleteIndex = valueIndex - 1;
309             uint256 lastIndex = set._values.length - 1;
310 
311             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
312             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
313 
314             bytes32 lastvalue = set._values[lastIndex];
315 
316             // Move the last value to the index where the value to delete is
317             set._values[toDeleteIndex] = lastvalue;
318             // Update the index for the moved value
319             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
320 
321             // Delete the slot where the moved value was stored
322             set._values.pop();
323 
324             // Delete the index for the deleted slot
325             delete set._indexes[value];
326 
327             return true;
328         } else {
329             return false;
330         }
331     }
332 
333     /**
334      * @dev Returns true if the value is in the set. O(1).
335      */
336     function _contains(Set storage set, bytes32 value) private view returns (bool) {
337         return set._indexes[value] != 0;
338     }
339 
340     /**
341      * @dev Returns the number of values on the set. O(1).
342      */
343     function _length(Set storage set) private view returns (uint256) {
344         return set._values.length;
345     }
346 
347    /**
348     * @dev Returns the value stored at position `index` in the set. O(1).
349     *
350     * Note that there are no guarantees on the ordering of values inside the
351     * array, and it may change when more values are added or removed.
352     *
353     * Requirements:
354     *
355     * - `index` must be strictly less than {length}.
356     */
357     function _at(Set storage set, uint256 index) private view returns (bytes32) {
358         require(set._values.length > index, "EnumerableSet: index out of bounds");
359         return set._values[index];
360     }
361 
362     // Bytes32Set
363 
364     struct Bytes32Set {
365         Set _inner;
366     }
367 
368     /**
369      * @dev Add a value to a set. O(1).
370      *
371      * Returns true if the value was added to the set, that is if it was not
372      * already present.
373      */
374     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
375         return _add(set._inner, value);
376     }
377 
378     /**
379      * @dev Removes a value from a set. O(1).
380      *
381      * Returns true if the value was removed from the set, that is if it was
382      * present.
383      */
384     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
385         return _remove(set._inner, value);
386     }
387 
388     /**
389      * @dev Returns true if the value is in the set. O(1).
390      */
391     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
392         return _contains(set._inner, value);
393     }
394 
395     /**
396      * @dev Returns the number of values in the set. O(1).
397      */
398     function length(Bytes32Set storage set) internal view returns (uint256) {
399         return _length(set._inner);
400     }
401 
402    /**
403     * @dev Returns the value stored at position `index` in the set. O(1).
404     *
405     * Note that there are no guarantees on the ordering of values inside the
406     * array, and it may change when more values are added or removed.
407     *
408     * Requirements:
409     *
410     * - `index` must be strictly less than {length}.
411     */
412     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
413         return _at(set._inner, index);
414     }
415 
416     // AddressSet
417 
418     struct AddressSet {
419         Set _inner;
420     }
421 
422     /**
423      * @dev Add a value to a set. O(1).
424      *
425      * Returns true if the value was added to the set, that is if it was not
426      * already present.
427      */
428     function add(AddressSet storage set, address value) internal returns (bool) {
429         return _add(set._inner, bytes32(uint256(uint160(value))));
430     }
431 
432     /**
433      * @dev Removes a value from a set. O(1).
434      *
435      * Returns true if the value was removed from the set, that is if it was
436      * present.
437      */
438     function remove(AddressSet storage set, address value) internal returns (bool) {
439         return _remove(set._inner, bytes32(uint256(uint160(value))));
440     }
441 
442     /**
443      * @dev Returns true if the value is in the set. O(1).
444      */
445     function contains(AddressSet storage set, address value) internal view returns (bool) {
446         return _contains(set._inner, bytes32(uint256(uint160(value))));
447     }
448 
449     /**
450      * @dev Returns the number of values in the set. O(1).
451      */
452     function length(AddressSet storage set) internal view returns (uint256) {
453         return _length(set._inner);
454     }
455 
456    /**
457     * @dev Returns the value stored at position `index` in the set. O(1).
458     *
459     * Note that there are no guarantees on the ordering of values inside the
460     * array, and it may change when more values are added or removed.
461     *
462     * Requirements:
463     *
464     * - `index` must be strictly less than {length}.
465     */
466     function at(AddressSet storage set, uint256 index) internal view returns (address) {
467         return address(uint160(uint256(_at(set._inner, index))));
468     }
469 
470 
471     // UintSet
472 
473     struct UintSet {
474         Set _inner;
475     }
476 
477     /**
478      * @dev Add a value to a set. O(1).
479      *
480      * Returns true if the value was added to the set, that is if it was not
481      * already present.
482      */
483     function add(UintSet storage set, uint256 value) internal returns (bool) {
484         return _add(set._inner, bytes32(value));
485     }
486 
487     /**
488      * @dev Removes a value from a set. O(1).
489      *
490      * Returns true if the value was removed from the set, that is if it was
491      * present.
492      */
493     function remove(UintSet storage set, uint256 value) internal returns (bool) {
494         return _remove(set._inner, bytes32(value));
495     }
496 
497     /**
498      * @dev Returns true if the value is in the set. O(1).
499      */
500     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
501         return _contains(set._inner, bytes32(value));
502     }
503 
504     /**
505      * @dev Returns the number of values on the set. O(1).
506      */
507     function length(UintSet storage set) internal view returns (uint256) {
508         return _length(set._inner);
509     }
510 
511    /**
512     * @dev Returns the value stored at position `index` in the set. O(1).
513     *
514     * Note that there are no guarantees on the ordering of values inside the
515     * array, and it may change when more values are added or removed.
516     *
517     * Requirements:
518     *
519     * - `index` must be strictly less than {length}.
520     */
521     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
522         return uint256(_at(set._inner, index));
523     }
524 }
525 
526 /**
527  * @dev Library for managing an enumerable variant of Solidity's
528  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
529  * type.
530  *
531  * Maps have the following properties:
532  *
533  * - Entries are added, removed, and checked for existence in constant time
534  * (O(1)).
535  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
536  *
537  * ```
538  * contract Example {
539  *     // Add the library methods
540  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
541  *
542  *     // Declare a set state variable
543  *     EnumerableMap.UintToAddressMap private myMap;
544  * }
545  * ```
546  *
547  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
548  * supported.
549  */
550 library EnumerableMap {
551     // To implement this library for multiple types with as little code
552     // repetition as possible, we write it in terms of a generic Map type with
553     // bytes32 keys and values.
554     // The Map implementation uses private functions, and user-facing
555     // implementations (such as Uint256ToAddressMap) are just wrappers around
556     // the underlying Map.
557     // This means that we can only create new EnumerableMaps for types that fit
558     // in bytes32.
559 
560     struct MapEntry {
561         bytes32 _key;
562         bytes32 _value;
563     }
564 
565     struct Map {
566         // Storage of map keys and values
567         MapEntry[] _entries;
568 
569         // Position of the entry defined by a key in the `entries` array, plus 1
570         // because index 0 means a key is not in the map.
571         mapping (bytes32 => uint256) _indexes;
572     }
573 
574     /**
575      * @dev Adds a key-value pair to a map, or updates the value for an existing
576      * key. O(1).
577      *
578      * Returns true if the key was added to the map, that is if it was not
579      * already present.
580      */
581     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
582         // We read and store the key's index to prevent multiple reads from the same storage slot
583         uint256 keyIndex = map._indexes[key];
584 
585         if (keyIndex == 0) { // Equivalent to !contains(map, key)
586             map._entries.push(MapEntry({ _key: key, _value: value }));
587             // The entry is stored at length-1, but we add 1 to all indexes
588             // and use 0 as a sentinel value
589             map._indexes[key] = map._entries.length;
590             return true;
591         } else {
592             map._entries[keyIndex - 1]._value = value;
593             return false;
594         }
595     }
596 
597     /**
598      * @dev Removes a key-value pair from a map. O(1).
599      *
600      * Returns true if the key was removed from the map, that is if it was present.
601      */
602     function _remove(Map storage map, bytes32 key) private returns (bool) {
603         // We read and store the key's index to prevent multiple reads from the same storage slot
604         uint256 keyIndex = map._indexes[key];
605 
606         if (keyIndex != 0) { // Equivalent to contains(map, key)
607             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
608             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
609             // This modifies the order of the array, as noted in {at}.
610 
611             uint256 toDeleteIndex = keyIndex - 1;
612             uint256 lastIndex = map._entries.length - 1;
613 
614             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
615             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
616 
617             MapEntry storage lastEntry = map._entries[lastIndex];
618 
619             // Move the last entry to the index where the entry to delete is
620             map._entries[toDeleteIndex] = lastEntry;
621             // Update the index for the moved entry
622             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
623 
624             // Delete the slot where the moved entry was stored
625             map._entries.pop();
626 
627             // Delete the index for the deleted slot
628             delete map._indexes[key];
629 
630             return true;
631         } else {
632             return false;
633         }
634     }
635 
636     /**
637      * @dev Returns true if the key is in the map. O(1).
638      */
639     function _contains(Map storage map, bytes32 key) private view returns (bool) {
640         return map._indexes[key] != 0;
641     }
642 
643     /**
644      * @dev Returns the number of key-value pairs in the map. O(1).
645      */
646     function _length(Map storage map) private view returns (uint256) {
647         return map._entries.length;
648     }
649 
650    /**
651     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
652     *
653     * Note that there are no guarantees on the ordering of entries inside the
654     * array, and it may change when more entries are added or removed.
655     *
656     * Requirements:
657     *
658     * - `index` must be strictly less than {length}.
659     */
660     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
661         require(map._entries.length > index, "EnumerableMap: index out of bounds");
662 
663         MapEntry storage entry = map._entries[index];
664         return (entry._key, entry._value);
665     }
666 
667     /**
668      * @dev Tries to returns the value associated with `key`.  O(1).
669      * Does not revert if `key` is not in the map.
670      */
671     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
672         uint256 keyIndex = map._indexes[key];
673         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
674         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
675     }
676 
677     /**
678      * @dev Returns the value associated with `key`.  O(1).
679      *
680      * Requirements:
681      *
682      * - `key` must be in the map.
683      */
684     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
685         uint256 keyIndex = map._indexes[key];
686         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
687         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
688     }
689 
690     /**
691      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
692      *
693      * CAUTION: This function is deprecated because it requires allocating memory for the error
694      * message unnecessarily. For custom revert reasons use {_tryGet}.
695      */
696     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
697         uint256 keyIndex = map._indexes[key];
698         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
699         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
700     }
701 
702     // UintToAddressMap
703 
704     struct UintToAddressMap {
705         Map _inner;
706     }
707 
708     /**
709      * @dev Adds a key-value pair to a map, or updates the value for an existing
710      * key. O(1).
711      *
712      * Returns true if the key was added to the map, that is if it was not
713      * already present.
714      */
715     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
716         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
717     }
718 
719     /**
720      * @dev Removes a value from a set. O(1).
721      *
722      * Returns true if the key was removed from the map, that is if it was present.
723      */
724     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
725         return _remove(map._inner, bytes32(key));
726     }
727 
728     /**
729      * @dev Returns true if the key is in the map. O(1).
730      */
731     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
732         return _contains(map._inner, bytes32(key));
733     }
734 
735     /**
736      * @dev Returns the number of elements in the map. O(1).
737      */
738     function length(UintToAddressMap storage map) internal view returns (uint256) {
739         return _length(map._inner);
740     }
741 
742    /**
743     * @dev Returns the element stored at position `index` in the set. O(1).
744     * Note that there are no guarantees on the ordering of values inside the
745     * array, and it may change when more values are added or removed.
746     *
747     * Requirements:
748     *
749     * - `index` must be strictly less than {length}.
750     */
751     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
752         (bytes32 key, bytes32 value) = _at(map._inner, index);
753         return (uint256(key), address(uint160(uint256(value))));
754     }
755 
756     /**
757      * @dev Tries to returns the value associated with `key`.  O(1).
758      * Does not revert if `key` is not in the map.
759      *
760      * _Available since v3.4._
761      */
762     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
763         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
764         return (success, address(uint160(uint256(value))));
765     }
766 
767     /**
768      * @dev Returns the value associated with `key`.  O(1).
769      *
770      * Requirements:
771      *
772      * - `key` must be in the map.
773      */
774     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
775         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
776     }
777 
778     /**
779      * @dev Same as {get}, with a custom error message when `key` is not in the map.
780      *
781      * CAUTION: This function is deprecated because it requires allocating memory for the error
782      * message unnecessarily. For custom revert reasons use {tryGet}.
783      */
784     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
785         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
786     }
787 }
788 
789 /**
790  * @dev String operations.
791  */
792 library Strings {
793     bytes16 private constant alphabet = "0123456789abcdef";
794 
795     /**
796      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
797      */
798     function toString(uint256 value) internal pure returns (string memory) {
799         // Inspired by OraclizeAPI's implementation - MIT licence
800         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
801 
802         if (value == 0) {
803             return "0";
804         }
805         uint256 temp = value;
806         uint256 digits;
807         while (temp != 0) {
808             digits++;
809             temp /= 10;
810         }
811         bytes memory buffer = new bytes(digits);
812         while (value != 0) {
813             digits -= 1;
814             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
815             value /= 10;
816         }
817         return string(buffer);
818     }
819 
820     /**
821      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
822      */
823     function toHexString(uint256 value) internal pure returns (string memory) {
824         if (value == 0) {
825             return "0x00";
826         }
827         uint256 temp = value;
828         uint256 length = 0;
829         while (temp != 0) {
830             length++;
831             temp >>= 8;
832         }
833         return toHexString(value, length);
834     }
835 
836     /**
837      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
838      */
839     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
840         bytes memory buffer = new bytes(2 * length + 2);
841         buffer[0] = "0";
842         buffer[1] = "x";
843         for (uint256 i = 2 * length + 1; i > 1; --i) {
844             buffer[i] = alphabet[value & 0xf];
845             value >>= 4;
846         }
847         require(value == 0, "Strings: hex length insufficient");
848         return string(buffer);
849     }
850 
851 }
852 
853 /**
854  * @dev Required interface of an ERC721 compliant contract.
855  */
856 interface IERC721 is IERC165 {
857     /**
858      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
859      */
860     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
861 
862     /**
863      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
864      */
865     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
866 
867     /**
868      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
869      */
870     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
871 
872     /**
873      * @dev Returns the number of tokens in ``owner``'s account.
874      */
875     function balanceOf(address owner) external view returns (uint256 balance);
876 
877     /**
878      * @dev Returns the owner of the `tokenId` token.
879      *
880      * Requirements:
881      *
882      * - `tokenId` must exist.
883      */
884     function ownerOf(uint256 tokenId) external view returns (address owner);
885 
886     /**
887      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
888      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must exist and be owned by `from`.
895      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function safeTransferFrom(address from, address to, uint256 tokenId) external;
901 
902     /**
903      * @dev Transfers `tokenId` token from `from` to `to`.
904      *
905      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
913      *
914      * Emits a {Transfer} event.
915      */
916     function transferFrom(address from, address to, uint256 tokenId) external;
917 
918     /**
919      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
920      * The approval is cleared when the token is transferred.
921      *
922      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
923      *
924      * Requirements:
925      *
926      * - The caller must own the token or be an approved operator.
927      * - `tokenId` must exist.
928      *
929      * Emits an {Approval} event.
930      */
931     function approve(address to, uint256 tokenId) external;
932 
933     /**
934      * @dev Returns the account approved for `tokenId` token.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      */
940     function getApproved(uint256 tokenId) external view returns (address operator);
941 
942     /**
943      * @dev Approve or remove `operator` as an operator for the caller.
944      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
945      *
946      * Requirements:
947      *
948      * - The `operator` cannot be the caller.
949      *
950      * Emits an {ApprovalForAll} event.
951      */
952     function setApprovalForAll(address operator, bool _approved) external;
953 
954     /**
955      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
956      *
957      * See {setApprovalForAll}
958      */
959     function isApprovedForAll(address owner, address operator) external view returns (bool);
960 
961     /**
962       * @dev Safely transfers `tokenId` token from `from` to `to`.
963       *
964       * Requirements:
965       *
966       * - `from` cannot be the zero address.
967       * - `to` cannot be the zero address.
968       * - `tokenId` token must exist and be owned by `from`.
969       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
970       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971       *
972       * Emits a {Transfer} event.
973       */
974     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
975 }
976 
977 /**
978  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
979  * @dev See https://eips.ethereum.org/EIPS/eip-721
980  */
981 interface IERC721Metadata is IERC721 {
982 
983     /**
984      * @dev Returns the token collection name.
985      */
986     function name() external view returns (string memory);
987 
988     /**
989      * @dev Returns the token collection symbol.
990      */
991     function symbol() external view returns (string memory);
992 
993     /**
994      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
995      */
996     function tokenURI(uint256 tokenId) external view returns (string memory);
997 }
998 
999 /**
1000  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1001  * @dev See https://eips.ethereum.org/EIPS/eip-721
1002  */
1003 interface IERC721Enumerable is IERC721 {
1004 
1005     /**
1006      * @dev Returns the total amount of tokens stored by the contract.
1007      */
1008     function totalSupply() external view returns (uint256);
1009 
1010     /**
1011      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1012      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1015 
1016     /**
1017      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1018      * Use along with {totalSupply} to enumerate all tokens.
1019      */
1020     function tokenByIndex(uint256 index) external view returns (uint256);
1021 }
1022 
1023 /**
1024  * @title ERC721 token receiver interface
1025  * @dev Interface for any contract that wants to support safeTransfers
1026  * from ERC721 asset contracts.
1027  */
1028 interface IERC721Receiver {
1029     /**
1030      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1031      * by `operator` from `from`, this function is called.
1032      *
1033      * It must return its Solidity selector to confirm the token transfer.
1034      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1035      *
1036      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1037      */
1038     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1039 }
1040 
1041 
1042 /**
1043  * @dev Wrappers over Solidity's arithmetic operations.
1044  */
1045 library SafeMath {
1046     /**
1047      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1048      *
1049      * _Available since v3.4._
1050      */
1051     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1052         unchecked {
1053             uint256 c = a + b;
1054             if (c < a) return (false, 0);
1055             return (true, c);
1056         }
1057     }
1058 
1059     /**
1060      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1061      *
1062      * _Available since v3.4._
1063      */
1064     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1065         unchecked {
1066             if (b > a) return (false, 0);
1067             return (true, a - b);
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1073      *
1074      * _Available since v3.4._
1075      */
1076     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1077         unchecked {
1078             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1079             // benefit is lost if 'b' is also tested.
1080             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1081             if (a == 0) return (true, 0);
1082             uint256 c = a * b;
1083             if (c / a != b) return (false, 0);
1084             return (true, c);
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1090      *
1091      * _Available since v3.4._
1092      */
1093     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1094         unchecked {
1095             if (b == 0) return (false, 0);
1096             return (true, a / b);
1097         }
1098     }
1099 
1100     /**
1101      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1102      *
1103      * _Available since v3.4._
1104      */
1105     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1106         unchecked {
1107             if (b == 0) return (false, 0);
1108             return (true, a % b);
1109         }
1110     }
1111 
1112     /**
1113      * @dev Returns the addition of two unsigned integers, reverting on
1114      * overflow.
1115      *
1116      * Counterpart to Solidity's `+` operator.
1117      *
1118      * Requirements:
1119      *
1120      * - Addition cannot overflow.
1121      */
1122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1123         return a + b;
1124     }
1125 
1126     /**
1127      * @dev Returns the subtraction of two unsigned integers, reverting on
1128      * overflow (when the result is negative).
1129      *
1130      * Counterpart to Solidity's `-` operator.
1131      *
1132      * Requirements:
1133      *
1134      * - Subtraction cannot overflow.
1135      */
1136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1137         return a - b;
1138     }
1139 
1140     /**
1141      * @dev Returns the multiplication of two unsigned integers, reverting on
1142      * overflow.
1143      *
1144      * Counterpart to Solidity's `*` operator.
1145      *
1146      * Requirements:
1147      *
1148      * - Multiplication cannot overflow.
1149      */
1150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1151         return a * b;
1152     }
1153 
1154     /**
1155      * @dev Returns the integer division of two unsigned integers, reverting on
1156      * division by zero. The result is rounded towards zero.
1157      *
1158      * Counterpart to Solidity's `/` operator.
1159      *
1160      * Requirements:
1161      *
1162      * - The divisor cannot be zero.
1163      */
1164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1165         return a / b;
1166     }
1167 
1168     /**
1169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1170      * reverting when dividing by zero.
1171      *
1172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1173      * opcode (which leaves remaining gas untouched) while Solidity uses an
1174      * invalid opcode to revert (consuming all remaining gas).
1175      *
1176      * Requirements:
1177      *
1178      * - The divisor cannot be zero.
1179      */
1180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1181         return a % b;
1182     }
1183 
1184     /**
1185      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1186      * overflow (when the result is negative).
1187      *
1188      * CAUTION: This function is deprecated because it requires allocating memory for the error
1189      * message unnecessarily. For custom revert reasons use {trySub}.
1190      *
1191      * Counterpart to Solidity's `-` operator.
1192      *
1193      * Requirements:
1194      *
1195      * - Subtraction cannot overflow.
1196      */
1197     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1198         unchecked {
1199             require(b <= a, errorMessage);
1200             return a - b;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1206      * division by zero. The result is rounded towards zero.
1207      *
1208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1209      * opcode (which leaves remaining gas untouched) while Solidity uses an
1210      * invalid opcode to revert (consuming all remaining gas).
1211      *
1212      * Counterpart to Solidity's `/` operator. Note: this function uses a
1213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1214      * uses an invalid opcode to revert (consuming all remaining gas).
1215      *
1216      * Requirements:
1217      *
1218      * - The divisor cannot be zero.
1219      */
1220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1221         unchecked {
1222             require(b > 0, errorMessage);
1223             return a / b;
1224         }
1225     }
1226 
1227     /**
1228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1229      * reverting with custom message when dividing by zero.
1230      *
1231      * CAUTION: This function is deprecated because it requires allocating memory for the error
1232      * message unnecessarily. For custom revert reasons use {tryMod}.
1233      *
1234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1235      * opcode (which leaves remaining gas untouched) while Solidity uses an
1236      * invalid opcode to revert (consuming all remaining gas).
1237      *
1238      * Requirements:
1239      *
1240      * - The divisor cannot be zero.
1241      */
1242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1243         unchecked {
1244             require(b > 0, errorMessage);
1245             return a % b;
1246         }
1247     }
1248 }
1249 
1250 /**
1251  * @dev Contract module which provides a basic access control mechanism, where
1252  * there is an account (an owner) that can be granted exclusive access to
1253  * specific functions.
1254  *
1255  * By default, the owner account will be the one that deploys the contract. This
1256  * can later be changed with {transferOwnership}.
1257  *
1258  * This module is used through inheritance. It will make available the modifier
1259  * `onlyOwner`, which can be applied to your functions to restrict their use to
1260  * the owner.
1261  */
1262 abstract contract Ownable is Context {
1263     address private _owner;
1264 
1265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1266 
1267     /**
1268      * @dev Initializes the contract setting the deployer as the initial owner.
1269      */
1270     constructor () {
1271         address msgSender = _msgSender();
1272         _owner = msgSender;
1273         emit OwnershipTransferred(address(0), msgSender);
1274     }
1275 
1276     /**
1277      * @dev Returns the address of the current owner.
1278      */
1279     function owner() public view virtual returns (address) {
1280         return _owner;
1281     }
1282 
1283     /**
1284      * @dev Throws if called by any account other than the owner.
1285      */
1286     modifier onlyOwner() {
1287         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1288         _;
1289     }
1290 
1291     /**
1292      * @dev Leaves the contract without owner. It will not be possible to call
1293      * `onlyOwner` functions anymore. Can only be called by the current owner.
1294      *
1295      * NOTE: Renouncing ownership will leave the contract without an owner,
1296      * thereby removing any functionality that is only available to the owner.
1297      */
1298     function renounceOwnership() public virtual onlyOwner {
1299         emit OwnershipTransferred(_owner, address(0));
1300         _owner = address(0);
1301     }
1302 
1303     /**
1304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1305      * Can only be called by the current owner.
1306      */
1307     function transferOwnership(address newOwner) public virtual onlyOwner {
1308         require(newOwner != address(0), "Ownable: new owner is the zero address");
1309         emit OwnershipTransferred(_owner, newOwner);
1310         _owner = newOwner;
1311     }
1312 }
1313 
1314 /**
1315  * @dev Implementation of the {IERC165} interface.
1316  *
1317  * Contracts may inherit from this and call {_registerInterface} to declare
1318  * their support of an interface.
1319  */
1320 abstract contract ERC165 is IERC165 {
1321     /**
1322      * @dev Mapping of interface ids to whether or not it's supported.
1323      */
1324     mapping(bytes4 => bool) private _supportedInterfaces;
1325 
1326     constructor () {
1327         // Derived contracts need only register support for their own interfaces,
1328         // we register support for ERC165 itself here
1329         _registerInterface(type(IERC165).interfaceId);
1330     }
1331 
1332     /**
1333      * @dev See {IERC165-supportsInterface}.
1334      *
1335      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1336      */
1337     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1338         return _supportedInterfaces[interfaceId];
1339     }
1340 
1341     /**
1342      * @dev Registers the contract as an implementer of the interface defined by
1343      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1344      * registering its interface id is not required.
1345      *
1346      * See {IERC165-supportsInterface}.
1347      *
1348      * Requirements:
1349      *
1350      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1351      */
1352     function _registerInterface(bytes4 interfaceId) internal virtual {
1353         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1354         _supportedInterfaces[interfaceId] = true;
1355     }
1356 }
1357 
1358 
1359 /**
1360  * @title ERC721 Non-Fungible Token Standard basic implementation
1361  * @dev see https://eips.ethereum.org/EIPS/eip-721
1362  */
1363 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1364     using Address for address;
1365     using EnumerableSet for EnumerableSet.UintSet;
1366     using EnumerableMap for EnumerableMap.UintToAddressMap;
1367     using Strings for uint256;
1368 
1369     // Mapping from holder address to their (enumerable) set of owned tokens
1370     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1371 
1372     // Enumerable mapping from token ids to their owners
1373     EnumerableMap.UintToAddressMap private _tokenOwners;
1374 
1375     // Mapping from token ID to approved address
1376     mapping (uint256 => address) private _tokenApprovals;
1377 
1378     // Mapping from owner to operator approvals
1379     mapping (address => mapping (address => bool)) private _operatorApprovals;
1380 
1381     // Token name
1382     string private _name;
1383 
1384     // Token symbol
1385     string private _symbol;
1386 
1387     // Optional mapping for token URIs
1388     mapping (uint256 => string) private _tokenURIs;
1389 
1390     // Base URI
1391     string private _baseURI;
1392 
1393     /**
1394      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1395      */
1396     constructor (string memory name_, string memory symbol_) {
1397         _name = name_;
1398         _symbol = symbol_;
1399 
1400         // register the supported interfaces to conform to ERC721 via ERC165
1401         _registerInterface(type(IERC721).interfaceId);
1402         _registerInterface(type(IERC721Metadata).interfaceId);
1403         _registerInterface(type(IERC721Enumerable).interfaceId);
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-balanceOf}.
1408      */
1409     function balanceOf(address owner) public view virtual override returns (uint256) {
1410         require(owner != address(0), "ERC721: balance query for the zero address");
1411         return _holderTokens[owner].length();
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-ownerOf}.
1416      */
1417     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1418         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1419     }
1420 
1421     /**
1422      * @dev See {IERC721Metadata-name}.
1423      */
1424     function name() public view virtual override returns (string memory) {
1425         return _name;
1426     }
1427 
1428     /**
1429      * @dev See {IERC721Metadata-symbol}.
1430      */
1431     function symbol() public view virtual override returns (string memory) {
1432         return _symbol;
1433     }
1434 
1435     /**
1436      * @dev See {IERC721Metadata-tokenURI}.
1437      */
1438     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1439         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1440 
1441         string memory _tokenURI = _tokenURIs[tokenId];
1442         string memory base = baseURI();
1443 
1444         // If there is no base URI, return the token URI.
1445         if (bytes(base).length == 0) {
1446             return _tokenURI;
1447         }
1448         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1449         if (bytes(_tokenURI).length > 0) {
1450             return string(abi.encodePacked(base, _tokenURI));
1451         }
1452         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1453         return string(abi.encodePacked(base, tokenId.toString()));
1454     }
1455 
1456     /**
1457     * @dev Returns the base URI set via {_setBaseURI}. This will be
1458     * automatically added as a prefix in {tokenURI} to each token's URI, or
1459     * to the token ID if no specific URI is set for that token ID.
1460     */
1461     function baseURI() public view virtual returns (string memory) {
1462         return _baseURI;
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1467      */
1468     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1469         return _holderTokens[owner].at(index);
1470     }
1471 
1472     /**
1473      * @dev See {IERC721Enumerable-totalSupply}.
1474      */
1475     function totalSupply() public view virtual override returns (uint256) {
1476         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1477         return _tokenOwners.length();
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Enumerable-tokenByIndex}.
1482      */
1483     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1484         (uint256 tokenId, ) = _tokenOwners.at(index);
1485         return tokenId;
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-approve}.
1490      */
1491     function approve(address to, uint256 tokenId) public virtual override {
1492         address owner = ERC721.ownerOf(tokenId);
1493         require(to != owner, "ERC721: approval to current owner");
1494 
1495         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1496             "ERC721: approve caller is not owner nor approved for all"
1497         );
1498 
1499         _approve(to, tokenId);
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-getApproved}.
1504      */
1505     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1506         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1507 
1508         return _tokenApprovals[tokenId];
1509     }
1510 
1511     /**
1512      * @dev See {IERC721-setApprovalForAll}.
1513      */
1514     function setApprovalForAll(address operator, bool approved) public virtual override {
1515         require(operator != _msgSender(), "ERC721: approve to caller");
1516 
1517         _operatorApprovals[_msgSender()][operator] = approved;
1518         emit ApprovalForAll(_msgSender(), operator, approved);
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-isApprovedForAll}.
1523      */
1524     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1525         return _operatorApprovals[owner][operator];
1526     }
1527 
1528     /**
1529      * @dev See {IERC721-transferFrom}.
1530      */
1531     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1532         //solhint-disable-next-line max-line-length
1533         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1534 
1535         _transfer(from, to, tokenId);
1536     }
1537 
1538     /**
1539      * @dev See {IERC721-safeTransferFrom}.
1540      */
1541     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1542         safeTransferFrom(from, to, tokenId, "");
1543     }
1544 
1545     /**
1546      * @dev See {IERC721-safeTransferFrom}.
1547      */
1548     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1549         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1550         _safeTransfer(from, to, tokenId, _data);
1551     }
1552 
1553     /**
1554      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1555      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1556      *
1557      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1558      *
1559      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1560      * implement alternative mechanisms to perform token transfer, such as signature-based.
1561      *
1562      * Requirements:
1563      *
1564      * - `from` cannot be the zero address.
1565      * - `to` cannot be the zero address.
1566      * - `tokenId` token must exist and be owned by `from`.
1567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1568      *
1569      * Emits a {Transfer} event.
1570      */
1571     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1572         _transfer(from, to, tokenId);
1573         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1574     }
1575 
1576     /**
1577      * @dev Returns whether `tokenId` exists.
1578      *
1579      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1580      *
1581      * Tokens start existing when they are minted (`_mint`),
1582      * and stop existing when they are burned (`_burn`).
1583      */
1584     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1585         return _tokenOwners.contains(tokenId);
1586     }
1587 
1588     /**
1589      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1590      *
1591      * Requirements:
1592      *
1593      * - `tokenId` must exist.
1594      */
1595     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1596         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1597         address owner = ERC721.ownerOf(tokenId);
1598         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1599     }
1600 
1601     /**
1602      * @dev Safely mints `tokenId` and transfers it to `to`.
1603      *
1604      * Requirements:
1605      d*
1606      * - `tokenId` must not exist.
1607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _safeMint(address to, uint256 tokenId) internal virtual {
1612         _safeMint(to, tokenId, "");
1613     }
1614 
1615     /**
1616      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1617      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1618      */
1619     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1620         _mint(to, tokenId);
1621         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1622     }
1623 
1624     /**
1625      * @dev Mints `tokenId` and transfers it to `to`.
1626      *
1627      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1628      *
1629      * Requirements:
1630      *
1631      * - `tokenId` must not exist.
1632      * - `to` cannot be the zero address.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function _mint(address to, uint256 tokenId) internal virtual {
1637         require(to != address(0), "ERC721: mint to the zero address");
1638         require(!_exists(tokenId), "ERC721: token already minted");
1639 
1640         _beforeTokenTransfer(address(0), to, tokenId);
1641 
1642         _holderTokens[to].add(tokenId);
1643 
1644         _tokenOwners.set(tokenId, to);
1645 
1646         emit Transfer(address(0), to, tokenId);
1647     }
1648 
1649     /**
1650      * @dev Destroys `tokenId`.
1651      * The approval is cleared when the token is burned.
1652      *
1653      * Requirements:
1654      *
1655      * - `tokenId` must exist.
1656      *
1657      * Emits a {Transfer} event.
1658      */
1659     function _burn(uint256 tokenId) internal virtual {
1660         address owner = ERC721.ownerOf(tokenId); // internal owner
1661 
1662         _beforeTokenTransfer(owner, address(0), tokenId);
1663 
1664         // Clear approvals
1665         _approve(address(0), tokenId);
1666 
1667         // Clear metadata (if any)
1668         if (bytes(_tokenURIs[tokenId]).length != 0) {
1669             delete _tokenURIs[tokenId];
1670         }
1671 
1672         _holderTokens[owner].remove(tokenId);
1673 
1674         _tokenOwners.remove(tokenId);
1675 
1676         emit Transfer(owner, address(0), tokenId);
1677     }
1678 
1679     /**
1680      * @dev Transfers `tokenId` from `from` to `to`.
1681      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1682      *
1683      * Requirements:
1684      *
1685      * - `to` cannot be the zero address.
1686      * - `tokenId` token must be owned by `from`.
1687      *
1688      * Emits a {Transfer} event.
1689      */
1690     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1691         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1692         require(to != address(0), "ERC721: transfer to the zero address");
1693 
1694         _beforeTokenTransfer(from, to, tokenId);
1695 
1696         // Clear approvals from the previous owner
1697         _approve(address(0), tokenId);
1698 
1699         _holderTokens[from].remove(tokenId);
1700         _holderTokens[to].add(tokenId);
1701 
1702         _tokenOwners.set(tokenId, to);
1703 
1704         emit Transfer(from, to, tokenId);
1705     }
1706 
1707     /**
1708      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1709      *
1710      * Requirements:
1711      *
1712      * - `tokenId` must exist.
1713      */
1714     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1715         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1716         _tokenURIs[tokenId] = _tokenURI;
1717     }
1718 
1719     /**
1720      * @dev Internal function to set the base URI for all token IDs. It is
1721      * automatically added as a prefix to the value returned in {tokenURI},
1722      * or to the token ID if {tokenURI} is empty.
1723      */
1724     function _setBaseURI(string memory baseURI_) internal virtual {
1725         _baseURI = baseURI_;
1726     }
1727 
1728     /**
1729      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1730      * The call is not executed if the target address is not a contract.
1731      *
1732      * @param from address representing the previous owner of the given token ID
1733      * @param to target address that will receive the tokens
1734      * @param tokenId uint256 ID of the token to be transferred
1735      * @param _data bytes optional data to send along with the call
1736      * @return bool whether the call correctly returned the expected magic value
1737      */
1738     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1739         private returns (bool)
1740     {
1741         if (to.isContract()) {
1742             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1743                 return retval == IERC721Receiver(to).onERC721Received.selector;
1744             } catch (bytes memory reason) {
1745                 if (reason.length == 0) {
1746                     revert("ERC721: transfer to non ERC721Receiver implementer");
1747                 } else {
1748                     // solhint-disable-next-line no-inline-assembly
1749                     assembly {
1750                         revert(add(32, reason), mload(reason))
1751                     }
1752                 }
1753             }
1754         } else {
1755             return true;
1756         }
1757     }
1758 
1759     function _approve(address to, uint256 tokenId) private {
1760         _tokenApprovals[tokenId] = to;
1761         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1762     }
1763 
1764     /**
1765      * @dev Hook that is called before any token transfer. This includes minting
1766      * and burning.
1767      *
1768      * Calling conditions:
1769      *
1770      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1771      * transferred to `to`.
1772      * - When `from` is zero, `tokenId` will be minted for `to`.
1773      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1774      * - `from` cannot be the zero address.
1775      * - `to` cannot be the zero address.
1776      *
1777      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1778      */
1779     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1780 }
1781 
1782 contract TokenWords is ERC721, Ownable {
1783     uint256 private _price = 0;
1784     uint256 private _currTokenID = 0;
1785     uint256 private _maxSupply = 0;
1786 
1787     mapping (uint256 => string) private _tokenWords;
1788 
1789     event PriceUpdated(uint256 previousPrice, uint256 newPrice);
1790 
1791     event MaxSupplyUpdated(uint256 previousMaxSupply, uint256 newMaxSupply);
1792 
1793     event TokenWordsUpdated(uint256 indexed tokenID, string previousWords, string newWords);
1794 
1795     event TokenURIUpdated(uint256 indexed tokenID, string previousURI, string newURI);
1796 
1797     event TokenMinted(uint256 indexed tokenID, address indexed minter, address indexed recipient, string tokenWords, string tokenURI, uint256 price, uint256 payment);
1798 
1799     event TokenBurned(uint256 indexed tokenID, address indexed burner);
1800 
1801     event WithdrawCompleted(address indexed recipient, uint256 amount);
1802 
1803     event BaseURIUpdated(string prevBaseURI, string newBaseURI);
1804 
1805     constructor(string memory name, string memory symbol, string memory genesisWords, string memory genesisURI, uint256 __price, uint256 __maxSupply, string memory baseURI) ERC721(name, symbol) {
1806         _price = __price;
1807         _maxSupply = __maxSupply;
1808 
1809         _setBaseURI(baseURI);
1810 
1811         uint256 genesisTokenID = 0;
1812 
1813         _safeMint(msg.sender, genesisTokenID);
1814 
1815         _setTokenURI(genesisTokenID, genesisURI);
1816 
1817         _tokenWords[genesisTokenID] = genesisWords;
1818 
1819         emit TokenMinted(0, msg.sender, msg.sender, genesisWords, genesisURI, _price, 0);
1820     }
1821 
1822     function price() public view returns (uint256) {
1823         return _price;
1824     }
1825 
1826     function updatePrice(uint256 newPrice) public onlyOwner returns (uint256) {
1827         uint256 prevPrice = _price;
1828 
1829         _price = newPrice;
1830 
1831         emit PriceUpdated(prevPrice, newPrice);
1832 
1833         return prevPrice;
1834     }
1835     
1836     function maxSupply() public view returns (uint256) {
1837         return _maxSupply;
1838     }
1839 
1840     function updateMaxSupply(uint256 newMaxSupply) public onlyOwner returns (uint256) {
1841         require(totalSupply() <= newMaxSupply, "current total supply greater than the new max supply");
1842 
1843         uint256 prevMaxSupply = _maxSupply;
1844 
1845         _maxSupply = newMaxSupply;
1846 
1847         emit MaxSupplyUpdated(prevMaxSupply, newMaxSupply);
1848 
1849         return prevMaxSupply;
1850     }
1851 
1852     function updateBaseURI(string memory newBaseURI) public onlyOwner returns (string memory) {
1853         string memory prevBaseURI = baseURI();
1854 
1855         _setBaseURI(newBaseURI);
1856 
1857         emit BaseURIUpdated(prevBaseURI, newBaseURI);
1858 
1859         return prevBaseURI;
1860     }
1861 
1862     function tokenWords(uint256 tokenID) public view returns (string memory) {
1863         require(_exists(tokenID), "nonexistent token");
1864 
1865         return _tokenWords[tokenID];
1866     }
1867 
1868     function updateTokenWords(uint256 tokenID, string memory newWords) public returns (string memory) {
1869         require(_exists(tokenID), "nonexistent token");
1870 
1871         address tokenOwner = ownerOf(tokenID);
1872 
1873         require(msg.sender == tokenOwner, "access violation");
1874 
1875         string memory prevWords = _tokenWords[tokenID];
1876 
1877         _tokenWords[tokenID] = newWords;
1878 
1879         emit TokenWordsUpdated(tokenID, prevWords, newWords);
1880 
1881         return prevWords;
1882     }
1883 
1884     function updateTokenURI(uint256 tokenID, string memory newURI) public returns (string memory) {
1885         require(_exists(tokenID), "nonexistent token");
1886 
1887         address tokenOwner = ownerOf(tokenID);
1888 
1889         require(msg.sender == tokenOwner, "access violation");
1890 
1891         string memory prevURI = tokenURI(tokenID);
1892 
1893         _setTokenURI(tokenID, newURI);
1894 
1895         emit TokenURIUpdated(tokenID, prevURI, tokenURI(tokenID));
1896 
1897         return prevURI;
1898     }
1899 
1900     function mint(address to, uint256 tokenID, string memory __tokenWords, string memory __tokenURI) public payable returns (uint256) {
1901         require(msg.value >= _price, "insufficient payment");
1902         require(totalSupply() < maxSupply(), "supply limit reached");
1903         require(_exists(tokenID) == false, "existent token");
1904         require(tokenID < maxSupply(), "token overflow");
1905         require(to != address(0), "zero address");
1906         require(bytes(__tokenWords).length <= 15, "too much words");
1907 
1908         _safeMint(to, tokenID);
1909 
1910         _setTokenURI(tokenID, __tokenURI);
1911 
1912         _tokenWords[tokenID] = __tokenWords;
1913 
1914         emit TokenMinted(tokenID, msg.sender, to, __tokenWords, tokenURI(tokenID), _price, msg.value);
1915 
1916         return tokenID;
1917     }
1918 
1919     function burn(uint256 tokenID) public {
1920         require(_exists(tokenID), "nonexistent token");
1921 
1922         address tokenOwner = ownerOf(tokenID);
1923 
1924         require(msg.sender == tokenOwner, "access violation");
1925 
1926         _burn(tokenID);
1927 
1928         emit TokenBurned(tokenID, msg.sender);
1929     }
1930 
1931     function withdraw(address payable recipient, uint256 amount) public onlyOwner {
1932         require(recipient != address(0), "zero address");
1933         require(recipient.send(amount), "withdraw error");
1934 
1935         emit WithdrawCompleted(recipient, amount);
1936     }
1937 }