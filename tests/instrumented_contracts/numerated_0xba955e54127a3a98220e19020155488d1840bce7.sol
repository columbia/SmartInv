1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-25
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         uint256 index = digits - 1;
31         temp = value;
32         while (temp != 0) {
33             buffer[index--] = byte(uint8(48 + temp % 10));
34             temp /= 10;
35         }
36         return string(buffer);
37     }
38 }
39 
40 /**
41  * @dev Library for managing an enumerable variant of Solidity's
42  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
43  * type.
44  *
45  * Maps have the following properties:
46  *
47  * - Entries are added, removed, and checked for existence in constant time
48  * (O(1)).
49  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
50  *
51  * ```
52  * contract Example {
53  *     // Add the library methods
54  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
55  *
56  *     // Declare a set state variable
57  *     EnumerableMap.UintToAddressMap private myMap;
58  * }
59  * ```
60  *
61  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
62  * supported.
63  */
64 library EnumerableMap {
65     // To implement this library for multiple types with as little code
66     // repetition as possible, we write it in terms of a generic Map type with
67     // bytes32 keys and values.
68     // The Map implementation uses private functions, and user-facing
69     // implementations (such as Uint256ToAddressMap) are just wrappers around
70     // the underlying Map.
71     // This means that we can only create new EnumerableMaps for types that fit
72     // in bytes32.
73 
74     struct MapEntry {
75         bytes32 _key;
76         bytes32 _value;
77     }
78 
79     struct Map {
80         // Storage of map keys and values
81         MapEntry[] _entries;
82 
83         // Position of the entry defined by a key in the `entries` array, plus 1
84         // because index 0 means a key is not in the map.
85         mapping (bytes32 => uint256) _indexes;
86     }
87 
88     /**
89      * @dev Adds a key-value pair to a map, or updates the value for an existing
90      * key. O(1).
91      *
92      * Returns true if the key was added to the map, that is if it was not
93      * already present.
94      */
95     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
96         // We read and store the key's index to prevent multiple reads from the same storage slot
97         uint256 keyIndex = map._indexes[key];
98 
99         if (keyIndex == 0) { // Equivalent to !contains(map, key)
100             map._entries.push(MapEntry({ _key: key, _value: value }));
101             // The entry is stored at length-1, but we add 1 to all indexes
102             // and use 0 as a sentinel value
103             map._indexes[key] = map._entries.length;
104             return true;
105         } else {
106             map._entries[keyIndex - 1]._value = value;
107             return false;
108         }
109     }
110 
111     /**
112      * @dev Removes a key-value pair from a map. O(1).
113      *
114      * Returns true if the key was removed from the map, that is if it was present.
115      */
116     function _remove(Map storage map, bytes32 key) private returns (bool) {
117         // We read and store the key's index to prevent multiple reads from the same storage slot
118         uint256 keyIndex = map._indexes[key];
119 
120         if (keyIndex != 0) { // Equivalent to contains(map, key)
121             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
122             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
123             // This modifies the order of the array, as noted in {at}.
124 
125             uint256 toDeleteIndex = keyIndex - 1;
126             uint256 lastIndex = map._entries.length - 1;
127 
128             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
129             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
130 
131             MapEntry storage lastEntry = map._entries[lastIndex];
132 
133             // Move the last entry to the index where the entry to delete is
134             map._entries[toDeleteIndex] = lastEntry;
135             // Update the index for the moved entry
136             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
137 
138             // Delete the slot where the moved entry was stored
139             map._entries.pop();
140 
141             // Delete the index for the deleted slot
142             delete map._indexes[key];
143 
144             return true;
145         } else {
146             return false;
147         }
148     }
149 
150     /**
151      * @dev Returns true if the key is in the map. O(1).
152      */
153     function _contains(Map storage map, bytes32 key) private view returns (bool) {
154         return map._indexes[key] != 0;
155     }
156 
157     /**
158      * @dev Returns the number of key-value pairs in the map. O(1).
159      */
160     function _length(Map storage map) private view returns (uint256) {
161         return map._entries.length;
162     }
163 
164    /**
165     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
166     *
167     * Note that there are no guarantees on the ordering of entries inside the
168     * array, and it may change when more entries are added or removed.
169     *
170     * Requirements:
171     *
172     * - `index` must be strictly less than {length}.
173     */
174     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
175         require(map._entries.length > index, "EnumerableMap: index out of bounds");
176 
177         MapEntry storage entry = map._entries[index];
178         return (entry._key, entry._value);
179     }
180 
181     /**
182      * @dev Returns the value associated with `key`.  O(1).
183      *
184      * Requirements:
185      *
186      * - `key` must be in the map.
187      */
188     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
189         return _get(map, key, "EnumerableMap: nonexistent key");
190     }
191 
192     /**
193      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
194      */
195     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
196         uint256 keyIndex = map._indexes[key];
197         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
198         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
199     }
200 
201     // UintToAddressMap
202 
203     struct UintToAddressMap {
204         Map _inner;
205     }
206 
207     /**
208      * @dev Adds a key-value pair to a map, or updates the value for an existing
209      * key. O(1).
210      *
211      * Returns true if the key was added to the map, that is if it was not
212      * already present.
213      */
214     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
215         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
216     }
217 
218     /**
219      * @dev Removes a value from a set. O(1).
220      *
221      * Returns true if the key was removed from the map, that is if it was present.
222      */
223     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
224         return _remove(map._inner, bytes32(key));
225     }
226 
227     /**
228      * @dev Returns true if the key is in the map. O(1).
229      */
230     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
231         return _contains(map._inner, bytes32(key));
232     }
233 
234     /**
235      * @dev Returns the number of elements in the map. O(1).
236      */
237     function length(UintToAddressMap storage map) internal view returns (uint256) {
238         return _length(map._inner);
239     }
240 
241    /**
242     * @dev Returns the element stored at position `index` in the set. O(1).
243     * Note that there are no guarantees on the ordering of values inside the
244     * array, and it may change when more values are added or removed.
245     *
246     * Requirements:
247     *
248     * - `index` must be strictly less than {length}.
249     */
250     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
251         (bytes32 key, bytes32 value) = _at(map._inner, index);
252         return (uint256(key), address(uint256(value)));
253     }
254 
255     /**
256      * @dev Returns the value associated with `key`.  O(1).
257      *
258      * Requirements:
259      *
260      * - `key` must be in the map.
261      */
262     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
263         return address(uint256(_get(map._inner, bytes32(key))));
264     }
265 
266     /**
267      * @dev Same as {get}, with a custom error message when `key` is not in the map.
268      */
269     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
270         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
271     }
272 }
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
514 /**
515  * @dev Collection of functions related to the address type
516  */
517 library Address {
518     /**
519      * @dev Returns true if `account` is a contract.
520      *
521      * [IMPORTANT]
522      * ====
523      * It is unsafe to assume that an address for which this function returns
524      * false is an externally-owned account (EOA) and not a contract.
525      *
526      * Among others, `isContract` will return false for the following
527      * types of addresses:
528      *
529      *  - an externally-owned account
530      *  - a contract in construction
531      *  - an address where a contract will be created
532      *  - an address where a contract lived, but was destroyed
533      * ====
534      */
535     function isContract(address account) internal view returns (bool) {
536         // This method relies on extcodesize, which returns 0 for contracts in
537         // construction, since the code is only stored at the end of the
538         // constructor execution.
539 
540         uint256 size;
541         // solhint-disable-next-line no-inline-assembly
542         assembly { size := extcodesize(account) }
543         return size > 0;
544     }
545 
546     /**
547      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
548      * `recipient`, forwarding all available gas and reverting on errors.
549      *
550      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
551      * of certain opcodes, possibly making contracts go over the 2300 gas limit
552      * imposed by `transfer`, making them unable to receive funds via
553      * `transfer`. {sendValue} removes this limitation.
554      *
555      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
556      *
557      * IMPORTANT: because control is transferred to `recipient`, care must be
558      * taken to not create reentrancy vulnerabilities. Consider using
559      * {ReentrancyGuard} or the
560      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
561      */
562     function sendValue(address payable recipient, uint256 amount) internal {
563         require(address(this).balance >= amount, "Address: insufficient balance");
564 
565         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
566         (bool success, ) = recipient.call{ value: amount }("");
567         require(success, "Address: unable to send value, recipient may have reverted");
568     }
569 
570     /**
571      * @dev Performs a Solidity function call using a low level `call`. A
572      * plain`call` is an unsafe replacement for a function call: use this
573      * function instead.
574      *
575      * If `target` reverts with a revert reason, it is bubbled up by this
576      * function (like regular Solidity function calls).
577      *
578      * Returns the raw returned data. To convert to the expected return value,
579      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
580      *
581      * Requirements:
582      *
583      * - `target` must be a contract.
584      * - calling `target` with `data` must not revert.
585      *
586      * _Available since v3.1._
587      */
588     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
589       return functionCall(target, data, "Address: low-level call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
594      * `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, 0, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but also transferring `value` wei to `target`.
605      *
606      * Requirements:
607      *
608      * - the calling contract must have an ETH balance of at least `value`.
609      * - the called Solidity function must be `payable`.
610      *
611      * _Available since v3.1._
612      */
613     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
614         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
619      * with `errorMessage` as a fallback revert reason when `target` reverts.
620      *
621      * _Available since v3.1._
622      */
623     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
624         require(address(this).balance >= value, "Address: insufficient balance for call");
625         require(isContract(target), "Address: call to non-contract");
626 
627         // solhint-disable-next-line avoid-low-level-calls
628         (bool success, bytes memory returndata) = target.call{ value: value }(data);
629         return _verifyCallResult(success, returndata, errorMessage);
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
634      * but performing a static call.
635      *
636      * _Available since v3.3._
637      */
638     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
639         return functionStaticCall(target, data, "Address: low-level static call failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
644      * but performing a static call.
645      *
646      * _Available since v3.3._
647      */
648     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
649         require(isContract(target), "Address: static call to non-contract");
650 
651         // solhint-disable-next-line avoid-low-level-calls
652         (bool success, bytes memory returndata) = target.staticcall(data);
653         return _verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a delegate call.
659      *
660      * _Available since v3.3._
661      */
662     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
663         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a delegate call.
669      *
670      * _Available since v3.3._
671      */
672     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
673         require(isContract(target), "Address: delegate call to non-contract");
674 
675         // solhint-disable-next-line avoid-low-level-calls
676         (bool success, bytes memory returndata) = target.delegatecall(data);
677         return _verifyCallResult(success, returndata, errorMessage);
678     }
679 
680     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687 
688                 // solhint-disable-next-line no-inline-assembly
689                 assembly {
690                     let returndata_size := mload(returndata)
691                     revert(add(32, returndata), returndata_size)
692                 }
693             } else {
694                 revert(errorMessage);
695             }
696         }
697     }
698 }
699 
700 /**
701  * @dev Wrappers over Solidity's arithmetic operations with added overflow
702  * checks.
703  *
704  * Arithmetic operations in Solidity wrap on overflow. This can easily result
705  * in bugs, because programmers usually assume that an overflow raises an
706  * error, which is the standard behavior in high level programming languages.
707  * `SafeMath` restores this intuition by reverting the transaction when an
708  * operation overflows.
709  *
710  * Using this library instead of the unchecked operations eliminates an entire
711  * class of bugs, so it's recommended to use it always.
712  */
713 library SafeMath {
714     /**
715      * @dev Returns the addition of two unsigned integers, reverting on
716      * overflow.
717      *
718      * Counterpart to Solidity's `+` operator.
719      *
720      * Requirements:
721      *
722      * - Addition cannot overflow.
723      */
724     function add(uint256 a, uint256 b) internal pure returns (uint256) {
725         uint256 c = a + b;
726         require(c >= a, "SafeMath: addition overflow");
727 
728         return c;
729     }
730 
731     /**
732      * @dev Returns the subtraction of two unsigned integers, reverting on
733      * overflow (when the result is negative).
734      *
735      * Counterpart to Solidity's `-` operator.
736      *
737      * Requirements:
738      *
739      * - Subtraction cannot overflow.
740      */
741     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
742         return sub(a, b, "SafeMath: subtraction overflow");
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
747      * overflow (when the result is negative).
748      *
749      * Counterpart to Solidity's `-` operator.
750      *
751      * Requirements:
752      *
753      * - Subtraction cannot overflow.
754      */
755     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
756         require(b <= a, errorMessage);
757         uint256 c = a - b;
758 
759         return c;
760     }
761 
762     /**
763      * @dev Returns the multiplication of two unsigned integers, reverting on
764      * overflow.
765      *
766      * Counterpart to Solidity's `*` operator.
767      *
768      * Requirements:
769      *
770      * - Multiplication cannot overflow.
771      */
772     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
773         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
774         // benefit is lost if 'b' is also tested.
775         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
776         if (a == 0) {
777             return 0;
778         }
779 
780         uint256 c = a * b;
781         require(c / a == b, "SafeMath: multiplication overflow");
782 
783         return c;
784     }
785 
786     /**
787      * @dev Returns the integer division of two unsigned integers. Reverts on
788      * division by zero. The result is rounded towards zero.
789      *
790      * Counterpart to Solidity's `/` operator. Note: this function uses a
791      * `revert` opcode (which leaves remaining gas untouched) while Solidity
792      * uses an invalid opcode to revert (consuming all remaining gas).
793      *
794      * Requirements:
795      *
796      * - The divisor cannot be zero.
797      */
798     function div(uint256 a, uint256 b) internal pure returns (uint256) {
799         return div(a, b, "SafeMath: division by zero");
800     }
801 
802     /**
803      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
804      * division by zero. The result is rounded towards zero.
805      *
806      * Counterpart to Solidity's `/` operator. Note: this function uses a
807      * `revert` opcode (which leaves remaining gas untouched) while Solidity
808      * uses an invalid opcode to revert (consuming all remaining gas).
809      *
810      * Requirements:
811      *
812      * - The divisor cannot be zero.
813      */
814     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
815         require(b > 0, errorMessage);
816         uint256 c = a / b;
817         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
818 
819         return c;
820     }
821 
822     /**
823      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
824      * Reverts when dividing by zero.
825      *
826      * Counterpart to Solidity's `%` operator. This function uses a `revert`
827      * opcode (which leaves remaining gas untouched) while Solidity uses an
828      * invalid opcode to revert (consuming all remaining gas).
829      *
830      * Requirements:
831      *
832      * - The divisor cannot be zero.
833      */
834     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
835         return mod(a, b, "SafeMath: modulo by zero");
836     }
837 
838     /**
839      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
840      * Reverts with custom message when dividing by zero.
841      *
842      * Counterpart to Solidity's `%` operator. This function uses a `revert`
843      * opcode (which leaves remaining gas untouched) while Solidity uses an
844      * invalid opcode to revert (consuming all remaining gas).
845      *
846      * Requirements:
847      *
848      * - The divisor cannot be zero.
849      */
850     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
851         require(b != 0, errorMessage);
852         return a % b;
853     }
854 }
855 
856 /**
857  * @title ERC721 token receiver interface
858  * @dev Interface for any contract that wants to support safeTransfers
859  * from ERC721 asset contracts.
860  */
861 interface IERC721Receiver {
862     /**
863      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
864      * by `operator` from `from`, this function is called.
865      *
866      * It must return its Solidity selector to confirm the token transfer.
867      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
868      *
869      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
870      */
871     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
872 }
873 
874 /*
875  * @dev Provides information about the current execution context, including the
876  * sender of the transaction and its data. While these are generally available
877  * via msg.sender and msg.data, they should not be accessed in such a direct
878  * manner, since when dealing with GSN meta-transactions the account sending and
879  * paying for execution may not be the actual sender (as far as an application
880  * is concerned).
881  *
882  * This contract is only required for intermediate, library-like contracts.
883  */
884 abstract contract Context {
885     function _msgSender() internal view virtual returns (address payable) {
886         return msg.sender;
887     }
888 
889     function _msgData() internal view virtual returns (bytes memory) {
890         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
891         return msg.data;
892     }
893 }
894 
895 /**
896  * @dev Interface of the ERC20 standard as defined in the EIP.
897  */
898 interface IERC20 {
899     /**
900      * @dev Returns the amount of tokens in existence.
901      */
902     function totalSupply() external view returns (uint256);
903 
904     /**
905      * @dev Returns the amount of tokens owned by `account`.
906      */
907     function balanceOf(address account) external view returns (uint256);
908 
909     /**
910      * @dev Moves `amount` tokens from the caller's account to `recipient`.
911      *
912      * Returns a boolean value indicating whether the operation succeeded.
913      *
914      * Emits a {Transfer} event.
915      */
916     function transfer(address recipient, uint256 amount) external returns (bool);
917 
918     /**
919      * @dev Returns the remaining number of tokens that `spender` will be
920      * allowed to spend on behalf of `owner` through {transferFrom}. This is
921      * zero by default.
922      *
923      * This value changes when {approve} or {transferFrom} are called.
924      */
925     function allowance(address owner, address spender) external view returns (uint256);
926 
927     /**
928      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
929      *
930      * Returns a boolean value indicating whether the operation succeeded.
931      *
932      * IMPORTANT: Beware that changing an allowance with this method brings the risk
933      * that someone may use both the old and the new allowance by unfortunate
934      * transaction ordering. One possible solution to mitigate this race
935      * condition is to first reduce the spender's allowance to 0 and set the
936      * desired value afterwards:
937      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
938      *
939      * Emits an {Approval} event.
940      */
941     function approve(address spender, uint256 amount) external returns (bool);
942 
943     /**
944      * @dev Moves `amount` tokens from `sender` to `recipient` using the
945      * allowance mechanism. `amount` is then deducted from the caller's
946      * allowance.
947      *
948      * Returns a boolean value indicating whether the operation succeeded.
949      *
950      * Emits a {Transfer} event.
951      */
952     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
953 
954     /**
955      * @dev Emitted when `value` tokens are moved from one account (`from`) to
956      * another (`to`).
957      *
958      * Note that `value` may be zero.
959      */
960     event Transfer(address indexed from, address indexed to, uint256 value);
961 
962     /**
963      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
964      * a call to {approve}. `value` is the new allowance.
965      */
966     event Approval(address indexed owner, address indexed spender, uint256 value);
967 }
968 
969 /**
970  * @dev Interface of the ERC165 standard, as defined in the
971  * https://eips.ethereum.org/EIPS/eip-165[EIP].
972  *
973  * Implementers can declare support of contract interfaces, which can then be
974  * queried by others ({ERC165Checker}).
975  *
976  * For an implementation, see {ERC165}.
977  */
978 interface IERC165 {
979     /**
980      * @dev Returns true if this contract implements the interface defined by
981      * `interfaceId`. See the corresponding
982      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
983      * to learn more about how these ids are created.
984      *
985      * This function call must use less than 30 000 gas.
986      */
987     function supportsInterface(bytes4 interfaceId) external view returns (bool);
988 }
989 
990 /**
991  * @dev Contract module which provides a basic access control mechanism, where
992  * there is an account (an owner) that can be granted exclusive access to
993  * specific functions.
994  *
995  * By default, the owner account will be the one that deploys the contract. This
996  * can later be changed with {transferOwnership}.
997  *
998  * This module is used through inheritance. It will make available the modifier
999  * `onlyOwner`, which can be applied to your functions to restrict their use to
1000  * the owner.
1001  */
1002 contract Ownable is Context {
1003     address private _owner;
1004 
1005     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1006 
1007     /**
1008      * @dev Initializes the contract setting the deployer as the initial owner.
1009      */
1010     constructor () internal {
1011         address msgSender = _msgSender();
1012         _owner = msgSender;
1013         emit OwnershipTransferred(address(0), msgSender);
1014     }
1015 
1016     /**
1017      * @dev Returns the address of the current owner.
1018      */
1019     function owner() public view returns (address) {
1020         return _owner;
1021     }
1022 
1023     /**
1024      * @dev Throws if called by any account other than the owner.
1025      */
1026     modifier onlyOwner() {
1027         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1028         _;
1029     }
1030 
1031     /**
1032      * @dev Leaves the contract without owner. It will not be possible to call
1033      * `onlyOwner` functions anymore. Can only be called by the current owner.
1034      *
1035      * NOTE: Renouncing ownership will leave the contract without an owner,
1036      * thereby removing any functionality that is only available to the owner.
1037      */
1038     function renounceOwnership() public virtual onlyOwner {
1039         emit OwnershipTransferred(_owner, address(0));
1040         _owner = address(0);
1041     }
1042 
1043     /**
1044      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1045      * Can only be called by the current owner.
1046      */
1047     function transferOwnership(address newOwner) public virtual onlyOwner {
1048         require(newOwner != address(0), "Ownable: new owner is the zero address");
1049         emit OwnershipTransferred(_owner, newOwner);
1050         _owner = newOwner;
1051     }
1052 }
1053 
1054 /**
1055  * @title SafeERC20
1056  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1057  * contract returns false). Tokens that return no value (and instead revert or
1058  * throw on failure) are also supported, non-reverting calls are assumed to be
1059  * successful.
1060  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1061  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1062  */
1063 library SafeERC20 {
1064     using SafeMath for uint256;
1065     using Address for address;
1066 
1067     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1068         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1069     }
1070 
1071     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1072         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1073     }
1074 
1075     /**
1076      * @dev Deprecated. This function has issues similar to the ones found in
1077      * {IERC20-approve}, and its usage is discouraged.
1078      *
1079      * Whenever possible, use {safeIncreaseAllowance} and
1080      * {safeDecreaseAllowance} instead.
1081      */
1082     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1083         // safeApprove should only be called when setting an initial allowance,
1084         // or when resetting it to zero. To increase and decrease it, use
1085         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1086         // solhint-disable-next-line max-line-length
1087         require((value == 0) || (token.allowance(address(this), spender) == 0),
1088             "SafeERC20: approve from non-zero to non-zero allowance"
1089         );
1090         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1091     }
1092 
1093     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1094         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1095         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1096     }
1097 
1098     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1099         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1100         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1101     }
1102 
1103     /**
1104      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1105      * on the return value: the return value is optional (but if data is returned, it must not be false).
1106      * @param token The token targeted by the call.
1107      * @param data The call data (encoded using abi.encode or one of its variants).
1108      */
1109     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1110         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1111         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1112         // the target address contains contract code and also asserts for success in the low-level call.
1113 
1114         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1115         if (returndata.length > 0) { // Return data is optional
1116             // solhint-disable-next-line max-line-length
1117             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1118         }
1119     }
1120 }
1121 
1122 /**
1123  * @dev Required interface of an ERC721 compliant contract.
1124  */
1125 interface IERC721 is IERC165 {
1126     /**
1127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1128      */
1129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1130 
1131     /**
1132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1133      */
1134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1135 
1136     /**
1137      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1138      */
1139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1140 
1141     /**
1142      * @dev Returns the number of tokens in ``owner``'s account.
1143      */
1144     function balanceOf(address owner) external view returns (uint256 balance);
1145 
1146     /**
1147      * @dev Returns the owner of the `tokenId` token.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must exist.
1152      */
1153     function ownerOf(uint256 tokenId) external view returns (address owner);
1154 
1155     /**
1156      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1157      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1158      *
1159      * Requirements:
1160      *
1161      * - `from` cannot be the zero address.
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must exist and be owned by `from`.
1164      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1170 
1171     /**
1172      * @dev Transfers `tokenId` token from `from` to `to`.
1173      *
1174      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1175      *
1176      * Requirements:
1177      *
1178      * - `from` cannot be the zero address.
1179      * - `to` cannot be the zero address.
1180      * - `tokenId` token must be owned by `from`.
1181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function transferFrom(address from, address to, uint256 tokenId) external;
1186 
1187     /**
1188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1189      * The approval is cleared when the token is transferred.
1190      *
1191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1192      *
1193      * Requirements:
1194      *
1195      * - The caller must own the token or be an approved operator.
1196      * - `tokenId` must exist.
1197      *
1198      * Emits an {Approval} event.
1199      */
1200     function approve(address to, uint256 tokenId) external;
1201 
1202     /**
1203      * @dev Returns the account approved for `tokenId` token.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      */
1209     function getApproved(uint256 tokenId) external view returns (address operator);
1210 
1211     /**
1212      * @dev Approve or remove `operator` as an operator for the caller.
1213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1214      *
1215      * Requirements:
1216      *
1217      * - The `operator` cannot be the caller.
1218      *
1219      * Emits an {ApprovalForAll} event.
1220      */
1221     function setApprovalForAll(address operator, bool _approved) external;
1222 
1223     /**
1224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1225      *
1226      * See {setApprovalForAll}
1227      */
1228     function isApprovedForAll(address owner, address operator) external view returns (bool);
1229 
1230     /**
1231       * @dev Safely transfers `tokenId` token from `from` to `to`.
1232       *
1233       * Requirements:
1234       *
1235      * - `from` cannot be the zero address.
1236      * - `to` cannot be the zero address.
1237       * - `tokenId` token must exist and be owned by `from`.
1238       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1239       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1240       *
1241       * Emits a {Transfer} event.
1242       */
1243     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1244 }
1245 
1246 /**
1247  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1248  * @dev See https://eips.ethereum.org/EIPS/eip-721
1249  */
1250 interface IERC721Metadata is IERC721 {
1251 
1252     /**
1253      * @dev Returns the token collection name.
1254      */
1255     function name() external view returns (string memory);
1256 
1257     /**
1258      * @dev Returns the token collection symbol.
1259      */
1260     function symbol() external view returns (string memory);
1261 
1262     /**
1263      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1264      */
1265     function tokenURI(uint256 tokenId) external view returns (string memory);
1266 }
1267 
1268 /**
1269  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1270  * @dev See https://eips.ethereum.org/EIPS/eip-721
1271  */
1272 interface IERC721Enumerable is IERC721 {
1273 
1274     /**
1275      * @dev Returns the total amount of tokens stored by the contract.
1276      */
1277     function totalSupply() external view returns (uint256);
1278 
1279     /**
1280      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1281      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1282      */
1283     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1284 
1285     /**
1286      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1287      * Use along with {totalSupply} to enumerate all tokens.
1288      */
1289     function tokenByIndex(uint256 index) external view returns (uint256);
1290 }
1291 
1292 /**
1293  * @dev Implementation of the {IERC165} interface.
1294  *
1295  * Contracts may inherit from this and call {_registerInterface} to declare
1296  * their support of an interface.
1297  */
1298 contract ERC165 is IERC165 {
1299     /*
1300      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1301      */
1302     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1303 
1304     /**
1305      * @dev Mapping of interface ids to whether or not it's supported.
1306      */
1307     mapping(bytes4 => bool) private _supportedInterfaces;
1308 
1309     constructor () internal {
1310         // Derived contracts need only register support for their own interfaces,
1311         // we register support for ERC165 itself here
1312         _registerInterface(_INTERFACE_ID_ERC165);
1313     }
1314 
1315     /**
1316      * @dev See {IERC165-supportsInterface}.
1317      *
1318      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1319      */
1320     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1321         return _supportedInterfaces[interfaceId];
1322     }
1323 
1324     /**
1325      * @dev Registers the contract as an implementer of the interface defined by
1326      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1327      * registering its interface id is not required.
1328      *
1329      * See {IERC165-supportsInterface}.
1330      *
1331      * Requirements:
1332      *
1333      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1334      */
1335     function _registerInterface(bytes4 interfaceId) internal virtual {
1336         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1337         _supportedInterfaces[interfaceId] = true;
1338     }
1339 }
1340 
1341 /**
1342  * @dev Contract module that can be used to recover ERC20 compatible tokens stuck in the contract.
1343  */
1344 contract ERC20Recoverable is Ownable {
1345     /**
1346      * @dev Used to transfer tokens stuck on this contract to another address.
1347      */
1348     function recoverERC20(address token, address recipient, uint256 amount) external onlyOwner returns (bool) {
1349         return IERC20(token).transfer(recipient, amount);
1350     }
1351 
1352     /**
1353      * @dev Used to approve recovery of stuck tokens. May also be used to approve token transfers in advance.
1354      */
1355      function recoverERC20Approve(address token, address spender, uint256 amount) external onlyOwner returns (bool) {
1356         return IERC20(token).approve(spender, amount);
1357     }
1358 }
1359 
1360 /**
1361  * @dev Contract module that can be used to recover ERC20 compatible tokens stuck in the contract.
1362  */
1363 contract ERC721Recoverable is Ownable {
1364     /**
1365      * @dev Used to recover a stuck token.
1366      */
1367     function recoverERC721(address token, address recipient, uint256 tokenId) external onlyOwner {
1368         return IERC721(token).transferFrom(address(this), recipient, tokenId);
1369     }
1370 
1371     /**
1372      * @dev Used to recover a stuck token using the safe transfer function of ERC721.
1373      */
1374     function recoverERC721Safe(address token, address recipient, uint256 tokenId) external onlyOwner {
1375         return IERC721(token).safeTransferFrom(address(this), recipient, tokenId);
1376     }
1377 
1378     /**
1379      * @dev Used to approve the recovery of a stuck token.
1380      */
1381     function recoverERC721Approve(address token, address recipient, uint256 tokenId) external onlyOwner {
1382         return IERC721(token).approve(recipient, tokenId);
1383     }
1384 
1385     /**
1386      * @dev Used to approve the recovery of stuck token, also in future.
1387      */
1388     function recoverERC721ApproveAll(address token, address recipient, bool approved) external onlyOwner {
1389         return IERC721(token).setApprovalForAll(recipient, approved);
1390     }
1391 }
1392 
1393 /**
1394  * @dev Most credited to OpenZeppelin ERC721.sol, but with some adjustments.
1395  */
1396 contract T2 is Context, Ownable, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, ERC20Recoverable, ERC721Recoverable {
1397     using SafeMath for uint256;
1398     using Address for address;
1399     using EnumerableSet for EnumerableSet.UintSet;
1400     using EnumerableMap for EnumerableMap.UintToAddressMap;
1401     using Strings for uint256;
1402 
1403     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1404     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1405     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1406 
1407     // Mapping from holder address to their (enumerable) set of owned tokens
1408     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1409 
1410     // Enumerable mapping from token ids to their owners
1411     EnumerableMap.UintToAddressMap private _tokenOwners;
1412 
1413     // Mapping from token ID to approved address
1414     mapping (uint256 => address) private _tokenApprovals;
1415 
1416     // Mapping from owner to operator approvals
1417     mapping (address => mapping (address => bool)) private _operatorApprovals;
1418 
1419     // Token name
1420     string private _name;
1421 
1422     // Token symbol
1423     string private _symbol;
1424 
1425     // Base URI
1426     string private _baseURI;
1427 
1428     // Specified if tokens are transferable. Can be flipped by the owner.
1429     bool private _transferable;
1430 
1431     // Price per token. Is chosen and can be changed by contract owner.
1432     uint256 private _tokenPrice;
1433 
1434     // Counter for token id
1435     uint256 private _nextId = 1;
1436 
1437     /*
1438      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1439      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1440      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1441      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1442      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1443      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1444      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1445      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1446      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1447      *
1448      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1449      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1450      */
1451     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1452 
1453     /*
1454      *     bytes4(keccak256('name()')) == 0x06fdde03
1455      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1456      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1457      *
1458      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1459      */
1460     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1461 
1462     /*
1463      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1464      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1465      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1466      *
1467      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1468      */
1469     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1470 
1471     /**
1472      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1473      */
1474     constructor (string memory name, string memory symbol, string memory baseURI, bool transferable, uint256 tokenPrice) public {
1475         _name = name;
1476         _symbol = symbol;
1477         _baseURI = baseURI;
1478         _transferable = transferable;
1479         _tokenPrice = tokenPrice;
1480 
1481         // register the supported interfaces to conform to ERC721 via ERC165
1482         _registerInterface(_INTERFACE_ID_ERC721);
1483         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1484         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1485     }
1486 
1487 // public functions:
1488     /**
1489      * @dev See {IERC721-balanceOf}.
1490      */
1491     function balanceOf(address owner) external view override returns (uint256) {
1492         require(owner != address(0), "ERC721: balance query for the zero address");
1493 
1494         return _holderTokens[owner].length();
1495     }
1496 
1497     /**
1498      * @dev See {IERC721-ownerOf}.
1499      */
1500     function ownerOf(uint256 tokenId) public view override returns (address) {
1501         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Metadata-name}.
1506      */
1507     function name() external view override returns (string memory) {
1508         return _name;
1509     }
1510 
1511     /**
1512      * @dev See {IERC721Metadata-symbol}.
1513      */
1514     function symbol() external view override returns (string memory) {
1515         return _symbol;
1516     }
1517 
1518     /**
1519      * @dev See {IERC721Metadata-tokenURI}.
1520      */
1521     function tokenURI(uint256 tokenId) external view override returns (string memory) {
1522         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1523 
1524         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1525         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1526     }
1527 
1528     /**
1529     * @dev Returns the base URI set via {_setBaseURI}. This will be
1530     * automatically added as a prefix in {tokenURI} to each token's URI, or
1531     * to the token ID if no specific URI is set for that token ID.
1532     */
1533     function baseURI() external view returns (string memory) {
1534         return _baseURI;
1535     }
1536 
1537     /**
1538      * @dev Returns if tokens are globally transferable currently. That may be decided by the contract owner.
1539      */
1540     function transferable() external view returns (bool) {
1541         return _transferable;
1542     }
1543 
1544     /**
1545      * @dev Price per token for public purchase.
1546      */
1547     function tokenPrice() external view returns (uint256) {
1548         return _tokenPrice;
1549     }
1550 
1551     /**
1552      * @dev Next token id.
1553      */
1554     function nextTokenId() public view returns (uint256) {
1555         return _nextId;
1556     }
1557 
1558     /**
1559      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1560      */
1561     function tokenOfOwnerByIndex(address owner, uint256 index) external view override returns (uint256) {
1562         return _holderTokens[owner].at(index);
1563     }
1564 
1565     /**
1566      * @dev See {IERC721Enumerable-totalSupply}.
1567      */
1568     function totalSupply() external view override returns (uint256) {
1569         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1570         return _tokenOwners.length();
1571     }
1572 
1573     /**
1574      * @dev See {IERC721Enumerable-tokenByIndex}.
1575      */
1576     function tokenByIndex(uint256 index) external view override returns (uint256) {
1577         (uint256 tokenId, ) = _tokenOwners.at(index);
1578         return tokenId;
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-approve}.
1583      */
1584     function approve(address to, uint256 tokenId) external virtual override {
1585         address owner = ownerOf(tokenId);
1586         require(to != owner, "ERC721: approval to current owner");
1587 
1588         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1589             "ERC721: approve caller is not owner nor approved for all"
1590         );
1591 
1592         _approve(to, tokenId);
1593     }
1594 
1595     /**
1596      * @dev See {IERC721-getApproved}.
1597      */
1598     function getApproved(uint256 tokenId) public view override returns (address) {
1599         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1600 
1601         return _tokenApprovals[tokenId];
1602     }
1603 
1604     /**
1605      * @dev See {IERC721-setApprovalForAll}.
1606      */
1607     function setApprovalForAll(address operator, bool approved) external virtual override {
1608         require(operator != _msgSender(), "ERC721: approve to caller");
1609 
1610         _operatorApprovals[_msgSender()][operator] = approved;
1611         emit ApprovalForAll(_msgSender(), operator, approved);
1612     }
1613 
1614     /**
1615      * @dev See {IERC721-isApprovedForAll}.
1616      */
1617     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1618         return _operatorApprovals[owner][operator];
1619     }
1620 
1621     /**
1622      * @dev See {IERC721-transferFrom}.
1623      */
1624     function transferFrom(address from, address to, uint256 tokenId) external virtual override {
1625         //solhint-disable-next-line max-line-length
1626         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1627 
1628         _transfer(from, to, tokenId);
1629     }
1630 
1631     /**
1632      * @dev See {IERC721-safeTransferFrom}.
1633      */
1634     function safeTransferFrom(address from, address to, uint256 tokenId) external virtual override {
1635         safeTransferFrom(from, to, tokenId, "");
1636     }
1637 
1638     /**
1639      * @dev See {IERC721-safeTransferFrom}.
1640      */
1641     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1642         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1643         _safeTransfer(from, to, tokenId, _data);
1644     }
1645 
1646     function buyToken() external payable returns (bool)
1647     {
1648         uint256 paidAmount = msg.value;
1649         require(paidAmount == _tokenPrice, "Invalid amount for token purchase");
1650         _mint(msg.sender, nextTokenId());
1651         _incrementTokenId();
1652         payable(owner()).transfer(paidAmount);
1653         return true;
1654     }
1655 
1656     /**
1657      * @dev Burns `tokenId`. See {ERC721-_burn}.
1658      *
1659      * Requirements:
1660      *
1661      * - The caller must own `tokenId` or be an approved operator.
1662      */
1663     function burn(uint256 tokenId) public returns (bool) {
1664         //solhint-disable-next-line max-line-length
1665         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1666         _burn(tokenId);
1667         return true;
1668     }
1669 
1670     function burnAnyFrom(address burner) public returns (bool) {
1671         require(_holderTokens[burner].length() > 0, "Address does not have any tokens to burn");
1672         return burn(_holderTokens[burner].at(0));
1673     }
1674 
1675     function burnAny() external returns (bool) {
1676         return burnAnyFrom(msg.sender);
1677     }
1678 
1679 // owner functions:
1680     /**
1681      * @dev Function to set the base URI for all token IDs. It is automatically added as a prefix to the token id in {tokenURI} to retrieve the token URI.
1682      */
1683     function setBaseURI(string calldata baseURI_) external onlyOwner {
1684         _baseURI = baseURI_;
1685     }
1686 
1687     /**
1688      * @dev Function for the contract owner to allow or disallow token transfers.
1689      */
1690     function setTransferable(bool allowed) external onlyOwner {
1691         _transferable = allowed;
1692     }
1693 
1694     /**
1695      * @dev Sets a new token price.
1696      */
1697     function setTokenPrice(uint256 newPrice) external onlyOwner {
1698         _tokenPrice = newPrice;
1699     }
1700 
1701 // internal functions:
1702     /**
1703      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1704      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1705      *
1706      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1707      *
1708      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1709      * implement alternative mechanisms to perform token transfer, such as signature-based.
1710      *
1711      * Requirements:
1712      *
1713      * - `from` cannot be the zero address.
1714      * - `to` cannot be the zero address.
1715      * - `tokenId` token must exist and be owned by `from`.
1716      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1717      *
1718      * Emits a {Transfer} event.
1719      */
1720     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) private {
1721         _transfer(from, to, tokenId);
1722         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1723     }
1724 
1725     /**
1726      * @dev Returns whether `tokenId` exists.
1727      *
1728      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1729      *
1730      * Tokens start existing when they are minted (`_mint`),
1731      * and stop existing when they are burned (`_burn`).
1732      */
1733     function _exists(uint256 tokenId) private view returns (bool) {
1734         return _tokenOwners.contains(tokenId);
1735     }
1736 
1737     /**
1738      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1739      *
1740      * Requirements:
1741      *
1742      * - `tokenId` must exist.
1743      */
1744     function _isApprovedOrOwner(address spender, uint256 tokenId) private view returns (bool) {
1745         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1746         address owner = ownerOf(tokenId);
1747         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1748     }
1749 
1750     /**
1751      * @dev Safely mints `tokenId` and transfers it to `to`.
1752      *
1753      * Requirements:
1754      d*
1755      * - `tokenId` must not exist.
1756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1757      *
1758      * Emits a {Transfer} event.
1759      */
1760     function _safeMint(address to, uint256 tokenId) private {
1761         _safeMint(to, tokenId, "");
1762     }
1763 
1764     /**
1765      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1766      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1767      */
1768     function _safeMint(address to, uint256 tokenId, bytes memory _data) private {
1769         _mint(to, tokenId);
1770         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1771     }
1772 
1773     /**
1774      * @dev Mints `tokenId` and transfers it to `to`.
1775      *
1776      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1777      *
1778      * Requirements:
1779      *
1780      * - `tokenId` must not exist.
1781      * - `to` cannot be the zero address.
1782      *
1783      * Emits a {Transfer} event.
1784      */
1785     function _mint(address to, uint256 tokenId) private {
1786         require(to != address(0), "ERC721: mint to the zero address");
1787         require(!_exists(tokenId), "ERC721: token already minted");
1788 
1789         _holderTokens[to].add(tokenId);
1790 
1791         _tokenOwners.set(tokenId, to);
1792 
1793         emit Transfer(address(0), to, tokenId);
1794     }
1795 
1796     /**
1797      * @dev Destroys `tokenId`.
1798      * The approval is cleared when the token is burned.
1799      *
1800      * Requirements:
1801      *
1802      * - `tokenId` must exist.
1803      *
1804      * Emits a {Transfer} event.
1805      */
1806     function _burn(uint256 tokenId) internal virtual {
1807         address owner = ownerOf(tokenId);
1808 
1809         // Clear approvals
1810         _approve(address(0), tokenId);
1811         _holderTokens[owner].remove(tokenId);
1812         _tokenOwners.remove(tokenId);
1813 
1814         emit Transfer(owner, address(0), tokenId);
1815     }
1816 
1817     /**
1818      * @dev Transfers `tokenId` from `from` to `to`.
1819      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1820      *
1821      * Requirements:
1822      *
1823      * - `to` cannot be the zero address.
1824      * - `tokenId` token must be owned by `from`.
1825      * - contract owner must have transfer globally allowed.
1826      *
1827      * Emits a {Transfer} event.
1828      */
1829     function _transfer(address from, address to, uint256 tokenId) private {
1830         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1831         require(to != address(0), "ERC721: transfer to the zero address");
1832         require(_transferable == true, "ERC721 transfer not permitted by contract owner");
1833 
1834         // Clear approvals from the previous owner
1835         _approve(address(0), tokenId);
1836 
1837         _holderTokens[from].remove(tokenId);
1838         _holderTokens[to].add(tokenId);
1839 
1840         _tokenOwners.set(tokenId, to);
1841 
1842         emit Transfer(from, to, tokenId);
1843     }
1844 
1845     /**
1846      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1847      * The call is not executed if the target address is not a contract.
1848      *
1849      * @param from address representing the previous owner of the given token ID
1850      * @param to target address that will receive the tokens
1851      * @param tokenId uint256 ID of the token to be transferred
1852      * @param _data bytes optional data to send along with the call
1853      * @return bool whether the call correctly returned the expected magic value
1854      */
1855     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool)
1856     {
1857         if (!to.isContract()) {
1858             return true;
1859         }
1860         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1861             IERC721Receiver(to).onERC721Received.selector,
1862             _msgSender(),
1863             from,
1864             tokenId,
1865             _data
1866         ), "ERC721: transfer to non ERC721Receiver implementer");
1867         bytes4 retval = abi.decode(returndata, (bytes4));
1868         return (retval == _ERC721_RECEIVED);
1869     }
1870 
1871     function _approve(address to, uint256 tokenId) private {
1872         _tokenApprovals[tokenId] = to;
1873         emit Approval(ownerOf(tokenId), to, tokenId);
1874     }
1875 
1876     function _incrementTokenId() private {
1877         _nextId = _nextId.add(1);
1878     }
1879 }
1880 
1881 
1882 /**
1883  * @dev Most credited to OpenZeppelin ERC721.sol, but with some adjustments.
1884  */
1885 contract T1 is Context, Ownable, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, ERC20Recoverable, ERC721Recoverable {
1886     using SafeMath for uint256;
1887     using Address for address;
1888     using EnumerableSet for EnumerableSet.UintSet;
1889     using EnumerableMap for EnumerableMap.UintToAddressMap;
1890     using Strings for uint256;
1891 
1892     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1893     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1894     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1895 
1896     // Mapping from holder address to their (enumerable) set of owned tokens
1897     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1898 
1899     // Enumerable mapping from token ids to their owners
1900     EnumerableMap.UintToAddressMap private _tokenOwners;
1901 
1902     // Mapping from token ID to approved address
1903     mapping (uint256 => address) private _tokenApprovals;
1904 
1905     // Mapping from owner to operator approvals
1906     mapping (address => mapping (address => bool)) private _operatorApprovals;
1907 
1908     // Token name
1909     string private _name;
1910 
1911     // Token symbol
1912     string private _symbol;
1913 
1914     // ERC721 token contract address serving as "ticket" to flip the bool in additional data
1915     address private _ticketContract;
1916 
1917     // Base URI
1918     string private _baseURI;
1919 
1920     // Price per token. Is chosen and can be changed by contract owner.
1921     uint256 private _tokenPrice;
1922 
1923     struct AdditionalData {
1924         bool isA; // A (true) or B (false)
1925         bool someBool; // may be flipped by token owner if he owns T2; default value in _mint
1926         uint8 power;
1927     }
1928 
1929     // Mapping from token ID to its additional data
1930     mapping (uint256 => AdditionalData) private _additionalData;
1931 
1932     // Counter for token id, and types
1933     uint256 private _nextId = 1;
1934     uint32 private _countA = 0; // count of B is implicit and not needed
1935 
1936     mapping (address => bool) public freeBoolSetters; // addresses which do not need to pay to set the bool variable
1937 
1938     // limits
1939     uint256 public constant MAX_SUPPLY = 7000;
1940     uint32 public constant MAX_A = 1000;
1941     uint32 public constant MAX_B = 6000;
1942 
1943     /*
1944      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1945      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1946      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1947      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1948      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1949      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1950      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1951      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1952      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1953      *
1954      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1955      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1956      */
1957     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1958 
1959     /*
1960      *     bytes4(keccak256('name()')) == 0x06fdde03
1961      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1962      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1963      *
1964      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1965      */
1966     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1967 
1968     /*
1969      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1970      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1971      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1972      *
1973      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1974      */
1975     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1976 
1977     /**
1978      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1979      */
1980     constructor (string memory name, string memory symbol, string memory baseURI, uint256 tokenPrice, address ticketContract) public {
1981         _name = name;
1982         _symbol = symbol;
1983         _baseURI = baseURI;
1984         _tokenPrice = tokenPrice;
1985         _ticketContract = ticketContract;
1986 
1987         // register the supported interfaces to conform to ERC721 via ERC165
1988         _registerInterface(_INTERFACE_ID_ERC721);
1989         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1990         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1991     }
1992 
1993 // public functions:
1994     /**
1995      * @dev See {IERC721-balanceOf}.
1996      */
1997     function balanceOf(address owner) public view override returns (uint256) {
1998         require(owner != address(0), "ERC721: balance query for the zero address");
1999 
2000         return _holderTokens[owner].length();
2001     }
2002 
2003     /**
2004      * @dev See {IERC721-ownerOf}.
2005      */
2006     function ownerOf(uint256 tokenId) public view override returns (address) {
2007         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
2008     }
2009 
2010     /**
2011      * @dev See {IERC721Metadata-name}.
2012      */
2013     function name() external view override returns (string memory) {
2014         return _name;
2015     }
2016 
2017     /**
2018      * @dev See {IERC721Metadata-symbol}.
2019      */
2020     function symbol() external view override returns (string memory) {
2021         return _symbol;
2022     }
2023 
2024     /**
2025      * @dev See {IERC721Metadata-tokenURI}.
2026      */
2027     function tokenURI(uint256 tokenId) external view override returns (string memory) {
2028         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2029 
2030         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
2031         return string(abi.encodePacked(_baseURI, tokenId.toString()));
2032     }
2033 
2034     /**
2035     * @dev Returns the base URI set via {_setBaseURI}. This will be
2036     * automatically added as a prefix in {tokenURI} to each token's URI, or
2037     * to the token ID if no specific URI is set for that token ID.
2038     */
2039     function baseURI() external view returns (string memory) {
2040         return _baseURI;
2041     }
2042 
2043     /**
2044      * @dev Retrieves address of the ticket token contract.
2045      */
2046     function ticketContract() external view returns (address) {
2047         return _ticketContract;
2048     }
2049 
2050     /**
2051      * @dev Price per token for public purchase.
2052      */
2053     function tokenPrice() external view returns (uint256) {
2054         return _tokenPrice;
2055     }
2056 
2057     /**
2058      * @dev Next token id.
2059      */
2060     function nextTokenId() public view returns (uint256) {
2061         return _nextId;
2062     }
2063 
2064     /**
2065      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2066      */
2067     function tokenOfOwnerByIndex(address owner, uint256 index) external view override returns (uint256) {
2068         require(index < balanceOf(owner), "Invalid token index for holder");
2069         return _holderTokens[owner].at(index);
2070     }
2071 
2072     /**
2073      * @dev See {IERC721Enumerable-totalSupply}.
2074      */
2075     function totalSupply() external view override returns (uint256) {
2076         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
2077         return _tokenOwners.length();
2078     }
2079 
2080     /**
2081      * @dev Supply of A tokens.
2082      */
2083     function supplyOfA() external view returns (uint256) {
2084         return _countA;
2085     }
2086 
2087     /**
2088      * @dev See {IERC721Enumerable-tokenByIndex}.
2089      */
2090     function tokenByIndex(uint256 index) external view override returns (uint256) {
2091         require(index < _tokenOwners.length(), "Invalid token index");
2092         (uint256 tokenId, ) = _tokenOwners.at(index);
2093         return tokenId;
2094     }
2095 
2096     /**
2097      * @dev See {IERC721-approve}.
2098      */
2099     function approve(address to, uint256 tokenId) external virtual override {
2100         address owner = ownerOf(tokenId);
2101         require(to != owner, "ERC721: approval to current owner");
2102 
2103         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2104             "ERC721: approve caller is not owner nor approved for all"
2105         );
2106 
2107         _approve(to, tokenId);
2108     }
2109 
2110     /**
2111      * @dev See {IERC721-getApproved}.
2112      */
2113     function getApproved(uint256 tokenId) public view override returns (address) {
2114         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2115 
2116         return _tokenApprovals[tokenId];
2117     }
2118 
2119     /**
2120      * @dev See {IERC721-setApprovalForAll}.
2121      */
2122     function setApprovalForAll(address operator, bool approved) external virtual override {
2123         require(operator != _msgSender(), "ERC721: approve to caller");
2124 
2125         _operatorApprovals[_msgSender()][operator] = approved;
2126         emit ApprovalForAll(_msgSender(), operator, approved);
2127     }
2128 
2129     /**
2130      * @dev See {IERC721-isApprovedForAll}.
2131      */
2132     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
2133         return _operatorApprovals[owner][operator];
2134     }
2135 
2136     /**
2137      * @dev See {IERC721-transferFrom}.
2138      */
2139     function transferFrom(address from, address to, uint256 tokenId) external virtual override {
2140         //solhint-disable-next-line max-line-length
2141         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2142 
2143         _transfer(from, to, tokenId);
2144     }
2145 
2146     /**
2147      * @dev See {IERC721-safeTransferFrom}.
2148      */
2149     function safeTransferFrom(address from, address to, uint256 tokenId) external virtual override {
2150         safeTransferFrom(from, to, tokenId, "");
2151     }
2152 
2153     /**
2154      * @dev See {IERC721-safeTransferFrom}.
2155      */
2156     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2157         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2158         _safeTransfer(from, to, tokenId, _data);
2159     }
2160 
2161     /**
2162      * @dev Buys a token. Needs to be supplied the correct amount of ether.
2163      */
2164     function buyToken() external payable returns (bool)
2165     {
2166         uint256 paidAmount = msg.value;
2167         require(paidAmount == _tokenPrice, "Invalid amount for token purchase");
2168         address to = msg.sender;
2169         uint256 nextToken = nextTokenId();
2170         uint256 remainingTokens = 1 + MAX_SUPPLY - nextToken;
2171         require(remainingTokens > 0, "Maximum supply already reached");
2172 
2173         _holderTokens[to].add(nextToken);
2174         _tokenOwners.set(nextToken, to);
2175 
2176         uint256 remainingA = MAX_A - _countA;
2177         bool a = (uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now, nextToken))) % remainingTokens) < remainingA;
2178         uint8 pow = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now + 1, nextToken))) % (a ? 21 : 79) + (a ? 80 : 1));
2179         _additionalData[nextToken] = AdditionalData(a, false, pow);
2180 
2181         if (a) {
2182             _countA = _countA + 1;
2183         }
2184 
2185         emit Transfer(address(0), to, nextToken);
2186         _nextId = nextToken.add(1);
2187 
2188         payable(owner()).transfer(paidAmount);
2189         return true;
2190     }
2191 
2192     function buy6Tokens() external payable returns (bool)
2193     {
2194         uint256 paidAmount = msg.value;
2195         require(paidAmount == (_tokenPrice * 5 + _tokenPrice / 2), "Invalid amount for token purchase"); // price for 6 tokens is 5.5 times the price for one token
2196         address to = msg.sender;
2197         uint256 nextToken = nextTokenId();
2198         uint256 remainingTokens = 1 + MAX_SUPPLY - nextToken;
2199         require(remainingTokens > 5, "Maximum supply already reached");
2200         uint256 endLoop = nextToken.add(6);
2201 
2202         while (nextToken < endLoop) {
2203             _holderTokens[to].add(nextToken);
2204             _tokenOwners.set(nextToken, to);
2205 
2206             uint256 remainingA = MAX_A - _countA;
2207             bool a = (uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now, nextToken))) % remainingTokens) < remainingA;
2208             uint8 pow = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now + 1, nextToken))) % (a ? 21 : 79) + (a ? 80 : 1));
2209             _additionalData[nextToken] = AdditionalData(a, false, pow);
2210 
2211             if (a) {
2212                 _countA = _countA + 1;
2213             }
2214 
2215             emit Transfer(address(0), to, nextToken);
2216             nextToken = nextToken.add(1);
2217             remainingTokens = remainingTokens.sub(1);
2218         }
2219 
2220         _nextId = _nextId.add(6);
2221 
2222         payable(owner()).transfer(paidAmount);
2223         return true;
2224     }
2225 
2226     /**
2227      * @dev Retrieves if the specified token is of A type.
2228      */
2229     function isA(uint256 tokenId) external view returns (bool) {
2230         require(_exists(tokenId), "Token ID does not exist");
2231         return _additionalData[tokenId].isA;
2232     }
2233 
2234     /**
2235      * @dev Retrieves if the specified token has its someBool attribute set.
2236      */
2237     function someBool(uint256 tokenId) external view returns (bool) {
2238         require(_exists(tokenId), "Token ID does not exist");
2239         return _additionalData[tokenId].someBool;
2240     }
2241 
2242     /**
2243      * @dev Sets someBool for the specified token. Can only be used by the owner of the token (not an approved account).
2244      * Owner needs to also own a ticket token to set the someBool attribute.
2245      */
2246     function setSomeBool(uint256 tokenId, bool newValue) external {
2247         require(_exists(tokenId), "Token ID does not exist");
2248         require(ownerOf(tokenId) == msg.sender, "Only token owner can set attribute");
2249 
2250         if (freeBoolSetters[msg.sender] == false && _additionalData[tokenId].someBool != newValue) {
2251             require(T2(_ticketContract).burnAnyFrom(msg.sender), "Token owner ticket could not be burned");
2252         }
2253 
2254         _additionalData[tokenId].someBool = newValue;
2255     }
2256 
2257     /**
2258      * @dev Retrieves the power value for a specified token.
2259      */
2260     function power(uint256 tokenId) external view returns (uint8) {
2261         require(_exists(tokenId), "Token ID does not exist");
2262         return _additionalData[tokenId].power;
2263     }
2264 
2265 // owner functions:
2266     /**
2267      * @dev Function to set the base URI for all token IDs. It is automatically added as a prefix to the token id in {tokenURI} to retrieve the token URI.
2268      */
2269     function setBaseURI(string calldata baseURI_) external onlyOwner {
2270         _baseURI = baseURI_;
2271     }
2272 
2273     /**
2274      * @dev Sets a new token price.
2275      */
2276     function setTokenPrice(uint256 newPrice) external onlyOwner {
2277         _tokenPrice = newPrice;
2278     }
2279 
2280     function setFreeBoolSetter(address holder, bool setForFree) external onlyOwner {
2281         freeBoolSetters[holder] = setForFree;
2282     }
2283 
2284 // internal functions:
2285     /**
2286      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2287      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2288      *
2289      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2290      *
2291      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2292      * implement alternative mechanisms to perform token transfer, such as signature-based.
2293      *
2294      * Requirements:
2295      *
2296      * - `from` cannot be the zero address.
2297      * - `to` cannot be the zero address.
2298      * - `tokenId` token must exist and be owned by `from`.
2299      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2300      *
2301      * Emits a {Transfer} event.
2302      */
2303     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) private {
2304         _transfer(from, to, tokenId);
2305         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2306     }
2307 
2308     /**
2309      * @dev Returns whether `tokenId` exists.
2310      *
2311      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2312      *
2313      * Tokens start existing when they are minted (`_mint`).
2314      */
2315     function _exists(uint256 tokenId) private view returns (bool) {
2316         return tokenId < _nextId && _tokenOwners.contains(tokenId);
2317     }
2318 
2319     /**
2320      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2321      *
2322      * Requirements:
2323      *
2324      * - `tokenId` must exist.
2325      */
2326     function _isApprovedOrOwner(address spender, uint256 tokenId) private view returns (bool) {
2327         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2328         address owner = ownerOf(tokenId);
2329         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2330     }
2331 
2332     /**
2333      * @dev Transfers `tokenId` from `from` to `to`.
2334      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2335      *
2336      * Requirements:
2337      *
2338      * - `to` cannot be the zero address.
2339      * - `tokenId` token must be owned by `from`.
2340      * - contract owner must have transfer globally allowed.
2341      *
2342      * Emits a {Transfer} event.
2343      */
2344     function _transfer(address from, address to, uint256 tokenId) private {
2345         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2346         require(to != address(0), "ERC721: transfer to the zero address");
2347 
2348         // Clear approvals from the previous owner
2349         _approve(address(0), tokenId);
2350 
2351         _holderTokens[from].remove(tokenId);
2352         _holderTokens[to].add(tokenId);
2353 
2354         _tokenOwners.set(tokenId, to);
2355 
2356         emit Transfer(from, to, tokenId);
2357     }
2358 
2359     /**
2360      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2361      * The call is not executed if the target address is not a contract.
2362      *
2363      * @param from address representing the previous owner of the given token ID
2364      * @param to target address that will receive the tokens
2365      * @param tokenId uint256 ID of the token to be transferred
2366      * @param _data bytes optional data to send along with the call
2367      * @return bool whether the call correctly returned the expected magic value
2368      */
2369     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool)
2370     {
2371         if (!to.isContract()) {
2372             return true;
2373         }
2374         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2375             IERC721Receiver(to).onERC721Received.selector,
2376             _msgSender(),
2377             from,
2378             tokenId,
2379             _data
2380         ), "ERC721: transfer to non ERC721Receiver implementer");
2381         bytes4 retval = abi.decode(returndata, (bytes4));
2382         return (retval == _ERC721_RECEIVED);
2383     }
2384 
2385     function _approve(address to, uint256 tokenId) private {
2386         _tokenApprovals[tokenId] = to;
2387         emit Approval(ownerOf(tokenId), to, tokenId);
2388     }
2389 }
2390 
2391 /**
2392  *
2393  */
2394 contract NFTeGG_Farm_3_Final is Ownable {
2395     using SafeMath for uint256;
2396     using SafeERC20 for IERC20;
2397 
2398     event StakeERC20(address indexed user, address indexed token, uint256 value);
2399     event UnstakeERC20(address indexed user, address indexed token, uint256 value);
2400     event StakeERC721(address indexed user, address indexed token, uint256 tokenid);
2401     event UnstakeERC721(address indexed user, address indexed token, uint256 tokenid);
2402     event StakeT1(address indexed user, address indexed token, uint256 indexed tokenid);
2403     event UnstakeT1(address indexed user, address indexed token, uint256 indexed tokenid);
2404     event Payout(address indexed user, uint256 value);
2405 
2406     uint256 public BLOCKTIME_PENALTY_THRESHOLD = 3600 * 72; // minimum time (in seconds) for staking to receive payout without penalty
2407     address public T3_ADDRESS = address(0xD821E91DB8aED33641ac5D122553cf10de49c8eF); // address of T3 contract (ERC20) used for distributing rewards
2408     
2409     uint256 public repay = 0; 
2410     uint256 public counter = 0;
2411 
2412     mapping (address => uint256) public accumulatedPayouts; // mapping from address to current accumulated payouts; only updated on new stakes on top of an already staked erc20 token and unstakes
2413 
2414     struct StakingDataERC20 {
2415         uint256 tokenStaked;
2416         uint setupBlock;
2417         uint setupTime;
2418     }
2419 
2420     struct StakeFactor {
2421         uint128 multi;
2422         uint128 divi;
2423     }
2424 
2425     address[] public supportedTokensERC20;
2426     mapping (address => StakeFactor) public erc20StakeFactors; // maps ERC20 token address to its stake factors
2427     mapping (address => mapping (address => StakingDataERC20)) public erc20Stakes; // mapping (<user address> => mapping (<token address> => <stake data>))
2428 
2429     struct StakingDataERC721 {
2430         uint setupBlock;
2431         uint setupTime;
2432     }
2433 
2434     address[] public supportedTokensERC721;
2435     mapping (address => StakeFactor) public erc721StakeFactors; // maps ERC721 token address to its stake factors
2436     mapping (address => mapping (uint256 => address)) public stakedERC721Holders; // maps from token address and tokenid to the user address who staked the tokenid
2437     mapping (address => mapping (address => mapping (uint256 => StakingDataERC721))) public erc721Stakes; // maps token address and staker address onto a mapping from tokenid to the struct specifying when the stake was made
2438     mapping (address => mapping (address => uint256[])) public stakedERC721ByUser; // maps token address and user address to an array of staked tokenids
2439     mapping (address => mapping (uint256 => uint256)) public erc721ArrayIndex; // maps token address and a tokenid to the index in the stakedERC721ByUser array of the user that holds it
2440 
2441     struct StakeFactorT1 {
2442         uint64 baseMulti; // base: stake payout per power and block for staked T1
2443         uint64 baseDivi;
2444         uint64 boolMulti; // bool: multiplier if the bool is true
2445         uint64 boolDivi;
2446     }
2447 
2448     address[] public supportedTokensT1;
2449     mapping (address => StakeFactorT1) public t1StakeFactors; // maps ERC721 token address to its stake factors
2450     mapping (address => mapping (uint256 => address)) public stakedT1Holders; // maps from token address and tokenid to the user address who staked the tokenid
2451     mapping (address => mapping (address => mapping (uint256 => StakingDataERC721))) public t1Stakes; // maps token address and staker address onto a mapping from tokenid to the struct specifying when the stake was made
2452     mapping (address => mapping (address => uint256[])) public stakedT1ByUser; // maps token address and user address to an array of staked tokenids
2453     mapping (address => mapping (uint256 => uint256)) public t1ArrayIndex; // maps token address and a tokenid to the index in the stakedT1ByUser array of the user that holds it
2454 
2455     // ctor
2456     constructor () public {
2457     }
2458 
2459     // views
2460     function calcCurrentPayoutERC20(address user, address token) public view returns (uint256) {
2461         uint stakeBlock = erc20Stakes[user][token].setupBlock;
2462         require(stakeBlock != 0, "User has no stake");
2463 
2464         if ((block.timestamp - erc20Stakes[user][token].setupTime) >= BLOCKTIME_PENALTY_THRESHOLD) { // normal payout if minimum time was reached
2465             return (block.number - stakeBlock) * erc20Stakes[user][token].tokenStaked * erc20StakeFactors[token].multi / erc20StakeFactors[token].divi;
2466         } else { // 90% payout if minimum time was not reached
2467             return (block.number - stakeBlock) * erc20Stakes[user][token].tokenStaked * erc20StakeFactors[token].multi / erc20StakeFactors[token].divi * 9 / 10;
2468         }
2469     }
2470 
2471     function calcCurrentPayoutERC721(address token, address user, uint256 tokenid) public view returns (uint256) {
2472         uint stakeBlock = erc721Stakes[token][user][tokenid].setupBlock;
2473         require(stakeBlock != 0, "User did not stake that token");
2474 
2475         if ((block.timestamp - erc721Stakes[token][user][tokenid].setupTime) >= BLOCKTIME_PENALTY_THRESHOLD) { // normal payout if minimum time was reached
2476             return (block.number - stakeBlock) * erc721StakeFactors[token].multi / erc721StakeFactors[token].divi;
2477         } else { // 90% payout if minimum time was not reached
2478             return (block.number - stakeBlock) * erc721StakeFactors[token].multi / erc721StakeFactors[token].divi * 9 / 10;
2479         }
2480     }
2481 
2482     function calcCurrentPayoutT1(address token, address user, uint256 tokenid) public view returns (uint256) {
2483         uint stakeBlock = t1Stakes[token][user][tokenid].setupBlock;
2484         require(stakeBlock != 0, "User did not stake that token");
2485 
2486         uint256 base = (block.number - stakeBlock) * T1(token).power(tokenid) * t1StakeFactors[token].baseMulti / t1StakeFactors[token].baseDivi;
2487 
2488         if (T1(token).someBool(tokenid)) {
2489             base = base * t1StakeFactors[token].boolMulti / t1StakeFactors[token].boolDivi;
2490         }
2491 
2492         if ((block.timestamp - t1Stakes[token][user][tokenid].setupTime) < BLOCKTIME_PENALTY_THRESHOLD) { // 90% payout if minimum time was not reached
2493             base = base * 9 / 10;
2494         }
2495 
2496         return base;
2497     }
2498 
2499     function tokenIdsFromUserT1(address token, address user) external view returns (uint256[] memory) {
2500         require(t1StakeFactors[token].baseDivi != 0, "Token not supported");
2501         return stakedT1ByUser[token][user];
2502     }
2503 
2504     function tokenIdsFromUserERC721(address token, address user) external view returns (uint256[] memory) {
2505         require(erc721StakeFactors[token].divi != 0, "Token not supported");
2506         return stakedERC721ByUser[token][user];
2507     }
2508 
2509     // user stuff
2510     function processAccumulatedPayout() external {
2511         address user = msg.sender;
2512         uint256 payout = accumulatedPayouts[user];
2513         require(payout > 0, "No payout pending");
2514         uint256 reserve = IERC20(T3_ADDRESS).balanceOf(address(this));
2515         require(reserve > 0, "Unable to process any more payouts");
2516 
2517         if (reserve >= payout) {
2518             delete accumulatedPayouts[user];
2519             IERC20(T3_ADDRESS).safeTransfer(user, payout);
2520             Payout(user, payout);
2521         } else {
2522             accumulatedPayouts[user] = payout - reserve;
2523             IERC20(T3_ADDRESS).safeTransfer(user, reserve);
2524             Payout(user, reserve);
2525         }
2526     }
2527 
2528     function stakeERC20(address token, uint256 value) external {
2529         require(erc20StakeFactors[token].multi != 0, "ERC20 token not stakeable");
2530         address user = msg.sender;
2531         uint256 currentStake = erc20Stakes[user][token].tokenStaked;
2532 
2533         if (currentStake > 0) { // there already was a current stake, so the payout since last time has to be accumulated
2534             accumulatedPayouts[user] = accumulatedPayouts[user].add(calcCurrentPayoutERC20(user, token));
2535         }
2536 
2537         IERC20(token).safeTransferFrom(user, address(this), value);
2538         erc20Stakes[user][token].tokenStaked = currentStake.add(value);
2539         erc20Stakes[user][token].setupBlock = block.number;
2540         erc20Stakes[user][token].setupTime = block.timestamp;
2541         StakeERC20(user, token, value);
2542     }
2543 
2544     function unstakeERC20(address token) external {
2545         address user = msg.sender;
2546         require(erc20Stakes[user][token].tokenStaked != 0, "User did not stake any token");
2547 
2548         uint256 payout = accumulatedPayouts[user] + calcCurrentPayoutERC20(user, token);
2549         uint256 currentStake = erc20Stakes[user][token].tokenStaked;
2550         delete erc20Stakes[user][token];
2551         _payout(user, payout);
2552         IERC20(token).safeTransfer(user, currentStake);
2553         UnstakeERC20(user, token, currentStake);
2554     }
2555 
2556     function payoutRewardERC20(address token) external {
2557         address user = msg.sender;
2558         require(erc20Stakes[user][token].tokenStaked != 0, "User did not stake any token");
2559 
2560         uint256 payout = accumulatedPayouts[user] + calcCurrentPayoutERC20(user, token);
2561         erc20Stakes[user][token].setupBlock = block.number;
2562         _payout(user, payout);
2563     }
2564 
2565     function stakeERC721(address token, uint256 tokenid) external {
2566         require(erc721StakeFactors[token].multi != 0, "ERC721 token not stakeable");
2567         address user = msg.sender;
2568         IERC721(token).transferFrom(user, address(this), tokenid);
2569         stakedERC721Holders[token][tokenid] = user;
2570         erc721Stakes[token][user][tokenid] = StakingDataERC721(block.number, block.timestamp);
2571         uint256[] storage nftIds = stakedERC721ByUser[token][msg.sender];
2572         if (nftIds.length == 0) {
2573             nftIds.push(0);
2574             erc721ArrayIndex[token][0] = 0;
2575         }
2576         erc721ArrayIndex[token][tokenid] = nftIds.length;
2577         nftIds.push(tokenid);
2578         StakeERC721(user, token, tokenid);
2579     }
2580 
2581     function unstakeERC721(address token, uint256 tokenid) external {
2582         address user = msg.sender;
2583         require(stakedERC721Holders[token][tokenid] == user, "User did not stake the specified token");
2584         delete stakedERC721Holders[token][tokenid];
2585         uint256 payout = accumulatedPayouts[user] + calcCurrentPayoutERC721(token, user, tokenid);
2586         delete erc721Stakes[token][user][tokenid];
2587         _payout(user, payout);
2588         IERC721(token).transferFrom(address(this), user, tokenid);
2589 
2590         uint256[] memory eggIds = stakedERC721ByUser[token][user];
2591         uint256 nftIndex = erc721ArrayIndex[token][tokenid]; 
2592         uint256 eggArrayLength = eggIds.length-1;
2593         uint256 tailId = eggIds[eggArrayLength];
2594         stakedERC721ByUser[token][user][nftIndex] = tailId;
2595         stakedERC721ByUser[token][user][eggArrayLength] = 0;
2596         stakedERC721ByUser[token][user].pop();
2597         erc721ArrayIndex[token][tailId] = nftIndex;
2598         erc721ArrayIndex[token][tokenid] = 0;
2599 
2600         UnstakeERC721(user, token, tokenid);
2601     }
2602 
2603     function payoutRewardERC721(address token, uint256 tokenid) external {
2604         address user = msg.sender;
2605         require(stakedERC721Holders[token][tokenid] == user, "User did not stake the specified token");
2606         uint256 payout = accumulatedPayouts[user] + calcCurrentPayoutERC721(token, user, tokenid);
2607         erc721Stakes[token][user][tokenid].setupBlock = block.number;
2608         _payout(user, payout);
2609     }
2610 
2611     function stakeT1(address token, uint256 tokenid) external {
2612         require(t1StakeFactors[token].baseDivi != 0, "T1 token not stakeable");
2613         address user = msg.sender;
2614         IERC721(token).transferFrom(user, address(this), tokenid);
2615         stakedT1Holders[token][tokenid] = user;
2616         t1Stakes[token][user][tokenid] = StakingDataERC721(block.number, block.timestamp);
2617         uint256[] storage nftIds = stakedT1ByUser[token][user];
2618         if (nftIds.length == 0) {
2619             nftIds.push(0);
2620             t1ArrayIndex[token][0] = 0;
2621         }
2622         t1ArrayIndex[token][tokenid] = nftIds.length;
2623         nftIds.push(tokenid);
2624         StakeT1(user, token, tokenid);
2625     }
2626 
2627     function unstakeT1(address token, uint256 tokenid) external {
2628         address user = msg.sender;
2629         require(stakedT1Holders[token][tokenid] == user, "User did not stake the specified token");
2630         delete stakedT1Holders[token][tokenid];
2631         uint256 payout = accumulatedPayouts[user] + calcCurrentPayoutT1(token, user, tokenid);
2632         delete t1Stakes[token][user][tokenid];
2633         _payout(user, payout);
2634         T1(token).setSomeBool(tokenid, false);
2635         IERC721(token).transferFrom(address(this), user, tokenid);
2636 
2637         uint256[] memory eggIds = stakedT1ByUser[token][user];
2638         uint256 nftIndex = t1ArrayIndex[token][tokenid]; 
2639         uint256 eggArrayLength = eggIds.length-1;
2640         uint256 tailId = eggIds[eggArrayLength];
2641         stakedT1ByUser[token][user][nftIndex] = tailId;
2642         stakedT1ByUser[token][user][eggArrayLength] = 0;
2643         stakedT1ByUser[token][user].pop();
2644         t1ArrayIndex[token][tailId] = nftIndex;
2645         t1ArrayIndex[token][tokenid] = 0;
2646 
2647         UnstakeT1(user, token, tokenid);
2648     }
2649 
2650     function payoutRewardT1(address token, uint256 tokenid) external {
2651         address user = msg.sender;
2652         require(stakedT1Holders[token][tokenid] == user, "User did not stake the specified token");
2653         uint256 payout = accumulatedPayouts[user] + calcCurrentPayoutT1(token, user, tokenid);
2654         t1Stakes[token][user][tokenid].setupBlock = block.number;
2655         _payout(user, payout);
2656     }
2657     
2658     function shareNFTeGG(address token, uint256 tokenid) external {
2659         require(t1StakeFactors[token].baseDivi != 0, "Token not supported");
2660         address user = msg.sender;
2661         address randomish = address(uint160(uint(keccak256(abi.encodePacked(counter, blockhash(block.number))))));
2662         counter += 1;
2663         if (counter > 100) {
2664         repay = repay / 2;
2665         }
2666         IERC20(T3_ADDRESS).safeTransfer(user, repay);        
2667         IERC721(token).transferFrom(user, address(randomish), tokenid);
2668     }
2669 
2670     // owner stuff
2671     function addERC20ForStaking(address erc20ContractAddress, uint128 stakeFactorMulti, uint128 stakeFactorDivi) onlyOwner external {
2672         require(stakeFactorDivi != 0, "Divi cannot be 0");
2673 
2674         if (erc20StakeFactors[erc20ContractAddress].divi == 0) {
2675             supportedTokensERC20.push(erc20ContractAddress);
2676         }
2677 
2678         erc20StakeFactors[erc20ContractAddress] = StakeFactor(stakeFactorMulti, stakeFactorDivi);
2679     }
2680 
2681     function addERC721ForStaking(address erc721ContractAddress, uint128 stakeFactorMulti, uint128 stakeFactorDivi) onlyOwner external {
2682         require(stakeFactorDivi != 0, "Divi cannot be 0");
2683 
2684         if (erc721StakeFactors[erc721ContractAddress].divi == 0) {
2685             supportedTokensERC721.push(erc721ContractAddress);
2686         }
2687 
2688         erc721StakeFactors[erc721ContractAddress] = StakeFactor(stakeFactorMulti, stakeFactorDivi);
2689     }
2690 
2691     function addT1ForStaking(address t1ContractAddress, uint64 baseStakeFactorMulti, uint64 baseStakeFactorDivi, uint64 boolFactorMulti, uint64 boolFactorDivi) onlyOwner external {
2692         require(baseStakeFactorDivi != 0 && boolFactorDivi != 0, "Divi cannot be 0");
2693 
2694         if (t1StakeFactors[t1ContractAddress].baseDivi == 0) {
2695             supportedTokensT1.push(t1ContractAddress);
2696         }
2697 
2698         t1StakeFactors[t1ContractAddress] = StakeFactorT1(baseStakeFactorMulti, baseStakeFactorDivi, boolFactorMulti, boolFactorDivi);
2699     }
2700     
2701     function set_Penalty(uint256 newPain) external onlyOwner {
2702         BLOCKTIME_PENALTY_THRESHOLD = newPain;
2703     }
2704     
2705     function setSharePayout(uint256 newpayout) external onlyOwner {
2706         repay = newpayout;
2707     }  
2708 
2709 	function setT3(address newT3_ADDRESS) external onlyOwner {
2710         T3_ADDRESS = newT3_ADDRESS;
2711     }
2712 
2713     // internal
2714     function _payout(address user, uint256 payout) internal {
2715         uint256 reserve = IERC20(T3_ADDRESS).balanceOf(address(this));
2716 
2717         if (reserve >= payout) {
2718             delete accumulatedPayouts[user];
2719             IERC20(T3_ADDRESS).safeTransfer(user, payout);
2720             Payout(user, payout);
2721         } else {
2722             accumulatedPayouts[user] = payout - reserve;
2723 
2724             if (reserve > 0) {
2725                 IERC20(T3_ADDRESS).safeTransfer(user, reserve);
2726                 Payout(user, reserve);
2727             }
2728         }
2729     }
2730 }