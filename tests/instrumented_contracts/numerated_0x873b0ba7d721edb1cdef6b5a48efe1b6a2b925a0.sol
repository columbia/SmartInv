1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
7 
8 
9 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
10 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Library for managing
16  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
17  * types.
18  *
19  * Sets have the following properties:
20  *
21  * - Elements are added, removed, and checked for existence in constant time
22  * (O(1)).
23  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
24  *
25  * ```
26  * contract Example {
27  *     // Add the library methods
28  *     using EnumerableSet for EnumerableSet.AddressSet;
29  *
30  *     // Declare a set state variable
31  *     EnumerableSet.AddressSet private mySet;
32  * }
33  * ```
34  *
35  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
36  * and `uint256` (`UintSet`) are supported.
37  *
38  * [WARNING]
39  * ====
40  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
41  * unusable.
42  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
43  *
44  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
45  * array of EnumerableSet.
46  * ====
47  */
48 library EnumerableSet {
49     // To implement this library for multiple types with as little code
50     // repetition as possible, we write it in terms of a generic Set type with
51     // bytes32 values.
52     // The Set implementation uses private functions, and user-facing
53     // implementations (such as AddressSet) are just wrappers around the
54     // underlying Set.
55     // This means that we can only create new EnumerableSets for types that fit
56     // in bytes32.
57 
58     struct Set {
59         // Storage of set values
60         bytes32[] _values;
61         // Position of the value in the `values` array, plus 1 because index 0
62         // means a value is not in the set.
63         mapping(bytes32 => uint256) _indexes;
64     }
65 
66     /**
67      * @dev Add a value to a set. O(1).
68      *
69      * Returns true if the value was added to the set, that is if it was not
70      * already present.
71      */
72     function _add(Set storage set, bytes32 value) private returns (bool) {
73         if (!_contains(set, value)) {
74             set._values.push(value);
75             // The value is stored at length-1, but we add 1 to all indexes
76             // and use 0 as a sentinel value
77             set._indexes[value] = set._values.length;
78             return true;
79         } else {
80             return false;
81         }
82     }
83 
84     /**
85      * @dev Removes a value from a set. O(1).
86      *
87      * Returns true if the value was removed from the set, that is if it was
88      * present.
89      */
90     function _remove(Set storage set, bytes32 value) private returns (bool) {
91         // We read and store the value's index to prevent multiple reads from the same storage slot
92         uint256 valueIndex = set._indexes[value];
93 
94         if (valueIndex != 0) {
95             // Equivalent to contains(set, value)
96             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
97             // the array, and then remove the last element (sometimes called as 'swap and pop').
98             // This modifies the order of the array, as noted in {at}.
99 
100             uint256 toDeleteIndex = valueIndex - 1;
101             uint256 lastIndex = set._values.length - 1;
102 
103             if (lastIndex != toDeleteIndex) {
104                 bytes32 lastValue = set._values[lastIndex];
105 
106                 // Move the last value to the index where the value to delete is
107                 set._values[toDeleteIndex] = lastValue;
108                 // Update the index for the moved value
109                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
110             }
111 
112             // Delete the slot where the moved value was stored
113             set._values.pop();
114 
115             // Delete the index for the deleted slot
116             delete set._indexes[value];
117 
118             return true;
119         } else {
120             return false;
121         }
122     }
123 
124     /**
125      * @dev Returns true if the value is in the set. O(1).
126      */
127     function _contains(Set storage set, bytes32 value) private view returns (bool) {
128         return set._indexes[value] != 0;
129     }
130 
131     /**
132      * @dev Returns the number of values on the set. O(1).
133      */
134     function _length(Set storage set) private view returns (uint256) {
135         return set._values.length;
136     }
137 
138     /**
139      * @dev Returns the value stored at position `index` in the set. O(1).
140      *
141      * Note that there are no guarantees on the ordering of values inside the
142      * array, and it may change when more values are added or removed.
143      *
144      * Requirements:
145      *
146      * - `index` must be strictly less than {length}.
147      */
148     function _at(Set storage set, uint256 index) private view returns (bytes32) {
149         return set._values[index];
150     }
151 
152     /**
153      * @dev Return the entire set in an array
154      *
155      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
156      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
157      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
158      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
159      */
160     function _values(Set storage set) private view returns (bytes32[] memory) {
161         return set._values;
162     }
163 
164     // Bytes32Set
165 
166     struct Bytes32Set {
167         Set _inner;
168     }
169 
170     /**
171      * @dev Add a value to a set. O(1).
172      *
173      * Returns true if the value was added to the set, that is if it was not
174      * already present.
175      */
176     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
177         return _add(set._inner, value);
178     }
179 
180     /**
181      * @dev Removes a value from a set. O(1).
182      *
183      * Returns true if the value was removed from the set, that is if it was
184      * present.
185      */
186     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
187         return _remove(set._inner, value);
188     }
189 
190     /**
191      * @dev Returns true if the value is in the set. O(1).
192      */
193     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
194         return _contains(set._inner, value);
195     }
196 
197     /**
198      * @dev Returns the number of values in the set. O(1).
199      */
200     function length(Bytes32Set storage set) internal view returns (uint256) {
201         return _length(set._inner);
202     }
203 
204     /**
205      * @dev Returns the value stored at position `index` in the set. O(1).
206      *
207      * Note that there are no guarantees on the ordering of values inside the
208      * array, and it may change when more values are added or removed.
209      *
210      * Requirements:
211      *
212      * - `index` must be strictly less than {length}.
213      */
214     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
215         return _at(set._inner, index);
216     }
217 
218     /**
219      * @dev Return the entire set in an array
220      *
221      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
222      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
223      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
224      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
225      */
226     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
227         bytes32[] memory store = _values(set._inner);
228         bytes32[] memory result;
229 
230         /// @solidity memory-safe-assembly
231         assembly {
232             result := store
233         }
234 
235         return result;
236     }
237 
238     // AddressSet
239 
240     struct AddressSet {
241         Set _inner;
242     }
243 
244     /**
245      * @dev Add a value to a set. O(1).
246      *
247      * Returns true if the value was added to the set, that is if it was not
248      * already present.
249      */
250     function add(AddressSet storage set, address value) internal returns (bool) {
251         return _add(set._inner, bytes32(uint256(uint160(value))));
252     }
253 
254     /**
255      * @dev Removes a value from a set. O(1).
256      *
257      * Returns true if the value was removed from the set, that is if it was
258      * present.
259      */
260     function remove(AddressSet storage set, address value) internal returns (bool) {
261         return _remove(set._inner, bytes32(uint256(uint160(value))));
262     }
263 
264     /**
265      * @dev Returns true if the value is in the set. O(1).
266      */
267     function contains(AddressSet storage set, address value) internal view returns (bool) {
268         return _contains(set._inner, bytes32(uint256(uint160(value))));
269     }
270 
271     /**
272      * @dev Returns the number of values in the set. O(1).
273      */
274     function length(AddressSet storage set) internal view returns (uint256) {
275         return _length(set._inner);
276     }
277 
278     /**
279      * @dev Returns the value stored at position `index` in the set. O(1).
280      *
281      * Note that there are no guarantees on the ordering of values inside the
282      * array, and it may change when more values are added or removed.
283      *
284      * Requirements:
285      *
286      * - `index` must be strictly less than {length}.
287      */
288     function at(AddressSet storage set, uint256 index) internal view returns (address) {
289         return address(uint160(uint256(_at(set._inner, index))));
290     }
291 
292     /**
293      * @dev Return the entire set in an array
294      *
295      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
296      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
297      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
298      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
299      */
300     function values(AddressSet storage set) internal view returns (address[] memory) {
301         bytes32[] memory store = _values(set._inner);
302         address[] memory result;
303 
304         /// @solidity memory-safe-assembly
305         assembly {
306             result := store
307         }
308 
309         return result;
310     }
311 
312     // UintSet
313 
314     struct UintSet {
315         Set _inner;
316     }
317 
318     /**
319      * @dev Add a value to a set. O(1).
320      *
321      * Returns true if the value was added to the set, that is if it was not
322      * already present.
323      */
324     function add(UintSet storage set, uint256 value) internal returns (bool) {
325         return _add(set._inner, bytes32(value));
326     }
327 
328     /**
329      * @dev Removes a value from a set. O(1).
330      *
331      * Returns true if the value was removed from the set, that is if it was
332      * present.
333      */
334     function remove(UintSet storage set, uint256 value) internal returns (bool) {
335         return _remove(set._inner, bytes32(value));
336     }
337 
338     /**
339      * @dev Returns true if the value is in the set. O(1).
340      */
341     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
342         return _contains(set._inner, bytes32(value));
343     }
344 
345     /**
346      * @dev Returns the number of values in the set. O(1).
347      */
348     function length(UintSet storage set) internal view returns (uint256) {
349         return _length(set._inner);
350     }
351 
352     /**
353      * @dev Returns the value stored at position `index` in the set. O(1).
354      *
355      * Note that there are no guarantees on the ordering of values inside the
356      * array, and it may change when more values are added or removed.
357      *
358      * Requirements:
359      *
360      * - `index` must be strictly less than {length}.
361      */
362     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
363         return uint256(_at(set._inner, index));
364     }
365 
366     /**
367      * @dev Return the entire set in an array
368      *
369      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
370      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
371      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
372      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
373      */
374     function values(UintSet storage set) internal view returns (uint256[] memory) {
375         bytes32[] memory store = _values(set._inner);
376         uint256[] memory result;
377 
378         /// @solidity memory-safe-assembly
379         assembly {
380             result := store
381         }
382 
383         return result;
384     }
385 }
386 
387 // File: contracts/IOperatorFilterRegistry.sol
388 
389 
390 pragma solidity ^0.8.13;
391 
392 interface IOperatorFilterRegistry {
393     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
394     function register(address registrant) external;
395     function registerAndSubscribe(address registrant, address subscription) external;
396     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
397     function unregister(address addr) external;
398     function updateOperator(address registrant, address operator, bool filtered) external;
399     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
400     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
401     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
402     function subscribe(address registrant, address registrantToSubscribe) external;
403     function unsubscribe(address registrant, bool copyExistingEntries) external;
404     function subscriptionOf(address addr) external returns (address registrant);
405     function subscribers(address registrant) external returns (address[] memory);
406     function subscriberAt(address registrant, uint256 index) external returns (address);
407     function copyEntriesOf(address registrant, address registrantToCopy) external;
408     function isOperatorFiltered(address registrant, address operator) external returns (bool);
409     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
410     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
411     function filteredOperators(address addr) external returns (address[] memory);
412     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
413     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
414     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
415     function isRegistered(address addr) external returns (bool);
416     function codeHashOf(address addr) external returns (bytes32);
417 }
418 // File: contracts/OperatorFilterer.sol
419 
420 
421 // OpenZeppelin Contracts (last updated v4.8.0) (access/Ownable2Step.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Contract module which provides access control mechanism, where
427  * there is an account (an owner) that can be granted exclusive access to
428  * specific functions.
429  *
430  * By default, the owner account will be the one that deploys the contract. This
431  * can later be changed with {transferOwnership} and {acceptOwnership}.
432  *
433  * This module is used through inheritance. It will make available all functions
434  * from parent (Ownable).
435  */
436 
437 
438 
439 pragma solidity ^0.8.13;
440 
441 /**
442  * @title  OwnedRegistrant
443  * @notice Ownable contract that registers itself with the OperatorFilterRegistry and administers its own entries,
444  *         to facilitate a subscription whose ownership can be transferred.
445  */
446 
447 pragma solidity ^0.8.13;
448 
449 contract OperatorFilterRegistryErrorsAndEvents {
450     error CannotFilterEOAs();
451     error AddressAlreadyFiltered(address operator);
452     error AddressNotFiltered(address operator);
453     error CodeHashAlreadyFiltered(bytes32 codeHash);
454     error CodeHashNotFiltered(bytes32 codeHash);
455     error OnlyAddressOrOwner();
456     error NotRegistered(address registrant);
457     error AlreadyRegistered();
458     error AlreadySubscribed(address subscription);
459     error NotSubscribed();
460     error CannotUpdateWhileSubscribed(address subscription);
461     error CannotSubscribeToSelf();
462     error CannotSubscribeToZeroAddress();
463     error NotOwnable();
464     error AddressFiltered(address filtered);
465     error CodeHashFiltered(address account, bytes32 codeHash);
466     error CannotSubscribeToRegistrantWithSubscription(address registrant);
467     error CannotCopyFromSelf();
468 
469     event RegistrationUpdated(address indexed registrant, bool indexed registered);
470     event OperatorUpdated(address indexed registrant, address indexed operator, bool indexed filtered);
471     event OperatorsUpdated(address indexed registrant, address[] operators, bool indexed filtered);
472     event CodeHashUpdated(address indexed registrant, bytes32 indexed codeHash, bool indexed filtered);
473     event CodeHashesUpdated(address indexed registrant, bytes32[] codeHashes, bool indexed filtered);
474     event SubscriptionUpdated(address indexed registrant, address indexed subscription, bool indexed subscribed);
475 }
476 
477 pragma solidity ^0.8.13;
478 
479 /**
480  * @title  OperatorFilterRegistry
481  * @notice Borrows heavily from the QQL BlacklistOperatorFilter contract:
482  *         https://github.com/qql-art/contracts/blob/main/contracts/BlacklistOperatorFilter.sol
483  * @notice This contracts allows tokens or token owners to register specific addresses or codeHashes that may be
484  * *       restricted according to the isOperatorAllowed function.
485  */
486 contract OperatorFilterRegistry is IOperatorFilterRegistry, OperatorFilterRegistryErrorsAndEvents {
487     using EnumerableSet for EnumerableSet.AddressSet;
488     using EnumerableSet for EnumerableSet.Bytes32Set;
489 
490     /// @dev initialized accounts have a nonzero codehash (see https://eips.ethereum.org/EIPS/eip-1052)
491     /// Note that this will also be a smart contract's codehash when making calls from its constructor.
492     bytes32 constant EOA_CODEHASH = keccak256("");
493 
494     mapping(address => EnumerableSet.AddressSet) private _filteredOperators;
495     mapping(address => EnumerableSet.Bytes32Set) private _filteredCodeHashes;
496     mapping(address => address) private _registrations;
497     mapping(address => EnumerableSet.AddressSet) private _subscribers;
498 
499     /**
500      * @notice restricts method caller to the address or EIP-173 "owner()"
501      */
502     modifier onlyAddressOrOwner(address addr) {
503         if (msg.sender != addr) {
504             try Ownable(addr).owner() returns (address owner) {
505                 if (msg.sender != owner) {
506                     revert OnlyAddressOrOwner();
507                 }
508             } catch (bytes memory reason) {
509                 if (reason.length == 0) {
510                     revert NotOwnable();
511                 } else {
512                     /// @solidity memory-safe-assembly
513                     assembly {
514                         revert(add(32, reason), mload(reason))
515                     }
516                 }
517             }
518         }
519         _;
520     }
521 
522     /**
523      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
524      *         true if supplied registrant address is not registered.
525      */
526     function isOperatorAllowed(address registrant, address operator) external view returns (bool) {
527         address registration = _registrations[registrant];
528         if (registration != address(0)) {
529             EnumerableSet.AddressSet storage filteredOperatorsRef;
530             EnumerableSet.Bytes32Set storage filteredCodeHashesRef;
531 
532             filteredOperatorsRef = _filteredOperators[registration];
533             filteredCodeHashesRef = _filteredCodeHashes[registration];
534 
535             if (filteredOperatorsRef.contains(operator)) {
536                 revert AddressFiltered(operator);
537             }
538             if (operator.code.length > 0) {
539                 bytes32 codeHash = operator.codehash;
540                 if (filteredCodeHashesRef.contains(codeHash)) {
541                     revert CodeHashFiltered(operator, codeHash);
542                 }
543             }
544         }
545         return true;
546     }
547 
548     //////////////////
549     // AUTH METHODS //
550     //////////////////
551 
552     /**
553      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
554      */
555     function register(address registrant) external onlyAddressOrOwner(registrant) {
556         if (_registrations[registrant] != address(0)) {
557             revert AlreadyRegistered();
558         }
559         _registrations[registrant] = registrant;
560         emit RegistrationUpdated(registrant, true);
561     }
562 
563     /**
564      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
565      *         Note that this does not remove any filtered addresses or codeHashes.
566      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
567      */
568     function unregister(address registrant) external onlyAddressOrOwner(registrant) {
569         address registration = _registrations[registrant];
570         if (registration == address(0)) {
571             revert NotRegistered(registrant);
572         }
573         if (registration != registrant) {
574             _subscribers[registration].remove(registrant);
575             emit SubscriptionUpdated(registrant, registration, false);
576         }
577         _registrations[registrant] = address(0);
578         emit RegistrationUpdated(registrant, false);
579     }
580 
581     /**
582      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
583      */
584     function registerAndSubscribe(address registrant, address subscription) external onlyAddressOrOwner(registrant) {
585         address registration = _registrations[registrant];
586         if (registration != address(0)) {
587             revert AlreadyRegistered();
588         }
589         if (registrant == subscription) {
590             revert CannotSubscribeToSelf();
591         }
592         address subscriptionRegistration = _registrations[subscription];
593         if (subscriptionRegistration == address(0)) {
594             revert NotRegistered(subscription);
595         }
596         if (subscriptionRegistration != subscription) {
597             revert CannotSubscribeToRegistrantWithSubscription(subscription);
598         }
599 
600         _registrations[registrant] = subscription;
601         _subscribers[subscription].add(registrant);
602         emit RegistrationUpdated(registrant, true);
603         emit SubscriptionUpdated(registrant, subscription, true);
604     }
605 
606     /**
607      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
608      *         address without subscribing.
609      */
610     function registerAndCopyEntries(address registrant, address registrantToCopy)
611         external
612         onlyAddressOrOwner(registrant)
613     {
614         if (registrantToCopy == registrant) {
615             revert CannotCopyFromSelf();
616         }
617         address registration = _registrations[registrant];
618         if (registration != address(0)) {
619             revert AlreadyRegistered();
620         }
621         address registrantRegistration = _registrations[registrantToCopy];
622         if (registrantRegistration == address(0)) {
623             revert NotRegistered(registrantToCopy);
624         }
625         _registrations[registrant] = registrant;
626         emit RegistrationUpdated(registrant, true);
627         _copyEntries(registrant, registrantToCopy);
628     }
629 
630     /**
631      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
632      */
633     function updateOperator(address registrant, address operator, bool filtered)
634         external
635         onlyAddressOrOwner(registrant)
636     {
637         address registration = _registrations[registrant];
638         if (registration == address(0)) {
639             revert NotRegistered(registrant);
640         }
641         if (registration != registrant) {
642             revert CannotUpdateWhileSubscribed(registration);
643         }
644         EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrant];
645 
646         if (!filtered) {
647             bool removed = filteredOperatorsRef.remove(operator);
648             if (!removed) {
649                 revert AddressNotFiltered(operator);
650             }
651         } else {
652             bool added = filteredOperatorsRef.add(operator);
653             if (!added) {
654                 revert AddressAlreadyFiltered(operator);
655             }
656         }
657         emit OperatorUpdated(registrant, operator, filtered);
658     }
659 
660     /**
661      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
662      */
663     function updateCodeHash(address registrant, bytes32 codeHash, bool filtered)
664         external
665         onlyAddressOrOwner(registrant)
666     {
667         if (codeHash == EOA_CODEHASH) {
668             revert CannotFilterEOAs();
669         }
670         address registration = _registrations[registrant];
671         if (registration == address(0)) {
672             revert NotRegistered(registrant);
673         }
674         if (registration != registrant) {
675             revert CannotUpdateWhileSubscribed(registration);
676         }
677         EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrant];
678 
679         if (!filtered) {
680             bool removed = filteredCodeHashesRef.remove(codeHash);
681             if (!removed) {
682                 revert CodeHashNotFiltered(codeHash);
683             }
684         } else {
685             bool added = filteredCodeHashesRef.add(codeHash);
686             if (!added) {
687                 revert CodeHashAlreadyFiltered(codeHash);
688             }
689         }
690         emit CodeHashUpdated(registrant, codeHash, filtered);
691     }
692 
693     /**
694      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
695      */
696     function updateOperators(address registrant, address[] calldata operators, bool filtered)
697         external
698         onlyAddressOrOwner(registrant)
699     {
700         address registration = _registrations[registrant];
701         if (registration == address(0)) {
702             revert NotRegistered(registrant);
703         }
704         if (registration != registrant) {
705             revert CannotUpdateWhileSubscribed(registration);
706         }
707         EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrant];
708         uint256 operatorsLength = operators.length;
709         unchecked {
710             if (!filtered) {
711                 for (uint256 i = 0; i < operatorsLength; ++i) {
712                     address operator = operators[i];
713                     bool removed = filteredOperatorsRef.remove(operator);
714                     if (!removed) {
715                         revert AddressNotFiltered(operator);
716                     }
717                 }
718             } else {
719                 for (uint256 i = 0; i < operatorsLength; ++i) {
720                     address operator = operators[i];
721                     bool added = filteredOperatorsRef.add(operator);
722                     if (!added) {
723                         revert AddressAlreadyFiltered(operator);
724                     }
725                 }
726             }
727         }
728         emit OperatorsUpdated(registrant, operators, filtered);
729     }
730 
731     /**
732      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
733      */
734     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered)
735         external
736         onlyAddressOrOwner(registrant)
737     {
738         address registration = _registrations[registrant];
739         if (registration == address(0)) {
740             revert NotRegistered(registrant);
741         }
742         if (registration != registrant) {
743             revert CannotUpdateWhileSubscribed(registration);
744         }
745         EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrant];
746         uint256 codeHashesLength = codeHashes.length;
747         unchecked {
748             if (!filtered) {
749                 for (uint256 i = 0; i < codeHashesLength; ++i) {
750                     bytes32 codeHash = codeHashes[i];
751                     bool removed = filteredCodeHashesRef.remove(codeHash);
752                     if (!removed) {
753                         revert CodeHashNotFiltered(codeHash);
754                     }
755                 }
756             } else {
757                 for (uint256 i = 0; i < codeHashesLength; ++i) {
758                     bytes32 codeHash = codeHashes[i];
759                     if (codeHash == EOA_CODEHASH) {
760                         revert CannotFilterEOAs();
761                     }
762                     bool added = filteredCodeHashesRef.add(codeHash);
763                     if (!added) {
764                         revert CodeHashAlreadyFiltered(codeHash);
765                     }
766                 }
767             }
768         }
769         emit CodeHashesUpdated(registrant, codeHashes, filtered);
770     }
771 
772     /**
773      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
774      *         subscription if present.
775      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
776      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
777      *         used.
778      */
779     function subscribe(address registrant, address newSubscription) external onlyAddressOrOwner(registrant) {
780         if (registrant == newSubscription) {
781             revert CannotSubscribeToSelf();
782         }
783         if (newSubscription == address(0)) {
784             revert CannotSubscribeToZeroAddress();
785         }
786         address registration = _registrations[registrant];
787         if (registration == address(0)) {
788             revert NotRegistered(registrant);
789         }
790         if (registration == newSubscription) {
791             revert AlreadySubscribed(newSubscription);
792         }
793         address newSubscriptionRegistration = _registrations[newSubscription];
794         if (newSubscriptionRegistration == address(0)) {
795             revert NotRegistered(newSubscription);
796         }
797         if (newSubscriptionRegistration != newSubscription) {
798             revert CannotSubscribeToRegistrantWithSubscription(newSubscription);
799         }
800 
801         if (registration != registrant) {
802             _subscribers[registration].remove(registrant);
803             emit SubscriptionUpdated(registrant, registration, false);
804         }
805         _registrations[registrant] = newSubscription;
806         _subscribers[newSubscription].add(registrant);
807         emit SubscriptionUpdated(registrant, newSubscription, true);
808     }
809 
810     /**
811      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
812      */
813     function unsubscribe(address registrant, bool copyExistingEntries) external onlyAddressOrOwner(registrant) {
814         address registration = _registrations[registrant];
815         if (registration == address(0)) {
816             revert NotRegistered(registrant);
817         }
818         if (registration == registrant) {
819             revert NotSubscribed();
820         }
821         _subscribers[registration].remove(registrant);
822         _registrations[registrant] = registrant;
823         emit SubscriptionUpdated(registrant, registration, false);
824         if (copyExistingEntries) {
825             _copyEntries(registrant, registration);
826         }
827     }
828 
829     /**
830      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
831      */
832     function copyEntriesOf(address registrant, address registrantToCopy) external onlyAddressOrOwner(registrant) {
833         if (registrant == registrantToCopy) {
834             revert CannotCopyFromSelf();
835         }
836         address registration = _registrations[registrant];
837         if (registration == address(0)) {
838             revert NotRegistered(registrant);
839         }
840         if (registration != registrant) {
841             revert CannotUpdateWhileSubscribed(registration);
842         }
843         address registrantRegistration = _registrations[registrantToCopy];
844         if (registrantRegistration == address(0)) {
845             revert NotRegistered(registrantToCopy);
846         }
847         _copyEntries(registrant, registrantToCopy);
848     }
849 
850     /// @dev helper to copy entries from registrantToCopy to registrant and emit events
851     function _copyEntries(address registrant, address registrantToCopy) private {
852         EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrantToCopy];
853         EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrantToCopy];
854         uint256 filteredOperatorsLength = filteredOperatorsRef.length();
855         uint256 filteredCodeHashesLength = filteredCodeHashesRef.length();
856         unchecked {
857             for (uint256 i = 0; i < filteredOperatorsLength; ++i) {
858                 address operator = filteredOperatorsRef.at(i);
859                 bool added = _filteredOperators[registrant].add(operator);
860                 if (added) {
861                     emit OperatorUpdated(registrant, operator, true);
862                 }
863             }
864             for (uint256 i = 0; i < filteredCodeHashesLength; ++i) {
865                 bytes32 codehash = filteredCodeHashesRef.at(i);
866                 bool added = _filteredCodeHashes[registrant].add(codehash);
867                 if (added) {
868                     emit CodeHashUpdated(registrant, codehash, true);
869                 }
870             }
871         }
872     }
873 
874     //////////////////
875     // VIEW METHODS //
876     //////////////////
877 
878     /**
879      * @notice Get the subscription address of a given registrant, if any.
880      */
881     function subscriptionOf(address registrant) external view returns (address subscription) {
882         subscription = _registrations[registrant];
883         if (subscription == address(0)) {
884             revert NotRegistered(registrant);
885         } else if (subscription == registrant) {
886             subscription = address(0);
887         }
888     }
889 
890     /**
891      * @notice Get the set of addresses subscribed to a given registrant.
892      *         Note that order is not guaranteed as updates are made.
893      */
894     function subscribers(address registrant) external view returns (address[] memory) {
895         return _subscribers[registrant].values();
896     }
897 
898     /**
899      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
900      *         Note that order is not guaranteed as updates are made.
901      */
902     function subscriberAt(address registrant, uint256 index) external view returns (address) {
903         return _subscribers[registrant].at(index);
904     }
905 
906     /**
907      * @notice Returns true if operator is filtered by a given address or its subscription.
908      */
909     function isOperatorFiltered(address registrant, address operator) external view returns (bool) {
910         address registration = _registrations[registrant];
911         if (registration != registrant) {
912             return _filteredOperators[registration].contains(operator);
913         }
914         return _filteredOperators[registrant].contains(operator);
915     }
916 
917     /**
918      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
919      */
920     function isCodeHashFiltered(address registrant, bytes32 codeHash) external view returns (bool) {
921         address registration = _registrations[registrant];
922         if (registration != registrant) {
923             return _filteredCodeHashes[registration].contains(codeHash);
924         }
925         return _filteredCodeHashes[registrant].contains(codeHash);
926     }
927 
928     /**
929      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
930      */
931     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external view returns (bool) {
932         bytes32 codeHash = operatorWithCode.codehash;
933         address registration = _registrations[registrant];
934         if (registration != registrant) {
935             return _filteredCodeHashes[registration].contains(codeHash);
936         }
937         return _filteredCodeHashes[registrant].contains(codeHash);
938     }
939 
940     /**
941      * @notice Returns true if an address has registered
942      */
943     function isRegistered(address registrant) external view returns (bool) {
944         return _registrations[registrant] != address(0);
945     }
946 
947     /**
948      * @notice Returns a list of filtered operators for a given address or its subscription.
949      */
950     function filteredOperators(address registrant) external view returns (address[] memory) {
951         address registration = _registrations[registrant];
952         if (registration != registrant) {
953             return _filteredOperators[registration].values();
954         }
955         return _filteredOperators[registrant].values();
956     }
957 
958     /**
959      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
960      *         Note that order is not guaranteed as updates are made.
961      */
962     function filteredCodeHashes(address registrant) external view returns (bytes32[] memory) {
963         address registration = _registrations[registrant];
964         if (registration != registrant) {
965             return _filteredCodeHashes[registration].values();
966         }
967         return _filteredCodeHashes[registrant].values();
968     }
969 
970     /**
971      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
972      *         its subscription.
973      *         Note that order is not guaranteed as updates are made.
974      */
975     function filteredOperatorAt(address registrant, uint256 index) external view returns (address) {
976         address registration = _registrations[registrant];
977         if (registration != registrant) {
978             return _filteredOperators[registration].at(index);
979         }
980         return _filteredOperators[registrant].at(index);
981     }
982 
983     /**
984      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
985      *         its subscription.
986      *         Note that order is not guaranteed as updates are made.
987      */
988     function filteredCodeHashAt(address registrant, uint256 index) external view returns (bytes32) {
989         address registration = _registrations[registrant];
990         if (registration != registrant) {
991             return _filteredCodeHashes[registration].at(index);
992         }
993         return _filteredCodeHashes[registrant].at(index);
994     }
995 
996     /// @dev Convenience method to compute the code hash of an arbitrary contract
997     function codeHashOf(address a) external view returns (bytes32) {
998         return a.codehash;
999     }
1000 }
1001 
1002 
1003 pragma solidity ^0.8.13;
1004 
1005 
1006 abstract contract OperatorFilterer {
1007     error OperatorNotAllowed(address operator);
1008 
1009     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1010         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1011 
1012     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1013         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1014         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1015         // order for the modifier to filter addresses.
1016         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1017             if (subscribe) {
1018                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1019             } else {
1020                 if (subscriptionOrRegistrantToCopy != address(0)) {
1021                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1022                 } else {
1023                     OPERATOR_FILTER_REGISTRY.register(address(this));
1024                 }
1025             }
1026         }
1027     }
1028 
1029     modifier onlyAllowedOperator(address from) virtual {
1030         // Allow spending tokens from addresses with balance
1031         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1032         // from an EOA.
1033         if (from != msg.sender) {
1034             _checkFilterOperator(msg.sender);
1035         }
1036         _;
1037     }
1038 
1039     modifier onlyAllowedOperatorApproval(address operator) virtual {
1040         _checkFilterOperator(operator);
1041         _;
1042     }
1043 
1044     function _checkFilterOperator(address operator) internal view virtual {
1045         // Check registry code length to facilitate testing in environments without a deployed registry.
1046         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1047             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1048                 revert OperatorNotAllowed(operator);
1049             }
1050         }
1051     }
1052 }
1053 
1054 
1055 // File: contracts/DefaultOperatorFilterer.sol
1056 
1057 
1058 pragma solidity ^0.8.13;
1059 
1060 
1061 /**
1062  * @title  DefaultOperatorFilterer
1063  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1064  */
1065 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1066     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1067 
1068     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1069 }
1070 // File: @openzeppelin/contracts/utils/math/Math.sol
1071 
1072 
1073 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1074 
1075 pragma solidity ^0.8.0;
1076 
1077 /**
1078  * @dev Standard math utilities missing in the Solidity language.
1079  */
1080 library Math {
1081     enum Rounding {
1082         Down, // Toward negative infinity
1083         Up, // Toward infinity
1084         Zero // Toward zero
1085     }
1086 
1087     /**
1088      * @dev Returns the largest of two numbers.
1089      */
1090     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1091         return a > b ? a : b;
1092     }
1093 
1094     /**
1095      * @dev Returns the smallest of two numbers.
1096      */
1097     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1098         return a < b ? a : b;
1099     }
1100 
1101     /**
1102      * @dev Returns the average of two numbers. The result is rounded towards
1103      * zero.
1104      */
1105     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1106         // (a + b) / 2 can overflow.
1107         return (a & b) + (a ^ b) / 2;
1108     }
1109 
1110     /**
1111      * @dev Returns the ceiling of the division of two numbers.
1112      *
1113      * This differs from standard division with `/` in that it rounds up instead
1114      * of rounding down.
1115      */
1116     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1117         // (a + b - 1) / b can overflow on addition, so we distribute.
1118         return a == 0 ? 0 : (a - 1) / b + 1;
1119     }
1120 
1121     /**
1122      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1123      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1124      * with further edits by Uniswap Labs also under MIT license.
1125      */
1126     function mulDiv(
1127         uint256 x,
1128         uint256 y,
1129         uint256 denominator
1130     ) internal pure returns (uint256 result) {
1131         unchecked {
1132             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1133             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1134             // variables such that product = prod1 * 2^256 + prod0.
1135             uint256 prod0; // Least significant 256 bits of the product
1136             uint256 prod1; // Most significant 256 bits of the product
1137             assembly {
1138                 let mm := mulmod(x, y, not(0))
1139                 prod0 := mul(x, y)
1140                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1141             }
1142 
1143             // Handle non-overflow cases, 256 by 256 division.
1144             if (prod1 == 0) {
1145                 return prod0 / denominator;
1146             }
1147 
1148             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1149             require(denominator > prod1);
1150 
1151             ///////////////////////////////////////////////
1152             // 512 by 256 division.
1153             ///////////////////////////////////////////////
1154 
1155             // Make division exact by subtracting the remainder from [prod1 prod0].
1156             uint256 remainder;
1157             assembly {
1158                 // Compute remainder using mulmod.
1159                 remainder := mulmod(x, y, denominator)
1160 
1161                 // Subtract 256 bit number from 512 bit number.
1162                 prod1 := sub(prod1, gt(remainder, prod0))
1163                 prod0 := sub(prod0, remainder)
1164             }
1165 
1166             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1167             // See https://cs.stackexchange.com/q/138556/92363.
1168 
1169             // Does not overflow because the denominator cannot be zero at this stage in the function.
1170             uint256 twos = denominator & (~denominator + 1);
1171             assembly {
1172                 // Divide denominator by twos.
1173                 denominator := div(denominator, twos)
1174 
1175                 // Divide [prod1 prod0] by twos.
1176                 prod0 := div(prod0, twos)
1177 
1178                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1179                 twos := add(div(sub(0, twos), twos), 1)
1180             }
1181 
1182             // Shift in bits from prod1 into prod0.
1183             prod0 |= prod1 * twos;
1184 
1185             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1186             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1187             // four bits. That is, denominator * inv = 1 mod 2^4.
1188             uint256 inverse = (3 * denominator) ^ 2;
1189 
1190             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1191             // in modular arithmetic, doubling the correct bits in each step.
1192             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1193             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1194             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1195             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1196             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1197             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1198 
1199             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1200             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1201             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1202             // is no longer required.
1203             result = prod0 * inverse;
1204             return result;
1205         }
1206     }
1207 
1208     /**
1209      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1210      */
1211     function mulDiv(
1212         uint256 x,
1213         uint256 y,
1214         uint256 denominator,
1215         Rounding rounding
1216     ) internal pure returns (uint256) {
1217         uint256 result = mulDiv(x, y, denominator);
1218         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1219             result += 1;
1220         }
1221         return result;
1222     }
1223 
1224     /**
1225      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1226      *
1227      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1228      */
1229     function sqrt(uint256 a) internal pure returns (uint256) {
1230         if (a == 0) {
1231             return 0;
1232         }
1233 
1234         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1235         //
1236         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1237         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1238         //
1239         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1240         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1241         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1242         //
1243         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1244         uint256 result = 1 << (log2(a) >> 1);
1245 
1246         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1247         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1248         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1249         // into the expected uint128 result.
1250         unchecked {
1251             result = (result + a / result) >> 1;
1252             result = (result + a / result) >> 1;
1253             result = (result + a / result) >> 1;
1254             result = (result + a / result) >> 1;
1255             result = (result + a / result) >> 1;
1256             result = (result + a / result) >> 1;
1257             result = (result + a / result) >> 1;
1258             return min(result, a / result);
1259         }
1260     }
1261 
1262     /**
1263      * @notice Calculates sqrt(a), following the selected rounding direction.
1264      */
1265     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1266         unchecked {
1267             uint256 result = sqrt(a);
1268             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1269         }
1270     }
1271 
1272     /**
1273      * @dev Return the log in base 2, rounded down, of a positive value.
1274      * Returns 0 if given 0.
1275      */
1276     function log2(uint256 value) internal pure returns (uint256) {
1277         uint256 result = 0;
1278         unchecked {
1279             if (value >> 128 > 0) {
1280                 value >>= 128;
1281                 result += 128;
1282             }
1283             if (value >> 64 > 0) {
1284                 value >>= 64;
1285                 result += 64;
1286             }
1287             if (value >> 32 > 0) {
1288                 value >>= 32;
1289                 result += 32;
1290             }
1291             if (value >> 16 > 0) {
1292                 value >>= 16;
1293                 result += 16;
1294             }
1295             if (value >> 8 > 0) {
1296                 value >>= 8;
1297                 result += 8;
1298             }
1299             if (value >> 4 > 0) {
1300                 value >>= 4;
1301                 result += 4;
1302             }
1303             if (value >> 2 > 0) {
1304                 value >>= 2;
1305                 result += 2;
1306             }
1307             if (value >> 1 > 0) {
1308                 result += 1;
1309             }
1310         }
1311         return result;
1312     }
1313 
1314     /**
1315      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1316      * Returns 0 if given 0.
1317      */
1318     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1319         unchecked {
1320             uint256 result = log2(value);
1321             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1322         }
1323     }
1324 
1325     /**
1326      * @dev Return the log in base 10, rounded down, of a positive value.
1327      * Returns 0 if given 0.
1328      */
1329     function log10(uint256 value) internal pure returns (uint256) {
1330         uint256 result = 0;
1331         unchecked {
1332             if (value >= 10**64) {
1333                 value /= 10**64;
1334                 result += 64;
1335             }
1336             if (value >= 10**32) {
1337                 value /= 10**32;
1338                 result += 32;
1339             }
1340             if (value >= 10**16) {
1341                 value /= 10**16;
1342                 result += 16;
1343             }
1344             if (value >= 10**8) {
1345                 value /= 10**8;
1346                 result += 8;
1347             }
1348             if (value >= 10**4) {
1349                 value /= 10**4;
1350                 result += 4;
1351             }
1352             if (value >= 10**2) {
1353                 value /= 10**2;
1354                 result += 2;
1355             }
1356             if (value >= 10**1) {
1357                 result += 1;
1358             }
1359         }
1360         return result;
1361     }
1362 
1363     /**
1364      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1365      * Returns 0 if given 0.
1366      */
1367     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1368         unchecked {
1369             uint256 result = log10(value);
1370             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1371         }
1372     }
1373 
1374     /**
1375      * @dev Return the log in base 256, rounded down, of a positive value.
1376      * Returns 0 if given 0.
1377      *
1378      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1379      */
1380     function log256(uint256 value) internal pure returns (uint256) {
1381         uint256 result = 0;
1382         unchecked {
1383             if (value >> 128 > 0) {
1384                 value >>= 128;
1385                 result += 16;
1386             }
1387             if (value >> 64 > 0) {
1388                 value >>= 64;
1389                 result += 8;
1390             }
1391             if (value >> 32 > 0) {
1392                 value >>= 32;
1393                 result += 4;
1394             }
1395             if (value >> 16 > 0) {
1396                 value >>= 16;
1397                 result += 2;
1398             }
1399             if (value >> 8 > 0) {
1400                 result += 1;
1401             }
1402         }
1403         return result;
1404     }
1405 
1406     /**
1407      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1408      * Returns 0 if given 0.
1409      */
1410     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1411         unchecked {
1412             uint256 result = log256(value);
1413             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1414         }
1415     }
1416 }
1417 
1418 // File: @openzeppelin/contracts/utils/Strings.sol
1419 
1420 
1421 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1422 
1423 pragma solidity ^0.8.0;
1424 
1425 
1426 /**
1427  * @dev String operations.
1428  */
1429 library Strings {
1430     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1431     uint8 private constant _ADDRESS_LENGTH = 20;
1432 
1433     /**
1434      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1435      */
1436     function toString(uint256 value) internal pure returns (string memory) {
1437         unchecked {
1438             uint256 length = Math.log10(value) + 1;
1439             string memory buffer = new string(length);
1440             uint256 ptr;
1441             /// @solidity memory-safe-assembly
1442             assembly {
1443                 ptr := add(buffer, add(32, length))
1444             }
1445             while (true) {
1446                 ptr--;
1447                 /// @solidity memory-safe-assembly
1448                 assembly {
1449                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1450                 }
1451                 value /= 10;
1452                 if (value == 0) break;
1453             }
1454             return buffer;
1455         }
1456     }
1457 
1458     /**
1459      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1460      */
1461     function toHexString(uint256 value) internal pure returns (string memory) {
1462         unchecked {
1463             return toHexString(value, Math.log256(value) + 1);
1464         }
1465     }
1466 
1467     /**
1468      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1469      */
1470     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1471         bytes memory buffer = new bytes(2 * length + 2);
1472         buffer[0] = "0";
1473         buffer[1] = "x";
1474         for (uint256 i = 2 * length + 1; i > 1; --i) {
1475             buffer[i] = _SYMBOLS[value & 0xf];
1476             value >>= 4;
1477         }
1478         require(value == 0, "Strings: hex length insufficient");
1479         return string(buffer);
1480     }
1481 
1482     /**
1483      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1484      */
1485     function toHexString(address addr) internal pure returns (string memory) {
1486         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1487     }
1488 }
1489 
1490 // File: @openzeppelin/contracts/utils/Address.sol
1491 
1492 
1493 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1494 
1495 pragma solidity ^0.8.1;
1496 
1497 /**
1498  * @dev Collection of functions related to the address type
1499  */
1500 library Address {
1501     /**
1502      * @dev Returns true if `account` is a contract.
1503      *
1504      * [IMPORTANT]
1505      * ====
1506      * It is unsafe to assume that an address for which this function returns
1507      * false is an externally-owned account (EOA) and not a contract.
1508      *
1509      * Among others, `isContract` will return false for the following
1510      * types of addresses:
1511      *
1512      *  - an externally-owned account
1513      *  - a contract in construction
1514      *  - an address where a contract will be created
1515      *  - an address where a contract lived, but was destroyed
1516      * ====
1517      *
1518      * [IMPORTANT]
1519      * ====
1520      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1521      *
1522      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1523      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1524      * constructor.
1525      * ====
1526      */
1527     function isContract(address account) internal view returns (bool) {
1528         // This method relies on extcodesize/address.code.length, which returns 0
1529         // for contracts in construction, since the code is only stored at the end
1530         // of the constructor execution.
1531 
1532         return account.code.length > 0;
1533     }
1534 
1535     /**
1536      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1537      * `recipient`, forwarding all available gas and reverting on errors.
1538      *
1539      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1540      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1541      * imposed by `transfer`, making them unable to receive funds via
1542      * `transfer`. {sendValue} removes this limitation.
1543      *
1544      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1545      *
1546      * IMPORTANT: because control is transferred to `recipient`, care must be
1547      * taken to not create reentrancy vulnerabilities. Consider using
1548      * {ReentrancyGuard} or the
1549      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1550      */
1551     function sendValue(address payable recipient, uint256 amount) internal {
1552         require(address(this).balance >= amount, "Address: insufficient balance");
1553 
1554         (bool success, ) = recipient.call{value: amount}("");
1555         require(success, "Address: unable to send value, recipient may have reverted");
1556     }
1557 
1558     /**
1559      * @dev Performs a Solidity function call using a low level `call`. A
1560      * plain `call` is an unsafe replacement for a function call: use this
1561      * function instead.
1562      *
1563      * If `target` reverts with a revert reason, it is bubbled up by this
1564      * function (like regular Solidity function calls).
1565      *
1566      * Returns the raw returned data. To convert to the expected return value,
1567      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1568      *
1569      * Requirements:
1570      *
1571      * - `target` must be a contract.
1572      * - calling `target` with `data` must not revert.
1573      *
1574      * _Available since v3.1._
1575      */
1576     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1577         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1578     }
1579 
1580     /**
1581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1582      * `errorMessage` as a fallback revert reason when `target` reverts.
1583      *
1584      * _Available since v3.1._
1585      */
1586     function functionCall(
1587         address target,
1588         bytes memory data,
1589         string memory errorMessage
1590     ) internal returns (bytes memory) {
1591         return functionCallWithValue(target, data, 0, errorMessage);
1592     }
1593 
1594     /**
1595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1596      * but also transferring `value` wei to `target`.
1597      *
1598      * Requirements:
1599      *
1600      * - the calling contract must have an ETH balance of at least `value`.
1601      * - the called Solidity function must be `payable`.
1602      *
1603      * _Available since v3.1._
1604      */
1605     function functionCallWithValue(
1606         address target,
1607         bytes memory data,
1608         uint256 value
1609     ) internal returns (bytes memory) {
1610         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1611     }
1612 
1613     /**
1614      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1615      * with `errorMessage` as a fallback revert reason when `target` reverts.
1616      *
1617      * _Available since v3.1._
1618      */
1619     function functionCallWithValue(
1620         address target,
1621         bytes memory data,
1622         uint256 value,
1623         string memory errorMessage
1624     ) internal returns (bytes memory) {
1625         require(address(this).balance >= value, "Address: insufficient balance for call");
1626         (bool success, bytes memory returndata) = target.call{value: value}(data);
1627         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1628     }
1629 
1630     /**
1631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1632      * but performing a static call.
1633      *
1634      * _Available since v3.3._
1635      */
1636     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1637         return functionStaticCall(target, data, "Address: low-level static call failed");
1638     }
1639 
1640     /**
1641      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1642      * but performing a static call.
1643      *
1644      * _Available since v3.3._
1645      */
1646     function functionStaticCall(
1647         address target,
1648         bytes memory data,
1649         string memory errorMessage
1650     ) internal view returns (bytes memory) {
1651         (bool success, bytes memory returndata) = target.staticcall(data);
1652         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1653     }
1654 
1655     /**
1656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1657      * but performing a delegate call.
1658      *
1659      * _Available since v3.4._
1660      */
1661     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1662         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1663     }
1664 
1665     /**
1666      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1667      * but performing a delegate call.
1668      *
1669      * _Available since v3.4._
1670      */
1671     function functionDelegateCall(
1672         address target,
1673         bytes memory data,
1674         string memory errorMessage
1675     ) internal returns (bytes memory) {
1676         (bool success, bytes memory returndata) = target.delegatecall(data);
1677         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1678     }
1679 
1680     /**
1681      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1682      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1683      *
1684      * _Available since v4.8._
1685      */
1686     function verifyCallResultFromTarget(
1687         address target,
1688         bool success,
1689         bytes memory returndata,
1690         string memory errorMessage
1691     ) internal view returns (bytes memory) {
1692         if (success) {
1693             if (returndata.length == 0) {
1694                 // only check isContract if the call was successful and the return data is empty
1695                 // otherwise we already know that it was a contract
1696                 require(isContract(target), "Address: call to non-contract");
1697             }
1698             return returndata;
1699         } else {
1700             _revert(returndata, errorMessage);
1701         }
1702     }
1703 
1704     /**
1705      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1706      * revert reason or using the provided one.
1707      *
1708      * _Available since v4.3._
1709      */
1710     function verifyCallResult(
1711         bool success,
1712         bytes memory returndata,
1713         string memory errorMessage
1714     ) internal pure returns (bytes memory) {
1715         if (success) {
1716             return returndata;
1717         } else {
1718             _revert(returndata, errorMessage);
1719         }
1720     }
1721 
1722     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1723         // Look for revert reason and bubble it up if present
1724         if (returndata.length > 0) {
1725             // The easiest way to bubble the revert reason is using memory via assembly
1726             /// @solidity memory-safe-assembly
1727             assembly {
1728                 let returndata_size := mload(returndata)
1729                 revert(add(32, returndata), returndata_size)
1730             }
1731         } else {
1732             revert(errorMessage);
1733         }
1734     }
1735 }
1736 
1737 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1738 
1739 
1740 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1741 
1742 pragma solidity ^0.8.0;
1743 
1744 /**
1745  * @title ERC721 token receiver interface
1746  * @dev Interface for any contract that wants to support safeTransfers
1747  * from ERC721 asset contracts.
1748  */
1749 interface IERC721Receiver {
1750     /**
1751      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1752      * by `operator` from `from`, this function is called.
1753      *
1754      * It must return its Solidity selector to confirm the token transfer.
1755      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1756      *
1757      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1758      */
1759     function onERC721Received(
1760         address operator,
1761         address from,
1762         uint256 tokenId,
1763         bytes calldata data
1764     ) external returns (bytes4);
1765 }
1766 
1767 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1768 
1769 
1770 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1771 
1772 
1773 
1774 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1775 
1776 
1777 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1778 
1779 
1780 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1781 
1782 pragma solidity ^0.8.0;
1783 
1784 /**
1785  * @dev Interface of the ERC165 standard, as defined in the
1786  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1787  *
1788  * Implementers can declare support of contract interfaces, which can then be
1789  * queried by others ({ERC165Checker}).
1790  *
1791  * For an implementation, see {ERC165}.
1792  */
1793 interface IERC165 {
1794     /**
1795      * @dev Returns true if this contract implements the interface defined by
1796      * `interfaceId`. See the corresponding
1797      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1798      * to learn more about how these ids are created.
1799      *
1800      * This function call must use less than 30 000 gas.
1801      */
1802     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1803 }
1804 
1805 
1806 
1807 pragma solidity ^0.8.0;
1808 
1809 
1810 /**
1811  * @dev Implementation of the {IERC165} interface.
1812  *
1813  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1814  * for the additional interface id that will be supported. For example:
1815  *
1816  * ```solidity
1817  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1818  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1819  * }
1820  * ```
1821  *
1822  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1823  */
1824 abstract contract ERC165 is IERC165 {
1825     /**
1826      * @dev See {IERC165-supportsInterface}.
1827      */
1828     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1829         return interfaceId == type(IERC165).interfaceId;
1830     }
1831 }
1832 
1833 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1834 
1835 
1836 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1837 
1838 pragma solidity ^0.8.0;
1839 
1840 
1841 /**
1842  * @dev Required interface of an ERC721 compliant contract.
1843  */
1844 interface IERC721 is IERC165 {
1845     /**
1846      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1847      */
1848     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1849 
1850     /**
1851      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1852      */
1853     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1854 
1855     /**
1856      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1857      */
1858     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1859 
1860     /**
1861      * @dev Returns the number of tokens in ``owner``'s account.
1862      */
1863     function balanceOf(address owner) external view returns (uint256 balance);
1864 
1865     /**
1866      * @dev Returns the owner of the `tokenId` token.
1867      *
1868      * Requirements:
1869      *
1870      * - `tokenId` must exist.
1871      */
1872     function ownerOf(uint256 tokenId) external view returns (address owner);
1873 
1874     /**
1875      * @dev Safely transfers `tokenId` token from `from` to `to`.
1876      *
1877      * Requirements:
1878      *
1879      * - `from` cannot be the zero address.
1880      * - `to` cannot be the zero address.
1881      * - `tokenId` token must exist and be owned by `from`.
1882      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1884      *
1885      * Emits a {Transfer} event.
1886      */
1887     function safeTransferFrom(
1888         address from,
1889         address to,
1890         uint256 tokenId,
1891         bytes calldata data
1892     ) external ;
1893 
1894     /**
1895      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1896      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1897      *
1898      * Requirements:
1899      *
1900      * - `from` cannot be the zero address.
1901      * - `to` cannot be the zero address.
1902      * - `tokenId` token must exist and be owned by `from`.
1903      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1905      *
1906      * Emits a {Transfer} event.
1907      */
1908     function safeTransferFrom(
1909         address from,
1910         address to,
1911         uint256 tokenId
1912     ) external;
1913 
1914     /**
1915      * @dev Transfers `tokenId` token from `from` to `to`.
1916      *
1917      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1918      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1919      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1920      *
1921      * Requirements:
1922      *
1923      * - `from` cannot be the zero address.
1924      * - `to` cannot be the zero address.
1925      * - `tokenId` token must be owned by `from`.
1926      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1927      *
1928      * Emits a {Transfer} event.
1929      */
1930     function transferFrom(
1931         address from,
1932         address to,
1933         uint256 tokenId
1934     ) external;
1935 
1936     /**
1937      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1938      * The approval is cleared when the token is transferred.
1939      *
1940      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1941      *
1942      * Requirements:
1943      *
1944      * - The caller must own the token or be an approved operator.
1945      * - `tokenId` must exist.
1946      *
1947      * Emits an {Approval} event.
1948      */
1949     function approve(address to, uint256 tokenId) external;
1950 
1951     /**
1952      * @dev Approve or remove `operator` as an operator for the caller.
1953      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1954      *
1955      * Requirements:
1956      *
1957      * - The `operator` cannot be the caller.
1958      *
1959      * Emits an {ApprovalForAll} event.
1960      */
1961     function setApprovalForAll(address operator, bool _approved) external;
1962 
1963     /**
1964      * @dev Returns the account approved for `tokenId` token.
1965      *
1966      * Requirements:
1967      *
1968      * - `tokenId` must exist.
1969      */
1970     function getApproved(uint256 tokenId) external view returns (address operator);
1971 
1972     /**
1973      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1974      *
1975      * See {setApprovalForAll}
1976      */
1977     function isApprovedForAll(address owner, address operator) external view returns (bool);
1978 }
1979 
1980 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1981 
1982 
1983 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1984 
1985 pragma solidity ^0.8.0;
1986 
1987 
1988 /**
1989  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1990  * @dev See https://eips.ethereum.org/EIPS/eip-721
1991  */
1992 interface IERC721Metadata is IERC721 {
1993     /**
1994      * @dev Returns the token collection name.
1995      */
1996     function name() external view returns (string memory);
1997 
1998     /**
1999      * @dev Returns the token collection symbol.
2000      */
2001     function symbol() external view returns (string memory);
2002 
2003     /**
2004      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2005      */
2006     function tokenURI(uint256 tokenId) external view returns (string memory);
2007 }
2008 
2009 // File: @openzeppelin/contracts/utils/Context.sol
2010 
2011 pragma solidity ^0.8.0;
2012 
2013 
2014 
2015 interface IERC721Enumerable is IERC721 {
2016   
2017     function totalSupply() external view returns (uint256);
2018 
2019 
2020     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
2021 
2022 
2023     function tokenByIndex(uint256 index) external view returns (uint256);
2024 }
2025 
2026 pragma solidity ^0.8.0;
2027 
2028 abstract contract ReentrancyGuard {
2029 
2030     uint256 private constant _NOT_ENTERED = 1;
2031     uint256 private constant _ENTERED = 2;
2032 
2033     uint256 private _status;
2034 
2035     constructor() {
2036         _status = _NOT_ENTERED;
2037     }
2038 
2039 
2040     modifier nonReentrant() {
2041         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2042 
2043         _status = _ENTERED;
2044 
2045         _;
2046 
2047         _status = _NOT_ENTERED;
2048     }
2049 }
2050 
2051 
2052 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2053 
2054 pragma solidity ^0.8.0;
2055 
2056 /**
2057  * @dev Provides information about the current execution context, including the
2058  * sender of the transaction and its data. While these are generally available
2059  * via msg.sender and msg.data, they should not be accessed in such a direct
2060  * manner, since when dealing with meta-transactions the account sending and
2061  * paying for execution may not be the actual sender (as far as an application
2062  * is concerned).
2063  *
2064  * This contract is only required for intermediate, library-like contracts.
2065  */
2066 abstract contract Context {
2067     function _msgSender() internal view virtual returns (address) {
2068         return msg.sender;
2069     }
2070 
2071     function _msgData() internal view virtual returns (bytes calldata) {
2072         return msg.data;
2073     }
2074 }
2075 
2076 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2077 
2078 
2079 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
2080 
2081 pragma solidity ^0.8.0;
2082 
2083 
2084 
2085 
2086 // File: @openzeppelin/contracts/access/Ownable.sol
2087 
2088 
2089 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2090 
2091 pragma solidity ^0.8.0;
2092 
2093 
2094 error ApprovalCallerNotOwnerNorApproved();
2095 error ApprovalQueryForNonexistentToken();
2096 error ApproveToCaller();
2097 error ApprovalToCurrentOwner();
2098 error BalanceQueryForZeroAddress();
2099 error MintToZeroAddress();
2100 error MintZeroQuantity();
2101 error OwnerQueryForNonexistentToken();
2102 error TransferCallerNotOwnerNorApproved();
2103 error TransferFromIncorrectOwner();
2104 error TransferToNonERC721ReceiverImplementer();
2105 error TransferToZeroAddress();
2106 error URIQueryForNonexistentToken();
2107 
2108 /**
2109  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2110  * the Metadata extension. Built to optimize for lower gas during batch mints.
2111  *
2112  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2113  *
2114  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2115  *
2116  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2117  */
2118 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, DefaultOperatorFilterer {
2119     using Address for address;
2120     using Strings for uint256;
2121 
2122     // Compiler will pack this into a single 256bit word.
2123     struct TokenOwnership {
2124         // The address of the owner.
2125         address addr;
2126         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2127         uint64 startTimestamp;
2128         // Whether the token has been burned.
2129         bool burned;
2130     }
2131 
2132     // Compiler will pack this into a single 256bit word.
2133     struct AddressData {
2134         // Realistically, 2**64-1 is more than enough.
2135         uint64 balance;
2136         // Keeps track of mint count with minimal overhead for tokenomics.
2137         uint64 numberMinted;
2138         // Keeps track of burn count with minimal overhead for tokenomics.
2139         uint64 numberBurned;
2140         // For miscellaneous variable(s) pertaining to the address
2141         // (e.g. number of whitelist mint slots used).
2142         // If there are multiple variables, please pack them into a uint64.
2143         uint64 aux;
2144     }
2145 
2146     // The tokenId of the next token to be minted.
2147     uint256 internal _currentIndex;
2148 
2149     // The number of tokens burned.
2150     uint256 internal _burnCounter;
2151 
2152     // Token name
2153     string private _name;
2154 
2155     // Token symbol
2156     string private _symbol;
2157 
2158     // Mapping from token ID to ownership details
2159     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2160     mapping(uint256 => TokenOwnership) internal _ownerships;
2161 
2162     // Mapping owner address to address data
2163     mapping(address => AddressData) private _addressData;
2164 
2165     // Mapping from token ID to approved address
2166     mapping(uint256 => address) private _tokenApprovals;
2167 
2168     // Mapping from owner to operator approvals
2169     mapping(address => mapping(address => bool)) private _operatorApprovals;
2170 
2171     constructor(string memory name_, string memory symbol_) {
2172         _name = name_;
2173         _symbol = symbol_;
2174         _currentIndex = _startTokenId();
2175     }
2176 
2177     /**
2178      * To change the starting tokenId, please override this function.
2179      */
2180     function _startTokenId() internal view virtual returns (uint256) {
2181         return 0;
2182     }
2183 
2184     /**
2185      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2186      */
2187     function totalSupply() public view returns (uint256) {
2188         // Counter underflow is impossible as _burnCounter cannot be incremented
2189         // more than _currentIndex - _startTokenId() times
2190         unchecked {
2191             return _currentIndex - _burnCounter - _startTokenId();
2192         }
2193     }
2194 
2195     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
2196         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
2197         uint256 numMintedSoFar = totalSupply();
2198         uint256 tokenIdsIdx;
2199         address currOwnershipAddr;
2200 
2201         unchecked {
2202             for (uint256 i; i < numMintedSoFar; i++) {
2203                 TokenOwnership memory ownership = _ownerships[i];
2204                 if (ownership.addr != address(0)) {
2205                     currOwnershipAddr = ownership.addr;
2206                 }
2207                 if (currOwnershipAddr == owner) {
2208                     if (tokenIdsIdx == index) {
2209                         return i;
2210                     }
2211                     tokenIdsIdx++;
2212                 }
2213             }
2214         }
2215 
2216         revert("ERC721A: unable to get token of owner by index");
2217     }
2218 
2219     function tokenByIndex(uint256 index) public view override returns (uint256) {
2220         require(index < totalSupply(), "ERC721A: global index out of bounds");
2221         return index;
2222     }
2223 
2224     /**
2225      * Returns the total amount of tokens minted in the contract.
2226      */
2227     function _totalMinted() internal view returns (uint256) {
2228         // Counter underflow is impossible as _currentIndex does not decrement,
2229         // and it is initialized to _startTokenId()
2230         unchecked {
2231             return _currentIndex - _startTokenId();
2232         }
2233     }
2234 
2235     /**
2236      * @dev See {IERC165-supportsInterface}.
2237      */
2238     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2239         return
2240             interfaceId == type(IERC721).interfaceId ||
2241             interfaceId == type(IERC721Metadata).interfaceId ||
2242             interfaceId == type(IERC721Enumerable).interfaceId ||
2243             super.supportsInterface(interfaceId);
2244     }
2245 
2246 
2247     /**
2248      * @dev See {IERC721-balanceOf}.
2249      */
2250     function balanceOf(address owner) public view override returns (uint256) {
2251         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2252         return uint256(_addressData[owner].balance);
2253     }
2254 
2255     /**
2256      * Returns the number of tokens minted by `owner`.
2257      */
2258     function _numberMinted(address owner) internal view returns (uint256) {
2259         return uint256(_addressData[owner].numberMinted);
2260     }
2261 
2262     /**
2263      * Returns the number of tokens burned by or on behalf of `owner`.
2264      */
2265     function _numberBurned(address owner) internal view returns (uint256) {
2266         return uint256(_addressData[owner].numberBurned);
2267     }
2268 
2269     /**
2270      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2271      */
2272     function _getAux(address owner) internal view returns (uint64) {
2273         return _addressData[owner].aux;
2274     }
2275 
2276     /**
2277      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2278      * If there are multiple variables, please pack them into a uint64.
2279      */
2280     function _setAux(address owner, uint64 aux) internal {
2281         _addressData[owner].aux = aux;
2282     }
2283 
2284     /**
2285      * Gas spent here starts off proportional to the maximum mint batch size.
2286      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2287      */
2288     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2289         uint256 curr = tokenId;
2290 
2291         unchecked {
2292             if (_startTokenId() <= curr && curr < _currentIndex) {
2293                 TokenOwnership memory ownership = _ownerships[curr];
2294                 if (!ownership.burned) {
2295                     if (ownership.addr != address(0)) {
2296                         return ownership;
2297                     }
2298                     // Invariant:
2299                     // There will always be an ownership that has an address and is not burned
2300                     // before an ownership that does not have an address and is not burned.
2301                     // Hence, curr will not underflow.
2302                     while (true) {
2303                         curr--;
2304                         ownership = _ownerships[curr];
2305                         if (ownership.addr != address(0)) {
2306                             return ownership;
2307                         }
2308                     }
2309                 }
2310             }
2311         }
2312         revert OwnerQueryForNonexistentToken();
2313     }
2314 
2315     /**
2316      * @dev See {IERC721-ownerOf}.
2317      */
2318     function ownerOf(uint256 tokenId) public view override returns (address) {
2319         return _ownershipOf(tokenId).addr;
2320     }
2321 
2322     /**
2323      * @dev See {IERC721Metadata-name}.
2324      */
2325     function name() public view virtual override returns (string memory) {
2326         return _name;
2327     }
2328 
2329     /**
2330      * @dev See {IERC721Metadata-symbol}.
2331      */
2332     function symbol() public view virtual override returns (string memory) {
2333         return _symbol;
2334     }
2335 
2336     /**
2337      * @dev See {IERC721Metadata-tokenURI}.
2338      */
2339     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2340         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2341 
2342         string memory baseURI = _baseURI();
2343         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2344     }
2345 
2346     /**
2347      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2348      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2349      * by default, can be overriden in child contracts.
2350      */
2351     function _baseURI() internal view virtual returns (string memory) {
2352         return '';
2353     }
2354 
2355     /**
2356      * @dev See {IERC721-approve}.
2357      */
2358     function approve(address to, uint256 tokenId) public virtual override onlyAllowedOperator(to) {
2359         address owner = ERC721A.ownerOf(tokenId);
2360         require(to != owner, "ERC721A: approval to current owner");
2361 
2362         require(
2363             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2364             "ERC721A: approve caller is not owner nor approved for all"
2365         );
2366 
2367         _approve(to, tokenId, owner);
2368     }
2369 
2370     /**
2371      * @dev See {IERC721-getApproved}.
2372      */
2373     function getApproved(uint256 tokenId) public view override returns (address) {
2374         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2375 
2376         return _tokenApprovals[tokenId];
2377     }
2378 
2379     /**
2380      * @dev See {IERC721-setApprovalForAll}.
2381      */
2382     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperator(operator) {
2383         require(operator != _msgSender(), "ERC721A: approve to caller");
2384 
2385         _operatorApprovals[_msgSender()][operator] = approved;
2386         emit ApprovalForAll(_msgSender(), operator, approved);
2387     }
2388 
2389     /**
2390      * @dev See {IERC721-isApprovedForAll}.
2391      */
2392     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2393         return _operatorApprovals[owner][operator];
2394     }
2395 
2396     /**
2397      * @dev See {IERC721-transferFrom}.
2398      */
2399    function transferFrom(
2400         address from,
2401         address to,
2402         uint256 tokenId
2403     ) public virtual override onlyAllowedOperator(from){
2404         _transfer(from, to, tokenId);
2405     }
2406 
2407     /**
2408      * @dev See {IERC721-safeTransferFrom}.
2409      */
2410     function safeTransferFrom(
2411         address from,
2412         address to,
2413         uint256 tokenId
2414     ) public virtual override onlyAllowedOperator(from) {
2415         safeTransferFrom(from, to, tokenId, "");
2416     }
2417 
2418     /**
2419      * @dev See {IERC721-safeTransferFrom}.
2420      */
2421     function safeTransferFrom(
2422         address from,
2423         address to,
2424         uint256 tokenId,
2425         bytes memory _data
2426     ) public virtual override onlyAllowedOperator(from){
2427         _transfer(from, to, tokenId);
2428         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2429             revert TransferToNonERC721ReceiverImplementer();
2430         }
2431     }
2432 
2433     /**
2434      * @dev Returns whether `tokenId` exists.
2435      *
2436      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2437      *
2438      * Tokens start existing when they are minted (`_mint`),
2439      */
2440     function _exists(uint256 tokenId) internal view returns (bool) {
2441         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
2442     }
2443 
2444     function _safeMint(address to, uint256 quantity) internal {
2445         _safeMint(to, quantity, '');
2446     }
2447 
2448     /**
2449      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2450      *
2451      * Requirements:
2452      *
2453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2454      * - `quantity` must be greater than 0.
2455      *
2456      * Emits a {Transfer} event.
2457      */
2458     function _safeMint(
2459         address to,
2460         uint256 quantity,
2461         bytes memory _data
2462     ) internal {
2463         _mint(to, quantity, _data, true);
2464     }
2465 
2466     /**
2467      * @dev Mints `quantity` tokens and transfers them to `to`.
2468      *
2469      * Requirements:
2470      *
2471      * - `to` cannot be the zero address.
2472      * - `quantity` must be greater than 0.
2473      *
2474      * Emits a {Transfer} event.
2475      */
2476     function _mint(
2477         address to,
2478         uint256 quantity,
2479         bytes memory _data,
2480         bool safe
2481     ) internal {
2482         uint256 startTokenId = _currentIndex;
2483         if (to == address(0)) revert MintToZeroAddress();
2484         if (quantity == 0) revert MintZeroQuantity();
2485 
2486         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2487 
2488         // Overflows are incredibly unrealistic.
2489         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2490         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2491         unchecked {
2492             _addressData[to].balance += uint64(quantity);
2493             _addressData[to].numberMinted += uint64(quantity);
2494 
2495             _ownerships[startTokenId].addr = to;
2496             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2497 
2498             uint256 updatedIndex = startTokenId;
2499             uint256 end = updatedIndex + quantity;
2500 
2501             if (safe && to.isContract()) {
2502                 do {
2503                     emit Transfer(address(0), to, updatedIndex);
2504                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2505                         revert TransferToNonERC721ReceiverImplementer();
2506                     }
2507                 } while (updatedIndex != end);
2508                 // Reentrancy protection
2509                 if (_currentIndex != startTokenId) revert();
2510             } else {
2511                 do {
2512                     emit Transfer(address(0), to, updatedIndex++);
2513                 } while (updatedIndex != end);
2514             }
2515             _currentIndex = updatedIndex;
2516         }
2517         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2518     }
2519 
2520     /**
2521      * @dev Transfers `tokenId` from `from` to `to`.
2522      *
2523      * Requirements:
2524      *
2525      * - `to` cannot be the zero address.
2526      * - `tokenId` token must be owned by `from`.
2527      *
2528      * Emits a {Transfer} event.
2529      */
2530     function _transfer(
2531         address from,
2532         address to,
2533         uint256 tokenId
2534     ) private {
2535         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2536 
2537         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2538 
2539         bool isApprovedOrOwner = (_msgSender() == from ||
2540             isApprovedForAll(from, _msgSender()) ||
2541             getApproved(tokenId) == _msgSender());
2542 
2543         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2544         if (to == address(0)) revert TransferToZeroAddress();
2545 
2546         _beforeTokenTransfers(from, to, tokenId, 1);
2547 
2548         // Clear approvals from the previous owner
2549         _approve(address(0), tokenId, from);
2550 
2551         // Underflow of the sender's balance is impossible because we check for
2552         // ownership above and the recipient's balance can't realistically overflow.
2553         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2554         unchecked {
2555             _addressData[from].balance -= 1;
2556             _addressData[to].balance += 1;
2557 
2558             TokenOwnership storage currSlot = _ownerships[tokenId];
2559             currSlot.addr = to;
2560             currSlot.startTimestamp = uint64(block.timestamp);
2561 
2562             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2563             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2564             uint256 nextTokenId = tokenId + 1;
2565             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2566             if (nextSlot.addr == address(0)) {
2567                 // This will suffice for checking _exists(nextTokenId),
2568                 // as a burned slot cannot contain the zero address.
2569                 if (nextTokenId != _currentIndex) {
2570                     nextSlot.addr = from;
2571                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2572                 }
2573             }
2574         }
2575 
2576         emit Transfer(from, to, tokenId);
2577         _afterTokenTransfers(from, to, tokenId, 1);
2578     }
2579 
2580     /**
2581      * @dev This is equivalent to _burn(tokenId, false)
2582      */
2583     function _burn(uint256 tokenId) internal virtual {
2584         _burn(tokenId, false);
2585     }
2586 
2587     /**
2588      * @dev Destroys `tokenId`.
2589      * The approval is cleared when the token is burned.
2590      *
2591      * Requirements:
2592      *
2593      * - `tokenId` must exist.
2594      *
2595      * Emits a {Transfer} event.
2596      */
2597     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2598         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2599 
2600         address from = prevOwnership.addr;
2601 
2602         if (approvalCheck) {
2603             bool isApprovedOrOwner = (_msgSender() == from ||
2604                 isApprovedForAll(from, _msgSender()) ||
2605                 getApproved(tokenId) == _msgSender());
2606 
2607             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2608         }
2609 
2610         _beforeTokenTransfers(from, address(0), tokenId, 1);
2611 
2612         // Clear approvals from the previous owner
2613         _approve(address(0), tokenId, from);
2614 
2615         // Underflow of the sender's balance is impossible because we check for
2616         // ownership above and the recipient's balance can't realistically overflow.
2617         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2618         unchecked {
2619             AddressData storage addressData = _addressData[from];
2620             addressData.balance -= 1;
2621             addressData.numberBurned += 1;
2622 
2623             // Keep track of who burned the token, and the timestamp of burning.
2624             TokenOwnership storage currSlot = _ownerships[tokenId];
2625             currSlot.addr = from;
2626             currSlot.startTimestamp = uint64(block.timestamp);
2627             currSlot.burned = true;
2628 
2629             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2630             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2631             uint256 nextTokenId = tokenId + 1;
2632             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2633             if (nextSlot.addr == address(0)) {
2634                 // This will suffice for checking _exists(nextTokenId),
2635                 // as a burned slot cannot contain the zero address.
2636                 if (nextTokenId != _currentIndex) {
2637                     nextSlot.addr = from;
2638                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2639                 }
2640             }
2641         }
2642 
2643         emit Transfer(from, address(0), tokenId);
2644         _afterTokenTransfers(from, address(0), tokenId, 1);
2645 
2646         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2647         unchecked {
2648             _burnCounter++;
2649         }
2650     }
2651 
2652     /**
2653      * @dev Approve `to` to operate on `tokenId`
2654      *
2655      * Emits a {Approval} event.
2656      */
2657     function _approve(
2658         address to,
2659         uint256 tokenId,
2660         address owner
2661     ) private {
2662         _tokenApprovals[tokenId] = to;
2663         emit Approval(owner, to, tokenId);
2664     }
2665 
2666     /**
2667      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2668      *
2669      * @param from address representing the previous owner of the given token ID
2670      * @param to target address that will receive the tokens
2671      * @param tokenId uint256 ID of the token to be transferred
2672      * @param _data bytes optional data to send along with the call
2673      * @return bool whether the call correctly returned the expected magic value
2674      */
2675     function _checkContractOnERC721Received(
2676         address from,
2677         address to,
2678         uint256 tokenId,
2679         bytes memory _data
2680     ) private returns (bool) {
2681         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2682             return retval == IERC721Receiver(to).onERC721Received.selector;
2683         } catch (bytes memory reason) {
2684             if (reason.length == 0) {
2685                 revert TransferToNonERC721ReceiverImplementer();
2686             } else {
2687                 assembly {
2688                     revert(add(32, reason), mload(reason))
2689                 }
2690             }
2691         }
2692     }
2693 
2694     /**
2695      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2696      * And also called before burning one token.
2697      *
2698      * startTokenId - the first token id to be transferred
2699      * quantity - the amount to be transferred
2700      *
2701      * Calling conditions:
2702      *
2703      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2704      * transferred to `to`.
2705      * - When `from` is zero, `tokenId` will be minted for `to`.
2706      * - When `to` is zero, `tokenId` will be burned by `from`.
2707      * - `from` and `to` are never both zero.
2708      */
2709     function _beforeTokenTransfers(
2710         address from,
2711         address to,
2712         uint256 startTokenId,
2713         uint256 quantity
2714     ) internal virtual {}
2715 
2716     /**
2717      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2718      * minting.
2719      * And also called after one token has been burned.
2720      *
2721      * startTokenId - the first token id to be transferred
2722      * quantity - the amount to be transferred
2723      *
2724      * Calling conditions:
2725      *
2726      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2727      * transferred to `to`.
2728      * - When `from` is zero, `tokenId` has been minted for `to`.
2729      * - When `to` is zero, `tokenId` has been burned by `from`.
2730      * - `from` and `to` are never both zero.
2731      */
2732     function _afterTokenTransfers(
2733         address from,
2734         address to,
2735         uint256 startTokenId,
2736         uint256 quantity
2737     ) internal virtual {}
2738 }
2739 
2740 
2741 /**
2742  * @dev Contract module which provides a basic access control mechanism, where
2743  * there is an account (an owner) that can be granted exclusive access to
2744  * specific functions.
2745  *
2746  * By default, the owner account will be the one that deploys the contract. This
2747  * can later be changed with {transferOwnership}.
2748  *
2749  * This module is used through inheritance. It will make available the modifier
2750  * `onlyOwner`, which can be applied to your functions to restrict their use to
2751  * the owner.
2752  */
2753 abstract contract Ownable is Context {
2754     address private _owner;
2755 
2756     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2757 
2758     /**
2759      * @dev Initializes the contract setting the deployer as the initial owner.
2760      */
2761     constructor() {
2762         _transferOwnership(_msgSender());
2763     }
2764 
2765     /**
2766      * @dev Throws if called by any account other than the owner.
2767      */
2768     modifier onlyOwner() {
2769         _checkOwner();
2770         _;
2771     }
2772 
2773     /**
2774      * @dev Returns the address of the current owner.
2775      */
2776     function owner() public view virtual returns (address) {
2777         return _owner;
2778     }
2779 
2780     /**
2781      * @dev Throws if the sender is not the owner.
2782      */
2783     function _checkOwner() internal view virtual {
2784         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2785     }
2786 
2787     /**
2788      * @dev Leaves the contract without owner. It will not be possible to call
2789      * `onlyOwner` functions anymore. Can only be called by the current owner.
2790      *
2791      * NOTE: Renouncing ownership will leave the contract without an owner,
2792      * thereby removing any functionality that is only available to the owner.
2793      */
2794     function renounceOwnership() public virtual onlyOwner {
2795         _transferOwnership(address(0));
2796     }
2797 
2798     /**
2799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2800      * Can only be called by the current owner.
2801      */
2802     function transferOwnership(address newOwner) public virtual onlyOwner {
2803         require(newOwner != address(0), "Ownable: new owner is the zero address");
2804         _transferOwnership(newOwner);
2805     }
2806 
2807     /**
2808      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2809      * Internal function without access restriction.
2810      */
2811     function _transferOwnership(address newOwner) internal virtual {
2812         address oldOwner = _owner;
2813         _owner = newOwner;
2814         emit OwnershipTransferred(oldOwner, newOwner);
2815     }
2816 }
2817 
2818 abstract contract Ownable2Step is Ownable {
2819     address private _pendingOwner;
2820 
2821     event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
2822 
2823     /**
2824      * @dev Returns the address of the pending owner.
2825      */
2826     function pendingOwner() public view virtual returns (address) {
2827         return _pendingOwner;
2828     }
2829 
2830     /**
2831      * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
2832      * Can only be called by the current owner.
2833      */
2834     function transferOwnership(address newOwner) public virtual override onlyOwner {
2835         _pendingOwner = newOwner;
2836         emit OwnershipTransferStarted(owner(), newOwner);
2837     }
2838 
2839     /**
2840      * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
2841      * Internal function without access restriction.
2842      */
2843     function _transferOwnership(address newOwner) internal virtual override {
2844         delete _pendingOwner;
2845         super._transferOwnership(newOwner);
2846     }
2847 
2848     /**
2849      * @dev The new owner accepts the ownership transfer.
2850      */
2851     function acceptOwnership() external {
2852         address sender = _msgSender();
2853         require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
2854         _transferOwnership(sender);
2855     }
2856 }
2857 
2858 contract OwnedRegistrant is Ownable2Step {
2859     address constant registry = 0x000000000000AAeB6D7670E522A718067333cd4E;
2860 
2861     constructor(address _owner) {
2862         IOperatorFilterRegistry(registry).register(address(this));
2863         transferOwnership(_owner);
2864     }
2865 }
2866 
2867 
2868 pragma solidity ^0.8.13;
2869 
2870 /**
2871  * @title  UpdatableOperatorFilterer
2872  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2873  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
2874  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
2875  *         which will bypass registry checks.
2876  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
2877  *         on-chain, eg, if the registry is revoked or bypassed.
2878  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2879  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2880  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2881  */
2882 abstract contract UpdatableOperatorFilterer {
2883     error OperatorNotAllowed(address operator);
2884     error OnlyOwner();
2885 
2886     IOperatorFilterRegistry public operatorFilterRegistry;
2887 
2888     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
2889         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
2890         operatorFilterRegistry = registry;
2891         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2892         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2893         // order for the modifier to filter addresses.
2894         if (address(registry).code.length > 0) {
2895             if (subscribe) {
2896                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2897             } else {
2898                 if (subscriptionOrRegistrantToCopy != address(0)) {
2899                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2900                 } else {
2901                     registry.register(address(this));
2902                 }
2903             }
2904         }
2905     }
2906 
2907     modifier onlyAllowedOperator(address from) virtual {
2908         // Allow spending tokens from addresses with balance
2909         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2910         // from an EOA.
2911         if (from != msg.sender) {
2912             _checkFilterOperator(msg.sender);
2913         }
2914         _;
2915     }
2916 
2917     modifier onlyAllowedOperatorApproval(address operator) virtual {
2918         _checkFilterOperator(operator);
2919         _;
2920     }
2921 
2922     /**
2923      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
2924      *         address, checks will be bypassed. OnlyOwner.
2925      */
2926     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
2927         if (msg.sender != owner()) {
2928             revert OnlyOwner();
2929         }
2930         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
2931     }
2932 
2933     /**
2934      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
2935      */
2936     function owner() public view virtual returns (address);
2937 
2938     function _checkFilterOperator(address operator) internal view virtual {
2939         IOperatorFilterRegistry registry = operatorFilterRegistry;
2940         // Check registry code length to facilitate testing in environments without a deployed registry.
2941         if (address(registry) != address(0) && address(registry).code.length > 0) {
2942             if (!registry.isOperatorAllowed(address(this), operator)) {
2943                 revert OperatorNotAllowed(operator);
2944             }
2945         }
2946     }
2947 }
2948 
2949 
2950 pragma solidity ^0.8.13;
2951 
2952 /**
2953  * @title  RevokableOperatorFilterer
2954  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
2955  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
2956  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
2957  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
2958  *         address cannot be further updated.
2959  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
2960  *         on-chain, eg, if the registry is revoked or bypassed.
2961  */
2962 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
2963     error RegistryHasBeenRevoked();
2964     error InitialRegistryAddressCannotBeZeroAddress();
2965 
2966     bool public isOperatorFilterRegistryRevoked;
2967 
2968     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
2969         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
2970     {
2971         // don't allow creating a contract with a permanently revoked registry
2972         if (_registry == address(0)) {
2973             revert InitialRegistryAddressCannotBeZeroAddress();
2974         }
2975     }
2976 
2977     function _checkFilterOperator(address operator) internal view virtual override {
2978         if (address(operatorFilterRegistry) != address(0)) {
2979             super._checkFilterOperator(operator);
2980         }
2981     }
2982 
2983     /**
2984      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
2985      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
2986      */
2987     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
2988         if (msg.sender != owner()) {
2989             revert OnlyOwner();
2990         }
2991         // if registry has been revoked, do not allow further updates
2992         if (isOperatorFilterRegistryRevoked) {
2993             revert RegistryHasBeenRevoked();
2994         }
2995 
2996         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
2997     }
2998 
2999     /**
3000      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
3001      */
3002     function revokeOperatorFilterRegistry() public {
3003         if (msg.sender != owner()) {
3004             revert OnlyOwner();
3005         }
3006         // if registry has been revoked, do not allow further updates
3007         if (isOperatorFilterRegistryRevoked) {
3008             revert RegistryHasBeenRevoked();
3009         }
3010 
3011         // set to zero address to bypass checks
3012         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
3013         isOperatorFilterRegistryRevoked = true;
3014     }
3015 }
3016 
3017 pragma solidity ^0.8.13;
3018 
3019 /**
3020  * @title  RevokableDefaultOperatorFilterer
3021  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
3022  *         Note that OpenSea will disable creator fee enforcement if filtered operators begin fulfilling orders
3023  *         on-chain, eg, if the registry is revoked or bypassed.
3024  */
3025 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
3026     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3027 
3028     constructor() RevokableOperatorFilterer(0x000000000000AAeB6D7670E522A718067333cd4E, DEFAULT_SUBSCRIPTION, true) {}
3029 }
3030 
3031 
3032 pragma solidity ^0.8.9;
3033 
3034 contract BitcoinApePunks is ERC721A, Ownable, ReentrancyGuard {
3035     using Strings for uint256;
3036     
3037     uint   public price             = 0.0069 ether;
3038     uint   public maxTx          = 20;
3039     uint   public maxSupply          = 10000;
3040     uint256 public reservedSupply = 100;
3041     string private baseURI;
3042     bool   public mintEnabled;  
3043     uint   public maxPerFree        = 1;
3044     uint   public totalFreeMinted = 0;
3045     uint   public totalFree         = 10000;
3046     uint256 public bridgeFee;
3047     bool public inscriptionPhaseActive = false;
3048     
3049     mapping(address => uint256) public _FreeMinted;
3050 
3051     constructor() ERC721A("Bitcoin Ape Punks", "BAP") {}
3052 
3053     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3054         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
3055         string memory currentBaseURI = _baseURI();
3056         return bytes(currentBaseURI).length > 0
3057             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
3058             : "";
3059     }
3060 
3061     function _baseURI() internal view virtual override returns (string memory) {
3062         return baseURI;
3063     }
3064 
3065     function mint(uint256 count) external payable {
3066         
3067         bool MintForFree = ((totalFreeMinted < totalFree) &&
3068             (_FreeMinted[msg.sender] < maxPerFree));
3069 
3070         if (MintForFree) { 
3071             require(mintEnabled, "Mint is not live yet");
3072             require(totalSupply() + count <= maxSupply, "No more");
3073             require(count <= maxTx, "Max per TX reached.");
3074             if(count >= (maxPerFree - _FreeMinted[msg.sender]))
3075             {
3076              require(msg.value >= (count * price) - ((maxPerFree - _FreeMinted[msg.sender]) * price), "Please send the exact ETH amount");
3077              _FreeMinted[msg.sender] = maxPerFree;
3078              totalFreeMinted += maxPerFree;
3079             }
3080             else if(count < (maxPerFree - _FreeMinted[msg.sender]))
3081             {
3082              require(msg.value >= 0, "Please send the exact ETH amount");
3083              _FreeMinted[msg.sender] += count;
3084              totalFreeMinted += count;
3085             }
3086         }
3087         else{
3088             require(mintEnabled, "Mint is not live yet");
3089             require(msg.value >= count * price, "Please send the exact ETH amount");
3090             require(totalSupply() + count <= maxSupply, "No more");
3091             require(count <= maxTx, "Max per TX reached.");
3092         }
3093 
3094         _safeMint(msg.sender, count);
3095     }
3096 
3097     function reservedMint(uint256 Amount) external onlyOwner
3098     {
3099         uint256 Remaining = reservedSupply;
3100 
3101         require(totalSupply() + Amount <= maxSupply, "No more supply to be minted");
3102         require(Remaining >= Amount, "Reserved Supply Minted");
3103     
3104         reservedSupply = Remaining - Amount;
3105         _safeMint(msg.sender, Amount);
3106        // totalSupply() += Amount;
3107     }
3108 
3109     function toggleMinting() external onlyOwner {
3110       mintEnabled = !mintEnabled;
3111     }
3112 
3113     function setBridgeFee(uint256 _fee) public onlyOwner {
3114         bridgeFee = _fee;
3115     }
3116     
3117     function toggleInscriptionsActive() public onlyOwner {
3118         inscriptionPhaseActive = !inscriptionPhaseActive;
3119     }
3120     
3121     function bridge(uint256 _tokenId) public payable {
3122         
3123         require(ownerOf(_tokenId) == msg.sender, "You do not own this token.");
3124         require(msg.value >= bridgeFee, "Insufficient fee to inscribe this token to ordinal BTC.");
3125 
3126         _burn(_tokenId);     
3127     }
3128 
3129     function bridgeMultiple(uint256[] calldata tokenIds) public payable {
3130     
3131      require(msg.value >= (tokenIds.length * bridgeFee), "Insufficient fee to inscribe this token to ordinal BTC.");
3132 
3133      for (uint i = 0; i < tokenIds.length; i++) {
3134       require(ownerOf(tokenIds[i]) == msg.sender, "You do not own this token.");
3135         _burn(tokenIds[i]);
3136        }
3137     }
3138 
3139     function burnUnbridgedTokens(uint256[] calldata tokenIds) public onlyOwner {
3140     for (uint i = 0; i < tokenIds.length; i++) {
3141       require(_exists(tokenIds[i]), "Token does not exist");
3142       _burn(tokenIds[i]);
3143       }
3144     }
3145    
3146    function setBaseUri(string memory baseuri_) public onlyOwner {
3147         baseURI = baseuri_;
3148     }
3149 
3150     function setCost(uint256 price_) external onlyOwner {
3151         price = price_;
3152     }
3153 
3154     function costInspect() public view returns (uint256) {
3155         return price;
3156     }
3157 
3158      function setmaxTx(uint256 _MaxTx) external onlyOwner {
3159         maxTx = _MaxTx;
3160     }
3161 
3162     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
3163         totalFree = MaxTotalFree_;
3164     }
3165 
3166     function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
3167         maxPerFree = MaxPerFree_;
3168     }
3169 
3170     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3171         super.setApprovalForAll(operator, approved);
3172     }
3173 
3174     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3175         super.approve(operator, tokenId);
3176     }
3177 
3178     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3179         super.transferFrom(from, to, tokenId);
3180     }
3181 
3182     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3183         super.safeTransferFrom(from, to, tokenId);
3184     }
3185 
3186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3187         public
3188         override
3189         onlyAllowedOperator(from)
3190     {
3191         super.safeTransferFrom(from, to, tokenId, data);
3192     }
3193 
3194     function withdraw() external onlyOwner nonReentrant {
3195         (bool success, ) = msg.sender.call{value: address(this).balance}("");
3196         require(success, "Transfer failed.");
3197     }
3198 }