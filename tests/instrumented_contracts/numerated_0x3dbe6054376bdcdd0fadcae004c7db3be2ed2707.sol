1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
5 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
6 
7 pragma solidity ^0.8.0;
8 
9 
10 /*
11         GGGGGGGGGGGGGEEEEEEEEEEEEEEEEEEEEEEMMMMMMMM               MMMMMMMMEEEEEEEEEEEEEEEEEEEEEE   SSSSSSSSSSSSSSS IIIIIIIIII   SSSSSSSSSSSSSSS 
12      GGG::::::::::::GE::::::::::::::::::::EM:::::::M             M:::::::ME::::::::::::::::::::E SS:::::::::::::::SI::::::::I SS:::::::::::::::S
13    GG:::::::::::::::GE::::::::::::::::::::EM::::::::M           M::::::::ME::::::::::::::::::::ES:::::SSSSSS::::::SI::::::::IS:::::SSSSSS::::::S
14   G:::::GGGGGGGG::::GEE::::::EEEEEEEEE::::EM:::::::::M         M:::::::::MEE::::::EEEEEEEEE::::ES:::::S     SSSSSSSII::::::IIS:::::S     SSSSSSS
15  G:::::G       GGGGGG  E:::::E       EEEEEEM::::::::::M       M::::::::::M  E:::::E       EEEEEES:::::S              I::::I  S:::::S            
16 G:::::G                E:::::E             M:::::::::::M     M:::::::::::M  E:::::E             S:::::S              I::::I  S:::::S            
17 G:::::G                E::::::EEEEEEEEEE   M:::::::M::::M   M::::M:::::::M  E::::::EEEEEEEEEE    S::::SSSS           I::::I   S::::SSSS         
18 G:::::G    GGGGGGGGGG  E:::::::::::::::E   M::::::M M::::M M::::M M::::::M  E:::::::::::::::E     SS::::::SSSSS      I::::I    SS::::::SSSSS    
19 G:::::G    G::::::::G  E:::::::::::::::E   M::::::M  M::::M::::M  M::::::M  E:::::::::::::::E       SSS::::::::SS    I::::I      SSS::::::::SS  
20 G:::::G    GGGGG::::G  E::::::EEEEEEEEEE   M::::::M   M:::::::M   M::::::M  E::::::EEEEEEEEEE          SSSSSS::::S   I::::I         SSSSSS::::S 
21 G:::::G        G::::G  E:::::E             M::::::M    M:::::M    M::::::M  E:::::E                         S:::::S  I::::I              S:::::S
22  G:::::G       G::::G  E:::::E       EEEEEEM::::::M     MMMMM     M::::::M  E:::::E       EEEEEE            S:::::S  I::::I              S:::::S
23   G:::::GGGGGGGG::::GEE::::::EEEEEEEE:::::EM::::::M               M::::::MEE::::::EEEEEEEE:::::ESSSSSSS     S:::::SII::::::IISSSSSSS     S:::::S
24    GG:::::::::::::::GE::::::::::::::::::::EM::::::M               M::::::ME::::::::::::::::::::ES::::::SSSSSS:::::SI::::::::IS::::::SSSSSS:::::S
25      GGG::::::GGG:::GE::::::::::::::::::::EM::::::M               M::::::ME::::::::::::::::::::ES:::::::::::::::SS I::::::::IS:::::::::::::::SS 
26         GGGGGG   GGGGEEEEEEEEEEEEEEEEEEEEEEMMMMMMMM               MMMMMMMMEEEEEEEEEEEEEEEEEEEEEE SSSSSSSSSSSSSSS   IIIIIIIIII SSSSSSSSSSSSSSS   
27         
28         BY JOHNATHAN SCHULTZ
29 */
30 
31 /**
32  * @dev Library for managing
33  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
34  * types.
35  *
36  * Sets have the following properties:
37  *
38  * - Elements are added, removed, and checked for existence in constant time
39  * (O(1)).
40  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
41  *
42  * ```
43  * contract Example {
44  *     // Add the library methods
45  *     using EnumerableSet for EnumerableSet.AddressSet;
46  *
47  *     // Declare a set state variable
48  *     EnumerableSet.AddressSet private mySet;
49  * }
50  * ```
51  *
52  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
53  * and `uint256` (`UintSet`) are supported.
54  *
55  * [WARNING]
56  * ====
57  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
58  * unusable.
59  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
60  *
61  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
62  * array of EnumerableSet.
63  * ====
64  */
65 library EnumerableSet {
66     // To implement this library for multiple types with as little code
67     // repetition as possible, we write it in terms of a generic Set type with
68     // bytes32 values.
69     // The Set implementation uses private functions, and user-facing
70     // implementations (such as AddressSet) are just wrappers around the
71     // underlying Set.
72     // This means that we can only create new EnumerableSets for types that fit
73     // in bytes32.
74 
75     struct Set {
76         // Storage of set values
77         bytes32[] _values;
78         // Position of the value in the `values` array, plus 1 because index 0
79         // means a value is not in the set.
80         mapping(bytes32 => uint256) _indexes;
81     }
82 
83     /**
84      * @dev Add a value to a set. O(1).
85      *
86      * Returns true if the value was added to the set, that is if it was not
87      * already present.
88      */
89     function _add(Set storage set, bytes32 value) private returns (bool) {
90         if (!_contains(set, value)) {
91             set._values.push(value);
92             // The value is stored at length-1, but we add 1 to all indexes
93             // and use 0 as a sentinel value
94             set._indexes[value] = set._values.length;
95             return true;
96         } else {
97             return false;
98         }
99     }
100 
101     /**
102      * @dev Removes a value from a set. O(1).
103      *
104      * Returns true if the value was removed from the set, that is if it was
105      * present.
106      */
107     function _remove(Set storage set, bytes32 value) private returns (bool) {
108         // We read and store the value's index to prevent multiple reads from the same storage slot
109         uint256 valueIndex = set._indexes[value];
110 
111         if (valueIndex != 0) {
112             // Equivalent to contains(set, value)
113             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
114             // the array, and then remove the last element (sometimes called as 'swap and pop').
115             // This modifies the order of the array, as noted in {at}.
116 
117             uint256 toDeleteIndex = valueIndex - 1;
118             uint256 lastIndex = set._values.length - 1;
119 
120             if (lastIndex != toDeleteIndex) {
121                 bytes32 lastValue = set._values[lastIndex];
122 
123                 // Move the last value to the index where the value to delete is
124                 set._values[toDeleteIndex] = lastValue;
125                 // Update the index for the moved value
126                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
127             }
128 
129             // Delete the slot where the moved value was stored
130             set._values.pop();
131 
132             // Delete the index for the deleted slot
133             delete set._indexes[value];
134 
135             return true;
136         } else {
137             return false;
138         }
139     }
140 
141     /**
142      * @dev Returns true if the value is in the set. O(1).
143      */
144     function _contains(Set storage set, bytes32 value) private view returns (bool) {
145         return set._indexes[value] != 0;
146     }
147 
148     /**
149      * @dev Returns the number of values on the set. O(1).
150      */
151     function _length(Set storage set) private view returns (uint256) {
152         return set._values.length;
153     }
154 
155     /**
156      * @dev Returns the value stored at position `index` in the set. O(1).
157      *
158      * Note that there are no guarantees on the ordering of values inside the
159      * array, and it may change when more values are added or removed.
160      *
161      * Requirements:
162      *
163      * - `index` must be strictly less than {length}.
164      */
165     function _at(Set storage set, uint256 index) private view returns (bytes32) {
166         return set._values[index];
167     }
168 
169     /**
170      * @dev Return the entire set in an array
171      *
172      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
173      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
174      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
175      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
176      */
177     function _values(Set storage set) private view returns (bytes32[] memory) {
178         return set._values;
179     }
180 
181     // Bytes32Set
182 
183     struct Bytes32Set {
184         Set _inner;
185     }
186 
187     /**
188      * @dev Add a value to a set. O(1).
189      *
190      * Returns true if the value was added to the set, that is if it was not
191      * already present.
192      */
193     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
194         return _add(set._inner, value);
195     }
196 
197     /**
198      * @dev Removes a value from a set. O(1).
199      *
200      * Returns true if the value was removed from the set, that is if it was
201      * present.
202      */
203     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
204         return _remove(set._inner, value);
205     }
206 
207     /**
208      * @dev Returns true if the value is in the set. O(1).
209      */
210     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
211         return _contains(set._inner, value);
212     }
213 
214     /**
215      * @dev Returns the number of values in the set. O(1).
216      */
217     function length(Bytes32Set storage set) internal view returns (uint256) {
218         return _length(set._inner);
219     }
220 
221     /**
222      * @dev Returns the value stored at position `index` in the set. O(1).
223      *
224      * Note that there are no guarantees on the ordering of values inside the
225      * array, and it may change when more values are added or removed.
226      *
227      * Requirements:
228      *
229      * - `index` must be strictly less than {length}.
230      */
231     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
232         return _at(set._inner, index);
233     }
234 
235     /**
236      * @dev Return the entire set in an array
237      *
238      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
239      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
240      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
241      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
242      */
243     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
244         bytes32[] memory store = _values(set._inner);
245         bytes32[] memory result;
246 
247         /// @solidity memory-safe-assembly
248         assembly {
249             result := store
250         }
251 
252         return result;
253     }
254 
255     // AddressSet
256 
257     struct AddressSet {
258         Set _inner;
259     }
260 
261     /**
262      * @dev Add a value to a set. O(1).
263      *
264      * Returns true if the value was added to the set, that is if it was not
265      * already present.
266      */
267     function add(AddressSet storage set, address value) internal returns (bool) {
268         return _add(set._inner, bytes32(uint256(uint160(value))));
269     }
270 
271     /**
272      * @dev Removes a value from a set. O(1).
273      *
274      * Returns true if the value was removed from the set, that is if it was
275      * present.
276      */
277     function remove(AddressSet storage set, address value) internal returns (bool) {
278         return _remove(set._inner, bytes32(uint256(uint160(value))));
279     }
280 
281     /**
282      * @dev Returns true if the value is in the set. O(1).
283      */
284     function contains(AddressSet storage set, address value) internal view returns (bool) {
285         return _contains(set._inner, bytes32(uint256(uint160(value))));
286     }
287 
288     /**
289      * @dev Returns the number of values in the set. O(1).
290      */
291     function length(AddressSet storage set) internal view returns (uint256) {
292         return _length(set._inner);
293     }
294 
295     /**
296      * @dev Returns the value stored at position `index` in the set. O(1).
297      *
298      * Note that there are no guarantees on the ordering of values inside the
299      * array, and it may change when more values are added or removed.
300      *
301      * Requirements:
302      *
303      * - `index` must be strictly less than {length}.
304      */
305     function at(AddressSet storage set, uint256 index) internal view returns (address) {
306         return address(uint160(uint256(_at(set._inner, index))));
307     }
308 
309     /**
310      * @dev Return the entire set in an array
311      *
312      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
313      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
314      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
315      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
316      */
317     function values(AddressSet storage set) internal view returns (address[] memory) {
318         bytes32[] memory store = _values(set._inner);
319         address[] memory result;
320 
321         /// @solidity memory-safe-assembly
322         assembly {
323             result := store
324         }
325 
326         return result;
327     }
328 
329     // UintSet
330 
331     struct UintSet {
332         Set _inner;
333     }
334 
335     /**
336      * @dev Add a value to a set. O(1).
337      *
338      * Returns true if the value was added to the set, that is if it was not
339      * already present.
340      */
341     function add(UintSet storage set, uint256 value) internal returns (bool) {
342         return _add(set._inner, bytes32(value));
343     }
344 
345     /**
346      * @dev Removes a value from a set. O(1).
347      *
348      * Returns true if the value was removed from the set, that is if it was
349      * present.
350      */
351     function remove(UintSet storage set, uint256 value) internal returns (bool) {
352         return _remove(set._inner, bytes32(value));
353     }
354 
355     /**
356      * @dev Returns true if the value is in the set. O(1).
357      */
358     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
359         return _contains(set._inner, bytes32(value));
360     }
361 
362     /**
363      * @dev Returns the number of values in the set. O(1).
364      */
365     function length(UintSet storage set) internal view returns (uint256) {
366         return _length(set._inner);
367     }
368 
369     /**
370      * @dev Returns the value stored at position `index` in the set. O(1).
371      *
372      * Note that there are no guarantees on the ordering of values inside the
373      * array, and it may change when more values are added or removed.
374      *
375      * Requirements:
376      *
377      * - `index` must be strictly less than {length}.
378      */
379     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
380         return uint256(_at(set._inner, index));
381     }
382 
383     /**
384      * @dev Return the entire set in an array
385      *
386      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
387      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
388      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
389      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
390      */
391     function values(UintSet storage set) internal view returns (uint256[] memory) {
392         bytes32[] memory store = _values(set._inner);
393         uint256[] memory result;
394 
395         /// @solidity memory-safe-assembly
396         assembly {
397             result := store
398         }
399 
400         return result;
401     }
402 }
403 
404 // File: contracts/IOperatorFilterRegistry.sol
405 
406 
407 pragma solidity ^0.8.13;
408 
409 
410 interface IOperatorFilterRegistry {
411     function isOperatorAllowed(address registrant, address operator) external returns (bool);
412     function register(address registrant) external;
413     function registerAndSubscribe(address registrant, address subscription) external;
414     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
415     function updateOperator(address registrant, address operator, bool filtered) external;
416     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
417     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
418     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
419     function subscribe(address registrant, address registrantToSubscribe) external;
420     function unsubscribe(address registrant, bool copyExistingEntries) external;
421     function subscriptionOf(address addr) external returns (address registrant);
422     function subscribers(address registrant) external returns (address[] memory);
423     function subscriberAt(address registrant, uint256 index) external returns (address);
424     function copyEntriesOf(address registrant, address registrantToCopy) external;
425     function isOperatorFiltered(address registrant, address operator) external returns (bool);
426     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
427     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
428     function filteredOperators(address addr) external returns (address[] memory);
429     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
430     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
431     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
432     function isRegistered(address addr) external returns (bool);
433     function codeHashOf(address addr) external returns (bytes32);
434 }
435 // File: contracts/OperatorFilterer.sol
436 
437 
438 pragma solidity ^0.8.13;
439 
440 
441 /**
442  * @title  OperatorFilterer
443  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
444  *         registrant's entries in the OperatorFilterRegistry.
445  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
446  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
447  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
448  */
449 abstract contract OperatorFilterer {
450     error OperatorNotAllowed(address operator);
451 
452     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
453         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
454 
455     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
456         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
457         // will not revert, but the contract will need to be registered with the registry once it is deployed in
458         // order for the modifier to filter addresses.
459         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
460             if (subscribe) {
461                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
462             } else {
463                 if (subscriptionOrRegistrantToCopy != address(0)) {
464                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
465                 } else {
466                     OPERATOR_FILTER_REGISTRY.register(address(this));
467                 }
468             }
469         }
470     }
471 
472     modifier onlyAllowedOperator(address from) virtual {
473         // Allow spending tokens from addresses with balance
474         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
475         // from an EOA.
476         if (from != msg.sender) {
477             _checkFilterOperator(msg.sender);
478         }
479         _;
480     }
481 
482     modifier onlyAllowedOperatorApproval(address operator) virtual {
483         _checkFilterOperator(operator);
484         _;
485     }
486 
487     function _checkFilterOperator(address operator) internal virtual {
488         // Check registry code length to facilitate testing in environments without a deployed registry.
489         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
490             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
491                 revert OperatorNotAllowed(operator);
492             }
493         }
494     }
495 }
496 // File: contracts/DefaultOperatorFilterer.sol
497 
498 
499 pragma solidity ^0.8.13;
500 
501 
502 contract DefaultOperatorFilterer is OperatorFilterer {
503     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
504 
505     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
506 }
507 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Contract module that helps prevent reentrant calls to a function.
516  *
517  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
518  * available, which can be applied to functions to make sure there are no nested
519  * (reentrant) calls to them.
520  *
521  * Note that because there is a single `nonReentrant` guard, functions marked as
522  * `nonReentrant` may not call one another. This can be worked around by making
523  * those functions `private`, and then adding `external` `nonReentrant` entry
524  * points to them.
525  *
526  * TIP: If you would like to learn more about reentrancy and alternative ways
527  * to protect against it, check out our blog post
528  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
529  */
530 abstract contract ReentrancyGuard {
531     // Booleans are more expensive than uint256 or any type that takes up a full
532     // word because each write operation emits an extra SLOAD to first read the
533     // slot's contents, replace the bits taken up by the boolean, and then write
534     // back. This is the compiler's defense against contract upgrades and
535     // pointer aliasing, and it cannot be disabled.
536 
537     // The values being non-zero value makes deployment a bit more expensive,
538     // but in exchange the refund on every call to nonReentrant will be lower in
539     // amount. Since refunds are capped to a percentage of the total
540     // transaction's gas, it is best to keep them low in cases like this one, to
541     // increase the likelihood of the full refund coming into effect.
542     uint256 private constant _NOT_ENTERED = 1;
543     uint256 private constant _ENTERED = 2;
544 
545     uint256 private _status;
546 
547     constructor() {
548         _status = _NOT_ENTERED;
549     }
550 
551     /**
552      * @dev Prevents a contract from calling itself, directly or indirectly.
553      * Calling a `nonReentrant` function from another `nonReentrant`
554      * function is not supported. It is possible to prevent this from happening
555      * by making the `nonReentrant` function external, and making it call a
556      * `private` function that does the actual work.
557      */
558     modifier nonReentrant() {
559         _nonReentrantBefore();
560         _;
561         _nonReentrantAfter();
562     }
563 
564     function _nonReentrantBefore() private {
565         // On the first call to nonReentrant, _status will be _NOT_ENTERED
566         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
567 
568         // Any calls to nonReentrant after this point will fail
569         _status = _ENTERED;
570     }
571 
572     function _nonReentrantAfter() private {
573         // By storing the original value once again, a refund is triggered (see
574         // https://eips.ethereum.org/EIPS/eip-2200)
575         _status = _NOT_ENTERED;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 /**
587  * @dev These functions deal with verification of Merkle Tree proofs.
588  *
589  * The tree and the proofs can be generated using our
590  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
591  * You will find a quickstart guide in the readme.
592  *
593  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
594  * hashing, or use a hash function other than keccak256 for hashing leaves.
595  * This is because the concatenation of a sorted pair of internal nodes in
596  * the merkle tree could be reinterpreted as a leaf value.
597  * OpenZeppelin's JavaScript library generates merkle trees that are safe
598  * against this attack out of the box.
599  */
600 library MerkleProof {
601     /**
602      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
603      * defined by `root`. For this, a `proof` must be provided, containing
604      * sibling hashes on the branch from the leaf to the root of the tree. Each
605      * pair of leaves and each pair of pre-images are assumed to be sorted.
606      */
607     function verify(
608         bytes32[] memory proof,
609         bytes32 root,
610         bytes32 leaf
611     ) internal pure returns (bool) {
612         return processProof(proof, leaf) == root;
613     }
614 
615     /**
616      * @dev Calldata version of {verify}
617      *
618      * _Available since v4.7._
619      */
620     function verifyCalldata(
621         bytes32[] calldata proof,
622         bytes32 root,
623         bytes32 leaf
624     ) internal pure returns (bool) {
625         return processProofCalldata(proof, leaf) == root;
626     }
627 
628     /**
629      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
630      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
631      * hash matches the root of the tree. When processing the proof, the pairs
632      * of leafs & pre-images are assumed to be sorted.
633      *
634      * _Available since v4.4._
635      */
636     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
637         bytes32 computedHash = leaf;
638         for (uint256 i = 0; i < proof.length; i++) {
639             computedHash = _hashPair(computedHash, proof[i]);
640         }
641         return computedHash;
642     }
643 
644     /**
645      * @dev Calldata version of {processProof}
646      *
647      * _Available since v4.7._
648      */
649     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
650         bytes32 computedHash = leaf;
651         for (uint256 i = 0; i < proof.length; i++) {
652             computedHash = _hashPair(computedHash, proof[i]);
653         }
654         return computedHash;
655     }
656 
657     /**
658      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
659      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
660      *
661      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
662      *
663      * _Available since v4.7._
664      */
665     function multiProofVerify(
666         bytes32[] memory proof,
667         bool[] memory proofFlags,
668         bytes32 root,
669         bytes32[] memory leaves
670     ) internal pure returns (bool) {
671         return processMultiProof(proof, proofFlags, leaves) == root;
672     }
673 
674     /**
675      * @dev Calldata version of {multiProofVerify}
676      *
677      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
678      *
679      * _Available since v4.7._
680      */
681     function multiProofVerifyCalldata(
682         bytes32[] calldata proof,
683         bool[] calldata proofFlags,
684         bytes32 root,
685         bytes32[] memory leaves
686     ) internal pure returns (bool) {
687         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
688     }
689 
690     /**
691      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
692      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
693      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
694      * respectively.
695      *
696      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
697      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
698      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
699      *
700      * _Available since v4.7._
701      */
702     function processMultiProof(
703         bytes32[] memory proof,
704         bool[] memory proofFlags,
705         bytes32[] memory leaves
706     ) internal pure returns (bytes32 merkleRoot) {
707         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
708         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
709         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
710         // the merkle tree.
711         uint256 leavesLen = leaves.length;
712         uint256 totalHashes = proofFlags.length;
713 
714         // Check proof validity.
715         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
716 
717         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
718         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
719         bytes32[] memory hashes = new bytes32[](totalHashes);
720         uint256 leafPos = 0;
721         uint256 hashPos = 0;
722         uint256 proofPos = 0;
723         // At each step, we compute the next hash using two values:
724         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
725         //   get the next hash.
726         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
727         //   `proof` array.
728         for (uint256 i = 0; i < totalHashes; i++) {
729             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
730             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
731             hashes[i] = _hashPair(a, b);
732         }
733 
734         if (totalHashes > 0) {
735             return hashes[totalHashes - 1];
736         } else if (leavesLen > 0) {
737             return leaves[0];
738         } else {
739             return proof[0];
740         }
741     }
742 
743     /**
744      * @dev Calldata version of {processMultiProof}.
745      *
746      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
747      *
748      * _Available since v4.7._
749      */
750     function processMultiProofCalldata(
751         bytes32[] calldata proof,
752         bool[] calldata proofFlags,
753         bytes32[] memory leaves
754     ) internal pure returns (bytes32 merkleRoot) {
755         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
756         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
757         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
758         // the merkle tree.
759         uint256 leavesLen = leaves.length;
760         uint256 totalHashes = proofFlags.length;
761 
762         // Check proof validity.
763         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
764 
765         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
766         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
767         bytes32[] memory hashes = new bytes32[](totalHashes);
768         uint256 leafPos = 0;
769         uint256 hashPos = 0;
770         uint256 proofPos = 0;
771         // At each step, we compute the next hash using two values:
772         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
773         //   get the next hash.
774         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
775         //   `proof` array.
776         for (uint256 i = 0; i < totalHashes; i++) {
777             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
778             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
779             hashes[i] = _hashPair(a, b);
780         }
781 
782         if (totalHashes > 0) {
783             return hashes[totalHashes - 1];
784         } else if (leavesLen > 0) {
785             return leaves[0];
786         } else {
787             return proof[0];
788         }
789     }
790 
791     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
792         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
793     }
794 
795     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
796         /// @solidity memory-safe-assembly
797         assembly {
798             mstore(0x00, a)
799             mstore(0x20, b)
800             value := keccak256(0x00, 0x40)
801         }
802     }
803 }
804 
805 // File: @openzeppelin/contracts/utils/math/Math.sol
806 
807 
808 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 /**
813  * @dev Standard math utilities missing in the Solidity language.
814  */
815 library Math {
816     enum Rounding {
817         Down, // Toward negative infinity
818         Up, // Toward infinity
819         Zero // Toward zero
820     }
821 
822     /**
823      * @dev Returns the largest of two numbers.
824      */
825     function max(uint256 a, uint256 b) internal pure returns (uint256) {
826         return a > b ? a : b;
827     }
828 
829     /**
830      * @dev Returns the smallest of two numbers.
831      */
832     function min(uint256 a, uint256 b) internal pure returns (uint256) {
833         return a < b ? a : b;
834     }
835 
836     /**
837      * @dev Returns the average of two numbers. The result is rounded towards
838      * zero.
839      */
840     function average(uint256 a, uint256 b) internal pure returns (uint256) {
841         // (a + b) / 2 can overflow.
842         return (a & b) + (a ^ b) / 2;
843     }
844 
845     /**
846      * @dev Returns the ceiling of the division of two numbers.
847      *
848      * This differs from standard division with `/` in that it rounds up instead
849      * of rounding down.
850      */
851     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
852         // (a + b - 1) / b can overflow on addition, so we distribute.
853         return a == 0 ? 0 : (a - 1) / b + 1;
854     }
855 
856     /**
857      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
858      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
859      * with further edits by Uniswap Labs also under MIT license.
860      */
861     function mulDiv(
862         uint256 x,
863         uint256 y,
864         uint256 denominator
865     ) internal pure returns (uint256 result) {
866         unchecked {
867             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
868             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
869             // variables such that product = prod1 * 2^256 + prod0.
870             uint256 prod0; // Least significant 256 bits of the product
871             uint256 prod1; // Most significant 256 bits of the product
872             assembly {
873                 let mm := mulmod(x, y, not(0))
874                 prod0 := mul(x, y)
875                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
876             }
877 
878             // Handle non-overflow cases, 256 by 256 division.
879             if (prod1 == 0) {
880                 return prod0 / denominator;
881             }
882 
883             // Make sure the result is less than 2^256. Also prevents denominator == 0.
884             require(denominator > prod1);
885 
886             ///////////////////////////////////////////////
887             // 512 by 256 division.
888             ///////////////////////////////////////////////
889 
890             // Make division exact by subtracting the remainder from [prod1 prod0].
891             uint256 remainder;
892             assembly {
893                 // Compute remainder using mulmod.
894                 remainder := mulmod(x, y, denominator)
895 
896                 // Subtract 256 bit number from 512 bit number.
897                 prod1 := sub(prod1, gt(remainder, prod0))
898                 prod0 := sub(prod0, remainder)
899             }
900 
901             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
902             // See https://cs.stackexchange.com/q/138556/92363.
903 
904             // Does not overflow because the denominator cannot be zero at this stage in the function.
905             uint256 twos = denominator & (~denominator + 1);
906             assembly {
907                 // Divide denominator by twos.
908                 denominator := div(denominator, twos)
909 
910                 // Divide [prod1 prod0] by twos.
911                 prod0 := div(prod0, twos)
912 
913                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
914                 twos := add(div(sub(0, twos), twos), 1)
915             }
916 
917             // Shift in bits from prod1 into prod0.
918             prod0 |= prod1 * twos;
919 
920             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
921             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
922             // four bits. That is, denominator * inv = 1 mod 2^4.
923             uint256 inverse = (3 * denominator) ^ 2;
924 
925             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
926             // in modular arithmetic, doubling the correct bits in each step.
927             inverse *= 2 - denominator * inverse; // inverse mod 2^8
928             inverse *= 2 - denominator * inverse; // inverse mod 2^16
929             inverse *= 2 - denominator * inverse; // inverse mod 2^32
930             inverse *= 2 - denominator * inverse; // inverse mod 2^64
931             inverse *= 2 - denominator * inverse; // inverse mod 2^128
932             inverse *= 2 - denominator * inverse; // inverse mod 2^256
933 
934             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
935             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
936             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
937             // is no longer required.
938             result = prod0 * inverse;
939             return result;
940         }
941     }
942 
943     /**
944      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
945      */
946     function mulDiv(
947         uint256 x,
948         uint256 y,
949         uint256 denominator,
950         Rounding rounding
951     ) internal pure returns (uint256) {
952         uint256 result = mulDiv(x, y, denominator);
953         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
954             result += 1;
955         }
956         return result;
957     }
958 
959     /**
960      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
961      *
962      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
963      */
964     function sqrt(uint256 a) internal pure returns (uint256) {
965         if (a == 0) {
966             return 0;
967         }
968 
969         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
970         //
971         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
972         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
973         //
974         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
975         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
976         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
977         //
978         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
979         uint256 result = 1 << (log2(a) >> 1);
980 
981         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
982         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
983         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
984         // into the expected uint128 result.
985         unchecked {
986             result = (result + a / result) >> 1;
987             result = (result + a / result) >> 1;
988             result = (result + a / result) >> 1;
989             result = (result + a / result) >> 1;
990             result = (result + a / result) >> 1;
991             result = (result + a / result) >> 1;
992             result = (result + a / result) >> 1;
993             return min(result, a / result);
994         }
995     }
996 
997     /**
998      * @notice Calculates sqrt(a), following the selected rounding direction.
999      */
1000     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1001         unchecked {
1002             uint256 result = sqrt(a);
1003             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1004         }
1005     }
1006 
1007     /**
1008      * @dev Return the log in base 2, rounded down, of a positive value.
1009      * Returns 0 if given 0.
1010      */
1011     function log2(uint256 value) internal pure returns (uint256) {
1012         uint256 result = 0;
1013         unchecked {
1014             if (value >> 128 > 0) {
1015                 value >>= 128;
1016                 result += 128;
1017             }
1018             if (value >> 64 > 0) {
1019                 value >>= 64;
1020                 result += 64;
1021             }
1022             if (value >> 32 > 0) {
1023                 value >>= 32;
1024                 result += 32;
1025             }
1026             if (value >> 16 > 0) {
1027                 value >>= 16;
1028                 result += 16;
1029             }
1030             if (value >> 8 > 0) {
1031                 value >>= 8;
1032                 result += 8;
1033             }
1034             if (value >> 4 > 0) {
1035                 value >>= 4;
1036                 result += 4;
1037             }
1038             if (value >> 2 > 0) {
1039                 value >>= 2;
1040                 result += 2;
1041             }
1042             if (value >> 1 > 0) {
1043                 result += 1;
1044             }
1045         }
1046         return result;
1047     }
1048 
1049     /**
1050      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1051      * Returns 0 if given 0.
1052      */
1053     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1054         unchecked {
1055             uint256 result = log2(value);
1056             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1057         }
1058     }
1059 
1060     /**
1061      * @dev Return the log in base 10, rounded down, of a positive value.
1062      * Returns 0 if given 0.
1063      */
1064     function log10(uint256 value) internal pure returns (uint256) {
1065         uint256 result = 0;
1066         unchecked {
1067             if (value >= 10**64) {
1068                 value /= 10**64;
1069                 result += 64;
1070             }
1071             if (value >= 10**32) {
1072                 value /= 10**32;
1073                 result += 32;
1074             }
1075             if (value >= 10**16) {
1076                 value /= 10**16;
1077                 result += 16;
1078             }
1079             if (value >= 10**8) {
1080                 value /= 10**8;
1081                 result += 8;
1082             }
1083             if (value >= 10**4) {
1084                 value /= 10**4;
1085                 result += 4;
1086             }
1087             if (value >= 10**2) {
1088                 value /= 10**2;
1089                 result += 2;
1090             }
1091             if (value >= 10**1) {
1092                 result += 1;
1093             }
1094         }
1095         return result;
1096     }
1097 
1098     /**
1099      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1100      * Returns 0 if given 0.
1101      */
1102     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1103         unchecked {
1104             uint256 result = log10(value);
1105             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1106         }
1107     }
1108 
1109     /**
1110      * @dev Return the log in base 256, rounded down, of a positive value.
1111      * Returns 0 if given 0.
1112      *
1113      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1114      */
1115     function log256(uint256 value) internal pure returns (uint256) {
1116         uint256 result = 0;
1117         unchecked {
1118             if (value >> 128 > 0) {
1119                 value >>= 128;
1120                 result += 16;
1121             }
1122             if (value >> 64 > 0) {
1123                 value >>= 64;
1124                 result += 8;
1125             }
1126             if (value >> 32 > 0) {
1127                 value >>= 32;
1128                 result += 4;
1129             }
1130             if (value >> 16 > 0) {
1131                 value >>= 16;
1132                 result += 2;
1133             }
1134             if (value >> 8 > 0) {
1135                 result += 1;
1136             }
1137         }
1138         return result;
1139     }
1140 
1141     /**
1142      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1143      * Returns 0 if given 0.
1144      */
1145     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1146         unchecked {
1147             uint256 result = log256(value);
1148             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1149         }
1150     }
1151 }
1152 
1153 // File: @openzeppelin/contracts/utils/Strings.sol
1154 
1155 
1156 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @dev String operations.
1163  */
1164 library Strings {
1165     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1166     uint8 private constant _ADDRESS_LENGTH = 20;
1167 
1168     /**
1169      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1170      */
1171     function toString(uint256 value) internal pure returns (string memory) {
1172         unchecked {
1173             uint256 length = Math.log10(value) + 1;
1174             string memory buffer = new string(length);
1175             uint256 ptr;
1176             /// @solidity memory-safe-assembly
1177             assembly {
1178                 ptr := add(buffer, add(32, length))
1179             }
1180             while (true) {
1181                 ptr--;
1182                 /// @solidity memory-safe-assembly
1183                 assembly {
1184                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1185                 }
1186                 value /= 10;
1187                 if (value == 0) break;
1188             }
1189             return buffer;
1190         }
1191     }
1192 
1193     /**
1194      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1195      */
1196     function toHexString(uint256 value) internal pure returns (string memory) {
1197         unchecked {
1198             return toHexString(value, Math.log256(value) + 1);
1199         }
1200     }
1201 
1202     /**
1203      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1204      */
1205     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1206         bytes memory buffer = new bytes(2 * length + 2);
1207         buffer[0] = "0";
1208         buffer[1] = "x";
1209         for (uint256 i = 2 * length + 1; i > 1; --i) {
1210             buffer[i] = _SYMBOLS[value & 0xf];
1211             value >>= 4;
1212         }
1213         require(value == 0, "Strings: hex length insufficient");
1214         return string(buffer);
1215     }
1216 
1217     /**
1218      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1219      */
1220     function toHexString(address addr) internal pure returns (string memory) {
1221         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1222     }
1223 }
1224 
1225 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1226 
1227 
1228 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 /**
1234  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1235  *
1236  * These functions can be used to verify that a message was signed by the holder
1237  * of the private keys of a given address.
1238  */
1239 library ECDSA {
1240     enum RecoverError {
1241         NoError,
1242         InvalidSignature,
1243         InvalidSignatureLength,
1244         InvalidSignatureS,
1245         InvalidSignatureV // Deprecated in v4.8
1246     }
1247 
1248     function _throwError(RecoverError error) private pure {
1249         if (error == RecoverError.NoError) {
1250             return; // no error: do nothing
1251         } else if (error == RecoverError.InvalidSignature) {
1252             revert("ECDSA: invalid signature");
1253         } else if (error == RecoverError.InvalidSignatureLength) {
1254             revert("ECDSA: invalid signature length");
1255         } else if (error == RecoverError.InvalidSignatureS) {
1256             revert("ECDSA: invalid signature 's' value");
1257         }
1258     }
1259 
1260     /**
1261      * @dev Returns the address that signed a hashed message (`hash`) with
1262      * `signature` or error string. This address can then be used for verification purposes.
1263      *
1264      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1265      * this function rejects them by requiring the `s` value to be in the lower
1266      * half order, and the `v` value to be either 27 or 28.
1267      *
1268      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1269      * verification to be secure: it is possible to craft signatures that
1270      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1271      * this is by receiving a hash of the original message (which may otherwise
1272      * be too long), and then calling {toEthSignedMessageHash} on it.
1273      *
1274      * Documentation for signature generation:
1275      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1276      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1277      *
1278      * _Available since v4.3._
1279      */
1280     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1281         if (signature.length == 65) {
1282             bytes32 r;
1283             bytes32 s;
1284             uint8 v;
1285             // ecrecover takes the signature parameters, and the only way to get them
1286             // currently is to use assembly.
1287             /// @solidity memory-safe-assembly
1288             assembly {
1289                 r := mload(add(signature, 0x20))
1290                 s := mload(add(signature, 0x40))
1291                 v := byte(0, mload(add(signature, 0x60)))
1292             }
1293             return tryRecover(hash, v, r, s);
1294         } else {
1295             return (address(0), RecoverError.InvalidSignatureLength);
1296         }
1297     }
1298 
1299     /**
1300      * @dev Returns the address that signed a hashed message (`hash`) with
1301      * `signature`. This address can then be used for verification purposes.
1302      *
1303      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1304      * this function rejects them by requiring the `s` value to be in the lower
1305      * half order, and the `v` value to be either 27 or 28.
1306      *
1307      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1308      * verification to be secure: it is possible to craft signatures that
1309      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1310      * this is by receiving a hash of the original message (which may otherwise
1311      * be too long), and then calling {toEthSignedMessageHash} on it.
1312      */
1313     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1314         (address recovered, RecoverError error) = tryRecover(hash, signature);
1315         _throwError(error);
1316         return recovered;
1317     }
1318 
1319     /**
1320      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1321      *
1322      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1323      *
1324      * _Available since v4.3._
1325      */
1326     function tryRecover(
1327         bytes32 hash,
1328         bytes32 r,
1329         bytes32 vs
1330     ) internal pure returns (address, RecoverError) {
1331         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1332         uint8 v = uint8((uint256(vs) >> 255) + 27);
1333         return tryRecover(hash, v, r, s);
1334     }
1335 
1336     /**
1337      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1338      *
1339      * _Available since v4.2._
1340      */
1341     function recover(
1342         bytes32 hash,
1343         bytes32 r,
1344         bytes32 vs
1345     ) internal pure returns (address) {
1346         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1347         _throwError(error);
1348         return recovered;
1349     }
1350 
1351     /**
1352      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1353      * `r` and `s` signature fields separately.
1354      *
1355      * _Available since v4.3._
1356      */
1357     function tryRecover(
1358         bytes32 hash,
1359         uint8 v,
1360         bytes32 r,
1361         bytes32 s
1362     ) internal pure returns (address, RecoverError) {
1363         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1364         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1365         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1366         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1367         //
1368         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1369         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1370         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1371         // these malleable signatures as well.
1372         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1373             return (address(0), RecoverError.InvalidSignatureS);
1374         }
1375 
1376         // If the signature is valid (and not malleable), return the signer address
1377         address signer = ecrecover(hash, v, r, s);
1378         if (signer == address(0)) {
1379             return (address(0), RecoverError.InvalidSignature);
1380         }
1381 
1382         return (signer, RecoverError.NoError);
1383     }
1384 
1385     /**
1386      * @dev Overload of {ECDSA-recover} that receives the `v`,
1387      * `r` and `s` signature fields separately.
1388      */
1389     function recover(
1390         bytes32 hash,
1391         uint8 v,
1392         bytes32 r,
1393         bytes32 s
1394     ) internal pure returns (address) {
1395         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1396         _throwError(error);
1397         return recovered;
1398     }
1399 
1400     /**
1401      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1402      * produces hash corresponding to the one signed with the
1403      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1404      * JSON-RPC method as part of EIP-191.
1405      *
1406      * See {recover}.
1407      */
1408     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1409         // 32 is the length in bytes of hash,
1410         // enforced by the type signature above
1411         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1412     }
1413 
1414     /**
1415      * @dev Returns an Ethereum Signed Message, created from `s`. This
1416      * produces hash corresponding to the one signed with the
1417      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1418      * JSON-RPC method as part of EIP-191.
1419      *
1420      * See {recover}.
1421      */
1422     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1423         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1424     }
1425 
1426     /**
1427      * @dev Returns an Ethereum Signed Typed Data, created from a
1428      * `domainSeparator` and a `structHash`. This produces hash corresponding
1429      * to the one signed with the
1430      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1431      * JSON-RPC method as part of EIP-712.
1432      *
1433      * See {recover}.
1434      */
1435     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1436         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1437     }
1438 }
1439 
1440 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
1441 
1442 
1443 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1444 
1445 pragma solidity ^0.8.0;
1446 
1447 
1448 /**
1449  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1450  *
1451  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1452  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1453  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1454  *
1455  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1456  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1457  * ({_hashTypedDataV4}).
1458  *
1459  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1460  * the chain id to protect against replay attacks on an eventual fork of the chain.
1461  *
1462  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1463  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1464  *
1465  * _Available since v3.4._
1466  */
1467 abstract contract EIP712 {
1468     /* solhint-disable var-name-mixedcase */
1469     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1470     // invalidate the cached domain separator if the chain id changes.
1471     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1472     uint256 private immutable _CACHED_CHAIN_ID;
1473     address private immutable _CACHED_THIS;
1474 
1475     bytes32 private immutable _HASHED_NAME;
1476     bytes32 private immutable _HASHED_VERSION;
1477     bytes32 private immutable _TYPE_HASH;
1478 
1479     /* solhint-enable var-name-mixedcase */
1480 
1481     /**
1482      * @dev Initializes the domain separator and parameter caches.
1483      *
1484      * The meaning of `name` and `version` is specified in
1485      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1486      *
1487      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1488      * - `version`: the current major version of the signing domain.
1489      *
1490      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1491      * contract upgrade].
1492      */
1493     constructor(string memory name, string memory version) {
1494         bytes32 hashedName = keccak256(bytes(name));
1495         bytes32 hashedVersion = keccak256(bytes(version));
1496         bytes32 typeHash = keccak256(
1497             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1498         );
1499         _HASHED_NAME = hashedName;
1500         _HASHED_VERSION = hashedVersion;
1501         _CACHED_CHAIN_ID = block.chainid;
1502         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1503         _CACHED_THIS = address(this);
1504         _TYPE_HASH = typeHash;
1505     }
1506 
1507     /**
1508      * @dev Returns the domain separator for the current chain.
1509      */
1510     function _domainSeparatorV4() internal view returns (bytes32) {
1511         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1512             return _CACHED_DOMAIN_SEPARATOR;
1513         } else {
1514             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1515         }
1516     }
1517 
1518     function _buildDomainSeparator(
1519         bytes32 typeHash,
1520         bytes32 nameHash,
1521         bytes32 versionHash
1522     ) private view returns (bytes32) {
1523         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1524     }
1525 
1526     /**
1527      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1528      * function returns the hash of the fully encoded EIP712 message for this domain.
1529      *
1530      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1531      *
1532      * ```solidity
1533      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1534      *     keccak256("Mail(address to,string contents)"),
1535      *     mailTo,
1536      *     keccak256(bytes(mailContents))
1537      * )));
1538      * address signer = ECDSA.recover(digest, signature);
1539      * ```
1540      */
1541     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1542         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1543     }
1544 }
1545 
1546 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1547 
1548 
1549 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/draft-EIP712.sol)
1550 
1551 pragma solidity ^0.8.0;
1552 
1553 // EIP-712 is Final as of 2022-08-11. This file is deprecated.
1554 
1555 
1556 // File: @openzeppelin/contracts/utils/Context.sol
1557 
1558 
1559 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1560 
1561 pragma solidity ^0.8.0;
1562 
1563 /**
1564  * @dev Provides information about the current execution context, including the
1565  * sender of the transaction and its data. While these are generally available
1566  * via msg.sender and msg.data, they should not be accessed in such a direct
1567  * manner, since when dealing with meta-transactions the account sending and
1568  * paying for execution may not be the actual sender (as far as an application
1569  * is concerned).
1570  *
1571  * This contract is only required for intermediate, library-like contracts.
1572  */
1573 abstract contract Context {
1574     function _msgSender() internal view virtual returns (address) {
1575         return msg.sender;
1576     }
1577 
1578     function _msgData() internal view virtual returns (bytes calldata) {
1579         return msg.data;
1580     }
1581 }
1582 
1583 // File: @openzeppelin/contracts/access/Ownable.sol
1584 
1585 
1586 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1587 
1588 pragma solidity ^0.8.0;
1589 
1590 
1591 /**
1592  * @dev Contract module which provides a basic access control mechanism, where
1593  * there is an account (an owner) that can be granted exclusive access to
1594  * specific functions.
1595  *
1596  * By default, the owner account will be the one that deploys the contract. This
1597  * can later be changed with {transferOwnership}.
1598  *
1599  * This module is used through inheritance. It will make available the modifier
1600  * `onlyOwner`, which can be applied to your functions to restrict their use to
1601  * the owner.
1602  */
1603 abstract contract Ownable is Context {
1604     address private _owner;
1605 
1606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1607 
1608     /**
1609      * @dev Initializes the contract setting the deployer as the initial owner.
1610      */
1611     constructor() {
1612         _transferOwnership(_msgSender());
1613     }
1614 
1615     /**
1616      * @dev Throws if called by any account other than the owner.
1617      */
1618     modifier onlyOwner() {
1619         _checkOwner();
1620         _;
1621     }
1622 
1623     /**
1624      * @dev Returns the address of the current owner.
1625      */
1626     function owner() public view virtual returns (address) {
1627         return _owner;
1628     }
1629 
1630     /**
1631      * @dev Throws if the sender is not the owner.
1632      */
1633     function _checkOwner() internal view virtual {
1634         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1635     }
1636 
1637     /**
1638      * @dev Leaves the contract without owner. It will not be possible to call
1639      * `onlyOwner` functions anymore. Can only be called by the current owner.
1640      *
1641      * NOTE: Renouncing ownership will leave the contract without an owner,
1642      * thereby removing any functionality that is only available to the owner.
1643      */
1644     function renounceOwnership() public virtual onlyOwner {
1645         _transferOwnership(address(0));
1646     }
1647 
1648     /**
1649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1650      * Can only be called by the current owner.
1651      */
1652     function transferOwnership(address newOwner) public virtual onlyOwner {
1653         require(newOwner != address(0), "Ownable: new owner is the zero address");
1654         _transferOwnership(newOwner);
1655     }
1656 
1657     /**
1658      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1659      * Internal function without access restriction.
1660      */
1661     function _transferOwnership(address newOwner) internal virtual {
1662         address oldOwner = _owner;
1663         _owner = newOwner;
1664         emit OwnershipTransferred(oldOwner, newOwner);
1665     }
1666 }
1667 
1668 // File: @openzeppelin/contracts/utils/Address.sol
1669 
1670 
1671 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1672 
1673 pragma solidity ^0.8.1;
1674 
1675 /**
1676  * @dev Collection of functions related to the address type
1677  */
1678 library Address {
1679     /**
1680      * @dev Returns true if `account` is a contract.
1681      *
1682      * [IMPORTANT]
1683      * ====
1684      * It is unsafe to assume that an address for which this function returns
1685      * false is an externally-owned account (EOA) and not a contract.
1686      *
1687      * Among others, `isContract` will return false for the following
1688      * types of addresses:
1689      *
1690      *  - an externally-owned account
1691      *  - a contract in construction
1692      *  - an address where a contract will be created
1693      *  - an address where a contract lived, but was destroyed
1694      * ====
1695      *
1696      * [IMPORTANT]
1697      * ====
1698      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1699      *
1700      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1701      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1702      * constructor.
1703      * ====
1704      */
1705     function isContract(address account) internal view returns (bool) {
1706         // This method relies on extcodesize/address.code.length, which returns 0
1707         // for contracts in construction, since the code is only stored at the end
1708         // of the constructor execution.
1709 
1710         return account.code.length > 0;
1711     }
1712 
1713     /**
1714      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1715      * `recipient`, forwarding all available gas and reverting on errors.
1716      *
1717      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1718      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1719      * imposed by `transfer`, making them unable to receive funds via
1720      * `transfer`. {sendValue} removes this limitation.
1721      *
1722      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1723      *
1724      * IMPORTANT: because control is transferred to `recipient`, care must be
1725      * taken to not create reentrancy vulnerabilities. Consider using
1726      * {ReentrancyGuard} or the
1727      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1728      */
1729     function sendValue(address payable recipient, uint256 amount) internal {
1730         require(address(this).balance >= amount, "Address: insufficient balance");
1731 
1732         (bool success, ) = recipient.call{value: amount}("");
1733         require(success, "Address: unable to send value, recipient may have reverted");
1734     }
1735 
1736     /**
1737      * @dev Performs a Solidity function call using a low level `call`. A
1738      * plain `call` is an unsafe replacement for a function call: use this
1739      * function instead.
1740      *
1741      * If `target` reverts with a revert reason, it is bubbled up by this
1742      * function (like regular Solidity function calls).
1743      *
1744      * Returns the raw returned data. To convert to the expected return value,
1745      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1746      *
1747      * Requirements:
1748      *
1749      * - `target` must be a contract.
1750      * - calling `target` with `data` must not revert.
1751      *
1752      * _Available since v3.1._
1753      */
1754     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1755         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1756     }
1757 
1758     /**
1759      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1760      * `errorMessage` as a fallback revert reason when `target` reverts.
1761      *
1762      * _Available since v3.1._
1763      */
1764     function functionCall(
1765         address target,
1766         bytes memory data,
1767         string memory errorMessage
1768     ) internal returns (bytes memory) {
1769         return functionCallWithValue(target, data, 0, errorMessage);
1770     }
1771 
1772     /**
1773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1774      * but also transferring `value` wei to `target`.
1775      *
1776      * Requirements:
1777      *
1778      * - the calling contract must have an ETH balance of at least `value`.
1779      * - the called Solidity function must be `payable`.
1780      *
1781      * _Available since v3.1._
1782      */
1783     function functionCallWithValue(
1784         address target,
1785         bytes memory data,
1786         uint256 value
1787     ) internal returns (bytes memory) {
1788         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1789     }
1790 
1791     /**
1792      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1793      * with `errorMessage` as a fallback revert reason when `target` reverts.
1794      *
1795      * _Available since v3.1._
1796      */
1797     function functionCallWithValue(
1798         address target,
1799         bytes memory data,
1800         uint256 value,
1801         string memory errorMessage
1802     ) internal returns (bytes memory) {
1803         require(address(this).balance >= value, "Address: insufficient balance for call");
1804         (bool success, bytes memory returndata) = target.call{value: value}(data);
1805         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1806     }
1807 
1808     /**
1809      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1810      * but performing a static call.
1811      *
1812      * _Available since v3.3._
1813      */
1814     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1815         return functionStaticCall(target, data, "Address: low-level static call failed");
1816     }
1817 
1818     /**
1819      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1820      * but performing a static call.
1821      *
1822      * _Available since v3.3._
1823      */
1824     function functionStaticCall(
1825         address target,
1826         bytes memory data,
1827         string memory errorMessage
1828     ) internal view returns (bytes memory) {
1829         (bool success, bytes memory returndata) = target.staticcall(data);
1830         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1831     }
1832 
1833     /**
1834      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1835      * but performing a delegate call.
1836      *
1837      * _Available since v3.4._
1838      */
1839     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1840         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1841     }
1842 
1843     /**
1844      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1845      * but performing a delegate call.
1846      *
1847      * _Available since v3.4._
1848      */
1849     function functionDelegateCall(
1850         address target,
1851         bytes memory data,
1852         string memory errorMessage
1853     ) internal returns (bytes memory) {
1854         (bool success, bytes memory returndata) = target.delegatecall(data);
1855         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1856     }
1857 
1858     /**
1859      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1860      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1861      *
1862      * _Available since v4.8._
1863      */
1864     function verifyCallResultFromTarget(
1865         address target,
1866         bool success,
1867         bytes memory returndata,
1868         string memory errorMessage
1869     ) internal view returns (bytes memory) {
1870         if (success) {
1871             if (returndata.length == 0) {
1872                 // only check isContract if the call was successful and the return data is empty
1873                 // otherwise we already know that it was a contract
1874                 require(isContract(target), "Address: call to non-contract");
1875             }
1876             return returndata;
1877         } else {
1878             _revert(returndata, errorMessage);
1879         }
1880     }
1881 
1882     /**
1883      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1884      * revert reason or using the provided one.
1885      *
1886      * _Available since v4.3._
1887      */
1888     function verifyCallResult(
1889         bool success,
1890         bytes memory returndata,
1891         string memory errorMessage
1892     ) internal pure returns (bytes memory) {
1893         if (success) {
1894             return returndata;
1895         } else {
1896             _revert(returndata, errorMessage);
1897         }
1898     }
1899 
1900     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1901         // Look for revert reason and bubble it up if present
1902         if (returndata.length > 0) {
1903             // The easiest way to bubble the revert reason is using memory via assembly
1904             /// @solidity memory-safe-assembly
1905             assembly {
1906                 let returndata_size := mload(returndata)
1907                 revert(add(32, returndata), returndata_size)
1908             }
1909         } else {
1910             revert(errorMessage);
1911         }
1912     }
1913 }
1914 
1915 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1916 
1917 
1918 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1919 
1920 pragma solidity ^0.8.0;
1921 
1922 /**
1923  * @title ERC721 token receiver interface
1924  * @dev Interface for any contract that wants to support safeTransfers
1925  * from ERC721 asset contracts.
1926  */
1927 interface IERC721Receiver {
1928     /**
1929      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1930      * by `operator` from `from`, this function is called.
1931      *
1932      * It must return its Solidity selector to confirm the token transfer.
1933      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1934      *
1935      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1936      */
1937     function onERC721Received(
1938         address operator,
1939         address from,
1940         uint256 tokenId,
1941         bytes calldata data
1942     ) external returns (bytes4);
1943 }
1944 
1945 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1946 
1947 
1948 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1949 
1950 pragma solidity ^0.8.0;
1951 
1952 /**
1953  * @dev Interface of the ERC165 standard, as defined in the
1954  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1955  *
1956  * Implementers can declare support of contract interfaces, which can then be
1957  * queried by others ({ERC165Checker}).
1958  *
1959  * For an implementation, see {ERC165}.
1960  */
1961 interface IERC165 {
1962     /**
1963      * @dev Returns true if this contract implements the interface defined by
1964      * `interfaceId`. See the corresponding
1965      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1966      * to learn more about how these ids are created.
1967      *
1968      * This function call must use less than 30 000 gas.
1969      */
1970     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1971 }
1972 
1973 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1974 
1975 
1976 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1977 
1978 pragma solidity ^0.8.0;
1979 
1980 
1981 /**
1982  * @dev Interface for the NFT Royalty Standard.
1983  *
1984  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1985  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1986  *
1987  * _Available since v4.5._
1988  */
1989 interface IERC2981 is IERC165 {
1990     /**
1991      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1992      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1993      */
1994     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1995         external
1996         view
1997         returns (address receiver, uint256 royaltyAmount);
1998 }
1999 
2000 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2001 
2002 
2003 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2004 
2005 pragma solidity ^0.8.0;
2006 
2007 
2008 /**
2009  * @dev Implementation of the {IERC165} interface.
2010  *
2011  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2012  * for the additional interface id that will be supported. For example:
2013  *
2014  * ```solidity
2015  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2016  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2017  * }
2018  * ```
2019  *
2020  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2021  */
2022 abstract contract ERC165 is IERC165 {
2023     /**
2024      * @dev See {IERC165-supportsInterface}.
2025      */
2026     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2027         return interfaceId == type(IERC165).interfaceId;
2028     }
2029 }
2030 
2031 // File: @openzeppelin/contracts/token/common/ERC2981.sol
2032 
2033 
2034 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2035 
2036 pragma solidity ^0.8.0;
2037 
2038 
2039 
2040 /**
2041  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2042  *
2043  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2044  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2045  *
2046  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2047  * fee is specified in basis points by default.
2048  *
2049  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2050  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2051  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2052  *
2053  * _Available since v4.5._
2054  */
2055 abstract contract ERC2981 is IERC2981, ERC165 {
2056     struct RoyaltyInfo {
2057         address receiver;
2058         uint96 royaltyFraction;
2059     }
2060 
2061     RoyaltyInfo private _defaultRoyaltyInfo;
2062     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2063 
2064     /**
2065      * @dev See {IERC165-supportsInterface}.
2066      */
2067     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2068         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2069     }
2070 
2071     /**
2072      * @inheritdoc IERC2981
2073      */
2074     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2075         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2076 
2077         if (royalty.receiver == address(0)) {
2078             royalty = _defaultRoyaltyInfo;
2079         }
2080 
2081         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2082 
2083         return (royalty.receiver, royaltyAmount);
2084     }
2085 
2086     /**
2087      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2088      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2089      * override.
2090      */
2091     function _feeDenominator() internal pure virtual returns (uint96) {
2092         return 10000;
2093     }
2094 
2095     /**
2096      * @dev Sets the royalty information that all ids in this contract will default to.
2097      *
2098      * Requirements:
2099      *
2100      * - `receiver` cannot be the zero address.
2101      * - `feeNumerator` cannot be greater than the fee denominator.
2102      */
2103     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2104         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2105         require(receiver != address(0), "ERC2981: invalid receiver");
2106 
2107         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2108     }
2109 
2110     /**
2111      * @dev Removes default royalty information.
2112      */
2113     function _deleteDefaultRoyalty() internal virtual {
2114         delete _defaultRoyaltyInfo;
2115     }
2116 
2117     /**
2118      * @dev Sets the royalty information for a specific token id, overriding the global default.
2119      *
2120      * Requirements:
2121      *
2122      * - `receiver` cannot be the zero address.
2123      * - `feeNumerator` cannot be greater than the fee denominator.
2124      */
2125     function _setTokenRoyalty(
2126         uint256 tokenId,
2127         address receiver,
2128         uint96 feeNumerator
2129     ) internal virtual {
2130         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2131         require(receiver != address(0), "ERC2981: Invalid parameters");
2132 
2133         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2134     }
2135 
2136     /**
2137      * @dev Resets royalty information for the token id back to the global default.
2138      */
2139     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2140         delete _tokenRoyaltyInfo[tokenId];
2141     }
2142 }
2143 
2144 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2145 
2146 
2147 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2148 
2149 pragma solidity ^0.8.0;
2150 
2151 
2152 /**
2153  * @dev Required interface of an ERC721 compliant contract.
2154  */
2155 interface IERC721 is IERC165 {
2156     /**
2157      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2158      */
2159     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2160 
2161     /**
2162      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2163      */
2164     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2165 
2166     /**
2167      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2168      */
2169     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2170 
2171     /**
2172      * @dev Returns the number of tokens in ``owner``'s account.
2173      */
2174     function balanceOf(address owner) external view returns (uint256 balance);
2175 
2176     /**
2177      * @dev Returns the owner of the `tokenId` token.
2178      *
2179      * Requirements:
2180      *
2181      * - `tokenId` must exist.
2182      */
2183     function ownerOf(uint256 tokenId) external view returns (address owner);
2184 
2185     /**
2186      * @dev Safely transfers `tokenId` token from `from` to `to`.
2187      *
2188      * Requirements:
2189      *
2190      * - `from` cannot be the zero address.
2191      * - `to` cannot be the zero address.
2192      * - `tokenId` token must exist and be owned by `from`.
2193      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2194      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2195      *
2196      * Emits a {Transfer} event.
2197      */
2198     function safeTransferFrom(
2199         address from,
2200         address to,
2201         uint256 tokenId,
2202         bytes calldata data
2203     ) external;
2204 
2205     /**
2206      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2207      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2208      *
2209      * Requirements:
2210      *
2211      * - `from` cannot be the zero address.
2212      * - `to` cannot be the zero address.
2213      * - `tokenId` token must exist and be owned by `from`.
2214      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2215      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2216      *
2217      * Emits a {Transfer} event.
2218      */
2219     function safeTransferFrom(
2220         address from,
2221         address to,
2222         uint256 tokenId
2223     ) external;
2224 
2225     /**
2226      * @dev Transfers `tokenId` token from `from` to `to`.
2227      *
2228      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2229      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2230      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2231      *
2232      * Requirements:
2233      *
2234      * - `from` cannot be the zero address.
2235      * - `to` cannot be the zero address.
2236      * - `tokenId` token must be owned by `from`.
2237      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2238      *
2239      * Emits a {Transfer} event.
2240      */
2241     function transferFrom(
2242         address from,
2243         address to,
2244         uint256 tokenId
2245     ) external;
2246 
2247     /**
2248      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2249      * The approval is cleared when the token is transferred.
2250      *
2251      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2252      *
2253      * Requirements:
2254      *
2255      * - The caller must own the token or be an approved operator.
2256      * - `tokenId` must exist.
2257      *
2258      * Emits an {Approval} event.
2259      */
2260     function approve(address to, uint256 tokenId) external;
2261 
2262     /**
2263      * @dev Approve or remove `operator` as an operator for the caller.
2264      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2265      *
2266      * Requirements:
2267      *
2268      * - The `operator` cannot be the caller.
2269      *
2270      * Emits an {ApprovalForAll} event.
2271      */
2272     function setApprovalForAll(address operator, bool _approved) external;
2273 
2274     /**
2275      * @dev Returns the account approved for `tokenId` token.
2276      *
2277      * Requirements:
2278      *
2279      * - `tokenId` must exist.
2280      */
2281     function getApproved(uint256 tokenId) external view returns (address operator);
2282 
2283     /**
2284      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2285      *
2286      * See {setApprovalForAll}
2287      */
2288     function isApprovedForAll(address owner, address operator) external view returns (bool);
2289 }
2290 
2291 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
2292 
2293 
2294 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
2295 
2296 pragma solidity ^0.8.0;
2297 
2298 
2299 /**
2300  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2301  * @dev See https://eips.ethereum.org/EIPS/eip-721
2302  */
2303 interface IERC721Enumerable is IERC721 {
2304     /**
2305      * @dev Returns the total amount of tokens stored by the contract.
2306      */
2307     function totalSupply() external view returns (uint256);
2308 
2309     /**
2310      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2311      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2312      */
2313     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
2314 
2315     /**
2316      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2317      * Use along with {totalSupply} to enumerate all tokens.
2318      */
2319     function tokenByIndex(uint256 index) external view returns (uint256);
2320 }
2321 
2322 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2323 
2324 
2325 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2326 
2327 pragma solidity ^0.8.0;
2328 
2329 
2330 /**
2331  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2332  * @dev See https://eips.ethereum.org/EIPS/eip-721
2333  */
2334 interface IERC721Metadata is IERC721 {
2335     /**
2336      * @dev Returns the token collection name.
2337      */
2338     function name() external view returns (string memory);
2339 
2340     /**
2341      * @dev Returns the token collection symbol.
2342      */
2343     function symbol() external view returns (string memory);
2344 
2345     /**
2346      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2347      */
2348     function tokenURI(uint256 tokenId) external view returns (string memory);
2349 }
2350 
2351 // File: contracts/ERC721A.sol
2352 
2353 
2354 // Creator: Chiru Labs
2355 
2356 pragma solidity ^0.8.4;
2357 
2358 
2359 
2360 
2361 
2362 
2363 
2364 
2365 
2366 error ApprovalCallerNotOwnerNorApproved();
2367 error ApprovalQueryForNonexistentToken();
2368 error ApproveToCaller();
2369 error ApprovalToCurrentOwner();
2370 error BalanceQueryForZeroAddress();
2371 error MintedQueryForZeroAddress();
2372 error BurnedQueryForZeroAddress();
2373 error AuxQueryForZeroAddress();
2374 error MintToZeroAddress();
2375 error MintZeroQuantity();
2376 error OwnerIndexOutOfBounds();
2377 error OwnerQueryForNonexistentToken();
2378 error TokenIndexOutOfBounds();
2379 error TransferCallerNotOwnerNorApproved();
2380 error TransferFromIncorrectOwner();
2381 error TransferToNonERC721ReceiverImplementer();
2382 error TransferToZeroAddress();
2383 error URIQueryForNonexistentToken();
2384 
2385 /**
2386  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2387  * the Metadata extension. Built to optimize for lower gas during batch mints.
2388  *
2389  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2390  *
2391  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2392  *
2393  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2394  */
2395 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2396     using Address for address;
2397     using Strings for uint256;
2398 
2399     // Compiler will pack this into a single 256bit word.
2400     struct TokenOwnership {
2401         // The address of the owner.
2402         address addr;
2403         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2404         uint64 startTimestamp;
2405         // Whether the token has been burned.
2406         bool burned;
2407     }
2408 
2409     // Compiler will pack this into a single 256bit word.
2410     struct AddressData {
2411         // Realistically, 2**64-1 is more than enough.
2412         uint64 balance;
2413         // Keeps track of mint count with minimal overhead for tokenomics.
2414         uint64 numberMinted;
2415         // Keeps track of burn count with minimal overhead for tokenomics.
2416         uint64 numberBurned;
2417         // For miscellaneous variable(s) pertaining to the address
2418         // (e.g. number of whitelist mint slots used).
2419         // If there are multiple variables, please pack them into a uint64.
2420         uint64 aux;
2421     }
2422 
2423     // The tokenId of the next token to be minted.
2424     uint256 internal _currentIndex;
2425 
2426     // The number of tokens burned.
2427     uint256 internal _burnCounter;
2428 
2429     // Token name
2430     string private _name;
2431 
2432     // Token symbol
2433     string private _symbol;
2434 
2435     // Mapping from token ID to ownership details
2436     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
2437     mapping(uint256 => TokenOwnership) internal _ownerships;
2438 
2439     // Mapping owner address to address data
2440     mapping(address => AddressData) public _addressData;
2441 
2442     // Mapping from token ID to approved address
2443     mapping(uint256 => address) private _tokenApprovals;
2444 
2445     // Mapping from owner to operator approvals
2446     mapping(address => mapping(address => bool)) private _operatorApprovals;
2447 
2448     constructor(string memory name_, string memory symbol_) {
2449         _name = name_;
2450         _symbol = symbol_;
2451         _currentIndex = _startTokenId();
2452     }
2453 
2454     /**
2455      * To change the starting tokenId, please override this function.
2456      */
2457     function _startTokenId() internal view virtual returns (uint256) {
2458         return 0;
2459     }
2460 
2461     /**
2462      * @dev See {IERC721Enumerable-totalSupply}.
2463      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2464      */
2465     function totalSupply() public view returns (uint256) {
2466         // Counter underflow is impossible as _burnCounter cannot be incremented
2467         // more than _currentIndex - _startTokenId() times
2468         unchecked {
2469             return _currentIndex - _burnCounter - _startTokenId();
2470         }
2471     }
2472 
2473     /**
2474      * Returns the total amount of tokens minted in the contract.
2475      */
2476     function _totalMinted() internal view returns (uint256) {
2477         // Counter underflow is impossible as _currentIndex does not decrement,
2478         // and it is initialized to _startTokenId()
2479         unchecked {
2480             return _currentIndex - _startTokenId();
2481         }
2482     }
2483 
2484     /**
2485      * @dev See {IERC165-supportsInterface}.
2486      */
2487     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2488         return
2489             interfaceId == type(IERC721).interfaceId || interfaceId == 0x2a55205a ||
2490             interfaceId == type(IERC721Metadata).interfaceId ||
2491             super.supportsInterface(interfaceId);
2492     }
2493 
2494     /**
2495      * @dev See {IERC721-balanceOf}.
2496      */
2497     function balanceOf(address owner) public view override returns (uint256) {
2498         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2499         return uint256(_addressData[owner].balance);
2500     }
2501 
2502     /**
2503      * Returns the number of tokens minted by `owner`.
2504      */
2505     function _numberMinted(address owner) internal view returns (uint256) {
2506         if (owner == address(0)) revert MintedQueryForZeroAddress();
2507         return uint256(_addressData[owner].numberMinted);
2508     }
2509 
2510     /**
2511      * Returns the number of tokens burned by or on behalf of `owner`.
2512      */
2513     function _numberBurned(address owner) internal view returns (uint256) {
2514         if (owner == address(0)) revert BurnedQueryForZeroAddress();
2515         return uint256(_addressData[owner].numberBurned);
2516     }
2517 
2518     /**
2519      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2520      */
2521     function _getAux(address owner) internal view returns (uint64) {
2522         if (owner == address(0)) revert AuxQueryForZeroAddress();
2523         return _addressData[owner].aux;
2524     }
2525 
2526     /**
2527      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2528      * If there are multiple variables, please pack them into a uint64.
2529      */
2530     function _setAux(address owner, uint64 aux) internal {
2531         if (owner == address(0)) revert AuxQueryForZeroAddress();
2532         _addressData[owner].aux = aux;
2533     }
2534 
2535     /**
2536      * Gas spent here starts off proportional to the maximum mint batch size.
2537      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2538      */
2539     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2540         uint256 curr = tokenId;
2541 
2542         unchecked {
2543             if (_startTokenId() <= curr && curr < _currentIndex) {
2544                 TokenOwnership memory ownership = _ownerships[curr];
2545                 if (!ownership.burned) {
2546                     if (ownership.addr != address(0)) {
2547                         return ownership;
2548                     }
2549                     // Invariant:
2550                     // There will always be an ownership that has an address and is not burned
2551                     // before an ownership that does not have an address and is not burned.
2552                     // Hence, curr will not underflow.
2553                     while (true) {
2554                         curr--;
2555                         ownership = _ownerships[curr];
2556                         if (ownership.addr != address(0)) {
2557                             return ownership;
2558                         }
2559                     }
2560                 }
2561             }
2562         }
2563         revert OwnerQueryForNonexistentToken();
2564     }
2565 
2566     /**
2567      * @dev See {IERC721-ownerOf}.
2568      */
2569     function ownerOf(uint256 tokenId) public view override returns (address) {
2570         return ownershipOf(tokenId).addr;
2571     }
2572 
2573     /**
2574      * @dev See {IERC721Metadata-name}.
2575      */
2576     function name() public view virtual override returns (string memory) {
2577         return _name;
2578     }
2579 
2580     /**
2581      * @dev See {IERC721Metadata-symbol}.
2582      */
2583     function symbol() public view virtual override returns (string memory) {
2584         return _symbol;
2585     }
2586 
2587     /**
2588      * @dev See {IERC721Metadata-tokenURI}.
2589      */
2590     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2591         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2592 
2593         string memory baseURI = _baseURI();
2594         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2595     }
2596 
2597     /**
2598      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2599      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2600      * by default, can be overriden in child contracts.
2601      */
2602     function _baseURI() internal view virtual returns (string memory) {
2603         return '';
2604     }
2605 
2606     /**
2607      * @dev See {IERC721-approve}.
2608      */
2609     function approve(address to, uint256 tokenId) public virtual override {
2610         address owner = ERC721A.ownerOf(tokenId);
2611         if (to == owner) revert ApprovalToCurrentOwner();
2612 
2613         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2614             revert ApprovalCallerNotOwnerNorApproved();
2615         }
2616 
2617         _approve(to, tokenId, owner);
2618     }
2619 
2620     /**
2621      * @dev See {IERC721-getApproved}.
2622      */
2623     function getApproved(uint256 tokenId) public view override returns (address) {
2624         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2625 
2626         return _tokenApprovals[tokenId];
2627     }
2628 
2629     /**
2630      * @dev See {IERC721-setApprovalForAll}.
2631      */
2632     function setApprovalForAll(address operator, bool approved) public virtual override {
2633         if (operator == _msgSender()) revert ApproveToCaller();
2634 
2635         _operatorApprovals[_msgSender()][operator] = approved;
2636         emit ApprovalForAll(_msgSender(), operator, approved);
2637     }
2638 
2639     /**
2640      * @dev See {IERC721-isApprovedForAll}.
2641      */
2642     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2643         return _operatorApprovals[owner][operator];
2644     }
2645 
2646     /**
2647      * @dev See {IERC721-transferFrom}.
2648      */
2649     function transferFrom(
2650         address from,
2651         address to,
2652         uint256 tokenId
2653     ) public virtual override {
2654         _transfer(from, to, tokenId);
2655     }
2656 
2657     /**
2658      * @dev See {IERC721-safeTransferFrom}.
2659      */
2660     function safeTransferFrom(
2661         address from,
2662         address to,
2663         uint256 tokenId
2664     ) public virtual override {
2665         safeTransferFrom(from, to, tokenId, '');
2666     }
2667 
2668     /**
2669      * @dev See {IERC721-safeTransferFrom}.
2670      */
2671     function safeTransferFrom(
2672         address from,
2673         address to,
2674         uint256 tokenId,
2675         bytes memory _data
2676     ) public virtual override {
2677         _transfer(from, to, tokenId);
2678         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2679             revert TransferToNonERC721ReceiverImplementer();
2680         }
2681     }
2682 
2683     /**
2684      * @dev Returns whether `tokenId` exists.
2685      *
2686      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2687      *
2688      * Tokens start existing when they are minted (`_mint`),
2689      */
2690     function _exists(uint256 tokenId) internal view returns (bool) {
2691         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
2692             !_ownerships[tokenId].burned;
2693     }
2694 
2695     function _safeMint(address to, uint256 quantity) internal {
2696         _safeMint(to, quantity, '');
2697     }
2698 
2699     /**
2700      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2701      *
2702      * Requirements:
2703      *
2704      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2705      * - `quantity` must be greater than 0.
2706      *
2707      * Emits a {Transfer} event.
2708      */
2709     function _safeMint(
2710         address to,
2711         uint256 quantity,
2712         bytes memory _data
2713     ) internal {
2714         _mint(to, quantity, _data, true);
2715     }
2716 
2717     /**
2718      * @dev Mints `quantity` tokens and transfers them to `to`.
2719      *
2720      * Requirements:
2721      *
2722      * - `to` cannot be the zero address.
2723      * - `quantity` must be greater than 0.
2724      *
2725      * Emits a {Transfer} event.
2726      */
2727     function _mint(
2728         address to,
2729         uint256 quantity,
2730         bytes memory _data,
2731         bool safe
2732     ) internal {
2733         uint256 startTokenId = _currentIndex;
2734         if (to == address(0)) revert MintToZeroAddress();
2735         if (quantity == 0) revert MintZeroQuantity();
2736 
2737         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2738 
2739         // Overflows are incredibly unrealistic.
2740         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2741         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2742         unchecked {
2743             _addressData[to].balance += uint64(quantity);
2744             _addressData[to].numberMinted += uint64(quantity);
2745 
2746             _ownerships[startTokenId].addr = to;
2747             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2748 
2749             uint256 updatedIndex = startTokenId;
2750             uint256 end = updatedIndex + quantity;
2751 
2752             if (safe && to.isContract()) {
2753                 do {
2754                     emit Transfer(address(0), to, updatedIndex);
2755                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2756                         revert TransferToNonERC721ReceiverImplementer();
2757                     }
2758                 } while (updatedIndex != end);
2759                 // Reentrancy protection
2760                 if (_currentIndex != startTokenId) revert();
2761             } else {
2762                 do {
2763                     emit Transfer(address(0), to, updatedIndex++);
2764                 } while (updatedIndex != end);
2765             }
2766             _currentIndex = updatedIndex;
2767         }
2768         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2769     }
2770 
2771     /**
2772      * @dev Transfers `tokenId` from `from` to `to`.
2773      *
2774      * Requirements:
2775      *
2776      * - `to` cannot be the zero address.
2777      * - `tokenId` token must be owned by `from`.
2778      *
2779      * Emits a {Transfer} event.
2780      */
2781     function _transfer(
2782         address from,
2783         address to,
2784         uint256 tokenId
2785     ) private {
2786         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2787 
2788         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
2789             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
2790             getApproved(tokenId) == _msgSender());
2791 
2792         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2793         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2794         if (to == address(0)) revert TransferToZeroAddress();
2795 
2796         _beforeTokenTransfers(from, to, tokenId, 1);
2797 
2798         // Clear approvals from the previous owner
2799         _approve(address(0), tokenId, prevOwnership.addr);
2800 
2801         // Underflow of the sender's balance is impossible because we check for
2802         // ownership above and the recipient's balance can't realistically overflow.
2803         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2804         unchecked {
2805             _addressData[from].balance -= 1;
2806             _addressData[to].balance += 1;
2807 
2808             _ownerships[tokenId].addr = to;
2809             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2810 
2811             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2812             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2813             uint256 nextTokenId = tokenId + 1;
2814             if (_ownerships[nextTokenId].addr == address(0)) {
2815                 // This will suffice for checking _exists(nextTokenId),
2816                 // as a burned slot cannot contain the zero address.
2817                 if (nextTokenId < _currentIndex) {
2818                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2819                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2820                 }
2821             }
2822         }
2823 
2824         emit Transfer(from, to, tokenId);
2825         _afterTokenTransfers(from, to, tokenId, 1);
2826     }
2827 
2828     /**
2829      * @dev Destroys `tokenId`.
2830      * The approval is cleared when the token is burned.
2831      *
2832      * Requirements:
2833      *
2834      * - `tokenId` must exist.
2835      *
2836      * Emits a {Transfer} event.
2837      */
2838     function _burn(uint256 tokenId) internal virtual {
2839         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2840 
2841         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
2842 
2843         // Clear approvals from the previous owner
2844         _approve(address(0), tokenId, prevOwnership.addr);
2845 
2846         // Underflow of the sender's balance is impossible because we check for
2847         // ownership above and the recipient's balance can't realistically overflow.
2848         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2849         unchecked {
2850             _addressData[prevOwnership.addr].balance -= 1;
2851             _addressData[prevOwnership.addr].numberBurned += 1;
2852 
2853             // Keep track of who burned the token, and the timestamp of burning.
2854             _ownerships[tokenId].addr = prevOwnership.addr;
2855             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2856             _ownerships[tokenId].burned = true;
2857 
2858             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2859             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2860             uint256 nextTokenId = tokenId + 1;
2861             if (_ownerships[nextTokenId].addr == address(0)) {
2862                 // This will suffice for checking _exists(nextTokenId),
2863                 // as a burned slot cannot contain the zero address.
2864                 if (nextTokenId < _currentIndex) {
2865                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2866                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2867                 }
2868             }
2869         }
2870 
2871         emit Transfer(prevOwnership.addr, address(0), tokenId);
2872         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
2873 
2874         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2875         unchecked {
2876             _burnCounter++;
2877         }
2878     }
2879 
2880     /**
2881      * @dev Approve `to` to operate on `tokenId`
2882      *
2883      * Emits a {Approval} event.
2884      */
2885     function _approve(
2886         address to,
2887         uint256 tokenId,
2888         address owner
2889     ) private {
2890         _tokenApprovals[tokenId] = to;
2891         emit Approval(owner, to, tokenId);
2892     }
2893 
2894     /**
2895      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2896      *
2897      * @param from address representing the previous owner of the given token ID
2898      * @param to target address that will receive the tokens
2899      * @param tokenId uint256 ID of the token to be transferred
2900      * @param _data bytes optional data to send along with the call
2901      * @return bool whether the call correctly returned the expected magic value
2902      */
2903     function _checkContractOnERC721Received(
2904         address from,
2905         address to,
2906         uint256 tokenId,
2907         bytes memory _data
2908     ) internal returns (bool) {
2909         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2910             return retval == IERC721Receiver(to).onERC721Received.selector;
2911         } catch (bytes memory reason) {
2912             if (reason.length == 0) {
2913                 revert TransferToNonERC721ReceiverImplementer();
2914             } else {
2915                 assembly {
2916                     revert(add(32, reason), mload(reason))
2917                 }
2918             }
2919         }
2920     }
2921 
2922     /**
2923      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2924      * And also called before burning one token.
2925      *
2926      * startTokenId - the first token id to be transferred
2927      * quantity - the amount to be transferred
2928      *
2929      * Calling conditions:
2930      *
2931      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2932      * transferred to `to`.
2933      * - When `from` is zero, `tokenId` will be minted for `to`.
2934      * - When `to` is zero, `tokenId` will be burned by `from`.
2935      * - `from` and `to` are never both zero.
2936      */
2937     function _beforeTokenTransfers(
2938         address from,
2939         address to,
2940         uint256 startTokenId,
2941         uint256 quantity
2942     ) internal virtual {}
2943 
2944     /**
2945      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2946      * minting.
2947      * And also called after one token has been burned.
2948      *
2949      * startTokenId - the first token id to be transferred
2950      * quantity - the amount to be transferred
2951      *
2952      * Calling conditions:
2953      *
2954      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2955      * transferred to `to`.
2956      * - When `from` is zero, `tokenId` has been minted for `to`.
2957      * - When `to` is zero, `tokenId` has been burned by `from`.
2958      * - `from` and `to` are never both zero.
2959      */
2960     function _afterTokenTransfers(
2961         address from,
2962         address to,
2963         uint256 startTokenId,
2964         uint256 quantity
2965     ) internal virtual {}
2966 }
2967 
2968 // File: contracts/TheGemesisByJohnathanSchultz.sol
2969 
2970 pragma solidity ^0.8.0 <0.9.0;
2971 
2972 
2973 contract TheGemesisByJohnathanSchultz is ERC721A, Ownable, ReentrancyGuard, EIP712, ERC2981, DefaultOperatorFilterer {
2974     
2975     uint8 public currentMintTier;
2976     string public contractURI;
2977     uint256 private royaltyFeesInBips;
2978     address private royaltyAddress;
2979 
2980     string public uriPrefix = '';
2981     string public uriSuffix = '.json';
2982     string public hiddenMetadataUri;
2983     
2984     uint256 public cost;
2985     uint256 public maxSupply;
2986     uint256 public maxMintAmountPerTx = 1;
2987 
2988     bool public paused = true;
2989     bool public revealed = false;
2990 
2991     struct NFTVoucher {
2992         uint256 minTokenId;
2993         uint256 maxTokenId;
2994         uint256 quantity;
2995         uint256 minPrice;
2996         address creator;    
2997         uint256 signatureTime;
2998     }
2999 
3000     struct merkleRoot {
3001         bytes32 merkleRoot;
3002         uint256 mintPrice;
3003         uint256 maxMintAmountPerTx;
3004         bool whitelistMintEnabled;
3005     }
3006 
3007     // PreciousGems -> 0 , TrueGems -> 1, FineGems -> 2 , GemList -> 3
3008     enum Tiers {
3009         PreciousGems,
3010         TrueGems,
3011         FineGems,
3012         GemList,
3013         Marketing
3014     }
3015 
3016     mapping(Tiers => merkleRoot) public merkleRootValue;
3017     mapping(bytes => uint256) public signatures;
3018 
3019     //mint 
3020     mapping(address => uint8) public mints;
3021 
3022     constructor(
3023         string memory _tokenName,
3024         string memory _tokenSymbol,
3025         uint256 _cost,
3026         uint256 _maxSupply,
3027         uint256 _maxMintAmountPerTx,
3028         string memory _hiddenMetadataUri,
3029         uint96 _royaltyFeesInBips, 
3030         string memory _contractURI
3031     ) ERC721A(_tokenName, _tokenSymbol) 
3032     EIP712("GemSet Lazy Contract", "1.0") {
3033         cost = _cost;
3034         maxSupply = _maxSupply;
3035         maxMintAmountPerTx = _maxMintAmountPerTx;
3036         setHiddenMetadataUri(_hiddenMetadataUri);
3037         setRoyaltyInfo(owner(), _royaltyFeesInBips);
3038         contractURI = _contractURI;
3039     }
3040 
3041     modifier signatureVerify(NFTVoucher calldata _voucher,bytes memory _signature,uint256 _mintQuantity) {
3042         address signer = _verify(_voucher, _signature);
3043         require(signer == _voucher.creator, "Signature invalid or unauthorized creator");
3044         require((currentIndex() <= _voucher.maxTokenId) && (currentIndex() >= _voucher.minTokenId), "Signature invalid or invalid maxTokenId or invalid minTokenId!");
3045         require((((currentIndex() + _mintQuantity - 1)) <= _voucher.maxTokenId) && (_mintQuantity <= _voucher.quantity), "Signature invalid or invalid maxTokenId or invalid quantity !");
3046         _;
3047     }
3048 
3049     // Verify whitelist requirements 
3050     
3051     // _tier == 0 (Tiers.PreciousGems) => merkleRootValue[_tier]     
3052     // _tier == 1 (Tiers.TrueGems) => merkleRootValue[_tier]     
3053     // _tier == 2 (Tiers.FineGems) => merkleRootValue[_tier]     
3054     // _tier == 3 (Tiers.GemList) => merkleRootValue[_tier]     
3055     
3056     function whitelistMint(Tiers _tier,NFTVoucher calldata _voucher,uint256 _mintQuantity, bytes32[] calldata _merkleProof,bytes memory _signature) public payable 
3057         signatureVerify(_voucher,_signature,_mintQuantity)
3058     {
3059         
3060         require(merkleRootValue[_tier].whitelistMintEnabled, "The whitelist sale is not enabled!");
3061 
3062         require(_mintQuantity > 0 && (currentIndex() + _mintQuantity) <= maxSupply, "Invalid mint amount!");
3063 
3064         require(mints[msg.sender] + _mintQuantity <= merkleRootValue[_tier].maxMintAmountPerTx, "Max supply exceeded!");
3065 
3066         require(msg.value >= merkleRootValue[_tier].mintPrice * _mintQuantity, "Insufficient funds!");
3067         
3068         
3069         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
3070         
3071         require(MerkleProof.verify(_merkleProof, merkleRootValue[_tier].merkleRoot, leaf), "Invalid proof!");
3072 
3073         _safeMint(msg.sender, _mintQuantity);
3074         signatures[_signature] += _mintQuantity;
3075         mints[msg.sender]++;
3076     }
3077 
3078     function mint(NFTVoucher calldata _voucher,uint256 _mintQuantity,bytes memory _signature) public payable 
3079         signatureVerify(_voucher,_signature,_mintQuantity)
3080     {
3081         require((!paused) && (_voucher.minPrice <= cost), "The contract is paused or Invalid mint price!");
3082 
3083         require(_mintQuantity > 0 && (currentIndex() + _mintQuantity) <= maxSupply, "Invalid mint amount!");
3084 
3085         require(mints[msg.sender] + _mintQuantity <= maxMintAmountPerTx, "Max supply exceeded!");
3086 
3087 
3088         require(msg.value >= cost * _mintQuantity, "Insufficient funds!");
3089 
3090         _safeMint(msg.sender, _mintQuantity);
3091         signatures[_signature] += _mintQuantity;
3092         mints[msg.sender]++;
3093     }    
3094 
3095     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3096         super.transferFrom(from, to, tokenId);
3097     }
3098 
3099     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3100         super.safeTransferFrom(from, to, tokenId);
3101     }
3102 
3103     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3104         public
3105         override
3106         onlyAllowedOperator(from)
3107     {
3108         super.safeTransferFrom(from, to, tokenId, data);
3109     }
3110 
3111     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3112         super.setApprovalForAll(operator, approved);
3113     }
3114 
3115     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3116         super.approve(operator, tokenId);
3117     }
3118 
3119     function _hash(NFTVoucher calldata voucher) internal view returns (bytes32) {
3120         return _hashTypedDataV4(keccak256(abi.encode(
3121             keccak256("NFTVoucher(uint256 minTokenId,uint256 maxTokenId,uint256 quantity,uint256 minPrice,address creator,uint256 signatureTime)"),
3122             voucher.minTokenId,
3123             voucher.maxTokenId,
3124             voucher.quantity,
3125             voucher.minPrice,
3126             voucher.creator,
3127             voucher.signatureTime
3128         )));
3129     }
3130 
3131     function _verify(NFTVoucher calldata voucher, bytes memory signature) internal view returns (address) {
3132         bytes32 digest = _hash(voucher);
3133         return ECDSA.recover(digest,signature);
3134     }
3135 
3136     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
3137         uint256 ownerTokenCount = balanceOf(_owner);
3138         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
3139         uint256 currentTokenId = _startTokenId();
3140         uint256 ownedTokenIndex = 0;
3141         address latestOwnerAddress;
3142 
3143         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
3144         TokenOwnership memory ownership = _ownerships[currentTokenId];
3145 
3146         if (!ownership.burned && ownership.addr != address(0)) {
3147             latestOwnerAddress = ownership.addr;
3148         }
3149 
3150         if (latestOwnerAddress == _owner) {
3151             ownedTokenIds[ownedTokenIndex] = currentTokenId;
3152 
3153             ownedTokenIndex++;
3154         }
3155 
3156         currentTokenId++;
3157         }
3158 
3159         return ownedTokenIds;
3160     }
3161 
3162 
3163     function _startTokenId() internal view virtual override returns (uint256) {
3164         return 1;
3165     }
3166 
3167     function currentIndex() public view returns(uint256) {
3168         return _currentIndex;
3169     }
3170 
3171     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3172         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
3173 
3174         if (revealed == false) {
3175             return hiddenMetadataUri;
3176         }
3177 
3178         string memory currentBaseURI = _baseURI();
3179         return bytes(currentBaseURI).length > 0
3180             ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
3181             : '';
3182     }
3183 
3184     function setRevealed(bool _state) public onlyOwner {
3185         revealed = _state;
3186     }
3187 
3188     function setCost(uint256 _cost,uint256 _maxMintAmountPerTx) public onlyOwner {
3189         cost = _cost;
3190         maxMintAmountPerTx = _maxMintAmountPerTx;
3191     }
3192 
3193     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
3194         hiddenMetadataUri = _hiddenMetadataUri;
3195     }
3196 
3197     function setUriPrefix(string calldata _uriPrefix) public onlyOwner {
3198         uriPrefix = _uriPrefix;
3199     }
3200 
3201     function setUriSuffix(string calldata _uriSuffix) public onlyOwner {
3202         uriSuffix = _uriSuffix;
3203     }
3204 
3205     function setPaused(bool _state) public onlyOwner {
3206         paused = _state;
3207     }
3208 
3209     function setMerkleRoot(bytes32 _merkleRoot,Tiers _tier,uint256 _mintPrice,uint256 _maxMintAmountPerTx,bool _whitelistMintEnabled) public onlyOwner {
3210         merkleRootValue[_tier] = merkleRoot(
3211             _merkleRoot,
3212             _mintPrice,
3213             _maxMintAmountPerTx,
3214             _whitelistMintEnabled
3215         );
3216         if(_whitelistMintEnabled == true){
3217             currentMintTier = uint8(_tier);
3218         }
3219     }
3220 
3221     function setWhitelistMintEnabled(Tiers _tier, bool _state) public onlyOwner {
3222         merkleRootValue[_tier].whitelistMintEnabled = _state;
3223         if(_state == true){
3224             currentMintTier = uint8(_tier);
3225         }
3226     }
3227 
3228     function setContractTokenURI(string memory _contractURI) public onlyOwner {
3229         contractURI = _contractURI;
3230     }
3231 
3232     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
3233         royaltyAddress = _receiver;
3234         royaltyFeesInBips = _royaltyFeesInBips;
3235     }
3236 
3237     function withdraw() public onlyOwner nonReentrant {
3238         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
3239         require(os);
3240     }
3241 
3242     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
3243         return (royaltyAddress, calculateRoyalty(_salePrice));
3244     }
3245 
3246     // ((10000  / 10000) * 250) =>  (2.5 % * 10000) => 250
3247     function calculateRoyalty(uint256 _salePrice) view public returns (uint256) {
3248         return (_salePrice / 10000) * royaltyFeesInBips;
3249     }
3250 
3251     function supportsInterface(
3252         bytes4 interfaceId
3253     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
3254         return 
3255             ERC721A.supportsInterface(interfaceId) || 
3256             ERC2981.supportsInterface(interfaceId) || 
3257             super.supportsInterface(interfaceId);
3258     }
3259 }