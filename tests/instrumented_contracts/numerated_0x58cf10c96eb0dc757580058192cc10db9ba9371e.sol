1 /**
2  *Submitted for verification at Etherscan.io on 2023-02-13
3 */
4 
5 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
9 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Library for managing
15  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
16  * types.
17  *
18  * Sets have the following properties:
19  *
20  * - Elements are added, removed, and checked for existence in constant time
21  * (O(1)).
22  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
23  *
24  * ```
25  * contract Example {
26  *     // Add the library methods
27  *     using EnumerableSet for EnumerableSet.AddressSet;
28  *
29  *     // Declare a set state variable
30  *     EnumerableSet.AddressSet private mySet;
31  * }
32  * ```
33  *
34  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
35  * and `uint256` (`UintSet`) are supported.
36  *
37  * [WARNING]
38  * ====
39  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
40  * unusable.
41  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
42  *
43  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
44  * array of EnumerableSet.
45  * ====
46  */
47 library EnumerableSet {
48     // To implement this library for multiple types with as little code
49     // repetition as possible, we write it in terms of a generic Set type with
50     // bytes32 values.
51     // The Set implementation uses private functions, and user-facing
52     // implementations (such as AddressSet) are just wrappers around the
53     // underlying Set.
54     // This means that we can only create new EnumerableSets for types that fit
55     // in bytes32.
56 
57     struct Set {
58         // Storage of set values
59         bytes32[] _values;
60         // Position of the value in the `values` array, plus 1 because index 0
61         // means a value is not in the set.
62         mapping(bytes32 => uint256) _indexes;
63     }
64 
65     /**
66      * @dev Add a value to a set. O(1).
67      *
68      * Returns true if the value was added to the set, that is if it was not
69      * already present.
70      */
71     function _add(Set storage set, bytes32 value) private returns (bool) {
72         if (!_contains(set, value)) {
73             set._values.push(value);
74             // The value is stored at length-1, but we add 1 to all indexes
75             // and use 0 as a sentinel value
76             set._indexes[value] = set._values.length;
77             return true;
78         } else {
79             return false;
80         }
81     }
82 
83     /**
84      * @dev Removes a value from a set. O(1).
85      *
86      * Returns true if the value was removed from the set, that is if it was
87      * present.
88      */
89     function _remove(Set storage set, bytes32 value) private returns (bool) {
90         // We read and store the value's index to prevent multiple reads from the same storage slot
91         uint256 valueIndex = set._indexes[value];
92 
93         if (valueIndex != 0) {
94             // Equivalent to contains(set, value)
95             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
96             // the array, and then remove the last element (sometimes called as 'swap and pop').
97             // This modifies the order of the array, as noted in {at}.
98 
99             uint256 toDeleteIndex = valueIndex - 1;
100             uint256 lastIndex = set._values.length - 1;
101 
102             if (lastIndex != toDeleteIndex) {
103                 bytes32 lastValue = set._values[lastIndex];
104 
105                 // Move the last value to the index where the value to delete is
106                 set._values[toDeleteIndex] = lastValue;
107                 // Update the index for the moved value
108                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
109             }
110 
111             // Delete the slot where the moved value was stored
112             set._values.pop();
113 
114             // Delete the index for the deleted slot
115             delete set._indexes[value];
116 
117             return true;
118         } else {
119             return false;
120         }
121     }
122 
123     /**
124      * @dev Returns true if the value is in the set. O(1).
125      */
126     function _contains(Set storage set, bytes32 value) private view returns (bool) {
127         return set._indexes[value] != 0;
128     }
129 
130     /**
131      * @dev Returns the number of values on the set. O(1).
132      */
133     function _length(Set storage set) private view returns (uint256) {
134         return set._values.length;
135     }
136 
137     /**
138      * @dev Returns the value stored at position `index` in the set. O(1).
139      *
140      * Note that there are no guarantees on the ordering of values inside the
141      * array, and it may change when more values are added or removed.
142      *
143      * Requirements:
144      *
145      * - `index` must be strictly less than {length}.
146      */
147     function _at(Set storage set, uint256 index) private view returns (bytes32) {
148         return set._values[index];
149     }
150 
151     /**
152      * @dev Return the entire set in an array
153      *
154      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
155      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
156      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
157      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
158      */
159     function _values(Set storage set) private view returns (bytes32[] memory) {
160         return set._values;
161     }
162 
163     // Bytes32Set
164 
165     struct Bytes32Set {
166         Set _inner;
167     }
168 
169     /**
170      * @dev Add a value to a set. O(1).
171      *
172      * Returns true if the value was added to the set, that is if it was not
173      * already present.
174      */
175     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
176         return _add(set._inner, value);
177     }
178 
179     /**
180      * @dev Removes a value from a set. O(1).
181      *
182      * Returns true if the value was removed from the set, that is if it was
183      * present.
184      */
185     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
186         return _remove(set._inner, value);
187     }
188 
189     /**
190      * @dev Returns true if the value is in the set. O(1).
191      */
192     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
193         return _contains(set._inner, value);
194     }
195 
196     /**
197      * @dev Returns the number of values in the set. O(1).
198      */
199     function length(Bytes32Set storage set) internal view returns (uint256) {
200         return _length(set._inner);
201     }
202 
203     /**
204      * @dev Returns the value stored at position `index` in the set. O(1).
205      *
206      * Note that there are no guarantees on the ordering of values inside the
207      * array, and it may change when more values are added or removed.
208      *
209      * Requirements:
210      *
211      * - `index` must be strictly less than {length}.
212      */
213     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
214         return _at(set._inner, index);
215     }
216 
217     /**
218      * @dev Return the entire set in an array
219      *
220      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
221      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
222      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
223      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
224      */
225     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
226         bytes32[] memory store = _values(set._inner);
227         bytes32[] memory result;
228 
229         /// @solidity memory-safe-assembly
230         assembly {
231             result := store
232         }
233 
234         return result;
235     }
236 
237     // AddressSet
238 
239     struct AddressSet {
240         Set _inner;
241     }
242 
243     /**
244      * @dev Add a value to a set. O(1).
245      *
246      * Returns true if the value was added to the set, that is if it was not
247      * already present.
248      */
249     function add(AddressSet storage set, address value) internal returns (bool) {
250         return _add(set._inner, bytes32(uint256(uint160(value))));
251     }
252 
253     /**
254      * @dev Removes a value from a set. O(1).
255      *
256      * Returns true if the value was removed from the set, that is if it was
257      * present.
258      */
259     function remove(AddressSet storage set, address value) internal returns (bool) {
260         return _remove(set._inner, bytes32(uint256(uint160(value))));
261     }
262 
263     /**
264      * @dev Returns true if the value is in the set. O(1).
265      */
266     function contains(AddressSet storage set, address value) internal view returns (bool) {
267         return _contains(set._inner, bytes32(uint256(uint160(value))));
268     }
269 
270     /**
271      * @dev Returns the number of values in the set. O(1).
272      */
273     function length(AddressSet storage set) internal view returns (uint256) {
274         return _length(set._inner);
275     }
276 
277     /**
278      * @dev Returns the value stored at position `index` in the set. O(1).
279      *
280      * Note that there are no guarantees on the ordering of values inside the
281      * array, and it may change when more values are added or removed.
282      *
283      * Requirements:
284      *
285      * - `index` must be strictly less than {length}.
286      */
287     function at(AddressSet storage set, uint256 index) internal view returns (address) {
288         return address(uint160(uint256(_at(set._inner, index))));
289     }
290 
291     /**
292      * @dev Return the entire set in an array
293      *
294      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
295      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
296      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
297      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
298      */
299     function values(AddressSet storage set) internal view returns (address[] memory) {
300         bytes32[] memory store = _values(set._inner);
301         address[] memory result;
302 
303         /// @solidity memory-safe-assembly
304         assembly {
305             result := store
306         }
307 
308         return result;
309     }
310 
311     // UintSet
312 
313     struct UintSet {
314         Set _inner;
315     }
316 
317     /**
318      * @dev Add a value to a set. O(1).
319      *
320      * Returns true if the value was added to the set, that is if it was not
321      * already present.
322      */
323     function add(UintSet storage set, uint256 value) internal returns (bool) {
324         return _add(set._inner, bytes32(value));
325     }
326 
327     /**
328      * @dev Removes a value from a set. O(1).
329      *
330      * Returns true if the value was removed from the set, that is if it was
331      * present.
332      */
333     function remove(UintSet storage set, uint256 value) internal returns (bool) {
334         return _remove(set._inner, bytes32(value));
335     }
336 
337     /**
338      * @dev Returns true if the value is in the set. O(1).
339      */
340     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
341         return _contains(set._inner, bytes32(value));
342     }
343 
344     /**
345      * @dev Returns the number of values in the set. O(1).
346      */
347     function length(UintSet storage set) internal view returns (uint256) {
348         return _length(set._inner);
349     }
350 
351     /**
352      * @dev Returns the value stored at position `index` in the set. O(1).
353      *
354      * Note that there are no guarantees on the ordering of values inside the
355      * array, and it may change when more values are added or removed.
356      *
357      * Requirements:
358      *
359      * - `index` must be strictly less than {length}.
360      */
361     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
362         return uint256(_at(set._inner, index));
363     }
364 
365     /**
366      * @dev Return the entire set in an array
367      *
368      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
369      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
370      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
371      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
372      */
373     function values(UintSet storage set) internal view returns (uint256[] memory) {
374         bytes32[] memory store = _values(set._inner);
375         uint256[] memory result;
376 
377         /// @solidity memory-safe-assembly
378         assembly {
379             result := store
380         }
381 
382         return result;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/utils/StorageSlot.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev Library for reading and writing primitive types to specific storage slots.
395  *
396  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
397  * This library helps with reading and writing to such slots without the need for inline assembly.
398  *
399  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
400  *
401  * Example usage to set ERC1967 implementation slot:
402  * ```
403  * contract ERC1967 {
404  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
405  *
406  *     function _getImplementation() internal view returns (address) {
407  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
408  *     }
409  *
410  *     function _setImplementation(address newImplementation) internal {
411  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
412  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
413  *     }
414  * }
415  * ```
416  *
417  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
418  */
419 library StorageSlot {
420     struct AddressSlot {
421         address value;
422     }
423 
424     struct BooleanSlot {
425         bool value;
426     }
427 
428     struct Bytes32Slot {
429         bytes32 value;
430     }
431 
432     struct Uint256Slot {
433         uint256 value;
434     }
435 
436     /**
437      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
438      */
439     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
440         /// @solidity memory-safe-assembly
441         assembly {
442             r.slot := slot
443         }
444     }
445 
446     /**
447      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
448      */
449     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
450         /// @solidity memory-safe-assembly
451         assembly {
452             r.slot := slot
453         }
454     }
455 
456     /**
457      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
458      */
459     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
460         /// @solidity memory-safe-assembly
461         assembly {
462             r.slot := slot
463         }
464     }
465 
466     /**
467      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
468      */
469     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
470         /// @solidity memory-safe-assembly
471         assembly {
472             r.slot := slot
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/utils/Address.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
481 
482 pragma solidity ^0.8.1;
483 
484 /**
485  * @dev Collection of functions related to the address type
486  */
487 library Address {
488     /**
489      * @dev Returns true if `account` is a contract.
490      *
491      * [IMPORTANT]
492      * ====
493      * It is unsafe to assume that an address for which this function returns
494      * false is an externally-owned account (EOA) and not a contract.
495      *
496      * Among others, `isContract` will return false for the following
497      * types of addresses:
498      *
499      *  - an externally-owned account
500      *  - a contract in construction
501      *  - an address where a contract will be created
502      *  - an address where a contract lived, but was destroyed
503      * ====
504      *
505      * [IMPORTANT]
506      * ====
507      * You shouldn't rely on `isContract` to protect against flash loan attacks!
508      *
509      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
510      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
511      * constructor.
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // This method relies on extcodesize/address.code.length, which returns 0
516         // for contracts in construction, since the code is only stored at the end
517         // of the constructor execution.
518 
519         return account.code.length > 0;
520     }
521 
522     /**
523      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
524      * `recipient`, forwarding all available gas and reverting on errors.
525      *
526      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
527      * of certain opcodes, possibly making contracts go over the 2300 gas limit
528      * imposed by `transfer`, making them unable to receive funds via
529      * `transfer`. {sendValue} removes this limitation.
530      *
531      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
532      *
533      * IMPORTANT: because control is transferred to `recipient`, care must be
534      * taken to not create reentrancy vulnerabilities. Consider using
535      * {ReentrancyGuard} or the
536      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
537      */
538     function sendValue(address payable recipient, uint256 amount) internal {
539         require(address(this).balance >= amount, "Address: insufficient balance");
540 
541         (bool success, ) = recipient.call{value: amount}("");
542         require(success, "Address: unable to send value, recipient may have reverted");
543     }
544 
545     /**
546      * @dev Performs a Solidity function call using a low level `call`. A
547      * plain `call` is an unsafe replacement for a function call: use this
548      * function instead.
549      *
550      * If `target` reverts with a revert reason, it is bubbled up by this
551      * function (like regular Solidity function calls).
552      *
553      * Returns the raw returned data. To convert to the expected return value,
554      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
555      *
556      * Requirements:
557      *
558      * - `target` must be a contract.
559      * - calling `target` with `data` must not revert.
560      *
561      * _Available since v3.1._
562      */
563     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
564         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
569      * `errorMessage` as a fallback revert reason when `target` reverts.
570      *
571      * _Available since v3.1._
572      */
573     function functionCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, 0, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but also transferring `value` wei to `target`.
584      *
585      * Requirements:
586      *
587      * - the calling contract must have an ETH balance of at least `value`.
588      * - the called Solidity function must be `payable`.
589      *
590      * _Available since v3.1._
591      */
592     function functionCallWithValue(
593         address target,
594         bytes memory data,
595         uint256 value
596     ) internal returns (bytes memory) {
597         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
602      * with `errorMessage` as a fallback revert reason when `target` reverts.
603      *
604      * _Available since v3.1._
605      */
606     function functionCallWithValue(
607         address target,
608         bytes memory data,
609         uint256 value,
610         string memory errorMessage
611     ) internal returns (bytes memory) {
612         require(address(this).balance >= value, "Address: insufficient balance for call");
613         (bool success, bytes memory returndata) = target.call{value: value}(data);
614         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
619      * but performing a static call.
620      *
621      * _Available since v3.3._
622      */
623     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
624         return functionStaticCall(target, data, "Address: low-level static call failed");
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
629      * but performing a static call.
630      *
631      * _Available since v3.3._
632      */
633     function functionStaticCall(
634         address target,
635         bytes memory data,
636         string memory errorMessage
637     ) internal view returns (bytes memory) {
638         (bool success, bytes memory returndata) = target.staticcall(data);
639         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but performing a delegate call.
645      *
646      * _Available since v3.4._
647      */
648     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
649         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
654      * but performing a delegate call.
655      *
656      * _Available since v3.4._
657      */
658     function functionDelegateCall(
659         address target,
660         bytes memory data,
661         string memory errorMessage
662     ) internal returns (bytes memory) {
663         (bool success, bytes memory returndata) = target.delegatecall(data);
664         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
669      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
670      *
671      * _Available since v4.8._
672      */
673     function verifyCallResultFromTarget(
674         address target,
675         bool success,
676         bytes memory returndata,
677         string memory errorMessage
678     ) internal view returns (bytes memory) {
679         if (success) {
680             if (returndata.length == 0) {
681                 // only check isContract if the call was successful and the return data is empty
682                 // otherwise we already know that it was a contract
683                 require(isContract(target), "Address: call to non-contract");
684             }
685             return returndata;
686         } else {
687             _revert(returndata, errorMessage);
688         }
689     }
690 
691     /**
692      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
693      * revert reason or using the provided one.
694      *
695      * _Available since v4.3._
696      */
697     function verifyCallResult(
698         bool success,
699         bytes memory returndata,
700         string memory errorMessage
701     ) internal pure returns (bytes memory) {
702         if (success) {
703             return returndata;
704         } else {
705             _revert(returndata, errorMessage);
706         }
707     }
708 
709     function _revert(bytes memory returndata, string memory errorMessage) private pure {
710         // Look for revert reason and bubble it up if present
711         if (returndata.length > 0) {
712             // The easiest way to bubble the revert reason is using memory via assembly
713             /// @solidity memory-safe-assembly
714             assembly {
715                 let returndata_size := mload(returndata)
716                 revert(add(32, returndata), returndata_size)
717             }
718         } else {
719             revert(errorMessage);
720         }
721     }
722 }
723 
724 // File: @openzeppelin/contracts/utils/math/Math.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 /**
732  * @dev Standard math utilities missing in the Solidity language.
733  */
734 library Math {
735     enum Rounding {
736         Down, // Toward negative infinity
737         Up, // Toward infinity
738         Zero // Toward zero
739     }
740 
741     /**
742      * @dev Returns the largest of two numbers.
743      */
744     function max(uint256 a, uint256 b) internal pure returns (uint256) {
745         return a > b ? a : b;
746     }
747 
748     /**
749      * @dev Returns the smallest of two numbers.
750      */
751     function min(uint256 a, uint256 b) internal pure returns (uint256) {
752         return a < b ? a : b;
753     }
754 
755     /**
756      * @dev Returns the average of two numbers. The result is rounded towards
757      * zero.
758      */
759     function average(uint256 a, uint256 b) internal pure returns (uint256) {
760         // (a + b) / 2 can overflow.
761         return (a & b) + (a ^ b) / 2;
762     }
763 
764     /**
765      * @dev Returns the ceiling of the division of two numbers.
766      *
767      * This differs from standard division with `/` in that it rounds up instead
768      * of rounding down.
769      */
770     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
771         // (a + b - 1) / b can overflow on addition, so we distribute.
772         return a == 0 ? 0 : (a - 1) / b + 1;
773     }
774 
775     /**
776      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
777      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
778      * with further edits by Uniswap Labs also under MIT license.
779      */
780     function mulDiv(
781         uint256 x,
782         uint256 y,
783         uint256 denominator
784     ) internal pure returns (uint256 result) {
785         unchecked {
786             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
787             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
788             // variables such that product = prod1 * 2^256 + prod0.
789             uint256 prod0; // Least significant 256 bits of the product
790             uint256 prod1; // Most significant 256 bits of the product
791             assembly {
792                 let mm := mulmod(x, y, not(0))
793                 prod0 := mul(x, y)
794                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
795             }
796 
797             // Handle non-overflow cases, 256 by 256 division.
798             if (prod1 == 0) {
799                 return prod0 / denominator;
800             }
801 
802             // Make sure the result is less than 2^256. Also prevents denominator == 0.
803             require(denominator > prod1);
804 
805             ///////////////////////////////////////////////
806             // 512 by 256 division.
807             ///////////////////////////////////////////////
808 
809             // Make division exact by subtracting the remainder from [prod1 prod0].
810             uint256 remainder;
811             assembly {
812                 // Compute remainder using mulmod.
813                 remainder := mulmod(x, y, denominator)
814 
815                 // Subtract 256 bit number from 512 bit number.
816                 prod1 := sub(prod1, gt(remainder, prod0))
817                 prod0 := sub(prod0, remainder)
818             }
819 
820             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
821             // See https://cs.stackexchange.com/q/138556/92363.
822 
823             // Does not overflow because the denominator cannot be zero at this stage in the function.
824             uint256 twos = denominator & (~denominator + 1);
825             assembly {
826                 // Divide denominator by twos.
827                 denominator := div(denominator, twos)
828 
829                 // Divide [prod1 prod0] by twos.
830                 prod0 := div(prod0, twos)
831 
832                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
833                 twos := add(div(sub(0, twos), twos), 1)
834             }
835 
836             // Shift in bits from prod1 into prod0.
837             prod0 |= prod1 * twos;
838 
839             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
840             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
841             // four bits. That is, denominator * inv = 1 mod 2^4.
842             uint256 inverse = (3 * denominator) ^ 2;
843 
844             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
845             // in modular arithmetic, doubling the correct bits in each step.
846             inverse *= 2 - denominator * inverse; // inverse mod 2^8
847             inverse *= 2 - denominator * inverse; // inverse mod 2^16
848             inverse *= 2 - denominator * inverse; // inverse mod 2^32
849             inverse *= 2 - denominator * inverse; // inverse mod 2^64
850             inverse *= 2 - denominator * inverse; // inverse mod 2^128
851             inverse *= 2 - denominator * inverse; // inverse mod 2^256
852 
853             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
854             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
855             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
856             // is no longer required.
857             result = prod0 * inverse;
858             return result;
859         }
860     }
861 
862     /**
863      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
864      */
865     function mulDiv(
866         uint256 x,
867         uint256 y,
868         uint256 denominator,
869         Rounding rounding
870     ) internal pure returns (uint256) {
871         uint256 result = mulDiv(x, y, denominator);
872         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
873             result += 1;
874         }
875         return result;
876     }
877 
878     /**
879      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
880      *
881      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
882      */
883     function sqrt(uint256 a) internal pure returns (uint256) {
884         if (a == 0) {
885             return 0;
886         }
887 
888         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
889         //
890         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
891         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
892         //
893         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
894         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
895         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
896         //
897         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
898         uint256 result = 1 << (log2(a) >> 1);
899 
900         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
901         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
902         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
903         // into the expected uint128 result.
904         unchecked {
905             result = (result + a / result) >> 1;
906             result = (result + a / result) >> 1;
907             result = (result + a / result) >> 1;
908             result = (result + a / result) >> 1;
909             result = (result + a / result) >> 1;
910             result = (result + a / result) >> 1;
911             result = (result + a / result) >> 1;
912             return min(result, a / result);
913         }
914     }
915 
916     /**
917      * @notice Calculates sqrt(a), following the selected rounding direction.
918      */
919     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
920         unchecked {
921             uint256 result = sqrt(a);
922             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
923         }
924     }
925 
926     /**
927      * @dev Return the log in base 2, rounded down, of a positive value.
928      * Returns 0 if given 0.
929      */
930     function log2(uint256 value) internal pure returns (uint256) {
931         uint256 result = 0;
932         unchecked {
933             if (value >> 128 > 0) {
934                 value >>= 128;
935                 result += 128;
936             }
937             if (value >> 64 > 0) {
938                 value >>= 64;
939                 result += 64;
940             }
941             if (value >> 32 > 0) {
942                 value >>= 32;
943                 result += 32;
944             }
945             if (value >> 16 > 0) {
946                 value >>= 16;
947                 result += 16;
948             }
949             if (value >> 8 > 0) {
950                 value >>= 8;
951                 result += 8;
952             }
953             if (value >> 4 > 0) {
954                 value >>= 4;
955                 result += 4;
956             }
957             if (value >> 2 > 0) {
958                 value >>= 2;
959                 result += 2;
960             }
961             if (value >> 1 > 0) {
962                 result += 1;
963             }
964         }
965         return result;
966     }
967 
968     /**
969      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
970      * Returns 0 if given 0.
971      */
972     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
973         unchecked {
974             uint256 result = log2(value);
975             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
976         }
977     }
978 
979     /**
980      * @dev Return the log in base 10, rounded down, of a positive value.
981      * Returns 0 if given 0.
982      */
983     function log10(uint256 value) internal pure returns (uint256) {
984         uint256 result = 0;
985         unchecked {
986             if (value >= 10**64) {
987                 value /= 10**64;
988                 result += 64;
989             }
990             if (value >= 10**32) {
991                 value /= 10**32;
992                 result += 32;
993             }
994             if (value >= 10**16) {
995                 value /= 10**16;
996                 result += 16;
997             }
998             if (value >= 10**8) {
999                 value /= 10**8;
1000                 result += 8;
1001             }
1002             if (value >= 10**4) {
1003                 value /= 10**4;
1004                 result += 4;
1005             }
1006             if (value >= 10**2) {
1007                 value /= 10**2;
1008                 result += 2;
1009             }
1010             if (value >= 10**1) {
1011                 result += 1;
1012             }
1013         }
1014         return result;
1015     }
1016 
1017     /**
1018      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1019      * Returns 0 if given 0.
1020      */
1021     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1022         unchecked {
1023             uint256 result = log10(value);
1024             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1025         }
1026     }
1027 
1028     /**
1029      * @dev Return the log in base 256, rounded down, of a positive value.
1030      * Returns 0 if given 0.
1031      *
1032      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1033      */
1034     function log256(uint256 value) internal pure returns (uint256) {
1035         uint256 result = 0;
1036         unchecked {
1037             if (value >> 128 > 0) {
1038                 value >>= 128;
1039                 result += 16;
1040             }
1041             if (value >> 64 > 0) {
1042                 value >>= 64;
1043                 result += 8;
1044             }
1045             if (value >> 32 > 0) {
1046                 value >>= 32;
1047                 result += 4;
1048             }
1049             if (value >> 16 > 0) {
1050                 value >>= 16;
1051                 result += 2;
1052             }
1053             if (value >> 8 > 0) {
1054                 result += 1;
1055             }
1056         }
1057         return result;
1058     }
1059 
1060     /**
1061      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1062      * Returns 0 if given 0.
1063      */
1064     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1065         unchecked {
1066             uint256 result = log256(value);
1067             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1068         }
1069     }
1070 }
1071 
1072 // File: @openzeppelin/contracts/utils/Strings.sol
1073 
1074 
1075 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1076 
1077 pragma solidity ^0.8.0;
1078 
1079 
1080 /**
1081  * @dev String operations.
1082  */
1083 library Strings {
1084     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1085     uint8 private constant _ADDRESS_LENGTH = 20;
1086 
1087     /**
1088      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1089      */
1090     function toString(uint256 value) internal pure returns (string memory) {
1091         unchecked {
1092             uint256 length = Math.log10(value) + 1;
1093             string memory buffer = new string(length);
1094             uint256 ptr;
1095             /// @solidity memory-safe-assembly
1096             assembly {
1097                 ptr := add(buffer, add(32, length))
1098             }
1099             while (true) {
1100                 ptr--;
1101                 /// @solidity memory-safe-assembly
1102                 assembly {
1103                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1104                 }
1105                 value /= 10;
1106                 if (value == 0) break;
1107             }
1108             return buffer;
1109         }
1110     }
1111 
1112     /**
1113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1114      */
1115     function toHexString(uint256 value) internal pure returns (string memory) {
1116         unchecked {
1117             return toHexString(value, Math.log256(value) + 1);
1118         }
1119     }
1120 
1121     /**
1122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1123      */
1124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1125         bytes memory buffer = new bytes(2 * length + 2);
1126         buffer[0] = "0";
1127         buffer[1] = "x";
1128         for (uint256 i = 2 * length + 1; i > 1; --i) {
1129             buffer[i] = _SYMBOLS[value & 0xf];
1130             value >>= 4;
1131         }
1132         require(value == 0, "Strings: hex length insufficient");
1133         return string(buffer);
1134     }
1135 
1136     /**
1137      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1138      */
1139     function toHexString(address addr) internal pure returns (string memory) {
1140         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1141     }
1142 }
1143 
1144 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1145 
1146 
1147 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1148 
1149 pragma solidity ^0.8.0;
1150 
1151 /**
1152  * @title ERC721 token receiver interface
1153  * @dev Interface for any contract that wants to support safeTransfers
1154  * from ERC721 asset contracts.
1155  */
1156 interface IERC721Receiver {
1157     /**
1158      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1159      * by `operator` from `from`, this function is called.
1160      *
1161      * It must return its Solidity selector to confirm the token transfer.
1162      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1163      *
1164      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1165      */
1166     function onERC721Received(
1167         address operator,
1168         address from,
1169         uint256 tokenId,
1170         bytes calldata data
1171     ) external returns (bytes4);
1172 }
1173 
1174 // File: solidity-bits/contracts/Popcount.sol
1175 
1176 
1177 /**
1178    _____       ___     ___ __           ____  _ __      
1179   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1180   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1181  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1182 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1183                            /____/                        
1184 
1185 - npm: https://www.npmjs.com/package/solidity-bits
1186 - github: https://github.com/estarriolvetch/solidity-bits
1187 
1188  */
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 library Popcount {
1193     uint256 private constant m1 = 0x5555555555555555555555555555555555555555555555555555555555555555;
1194     uint256 private constant m2 = 0x3333333333333333333333333333333333333333333333333333333333333333;
1195     uint256 private constant m4 = 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
1196     uint256 private constant h01 = 0x0101010101010101010101010101010101010101010101010101010101010101;
1197 
1198     function popcount256A(uint256 x) internal pure returns (uint256 count) {
1199         unchecked{
1200             for (count=0; x!=0; count++)
1201                 x &= x - 1;
1202         }
1203     }
1204 
1205     function popcount256B(uint256 x) internal pure returns (uint256) {
1206         if (x == type(uint256).max) {
1207             return 256;
1208         }
1209         unchecked {
1210             x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
1211             x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits 
1212             x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits 
1213             x = (x * h01) >> 248;  //returns left 8 bits of x + (x<<8) + (x<<16) + (x<<24) + ... 
1214         }
1215         return x;
1216     }
1217 }
1218 // File: solidity-bits/contracts/BitScan.sol
1219 
1220 
1221 /**
1222    _____       ___     ___ __           ____  _ __      
1223   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1224   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1225  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1226 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1227                            /____/                        
1228 
1229 - npm: https://www.npmjs.com/package/solidity-bits
1230 - github: https://github.com/estarriolvetch/solidity-bits
1231 
1232  */
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 
1237 library BitScan {
1238     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
1239     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
1240 
1241     /**
1242         @dev Isolate the least significant set bit.
1243      */ 
1244     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
1245         require(bb > 0);
1246         unchecked {
1247             return bb & (0 - bb);
1248         }
1249     } 
1250 
1251     /**
1252         @dev Isolate the most significant set bit.
1253      */ 
1254     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
1255         require(bb > 0);
1256         unchecked {
1257             bb |= bb >> 128;
1258             bb |= bb >> 64;
1259             bb |= bb >> 32;
1260             bb |= bb >> 16;
1261             bb |= bb >> 8;
1262             bb |= bb >> 4;
1263             bb |= bb >> 2;
1264             bb |= bb >> 1;
1265             
1266             return (bb >> 1) + 1;
1267         }
1268     } 
1269 
1270     /**
1271         @dev Find the index of the lest significant set bit. (trailing zero count)
1272      */ 
1273     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
1274         unchecked {
1275             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
1276         }   
1277     }
1278 
1279     /**
1280         @dev Find the index of the most significant set bit.
1281      */ 
1282     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
1283         unchecked {
1284             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
1285         }   
1286     }
1287 
1288     function log2(uint256 bb) pure internal returns (uint8) {
1289         unchecked {
1290             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
1291         } 
1292     }
1293 }
1294 
1295 // File: solidity-bits/contracts/BitMaps.sol
1296 
1297 
1298 /**
1299    _____       ___     ___ __           ____  _ __      
1300   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1301   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1302  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1303 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1304                            /____/                        
1305 
1306 - npm: https://www.npmjs.com/package/solidity-bits
1307 - github: https://github.com/estarriolvetch/solidity-bits
1308 
1309  */
1310 pragma solidity ^0.8.0;
1311 
1312 
1313 
1314 /**
1315  * @dev This Library is a modified version of Openzeppelin's BitMaps library with extra features.
1316  *
1317  * 1. Functions of finding the index of the closest set bit from a given index are added.
1318  *    The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
1319  *    The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
1320  * 2. Setting and unsetting the bitmap consecutively.
1321  * 3. Accounting number of set bits within a given range.   
1322  *
1323 */
1324 
1325 /**
1326  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
1327  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
1328  */
1329 
1330 library BitMaps {
1331     using BitScan for uint256;
1332     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
1333     uint256 private constant MASK_FULL = type(uint256).max;
1334 
1335     struct BitMap {
1336         mapping(uint256 => uint256) _data;
1337     }
1338 
1339     /**
1340      * @dev Returns whether the bit at `index` is set.
1341      */
1342     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
1343         uint256 bucket = index >> 8;
1344         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1345         return bitmap._data[bucket] & mask != 0;
1346     }
1347 
1348     /**
1349      * @dev Sets the bit at `index` to the boolean `value`.
1350      */
1351     function setTo(
1352         BitMap storage bitmap,
1353         uint256 index,
1354         bool value
1355     ) internal {
1356         if (value) {
1357             set(bitmap, index);
1358         } else {
1359             unset(bitmap, index);
1360         }
1361     }
1362 
1363     /**
1364      * @dev Sets the bit at `index`.
1365      */
1366     function set(BitMap storage bitmap, uint256 index) internal {
1367         uint256 bucket = index >> 8;
1368         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1369         bitmap._data[bucket] |= mask;
1370     }
1371 
1372     /**
1373      * @dev Unsets the bit at `index`.
1374      */
1375     function unset(BitMap storage bitmap, uint256 index) internal {
1376         uint256 bucket = index >> 8;
1377         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1378         bitmap._data[bucket] &= ~mask;
1379     }
1380 
1381 
1382     /**
1383      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
1384      */    
1385     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
1386         uint256 bucket = startIndex >> 8;
1387 
1388         uint256 bucketStartIndex = (startIndex & 0xff);
1389 
1390         unchecked {
1391             if(bucketStartIndex + amount < 256) {
1392                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
1393             } else {
1394                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
1395                 amount -= (256 - bucketStartIndex);
1396                 bucket++;
1397 
1398                 while(amount > 256) {
1399                     bitmap._data[bucket] = MASK_FULL;
1400                     amount -= 256;
1401                     bucket++;
1402                 }
1403 
1404                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
1405             }
1406         }
1407     }
1408 
1409 
1410     /**
1411      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
1412      */    
1413     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
1414         uint256 bucket = startIndex >> 8;
1415 
1416         uint256 bucketStartIndex = (startIndex & 0xff);
1417 
1418         unchecked {
1419             if(bucketStartIndex + amount < 256) {
1420                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
1421             } else {
1422                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
1423                 amount -= (256 - bucketStartIndex);
1424                 bucket++;
1425 
1426                 while(amount > 256) {
1427                     bitmap._data[bucket] = 0;
1428                     amount -= 256;
1429                     bucket++;
1430                 }
1431 
1432                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
1433             }
1434         }
1435     }
1436 
1437     /**
1438      * @dev Returns number of set bits within a range.
1439      */
1440     function popcountA(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
1441         uint256 bucket = startIndex >> 8;
1442 
1443         uint256 bucketStartIndex = (startIndex & 0xff);
1444 
1445         unchecked {
1446             if(bucketStartIndex + amount < 256) {
1447                 count +=  Popcount.popcount256A(
1448                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
1449                 );
1450             } else {
1451                 count += Popcount.popcount256A(
1452                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
1453                 );
1454                 amount -= (256 - bucketStartIndex);
1455                 bucket++;
1456 
1457                 while(amount > 256) {
1458                     count += Popcount.popcount256A(bitmap._data[bucket]);
1459                     amount -= 256;
1460                     bucket++;
1461                 }
1462                 count += Popcount.popcount256A(
1463                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
1464                 );
1465             }
1466         }
1467     }
1468 
1469     /**
1470      * @dev Returns number of set bits within a range.
1471      */
1472     function popcountB(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
1473         uint256 bucket = startIndex >> 8;
1474 
1475         uint256 bucketStartIndex = (startIndex & 0xff);
1476 
1477         unchecked {
1478             if(bucketStartIndex + amount < 256) {
1479                 count +=  Popcount.popcount256B(
1480                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
1481                 );
1482             } else {
1483                 count += Popcount.popcount256B(
1484                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
1485                 );
1486                 amount -= (256 - bucketStartIndex);
1487                 bucket++;
1488 
1489                 while(amount > 256) {
1490                     count += Popcount.popcount256B(bitmap._data[bucket]);
1491                     amount -= 256;
1492                     bucket++;
1493                 }
1494                 count += Popcount.popcount256B(
1495                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
1496                 );
1497             }
1498         }
1499     }
1500 
1501 
1502     /**
1503      * @dev Find the closest index of the set bit before `index`.
1504      */
1505     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
1506         uint256 bucket = index >> 8;
1507 
1508         // index within the bucket
1509         uint256 bucketIndex = (index & 0xff);
1510 
1511         // load a bitboard from the bitmap.
1512         uint256 bb = bitmap._data[bucket];
1513 
1514         // offset the bitboard to scan from `bucketIndex`.
1515         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
1516         
1517         if(bb > 0) {
1518             unchecked {
1519                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());    
1520             }
1521         } else {
1522             while(true) {
1523                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
1524                 unchecked {
1525                     bucket--;
1526                 }
1527                 // No offset. Always scan from the least significiant bit now.
1528                 bb = bitmap._data[bucket];
1529                 
1530                 if(bb > 0) {
1531                     unchecked {
1532                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
1533                         break;
1534                     }
1535                 } 
1536             }
1537         }
1538     }
1539 
1540     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
1541         return bitmap._data[bucket];
1542     }
1543 }
1544 
1545 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1546 
1547 
1548 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1549 
1550 pragma solidity ^0.8.0;
1551 
1552 /**
1553  * @dev Contract module that helps prevent reentrant calls to a function.
1554  *
1555  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1556  * available, which can be applied to functions to make sure there are no nested
1557  * (reentrant) calls to them.
1558  *
1559  * Note that because there is a single `nonReentrant` guard, functions marked as
1560  * `nonReentrant` may not call one another. This can be worked around by making
1561  * those functions `private`, and then adding `external` `nonReentrant` entry
1562  * points to them.
1563  *
1564  * TIP: If you would like to learn more about reentrancy and alternative ways
1565  * to protect against it, check out our blog post
1566  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1567  */
1568 abstract contract ReentrancyGuard {
1569     // Booleans are more expensive than uint256 or any type that takes up a full
1570     // word because each write operation emits an extra SLOAD to first read the
1571     // slot's contents, replace the bits taken up by the boolean, and then write
1572     // back. This is the compiler's defense against contract upgrades and
1573     // pointer aliasing, and it cannot be disabled.
1574 
1575     // The values being non-zero value makes deployment a bit more expensive,
1576     // but in exchange the refund on every call to nonReentrant will be lower in
1577     // amount. Since refunds are capped to a percentage of the total
1578     // transaction's gas, it is best to keep them low in cases like this one, to
1579     // increase the likelihood of the full refund coming into effect.
1580     uint256 private constant _NOT_ENTERED = 1;
1581     uint256 private constant _ENTERED = 2;
1582 
1583     uint256 private _status;
1584 
1585     constructor() {
1586         _status = _NOT_ENTERED;
1587     }
1588 
1589     /**
1590      * @dev Prevents a contract from calling itself, directly or indirectly.
1591      * Calling a `nonReentrant` function from another `nonReentrant`
1592      * function is not supported. It is possible to prevent this from happening
1593      * by making the `nonReentrant` function external, and making it call a
1594      * `private` function that does the actual work.
1595      */
1596     modifier nonReentrant() {
1597         _nonReentrantBefore();
1598         _;
1599         _nonReentrantAfter();
1600     }
1601 
1602     function _nonReentrantBefore() private {
1603         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1604         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1605 
1606         // Any calls to nonReentrant after this point will fail
1607         _status = _ENTERED;
1608     }
1609 
1610     function _nonReentrantAfter() private {
1611         // By storing the original value once again, a refund is triggered (see
1612         // https://eips.ethereum.org/EIPS/eip-2200)
1613         _status = _NOT_ENTERED;
1614     }
1615 }
1616 
1617 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1618 
1619 
1620 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1621 
1622 pragma solidity ^0.8.0;
1623 
1624 /**
1625  * @dev Interface of the ERC165 standard, as defined in the
1626  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1627  *
1628  * Implementers can declare support of contract interfaces, which can then be
1629  * queried by others ({ERC165Checker}).
1630  *
1631  * For an implementation, see {ERC165}.
1632  */
1633 interface IERC165 {
1634     /**
1635      * @dev Returns true if this contract implements the interface defined by
1636      * `interfaceId`. See the corresponding
1637      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1638      * to learn more about how these ids are created.
1639      *
1640      * This function call must use less than 30 000 gas.
1641      */
1642     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1643 }
1644 
1645 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1646 
1647 
1648 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1649 
1650 pragma solidity ^0.8.0;
1651 
1652 
1653 /**
1654  * @dev Required interface of an ERC721 compliant contract.
1655  */
1656 interface IERC721 is IERC165 {
1657     /**
1658      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1659      */
1660     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1661 
1662     /**
1663      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1664      */
1665     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1666 
1667     /**
1668      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1669      */
1670     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1671 
1672     /**
1673      * @dev Returns the number of tokens in ``owner``'s account.
1674      */
1675     function balanceOf(address owner) external view returns (uint256 balance);
1676 
1677     /**
1678      * @dev Returns the owner of the `tokenId` token.
1679      *
1680      * Requirements:
1681      *
1682      * - `tokenId` must exist.
1683      */
1684     function ownerOf(uint256 tokenId) external view returns (address owner);
1685 
1686     /**
1687      * @dev Safely transfers `tokenId` token from `from` to `to`.
1688      *
1689      * Requirements:
1690      *
1691      * - `from` cannot be the zero address.
1692      * - `to` cannot be the zero address.
1693      * - `tokenId` token must exist and be owned by `from`.
1694      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function safeTransferFrom(
1700         address from,
1701         address to,
1702         uint256 tokenId,
1703         bytes calldata data
1704     ) external;
1705 
1706     /**
1707      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1708      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1709      *
1710      * Requirements:
1711      *
1712      * - `from` cannot be the zero address.
1713      * - `to` cannot be the zero address.
1714      * - `tokenId` token must exist and be owned by `from`.
1715      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1716      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1717      *
1718      * Emits a {Transfer} event.
1719      */
1720     function safeTransferFrom(
1721         address from,
1722         address to,
1723         uint256 tokenId
1724     ) external;
1725 
1726     /**
1727      * @dev Transfers `tokenId` token from `from` to `to`.
1728      *
1729      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1730      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1731      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1732      *
1733      * Requirements:
1734      *
1735      * - `from` cannot be the zero address.
1736      * - `to` cannot be the zero address.
1737      * - `tokenId` token must be owned by `from`.
1738      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1739      *
1740      * Emits a {Transfer} event.
1741      */
1742     function transferFrom(
1743         address from,
1744         address to,
1745         uint256 tokenId
1746     ) external;
1747 
1748     /**
1749      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1750      * The approval is cleared when the token is transferred.
1751      *
1752      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1753      *
1754      * Requirements:
1755      *
1756      * - The caller must own the token or be an approved operator.
1757      * - `tokenId` must exist.
1758      *
1759      * Emits an {Approval} event.
1760      */
1761     function approve(address to, uint256 tokenId) external;
1762 
1763     /**
1764      * @dev Approve or remove `operator` as an operator for the caller.
1765      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1766      *
1767      * Requirements:
1768      *
1769      * - The `operator` cannot be the caller.
1770      *
1771      * Emits an {ApprovalForAll} event.
1772      */
1773     function setApprovalForAll(address operator, bool _approved) external;
1774 
1775     /**
1776      * @dev Returns the account approved for `tokenId` token.
1777      *
1778      * Requirements:
1779      *
1780      * - `tokenId` must exist.
1781      */
1782     function getApproved(uint256 tokenId) external view returns (address operator);
1783 
1784     /**
1785      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1786      *
1787      * See {setApprovalForAll}
1788      */
1789     function isApprovedForAll(address owner, address operator) external view returns (bool);
1790 }
1791 
1792 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1793 
1794 
1795 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1796 
1797 pragma solidity ^0.8.0;
1798 
1799 
1800 /**
1801  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1802  * @dev See https://eips.ethereum.org/EIPS/eip-721
1803  */
1804 interface IERC721Metadata is IERC721 {
1805     /**
1806      * @dev Returns the token collection name.
1807      */
1808     function name() external view returns (string memory);
1809 
1810     /**
1811      * @dev Returns the token collection symbol.
1812      */
1813     function symbol() external view returns (string memory);
1814 
1815     /**
1816      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1817      */
1818     function tokenURI(uint256 tokenId) external view returns (string memory);
1819 }
1820 
1821 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1822 
1823 
1824 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1825 
1826 pragma solidity ^0.8.0;
1827 
1828 
1829 /**
1830  * @dev Implementation of the {IERC165} interface.
1831  *
1832  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1833  * for the additional interface id that will be supported. For example:
1834  *
1835  * ```solidity
1836  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1837  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1838  * }
1839  * ```
1840  *
1841  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1842  */
1843 abstract contract ERC165 is IERC165 {
1844     /**
1845      * @dev See {IERC165-supportsInterface}.
1846      */
1847     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1848         return interfaceId == type(IERC165).interfaceId;
1849     }
1850 }
1851 
1852 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1853 
1854 
1855 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1856 
1857 pragma solidity ^0.8.0;
1858 
1859 
1860 /**
1861  * @dev Interface for the NFT Royalty Standard.
1862  *
1863  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1864  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1865  *
1866  * _Available since v4.5._
1867  */
1868 interface IERC2981 is IERC165 {
1869     /**
1870      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1871      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1872      */
1873     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1874         external
1875         view
1876         returns (address receiver, uint256 royaltyAmount);
1877 }
1878 
1879 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1880 
1881 
1882 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1883 
1884 pragma solidity ^0.8.0;
1885 
1886 
1887 
1888 /**
1889  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1890  *
1891  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1892  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1893  *
1894  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1895  * fee is specified in basis points by default.
1896  *
1897  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1898  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1899  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1900  *
1901  * _Available since v4.5._
1902  */
1903 abstract contract ERC2981 is IERC2981, ERC165 {
1904     struct RoyaltyInfo {
1905         address receiver;
1906         uint96 royaltyFraction;
1907     }
1908 
1909     RoyaltyInfo private _defaultRoyaltyInfo;
1910     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1911 
1912     /**
1913      * @dev See {IERC165-supportsInterface}.
1914      */
1915     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1916         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1917     }
1918 
1919     /**
1920      * @inheritdoc IERC2981
1921      */
1922     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1923         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1924 
1925         if (royalty.receiver == address(0)) {
1926             royalty = _defaultRoyaltyInfo;
1927         }
1928 
1929         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1930 
1931         return (royalty.receiver, royaltyAmount);
1932     }
1933 
1934     /**
1935      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1936      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1937      * override.
1938      */
1939     function _feeDenominator() internal pure virtual returns (uint96) {
1940         return 10000;
1941     }
1942 
1943     /**
1944      * @dev Sets the royalty information that all ids in this contract will default to.
1945      *
1946      * Requirements:
1947      *
1948      * - `receiver` cannot be the zero address.
1949      * - `feeNumerator` cannot be greater than the fee denominator.
1950      */
1951     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1952         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1953         require(receiver != address(0), "ERC2981: invalid receiver");
1954 
1955         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1956     }
1957 
1958     /**
1959      * @dev Removes default royalty information.
1960      */
1961     function _deleteDefaultRoyalty() internal virtual {
1962         delete _defaultRoyaltyInfo;
1963     }
1964 
1965     /**
1966      * @dev Sets the royalty information for a specific token id, overriding the global default.
1967      *
1968      * Requirements:
1969      *
1970      * - `receiver` cannot be the zero address.
1971      * - `feeNumerator` cannot be greater than the fee denominator.
1972      */
1973     function _setTokenRoyalty(
1974         uint256 tokenId,
1975         address receiver,
1976         uint96 feeNumerator
1977     ) internal virtual {
1978         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1979         require(receiver != address(0), "ERC2981: Invalid parameters");
1980 
1981         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1982     }
1983 
1984     /**
1985      * @dev Resets royalty information for the token id back to the global default.
1986      */
1987     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1988         delete _tokenRoyaltyInfo[tokenId];
1989     }
1990 }
1991 
1992 // File: @openzeppelin/contracts/utils/Context.sol
1993 
1994 
1995 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1996 
1997 pragma solidity ^0.8.0;
1998 
1999 /**
2000  * @dev Provides information about the current execution context, including the
2001  * sender of the transaction and its data. While these are generally available
2002  * via msg.sender and msg.data, they should not be accessed in such a direct
2003  * manner, since when dealing with meta-transactions the account sending and
2004  * paying for execution may not be the actual sender (as far as an application
2005  * is concerned).
2006  *
2007  * This contract is only required for intermediate, library-like contracts.
2008  */
2009 abstract contract Context {
2010     function _msgSender() internal view virtual returns (address) {
2011         return msg.sender;
2012     }
2013 
2014     function _msgData() internal view virtual returns (bytes calldata) {
2015         return msg.data;
2016     }
2017 }
2018 
2019 // File: erc721psi/contracts/ERC721Psi.sol
2020 
2021 
2022 /**
2023   ______ _____   _____ ______ ___  __ _  _  _ 
2024  |  ____|  __ \ / ____|____  |__ \/_ | || || |
2025  | |__  | |__) | |        / /   ) || | \| |/ |
2026  |  __| |  _  /| |       / /   / / | |\_   _/ 
2027  | |____| | \ \| |____  / /   / /_ | |  | |   
2028  |______|_|  \_\\_____|/_/   |____||_|  |_|   
2029 
2030  - github: https://github.com/estarriolvetch/ERC721Psi
2031  - npm: https://www.npmjs.com/package/erc721psi
2032                                           
2033  */
2034 
2035 pragma solidity ^0.8.0;
2036 
2037 
2038 
2039 
2040 
2041 
2042 
2043 
2044 
2045 
2046 
2047 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata {
2048     using Address for address;
2049     using Strings for uint256;
2050     using BitMaps for BitMaps.BitMap;
2051 
2052     BitMaps.BitMap private _batchHead;
2053 
2054     string private _name;
2055     string private _symbol;
2056 
2057     // Mapping from token ID to owner address
2058     mapping(uint256 => address) internal _owners;
2059     uint256 private _currentIndex;
2060 
2061     mapping(uint256 => address) private _tokenApprovals;
2062     mapping(address => mapping(address => bool)) private _operatorApprovals;
2063 
2064     /**
2065      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2066      */
2067     constructor(string memory name_, string memory symbol_) {
2068         _name = name_;
2069         _symbol = symbol_;
2070         _currentIndex = _startTokenId();
2071     }
2072 
2073     /**
2074      * @dev Returns the starting token ID.
2075      * To change the starting token ID, please override this function.
2076      */
2077     function _startTokenId() internal pure virtual returns (uint256) {
2078         // It will become modifiable in the future versions
2079         return 0;
2080     }
2081 
2082     /**
2083      * @dev Returns the next token ID to be minted.
2084      */
2085     function _nextTokenId() internal view virtual returns (uint256) {
2086         return _currentIndex;
2087     }
2088 
2089     /**
2090      * @dev Returns the total amount of tokens minted in the contract.
2091      */
2092     function _totalMinted() internal view virtual returns (uint256) {
2093         return _currentIndex - _startTokenId();
2094     }
2095 
2096 
2097     /**
2098      * @dev See {IERC165-supportsInterface}.
2099      */
2100     function supportsInterface(bytes4 interfaceId)
2101         public
2102         view
2103         virtual
2104         override(ERC165, IERC165)
2105         returns (bool)
2106     {
2107         return
2108             interfaceId == type(IERC721).interfaceId ||
2109             interfaceId == type(IERC721Metadata).interfaceId ||
2110             super.supportsInterface(interfaceId);
2111     }
2112 
2113     /**
2114      * @dev See {IERC721-balanceOf}.
2115      */
2116     function balanceOf(address owner) 
2117         public 
2118         view 
2119         virtual 
2120         override 
2121         returns (uint) 
2122     {
2123         require(owner != address(0), "ERC721Psi: balance query for the zero address");
2124 
2125         uint count;
2126         for( uint i = _startTokenId(); i < _nextTokenId(); ++i ){
2127             if(_exists(i)){
2128                 if( owner == ownerOf(i)){
2129                     ++count;
2130                 }
2131             }
2132         }
2133         return count;
2134     }
2135 
2136     /**
2137      * @dev See {IERC721-ownerOf}.
2138      */
2139     function ownerOf(uint256 tokenId)
2140         public
2141         view
2142         virtual
2143         override
2144         returns (address)
2145     {
2146         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
2147         return owner;
2148     }
2149 
2150     function _ownerAndBatchHeadOf(uint256 tokenId) internal view returns (address owner, uint256 tokenIdBatchHead){
2151         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
2152         tokenIdBatchHead = _getBatchHead(tokenId);
2153         owner = _owners[tokenIdBatchHead];
2154     }
2155 
2156     /**
2157      * @dev See {IERC721Metadata-name}.
2158      */
2159     function name() public view virtual override returns (string memory) {
2160         return _name;
2161     }
2162 
2163     /**
2164      * @dev See {IERC721Metadata-symbol}.
2165      */
2166     function symbol() public view virtual override returns (string memory) {
2167         return _symbol;
2168     }
2169 
2170     /**
2171      * @dev See {IERC721Metadata-tokenURI}.
2172      */
2173     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2174         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
2175 
2176         string memory baseURI = _baseURI();
2177         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2178     }
2179 
2180     /**
2181      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2182      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2183      * by default, can be overriden in child contracts.
2184      */
2185     function _baseURI() internal view virtual returns (string memory) {
2186         return "";
2187     }
2188 
2189 
2190     /**
2191      * @dev See {IERC721-approve}.
2192      */
2193     function approve(address to, uint256 tokenId) public virtual override {
2194         address owner = ownerOf(tokenId);
2195         require(to != owner, "ERC721Psi: approval to current owner");
2196 
2197         require(
2198             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2199             "ERC721Psi: approve caller is not owner nor approved for all"
2200         );
2201 
2202         _approve(to, tokenId);
2203     }
2204 
2205     /**
2206      * @dev See {IERC721-getApproved}.
2207      */
2208     function getApproved(uint256 tokenId)
2209         public
2210         view
2211         virtual
2212         override
2213         returns (address)
2214     {
2215         require(
2216             _exists(tokenId),
2217             "ERC721Psi: approved query for nonexistent token"
2218         );
2219 
2220         return _tokenApprovals[tokenId];
2221     }
2222 
2223     /**
2224      * @dev See {IERC721-setApprovalForAll}.
2225      */
2226     function setApprovalForAll(address operator, bool approved)
2227         public
2228         virtual
2229         override
2230     {
2231         require(operator != _msgSender(), "ERC721Psi: approve to caller");
2232 
2233         _operatorApprovals[_msgSender()][operator] = approved;
2234         emit ApprovalForAll(_msgSender(), operator, approved);
2235     }
2236 
2237     /**
2238      * @dev See {IERC721-isApprovedForAll}.
2239      */
2240     function isApprovedForAll(address owner, address operator)
2241         public
2242         view
2243         virtual
2244         override
2245         returns (bool)
2246     {
2247         return _operatorApprovals[owner][operator];
2248     }
2249 
2250     /**
2251      * @dev See {IERC721-transferFrom}.
2252      */
2253     function transferFrom(
2254         address from,
2255         address to,
2256         uint256 tokenId
2257     ) public virtual override {
2258         //solhint-disable-next-line max-line-length
2259         require(
2260             _isApprovedOrOwner(_msgSender(), tokenId),
2261             "ERC721Psi: transfer caller is not owner nor approved"
2262         );
2263 
2264         _transfer(from, to, tokenId);
2265     }
2266 
2267     /**
2268      * @dev See {IERC721-safeTransferFrom}.
2269      */
2270     function safeTransferFrom(
2271         address from,
2272         address to,
2273         uint256 tokenId
2274     ) public virtual override {
2275         safeTransferFrom(from, to, tokenId, "");
2276     }
2277 
2278     /**
2279      * @dev See {IERC721-safeTransferFrom}.
2280      */
2281     function safeTransferFrom(
2282         address from,
2283         address to,
2284         uint256 tokenId,
2285         bytes memory _data
2286     ) public virtual override {
2287         require(
2288             _isApprovedOrOwner(_msgSender(), tokenId),
2289             "ERC721Psi: transfer caller is not owner nor approved"
2290         );
2291         _safeTransfer(from, to, tokenId, _data);
2292     }
2293 
2294     /**
2295      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2296      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2297      *
2298      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2299      *
2300      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2301      * implement alternative mechanisms to perform token transfer, such as signature-based.
2302      *
2303      * Requirements:
2304      *
2305      * - `from` cannot be the zero address.
2306      * - `to` cannot be the zero address.
2307      * - `tokenId` token must exist and be owned by `from`.
2308      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2309      *
2310      * Emits a {Transfer} event.
2311      */
2312     function _safeTransfer(
2313         address from,
2314         address to,
2315         uint256 tokenId,
2316         bytes memory _data
2317     ) internal virtual {
2318         _transfer(from, to, tokenId);
2319         require(
2320             _checkOnERC721Received(from, to, tokenId, 1,_data),
2321             "ERC721Psi: transfer to non ERC721Receiver implementer"
2322         );
2323     }
2324 
2325     /**
2326      * @dev Returns whether `tokenId` exists.
2327      *
2328      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2329      *
2330      * Tokens start existing when they are minted (`_mint`).
2331      */
2332     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2333         return tokenId < _nextTokenId() && _startTokenId() <= tokenId;
2334     }
2335 
2336     /**
2337      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2338      *
2339      * Requirements:
2340      *
2341      * - `tokenId` must exist.
2342      */
2343     function _isApprovedOrOwner(address spender, uint256 tokenId)
2344         internal
2345         view
2346         virtual
2347         returns (bool)
2348     {
2349         require(
2350             _exists(tokenId),
2351             "ERC721Psi: operator query for nonexistent token"
2352         );
2353         address owner = ownerOf(tokenId);
2354         return (spender == owner ||
2355             getApproved(tokenId) == spender ||
2356             isApprovedForAll(owner, spender));
2357     }
2358 
2359     /**
2360      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2361      *
2362      * Requirements:
2363      *
2364      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2365      * - `quantity` must be greater than 0.
2366      *
2367      * Emits a {Transfer} event.
2368      */
2369     function _safeMint(address to, uint256 quantity) internal virtual {
2370         _safeMint(to, quantity, "");
2371     }
2372 
2373     
2374     function _safeMint(
2375         address to,
2376         uint256 quantity,
2377         bytes memory _data
2378     ) internal virtual {
2379         uint256 nextTokenId = _nextTokenId();
2380         _mint(to, quantity);
2381         require(
2382             _checkOnERC721Received(address(0), to, nextTokenId, quantity, _data),
2383             "ERC721Psi: transfer to non ERC721Receiver implementer"
2384         );
2385     }
2386 
2387 
2388     function _mint(
2389         address to,
2390         uint256 quantity
2391     ) internal virtual {
2392         uint256 nextTokenId = _nextTokenId();
2393         
2394         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
2395         require(to != address(0), "ERC721Psi: mint to the zero address");
2396         
2397         _beforeTokenTransfers(address(0), to, nextTokenId, quantity);
2398         _currentIndex += quantity;
2399         _owners[nextTokenId] = to;
2400         _batchHead.set(nextTokenId);
2401         _afterTokenTransfers(address(0), to, nextTokenId, quantity);
2402         
2403         // Emit events
2404         for(uint256 tokenId=nextTokenId; tokenId < nextTokenId + quantity; tokenId++){
2405             emit Transfer(address(0), to, tokenId);
2406         } 
2407     }
2408 
2409 
2410     /**
2411      * @dev Transfers `tokenId` from `from` to `to`.
2412      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2413      *
2414      * Requirements:
2415      *
2416      * - `to` cannot be the zero address.
2417      * - `tokenId` token must be owned by `from`.
2418      *
2419      * Emits a {Transfer} event.
2420      */
2421     function _transfer(
2422         address from,
2423         address to,
2424         uint256 tokenId
2425     ) internal virtual {
2426         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
2427 
2428         require(
2429             owner == from,
2430             "ERC721Psi: transfer of token that is not own"
2431         );
2432         require(to != address(0), "ERC721Psi: transfer to the zero address");
2433 
2434         _beforeTokenTransfers(from, to, tokenId, 1);
2435 
2436         // Clear approvals from the previous owner
2437         _approve(address(0), tokenId);   
2438 
2439         uint256 subsequentTokenId = tokenId + 1;
2440 
2441         if(!_batchHead.get(subsequentTokenId) &&  
2442             subsequentTokenId < _nextTokenId()
2443         ) {
2444             _owners[subsequentTokenId] = from;
2445             _batchHead.set(subsequentTokenId);
2446         }
2447 
2448         _owners[tokenId] = to;
2449         if(tokenId != tokenIdBatchHead) {
2450             _batchHead.set(tokenId);
2451         }
2452 
2453         emit Transfer(from, to, tokenId);
2454 
2455         _afterTokenTransfers(from, to, tokenId, 1);
2456     }
2457 
2458     /**
2459      * @dev Approve `to` to operate on `tokenId`
2460      *
2461      * Emits a {Approval} event.
2462      */
2463     function _approve(address to, uint256 tokenId) internal virtual {
2464         _tokenApprovals[tokenId] = to;
2465         emit Approval(ownerOf(tokenId), to, tokenId);
2466     }
2467 
2468     /**
2469      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2470      * The call is not executed if the target address is not a contract.
2471      *
2472      * @param from address representing the previous owner of the given token ID
2473      * @param to target address that will receive the tokens
2474      * @param startTokenId uint256 the first ID of the tokens to be transferred
2475      * @param quantity uint256 amount of the tokens to be transfered.
2476      * @param _data bytes optional data to send along with the call
2477      * @return r bool whether the call correctly returned the expected magic value
2478      */
2479     function _checkOnERC721Received(
2480         address from,
2481         address to,
2482         uint256 startTokenId,
2483         uint256 quantity,
2484         bytes memory _data
2485     ) private returns (bool r) {
2486         if (to.isContract()) {
2487             r = true;
2488             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
2489                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2490                     r = r && retval == IERC721Receiver.onERC721Received.selector;
2491                 } catch (bytes memory reason) {
2492                     if (reason.length == 0) {
2493                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
2494                     } else {
2495                         assembly {
2496                             revert(add(32, reason), mload(reason))
2497                         }
2498                     }
2499                 }
2500             }
2501             return r;
2502         } else {
2503             return true;
2504         }
2505     }
2506 
2507     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
2508         tokenIdBatchHead = _batchHead.scanForward(tokenId); 
2509     }
2510 
2511 
2512     function totalSupply() public virtual view returns (uint256) {
2513         return _totalMinted();
2514     }
2515 
2516     /**
2517      * @dev Returns an array of token IDs owned by `owner`.
2518      *
2519      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2520      * It is meant to be called off-chain.
2521      *
2522      * This function is compatiable with ERC721AQueryable.
2523      */
2524     function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
2525         unchecked {
2526             uint256 tokenIdsIdx;
2527             uint256 tokenIdsLength = balanceOf(owner);
2528             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2529             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2530                 if (_exists(i)) {
2531                     if (ownerOf(i) == owner) {
2532                         tokenIds[tokenIdsIdx++] = i;
2533                     }
2534                 }
2535             }
2536             return tokenIds;   
2537         }
2538     }
2539 
2540     /**
2541      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2542      *
2543      * startTokenId - the first token id to be transferred
2544      * quantity - the amount to be transferred
2545      *
2546      * Calling conditions:
2547      *
2548      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2549      * transferred to `to`.
2550      * - When `from` is zero, `tokenId` will be minted for `to`.
2551      */
2552     function _beforeTokenTransfers(
2553         address from,
2554         address to,
2555         uint256 startTokenId,
2556         uint256 quantity
2557     ) internal virtual {}
2558 
2559     /**
2560      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2561      * minting.
2562      *
2563      * startTokenId - the first token id to be transferred
2564      * quantity - the amount to be transferred
2565      *
2566      * Calling conditions:
2567      *
2568      * - when `from` and `to` are both non-zero.
2569      * - `from` and `to` are never both zero.
2570      */
2571     function _afterTokenTransfers(
2572         address from,
2573         address to,
2574         uint256 startTokenId,
2575         uint256 quantity
2576     ) internal virtual {}
2577 }
2578 // File: erc721psi/contracts/extension/ERC721PsiBurnable.sol
2579 
2580 
2581 /**
2582   ______ _____   _____ ______ ___  __ _  _  _ 
2583  |  ____|  __ \ / ____|____  |__ \/_ | || || |
2584  | |__  | |__) | |        / /   ) || | \| |/ |
2585  |  __| |  _  /| |       / /   / / | |\_   _/ 
2586  | |____| | \ \| |____  / /   / /_ | |  | |   
2587  |______|_|  \_\\_____|/_/   |____||_|  |_|   
2588                                               
2589                                             
2590  */
2591 pragma solidity ^0.8.0;
2592 
2593 
2594 
2595 
2596 abstract contract ERC721PsiBurnable is ERC721Psi {
2597     using BitMaps for BitMaps.BitMap;
2598     BitMaps.BitMap private _burnedToken;
2599 
2600     /**
2601      * @dev Destroys `tokenId`.
2602      * The approval is cleared when the token is burned.
2603      *
2604      * Requirements:
2605      *
2606      * - `tokenId` must exist.
2607      *
2608      * Emits a {Transfer} event.
2609      */
2610     function _burn(uint256 tokenId) internal virtual {
2611         address from = ownerOf(tokenId);
2612         _beforeTokenTransfers(from, address(0), tokenId, 1);
2613         _burnedToken.set(tokenId);
2614         
2615         emit Transfer(from, address(0), tokenId);
2616 
2617         _afterTokenTransfers(from, address(0), tokenId, 1);
2618     }
2619 
2620     /**
2621      * @dev Returns whether `tokenId` exists.
2622      *
2623      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2624      *
2625      * Tokens start existing when they are minted (`_mint`),
2626      * and stop existing when they are burned (`_burn`).
2627      */
2628     function _exists(uint256 tokenId) internal view override virtual returns (bool){
2629         if(_burnedToken.get(tokenId)) {
2630             return false;
2631         } 
2632         return super._exists(tokenId);
2633     }
2634 
2635     /**
2636      * @dev See {IERC721Enumerable-totalSupply}.
2637      */
2638     function totalSupply() public view virtual override returns (uint256) {
2639         return _totalMinted() - _burned();
2640     }
2641 
2642     /**
2643      * @dev Returns number of token burned.
2644      */
2645     function _burned() internal view returns (uint256 burned){
2646         uint256 startBucket = _startTokenId() >> 8;
2647         uint256 lastBucket = (_nextTokenId() >> 8) + 1;
2648 
2649         for(uint256 i=startBucket; i < lastBucket; i++) {
2650             uint256 bucket = _burnedToken.getBucket(i);
2651             burned += _popcount(bucket);
2652         }
2653     }
2654 
2655     /**
2656      * @dev Returns number of set bits.
2657      */
2658     function _popcount(uint256 x) private pure returns (uint256 count) {
2659         unchecked{
2660             for (count=0; x!=0; count++)
2661                 x &= x - 1;
2662         }
2663     }
2664 }
2665 // File: @openzeppelin/contracts/access/Ownable.sol
2666 
2667 
2668 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2669 
2670 pragma solidity ^0.8.0;
2671 
2672 
2673 /**
2674  * @dev Contract module which provides a basic access control mechanism, where
2675  * there is an account (an owner) that can be granted exclusive access to
2676  * specific functions.
2677  *
2678  * By default, the owner account will be the one that deploys the contract. This
2679  * can later be changed with {transferOwnership}.
2680  *
2681  * This module is used through inheritance. It will make available the modifier
2682  * `onlyOwner`, which can be applied to your functions to restrict their use to
2683  * the owner.
2684  */
2685 abstract contract Ownable is Context {
2686     address private _owner;
2687 
2688     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2689 
2690     /**
2691      * @dev Initializes the contract setting the deployer as the initial owner.
2692      */
2693     constructor() {
2694         _transferOwnership(_msgSender());
2695     }
2696 
2697     /**
2698      * @dev Throws if called by any account other than the owner.
2699      */
2700     modifier onlyOwner() {
2701         _checkOwner();
2702         _;
2703     }
2704 
2705     /**
2706      * @dev Returns the address of the current owner.
2707      */
2708     function owner() public view virtual returns (address) {
2709         return _owner;
2710     }
2711 
2712     /**
2713      * @dev Throws if the sender is not the owner.
2714      */
2715     function _checkOwner() internal view virtual {
2716         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2717     }
2718 
2719     /**
2720      * @dev Leaves the contract without owner. It will not be possible to call
2721      * `onlyOwner` functions anymore. Can only be called by the current owner.
2722      *
2723      * NOTE: Renouncing ownership will leave the contract without an owner,
2724      * thereby removing any functionality that is only available to the owner.
2725      */
2726     function renounceOwnership() public virtual onlyOwner {
2727         _transferOwnership(address(0));
2728     }
2729 
2730     /**
2731      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2732      * Can only be called by the current owner.
2733      */
2734     function transferOwnership(address newOwner) public virtual onlyOwner {
2735         require(newOwner != address(0), "Ownable: new owner is the zero address");
2736         _transferOwnership(newOwner);
2737     }
2738 
2739     /**
2740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2741      * Internal function without access restriction.
2742      */
2743     function _transferOwnership(address newOwner) internal virtual {
2744         address oldOwner = _owner;
2745         _owner = newOwner;
2746         emit OwnershipTransferred(oldOwner, newOwner);
2747     }
2748 }
2749 
2750 // File: EXO/NEW/EXO.sol
2751 
2752 //SPDX-License-Identifier: MIT
2753 pragma solidity >=0.6.0;
2754 
2755 /// @title Base64
2756 /// @author Brecht Devos - <brecht@loopring.org>
2757 /// @notice Provides functions for encoding/decoding base64
2758 library Base64 {
2759     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
2760     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
2761                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
2762                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
2763                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
2764 
2765     function encode(bytes memory data) internal pure returns (string memory) {
2766         if (data.length == 0) return '';
2767 
2768         // load the table into memory
2769         string memory table = TABLE_ENCODE;
2770 
2771         // multiply by 4/3 rounded up
2772         uint256 encodedLen = 4 * ((data.length + 2) / 3);
2773 
2774         // add some extra buffer at the end required for the writing
2775         string memory result = new string(encodedLen + 32);
2776 
2777         assembly {
2778             // set the actual output length
2779             mstore(result, encodedLen)
2780 
2781             // prepare the lookup table
2782             let tablePtr := add(table, 1)
2783 
2784             // input ptr
2785             let dataPtr := data
2786             let endPtr := add(dataPtr, mload(data))
2787 
2788             // result ptr, jump over length
2789             let resultPtr := add(result, 32)
2790 
2791             // run over the input, 3 bytes at a time
2792             for {} lt(dataPtr, endPtr) {}
2793             {
2794                 // read 3 bytes
2795                 dataPtr := add(dataPtr, 3)
2796                 let input := mload(dataPtr)
2797 
2798                 // write 4 characters
2799                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2800                 resultPtr := add(resultPtr, 1)
2801                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2802                 resultPtr := add(resultPtr, 1)
2803                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
2804                 resultPtr := add(resultPtr, 1)
2805                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
2806                 resultPtr := add(resultPtr, 1)
2807             }
2808 
2809             // padding with '='
2810             switch mod(mload(data), 3)
2811             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
2812             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
2813         }
2814 
2815         return result;
2816     }
2817 
2818     function decode(string memory _data) internal pure returns (bytes memory) {
2819         bytes memory data = bytes(_data);
2820 
2821         if (data.length == 0) return new bytes(0);
2822         require(data.length % 4 == 0, "invalid base64 decoder input");
2823 
2824         // load the table into memory
2825         bytes memory table = TABLE_DECODE;
2826 
2827         // every 4 characters represent 3 bytes
2828         uint256 decodedLen = (data.length / 4) * 3;
2829 
2830         // add some extra buffer at the end required for the writing
2831         bytes memory result = new bytes(decodedLen + 32);
2832 
2833         assembly {
2834             // padding with '='
2835             let lastBytes := mload(add(data, mload(data)))
2836             if eq(and(lastBytes, 0xFF), 0x3d) {
2837                 decodedLen := sub(decodedLen, 1)
2838                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
2839                     decodedLen := sub(decodedLen, 1)
2840                 }
2841             }
2842 
2843             // set the actual output length
2844             mstore(result, decodedLen)
2845 
2846             // prepare the lookup table
2847             let tablePtr := add(table, 1)
2848 
2849             // input ptr
2850             let dataPtr := data
2851             let endPtr := add(dataPtr, mload(data))
2852 
2853             // result ptr, jump over length
2854             let resultPtr := add(result, 32)
2855 
2856             // run over the input, 4 characters at a time
2857             for {} lt(dataPtr, endPtr) {}
2858             {
2859                // read 4 characters
2860                dataPtr := add(dataPtr, 4)
2861                let input := mload(dataPtr)
2862 
2863                // write 3 bytes
2864                let output := add(
2865                    add(
2866                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
2867                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
2868                    add(
2869                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
2870                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
2871                     )
2872                 )
2873                 mstore(resultPtr, shl(232, output))
2874                 resultPtr := add(resultPtr, 3)
2875             }
2876         }
2877 
2878         return result;
2879     }
2880 }
2881 
2882 
2883 
2884 
2885 
2886 
2887 pragma solidity ^0.8.7;
2888 
2889 
2890 abstract contract MerkleProof {
2891     bytes32 internal _alMerkleRoot;
2892     bytes32 internal _pbMerkleRoot;
2893     mapping(uint256 => bytes32) internal _wlMerkleRoot;
2894     uint256 public phaseId;
2895 
2896     function _setWlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2897         _wlMerkleRoot[phaseId] = merkleRoot_;
2898     }
2899 
2900     function _setWlMerkleRootWithId(uint256 _phaseId,bytes32 merkleRoot_) internal virtual {
2901         _wlMerkleRoot[_phaseId] = merkleRoot_;
2902     }
2903     function isWhitelisted(address address_, uint256 _phaseId, uint256 wlCount, bytes32[] memory proof_) public view returns (bool) {
2904         bytes32 _leaf = keccak256(abi.encodePacked(address_, wlCount));
2905         for (uint256 i = 0; i < proof_.length; i++) {
2906             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2907         }
2908         return _leaf == _wlMerkleRoot[_phaseId];
2909     }
2910 
2911 
2912 
2913 
2914     function _setAlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2915         _alMerkleRoot = merkleRoot_;
2916     }
2917 
2918     function isAllowlisted(address address_, bytes32[] memory proof_) public view returns (bool) {
2919         bytes32 _leaf = keccak256(abi.encodePacked(address_));
2920         for (uint256 i = 0; i < proof_.length; i++) {
2921             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2922         }
2923         return _leaf == _alMerkleRoot;
2924     }
2925 
2926 
2927     function _setPlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2928         _pbMerkleRoot = merkleRoot_;
2929     }
2930 
2931 
2932     function isPubliclisted(address address_, bytes32[] memory proof_) public view returns (bool) {
2933         bytes32 _leaf = keccak256(abi.encodePacked(address_));
2934         for (uint256 i = 0; i < proof_.length; i++) {
2935             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2936         }
2937         return _leaf == _pbMerkleRoot;
2938     }
2939 
2940 }
2941 
2942 
2943 
2944 pragma solidity ^0.8.9;
2945 abstract contract Operable is Context {
2946     mapping(address => bool) _operators;
2947     modifier onlyOperator() {
2948         _checkOperatorRole(_msgSender());
2949         _;
2950     }
2951     function isOperator(address _operator) public view returns (bool) {
2952         return _operators[_operator];
2953     }
2954     function _grantOperatorRole(address _candidate) internal {
2955         require(
2956             !_operators[_candidate],
2957             string(
2958                 abi.encodePacked(
2959                     "account ",
2960                     Strings.toHexString(uint160(_msgSender()), 20),
2961                     " is already has an operator role"
2962                 )
2963             )
2964         );
2965         _operators[_candidate] = true;
2966     }
2967     function _revokeOperatorRole(address _candidate) internal {
2968         _checkOperatorRole(_candidate);
2969         delete _operators[_candidate];
2970     }
2971     function _checkOperatorRole(address _operator) internal view {
2972         require(
2973             _operators[_operator],
2974             string(
2975                 abi.encodePacked(
2976                     "account ",
2977                     Strings.toHexString(uint160(_msgSender()), 20),
2978                     " is not an operator"
2979                 )
2980             )
2981         );
2982     }
2983 }
2984 
2985 pragma solidity ^0.8.13;
2986 
2987 interface IOperatorFilterRegistry {
2988     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2989     function register(address registrant) external;
2990     function registerAndSubscribe(address registrant, address subscription) external;
2991     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2992     function unregister(address addr) external;
2993     function updateOperator(address registrant, address operator, bool filtered) external;
2994     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2995     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2996     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2997     function subscribe(address registrant, address registrantToSubscribe) external;
2998     function unsubscribe(address registrant, bool copyExistingEntries) external;
2999     function subscriptionOf(address addr) external returns (address registrant);
3000     function subscribers(address registrant) external returns (address[] memory);
3001     function subscriberAt(address registrant, uint256 index) external returns (address);
3002     function copyEntriesOf(address registrant, address registrantToCopy) external;
3003     function isOperatorFiltered(address registrant, address operator) external returns (bool);
3004     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
3005     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
3006     function filteredOperators(address addr) external returns (address[] memory);
3007     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
3008     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
3009     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
3010     function isRegistered(address addr) external returns (bool);
3011     function codeHashOf(address addr) external returns (bytes32);
3012 }
3013 
3014 pragma solidity ^0.8.13;
3015 
3016 
3017 /**
3018  * @title  OperatorFilterer
3019  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3020  *         registrant's entries in the OperatorFilterRegistry.
3021  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3022  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3023  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3024  */
3025 abstract contract OperatorFilterer {
3026     error OperatorNotAllowed(address operator);
3027     bool public operatorFilteringEnabled = true;
3028 
3029     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3030         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3031 
3032     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3033         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3034         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3035         // order for the modifier to filter addresses.
3036         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3037             if (subscribe) {
3038                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
3039             } else {
3040                 if (subscriptionOrRegistrantToCopy != address(0)) {
3041                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
3042                 } else {
3043                     OPERATOR_FILTER_REGISTRY.register(address(this));
3044                 }
3045             }
3046         }
3047     }
3048 
3049     modifier onlyAllowedOperator(address from) virtual {
3050         // Check registry code length to facilitate testing in environments without a deployed registry.
3051         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
3052             // Allow spending tokens from addresses with balance
3053             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3054             // from an EOA.
3055             if (from == msg.sender) {
3056                 _;
3057                 return;
3058             }
3059             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
3060                 revert OperatorNotAllowed(msg.sender);
3061             }
3062         }
3063         _;
3064     }
3065 
3066     modifier onlyAllowedOperatorApproval(address operator) virtual {
3067         // Check registry code length to facilitate testing in environments without a deployed registry.
3068         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
3069             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
3070                 revert OperatorNotAllowed(operator);
3071             }
3072         }
3073         _;
3074     }
3075 }
3076 
3077 
3078 pragma solidity ^0.8.13;
3079 /**
3080  * @title  DefaultOperatorFilterer
3081  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3082  */
3083 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3084     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3085 
3086     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3087 }
3088 
3089 
3090 
3091 pragma solidity ^0.8.7;
3092 /*
3093 ╭━━━╮╭╮╱╱╱╱╱╭╮╭╮╱╱╱╱╱╱╱╱╱╱╭╮
3094 ┃╭━╮┣╯╰╮╱╱╱╭╯╰┫┃╱╱╱╱╱╱╱╱╱╱┃┃
3095 ┃╰━━╋╮╭╋━━┳┻╮╭┫┃╱╱╭━━┳━╮╭━╯┃
3096 ╰━━╮┃┃┃┃╭╮┃╭┫┃┃┃╱╭┫╭╮┃╭╮┫╭╮┃
3097 ┃╰━╯┃┃╰┫╭╮┃┃┃╰┫╰━╯┃╭╮┃┃┃┃╰╯┃
3098 ╰━━━╯╰━┻╯╰┻╯╰━┻━━━┻╯╰┻╯╰┻━━╯
3099 ╭━━━╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮
3100 ┃╭━╮┃╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╯╰╮
3101 ┃╰━╯┣━━┳━━┳━━┳━┳╮╭┳━┻╮╭╋┳━━┳━╮
3102 ┃╭╮╭┫┃━┫━━┫┃━┫╭┫╰╯┃╭╮┃┃┣┫╭╮┃╭╮╮
3103 ┃┃┃╰┫┃━╋━━┃┃━┫┃╰╮╭┫╭╮┃╰┫┃╰╯┃┃┃┃
3104 ╰╯╰━┻━━┻━━┻━━┻╯╱╰╯╰╯╰┻━┻┻━━┻╯╰╯
3105 ╭━━━╮╭━━╮╱╭━━━━╮
3106 ┃╭━╮┃┃╭╮┃╱┃╭╮╭╮┃
3107 ┃╰━━╮┃╰╯╰╮╰╯┃┃╰╯
3108 ╰━━╮┃┃╭━╮┃╱╱┃┃
3109 ┃╰━╯┃┃╰━╯┃╱╱┃┃
3110 ╰━━━╯╰━━━╯╱╱╰╯
3111 //LAND Reservation SBT-
3112 */
3113 contract ALNDR is Ownable, ERC721PsiBurnable, ReentrancyGuard, MerkleProof, ERC2981, DefaultOperatorFilterer,Operable {
3114   //Project Settings
3115   uint256 public wlMintPrice = 0.1 ether;
3116   uint256 public alMintPrice = 0.1 ether;
3117   uint256 public psMintPrice = 0.1 ether;
3118   uint256 public maxMintsPerWL = 1;
3119   uint256 public maxMintsPerAL = 1;
3120   uint256 public maxMintsPerPS = 1;
3121   uint256 public maxMintsPerWLOT = 1;
3122   uint256 public maxMintsPerALOT = 1;
3123   uint256 public maxMintsPerPSOT = 1;
3124   uint256 public maxSupply;
3125   uint256 public mintable = 1000;
3126   uint256 public revealed = 0;
3127   uint256 public nowPhaseWl;
3128   uint256 public nowPhaseAl;
3129   uint256 public nowPhasePs;
3130 
3131   address public deployer;
3132   address internal _withdrawWallet;
3133   address internal _aa;
3134   address internal _bb;
3135   address internal _cc;
3136   address internal _dd;
3137   address internal _ee;
3138   address internal _ff;
3139 
3140   uint256 internal _aaPerc;
3141   uint256 internal _bbPerc;
3142   uint256 internal _ccPerc;
3143   uint256 internal _ddPerc;
3144   uint256 internal _eePerc;
3145   uint256 internal _ffPerc;
3146 
3147   //URI
3148   string internal hiddenURI;
3149   string internal _baseTokenURI;
3150   string public _baseExtension = ".json";
3151 
3152   //flags
3153   mapping(uint256 => bool) public isWlSaleEnabled;
3154   bool public isAlSaleEnabled;
3155   bool public isPublicSaleEnabled;
3156   bool public isPublicSaleMPEnabled;
3157   bool public sbtFlag = true;
3158   bool internal lockBurn = true;
3159   //mint records.
3160   mapping(uint256 => mapping(address => uint256)) internal _wlMinted;
3161   mapping(uint256 => mapping(address => uint256)) internal _alMinted;
3162   mapping(uint256 => mapping(address => uint256)) internal _psMinted;
3163   mapping(address => bool) bondedAddress;
3164 
3165   constructor (
3166     address _founder
3167   ) ERC721Psi ("LAND Reservation SBT","LNDR") {
3168     deployer = msg.sender;
3169     _grantOperatorRole(msg.sender);
3170     _grantOperatorRole(_founder);
3171     _withdrawWallet = _founder;
3172     _wlMerkleRoot[0] = 0x93913cd5385c3edccaf0ec6ce76a475b134880fb711a1825c8ef12651ce2b410;
3173     _wlMerkleRoot[1] = 0x5dc17beb5247ca0e306fb0af1fd9fbc6103b322eaf9c922f2716f346e5ddfa57;
3174 
3175   }
3176   //start from 1.adjust.
3177   function _startTokenId() internal pure virtual override returns (uint256) {
3178         return 1;
3179   }
3180   //set Default Royalty._feeNumerator 500 = 5% Royalty
3181   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external virtual onlyOperator {
3182       _setDefaultRoyalty(_receiver, _feeNumerator);
3183   }
3184   //for ERC2981
3185   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Psi, ERC2981) returns (bool) {
3186     return super.supportsInterface(interfaceId);
3187   }
3188   //for ERC2981 Opensea
3189   function contractURI() external view virtual returns (string memory) {
3190         return _formatContractURI();
3191   }
3192   //make contractURI
3193   function _formatContractURI() internal view returns (string memory) {
3194     (address receiver, uint256 royaltyFraction) = royaltyInfo(0,_feeDenominator());//tokenid=0
3195     return string(
3196       abi.encodePacked(
3197         "data:application/json;base64,",
3198         Base64.encode(
3199           bytes(
3200             abi.encodePacked(
3201                 '{"seller_fee_basis_points":', Strings.toString(royaltyFraction),
3202                 ', "fee_recipient":"', Strings.toHexString(uint256(uint160(receiver)), 20), '"}'
3203             )
3204           )
3205         )
3206       )
3207     );
3208   }
3209   /**
3210     @dev set aa's wallet and fraction.withdraw to this wallet.only operator.
3211     */
3212   function setWallet__aa(address _owner,uint256 _perc) external virtual onlyOperator {
3213     _aa = _owner;
3214     _aaPerc = _perc;
3215   }
3216 
3217   /**
3218     @dev set bb's wallet and fraction.withdraw to this wallet.only operator.
3219     */
3220   function setWallet__bb(address _owner,uint256 _perc) external virtual onlyOperator {
3221     _bb = _owner;
3222     _bbPerc = _perc;
3223   }
3224 
3225   /**
3226     @dev set cc's wallet and fraction.withdraw to this wallet.only operator.
3227     */
3228   function setWallet__cc(address _owner,uint256 _perc) external virtual onlyOperator {
3229     _cc = _owner;
3230     _ccPerc = _perc;
3231   }
3232 
3233   /**
3234     @dev set dd's wallet and fraction.withdraw to this wallet.only operator.
3235     */
3236   function setWallet__dd(address _owner,uint256 _perc) external virtual onlyOperator {
3237     _dd = _owner;
3238     _ddPerc = _perc;
3239   }
3240 
3241   /**
3242     @dev set ee's wallet and fraction.withdraw to this wallet.only operator.
3243     */
3244   function setWallet__ee(address _owner,uint256 _perc) external virtual onlyOperator {
3245     _ee = _owner;
3246     _eePerc = _perc;
3247   }
3248 
3249   /**
3250     @dev set ff's wallet and fraction.withdraw to this wallet.only operator.
3251     */
3252   function setWallet__ff(address _owner,uint256 _perc) external virtual onlyOperator {
3253     _ff = _owner;
3254     _ffPerc = _perc;
3255   }
3256 
3257 
3258   function setDeployer(address _deployer) external virtual onlyOperator {
3259     deployer = _deployer;
3260   }
3261   function locked(address to) external view returns (bool) {
3262     return bondedAddress[to];
3263   }
3264 
3265   function bound(address to, bool flag) public onlyOperator {
3266       bondedAddress[to] = flag;
3267   }
3268 
3269   //set maxSupply.only owner.
3270   function setMaxSupply(uint256 _maxSupply) external virtual onlyOperator {
3271     require(totalSupply() <= _maxSupply, "Lower than _currentIndex.");
3272     maxSupply = _maxSupply;
3273   }
3274   function setMintable(uint256 _mintable) external virtual onlyOperator {
3275     require(totalSupply() <= _mintable, "Lower than _currentIndex.");
3276     mintable = _mintable;
3277   }
3278   //now.phase
3279   function setNowPhase(uint256 _nowPhase) external virtual onlyOperator {
3280     nowPhaseWl = _nowPhase;
3281     nowPhaseAl = _nowPhase;
3282     nowPhasePs = _nowPhase;
3283   }
3284   function setNowPhaseWl(uint256 _nowPhaseWl) external virtual onlyOperator {
3285     nowPhaseWl = _nowPhaseWl;
3286   }
3287   function setNowPhaseAl(uint256 _nowPhaseAl) external virtual onlyOperator {
3288     nowPhaseAl = _nowPhaseAl;
3289   }
3290   function setNowPhasePs(uint256 _nowPhasePs) external virtual onlyOperator {
3291     nowPhasePs = _nowPhasePs;
3292   }
3293   // SET PRICES.
3294   //WL.Price
3295   function setWlPrice(uint256 newPrice) external virtual onlyOperator {
3296     wlMintPrice = newPrice;
3297   }
3298   //AL.Price
3299   function setAlPrice(uint256 newPrice) external virtual onlyOperator {
3300     alMintPrice = newPrice;
3301   }
3302   //PS.Price
3303   function setPsPrice(uint256 newPrice) external virtual onlyOperator {
3304     psMintPrice = newPrice;
3305   }
3306 
3307   //set reveal.only owner.
3308   function setReveal(uint256 newRevealNum) external virtual onlyOperator {
3309     revealed = newRevealNum;
3310   }
3311   //return _isRevealed()
3312   function _isRevealed(uint256 _tokenId) internal view virtual returns (bool){
3313     return _tokenId <= revealed;
3314   }
3315   // GET MINTED COUNT.
3316   function wlMinted(address _address) external view virtual returns (uint256){
3317     return _wlMinted[nowPhaseWl][_address];
3318   }
3319   function alMinted(address _address) external view virtual returns (uint256){
3320     return _alMinted[nowPhaseAl][_address];
3321   }
3322   function psMinted(address _address) external view virtual returns (uint256){
3323     return _psMinted[nowPhasePs][_address];
3324   }
3325 
3326   // GET MINTED COUNT　FROM Phase.
3327   function wlMinted(address _address,uint256 _phaseNum) external view virtual returns (uint256){
3328     return _wlMinted[_phaseNum][_address];
3329   }
3330   function alMinted(address _address,uint256 _phaseNum) external view virtual returns (uint256){
3331     return _alMinted[_phaseNum][_address];
3332   }
3333   function psMinted(address _address,uint256 _phaseNum) external view virtual returns (uint256){
3334     return _psMinted[_phaseNum][_address];
3335   }
3336 
3337   // SET MAX MINTS.
3338   //WL.mxmints
3339   function setWlMaxMints(uint256 _max) external virtual onlyOperator {
3340     maxMintsPerWL = _max;
3341   }
3342   //AL.mxmints
3343   function setAlMaxMints(uint256 _max) external virtual onlyOperator {
3344     maxMintsPerAL = _max;
3345   }
3346   //PS.mxmints
3347   function setPsMaxMints(uint256 _max) external virtual onlyOperator {
3348     maxMintsPerPS = _max;
3349   }
3350 
3351   // SET SALES ENABLE.
3352   //WL.SaleEnable
3353   function setWhitelistSaleEnable(uint256 _phaseId,bool bool_) external virtual onlyOperator {
3354     isWlSaleEnabled[_phaseId] = bool_;
3355   }
3356   //AL.SaleEnable
3357   function setAllowlistSaleEnable(bool bool_) external virtual onlyOperator {
3358     isAlSaleEnabled = bool_;
3359   }
3360   //PS.SaleEnable
3361   function setPublicSaleEnable(bool bool_) external virtual onlyOperator {
3362     isPublicSaleEnabled = bool_;
3363   }
3364   //PSMP.SaleEnable
3365   function setPublicSaleMPEnable(bool bool_) external virtual onlyOperator {
3366     isPublicSaleMPEnabled = bool_;
3367   }
3368   //sbtFlag
3369   function setSbtFlag(bool bool_) external virtual onlyOperator {
3370     sbtFlag = bool_;
3371   }
3372 
3373   // SET MERKLE ROOT.
3374   function setMerkleRootWl(bytes32 merkleRoot_) external virtual onlyOperator {
3375     _setWlMerkleRoot(merkleRoot_);
3376   }
3377   function setMerkleRootWlWithId(uint256 _phaseId,bytes32 merkleRoot_) external virtual onlyOperator {
3378     _setWlMerkleRootWithId(_phaseId,merkleRoot_);
3379   }
3380 
3381   function setMerkleRootAl(bytes32 merkleRoot_) external virtual onlyOperator {
3382     _setAlMerkleRoot(merkleRoot_);
3383   }
3384   function setMerkleRootPl(bytes32 merkleRoot_) external virtual onlyOperator {
3385     _setPlMerkleRoot(merkleRoot_);
3386   }
3387 
3388   //set HiddenBaseURI.only owner.
3389   function setHiddenURI(string memory uri_) external virtual onlyOperator {
3390     hiddenURI = uri_;
3391   }
3392 
3393   //return _currentIndex
3394   function getCurrentIndex() external view virtual returns (uint256){
3395     return _nextTokenId() -1;
3396   }
3397 
3398   //set BaseURI at after reveal. only owner.
3399   function setBaseURI(string memory uri_) external virtual onlyOperator {
3400     _baseTokenURI = uri_;
3401   }
3402 
3403 
3404   function setBaseExtension(string memory _newBaseExtension) external onlyOperator
3405   {
3406     _baseExtension = _newBaseExtension;
3407   }
3408 
3409   //retuen BaseURI.internal.
3410   function _currentBaseURI() internal view returns (string memory){
3411     return _baseTokenURI;
3412   }
3413 
3414 
3415   
3416   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3417     require(_exists(_tokenId), "URI query for nonexistent token");
3418     if(_isRevealed(_tokenId)){
3419         return string(abi.encodePacked(_currentBaseURI(), Strings.toString(_tokenId), _baseExtension));
3420     }
3421     return hiddenURI;
3422   }
3423 
3424 
3425   //owner mint.transfer to _address.only owner.
3426   function ownerMint(uint256 _amount, address _address) external virtual onlyOperator { 
3427     require((_amount + totalSupply()) <= (maxSupply) || maxSupply == 0, "No more NFTs");
3428     _safeMint(_address, _amount);
3429   }
3430 
3431 
3432   //WL mint.
3433   function whitelistMint(uint256 _phaseId,uint256 _amount, uint256 wlcount, bytes32[] memory proof_) external payable virtual nonReentrant {
3434     require(isWlSaleEnabled[_phaseId], "whitelistMint is Paused");
3435     require(isWhitelisted(msg.sender,_phaseId, wlcount, proof_), "You are not whitelisted!");
3436     require(wlcount > 0, "You have no WL!");
3437     require(wlcount >= _amount, "whitelistMint: Over max mints per wallet");
3438     require(wlcount >= _wlMinted[_phaseId][msg.sender] + _amount, "You have no whitelistMint left");
3439     require(msg.value == wlMintPrice * _amount, "ETH value is not correct");
3440     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3441     _wlMinted[_phaseId][msg.sender] += _amount;
3442     _safeMint(msg.sender, _amount);
3443   }
3444     
3445     //AL mint.
3446   function allowlistMint(uint256 _amount, bytes32[] memory proof_) external payable virtual nonReentrant {
3447     require(isAlSaleEnabled, "allowlistMint is Paused");
3448     require(isAllowlisted(msg.sender, proof_), "You are not whitelisted!");
3449     require(maxMintsPerALOT >= _amount, "allowlistMint: Over max mints per one time");
3450     require(maxMintsPerAL >= _amount, "allowlistMint: Over max mints per wallet");
3451     require(maxMintsPerAL >= _alMinted[nowPhaseAl][msg.sender] + _amount, "You have no whitelistMint left");
3452     require(msg.value == alMintPrice * _amount, "ETH value is not correct");
3453     require((_amount + totalSupply()) <= (mintable) || mintable == 0, "No more NFTs");
3454     require((_amount + totalSupply()) <= (maxSupply) || maxSupply == 0, "No more NFTs");
3455     _alMinted[nowPhaseAl][msg.sender] += _amount;
3456     _safeMint(msg.sender, _amount);
3457   }
3458 
3459   //Public mint.
3460   function publicMint(uint256 _amount) external payable virtual nonReentrant {
3461     require(isPublicSaleEnabled, "publicMint is Paused");
3462     require(maxMintsPerPSOT >= _amount, "publicMint: Over max mints per one time");
3463     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
3464     require(maxMintsPerPS >= _psMinted[nowPhasePs][msg.sender] + _amount, "You have no publicMint left");
3465     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
3466     require((_amount + totalSupply()) <= (mintable) || mintable == 0, "No more NFTs");
3467     require((_amount + totalSupply()) <= (maxSupply) || maxSupply == 0, "No more NFTs");
3468     _psMinted[nowPhasePs][msg.sender] += _amount;
3469     _safeMint(msg.sender, _amount);
3470   }
3471 
3472   //Public mint.
3473   function publicMintMP(uint256 _amount, bytes32[] memory proof_) external payable virtual nonReentrant {
3474     require(isPublicSaleMPEnabled, "publicMint is Paused");
3475     require(isPubliclisted(msg.sender, proof_), "You are not whitelisted!");
3476     require(maxMintsPerPSOT >= _amount, "publicMint: Over max mints per one time");
3477     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
3478     require(maxMintsPerPS >= _psMinted[nowPhasePs][msg.sender] + _amount, "You have no publicMint left");
3479     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
3480     require((_amount + totalSupply()) <= (mintable) || mintable == 0, "No more NFTs");
3481     require((_amount + totalSupply()) <= (maxSupply) || maxSupply == 0, "No more NFTs");
3482     _psMinted[nowPhasePs][msg.sender] += _amount;
3483     _safeMint(msg.sender, _amount);
3484   }
3485 
3486     //burn
3487     function burn(uint256 tokenId) external virtual {
3488         require(ownerOf(tokenId) == msg.sender, "isnt owner token");
3489         require(lockBurn == false, "not allow");
3490         _burn(tokenId);
3491     }
3492     //LB.SaleEnable
3493     function setLockBurn(bool bool_) external virtual onlyOperator {
3494         lockBurn = bool_;
3495     }
3496   //receive.
3497   function receiveToDeb() external payable virtual nonReentrant {
3498       require(msg.value > 0, "ETH value is not correct");
3499   }
3500 
3501   /**
3502     @dev widraw ETH from this contract.only operator. 
3503     */
3504   function withdraw() external payable virtual onlyOperator nonReentrant{
3505     require((_aa != address(0) && _aaPerc != 0) || _aa == address(0),"please set withdraw Address_aa and percentage.");
3506     require((_bb != address(0) && _bbPerc != 0) || _bb == address(0),"please set withdraw Address_bb and percentage.");
3507     require((_cc != address(0) && _ccPerc != 0) || _cc == address(0),"please set withdraw Address_cc and percentage.");
3508     require((_dd != address(0) && _ddPerc != 0) || _dd == address(0),"please set withdraw Address_dd and percentage.");
3509     require((_ee != address(0) && _eePerc != 0) || _ee == address(0),"please set withdraw Address_ee and percentage.");
3510     require((_ff != address(0) && _ffPerc != 0) || _ff == address(0),"please set withdraw Address_ff and percentage.");
3511 
3512     uint256 _ethBalance = address(this).balance;
3513     bool os;
3514     if(_aa != address(0)){//if _aa has.
3515         (os, ) = payable(_aa).call{value: (_ethBalance * _aaPerc/10000)}("");
3516         require(os, "Failed to withdraw_aa Ether");
3517     }
3518     if(_bb != address(0)){//if _bb has.
3519         (os, ) = payable(_bb).call{value: (_ethBalance * _bbPerc/10000)}("");
3520         require(os, "Failed to withdraw_bb Ether");
3521     }
3522     if(_cc != address(0)){//if _cc has.
3523         (os, ) = payable(_cc).call{value: (_ethBalance * _ccPerc/10000)}("");
3524         require(os, "Failed to withdraw_cc Ether");
3525     }
3526     if(_dd != address(0)){//if _dd has.
3527         (os, ) = payable(_dd).call{value: (_ethBalance * _ddPerc/10000)}("");
3528         require(os, "Failed to withdraw_dd Ether");
3529     }
3530     if(_ee != address(0)){//if _ee has.
3531         (os, ) = payable(_ee).call{value: (_ethBalance * _eePerc/10000)}("");
3532         require(os, "Failed to withdraw_ee Ether");
3533     }
3534     if(_ff != address(0)){//if _ff has.
3535         (os, ) = payable(_ff).call{value: (_ethBalance * _ffPerc/10000)}("");
3536         require(os, "Failed to withdraw_ff Ether");
3537     }
3538 
3539     _ethBalance = address(this).balance;
3540     if(_withdrawWallet != address(0)){//if _withdrawWallet has.
3541         (os, ) = payable(_withdrawWallet).call{value: (_ethBalance)}("");
3542     }else{
3543         (os, ) = payable(owner()).call{value: (_ethBalance)}("");
3544     }
3545     require(os, "Failed to withdraw Ether");
3546   }
3547 
3548 
3549   //return wallet owned tokenids.
3550   function walletOfOwner(address _address) external view virtual returns (uint256[] memory) {
3551     uint256 ownerTokenCount = balanceOf(_address);
3552     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3553     //search from all tonkenid. so spend high gas values.attention.
3554     uint256 tokenindex = 0;
3555     for (uint256 i = _startTokenId(); i < (_nextTokenId() -1); i++) {
3556       if(_address == this.tryOwnerOf(i)) tokenIds[tokenindex++] = i;
3557     }
3558     return tokenIds;
3559   }
3560 
3561   //try catch vaersion ownerOf. support burned tokenid.
3562   function tryOwnerOf(uint256 tokenId) external view  virtual returns (address) {
3563     try this.ownerOf(tokenId) returns (address _address) {
3564       return(_address);
3565     } catch {
3566         return (address(0));//return 0x0 if error.
3567     }
3568   }
3569 
3570     //OPENSEA.OPERATORFilterer.START
3571     /**
3572      * @notice Set the state of the OpenSea operator filter
3573      * @param value Flag indicating if the operator filter should be applied to transfers and approvals
3574      */
3575     function setOperatorFilteringEnabled(bool value) external onlyOperator {
3576         operatorFilteringEnabled = value;
3577     }
3578 
3579 
3580     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3581         require(
3582             operator == owner() || bondedAddress[operator] == true || sbtFlag == false,
3583             'Cannot approve, transferring not allowed'
3584         );
3585         super.setApprovalForAll(operator, approved);
3586     }
3587 
3588     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3589         require(
3590             operator == owner() || bondedAddress[operator] == true || sbtFlag == false,
3591             'Cannot approve, transferring not allowed'
3592         );
3593         super.approve(operator, tokenId);
3594     }
3595 
3596     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3597         super.transferFrom(from, to, tokenId);
3598     }
3599 
3600     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3601         super.safeTransferFrom(from, to, tokenId);
3602     }
3603     //OPENSEA.OPERATORFilterer.END
3604 
3605     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3606         public
3607         override
3608         onlyAllowedOperator(from)
3609     {
3610         super.safeTransferFrom(from, to, tokenId, data);
3611     }
3612 
3613 
3614   function _beforeTokenTransfers(address from,address to,uint256 startTokenId,uint256 quantity) internal override {
3615     if(from != address(0)){
3616         require(
3617             from == owner() || bondedAddress[from] == true || sbtFlag == false,
3618             'Send NFT not allowed'
3619         );
3620     }
3621     super._beforeTokenTransfers(from, to, startTokenId, quantity);
3622   }
3623 
3624     /**
3625         @dev Operable Role
3626      */
3627     function grantOperatorRole(address _candidate) external onlyOwner {
3628         _grantOperatorRole(_candidate);
3629     }
3630     function revokeOperatorRole(address _candidate) external onlyOwner {
3631         _revokeOperatorRole(_candidate);
3632     }
3633 }
3634 //CODE.BY.FRICKLIK