1 // POMERANIANSNFT//
2 // SPDX-License-Identifier: MIT
3 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
7 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Library for managing
13  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
14  * types.
15  *
16  * Sets have the following properties:
17  *
18  * - Elements are added, removed, and checked for existence in constant time
19  * (O(1)).
20  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
21  *
22  * ```
23  * contract Example {
24  *     // Add the library methods
25  *     using EnumerableSet for EnumerableSet.AddressSet;
26  *
27  *     // Declare a set state variable
28  *     EnumerableSet.AddressSet private mySet;
29  * }
30  * ```
31  *
32  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
33  * and `uint256` (`UintSet`) are supported.
34  *
35  * [WARNING]
36  * ====
37  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
38  * unusable.
39  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
40  *
41  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
42  * array of EnumerableSet.
43  * ====
44  */
45 library EnumerableSet {
46     // To implement this library for multiple types with as little code
47     // repetition as possible, we write it in terms of a generic Set type with
48     // bytes32 values.
49     // The Set implementation uses private functions, and user-facing
50     // implementations (such as AddressSet) are just wrappers around the
51     // underlying Set.
52     // This means that we can only create new EnumerableSets for types that fit
53     // in bytes32.
54 
55     struct Set {
56         // Storage of set values
57         bytes32[] _values;
58         // Position of the value in the `values` array, plus 1 because index 0
59         // means a value is not in the set.
60         mapping(bytes32 => uint256) _indexes;
61     }
62 
63     /**
64      * @dev Add a value to a set. O(1).
65      *
66      * Returns true if the value was added to the set, that is if it was not
67      * already present.
68      */
69     function _add(Set storage set, bytes32 value) private returns (bool) {
70         if (!_contains(set, value)) {
71             set._values.push(value);
72             // The value is stored at length-1, but we add 1 to all indexes
73             // and use 0 as a sentinel value
74             set._indexes[value] = set._values.length;
75             return true;
76         } else {
77             return false;
78         }
79     }
80 
81     /**
82      * @dev Removes a value from a set. O(1).
83      *
84      * Returns true if the value was removed from the set, that is if it was
85      * present.
86      */
87     function _remove(Set storage set, bytes32 value) private returns (bool) {
88         // We read and store the value's index to prevent multiple reads from the same storage slot
89         uint256 valueIndex = set._indexes[value];
90 
91         if (valueIndex != 0) {
92             // Equivalent to contains(set, value)
93             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
94             // the array, and then remove the last element (sometimes called as 'swap and pop').
95             // This modifies the order of the array, as noted in {at}.
96 
97             uint256 toDeleteIndex = valueIndex - 1;
98             uint256 lastIndex = set._values.length - 1;
99 
100             if (lastIndex != toDeleteIndex) {
101                 bytes32 lastValue = set._values[lastIndex];
102 
103                 // Move the last value to the index where the value to delete is
104                 set._values[toDeleteIndex] = lastValue;
105                 // Update the index for the moved value
106                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
107             }
108 
109             // Delete the slot where the moved value was stored
110             set._values.pop();
111 
112             // Delete the index for the deleted slot
113             delete set._indexes[value];
114 
115             return true;
116         } else {
117             return false;
118         }
119     }
120 
121     /**
122      * @dev Returns true if the value is in the set. O(1).
123      */
124     function _contains(Set storage set, bytes32 value) private view returns (bool) {
125         return set._indexes[value] != 0;
126     }
127 
128     /**
129      * @dev Returns the number of values on the set. O(1).
130      */
131     function _length(Set storage set) private view returns (uint256) {
132         return set._values.length;
133     }
134 
135     /**
136      * @dev Returns the value stored at position `index` in the set. O(1).
137      *
138      * Note that there are no guarantees on the ordering of values inside the
139      * array, and it may change when more values are added or removed.
140      *
141      * Requirements:
142      *
143      * - `index` must be strictly less than {length}.
144      */
145     function _at(Set storage set, uint256 index) private view returns (bytes32) {
146         return set._values[index];
147     }
148 
149     /**
150      * @dev Return the entire set in an array
151      *
152      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
153      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
154      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
155      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
156      */
157     function _values(Set storage set) private view returns (bytes32[] memory) {
158         return set._values;
159     }
160 
161     // Bytes32Set
162 
163     struct Bytes32Set {
164         Set _inner;
165     }
166 
167     /**
168      * @dev Add a value to a set. O(1).
169      *
170      * Returns true if the value was added to the set, that is if it was not
171      * already present.
172      */
173     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
174         return _add(set._inner, value);
175     }
176 
177     /**
178      * @dev Removes a value from a set. O(1).
179      *
180      * Returns true if the value was removed from the set, that is if it was
181      * present.
182      */
183     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
184         return _remove(set._inner, value);
185     }
186 
187     /**
188      * @dev Returns true if the value is in the set. O(1).
189      */
190     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
191         return _contains(set._inner, value);
192     }
193 
194     /**
195      * @dev Returns the number of values in the set. O(1).
196      */
197     function length(Bytes32Set storage set) internal view returns (uint256) {
198         return _length(set._inner);
199     }
200 
201     /**
202      * @dev Returns the value stored at position `index` in the set. O(1).
203      *
204      * Note that there are no guarantees on the ordering of values inside the
205      * array, and it may change when more values are added or removed.
206      *
207      * Requirements:
208      *
209      * - `index` must be strictly less than {length}.
210      */
211     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
212         return _at(set._inner, index);
213     }
214 
215     /**
216      * @dev Return the entire set in an array
217      *
218      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
219      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
220      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
221      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
222      */
223     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
224         bytes32[] memory store = _values(set._inner);
225         bytes32[] memory result;
226 
227         /// @solidity memory-safe-assembly
228         assembly {
229             result := store
230         }
231 
232         return result;
233     }
234 
235     // AddressSet
236 
237     struct AddressSet {
238         Set _inner;
239     }
240 
241     /**
242      * @dev Add a value to a set. O(1).
243      *
244      * Returns true if the value was added to the set, that is if it was not
245      * already present.
246      */
247     function add(AddressSet storage set, address value) internal returns (bool) {
248         return _add(set._inner, bytes32(uint256(uint160(value))));
249     }
250 
251     /**
252      * @dev Removes a value from a set. O(1).
253      *
254      * Returns true if the value was removed from the set, that is if it was
255      * present.
256      */
257     function remove(AddressSet storage set, address value) internal returns (bool) {
258         return _remove(set._inner, bytes32(uint256(uint160(value))));
259     }
260 
261     /**
262      * @dev Returns true if the value is in the set. O(1).
263      */
264     function contains(AddressSet storage set, address value) internal view returns (bool) {
265         return _contains(set._inner, bytes32(uint256(uint160(value))));
266     }
267 
268     /**
269      * @dev Returns the number of values in the set. O(1).
270      */
271     function length(AddressSet storage set) internal view returns (uint256) {
272         return _length(set._inner);
273     }
274 
275     /**
276      * @dev Returns the value stored at position `index` in the set. O(1).
277      *
278      * Note that there are no guarantees on the ordering of values inside the
279      * array, and it may change when more values are added or removed.
280      *
281      * Requirements:
282      *
283      * - `index` must be strictly less than {length}.
284      */
285     function at(AddressSet storage set, uint256 index) internal view returns (address) {
286         return address(uint160(uint256(_at(set._inner, index))));
287     }
288 
289     /**
290      * @dev Return the entire set in an array
291      *
292      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
293      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
294      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
295      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
296      */
297     function values(AddressSet storage set) internal view returns (address[] memory) {
298         bytes32[] memory store = _values(set._inner);
299         address[] memory result;
300 
301         /// @solidity memory-safe-assembly
302         assembly {
303             result := store
304         }
305 
306         return result;
307     }
308 
309     // UintSet
310 
311     struct UintSet {
312         Set _inner;
313     }
314 
315     /**
316      * @dev Add a value to a set. O(1).
317      *
318      * Returns true if the value was added to the set, that is if it was not
319      * already present.
320      */
321     function add(UintSet storage set, uint256 value) internal returns (bool) {
322         return _add(set._inner, bytes32(value));
323     }
324 
325     /**
326      * @dev Removes a value from a set. O(1).
327      *
328      * Returns true if the value was removed from the set, that is if it was
329      * present.
330      */
331     function remove(UintSet storage set, uint256 value) internal returns (bool) {
332         return _remove(set._inner, bytes32(value));
333     }
334 
335     /**
336      * @dev Returns true if the value is in the set. O(1).
337      */
338     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
339         return _contains(set._inner, bytes32(value));
340     }
341 
342     /**
343      * @dev Returns the number of values in the set. O(1).
344      */
345     function length(UintSet storage set) internal view returns (uint256) {
346         return _length(set._inner);
347     }
348 
349     /**
350      * @dev Returns the value stored at position `index` in the set. O(1).
351      *
352      * Note that there are no guarantees on the ordering of values inside the
353      * array, and it may change when more values are added or removed.
354      *
355      * Requirements:
356      *
357      * - `index` must be strictly less than {length}.
358      */
359     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
360         return uint256(_at(set._inner, index));
361     }
362 
363     /**
364      * @dev Return the entire set in an array
365      *
366      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
367      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
368      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
369      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
370      */
371     function values(UintSet storage set) internal view returns (uint256[] memory) {
372         bytes32[] memory store = _values(set._inner);
373         uint256[] memory result;
374 
375         /// @solidity memory-safe-assembly
376         assembly {
377             result := store
378         }
379 
380         return result;
381     }
382 }
383 
384 // File: IOperatorFilterRegistry.sol
385 
386 
387 pragma solidity ^0.8.13;
388 
389 
390 interface IOperatorFilterRegistry {
391     function isOperatorAllowed(address registrant, address operator) external returns (bool);
392     function register(address registrant) external;
393     function registerAndSubscribe(address registrant, address subscription) external;
394     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
395     function updateOperator(address registrant, address operator, bool filtered) external;
396     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
397     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
398     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
399     function subscribe(address registrant, address registrantToSubscribe) external;
400     function unsubscribe(address registrant, bool copyExistingEntries) external;
401     function subscriptionOf(address addr) external returns (address registrant);
402     function subscribers(address registrant) external returns (address[] memory);
403     function subscriberAt(address registrant, uint256 index) external returns (address);
404     function copyEntriesOf(address registrant, address registrantToCopy) external;
405     function isOperatorFiltered(address registrant, address operator) external returns (bool);
406     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
407     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
408     function filteredOperators(address addr) external returns (address[] memory);
409     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
410     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
411     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
412     function isRegistered(address addr) external returns (bool);
413     function codeHashOf(address addr) external returns (bytes32);
414 }
415 // File: OperatorFilterer.sol
416 
417 
418 pragma solidity ^0.8.13;
419 
420 
421 contract OperatorFilterer {
422     error OperatorNotAllowed(address operator);
423 
424     IOperatorFilterRegistry constant operatorFilterRegistry =
425         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
426 
427     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
428         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
429         // will not revert, but the contract will need to be registered with the registry once it is deployed in
430         // order for the modifier to filter addresses.
431         if (address(operatorFilterRegistry).code.length > 0) {
432             if (subscribe) {
433                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
434             } else {
435                 if (subscriptionOrRegistrantToCopy != address(0)) {
436                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
437                 } else {
438                     operatorFilterRegistry.register(address(this));
439                 }
440             }
441         }
442     }
443 
444     modifier onlyAllowedOperator() virtual {
445         // Check registry code length to facilitate testing in environments without a deployed registry.
446         if (address(operatorFilterRegistry).code.length > 0) {
447             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
448                 revert OperatorNotAllowed(msg.sender);
449             }
450         }
451         _;
452     }
453 }
454 // File: DefaultOperatorFilterer.sol
455 
456 
457 pragma solidity ^0.8.13;
458 
459 
460 contract DefaultOperatorFilterer is OperatorFilterer {
461     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
462 
463     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
464 }
465 // File: @openzeppelin/contracts/utils/Strings.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev String operations.
474  */
475 library Strings {
476     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
480      */
481     function toString(uint256 value) internal pure returns (string memory) {
482         // Inspired by OraclizeAPI's implementation - MIT licence
483         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
484 
485         if (value == 0) {
486             return "0";
487         }
488         uint256 temp = value;
489         uint256 digits;
490         while (temp != 0) {
491             digits++;
492             temp /= 10;
493         }
494         bytes memory buffer = new bytes(digits);
495         while (value != 0) {
496             digits -= 1;
497             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
498             value /= 10;
499         }
500         return string(buffer);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
505      */
506     function toHexString(uint256 value) internal pure returns (string memory) {
507         if (value == 0) {
508             return "0x00";
509         }
510         uint256 temp = value;
511         uint256 length = 0;
512         while (temp != 0) {
513             length++;
514             temp >>= 8;
515         }
516         return toHexString(value, length);
517     }
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
521      */
522     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
523         bytes memory buffer = new bytes(2 * length + 2);
524         buffer[0] = "0";
525         buffer[1] = "x";
526         for (uint256 i = 2 * length + 1; i > 1; --i) {
527             buffer[i] = _HEX_SYMBOLS[value & 0xf];
528             value >>= 4;
529         }
530         require(value == 0, "Strings: hex length insufficient");
531         return string(buffer);
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Address.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
539 
540 pragma solidity ^0.8.1;
541 
542 /**
543  * @dev Collection of functions related to the address type
544  */
545 library Address {
546     /**
547      * @dev Returns true if `account` is a contract.
548      *
549      * [IMPORTANT]
550      * ====
551      * It is unsafe to assume that an address for which this function returns
552      * false is an externally-owned account (EOA) and not a contract.
553      *
554      * Among others, `isContract` will return false for the following
555      * types of addresses:
556      *
557      *  - an externally-owned account
558      *  - a contract in construction
559      *  - an address where a contract will be created
560      *  - an address where a contract lived, but was destroyed
561      * ====
562      *
563      * [IMPORTANT]
564      * ====
565      * You shouldn't rely on `isContract` to protect against flash loan attacks!
566      *
567      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
568      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
569      * constructor.
570      * ====
571      */
572     function isContract(address account) internal view returns (bool) {
573         // This method relies on extcodesize/address.code.length, which returns 0
574         // for contracts in construction, since the code is only stored at the end
575         // of the constructor execution.
576 
577         return account.code.length > 0;
578     }
579 
580     /**
581      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
582      * `recipient`, forwarding all available gas and reverting on errors.
583      *
584      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
585      * of certain opcodes, possibly making contracts go over the 2300 gas limit
586      * imposed by `transfer`, making them unable to receive funds via
587      * `transfer`. {sendValue} removes this limitation.
588      *
589      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
590      *
591      * IMPORTANT: because control is transferred to `recipient`, care must be
592      * taken to not create reentrancy vulnerabilities. Consider using
593      * {ReentrancyGuard} or the
594      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
595      */
596     function sendValue(address payable recipient, uint256 amount) internal {
597         require(address(this).balance >= amount, "Address: insufficient balance");
598 
599         (bool success, ) = recipient.call{value: amount}("");
600         require(success, "Address: unable to send value, recipient may have reverted");
601     }
602 
603     /**
604      * @dev Performs a Solidity function call using a low level `call`. A
605      * plain `call` is an unsafe replacement for a function call: use this
606      * function instead.
607      *
608      * If `target` reverts with a revert reason, it is bubbled up by this
609      * function (like regular Solidity function calls).
610      *
611      * Returns the raw returned data. To convert to the expected return value,
612      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
613      *
614      * Requirements:
615      *
616      * - `target` must be a contract.
617      * - calling `target` with `data` must not revert.
618      *
619      * _Available since v3.1._
620      */
621     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
622         return functionCall(target, data, "Address: low-level call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
627      * `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         return functionCallWithValue(target, data, 0, errorMessage);
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
641      * but also transferring `value` wei to `target`.
642      *
643      * Requirements:
644      *
645      * - the calling contract must have an ETH balance of at least `value`.
646      * - the called Solidity function must be `payable`.
647      *
648      * _Available since v3.1._
649      */
650     function functionCallWithValue(
651         address target,
652         bytes memory data,
653         uint256 value
654     ) internal returns (bytes memory) {
655         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
660      * with `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCallWithValue(
665         address target,
666         bytes memory data,
667         uint256 value,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         require(address(this).balance >= value, "Address: insufficient balance for call");
671         require(isContract(target), "Address: call to non-contract");
672 
673         (bool success, bytes memory returndata) = target.call{value: value}(data);
674         return verifyCallResult(success, returndata, errorMessage);
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
679      * but performing a static call.
680      *
681      * _Available since v3.3._
682      */
683     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
684         return functionStaticCall(target, data, "Address: low-level static call failed");
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
689      * but performing a static call.
690      *
691      * _Available since v3.3._
692      */
693     function functionStaticCall(
694         address target,
695         bytes memory data,
696         string memory errorMessage
697     ) internal view returns (bytes memory) {
698         require(isContract(target), "Address: static call to non-contract");
699 
700         (bool success, bytes memory returndata) = target.staticcall(data);
701         return verifyCallResult(success, returndata, errorMessage);
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
706      * but performing a delegate call.
707      *
708      * _Available since v3.4._
709      */
710     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
711         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
716      * but performing a delegate call.
717      *
718      * _Available since v3.4._
719      */
720     function functionDelegateCall(
721         address target,
722         bytes memory data,
723         string memory errorMessage
724     ) internal returns (bytes memory) {
725         require(isContract(target), "Address: delegate call to non-contract");
726 
727         (bool success, bytes memory returndata) = target.delegatecall(data);
728         return verifyCallResult(success, returndata, errorMessage);
729     }
730 
731     /**
732      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
733      * revert reason using the provided one.
734      *
735      * _Available since v4.3._
736      */
737     function verifyCallResult(
738         bool success,
739         bytes memory returndata,
740         string memory errorMessage
741     ) internal pure returns (bytes memory) {
742         if (success) {
743             return returndata;
744         } else {
745             // Look for revert reason and bubble it up if present
746             if (returndata.length > 0) {
747                 // The easiest way to bubble the revert reason is using memory via assembly
748 
749                 assembly {
750                     let returndata_size := mload(returndata)
751                     revert(add(32, returndata), returndata_size)
752                 }
753             } else {
754                 revert(errorMessage);
755             }
756         }
757     }
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
761 
762 
763 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 /**
768  * @title ERC721 token receiver interface
769  * @dev Interface for any contract that wants to support safeTransfers
770  * from ERC721 asset contracts.
771  */
772 interface IERC721Receiver {
773     /**
774      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
775      * by `operator` from `from`, this function is called.
776      *
777      * It must return its Solidity selector to confirm the token transfer.
778      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
779      *
780      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
781      */
782     function onERC721Received(
783         address operator,
784         address from,
785         uint256 tokenId,
786         bytes calldata data
787     ) external returns (bytes4);
788 }
789 
790 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
791 
792 
793 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
794 
795 pragma solidity ^0.8.0;
796 
797 /**
798  * @dev Interface of the ERC165 standard, as defined in the
799  * https://eips.ethereum.org/EIPS/eip-165[EIP].
800  *
801  * Implementers can declare support of contract interfaces, which can then be
802  * queried by others ({ERC165Checker}).
803  *
804  * For an implementation, see {ERC165}.
805  */
806 interface IERC165 {
807     /**
808      * @dev Returns true if this contract implements the interface defined by
809      * `interfaceId`. See the corresponding
810      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
811      * to learn more about how these ids are created.
812      *
813      * This function call must use less than 30 000 gas.
814      */
815     function supportsInterface(bytes4 interfaceId) external view returns (bool);
816 }
817 
818 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
819 
820 
821 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
822 
823 pragma solidity ^0.8.0;
824 
825 
826 /**
827  * @dev Implementation of the {IERC165} interface.
828  *
829  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
830  * for the additional interface id that will be supported. For example:
831  *
832  * ```solidity
833  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
834  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
835  * }
836  * ```
837  *
838  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
839  */
840 abstract contract ERC165 is IERC165 {
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
845         return interfaceId == type(IERC165).interfaceId;
846     }
847 }
848 
849 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
850 
851 
852 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 
857 /**
858  * @dev Required interface of an ERC721 compliant contract.
859  */
860 interface IERC721 is IERC165 {
861     /**
862      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
863      */
864     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
865 
866     /**
867      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
868      */
869     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
870 
871     /**
872      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
873      */
874     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
875 
876     /**
877      * @dev Returns the number of tokens in ``owner``'s account.
878      */
879     function balanceOf(address owner) external view returns (uint256 balance);
880 
881     /**
882      * @dev Returns the owner of the `tokenId` token.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function ownerOf(uint256 tokenId) external view returns (address owner);
889 
890     /**
891      * @dev Safely transfers `tokenId` token from `from` to `to`.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must exist and be owned by `from`.
898      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes calldata data
908     ) external;
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
912      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must exist and be owned by `from`.
919      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
920      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
921      *
922      * Emits a {Transfer} event.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) external;
929 
930     /**
931      * @dev Transfers `tokenId` token from `from` to `to`.
932      *
933      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
934      *
935      * Requirements:
936      *
937      * - `from` cannot be the zero address.
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must be owned by `from`.
940      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
941      *
942      * Emits a {Transfer} event.
943      */
944     function transferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) external;
949 
950     /**
951      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
952      * The approval is cleared when the token is transferred.
953      *
954      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
955      *
956      * Requirements:
957      *
958      * - The caller must own the token or be an approved operator.
959      * - `tokenId` must exist.
960      *
961      * Emits an {Approval} event.
962      */
963     function approve(address to, uint256 tokenId) external;
964 
965     /**
966      * @dev Approve or remove `operator` as an operator for the caller.
967      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
968      *
969      * Requirements:
970      *
971      * - The `operator` cannot be the caller.
972      *
973      * Emits an {ApprovalForAll} event.
974      */
975     function setApprovalForAll(address operator, bool _approved) external;
976 
977     /**
978      * @dev Returns the account approved for `tokenId` token.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function getApproved(uint256 tokenId) external view returns (address operator);
985 
986     /**
987      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
988      *
989      * See {setApprovalForAll}
990      */
991     function isApprovedForAll(address owner, address operator) external view returns (bool);
992 }
993 
994 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
995 
996 
997 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 /**
1003  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1004  * @dev See https://eips.ethereum.org/EIPS/eip-721
1005  */
1006 interface IERC721Metadata is IERC721 {
1007     /**
1008      * @dev Returns the token collection name.
1009      */
1010     function name() external view returns (string memory);
1011 
1012     /**
1013      * @dev Returns the token collection symbol.
1014      */
1015     function symbol() external view returns (string memory);
1016 
1017     /**
1018      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1019      */
1020     function tokenURI(uint256 tokenId) external view returns (string memory);
1021 }
1022 
1023 // File: @openzeppelin/contracts/utils/Context.sol
1024 
1025 
1026 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 /**
1031  * @dev Provides information about the current execution context, including the
1032  * sender of the transaction and its data. While these are generally available
1033  * via msg.sender and msg.data, they should not be accessed in such a direct
1034  * manner, since when dealing with meta-transactions the account sending and
1035  * paying for execution may not be the actual sender (as far as an application
1036  * is concerned).
1037  *
1038  * This contract is only required for intermediate, library-like contracts.
1039  */
1040 abstract contract Context {
1041     function _msgSender() internal view virtual returns (address) {
1042         return msg.sender;
1043     }
1044 
1045     function _msgData() internal view virtual returns (bytes calldata) {
1046         return msg.data;
1047     }
1048 }
1049 
1050 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1051 
1052 
1053 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1054 
1055 pragma solidity ^0.8.0;
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 /**
1065  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1066  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1067  * {ERC721Enumerable}.
1068  */
1069 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1070     using Address for address;
1071     using Strings for uint256;
1072 
1073     // Token name
1074     string private _name;
1075 
1076     // Token symbol
1077     string private _symbol;
1078 
1079     // Mapping from token ID to owner address
1080     mapping(uint256 => address) private _owners;
1081 
1082     // Mapping owner address to token count
1083     mapping(address => uint256) private _balances;
1084 
1085     // Mapping from token ID to approved address
1086     mapping(uint256 => address) private _tokenApprovals;
1087 
1088     // Mapping from owner to operator approvals
1089     mapping(address => mapping(address => bool)) private _operatorApprovals;
1090 
1091     /**
1092      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1093      */
1094     constructor(string memory name_, string memory symbol_) {
1095         _name = name_;
1096         _symbol = symbol_;
1097     }
1098 
1099     /**
1100      * @dev See {IERC165-supportsInterface}.
1101      */
1102     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1103         return
1104             interfaceId == type(IERC721).interfaceId ||
1105             interfaceId == type(IERC721Metadata).interfaceId ||
1106             super.supportsInterface(interfaceId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-balanceOf}.
1111      */
1112     function balanceOf(address owner) public view virtual override returns (uint256) {
1113         require(owner != address(0), "ERC721: balance query for the zero address");
1114         return _balances[owner];
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-ownerOf}.
1119      */
1120     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1121         address owner = _owners[tokenId];
1122         require(owner != address(0), "ERC721: owner query for nonexistent token");
1123         return owner;
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Metadata-name}.
1128      */
1129     function name() public view virtual override returns (string memory) {
1130         return _name;
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Metadata-symbol}.
1135      */
1136     function symbol() public view virtual override returns (string memory) {
1137         return _symbol;
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Metadata-tokenURI}.
1142      */
1143     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1144         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1145 
1146         string memory baseURI = _baseURI();
1147         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1148     }
1149 
1150     /**
1151      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1152      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1153      * by default, can be overridden in child contracts.
1154      */
1155     function _baseURI() internal view virtual returns (string memory) {
1156         return "";
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-approve}.
1161      */
1162     function approve(address to, uint256 tokenId) public virtual override {
1163         address owner = ERC721.ownerOf(tokenId);
1164         require(to != owner, "ERC721: approval to current owner");
1165 
1166         require(
1167             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1168             "ERC721: approve caller is not owner nor approved for all"
1169         );
1170 
1171         _approve(to, tokenId);
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-getApproved}.
1176      */
1177     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1178         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1179 
1180         return _tokenApprovals[tokenId];
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-setApprovalForAll}.
1185      */
1186     function setApprovalForAll(address operator, bool approved) public virtual override {
1187         _setApprovalForAll(_msgSender(), operator, approved);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-isApprovedForAll}.
1192      */
1193     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1194         return _operatorApprovals[owner][operator];
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-transferFrom}.
1199      */
1200     function transferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) public virtual override {
1205         //solhint-disable-next-line max-line-length
1206         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1207 
1208         _transfer(from, to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-safeTransferFrom}.
1213      */
1214     function safeTransferFrom(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) public virtual override {
1219         safeTransferFrom(from, to, tokenId, "");
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-safeTransferFrom}.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes memory _data
1230     ) public virtual override {
1231         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1232         _safeTransfer(from, to, tokenId, _data);
1233     }
1234 
1235     /**
1236      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1237      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1238      *
1239      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1240      *
1241      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1242      * implement alternative mechanisms to perform token transfer, such as signature-based.
1243      *
1244      * Requirements:
1245      *
1246      * - `from` cannot be the zero address.
1247      * - `to` cannot be the zero address.
1248      * - `tokenId` token must exist and be owned by `from`.
1249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _safeTransfer(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) internal virtual {
1259         _transfer(from, to, tokenId);
1260         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1261     }
1262 
1263     /**
1264      * @dev Returns whether `tokenId` exists.
1265      *
1266      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1267      *
1268      * Tokens start existing when they are minted (`_mint`),
1269      * and stop existing when they are burned (`_burn`).
1270      */
1271     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1272         return _owners[tokenId] != address(0);
1273     }
1274 
1275     /**
1276      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      */
1282     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1283         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1284         address owner = ERC721.ownerOf(tokenId);
1285         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1286     }
1287 
1288     /**
1289      * @dev Safely mints `tokenId` and transfers it to `to`.
1290      *
1291      * Requirements:
1292      *
1293      * - `tokenId` must not exist.
1294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _safeMint(address to, uint256 tokenId) internal virtual {
1299         _safeMint(to, tokenId, "");
1300     }
1301 
1302     /**
1303      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1304      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1305      */
1306     function _safeMint(
1307         address to,
1308         uint256 tokenId,
1309         bytes memory _data
1310     ) internal virtual {
1311         _mint(to, tokenId);
1312         require(
1313             _checkOnERC721Received(address(0), to, tokenId, _data),
1314             "ERC721: transfer to non ERC721Receiver implementer"
1315         );
1316     }
1317 
1318     /**
1319      * @dev Mints `tokenId` and transfers it to `to`.
1320      *
1321      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1322      *
1323      * Requirements:
1324      *
1325      * - `tokenId` must not exist.
1326      * - `to` cannot be the zero address.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _mint(address to, uint256 tokenId) internal virtual {
1331         require(to != address(0), "ERC721: mint to the zero address");
1332         require(!_exists(tokenId), "ERC721: token already minted");
1333 
1334         _beforeTokenTransfer(address(0), to, tokenId);
1335 
1336         _balances[to] += 1;
1337         _owners[tokenId] = to;
1338 
1339         emit Transfer(address(0), to, tokenId);
1340 
1341         _afterTokenTransfer(address(0), to, tokenId);
1342     }
1343 
1344     /**
1345      * @dev Destroys `tokenId`.
1346      * The approval is cleared when the token is burned.
1347      *
1348      * Requirements:
1349      *
1350      * - `tokenId` must exist.
1351      *
1352      * Emits a {Transfer} event.
1353      */
1354     function _burn(uint256 tokenId) internal virtual {
1355         address owner = ERC721.ownerOf(tokenId);
1356 
1357         _beforeTokenTransfer(owner, address(0), tokenId);
1358 
1359         // Clear approvals
1360         _approve(address(0), tokenId);
1361 
1362         _balances[owner] -= 1;
1363         delete _owners[tokenId];
1364 
1365         emit Transfer(owner, address(0), tokenId);
1366 
1367         _afterTokenTransfer(owner, address(0), tokenId);
1368     }
1369 
1370     /**
1371      * @dev Transfers `tokenId` from `from` to `to`.
1372      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1373      *
1374      * Requirements:
1375      *
1376      * - `to` cannot be the zero address.
1377      * - `tokenId` token must be owned by `from`.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _transfer(
1382         address from,
1383         address to,
1384         uint256 tokenId
1385     ) internal virtual {
1386         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1387         require(to != address(0), "ERC721: transfer to the zero address");
1388 
1389         _beforeTokenTransfer(from, to, tokenId);
1390 
1391         // Clear approvals from the previous owner
1392         _approve(address(0), tokenId);
1393 
1394         _balances[from] -= 1;
1395         _balances[to] += 1;
1396         _owners[tokenId] = to;
1397 
1398         emit Transfer(from, to, tokenId);
1399 
1400         _afterTokenTransfer(from, to, tokenId);
1401     }
1402 
1403     /**
1404      * @dev Approve `to` to operate on `tokenId`
1405      *
1406      * Emits a {Approval} event.
1407      */
1408     function _approve(address to, uint256 tokenId) internal virtual {
1409         _tokenApprovals[tokenId] = to;
1410         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1411     }
1412 
1413     /**
1414      * @dev Approve `operator` to operate on all of `owner` tokens
1415      *
1416      * Emits a {ApprovalForAll} event.
1417      */
1418     function _setApprovalForAll(
1419         address owner,
1420         address operator,
1421         bool approved
1422     ) internal virtual {
1423         require(owner != operator, "ERC721: approve to caller");
1424         _operatorApprovals[owner][operator] = approved;
1425         emit ApprovalForAll(owner, operator, approved);
1426     }
1427 
1428     /**
1429      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1430      * The call is not executed if the target address is not a contract.
1431      *
1432      * @param from address representing the previous owner of the given token ID
1433      * @param to target address that will receive the tokens
1434      * @param tokenId uint256 ID of the token to be transferred
1435      * @param _data bytes optional data to send along with the call
1436      * @return bool whether the call correctly returned the expected magic value
1437      */
1438     function _checkOnERC721Received(
1439         address from,
1440         address to,
1441         uint256 tokenId,
1442         bytes memory _data
1443     ) private returns (bool) {
1444         if (to.isContract()) {
1445             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1446                 return retval == IERC721Receiver.onERC721Received.selector;
1447             } catch (bytes memory reason) {
1448                 if (reason.length == 0) {
1449                     revert("ERC721: transfer to non ERC721Receiver implementer");
1450                 } else {
1451                     assembly {
1452                         revert(add(32, reason), mload(reason))
1453                     }
1454                 }
1455             }
1456         } else {
1457             return true;
1458         }
1459     }
1460 
1461     /**
1462      * @dev Hook that is called before any token transfer. This includes minting
1463      * and burning.
1464      *
1465      * Calling conditions:
1466      *
1467      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1468      * transferred to `to`.
1469      * - When `from` is zero, `tokenId` will be minted for `to`.
1470      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1471      * - `from` and `to` are never both zero.
1472      *
1473      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1474      */
1475     function _beforeTokenTransfer(
1476         address from,
1477         address to,
1478         uint256 tokenId
1479     ) internal virtual {}
1480 
1481     /**
1482      * @dev Hook that is called after any transfer of tokens. This includes
1483      * minting and burning.
1484      *
1485      * Calling conditions:
1486      *
1487      * - when `from` and `to` are both non-zero.
1488      * - `from` and `to` are never both zero.
1489      *
1490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1491      */
1492     function _afterTokenTransfer(
1493         address from,
1494         address to,
1495         uint256 tokenId
1496     ) internal virtual {}
1497 }
1498 
1499 // File: @openzeppelin/contracts/access/Ownable.sol
1500 
1501 
1502 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1503 
1504 pragma solidity ^0.8.0;
1505 
1506 
1507 /**
1508  * @dev Contract module which provides a basic access control mechanism, where
1509  * there is an account (an owner) that can be granted exclusive access to
1510  * specific functions.
1511  *
1512  * By default, the owner account will be the one that deploys the contract. This
1513  * can later be changed with {transferOwnership}.
1514  *
1515  * This module is used through inheritance. It will make available the modifier
1516  * `onlyOwner`, which can be applied to your functions to restrict their use to
1517  * the owner.
1518  */
1519 abstract contract Ownable is Context {
1520     address private _owner;
1521 
1522     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1523 
1524     /**
1525      * @dev Initializes the contract setting the deployer as the initial owner.
1526      */
1527     constructor() {
1528         _transferOwnership(_msgSender());
1529     }
1530 
1531     /**
1532      * @dev Returns the address of the current owner.
1533      */
1534     function owner() public view virtual returns (address) {
1535         return _owner;
1536     }
1537 
1538     /**
1539      * @dev Throws if called by any account other than the owner.
1540      */
1541     modifier onlyOwner() {
1542         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1543         _;
1544     }
1545 
1546     /**
1547      * @dev Leaves the contract without owner. It will not be possible to call
1548      * `onlyOwner` functions anymore. Can only be called by the current owner.
1549      *
1550      * NOTE: Renouncing ownership will leave the contract without an owner,
1551      * thereby removing any functionality that is only available to the owner.
1552      */
1553     function renounceOwnership() public virtual onlyOwner {
1554         _transferOwnership(address(0));
1555     }
1556 
1557     /**
1558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1559      * Can only be called by the current owner.
1560      */
1561     function transferOwnership(address newOwner) public virtual onlyOwner {
1562         require(newOwner != address(0), "Ownable: new owner is the zero address");
1563         _transferOwnership(newOwner);
1564     }
1565 
1566     /**
1567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1568      * Internal function without access restriction.
1569      */
1570     function _transferOwnership(address newOwner) internal virtual {
1571         address oldOwner = _owner;
1572         _owner = newOwner;
1573         emit OwnershipTransferred(oldOwner, newOwner);
1574     }
1575 }
1576 
1577 // File: FacepunchAbstractions.sol
1578 
1579 
1580 
1581 pragma solidity ^0.8.9;
1582 
1583 
1584 
1585 
1586 contract Pomeranians is ERC721, Ownable, DefaultOperatorFilterer {
1587     using Strings for uint256;
1588 
1589     uint public constant MAX_TOKENS = 3333;
1590     uint private constant TOKENS_RESERVED = 0;
1591     uint public price = 0;
1592     uint256 public constant MAX_MINT_PER_TX = 4;
1593     uint256 public totalTokens;
1594 
1595     bool public isSaleActive;   
1596     uint256 public totalSupply;
1597     mapping(address => uint256) private mintedPerWallet;
1598 
1599     string public baseUri;
1600     string public baseExtension = ".json";
1601 
1602     constructor() ERC721("Pomeranians", "POM") {
1603         baseUri = "https://sereno.work/pomoutput/";
1604         for(uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
1605             _safeMint(msg.sender, i);
1606         }
1607         totalSupply = TOKENS_RESERVED;
1608     }
1609 
1610     // Public Functions
1611     function mint(uint256 _numTokens) external payable {
1612         require(isSaleActive, "The sale is paused.");
1613         require(_numTokens <= MAX_MINT_PER_TX, "You cannot mint that many in one transaction.");
1614         require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "You cannot mint that many total.");
1615         uint256 curTotalSupply = totalSupply;
1616         require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds total supply.");
1617         require(_numTokens * price <= msg.value, "Insufficient funds.");
1618 
1619         for(uint256 i = 1; i <= _numTokens; ++i) {
1620             _safeMint(msg.sender, curTotalSupply + i);
1621         }
1622         mintedPerWallet[msg.sender] += _numTokens;
1623         totalSupply += _numTokens;
1624     }
1625 
1626     // Owner-only functions
1627     function airdrop(uint16 numberOfTokens, address userAddress) external onlyOwner {
1628         for(uint256 i = 1; i <= numberOfTokens; i+=1) {
1629             _safeMint(userAddress, totalTokens+i);
1630         }
1631         totalTokens += numberOfTokens;
1632     }
1633 
1634     function flipSaleState() external onlyOwner {
1635         isSaleActive = !isSaleActive;
1636     }
1637 
1638     function setBaseUri(string memory _baseUri) external onlyOwner {
1639         baseUri = _baseUri;
1640     }
1641 
1642     function setPrice(uint256 _price) external onlyOwner {
1643         price = _price;
1644     }
1645 
1646     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
1647         super.transferFrom(from, to, tokenId);
1648     }
1649 
1650     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
1651         super.safeTransferFrom(from, to, tokenId);
1652     }
1653 
1654     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1655         public
1656         override
1657         onlyAllowedOperator
1658     {
1659         super.safeTransferFrom(from, to, tokenId, data);
1660     }
1661 
1662     function withdraw() public onlyOwner {
1663         require(address(this).balance > 0, "Balance is 0");
1664         payable(owner()).transfer(address(this).balance);
1665     }
1666 
1667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1669  
1670         string memory currentBaseURI = _baseURI();
1671         return bytes(currentBaseURI).length > 0
1672             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1673             : "";
1674     }
1675  
1676     function _baseURI() internal view virtual override returns (string memory) {
1677         return baseUri;
1678     }
1679 }