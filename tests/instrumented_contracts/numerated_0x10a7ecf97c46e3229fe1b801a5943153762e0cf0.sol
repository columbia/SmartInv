1 // SPDX-License-Identifier: MIT AND UNLICENSED
2 
3 pragma solidity ^0.6.2;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     /**
10      * @dev Converts a `uint256` to its ASCII `string` representation.
11      */
12     function toString(uint256 value) internal pure returns (string memory) {
13         // Inspired by OraclizeAPI's implementation - MIT licence
14         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
15 
16         if (value == 0) {
17             return "0";
18         }
19         uint256 temp = value;
20         uint256 digits;
21         while (temp != 0) {
22             digits++;
23             temp /= 10;
24         }
25         bytes memory buffer = new bytes(digits);
26         uint256 index = digits - 1;
27         temp = value;
28         while (temp != 0) {
29             buffer[index--] = byte(uint8(48 + temp % 10));
30             temp /= 10;
31         }
32         return string(buffer);
33     }
34 }
35 
36 
37 /**
38  * @dev Library for managing an enumerable variant of Solidity's
39  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
40  * type.
41  *
42  * Maps have the following properties:
43  *
44  * - Entries are added, removed, and checked for existence in constant time
45  * (O(1)).
46  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
47  *
48  * ```
49  * contract Example {
50  *     // Add the library methods
51  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
52  *
53  *     // Declare a set state variable
54  *     EnumerableMap.UintToAddressMap private myMap;
55  * }
56  * ```
57  *
58  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
59  * supported.
60  */
61 library EnumerableMap {
62     // To implement this library for multiple types with as little code
63     // repetition as possible, we write it in terms of a generic Map type with
64     // bytes32 keys and values.
65     // The Map implementation uses private functions, and user-facing
66     // implementations (such as Uint256ToAddressMap) are just wrappers around
67     // the underlying Map.
68     // This means that we can only create new EnumerableMaps for types that fit
69     // in bytes32.
70 
71     struct MapEntry {
72         bytes32 _key;
73         bytes32 _value;
74     }
75 
76     struct Map {
77         // Storage of map keys and values
78         MapEntry[] _entries;
79 
80         // Position of the entry defined by a key in the `entries` array, plus 1
81         // because index 0 means a key is not in the map.
82         mapping (bytes32 => uint256) _indexes;
83     }
84 
85     /**
86      * @dev Adds a key-value pair to a map, or updates the value for an existing
87      * key. O(1).
88      *
89      * Returns true if the key was added to the map, that is if it was not
90      * already present.
91      */
92     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
93         // We read and store the key's index to prevent multiple reads from the same storage slot
94         uint256 keyIndex = map._indexes[key];
95 
96         if (keyIndex == 0) { // Equivalent to !contains(map, key)
97             map._entries.push(MapEntry({ _key: key, _value: value }));
98             // The entry is stored at length-1, but we add 1 to all indexes
99             // and use 0 as a sentinel value
100             map._indexes[key] = map._entries.length;
101             return true;
102         } else {
103             map._entries[keyIndex - 1]._value = value;
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Removes a key-value pair from a map. O(1).
110      *
111      * Returns true if the key was removed from the map, that is if it was present.
112      */
113     function _remove(Map storage map, bytes32 key) private returns (bool) {
114         // We read and store the key's index to prevent multiple reads from the same storage slot
115         uint256 keyIndex = map._indexes[key];
116 
117         if (keyIndex != 0) { // Equivalent to contains(map, key)
118             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
119             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
120             // This modifies the order of the array, as noted in {at}.
121 
122             uint256 toDeleteIndex = keyIndex - 1;
123             uint256 lastIndex = map._entries.length - 1;
124 
125             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
126             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
127 
128             MapEntry storage lastEntry = map._entries[lastIndex];
129 
130             // Move the last entry to the index where the entry to delete is
131             map._entries[toDeleteIndex] = lastEntry;
132             // Update the index for the moved entry
133             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
134 
135             // Delete the slot where the moved entry was stored
136             map._entries.pop();
137 
138             // Delete the index for the deleted slot
139             delete map._indexes[key];
140 
141             return true;
142         } else {
143             return false;
144         }
145     }
146 
147     /**
148      * @dev Returns true if the key is in the map. O(1).
149      */
150     function _contains(Map storage map, bytes32 key) private view returns (bool) {
151         return map._indexes[key] != 0;
152     }
153 
154     /**
155      * @dev Returns the number of key-value pairs in the map. O(1).
156      */
157     function _length(Map storage map) private view returns (uint256) {
158         return map._entries.length;
159     }
160 
161    /**
162     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
163     *
164     * Note that there are no guarantees on the ordering of entries inside the
165     * array, and it may change when more entries are added or removed.
166     *
167     * Requirements:
168     *
169     * - `index` must be strictly less than {length}.
170     */
171     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
172         require(map._entries.length > index, "EnumerableMap: index out of bounds");
173 
174         MapEntry storage entry = map._entries[index];
175         return (entry._key, entry._value);
176     }
177 
178     /**
179      * @dev Returns the value associated with `key`.  O(1).
180      *
181      * Requirements:
182      *
183      * - `key` must be in the map.
184      */
185     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
186         return _get(map, key, "EnumerableMap: nonexistent key");
187     }
188 
189     /**
190      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
191      */
192     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
193         uint256 keyIndex = map._indexes[key];
194         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
195         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
196     }
197 
198     // UintToAddressMap
199 
200     struct UintToAddressMap {
201         Map _inner;
202     }
203 
204     /**
205      * @dev Adds a key-value pair to a map, or updates the value for an existing
206      * key. O(1).
207      *
208      * Returns true if the key was added to the map, that is if it was not
209      * already present.
210      */
211     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
212         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
213     }
214 
215     /**
216      * @dev Removes a value from a set. O(1).
217      *
218      * Returns true if the key was removed from the map, that is if it was present.
219      */
220     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
221         return _remove(map._inner, bytes32(key));
222     }
223 
224     /**
225      * @dev Returns true if the key is in the map. O(1).
226      */
227     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
228         return _contains(map._inner, bytes32(key));
229     }
230 
231     /**
232      * @dev Returns the number of elements in the map. O(1).
233      */
234     function length(UintToAddressMap storage map) internal view returns (uint256) {
235         return _length(map._inner);
236     }
237 
238    /**
239     * @dev Returns the element stored at position `index` in the set. O(1).
240     * Note that there are no guarantees on the ordering of values inside the
241     * array, and it may change when more values are added or removed.
242     *
243     * Requirements:
244     *
245     * - `index` must be strictly less than {length}.
246     */
247     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
248         (bytes32 key, bytes32 value) = _at(map._inner, index);
249         return (uint256(key), address(uint256(value)));
250     }
251 
252     /**
253      * @dev Returns the value associated with `key`.  O(1).
254      *
255      * Requirements:
256      *
257      * - `key` must be in the map.
258      */
259     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
260         return address(uint256(_get(map._inner, bytes32(key))));
261     }
262 
263     /**
264      * @dev Same as {get}, with a custom error message when `key` is not in the map.
265      */
266     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
267         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
268     }
269 }
270 
271 
272 
273 
274 /**
275  * @dev Library for managing
276  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
277  * types.
278  *
279  * Sets have the following properties:
280  *
281  * - Elements are added, removed, and checked for existence in constant time
282  * (O(1)).
283  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
284  *
285  * ```
286  * contract Example {
287  *     // Add the library methods
288  *     using EnumerableSet for EnumerableSet.AddressSet;
289  *
290  *     // Declare a set state variable
291  *     EnumerableSet.AddressSet private mySet;
292  * }
293  * ```
294  *
295  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
296  * (`UintSet`) are supported.
297  */
298 library EnumerableSet {
299     // To implement this library for multiple types with as little code
300     // repetition as possible, we write it in terms of a generic Set type with
301     // bytes32 values.
302     // The Set implementation uses private functions, and user-facing
303     // implementations (such as AddressSet) are just wrappers around the
304     // underlying Set.
305     // This means that we can only create new EnumerableSets for types that fit
306     // in bytes32.
307 
308     struct Set {
309         // Storage of set values
310         bytes32[] _values;
311 
312         // Position of the value in the `values` array, plus 1 because index 0
313         // means a value is not in the set.
314         mapping (bytes32 => uint256) _indexes;
315     }
316 
317     /**
318      * @dev Add a value to a set. O(1).
319      *
320      * Returns true if the value was added to the set, that is if it was not
321      * already present.
322      */
323     function _add(Set storage set, bytes32 value) private returns (bool) {
324         if (!_contains(set, value)) {
325             set._values.push(value);
326             // The value is stored at length-1, but we add 1 to all indexes
327             // and use 0 as a sentinel value
328             set._indexes[value] = set._values.length;
329             return true;
330         } else {
331             return false;
332         }
333     }
334 
335     /**
336      * @dev Removes a value from a set. O(1).
337      *
338      * Returns true if the value was removed from the set, that is if it was
339      * present.
340      */
341     function _remove(Set storage set, bytes32 value) private returns (bool) {
342         // We read and store the value's index to prevent multiple reads from the same storage slot
343         uint256 valueIndex = set._indexes[value];
344 
345         if (valueIndex != 0) { // Equivalent to contains(set, value)
346             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
347             // the array, and then remove the last element (sometimes called as 'swap and pop').
348             // This modifies the order of the array, as noted in {at}.
349 
350             uint256 toDeleteIndex = valueIndex - 1;
351             uint256 lastIndex = set._values.length - 1;
352 
353             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
354             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
355 
356             bytes32 lastvalue = set._values[lastIndex];
357 
358             // Move the last value to the index where the value to delete is
359             set._values[toDeleteIndex] = lastvalue;
360             // Update the index for the moved value
361             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
362 
363             // Delete the slot where the moved value was stored
364             set._values.pop();
365 
366             // Delete the index for the deleted slot
367             delete set._indexes[value];
368 
369             return true;
370         } else {
371             return false;
372         }
373     }
374 
375     /**
376      * @dev Returns true if the value is in the set. O(1).
377      */
378     function _contains(Set storage set, bytes32 value) private view returns (bool) {
379         return set._indexes[value] != 0;
380     }
381 
382     /**
383      * @dev Returns the number of values on the set. O(1).
384      */
385     function _length(Set storage set) private view returns (uint256) {
386         return set._values.length;
387     }
388 
389    /**
390     * @dev Returns the value stored at position `index` in the set. O(1).
391     *
392     * Note that there are no guarantees on the ordering of values inside the
393     * array, and it may change when more values are added or removed.
394     *
395     * Requirements:
396     *
397     * - `index` must be strictly less than {length}.
398     */
399     function _at(Set storage set, uint256 index) private view returns (bytes32) {
400         require(set._values.length > index, "EnumerableSet: index out of bounds");
401         return set._values[index];
402     }
403 
404     // AddressSet
405 
406     struct AddressSet {
407         Set _inner;
408     }
409 
410     /**
411      * @dev Add a value to a set. O(1).
412      *
413      * Returns true if the value was added to the set, that is if it was not
414      * already present.
415      */
416     function add(AddressSet storage set, address value) internal returns (bool) {
417         return _add(set._inner, bytes32(uint256(value)));
418     }
419 
420     /**
421      * @dev Removes a value from a set. O(1).
422      *
423      * Returns true if the value was removed from the set, that is if it was
424      * present.
425      */
426     function remove(AddressSet storage set, address value) internal returns (bool) {
427         return _remove(set._inner, bytes32(uint256(value)));
428     }
429 
430     /**
431      * @dev Returns true if the value is in the set. O(1).
432      */
433     function contains(AddressSet storage set, address value) internal view returns (bool) {
434         return _contains(set._inner, bytes32(uint256(value)));
435     }
436 
437     /**
438      * @dev Returns the number of values in the set. O(1).
439      */
440     function length(AddressSet storage set) internal view returns (uint256) {
441         return _length(set._inner);
442     }
443 
444    /**
445     * @dev Returns the value stored at position `index` in the set. O(1).
446     *
447     * Note that there are no guarantees on the ordering of values inside the
448     * array, and it may change when more values are added or removed.
449     *
450     * Requirements:
451     *
452     * - `index` must be strictly less than {length}.
453     */
454     function at(AddressSet storage set, uint256 index) internal view returns (address) {
455         return address(uint256(_at(set._inner, index)));
456     }
457 
458 
459     // UintSet
460 
461     struct UintSet {
462         Set _inner;
463     }
464 
465     /**
466      * @dev Add a value to a set. O(1).
467      *
468      * Returns true if the value was added to the set, that is if it was not
469      * already present.
470      */
471     function add(UintSet storage set, uint256 value) internal returns (bool) {
472         return _add(set._inner, bytes32(value));
473     }
474 
475     /**
476      * @dev Removes a value from a set. O(1).
477      *
478      * Returns true if the value was removed from the set, that is if it was
479      * present.
480      */
481     function remove(UintSet storage set, uint256 value) internal returns (bool) {
482         return _remove(set._inner, bytes32(value));
483     }
484 
485     /**
486      * @dev Returns true if the value is in the set. O(1).
487      */
488     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
489         return _contains(set._inner, bytes32(value));
490     }
491 
492     /**
493      * @dev Returns the number of values on the set. O(1).
494      */
495     function length(UintSet storage set) internal view returns (uint256) {
496         return _length(set._inner);
497     }
498 
499    /**
500     * @dev Returns the value stored at position `index` in the set. O(1).
501     *
502     * Note that there are no guarantees on the ordering of values inside the
503     * array, and it may change when more values are added or removed.
504     *
505     * Requirements:
506     *
507     * - `index` must be strictly less than {length}.
508     */
509     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
510         return uint256(_at(set._inner, index));
511     }
512 }
513 
514 
515 
516 
517 /**
518  * @dev Collection of functions related to the address type
519  */
520 library Address {
521     /**
522      * @dev Returns true if `account` is a contract.
523      *
524      * [IMPORTANT]
525      * ====
526      * It is unsafe to assume that an address for which this function returns
527      * false is an externally-owned account (EOA) and not a contract.
528      *
529      * Among others, `isContract` will return false for the following
530      * types of addresses:
531      *
532      *  - an externally-owned account
533      *  - a contract in construction
534      *  - an address where a contract will be created
535      *  - an address where a contract lived, but was destroyed
536      * ====
537      */
538     function isContract(address account) internal view returns (bool) {
539         // This method relies on extcodesize, which returns 0 for contracts in
540         // construction, since the code is only stored at the end of the
541         // constructor execution.
542 
543         uint256 size;
544         // solhint-disable-next-line no-inline-assembly
545         assembly { size := extcodesize(account) }
546         return size > 0;
547     }
548 
549     /**
550      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
551      * `recipient`, forwarding all available gas and reverting on errors.
552      *
553      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
554      * of certain opcodes, possibly making contracts go over the 2300 gas limit
555      * imposed by `transfer`, making them unable to receive funds via
556      * `transfer`. {sendValue} removes this limitation.
557      *
558      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
559      *
560      * IMPORTANT: because control is transferred to `recipient`, care must be
561      * taken to not create reentrancy vulnerabilities. Consider using
562      * {ReentrancyGuard} or the
563      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
564      */
565     function sendValue(address payable recipient, uint256 amount) internal {
566         require(address(this).balance >= amount, "Address: insufficient balance");
567 
568         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
569         (bool success, ) = recipient.call{ value: amount }("");
570         require(success, "Address: unable to send value, recipient may have reverted");
571     }
572 
573     /**
574      * @dev Performs a Solidity function call using a low level `call`. A
575      * plain`call` is an unsafe replacement for a function call: use this
576      * function instead.
577      *
578      * If `target` reverts with a revert reason, it is bubbled up by this
579      * function (like regular Solidity function calls).
580      *
581      * Returns the raw returned data. To convert to the expected return value,
582      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
583      *
584      * Requirements:
585      *
586      * - `target` must be a contract.
587      * - calling `target` with `data` must not revert.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
592       return functionCall(target, data, "Address: low-level call failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
597      * `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
602         return functionCallWithValue(target, data, 0, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but also transferring `value` wei to `target`.
608      *
609      * Requirements:
610      *
611      * - the calling contract must have an ETH balance of at least `value`.
612      * - the called Solidity function must be `payable`.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
617         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
622      * with `errorMessage` as a fallback revert reason when `target` reverts.
623      *
624      * _Available since v3.1._
625      */
626     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
627         require(address(this).balance >= value, "Address: insufficient balance for call");
628         require(isContract(target), "Address: call to non-contract");
629 
630         // solhint-disable-next-line avoid-low-level-calls
631         (bool success, bytes memory returndata) = target.call{ value: value }(data);
632         return _verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a static call.
638      *
639      * _Available since v3.3._
640      */
641     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
642         return functionStaticCall(target, data, "Address: low-level static call failed");
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
647      * but performing a static call.
648      *
649      * _Available since v3.3._
650      */
651     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
652         require(isContract(target), "Address: static call to non-contract");
653 
654         // solhint-disable-next-line avoid-low-level-calls
655         (bool success, bytes memory returndata) = target.staticcall(data);
656         return _verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
661      * but performing a delegate call.
662      *
663      * _Available since v3.3._
664      */
665     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
666         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
671      * but performing a delegate call.
672      *
673      * _Available since v3.3._
674      */
675     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
676         require(isContract(target), "Address: delegate call to non-contract");
677 
678         // solhint-disable-next-line avoid-low-level-calls
679         (bool success, bytes memory returndata) = target.delegatecall(data);
680         return _verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
684         if (success) {
685             return returndata;
686         } else {
687             // Look for revert reason and bubble it up if present
688             if (returndata.length > 0) {
689                 // The easiest way to bubble the revert reason is using memory via assembly
690 
691                 // solhint-disable-next-line no-inline-assembly
692                 assembly {
693                     let returndata_size := mload(returndata)
694                     revert(add(32, returndata), returndata_size)
695                 }
696             } else {
697                 revert(errorMessage);
698             }
699         }
700     }
701 }
702 
703 
704 
705 
706 /**
707  * @dev Wrappers over Solidity's arithmetic operations with added overflow
708  * checks.
709  *
710  * Arithmetic operations in Solidity wrap on overflow. This can easily result
711  * in bugs, because programmers usually assume that an overflow raises an
712  * error, which is the standard behavior in high level programming languages.
713  * `SafeMath` restores this intuition by reverting the transaction when an
714  * operation overflows.
715  *
716  * Using this library instead of the unchecked operations eliminates an entire
717  * class of bugs, so it's recommended to use it always.
718  */
719 library SafeMath {
720     /**
721      * @dev Returns the addition of two unsigned integers, reverting on
722      * overflow.
723      *
724      * Counterpart to Solidity's `+` operator.
725      *
726      * Requirements:
727      *
728      * - Addition cannot overflow.
729      */
730     function add(uint256 a, uint256 b) internal pure returns (uint256) {
731         uint256 c = a + b;
732         require(c >= a, "SafeMath: addition overflow");
733 
734         return c;
735     }
736 
737     /**
738      * @dev Returns the subtraction of two unsigned integers, reverting on
739      * overflow (when the result is negative).
740      *
741      * Counterpart to Solidity's `-` operator.
742      *
743      * Requirements:
744      *
745      * - Subtraction cannot overflow.
746      */
747     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
748         return sub(a, b, "SafeMath: subtraction overflow");
749     }
750 
751     /**
752      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
753      * overflow (when the result is negative).
754      *
755      * Counterpart to Solidity's `-` operator.
756      *
757      * Requirements:
758      *
759      * - Subtraction cannot overflow.
760      */
761     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
762         require(b <= a, errorMessage);
763         uint256 c = a - b;
764 
765         return c;
766     }
767 
768     /**
769      * @dev Returns the multiplication of two unsigned integers, reverting on
770      * overflow.
771      *
772      * Counterpart to Solidity's `*` operator.
773      *
774      * Requirements:
775      *
776      * - Multiplication cannot overflow.
777      */
778     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
779         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
780         // benefit is lost if 'b' is also tested.
781         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
782         if (a == 0) {
783             return 0;
784         }
785 
786         uint256 c = a * b;
787         require(c / a == b, "SafeMath: multiplication overflow");
788 
789         return c;
790     }
791 
792     /**
793      * @dev Returns the integer division of two unsigned integers. Reverts on
794      * division by zero. The result is rounded towards zero.
795      *
796      * Counterpart to Solidity's `/` operator. Note: this function uses a
797      * `revert` opcode (which leaves remaining gas untouched) while Solidity
798      * uses an invalid opcode to revert (consuming all remaining gas).
799      *
800      * Requirements:
801      *
802      * - The divisor cannot be zero.
803      */
804     function div(uint256 a, uint256 b) internal pure returns (uint256) {
805         return div(a, b, "SafeMath: division by zero");
806     }
807 
808     /**
809      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
810      * division by zero. The result is rounded towards zero.
811      *
812      * Counterpart to Solidity's `/` operator. Note: this function uses a
813      * `revert` opcode (which leaves remaining gas untouched) while Solidity
814      * uses an invalid opcode to revert (consuming all remaining gas).
815      *
816      * Requirements:
817      *
818      * - The divisor cannot be zero.
819      */
820     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
821         require(b > 0, errorMessage);
822         uint256 c = a / b;
823         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
824 
825         return c;
826     }
827 
828     /**
829      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
830      * Reverts when dividing by zero.
831      *
832      * Counterpart to Solidity's `%` operator. This function uses a `revert`
833      * opcode (which leaves remaining gas untouched) while Solidity uses an
834      * invalid opcode to revert (consuming all remaining gas).
835      *
836      * Requirements:
837      *
838      * - The divisor cannot be zero.
839      */
840     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
841         return mod(a, b, "SafeMath: modulo by zero");
842     }
843 
844     /**
845      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
846      * Reverts with custom message when dividing by zero.
847      *
848      * Counterpart to Solidity's `%` operator. This function uses a `revert`
849      * opcode (which leaves remaining gas untouched) while Solidity uses an
850      * invalid opcode to revert (consuming all remaining gas).
851      *
852      * Requirements:
853      *
854      * - The divisor cannot be zero.
855      */
856     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
857         require(b != 0, errorMessage);
858         return a % b;
859     }
860 }
861 
862 
863 
864 
865 /**
866  * @title ERC721 token receiver interface
867  * @dev Interface for any contract that wants to support safeTransfers
868  * from ERC721 asset contracts.
869  */
870 interface IERC721Receiver {
871     /**
872      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
873      * by `operator` from `from`, this function is called.
874      *
875      * It must return its Solidity selector to confirm the token transfer.
876      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
877      *
878      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
879      */
880     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
881 }
882 
883 
884 
885 
886 /*
887  * @dev Provides information about the current execution context, including the
888  * sender of the transaction and its data. While these are generally available
889  * via msg.sender and msg.data, they should not be accessed in such a direct
890  * manner, since when dealing with GSN meta-transactions the account sending and
891  * paying for execution may not be the actual sender (as far as an application
892  * is concerned).
893  *
894  * This contract is only required for intermediate, library-like contracts.
895  */
896 abstract contract Context {
897     function _msgSender() internal view virtual returns (address payable) {
898         return msg.sender;
899     }
900 
901     function _msgData() internal view virtual returns (bytes memory) {
902         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
903         return msg.data;
904     }
905 }
906 
907 /**
908  * @dev Interface of the ERC165 standard, as defined in the
909  * https://eips.ethereum.org/EIPS/eip-165[EIP].
910  *
911  * Implementers can declare support of contract interfaces, which can then be
912  * queried by others ({ERC165Checker}).
913  *
914  * For an implementation, see {ERC165}.
915  */
916 interface IERC165 {
917     /**
918      * @dev Returns true if this contract implements the interface defined by
919      * `interfaceId`. See the corresponding
920      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
921      * to learn more about how these ids are created.
922      *
923      * This function call must use less than 30 000 gas.
924      */
925     function supportsInterface(bytes4 interfaceId) external view returns (bool);
926 }
927 
928 /**
929  * @dev Contract module which provides a basic access control mechanism, where
930  * there is an account (an owner) that can be granted exclusive access to
931  * specific functions.
932  *
933  * By default, the owner account will be the one that deploys the contract. This
934  * can later be changed with {transferOwnership}.
935  *
936  * This module is used through inheritance. It will make available the modifier
937  * `onlyOwner`, which can be applied to your functions to restrict their use to
938  * the owner.
939  */
940 contract Ownable is Context {
941     address private _owner;
942 
943     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
944 
945     /**
946      * @dev Initializes the contract setting the deployer as the initial owner.
947      */
948     constructor () internal {
949         address msgSender = _msgSender();
950         _owner = msgSender;
951         emit OwnershipTransferred(address(0), msgSender);
952     }
953 
954     /**
955      * @dev Returns the address of the current owner.
956      */
957     function owner() public view returns (address) {
958         return _owner;
959     }
960 
961     /**
962      * @dev Throws if called by any account other than the owner.
963      */
964     modifier onlyOwner() {
965         require(_owner == _msgSender(), "Ownable: caller is not the owner");
966         _;
967     }
968 
969     /**
970      * @dev Leaves the contract without owner. It will not be possible to call
971      * `onlyOwner` functions anymore. Can only be called by the current owner.
972      *
973      * NOTE: Renouncing ownership will leave the contract without an owner,
974      * thereby removing any functionality that is only available to the owner.
975      */
976     function renounceOwnership() public virtual onlyOwner {
977         emit OwnershipTransferred(_owner, address(0));
978         _owner = address(0);
979     }
980 
981     /**
982      * @dev Transfers ownership of the contract to a new account (`newOwner`).
983      * Can only be called by the current owner.
984      */
985     function transferOwnership(address newOwner) public virtual onlyOwner {
986         require(newOwner != address(0), "Ownable: new owner is the zero address");
987         emit OwnershipTransferred(_owner, newOwner);
988         _owner = newOwner;
989     }
990 }
991 
992 /**
993  * @dev Required interface of an ERC721 compliant contract.
994  */
995 interface IERC721 is IERC165 {
996     /**
997      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
998      */
999     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1000 
1001     /**
1002      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1003      */
1004     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1005 
1006     /**
1007      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1008      */
1009     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1010 
1011     /**
1012      * @dev Returns the number of tokens in ``owner``'s account.
1013      */
1014     function balanceOf(address owner) external view returns (uint256 balance);
1015 
1016     /**
1017      * @dev Returns the owner of the `tokenId` token.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function ownerOf(uint256 tokenId) external view returns (address owner);
1024 
1025     /**
1026      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1027      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1028      *
1029      * Requirements:
1030      *
1031      * - `from` cannot be the zero address.
1032      * - `to` cannot be the zero address.
1033      * - `tokenId` token must exist and be owned by `from`.
1034      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1035      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1040 
1041     /**
1042      * @dev Transfers `tokenId` token from `from` to `to`.
1043      *
1044      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1045      *
1046      * Requirements:
1047      *
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must be owned by `from`.
1051      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function transferFrom(address from, address to, uint256 tokenId) external;
1056 
1057     /**
1058      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1059      * The approval is cleared when the token is transferred.
1060      *
1061      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1062      *
1063      * Requirements:
1064      *
1065      * - The caller must own the token or be an approved operator.
1066      * - `tokenId` must exist.
1067      *
1068      * Emits an {Approval} event.
1069      */
1070     function approve(address to, uint256 tokenId) external;
1071 
1072     /**
1073      * @dev Returns the account approved for `tokenId` token.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      */
1079     function getApproved(uint256 tokenId) external view returns (address operator);
1080 
1081     /**
1082      * @dev Approve or remove `operator` as an operator for the caller.
1083      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1084      *
1085      * Requirements:
1086      *
1087      * - The `operator` cannot be the caller.
1088      *
1089      * Emits an {ApprovalForAll} event.
1090      */
1091     function setApprovalForAll(address operator, bool _approved) external;
1092 
1093     /**
1094      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1095      *
1096      * See {setApprovalForAll}
1097      */
1098     function isApprovedForAll(address owner, address operator) external view returns (bool);
1099 
1100     /**
1101       * @dev Safely transfers `tokenId` token from `from` to `to`.
1102       *
1103       * Requirements:
1104       *
1105      * - `from` cannot be the zero address.
1106      * - `to` cannot be the zero address.
1107       * - `tokenId` token must exist and be owned by `from`.
1108       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1109       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1110       *
1111       * Emits a {Transfer} event.
1112       */
1113     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1114 }
1115 
1116 /**
1117  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1118  * @dev See https://eips.ethereum.org/EIPS/eip-721
1119  */
1120 interface IERC721Metadata is IERC721 {
1121 
1122     /**
1123      * @dev Returns the token collection name.
1124      */
1125     function name() external view returns (string memory);
1126 
1127     /**
1128      * @dev Returns the token collection symbol.
1129      */
1130     function symbol() external view returns (string memory);
1131 
1132     /**
1133      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1134      */
1135     function tokenURI(uint256 tokenId) external view returns (string memory);
1136 }
1137 
1138 /**
1139  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1140  * @dev See https://eips.ethereum.org/EIPS/eip-721
1141  */
1142 interface IERC721Enumerable is IERC721 {
1143 
1144     /**
1145      * @dev Returns the total amount of tokens stored by the contract.
1146      */
1147     function totalSupply() external view returns (uint256);
1148 
1149     /**
1150      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1151      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1152      */
1153     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1154 
1155     /**
1156      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1157      * Use along with {totalSupply} to enumerate all tokens.
1158      */
1159     function tokenByIndex(uint256 index) external view returns (uint256);
1160 }
1161 
1162 /**
1163  * @dev Implementation of the {IERC165} interface.
1164  *
1165  * Contracts may inherit from this and call {_registerInterface} to declare
1166  * their support of an interface.
1167  */
1168 contract ERC165 is IERC165 {
1169     /*
1170      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1171      */
1172     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1173 
1174     /**
1175      * @dev Mapping of interface ids to whether or not it's supported.
1176      */
1177     mapping(bytes4 => bool) private _supportedInterfaces;
1178 
1179     constructor () internal {
1180         // Derived contracts need only register support for their own interfaces,
1181         // we register support for ERC165 itself here
1182         _registerInterface(_INTERFACE_ID_ERC165);
1183     }
1184 
1185     /**
1186      * @dev See {IERC165-supportsInterface}.
1187      *
1188      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1189      */
1190     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1191         return _supportedInterfaces[interfaceId];
1192     }
1193 
1194     /**
1195      * @dev Registers the contract as an implementer of the interface defined by
1196      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1197      * registering its interface id is not required.
1198      *
1199      * See {IERC165-supportsInterface}.
1200      *
1201      * Requirements:
1202      *
1203      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1204      */
1205     function _registerInterface(bytes4 interfaceId) internal virtual {
1206         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1207         _supportedInterfaces[interfaceId] = true;
1208     }
1209 }
1210 
1211 
1212 /**
1213  * @dev Interface of the ERC20 standard as defined in the EIP.
1214  */
1215 interface IERC20 {
1216     /**
1217      * @dev Returns the amount of tokens in existence.
1218      */
1219     function totalSupply() external view returns (uint256);
1220 
1221     /**
1222      * @dev Returns the amount of tokens owned by `account`.
1223      */
1224     function balanceOf(address account) external view returns (uint256);
1225 
1226     /**
1227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1228      *
1229      * Returns a boolean value indicating whether the operation succeeded.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function transfer(address recipient, uint256 amount) external returns (bool);
1234 
1235     /**
1236      * @dev Returns the remaining number of tokens that `spender` will be
1237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1238      * zero by default.
1239      *
1240      * This value changes when {approve} or {transferFrom} are called.
1241      */
1242     function allowance(address owner, address spender) external view returns (uint256);
1243 
1244     /**
1245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1246      *
1247      * Returns a boolean value indicating whether the operation succeeded.
1248      *
1249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1250      * that someone may use both the old and the new allowance by unfortunate
1251      * transaction ordering. One possible solution to mitigate this race
1252      * condition is to first reduce the spender's allowance to 0 and set the
1253      * desired value afterwards:
1254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1255      *
1256      * Emits an {Approval} event.
1257      */
1258     function approve(address spender, uint256 amount) external returns (bool);
1259 
1260     /**
1261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1262      * allowance mechanism. `amount` is then deducted from the caller's
1263      * allowance.
1264      *
1265      * Returns a boolean value indicating whether the operation succeeded.
1266      *
1267      * Emits a {Transfer} event.
1268      */
1269     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1270 
1271     /**
1272      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1273      * another (`to`).
1274      *
1275      * Note that `value` may be zero.
1276      */
1277     event Transfer(address indexed from, address indexed to, uint256 value);
1278 
1279     /**
1280      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1281      * a call to {approve}. `value` is the new allowance.
1282      */
1283     event Approval(address indexed owner, address indexed spender, uint256 value);
1284 }
1285 
1286 
1287 /**
1288  * @dev Contract module that can be used to recover ERC20 compatible tokens stuck in the contract.
1289  */
1290 contract ERC20Recoverable is Ownable {
1291     /**
1292      * @dev Used to transfer tokens stuck on this contract to another address.
1293      */
1294     function recoverERC20(address token, address recipient, uint256 amount) external onlyOwner returns (bool) {
1295         return IERC20(token).transfer(recipient, amount);
1296     }
1297 
1298     /**
1299      * @dev Used to approve recovery of stuck tokens. May also be used to approve token transfers in advance.
1300      */
1301      function recoverERC20Approve(address token, address spender, uint256 amount) external onlyOwner returns (bool) {
1302         return IERC20(token).approve(spender, amount);
1303     }
1304 }
1305 
1306 /**
1307  * @dev Contract module that can be used to recover ERC20 compatible tokens stuck in the contract.
1308  */
1309 contract ERC721Recoverable is Ownable {
1310     /**
1311      * @dev Used to recover a stuck token.
1312      */
1313     function recoverERC721(address token, address recipient, uint256 tokenId) external onlyOwner {
1314         return IERC721(token).transferFrom(address(this), recipient, tokenId);
1315     }
1316 
1317     /**
1318      * @dev Used to recover a stuck token using the safe transfer function of ERC721.
1319      */
1320     function recoverERC721Safe(address token, address recipient, uint256 tokenId) external onlyOwner {
1321         return IERC721(token).safeTransferFrom(address(this), recipient, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Used to approve the recovery of a stuck token.
1326      */
1327     function recoverERC721Approve(address token, address recipient, uint256 tokenId) external onlyOwner {
1328         return IERC721(token).approve(recipient, tokenId);
1329     }
1330 
1331     /**
1332      * @dev Used to approve the recovery of stuck token, also in future.
1333      */
1334     function recoverERC721ApproveAll(address token, address recipient, bool approved) external onlyOwner {
1335         return IERC721(token).setApprovalForAll(recipient, approved);
1336     }
1337 }
1338 
1339 /**
1340  * @dev Most credited to OpenZeppelin ERC721.sol, but with some adjustments.
1341  */
1342 contract T2 is Context, Ownable, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, ERC20Recoverable, ERC721Recoverable {
1343     using SafeMath for uint256;
1344     using Address for address;
1345     using EnumerableSet for EnumerableSet.UintSet;
1346     using EnumerableMap for EnumerableMap.UintToAddressMap;
1347     using Strings for uint256;
1348 
1349     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1350     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1351     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1352 
1353     // Mapping from holder address to their (enumerable) set of owned tokens
1354     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1355 
1356     // Enumerable mapping from token ids to their owners
1357     EnumerableMap.UintToAddressMap private _tokenOwners;
1358 
1359     // Mapping from token ID to approved address
1360     mapping (uint256 => address) private _tokenApprovals;
1361 
1362     // Mapping from owner to operator approvals
1363     mapping (address => mapping (address => bool)) private _operatorApprovals;
1364 
1365     // Token name
1366     string private _name;
1367 
1368     // Token symbol
1369     string private _symbol;
1370 
1371     // Base URI
1372     string private _baseURI;
1373 
1374     // Specified if tokens are transferable. Can be flipped by the owner.
1375     bool private _transferable;
1376 
1377     // Price per token. Is chosen and can be changed by contract owner.
1378     uint256 private _tokenPrice;
1379 
1380     // Counter for token id
1381     uint256 private _nextId = 1;
1382 
1383     /*
1384      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1385      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1386      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1387      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1388      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1389      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1390      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1391      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1392      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1393      *
1394      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1395      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1396      */
1397     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1398 
1399     /*
1400      *     bytes4(keccak256('name()')) == 0x06fdde03
1401      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1402      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1403      *
1404      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1405      */
1406     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1407 
1408     /*
1409      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1410      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1411      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1412      *
1413      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1414      */
1415     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1416 
1417     /**
1418      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1419      */
1420     constructor (string memory name, string memory symbol, string memory baseURI, bool transferable, uint256 tokenPrice) public {
1421         _name = name;
1422         _symbol = symbol;
1423         _baseURI = baseURI;
1424         _transferable = transferable;
1425         _tokenPrice = tokenPrice;
1426 
1427         // register the supported interfaces to conform to ERC721 via ERC165
1428         _registerInterface(_INTERFACE_ID_ERC721);
1429         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1430         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1431     }
1432 
1433 // public functions:
1434     /**
1435      * @dev See {IERC721-balanceOf}.
1436      */
1437     function balanceOf(address owner) external view override returns (uint256) {
1438         require(owner != address(0), "ERC721: balance query for the zero address");
1439 
1440         return _holderTokens[owner].length();
1441     }
1442 
1443     /**
1444      * @dev See {IERC721-ownerOf}.
1445      */
1446     function ownerOf(uint256 tokenId) public view override returns (address) {
1447         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Metadata-name}.
1452      */
1453     function name() external view override returns (string memory) {
1454         return _name;
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Metadata-symbol}.
1459      */
1460     function symbol() external view override returns (string memory) {
1461         return _symbol;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Metadata-tokenURI}.
1466      */
1467     function tokenURI(uint256 tokenId) external view override returns (string memory) {
1468         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1469 
1470         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1471         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1472     }
1473 
1474     /**
1475     * @dev Returns the base URI set via {_setBaseURI}. This will be
1476     * automatically added as a prefix in {tokenURI} to each token's URI, or
1477     * to the token ID if no specific URI is set for that token ID.
1478     */
1479     function baseURI() external view returns (string memory) {
1480         return _baseURI;
1481     }
1482 
1483     /**
1484      * @dev Returns if tokens are globally transferable currently. That may be decided by the contract owner.
1485      */
1486     function transferable() external view returns (bool) {
1487         return _transferable;
1488     }
1489 
1490     /**
1491      * @dev Price per token for public purchase.
1492      */
1493     function tokenPrice() external view returns (uint256) {
1494         return _tokenPrice;
1495     }
1496 
1497     /**
1498      * @dev Next token id.
1499      */
1500     function nextTokenId() public view returns (uint256) {
1501         return _nextId;
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1506      */
1507     function tokenOfOwnerByIndex(address owner, uint256 index) external view override returns (uint256) {
1508         return _holderTokens[owner].at(index);
1509     }
1510 
1511     /**
1512      * @dev See {IERC721Enumerable-totalSupply}.
1513      */
1514     function totalSupply() external view override returns (uint256) {
1515         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1516         return _tokenOwners.length();
1517     }
1518 
1519     /**
1520      * @dev See {IERC721Enumerable-tokenByIndex}.
1521      */
1522     function tokenByIndex(uint256 index) external view override returns (uint256) {
1523         (uint256 tokenId, ) = _tokenOwners.at(index);
1524         return tokenId;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721-approve}.
1529      */
1530     function approve(address to, uint256 tokenId) external virtual override {
1531         address owner = ownerOf(tokenId);
1532         require(to != owner, "ERC721: approval to current owner");
1533 
1534         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1535             "ERC721: approve caller is not owner nor approved for all"
1536         );
1537 
1538         _approve(to, tokenId);
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-getApproved}.
1543      */
1544     function getApproved(uint256 tokenId) public view override returns (address) {
1545         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1546 
1547         return _tokenApprovals[tokenId];
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-setApprovalForAll}.
1552      */
1553     function setApprovalForAll(address operator, bool approved) external virtual override {
1554         require(operator != _msgSender(), "ERC721: approve to caller");
1555 
1556         _operatorApprovals[_msgSender()][operator] = approved;
1557         emit ApprovalForAll(_msgSender(), operator, approved);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-isApprovedForAll}.
1562      */
1563     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1564         return _operatorApprovals[owner][operator];
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-transferFrom}.
1569      */
1570     function transferFrom(address from, address to, uint256 tokenId) external virtual override {
1571         //solhint-disable-next-line max-line-length
1572         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1573 
1574         _transfer(from, to, tokenId);
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-safeTransferFrom}.
1579      */
1580     function safeTransferFrom(address from, address to, uint256 tokenId) external virtual override {
1581         safeTransferFrom(from, to, tokenId, "");
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-safeTransferFrom}.
1586      */
1587     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1588         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1589         _safeTransfer(from, to, tokenId, _data);
1590     }
1591 
1592     function buyToken() external payable returns (bool)
1593     {
1594         uint256 paidAmount = msg.value;
1595         require(paidAmount == _tokenPrice, "Invalid amount for token purchase");
1596         _mint(msg.sender, nextTokenId());
1597         _incrementTokenId();
1598         payable(owner()).transfer(paidAmount);
1599         return true;
1600     }
1601 
1602     /**
1603      * @dev Burns `tokenId`. See {ERC721-_burn}.
1604      *
1605      * Requirements:
1606      *
1607      * - The caller must own `tokenId` or be an approved operator.
1608      */
1609     function burn(uint256 tokenId) public returns (bool) {
1610         //solhint-disable-next-line max-line-length
1611         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1612         _burn(tokenId);
1613         return true;
1614     }
1615 
1616     function burnAnyFrom(address burner) public returns (bool) {
1617         require(_holderTokens[burner].length() > 0, "Address does not have any tokens to burn");
1618         return burn(_holderTokens[burner].at(0));
1619     }
1620 
1621     function burnAny() external returns (bool) {
1622         return burnAnyFrom(msg.sender);
1623     }
1624 
1625 // owner functions:
1626     /**
1627      * @dev Function to set the base URI for all token IDs. It is automatically added as a prefix to the token id in {tokenURI} to retrieve the token URI.
1628      */
1629     function setBaseURI(string calldata baseURI_) external onlyOwner {
1630         _baseURI = baseURI_;
1631     }
1632 
1633     /**
1634      * @dev Function for the contract owner to allow or disallow token transfers.
1635      */
1636     function setTransferable(bool allowed) external onlyOwner {
1637         _transferable = allowed;
1638     }
1639 
1640     /**
1641      * @dev Sets a new token price.
1642      */
1643     function setTokenPrice(uint256 newPrice) external onlyOwner {
1644         _tokenPrice = newPrice;
1645     }
1646 
1647 // internal functions:
1648     /**
1649      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1650      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1651      *
1652      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1653      *
1654      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1655      * implement alternative mechanisms to perform token transfer, such as signature-based.
1656      *
1657      * Requirements:
1658      *
1659      * - `from` cannot be the zero address.
1660      * - `to` cannot be the zero address.
1661      * - `tokenId` token must exist and be owned by `from`.
1662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1663      *
1664      * Emits a {Transfer} event.
1665      */
1666     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) private {
1667         _transfer(from, to, tokenId);
1668         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1669     }
1670 
1671     /**
1672      * @dev Returns whether `tokenId` exists.
1673      *
1674      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1675      *
1676      * Tokens start existing when they are minted (`_mint`),
1677      * and stop existing when they are burned (`_burn`).
1678      */
1679     function _exists(uint256 tokenId) private view returns (bool) {
1680         return _tokenOwners.contains(tokenId);
1681     }
1682 
1683     /**
1684      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1685      *
1686      * Requirements:
1687      *
1688      * - `tokenId` must exist.
1689      */
1690     function _isApprovedOrOwner(address spender, uint256 tokenId) private view returns (bool) {
1691         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1692         address owner = ownerOf(tokenId);
1693         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1694     }
1695 
1696     /**
1697      * @dev Safely mints `tokenId` and transfers it to `to`.
1698      *
1699      * Requirements:
1700      d*
1701      * - `tokenId` must not exist.
1702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1703      *
1704      * Emits a {Transfer} event.
1705      */
1706     function _safeMint(address to, uint256 tokenId) private {
1707         _safeMint(to, tokenId, "");
1708     }
1709 
1710     /**
1711      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1712      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1713      */
1714     function _safeMint(address to, uint256 tokenId, bytes memory _data) private {
1715         _mint(to, tokenId);
1716         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1717     }
1718 
1719     /**
1720      * @dev Mints `tokenId` and transfers it to `to`.
1721      *
1722      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1723      *
1724      * Requirements:
1725      *
1726      * - `tokenId` must not exist.
1727      * - `to` cannot be the zero address.
1728      *
1729      * Emits a {Transfer} event.
1730      */
1731     function _mint(address to, uint256 tokenId) private {
1732         require(to != address(0), "ERC721: mint to the zero address");
1733         require(!_exists(tokenId), "ERC721: token already minted");
1734 
1735         _holderTokens[to].add(tokenId);
1736 
1737         _tokenOwners.set(tokenId, to);
1738 
1739         emit Transfer(address(0), to, tokenId);
1740     }
1741 
1742     /**
1743      * @dev Destroys `tokenId`.
1744      * The approval is cleared when the token is burned.
1745      *
1746      * Requirements:
1747      *
1748      * - `tokenId` must exist.
1749      *
1750      * Emits a {Transfer} event.
1751      */
1752     function _burn(uint256 tokenId) internal virtual {
1753         address owner = ownerOf(tokenId);
1754 
1755         // Clear approvals
1756         _approve(address(0), tokenId);
1757         _holderTokens[owner].remove(tokenId);
1758         _tokenOwners.remove(tokenId);
1759 
1760         emit Transfer(owner, address(0), tokenId);
1761     }
1762 
1763     /**
1764      * @dev Transfers `tokenId` from `from` to `to`.
1765      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1766      *
1767      * Requirements:
1768      *
1769      * - `to` cannot be the zero address.
1770      * - `tokenId` token must be owned by `from`.
1771      * - contract owner must have transfer globally allowed.
1772      *
1773      * Emits a {Transfer} event.
1774      */
1775     function _transfer(address from, address to, uint256 tokenId) private {
1776         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1777         require(to != address(0), "ERC721: transfer to the zero address");
1778         require(_transferable == true, "ERC721 transfer not permitted by contract owner");
1779 
1780         // Clear approvals from the previous owner
1781         _approve(address(0), tokenId);
1782 
1783         _holderTokens[from].remove(tokenId);
1784         _holderTokens[to].add(tokenId);
1785 
1786         _tokenOwners.set(tokenId, to);
1787 
1788         emit Transfer(from, to, tokenId);
1789     }
1790 
1791     /**
1792      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1793      * The call is not executed if the target address is not a contract.
1794      *
1795      * @param from address representing the previous owner of the given token ID
1796      * @param to target address that will receive the tokens
1797      * @param tokenId uint256 ID of the token to be transferred
1798      * @param _data bytes optional data to send along with the call
1799      * @return bool whether the call correctly returned the expected magic value
1800      */
1801     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool)
1802     {
1803         if (!to.isContract()) {
1804             return true;
1805         }
1806         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1807             IERC721Receiver(to).onERC721Received.selector,
1808             _msgSender(),
1809             from,
1810             tokenId,
1811             _data
1812         ), "ERC721: transfer to non ERC721Receiver implementer");
1813         bytes4 retval = abi.decode(returndata, (bytes4));
1814         return (retval == _ERC721_RECEIVED);
1815     }
1816 
1817     function _approve(address to, uint256 tokenId) private {
1818         _tokenApprovals[tokenId] = to;
1819         emit Approval(ownerOf(tokenId), to, tokenId);
1820     }
1821 
1822     function _incrementTokenId() private {
1823         _nextId = _nextId.add(1);
1824     }
1825 }
1826 
1827 
1828 /**
1829  * @dev Most credited to OpenZeppelin ERC721.sol, but with some adjustments.
1830  */
1831 contract NFTeGG_Series_1 is Context, Ownable, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, ERC20Recoverable, ERC721Recoverable {
1832     using SafeMath for uint256;
1833     using Address for address;
1834     using EnumerableSet for EnumerableSet.UintSet;
1835     using EnumerableMap for EnumerableMap.UintToAddressMap;
1836     using Strings for uint256;
1837 
1838     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1839     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1840     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1841 
1842     // Mapping from holder address to their (enumerable) set of owned tokens
1843     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1844 
1845     // Enumerable mapping from token ids to their owners
1846     EnumerableMap.UintToAddressMap private _tokenOwners;
1847 
1848     // Mapping from token ID to approved address
1849     mapping (uint256 => address) private _tokenApprovals;
1850 
1851     // Mapping from owner to operator approvals
1852     mapping (address => mapping (address => bool)) private _operatorApprovals;
1853 
1854     // Token name
1855     string private _name;
1856 
1857     // Token symbol
1858     string private _symbol;
1859 
1860     // ERC721 token contract address serving as "ticket" to flip the bool in additional data
1861     address private _ticketContract;
1862 
1863     // Base URI
1864     string private _baseURI;
1865 
1866     // Price per token. Is chosen and can be changed by contract owner.
1867     uint256 private _tokenPrice;
1868 
1869     struct AdditionalData {
1870         bool isA; // A (true) or B (false)
1871         bool someBool; // may be flipped by token owner if he owns T2; default value in _mint
1872         uint8 power;
1873     }
1874 
1875     // Mapping from token ID to its additional data
1876     mapping (uint256 => AdditionalData) private _additionalData;
1877 
1878     // Counter for token id, and types
1879     uint256 private _nextId = 1;
1880     uint32 private _countA = 0; // count of B is implicit and not needed
1881 
1882     mapping (address => bool) public freeBoolSetters; // addresses which do not need to pay to set the bool variable
1883 
1884     // limits
1885     uint256 public constant MAX_SUPPLY = 7000;
1886     uint32 public constant MAX_A = 1000;
1887     uint32 public constant MAX_B = 6000;
1888 
1889     /*
1890      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1891      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1892      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1893      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1894      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1895      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1896      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1897      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1898      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1899      *
1900      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1901      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1902      */
1903     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1904 
1905     /*
1906      *     bytes4(keccak256('name()')) == 0x06fdde03
1907      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1908      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1909      *
1910      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1911      */
1912     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1913 
1914     /*
1915      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1916      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1917      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1918      *
1919      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1920      */
1921     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1922 
1923     /**
1924      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1925      */
1926     constructor (string memory name, string memory symbol, string memory baseURI, uint256 tokenPrice, address ticketContract) public {
1927         _name = name;
1928         _symbol = symbol;
1929         _baseURI = baseURI;
1930         _tokenPrice = tokenPrice;
1931         _ticketContract = ticketContract;
1932 
1933         // register the supported interfaces to conform to ERC721 via ERC165
1934         _registerInterface(_INTERFACE_ID_ERC721);
1935         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1936         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1937     }
1938 
1939 // public functions:
1940     /**
1941      * @dev See {IERC721-balanceOf}.
1942      */
1943     function balanceOf(address owner) public view override returns (uint256) {
1944         require(owner != address(0), "ERC721: balance query for the zero address");
1945 
1946         return _holderTokens[owner].length();
1947     }
1948 
1949     /**
1950      * @dev See {IERC721-ownerOf}.
1951      */
1952     function ownerOf(uint256 tokenId) public view override returns (address) {
1953         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1954     }
1955 
1956     /**
1957      * @dev See {IERC721Metadata-name}.
1958      */
1959     function name() external view override returns (string memory) {
1960         return _name;
1961     }
1962 
1963     /**
1964      * @dev See {IERC721Metadata-symbol}.
1965      */
1966     function symbol() external view override returns (string memory) {
1967         return _symbol;
1968     }
1969 
1970     /**
1971      * @dev See {IERC721Metadata-tokenURI}.
1972      */
1973     function tokenURI(uint256 tokenId) external view override returns (string memory) {
1974         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1975 
1976         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1977         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1978     }
1979 
1980     /**
1981     * @dev Returns the base URI set via {_setBaseURI}. This will be
1982     * automatically added as a prefix in {tokenURI} to each token's URI, or
1983     * to the token ID if no specific URI is set for that token ID.
1984     */
1985     function baseURI() external view returns (string memory) {
1986         return _baseURI;
1987     }
1988 
1989     /**
1990      * @dev Retrieves address of the ticket token contract.
1991      */
1992     function ticketContract() external view returns (address) {
1993         return _ticketContract;
1994     }
1995 
1996     /**
1997      * @dev Price per token for public purchase.
1998      */
1999     function tokenPrice() external view returns (uint256) {
2000         return _tokenPrice;
2001     }
2002 
2003     /**
2004      * @dev Next token id.
2005      */
2006     function nextTokenId() public view returns (uint256) {
2007         return _nextId;
2008     }
2009 
2010     /**
2011      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2012      */
2013     function tokenOfOwnerByIndex(address owner, uint256 index) external view override returns (uint256) {
2014         require(index < balanceOf(owner), "Invalid token index for holder");
2015         return _holderTokens[owner].at(index);
2016     }
2017 
2018     /**
2019      * @dev See {IERC721Enumerable-totalSupply}.
2020      */
2021     function totalSupply() external view override returns (uint256) {
2022         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
2023         return _tokenOwners.length();
2024     }
2025 
2026     /**
2027      * @dev Supply of A tokens.
2028      */
2029     function supplyOfA() external view returns (uint256) {
2030         return _countA;
2031     }
2032 
2033     /**
2034      * @dev See {IERC721Enumerable-tokenByIndex}.
2035      */
2036     function tokenByIndex(uint256 index) external view override returns (uint256) {
2037         require(index < _tokenOwners.length(), "Invalid token index");
2038         (uint256 tokenId, ) = _tokenOwners.at(index);
2039         return tokenId;
2040     }
2041 
2042     /**
2043      * @dev See {IERC721-approve}.
2044      */
2045     function approve(address to, uint256 tokenId) external virtual override {
2046         address owner = ownerOf(tokenId);
2047         require(to != owner, "ERC721: approval to current owner");
2048 
2049         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2050             "ERC721: approve caller is not owner nor approved for all"
2051         );
2052 
2053         _approve(to, tokenId);
2054     }
2055 
2056     /**
2057      * @dev See {IERC721-getApproved}.
2058      */
2059     function getApproved(uint256 tokenId) public view override returns (address) {
2060         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2061 
2062         return _tokenApprovals[tokenId];
2063     }
2064 
2065     /**
2066      * @dev See {IERC721-setApprovalForAll}.
2067      */
2068     function setApprovalForAll(address operator, bool approved) external virtual override {
2069         require(operator != _msgSender(), "ERC721: approve to caller");
2070 
2071         _operatorApprovals[_msgSender()][operator] = approved;
2072         emit ApprovalForAll(_msgSender(), operator, approved);
2073     }
2074 
2075     /**
2076      * @dev See {IERC721-isApprovedForAll}.
2077      */
2078     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
2079         return _operatorApprovals[owner][operator];
2080     }
2081 
2082     /**
2083      * @dev See {IERC721-transferFrom}.
2084      */
2085     function transferFrom(address from, address to, uint256 tokenId) external virtual override {
2086         //solhint-disable-next-line max-line-length
2087         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2088 
2089         _transfer(from, to, tokenId);
2090     }
2091 
2092     /**
2093      * @dev See {IERC721-safeTransferFrom}.
2094      */
2095     function safeTransferFrom(address from, address to, uint256 tokenId) external virtual override {
2096         safeTransferFrom(from, to, tokenId, "");
2097     }
2098 
2099     /**
2100      * @dev See {IERC721-safeTransferFrom}.
2101      */
2102     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2103         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2104         _safeTransfer(from, to, tokenId, _data);
2105     }
2106 
2107     /**
2108      * @dev Buys a token. Needs to be supplied the correct amount of ether.
2109      */
2110     function buyToken() external payable returns (bool)
2111     {
2112         uint256 paidAmount = msg.value;
2113         require(paidAmount == _tokenPrice, "Invalid amount for token purchase");
2114         address to = msg.sender;
2115         uint256 nextToken = nextTokenId();
2116         uint256 remainingTokens = 1 + MAX_SUPPLY - nextToken;
2117         require(remainingTokens > 0, "Maximum supply already reached");
2118 
2119         _holderTokens[to].add(nextToken);
2120         _tokenOwners.set(nextToken, to);
2121 
2122         uint256 remainingA = MAX_A - _countA;
2123         bool a = (uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now, nextToken))) % remainingTokens) < remainingA;
2124         uint8 pow = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now + 1, nextToken))) % (a ? 21 : 79) + (a ? 80 : 1));
2125         _additionalData[nextToken] = AdditionalData(a, false, pow);
2126 
2127         if (a) {
2128             _countA = _countA + 1;
2129         }
2130 
2131         emit Transfer(address(0), to, nextToken);
2132         _nextId = nextToken.add(1);
2133 
2134         payable(owner()).transfer(paidAmount);
2135         return true;
2136     }
2137 
2138     function buy6Tokens() external payable returns (bool)
2139     {
2140         uint256 paidAmount = msg.value;
2141         require(paidAmount == (_tokenPrice * 5 + _tokenPrice / 2), "Invalid amount for token purchase"); // price for 6 tokens is 5.5 times the price for one token
2142         address to = msg.sender;
2143         uint256 nextToken = nextTokenId();
2144         uint256 remainingTokens = 1 + MAX_SUPPLY - nextToken;
2145         require(remainingTokens > 5, "Maximum supply already reached");
2146         uint256 endLoop = nextToken.add(6);
2147 
2148         while (nextToken < endLoop) {
2149             _holderTokens[to].add(nextToken);
2150             _tokenOwners.set(nextToken, to);
2151 
2152             uint256 remainingA = MAX_A - _countA;
2153             bool a = (uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now, nextToken))) % remainingTokens) < remainingA;
2154             uint8 pow = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now + 1, nextToken))) % (a ? 21 : 79) + (a ? 80 : 1));
2155             _additionalData[nextToken] = AdditionalData(a, false, pow);
2156 
2157             if (a) {
2158                 _countA = _countA + 1;
2159             }
2160 
2161             emit Transfer(address(0), to, nextToken);
2162             nextToken = nextToken.add(1);
2163             remainingTokens = remainingTokens.sub(1);
2164         }
2165 
2166         _nextId = _nextId.add(6);
2167 
2168         payable(owner()).transfer(paidAmount);
2169         return true;
2170     }
2171     
2172         function buyTokenTo(address to) external payable returns (bool)
2173     {
2174         uint256 paidAmount = msg.value;
2175         require(paidAmount == _tokenPrice, "Invalid amount for token purchase");
2176         uint256 nextToken = nextTokenId();
2177         uint256 remainingTokens = 1 + MAX_SUPPLY - nextToken;
2178         require(remainingTokens > 0, "Maximum supply already reached");
2179 
2180         _holderTokens[to].add(nextToken);
2181         _tokenOwners.set(nextToken, to);
2182 
2183         uint256 remainingA = MAX_A - _countA;
2184         bool a = (uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now, nextToken))) % remainingTokens) < remainingA;
2185         uint8 pow = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now + 1, nextToken))) % (a ? 21 : 79) + (a ? 80 : 1));
2186         _additionalData[nextToken] = AdditionalData(a, false, pow);
2187 
2188         if (a) {
2189             _countA = _countA + 1;
2190         }
2191 
2192         emit Transfer(address(0), to, nextToken);
2193         _nextId = nextToken.add(1);
2194 
2195         payable(owner()).transfer(paidAmount);
2196         return true;
2197     }
2198     
2199     function buy6TokensTo(address to) external payable returns (bool)
2200     {
2201         uint256 paidAmount = msg.value;
2202         require(paidAmount == (_tokenPrice * 5 + _tokenPrice / 2), "Invalid amount for token purchase"); // price for 6 tokens is 5.5 times the price for one token
2203         uint256 nextToken = nextTokenId();
2204         uint256 remainingTokens = 1 + MAX_SUPPLY - nextToken;
2205         require(remainingTokens > 5, "Maximum supply already reached");
2206         uint256 endLoop = nextToken.add(6);
2207 
2208         while (nextToken < endLoop) {
2209             _holderTokens[to].add(nextToken);
2210             _tokenOwners.set(nextToken, to);
2211 
2212             uint256 remainingA = MAX_A - _countA;
2213             bool a = (uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now, nextToken))) % remainingTokens) < remainingA;
2214             uint8 pow = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now + 1, nextToken))) % (a ? 21 : 79) + (a ? 80 : 1));
2215             _additionalData[nextToken] = AdditionalData(a, false, pow);
2216 
2217             if (a) {
2218                 _countA = _countA + 1;
2219             }
2220 
2221             emit Transfer(address(0), to, nextToken);
2222             nextToken = nextToken.add(1);
2223             remainingTokens = remainingTokens.sub(1);
2224         }
2225 
2226         _nextId = _nextId.add(6);
2227 
2228         payable(owner()).transfer(paidAmount);
2229         return true;
2230     }
2231 
2232     /**
2233      * @dev Retrieves if the specified token is of A type.
2234      */
2235     function isA(uint256 tokenId) external view returns (bool) {
2236         require(_exists(tokenId), "Token ID does not exist");
2237         return _additionalData[tokenId].isA;
2238     }
2239 
2240     /**
2241      * @dev Retrieves if the specified token has its someBool attribute set.
2242      */
2243     function someBool(uint256 tokenId) external view returns (bool) {
2244         require(_exists(tokenId), "Token ID does not exist");
2245         return _additionalData[tokenId].someBool;
2246     }
2247 
2248     /**
2249      * @dev Sets someBool for the specified token. Can only be used by the owner of the token (not an approved account).
2250      * Owner needs to also own a ticket token to set the someBool attribute.
2251      */
2252     function setSomeBool(uint256 tokenId, bool newValue) external {
2253         require(_exists(tokenId), "Token ID does not exist");
2254         require(ownerOf(tokenId) == msg.sender, "Only token owner can set attribute");
2255 
2256         if (freeBoolSetters[msg.sender] == false && _additionalData[tokenId].someBool != newValue) {
2257             require(T2(_ticketContract).burnAnyFrom(msg.sender), "Token owner ticket could not be burned");
2258         }
2259 
2260         _additionalData[tokenId].someBool = newValue;
2261     }
2262 
2263     /**
2264      * @dev Retrieves the power value for a specified token.
2265      */
2266     function power(uint256 tokenId) external view returns (uint8) {
2267         require(_exists(tokenId), "Token ID does not exist");
2268         return _additionalData[tokenId].power;
2269     }
2270 
2271 // owner functions:
2272     /**
2273      * @dev Function to set the base URI for all token IDs. It is automatically added as a prefix to the token id in {tokenURI} to retrieve the token URI.
2274      */
2275     function setBaseURI(string calldata baseURI_) external onlyOwner {
2276         _baseURI = baseURI_;
2277     }
2278 
2279     /**
2280      * @dev Sets a new token price.
2281      */
2282     function setTokenPrice(uint256 newPrice) external onlyOwner {
2283         _tokenPrice = newPrice;
2284     }
2285 
2286     function setFreeBoolSetter(address holder, bool setForFree) external onlyOwner {
2287         freeBoolSetters[holder] = setForFree;
2288     }
2289 
2290 // internal functions:
2291     /**
2292      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2293      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2294      *
2295      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2296      *
2297      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2298      * implement alternative mechanisms to perform token transfer, such as signature-based.
2299      *
2300      * Requirements:
2301      *
2302      * - `from` cannot be the zero address.
2303      * - `to` cannot be the zero address.
2304      * - `tokenId` token must exist and be owned by `from`.
2305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2306      *
2307      * Emits a {Transfer} event.
2308      */
2309     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) private {
2310         _transfer(from, to, tokenId);
2311         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2312     }
2313 
2314     /**
2315      * @dev Returns whether `tokenId` exists.
2316      *
2317      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2318      *
2319      * Tokens start existing when they are minted (`_mint`).
2320      */
2321     function _exists(uint256 tokenId) private view returns (bool) {
2322         return tokenId < _nextId && _tokenOwners.contains(tokenId);
2323     }
2324 
2325     /**
2326      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2327      *
2328      * Requirements:
2329      *
2330      * - `tokenId` must exist.
2331      */
2332     function _isApprovedOrOwner(address spender, uint256 tokenId) private view returns (bool) {
2333         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2334         address owner = ownerOf(tokenId);
2335         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2336     }
2337 
2338     /**
2339      * @dev Transfers `tokenId` from `from` to `to`.
2340      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2341      *
2342      * Requirements:
2343      *
2344      * - `to` cannot be the zero address.
2345      * - `tokenId` token must be owned by `from`.
2346      * - contract owner must have transfer globally allowed.
2347      *
2348      * Emits a {Transfer} event.
2349      */
2350     function _transfer(address from, address to, uint256 tokenId) private {
2351         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2352         require(to != address(0), "ERC721: transfer to the zero address");
2353 
2354         // Clear approvals from the previous owner
2355         _approve(address(0), tokenId);
2356 
2357         _holderTokens[from].remove(tokenId);
2358         _holderTokens[to].add(tokenId);
2359 
2360         _tokenOwners.set(tokenId, to);
2361 
2362         emit Transfer(from, to, tokenId);
2363     }
2364 
2365     /**
2366      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2367      * The call is not executed if the target address is not a contract.
2368      *
2369      * @param from address representing the previous owner of the given token ID
2370      * @param to target address that will receive the tokens
2371      * @param tokenId uint256 ID of the token to be transferred
2372      * @param _data bytes optional data to send along with the call
2373      * @return bool whether the call correctly returned the expected magic value
2374      */
2375     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool)
2376     {
2377         if (!to.isContract()) {
2378             return true;
2379         }
2380         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2381             IERC721Receiver(to).onERC721Received.selector,
2382             _msgSender(),
2383             from,
2384             tokenId,
2385             _data
2386         ), "ERC721: transfer to non ERC721Receiver implementer");
2387         bytes4 retval = abi.decode(returndata, (bytes4));
2388         return (retval == _ERC721_RECEIVED);
2389     }
2390 
2391     function _approve(address to, uint256 tokenId) private {
2392         _tokenApprovals[tokenId] = to;
2393         emit Approval(ownerOf(tokenId), to, tokenId);
2394     }
2395 }