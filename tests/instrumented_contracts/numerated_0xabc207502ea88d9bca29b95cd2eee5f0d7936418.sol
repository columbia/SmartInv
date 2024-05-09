1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
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
170 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ECDSA
171 
172 /**
173  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
174  *
175  * These functions can be used to verify that a message was signed by the holder
176  * of the private keys of a given address.
177  */
178 library ECDSA {
179     /**
180      * @dev Returns the address that signed a hashed message (`hash`) with
181      * `signature`. This address can then be used for verification purposes.
182      *
183      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
184      * this function rejects them by requiring the `s` value to be in the lower
185      * half order, and the `v` value to be either 27 or 28.
186      *
187      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
188      * verification to be secure: it is possible to craft signatures that
189      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
190      * this is by receiving a hash of the original message (which may otherwise
191      * be too long), and then calling {toEthSignedMessageHash} on it.
192      */
193     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
194         // Check the signature length
195         if (signature.length != 65) {
196             revert("ECDSA: invalid signature length");
197         }
198 
199         // Divide the signature in r, s and v variables
200         bytes32 r;
201         bytes32 s;
202         uint8 v;
203 
204         // ecrecover takes the signature parameters, and the only way to get them
205         // currently is to use assembly.
206         // solhint-disable-next-line no-inline-assembly
207         assembly {
208             r := mload(add(signature, 0x20))
209             s := mload(add(signature, 0x40))
210             v := byte(0, mload(add(signature, 0x60)))
211         }
212 
213         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
214         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
215         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
216         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
217         //
218         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
219         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
220         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
221         // these malleable signatures as well.
222         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
223             revert("ECDSA: invalid signature 's' value");
224         }
225 
226         if (v != 27 && v != 28) {
227             revert("ECDSA: invalid signature 'v' value");
228         }
229 
230         // If the signature is valid (and not malleable), return the signer address
231         address signer = ecrecover(hash, v, r, s);
232         require(signer != address(0), "ECDSA: invalid signature");
233 
234         return signer;
235     }
236 
237     /**
238      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
239      * replicates the behavior of the
240      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
241      * JSON-RPC method.
242      *
243      * See {recover}.
244      */
245     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
246         // 32 is the length in bytes of hash,
247         // enforced by the type signature above
248         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
249     }
250 }
251 
252 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableMap
253 
254 /**
255  * @dev Library for managing an enumerable variant of Solidity's
256  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
257  * type.
258  *
259  * Maps have the following properties:
260  *
261  * - Entries are added, removed, and checked for existence in constant time
262  * (O(1)).
263  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
264  *
265  * ```
266  * contract Example {
267  *     // Add the library methods
268  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
269  *
270  *     // Declare a set state variable
271  *     EnumerableMap.UintToAddressMap private myMap;
272  * }
273  * ```
274  *
275  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
276  * supported.
277  */
278 library EnumerableMap {
279     // To implement this library for multiple types with as little code
280     // repetition as possible, we write it in terms of a generic Map type with
281     // bytes32 keys and values.
282     // The Map implementation uses private functions, and user-facing
283     // implementations (such as Uint256ToAddressMap) are just wrappers around
284     // the underlying Map.
285     // This means that we can only create new EnumerableMaps for types that fit
286     // in bytes32.
287 
288     struct MapEntry {
289         bytes32 _key;
290         bytes32 _value;
291     }
292 
293     struct Map {
294         // Storage of map keys and values
295         MapEntry[] _entries;
296 
297         // Position of the entry defined by a key in the `entries` array, plus 1
298         // because index 0 means a key is not in the map.
299         mapping (bytes32 => uint256) _indexes;
300     }
301 
302     /**
303      * @dev Adds a key-value pair to a map, or updates the value for an existing
304      * key. O(1).
305      *
306      * Returns true if the key was added to the map, that is if it was not
307      * already present.
308      */
309     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
310         // We read and store the key's index to prevent multiple reads from the same storage slot
311         uint256 keyIndex = map._indexes[key];
312 
313         if (keyIndex == 0) { // Equivalent to !contains(map, key)
314             map._entries.push(MapEntry({ _key: key, _value: value }));
315             // The entry is stored at length-1, but we add 1 to all indexes
316             // and use 0 as a sentinel value
317             map._indexes[key] = map._entries.length;
318             return true;
319         } else {
320             map._entries[keyIndex - 1]._value = value;
321             return false;
322         }
323     }
324 
325     /**
326      * @dev Removes a key-value pair from a map. O(1).
327      *
328      * Returns true if the key was removed from the map, that is if it was present.
329      */
330     function _remove(Map storage map, bytes32 key) private returns (bool) {
331         // We read and store the key's index to prevent multiple reads from the same storage slot
332         uint256 keyIndex = map._indexes[key];
333 
334         if (keyIndex != 0) { // Equivalent to contains(map, key)
335             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
336             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
337             // This modifies the order of the array, as noted in {at}.
338 
339             uint256 toDeleteIndex = keyIndex - 1;
340             uint256 lastIndex = map._entries.length - 1;
341 
342             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
343             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
344 
345             MapEntry storage lastEntry = map._entries[lastIndex];
346 
347             // Move the last entry to the index where the entry to delete is
348             map._entries[toDeleteIndex] = lastEntry;
349             // Update the index for the moved entry
350             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
351 
352             // Delete the slot where the moved entry was stored
353             map._entries.pop();
354 
355             // Delete the index for the deleted slot
356             delete map._indexes[key];
357 
358             return true;
359         } else {
360             return false;
361         }
362     }
363 
364     /**
365      * @dev Returns true if the key is in the map. O(1).
366      */
367     function _contains(Map storage map, bytes32 key) private view returns (bool) {
368         return map._indexes[key] != 0;
369     }
370 
371     /**
372      * @dev Returns the number of key-value pairs in the map. O(1).
373      */
374     function _length(Map storage map) private view returns (uint256) {
375         return map._entries.length;
376     }
377 
378    /**
379     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
380     *
381     * Note that there are no guarantees on the ordering of entries inside the
382     * array, and it may change when more entries are added or removed.
383     *
384     * Requirements:
385     *
386     * - `index` must be strictly less than {length}.
387     */
388     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
389         require(map._entries.length > index, "EnumerableMap: index out of bounds");
390 
391         MapEntry storage entry = map._entries[index];
392         return (entry._key, entry._value);
393     }
394 
395     /**
396      * @dev Returns the value associated with `key`.  O(1).
397      *
398      * Requirements:
399      *
400      * - `key` must be in the map.
401      */
402     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
403         return _get(map, key, "EnumerableMap: nonexistent key");
404     }
405 
406     /**
407      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
408      */
409     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
410         uint256 keyIndex = map._indexes[key];
411         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
412         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
413     }
414 
415     // UintToAddressMap
416 
417     struct UintToAddressMap {
418         Map _inner;
419     }
420 
421     /**
422      * @dev Adds a key-value pair to a map, or updates the value for an existing
423      * key. O(1).
424      *
425      * Returns true if the key was added to the map, that is if it was not
426      * already present.
427      */
428     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
429         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
430     }
431 
432     /**
433      * @dev Removes a value from a set. O(1).
434      *
435      * Returns true if the key was removed from the map, that is if it was present.
436      */
437     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
438         return _remove(map._inner, bytes32(key));
439     }
440 
441     /**
442      * @dev Returns true if the key is in the map. O(1).
443      */
444     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
445         return _contains(map._inner, bytes32(key));
446     }
447 
448     /**
449      * @dev Returns the number of elements in the map. O(1).
450      */
451     function length(UintToAddressMap storage map) internal view returns (uint256) {
452         return _length(map._inner);
453     }
454 
455    /**
456     * @dev Returns the element stored at position `index` in the set. O(1).
457     * Note that there are no guarantees on the ordering of values inside the
458     * array, and it may change when more values are added or removed.
459     *
460     * Requirements:
461     *
462     * - `index` must be strictly less than {length}.
463     */
464     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
465         (bytes32 key, bytes32 value) = _at(map._inner, index);
466         return (uint256(key), address(uint256(value)));
467     }
468 
469     /**
470      * @dev Returns the value associated with `key`.  O(1).
471      *
472      * Requirements:
473      *
474      * - `key` must be in the map.
475      */
476     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
477         return address(uint256(_get(map._inner, bytes32(key))));
478     }
479 
480     /**
481      * @dev Same as {get}, with a custom error message when `key` is not in the map.
482      */
483     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
484         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
485     }
486 }
487 
488 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/EnumerableSet
489 
490 /**
491  * @dev Library for managing
492  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
493  * types.
494  *
495  * Sets have the following properties:
496  *
497  * - Elements are added, removed, and checked for existence in constant time
498  * (O(1)).
499  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
500  *
501  * ```
502  * contract Example {
503  *     // Add the library methods
504  *     using EnumerableSet for EnumerableSet.AddressSet;
505  *
506  *     // Declare a set state variable
507  *     EnumerableSet.AddressSet private mySet;
508  * }
509  * ```
510  *
511  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
512  * (`UintSet`) are supported.
513  */
514 library EnumerableSet {
515     // To implement this library for multiple types with as little code
516     // repetition as possible, we write it in terms of a generic Set type with
517     // bytes32 values.
518     // The Set implementation uses private functions, and user-facing
519     // implementations (such as AddressSet) are just wrappers around the
520     // underlying Set.
521     // This means that we can only create new EnumerableSets for types that fit
522     // in bytes32.
523 
524     struct Set {
525         // Storage of set values
526         bytes32[] _values;
527 
528         // Position of the value in the `values` array, plus 1 because index 0
529         // means a value is not in the set.
530         mapping (bytes32 => uint256) _indexes;
531     }
532 
533     /**
534      * @dev Add a value to a set. O(1).
535      *
536      * Returns true if the value was added to the set, that is if it was not
537      * already present.
538      */
539     function _add(Set storage set, bytes32 value) private returns (bool) {
540         if (!_contains(set, value)) {
541             set._values.push(value);
542             // The value is stored at length-1, but we add 1 to all indexes
543             // and use 0 as a sentinel value
544             set._indexes[value] = set._values.length;
545             return true;
546         } else {
547             return false;
548         }
549     }
550 
551     /**
552      * @dev Removes a value from a set. O(1).
553      *
554      * Returns true if the value was removed from the set, that is if it was
555      * present.
556      */
557     function _remove(Set storage set, bytes32 value) private returns (bool) {
558         // We read and store the value's index to prevent multiple reads from the same storage slot
559         uint256 valueIndex = set._indexes[value];
560 
561         if (valueIndex != 0) { // Equivalent to contains(set, value)
562             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
563             // the array, and then remove the last element (sometimes called as 'swap and pop').
564             // This modifies the order of the array, as noted in {at}.
565 
566             uint256 toDeleteIndex = valueIndex - 1;
567             uint256 lastIndex = set._values.length - 1;
568 
569             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
570             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
571 
572             bytes32 lastvalue = set._values[lastIndex];
573 
574             // Move the last value to the index where the value to delete is
575             set._values[toDeleteIndex] = lastvalue;
576             // Update the index for the moved value
577             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
578 
579             // Delete the slot where the moved value was stored
580             set._values.pop();
581 
582             // Delete the index for the deleted slot
583             delete set._indexes[value];
584 
585             return true;
586         } else {
587             return false;
588         }
589     }
590 
591     /**
592      * @dev Returns true if the value is in the set. O(1).
593      */
594     function _contains(Set storage set, bytes32 value) private view returns (bool) {
595         return set._indexes[value] != 0;
596     }
597 
598     /**
599      * @dev Returns the number of values on the set. O(1).
600      */
601     function _length(Set storage set) private view returns (uint256) {
602         return set._values.length;
603     }
604 
605    /**
606     * @dev Returns the value stored at position `index` in the set. O(1).
607     *
608     * Note that there are no guarantees on the ordering of values inside the
609     * array, and it may change when more values are added or removed.
610     *
611     * Requirements:
612     *
613     * - `index` must be strictly less than {length}.
614     */
615     function _at(Set storage set, uint256 index) private view returns (bytes32) {
616         require(set._values.length > index, "EnumerableSet: index out of bounds");
617         return set._values[index];
618     }
619 
620     // AddressSet
621 
622     struct AddressSet {
623         Set _inner;
624     }
625 
626     /**
627      * @dev Add a value to a set. O(1).
628      *
629      * Returns true if the value was added to the set, that is if it was not
630      * already present.
631      */
632     function add(AddressSet storage set, address value) internal returns (bool) {
633         return _add(set._inner, bytes32(uint256(value)));
634     }
635 
636     /**
637      * @dev Removes a value from a set. O(1).
638      *
639      * Returns true if the value was removed from the set, that is if it was
640      * present.
641      */
642     function remove(AddressSet storage set, address value) internal returns (bool) {
643         return _remove(set._inner, bytes32(uint256(value)));
644     }
645 
646     /**
647      * @dev Returns true if the value is in the set. O(1).
648      */
649     function contains(AddressSet storage set, address value) internal view returns (bool) {
650         return _contains(set._inner, bytes32(uint256(value)));
651     }
652 
653     /**
654      * @dev Returns the number of values in the set. O(1).
655      */
656     function length(AddressSet storage set) internal view returns (uint256) {
657         return _length(set._inner);
658     }
659 
660    /**
661     * @dev Returns the value stored at position `index` in the set. O(1).
662     *
663     * Note that there are no guarantees on the ordering of values inside the
664     * array, and it may change when more values are added or removed.
665     *
666     * Requirements:
667     *
668     * - `index` must be strictly less than {length}.
669     */
670     function at(AddressSet storage set, uint256 index) internal view returns (address) {
671         return address(uint256(_at(set._inner, index)));
672     }
673 
674 
675     // UintSet
676 
677     struct UintSet {
678         Set _inner;
679     }
680 
681     /**
682      * @dev Add a value to a set. O(1).
683      *
684      * Returns true if the value was added to the set, that is if it was not
685      * already present.
686      */
687     function add(UintSet storage set, uint256 value) internal returns (bool) {
688         return _add(set._inner, bytes32(value));
689     }
690 
691     /**
692      * @dev Removes a value from a set. O(1).
693      *
694      * Returns true if the value was removed from the set, that is if it was
695      * present.
696      */
697     function remove(UintSet storage set, uint256 value) internal returns (bool) {
698         return _remove(set._inner, bytes32(value));
699     }
700 
701     /**
702      * @dev Returns true if the value is in the set. O(1).
703      */
704     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
705         return _contains(set._inner, bytes32(value));
706     }
707 
708     /**
709      * @dev Returns the number of values on the set. O(1).
710      */
711     function length(UintSet storage set) internal view returns (uint256) {
712         return _length(set._inner);
713     }
714 
715    /**
716     * @dev Returns the value stored at position `index` in the set. O(1).
717     *
718     * Note that there are no guarantees on the ordering of values inside the
719     * array, and it may change when more values are added or removed.
720     *
721     * Requirements:
722     *
723     * - `index` must be strictly less than {length}.
724     */
725     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
726         return uint256(_at(set._inner, index));
727     }
728 }
729 
730 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC165
731 
732 /**
733  * @dev Interface of the ERC165 standard, as defined in the
734  * https://eips.ethereum.org/EIPS/eip-165[EIP].
735  *
736  * Implementers can declare support of contract interfaces, which can then be
737  * queried by others ({ERC165Checker}).
738  *
739  * For an implementation, see {ERC165}.
740  */
741 interface IERC165 {
742     /**
743      * @dev Returns true if this contract implements the interface defined by
744      * `interfaceId`. See the corresponding
745      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
746      * to learn more about how these ids are created.
747      *
748      * This function call must use less than 30 000 gas.
749      */
750     function supportsInterface(bytes4 interfaceId) external view returns (bool);
751 }
752 
753 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Receiver
754 
755 /**
756  * @title ERC721 token receiver interface
757  * @dev Interface for any contract that wants to support safeTransfers
758  * from ERC721 asset contracts.
759  */
760 interface IERC721Receiver {
761     /**
762      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
763      * by `operator` from `from`, this function is called.
764      *
765      * It must return its Solidity selector to confirm the token transfer.
766      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
767      *
768      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
769      */
770     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
771     external returns (bytes4);
772 }
773 
774 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
775 
776 /**
777  * @dev Wrappers over Solidity's arithmetic operations with added overflow
778  * checks.
779  *
780  * Arithmetic operations in Solidity wrap on overflow. This can easily result
781  * in bugs, because programmers usually assume that an overflow raises an
782  * error, which is the standard behavior in high level programming languages.
783  * `SafeMath` restores this intuition by reverting the transaction when an
784  * operation overflows.
785  *
786  * Using this library instead of the unchecked operations eliminates an entire
787  * class of bugs, so it's recommended to use it always.
788  */
789 library SafeMath {
790     /**
791      * @dev Returns the addition of two unsigned integers, reverting on
792      * overflow.
793      *
794      * Counterpart to Solidity's `+` operator.
795      *
796      * Requirements:
797      *
798      * - Addition cannot overflow.
799      */
800     function add(uint256 a, uint256 b) internal pure returns (uint256) {
801         uint256 c = a + b;
802         require(c >= a, "SafeMath: addition overflow");
803 
804         return c;
805     }
806 
807     /**
808      * @dev Returns the subtraction of two unsigned integers, reverting on
809      * overflow (when the result is negative).
810      *
811      * Counterpart to Solidity's `-` operator.
812      *
813      * Requirements:
814      *
815      * - Subtraction cannot overflow.
816      */
817     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
818         return sub(a, b, "SafeMath: subtraction overflow");
819     }
820 
821     /**
822      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
823      * overflow (when the result is negative).
824      *
825      * Counterpart to Solidity's `-` operator.
826      *
827      * Requirements:
828      *
829      * - Subtraction cannot overflow.
830      */
831     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
832         require(b <= a, errorMessage);
833         uint256 c = a - b;
834 
835         return c;
836     }
837 
838     /**
839      * @dev Returns the multiplication of two unsigned integers, reverting on
840      * overflow.
841      *
842      * Counterpart to Solidity's `*` operator.
843      *
844      * Requirements:
845      *
846      * - Multiplication cannot overflow.
847      */
848     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
849         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
850         // benefit is lost if 'b' is also tested.
851         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
852         if (a == 0) {
853             return 0;
854         }
855 
856         uint256 c = a * b;
857         require(c / a == b, "SafeMath: multiplication overflow");
858 
859         return c;
860     }
861 
862     /**
863      * @dev Returns the integer division of two unsigned integers. Reverts on
864      * division by zero. The result is rounded towards zero.
865      *
866      * Counterpart to Solidity's `/` operator. Note: this function uses a
867      * `revert` opcode (which leaves remaining gas untouched) while Solidity
868      * uses an invalid opcode to revert (consuming all remaining gas).
869      *
870      * Requirements:
871      *
872      * - The divisor cannot be zero.
873      */
874     function div(uint256 a, uint256 b) internal pure returns (uint256) {
875         return div(a, b, "SafeMath: division by zero");
876     }
877 
878     /**
879      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
880      * division by zero. The result is rounded towards zero.
881      *
882      * Counterpart to Solidity's `/` operator. Note: this function uses a
883      * `revert` opcode (which leaves remaining gas untouched) while Solidity
884      * uses an invalid opcode to revert (consuming all remaining gas).
885      *
886      * Requirements:
887      *
888      * - The divisor cannot be zero.
889      */
890     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
891         require(b > 0, errorMessage);
892         uint256 c = a / b;
893         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
894 
895         return c;
896     }
897 
898     /**
899      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
900      * Reverts when dividing by zero.
901      *
902      * Counterpart to Solidity's `%` operator. This function uses a `revert`
903      * opcode (which leaves remaining gas untouched) while Solidity uses an
904      * invalid opcode to revert (consuming all remaining gas).
905      *
906      * Requirements:
907      *
908      * - The divisor cannot be zero.
909      */
910     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
911         return mod(a, b, "SafeMath: modulo by zero");
912     }
913 
914     /**
915      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
916      * Reverts with custom message when dividing by zero.
917      *
918      * Counterpart to Solidity's `%` operator. This function uses a `revert`
919      * opcode (which leaves remaining gas untouched) while Solidity uses an
920      * invalid opcode to revert (consuming all remaining gas).
921      *
922      * Requirements:
923      *
924      * - The divisor cannot be zero.
925      */
926     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
927         require(b != 0, errorMessage);
928         return a % b;
929     }
930 }
931 
932 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Strings
933 
934 /**
935  * @dev String operations.
936  */
937 library Strings {
938     /**
939      * @dev Converts a `uint256` to its ASCII `string` representation.
940      */
941     function toString(uint256 value) internal pure returns (string memory) {
942         // Inspired by OraclizeAPI's implementation - MIT licence
943         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
944 
945         if (value == 0) {
946             return "0";
947         }
948         uint256 temp = value;
949         uint256 digits;
950         while (temp != 0) {
951             digits++;
952             temp /= 10;
953         }
954         bytes memory buffer = new bytes(digits);
955         uint256 index = digits - 1;
956         temp = value;
957         while (temp != 0) {
958             buffer[index--] = byte(uint8(48 + temp % 10));
959             temp /= 10;
960         }
961         return string(buffer);
962     }
963 }
964 
965 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC165
966 
967 /**
968  * @dev Implementation of the {IERC165} interface.
969  *
970  * Contracts may inherit from this and call {_registerInterface} to declare
971  * their support of an interface.
972  */
973 contract ERC165 is IERC165 {
974     /*
975      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
976      */
977     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
978 
979     /**
980      * @dev Mapping of interface ids to whether or not it's supported.
981      */
982     mapping(bytes4 => bool) private _supportedInterfaces;
983 
984     constructor () internal {
985         // Derived contracts need only register support for their own interfaces,
986         // we register support for ERC165 itself here
987         _registerInterface(_INTERFACE_ID_ERC165);
988     }
989 
990     /**
991      * @dev See {IERC165-supportsInterface}.
992      *
993      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
994      */
995     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
996         return _supportedInterfaces[interfaceId];
997     }
998 
999     /**
1000      * @dev Registers the contract as an implementer of the interface defined by
1001      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1002      * registering its interface id is not required.
1003      *
1004      * See {IERC165-supportsInterface}.
1005      *
1006      * Requirements:
1007      *
1008      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1009      */
1010     function _registerInterface(bytes4 interfaceId) internal virtual {
1011         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1012         _supportedInterfaces[interfaceId] = true;
1013     }
1014 }
1015 
1016 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721
1017 
1018 /**
1019  * @dev Required interface of an ERC721 compliant contract.
1020  */
1021 interface IERC721 is IERC165 {
1022     /**
1023      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1024      */
1025     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1026 
1027     /**
1028      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1029      */
1030     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1031 
1032     /**
1033      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1034      */
1035     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1036 
1037     /**
1038      * @dev Returns the number of tokens in ``owner``'s account.
1039      */
1040     function balanceOf(address owner) external view returns (uint256 balance);
1041 
1042     /**
1043      * @dev Returns the owner of the `tokenId` token.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must exist.
1048      */
1049     function ownerOf(uint256 tokenId) external view returns (address owner);
1050 
1051     /**
1052      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1053      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1054      *
1055      * Requirements:
1056      *
1057      * - `from` cannot be the zero address.
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must exist and be owned by `from`.
1060      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1066 
1067     /**
1068      * @dev Transfers `tokenId` token from `from` to `to`.
1069      *
1070      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1071      *
1072      * Requirements:
1073      *
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      * - `tokenId` token must be owned by `from`.
1077      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function transferFrom(address from, address to, uint256 tokenId) external;
1082 
1083     /**
1084      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1085      * The approval is cleared when the token is transferred.
1086      *
1087      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1088      *
1089      * Requirements:
1090      *
1091      * - The caller must own the token or be an approved operator.
1092      * - `tokenId` must exist.
1093      *
1094      * Emits an {Approval} event.
1095      */
1096     function approve(address to, uint256 tokenId) external;
1097 
1098     /**
1099      * @dev Returns the account approved for `tokenId` token.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must exist.
1104      */
1105     function getApproved(uint256 tokenId) external view returns (address operator);
1106 
1107     /**
1108      * @dev Approve or remove `operator` as an operator for the caller.
1109      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1110      *
1111      * Requirements:
1112      *
1113      * - The `operator` cannot be the caller.
1114      *
1115      * Emits an {ApprovalForAll} event.
1116      */
1117     function setApprovalForAll(address operator, bool _approved) external;
1118 
1119     /**
1120      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1121      *
1122      * See {setApprovalForAll}
1123      */
1124     function isApprovedForAll(address owner, address operator) external view returns (bool);
1125 
1126     /**
1127       * @dev Safely transfers `tokenId` token from `from` to `to`.
1128       *
1129       * Requirements:
1130       *
1131      * - `from` cannot be the zero address.
1132      * - `to` cannot be the zero address.
1133       * - `tokenId` token must exist and be owned by `from`.
1134       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1135       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1136       *
1137       * Emits a {Transfer} event.
1138       */
1139     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1140 }
1141 
1142 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Ownable
1143 
1144 /**
1145  * @dev Contract module which provides a basic access control mechanism, where
1146  * there is an account (an owner) that can be granted exclusive access to
1147  * specific functions.
1148  *
1149  * By default, the owner account will be the one that deploys the contract. This
1150  * can later be changed with {transferOwnership}.
1151  *
1152  * This module is used through inheritance. It will make available the modifier
1153  * `onlyOwner`, which can be applied to your functions to restrict their use to
1154  * the owner.
1155  */
1156 contract Ownable is Context {
1157     address private _owner;
1158 
1159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1160 
1161     /**
1162      * @dev Initializes the contract setting the deployer as the initial owner.
1163      */
1164     constructor () internal {
1165         address msgSender = _msgSender();
1166         _owner = msgSender;
1167         emit OwnershipTransferred(address(0), msgSender);
1168     }
1169 
1170     /**
1171      * @dev Returns the address of the current owner.
1172      */
1173     function owner() public view returns (address) {
1174         return _owner;
1175     }
1176 
1177     /**
1178      * @dev Throws if called by any account other than the owner.
1179      */
1180     modifier onlyOwner() {
1181         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1182         _;
1183     }
1184 
1185     /**
1186      * @dev Leaves the contract without owner. It will not be possible to call
1187      * `onlyOwner` functions anymore. Can only be called by the current owner.
1188      *
1189      * NOTE: Renouncing ownership will leave the contract without an owner,
1190      * thereby removing any functionality that is only available to the owner.
1191      */
1192     function renounceOwnership() public virtual onlyOwner {
1193         emit OwnershipTransferred(_owner, address(0));
1194         _owner = address(0);
1195     }
1196 
1197     /**
1198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1199      * Can only be called by the current owner.
1200      */
1201     function transferOwnership(address newOwner) public virtual onlyOwner {
1202         require(newOwner != address(0), "Ownable: new owner is the zero address");
1203         emit OwnershipTransferred(_owner, newOwner);
1204         _owner = newOwner;
1205     }
1206 }
1207 
1208 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Enumerable
1209 
1210 /**
1211  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1212  * @dev See https://eips.ethereum.org/EIPS/eip-721
1213  */
1214 interface IERC721Enumerable is IERC721 {
1215 
1216     /**
1217      * @dev Returns the total amount of tokens stored by the contract.
1218      */
1219     function totalSupply() external view returns (uint256);
1220 
1221     /**
1222      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1223      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1224      */
1225     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1226 
1227     /**
1228      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1229      * Use along with {totalSupply} to enumerate all tokens.
1230      */
1231     function tokenByIndex(uint256 index) external view returns (uint256);
1232 }
1233 
1234 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721Metadata
1235 
1236 /**
1237  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1238  * @dev See https://eips.ethereum.org/EIPS/eip-721
1239  */
1240 interface IERC721Metadata is IERC721 {
1241 
1242     /**
1243      * @dev Returns the token collection name.
1244      */
1245     function name() external view returns (string memory);
1246 
1247     /**
1248      * @dev Returns the token collection symbol.
1249      */
1250     function symbol() external view returns (string memory);
1251 
1252     /**
1253      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1254      */
1255     function tokenURI(uint256 tokenId) external view returns (string memory);
1256 }
1257 
1258 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC721
1259 
1260 /**
1261  * @title ERC721 Non-Fungible Token Standard basic implementation
1262  * @dev see https://eips.ethereum.org/EIPS/eip-721
1263  */
1264 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1265     using SafeMath for uint256;
1266     using Address for address;
1267     using EnumerableSet for EnumerableSet.UintSet;
1268     using EnumerableMap for EnumerableMap.UintToAddressMap;
1269     using Strings for uint256;
1270 
1271     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1272     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1273     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1274 
1275     // Mapping from holder address to their (enumerable) set of owned tokens
1276     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1277 
1278     // Enumerable mapping from token ids to their owners
1279     EnumerableMap.UintToAddressMap private _tokenOwners;
1280 
1281     // Mapping from token ID to approved address
1282     mapping (uint256 => address) private _tokenApprovals;
1283 
1284     // Mapping from owner to operator approvals
1285     mapping (address => mapping (address => bool)) private _operatorApprovals;
1286 
1287     // Token name
1288     string private _name;
1289 
1290     // Token symbol
1291     string private _symbol;
1292 
1293     // Optional mapping for token URIs
1294     mapping (uint256 => string) private _tokenURIs;
1295 
1296     // Base URI
1297     string private _baseURI;
1298 
1299     /*
1300      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1301      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1302      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1303      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1304      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1305      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1306      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1307      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1308      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1309      *
1310      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1311      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1312      */
1313     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1314 
1315     /*
1316      *     bytes4(keccak256('name()')) == 0x06fdde03
1317      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1318      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1319      *
1320      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1321      */
1322     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1323 
1324     /*
1325      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1326      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1327      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1328      *
1329      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1330      */
1331     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1332 
1333     /**
1334      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1335      */
1336     constructor (string memory name, string memory symbol) public {
1337         _name = name;
1338         _symbol = symbol;
1339 
1340         // register the supported interfaces to conform to ERC721 via ERC165
1341         _registerInterface(_INTERFACE_ID_ERC721);
1342         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1343         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1344     }
1345 
1346     /**
1347      * @dev See {IERC721-balanceOf}.
1348      */
1349     function balanceOf(address owner) public view override returns (uint256) {
1350         require(owner != address(0), "ERC721: balance query for the zero address");
1351 
1352         return _holderTokens[owner].length();
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-ownerOf}.
1357      */
1358     function ownerOf(uint256 tokenId) public view override returns (address) {
1359         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1360     }
1361 
1362     /**
1363      * @dev See {IERC721Metadata-name}.
1364      */
1365     function name() public view override returns (string memory) {
1366         return _name;
1367     }
1368 
1369     /**
1370      * @dev See {IERC721Metadata-symbol}.
1371      */
1372     function symbol() public view override returns (string memory) {
1373         return _symbol;
1374     }
1375 
1376     /**
1377      * @dev See {IERC721Metadata-tokenURI}.
1378      */
1379     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1380         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1381 
1382         string memory _tokenURI = _tokenURIs[tokenId];
1383 
1384         // If there is no base URI, return the token URI.
1385         if (bytes(_baseURI).length == 0) {
1386             return _tokenURI;
1387         }
1388         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1389         if (bytes(_tokenURI).length > 0) {
1390             return string(abi.encodePacked(_baseURI, _tokenURI));
1391         }
1392         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1393         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1394     }
1395 
1396     /**
1397     * @dev Returns the base URI set via {_setBaseURI}. This will be
1398     * automatically added as a prefix in {tokenURI} to each token's URI, or
1399     * to the token ID if no specific URI is set for that token ID.
1400     */
1401     function baseURI() public view returns (string memory) {
1402         return _baseURI;
1403     }
1404 
1405     /**
1406      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1407      */
1408     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1409         return _holderTokens[owner].at(index);
1410     }
1411 
1412     /**
1413      * @dev See {IERC721Enumerable-totalSupply}.
1414      */
1415     function totalSupply() public view override returns (uint256) {
1416         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1417         return _tokenOwners.length();
1418     }
1419 
1420     /**
1421      * @dev See {IERC721Enumerable-tokenByIndex}.
1422      */
1423     function tokenByIndex(uint256 index) public view override returns (uint256) {
1424         (uint256 tokenId, ) = _tokenOwners.at(index);
1425         return tokenId;
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-approve}.
1430      */
1431     function approve(address to, uint256 tokenId) public virtual override {
1432         address owner = ownerOf(tokenId);
1433         require(to != owner, "ERC721: approval to current owner");
1434 
1435         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1436             "ERC721: approve caller is not owner nor approved for all"
1437         );
1438 
1439         _approve(to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-getApproved}.
1444      */
1445     function getApproved(uint256 tokenId) public view override returns (address) {
1446         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1447 
1448         return _tokenApprovals[tokenId];
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-setApprovalForAll}.
1453      */
1454     function setApprovalForAll(address operator, bool approved) public virtual override {
1455         require(operator != _msgSender(), "ERC721: approve to caller");
1456 
1457         _operatorApprovals[_msgSender()][operator] = approved;
1458         emit ApprovalForAll(_msgSender(), operator, approved);
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-isApprovedForAll}.
1463      */
1464     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1465         return _operatorApprovals[owner][operator];
1466     }
1467 
1468     /**
1469      * @dev See {IERC721-transferFrom}.
1470      */
1471     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1472         //solhint-disable-next-line max-line-length
1473         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1474 
1475         _transfer(from, to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev See {IERC721-safeTransferFrom}.
1480      */
1481     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1482         safeTransferFrom(from, to, tokenId, "");
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-safeTransferFrom}.
1487      */
1488     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1489         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1490         _safeTransfer(from, to, tokenId, _data);
1491     }
1492 
1493     /**
1494      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1495      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1496      *
1497      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1498      *
1499      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1500      * implement alternative mechanisms to perform token transfer, such as signature-based.
1501      *
1502      * Requirements:
1503      *
1504      * - `from` cannot be the zero address.
1505      * - `to` cannot be the zero address.
1506      * - `tokenId` token must exist and be owned by `from`.
1507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1512         _transfer(from, to, tokenId);
1513         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1514     }
1515 
1516     /**
1517      * @dev Returns whether `tokenId` exists.
1518      *
1519      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1520      *
1521      * Tokens start existing when they are minted (`_mint`),
1522      * and stop existing when they are burned (`_burn`).
1523      */
1524     function _exists(uint256 tokenId) internal view returns (bool) {
1525         return _tokenOwners.contains(tokenId);
1526     }
1527 
1528     /**
1529      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1530      *
1531      * Requirements:
1532      *
1533      * - `tokenId` must exist.
1534      */
1535     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1536         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1537         address owner = ownerOf(tokenId);
1538         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1539     }
1540 
1541     /**
1542      * @dev Safely mints `tokenId` and transfers it to `to`.
1543      *
1544      * Requirements:
1545      d*
1546      * - `tokenId` must not exist.
1547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1548      *
1549      * Emits a {Transfer} event.
1550      */
1551     function _safeMint(address to, uint256 tokenId) internal virtual {
1552         _safeMint(to, tokenId, "");
1553     }
1554 
1555     /**
1556      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1557      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1558      */
1559     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1560         _mint(to, tokenId);
1561         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1562     }
1563 
1564     /**
1565      * @dev Mints `tokenId` and transfers it to `to`.
1566      *
1567      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must not exist.
1572      * - `to` cannot be the zero address.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _mint(address to, uint256 tokenId) internal virtual {
1577         require(to != address(0), "ERC721: mint to the zero address");
1578         require(!_exists(tokenId), "ERC721: token already minted");
1579 
1580         _beforeTokenTransfer(address(0), to, tokenId);
1581 
1582         _holderTokens[to].add(tokenId);
1583 
1584         _tokenOwners.set(tokenId, to);
1585 
1586         emit Transfer(address(0), to, tokenId);
1587     }
1588 
1589     /**
1590      * @dev Destroys `tokenId`.
1591      * The approval is cleared when the token is burned.
1592      *
1593      * Requirements:
1594      *
1595      * - `tokenId` must exist.
1596      *
1597      * Emits a {Transfer} event.
1598      */
1599     function _burn(uint256 tokenId) internal virtual {
1600         address owner = ownerOf(tokenId);
1601 
1602         _beforeTokenTransfer(owner, address(0), tokenId);
1603 
1604         // Clear approvals
1605         _approve(address(0), tokenId);
1606 
1607         // Clear metadata (if any)
1608         if (bytes(_tokenURIs[tokenId]).length != 0) {
1609             delete _tokenURIs[tokenId];
1610         }
1611 
1612         _holderTokens[owner].remove(tokenId);
1613 
1614         _tokenOwners.remove(tokenId);
1615 
1616         emit Transfer(owner, address(0), tokenId);
1617     }
1618 
1619     /**
1620      * @dev Transfers `tokenId` from `from` to `to`.
1621      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1622      *
1623      * Requirements:
1624      *
1625      * - `to` cannot be the zero address.
1626      * - `tokenId` token must be owned by `from`.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1631         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1632         require(to != address(0), "ERC721: transfer to the zero address");
1633 
1634         _beforeTokenTransfer(from, to, tokenId);
1635 
1636         // Clear approvals from the previous owner
1637         _approve(address(0), tokenId);
1638 
1639         _holderTokens[from].remove(tokenId);
1640         _holderTokens[to].add(tokenId);
1641 
1642         _tokenOwners.set(tokenId, to);
1643 
1644         emit Transfer(from, to, tokenId);
1645     }
1646 
1647     /**
1648      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1649      *
1650      * Requirements:
1651      *
1652      * - `tokenId` must exist.
1653      */
1654     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1655         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1656         _tokenURIs[tokenId] = _tokenURI;
1657     }
1658 
1659     /**
1660      * @dev Internal function to set the base URI for all token IDs. It is
1661      * automatically added as a prefix to the value returned in {tokenURI},
1662      * or to the token ID if {tokenURI} is empty.
1663      */
1664     function _setBaseURI(string memory baseURI_) internal virtual {
1665         _baseURI = baseURI_;
1666     }
1667 
1668     /**
1669      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1670      * The call is not executed if the target address is not a contract.
1671      *
1672      * @param from address representing the previous owner of the given token ID
1673      * @param to target address that will receive the tokens
1674      * @param tokenId uint256 ID of the token to be transferred
1675      * @param _data bytes optional data to send along with the call
1676      * @return bool whether the call correctly returned the expected magic value
1677      */
1678     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1679         private returns (bool)
1680     {
1681         if (!to.isContract()) {
1682             return true;
1683         }
1684         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1685             IERC721Receiver(to).onERC721Received.selector,
1686             _msgSender(),
1687             from,
1688             tokenId,
1689             _data
1690         ), "ERC721: transfer to non ERC721Receiver implementer");
1691         bytes4 retval = abi.decode(returndata, (bytes4));
1692         return (retval == _ERC721_RECEIVED);
1693     }
1694 
1695     function _approve(address to, uint256 tokenId) private {
1696         _tokenApprovals[tokenId] = to;
1697         emit Approval(ownerOf(tokenId), to, tokenId);
1698     }
1699 
1700     /**
1701      * @dev Hook that is called before any token transfer. This includes minting
1702      * and burning.
1703      *
1704      * Calling conditions:
1705      *
1706      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1707      * transferred to `to`.
1708      * - When `from` is zero, `tokenId` will be minted for `to`.
1709      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1710      * - `from` cannot be the zero address.
1711      * - `to` cannot be the zero address.
1712      *
1713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1714      */
1715     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1716 }
1717 
1718 // File: Badge.sol
1719 
1720 contract Badge is ERC721("Yield Guild Badge", "YGG BADGE"), Ownable {
1721 	using ECDSA for bytes32;
1722 	using SafeMath for uint256;
1723 
1724 	mapping(address => uint256) public addressToBadge;
1725 
1726 	function updateURI(string memory newURI) public onlyOwner {
1727 		_setBaseURI(newURI);
1728 	}
1729 
1730 	function mint() external {
1731 		uint256 supply = totalSupply() + 1;
1732 		require(addressToBadge[msg.sender] == 0, "Receiver already has a badge");
1733 		addressToBadge[msg.sender] = supply;
1734 		_mint(msg.sender, supply);
1735 	}
1736 
1737 	function mintFor(address _owner) external onlyOwner {
1738 		uint256 supply = totalSupply() + 1;
1739 		require(addressToBadge[_owner] == 0, "Receiver already has a badge");
1740 		addressToBadge[_owner] = supply;
1741 		_mint(_owner, supply);
1742 	}
1743 
1744 	function transferFrom(address from, address to, uint256 tokenId) public override {
1745 		revert();
1746 		//super.transferFrom(from, to, tokenId);
1747 	}
1748 
1749 	function safeTransferFrom(address from, address to, uint256 tokenId) public override {
1750 		revert();
1751 		//super.safeTransferFrom(from, to, tokenId);
1752 	}
1753 
1754 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
1755 		revert();
1756 		//super.safeTransferFrom(from, to, tokenId, _data);
1757 	}
1758 }
