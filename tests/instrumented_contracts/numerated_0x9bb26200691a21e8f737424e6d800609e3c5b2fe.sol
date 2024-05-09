1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: IMintableAirdrop
8 
9 interface IMintableAirdrop {
10 
11   function mintAirdrops(
12     address _owner,
13     uint256 _amount,
14     uint256 _upfront,
15     uint256 _start,
16     uint256 _end) external returns(uint256);
17 }
18 
19 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies in extcodesize, which returns 0 for contracts in
44         // construction, since the code is only stored at the end of the
45         // constructor execution.
46 
47         uint256 size;
48         // solhint-disable-next-line no-inline-assembly
49         assembly { size := extcodesize(account) }
50         return size > 0;
51     }
52 
53     /**
54      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
55      * `recipient`, forwarding all available gas and reverting on errors.
56      *
57      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
58      * of certain opcodes, possibly making contracts go over the 2300 gas limit
59      * imposed by `transfer`, making them unable to receive funds via
60      * `transfer`. {sendValue} removes this limitation.
61      *
62      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
63      *
64      * IMPORTANT: because control is transferred to `recipient`, care must be
65      * taken to not create reentrancy vulnerabilities. Consider using
66      * {ReentrancyGuard} or the
67      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
68      */
69     function sendValue(address payable recipient, uint256 amount) internal {
70         require(address(this).balance >= amount, "Address: insufficient balance");
71 
72         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
73         (bool success, ) = recipient.call{ value: amount }("");
74         require(success, "Address: unable to send value, recipient may have reverted");
75     }
76 
77     /**
78      * @dev Performs a Solidity function call using a low level `call`. A
79      * plain`call` is an unsafe replacement for a function call: use this
80      * function instead.
81      *
82      * If `target` reverts with a revert reason, it is bubbled up by this
83      * function (like regular Solidity function calls).
84      *
85      * Returns the raw returned data. To convert to the expected return value,
86      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
87      *
88      * Requirements:
89      *
90      * - `target` must be a contract.
91      * - calling `target` with `data` must not revert.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96       return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
101      * `errorMessage` as a fallback revert reason when `target` reverts.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
106         return _functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
111      * but also transferring `value` wei to `target`.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least `value`.
116      * - the called Solidity function must be `payable`.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         return _functionCallWithValue(target, data, value, errorMessage);
133     }
134 
135     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
136         require(isContract(target), "Address: call to non-contract");
137 
138         // solhint-disable-next-line avoid-low-level-calls
139         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
140         if (success) {
141             return returndata;
142         } else {
143             // Look for revert reason and bubble it up if present
144             if (returndata.length > 0) {
145                 // The easiest way to bubble the revert reason is using memory via assembly
146 
147                 // solhint-disable-next-line no-inline-assembly
148                 assembly {
149                     let returndata_size := mload(returndata)
150                     revert(add(32, returndata), returndata_size)
151                 }
152             } else {
153                 revert(errorMessage);
154             }
155         }
156     }
157 }
158 
159 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
160 
161 /*
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with GSN meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address payable) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes memory) {
177         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
178         return msg.data;
179     }
180 }
181 
182 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ECDSA
183 
184 /**
185  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
186  *
187  * These functions can be used to verify that a message was signed by the holder
188  * of the private keys of a given address.
189  */
190 library ECDSA {
191     /**
192      * @dev Returns the address that signed a hashed message (`hash`) with
193      * `signature`. This address can then be used for verification purposes.
194      *
195      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
196      * this function rejects them by requiring the `s` value to be in the lower
197      * half order, and the `v` value to be either 27 or 28.
198      *
199      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
200      * verification to be secure: it is possible to craft signatures that
201      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
202      * this is by receiving a hash of the original message (which may otherwise
203      * be too long), and then calling {toEthSignedMessageHash} on it.
204      */
205     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
206         // Check the signature length
207         if (signature.length != 65) {
208             revert("ECDSA: invalid signature length");
209         }
210 
211         // Divide the signature in r, s and v variables
212         bytes32 r;
213         bytes32 s;
214         uint8 v;
215 
216         // ecrecover takes the signature parameters, and the only way to get them
217         // currently is to use assembly.
218         // solhint-disable-next-line no-inline-assembly
219         assembly {
220             r := mload(add(signature, 0x20))
221             s := mload(add(signature, 0x40))
222             v := byte(0, mload(add(signature, 0x60)))
223         }
224 
225         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
226         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
227         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
228         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
229         //
230         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
231         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
232         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
233         // these malleable signatures as well.
234         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
235             revert("ECDSA: invalid signature 's' value");
236         }
237 
238         if (v != 27 && v != 28) {
239             revert("ECDSA: invalid signature 'v' value");
240         }
241 
242         // If the signature is valid (and not malleable), return the signer address
243         address signer = ecrecover(hash, v, r, s);
244         require(signer != address(0), "ECDSA: invalid signature");
245 
246         return signer;
247     }
248 
249     /**
250      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
251      * replicates the behavior of the
252      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
253      * JSON-RPC method.
254      *
255      * See {recover}.
256      */
257     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
258         // 32 is the length in bytes of hash,
259         // enforced by the type signature above
260         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
261     }
262 }
263 
264 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableMap
265 
266 /**
267  * @dev Library for managing an enumerable variant of Solidity's
268  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
269  * type.
270  *
271  * Maps have the following properties:
272  *
273  * - Entries are added, removed, and checked for existence in constant time
274  * (O(1)).
275  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
276  *
277  * ```
278  * contract Example {
279  *     // Add the library methods
280  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
281  *
282  *     // Declare a set state variable
283  *     EnumerableMap.UintToAddressMap private myMap;
284  * }
285  * ```
286  *
287  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
288  * supported.
289  */
290 library EnumerableMap {
291     // To implement this library for multiple types with as little code
292     // repetition as possible, we write it in terms of a generic Map type with
293     // bytes32 keys and values.
294     // The Map implementation uses private functions, and user-facing
295     // implementations (such as Uint256ToAddressMap) are just wrappers around
296     // the underlying Map.
297     // This means that we can only create new EnumerableMaps for types that fit
298     // in bytes32.
299 
300     struct MapEntry {
301         bytes32 _key;
302         bytes32 _value;
303     }
304 
305     struct Map {
306         // Storage of map keys and values
307         MapEntry[] _entries;
308 
309         // Position of the entry defined by a key in the `entries` array, plus 1
310         // because index 0 means a key is not in the map.
311         mapping (bytes32 => uint256) _indexes;
312     }
313 
314     /**
315      * @dev Adds a key-value pair to a map, or updates the value for an existing
316      * key. O(1).
317      *
318      * Returns true if the key was added to the map, that is if it was not
319      * already present.
320      */
321     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
322         // We read and store the key's index to prevent multiple reads from the same storage slot
323         uint256 keyIndex = map._indexes[key];
324 
325         if (keyIndex == 0) { // Equivalent to !contains(map, key)
326             map._entries.push(MapEntry({ _key: key, _value: value }));
327             // The entry is stored at length-1, but we add 1 to all indexes
328             // and use 0 as a sentinel value
329             map._indexes[key] = map._entries.length;
330             return true;
331         } else {
332             map._entries[keyIndex - 1]._value = value;
333             return false;
334         }
335     }
336 
337     /**
338      * @dev Removes a key-value pair from a map. O(1).
339      *
340      * Returns true if the key was removed from the map, that is if it was present.
341      */
342     function _remove(Map storage map, bytes32 key) private returns (bool) {
343         // We read and store the key's index to prevent multiple reads from the same storage slot
344         uint256 keyIndex = map._indexes[key];
345 
346         if (keyIndex != 0) { // Equivalent to contains(map, key)
347             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
348             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
349             // This modifies the order of the array, as noted in {at}.
350 
351             uint256 toDeleteIndex = keyIndex - 1;
352             uint256 lastIndex = map._entries.length - 1;
353 
354             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
355             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
356 
357             MapEntry storage lastEntry = map._entries[lastIndex];
358 
359             // Move the last entry to the index where the entry to delete is
360             map._entries[toDeleteIndex] = lastEntry;
361             // Update the index for the moved entry
362             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
363 
364             // Delete the slot where the moved entry was stored
365             map._entries.pop();
366 
367             // Delete the index for the deleted slot
368             delete map._indexes[key];
369 
370             return true;
371         } else {
372             return false;
373         }
374     }
375 
376     /**
377      * @dev Returns true if the key is in the map. O(1).
378      */
379     function _contains(Map storage map, bytes32 key) private view returns (bool) {
380         return map._indexes[key] != 0;
381     }
382 
383     /**
384      * @dev Returns the number of key-value pairs in the map. O(1).
385      */
386     function _length(Map storage map) private view returns (uint256) {
387         return map._entries.length;
388     }
389 
390    /**
391     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
392     *
393     * Note that there are no guarantees on the ordering of entries inside the
394     * array, and it may change when more entries are added or removed.
395     *
396     * Requirements:
397     *
398     * - `index` must be strictly less than {length}.
399     */
400     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
401         require(map._entries.length > index, "EnumerableMap: index out of bounds");
402 
403         MapEntry storage entry = map._entries[index];
404         return (entry._key, entry._value);
405     }
406 
407     /**
408      * @dev Returns the value associated with `key`.  O(1).
409      *
410      * Requirements:
411      *
412      * - `key` must be in the map.
413      */
414     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
415         return _get(map, key, "EnumerableMap: nonexistent key");
416     }
417 
418     /**
419      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
420      */
421     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
422         uint256 keyIndex = map._indexes[key];
423         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
424         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
425     }
426 
427     // UintToAddressMap
428 
429     struct UintToAddressMap {
430         Map _inner;
431     }
432 
433     /**
434      * @dev Adds a key-value pair to a map, or updates the value for an existing
435      * key. O(1).
436      *
437      * Returns true if the key was added to the map, that is if it was not
438      * already present.
439      */
440     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
441         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
442     }
443 
444     /**
445      * @dev Removes a value from a set. O(1).
446      *
447      * Returns true if the key was removed from the map, that is if it was present.
448      */
449     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
450         return _remove(map._inner, bytes32(key));
451     }
452 
453     /**
454      * @dev Returns true if the key is in the map. O(1).
455      */
456     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
457         return _contains(map._inner, bytes32(key));
458     }
459 
460     /**
461      * @dev Returns the number of elements in the map. O(1).
462      */
463     function length(UintToAddressMap storage map) internal view returns (uint256) {
464         return _length(map._inner);
465     }
466 
467    /**
468     * @dev Returns the element stored at position `index` in the set. O(1).
469     * Note that there are no guarantees on the ordering of values inside the
470     * array, and it may change when more values are added or removed.
471     *
472     * Requirements:
473     *
474     * - `index` must be strictly less than {length}.
475     */
476     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
477         (bytes32 key, bytes32 value) = _at(map._inner, index);
478         return (uint256(key), address(uint256(value)));
479     }
480 
481     /**
482      * @dev Returns the value associated with `key`.  O(1).
483      *
484      * Requirements:
485      *
486      * - `key` must be in the map.
487      */
488     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
489         return address(uint256(_get(map._inner, bytes32(key))));
490     }
491 
492     /**
493      * @dev Same as {get}, with a custom error message when `key` is not in the map.
494      */
495     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
496         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
497     }
498 }
499 
500 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableSet
501 
502 /**
503  * @dev Library for managing
504  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
505  * types.
506  *
507  * Sets have the following properties:
508  *
509  * - Elements are added, removed, and checked for existence in constant time
510  * (O(1)).
511  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
512  *
513  * ```
514  * contract Example {
515  *     // Add the library methods
516  *     using EnumerableSet for EnumerableSet.AddressSet;
517  *
518  *     // Declare a set state variable
519  *     EnumerableSet.AddressSet private mySet;
520  * }
521  * ```
522  *
523  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
524  * (`UintSet`) are supported.
525  */
526 library EnumerableSet {
527     // To implement this library for multiple types with as little code
528     // repetition as possible, we write it in terms of a generic Set type with
529     // bytes32 values.
530     // The Set implementation uses private functions, and user-facing
531     // implementations (such as AddressSet) are just wrappers around the
532     // underlying Set.
533     // This means that we can only create new EnumerableSets for types that fit
534     // in bytes32.
535 
536     struct Set {
537         // Storage of set values
538         bytes32[] _values;
539 
540         // Position of the value in the `values` array, plus 1 because index 0
541         // means a value is not in the set.
542         mapping (bytes32 => uint256) _indexes;
543     }
544 
545     /**
546      * @dev Add a value to a set. O(1).
547      *
548      * Returns true if the value was added to the set, that is if it was not
549      * already present.
550      */
551     function _add(Set storage set, bytes32 value) private returns (bool) {
552         if (!_contains(set, value)) {
553             set._values.push(value);
554             // The value is stored at length-1, but we add 1 to all indexes
555             // and use 0 as a sentinel value
556             set._indexes[value] = set._values.length;
557             return true;
558         } else {
559             return false;
560         }
561     }
562 
563     /**
564      * @dev Removes a value from a set. O(1).
565      *
566      * Returns true if the value was removed from the set, that is if it was
567      * present.
568      */
569     function _remove(Set storage set, bytes32 value) private returns (bool) {
570         // We read and store the value's index to prevent multiple reads from the same storage slot
571         uint256 valueIndex = set._indexes[value];
572 
573         if (valueIndex != 0) { // Equivalent to contains(set, value)
574             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
575             // the array, and then remove the last element (sometimes called as 'swap and pop').
576             // This modifies the order of the array, as noted in {at}.
577 
578             uint256 toDeleteIndex = valueIndex - 1;
579             uint256 lastIndex = set._values.length - 1;
580 
581             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
582             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
583 
584             bytes32 lastvalue = set._values[lastIndex];
585 
586             // Move the last value to the index where the value to delete is
587             set._values[toDeleteIndex] = lastvalue;
588             // Update the index for the moved value
589             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
590 
591             // Delete the slot where the moved value was stored
592             set._values.pop();
593 
594             // Delete the index for the deleted slot
595             delete set._indexes[value];
596 
597             return true;
598         } else {
599             return false;
600         }
601     }
602 
603     /**
604      * @dev Returns true if the value is in the set. O(1).
605      */
606     function _contains(Set storage set, bytes32 value) private view returns (bool) {
607         return set._indexes[value] != 0;
608     }
609 
610     /**
611      * @dev Returns the number of values on the set. O(1).
612      */
613     function _length(Set storage set) private view returns (uint256) {
614         return set._values.length;
615     }
616 
617    /**
618     * @dev Returns the value stored at position `index` in the set. O(1).
619     *
620     * Note that there are no guarantees on the ordering of values inside the
621     * array, and it may change when more values are added or removed.
622     *
623     * Requirements:
624     *
625     * - `index` must be strictly less than {length}.
626     */
627     function _at(Set storage set, uint256 index) private view returns (bytes32) {
628         require(set._values.length > index, "EnumerableSet: index out of bounds");
629         return set._values[index];
630     }
631 
632     // AddressSet
633 
634     struct AddressSet {
635         Set _inner;
636     }
637 
638     /**
639      * @dev Add a value to a set. O(1).
640      *
641      * Returns true if the value was added to the set, that is if it was not
642      * already present.
643      */
644     function add(AddressSet storage set, address value) internal returns (bool) {
645         return _add(set._inner, bytes32(uint256(value)));
646     }
647 
648     /**
649      * @dev Removes a value from a set. O(1).
650      *
651      * Returns true if the value was removed from the set, that is if it was
652      * present.
653      */
654     function remove(AddressSet storage set, address value) internal returns (bool) {
655         return _remove(set._inner, bytes32(uint256(value)));
656     }
657 
658     /**
659      * @dev Returns true if the value is in the set. O(1).
660      */
661     function contains(AddressSet storage set, address value) internal view returns (bool) {
662         return _contains(set._inner, bytes32(uint256(value)));
663     }
664 
665     /**
666      * @dev Returns the number of values in the set. O(1).
667      */
668     function length(AddressSet storage set) internal view returns (uint256) {
669         return _length(set._inner);
670     }
671 
672    /**
673     * @dev Returns the value stored at position `index` in the set. O(1).
674     *
675     * Note that there are no guarantees on the ordering of values inside the
676     * array, and it may change when more values are added or removed.
677     *
678     * Requirements:
679     *
680     * - `index` must be strictly less than {length}.
681     */
682     function at(AddressSet storage set, uint256 index) internal view returns (address) {
683         return address(uint256(_at(set._inner, index)));
684     }
685 
686 
687     // UintSet
688 
689     struct UintSet {
690         Set _inner;
691     }
692 
693     /**
694      * @dev Add a value to a set. O(1).
695      *
696      * Returns true if the value was added to the set, that is if it was not
697      * already present.
698      */
699     function add(UintSet storage set, uint256 value) internal returns (bool) {
700         return _add(set._inner, bytes32(value));
701     }
702 
703     /**
704      * @dev Removes a value from a set. O(1).
705      *
706      * Returns true if the value was removed from the set, that is if it was
707      * present.
708      */
709     function remove(UintSet storage set, uint256 value) internal returns (bool) {
710         return _remove(set._inner, bytes32(value));
711     }
712 
713     /**
714      * @dev Returns true if the value is in the set. O(1).
715      */
716     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
717         return _contains(set._inner, bytes32(value));
718     }
719 
720     /**
721      * @dev Returns the number of values on the set. O(1).
722      */
723     function length(UintSet storage set) internal view returns (uint256) {
724         return _length(set._inner);
725     }
726 
727    /**
728     * @dev Returns the value stored at position `index` in the set. O(1).
729     *
730     * Note that there are no guarantees on the ordering of values inside the
731     * array, and it may change when more values are added or removed.
732     *
733     * Requirements:
734     *
735     * - `index` must be strictly less than {length}.
736     */
737     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
738         return uint256(_at(set._inner, index));
739     }
740 }
741 
742 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC165
743 
744 /**
745  * @dev Interface of the ERC165 standard, as defined in the
746  * https://eips.ethereum.org/EIPS/eip-165[EIP].
747  *
748  * Implementers can declare support of contract interfaces, which can then be
749  * queried by others ({ERC165Checker}).
750  *
751  * For an implementation, see {ERC165}.
752  */
753 interface IERC165 {
754     /**
755      * @dev Returns true if this contract implements the interface defined by
756      * `interfaceId`. See the corresponding
757      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
758      * to learn more about how these ids are created.
759      *
760      * This function call must use less than 30 000 gas.
761      */
762     function supportsInterface(bytes4 interfaceId) external view returns (bool);
763 }
764 
765 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
766 
767 /**
768  * @dev Interface of the ERC20 standard as defined in the EIP.
769  */
770 interface IERC20 {
771     /**
772      * @dev Returns the amount of tokens in existence.
773      */
774     function totalSupply() external view returns (uint256);
775 
776     /**
777      * @dev Returns the amount of tokens owned by `account`.
778      */
779     function balanceOf(address account) external view returns (uint256);
780 
781     /**
782      * @dev Moves `amount` tokens from the caller's account to `recipient`.
783      *
784      * Returns a boolean value indicating whether the operation succeeded.
785      *
786      * Emits a {Transfer} event.
787      */
788     function transfer(address recipient, uint256 amount) external returns (bool);
789 
790     /**
791      * @dev Returns the remaining number of tokens that `spender` will be
792      * allowed to spend on behalf of `owner` through {transferFrom}. This is
793      * zero by default.
794      *
795      * This value changes when {approve} or {transferFrom} are called.
796      */
797     function allowance(address owner, address spender) external view returns (uint256);
798 
799     /**
800      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
801      *
802      * Returns a boolean value indicating whether the operation succeeded.
803      *
804      * IMPORTANT: Beware that changing an allowance with this method brings the risk
805      * that someone may use both the old and the new allowance by unfortunate
806      * transaction ordering. One possible solution to mitigate this race
807      * condition is to first reduce the spender's allowance to 0 and set the
808      * desired value afterwards:
809      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
810      *
811      * Emits an {Approval} event.
812      */
813     function approve(address spender, uint256 amount) external returns (bool);
814 
815     /**
816      * @dev Moves `amount` tokens from `sender` to `recipient` using the
817      * allowance mechanism. `amount` is then deducted from the caller's
818      * allowance.
819      *
820      * Returns a boolean value indicating whether the operation succeeded.
821      *
822      * Emits a {Transfer} event.
823      */
824     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
825 
826     /**
827      * @dev Emitted when `value` tokens are moved from one account (`from`) to
828      * another (`to`).
829      *
830      * Note that `value` may be zero.
831      */
832     event Transfer(address indexed from, address indexed to, uint256 value);
833 
834     /**
835      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
836      * a call to {approve}. `value` is the new allowance.
837      */
838     event Approval(address indexed owner, address indexed spender, uint256 value);
839 }
840 
841 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Receiver
842 
843 /**
844  * @title ERC721 token receiver interface
845  * @dev Interface for any contract that wants to support safeTransfers
846  * from ERC721 asset contracts.
847  */
848 interface IERC721Receiver {
849     /**
850      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
851      * by `operator` from `from`, this function is called.
852      *
853      * It must return its Solidity selector to confirm the token transfer.
854      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
855      *
856      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
857      */
858     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
859     external returns (bytes4);
860 }
861 
862 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
863 
864 /**
865  * @dev Wrappers over Solidity's arithmetic operations with added overflow
866  * checks.
867  *
868  * Arithmetic operations in Solidity wrap on overflow. This can easily result
869  * in bugs, because programmers usually assume that an overflow raises an
870  * error, which is the standard behavior in high level programming languages.
871  * `SafeMath` restores this intuition by reverting the transaction when an
872  * operation overflows.
873  *
874  * Using this library instead of the unchecked operations eliminates an entire
875  * class of bugs, so it's recommended to use it always.
876  */
877 library SafeMath {
878     /**
879      * @dev Returns the addition of two unsigned integers, reverting on
880      * overflow.
881      *
882      * Counterpart to Solidity's `+` operator.
883      *
884      * Requirements:
885      *
886      * - Addition cannot overflow.
887      */
888     function add(uint256 a, uint256 b) internal pure returns (uint256) {
889         uint256 c = a + b;
890         require(c >= a, "SafeMath: addition overflow");
891 
892         return c;
893     }
894 
895     /**
896      * @dev Returns the subtraction of two unsigned integers, reverting on
897      * overflow (when the result is negative).
898      *
899      * Counterpart to Solidity's `-` operator.
900      *
901      * Requirements:
902      *
903      * - Subtraction cannot overflow.
904      */
905     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
906         return sub(a, b, "SafeMath: subtraction overflow");
907     }
908 
909     /**
910      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
911      * overflow (when the result is negative).
912      *
913      * Counterpart to Solidity's `-` operator.
914      *
915      * Requirements:
916      *
917      * - Subtraction cannot overflow.
918      */
919     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
920         require(b <= a, errorMessage);
921         uint256 c = a - b;
922 
923         return c;
924     }
925 
926     /**
927      * @dev Returns the multiplication of two unsigned integers, reverting on
928      * overflow.
929      *
930      * Counterpart to Solidity's `*` operator.
931      *
932      * Requirements:
933      *
934      * - Multiplication cannot overflow.
935      */
936     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
937         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
938         // benefit is lost if 'b' is also tested.
939         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
940         if (a == 0) {
941             return 0;
942         }
943 
944         uint256 c = a * b;
945         require(c / a == b, "SafeMath: multiplication overflow");
946 
947         return c;
948     }
949 
950     /**
951      * @dev Returns the integer division of two unsigned integers. Reverts on
952      * division by zero. The result is rounded towards zero.
953      *
954      * Counterpart to Solidity's `/` operator. Note: this function uses a
955      * `revert` opcode (which leaves remaining gas untouched) while Solidity
956      * uses an invalid opcode to revert (consuming all remaining gas).
957      *
958      * Requirements:
959      *
960      * - The divisor cannot be zero.
961      */
962     function div(uint256 a, uint256 b) internal pure returns (uint256) {
963         return div(a, b, "SafeMath: division by zero");
964     }
965 
966     /**
967      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
968      * division by zero. The result is rounded towards zero.
969      *
970      * Counterpart to Solidity's `/` operator. Note: this function uses a
971      * `revert` opcode (which leaves remaining gas untouched) while Solidity
972      * uses an invalid opcode to revert (consuming all remaining gas).
973      *
974      * Requirements:
975      *
976      * - The divisor cannot be zero.
977      */
978     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
979         require(b > 0, errorMessage);
980         uint256 c = a / b;
981         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
982 
983         return c;
984     }
985 
986     /**
987      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
988      * Reverts when dividing by zero.
989      *
990      * Counterpart to Solidity's `%` operator. This function uses a `revert`
991      * opcode (which leaves remaining gas untouched) while Solidity uses an
992      * invalid opcode to revert (consuming all remaining gas).
993      *
994      * Requirements:
995      *
996      * - The divisor cannot be zero.
997      */
998     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
999         return mod(a, b, "SafeMath: modulo by zero");
1000     }
1001 
1002     /**
1003      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1004      * Reverts with custom message when dividing by zero.
1005      *
1006      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1007      * opcode (which leaves remaining gas untouched) while Solidity uses an
1008      * invalid opcode to revert (consuming all remaining gas).
1009      *
1010      * Requirements:
1011      *
1012      * - The divisor cannot be zero.
1013      */
1014     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1015         require(b != 0, errorMessage);
1016         return a % b;
1017     }
1018 }
1019 
1020 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Strings
1021 
1022 /**
1023  * @dev String operations.
1024  */
1025 library Strings {
1026     /**
1027      * @dev Converts a `uint256` to its ASCII `string` representation.
1028      */
1029     function toString(uint256 value) internal pure returns (string memory) {
1030         // Inspired by OraclizeAPI's implementation - MIT licence
1031         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1032 
1033         if (value == 0) {
1034             return "0";
1035         }
1036         uint256 temp = value;
1037         uint256 digits;
1038         while (temp != 0) {
1039             digits++;
1040             temp /= 10;
1041         }
1042         bytes memory buffer = new bytes(digits);
1043         uint256 index = digits - 1;
1044         temp = value;
1045         while (temp != 0) {
1046             buffer[index--] = byte(uint8(48 + temp % 10));
1047             temp /= 10;
1048         }
1049         return string(buffer);
1050     }
1051 }
1052 
1053 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC165
1054 
1055 /**
1056  * @dev Implementation of the {IERC165} interface.
1057  *
1058  * Contracts may inherit from this and call {_registerInterface} to declare
1059  * their support of an interface.
1060  */
1061 contract ERC165 is IERC165 {
1062     /*
1063      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1064      */
1065     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1066 
1067     /**
1068      * @dev Mapping of interface ids to whether or not it's supported.
1069      */
1070     mapping(bytes4 => bool) private _supportedInterfaces;
1071 
1072     constructor () internal {
1073         // Derived contracts need only register support for their own interfaces,
1074         // we register support for ERC165 itself here
1075         _registerInterface(_INTERFACE_ID_ERC165);
1076     }
1077 
1078     /**
1079      * @dev See {IERC165-supportsInterface}.
1080      *
1081      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1082      */
1083     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1084         return _supportedInterfaces[interfaceId];
1085     }
1086 
1087     /**
1088      * @dev Registers the contract as an implementer of the interface defined by
1089      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1090      * registering its interface id is not required.
1091      *
1092      * See {IERC165-supportsInterface}.
1093      *
1094      * Requirements:
1095      *
1096      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1097      */
1098     function _registerInterface(bytes4 interfaceId) internal virtual {
1099         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1100         _supportedInterfaces[interfaceId] = true;
1101     }
1102 }
1103 
1104 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721
1105 
1106 /**
1107  * @dev Required interface of an ERC721 compliant contract.
1108  */
1109 interface IERC721 is IERC165 {
1110     /**
1111      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1112      */
1113     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1114 
1115     /**
1116      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1117      */
1118     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1119 
1120     /**
1121      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1122      */
1123     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1124 
1125     /**
1126      * @dev Returns the number of tokens in ``owner``'s account.
1127      */
1128     function balanceOf(address owner) external view returns (uint256 balance);
1129 
1130     /**
1131      * @dev Returns the owner of the `tokenId` token.
1132      *
1133      * Requirements:
1134      *
1135      * - `tokenId` must exist.
1136      */
1137     function ownerOf(uint256 tokenId) external view returns (address owner);
1138 
1139     /**
1140      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1141      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1142      *
1143      * Requirements:
1144      *
1145      * - `from` cannot be the zero address.
1146      * - `to` cannot be the zero address.
1147      * - `tokenId` token must exist and be owned by `from`.
1148      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1154 
1155     /**
1156      * @dev Transfers `tokenId` token from `from` to `to`.
1157      *
1158      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1159      *
1160      * Requirements:
1161      *
1162      * - `from` cannot be the zero address.
1163      * - `to` cannot be the zero address.
1164      * - `tokenId` token must be owned by `from`.
1165      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function transferFrom(address from, address to, uint256 tokenId) external;
1170 
1171     /**
1172      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1173      * The approval is cleared when the token is transferred.
1174      *
1175      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1176      *
1177      * Requirements:
1178      *
1179      * - The caller must own the token or be an approved operator.
1180      * - `tokenId` must exist.
1181      *
1182      * Emits an {Approval} event.
1183      */
1184     function approve(address to, uint256 tokenId) external;
1185 
1186     /**
1187      * @dev Returns the account approved for `tokenId` token.
1188      *
1189      * Requirements:
1190      *
1191      * - `tokenId` must exist.
1192      */
1193     function getApproved(uint256 tokenId) external view returns (address operator);
1194 
1195     /**
1196      * @dev Approve or remove `operator` as an operator for the caller.
1197      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1198      *
1199      * Requirements:
1200      *
1201      * - The `operator` cannot be the caller.
1202      *
1203      * Emits an {ApprovalForAll} event.
1204      */
1205     function setApprovalForAll(address operator, bool _approved) external;
1206 
1207     /**
1208      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1209      *
1210      * See {setApprovalForAll}
1211      */
1212     function isApprovedForAll(address owner, address operator) external view returns (bool);
1213 
1214     /**
1215       * @dev Safely transfers `tokenId` token from `from` to `to`.
1216       *
1217       * Requirements:
1218       *
1219      * - `from` cannot be the zero address.
1220      * - `to` cannot be the zero address.
1221       * - `tokenId` token must exist and be owned by `from`.
1222       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1223       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1224       *
1225       * Emits a {Transfer} event.
1226       */
1227     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1228 }
1229 
1230 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Ownable
1231 
1232 /**
1233  * @dev Contract module which provides a basic access control mechanism, where
1234  * there is an account (an owner) that can be granted exclusive access to
1235  * specific functions.
1236  *
1237  * By default, the owner account will be the one that deploys the contract. This
1238  * can later be changed with {transferOwnership}.
1239  *
1240  * This module is used through inheritance. It will make available the modifier
1241  * `onlyOwner`, which can be applied to your functions to restrict their use to
1242  * the owner.
1243  */
1244 contract Ownable is Context {
1245     address private _owner;
1246 
1247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1248 
1249     /**
1250      * @dev Initializes the contract setting the deployer as the initial owner.
1251      */
1252     constructor () internal {
1253         address msgSender = _msgSender();
1254         _owner = msgSender;
1255         emit OwnershipTransferred(address(0), msgSender);
1256     }
1257 
1258     /**
1259      * @dev Returns the address of the current owner.
1260      */
1261     function owner() public view returns (address) {
1262         return _owner;
1263     }
1264 
1265     /**
1266      * @dev Throws if called by any account other than the owner.
1267      */
1268     modifier onlyOwner() {
1269         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1270         _;
1271     }
1272 
1273     /**
1274      * @dev Leaves the contract without owner. It will not be possible to call
1275      * `onlyOwner` functions anymore. Can only be called by the current owner.
1276      *
1277      * NOTE: Renouncing ownership will leave the contract without an owner,
1278      * thereby removing any functionality that is only available to the owner.
1279      */
1280     function renounceOwnership() public virtual onlyOwner {
1281         emit OwnershipTransferred(_owner, address(0));
1282         _owner = address(0);
1283     }
1284 
1285     /**
1286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1287      * Can only be called by the current owner.
1288      */
1289     function transferOwnership(address newOwner) public virtual onlyOwner {
1290         require(newOwner != address(0), "Ownable: new owner is the zero address");
1291         emit OwnershipTransferred(_owner, newOwner);
1292         _owner = newOwner;
1293     }
1294 }
1295 
1296 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Pausable
1297 
1298 /**
1299  * @dev Contract module which allows children to implement an emergency stop
1300  * mechanism that can be triggered by an authorized account.
1301  *
1302  * This module is used through inheritance. It will make available the
1303  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1304  * the functions of your contract. Note that they will not be pausable by
1305  * simply including this module, only once the modifiers are put in place.
1306  */
1307 contract Pausable is Context {
1308     /**
1309      * @dev Emitted when the pause is triggered by `account`.
1310      */
1311     event Paused(address account);
1312 
1313     /**
1314      * @dev Emitted when the pause is lifted by `account`.
1315      */
1316     event Unpaused(address account);
1317 
1318     bool private _paused;
1319 
1320     /**
1321      * @dev Initializes the contract in unpaused state.
1322      */
1323     constructor () internal {
1324         _paused = false;
1325     }
1326 
1327     /**
1328      * @dev Returns true if the contract is paused, and false otherwise.
1329      */
1330     function paused() public view returns (bool) {
1331         return _paused;
1332     }
1333 
1334     /**
1335      * @dev Modifier to make a function callable only when the contract is not paused.
1336      *
1337      * Requirements:
1338      *
1339      * - The contract must not be paused.
1340      */
1341     modifier whenNotPaused() {
1342         require(!_paused, "Pausable: paused");
1343         _;
1344     }
1345 
1346     /**
1347      * @dev Modifier to make a function callable only when the contract is paused.
1348      *
1349      * Requirements:
1350      *
1351      * - The contract must be paused.
1352      */
1353     modifier whenPaused() {
1354         require(_paused, "Pausable: not paused");
1355         _;
1356     }
1357 
1358     /**
1359      * @dev Triggers stopped state.
1360      *
1361      * Requirements:
1362      *
1363      * - The contract must not be paused.
1364      */
1365     function _pause() internal virtual whenNotPaused {
1366         _paused = true;
1367         emit Paused(_msgSender());
1368     }
1369 
1370     /**
1371      * @dev Returns to normal state.
1372      *
1373      * Requirements:
1374      *
1375      * - The contract must be paused.
1376      */
1377     function _unpause() internal virtual whenPaused {
1378         _paused = false;
1379         emit Unpaused(_msgSender());
1380     }
1381 }
1382 
1383 // Part: MintableAirdrop
1384 
1385 abstract contract MintableAirdrop is Ownable, IMintableAirdrop {
1386   using SafeMath for uint256;
1387   using ECDSA for bytes32;
1388 
1389   struct AirdropNFT {
1390     uint256 start;
1391     uint256 end;
1392     uint256 upfront;
1393     uint256 amount;
1394     uint256 claimed;
1395     uint256 claimedUpfront;
1396   }
1397 
1398   AirdropNFT[] public airdrops;
1399   address public minter;
1400   bool public mintingLocked;
1401   bool public minterChangeLocked;
1402   address public token;
1403 
1404   event AirdropTokenClaimed(uint256 indexed _aidropId, address owner, uint256 amount);
1405   event AirdropsCreated(uint256 indexed _aidropId, address owner, uint256 amount, uint256 start, uint256 end);
1406 
1407 
1408   constructor(address _token) public {
1409     require(_token != address(0));
1410     token = _token;
1411   }
1412 
1413 
1414   modifier onlyMinter() {
1415     require(minter == msg.sender, "Caller is not authorized to mint");
1416     _;
1417   }
1418 
1419   modifier mintingAllowed() {
1420     require(mintingLocked == false, "MintableAirdrop: Minting has been blocked");
1421     _;
1422   }
1423 
1424   modifier minterChangeAllowed() {
1425     require(minterChangeLocked == false, "MintableAirdrop: The minter has been locked in");
1426     _;
1427   }
1428 
1429   function min(uint256 a, uint256 b) pure private returns(uint256) {
1430     return a < b ? a : b;
1431   }
1432 
1433   function emergencyRescueFunds() onlyOwner external {
1434     IERC20 erc20 = IERC20(token);
1435     uint256 amountToRescue = erc20.balanceOf(address(this));
1436     erc20.transfer(owner(), amountToRescue);
1437   }
1438 
1439   function setMerkleMinter(address _minter) onlyOwner minterChangeAllowed external {
1440     minter = _minter;
1441   }
1442 
1443   function lockMinting() onlyOwner external {
1444     mintingLocked = true;
1445   }
1446 
1447 
1448   function lockMinterChange() onlyOwner external {
1449     minterChangeLocked = true;
1450   }
1451 
1452 
1453   function _mintAirdrop(address _owner, uint256 _amount, uint256 _upfront, uint256 _start, uint256 _end) mintingAllowed internal {
1454     uint256 id = airdrops.length;
1455     airdrops.push(AirdropNFT(_start, _end, _upfront, _amount, 0, 0));
1456     emit AirdropsCreated(id, _owner, _amount + _upfront, _start, _end);
1457   }
1458 
1459   function pendingReward(uint256 _airdropId) public view returns(uint256) {
1460     AirdropNFT memory airdrop = airdrops[_airdropId];
1461     uint256 elapsed = min(airdrop.end, block.timestamp).sub(airdrop.start);
1462     uint256 maxDelta = airdrop.end.sub(airdrop.start);
1463     return airdrop.amount.mul(elapsed).div(maxDelta).sub(airdrop.claimed).add(airdrop.upfront);
1464   }
1465 
1466   function claimed(uint256 _airdropId) external view returns(uint256) {
1467     AirdropNFT memory airdrop = airdrops[_airdropId];
1468     return airdrop.claimed.add(airdrop.claimedUpfront);
1469   }
1470 
1471   function _claimTokens(uint256 _airdropId) internal {
1472     uint256 _now = block.timestamp;
1473 
1474     AirdropNFT storage airdrop = airdrops[_airdropId];
1475 
1476     uint256 upfront = _claimUpfront(airdrop);
1477     require(_now > airdrop.start, "Airdrop: cliff !started");
1478     uint256 yield = pendingReward(_airdropId);
1479     airdrop.claimed += yield;
1480     IERC20(token).transfer(msg.sender, yield.add(upfront));
1481     emit AirdropTokenClaimed(_airdropId, msg.sender, yield);
1482   }
1483 
1484   function _claimUpfront(AirdropNFT storage airdrop) private returns(uint256) {
1485     uint256 upfront = airdrop.upfront;
1486     if (upfront > 0) {
1487       airdrop.upfront = 0;
1488       airdrop.claimedUpfront = upfront;
1489       return upfront;
1490     }
1491     return 0;
1492   }
1493 }
1494 
1495 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Enumerable
1496 
1497 /**
1498  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1499  * @dev See https://eips.ethereum.org/EIPS/eip-721
1500  */
1501 interface IERC721Enumerable is IERC721 {
1502 
1503     /**
1504      * @dev Returns the total amount of tokens stored by the contract.
1505      */
1506     function totalSupply() external view returns (uint256);
1507 
1508     /**
1509      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1510      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1511      */
1512     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1513 
1514     /**
1515      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1516      * Use along with {totalSupply} to enumerate all tokens.
1517      */
1518     function tokenByIndex(uint256 index) external view returns (uint256);
1519 }
1520 
1521 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Metadata
1522 
1523 /**
1524  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1525  * @dev See https://eips.ethereum.org/EIPS/eip-721
1526  */
1527 interface IERC721Metadata is IERC721 {
1528 
1529     /**
1530      * @dev Returns the token collection name.
1531      */
1532     function name() external view returns (string memory);
1533 
1534     /**
1535      * @dev Returns the token collection symbol.
1536      */
1537     function symbol() external view returns (string memory);
1538 
1539     /**
1540      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1541      */
1542     function tokenURI(uint256 tokenId) external view returns (string memory);
1543 }
1544 
1545 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC721
1546 
1547 /**
1548  * @title ERC721 Non-Fungible Token Standard basic implementation
1549  * @dev see https://eips.ethereum.org/EIPS/eip-721
1550  */
1551 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1552     using SafeMath for uint256;
1553     using Address for address;
1554     using EnumerableSet for EnumerableSet.UintSet;
1555     using EnumerableMap for EnumerableMap.UintToAddressMap;
1556     using Strings for uint256;
1557 
1558     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1559     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1560     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1561 
1562     // Mapping from holder address to their (enumerable) set of owned tokens
1563     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1564 
1565     // Enumerable mapping from token ids to their owners
1566     EnumerableMap.UintToAddressMap private _tokenOwners;
1567 
1568     // Mapping from token ID to approved address
1569     mapping (uint256 => address) private _tokenApprovals;
1570 
1571     // Mapping from owner to operator approvals
1572     mapping (address => mapping (address => bool)) private _operatorApprovals;
1573 
1574     // Token name
1575     string private _name;
1576 
1577     // Token symbol
1578     string private _symbol;
1579 
1580     // Optional mapping for token URIs
1581     mapping (uint256 => string) private _tokenURIs;
1582 
1583     // Base URI
1584     string private _baseURI;
1585 
1586     /*
1587      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1588      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1589      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1590      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1591      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1592      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1593      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1594      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1595      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1596      *
1597      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1598      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1599      */
1600     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1601 
1602     /*
1603      *     bytes4(keccak256('name()')) == 0x06fdde03
1604      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1605      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1606      *
1607      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1608      */
1609     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1610 
1611     /*
1612      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1613      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1614      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1615      *
1616      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1617      */
1618     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1619 
1620     /**
1621      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1622      */
1623     constructor (string memory name, string memory symbol) public {
1624         _name = name;
1625         _symbol = symbol;
1626 
1627         // register the supported interfaces to conform to ERC721 via ERC165
1628         _registerInterface(_INTERFACE_ID_ERC721);
1629         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1630         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1631     }
1632 
1633     /**
1634      * @dev See {IERC721-balanceOf}.
1635      */
1636     function balanceOf(address owner) public view override returns (uint256) {
1637         require(owner != address(0), "ERC721: balance query for the zero address");
1638 
1639         return _holderTokens[owner].length();
1640     }
1641 
1642     /**
1643      * @dev See {IERC721-ownerOf}.
1644      */
1645     function ownerOf(uint256 tokenId) public view override returns (address) {
1646         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1647     }
1648 
1649     /**
1650      * @dev See {IERC721Metadata-name}.
1651      */
1652     function name() public view override returns (string memory) {
1653         return _name;
1654     }
1655 
1656     /**
1657      * @dev See {IERC721Metadata-symbol}.
1658      */
1659     function symbol() public view override returns (string memory) {
1660         return _symbol;
1661     }
1662 
1663     /**
1664      * @dev See {IERC721Metadata-tokenURI}.
1665      */
1666     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1667         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1668 
1669         string memory _tokenURI = _tokenURIs[tokenId];
1670 
1671         // If there is no base URI, return the token URI.
1672         if (bytes(_baseURI).length == 0) {
1673             return _tokenURI;
1674         }
1675         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1676         if (bytes(_tokenURI).length > 0) {
1677             return string(abi.encodePacked(_baseURI, _tokenURI));
1678         }
1679         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1680         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1681     }
1682 
1683     /**
1684     * @dev Returns the base URI set via {_setBaseURI}. This will be
1685     * automatically added as a prefix in {tokenURI} to each token's URI, or
1686     * to the token ID if no specific URI is set for that token ID.
1687     */
1688     function baseURI() public view returns (string memory) {
1689         return _baseURI;
1690     }
1691 
1692     /**
1693      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1694      */
1695     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1696         return _holderTokens[owner].at(index);
1697     }
1698 
1699     /**
1700      * @dev See {IERC721Enumerable-totalSupply}.
1701      */
1702     function totalSupply() public view override returns (uint256) {
1703         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1704         return _tokenOwners.length();
1705     }
1706 
1707     /**
1708      * @dev See {IERC721Enumerable-tokenByIndex}.
1709      */
1710     function tokenByIndex(uint256 index) public view override returns (uint256) {
1711         (uint256 tokenId, ) = _tokenOwners.at(index);
1712         return tokenId;
1713     }
1714 
1715     /**
1716      * @dev See {IERC721-approve}.
1717      */
1718     function approve(address to, uint256 tokenId) public virtual override {
1719         address owner = ownerOf(tokenId);
1720         require(to != owner, "ERC721: approval to current owner");
1721 
1722         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1723             "ERC721: approve caller is not owner nor approved for all"
1724         );
1725 
1726         _approve(to, tokenId);
1727     }
1728 
1729     /**
1730      * @dev See {IERC721-getApproved}.
1731      */
1732     function getApproved(uint256 tokenId) public view override returns (address) {
1733         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1734 
1735         return _tokenApprovals[tokenId];
1736     }
1737 
1738     /**
1739      * @dev See {IERC721-setApprovalForAll}.
1740      */
1741     function setApprovalForAll(address operator, bool approved) public virtual override {
1742         require(operator != _msgSender(), "ERC721: approve to caller");
1743 
1744         _operatorApprovals[_msgSender()][operator] = approved;
1745         emit ApprovalForAll(_msgSender(), operator, approved);
1746     }
1747 
1748     /**
1749      * @dev See {IERC721-isApprovedForAll}.
1750      */
1751     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1752         return _operatorApprovals[owner][operator];
1753     }
1754 
1755     /**
1756      * @dev See {IERC721-transferFrom}.
1757      */
1758     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1759         //solhint-disable-next-line max-line-length
1760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1761 
1762         _transfer(from, to, tokenId);
1763     }
1764 
1765     /**
1766      * @dev See {IERC721-safeTransferFrom}.
1767      */
1768     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1769         safeTransferFrom(from, to, tokenId, "");
1770     }
1771 
1772     /**
1773      * @dev See {IERC721-safeTransferFrom}.
1774      */
1775     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1776         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1777         _safeTransfer(from, to, tokenId, _data);
1778     }
1779 
1780     /**
1781      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1782      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1783      *
1784      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1785      *
1786      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1787      * implement alternative mechanisms to perform token transfer, such as signature-based.
1788      *
1789      * Requirements:
1790      *
1791      * - `from` cannot be the zero address.
1792      * - `to` cannot be the zero address.
1793      * - `tokenId` token must exist and be owned by `from`.
1794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1795      *
1796      * Emits a {Transfer} event.
1797      */
1798     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1799         _transfer(from, to, tokenId);
1800         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1801     }
1802 
1803     /**
1804      * @dev Returns whether `tokenId` exists.
1805      *
1806      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1807      *
1808      * Tokens start existing when they are minted (`_mint`),
1809      * and stop existing when they are burned (`_burn`).
1810      */
1811     function _exists(uint256 tokenId) internal view returns (bool) {
1812         return _tokenOwners.contains(tokenId);
1813     }
1814 
1815     /**
1816      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1817      *
1818      * Requirements:
1819      *
1820      * - `tokenId` must exist.
1821      */
1822     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1823         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1824         address owner = ownerOf(tokenId);
1825         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1826     }
1827 
1828     /**
1829      * @dev Safely mints `tokenId` and transfers it to `to`.
1830      *
1831      * Requirements:
1832      d*
1833      * - `tokenId` must not exist.
1834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1835      *
1836      * Emits a {Transfer} event.
1837      */
1838     function _safeMint(address to, uint256 tokenId) internal virtual {
1839         _safeMint(to, tokenId, "");
1840     }
1841 
1842     /**
1843      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1844      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1845      */
1846     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1847         _mint(to, tokenId);
1848         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1849     }
1850 
1851     /**
1852      * @dev Mints `tokenId` and transfers it to `to`.
1853      *
1854      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1855      *
1856      * Requirements:
1857      *
1858      * - `tokenId` must not exist.
1859      * - `to` cannot be the zero address.
1860      *
1861      * Emits a {Transfer} event.
1862      */
1863     function _mint(address to, uint256 tokenId) internal virtual {
1864         require(to != address(0), "ERC721: mint to the zero address");
1865         require(!_exists(tokenId), "ERC721: token already minted");
1866 
1867         _beforeTokenTransfer(address(0), to, tokenId);
1868 
1869         _holderTokens[to].add(tokenId);
1870 
1871         _tokenOwners.set(tokenId, to);
1872 
1873         emit Transfer(address(0), to, tokenId);
1874     }
1875 
1876     /**
1877      * @dev Destroys `tokenId`.
1878      * The approval is cleared when the token is burned.
1879      *
1880      * Requirements:
1881      *
1882      * - `tokenId` must exist.
1883      *
1884      * Emits a {Transfer} event.
1885      */
1886     function _burn(uint256 tokenId) internal virtual {
1887         address owner = ownerOf(tokenId);
1888 
1889         _beforeTokenTransfer(owner, address(0), tokenId);
1890 
1891         // Clear approvals
1892         _approve(address(0), tokenId);
1893 
1894         // Clear metadata (if any)
1895         if (bytes(_tokenURIs[tokenId]).length != 0) {
1896             delete _tokenURIs[tokenId];
1897         }
1898 
1899         _holderTokens[owner].remove(tokenId);
1900 
1901         _tokenOwners.remove(tokenId);
1902 
1903         emit Transfer(owner, address(0), tokenId);
1904     }
1905 
1906     /**
1907      * @dev Transfers `tokenId` from `from` to `to`.
1908      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1909      *
1910      * Requirements:
1911      *
1912      * - `to` cannot be the zero address.
1913      * - `tokenId` token must be owned by `from`.
1914      *
1915      * Emits a {Transfer} event.
1916      */
1917     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1918         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1919         require(to != address(0), "ERC721: transfer to the zero address");
1920 
1921         _beforeTokenTransfer(from, to, tokenId);
1922 
1923         // Clear approvals from the previous owner
1924         _approve(address(0), tokenId);
1925 
1926         _holderTokens[from].remove(tokenId);
1927         _holderTokens[to].add(tokenId);
1928 
1929         _tokenOwners.set(tokenId, to);
1930 
1931         emit Transfer(from, to, tokenId);
1932     }
1933 
1934     /**
1935      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1936      *
1937      * Requirements:
1938      *
1939      * - `tokenId` must exist.
1940      */
1941     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1942         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1943         _tokenURIs[tokenId] = _tokenURI;
1944     }
1945 
1946     /**
1947      * @dev Internal function to set the base URI for all token IDs. It is
1948      * automatically added as a prefix to the value returned in {tokenURI},
1949      * or to the token ID if {tokenURI} is empty.
1950      */
1951     function _setBaseURI(string memory baseURI_) internal virtual {
1952         _baseURI = baseURI_;
1953     }
1954 
1955     /**
1956      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1957      * The call is not executed if the target address is not a contract.
1958      *
1959      * @param from address representing the previous owner of the given token ID
1960      * @param to target address that will receive the tokens
1961      * @param tokenId uint256 ID of the token to be transferred
1962      * @param _data bytes optional data to send along with the call
1963      * @return bool whether the call correctly returned the expected magic value
1964      */
1965     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1966         private returns (bool)
1967     {
1968         if (!to.isContract()) {
1969             return true;
1970         }
1971         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1972             IERC721Receiver(to).onERC721Received.selector,
1973             _msgSender(),
1974             from,
1975             tokenId,
1976             _data
1977         ), "ERC721: transfer to non ERC721Receiver implementer");
1978         bytes4 retval = abi.decode(returndata, (bytes4));
1979         return (retval == _ERC721_RECEIVED);
1980     }
1981 
1982     function _approve(address to, uint256 tokenId) private {
1983         _tokenApprovals[tokenId] = to;
1984         emit Approval(ownerOf(tokenId), to, tokenId);
1985     }
1986 
1987     /**
1988      * @dev Hook that is called before any token transfer. This includes minting
1989      * and burning.
1990      *
1991      * Calling conditions:
1992      *
1993      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1994      * transferred to `to`.
1995      * - When `from` is zero, `tokenId` will be minted for `to`.
1996      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1997      * - `from` cannot be the zero address.
1998      * - `to` cannot be the zero address.
1999      *
2000      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2001      */
2002     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2003 }
2004 
2005 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC721Pausable
2006 
2007 /**
2008  * @dev ERC721 token with pausable token transfers, minting and burning.
2009  *
2010  * Useful for scenarios such as preventing trades until the end of an evaluation
2011  * period, or having an emergency switch for freezing all token transfers in the
2012  * event of a large bug.
2013  */
2014 abstract contract ERC721Pausable is ERC721, Pausable {
2015     /**
2016      * @dev See {ERC721-_beforeTokenTransfer}.
2017      *
2018      * Requirements:
2019      *
2020      * - the contract must not be paused.
2021      */
2022     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2023         super._beforeTokenTransfer(from, to, tokenId);
2024 
2025         require(!paused(), "ERC721Pausable: token transfer while paused");
2026     }
2027 }
2028 
2029 // File: SwordAndShield.sol
2030 
2031 contract SwordAndShield is MintableAirdrop, ERC721Pausable {
2032 
2033   constructor(address _yggToken)
2034   ERC721("YGG Sword and Shield", "YGG S/S")
2035   MintableAirdrop(_yggToken) public {
2036     pause(); 
2037   }
2038 
2039   function mintAirdrops(address _owner, uint256 _amount, uint256 _upfront, uint256 _start, uint256 _end) external onlyMinter whenNotPaused override returns(uint256){
2040     require(_end > _start, "Airdrop: wrong vehicule parametres");
2041     require(_start > 0, "Airdrop: start cannot be 0");
2042     require(_owner != address(0), "Airdrop: address non existent");
2043 
2044     // id starts at 0 and gets value of the airdrop's index in the array
2045     uint id = airdrops.length;
2046     _mint(_owner, id);
2047     _mint(_owner, id + 1);
2048     _mintAirdrop(_owner, _amount / 2, _upfront / 2, _start, _end);
2049     _mintAirdrop(_owner, _amount / 2, _upfront / 2, _start, _end);
2050   }
2051 
2052 
2053   modifier onlyOwnerOf(uint _airdropId) {
2054     require(msg.sender == ownerOf(_airdropId), "Airdrop: You must be the owner of the NFT to claim tokens");
2055     _;
2056   }
2057 
2058   function claimTokens(uint256 _airdropId) external whenNotPaused onlyOwnerOf(_airdropId) {
2059     _claimTokens(_airdropId);
2060   }
2061 
2062   function pause() public onlyOwner {
2063     _pause();
2064   }
2065 
2066   function unpause() external onlyOwner {
2067     _unpause();
2068   }
2069 
2070   function updateURI(string memory newURI) external onlyOwner {
2071 		_setBaseURI(newURI);
2072 	}
2073 }
