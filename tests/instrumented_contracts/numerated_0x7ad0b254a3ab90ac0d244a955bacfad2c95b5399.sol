1 //File: @OpenZeppelin/contracts/utils/Address.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { size := extcodesize(account) }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: value }(data);
122         return _verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but performing a static call.
128      *
129      * _Available since v3.3._
130      */
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a delegate call.
152      *
153      * _Available since v3.4._
154      */
155     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
161      * but performing a delegate call.
162      *
163      * _Available since v3.4._
164      */
165     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
166         require(isContract(target), "Address: delegate call to non-contract");
167 
168         // solhint-disable-next-line avoid-low-level-calls
169         (bool success, bytes memory returndata) = target.delegatecall(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
174         if (success) {
175             return returndata;
176         } else {
177             // Look for revert reason and bubble it up if present
178             if (returndata.length > 0) {
179                 // The easiest way to bubble the revert reason is using memory via assembly
180 
181                 // solhint-disable-next-line no-inline-assembly
182                 assembly {
183                     let returndata_size := mload(returndata)
184                     revert(add(32, returndata), returndata_size)
185                 }
186             } else {
187                 revert(errorMessage);
188             }
189         }
190     }
191 }
192 
193 //File: @OpenZeppelin/contracts/utils/Context.sol
194 
195 
196 pragma solidity ^0.8.0;
197 
198 /*
199  * @dev Provides information about the current execution context, including the
200  * sender of the transaction and its data. While these are generally available
201  * via msg.sender and msg.data, they should not be accessed in such a direct
202  * manner, since when dealing with meta-transactions the account sending and
203  * paying for execution may not be the actual sender (as far as an application
204  * is concerned).
205  *
206  * This contract is only required for intermediate, library-like contracts.
207  */
208 abstract contract Context {
209     function _msgSender() internal view virtual returns (address) {
210         return msg.sender;
211     }
212 
213     function _msgData() internal view virtual returns (bytes calldata) {
214         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
215         return msg.data;
216     }
217 }
218 
219 //File: @OpenZeppelin/contracts/mocks/EnumerableMapMock.sol
220 
221 
222 pragma solidity ^0.8.0;
223 
224 
225 /**
226  * @dev Library for managing an enumerable variant of Solidity's
227  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
228  * type.
229  *
230  * Maps have the following properties:
231  *
232  * - Entries are added, removed, and checked for existence in constant time
233  * (O(1)).
234  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
235  *
236  * ```
237  * contract Example {
238  *     // Add the library methods
239  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
240  *
241  *     // Declare a set state variable
242  *     EnumerableMap.UintToAddressMap private myMap;
243  * }
244  * ```
245  *
246  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
247  * supported.
248  */
249 library EnumerableMap {
250     using EnumerableSet for EnumerableSet.Bytes32Set;
251 
252     // To implement this library for multiple types with as little code
253     // repetition as possible, we write it in terms of a generic Map type with
254     // bytes32 keys and values.
255     // The Map implementation uses private functions, and user-facing
256     // implementations (such as Uint256ToAddressMap) are just wrappers around
257     // the underlying Map.
258     // This means that we can only create new EnumerableMaps for types that fit
259     // in bytes32.
260 
261     struct Map {
262         // Storage of keys
263         EnumerableSet.Bytes32Set _keys;
264 
265         mapping (bytes32 => bytes32) _values;
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
276         map._values[key] = value;
277         return map._keys.add(key);
278     }
279 
280     /**
281      * @dev Removes a key-value pair from a map. O(1).
282      *
283      * Returns true if the key was removed from the map, that is if it was present.
284      */
285     function _remove(Map storage map, bytes32 key) private returns (bool) {
286         delete map._values[key];
287         return map._keys.remove(key);
288     }
289 
290     /**
291      * @dev Returns true if the key is in the map. O(1).
292      */
293     function _contains(Map storage map, bytes32 key) private view returns (bool) {
294         return map._keys.contains(key);
295     }
296 
297     /**
298      * @dev Returns the number of key-value pairs in the map. O(1).
299      */
300     function _length(Map storage map) private view returns (uint256) {
301         return map._keys.length();
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
315         bytes32 key = map._keys.at(index);
316         return (key, map._values[key]);
317     }
318 
319     /**
320      * @dev Tries to returns the value associated with `key`.  O(1).
321      * Does not revert if `key` is not in the map.
322      */
323     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
324         bytes32 value = map._values[key];
325         if (value == bytes32(0)) {
326             return (_contains(map, key), bytes32(0));
327         } else {
328             return (true, value);
329         }
330     }
331 
332     /**
333      * @dev Returns the value associated with `key`.  O(1).
334      *
335      * Requirements:
336      *
337      * - `key` must be in the map.
338      */
339     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
340         bytes32 value = map._values[key];
341         require(value != 0 || _contains(map, key), "EnumerableMap: nonexistent key");
342         return value;
343     }
344 
345     /**
346      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
347      *
348      * CAUTION: This function is deprecated because it requires allocating memory for the error
349      * message unnecessarily. For custom revert reasons use {_tryGet}.
350      */
351     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
352         bytes32 value = map._values[key];
353         require(value != 0 || _contains(map, key), errorMessage);
354         return value;
355     }
356 
357     // UintToAddressMap
358 
359     struct UintToAddressMap {
360         Map _inner;
361     }
362 
363     /**
364      * @dev Adds a key-value pair to a map, or updates the value for an existing
365      * key. O(1).
366      *
367      * Returns true if the key was added to the map, that is if it was not
368      * already present.
369      */
370     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
371         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
372     }
373 
374     /**
375      * @dev Removes a value from a set. O(1).
376      *
377      * Returns true if the key was removed from the map, that is if it was present.
378      */
379     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
380         return _remove(map._inner, bytes32(key));
381     }
382 
383     /**
384      * @dev Returns true if the key is in the map. O(1).
385      */
386     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
387         return _contains(map._inner, bytes32(key));
388     }
389 
390     /**
391      * @dev Returns the number of elements in the map. O(1).
392      */
393     function length(UintToAddressMap storage map) internal view returns (uint256) {
394         return _length(map._inner);
395     }
396 
397    /**
398     * @dev Returns the element stored at position `index` in the set. O(1).
399     * Note that there are no guarantees on the ordering of values inside the
400     * array, and it may change when more values are added or removed.
401     *
402     * Requirements:
403     *
404     * - `index` must be strictly less than {length}.
405     */
406     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
407         (bytes32 key, bytes32 value) = _at(map._inner, index);
408         return (uint256(key), address(uint160(uint256(value))));
409     }
410 
411     /**
412      * @dev Tries to returns the value associated with `key`.  O(1).
413      * Does not revert if `key` is not in the map.
414      *
415      * _Available since v3.4._
416      */
417     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
418         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
419         return (success, address(uint160(uint256(value))));
420     }
421 
422     /**
423      * @dev Returns the value associated with `key`.  O(1).
424      *
425      * Requirements:
426      *
427      * - `key` must be in the map.
428      */
429     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
430         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
431     }
432 
433     /**
434      * @dev Same as {get}, with a custom error message when `key` is not in the map.
435      *
436      * CAUTION: This function is deprecated because it requires allocating memory for the error
437      * message unnecessarily. For custom revert reasons use {tryGet}.
438      */
439     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
440         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
441     }
442 }
443 
444 //File: @OpenZeppelin/contracts/utils/structs/EnumerableSet.sol
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Library for managing
451  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
452  * types.
453  *
454  * Sets have the following properties:
455  *
456  * - Elements are added, removed, and checked for existence in constant time
457  * (O(1)).
458  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
459  *
460  * ```
461  * contract Example {
462  *     // Add the library methods
463  *     using EnumerableSet for EnumerableSet.AddressSet;
464  *
465  *     // Declare a set state variable
466  *     EnumerableSet.AddressSet private mySet;
467  * }
468  * ```
469  *
470  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
471  * and `uint256` (`UintSet`) are supported.
472  */
473 library EnumerableSet {
474     // To implement this library for multiple types with as little code
475     // repetition as possible, we write it in terms of a generic Set type with
476     // bytes32 values.
477     // The Set implementation uses private functions, and user-facing
478     // implementations (such as AddressSet) are just wrappers around the
479     // underlying Set.
480     // This means that we can only create new EnumerableSets for types that fit
481     // in bytes32.
482 
483     struct Set {
484         // Storage of set values
485         bytes32[] _values;
486 
487         // Position of the value in the `values` array, plus 1 because index 0
488         // means a value is not in the set.
489         mapping (bytes32 => uint256) _indexes;
490     }
491 
492     /**
493      * @dev Add a value to a set. O(1).
494      *
495      * Returns true if the value was added to the set, that is if it was not
496      * already present.
497      */
498     function _add(Set storage set, bytes32 value) private returns (bool) {
499         if (!_contains(set, value)) {
500             set._values.push(value);
501             // The value is stored at length-1, but we add 1 to all indexes
502             // and use 0 as a sentinel value
503             set._indexes[value] = set._values.length;
504             return true;
505         } else {
506             return false;
507         }
508     }
509 
510     /**
511      * @dev Removes a value from a set. O(1).
512      *
513      * Returns true if the value was removed from the set, that is if it was
514      * present.
515      */
516     function _remove(Set storage set, bytes32 value) private returns (bool) {
517         // We read and store the value's index to prevent multiple reads from the same storage slot
518         uint256 valueIndex = set._indexes[value];
519 
520         if (valueIndex != 0) { // Equivalent to contains(set, value)
521             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
522             // the array, and then remove the last element (sometimes called as 'swap and pop').
523             // This modifies the order of the array, as noted in {at}.
524 
525             uint256 toDeleteIndex = valueIndex - 1;
526             uint256 lastIndex = set._values.length - 1;
527 
528             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
529             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
530 
531             bytes32 lastvalue = set._values[lastIndex];
532 
533             // Move the last value to the index where the value to delete is
534             set._values[toDeleteIndex] = lastvalue;
535             // Update the index for the moved value
536             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
537 
538             // Delete the slot where the moved value was stored
539             set._values.pop();
540 
541             // Delete the index for the deleted slot
542             delete set._indexes[value];
543 
544             return true;
545         } else {
546             return false;
547         }
548     }
549 
550     /**
551      * @dev Returns true if the value is in the set. O(1).
552      */
553     function _contains(Set storage set, bytes32 value) private view returns (bool) {
554         return set._indexes[value] != 0;
555     }
556 
557     /**
558      * @dev Returns the number of values on the set. O(1).
559      */
560     function _length(Set storage set) private view returns (uint256) {
561         return set._values.length;
562     }
563 
564    /**
565     * @dev Returns the value stored at position `index` in the set. O(1).
566     *
567     * Note that there are no guarantees on the ordering of values inside the
568     * array, and it may change when more values are added or removed.
569     *
570     * Requirements:
571     *
572     * - `index` must be strictly less than {length}.
573     */
574     function _at(Set storage set, uint256 index) private view returns (bytes32) {
575         require(set._values.length > index, "EnumerableSet: index out of bounds");
576         return set._values[index];
577     }
578 
579     // Bytes32Set
580 
581     struct Bytes32Set {
582         Set _inner;
583     }
584 
585     /**
586      * @dev Add a value to a set. O(1).
587      *
588      * Returns true if the value was added to the set, that is if it was not
589      * already present.
590      */
591     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
592         return _add(set._inner, value);
593     }
594 
595     /**
596      * @dev Removes a value from a set. O(1).
597      *
598      * Returns true if the value was removed from the set, that is if it was
599      * present.
600      */
601     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
602         return _remove(set._inner, value);
603     }
604 
605     /**
606      * @dev Returns true if the value is in the set. O(1).
607      */
608     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
609         return _contains(set._inner, value);
610     }
611 
612     /**
613      * @dev Returns the number of values in the set. O(1).
614      */
615     function length(Bytes32Set storage set) internal view returns (uint256) {
616         return _length(set._inner);
617     }
618 
619    /**
620     * @dev Returns the value stored at position `index` in the set. O(1).
621     *
622     * Note that there are no guarantees on the ordering of values inside the
623     * array, and it may change when more values are added or removed.
624     *
625     * Requirements:
626     *
627     * - `index` must be strictly less than {length}.
628     */
629     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
630         return _at(set._inner, index);
631     }
632 
633     // AddressSet
634 
635     struct AddressSet {
636         Set _inner;
637     }
638 
639     /**
640      * @dev Add a value to a set. O(1).
641      *
642      * Returns true if the value was added to the set, that is if it was not
643      * already present.
644      */
645     function add(AddressSet storage set, address value) internal returns (bool) {
646         return _add(set._inner, bytes32(uint256(uint160(value))));
647     }
648 
649     /**
650      * @dev Removes a value from a set. O(1).
651      *
652      * Returns true if the value was removed from the set, that is if it was
653      * present.
654      */
655     function remove(AddressSet storage set, address value) internal returns (bool) {
656         return _remove(set._inner, bytes32(uint256(uint160(value))));
657     }
658 
659     /**
660      * @dev Returns true if the value is in the set. O(1).
661      */
662     function contains(AddressSet storage set, address value) internal view returns (bool) {
663         return _contains(set._inner, bytes32(uint256(uint160(value))));
664     }
665 
666     /**
667      * @dev Returns the number of values in the set. O(1).
668      */
669     function length(AddressSet storage set) internal view returns (uint256) {
670         return _length(set._inner);
671     }
672 
673    /**
674     * @dev Returns the value stored at position `index` in the set. O(1).
675     *
676     * Note that there are no guarantees on the ordering of values inside the
677     * array, and it may change when more values are added or removed.
678     *
679     * Requirements:
680     *
681     * - `index` must be strictly less than {length}.
682     */
683     function at(AddressSet storage set, uint256 index) internal view returns (address) {
684         return address(uint160(uint256(_at(set._inner, index))));
685     }
686 
687 
688     // UintSet
689 
690     struct UintSet {
691         Set _inner;
692     }
693 
694     /**
695      * @dev Add a value to a set. O(1).
696      *
697      * Returns true if the value was added to the set, that is if it was not
698      * already present.
699      */
700     function add(UintSet storage set, uint256 value) internal returns (bool) {
701         return _add(set._inner, bytes32(value));
702     }
703 
704     /**
705      * @dev Removes a value from a set. O(1).
706      *
707      * Returns true if the value was removed from the set, that is if it was
708      * present.
709      */
710     function remove(UintSet storage set, uint256 value) internal returns (bool) {
711         return _remove(set._inner, bytes32(value));
712     }
713 
714     /**
715      * @dev Returns true if the value is in the set. O(1).
716      */
717     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
718         return _contains(set._inner, bytes32(value));
719     }
720 
721     /**
722      * @dev Returns the number of values on the set. O(1).
723      */
724     function length(UintSet storage set) internal view returns (uint256) {
725         return _length(set._inner);
726     }
727 
728    /**
729     * @dev Returns the value stored at position `index` in the set. O(1).
730     *
731     * Note that there are no guarantees on the ordering of values inside the
732     * array, and it may change when more values are added or removed.
733     *
734     * Requirements:
735     *
736     * - `index` must be strictly less than {length}.
737     */
738     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
739         return uint256(_at(set._inner, index));
740     }
741 }
742 
743 
744 //File: @OpenZeppelin/contracts/utils/introspection/IERC165.sol
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @dev Interface of the ERC165 standard, as defined in the
750  * https://eips.ethereum.org/EIPS/eip-165[EIP].
751  *
752  * Implementers can declare support of contract interfaces, which can then be
753  * queried by others ({ERC165Checker}).
754  *
755  * For an implementation, see {ERC165}.
756  */
757 interface IERC165 {
758     /**
759      * @dev Returns true if this contract implements the interface defined by
760      * `interfaceId`. See the corresponding
761      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
762      * to learn more about how these ids are created.
763      *
764      * This function call must use less than 30 000 gas.
765      */
766     function supportsInterface(bytes4 interfaceId) external view returns (bool);
767 }
768 
769 //File @OpenZeppelin/contracts/introspection/ERC165.sol
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @dev Implementation of the {IERC165} interface.
776  *
777  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
778  * for the additional interface id that will be supported. For example:
779  *
780  * ```solidity
781  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
783  * }
784  * ```
785  *
786  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
787  */
788 abstract contract ERC165 is IERC165 {
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
793         return interfaceId == type(IERC165).interfaceId;
794     }
795 }
796 
797 
798 //File: @OpenZeppelin/contracts/token/ERC721/IERC721.sol
799 
800 pragma solidity ^0.8.0;
801 
802 
803 /**
804  * @dev Required interface of an ERC721 compliant contract.
805  */
806 interface IERC721 is IERC165 {
807     /**
808      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
809      */
810     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
811 
812     /**
813      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
814      */
815     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
816 
817     /**
818      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
819      */
820     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
821 
822     /**
823      * @dev Returns the number of tokens in ``owner``'s account.
824      */
825     function balanceOf(address owner) external view returns (uint256 balance);
826 
827     /**
828      * @dev Returns the owner of the `tokenId` token.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must exist.
833      */
834     function ownerOf(uint256 tokenId) external view returns (address owner);
835 
836     /**
837      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
838      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
839      *
840      * Requirements:
841      *
842      * - `from` cannot be the zero address.
843      * - `to` cannot be the zero address.
844      * - `tokenId` token must exist and be owned by `from`.
845      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
846      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
847      *
848      * Emits a {Transfer} event.
849      */
850     function safeTransferFrom(address from, address to, uint256 tokenId) external;
851 
852     /**
853      * @dev Transfers `tokenId` token from `from` to `to`.
854      *
855      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must be owned by `from`.
862      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
863      *
864      * Emits a {Transfer} event.
865      */
866     function transferFrom(address from, address to, uint256 tokenId) external;
867 
868     /**
869      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
870      * The approval is cleared when the token is transferred.
871      *
872      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
873      *
874      * Requirements:
875      *
876      * - The caller must own the token or be an approved operator.
877      * - `tokenId` must exist.
878      *
879      * Emits an {Approval} event.
880      */
881     function approve(address to, uint256 tokenId) external;
882 
883     /**
884      * @dev Returns the account approved for `tokenId` token.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must exist.
889      */
890     function getApproved(uint256 tokenId) external view returns (address operator);
891 
892     /**
893      * @dev Approve or remove `operator` as an operator for the caller.
894      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
895      *
896      * Requirements:
897      *
898      * - The `operator` cannot be the caller.
899      *
900      * Emits an {ApprovalForAll} event.
901      */
902     function setApprovalForAll(address operator, bool _approved) external;
903 
904     /**
905      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
906      *
907      * See {setApprovalForAll}
908      */
909     function isApprovedForAll(address owner, address operator) external view returns (bool);
910 
911     /**
912       * @dev Safely transfers `tokenId` token from `from` to `to`.
913       *
914       * Requirements:
915       *
916       * - `from` cannot be the zero address.
917       * - `to` cannot be the zero address.
918       * - `tokenId` token must exist and be owned by `from`.
919       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
920       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
921       *
922       * Emits a {Transfer} event.
923       */
924     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
925 }
926 
927 //File: @OpenZeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
928 
929 pragma solidity ^0.8.0;
930 
931 
932 /**
933  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
934  * @dev See https://eips.ethereum.org/EIPS/eip-721
935  */
936 interface IERC721Metadata is IERC721 {
937 
938     /**
939      * @dev Returns the token collection name.
940      */
941     function name() external view returns (string memory);
942 
943     /**
944      * @dev Returns the token collection symbol.
945      */
946     function symbol() external view returns (string memory);
947 
948     /**
949      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
950      */
951     function tokenURI(uint256 tokenId) external view returns (string memory);
952 }
953 
954 
955 
956 //File: @OpenZeppelin/contracts/token/ERC721/ERC721.sol
957 
958 
959 pragma solidity ^0.8.0;
960 
961 /**
962  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
963  * the Metadata extension, but not including the Enumerable extension, which is available separately as
964  * {ERC721Enumerable}.
965  */
966 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
967     using Address for address;
968     using Strings for uint256;
969 
970     // Token name
971     string private _name;
972 
973     // Token symbol
974     string private _symbol;
975 
976     // Mapping from token ID to owner address
977     mapping (uint256 => address) private _owners;
978 
979     // Mapping owner address to token count
980     mapping (address => uint256) private _balances;
981 
982     // Mapping from token ID to approved address
983     mapping (uint256 => address) private _tokenApprovals;
984 
985     // Mapping from owner to operator approvals
986     mapping (address => mapping (address => bool)) private _operatorApprovals;
987 
988     /**
989      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
990      */
991     constructor (string memory name_, string memory symbol_) {
992         _name = name_;
993         _symbol = symbol_;
994     }
995 
996     /**
997      * @dev See {IERC165-supportsInterface}.
998      */
999     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1000         return interfaceId == type(IERC721).interfaceId
1001             || interfaceId == type(IERC721Metadata).interfaceId
1002             || super.supportsInterface(interfaceId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-balanceOf}.
1007      */
1008     function balanceOf(address owner) public view virtual override returns (uint256) {
1009         require(owner != address(0), "ERC721: balance query for the zero address");
1010         return _balances[owner];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-ownerOf}.
1015      */
1016     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1017         address owner = _owners[tokenId];
1018         require(owner != address(0), "ERC721: owner query for nonexistent token");
1019         return owner;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-name}.
1024      */
1025     function name() public view virtual override returns (string memory) {
1026         return _name;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-symbol}.
1031      */
1032     function symbol() public view virtual override returns (string memory) {
1033         return _symbol;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-tokenURI}.
1038      */
1039     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1040         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1041 
1042         string memory baseURI = _baseURI();
1043         return bytes(baseURI).length > 0
1044             ? string(abi.encodePacked(baseURI, tokenId.toString()))
1045             : '';
1046     }
1047 
1048     /**
1049      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
1050      * in child contracts.
1051      */
1052     function _baseURI() internal view virtual returns (string memory) {
1053         return "";
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-approve}.
1058      */
1059     function approve(address to, uint256 tokenId) public virtual override {
1060         address owner = ERC721.ownerOf(tokenId);
1061         require(to != owner, "ERC721: approval to current owner");
1062 
1063         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1064             "ERC721: approve caller is not owner nor approved for all"
1065         );
1066 
1067         _approve(to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-getApproved}.
1072      */
1073     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1074         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1075 
1076         return _tokenApprovals[tokenId];
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-setApprovalForAll}.
1081      */
1082     function setApprovalForAll(address operator, bool approved) public virtual override {
1083         require(operator != _msgSender(), "ERC721: approve to caller");
1084 
1085         _operatorApprovals[_msgSender()][operator] = approved;
1086         emit ApprovalForAll(_msgSender(), operator, approved);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-isApprovedForAll}.
1091      */
1092     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1093         return _operatorApprovals[owner][operator];
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-transferFrom}.
1098      */
1099     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1100         //solhint-disable-next-line max-line-length
1101         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1102 
1103         _transfer(from, to, tokenId);
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-safeTransferFrom}.
1108      */
1109     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1110         safeTransferFrom(from, to, tokenId, "");
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-safeTransferFrom}.
1115      */
1116     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1117         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1118         _safeTransfer(from, to, tokenId, _data);
1119     }
1120 
1121     /**
1122      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1123      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1124      *
1125      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1126      *
1127      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1128      * implement alternative mechanisms to perform token transfer, such as signature-based.
1129      *
1130      * Requirements:
1131      *
1132      * - `from` cannot be the zero address.
1133      * - `to` cannot be the zero address.
1134      * - `tokenId` token must exist and be owned by `from`.
1135      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1140         _transfer(from, to, tokenId);
1141         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1142     }
1143 
1144     /**
1145      * @dev Returns whether `tokenId` exists.
1146      *
1147      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1148      *
1149      * Tokens start existing when they are minted (`_mint`),
1150      * and stop existing when they are burned (`_burn`).
1151      */
1152     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1153         return _owners[tokenId] != address(0);
1154     }
1155 
1156     /**
1157      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      */
1163     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1164         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1165         address owner = ERC721.ownerOf(tokenId);
1166         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1167     }
1168 
1169     /**
1170      * @dev Safely mints `tokenId` and transfers it to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must not exist.
1175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _safeMint(address to, uint256 tokenId) internal virtual {
1180         _safeMint(to, tokenId, "");
1181     }
1182 
1183     /**
1184      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1185      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1186      */
1187     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1188         _mint(to, tokenId);
1189         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1190     }
1191 
1192     /**
1193      * @dev Mints `tokenId` and transfers it to `to`.
1194      *
1195      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must not exist.
1200      * - `to` cannot be the zero address.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _mint(address to, uint256 tokenId) internal virtual {
1205         require(to != address(0), "ERC721: mint to the zero address");
1206         require(!_exists(tokenId), "ERC721: token already minted");
1207 
1208         _beforeTokenTransfer(address(0), to, tokenId);
1209 
1210         _balances[to] += 1;
1211         _owners[tokenId] = to;
1212 
1213         emit Transfer(address(0), to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev Destroys `tokenId`.
1218      * The approval is cleared when the token is burned.
1219      *
1220      * Requirements:
1221      *
1222      * - `tokenId` must exist.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _burn(uint256 tokenId) internal virtual {
1227         address owner = ERC721.ownerOf(tokenId);
1228 
1229         _beforeTokenTransfer(owner, address(0), tokenId);
1230 
1231         // Clear approvals
1232         _approve(address(0), tokenId);
1233 
1234         _balances[owner] -= 1;
1235         delete _owners[tokenId];
1236 
1237         emit Transfer(owner, address(0), tokenId);
1238     }
1239 
1240     /**
1241      * @dev Transfers `tokenId` from `from` to `to`.
1242      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1243      *
1244      * Requirements:
1245      *
1246      * - `to` cannot be the zero address.
1247      * - `tokenId` token must be owned by `from`.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1252         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1253         require(to != address(0), "ERC721: transfer to the zero address");
1254 
1255         _beforeTokenTransfer(from, to, tokenId);
1256 
1257         // Clear approvals from the previous owner
1258         _approve(address(0), tokenId);
1259 
1260         _balances[from] -= 1;
1261         _balances[to] += 1;
1262         _owners[tokenId] = to;
1263 
1264         emit Transfer(from, to, tokenId);
1265     }
1266 
1267     /**
1268      * @dev Approve `to` to operate on `tokenId`
1269      *
1270      * Emits a {Approval} event.
1271      */
1272     function _approve(address to, uint256 tokenId) internal virtual {
1273         _tokenApprovals[tokenId] = to;
1274         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1279      * The call is not executed if the target address is not a contract.
1280      *
1281      * @param from address representing the previous owner of the given token ID
1282      * @param to target address that will receive the tokens
1283      * @param tokenId uint256 ID of the token to be transferred
1284      * @param _data bytes optional data to send along with the call
1285      * @return bool whether the call correctly returned the expected magic value
1286      */
1287     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1288         private returns (bool)
1289     {
1290         if (to.isContract()) {
1291             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1292                 return retval == IERC721Receiver(to).onERC721Received.selector;
1293             } catch (bytes memory reason) {
1294                 if (reason.length == 0) {
1295                     revert("ERC721: transfer to non ERC721Receiver implementer");
1296                 } else {
1297                     // solhint-disable-next-line no-inline-assembly
1298                     assembly {
1299                         revert(add(32, reason), mload(reason))
1300                     }
1301                 }
1302             }
1303         } else {
1304             return true;
1305         }
1306     }
1307 
1308     /**
1309      * @dev Hook that is called before any token transfer. This includes minting
1310      * and burning.
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` will be minted for `to`.
1317      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1318      * - `from` cannot be the zero address.
1319      * - `to` cannot be the zero address.
1320      *
1321      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1322      */
1323     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1324 }
1325 
1326 
1327 //File: @OpenZeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 
1332 /**
1333  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1334  * @dev See https://eips.ethereum.org/EIPS/eip-721
1335  */
1336 interface IERC721Enumerable is IERC721 {
1337 
1338     /**
1339      * @dev Returns the total amount of tokens stored by the contract.
1340      */
1341     function totalSupply() external view returns (uint256);
1342 
1343     /**
1344      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1345      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1346      */
1347     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1348 
1349     /**
1350      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1351      * Use along with {totalSupply} to enumerate all tokens.
1352      */
1353     function tokenByIndex(uint256 index) external view returns (uint256);
1354 }
1355 
1356 
1357 //File: @OpenZeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1358 
1359 pragma solidity ^0.8.0;
1360 
1361 /**
1362  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1363  * enumerability of all the token ids in the contract as well as all token ids owned by each
1364  * account.
1365  */
1366 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1367     // Mapping from owner to list of owned token IDs
1368     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1369 
1370     // Mapping from token ID to index of the owner tokens list
1371     mapping(uint256 => uint256) private _ownedTokensIndex;
1372 
1373     // Array with all token ids, used for enumeration
1374     uint256[] private _allTokens;
1375 
1376     // Mapping from token id to position in the allTokens array
1377     mapping(uint256 => uint256) private _allTokensIndex;
1378 
1379     /**
1380      * @dev See {IERC165-supportsInterface}.
1381      */
1382     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1383         return interfaceId == type(IERC721Enumerable).interfaceId
1384             || super.supportsInterface(interfaceId);
1385     }
1386 
1387     /**
1388      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1389      */
1390     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1391         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1392         return _ownedTokens[owner][index];
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Enumerable-totalSupply}.
1397      */
1398     function totalSupply() public view virtual override returns (uint256) {
1399         return _allTokens.length;
1400     }
1401 
1402     /**
1403      * @dev See {IERC721Enumerable-tokenByIndex}.
1404      */
1405     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1406         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1407         return _allTokens[index];
1408     }
1409 
1410     /**
1411      * @dev Hook that is called before any token transfer. This includes minting
1412      * and burning.
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` will be minted for `to`.
1419      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1420      * - `from` cannot be the zero address.
1421      * - `to` cannot be the zero address.
1422      *
1423      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1424      */
1425     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1426         super._beforeTokenTransfer(from, to, tokenId);
1427 
1428         if (from == address(0)) {
1429             _addTokenToAllTokensEnumeration(tokenId);
1430         } else if (from != to) {
1431             _removeTokenFromOwnerEnumeration(from, tokenId);
1432         }
1433         if (to == address(0)) {
1434             _removeTokenFromAllTokensEnumeration(tokenId);
1435         } else if (to != from) {
1436             _addTokenToOwnerEnumeration(to, tokenId);
1437         }
1438     }
1439 
1440     /**
1441      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1442      * @param to address representing the new owner of the given token ID
1443      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1444      */
1445     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1446         uint256 length = ERC721.balanceOf(to);
1447         _ownedTokens[to][length] = tokenId;
1448         _ownedTokensIndex[tokenId] = length;
1449     }
1450 
1451     /**
1452      * @dev Private function to add a token to this extension's token tracking data structures.
1453      * @param tokenId uint256 ID of the token to be added to the tokens list
1454      */
1455     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1456         _allTokensIndex[tokenId] = _allTokens.length;
1457         _allTokens.push(tokenId);
1458     }
1459 
1460     /**
1461      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1462      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1463      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1464      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1465      * @param from address representing the previous owner of the given token ID
1466      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1467      */
1468     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1469         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1470         // then delete the last slot (swap and pop).
1471 
1472         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1473         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1474 
1475         // When the token to delete is the last token, the swap operation is unnecessary
1476         if (tokenIndex != lastTokenIndex) {
1477             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1478 
1479             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1480             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1481         }
1482 
1483         // This also deletes the contents at the last position of the array
1484         delete _ownedTokensIndex[tokenId];
1485         delete _ownedTokens[from][lastTokenIndex];
1486     }
1487 
1488     /**
1489      * @dev Private function to remove a token from this extension's token tracking data structures.
1490      * This has O(1) time complexity, but alters the order of the _allTokens array.
1491      * @param tokenId uint256 ID of the token to be removed from the tokens list
1492      */
1493     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1494         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1495         // then delete the last slot (swap and pop).
1496 
1497         uint256 lastTokenIndex = _allTokens.length - 1;
1498         uint256 tokenIndex = _allTokensIndex[tokenId];
1499 
1500         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1501         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1502         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1503         uint256 lastTokenId = _allTokens[lastTokenIndex];
1504 
1505         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1506         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1507 
1508         // This also deletes the contents at the last position of the array
1509         delete _allTokensIndex[tokenId];
1510         _allTokens.pop();
1511     }
1512 }
1513 
1514 
1515 
1516 //File: @OpenZeppelin/contracts/token/ERC721/IERC721Receiver.sol
1517 
1518 pragma solidity ^0.8.0;
1519 
1520 /**
1521  * @title ERC721 token receiver interface
1522  * @dev Interface for any contract that wants to support safeTransfers
1523  * from ERC721 asset contracts.
1524  */
1525 interface IERC721Receiver {
1526     /**
1527      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1528      * by `operator` from `from`, this function is called.
1529      *
1530      * It must return its Solidity selector to confirm the token transfer.
1531      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1532      *
1533      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1534      */
1535     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1536 }
1537 
1538 
1539 //File: @OpenZeppelin/contracts/access/Ownable.sol
1540 
1541 pragma solidity ^0.8.0;
1542 
1543 /**
1544  * @dev Contract module which provides a basic access control mechanism, where
1545  * there is an account (an owner) that can be granted exclusive access to
1546  * specific functions.
1547  *
1548  * By default, the owner account will be the one that deploys the contract. This
1549  * can later be changed with {transferOwnership}.
1550  *
1551  * This module is used through inheritance. It will make available the modifier
1552  * `onlyOwner`, which can be applied to your functions to restrict their use to
1553  * the owner.
1554  */
1555 abstract contract Ownable is Context {
1556     address private _owner;
1557 
1558     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1559 
1560     /**
1561      * @dev Initializes the contract setting the deployer as the initial owner.
1562      */
1563     constructor () {
1564         address msgSender = _msgSender();
1565         _owner = msgSender;
1566         emit OwnershipTransferred(address(0), msgSender);
1567     }
1568 
1569     /**
1570      * @dev Returns the address of the current owner.
1571      */
1572     function owner() public view virtual returns (address) {
1573         return _owner;
1574     }
1575 
1576     /**
1577      * @dev Throws if called by any account other than the owner.
1578      */
1579     modifier onlyOwner() {
1580         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1581         _;
1582     }
1583 
1584     /**
1585      * @dev Leaves the contract without owner. It will not be possible to call
1586      * `onlyOwner` functions anymore. Can only be called by the current owner.
1587      *
1588      * NOTE: Renouncing ownership will leave the contract without an owner,
1589      * thereby removing any functionality that is only available to the owner.
1590      */
1591     function renounceOwnership() public virtual onlyOwner {
1592         emit OwnershipTransferred(_owner, address(0));
1593         _owner = address(0);
1594     }
1595 
1596     /**
1597      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1598      * Can only be called by the current owner.
1599      */
1600     function transferOwnership(address newOwner) public virtual onlyOwner {
1601         require(newOwner != address(0), "Ownable: new owner is the zero address");
1602         emit OwnershipTransferred(_owner, newOwner);
1603         _owner = newOwner;
1604     }
1605 }
1606 
1607 //File: @OpenZeppelin/contracts/utils/math/SafeMath.sol
1608 
1609 pragma solidity ^0.8.0;
1610 
1611 // CAUTION
1612 // This version of SafeMath should only be used with Solidity 0.8 or later,
1613 // because it relies on the compiler's built in overflow checks.
1614 
1615 /**
1616  * @dev Wrappers over Solidity's arithmetic operations.
1617  *
1618  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1619  * now has built in overflow checking.
1620  */
1621 library SafeMath {
1622     /**
1623      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1624      *
1625      * _Available since v3.4._
1626      */
1627     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1628         unchecked {
1629             uint256 c = a + b;
1630             if (c < a) return (false, 0);
1631             return (true, c);
1632         }
1633     }
1634 
1635     /**
1636      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1637      *
1638      * _Available since v3.4._
1639      */
1640     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1641         unchecked {
1642             if (b > a) return (false, 0);
1643             return (true, a - b);
1644         }
1645     }
1646 
1647     /**
1648      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1649      *
1650      * _Available since v3.4._
1651      */
1652     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1653         unchecked {
1654             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1655             // benefit is lost if 'b' is also tested.
1656             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1657             if (a == 0) return (true, 0);
1658             uint256 c = a * b;
1659             if (c / a != b) return (false, 0);
1660             return (true, c);
1661         }
1662     }
1663 
1664     /**
1665      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1666      *
1667      * _Available since v3.4._
1668      */
1669     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1670         unchecked {
1671             if (b == 0) return (false, 0);
1672             return (true, a / b);
1673         }
1674     }
1675 
1676     /**
1677      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1678      *
1679      * _Available since v3.4._
1680      */
1681     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1682         unchecked {
1683             if (b == 0) return (false, 0);
1684             return (true, a % b);
1685         }
1686     }
1687 
1688     /**
1689      * @dev Returns the addition of two unsigned integers, reverting on
1690      * overflow.
1691      *
1692      * Counterpart to Solidity's `+` operator.
1693      *
1694      * Requirements:
1695      *
1696      * - Addition cannot overflow.
1697      */
1698     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1699         return a + b;
1700     }
1701 
1702     /**
1703      * @dev Returns the subtraction of two unsigned integers, reverting on
1704      * overflow (when the result is negative).
1705      *
1706      * Counterpart to Solidity's `-` operator.
1707      *
1708      * Requirements:
1709      *
1710      * - Subtraction cannot overflow.
1711      */
1712     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1713         return a - b;
1714     }
1715 
1716     /**
1717      * @dev Returns the multiplication of two unsigned integers, reverting on
1718      * overflow.
1719      *
1720      * Counterpart to Solidity's `*` operator.
1721      *
1722      * Requirements:
1723      *
1724      * - Multiplication cannot overflow.
1725      */
1726     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1727         return a * b;
1728     }
1729 
1730     /**
1731      * @dev Returns the integer division of two unsigned integers, reverting on
1732      * division by zero. The result is rounded towards zero.
1733      *
1734      * Counterpart to Solidity's `/` operator.
1735      *
1736      * Requirements:
1737      *
1738      * - The divisor cannot be zero.
1739      */
1740     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1741         return a / b;
1742     }
1743 
1744     /**
1745      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1746      * reverting when dividing by zero.
1747      *
1748      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1749      * opcode (which leaves remaining gas untouched) while Solidity uses an
1750      * invalid opcode to revert (consuming all remaining gas).
1751      *
1752      * Requirements:
1753      *
1754      * - The divisor cannot be zero.
1755      */
1756     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1757         return a % b;
1758     }
1759 
1760     /**
1761      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1762      * overflow (when the result is negative).
1763      *
1764      * CAUTION: This function is deprecated because it requires allocating memory for the error
1765      * message unnecessarily. For custom revert reasons use {trySub}.
1766      *
1767      * Counterpart to Solidity's `-` operator.
1768      *
1769      * Requirements:
1770      *
1771      * - Subtraction cannot overflow.
1772      */
1773     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1774         unchecked {
1775             require(b <= a, errorMessage);
1776             return a - b;
1777         }
1778     }
1779 
1780     /**
1781      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1782      * division by zero. The result is rounded towards zero.
1783      *
1784      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1785      * opcode (which leaves remaining gas untouched) while Solidity uses an
1786      * invalid opcode to revert (consuming all remaining gas).
1787      *
1788      * Counterpart to Solidity's `/` operator. Note: this function uses a
1789      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1790      * uses an invalid opcode to revert (consuming all remaining gas).
1791      *
1792      * Requirements:
1793      *
1794      * - The divisor cannot be zero.
1795      */
1796     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1797         unchecked {
1798             require(b > 0, errorMessage);
1799             return a / b;
1800         }
1801     }
1802 
1803     /**
1804      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1805      * reverting with custom message when dividing by zero.
1806      *
1807      * CAUTION: This function is deprecated because it requires allocating memory for the error
1808      * message unnecessarily. For custom revert reasons use {tryMod}.
1809      *
1810      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1811      * opcode (which leaves remaining gas untouched) while Solidity uses an
1812      * invalid opcode to revert (consuming all remaining gas).
1813      *
1814      * Requirements:
1815      *
1816      * - The divisor cannot be zero.
1817      */
1818     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1819         unchecked {
1820             require(b > 0, errorMessage);
1821             return a % b;
1822         }
1823     }
1824 }
1825 
1826 
1827 //File: @OpenZeppelin/contracts/utils/Strings.sol
1828 
1829 pragma solidity ^0.8.0;
1830 
1831 /**
1832  * @dev String operations.
1833  */
1834 library Strings {
1835     bytes16 private constant alphabet = "0123456789abcdef";
1836 
1837     /**
1838      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1839      */
1840     function toString(uint256 value) internal pure returns (string memory) {
1841         // Inspired by OraclizeAPI's implementation - MIT licence
1842         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1843 
1844         if (value == 0) {
1845             return "0";
1846         }
1847         uint256 temp = value;
1848         uint256 digits;
1849         while (temp != 0) {
1850             digits++;
1851             temp /= 10;
1852         }
1853         bytes memory buffer = new bytes(digits);
1854         while (value != 0) {
1855             digits -= 1;
1856             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1857             value /= 10;
1858         }
1859         return string(buffer);
1860     }
1861 
1862     /**
1863      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1864      */
1865     function toHexString(uint256 value) internal pure returns (string memory) {
1866         if (value == 0) {
1867             return "0x00";
1868         }
1869         uint256 temp = value;
1870         uint256 length = 0;
1871         while (temp != 0) {
1872             length++;
1873             temp >>= 8;
1874         }
1875         return toHexString(value, length);
1876     }
1877 
1878     /**
1879      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1880      */
1881     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1882         bytes memory buffer = new bytes(2 * length + 2);
1883         buffer[0] = "0";
1884         buffer[1] = "x";
1885         for (uint256 i = 2 * length + 1; i > 1; --i) {
1886             buffer[i] = alphabet[value & 0xf];
1887             value >>= 4;
1888         }
1889         require(value == 0, "Strings: hex length insufficient");
1890         return string(buffer);
1891     }
1892 
1893 }
1894 
1895 //File: contracts/CutieBears.sol
1896 
1897 pragma solidity ^0.8.0;
1898 /**
1899  * @title CutieBears contract
1900  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1901  */
1902 
1903 //────███████────────────███████──────────
1904 //────█─────█────────────█─────█──────────
1905 //────█─────██████████████─────█──────────
1906 //────█────────────────────────█──────────
1907 //────█───███────────────███───█──────────
1908 //────█───███────────────███───█──────────
1909 //────█────────────────────────█──────────
1910 //────█──────█──────────█──────█──────────
1911 //────█───────██████████───────█──────────
1912 //────█────────────────────────█──────────
1913 //─────████████████████████████───────────
1914 //──────────╔╗────╔╗──────────────────────
1915 //─────────╔╝╚╗───║║──────────────────────
1916 //────╔══╦╗╠╗╔╬╦══╣╚═╦══╦══╦═╦══╗─────────
1917 //────║╔═╣║║║║╠╣║═╣╔╗║║═╣╔╗║╔╣══╣─────────
1918 //────║╚═╣╚╝║╚╣║║═╣╚╝║║═╣╔╗║║╠══║─────────
1919 //────╚══╩══╩═╩╩══╩══╩══╩╝╚╩╝╚══╝─────────
1920 //
1921 // Oops you've found me!
1922 // Give our artist a follow on twitter @Swifty_igh
1923 // Also join our discord for more fun at discord.gg/MVAKbSanFc
1924 
1925 contract CutieBears is ERC721Enumerable, Ownable  {
1926 
1927     using SafeMath for uint256;
1928 
1929     // Token detail
1930     struct CutieDetail {
1931         uint256 first_encounter;
1932     }
1933 
1934     // Events
1935     event TokenMinted(uint256 tokenId, address owner, uint256 first_encounter);
1936 
1937     // Token Detail
1938     mapping( uint256 => CutieDetail) private _CutieDetails;
1939 
1940     // Provenance number
1941     string public PROVENANCE = "";
1942 
1943     // Starting index
1944     uint256 public STARTING_INDEX;
1945 
1946     // Max amount of token to purchase per account each time
1947     uint public MAX_PURCHASE = 10086;
1948 
1949     // Maximum amount of tokens to supply.
1950     uint256 public MAX_TOKENS = 10086;
1951 
1952     // Current price.
1953     uint256 public CURRENT_PRICE = 0; //0.06 ETH
1954 
1955     // Define if sale is active
1956     bool public saleIsActive = true;
1957 
1958     // Base URI
1959     string private baseURI;
1960 
1961     /**
1962      * Contract constructor
1963      */
1964     constructor(string memory name, string memory symbol, string memory baseURIp) ERC721(name, symbol) {
1965         setBaseURI(baseURIp);
1966     }
1967 
1968     /**
1969      * Withdraw
1970      */
1971     function withdraw() public onlyOwner {
1972         uint balance = address(this).balance;
1973         payable(msg.sender).transfer(balance);
1974     }
1975 
1976     /**
1977      * Reserve tokens
1978      */
1979     function reserveTokens() public onlyOwner {
1980         uint i;
1981         uint tokenId;
1982         uint256 first_encounter = block.timestamp;
1983 
1984         for (i = 1; i <= 275; i++) {
1985             tokenId = totalSupply().add(1);
1986             if (tokenId <= MAX_TOKENS) {
1987                 _safeMint(msg.sender, tokenId);
1988                 _CutieDetails[tokenId] = CutieDetail(first_encounter);
1989                 emit TokenMinted(tokenId, msg.sender, first_encounter);
1990             }
1991         }
1992     }
1993 
1994     /**
1995      * Mint a specific token. 
1996      */
1997     function mintTokenId(uint tokenId) public onlyOwner {
1998         require(!_exists(tokenId), "Token was minted");
1999         uint256 first_encounter = block.timestamp;
2000         
2001         _safeMint(msg.sender, tokenId);
2002         _CutieDetails[tokenId] = CutieDetail(first_encounter);
2003         emit TokenMinted(tokenId, msg.sender, first_encounter);
2004     }
2005 
2006     /*     
2007     * Set provenance once it's calculated
2008     */
2009     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2010         PROVENANCE = provenanceHash;
2011     }
2012 
2013     /*     
2014     * Set max tokens
2015     */
2016     function setMaxTokens(uint256 maxTokens) public onlyOwner {
2017         MAX_TOKENS = maxTokens;
2018     }
2019     
2020     /*     
2021     * Set max purchase
2022     */
2023     function setMAX_PURCHASE(uint256 maxPurchase) public onlyOwner {
2024         MAX_PURCHASE = maxPurchase;
2025     }
2026 
2027     /*
2028     * Pause sale if active, make active if paused
2029     */
2030     function setSaleState(bool newState) public onlyOwner {
2031         saleIsActive = newState;
2032     }
2033 
2034     /**
2035     * Mint Cuties
2036     */
2037     function mintCuties(uint numberOfTokens) public payable {
2038         require(saleIsActive, "Mint is not available right now");
2039         require(numberOfTokens <= MAX_PURCHASE, "Can only mint 20 tokens at a time");
2040         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Purchase would exceed max supply of Cuties");
2041         require(CURRENT_PRICE.mul(numberOfTokens) <= msg.value, "Value sent is not correct");
2042         uint256 first_encounter = block.timestamp;
2043         uint tokenId;
2044         
2045         for(uint i = 1; i <= numberOfTokens; i++) {
2046             tokenId = totalSupply().add(1);
2047             if (tokenId <= MAX_TOKENS) {
2048                 _safeMint(msg.sender, tokenId);
2049                 _CutieDetails[tokenId] = CutieDetail(first_encounter);
2050                 
2051                 emit TokenMinted(tokenId, msg.sender, first_encounter);
2052             }
2053         }
2054     }
2055 
2056     /**
2057      * Set the starting index for the collection
2058      */
2059     function setStartingIndex(uint256 startingIndex) public onlyOwner {
2060         STARTING_INDEX = startingIndex;
2061     }
2062 
2063     /**
2064     * @dev Changes the base URI if we want to move things in the future (Callable by owner only)
2065     */
2066     function setBaseURI(string memory BaseURI) public onlyOwner {
2067        baseURI = BaseURI;
2068     }
2069 
2070      /**
2071      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
2072      * in child contracts.
2073      */
2074     function _baseURI() internal view virtual override returns (string memory) {
2075         return baseURI;
2076     }
2077 
2078    /**
2079      * Set the current token price
2080      */
2081     function setCurrentPrice(uint256 currentPrice) public onlyOwner {
2082         CURRENT_PRICE = currentPrice;
2083     }
2084 
2085     /**
2086      * Get the token detail
2087      */
2088     function getCutieDetail(uint256 tokenId) public view returns(CutieDetail memory detail) {
2089         require(_exists(tokenId), "Token was not minted");
2090 
2091         return _CutieDetails[tokenId];
2092     }
2093         /*
2094     * Pause sale if active, make active if paused
2095     */
2096     function flipSaleState() public onlyOwner {
2097         saleIsActive = !saleIsActive;
2098     }
2099 }