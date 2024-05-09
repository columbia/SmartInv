1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: IVendingMachine
9 
10 interface IVendingMachine {
11 
12 	function NFTMachineFor(uint256 NFTId, address _recipient) external;
13 }
14 
15 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
16 
17 /**
18  * @dev Collection of functions related to the address type
19  */
20 library Address {
21     /**
22      * @dev Returns true if `account` is a contract.
23      *
24      * [IMPORTANT]
25      * ====
26      * It is unsafe to assume that an address for which this function returns
27      * false is an externally-owned account (EOA) and not a contract.
28      *
29      * Among others, `isContract` will return false for the following
30      * types of addresses:
31      *
32      *  - an externally-owned account
33      *  - a contract in construction
34      *  - an address where a contract will be created
35      *  - an address where a contract lived, but was destroyed
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies in extcodesize, which returns 0 for contracts in
40         // construction, since the code is only stored at the end of the
41         // constructor execution.
42 
43         uint256 size;
44         // solhint-disable-next-line no-inline-assembly
45         assembly { size := extcodesize(account) }
46         return size > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
69         (bool success, ) = recipient.call{ value: amount }("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level `call`. A
75      * plain`call` is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If `target` reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
83      *
84      * Requirements:
85      *
86      * - `target` must be a contract.
87      * - calling `target` with `data` must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92       return functionCall(target, data, "Address: low-level call failed");
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
97      * `errorMessage` as a fallback revert reason when `target` reverts.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
102         return _functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
127         require(address(this).balance >= value, "Address: insufficient balance for call");
128         return _functionCallWithValue(target, data, value, errorMessage);
129     }
130 
131     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
132         require(isContract(target), "Address: call to non-contract");
133 
134         // solhint-disable-next-line avoid-low-level-calls
135         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
136         if (success) {
137             return returndata;
138         } else {
139             // Look for revert reason and bubble it up if present
140             if (returndata.length > 0) {
141                 // The easiest way to bubble the revert reason is using memory via assembly
142 
143                 // solhint-disable-next-line no-inline-assembly
144                 assembly {
145                     let returndata_size := mload(returndata)
146                     revert(add(32, returndata), returndata_size)
147                 }
148             } else {
149                 revert(errorMessage);
150             }
151         }
152     }
153 }
154 
155 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
156 
157 /*
158  * @dev Provides information about the current execution context, including the
159  * sender of the transaction and its data. While these are generally available
160  * via msg.sender and msg.data, they should not be accessed in such a direct
161  * manner, since when dealing with GSN meta-transactions the account sending and
162  * paying for execution may not be the actual sender (as far as an application
163  * is concerned).
164  *
165  * This contract is only required for intermediate, library-like contracts.
166  */
167 abstract contract Context {
168     function _msgSender() internal view virtual returns (address payable) {
169         return msg.sender;
170     }
171 
172     function _msgData() internal view virtual returns (bytes memory) {
173         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
174         return msg.data;
175     }
176 }
177 
178 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableMap
179 
180 /**
181  * @dev Library for managing an enumerable variant of Solidity's
182  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
183  * type.
184  *
185  * Maps have the following properties:
186  *
187  * - Entries are added, removed, and checked for existence in constant time
188  * (O(1)).
189  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
190  *
191  * ```
192  * contract Example {
193  *     // Add the library methods
194  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
195  *
196  *     // Declare a set state variable
197  *     EnumerableMap.UintToAddressMap private myMap;
198  * }
199  * ```
200  *
201  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
202  * supported.
203  */
204 library EnumerableMap {
205     // To implement this library for multiple types with as little code
206     // repetition as possible, we write it in terms of a generic Map type with
207     // bytes32 keys and values.
208     // The Map implementation uses private functions, and user-facing
209     // implementations (such as Uint256ToAddressMap) are just wrappers around
210     // the underlying Map.
211     // This means that we can only create new EnumerableMaps for types that fit
212     // in bytes32.
213 
214     struct MapEntry {
215         bytes32 _key;
216         bytes32 _value;
217     }
218 
219     struct Map {
220         // Storage of map keys and values
221         MapEntry[] _entries;
222 
223         // Position of the entry defined by a key in the `entries` array, plus 1
224         // because index 0 means a key is not in the map.
225         mapping (bytes32 => uint256) _indexes;
226     }
227 
228     /**
229      * @dev Adds a key-value pair to a map, or updates the value for an existing
230      * key. O(1).
231      *
232      * Returns true if the key was added to the map, that is if it was not
233      * already present.
234      */
235     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
236         // We read and store the key's index to prevent multiple reads from the same storage slot
237         uint256 keyIndex = map._indexes[key];
238 
239         if (keyIndex == 0) { // Equivalent to !contains(map, key)
240             map._entries.push(MapEntry({ _key: key, _value: value }));
241             // The entry is stored at length-1, but we add 1 to all indexes
242             // and use 0 as a sentinel value
243             map._indexes[key] = map._entries.length;
244             return true;
245         } else {
246             map._entries[keyIndex - 1]._value = value;
247             return false;
248         }
249     }
250 
251     /**
252      * @dev Removes a key-value pair from a map. O(1).
253      *
254      * Returns true if the key was removed from the map, that is if it was present.
255      */
256     function _remove(Map storage map, bytes32 key) private returns (bool) {
257         // We read and store the key's index to prevent multiple reads from the same storage slot
258         uint256 keyIndex = map._indexes[key];
259 
260         if (keyIndex != 0) { // Equivalent to contains(map, key)
261             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
262             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
263             // This modifies the order of the array, as noted in {at}.
264 
265             uint256 toDeleteIndex = keyIndex - 1;
266             uint256 lastIndex = map._entries.length - 1;
267 
268             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
269             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
270 
271             MapEntry storage lastEntry = map._entries[lastIndex];
272 
273             // Move the last entry to the index where the entry to delete is
274             map._entries[toDeleteIndex] = lastEntry;
275             // Update the index for the moved entry
276             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
277 
278             // Delete the slot where the moved entry was stored
279             map._entries.pop();
280 
281             // Delete the index for the deleted slot
282             delete map._indexes[key];
283 
284             return true;
285         } else {
286             return false;
287         }
288     }
289 
290     /**
291      * @dev Returns true if the key is in the map. O(1).
292      */
293     function _contains(Map storage map, bytes32 key) private view returns (bool) {
294         return map._indexes[key] != 0;
295     }
296 
297     /**
298      * @dev Returns the number of key-value pairs in the map. O(1).
299      */
300     function _length(Map storage map) private view returns (uint256) {
301         return map._entries.length;
302     }
303 
304    /**
305     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
306     *
307     * Note that there are no guarantees on the ordering of entries inside the
308     * array, and it may change when more entries are added or removed.
309     *
310     * Requirements:
311     *
312     * - `index` must be strictly less than {length}.
313     */
314     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
315         require(map._entries.length > index, "EnumerableMap: index out of bounds");
316 
317         MapEntry storage entry = map._entries[index];
318         return (entry._key, entry._value);
319     }
320 
321     /**
322      * @dev Returns the value associated with `key`.  O(1).
323      *
324      * Requirements:
325      *
326      * - `key` must be in the map.
327      */
328     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
329         return _get(map, key, "EnumerableMap: nonexistent key");
330     }
331 
332     /**
333      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
334      */
335     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
336         uint256 keyIndex = map._indexes[key];
337         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
338         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
339     }
340 
341     // UintToAddressMap
342 
343     struct UintToAddressMap {
344         Map _inner;
345     }
346 
347     /**
348      * @dev Adds a key-value pair to a map, or updates the value for an existing
349      * key. O(1).
350      *
351      * Returns true if the key was added to the map, that is if it was not
352      * already present.
353      */
354     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
355         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
356     }
357 
358     /**
359      * @dev Removes a value from a set. O(1).
360      *
361      * Returns true if the key was removed from the map, that is if it was present.
362      */
363     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
364         return _remove(map._inner, bytes32(key));
365     }
366 
367     /**
368      * @dev Returns true if the key is in the map. O(1).
369      */
370     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
371         return _contains(map._inner, bytes32(key));
372     }
373 
374     /**
375      * @dev Returns the number of elements in the map. O(1).
376      */
377     function length(UintToAddressMap storage map) internal view returns (uint256) {
378         return _length(map._inner);
379     }
380 
381    /**
382     * @dev Returns the element stored at position `index` in the set. O(1).
383     * Note that there are no guarantees on the ordering of values inside the
384     * array, and it may change when more values are added or removed.
385     *
386     * Requirements:
387     *
388     * - `index` must be strictly less than {length}.
389     */
390     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
391         (bytes32 key, bytes32 value) = _at(map._inner, index);
392         return (uint256(key), address(uint256(value)));
393     }
394 
395     /**
396      * @dev Returns the value associated with `key`.  O(1).
397      *
398      * Requirements:
399      *
400      * - `key` must be in the map.
401      */
402     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
403         return address(uint256(_get(map._inner, bytes32(key))));
404     }
405 
406     /**
407      * @dev Same as {get}, with a custom error message when `key` is not in the map.
408      */
409     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
410         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
411     }
412 }
413 
414 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableSet
415 
416 /**
417  * @dev Library for managing
418  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
419  * types.
420  *
421  * Sets have the following properties:
422  *
423  * - Elements are added, removed, and checked for existence in constant time
424  * (O(1)).
425  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
426  *
427  * ```
428  * contract Example {
429  *     // Add the library methods
430  *     using EnumerableSet for EnumerableSet.AddressSet;
431  *
432  *     // Declare a set state variable
433  *     EnumerableSet.AddressSet private mySet;
434  * }
435  * ```
436  *
437  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
438  * (`UintSet`) are supported.
439  */
440 library EnumerableSet {
441     // To implement this library for multiple types with as little code
442     // repetition as possible, we write it in terms of a generic Set type with
443     // bytes32 values.
444     // The Set implementation uses private functions, and user-facing
445     // implementations (such as AddressSet) are just wrappers around the
446     // underlying Set.
447     // This means that we can only create new EnumerableSets for types that fit
448     // in bytes32.
449 
450     struct Set {
451         // Storage of set values
452         bytes32[] _values;
453 
454         // Position of the value in the `values` array, plus 1 because index 0
455         // means a value is not in the set.
456         mapping (bytes32 => uint256) _indexes;
457     }
458 
459     /**
460      * @dev Add a value to a set. O(1).
461      *
462      * Returns true if the value was added to the set, that is if it was not
463      * already present.
464      */
465     function _add(Set storage set, bytes32 value) private returns (bool) {
466         if (!_contains(set, value)) {
467             set._values.push(value);
468             // The value is stored at length-1, but we add 1 to all indexes
469             // and use 0 as a sentinel value
470             set._indexes[value] = set._values.length;
471             return true;
472         } else {
473             return false;
474         }
475     }
476 
477     /**
478      * @dev Removes a value from a set. O(1).
479      *
480      * Returns true if the value was removed from the set, that is if it was
481      * present.
482      */
483     function _remove(Set storage set, bytes32 value) private returns (bool) {
484         // We read and store the value's index to prevent multiple reads from the same storage slot
485         uint256 valueIndex = set._indexes[value];
486 
487         if (valueIndex != 0) { // Equivalent to contains(set, value)
488             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
489             // the array, and then remove the last element (sometimes called as 'swap and pop').
490             // This modifies the order of the array, as noted in {at}.
491 
492             uint256 toDeleteIndex = valueIndex - 1;
493             uint256 lastIndex = set._values.length - 1;
494 
495             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
496             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
497 
498             bytes32 lastvalue = set._values[lastIndex];
499 
500             // Move the last value to the index where the value to delete is
501             set._values[toDeleteIndex] = lastvalue;
502             // Update the index for the moved value
503             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
504 
505             // Delete the slot where the moved value was stored
506             set._values.pop();
507 
508             // Delete the index for the deleted slot
509             delete set._indexes[value];
510 
511             return true;
512         } else {
513             return false;
514         }
515     }
516 
517     /**
518      * @dev Returns true if the value is in the set. O(1).
519      */
520     function _contains(Set storage set, bytes32 value) private view returns (bool) {
521         return set._indexes[value] != 0;
522     }
523 
524     /**
525      * @dev Returns the number of values on the set. O(1).
526      */
527     function _length(Set storage set) private view returns (uint256) {
528         return set._values.length;
529     }
530 
531    /**
532     * @dev Returns the value stored at position `index` in the set. O(1).
533     *
534     * Note that there are no guarantees on the ordering of values inside the
535     * array, and it may change when more values are added or removed.
536     *
537     * Requirements:
538     *
539     * - `index` must be strictly less than {length}.
540     */
541     function _at(Set storage set, uint256 index) private view returns (bytes32) {
542         require(set._values.length > index, "EnumerableSet: index out of bounds");
543         return set._values[index];
544     }
545 
546     // AddressSet
547 
548     struct AddressSet {
549         Set _inner;
550     }
551 
552     /**
553      * @dev Add a value to a set. O(1).
554      *
555      * Returns true if the value was added to the set, that is if it was not
556      * already present.
557      */
558     function add(AddressSet storage set, address value) internal returns (bool) {
559         return _add(set._inner, bytes32(uint256(value)));
560     }
561 
562     /**
563      * @dev Removes a value from a set. O(1).
564      *
565      * Returns true if the value was removed from the set, that is if it was
566      * present.
567      */
568     function remove(AddressSet storage set, address value) internal returns (bool) {
569         return _remove(set._inner, bytes32(uint256(value)));
570     }
571 
572     /**
573      * @dev Returns true if the value is in the set. O(1).
574      */
575     function contains(AddressSet storage set, address value) internal view returns (bool) {
576         return _contains(set._inner, bytes32(uint256(value)));
577     }
578 
579     /**
580      * @dev Returns the number of values in the set. O(1).
581      */
582     function length(AddressSet storage set) internal view returns (uint256) {
583         return _length(set._inner);
584     }
585 
586    /**
587     * @dev Returns the value stored at position `index` in the set. O(1).
588     *
589     * Note that there are no guarantees on the ordering of values inside the
590     * array, and it may change when more values are added or removed.
591     *
592     * Requirements:
593     *
594     * - `index` must be strictly less than {length}.
595     */
596     function at(AddressSet storage set, uint256 index) internal view returns (address) {
597         return address(uint256(_at(set._inner, index)));
598     }
599 
600 
601     // UintSet
602 
603     struct UintSet {
604         Set _inner;
605     }
606 
607     /**
608      * @dev Add a value to a set. O(1).
609      *
610      * Returns true if the value was added to the set, that is if it was not
611      * already present.
612      */
613     function add(UintSet storage set, uint256 value) internal returns (bool) {
614         return _add(set._inner, bytes32(value));
615     }
616 
617     /**
618      * @dev Removes a value from a set. O(1).
619      *
620      * Returns true if the value was removed from the set, that is if it was
621      * present.
622      */
623     function remove(UintSet storage set, uint256 value) internal returns (bool) {
624         return _remove(set._inner, bytes32(value));
625     }
626 
627     /**
628      * @dev Returns true if the value is in the set. O(1).
629      */
630     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
631         return _contains(set._inner, bytes32(value));
632     }
633 
634     /**
635      * @dev Returns the number of values on the set. O(1).
636      */
637     function length(UintSet storage set) internal view returns (uint256) {
638         return _length(set._inner);
639     }
640 
641    /**
642     * @dev Returns the value stored at position `index` in the set. O(1).
643     *
644     * Note that there are no guarantees on the ordering of values inside the
645     * array, and it may change when more values are added or removed.
646     *
647     * Requirements:
648     *
649     * - `index` must be strictly less than {length}.
650     */
651     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
652         return uint256(_at(set._inner, index));
653     }
654 }
655 
656 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC165
657 
658 /**
659  * @dev Interface of the ERC165 standard, as defined in the
660  * https://eips.ethereum.org/EIPS/eip-165[EIP].
661  *
662  * Implementers can declare support of contract interfaces, which can then be
663  * queried by others ({ERC165Checker}).
664  *
665  * For an implementation, see {ERC165}.
666  */
667 interface IERC165 {
668     /**
669      * @dev Returns true if this contract implements the interface defined by
670      * `interfaceId`. See the corresponding
671      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
672      * to learn more about how these ids are created.
673      *
674      * This function call must use less than 30 000 gas.
675      */
676     function supportsInterface(bytes4 interfaceId) external view returns (bool);
677 }
678 
679 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Receiver
680 
681 /**
682  * @title ERC721 token receiver interface
683  * @dev Interface for any contract that wants to support safeTransfers
684  * from ERC721 asset contracts.
685  */
686 interface IERC721Receiver {
687     /**
688      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
689      * by `operator` from `from`, this function is called.
690      *
691      * It must return its Solidity selector to confirm the token transfer.
692      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
693      *
694      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
695      */
696     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
697     external returns (bytes4);
698 }
699 
700 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
701 
702 /**
703  * @dev Wrappers over Solidity's arithmetic operations with added overflow
704  * checks.
705  *
706  * Arithmetic operations in Solidity wrap on overflow. This can easily result
707  * in bugs, because programmers usually assume that an overflow raises an
708  * error, which is the standard behavior in high level programming languages.
709  * `SafeMath` restores this intuition by reverting the transaction when an
710  * operation overflows.
711  *
712  * Using this library instead of the unchecked operations eliminates an entire
713  * class of bugs, so it's recommended to use it always.
714  */
715 library SafeMath {
716     /**
717      * @dev Returns the addition of two unsigned integers, reverting on
718      * overflow.
719      *
720      * Counterpart to Solidity's `+` operator.
721      *
722      * Requirements:
723      *
724      * - Addition cannot overflow.
725      */
726     function add(uint256 a, uint256 b) internal pure returns (uint256) {
727         uint256 c = a + b;
728         require(c >= a, "SafeMath: addition overflow");
729 
730         return c;
731     }
732 
733     /**
734      * @dev Returns the subtraction of two unsigned integers, reverting on
735      * overflow (when the result is negative).
736      *
737      * Counterpart to Solidity's `-` operator.
738      *
739      * Requirements:
740      *
741      * - Subtraction cannot overflow.
742      */
743     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
744         return sub(a, b, "SafeMath: subtraction overflow");
745     }
746 
747     /**
748      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
749      * overflow (when the result is negative).
750      *
751      * Counterpart to Solidity's `-` operator.
752      *
753      * Requirements:
754      *
755      * - Subtraction cannot overflow.
756      */
757     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
758         require(b <= a, errorMessage);
759         uint256 c = a - b;
760 
761         return c;
762     }
763 
764     /**
765      * @dev Returns the multiplication of two unsigned integers, reverting on
766      * overflow.
767      *
768      * Counterpart to Solidity's `*` operator.
769      *
770      * Requirements:
771      *
772      * - Multiplication cannot overflow.
773      */
774     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
775         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
776         // benefit is lost if 'b' is also tested.
777         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
778         if (a == 0) {
779             return 0;
780         }
781 
782         uint256 c = a * b;
783         require(c / a == b, "SafeMath: multiplication overflow");
784 
785         return c;
786     }
787 
788     /**
789      * @dev Returns the integer division of two unsigned integers. Reverts on
790      * division by zero. The result is rounded towards zero.
791      *
792      * Counterpart to Solidity's `/` operator. Note: this function uses a
793      * `revert` opcode (which leaves remaining gas untouched) while Solidity
794      * uses an invalid opcode to revert (consuming all remaining gas).
795      *
796      * Requirements:
797      *
798      * - The divisor cannot be zero.
799      */
800     function div(uint256 a, uint256 b) internal pure returns (uint256) {
801         return div(a, b, "SafeMath: division by zero");
802     }
803 
804     /**
805      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
806      * division by zero. The result is rounded towards zero.
807      *
808      * Counterpart to Solidity's `/` operator. Note: this function uses a
809      * `revert` opcode (which leaves remaining gas untouched) while Solidity
810      * uses an invalid opcode to revert (consuming all remaining gas).
811      *
812      * Requirements:
813      *
814      * - The divisor cannot be zero.
815      */
816     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
817         require(b > 0, errorMessage);
818         uint256 c = a / b;
819         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
820 
821         return c;
822     }
823 
824     /**
825      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
826      * Reverts when dividing by zero.
827      *
828      * Counterpart to Solidity's `%` operator. This function uses a `revert`
829      * opcode (which leaves remaining gas untouched) while Solidity uses an
830      * invalid opcode to revert (consuming all remaining gas).
831      *
832      * Requirements:
833      *
834      * - The divisor cannot be zero.
835      */
836     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
837         return mod(a, b, "SafeMath: modulo by zero");
838     }
839 
840     /**
841      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
842      * Reverts with custom message when dividing by zero.
843      *
844      * Counterpart to Solidity's `%` operator. This function uses a `revert`
845      * opcode (which leaves remaining gas untouched) while Solidity uses an
846      * invalid opcode to revert (consuming all remaining gas).
847      *
848      * Requirements:
849      *
850      * - The divisor cannot be zero.
851      */
852     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
853         require(b != 0, errorMessage);
854         return a % b;
855     }
856 }
857 
858 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Strings
859 
860 /**
861  * @dev String operations.
862  */
863 library Strings {
864     /**
865      * @dev Converts a `uint256` to its ASCII `string` representation.
866      */
867     function toString(uint256 value) internal pure returns (string memory) {
868         // Inspired by OraclizeAPI's implementation - MIT licence
869         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
870 
871         if (value == 0) {
872             return "0";
873         }
874         uint256 temp = value;
875         uint256 digits;
876         while (temp != 0) {
877             digits++;
878             temp /= 10;
879         }
880         bytes memory buffer = new bytes(digits);
881         uint256 index = digits - 1;
882         temp = value;
883         while (temp != 0) {
884             buffer[index--] = byte(uint8(48 + temp % 10));
885             temp /= 10;
886         }
887         return string(buffer);
888     }
889 }
890 
891 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC165
892 
893 /**
894  * @dev Implementation of the {IERC165} interface.
895  *
896  * Contracts may inherit from this and call {_registerInterface} to declare
897  * their support of an interface.
898  */
899 contract ERC165 is IERC165 {
900     /*
901      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
902      */
903     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
904 
905     /**
906      * @dev Mapping of interface ids to whether or not it's supported.
907      */
908     mapping(bytes4 => bool) private _supportedInterfaces;
909 
910     constructor () internal {
911         // Derived contracts need only register support for their own interfaces,
912         // we register support for ERC165 itself here
913         _registerInterface(_INTERFACE_ID_ERC165);
914     }
915 
916     /**
917      * @dev See {IERC165-supportsInterface}.
918      *
919      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
920      */
921     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
922         return _supportedInterfaces[interfaceId];
923     }
924 
925     /**
926      * @dev Registers the contract as an implementer of the interface defined by
927      * `interfaceId`. Support of the actual ERC165 interface is automatic and
928      * registering its interface id is not required.
929      *
930      * See {IERC165-supportsInterface}.
931      *
932      * Requirements:
933      *
934      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
935      */
936     function _registerInterface(bytes4 interfaceId) internal virtual {
937         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
938         _supportedInterfaces[interfaceId] = true;
939     }
940 }
941 
942 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC1155
943 
944 /**
945  * @dev Required interface of an ERC1155 compliant contract, as defined in the
946  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
947  *
948  * _Available since v3.1._
949  */
950 interface IERC1155 is IERC165 {
951     /**
952      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
953      */
954     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
955 
956     /**
957      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
958      * transfers.
959      */
960     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
961 
962     /**
963      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
964      * `approved`.
965      */
966     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
967 
968     /**
969      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
970      *
971      * If an {URI} event was emitted for `id`, the standard
972      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
973      * returned by {IERC1155MetadataURI-uri}.
974      */
975     event URI(string value, uint256 indexed id);
976 
977     /**
978      * @dev Returns the amount of tokens of token type `id` owned by `account`.
979      *
980      * Requirements:
981      *
982      * - `account` cannot be the zero address.
983      */
984     function balanceOf(address account, uint256 id) external view returns (uint256);
985 
986     /**
987      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
988      *
989      * Requirements:
990      *
991      * - `accounts` and `ids` must have the same length.
992      */
993     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
994 
995     /**
996      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
997      *
998      * Emits an {ApprovalForAll} event.
999      *
1000      * Requirements:
1001      *
1002      * - `operator` cannot be the caller.
1003      */
1004     function setApprovalForAll(address operator, bool approved) external;
1005 
1006     /**
1007      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1008      *
1009      * See {setApprovalForAll}.
1010      */
1011     function isApprovedForAll(address account, address operator) external view returns (bool);
1012 
1013     /**
1014      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1015      *
1016      * Emits a {TransferSingle} event.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1022      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1023      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1024      * acceptance magic value.
1025      */
1026     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1027 
1028     /**
1029      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1030      *
1031      * Emits a {TransferBatch} event.
1032      *
1033      * Requirements:
1034      *
1035      * - `ids` and `amounts` must have the same length.
1036      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1037      * acceptance magic value.
1038      */
1039     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1040 }
1041 
1042 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721
1043 
1044 /**
1045  * @dev Required interface of an ERC721 compliant contract.
1046  */
1047 interface IERC721 is IERC165 {
1048     /**
1049      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1050      */
1051     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1052 
1053     /**
1054      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1055      */
1056     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1057 
1058     /**
1059      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1060      */
1061     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1062 
1063     /**
1064      * @dev Returns the number of tokens in ``owner``'s account.
1065      */
1066     function balanceOf(address owner) external view returns (uint256 balance);
1067 
1068     /**
1069      * @dev Returns the owner of the `tokenId` token.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      */
1075     function ownerOf(uint256 tokenId) external view returns (address owner);
1076 
1077     /**
1078      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1079      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1080      *
1081      * Requirements:
1082      *
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must exist and be owned by `from`.
1086      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1092 
1093     /**
1094      * @dev Transfers `tokenId` token from `from` to `to`.
1095      *
1096      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1097      *
1098      * Requirements:
1099      *
1100      * - `from` cannot be the zero address.
1101      * - `to` cannot be the zero address.
1102      * - `tokenId` token must be owned by `from`.
1103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function transferFrom(address from, address to, uint256 tokenId) external;
1108 
1109     /**
1110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1111      * The approval is cleared when the token is transferred.
1112      *
1113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1114      *
1115      * Requirements:
1116      *
1117      * - The caller must own the token or be an approved operator.
1118      * - `tokenId` must exist.
1119      *
1120      * Emits an {Approval} event.
1121      */
1122     function approve(address to, uint256 tokenId) external;
1123 
1124     /**
1125      * @dev Returns the account approved for `tokenId` token.
1126      *
1127      * Requirements:
1128      *
1129      * - `tokenId` must exist.
1130      */
1131     function getApproved(uint256 tokenId) external view returns (address operator);
1132 
1133     /**
1134      * @dev Approve or remove `operator` as an operator for the caller.
1135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1136      *
1137      * Requirements:
1138      *
1139      * - The `operator` cannot be the caller.
1140      *
1141      * Emits an {ApprovalForAll} event.
1142      */
1143     function setApprovalForAll(address operator, bool _approved) external;
1144 
1145     /**
1146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1147      *
1148      * See {setApprovalForAll}
1149      */
1150     function isApprovedForAll(address owner, address operator) external view returns (bool);
1151 
1152     /**
1153       * @dev Safely transfers `tokenId` token from `from` to `to`.
1154       *
1155       * Requirements:
1156       *
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159       * - `tokenId` token must exist and be owned by `from`.
1160       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1161       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1162       *
1163       * Emits a {Transfer} event.
1164       */
1165     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1166 }
1167 
1168 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Ownable
1169 
1170 /**
1171  * @dev Contract module which provides a basic access control mechanism, where
1172  * there is an account (an owner) that can be granted exclusive access to
1173  * specific functions.
1174  *
1175  * By default, the owner account will be the one that deploys the contract. This
1176  * can later be changed with {transferOwnership}.
1177  *
1178  * This module is used through inheritance. It will make available the modifier
1179  * `onlyOwner`, which can be applied to your functions to restrict their use to
1180  * the owner.
1181  */
1182 contract Ownable is Context {
1183     address private _owner;
1184 
1185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1186 
1187     /**
1188      * @dev Initializes the contract setting the deployer as the initial owner.
1189      */
1190     constructor () internal {
1191         address msgSender = _msgSender();
1192         _owner = msgSender;
1193         emit OwnershipTransferred(address(0), msgSender);
1194     }
1195 
1196     /**
1197      * @dev Returns the address of the current owner.
1198      */
1199     function owner() public view returns (address) {
1200         return _owner;
1201     }
1202 
1203     /**
1204      * @dev Throws if called by any account other than the owner.
1205      */
1206     modifier onlyOwner() {
1207         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1208         _;
1209     }
1210 
1211     /**
1212      * @dev Leaves the contract without owner. It will not be possible to call
1213      * `onlyOwner` functions anymore. Can only be called by the current owner.
1214      *
1215      * NOTE: Renouncing ownership will leave the contract without an owner,
1216      * thereby removing any functionality that is only available to the owner.
1217      */
1218     function renounceOwnership() public virtual onlyOwner {
1219         emit OwnershipTransferred(_owner, address(0));
1220         _owner = address(0);
1221     }
1222 
1223     /**
1224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1225      * Can only be called by the current owner.
1226      */
1227     function transferOwnership(address newOwner) public virtual onlyOwner {
1228         require(newOwner != address(0), "Ownable: new owner is the zero address");
1229         emit OwnershipTransferred(_owner, newOwner);
1230         _owner = newOwner;
1231     }
1232 }
1233 
1234 // Part: HasSecondaryBoxSaleFees
1235 
1236 contract HasSecondaryBoxSaleFees is ERC165 {
1237     
1238     address payable teamAddress;
1239     uint256 teamSecondaryBps;  
1240         
1241    /*
1242     * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1243     * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1244     *
1245     * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
1246     */
1247     
1248     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1249     
1250     constructor() public {
1251         _registerInterface(_INTERFACE_ID_FEES);
1252     }
1253 
1254     function getFeeRecipients(uint256 id) public view returns (address payable[] memory){
1255         address payable[] memory addressArray = new address payable[](1);
1256         addressArray[0] = teamAddress;
1257         return addressArray;
1258     }
1259     
1260     function getFeeBps(uint256 id) public view returns (uint[] memory){
1261         uint[] memory bpsArray = new uint[](1);
1262         bpsArray[0] = teamSecondaryBps; 
1263         return bpsArray;
1264     }
1265  
1266 }
1267 
1268 // Part: IBoxVoucher
1269 
1270 interface IBoxVoucher is IERC1155 {
1271 	function mintFor(address _to, uint256 _id, uint256 _amount) external;
1272 	function burnFrom(address _from, uint256 _id, uint256 _amount) external;
1273 	function totalSupply(uint256 _id) external view returns(uint256);
1274 }
1275 
1276 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Enumerable
1277 
1278 /**
1279  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1280  * @dev See https://eips.ethereum.org/EIPS/eip-721
1281  */
1282 interface IERC721Enumerable is IERC721 {
1283 
1284     /**
1285      * @dev Returns the total amount of tokens stored by the contract.
1286      */
1287     function totalSupply() external view returns (uint256);
1288 
1289     /**
1290      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1291      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1292      */
1293     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1294 
1295     /**
1296      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1297      * Use along with {totalSupply} to enumerate all tokens.
1298      */
1299     function tokenByIndex(uint256 index) external view returns (uint256);
1300 }
1301 
1302 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Metadata
1303 
1304 /**
1305  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1306  * @dev See https://eips.ethereum.org/EIPS/eip-721
1307  */
1308 interface IERC721Metadata is IERC721 {
1309 
1310     /**
1311      * @dev Returns the token collection name.
1312      */
1313     function name() external view returns (string memory);
1314 
1315     /**
1316      * @dev Returns the token collection symbol.
1317      */
1318     function symbol() external view returns (string memory);
1319 
1320     /**
1321      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1322      */
1323     function tokenURI(uint256 tokenId) external view returns (string memory);
1324 }
1325 
1326 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC721
1327 
1328 /**
1329  * @title ERC721 Non-Fungible Token Standard basic implementation
1330  * @dev see https://eips.ethereum.org/EIPS/eip-721
1331  */
1332 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1333     using SafeMath for uint256;
1334     using Address for address;
1335     using EnumerableSet for EnumerableSet.UintSet;
1336     using EnumerableMap for EnumerableMap.UintToAddressMap;
1337     using Strings for uint256;
1338 
1339     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1340     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1341     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1342 
1343     // Mapping from holder address to their (enumerable) set of owned tokens
1344     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1345 
1346     // Enumerable mapping from token ids to their owners
1347     EnumerableMap.UintToAddressMap private _tokenOwners;
1348 
1349     // Mapping from token ID to approved address
1350     mapping (uint256 => address) private _tokenApprovals;
1351 
1352     // Mapping from owner to operator approvals
1353     mapping (address => mapping (address => bool)) private _operatorApprovals;
1354 
1355     // Token name
1356     string private _name;
1357 
1358     // Token symbol
1359     string private _symbol;
1360 
1361     // Optional mapping for token URIs
1362     mapping (uint256 => string) private _tokenURIs;
1363 
1364     // Base URI
1365     string private _baseURI;
1366 
1367     /*
1368      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1369      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1370      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1371      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1372      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1373      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1374      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1375      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1376      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1377      *
1378      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1379      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1380      */
1381     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1382 
1383     /*
1384      *     bytes4(keccak256('name()')) == 0x06fdde03
1385      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1386      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1387      *
1388      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1389      */
1390     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1391 
1392     /*
1393      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1394      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1395      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1396      *
1397      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1398      */
1399     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1400 
1401     /**
1402      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1403      */
1404     constructor (string memory name, string memory symbol) public {
1405         _name = name;
1406         _symbol = symbol;
1407 
1408         // register the supported interfaces to conform to ERC721 via ERC165
1409         _registerInterface(_INTERFACE_ID_ERC721);
1410         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1411         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-balanceOf}.
1416      */
1417     function balanceOf(address owner) public view override returns (uint256) {
1418         require(owner != address(0), "ERC721: balance query for the zero address");
1419 
1420         return _holderTokens[owner].length();
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-ownerOf}.
1425      */
1426     function ownerOf(uint256 tokenId) public view override returns (address) {
1427         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Metadata-name}.
1432      */
1433     function name() public view override returns (string memory) {
1434         return _name;
1435     }
1436 
1437     /**
1438      * @dev See {IERC721Metadata-symbol}.
1439      */
1440     function symbol() public view override returns (string memory) {
1441         return _symbol;
1442     }
1443 
1444     /**
1445      * @dev See {IERC721Metadata-tokenURI}.
1446      */
1447     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1448         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1449 
1450         string memory _tokenURI = _tokenURIs[tokenId];
1451 
1452         // If there is no base URI, return the token URI.
1453         if (bytes(_baseURI).length == 0) {
1454             return _tokenURI;
1455         }
1456         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1457         if (bytes(_tokenURI).length > 0) {
1458             return string(abi.encodePacked(_baseURI, _tokenURI));
1459         }
1460         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1461         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1462     }
1463 
1464     /**
1465     * @dev Returns the base URI set via {_setBaseURI}. This will be
1466     * automatically added as a prefix in {tokenURI} to each token's URI, or
1467     * to the token ID if no specific URI is set for that token ID.
1468     */
1469     function baseURI() public view returns (string memory) {
1470         return _baseURI;
1471     }
1472 
1473     /**
1474      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1475      */
1476     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1477         return _holderTokens[owner].at(index);
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Enumerable-totalSupply}.
1482      */
1483     function totalSupply() public view override returns (uint256) {
1484         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1485         return _tokenOwners.length();
1486     }
1487 
1488     /**
1489      * @dev See {IERC721Enumerable-tokenByIndex}.
1490      */
1491     function tokenByIndex(uint256 index) public view override returns (uint256) {
1492         (uint256 tokenId, ) = _tokenOwners.at(index);
1493         return tokenId;
1494     }
1495 
1496     /**
1497      * @dev See {IERC721-approve}.
1498      */
1499     function approve(address to, uint256 tokenId) public virtual override {
1500         address owner = ownerOf(tokenId);
1501         require(to != owner, "ERC721: approval to current owner");
1502 
1503         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1504             "ERC721: approve caller is not owner nor approved for all"
1505         );
1506 
1507         _approve(to, tokenId);
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-getApproved}.
1512      */
1513     function getApproved(uint256 tokenId) public view override returns (address) {
1514         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1515 
1516         return _tokenApprovals[tokenId];
1517     }
1518 
1519     /**
1520      * @dev See {IERC721-setApprovalForAll}.
1521      */
1522     function setApprovalForAll(address operator, bool approved) public virtual override {
1523         require(operator != _msgSender(), "ERC721: approve to caller");
1524 
1525         _operatorApprovals[_msgSender()][operator] = approved;
1526         emit ApprovalForAll(_msgSender(), operator, approved);
1527     }
1528 
1529     /**
1530      * @dev See {IERC721-isApprovedForAll}.
1531      */
1532     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1533         return _operatorApprovals[owner][operator];
1534     }
1535 
1536     /**
1537      * @dev See {IERC721-transferFrom}.
1538      */
1539     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1540         //solhint-disable-next-line max-line-length
1541         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1542 
1543         _transfer(from, to, tokenId);
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-safeTransferFrom}.
1548      */
1549     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1550         safeTransferFrom(from, to, tokenId, "");
1551     }
1552 
1553     /**
1554      * @dev See {IERC721-safeTransferFrom}.
1555      */
1556     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1557         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1558         _safeTransfer(from, to, tokenId, _data);
1559     }
1560 
1561     /**
1562      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1563      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1564      *
1565      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1566      *
1567      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1568      * implement alternative mechanisms to perform token transfer, such as signature-based.
1569      *
1570      * Requirements:
1571      *
1572      * - `from` cannot be the zero address.
1573      * - `to` cannot be the zero address.
1574      * - `tokenId` token must exist and be owned by `from`.
1575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1576      *
1577      * Emits a {Transfer} event.
1578      */
1579     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1580         _transfer(from, to, tokenId);
1581         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1582     }
1583 
1584     /**
1585      * @dev Returns whether `tokenId` exists.
1586      *
1587      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1588      *
1589      * Tokens start existing when they are minted (`_mint`),
1590      * and stop existing when they are burned (`_burn`).
1591      */
1592     function _exists(uint256 tokenId) internal view returns (bool) {
1593         return _tokenOwners.contains(tokenId);
1594     }
1595 
1596     /**
1597      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1598      *
1599      * Requirements:
1600      *
1601      * - `tokenId` must exist.
1602      */
1603     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1604         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1605         address owner = ownerOf(tokenId);
1606         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1607     }
1608 
1609     /**
1610      * @dev Safely mints `tokenId` and transfers it to `to`.
1611      *
1612      * Requirements:
1613      d*
1614      * - `tokenId` must not exist.
1615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1616      *
1617      * Emits a {Transfer} event.
1618      */
1619     function _safeMint(address to, uint256 tokenId) internal virtual {
1620         _safeMint(to, tokenId, "");
1621     }
1622 
1623     /**
1624      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1625      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1626      */
1627     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1628         _mint(to, tokenId);
1629         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1630     }
1631 
1632     /**
1633      * @dev Mints `tokenId` and transfers it to `to`.
1634      *
1635      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1636      *
1637      * Requirements:
1638      *
1639      * - `tokenId` must not exist.
1640      * - `to` cannot be the zero address.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function _mint(address to, uint256 tokenId) internal virtual {
1645         require(to != address(0), "ERC721: mint to the zero address");
1646         require(!_exists(tokenId), "ERC721: token already minted");
1647 
1648         _beforeTokenTransfer(address(0), to, tokenId);
1649 
1650         _holderTokens[to].add(tokenId);
1651 
1652         _tokenOwners.set(tokenId, to);
1653 
1654         emit Transfer(address(0), to, tokenId);
1655     }
1656 
1657     /**
1658      * @dev Destroys `tokenId`.
1659      * The approval is cleared when the token is burned.
1660      *
1661      * Requirements:
1662      *
1663      * - `tokenId` must exist.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function _burn(uint256 tokenId) internal virtual {
1668         address owner = ownerOf(tokenId);
1669 
1670         _beforeTokenTransfer(owner, address(0), tokenId);
1671 
1672         // Clear approvals
1673         _approve(address(0), tokenId);
1674 
1675         // Clear metadata (if any)
1676         if (bytes(_tokenURIs[tokenId]).length != 0) {
1677             delete _tokenURIs[tokenId];
1678         }
1679 
1680         _holderTokens[owner].remove(tokenId);
1681 
1682         _tokenOwners.remove(tokenId);
1683 
1684         emit Transfer(owner, address(0), tokenId);
1685     }
1686 
1687     /**
1688      * @dev Transfers `tokenId` from `from` to `to`.
1689      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1690      *
1691      * Requirements:
1692      *
1693      * - `to` cannot be the zero address.
1694      * - `tokenId` token must be owned by `from`.
1695      *
1696      * Emits a {Transfer} event.
1697      */
1698     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1699         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1700         require(to != address(0), "ERC721: transfer to the zero address");
1701 
1702         _beforeTokenTransfer(from, to, tokenId);
1703 
1704         // Clear approvals from the previous owner
1705         _approve(address(0), tokenId);
1706 
1707         _holderTokens[from].remove(tokenId);
1708         _holderTokens[to].add(tokenId);
1709 
1710         _tokenOwners.set(tokenId, to);
1711 
1712         emit Transfer(from, to, tokenId);
1713     }
1714 
1715     /**
1716      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1717      *
1718      * Requirements:
1719      *
1720      * - `tokenId` must exist.
1721      */
1722     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1723         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1724         _tokenURIs[tokenId] = _tokenURI;
1725     }
1726 
1727     /**
1728      * @dev Internal function to set the base URI for all token IDs. It is
1729      * automatically added as a prefix to the value returned in {tokenURI},
1730      * or to the token ID if {tokenURI} is empty.
1731      */
1732     function _setBaseURI(string memory baseURI_) internal virtual {
1733         _baseURI = baseURI_;
1734     }
1735 
1736     /**
1737      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1738      * The call is not executed if the target address is not a contract.
1739      *
1740      * @param from address representing the previous owner of the given token ID
1741      * @param to target address that will receive the tokens
1742      * @param tokenId uint256 ID of the token to be transferred
1743      * @param _data bytes optional data to send along with the call
1744      * @return bool whether the call correctly returned the expected magic value
1745      */
1746     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1747         private returns (bool)
1748     {
1749         if (!to.isContract()) {
1750             return true;
1751         }
1752         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1753             IERC721Receiver(to).onERC721Received.selector,
1754             _msgSender(),
1755             from,
1756             tokenId,
1757             _data
1758         ), "ERC721: transfer to non ERC721Receiver implementer");
1759         bytes4 retval = abi.decode(returndata, (bytes4));
1760         return (retval == _ERC721_RECEIVED);
1761     }
1762 
1763     function _approve(address to, uint256 tokenId) private {
1764         _tokenApprovals[tokenId] = to;
1765         emit Approval(ownerOf(tokenId), to, tokenId);
1766     }
1767 
1768     /**
1769      * @dev Hook that is called before any token transfer. This includes minting
1770      * and burning.
1771      *
1772      * Calling conditions:
1773      *
1774      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1775      * transferred to `to`.
1776      * - When `from` is zero, `tokenId` will be minted for `to`.
1777      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1778      * - `from` cannot be the zero address.
1779      * - `to` cannot be the zero address.
1780      *
1781      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1782      */
1783     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1784 }
1785 
1786 // File: NFTBoxes.sol
1787 
1788 contract NFTBoxesBox is ERC721("NFTBox", "[BOX]"), Ownable, HasSecondaryBoxSaleFees {
1789     
1790 	struct BoxMould{
1791 		uint8				live; // bool
1792 		uint8				shared; // bool
1793 		uint128				maxEdition;
1794 		uint128				maxBuyAmount;
1795 		uint128				currentEditionCount;
1796 		uint256				price;
1797 		address payable[]	artists;
1798 		uint256[]			shares;
1799 		string				name;
1800 		string				series;
1801 		string				theme;
1802 		string				ipfsHash;
1803 		string				arweaveHash;
1804 	}
1805 
1806 	struct Box {
1807 		uint256				mouldId;
1808 		uint256				edition;
1809 	}
1810 
1811 	IVendingMachine public	vendingMachine;
1812 	IBoxVoucher public		boxVoucher;
1813 	uint256 public			boxMouldCount;
1814 	uint256 public			gasFee;
1815 
1816 	uint256 constant public TOTAL_SHARES = 1000;
1817 	uint256 constant DELIMITOR = 100000;
1818 
1819 	mapping(uint256 => BoxMould) public	boxMoulds;
1820 	mapping(uint256 =>  Box) public	boxes;
1821 	mapping(uint256 => bool) public lockedBoxes;
1822 	mapping(uint256 => uint256) public voucherValidityInterval;
1823 	mapping(uint256 => address[]) public reservations;
1824 	mapping(uint256 => mapping(address => uint256)) boxBoughtMapping;
1825 
1826 	mapping(address => uint256) public teamShare;
1827 	address payable[] public team;
1828 
1829 	uint256 gasMoney;
1830 
1831 	mapping(address => bool) public authorisedCaller;
1832 
1833 	event BoxMouldCreated(uint256 id);
1834 	event BoxBought(uint256 indexed boxMould, uint256 boxEdition, uint256 tokenId);
1835 	event BatchDeployed(uint256 indexed boxMould, uint256 batchSize);
1836 
1837 	constructor() public {
1838 		_setBaseURI("https://nftboxesbox.azurewebsites.net/api/HttpTrigger?id=");
1839 		gasFee = 1050;
1840 		boxMouldCount = 4;
1841 		team.push(payable(0x3428B1746Dfd26C7C725913D829BE2706AA89B2e));
1842 		team.push(payable(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3));
1843 		team.push(payable(0x4C7BEdfA26C744e6bd61CBdF86F3fc4a76DCa073));
1844 		team.push(payable(0xf521Bb7437bEc77b0B15286dC3f49A87b9946773));
1845 		team.push(payable(0x3945476E477De76d53b4833a46c806Ef3D72b21E));
1846 		team.push(payable(0xd084c5fF298E951E0e4CD29dD29684d5a54C0d8e));
1847 
1848 		teamShare[address(0x3428B1746Dfd26C7C725913D829BE2706AA89B2e)] = 600;
1849         teamShare[address(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3)] = 10;
1850         teamShare[address(0x4C7BEdfA26C744e6bd61CBdF86F3fc4a76DCa073)] = 30;
1851         teamShare[address(0xf521Bb7437bEc77b0B15286dC3f49A87b9946773)] = 60;
1852         teamShare[address(0x3945476E477De76d53b4833a46c806Ef3D72b21E)] = 10;
1853         teamShare[address(0xd084c5fF298E951E0e4CD29dD29684d5a54C0d8e)] = 20;
1854 		authorisedCaller[0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3] = true;
1855 		vendingMachine = IVendingMachine(0x6d4530149e5B4483d2F7E60449C02570531A0751);
1856 	}
1857 
1858 	function updateURI(string memory newURI) public onlyOwner {
1859 		_setBaseURI(newURI);
1860 	}
1861 
1862 	modifier authorised() {
1863 		require(authorisedCaller[msg.sender] || msg.sender == owner(), "Not authorised to execute.");
1864 		_;
1865 	}
1866 
1867 	function setCaller(address _caller, bool _value) external onlyOwner {
1868 		authorisedCaller[_caller] = _value;
1869 	}
1870 
1871 	function addTeamMember(address payable _member) external onlyOwner {
1872 		for (uint256 i = 0; i < team.length; i++)
1873 			require( _member != team[i], "members exists already");
1874 		team.push(_member);
1875 	}
1876 
1877 	function removeTeamMember(address payable _member) external onlyOwner {
1878 		for (uint256 i = 0; i < team.length; i++)
1879 			if (team[i] == _member) {
1880 				delete teamShare[_member];
1881 				team[i] = team[team.length - 1];
1882 				team.pop();
1883 			}
1884 	}
1885 
1886 	function setTeamShare(address _member, uint _share) external onlyOwner {
1887 		require(_share <= TOTAL_SHARES, "share must be below 1000");
1888 		for (uint256 i = 0; i < team.length; i++)
1889 			if (team[i] == _member)
1890 				teamShare[_member] = _share;
1891 	}
1892 
1893 	function setLockOnBox(uint256 _id, bool _lock) external authorised {
1894 		require(_id <= boxMouldCount && _id > 0, "ID !exist.");
1895 		lockedBoxes[_id] = _lock;
1896 	}
1897 
1898 	function createBoxMould(
1899 		uint128 _max,
1900 		uint128 _maxBuyAmount,
1901 		uint128 _reserve,
1902 		uint256 _price,
1903 		address payable[] memory _artists,
1904 		uint256[] memory _shares,
1905 		string memory _name,
1906 		string memory _series,
1907 		string memory _theme,
1908 		string memory _ipfsHash,
1909 		string memory _arweaveHash)
1910 		external
1911 		onlyOwner {
1912 		require(_artists.length == _shares.length, "arrays !same len");
1913 		require(_reserve <= _max, "!mint");
1914 		boxMoulds[boxMouldCount + 1] = BoxMould({
1915 			live: uint8(0),
1916 			shared: uint8(0),
1917 			maxEdition: _max,
1918 			maxBuyAmount: _maxBuyAmount,
1919 			currentEditionCount: 0,
1920 			price: _price,
1921 			artists: _artists,
1922 			shares: _shares,
1923 			name: _name,
1924 			series: _series,
1925 			theme: _theme,
1926 			ipfsHash: _ipfsHash,
1927 			arweaveHash: _arweaveHash
1928 		});
1929 		boxMouldCount++;
1930 		lockedBoxes[boxMouldCount] = true;
1931 		boxVoucher.mintFor(msg.sender, boxMouldCount, _reserve);
1932 		emit BoxMouldCreated(boxMouldCount);
1933 	}
1934 
1935 	function removeArtist(uint256 _id, address payable _artist) external onlyOwner {
1936 		BoxMould storage boxMould = boxMoulds[_id];
1937 		require(_id <= boxMouldCount && _id > 0, "ID !exist");
1938 		for (uint256 i = 0; i < boxMould.artists.length; i++) {
1939 			if (boxMould.artists[i] == _artist) {
1940 				boxMould.artists[i] = boxMould.artists[boxMould.artists.length - 1];
1941 				boxMould.artists.pop();
1942 				boxMould.shares[i] = boxMould.shares[boxMould.shares.length - 1];
1943 				boxMould.shares.pop();
1944 			}
1945 		}
1946 	}
1947 	
1948 	function addArtists(uint256 _id, address payable _artist, uint256 _share) external onlyOwner {
1949 		BoxMould storage boxMould = boxMoulds[_id];
1950 		require(_id <= boxMouldCount && _id > 0, "ID !exist");
1951 		boxMould.artists.push(_artist);
1952 		boxMould.shares.push(_share);
1953 	}
1954 
1955 	// dont even need this tbh?
1956 	// function getArtistRoyalties(uint256 _id) external view returns (address payable[] memory artists, uint256[] memory royalties) {
1957 	// 	require(_id <= boxMouldCount && _id > 0, "ID !exist.");
1958 	// 	BoxMould memory boxMould = boxMoulds[_id];
1959 	// 	artists = boxMould.artists;
1960 	// 	royalties = boxMould.shares;
1961 	// }
1962 
1963 	function buyManyBoxes(uint256 _id, uint128 _quantity) external payable {
1964 		BoxMould storage boxMould = boxMoulds[_id];
1965 		uint128 currentEdition = boxMould.currentEditionCount;
1966 		uint128 max = boxMould.maxEdition;
1967 		require(_id <= boxMouldCount && _id > 0, "ID !exist");
1968 		require(boxMould.live == 0, "!live");
1969 		require(!lockedBoxes[_id], "locked");
1970 		require(voucherValidityInterval[_id] != 0 && block.timestamp > voucherValidityInterval[_id],
1971 			"Buy window !open");
1972 		require(boxMould.price.mul(_quantity) == msg.value, "!price");
1973 		require(currentEdition + _quantity <= max, "Too many boxes");
1974 		require(boxBoughtMapping[_id][msg.sender].add(_quantity) <= boxMould.maxBuyAmount, "!buy");
1975 
1976 		for (uint128 i = 0; i < _quantity; i++)
1977 			_buy(currentEdition, _id, i, msg.sender);
1978 		boxMould.currentEditionCount += _quantity;
1979 		boxBoughtMapping[_id][msg.sender] = boxBoughtMapping[_id][msg.sender].add(_quantity);
1980 		if (currentEdition + _quantity == max)
1981 			boxMould.live = uint8(1);
1982 	}
1983 
1984 	function buyBoxesWithVouchers(uint256 _id, uint128 _quantity) external payable {
1985 		BoxMould storage boxMould = boxMoulds[_id];
1986 		uint128 currentEdition = boxMould.currentEditionCount;
1987 		uint128 max = boxMould.maxEdition;
1988 		require(_id <= boxMouldCount && _id > 0, "ID !exist");
1989 		require(!lockedBoxes[_id], "locked");
1990 		require(boxMould.price.mul(_quantity) == msg.value, "!price");
1991 		require(boxMould.live == 0, "!live");
1992 
1993 		boxVoucher.burnFrom(msg.sender, _id, _quantity);
1994 		boxVoucher.mintFor(msg.sender, _id + DELIMITOR, _quantity);
1995 		for (uint128 i = 0; i < _quantity; i++)
1996 			_buy(currentEdition, _id, i, msg.sender);
1997 		boxMould.currentEditionCount += _quantity;
1998 		if (currentEdition + _quantity == max)
1999 			boxMould.live = uint8(1);
2000 	}
2001 
2002 	function reserveBoxes(uint256 _id, uint256 _quantity) external payable {
2003 		BoxMould memory boxMould = boxMoulds[_id];
2004 		require(_id <= boxMouldCount && _id > 0, "ID !exist");
2005 		require(voucherValidityInterval[_id] == 0, "Cannot reserve");
2006 		require(boxMould.price.mul(_quantity).mul(gasFee).div(TOTAL_SHARES) == msg.value, "!price");
2007 
2008 		boxVoucher.burnFrom(msg.sender, _id, _quantity);
2009 		boxVoucher.mintFor(msg.sender, _id + DELIMITOR, _quantity);
2010 		for (uint256 i = 0; i < _quantity; i++)
2011 			reservations[_id].push(msg.sender);
2012 		gasMoney = gasMoney.add(msg.value.sub(boxMould.price.mul(_quantity)));
2013 	}
2014 
2015 	function withdrawGasMoney() external onlyOwner {
2016 		msg.sender.transfer(gasMoney);
2017 		gasMoney = 0;
2018 	}
2019 
2020 	function distributeReservedBoxes(uint256 _id, uint256 _amount) external authorised {
2021 		require(_id <= boxMouldCount && _id > 0, "ID !exist");
2022 		require(!lockedBoxes[_id], "Box locked");
2023 		require(voucherValidityInterval[_id] == 0, "Box distro over");
2024 
2025 		BoxMould storage boxMould = boxMoulds[_id];
2026 		uint128 currentEdition = boxMould.currentEditionCount;
2027 		uint256 length = reservations[_id].length;
2028 		uint256 i = 0;
2029 		while (length > 0 && _amount > 0) {
2030 			_buy(currentEdition, _id, i, reservations[_id][length - 1]);
2031 			reservations[_id].pop();
2032 			length--;
2033 			_amount--;
2034 			i++;
2035 		}
2036 		boxMould.currentEditionCount += uint128(i);
2037 		if (currentEdition + i == boxMould.maxEdition)
2038 			boxMould.live = uint8(1);
2039 		if (length == 0)
2040 			voucherValidityInterval[_id] = block.timestamp + 900;
2041 	}
2042 
2043 	function _buy(uint128 _currentEdition, uint256 _id, uint256 _new, address _recipient) internal {
2044 		boxes[totalSupply() + 1] = Box(_id, _currentEdition + _new + 1);
2045 		//safe mint?
2046 		emit BoxBought(_id, _currentEdition + _new + 1, totalSupply() + 1);
2047 		_mint(_recipient, totalSupply() + 1);
2048 	}
2049 
2050 	// close a sale if not sold out
2051 	function closeBox(uint256 _id) external authorised {
2052 		BoxMould storage boxMould = boxMoulds[_id];
2053 		require(_id <= boxMouldCount && _id > 0, "ID !exist.");
2054 		boxMould.live = uint8(1);
2055 	}
2056 
2057 	function setVendingMachine(address _machine) external onlyOwner {
2058 		vendingMachine = IVendingMachine(_machine);
2059 	}
2060 
2061 	function setBoxVoucher(address _vouchers) external onlyOwner {
2062 		boxVoucher = IBoxVoucher(_vouchers);
2063 	}
2064 
2065 	function setGasFee(uint256 _fee) external onlyOwner {
2066 		gasFee = _fee;
2067 	}
2068 
2069 	function distributeOffchain(uint256 _id, address[][] calldata _recipients, uint256[] calldata _ids) external authorised {
2070 		BoxMould memory boxMould= boxMoulds[_id];
2071 		require(boxMould.live == 1, "live");
2072 		require (_recipients[0].length == _ids.length, "bad array");
2073 
2074 		// i is batch number
2075 		for (uint256 i = 0; i < _recipients.length; i++) {
2076 			// j is for the index of nft ID to send
2077 			for (uint256 j = 0;j <  _recipients[0].length; j++)
2078 				vendingMachine.NFTMachineFor(_ids[j], _recipients[i][j]);
2079 		}
2080 		emit BatchDeployed(_id, _recipients.length);
2081 	}
2082 
2083 	function distributeShares(uint256 _id) external {
2084 		BoxMould storage boxMould= boxMoulds[_id];
2085 		require(_id <= boxMouldCount && _id > 0, "ID !exist.");
2086 		require(boxMould.live == 1 && boxMould.shared == 0,  "!distribute");
2087 		require(is100(_id), "sum != 100%.");
2088 
2089 		boxMould.shared = 1;
2090 		uint256 rev = uint256(boxMould.currentEditionCount).mul(boxMould.price);
2091 		uint256 share;
2092 		for (uint256 i = 0; i < team.length; i++) {
2093 			share = rev.mul(teamShare[team[i]]).div(TOTAL_SHARES);
2094 			team[i].transfer(share);
2095 		}
2096 		for (uint256 i = 0; i < boxMould.artists.length; i++) {
2097 			share = rev.mul(boxMould.shares[i]).div(TOTAL_SHARES);
2098 			boxMould.artists[i].transfer(share);
2099 		}
2100 	}
2101 
2102 	function is100(uint256 _id) internal returns(bool) {
2103 		BoxMould storage boxMould= boxMoulds[_id];
2104 		uint256 total;
2105 		for (uint256 i = 0; i < team.length; i++) {
2106 			total = total.add(teamShare[team[i]]);
2107 		}
2108 		for (uint256 i = 0; i < boxMould.shares.length; i++) {
2109 			total = total.add(boxMould.shares[i]);
2110 		}
2111 		return total == TOTAL_SHARES;
2112 	}
2113 
2114 	function getReservationCount(uint256 _id) external view returns(uint256) {
2115 		return reservations[_id].length;
2116 	}
2117 
2118 	function getArtist(uint256 _id) external view returns (address payable[] memory) {
2119 		return boxMoulds[_id].artists;
2120 	}
2121 
2122 	function getArtistShares(uint256 _id) external view returns (uint256[] memory) {
2123 		return boxMoulds[_id].shares;
2124 	}
2125 
2126     function updateTeamAddress(address payable newTeamAddress) public onlyOwner {
2127         teamAddress = newTeamAddress;
2128     }
2129     
2130     function updateSecondaryFee(uint256 newSecondaryBps) public onlyOwner {
2131         teamSecondaryBps = newSecondaryBps;
2132     }
2133 
2134     function getBoxMetaData(uint256 _id) external view returns 
2135     (uint256 boxId, uint256 boxEdition, uint128 boxMax, string memory boxName, string memory boxSeries, string memory boxTheme, string memory boxHashIPFS, string memory boxHashArweave) {
2136         Box memory box = boxes[_id];
2137         BoxMould memory mould = boxMoulds[box.mouldId];
2138         return (box.mouldId, box.edition, mould.maxEdition, mould.name, mould.series, mould.theme, mould.ipfsHash, mould.arweaveHash);
2139     }
2140 
2141 	function _transfer(address from, address to, uint256 tokenId) internal override {
2142 		Box memory box = boxes[tokenId];
2143 		require(!lockedBoxes[box.mouldId], "Box is locked");
2144 		super._transfer(from, to, tokenId);
2145 	}
2146 }
