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
2093 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, DefaultOperatorFilterer {
2094     using Address for address;
2095     using Strings for uint256;
2096 
2097     struct TokenOwnership {
2098         address addr;
2099         uint64 startTimestamp;
2100     }
2101 
2102     struct AddressData {
2103         uint128 balance;
2104         uint128 numberMinted;
2105     }
2106 
2107     uint256 internal currentIndex;
2108 
2109     string private _name;
2110 
2111     string private _symbol;
2112 
2113     mapping(uint256 => TokenOwnership) internal _ownerships;
2114 
2115     mapping(address => AddressData) private _addressData;
2116 
2117     mapping(uint256 => address) private _tokenApprovals;
2118 
2119     mapping(address => mapping(address => bool)) private _operatorApprovals;
2120 
2121     constructor(string memory name_, string memory symbol_) {
2122         _name = name_;
2123         _symbol = symbol_;
2124     }
2125 
2126     function totalSupply() public view override returns (uint256) {
2127         return currentIndex;
2128     }
2129 
2130     function tokenByIndex(uint256 index) public view override returns (uint256) {
2131         require(index < totalSupply(), "ERC721A: global index out of bounds");
2132         return index;
2133     }
2134 
2135     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
2136         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
2137         uint256 numMintedSoFar = totalSupply();
2138         uint256 tokenIdsIdx;
2139         address currOwnershipAddr;
2140 
2141         unchecked {
2142             for (uint256 i; i < numMintedSoFar; i++) {
2143                 TokenOwnership memory ownership = _ownerships[i];
2144                 if (ownership.addr != address(0)) {
2145                     currOwnershipAddr = ownership.addr;
2146                 }
2147                 if (currOwnershipAddr == owner) {
2148                     if (tokenIdsIdx == index) {
2149                         return i;
2150                     }
2151                     tokenIdsIdx++;
2152                 }
2153             }
2154         }
2155 
2156         revert("ERC721A: unable to get token of owner by index");
2157     }
2158 
2159 
2160     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2161         return
2162             interfaceId == type(IERC721).interfaceId ||
2163             interfaceId == type(IERC721Metadata).interfaceId ||
2164             interfaceId == type(IERC721Enumerable).interfaceId ||
2165             super.supportsInterface(interfaceId);
2166     }
2167 
2168     function balanceOf(address owner) public view override returns (uint256) {
2169         require(owner != address(0), "ERC721A: balance query for the zero address");
2170         return uint256(_addressData[owner].balance);
2171     }
2172 
2173     function _numberMinted(address owner) internal view returns (uint256) {
2174         require(owner != address(0), "ERC721A: number minted query for the zero address");
2175         return uint256(_addressData[owner].numberMinted);
2176     }
2177 
2178     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2179         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
2180 
2181         unchecked {
2182             for (uint256 curr = tokenId; curr >= 0; curr--) {
2183                 TokenOwnership memory ownership = _ownerships[curr];
2184                 if (ownership.addr != address(0)) {
2185                     return ownership;
2186                 }
2187             }
2188         }
2189 
2190         revert("ERC721A: unable to determine the owner of token");
2191     }
2192 
2193     function ownerOf(uint256 tokenId) public view override returns (address) {
2194         return ownershipOf(tokenId).addr;
2195     }
2196 
2197     function name() public view virtual override returns (string memory) {
2198         return _name;
2199     }
2200 
2201     function symbol() public view virtual override returns (string memory) {
2202         return _symbol;
2203     }
2204 
2205     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2206         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2207 
2208         string memory baseURI = _baseURI();
2209         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2210     }
2211 
2212     function _baseURI() internal view virtual returns (string memory) {
2213         return "";
2214     }
2215 
2216 
2217     function approve(address to, uint256 tokenId) public virtual override onlyAllowedOperator(to) {
2218         address owner = ERC721A.ownerOf(tokenId);
2219         require(to != owner, "ERC721A: approval to current owner");
2220 
2221         require(
2222             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2223             "ERC721A: approve caller is not owner nor approved for all"
2224         );
2225 
2226         _approve(to, tokenId, owner);
2227     }
2228 
2229     function getApproved(uint256 tokenId) public view override returns (address) {
2230         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
2231 
2232         return _tokenApprovals[tokenId];
2233     }
2234 
2235     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperator(operator) {
2236         require(operator != _msgSender(), "ERC721A: approve to caller");
2237 
2238         _operatorApprovals[_msgSender()][operator] = approved;
2239         emit ApprovalForAll(_msgSender(), operator, approved);
2240     }
2241 
2242     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2243         return _operatorApprovals[owner][operator];
2244     }
2245 
2246     function transferFrom(
2247         address from,
2248         address to,
2249         uint256 tokenId
2250     ) public virtual override onlyAllowedOperator(from){
2251         _transfer(from, to, tokenId);
2252     }
2253 
2254     function safeTransferFrom(
2255         address from,
2256         address to,
2257         uint256 tokenId
2258     ) public virtual override onlyAllowedOperator(from) {
2259         safeTransferFrom(from, to, tokenId, "");
2260     }
2261 
2262     function safeTransferFrom(
2263         address from,
2264         address to,
2265         uint256 tokenId,
2266         bytes memory _data
2267     ) public virtual override onlyAllowedOperator(from){
2268         _transfer(from, to, tokenId);
2269         require(
2270             _checkOnERC721Received(from, to, tokenId, _data),
2271             "ERC721A: transfer to non ERC721Receiver implementer"
2272         );
2273     }
2274 
2275     function _exists(uint256 tokenId) internal view returns (bool) {
2276         return tokenId < currentIndex;
2277     }
2278 
2279     function _safeMint(address to, uint256 quantity) internal {
2280         _safeMint(to, quantity, "");
2281     }
2282 
2283     function _safeMint(
2284         address to,
2285         uint256 quantity,
2286         bytes memory _data
2287     ) internal {
2288         _mint(to, quantity, _data, true);
2289     }
2290 
2291     function _mint(
2292         address to,
2293         uint256 quantity,
2294         bytes memory _data,
2295         bool safe
2296     ) internal {
2297         uint256 startTokenId = currentIndex;
2298         require(to != address(0), "ERC721A: mint to the zero address");
2299         require(quantity != 0, "ERC721A: quantity must be greater than 0");
2300 
2301         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2302 
2303         unchecked {
2304             _addressData[to].balance += uint128(quantity);
2305             _addressData[to].numberMinted += uint128(quantity);
2306 
2307             _ownerships[startTokenId].addr = to;
2308             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2309 
2310             uint256 updatedIndex = startTokenId;
2311 
2312             for (uint256 i; i < quantity; i++) {
2313                 emit Transfer(address(0), to, updatedIndex);
2314                 if (safe) {
2315                     require(
2316                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
2317                         "ERC721A: transfer to non ERC721Receiver implementer"
2318                     );
2319                 }
2320 
2321                 updatedIndex++;
2322             }
2323 
2324             currentIndex = updatedIndex;
2325         }
2326 
2327         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2328     }
2329  
2330     function _transfer(
2331         address from,
2332         address to,
2333         uint256 tokenId
2334     ) private {
2335         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2336 
2337         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
2338             getApproved(tokenId) == _msgSender() ||
2339             isApprovedForAll(prevOwnership.addr, _msgSender()));
2340 
2341         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
2342 
2343         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
2344         require(to != address(0), "ERC721A: transfer to the zero address");
2345 
2346         _beforeTokenTransfers(from, to, tokenId, 1);
2347 
2348         _approve(address(0), tokenId, prevOwnership.addr);
2349 
2350         
2351         unchecked {
2352             _addressData[from].balance -= 1;
2353             _addressData[to].balance += 1;
2354 
2355             _ownerships[tokenId].addr = to;
2356             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2357 
2358             uint256 nextTokenId = tokenId + 1;
2359             if (_ownerships[nextTokenId].addr == address(0)) {
2360                 if (_exists(nextTokenId)) {
2361                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2362                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2363                 }
2364             }
2365         }
2366 
2367         emit Transfer(from, to, tokenId);
2368         _afterTokenTransfers(from, to, tokenId, 1);
2369     }
2370 
2371     function _approve(
2372         address to,
2373         uint256 tokenId,
2374         address owner
2375     ) private {
2376         _tokenApprovals[tokenId] = to;
2377         emit Approval(owner, to, tokenId);
2378     }
2379 
2380     function _checkOnERC721Received(
2381         address from,
2382         address to,
2383         uint256 tokenId,
2384         bytes memory _data
2385     ) private returns (bool) {
2386         if (to.isContract()) {
2387             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2388                 return retval == IERC721Receiver(to).onERC721Received.selector;
2389             } catch (bytes memory reason) {
2390                 if (reason.length == 0) {
2391                     revert("ERC721A: transfer to non ERC721Receiver implementer");
2392                 } else {
2393                     assembly {
2394                         revert(add(32, reason), mload(reason))
2395                     }
2396                 }
2397             }
2398         } else {
2399             return true;
2400         }
2401     }
2402 
2403     function _beforeTokenTransfers(
2404         address from,
2405         address to,
2406         uint256 startTokenId,
2407         uint256 quantity
2408     ) internal virtual {}
2409 
2410     function _afterTokenTransfers(
2411         address from,
2412         address to,
2413         uint256 startTokenId,
2414         uint256 quantity
2415     ) internal virtual {}
2416 }
2417 
2418 
2419 /**
2420  * @dev Contract module which provides a basic access control mechanism, where
2421  * there is an account (an owner) that can be granted exclusive access to
2422  * specific functions.
2423  *
2424  * By default, the owner account will be the one that deploys the contract. This
2425  * can later be changed with {transferOwnership}.
2426  *
2427  * This module is used through inheritance. It will make available the modifier
2428  * `onlyOwner`, which can be applied to your functions to restrict their use to
2429  * the owner.
2430  */
2431 abstract contract Ownable is Context {
2432     address private _owner;
2433 
2434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2435 
2436     /**
2437      * @dev Initializes the contract setting the deployer as the initial owner.
2438      */
2439     constructor() {
2440         _transferOwnership(_msgSender());
2441     }
2442 
2443     /**
2444      * @dev Throws if called by any account other than the owner.
2445      */
2446     modifier onlyOwner() {
2447         _checkOwner();
2448         _;
2449     }
2450 
2451     /**
2452      * @dev Returns the address of the current owner.
2453      */
2454     function owner() public view virtual returns (address) {
2455         return _owner;
2456     }
2457 
2458     /**
2459      * @dev Throws if the sender is not the owner.
2460      */
2461     function _checkOwner() internal view virtual {
2462         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2463     }
2464 
2465     /**
2466      * @dev Leaves the contract without owner. It will not be possible to call
2467      * `onlyOwner` functions anymore. Can only be called by the current owner.
2468      *
2469      * NOTE: Renouncing ownership will leave the contract without an owner,
2470      * thereby removing any functionality that is only available to the owner.
2471      */
2472     function renounceOwnership() public virtual onlyOwner {
2473         _transferOwnership(address(0));
2474     }
2475 
2476     /**
2477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2478      * Can only be called by the current owner.
2479      */
2480     function transferOwnership(address newOwner) public virtual onlyOwner {
2481         require(newOwner != address(0), "Ownable: new owner is the zero address");
2482         _transferOwnership(newOwner);
2483     }
2484 
2485     /**
2486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2487      * Internal function without access restriction.
2488      */
2489     function _transferOwnership(address newOwner) internal virtual {
2490         address oldOwner = _owner;
2491         _owner = newOwner;
2492         emit OwnershipTransferred(oldOwner, newOwner);
2493     }
2494 }
2495 
2496 abstract contract Ownable2Step is Ownable {
2497     address private _pendingOwner;
2498 
2499     event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
2500 
2501     /**
2502      * @dev Returns the address of the pending owner.
2503      */
2504     function pendingOwner() public view virtual returns (address) {
2505         return _pendingOwner;
2506     }
2507 
2508     /**
2509      * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
2510      * Can only be called by the current owner.
2511      */
2512     function transferOwnership(address newOwner) public virtual override onlyOwner {
2513         _pendingOwner = newOwner;
2514         emit OwnershipTransferStarted(owner(), newOwner);
2515     }
2516 
2517     /**
2518      * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
2519      * Internal function without access restriction.
2520      */
2521     function _transferOwnership(address newOwner) internal virtual override {
2522         delete _pendingOwner;
2523         super._transferOwnership(newOwner);
2524     }
2525 
2526     /**
2527      * @dev The new owner accepts the ownership transfer.
2528      */
2529     function acceptOwnership() external {
2530         address sender = _msgSender();
2531         require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
2532         _transferOwnership(sender);
2533     }
2534 }
2535 
2536 contract OwnedRegistrant is Ownable2Step {
2537     address constant registry = 0x000000000000AAeB6D7670E522A718067333cd4E;
2538 
2539     constructor(address _owner) {
2540         IOperatorFilterRegistry(registry).register(address(this));
2541         transferOwnership(_owner);
2542     }
2543 }
2544 
2545 
2546 pragma solidity ^0.8.13;
2547 
2548 /**
2549  * @title  UpdatableOperatorFilterer
2550  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2551  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
2552  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
2553  *         which will bypass registry checks.
2554  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
2555  *         on-chain, eg, if the registry is revoked or bypassed.
2556  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2557  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2558  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2559  */
2560 abstract contract UpdatableOperatorFilterer {
2561     error OperatorNotAllowed(address operator);
2562     error OnlyOwner();
2563 
2564     IOperatorFilterRegistry public operatorFilterRegistry;
2565 
2566     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
2567         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
2568         operatorFilterRegistry = registry;
2569         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2570         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2571         // order for the modifier to filter addresses.
2572         if (address(registry).code.length > 0) {
2573             if (subscribe) {
2574                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2575             } else {
2576                 if (subscriptionOrRegistrantToCopy != address(0)) {
2577                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2578                 } else {
2579                     registry.register(address(this));
2580                 }
2581             }
2582         }
2583     }
2584 
2585     modifier onlyAllowedOperator(address from) virtual {
2586         // Allow spending tokens from addresses with balance
2587         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2588         // from an EOA.
2589         if (from != msg.sender) {
2590             _checkFilterOperator(msg.sender);
2591         }
2592         _;
2593     }
2594 
2595     modifier onlyAllowedOperatorApproval(address operator) virtual {
2596         _checkFilterOperator(operator);
2597         _;
2598     }
2599 
2600     /**
2601      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
2602      *         address, checks will be bypassed. OnlyOwner.
2603      */
2604     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
2605         if (msg.sender != owner()) {
2606             revert OnlyOwner();
2607         }
2608         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
2609     }
2610 
2611     /**
2612      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
2613      */
2614     function owner() public view virtual returns (address);
2615 
2616     function _checkFilterOperator(address operator) internal view virtual {
2617         IOperatorFilterRegistry registry = operatorFilterRegistry;
2618         // Check registry code length to facilitate testing in environments without a deployed registry.
2619         if (address(registry) != address(0) && address(registry).code.length > 0) {
2620             if (!registry.isOperatorAllowed(address(this), operator)) {
2621                 revert OperatorNotAllowed(operator);
2622             }
2623         }
2624     }
2625 }
2626 
2627 
2628 pragma solidity ^0.8.13;
2629 
2630 /**
2631  * @title  RevokableOperatorFilterer
2632  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
2633  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
2634  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
2635  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
2636  *         address cannot be further updated.
2637  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
2638  *         on-chain, eg, if the registry is revoked or bypassed.
2639  */
2640 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
2641     error RegistryHasBeenRevoked();
2642     error InitialRegistryAddressCannotBeZeroAddress();
2643 
2644     bool public isOperatorFilterRegistryRevoked;
2645 
2646     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
2647         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
2648     {
2649         // don't allow creating a contract with a permanently revoked registry
2650         if (_registry == address(0)) {
2651             revert InitialRegistryAddressCannotBeZeroAddress();
2652         }
2653     }
2654 
2655     function _checkFilterOperator(address operator) internal view virtual override {
2656         if (address(operatorFilterRegistry) != address(0)) {
2657             super._checkFilterOperator(operator);
2658         }
2659     }
2660 
2661     /**
2662      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
2663      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
2664      */
2665     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
2666         if (msg.sender != owner()) {
2667             revert OnlyOwner();
2668         }
2669         // if registry has been revoked, do not allow further updates
2670         if (isOperatorFilterRegistryRevoked) {
2671             revert RegistryHasBeenRevoked();
2672         }
2673 
2674         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
2675     }
2676 
2677     /**
2678      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
2679      */
2680     function revokeOperatorFilterRegistry() public {
2681         if (msg.sender != owner()) {
2682             revert OnlyOwner();
2683         }
2684         // if registry has been revoked, do not allow further updates
2685         if (isOperatorFilterRegistryRevoked) {
2686             revert RegistryHasBeenRevoked();
2687         }
2688 
2689         // set to zero address to bypass checks
2690         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
2691         isOperatorFilterRegistryRevoked = true;
2692     }
2693 }
2694 
2695 pragma solidity ^0.8.13;
2696 
2697 /**
2698  * @title  RevokableDefaultOperatorFilterer
2699  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
2700  *         Note that OpenSea will disable creator fee enforcement if filtered operators begin fulfilling orders
2701  *         on-chain, eg, if the registry is revoked or bypassed.
2702  */
2703 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
2704     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2705 
2706     constructor() RevokableOperatorFilterer(0x000000000000AAeB6D7670E522A718067333cd4E, DEFAULT_SUBSCRIPTION, true) {}
2707 }
2708 
2709 
2710 pragma solidity ^0.8.9;
2711 
2712 contract DeApes is ERC721A, Ownable, ReentrancyGuard {
2713     using Strings for uint256;
2714     
2715     uint   private _totalStake;
2716     address private _bozoContract; 
2717     uint   public price             = 0.005 ether;
2718     uint   public maxTx          = 20;
2719     uint   public maxSupply          = 5000;
2720     uint256 public reservedSupply = 10;
2721     string private baseURI;
2722     bool   public mintLive;  
2723     uint   public maxFreePerWallet        = 1;
2724     uint   public freeMinted = 0;
2725     uint   public totalFreeAvailable = 5000;
2726     
2727     mapping(address => uint256) public _senderFreeMinted;
2728 
2729     constructor() ERC721A("DeApes", "DA") {}
2730 
2731     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2732         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
2733         string memory currentBaseURI = _baseURI();
2734         return bytes(currentBaseURI).length > 0
2735             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
2736             : "";
2737     }
2738 
2739     function _baseURI() internal view virtual override returns (string memory) {
2740         return baseURI;
2741     }
2742 
2743     function mint(uint256 amount) external payable {
2744         
2745         if ((freeMinted < totalFreeAvailable) && (_senderFreeMinted[msg.sender] < maxFreePerWallet)) { 
2746             require(mintLive, "not live yet");
2747             require(msg.value >= (amount * price) - price, "Eth Amount Invalid");
2748             require(totalSupply() + amount <= maxSupply, "No more supply");
2749             require(amount <= maxTx, "Max per TX reached.");
2750             _senderFreeMinted[msg.sender] = maxFreePerWallet;
2751             freeMinted += maxFreePerWallet;   
2752         }
2753         else{
2754             require(mintLive, "not live yet");
2755             require(msg.value >= amount * price, "Eth Amount Invalid");
2756             require(totalSupply() + amount <= maxSupply, "No more supply");
2757             require(amount <= maxTx, "Max per TX reached.");
2758         }
2759 
2760         _safeMint(msg.sender, amount);
2761     }
2762 
2763     function reservedMint(uint256 Amount) external onlyOwner
2764     {
2765         uint256 Remaining = reservedSupply;
2766 
2767         require(totalSupply() + Amount <= maxSupply, "No more supply to be minted");
2768         require(Remaining >= Amount, "Reserved Supply Minted");
2769     
2770         reservedSupply = Remaining - Amount;
2771         _safeMint(msg.sender, Amount);
2772     }
2773 
2774     function enableMinting() external onlyOwner {
2775       mintLive = !mintLive;
2776     }
2777 
2778    function setBaseUri(string memory baseuri_) public onlyOwner {
2779         baseURI = baseuri_;
2780     }
2781 
2782     function setCost(uint256 price_) external onlyOwner {
2783         price = price_;
2784     }
2785 
2786     function costInspect() public view returns (uint256) {
2787         return price;
2788     }
2789 
2790      function setmaxTx(uint256 _MaxTx) external onlyOwner {
2791         maxTx = _MaxTx;
2792     }
2793 
2794     function setMaxTotalFreeAvailable(uint256 MaxTotalFree_) external onlyOwner {
2795         totalFreeAvailable = MaxTotalFree_;
2796     }
2797 
2798     function setmaxFreePerWallet(uint256 maxFreePerWallet_) external onlyOwner {
2799         maxFreePerWallet = maxFreePerWallet_;
2800     }
2801 
2802     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2803         super.setApprovalForAll(operator, approved);
2804     }
2805 
2806     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2807         super.approve(operator, tokenId);
2808     }
2809 
2810     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2811         super.transferFrom(from, to, tokenId);
2812     }
2813 
2814     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2815         super.safeTransferFrom(from, to, tokenId);
2816     }
2817 
2818     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2819         public
2820         override
2821         onlyAllowedOperator(from)
2822     {
2823         super.safeTransferFrom(from, to, tokenId, data);
2824     }
2825 
2826     function withdraw() external onlyOwner nonReentrant {
2827         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2828         require(success, "Transfer failed.");
2829     }
2830 }