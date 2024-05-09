1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
5 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
31  * and `uint256` (`UintSet`) are supported.
32  *
33  * [WARNING]
34  * ====
35  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
36  * unusable.
37  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
38  *
39  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
40  * array of EnumerableSet.
41  * ====
42  */
43 library EnumerableSet {
44     // To implement this library for multiple types with as little code
45     // repetition as possible, we write it in terms of a generic Set type with
46     // bytes32 values.
47     // The Set implementation uses private functions, and user-facing
48     // implementations (such as AddressSet) are just wrappers around the
49     // underlying Set.
50     // This means that we can only create new EnumerableSets for types that fit
51     // in bytes32.
52 
53     struct Set {
54         // Storage of set values
55         bytes32[] _values;
56         // Position of the value in the `values` array, plus 1 because index 0
57         // means a value is not in the set.
58         mapping(bytes32 => uint256) _indexes;
59     }
60 
61     /**
62      * @dev Add a value to a set. O(1).
63      *
64      * Returns true if the value was added to the set, that is if it was not
65      * already present.
66      */
67     function _add(Set storage set, bytes32 value) private returns (bool) {
68         if (!_contains(set, value)) {
69             set._values.push(value);
70             // The value is stored at length-1, but we add 1 to all indexes
71             // and use 0 as a sentinel value
72             set._indexes[value] = set._values.length;
73             return true;
74         } else {
75             return false;
76         }
77     }
78 
79     /**
80      * @dev Removes a value from a set. O(1).
81      *
82      * Returns true if the value was removed from the set, that is if it was
83      * present.
84      */
85     function _remove(Set storage set, bytes32 value) private returns (bool) {
86         // We read and store the value's index to prevent multiple reads from the same storage slot
87         uint256 valueIndex = set._indexes[value];
88 
89         if (valueIndex != 0) {
90             // Equivalent to contains(set, value)
91             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
92             // the array, and then remove the last element (sometimes called as 'swap and pop').
93             // This modifies the order of the array, as noted in {at}.
94 
95             uint256 toDeleteIndex = valueIndex - 1;
96             uint256 lastIndex = set._values.length - 1;
97 
98             if (lastIndex != toDeleteIndex) {
99                 bytes32 lastValue = set._values[lastIndex];
100 
101                 // Move the last value to the index where the value to delete is
102                 set._values[toDeleteIndex] = lastValue;
103                 // Update the index for the moved value
104                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
105             }
106 
107             // Delete the slot where the moved value was stored
108             set._values.pop();
109 
110             // Delete the index for the deleted slot
111             delete set._indexes[value];
112 
113             return true;
114         } else {
115             return false;
116         }
117     }
118 
119     /**
120      * @dev Returns true if the value is in the set. O(1).
121      */
122     function _contains(Set storage set, bytes32 value) private view returns (bool) {
123         return set._indexes[value] != 0;
124     }
125 
126     /**
127      * @dev Returns the number of values on the set. O(1).
128      */
129     function _length(Set storage set) private view returns (uint256) {
130         return set._values.length;
131     }
132 
133     /**
134      * @dev Returns the value stored at position `index` in the set. O(1).
135      *
136      * Note that there are no guarantees on the ordering of values inside the
137      * array, and it may change when more values are added or removed.
138      *
139      * Requirements:
140      *
141      * - `index` must be strictly less than {length}.
142      */
143     function _at(Set storage set, uint256 index) private view returns (bytes32) {
144         return set._values[index];
145     }
146 
147     /**
148      * @dev Return the entire set in an array
149      *
150      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
151      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
152      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
153      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
154      */
155     function _values(Set storage set) private view returns (bytes32[] memory) {
156         return set._values;
157     }
158 
159     // Bytes32Set
160 
161     struct Bytes32Set {
162         Set _inner;
163     }
164 
165     /**
166      * @dev Add a value to a set. O(1).
167      *
168      * Returns true if the value was added to the set, that is if it was not
169      * already present.
170      */
171     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
172         return _add(set._inner, value);
173     }
174 
175     /**
176      * @dev Removes a value from a set. O(1).
177      *
178      * Returns true if the value was removed from the set, that is if it was
179      * present.
180      */
181     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
182         return _remove(set._inner, value);
183     }
184 
185     /**
186      * @dev Returns true if the value is in the set. O(1).
187      */
188     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
189         return _contains(set._inner, value);
190     }
191 
192     /**
193      * @dev Returns the number of values in the set. O(1).
194      */
195     function length(Bytes32Set storage set) internal view returns (uint256) {
196         return _length(set._inner);
197     }
198 
199     /**
200      * @dev Returns the value stored at position `index` in the set. O(1).
201      *
202      * Note that there are no guarantees on the ordering of values inside the
203      * array, and it may change when more values are added or removed.
204      *
205      * Requirements:
206      *
207      * - `index` must be strictly less than {length}.
208      */
209     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
210         return _at(set._inner, index);
211     }
212 
213     /**
214      * @dev Return the entire set in an array
215      *
216      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
217      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
218      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
219      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
220      */
221     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
222         bytes32[] memory store = _values(set._inner);
223         bytes32[] memory result;
224 
225         /// @solidity memory-safe-assembly
226         assembly {
227             result := store
228         }
229 
230         return result;
231     }
232 
233     // AddressSet
234 
235     struct AddressSet {
236         Set _inner;
237     }
238 
239     /**
240      * @dev Add a value to a set. O(1).
241      *
242      * Returns true if the value was added to the set, that is if it was not
243      * already present.
244      */
245     function add(AddressSet storage set, address value) internal returns (bool) {
246         return _add(set._inner, bytes32(uint256(uint160(value))));
247     }
248 
249     /**
250      * @dev Removes a value from a set. O(1).
251      *
252      * Returns true if the value was removed from the set, that is if it was
253      * present.
254      */
255     function remove(AddressSet storage set, address value) internal returns (bool) {
256         return _remove(set._inner, bytes32(uint256(uint160(value))));
257     }
258 
259     /**
260      * @dev Returns true if the value is in the set. O(1).
261      */
262     function contains(AddressSet storage set, address value) internal view returns (bool) {
263         return _contains(set._inner, bytes32(uint256(uint160(value))));
264     }
265 
266     /**
267      * @dev Returns the number of values in the set. O(1).
268      */
269     function length(AddressSet storage set) internal view returns (uint256) {
270         return _length(set._inner);
271     }
272 
273     /**
274      * @dev Returns the value stored at position `index` in the set. O(1).
275      *
276      * Note that there are no guarantees on the ordering of values inside the
277      * array, and it may change when more values are added or removed.
278      *
279      * Requirements:
280      *
281      * - `index` must be strictly less than {length}.
282      */
283     function at(AddressSet storage set, uint256 index) internal view returns (address) {
284         return address(uint160(uint256(_at(set._inner, index))));
285     }
286 
287     /**
288      * @dev Return the entire set in an array
289      *
290      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
291      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
292      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
293      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
294      */
295     function values(AddressSet storage set) internal view returns (address[] memory) {
296         bytes32[] memory store = _values(set._inner);
297         address[] memory result;
298 
299         /// @solidity memory-safe-assembly
300         assembly {
301             result := store
302         }
303 
304         return result;
305     }
306 
307     // UintSet
308 
309     struct UintSet {
310         Set _inner;
311     }
312 
313     /**
314      * @dev Add a value to a set. O(1).
315      *
316      * Returns true if the value was added to the set, that is if it was not
317      * already present.
318      */
319     function add(UintSet storage set, uint256 value) internal returns (bool) {
320         return _add(set._inner, bytes32(value));
321     }
322 
323     /**
324      * @dev Removes a value from a set. O(1).
325      *
326      * Returns true if the value was removed from the set, that is if it was
327      * present.
328      */
329     function remove(UintSet storage set, uint256 value) internal returns (bool) {
330         return _remove(set._inner, bytes32(value));
331     }
332 
333     /**
334      * @dev Returns true if the value is in the set. O(1).
335      */
336     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
337         return _contains(set._inner, bytes32(value));
338     }
339 
340     /**
341      * @dev Returns the number of values in the set. O(1).
342      */
343     function length(UintSet storage set) internal view returns (uint256) {
344         return _length(set._inner);
345     }
346 
347     /**
348      * @dev Returns the value stored at position `index` in the set. O(1).
349      *
350      * Note that there are no guarantees on the ordering of values inside the
351      * array, and it may change when more values are added or removed.
352      *
353      * Requirements:
354      *
355      * - `index` must be strictly less than {length}.
356      */
357     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
358         return uint256(_at(set._inner, index));
359     }
360 
361     /**
362      * @dev Return the entire set in an array
363      *
364      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
365      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
366      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
367      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
368      */
369     function values(UintSet storage set) internal view returns (uint256[] memory) {
370         bytes32[] memory store = _values(set._inner);
371         uint256[] memory result;
372 
373         /// @solidity memory-safe-assembly
374         assembly {
375             result := store
376         }
377 
378         return result;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/utils/StorageSlot.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 /**
390  * @dev Library for reading and writing primitive types to specific storage slots.
391  *
392  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
393  * This library helps with reading and writing to such slots without the need for inline assembly.
394  *
395  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
396  *
397  * Example usage to set ERC1967 implementation slot:
398  * ```
399  * contract ERC1967 {
400  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
401  *
402  *     function _getImplementation() internal view returns (address) {
403  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
404  *     }
405  *
406  *     function _setImplementation(address newImplementation) internal {
407  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
408  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
409  *     }
410  * }
411  * ```
412  *
413  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
414  */
415 library StorageSlot {
416     struct AddressSlot {
417         address value;
418     }
419 
420     struct BooleanSlot {
421         bool value;
422     }
423 
424     struct Bytes32Slot {
425         bytes32 value;
426     }
427 
428     struct Uint256Slot {
429         uint256 value;
430     }
431 
432     /**
433      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
434      */
435     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
436         /// @solidity memory-safe-assembly
437         assembly {
438             r.slot := slot
439         }
440     }
441 
442     /**
443      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
444      */
445     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
446         /// @solidity memory-safe-assembly
447         assembly {
448             r.slot := slot
449         }
450     }
451 
452     /**
453      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
454      */
455     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
456         /// @solidity memory-safe-assembly
457         assembly {
458             r.slot := slot
459         }
460     }
461 
462     /**
463      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
464      */
465     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
466         /// @solidity memory-safe-assembly
467         assembly {
468             r.slot := slot
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/utils/Address.sol
474 
475 
476 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
477 
478 pragma solidity ^0.8.1;
479 
480 /**
481  * @dev Collection of functions related to the address type
482  */
483 library Address {
484     /**
485      * @dev Returns true if `account` is a contract.
486      *
487      * [IMPORTANT]
488      * ====
489      * It is unsafe to assume that an address for which this function returns
490      * false is an externally-owned account (EOA) and not a contract.
491      *
492      * Among others, `isContract` will return false for the following
493      * types of addresses:
494      *
495      *  - an externally-owned account
496      *  - a contract in construction
497      *  - an address where a contract will be created
498      *  - an address where a contract lived, but was destroyed
499      * ====
500      *
501      * [IMPORTANT]
502      * ====
503      * You shouldn't rely on `isContract` to protect against flash loan attacks!
504      *
505      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
506      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
507      * constructor.
508      * ====
509      */
510     function isContract(address account) internal view returns (bool) {
511         // This method relies on extcodesize/address.code.length, which returns 0
512         // for contracts in construction, since the code is only stored at the end
513         // of the constructor execution.
514 
515         return account.code.length > 0;
516     }
517 
518     /**
519      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
520      * `recipient`, forwarding all available gas and reverting on errors.
521      *
522      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
523      * of certain opcodes, possibly making contracts go over the 2300 gas limit
524      * imposed by `transfer`, making them unable to receive funds via
525      * `transfer`. {sendValue} removes this limitation.
526      *
527      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
528      *
529      * IMPORTANT: because control is transferred to `recipient`, care must be
530      * taken to not create reentrancy vulnerabilities. Consider using
531      * {ReentrancyGuard} or the
532      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
533      */
534     function sendValue(address payable recipient, uint256 amount) internal {
535         require(address(this).balance >= amount, "Address: insufficient balance");
536 
537         (bool success, ) = recipient.call{value: amount}("");
538         require(success, "Address: unable to send value, recipient may have reverted");
539     }
540 
541     /**
542      * @dev Performs a Solidity function call using a low level `call`. A
543      * plain `call` is an unsafe replacement for a function call: use this
544      * function instead.
545      *
546      * If `target` reverts with a revert reason, it is bubbled up by this
547      * function (like regular Solidity function calls).
548      *
549      * Returns the raw returned data. To convert to the expected return value,
550      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
551      *
552      * Requirements:
553      *
554      * - `target` must be a contract.
555      * - calling `target` with `data` must not revert.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
560         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
565      * `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, 0, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but also transferring `value` wei to `target`.
580      *
581      * Requirements:
582      *
583      * - the calling contract must have an ETH balance of at least `value`.
584      * - the called Solidity function must be `payable`.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(
589         address target,
590         bytes memory data,
591         uint256 value
592     ) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(
603         address target,
604         bytes memory data,
605         uint256 value,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(address(this).balance >= value, "Address: insufficient balance for call");
609         (bool success, bytes memory returndata) = target.call{value: value}(data);
610         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but performing a static call.
616      *
617      * _Available since v3.3._
618      */
619     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
620         return functionStaticCall(target, data, "Address: low-level static call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
625      * but performing a static call.
626      *
627      * _Available since v3.3._
628      */
629     function functionStaticCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal view returns (bytes memory) {
634         (bool success, bytes memory returndata) = target.staticcall(data);
635         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a delegate call.
641      *
642      * _Available since v3.4._
643      */
644     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
645         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal returns (bytes memory) {
659         (bool success, bytes memory returndata) = target.delegatecall(data);
660         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
661     }
662 
663     /**
664      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
665      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
666      *
667      * _Available since v4.8._
668      */
669     function verifyCallResultFromTarget(
670         address target,
671         bool success,
672         bytes memory returndata,
673         string memory errorMessage
674     ) internal view returns (bytes memory) {
675         if (success) {
676             if (returndata.length == 0) {
677                 // only check isContract if the call was successful and the return data is empty
678                 // otherwise we already know that it was a contract
679                 require(isContract(target), "Address: call to non-contract");
680             }
681             return returndata;
682         } else {
683             _revert(returndata, errorMessage);
684         }
685     }
686 
687     /**
688      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
689      * revert reason or using the provided one.
690      *
691      * _Available since v4.3._
692      */
693     function verifyCallResult(
694         bool success,
695         bytes memory returndata,
696         string memory errorMessage
697     ) internal pure returns (bytes memory) {
698         if (success) {
699             return returndata;
700         } else {
701             _revert(returndata, errorMessage);
702         }
703     }
704 
705     function _revert(bytes memory returndata, string memory errorMessage) private pure {
706         // Look for revert reason and bubble it up if present
707         if (returndata.length > 0) {
708             // The easiest way to bubble the revert reason is using memory via assembly
709             /// @solidity memory-safe-assembly
710             assembly {
711                 let returndata_size := mload(returndata)
712                 revert(add(32, returndata), returndata_size)
713             }
714         } else {
715             revert(errorMessage);
716         }
717     }
718 }
719 
720 // File: @openzeppelin/contracts/utils/math/Math.sol
721 
722 
723 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @dev Standard math utilities missing in the Solidity language.
729  */
730 library Math {
731     enum Rounding {
732         Down, // Toward negative infinity
733         Up, // Toward infinity
734         Zero // Toward zero
735     }
736 
737     /**
738      * @dev Returns the largest of two numbers.
739      */
740     function max(uint256 a, uint256 b) internal pure returns (uint256) {
741         return a > b ? a : b;
742     }
743 
744     /**
745      * @dev Returns the smallest of two numbers.
746      */
747     function min(uint256 a, uint256 b) internal pure returns (uint256) {
748         return a < b ? a : b;
749     }
750 
751     /**
752      * @dev Returns the average of two numbers. The result is rounded towards
753      * zero.
754      */
755     function average(uint256 a, uint256 b) internal pure returns (uint256) {
756         // (a + b) / 2 can overflow.
757         return (a & b) + (a ^ b) / 2;
758     }
759 
760     /**
761      * @dev Returns the ceiling of the division of two numbers.
762      *
763      * This differs from standard division with `/` in that it rounds up instead
764      * of rounding down.
765      */
766     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
767         // (a + b - 1) / b can overflow on addition, so we distribute.
768         return a == 0 ? 0 : (a - 1) / b + 1;
769     }
770 
771     /**
772      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
773      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
774      * with further edits by Uniswap Labs also under MIT license.
775      */
776     function mulDiv(
777         uint256 x,
778         uint256 y,
779         uint256 denominator
780     ) internal pure returns (uint256 result) {
781         unchecked {
782             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
783             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
784             // variables such that product = prod1 * 2^256 + prod0.
785             uint256 prod0; // Least significant 256 bits of the product
786             uint256 prod1; // Most significant 256 bits of the product
787             assembly {
788                 let mm := mulmod(x, y, not(0))
789                 prod0 := mul(x, y)
790                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
791             }
792 
793             // Handle non-overflow cases, 256 by 256 division.
794             if (prod1 == 0) {
795                 return prod0 / denominator;
796             }
797 
798             // Make sure the result is less than 2^256. Also prevents denominator == 0.
799             require(denominator > prod1);
800 
801             ///////////////////////////////////////////////
802             // 512 by 256 division.
803             ///////////////////////////////////////////////
804 
805             // Make division exact by subtracting the remainder from [prod1 prod0].
806             uint256 remainder;
807             assembly {
808                 // Compute remainder using mulmod.
809                 remainder := mulmod(x, y, denominator)
810 
811                 // Subtract 256 bit number from 512 bit number.
812                 prod1 := sub(prod1, gt(remainder, prod0))
813                 prod0 := sub(prod0, remainder)
814             }
815 
816             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
817             // See https://cs.stackexchange.com/q/138556/92363.
818 
819             // Does not overflow because the denominator cannot be zero at this stage in the function.
820             uint256 twos = denominator & (~denominator + 1);
821             assembly {
822                 // Divide denominator by twos.
823                 denominator := div(denominator, twos)
824 
825                 // Divide [prod1 prod0] by twos.
826                 prod0 := div(prod0, twos)
827 
828                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
829                 twos := add(div(sub(0, twos), twos), 1)
830             }
831 
832             // Shift in bits from prod1 into prod0.
833             prod0 |= prod1 * twos;
834 
835             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
836             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
837             // four bits. That is, denominator * inv = 1 mod 2^4.
838             uint256 inverse = (3 * denominator) ^ 2;
839 
840             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
841             // in modular arithmetic, doubling the correct bits in each step.
842             inverse *= 2 - denominator * inverse; // inverse mod 2^8
843             inverse *= 2 - denominator * inverse; // inverse mod 2^16
844             inverse *= 2 - denominator * inverse; // inverse mod 2^32
845             inverse *= 2 - denominator * inverse; // inverse mod 2^64
846             inverse *= 2 - denominator * inverse; // inverse mod 2^128
847             inverse *= 2 - denominator * inverse; // inverse mod 2^256
848 
849             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
850             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
851             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
852             // is no longer required.
853             result = prod0 * inverse;
854             return result;
855         }
856     }
857 
858     /**
859      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
860      */
861     function mulDiv(
862         uint256 x,
863         uint256 y,
864         uint256 denominator,
865         Rounding rounding
866     ) internal pure returns (uint256) {
867         uint256 result = mulDiv(x, y, denominator);
868         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
869             result += 1;
870         }
871         return result;
872     }
873 
874     /**
875      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
876      *
877      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
878      */
879     function sqrt(uint256 a) internal pure returns (uint256) {
880         if (a == 0) {
881             return 0;
882         }
883 
884         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
885         //
886         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
887         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
888         //
889         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
890         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
891         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
892         //
893         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
894         uint256 result = 1 << (log2(a) >> 1);
895 
896         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
897         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
898         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
899         // into the expected uint128 result.
900         unchecked {
901             result = (result + a / result) >> 1;
902             result = (result + a / result) >> 1;
903             result = (result + a / result) >> 1;
904             result = (result + a / result) >> 1;
905             result = (result + a / result) >> 1;
906             result = (result + a / result) >> 1;
907             result = (result + a / result) >> 1;
908             return min(result, a / result);
909         }
910     }
911 
912     /**
913      * @notice Calculates sqrt(a), following the selected rounding direction.
914      */
915     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
916         unchecked {
917             uint256 result = sqrt(a);
918             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
919         }
920     }
921 
922     /**
923      * @dev Return the log in base 2, rounded down, of a positive value.
924      * Returns 0 if given 0.
925      */
926     function log2(uint256 value) internal pure returns (uint256) {
927         uint256 result = 0;
928         unchecked {
929             if (value >> 128 > 0) {
930                 value >>= 128;
931                 result += 128;
932             }
933             if (value >> 64 > 0) {
934                 value >>= 64;
935                 result += 64;
936             }
937             if (value >> 32 > 0) {
938                 value >>= 32;
939                 result += 32;
940             }
941             if (value >> 16 > 0) {
942                 value >>= 16;
943                 result += 16;
944             }
945             if (value >> 8 > 0) {
946                 value >>= 8;
947                 result += 8;
948             }
949             if (value >> 4 > 0) {
950                 value >>= 4;
951                 result += 4;
952             }
953             if (value >> 2 > 0) {
954                 value >>= 2;
955                 result += 2;
956             }
957             if (value >> 1 > 0) {
958                 result += 1;
959             }
960         }
961         return result;
962     }
963 
964     /**
965      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
966      * Returns 0 if given 0.
967      */
968     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
969         unchecked {
970             uint256 result = log2(value);
971             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
972         }
973     }
974 
975     /**
976      * @dev Return the log in base 10, rounded down, of a positive value.
977      * Returns 0 if given 0.
978      */
979     function log10(uint256 value) internal pure returns (uint256) {
980         uint256 result = 0;
981         unchecked {
982             if (value >= 10**64) {
983                 value /= 10**64;
984                 result += 64;
985             }
986             if (value >= 10**32) {
987                 value /= 10**32;
988                 result += 32;
989             }
990             if (value >= 10**16) {
991                 value /= 10**16;
992                 result += 16;
993             }
994             if (value >= 10**8) {
995                 value /= 10**8;
996                 result += 8;
997             }
998             if (value >= 10**4) {
999                 value /= 10**4;
1000                 result += 4;
1001             }
1002             if (value >= 10**2) {
1003                 value /= 10**2;
1004                 result += 2;
1005             }
1006             if (value >= 10**1) {
1007                 result += 1;
1008             }
1009         }
1010         return result;
1011     }
1012 
1013     /**
1014      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1015      * Returns 0 if given 0.
1016      */
1017     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1018         unchecked {
1019             uint256 result = log10(value);
1020             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1021         }
1022     }
1023 
1024     /**
1025      * @dev Return the log in base 256, rounded down, of a positive value.
1026      * Returns 0 if given 0.
1027      *
1028      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1029      */
1030     function log256(uint256 value) internal pure returns (uint256) {
1031         uint256 result = 0;
1032         unchecked {
1033             if (value >> 128 > 0) {
1034                 value >>= 128;
1035                 result += 16;
1036             }
1037             if (value >> 64 > 0) {
1038                 value >>= 64;
1039                 result += 8;
1040             }
1041             if (value >> 32 > 0) {
1042                 value >>= 32;
1043                 result += 4;
1044             }
1045             if (value >> 16 > 0) {
1046                 value >>= 16;
1047                 result += 2;
1048             }
1049             if (value >> 8 > 0) {
1050                 result += 1;
1051             }
1052         }
1053         return result;
1054     }
1055 
1056     /**
1057      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1058      * Returns 0 if given 0.
1059      */
1060     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1061         unchecked {
1062             uint256 result = log256(value);
1063             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1064         }
1065     }
1066 }
1067 
1068 // File: @openzeppelin/contracts/utils/Strings.sol
1069 
1070 
1071 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1072 
1073 pragma solidity ^0.8.0;
1074 
1075 
1076 /**
1077  * @dev String operations.
1078  */
1079 library Strings {
1080     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1081     uint8 private constant _ADDRESS_LENGTH = 20;
1082 
1083     /**
1084      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1085      */
1086     function toString(uint256 value) internal pure returns (string memory) {
1087         unchecked {
1088             uint256 length = Math.log10(value) + 1;
1089             string memory buffer = new string(length);
1090             uint256 ptr;
1091             /// @solidity memory-safe-assembly
1092             assembly {
1093                 ptr := add(buffer, add(32, length))
1094             }
1095             while (true) {
1096                 ptr--;
1097                 /// @solidity memory-safe-assembly
1098                 assembly {
1099                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1100                 }
1101                 value /= 10;
1102                 if (value == 0) break;
1103             }
1104             return buffer;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1110      */
1111     function toHexString(uint256 value) internal pure returns (string memory) {
1112         unchecked {
1113             return toHexString(value, Math.log256(value) + 1);
1114         }
1115     }
1116 
1117     /**
1118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1119      */
1120     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1121         bytes memory buffer = new bytes(2 * length + 2);
1122         buffer[0] = "0";
1123         buffer[1] = "x";
1124         for (uint256 i = 2 * length + 1; i > 1; --i) {
1125             buffer[i] = _SYMBOLS[value & 0xf];
1126             value >>= 4;
1127         }
1128         require(value == 0, "Strings: hex length insufficient");
1129         return string(buffer);
1130     }
1131 
1132     /**
1133      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1134      */
1135     function toHexString(address addr) internal pure returns (string memory) {
1136         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1137     }
1138 }
1139 
1140 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1141 
1142 
1143 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1144 
1145 pragma solidity ^0.8.0;
1146 
1147 /**
1148  * @title ERC721 token receiver interface
1149  * @dev Interface for any contract that wants to support safeTransfers
1150  * from ERC721 asset contracts.
1151  */
1152 interface IERC721Receiver {
1153     /**
1154      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1155      * by `operator` from `from`, this function is called.
1156      *
1157      * It must return its Solidity selector to confirm the token transfer.
1158      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1159      *
1160      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1161      */
1162     function onERC721Received(
1163         address operator,
1164         address from,
1165         uint256 tokenId,
1166         bytes calldata data
1167     ) external returns (bytes4);
1168 }
1169 
1170 // File: solidity-bits/contracts/Popcount.sol
1171 
1172 
1173 /**
1174    _____       ___     ___ __           ____  _ __      
1175   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1176   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1177  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1178 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1179                            /____/                        
1180 
1181 - npm: https://www.npmjs.com/package/solidity-bits
1182 - github: https://github.com/estarriolvetch/solidity-bits
1183 
1184  */
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 library Popcount {
1189     uint256 private constant m1 = 0x5555555555555555555555555555555555555555555555555555555555555555;
1190     uint256 private constant m2 = 0x3333333333333333333333333333333333333333333333333333333333333333;
1191     uint256 private constant m4 = 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
1192     uint256 private constant h01 = 0x0101010101010101010101010101010101010101010101010101010101010101;
1193 
1194     function popcount256A(uint256 x) internal pure returns (uint256 count) {
1195         unchecked{
1196             for (count=0; x!=0; count++)
1197                 x &= x - 1;
1198         }
1199     }
1200 
1201     function popcount256B(uint256 x) internal pure returns (uint256) {
1202         if (x == type(uint256).max) {
1203             return 256;
1204         }
1205         unchecked {
1206             x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
1207             x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits 
1208             x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits 
1209             x = (x * h01) >> 248;  //returns left 8 bits of x + (x<<8) + (x<<16) + (x<<24) + ... 
1210         }
1211         return x;
1212     }
1213 }
1214 // File: solidity-bits/contracts/BitScan.sol
1215 
1216 
1217 /**
1218    _____       ___     ___ __           ____  _ __      
1219   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1220   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1221  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1222 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1223                            /____/                        
1224 
1225 - npm: https://www.npmjs.com/package/solidity-bits
1226 - github: https://github.com/estarriolvetch/solidity-bits
1227 
1228  */
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 library BitScan {
1234     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
1235     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
1236 
1237     /**
1238         @dev Isolate the least significant set bit.
1239      */ 
1240     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
1241         require(bb > 0);
1242         unchecked {
1243             return bb & (0 - bb);
1244         }
1245     } 
1246 
1247     /**
1248         @dev Isolate the most significant set bit.
1249      */ 
1250     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
1251         require(bb > 0);
1252         unchecked {
1253             bb |= bb >> 128;
1254             bb |= bb >> 64;
1255             bb |= bb >> 32;
1256             bb |= bb >> 16;
1257             bb |= bb >> 8;
1258             bb |= bb >> 4;
1259             bb |= bb >> 2;
1260             bb |= bb >> 1;
1261             
1262             return (bb >> 1) + 1;
1263         }
1264     } 
1265 
1266     /**
1267         @dev Find the index of the lest significant set bit. (trailing zero count)
1268      */ 
1269     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
1270         unchecked {
1271             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
1272         }   
1273     }
1274 
1275     /**
1276         @dev Find the index of the most significant set bit.
1277      */ 
1278     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
1279         unchecked {
1280             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
1281         }   
1282     }
1283 
1284     function log2(uint256 bb) pure internal returns (uint8) {
1285         unchecked {
1286             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
1287         } 
1288     }
1289 }
1290 
1291 // File: solidity-bits/contracts/BitMaps.sol
1292 
1293 
1294 /**
1295    _____       ___     ___ __           ____  _ __      
1296   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1297   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1298  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1299 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1300                            /____/                        
1301 
1302 - npm: https://www.npmjs.com/package/solidity-bits
1303 - github: https://github.com/estarriolvetch/solidity-bits
1304 
1305  */
1306 pragma solidity ^0.8.0;
1307 
1308 
1309 
1310 /**
1311  * @dev This Library is a modified version of Openzeppelin's BitMaps library with extra features.
1312  *
1313  * 1. Functions of finding the index of the closest set bit from a given index are added.
1314  *    The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
1315  *    The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
1316  * 2. Setting and unsetting the bitmap consecutively.
1317  * 3. Accounting number of set bits within a given range.   
1318  *
1319 */
1320 
1321 /**
1322  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
1323  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
1324  */
1325 
1326 library BitMaps {
1327     using BitScan for uint256;
1328     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
1329     uint256 private constant MASK_FULL = type(uint256).max;
1330 
1331     struct BitMap {
1332         mapping(uint256 => uint256) _data;
1333     }
1334 
1335     /**
1336      * @dev Returns whether the bit at `index` is set.
1337      */
1338     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
1339         uint256 bucket = index >> 8;
1340         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1341         return bitmap._data[bucket] & mask != 0;
1342     }
1343 
1344     /**
1345      * @dev Sets the bit at `index` to the boolean `value`.
1346      */
1347     function setTo(
1348         BitMap storage bitmap,
1349         uint256 index,
1350         bool value
1351     ) internal {
1352         if (value) {
1353             set(bitmap, index);
1354         } else {
1355             unset(bitmap, index);
1356         }
1357     }
1358 
1359     /**
1360      * @dev Sets the bit at `index`.
1361      */
1362     function set(BitMap storage bitmap, uint256 index) internal {
1363         uint256 bucket = index >> 8;
1364         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1365         bitmap._data[bucket] |= mask;
1366     }
1367 
1368     /**
1369      * @dev Unsets the bit at `index`.
1370      */
1371     function unset(BitMap storage bitmap, uint256 index) internal {
1372         uint256 bucket = index >> 8;
1373         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1374         bitmap._data[bucket] &= ~mask;
1375     }
1376 
1377 
1378     /**
1379      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
1380      */    
1381     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
1382         uint256 bucket = startIndex >> 8;
1383 
1384         uint256 bucketStartIndex = (startIndex & 0xff);
1385 
1386         unchecked {
1387             if(bucketStartIndex + amount < 256) {
1388                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
1389             } else {
1390                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
1391                 amount -= (256 - bucketStartIndex);
1392                 bucket++;
1393 
1394                 while(amount > 256) {
1395                     bitmap._data[bucket] = MASK_FULL;
1396                     amount -= 256;
1397                     bucket++;
1398                 }
1399 
1400                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
1401             }
1402         }
1403     }
1404 
1405 
1406     /**
1407      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
1408      */    
1409     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
1410         uint256 bucket = startIndex >> 8;
1411 
1412         uint256 bucketStartIndex = (startIndex & 0xff);
1413 
1414         unchecked {
1415             if(bucketStartIndex + amount < 256) {
1416                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
1417             } else {
1418                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
1419                 amount -= (256 - bucketStartIndex);
1420                 bucket++;
1421 
1422                 while(amount > 256) {
1423                     bitmap._data[bucket] = 0;
1424                     amount -= 256;
1425                     bucket++;
1426                 }
1427 
1428                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
1429             }
1430         }
1431     }
1432 
1433     /**
1434      * @dev Returns number of set bits within a range.
1435      */
1436     function popcountA(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
1437         uint256 bucket = startIndex >> 8;
1438 
1439         uint256 bucketStartIndex = (startIndex & 0xff);
1440 
1441         unchecked {
1442             if(bucketStartIndex + amount < 256) {
1443                 count +=  Popcount.popcount256A(
1444                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
1445                 );
1446             } else {
1447                 count += Popcount.popcount256A(
1448                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
1449                 );
1450                 amount -= (256 - bucketStartIndex);
1451                 bucket++;
1452 
1453                 while(amount > 256) {
1454                     count += Popcount.popcount256A(bitmap._data[bucket]);
1455                     amount -= 256;
1456                     bucket++;
1457                 }
1458                 count += Popcount.popcount256A(
1459                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
1460                 );
1461             }
1462         }
1463     }
1464 
1465     /**
1466      * @dev Returns number of set bits within a range.
1467      */
1468     function popcountB(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
1469         uint256 bucket = startIndex >> 8;
1470 
1471         uint256 bucketStartIndex = (startIndex & 0xff);
1472 
1473         unchecked {
1474             if(bucketStartIndex + amount < 256) {
1475                 count +=  Popcount.popcount256B(
1476                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
1477                 );
1478             } else {
1479                 count += Popcount.popcount256B(
1480                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
1481                 );
1482                 amount -= (256 - bucketStartIndex);
1483                 bucket++;
1484 
1485                 while(amount > 256) {
1486                     count += Popcount.popcount256B(bitmap._data[bucket]);
1487                     amount -= 256;
1488                     bucket++;
1489                 }
1490                 count += Popcount.popcount256B(
1491                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
1492                 );
1493             }
1494         }
1495     }
1496 
1497 
1498     /**
1499      * @dev Find the closest index of the set bit before `index`.
1500      */
1501     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
1502         uint256 bucket = index >> 8;
1503 
1504         // index within the bucket
1505         uint256 bucketIndex = (index & 0xff);
1506 
1507         // load a bitboard from the bitmap.
1508         uint256 bb = bitmap._data[bucket];
1509 
1510         // offset the bitboard to scan from `bucketIndex`.
1511         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
1512         
1513         if(bb > 0) {
1514             unchecked {
1515                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());    
1516             }
1517         } else {
1518             while(true) {
1519                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
1520                 unchecked {
1521                     bucket--;
1522                 }
1523                 // No offset. Always scan from the least significiant bit now.
1524                 bb = bitmap._data[bucket];
1525                 
1526                 if(bb > 0) {
1527                     unchecked {
1528                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
1529                         break;
1530                     }
1531                 } 
1532             }
1533         }
1534     }
1535 
1536     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
1537         return bitmap._data[bucket];
1538     }
1539 }
1540 
1541 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1542 
1543 
1544 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 /**
1549  * @dev Contract module that helps prevent reentrant calls to a function.
1550  *
1551  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1552  * available, which can be applied to functions to make sure there are no nested
1553  * (reentrant) calls to them.
1554  *
1555  * Note that because there is a single `nonReentrant` guard, functions marked as
1556  * `nonReentrant` may not call one another. This can be worked around by making
1557  * those functions `private`, and then adding `external` `nonReentrant` entry
1558  * points to them.
1559  *
1560  * TIP: If you would like to learn more about reentrancy and alternative ways
1561  * to protect against it, check out our blog post
1562  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1563  */
1564 abstract contract ReentrancyGuard {
1565     // Booleans are more expensive than uint256 or any type that takes up a full
1566     // word because each write operation emits an extra SLOAD to first read the
1567     // slot's contents, replace the bits taken up by the boolean, and then write
1568     // back. This is the compiler's defense against contract upgrades and
1569     // pointer aliasing, and it cannot be disabled.
1570 
1571     // The values being non-zero value makes deployment a bit more expensive,
1572     // but in exchange the refund on every call to nonReentrant will be lower in
1573     // amount. Since refunds are capped to a percentage of the total
1574     // transaction's gas, it is best to keep them low in cases like this one, to
1575     // increase the likelihood of the full refund coming into effect.
1576     uint256 private constant _NOT_ENTERED = 1;
1577     uint256 private constant _ENTERED = 2;
1578 
1579     uint256 private _status;
1580 
1581     constructor() {
1582         _status = _NOT_ENTERED;
1583     }
1584 
1585     /**
1586      * @dev Prevents a contract from calling itself, directly or indirectly.
1587      * Calling a `nonReentrant` function from another `nonReentrant`
1588      * function is not supported. It is possible to prevent this from happening
1589      * by making the `nonReentrant` function external, and making it call a
1590      * `private` function that does the actual work.
1591      */
1592     modifier nonReentrant() {
1593         _nonReentrantBefore();
1594         _;
1595         _nonReentrantAfter();
1596     }
1597 
1598     function _nonReentrantBefore() private {
1599         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1600         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1601 
1602         // Any calls to nonReentrant after this point will fail
1603         _status = _ENTERED;
1604     }
1605 
1606     function _nonReentrantAfter() private {
1607         // By storing the original value once again, a refund is triggered (see
1608         // https://eips.ethereum.org/EIPS/eip-2200)
1609         _status = _NOT_ENTERED;
1610     }
1611 }
1612 
1613 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1614 
1615 
1616 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1617 
1618 pragma solidity ^0.8.0;
1619 
1620 /**
1621  * @dev Interface of the ERC165 standard, as defined in the
1622  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1623  *
1624  * Implementers can declare support of contract interfaces, which can then be
1625  * queried by others ({ERC165Checker}).
1626  *
1627  * For an implementation, see {ERC165}.
1628  */
1629 interface IERC165 {
1630     /**
1631      * @dev Returns true if this contract implements the interface defined by
1632      * `interfaceId`. See the corresponding
1633      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1634      * to learn more about how these ids are created.
1635      *
1636      * This function call must use less than 30 000 gas.
1637      */
1638     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1639 }
1640 
1641 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1642 
1643 
1644 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1645 
1646 pragma solidity ^0.8.0;
1647 
1648 
1649 /**
1650  * @dev Required interface of an ERC721 compliant contract.
1651  */
1652 interface IERC721 is IERC165 {
1653     /**
1654      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1655      */
1656     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1657 
1658     /**
1659      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1660      */
1661     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1662 
1663     /**
1664      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1665      */
1666     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1667 
1668     /**
1669      * @dev Returns the number of tokens in ``owner``'s account.
1670      */
1671     function balanceOf(address owner) external view returns (uint256 balance);
1672 
1673     /**
1674      * @dev Returns the owner of the `tokenId` token.
1675      *
1676      * Requirements:
1677      *
1678      * - `tokenId` must exist.
1679      */
1680     function ownerOf(uint256 tokenId) external view returns (address owner);
1681 
1682     /**
1683      * @dev Safely transfers `tokenId` token from `from` to `to`.
1684      *
1685      * Requirements:
1686      *
1687      * - `from` cannot be the zero address.
1688      * - `to` cannot be the zero address.
1689      * - `tokenId` token must exist and be owned by `from`.
1690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1691      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1692      *
1693      * Emits a {Transfer} event.
1694      */
1695     function safeTransferFrom(
1696         address from,
1697         address to,
1698         uint256 tokenId,
1699         bytes calldata data
1700     ) external;
1701 
1702     /**
1703      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1704      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1705      *
1706      * Requirements:
1707      *
1708      * - `from` cannot be the zero address.
1709      * - `to` cannot be the zero address.
1710      * - `tokenId` token must exist and be owned by `from`.
1711      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1712      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1713      *
1714      * Emits a {Transfer} event.
1715      */
1716     function safeTransferFrom(
1717         address from,
1718         address to,
1719         uint256 tokenId
1720     ) external;
1721 
1722     /**
1723      * @dev Transfers `tokenId` token from `from` to `to`.
1724      *
1725      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1726      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1727      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1728      *
1729      * Requirements:
1730      *
1731      * - `from` cannot be the zero address.
1732      * - `to` cannot be the zero address.
1733      * - `tokenId` token must be owned by `from`.
1734      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1735      *
1736      * Emits a {Transfer} event.
1737      */
1738     function transferFrom(
1739         address from,
1740         address to,
1741         uint256 tokenId
1742     ) external;
1743 
1744     /**
1745      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1746      * The approval is cleared when the token is transferred.
1747      *
1748      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1749      *
1750      * Requirements:
1751      *
1752      * - The caller must own the token or be an approved operator.
1753      * - `tokenId` must exist.
1754      *
1755      * Emits an {Approval} event.
1756      */
1757     function approve(address to, uint256 tokenId) external;
1758 
1759     /**
1760      * @dev Approve or remove `operator` as an operator for the caller.
1761      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1762      *
1763      * Requirements:
1764      *
1765      * - The `operator` cannot be the caller.
1766      *
1767      * Emits an {ApprovalForAll} event.
1768      */
1769     function setApprovalForAll(address operator, bool _approved) external;
1770 
1771     /**
1772      * @dev Returns the account approved for `tokenId` token.
1773      *
1774      * Requirements:
1775      *
1776      * - `tokenId` must exist.
1777      */
1778     function getApproved(uint256 tokenId) external view returns (address operator);
1779 
1780     /**
1781      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1782      *
1783      * See {setApprovalForAll}
1784      */
1785     function isApprovedForAll(address owner, address operator) external view returns (bool);
1786 }
1787 
1788 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1789 
1790 
1791 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1792 
1793 pragma solidity ^0.8.0;
1794 
1795 
1796 /**
1797  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1798  * @dev See https://eips.ethereum.org/EIPS/eip-721
1799  */
1800 interface IERC721Metadata is IERC721 {
1801     /**
1802      * @dev Returns the token collection name.
1803      */
1804     function name() external view returns (string memory);
1805 
1806     /**
1807      * @dev Returns the token collection symbol.
1808      */
1809     function symbol() external view returns (string memory);
1810 
1811     /**
1812      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1813      */
1814     function tokenURI(uint256 tokenId) external view returns (string memory);
1815 }
1816 
1817 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1818 
1819 
1820 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1821 
1822 pragma solidity ^0.8.0;
1823 
1824 
1825 /**
1826  * @dev Implementation of the {IERC165} interface.
1827  *
1828  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1829  * for the additional interface id that will be supported. For example:
1830  *
1831  * ```solidity
1832  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1833  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1834  * }
1835  * ```
1836  *
1837  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1838  */
1839 abstract contract ERC165 is IERC165 {
1840     /**
1841      * @dev See {IERC165-supportsInterface}.
1842      */
1843     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1844         return interfaceId == type(IERC165).interfaceId;
1845     }
1846 }
1847 
1848 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1849 
1850 
1851 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1852 
1853 pragma solidity ^0.8.0;
1854 
1855 
1856 /**
1857  * @dev Interface for the NFT Royalty Standard.
1858  *
1859  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1860  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1861  *
1862  * _Available since v4.5._
1863  */
1864 interface IERC2981 is IERC165 {
1865     /**
1866      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1867      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1868      */
1869     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1870         external
1871         view
1872         returns (address receiver, uint256 royaltyAmount);
1873 }
1874 
1875 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1876 
1877 
1878 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1879 
1880 pragma solidity ^0.8.0;
1881 
1882 
1883 
1884 /**
1885  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1886  *
1887  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1888  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1889  *
1890  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1891  * fee is specified in basis points by default.
1892  *
1893  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1894  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1895  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1896  *
1897  * _Available since v4.5._
1898  */
1899 abstract contract ERC2981 is IERC2981, ERC165 {
1900     struct RoyaltyInfo {
1901         address receiver;
1902         uint96 royaltyFraction;
1903     }
1904 
1905     RoyaltyInfo private _defaultRoyaltyInfo;
1906     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1907 
1908     /**
1909      * @dev See {IERC165-supportsInterface}.
1910      */
1911     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1912         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1913     }
1914 
1915     /**
1916      * @inheritdoc IERC2981
1917      */
1918     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1919         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1920 
1921         if (royalty.receiver == address(0)) {
1922             royalty = _defaultRoyaltyInfo;
1923         }
1924 
1925         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1926 
1927         return (royalty.receiver, royaltyAmount);
1928     }
1929 
1930     /**
1931      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1932      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1933      * override.
1934      */
1935     function _feeDenominator() internal pure virtual returns (uint96) {
1936         return 10000;
1937     }
1938 
1939     /**
1940      * @dev Sets the royalty information that all ids in this contract will default to.
1941      *
1942      * Requirements:
1943      *
1944      * - `receiver` cannot be the zero address.
1945      * - `feeNumerator` cannot be greater than the fee denominator.
1946      */
1947     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1948         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1949         require(receiver != address(0), "ERC2981: invalid receiver");
1950 
1951         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1952     }
1953 
1954     /**
1955      * @dev Removes default royalty information.
1956      */
1957     function _deleteDefaultRoyalty() internal virtual {
1958         delete _defaultRoyaltyInfo;
1959     }
1960 
1961     /**
1962      * @dev Sets the royalty information for a specific token id, overriding the global default.
1963      *
1964      * Requirements:
1965      *
1966      * - `receiver` cannot be the zero address.
1967      * - `feeNumerator` cannot be greater than the fee denominator.
1968      */
1969     function _setTokenRoyalty(
1970         uint256 tokenId,
1971         address receiver,
1972         uint96 feeNumerator
1973     ) internal virtual {
1974         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1975         require(receiver != address(0), "ERC2981: Invalid parameters");
1976 
1977         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1978     }
1979 
1980     /**
1981      * @dev Resets royalty information for the token id back to the global default.
1982      */
1983     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1984         delete _tokenRoyaltyInfo[tokenId];
1985     }
1986 }
1987 
1988 // File: @openzeppelin/contracts/utils/Context.sol
1989 
1990 
1991 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1992 
1993 pragma solidity ^0.8.0;
1994 
1995 /**
1996  * @dev Provides information about the current execution context, including the
1997  * sender of the transaction and its data. While these are generally available
1998  * via msg.sender and msg.data, they should not be accessed in such a direct
1999  * manner, since when dealing with meta-transactions the account sending and
2000  * paying for execution may not be the actual sender (as far as an application
2001  * is concerned).
2002  *
2003  * This contract is only required for intermediate, library-like contracts.
2004  */
2005 abstract contract Context {
2006     function _msgSender() internal view virtual returns (address) {
2007         return msg.sender;
2008     }
2009 
2010     function _msgData() internal view virtual returns (bytes calldata) {
2011         return msg.data;
2012     }
2013 }
2014 
2015 // File: erc721psi/contracts/ERC721Psi.sol
2016 
2017 
2018 /**
2019   ______ _____   _____ ______ ___  __ _  _  _ 
2020  |  ____|  __ \ / ____|____  |__ \/_ | || || |
2021  | |__  | |__) | |        / /   ) || | \| |/ |
2022  |  __| |  _  /| |       / /   / / | |\_   _/ 
2023  | |____| | \ \| |____  / /   / /_ | |  | |   
2024  |______|_|  \_\\_____|/_/   |____||_|  |_|   
2025 
2026  - github: https://github.com/estarriolvetch/ERC721Psi
2027  - npm: https://www.npmjs.com/package/erc721psi
2028                                           
2029  */
2030 
2031 pragma solidity ^0.8.0;
2032 
2033 
2034 
2035 
2036 
2037 
2038 
2039 
2040 
2041 
2042 
2043 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata {
2044     using Address for address;
2045     using Strings for uint256;
2046     using BitMaps for BitMaps.BitMap;
2047 
2048     BitMaps.BitMap private _batchHead;
2049 
2050     string private _name;
2051     string private _symbol;
2052 
2053     // Mapping from token ID to owner address
2054     mapping(uint256 => address) internal _owners;
2055     uint256 private _currentIndex;
2056 
2057     mapping(uint256 => address) private _tokenApprovals;
2058     mapping(address => mapping(address => bool)) private _operatorApprovals;
2059 
2060     /**
2061      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2062      */
2063     constructor(string memory name_, string memory symbol_) {
2064         _name = name_;
2065         _symbol = symbol_;
2066         _currentIndex = _startTokenId();
2067     }
2068 
2069     /**
2070      * @dev Returns the starting token ID.
2071      * To change the starting token ID, please override this function.
2072      */
2073     function _startTokenId() internal pure virtual returns (uint256) {
2074         // It will become modifiable in the future versions
2075         return 0;
2076     }
2077 
2078     /**
2079      * @dev Returns the next token ID to be minted.
2080      */
2081     function _nextTokenId() internal view virtual returns (uint256) {
2082         return _currentIndex;
2083     }
2084 
2085     /**
2086      * @dev Returns the total amount of tokens minted in the contract.
2087      */
2088     function _totalMinted() internal view virtual returns (uint256) {
2089         return _currentIndex - _startTokenId();
2090     }
2091 
2092 
2093     /**
2094      * @dev See {IERC165-supportsInterface}.
2095      */
2096     function supportsInterface(bytes4 interfaceId)
2097         public
2098         view
2099         virtual
2100         override(ERC165, IERC165)
2101         returns (bool)
2102     {
2103         return
2104             interfaceId == type(IERC721).interfaceId ||
2105             interfaceId == type(IERC721Metadata).interfaceId ||
2106             super.supportsInterface(interfaceId);
2107     }
2108 
2109     /**
2110      * @dev See {IERC721-balanceOf}.
2111      */
2112     function balanceOf(address owner) 
2113         public 
2114         view 
2115         virtual 
2116         override 
2117         returns (uint) 
2118     {
2119         require(owner != address(0), "ERC721Psi: balance query for the zero address");
2120 
2121         uint count;
2122         for( uint i = _startTokenId(); i < _nextTokenId(); ++i ){
2123             if(_exists(i)){
2124                 if( owner == ownerOf(i)){
2125                     ++count;
2126                 }
2127             }
2128         }
2129         return count;
2130     }
2131 
2132     /**
2133      * @dev See {IERC721-ownerOf}.
2134      */
2135     function ownerOf(uint256 tokenId)
2136         public
2137         view
2138         virtual
2139         override
2140         returns (address)
2141     {
2142         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
2143         return owner;
2144     }
2145 
2146     function _ownerAndBatchHeadOf(uint256 tokenId) internal view returns (address owner, uint256 tokenIdBatchHead){
2147         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
2148         tokenIdBatchHead = _getBatchHead(tokenId);
2149         owner = _owners[tokenIdBatchHead];
2150     }
2151 
2152     /**
2153      * @dev See {IERC721Metadata-name}.
2154      */
2155     function name() public view virtual override returns (string memory) {
2156         return _name;
2157     }
2158 
2159     /**
2160      * @dev See {IERC721Metadata-symbol}.
2161      */
2162     function symbol() public view virtual override returns (string memory) {
2163         return _symbol;
2164     }
2165 
2166     /**
2167      * @dev See {IERC721Metadata-tokenURI}.
2168      */
2169     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2170         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
2171 
2172         string memory baseURI = _baseURI();
2173         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2174     }
2175 
2176     /**
2177      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2178      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2179      * by default, can be overriden in child contracts.
2180      */
2181     function _baseURI() internal view virtual returns (string memory) {
2182         return "";
2183     }
2184 
2185 
2186     /**
2187      * @dev See {IERC721-approve}.
2188      */
2189     function approve(address to, uint256 tokenId) public virtual override {
2190         address owner = ownerOf(tokenId);
2191         require(to != owner, "ERC721Psi: approval to current owner");
2192 
2193         require(
2194             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2195             "ERC721Psi: approve caller is not owner nor approved for all"
2196         );
2197 
2198         _approve(to, tokenId);
2199     }
2200 
2201     /**
2202      * @dev See {IERC721-getApproved}.
2203      */
2204     function getApproved(uint256 tokenId)
2205         public
2206         view
2207         virtual
2208         override
2209         returns (address)
2210     {
2211         require(
2212             _exists(tokenId),
2213             "ERC721Psi: approved query for nonexistent token"
2214         );
2215 
2216         return _tokenApprovals[tokenId];
2217     }
2218 
2219     /**
2220      * @dev See {IERC721-setApprovalForAll}.
2221      */
2222     function setApprovalForAll(address operator, bool approved)
2223         public
2224         virtual
2225         override
2226     {
2227         require(operator != _msgSender(), "ERC721Psi: approve to caller");
2228 
2229         _operatorApprovals[_msgSender()][operator] = approved;
2230         emit ApprovalForAll(_msgSender(), operator, approved);
2231     }
2232 
2233     /**
2234      * @dev See {IERC721-isApprovedForAll}.
2235      */
2236     function isApprovedForAll(address owner, address operator)
2237         public
2238         view
2239         virtual
2240         override
2241         returns (bool)
2242     {
2243         return _operatorApprovals[owner][operator];
2244     }
2245 
2246     /**
2247      * @dev See {IERC721-transferFrom}.
2248      */
2249     function transferFrom(
2250         address from,
2251         address to,
2252         uint256 tokenId
2253     ) public virtual override {
2254         //solhint-disable-next-line max-line-length
2255         require(
2256             _isApprovedOrOwner(_msgSender(), tokenId),
2257             "ERC721Psi: transfer caller is not owner nor approved"
2258         );
2259 
2260         _transfer(from, to, tokenId);
2261     }
2262 
2263     /**
2264      * @dev See {IERC721-safeTransferFrom}.
2265      */
2266     function safeTransferFrom(
2267         address from,
2268         address to,
2269         uint256 tokenId
2270     ) public virtual override {
2271         safeTransferFrom(from, to, tokenId, "");
2272     }
2273 
2274     /**
2275      * @dev See {IERC721-safeTransferFrom}.
2276      */
2277     function safeTransferFrom(
2278         address from,
2279         address to,
2280         uint256 tokenId,
2281         bytes memory _data
2282     ) public virtual override {
2283         require(
2284             _isApprovedOrOwner(_msgSender(), tokenId),
2285             "ERC721Psi: transfer caller is not owner nor approved"
2286         );
2287         _safeTransfer(from, to, tokenId, _data);
2288     }
2289 
2290     /**
2291      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2292      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2293      *
2294      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2295      *
2296      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2297      * implement alternative mechanisms to perform token transfer, such as signature-based.
2298      *
2299      * Requirements:
2300      *
2301      * - `from` cannot be the zero address.
2302      * - `to` cannot be the zero address.
2303      * - `tokenId` token must exist and be owned by `from`.
2304      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2305      *
2306      * Emits a {Transfer} event.
2307      */
2308     function _safeTransfer(
2309         address from,
2310         address to,
2311         uint256 tokenId,
2312         bytes memory _data
2313     ) internal virtual {
2314         _transfer(from, to, tokenId);
2315         require(
2316             _checkOnERC721Received(from, to, tokenId, 1,_data),
2317             "ERC721Psi: transfer to non ERC721Receiver implementer"
2318         );
2319     }
2320 
2321     /**
2322      * @dev Returns whether `tokenId` exists.
2323      *
2324      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2325      *
2326      * Tokens start existing when they are minted (`_mint`).
2327      */
2328     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2329         return tokenId < _nextTokenId() && _startTokenId() <= tokenId;
2330     }
2331 
2332     /**
2333      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2334      *
2335      * Requirements:
2336      *
2337      * - `tokenId` must exist.
2338      */
2339     function _isApprovedOrOwner(address spender, uint256 tokenId)
2340         internal
2341         view
2342         virtual
2343         returns (bool)
2344     {
2345         require(
2346             _exists(tokenId),
2347             "ERC721Psi: operator query for nonexistent token"
2348         );
2349         address owner = ownerOf(tokenId);
2350         return (spender == owner ||
2351             getApproved(tokenId) == spender ||
2352             isApprovedForAll(owner, spender));
2353     }
2354 
2355     /**
2356      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2357      *
2358      * Requirements:
2359      *
2360      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2361      * - `quantity` must be greater than 0.
2362      *
2363      * Emits a {Transfer} event.
2364      */
2365     function _safeMint(address to, uint256 quantity) internal virtual {
2366         _safeMint(to, quantity, "");
2367     }
2368 
2369     
2370     function _safeMint(
2371         address to,
2372         uint256 quantity,
2373         bytes memory _data
2374     ) internal virtual {
2375         uint256 nextTokenId = _nextTokenId();
2376         _mint(to, quantity);
2377         require(
2378             _checkOnERC721Received(address(0), to, nextTokenId, quantity, _data),
2379             "ERC721Psi: transfer to non ERC721Receiver implementer"
2380         );
2381     }
2382 
2383 
2384     function _mint(
2385         address to,
2386         uint256 quantity
2387     ) internal virtual {
2388         uint256 nextTokenId = _nextTokenId();
2389         
2390         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
2391         require(to != address(0), "ERC721Psi: mint to the zero address");
2392         
2393         _beforeTokenTransfers(address(0), to, nextTokenId, quantity);
2394         _currentIndex += quantity;
2395         _owners[nextTokenId] = to;
2396         _batchHead.set(nextTokenId);
2397         _afterTokenTransfers(address(0), to, nextTokenId, quantity);
2398         
2399         // Emit events
2400         for(uint256 tokenId=nextTokenId; tokenId < nextTokenId + quantity; tokenId++){
2401             emit Transfer(address(0), to, tokenId);
2402         } 
2403     }
2404 
2405 
2406     /**
2407      * @dev Transfers `tokenId` from `from` to `to`.
2408      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2409      *
2410      * Requirements:
2411      *
2412      * - `to` cannot be the zero address.
2413      * - `tokenId` token must be owned by `from`.
2414      *
2415      * Emits a {Transfer} event.
2416      */
2417     function _transfer(
2418         address from,
2419         address to,
2420         uint256 tokenId
2421     ) internal virtual {
2422         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
2423 
2424         require(
2425             owner == from,
2426             "ERC721Psi: transfer of token that is not own"
2427         );
2428         require(to != address(0), "ERC721Psi: transfer to the zero address");
2429 
2430         _beforeTokenTransfers(from, to, tokenId, 1);
2431 
2432         // Clear approvals from the previous owner
2433         _approve(address(0), tokenId);   
2434 
2435         uint256 subsequentTokenId = tokenId + 1;
2436 
2437         if(!_batchHead.get(subsequentTokenId) &&  
2438             subsequentTokenId < _nextTokenId()
2439         ) {
2440             _owners[subsequentTokenId] = from;
2441             _batchHead.set(subsequentTokenId);
2442         }
2443 
2444         _owners[tokenId] = to;
2445         if(tokenId != tokenIdBatchHead) {
2446             _batchHead.set(tokenId);
2447         }
2448 
2449         emit Transfer(from, to, tokenId);
2450 
2451         _afterTokenTransfers(from, to, tokenId, 1);
2452     }
2453 
2454     /**
2455      * @dev Approve `to` to operate on `tokenId`
2456      *
2457      * Emits a {Approval} event.
2458      */
2459     function _approve(address to, uint256 tokenId) internal virtual {
2460         _tokenApprovals[tokenId] = to;
2461         emit Approval(ownerOf(tokenId), to, tokenId);
2462     }
2463 
2464     /**
2465      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2466      * The call is not executed if the target address is not a contract.
2467      *
2468      * @param from address representing the previous owner of the given token ID
2469      * @param to target address that will receive the tokens
2470      * @param startTokenId uint256 the first ID of the tokens to be transferred
2471      * @param quantity uint256 amount of the tokens to be transfered.
2472      * @param _data bytes optional data to send along with the call
2473      * @return r bool whether the call correctly returned the expected magic value
2474      */
2475     function _checkOnERC721Received(
2476         address from,
2477         address to,
2478         uint256 startTokenId,
2479         uint256 quantity,
2480         bytes memory _data
2481     ) private returns (bool r) {
2482         if (to.isContract()) {
2483             r = true;
2484             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
2485                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2486                     r = r && retval == IERC721Receiver.onERC721Received.selector;
2487                 } catch (bytes memory reason) {
2488                     if (reason.length == 0) {
2489                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
2490                     } else {
2491                         assembly {
2492                             revert(add(32, reason), mload(reason))
2493                         }
2494                     }
2495                 }
2496             }
2497             return r;
2498         } else {
2499             return true;
2500         }
2501     }
2502 
2503     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
2504         tokenIdBatchHead = _batchHead.scanForward(tokenId); 
2505     }
2506 
2507 
2508     function totalSupply() public virtual view returns (uint256) {
2509         return _totalMinted();
2510     }
2511 
2512     /**
2513      * @dev Returns an array of token IDs owned by `owner`.
2514      *
2515      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2516      * It is meant to be called off-chain.
2517      *
2518      * This function is compatiable with ERC721AQueryable.
2519      */
2520     function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
2521         unchecked {
2522             uint256 tokenIdsIdx;
2523             uint256 tokenIdsLength = balanceOf(owner);
2524             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2525             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2526                 if (_exists(i)) {
2527                     if (ownerOf(i) == owner) {
2528                         tokenIds[tokenIdsIdx++] = i;
2529                     }
2530                 }
2531             }
2532             return tokenIds;   
2533         }
2534     }
2535 
2536     /**
2537      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2538      *
2539      * startTokenId - the first token id to be transferred
2540      * quantity - the amount to be transferred
2541      *
2542      * Calling conditions:
2543      *
2544      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2545      * transferred to `to`.
2546      * - When `from` is zero, `tokenId` will be minted for `to`.
2547      */
2548     function _beforeTokenTransfers(
2549         address from,
2550         address to,
2551         uint256 startTokenId,
2552         uint256 quantity
2553     ) internal virtual {}
2554 
2555     /**
2556      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2557      * minting.
2558      *
2559      * startTokenId - the first token id to be transferred
2560      * quantity - the amount to be transferred
2561      *
2562      * Calling conditions:
2563      *
2564      * - when `from` and `to` are both non-zero.
2565      * - `from` and `to` are never both zero.
2566      */
2567     function _afterTokenTransfers(
2568         address from,
2569         address to,
2570         uint256 startTokenId,
2571         uint256 quantity
2572     ) internal virtual {}
2573 }
2574 // File: erc721psi/contracts/extension/ERC721PsiBurnable.sol
2575 
2576 
2577 /**
2578   ______ _____   _____ ______ ___  __ _  _  _ 
2579  |  ____|  __ \ / ____|____  |__ \/_ | || || |
2580  | |__  | |__) | |        / /   ) || | \| |/ |
2581  |  __| |  _  /| |       / /   / / | |\_   _/ 
2582  | |____| | \ \| |____  / /   / /_ | |  | |   
2583  |______|_|  \_\\_____|/_/   |____||_|  |_|   
2584                                               
2585                                             
2586  */
2587 pragma solidity ^0.8.0;
2588 
2589 
2590 
2591 
2592 abstract contract ERC721PsiBurnable is ERC721Psi {
2593     using BitMaps for BitMaps.BitMap;
2594     BitMaps.BitMap private _burnedToken;
2595 
2596     /**
2597      * @dev Destroys `tokenId`.
2598      * The approval is cleared when the token is burned.
2599      *
2600      * Requirements:
2601      *
2602      * - `tokenId` must exist.
2603      *
2604      * Emits a {Transfer} event.
2605      */
2606     function _burn(uint256 tokenId) internal virtual {
2607         address from = ownerOf(tokenId);
2608         _beforeTokenTransfers(from, address(0), tokenId, 1);
2609         _burnedToken.set(tokenId);
2610         
2611         emit Transfer(from, address(0), tokenId);
2612 
2613         _afterTokenTransfers(from, address(0), tokenId, 1);
2614     }
2615 
2616     /**
2617      * @dev Returns whether `tokenId` exists.
2618      *
2619      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2620      *
2621      * Tokens start existing when they are minted (`_mint`),
2622      * and stop existing when they are burned (`_burn`).
2623      */
2624     function _exists(uint256 tokenId) internal view override virtual returns (bool){
2625         if(_burnedToken.get(tokenId)) {
2626             return false;
2627         } 
2628         return super._exists(tokenId);
2629     }
2630 
2631     /**
2632      * @dev See {IERC721Enumerable-totalSupply}.
2633      */
2634     function totalSupply() public view virtual override returns (uint256) {
2635         return _totalMinted() - _burned();
2636     }
2637 
2638     /**
2639      * @dev Returns number of token burned.
2640      */
2641     function _burned() internal view returns (uint256 burned){
2642         uint256 startBucket = _startTokenId() >> 8;
2643         uint256 lastBucket = (_nextTokenId() >> 8) + 1;
2644 
2645         for(uint256 i=startBucket; i < lastBucket; i++) {
2646             uint256 bucket = _burnedToken.getBucket(i);
2647             burned += _popcount(bucket);
2648         }
2649     }
2650 
2651     /**
2652      * @dev Returns number of set bits.
2653      */
2654     function _popcount(uint256 x) private pure returns (uint256 count) {
2655         unchecked{
2656             for (count=0; x!=0; count++)
2657                 x &= x - 1;
2658         }
2659     }
2660 }
2661 // File: @openzeppelin/contracts/access/Ownable.sol
2662 
2663 
2664 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2665 
2666 pragma solidity ^0.8.0;
2667 
2668 
2669 /**
2670  * @dev Contract module which provides a basic access control mechanism, where
2671  * there is an account (an owner) that can be granted exclusive access to
2672  * specific functions.
2673  *
2674  * By default, the owner account will be the one that deploys the contract. This
2675  * can later be changed with {transferOwnership}.
2676  *
2677  * This module is used through inheritance. It will make available the modifier
2678  * `onlyOwner`, which can be applied to your functions to restrict their use to
2679  * the owner.
2680  */
2681 abstract contract Ownable is Context {
2682     address private _owner;
2683 
2684     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2685 
2686     /**
2687      * @dev Initializes the contract setting the deployer as the initial owner.
2688      */
2689     constructor() {
2690         _transferOwnership(_msgSender());
2691     }
2692 
2693     /**
2694      * @dev Throws if called by any account other than the owner.
2695      */
2696     modifier onlyOwner() {
2697         _checkOwner();
2698         _;
2699     }
2700 
2701     /**
2702      * @dev Returns the address of the current owner.
2703      */
2704     function owner() public view virtual returns (address) {
2705         return _owner;
2706     }
2707 
2708     /**
2709      * @dev Throws if the sender is not the owner.
2710      */
2711     function _checkOwner() internal view virtual {
2712         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2713     }
2714 
2715     /**
2716      * @dev Leaves the contract without owner. It will not be possible to call
2717      * `onlyOwner` functions anymore. Can only be called by the current owner.
2718      *
2719      * NOTE: Renouncing ownership will leave the contract without an owner,
2720      * thereby removing any functionality that is only available to the owner.
2721      */
2722     function renounceOwnership() public virtual onlyOwner {
2723         _transferOwnership(address(0));
2724     }
2725 
2726     /**
2727      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2728      * Can only be called by the current owner.
2729      */
2730     function transferOwnership(address newOwner) public virtual onlyOwner {
2731         require(newOwner != address(0), "Ownable: new owner is the zero address");
2732         _transferOwnership(newOwner);
2733     }
2734 
2735     /**
2736      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2737      * Internal function without access restriction.
2738      */
2739     function _transferOwnership(address newOwner) internal virtual {
2740         address oldOwner = _owner;
2741         _owner = newOwner;
2742         emit OwnershipTransferred(oldOwner, newOwner);
2743     }
2744 }
2745 
2746 // File: EXO/NEW/EXO.sol
2747 
2748 //SPDX-License-Identifier: MIT
2749 pragma solidity >=0.6.0;
2750 
2751 /// @title Base64
2752 /// @author Brecht Devos - <brecht@loopring.org>
2753 /// @notice Provides functions for encoding/decoding base64
2754 library Base64 {
2755     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
2756     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
2757                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
2758                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
2759                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
2760 
2761     function encode(bytes memory data) internal pure returns (string memory) {
2762         if (data.length == 0) return '';
2763 
2764         // load the table into memory
2765         string memory table = TABLE_ENCODE;
2766 
2767         // multiply by 4/3 rounded up
2768         uint256 encodedLen = 4 * ((data.length + 2) / 3);
2769 
2770         // add some extra buffer at the end required for the writing
2771         string memory result = new string(encodedLen + 32);
2772 
2773         assembly {
2774             // set the actual output length
2775             mstore(result, encodedLen)
2776 
2777             // prepare the lookup table
2778             let tablePtr := add(table, 1)
2779 
2780             // input ptr
2781             let dataPtr := data
2782             let endPtr := add(dataPtr, mload(data))
2783 
2784             // result ptr, jump over length
2785             let resultPtr := add(result, 32)
2786 
2787             // run over the input, 3 bytes at a time
2788             for {} lt(dataPtr, endPtr) {}
2789             {
2790                 // read 3 bytes
2791                 dataPtr := add(dataPtr, 3)
2792                 let input := mload(dataPtr)
2793 
2794                 // write 4 characters
2795                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2796                 resultPtr := add(resultPtr, 1)
2797                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2798                 resultPtr := add(resultPtr, 1)
2799                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
2800                 resultPtr := add(resultPtr, 1)
2801                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
2802                 resultPtr := add(resultPtr, 1)
2803             }
2804 
2805             // padding with '='
2806             switch mod(mload(data), 3)
2807             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
2808             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
2809         }
2810 
2811         return result;
2812     }
2813 
2814     function decode(string memory _data) internal pure returns (bytes memory) {
2815         bytes memory data = bytes(_data);
2816 
2817         if (data.length == 0) return new bytes(0);
2818         require(data.length % 4 == 0, "invalid base64 decoder input");
2819 
2820         // load the table into memory
2821         bytes memory table = TABLE_DECODE;
2822 
2823         // every 4 characters represent 3 bytes
2824         uint256 decodedLen = (data.length / 4) * 3;
2825 
2826         // add some extra buffer at the end required for the writing
2827         bytes memory result = new bytes(decodedLen + 32);
2828 
2829         assembly {
2830             // padding with '='
2831             let lastBytes := mload(add(data, mload(data)))
2832             if eq(and(lastBytes, 0xFF), 0x3d) {
2833                 decodedLen := sub(decodedLen, 1)
2834                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
2835                     decodedLen := sub(decodedLen, 1)
2836                 }
2837             }
2838 
2839             // set the actual output length
2840             mstore(result, decodedLen)
2841 
2842             // prepare the lookup table
2843             let tablePtr := add(table, 1)
2844 
2845             // input ptr
2846             let dataPtr := data
2847             let endPtr := add(dataPtr, mload(data))
2848 
2849             // result ptr, jump over length
2850             let resultPtr := add(result, 32)
2851 
2852             // run over the input, 4 characters at a time
2853             for {} lt(dataPtr, endPtr) {}
2854             {
2855                // read 4 characters
2856                dataPtr := add(dataPtr, 4)
2857                let input := mload(dataPtr)
2858 
2859                // write 3 bytes
2860                let output := add(
2861                    add(
2862                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
2863                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
2864                    add(
2865                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
2866                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
2867                     )
2868                 )
2869                 mstore(resultPtr, shl(232, output))
2870                 resultPtr := add(resultPtr, 3)
2871             }
2872         }
2873 
2874         return result;
2875     }
2876 }
2877 
2878 
2879 
2880 
2881 
2882 
2883 pragma solidity ^0.8.7;
2884 
2885 
2886 abstract contract MerkleProof {
2887     bytes32 internal _wlMerkleRoot;
2888     bytes32 internal _pbMerkleRoot;
2889     mapping(uint256 => bytes32) internal _alMerkleRoot;
2890     uint256 public phaseId;
2891 
2892     function _setWlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2893         _wlMerkleRoot = merkleRoot_;
2894     }
2895     function isWhitelisted(address address_, uint256 wlCount, bytes32[] memory proof_) public view returns (bool) {
2896         bytes32 _leaf = keccak256(abi.encodePacked(address_, wlCount));
2897         for (uint256 i = 0; i < proof_.length; i++) {
2898             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2899         }
2900         return _leaf == _wlMerkleRoot;
2901     }
2902 
2903     function _setAlMerkleRootWithId(uint256 _phaseId,bytes32 merkleRoot_) internal virtual {
2904         _alMerkleRoot[_phaseId] = merkleRoot_;
2905     }
2906 
2907     function _setAlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2908         _alMerkleRoot[phaseId] = merkleRoot_;
2909     }
2910 
2911     function isAllowlisted(address address_,uint256 _phaseId, bytes32[] memory proof_) public view returns (bool) {
2912         bytes32 _leaf = keccak256(abi.encodePacked(address_));
2913         for (uint256 i = 0; i < proof_.length; i++) {
2914             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2915         }
2916         return _leaf == _alMerkleRoot[_phaseId];
2917     }
2918 
2919     function _setPlMerkleRoot(bytes32 merkleRoot_) internal virtual {
2920         _pbMerkleRoot = merkleRoot_;
2921     }
2922 
2923     function isPubliclisted(address address_, bytes32[] memory proof_) public view returns (bool) {
2924         bytes32 _leaf = keccak256(abi.encodePacked(address_));
2925         for (uint256 i = 0; i < proof_.length; i++) {
2926             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
2927         }
2928         return _leaf == _pbMerkleRoot;
2929     }
2930 
2931 }
2932 
2933 pragma solidity ^0.8.9;
2934 abstract contract Operable is Context {
2935     mapping(address => bool) _operators;
2936     modifier onlyOperator() {
2937         _checkOperatorRole(_msgSender());
2938         _;
2939     }
2940     function isOperator(address _operator) public view returns (bool) {
2941         return _operators[_operator];
2942     }
2943     function _grantOperatorRole(address _candidate) internal {
2944         require(
2945             !_operators[_candidate],
2946             string(
2947                 abi.encodePacked(
2948                     "account ",
2949                     Strings.toHexString(uint160(_msgSender()), 20),
2950                     " is already has an operator role"
2951                 )
2952             )
2953         );
2954         _operators[_candidate] = true;
2955     }
2956     function _revokeOperatorRole(address _candidate) internal {
2957         _checkOperatorRole(_candidate);
2958         delete _operators[_candidate];
2959     }
2960     function _checkOperatorRole(address _operator) internal view {
2961         require(
2962             _operators[_operator],
2963             string(
2964                 abi.encodePacked(
2965                     "account ",
2966                     Strings.toHexString(uint160(_msgSender()), 20),
2967                     " is not an operator"
2968                 )
2969             )
2970         );
2971     }
2972 }
2973 
2974 pragma solidity ^0.8.13;
2975 
2976 interface IOperatorFilterRegistry {
2977     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2978     function register(address registrant) external;
2979     function registerAndSubscribe(address registrant, address subscription) external;
2980     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2981     function unregister(address addr) external;
2982     function updateOperator(address registrant, address operator, bool filtered) external;
2983     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2984     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2985     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2986     function subscribe(address registrant, address registrantToSubscribe) external;
2987     function unsubscribe(address registrant, bool copyExistingEntries) external;
2988     function subscriptionOf(address addr) external returns (address registrant);
2989     function subscribers(address registrant) external returns (address[] memory);
2990     function subscriberAt(address registrant, uint256 index) external returns (address);
2991     function copyEntriesOf(address registrant, address registrantToCopy) external;
2992     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2993     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2994     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2995     function filteredOperators(address addr) external returns (address[] memory);
2996     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2997     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2998     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2999     function isRegistered(address addr) external returns (bool);
3000     function codeHashOf(address addr) external returns (bytes32);
3001 }
3002 
3003 pragma solidity ^0.8.13;
3004 
3005 
3006 /**
3007  * @title  OperatorFilterer
3008  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3009  *         registrant's entries in the OperatorFilterRegistry.
3010  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3011  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3012  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3013  */
3014 abstract contract OperatorFilterer {
3015     error OperatorNotAllowed(address operator);
3016     bool public operatorFilteringEnabled = true;
3017 
3018     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3019         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3020 
3021     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3022         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3023         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3024         // order for the modifier to filter addresses.
3025         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3026             if (subscribe) {
3027                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
3028             } else {
3029                 if (subscriptionOrRegistrantToCopy != address(0)) {
3030                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
3031                 } else {
3032                     OPERATOR_FILTER_REGISTRY.register(address(this));
3033                 }
3034             }
3035         }
3036     }
3037 
3038     modifier onlyAllowedOperator(address from) virtual {
3039         // Check registry code length to facilitate testing in environments without a deployed registry.
3040         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
3041             // Allow spending tokens from addresses with balance
3042             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3043             // from an EOA.
3044             if (from == msg.sender) {
3045                 _;
3046                 return;
3047             }
3048             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
3049                 revert OperatorNotAllowed(msg.sender);
3050             }
3051         }
3052         _;
3053     }
3054 
3055     modifier onlyAllowedOperatorApproval(address operator) virtual {
3056         // Check registry code length to facilitate testing in environments without a deployed registry.
3057         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
3058             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
3059                 revert OperatorNotAllowed(operator);
3060             }
3061         }
3062         _;
3063     }
3064 }
3065 
3066 
3067 pragma solidity ^0.8.13;
3068 /**
3069  * @title  DefaultOperatorFilterer
3070  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3071  */
3072 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3073     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3074 
3075     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3076 }
3077 
3078 
3079 
3080 
3081 
3082 pragma solidity >=0.7.0 <0.9.0;
3083 
3084 interface IContractAllowListProxy {
3085     function isAllowed(address _transferer, uint256 _level)
3086         external
3087         view
3088         returns (bool);
3089 }
3090 
3091 pragma solidity >=0.8.0;
3092 
3093 /// @title IERC721RestrictApprove
3094 /// @dev Approve抑制機能付きコントラクトのインターフェース
3095 /// @author Lavulite
3096 
3097 interface IERC721RestrictApprove {
3098     /**
3099      * @dev CALレベルが変更された場合のイベント
3100      */
3101     event CalLevelChanged(address indexed operator, uint256 indexed level);
3102     
3103     /**
3104      * @dev LocalContractAllowListnに追加された場合のイベント
3105      */
3106     event LocalCalAdded(address indexed operator, address indexed transferer);
3107 
3108     /**
3109      * @dev LocalContractAllowListnに削除された場合のイベント
3110      */
3111     event LocalCalRemoved(address indexed operator, address indexed transferer);
3112 
3113     /**
3114      * @dev CALを利用する場合のCALのレベルを設定する。レベルが高いほど、許可されるコントラクトの範囲が狭い。
3115      */
3116     function setCALLevel(uint256 level) external;
3117 
3118     /**
3119      * @dev CALのアドレスをセットする。
3120      */
3121     function setCAL(address calAddress) external;
3122 
3123     /**
3124      * @dev CALのリストに無い独自の許可アドレスを追加する場合、こちらにアドレスを記載する。
3125      */
3126     function addLocalContractAllowList(address transferer) external;
3127 
3128     /**
3129      * @dev CALのリストにある独自の許可アドレスを削除する場合、こちらにアドレスを記載する。
3130      */
3131     function removeLocalContractAllowList(address transferer) external;
3132 
3133     /**
3134      * @dev CALのリストにある独自の許可アドレスの一覧を取得する。
3135      */
3136     function getLocalContractAllowList() external view returns(address[] memory);
3137 
3138 }
3139 
3140 pragma solidity >=0.8.0;
3141 
3142 /// @title AntiScam機能付きERC721A
3143 /// @dev Readmeを見てください。
3144 
3145 abstract contract ERC721RestrictApprove is ERC721PsiBurnable, IERC721RestrictApprove {
3146     using EnumerableSet for EnumerableSet.AddressSet;
3147 
3148     IContractAllowListProxy public CAL;
3149     EnumerableSet.AddressSet localAllowedAddresses;
3150 
3151     modifier onlyHolder(uint256 tokenId) {
3152         require(
3153             msg.sender == ownerOf(tokenId),
3154             "RestrictApprove: operation is only holder."
3155         );
3156         _;
3157     }
3158 
3159     /*//////////////////////////////////////////////////////////////
3160     変数
3161     //////////////////////////////////////////////////////////////*/
3162     bool public enableRestrict = true;
3163 
3164     // token lock
3165     mapping(uint256 => uint256) public tokenCALLevel;
3166 
3167     // wallet lock
3168     mapping(address => uint256) public walletCALLevel;
3169 
3170     // contract lock
3171     uint256 public CALLevel = 1;
3172 
3173     /*///////////////////////////////////////////////////////////////
3174     Approve抑制機能ロジック
3175     //////////////////////////////////////////////////////////////*/
3176     function _addLocalContractAllowList(address transferer)
3177         internal
3178         virtual
3179     {
3180         localAllowedAddresses.add(transferer);
3181         emit LocalCalAdded(msg.sender, transferer);
3182     }
3183 
3184     function _removeLocalContractAllowList(address transferer)
3185         internal
3186         virtual
3187     {
3188         localAllowedAddresses.remove(transferer);
3189         emit LocalCalRemoved(msg.sender, transferer);
3190     }
3191 
3192     function _getLocalContractAllowList()
3193         internal
3194         virtual
3195         view
3196         returns(address[] memory)
3197     {
3198         return localAllowedAddresses.values();
3199     }
3200 
3201     function _isLocalAllowed(address transferer)
3202         internal
3203         view
3204         virtual
3205         returns (bool)
3206     {
3207         return localAllowedAddresses.contains(transferer);
3208     }
3209 
3210     function _isAllowed(address transferer)
3211         internal
3212         view
3213         virtual
3214         returns (bool)
3215     {
3216         return _isAllowed(msg.sender, transferer);
3217     }
3218 
3219     function _isAllowed(uint256 tokenId, address transferer)
3220         internal
3221         view
3222         virtual
3223         returns (bool)
3224     {
3225         uint256 level = _getCALLevel(msg.sender, tokenId);
3226         return _isAllowed(transferer, level);
3227     }
3228 
3229     function _isAllowed(address holder, address transferer)
3230         internal
3231         view
3232         virtual
3233         returns (bool)
3234     {
3235         uint256 level = _getCALLevel(holder);
3236         return _isAllowed(transferer, level);
3237     }
3238 
3239     function _isAllowed(address transferer, uint256 level)
3240         internal
3241         view
3242         virtual
3243         returns (bool)
3244     {
3245         if (!enableRestrict) {
3246             return true;
3247         }
3248 
3249         return _isLocalAllowed(transferer) || CAL.isAllowed(transferer, level);
3250     }
3251 
3252     function _getCALLevel(address holder, uint256 tokenId)
3253         internal
3254         view
3255         virtual
3256         returns (uint256)
3257     {
3258         if (tokenCALLevel[tokenId] > 0) {
3259             return tokenCALLevel[tokenId];
3260         }
3261 
3262         return _getCALLevel(holder);
3263     }
3264 
3265     function _getCALLevel(address holder)
3266         internal
3267         view
3268         virtual
3269         returns (uint256)
3270     {
3271         if (walletCALLevel[holder] > 0) {
3272             return walletCALLevel[holder];
3273         }
3274 
3275         return CALLevel;
3276     }
3277 
3278     function _setCAL(address _cal) internal virtual {
3279         CAL = IContractAllowListProxy(_cal);
3280     }
3281 
3282     function _deleteTokenCALLevel(uint256 tokenId) internal virtual {
3283         delete tokenCALLevel[tokenId];
3284     }
3285 
3286     function setTokenCALLevel(uint256 tokenId, uint256 level)
3287         external
3288         virtual
3289         onlyHolder(tokenId)
3290     {
3291         tokenCALLevel[tokenId] = level;
3292     }
3293 
3294     function setWalletCALLevel(uint256 level)
3295         external
3296         virtual
3297     {
3298         walletCALLevel[msg.sender] = level;
3299     }
3300 
3301     /*///////////////////////////////////////////////////////////////
3302                               OVERRIDES
3303     //////////////////////////////////////////////////////////////*/
3304 
3305     function isApprovedForAll(address owner, address operator)
3306         public
3307         view
3308         virtual
3309         override
3310         returns (bool)
3311     {
3312         if (_isAllowed(owner, operator) == false) {
3313             return false;
3314         }
3315         return super.isApprovedForAll(owner, operator);
3316     }
3317 
3318     function setApprovalForAll(address operator, bool approved)
3319         public
3320         virtual
3321         override
3322     {
3323         require(
3324             _isAllowed(operator) || approved == false,
3325             "RestrictApprove: Can not approve locked token"
3326         );
3327         super.setApprovalForAll(operator, approved);
3328     }
3329 
3330     function _beforeApprove(address to, uint256 tokenId)
3331         internal
3332         virtual
3333     {
3334         if (to != address(0)) {
3335             require(_isAllowed(tokenId, to), "RestrictApprove: The contract is not allowed.");
3336         }
3337     }
3338 
3339     function approve(address to, uint256 tokenId)
3340         public
3341         virtual
3342         override
3343     {
3344         _beforeApprove(to, tokenId);
3345         super.approve(to, tokenId);
3346     }
3347 
3348     function _afterTokenTransfers(
3349         address from,
3350         address, /*to*/
3351         uint256 startTokenId,
3352         uint256 /*quantity*/
3353     ) internal virtual override {
3354         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
3355         if (from != address(0)) {
3356             // CALレベルをデフォルトに戻す。
3357             _deleteTokenCALLevel(startTokenId);
3358         }
3359     }
3360 
3361     function supportsInterface(bytes4 interfaceId)
3362         public
3363         view
3364         virtual
3365         override
3366         returns (bool)
3367     {
3368         return
3369             interfaceId == type(IERC721RestrictApprove).interfaceId ||
3370             super.supportsInterface(interfaceId);
3371     }
3372 }
3373 
3374 
3375 pragma solidity ^0.8.7;
3376 /*
3377 
3378 ╭━━━┳━╮╱╭┳╮╭╮╭╮╭━━━┳━━━━┳━━━┳━━━┳━━━━╮╭┳━━━┳━╮╱╭╮
3379 ┃╭━╮┃┃╰╮┃┃┃┃┃┃┃┃╭━╮┃╭╮╭╮┃╭━╮┃╭━╮┃╭╮╭╮┃┃┃╭━╮┃┃╰╮┃┃
3380 ┃┃╱╰┫╭╮╰╯┃┃┃┃┃by╰━━╋╯┃┃╰┫┃╱┃┃╰━╯┣╯┃┃╰╯┃┃╰━╯┃╭╮╰╯┃
3381 ┃┃╱╭┫┃╰╮┃┃╰╯╰╯┃╰━━╮┃╱┃┃╱┃╰━╯┃╭╮╭╯╱┃┃╭╮┃┃╭━━┫┃╰╮┃┃
3382 ┃╰━╯┃┃╱┃┃┣╮╭╮╭╯┃╰━╯┃╱┃┃╱┃╭━╮┃┃┃╰╮╱┃┃┃╰╯┃┃╱╱┃┃╱┃┃┃
3383 ╰━━━┻╯╱╰━╯╰╯╰╯╱╰━━━╯╱╰╯╱╰╯╱╰┻╯╰━╯╱╰╯╰━━┻╯╱╱╰╯╱╰━╯
3384 -CNW by STARTJPN-
3385 */
3386 contract CRYPTONINJAWORLD is Ownable, ERC721RestrictApprove, ReentrancyGuard, MerkleProof, ERC2981, DefaultOperatorFilterer,Operable {
3387   //Project Settings
3388   uint256 public wlMintPrice = 0.001 ether;
3389   uint256 public alMintPrice = 0.001 ether;
3390   uint256 public psMintPrice = 0.002 ether;
3391   mapping(uint256 => uint256) public maxMintsPerAL;
3392   uint256 public maxMintsPerPS = 2;
3393   uint256 public maxMintsPerALOT = 1;
3394   uint256 public maxMintsPerPSOT = 1;
3395   uint256 public maxSupply = 22222;
3396   uint256 public mintable = 11111;
3397   uint256 public revealed = 0;
3398   uint256 public nowPhaseWl;
3399   uint256 public nowPhaseAl;
3400   uint256 public nowPhasePs;
3401   uint256 public maxReveal;
3402   uint256 public cntBlock;// = 604800;
3403 
3404   address public deployer;
3405   address internal _withdrawWallet;
3406 
3407   //URI
3408   string internal hiddenURI;
3409   string internal _baseTokenURI;
3410   string public _baseExtension = ".json";
3411 
3412   //flags
3413   bool public isWlSaleEnabled;
3414   bool public isAlSaleEnabled;
3415   bool public isPublicSaleEnabled;
3416   bool public isPublicSaleMPEnabled;
3417   bool internal hodlTimSys = false;
3418 
3419   //mint records.
3420   mapping(uint256 => mapping(address => uint256)) internal _wlMinted;
3421   mapping(uint256 => mapping(address => uint256)) internal _alMinted;
3422   mapping(uint256 => mapping(address => uint256)) internal _psMinted;
3423   mapping(uint256 => uint256) internal _updateAt;
3424   mapping(uint256 => int256) internal _lockTim;
3425   constructor (
3426     address _royaltyReceiver,
3427     uint96 _royaltyFraction
3428   ) ERC721Psi ("CRYPTONINJA WORLD","CNW") {
3429     deployer = msg.sender;
3430     _grantOperatorRole(deployer);
3431     _grantOperatorRole(_royaltyReceiver);
3432     _setDefaultRoyalty(_royaltyReceiver,_royaltyFraction);
3433     //CAL initialization
3434     setCALLevel(1);
3435     _setCAL(0xF2A78c73ffBAB6ECc3548Acc54B546ace279312E);//Ethereum mainnet proxy
3436     _addLocalContractAllowList(0x1E0049783F008A0085193E00003D00cd54003c71);//OpenSea
3437     _addLocalContractAllowList(0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be);//Rarible
3438     _addLocalContractAllowList(0x000000000000Ad05Ccc4F10045630fb830B95127);//BLUR
3439     operatorFilteringEnabled = false;
3440     maxMintsPerAL[0] = 1;
3441     maxMintsPerAL[1] = 1;
3442     maxMintsPerAL[2] = 2;
3443   }
3444   //start from 1.adjust.
3445   function _startTokenId() internal pure virtual override returns (uint256) {
3446         return 1;
3447   }
3448   //set Default Royalty._feeNumerator 500 = 5% Royalty
3449   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external virtual onlyOperator {
3450       _setDefaultRoyalty(_receiver, _feeNumerator);
3451   }
3452   //for ERC2981
3453   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721RestrictApprove, ERC2981) returns (bool) {
3454     return super.supportsInterface(interfaceId);
3455   }
3456   //for ERC2981 Opensea
3457   function contractURI() external view virtual returns (string memory) {
3458         return _formatContractURI();
3459   }
3460   //make contractURI
3461   function _formatContractURI() internal view returns (string memory) {
3462     (address receiver, uint256 royaltyFraction) = royaltyInfo(0,_feeDenominator());//tokenid=0
3463     return string(
3464       abi.encodePacked(
3465         "data:application/json;base64,",
3466         Base64.encode(
3467           bytes(
3468             abi.encodePacked(
3469                 '{"seller_fee_basis_points":', Strings.toString(royaltyFraction),
3470                 ', "fee_recipient":"', Strings.toHexString(uint256(uint160(receiver)), 20), '"}'
3471             )
3472           )
3473         )
3474       )
3475     );
3476   }
3477   function setDeployer(address _deployer) external virtual onlyOperator {
3478     deployer = _deployer;
3479   }
3480   //set maxSupply.only owner.
3481   function setMaxSupply(uint256 _maxSupply) external virtual onlyOperator {
3482     require(totalSupply() <= _maxSupply, "Lower than _currentIndex.");
3483     maxSupply = _maxSupply;
3484   }
3485   function setMintable(uint256 _mintable) external virtual onlyOperator {
3486     require(totalSupply() <= _mintable, "Lower than _currentIndex.");
3487     mintable = _mintable;
3488   }
3489     // GET phaseId.
3490   function getPhaseId() external view virtual returns (uint256){
3491     return phaseId;
3492   }
3493     // SET phaseId.
3494   function setPhaseId(uint256 _phaseId) external virtual onlyOperator {
3495     phaseId = _phaseId;
3496   }
3497     // SET phaseId.
3498   function setPhaseIdWithReset(uint256 _phaseId) external virtual onlyOperator {
3499     phaseId = _phaseId;
3500     nowPhaseAl += 1;
3501   }
3502   //now.phase
3503   function setNowPhase(uint256 _nowPhase) external virtual onlyOperator {
3504     nowPhaseWl = _nowPhase;
3505     nowPhaseAl = _nowPhase;
3506     nowPhasePs = _nowPhase;
3507   }
3508   function setNowPhaseWl(uint256 _nowPhaseWl) external virtual onlyOperator {
3509     nowPhaseWl = _nowPhaseWl;
3510   }
3511   function setNowPhaseAl(uint256 _nowPhaseAl) external virtual onlyOperator {
3512     nowPhaseAl = _nowPhaseAl;
3513   }
3514   function setNowPhasePs(uint256 _nowPhasePs) external virtual onlyOperator {
3515     nowPhasePs = _nowPhasePs;
3516   }
3517   // SET PRICES.
3518   //WL.Price
3519   function setWlPrice(uint256 newPrice) external virtual onlyOperator {
3520     wlMintPrice = newPrice;
3521   }
3522   //AL.Price
3523   function setAlPrice(uint256 newPrice) external virtual onlyOperator {
3524     alMintPrice = newPrice;
3525   }
3526   //PS.Price
3527   function setPsPrice(uint256 newPrice) external virtual onlyOperator {
3528     psMintPrice = newPrice;
3529   }
3530   //set reveal.only owner.
3531   function setReveal(uint256 newRevealNum) external virtual onlyOperator {
3532     revealed = newRevealNum;
3533   }
3534   //return _isRevealed()
3535   function _isRevealed(uint256 _tokenId) internal view virtual returns (bool){
3536     return _tokenId <= revealed;
3537   }
3538   // GET MINTED COUNT.
3539   function wlMinted(address _address) external view virtual returns (uint256){
3540     return _wlMinted[nowPhaseWl][_address];
3541   }
3542   function alMinted(address _address) external view virtual returns (uint256){
3543     return _alMinted[nowPhaseAl][_address];
3544   }
3545   function alIdMinted(uint256 _nowPhaseAl,address _address) external view virtual returns (uint256){
3546     return _alMinted[_nowPhaseAl][_address];
3547   }
3548   function psMinted(address _address) external view virtual returns (uint256){
3549     return _psMinted[nowPhasePs][_address];
3550   }
3551   // SET MAX MINTS.
3552   //get.AL.mxmints
3553   function getAlMaxMints() external view virtual returns (uint256){
3554     return maxMintsPerAL[phaseId];
3555   }
3556   //set.AL.mxmints
3557   function setAlMaxMints(uint256 _phaseId,uint256 _max) external virtual onlyOperator {
3558     maxMintsPerAL[_phaseId] = _max;
3559   }
3560   //PS.mxmints
3561   function setPsMaxMints(uint256 _max) external virtual onlyOperator {
3562     maxMintsPerPS = _max;
3563   }
3564   // SET SALES ENABLE.
3565   //WL.SaleEnable
3566   function setWhitelistSaleEnable(bool bool_) external virtual onlyOperator {
3567     isWlSaleEnabled = bool_;
3568   }
3569   //AL.SaleEnable
3570   function setAllowlistSaleEnable(bool bool_) external virtual onlyOperator {
3571     isAlSaleEnabled = bool_;
3572   }
3573   //PS.SaleEnable
3574   function setPublicSaleEnable(bool bool_) external virtual onlyOperator {
3575     isPublicSaleEnabled = bool_;
3576   }
3577   //PSMP.SaleEnable
3578   function setPublicSaleMPEnable(bool bool_) external virtual onlyOperator {
3579     isPublicSaleMPEnabled = bool_;
3580   }
3581   // SET MERKLE ROOT.
3582   function setMerkleRootWl(bytes32 merkleRoot_) external virtual onlyOperator {
3583     _setWlMerkleRoot(merkleRoot_);
3584   }
3585   function setMerkleRootAlWithId(uint256 _phaseId,bytes32 merkleRoot_) external virtual onlyOperator {
3586     _setAlMerkleRootWithId(_phaseId,merkleRoot_);
3587   }
3588   function setMerkleRootPl(bytes32 merkleRoot_) external virtual onlyOperator {
3589     _setPlMerkleRoot(merkleRoot_);
3590   }
3591   //set HiddenBaseURI.only owner.
3592   function setHiddenURI(string memory uri_) external virtual onlyOperator {
3593     hiddenURI = uri_;
3594   }
3595   //return _currentIndex
3596   function getCurrentIndex() external view virtual returns (uint256){
3597     return _nextTokenId() -1;
3598   }
3599 
3600   /** @dev set BaseURI at after reveal. only owner. */
3601   function setBaseURI(string memory uri_) external virtual onlyOperator {
3602     _baseTokenURI = uri_;
3603   }
3604 
3605 
3606   function setBaseExtension(string memory _newBaseExtension) external onlyOperator
3607   {
3608     _baseExtension = _newBaseExtension;
3609   }
3610 
3611   /** @dev BaseURI.internal. */
3612   function _currentBaseURI() internal view returns (string memory){
3613     return _baseTokenURI;
3614   }
3615 
3616 
3617   function getTokenTim(uint256 _tokenId) external view  virtual returns (uint256) {
3618     require(_exists(_tokenId), "URI query for nonexistent token");
3619       return _updateAt[_tokenId];
3620   }
3621 
3622   function getTokenTimId(uint256 _tokenId) internal view  virtual returns (int256) {
3623     require(_exists(_tokenId), "URI query for nonexistent token");
3624     int256 revealId = (int256(block.timestamp)-int256(_updateAt[_tokenId])) / int256(cntBlock);
3625     if (revealId >= int256(maxReveal)){
3626         revealId = int256(maxReveal);
3627     }
3628     return revealId;
3629   }
3630   /** @dev fixrevId. */
3631   function fixToken(uint256 _tokenId) external virtual {
3632     require(_exists(_tokenId), "URI query for nonexistent token");
3633     require(ownerOf(_tokenId) == msg.sender, "isnt owner token");
3634     if(_isRevealed(_tokenId)){
3635         if(hodlTimSys){
3636             int256 revealId = getTokenTimId(_tokenId);
3637             _lockTim[_tokenId] = revealId;
3638         }
3639     }
3640   }
3641   /** @dev unfixrevId. */
3642   function unfixToken(uint256 _tokenId) external virtual {
3643     require(_exists(_tokenId), "URI query for nonexistent token");
3644     require(ownerOf(_tokenId) == msg.sender, "isnt owner token");
3645     _lockTim[_tokenId] = 0;
3646   }
3647   // SET MAX Rev.
3648   function setmaxReveal(uint256 _max) external virtual onlyOwner {
3649     maxReveal = _max;
3650   }
3651   // SET Cntable.
3652   function setcntBlock(uint256 _cnt) external virtual onlyOwner {
3653     cntBlock = _cnt;
3654   }
3655   function _beforeTokenTransfers(address from,address to,uint256 startTokenId,uint256 quantity) internal override {
3656     _updateAt[startTokenId] = block.timestamp;
3657     uint256 updatedIndex = startTokenId;
3658     uint256 end = updatedIndex + quantity;
3659     do {
3660       _updateAt[updatedIndex++] = block.timestamp;
3661     } while (updatedIndex < end);
3662     super._beforeTokenTransfers(from, to, startTokenId, quantity);
3663   }
3664 
3665   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3666     require(_exists(_tokenId), "URI query for nonexistent token");
3667     if(_isRevealed(_tokenId)){
3668         if(_lockTim[_tokenId] > 0){
3669             return string(abi.encodePacked(_currentBaseURI(), Strings.toString(uint256(_lockTim[_tokenId])) ,"/", Strings.toString((_tokenId)), _baseExtension));
3670         }
3671         if(hodlTimSys){
3672             int256 revealId = getTokenTimId(_tokenId);
3673             return string(abi.encodePacked(_currentBaseURI(), Strings.toString(uint256(revealId)) ,"/", Strings.toString((_tokenId)), _baseExtension));
3674         }
3675         return string(abi.encodePacked(_currentBaseURI(), Strings.toString(_tokenId), _baseExtension));
3676     }
3677     return hiddenURI;
3678   }
3679   /** @dev owner mint.transfer to _address.only owner. */
3680   function ownerMint(uint256 _amount, address _address) external virtual onlyOperator { 
3681     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
3682     _safeMint(_address, _amount);
3683   }
3684   //WL mint.
3685   function whitelistMint(uint256 _amount, uint256 wlcount, bytes32[] memory proof_) external payable virtual nonReentrant {
3686     require(isWlSaleEnabled, "whitelistMint is Paused");
3687     require(isWhitelisted(msg.sender, wlcount, proof_), "You are not whitelisted!");
3688     require(wlcount > 0, "You have no WL!");
3689     require(wlcount >= _amount, "whitelistMint: Over max mints per wallet");
3690     require(wlcount >= _wlMinted[nowPhaseWl][msg.sender] + _amount, "You have no whitelistMint left");
3691     require(msg.value == wlMintPrice * _amount, "ETH value is not correct");
3692     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3693     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
3694 
3695     _wlMinted[nowPhaseWl][msg.sender] += _amount;
3696     _safeMint(msg.sender, _amount);
3697   }
3698   
3699     //AL mint.
3700   function allowlistMint(uint256 _amount, bytes32[] memory proof_) external payable virtual nonReentrant {
3701     require(isAlSaleEnabled, "allowlistMint is Paused");
3702     require(isAllowlisted(msg.sender,phaseId, proof_), "You are not whitelisted!");
3703     require(maxMintsPerALOT >= _amount, "allowlistMint: Over max mints per one time");
3704     require(maxMintsPerAL[phaseId] >= _amount, "allowlistMint: Over max mints per wallet");
3705     require(maxMintsPerAL[phaseId] >= _alMinted[nowPhaseAl][msg.sender] + _amount, "You have no whitelistMint left");
3706     require(msg.value == alMintPrice * _amount, "ETH value is not correct");
3707     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3708     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
3709     _alMinted[nowPhaseAl][msg.sender] += _amount;
3710     _safeMint(msg.sender, _amount);
3711   }
3712 
3713   //Public mint.
3714   function publicMint(uint256 _amount) external payable virtual nonReentrant {
3715     require(isPublicSaleEnabled, "publicMint is Paused");
3716     require(maxMintsPerPSOT >= _amount, "publicMint: Over max mints per one time");
3717     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
3718     require(maxMintsPerPS >= _psMinted[nowPhasePs][msg.sender] + _amount, "You have no publicMint left");
3719     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
3720     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3721     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
3722     _psMinted[nowPhasePs][msg.sender] += _amount;
3723     _safeMint(msg.sender, _amount);
3724   }
3725 
3726   //Public mint.
3727   function publicMintMP(uint256 _amount, bytes32[] memory proof_) external payable virtual nonReentrant {
3728     require(isPublicSaleMPEnabled, "publicMint is Paused");
3729     require(isPubliclisted(msg.sender, proof_), "You are not whitelisted!");
3730     require(maxMintsPerPSOT >= _amount, "publicMint: Over max mints per one time");
3731     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
3732     require(maxMintsPerPS >= _psMinted[nowPhasePs][msg.sender] + _amount, "You have no publicMint left");
3733     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
3734     require((_amount + totalSupply()) <= (mintable), "No more NFTs");
3735     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
3736     _psMinted[nowPhasePs][msg.sender] += _amount;
3737     _safeMint(msg.sender, _amount);
3738   }
3739 
3740   //burn
3741   function burn(uint256 tokenId) external virtual {
3742     _burn(tokenId);
3743   }
3744 
3745   /** @dev receive. */
3746   function receiveToDeb() external payable virtual nonReentrant {
3747       require(msg.value > 0, "ETH value is not correct");
3748   }
3749   /** @dev widraw ETH from this contract.only operator. */
3750   function withdraw() external payable virtual onlyOperator nonReentrant{
3751     uint256 _ethBalance = address(this).balance;
3752     bool os;
3753     if(_withdrawWallet != address(0)){//if _withdrawWallet has.
3754         (os, ) = payable(_withdrawWallet).call{value: (_ethBalance)}("");
3755     }else{
3756         (os, ) = payable(owner()).call{value: (_ethBalance)}("");
3757     }
3758     require(os, "Failed to withdraw Ether");
3759   }
3760   //return wallet owned tokenids.
3761   function walletOfOwner(address _address) external view virtual returns (uint256[] memory) {
3762     uint256 ownerTokenCount = balanceOf(_address);
3763     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3764     //search from all tonkenid. so spend high gas values.attention.
3765     uint256 tokenindex = 0;
3766     for (uint256 i = _startTokenId(); i < (_nextTokenId() -1); i++) {
3767       if(_address == this.tryOwnerOf(i)) tokenIds[tokenindex++] = i;
3768     }
3769     return tokenIds;
3770   }
3771 
3772   //try catch vaersion ownerOf. support burned tokenid.
3773   function tryOwnerOf(uint256 tokenId) external view  virtual returns (address) {
3774     try this.ownerOf(tokenId) returns (address _address) {
3775       return(_address);
3776     } catch {
3777         return (address(0));//return 0x0 if error.
3778     }
3779   }
3780     //OPENSEA.OPERATORFilterer.START
3781     /**
3782      * @notice Set the state of the OpenSea operator filter
3783      * @param value Flag indicating if the operator filter should be applied to transfers and approvals
3784      */
3785     function setOperatorFilteringEnabled(bool value) external onlyOperator {
3786         operatorFilteringEnabled = value;
3787     }
3788 
3789     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3790         super.setApprovalForAll(operator, approved);
3791     }
3792 
3793     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3794         super.approve(operator, tokenId);
3795     }
3796 
3797     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3798         super.transferFrom(from, to, tokenId);
3799     }
3800 
3801     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3802         super.safeTransferFrom(from, to, tokenId);
3803     }
3804 
3805     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3806         public
3807         override
3808         onlyAllowedOperator(from)
3809     {
3810         super.safeTransferFrom(from, to, tokenId, data);
3811     }
3812     //OPENSEA.OPERATORFilterer.END
3813 
3814     /*///////////////////////////////////////////////////////////////
3815                     OVERRIDES ERC721RestrictApprove
3816     //////////////////////////////////////////////////////////////*/
3817     function addLocalContractAllowList(address transferer)
3818         external
3819         override
3820         onlyOperator
3821     {
3822         _addLocalContractAllowList(transferer);
3823     }
3824 
3825     function removeLocalContractAllowList(address transferer)
3826         external
3827         override
3828         onlyOperator
3829     {
3830         _removeLocalContractAllowList(transferer);
3831     }
3832 
3833     function getLocalContractAllowList()
3834         external
3835         override
3836         view
3837         returns(address[] memory)
3838     {
3839         return _getLocalContractAllowList();
3840     }
3841 
3842     function setCALLevel(uint256 level) public override onlyOperator {
3843         CALLevel = level;
3844     }
3845 
3846     function setCAL(address calAddress) external override onlyOperator {
3847         _setCAL(calAddress);
3848     }
3849 
3850     /**
3851         @dev Operable.Role.ADD
3852      */
3853     function grantOperatorRole(address _candidate) external onlyOwner {
3854         _grantOperatorRole(_candidate);
3855     }
3856     /**
3857         @dev Operable.Role.REMOVE
3858      */
3859     function revokeOperatorRole(address _candidate) external onlyOwner {
3860         _revokeOperatorRole(_candidate);
3861     }
3862     
3863 }
3864 //CODE.BY.FRICKLIK