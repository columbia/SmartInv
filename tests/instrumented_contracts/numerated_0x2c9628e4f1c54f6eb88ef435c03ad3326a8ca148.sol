1 // SPDX-License-Identifier: UNLICENSED
2 
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
384 // File: contracts/IOperatorFilterRegistry.sol
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
415 // File: contracts/OperatorFilterer.sol
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
454 // File: contracts/DefaultOperatorFilterer.sol
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
465 // File: underdogenft.sol
466 
467 
468 
469 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @dev Contract module that helps prevent reentrant calls to a function.
479  *
480  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
481  * available, which can be applied to functions to make sure there are no nested
482  * (reentrant) calls to them.
483  *
484  * Note that because there is a single `nonReentrant` guard, functions marked as
485  * `nonReentrant` may not call one another. This can be worked around by making
486  * those functions `private`, and then adding `external` `nonReentrant` entry
487  * points to them.
488  *
489  * TIP: If you would like to learn more about reentrancy and alternative ways
490  * to protect against it, check out our blog post
491  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
492  */
493 abstract contract ReentrancyGuard {
494     // Booleans are more expensive than uint256 or any type that takes up a full
495     // word because each write operation emits an extra SLOAD to first read the
496     // slot's contents, replace the bits taken up by the boolean, and then write
497     // back. This is the compiler's defense against contract upgrades and
498     // pointer aliasing, and it cannot be disabled.
499 
500     // The values being non-zero value makes deployment a bit more expensive,
501     // but in exchange the refund on every call to nonReentrant will be lower in
502     // amount. Since refunds are capped to a percentage of the total
503     // transaction's gas, it is best to keep them low in cases like this one, to
504     // increase the likelihood of the full refund coming into effect.
505     uint256 private constant _NOT_ENTERED = 1;
506     uint256 private constant _ENTERED = 2;
507 
508     uint256 private _status;
509 
510     constructor() {
511         _status = _NOT_ENTERED;
512     }
513 
514     /**
515      * @dev Prevents a contract from calling itself, directly or indirectly.
516      * Calling a `nonReentrant` function from another `nonReentrant`
517      * function is not supported. It is possible to prevent this from happening
518      * by making the `nonReentrant` function external, and making it call a
519      * `private` function that does the actual work.
520      */
521     modifier nonReentrant() {
522         // On the first call to nonReentrant, _notEntered will be true
523         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
524 
525         // Any calls to nonReentrant after this point will fail
526         _status = _ENTERED;
527 
528         _;
529 
530         // By storing the original value once again, a refund is triggered (see
531         // https://eips.ethereum.org/EIPS/eip-2200)
532         _status = _NOT_ENTERED;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
537 
538 
539 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev These functions deal with verification of Merkle Trees proofs.
545  *
546  * The proofs can be generated using the JavaScript library
547  * https://github.com/miguelmota/merkletreejs[merkletreejs].
548  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
549  *
550  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
551  */
552 library MerkleProof {
553     /**
554      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
555      * defined by `root`. For this, a `proof` must be provided, containing
556      * sibling hashes on the branch from the leaf to the root of the tree. Each
557      * pair of leaves and each pair of pre-images are assumed to be sorted.
558      */
559     function verify(
560         bytes32[] memory proof,
561         bytes32 root,
562         bytes32 leaf
563     ) internal pure returns (bool) {
564         return processProof(proof, leaf) == root;
565     }
566 
567     /**
568      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
569      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
570      * hash matches the root of the tree. When processing the proof, the pairs
571      * of leafs & pre-images are assumed to be sorted.
572      *
573      * _Available since v4.4._
574      */
575     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
576         bytes32 computedHash = leaf;
577         for (uint256 i = 0; i < proof.length; i++) {
578             bytes32 proofElement = proof[i];
579             if (computedHash <= proofElement) {
580                 // Hash(current computed hash + current element of the proof)
581                 computedHash = _efficientHash(computedHash, proofElement);
582             } else {
583                 // Hash(current element of the proof + current computed hash)
584                 computedHash = _efficientHash(proofElement, computedHash);
585             }
586         }
587         return computedHash;
588     }
589 
590     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
591         assembly {
592             mstore(0x00, a)
593             mstore(0x20, b)
594             value := keccak256(0x00, 0x40)
595         }
596     }
597 }
598 
599 // File: @openzeppelin/contracts/utils/Strings.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 /**
607  * @dev String operations.
608  */
609 library Strings {
610     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
614      */
615     function toString(uint256 value) internal pure returns (string memory) {
616         // Inspired by OraclizeAPI's implementation - MIT licence
617         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
618 
619         if (value == 0) {
620             return "0";
621         }
622         uint256 temp = value;
623         uint256 digits;
624         while (temp != 0) {
625             digits++;
626             temp /= 10;
627         }
628         bytes memory buffer = new bytes(digits);
629         while (value != 0) {
630             digits -= 1;
631             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
632             value /= 10;
633         }
634         return string(buffer);
635     }
636 
637     /**
638      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
639      */
640     function toHexString(uint256 value) internal pure returns (string memory) {
641         if (value == 0) {
642             return "0x00";
643         }
644         uint256 temp = value;
645         uint256 length = 0;
646         while (temp != 0) {
647             length++;
648             temp >>= 8;
649         }
650         return toHexString(value, length);
651     }
652 
653     /**
654      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
655      */
656     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
657         bytes memory buffer = new bytes(2 * length + 2);
658         buffer[0] = "0";
659         buffer[1] = "x";
660         for (uint256 i = 2 * length + 1; i > 1; --i) {
661             buffer[i] = _HEX_SYMBOLS[value & 0xf];
662             value >>= 4;
663         }
664         require(value == 0, "Strings: hex length insufficient");
665         return string(buffer);
666     }
667 }
668 
669 // File: @openzeppelin/contracts/utils/Context.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Provides information about the current execution context, including the
678  * sender of the transaction and its data. While these are generally available
679  * via msg.sender and msg.data, they should not be accessed in such a direct
680  * manner, since when dealing with meta-transactions the account sending and
681  * paying for execution may not be the actual sender (as far as an application
682  * is concerned).
683  *
684  * This contract is only required for intermediate, library-like contracts.
685  */
686 abstract contract Context {
687     function _msgSender() internal view virtual returns (address) {
688         return msg.sender;
689     }
690 
691     function _msgData() internal view virtual returns (bytes calldata) {
692         return msg.data;
693     }
694 }
695 
696 // File: @openzeppelin/contracts/access/Ownable.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Contract module which provides a basic access control mechanism, where
706  * there is an account (an owner) that can be granted exclusive access to
707  * specific functions.
708  *
709  * By default, the owner account will be the one that deploys the contract. This
710  * can later be changed with {transferOwnership}.
711  *
712  * This module is used through inheritance. It will make available the modifier
713  * `onlyOwner`, which can be applied to your functions to restrict their use to
714  * the owner.
715  */
716 abstract contract Ownable is Context {
717     address private _owner;
718 
719     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
720 
721     /**
722      * @dev Initializes the contract setting the deployer as the initial owner.
723      */
724     constructor() {
725         _transferOwnership(_msgSender());
726     }
727 
728     /**
729      * @dev Returns the address of the current owner.
730      */
731     function owner() public view virtual returns (address) {
732         return _owner;
733     }
734 
735     /**
736      * @dev Throws if called by any account other than the owner.
737      */
738     modifier onlyOwner() {
739         require(owner() == _msgSender(), "Ownable: caller is not the owner");
740         _;
741     }
742 
743     /**
744      * @dev Leaves the contract without owner. It will not be possible to call
745      * `onlyOwner` functions anymore. Can only be called by the current owner.
746      *
747      * NOTE: Renouncing ownership will leave the contract without an owner,
748      * thereby removing any functionality that is only available to the owner.
749      */
750     function renounceOwnership() public virtual onlyOwner {
751         _transferOwnership(address(0));
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (`newOwner`).
756      * Can only be called by the current owner.
757      */
758     function transferOwnership(address newOwner) public virtual onlyOwner {
759         require(newOwner != address(0), "Ownable: new owner is the zero address");
760         _transferOwnership(newOwner);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Internal function without access restriction.
766      */
767     function _transferOwnership(address newOwner) internal virtual {
768         address oldOwner = _owner;
769         _owner = newOwner;
770         emit OwnershipTransferred(oldOwner, newOwner);
771     }
772 }
773 
774 // File: @openzeppelin/contracts/utils/Address.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
778 
779 pragma solidity ^0.8.1;
780 
781 /**
782  * @dev Collection of functions related to the address type
783  */
784 library Address {
785     /**
786      * @dev Returns true if `account` is a contract.
787      *
788      * [IMPORTANT]
789      * ====
790      * It is unsafe to assume that an address for which this function returns
791      * false is an externally-owned account (EOA) and not a contract.
792      *
793      * Among others, `isContract` will return false for the following
794      * types of addresses:
795      *
796      *  - an externally-owned account
797      *  - a contract in construction
798      *  - an address where a contract will be created
799      *  - an address where a contract lived, but was destroyed
800      * ====
801      *
802      * [IMPORTANT]
803      * ====
804      * You shouldn't rely on `isContract` to protect against flash loan attacks!
805      *
806      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
807      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
808      * constructor.
809      * ====
810      */
811     function isContract(address account) internal view returns (bool) {
812         // This method relies on extcodesize/address.code.length, which returns 0
813         // for contracts in construction, since the code is only stored at the end
814         // of the constructor execution.
815 
816         return account.code.length > 0;
817     }
818 
819     /**
820      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
821      * `recipient`, forwarding all available gas and reverting on errors.
822      *
823      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas Cost
824      * of certain opcodes, possibly making contracts go over the 2300 gas limit
825      * imposed by `transfer`, making them unable to receive funds via
826      * `transfer`. {sendValue} removes this limitation.
827      *
828      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
829      *
830      * IMPORTANT: because control is transferred to `recipient`, care must be
831      * taken to not create reentrancy vulnerabilities. Consider using
832      * {ReentrancyGuard} or the
833      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
834      */
835     function sendValue(address payable recipient, uint256 amount) internal {
836         require(address(this).balance >= amount, "Address: insufficient balance");
837 
838         (bool success, ) = recipient.call{value: amount}("");
839         require(success, "Address: unable to send value, recipient may have reverted");
840     }
841 
842     /**
843      * @dev Performs a Solidity function call using a low level `call`. A
844      * plain `call` is an unsafe replacement for a function call: use this
845      * function instead.
846      *
847      * If `target` reverts with a revert reason, it is bubbled up by this
848      * function (like regular Solidity function calls).
849      *
850      * Returns the raw returned data. To convert to the expected return value,
851      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
852      *
853      * Requirements:
854      *
855      * - `target` must be a contract.
856      * - calling `target` with `data` must not revert.
857      *
858      * _Available since v3.1._
859      */
860     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
861         return functionCall(target, data, "Address: low-level call failed");
862     }
863 
864     /**
865      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
866      * `errorMessage` as a fallback revert reason when `target` reverts.
867      *
868      * _Available since v3.1._
869      */
870     function functionCall(
871         address target,
872         bytes memory data,
873         string memory errorMessage
874     ) internal returns (bytes memory) {
875         return functionCallWithValue(target, data, 0, errorMessage);
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
880      * but also transferring `value` wei to `target`.
881      *
882      * Requirements:
883      *
884      * - the calling contract must have an ETH balance of at least `value`.
885      * - the called Solidity function must be `payable`.
886      *
887      * _Available since v3.1._
888      */
889     function functionCallWithValue(
890         address target,
891         bytes memory data,
892         uint256 value
893     ) internal returns (bytes memory) {
894         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
895     }
896 
897     /**
898      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
899      * with `errorMessage` as a fallback revert reason when `target` reverts.
900      *
901      * _Available since v3.1._
902      */
903     function functionCallWithValue(
904         address target,
905         bytes memory data,
906         uint256 value,
907         string memory errorMessage
908     ) internal returns (bytes memory) {
909         require(address(this).balance >= value, "Address: insufficient balance for call");
910         require(isContract(target), "Address: call to non-contract");
911 
912         (bool success, bytes memory returndata) = target.call{value: value}(data);
913         return verifyCallResult(success, returndata, errorMessage);
914     }
915 
916     /**
917      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
918      * but performing a static call.
919      *
920      * _Available since v3.3._
921      */
922     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
923         return functionStaticCall(target, data, "Address: low-level static call failed");
924     }
925 
926     /**
927      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
928      * but performing a static call.
929      *
930      * _Available since v3.3._
931      */
932     function functionStaticCall(
933         address target,
934         bytes memory data,
935         string memory errorMessage
936     ) internal view returns (bytes memory) {
937         require(isContract(target), "Address: static call to non-contract");
938 
939         (bool success, bytes memory returndata) = target.staticcall(data);
940         return verifyCallResult(success, returndata, errorMessage);
941     }
942 
943     /**
944      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
945      * but performing a delegate call.
946      *
947      * _Available since v3.4._
948      */
949     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
950         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
951     }
952 
953     /**
954      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
955      * but performing a delegate call.
956      *
957      * _Available since v3.4._
958      */
959     function functionDelegateCall(
960         address target,
961         bytes memory data,
962         string memory errorMessage
963     ) internal returns (bytes memory) {
964         require(isContract(target), "Address: delegate call to non-contract");
965 
966         (bool success, bytes memory returndata) = target.delegatecall(data);
967         return verifyCallResult(success, returndata, errorMessage);
968     }
969 
970     /**
971      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
972      * revert reason using the provided one.
973      *
974      * _Available since v4.3._
975      */
976     function verifyCallResult(
977         bool success,
978         bytes memory returndata,
979         string memory errorMessage
980     ) internal pure returns (bytes memory) {
981         if (success) {
982             return returndata;
983         } else {
984             // Look for revert reason and bubble it up if present
985             if (returndata.length > 0) {
986                 // The easiest way to bubble the revert reason is using memory via assembly
987 
988                 assembly {
989                     let returndata_size := mload(returndata)
990                     revert(add(32, returndata), returndata_size)
991                 }
992             } else {
993                 revert(errorMessage);
994             }
995         }
996     }
997 }
998 
999 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1000 
1001 
1002 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 /**
1007  * @title ERC721 token receiver interface
1008  * @dev Interface for any contract that wants to support safeTransfers
1009  * from ERC721 asset contracts.
1010  */
1011 interface IERC721Receiver {
1012     /**
1013      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1014      * by `operator` from `from`, this function is called.
1015      *
1016      * It must return its Solidity selector to confirm the token transfer.
1017      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1018      *
1019      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1020      */
1021     function onERC721Received(
1022         address operator,
1023         address from,
1024         uint256 tokenId,
1025         bytes calldata data
1026     ) external returns (bytes4);
1027 }
1028 
1029 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1030 
1031 
1032 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 /**
1037  * @dev Interface of the ERC165 standard, as defined in the
1038  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1039  *
1040  * Implementers can declare support of contract interfaces, which can then be
1041  * queried by others ({ERC165Checker}).
1042  *
1043  * For an implementation, see {ERC165}.
1044  */
1045 interface IERC165 {
1046     /**
1047      * @dev Returns true if this contract implements the interface defined by
1048      * `interfaceId`. See the corresponding
1049      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1050      * to learn more about how these ids are created.
1051      *
1052      * This function call must use less than 30 000 gas.
1053      */
1054     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1055 }
1056 
1057 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1058 
1059 
1060 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 
1065 /**
1066  * @dev Implementation of the {IERC165} interface.
1067  *
1068  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1069  * for the additional interface id that will be supported. For example:
1070  *
1071  * ```solidity
1072  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1073  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1074  * }
1075  * ```
1076  *
1077  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1078  */
1079 abstract contract ERC165 is IERC165 {
1080     /**
1081      * @dev See {IERC165-supportsInterface}.
1082      */
1083     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1084         return interfaceId == type(IERC165).interfaceId;
1085     }
1086 }
1087 
1088 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1089 
1090 
1091 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 
1096 /**
1097  * @dev Required interface of an ERC721 compliant contract.
1098  */
1099 interface IERC721 is IERC165 {
1100     /**
1101      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1102      */
1103     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1104 
1105     /**
1106      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1107      */
1108     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1109 
1110     /**
1111      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1112      */
1113     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1114 
1115     /**
1116      * @dev Returns the number of tokens in ``owner``'s account.
1117      */
1118     function balanceOf(address owner) external view returns (uint256 balance);
1119 
1120     /**
1121      * @dev Returns the owner of the `tokenId` token.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must exist.
1126      */
1127     function ownerOf(uint256 tokenId) external view returns (address owner);
1128 
1129     /**
1130      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1131      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1132      *
1133      * Requirements:
1134      *
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must exist and be owned by `from`.
1138      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function safeTransferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) external;
1148 
1149     /**
1150      * @dev Transfers `tokenId` token from `from` to `to`.
1151      *
1152      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1153      *
1154      * Requirements:
1155      *
1156      * - `from` cannot be the zero address.
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must be owned by `from`.
1159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function transferFrom(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) external;
1168 
1169     /**
1170      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1171      * The approval is cleared when the token is transferred.
1172      *
1173      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1174      *
1175      * Requirements:
1176      *
1177      * - The caller must own the token or be an approved operator.
1178      * - `tokenId` must exist.
1179      *
1180      * Emits an {Approval} event.
1181      */
1182     function approve(address to, uint256 tokenId) external;
1183 
1184     /**
1185      * @dev Returns the account approved for `tokenId` token.
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must exist.
1190      */
1191     function getApproved(uint256 tokenId) external view returns (address operator);
1192 
1193     /**
1194      * @dev Approve or remove `operator` as an operator for the caller.
1195      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1196      *
1197      * Requirements:
1198      *
1199      * - The `operator` cannot be the caller.
1200      *
1201      * Emits an {ApprovalForAll} event.
1202      */
1203     function setApprovalForAll(address operator, bool _approved) external;
1204 
1205     /**
1206      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1207      *
1208      * See {setApprovalForAll}
1209      */
1210     function isApprovedForAll(address owner, address operator) external view returns (bool);
1211 
1212     /**
1213      * @dev Safely transfers `tokenId` token from `from` to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - `from` cannot be the zero address.
1218      * - `to` cannot be the zero address.
1219      * - `tokenId` token must exist and be owned by `from`.
1220      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes calldata data
1230     ) external;
1231 }
1232 
1233 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1234 
1235 
1236 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 
1241 /**
1242  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1243  * @dev See https://eips.ethereum.org/EIPS/eip-721
1244  */
1245 interface IERC721Metadata is IERC721 {
1246     /**
1247      * @dev Returns the token collection name.
1248      */
1249     function name() external view returns (string memory);
1250 
1251     /**
1252      * @dev Returns the token collection symbol.
1253      */
1254     function symbol() external view returns (string memory);
1255 
1256     /**
1257      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1258      */
1259     function tokenURI(uint256 tokenId) external view returns (string memory);
1260 }
1261 
1262 // File: erc721a/contracts/ERC721A.sol
1263 
1264 
1265 // Creator: Chiru Labs
1266 
1267 pragma solidity ^0.8.4;
1268 
1269 
1270 
1271 
1272 
1273 
1274 
1275 
1276 error ApprovalCallerNotOwnerNorApproved();
1277 error ApprovalQueryForNonexistentToken();
1278 error ApproveToCaller();
1279 error ApprovalToCurrentOwner();
1280 error BalanceQueryForZeroAddress();
1281 error MintToZeroAddress();
1282 error MintZeroQuantity();
1283 error OwnerQueryForNonexistentToken();
1284 error TransferCallerNotOwnerNorApproved();
1285 error TransferFromIncorrectOwner();
1286 error TransferToNonERC721ReceiverImplementer();
1287 error TransferToZeroAddress();
1288 error URIQueryForNonexistentToken();
1289 
1290 /**
1291  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1292  * the Metadata extension. Built to optimize for lower gas during batch mints.
1293  *
1294  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1295  *
1296  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1297  *
1298  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1299  */
1300 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1301     using Address for address;
1302     using Strings for uint256;
1303 
1304     // Compiler will pack this into a single 256bit word.
1305     struct TokenOwnership {
1306         // The address of the owner.
1307         address addr;
1308         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1309         uint64 startTimestamp;
1310         // Whether the token has been burned.
1311         bool burned;
1312     }
1313 
1314     // Compiler will pack this into a single 256bit word.
1315     struct AddressData {
1316         // Realistically, 2**64-1 is more than enough.
1317         uint64 balance;
1318         // Keeps track of mint count with minimal overhead for tokenomics.
1319         uint64 numberMinted;
1320         // Keeps track of burn count with minimal overhead for tokenomics.
1321         uint64 numberBurned;
1322         // For miscellaneous variable(s) pertaining to the address
1323         // (e.g. number of whitelist mint slots used).
1324         // If there are multiple variables, please pack them into a uint64.
1325         uint64 aux;
1326     }
1327 
1328     // The tokenId of the next token to be minted.
1329     uint256 internal _currentIndex;
1330 
1331     // The number of tokens burned.
1332     uint256 internal _burnCounter;
1333 
1334     // Token name
1335     string private _name;
1336 
1337     // Token symbol
1338     string private _symbol;
1339 
1340     // Mapping from token ID to ownership details
1341     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1342     mapping(uint256 => TokenOwnership) internal _ownerships;
1343 
1344     // Mapping owner address to address data
1345     mapping(address => AddressData) private _addressData;
1346 
1347     // Mapping from token ID to approved address
1348     mapping(uint256 => address) private _tokenApprovals;
1349 
1350     // Mapping from owner to operator approvals
1351     mapping(address => mapping(address => bool)) private _operatorApprovals;
1352 
1353     constructor(string memory name_, string memory symbol_) {
1354         _name = name_;
1355         _symbol = symbol_;
1356         _currentIndex = _startTokenId();
1357     }
1358 
1359     /**
1360      * To change the starting tokenId, please override this function.
1361      */
1362     function _startTokenId() internal view virtual returns (uint256) {
1363         return 0;
1364     }
1365 
1366     /**
1367      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1368      */
1369     function totalSupply() public view returns (uint256) {
1370         // Counter underflow is impossible as _burnCounter cannot be incremented
1371         // more than _currentIndex - _startTokenId() times
1372         unchecked {
1373             return _currentIndex - _burnCounter - _startTokenId();
1374         }
1375     }
1376 
1377     /**
1378      * Returns the total amount of tokens minted in the contract.
1379      */
1380     function _totalMinted() internal view returns (uint256) {
1381         // Counter underflow is impossible as _currentIndex does not decrement,
1382         // and it is initialized to _startTokenId()
1383         unchecked {
1384             return _currentIndex - _startTokenId();
1385         }
1386     }
1387 
1388     /**
1389      * @dev See {IERC165-supportsInterface}.
1390      */
1391     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1392         return
1393             interfaceId == type(IERC721).interfaceId ||
1394             interfaceId == type(IERC721Metadata).interfaceId ||
1395             super.supportsInterface(interfaceId);
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-balanceOf}.
1400      */
1401     function balanceOf(address owner) public view override returns (uint256) {
1402         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1403         return uint256(_addressData[owner].balance);
1404     }
1405 
1406     /**
1407      * Returns the number of tokens minted by `owner`.
1408      */
1409     function _numberMinted(address owner) internal view returns (uint256) {
1410         return uint256(_addressData[owner].numberMinted);
1411     }
1412 
1413     /**
1414      * Returns the number of tokens burned by or on behalf of `owner`.
1415      */
1416     function _numberBurned(address owner) internal view returns (uint256) {
1417         return uint256(_addressData[owner].numberBurned);
1418     }
1419 
1420     /**
1421      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1422      */
1423     function _getAux(address owner) internal view returns (uint64) {
1424         return _addressData[owner].aux;
1425     }
1426 
1427     /**
1428      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1429      * If there are multiple variables, please pack them into a uint64.
1430      */
1431     function _setAux(address owner, uint64 aux) internal {
1432         _addressData[owner].aux = aux;
1433     }
1434 
1435     /**
1436      * Gas spent here starts off proportional to the maximum mint batch size.
1437      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1438      */
1439     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1440         uint256 curr = tokenId;
1441 
1442         unchecked {
1443             if (_startTokenId() <= curr && curr < _currentIndex) {
1444                 TokenOwnership memory ownership = _ownerships[curr];
1445                 if (!ownership.burned) {
1446                     if (ownership.addr != address(0)) {
1447                         return ownership;
1448                     }
1449                     // Invariant:
1450                     // There will always be an ownership that has an address and is not burned
1451                     // before an ownership that does not have an address and is not burned.
1452                     // Hence, curr will not underflow.
1453                     while (true) {
1454                         curr--;
1455                         ownership = _ownerships[curr];
1456                         if (ownership.addr != address(0)) {
1457                             return ownership;
1458                         }
1459                     }
1460                 }
1461             }
1462         }
1463         revert OwnerQueryForNonexistentToken();
1464     }
1465 
1466     /**
1467      * @dev See {IERC721-ownerOf}.
1468      */
1469     function ownerOf(uint256 tokenId) public view override returns (address) {
1470         return _ownershipOf(tokenId).addr;
1471     }
1472 
1473     /**
1474      * @dev See {IERC721Metadata-name}.
1475      */
1476     function name() public view virtual override returns (string memory) {
1477         return _name;
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Metadata-symbol}.
1482      */
1483     function symbol() public view virtual override returns (string memory) {
1484         return _symbol;
1485     }
1486 
1487     /**
1488      * @dev See {IERC721Metadata-tokenURI}.
1489      */
1490     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1491         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1492 
1493         string memory baseURI = _baseURI();
1494         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1495     }
1496 
1497     /**
1498      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1499      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1500      * by default, can be overriden in child contracts.
1501      */
1502     function _baseURI() internal view virtual returns (string memory) {
1503         return '';
1504     }
1505 
1506     /**
1507      * @dev See {IERC721-approve}.
1508      */
1509     function approve(address to, uint256 tokenId) public override {
1510         address owner = ERC721A.ownerOf(tokenId);
1511         if (to == owner) revert ApprovalToCurrentOwner();
1512 
1513         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1514             revert ApprovalCallerNotOwnerNorApproved();
1515         }
1516 
1517         _approve(to, tokenId, owner);
1518     }
1519 
1520     /**
1521      * @dev See {IERC721-getApproved}.
1522      */
1523     function getApproved(uint256 tokenId) public view override returns (address) {
1524         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1525 
1526         return _tokenApprovals[tokenId];
1527     }
1528 
1529     /**
1530      * @dev See {IERC721-setApprovalForAll}.
1531      */
1532     function setApprovalForAll(address operator, bool approved) public virtual override {
1533         if (operator == _msgSender()) revert ApproveToCaller();
1534 
1535         _operatorApprovals[_msgSender()][operator] = approved;
1536         emit ApprovalForAll(_msgSender(), operator, approved);
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-isApprovedForAll}.
1541      */
1542     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1543         return _operatorApprovals[owner][operator];
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-transferFrom}.
1548      */
1549     function transferFrom(
1550         address from,
1551         address to,
1552         uint256 tokenId
1553     ) public virtual override {
1554         _transfer(from, to, tokenId);
1555     }
1556 
1557     /**
1558      * @dev See {IERC721-safeTransferFrom}.
1559      */
1560     function safeTransferFrom(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) public virtual override {
1565         safeTransferFrom(from, to, tokenId, '');
1566     }
1567 
1568     /**
1569      * @dev See {IERC721-safeTransferFrom}.
1570      */
1571     function safeTransferFrom(
1572         address from,
1573         address to,
1574         uint256 tokenId,
1575         bytes memory _data
1576     ) public virtual override {
1577         _transfer(from, to, tokenId);
1578         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1579             revert TransferToNonERC721ReceiverImplementer();
1580         }
1581     }
1582 
1583     /**
1584      * @dev Returns whether `tokenId` exists.
1585      *
1586      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1587      *
1588      * Tokens start existing when they are minted (`_mint`),
1589      */
1590     function _exists(uint256 tokenId) internal view returns (bool) {
1591         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1592     }
1593 
1594     function _safeMint(address to, uint256 quantity) internal {
1595         _safeMint(to, quantity, '');
1596     }
1597 
1598     /**
1599      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1600      *
1601      * Requirements:
1602      *
1603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1604      * - `quantity` must be greater than 0.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function _safeMint(
1609         address to,
1610         uint256 quantity,
1611         bytes memory _data
1612     ) internal {
1613         _mint(to, quantity, _data, true);
1614     }
1615 
1616     /**
1617      * @dev Mints `quantity` tokens and transfers them to `to`.
1618      *
1619      * Requirements:
1620      *
1621      * - `to` cannot be the zero address.
1622      * - `quantity` must be greater than 0.
1623      *
1624      * Emits a {Transfer} event.
1625      */
1626     function _mint(
1627         address to,
1628         uint256 quantity,
1629         bytes memory _data,
1630         bool safe
1631     ) internal {
1632         uint256 startTokenId = _currentIndex;
1633         if (to == address(0)) revert MintToZeroAddress();
1634         if (quantity == 0) revert MintZeroQuantity();
1635 
1636         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1637 
1638         // Overflows are incredibly unrealistic.
1639         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1640         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1641         unchecked {
1642             _addressData[to].balance += uint64(quantity);
1643             _addressData[to].numberMinted += uint64(quantity);
1644 
1645             _ownerships[startTokenId].addr = to;
1646             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1647 
1648             uint256 updatedIndex = startTokenId;
1649             uint256 end = updatedIndex + quantity;
1650 
1651             if (safe && to.isContract()) {
1652                 do {
1653                     emit Transfer(address(0), to, updatedIndex);
1654                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1655                         revert TransferToNonERC721ReceiverImplementer();
1656                     }
1657                 } while (updatedIndex != end);
1658                 // Reentrancy protection
1659                 if (_currentIndex != startTokenId) revert();
1660             } else {
1661                 do {
1662                     emit Transfer(address(0), to, updatedIndex++);
1663                 } while (updatedIndex != end);
1664             }
1665             _currentIndex = updatedIndex;
1666         }
1667         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1668     }
1669 
1670     /**
1671      * @dev Transfers `tokenId` from `from` to `to`.
1672      *
1673      * Requirements:
1674      *
1675      * - `to` cannot be the zero address.
1676      * - `tokenId` token must be owned by `from`.
1677      *
1678      * Emits a {Transfer} event.
1679      */
1680     function _transfer(
1681         address from,
1682         address to,
1683         uint256 tokenId
1684     ) private {
1685         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1686 
1687         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1688 
1689         bool isApprovedOrOwner = (_msgSender() == from ||
1690             isApprovedForAll(from, _msgSender()) ||
1691             getApproved(tokenId) == _msgSender());
1692 
1693         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1694         if (to == address(0)) revert TransferToZeroAddress();
1695 
1696         _beforeTokenTransfers(from, to, tokenId, 1);
1697 
1698         // Clear approvals from the previous owner
1699         _approve(address(0), tokenId, from);
1700 
1701         // Underflow of the sender's balance is impossible because we check for
1702         // ownership above and the recipient's balance can't realistically overflow.
1703         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1704         unchecked {
1705             _addressData[from].balance -= 1;
1706             _addressData[to].balance += 1;
1707 
1708             TokenOwnership storage currSlot = _ownerships[tokenId];
1709             currSlot.addr = to;
1710             currSlot.startTimestamp = uint64(block.timestamp);
1711 
1712             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1713             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1714             uint256 nextTokenId = tokenId + 1;
1715             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1716             if (nextSlot.addr == address(0)) {
1717                 // This will suffice for checking _exists(nextTokenId),
1718                 // as a burned slot cannot contain the zero address.
1719                 if (nextTokenId != _currentIndex) {
1720                     nextSlot.addr = from;
1721                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1722                 }
1723             }
1724         }
1725 
1726         emit Transfer(from, to, tokenId);
1727         _afterTokenTransfers(from, to, tokenId, 1);
1728     }
1729 
1730     /**
1731      * @dev This is equivalent to _burn(tokenId, false)
1732      */
1733     function _burn(uint256 tokenId) internal virtual {
1734         _burn(tokenId, false);
1735     }
1736 
1737     /**
1738      * @dev Destroys `tokenId`.
1739      * The approval is cleared when the token is burned.
1740      *
1741      * Requirements:
1742      *
1743      * - `tokenId` must exist.
1744      *
1745      * Emits a {Transfer} event.
1746      */
1747     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1748         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1749 
1750         address from = prevOwnership.addr;
1751 
1752         if (approvalCheck) {
1753             bool isApprovedOrOwner = (_msgSender() == from ||
1754                 isApprovedForAll(from, _msgSender()) ||
1755                 getApproved(tokenId) == _msgSender());
1756 
1757             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1758         }
1759 
1760         _beforeTokenTransfers(from, address(0), tokenId, 1);
1761 
1762         // Clear approvals from the previous owner
1763         _approve(address(0), tokenId, from);
1764 
1765         // Underflow of the sender's balance is impossible because we check for
1766         // ownership above and the recipient's balance can't realistically overflow.
1767         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1768         unchecked {
1769             AddressData storage addressData = _addressData[from];
1770             addressData.balance -= 1;
1771             addressData.numberBurned += 1;
1772 
1773             // Keep track of who burned the token, and the timestamp of burning.
1774             TokenOwnership storage currSlot = _ownerships[tokenId];
1775             currSlot.addr = from;
1776             currSlot.startTimestamp = uint64(block.timestamp);
1777             currSlot.burned = true;
1778 
1779             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1780             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1781             uint256 nextTokenId = tokenId + 1;
1782             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1783             if (nextSlot.addr == address(0)) {
1784                 // This will suffice for checking _exists(nextTokenId),
1785                 // as a burned slot cannot contain the zero address.
1786                 if (nextTokenId != _currentIndex) {
1787                     nextSlot.addr = from;
1788                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1789                 }
1790             }
1791         }
1792 
1793         emit Transfer(from, address(0), tokenId);
1794         _afterTokenTransfers(from, address(0), tokenId, 1);
1795 
1796         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1797         unchecked {
1798             _burnCounter++;
1799         }
1800     }
1801 
1802     /**
1803      * @dev Approve `to` to operate on `tokenId`
1804      *
1805      * Emits a {Approval} event.
1806      */
1807     function _approve(
1808         address to,
1809         uint256 tokenId,
1810         address owner
1811     ) private {
1812         _tokenApprovals[tokenId] = to;
1813         emit Approval(owner, to, tokenId);
1814     }
1815 
1816     /**
1817      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1818      *
1819      * @param from address representing the previous owner of the given token ID
1820      * @param to target address that will receive the tokens
1821      * @param tokenId uint256 ID of the token to be transferred
1822      * @param _data bytes optional data to send along with the call
1823      * @return bool whether the call correctly returned the expected magic value
1824      */
1825     function _checkContractOnERC721Received(
1826         address from,
1827         address to,
1828         uint256 tokenId,
1829         bytes memory _data
1830     ) private returns (bool) {
1831         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1832             return retval == IERC721Receiver(to).onERC721Received.selector;
1833         } catch (bytes memory reason) {
1834             if (reason.length == 0) {
1835                 revert TransferToNonERC721ReceiverImplementer();
1836             } else {
1837                 assembly {
1838                     revert(add(32, reason), mload(reason))
1839                 }
1840             }
1841         }
1842     }
1843 
1844     /**
1845      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1846      * And also called before burning one token.
1847      *
1848      * startTokenId - the first token id to be transferred
1849      * quantity - the amount to be transferred
1850      *
1851      * Calling conditions:
1852      *
1853      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1854      * transferred to `to`.
1855      * - When `from` is zero, `tokenId` will be minted for `to`.
1856      * - When `to` is zero, `tokenId` will be burned by `from`.
1857      * - `from` and `to` are never both zero.
1858      */
1859     function _beforeTokenTransfers(
1860         address from,
1861         address to,
1862         uint256 startTokenId,
1863         uint256 quantity
1864     ) internal virtual {}
1865 
1866     /**
1867      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1868      * minting.
1869      * And also called after one token has been burned.
1870      *
1871      * startTokenId - the first token id to be transferred
1872      * quantity - the amount to be transferred
1873      *
1874      * Calling conditions:
1875      *
1876      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1877      * transferred to `to`.
1878      * - When `from` is zero, `tokenId` has been minted for `to`.
1879      * - When `to` is zero, `tokenId` has been burned by `from`.
1880      * - `from` and `to` are never both zero.
1881      */
1882     function _afterTokenTransfers(
1883         address from,
1884         address to,
1885         uint256 startTokenId,
1886         uint256 quantity
1887     ) internal virtual {}
1888 }
1889 
1890 // File: contracts/TutorialErc721A.sol
1891 
1892 
1893 
1894 
1895 
1896 pragma solidity >=0.8.9 <0.9.0;
1897 
1898 
1899 
1900 
1901 
1902 
1903 
1904 contract AnotherFailedProject is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1905 
1906 
1907 
1908   using Strings for uint256;
1909 
1910 
1911 
1912   bytes32 public merkleRoot;
1913 
1914 //   mapping(address => bool) public whitelistClaimed;
1915   mapping(address => uint256) public whitelistClaimed;
1916 
1917 
1918 
1919   string public uriPrefix = '';
1920 
1921   string public uriSuffix = '.json';
1922 
1923   string public HiddenMetadataUri;
1924 
1925   
1926 
1927   uint256 public Cost;
1928 
1929   uint256 public MaxSupply;
1930 
1931   uint256 public MaxMintAmountPerTx;
1932 
1933   uint256 public MaxPerWallet;
1934 
1935 
1936 
1937   bool public paused = true;
1938 
1939   bool public whitelistMintEnabled = false;
1940 
1941   bool public revealed = false;
1942 
1943 
1944 
1945   constructor(
1946 
1947     string memory _tokenName,
1948 
1949     string memory _tokenSymbol,
1950 
1951     uint256 _Cost,
1952 
1953     uint256 _MaxSupply,
1954 
1955     uint256 _MaxMintAmountPerTx,
1956 
1957     uint256 _MaxPerWallet,
1958 
1959     string memory _HiddenMetadataUri
1960 
1961   ) ERC721A(_tokenName, _tokenSymbol) {
1962 
1963     setCost(_Cost);
1964 
1965     setMaxSupply(_MaxSupply);
1966 
1967     setMaxMintAmountPerTx(_MaxMintAmountPerTx);
1968 
1969     setMaxPerWallet(_MaxPerWallet);
1970 
1971     setHiddenMetadataUri(_HiddenMetadataUri);
1972 
1973   }
1974 
1975 
1976 
1977   modifier mintCompliance(uint256 _mintAmount) {
1978 
1979     require(_mintAmount > 0 && _mintAmount <= MaxMintAmountPerTx, 'Invalid mint amount!');
1980 
1981     require(totalSupply() + _mintAmount <= MaxSupply, 'Max supply exceeded!');
1982 
1983     require(balanceOf(msg.sender) + _mintAmount <= MaxPerWallet, 'Per Wallet Limit Reached');
1984 
1985     _;
1986 
1987   }
1988 
1989 
1990 
1991   modifier mintPriceCompliance(uint256 _mintAmount) {
1992 
1993     require(msg.value >= Cost * _mintAmount, 'Insufficient funds!');
1994 
1995     _;
1996 
1997   }
1998 
1999 
2000 
2001   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2002 
2003     // Verify whitelist requirements
2004 
2005     uint256 WLClaimed = whitelistClaimed[_msgSender()];
2006 
2007     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2008 
2009     require(WLClaimed + _mintAmount <= MaxMintAmountPerTx, 'Address already claimed!');
2010 
2011     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2012 
2013     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2014 
2015     require(msg.value >= Cost * _mintAmount, 'Insufficient funds!');
2016 
2017 
2018 
2019     whitelistClaimed[_msgSender()] += _mintAmount;
2020 
2021     _safeMint(_msgSender(), _mintAmount);
2022 
2023   }
2024 
2025 
2026 
2027   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2028 
2029     require(!paused, 'The contract is paused!');
2030 
2031 
2032 
2033     _safeMint(_msgSender(), _mintAmount);
2034 
2035   }
2036 
2037   
2038 
2039   function ownerMint(uint256 _mintAmount, address _receiver) public onlyOwner {
2040 
2041     _safeMint(_receiver, _mintAmount);
2042 
2043   }
2044 
2045 
2046 
2047   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
2048 
2049     uint256 ownerTokenCount = balanceOf(_owner);
2050 
2051     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2052 
2053     uint256 currentTokenId = _startTokenId();
2054 
2055     uint256 ownedTokenIndex = 0;
2056 
2057     address latestOwnerAddress;
2058 
2059 
2060 
2061     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
2062 
2063       TokenOwnership memory ownership = _ownerships[currentTokenId];
2064 
2065 
2066 
2067       if (!ownership.burned) {
2068 
2069         if (ownership.addr != address(0)) {
2070 
2071           latestOwnerAddress = ownership.addr;
2072 
2073         }
2074 
2075 
2076 
2077         if (latestOwnerAddress == _owner) {
2078 
2079           ownedTokenIds[ownedTokenIndex] = currentTokenId;
2080 
2081 
2082 
2083           ownedTokenIndex++;
2084 
2085         }
2086 
2087       }
2088 
2089 
2090 
2091       currentTokenId++;
2092 
2093     }
2094 
2095 
2096 
2097     return ownedTokenIds;
2098 
2099   }
2100 
2101 
2102 
2103   function _startTokenId() internal view virtual override returns (uint256) {
2104 
2105     return 1;
2106 
2107   }
2108 
2109 
2110 
2111   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2112 
2113     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2114 
2115 
2116 
2117     if (revealed == false) {
2118 
2119       return HiddenMetadataUri;
2120 
2121     }
2122 
2123 
2124 
2125     string memory currentBaseURI = _baseURI();
2126 
2127     return bytes(currentBaseURI).length > 0
2128 
2129         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2130 
2131         : '';
2132 
2133   }
2134 
2135 
2136 
2137   function setRevealed(bool _state) public onlyOwner {
2138 
2139     revealed = _state;
2140 
2141   }
2142 
2143 
2144 
2145   function setCost(uint256 _Cost) public onlyOwner {
2146 
2147     Cost = _Cost;
2148 
2149   }
2150 
2151 
2152 
2153   function setMaxSupply(uint256 _MaxSupply) public onlyOwner {
2154 
2155       MaxSupply = _MaxSupply;
2156   
2157   }
2158 
2159 
2160 
2161   function setMaxMintAmountPerTx(uint256 _MaxMintAmountPerTx) public onlyOwner {
2162 
2163     MaxMintAmountPerTx = _MaxMintAmountPerTx;
2164 
2165   }
2166 
2167 
2168 
2169   function setMaxPerWallet(uint256 _MaxPerWallet) public onlyOwner {       
2170 
2171         MaxPerWallet = _MaxPerWallet;
2172 
2173   }
2174 
2175 
2176 
2177   function setHiddenMetadataUri(string memory _HiddenMetadataUri) public onlyOwner {
2178 
2179     HiddenMetadataUri = _HiddenMetadataUri;
2180 
2181   }
2182 
2183 
2184 
2185   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2186 
2187     uriPrefix = _uriPrefix;
2188 
2189   }
2190 
2191 
2192 
2193   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2194 
2195     uriSuffix = _uriSuffix;
2196 
2197   }
2198 
2199 
2200 
2201   function setPaused(bool _state) public onlyOwner {
2202 
2203     paused = _state;
2204 
2205   }
2206 
2207 
2208 
2209   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2210 
2211     merkleRoot = _merkleRoot;
2212 
2213   }
2214 
2215 
2216 
2217   function setWhitelistMintEnabled(bool _state) public onlyOwner {
2218 
2219     whitelistMintEnabled = _state;
2220 
2221   }
2222 
2223 
2224 
2225   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2226         super.transferFrom(from, to, tokenId);
2227  
2228   }
2229 
2230  
2231  
2232   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2233         super.safeTransferFrom(from, to, tokenId);
2234         
2235   }
2236 
2237   
2238   
2239   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2240         public
2241         override
2242         onlyAllowedOperator
2243 
2244   {
2245 
2246         super.safeTransferFrom(from, to, tokenId, data);
2247 
2248   } 
2249 
2250 
2251 
2252   function withdrawAll() external payable onlyOwner nonReentrant {
2253         uint256 balance = address(this).balance;
2254         uint256 balanceOne = balance * 10 / 100;
2255         uint256 balanceTwo = balance * 20 / 100;
2256         uint256 balanceThree = balance * 15 / 100;
2257         uint256 balanceFour = balance * 5 / 100;
2258         uint256 balanceFive = balance * 10 / 100;
2259         uint256 balanceDev = balance * 1 / 100;
2260         ( bool transferOne, ) = payable(0x913f6294c35150B5067559b76C1e53380636BA0B).call{value: balanceOne}("");
2261         ( bool transferTwo, ) = payable(0xC11778679A4B7be52f63be6b152643549db2C246).call{value: balanceTwo}("");
2262         ( bool transferThree, ) = payable(0xBDd95CAd313eB8eD0784bcB07aEA41292ecCf3bc).call{value: balanceThree}("");
2263         ( bool transferFour, ) = payable(0x67fa73E8cc5F67AB017f68DCF213BB74dCbf9E6e).call{value: balanceFour}("");
2264         ( bool transferFive, ) = payable(0x7455D8672c75B50eC35bc62C1c9e231101704EBe).call{value: balanceFive}("");
2265         ( bool transferDev, ) = payable(0x913f6294c35150B5067559b76C1e53380636BA0B).call{value: balanceDev}(""); // Dev Donation - The Bee Collab
2266         (bool remaining, ) = payable(owner()).call{value: address(this).balance}('');
2267         require(transferOne && transferTwo && transferThree && transferFour && transferFive && transferDev && remaining, "Transfer failed.");
2268 
2269     }
2270 
2271 
2272 
2273   function _baseURI() internal view virtual override returns (string memory) {
2274 
2275     return uriPrefix;
2276 
2277   }
2278 
2279 }