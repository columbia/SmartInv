1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 pragma abicoder v2;
5 
6 
7 
8 // Part: Address
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
32         // This method relies on extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         // solhint-disable-next-line no-inline-assembly
38         assembly {
39             size := extcodesize(account)
40         }
41         return size > 0;
42     }
43 
44     /**
45      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
46      * `recipient`, forwarding all available gas and reverting on errors.
47      *
48      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
49      * of certain opcodes, possibly making contracts go over the 2300 gas limit
50      * imposed by `transfer`, making them unable to receive funds via
51      * `transfer`. {sendValue} removes this limitation.
52      *
53      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
54      *
55      * IMPORTANT: because control is transferred to `recipient`, care must be
56      * taken to not create reentrancy vulnerabilities. Consider using
57      * {ReentrancyGuard} or the
58      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
59      */
60     function sendValue(address payable recipient, uint256 amount) internal {
61         require(
62             address(this).balance >= amount,
63             "Address: insufficient balance"
64         );
65 
66         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
67         (bool success, ) = recipient.call{value: amount}("");
68         require(
69             success,
70             "Address: unable to send value, recipient may have reverted"
71         );
72     }
73 
74     /**
75      * @dev Performs a Solidity function call using a low level `call`. A
76      * plain`call` is an unsafe replacement for a function call: use this
77      * function instead.
78      *
79      * If `target` reverts with a revert reason, it is bubbled up by this
80      * function (like regular Solidity function calls).
81      *
82      * Returns the raw returned data. To convert to the expected return value,
83      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
84      *
85      * Requirements:
86      *
87      * - `target` must be a contract.
88      * - calling `target` with `data` must not revert.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data)
93         internal
94         returns (bytes memory)
95     {
96         return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
101      * `errorMessage` as a fallback revert reason when `target` reverts.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(
106         address target,
107         bytes memory data,
108         string memory errorMessage
109     ) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, 0, errorMessage);
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
115      * but also transferring `value` wei to `target`.
116      *
117      * Requirements:
118      *
119      * - the calling contract must have an ETH balance of at least `value`.
120      * - the called Solidity function must be `payable`.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value
128     ) internal returns (bytes memory) {
129         return
130             functionCallWithValue(
131                 target,
132                 data,
133                 value,
134                 "Address: low-level call with value failed"
135             );
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(
151             address(this).balance >= value,
152             "Address: insufficient balance for call"
153         );
154         require(isContract(target), "Address: call to non-contract");
155 
156         // solhint-disable-next-line avoid-low-level-calls
157         (bool success, bytes memory returndata) = target.call{value: value}(
158             data
159         );
160         return _verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(address target, bytes memory data)
170         internal
171         view
172         returns (bytes memory)
173     {
174         return
175             functionStaticCall(
176                 target,
177                 data,
178                 "Address: low-level static call failed"
179             );
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a static call.
185      *
186      * _Available since v3.3._
187      */
188     function functionStaticCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal view returns (bytes memory) {
193         require(isContract(target), "Address: static call to non-contract");
194 
195         // solhint-disable-next-line avoid-low-level-calls
196         (bool success, bytes memory returndata) = target.staticcall(data);
197         return _verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but performing a delegate call.
203      *
204      * _Available since v3.4._
205      */
206     function functionDelegateCall(address target, bytes memory data)
207         internal
208         returns (bytes memory)
209     {
210         return
211             functionDelegateCall(
212                 target,
213                 data,
214                 "Address: low-level delegate call failed"
215             );
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a delegate call.
221      *
222      * _Available since v3.4._
223      */
224     function functionDelegateCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         require(isContract(target), "Address: delegate call to non-contract");
230 
231         // solhint-disable-next-line avoid-low-level-calls
232         (bool success, bytes memory returndata) = target.delegatecall(data);
233         return _verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     function _verifyCallResult(
237         bool success,
238         bytes memory returndata,
239         string memory errorMessage
240     ) private pure returns (bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 // solhint-disable-next-line no-inline-assembly
249                 assembly {
250                     let returndata_size := mload(returndata)
251                     revert(add(32, returndata), returndata_size)
252                 }
253             } else {
254                 revert(errorMessage);
255             }
256         }
257     }
258 }
259 
260 // Part: Context
261 
262 /*
263  * @dev Provides information about the current execution context, including the
264  * sender of the transaction and its data. While these are generally available
265  * via msg.sender and msg.data, they should not be accessed in such a direct
266  * manner, since when dealing with GSN meta-transactions the account sending and
267  * paying for execution may not be the actual sender (as far as an application
268  * is concerned).
269  *
270  * This contract is only required for intermediate, library-like contracts.
271  */
272 abstract contract Context {
273     function _msgSender() internal view virtual returns (address payable) {
274         return msg.sender;
275     }
276 
277     function _msgData() internal view virtual returns (bytes memory) {
278         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
279         return msg.data;
280     }
281 }
282 
283 // Part: EnumerableMap
284 
285 /**
286  * @dev Library for managing an enumerable variant of Solidity's
287  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
288  * type.
289  *
290  * Maps have the following properties:
291  *
292  * - Entries are added, removed, and checked for existence in constant time
293  * (O(1)).
294  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
295  *
296  * ```
297  * contract Example {
298  *     // Add the library methods
299  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
300  *
301  *     // Declare a set state variable
302  *     EnumerableMap.UintToAddressMap private myMap;
303  * }
304  * ```
305  *
306  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
307  * supported.
308  */
309 library EnumerableMap {
310     // To implement this library for multiple types with as little code
311     // repetition as possible, we write it in terms of a generic Map type with
312     // bytes32 keys and values.
313     // The Map implementation uses private functions, and user-facing
314     // implementations (such as Uint256ToAddressMap) are just wrappers around
315     // the underlying Map.
316     // This means that we can only create new EnumerableMaps for types that fit
317     // in bytes32.
318 
319     struct MapEntry {
320         bytes32 _key;
321         bytes32 _value;
322     }
323 
324     struct Map {
325         // Storage of map keys and values
326         MapEntry[] _entries;
327         // Position of the entry defined by a key in the `entries` array, plus 1
328         // because index 0 means a key is not in the map.
329         mapping(bytes32 => uint256) _indexes;
330     }
331 
332     /**
333      * @dev Adds a key-value pair to a map, or updates the value for an existing
334      * key. O(1).
335      *
336      * Returns true if the key was added to the map, that is if it was not
337      * already present.
338      */
339     function _set(
340         Map storage map,
341         bytes32 key,
342         bytes32 value
343     ) private returns (bool) {
344         // We read and store the key's index to prevent multiple reads from the same storage slot
345         uint256 keyIndex = map._indexes[key];
346 
347         if (keyIndex == 0) {
348             // Equivalent to !contains(map, key)
349             map._entries.push(MapEntry({_key: key, _value: value}));
350             // The entry is stored at length-1, but we add 1 to all indexes
351             // and use 0 as a sentinel value
352             map._indexes[key] = map._entries.length;
353             return true;
354         } else {
355             map._entries[keyIndex - 1]._value = value;
356             return false;
357         }
358     }
359 
360     /**
361      * @dev Removes a key-value pair from a map. O(1).
362      *
363      * Returns true if the key was removed from the map, that is if it was present.
364      */
365     function _remove(Map storage map, bytes32 key) private returns (bool) {
366         // We read and store the key's index to prevent multiple reads from the same storage slot
367         uint256 keyIndex = map._indexes[key];
368 
369         if (keyIndex != 0) {
370             // Equivalent to contains(map, key)
371             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
372             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
373             // This modifies the order of the array, as noted in {at}.
374 
375             uint256 toDeleteIndex = keyIndex - 1;
376             uint256 lastIndex = map._entries.length - 1;
377 
378             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
379             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
380 
381             MapEntry storage lastEntry = map._entries[lastIndex];
382 
383             // Move the last entry to the index where the entry to delete is
384             map._entries[toDeleteIndex] = lastEntry;
385             // Update the index for the moved entry
386             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
387 
388             // Delete the slot where the moved entry was stored
389             map._entries.pop();
390 
391             // Delete the index for the deleted slot
392             delete map._indexes[key];
393 
394             return true;
395         } else {
396             return false;
397         }
398     }
399 
400     /**
401      * @dev Returns true if the key is in the map. O(1).
402      */
403     function _contains(Map storage map, bytes32 key)
404         private
405         view
406         returns (bool)
407     {
408         return map._indexes[key] != 0;
409     }
410 
411     /**
412      * @dev Returns the number of key-value pairs in the map. O(1).
413      */
414     function _length(Map storage map) private view returns (uint256) {
415         return map._entries.length;
416     }
417 
418     /**
419      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
420      *
421      * Note that there are no guarantees on the ordering of entries inside the
422      * array, and it may change when more entries are added or removed.
423      *
424      * Requirements:
425      *
426      * - `index` must be strictly less than {length}.
427      */
428     function _at(Map storage map, uint256 index)
429         private
430         view
431         returns (bytes32, bytes32)
432     {
433         require(
434             map._entries.length > index,
435             "EnumerableMap: index out of bounds"
436         );
437 
438         MapEntry storage entry = map._entries[index];
439         return (entry._key, entry._value);
440     }
441 
442     /**
443      * @dev Tries to returns the value associated with `key`.  O(1).
444      * Does not revert if `key` is not in the map.
445      */
446     function _tryGet(Map storage map, bytes32 key)
447         private
448         view
449         returns (bool, bytes32)
450     {
451         uint256 keyIndex = map._indexes[key];
452         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
453         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
454     }
455 
456     /**
457      * @dev Returns the value associated with `key`.  O(1).
458      *
459      * Requirements:
460      *
461      * - `key` must be in the map.
462      */
463     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
464         uint256 keyIndex = map._indexes[key];
465         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
466         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
467     }
468 
469     /**
470      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
471      *
472      * CAUTION: This function is deprecated because it requires allocating memory for the error
473      * message unnecessarily. For custom revert reasons use {_tryGet}.
474      */
475     function _get(
476         Map storage map,
477         bytes32 key,
478         string memory errorMessage
479     ) private view returns (bytes32) {
480         uint256 keyIndex = map._indexes[key];
481         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
482         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
483     }
484 
485     // UintToAddressMap
486 
487     struct UintToAddressMap {
488         Map _inner;
489     }
490 
491     /**
492      * @dev Adds a key-value pair to a map, or updates the value for an existing
493      * key. O(1).
494      *
495      * Returns true if the key was added to the map, that is if it was not
496      * already present.
497      */
498     function set(
499         UintToAddressMap storage map,
500         uint256 key,
501         address value
502     ) internal returns (bool) {
503         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
504     }
505 
506     /**
507      * @dev Removes a value from a set. O(1).
508      *
509      * Returns true if the key was removed from the map, that is if it was present.
510      */
511     function remove(UintToAddressMap storage map, uint256 key)
512         internal
513         returns (bool)
514     {
515         return _remove(map._inner, bytes32(key));
516     }
517 
518     /**
519      * @dev Returns true if the key is in the map. O(1).
520      */
521     function contains(UintToAddressMap storage map, uint256 key)
522         internal
523         view
524         returns (bool)
525     {
526         return _contains(map._inner, bytes32(key));
527     }
528 
529     /**
530      * @dev Returns the number of elements in the map. O(1).
531      */
532     function length(UintToAddressMap storage map)
533         internal
534         view
535         returns (uint256)
536     {
537         return _length(map._inner);
538     }
539 
540     /**
541      * @dev Returns the element stored at position `index` in the set. O(1).
542      * Note that there are no guarantees on the ordering of values inside the
543      * array, and it may change when more values are added or removed.
544      *
545      * Requirements:
546      *
547      * - `index` must be strictly less than {length}.
548      */
549     function at(UintToAddressMap storage map, uint256 index)
550         internal
551         view
552         returns (uint256, address)
553     {
554         (bytes32 key, bytes32 value) = _at(map._inner, index);
555         return (uint256(key), address(uint160(uint256(value))));
556     }
557 
558     /**
559      * @dev Tries to returns the value associated with `key`.  O(1).
560      * Does not revert if `key` is not in the map.
561      *
562      * _Available since v3.4._
563      */
564     function tryGet(UintToAddressMap storage map, uint256 key)
565         internal
566         view
567         returns (bool, address)
568     {
569         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
570         return (success, address(uint160(uint256(value))));
571     }
572 
573     /**
574      * @dev Returns the value associated with `key`.  O(1).
575      *
576      * Requirements:
577      *
578      * - `key` must be in the map.
579      */
580     function get(UintToAddressMap storage map, uint256 key)
581         internal
582         view
583         returns (address)
584     {
585         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
586     }
587 
588     /**
589      * @dev Same as {get}, with a custom error message when `key` is not in the map.
590      *
591      * CAUTION: This function is deprecated because it requires allocating memory for the error
592      * message unnecessarily. For custom revert reasons use {tryGet}.
593      */
594     function get(
595         UintToAddressMap storage map,
596         uint256 key,
597         string memory errorMessage
598     ) internal view returns (address) {
599         return
600             address(
601                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
602             );
603     }
604 }
605 
606 // Part: EnumerableSet
607 
608 /**
609  * @dev Library for managing
610  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
611  * types.
612  *
613  * Sets have the following properties:
614  *
615  * - Elements are added, removed, and checked for existence in constant time
616  * (O(1)).
617  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
618  *
619  * ```
620  * contract Example {
621  *     // Add the library methods
622  *     using EnumerableSet for EnumerableSet.AddressSet;
623  *
624  *     // Declare a set state variable
625  *     EnumerableSet.AddressSet private mySet;
626  * }
627  * ```
628  *
629  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
630  * and `uint256` (`UintSet`) are supported.
631  */
632 library EnumerableSet {
633     // To implement this library for multiple types with as little code
634     // repetition as possible, we write it in terms of a generic Set type with
635     // bytes32 values.
636     // The Set implementation uses private functions, and user-facing
637     // implementations (such as AddressSet) are just wrappers around the
638     // underlying Set.
639     // This means that we can only create new EnumerableSets for types that fit
640     // in bytes32.
641 
642     struct Set {
643         // Storage of set values
644         bytes32[] _values;
645         // Position of the value in the `values` array, plus 1 because index 0
646         // means a value is not in the set.
647         mapping(bytes32 => uint256) _indexes;
648     }
649 
650     /**
651      * @dev Add a value to a set. O(1).
652      *
653      * Returns true if the value was added to the set, that is if it was not
654      * already present.
655      */
656     function _add(Set storage set, bytes32 value) private returns (bool) {
657         if (!_contains(set, value)) {
658             set._values.push(value);
659             // The value is stored at length-1, but we add 1 to all indexes
660             // and use 0 as a sentinel value
661             set._indexes[value] = set._values.length;
662             return true;
663         } else {
664             return false;
665         }
666     }
667 
668     /**
669      * @dev Removes a value from a set. O(1).
670      *
671      * Returns true if the value was removed from the set, that is if it was
672      * present.
673      */
674     function _remove(Set storage set, bytes32 value) private returns (bool) {
675         // We read and store the value's index to prevent multiple reads from the same storage slot
676         uint256 valueIndex = set._indexes[value];
677 
678         if (valueIndex != 0) {
679             // Equivalent to contains(set, value)
680             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
681             // the array, and then remove the last element (sometimes called as 'swap and pop').
682             // This modifies the order of the array, as noted in {at}.
683 
684             uint256 toDeleteIndex = valueIndex - 1;
685             uint256 lastIndex = set._values.length - 1;
686 
687             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
688             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
689 
690             bytes32 lastvalue = set._values[lastIndex];
691 
692             // Move the last value to the index where the value to delete is
693             set._values[toDeleteIndex] = lastvalue;
694             // Update the index for the moved value
695             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
696 
697             // Delete the slot where the moved value was stored
698             set._values.pop();
699 
700             // Delete the index for the deleted slot
701             delete set._indexes[value];
702 
703             return true;
704         } else {
705             return false;
706         }
707     }
708 
709     /**
710      * @dev Returns true if the value is in the set. O(1).
711      */
712     function _contains(Set storage set, bytes32 value)
713         private
714         view
715         returns (bool)
716     {
717         return set._indexes[value] != 0;
718     }
719 
720     /**
721      * @dev Returns the number of values on the set. O(1).
722      */
723     function _length(Set storage set) private view returns (uint256) {
724         return set._values.length;
725     }
726 
727     /**
728      * @dev Returns the value stored at position `index` in the set. O(1).
729      *
730      * Note that there are no guarantees on the ordering of values inside the
731      * array, and it may change when more values are added or removed.
732      *
733      * Requirements:
734      *
735      * - `index` must be strictly less than {length}.
736      */
737     function _at(Set storage set, uint256 index)
738         private
739         view
740         returns (bytes32)
741     {
742         require(
743             set._values.length > index,
744             "EnumerableSet: index out of bounds"
745         );
746         return set._values[index];
747     }
748 
749     // Bytes32Set
750 
751     struct Bytes32Set {
752         Set _inner;
753     }
754 
755     /**
756      * @dev Add a value to a set. O(1).
757      *
758      * Returns true if the value was added to the set, that is if it was not
759      * already present.
760      */
761     function add(Bytes32Set storage set, bytes32 value)
762         internal
763         returns (bool)
764     {
765         return _add(set._inner, value);
766     }
767 
768     /**
769      * @dev Removes a value from a set. O(1).
770      *
771      * Returns true if the value was removed from the set, that is if it was
772      * present.
773      */
774     function remove(Bytes32Set storage set, bytes32 value)
775         internal
776         returns (bool)
777     {
778         return _remove(set._inner, value);
779     }
780 
781     /**
782      * @dev Returns true if the value is in the set. O(1).
783      */
784     function contains(Bytes32Set storage set, bytes32 value)
785         internal
786         view
787         returns (bool)
788     {
789         return _contains(set._inner, value);
790     }
791 
792     /**
793      * @dev Returns the number of values in the set. O(1).
794      */
795     function length(Bytes32Set storage set) internal view returns (uint256) {
796         return _length(set._inner);
797     }
798 
799     /**
800      * @dev Returns the value stored at position `index` in the set. O(1).
801      *
802      * Note that there are no guarantees on the ordering of values inside the
803      * array, and it may change when more values are added or removed.
804      *
805      * Requirements:
806      *
807      * - `index` must be strictly less than {length}.
808      */
809     function at(Bytes32Set storage set, uint256 index)
810         internal
811         view
812         returns (bytes32)
813     {
814         return _at(set._inner, index);
815     }
816 
817     // AddressSet
818 
819     struct AddressSet {
820         Set _inner;
821     }
822 
823     /**
824      * @dev Add a value to a set. O(1).
825      *
826      * Returns true if the value was added to the set, that is if it was not
827      * already present.
828      */
829     function add(AddressSet storage set, address value)
830         internal
831         returns (bool)
832     {
833         return _add(set._inner, bytes32(uint256(uint160(value))));
834     }
835 
836     /**
837      * @dev Removes a value from a set. O(1).
838      *
839      * Returns true if the value was removed from the set, that is if it was
840      * present.
841      */
842     function remove(AddressSet storage set, address value)
843         internal
844         returns (bool)
845     {
846         return _remove(set._inner, bytes32(uint256(uint160(value))));
847     }
848 
849     /**
850      * @dev Returns true if the value is in the set. O(1).
851      */
852     function contains(AddressSet storage set, address value)
853         internal
854         view
855         returns (bool)
856     {
857         return _contains(set._inner, bytes32(uint256(uint160(value))));
858     }
859 
860     /**
861      * @dev Returns the number of values in the set. O(1).
862      */
863     function length(AddressSet storage set) internal view returns (uint256) {
864         return _length(set._inner);
865     }
866 
867     /**
868      * @dev Returns the value stored at position `index` in the set. O(1).
869      *
870      * Note that there are no guarantees on the ordering of values inside the
871      * array, and it may change when more values are added or removed.
872      *
873      * Requirements:
874      *
875      * - `index` must be strictly less than {length}.
876      */
877     function at(AddressSet storage set, uint256 index)
878         internal
879         view
880         returns (address)
881     {
882         return address(uint160(uint256(_at(set._inner, index))));
883     }
884 
885     // UintSet
886 
887     struct UintSet {
888         Set _inner;
889     }
890 
891     /**
892      * @dev Add a value to a set. O(1).
893      *
894      * Returns true if the value was added to the set, that is if it was not
895      * already present.
896      */
897     function add(UintSet storage set, uint256 value) internal returns (bool) {
898         return _add(set._inner, bytes32(value));
899     }
900 
901     /**
902      * @dev Removes a value from a set. O(1).
903      *
904      * Returns true if the value was removed from the set, that is if it was
905      * present.
906      */
907     function remove(UintSet storage set, uint256 value)
908         internal
909         returns (bool)
910     {
911         return _remove(set._inner, bytes32(value));
912     }
913 
914     /**
915      * @dev Returns true if the value is in the set. O(1).
916      */
917     function contains(UintSet storage set, uint256 value)
918         internal
919         view
920         returns (bool)
921     {
922         return _contains(set._inner, bytes32(value));
923     }
924 
925     /**
926      * @dev Returns the number of values on the set. O(1).
927      */
928     function length(UintSet storage set) internal view returns (uint256) {
929         return _length(set._inner);
930     }
931 
932     /**
933      * @dev Returns the value stored at position `index` in the set. O(1).
934      *
935      * Note that there are no guarantees on the ordering of values inside the
936      * array, and it may change when more values are added or removed.
937      *
938      * Requirements:
939      *
940      * - `index` must be strictly less than {length}.
941      */
942     function at(UintSet storage set, uint256 index)
943         internal
944         view
945         returns (uint256)
946     {
947         return uint256(_at(set._inner, index));
948     }
949 }
950 
951 // Part: IERC165
952 
953 /**
954  * @dev Interface of the ERC165 standard, as defined in the
955  * https://eips.ethereum.org/EIPS/eip-165[EIP].
956  *
957  * Implementers can declare support of contract interfaces, which can then be
958  * queried by others ({ERC165Checker}).
959  *
960  * For an implementation, see {ERC165}.
961  */
962 interface IERC165 {
963     /**
964      * @dev Returns true if this contract implements the interface defined by
965      * `interfaceId`. See the corresponding
966      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
967      * to learn more about how these ids are created.
968      *
969      * This function call must use less than 30 000 gas.
970      */
971     function supportsInterface(bytes4 interfaceId) external view returns (bool);
972 }
973 
974 // Part: IERC721Receiver
975 
976 /**
977  * @title ERC721 token receiver interface
978  * @dev Interface for any contract that wants to support safeTransfers
979  * from ERC721 asset contracts.
980  */
981 interface IERC721Receiver {
982     /**
983      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
984      * by `operator` from `from`, this function is called.
985      *
986      * It must return its Solidity selector to confirm the token transfer.
987      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
988      *
989      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
990      */
991     function onERC721Received(
992         address operator,
993         address from,
994         uint256 tokenId,
995         bytes calldata data
996     ) external returns (bytes4);
997 }
998 
999 // Part: Roles
1000 
1001 library Roles {
1002   struct Role {
1003     mapping (address => bool) bearer;
1004   }
1005 
1006   /**
1007    * @dev give an account access to this role
1008    */
1009   function add(Role storage role, address account) internal {
1010     require(account != address(0));
1011     require(!has(role, account));
1012 
1013     role.bearer[account] = true;
1014   }
1015 
1016   /**
1017    * @dev remove an account's access to this role
1018    */
1019   function remove(Role storage role, address account) internal {
1020     require(account != address(0));
1021     require(has(role, account));
1022 
1023     role.bearer[account] = false;
1024   }
1025 
1026   /**
1027    * @dev check if an account has this role
1028    * @return bool
1029    */
1030   function has(Role storage role, address account)
1031     internal
1032     view
1033     returns (bool)
1034   {
1035     require(account != address(0));
1036     return role.bearer[account];
1037   }
1038 }
1039 
1040 // Part: SafeMath
1041 
1042 /**
1043  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1044  * checks.
1045  *
1046  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1047  * in bugs, because programmers usually assume that an overflow raises an
1048  * error, which is the standard behavior in high level programming languages.
1049  * `SafeMath` restores this intuition by reverting the transaction when an
1050  * operation overflows.
1051  *
1052  * Using this library instead of the unchecked operations eliminates an entire
1053  * class of bugs, so it's recommended to use it always.
1054  */
1055 library SafeMath {
1056     /**
1057      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1058      *
1059      * _Available since v3.4._
1060      */
1061     function tryAdd(uint256 a, uint256 b)
1062         internal
1063         pure
1064         returns (bool, uint256)
1065     {
1066         uint256 c = a + b;
1067         if (c < a) return (false, 0);
1068         return (true, c);
1069     }
1070 
1071     /**
1072      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1073      *
1074      * _Available since v3.4._
1075      */
1076     function trySub(uint256 a, uint256 b)
1077         internal
1078         pure
1079         returns (bool, uint256)
1080     {
1081         if (b > a) return (false, 0);
1082         return (true, a - b);
1083     }
1084 
1085     /**
1086      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1087      *
1088      * _Available since v3.4._
1089      */
1090     function tryMul(uint256 a, uint256 b)
1091         internal
1092         pure
1093         returns (bool, uint256)
1094     {
1095         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1096         // benefit is lost if 'b' is also tested.
1097         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1098         if (a == 0) return (true, 0);
1099         uint256 c = a * b;
1100         if (c / a != b) return (false, 0);
1101         return (true, c);
1102     }
1103 
1104     /**
1105      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1106      *
1107      * _Available since v3.4._
1108      */
1109     function tryDiv(uint256 a, uint256 b)
1110         internal
1111         pure
1112         returns (bool, uint256)
1113     {
1114         if (b == 0) return (false, 0);
1115         return (true, a / b);
1116     }
1117 
1118     /**
1119      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1120      *
1121      * _Available since v3.4._
1122      */
1123     function tryMod(uint256 a, uint256 b)
1124         internal
1125         pure
1126         returns (bool, uint256)
1127     {
1128         if (b == 0) return (false, 0);
1129         return (true, a % b);
1130     }
1131 
1132     /**
1133      * @dev Returns the addition of two unsigned integers, reverting on
1134      * overflow.
1135      *
1136      * Counterpart to Solidity's `+` operator.
1137      *
1138      * Requirements:
1139      *
1140      * - Addition cannot overflow.
1141      */
1142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1143         uint256 c = a + b;
1144         require(c >= a, "SafeMath: addition overflow");
1145         return c;
1146     }
1147 
1148     /**
1149      * @dev Returns the subtraction of two unsigned integers, reverting on
1150      * overflow (when the result is negative).
1151      *
1152      * Counterpart to Solidity's `-` operator.
1153      *
1154      * Requirements:
1155      *
1156      * - Subtraction cannot overflow.
1157      */
1158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1159         require(b <= a, "SafeMath: subtraction overflow");
1160         return a - b;
1161     }
1162 
1163     /**
1164      * @dev Returns the multiplication of two unsigned integers, reverting on
1165      * overflow.
1166      *
1167      * Counterpart to Solidity's `*` operator.
1168      *
1169      * Requirements:
1170      *
1171      * - Multiplication cannot overflow.
1172      */
1173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1174         if (a == 0) return 0;
1175         uint256 c = a * b;
1176         require(c / a == b, "SafeMath: multiplication overflow");
1177         return c;
1178     }
1179 
1180     /**
1181      * @dev Returns the integer division of two unsigned integers, reverting on
1182      * division by zero. The result is rounded towards zero.
1183      *
1184      * Counterpart to Solidity's `/` operator. Note: this function uses a
1185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1186      * uses an invalid opcode to revert (consuming all remaining gas).
1187      *
1188      * Requirements:
1189      *
1190      * - The divisor cannot be zero.
1191      */
1192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1193         require(b > 0, "SafeMath: division by zero");
1194         return a / b;
1195     }
1196 
1197     /**
1198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1199      * reverting when dividing by zero.
1200      *
1201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1202      * opcode (which leaves remaining gas untouched) while Solidity uses an
1203      * invalid opcode to revert (consuming all remaining gas).
1204      *
1205      * Requirements:
1206      *
1207      * - The divisor cannot be zero.
1208      */
1209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1210         require(b > 0, "SafeMath: modulo by zero");
1211         return a % b;
1212     }
1213 
1214     /**
1215      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1216      * overflow (when the result is negative).
1217      *
1218      * CAUTION: This function is deprecated because it requires allocating memory for the error
1219      * message unnecessarily. For custom revert reasons use {trySub}.
1220      *
1221      * Counterpart to Solidity's `-` operator.
1222      *
1223      * Requirements:
1224      *
1225      * - Subtraction cannot overflow.
1226      */
1227     function sub(
1228         uint256 a,
1229         uint256 b,
1230         string memory errorMessage
1231     ) internal pure returns (uint256) {
1232         require(b <= a, errorMessage);
1233         return a - b;
1234     }
1235 
1236     /**
1237      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1238      * division by zero. The result is rounded towards zero.
1239      *
1240      * CAUTION: This function is deprecated because it requires allocating memory for the error
1241      * message unnecessarily. For custom revert reasons use {tryDiv}.
1242      *
1243      * Counterpart to Solidity's `/` operator. Note: this function uses a
1244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1245      * uses an invalid opcode to revert (consuming all remaining gas).
1246      *
1247      * Requirements:
1248      *
1249      * - The divisor cannot be zero.
1250      */
1251     function div(
1252         uint256 a,
1253         uint256 b,
1254         string memory errorMessage
1255     ) internal pure returns (uint256) {
1256         require(b > 0, errorMessage);
1257         return a / b;
1258     }
1259 
1260     /**
1261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1262      * reverting with custom message when dividing by zero.
1263      *
1264      * CAUTION: This function is deprecated because it requires allocating memory for the error
1265      * message unnecessarily. For custom revert reasons use {tryMod}.
1266      *
1267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1268      * opcode (which leaves remaining gas untouched) while Solidity uses an
1269      * invalid opcode to revert (consuming all remaining gas).
1270      *
1271      * Requirements:
1272      *
1273      * - The divisor cannot be zero.
1274      */
1275     function mod(
1276         uint256 a,
1277         uint256 b,
1278         string memory errorMessage
1279     ) internal pure returns (uint256) {
1280         require(b > 0, errorMessage);
1281         return a % b;
1282     }
1283 }
1284 
1285 // Part: Strings
1286 
1287 /**
1288  * @dev String operations.
1289  */
1290 library Strings {
1291     /**
1292      * @dev Converts a `uint256` to its ASCII `string` representation.
1293      */
1294     function toString(uint256 value) internal pure returns (string memory) {
1295         // Inspired by OraclizeAPI's implementation - MIT licence
1296         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1297 
1298         if (value == 0) {
1299             return "0";
1300         }
1301         uint256 temp = value;
1302         uint256 digits;
1303         while (temp != 0) {
1304             digits++;
1305             temp /= 10;
1306         }
1307         bytes memory buffer = new bytes(digits);
1308         uint256 index = digits - 1;
1309         temp = value;
1310         while (temp != 0) {
1311             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1312             temp /= 10;
1313         }
1314         return string(buffer);
1315     }
1316 }
1317 
1318 // Part: ERC165
1319 
1320 /**
1321  * @dev Implementation of the {IERC165} interface.
1322  *
1323  * Contracts may inherit from this and call {_registerInterface} to declare
1324  * their support of an interface.
1325  */
1326 abstract contract ERC165 is IERC165 {
1327     /*
1328      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1329      */
1330     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1331 
1332     /**
1333      * @dev Mapping of interface ids to whether or not it's supported.
1334      */
1335     mapping(bytes4 => bool) private _supportedInterfaces;
1336 
1337     constructor() internal {
1338         // Derived contracts need only register support for their own interfaces,
1339         // we register support for ERC165 itself here
1340         _registerInterface(_INTERFACE_ID_ERC165);
1341     }
1342 
1343     /**
1344      * @dev See {IERC165-supportsInterface}.
1345      *
1346      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1347      */
1348     function supportsInterface(bytes4 interfaceId)
1349         public
1350         view
1351         virtual
1352         override
1353         returns (bool)
1354     {
1355         return _supportedInterfaces[interfaceId];
1356     }
1357 
1358     /**
1359      * @dev Registers the contract as an implementer of the interface defined by
1360      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1361      * registering its interface id is not required.
1362      *
1363      * See {IERC165-supportsInterface}.
1364      *
1365      * Requirements:
1366      *
1367      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1368      */
1369     function _registerInterface(bytes4 interfaceId) internal virtual {
1370         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1371         _supportedInterfaces[interfaceId] = true;
1372     }
1373 }
1374 
1375 // Part: IERC721
1376 
1377 /**
1378  * @dev Required interface of an ERC721 compliant contract.
1379  */
1380 interface IERC721 is IERC165 {
1381     /**
1382      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1383      */
1384     event Transfer(
1385         address indexed from,
1386         address indexed to,
1387         uint256 indexed tokenId
1388     );
1389 
1390     /**
1391      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1392      */
1393     event Approval(
1394         address indexed owner,
1395         address indexed approved,
1396         uint256 indexed tokenId
1397     );
1398 
1399     /**
1400      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1401      */
1402     event ApprovalForAll(
1403         address indexed owner,
1404         address indexed operator,
1405         bool approved
1406     );
1407 
1408     /**
1409      * @dev Returns the number of tokens in ``owner``'s account.
1410      */
1411     function balanceOf(address owner) external view returns (uint256 balance);
1412 
1413     /**
1414      * @dev Returns the owner of the `tokenId` token.
1415      *
1416      * Requirements:
1417      *
1418      * - `tokenId` must exist.
1419      */
1420     function ownerOf(uint256 tokenId) external view returns (address owner);
1421 
1422     /**
1423      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1424      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1425      *
1426      * Requirements:
1427      *
1428      * - `from` cannot be the zero address.
1429      * - `to` cannot be the zero address.
1430      * - `tokenId` token must exist and be owned by `from`.
1431      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function safeTransferFrom(
1437         address from,
1438         address to,
1439         uint256 tokenId
1440     ) external;
1441 
1442     /**
1443      * @dev Transfers `tokenId` token from `from` to `to`.
1444      *
1445      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1446      *
1447      * Requirements:
1448      *
1449      * - `from` cannot be the zero address.
1450      * - `to` cannot be the zero address.
1451      * - `tokenId` token must be owned by `from`.
1452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1453      *
1454      * Emits a {Transfer} event.
1455      */
1456     function transferFrom(
1457         address from,
1458         address to,
1459         uint256 tokenId
1460     ) external;
1461 
1462     /**
1463      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1464      * The approval is cleared when the token is transferred.
1465      *
1466      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1467      *
1468      * Requirements:
1469      *
1470      * - The caller must own the token or be an approved operator.
1471      * - `tokenId` must exist.
1472      *
1473      * Emits an {Approval} event.
1474      */
1475     function approve(address to, uint256 tokenId) external;
1476 
1477     /**
1478      * @dev Returns the account approved for `tokenId` token.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      */
1484     function getApproved(uint256 tokenId)
1485         external
1486         view
1487         returns (address operator);
1488 
1489     /**
1490      * @dev Approve or remove `operator` as an operator for the caller.
1491      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1492      *
1493      * Requirements:
1494      *
1495      * - The `operator` cannot be the caller.
1496      *
1497      * Emits an {ApprovalForAll} event.
1498      */
1499     function setApprovalForAll(address operator, bool _approved) external;
1500 
1501     /**
1502      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1503      *
1504      * See {setApprovalForAll}
1505      */
1506     function isApprovedForAll(address owner, address operator)
1507         external
1508         view
1509         returns (bool);
1510 
1511     /**
1512      * @dev Safely transfers `tokenId` token from `from` to `to`.
1513      *
1514      * Requirements:
1515      *
1516      * - `from` cannot be the zero address.
1517      * - `to` cannot be the zero address.
1518      * - `tokenId` token must exist and be owned by `from`.
1519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1520      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1521      *
1522      * Emits a {Transfer} event.
1523      */
1524     function safeTransferFrom(
1525         address from,
1526         address to,
1527         uint256 tokenId,
1528         bytes calldata data
1529     ) external;
1530 }
1531 
1532 // Part: Ownable
1533 
1534 /**
1535  * @dev Contract module which provides a basic access control mechanism, where
1536  * there is an account (an owner) that can be granted exclusive access to
1537  * specific functions.
1538  *
1539  * By default, the owner account will be the one that deploys the contract. This
1540  * can later be changed with {transferOwnership}.
1541  *
1542  * This module is used through inheritance. It will make available the modifier
1543  * `onlyOwner`, which can be applied to your functions to restrict their use to
1544  * the owner.
1545  */
1546 abstract contract Ownable is Context {
1547     address private _owner;
1548 
1549     event OwnershipTransferred(
1550         address indexed previousOwner,
1551         address indexed newOwner
1552     );
1553 
1554     /**
1555      * @dev Initializes the contract setting the deployer as the initial owner.
1556      */
1557     constructor() internal {
1558         address msgSender = _msgSender();
1559         _owner = msgSender;
1560         emit OwnershipTransferred(address(0), msgSender);
1561     }
1562 
1563     /**
1564      * @dev Returns the address of the current owner.
1565      */
1566     function owner() public view virtual returns (address) {
1567         return _owner;
1568     }
1569 
1570     /**
1571      * @dev Throws if called by any account other than the owner.
1572      */
1573     modifier onlyOwner() {
1574         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1575         _;
1576     }
1577 
1578     /**
1579      * @dev Leaves the contract without owner. It will not be possible to call
1580      * `onlyOwner` functions anymore. Can only be called by the current owner.
1581      *
1582      * NOTE: Renouncing ownership will leave the contract without an owner,
1583      * thereby removing any functionality that is only available to the owner.
1584      */
1585     function renounceOwnership() public virtual onlyOwner {
1586         emit OwnershipTransferred(_owner, address(0));
1587         _owner = address(0);
1588     }
1589 
1590     /**
1591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1592      * Can only be called by the current owner.
1593      */
1594     function transferOwnership(address newOwner) public virtual onlyOwner {
1595         require(
1596             newOwner != address(0),
1597             "Ownable: new owner is the zero address"
1598         );
1599         emit OwnershipTransferred(_owner, newOwner);
1600         _owner = newOwner;
1601     }
1602 }
1603 
1604 // Part: IERC721Enumerable
1605 
1606 /**
1607  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1608  * @dev See https://eips.ethereum.org/EIPS/eip-721
1609  */
1610 interface IERC721Enumerable is IERC721 {
1611     /**
1612      * @dev Returns the total amount of tokens stored by the contract.
1613      */
1614     function totalSupply() external view returns (uint256);
1615 
1616     /**
1617      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1618      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1619      */
1620     function tokenOfOwnerByIndex(address owner, uint256 index)
1621         external
1622         view
1623         returns (uint256 tokenId);
1624 
1625     /**
1626      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1627      * Use along with {totalSupply} to enumerate all tokens.
1628      */
1629     function tokenByIndex(uint256 index) external view returns (uint256);
1630 }
1631 
1632 // Part: IERC721Metadata
1633 
1634 /**
1635  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1636  * @dev See https://eips.ethereum.org/EIPS/eip-721
1637  */
1638 interface IERC721Metadata is IERC721 {
1639     /**
1640      * @dev Returns the token collection name.
1641      */
1642     function name() external view returns (string memory);
1643 
1644     /**
1645      * @dev Returns the token collection symbol.
1646      */
1647     function symbol() external view returns (string memory);
1648 
1649     /**
1650      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1651      */
1652     function tokenURI(uint256 tokenId) external view returns (string memory);
1653 }
1654 
1655 // Part: RBAC
1656 
1657 contract RBAC is Ownable {
1658   using Roles for Roles.Role;
1659 
1660   Roles.Role private preminters;
1661 
1662 
1663   function addPreminter(address _newPreminter) external onlyOwner{
1664     preminters.add(_newPreminter);
1665   }
1666 
1667   function addPremintList(address[] memory list) external onlyOwner{
1668     for(uint i = 0; i < 420; i++)
1669     {
1670       preminters.add(list[i]);
1671     }
1672   }
1673 
1674   function isPreminter(address toCheck) public view returns(bool)
1675   {
1676     return preminters.has(toCheck);
1677   }
1678 
1679   modifier onlyPreminter()
1680   {
1681     require(preminters.has(msg.sender) == true, "Must be eligible for premint");
1682     _;
1683   }
1684 }
1685 
1686 // Part: ERC721
1687 
1688 /**
1689  * @title ERC721 Non-Fungible Token Standard basic implementation
1690  * @dev see https://eips.ethereum.org/EIPS/eip-721
1691  */
1692 
1693 contract ERC721 is
1694     Context,
1695     ERC165,
1696     IERC721,
1697     IERC721Metadata,
1698     IERC721Enumerable
1699 {
1700     using SafeMath for uint256;
1701     using Address for address;
1702     using EnumerableSet for EnumerableSet.UintSet;
1703     using EnumerableMap for EnumerableMap.UintToAddressMap;
1704     using Strings for uint256;
1705 
1706     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1707     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1708     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1709 
1710     // Mapping from holder address to their (enumerable) set of owned tokens
1711     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1712 
1713     // Enumerable mapping from token ids to their owners
1714     EnumerableMap.UintToAddressMap private _tokenOwners;
1715 
1716     // Mapping from token ID to approved address
1717     mapping(uint256 => address) private _tokenApprovals;
1718 
1719     // Mapping from owner to operator approvals
1720     mapping(address => mapping(address => bool)) private _operatorApprovals;
1721 
1722     // Token name
1723     string private _name;
1724 
1725     // Token symbol
1726     string private _symbol;
1727 
1728     // Optional mapping for token URIs
1729     mapping(uint256 => string) private _tokenURIs;
1730 
1731     // Base URI
1732     string private _baseURI;
1733 
1734     /*
1735      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1736      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1737      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1738      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1739      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1740      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1741      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1742      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1743      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1744      *
1745      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1746      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1747      */
1748     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1749 
1750     /*
1751      *     bytes4(keccak256('name()')) == 0x06fdde03
1752      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1753      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1754      *
1755      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1756      */
1757     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1758 
1759     /*
1760      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1761      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1762      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1763      *
1764      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1765      */
1766     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1767 
1768     /**
1769      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1770      */
1771     constructor(string memory name_, string memory symbol_) public {
1772         _name = name_;
1773         _symbol = symbol_;
1774 
1775         // register the supported interfaces to conform to ERC721 via ERC165
1776         _registerInterface(_INTERFACE_ID_ERC721);
1777         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1778         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1779     }
1780 
1781     /**
1782      * @dev See {IERC721-balanceOf}.
1783      */
1784     function balanceOf(address owner)
1785         public
1786         view
1787         virtual
1788         override
1789         returns (uint256)
1790     {
1791         require(
1792             owner != address(0),
1793             "ERC721: balance query for the zero address"
1794         );
1795         return _holderTokens[owner].length();
1796     }
1797 
1798     /**
1799      * @dev See {IERC721-ownerOf}.
1800      */
1801     function ownerOf(uint256 tokenId)
1802         public
1803         view
1804         virtual
1805         override
1806         returns (address)
1807     {
1808         return
1809             _tokenOwners.get(
1810                 tokenId,
1811                 "ERC721: owner query for nonexistent token"
1812             );
1813     }
1814 
1815     /**
1816      * @dev See {IERC721Metadata-name}.
1817      */
1818     function name() public view virtual override returns (string memory) {
1819         return _name;
1820     }
1821 
1822     /**
1823      * @dev See {IERC721Metadata-symbol}.
1824      */
1825     function symbol() public view virtual override returns (string memory) {
1826         return _symbol;
1827     }
1828 
1829     /**
1830      * @dev See {IERC721Metadata-tokenURI}.
1831      */
1832     function tokenURI(uint256 tokenId)
1833         public
1834         view
1835         virtual
1836         override
1837         returns (string memory)
1838     {
1839         require(
1840             _exists(tokenId),
1841             "ERC721Metadata: URI query for nonexistent token"
1842         );
1843 
1844         string memory _tokenURI = _tokenURIs[tokenId];
1845         string memory base = _baseURI;
1846 
1847         // If there is no base URI, return the token URI.
1848         if (bytes(base).length == 0) {
1849             return _tokenURI;
1850         }
1851         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1852         if (bytes(_tokenURI).length > 0) {
1853             return string(abi.encodePacked(base, _tokenURI));
1854         }
1855         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1856         return string(abi.encodePacked(base, tokenId.toString()));
1857     }
1858 
1859     /**
1860      * @dev Returns the base URI set via {_setBaseURI}. This will be
1861      * automatically added as a prefix in {tokenURI} to each token's URI, or
1862      * to the token ID if no specific URI is set for that token ID.
1863      */
1864     //function baseURI() public view virtual returns (string memory) {
1865     //    return _baseURI;
1866     //}
1867 
1868     /**
1869      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1870      */
1871     function tokenOfOwnerByIndex(address owner, uint256 index)
1872         public
1873         view
1874         virtual
1875         override
1876         returns (uint256)
1877     {
1878         return _holderTokens[owner].at(index);
1879     }
1880 
1881     /**
1882      * @dev See {IERC721Enumerable-totalSupply}.
1883      */
1884     function totalSupply() public view virtual override returns (uint256) {
1885         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1886         return _tokenOwners.length();
1887     }
1888 
1889     /**
1890      * @dev See {IERC721Enumerable-tokenByIndex}.
1891      */
1892     function tokenByIndex(uint256 index)
1893         public
1894         view
1895         virtual
1896         override
1897         returns (uint256)
1898     {
1899         (uint256 tokenId, ) = _tokenOwners.at(index);
1900         return tokenId;
1901     }
1902 
1903     /**
1904      * @dev See {IERC721-approve}.
1905      */
1906     function approve(address to, uint256 tokenId) public virtual override {
1907         address owner = ERC721.ownerOf(tokenId);
1908         require(to != owner, "ERC721: approval to current owner");
1909 
1910         require(
1911             _msgSender() == owner ||
1912                 ERC721.isApprovedForAll(owner, _msgSender()),
1913             "ERC721: approve caller is not owner nor approved for all"
1914         );
1915 
1916         _approve(to, tokenId);
1917     }
1918 
1919     /**
1920      * @dev See {IERC721-getApproved}.
1921      */
1922     function getApproved(uint256 tokenId)
1923         public
1924         view
1925         virtual
1926         override
1927         returns (address)
1928     {
1929         require(
1930             _exists(tokenId),
1931             "ERC721: approved query for nonexistent token"
1932         );
1933 
1934         return _tokenApprovals[tokenId];
1935     }
1936 
1937     /**
1938      * @dev See {IERC721-setApprovalForAll}.
1939      */
1940     function setApprovalForAll(address operator, bool approved)
1941         public
1942         virtual
1943         override
1944     {
1945         require(operator != _msgSender(), "ERC721: approve to caller");
1946 
1947         _operatorApprovals[_msgSender()][operator] = approved;
1948         emit ApprovalForAll(_msgSender(), operator, approved);
1949     }
1950 
1951     /**
1952      * @dev See {IERC721-isApprovedForAll}.
1953      */
1954     function isApprovedForAll(address owner, address operator)
1955         public
1956         view
1957         virtual
1958         override
1959         returns (bool)
1960     {
1961         return _operatorApprovals[owner][operator];
1962     }
1963 
1964     /**
1965      * @dev See {IERC721-transferFrom}.
1966      */
1967     function transferFrom(
1968         address from,
1969         address to,
1970         uint256 tokenId
1971     ) public virtual override {
1972         //solhint-disable-next-line max-line-length
1973         require(
1974             _isApprovedOrOwner(_msgSender(), tokenId),
1975             "ERC721: transfer caller is not owner nor approved"
1976         );
1977 
1978         _transfer(from, to, tokenId);
1979     }
1980 
1981     /**
1982      * @dev See {IERC721-safeTransferFrom}.
1983      */
1984     function safeTransferFrom(
1985         address from,
1986         address to,
1987         uint256 tokenId
1988     ) public virtual override {
1989         safeTransferFrom(from, to, tokenId, "");
1990     }
1991 
1992     /**
1993      * @dev See {IERC721-safeTransferFrom}.
1994      */
1995     function safeTransferFrom(
1996         address from,
1997         address to,
1998         uint256 tokenId,
1999         bytes memory _data
2000     ) public virtual override {
2001         require(
2002             _isApprovedOrOwner(_msgSender(), tokenId),
2003             "ERC721: transfer caller is not owner nor approved"
2004         );
2005         _safeTransfer(from, to, tokenId, _data);
2006     }
2007 
2008     /**
2009      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2010      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2011      *
2012      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2013      *
2014      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2015      * implement alternative mechanisms to perform token transfer, such as signature-based.
2016      *
2017      * Requirements:
2018      *
2019      * - `from` cannot be the zero address.
2020      * - `to` cannot be the zero address.
2021      * - `tokenId` token must exist and be owned by `from`.
2022      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2023      *
2024      * Emits a {Transfer} event.
2025      */
2026     function _safeTransfer(
2027         address from,
2028         address to,
2029         uint256 tokenId,
2030         bytes memory _data
2031     ) internal virtual {
2032         _transfer(from, to, tokenId);
2033         require(
2034             _checkOnERC721Received(from, to, tokenId, _data),
2035             "ERC721: transfer to non ERC721Receiver implementer"
2036         );
2037     }
2038 
2039     /**
2040      * @dev Returns whether `tokenId` exists.
2041      *
2042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2043      *
2044      * Tokens start existing when they are minted (`_mint`),
2045      * and stop existing when they are burned (`_burn`).
2046      */
2047     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2048         return _tokenOwners.contains(tokenId);
2049     }
2050 
2051     /**
2052      * @dev Returns whether `spender` is allowed to manage `tokenId` using FLACKO.
2053      *
2054      * Requirements:
2055      *
2056      * - `tokenId` must exist.
2057      */
2058     function _isApprovedOrOwner(address spender, uint256 tokenId)
2059         internal
2060         view
2061         virtual
2062         returns (bool)
2063     {
2064         require(
2065             _exists(tokenId),
2066             "ERC721: operator query for nonexistent token"
2067         );
2068         address owner = ERC721.ownerOf(tokenId);
2069         return (spender == owner ||
2070             getApproved(tokenId) == spender ||
2071             ERC721.isApprovedForAll(owner, spender));
2072     }
2073 
2074     /**
2075      * @dev Safely mints `tokenId` and transfers it to `to`.
2076      *
2077      * Requirements:
2078      d*
2079      * - `tokenId` must not exist.
2080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2081      *
2082      * Emits a {Transfer} event.
2083      */
2084     function _safeMint(address to, uint256 tokenId) internal virtual {
2085         _safeMint(to, tokenId, "");
2086     }
2087 
2088     /**
2089      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2090      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2091      */
2092     function _safeMint(
2093         address to,
2094         uint256 tokenId,
2095         bytes memory _data
2096     ) internal virtual {
2097         _mint(to, tokenId);
2098         require(
2099             _checkOnERC721Received(address(0), to, tokenId, _data),
2100             "ERC721: transfer to non ERC721Receiver implementer"
2101         );
2102     }
2103 
2104     /**
2105      * @dev Mints `tokenId` and transfers it to `to`.
2106      *
2107      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2108      *
2109      * Requirements:
2110      *
2111      * - `tokenId` must not exist.
2112      * - `to` cannot be the zero address.
2113      *
2114      * Emits a {Transfer} event.
2115      */
2116     function _mint(address to, uint256 tokenId) internal virtual {
2117         require(to != address(0), "ERC721: mint to the zero address");
2118         require(!_exists(tokenId), "ERC721: token already minted");
2119 
2120         _beforeTokenTransfer(address(0), to, tokenId);
2121 
2122         _holderTokens[to].add(tokenId);
2123 
2124         _tokenOwners.set(tokenId, to);
2125 
2126         emit Transfer(address(0), to, tokenId);
2127     }
2128 
2129     /**
2130      * @dev Destroys `tokenId`.
2131      * The approval is cleared when the token is burned.
2132      *
2133      * Requirements:
2134      *
2135      * - `tokenId` must exist.
2136      *
2137      * Emits a {Transfer} event.
2138      */
2139     function _burn(uint256 tokenId) internal virtual {
2140         address owner = ERC721.ownerOf(tokenId); // internal owner
2141 
2142         _beforeTokenTransfer(owner, address(0), tokenId);
2143 
2144         // Clear approvals
2145         _approve(address(0), tokenId);
2146 
2147         // Clear metadata (if any)
2148         if (bytes(_tokenURIs[tokenId]).length != 0) {
2149             delete _tokenURIs[tokenId];
2150         }
2151 
2152         _holderTokens[owner].remove(tokenId);
2153 
2154         _tokenOwners.remove(tokenId);
2155 
2156         emit Transfer(owner, address(0), tokenId);
2157     }
2158 
2159     /**
2160      * @dev Transfers `tokenId` from `from` to `to`.
2161      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2162      *
2163      * Requirements:
2164      *
2165      * - `to` cannot be the zero address.
2166      * - `tokenId` token must be owned by `from`.
2167      *
2168      * Emits a {Transfer} event.
2169      */
2170     function _transfer(
2171         address from,
2172         address to,
2173         uint256 tokenId
2174     ) internal virtual {
2175         require(
2176             ERC721.ownerOf(tokenId) == from,
2177             "ERC721: transfer of token that is not own"
2178         ); // internal owner
2179         require(to != address(0), "ERC721: transfer to the zero address");
2180 
2181         _beforeTokenTransfer(from, to, tokenId);
2182 
2183         // Clear approvals from the previous owner
2184         _approve(address(0), tokenId);
2185 
2186         _holderTokens[from].remove(tokenId);
2187         _holderTokens[to].add(tokenId);
2188 
2189         _tokenOwners.set(tokenId, to);
2190 
2191         emit Transfer(from, to, tokenId);
2192     }
2193 
2194     /**
2195      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2196      *
2197      * Requirements:
2198      *
2199      * - `tokenId` must exist.
2200      */
2201     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2202         internal
2203         virtual
2204     {
2205         require(
2206             _exists(tokenId),
2207             "ERC721Metadata: URI set of nonexistent token"
2208         );
2209         _tokenURIs[tokenId] = _tokenURI;
2210     }
2211 
2212     /**
2213      * @dev Internal function to set the base URI for all token IDs. It is
2214      * automatically added as a prefix to the value returned in {tokenURI},
2215      * or to the token ID if {tokenURI} is empty.
2216      */
2217     function _setBaseURI(string memory baseURI_) internal virtual {
2218         _baseURI = baseURI_;
2219     }
2220 
2221     /**
2222      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2223      * The call is not executed if the target address is not a contract.
2224      *
2225      * @param from address representing the previous owner of the given token ID
2226      * @param to target address that will receive the tokens
2227      * @param tokenId uint256 ID of the token to be transferred
2228      * @param _data bytes optional data to send along with the call
2229      * @return bool whether the call correctly returned the expected magic value
2230      */
2231     function _checkOnERC721Received(
2232         address from,
2233         address to,
2234         uint256 tokenId,
2235         bytes memory _data
2236     ) private returns (bool) {
2237         if (!to.isContract()) {
2238             return true;
2239         }
2240         bytes memory returndata = to.functionCall(
2241             abi.encodeWithSelector(
2242                 IERC721Receiver(to).onERC721Received.selector,
2243                 _msgSender(),
2244                 from,
2245                 tokenId,
2246                 _data
2247             ),
2248             "ERC721: transfer to non ERC721Receiver implementer"
2249         );
2250         bytes4 retval = abi.decode(returndata, (bytes4));
2251         return (retval == _ERC721_RECEIVED);
2252     }
2253 
2254     /**
2255      * @dev Approve `to` to operate on `tokenId`
2256      *
2257      * Emits an {Approval} event.
2258      */
2259     function _approve(address to, uint256 tokenId) internal virtual {
2260         _tokenApprovals[tokenId] = to;
2261         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2262     }
2263 
2264     /**
2265      * @dev Hook that is called before any token transfer. This includes minting
2266      * and burning.
2267      *
2268      * Calling conditions:
2269      *
2270      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2271      * transferred to `to`.
2272      * - When `from` is zero, `tokenId` will be minted for `to`.
2273      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2274      * - `from` cannot be the zero address.
2275      * - `to` cannot be the zero address.
2276      *
2277      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2278      */
2279     function _beforeTokenTransfer(
2280         address from,
2281         address to,
2282         uint256 tokenId
2283     ) internal virtual {}
2284 }
2285 
2286 // File: SimpleCollectible.sol
2287 
2288 /**
2289  * @title Skulls contract
2290  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2291  */
2292 
2293 contract TheGraveyardSale is ERC721, Ownable, RBAC {
2294   using SafeMath for uint256;
2295 
2296   bool public canSetURI = true; // one way toggle that allows use for hardSetTokenURI
2297   // use ONLY in the case that community asks for this functionality to be removed
2298   // this cannot be undone.
2299 
2300   bool public saleIsActive = false; // current status of sale, default is inactive
2301   bool public premintIsActive = false; // curent status of premint, default is inactive
2302   string public NFT_PROVENANCE = ''; // hash representing ownership history of the NFT
2303   uint256 public NFTPrice = 42000000000000000; // 0.042 ETH
2304   uint256 public NFTReserve = 50; // Reserve amount of NFTs [COLIN]
2305   uint256 public constant maxNFTPurchase = 15; // max no. of tokens that can be bought at a time
2306   uint256 public constant WALLET_CAP = 30; // max no. of tokens a wallet can own before losing the ability to mint
2307   uint256 public constant maxPremintPurchase = 3; // max no. of tokens that can be bought or owned during premint
2308   uint256 public constant MAX_NFTS = 4200; // max total supply of NFTs 4200
2309   uint256 public constant PREMINT_SUPPLY = 420; // 420
2310   uint256 public premintReserve = 420; //420
2311   // address[420] private premintList;
2312   constructor() ERC721('The Graveyard Sale', 'SKULL') {}
2313 
2314   // sets canSetURI to false. USE ONLY IF COMMUNITY ASKS FOR FUNCTIONALITY TO BE REMOVED
2315   function cannotSetURI() public onlyOwner
2316   {
2317     canSetURI = false;
2318   }
2319 
2320   // set token URI in the event webhost fails: use with ipfs json
2321   function hardSetTokenURI(uint256 tokenId, string memory tokenURI) public onlyOwner
2322   {
2323     require(canSetURI == true, "This function is no longer available");
2324     _setTokenURI(tokenId, tokenURI);
2325   }
2326 
2327   // Withdraws entire balance of contract (ETH) to owner account (owner-only)
2328   function withdraw() public onlyOwner {
2329     uint256 balance = address(this).balance;
2330     msg.sender.transfer(balance);
2331   }
2332 
2333   // Withdraws amount specified (ETH) from balance of contract to owner account (owner-only)
2334   function withdrawPartial(address payable _recipient, uint256 _amount)
2335     public
2336     onlyOwner
2337   {
2338     // Check that amount is not more than total contract balance
2339     require(
2340       _amount > 0 && _amount <= address(this).balance,
2341       'Withdraw amount must be positive and not exceed total contract balance'
2342     );
2343     _recipient.transfer(_amount);
2344   }
2345 
2346   // Sets a new price for the NFT (owner-only)
2347   function setNFTPrice(uint256 newPrice) public onlyOwner {
2348     NFTPrice = newPrice;
2349   }
2350 
2351   /**
2352    * Mints specified amount of new tokens for the recipient from the reserve
2353    * reduces the reserve by this amount (owner-only)
2354    */
2355   function reserveNFTs(address _to, string memory tokenURI) public onlyOwner {
2356     uint256 supply = totalSupply();
2357     // Checks that there is sufficient reserve supply of tokens for the transaction
2358     require(
2359       NFTReserve > 0,
2360       'Not enough reserve left'
2361     );
2362     _safeMint(_to, supply);
2363     _setTokenURI(supply, tokenURI);
2364 
2365 
2366     NFTReserve = NFTReserve.sub(1);
2367   }
2368 
2369   // Sets the provenance (ownership history) of the NFT (owner-only). The information is encoded by its hash value.
2370   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2371     NFT_PROVENANCE = provenanceHash;
2372   }
2373 
2374   /**
2375    * Sets the base URI for all token IDs. It is automatically added as a prefix to the value returned in {tokenURI},
2376    * or to the token ID if {tokenURI} is empty. Identical to internal function _setBaseURI, but with public
2377    * visibility, and can be called by owner only.
2378    */
2379   function setBaseURI(string memory baseURI) public onlyOwner {
2380     _setBaseURI(baseURI);
2381   }
2382 
2383   // Toggle the current status of the sale between active/inactive (owner-only)
2384   function flipSaleState() public onlyOwner {
2385     saleIsActive = !saleIsActive;
2386   }
2387 
2388   function flipPremintState() public onlyOwner {
2389     premintIsActive = !premintIsActive;
2390   }
2391 
2392   // Returns an array of all tokens belonging to an owner (if any), indexed by their token ID
2393   function tokensOfOwner(address _owner)
2394     external
2395     view
2396     returns (uint256[] memory)
2397   {
2398     uint256 tokenCount = balanceOf(_owner);
2399     if (tokenCount == 0) {
2400       // Return an empty array
2401       return new uint256[](0);
2402     } else {
2403       uint256[] memory result = new uint256[](tokenCount);
2404       uint256 index;
2405       for (index = 0; index < tokenCount; index++) {
2406         result[index] = tokenOfOwnerByIndex(_owner, index);
2407       }
2408       return result;
2409     }
2410   }
2411 
2412   // Mints specified number of NFTs for the receiver and accepts payment (ETH) in return
2413   function mintNFT(uint256 numberOfTokens) public payable {
2414     // Checks that sale is currently active
2415     require(saleIsActive, 'Sale must be active to mint NFT');
2416     // Checks that requested number of tokens is positive and not more than the max purchase limit
2417     require(
2418       numberOfTokens > 0 && numberOfTokens <= maxNFTPurchase,
2419       'Exceeded max token purchase'
2420     );
2421     // Checks that final total supply of tokens (if sale occurs) would not exceed the max supply limit
2422     require(
2423       totalSupply().add(numberOfTokens) <= MAX_NFTS,
2424       'Purchase would exceed max supply of NFTs'
2425     );
2426 
2427     require(balanceOf(msg.sender).add(numberOfTokens) <= WALLET_CAP);
2428     /**
2429          Checks that the buyer sends at least the total price of the transaction (ETH), calculated as number
2430         * of tokens times the token price
2431         */
2432     require(
2433       msg.value >= NFTPrice.mul(numberOfTokens),
2434       'ETH value sent is not correct'
2435     );
2436 
2437     for (uint256 i = 0; i < numberOfTokens; i++) {
2438       uint256 mintIndex = totalSupply();
2439       if (totalSupply() < MAX_NFTS) {
2440         _safeMint(msg.sender, mintIndex);
2441       }
2442     }
2443   }
2444 
2445   function premint(uint256 _toPremint) external onlyPreminter() payable
2446   {
2447 
2448     uint256 supply = totalSupply();
2449     // Checks that there is sufficient reserve supply of tokens for the transaction
2450     require(
2451       _toPremint > 0 && _toPremint <= premintReserve,
2452       'Not enough reserve left'
2453     );
2454     require((balanceOf(msg.sender) + _toPremint) <= maxPremintPurchase, "Limit of 3 NFTs during presale");
2455     require(premintIsActive, 'Premint must be active to mint NFT');
2456     // Checks that requested number of tokens is positive and not more than the max purchase limit
2457     require(
2458       _toPremint > 0 && _toPremint <= maxPremintPurchase,
2459       'Exceeded max token purchase'
2460     );
2461     // Checks that final total supply of tokens (if sale occurs) would not exceed the max supply limit
2462     require(
2463       totalSupply().add(_toPremint) <= PREMINT_SUPPLY,
2464       'Purchase would exceed max supply of NFTs'
2465     );
2466     /**
2467          Checks that the buyer sends at least the total price of the transaction (ETH), calculated as number
2468         * of tokens times the token price
2469         */
2470     require(
2471       msg.value >= NFTPrice.mul(_toPremint),
2472       'ETH value sent is not correct'
2473     );
2474 
2475     for (uint256 i = 0; i < _toPremint; i++) {
2476       uint256 mintIndex = totalSupply();
2477       if (totalSupply() < MAX_NFTS) {
2478         _safeMint(msg.sender, mintIndex);
2479       }
2480     }
2481 
2482     premintReserve = premintReserve.sub(_toPremint);
2483   }
2484 }
