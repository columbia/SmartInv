1 // SPDX-License-Identifier: <SPDX-License> */
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/Address
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
32         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
33         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
34         // for accounts without code, i.e. `keccak256('')`
35         bytes32 codehash;
36         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
37         // solhint-disable-next-line no-inline-assembly
38         assembly { codehash := extcodehash(account) }
39         return (codehash != accountHash && codehash != 0x0);
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
65 }
66 
67 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/Context
68 
69 /*
70  * @dev Provides information about the current execution context, including the
71  * sender of the transaction and its data. While these are generally available
72  * via msg.sender and msg.data, they should not be accessed in such a direct
73  * manner, since when dealing with GSN meta-transactions the account sending and
74  * paying for execution may not be the actual sender (as far as an application
75  * is concerned).
76  *
77  * This contract is only required for intermediate, library-like contracts.
78  */
79 contract Context {
80     // Empty internal constructor, to prevent people from mistakenly deploying
81     // an instance of this contract, which should be used via inheritance.
82     constructor () internal { }
83 
84     function _msgSender() internal view virtual returns (address payable) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view virtual returns (bytes memory) {
89         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
90         return msg.data;
91     }
92 }
93 
94 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/EnumerableMap
95 
96 /**
97  * @dev Library for managing an enumerable variant of Solidity's
98  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
99  * type.
100  *
101  * Maps have the following properties:
102  *
103  * - Entries are added, removed, and checked for existence in constant time
104  * (O(1)).
105  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
106  *
107  * ```
108  * contract Example {
109  *     // Add the library methods
110  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
111  *
112  *     // Declare a set state variable
113  *     EnumerableMap.UintToAddressMap private myMap;
114  * }
115  * ```
116  *
117  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
118  * supported.
119  */
120 library EnumerableMap {
121     // To implement this library for multiple types with as little code
122     // repetition as possible, we write it in terms of a generic Map type with
123     // bytes32 keys and values.
124     // The Map implementation uses private functions, and user-facing
125     // implementations (such as Uint256ToAddressMap) are just wrappers around
126     // the underlying Map.
127     // This means that we can only create new EnumerableMaps for types that fit
128     // in bytes32.
129 
130     struct MapEntry {
131         bytes32 _key;
132         bytes32 _value;
133     }
134 
135     struct Map {
136         // Storage of map keys and values
137         MapEntry[] _entries;
138 
139         // Position of the entry defined by a key in the `entries` array, plus 1
140         // because index 0 means a key is not in the map.
141         mapping (bytes32 => uint256) _indexes;
142     }
143 
144     /**
145      * @dev Adds a key-value pair to a map, or updates the value for an existing
146      * key. O(1).
147      *
148      * Returns true if the key was added to the map, that is if it was not
149      * already present.
150      */
151     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
152         // We read and store the key's index to prevent multiple reads from the same storage slot
153         uint256 keyIndex = map._indexes[key];
154 
155         if (keyIndex == 0) { // Equivalent to !contains(map, key)
156             map._entries.push(MapEntry({ _key: key, _value: value }));
157             // The entry is stored at length-1, but we add 1 to all indexes
158             // and use 0 as a sentinel value
159             map._indexes[key] = map._entries.length;
160             return true;
161         } else {
162             map._entries[keyIndex - 1]._value = value;
163             return false;
164         }
165     }
166 
167     /**
168      * @dev Removes a key-value pair from a map. O(1).
169      *
170      * Returns true if the key was removed from the map, that is if it was present.
171      */
172     function _remove(Map storage map, bytes32 key) private returns (bool) {
173         // We read and store the key's index to prevent multiple reads from the same storage slot
174         uint256 keyIndex = map._indexes[key];
175 
176         if (keyIndex != 0) { // Equivalent to contains(map, key)
177             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
178             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
179             // This modifies the order of the array, as noted in {at}.
180 
181             uint256 toDeleteIndex = keyIndex - 1;
182             uint256 lastIndex = map._entries.length - 1;
183 
184             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
185             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
186 
187             MapEntry storage lastEntry = map._entries[lastIndex];
188 
189             // Move the last entry to the index where the entry to delete is
190             map._entries[toDeleteIndex] = lastEntry;
191             // Update the index for the moved entry
192             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
193 
194             // Delete the slot where the moved entry was stored
195             map._entries.pop();
196 
197             // Delete the index for the deleted slot
198             delete map._indexes[key];
199 
200             return true;
201         } else {
202             return false;
203         }
204     }
205 
206     /**
207      * @dev Returns true if the key is in the map. O(1).
208      */
209     function _contains(Map storage map, bytes32 key) private view returns (bool) {
210         return map._indexes[key] != 0;
211     }
212 
213     /**
214      * @dev Returns the number of key-value pairs in the map. O(1).
215      */
216     function _length(Map storage map) private view returns (uint256) {
217         return map._entries.length;
218     }
219 
220    /**
221     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
222     *
223     * Note that there are no guarantees on the ordering of entries inside the
224     * array, and it may change when more entries are added or removed.
225     *
226     * Requirements:
227     *
228     * - `index` must be strictly less than {length}.
229     */
230     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
231         require(map._entries.length > index, "EnumerableMap: index out of bounds");
232 
233         MapEntry storage entry = map._entries[index];
234         return (entry._key, entry._value);
235     }
236 
237     /**
238      * @dev Returns the value associated with `key`.  O(1).
239      *
240      * Requirements:
241      *
242      * - `key` must be in the map.
243      */
244     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
245         return _get(map, key, "EnumerableMap: nonexistent key");
246     }
247 
248     /**
249      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
250      */
251     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
252         uint256 keyIndex = map._indexes[key];
253         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
254         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
255     }
256 
257     // UintToAddressMap
258 
259     struct UintToAddressMap {
260         Map _inner;
261     }
262 
263     /**
264      * @dev Adds a key-value pair to a map, or updates the value for an existing
265      * key. O(1).
266      *
267      * Returns true if the key was added to the map, that is if it was not
268      * already present.
269      */
270     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
271         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
272     }
273 
274     /**
275      * @dev Removes a value from a set. O(1).
276      *
277      * Returns true if the key was removed from the map, that is if it was present.
278      */
279     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
280         return _remove(map._inner, bytes32(key));
281     }
282 
283     /**
284      * @dev Returns true if the key is in the map. O(1).
285      */
286     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
287         return _contains(map._inner, bytes32(key));
288     }
289 
290     /**
291      * @dev Returns the number of elements in the map. O(1).
292      */
293     function length(UintToAddressMap storage map) internal view returns (uint256) {
294         return _length(map._inner);
295     }
296 
297    /**
298     * @dev Returns the element stored at position `index` in the set. O(1).
299     * Note that there are no guarantees on the ordering of values inside the
300     * array, and it may change when more values are added or removed.
301     *
302     * Requirements:
303     *
304     * - `index` must be strictly less than {length}.
305     */
306     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
307         (bytes32 key, bytes32 value) = _at(map._inner, index);
308         return (uint256(key), address(uint256(value)));
309     }
310 
311     /**
312      * @dev Returns the value associated with `key`.  O(1).
313      *
314      * Requirements:
315      *
316      * - `key` must be in the map.
317      */
318     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
319         return address(uint256(_get(map._inner, bytes32(key))));
320     }
321 
322     /**
323      * @dev Same as {get}, with a custom error message when `key` is not in the map.
324      */
325     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
326         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
327     }
328 }
329 
330 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/EnumerableSet
331 
332 /**
333  * @dev Library for managing
334  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
335  * types.
336  *
337  * Sets have the following properties:
338  *
339  * - Elements are added, removed, and checked for existence in constant time
340  * (O(1)).
341  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
342  *
343  * ```
344  * contract Example {
345  *     // Add the library methods
346  *     using EnumerableSet for EnumerableSet.AddressSet;
347  *
348  *     // Declare a set state variable
349  *     EnumerableSet.AddressSet private mySet;
350  * }
351  * ```
352  *
353  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
354  * (`UintSet`) are supported.
355  */
356 library EnumerableSet {
357     // To implement this library for multiple types with as little code
358     // repetition as possible, we write it in terms of a generic Set type with
359     // bytes32 values.
360     // The Set implementation uses private functions, and user-facing
361     // implementations (such as AddressSet) are just wrappers around the
362     // underlying Set.
363     // This means that we can only create new EnumerableSets for types that fit
364     // in bytes32.
365 
366     struct Set {
367         // Storage of set values
368         bytes32[] _values;
369 
370         // Position of the value in the `values` array, plus 1 because index 0
371         // means a value is not in the set.
372         mapping (bytes32 => uint256) _indexes;
373     }
374 
375     /**
376      * @dev Add a value to a set. O(1).
377      *
378      * Returns true if the value was added to the set, that is if it was not
379      * already present.
380      */
381     function _add(Set storage set, bytes32 value) private returns (bool) {
382         if (!_contains(set, value)) {
383             set._values.push(value);
384             // The value is stored at length-1, but we add 1 to all indexes
385             // and use 0 as a sentinel value
386             set._indexes[value] = set._values.length;
387             return true;
388         } else {
389             return false;
390         }
391     }
392 
393     /**
394      * @dev Removes a value from a set. O(1).
395      *
396      * Returns true if the value was removed from the set, that is if it was
397      * present.
398      */
399     function _remove(Set storage set, bytes32 value) private returns (bool) {
400         // We read and store the value's index to prevent multiple reads from the same storage slot
401         uint256 valueIndex = set._indexes[value];
402 
403         if (valueIndex != 0) { // Equivalent to contains(set, value)
404             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
405             // the array, and then remove the last element (sometimes called as 'swap and pop').
406             // This modifies the order of the array, as noted in {at}.
407 
408             uint256 toDeleteIndex = valueIndex - 1;
409             uint256 lastIndex = set._values.length - 1;
410 
411             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
412             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
413 
414             bytes32 lastvalue = set._values[lastIndex];
415 
416             // Move the last value to the index where the value to delete is
417             set._values[toDeleteIndex] = lastvalue;
418             // Update the index for the moved value
419             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
420 
421             // Delete the slot where the moved value was stored
422             set._values.pop();
423 
424             // Delete the index for the deleted slot
425             delete set._indexes[value];
426 
427             return true;
428         } else {
429             return false;
430         }
431     }
432 
433     /**
434      * @dev Returns true if the value is in the set. O(1).
435      */
436     function _contains(Set storage set, bytes32 value) private view returns (bool) {
437         return set._indexes[value] != 0;
438     }
439 
440     /**
441      * @dev Returns the number of values on the set. O(1).
442      */
443     function _length(Set storage set) private view returns (uint256) {
444         return set._values.length;
445     }
446 
447    /**
448     * @dev Returns the value stored at position `index` in the set. O(1).
449     *
450     * Note that there are no guarantees on the ordering of values inside the
451     * array, and it may change when more values are added or removed.
452     *
453     * Requirements:
454     *
455     * - `index` must be strictly less than {length}.
456     */
457     function _at(Set storage set, uint256 index) private view returns (bytes32) {
458         require(set._values.length > index, "EnumerableSet: index out of bounds");
459         return set._values[index];
460     }
461 
462     // AddressSet
463 
464     struct AddressSet {
465         Set _inner;
466     }
467 
468     /**
469      * @dev Add a value to a set. O(1).
470      *
471      * Returns true if the value was added to the set, that is if it was not
472      * already present.
473      */
474     function add(AddressSet storage set, address value) internal returns (bool) {
475         return _add(set._inner, bytes32(uint256(value)));
476     }
477 
478     /**
479      * @dev Removes a value from a set. O(1).
480      *
481      * Returns true if the value was removed from the set, that is if it was
482      * present.
483      */
484     function remove(AddressSet storage set, address value) internal returns (bool) {
485         return _remove(set._inner, bytes32(uint256(value)));
486     }
487 
488     /**
489      * @dev Returns true if the value is in the set. O(1).
490      */
491     function contains(AddressSet storage set, address value) internal view returns (bool) {
492         return _contains(set._inner, bytes32(uint256(value)));
493     }
494 
495     /**
496      * @dev Returns the number of values in the set. O(1).
497      */
498     function length(AddressSet storage set) internal view returns (uint256) {
499         return _length(set._inner);
500     }
501 
502    /**
503     * @dev Returns the value stored at position `index` in the set. O(1).
504     *
505     * Note that there are no guarantees on the ordering of values inside the
506     * array, and it may change when more values are added or removed.
507     *
508     * Requirements:
509     *
510     * - `index` must be strictly less than {length}.
511     */
512     function at(AddressSet storage set, uint256 index) internal view returns (address) {
513         return address(uint256(_at(set._inner, index)));
514     }
515 
516 
517     // UintSet
518 
519     struct UintSet {
520         Set _inner;
521     }
522 
523     /**
524      * @dev Add a value to a set. O(1).
525      *
526      * Returns true if the value was added to the set, that is if it was not
527      * already present.
528      */
529     function add(UintSet storage set, uint256 value) internal returns (bool) {
530         return _add(set._inner, bytes32(value));
531     }
532 
533     /**
534      * @dev Removes a value from a set. O(1).
535      *
536      * Returns true if the value was removed from the set, that is if it was
537      * present.
538      */
539     function remove(UintSet storage set, uint256 value) internal returns (bool) {
540         return _remove(set._inner, bytes32(value));
541     }
542 
543     /**
544      * @dev Returns true if the value is in the set. O(1).
545      */
546     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
547         return _contains(set._inner, bytes32(value));
548     }
549 
550     /**
551      * @dev Returns the number of values on the set. O(1).
552      */
553     function length(UintSet storage set) internal view returns (uint256) {
554         return _length(set._inner);
555     }
556 
557    /**
558     * @dev Returns the value stored at position `index` in the set. O(1).
559     *
560     * Note that there are no guarantees on the ordering of values inside the
561     * array, and it may change when more values are added or removed.
562     *
563     * Requirements:
564     *
565     * - `index` must be strictly less than {length}.
566     */
567     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
568         return uint256(_at(set._inner, index));
569     }
570 }
571 
572 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/IERC165
573 
574 /**
575  * @dev Interface of the ERC165 standard, as defined in the
576  * https://eips.ethereum.org/EIPS/eip-165[EIP].
577  *
578  * Implementers can declare support of contract interfaces, which can then be
579  * queried by others ({ERC165Checker}).
580  *
581  * For an implementation, see {ERC165}.
582  */
583 interface IERC165 {
584     /**
585      * @dev Returns true if this contract implements the interface defined by
586      * `interfaceId`. See the corresponding
587      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
588      * to learn more about how these ids are created.
589      *
590      * This function call must use less than 30 000 gas.
591      */
592     function supportsInterface(bytes4 interfaceId) external view returns (bool);
593 }
594 
595 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/IERC721Receiver
596 
597 /**
598  * @title ERC721 token receiver interface
599  * @dev Interface for any contract that wants to support safeTransfers
600  * from ERC721 asset contracts.
601  */
602 abstract contract IERC721Receiver {
603     /**
604      * @notice Handle the receipt of an NFT
605      * @dev The ERC721 smart contract calls this function on the recipient
606      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
607      * otherwise the caller will revert the transaction. The selector to be
608      * returned can be obtained as `this.onERC721Received.selector`. This
609      * function MAY throw to revert and reject the transfer.
610      * Note: the ERC721 contract address is always the message sender.
611      * @param operator The address which called `safeTransferFrom` function
612      * @param from The address which previously owned the token
613      * @param tokenId The NFT identifier which is being transferred
614      * @param data Additional data with no specified format
615      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
616      */
617     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
618     public virtual returns (bytes4);
619 }
620 
621 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/SafeMath
622 
623 /**
624  * @dev Wrappers over Solidity's arithmetic operations with added overflow
625  * checks.
626  *
627  * Arithmetic operations in Solidity wrap on overflow. This can easily result
628  * in bugs, because programmers usually assume that an overflow raises an
629  * error, which is the standard behavior in high level programming languages.
630  * `SafeMath` restores this intuition by reverting the transaction when an
631  * operation overflows.
632  *
633  * Using this library instead of the unchecked operations eliminates an entire
634  * class of bugs, so it's recommended to use it always.
635  */
636 library SafeMath {
637     /**
638      * @dev Returns the addition of two unsigned integers, reverting on
639      * overflow.
640      *
641      * Counterpart to Solidity's `+` operator.
642      *
643      * Requirements:
644      * - Addition cannot overflow.
645      */
646     function add(uint256 a, uint256 b) internal pure returns (uint256) {
647         uint256 c = a + b;
648         require(c >= a, "SafeMath: addition overflow");
649 
650         return c;
651     }
652 
653     /**
654      * @dev Returns the subtraction of two unsigned integers, reverting on
655      * overflow (when the result is negative).
656      *
657      * Counterpart to Solidity's `-` operator.
658      *
659      * Requirements:
660      * - Subtraction cannot overflow.
661      */
662     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
663         return sub(a, b, "SafeMath: subtraction overflow");
664     }
665 
666     /**
667      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
668      * overflow (when the result is negative).
669      *
670      * Counterpart to Solidity's `-` operator.
671      *
672      * Requirements:
673      * - Subtraction cannot overflow.
674      */
675     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
676         require(b <= a, errorMessage);
677         uint256 c = a - b;
678 
679         return c;
680     }
681 
682     /**
683      * @dev Returns the multiplication of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `*` operator.
687      *
688      * Requirements:
689      * - Multiplication cannot overflow.
690      */
691     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
692         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
693         // benefit is lost if 'b' is also tested.
694         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
695         if (a == 0) {
696             return 0;
697         }
698 
699         uint256 c = a * b;
700         require(c / a == b, "SafeMath: multiplication overflow");
701 
702         return c;
703     }
704 
705     /**
706      * @dev Returns the integer division of two unsigned integers. Reverts on
707      * division by zero. The result is rounded towards zero.
708      *
709      * Counterpart to Solidity's `/` operator. Note: this function uses a
710      * `revert` opcode (which leaves remaining gas untouched) while Solidity
711      * uses an invalid opcode to revert (consuming all remaining gas).
712      *
713      * Requirements:
714      * - The divisor cannot be zero.
715      */
716     function div(uint256 a, uint256 b) internal pure returns (uint256) {
717         return div(a, b, "SafeMath: division by zero");
718     }
719 
720     /**
721      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
722      * division by zero. The result is rounded towards zero.
723      *
724      * Counterpart to Solidity's `/` operator. Note: this function uses a
725      * `revert` opcode (which leaves remaining gas untouched) while Solidity
726      * uses an invalid opcode to revert (consuming all remaining gas).
727      *
728      * Requirements:
729      * - The divisor cannot be zero.
730      */
731     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
732         // Solidity only automatically asserts when dividing by 0
733         require(b > 0, errorMessage);
734         uint256 c = a / b;
735         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
736 
737         return c;
738     }
739 
740     /**
741      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
742      * Reverts when dividing by zero.
743      *
744      * Counterpart to Solidity's `%` operator. This function uses a `revert`
745      * opcode (which leaves remaining gas untouched) while Solidity uses an
746      * invalid opcode to revert (consuming all remaining gas).
747      *
748      * Requirements:
749      * - The divisor cannot be zero.
750      */
751     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
752         return mod(a, b, "SafeMath: modulo by zero");
753     }
754 
755     /**
756      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
757      * Reverts with custom message when dividing by zero.
758      *
759      * Counterpart to Solidity's `%` operator. This function uses a `revert`
760      * opcode (which leaves remaining gas untouched) while Solidity uses an
761      * invalid opcode to revert (consuming all remaining gas).
762      *
763      * Requirements:
764      * - The divisor cannot be zero.
765      */
766     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
767         require(b != 0, errorMessage);
768         return a % b;
769     }
770 }
771 
772 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/Strings
773 
774 /**
775  * @dev String operations.
776  */
777 library Strings {
778     /**
779      * @dev Converts a `uint256` to its ASCII `string` representation.
780      */
781     function toString(uint256 value) internal pure returns (string memory) {
782         // Inspired by OraclizeAPI's implementation - MIT licence
783         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
784 
785         if (value == 0) {
786             return "0";
787         }
788         uint256 temp = value;
789         uint256 digits;
790         while (temp != 0) {
791             digits++;
792             temp /= 10;
793         }
794         bytes memory buffer = new bytes(digits);
795         uint256 index = digits - 1;
796         temp = value;
797         while (temp != 0) {
798             buffer[index--] = byte(uint8(48 + temp % 10));
799             temp /= 10;
800         }
801         return string(buffer);
802     }
803 }
804 
805 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/ERC165
806 
807 /**
808  * @dev Implementation of the {IERC165} interface.
809  *
810  * Contracts may inherit from this and call {_registerInterface} to declare
811  * their support of an interface.
812  */
813 contract ERC165 is IERC165 {
814     /*
815      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
816      */
817     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
818 
819     /**
820      * @dev Mapping of interface ids to whether or not it's supported.
821      */
822     mapping(bytes4 => bool) private _supportedInterfaces;
823 
824     constructor () internal {
825         // Derived contracts need only register support for their own interfaces,
826         // we register support for ERC165 itself here
827         _registerInterface(_INTERFACE_ID_ERC165);
828     }
829 
830     /**
831      * @dev See {IERC165-supportsInterface}.
832      *
833      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
834      */
835     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
836         return _supportedInterfaces[interfaceId];
837     }
838 
839     /**
840      * @dev Registers the contract as an implementer of the interface defined by
841      * `interfaceId`. Support of the actual ERC165 interface is automatic and
842      * registering its interface id is not required.
843      *
844      * See {IERC165-supportsInterface}.
845      *
846      * Requirements:
847      *
848      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
849      */
850     function _registerInterface(bytes4 interfaceId) internal virtual {
851         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
852         _supportedInterfaces[interfaceId] = true;
853     }
854 }
855 
856 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/IERC721
857 
858 /**
859  * @dev Required interface of an ERC721 compliant contract.
860  */
861 interface IERC721 is IERC165 {
862     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
863     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
864     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
865 
866     /**
867      * @dev Returns the number of NFTs in ``owner``'s account.
868      */
869     function balanceOf(address owner) external view returns (uint256 balance);
870 
871     /**
872      * @dev Returns the owner of the NFT specified by `tokenId`.
873      */
874     function ownerOf(uint256 tokenId) external view returns (address owner);
875 
876     /**
877      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
878      * another (`to`).
879      *
880      *
881      *
882      * Requirements:
883      * - `from`, `to` cannot be zero.
884      * - `tokenId` must be owned by `from`.
885      * - If the caller is not `from`, it must be have been allowed to move this
886      * NFT by either {approve} or {setApprovalForAll}.
887      */
888     function safeTransferFrom(address from, address to, uint256 tokenId) external;
889     /**
890      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
891      * another (`to`).
892      *
893      * Requirements:
894      * - If the caller is not `from`, it must be approved to move this NFT by
895      * either {approve} or {setApprovalForAll}.
896      */
897     function transferFrom(address from, address to, uint256 tokenId) external;
898     function approve(address to, uint256 tokenId) external;
899     function getApproved(uint256 tokenId) external view returns (address operator);
900 
901     function setApprovalForAll(address operator, bool _approved) external;
902     function isApprovedForAll(address owner, address operator) external view returns (bool);
903 
904 
905     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
906 }
907 
908 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/IERC721Enumerable
909 
910 /**
911  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
912  * @dev See https://eips.ethereum.org/EIPS/eip-721
913  */
914 interface IERC721Enumerable is IERC721 {
915     function totalSupply() external view returns (uint256);
916     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
917 
918     function tokenByIndex(uint256 index) external view returns (uint256);
919 }
920 
921 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/IERC721Metadata
922 
923 /**
924  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
925  * @dev See https://eips.ethereum.org/EIPS/eip-721
926  */
927 interface IERC721Metadata is IERC721 {
928     function name() external view returns (string memory);
929     function symbol() external view returns (string memory);
930     function tokenURI(uint256 tokenId) external view returns (string memory);
931 }
932 
933 // Part: OpenZeppelin/openzeppelin-contracts@3.0.0/ERC721
934 
935 /**
936  * @title ERC721 Non-Fungible Token Standard basic implementation
937  * @dev see https://eips.ethereum.org/EIPS/eip-721
938  */
939 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
940     using SafeMath for uint256;
941     using Address for address;
942     using EnumerableSet for EnumerableSet.UintSet;
943     using EnumerableMap for EnumerableMap.UintToAddressMap;
944     using Strings for uint256;
945 
946     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
947     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
948     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
949 
950     // Mapping from holder address to their (enumerable) set of owned tokens
951     mapping (address => EnumerableSet.UintSet) private _holderTokens;
952 
953     // Enumerable mapping from token ids to their owners
954     EnumerableMap.UintToAddressMap private _tokenOwners;
955 
956     // Mapping from token ID to approved address
957     mapping (uint256 => address) private _tokenApprovals;
958 
959     // Mapping from owner to operator approvals
960     mapping (address => mapping (address => bool)) private _operatorApprovals;
961 
962     // Token name
963     string private _name;
964 
965     // Token symbol
966     string private _symbol;
967 
968     // Optional mapping for token URIs
969     mapping(uint256 => string) private _tokenURIs;
970 
971     // Base URI
972     string private _baseURI;
973 
974     /*
975      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
976      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
977      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
978      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
979      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
980      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
981      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
982      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
983      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
984      *
985      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
986      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
987      */
988     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
989 
990     /*
991      *     bytes4(keccak256('name()')) == 0x06fdde03
992      *     bytes4(keccak256('symbol()')) == 0x95d89b41
993      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
994      *
995      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
996      */
997     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
998 
999     /*
1000      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1001      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1002      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1003      *
1004      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1005      */
1006     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1007 
1008     constructor (string memory name, string memory symbol) public {
1009         _name = name;
1010         _symbol = symbol;
1011 
1012         // register the supported interfaces to conform to ERC721 via ERC165
1013         _registerInterface(_INTERFACE_ID_ERC721);
1014         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1015         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1016     }
1017 
1018     /**
1019      * @dev Gets the balance of the specified address.
1020      * @param owner address to query the balance of
1021      * @return uint256 representing the amount owned by the passed address
1022      */
1023     function balanceOf(address owner) public view override returns (uint256) {
1024         require(owner != address(0), "ERC721: balance query for the zero address");
1025 
1026         return _holderTokens[owner].length();
1027     }
1028 
1029     /**
1030      * @dev Gets the owner of the specified token ID.
1031      * @param tokenId uint256 ID of the token to query the owner of
1032      * @return address currently marked as the owner of the given token ID
1033      */
1034     function ownerOf(uint256 tokenId) public view override returns (address) {
1035         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1036     }
1037 
1038     /**
1039      * @dev Gets the token name.
1040      * @return string representing the token name
1041      */
1042     function name() public view override returns (string memory) {
1043         return _name;
1044     }
1045 
1046     /**
1047      * @dev Gets the token symbol.
1048      * @return string representing the token symbol
1049      */
1050     function symbol() public view override returns (string memory) {
1051         return _symbol;
1052     }
1053 
1054     /**
1055      * @dev Returns the URI for a given token ID. May return an empty string.
1056      *
1057      * If a base URI is set (via {_setBaseURI}), it is added as a prefix to the
1058      * token's own URI (via {_setTokenURI}).
1059      *
1060      * If there is a base URI but no token URI, the token's ID will be used as
1061      * its URI when appending it to the base URI. This pattern for autogenerated
1062      * token URIs can lead to large gas savings.
1063      *
1064      * .Examples
1065      * |===
1066      * |`_setBaseURI()` |`_setTokenURI()` |`tokenURI()`
1067      * | ""
1068      * | ""
1069      * | ""
1070      * | ""
1071      * | "token.uri/123"
1072      * | "token.uri/123"
1073      * | "token.uri/"
1074      * | "123"
1075      * | "token.uri/123"
1076      * | "token.uri/"
1077      * | ""
1078      * | "token.uri/<tokenId>"
1079      * |===
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      */
1085     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1086         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1087 
1088         string memory _tokenURI = _tokenURIs[tokenId];
1089 
1090         // If there is no base URI, return the token URI.
1091         if (bytes(_baseURI).length == 0) {
1092             return _tokenURI;
1093         }
1094         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1095         if (bytes(_tokenURI).length > 0) {
1096             return string(abi.encodePacked(_baseURI, _tokenURI));
1097         }
1098         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1099         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1100     }
1101 
1102     /**
1103     * @dev Returns the base URI set via {_setBaseURI}. This will be
1104     * automatically added as a prefix in {tokenURI} to each token's URI, or
1105     * to the token ID if no specific URI is set for that token ID.
1106     */
1107     function baseURI() public view returns (string memory) {
1108         return _baseURI;
1109     }
1110 
1111     /**
1112      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1113      * @param owner address owning the tokens list to be accessed
1114      * @param index uint256 representing the index to be accessed of the requested tokens list
1115      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1116      */
1117     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1118         return _holderTokens[owner].at(index);
1119     }
1120 
1121     /**
1122      * @dev Gets the total amount of tokens stored by the contract.
1123      * @return uint256 representing the total amount of tokens
1124      */
1125     function totalSupply() public view override returns (uint256) {
1126         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1127         return _tokenOwners.length();
1128     }
1129 
1130     /**
1131      * @dev Gets the token ID at a given index of all the tokens in this contract
1132      * Reverts if the index is greater or equal to the total number of tokens.
1133      * @param index uint256 representing the index to be accessed of the tokens list
1134      * @return uint256 token ID at the given index of the tokens list
1135      */
1136     function tokenByIndex(uint256 index) public view override returns (uint256) {
1137         (uint256 tokenId, ) = _tokenOwners.at(index);
1138         return tokenId;
1139     }
1140 
1141     /**
1142      * @dev Approves another address to transfer the given token ID
1143      * The zero address indicates there is no approved address.
1144      * There can only be one approved address per token at a given time.
1145      * Can only be called by the token owner or an approved operator.
1146      * @param to address to be approved for the given token ID
1147      * @param tokenId uint256 ID of the token to be approved
1148      */
1149     function approve(address to, uint256 tokenId) public virtual override {
1150         address owner = ownerOf(tokenId);
1151         require(to != owner, "ERC721: approval to current owner");
1152 
1153         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1154             "ERC721: approve caller is not owner nor approved for all"
1155         );
1156 
1157         _approve(to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Gets the approved address for a token ID, or zero if no address set
1162      * Reverts if the token ID does not exist.
1163      * @param tokenId uint256 ID of the token to query the approval of
1164      * @return address currently approved for the given token ID
1165      */
1166     function getApproved(uint256 tokenId) public view override returns (address) {
1167         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1168 
1169         return _tokenApprovals[tokenId];
1170     }
1171 
1172     /**
1173      * @dev Sets or unsets the approval of a given operator
1174      * An operator is allowed to transfer all tokens of the sender on their behalf.
1175      * @param operator operator address to set the approval
1176      * @param approved representing the status of the approval to be set
1177      */
1178     function setApprovalForAll(address operator, bool approved) public virtual override {
1179         require(operator != _msgSender(), "ERC721: approve to caller");
1180 
1181         _operatorApprovals[_msgSender()][operator] = approved;
1182         emit ApprovalForAll(_msgSender(), operator, approved);
1183     }
1184 
1185     /**
1186      * @dev Tells whether an operator is approved by a given owner.
1187      * @param owner owner address which you want to query the approval of
1188      * @param operator operator address which you want to query the approval of
1189      * @return bool whether the given operator is approved by the given owner
1190      */
1191     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1192         return _operatorApprovals[owner][operator];
1193     }
1194 
1195     /**
1196      * @dev Transfers the ownership of a given token ID to another address.
1197      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1198      * Requires the msg.sender to be the owner, approved, or operator.
1199      * @param from current owner of the token
1200      * @param to address to receive the ownership of the given token ID
1201      * @param tokenId uint256 ID of the token to be transferred
1202      */
1203     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1204         //solhint-disable-next-line max-line-length
1205         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1206 
1207         _transfer(from, to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev Safely transfers the ownership of a given token ID to another address
1212      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1213      * which is called upon a safe transfer, and return the magic value
1214      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1215      * the transfer is reverted.
1216      * Requires the msg.sender to be the owner, approved, or operator
1217      * @param from current owner of the token
1218      * @param to address to receive the ownership of the given token ID
1219      * @param tokenId uint256 ID of the token to be transferred
1220      */
1221     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1222         safeTransferFrom(from, to, tokenId, "");
1223     }
1224 
1225     /**
1226      * @dev Safely transfers the ownership of a given token ID to another address
1227      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1228      * which is called upon a safe transfer, and return the magic value
1229      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1230      * the transfer is reverted.
1231      * Requires the _msgSender() to be the owner, approved, or operator
1232      * @param from current owner of the token
1233      * @param to address to receive the ownership of the given token ID
1234      * @param tokenId uint256 ID of the token to be transferred
1235      * @param _data bytes data to send along with a safe transfer check
1236      */
1237     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1238         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1239         _safeTransfer(from, to, tokenId, _data);
1240     }
1241 
1242     /**
1243      * @dev Safely transfers the ownership of a given token ID to another address
1244      * If the target address is a contract, it must implement `onERC721Received`,
1245      * which is called upon a safe transfer, and return the magic value
1246      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1247      * the transfer is reverted.
1248      * Requires the msg.sender to be the owner, approved, or operator
1249      * @param from current owner of the token
1250      * @param to address to receive the ownership of the given token ID
1251      * @param tokenId uint256 ID of the token to be transferred
1252      * @param _data bytes data to send along with a safe transfer check
1253      */
1254     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1255         _transfer(from, to, tokenId);
1256         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1257     }
1258 
1259     /**
1260      * @dev Returns whether the specified token exists.
1261      * @param tokenId uint256 ID of the token to query the existence of
1262      * @return bool whether the token exists
1263      */
1264     function _exists(uint256 tokenId) internal view returns (bool) {
1265         return _tokenOwners.contains(tokenId);
1266     }
1267 
1268     /**
1269      * @dev Returns whether the given spender can transfer a given token ID.
1270      * @param spender address of the spender to query
1271      * @param tokenId uint256 ID of the token to be transferred
1272      * @return bool whether the msg.sender is approved for the given token ID,
1273      * is an operator of the owner, or is the owner of the token
1274      */
1275     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1276         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1277         address owner = ownerOf(tokenId);
1278         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1279     }
1280 
1281     /**
1282      * @dev Internal function to safely mint a new token.
1283      * Reverts if the given token ID already exists.
1284      * If the target address is a contract, it must implement `onERC721Received`,
1285      * which is called upon a safe transfer, and return the magic value
1286      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1287      * the transfer is reverted.
1288      * @param to The address that will own the minted token
1289      * @param tokenId uint256 ID of the token to be minted
1290      */
1291     function _safeMint(address to, uint256 tokenId) internal virtual {
1292         _safeMint(to, tokenId, "");
1293     }
1294 
1295     /**
1296      * @dev Internal function to safely mint a new token.
1297      * Reverts if the given token ID already exists.
1298      * If the target address is a contract, it must implement `onERC721Received`,
1299      * which is called upon a safe transfer, and return the magic value
1300      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1301      * the transfer is reverted.
1302      * @param to The address that will own the minted token
1303      * @param tokenId uint256 ID of the token to be minted
1304      * @param _data bytes data to send along with a safe transfer check
1305      */
1306     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1307         _mint(to, tokenId);
1308         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1309     }
1310 
1311     /**
1312      * @dev Internal function to mint a new token.
1313      * Reverts if the given token ID already exists.
1314      * @param to The address that will own the minted token
1315      * @param tokenId uint256 ID of the token to be minted
1316      */
1317     function _mint(address to, uint256 tokenId) internal virtual {
1318         require(to != address(0), "ERC721: mint to the zero address");
1319         require(!_exists(tokenId), "ERC721: token already minted");
1320 
1321         _beforeTokenTransfer(address(0), to, tokenId);
1322 
1323         _holderTokens[to].add(tokenId);
1324 
1325         _tokenOwners.set(tokenId, to);
1326 
1327         emit Transfer(address(0), to, tokenId);
1328     }
1329 
1330     /**
1331      * @dev Internal function to burn a specific token.
1332      * Reverts if the token does not exist.
1333      * @param tokenId uint256 ID of the token being burned
1334      */
1335     function _burn(uint256 tokenId) internal virtual {
1336         address owner = ownerOf(tokenId);
1337 
1338         _beforeTokenTransfer(owner, address(0), tokenId);
1339 
1340         // Clear approvals
1341         _approve(address(0), tokenId);
1342 
1343         // Clear metadata (if any)
1344         if (bytes(_tokenURIs[tokenId]).length != 0) {
1345             delete _tokenURIs[tokenId];
1346         }
1347 
1348         _holderTokens[owner].remove(tokenId);
1349 
1350         _tokenOwners.remove(tokenId);
1351 
1352         emit Transfer(owner, address(0), tokenId);
1353     }
1354 
1355     /**
1356      * @dev Internal function to transfer ownership of a given token ID to another address.
1357      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1358      * @param from current owner of the token
1359      * @param to address to receive the ownership of the given token ID
1360      * @param tokenId uint256 ID of the token to be transferred
1361      */
1362     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1363         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1364         require(to != address(0), "ERC721: transfer to the zero address");
1365 
1366         _beforeTokenTransfer(from, to, tokenId);
1367 
1368         // Clear approvals from the previous owner
1369         _approve(address(0), tokenId);
1370 
1371         _holderTokens[from].remove(tokenId);
1372         _holderTokens[to].add(tokenId);
1373 
1374         _tokenOwners.set(tokenId, to);
1375 
1376         emit Transfer(from, to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev Internal function to set the token URI for a given token.
1381      *
1382      * Reverts if the token ID does not exist.
1383      *
1384      * TIP: If all token IDs share a prefix (for example, if your URIs look like
1385      * `https://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1386      * it and save gas.
1387      */
1388     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1389         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1390         _tokenURIs[tokenId] = _tokenURI;
1391     }
1392 
1393     /**
1394      * @dev Internal function to set the base URI for all token IDs. It is
1395      * automatically added as a prefix to the value returned in {tokenURI},
1396      * or to the token ID if {tokenURI} is empty.
1397      */
1398     function _setBaseURI(string memory baseURI_) internal virtual {
1399         _baseURI = baseURI_;
1400     }
1401 
1402     /**
1403      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1404      * The call is not executed if the target address is not a contract.
1405      *
1406      * @param from address representing the previous owner of the given token ID
1407      * @param to target address that will receive the tokens
1408      * @param tokenId uint256 ID of the token to be transferred
1409      * @param _data bytes optional data to send along with the call
1410      * @return bool whether the call correctly returned the expected magic value
1411      */
1412     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1413         private returns (bool)
1414     {
1415         if (!to.isContract()) {
1416             return true;
1417         }
1418         // solhint-disable-next-line avoid-low-level-calls
1419         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1420             IERC721Receiver(to).onERC721Received.selector,
1421             _msgSender(),
1422             from,
1423             tokenId,
1424             _data
1425         ));
1426         if (!success) {
1427             if (returndata.length > 0) {
1428                 // solhint-disable-next-line no-inline-assembly
1429                 assembly {
1430                     let returndata_size := mload(returndata)
1431                     revert(add(32, returndata), returndata_size)
1432                 }
1433             } else {
1434                 revert("ERC721: transfer to non ERC721Receiver implementer");
1435             }
1436         } else {
1437             bytes4 retval = abi.decode(returndata, (bytes4));
1438             return (retval == _ERC721_RECEIVED);
1439         }
1440     }
1441 
1442     function _approve(address to, uint256 tokenId) private {
1443         _tokenApprovals[tokenId] = to;
1444         emit Approval(ownerOf(tokenId), to, tokenId);
1445     }
1446 
1447     /**
1448      * @dev Hook that is called before any token transfer. This includes minting
1449      * and burning.
1450      *
1451      * Calling conditions:
1452      *
1453      * - when `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1454      * transferred to `to`.
1455      * - when `from` is zero, `tokenId` will be minted for `to`.
1456      * - when `to` is zero, ``from``'s `tokenId` will be burned.
1457      * - `from` and `to` are never both zero.
1458      *
1459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1460      */
1461     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1462 }
1463 
1464 // File: toadz.sol
1465 
1466 contract Toadz is ERC721("Flip Toadz", "FLOADZ"){
1467 
1468 
1469     address public owner;
1470     uint256 public maxSupply = 6969;
1471     uint256 public dropTime;
1472     uint256 public accLimit = 5;
1473     uint256 public mintPerTx = 3;
1474     uint256 public minted = 0;
1475 
1476     constructor(uint256 _dropTime) public {
1477         require(_dropTime > block.timestamp);
1478         owner = msg.sender;
1479         dropTime = _dropTime;
1480         _setBaseURI("http://108.61.217.200/token/");
1481     }
1482 
1483     function setURI(string memory _uri) public {
1484         require(msg.sender == owner);
1485         _setBaseURI(_uri);
1486     }
1487 
1488     function mint(uint256 _amount) public payable {
1489         require(block.timestamp >= dropTime, "Drop not yet available");
1490         require(_amount <= mintPerTx, "Only 5 mints per tx");
1491         require(balanceOf(msg.sender) + _amount <= accLimit, "Only 5 toadz per address!");
1492         require((minted + _amount) <= maxSupply, "Sold out");
1493 
1494         for (uint256 i = 0; i < _amount; i++) {
1495             minted += 1;
1496             _mint(msg.sender, minted);
1497         }
1498     }
1499 
1500     function reroll(uint256 _token1, uint256 _token2) public {
1501         require(ownerOf(_token1) == msg.sender && ownerOf(_token2) == msg.sender, "You do not own these tokens!!");
1502         require(minted + 1 <= maxSupply, "No longer available");
1503         //burn tokens and mint again
1504         _burn(_token1);
1505         _burn(_token2);
1506         minted += 1;
1507         _mint(msg.sender, minted);
1508     }
1509 
1510     function changeOwner(address _owner) public {
1511         require(msg.sender == owner);
1512         owner = _owner;
1513     }
1514 }
