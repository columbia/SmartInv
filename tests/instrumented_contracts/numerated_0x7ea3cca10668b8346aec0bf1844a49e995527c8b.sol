1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies in extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         // solhint-disable-next-line no-inline-assembly
38         assembly { size := extcodesize(account) }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
62         (bool success, ) = recipient.call{ value: amount }("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain`call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85       return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
95         return _functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
115      * with `errorMessage` as a fallback revert reason when `target` reverts.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         return _functionCallWithValue(target, data, value, errorMessage);
122     }
123 
124     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
125         require(isContract(target), "Address: call to non-contract");
126 
127         // solhint-disable-next-line avoid-low-level-calls
128         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
129         if (success) {
130             return returndata;
131         } else {
132             // Look for revert reason and bubble it up if present
133             if (returndata.length > 0) {
134                 // The easiest way to bubble the revert reason is using memory via assembly
135 
136                 // solhint-disable-next-line no-inline-assembly
137                 assembly {
138                     let returndata_size := mload(returndata)
139                     revert(add(32, returndata), returndata_size)
140                 }
141             } else {
142                 revert(errorMessage);
143             }
144         }
145     }
146 }
147 
148 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
149 
150 /*
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with GSN meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address payable) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes memory) {
166         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
167         return msg.data;
168     }
169 }
170 
171 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableMap
172 
173 /**
174  * @dev Library for managing an enumerable variant of Solidity's
175  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
176  * type.
177  *
178  * Maps have the following properties:
179  *
180  * - Entries are added, removed, and checked for existence in constant time
181  * (O(1)).
182  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
183  *
184  * ```
185  * contract Example {
186  *     // Add the library methods
187  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
188  *
189  *     // Declare a set state variable
190  *     EnumerableMap.UintToAddressMap private myMap;
191  * }
192  * ```
193  *
194  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
195  * supported.
196  */
197 library EnumerableMap {
198     // To implement this library for multiple types with as little code
199     // repetition as possible, we write it in terms of a generic Map type with
200     // bytes32 keys and values.
201     // The Map implementation uses private functions, and user-facing
202     // implementations (such as Uint256ToAddressMap) are just wrappers around
203     // the underlying Map.
204     // This means that we can only create new EnumerableMaps for types that fit
205     // in bytes32.
206 
207     struct MapEntry {
208         bytes32 _key;
209         bytes32 _value;
210     }
211 
212     struct Map {
213         // Storage of map keys and values
214         MapEntry[] _entries;
215 
216         // Position of the entry defined by a key in the `entries` array, plus 1
217         // because index 0 means a key is not in the map.
218         mapping (bytes32 => uint256) _indexes;
219     }
220 
221     /**
222      * @dev Adds a key-value pair to a map, or updates the value for an existing
223      * key. O(1).
224      *
225      * Returns true if the key was added to the map, that is if it was not
226      * already present.
227      */
228     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
229         // We read and store the key's index to prevent multiple reads from the same storage slot
230         uint256 keyIndex = map._indexes[key];
231 
232         if (keyIndex == 0) { // Equivalent to !contains(map, key)
233             map._entries.push(MapEntry({ _key: key, _value: value }));
234             // The entry is stored at length-1, but we add 1 to all indexes
235             // and use 0 as a sentinel value
236             map._indexes[key] = map._entries.length;
237             return true;
238         } else {
239             map._entries[keyIndex - 1]._value = value;
240             return false;
241         }
242     }
243 
244     /**
245      * @dev Removes a key-value pair from a map. O(1).
246      *
247      * Returns true if the key was removed from the map, that is if it was present.
248      */
249     function _remove(Map storage map, bytes32 key) private returns (bool) {
250         // We read and store the key's index to prevent multiple reads from the same storage slot
251         uint256 keyIndex = map._indexes[key];
252 
253         if (keyIndex != 0) { // Equivalent to contains(map, key)
254             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
255             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
256             // This modifies the order of the array, as noted in {at}.
257 
258             uint256 toDeleteIndex = keyIndex - 1;
259             uint256 lastIndex = map._entries.length - 1;
260 
261             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
262             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
263 
264             MapEntry storage lastEntry = map._entries[lastIndex];
265 
266             // Move the last entry to the index where the entry to delete is
267             map._entries[toDeleteIndex] = lastEntry;
268             // Update the index for the moved entry
269             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
270 
271             // Delete the slot where the moved entry was stored
272             map._entries.pop();
273 
274             // Delete the index for the deleted slot
275             delete map._indexes[key];
276 
277             return true;
278         } else {
279             return false;
280         }
281     }
282 
283     /**
284      * @dev Returns true if the key is in the map. O(1).
285      */
286     function _contains(Map storage map, bytes32 key) private view returns (bool) {
287         return map._indexes[key] != 0;
288     }
289 
290     /**
291      * @dev Returns the number of key-value pairs in the map. O(1).
292      */
293     function _length(Map storage map) private view returns (uint256) {
294         return map._entries.length;
295     }
296 
297    /**
298     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
299     *
300     * Note that there are no guarantees on the ordering of entries inside the
301     * array, and it may change when more entries are added or removed.
302     *
303     * Requirements:
304     *
305     * - `index` must be strictly less than {length}.
306     */
307     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
308         require(map._entries.length > index, "EnumerableMap: index out of bounds");
309 
310         MapEntry storage entry = map._entries[index];
311         return (entry._key, entry._value);
312     }
313 
314     /**
315      * @dev Returns the value associated with `key`.  O(1).
316      *
317      * Requirements:
318      *
319      * - `key` must be in the map.
320      */
321     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
322         return _get(map, key, "EnumerableMap: nonexistent key");
323     }
324 
325     /**
326      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
327      */
328     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
329         uint256 keyIndex = map._indexes[key];
330         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
331         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
332     }
333 
334     // UintToAddressMap
335 
336     struct UintToAddressMap {
337         Map _inner;
338     }
339 
340     /**
341      * @dev Adds a key-value pair to a map, or updates the value for an existing
342      * key. O(1).
343      *
344      * Returns true if the key was added to the map, that is if it was not
345      * already present.
346      */
347     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
348         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
349     }
350 
351     /**
352      * @dev Removes a value from a set. O(1).
353      *
354      * Returns true if the key was removed from the map, that is if it was present.
355      */
356     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
357         return _remove(map._inner, bytes32(key));
358     }
359 
360     /**
361      * @dev Returns true if the key is in the map. O(1).
362      */
363     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
364         return _contains(map._inner, bytes32(key));
365     }
366 
367     /**
368      * @dev Returns the number of elements in the map. O(1).
369      */
370     function length(UintToAddressMap storage map) internal view returns (uint256) {
371         return _length(map._inner);
372     }
373 
374    /**
375     * @dev Returns the element stored at position `index` in the set. O(1).
376     * Note that there are no guarantees on the ordering of values inside the
377     * array, and it may change when more values are added or removed.
378     *
379     * Requirements:
380     *
381     * - `index` must be strictly less than {length}.
382     */
383     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
384         (bytes32 key, bytes32 value) = _at(map._inner, index);
385         return (uint256(key), address(uint256(value)));
386     }
387 
388     /**
389      * @dev Returns the value associated with `key`.  O(1).
390      *
391      * Requirements:
392      *
393      * - `key` must be in the map.
394      */
395     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
396         return address(uint256(_get(map._inner, bytes32(key))));
397     }
398 
399     /**
400      * @dev Same as {get}, with a custom error message when `key` is not in the map.
401      */
402     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
403         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
404     }
405 }
406 
407 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableSet
408 
409 /**
410  * @dev Library for managing
411  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
412  * types.
413  *
414  * Sets have the following properties:
415  *
416  * - Elements are added, removed, and checked for existence in constant time
417  * (O(1)).
418  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
419  *
420  * ```
421  * contract Example {
422  *     // Add the library methods
423  *     using EnumerableSet for EnumerableSet.AddressSet;
424  *
425  *     // Declare a set state variable
426  *     EnumerableSet.AddressSet private mySet;
427  * }
428  * ```
429  *
430  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
431  * (`UintSet`) are supported.
432  */
433 library EnumerableSet {
434     // To implement this library for multiple types with as little code
435     // repetition as possible, we write it in terms of a generic Set type with
436     // bytes32 values.
437     // The Set implementation uses private functions, and user-facing
438     // implementations (such as AddressSet) are just wrappers around the
439     // underlying Set.
440     // This means that we can only create new EnumerableSets for types that fit
441     // in bytes32.
442 
443     struct Set {
444         // Storage of set values
445         bytes32[] _values;
446 
447         // Position of the value in the `values` array, plus 1 because index 0
448         // means a value is not in the set.
449         mapping (bytes32 => uint256) _indexes;
450     }
451 
452     /**
453      * @dev Add a value to a set. O(1).
454      *
455      * Returns true if the value was added to the set, that is if it was not
456      * already present.
457      */
458     function _add(Set storage set, bytes32 value) private returns (bool) {
459         if (!_contains(set, value)) {
460             set._values.push(value);
461             // The value is stored at length-1, but we add 1 to all indexes
462             // and use 0 as a sentinel value
463             set._indexes[value] = set._values.length;
464             return true;
465         } else {
466             return false;
467         }
468     }
469 
470     /**
471      * @dev Removes a value from a set. O(1).
472      *
473      * Returns true if the value was removed from the set, that is if it was
474      * present.
475      */
476     function _remove(Set storage set, bytes32 value) private returns (bool) {
477         // We read and store the value's index to prevent multiple reads from the same storage slot
478         uint256 valueIndex = set._indexes[value];
479 
480         if (valueIndex != 0) { // Equivalent to contains(set, value)
481             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
482             // the array, and then remove the last element (sometimes called as 'swap and pop').
483             // This modifies the order of the array, as noted in {at}.
484 
485             uint256 toDeleteIndex = valueIndex - 1;
486             uint256 lastIndex = set._values.length - 1;
487 
488             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
489             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
490 
491             bytes32 lastvalue = set._values[lastIndex];
492 
493             // Move the last value to the index where the value to delete is
494             set._values[toDeleteIndex] = lastvalue;
495             // Update the index for the moved value
496             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
497 
498             // Delete the slot where the moved value was stored
499             set._values.pop();
500 
501             // Delete the index for the deleted slot
502             delete set._indexes[value];
503 
504             return true;
505         } else {
506             return false;
507         }
508     }
509 
510     /**
511      * @dev Returns true if the value is in the set. O(1).
512      */
513     function _contains(Set storage set, bytes32 value) private view returns (bool) {
514         return set._indexes[value] != 0;
515     }
516 
517     /**
518      * @dev Returns the number of values on the set. O(1).
519      */
520     function _length(Set storage set) private view returns (uint256) {
521         return set._values.length;
522     }
523 
524    /**
525     * @dev Returns the value stored at position `index` in the set. O(1).
526     *
527     * Note that there are no guarantees on the ordering of values inside the
528     * array, and it may change when more values are added or removed.
529     *
530     * Requirements:
531     *
532     * - `index` must be strictly less than {length}.
533     */
534     function _at(Set storage set, uint256 index) private view returns (bytes32) {
535         require(set._values.length > index, "EnumerableSet: index out of bounds");
536         return set._values[index];
537     }
538 
539     // AddressSet
540 
541     struct AddressSet {
542         Set _inner;
543     }
544 
545     /**
546      * @dev Add a value to a set. O(1).
547      *
548      * Returns true if the value was added to the set, that is if it was not
549      * already present.
550      */
551     function add(AddressSet storage set, address value) internal returns (bool) {
552         return _add(set._inner, bytes32(uint256(value)));
553     }
554 
555     /**
556      * @dev Removes a value from a set. O(1).
557      *
558      * Returns true if the value was removed from the set, that is if it was
559      * present.
560      */
561     function remove(AddressSet storage set, address value) internal returns (bool) {
562         return _remove(set._inner, bytes32(uint256(value)));
563     }
564 
565     /**
566      * @dev Returns true if the value is in the set. O(1).
567      */
568     function contains(AddressSet storage set, address value) internal view returns (bool) {
569         return _contains(set._inner, bytes32(uint256(value)));
570     }
571 
572     /**
573      * @dev Returns the number of values in the set. O(1).
574      */
575     function length(AddressSet storage set) internal view returns (uint256) {
576         return _length(set._inner);
577     }
578 
579    /**
580     * @dev Returns the value stored at position `index` in the set. O(1).
581     *
582     * Note that there are no guarantees on the ordering of values inside the
583     * array, and it may change when more values are added or removed.
584     *
585     * Requirements:
586     *
587     * - `index` must be strictly less than {length}.
588     */
589     function at(AddressSet storage set, uint256 index) internal view returns (address) {
590         return address(uint256(_at(set._inner, index)));
591     }
592 
593 
594     // UintSet
595 
596     struct UintSet {
597         Set _inner;
598     }
599 
600     /**
601      * @dev Add a value to a set. O(1).
602      *
603      * Returns true if the value was added to the set, that is if it was not
604      * already present.
605      */
606     function add(UintSet storage set, uint256 value) internal returns (bool) {
607         return _add(set._inner, bytes32(value));
608     }
609 
610     /**
611      * @dev Removes a value from a set. O(1).
612      *
613      * Returns true if the value was removed from the set, that is if it was
614      * present.
615      */
616     function remove(UintSet storage set, uint256 value) internal returns (bool) {
617         return _remove(set._inner, bytes32(value));
618     }
619 
620     /**
621      * @dev Returns true if the value is in the set. O(1).
622      */
623     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
624         return _contains(set._inner, bytes32(value));
625     }
626 
627     /**
628      * @dev Returns the number of values on the set. O(1).
629      */
630     function length(UintSet storage set) internal view returns (uint256) {
631         return _length(set._inner);
632     }
633 
634    /**
635     * @dev Returns the value stored at position `index` in the set. O(1).
636     *
637     * Note that there are no guarantees on the ordering of values inside the
638     * array, and it may change when more values are added or removed.
639     *
640     * Requirements:
641     *
642     * - `index` must be strictly less than {length}.
643     */
644     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
645         return uint256(_at(set._inner, index));
646     }
647 }
648 
649 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC165
650 
651 /**
652  * @dev Interface of the ERC165 standard, as defined in the
653  * https://eips.ethereum.org/EIPS/eip-165[EIP].
654  *
655  * Implementers can declare support of contract interfaces, which can then be
656  * queried by others ({ERC165Checker}).
657  *
658  * For an implementation, see {ERC165}.
659  */
660 interface IERC165 {
661     /**
662      * @dev Returns true if this contract implements the interface defined by
663      * `interfaceId`. See the corresponding
664      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
665      * to learn more about how these ids are created.
666      *
667      * This function call must use less than 30 000 gas.
668      */
669     function supportsInterface(bytes4 interfaceId) external view returns (bool);
670 }
671 
672 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
673 
674 /**
675  * @dev Interface of the ERC20 standard as defined in the EIP.
676  */
677 interface IERC20 {
678     /**
679      * @dev Returns the amount of tokens in existence.
680      */
681     function totalSupply() external view returns (uint256);
682 
683     /**
684      * @dev Returns the amount of tokens owned by `account`.
685      */
686     function balanceOf(address account) external view returns (uint256);
687 
688     /**
689      * @dev Moves `amount` tokens from the caller's account to `recipient`.
690      *
691      * Returns a boolean value indicating whether the operation succeeded.
692      *
693      * Emits a {Transfer} event.
694      */
695     function transfer(address recipient, uint256 amount) external returns (bool);
696 
697     /**
698      * @dev Returns the remaining number of tokens that `spender` will be
699      * allowed to spend on behalf of `owner` through {transferFrom}. This is
700      * zero by default.
701      *
702      * This value changes when {approve} or {transferFrom} are called.
703      */
704     function allowance(address owner, address spender) external view returns (uint256);
705 
706     /**
707      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
708      *
709      * Returns a boolean value indicating whether the operation succeeded.
710      *
711      * IMPORTANT: Beware that changing an allowance with this method brings the risk
712      * that someone may use both the old and the new allowance by unfortunate
713      * transaction ordering. One possible solution to mitigate this race
714      * condition is to first reduce the spender's allowance to 0 and set the
715      * desired value afterwards:
716      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
717      *
718      * Emits an {Approval} event.
719      */
720     function approve(address spender, uint256 amount) external returns (bool);
721 
722     /**
723      * @dev Moves `amount` tokens from `sender` to `recipient` using the
724      * allowance mechanism. `amount` is then deducted from the caller's
725      * allowance.
726      *
727      * Returns a boolean value indicating whether the operation succeeded.
728      *
729      * Emits a {Transfer} event.
730      */
731     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
732 
733     /**
734      * @dev Emitted when `value` tokens are moved from one account (`from`) to
735      * another (`to`).
736      *
737      * Note that `value` may be zero.
738      */
739     event Transfer(address indexed from, address indexed to, uint256 value);
740 
741     /**
742      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
743      * a call to {approve}. `value` is the new allowance.
744      */
745     event Approval(address indexed owner, address indexed spender, uint256 value);
746 }
747 
748 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Receiver
749 
750 /**
751  * @title ERC721 token receiver interface
752  * @dev Interface for any contract that wants to support safeTransfers
753  * from ERC721 asset contracts.
754  */
755 interface IERC721Receiver {
756     /**
757      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
758      * by `operator` from `from`, this function is called.
759      *
760      * It must return its Solidity selector to confirm the token transfer.
761      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
762      *
763      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
764      */
765     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
766     external returns (bytes4);
767 }
768 
769 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
770 
771 /**
772  * @dev Wrappers over Solidity's arithmetic operations with added overflow
773  * checks.
774  *
775  * Arithmetic operations in Solidity wrap on overflow. This can easily result
776  * in bugs, because programmers usually assume that an overflow raises an
777  * error, which is the standard behavior in high level programming languages.
778  * `SafeMath` restores this intuition by reverting the transaction when an
779  * operation overflows.
780  *
781  * Using this library instead of the unchecked operations eliminates an entire
782  * class of bugs, so it's recommended to use it always.
783  */
784 library SafeMath {
785     /**
786      * @dev Returns the addition of two unsigned integers, reverting on
787      * overflow.
788      *
789      * Counterpart to Solidity's `+` operator.
790      *
791      * Requirements:
792      *
793      * - Addition cannot overflow.
794      */
795     function add(uint256 a, uint256 b) internal pure returns (uint256) {
796         uint256 c = a + b;
797         require(c >= a, "SafeMath: addition overflow");
798 
799         return c;
800     }
801 
802     /**
803      * @dev Returns the subtraction of two unsigned integers, reverting on
804      * overflow (when the result is negative).
805      *
806      * Counterpart to Solidity's `-` operator.
807      *
808      * Requirements:
809      *
810      * - Subtraction cannot overflow.
811      */
812     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
813         return sub(a, b, "SafeMath: subtraction overflow");
814     }
815 
816     /**
817      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
818      * overflow (when the result is negative).
819      *
820      * Counterpart to Solidity's `-` operator.
821      *
822      * Requirements:
823      *
824      * - Subtraction cannot overflow.
825      */
826     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
827         require(b <= a, errorMessage);
828         uint256 c = a - b;
829 
830         return c;
831     }
832 
833     /**
834      * @dev Returns the multiplication of two unsigned integers, reverting on
835      * overflow.
836      *
837      * Counterpart to Solidity's `*` operator.
838      *
839      * Requirements:
840      *
841      * - Multiplication cannot overflow.
842      */
843     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
844         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
845         // benefit is lost if 'b' is also tested.
846         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
847         if (a == 0) {
848             return 0;
849         }
850 
851         uint256 c = a * b;
852         require(c / a == b, "SafeMath: multiplication overflow");
853 
854         return c;
855     }
856 
857     /**
858      * @dev Returns the integer division of two unsigned integers. Reverts on
859      * division by zero. The result is rounded towards zero.
860      *
861      * Counterpart to Solidity's `/` operator. Note: this function uses a
862      * `revert` opcode (which leaves remaining gas untouched) while Solidity
863      * uses an invalid opcode to revert (consuming all remaining gas).
864      *
865      * Requirements:
866      *
867      * - The divisor cannot be zero.
868      */
869     function div(uint256 a, uint256 b) internal pure returns (uint256) {
870         return div(a, b, "SafeMath: division by zero");
871     }
872 
873     /**
874      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
875      * division by zero. The result is rounded towards zero.
876      *
877      * Counterpart to Solidity's `/` operator. Note: this function uses a
878      * `revert` opcode (which leaves remaining gas untouched) while Solidity
879      * uses an invalid opcode to revert (consuming all remaining gas).
880      *
881      * Requirements:
882      *
883      * - The divisor cannot be zero.
884      */
885     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
886         require(b > 0, errorMessage);
887         uint256 c = a / b;
888         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
889 
890         return c;
891     }
892 
893     /**
894      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
895      * Reverts when dividing by zero.
896      *
897      * Counterpart to Solidity's `%` operator. This function uses a `revert`
898      * opcode (which leaves remaining gas untouched) while Solidity uses an
899      * invalid opcode to revert (consuming all remaining gas).
900      *
901      * Requirements:
902      *
903      * - The divisor cannot be zero.
904      */
905     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
906         return mod(a, b, "SafeMath: modulo by zero");
907     }
908 
909     /**
910      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
911      * Reverts with custom message when dividing by zero.
912      *
913      * Counterpart to Solidity's `%` operator. This function uses a `revert`
914      * opcode (which leaves remaining gas untouched) while Solidity uses an
915      * invalid opcode to revert (consuming all remaining gas).
916      *
917      * Requirements:
918      *
919      * - The divisor cannot be zero.
920      */
921     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
922         require(b != 0, errorMessage);
923         return a % b;
924     }
925 }
926 
927 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Strings
928 
929 /**
930  * @dev String operations.
931  */
932 library Strings {
933     /**
934      * @dev Converts a `uint256` to its ASCII `string` representation.
935      */
936     function toString(uint256 value) internal pure returns (string memory) {
937         // Inspired by OraclizeAPI's implementation - MIT licence
938         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
939 
940         if (value == 0) {
941             return "0";
942         }
943         uint256 temp = value;
944         uint256 digits;
945         while (temp != 0) {
946             digits++;
947             temp /= 10;
948         }
949         bytes memory buffer = new bytes(digits);
950         uint256 index = digits - 1;
951         temp = value;
952         while (temp != 0) {
953             buffer[index--] = byte(uint8(48 + temp % 10));
954             temp /= 10;
955         }
956         return string(buffer);
957     }
958 }
959 
960 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC165
961 
962 /**
963  * @dev Implementation of the {IERC165} interface.
964  *
965  * Contracts may inherit from this and call {_registerInterface} to declare
966  * their support of an interface.
967  */
968 contract ERC165 is IERC165 {
969     /*
970      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
971      */
972     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
973 
974     /**
975      * @dev Mapping of interface ids to whether or not it's supported.
976      */
977     mapping(bytes4 => bool) private _supportedInterfaces;
978 
979     constructor () internal {
980         // Derived contracts need only register support for their own interfaces,
981         // we register support for ERC165 itself here
982         _registerInterface(_INTERFACE_ID_ERC165);
983     }
984 
985     /**
986      * @dev See {IERC165-supportsInterface}.
987      *
988      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
989      */
990     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
991         return _supportedInterfaces[interfaceId];
992     }
993 
994     /**
995      * @dev Registers the contract as an implementer of the interface defined by
996      * `interfaceId`. Support of the actual ERC165 interface is automatic and
997      * registering its interface id is not required.
998      *
999      * See {IERC165-supportsInterface}.
1000      *
1001      * Requirements:
1002      *
1003      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1004      */
1005     function _registerInterface(bytes4 interfaceId) internal virtual {
1006         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1007         _supportedInterfaces[interfaceId] = true;
1008     }
1009 }
1010 
1011 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721
1012 
1013 /**
1014  * @dev Required interface of an ERC721 compliant contract.
1015  */
1016 interface IERC721 is IERC165 {
1017     /**
1018      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1019      */
1020     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1021 
1022     /**
1023      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1024      */
1025     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1026 
1027     /**
1028      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1029      */
1030     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1031 
1032     /**
1033      * @dev Returns the number of tokens in ``owner``'s account.
1034      */
1035     function balanceOf(address owner) external view returns (uint256 balance);
1036 
1037     /**
1038      * @dev Returns the owner of the `tokenId` token.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      */
1044     function ownerOf(uint256 tokenId) external view returns (address owner);
1045 
1046     /**
1047      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1048      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1049      *
1050      * Requirements:
1051      *
1052      * - `from` cannot be the zero address.
1053      * - `to` cannot be the zero address.
1054      * - `tokenId` token must exist and be owned by `from`.
1055      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1061 
1062     /**
1063      * @dev Transfers `tokenId` token from `from` to `to`.
1064      *
1065      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1066      *
1067      * Requirements:
1068      *
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must be owned by `from`.
1072      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function transferFrom(address from, address to, uint256 tokenId) external;
1077 
1078     /**
1079      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1080      * The approval is cleared when the token is transferred.
1081      *
1082      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1083      *
1084      * Requirements:
1085      *
1086      * - The caller must own the token or be an approved operator.
1087      * - `tokenId` must exist.
1088      *
1089      * Emits an {Approval} event.
1090      */
1091     function approve(address to, uint256 tokenId) external;
1092 
1093     /**
1094      * @dev Returns the account approved for `tokenId` token.
1095      *
1096      * Requirements:
1097      *
1098      * - `tokenId` must exist.
1099      */
1100     function getApproved(uint256 tokenId) external view returns (address operator);
1101 
1102     /**
1103      * @dev Approve or remove `operator` as an operator for the caller.
1104      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1105      *
1106      * Requirements:
1107      *
1108      * - The `operator` cannot be the caller.
1109      *
1110      * Emits an {ApprovalForAll} event.
1111      */
1112     function setApprovalForAll(address operator, bool _approved) external;
1113 
1114     /**
1115      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1116      *
1117      * See {setApprovalForAll}
1118      */
1119     function isApprovedForAll(address owner, address operator) external view returns (bool);
1120 
1121     /**
1122       * @dev Safely transfers `tokenId` token from `from` to `to`.
1123       *
1124       * Requirements:
1125       *
1126      * - `from` cannot be the zero address.
1127      * - `to` cannot be the zero address.
1128       * - `tokenId` token must exist and be owned by `from`.
1129       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1130       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1131       *
1132       * Emits a {Transfer} event.
1133       */
1134     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1135 }
1136 
1137 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Ownable
1138 
1139 /**
1140  * @dev Contract module which provides a basic access control mechanism, where
1141  * there is an account (an owner) that can be granted exclusive access to
1142  * specific functions.
1143  *
1144  * By default, the owner account will be the one that deploys the contract. This
1145  * can later be changed with {transferOwnership}.
1146  *
1147  * This module is used through inheritance. It will make available the modifier
1148  * `onlyOwner`, which can be applied to your functions to restrict their use to
1149  * the owner.
1150  */
1151 contract Ownable is Context {
1152     address private _owner;
1153 
1154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1155 
1156     /**
1157      * @dev Initializes the contract setting the deployer as the initial owner.
1158      */
1159     constructor () internal {
1160         address msgSender = _msgSender();
1161         _owner = msgSender;
1162         emit OwnershipTransferred(address(0), msgSender);
1163     }
1164 
1165     /**
1166      * @dev Returns the address of the current owner.
1167      */
1168     function owner() public view returns (address) {
1169         return _owner;
1170     }
1171 
1172     /**
1173      * @dev Throws if called by any account other than the owner.
1174      */
1175     modifier onlyOwner() {
1176         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1177         _;
1178     }
1179 
1180     /**
1181      * @dev Leaves the contract without owner. It will not be possible to call
1182      * `onlyOwner` functions anymore. Can only be called by the current owner.
1183      *
1184      * NOTE: Renouncing ownership will leave the contract without an owner,
1185      * thereby removing any functionality that is only available to the owner.
1186      */
1187     function renounceOwnership() public virtual onlyOwner {
1188         emit OwnershipTransferred(_owner, address(0));
1189         _owner = address(0);
1190     }
1191 
1192     /**
1193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1194      * Can only be called by the current owner.
1195      */
1196     function transferOwnership(address newOwner) public virtual onlyOwner {
1197         require(newOwner != address(0), "Ownable: new owner is the zero address");
1198         emit OwnershipTransferred(_owner, newOwner);
1199         _owner = newOwner;
1200     }
1201 }
1202 
1203 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Enumerable
1204 
1205 /**
1206  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1207  * @dev See https://eips.ethereum.org/EIPS/eip-721
1208  */
1209 interface IERC721Enumerable is IERC721 {
1210 
1211     /**
1212      * @dev Returns the total amount of tokens stored by the contract.
1213      */
1214     function totalSupply() external view returns (uint256);
1215 
1216     /**
1217      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1218      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1219      */
1220     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1221 
1222     /**
1223      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1224      * Use along with {totalSupply} to enumerate all tokens.
1225      */
1226     function tokenByIndex(uint256 index) external view returns (uint256);
1227 }
1228 
1229 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Metadata
1230 
1231 /**
1232  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1233  * @dev See https://eips.ethereum.org/EIPS/eip-721
1234  */
1235 interface IERC721Metadata is IERC721 {
1236 
1237     /**
1238      * @dev Returns the token collection name.
1239      */
1240     function name() external view returns (string memory);
1241 
1242     /**
1243      * @dev Returns the token collection symbol.
1244      */
1245     function symbol() external view returns (string memory);
1246 
1247     /**
1248      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1249      */
1250     function tokenURI(uint256 tokenId) external view returns (string memory);
1251 }
1252 
1253 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC721
1254 
1255 /**
1256  * @title ERC721 Non-Fungible Token Standard basic implementation
1257  * @dev see https://eips.ethereum.org/EIPS/eip-721
1258  */
1259 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1260     using SafeMath for uint256;
1261     using Address for address;
1262     using EnumerableSet for EnumerableSet.UintSet;
1263     using EnumerableMap for EnumerableMap.UintToAddressMap;
1264     using Strings for uint256;
1265 
1266     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1267     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1268     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1269 
1270     // Mapping from holder address to their (enumerable) set of owned tokens
1271     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1272 
1273     // Enumerable mapping from token ids to their owners
1274     EnumerableMap.UintToAddressMap private _tokenOwners;
1275 
1276     // Mapping from token ID to approved address
1277     mapping (uint256 => address) private _tokenApprovals;
1278 
1279     // Mapping from owner to operator approvals
1280     mapping (address => mapping (address => bool)) private _operatorApprovals;
1281 
1282     // Token name
1283     string private _name;
1284 
1285     // Token symbol
1286     string private _symbol;
1287 
1288     // Optional mapping for token URIs
1289     mapping (uint256 => string) private _tokenURIs;
1290 
1291     // Base URI
1292     string private _baseURI;
1293 
1294     /*
1295      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1296      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1297      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1298      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1299      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1300      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1301      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1302      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1303      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1304      *
1305      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1306      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1307      */
1308     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1309 
1310     /*
1311      *     bytes4(keccak256('name()')) == 0x06fdde03
1312      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1313      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1314      *
1315      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1316      */
1317     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1318 
1319     /*
1320      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1321      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1322      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1323      *
1324      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1325      */
1326     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1327 
1328     /**
1329      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1330      */
1331     constructor (string memory name, string memory symbol) public {
1332         _name = name;
1333         _symbol = symbol;
1334 
1335         // register the supported interfaces to conform to ERC721 via ERC165
1336         _registerInterface(_INTERFACE_ID_ERC721);
1337         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1338         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1339     }
1340 
1341     /**
1342      * @dev See {IERC721-balanceOf}.
1343      */
1344     function balanceOf(address owner) public view override returns (uint256) {
1345         require(owner != address(0), "ERC721: balance query for the zero address");
1346 
1347         return _holderTokens[owner].length();
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-ownerOf}.
1352      */
1353     function ownerOf(uint256 tokenId) public view override returns (address) {
1354         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1355     }
1356 
1357     /**
1358      * @dev See {IERC721Metadata-name}.
1359      */
1360     function name() public view override returns (string memory) {
1361         return _name;
1362     }
1363 
1364     /**
1365      * @dev See {IERC721Metadata-symbol}.
1366      */
1367     function symbol() public view override returns (string memory) {
1368         return _symbol;
1369     }
1370 
1371     /**
1372      * @dev See {IERC721Metadata-tokenURI}.
1373      */
1374     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1375         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1376 
1377         string memory _tokenURI = _tokenURIs[tokenId];
1378 
1379         // If there is no base URI, return the token URI.
1380         if (bytes(_baseURI).length == 0) {
1381             return _tokenURI;
1382         }
1383         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1384         if (bytes(_tokenURI).length > 0) {
1385             return string(abi.encodePacked(_baseURI, _tokenURI));
1386         }
1387         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1388         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1389     }
1390 
1391     /**
1392     * @dev Returns the base URI set via {_setBaseURI}. This will be
1393     * automatically added as a prefix in {tokenURI} to each token's URI, or
1394     * to the token ID if no specific URI is set for that token ID.
1395     */
1396     function baseURI() public view returns (string memory) {
1397         return _baseURI;
1398     }
1399 
1400     /**
1401      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1402      */
1403     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1404         return _holderTokens[owner].at(index);
1405     }
1406 
1407     /**
1408      * @dev See {IERC721Enumerable-totalSupply}.
1409      */
1410     function totalSupply() public view override returns (uint256) {
1411         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1412         return _tokenOwners.length();
1413     }
1414 
1415     /**
1416      * @dev See {IERC721Enumerable-tokenByIndex}.
1417      */
1418     function tokenByIndex(uint256 index) public view override returns (uint256) {
1419         (uint256 tokenId, ) = _tokenOwners.at(index);
1420         return tokenId;
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-approve}.
1425      */
1426     function approve(address to, uint256 tokenId) public virtual override {
1427         address owner = ownerOf(tokenId);
1428         require(to != owner, "ERC721: approval to current owner");
1429 
1430         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1431             "ERC721: approve caller is not owner nor approved for all"
1432         );
1433 
1434         _approve(to, tokenId);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721-getApproved}.
1439      */
1440     function getApproved(uint256 tokenId) public view override returns (address) {
1441         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1442 
1443         return _tokenApprovals[tokenId];
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-setApprovalForAll}.
1448      */
1449     function setApprovalForAll(address operator, bool approved) public virtual override {
1450         require(operator != _msgSender(), "ERC721: approve to caller");
1451 
1452         _operatorApprovals[_msgSender()][operator] = approved;
1453         emit ApprovalForAll(_msgSender(), operator, approved);
1454     }
1455 
1456     /**
1457      * @dev See {IERC721-isApprovedForAll}.
1458      */
1459     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1460         return _operatorApprovals[owner][operator];
1461     }
1462 
1463     /**
1464      * @dev See {IERC721-transferFrom}.
1465      */
1466     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1467         //solhint-disable-next-line max-line-length
1468         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1469 
1470         _transfer(from, to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-safeTransferFrom}.
1475      */
1476     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1477         safeTransferFrom(from, to, tokenId, "");
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-safeTransferFrom}.
1482      */
1483     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1484         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1485         _safeTransfer(from, to, tokenId, _data);
1486     }
1487 
1488     /**
1489      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1490      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1491      *
1492      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1493      *
1494      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1495      * implement alternative mechanisms to perform token transfer, such as signature-based.
1496      *
1497      * Requirements:
1498      *
1499      * - `from` cannot be the zero address.
1500      * - `to` cannot be the zero address.
1501      * - `tokenId` token must exist and be owned by `from`.
1502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1503      *
1504      * Emits a {Transfer} event.
1505      */
1506     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1507         _transfer(from, to, tokenId);
1508         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1509     }
1510 
1511     /**
1512      * @dev Returns whether `tokenId` exists.
1513      *
1514      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1515      *
1516      * Tokens start existing when they are minted (`_mint`),
1517      * and stop existing when they are burned (`_burn`).
1518      */
1519     function _exists(uint256 tokenId) internal view returns (bool) {
1520         return _tokenOwners.contains(tokenId);
1521     }
1522 
1523     /**
1524      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1525      *
1526      * Requirements:
1527      *
1528      * - `tokenId` must exist.
1529      */
1530     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1531         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1532         address owner = ownerOf(tokenId);
1533         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1534     }
1535 
1536     /**
1537      * @dev Safely mints `tokenId` and transfers it to `to`.
1538      *
1539      * Requirements:
1540      d*
1541      * - `tokenId` must not exist.
1542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1543      *
1544      * Emits a {Transfer} event.
1545      */
1546     function _safeMint(address to, uint256 tokenId) internal virtual {
1547         _safeMint(to, tokenId, "");
1548     }
1549 
1550     /**
1551      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1552      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1553      */
1554     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1555         _mint(to, tokenId);
1556         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1557     }
1558 
1559     /**
1560      * @dev Mints `tokenId` and transfers it to `to`.
1561      *
1562      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1563      *
1564      * Requirements:
1565      *
1566      * - `tokenId` must not exist.
1567      * - `to` cannot be the zero address.
1568      *
1569      * Emits a {Transfer} event.
1570      */
1571     function _mint(address to, uint256 tokenId) internal virtual {
1572         require(to != address(0), "ERC721: mint to the zero address");
1573         require(!_exists(tokenId), "ERC721: token already minted");
1574 
1575         _beforeTokenTransfer(address(0), to, tokenId);
1576 
1577         _holderTokens[to].add(tokenId);
1578 
1579         _tokenOwners.set(tokenId, to);
1580 
1581         emit Transfer(address(0), to, tokenId);
1582     }
1583 
1584     /**
1585      * @dev Destroys `tokenId`.
1586      * The approval is cleared when the token is burned.
1587      *
1588      * Requirements:
1589      *
1590      * - `tokenId` must exist.
1591      *
1592      * Emits a {Transfer} event.
1593      */
1594     function _burn(uint256 tokenId) internal virtual {
1595         address owner = ownerOf(tokenId);
1596 
1597         _beforeTokenTransfer(owner, address(0), tokenId);
1598 
1599         // Clear approvals
1600         _approve(address(0), tokenId);
1601 
1602         // Clear metadata (if any)
1603         if (bytes(_tokenURIs[tokenId]).length != 0) {
1604             delete _tokenURIs[tokenId];
1605         }
1606 
1607         _holderTokens[owner].remove(tokenId);
1608 
1609         _tokenOwners.remove(tokenId);
1610 
1611         emit Transfer(owner, address(0), tokenId);
1612     }
1613 
1614     /**
1615      * @dev Transfers `tokenId` from `from` to `to`.
1616      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1617      *
1618      * Requirements:
1619      *
1620      * - `to` cannot be the zero address.
1621      * - `tokenId` token must be owned by `from`.
1622      *
1623      * Emits a {Transfer} event.
1624      */
1625     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1626         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1627         require(to != address(0), "ERC721: transfer to the zero address");
1628 
1629         _beforeTokenTransfer(from, to, tokenId);
1630 
1631         // Clear approvals from the previous owner
1632         _approve(address(0), tokenId);
1633 
1634         _holderTokens[from].remove(tokenId);
1635         _holderTokens[to].add(tokenId);
1636 
1637         _tokenOwners.set(tokenId, to);
1638 
1639         emit Transfer(from, to, tokenId);
1640     }
1641 
1642     /**
1643      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1644      *
1645      * Requirements:
1646      *
1647      * - `tokenId` must exist.
1648      */
1649     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1650         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1651         _tokenURIs[tokenId] = _tokenURI;
1652     }
1653 
1654     /**
1655      * @dev Internal function to set the base URI for all token IDs. It is
1656      * automatically added as a prefix to the value returned in {tokenURI},
1657      * or to the token ID if {tokenURI} is empty.
1658      */
1659     function _setBaseURI(string memory baseURI_) internal virtual {
1660         _baseURI = baseURI_;
1661     }
1662 
1663     /**
1664      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1665      * The call is not executed if the target address is not a contract.
1666      *
1667      * @param from address representing the previous owner of the given token ID
1668      * @param to target address that will receive the tokens
1669      * @param tokenId uint256 ID of the token to be transferred
1670      * @param _data bytes optional data to send along with the call
1671      * @return bool whether the call correctly returned the expected magic value
1672      */
1673     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1674         private returns (bool)
1675     {
1676         if (!to.isContract()) {
1677             return true;
1678         }
1679         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1680             IERC721Receiver(to).onERC721Received.selector,
1681             _msgSender(),
1682             from,
1683             tokenId,
1684             _data
1685         ), "ERC721: transfer to non ERC721Receiver implementer");
1686         bytes4 retval = abi.decode(returndata, (bytes4));
1687         return (retval == _ERC721_RECEIVED);
1688     }
1689 
1690     function _approve(address to, uint256 tokenId) private {
1691         _tokenApprovals[tokenId] = to;
1692         emit Approval(ownerOf(tokenId), to, tokenId);
1693     }
1694 
1695     /**
1696      * @dev Hook that is called before any token transfer. This includes minting
1697      * and burning.
1698      *
1699      * Calling conditions:
1700      *
1701      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1702      * transferred to `to`.
1703      * - When `from` is zero, `tokenId` will be minted for `to`.
1704      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1705      * - `from` cannot be the zero address.
1706      * - `to` cannot be the zero address.
1707      *
1708      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1709      */
1710     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1711 }
1712 
1713 // Part: ERC721Namable
1714 
1715 contract ERC721Namable is ERC721 {
1716 
1717 	uint256 public nameChangePrice = 10 ether;
1718 	// uint256 constant public BIO_CHANGE_PRICE = 100 ether;
1719 
1720 	// mapping(uint256 => string) public bio;
1721 
1722 	// Mapping from token ID to name
1723 	mapping (uint256 => string) private _tokenName;
1724 
1725 	// Mapping if certain name string has already been reserved
1726 	mapping (string => bool) private _nameReserved;
1727 
1728 	event NameChange (uint256 indexed tokenId, string newName);
1729 	event BioChange (uint256 indexed tokenId, string bio);
1730 
1731 	constructor(string memory _name, string memory _symbol, string[] memory _names, uint256[] memory _ids) public ERC721(_name, _symbol) {
1732 		for (uint256 i = 0; i < _ids.length; i++)
1733 		{
1734 			toggleReserveName(_names[i], true);
1735 			_tokenName[_ids[i]] = _names[i];
1736 			emit NameChange(_ids[i], _names[i]);
1737 		}
1738 	}
1739 
1740 	// function changeBio(uint256 _tokenId, string memory _bio) public virtual {
1741 	// 	address owner = ownerOf(_tokenId);
1742 	// 	require(_msgSender() == owner, "ERC721: caller is not the owner");
1743 
1744 	// 	bio[_tokenId] = _bio;
1745 	// 	emit BioChange(_tokenId, _bio); 
1746 	// }
1747 
1748 	function changeName(uint256 tokenId, string memory newName) public virtual {
1749 		address owner = ownerOf(tokenId);
1750 
1751 		require(_msgSender() == owner, "ERC721: caller is not the owner");
1752 		require(validateName(newName) == true, "Not a valid new name");
1753 		require(sha256(bytes(newName)) != sha256(bytes(_tokenName[tokenId])), "New name is same as the current one");
1754 		require(isNameReserved(newName) == false, "Name already reserved");
1755 
1756 		// If already named, dereserve old name
1757 		if (bytes(_tokenName[tokenId]).length > 0) {
1758 			toggleReserveName(_tokenName[tokenId], false);
1759 		}
1760 		toggleReserveName(newName, true);
1761 		_tokenName[tokenId] = newName;
1762 		emit NameChange(tokenId, newName);
1763 	}
1764 
1765 	/**
1766 	 * @dev Reserves the name if isReserve is set to true, de-reserves if set to false
1767 	 */
1768 	function toggleReserveName(string memory str, bool isReserve) internal {
1769 		_nameReserved[toLower(str)] = isReserve;
1770 	}
1771 
1772 	/**
1773 	 * @dev Returns name of the NFT at index.
1774 	 */
1775 	function tokenNameByIndex(uint256 index) public view returns (string memory) {
1776 		return _tokenName[index];
1777 	}
1778 
1779 	/**
1780 	 * @dev Returns if the name has been reserved.
1781 	 */
1782 	function isNameReserved(string memory nameString) public view returns (bool) {
1783 		return _nameReserved[toLower(nameString)];
1784 	}
1785 
1786 	function validateName(string memory str) public pure returns (bool){
1787 		bytes memory b = bytes(str);
1788 		if(b.length < 1) return false;
1789 		if(b.length > 25) return false; // Cannot be longer than 25 characters
1790 		if(b[0] == 0x20) return false; // Leading space
1791 		if (b[b.length - 1] == 0x20) return false; // Trailing space
1792 
1793 		bytes1 lastChar = b[0];
1794 
1795 		for(uint i; i<b.length; i++){
1796 			bytes1 char = b[i];
1797 
1798 			if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces
1799 
1800 			if(
1801 				!(char >= 0x30 && char <= 0x39) && //9-0
1802 				!(char >= 0x41 && char <= 0x5A) && //A-Z
1803 				!(char >= 0x61 && char <= 0x7A) && //a-z
1804 				!(char == 0x20) //space
1805 			)
1806 				return false;
1807 
1808 			lastChar = char;
1809 		}
1810 
1811 		return true;
1812 	}
1813 
1814 	 /**
1815 	 * @dev Converts the string to lowercase
1816 	 */
1817 	function toLower(string memory str) public pure returns (string memory){
1818 		bytes memory bStr = bytes(str);
1819 		bytes memory bLower = new bytes(bStr.length);
1820 		for (uint i = 0; i < bStr.length; i++) {
1821 			// Uppercase character
1822 			if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
1823 				bLower[i] = bytes1(uint8(bStr[i]) + 32);
1824 			} else {
1825 				bLower[i] = bStr[i];
1826 			}
1827 		}
1828 		return string(bLower);
1829 	}
1830 }
1831 
1832 // File: KongzVx.sol
1833 
1834 contract KongzVX is ERC721Namable, Ownable {
1835 
1836 	address constant public KONGZ = address(0x57a204AA1042f6E66DD7730813f4024114d74f37);
1837 	uint256 constant public CAP = 15000;
1838 	uint256 constant public MINTABLE = 14000;
1839 	uint256 constant public BUYABLE = 10000;
1840 	uint256 constant public PRICE = 7 ether / 100;
1841 
1842 	uint256[MINTABLE] internal availableIds;
1843 	uint256 public sold;
1844 	uint256 public minted;
1845 
1846 	address public banana;
1847 	uint256 public startTime;
1848 
1849 	mapping(uint256 => uint256) public bebeClaimBitMask;
1850 
1851 
1852 	constructor(address _banana, string memory _name, string memory _symbol, string[] memory _names, uint256[] memory _ids) public ERC721Namable(_name, _symbol, _names, _ids) {
1853 		_setBaseURI("http://kongz.herokuapp.com/api/metadata-vx");
1854 		banana = _banana;
1855 	}
1856 
1857 	function setStartTime(uint256 _start) external onlyOwner {
1858 		require(block.timestamp < startTime || startTime == 0);
1859 		require(_start > block.timestamp);
1860 		startTime = _start;
1861 	}
1862 
1863 	function updateURI(string memory newURI) public onlyOwner {
1864 		_setBaseURI(newURI);
1865 	}
1866 
1867 	function setBanana(address _banana) external onlyOwner {
1868 		banana = _banana;
1869 	}
1870 
1871 	function changeNamePrice(uint256 _price) external onlyOwner {
1872 		nameChangePrice = _price;
1873 	}
1874 
1875 	function _isContract(address _addr) internal view returns (bool) {
1876 		uint32 _size;
1877 		assembly {
1878 			_size:= extcodesize(_addr)
1879 		}
1880 		return (_size > 0);
1881 	}
1882 
1883 	function isClaimed(uint256 _tokenId) public view returns (bool) {
1884 		uint256 wordIndex = _tokenId / 256;
1885 		uint256 bitIndex = _tokenId % 256;
1886 		uint256 mask = 1 << bitIndex;
1887 		return bebeClaimBitMask[wordIndex] & mask == mask;
1888 	}
1889 
1890 	function _setClaimed(uint256 _tokenId) internal{
1891 		uint256 wordIndex = _tokenId / 256;
1892 		uint256 bitIndex = _tokenId % 256;
1893 		uint256 mask = 1 << bitIndex;
1894 		bebeClaimBitMask[wordIndex] |= mask;
1895 	}
1896 
1897 	function _getNewId(uint256 _totalMinted) internal returns(uint256 value) {
1898 		uint256 remaining = MINTABLE - _totalMinted;
1899         uint rand = uint256(keccak256(abi.encodePacked(msg.sender, block.difficulty, block.timestamp, remaining))) % remaining;
1900 		value = 0;
1901 		// if array value exists, use, otherwise, use generated random value
1902 		if (availableIds[rand] != 0)
1903 			value = availableIds[rand];
1904 		else
1905 			value = rand;
1906 		// store remaining - 1 in used ID to create mapping
1907 		if (availableIds[remaining - 1] == 0)
1908 			availableIds[rand] = remaining - 1;
1909 		else
1910 			availableIds[rand] = availableIds[remaining - 1];
1911 		value += 1001;		
1912 	}
1913 
1914 	// function claim(uint256[] calldata _tokenIds) external {
1915 	// 	uint256 currentMinted = sold + minted;
1916 	// 	uint256 bebeIndex = 0;
1917 	// 	for (uint256 i = 0; i < _tokenIds.length; i++) {
1918 	// 		require(IERC721(KONGZ).ownerOf(_tokenIds[i]) == msg.sender, "KongzVX: !owner of token");
1919 	// 		if (_tokenIds[i] < 1004) {
1920 	// 			require(!_exists(_tokenIds[i]), "KongzVX: Genesis claimed already");
1921 	// 			_mint(msg.sender, _tokenIds[i]);
1922 	// 		}
1923 	// 		else {
1924 	// 			require(!isClaimed(_tokenIds[i]), "KongzVX: Bebe claimed already");
1925 	// 			_setClaimed(_tokenIds[i]);
1926 	// 			_mint(msg.sender, _getNewId(currentMinted + bebeIndex));
1927 	// 			bebeIndex++;
1928 	// 		}
1929 	// 	}
1930 	// 	minted += bebeIndex;
1931 	// }
1932 
1933 	function claim(uint256 _tokenId) external {
1934 		require(block.timestamp >= startTime && startTime != 0, "KongzVX: Claiming not started");
1935 		require(IERC721(KONGZ).ownerOf(_tokenId) == msg.sender, "KongzVX: !owner of token");
1936 		if (_tokenId < 1001) {
1937 			require(!_exists(_tokenId), "KongzVX: Genesis claimed already");
1938 			_mint(msg.sender, _tokenId);
1939 		}
1940 		else {
1941 			uint256 currentMinted = sold + minted;
1942 			require(!isClaimed(_tokenId), "KongzVX: Bebe claimed already");
1943 			_setClaimed(_tokenId);
1944 			_mint(msg.sender, _getNewId(currentMinted));
1945 			minted++;
1946 		}
1947 	}
1948 
1949 	function mint(uint256 _amount) external payable {
1950 		require(block.timestamp >= startTime && startTime != 0, "KongzVX: Minting not started");
1951 		require(sold + _amount <= BUYABLE, "KongzVX: Buyable amount has been reached");
1952 		require(_amount < 4, "KongzVX: Buy limit is 3");
1953 		require(msg.value == PRICE * _amount, "KongzVX: incorrect price");
1954 		require(!_isContract(msg.sender), "KongzVX: Caller cannot be contract");
1955 
1956 		uint256 currentMinted = sold + minted;
1957 		for (uint256 i = 0; i < _amount; i++)
1958 			_mint(msg.sender, _getNewId(currentMinted + i));
1959 		sold += _amount;
1960 	}
1961 
1962 	function changeName(uint256 tokenId, string memory newName) public override {
1963 		IERC20(banana).transferFrom(msg.sender, owner(), nameChangePrice);
1964 		super.changeName(tokenId, newName);
1965 	}
1966 
1967 	function fetchSaleFunds() external onlyOwner {
1968 		msg.sender.transfer(address(this).balance);
1969 	}
1970 }
