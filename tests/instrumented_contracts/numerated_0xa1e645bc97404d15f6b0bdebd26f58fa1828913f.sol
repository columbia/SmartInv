1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.6;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
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
31         // This method relies in extcodesize, which returns 0 for contracts in
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
94         return _functionCallWithValue(target, data, 0, errorMessage);
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
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
148 
149 /*
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with GSN meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address payable) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes memory) {
165         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
166         return msg.data;
167     }
168 }
169 
170 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableMap
171 
172 /**
173  * @dev Library for managing an enumerable variant of Solidity's
174  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
175  * type.
176  *
177  * Maps have the following properties:
178  *
179  * - Entries are added, removed, and checked for existence in constant time
180  * (O(1)).
181  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
182  *
183  * ```
184  * contract Example {
185  *     // Add the library methods
186  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
187  *
188  *     // Declare a set state variable
189  *     EnumerableMap.UintToAddressMap private myMap;
190  * }
191  * ```
192  *
193  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
194  * supported.
195  */
196 library EnumerableMap {
197     // To implement this library for multiple types with as little code
198     // repetition as possible, we write it in terms of a generic Map type with
199     // bytes32 keys and values.
200     // The Map implementation uses private functions, and user-facing
201     // implementations (such as Uint256ToAddressMap) are just wrappers around
202     // the underlying Map.
203     // This means that we can only create new EnumerableMaps for types that fit
204     // in bytes32.
205 
206     struct MapEntry {
207         bytes32 _key;
208         bytes32 _value;
209     }
210 
211     struct Map {
212         // Storage of map keys and values
213         MapEntry[] _entries;
214 
215         // Position of the entry defined by a key in the `entries` array, plus 1
216         // because index 0 means a key is not in the map.
217         mapping (bytes32 => uint256) _indexes;
218     }
219 
220     /**
221      * @dev Adds a key-value pair to a map, or updates the value for an existing
222      * key. O(1).
223      *
224      * Returns true if the key was added to the map, that is if it was not
225      * already present.
226      */
227     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
228         // We read and store the key's index to prevent multiple reads from the same storage slot
229         uint256 keyIndex = map._indexes[key];
230 
231         if (keyIndex == 0) { // Equivalent to !contains(map, key)
232             map._entries.push(MapEntry({ _key: key, _value: value }));
233             // The entry is stored at length-1, but we add 1 to all indexes
234             // and use 0 as a sentinel value
235             map._indexes[key] = map._entries.length;
236             return true;
237         } else {
238             map._entries[keyIndex - 1]._value = value;
239             return false;
240         }
241     }
242 
243     /**
244      * @dev Removes a key-value pair from a map. O(1).
245      *
246      * Returns true if the key was removed from the map, that is if it was present.
247      */
248     function _remove(Map storage map, bytes32 key) private returns (bool) {
249         // We read and store the key's index to prevent multiple reads from the same storage slot
250         uint256 keyIndex = map._indexes[key];
251 
252         if (keyIndex != 0) { // Equivalent to contains(map, key)
253             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
254             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
255             // This modifies the order of the array, as noted in {at}.
256 
257             uint256 toDeleteIndex = keyIndex - 1;
258             uint256 lastIndex = map._entries.length - 1;
259 
260             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
261             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
262 
263             MapEntry storage lastEntry = map._entries[lastIndex];
264 
265             // Move the last entry to the index where the entry to delete is
266             map._entries[toDeleteIndex] = lastEntry;
267             // Update the index for the moved entry
268             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
269 
270             // Delete the slot where the moved entry was stored
271             map._entries.pop();
272 
273             // Delete the index for the deleted slot
274             delete map._indexes[key];
275 
276             return true;
277         } else {
278             return false;
279         }
280     }
281 
282     /**
283      * @dev Returns true if the key is in the map. O(1).
284      */
285     function _contains(Map storage map, bytes32 key) private view returns (bool) {
286         return map._indexes[key] != 0;
287     }
288 
289     /**
290      * @dev Returns the number of key-value pairs in the map. O(1).
291      */
292     function _length(Map storage map) private view returns (uint256) {
293         return map._entries.length;
294     }
295 
296    /**
297     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
298     *
299     * Note that there are no guarantees on the ordering of entries inside the
300     * array, and it may change when more entries are added or removed.
301     *
302     * Requirements:
303     *
304     * - `index` must be strictly less than {length}.
305     */
306     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
307         require(map._entries.length > index, "EnumerableMap: index out of bounds");
308 
309         MapEntry storage entry = map._entries[index];
310         return (entry._key, entry._value);
311     }
312 
313     /**
314      * @dev Returns the value associated with `key`.  O(1).
315      *
316      * Requirements:
317      *
318      * - `key` must be in the map.
319      */
320     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
321         return _get(map, key, "EnumerableMap: nonexistent key");
322     }
323 
324     /**
325      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
326      */
327     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
328         uint256 keyIndex = map._indexes[key];
329         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
330         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
331     }
332 
333     // UintToAddressMap
334 
335     struct UintToAddressMap {
336         Map _inner;
337     }
338 
339     /**
340      * @dev Adds a key-value pair to a map, or updates the value for an existing
341      * key. O(1).
342      *
343      * Returns true if the key was added to the map, that is if it was not
344      * already present.
345      */
346     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
347         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
348     }
349 
350     /**
351      * @dev Removes a value from a set. O(1).
352      *
353      * Returns true if the key was removed from the map, that is if it was present.
354      */
355     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
356         return _remove(map._inner, bytes32(key));
357     }
358 
359     /**
360      * @dev Returns true if the key is in the map. O(1).
361      */
362     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
363         return _contains(map._inner, bytes32(key));
364     }
365 
366     /**
367      * @dev Returns the number of elements in the map. O(1).
368      */
369     function length(UintToAddressMap storage map) internal view returns (uint256) {
370         return _length(map._inner);
371     }
372 
373    /**
374     * @dev Returns the element stored at position `index` in the set. O(1).
375     * Note that there are no guarantees on the ordering of values inside the
376     * array, and it may change when more values are added or removed.
377     *
378     * Requirements:
379     *
380     * - `index` must be strictly less than {length}.
381     */
382     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
383         (bytes32 key, bytes32 value) = _at(map._inner, index);
384         return (uint256(key), address(uint256(value)));
385     }
386 
387     /**
388      * @dev Returns the value associated with `key`.  O(1).
389      *
390      * Requirements:
391      *
392      * - `key` must be in the map.
393      */
394     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
395         return address(uint256(_get(map._inner, bytes32(key))));
396     }
397 
398     /**
399      * @dev Same as {get}, with a custom error message when `key` is not in the map.
400      */
401     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
402         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
403     }
404 }
405 
406 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableSet
407 
408 /**
409  * @dev Library for managing
410  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
411  * types.
412  *
413  * Sets have the following properties:
414  *
415  * - Elements are added, removed, and checked for existence in constant time
416  * (O(1)).
417  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
418  *
419  * ```
420  * contract Example {
421  *     // Add the library methods
422  *     using EnumerableSet for EnumerableSet.AddressSet;
423  *
424  *     // Declare a set state variable
425  *     EnumerableSet.AddressSet private mySet;
426  * }
427  * ```
428  *
429  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
430  * (`UintSet`) are supported.
431  */
432 library EnumerableSet {
433     // To implement this library for multiple types with as little code
434     // repetition as possible, we write it in terms of a generic Set type with
435     // bytes32 values.
436     // The Set implementation uses private functions, and user-facing
437     // implementations (such as AddressSet) are just wrappers around the
438     // underlying Set.
439     // This means that we can only create new EnumerableSets for types that fit
440     // in bytes32.
441 
442     struct Set {
443         // Storage of set values
444         bytes32[] _values;
445 
446         // Position of the value in the `values` array, plus 1 because index 0
447         // means a value is not in the set.
448         mapping (bytes32 => uint256) _indexes;
449     }
450 
451     /**
452      * @dev Add a value to a set. O(1).
453      *
454      * Returns true if the value was added to the set, that is if it was not
455      * already present.
456      */
457     function _add(Set storage set, bytes32 value) private returns (bool) {
458         if (!_contains(set, value)) {
459             set._values.push(value);
460             // The value is stored at length-1, but we add 1 to all indexes
461             // and use 0 as a sentinel value
462             set._indexes[value] = set._values.length;
463             return true;
464         } else {
465             return false;
466         }
467     }
468 
469     /**
470      * @dev Removes a value from a set. O(1).
471      *
472      * Returns true if the value was removed from the set, that is if it was
473      * present.
474      */
475     function _remove(Set storage set, bytes32 value) private returns (bool) {
476         // We read and store the value's index to prevent multiple reads from the same storage slot
477         uint256 valueIndex = set._indexes[value];
478 
479         if (valueIndex != 0) { // Equivalent to contains(set, value)
480             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
481             // the array, and then remove the last element (sometimes called as 'swap and pop').
482             // This modifies the order of the array, as noted in {at}.
483 
484             uint256 toDeleteIndex = valueIndex - 1;
485             uint256 lastIndex = set._values.length - 1;
486 
487             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
488             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
489 
490             bytes32 lastvalue = set._values[lastIndex];
491 
492             // Move the last value to the index where the value to delete is
493             set._values[toDeleteIndex] = lastvalue;
494             // Update the index for the moved value
495             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
496 
497             // Delete the slot where the moved value was stored
498             set._values.pop();
499 
500             // Delete the index for the deleted slot
501             delete set._indexes[value];
502 
503             return true;
504         } else {
505             return false;
506         }
507     }
508 
509     /**
510      * @dev Returns true if the value is in the set. O(1).
511      */
512     function _contains(Set storage set, bytes32 value) private view returns (bool) {
513         return set._indexes[value] != 0;
514     }
515 
516     /**
517      * @dev Returns the number of values on the set. O(1).
518      */
519     function _length(Set storage set) private view returns (uint256) {
520         return set._values.length;
521     }
522 
523    /**
524     * @dev Returns the value stored at position `index` in the set. O(1).
525     *
526     * Note that there are no guarantees on the ordering of values inside the
527     * array, and it may change when more values are added or removed.
528     *
529     * Requirements:
530     *
531     * - `index` must be strictly less than {length}.
532     */
533     function _at(Set storage set, uint256 index) private view returns (bytes32) {
534         require(set._values.length > index, "EnumerableSet: index out of bounds");
535         return set._values[index];
536     }
537 
538     // AddressSet
539 
540     struct AddressSet {
541         Set _inner;
542     }
543 
544     /**
545      * @dev Add a value to a set. O(1).
546      *
547      * Returns true if the value was added to the set, that is if it was not
548      * already present.
549      */
550     function add(AddressSet storage set, address value) internal returns (bool) {
551         return _add(set._inner, bytes32(uint256(value)));
552     }
553 
554     /**
555      * @dev Removes a value from a set. O(1).
556      *
557      * Returns true if the value was removed from the set, that is if it was
558      * present.
559      */
560     function remove(AddressSet storage set, address value) internal returns (bool) {
561         return _remove(set._inner, bytes32(uint256(value)));
562     }
563 
564     /**
565      * @dev Returns true if the value is in the set. O(1).
566      */
567     function contains(AddressSet storage set, address value) internal view returns (bool) {
568         return _contains(set._inner, bytes32(uint256(value)));
569     }
570 
571     /**
572      * @dev Returns the number of values in the set. O(1).
573      */
574     function length(AddressSet storage set) internal view returns (uint256) {
575         return _length(set._inner);
576     }
577 
578    /**
579     * @dev Returns the value stored at position `index` in the set. O(1).
580     *
581     * Note that there are no guarantees on the ordering of values inside the
582     * array, and it may change when more values are added or removed.
583     *
584     * Requirements:
585     *
586     * - `index` must be strictly less than {length}.
587     */
588     function at(AddressSet storage set, uint256 index) internal view returns (address) {
589         return address(uint256(_at(set._inner, index)));
590     }
591 
592 
593     // UintSet
594 
595     struct UintSet {
596         Set _inner;
597     }
598 
599     /**
600      * @dev Add a value to a set. O(1).
601      *
602      * Returns true if the value was added to the set, that is if it was not
603      * already present.
604      */
605     function add(UintSet storage set, uint256 value) internal returns (bool) {
606         return _add(set._inner, bytes32(value));
607     }
608 
609     /**
610      * @dev Removes a value from a set. O(1).
611      *
612      * Returns true if the value was removed from the set, that is if it was
613      * present.
614      */
615     function remove(UintSet storage set, uint256 value) internal returns (bool) {
616         return _remove(set._inner, bytes32(value));
617     }
618 
619     /**
620      * @dev Returns true if the value is in the set. O(1).
621      */
622     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
623         return _contains(set._inner, bytes32(value));
624     }
625 
626     /**
627      * @dev Returns the number of values on the set. O(1).
628      */
629     function length(UintSet storage set) internal view returns (uint256) {
630         return _length(set._inner);
631     }
632 
633    /**
634     * @dev Returns the value stored at position `index` in the set. O(1).
635     *
636     * Note that there are no guarantees on the ordering of values inside the
637     * array, and it may change when more values are added or removed.
638     *
639     * Requirements:
640     *
641     * - `index` must be strictly less than {length}.
642     */
643     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
644         return uint256(_at(set._inner, index));
645     }
646 }
647 
648 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC165
649 
650 /**
651  * @dev Interface of the ERC165 standard, as defined in the
652  * https://eips.ethereum.org/EIPS/eip-165[EIP].
653  *
654  * Implementers can declare support of contract interfaces, which can then be
655  * queried by others ({ERC165Checker}).
656  *
657  * For an implementation, see {ERC165}.
658  */
659 interface IERC165 {
660     /**
661      * @dev Returns true if this contract implements the interface defined by
662      * `interfaceId`. See the corresponding
663      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
664      * to learn more about how these ids are created.
665      *
666      * This function call must use less than 30 000 gas.
667      */
668     function supportsInterface(bytes4 interfaceId) external view returns (bool);
669 }
670 
671 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Receiver
672 
673 /**
674  * @title ERC721 token receiver interface
675  * @dev Interface for any contract that wants to support safeTransfers
676  * from ERC721 asset contracts.
677  */
678 interface IERC721Receiver {
679     /**
680      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
681      * by `operator` from `from`, this function is called.
682      *
683      * It must return its Solidity selector to confirm the token transfer.
684      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
685      *
686      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
687      */
688     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
689     external returns (bytes4);
690 }
691 
692 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
693 
694 /**
695  * @dev Wrappers over Solidity's arithmetic operations with added overflow
696  * checks.
697  *
698  * Arithmetic operations in Solidity wrap on overflow. This can easily result
699  * in bugs, because programmers usually assume that an overflow raises an
700  * error, which is the standard behavior in high level programming languages.
701  * `SafeMath` restores this intuition by reverting the transaction when an
702  * operation overflows.
703  *
704  * Using this library instead of the unchecked operations eliminates an entire
705  * class of bugs, so it's recommended to use it always.
706  */
707 library SafeMath {
708     /**
709      * @dev Returns the addition of two unsigned integers, reverting on
710      * overflow.
711      *
712      * Counterpart to Solidity's `+` operator.
713      *
714      * Requirements:
715      *
716      * - Addition cannot overflow.
717      */
718     function add(uint256 a, uint256 b) internal pure returns (uint256) {
719         uint256 c = a + b;
720         require(c >= a, "SafeMath: addition overflow");
721 
722         return c;
723     }
724 
725     /**
726      * @dev Returns the subtraction of two unsigned integers, reverting on
727      * overflow (when the result is negative).
728      *
729      * Counterpart to Solidity's `-` operator.
730      *
731      * Requirements:
732      *
733      * - Subtraction cannot overflow.
734      */
735     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
736         return sub(a, b, "SafeMath: subtraction overflow");
737     }
738 
739     /**
740      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
741      * overflow (when the result is negative).
742      *
743      * Counterpart to Solidity's `-` operator.
744      *
745      * Requirements:
746      *
747      * - Subtraction cannot overflow.
748      */
749     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
750         require(b <= a, errorMessage);
751         uint256 c = a - b;
752 
753         return c;
754     }
755 
756     /**
757      * @dev Returns the multiplication of two unsigned integers, reverting on
758      * overflow.
759      *
760      * Counterpart to Solidity's `*` operator.
761      *
762      * Requirements:
763      *
764      * - Multiplication cannot overflow.
765      */
766     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
767         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
768         // benefit is lost if 'b' is also tested.
769         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
770         if (a == 0) {
771             return 0;
772         }
773 
774         uint256 c = a * b;
775         require(c / a == b, "SafeMath: multiplication overflow");
776 
777         return c;
778     }
779 
780     /**
781      * @dev Returns the integer division of two unsigned integers. Reverts on
782      * division by zero. The result is rounded towards zero.
783      *
784      * Counterpart to Solidity's `/` operator. Note: this function uses a
785      * `revert` opcode (which leaves remaining gas untouched) while Solidity
786      * uses an invalid opcode to revert (consuming all remaining gas).
787      *
788      * Requirements:
789      *
790      * - The divisor cannot be zero.
791      */
792     function div(uint256 a, uint256 b) internal pure returns (uint256) {
793         return div(a, b, "SafeMath: division by zero");
794     }
795 
796     /**
797      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
798      * division by zero. The result is rounded towards zero.
799      *
800      * Counterpart to Solidity's `/` operator. Note: this function uses a
801      * `revert` opcode (which leaves remaining gas untouched) while Solidity
802      * uses an invalid opcode to revert (consuming all remaining gas).
803      *
804      * Requirements:
805      *
806      * - The divisor cannot be zero.
807      */
808     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
809         require(b > 0, errorMessage);
810         uint256 c = a / b;
811         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
812 
813         return c;
814     }
815 
816     /**
817      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
818      * Reverts when dividing by zero.
819      *
820      * Counterpart to Solidity's `%` operator. This function uses a `revert`
821      * opcode (which leaves remaining gas untouched) while Solidity uses an
822      * invalid opcode to revert (consuming all remaining gas).
823      *
824      * Requirements:
825      *
826      * - The divisor cannot be zero.
827      */
828     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
829         return mod(a, b, "SafeMath: modulo by zero");
830     }
831 
832     /**
833      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
834      * Reverts with custom message when dividing by zero.
835      *
836      * Counterpart to Solidity's `%` operator. This function uses a `revert`
837      * opcode (which leaves remaining gas untouched) while Solidity uses an
838      * invalid opcode to revert (consuming all remaining gas).
839      *
840      * Requirements:
841      *
842      * - The divisor cannot be zero.
843      */
844     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
845         require(b != 0, errorMessage);
846         return a % b;
847     }
848 }
849 
850 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Strings
851 
852 /**
853  * @dev String operations.
854  */
855 library Strings {
856     /**
857      * @dev Converts a `uint256` to its ASCII `string` representation.
858      */
859     function toString(uint256 value) internal pure returns (string memory) {
860         // Inspired by OraclizeAPI's implementation - MIT licence
861         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
862 
863         if (value == 0) {
864             return "0";
865         }
866         uint256 temp = value;
867         uint256 digits;
868         while (temp != 0) {
869             digits++;
870             temp /= 10;
871         }
872         bytes memory buffer = new bytes(digits);
873         uint256 index = digits - 1;
874         temp = value;
875         while (temp != 0) {
876             buffer[index--] = byte(uint8(48 + temp % 10));
877             temp /= 10;
878         }
879         return string(buffer);
880     }
881 }
882 
883 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC165
884 
885 /**
886  * @dev Implementation of the {IERC165} interface.
887  *
888  * Contracts may inherit from this and call {_registerInterface} to declare
889  * their support of an interface.
890  */
891 contract ERC165 is IERC165 {
892     /*
893      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
894      */
895     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
896 
897     /**
898      * @dev Mapping of interface ids to whether or not it's supported.
899      */
900     mapping(bytes4 => bool) private _supportedInterfaces;
901 
902     constructor () internal {
903         // Derived contracts need only register support for their own interfaces,
904         // we register support for ERC165 itself here
905         _registerInterface(_INTERFACE_ID_ERC165);
906     }
907 
908     /**
909      * @dev See {IERC165-supportsInterface}.
910      *
911      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
912      */
913     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
914         return _supportedInterfaces[interfaceId];
915     }
916 
917     /**
918      * @dev Registers the contract as an implementer of the interface defined by
919      * `interfaceId`. Support of the actual ERC165 interface is automatic and
920      * registering its interface id is not required.
921      *
922      * See {IERC165-supportsInterface}.
923      *
924      * Requirements:
925      *
926      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
927      */
928     function _registerInterface(bytes4 interfaceId) internal virtual {
929         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
930         _supportedInterfaces[interfaceId] = true;
931     }
932 }
933 
934 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721
935 
936 /**
937  * @dev Required interface of an ERC721 compliant contract.
938  */
939 interface IERC721 is IERC165 {
940     /**
941      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
942      */
943     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
944 
945     /**
946      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
947      */
948     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
949 
950     /**
951      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
952      */
953     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
954 
955     /**
956      * @dev Returns the number of tokens in ``owner``'s account.
957      */
958     function balanceOf(address owner) external view returns (uint256 balance);
959 
960     /**
961      * @dev Returns the owner of the `tokenId` token.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function ownerOf(uint256 tokenId) external view returns (address owner);
968 
969     /**
970      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
971      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must exist and be owned by `from`.
978      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function safeTransferFrom(address from, address to, uint256 tokenId) external;
984 
985     /**
986      * @dev Transfers `tokenId` token from `from` to `to`.
987      *
988      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
989      *
990      * Requirements:
991      *
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must be owned by `from`.
995      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
996      *
997      * Emits a {Transfer} event.
998      */
999     function transferFrom(address from, address to, uint256 tokenId) external;
1000 
1001     /**
1002      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1003      * The approval is cleared when the token is transferred.
1004      *
1005      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1006      *
1007      * Requirements:
1008      *
1009      * - The caller must own the token or be an approved operator.
1010      * - `tokenId` must exist.
1011      *
1012      * Emits an {Approval} event.
1013      */
1014     function approve(address to, uint256 tokenId) external;
1015 
1016     /**
1017      * @dev Returns the account approved for `tokenId` token.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function getApproved(uint256 tokenId) external view returns (address operator);
1024 
1025     /**
1026      * @dev Approve or remove `operator` as an operator for the caller.
1027      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1028      *
1029      * Requirements:
1030      *
1031      * - The `operator` cannot be the caller.
1032      *
1033      * Emits an {ApprovalForAll} event.
1034      */
1035     function setApprovalForAll(address operator, bool _approved) external;
1036 
1037     /**
1038      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1039      *
1040      * See {setApprovalForAll}
1041      */
1042     function isApprovedForAll(address owner, address operator) external view returns (bool);
1043 
1044     /**
1045       * @dev Safely transfers `tokenId` token from `from` to `to`.
1046       *
1047       * Requirements:
1048       *
1049      * - `from` cannot be the zero address.
1050      * - `to` cannot be the zero address.
1051       * - `tokenId` token must exist and be owned by `from`.
1052       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1053       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1054       *
1055       * Emits a {Transfer} event.
1056       */
1057     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1058 }
1059 
1060 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Ownable
1061 
1062 /**
1063  * @dev Contract module which provides a basic access control mechanism, where
1064  * there is an account (an owner) that can be granted exclusive access to
1065  * specific functions.
1066  *
1067  * By default, the owner account will be the one that deploys the contract. This
1068  * can later be changed with {transferOwnership}.
1069  *
1070  * This module is used through inheritance. It will make available the modifier
1071  * `onlyOwner`, which can be applied to your functions to restrict their use to
1072  * the owner.
1073  */
1074 contract Ownable is Context {
1075     address private _owner;
1076 
1077     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1078 
1079     /**
1080      * @dev Initializes the contract setting the deployer as the initial owner.
1081      */
1082     constructor () internal {
1083         address msgSender = _msgSender();
1084         _owner = msgSender;
1085         emit OwnershipTransferred(address(0), msgSender);
1086     }
1087 
1088     /**
1089      * @dev Returns the address of the current owner.
1090      */
1091     function owner() public view returns (address) {
1092         return _owner;
1093     }
1094 
1095     /**
1096      * @dev Throws if called by any account other than the owner.
1097      */
1098     modifier onlyOwner() {
1099         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1100         _;
1101     }
1102 
1103     /**
1104      * @dev Leaves the contract without owner. It will not be possible to call
1105      * `onlyOwner` functions anymore. Can only be called by the current owner.
1106      *
1107      * NOTE: Renouncing ownership will leave the contract without an owner,
1108      * thereby removing any functionality that is only available to the owner.
1109      */
1110     function renounceOwnership() public virtual onlyOwner {
1111         emit OwnershipTransferred(_owner, address(0));
1112         _owner = address(0);
1113     }
1114 
1115     /**
1116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1117      * Can only be called by the current owner.
1118      */
1119     function transferOwnership(address newOwner) public virtual onlyOwner {
1120         require(newOwner != address(0), "Ownable: new owner is the zero address");
1121         emit OwnershipTransferred(_owner, newOwner);
1122         _owner = newOwner;
1123     }
1124 }
1125 
1126 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Enumerable
1127 
1128 /**
1129  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1130  * @dev See https://eips.ethereum.org/EIPS/eip-721
1131  */
1132 interface IERC721Enumerable is IERC721 {
1133 
1134     /**
1135      * @dev Returns the total amount of tokens stored by the contract.
1136      */
1137     function totalSupply() external view returns (uint256);
1138 
1139     /**
1140      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1141      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1142      */
1143     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1144 
1145     /**
1146      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1147      * Use along with {totalSupply} to enumerate all tokens.
1148      */
1149     function tokenByIndex(uint256 index) external view returns (uint256);
1150 }
1151 
1152 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Metadata
1153 
1154 /**
1155  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1156  * @dev See https://eips.ethereum.org/EIPS/eip-721
1157  */
1158 interface IERC721Metadata is IERC721 {
1159 
1160     /**
1161      * @dev Returns the token collection name.
1162      */
1163     function name() external view returns (string memory);
1164 
1165     /**
1166      * @dev Returns the token collection symbol.
1167      */
1168     function symbol() external view returns (string memory);
1169 
1170     /**
1171      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1172      */
1173     function tokenURI(uint256 tokenId) external view returns (string memory);
1174 }
1175 
1176 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC721
1177 
1178 /**
1179  * @title ERC721 Non-Fungible Token Standard basic implementation
1180  * @dev see https://eips.ethereum.org/EIPS/eip-721
1181  */
1182 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1183     using SafeMath for uint256;
1184     using Address for address;
1185     using EnumerableSet for EnumerableSet.UintSet;
1186     using EnumerableMap for EnumerableMap.UintToAddressMap;
1187     using Strings for uint256;
1188 
1189     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1190     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1191     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1192 
1193     // Mapping from holder address to their (enumerable) set of owned tokens
1194     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1195 
1196     // Enumerable mapping from token ids to their owners
1197     EnumerableMap.UintToAddressMap private _tokenOwners;
1198 
1199     // Mapping from token ID to approved address
1200     mapping (uint256 => address) private _tokenApprovals;
1201 
1202     // Mapping from owner to operator approvals
1203     mapping (address => mapping (address => bool)) private _operatorApprovals;
1204 
1205     // Token name
1206     string private _name;
1207 
1208     // Token symbol
1209     string private _symbol;
1210 
1211     // Optional mapping for token URIs
1212     mapping (uint256 => string) private _tokenURIs;
1213 
1214     // Base URI
1215     string private _baseURI;
1216 
1217     /*
1218      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1219      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1220      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1221      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1222      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1223      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1224      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1225      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1226      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1227      *
1228      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1229      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1230      */
1231     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1232 
1233     /*
1234      *     bytes4(keccak256('name()')) == 0x06fdde03
1235      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1236      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1237      *
1238      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1239      */
1240     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1241 
1242     /*
1243      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1244      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1245      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1246      *
1247      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1248      */
1249     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1250 
1251     /**
1252      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1253      */
1254     constructor (string memory name, string memory symbol) public {
1255         _name = name;
1256         _symbol = symbol;
1257 
1258         // register the supported interfaces to conform to ERC721 via ERC165
1259         _registerInterface(_INTERFACE_ID_ERC721);
1260         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1261         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-balanceOf}.
1266      */
1267     function balanceOf(address owner) public view override returns (uint256) {
1268         require(owner != address(0), "ERC721: balance query for the zero address");
1269 
1270         return _holderTokens[owner].length();
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-ownerOf}.
1275      */
1276     function ownerOf(uint256 tokenId) public view override returns (address) {
1277         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1278     }
1279 
1280     /**
1281      * @dev See {IERC721Metadata-name}.
1282      */
1283     function name() public view override returns (string memory) {
1284         return _name;
1285     }
1286 
1287     /**
1288      * @dev See {IERC721Metadata-symbol}.
1289      */
1290     function symbol() public view override returns (string memory) {
1291         return _symbol;
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Metadata-tokenURI}.
1296      */
1297     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1298         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1299 
1300         string memory _tokenURI = _tokenURIs[tokenId];
1301 
1302         // If there is no base URI, return the token URI.
1303         if (bytes(_baseURI).length == 0) {
1304             return _tokenURI;
1305         }
1306         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1307         if (bytes(_tokenURI).length > 0) {
1308             return string(abi.encodePacked(_baseURI, _tokenURI));
1309         }
1310         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1311         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1312     }
1313 
1314     /**
1315     * @dev Returns the base URI set via {_setBaseURI}. This will be
1316     * automatically added as a prefix in {tokenURI} to each token's URI, or
1317     * to the token ID if no specific URI is set for that token ID.
1318     */
1319     function baseURI() public view returns (string memory) {
1320         return _baseURI;
1321     }
1322 
1323     /**
1324      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1325      */
1326     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1327         return _holderTokens[owner].at(index);
1328     }
1329 
1330     /**
1331      * @dev See {IERC721Enumerable-totalSupply}.
1332      */
1333     function totalSupply() public view override returns (uint256) {
1334         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1335         return _tokenOwners.length();
1336     }
1337 
1338     /**
1339      * @dev See {IERC721Enumerable-tokenByIndex}.
1340      */
1341     function tokenByIndex(uint256 index) public view override returns (uint256) {
1342         (uint256 tokenId, ) = _tokenOwners.at(index);
1343         return tokenId;
1344     }
1345 
1346     /**
1347      * @dev See {IERC721-approve}.
1348      */
1349     function approve(address to, uint256 tokenId) public virtual override {
1350         address owner = ownerOf(tokenId);
1351         require(to != owner, "ERC721: approval to current owner");
1352 
1353         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1354             "ERC721: approve caller is not owner nor approved for all"
1355         );
1356 
1357         _approve(to, tokenId);
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-getApproved}.
1362      */
1363     function getApproved(uint256 tokenId) public view override returns (address) {
1364         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1365 
1366         return _tokenApprovals[tokenId];
1367     }
1368 
1369     /**
1370      * @dev See {IERC721-setApprovalForAll}.
1371      */
1372     function setApprovalForAll(address operator, bool approved) public virtual override {
1373         require(operator != _msgSender(), "ERC721: approve to caller");
1374 
1375         _operatorApprovals[_msgSender()][operator] = approved;
1376         emit ApprovalForAll(_msgSender(), operator, approved);
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-isApprovedForAll}.
1381      */
1382     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1383         return _operatorApprovals[owner][operator];
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-transferFrom}.
1388      */
1389     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1390         //solhint-disable-next-line max-line-length
1391         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1392 
1393         _transfer(from, to, tokenId);
1394     }
1395 
1396     /**
1397      * @dev See {IERC721-safeTransferFrom}.
1398      */
1399     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1400         safeTransferFrom(from, to, tokenId, "");
1401     }
1402 
1403     /**
1404      * @dev See {IERC721-safeTransferFrom}.
1405      */
1406     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1407         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1408         _safeTransfer(from, to, tokenId, _data);
1409     }
1410 
1411     /**
1412      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1413      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1414      *
1415      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1416      *
1417      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1418      * implement alternative mechanisms to perform token transfer, such as signature-based.
1419      *
1420      * Requirements:
1421      *
1422      * - `from` cannot be the zero address.
1423      * - `to` cannot be the zero address.
1424      * - `tokenId` token must exist and be owned by `from`.
1425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1430         _transfer(from, to, tokenId);
1431         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1432     }
1433 
1434     /**
1435      * @dev Returns whether `tokenId` exists.
1436      *
1437      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1438      *
1439      * Tokens start existing when they are minted (`_mint`),
1440      * and stop existing when they are burned (`_burn`).
1441      */
1442     function _exists(uint256 tokenId) internal view returns (bool) {
1443         return _tokenOwners.contains(tokenId);
1444     }
1445 
1446     /**
1447      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1448      *
1449      * Requirements:
1450      *
1451      * - `tokenId` must exist.
1452      */
1453     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1454         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1455         address owner = ownerOf(tokenId);
1456         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1457     }
1458 
1459     /**
1460      * @dev Safely mints `tokenId` and transfers it to `to`.
1461      *
1462      * Requirements:
1463      d*
1464      * - `tokenId` must not exist.
1465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function _safeMint(address to, uint256 tokenId) internal virtual {
1470         _safeMint(to, tokenId, "");
1471     }
1472 
1473     /**
1474      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1475      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1476      */
1477     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1478         _mint(to, tokenId);
1479         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1480     }
1481 
1482     /**
1483      * @dev Mints `tokenId` and transfers it to `to`.
1484      *
1485      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1486      *
1487      * Requirements:
1488      *
1489      * - `tokenId` must not exist.
1490      * - `to` cannot be the zero address.
1491      *
1492      * Emits a {Transfer} event.
1493      */
1494     function _mint(address to, uint256 tokenId) internal virtual {
1495         require(to != address(0), "ERC721: mint to the zero address");
1496         require(!_exists(tokenId), "ERC721: token already minted");
1497 
1498         _beforeTokenTransfer(address(0), to, tokenId);
1499 
1500         _holderTokens[to].add(tokenId);
1501 
1502         _tokenOwners.set(tokenId, to);
1503 
1504         emit Transfer(address(0), to, tokenId);
1505     }
1506 
1507     /**
1508      * @dev Destroys `tokenId`.
1509      * The approval is cleared when the token is burned.
1510      *
1511      * Requirements:
1512      *
1513      * - `tokenId` must exist.
1514      *
1515      * Emits a {Transfer} event.
1516      */
1517     function _burn(uint256 tokenId) internal virtual {
1518         address owner = ownerOf(tokenId);
1519 
1520         _beforeTokenTransfer(owner, address(0), tokenId);
1521 
1522         // Clear approvals
1523         _approve(address(0), tokenId);
1524 
1525         // Clear metadata (if any)
1526         if (bytes(_tokenURIs[tokenId]).length != 0) {
1527             delete _tokenURIs[tokenId];
1528         }
1529 
1530         _holderTokens[owner].remove(tokenId);
1531 
1532         _tokenOwners.remove(tokenId);
1533 
1534         emit Transfer(owner, address(0), tokenId);
1535     }
1536 
1537     /**
1538      * @dev Transfers `tokenId` from `from` to `to`.
1539      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1540      *
1541      * Requirements:
1542      *
1543      * - `to` cannot be the zero address.
1544      * - `tokenId` token must be owned by `from`.
1545      *
1546      * Emits a {Transfer} event.
1547      */
1548     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1549         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1550         require(to != address(0), "ERC721: transfer to the zero address");
1551 
1552         _beforeTokenTransfer(from, to, tokenId);
1553 
1554         // Clear approvals from the previous owner
1555         _approve(address(0), tokenId);
1556 
1557         _holderTokens[from].remove(tokenId);
1558         _holderTokens[to].add(tokenId);
1559 
1560         _tokenOwners.set(tokenId, to);
1561 
1562         emit Transfer(from, to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1567      *
1568      * Requirements:
1569      *
1570      * - `tokenId` must exist.
1571      */
1572     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1573         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1574         _tokenURIs[tokenId] = _tokenURI;
1575     }
1576 
1577     /**
1578      * @dev Internal function to set the base URI for all token IDs. It is
1579      * automatically added as a prefix to the value returned in {tokenURI},
1580      * or to the token ID if {tokenURI} is empty.
1581      */
1582     function _setBaseURI(string memory baseURI_) internal virtual {
1583         _baseURI = baseURI_;
1584     }
1585 
1586     /**
1587      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1588      * The call is not executed if the target address is not a contract.
1589      *
1590      * @param from address representing the previous owner of the given token ID
1591      * @param to target address that will receive the tokens
1592      * @param tokenId uint256 ID of the token to be transferred
1593      * @param _data bytes optional data to send along with the call
1594      * @return bool whether the call correctly returned the expected magic value
1595      */
1596     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1597         private returns (bool)
1598     {
1599         if (!to.isContract()) {
1600             return true;
1601         }
1602         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1603             IERC721Receiver(to).onERC721Received.selector,
1604             _msgSender(),
1605             from,
1606             tokenId,
1607             _data
1608         ), "ERC721: transfer to non ERC721Receiver implementer");
1609         bytes4 retval = abi.decode(returndata, (bytes4));
1610         return (retval == _ERC721_RECEIVED);
1611     }
1612 
1613     function _approve(address to, uint256 tokenId) private {
1614         _tokenApprovals[tokenId] = to;
1615         emit Approval(ownerOf(tokenId), to, tokenId);
1616     }
1617 
1618     /**
1619      * @dev Hook that is called before any token transfer. This includes minting
1620      * and burning.
1621      *
1622      * Calling conditions:
1623      *
1624      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1625      * transferred to `to`.
1626      * - When `from` is zero, `tokenId` will be minted for `to`.
1627      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1628      * - `from` cannot be the zero address.
1629      * - `to` cannot be the zero address.
1630      *
1631      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1632      */
1633     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1634 }
1635 
1636 // File: Blockheadz.sol
1637 
1638 /**
1639  * @title NFT contract - forked from BAYC
1640  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1641  */
1642 contract Blockheadz is ERC721, Ownable {
1643     using SafeMath for uint256;
1644 
1645     uint256 public constant maxSupply = 10000;
1646     uint256 public constant price = 5*10**16;
1647     uint256 public constant purchaseLimit = 20;
1648     uint256 internal constant reservable = 105;
1649     string internal constant _name = "Blockheadz";
1650     string internal constant _symbol = "BLOCK";
1651     address payable public payee;
1652     address internal reservee = 0xA89AeFFc48e51bDe582Dd5aE5b45d5A45B6C26Bf;
1653 
1654     string public contractURI;
1655     string public provenance;
1656     bool public saleIsActive = true;
1657     uint256 public saleStart = 1632085200;
1658 
1659     constructor (
1660         address payable _payee
1661         ) public ERC721(_name, _symbol) {
1662         payee = _payee;
1663     }
1664 
1665     /** 
1666      * emergency withdraw function, callable by anyone
1667      */
1668     function withdraw() public {
1669         payee.transfer(address(this).balance);
1670     }
1671 
1672     /**
1673      * reserve
1674      */
1675     function reserve() public onlyOwner {
1676         require(totalSupply() < reservable, "reserve would exceed reservable");
1677         uint supply = totalSupply();
1678         uint i;
1679         for (i = 0; i < 55; i++) {
1680             if (totalSupply() < 90) {
1681                 _safeMint(reservee, supply + i);
1682             } else if (totalSupply() < reservable){
1683                 _safeMint(msg.sender, supply + i);
1684             }
1685         }
1686     }
1687 
1688     /**
1689      * set provenance if needed
1690     */
1691     function setProvenance(string memory _provenance) public onlyOwner {
1692         provenance = _provenance;
1693     }
1694 
1695     /*
1696     * sets baseURI
1697     */
1698     function setBaseURI(string memory baseURI) public onlyOwner {
1699         _setBaseURI(baseURI);
1700     }
1701 
1702     /*
1703     * set contractURI if needed
1704     */
1705     function setContractURI(string memory _contractURI) public onlyOwner {
1706         contractURI = (_contractURI);
1707     }
1708 
1709 
1710     /*
1711     * Pause sale if active, make active if paused
1712     */
1713     function flipSaleState() public onlyOwner {
1714         saleIsActive = !saleIsActive;
1715     }
1716 
1717     /*
1718     * updates saleStart
1719     */
1720     function setSaleStart(uint256 _saleStart) public onlyOwner {
1721         saleStart = _saleStart;
1722     }
1723 
1724     /**
1725     * mint
1726     */
1727     function mint(uint numberOfTokens) public payable {
1728         require(saleIsActive, "Sale must be active to mint");
1729         require(block.timestamp >= saleStart, "Sale has not started yet, timestamp too low");
1730         require(numberOfTokens <= purchaseLimit, "Purchase would exceed purchase limit");
1731         require(totalSupply().add(numberOfTokens) <= maxSupply, "Purchase would exceed maxSupply");
1732         require(price.mul(numberOfTokens) <= msg.value, "Ether value sent is too low");
1733         
1734         payee.transfer(address(this).balance);        
1735         for(uint i = 0; i < numberOfTokens; i++) {
1736             uint mintIndex = totalSupply();
1737             if (totalSupply() < maxSupply) {
1738                 _safeMint(msg.sender, mintIndex);
1739             }
1740         }
1741     }
1742 
1743 }
