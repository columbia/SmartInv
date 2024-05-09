1 /**
2  *Submitted for verification at Etherscan.io on 2023-02-25
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 /**
9  *Submitted for verification at Etherscan.io on 2023-02-17
10 */
11 
12 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
13 
14 
15 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
16 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Library for managing
22  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
23  * types.
24  *
25  * Sets have the following properties:
26  *
27  * - Elements are added, removed, and checked for existence in constant time
28  * (O(1)).
29  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
30  *
31  * ```
32  * contract Example {
33  *     // Add the library methods
34  *     using EnumerableSet for EnumerableSet.AddressSet;
35  *
36  *     // Declare a set state variable
37  *     EnumerableSet.AddressSet private mySet;
38  * }
39  * ```
40  *
41  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
42  * and `uint256` (`UintSet`) are supported.
43  *
44  * [WARNING]
45  * ====
46  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
47  * unusable.
48  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
49  *
50  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
51  * array of EnumerableSet.
52  * ====
53  */
54 library EnumerableSet {
55     // To implement this library for multiple types with as little code
56     // repetition as possible, we write it in terms of a generic Set type with
57     // bytes32 values.
58     // The Set implementation uses private functions, and user-facing
59     // implementations (such as AddressSet) are just wrappers around the
60     // underlying Set.
61     // This means that we can only create new EnumerableSets for types that fit
62     // in bytes32.
63 
64     struct Set {
65         // Storage of set values
66         bytes32[] _values;
67         // Position of the value in the `values` array, plus 1 because index 0
68         // means a value is not in the set.
69         mapping(bytes32 => uint256) _indexes;
70     }
71 
72     /**
73      * @dev Add a value to a set. O(1).
74      *
75      * Returns true if the value was added to the set, that is if it was not
76      * already present.
77      */
78     function _add(Set storage set, bytes32 value) private returns (bool) {
79         if (!_contains(set, value)) {
80             set._values.push(value);
81             // The value is stored at length-1, but we add 1 to all indexes
82             // and use 0 as a sentinel value
83             set._indexes[value] = set._values.length;
84             return true;
85         } else {
86             return false;
87         }
88     }
89 
90     /**
91      * @dev Removes a value from a set. O(1).
92      *
93      * Returns true if the value was removed from the set, that is if it was
94      * present.
95      */
96     function _remove(Set storage set, bytes32 value) private returns (bool) {
97         // We read and store the value's index to prevent multiple reads from the same storage slot
98         uint256 valueIndex = set._indexes[value];
99 
100         if (valueIndex != 0) {
101             // Equivalent to contains(set, value)
102             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
103             // the array, and then remove the last element (sometimes called as 'swap and pop').
104             // This modifies the order of the array, as noted in {at}.
105 
106             uint256 toDeleteIndex = valueIndex - 1;
107             uint256 lastIndex = set._values.length - 1;
108 
109             if (lastIndex != toDeleteIndex) {
110                 bytes32 lastValue = set._values[lastIndex];
111 
112                 // Move the last value to the index where the value to delete is
113                 set._values[toDeleteIndex] = lastValue;
114                 // Update the index for the moved value
115                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
116             }
117 
118             // Delete the slot where the moved value was stored
119             set._values.pop();
120 
121             // Delete the index for the deleted slot
122             delete set._indexes[value];
123 
124             return true;
125         } else {
126             return false;
127         }
128     }
129 
130     /**
131      * @dev Returns true if the value is in the set. O(1).
132      */
133     function _contains(Set storage set, bytes32 value) private view returns (bool) {
134         return set._indexes[value] != 0;
135     }
136 
137     /**
138      * @dev Returns the number of values on the set. O(1).
139      */
140     function _length(Set storage set) private view returns (uint256) {
141         return set._values.length;
142     }
143 
144     /**
145      * @dev Returns the value stored at position `index` in the set. O(1).
146      *
147      * Note that there are no guarantees on the ordering of values inside the
148      * array, and it may change when more values are added or removed.
149      *
150      * Requirements:
151      *
152      * - `index` must be strictly less than {length}.
153      */
154     function _at(Set storage set, uint256 index) private view returns (bytes32) {
155         return set._values[index];
156     }
157 
158     /**
159      * @dev Return the entire set in an array
160      *
161      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
162      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
163      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
164      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
165      */
166     function _values(Set storage set) private view returns (bytes32[] memory) {
167         return set._values;
168     }
169 
170     // Bytes32Set
171 
172     struct Bytes32Set {
173         Set _inner;
174     }
175 
176     /**
177      * @dev Add a value to a set. O(1).
178      *
179      * Returns true if the value was added to the set, that is if it was not
180      * already present.
181      */
182     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
183         return _add(set._inner, value);
184     }
185 
186     /**
187      * @dev Removes a value from a set. O(1).
188      *
189      * Returns true if the value was removed from the set, that is if it was
190      * present.
191      */
192     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
193         return _remove(set._inner, value);
194     }
195 
196     /**
197      * @dev Returns true if the value is in the set. O(1).
198      */
199     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
200         return _contains(set._inner, value);
201     }
202 
203     /**
204      * @dev Returns the number of values in the set. O(1).
205      */
206     function length(Bytes32Set storage set) internal view returns (uint256) {
207         return _length(set._inner);
208     }
209 
210     /**
211      * @dev Returns the value stored at position `index` in the set. O(1).
212      *
213      * Note that there are no guarantees on the ordering of values inside the
214      * array, and it may change when more values are added or removed.
215      *
216      * Requirements:
217      *
218      * - `index` must be strictly less than {length}.
219      */
220     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
221         return _at(set._inner, index);
222     }
223 
224     /**
225      * @dev Return the entire set in an array
226      *
227      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
228      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
229      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
230      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
231      */
232     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
233         bytes32[] memory store = _values(set._inner);
234         bytes32[] memory result;
235 
236         /// @solidity memory-safe-assembly
237         assembly {
238             result := store
239         }
240 
241         return result;
242     }
243 
244     // AddressSet
245 
246     struct AddressSet {
247         Set _inner;
248     }
249 
250     /**
251      * @dev Add a value to a set. O(1).
252      *
253      * Returns true if the value was added to the set, that is if it was not
254      * already present.
255      */
256     function add(AddressSet storage set, address value) internal returns (bool) {
257         return _add(set._inner, bytes32(uint256(uint160(value))));
258     }
259 
260     /**
261      * @dev Removes a value from a set. O(1).
262      *
263      * Returns true if the value was removed from the set, that is if it was
264      * present.
265      */
266     function remove(AddressSet storage set, address value) internal returns (bool) {
267         return _remove(set._inner, bytes32(uint256(uint160(value))));
268     }
269 
270     /**
271      * @dev Returns true if the value is in the set. O(1).
272      */
273     function contains(AddressSet storage set, address value) internal view returns (bool) {
274         return _contains(set._inner, bytes32(uint256(uint160(value))));
275     }
276 
277     /**
278      * @dev Returns the number of values in the set. O(1).
279      */
280     function length(AddressSet storage set) internal view returns (uint256) {
281         return _length(set._inner);
282     }
283 
284     /**
285      * @dev Returns the value stored at position `index` in the set. O(1).
286      *
287      * Note that there are no guarantees on the ordering of values inside the
288      * array, and it may change when more values are added or removed.
289      *
290      * Requirements:
291      *
292      * - `index` must be strictly less than {length}.
293      */
294     function at(AddressSet storage set, uint256 index) internal view returns (address) {
295         return address(uint160(uint256(_at(set._inner, index))));
296     }
297 
298     /**
299      * @dev Return the entire set in an array
300      *
301      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
302      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
303      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
304      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
305      */
306     function values(AddressSet storage set) internal view returns (address[] memory) {
307         bytes32[] memory store = _values(set._inner);
308         address[] memory result;
309 
310         /// @solidity memory-safe-assembly
311         assembly {
312             result := store
313         }
314 
315         return result;
316     }
317 
318     // UintSet
319 
320     struct UintSet {
321         Set _inner;
322     }
323 
324     /**
325      * @dev Add a value to a set. O(1).
326      *
327      * Returns true if the value was added to the set, that is if it was not
328      * already present.
329      */
330     function add(UintSet storage set, uint256 value) internal returns (bool) {
331         return _add(set._inner, bytes32(value));
332     }
333 
334     /**
335      * @dev Removes a value from a set. O(1).
336      *
337      * Returns true if the value was removed from the set, that is if it was
338      * present.
339      */
340     function remove(UintSet storage set, uint256 value) internal returns (bool) {
341         return _remove(set._inner, bytes32(value));
342     }
343 
344     /**
345      * @dev Returns true if the value is in the set. O(1).
346      */
347     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
348         return _contains(set._inner, bytes32(value));
349     }
350 
351     /**
352      * @dev Returns the number of values in the set. O(1).
353      */
354     function length(UintSet storage set) internal view returns (uint256) {
355         return _length(set._inner);
356     }
357 
358     /**
359      * @dev Returns the value stored at position `index` in the set. O(1).
360      *
361      * Note that there are no guarantees on the ordering of values inside the
362      * array, and it may change when more values are added or removed.
363      *
364      * Requirements:
365      *
366      * - `index` must be strictly less than {length}.
367      */
368     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
369         return uint256(_at(set._inner, index));
370     }
371 
372     /**
373      * @dev Return the entire set in an array
374      *
375      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
376      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
377      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
378      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
379      */
380     function values(UintSet storage set) internal view returns (uint256[] memory) {
381         bytes32[] memory store = _values(set._inner);
382         uint256[] memory result;
383 
384         /// @solidity memory-safe-assembly
385         assembly {
386             result := store
387         }
388 
389         return result;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/utils/StorageSlot.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Library for reading and writing primitive types to specific storage slots.
402  *
403  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
404  * This library helps with reading and writing to such slots without the need for inline assembly.
405  *
406  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
407  *
408  * Example usage to set ERC1967 implementation slot:
409  * ```
410  * contract ERC1967 {
411  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
412  *
413  *     function _getImplementation() internal view returns (address) {
414  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
415  *     }
416  *
417  *     function _setImplementation(address newImplementation) internal {
418  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
419  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
420  *     }
421  * }
422  * ```
423  *
424  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
425  */
426 library StorageSlot {
427     struct AddressSlot {
428         address value;
429     }
430 
431     struct BooleanSlot {
432         bool value;
433     }
434 
435     struct Bytes32Slot {
436         bytes32 value;
437     }
438 
439     struct Uint256Slot {
440         uint256 value;
441     }
442 
443     /**
444      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
445      */
446     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
447         /// @solidity memory-safe-assembly
448         assembly {
449             r.slot := slot
450         }
451     }
452 
453     /**
454      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
455      */
456     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
457         /// @solidity memory-safe-assembly
458         assembly {
459             r.slot := slot
460         }
461     }
462 
463     /**
464      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
465      */
466     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
467         /// @solidity memory-safe-assembly
468         assembly {
469             r.slot := slot
470         }
471     }
472 
473     /**
474      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
475      */
476     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
477         /// @solidity memory-safe-assembly
478         assembly {
479             r.slot := slot
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/utils/Address.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
488 
489 pragma solidity ^0.8.1;
490 
491 /**
492  * @dev Collection of functions related to the address type
493  */
494 library Address {
495     /**
496      * @dev Returns true if `account` is a contract.
497      *
498      * [IMPORTANT]
499      * ====
500      * It is unsafe to assume that an address for which this function returns
501      * false is an externally-owned account (EOA) and not a contract.
502      *
503      * Among others, `isContract` will return false for the following
504      * types of addresses:
505      *
506      *  - an externally-owned account
507      *  - a contract in construction
508      *  - an address where a contract will be created
509      *  - an address where a contract lived, but was destroyed
510      * ====
511      *
512      * [IMPORTANT]
513      * ====
514      * You shouldn't rely on `isContract` to protect against flash loan attacks!
515      *
516      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
517      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
518      * constructor.
519      * ====
520      */
521     function isContract(address account) internal view returns (bool) {
522         // This method relies on extcodesize/address.code.length, which returns 0
523         // for contracts in construction, since the code is only stored at the end
524         // of the constructor execution.
525 
526         return account.code.length > 0;
527     }
528 
529     /**
530      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
531      * `recipient`, forwarding all available gas and reverting on errors.
532      *
533      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
534      * of certain opcodes, possibly making contracts go over the 2300 gas limit
535      * imposed by `transfer`, making them unable to receive funds via
536      * `transfer`. {sendValue} removes this limitation.
537      *
538      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
539      *
540      * IMPORTANT: because control is transferred to `recipient`, care must be
541      * taken to not create reentrancy vulnerabilities. Consider using
542      * {ReentrancyGuard} or the
543      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
544      */
545     function sendValue(address payable recipient, uint256 amount) internal {
546         require(address(this).balance >= amount, "Address: insufficient balance");
547 
548         (bool success, ) = recipient.call{value: amount}("");
549         require(success, "Address: unable to send value, recipient may have reverted");
550     }
551 
552     /**
553      * @dev Performs a Solidity function call using a low level `call`. A
554      * plain `call` is an unsafe replacement for a function call: use this
555      * function instead.
556      *
557      * If `target` reverts with a revert reason, it is bubbled up by this
558      * function (like regular Solidity function calls).
559      *
560      * Returns the raw returned data. To convert to the expected return value,
561      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
562      *
563      * Requirements:
564      *
565      * - `target` must be a contract.
566      * - calling `target` with `data` must not revert.
567      *
568      * _Available since v3.1._
569      */
570     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
571         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
576      * `errorMessage` as a fallback revert reason when `target` reverts.
577      *
578      * _Available since v3.1._
579      */
580     function functionCall(
581         address target,
582         bytes memory data,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         return functionCallWithValue(target, data, 0, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but also transferring `value` wei to `target`.
591      *
592      * Requirements:
593      *
594      * - the calling contract must have an ETH balance of at least `value`.
595      * - the called Solidity function must be `payable`.
596      *
597      * _Available since v3.1._
598      */
599     function functionCallWithValue(
600         address target,
601         bytes memory data,
602         uint256 value
603     ) internal returns (bytes memory) {
604         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
609      * with `errorMessage` as a fallback revert reason when `target` reverts.
610      *
611      * _Available since v3.1._
612      */
613     function functionCallWithValue(
614         address target,
615         bytes memory data,
616         uint256 value,
617         string memory errorMessage
618     ) internal returns (bytes memory) {
619         require(address(this).balance >= value, "Address: insufficient balance for call");
620         (bool success, bytes memory returndata) = target.call{value: value}(data);
621         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
631         return functionStaticCall(target, data, "Address: low-level static call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a static call.
637      *
638      * _Available since v3.3._
639      */
640     function functionStaticCall(
641         address target,
642         bytes memory data,
643         string memory errorMessage
644     ) internal view returns (bytes memory) {
645         (bool success, bytes memory returndata) = target.staticcall(data);
646         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but performing a delegate call.
652      *
653      * _Available since v3.4._
654      */
655     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
656         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
661      * but performing a delegate call.
662      *
663      * _Available since v3.4._
664      */
665     function functionDelegateCall(
666         address target,
667         bytes memory data,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         (bool success, bytes memory returndata) = target.delegatecall(data);
671         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
676      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
677      *
678      * _Available since v4.8._
679      */
680     function verifyCallResultFromTarget(
681         address target,
682         bool success,
683         bytes memory returndata,
684         string memory errorMessage
685     ) internal view returns (bytes memory) {
686         if (success) {
687             if (returndata.length == 0) {
688                 // only check isContract if the call was successful and the return data is empty
689                 // otherwise we already know that it was a contract
690                 require(isContract(target), "Address: call to non-contract");
691             }
692             return returndata;
693         } else {
694             _revert(returndata, errorMessage);
695         }
696     }
697 
698     /**
699      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
700      * revert reason or using the provided one.
701      *
702      * _Available since v4.3._
703      */
704     function verifyCallResult(
705         bool success,
706         bytes memory returndata,
707         string memory errorMessage
708     ) internal pure returns (bytes memory) {
709         if (success) {
710             return returndata;
711         } else {
712             _revert(returndata, errorMessage);
713         }
714     }
715 
716     function _revert(bytes memory returndata, string memory errorMessage) private pure {
717         // Look for revert reason and bubble it up if present
718         if (returndata.length > 0) {
719             // The easiest way to bubble the revert reason is using memory via assembly
720             /// @solidity memory-safe-assembly
721             assembly {
722                 let returndata_size := mload(returndata)
723                 revert(add(32, returndata), returndata_size)
724             }
725         } else {
726             revert(errorMessage);
727         }
728     }
729 }
730 
731 // File: @openzeppelin/contracts/utils/math/Math.sol
732 
733 
734 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Standard math utilities missing in the Solidity language.
740  */
741 library Math {
742     enum Rounding {
743         Down, // Toward negative infinity
744         Up, // Toward infinity
745         Zero // Toward zero
746     }
747 
748     /**
749      * @dev Returns the largest of two numbers.
750      */
751     function max(uint256 a, uint256 b) internal pure returns (uint256) {
752         return a > b ? a : b;
753     }
754 
755     /**
756      * @dev Returns the smallest of two numbers.
757      */
758     function min(uint256 a, uint256 b) internal pure returns (uint256) {
759         return a < b ? a : b;
760     }
761 
762     /**
763      * @dev Returns the average of two numbers. The result is rounded towards
764      * zero.
765      */
766     function average(uint256 a, uint256 b) internal pure returns (uint256) {
767         // (a + b) / 2 can overflow.
768         return (a & b) + (a ^ b) / 2;
769     }
770 
771     /**
772      * @dev Returns the ceiling of the division of two numbers.
773      *
774      * This differs from standard division with `/` in that it rounds up instead
775      * of rounding down.
776      */
777     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
778         // (a + b - 1) / b can overflow on addition, so we distribute.
779         return a == 0 ? 0 : (a - 1) / b + 1;
780     }
781 
782     /**
783      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
784      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
785      * with further edits by Uniswap Labs also under MIT license.
786      */
787     function mulDiv(
788         uint256 x,
789         uint256 y,
790         uint256 denominator
791     ) internal pure returns (uint256 result) {
792         unchecked {
793             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
794             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
795             // variables such that product = prod1 * 2^256 + prod0.
796             uint256 prod0; // Least significant 256 bits of the product
797             uint256 prod1; // Most significant 256 bits of the product
798             assembly {
799                 let mm := mulmod(x, y, not(0))
800                 prod0 := mul(x, y)
801                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
802             }
803 
804             // Handle non-overflow cases, 256 by 256 division.
805             if (prod1 == 0) {
806                 return prod0 / denominator;
807             }
808 
809             // Make sure the result is less than 2^256. Also prevents denominator == 0.
810             require(denominator > prod1);
811 
812             ///////////////////////////////////////////////
813             // 512 by 256 division.
814             ///////////////////////////////////////////////
815 
816             // Make division exact by subtracting the remainder from [prod1 prod0].
817             uint256 remainder;
818             assembly {
819                 // Compute remainder using mulmod.
820                 remainder := mulmod(x, y, denominator)
821 
822                 // Subtract 256 bit number from 512 bit number.
823                 prod1 := sub(prod1, gt(remainder, prod0))
824                 prod0 := sub(prod0, remainder)
825             }
826 
827             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
828             // See https://cs.stackexchange.com/q/138556/92363.
829 
830             // Does not overflow because the denominator cannot be zero at this stage in the function.
831             uint256 twos = denominator & (~denominator + 1);
832             assembly {
833                 // Divide denominator by twos.
834                 denominator := div(denominator, twos)
835 
836                 // Divide [prod1 prod0] by twos.
837                 prod0 := div(prod0, twos)
838 
839                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
840                 twos := add(div(sub(0, twos), twos), 1)
841             }
842 
843             // Shift in bits from prod1 into prod0.
844             prod0 |= prod1 * twos;
845 
846             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
847             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
848             // four bits. That is, denominator * inv = 1 mod 2^4.
849             uint256 inverse = (3 * denominator) ^ 2;
850 
851             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
852             // in modular arithmetic, doubling the correct bits in each step.
853             inverse *= 2 - denominator * inverse; // inverse mod 2^8
854             inverse *= 2 - denominator * inverse; // inverse mod 2^16
855             inverse *= 2 - denominator * inverse; // inverse mod 2^32
856             inverse *= 2 - denominator * inverse; // inverse mod 2^64
857             inverse *= 2 - denominator * inverse; // inverse mod 2^128
858             inverse *= 2 - denominator * inverse; // inverse mod 2^256
859 
860             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
861             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
862             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
863             // is no longer required.
864             result = prod0 * inverse;
865             return result;
866         }
867     }
868 
869     /**
870      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
871      */
872     function mulDiv(
873         uint256 x,
874         uint256 y,
875         uint256 denominator,
876         Rounding rounding
877     ) internal pure returns (uint256) {
878         uint256 result = mulDiv(x, y, denominator);
879         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
880             result += 1;
881         }
882         return result;
883     }
884 
885     /**
886      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
887      *
888      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
889      */
890     function sqrt(uint256 a) internal pure returns (uint256) {
891         if (a == 0) {
892             return 0;
893         }
894 
895         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
896         //
897         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
898         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
899         //
900         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
901         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
902         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
903         //
904         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
905         uint256 result = 1 << (log2(a) >> 1);
906 
907         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
908         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
909         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
910         // into the expected uint128 result.
911         unchecked {
912             result = (result + a / result) >> 1;
913             result = (result + a / result) >> 1;
914             result = (result + a / result) >> 1;
915             result = (result + a / result) >> 1;
916             result = (result + a / result) >> 1;
917             result = (result + a / result) >> 1;
918             result = (result + a / result) >> 1;
919             return min(result, a / result);
920         }
921     }
922 
923     /**
924      * @notice Calculates sqrt(a), following the selected rounding direction.
925      */
926     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
927         unchecked {
928             uint256 result = sqrt(a);
929             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
930         }
931     }
932 
933     /**
934      * @dev Return the log in base 2, rounded down, of a positive value.
935      * Returns 0 if given 0.
936      */
937     function log2(uint256 value) internal pure returns (uint256) {
938         uint256 result = 0;
939         unchecked {
940             if (value >> 128 > 0) {
941                 value >>= 128;
942                 result += 128;
943             }
944             if (value >> 64 > 0) {
945                 value >>= 64;
946                 result += 64;
947             }
948             if (value >> 32 > 0) {
949                 value >>= 32;
950                 result += 32;
951             }
952             if (value >> 16 > 0) {
953                 value >>= 16;
954                 result += 16;
955             }
956             if (value >> 8 > 0) {
957                 value >>= 8;
958                 result += 8;
959             }
960             if (value >> 4 > 0) {
961                 value >>= 4;
962                 result += 4;
963             }
964             if (value >> 2 > 0) {
965                 value >>= 2;
966                 result += 2;
967             }
968             if (value >> 1 > 0) {
969                 result += 1;
970             }
971         }
972         return result;
973     }
974 
975     /**
976      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
977      * Returns 0 if given 0.
978      */
979     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
980         unchecked {
981             uint256 result = log2(value);
982             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
983         }
984     }
985 
986     /**
987      * @dev Return the log in base 10, rounded down, of a positive value.
988      * Returns 0 if given 0.
989      */
990     function log10(uint256 value) internal pure returns (uint256) {
991         uint256 result = 0;
992         unchecked {
993             if (value >= 10**64) {
994                 value /= 10**64;
995                 result += 64;
996             }
997             if (value >= 10**32) {
998                 value /= 10**32;
999                 result += 32;
1000             }
1001             if (value >= 10**16) {
1002                 value /= 10**16;
1003                 result += 16;
1004             }
1005             if (value >= 10**8) {
1006                 value /= 10**8;
1007                 result += 8;
1008             }
1009             if (value >= 10**4) {
1010                 value /= 10**4;
1011                 result += 4;
1012             }
1013             if (value >= 10**2) {
1014                 value /= 10**2;
1015                 result += 2;
1016             }
1017             if (value >= 10**1) {
1018                 result += 1;
1019             }
1020         }
1021         return result;
1022     }
1023 
1024     /**
1025      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1026      * Returns 0 if given 0.
1027      */
1028     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1029         unchecked {
1030             uint256 result = log10(value);
1031             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1032         }
1033     }
1034 
1035     /**
1036      * @dev Return the log in base 256, rounded down, of a positive value.
1037      * Returns 0 if given 0.
1038      *
1039      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1040      */
1041     function log256(uint256 value) internal pure returns (uint256) {
1042         uint256 result = 0;
1043         unchecked {
1044             if (value >> 128 > 0) {
1045                 value >>= 128;
1046                 result += 16;
1047             }
1048             if (value >> 64 > 0) {
1049                 value >>= 64;
1050                 result += 8;
1051             }
1052             if (value >> 32 > 0) {
1053                 value >>= 32;
1054                 result += 4;
1055             }
1056             if (value >> 16 > 0) {
1057                 value >>= 16;
1058                 result += 2;
1059             }
1060             if (value >> 8 > 0) {
1061                 result += 1;
1062             }
1063         }
1064         return result;
1065     }
1066 
1067     /**
1068      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1069      * Returns 0 if given 0.
1070      */
1071     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1072         unchecked {
1073             uint256 result = log256(value);
1074             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1075         }
1076     }
1077 }
1078 
1079 // File: @openzeppelin/contracts/utils/Strings.sol
1080 
1081 
1082 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1083 
1084 pragma solidity ^0.8.0;
1085 
1086 
1087 /**
1088  * @dev String operations.
1089  */
1090 library Strings {
1091     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1092     uint8 private constant _ADDRESS_LENGTH = 20;
1093 
1094     /**
1095      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1096      */
1097     function toString(uint256 value) internal pure returns (string memory) {
1098         unchecked {
1099             uint256 length = Math.log10(value) + 1;
1100             string memory buffer = new string(length);
1101             uint256 ptr;
1102             /// @solidity memory-safe-assembly
1103             assembly {
1104                 ptr := add(buffer, add(32, length))
1105             }
1106             while (true) {
1107                 ptr--;
1108                 /// @solidity memory-safe-assembly
1109                 assembly {
1110                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1111                 }
1112                 value /= 10;
1113                 if (value == 0) break;
1114             }
1115             return buffer;
1116         }
1117     }
1118 
1119     /**
1120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1121      */
1122     function toHexString(uint256 value) internal pure returns (string memory) {
1123         unchecked {
1124             return toHexString(value, Math.log256(value) + 1);
1125         }
1126     }
1127 
1128     /**
1129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1130      */
1131     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1132         bytes memory buffer = new bytes(2 * length + 2);
1133         buffer[0] = "0";
1134         buffer[1] = "x";
1135         for (uint256 i = 2 * length + 1; i > 1; --i) {
1136             buffer[i] = _SYMBOLS[value & 0xf];
1137             value >>= 4;
1138         }
1139         require(value == 0, "Strings: hex length insufficient");
1140         return string(buffer);
1141     }
1142 
1143     /**
1144      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1145      */
1146     function toHexString(address addr) internal pure returns (string memory) {
1147         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1148     }
1149 }
1150 
1151 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1152 
1153 
1154 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 /**
1159  * @title ERC721 token receiver interface
1160  * @dev Interface for any contract that wants to support safeTransfers
1161  * from ERC721 asset contracts.
1162  */
1163 interface IERC721Receiver {
1164     /**
1165      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1166      * by `operator` from `from`, this function is called.
1167      *
1168      * It must return its Solidity selector to confirm the token transfer.
1169      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1170      *
1171      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1172      */
1173     function onERC721Received(
1174         address operator,
1175         address from,
1176         uint256 tokenId,
1177         bytes calldata data
1178     ) external returns (bytes4);
1179 }
1180 
1181 // File: solidity-bits/contracts/Popcount.sol
1182 
1183 
1184 /**
1185    _____       ___     ___ __           ____  _ __      
1186   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1187   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1188  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1189 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1190                            /____/                        
1191 
1192 - npm: https://www.npmjs.com/package/solidity-bits
1193 - github: https://github.com/estarriolvetch/solidity-bits
1194 
1195  */
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 library Popcount {
1200     uint256 private constant m1 = 0x5555555555555555555555555555555555555555555555555555555555555555;
1201     uint256 private constant m2 = 0x3333333333333333333333333333333333333333333333333333333333333333;
1202     uint256 private constant m4 = 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
1203     uint256 private constant h01 = 0x0101010101010101010101010101010101010101010101010101010101010101;
1204 
1205     function popcount256A(uint256 x) internal pure returns (uint256 count) {
1206         unchecked{
1207             for (count=0; x!=0; count++)
1208                 x &= x - 1;
1209         }
1210     }
1211 
1212     function popcount256B(uint256 x) internal pure returns (uint256) {
1213         if (x == type(uint256).max) {
1214             return 256;
1215         }
1216         unchecked {
1217             x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
1218             x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits 
1219             x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits 
1220             x = (x * h01) >> 248;  //returns left 8 bits of x + (x<<8) + (x<<16) + (x<<24) + ... 
1221         }
1222         return x;
1223     }
1224 }
1225 // File: solidity-bits/contracts/BitScan.sol
1226 
1227 
1228 /**
1229    _____       ___     ___ __           ____  _ __      
1230   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1231   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1232  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1233 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1234                            /____/                        
1235 
1236 - npm: https://www.npmjs.com/package/solidity-bits
1237 - github: https://github.com/estarriolvetch/solidity-bits
1238 
1239  */
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 
1244 library BitScan {
1245     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
1246     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
1247 
1248     /**
1249         @dev Isolate the least significant set bit.
1250      */ 
1251     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
1252         require(bb > 0);
1253         unchecked {
1254             return bb & (0 - bb);
1255         }
1256     } 
1257 
1258     /**
1259         @dev Isolate the most significant set bit.
1260      */ 
1261     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
1262         require(bb > 0);
1263         unchecked {
1264             bb |= bb >> 128;
1265             bb |= bb >> 64;
1266             bb |= bb >> 32;
1267             bb |= bb >> 16;
1268             bb |= bb >> 8;
1269             bb |= bb >> 4;
1270             bb |= bb >> 2;
1271             bb |= bb >> 1;
1272             
1273             return (bb >> 1) + 1;
1274         }
1275     } 
1276 
1277     /**
1278         @dev Find the index of the lest significant set bit. (trailing zero count)
1279      */ 
1280     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
1281         unchecked {
1282             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
1283         }   
1284     }
1285 
1286     /**
1287         @dev Find the index of the most significant set bit.
1288      */ 
1289     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
1290         unchecked {
1291             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
1292         }   
1293     }
1294 
1295     function log2(uint256 bb) pure internal returns (uint8) {
1296         unchecked {
1297             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
1298         } 
1299     }
1300 }
1301 
1302 // File: solidity-bits/contracts/BitMaps.sol
1303 
1304 
1305 /**
1306    _____       ___     ___ __           ____  _ __      
1307   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1308   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1309  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1310 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1311                            /____/                        
1312 
1313 - npm: https://www.npmjs.com/package/solidity-bits
1314 - github: https://github.com/estarriolvetch/solidity-bits
1315 
1316  */
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 
1321 /**
1322  * @dev This Library is a modified version of Openzeppelin's BitMaps library with extra features.
1323  *
1324  * 1. Functions of finding the index of the closest set bit from a given index are added.
1325  *    The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
1326  *    The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
1327  * 2. Setting and unsetting the bitmap consecutively.
1328  * 3. Accounting number of set bits within a given range.   
1329  *
1330 */
1331 
1332 /**
1333  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
1334  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
1335  */
1336 
1337 library BitMaps {
1338     using BitScan for uint256;
1339     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
1340     uint256 private constant MASK_FULL = type(uint256).max;
1341 
1342     struct BitMap {
1343         mapping(uint256 => uint256) _data;
1344     }
1345 
1346     /**
1347      * @dev Returns whether the bit at `index` is set.
1348      */
1349     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
1350         uint256 bucket = index >> 8;
1351         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1352         return bitmap._data[bucket] & mask != 0;
1353     }
1354 
1355     /**
1356      * @dev Sets the bit at `index` to the boolean `value`.
1357      */
1358     function setTo(
1359         BitMap storage bitmap,
1360         uint256 index,
1361         bool value
1362     ) internal {
1363         if (value) {
1364             set(bitmap, index);
1365         } else {
1366             unset(bitmap, index);
1367         }
1368     }
1369 
1370     /**
1371      * @dev Sets the bit at `index`.
1372      */
1373     function set(BitMap storage bitmap, uint256 index) internal {
1374         uint256 bucket = index >> 8;
1375         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1376         bitmap._data[bucket] |= mask;
1377     }
1378 
1379     /**
1380      * @dev Unsets the bit at `index`.
1381      */
1382     function unset(BitMap storage bitmap, uint256 index) internal {
1383         uint256 bucket = index >> 8;
1384         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1385         bitmap._data[bucket] &= ~mask;
1386     }
1387 
1388 
1389     /**
1390      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
1391      */    
1392     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
1393         uint256 bucket = startIndex >> 8;
1394 
1395         uint256 bucketStartIndex = (startIndex & 0xff);
1396 
1397         unchecked {
1398             if(bucketStartIndex + amount < 256) {
1399                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
1400             } else {
1401                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
1402                 amount -= (256 - bucketStartIndex);
1403                 bucket++;
1404 
1405                 while(amount > 256) {
1406                     bitmap._data[bucket] = MASK_FULL;
1407                     amount -= 256;
1408                     bucket++;
1409                 }
1410 
1411                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
1412             }
1413         }
1414     }
1415 
1416 
1417     /**
1418      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
1419      */    
1420     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
1421         uint256 bucket = startIndex >> 8;
1422 
1423         uint256 bucketStartIndex = (startIndex & 0xff);
1424 
1425         unchecked {
1426             if(bucketStartIndex + amount < 256) {
1427                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
1428             } else {
1429                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
1430                 amount -= (256 - bucketStartIndex);
1431                 bucket++;
1432 
1433                 while(amount > 256) {
1434                     bitmap._data[bucket] = 0;
1435                     amount -= 256;
1436                     bucket++;
1437                 }
1438 
1439                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
1440             }
1441         }
1442     }
1443 
1444     /**
1445      * @dev Returns number of set bits within a range.
1446      */
1447     function popcountA(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
1448         uint256 bucket = startIndex >> 8;
1449 
1450         uint256 bucketStartIndex = (startIndex & 0xff);
1451 
1452         unchecked {
1453             if(bucketStartIndex + amount < 256) {
1454                 count +=  Popcount.popcount256A(
1455                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
1456                 );
1457             } else {
1458                 count += Popcount.popcount256A(
1459                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
1460                 );
1461                 amount -= (256 - bucketStartIndex);
1462                 bucket++;
1463 
1464                 while(amount > 256) {
1465                     count += Popcount.popcount256A(bitmap._data[bucket]);
1466                     amount -= 256;
1467                     bucket++;
1468                 }
1469                 count += Popcount.popcount256A(
1470                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
1471                 );
1472             }
1473         }
1474     }
1475 
1476     /**
1477      * @dev Returns number of set bits within a range.
1478      */
1479     function popcountB(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
1480         uint256 bucket = startIndex >> 8;
1481 
1482         uint256 bucketStartIndex = (startIndex & 0xff);
1483 
1484         unchecked {
1485             if(bucketStartIndex + amount < 256) {
1486                 count +=  Popcount.popcount256B(
1487                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
1488                 );
1489             } else {
1490                 count += Popcount.popcount256B(
1491                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
1492                 );
1493                 amount -= (256 - bucketStartIndex);
1494                 bucket++;
1495 
1496                 while(amount > 256) {
1497                     count += Popcount.popcount256B(bitmap._data[bucket]);
1498                     amount -= 256;
1499                     bucket++;
1500                 }
1501                 count += Popcount.popcount256B(
1502                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
1503                 );
1504             }
1505         }
1506     }
1507 
1508 
1509     /**
1510      * @dev Find the closest index of the set bit before `index`.
1511      */
1512     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
1513         uint256 bucket = index >> 8;
1514 
1515         // index within the bucket
1516         uint256 bucketIndex = (index & 0xff);
1517 
1518         // load a bitboard from the bitmap.
1519         uint256 bb = bitmap._data[bucket];
1520 
1521         // offset the bitboard to scan from `bucketIndex`.
1522         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
1523         
1524         if(bb > 0) {
1525             unchecked {
1526                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());    
1527             }
1528         } else {
1529             while(true) {
1530                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
1531                 unchecked {
1532                     bucket--;
1533                 }
1534                 // No offset. Always scan from the least significiant bit now.
1535                 bb = bitmap._data[bucket];
1536                 
1537                 if(bb > 0) {
1538                     unchecked {
1539                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
1540                         break;
1541                     }
1542                 } 
1543             }
1544         }
1545     }
1546 
1547     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
1548         return bitmap._data[bucket];
1549     }
1550 }
1551 
1552 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1553 
1554 
1555 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1556 
1557 pragma solidity ^0.8.0;
1558 
1559 /**
1560  * @dev Contract module that helps prevent reentrant calls to a function.
1561  *
1562  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1563  * available, which can be applied to functions to make sure there are no nested
1564  * (reentrant) calls to them.
1565  *
1566  * Note that because there is a single `nonReentrant` guard, functions marked as
1567  * `nonReentrant` may not call one another. This can be worked around by making
1568  * those functions `private`, and then adding `external` `nonReentrant` entry
1569  * points to them.
1570  *
1571  * TIP: If you would like to learn more about reentrancy and alternative ways
1572  * to protect against it, check out our blog post
1573  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1574  */
1575 abstract contract ReentrancyGuard {
1576     // Booleans are more expensive than uint256 or any type that takes up a full
1577     // word because each write operation emits an extra SLOAD to first read the
1578     // slot's contents, replace the bits taken up by the boolean, and then write
1579     // back. This is the compiler's defense against contract upgrades and
1580     // pointer aliasing, and it cannot be disabled.
1581 
1582     // The values being non-zero value makes deployment a bit more expensive,
1583     // but in exchange the refund on every call to nonReentrant will be lower in
1584     // amount. Since refunds are capped to a percentage of the total
1585     // transaction's gas, it is best to keep them low in cases like this one, to
1586     // increase the likelihood of the full refund coming into effect.
1587     uint256 private constant _NOT_ENTERED = 1;
1588     uint256 private constant _ENTERED = 2;
1589 
1590     uint256 private _status;
1591 
1592     constructor() {
1593         _status = _NOT_ENTERED;
1594     }
1595 
1596     /**
1597      * @dev Prevents a contract from calling itself, directly or indirectly.
1598      * Calling a `nonReentrant` function from another `nonReentrant`
1599      * function is not supported. It is possible to prevent this from happening
1600      * by making the `nonReentrant` function external, and making it call a
1601      * `private` function that does the actual work.
1602      */
1603     modifier nonReentrant() {
1604         _nonReentrantBefore();
1605         _;
1606         _nonReentrantAfter();
1607     }
1608 
1609     function _nonReentrantBefore() private {
1610         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1611         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1612 
1613         // Any calls to nonReentrant after this point will fail
1614         _status = _ENTERED;
1615     }
1616 
1617     function _nonReentrantAfter() private {
1618         // By storing the original value once again, a refund is triggered (see
1619         // https://eips.ethereum.org/EIPS/eip-2200)
1620         _status = _NOT_ENTERED;
1621     }
1622 }
1623 
1624 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1625 
1626 
1627 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1628 
1629 pragma solidity ^0.8.0;
1630 
1631 /**
1632  * @dev Interface of the ERC165 standard, as defined in the
1633  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1634  *
1635  * Implementers can declare support of contract interfaces, which can then be
1636  * queried by others ({ERC165Checker}).
1637  *
1638  * For an implementation, see {ERC165}.
1639  */
1640 interface IERC165 {
1641     /**
1642      * @dev Returns true if this contract implements the interface defined by
1643      * `interfaceId`. See the corresponding
1644      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1645      * to learn more about how these ids are created.
1646      *
1647      * This function call must use less than 30 000 gas.
1648      */
1649     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1650 }
1651 
1652 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1653 
1654 
1655 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1656 
1657 pragma solidity ^0.8.0;
1658 
1659 
1660 /**
1661  * @dev Required interface of an ERC721 compliant contract.
1662  */
1663 interface IERC721 is IERC165 {
1664     /**
1665      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1666      */
1667     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1668 
1669     /**
1670      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1671      */
1672     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1673 
1674     /**
1675      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1676      */
1677     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1678 
1679     /**
1680      * @dev Returns the number of tokens in ``owner``'s account.
1681      */
1682     function balanceOf(address owner) external view returns (uint256 balance);
1683 
1684     /**
1685      * @dev Returns the owner of the `tokenId` token.
1686      *
1687      * Requirements:
1688      *
1689      * - `tokenId` must exist.
1690      */
1691     function ownerOf(uint256 tokenId) external view returns (address owner);
1692 
1693     /**
1694      * @dev Safely transfers `tokenId` token from `from` to `to`.
1695      *
1696      * Requirements:
1697      *
1698      * - `from` cannot be the zero address.
1699      * - `to` cannot be the zero address.
1700      * - `tokenId` token must exist and be owned by `from`.
1701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1703      *
1704      * Emits a {Transfer} event.
1705      */
1706     function safeTransferFrom(
1707         address from,
1708         address to,
1709         uint256 tokenId,
1710         bytes calldata data
1711     ) external;
1712 
1713     /**
1714      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1715      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1716      *
1717      * Requirements:
1718      *
1719      * - `from` cannot be the zero address.
1720      * - `to` cannot be the zero address.
1721      * - `tokenId` token must exist and be owned by `from`.
1722      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1723      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function safeTransferFrom(
1728         address from,
1729         address to,
1730         uint256 tokenId
1731     ) external;
1732 
1733     /**
1734      * @dev Transfers `tokenId` token from `from` to `to`.
1735      *
1736      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1737      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1738      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1739      *
1740      * Requirements:
1741      *
1742      * - `from` cannot be the zero address.
1743      * - `to` cannot be the zero address.
1744      * - `tokenId` token must be owned by `from`.
1745      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1746      *
1747      * Emits a {Transfer} event.
1748      */
1749     function transferFrom(
1750         address from,
1751         address to,
1752         uint256 tokenId
1753     ) external;
1754 
1755     /**
1756      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1757      * The approval is cleared when the token is transferred.
1758      *
1759      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1760      *
1761      * Requirements:
1762      *
1763      * - The caller must own the token or be an approved operator.
1764      * - `tokenId` must exist.
1765      *
1766      * Emits an {Approval} event.
1767      */
1768     function approve(address to, uint256 tokenId) external;
1769 
1770     /**
1771      * @dev Approve or remove `operator` as an operator for the caller.
1772      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1773      *
1774      * Requirements:
1775      *
1776      * - The `operator` cannot be the caller.
1777      *
1778      * Emits an {ApprovalForAll} event.
1779      */
1780     function setApprovalForAll(address operator, bool _approved) external;
1781 
1782     /**
1783      * @dev Returns the account approved for `tokenId` token.
1784      *
1785      * Requirements:
1786      *
1787      * - `tokenId` must exist.
1788      */
1789     function getApproved(uint256 tokenId) external view returns (address operator);
1790 
1791     /**
1792      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1793      *
1794      * See {setApprovalForAll}
1795      */
1796     function isApprovedForAll(address owner, address operator) external view returns (bool);
1797 }
1798 
1799 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1800 
1801 
1802 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1803 
1804 pragma solidity ^0.8.0;
1805 
1806 
1807 /**
1808  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1809  * @dev See https://eips.ethereum.org/EIPS/eip-721
1810  */
1811 interface IERC721Metadata is IERC721 {
1812     /**
1813      * @dev Returns the token collection name.
1814      */
1815     function name() external view returns (string memory);
1816 
1817     /**
1818      * @dev Returns the token collection symbol.
1819      */
1820     function symbol() external view returns (string memory);
1821 
1822     /**
1823      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1824      */
1825     function tokenURI(uint256 tokenId) external view returns (string memory);
1826 }
1827 
1828 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1829 
1830 
1831 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1832 
1833 pragma solidity ^0.8.0;
1834 
1835 
1836 /**
1837  * @dev Implementation of the {IERC165} interface.
1838  *
1839  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1840  * for the additional interface id that will be supported. For example:
1841  *
1842  * ```solidity
1843  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1844  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1845  * }
1846  * ```
1847  *
1848  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1849  */
1850 abstract contract ERC165 is IERC165 {
1851     /**
1852      * @dev See {IERC165-supportsInterface}.
1853      */
1854     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1855         return interfaceId == type(IERC165).interfaceId;
1856     }
1857 }
1858 
1859 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1860 
1861 
1862 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1863 
1864 pragma solidity ^0.8.0;
1865 
1866 
1867 /**
1868  * @dev Interface for the NFT Royalty Standard.
1869  *
1870  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1871  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1872  *
1873  * _Available since v4.5._
1874  */
1875 interface IERC2981 is IERC165 {
1876     /**
1877      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1878      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1879      */
1880     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1881         external
1882         view
1883         returns (address receiver, uint256 royaltyAmount);
1884 }
1885 
1886 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1887 
1888 
1889 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1890 
1891 pragma solidity ^0.8.0;
1892 
1893 
1894 
1895 /**
1896  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1897  *
1898  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1899  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1900  *
1901  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1902  * fee is specified in basis points by default.
1903  *
1904  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1905  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1906  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1907  *
1908  * _Available since v4.5._
1909  */
1910 abstract contract ERC2981 is IERC2981, ERC165 {
1911     struct RoyaltyInfo {
1912         address receiver;
1913         uint96 royaltyFraction;
1914     }
1915 
1916     RoyaltyInfo private _defaultRoyaltyInfo;
1917     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1918 
1919     /**
1920      * @dev See {IERC165-supportsInterface}.
1921      */
1922     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1923         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1924     }
1925 
1926     /**
1927      * @inheritdoc IERC2981
1928      */
1929     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1930         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1931 
1932         if (royalty.receiver == address(0)) {
1933             royalty = _defaultRoyaltyInfo;
1934         }
1935 
1936         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1937 
1938         return (royalty.receiver, royaltyAmount);
1939     }
1940 
1941     /**
1942      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1943      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1944      * override.
1945      */
1946     function _feeDenominator() internal pure virtual returns (uint96) {
1947         return 10000;
1948     }
1949 
1950     /**
1951      * @dev Sets the royalty information that all ids in this contract will default to.
1952      *
1953      * Requirements:
1954      *
1955      * - `receiver` cannot be the zero address.
1956      * - `feeNumerator` cannot be greater than the fee denominator.
1957      */
1958     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1959         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1960         require(receiver != address(0), "ERC2981: invalid receiver");
1961 
1962         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1963     }
1964 
1965     /**
1966      * @dev Removes default royalty information.
1967      */
1968     function _deleteDefaultRoyalty() internal virtual {
1969         delete _defaultRoyaltyInfo;
1970     }
1971 
1972     /**
1973      * @dev Sets the royalty information for a specific token id, overriding the global default.
1974      *
1975      * Requirements:
1976      *
1977      * - `receiver` cannot be the zero address.
1978      * - `feeNumerator` cannot be greater than the fee denominator.
1979      */
1980     function _setTokenRoyalty(
1981         uint256 tokenId,
1982         address receiver,
1983         uint96 feeNumerator
1984     ) internal virtual {
1985         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1986         require(receiver != address(0), "ERC2981: Invalid parameters");
1987 
1988         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1989     }
1990 
1991     /**
1992      * @dev Resets royalty information for the token id back to the global default.
1993      */
1994     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1995         delete _tokenRoyaltyInfo[tokenId];
1996     }
1997 }
1998 
1999 // File: @openzeppelin/contracts/utils/Context.sol
2000 
2001 
2002 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2003 
2004 pragma solidity ^0.8.0;
2005 
2006 /**
2007  * @dev Provides information about the current execution context, including the
2008  * sender of the transaction and its data. While these are generally available
2009  * via msg.sender and msg.data, they should not be accessed in such a direct
2010  * manner, since when dealing with meta-transactions the account sending and
2011  * paying for execution may not be the actual sender (as far as an application
2012  * is concerned).
2013  *
2014  * This contract is only required for intermediate, library-like contracts.
2015  */
2016 abstract contract Context {
2017     function _msgSender() internal view virtual returns (address) {
2018         return msg.sender;
2019     }
2020 
2021     function _msgData() internal view virtual returns (bytes calldata) {
2022         return msg.data;
2023     }
2024 }
2025 
2026 // File: erc721psi/contracts/ERC721Psi.sol
2027 
2028 
2029 /**
2030   ______ _____   _____ ______ ___  __ _  _  _ 
2031  |  ____|  __ \ / ____|____  |__ \/_ | || || |
2032  | |__  | |__) | |        / /   ) || | \| |/ |
2033  |  __| |  _  /| |       / /   / / | |\_   _/ 
2034  | |____| | \ \| |____  / /   / /_ | |  | |   
2035  |______|_|  \_\\_____|/_/   |____||_|  |_|   
2036 
2037  - github: https://github.com/estarriolvetch/ERC721Psi
2038  - npm: https://www.npmjs.com/package/erc721psi
2039                                           
2040  */
2041 
2042 pragma solidity ^0.8.0;
2043 
2044 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata {
2045     using Address for address;
2046     using Strings for uint256;
2047     using BitMaps for BitMaps.BitMap;
2048 
2049     BitMaps.BitMap internal _batchHead;
2050 
2051     string private _name;
2052     string private _symbol;
2053 
2054     // Mapping from token ID to owner address
2055     mapping(uint256 => address) internal _owners;
2056     uint256 internal _currentIndex;
2057 
2058     mapping(uint256 => address) private _tokenApprovals;
2059     mapping(address => mapping(address => bool)) private _operatorApprovals;
2060 
2061     /**
2062      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2063      */
2064     constructor(string memory name_, string memory symbol_) {
2065         _name = name_;
2066         _symbol = symbol_;
2067         _currentIndex = _startTokenId();
2068     }
2069 
2070     /**
2071      * @dev Returns the starting token ID.
2072      * To change the starting token ID, please override this function.
2073      */
2074     function _startTokenId() internal pure virtual returns (uint256) {
2075         // It will become modifiable in the future versions
2076         return 0;
2077     }
2078 
2079     /**
2080      * @dev Returns the next token ID to be minted.
2081      */
2082     function _nextTokenId() internal view virtual returns (uint256) {
2083         return _currentIndex;
2084     }
2085 
2086     /**
2087      * @dev Returns the total amount of tokens minted in the contract.
2088      */
2089     function _totalMinted() internal view virtual returns (uint256) {
2090         return _currentIndex - _startTokenId();
2091     }
2092 
2093 
2094     /**
2095      * @dev See {IERC165-supportsInterface}.
2096      */
2097     function supportsInterface(bytes4 interfaceId)
2098         public
2099         view
2100         virtual
2101         override(ERC165, IERC165)
2102         returns (bool)
2103     {
2104         return
2105             interfaceId == type(IERC721).interfaceId ||
2106             interfaceId == type(IERC721Metadata).interfaceId ||
2107             super.supportsInterface(interfaceId);
2108     }
2109 
2110     /**
2111      * @dev See {IERC721-balanceOf}.
2112      */
2113     function balanceOf(address owner) 
2114         public 
2115         view 
2116         virtual 
2117         override 
2118         returns (uint) 
2119     {
2120         require(owner != address(0), "ERC721Psi: balance query for the zero address");
2121 
2122         uint count;
2123         for( uint i = _startTokenId(); i < _nextTokenId(); ++i ){
2124             if(_exists(i)){
2125                 if( owner == ownerOf(i)){
2126                     ++count;
2127                 }
2128             }
2129         }
2130         return count;
2131     }
2132 
2133     /**
2134      * @dev See {IERC721-ownerOf}.
2135      */
2136     function ownerOf(uint256 tokenId)
2137         public
2138         view
2139         virtual
2140         override
2141         returns (address)
2142     {
2143         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
2144         return owner;
2145     }
2146 
2147     function _ownerAndBatchHeadOf(uint256 tokenId) internal view virtual returns (address owner, uint256 tokenIdBatchHead){
2148         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
2149         tokenIdBatchHead = _getBatchHead(tokenId);
2150         owner = _owners[tokenIdBatchHead];
2151     }
2152 
2153     /**
2154      * @dev See {IERC721Metadata-name}.
2155      */
2156     function name() public view virtual override returns (string memory) {
2157         return _name;
2158     }
2159 
2160     /**
2161      * @dev See {IERC721Metadata-symbol}.
2162      */
2163     function symbol() public view virtual override returns (string memory) {
2164         return _symbol;
2165     }
2166 
2167     /**
2168      * @dev See {IERC721Metadata-tokenURI}.
2169      */
2170     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2171         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
2172 
2173         string memory baseURI = _baseURI();
2174         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2175     }
2176 
2177     /**
2178      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2179      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2180      * by default, can be overriden in child contracts.
2181      */
2182     function _baseURI() internal view virtual returns (string memory) {
2183         return "";
2184     }
2185 
2186 
2187     /**
2188      * @dev See {IERC721-approve}.
2189      */
2190     function approve(address to, uint256 tokenId) public virtual override {
2191         address owner = ownerOf(tokenId);
2192         require(to != owner, "ERC721Psi: approval to current owner");
2193 
2194         require(
2195             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2196             "ERC721Psi: approve caller is not owner nor approved for all"
2197         );
2198 
2199         _approve(to, tokenId);
2200     }
2201 
2202     /**
2203      * @dev See {IERC721-getApproved}.
2204      */
2205     function getApproved(uint256 tokenId)
2206         public
2207         view
2208         virtual
2209         override
2210         returns (address)
2211     {
2212         require(
2213             _exists(tokenId),
2214             "ERC721Psi: approved query for nonexistent token"
2215         );
2216 
2217         return _tokenApprovals[tokenId];
2218     }
2219 
2220     /**
2221      * @dev See {IERC721-setApprovalForAll}.
2222      */
2223     function setApprovalForAll(address operator, bool approved)
2224         public
2225         virtual
2226         override
2227     {
2228         require(operator != _msgSender(), "ERC721Psi: approve to caller");
2229 
2230         _operatorApprovals[_msgSender()][operator] = approved;
2231         emit ApprovalForAll(_msgSender(), operator, approved);
2232     }
2233 
2234     /**
2235      * @dev See {IERC721-isApprovedForAll}.
2236      */
2237     function isApprovedForAll(address owner, address operator)
2238         public
2239         view
2240         virtual
2241         override
2242         returns (bool)
2243     {
2244         return _operatorApprovals[owner][operator];
2245     }
2246 
2247     /**
2248      * @dev See {IERC721-transferFrom}.
2249      */
2250     function transferFrom(
2251         address from,
2252         address to,
2253         uint256 tokenId
2254     ) public virtual override {
2255         //solhint-disable-next-line max-line-length
2256         require(
2257             _isApprovedOrOwner(_msgSender(), tokenId),
2258             "ERC721Psi: transfer caller is not owner nor approved"
2259         );
2260 
2261         _transfer(from, to, tokenId);
2262     }
2263 
2264     /**
2265      * @dev See {IERC721-safeTransferFrom}.
2266      */
2267     function safeTransferFrom(
2268         address from,
2269         address to,
2270         uint256 tokenId
2271     ) public virtual override {
2272         safeTransferFrom(from, to, tokenId, "");
2273     }
2274 
2275     /**
2276      * @dev See {IERC721-safeTransferFrom}.
2277      */
2278     function safeTransferFrom(
2279         address from,
2280         address to,
2281         uint256 tokenId,
2282         bytes memory _data
2283     ) public virtual override {
2284         require(
2285             _isApprovedOrOwner(_msgSender(), tokenId),
2286             "ERC721Psi: transfer caller is not owner nor approved"
2287         );
2288         _safeTransfer(from, to, tokenId, _data);
2289     }
2290 
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
2309     function _safeTransfer(
2310         address from,
2311         address to,
2312         uint256 tokenId,
2313         bytes memory _data
2314     ) internal virtual {
2315         _transfer(from, to, tokenId);
2316         require(
2317             _checkOnERC721Received(from, to, tokenId, 1,_data),
2318             "ERC721Psi: transfer to non ERC721Receiver implementer"
2319         );
2320     }
2321 
2322     /**
2323      * @dev Returns whether `tokenId` exists.
2324      *
2325      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2326      *
2327      * Tokens start existing when they are minted (`_mint`).
2328      */
2329     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2330         return tokenId < _nextTokenId() && _startTokenId() <= tokenId;
2331     }
2332 
2333     /**
2334      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2335      *
2336      * Requirements:
2337      *
2338      * - `tokenId` must exist.
2339      */
2340     function _isApprovedOrOwner(address spender, uint256 tokenId)
2341         internal
2342         view
2343         virtual
2344         returns (bool)
2345     {
2346         require(
2347             _exists(tokenId),
2348             "ERC721Psi: operator query for nonexistent token"
2349         );
2350         address owner = ownerOf(tokenId);
2351         return (spender == owner ||
2352             getApproved(tokenId) == spender ||
2353             isApprovedForAll(owner, spender));
2354     }
2355 
2356     /**
2357      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2358      *
2359      * Requirements:
2360      *
2361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2362      * - `quantity` must be greater than 0.
2363      *
2364      * Emits a {Transfer} event.
2365      */
2366     function _safeMint(address to, uint256 quantity) internal virtual {
2367         _safeMint(to, quantity, "");
2368     }
2369 
2370     
2371     function _safeMint(
2372         address to,
2373         uint256 quantity,
2374         bytes memory _data
2375     ) internal virtual {
2376         uint256 nextTokenId = _nextTokenId();
2377         _mint(to, quantity);
2378         require(
2379             _checkOnERC721Received(address(0), to, nextTokenId, quantity, _data),
2380             "ERC721Psi: transfer to non ERC721Receiver implementer"
2381         );
2382     }
2383 
2384 
2385     function _mint(
2386         address to,
2387         uint256 quantity
2388     ) internal virtual {
2389         uint256 nextTokenId = _nextTokenId();
2390         
2391         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
2392         require(to != address(0), "ERC721Psi: mint to the zero address");
2393         
2394         _beforeTokenTransfers(address(0), to, nextTokenId, quantity);
2395         _currentIndex += quantity;
2396         _owners[nextTokenId] = to;
2397         _batchHead.set(nextTokenId);
2398         _afterTokenTransfers(address(0), to, nextTokenId, quantity);
2399         
2400         // Emit events
2401         for(uint256 tokenId=nextTokenId; tokenId < nextTokenId + quantity; tokenId++){
2402             emit Transfer(address(0), to, tokenId);
2403         } 
2404     }
2405 
2406 
2407 
2408     /**
2409      * @dev Transfers `tokenId` from `from` to `to`.
2410      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2411      *
2412      * Requirements:
2413      *
2414      * - `to` cannot be the zero address.
2415      * - `tokenId` token must be owned by `from`.
2416      *
2417      * Emits a {Transfer} event.
2418      */
2419     function _transfer(
2420         address from,
2421         address to,
2422         uint256 tokenId
2423     ) internal virtual {
2424         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
2425 
2426         require(
2427             owner == from,
2428             "ERC721Psi: transfer of token that is not own"
2429         );
2430         require(to != address(0), "ERC721Psi: transfer to the zero address");
2431 
2432         _beforeTokenTransfers(from, to, tokenId, 1);
2433 
2434         // Clear approvals from the previous owner
2435         _approve(address(0), tokenId);   
2436 
2437         uint256 subsequentTokenId = tokenId + 1;
2438 
2439         if(!_batchHead.get(subsequentTokenId) &&  
2440             subsequentTokenId < _nextTokenId()
2441         ) {
2442             _owners[subsequentTokenId] = from;
2443             _batchHead.set(subsequentTokenId);
2444         }
2445 
2446         _owners[tokenId] = to;
2447         if(tokenId != tokenIdBatchHead) {
2448             _batchHead.set(tokenId);
2449         }
2450 
2451         emit Transfer(from, to, tokenId);
2452 
2453         _afterTokenTransfers(from, to, tokenId, 1);
2454     }
2455 
2456     /**
2457      * @dev Approve `to` to operate on `tokenId`
2458      *
2459      * Emits a {Approval} event.
2460      */
2461     function _approve(address to, uint256 tokenId) internal virtual {
2462         _tokenApprovals[tokenId] = to;
2463         emit Approval(ownerOf(tokenId), to, tokenId);
2464     }
2465 
2466     /**
2467      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2468      * The call is not executed if the target address is not a contract.
2469      *
2470      * @param from address representing the previous owner of the given token ID
2471      * @param to target address that will receive the tokens
2472      * @param startTokenId uint256 the first ID of the tokens to be transferred
2473      * @param quantity uint256 amount of the tokens to be transfered.
2474      * @param _data bytes optional data to send along with the call
2475      * @return r bool whether the call correctly returned the expected magic value
2476      */
2477     function _checkOnERC721Received(
2478         address from,
2479         address to,
2480         uint256 startTokenId,
2481         uint256 quantity,
2482         bytes memory _data
2483     ) private returns (bool r) {
2484         if (to.isContract()) {
2485             r = true;
2486             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
2487                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2488                     r = r && retval == IERC721Receiver.onERC721Received.selector;
2489                 } catch (bytes memory reason) {
2490                     if (reason.length == 0) {
2491                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
2492                     } else {
2493                         assembly {
2494                             revert(add(32, reason), mload(reason))
2495                         }
2496                     }
2497                 }
2498             }
2499             return r;
2500         } else {
2501             return true;
2502         }
2503     }
2504 
2505     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
2506         tokenIdBatchHead = _batchHead.scanForward(tokenId); 
2507     }
2508 
2509 
2510     function totalSupply() public virtual view returns (uint256) {
2511         return _totalMinted();
2512     }
2513 
2514     /**
2515      * @dev Returns an array of token IDs owned by `owner`.
2516      *
2517      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2518      * It is meant to be called off-chain.
2519      *
2520      * This function is compatiable with ERC721AQueryable.
2521      */
2522     function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
2523         unchecked {
2524             uint256 tokenIdsIdx;
2525             uint256 tokenIdsLength = balanceOf(owner);
2526             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2527             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2528                 if (_exists(i)) {
2529                     if (ownerOf(i) == owner) {
2530                         tokenIds[tokenIdsIdx++] = i;
2531                     }
2532                 }
2533             }
2534             return tokenIds;   
2535         }
2536     }
2537 
2538     /**
2539      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2540      *
2541      * startTokenId - the first token id to be transferred
2542      * quantity - the amount to be transferred
2543      *
2544      * Calling conditions:
2545      *
2546      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2547      * transferred to `to`.
2548      * - When `from` is zero, `tokenId` will be minted for `to`.
2549      */
2550     function _beforeTokenTransfers(
2551         address from,
2552         address to,
2553         uint256 startTokenId,
2554         uint256 quantity
2555     ) internal virtual {}
2556 
2557     /**
2558      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2559      * minting.
2560      *
2561      * startTokenId - the first token id to be transferred
2562      * quantity - the amount to be transferred
2563      *
2564      * Calling conditions:
2565      *
2566      * - when `from` and `to` are both non-zero.
2567      * - `from` and `to` are never both zero.
2568      */
2569     function _afterTokenTransfers(
2570         address from,
2571         address to,
2572         uint256 startTokenId,
2573         uint256 quantity
2574     ) internal virtual {}
2575 }
2576 // File: erc721psi/contracts/extension/ERC721PsiBurnable.sol
2577 
2578 
2579 /**
2580   ______ _____   _____ ______ ___  __ _  _  _ 
2581  |  ____|  __ \ / ____|____  |__ \/_ | || || |
2582  | |__  | |__) | |        / /   ) || | \| |/ |
2583  |  __| |  _  /| |       / /   / / | |\_   _/ 
2584  | |____| | \ \| |____  / /   / /_ | |  | |   
2585  |______|_|  \_\\_____|/_/   |____||_|  |_|   
2586                                               
2587                                             
2588  */
2589 pragma solidity ^0.8.0;
2590 
2591 
2592 
2593 
2594 abstract contract ERC721PsiBurnable is ERC721Psi {
2595     using BitMaps for BitMaps.BitMap;
2596     BitMaps.BitMap internal _burnedToken;
2597 
2598     /**
2599      * @dev Destroys `tokenId`.
2600      * The approval is cleared when the token is burned.
2601      *
2602      * Requirements:
2603      *
2604      * - `tokenId` must exist.
2605      *
2606      * Emits a {Transfer} event.
2607      */
2608     function _burn(uint256 tokenId) internal virtual {
2609         address from = ownerOf(tokenId);
2610         _beforeTokenTransfers(from, address(0), tokenId, 1);
2611         _burnedToken.set(tokenId);
2612         
2613         emit Transfer(from, address(0), tokenId);
2614 
2615         _afterTokenTransfers(from, address(0), tokenId, 1);
2616     }
2617 
2618     /**
2619      * @dev Returns whether `tokenId` exists.
2620      *
2621      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2622      *
2623      * Tokens start existing when they are minted (`_mint`),
2624      * and stop existing when they are burned (`_burn`).
2625      */
2626     function _exists(uint256 tokenId) internal view override virtual returns (bool){
2627         if(_burnedToken.get(tokenId)) {
2628             return false;
2629         } 
2630         return super._exists(tokenId);
2631     }
2632 
2633     /**
2634      * @dev See {IERC721Enumerable-totalSupply}.
2635      */
2636     function totalSupply() public view virtual override returns (uint256) {
2637         return _totalMinted() - _burned();
2638     }
2639 
2640     /**
2641      * @dev Returns number of token burned.
2642      */
2643     function _burned() internal view returns (uint256 burned){
2644         uint256 startBucket = _startTokenId() >> 8;
2645         uint256 lastBucket = (_nextTokenId() >> 8) + 1;
2646 
2647         for(uint256 i=startBucket; i < lastBucket; i++) {
2648             uint256 bucket = _burnedToken.getBucket(i);
2649             burned += _popcount(bucket);
2650         }
2651     }
2652 
2653     /**
2654      * @dev Returns number of set bits.
2655      */
2656     function _popcount(uint256 x) private pure returns (uint256 count) {
2657         unchecked{
2658             for (count=0; x!=0; count++)
2659                 x &= x - 1;
2660         }
2661     }
2662 }
2663 // File: @openzeppelin/contracts/access/Ownable.sol
2664 
2665 
2666 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2667 
2668 pragma solidity ^0.8.0;
2669 
2670 
2671 /**
2672  * @dev Contract module which provides a basic access control mechanism, where
2673  * there is an account (an owner) that can be granted exclusive access to
2674  * specific functions.
2675  *
2676  * By default, the owner account will be the one that deploys the contract. This
2677  * can later be changed with {transferOwnership}.
2678  *
2679  * This module is used through inheritance. It will make available the modifier
2680  * `onlyOwner`, which can be applied to your functions to restrict their use to
2681  * the owner.
2682  */
2683 abstract contract Ownable is Context {
2684     address private _owner;
2685 
2686     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2687 
2688     /**
2689      * @dev Initializes the contract setting the deployer as the initial owner.
2690      */
2691     constructor() {
2692         _transferOwnership(_msgSender());
2693     }
2694 
2695     /**
2696      * @dev Throws if called by any account other than the owner.
2697      */
2698     modifier onlyOwner() {
2699         _checkOwner();
2700         _;
2701     }
2702 
2703     /**
2704      * @dev Returns the address of the current owner.
2705      */
2706     function owner() public view virtual returns (address) {
2707         return _owner;
2708     }
2709 
2710     /**
2711      * @dev Throws if the sender is not the owner.
2712      */
2713     function _checkOwner() internal view virtual {
2714         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2715     }
2716 
2717     /**
2718      * @dev Leaves the contract without owner. It will not be possible to call
2719      * `onlyOwner` functions anymore. Can only be called by the current owner.
2720      *
2721      * NOTE: Renouncing ownership will leave the contract without an owner,
2722      * thereby removing any functionality that is only available to the owner.
2723      */
2724     function renounceOwnership() public virtual onlyOwner {
2725         _transferOwnership(address(0));
2726     }
2727 
2728     /**
2729      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2730      * Can only be called by the current owner.
2731      */
2732     function transferOwnership(address newOwner) public virtual onlyOwner {
2733         require(newOwner != address(0), "Ownable: new owner is the zero address");
2734         _transferOwnership(newOwner);
2735     }
2736 
2737     /**
2738      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2739      * Internal function without access restriction.
2740      */
2741     function _transferOwnership(address newOwner) internal virtual {
2742         address oldOwner = _owner;
2743         _owner = newOwner;
2744         emit OwnershipTransferred(oldOwner, newOwner);
2745     }
2746 }
2747 
2748 // File: EXO/NEW/EXO.sol
2749 
2750 pragma solidity >=0.6.0;
2751 
2752 /// @title Base64
2753 /// @author Brecht Devos - <brecht@loopring.org>
2754 /// @notice Provides functions for encoding/decoding base64
2755 library Base64 {
2756     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
2757     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
2758                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
2759                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
2760                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
2761 
2762     function encode(bytes memory data) internal pure returns (string memory) {
2763         if (data.length == 0) return '';
2764 
2765         // load the table into memory
2766         string memory table = TABLE_ENCODE;
2767 
2768         // multiply by 4/3 rounded up
2769         uint256 encodedLen = 4 * ((data.length + 2) / 3);
2770 
2771         // add some extra buffer at the end required for the writing
2772         string memory result = new string(encodedLen + 32);
2773 
2774         assembly {
2775             // set the actual output length
2776             mstore(result, encodedLen)
2777 
2778             // prepare the lookup table
2779             let tablePtr := add(table, 1)
2780 
2781             // input ptr
2782             let dataPtr := data
2783             let endPtr := add(dataPtr, mload(data))
2784 
2785             // result ptr, jump over length
2786             let resultPtr := add(result, 32)
2787 
2788             // run over the input, 3 bytes at a time
2789             for {} lt(dataPtr, endPtr) {}
2790             {
2791                 // read 3 bytes
2792                 dataPtr := add(dataPtr, 3)
2793                 let input := mload(dataPtr)
2794 
2795                 // write 4 characters
2796                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2797                 resultPtr := add(resultPtr, 1)
2798                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2799                 resultPtr := add(resultPtr, 1)
2800                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
2801                 resultPtr := add(resultPtr, 1)
2802                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
2803                 resultPtr := add(resultPtr, 1)
2804             }
2805 
2806             // padding with '='
2807             switch mod(mload(data), 3)
2808             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
2809             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
2810         }
2811 
2812         return result;
2813     }
2814 
2815     function decode(string memory _data) internal pure returns (bytes memory) {
2816         bytes memory data = bytes(_data);
2817 
2818         if (data.length == 0) return new bytes(0);
2819         require(data.length % 4 == 0, "invalid base64 decoder input");
2820 
2821         // load the table into memory
2822         bytes memory table = TABLE_DECODE;
2823 
2824         // every 4 characters represent 3 bytes
2825         uint256 decodedLen = (data.length / 4) * 3;
2826 
2827         // add some extra buffer at the end required for the writing
2828         bytes memory result = new bytes(decodedLen + 32);
2829 
2830         assembly {
2831             // padding with '='
2832             let lastBytes := mload(add(data, mload(data)))
2833             if eq(and(lastBytes, 0xFF), 0x3d) {
2834                 decodedLen := sub(decodedLen, 1)
2835                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
2836                     decodedLen := sub(decodedLen, 1)
2837                 }
2838             }
2839 
2840             // set the actual output length
2841             mstore(result, decodedLen)
2842 
2843             // prepare the lookup table
2844             let tablePtr := add(table, 1)
2845 
2846             // input ptr
2847             let dataPtr := data
2848             let endPtr := add(dataPtr, mload(data))
2849 
2850             // result ptr, jump over length
2851             let resultPtr := add(result, 32)
2852 
2853             // run over the input, 4 characters at a time
2854             for {} lt(dataPtr, endPtr) {}
2855             {
2856                // read 4 characters
2857                dataPtr := add(dataPtr, 4)
2858                let input := mload(dataPtr)
2859 
2860                // write 3 bytes
2861                let output := add(
2862                    add(
2863                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
2864                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
2865                    add(
2866                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
2867                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
2868                     )
2869                 )
2870                 mstore(resultPtr, shl(232, output))
2871                 resultPtr := add(resultPtr, 3)
2872             }
2873         }
2874 
2875         return result;
2876     }
2877 }
2878 
2879 
2880 
2881 
2882 
2883 
2884 pragma solidity ^0.8.7;
2885 
2886 
2887 abstract contract MerkleProof {
2888     mapping(uint256 => bytes32) internal _wlMerkleRoot;
2889     mapping(uint256 => bytes32) internal _alMerkleRoot;
2890     uint256 public phaseId;
2891 
2892     function _setWlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2893         _wlMerkleRoot[phaseId] = merkleRoot_;
2894     }
2895 
2896     function _setWlMerkleRootWithId(uint256 _phaseId,bytes32 merkleRoot_) internal virtual {
2897         _wlMerkleRoot[_phaseId] = merkleRoot_;
2898     }
2899     function isWhitelisted(address address_, uint256 _phaseId, uint256 wlCount, bytes32[] memory proof_) public view returns (bool) {
2900         bytes32 _leaf = keccak256(abi.encodePacked(address_, wlCount));
2901         for (uint256 i = 0; i < proof_.length; i++) {
2902             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2903         }
2904         return _leaf == _wlMerkleRoot[_phaseId];
2905     }
2906 
2907     function _setAlMerkleRootWithId(uint256 _phaseId,bytes32 merkleRoot_) internal virtual {
2908         _alMerkleRoot[_phaseId] = merkleRoot_;
2909     }
2910 
2911     function _setAlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2912         _alMerkleRoot[phaseId] = merkleRoot_;
2913     }
2914 
2915     function isAllowlisted(address address_,uint256 _phaseId, bytes32[] memory proof_) public view returns (bool) {
2916         bytes32 _leaf = keccak256(abi.encodePacked(address_));
2917         for (uint256 i = 0; i < proof_.length; i++) {
2918             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2919         }
2920         return _leaf == _alMerkleRoot[_phaseId];
2921     }
2922 
2923 }
2924 
2925 pragma solidity ^0.8.9;
2926 abstract contract Operable is Context {
2927     mapping(address => bool) _operators;
2928     modifier onlyOperator() {
2929         _checkOperatorRole(_msgSender());
2930         _;
2931     }
2932     function isOperator(address _operator) public view returns (bool) {
2933         return _operators[_operator];
2934     }
2935     function _grantOperatorRole(address _candidate) internal {
2936         require(
2937             !_operators[_candidate],
2938             string(
2939                 abi.encodePacked(
2940                     "account ",
2941                     Strings.toHexString(uint160(_msgSender()), 20),
2942                     " is already has an operator role"
2943                 )
2944             )
2945         );
2946         _operators[_candidate] = true;
2947     }
2948     function _revokeOperatorRole(address _candidate) internal {
2949         _checkOperatorRole(_candidate);
2950         delete _operators[_candidate];
2951     }
2952     function _checkOperatorRole(address _operator) internal view {
2953         require(
2954             _operators[_operator],
2955             string(
2956                 abi.encodePacked(
2957                     "account ",
2958                     Strings.toHexString(uint160(_msgSender()), 20),
2959                     " is not an operator"
2960                 )
2961             )
2962         );
2963     }
2964 }
2965 
2966 pragma solidity ^0.8.13;
2967 
2968 interface IOperatorFilterRegistry {
2969     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2970     function register(address registrant) external;
2971     function registerAndSubscribe(address registrant, address subscription) external;
2972     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2973     function unregister(address addr) external;
2974     function updateOperator(address registrant, address operator, bool filtered) external;
2975     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2976     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2977     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2978     function subscribe(address registrant, address registrantToSubscribe) external;
2979     function unsubscribe(address registrant, bool copyExistingEntries) external;
2980     function subscriptionOf(address addr) external returns (address registrant);
2981     function subscribers(address registrant) external returns (address[] memory);
2982     function subscriberAt(address registrant, uint256 index) external returns (address);
2983     function copyEntriesOf(address registrant, address registrantToCopy) external;
2984     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2985     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2986     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2987     function filteredOperators(address addr) external returns (address[] memory);
2988     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2989     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2990     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2991     function isRegistered(address addr) external returns (bool);
2992     function codeHashOf(address addr) external returns (bytes32);
2993 }
2994 
2995 pragma solidity ^0.8.13;
2996 
2997 
2998 /**
2999  * @title  OperatorFilterer
3000  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3001  *         registrant's entries in the OperatorFilterRegistry.
3002  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3003  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3004  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3005  */
3006 abstract contract OperatorFilterer {
3007     error OperatorNotAllowed(address operator);
3008     bool public operatorFilteringEnabled = true;
3009 
3010     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3011         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3012 
3013     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3014         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3015         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3016         // order for the modifier to filter addresses.
3017         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3018             if (subscribe) {
3019                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
3020             } else {
3021                 if (subscriptionOrRegistrantToCopy != address(0)) {
3022                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
3023                 } else {
3024                     OPERATOR_FILTER_REGISTRY.register(address(this));
3025                 }
3026             }
3027         }
3028     }
3029 
3030     modifier onlyAllowedOperator(address from) virtual {
3031         // Check registry code length to facilitate testing in environments without a deployed registry.
3032         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
3033             // Allow spending tokens from addresses with balance
3034             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3035             // from an EOA.
3036             if (from == msg.sender) {
3037                 _;
3038                 return;
3039             }
3040             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
3041                 revert OperatorNotAllowed(msg.sender);
3042             }
3043         }
3044         _;
3045     }
3046 
3047     modifier onlyAllowedOperatorApproval(address operator) virtual {
3048         // Check registry code length to facilitate testing in environments without a deployed registry.
3049         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
3050             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
3051                 revert OperatorNotAllowed(operator);
3052             }
3053         }
3054         _;
3055     }
3056 }
3057 
3058 
3059 pragma solidity ^0.8.13;
3060 /**
3061  * @title  DefaultOperatorFilterer
3062  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3063  */
3064 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3065     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3066 
3067     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3068 }
3069 
3070 
3071 
3072 
3073 
3074 pragma solidity >=0.7.0 <0.9.0;
3075 
3076 interface IContractAllowListProxy {
3077     function isAllowed(address _transferer, uint256 _level)
3078         external
3079         view
3080         returns (bool);
3081 }
3082 
3083 pragma solidity >=0.8.0;
3084 
3085 /// @title IERC721RestrictApprove
3086 /// @dev Approve抑制機能付きコントラクトのインターフェース
3087 /// @author Lavulite
3088 
3089 interface IERC721RestrictApprove {
3090     /**
3091      * @dev CALレベルが変更された場合のイベント
3092      */
3093     event CalLevelChanged(address indexed operator, uint256 indexed level);
3094     
3095     /**
3096      * @dev LocalContractAllowListnに追加された場合のイベント
3097      */
3098     event LocalCalAdded(address indexed operator, address indexed transferer);
3099 
3100     /**
3101      * @dev LocalContractAllowListnに削除された場合のイベント
3102      */
3103     event LocalCalRemoved(address indexed operator, address indexed transferer);
3104 
3105     /**
3106      * @dev CALを利用する場合のCALのレベルを設定する。レベルが高いほど、許可されるコントラクトの範囲が狭い。
3107      */
3108     function setCALLevel(uint256 level) external;
3109 
3110     /**
3111      * @dev CALのアドレスをセットする。
3112      */
3113     function setCAL(address calAddress) external;
3114 
3115     /**
3116      * @dev CALのリストに無い独自の許可アドレスを追加する場合、こちらにアドレスを記載する。
3117      */
3118     function addLocalContractAllowList(address transferer) external;
3119 
3120     /**
3121      * @dev CALのリストにある独自の許可アドレスを削除する場合、こちらにアドレスを記載する。
3122      */
3123     function removeLocalContractAllowList(address transferer) external;
3124 
3125     /**
3126      * @dev CALのリストにある独自の許可アドレスの一覧を取得する。
3127      */
3128     function getLocalContractAllowList() external view returns(address[] memory);
3129 
3130 }
3131 
3132 pragma solidity >=0.8.0;
3133 
3134 /// @title AntiScam機能付きERC721A
3135 /// @dev Readmeを見てください。
3136 
3137 abstract contract ERC721RestrictApprove is ERC721PsiBurnable, IERC721RestrictApprove {
3138     using EnumerableSet for EnumerableSet.AddressSet;
3139 
3140     IContractAllowListProxy public CAL;
3141     EnumerableSet.AddressSet localAllowedAddresses;
3142 
3143     modifier onlyHolder(uint256 tokenId) {
3144         require(
3145             msg.sender == ownerOf(tokenId),
3146             "RestrictApprove: operation is only holder."
3147         );
3148         _;
3149     }
3150 
3151     /*//////////////////////////////////////////////////////////////
3152     変数
3153     //////////////////////////////////////////////////////////////*/
3154     bool public enableRestrict = true;
3155 
3156     // token lock
3157     mapping(uint256 => uint256) public tokenCALLevel;
3158 
3159     // wallet lock
3160     mapping(address => uint256) public walletCALLevel;
3161 
3162     // contract lock
3163     uint256 public CALLevel = 1;
3164 
3165     /*///////////////////////////////////////////////////////////////
3166     Approve抑制機能ロジック
3167     //////////////////////////////////////////////////////////////*/
3168     function _addLocalContractAllowList(address transferer)
3169         internal
3170         virtual
3171     {
3172         localAllowedAddresses.add(transferer);
3173         emit LocalCalAdded(msg.sender, transferer);
3174     }
3175 
3176     function _removeLocalContractAllowList(address transferer)
3177         internal
3178         virtual
3179     {
3180         localAllowedAddresses.remove(transferer);
3181         emit LocalCalRemoved(msg.sender, transferer);
3182     }
3183 
3184     function _getLocalContractAllowList()
3185         internal
3186         virtual
3187         view
3188         returns(address[] memory)
3189     {
3190         return localAllowedAddresses.values();
3191     }
3192 
3193     function _isLocalAllowed(address transferer)
3194         internal
3195         view
3196         virtual
3197         returns (bool)
3198     {
3199         return localAllowedAddresses.contains(transferer);
3200     }
3201 
3202     function _isAllowed(address transferer)
3203         internal
3204         view
3205         virtual
3206         returns (bool)
3207     {
3208         return _isAllowed(msg.sender, transferer);
3209     }
3210 
3211     function _isAllowed(uint256 tokenId, address transferer)
3212         internal
3213         view
3214         virtual
3215         returns (bool)
3216     {
3217         uint256 level = _getCALLevel(msg.sender, tokenId);
3218         return _isAllowed(transferer, level);
3219     }
3220 
3221     function _isAllowed(address holder, address transferer)
3222         internal
3223         view
3224         virtual
3225         returns (bool)
3226     {
3227         uint256 level = _getCALLevel(holder);
3228         return _isAllowed(transferer, level);
3229     }
3230 
3231     function _isAllowed(address transferer, uint256 level)
3232         internal
3233         view
3234         virtual
3235         returns (bool)
3236     {
3237         if (!enableRestrict) {
3238             return true;
3239         }
3240 
3241         return _isLocalAllowed(transferer) || CAL.isAllowed(transferer, level);
3242     }
3243 
3244     function _getCALLevel(address holder, uint256 tokenId)
3245         internal
3246         view
3247         virtual
3248         returns (uint256)
3249     {
3250         if (tokenCALLevel[tokenId] > 0) {
3251             return tokenCALLevel[tokenId];
3252         }
3253 
3254         return _getCALLevel(holder);
3255     }
3256 
3257     function _getCALLevel(address holder)
3258         internal
3259         view
3260         virtual
3261         returns (uint256)
3262     {
3263         if (walletCALLevel[holder] > 0) {
3264             return walletCALLevel[holder];
3265         }
3266 
3267         return CALLevel;
3268     }
3269 
3270     function _setCAL(address _cal) internal virtual {
3271         CAL = IContractAllowListProxy(_cal);
3272     }
3273 
3274     function _deleteTokenCALLevel(uint256 tokenId) internal virtual {
3275         delete tokenCALLevel[tokenId];
3276     }
3277 
3278     function setTokenCALLevel(uint256 tokenId, uint256 level)
3279         external
3280         virtual
3281         onlyHolder(tokenId)
3282     {
3283         tokenCALLevel[tokenId] = level;
3284     }
3285 
3286     function setWalletCALLevel(uint256 level)
3287         external
3288         virtual
3289     {
3290         walletCALLevel[msg.sender] = level;
3291     }
3292 
3293     /*///////////////////////////////////////////////////////////////
3294                               OVERRIDES
3295     //////////////////////////////////////////////////////////////*/
3296 
3297     function isApprovedForAll(address owner, address operator)
3298         public
3299         view
3300         virtual
3301         override
3302         returns (bool)
3303     {
3304         if (_isAllowed(owner, operator) == false) {
3305             return false;
3306         }
3307         return super.isApprovedForAll(owner, operator);
3308     }
3309 
3310     function setApprovalForAll(address operator, bool approved)
3311         public
3312         virtual
3313         override
3314     {
3315         require(
3316             _isAllowed(operator) || approved == false,
3317             "RestrictApprove: Can not approve locked token"
3318         );
3319         super.setApprovalForAll(operator, approved);
3320     }
3321 
3322     function _beforeApprove(address to, uint256 tokenId)
3323         internal
3324         virtual
3325     {
3326         if (to != address(0)) {
3327             require(_isAllowed(tokenId, to), "RestrictApprove: The contract is not allowed.");
3328         }
3329     }
3330 
3331     function approve(address to, uint256 tokenId)
3332         public
3333         virtual
3334         override
3335     {
3336         _beforeApprove(to, tokenId);
3337         super.approve(to, tokenId);
3338     }
3339 
3340     function _afterTokenTransfers(
3341         address from,
3342         address, /*to*/
3343         uint256 startTokenId,
3344         uint256 /*quantity*/
3345     ) internal virtual override {
3346         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
3347         if (from != address(0)) {
3348             // CALレベルをデフォルトに戻す。
3349             _deleteTokenCALLevel(startTokenId);
3350         }
3351     }
3352 
3353     function supportsInterface(bytes4 interfaceId)
3354         public
3355         view
3356         virtual
3357         override
3358         returns (bool)
3359     {
3360         return
3361             interfaceId == type(IERC721RestrictApprove).interfaceId ||
3362             super.supportsInterface(interfaceId);
3363     }
3364 }
3365 
3366 
3367 pragma solidity ^0.8.7;
3368 /*
3369 ██████╗░░█████╗░███╗░░██╗██╗░░░░░░█████╗░
3370 ██╔══██╗██╔══██╗████╗░██║██║░░░░░██╔══██╗
3371 ██████╔╝███████║██╔██╗██║██║░░░░░██║░░██║
3372 ██╔═══╝░██╔══██║██║╚████║██║░░░░░██║░░██║
3373 ██║░░░░░██║░░██║██║░╚███║███████╗╚█████╔╝
3374 ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚══╝╚══════╝░╚════╝░
3375 -PANLO by STARTJPN-
3376 */
3377 contract Panlo is Ownable, ERC721RestrictApprove, ReentrancyGuard, MerkleProof, ERC2981, DefaultOperatorFilterer,Operable {
3378   //Project Settings
3379   uint256 public wlMintPrice = 0.0 ether;
3380   uint256 public alMintPrice = 0.0 ether;
3381   uint256 public psMintPrice = 0.0 ether;
3382   mapping(uint256 => uint256) public maxMintsPerAL;
3383   uint256 public maxMintsPerPS = 2;
3384   uint256 public maxMintsPerALOT = 1;
3385   uint256 public maxMintsPerPSOT = 1;
3386   uint256 public maxSupply = 10000;
3387   uint256 public mintable = 10000;
3388   uint256 public revealed = 0;
3389   uint256 public nowPhaseAl;
3390   uint256 public nowPhasePs;
3391   uint256 public maxReveal;
3392   uint256 public cntBlock;// = 604800;
3393 
3394   address internal _withdrawWallet;
3395 
3396   //URI
3397   string internal hiddenURI;
3398   string internal _baseTokenURI;
3399   string public _baseExtension = ".json";
3400 
3401   //flags
3402   bool public isAlSaleEnabled;
3403   bool public isPublicSaleEnabled;
3404   bool internal hodlTimSys = false;
3405   bool internal lockBurn = true;
3406 
3407   //mint records.
3408   mapping(uint256 => mapping(address => uint256)) internal _wlMinted;
3409   mapping(uint256 => mapping(address => uint256)) internal _alMinted;
3410   mapping(uint256 => mapping(address => uint256)) internal _psMinted;
3411   mapping(uint256 => uint256) internal _updateAt;
3412   mapping(uint256 => int256) internal _lockTim;
3413   mapping(uint256 => bool) public isWlSaleEnabled;
3414   
3415   constructor (
3416     address _royaltyReceiver,
3417     uint96 _royaltyFraction
3418   ) ERC721Psi ("Panlo by STARTPH","PNL") {
3419     _grantOperatorRole(msg.sender);
3420     _grantOperatorRole(_royaltyReceiver);
3421     _setDefaultRoyalty(_royaltyReceiver,_royaltyFraction);
3422     //CAL initialization
3423     setCALLevel(1);
3424     _setCAL(0xF2A78c73ffBAB6ECc3548Acc54B546ace279312E);//Ethereum mainnet proxy
3425     _addLocalContractAllowList(0x1E0049783F008A0085193E00003D00cd54003c71);//OpenSea
3426     _addLocalContractAllowList(0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be);//Rarible
3427     hiddenURI = "https://startdata.io/PNL/hidden.json";
3428   }
3429   //start from 1.adjust.
3430   function _startTokenId() internal pure virtual override returns (uint256) {
3431         return 1;
3432   }
3433   //set Default Royalty._feeNumerator 500 = 5% Royalty
3434   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external virtual onlyOperator {
3435       _setDefaultRoyalty(_receiver, _feeNumerator);
3436   }
3437   //for ERC2981
3438   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721RestrictApprove, ERC2981) returns (bool) {
3439     return super.supportsInterface(interfaceId);
3440   }
3441   //for ERC2981 Opensea
3442   function contractURI() external view virtual returns (string memory) {
3443         return _formatContractURI();
3444   }
3445   //make contractURI
3446   function _formatContractURI() internal view returns (string memory) {
3447     (address receiver, uint256 royaltyFraction) = royaltyInfo(0,_feeDenominator());//tokenid=0
3448     return string(
3449       abi.encodePacked(
3450         "data:application/json;base64,",
3451         Base64.encode(
3452           bytes(
3453             abi.encodePacked(
3454                 '{"seller_fee_basis_points":', Strings.toString(royaltyFraction),
3455                 ', "fee_recipient":"', Strings.toHexString(uint256(uint160(receiver)), 20), '"}'
3456             )
3457           )
3458         )
3459       )
3460     );
3461   }
3462   //set maxSupply.only owner.
3463   function setMaxSupply(uint256 _maxSupply) external virtual onlyOperator {
3464     require(totalSupply() <= _maxSupply, "Lower than _currentIndex.");
3465     maxSupply = _maxSupply;
3466   }
3467   function setMintable(uint256 _mintable) external virtual onlyOperator {
3468     require(totalSupply() <= _mintable, "Lower than _currentIndex.");
3469     mintable = _mintable;
3470   }
3471     // GET phaseId.
3472   function getPhaseId() external view virtual returns (uint256){
3473     return phaseId;
3474   }
3475     // SET phaseId.
3476   function setPhaseId(uint256 _phaseId) external virtual onlyOperator {
3477     phaseId = _phaseId;
3478   }
3479     // SET phaseId.
3480   function setPhaseIdWithReset(uint256 _phaseId) external virtual onlyOperator {
3481     phaseId = _phaseId;
3482     nowPhaseAl += 1;
3483   }
3484   function setNowPhaseAl(uint256 _nowPhaseAl) external virtual onlyOperator {
3485     nowPhaseAl = _nowPhaseAl;
3486   }
3487   function setNowPhasePs(uint256 _nowPhasePs) external virtual onlyOperator {
3488     nowPhasePs = _nowPhasePs;
3489   }
3490   // SET PRICES.
3491   //WL.Price
3492   function setWlPrice(uint256 newPrice) external virtual onlyOperator {
3493     wlMintPrice = newPrice;
3494   }
3495   //AL.Price
3496   function setAlPrice(uint256 newPrice) external virtual onlyOperator {
3497     alMintPrice = newPrice;
3498   }
3499   //PS.Price
3500   function setPsPrice(uint256 newPrice) external virtual onlyOperator {
3501     psMintPrice = newPrice;
3502   }
3503   //set reveal.only owner.
3504   function setReveal(uint256 newRevealNum) external virtual onlyOperator {
3505     revealed = newRevealNum;
3506   }
3507   //return _isRevealed()
3508   function _isRevealed(uint256 _tokenId) internal view virtual returns (bool){
3509     return _tokenId <= revealed;
3510   }
3511   // GET MINTED COUNT.
3512   function wlMinted(address _address,uint256 _phaseId) external view virtual returns (uint256){
3513     return _wlMinted[_phaseId][_address];
3514   }
3515   function alMinted(address _address) external view virtual returns (uint256){
3516     return _alMinted[nowPhaseAl][_address];
3517   }
3518   function alIdMinted(uint256 _nowPhaseAl,address _address) external view virtual returns (uint256){
3519     return _alMinted[_nowPhaseAl][_address];
3520   }
3521   function psMinted(address _address) external view virtual returns (uint256){
3522     return _psMinted[nowPhasePs][_address];
3523   }
3524   // SET MAX MINTS.
3525   //get.AL.mxmints
3526   function getAlMaxMints() external view virtual returns (uint256){
3527     return maxMintsPerAL[phaseId];
3528   }
3529   //set.AL.mxmints
3530   function setAlMaxMints(uint256 _phaseId,uint256 _max) external virtual onlyOperator {
3531     maxMintsPerAL[_phaseId] = _max;
3532   }
3533   //PS.mxmints
3534   function setPsMaxMints(uint256 _max) external virtual onlyOperator {
3535     maxMintsPerPS = _max;
3536   }
3537   // SET SALES ENABLE.
3538   //WL.SaleEnable
3539   function setWhitelistSaleEnable(uint256 _phaseId,bool bool_) external virtual onlyOperator {
3540     isWlSaleEnabled[_phaseId] = bool_;
3541   }
3542   //AL.SaleEnable
3543   function setAllowlistSaleEnable(bool bool_) external virtual onlyOperator {
3544     isAlSaleEnabled = bool_;
3545   }
3546   //PS.SaleEnable
3547   function setPublicSaleEnable(bool bool_) external virtual onlyOperator {
3548     isPublicSaleEnabled = bool_;
3549   }
3550   // SET MERKLE ROOT.
3551   function setMerkleRootWl(bytes32 merkleRoot_) external virtual onlyOperator {
3552     _setWlMerkleRoot(merkleRoot_);
3553   }
3554 
3555   function setMerkleRootWlWithId(uint256 _phaseId,bytes32 merkleRoot_) external virtual onlyOperator {
3556     _setWlMerkleRootWithId(_phaseId,merkleRoot_);
3557   }
3558 
3559   function setMerkleRootAlWithId(uint256 _phaseId,bytes32 merkleRoot_) external virtual onlyOperator {
3560     _setAlMerkleRootWithId(_phaseId,merkleRoot_);
3561   }
3562   //set HiddenBaseURI.only owner.
3563   function setHiddenURI(string memory uri_) external virtual onlyOperator {
3564     hiddenURI = uri_;
3565   }
3566   //return _currentIndex
3567   function getCurrentIndex() external view virtual returns (uint256){
3568     return _nextTokenId() -1;
3569   }
3570   /** @dev set BaseURI at after reveal. only owner. */
3571   function setBaseURI(string memory uri_) external virtual onlyOperator {
3572     _baseTokenURI = uri_;
3573   }
3574 
3575   function setBaseExtension(string memory _newBaseExtension) external onlyOperator
3576   {
3577     _baseExtension = _newBaseExtension;
3578   }
3579 
3580   /** @dev BaseURI.internal. */
3581   function _currentBaseURI() internal view returns (string memory){
3582     return _baseTokenURI;
3583   }
3584 
3585   function getTokenTim(uint256 _tokenId) external view  virtual returns (uint256) {
3586     require(_exists(_tokenId), "URI query for nonexistent token");
3587     return _updateAt[_tokenId];
3588   }
3589 
3590   function getTokenTimId(uint256 _tokenId) internal view  virtual returns (int256) {
3591     require(_exists(_tokenId), "URI query for nonexistent token");
3592     int256 revealId = (int256(block.timestamp)-int256(_updateAt[_tokenId])) / int256(cntBlock);
3593     if (revealId >= int256(maxReveal)){
3594         revealId = int256(maxReveal);
3595     }
3596     return revealId;
3597   }
3598   /** @dev fixrevId. */
3599   function fixToken(uint256 _tokenId) external virtual {
3600     require(_exists(_tokenId), "URI query for nonexistent token");
3601     require(ownerOf(_tokenId) == msg.sender, "isnt owner token");
3602     if(_isRevealed(_tokenId)){
3603         if(hodlTimSys){
3604             int256 revealId = getTokenTimId(_tokenId);
3605             _lockTim[_tokenId] = revealId;
3606         }
3607     }
3608   }
3609   /** @dev unfixrevId. */
3610   function unfixToken(uint256 _tokenId) external virtual {
3611     require(_exists(_tokenId), "URI query for nonexistent token");
3612     require(ownerOf(_tokenId) == msg.sender, "isnt owner token");
3613     _lockTim[_tokenId] = 0;
3614   }
3615   // SET MAX Rev.
3616   function setmaxReveal(uint256 _max) external virtual onlyOwner {
3617     maxReveal = _max;
3618   }
3619   // SET Cntable.
3620   function setcntBlock(uint256 _cnt) external virtual onlyOwner {
3621     cntBlock = _cnt;
3622   }
3623 
3624   function _beforeTokenTransfers(address from,address to,uint256 startTokenId,uint256 quantity) internal override {
3625     // if(from != address(0)){
3626         _updateAt[startTokenId] = block.timestamp;
3627         uint256 updatedIndex = startTokenId;
3628         uint256 end = updatedIndex + quantity;
3629         do {
3630         _updateAt[updatedIndex++] = block.timestamp;
3631         } while (updatedIndex < end);
3632     // }
3633     super._beforeTokenTransfers(from, to, startTokenId, quantity);
3634   }
3635 
3636   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3637     require(_exists(_tokenId), "URI query for nonexistent token");
3638     if(_isRevealed(_tokenId)){
3639         if(_lockTim[_tokenId] > 0){
3640             return string(abi.encodePacked(_currentBaseURI(), Strings.toString(uint256(_lockTim[_tokenId])) ,"/", Strings.toString((_tokenId)), _baseExtension));
3641         }
3642         if(hodlTimSys){
3643             int256 revealId = getTokenTimId(_tokenId);
3644             return string(abi.encodePacked(_currentBaseURI(), Strings.toString(uint256(revealId)) ,"/", Strings.toString((_tokenId)), _baseExtension));
3645         }
3646         return string(abi.encodePacked(_currentBaseURI(), Strings.toString(_tokenId), _baseExtension));
3647     }
3648     return hiddenURI;
3649   }
3650   /** @dev owner mint.transfer to _address.only owner. */
3651   function ownerMintSafe(uint256 _amount, address _address) external virtual onlyOperator { 
3652     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
3653     _safeMint(_address, _amount);
3654   }
3655 
3656   //WL mint.
3657   function whitelistMint(uint256 _phaseId,uint256 _amount, uint256 wlcount, bytes32[] memory proof_) external payable virtual nonReentrant {
3658     require(isWlSaleEnabled[_phaseId], "whitelistMint is Paused");
3659     require(isWhitelisted(msg.sender,_phaseId, wlcount, proof_), "You are not whitelisted!");
3660     require(wlcount > 0, "You have no WL!");
3661     require(wlcount >= _amount, "whitelistMint: Over max mints per wallet");
3662     require(wlcount >= _wlMinted[_phaseId][msg.sender] + _amount, "You have no whitelistMint left");
3663     require(msg.value == wlMintPrice * _amount, "ETH value is not correct");
3664     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3665     _wlMinted[_phaseId][msg.sender] += _amount;
3666     _safeMint(msg.sender, _amount);
3667   }
3668   
3669     //AL mint.
3670   function allowlistMint(uint256 _amount, bytes32[] memory proof_) external payable virtual nonReentrant {
3671     require(isAlSaleEnabled, "allowlistMint is Paused");
3672     require(isAllowlisted(msg.sender,phaseId, proof_), "You are not whitelisted!");
3673     require(maxMintsPerALOT >= _amount, "allowlistMint: Over max mints per one time");
3674     require(maxMintsPerAL[phaseId] >= _amount, "allowlistMint: Over max mints per wallet");
3675     require(maxMintsPerAL[phaseId] >= _alMinted[nowPhaseAl][msg.sender] + _amount, "You have no whitelistMint left");
3676     require(msg.value == alMintPrice * _amount, "ETH value is not correct");
3677     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3678     _alMinted[nowPhaseAl][msg.sender] += _amount;
3679     _safeMint(msg.sender, _amount);
3680   }
3681 
3682 
3683   /** @dev receive. */
3684   function receiveToDeb() external payable virtual nonReentrant {
3685       require(msg.value > 0, "ETH value is not correct");
3686   }
3687   /** @dev widraw ETH from this contract.only operator. */
3688   function withdraw() external payable virtual onlyOperator nonReentrant{
3689     uint256 _ethBalance = address(this).balance;
3690     bool os;
3691     if(_withdrawWallet != address(0)){//if _withdrawWallet has.
3692         (os, ) = payable(_withdrawWallet).call{value: (_ethBalance)}("");
3693     }else{
3694         (os, ) = payable(owner()).call{value: (_ethBalance)}("");
3695     }
3696     require(os, "Failed to withdraw Ether");
3697   }
3698   //Public mint.
3699   function publicMint(uint256 _amount) external payable virtual nonReentrant {
3700     require(isPublicSaleEnabled, "publicMint is Paused");
3701     require(maxMintsPerPSOT >= _amount, "publicMint: Over max mints per one time");
3702     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
3703     require(maxMintsPerPS >= _psMinted[nowPhasePs][msg.sender] + _amount, "You have no publicMint left");
3704     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
3705     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3706     _psMinted[nowPhasePs][msg.sender] += _amount;
3707     _safeMint(msg.sender, _amount);
3708   }
3709 
3710     //burn
3711     function burn(uint256 tokenId) external virtual {
3712         require(ownerOf(tokenId) == msg.sender, "isnt owner token");
3713         require(lockBurn == false, "not allow");
3714         _burn(tokenId);
3715     }
3716     //LB.SaleEnable
3717     function setLockBurn(bool bool_) external virtual onlyOperator {
3718         lockBurn = bool_;
3719     }
3720 
3721 
3722   //return wallet owned tokenids.
3723   function walletOfOwner(address _address) external view virtual returns (uint256[] memory) {
3724     uint256 ownerTokenCount = balanceOf(_address);
3725     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3726     //search from all tonkenid. so spend high gas values.attention.
3727     uint256 tokenindex = 0;
3728     for (uint256 i = _startTokenId(); i < (_nextTokenId() -1); i++) {
3729       if(_address == this.tryOwnerOf(i)) tokenIds[tokenindex++] = i;
3730     }
3731     return tokenIds;
3732   }
3733 
3734   //try catch vaersion ownerOf. support burned tokenid.
3735   function tryOwnerOf(uint256 tokenId) external view  virtual returns (address) {
3736     try this.ownerOf(tokenId) returns (address _address) {
3737       return(_address);
3738     } catch {
3739         return (address(0));//return 0x0 if error.
3740     }
3741   }
3742 
3743     //OPENSEA.OPERATORFilterer.START
3744     /**
3745      * @notice Set the state of the OpenSea operator filter
3746      * @param value Flag indicating if the operator filter should be applied to transfers and approvals
3747      */
3748     function setOperatorFilteringEnabled(bool value) external onlyOperator {
3749         operatorFilteringEnabled = value;
3750     }
3751 
3752     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3753         super.setApprovalForAll(operator, approved);
3754     }
3755 
3756     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3757         super.approve(operator, tokenId);
3758     }
3759 
3760     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3761         super.transferFrom(from, to, tokenId);
3762     }
3763 
3764     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3765         super.safeTransferFrom(from, to, tokenId);
3766     }
3767 
3768     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3769         public
3770         override
3771         onlyAllowedOperator(from)
3772     {
3773         super.safeTransferFrom(from, to, tokenId, data);
3774     }
3775     //OPENSEA.OPERATORFilterer.END
3776 
3777     /*///////////////////////////////////////////////////////////////
3778                     OVERRIDES ERC721RestrictApprove
3779     //////////////////////////////////////////////////////////////*/
3780     function addLocalContractAllowList(address transferer)
3781         external
3782         override
3783         onlyOperator
3784     {
3785         _addLocalContractAllowList(transferer);
3786     }
3787 
3788     function removeLocalContractAllowList(address transferer)
3789         external
3790         override
3791         onlyOperator
3792     {
3793         _removeLocalContractAllowList(transferer);
3794     }
3795 
3796     function getLocalContractAllowList()
3797         external
3798         override
3799         view
3800         returns(address[] memory)
3801     {
3802         return _getLocalContractAllowList();
3803     }
3804 
3805     function setCALLevel(uint256 level) public override onlyOperator {
3806         CALLevel = level;
3807     }
3808 
3809     function setCAL(address calAddress) external override onlyOperator {
3810         _setCAL(calAddress);
3811     }
3812 
3813     /**
3814         @dev Operable.Role.ADD
3815      */
3816     function grantOperatorRole(address _candidate) external onlyOwner {
3817         _grantOperatorRole(_candidate);
3818     }
3819     /**
3820         @dev Operable.Role.REMOVE
3821      */
3822     function revokeOperatorRole(address _candidate) external onlyOwner {
3823         _revokeOperatorRole(_candidate);
3824     }
3825 
3826 }
3827 //CODE.BY.FRICKLIK