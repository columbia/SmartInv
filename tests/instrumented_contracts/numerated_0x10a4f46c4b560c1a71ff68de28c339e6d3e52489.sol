1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * _Available since v4.7._
85      */
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     /**
96      * @dev Calldata version of {multiProofVerify}
97      *
98      * _Available since v4.7._
99      */
100     function multiProofVerifyCalldata(
101         bytes32[] calldata proof,
102         bool[] calldata proofFlags,
103         bytes32 root,
104         bytes32[] memory leaves
105     ) internal pure returns (bool) {
106         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
107     }
108 
109     /**
110      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
111      * consuming from one or the other at each step according to the instructions given by
112      * `proofFlags`.
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 totalHashes = proofFlags.length;
127 
128         // Check proof validity.
129         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
130 
131         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
132         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
133         bytes32[] memory hashes = new bytes32[](totalHashes);
134         uint256 leafPos = 0;
135         uint256 hashPos = 0;
136         uint256 proofPos = 0;
137         // At each step, we compute the next hash using two values:
138         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
139         //   get the next hash.
140         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             return hashes[totalHashes - 1];
150         } else if (leavesLen > 0) {
151             return leaves[0];
152         } else {
153             return proof[0];
154         }
155     }
156 
157     /**
158      * @dev Calldata version of {processMultiProof}
159      *
160      * _Available since v4.7._
161      */
162     function processMultiProofCalldata(
163         bytes32[] calldata proof,
164         bool[] calldata proofFlags,
165         bytes32[] memory leaves
166     ) internal pure returns (bytes32 merkleRoot) {
167         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
168         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
169         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
170         // the merkle tree.
171         uint256 leavesLen = leaves.length;
172         uint256 totalHashes = proofFlags.length;
173 
174         // Check proof validity.
175         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
176 
177         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
178         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
179         bytes32[] memory hashes = new bytes32[](totalHashes);
180         uint256 leafPos = 0;
181         uint256 hashPos = 0;
182         uint256 proofPos = 0;
183         // At each step, we compute the next hash using two values:
184         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
185         //   get the next hash.
186         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
187         //   `proof` array.
188         for (uint256 i = 0; i < totalHashes; i++) {
189             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
190             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
191             hashes[i] = _hashPair(a, b);
192         }
193 
194         if (totalHashes > 0) {
195             return hashes[totalHashes - 1];
196         } else if (leavesLen > 0) {
197             return leaves[0];
198         } else {
199             return proof[0];
200         }
201     }
202 
203     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
204         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         /// @solidity memory-safe-assembly
209         assembly {
210             mstore(0x00, a)
211             mstore(0x20, b)
212             value := keccak256(0x00, 0x40)
213         }
214     }
215 }
216 
217 // File: @openzeppelin/contracts/utils/Counters.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @title Counters
226  * @author Matt Condon (@shrugs)
227  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
228  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
229  *
230  * Include with `using Counters for Counters.Counter;`
231  */
232 library Counters {
233     struct Counter {
234         // This variable should never be directly accessed by users of the library: interactions must be restricted to
235         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
236         // this feature: see https://github.com/ethereum/solidity/issues/4637
237         uint256 _value; // default: 0
238     }
239 
240     function current(Counter storage counter) internal view returns (uint256) {
241         return counter._value;
242     }
243 
244     function increment(Counter storage counter) internal {
245         unchecked {
246             counter._value += 1;
247         }
248     }
249 
250     function decrement(Counter storage counter) internal {
251         uint256 value = counter._value;
252         require(value > 0, "Counter: decrement overflow");
253         unchecked {
254             counter._value = value - 1;
255         }
256     }
257 
258     function reset(Counter storage counter) internal {
259         counter._value = 0;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
264 
265 
266 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev Library for managing
272  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
273  * types.
274  *
275  * Sets have the following properties:
276  *
277  * - Elements are added, removed, and checked for existence in constant time
278  * (O(1)).
279  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
280  *
281  * ```
282  * contract Example {
283  *     // Add the library methods
284  *     using EnumerableSet for EnumerableSet.AddressSet;
285  *
286  *     // Declare a set state variable
287  *     EnumerableSet.AddressSet private mySet;
288  * }
289  * ```
290  *
291  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
292  * and `uint256` (`UintSet`) are supported.
293  *
294  * [WARNING]
295  * ====
296  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
297  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
298  *
299  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
300  * ====
301  */
302 library EnumerableSet {
303     // To implement this library for multiple types with as little code
304     // repetition as possible, we write it in terms of a generic Set type with
305     // bytes32 values.
306     // The Set implementation uses private functions, and user-facing
307     // implementations (such as AddressSet) are just wrappers around the
308     // underlying Set.
309     // This means that we can only create new EnumerableSets for types that fit
310     // in bytes32.
311 
312     struct Set {
313         // Storage of set values
314         bytes32[] _values;
315         // Position of the value in the `values` array, plus 1 because index 0
316         // means a value is not in the set.
317         mapping(bytes32 => uint256) _indexes;
318     }
319 
320     /**
321      * @dev Add a value to a set. O(1).
322      *
323      * Returns true if the value was added to the set, that is if it was not
324      * already present.
325      */
326     function _add(Set storage set, bytes32 value) private returns (bool) {
327         if (!_contains(set, value)) {
328             set._values.push(value);
329             // The value is stored at length-1, but we add 1 to all indexes
330             // and use 0 as a sentinel value
331             set._indexes[value] = set._values.length;
332             return true;
333         } else {
334             return false;
335         }
336     }
337 
338     /**
339      * @dev Removes a value from a set. O(1).
340      *
341      * Returns true if the value was removed from the set, that is if it was
342      * present.
343      */
344     function _remove(Set storage set, bytes32 value) private returns (bool) {
345         // We read and store the value's index to prevent multiple reads from the same storage slot
346         uint256 valueIndex = set._indexes[value];
347 
348         if (valueIndex != 0) {
349             // Equivalent to contains(set, value)
350             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
351             // the array, and then remove the last element (sometimes called as 'swap and pop').
352             // This modifies the order of the array, as noted in {at}.
353 
354             uint256 toDeleteIndex = valueIndex - 1;
355             uint256 lastIndex = set._values.length - 1;
356 
357             if (lastIndex != toDeleteIndex) {
358                 bytes32 lastValue = set._values[lastIndex];
359 
360                 // Move the last value to the index where the value to delete is
361                 set._values[toDeleteIndex] = lastValue;
362                 // Update the index for the moved value
363                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
364             }
365 
366             // Delete the slot where the moved value was stored
367             set._values.pop();
368 
369             // Delete the index for the deleted slot
370             delete set._indexes[value];
371 
372             return true;
373         } else {
374             return false;
375         }
376     }
377 
378     /**
379      * @dev Returns true if the value is in the set. O(1).
380      */
381     function _contains(Set storage set, bytes32 value) private view returns (bool) {
382         return set._indexes[value] != 0;
383     }
384 
385     /**
386      * @dev Returns the number of values on the set. O(1).
387      */
388     function _length(Set storage set) private view returns (uint256) {
389         return set._values.length;
390     }
391 
392     /**
393      * @dev Returns the value stored at position `index` in the set. O(1).
394      *
395      * Note that there are no guarantees on the ordering of values inside the
396      * array, and it may change when more values are added or removed.
397      *
398      * Requirements:
399      *
400      * - `index` must be strictly less than {length}.
401      */
402     function _at(Set storage set, uint256 index) private view returns (bytes32) {
403         return set._values[index];
404     }
405 
406     /**
407      * @dev Return the entire set in an array
408      *
409      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
410      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
411      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
412      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
413      */
414     function _values(Set storage set) private view returns (bytes32[] memory) {
415         return set._values;
416     }
417 
418     // Bytes32Set
419 
420     struct Bytes32Set {
421         Set _inner;
422     }
423 
424     /**
425      * @dev Add a value to a set. O(1).
426      *
427      * Returns true if the value was added to the set, that is if it was not
428      * already present.
429      */
430     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
431         return _add(set._inner, value);
432     }
433 
434     /**
435      * @dev Removes a value from a set. O(1).
436      *
437      * Returns true if the value was removed from the set, that is if it was
438      * present.
439      */
440     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
441         return _remove(set._inner, value);
442     }
443 
444     /**
445      * @dev Returns true if the value is in the set. O(1).
446      */
447     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
448         return _contains(set._inner, value);
449     }
450 
451     /**
452      * @dev Returns the number of values in the set. O(1).
453      */
454     function length(Bytes32Set storage set) internal view returns (uint256) {
455         return _length(set._inner);
456     }
457 
458     /**
459      * @dev Returns the value stored at position `index` in the set. O(1).
460      *
461      * Note that there are no guarantees on the ordering of values inside the
462      * array, and it may change when more values are added or removed.
463      *
464      * Requirements:
465      *
466      * - `index` must be strictly less than {length}.
467      */
468     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
469         return _at(set._inner, index);
470     }
471 
472     /**
473      * @dev Return the entire set in an array
474      *
475      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
476      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
477      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
478      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
479      */
480     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
481         return _values(set._inner);
482     }
483 
484     // AddressSet
485 
486     struct AddressSet {
487         Set _inner;
488     }
489 
490     /**
491      * @dev Add a value to a set. O(1).
492      *
493      * Returns true if the value was added to the set, that is if it was not
494      * already present.
495      */
496     function add(AddressSet storage set, address value) internal returns (bool) {
497         return _add(set._inner, bytes32(uint256(uint160(value))));
498     }
499 
500     /**
501      * @dev Removes a value from a set. O(1).
502      *
503      * Returns true if the value was removed from the set, that is if it was
504      * present.
505      */
506     function remove(AddressSet storage set, address value) internal returns (bool) {
507         return _remove(set._inner, bytes32(uint256(uint160(value))));
508     }
509 
510     /**
511      * @dev Returns true if the value is in the set. O(1).
512      */
513     function contains(AddressSet storage set, address value) internal view returns (bool) {
514         return _contains(set._inner, bytes32(uint256(uint160(value))));
515     }
516 
517     /**
518      * @dev Returns the number of values in the set. O(1).
519      */
520     function length(AddressSet storage set) internal view returns (uint256) {
521         return _length(set._inner);
522     }
523 
524     /**
525      * @dev Returns the value stored at position `index` in the set. O(1).
526      *
527      * Note that there are no guarantees on the ordering of values inside the
528      * array, and it may change when more values are added or removed.
529      *
530      * Requirements:
531      *
532      * - `index` must be strictly less than {length}.
533      */
534     function at(AddressSet storage set, uint256 index) internal view returns (address) {
535         return address(uint160(uint256(_at(set._inner, index))));
536     }
537 
538     /**
539      * @dev Return the entire set in an array
540      *
541      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
542      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
543      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
544      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
545      */
546     function values(AddressSet storage set) internal view returns (address[] memory) {
547         bytes32[] memory store = _values(set._inner);
548         address[] memory result;
549 
550         /// @solidity memory-safe-assembly
551         assembly {
552             result := store
553         }
554 
555         return result;
556     }
557 
558     // UintSet
559 
560     struct UintSet {
561         Set _inner;
562     }
563 
564     /**
565      * @dev Add a value to a set. O(1).
566      *
567      * Returns true if the value was added to the set, that is if it was not
568      * already present.
569      */
570     function add(UintSet storage set, uint256 value) internal returns (bool) {
571         return _add(set._inner, bytes32(value));
572     }
573 
574     /**
575      * @dev Removes a value from a set. O(1).
576      *
577      * Returns true if the value was removed from the set, that is if it was
578      * present.
579      */
580     function remove(UintSet storage set, uint256 value) internal returns (bool) {
581         return _remove(set._inner, bytes32(value));
582     }
583 
584     /**
585      * @dev Returns true if the value is in the set. O(1).
586      */
587     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
588         return _contains(set._inner, bytes32(value));
589     }
590 
591     /**
592      * @dev Returns the number of values on the set. O(1).
593      */
594     function length(UintSet storage set) internal view returns (uint256) {
595         return _length(set._inner);
596     }
597 
598     /**
599      * @dev Returns the value stored at position `index` in the set. O(1).
600      *
601      * Note that there are no guarantees on the ordering of values inside the
602      * array, and it may change when more values are added or removed.
603      *
604      * Requirements:
605      *
606      * - `index` must be strictly less than {length}.
607      */
608     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
609         return uint256(_at(set._inner, index));
610     }
611 
612     /**
613      * @dev Return the entire set in an array
614      *
615      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
616      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
617      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
618      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
619      */
620     function values(UintSet storage set) internal view returns (uint256[] memory) {
621         bytes32[] memory store = _values(set._inner);
622         uint256[] memory result;
623 
624         /// @solidity memory-safe-assembly
625         assembly {
626             result := store
627         }
628 
629         return result;
630     }
631 }
632 
633 // File: @openzeppelin/contracts/access/IAccessControl.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev External interface of AccessControl declared to support ERC165 detection.
642  */
643 interface IAccessControl {
644     /**
645      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
646      *
647      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
648      * {RoleAdminChanged} not being emitted signaling this.
649      *
650      * _Available since v3.1._
651      */
652     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
653 
654     /**
655      * @dev Emitted when `account` is granted `role`.
656      *
657      * `sender` is the account that originated the contract call, an admin role
658      * bearer except when using {AccessControl-_setupRole}.
659      */
660     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
661 
662     /**
663      * @dev Emitted when `account` is revoked `role`.
664      *
665      * `sender` is the account that originated the contract call:
666      *   - if using `revokeRole`, it is the admin role bearer
667      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
668      */
669     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
670 
671     /**
672      * @dev Returns `true` if `account` has been granted `role`.
673      */
674     function hasRole(bytes32 role, address account) external view returns (bool);
675 
676     /**
677      * @dev Returns the admin role that controls `role`. See {grantRole} and
678      * {revokeRole}.
679      *
680      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
681      */
682     function getRoleAdmin(bytes32 role) external view returns (bytes32);
683 
684     /**
685      * @dev Grants `role` to `account`.
686      *
687      * If `account` had not been already granted `role`, emits a {RoleGranted}
688      * event.
689      *
690      * Requirements:
691      *
692      * - the caller must have ``role``'s admin role.
693      */
694     function grantRole(bytes32 role, address account) external;
695 
696     /**
697      * @dev Revokes `role` from `account`.
698      *
699      * If `account` had been granted `role`, emits a {RoleRevoked} event.
700      *
701      * Requirements:
702      *
703      * - the caller must have ``role``'s admin role.
704      */
705     function revokeRole(bytes32 role, address account) external;
706 
707     /**
708      * @dev Revokes `role` from the calling account.
709      *
710      * Roles are often managed via {grantRole} and {revokeRole}: this function's
711      * purpose is to provide a mechanism for accounts to lose their privileges
712      * if they are compromised (such as when a trusted device is misplaced).
713      *
714      * If the calling account had been granted `role`, emits a {RoleRevoked}
715      * event.
716      *
717      * Requirements:
718      *
719      * - the caller must be `account`.
720      */
721     function renounceRole(bytes32 role, address account) external;
722 }
723 
724 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
734  */
735 interface IAccessControlEnumerable is IAccessControl {
736     /**
737      * @dev Returns one of the accounts that have `role`. `index` must be a
738      * value between 0 and {getRoleMemberCount}, non-inclusive.
739      *
740      * Role bearers are not sorted in any particular way, and their ordering may
741      * change at any point.
742      *
743      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
744      * you perform all queries on the same block. See the following
745      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
746      * for more information.
747      */
748     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
749 
750     /**
751      * @dev Returns the number of accounts that have `role`. Can be used
752      * together with {getRoleMember} to enumerate all bearers of a role.
753      */
754     function getRoleMemberCount(bytes32 role) external view returns (uint256);
755 }
756 
757 // File: @openzeppelin/contracts/utils/Strings.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 /**
765  * @dev String operations.
766  */
767 library Strings {
768     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
769     uint8 private constant _ADDRESS_LENGTH = 20;
770 
771     /**
772      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
773      */
774     function toString(uint256 value) internal pure returns (string memory) {
775         // Inspired by OraclizeAPI's implementation - MIT licence
776         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
777 
778         if (value == 0) {
779             return "0";
780         }
781         uint256 temp = value;
782         uint256 digits;
783         while (temp != 0) {
784             digits++;
785             temp /= 10;
786         }
787         bytes memory buffer = new bytes(digits);
788         while (value != 0) {
789             digits -= 1;
790             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
791             value /= 10;
792         }
793         return string(buffer);
794     }
795 
796     /**
797      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
798      */
799     function toHexString(uint256 value) internal pure returns (string memory) {
800         if (value == 0) {
801             return "0x00";
802         }
803         uint256 temp = value;
804         uint256 length = 0;
805         while (temp != 0) {
806             length++;
807             temp >>= 8;
808         }
809         return toHexString(value, length);
810     }
811 
812     /**
813      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
814      */
815     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
816         bytes memory buffer = new bytes(2 * length + 2);
817         buffer[0] = "0";
818         buffer[1] = "x";
819         for (uint256 i = 2 * length + 1; i > 1; --i) {
820             buffer[i] = _HEX_SYMBOLS[value & 0xf];
821             value >>= 4;
822         }
823         require(value == 0, "Strings: hex length insufficient");
824         return string(buffer);
825     }
826 
827     /**
828      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
829      */
830     function toHexString(address addr) internal pure returns (string memory) {
831         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
832     }
833 }
834 
835 // File: @openzeppelin/contracts/utils/Context.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @dev Provides information about the current execution context, including the
844  * sender of the transaction and its data. While these are generally available
845  * via msg.sender and msg.data, they should not be accessed in such a direct
846  * manner, since when dealing with meta-transactions the account sending and
847  * paying for execution may not be the actual sender (as far as an application
848  * is concerned).
849  *
850  * This contract is only required for intermediate, library-like contracts.
851  */
852 abstract contract Context {
853     function _msgSender() internal view virtual returns (address) {
854         return msg.sender;
855     }
856 
857     function _msgData() internal view virtual returns (bytes calldata) {
858         return msg.data;
859     }
860 }
861 
862 // File: @openzeppelin/contracts/access/Ownable.sol
863 
864 
865 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @dev Contract module which provides a basic access control mechanism, where
872  * there is an account (an owner) that can be granted exclusive access to
873  * specific functions.
874  *
875  * By default, the owner account will be the one that deploys the contract. This
876  * can later be changed with {transferOwnership}.
877  *
878  * This module is used through inheritance. It will make available the modifier
879  * `onlyOwner`, which can be applied to your functions to restrict their use to
880  * the owner.
881  */
882 abstract contract Ownable is Context {
883     address private _owner;
884 
885     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
886 
887     /**
888      * @dev Initializes the contract setting the deployer as the initial owner.
889      */
890     constructor() {
891         _transferOwnership(_msgSender());
892     }
893 
894     /**
895      * @dev Throws if called by any account other than the owner.
896      */
897     modifier onlyOwner() {
898         _checkOwner();
899         _;
900     }
901 
902     /**
903      * @dev Returns the address of the current owner.
904      */
905     function owner() public view virtual returns (address) {
906         return _owner;
907     }
908 
909     /**
910      * @dev Throws if the sender is not the owner.
911      */
912     function _checkOwner() internal view virtual {
913         require(owner() == _msgSender(), "Ownable: caller is not the owner");
914     }
915 
916     /**
917      * @dev Leaves the contract without owner. It will not be possible to call
918      * `onlyOwner` functions anymore. Can only be called by the current owner.
919      *
920      * NOTE: Renouncing ownership will leave the contract without an owner,
921      * thereby removing any functionality that is only available to the owner.
922      */
923     function renounceOwnership() public virtual onlyOwner {
924         _transferOwnership(address(0));
925     }
926 
927     /**
928      * @dev Transfers ownership of the contract to a new account (`newOwner`).
929      * Can only be called by the current owner.
930      */
931     function transferOwnership(address newOwner) public virtual onlyOwner {
932         require(newOwner != address(0), "Ownable: new owner is the zero address");
933         _transferOwnership(newOwner);
934     }
935 
936     /**
937      * @dev Transfers ownership of the contract to a new account (`newOwner`).
938      * Internal function without access restriction.
939      */
940     function _transferOwnership(address newOwner) internal virtual {
941         address oldOwner = _owner;
942         _owner = newOwner;
943         emit OwnershipTransferred(oldOwner, newOwner);
944     }
945 }
946 
947 // File: @openzeppelin/contracts/utils/Address.sol
948 
949 
950 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
951 
952 pragma solidity ^0.8.1;
953 
954 /**
955  * @dev Collection of functions related to the address type
956  */
957 library Address {
958     /**
959      * @dev Returns true if `account` is a contract.
960      *
961      * [IMPORTANT]
962      * ====
963      * It is unsafe to assume that an address for which this function returns
964      * false is an externally-owned account (EOA) and not a contract.
965      *
966      * Among others, `isContract` will return false for the following
967      * types of addresses:
968      *
969      *  - an externally-owned account
970      *  - a contract in construction
971      *  - an address where a contract will be created
972      *  - an address where a contract lived, but was destroyed
973      * ====
974      *
975      * [IMPORTANT]
976      * ====
977      * You shouldn't rely on `isContract` to protect against flash loan attacks!
978      *
979      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
980      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
981      * constructor.
982      * ====
983      */
984     function isContract(address account) internal view returns (bool) {
985         // This method relies on extcodesize/address.code.length, which returns 0
986         // for contracts in construction, since the code is only stored at the end
987         // of the constructor execution.
988 
989         return account.code.length > 0;
990     }
991 
992     /**
993      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
994      * `recipient`, forwarding all available gas and reverting on errors.
995      *
996      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
997      * of certain opcodes, possibly making contracts go over the 2300 gas limit
998      * imposed by `transfer`, making them unable to receive funds via
999      * `transfer`. {sendValue} removes this limitation.
1000      *
1001      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1002      *
1003      * IMPORTANT: because control is transferred to `recipient`, care must be
1004      * taken to not create reentrancy vulnerabilities. Consider using
1005      * {ReentrancyGuard} or the
1006      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1007      */
1008     function sendValue(address payable recipient, uint256 amount) internal {
1009         require(address(this).balance >= amount, "Address: insufficient balance");
1010 
1011         (bool success, ) = recipient.call{value: amount}("");
1012         require(success, "Address: unable to send value, recipient may have reverted");
1013     }
1014 
1015     /**
1016      * @dev Performs a Solidity function call using a low level `call`. A
1017      * plain `call` is an unsafe replacement for a function call: use this
1018      * function instead.
1019      *
1020      * If `target` reverts with a revert reason, it is bubbled up by this
1021      * function (like regular Solidity function calls).
1022      *
1023      * Returns the raw returned data. To convert to the expected return value,
1024      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1025      *
1026      * Requirements:
1027      *
1028      * - `target` must be a contract.
1029      * - calling `target` with `data` must not revert.
1030      *
1031      * _Available since v3.1._
1032      */
1033     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1034         return functionCall(target, data, "Address: low-level call failed");
1035     }
1036 
1037     /**
1038      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1039      * `errorMessage` as a fallback revert reason when `target` reverts.
1040      *
1041      * _Available since v3.1._
1042      */
1043     function functionCall(
1044         address target,
1045         bytes memory data,
1046         string memory errorMessage
1047     ) internal returns (bytes memory) {
1048         return functionCallWithValue(target, data, 0, errorMessage);
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1053      * but also transferring `value` wei to `target`.
1054      *
1055      * Requirements:
1056      *
1057      * - the calling contract must have an ETH balance of at least `value`.
1058      * - the called Solidity function must be `payable`.
1059      *
1060      * _Available since v3.1._
1061      */
1062     function functionCallWithValue(
1063         address target,
1064         bytes memory data,
1065         uint256 value
1066     ) internal returns (bytes memory) {
1067         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1068     }
1069 
1070     /**
1071      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1072      * with `errorMessage` as a fallback revert reason when `target` reverts.
1073      *
1074      * _Available since v3.1._
1075      */
1076     function functionCallWithValue(
1077         address target,
1078         bytes memory data,
1079         uint256 value,
1080         string memory errorMessage
1081     ) internal returns (bytes memory) {
1082         require(address(this).balance >= value, "Address: insufficient balance for call");
1083         require(isContract(target), "Address: call to non-contract");
1084 
1085         (bool success, bytes memory returndata) = target.call{value: value}(data);
1086         return verifyCallResult(success, returndata, errorMessage);
1087     }
1088 
1089     /**
1090      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1091      * but performing a static call.
1092      *
1093      * _Available since v3.3._
1094      */
1095     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1096         return functionStaticCall(target, data, "Address: low-level static call failed");
1097     }
1098 
1099     /**
1100      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1101      * but performing a static call.
1102      *
1103      * _Available since v3.3._
1104      */
1105     function functionStaticCall(
1106         address target,
1107         bytes memory data,
1108         string memory errorMessage
1109     ) internal view returns (bytes memory) {
1110         require(isContract(target), "Address: static call to non-contract");
1111 
1112         (bool success, bytes memory returndata) = target.staticcall(data);
1113         return verifyCallResult(success, returndata, errorMessage);
1114     }
1115 
1116     /**
1117      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1118      * but performing a delegate call.
1119      *
1120      * _Available since v3.4._
1121      */
1122     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1123         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1124     }
1125 
1126     /**
1127      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1128      * but performing a delegate call.
1129      *
1130      * _Available since v3.4._
1131      */
1132     function functionDelegateCall(
1133         address target,
1134         bytes memory data,
1135         string memory errorMessage
1136     ) internal returns (bytes memory) {
1137         require(isContract(target), "Address: delegate call to non-contract");
1138 
1139         (bool success, bytes memory returndata) = target.delegatecall(data);
1140         return verifyCallResult(success, returndata, errorMessage);
1141     }
1142 
1143     /**
1144      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1145      * revert reason using the provided one.
1146      *
1147      * _Available since v4.3._
1148      */
1149     function verifyCallResult(
1150         bool success,
1151         bytes memory returndata,
1152         string memory errorMessage
1153     ) internal pure returns (bytes memory) {
1154         if (success) {
1155             return returndata;
1156         } else {
1157             // Look for revert reason and bubble it up if present
1158             if (returndata.length > 0) {
1159                 // The easiest way to bubble the revert reason is using memory via assembly
1160                 /// @solidity memory-safe-assembly
1161                 assembly {
1162                     let returndata_size := mload(returndata)
1163                     revert(add(32, returndata), returndata_size)
1164                 }
1165             } else {
1166                 revert(errorMessage);
1167             }
1168         }
1169     }
1170 }
1171 
1172 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1173 
1174 
1175 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /**
1180  * @title ERC721 token receiver interface
1181  * @dev Interface for any contract that wants to support safeTransfers
1182  * from ERC721 asset contracts.
1183  */
1184 interface IERC721Receiver {
1185     /**
1186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1187      * by `operator` from `from`, this function is called.
1188      *
1189      * It must return its Solidity selector to confirm the token transfer.
1190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1191      *
1192      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1193      */
1194     function onERC721Received(
1195         address operator,
1196         address from,
1197         uint256 tokenId,
1198         bytes calldata data
1199     ) external returns (bytes4);
1200 }
1201 
1202 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1203 
1204 
1205 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 /**
1210  * @dev Interface of the ERC165 standard, as defined in the
1211  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1212  *
1213  * Implementers can declare support of contract interfaces, which can then be
1214  * queried by others ({ERC165Checker}).
1215  *
1216  * For an implementation, see {ERC165}.
1217  */
1218 interface IERC165 {
1219     /**
1220      * @dev Returns true if this contract implements the interface defined by
1221      * `interfaceId`. See the corresponding
1222      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1223      * to learn more about how these ids are created.
1224      *
1225      * This function call must use less than 30 000 gas.
1226      */
1227     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1228 }
1229 
1230 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1231 
1232 
1233 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 
1238 /**
1239  * @dev Implementation of the {IERC165} interface.
1240  *
1241  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1242  * for the additional interface id that will be supported. For example:
1243  *
1244  * ```solidity
1245  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1246  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1247  * }
1248  * ```
1249  *
1250  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1251  */
1252 abstract contract ERC165 is IERC165 {
1253     /**
1254      * @dev See {IERC165-supportsInterface}.
1255      */
1256     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1257         return interfaceId == type(IERC165).interfaceId;
1258     }
1259 }
1260 
1261 // File: @openzeppelin/contracts/access/AccessControl.sol
1262 
1263 
1264 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 
1269 
1270 
1271 
1272 /**
1273  * @dev Contract module that allows children to implement role-based access
1274  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1275  * members except through off-chain means by accessing the contract event logs. Some
1276  * applications may benefit from on-chain enumerability, for those cases see
1277  * {AccessControlEnumerable}.
1278  *
1279  * Roles are referred to by their `bytes32` identifier. These should be exposed
1280  * in the external API and be unique. The best way to achieve this is by
1281  * using `public constant` hash digests:
1282  *
1283  * ```
1284  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1285  * ```
1286  *
1287  * Roles can be used to represent a set of permissions. To restrict access to a
1288  * function call, use {hasRole}:
1289  *
1290  * ```
1291  * function foo() public {
1292  *     require(hasRole(MY_ROLE, msg.sender));
1293  *     ...
1294  * }
1295  * ```
1296  *
1297  * Roles can be granted and revoked dynamically via the {grantRole} and
1298  * {revokeRole} functions. Each role has an associated admin role, and only
1299  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1300  *
1301  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1302  * that only accounts with this role will be able to grant or revoke other
1303  * roles. More complex role relationships can be created by using
1304  * {_setRoleAdmin}.
1305  *
1306  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1307  * grant and revoke this role. Extra precautions should be taken to secure
1308  * accounts that have been granted it.
1309  */
1310 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1311     struct RoleData {
1312         mapping(address => bool) members;
1313         bytes32 adminRole;
1314     }
1315 
1316     mapping(bytes32 => RoleData) private _roles;
1317 
1318     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1319 
1320     /**
1321      * @dev Modifier that checks that an account has a specific role. Reverts
1322      * with a standardized message including the required role.
1323      *
1324      * The format of the revert reason is given by the following regular expression:
1325      *
1326      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1327      *
1328      * _Available since v4.1._
1329      */
1330     modifier onlyRole(bytes32 role) {
1331         _checkRole(role);
1332         _;
1333     }
1334 
1335     /**
1336      * @dev See {IERC165-supportsInterface}.
1337      */
1338     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1339         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1340     }
1341 
1342     /**
1343      * @dev Returns `true` if `account` has been granted `role`.
1344      */
1345     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1346         return _roles[role].members[account];
1347     }
1348 
1349     /**
1350      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1351      * Overriding this function changes the behavior of the {onlyRole} modifier.
1352      *
1353      * Format of the revert message is described in {_checkRole}.
1354      *
1355      * _Available since v4.6._
1356      */
1357     function _checkRole(bytes32 role) internal view virtual {
1358         _checkRole(role, _msgSender());
1359     }
1360 
1361     /**
1362      * @dev Revert with a standard message if `account` is missing `role`.
1363      *
1364      * The format of the revert reason is given by the following regular expression:
1365      *
1366      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1367      */
1368     function _checkRole(bytes32 role, address account) internal view virtual {
1369         if (!hasRole(role, account)) {
1370             revert(
1371                 string(
1372                     abi.encodePacked(
1373                         "AccessControl: account ",
1374                         Strings.toHexString(uint160(account), 20),
1375                         " is missing role ",
1376                         Strings.toHexString(uint256(role), 32)
1377                     )
1378                 )
1379             );
1380         }
1381     }
1382 
1383     /**
1384      * @dev Returns the admin role that controls `role`. See {grantRole} and
1385      * {revokeRole}.
1386      *
1387      * To change a role's admin, use {_setRoleAdmin}.
1388      */
1389     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1390         return _roles[role].adminRole;
1391     }
1392 
1393     /**
1394      * @dev Grants `role` to `account`.
1395      *
1396      * If `account` had not been already granted `role`, emits a {RoleGranted}
1397      * event.
1398      *
1399      * Requirements:
1400      *
1401      * - the caller must have ``role``'s admin role.
1402      *
1403      * May emit a {RoleGranted} event.
1404      */
1405     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1406         _grantRole(role, account);
1407     }
1408 
1409     /**
1410      * @dev Revokes `role` from `account`.
1411      *
1412      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1413      *
1414      * Requirements:
1415      *
1416      * - the caller must have ``role``'s admin role.
1417      *
1418      * May emit a {RoleRevoked} event.
1419      */
1420     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1421         _revokeRole(role, account);
1422     }
1423 
1424     /**
1425      * @dev Revokes `role` from the calling account.
1426      *
1427      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1428      * purpose is to provide a mechanism for accounts to lose their privileges
1429      * if they are compromised (such as when a trusted device is misplaced).
1430      *
1431      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1432      * event.
1433      *
1434      * Requirements:
1435      *
1436      * - the caller must be `account`.
1437      *
1438      * May emit a {RoleRevoked} event.
1439      */
1440     function renounceRole(bytes32 role, address account) public virtual override {
1441         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1442 
1443         _revokeRole(role, account);
1444     }
1445 
1446     /**
1447      * @dev Grants `role` to `account`.
1448      *
1449      * If `account` had not been already granted `role`, emits a {RoleGranted}
1450      * event. Note that unlike {grantRole}, this function doesn't perform any
1451      * checks on the calling account.
1452      *
1453      * May emit a {RoleGranted} event.
1454      *
1455      * [WARNING]
1456      * ====
1457      * This function should only be called from the constructor when setting
1458      * up the initial roles for the system.
1459      *
1460      * Using this function in any other way is effectively circumventing the admin
1461      * system imposed by {AccessControl}.
1462      * ====
1463      *
1464      * NOTE: This function is deprecated in favor of {_grantRole}.
1465      */
1466     function _setupRole(bytes32 role, address account) internal virtual {
1467         _grantRole(role, account);
1468     }
1469 
1470     /**
1471      * @dev Sets `adminRole` as ``role``'s admin role.
1472      *
1473      * Emits a {RoleAdminChanged} event.
1474      */
1475     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1476         bytes32 previousAdminRole = getRoleAdmin(role);
1477         _roles[role].adminRole = adminRole;
1478         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1479     }
1480 
1481     /**
1482      * @dev Grants `role` to `account`.
1483      *
1484      * Internal function without access restriction.
1485      *
1486      * May emit a {RoleGranted} event.
1487      */
1488     function _grantRole(bytes32 role, address account) internal virtual {
1489         if (!hasRole(role, account)) {
1490             _roles[role].members[account] = true;
1491             emit RoleGranted(role, account, _msgSender());
1492         }
1493     }
1494 
1495     /**
1496      * @dev Revokes `role` from `account`.
1497      *
1498      * Internal function without access restriction.
1499      *
1500      * May emit a {RoleRevoked} event.
1501      */
1502     function _revokeRole(bytes32 role, address account) internal virtual {
1503         if (hasRole(role, account)) {
1504             _roles[role].members[account] = false;
1505             emit RoleRevoked(role, account, _msgSender());
1506         }
1507     }
1508 }
1509 
1510 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1511 
1512 
1513 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 
1518 
1519 
1520 /**
1521  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1522  */
1523 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1524     using EnumerableSet for EnumerableSet.AddressSet;
1525 
1526     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1527 
1528     /**
1529      * @dev See {IERC165-supportsInterface}.
1530      */
1531     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1532         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1533     }
1534 
1535     /**
1536      * @dev Returns one of the accounts that have `role`. `index` must be a
1537      * value between 0 and {getRoleMemberCount}, non-inclusive.
1538      *
1539      * Role bearers are not sorted in any particular way, and their ordering may
1540      * change at any point.
1541      *
1542      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1543      * you perform all queries on the same block. See the following
1544      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1545      * for more information.
1546      */
1547     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1548         return _roleMembers[role].at(index);
1549     }
1550 
1551     /**
1552      * @dev Returns the number of accounts that have `role`. Can be used
1553      * together with {getRoleMember} to enumerate all bearers of a role.
1554      */
1555     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1556         return _roleMembers[role].length();
1557     }
1558 
1559     /**
1560      * @dev Overload {_grantRole} to track enumerable memberships
1561      */
1562     function _grantRole(bytes32 role, address account) internal virtual override {
1563         super._grantRole(role, account);
1564         _roleMembers[role].add(account);
1565     }
1566 
1567     /**
1568      * @dev Overload {_revokeRole} to track enumerable memberships
1569      */
1570     function _revokeRole(bytes32 role, address account) internal virtual override {
1571         super._revokeRole(role, account);
1572         _roleMembers[role].remove(account);
1573     }
1574 }
1575 
1576 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1577 
1578 
1579 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1580 
1581 pragma solidity ^0.8.0;
1582 
1583 
1584 /**
1585  * @dev Required interface of an ERC721 compliant contract.
1586  */
1587 interface IERC721 is IERC165 {
1588     /**
1589      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1590      */
1591     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1592 
1593     /**
1594      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1595      */
1596     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1597 
1598     /**
1599      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1600      */
1601     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1602 
1603     /**
1604      * @dev Returns the number of tokens in ``owner``'s account.
1605      */
1606     function balanceOf(address owner) external view returns (uint256 balance);
1607 
1608     /**
1609      * @dev Returns the owner of the `tokenId` token.
1610      *
1611      * Requirements:
1612      *
1613      * - `tokenId` must exist.
1614      */
1615     function ownerOf(uint256 tokenId) external view returns (address owner);
1616 
1617     /**
1618      * @dev Safely transfers `tokenId` token from `from` to `to`.
1619      *
1620      * Requirements:
1621      *
1622      * - `from` cannot be the zero address.
1623      * - `to` cannot be the zero address.
1624      * - `tokenId` token must exist and be owned by `from`.
1625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function safeTransferFrom(
1631         address from,
1632         address to,
1633         uint256 tokenId,
1634         bytes calldata data
1635     ) external;
1636 
1637     /**
1638      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1639      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1640      *
1641      * Requirements:
1642      *
1643      * - `from` cannot be the zero address.
1644      * - `to` cannot be the zero address.
1645      * - `tokenId` token must exist and be owned by `from`.
1646      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1647      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1648      *
1649      * Emits a {Transfer} event.
1650      */
1651     function safeTransferFrom(
1652         address from,
1653         address to,
1654         uint256 tokenId
1655     ) external;
1656 
1657     /**
1658      * @dev Transfers `tokenId` token from `from` to `to`.
1659      *
1660      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1661      *
1662      * Requirements:
1663      *
1664      * - `from` cannot be the zero address.
1665      * - `to` cannot be the zero address.
1666      * - `tokenId` token must be owned by `from`.
1667      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1668      *
1669      * Emits a {Transfer} event.
1670      */
1671     function transferFrom(
1672         address from,
1673         address to,
1674         uint256 tokenId
1675     ) external;
1676 
1677     /**
1678      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1679      * The approval is cleared when the token is transferred.
1680      *
1681      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1682      *
1683      * Requirements:
1684      *
1685      * - The caller must own the token or be an approved operator.
1686      * - `tokenId` must exist.
1687      *
1688      * Emits an {Approval} event.
1689      */
1690     function approve(address to, uint256 tokenId) external;
1691 
1692     /**
1693      * @dev Approve or remove `operator` as an operator for the caller.
1694      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1695      *
1696      * Requirements:
1697      *
1698      * - The `operator` cannot be the caller.
1699      *
1700      * Emits an {ApprovalForAll} event.
1701      */
1702     function setApprovalForAll(address operator, bool _approved) external;
1703 
1704     /**
1705      * @dev Returns the account approved for `tokenId` token.
1706      *
1707      * Requirements:
1708      *
1709      * - `tokenId` must exist.
1710      */
1711     function getApproved(uint256 tokenId) external view returns (address operator);
1712 
1713     /**
1714      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1715      *
1716      * See {setApprovalForAll}
1717      */
1718     function isApprovedForAll(address owner, address operator) external view returns (bool);
1719 }
1720 
1721 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1722 
1723 
1724 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1725 
1726 pragma solidity ^0.8.0;
1727 
1728 
1729 /**
1730  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1731  * @dev See https://eips.ethereum.org/EIPS/eip-721
1732  */
1733 interface IERC721Enumerable is IERC721 {
1734     /**
1735      * @dev Returns the total amount of tokens stored by the contract.
1736      */
1737     function totalSupply() external view returns (uint256);
1738 
1739     /**
1740      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1741      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1742      */
1743     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1744 
1745     /**
1746      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1747      * Use along with {totalSupply} to enumerate all tokens.
1748      */
1749     function tokenByIndex(uint256 index) external view returns (uint256);
1750 }
1751 
1752 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1753 
1754 
1755 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1756 
1757 pragma solidity ^0.8.0;
1758 
1759 
1760 /**
1761  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1762  * @dev See https://eips.ethereum.org/EIPS/eip-721
1763  */
1764 interface IERC721Metadata is IERC721 {
1765     /**
1766      * @dev Returns the token collection name.
1767      */
1768     function name() external view returns (string memory);
1769 
1770     /**
1771      * @dev Returns the token collection symbol.
1772      */
1773     function symbol() external view returns (string memory);
1774 
1775     /**
1776      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1777      */
1778     function tokenURI(uint256 tokenId) external view returns (string memory);
1779 }
1780 
1781 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1782 
1783 
1784 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1785 
1786 pragma solidity ^0.8.0;
1787 
1788 
1789 
1790 
1791 
1792 
1793 
1794 
1795 /**
1796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1797  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1798  * {ERC721Enumerable}.
1799  */
1800 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1801     using Address for address;
1802     using Strings for uint256;
1803 
1804     // Token name
1805     string private _name;
1806 
1807     // Token symbol
1808     string private _symbol;
1809 
1810     // Mapping from token ID to owner address
1811     mapping(uint256 => address) private _owners;
1812 
1813     // Mapping owner address to token count
1814     mapping(address => uint256) private _balances;
1815 
1816     // Mapping from token ID to approved address
1817     mapping(uint256 => address) private _tokenApprovals;
1818 
1819     // Mapping from owner to operator approvals
1820     mapping(address => mapping(address => bool)) private _operatorApprovals;
1821 
1822     /**
1823      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1824      */
1825     constructor(string memory name_, string memory symbol_) {
1826         _name = name_;
1827         _symbol = symbol_;
1828     }
1829 
1830     /**
1831      * @dev See {IERC165-supportsInterface}.
1832      */
1833     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1834         return
1835             interfaceId == type(IERC721).interfaceId ||
1836             interfaceId == type(IERC721Metadata).interfaceId ||
1837             super.supportsInterface(interfaceId);
1838     }
1839 
1840     /**
1841      * @dev See {IERC721-balanceOf}.
1842      */
1843     function balanceOf(address owner) public view virtual override returns (uint256) {
1844         require(owner != address(0), "ERC721: address zero is not a valid owner");
1845         return _balances[owner];
1846     }
1847 
1848     /**
1849      * @dev See {IERC721-ownerOf}.
1850      */
1851     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1852         address owner = _owners[tokenId];
1853         require(owner != address(0), "ERC721: invalid token ID");
1854         return owner;
1855     }
1856 
1857     /**
1858      * @dev See {IERC721Metadata-name}.
1859      */
1860     function name() public view virtual override returns (string memory) {
1861         return _name;
1862     }
1863 
1864     /**
1865      * @dev See {IERC721Metadata-symbol}.
1866      */
1867     function symbol() public view virtual override returns (string memory) {
1868         return _symbol;
1869     }
1870 
1871     /**
1872      * @dev See {IERC721Metadata-tokenURI}.
1873      */
1874     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1875         _requireMinted(tokenId);
1876 
1877         string memory baseURI = _baseURI();
1878         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1879     }
1880 
1881     /**
1882      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1883      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1884      * by default, can be overridden in child contracts.
1885      */
1886     function _baseURI() internal view virtual returns (string memory) {
1887         return "";
1888     }
1889 
1890     /**
1891      * @dev See {IERC721-approve}.
1892      */
1893     function approve(address to, uint256 tokenId) public virtual override {
1894         address owner = ERC721.ownerOf(tokenId);
1895         require(to != owner, "ERC721: approval to current owner");
1896 
1897         require(
1898             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1899             "ERC721: approve caller is not token owner nor approved for all"
1900         );
1901 
1902         _approve(to, tokenId);
1903     }
1904 
1905     /**
1906      * @dev See {IERC721-getApproved}.
1907      */
1908     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1909         _requireMinted(tokenId);
1910 
1911         return _tokenApprovals[tokenId];
1912     }
1913 
1914     /**
1915      * @dev See {IERC721-setApprovalForAll}.
1916      */
1917     function setApprovalForAll(address operator, bool approved) public virtual override {
1918         _setApprovalForAll(_msgSender(), operator, approved);
1919     }
1920 
1921     /**
1922      * @dev See {IERC721-isApprovedForAll}.
1923      */
1924     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1925         return _operatorApprovals[owner][operator];
1926     }
1927 
1928     /**
1929      * @dev See {IERC721-transferFrom}.
1930      */
1931     function transferFrom(
1932         address from,
1933         address to,
1934         uint256 tokenId
1935     ) public virtual override {
1936         //solhint-disable-next-line max-line-length
1937         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1938 
1939         _transfer(from, to, tokenId);
1940     }
1941 
1942     /**
1943      * @dev See {IERC721-safeTransferFrom}.
1944      */
1945     function safeTransferFrom(
1946         address from,
1947         address to,
1948         uint256 tokenId
1949     ) public virtual override {
1950         safeTransferFrom(from, to, tokenId, "");
1951     }
1952 
1953     /**
1954      * @dev See {IERC721-safeTransferFrom}.
1955      */
1956     function safeTransferFrom(
1957         address from,
1958         address to,
1959         uint256 tokenId,
1960         bytes memory data
1961     ) public virtual override {
1962         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1963         _safeTransfer(from, to, tokenId, data);
1964     }
1965 
1966     /**
1967      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1968      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1969      *
1970      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1971      *
1972      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1973      * implement alternative mechanisms to perform token transfer, such as signature-based.
1974      *
1975      * Requirements:
1976      *
1977      * - `from` cannot be the zero address.
1978      * - `to` cannot be the zero address.
1979      * - `tokenId` token must exist and be owned by `from`.
1980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1981      *
1982      * Emits a {Transfer} event.
1983      */
1984     function _safeTransfer(
1985         address from,
1986         address to,
1987         uint256 tokenId,
1988         bytes memory data
1989     ) internal virtual {
1990         _transfer(from, to, tokenId);
1991         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1992     }
1993 
1994     /**
1995      * @dev Returns whether `tokenId` exists.
1996      *
1997      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1998      *
1999      * Tokens start existing when they are minted (`_mint`),
2000      * and stop existing when they are burned (`_burn`).
2001      */
2002     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2003         return _owners[tokenId] != address(0);
2004     }
2005 
2006     /**
2007      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2008      *
2009      * Requirements:
2010      *
2011      * - `tokenId` must exist.
2012      */
2013     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2014         address owner = ERC721.ownerOf(tokenId);
2015         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2016     }
2017 
2018     /**
2019      * @dev Safely mints `tokenId` and transfers it to `to`.
2020      *
2021      * Requirements:
2022      *
2023      * - `tokenId` must not exist.
2024      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2025      *
2026      * Emits a {Transfer} event.
2027      */
2028     function _safeMint(address to, uint256 tokenId) internal virtual {
2029         _safeMint(to, tokenId, "");
2030     }
2031 
2032     /**
2033      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2034      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2035      */
2036     function _safeMint(
2037         address to,
2038         uint256 tokenId,
2039         bytes memory data
2040     ) internal virtual {
2041         _mint(to, tokenId);
2042         require(
2043             _checkOnERC721Received(address(0), to, tokenId, data),
2044             "ERC721: transfer to non ERC721Receiver implementer"
2045         );
2046     }
2047 
2048     /**
2049      * @dev Mints `tokenId` and transfers it to `to`.
2050      *
2051      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2052      *
2053      * Requirements:
2054      *
2055      * - `tokenId` must not exist.
2056      * - `to` cannot be the zero address.
2057      *
2058      * Emits a {Transfer} event.
2059      */
2060     function _mint(address to, uint256 tokenId) internal virtual {
2061         require(to != address(0), "ERC721: mint to the zero address");
2062         require(!_exists(tokenId), "ERC721: token already minted");
2063 
2064         _beforeTokenTransfer(address(0), to, tokenId);
2065 
2066         _balances[to] += 1;
2067         _owners[tokenId] = to;
2068 
2069         emit Transfer(address(0), to, tokenId);
2070 
2071         _afterTokenTransfer(address(0), to, tokenId);
2072     }
2073 
2074     /**
2075      * @dev Destroys `tokenId`.
2076      * The approval is cleared when the token is burned.
2077      *
2078      * Requirements:
2079      *
2080      * - `tokenId` must exist.
2081      *
2082      * Emits a {Transfer} event.
2083      */
2084     function _burn(uint256 tokenId) internal virtual {
2085         address owner = ERC721.ownerOf(tokenId);
2086 
2087         _beforeTokenTransfer(owner, address(0), tokenId);
2088 
2089         // Clear approvals
2090         _approve(address(0), tokenId);
2091 
2092         _balances[owner] -= 1;
2093         delete _owners[tokenId];
2094 
2095         emit Transfer(owner, address(0), tokenId);
2096 
2097         _afterTokenTransfer(owner, address(0), tokenId);
2098     }
2099 
2100     /**
2101      * @dev Transfers `tokenId` from `from` to `to`.
2102      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2103      *
2104      * Requirements:
2105      *
2106      * - `to` cannot be the zero address.
2107      * - `tokenId` token must be owned by `from`.
2108      *
2109      * Emits a {Transfer} event.
2110      */
2111     function _transfer(
2112         address from,
2113         address to,
2114         uint256 tokenId
2115     ) internal virtual {
2116         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2117         require(to != address(0), "ERC721: transfer to the zero address");
2118 
2119         _beforeTokenTransfer(from, to, tokenId);
2120 
2121         // Clear approvals from the previous owner
2122         _approve(address(0), tokenId);
2123 
2124         _balances[from] -= 1;
2125         _balances[to] += 1;
2126         _owners[tokenId] = to;
2127 
2128         emit Transfer(from, to, tokenId);
2129 
2130         _afterTokenTransfer(from, to, tokenId);
2131     }
2132 
2133     /**
2134      * @dev Approve `to` to operate on `tokenId`
2135      *
2136      * Emits an {Approval} event.
2137      */
2138     function _approve(address to, uint256 tokenId) internal virtual {
2139         _tokenApprovals[tokenId] = to;
2140         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2141     }
2142 
2143     /**
2144      * @dev Approve `operator` to operate on all of `owner` tokens
2145      *
2146      * Emits an {ApprovalForAll} event.
2147      */
2148     function _setApprovalForAll(
2149         address owner,
2150         address operator,
2151         bool approved
2152     ) internal virtual {
2153         require(owner != operator, "ERC721: approve to caller");
2154         _operatorApprovals[owner][operator] = approved;
2155         emit ApprovalForAll(owner, operator, approved);
2156     }
2157 
2158     /**
2159      * @dev Reverts if the `tokenId` has not been minted yet.
2160      */
2161     function _requireMinted(uint256 tokenId) internal view virtual {
2162         require(_exists(tokenId), "ERC721: invalid token ID");
2163     }
2164 
2165     /**
2166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2167      * The call is not executed if the target address is not a contract.
2168      *
2169      * @param from address representing the previous owner of the given token ID
2170      * @param to target address that will receive the tokens
2171      * @param tokenId uint256 ID of the token to be transferred
2172      * @param data bytes optional data to send along with the call
2173      * @return bool whether the call correctly returned the expected magic value
2174      */
2175     function _checkOnERC721Received(
2176         address from,
2177         address to,
2178         uint256 tokenId,
2179         bytes memory data
2180     ) private returns (bool) {
2181         if (to.isContract()) {
2182             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2183                 return retval == IERC721Receiver.onERC721Received.selector;
2184             } catch (bytes memory reason) {
2185                 if (reason.length == 0) {
2186                     revert("ERC721: transfer to non ERC721Receiver implementer");
2187                 } else {
2188                     /// @solidity memory-safe-assembly
2189                     assembly {
2190                         revert(add(32, reason), mload(reason))
2191                     }
2192                 }
2193             }
2194         } else {
2195             return true;
2196         }
2197     }
2198 
2199     /**
2200      * @dev Hook that is called before any token transfer. This includes minting
2201      * and burning.
2202      *
2203      * Calling conditions:
2204      *
2205      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2206      * transferred to `to`.
2207      * - When `from` is zero, `tokenId` will be minted for `to`.
2208      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2209      * - `from` and `to` are never both zero.
2210      *
2211      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2212      */
2213     function _beforeTokenTransfer(
2214         address from,
2215         address to,
2216         uint256 tokenId
2217     ) internal virtual {}
2218 
2219     /**
2220      * @dev Hook that is called after any transfer of tokens. This includes
2221      * minting and burning.
2222      *
2223      * Calling conditions:
2224      *
2225      * - when `from` and `to` are both non-zero.
2226      * - `from` and `to` are never both zero.
2227      *
2228      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2229      */
2230     function _afterTokenTransfer(
2231         address from,
2232         address to,
2233         uint256 tokenId
2234     ) internal virtual {}
2235 }
2236 
2237 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2238 
2239 
2240 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2241 
2242 pragma solidity ^0.8.0;
2243 
2244 
2245 
2246 /**
2247  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2248  * enumerability of all the token ids in the contract as well as all token ids owned by each
2249  * account.
2250  */
2251 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2252     // Mapping from owner to list of owned token IDs
2253     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2254 
2255     // Mapping from token ID to index of the owner tokens list
2256     mapping(uint256 => uint256) private _ownedTokensIndex;
2257 
2258     // Array with all token ids, used for enumeration
2259     uint256[] private _allTokens;
2260 
2261     // Mapping from token id to position in the allTokens array
2262     mapping(uint256 => uint256) private _allTokensIndex;
2263 
2264     /**
2265      * @dev See {IERC165-supportsInterface}.
2266      */
2267     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2268         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2269     }
2270 
2271     /**
2272      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2273      */
2274     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2275         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2276         return _ownedTokens[owner][index];
2277     }
2278 
2279     /**
2280      * @dev See {IERC721Enumerable-totalSupply}.
2281      */
2282     function totalSupply() public view virtual override returns (uint256) {
2283         return _allTokens.length;
2284     }
2285 
2286     /**
2287      * @dev See {IERC721Enumerable-tokenByIndex}.
2288      */
2289     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2290         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2291         return _allTokens[index];
2292     }
2293 
2294     /**
2295      * @dev Hook that is called before any token transfer. This includes minting
2296      * and burning.
2297      *
2298      * Calling conditions:
2299      *
2300      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2301      * transferred to `to`.
2302      * - When `from` is zero, `tokenId` will be minted for `to`.
2303      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2304      * - `from` cannot be the zero address.
2305      * - `to` cannot be the zero address.
2306      *
2307      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2308      */
2309     function _beforeTokenTransfer(
2310         address from,
2311         address to,
2312         uint256 tokenId
2313     ) internal virtual override {
2314         super._beforeTokenTransfer(from, to, tokenId);
2315 
2316         if (from == address(0)) {
2317             _addTokenToAllTokensEnumeration(tokenId);
2318         } else if (from != to) {
2319             _removeTokenFromOwnerEnumeration(from, tokenId);
2320         }
2321         if (to == address(0)) {
2322             _removeTokenFromAllTokensEnumeration(tokenId);
2323         } else if (to != from) {
2324             _addTokenToOwnerEnumeration(to, tokenId);
2325         }
2326     }
2327 
2328     /**
2329      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2330      * @param to address representing the new owner of the given token ID
2331      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2332      */
2333     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2334         uint256 length = ERC721.balanceOf(to);
2335         _ownedTokens[to][length] = tokenId;
2336         _ownedTokensIndex[tokenId] = length;
2337     }
2338 
2339     /**
2340      * @dev Private function to add a token to this extension's token tracking data structures.
2341      * @param tokenId uint256 ID of the token to be added to the tokens list
2342      */
2343     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2344         _allTokensIndex[tokenId] = _allTokens.length;
2345         _allTokens.push(tokenId);
2346     }
2347 
2348     /**
2349      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2350      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2351      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2352      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2353      * @param from address representing the previous owner of the given token ID
2354      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2355      */
2356     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2357         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2358         // then delete the last slot (swap and pop).
2359 
2360         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2361         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2362 
2363         // When the token to delete is the last token, the swap operation is unnecessary
2364         if (tokenIndex != lastTokenIndex) {
2365             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2366 
2367             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2368             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2369         }
2370 
2371         // This also deletes the contents at the last position of the array
2372         delete _ownedTokensIndex[tokenId];
2373         delete _ownedTokens[from][lastTokenIndex];
2374     }
2375 
2376     /**
2377      * @dev Private function to remove a token from this extension's token tracking data structures.
2378      * This has O(1) time complexity, but alters the order of the _allTokens array.
2379      * @param tokenId uint256 ID of the token to be removed from the tokens list
2380      */
2381     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2382         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2383         // then delete the last slot (swap and pop).
2384 
2385         uint256 lastTokenIndex = _allTokens.length - 1;
2386         uint256 tokenIndex = _allTokensIndex[tokenId];
2387 
2388         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2389         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2390         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2391         uint256 lastTokenId = _allTokens[lastTokenIndex];
2392 
2393         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2394         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2395 
2396         // This also deletes the contents at the last position of the array
2397         delete _allTokensIndex[tokenId];
2398         _allTokens.pop();
2399     }
2400 }
2401 
2402 // File: contracts/MILLIES_NFT.sol
2403 
2404 
2405 
2406 //                                        *                                       
2407 //                                    *********                                  
2408 //                              ********************                              
2409 //                           ***************************                          
2410 //                           ***************************                          
2411 //                           ***************************                         
2412 //                           ***************************                          
2413 //                           ***************************                          
2414 //                           ***************************                          
2415 //                               *******************                               
2416 //                                   ***********                                   
2417 //                                        *                                       
2418 //                                                                                
2419 //                                                                                
2420 //                          *                           *                         
2421 //                     ***********                 ***********                     
2422 //                 ********************       ********************                
2423 //              ************************** *************************             
2424 //                   ******************************************                 
2425 //                       **********************************                      
2426 //                           **************************                           
2427 //                               ******************                               
2428 //                                    *********                                   
2429 //            ***                         *                        ***            
2430 //        ***********                                          ***********       
2431 //   ********************                                  ********************   
2432 //****************************                         ****************************
2433 //     ****************************               ***************************    
2434 //         ****************************       ***************************        
2435 //             *************************** **************************             
2436 //                  ************|Developed by BEE3™|************                 
2437 //                       **********************************                      
2438 //                           **************************                          
2439 //                                *****************                               
2440 //                                    ********                                    
2441 //                                        *                                        
2442 //                                                                                
2443 //                                                                                
2444 //                           *                         *                          
2445 //                           ******               ******                          
2446 //                           *********         *********                          
2447 //                           ************* *************                          
2448 //                           ***************************                          
2449 //                           ***************************                          
2450 //                           ***************************                           
2451 //                               *******************                               
2452 //                                    *********
2453 //                                        *
2454 
2455 pragma solidity 0.8.16;
2456 
2457 
2458 
2459 
2460 
2461 
2462 contract MILLIES_NFT is ERC721Enumerable, Ownable, AccessControlEnumerable {
2463 
2464     /**********************************************
2465      **********************************************
2466                     VARIABLES
2467     **********************************************                    
2468     **********************************************/
2469 
2470     using Strings for uint256;
2471     using Counters for Counters.Counter;
2472 
2473     // Admin role
2474     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2475 
2476     // URI Control
2477     string private baseURI = "https://nftstorage.link/ipfs/bafybeiglxenm2iyk6f3lst7awa2qbaxcdh342fqfv2rekisaumyxocz5cq/";
2478     string public baseExtension = ".json";
2479     string private notRevealedUri = "https://nftstorage.link/ipfs/bafybeigcicp3irnxmbnfw2guamvvmd4yue5gmi6hieajteqdzeqmy56beu/MilliesNotRevealed.json";
2480 
2481     // Payment address
2482     address payable private payments;
2483 
2484     // Supply 6500 NFTs by default
2485     uint256 public maxSupply = 6500;
2486     
2487     // Precio de 0.04 Eth en WL y precio de 0.08 Eth Public Sale
2488     uint256 public wlCost = 0.04 ether;
2489     uint256 public mintCost = 0.08 ether;
2490 
2491     // Máximo de 5 NFTs por wallet
2492     uint256 public maxMintAmountinWL = 3;
2493     uint256 public maxMintAmount = 5;
2494 
2495     // 500 freemints (Últimos 500 NFTs)
2496     uint256 public constant freeMintAmount = 500;
2497 
2498     // Royalties del 5% de ventas secundarias.
2499     address payable private royaltiesAddress;           // ¿Donde se pagan los royalties?
2500     uint96 private royaltiesBasicPoints;                // Porcentaje a pagar
2501     uint96 private constant maxRoyaltiePoints = 1500;    // Maximo un 15%
2502 
2503     // Smart Contract | Control
2504     bool public isPaused = true;              // Pausar el mint
2505     bool private isRevealed = false;          // Revelar NFTs
2506     bool public isWhitelistEnabled = true;    // Whitelist activa?
2507     bool public isFreeMintEnabled = false;    // Freemints activos?
2508 
2509     // Mapeo direcciónWallet -> activo en whitelist
2510     bytes32 private wlRoot = 0xa9244026f69efee0ba376df3689d70a57a73c5e17a216a7b815ca48663e1e50a;
2511     bytes32 private ogRoot = 0xc23bffc5fd6cd6235d0fb70f2214e2d8847810efc9b15580b25a244a0c49305c;
2512 
2513     // Freeminters
2514     mapping(address => bool) private claimedFreeminters;
2515 
2516     // Mint amount control
2517     mapping(address => Counters.Counter) private addressMintedBalanceInWL;
2518     mapping(address => Counters.Counter) private addressMintedBalance;
2519 
2520     /**********************************************
2521      **********************************************
2522                     CONSTRUCTOR
2523     **********************************************                    
2524     **********************************************/
2525 
2526     constructor(address _paymentAddress, address _royaltiesAddress) ERC721("The Millies Club", "TMC") {
2527         
2528         // Rol de administrador para owner
2529         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2530         _setupRole(ADMIN_ROLE, _msgSender());
2531         // Splitters
2532         payments = payable(_paymentAddress);
2533         royaltiesAddress = payable(_royaltiesAddress); //Contract creator by default
2534         // Porcentaje de royalties
2535         royaltiesBasicPoints = 500; // 5% default
2536 
2537         // ---------
2538         // Preminted
2539         // ---------
2540         // BEE3
2541         internalPreMint(0xd54cC4CCAc6974417A9B90fd15B7de08CbC9F1D7, 18);
2542         // (SORTEOS, REGALOS Y PERSONALES)
2543         internalPreMint(0xfB6171deec30DF5efA7f115e6F04C8DF23eEDeA4, 25);
2544         // (SORTEOS, REGALOS Y PERSONALES)
2545         internalPreMint(0xea777b2C50094bdA93D55c64393Ec6F0F92D3380, 25);
2546         // 
2547         internalPreMint(0xCe3f52A81D998f37692aC85e6Aa26029A3fAF24d, 5);
2548         // 
2549         internalPreMint(0x4894B2Bc59579c2574B5309C8343E8cF0e2ec67E, 3);
2550         //
2551         internalPreMint(0xF30f172Fa9EaAffe2146D414fE573a33387133dd, 3);
2552         //
2553         internalPreMint(0x494A38af8d9C9252ac52580ec7b5543333127c07, 3);
2554     }
2555 
2556     /**********************************************
2557      **********************************************
2558                URI AND METADATA FUNCTIONS
2559     **********************************************                    
2560     **********************************************/
2561 
2562     // ERC721 override
2563     function _baseURI() internal view virtual override returns (string memory) {
2564         return baseURI;
2565     }
2566 
2567     // ERC721 override
2568     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2569         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2570         
2571         if(!isRevealed) return notRevealedUri;
2572 
2573         string memory currentBaseURI = _baseURI();
2574 
2575         return bytes(currentBaseURI).length > 0
2576             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2577             : "";
2578     }
2579 
2580     // Meta-data to show when it has not yet been revealed.
2581     function setNotRevealedURI(string memory _notRevealedURI) external {
2582         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2583         notRevealedUri = _notRevealedURI;
2584     }
2585 
2586     function setBaseURI(string memory _newBaseURI) external {
2587         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2588         baseURI = _newBaseURI;
2589     }
2590 
2591     function setBaseExtension(string memory _newBaseExtension) external {
2592         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2593         baseExtension = _newBaseExtension;
2594     }
2595 
2596     // Reveal meta-data of NFTs.
2597     function reveal() external {
2598         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2599         isRevealed = true;
2600     }
2601 
2602     /**********************************************
2603      **********************************************
2604                     MINTING FUNCTIONs
2605     **********************************************                    
2606     **********************************************/
2607 
2608     // Internal function - Easy mint and counting
2609     function internalBulkMint(address _to, uint256 _amount) internal {
2610         for(uint i = 0; i < _amount; i++) {
2611             _safeMint(_to, totalSupply());
2612 
2613             if(isWhitelistEnabled) addressMintedBalanceInWL[_to].increment();
2614             else addressMintedBalance[_to].increment();
2615         }
2616     }
2617 
2618     // Internal function - Easy pre-mint
2619     function internalPreMint(address _to, uint256 _amount) internal {
2620         for(uint i = 0; i < _amount; i++) {
2621             _safeMint(_to, totalSupply());
2622         }
2623     }
2624 
2625     // Public function
2626     function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) external payable {
2627         require(!isPaused, "Exception in mint: Contract is paused");
2628         require(!isFreeMintEnabled, "Exception in mint: Mint finished. Freemint enabled.");
2629         require(_mintAmount > 0, "Exception in mint: You have to mint at least one");
2630 
2631         require((totalSupply() + _mintAmount) <= (maxSupply-freeMintAmount), "Exception in mint: Try to mint less quantity.");
2632         require((remainingForMint() - _mintAmount) > freeMintAmount, "Exception in mint: Mint finished.");
2633 
2634         address _to = _msgSender();
2635         // 1ª Fase: Solo minteo con whitelist
2636         if(isWhitelistEnabled) {
2637             require(checkWhitelistValidity(_merkleProof), "Exception in mint: You are not in the WL.");
2638             require((addressMintedBalanceInWL[_to].current() + _mintAmount <= maxMintAmountinWL), "Exception in mint: You have exceeded the limit.");
2639             require(msg.value >= (wlCost * _mintAmount), "Exception in mint: A lower quantity has been sended.");
2640             internalBulkMint(_to, _mintAmount);
2641         }
2642         // 2ª Fase: Minteo público
2643         else if(!isWhitelistEnabled) {
2644             require((addressMintedBalance[_to].current() + _mintAmount <= maxMintAmount), "Exception in mint: You have exceeded the limit.");
2645             require(msg.value >= (mintCost * _mintAmount), "Exception in mint: A lower quantity has been sended.");
2646             internalBulkMint(_to, _mintAmount);
2647         }
2648     }
2649 
2650     function claimFreemint(bytes32[] calldata _merkleProof) external {
2651         require(checkFreemintValidity(_merkleProof), "Exception in claimFreemint: You do not have access to free mining.");
2652         require(!claimedFreeminters[_msgSender()], "Exception in claimFreemint: You have already claimed your NFT.");
2653 
2654         require(!isPaused, "Exception in claimFreemint: Claim is paused.");
2655         require(isFreeMintEnabled, "Exception in claimFreemint: Freemint is not activated.");
2656         
2657         require(remainingForMint() <= freeMintAmount, "Exception in claimFreemint: Not the last 500 NFTs yet!");
2658 
2659         claimedFreeminters[_msgSender()] = true;
2660         internalBulkMint(_msgSender(), 1);
2661     }
2662 
2663     function itsClaimed(address _addr) external view returns(bool) {
2664         return claimedFreeminters[_addr];
2665     }
2666 
2667     function adminMint(address _to, uint256 _amount) external {
2668         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2669         internalBulkMint(_to, _amount);
2670     }
2671 
2672     // BE CAREFUL!!!
2673     function destroyTheRest() external {
2674         require(isPaused, "Exception in destroyTheRest: The contract needs to be suspended.");
2675         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2676 
2677         uint burnAmount = (maxSupply - freeMintAmount) - totalSupply();
2678         maxSupply -= burnAmount;
2679         isFreeMintEnabled = true;
2680     }
2681 
2682     /**********************************************
2683      **********************************************
2684                    WHITELIST FUNCTIONs
2685     **********************************************                    
2686     **********************************************/
2687 
2688     function checkWhitelistValidity(bytes32[] calldata _merkleProof) public view returns (bool){
2689         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2690         require(MerkleProof.verify(_merkleProof, wlRoot, leaf), "Excetion in checkWhitelistValidity: Not whitelisted");
2691         return true;
2692     }
2693 
2694     function setWlRoot(bytes32 _root) external onlyOwner {
2695         wlRoot = _root;
2696     }
2697 
2698     function toggleWhitelist(bool toggle) external {
2699         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2700         require(isWhitelistEnabled != toggle, "Exception in toggleWhitelist: Same values.");
2701         isWhitelistEnabled = toggle;
2702     }
2703 
2704     /**********************************************
2705      **********************************************
2706                    FREEMINTs FUNCTIONs
2707     **********************************************                    
2708     **********************************************/
2709 
2710     function checkFreemintValidity(bytes32[] calldata _merkleProof) public view returns (bool){
2711         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2712         require(MerkleProof.verify(_merkleProof, ogRoot, leaf), "Excetion in checkFreemintValidity: Not whitelisted");
2713         return true;
2714     }
2715 
2716     function setOgRoot(bytes32 _root) external onlyOwner {
2717         ogRoot = _root;
2718     }
2719    
2720     function toggleFreemint(bool toggle) external {
2721         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2722         require(isFreeMintEnabled != toggle, "Exception in toggleFreemint: Same values.");
2723         isFreeMintEnabled = toggle;
2724     }
2725 
2726     /**********************************************
2727      **********************************************
2728                     UTILITY FUNCTIONs
2729     **********************************************                    
2730     **********************************************/
2731 
2732     function walletOfOwner(address wallet) external view returns (uint256[] memory) {
2733         uint256 ownerTokenCount = balanceOf(wallet);
2734         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2735 
2736         for (uint256 i; i < ownerTokenCount; i++) {
2737             tokenIds[i] = tokenOfOwnerByIndex(wallet, i);
2738         }
2739 
2740         return tokenIds;
2741     }
2742 
2743     function getWalletMinted(address wallet) external view returns(uint) {
2744         return addressMintedBalance[wallet].current();
2745     }
2746 
2747     //Public wrapper of _exists
2748     function exists(uint256 tokenId) public view returns (bool) {
2749         return _exists(tokenId);
2750     }
2751 
2752     function remainingForMint() public view returns(uint256) {
2753         return maxSupply - totalSupply();
2754     }
2755 
2756     function remainingForMintOneWallet(address wallet) external view returns(uint256) {
2757         uint256 resultado;
2758 
2759         if(isWhitelistEnabled) {
2760             resultado = maxMintAmountinWL - addressMintedBalanceInWL[wallet].current();
2761         } else {
2762             resultado = maxMintAmount - addressMintedBalance[wallet].current();
2763         }
2764 
2765         return resultado;
2766     }
2767 
2768     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, AccessControlEnumerable) returns (bool) {
2769         return super.supportsInterface(interfaceId);
2770     }
2771 
2772     /**********************************************
2773      **********************************************
2774                     PAYMETS FUNCTIONs
2775     **********************************************                    
2776     **********************************************/
2777 
2778     function withdraw() external payable {
2779         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2780         (bool itsOk, ) = payable(payments).call{value: address(this).balance}("");
2781         require(itsOk, "Failed withdraw.");
2782     }
2783 
2784     function setPaymentAddress(address newAddress) external onlyOwner {
2785         payments = payable(newAddress);
2786     }
2787 
2788     function viewPaymentAddress() external view onlyOwner returns(address) {
2789         return payments;
2790     }
2791 
2792     function setMintCost(uint256 _newCost) external {
2793         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2794         mintCost = _newCost;
2795     }
2796 
2797     function setWlCost(uint256 _newCost) external {
2798         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2799         wlCost = _newCost;
2800     }
2801 
2802     /**********************************************
2803      **********************************************
2804                     CONTROL FUNCTIONs
2805     **********************************************                    
2806     **********************************************/
2807 
2808     function setMaxMintAmount(uint256 _newmaxMintAmount) external {
2809         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2810         maxMintAmount = _newmaxMintAmount;
2811     }
2812 
2813     function pause(bool _state) external {
2814         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2815         isPaused = _state;
2816     }
2817 
2818     function manageRoles(address wallet, bool enabled) external {
2819         require(hasRole(ADMIN_ROLE, _msgSender()) || _msgSender() == owner(), "You do not have permissions.");
2820         if(enabled){
2821             _grantRole(ADMIN_ROLE, wallet);
2822         } else{
2823             _revokeRole(ADMIN_ROLE, wallet);
2824         } 
2825     }
2826 
2827     /**********************************************
2828      **********************************************
2829                    ROYALTIES FUNCTIONs
2830     **********************************************                    
2831     **********************************************/
2832 
2833     function royaltyInfo(uint256 _tokenId, uint256 _salePrice ) external view returns ( address receiver, uint256 royaltyAmount) {
2834         if(exists(_tokenId))
2835             return(royaltiesAddress, (_salePrice * royaltiesBasicPoints)/10000);        
2836         return (address(0), 0); 
2837     }
2838 
2839     function setRoyaltiesAddress(address payable rAddress) external {
2840         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2841         require(rAddress != address(0), "Exception in setRoyaltiesAddress: Address zero.");
2842         royaltiesAddress = rAddress;
2843     }
2844 
2845     function setRoyaltiesBasicPoints(uint96 rBasicPoints) external {
2846         require(hasRole(ADMIN_ROLE, _msgSender()), "You do not have permissions.");
2847         require(rBasicPoints <= maxRoyaltiePoints, "Royaties error: Limit reached");
2848         royaltiesBasicPoints = rBasicPoints;
2849     }  
2850 
2851 }