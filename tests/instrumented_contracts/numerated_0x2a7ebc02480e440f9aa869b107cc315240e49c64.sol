1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 // File: operator-filter-registry/src/UpdatableOperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  UpdatableOperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
44  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
45  *         which will bypass registry checks.
46  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
47  *         on-chain, eg, if the registry is revoked or bypassed.
48  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
49  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
50  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
51  */
52 abstract contract UpdatableOperatorFilterer {
53     error OperatorNotAllowed(address operator);
54     error OnlyOwner();
55 
56     IOperatorFilterRegistry public operatorFilterRegistry;
57 
58     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
59         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
60         operatorFilterRegistry = registry;
61         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
62         // will not revert, but the contract will need to be registered with the registry once it is deployed in
63         // order for the modifier to filter addresses.
64         if (address(registry).code.length > 0) {
65             if (subscribe) {
66                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
67             } else {
68                 if (subscriptionOrRegistrantToCopy != address(0)) {
69                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
70                 } else {
71                     registry.register(address(this));
72                 }
73             }
74         }
75     }
76 
77     modifier onlyAllowedOperator(address from) virtual {
78         // Allow spending tokens from addresses with balance
79         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
80         // from an EOA.
81         if (from != msg.sender) {
82             _checkFilterOperator(msg.sender);
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         _checkFilterOperator(operator);
89         _;
90     }
91 
92     /**
93      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
94      *         address, checks will be bypassed. OnlyOwner.
95      */
96     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
97         if (msg.sender != owner()) {
98             revert OnlyOwner();
99         }
100         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
101     }
102 
103     /**
104      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
105      */
106     function owner() public view virtual returns (address);
107 
108     function _checkFilterOperator(address operator) internal view virtual {
109         IOperatorFilterRegistry registry = operatorFilterRegistry;
110         // Check registry code length to facilitate testing in environments without a deployed registry.
111         if (address(registry) != address(0) && address(registry).code.length > 0) {
112             if (!registry.isOperatorAllowed(address(this), operator)) {
113                 revert OperatorNotAllowed(operator);
114             }
115         }
116     }
117 }
118 
119 // File: operator-filter-registry/src/RevokableOperatorFilterer.sol
120 
121 
122 pragma solidity ^0.8.13;
123 
124 
125 
126 /**
127  * @title  RevokableOperatorFilterer
128  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
129  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
130  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
131  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
132  *         address cannot be further updated.
133  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
134  *         on-chain, eg, if the registry is revoked or bypassed.
135  */
136 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
137     error RegistryHasBeenRevoked();
138     error InitialRegistryAddressCannotBeZeroAddress();
139 
140     bool public isOperatorFilterRegistryRevoked;
141 
142     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
143         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
144     {
145         // don't allow creating a contract with a permanently revoked registry
146         if (_registry == address(0)) {
147             revert InitialRegistryAddressCannotBeZeroAddress();
148         }
149     }
150 
151     function _checkFilterOperator(address operator) internal view virtual override {
152         if (address(operatorFilterRegistry) != address(0)) {
153             super._checkFilterOperator(operator);
154         }
155     }
156 
157     /**
158      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
159      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
160      */
161     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
162         if (msg.sender != owner()) {
163             revert OnlyOwner();
164         }
165         // if registry has been revoked, do not allow further updates
166         if (isOperatorFilterRegistryRevoked) {
167             revert RegistryHasBeenRevoked();
168         }
169 
170         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
171     }
172 
173     /**
174      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
175      */
176     function revokeOperatorFilterRegistry() public {
177         if (msg.sender != owner()) {
178             revert OnlyOwner();
179         }
180         // if registry has been revoked, do not allow further updates
181         if (isOperatorFilterRegistryRevoked) {
182             revert RegistryHasBeenRevoked();
183         }
184 
185         // set to zero address to bypass checks
186         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
187         isOperatorFilterRegistryRevoked = true;
188     }
189 }
190 
191 // File: operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol
192 
193 
194 pragma solidity ^0.8.13;
195 
196 
197 /**
198  * @title  RevokableDefaultOperatorFilterer
199  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
200  *         Note that OpenSea will disable creator fee enforcement if filtered operators begin fulfilling orders
201  *         on-chain, eg, if the registry is revoked or bypassed.
202  */
203 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
204     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
205 
206     constructor() RevokableOperatorFilterer(0x000000000000AAeB6D7670E522A718067333cd4E, DEFAULT_SUBSCRIPTION, true) {}
207 }
208 
209 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
210 
211 
212 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
213 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Library for managing
219  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
220  * types.
221  *
222  * Sets have the following properties:
223  *
224  * - Elements are added, removed, and checked for existence in constant time
225  * (O(1)).
226  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
227  *
228  * ```
229  * contract Example {
230  *     // Add the library methods
231  *     using EnumerableSet for EnumerableSet.AddressSet;
232  *
233  *     // Declare a set state variable
234  *     EnumerableSet.AddressSet private mySet;
235  * }
236  * ```
237  *
238  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
239  * and `uint256` (`UintSet`) are supported.
240  *
241  * [WARNING]
242  * ====
243  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
244  * unusable.
245  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
246  *
247  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
248  * array of EnumerableSet.
249  * ====
250  */
251 library EnumerableSet {
252     // To implement this library for multiple types with as little code
253     // repetition as possible, we write it in terms of a generic Set type with
254     // bytes32 values.
255     // The Set implementation uses private functions, and user-facing
256     // implementations (such as AddressSet) are just wrappers around the
257     // underlying Set.
258     // This means that we can only create new EnumerableSets for types that fit
259     // in bytes32.
260 
261     struct Set {
262         // Storage of set values
263         bytes32[] _values;
264         // Position of the value in the `values` array, plus 1 because index 0
265         // means a value is not in the set.
266         mapping(bytes32 => uint256) _indexes;
267     }
268 
269     /**
270      * @dev Add a value to a set. O(1).
271      *
272      * Returns true if the value was added to the set, that is if it was not
273      * already present.
274      */
275     function _add(Set storage set, bytes32 value) private returns (bool) {
276         if (!_contains(set, value)) {
277             set._values.push(value);
278             // The value is stored at length-1, but we add 1 to all indexes
279             // and use 0 as a sentinel value
280             set._indexes[value] = set._values.length;
281             return true;
282         } else {
283             return false;
284         }
285     }
286 
287     /**
288      * @dev Removes a value from a set. O(1).
289      *
290      * Returns true if the value was removed from the set, that is if it was
291      * present.
292      */
293     function _remove(Set storage set, bytes32 value) private returns (bool) {
294         // We read and store the value's index to prevent multiple reads from the same storage slot
295         uint256 valueIndex = set._indexes[value];
296 
297         if (valueIndex != 0) {
298             // Equivalent to contains(set, value)
299             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
300             // the array, and then remove the last element (sometimes called as 'swap and pop').
301             // This modifies the order of the array, as noted in {at}.
302 
303             uint256 toDeleteIndex = valueIndex - 1;
304             uint256 lastIndex = set._values.length - 1;
305 
306             if (lastIndex != toDeleteIndex) {
307                 bytes32 lastValue = set._values[lastIndex];
308 
309                 // Move the last value to the index where the value to delete is
310                 set._values[toDeleteIndex] = lastValue;
311                 // Update the index for the moved value
312                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
313             }
314 
315             // Delete the slot where the moved value was stored
316             set._values.pop();
317 
318             // Delete the index for the deleted slot
319             delete set._indexes[value];
320 
321             return true;
322         } else {
323             return false;
324         }
325     }
326 
327     /**
328      * @dev Returns true if the value is in the set. O(1).
329      */
330     function _contains(Set storage set, bytes32 value) private view returns (bool) {
331         return set._indexes[value] != 0;
332     }
333 
334     /**
335      * @dev Returns the number of values on the set. O(1).
336      */
337     function _length(Set storage set) private view returns (uint256) {
338         return set._values.length;
339     }
340 
341     /**
342      * @dev Returns the value stored at position `index` in the set. O(1).
343      *
344      * Note that there are no guarantees on the ordering of values inside the
345      * array, and it may change when more values are added or removed.
346      *
347      * Requirements:
348      *
349      * - `index` must be strictly less than {length}.
350      */
351     function _at(Set storage set, uint256 index) private view returns (bytes32) {
352         return set._values[index];
353     }
354 
355     /**
356      * @dev Return the entire set in an array
357      *
358      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
359      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
360      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
361      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
362      */
363     function _values(Set storage set) private view returns (bytes32[] memory) {
364         return set._values;
365     }
366 
367     // Bytes32Set
368 
369     struct Bytes32Set {
370         Set _inner;
371     }
372 
373     /**
374      * @dev Add a value to a set. O(1).
375      *
376      * Returns true if the value was added to the set, that is if it was not
377      * already present.
378      */
379     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
380         return _add(set._inner, value);
381     }
382 
383     /**
384      * @dev Removes a value from a set. O(1).
385      *
386      * Returns true if the value was removed from the set, that is if it was
387      * present.
388      */
389     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
390         return _remove(set._inner, value);
391     }
392 
393     /**
394      * @dev Returns true if the value is in the set. O(1).
395      */
396     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
397         return _contains(set._inner, value);
398     }
399 
400     /**
401      * @dev Returns the number of values in the set. O(1).
402      */
403     function length(Bytes32Set storage set) internal view returns (uint256) {
404         return _length(set._inner);
405     }
406 
407     /**
408      * @dev Returns the value stored at position `index` in the set. O(1).
409      *
410      * Note that there are no guarantees on the ordering of values inside the
411      * array, and it may change when more values are added or removed.
412      *
413      * Requirements:
414      *
415      * - `index` must be strictly less than {length}.
416      */
417     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
418         return _at(set._inner, index);
419     }
420 
421     /**
422      * @dev Return the entire set in an array
423      *
424      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
425      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
426      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
427      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
428      */
429     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
430         bytes32[] memory store = _values(set._inner);
431         bytes32[] memory result;
432 
433         /// @solidity memory-safe-assembly
434         assembly {
435             result := store
436         }
437 
438         return result;
439     }
440 
441     // AddressSet
442 
443     struct AddressSet {
444         Set _inner;
445     }
446 
447     /**
448      * @dev Add a value to a set. O(1).
449      *
450      * Returns true if the value was added to the set, that is if it was not
451      * already present.
452      */
453     function add(AddressSet storage set, address value) internal returns (bool) {
454         return _add(set._inner, bytes32(uint256(uint160(value))));
455     }
456 
457     /**
458      * @dev Removes a value from a set. O(1).
459      *
460      * Returns true if the value was removed from the set, that is if it was
461      * present.
462      */
463     function remove(AddressSet storage set, address value) internal returns (bool) {
464         return _remove(set._inner, bytes32(uint256(uint160(value))));
465     }
466 
467     /**
468      * @dev Returns true if the value is in the set. O(1).
469      */
470     function contains(AddressSet storage set, address value) internal view returns (bool) {
471         return _contains(set._inner, bytes32(uint256(uint160(value))));
472     }
473 
474     /**
475      * @dev Returns the number of values in the set. O(1).
476      */
477     function length(AddressSet storage set) internal view returns (uint256) {
478         return _length(set._inner);
479     }
480 
481     /**
482      * @dev Returns the value stored at position `index` in the set. O(1).
483      *
484      * Note that there are no guarantees on the ordering of values inside the
485      * array, and it may change when more values are added or removed.
486      *
487      * Requirements:
488      *
489      * - `index` must be strictly less than {length}.
490      */
491     function at(AddressSet storage set, uint256 index) internal view returns (address) {
492         return address(uint160(uint256(_at(set._inner, index))));
493     }
494 
495     /**
496      * @dev Return the entire set in an array
497      *
498      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
499      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
500      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
501      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
502      */
503     function values(AddressSet storage set) internal view returns (address[] memory) {
504         bytes32[] memory store = _values(set._inner);
505         address[] memory result;
506 
507         /// @solidity memory-safe-assembly
508         assembly {
509             result := store
510         }
511 
512         return result;
513     }
514 
515     // UintSet
516 
517     struct UintSet {
518         Set _inner;
519     }
520 
521     /**
522      * @dev Add a value to a set. O(1).
523      *
524      * Returns true if the value was added to the set, that is if it was not
525      * already present.
526      */
527     function add(UintSet storage set, uint256 value) internal returns (bool) {
528         return _add(set._inner, bytes32(value));
529     }
530 
531     /**
532      * @dev Removes a value from a set. O(1).
533      *
534      * Returns true if the value was removed from the set, that is if it was
535      * present.
536      */
537     function remove(UintSet storage set, uint256 value) internal returns (bool) {
538         return _remove(set._inner, bytes32(value));
539     }
540 
541     /**
542      * @dev Returns true if the value is in the set. O(1).
543      */
544     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
545         return _contains(set._inner, bytes32(value));
546     }
547 
548     /**
549      * @dev Returns the number of values in the set. O(1).
550      */
551     function length(UintSet storage set) internal view returns (uint256) {
552         return _length(set._inner);
553     }
554 
555     /**
556      * @dev Returns the value stored at position `index` in the set. O(1).
557      *
558      * Note that there are no guarantees on the ordering of values inside the
559      * array, and it may change when more values are added or removed.
560      *
561      * Requirements:
562      *
563      * - `index` must be strictly less than {length}.
564      */
565     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
566         return uint256(_at(set._inner, index));
567     }
568 
569     /**
570      * @dev Return the entire set in an array
571      *
572      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
573      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
574      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
575      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
576      */
577     function values(UintSet storage set) internal view returns (uint256[] memory) {
578         bytes32[] memory store = _values(set._inner);
579         uint256[] memory result;
580 
581         /// @solidity memory-safe-assembly
582         assembly {
583             result := store
584         }
585 
586         return result;
587     }
588 }
589 
590 // File: contract-allow-list/contracts/proxy/interface/IContractAllowListProxy.sol
591 
592 
593 pragma solidity >=0.7.0 <0.9.0;
594 
595 interface IContractAllowListProxy {
596     function isAllowed(address _transferer, uint256 _level)
597         external
598         view
599         returns (bool);
600 }
601 
602 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
603 
604 
605 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev These functions deal with verification of Merkle Tree proofs.
611  *
612  * The tree and the proofs can be generated using our
613  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
614  * You will find a quickstart guide in the readme.
615  *
616  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
617  * hashing, or use a hash function other than keccak256 for hashing leaves.
618  * This is because the concatenation of a sorted pair of internal nodes in
619  * the merkle tree could be reinterpreted as a leaf value.
620  * OpenZeppelin's JavaScript library generates merkle trees that are safe
621  * against this attack out of the box.
622  */
623 library MerkleProof {
624     /**
625      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
626      * defined by `root`. For this, a `proof` must be provided, containing
627      * sibling hashes on the branch from the leaf to the root of the tree. Each
628      * pair of leaves and each pair of pre-images are assumed to be sorted.
629      */
630     function verify(
631         bytes32[] memory proof,
632         bytes32 root,
633         bytes32 leaf
634     ) internal pure returns (bool) {
635         return processProof(proof, leaf) == root;
636     }
637 
638     /**
639      * @dev Calldata version of {verify}
640      *
641      * _Available since v4.7._
642      */
643     function verifyCalldata(
644         bytes32[] calldata proof,
645         bytes32 root,
646         bytes32 leaf
647     ) internal pure returns (bool) {
648         return processProofCalldata(proof, leaf) == root;
649     }
650 
651     /**
652      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
653      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
654      * hash matches the root of the tree. When processing the proof, the pairs
655      * of leafs & pre-images are assumed to be sorted.
656      *
657      * _Available since v4.4._
658      */
659     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
660         bytes32 computedHash = leaf;
661         for (uint256 i = 0; i < proof.length; i++) {
662             computedHash = _hashPair(computedHash, proof[i]);
663         }
664         return computedHash;
665     }
666 
667     /**
668      * @dev Calldata version of {processProof}
669      *
670      * _Available since v4.7._
671      */
672     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
673         bytes32 computedHash = leaf;
674         for (uint256 i = 0; i < proof.length; i++) {
675             computedHash = _hashPair(computedHash, proof[i]);
676         }
677         return computedHash;
678     }
679 
680     /**
681      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
682      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
683      *
684      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
685      *
686      * _Available since v4.7._
687      */
688     function multiProofVerify(
689         bytes32[] memory proof,
690         bool[] memory proofFlags,
691         bytes32 root,
692         bytes32[] memory leaves
693     ) internal pure returns (bool) {
694         return processMultiProof(proof, proofFlags, leaves) == root;
695     }
696 
697     /**
698      * @dev Calldata version of {multiProofVerify}
699      *
700      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
701      *
702      * _Available since v4.7._
703      */
704     function multiProofVerifyCalldata(
705         bytes32[] calldata proof,
706         bool[] calldata proofFlags,
707         bytes32 root,
708         bytes32[] memory leaves
709     ) internal pure returns (bool) {
710         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
711     }
712 
713     /**
714      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
715      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
716      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
717      * respectively.
718      *
719      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
720      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
721      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
722      *
723      * _Available since v4.7._
724      */
725     function processMultiProof(
726         bytes32[] memory proof,
727         bool[] memory proofFlags,
728         bytes32[] memory leaves
729     ) internal pure returns (bytes32 merkleRoot) {
730         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
731         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
732         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
733         // the merkle tree.
734         uint256 leavesLen = leaves.length;
735         uint256 totalHashes = proofFlags.length;
736 
737         // Check proof validity.
738         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
739 
740         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
741         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
742         bytes32[] memory hashes = new bytes32[](totalHashes);
743         uint256 leafPos = 0;
744         uint256 hashPos = 0;
745         uint256 proofPos = 0;
746         // At each step, we compute the next hash using two values:
747         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
748         //   get the next hash.
749         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
750         //   `proof` array.
751         for (uint256 i = 0; i < totalHashes; i++) {
752             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
753             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
754             hashes[i] = _hashPair(a, b);
755         }
756 
757         if (totalHashes > 0) {
758             return hashes[totalHashes - 1];
759         } else if (leavesLen > 0) {
760             return leaves[0];
761         } else {
762             return proof[0];
763         }
764     }
765 
766     /**
767      * @dev Calldata version of {processMultiProof}.
768      *
769      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
770      *
771      * _Available since v4.7._
772      */
773     function processMultiProofCalldata(
774         bytes32[] calldata proof,
775         bool[] calldata proofFlags,
776         bytes32[] memory leaves
777     ) internal pure returns (bytes32 merkleRoot) {
778         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
779         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
780         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
781         // the merkle tree.
782         uint256 leavesLen = leaves.length;
783         uint256 totalHashes = proofFlags.length;
784 
785         // Check proof validity.
786         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
787 
788         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
789         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
790         bytes32[] memory hashes = new bytes32[](totalHashes);
791         uint256 leafPos = 0;
792         uint256 hashPos = 0;
793         uint256 proofPos = 0;
794         // At each step, we compute the next hash using two values:
795         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
796         //   get the next hash.
797         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
798         //   `proof` array.
799         for (uint256 i = 0; i < totalHashes; i++) {
800             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
801             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
802             hashes[i] = _hashPair(a, b);
803         }
804 
805         if (totalHashes > 0) {
806             return hashes[totalHashes - 1];
807         } else if (leavesLen > 0) {
808             return leaves[0];
809         } else {
810             return proof[0];
811         }
812     }
813 
814     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
815         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
816     }
817 
818     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
819         /// @solidity memory-safe-assembly
820         assembly {
821             mstore(0x00, a)
822             mstore(0x20, b)
823             value := keccak256(0x00, 0x40)
824         }
825     }
826 }
827 
828 // File: @openzeppelin/contracts/utils/math/Math.sol
829 
830 
831 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 /**
836  * @dev Standard math utilities missing in the Solidity language.
837  */
838 library Math {
839     enum Rounding {
840         Down, // Toward negative infinity
841         Up, // Toward infinity
842         Zero // Toward zero
843     }
844 
845     /**
846      * @dev Returns the largest of two numbers.
847      */
848     function max(uint256 a, uint256 b) internal pure returns (uint256) {
849         return a > b ? a : b;
850     }
851 
852     /**
853      * @dev Returns the smallest of two numbers.
854      */
855     function min(uint256 a, uint256 b) internal pure returns (uint256) {
856         return a < b ? a : b;
857     }
858 
859     /**
860      * @dev Returns the average of two numbers. The result is rounded towards
861      * zero.
862      */
863     function average(uint256 a, uint256 b) internal pure returns (uint256) {
864         // (a + b) / 2 can overflow.
865         return (a & b) + (a ^ b) / 2;
866     }
867 
868     /**
869      * @dev Returns the ceiling of the division of two numbers.
870      *
871      * This differs from standard division with `/` in that it rounds up instead
872      * of rounding down.
873      */
874     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
875         // (a + b - 1) / b can overflow on addition, so we distribute.
876         return a == 0 ? 0 : (a - 1) / b + 1;
877     }
878 
879     /**
880      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
881      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
882      * with further edits by Uniswap Labs also under MIT license.
883      */
884     function mulDiv(
885         uint256 x,
886         uint256 y,
887         uint256 denominator
888     ) internal pure returns (uint256 result) {
889         unchecked {
890             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
891             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
892             // variables such that product = prod1 * 2^256 + prod0.
893             uint256 prod0; // Least significant 256 bits of the product
894             uint256 prod1; // Most significant 256 bits of the product
895             assembly {
896                 let mm := mulmod(x, y, not(0))
897                 prod0 := mul(x, y)
898                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
899             }
900 
901             // Handle non-overflow cases, 256 by 256 division.
902             if (prod1 == 0) {
903                 return prod0 / denominator;
904             }
905 
906             // Make sure the result is less than 2^256. Also prevents denominator == 0.
907             require(denominator > prod1);
908 
909             ///////////////////////////////////////////////
910             // 512 by 256 division.
911             ///////////////////////////////////////////////
912 
913             // Make division exact by subtracting the remainder from [prod1 prod0].
914             uint256 remainder;
915             assembly {
916                 // Compute remainder using mulmod.
917                 remainder := mulmod(x, y, denominator)
918 
919                 // Subtract 256 bit number from 512 bit number.
920                 prod1 := sub(prod1, gt(remainder, prod0))
921                 prod0 := sub(prod0, remainder)
922             }
923 
924             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
925             // See https://cs.stackexchange.com/q/138556/92363.
926 
927             // Does not overflow because the denominator cannot be zero at this stage in the function.
928             uint256 twos = denominator & (~denominator + 1);
929             assembly {
930                 // Divide denominator by twos.
931                 denominator := div(denominator, twos)
932 
933                 // Divide [prod1 prod0] by twos.
934                 prod0 := div(prod0, twos)
935 
936                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
937                 twos := add(div(sub(0, twos), twos), 1)
938             }
939 
940             // Shift in bits from prod1 into prod0.
941             prod0 |= prod1 * twos;
942 
943             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
944             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
945             // four bits. That is, denominator * inv = 1 mod 2^4.
946             uint256 inverse = (3 * denominator) ^ 2;
947 
948             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
949             // in modular arithmetic, doubling the correct bits in each step.
950             inverse *= 2 - denominator * inverse; // inverse mod 2^8
951             inverse *= 2 - denominator * inverse; // inverse mod 2^16
952             inverse *= 2 - denominator * inverse; // inverse mod 2^32
953             inverse *= 2 - denominator * inverse; // inverse mod 2^64
954             inverse *= 2 - denominator * inverse; // inverse mod 2^128
955             inverse *= 2 - denominator * inverse; // inverse mod 2^256
956 
957             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
958             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
959             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
960             // is no longer required.
961             result = prod0 * inverse;
962             return result;
963         }
964     }
965 
966     /**
967      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
968      */
969     function mulDiv(
970         uint256 x,
971         uint256 y,
972         uint256 denominator,
973         Rounding rounding
974     ) internal pure returns (uint256) {
975         uint256 result = mulDiv(x, y, denominator);
976         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
977             result += 1;
978         }
979         return result;
980     }
981 
982     /**
983      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
984      *
985      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
986      */
987     function sqrt(uint256 a) internal pure returns (uint256) {
988         if (a == 0) {
989             return 0;
990         }
991 
992         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
993         //
994         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
995         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
996         //
997         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
998         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
999         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1000         //
1001         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1002         uint256 result = 1 << (log2(a) >> 1);
1003 
1004         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1005         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1006         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1007         // into the expected uint128 result.
1008         unchecked {
1009             result = (result + a / result) >> 1;
1010             result = (result + a / result) >> 1;
1011             result = (result + a / result) >> 1;
1012             result = (result + a / result) >> 1;
1013             result = (result + a / result) >> 1;
1014             result = (result + a / result) >> 1;
1015             result = (result + a / result) >> 1;
1016             return min(result, a / result);
1017         }
1018     }
1019 
1020     /**
1021      * @notice Calculates sqrt(a), following the selected rounding direction.
1022      */
1023     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1024         unchecked {
1025             uint256 result = sqrt(a);
1026             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1027         }
1028     }
1029 
1030     /**
1031      * @dev Return the log in base 2, rounded down, of a positive value.
1032      * Returns 0 if given 0.
1033      */
1034     function log2(uint256 value) internal pure returns (uint256) {
1035         uint256 result = 0;
1036         unchecked {
1037             if (value >> 128 > 0) {
1038                 value >>= 128;
1039                 result += 128;
1040             }
1041             if (value >> 64 > 0) {
1042                 value >>= 64;
1043                 result += 64;
1044             }
1045             if (value >> 32 > 0) {
1046                 value >>= 32;
1047                 result += 32;
1048             }
1049             if (value >> 16 > 0) {
1050                 value >>= 16;
1051                 result += 16;
1052             }
1053             if (value >> 8 > 0) {
1054                 value >>= 8;
1055                 result += 8;
1056             }
1057             if (value >> 4 > 0) {
1058                 value >>= 4;
1059                 result += 4;
1060             }
1061             if (value >> 2 > 0) {
1062                 value >>= 2;
1063                 result += 2;
1064             }
1065             if (value >> 1 > 0) {
1066                 result += 1;
1067             }
1068         }
1069         return result;
1070     }
1071 
1072     /**
1073      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1074      * Returns 0 if given 0.
1075      */
1076     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1077         unchecked {
1078             uint256 result = log2(value);
1079             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1080         }
1081     }
1082 
1083     /**
1084      * @dev Return the log in base 10, rounded down, of a positive value.
1085      * Returns 0 if given 0.
1086      */
1087     function log10(uint256 value) internal pure returns (uint256) {
1088         uint256 result = 0;
1089         unchecked {
1090             if (value >= 10**64) {
1091                 value /= 10**64;
1092                 result += 64;
1093             }
1094             if (value >= 10**32) {
1095                 value /= 10**32;
1096                 result += 32;
1097             }
1098             if (value >= 10**16) {
1099                 value /= 10**16;
1100                 result += 16;
1101             }
1102             if (value >= 10**8) {
1103                 value /= 10**8;
1104                 result += 8;
1105             }
1106             if (value >= 10**4) {
1107                 value /= 10**4;
1108                 result += 4;
1109             }
1110             if (value >= 10**2) {
1111                 value /= 10**2;
1112                 result += 2;
1113             }
1114             if (value >= 10**1) {
1115                 result += 1;
1116             }
1117         }
1118         return result;
1119     }
1120 
1121     /**
1122      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1123      * Returns 0 if given 0.
1124      */
1125     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1126         unchecked {
1127             uint256 result = log10(value);
1128             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1129         }
1130     }
1131 
1132     /**
1133      * @dev Return the log in base 256, rounded down, of a positive value.
1134      * Returns 0 if given 0.
1135      *
1136      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1137      */
1138     function log256(uint256 value) internal pure returns (uint256) {
1139         uint256 result = 0;
1140         unchecked {
1141             if (value >> 128 > 0) {
1142                 value >>= 128;
1143                 result += 16;
1144             }
1145             if (value >> 64 > 0) {
1146                 value >>= 64;
1147                 result += 8;
1148             }
1149             if (value >> 32 > 0) {
1150                 value >>= 32;
1151                 result += 4;
1152             }
1153             if (value >> 16 > 0) {
1154                 value >>= 16;
1155                 result += 2;
1156             }
1157             if (value >> 8 > 0) {
1158                 result += 1;
1159             }
1160         }
1161         return result;
1162     }
1163 
1164     /**
1165      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1166      * Returns 0 if given 0.
1167      */
1168     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1169         unchecked {
1170             uint256 result = log256(value);
1171             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1172         }
1173     }
1174 }
1175 
1176 // File: @openzeppelin/contracts/utils/Strings.sol
1177 
1178 
1179 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 
1184 /**
1185  * @dev String operations.
1186  */
1187 library Strings {
1188     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1189     uint8 private constant _ADDRESS_LENGTH = 20;
1190 
1191     /**
1192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1193      */
1194     function toString(uint256 value) internal pure returns (string memory) {
1195         unchecked {
1196             uint256 length = Math.log10(value) + 1;
1197             string memory buffer = new string(length);
1198             uint256 ptr;
1199             /// @solidity memory-safe-assembly
1200             assembly {
1201                 ptr := add(buffer, add(32, length))
1202             }
1203             while (true) {
1204                 ptr--;
1205                 /// @solidity memory-safe-assembly
1206                 assembly {
1207                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1208                 }
1209                 value /= 10;
1210                 if (value == 0) break;
1211             }
1212             return buffer;
1213         }
1214     }
1215 
1216     /**
1217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1218      */
1219     function toHexString(uint256 value) internal pure returns (string memory) {
1220         unchecked {
1221             return toHexString(value, Math.log256(value) + 1);
1222         }
1223     }
1224 
1225     /**
1226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1227      */
1228     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1229         bytes memory buffer = new bytes(2 * length + 2);
1230         buffer[0] = "0";
1231         buffer[1] = "x";
1232         for (uint256 i = 2 * length + 1; i > 1; --i) {
1233             buffer[i] = _SYMBOLS[value & 0xf];
1234             value >>= 4;
1235         }
1236         require(value == 0, "Strings: hex length insufficient");
1237         return string(buffer);
1238     }
1239 
1240     /**
1241      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1242      */
1243     function toHexString(address addr) internal pure returns (string memory) {
1244         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1245     }
1246 }
1247 
1248 // File: @openzeppelin/contracts/access/IAccessControl.sol
1249 
1250 
1251 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 /**
1256  * @dev External interface of AccessControl declared to support ERC165 detection.
1257  */
1258 interface IAccessControl {
1259     /**
1260      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1261      *
1262      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1263      * {RoleAdminChanged} not being emitted signaling this.
1264      *
1265      * _Available since v3.1._
1266      */
1267     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1268 
1269     /**
1270      * @dev Emitted when `account` is granted `role`.
1271      *
1272      * `sender` is the account that originated the contract call, an admin role
1273      * bearer except when using {AccessControl-_setupRole}.
1274      */
1275     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1276 
1277     /**
1278      * @dev Emitted when `account` is revoked `role`.
1279      *
1280      * `sender` is the account that originated the contract call:
1281      *   - if using `revokeRole`, it is the admin role bearer
1282      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1283      */
1284     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1285 
1286     /**
1287      * @dev Returns `true` if `account` has been granted `role`.
1288      */
1289     function hasRole(bytes32 role, address account) external view returns (bool);
1290 
1291     /**
1292      * @dev Returns the admin role that controls `role`. See {grantRole} and
1293      * {revokeRole}.
1294      *
1295      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1296      */
1297     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1298 
1299     /**
1300      * @dev Grants `role` to `account`.
1301      *
1302      * If `account` had not been already granted `role`, emits a {RoleGranted}
1303      * event.
1304      *
1305      * Requirements:
1306      *
1307      * - the caller must have ``role``'s admin role.
1308      */
1309     function grantRole(bytes32 role, address account) external;
1310 
1311     /**
1312      * @dev Revokes `role` from `account`.
1313      *
1314      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1315      *
1316      * Requirements:
1317      *
1318      * - the caller must have ``role``'s admin role.
1319      */
1320     function revokeRole(bytes32 role, address account) external;
1321 
1322     /**
1323      * @dev Revokes `role` from the calling account.
1324      *
1325      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1326      * purpose is to provide a mechanism for accounts to lose their privileges
1327      * if they are compromised (such as when a trusted device is misplaced).
1328      *
1329      * If the calling account had been granted `role`, emits a {RoleRevoked}
1330      * event.
1331      *
1332      * Requirements:
1333      *
1334      * - the caller must be `account`.
1335      */
1336     function renounceRole(bytes32 role, address account) external;
1337 }
1338 
1339 // File: @openzeppelin/contracts/utils/Address.sol
1340 
1341 
1342 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1343 
1344 pragma solidity ^0.8.1;
1345 
1346 /**
1347  * @dev Collection of functions related to the address type
1348  */
1349 library Address {
1350     /**
1351      * @dev Returns true if `account` is a contract.
1352      *
1353      * [IMPORTANT]
1354      * ====
1355      * It is unsafe to assume that an address for which this function returns
1356      * false is an externally-owned account (EOA) and not a contract.
1357      *
1358      * Among others, `isContract` will return false for the following
1359      * types of addresses:
1360      *
1361      *  - an externally-owned account
1362      *  - a contract in construction
1363      *  - an address where a contract will be created
1364      *  - an address where a contract lived, but was destroyed
1365      * ====
1366      *
1367      * [IMPORTANT]
1368      * ====
1369      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1370      *
1371      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1372      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1373      * constructor.
1374      * ====
1375      */
1376     function isContract(address account) internal view returns (bool) {
1377         // This method relies on extcodesize/address.code.length, which returns 0
1378         // for contracts in construction, since the code is only stored at the end
1379         // of the constructor execution.
1380 
1381         return account.code.length > 0;
1382     }
1383 
1384     /**
1385      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1386      * `recipient`, forwarding all available gas and reverting on errors.
1387      *
1388      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1389      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1390      * imposed by `transfer`, making them unable to receive funds via
1391      * `transfer`. {sendValue} removes this limitation.
1392      *
1393      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1394      *
1395      * IMPORTANT: because control is transferred to `recipient`, care must be
1396      * taken to not create reentrancy vulnerabilities. Consider using
1397      * {ReentrancyGuard} or the
1398      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1399      */
1400     function sendValue(address payable recipient, uint256 amount) internal {
1401         require(address(this).balance >= amount, "Address: insufficient balance");
1402 
1403         (bool success, ) = recipient.call{value: amount}("");
1404         require(success, "Address: unable to send value, recipient may have reverted");
1405     }
1406 
1407     /**
1408      * @dev Performs a Solidity function call using a low level `call`. A
1409      * plain `call` is an unsafe replacement for a function call: use this
1410      * function instead.
1411      *
1412      * If `target` reverts with a revert reason, it is bubbled up by this
1413      * function (like regular Solidity function calls).
1414      *
1415      * Returns the raw returned data. To convert to the expected return value,
1416      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1417      *
1418      * Requirements:
1419      *
1420      * - `target` must be a contract.
1421      * - calling `target` with `data` must not revert.
1422      *
1423      * _Available since v3.1._
1424      */
1425     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1426         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1427     }
1428 
1429     /**
1430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1431      * `errorMessage` as a fallback revert reason when `target` reverts.
1432      *
1433      * _Available since v3.1._
1434      */
1435     function functionCall(
1436         address target,
1437         bytes memory data,
1438         string memory errorMessage
1439     ) internal returns (bytes memory) {
1440         return functionCallWithValue(target, data, 0, errorMessage);
1441     }
1442 
1443     /**
1444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1445      * but also transferring `value` wei to `target`.
1446      *
1447      * Requirements:
1448      *
1449      * - the calling contract must have an ETH balance of at least `value`.
1450      * - the called Solidity function must be `payable`.
1451      *
1452      * _Available since v3.1._
1453      */
1454     function functionCallWithValue(
1455         address target,
1456         bytes memory data,
1457         uint256 value
1458     ) internal returns (bytes memory) {
1459         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1460     }
1461 
1462     /**
1463      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1464      * with `errorMessage` as a fallback revert reason when `target` reverts.
1465      *
1466      * _Available since v3.1._
1467      */
1468     function functionCallWithValue(
1469         address target,
1470         bytes memory data,
1471         uint256 value,
1472         string memory errorMessage
1473     ) internal returns (bytes memory) {
1474         require(address(this).balance >= value, "Address: insufficient balance for call");
1475         (bool success, bytes memory returndata) = target.call{value: value}(data);
1476         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1477     }
1478 
1479     /**
1480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1481      * but performing a static call.
1482      *
1483      * _Available since v3.3._
1484      */
1485     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1486         return functionStaticCall(target, data, "Address: low-level static call failed");
1487     }
1488 
1489     /**
1490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1491      * but performing a static call.
1492      *
1493      * _Available since v3.3._
1494      */
1495     function functionStaticCall(
1496         address target,
1497         bytes memory data,
1498         string memory errorMessage
1499     ) internal view returns (bytes memory) {
1500         (bool success, bytes memory returndata) = target.staticcall(data);
1501         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1502     }
1503 
1504     /**
1505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1506      * but performing a delegate call.
1507      *
1508      * _Available since v3.4._
1509      */
1510     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1511         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1512     }
1513 
1514     /**
1515      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1516      * but performing a delegate call.
1517      *
1518      * _Available since v3.4._
1519      */
1520     function functionDelegateCall(
1521         address target,
1522         bytes memory data,
1523         string memory errorMessage
1524     ) internal returns (bytes memory) {
1525         (bool success, bytes memory returndata) = target.delegatecall(data);
1526         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1527     }
1528 
1529     /**
1530      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1531      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1532      *
1533      * _Available since v4.8._
1534      */
1535     function verifyCallResultFromTarget(
1536         address target,
1537         bool success,
1538         bytes memory returndata,
1539         string memory errorMessage
1540     ) internal view returns (bytes memory) {
1541         if (success) {
1542             if (returndata.length == 0) {
1543                 // only check isContract if the call was successful and the return data is empty
1544                 // otherwise we already know that it was a contract
1545                 require(isContract(target), "Address: call to non-contract");
1546             }
1547             return returndata;
1548         } else {
1549             _revert(returndata, errorMessage);
1550         }
1551     }
1552 
1553     /**
1554      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1555      * revert reason or using the provided one.
1556      *
1557      * _Available since v4.3._
1558      */
1559     function verifyCallResult(
1560         bool success,
1561         bytes memory returndata,
1562         string memory errorMessage
1563     ) internal pure returns (bytes memory) {
1564         if (success) {
1565             return returndata;
1566         } else {
1567             _revert(returndata, errorMessage);
1568         }
1569     }
1570 
1571     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1572         // Look for revert reason and bubble it up if present
1573         if (returndata.length > 0) {
1574             // The easiest way to bubble the revert reason is using memory via assembly
1575             /// @solidity memory-safe-assembly
1576             assembly {
1577                 let returndata_size := mload(returndata)
1578                 revert(add(32, returndata), returndata_size)
1579             }
1580         } else {
1581             revert(errorMessage);
1582         }
1583     }
1584 }
1585 
1586 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1587 
1588 
1589 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1590 
1591 pragma solidity ^0.8.0;
1592 
1593 /**
1594  * @dev Interface of the ERC165 standard, as defined in the
1595  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1596  *
1597  * Implementers can declare support of contract interfaces, which can then be
1598  * queried by others ({ERC165Checker}).
1599  *
1600  * For an implementation, see {ERC165}.
1601  */
1602 interface IERC165 {
1603     /**
1604      * @dev Returns true if this contract implements the interface defined by
1605      * `interfaceId`. See the corresponding
1606      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1607      * to learn more about how these ids are created.
1608      *
1609      * This function call must use less than 30 000 gas.
1610      */
1611     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1612 }
1613 
1614 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1615 
1616 
1617 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1618 
1619 pragma solidity ^0.8.0;
1620 
1621 
1622 /**
1623  * @dev Interface for the NFT Royalty Standard.
1624  *
1625  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1626  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1627  *
1628  * _Available since v4.5._
1629  */
1630 interface IERC2981 is IERC165 {
1631     /**
1632      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1633      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1634      */
1635     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1636         external
1637         view
1638         returns (address receiver, uint256 royaltyAmount);
1639 }
1640 
1641 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1642 
1643 
1644 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1645 
1646 pragma solidity ^0.8.0;
1647 
1648 
1649 /**
1650  * @dev Implementation of the {IERC165} interface.
1651  *
1652  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1653  * for the additional interface id that will be supported. For example:
1654  *
1655  * ```solidity
1656  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1657  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1658  * }
1659  * ```
1660  *
1661  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1662  */
1663 abstract contract ERC165 is IERC165 {
1664     /**
1665      * @dev See {IERC165-supportsInterface}.
1666      */
1667     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1668         return interfaceId == type(IERC165).interfaceId;
1669     }
1670 }
1671 
1672 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1673 
1674 
1675 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1676 
1677 pragma solidity ^0.8.0;
1678 
1679 
1680 
1681 /**
1682  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1683  *
1684  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1685  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1686  *
1687  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1688  * fee is specified in basis points by default.
1689  *
1690  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1691  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1692  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1693  *
1694  * _Available since v4.5._
1695  */
1696 abstract contract ERC2981 is IERC2981, ERC165 {
1697     struct RoyaltyInfo {
1698         address receiver;
1699         uint96 royaltyFraction;
1700     }
1701 
1702     RoyaltyInfo private _defaultRoyaltyInfo;
1703     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1704 
1705     /**
1706      * @dev See {IERC165-supportsInterface}.
1707      */
1708     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1709         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1710     }
1711 
1712     /**
1713      * @inheritdoc IERC2981
1714      */
1715     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1716         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1717 
1718         if (royalty.receiver == address(0)) {
1719             royalty = _defaultRoyaltyInfo;
1720         }
1721 
1722         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1723 
1724         return (royalty.receiver, royaltyAmount);
1725     }
1726 
1727     /**
1728      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1729      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1730      * override.
1731      */
1732     function _feeDenominator() internal pure virtual returns (uint96) {
1733         return 10000;
1734     }
1735 
1736     /**
1737      * @dev Sets the royalty information that all ids in this contract will default to.
1738      *
1739      * Requirements:
1740      *
1741      * - `receiver` cannot be the zero address.
1742      * - `feeNumerator` cannot be greater than the fee denominator.
1743      */
1744     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1745         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1746         require(receiver != address(0), "ERC2981: invalid receiver");
1747 
1748         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1749     }
1750 
1751     /**
1752      * @dev Removes default royalty information.
1753      */
1754     function _deleteDefaultRoyalty() internal virtual {
1755         delete _defaultRoyaltyInfo;
1756     }
1757 
1758     /**
1759      * @dev Sets the royalty information for a specific token id, overriding the global default.
1760      *
1761      * Requirements:
1762      *
1763      * - `receiver` cannot be the zero address.
1764      * - `feeNumerator` cannot be greater than the fee denominator.
1765      */
1766     function _setTokenRoyalty(
1767         uint256 tokenId,
1768         address receiver,
1769         uint96 feeNumerator
1770     ) internal virtual {
1771         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1772         require(receiver != address(0), "ERC2981: Invalid parameters");
1773 
1774         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1775     }
1776 
1777     /**
1778      * @dev Resets royalty information for the token id back to the global default.
1779      */
1780     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1781         delete _tokenRoyaltyInfo[tokenId];
1782     }
1783 }
1784 
1785 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1786 
1787 
1788 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1789 
1790 pragma solidity ^0.8.0;
1791 
1792 
1793 /**
1794  * @dev _Available since v3.1._
1795  */
1796 interface IERC1155Receiver is IERC165 {
1797     /**
1798      * @dev Handles the receipt of a single ERC1155 token type. This function is
1799      * called at the end of a `safeTransferFrom` after the balance has been updated.
1800      *
1801      * NOTE: To accept the transfer, this must return
1802      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1803      * (i.e. 0xf23a6e61, or its own function selector).
1804      *
1805      * @param operator The address which initiated the transfer (i.e. msg.sender)
1806      * @param from The address which previously owned the token
1807      * @param id The ID of the token being transferred
1808      * @param value The amount of tokens being transferred
1809      * @param data Additional data with no specified format
1810      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1811      */
1812     function onERC1155Received(
1813         address operator,
1814         address from,
1815         uint256 id,
1816         uint256 value,
1817         bytes calldata data
1818     ) external returns (bytes4);
1819 
1820     /**
1821      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1822      * is called at the end of a `safeBatchTransferFrom` after the balances have
1823      * been updated.
1824      *
1825      * NOTE: To accept the transfer(s), this must return
1826      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1827      * (i.e. 0xbc197c81, or its own function selector).
1828      *
1829      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1830      * @param from The address which previously owned the token
1831      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1832      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1833      * @param data Additional data with no specified format
1834      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1835      */
1836     function onERC1155BatchReceived(
1837         address operator,
1838         address from,
1839         uint256[] calldata ids,
1840         uint256[] calldata values,
1841         bytes calldata data
1842     ) external returns (bytes4);
1843 }
1844 
1845 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1846 
1847 
1848 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1849 
1850 pragma solidity ^0.8.0;
1851 
1852 
1853 /**
1854  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1855  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1856  *
1857  * _Available since v3.1._
1858  */
1859 interface IERC1155 is IERC165 {
1860     /**
1861      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1862      */
1863     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1864 
1865     /**
1866      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1867      * transfers.
1868      */
1869     event TransferBatch(
1870         address indexed operator,
1871         address indexed from,
1872         address indexed to,
1873         uint256[] ids,
1874         uint256[] values
1875     );
1876 
1877     /**
1878      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1879      * `approved`.
1880      */
1881     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1882 
1883     /**
1884      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1885      *
1886      * If an {URI} event was emitted for `id`, the standard
1887      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1888      * returned by {IERC1155MetadataURI-uri}.
1889      */
1890     event URI(string value, uint256 indexed id);
1891 
1892     /**
1893      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1894      *
1895      * Requirements:
1896      *
1897      * - `account` cannot be the zero address.
1898      */
1899     function balanceOf(address account, uint256 id) external view returns (uint256);
1900 
1901     /**
1902      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1903      *
1904      * Requirements:
1905      *
1906      * - `accounts` and `ids` must have the same length.
1907      */
1908     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1909         external
1910         view
1911         returns (uint256[] memory);
1912 
1913     /**
1914      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1915      *
1916      * Emits an {ApprovalForAll} event.
1917      *
1918      * Requirements:
1919      *
1920      * - `operator` cannot be the caller.
1921      */
1922     function setApprovalForAll(address operator, bool approved) external;
1923 
1924     /**
1925      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1926      *
1927      * See {setApprovalForAll}.
1928      */
1929     function isApprovedForAll(address account, address operator) external view returns (bool);
1930 
1931     /**
1932      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1933      *
1934      * Emits a {TransferSingle} event.
1935      *
1936      * Requirements:
1937      *
1938      * - `to` cannot be the zero address.
1939      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1940      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1941      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1942      * acceptance magic value.
1943      */
1944     function safeTransferFrom(
1945         address from,
1946         address to,
1947         uint256 id,
1948         uint256 amount,
1949         bytes calldata data
1950     ) external;
1951 
1952     /**
1953      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1954      *
1955      * Emits a {TransferBatch} event.
1956      *
1957      * Requirements:
1958      *
1959      * - `ids` and `amounts` must have the same length.
1960      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1961      * acceptance magic value.
1962      */
1963     function safeBatchTransferFrom(
1964         address from,
1965         address to,
1966         uint256[] calldata ids,
1967         uint256[] calldata amounts,
1968         bytes calldata data
1969     ) external;
1970 }
1971 
1972 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1973 
1974 
1975 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1976 
1977 pragma solidity ^0.8.0;
1978 
1979 
1980 /**
1981  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1982  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1983  *
1984  * _Available since v3.1._
1985  */
1986 interface IERC1155MetadataURI is IERC1155 {
1987     /**
1988      * @dev Returns the URI for token type `id`.
1989      *
1990      * If the `\{id\}` substring is present in the URI, it must be replaced by
1991      * clients with the actual token type ID.
1992      */
1993     function uri(uint256 id) external view returns (string memory);
1994 }
1995 
1996 // File: @openzeppelin/contracts/utils/Context.sol
1997 
1998 
1999 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2000 
2001 pragma solidity ^0.8.0;
2002 
2003 /**
2004  * @dev Provides information about the current execution context, including the
2005  * sender of the transaction and its data. While these are generally available
2006  * via msg.sender and msg.data, they should not be accessed in such a direct
2007  * manner, since when dealing with meta-transactions the account sending and
2008  * paying for execution may not be the actual sender (as far as an application
2009  * is concerned).
2010  *
2011  * This contract is only required for intermediate, library-like contracts.
2012  */
2013 abstract contract Context {
2014     function _msgSender() internal view virtual returns (address) {
2015         return msg.sender;
2016     }
2017 
2018     function _msgData() internal view virtual returns (bytes calldata) {
2019         return msg.data;
2020     }
2021 }
2022 
2023 // File: @openzeppelin/contracts/access/AccessControl.sol
2024 
2025 
2026 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
2027 
2028 pragma solidity ^0.8.0;
2029 
2030 
2031 
2032 
2033 
2034 /**
2035  * @dev Contract module that allows children to implement role-based access
2036  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2037  * members except through off-chain means by accessing the contract event logs. Some
2038  * applications may benefit from on-chain enumerability, for those cases see
2039  * {AccessControlEnumerable}.
2040  *
2041  * Roles are referred to by their `bytes32` identifier. These should be exposed
2042  * in the external API and be unique. The best way to achieve this is by
2043  * using `public constant` hash digests:
2044  *
2045  * ```
2046  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2047  * ```
2048  *
2049  * Roles can be used to represent a set of permissions. To restrict access to a
2050  * function call, use {hasRole}:
2051  *
2052  * ```
2053  * function foo() public {
2054  *     require(hasRole(MY_ROLE, msg.sender));
2055  *     ...
2056  * }
2057  * ```
2058  *
2059  * Roles can be granted and revoked dynamically via the {grantRole} and
2060  * {revokeRole} functions. Each role has an associated admin role, and only
2061  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2062  *
2063  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2064  * that only accounts with this role will be able to grant or revoke other
2065  * roles. More complex role relationships can be created by using
2066  * {_setRoleAdmin}.
2067  *
2068  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2069  * grant and revoke this role. Extra precautions should be taken to secure
2070  * accounts that have been granted it.
2071  */
2072 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2073     struct RoleData {
2074         mapping(address => bool) members;
2075         bytes32 adminRole;
2076     }
2077 
2078     mapping(bytes32 => RoleData) private _roles;
2079 
2080     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2081 
2082     /**
2083      * @dev Modifier that checks that an account has a specific role. Reverts
2084      * with a standardized message including the required role.
2085      *
2086      * The format of the revert reason is given by the following regular expression:
2087      *
2088      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2089      *
2090      * _Available since v4.1._
2091      */
2092     modifier onlyRole(bytes32 role) {
2093         _checkRole(role);
2094         _;
2095     }
2096 
2097     /**
2098      * @dev See {IERC165-supportsInterface}.
2099      */
2100     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2101         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2102     }
2103 
2104     /**
2105      * @dev Returns `true` if `account` has been granted `role`.
2106      */
2107     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2108         return _roles[role].members[account];
2109     }
2110 
2111     /**
2112      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2113      * Overriding this function changes the behavior of the {onlyRole} modifier.
2114      *
2115      * Format of the revert message is described in {_checkRole}.
2116      *
2117      * _Available since v4.6._
2118      */
2119     function _checkRole(bytes32 role) internal view virtual {
2120         _checkRole(role, _msgSender());
2121     }
2122 
2123     /**
2124      * @dev Revert with a standard message if `account` is missing `role`.
2125      *
2126      * The format of the revert reason is given by the following regular expression:
2127      *
2128      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2129      */
2130     function _checkRole(bytes32 role, address account) internal view virtual {
2131         if (!hasRole(role, account)) {
2132             revert(
2133                 string(
2134                     abi.encodePacked(
2135                         "AccessControl: account ",
2136                         Strings.toHexString(account),
2137                         " is missing role ",
2138                         Strings.toHexString(uint256(role), 32)
2139                     )
2140                 )
2141             );
2142         }
2143     }
2144 
2145     /**
2146      * @dev Returns the admin role that controls `role`. See {grantRole} and
2147      * {revokeRole}.
2148      *
2149      * To change a role's admin, use {_setRoleAdmin}.
2150      */
2151     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2152         return _roles[role].adminRole;
2153     }
2154 
2155     /**
2156      * @dev Grants `role` to `account`.
2157      *
2158      * If `account` had not been already granted `role`, emits a {RoleGranted}
2159      * event.
2160      *
2161      * Requirements:
2162      *
2163      * - the caller must have ``role``'s admin role.
2164      *
2165      * May emit a {RoleGranted} event.
2166      */
2167     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2168         _grantRole(role, account);
2169     }
2170 
2171     /**
2172      * @dev Revokes `role` from `account`.
2173      *
2174      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2175      *
2176      * Requirements:
2177      *
2178      * - the caller must have ``role``'s admin role.
2179      *
2180      * May emit a {RoleRevoked} event.
2181      */
2182     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2183         _revokeRole(role, account);
2184     }
2185 
2186     /**
2187      * @dev Revokes `role` from the calling account.
2188      *
2189      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2190      * purpose is to provide a mechanism for accounts to lose their privileges
2191      * if they are compromised (such as when a trusted device is misplaced).
2192      *
2193      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2194      * event.
2195      *
2196      * Requirements:
2197      *
2198      * - the caller must be `account`.
2199      *
2200      * May emit a {RoleRevoked} event.
2201      */
2202     function renounceRole(bytes32 role, address account) public virtual override {
2203         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2204 
2205         _revokeRole(role, account);
2206     }
2207 
2208     /**
2209      * @dev Grants `role` to `account`.
2210      *
2211      * If `account` had not been already granted `role`, emits a {RoleGranted}
2212      * event. Note that unlike {grantRole}, this function doesn't perform any
2213      * checks on the calling account.
2214      *
2215      * May emit a {RoleGranted} event.
2216      *
2217      * [WARNING]
2218      * ====
2219      * This function should only be called from the constructor when setting
2220      * up the initial roles for the system.
2221      *
2222      * Using this function in any other way is effectively circumventing the admin
2223      * system imposed by {AccessControl}.
2224      * ====
2225      *
2226      * NOTE: This function is deprecated in favor of {_grantRole}.
2227      */
2228     function _setupRole(bytes32 role, address account) internal virtual {
2229         _grantRole(role, account);
2230     }
2231 
2232     /**
2233      * @dev Sets `adminRole` as ``role``'s admin role.
2234      *
2235      * Emits a {RoleAdminChanged} event.
2236      */
2237     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2238         bytes32 previousAdminRole = getRoleAdmin(role);
2239         _roles[role].adminRole = adminRole;
2240         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2241     }
2242 
2243     /**
2244      * @dev Grants `role` to `account`.
2245      *
2246      * Internal function without access restriction.
2247      *
2248      * May emit a {RoleGranted} event.
2249      */
2250     function _grantRole(bytes32 role, address account) internal virtual {
2251         if (!hasRole(role, account)) {
2252             _roles[role].members[account] = true;
2253             emit RoleGranted(role, account, _msgSender());
2254         }
2255     }
2256 
2257     /**
2258      * @dev Revokes `role` from `account`.
2259      *
2260      * Internal function without access restriction.
2261      *
2262      * May emit a {RoleRevoked} event.
2263      */
2264     function _revokeRole(bytes32 role, address account) internal virtual {
2265         if (hasRole(role, account)) {
2266             _roles[role].members[account] = false;
2267             emit RoleRevoked(role, account, _msgSender());
2268         }
2269     }
2270 }
2271 
2272 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
2273 
2274 
2275 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
2276 
2277 pragma solidity ^0.8.0;
2278 
2279 
2280 
2281 
2282 
2283 
2284 
2285 /**
2286  * @dev Implementation of the basic standard multi-token.
2287  * See https://eips.ethereum.org/EIPS/eip-1155
2288  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
2289  *
2290  * _Available since v3.1._
2291  */
2292 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
2293     using Address for address;
2294 
2295     // Mapping from token ID to account balances
2296     mapping(uint256 => mapping(address => uint256)) private _balances;
2297 
2298     // Mapping from account to operator approvals
2299     mapping(address => mapping(address => bool)) private _operatorApprovals;
2300 
2301     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
2302     string private _uri;
2303 
2304     /**
2305      * @dev See {_setURI}.
2306      */
2307     constructor(string memory uri_) {
2308         _setURI(uri_);
2309     }
2310 
2311     /**
2312      * @dev See {IERC165-supportsInterface}.
2313      */
2314     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2315         return
2316             interfaceId == type(IERC1155).interfaceId ||
2317             interfaceId == type(IERC1155MetadataURI).interfaceId ||
2318             super.supportsInterface(interfaceId);
2319     }
2320 
2321     /**
2322      * @dev See {IERC1155MetadataURI-uri}.
2323      *
2324      * This implementation returns the same URI for *all* token types. It relies
2325      * on the token type ID substitution mechanism
2326      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
2327      *
2328      * Clients calling this function must replace the `\{id\}` substring with the
2329      * actual token type ID.
2330      */
2331     function uri(uint256) public view virtual override returns (string memory) {
2332         return _uri;
2333     }
2334 
2335     /**
2336      * @dev See {IERC1155-balanceOf}.
2337      *
2338      * Requirements:
2339      *
2340      * - `account` cannot be the zero address.
2341      */
2342     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
2343         require(account != address(0), "ERC1155: address zero is not a valid owner");
2344         return _balances[id][account];
2345     }
2346 
2347     /**
2348      * @dev See {IERC1155-balanceOfBatch}.
2349      *
2350      * Requirements:
2351      *
2352      * - `accounts` and `ids` must have the same length.
2353      */
2354     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
2355         public
2356         view
2357         virtual
2358         override
2359         returns (uint256[] memory)
2360     {
2361         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
2362 
2363         uint256[] memory batchBalances = new uint256[](accounts.length);
2364 
2365         for (uint256 i = 0; i < accounts.length; ++i) {
2366             batchBalances[i] = balanceOf(accounts[i], ids[i]);
2367         }
2368 
2369         return batchBalances;
2370     }
2371 
2372     /**
2373      * @dev See {IERC1155-setApprovalForAll}.
2374      */
2375     function setApprovalForAll(address operator, bool approved) public virtual override {
2376         _setApprovalForAll(_msgSender(), operator, approved);
2377     }
2378 
2379     /**
2380      * @dev See {IERC1155-isApprovedForAll}.
2381      */
2382     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
2383         return _operatorApprovals[account][operator];
2384     }
2385 
2386     /**
2387      * @dev See {IERC1155-safeTransferFrom}.
2388      */
2389     function safeTransferFrom(
2390         address from,
2391         address to,
2392         uint256 id,
2393         uint256 amount,
2394         bytes memory data
2395     ) public virtual override {
2396         require(
2397             from == _msgSender() || isApprovedForAll(from, _msgSender()),
2398             "ERC1155: caller is not token owner or approved"
2399         );
2400         _safeTransferFrom(from, to, id, amount, data);
2401     }
2402 
2403     /**
2404      * @dev See {IERC1155-safeBatchTransferFrom}.
2405      */
2406     function safeBatchTransferFrom(
2407         address from,
2408         address to,
2409         uint256[] memory ids,
2410         uint256[] memory amounts,
2411         bytes memory data
2412     ) public virtual override {
2413         require(
2414             from == _msgSender() || isApprovedForAll(from, _msgSender()),
2415             "ERC1155: caller is not token owner or approved"
2416         );
2417         _safeBatchTransferFrom(from, to, ids, amounts, data);
2418     }
2419 
2420     /**
2421      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
2422      *
2423      * Emits a {TransferSingle} event.
2424      *
2425      * Requirements:
2426      *
2427      * - `to` cannot be the zero address.
2428      * - `from` must have a balance of tokens of type `id` of at least `amount`.
2429      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2430      * acceptance magic value.
2431      */
2432     function _safeTransferFrom(
2433         address from,
2434         address to,
2435         uint256 id,
2436         uint256 amount,
2437         bytes memory data
2438     ) internal virtual {
2439         require(to != address(0), "ERC1155: transfer to the zero address");
2440 
2441         address operator = _msgSender();
2442         uint256[] memory ids = _asSingletonArray(id);
2443         uint256[] memory amounts = _asSingletonArray(amount);
2444 
2445         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
2446 
2447         uint256 fromBalance = _balances[id][from];
2448         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
2449         unchecked {
2450             _balances[id][from] = fromBalance - amount;
2451         }
2452         _balances[id][to] += amount;
2453 
2454         emit TransferSingle(operator, from, to, id, amount);
2455 
2456         _afterTokenTransfer(operator, from, to, ids, amounts, data);
2457 
2458         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
2459     }
2460 
2461     /**
2462      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
2463      *
2464      * Emits a {TransferBatch} event.
2465      *
2466      * Requirements:
2467      *
2468      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2469      * acceptance magic value.
2470      */
2471     function _safeBatchTransferFrom(
2472         address from,
2473         address to,
2474         uint256[] memory ids,
2475         uint256[] memory amounts,
2476         bytes memory data
2477     ) internal virtual {
2478         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2479         require(to != address(0), "ERC1155: transfer to the zero address");
2480 
2481         address operator = _msgSender();
2482 
2483         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
2484 
2485         for (uint256 i = 0; i < ids.length; ++i) {
2486             uint256 id = ids[i];
2487             uint256 amount = amounts[i];
2488 
2489             uint256 fromBalance = _balances[id][from];
2490             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
2491             unchecked {
2492                 _balances[id][from] = fromBalance - amount;
2493             }
2494             _balances[id][to] += amount;
2495         }
2496 
2497         emit TransferBatch(operator, from, to, ids, amounts);
2498 
2499         _afterTokenTransfer(operator, from, to, ids, amounts, data);
2500 
2501         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
2502     }
2503 
2504     /**
2505      * @dev Sets a new URI for all token types, by relying on the token type ID
2506      * substitution mechanism
2507      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
2508      *
2509      * By this mechanism, any occurrence of the `\{id\}` substring in either the
2510      * URI or any of the amounts in the JSON file at said URI will be replaced by
2511      * clients with the token type ID.
2512      *
2513      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
2514      * interpreted by clients as
2515      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
2516      * for token type ID 0x4cce0.
2517      *
2518      * See {uri}.
2519      *
2520      * Because these URIs cannot be meaningfully represented by the {URI} event,
2521      * this function emits no events.
2522      */
2523     function _setURI(string memory newuri) internal virtual {
2524         _uri = newuri;
2525     }
2526 
2527     /**
2528      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
2529      *
2530      * Emits a {TransferSingle} event.
2531      *
2532      * Requirements:
2533      *
2534      * - `to` cannot be the zero address.
2535      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2536      * acceptance magic value.
2537      */
2538     function _mint(
2539         address to,
2540         uint256 id,
2541         uint256 amount,
2542         bytes memory data
2543     ) internal virtual {
2544         require(to != address(0), "ERC1155: mint to the zero address");
2545 
2546         address operator = _msgSender();
2547         uint256[] memory ids = _asSingletonArray(id);
2548         uint256[] memory amounts = _asSingletonArray(amount);
2549 
2550         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2551 
2552         _balances[id][to] += amount;
2553         emit TransferSingle(operator, address(0), to, id, amount);
2554 
2555         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2556 
2557         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
2558     }
2559 
2560     /**
2561      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
2562      *
2563      * Emits a {TransferBatch} event.
2564      *
2565      * Requirements:
2566      *
2567      * - `ids` and `amounts` must have the same length.
2568      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2569      * acceptance magic value.
2570      */
2571     function _mintBatch(
2572         address to,
2573         uint256[] memory ids,
2574         uint256[] memory amounts,
2575         bytes memory data
2576     ) internal virtual {
2577         require(to != address(0), "ERC1155: mint to the zero address");
2578         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2579 
2580         address operator = _msgSender();
2581 
2582         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2583 
2584         for (uint256 i = 0; i < ids.length; i++) {
2585             _balances[ids[i]][to] += amounts[i];
2586         }
2587 
2588         emit TransferBatch(operator, address(0), to, ids, amounts);
2589 
2590         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2591 
2592         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
2593     }
2594 
2595     /**
2596      * @dev Destroys `amount` tokens of token type `id` from `from`
2597      *
2598      * Emits a {TransferSingle} event.
2599      *
2600      * Requirements:
2601      *
2602      * - `from` cannot be the zero address.
2603      * - `from` must have at least `amount` tokens of token type `id`.
2604      */
2605     function _burn(
2606         address from,
2607         uint256 id,
2608         uint256 amount
2609     ) internal virtual {
2610         require(from != address(0), "ERC1155: burn from the zero address");
2611 
2612         address operator = _msgSender();
2613         uint256[] memory ids = _asSingletonArray(id);
2614         uint256[] memory amounts = _asSingletonArray(amount);
2615 
2616         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2617 
2618         uint256 fromBalance = _balances[id][from];
2619         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2620         unchecked {
2621             _balances[id][from] = fromBalance - amount;
2622         }
2623 
2624         emit TransferSingle(operator, from, address(0), id, amount);
2625 
2626         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2627     }
2628 
2629     /**
2630      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
2631      *
2632      * Emits a {TransferBatch} event.
2633      *
2634      * Requirements:
2635      *
2636      * - `ids` and `amounts` must have the same length.
2637      */
2638     function _burnBatch(
2639         address from,
2640         uint256[] memory ids,
2641         uint256[] memory amounts
2642     ) internal virtual {
2643         require(from != address(0), "ERC1155: burn from the zero address");
2644         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2645 
2646         address operator = _msgSender();
2647 
2648         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2649 
2650         for (uint256 i = 0; i < ids.length; i++) {
2651             uint256 id = ids[i];
2652             uint256 amount = amounts[i];
2653 
2654             uint256 fromBalance = _balances[id][from];
2655             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2656             unchecked {
2657                 _balances[id][from] = fromBalance - amount;
2658             }
2659         }
2660 
2661         emit TransferBatch(operator, from, address(0), ids, amounts);
2662 
2663         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2664     }
2665 
2666     /**
2667      * @dev Approve `operator` to operate on all of `owner` tokens
2668      *
2669      * Emits an {ApprovalForAll} event.
2670      */
2671     function _setApprovalForAll(
2672         address owner,
2673         address operator,
2674         bool approved
2675     ) internal virtual {
2676         require(owner != operator, "ERC1155: setting approval status for self");
2677         _operatorApprovals[owner][operator] = approved;
2678         emit ApprovalForAll(owner, operator, approved);
2679     }
2680 
2681     /**
2682      * @dev Hook that is called before any token transfer. This includes minting
2683      * and burning, as well as batched variants.
2684      *
2685      * The same hook is called on both single and batched variants. For single
2686      * transfers, the length of the `ids` and `amounts` arrays will be 1.
2687      *
2688      * Calling conditions (for each `id` and `amount` pair):
2689      *
2690      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2691      * of token type `id` will be  transferred to `to`.
2692      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2693      * for `to`.
2694      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2695      * will be burned.
2696      * - `from` and `to` are never both zero.
2697      * - `ids` and `amounts` have the same, non-zero length.
2698      *
2699      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2700      */
2701     function _beforeTokenTransfer(
2702         address operator,
2703         address from,
2704         address to,
2705         uint256[] memory ids,
2706         uint256[] memory amounts,
2707         bytes memory data
2708     ) internal virtual {}
2709 
2710     /**
2711      * @dev Hook that is called after any token transfer. This includes minting
2712      * and burning, as well as batched variants.
2713      *
2714      * The same hook is called on both single and batched variants. For single
2715      * transfers, the length of the `id` and `amount` arrays will be 1.
2716      *
2717      * Calling conditions (for each `id` and `amount` pair):
2718      *
2719      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2720      * of token type `id` will be  transferred to `to`.
2721      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2722      * for `to`.
2723      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2724      * will be burned.
2725      * - `from` and `to` are never both zero.
2726      * - `ids` and `amounts` have the same, non-zero length.
2727      *
2728      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2729      */
2730     function _afterTokenTransfer(
2731         address operator,
2732         address from,
2733         address to,
2734         uint256[] memory ids,
2735         uint256[] memory amounts,
2736         bytes memory data
2737     ) internal virtual {}
2738 
2739     function _doSafeTransferAcceptanceCheck(
2740         address operator,
2741         address from,
2742         address to,
2743         uint256 id,
2744         uint256 amount,
2745         bytes memory data
2746     ) private {
2747         if (to.isContract()) {
2748             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
2749                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2750                     revert("ERC1155: ERC1155Receiver rejected tokens");
2751                 }
2752             } catch Error(string memory reason) {
2753                 revert(reason);
2754             } catch {
2755                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2756             }
2757         }
2758     }
2759 
2760     function _doSafeBatchTransferAcceptanceCheck(
2761         address operator,
2762         address from,
2763         address to,
2764         uint256[] memory ids,
2765         uint256[] memory amounts,
2766         bytes memory data
2767     ) private {
2768         if (to.isContract()) {
2769             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
2770                 bytes4 response
2771             ) {
2772                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
2773                     revert("ERC1155: ERC1155Receiver rejected tokens");
2774                 }
2775             } catch Error(string memory reason) {
2776                 revert(reason);
2777             } catch {
2778                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2779             }
2780         }
2781     }
2782 
2783     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
2784         uint256[] memory array = new uint256[](1);
2785         array[0] = element;
2786 
2787         return array;
2788     }
2789 }
2790 
2791 // File: @openzeppelin/contracts/access/Ownable.sol
2792 
2793 
2794 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2795 
2796 pragma solidity ^0.8.0;
2797 
2798 
2799 /**
2800  * @dev Contract module which provides a basic access control mechanism, where
2801  * there is an account (an owner) that can be granted exclusive access to
2802  * specific functions.
2803  *
2804  * By default, the owner account will be the one that deploys the contract. This
2805  * can later be changed with {transferOwnership}.
2806  *
2807  * This module is used through inheritance. It will make available the modifier
2808  * `onlyOwner`, which can be applied to your functions to restrict their use to
2809  * the owner.
2810  */
2811 abstract contract Ownable is Context {
2812     address private _owner;
2813 
2814     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2815 
2816     /**
2817      * @dev Initializes the contract setting the deployer as the initial owner.
2818      */
2819     constructor() {
2820         _transferOwnership(_msgSender());
2821     }
2822 
2823     /**
2824      * @dev Throws if called by any account other than the owner.
2825      */
2826     modifier onlyOwner() {
2827         _checkOwner();
2828         _;
2829     }
2830 
2831     /**
2832      * @dev Returns the address of the current owner.
2833      */
2834     function owner() public view virtual returns (address) {
2835         return _owner;
2836     }
2837 
2838     /**
2839      * @dev Throws if the sender is not the owner.
2840      */
2841     function _checkOwner() internal view virtual {
2842         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2843     }
2844 
2845     /**
2846      * @dev Leaves the contract without owner. It will not be possible to call
2847      * `onlyOwner` functions anymore. Can only be called by the current owner.
2848      *
2849      * NOTE: Renouncing ownership will leave the contract without an owner,
2850      * thereby removing any functionality that is only available to the owner.
2851      */
2852     function renounceOwnership() public virtual onlyOwner {
2853         _transferOwnership(address(0));
2854     }
2855 
2856     /**
2857      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2858      * Can only be called by the current owner.
2859      */
2860     function transferOwnership(address newOwner) public virtual onlyOwner {
2861         require(newOwner != address(0), "Ownable: new owner is the zero address");
2862         _transferOwnership(newOwner);
2863     }
2864 
2865     /**
2866      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2867      * Internal function without access restriction.
2868      */
2869     function _transferOwnership(address newOwner) internal virtual {
2870         address oldOwner = _owner;
2871         _owner = newOwner;
2872         emit OwnershipTransferred(oldOwner, newOwner);
2873     }
2874 }
2875 
2876 // File: base64-sol/base64.sol
2877 
2878 
2879 
2880 pragma solidity >=0.6.0;
2881 
2882 /// @title Base64
2883 /// @author Brecht Devos - <brecht@loopring.org>
2884 /// @notice Provides functions for encoding/decoding base64
2885 library Base64 {
2886     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
2887     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
2888                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
2889                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
2890                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
2891 
2892     function encode(bytes memory data) internal pure returns (string memory) {
2893         if (data.length == 0) return '';
2894 
2895         // load the table into memory
2896         string memory table = TABLE_ENCODE;
2897 
2898         // multiply by 4/3 rounded up
2899         uint256 encodedLen = 4 * ((data.length + 2) / 3);
2900 
2901         // add some extra buffer at the end required for the writing
2902         string memory result = new string(encodedLen + 32);
2903 
2904         assembly {
2905             // set the actual output length
2906             mstore(result, encodedLen)
2907 
2908             // prepare the lookup table
2909             let tablePtr := add(table, 1)
2910 
2911             // input ptr
2912             let dataPtr := data
2913             let endPtr := add(dataPtr, mload(data))
2914 
2915             // result ptr, jump over length
2916             let resultPtr := add(result, 32)
2917 
2918             // run over the input, 3 bytes at a time
2919             for {} lt(dataPtr, endPtr) {}
2920             {
2921                 // read 3 bytes
2922                 dataPtr := add(dataPtr, 3)
2923                 let input := mload(dataPtr)
2924 
2925                 // write 4 characters
2926                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2927                 resultPtr := add(resultPtr, 1)
2928                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2929                 resultPtr := add(resultPtr, 1)
2930                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
2931                 resultPtr := add(resultPtr, 1)
2932                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
2933                 resultPtr := add(resultPtr, 1)
2934             }
2935 
2936             // padding with '='
2937             switch mod(mload(data), 3)
2938             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
2939             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
2940         }
2941 
2942         return result;
2943     }
2944 
2945     function decode(string memory _data) internal pure returns (bytes memory) {
2946         bytes memory data = bytes(_data);
2947 
2948         if (data.length == 0) return new bytes(0);
2949         require(data.length % 4 == 0, "invalid base64 decoder input");
2950 
2951         // load the table into memory
2952         bytes memory table = TABLE_DECODE;
2953 
2954         // every 4 characters represent 3 bytes
2955         uint256 decodedLen = (data.length / 4) * 3;
2956 
2957         // add some extra buffer at the end required for the writing
2958         bytes memory result = new bytes(decodedLen + 32);
2959 
2960         assembly {
2961             // padding with '='
2962             let lastBytes := mload(add(data, mload(data)))
2963             if eq(and(lastBytes, 0xFF), 0x3d) {
2964                 decodedLen := sub(decodedLen, 1)
2965                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
2966                     decodedLen := sub(decodedLen, 1)
2967                 }
2968             }
2969 
2970             // set the actual output length
2971             mstore(result, decodedLen)
2972 
2973             // prepare the lookup table
2974             let tablePtr := add(table, 1)
2975 
2976             // input ptr
2977             let dataPtr := data
2978             let endPtr := add(dataPtr, mload(data))
2979 
2980             // result ptr, jump over length
2981             let resultPtr := add(result, 32)
2982 
2983             // run over the input, 4 characters at a time
2984             for {} lt(dataPtr, endPtr) {}
2985             {
2986                // read 4 characters
2987                dataPtr := add(dataPtr, 4)
2988                let input := mload(dataPtr)
2989 
2990                // write 3 bytes
2991                let output := add(
2992                    add(
2993                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
2994                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
2995                    add(
2996                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
2997                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
2998                     )
2999                 )
3000                 mstore(resultPtr, shl(232, output))
3001                 resultPtr := add(resultPtr, 3)
3002             }
3003         }
3004 
3005         return result;
3006     }
3007 }
3008 
3009 // File: contracts/nft1155_contract.sol
3010 
3011 
3012 // Copyright (c) 2023 Keisuke OHNO (kei31.eth)
3013 
3014 /*
3015 
3016 Permission is hereby granted, free of charge, to any person obtaining a copy
3017 of this software and associated documentation files (the "Software"), to deal
3018 in the Software without restriction, including without limitation the rights
3019 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
3020 copies of the Software, and to permit persons to whom the Software is
3021 furnished to do so, subject to the following conditions:
3022 
3023 The above copyright notice and this permission notice shall be included in all
3024 copies or substantial portions of the Software.
3025 
3026 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
3027 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
3028 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
3029 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
3030 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
3031 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
3032 SOFTWARE.
3033 
3034 */
3035 
3036 
3037 pragma solidity >=0.8.17;
3038 
3039 
3040 
3041 
3042 
3043 
3044 
3045 
3046 
3047 
3048 
3049 
3050 
3051 //tokenURI interface
3052 interface iTokenURI {
3053     function tokenURI(uint256 _tokenId) external view returns (string memory);
3054 }
3055 
3056 contract NFTContract1155 is RevokableDefaultOperatorFilterer , ERC1155, ERC2981 , Ownable ,AccessControl{
3057     using Strings for uint256;    
3058 
3059     string public name;
3060     string public symbol;
3061     mapping(uint => string) public tokenURIs;
3062     bytes32 public constant ADMIN = keccak256("ADMIN");
3063 
3064 
3065     constructor() ERC1155("") {
3066         name = "ikehaya Museum";
3067         symbol = "IHM";
3068 
3069         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
3070         grantRole(MINTER_ROLE        , msg.sender);
3071         grantRole(AIRDROP_ROLE       , msg.sender);
3072         grantRole(ADMIN              , msg.sender);
3073 
3074         //CAL initialization
3075         setCALLevel(1);
3076 
3077         setCAL(0xdbaa28cBe70aF04EbFB166b1A3E8F8034e5B9FC7);//Ethereum mainnet proxy
3078         //setCAL(0xb506d7BbE23576b8AAf22477cd9A7FDF08002211);//Goerli testnet proxy
3079 
3080         addLocalContractAllowList(0x1E0049783F008A0085193E00003D00cd54003c71);//OpenSea
3081         addLocalContractAllowList(0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be);//Rarible
3082 
3083         //Royalty
3084         setDefaultRoyalty(0xA0a4053c53E4800c88bC09c94F6eaF0307a6c292 , 1000);
3085         setWithdrawAddress(0xA0a4053c53E4800c88bC09c94F6eaF0307a6c292);
3086 
3087         setPhaseId(0);
3088         setUseOnChainMetadataWithImageURI(true);
3089 
3090         setOnChainMetadataWithImageURI(
3091             1 , 
3092             "001" , 
3093             "by Rii2",
3094             "Rii2",
3095             "https://arweave.net/64ufsMiByJYcZir_sooP9HtdV2onryI7A6fD3DRpqZY",
3096             false,
3097             " "
3098         );
3099 
3100         _mint(msg.sender , 1 , 1 , "");
3101 
3102         setPhaseData(
3103             0,
3104             2000,
3105             0,
3106             500,
3107             0xc721e72d15d70280b14947b4720a25bd67740abb4970c4af22f5be279309e526
3108         );
3109 
3110     }
3111 
3112 
3113     //
3114     //withdraw section
3115     //
3116 
3117     address public withdrawAddress = 0xdEcf4B112d4120B6998e5020a6B4819E490F7db6;
3118 
3119     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
3120         withdrawAddress = _withdrawAddress;
3121     }
3122 
3123     function withdraw() public onlyOwner {
3124         (bool os, ) = payable(withdrawAddress).call{value: address(this).balance}('');
3125         require(os);
3126     }
3127 
3128 
3129     //
3130     //mint section
3131     //
3132 
3133     bool public paused = true;
3134     bool public onlyAllowlisted = true;
3135     bool public mintCount = true;
3136     uint256 public publicSaleMaxMintAmountPerAddress = 50;
3137    
3138     uint256 public phaseId = 1;
3139     mapping(uint256 => phaseStrct) public phaseData;
3140 
3141     struct phaseStrct {
3142         uint256 totalSupply;
3143         uint256 maxSupply;
3144         uint256 cost;
3145         uint256 maxMintAmountPerTransaction;
3146         bytes32 merkleRoot;
3147         mapping(address => uint256) userMintedAmount;
3148     }
3149 
3150     modifier callerIsUser() {
3151         require(tx.origin == msg.sender, "The caller is another contract.");
3152         _;
3153     }
3154 
3155     uint256 public minTokenId = 1;
3156     uint256 public maxTokenId = 1;
3157 
3158     function setMinTokenId(uint256 _minTokenId) public onlyRole(ADMIN) {
3159         minTokenId = _minTokenId;
3160     }
3161     function setMaxTokenId(uint256 _maxTokenId) public onlyRole(ADMIN) {
3162         maxTokenId = _maxTokenId;
3163     }
3164 
3165 
3166     function mint(uint256 _mintAmount , uint256 _maxMintAmount , bytes32[] calldata _merkleProof , uint256 _tokenId )  external payable callerIsUser{
3167         require( !paused, "the contract is paused");
3168         require( 0 < _mintAmount , "need to mint at least 1 NFT");
3169         require( _mintAmount <= phaseData[phaseId].maxMintAmountPerTransaction, "max mint amount per session exceeded");
3170         require( phaseData[phaseId].totalSupply + _mintAmount <= phaseData[phaseId].maxSupply, "max NFT limit exceeded");
3171         require( phaseData[phaseId].cost * _mintAmount <=  msg.value , "insufficient funds");
3172         require( minTokenId <= _tokenId && _tokenId <= maxTokenId, "Token ID is not supported by this contract");
3173 
3174         uint256 maxMintAmountPerAddress;
3175         if(onlyAllowlisted == true) {
3176             bytes32 leaf = keccak256( abi.encodePacked(msg.sender, _maxMintAmount) );
3177             require(MerkleProof.verify(_merkleProof, phaseData[phaseId].merkleRoot, leaf), "user is not allowlisted");
3178             maxMintAmountPerAddress = _maxMintAmount;
3179         }else{
3180             maxMintAmountPerAddress = publicSaleMaxMintAmountPerAddress;//atode kangaeru
3181         }
3182 
3183         if(mintCount == true){
3184             require(_mintAmount <= maxMintAmountPerAddress - phaseData[phaseId].userMintedAmount[msg.sender] , "max NFT per address exceeded");
3185             phaseData[phaseId].userMintedAmount[msg.sender] += _mintAmount;
3186         }
3187 
3188         phaseData[_tokenId].totalSupply += _mintAmount;
3189         _mint(msg.sender, _tokenId , _mintAmount, "");
3190     }
3191 
3192     bytes32 public constant AIRDROP_ROLE = keccak256("AIRDROP_ROLE");
3193     function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public {
3194         require(hasRole(AIRDROP_ROLE, msg.sender), "Caller is not a air dropper");
3195         require(_airdropAddresses.length == _UserMintAmount.length , "Array lengths are different");
3196         uint256 _mintAmount = 0;
3197         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
3198             _mintAmount += _UserMintAmount[i];
3199         }
3200         require( 0 < _mintAmount , "need to mint at least 1 NFT" );
3201         require( phaseData[phaseId].totalSupply + _mintAmount <= phaseData[phaseId].maxSupply, "max NFT limit exceeded");
3202         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
3203             phaseData[phaseId].totalSupply += _UserMintAmount[i];
3204             _mint(_airdropAddresses[i], phaseId , _UserMintAmount[i] , "" );
3205         }
3206     }
3207 
3208     function adminMint(address _address , uint256 _mintAmount ) public onlyRole(ADMIN) {
3209         phaseData[phaseId].totalSupply += _mintAmount;
3210         _mint(_address, phaseId , _mintAmount, "");
3211     }
3212 
3213     function setPhaseData( 
3214         uint256 _id , 
3215         uint256 _maxSupply , 
3216         uint256 _cost , 
3217         uint256 _maxMintAmountPerTransaction ,
3218         bytes32 _merkleRoot
3219     ) public onlyRole(ADMIN) {
3220         phaseData[_id].maxSupply = _maxSupply;
3221         phaseData[_id].cost = _cost;
3222         phaseData[_id].maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
3223         phaseData[_id].merkleRoot = _merkleRoot;
3224     }
3225 
3226     function setPhaseId(uint256 _id) public onlyRole(ADMIN) {
3227         phaseId = _id;
3228     }
3229 
3230     function setMintCount(bool _state) public onlyRole(ADMIN) {
3231         mintCount = _state;
3232     }
3233 
3234     function setPause(bool _state) public onlyRole(ADMIN) {
3235         paused = _state;
3236     }
3237 
3238     function setCost(uint256 _newCost) public onlyRole(ADMIN) {
3239         phaseData[phaseId].cost = _newCost;
3240     }
3241 
3242     function setMaxSupply(uint256 _maxSupply) public onlyRole(ADMIN) {
3243         phaseData[phaseId].maxSupply = _maxSupply;
3244     }
3245 
3246     function setMaxMintAmountPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyRole(ADMIN) {
3247         phaseData[phaseId].maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
3248     }
3249 
3250     function setMerkleRoot(bytes32 _merkleRoot) public onlyRole(ADMIN) {
3251         phaseData[phaseId].merkleRoot = _merkleRoot;
3252     }
3253 
3254     function setPublicSaleMaxMintAmountPerAddress(uint256 _publicSaleMaxMintAmountPerAddress) public onlyRole(ADMIN) {
3255         publicSaleMaxMintAmountPerAddress = _publicSaleMaxMintAmountPerAddress;
3256     }
3257 
3258     function setOnlyAllowlisted(bool _state) public onlyRole(ADMIN) {
3259         onlyAllowlisted = _state;
3260     }
3261 
3262 
3263 
3264     //
3265     //interface metadata
3266     //
3267 
3268     iTokenURI public interfaceOfTokenURI;
3269     bool public useInterfaceMetadata = false;
3270 
3271     function setInterfaceOfTokenURI(address _address) public onlyRole(ADMIN) {
3272         interfaceOfTokenURI = iTokenURI(_address);
3273     }
3274 
3275     function setUseInterfaceMetadata(bool _useInterfaceMetadata) public onlyRole(ADMIN) {
3276         useInterfaceMetadata = _useInterfaceMetadata;
3277     }
3278 
3279 
3280     //
3281     //URI section
3282     //
3283 
3284     bool public useOnChainMetadata = false;
3285 
3286     function setUseOnChainMetadata(bool _useOnChainMetadata) public onlyRole(ADMIN) {
3287         useOnChainMetadata = _useOnChainMetadata;
3288     }
3289 
3290     mapping (uint256 => string)  public metadataTitle;
3291     mapping (uint256 => string)  public metadataDescription;
3292     mapping (uint256 => string)  public metadataAttributes;
3293     mapping (uint256 => string)  public imageData;
3294 
3295     bool public useOnChainMetadataWithImageURI = false;
3296 
3297     function setUseOnChainMetadataWithImageURI(bool _useOnChainMetadataWithImageURI) public onlyRole(ADMIN) {
3298         useOnChainMetadataWithImageURI = _useOnChainMetadataWithImageURI;
3299     }
3300 
3301     mapping (uint256 => string)  public imageURI;
3302     mapping (uint256 => bool)    public useAnimationURI;
3303     mapping (uint256 => string)  public animationURI;
3304 
3305 
3306 
3307 
3308     //single image metadata
3309     function setMetadataTitle(uint256 _id , string memory _metadataTitle) public onlyRole(ADMIN) {
3310         metadataTitle[_id] = _metadataTitle;
3311     }
3312     function setMetadataDescription(uint256 _id , string memory _metadataDescription) public onlyRole(ADMIN) {
3313         metadataDescription[_id] = _metadataDescription;
3314     }
3315     function setMetadataAttributes(uint256 _id , string memory _metadataAttributes) public onlyRole(ADMIN) {
3316         metadataAttributes[_id] = _metadataAttributes;
3317     }
3318     function setImageData(uint256 _id , string memory _imageData) public onlyRole(ADMIN) {
3319         imageData[_id] = _imageData;
3320     }
3321 
3322 
3323     function setImageURI(uint256 _id , string memory _imageURI) public onlyRole(ADMIN) {
3324         imageURI[_id] = _imageURI;
3325     }
3326     function setUseAnimationURI(uint256 _id , bool _useAnimationURI) public onlyRole(ADMIN) {
3327         useAnimationURI[_id] = _useAnimationURI;
3328     }
3329     function setAnimationURI(uint256 _id , string memory _animationURI) public onlyRole(ADMIN) {
3330         animationURI[_id] = _animationURI;
3331     }
3332 
3333 
3334 
3335     function setOnChainMetadata(
3336         uint256 _id , 
3337         string memory _metadataTitle, 
3338         string memory _metadataDescription,
3339         string memory _metadataAttributes,
3340         string memory _imageData
3341          )public onlyRole(ADMIN){
3342         setMetadataTitle( _id , _metadataTitle);
3343         setMetadataDescription( _id , _metadataDescription);
3344         setMetadataAttributes( _id , _metadataAttributes);
3345         setImageData( _id , _imageData);
3346     }
3347 
3348     function setOnChainMetadataWithImageURI(
3349         uint256 _id , 
3350         string memory _metadataTitle, 
3351         string memory _metadataDescription,
3352         string memory _metadataAttributes,
3353         string memory _imageURI,
3354         bool _useAnimationURI,
3355         string memory _animationURI
3356          )public onlyRole(ADMIN){
3357         setMetadataTitle( _id , _metadataTitle);
3358         setMetadataDescription( _id , _metadataDescription);
3359         setMetadataAttributes( _id , _metadataAttributes);
3360         setImageURI( _id , _imageURI);
3361         setUseAnimationURI( _id , _useAnimationURI);
3362         setAnimationURI( _id , _animationURI);
3363     }
3364 
3365 
3366     bool public useBaseURI = false;
3367     string public baseURI;
3368     string public baseExtension = ".json";
3369 
3370     function setUseBaseURI(bool _useBaseURI) public onlyRole(ADMIN) {
3371         useBaseURI = _useBaseURI;
3372     }
3373 
3374     function setBaseURI(string memory _newBaseURI) public onlyRole(ADMIN) {
3375         baseURI = _newBaseURI;
3376     }
3377 
3378     function setBaseExtension(string memory _newBaseExtension) public onlyRole(ADMIN) {
3379         baseExtension = _newBaseExtension;
3380     }
3381 
3382 
3383 
3384     function uri(uint256 _id) public override view returns (string memory) {
3385         if( useInterfaceMetadata == true) {
3386             return interfaceOfTokenURI.tokenURI(_id);
3387         }
3388         if( useOnChainMetadata == true ){
3389             return string( abi.encodePacked( 'data:application/json;base64,' , Base64.encode(
3390                 abi.encodePacked(
3391                     '{'
3392                         '"name":"' , metadataTitle[_id] ,'",' ,
3393                         '"description":"' , metadataDescription[_id] ,  '",' ,
3394                         '"image": "data:image/svg+xml;base64,' , imageData[_id] , '",' ,
3395                         '"attributes":[{"trait_type":"type","value":"' , metadataAttributes[_id] , '"}]',
3396                     '}'
3397                 )
3398             ) ) );
3399         }
3400         if(useOnChainMetadataWithImageURI == true){
3401             return string( abi.encodePacked( 'data:application/json;base64,' , Base64.encode(
3402                 abi.encodePacked(
3403                     '{',
3404                         '"name":"' , metadataTitle[_id] ,'",' ,
3405                         '"description":"' , metadataDescription[_id] ,  '",' ,
3406                         '"image": "' , imageURI[_id] , '",' ,
3407                         useAnimationURI[_id]==true ? string(abi.encodePacked('"animation_url": "' , animationURI[_id] , '",')) :"" ,
3408                         '"attributes":[{"trait_type":"type","value":"' , metadataAttributes[_id] , '"}]',
3409                     '}'
3410                 )
3411             ) ) );
3412         }
3413         if( useBaseURI == true) {
3414             return string(abi.encodePacked( baseURI, _id.toString(), baseExtension));
3415         }        
3416         return tokenURIs[_id];
3417     }
3418 
3419     function setURI(uint _id, string memory _uri) external onlyRole(ADMIN) {
3420         tokenURIs[_id] = _uri;
3421         emit URI(_uri, _id);
3422     }
3423 
3424 
3425 
3426     //
3427     //burnin' section
3428     //
3429 
3430     bytes32 public constant MINTER_ROLE  = keccak256("MINTER_ROLE");
3431 
3432     function externalMint(address _address , uint256 _amount ) external payable onlyRole(MINTER_ROLE){
3433         phaseData[phaseId].totalSupply += _amount;
3434         _mint(_address, phaseId, _amount, "");
3435     }
3436 
3437     function externalMintWithPhaseId(address _address , uint256 _amount , uint256 _phaseId ) external payable onlyRole(MINTER_ROLE){
3438         phaseData[_phaseId].totalSupply += _amount;
3439         _mint(_address, _phaseId, _amount, "");
3440     }
3441 
3442 
3443 
3444     //
3445     //1155 owner mint section iranai kamo
3446     //
3447 
3448     function ownermint(address _to, uint _id, uint _amount) external onlyOwner {
3449         _mint(_to, _id, _amount, "");
3450     }
3451 
3452     function mintBatch(address _to, uint[] memory _ids, uint[] memory _amounts) external onlyOwner {
3453         _mintBatch(_to, _ids, _amounts, "");
3454     }
3455 
3456     function burn(uint _id, uint _amount) external {
3457         _burn(msg.sender, _id, _amount);
3458     }
3459 
3460     function burnBatch(uint[] memory _ids, uint[] memory _amounts) external {
3461         _burnBatch(msg.sender, _ids, _amounts);
3462     }
3463 
3464     function burnForMint(address _from, uint[] memory _burnIds, uint[] memory _burnAmounts, uint[] memory _mintIds, uint[] memory _mintAmounts) external onlyOwner {
3465         _burnBatch(_from, _burnIds, _burnAmounts);
3466         _mintBatch(_from, _mintIds, _mintAmounts, "");
3467     }
3468 
3469 
3470 
3471     //
3472     //return phase data
3473     //
3474 
3475     function merkleRoot() external view returns(bytes32) {
3476         return phaseData[phaseId].merkleRoot;
3477     }
3478 
3479     function maxSupply() external view returns(uint256){
3480         return phaseData[phaseId].maxSupply;
3481     }
3482 
3483     function totalSupply() external view returns(uint256){
3484         return phaseData[phaseId].totalSupply;
3485     }
3486 
3487     function maxMintAmountPerTransaction() external view returns(uint256){
3488         return phaseData[phaseId].maxMintAmountPerTransaction;
3489     }
3490 
3491     function cost() external view returns(uint256){
3492         return phaseData[phaseId].cost;
3493     }
3494 
3495     function getAllowlistUserAmount(address /*_address*/ ) public pure returns(uint256){
3496         return 0;
3497     }
3498 
3499     function allowlistType() public pure returns(uint256){
3500         return 0;
3501     }    
3502 
3503     function getUserMintedAmount(address _address ) public view returns(uint256){
3504         return phaseData[phaseId].userMintedAmount[_address];
3505     }
3506 
3507 
3508 
3509     //
3510     //sbt and opensea filter section
3511     //
3512 
3513     bool public isSBT = false;
3514 
3515     function setIsSBT(bool _state) public onlyRole(ADMIN) {
3516         isSBT = _state;
3517     }
3518 
3519     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperatorApproval(operator) {
3520         require( isSBT == false || approved == false , "setApprovalForAll is prohibited");
3521         require(
3522             _isAllowed(operator) || approved == false,
3523             "RestrictApprove: Can not approve locked token"
3524         );
3525         super.setApprovalForAll(operator, approved);
3526     }
3527 
3528     function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
3529         public
3530         override
3531         onlyAllowedOperator(from)
3532     {
3533         super.safeTransferFrom(from, to, tokenId, amount, data);
3534     }
3535 
3536     function safeBatchTransferFrom(
3537         address from,
3538         address to,
3539         uint256[] memory ids,
3540         uint256[] memory amounts,
3541         bytes memory data
3542     ) public virtual override onlyAllowedOperator(from) {
3543         super.safeBatchTransferFrom(from, to, ids, amounts, data);
3544     }
3545 
3546     function _beforeTokenTransfer(
3547         address operator,
3548         address from,
3549         address to,
3550         uint256[] memory ids,
3551         uint256[] memory amounts,
3552         bytes memory data
3553     ) internal virtual override{
3554         require( isSBT == false ||
3555             from == address(0) || 
3556             to == address(0)|| 
3557             to == address(0x000000000000000000000000000000000000dEaD), 
3558             "transfer is prohibited");
3559         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
3560     }
3561 
3562     function owner() public view virtual override(Ownable, UpdatableOperatorFilterer) returns (address) {
3563         return Ownable.owner();
3564     }
3565 
3566 
3567     //
3568     //setDefaultRoyalty
3569     //
3570     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner{
3571         _setDefaultRoyalty(_receiver, _feeNumerator);
3572     }
3573 
3574 
3575 
3576 
3577     // ==================================================================
3578     // Ristrict Approve
3579     // ==================================================================
3580 
3581     using EnumerableSet for EnumerableSet.AddressSet;
3582 
3583     IContractAllowListProxy public cal;
3584     EnumerableSet.AddressSet localAllowedAddresses;
3585     uint256 public calLevel = 1;
3586     bool public enableRestrict = true;
3587 
3588     function setEnebleRestrict(bool _enableRestrict )public onlyRole(ADMIN){
3589         enableRestrict = _enableRestrict;
3590     }
3591 
3592 
3593     function addLocalContractAllowList(address transferer)
3594         public
3595         onlyRole(ADMIN)
3596     {
3597         localAllowedAddresses.add(transferer);
3598     }
3599 
3600     function removeLocalContractAllowList(address transferer)
3601         external
3602         onlyRole(ADMIN)
3603     {
3604         localAllowedAddresses.remove(transferer);
3605     }
3606 
3607     function getLocalContractAllowList()
3608         external
3609         view
3610         returns (address[] memory)
3611     {
3612         return localAllowedAddresses.values();
3613     }
3614 
3615     function _isLocalAllowed(address transferer)
3616         internal
3617         view
3618         virtual
3619         returns (bool)
3620     {
3621         return localAllowedAddresses.contains(transferer);
3622     }
3623 
3624     function _isAllowed(address transferer)
3625         internal
3626         view
3627         virtual
3628         returns (bool)
3629     {
3630         if(enableRestrict == false) {
3631             return true;
3632         }
3633 
3634         return
3635             _isLocalAllowed(transferer) || cal.isAllowed(transferer, calLevel);
3636     }
3637 
3638     function setCAL(address value) public onlyRole(ADMIN) {
3639         cal = IContractAllowListProxy(value);
3640     }
3641 
3642     function setCALLevel(uint256 value) public onlyRole(ADMIN) {
3643         calLevel = value;
3644     }
3645 
3646 
3647 
3648 
3649 
3650     //
3651     //support interface override
3652     //
3653     function supportsInterface(bytes4 interfaceId)
3654         public
3655         view
3656         override(ERC2981,ERC1155,AccessControl)
3657         returns (bool)
3658     {
3659         return
3660             ERC2981.supportsInterface(interfaceId) ||
3661             AccessControl.supportsInterface(interfaceId) ||
3662             ERC1155.supportsInterface(interfaceId) ;
3663     }
3664 
3665 }