1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
6 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Library for managing
12  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
13  * types.
14  *
15  * Sets have the following properties:
16  *
17  * - Elements are added, removed, and checked for existence in constant time
18  * (O(1)).
19  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
20  *
21  * ```
22  * contract Example {
23  *     // Add the library methods
24  *     using EnumerableSet for EnumerableSet.AddressSet;
25  *
26  *     // Declare a set state variable
27  *     EnumerableSet.AddressSet private mySet;
28  * }
29  * ```
30  *
31  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
32  * and `uint256` (`UintSet`) are supported.
33  *
34  * [WARNING]
35  * ====
36  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
37  * unusable.
38  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
39  *
40  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
41  * array of EnumerableSet.
42  * ====
43  */
44 library EnumerableSet {
45     // To implement this library for multiple types with as little code
46     // repetition as possible, we write it in terms of a generic Set type with
47     // bytes32 values.
48     // The Set implementation uses private functions, and user-facing
49     // implementations (such as AddressSet) are just wrappers around the
50     // underlying Set.
51     // This means that we can only create new EnumerableSets for types that fit
52     // in bytes32.
53 
54     struct Set {
55         // Storage of set values
56         bytes32[] _values;
57         // Position of the value in the `values` array, plus 1 because index 0
58         // means a value is not in the set.
59         mapping(bytes32 => uint256) _indexes;
60     }
61 
62     /**
63      * @dev Add a value to a set. O(1).
64      *
65      * Returns true if the value was added to the set, that is if it was not
66      * already present.
67      */
68     function _add(Set storage set, bytes32 value) private returns (bool) {
69         if (!_contains(set, value)) {
70             set._values.push(value);
71             // The value is stored at length-1, but we add 1 to all indexes
72             // and use 0 as a sentinel value
73             set._indexes[value] = set._values.length;
74             return true;
75         } else {
76             return false;
77         }
78     }
79 
80     /**
81      * @dev Removes a value from a set. O(1).
82      *
83      * Returns true if the value was removed from the set, that is if it was
84      * present.
85      */
86     function _remove(Set storage set, bytes32 value) private returns (bool) {
87         // We read and store the value's index to prevent multiple reads from the same storage slot
88         uint256 valueIndex = set._indexes[value];
89 
90         if (valueIndex != 0) {
91             // Equivalent to contains(set, value)
92             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
93             // the array, and then remove the last element (sometimes called as 'swap and pop').
94             // This modifies the order of the array, as noted in {at}.
95 
96             uint256 toDeleteIndex = valueIndex - 1;
97             uint256 lastIndex = set._values.length - 1;
98 
99             if (lastIndex != toDeleteIndex) {
100                 bytes32 lastValue = set._values[lastIndex];
101 
102                 // Move the last value to the index where the value to delete is
103                 set._values[toDeleteIndex] = lastValue;
104                 // Update the index for the moved value
105                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
106             }
107 
108             // Delete the slot where the moved value was stored
109             set._values.pop();
110 
111             // Delete the index for the deleted slot
112             delete set._indexes[value];
113 
114             return true;
115         } else {
116             return false;
117         }
118     }
119 
120     /**
121      * @dev Returns true if the value is in the set. O(1).
122      */
123     function _contains(Set storage set, bytes32 value) private view returns (bool) {
124         return set._indexes[value] != 0;
125     }
126 
127     /**
128      * @dev Returns the number of values on the set. O(1).
129      */
130     function _length(Set storage set) private view returns (uint256) {
131         return set._values.length;
132     }
133 
134     /**
135      * @dev Returns the value stored at position `index` in the set. O(1).
136      *
137      * Note that there are no guarantees on the ordering of values inside the
138      * array, and it may change when more values are added or removed.
139      *
140      * Requirements:
141      *
142      * - `index` must be strictly less than {length}.
143      */
144     function _at(Set storage set, uint256 index) private view returns (bytes32) {
145         return set._values[index];
146     }
147 
148     /**
149      * @dev Return the entire set in an array
150      *
151      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
152      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
153      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
154      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
155      */
156     function _values(Set storage set) private view returns (bytes32[] memory) {
157         return set._values;
158     }
159 
160     // Bytes32Set
161 
162     struct Bytes32Set {
163         Set _inner;
164     }
165 
166     /**
167      * @dev Add a value to a set. O(1).
168      *
169      * Returns true if the value was added to the set, that is if it was not
170      * already present.
171      */
172     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
173         return _add(set._inner, value);
174     }
175 
176     /**
177      * @dev Removes a value from a set. O(1).
178      *
179      * Returns true if the value was removed from the set, that is if it was
180      * present.
181      */
182     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
183         return _remove(set._inner, value);
184     }
185 
186     /**
187      * @dev Returns true if the value is in the set. O(1).
188      */
189     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
190         return _contains(set._inner, value);
191     }
192 
193     /**
194      * @dev Returns the number of values in the set. O(1).
195      */
196     function length(Bytes32Set storage set) internal view returns (uint256) {
197         return _length(set._inner);
198     }
199 
200     /**
201      * @dev Returns the value stored at position `index` in the set. O(1).
202      *
203      * Note that there are no guarantees on the ordering of values inside the
204      * array, and it may change when more values are added or removed.
205      *
206      * Requirements:
207      *
208      * - `index` must be strictly less than {length}.
209      */
210     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
211         return _at(set._inner, index);
212     }
213 
214     /**
215      * @dev Return the entire set in an array
216      *
217      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
218      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
219      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
220      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
221      */
222     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
223         bytes32[] memory store = _values(set._inner);
224         bytes32[] memory result;
225 
226         /// @solidity memory-safe-assembly
227         assembly {
228             result := store
229         }
230 
231         return result;
232     }
233 
234     // AddressSet
235 
236     struct AddressSet {
237         Set _inner;
238     }
239 
240     /**
241      * @dev Add a value to a set. O(1).
242      *
243      * Returns true if the value was added to the set, that is if it was not
244      * already present.
245      */
246     function add(AddressSet storage set, address value) internal returns (bool) {
247         return _add(set._inner, bytes32(uint256(uint160(value))));
248     }
249 
250     /**
251      * @dev Removes a value from a set. O(1).
252      *
253      * Returns true if the value was removed from the set, that is if it was
254      * present.
255      */
256     function remove(AddressSet storage set, address value) internal returns (bool) {
257         return _remove(set._inner, bytes32(uint256(uint160(value))));
258     }
259 
260     /**
261      * @dev Returns true if the value is in the set. O(1).
262      */
263     function contains(AddressSet storage set, address value) internal view returns (bool) {
264         return _contains(set._inner, bytes32(uint256(uint160(value))));
265     }
266 
267     /**
268      * @dev Returns the number of values in the set. O(1).
269      */
270     function length(AddressSet storage set) internal view returns (uint256) {
271         return _length(set._inner);
272     }
273 
274     /**
275      * @dev Returns the value stored at position `index` in the set. O(1).
276      *
277      * Note that there are no guarantees on the ordering of values inside the
278      * array, and it may change when more values are added or removed.
279      *
280      * Requirements:
281      *
282      * - `index` must be strictly less than {length}.
283      */
284     function at(AddressSet storage set, uint256 index) internal view returns (address) {
285         return address(uint160(uint256(_at(set._inner, index))));
286     }
287 
288     /**
289      * @dev Return the entire set in an array
290      *
291      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
292      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
293      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
294      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
295      */
296     function values(AddressSet storage set) internal view returns (address[] memory) {
297         bytes32[] memory store = _values(set._inner);
298         address[] memory result;
299 
300         /// @solidity memory-safe-assembly
301         assembly {
302             result := store
303         }
304 
305         return result;
306     }
307 
308     // UintSet
309 
310     struct UintSet {
311         Set _inner;
312     }
313 
314     /**
315      * @dev Add a value to a set. O(1).
316      *
317      * Returns true if the value was added to the set, that is if it was not
318      * already present.
319      */
320     function add(UintSet storage set, uint256 value) internal returns (bool) {
321         return _add(set._inner, bytes32(value));
322     }
323 
324     /**
325      * @dev Removes a value from a set. O(1).
326      *
327      * Returns true if the value was removed from the set, that is if it was
328      * present.
329      */
330     function remove(UintSet storage set, uint256 value) internal returns (bool) {
331         return _remove(set._inner, bytes32(value));
332     }
333 
334     /**
335      * @dev Returns true if the value is in the set. O(1).
336      */
337     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
338         return _contains(set._inner, bytes32(value));
339     }
340 
341     /**
342      * @dev Returns the number of values in the set. O(1).
343      */
344     function length(UintSet storage set) internal view returns (uint256) {
345         return _length(set._inner);
346     }
347 
348     /**
349      * @dev Returns the value stored at position `index` in the set. O(1).
350      *
351      * Note that there are no guarantees on the ordering of values inside the
352      * array, and it may change when more values are added or removed.
353      *
354      * Requirements:
355      *
356      * - `index` must be strictly less than {length}.
357      */
358     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
359         return uint256(_at(set._inner, index));
360     }
361 
362     /**
363      * @dev Return the entire set in an array
364      *
365      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
366      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
367      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
368      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
369      */
370     function values(UintSet storage set) internal view returns (uint256[] memory) {
371         bytes32[] memory store = _values(set._inner);
372         uint256[] memory result;
373 
374         /// @solidity memory-safe-assembly
375         assembly {
376             result := store
377         }
378 
379         return result;
380     }
381 }
382 
383 // File: contracts/IOperatorFilterRegistry.sol
384 
385 
386 pragma solidity ^0.8.13;
387 
388 interface IOperatorFilterRegistry {
389     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
390     function register(address registrant) external;
391     function registerAndSubscribe(address registrant, address subscription) external;
392     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
393     function unregister(address addr) external;
394     function updateOperator(address registrant, address operator, bool filtered) external;
395     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
396     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
397     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
398     function subscribe(address registrant, address registrantToSubscribe) external;
399     function unsubscribe(address registrant, bool copyExistingEntries) external;
400     function subscriptionOf(address addr) external returns (address registrant);
401     function subscribers(address registrant) external returns (address[] memory);
402     function subscriberAt(address registrant, uint256 index) external returns (address);
403     function copyEntriesOf(address registrant, address registrantToCopy) external;
404     function isOperatorFiltered(address registrant, address operator) external returns (bool);
405     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
406     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
407     function filteredOperators(address addr) external returns (address[] memory);
408     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
409     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
410     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
411     function isRegistered(address addr) external returns (bool);
412     function codeHashOf(address addr) external returns (bytes32);
413 }
414 // File: contracts/OperatorFilterer.sol
415 
416 
417 // OpenZeppelin Contracts (last updated v4.8.0) (access/Ownable2Step.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 /**
422  * @dev Contract module which provides access control mechanism, where
423  * there is an account (an owner) that can be granted exclusive access to
424  * specific functions.
425  *
426  * By default, the owner account will be the one that deploys the contract. This
427  * can later be changed with {transferOwnership} and {acceptOwnership}.
428  *
429  * This module is used through inheritance. It will make available all functions
430  * from parent (Ownable).
431  */
432 
433 
434 
435 pragma solidity ^0.8.13;
436 
437 /**
438  * @title  OwnedRegistrant
439  * @notice Ownable contract that registers itself with the OperatorFilterRegistry and administers its own entries,
440  *         to facilitate a subscription whose ownership can be transferred.
441  */
442 
443 pragma solidity ^0.8.13;
444 
445 contract OperatorFilterRegistryErrorsAndEvents {
446     error CannotFilterEOAs();
447     error AddressAlreadyFiltered(address operator);
448     error AddressNotFiltered(address operator);
449     error CodeHashAlreadyFiltered(bytes32 codeHash);
450     error CodeHashNotFiltered(bytes32 codeHash);
451     error OnlyAddressOrOwner();
452     error NotRegistered(address registrant);
453     error AlreadyRegistered();
454     error AlreadySubscribed(address subscription);
455     error NotSubscribed();
456     error CannotUpdateWhileSubscribed(address subscription);
457     error CannotSubscribeToSelf();
458     error CannotSubscribeToZeroAddress();
459     error NotOwnable();
460     error AddressFiltered(address filtered);
461     error CodeHashFiltered(address account, bytes32 codeHash);
462     error CannotSubscribeToRegistrantWithSubscription(address registrant);
463     error CannotCopyFromSelf();
464 
465     event RegistrationUpdated(address indexed registrant, bool indexed registered);
466     event OperatorUpdated(address indexed registrant, address indexed operator, bool indexed filtered);
467     event OperatorsUpdated(address indexed registrant, address[] operators, bool indexed filtered);
468     event CodeHashUpdated(address indexed registrant, bytes32 indexed codeHash, bool indexed filtered);
469     event CodeHashesUpdated(address indexed registrant, bytes32[] codeHashes, bool indexed filtered);
470     event SubscriptionUpdated(address indexed registrant, address indexed subscription, bool indexed subscribed);
471 }
472 
473 pragma solidity ^0.8.13;
474 
475 /**
476  * @title  OperatorFilterRegistry
477  * @notice Borrows heavily from the QQL BlacklistOperatorFilter contract:
478  *         https://github.com/qql-art/contracts/blob/main/contracts/BlacklistOperatorFilter.sol
479  * @notice This contracts allows tokens or token owners to register specific addresses or codeHashes that may be
480  * *       restricted according to the isOperatorAllowed function.
481  */
482 contract OperatorFilterRegistry is IOperatorFilterRegistry, OperatorFilterRegistryErrorsAndEvents {
483     using EnumerableSet for EnumerableSet.AddressSet;
484     using EnumerableSet for EnumerableSet.Bytes32Set;
485 
486     /// @dev initialized accounts have a nonzero codehash (see https://eips.ethereum.org/EIPS/eip-1052)
487     /// Note that this will also be a smart contract's codehash when making calls from its constructor.
488     bytes32 constant EOA_CODEHASH = keccak256("");
489 
490     mapping(address => EnumerableSet.AddressSet) private _filteredOperators;
491     mapping(address => EnumerableSet.Bytes32Set) private _filteredCodeHashes;
492     mapping(address => address) private _registrations;
493     mapping(address => EnumerableSet.AddressSet) private _subscribers;
494 
495     /**
496      * @notice restricts method caller to the address or EIP-173 "owner()"
497      */
498     modifier onlyAddressOrOwner(address addr) {
499         if (msg.sender != addr) {
500             try Ownable(addr).owner() returns (address owner) {
501                 if (msg.sender != owner) {
502                     revert OnlyAddressOrOwner();
503                 }
504             } catch (bytes memory reason) {
505                 if (reason.length == 0) {
506                     revert NotOwnable();
507                 } else {
508                     /// @solidity memory-safe-assembly
509                     assembly {
510                         revert(add(32, reason), mload(reason))
511                     }
512                 }
513             }
514         }
515         _;
516     }
517 
518     /**
519      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
520      *         true if supplied registrant address is not registered.
521      */
522     function isOperatorAllowed(address registrant, address operator) external view returns (bool) {
523         address registration = _registrations[registrant];
524         if (registration != address(0)) {
525             EnumerableSet.AddressSet storage filteredOperatorsRef;
526             EnumerableSet.Bytes32Set storage filteredCodeHashesRef;
527 
528             filteredOperatorsRef = _filteredOperators[registration];
529             filteredCodeHashesRef = _filteredCodeHashes[registration];
530 
531             if (filteredOperatorsRef.contains(operator)) {
532                 revert AddressFiltered(operator);
533             }
534             if (operator.code.length > 0) {
535                 bytes32 codeHash = operator.codehash;
536                 if (filteredCodeHashesRef.contains(codeHash)) {
537                     revert CodeHashFiltered(operator, codeHash);
538                 }
539             }
540         }
541         return true;
542     }
543 
544     //////////////////
545     // AUTH METHODS //
546     //////////////////
547 
548     /**
549      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
550      */
551     function register(address registrant) external onlyAddressOrOwner(registrant) {
552         if (_registrations[registrant] != address(0)) {
553             revert AlreadyRegistered();
554         }
555         _registrations[registrant] = registrant;
556         emit RegistrationUpdated(registrant, true);
557     }
558 
559     /**
560      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
561      *         Note that this does not remove any filtered addresses or codeHashes.
562      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
563      */
564     function unregister(address registrant) external onlyAddressOrOwner(registrant) {
565         address registration = _registrations[registrant];
566         if (registration == address(0)) {
567             revert NotRegistered(registrant);
568         }
569         if (registration != registrant) {
570             _subscribers[registration].remove(registrant);
571             emit SubscriptionUpdated(registrant, registration, false);
572         }
573         _registrations[registrant] = address(0);
574         emit RegistrationUpdated(registrant, false);
575     }
576 
577     /**
578      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
579      */
580     function registerAndSubscribe(address registrant, address subscription) external onlyAddressOrOwner(registrant) {
581         address registration = _registrations[registrant];
582         if (registration != address(0)) {
583             revert AlreadyRegistered();
584         }
585         if (registrant == subscription) {
586             revert CannotSubscribeToSelf();
587         }
588         address subscriptionRegistration = _registrations[subscription];
589         if (subscriptionRegistration == address(0)) {
590             revert NotRegistered(subscription);
591         }
592         if (subscriptionRegistration != subscription) {
593             revert CannotSubscribeToRegistrantWithSubscription(subscription);
594         }
595 
596         _registrations[registrant] = subscription;
597         _subscribers[subscription].add(registrant);
598         emit RegistrationUpdated(registrant, true);
599         emit SubscriptionUpdated(registrant, subscription, true);
600     }
601 
602     /**
603      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
604      *         address without subscribing.
605      */
606     function registerAndCopyEntries(address registrant, address registrantToCopy)
607         external
608         onlyAddressOrOwner(registrant)
609     {
610         if (registrantToCopy == registrant) {
611             revert CannotCopyFromSelf();
612         }
613         address registration = _registrations[registrant];
614         if (registration != address(0)) {
615             revert AlreadyRegistered();
616         }
617         address registrantRegistration = _registrations[registrantToCopy];
618         if (registrantRegistration == address(0)) {
619             revert NotRegistered(registrantToCopy);
620         }
621         _registrations[registrant] = registrant;
622         emit RegistrationUpdated(registrant, true);
623         _copyEntries(registrant, registrantToCopy);
624     }
625 
626     /**
627      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
628      */
629     function updateOperator(address registrant, address operator, bool filtered)
630         external
631         onlyAddressOrOwner(registrant)
632     {
633         address registration = _registrations[registrant];
634         if (registration == address(0)) {
635             revert NotRegistered(registrant);
636         }
637         if (registration != registrant) {
638             revert CannotUpdateWhileSubscribed(registration);
639         }
640         EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrant];
641 
642         if (!filtered) {
643             bool removed = filteredOperatorsRef.remove(operator);
644             if (!removed) {
645                 revert AddressNotFiltered(operator);
646             }
647         } else {
648             bool added = filteredOperatorsRef.add(operator);
649             if (!added) {
650                 revert AddressAlreadyFiltered(operator);
651             }
652         }
653         emit OperatorUpdated(registrant, operator, filtered);
654     }
655 
656     /**
657      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
658      */
659     function updateCodeHash(address registrant, bytes32 codeHash, bool filtered)
660         external
661         onlyAddressOrOwner(registrant)
662     {
663         if (codeHash == EOA_CODEHASH) {
664             revert CannotFilterEOAs();
665         }
666         address registration = _registrations[registrant];
667         if (registration == address(0)) {
668             revert NotRegistered(registrant);
669         }
670         if (registration != registrant) {
671             revert CannotUpdateWhileSubscribed(registration);
672         }
673         EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrant];
674 
675         if (!filtered) {
676             bool removed = filteredCodeHashesRef.remove(codeHash);
677             if (!removed) {
678                 revert CodeHashNotFiltered(codeHash);
679             }
680         } else {
681             bool added = filteredCodeHashesRef.add(codeHash);
682             if (!added) {
683                 revert CodeHashAlreadyFiltered(codeHash);
684             }
685         }
686         emit CodeHashUpdated(registrant, codeHash, filtered);
687     }
688 
689     /**
690      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
691      */
692     function updateOperators(address registrant, address[] calldata operators, bool filtered)
693         external
694         onlyAddressOrOwner(registrant)
695     {
696         address registration = _registrations[registrant];
697         if (registration == address(0)) {
698             revert NotRegistered(registrant);
699         }
700         if (registration != registrant) {
701             revert CannotUpdateWhileSubscribed(registration);
702         }
703         EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrant];
704         uint256 operatorsLength = operators.length;
705         unchecked {
706             if (!filtered) {
707                 for (uint256 i = 0; i < operatorsLength; ++i) {
708                     address operator = operators[i];
709                     bool removed = filteredOperatorsRef.remove(operator);
710                     if (!removed) {
711                         revert AddressNotFiltered(operator);
712                     }
713                 }
714             } else {
715                 for (uint256 i = 0; i < operatorsLength; ++i) {
716                     address operator = operators[i];
717                     bool added = filteredOperatorsRef.add(operator);
718                     if (!added) {
719                         revert AddressAlreadyFiltered(operator);
720                     }
721                 }
722             }
723         }
724         emit OperatorsUpdated(registrant, operators, filtered);
725     }
726 
727     /**
728      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
729      */
730     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered)
731         external
732         onlyAddressOrOwner(registrant)
733     {
734         address registration = _registrations[registrant];
735         if (registration == address(0)) {
736             revert NotRegistered(registrant);
737         }
738         if (registration != registrant) {
739             revert CannotUpdateWhileSubscribed(registration);
740         }
741         EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrant];
742         uint256 codeHashesLength = codeHashes.length;
743         unchecked {
744             if (!filtered) {
745                 for (uint256 i = 0; i < codeHashesLength; ++i) {
746                     bytes32 codeHash = codeHashes[i];
747                     bool removed = filteredCodeHashesRef.remove(codeHash);
748                     if (!removed) {
749                         revert CodeHashNotFiltered(codeHash);
750                     }
751                 }
752             } else {
753                 for (uint256 i = 0; i < codeHashesLength; ++i) {
754                     bytes32 codeHash = codeHashes[i];
755                     if (codeHash == EOA_CODEHASH) {
756                         revert CannotFilterEOAs();
757                     }
758                     bool added = filteredCodeHashesRef.add(codeHash);
759                     if (!added) {
760                         revert CodeHashAlreadyFiltered(codeHash);
761                     }
762                 }
763             }
764         }
765         emit CodeHashesUpdated(registrant, codeHashes, filtered);
766     }
767 
768     /**
769      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
770      *         subscription if present.
771      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
772      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
773      *         used.
774      */
775     function subscribe(address registrant, address newSubscription) external onlyAddressOrOwner(registrant) {
776         if (registrant == newSubscription) {
777             revert CannotSubscribeToSelf();
778         }
779         if (newSubscription == address(0)) {
780             revert CannotSubscribeToZeroAddress();
781         }
782         address registration = _registrations[registrant];
783         if (registration == address(0)) {
784             revert NotRegistered(registrant);
785         }
786         if (registration == newSubscription) {
787             revert AlreadySubscribed(newSubscription);
788         }
789         address newSubscriptionRegistration = _registrations[newSubscription];
790         if (newSubscriptionRegistration == address(0)) {
791             revert NotRegistered(newSubscription);
792         }
793         if (newSubscriptionRegistration != newSubscription) {
794             revert CannotSubscribeToRegistrantWithSubscription(newSubscription);
795         }
796 
797         if (registration != registrant) {
798             _subscribers[registration].remove(registrant);
799             emit SubscriptionUpdated(registrant, registration, false);
800         }
801         _registrations[registrant] = newSubscription;
802         _subscribers[newSubscription].add(registrant);
803         emit SubscriptionUpdated(registrant, newSubscription, true);
804     }
805 
806     /**
807      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
808      */
809     function unsubscribe(address registrant, bool copyExistingEntries) external onlyAddressOrOwner(registrant) {
810         address registration = _registrations[registrant];
811         if (registration == address(0)) {
812             revert NotRegistered(registrant);
813         }
814         if (registration == registrant) {
815             revert NotSubscribed();
816         }
817         _subscribers[registration].remove(registrant);
818         _registrations[registrant] = registrant;
819         emit SubscriptionUpdated(registrant, registration, false);
820         if (copyExistingEntries) {
821             _copyEntries(registrant, registration);
822         }
823     }
824 
825     /**
826      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
827      */
828     function copyEntriesOf(address registrant, address registrantToCopy) external onlyAddressOrOwner(registrant) {
829         if (registrant == registrantToCopy) {
830             revert CannotCopyFromSelf();
831         }
832         address registration = _registrations[registrant];
833         if (registration == address(0)) {
834             revert NotRegistered(registrant);
835         }
836         if (registration != registrant) {
837             revert CannotUpdateWhileSubscribed(registration);
838         }
839         address registrantRegistration = _registrations[registrantToCopy];
840         if (registrantRegistration == address(0)) {
841             revert NotRegistered(registrantToCopy);
842         }
843         _copyEntries(registrant, registrantToCopy);
844     }
845 
846     /// @dev helper to copy entries from registrantToCopy to registrant and emit events
847     function _copyEntries(address registrant, address registrantToCopy) private {
848         EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrantToCopy];
849         EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrantToCopy];
850         uint256 filteredOperatorsLength = filteredOperatorsRef.length();
851         uint256 filteredCodeHashesLength = filteredCodeHashesRef.length();
852         unchecked {
853             for (uint256 i = 0; i < filteredOperatorsLength; ++i) {
854                 address operator = filteredOperatorsRef.at(i);
855                 bool added = _filteredOperators[registrant].add(operator);
856                 if (added) {
857                     emit OperatorUpdated(registrant, operator, true);
858                 }
859             }
860             for (uint256 i = 0; i < filteredCodeHashesLength; ++i) {
861                 bytes32 codehash = filteredCodeHashesRef.at(i);
862                 bool added = _filteredCodeHashes[registrant].add(codehash);
863                 if (added) {
864                     emit CodeHashUpdated(registrant, codehash, true);
865                 }
866             }
867         }
868     }
869 
870     //////////////////
871     // VIEW METHODS //
872     //////////////////
873 
874     /**
875      * @notice Get the subscription address of a given registrant, if any.
876      */
877     function subscriptionOf(address registrant) external view returns (address subscription) {
878         subscription = _registrations[registrant];
879         if (subscription == address(0)) {
880             revert NotRegistered(registrant);
881         } else if (subscription == registrant) {
882             subscription = address(0);
883         }
884     }
885 
886     /**
887      * @notice Get the set of addresses subscribed to a given registrant.
888      *         Note that order is not guaranteed as updates are made.
889      */
890     function subscribers(address registrant) external view returns (address[] memory) {
891         return _subscribers[registrant].values();
892     }
893 
894     /**
895      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
896      *         Note that order is not guaranteed as updates are made.
897      */
898     function subscriberAt(address registrant, uint256 index) external view returns (address) {
899         return _subscribers[registrant].at(index);
900     }
901 
902     /**
903      * @notice Returns true if operator is filtered by a given address or its subscription.
904      */
905     function isOperatorFiltered(address registrant, address operator) external view returns (bool) {
906         address registration = _registrations[registrant];
907         if (registration != registrant) {
908             return _filteredOperators[registration].contains(operator);
909         }
910         return _filteredOperators[registrant].contains(operator);
911     }
912 
913     /**
914      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
915      */
916     function isCodeHashFiltered(address registrant, bytes32 codeHash) external view returns (bool) {
917         address registration = _registrations[registrant];
918         if (registration != registrant) {
919             return _filteredCodeHashes[registration].contains(codeHash);
920         }
921         return _filteredCodeHashes[registrant].contains(codeHash);
922     }
923 
924     /**
925      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
926      */
927     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external view returns (bool) {
928         bytes32 codeHash = operatorWithCode.codehash;
929         address registration = _registrations[registrant];
930         if (registration != registrant) {
931             return _filteredCodeHashes[registration].contains(codeHash);
932         }
933         return _filteredCodeHashes[registrant].contains(codeHash);
934     }
935 
936     /**
937      * @notice Returns true if an address has registered
938      */
939     function isRegistered(address registrant) external view returns (bool) {
940         return _registrations[registrant] != address(0);
941     }
942 
943     /**
944      * @notice Returns a list of filtered operators for a given address or its subscription.
945      */
946     function filteredOperators(address registrant) external view returns (address[] memory) {
947         address registration = _registrations[registrant];
948         if (registration != registrant) {
949             return _filteredOperators[registration].values();
950         }
951         return _filteredOperators[registrant].values();
952     }
953 
954     /**
955      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
956      *         Note that order is not guaranteed as updates are made.
957      */
958     function filteredCodeHashes(address registrant) external view returns (bytes32[] memory) {
959         address registration = _registrations[registrant];
960         if (registration != registrant) {
961             return _filteredCodeHashes[registration].values();
962         }
963         return _filteredCodeHashes[registrant].values();
964     }
965 
966     /**
967      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
968      *         its subscription.
969      *         Note that order is not guaranteed as updates are made.
970      */
971     function filteredOperatorAt(address registrant, uint256 index) external view returns (address) {
972         address registration = _registrations[registrant];
973         if (registration != registrant) {
974             return _filteredOperators[registration].at(index);
975         }
976         return _filteredOperators[registrant].at(index);
977     }
978 
979     /**
980      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
981      *         its subscription.
982      *         Note that order is not guaranteed as updates are made.
983      */
984     function filteredCodeHashAt(address registrant, uint256 index) external view returns (bytes32) {
985         address registration = _registrations[registrant];
986         if (registration != registrant) {
987             return _filteredCodeHashes[registration].at(index);
988         }
989         return _filteredCodeHashes[registrant].at(index);
990     }
991 
992     /// @dev Convenience method to compute the code hash of an arbitrary contract
993     function codeHashOf(address a) external view returns (bytes32) {
994         return a.codehash;
995     }
996 }
997 
998 
999 pragma solidity ^0.8.13;
1000 
1001 
1002 abstract contract OperatorFilterer {
1003     error OperatorNotAllowed(address operator);
1004 
1005     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1006         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1007 
1008     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1009         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1010         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1011         // order for the modifier to filter addresses.
1012         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1013             if (subscribe) {
1014                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1015             } else {
1016                 if (subscriptionOrRegistrantToCopy != address(0)) {
1017                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1018                 } else {
1019                     OPERATOR_FILTER_REGISTRY.register(address(this));
1020                 }
1021             }
1022         }
1023     }
1024 
1025     modifier onlyAllowedOperator(address from) virtual {
1026         // Allow spending tokens from addresses with balance
1027         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1028         // from an EOA.
1029         if (from != msg.sender) {
1030             _checkFilterOperator(msg.sender);
1031         }
1032         _;
1033     }
1034 
1035     modifier onlyAllowedOperatorApproval(address operator) virtual {
1036         _checkFilterOperator(operator);
1037         _;
1038     }
1039 
1040     function _checkFilterOperator(address operator) internal view virtual {
1041         // Check registry code length to facilitate testing in environments without a deployed registry.
1042         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1043             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1044                 revert OperatorNotAllowed(operator);
1045             }
1046         }
1047     }
1048 }
1049 
1050 
1051 // File: contracts/DefaultOperatorFilterer.sol
1052 
1053 
1054 pragma solidity ^0.8.13;
1055 
1056 
1057 /**
1058  * @title  DefaultOperatorFilterer
1059  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1060  */
1061 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1062     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1063 
1064     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1065 }
1066 // File: @openzeppelin/contracts/utils/math/Math.sol
1067 
1068 
1069 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 /**
1074  * @dev Standard math utilities missing in the Solidity language.
1075  */
1076 library Math {
1077     enum Rounding {
1078         Down, // Toward negative infinity
1079         Up, // Toward infinity
1080         Zero // Toward zero
1081     }
1082 
1083     /**
1084      * @dev Returns the largest of two numbers.
1085      */
1086     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1087         return a > b ? a : b;
1088     }
1089 
1090     /**
1091      * @dev Returns the smallest of two numbers.
1092      */
1093     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1094         return a < b ? a : b;
1095     }
1096 
1097     /**
1098      * @dev Returns the average of two numbers. The result is rounded towards
1099      * zero.
1100      */
1101     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1102         // (a + b) / 2 can overflow.
1103         return (a & b) + (a ^ b) / 2;
1104     }
1105 
1106     /**
1107      * @dev Returns the ceiling of the division of two numbers.
1108      *
1109      * This differs from standard division with `/` in that it rounds up instead
1110      * of rounding down.
1111      */
1112     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1113         // (a + b - 1) / b can overflow on addition, so we distribute.
1114         return a == 0 ? 0 : (a - 1) / b + 1;
1115     }
1116 
1117     /**
1118      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1119      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1120      * with further edits by Uniswap Labs also under MIT license.
1121      */
1122     function mulDiv(
1123         uint256 x,
1124         uint256 y,
1125         uint256 denominator
1126     ) internal pure returns (uint256 result) {
1127         unchecked {
1128             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1129             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1130             // variables such that product = prod1 * 2^256 + prod0.
1131             uint256 prod0; // Least significant 256 bits of the product
1132             uint256 prod1; // Most significant 256 bits of the product
1133             assembly {
1134                 let mm := mulmod(x, y, not(0))
1135                 prod0 := mul(x, y)
1136                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1137             }
1138 
1139             // Handle non-overflow cases, 256 by 256 division.
1140             if (prod1 == 0) {
1141                 return prod0 / denominator;
1142             }
1143 
1144             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1145             require(denominator > prod1);
1146 
1147             ///////////////////////////////////////////////
1148             // 512 by 256 division.
1149             ///////////////////////////////////////////////
1150 
1151             // Make division exact by subtracting the remainder from [prod1 prod0].
1152             uint256 remainder;
1153             assembly {
1154                 // Compute remainder using mulmod.
1155                 remainder := mulmod(x, y, denominator)
1156 
1157                 // Subtract 256 bit number from 512 bit number.
1158                 prod1 := sub(prod1, gt(remainder, prod0))
1159                 prod0 := sub(prod0, remainder)
1160             }
1161 
1162             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1163             // See https://cs.stackexchange.com/q/138556/92363.
1164 
1165             // Does not overflow because the denominator cannot be zero at this stage in the function.
1166             uint256 twos = denominator & (~denominator + 1);
1167             assembly {
1168                 // Divide denominator by twos.
1169                 denominator := div(denominator, twos)
1170 
1171                 // Divide [prod1 prod0] by twos.
1172                 prod0 := div(prod0, twos)
1173 
1174                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1175                 twos := add(div(sub(0, twos), twos), 1)
1176             }
1177 
1178             // Shift in bits from prod1 into prod0.
1179             prod0 |= prod1 * twos;
1180 
1181             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1182             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1183             // four bits. That is, denominator * inv = 1 mod 2^4.
1184             uint256 inverse = (3 * denominator) ^ 2;
1185 
1186             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1187             // in modular arithmetic, doubling the correct bits in each step.
1188             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1189             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1190             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1191             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1192             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1193             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1194 
1195             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1196             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1197             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1198             // is no longer required.
1199             result = prod0 * inverse;
1200             return result;
1201         }
1202     }
1203 
1204     /**
1205      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1206      */
1207     function mulDiv(
1208         uint256 x,
1209         uint256 y,
1210         uint256 denominator,
1211         Rounding rounding
1212     ) internal pure returns (uint256) {
1213         uint256 result = mulDiv(x, y, denominator);
1214         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1215             result += 1;
1216         }
1217         return result;
1218     }
1219 
1220     /**
1221      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1222      *
1223      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1224      */
1225     function sqrt(uint256 a) internal pure returns (uint256) {
1226         if (a == 0) {
1227             return 0;
1228         }
1229 
1230         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1231         //
1232         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1233         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1234         //
1235         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1236         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1237         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1238         //
1239         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1240         uint256 result = 1 << (log2(a) >> 1);
1241 
1242         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1243         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1244         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1245         // into the expected uint128 result.
1246         unchecked {
1247             result = (result + a / result) >> 1;
1248             result = (result + a / result) >> 1;
1249             result = (result + a / result) >> 1;
1250             result = (result + a / result) >> 1;
1251             result = (result + a / result) >> 1;
1252             result = (result + a / result) >> 1;
1253             result = (result + a / result) >> 1;
1254             return min(result, a / result);
1255         }
1256     }
1257 
1258     /**
1259      * @notice Calculates sqrt(a), following the selected rounding direction.
1260      */
1261     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1262         unchecked {
1263             uint256 result = sqrt(a);
1264             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1265         }
1266     }
1267 
1268     /**
1269      * @dev Return the log in base 2, rounded down, of a positive value.
1270      * Returns 0 if given 0.
1271      */
1272     function log2(uint256 value) internal pure returns (uint256) {
1273         uint256 result = 0;
1274         unchecked {
1275             if (value >> 128 > 0) {
1276                 value >>= 128;
1277                 result += 128;
1278             }
1279             if (value >> 64 > 0) {
1280                 value >>= 64;
1281                 result += 64;
1282             }
1283             if (value >> 32 > 0) {
1284                 value >>= 32;
1285                 result += 32;
1286             }
1287             if (value >> 16 > 0) {
1288                 value >>= 16;
1289                 result += 16;
1290             }
1291             if (value >> 8 > 0) {
1292                 value >>= 8;
1293                 result += 8;
1294             }
1295             if (value >> 4 > 0) {
1296                 value >>= 4;
1297                 result += 4;
1298             }
1299             if (value >> 2 > 0) {
1300                 value >>= 2;
1301                 result += 2;
1302             }
1303             if (value >> 1 > 0) {
1304                 result += 1;
1305             }
1306         }
1307         return result;
1308     }
1309 
1310     /**
1311      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1312      * Returns 0 if given 0.
1313      */
1314     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1315         unchecked {
1316             uint256 result = log2(value);
1317             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1318         }
1319     }
1320 
1321     /**
1322      * @dev Return the log in base 10, rounded down, of a positive value.
1323      * Returns 0 if given 0.
1324      */
1325     function log10(uint256 value) internal pure returns (uint256) {
1326         uint256 result = 0;
1327         unchecked {
1328             if (value >= 10**64) {
1329                 value /= 10**64;
1330                 result += 64;
1331             }
1332             if (value >= 10**32) {
1333                 value /= 10**32;
1334                 result += 32;
1335             }
1336             if (value >= 10**16) {
1337                 value /= 10**16;
1338                 result += 16;
1339             }
1340             if (value >= 10**8) {
1341                 value /= 10**8;
1342                 result += 8;
1343             }
1344             if (value >= 10**4) {
1345                 value /= 10**4;
1346                 result += 4;
1347             }
1348             if (value >= 10**2) {
1349                 value /= 10**2;
1350                 result += 2;
1351             }
1352             if (value >= 10**1) {
1353                 result += 1;
1354             }
1355         }
1356         return result;
1357     }
1358 
1359     /**
1360      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1361      * Returns 0 if given 0.
1362      */
1363     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1364         unchecked {
1365             uint256 result = log10(value);
1366             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1367         }
1368     }
1369 
1370     /**
1371      * @dev Return the log in base 256, rounded down, of a positive value.
1372      * Returns 0 if given 0.
1373      *
1374      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1375      */
1376     function log256(uint256 value) internal pure returns (uint256) {
1377         uint256 result = 0;
1378         unchecked {
1379             if (value >> 128 > 0) {
1380                 value >>= 128;
1381                 result += 16;
1382             }
1383             if (value >> 64 > 0) {
1384                 value >>= 64;
1385                 result += 8;
1386             }
1387             if (value >> 32 > 0) {
1388                 value >>= 32;
1389                 result += 4;
1390             }
1391             if (value >> 16 > 0) {
1392                 value >>= 16;
1393                 result += 2;
1394             }
1395             if (value >> 8 > 0) {
1396                 result += 1;
1397             }
1398         }
1399         return result;
1400     }
1401 
1402     /**
1403      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1404      * Returns 0 if given 0.
1405      */
1406     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1407         unchecked {
1408             uint256 result = log256(value);
1409             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1410         }
1411     }
1412 }
1413 
1414 // File: @openzeppelin/contracts/utils/Strings.sol
1415 
1416 
1417 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1418 
1419 pragma solidity ^0.8.0;
1420 
1421 
1422 /**
1423  * @dev String operations.
1424  */
1425 library Strings {
1426     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1427     uint8 private constant _ADDRESS_LENGTH = 20;
1428 
1429     /**
1430      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1431      */
1432     function toString(uint256 value) internal pure returns (string memory) {
1433         unchecked {
1434             uint256 length = Math.log10(value) + 1;
1435             string memory buffer = new string(length);
1436             uint256 ptr;
1437             /// @solidity memory-safe-assembly
1438             assembly {
1439                 ptr := add(buffer, add(32, length))
1440             }
1441             while (true) {
1442                 ptr--;
1443                 /// @solidity memory-safe-assembly
1444                 assembly {
1445                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1446                 }
1447                 value /= 10;
1448                 if (value == 0) break;
1449             }
1450             return buffer;
1451         }
1452     }
1453 
1454     /**
1455      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1456      */
1457     function toHexString(uint256 value) internal pure returns (string memory) {
1458         unchecked {
1459             return toHexString(value, Math.log256(value) + 1);
1460         }
1461     }
1462 
1463     /**
1464      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1465      */
1466     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1467         bytes memory buffer = new bytes(2 * length + 2);
1468         buffer[0] = "0";
1469         buffer[1] = "x";
1470         for (uint256 i = 2 * length + 1; i > 1; --i) {
1471             buffer[i] = _SYMBOLS[value & 0xf];
1472             value >>= 4;
1473         }
1474         require(value == 0, "Strings: hex length insufficient");
1475         return string(buffer);
1476     }
1477 
1478     /**
1479      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1480      */
1481     function toHexString(address addr) internal pure returns (string memory) {
1482         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1483     }
1484 }
1485 
1486 // File: @openzeppelin/contracts/utils/Address.sol
1487 
1488 
1489 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1490 
1491 pragma solidity ^0.8.1;
1492 
1493 /**
1494  * @dev Collection of functions related to the address type
1495  */
1496 library Address {
1497     /**
1498      * @dev Returns true if `account` is a contract.
1499      *
1500      * [IMPORTANT]
1501      * ====
1502      * It is unsafe to assume that an address for which this function returns
1503      * false is an externally-owned account (EOA) and not a contract.
1504      *
1505      * Among others, `isContract` will return false for the following
1506      * types of addresses:
1507      *
1508      *  - an externally-owned account
1509      *  - a contract in construction
1510      *  - an address where a contract will be created
1511      *  - an address where a contract lived, but was destroyed
1512      * ====
1513      *
1514      * [IMPORTANT]
1515      * ====
1516      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1517      *
1518      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1519      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1520      * constructor.
1521      * ====
1522      */
1523     function isContract(address account) internal view returns (bool) {
1524         // This method relies on extcodesize/address.code.length, which returns 0
1525         // for contracts in construction, since the code is only stored at the end
1526         // of the constructor execution.
1527 
1528         return account.code.length > 0;
1529     }
1530 
1531     /**
1532      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1533      * `recipient`, forwarding all available gas and reverting on errors.
1534      *
1535      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1536      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1537      * imposed by `transfer`, making them unable to receive funds via
1538      * `transfer`. {sendValue} removes this limitation.
1539      *
1540      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1541      *
1542      * IMPORTANT: because control is transferred to `recipient`, care must be
1543      * taken to not create reentrancy vulnerabilities. Consider using
1544      * {ReentrancyGuard} or the
1545      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1546      */
1547     function sendValue(address payable recipient, uint256 amount) internal {
1548         require(address(this).balance >= amount, "Address: insufficient balance");
1549 
1550         (bool success, ) = recipient.call{value: amount}("");
1551         require(success, "Address: unable to send value, recipient may have reverted");
1552     }
1553 
1554     /**
1555      * @dev Performs a Solidity function call using a low level `call`. A
1556      * plain `call` is an unsafe replacement for a function call: use this
1557      * function instead.
1558      *
1559      * If `target` reverts with a revert reason, it is bubbled up by this
1560      * function (like regular Solidity function calls).
1561      *
1562      * Returns the raw returned data. To convert to the expected return value,
1563      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1564      *
1565      * Requirements:
1566      *
1567      * - `target` must be a contract.
1568      * - calling `target` with `data` must not revert.
1569      *
1570      * _Available since v3.1._
1571      */
1572     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1573         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1574     }
1575 
1576     /**
1577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1578      * `errorMessage` as a fallback revert reason when `target` reverts.
1579      *
1580      * _Available since v3.1._
1581      */
1582     function functionCall(
1583         address target,
1584         bytes memory data,
1585         string memory errorMessage
1586     ) internal returns (bytes memory) {
1587         return functionCallWithValue(target, data, 0, errorMessage);
1588     }
1589 
1590     /**
1591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1592      * but also transferring `value` wei to `target`.
1593      *
1594      * Requirements:
1595      *
1596      * - the calling contract must have an ETH balance of at least `value`.
1597      * - the called Solidity function must be `payable`.
1598      *
1599      * _Available since v3.1._
1600      */
1601     function functionCallWithValue(
1602         address target,
1603         bytes memory data,
1604         uint256 value
1605     ) internal returns (bytes memory) {
1606         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1607     }
1608 
1609     /**
1610      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1611      * with `errorMessage` as a fallback revert reason when `target` reverts.
1612      *
1613      * _Available since v3.1._
1614      */
1615     function functionCallWithValue(
1616         address target,
1617         bytes memory data,
1618         uint256 value,
1619         string memory errorMessage
1620     ) internal returns (bytes memory) {
1621         require(address(this).balance >= value, "Address: insufficient balance for call");
1622         (bool success, bytes memory returndata) = target.call{value: value}(data);
1623         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1624     }
1625 
1626     /**
1627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1628      * but performing a static call.
1629      *
1630      * _Available since v3.3._
1631      */
1632     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1633         return functionStaticCall(target, data, "Address: low-level static call failed");
1634     }
1635 
1636     /**
1637      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1638      * but performing a static call.
1639      *
1640      * _Available since v3.3._
1641      */
1642     function functionStaticCall(
1643         address target,
1644         bytes memory data,
1645         string memory errorMessage
1646     ) internal view returns (bytes memory) {
1647         (bool success, bytes memory returndata) = target.staticcall(data);
1648         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1649     }
1650 
1651     /**
1652      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1653      * but performing a delegate call.
1654      *
1655      * _Available since v3.4._
1656      */
1657     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1658         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1659     }
1660 
1661     /**
1662      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1663      * but performing a delegate call.
1664      *
1665      * _Available since v3.4._
1666      */
1667     function functionDelegateCall(
1668         address target,
1669         bytes memory data,
1670         string memory errorMessage
1671     ) internal returns (bytes memory) {
1672         (bool success, bytes memory returndata) = target.delegatecall(data);
1673         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1674     }
1675 
1676     /**
1677      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1678      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1679      *
1680      * _Available since v4.8._
1681      */
1682     function verifyCallResultFromTarget(
1683         address target,
1684         bool success,
1685         bytes memory returndata,
1686         string memory errorMessage
1687     ) internal view returns (bytes memory) {
1688         if (success) {
1689             if (returndata.length == 0) {
1690                 // only check isContract if the call was successful and the return data is empty
1691                 // otherwise we already know that it was a contract
1692                 require(isContract(target), "Address: call to non-contract");
1693             }
1694             return returndata;
1695         } else {
1696             _revert(returndata, errorMessage);
1697         }
1698     }
1699 
1700     /**
1701      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1702      * revert reason or using the provided one.
1703      *
1704      * _Available since v4.3._
1705      */
1706     function verifyCallResult(
1707         bool success,
1708         bytes memory returndata,
1709         string memory errorMessage
1710     ) internal pure returns (bytes memory) {
1711         if (success) {
1712             return returndata;
1713         } else {
1714             _revert(returndata, errorMessage);
1715         }
1716     }
1717 
1718     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1719         // Look for revert reason and bubble it up if present
1720         if (returndata.length > 0) {
1721             // The easiest way to bubble the revert reason is using memory via assembly
1722             /// @solidity memory-safe-assembly
1723             assembly {
1724                 let returndata_size := mload(returndata)
1725                 revert(add(32, returndata), returndata_size)
1726             }
1727         } else {
1728             revert(errorMessage);
1729         }
1730     }
1731 }
1732 
1733 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1734 
1735 
1736 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1737 
1738 pragma solidity ^0.8.0;
1739 
1740 /**
1741  * @title ERC721 token receiver interface
1742  * @dev Interface for any contract that wants to support safeTransfers
1743  * from ERC721 asset contracts.
1744  */
1745 interface IERC721Receiver {
1746     /**
1747      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1748      * by `operator` from `from`, this function is called.
1749      *
1750      * It must return its Solidity selector to confirm the token transfer.
1751      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1752      *
1753      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1754      */
1755     function onERC721Received(
1756         address operator,
1757         address from,
1758         uint256 tokenId,
1759         bytes calldata data
1760     ) external returns (bytes4);
1761 }
1762 
1763 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1764 
1765 
1766 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1767 
1768 
1769 
1770 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1771 
1772 
1773 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1774 
1775 
1776 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1777 
1778 pragma solidity ^0.8.0;
1779 
1780 /**
1781  * @dev Interface of the ERC165 standard, as defined in the
1782  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1783  *
1784  * Implementers can declare support of contract interfaces, which can then be
1785  * queried by others ({ERC165Checker}).
1786  *
1787  * For an implementation, see {ERC165}.
1788  */
1789 interface IERC165 {
1790     /**
1791      * @dev Returns true if this contract implements the interface defined by
1792      * `interfaceId`. See the corresponding
1793      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1794      * to learn more about how these ids are created.
1795      *
1796      * This function call must use less than 30 000 gas.
1797      */
1798     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1799 }
1800 
1801 
1802 
1803 pragma solidity ^0.8.0;
1804 
1805 
1806 /**
1807  * @dev Implementation of the {IERC165} interface.
1808  *
1809  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1810  * for the additional interface id that will be supported. For example:
1811  *
1812  * ```solidity
1813  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1814  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1815  * }
1816  * ```
1817  *
1818  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1819  */
1820 abstract contract ERC165 is IERC165 {
1821     /**
1822      * @dev See {IERC165-supportsInterface}.
1823      */
1824     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1825         return interfaceId == type(IERC165).interfaceId;
1826     }
1827 }
1828 
1829 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1830 
1831 
1832 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1833 
1834 pragma solidity ^0.8.0;
1835 
1836 
1837 /**
1838  * @dev Required interface of an ERC721 compliant contract.
1839  */
1840 interface IERC721 is IERC165 {
1841     /**
1842      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1843      */
1844     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1845 
1846     /**
1847      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1848      */
1849     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1850 
1851     /**
1852      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1853      */
1854     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1855 
1856     /**
1857      * @dev Returns the number of tokens in ``owner``'s account.
1858      */
1859     function balanceOf(address owner) external view returns (uint256 balance);
1860 
1861     /**
1862      * @dev Returns the owner of the `tokenId` token.
1863      *
1864      * Requirements:
1865      *
1866      * - `tokenId` must exist.
1867      */
1868     function ownerOf(uint256 tokenId) external view returns (address owner);
1869 
1870     /**
1871      * @dev Safely transfers `tokenId` token from `from` to `to`.
1872      *
1873      * Requirements:
1874      *
1875      * - `from` cannot be the zero address.
1876      * - `to` cannot be the zero address.
1877      * - `tokenId` token must exist and be owned by `from`.
1878      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1880      *
1881      * Emits a {Transfer} event.
1882      */
1883     function safeTransferFrom(
1884         address from,
1885         address to,
1886         uint256 tokenId,
1887         bytes calldata data
1888     ) external ;
1889 
1890     /**
1891      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1892      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1893      *
1894      * Requirements:
1895      *
1896      * - `from` cannot be the zero address.
1897      * - `to` cannot be the zero address.
1898      * - `tokenId` token must exist and be owned by `from`.
1899      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1901      *
1902      * Emits a {Transfer} event.
1903      */
1904     function safeTransferFrom(
1905         address from,
1906         address to,
1907         uint256 tokenId
1908     ) external;
1909 
1910     /**
1911      * @dev Transfers `tokenId` token from `from` to `to`.
1912      *
1913      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1914      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1915      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1916      *
1917      * Requirements:
1918      *
1919      * - `from` cannot be the zero address.
1920      * - `to` cannot be the zero address.
1921      * - `tokenId` token must be owned by `from`.
1922      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1923      *
1924      * Emits a {Transfer} event.
1925      */
1926     function transferFrom(
1927         address from,
1928         address to,
1929         uint256 tokenId
1930     ) external;
1931 
1932     /**
1933      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1934      * The approval is cleared when the token is transferred.
1935      *
1936      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1937      *
1938      * Requirements:
1939      *
1940      * - The caller must own the token or be an approved operator.
1941      * - `tokenId` must exist.
1942      *
1943      * Emits an {Approval} event.
1944      */
1945     function approve(address to, uint256 tokenId) external;
1946 
1947     /**
1948      * @dev Approve or remove `operator` as an operator for the caller.
1949      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1950      *
1951      * Requirements:
1952      *
1953      * - The `operator` cannot be the caller.
1954      *
1955      * Emits an {ApprovalForAll} event.
1956      */
1957     function setApprovalForAll(address operator, bool _approved) external;
1958 
1959     /**
1960      * @dev Returns the account approved for `tokenId` token.
1961      *
1962      * Requirements:
1963      *
1964      * - `tokenId` must exist.
1965      */
1966     function getApproved(uint256 tokenId) external view returns (address operator);
1967 
1968     /**
1969      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1970      *
1971      * See {setApprovalForAll}
1972      */
1973     function isApprovedForAll(address owner, address operator) external view returns (bool);
1974 }
1975 
1976 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1977 
1978 
1979 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1980 
1981 pragma solidity ^0.8.0;
1982 
1983 
1984 /**
1985  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1986  * @dev See https://eips.ethereum.org/EIPS/eip-721
1987  */
1988 interface IERC721Metadata is IERC721 {
1989     /**
1990      * @dev Returns the token collection name.
1991      */
1992     function name() external view returns (string memory);
1993 
1994     /**
1995      * @dev Returns the token collection symbol.
1996      */
1997     function symbol() external view returns (string memory);
1998 
1999     /**
2000      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2001      */
2002     function tokenURI(uint256 tokenId) external view returns (string memory);
2003 }
2004 
2005 // File: @openzeppelin/contracts/utils/Context.sol
2006 
2007 pragma solidity ^0.8.0;
2008 
2009 
2010 
2011 interface IERC721Enumerable is IERC721 {
2012   
2013     function totalSupply() external view returns (uint256);
2014 
2015 
2016     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
2017 
2018 
2019     function tokenByIndex(uint256 index) external view returns (uint256);
2020 }
2021 
2022 pragma solidity ^0.8.0;
2023 
2024 abstract contract ReentrancyGuard {
2025 
2026     uint256 private constant _NOT_ENTERED = 1;
2027     uint256 private constant _ENTERED = 2;
2028 
2029     uint256 private _status;
2030 
2031     constructor() {
2032         _status = _NOT_ENTERED;
2033     }
2034 
2035 
2036     modifier nonReentrant() {
2037         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2038 
2039         _status = _ENTERED;
2040 
2041         _;
2042 
2043         _status = _NOT_ENTERED;
2044     }
2045 }
2046 
2047 
2048 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2049 
2050 pragma solidity ^0.8.0;
2051 
2052 /**
2053  * @dev Provides information about the current execution context, including the
2054  * sender of the transaction and its data. While these are generally available
2055  * via msg.sender and msg.data, they should not be accessed in such a direct
2056  * manner, since when dealing with meta-transactions the account sending and
2057  * paying for execution may not be the actual sender (as far as an application
2058  * is concerned).
2059  *
2060  * This contract is only required for intermediate, library-like contracts.
2061  */
2062 abstract contract Context {
2063     function _msgSender() internal view virtual returns (address) {
2064         return msg.sender;
2065     }
2066 
2067     function _msgData() internal view virtual returns (bytes calldata) {
2068         return msg.data;
2069     }
2070 }
2071 
2072 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2073 
2074 
2075 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
2076 
2077 pragma solidity ^0.8.0;
2078 
2079 
2080 
2081 
2082 // File: @openzeppelin/contracts/access/Ownable.sol
2083 
2084 
2085 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2086 
2087 pragma solidity ^0.8.0;
2088 
2089 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, DefaultOperatorFilterer {
2090     using Address for address;
2091     using Strings for uint256;
2092 
2093     struct TokenOwnership {
2094         address addr;
2095         uint64 startTimestamp;
2096     }
2097 
2098     struct AddressData {
2099         uint128 balance;
2100         uint128 numberMinted;
2101     }
2102 
2103     uint256 internal currentIndex;
2104 
2105     string private _name;
2106 
2107     string private _symbol;
2108 
2109     mapping(uint256 => TokenOwnership) internal _ownerships;
2110 
2111     mapping(address => AddressData) private _addressData;
2112 
2113     mapping(uint256 => address) private _tokenApprovals;
2114 
2115     mapping(address => mapping(address => bool)) private _operatorApprovals;
2116 
2117     constructor(string memory name_, string memory symbol_) {
2118         _name = name_;
2119         _symbol = symbol_;
2120     }
2121 
2122     function totalSupply() public view override returns (uint256) {
2123         return currentIndex;
2124     }
2125 
2126     function tokenByIndex(uint256 index) public view override returns (uint256) {
2127         require(index < totalSupply(), "ERC721A: global index out of bounds");
2128         return index;
2129     }
2130 
2131     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
2132         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
2133         uint256 numMintedSoFar = totalSupply();
2134         uint256 tokenIdsIdx;
2135         address currOwnershipAddr;
2136 
2137         unchecked {
2138             for (uint256 i; i < numMintedSoFar; i++) {
2139                 TokenOwnership memory ownership = _ownerships[i];
2140                 if (ownership.addr != address(0)) {
2141                     currOwnershipAddr = ownership.addr;
2142                 }
2143                 if (currOwnershipAddr == owner) {
2144                     if (tokenIdsIdx == index) {
2145                         return i;
2146                     }
2147                     tokenIdsIdx++;
2148                 }
2149             }
2150         }
2151 
2152         revert("ERC721A: unable to get token of owner by index");
2153     }
2154 
2155 
2156     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2157         return
2158             interfaceId == type(IERC721).interfaceId ||
2159             interfaceId == type(IERC721Metadata).interfaceId ||
2160             interfaceId == type(IERC721Enumerable).interfaceId ||
2161             super.supportsInterface(interfaceId);
2162     }
2163 
2164     function balanceOf(address owner) public view override returns (uint256) {
2165         require(owner != address(0), "ERC721A: balance query for the zero address");
2166         return uint256(_addressData[owner].balance);
2167     }
2168 
2169     function _numberMinted(address owner) internal view returns (uint256) {
2170         require(owner != address(0), "ERC721A: number minted query for the zero address");
2171         return uint256(_addressData[owner].numberMinted);
2172     }
2173 
2174     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2175         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
2176 
2177         unchecked {
2178             for (uint256 curr = tokenId; curr >= 0; curr--) {
2179                 TokenOwnership memory ownership = _ownerships[curr];
2180                 if (ownership.addr != address(0)) {
2181                     return ownership;
2182                 }
2183             }
2184         }
2185 
2186         revert("ERC721A: unable to determine the owner of token");
2187     }
2188 
2189     function ownerOf(uint256 tokenId) public view override returns (address) {
2190         return ownershipOf(tokenId).addr;
2191     }
2192 
2193     function name() public view virtual override returns (string memory) {
2194         return _name;
2195     }
2196 
2197     function symbol() public view virtual override returns (string memory) {
2198         return _symbol;
2199     }
2200 
2201     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2202         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2203 
2204         string memory baseURI = _baseURI();
2205         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2206     }
2207 
2208     function _baseURI() internal view virtual returns (string memory) {
2209         return "";
2210     }
2211 
2212 
2213     function approve(address to, uint256 tokenId) public virtual override onlyAllowedOperator(to) {
2214         address owner = ERC721A.ownerOf(tokenId);
2215         require(to != owner, "ERC721A: approval to current owner");
2216 
2217         require(
2218             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2219             "ERC721A: approve caller is not owner nor approved for all"
2220         );
2221 
2222         _approve(to, tokenId, owner);
2223     }
2224 
2225     function getApproved(uint256 tokenId) public view override returns (address) {
2226         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
2227 
2228         return _tokenApprovals[tokenId];
2229     }
2230 
2231     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperator(operator) {
2232         require(operator != _msgSender(), "ERC721A: approve to caller");
2233 
2234         _operatorApprovals[_msgSender()][operator] = approved;
2235         emit ApprovalForAll(_msgSender(), operator, approved);
2236     }
2237 
2238     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2239         return _operatorApprovals[owner][operator];
2240     }
2241 
2242     function transferFrom(
2243         address from,
2244         address to,
2245         uint256 tokenId
2246     ) public virtual override onlyAllowedOperator(from){
2247         _transfer(from, to, tokenId);
2248     }
2249 
2250     function safeTransferFrom(
2251         address from,
2252         address to,
2253         uint256 tokenId
2254     ) public virtual override onlyAllowedOperator(from) {
2255         safeTransferFrom(from, to, tokenId, "");
2256     }
2257 
2258     function safeTransferFrom(
2259         address from,
2260         address to,
2261         uint256 tokenId,
2262         bytes memory _data
2263     ) public virtual override onlyAllowedOperator(from){
2264         _transfer(from, to, tokenId);
2265         require(
2266             _checkOnERC721Received(from, to, tokenId, _data),
2267             "ERC721A: transfer to non ERC721Receiver implementer"
2268         );
2269     }
2270 
2271     function _exists(uint256 tokenId) internal view returns (bool) {
2272         return tokenId < currentIndex;
2273     }
2274 
2275     function _safeMint(address to, uint256 quantity) internal {
2276         _safeMint(to, quantity, "");
2277     }
2278 
2279     function _safeMint(
2280         address to,
2281         uint256 quantity,
2282         bytes memory _data
2283     ) internal {
2284         _mint(to, quantity, _data, true);
2285     }
2286 
2287     function _mint(
2288         address to,
2289         uint256 quantity,
2290         bytes memory _data,
2291         bool safe
2292     ) internal {
2293         uint256 startTokenId = currentIndex;
2294         require(to != address(0), "ERC721A: mint to the zero address");
2295         require(quantity != 0, "ERC721A: quantity must be greater than 0");
2296 
2297         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2298 
2299         unchecked {
2300             _addressData[to].balance += uint128(quantity);
2301             _addressData[to].numberMinted += uint128(quantity);
2302 
2303             _ownerships[startTokenId].addr = to;
2304             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2305 
2306             uint256 updatedIndex = startTokenId;
2307 
2308             for (uint256 i; i < quantity; i++) {
2309                 emit Transfer(address(0), to, updatedIndex);
2310                 if (safe) {
2311                     require(
2312                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
2313                         "ERC721A: transfer to non ERC721Receiver implementer"
2314                     );
2315                 }
2316 
2317                 updatedIndex++;
2318             }
2319 
2320             currentIndex = updatedIndex;
2321         }
2322 
2323         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2324     }
2325  
2326     function _transfer(
2327         address from,
2328         address to,
2329         uint256 tokenId
2330     ) private {
2331         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2332 
2333         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
2334             getApproved(tokenId) == _msgSender() ||
2335             isApprovedForAll(prevOwnership.addr, _msgSender()));
2336 
2337         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
2338 
2339         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
2340         require(to != address(0), "ERC721A: transfer to the zero address");
2341 
2342         _beforeTokenTransfers(from, to, tokenId, 1);
2343 
2344         _approve(address(0), tokenId, prevOwnership.addr);
2345 
2346         
2347         unchecked {
2348             _addressData[from].balance -= 1;
2349             _addressData[to].balance += 1;
2350 
2351             _ownerships[tokenId].addr = to;
2352             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2353 
2354             uint256 nextTokenId = tokenId + 1;
2355             if (_ownerships[nextTokenId].addr == address(0)) {
2356                 if (_exists(nextTokenId)) {
2357                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2358                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2359                 }
2360             }
2361         }
2362 
2363         emit Transfer(from, to, tokenId);
2364         _afterTokenTransfers(from, to, tokenId, 1);
2365     }
2366 
2367     function _approve(
2368         address to,
2369         uint256 tokenId,
2370         address owner
2371     ) private {
2372         _tokenApprovals[tokenId] = to;
2373         emit Approval(owner, to, tokenId);
2374     }
2375 
2376     function _checkOnERC721Received(
2377         address from,
2378         address to,
2379         uint256 tokenId,
2380         bytes memory _data
2381     ) private returns (bool) {
2382         if (to.isContract()) {
2383             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2384                 return retval == IERC721Receiver(to).onERC721Received.selector;
2385             } catch (bytes memory reason) {
2386                 if (reason.length == 0) {
2387                     revert("ERC721A: transfer to non ERC721Receiver implementer");
2388                 } else {
2389                     assembly {
2390                         revert(add(32, reason), mload(reason))
2391                     }
2392                 }
2393             }
2394         } else {
2395             return true;
2396         }
2397     }
2398 
2399     function _beforeTokenTransfers(
2400         address from,
2401         address to,
2402         uint256 startTokenId,
2403         uint256 quantity
2404     ) internal virtual {}
2405 
2406     function _afterTokenTransfers(
2407         address from,
2408         address to,
2409         uint256 startTokenId,
2410         uint256 quantity
2411     ) internal virtual {}
2412 }
2413 
2414 
2415 /**
2416  * @dev Contract module which provides a basic access control mechanism, where
2417  * there is an account (an owner) that can be granted exclusive access to
2418  * specific functions.
2419  *
2420  * By default, the owner account will be the one that deploys the contract. This
2421  * can later be changed with {transferOwnership}.
2422  *
2423  * This module is used through inheritance. It will make available the modifier
2424  * `onlyOwner`, which can be applied to your functions to restrict their use to
2425  * the owner.
2426  */
2427 abstract contract Ownable is Context {
2428     address private _owner;
2429 
2430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2431 
2432     /**
2433      * @dev Initializes the contract setting the deployer as the initial owner.
2434      */
2435     constructor() {
2436         _transferOwnership(_msgSender());
2437     }
2438 
2439     /**
2440      * @dev Throws if called by any account other than the owner.
2441      */
2442     modifier onlyOwner() {
2443         _checkOwner();
2444         _;
2445     }
2446 
2447     /**
2448      * @dev Returns the address of the current owner.
2449      */
2450     function owner() public view virtual returns (address) {
2451         return _owner;
2452     }
2453 
2454     /**
2455      * @dev Throws if the sender is not the owner.
2456      */
2457     function _checkOwner() internal view virtual {
2458         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2459     }
2460 
2461     /**
2462      * @dev Leaves the contract without owner. It will not be possible to call
2463      * `onlyOwner` functions anymore. Can only be called by the current owner.
2464      *
2465      * NOTE: Renouncing ownership will leave the contract without an owner,
2466      * thereby removing any functionality that is only available to the owner.
2467      */
2468     function renounceOwnership() public virtual onlyOwner {
2469         _transferOwnership(address(0));
2470     }
2471 
2472     /**
2473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2474      * Can only be called by the current owner.
2475      */
2476     function transferOwnership(address newOwner) public virtual onlyOwner {
2477         require(newOwner != address(0), "Ownable: new owner is the zero address");
2478         _transferOwnership(newOwner);
2479     }
2480 
2481     /**
2482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2483      * Internal function without access restriction.
2484      */
2485     function _transferOwnership(address newOwner) internal virtual {
2486         address oldOwner = _owner;
2487         _owner = newOwner;
2488         emit OwnershipTransferred(oldOwner, newOwner);
2489     }
2490 }
2491 
2492 abstract contract Ownable2Step is Ownable {
2493     address private _pendingOwner;
2494 
2495     event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
2496 
2497     /**
2498      * @dev Returns the address of the pending owner.
2499      */
2500     function pendingOwner() public view virtual returns (address) {
2501         return _pendingOwner;
2502     }
2503 
2504     /**
2505      * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
2506      * Can only be called by the current owner.
2507      */
2508     function transferOwnership(address newOwner) public virtual override onlyOwner {
2509         _pendingOwner = newOwner;
2510         emit OwnershipTransferStarted(owner(), newOwner);
2511     }
2512 
2513     /**
2514      * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
2515      * Internal function without access restriction.
2516      */
2517     function _transferOwnership(address newOwner) internal virtual override {
2518         delete _pendingOwner;
2519         super._transferOwnership(newOwner);
2520     }
2521 
2522     /**
2523      * @dev The new owner accepts the ownership transfer.
2524      */
2525     function acceptOwnership() external {
2526         address sender = _msgSender();
2527         require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
2528         _transferOwnership(sender);
2529     }
2530 }
2531 
2532 contract OwnedRegistrant is Ownable2Step {
2533     address constant registry = 0x000000000000AAeB6D7670E522A718067333cd4E;
2534 
2535     constructor(address _owner) {
2536         IOperatorFilterRegistry(registry).register(address(this));
2537         transferOwnership(_owner);
2538     }
2539 }
2540 
2541 
2542 pragma solidity ^0.8.13;
2543 
2544 /**
2545  * @title  UpdatableOperatorFilterer
2546  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2547  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
2548  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
2549  *         which will bypass registry checks.
2550  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
2551  *         on-chain, eg, if the registry is revoked or bypassed.
2552  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2553  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2554  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2555  */
2556 abstract contract UpdatableOperatorFilterer {
2557     error OperatorNotAllowed(address operator);
2558     error OnlyOwner();
2559 
2560     IOperatorFilterRegistry public operatorFilterRegistry;
2561 
2562     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
2563         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
2564         operatorFilterRegistry = registry;
2565         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2566         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2567         // order for the modifier to filter addresses.
2568         if (address(registry).code.length > 0) {
2569             if (subscribe) {
2570                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2571             } else {
2572                 if (subscriptionOrRegistrantToCopy != address(0)) {
2573                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2574                 } else {
2575                     registry.register(address(this));
2576                 }
2577             }
2578         }
2579     }
2580 
2581     modifier onlyAllowedOperator(address from) virtual {
2582         // Allow spending tokens from addresses with balance
2583         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2584         // from an EOA.
2585         if (from != msg.sender) {
2586             _checkFilterOperator(msg.sender);
2587         }
2588         _;
2589     }
2590 
2591     modifier onlyAllowedOperatorApproval(address operator) virtual {
2592         _checkFilterOperator(operator);
2593         _;
2594     }
2595 
2596     /**
2597      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
2598      *         address, checks will be bypassed. OnlyOwner.
2599      */
2600     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
2601         if (msg.sender != owner()) {
2602             revert OnlyOwner();
2603         }
2604         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
2605     }
2606 
2607     /**
2608      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
2609      */
2610     function owner() public view virtual returns (address);
2611 
2612     function _checkFilterOperator(address operator) internal view virtual {
2613         IOperatorFilterRegistry registry = operatorFilterRegistry;
2614         // Check registry code length to facilitate testing in environments without a deployed registry.
2615         if (address(registry) != address(0) && address(registry).code.length > 0) {
2616             if (!registry.isOperatorAllowed(address(this), operator)) {
2617                 revert OperatorNotAllowed(operator);
2618             }
2619         }
2620     }
2621 }
2622 
2623 
2624 pragma solidity ^0.8.13;
2625 
2626 /**
2627  * @title  RevokableOperatorFilterer
2628  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
2629  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
2630  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
2631  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
2632  *         address cannot be further updated.
2633  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
2634  *         on-chain, eg, if the registry is revoked or bypassed.
2635  */
2636 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
2637     error RegistryHasBeenRevoked();
2638     error InitialRegistryAddressCannotBeZeroAddress();
2639 
2640     bool public isOperatorFilterRegistryRevoked;
2641 
2642     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
2643         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
2644     {
2645         // don't allow creating a contract with a permanently revoked registry
2646         if (_registry == address(0)) {
2647             revert InitialRegistryAddressCannotBeZeroAddress();
2648         }
2649     }
2650 
2651     function _checkFilterOperator(address operator) internal view virtual override {
2652         if (address(operatorFilterRegistry) != address(0)) {
2653             super._checkFilterOperator(operator);
2654         }
2655     }
2656 
2657     /**
2658      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
2659      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
2660      */
2661     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
2662         if (msg.sender != owner()) {
2663             revert OnlyOwner();
2664         }
2665         // if registry has been revoked, do not allow further updates
2666         if (isOperatorFilterRegistryRevoked) {
2667             revert RegistryHasBeenRevoked();
2668         }
2669 
2670         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
2671     }
2672 
2673     /**
2674      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
2675      */
2676     function revokeOperatorFilterRegistry() public {
2677         if (msg.sender != owner()) {
2678             revert OnlyOwner();
2679         }
2680         // if registry has been revoked, do not allow further updates
2681         if (isOperatorFilterRegistryRevoked) {
2682             revert RegistryHasBeenRevoked();
2683         }
2684 
2685         // set to zero address to bypass checks
2686         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
2687         isOperatorFilterRegistryRevoked = true;
2688     }
2689 }
2690 
2691 pragma solidity ^0.8.13;
2692 
2693 /**
2694  * @title  RevokableDefaultOperatorFilterer
2695  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
2696  *         Note that OpenSea will disable creator fee enforcement if filtered operators begin fulfilling orders
2697  *         on-chain, eg, if the registry is revoked or bypassed.
2698  */
2699 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
2700     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2701 
2702     constructor() RevokableOperatorFilterer(0x000000000000AAeB6D7670E522A718067333cd4E, DEFAULT_SUBSCRIPTION, true) {}
2703 }
2704 
2705 
2706 pragma solidity ^0.8.9;
2707 
2708 contract BoredJimmyYC is ERC721A, Ownable, ReentrancyGuard {
2709     using Strings for uint256;
2710     
2711     address private _mechaMonkeyContract; //Companion 
2712     uint   private _totalStake;
2713     bool   public JimmyTrialPhase = false; // Key owners reveal phase 2
2714     uint   public price             = 0.008 ether;
2715     uint   public maxTx          = 20;
2716     uint   public maxSupply          = 10000;
2717     uint256 public reservedSupply = 100;
2718     string private baseURI;
2719     bool   public mintEnabled;  
2720     uint   public maxPerFree        = 1;
2721     uint   public totalFreeMinted = 0;
2722     uint   public totalFree         = 2000;
2723     
2724     mapping(address => uint256) public _FreeMinted;
2725 
2726     constructor() ERC721A("Bored Jimmy YC", "BJYC") {}
2727 
2728     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2729         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
2730         string memory currentBaseURI = _baseURI();
2731         return bytes(currentBaseURI).length > 0
2732             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
2733             : "";
2734     }
2735 
2736     function _baseURI() internal view virtual override returns (string memory) {
2737         return baseURI;
2738     }
2739 
2740     function mint(uint256 count) external payable {
2741         
2742         bool MintForFree = ((totalFreeMinted < totalFree) &&
2743             (_FreeMinted[msg.sender] < maxPerFree));
2744 
2745         if (MintForFree) { 
2746             require(mintEnabled, "Mint is not live yet");
2747             require(totalSupply() + count <= maxSupply, "No more");
2748             require(count <= maxTx, "Max per TX reached.");
2749             if(count >= (maxPerFree - _FreeMinted[msg.sender]))
2750             {
2751              require(msg.value >= (count * price) - ((maxPerFree - _FreeMinted[msg.sender]) * price), "Please send the exact ETH amount");
2752              _FreeMinted[msg.sender] = maxPerFree;
2753              totalFreeMinted += maxPerFree;
2754             }
2755             else if(count < (maxPerFree - _FreeMinted[msg.sender]))
2756             {
2757              require(msg.value >= 0, "Please send the exact ETH amount");
2758              _FreeMinted[msg.sender] += count;
2759              totalFreeMinted += count;
2760             }
2761         }
2762         else{
2763             require(mintEnabled, "Mint is not live yet");
2764             require(msg.value >= count * price, "Please send the exact ETH amount");
2765             require(totalSupply() + count <= maxSupply, "No more");
2766             require(count <= maxTx, "Max per TX reached.");
2767         }
2768 
2769         _safeMint(msg.sender, count);
2770     }
2771 
2772     function reservedMint(uint256 Amount) external onlyOwner
2773     {
2774         uint256 Remaining = reservedSupply;
2775 
2776         require(totalSupply() + Amount <= maxSupply, "No more supply to be minted");
2777         require(Remaining >= Amount, "Reserved Supply Minted");
2778     
2779         reservedSupply = Remaining - Amount;
2780         _safeMint(msg.sender, Amount);
2781        // totalSupply() += Amount;
2782     }
2783 
2784     function toggleMinting() external onlyOwner {
2785       mintEnabled = !mintEnabled;
2786     }
2787 
2788    function setBaseUri(string memory baseuri_) public onlyOwner {
2789         baseURI = baseuri_;
2790     }
2791 
2792     function setCost(uint256 price_) external onlyOwner {
2793         price = price_;
2794     }
2795 
2796     function costInspect() public view returns (uint256) {
2797         return price;
2798     }
2799 
2800      function setmaxTx(uint256 _MaxTx) external onlyOwner {
2801         maxTx = _MaxTx;
2802     }
2803 
2804     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
2805         totalFree = MaxTotalFree_;
2806     }
2807 
2808     function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
2809         maxPerFree = MaxPerFree_;
2810     }
2811 
2812     function setMechaMonkeyContract(address _contract) public onlyOwner {
2813         _mechaMonkeyContract = _contract;
2814     }
2815 
2816     function toggleJimmyTrialPhase() public onlyOwner {
2817         JimmyTrialPhase = !JimmyTrialPhase;
2818     }
2819 
2820     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2821         super.setApprovalForAll(operator, approved);
2822     }
2823 
2824     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2825         super.approve(operator, tokenId);
2826     }
2827 
2828     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2829         super.transferFrom(from, to, tokenId);
2830     }
2831 
2832     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2833         super.safeTransferFrom(from, to, tokenId);
2834     }
2835 
2836     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2837         public
2838         override
2839         onlyAllowedOperator(from)
2840     {
2841         super.safeTransferFrom(from, to, tokenId, data);
2842     }
2843 
2844     function withdraw() external onlyOwner nonReentrant {
2845         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2846         require(success, "Transfer failed.");
2847     }
2848 }