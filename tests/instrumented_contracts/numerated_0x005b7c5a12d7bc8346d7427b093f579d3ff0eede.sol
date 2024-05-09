1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The tree and the proofs can be generated using our
12  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
13  * You will find a quickstart guide in the readme.
14  *
15  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
16  * hashing, or use a hash function other than keccak256 for hashing leaves.
17  * This is because the concatenation of a sorted pair of internal nodes in
18  * the merkle tree could be reinterpreted as a leaf value.
19  * OpenZeppelin's JavaScript library generates merkle trees that are safe
20  * against this attack out of the box.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
84      *
85      * _Available since v4.7._
86      */
87     function multiProofVerify(
88         bytes32[] memory proof,
89         bool[] memory proofFlags,
90         bytes32 root,
91         bytes32[] memory leaves
92     ) internal pure returns (bool) {
93         return processMultiProof(proof, proofFlags, leaves) == root;
94     }
95 
96     /**
97      * @dev Calldata version of {multiProofVerify}
98      *
99      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
100      *
101      * _Available since v4.7._
102      */
103     function multiProofVerifyCalldata(
104         bytes32[] calldata proof,
105         bool[] calldata proofFlags,
106         bytes32 root,
107         bytes32[] memory leaves
108     ) internal pure returns (bool) {
109         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
110     }
111 
112     /**
113      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
114      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
115      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
116      * respectively.
117      *
118      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
119      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
120      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
121      *
122      * _Available since v4.7._
123      */
124     function processMultiProof(
125         bytes32[] memory proof,
126         bool[] memory proofFlags,
127         bytes32[] memory leaves
128     ) internal pure returns (bytes32 merkleRoot) {
129         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
130         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
131         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
132         // the merkle tree.
133         uint256 leavesLen = leaves.length;
134         uint256 totalHashes = proofFlags.length;
135 
136         // Check proof validity.
137         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
138 
139         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
140         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
141         bytes32[] memory hashes = new bytes32[](totalHashes);
142         uint256 leafPos = 0;
143         uint256 hashPos = 0;
144         uint256 proofPos = 0;
145         // At each step, we compute the next hash using two values:
146         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
147         //   get the next hash.
148         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
149         //   `proof` array.
150         for (uint256 i = 0; i < totalHashes; i++) {
151             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
152             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
153             hashes[i] = _hashPair(a, b);
154         }
155 
156         if (totalHashes > 0) {
157             return hashes[totalHashes - 1];
158         } else if (leavesLen > 0) {
159             return leaves[0];
160         } else {
161             return proof[0];
162         }
163     }
164 
165     /**
166      * @dev Calldata version of {processMultiProof}.
167      *
168      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
169      *
170      * _Available since v4.7._
171      */
172     function processMultiProofCalldata(
173         bytes32[] calldata proof,
174         bool[] calldata proofFlags,
175         bytes32[] memory leaves
176     ) internal pure returns (bytes32 merkleRoot) {
177         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
178         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
179         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
180         // the merkle tree.
181         uint256 leavesLen = leaves.length;
182         uint256 totalHashes = proofFlags.length;
183 
184         // Check proof validity.
185         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
186 
187         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
188         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
189         bytes32[] memory hashes = new bytes32[](totalHashes);
190         uint256 leafPos = 0;
191         uint256 hashPos = 0;
192         uint256 proofPos = 0;
193         // At each step, we compute the next hash using two values:
194         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
195         //   get the next hash.
196         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
197         //   `proof` array.
198         for (uint256 i = 0; i < totalHashes; i++) {
199             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
200             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
201             hashes[i] = _hashPair(a, b);
202         }
203 
204         if (totalHashes > 0) {
205             return hashes[totalHashes - 1];
206         } else if (leavesLen > 0) {
207             return leaves[0];
208         } else {
209             return proof[0];
210         }
211     }
212 
213     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
214         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
215     }
216 
217     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
218         /// @solidity memory-safe-assembly
219         assembly {
220             mstore(0x00, a)
221             mstore(0x20, b)
222             value := keccak256(0x00, 0x40)
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
231 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Library for managing
237  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
238  * types.
239  *
240  * Sets have the following properties:
241  *
242  * - Elements are added, removed, and checked for existence in constant time
243  * (O(1)).
244  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
245  *
246  * ```
247  * contract Example {
248  *     // Add the library methods
249  *     using EnumerableSet for EnumerableSet.AddressSet;
250  *
251  *     // Declare a set state variable
252  *     EnumerableSet.AddressSet private mySet;
253  * }
254  * ```
255  *
256  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
257  * and `uint256` (`UintSet`) are supported.
258  *
259  * [WARNING]
260  * ====
261  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
262  * unusable.
263  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
264  *
265  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
266  * array of EnumerableSet.
267  * ====
268  */
269 library EnumerableSet {
270     // To implement this library for multiple types with as little code
271     // repetition as possible, we write it in terms of a generic Set type with
272     // bytes32 values.
273     // The Set implementation uses private functions, and user-facing
274     // implementations (such as AddressSet) are just wrappers around the
275     // underlying Set.
276     // This means that we can only create new EnumerableSets for types that fit
277     // in bytes32.
278 
279     struct Set {
280         // Storage of set values
281         bytes32[] _values;
282         // Position of the value in the `values` array, plus 1 because index 0
283         // means a value is not in the set.
284         mapping(bytes32 => uint256) _indexes;
285     }
286 
287     /**
288      * @dev Add a value to a set. O(1).
289      *
290      * Returns true if the value was added to the set, that is if it was not
291      * already present.
292      */
293     function _add(Set storage set, bytes32 value) private returns (bool) {
294         if (!_contains(set, value)) {
295             set._values.push(value);
296             // The value is stored at length-1, but we add 1 to all indexes
297             // and use 0 as a sentinel value
298             set._indexes[value] = set._values.length;
299             return true;
300         } else {
301             return false;
302         }
303     }
304 
305     /**
306      * @dev Removes a value from a set. O(1).
307      *
308      * Returns true if the value was removed from the set, that is if it was
309      * present.
310      */
311     function _remove(Set storage set, bytes32 value) private returns (bool) {
312         // We read and store the value's index to prevent multiple reads from the same storage slot
313         uint256 valueIndex = set._indexes[value];
314 
315         if (valueIndex != 0) {
316             // Equivalent to contains(set, value)
317             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
318             // the array, and then remove the last element (sometimes called as 'swap and pop').
319             // This modifies the order of the array, as noted in {at}.
320 
321             uint256 toDeleteIndex = valueIndex - 1;
322             uint256 lastIndex = set._values.length - 1;
323 
324             if (lastIndex != toDeleteIndex) {
325                 bytes32 lastValue = set._values[lastIndex];
326 
327                 // Move the last value to the index where the value to delete is
328                 set._values[toDeleteIndex] = lastValue;
329                 // Update the index for the moved value
330                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
331             }
332 
333             // Delete the slot where the moved value was stored
334             set._values.pop();
335 
336             // Delete the index for the deleted slot
337             delete set._indexes[value];
338 
339             return true;
340         } else {
341             return false;
342         }
343     }
344 
345     /**
346      * @dev Returns true if the value is in the set. O(1).
347      */
348     function _contains(Set storage set, bytes32 value) private view returns (bool) {
349         return set._indexes[value] != 0;
350     }
351 
352     /**
353      * @dev Returns the number of values on the set. O(1).
354      */
355     function _length(Set storage set) private view returns (uint256) {
356         return set._values.length;
357     }
358 
359     /**
360      * @dev Returns the value stored at position `index` in the set. O(1).
361      *
362      * Note that there are no guarantees on the ordering of values inside the
363      * array, and it may change when more values are added or removed.
364      *
365      * Requirements:
366      *
367      * - `index` must be strictly less than {length}.
368      */
369     function _at(Set storage set, uint256 index) private view returns (bytes32) {
370         return set._values[index];
371     }
372 
373     /**
374      * @dev Return the entire set in an array
375      *
376      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
377      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
378      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
379      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
380      */
381     function _values(Set storage set) private view returns (bytes32[] memory) {
382         return set._values;
383     }
384 
385     // Bytes32Set
386 
387     struct Bytes32Set {
388         Set _inner;
389     }
390 
391     /**
392      * @dev Add a value to a set. O(1).
393      *
394      * Returns true if the value was added to the set, that is if it was not
395      * already present.
396      */
397     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
398         return _add(set._inner, value);
399     }
400 
401     /**
402      * @dev Removes a value from a set. O(1).
403      *
404      * Returns true if the value was removed from the set, that is if it was
405      * present.
406      */
407     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
408         return _remove(set._inner, value);
409     }
410 
411     /**
412      * @dev Returns true if the value is in the set. O(1).
413      */
414     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
415         return _contains(set._inner, value);
416     }
417 
418     /**
419      * @dev Returns the number of values in the set. O(1).
420      */
421     function length(Bytes32Set storage set) internal view returns (uint256) {
422         return _length(set._inner);
423     }
424 
425     /**
426      * @dev Returns the value stored at position `index` in the set. O(1).
427      *
428      * Note that there are no guarantees on the ordering of values inside the
429      * array, and it may change when more values are added or removed.
430      *
431      * Requirements:
432      *
433      * - `index` must be strictly less than {length}.
434      */
435     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
436         return _at(set._inner, index);
437     }
438 
439     /**
440      * @dev Return the entire set in an array
441      *
442      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
443      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
444      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
445      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
446      */
447     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
448         bytes32[] memory store = _values(set._inner);
449         bytes32[] memory result;
450 
451         /// @solidity memory-safe-assembly
452         assembly {
453             result := store
454         }
455 
456         return result;
457     }
458 
459     // AddressSet
460 
461     struct AddressSet {
462         Set _inner;
463     }
464 
465     /**
466      * @dev Add a value to a set. O(1).
467      *
468      * Returns true if the value was added to the set, that is if it was not
469      * already present.
470      */
471     function add(AddressSet storage set, address value) internal returns (bool) {
472         return _add(set._inner, bytes32(uint256(uint160(value))));
473     }
474 
475     /**
476      * @dev Removes a value from a set. O(1).
477      *
478      * Returns true if the value was removed from the set, that is if it was
479      * present.
480      */
481     function remove(AddressSet storage set, address value) internal returns (bool) {
482         return _remove(set._inner, bytes32(uint256(uint160(value))));
483     }
484 
485     /**
486      * @dev Returns true if the value is in the set. O(1).
487      */
488     function contains(AddressSet storage set, address value) internal view returns (bool) {
489         return _contains(set._inner, bytes32(uint256(uint160(value))));
490     }
491 
492     /**
493      * @dev Returns the number of values in the set. O(1).
494      */
495     function length(AddressSet storage set) internal view returns (uint256) {
496         return _length(set._inner);
497     }
498 
499     /**
500      * @dev Returns the value stored at position `index` in the set. O(1).
501      *
502      * Note that there are no guarantees on the ordering of values inside the
503      * array, and it may change when more values are added or removed.
504      *
505      * Requirements:
506      *
507      * - `index` must be strictly less than {length}.
508      */
509     function at(AddressSet storage set, uint256 index) internal view returns (address) {
510         return address(uint160(uint256(_at(set._inner, index))));
511     }
512 
513     /**
514      * @dev Return the entire set in an array
515      *
516      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
517      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
518      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
519      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
520      */
521     function values(AddressSet storage set) internal view returns (address[] memory) {
522         bytes32[] memory store = _values(set._inner);
523         address[] memory result;
524 
525         /// @solidity memory-safe-assembly
526         assembly {
527             result := store
528         }
529 
530         return result;
531     }
532 
533     // UintSet
534 
535     struct UintSet {
536         Set _inner;
537     }
538 
539     /**
540      * @dev Add a value to a set. O(1).
541      *
542      * Returns true if the value was added to the set, that is if it was not
543      * already present.
544      */
545     function add(UintSet storage set, uint256 value) internal returns (bool) {
546         return _add(set._inner, bytes32(value));
547     }
548 
549     /**
550      * @dev Removes a value from a set. O(1).
551      *
552      * Returns true if the value was removed from the set, that is if it was
553      * present.
554      */
555     function remove(UintSet storage set, uint256 value) internal returns (bool) {
556         return _remove(set._inner, bytes32(value));
557     }
558 
559     /**
560      * @dev Returns true if the value is in the set. O(1).
561      */
562     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
563         return _contains(set._inner, bytes32(value));
564     }
565 
566     /**
567      * @dev Returns the number of values in the set. O(1).
568      */
569     function length(UintSet storage set) internal view returns (uint256) {
570         return _length(set._inner);
571     }
572 
573     /**
574      * @dev Returns the value stored at position `index` in the set. O(1).
575      *
576      * Note that there are no guarantees on the ordering of values inside the
577      * array, and it may change when more values are added or removed.
578      *
579      * Requirements:
580      *
581      * - `index` must be strictly less than {length}.
582      */
583     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
584         return uint256(_at(set._inner, index));
585     }
586 
587     /**
588      * @dev Return the entire set in an array
589      *
590      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
591      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
592      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
593      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
594      */
595     function values(UintSet storage set) internal view returns (uint256[] memory) {
596         bytes32[] memory store = _values(set._inner);
597         uint256[] memory result;
598 
599         /// @solidity memory-safe-assembly
600         assembly {
601             result := store
602         }
603 
604         return result;
605     }
606 }
607 
608 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev Interface of the ERC165 standard, as defined in the
617  * https://eips.ethereum.org/EIPS/eip-165[EIP].
618  *
619  * Implementers can declare support of contract interfaces, which can then be
620  * queried by others ({ERC165Checker}).
621  *
622  * For an implementation, see {ERC165}.
623  */
624 interface IERC165 {
625     /**
626      * @dev Returns true if this contract implements the interface defined by
627      * `interfaceId`. See the corresponding
628      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
629      * to learn more about how these ids are created.
630      *
631      * This function call must use less than 30 000 gas.
632      */
633     function supportsInterface(bytes4 interfaceId) external view returns (bool);
634 }
635 
636 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @dev Implementation of the {IERC165} interface.
646  *
647  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
648  * for the additional interface id that will be supported. For example:
649  *
650  * ```solidity
651  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
652  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
653  * }
654  * ```
655  *
656  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
657  */
658 abstract contract ERC165 is IERC165 {
659     /**
660      * @dev See {IERC165-supportsInterface}.
661      */
662     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
663         return interfaceId == type(IERC165).interfaceId;
664     }
665 }
666 
667 // File: @openzeppelin/contracts/utils/math/Math.sol
668 
669 
670 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev Standard math utilities missing in the Solidity language.
676  */
677 library Math {
678     enum Rounding {
679         Down, // Toward negative infinity
680         Up, // Toward infinity
681         Zero // Toward zero
682     }
683 
684     /**
685      * @dev Returns the largest of two numbers.
686      */
687     function max(uint256 a, uint256 b) internal pure returns (uint256) {
688         return a > b ? a : b;
689     }
690 
691     /**
692      * @dev Returns the smallest of two numbers.
693      */
694     function min(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a < b ? a : b;
696     }
697 
698     /**
699      * @dev Returns the average of two numbers. The result is rounded towards
700      * zero.
701      */
702     function average(uint256 a, uint256 b) internal pure returns (uint256) {
703         // (a + b) / 2 can overflow.
704         return (a & b) + (a ^ b) / 2;
705     }
706 
707     /**
708      * @dev Returns the ceiling of the division of two numbers.
709      *
710      * This differs from standard division with `/` in that it rounds up instead
711      * of rounding down.
712      */
713     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
714         // (a + b - 1) / b can overflow on addition, so we distribute.
715         return a == 0 ? 0 : (a - 1) / b + 1;
716     }
717 
718     /**
719      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
720      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
721      * with further edits by Uniswap Labs also under MIT license.
722      */
723     function mulDiv(
724         uint256 x,
725         uint256 y,
726         uint256 denominator
727     ) internal pure returns (uint256 result) {
728         unchecked {
729             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
730             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
731             // variables such that product = prod1 * 2^256 + prod0.
732             uint256 prod0; // Least significant 256 bits of the product
733             uint256 prod1; // Most significant 256 bits of the product
734             assembly {
735                 let mm := mulmod(x, y, not(0))
736                 prod0 := mul(x, y)
737                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
738             }
739 
740             // Handle non-overflow cases, 256 by 256 division.
741             if (prod1 == 0) {
742                 return prod0 / denominator;
743             }
744 
745             // Make sure the result is less than 2^256. Also prevents denominator == 0.
746             require(denominator > prod1);
747 
748             ///////////////////////////////////////////////
749             // 512 by 256 division.
750             ///////////////////////////////////////////////
751 
752             // Make division exact by subtracting the remainder from [prod1 prod0].
753             uint256 remainder;
754             assembly {
755                 // Compute remainder using mulmod.
756                 remainder := mulmod(x, y, denominator)
757 
758                 // Subtract 256 bit number from 512 bit number.
759                 prod1 := sub(prod1, gt(remainder, prod0))
760                 prod0 := sub(prod0, remainder)
761             }
762 
763             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
764             // See https://cs.stackexchange.com/q/138556/92363.
765 
766             // Does not overflow because the denominator cannot be zero at this stage in the function.
767             uint256 twos = denominator & (~denominator + 1);
768             assembly {
769                 // Divide denominator by twos.
770                 denominator := div(denominator, twos)
771 
772                 // Divide [prod1 prod0] by twos.
773                 prod0 := div(prod0, twos)
774 
775                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
776                 twos := add(div(sub(0, twos), twos), 1)
777             }
778 
779             // Shift in bits from prod1 into prod0.
780             prod0 |= prod1 * twos;
781 
782             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
783             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
784             // four bits. That is, denominator * inv = 1 mod 2^4.
785             uint256 inverse = (3 * denominator) ^ 2;
786 
787             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
788             // in modular arithmetic, doubling the correct bits in each step.
789             inverse *= 2 - denominator * inverse; // inverse mod 2^8
790             inverse *= 2 - denominator * inverse; // inverse mod 2^16
791             inverse *= 2 - denominator * inverse; // inverse mod 2^32
792             inverse *= 2 - denominator * inverse; // inverse mod 2^64
793             inverse *= 2 - denominator * inverse; // inverse mod 2^128
794             inverse *= 2 - denominator * inverse; // inverse mod 2^256
795 
796             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
797             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
798             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
799             // is no longer required.
800             result = prod0 * inverse;
801             return result;
802         }
803     }
804 
805     /**
806      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
807      */
808     function mulDiv(
809         uint256 x,
810         uint256 y,
811         uint256 denominator,
812         Rounding rounding
813     ) internal pure returns (uint256) {
814         uint256 result = mulDiv(x, y, denominator);
815         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
816             result += 1;
817         }
818         return result;
819     }
820 
821     /**
822      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
823      *
824      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
825      */
826     function sqrt(uint256 a) internal pure returns (uint256) {
827         if (a == 0) {
828             return 0;
829         }
830 
831         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
832         //
833         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
834         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
835         //
836         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
837         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
838         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
839         //
840         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
841         uint256 result = 1 << (log2(a) >> 1);
842 
843         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
844         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
845         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
846         // into the expected uint128 result.
847         unchecked {
848             result = (result + a / result) >> 1;
849             result = (result + a / result) >> 1;
850             result = (result + a / result) >> 1;
851             result = (result + a / result) >> 1;
852             result = (result + a / result) >> 1;
853             result = (result + a / result) >> 1;
854             result = (result + a / result) >> 1;
855             return min(result, a / result);
856         }
857     }
858 
859     /**
860      * @notice Calculates sqrt(a), following the selected rounding direction.
861      */
862     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
863         unchecked {
864             uint256 result = sqrt(a);
865             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
866         }
867     }
868 
869     /**
870      * @dev Return the log in base 2, rounded down, of a positive value.
871      * Returns 0 if given 0.
872      */
873     function log2(uint256 value) internal pure returns (uint256) {
874         uint256 result = 0;
875         unchecked {
876             if (value >> 128 > 0) {
877                 value >>= 128;
878                 result += 128;
879             }
880             if (value >> 64 > 0) {
881                 value >>= 64;
882                 result += 64;
883             }
884             if (value >> 32 > 0) {
885                 value >>= 32;
886                 result += 32;
887             }
888             if (value >> 16 > 0) {
889                 value >>= 16;
890                 result += 16;
891             }
892             if (value >> 8 > 0) {
893                 value >>= 8;
894                 result += 8;
895             }
896             if (value >> 4 > 0) {
897                 value >>= 4;
898                 result += 4;
899             }
900             if (value >> 2 > 0) {
901                 value >>= 2;
902                 result += 2;
903             }
904             if (value >> 1 > 0) {
905                 result += 1;
906             }
907         }
908         return result;
909     }
910 
911     /**
912      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
913      * Returns 0 if given 0.
914      */
915     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
916         unchecked {
917             uint256 result = log2(value);
918             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
919         }
920     }
921 
922     /**
923      * @dev Return the log in base 10, rounded down, of a positive value.
924      * Returns 0 if given 0.
925      */
926     function log10(uint256 value) internal pure returns (uint256) {
927         uint256 result = 0;
928         unchecked {
929             if (value >= 10**64) {
930                 value /= 10**64;
931                 result += 64;
932             }
933             if (value >= 10**32) {
934                 value /= 10**32;
935                 result += 32;
936             }
937             if (value >= 10**16) {
938                 value /= 10**16;
939                 result += 16;
940             }
941             if (value >= 10**8) {
942                 value /= 10**8;
943                 result += 8;
944             }
945             if (value >= 10**4) {
946                 value /= 10**4;
947                 result += 4;
948             }
949             if (value >= 10**2) {
950                 value /= 10**2;
951                 result += 2;
952             }
953             if (value >= 10**1) {
954                 result += 1;
955             }
956         }
957         return result;
958     }
959 
960     /**
961      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
962      * Returns 0 if given 0.
963      */
964     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
965         unchecked {
966             uint256 result = log10(value);
967             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
968         }
969     }
970 
971     /**
972      * @dev Return the log in base 256, rounded down, of a positive value.
973      * Returns 0 if given 0.
974      *
975      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
976      */
977     function log256(uint256 value) internal pure returns (uint256) {
978         uint256 result = 0;
979         unchecked {
980             if (value >> 128 > 0) {
981                 value >>= 128;
982                 result += 16;
983             }
984             if (value >> 64 > 0) {
985                 value >>= 64;
986                 result += 8;
987             }
988             if (value >> 32 > 0) {
989                 value >>= 32;
990                 result += 4;
991             }
992             if (value >> 16 > 0) {
993                 value >>= 16;
994                 result += 2;
995             }
996             if (value >> 8 > 0) {
997                 result += 1;
998             }
999         }
1000         return result;
1001     }
1002 
1003     /**
1004      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1005      * Returns 0 if given 0.
1006      */
1007     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1008         unchecked {
1009             uint256 result = log256(value);
1010             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1011         }
1012     }
1013 }
1014 
1015 // File: @openzeppelin/contracts/utils/Strings.sol
1016 
1017 
1018 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 /**
1024  * @dev String operations.
1025  */
1026 library Strings {
1027     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1028     uint8 private constant _ADDRESS_LENGTH = 20;
1029 
1030     /**
1031      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1032      */
1033     function toString(uint256 value) internal pure returns (string memory) {
1034         unchecked {
1035             uint256 length = Math.log10(value) + 1;
1036             string memory buffer = new string(length);
1037             uint256 ptr;
1038             /// @solidity memory-safe-assembly
1039             assembly {
1040                 ptr := add(buffer, add(32, length))
1041             }
1042             while (true) {
1043                 ptr--;
1044                 /// @solidity memory-safe-assembly
1045                 assembly {
1046                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1047                 }
1048                 value /= 10;
1049                 if (value == 0) break;
1050             }
1051             return buffer;
1052         }
1053     }
1054 
1055     /**
1056      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1057      */
1058     function toHexString(uint256 value) internal pure returns (string memory) {
1059         unchecked {
1060             return toHexString(value, Math.log256(value) + 1);
1061         }
1062     }
1063 
1064     /**
1065      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1066      */
1067     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1068         bytes memory buffer = new bytes(2 * length + 2);
1069         buffer[0] = "0";
1070         buffer[1] = "x";
1071         for (uint256 i = 2 * length + 1; i > 1; --i) {
1072             buffer[i] = _SYMBOLS[value & 0xf];
1073             value >>= 4;
1074         }
1075         require(value == 0, "Strings: hex length insufficient");
1076         return string(buffer);
1077     }
1078 
1079     /**
1080      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1081      */
1082     function toHexString(address addr) internal pure returns (string memory) {
1083         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1084     }
1085 }
1086 
1087 // File: @openzeppelin/contracts/access/IAccessControl.sol
1088 
1089 
1090 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 /**
1095  * @dev External interface of AccessControl declared to support ERC165 detection.
1096  */
1097 interface IAccessControl {
1098     /**
1099      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1100      *
1101      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1102      * {RoleAdminChanged} not being emitted signaling this.
1103      *
1104      * _Available since v3.1._
1105      */
1106     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1107 
1108     /**
1109      * @dev Emitted when `account` is granted `role`.
1110      *
1111      * `sender` is the account that originated the contract call, an admin role
1112      * bearer except when using {AccessControl-_setupRole}.
1113      */
1114     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1115 
1116     /**
1117      * @dev Emitted when `account` is revoked `role`.
1118      *
1119      * `sender` is the account that originated the contract call:
1120      *   - if using `revokeRole`, it is the admin role bearer
1121      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1122      */
1123     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1124 
1125     /**
1126      * @dev Returns `true` if `account` has been granted `role`.
1127      */
1128     function hasRole(bytes32 role, address account) external view returns (bool);
1129 
1130     /**
1131      * @dev Returns the admin role that controls `role`. See {grantRole} and
1132      * {revokeRole}.
1133      *
1134      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1135      */
1136     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1137 
1138     /**
1139      * @dev Grants `role` to `account`.
1140      *
1141      * If `account` had not been already granted `role`, emits a {RoleGranted}
1142      * event.
1143      *
1144      * Requirements:
1145      *
1146      * - the caller must have ``role``'s admin role.
1147      */
1148     function grantRole(bytes32 role, address account) external;
1149 
1150     /**
1151      * @dev Revokes `role` from `account`.
1152      *
1153      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1154      *
1155      * Requirements:
1156      *
1157      * - the caller must have ``role``'s admin role.
1158      */
1159     function revokeRole(bytes32 role, address account) external;
1160 
1161     /**
1162      * @dev Revokes `role` from the calling account.
1163      *
1164      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1165      * purpose is to provide a mechanism for accounts to lose their privileges
1166      * if they are compromised (such as when a trusted device is misplaced).
1167      *
1168      * If the calling account had been granted `role`, emits a {RoleRevoked}
1169      * event.
1170      *
1171      * Requirements:
1172      *
1173      * - the caller must be `account`.
1174      */
1175     function renounceRole(bytes32 role, address account) external;
1176 }
1177 
1178 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
1179 
1180 
1181 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 
1186 /**
1187  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1188  */
1189 interface IAccessControlEnumerable is IAccessControl {
1190     /**
1191      * @dev Returns one of the accounts that have `role`. `index` must be a
1192      * value between 0 and {getRoleMemberCount}, non-inclusive.
1193      *
1194      * Role bearers are not sorted in any particular way, and their ordering may
1195      * change at any point.
1196      *
1197      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1198      * you perform all queries on the same block. See the following
1199      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1200      * for more information.
1201      */
1202     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1203 
1204     /**
1205      * @dev Returns the number of accounts that have `role`. Can be used
1206      * together with {getRoleMember} to enumerate all bearers of a role.
1207      */
1208     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1209 }
1210 
1211 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1212 
1213 
1214 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 /**
1219  * @dev Contract module that helps prevent reentrant calls to a function.
1220  *
1221  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1222  * available, which can be applied to functions to make sure there are no nested
1223  * (reentrant) calls to them.
1224  *
1225  * Note that because there is a single `nonReentrant` guard, functions marked as
1226  * `nonReentrant` may not call one another. This can be worked around by making
1227  * those functions `private`, and then adding `external` `nonReentrant` entry
1228  * points to them.
1229  *
1230  * TIP: If you would like to learn more about reentrancy and alternative ways
1231  * to protect against it, check out our blog post
1232  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1233  */
1234 abstract contract ReentrancyGuard {
1235     // Booleans are more expensive than uint256 or any type that takes up a full
1236     // word because each write operation emits an extra SLOAD to first read the
1237     // slot's contents, replace the bits taken up by the boolean, and then write
1238     // back. This is the compiler's defense against contract upgrades and
1239     // pointer aliasing, and it cannot be disabled.
1240 
1241     // The values being non-zero value makes deployment a bit more expensive,
1242     // but in exchange the refund on every call to nonReentrant will be lower in
1243     // amount. Since refunds are capped to a percentage of the total
1244     // transaction's gas, it is best to keep them low in cases like this one, to
1245     // increase the likelihood of the full refund coming into effect.
1246     uint256 private constant _NOT_ENTERED = 1;
1247     uint256 private constant _ENTERED = 2;
1248 
1249     uint256 private _status;
1250 
1251     constructor() {
1252         _status = _NOT_ENTERED;
1253     }
1254 
1255     /**
1256      * @dev Prevents a contract from calling itself, directly or indirectly.
1257      * Calling a `nonReentrant` function from another `nonReentrant`
1258      * function is not supported. It is possible to prevent this from happening
1259      * by making the `nonReentrant` function external, and making it call a
1260      * `private` function that does the actual work.
1261      */
1262     modifier nonReentrant() {
1263         _nonReentrantBefore();
1264         _;
1265         _nonReentrantAfter();
1266     }
1267 
1268     function _nonReentrantBefore() private {
1269         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1270         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1271 
1272         // Any calls to nonReentrant after this point will fail
1273         _status = _ENTERED;
1274     }
1275 
1276     function _nonReentrantAfter() private {
1277         // By storing the original value once again, a refund is triggered (see
1278         // https://eips.ethereum.org/EIPS/eip-2200)
1279         _status = _NOT_ENTERED;
1280     }
1281 }
1282 
1283 // File: @openzeppelin/contracts/utils/Context.sol
1284 
1285 
1286 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 /**
1291  * @dev Provides information about the current execution context, including the
1292  * sender of the transaction and its data. While these are generally available
1293  * via msg.sender and msg.data, they should not be accessed in such a direct
1294  * manner, since when dealing with meta-transactions the account sending and
1295  * paying for execution may not be the actual sender (as far as an application
1296  * is concerned).
1297  *
1298  * This contract is only required for intermediate, library-like contracts.
1299  */
1300 abstract contract Context {
1301     function _msgSender() internal view virtual returns (address) {
1302         return msg.sender;
1303     }
1304 
1305     function _msgData() internal view virtual returns (bytes calldata) {
1306         return msg.data;
1307     }
1308 }
1309 
1310 // File: @openzeppelin/contracts/access/AccessControl.sol
1311 
1312 
1313 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 
1318 
1319 
1320 
1321 /**
1322  * @dev Contract module that allows children to implement role-based access
1323  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1324  * members except through off-chain means by accessing the contract event logs. Some
1325  * applications may benefit from on-chain enumerability, for those cases see
1326  * {AccessControlEnumerable}.
1327  *
1328  * Roles are referred to by their `bytes32` identifier. These should be exposed
1329  * in the external API and be unique. The best way to achieve this is by
1330  * using `public constant` hash digests:
1331  *
1332  * ```
1333  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1334  * ```
1335  *
1336  * Roles can be used to represent a set of permissions. To restrict access to a
1337  * function call, use {hasRole}:
1338  *
1339  * ```
1340  * function foo() public {
1341  *     require(hasRole(MY_ROLE, msg.sender));
1342  *     ...
1343  * }
1344  * ```
1345  *
1346  * Roles can be granted and revoked dynamically via the {grantRole} and
1347  * {revokeRole} functions. Each role has an associated admin role, and only
1348  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1349  *
1350  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1351  * that only accounts with this role will be able to grant or revoke other
1352  * roles. More complex role relationships can be created by using
1353  * {_setRoleAdmin}.
1354  *
1355  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1356  * grant and revoke this role. Extra precautions should be taken to secure
1357  * accounts that have been granted it.
1358  */
1359 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1360     struct RoleData {
1361         mapping(address => bool) members;
1362         bytes32 adminRole;
1363     }
1364 
1365     mapping(bytes32 => RoleData) private _roles;
1366 
1367     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1368 
1369     /**
1370      * @dev Modifier that checks that an account has a specific role. Reverts
1371      * with a standardized message including the required role.
1372      *
1373      * The format of the revert reason is given by the following regular expression:
1374      *
1375      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1376      *
1377      * _Available since v4.1._
1378      */
1379     modifier onlyRole(bytes32 role) {
1380         _checkRole(role);
1381         _;
1382     }
1383 
1384     /**
1385      * @dev See {IERC165-supportsInterface}.
1386      */
1387     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1388         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1389     }
1390 
1391     /**
1392      * @dev Returns `true` if `account` has been granted `role`.
1393      */
1394     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1395         return _roles[role].members[account];
1396     }
1397 
1398     /**
1399      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1400      * Overriding this function changes the behavior of the {onlyRole} modifier.
1401      *
1402      * Format of the revert message is described in {_checkRole}.
1403      *
1404      * _Available since v4.6._
1405      */
1406     function _checkRole(bytes32 role) internal view virtual {
1407         _checkRole(role, _msgSender());
1408     }
1409 
1410     /**
1411      * @dev Revert with a standard message if `account` is missing `role`.
1412      *
1413      * The format of the revert reason is given by the following regular expression:
1414      *
1415      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1416      */
1417     function _checkRole(bytes32 role, address account) internal view virtual {
1418         if (!hasRole(role, account)) {
1419             revert(
1420                 string(
1421                     abi.encodePacked(
1422                         "AccessControl: account ",
1423                         Strings.toHexString(account),
1424                         " is missing role ",
1425                         Strings.toHexString(uint256(role), 32)
1426                     )
1427                 )
1428             );
1429         }
1430     }
1431 
1432     /**
1433      * @dev Returns the admin role that controls `role`. See {grantRole} and
1434      * {revokeRole}.
1435      *
1436      * To change a role's admin, use {_setRoleAdmin}.
1437      */
1438     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1439         return _roles[role].adminRole;
1440     }
1441 
1442     /**
1443      * @dev Grants `role` to `account`.
1444      *
1445      * If `account` had not been already granted `role`, emits a {RoleGranted}
1446      * event.
1447      *
1448      * Requirements:
1449      *
1450      * - the caller must have ``role``'s admin role.
1451      *
1452      * May emit a {RoleGranted} event.
1453      */
1454     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1455         _grantRole(role, account);
1456     }
1457 
1458     /**
1459      * @dev Revokes `role` from `account`.
1460      *
1461      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1462      *
1463      * Requirements:
1464      *
1465      * - the caller must have ``role``'s admin role.
1466      *
1467      * May emit a {RoleRevoked} event.
1468      */
1469     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1470         _revokeRole(role, account);
1471     }
1472 
1473     /**
1474      * @dev Revokes `role` from the calling account.
1475      *
1476      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1477      * purpose is to provide a mechanism for accounts to lose their privileges
1478      * if they are compromised (such as when a trusted device is misplaced).
1479      *
1480      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1481      * event.
1482      *
1483      * Requirements:
1484      *
1485      * - the caller must be `account`.
1486      *
1487      * May emit a {RoleRevoked} event.
1488      */
1489     function renounceRole(bytes32 role, address account) public virtual override {
1490         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1491 
1492         _revokeRole(role, account);
1493     }
1494 
1495     /**
1496      * @dev Grants `role` to `account`.
1497      *
1498      * If `account` had not been already granted `role`, emits a {RoleGranted}
1499      * event. Note that unlike {grantRole}, this function doesn't perform any
1500      * checks on the calling account.
1501      *
1502      * May emit a {RoleGranted} event.
1503      *
1504      * [WARNING]
1505      * ====
1506      * This function should only be called from the constructor when setting
1507      * up the initial roles for the system.
1508      *
1509      * Using this function in any other way is effectively circumventing the admin
1510      * system imposed by {AccessControl}.
1511      * ====
1512      *
1513      * NOTE: This function is deprecated in favor of {_grantRole}.
1514      */
1515     function _setupRole(bytes32 role, address account) internal virtual {
1516         _grantRole(role, account);
1517     }
1518 
1519     /**
1520      * @dev Sets `adminRole` as ``role``'s admin role.
1521      *
1522      * Emits a {RoleAdminChanged} event.
1523      */
1524     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1525         bytes32 previousAdminRole = getRoleAdmin(role);
1526         _roles[role].adminRole = adminRole;
1527         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1528     }
1529 
1530     /**
1531      * @dev Grants `role` to `account`.
1532      *
1533      * Internal function without access restriction.
1534      *
1535      * May emit a {RoleGranted} event.
1536      */
1537     function _grantRole(bytes32 role, address account) internal virtual {
1538         if (!hasRole(role, account)) {
1539             _roles[role].members[account] = true;
1540             emit RoleGranted(role, account, _msgSender());
1541         }
1542     }
1543 
1544     /**
1545      * @dev Revokes `role` from `account`.
1546      *
1547      * Internal function without access restriction.
1548      *
1549      * May emit a {RoleRevoked} event.
1550      */
1551     function _revokeRole(bytes32 role, address account) internal virtual {
1552         if (hasRole(role, account)) {
1553             _roles[role].members[account] = false;
1554             emit RoleRevoked(role, account, _msgSender());
1555         }
1556     }
1557 }
1558 
1559 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1560 
1561 
1562 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1563 
1564 pragma solidity ^0.8.0;
1565 
1566 
1567 
1568 
1569 /**
1570  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1571  */
1572 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1573     using EnumerableSet for EnumerableSet.AddressSet;
1574 
1575     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1576 
1577     /**
1578      * @dev See {IERC165-supportsInterface}.
1579      */
1580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1581         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1582     }
1583 
1584     /**
1585      * @dev Returns one of the accounts that have `role`. `index` must be a
1586      * value between 0 and {getRoleMemberCount}, non-inclusive.
1587      *
1588      * Role bearers are not sorted in any particular way, and their ordering may
1589      * change at any point.
1590      *
1591      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1592      * you perform all queries on the same block. See the following
1593      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1594      * for more information.
1595      */
1596     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1597         return _roleMembers[role].at(index);
1598     }
1599 
1600     /**
1601      * @dev Returns the number of accounts that have `role`. Can be used
1602      * together with {getRoleMember} to enumerate all bearers of a role.
1603      */
1604     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1605         return _roleMembers[role].length();
1606     }
1607 
1608     /**
1609      * @dev Overload {_grantRole} to track enumerable memberships
1610      */
1611     function _grantRole(bytes32 role, address account) internal virtual override {
1612         super._grantRole(role, account);
1613         _roleMembers[role].add(account);
1614     }
1615 
1616     /**
1617      * @dev Overload {_revokeRole} to track enumerable memberships
1618      */
1619     function _revokeRole(bytes32 role, address account) internal virtual override {
1620         super._revokeRole(role, account);
1621         _roleMembers[role].remove(account);
1622     }
1623 }
1624 
1625 // File: @openzeppelin/contracts/access/Ownable.sol
1626 
1627 
1628 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1629 
1630 pragma solidity ^0.8.0;
1631 
1632 
1633 /**
1634  * @dev Contract module which provides a basic access control mechanism, where
1635  * there is an account (an owner) that can be granted exclusive access to
1636  * specific functions.
1637  *
1638  * By default, the owner account will be the one that deploys the contract. This
1639  * can later be changed with {transferOwnership}.
1640  *
1641  * This module is used through inheritance. It will make available the modifier
1642  * `onlyOwner`, which can be applied to your functions to restrict their use to
1643  * the owner.
1644  */
1645 abstract contract Ownable is Context {
1646     address private _owner;
1647 
1648     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1649 
1650     /**
1651      * @dev Initializes the contract setting the deployer as the initial owner.
1652      */
1653     constructor() {
1654         _transferOwnership(_msgSender());
1655     }
1656 
1657     /**
1658      * @dev Throws if called by any account other than the owner.
1659      */
1660     modifier onlyOwner() {
1661         _checkOwner();
1662         _;
1663     }
1664 
1665     /**
1666      * @dev Returns the address of the current owner.
1667      */
1668     function owner() public view virtual returns (address) {
1669         return _owner;
1670     }
1671 
1672     /**
1673      * @dev Throws if the sender is not the owner.
1674      */
1675     function _checkOwner() internal view virtual {
1676         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1677     }
1678 
1679     /**
1680      * @dev Leaves the contract without owner. It will not be possible to call
1681      * `onlyOwner` functions anymore. Can only be called by the current owner.
1682      *
1683      * NOTE: Renouncing ownership will leave the contract without an owner,
1684      * thereby removing any functionality that is only available to the owner.
1685      */
1686     function renounceOwnership() public virtual onlyOwner {
1687         _transferOwnership(address(0));
1688     }
1689 
1690     /**
1691      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1692      * Can only be called by the current owner.
1693      */
1694     function transferOwnership(address newOwner) public virtual onlyOwner {
1695         require(newOwner != address(0), "Ownable: new owner is the zero address");
1696         _transferOwnership(newOwner);
1697     }
1698 
1699     /**
1700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1701      * Internal function without access restriction.
1702      */
1703     function _transferOwnership(address newOwner) internal virtual {
1704         address oldOwner = _owner;
1705         _owner = newOwner;
1706         emit OwnershipTransferred(oldOwner, newOwner);
1707     }
1708 }
1709 
1710 // File: erc721a/contracts/IERC721A.sol
1711 
1712 
1713 // ERC721A Contracts v4.2.3
1714 // Creator: Chiru Labs
1715 
1716 pragma solidity ^0.8.4;
1717 
1718 /**
1719  * @dev Interface of ERC721A.
1720  */
1721 interface IERC721A {
1722     /**
1723      * The caller must own the token or be an approved operator.
1724      */
1725     error ApprovalCallerNotOwnerNorApproved();
1726 
1727     /**
1728      * The token does not exist.
1729      */
1730     error ApprovalQueryForNonexistentToken();
1731 
1732     /**
1733      * Cannot query the balance for the zero address.
1734      */
1735     error BalanceQueryForZeroAddress();
1736 
1737     /**
1738      * Cannot mint to the zero address.
1739      */
1740     error MintToZeroAddress();
1741 
1742     /**
1743      * The quantity of tokens minted must be more than zero.
1744      */
1745     error MintZeroQuantity();
1746 
1747     /**
1748      * The token does not exist.
1749      */
1750     error OwnerQueryForNonexistentToken();
1751 
1752     /**
1753      * The caller must own the token or be an approved operator.
1754      */
1755     error TransferCallerNotOwnerNorApproved();
1756 
1757     /**
1758      * The token must be owned by `from`.
1759      */
1760     error TransferFromIncorrectOwner();
1761 
1762     /**
1763      * Cannot safely transfer to a contract that does not implement the
1764      * ERC721Receiver interface.
1765      */
1766     error TransferToNonERC721ReceiverImplementer();
1767 
1768     /**
1769      * Cannot transfer to the zero address.
1770      */
1771     error TransferToZeroAddress();
1772 
1773     /**
1774      * The token does not exist.
1775      */
1776     error URIQueryForNonexistentToken();
1777 
1778     /**
1779      * The `quantity` minted with ERC2309 exceeds the safety limit.
1780      */
1781     error MintERC2309QuantityExceedsLimit();
1782 
1783     /**
1784      * The `extraData` cannot be set on an unintialized ownership slot.
1785      */
1786     error OwnershipNotInitializedForExtraData();
1787 
1788     // =============================================================
1789     //                            STRUCTS
1790     // =============================================================
1791 
1792     struct TokenOwnership {
1793         // The address of the owner.
1794         address addr;
1795         // Stores the start time of ownership with minimal overhead for tokenomics.
1796         uint64 startTimestamp;
1797         // Whether the token has been burned.
1798         bool burned;
1799         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1800         uint24 extraData;
1801     }
1802 
1803     // =============================================================
1804     //                         TOKEN COUNTERS
1805     // =============================================================
1806 
1807     /**
1808      * @dev Returns the total number of tokens in existence.
1809      * Burned tokens will reduce the count.
1810      * To get the total number of tokens minted, please see {_totalMinted}.
1811      */
1812     function totalSupply() external view returns (uint256);
1813 
1814     // =============================================================
1815     //                            IERC165
1816     // =============================================================
1817 
1818     /**
1819      * @dev Returns true if this contract implements the interface defined by
1820      * `interfaceId`. See the corresponding
1821      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1822      * to learn more about how these ids are created.
1823      *
1824      * This function call must use less than 30000 gas.
1825      */
1826     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1827 
1828     // =============================================================
1829     //                            IERC721
1830     // =============================================================
1831 
1832     /**
1833      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1834      */
1835     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1836 
1837     /**
1838      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1839      */
1840     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1841 
1842     /**
1843      * @dev Emitted when `owner` enables or disables
1844      * (`approved`) `operator` to manage all of its assets.
1845      */
1846     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1847 
1848     /**
1849      * @dev Returns the number of tokens in `owner`'s account.
1850      */
1851     function balanceOf(address owner) external view returns (uint256 balance);
1852 
1853     /**
1854      * @dev Returns the owner of the `tokenId` token.
1855      *
1856      * Requirements:
1857      *
1858      * - `tokenId` must exist.
1859      */
1860     function ownerOf(uint256 tokenId) external view returns (address owner);
1861 
1862     /**
1863      * @dev Safely transfers `tokenId` token from `from` to `to`,
1864      * checking first that contract recipients are aware of the ERC721 protocol
1865      * to prevent tokens from being forever locked.
1866      *
1867      * Requirements:
1868      *
1869      * - `from` cannot be the zero address.
1870      * - `to` cannot be the zero address.
1871      * - `tokenId` token must exist and be owned by `from`.
1872      * - If the caller is not `from`, it must be have been allowed to move
1873      * this token by either {approve} or {setApprovalForAll}.
1874      * - If `to` refers to a smart contract, it must implement
1875      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1876      *
1877      * Emits a {Transfer} event.
1878      */
1879     function safeTransferFrom(
1880         address from,
1881         address to,
1882         uint256 tokenId,
1883         bytes calldata data
1884     ) external payable;
1885 
1886     /**
1887      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1888      */
1889     function safeTransferFrom(
1890         address from,
1891         address to,
1892         uint256 tokenId
1893     ) external payable;
1894 
1895     /**
1896      * @dev Transfers `tokenId` from `from` to `to`.
1897      *
1898      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1899      * whenever possible.
1900      *
1901      * Requirements:
1902      *
1903      * - `from` cannot be the zero address.
1904      * - `to` cannot be the zero address.
1905      * - `tokenId` token must be owned by `from`.
1906      * - If the caller is not `from`, it must be approved to move this token
1907      * by either {approve} or {setApprovalForAll}.
1908      *
1909      * Emits a {Transfer} event.
1910      */
1911     function transferFrom(
1912         address from,
1913         address to,
1914         uint256 tokenId
1915     ) external payable;
1916 
1917     /**
1918      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1919      * The approval is cleared when the token is transferred.
1920      *
1921      * Only a single account can be approved at a time, so approving the
1922      * zero address clears previous approvals.
1923      *
1924      * Requirements:
1925      *
1926      * - The caller must own the token or be an approved operator.
1927      * - `tokenId` must exist.
1928      *
1929      * Emits an {Approval} event.
1930      */
1931     function approve(address to, uint256 tokenId) external payable;
1932 
1933     /**
1934      * @dev Approve or remove `operator` as an operator for the caller.
1935      * Operators can call {transferFrom} or {safeTransferFrom}
1936      * for any token owned by the caller.
1937      *
1938      * Requirements:
1939      *
1940      * - The `operator` cannot be the caller.
1941      *
1942      * Emits an {ApprovalForAll} event.
1943      */
1944     function setApprovalForAll(address operator, bool _approved) external;
1945 
1946     /**
1947      * @dev Returns the account approved for `tokenId` token.
1948      *
1949      * Requirements:
1950      *
1951      * - `tokenId` must exist.
1952      */
1953     function getApproved(uint256 tokenId) external view returns (address operator);
1954 
1955     /**
1956      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1957      *
1958      * See {setApprovalForAll}.
1959      */
1960     function isApprovedForAll(address owner, address operator) external view returns (bool);
1961 
1962     // =============================================================
1963     //                        IERC721Metadata
1964     // =============================================================
1965 
1966     /**
1967      * @dev Returns the token collection name.
1968      */
1969     function name() external view returns (string memory);
1970 
1971     /**
1972      * @dev Returns the token collection symbol.
1973      */
1974     function symbol() external view returns (string memory);
1975 
1976     /**
1977      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1978      */
1979     function tokenURI(uint256 tokenId) external view returns (string memory);
1980 
1981     // =============================================================
1982     //                           IERC2309
1983     // =============================================================
1984 
1985     /**
1986      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1987      * (inclusive) is transferred from `from` to `to`, as defined in the
1988      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1989      *
1990      * See {_mintERC2309} for more details.
1991      */
1992     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1993 }
1994 
1995 // File: erc721a/contracts/ERC721A.sol
1996 
1997 
1998 // ERC721A Contracts v4.2.3
1999 // Creator: Chiru Labs
2000 
2001 pragma solidity ^0.8.4;
2002 
2003 
2004 /**
2005  * @dev Interface of ERC721 token receiver.
2006  */
2007 interface ERC721A__IERC721Receiver {
2008     function onERC721Received(
2009         address operator,
2010         address from,
2011         uint256 tokenId,
2012         bytes calldata data
2013     ) external returns (bytes4);
2014 }
2015 
2016 /**
2017  * @title ERC721A
2018  *
2019  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
2020  * Non-Fungible Token Standard, including the Metadata extension.
2021  * Optimized for lower gas during batch mints.
2022  *
2023  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
2024  * starting from `_startTokenId()`.
2025  *
2026  * Assumptions:
2027  *
2028  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2029  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
2030  */
2031 contract ERC721A is IERC721A {
2032     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
2033     struct TokenApprovalRef {
2034         address value;
2035     }
2036 
2037     // =============================================================
2038     //                           CONSTANTS
2039     // =============================================================
2040 
2041     // Mask of an entry in packed address data.
2042     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
2043 
2044     // The bit position of `numberMinted` in packed address data.
2045     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
2046 
2047     // The bit position of `numberBurned` in packed address data.
2048     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
2049 
2050     // The bit position of `aux` in packed address data.
2051     uint256 private constant _BITPOS_AUX = 192;
2052 
2053     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2054     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2055 
2056     // The bit position of `startTimestamp` in packed ownership.
2057     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
2058 
2059     // The bit mask of the `burned` bit in packed ownership.
2060     uint256 private constant _BITMASK_BURNED = 1 << 224;
2061 
2062     // The bit position of the `nextInitialized` bit in packed ownership.
2063     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
2064 
2065     // The bit mask of the `nextInitialized` bit in packed ownership.
2066     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
2067 
2068     // The bit position of `extraData` in packed ownership.
2069     uint256 private constant _BITPOS_EXTRA_DATA = 232;
2070 
2071     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2072     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2073 
2074     // The mask of the lower 160 bits for addresses.
2075     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
2076 
2077     // The maximum `quantity` that can be minted with {_mintERC2309}.
2078     // This limit is to prevent overflows on the address data entries.
2079     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
2080     // is required to cause an overflow, which is unrealistic.
2081     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2082 
2083     // The `Transfer` event signature is given by:
2084     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
2085     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
2086         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
2087 
2088     // =============================================================
2089     //                            STORAGE
2090     // =============================================================
2091 
2092     // The next token ID to be minted.
2093     uint256 private _currentIndex;
2094 
2095     // The number of tokens burned.
2096     uint256 private _burnCounter;
2097 
2098     // Token name
2099     string private _name;
2100 
2101     // Token symbol
2102     string private _symbol;
2103 
2104     // Mapping from token ID to ownership details
2105     // An empty struct value does not necessarily mean the token is unowned.
2106     // See {_packedOwnershipOf} implementation for details.
2107     //
2108     // Bits Layout:
2109     // - [0..159]   `addr`
2110     // - [160..223] `startTimestamp`
2111     // - [224]      `burned`
2112     // - [225]      `nextInitialized`
2113     // - [232..255] `extraData`
2114     mapping(uint256 => uint256) private _packedOwnerships;
2115 
2116     // Mapping owner address to address data.
2117     //
2118     // Bits Layout:
2119     // - [0..63]    `balance`
2120     // - [64..127]  `numberMinted`
2121     // - [128..191] `numberBurned`
2122     // - [192..255] `aux`
2123     mapping(address => uint256) private _packedAddressData;
2124 
2125     // Mapping from token ID to approved address.
2126     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
2127 
2128     // Mapping from owner to operator approvals
2129     mapping(address => mapping(address => bool)) private _operatorApprovals;
2130 
2131     // =============================================================
2132     //                          CONSTRUCTOR
2133     // =============================================================
2134 
2135     constructor(string memory name_, string memory symbol_) {
2136         _name = name_;
2137         _symbol = symbol_;
2138         _currentIndex = _startTokenId();
2139     }
2140 
2141     // =============================================================
2142     //                   TOKEN COUNTING OPERATIONS
2143     // =============================================================
2144 
2145     /**
2146      * @dev Returns the starting token ID.
2147      * To change the starting token ID, please override this function.
2148      */
2149     function _startTokenId() internal view virtual returns (uint256) {
2150         return 0;
2151     }
2152 
2153     /**
2154      * @dev Returns the next token ID to be minted.
2155      */
2156     function _nextTokenId() internal view virtual returns (uint256) {
2157         return _currentIndex;
2158     }
2159 
2160     /**
2161      * @dev Returns the total number of tokens in existence.
2162      * Burned tokens will reduce the count.
2163      * To get the total number of tokens minted, please see {_totalMinted}.
2164      */
2165     function totalSupply() public view virtual override returns (uint256) {
2166         // Counter underflow is impossible as _burnCounter cannot be incremented
2167         // more than `_currentIndex - _startTokenId()` times.
2168         unchecked {
2169             return _currentIndex - _burnCounter - _startTokenId();
2170         }
2171     }
2172 
2173     /**
2174      * @dev Returns the total amount of tokens minted in the contract.
2175      */
2176     function _totalMinted() internal view virtual returns (uint256) {
2177         // Counter underflow is impossible as `_currentIndex` does not decrement,
2178         // and it is initialized to `_startTokenId()`.
2179         unchecked {
2180             return _currentIndex - _startTokenId();
2181         }
2182     }
2183 
2184     /**
2185      * @dev Returns the total number of tokens burned.
2186      */
2187     function _totalBurned() internal view virtual returns (uint256) {
2188         return _burnCounter;
2189     }
2190 
2191     // =============================================================
2192     //                    ADDRESS DATA OPERATIONS
2193     // =============================================================
2194 
2195     /**
2196      * @dev Returns the number of tokens in `owner`'s account.
2197      */
2198     function balanceOf(address owner) public view virtual override returns (uint256) {
2199         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2200         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2201     }
2202 
2203     /**
2204      * Returns the number of tokens minted by `owner`.
2205      */
2206     function _numberMinted(address owner) internal view returns (uint256) {
2207         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2208     }
2209 
2210     /**
2211      * Returns the number of tokens burned by or on behalf of `owner`.
2212      */
2213     function _numberBurned(address owner) internal view returns (uint256) {
2214         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2215     }
2216 
2217     /**
2218      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2219      */
2220     function _getAux(address owner) internal view returns (uint64) {
2221         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2222     }
2223 
2224     /**
2225      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2226      * If there are multiple variables, please pack them into a uint64.
2227      */
2228     function _setAux(address owner, uint64 aux) internal virtual {
2229         uint256 packed = _packedAddressData[owner];
2230         uint256 auxCasted;
2231         // Cast `aux` with assembly to avoid redundant masking.
2232         assembly {
2233             auxCasted := aux
2234         }
2235         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2236         _packedAddressData[owner] = packed;
2237     }
2238 
2239     // =============================================================
2240     //                            IERC165
2241     // =============================================================
2242 
2243     /**
2244      * @dev Returns true if this contract implements the interface defined by
2245      * `interfaceId`. See the corresponding
2246      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2247      * to learn more about how these ids are created.
2248      *
2249      * This function call must use less than 30000 gas.
2250      */
2251     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2252         // The interface IDs are constants representing the first 4 bytes
2253         // of the XOR of all function selectors in the interface.
2254         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2255         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2256         return
2257             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2258             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2259             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2260     }
2261 
2262     // =============================================================
2263     //                        IERC721Metadata
2264     // =============================================================
2265 
2266     /**
2267      * @dev Returns the token collection name.
2268      */
2269     function name() public view virtual override returns (string memory) {
2270         return _name;
2271     }
2272 
2273     /**
2274      * @dev Returns the token collection symbol.
2275      */
2276     function symbol() public view virtual override returns (string memory) {
2277         return _symbol;
2278     }
2279 
2280     /**
2281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2282      */
2283     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2284         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2285 
2286         string memory baseURI = _baseURI();
2287         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2288     }
2289 
2290     /**
2291      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2292      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2293      * by default, it can be overridden in child contracts.
2294      */
2295     function _baseURI() internal view virtual returns (string memory) {
2296         return '';
2297     }
2298 
2299     // =============================================================
2300     //                     OWNERSHIPS OPERATIONS
2301     // =============================================================
2302 
2303     /**
2304      * @dev Returns the owner of the `tokenId` token.
2305      *
2306      * Requirements:
2307      *
2308      * - `tokenId` must exist.
2309      */
2310     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2311         return address(uint160(_packedOwnershipOf(tokenId)));
2312     }
2313 
2314     /**
2315      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2316      * It gradually moves to O(1) as tokens get transferred around over time.
2317      */
2318     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2319         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2320     }
2321 
2322     /**
2323      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2324      */
2325     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2326         return _unpackedOwnership(_packedOwnerships[index]);
2327     }
2328 
2329     /**
2330      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2331      */
2332     function _initializeOwnershipAt(uint256 index) internal virtual {
2333         if (_packedOwnerships[index] == 0) {
2334             _packedOwnerships[index] = _packedOwnershipOf(index);
2335         }
2336     }
2337 
2338     /**
2339      * Returns the packed ownership data of `tokenId`.
2340      */
2341     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2342         uint256 curr = tokenId;
2343 
2344         unchecked {
2345             if (_startTokenId() <= curr)
2346                 if (curr < _currentIndex) {
2347                     uint256 packed = _packedOwnerships[curr];
2348                     // If not burned.
2349                     if (packed & _BITMASK_BURNED == 0) {
2350                         // Invariant:
2351                         // There will always be an initialized ownership slot
2352                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2353                         // before an unintialized ownership slot
2354                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2355                         // Hence, `curr` will not underflow.
2356                         //
2357                         // We can directly compare the packed value.
2358                         // If the address is zero, packed will be zero.
2359                         while (packed == 0) {
2360                             packed = _packedOwnerships[--curr];
2361                         }
2362                         return packed;
2363                     }
2364                 }
2365         }
2366         revert OwnerQueryForNonexistentToken();
2367     }
2368 
2369     /**
2370      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2371      */
2372     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2373         ownership.addr = address(uint160(packed));
2374         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2375         ownership.burned = packed & _BITMASK_BURNED != 0;
2376         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2377     }
2378 
2379     /**
2380      * @dev Packs ownership data into a single uint256.
2381      */
2382     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2383         assembly {
2384             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2385             owner := and(owner, _BITMASK_ADDRESS)
2386             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2387             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2388         }
2389     }
2390 
2391     /**
2392      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2393      */
2394     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2395         // For branchless setting of the `nextInitialized` flag.
2396         assembly {
2397             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2398             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2399         }
2400     }
2401 
2402     // =============================================================
2403     //                      APPROVAL OPERATIONS
2404     // =============================================================
2405 
2406     /**
2407      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2408      * The approval is cleared when the token is transferred.
2409      *
2410      * Only a single account can be approved at a time, so approving the
2411      * zero address clears previous approvals.
2412      *
2413      * Requirements:
2414      *
2415      * - The caller must own the token or be an approved operator.
2416      * - `tokenId` must exist.
2417      *
2418      * Emits an {Approval} event.
2419      */
2420     function approve(address to, uint256 tokenId) public payable virtual override {
2421         address owner = ownerOf(tokenId);
2422 
2423         if (_msgSenderERC721A() != owner)
2424             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2425                 revert ApprovalCallerNotOwnerNorApproved();
2426             }
2427 
2428         _tokenApprovals[tokenId].value = to;
2429         emit Approval(owner, to, tokenId);
2430     }
2431 
2432     /**
2433      * @dev Returns the account approved for `tokenId` token.
2434      *
2435      * Requirements:
2436      *
2437      * - `tokenId` must exist.
2438      */
2439     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2440         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2441 
2442         return _tokenApprovals[tokenId].value;
2443     }
2444 
2445     /**
2446      * @dev Approve or remove `operator` as an operator for the caller.
2447      * Operators can call {transferFrom} or {safeTransferFrom}
2448      * for any token owned by the caller.
2449      *
2450      * Requirements:
2451      *
2452      * - The `operator` cannot be the caller.
2453      *
2454      * Emits an {ApprovalForAll} event.
2455      */
2456     function setApprovalForAll(address operator, bool approved) public virtual override {
2457         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2458         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2459     }
2460 
2461     /**
2462      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2463      *
2464      * See {setApprovalForAll}.
2465      */
2466     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2467         return _operatorApprovals[owner][operator];
2468     }
2469 
2470     /**
2471      * @dev Returns whether `tokenId` exists.
2472      *
2473      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2474      *
2475      * Tokens start existing when they are minted. See {_mint}.
2476      */
2477     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2478         return
2479             _startTokenId() <= tokenId &&
2480             tokenId < _currentIndex && // If within bounds,
2481             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2482     }
2483 
2484     /**
2485      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2486      */
2487     function _isSenderApprovedOrOwner(
2488         address approvedAddress,
2489         address owner,
2490         address msgSender
2491     ) private pure returns (bool result) {
2492         assembly {
2493             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2494             owner := and(owner, _BITMASK_ADDRESS)
2495             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2496             msgSender := and(msgSender, _BITMASK_ADDRESS)
2497             // `msgSender == owner || msgSender == approvedAddress`.
2498             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2499         }
2500     }
2501 
2502     /**
2503      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2504      */
2505     function _getApprovedSlotAndAddress(uint256 tokenId)
2506         private
2507         view
2508         returns (uint256 approvedAddressSlot, address approvedAddress)
2509     {
2510         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2511         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2512         assembly {
2513             approvedAddressSlot := tokenApproval.slot
2514             approvedAddress := sload(approvedAddressSlot)
2515         }
2516     }
2517 
2518     // =============================================================
2519     //                      TRANSFER OPERATIONS
2520     // =============================================================
2521 
2522     /**
2523      * @dev Transfers `tokenId` from `from` to `to`.
2524      *
2525      * Requirements:
2526      *
2527      * - `from` cannot be the zero address.
2528      * - `to` cannot be the zero address.
2529      * - `tokenId` token must be owned by `from`.
2530      * - If the caller is not `from`, it must be approved to move this token
2531      * by either {approve} or {setApprovalForAll}.
2532      *
2533      * Emits a {Transfer} event.
2534      */
2535     function transferFrom(
2536         address from,
2537         address to,
2538         uint256 tokenId
2539     ) public payable virtual override {
2540         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2541 
2542         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2543 
2544         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2545 
2546         // The nested ifs save around 20+ gas over a compound boolean condition.
2547         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2548             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2549 
2550         if (to == address(0)) revert TransferToZeroAddress();
2551 
2552         _beforeTokenTransfers(from, to, tokenId, 1);
2553 
2554         // Clear approvals from the previous owner.
2555         assembly {
2556             if approvedAddress {
2557                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2558                 sstore(approvedAddressSlot, 0)
2559             }
2560         }
2561 
2562         // Underflow of the sender's balance is impossible because we check for
2563         // ownership above and the recipient's balance can't realistically overflow.
2564         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2565         unchecked {
2566             // We can directly increment and decrement the balances.
2567             --_packedAddressData[from]; // Updates: `balance -= 1`.
2568             ++_packedAddressData[to]; // Updates: `balance += 1`.
2569 
2570             // Updates:
2571             // - `address` to the next owner.
2572             // - `startTimestamp` to the timestamp of transfering.
2573             // - `burned` to `false`.
2574             // - `nextInitialized` to `true`.
2575             _packedOwnerships[tokenId] = _packOwnershipData(
2576                 to,
2577                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2578             );
2579 
2580             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2581             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2582                 uint256 nextTokenId = tokenId + 1;
2583                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2584                 if (_packedOwnerships[nextTokenId] == 0) {
2585                     // If the next slot is within bounds.
2586                     if (nextTokenId != _currentIndex) {
2587                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2588                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2589                     }
2590                 }
2591             }
2592         }
2593 
2594         emit Transfer(from, to, tokenId);
2595         _afterTokenTransfers(from, to, tokenId, 1);
2596     }
2597 
2598     /**
2599      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2600      */
2601     function safeTransferFrom(
2602         address from,
2603         address to,
2604         uint256 tokenId
2605     ) public payable virtual override {
2606         safeTransferFrom(from, to, tokenId, '');
2607     }
2608 
2609     /**
2610      * @dev Safely transfers `tokenId` token from `from` to `to`.
2611      *
2612      * Requirements:
2613      *
2614      * - `from` cannot be the zero address.
2615      * - `to` cannot be the zero address.
2616      * - `tokenId` token must exist and be owned by `from`.
2617      * - If the caller is not `from`, it must be approved to move this token
2618      * by either {approve} or {setApprovalForAll}.
2619      * - If `to` refers to a smart contract, it must implement
2620      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2621      *
2622      * Emits a {Transfer} event.
2623      */
2624     function safeTransferFrom(
2625         address from,
2626         address to,
2627         uint256 tokenId,
2628         bytes memory _data
2629     ) public payable virtual override {
2630         transferFrom(from, to, tokenId);
2631         if (to.code.length != 0)
2632             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2633                 revert TransferToNonERC721ReceiverImplementer();
2634             }
2635     }
2636 
2637     /**
2638      * @dev Hook that is called before a set of serially-ordered token IDs
2639      * are about to be transferred. This includes minting.
2640      * And also called before burning one token.
2641      *
2642      * `startTokenId` - the first token ID to be transferred.
2643      * `quantity` - the amount to be transferred.
2644      *
2645      * Calling conditions:
2646      *
2647      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2648      * transferred to `to`.
2649      * - When `from` is zero, `tokenId` will be minted for `to`.
2650      * - When `to` is zero, `tokenId` will be burned by `from`.
2651      * - `from` and `to` are never both zero.
2652      */
2653     function _beforeTokenTransfers(
2654         address from,
2655         address to,
2656         uint256 startTokenId,
2657         uint256 quantity
2658     ) internal virtual {}
2659 
2660     /**
2661      * @dev Hook that is called after a set of serially-ordered token IDs
2662      * have been transferred. This includes minting.
2663      * And also called after one token has been burned.
2664      *
2665      * `startTokenId` - the first token ID to be transferred.
2666      * `quantity` - the amount to be transferred.
2667      *
2668      * Calling conditions:
2669      *
2670      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2671      * transferred to `to`.
2672      * - When `from` is zero, `tokenId` has been minted for `to`.
2673      * - When `to` is zero, `tokenId` has been burned by `from`.
2674      * - `from` and `to` are never both zero.
2675      */
2676     function _afterTokenTransfers(
2677         address from,
2678         address to,
2679         uint256 startTokenId,
2680         uint256 quantity
2681     ) internal virtual {}
2682 
2683     /**
2684      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2685      *
2686      * `from` - Previous owner of the given token ID.
2687      * `to` - Target address that will receive the token.
2688      * `tokenId` - Token ID to be transferred.
2689      * `_data` - Optional data to send along with the call.
2690      *
2691      * Returns whether the call correctly returned the expected magic value.
2692      */
2693     function _checkContractOnERC721Received(
2694         address from,
2695         address to,
2696         uint256 tokenId,
2697         bytes memory _data
2698     ) private returns (bool) {
2699         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2700             bytes4 retval
2701         ) {
2702             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2703         } catch (bytes memory reason) {
2704             if (reason.length == 0) {
2705                 revert TransferToNonERC721ReceiverImplementer();
2706             } else {
2707                 assembly {
2708                     revert(add(32, reason), mload(reason))
2709                 }
2710             }
2711         }
2712     }
2713 
2714     // =============================================================
2715     //                        MINT OPERATIONS
2716     // =============================================================
2717 
2718     /**
2719      * @dev Mints `quantity` tokens and transfers them to `to`.
2720      *
2721      * Requirements:
2722      *
2723      * - `to` cannot be the zero address.
2724      * - `quantity` must be greater than 0.
2725      *
2726      * Emits a {Transfer} event for each mint.
2727      */
2728     function _mint(address to, uint256 quantity) internal virtual {
2729         uint256 startTokenId = _currentIndex;
2730         if (quantity == 0) revert MintZeroQuantity();
2731 
2732         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2733 
2734         // Overflows are incredibly unrealistic.
2735         // `balance` and `numberMinted` have a maximum limit of 2**64.
2736         // `tokenId` has a maximum limit of 2**256.
2737         unchecked {
2738             // Updates:
2739             // - `balance += quantity`.
2740             // - `numberMinted += quantity`.
2741             //
2742             // We can directly add to the `balance` and `numberMinted`.
2743             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2744 
2745             // Updates:
2746             // - `address` to the owner.
2747             // - `startTimestamp` to the timestamp of minting.
2748             // - `burned` to `false`.
2749             // - `nextInitialized` to `quantity == 1`.
2750             _packedOwnerships[startTokenId] = _packOwnershipData(
2751                 to,
2752                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2753             );
2754 
2755             uint256 toMasked;
2756             uint256 end = startTokenId + quantity;
2757 
2758             // Use assembly to loop and emit the `Transfer` event for gas savings.
2759             // The duplicated `log4` removes an extra check and reduces stack juggling.
2760             // The assembly, together with the surrounding Solidity code, have been
2761             // delicately arranged to nudge the compiler into producing optimized opcodes.
2762             assembly {
2763                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2764                 toMasked := and(to, _BITMASK_ADDRESS)
2765                 // Emit the `Transfer` event.
2766                 log4(
2767                     0, // Start of data (0, since no data).
2768                     0, // End of data (0, since no data).
2769                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2770                     0, // `address(0)`.
2771                     toMasked, // `to`.
2772                     startTokenId // `tokenId`.
2773                 )
2774 
2775                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2776                 // that overflows uint256 will make the loop run out of gas.
2777                 // The compiler will optimize the `iszero` away for performance.
2778                 for {
2779                     let tokenId := add(startTokenId, 1)
2780                 } iszero(eq(tokenId, end)) {
2781                     tokenId := add(tokenId, 1)
2782                 } {
2783                     // Emit the `Transfer` event. Similar to above.
2784                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2785                 }
2786             }
2787             if (toMasked == 0) revert MintToZeroAddress();
2788 
2789             _currentIndex = end;
2790         }
2791         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2792     }
2793 
2794     /**
2795      * @dev Mints `quantity` tokens and transfers them to `to`.
2796      *
2797      * This function is intended for efficient minting only during contract creation.
2798      *
2799      * It emits only one {ConsecutiveTransfer} as defined in
2800      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2801      * instead of a sequence of {Transfer} event(s).
2802      *
2803      * Calling this function outside of contract creation WILL make your contract
2804      * non-compliant with the ERC721 standard.
2805      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2806      * {ConsecutiveTransfer} event is only permissible during contract creation.
2807      *
2808      * Requirements:
2809      *
2810      * - `to` cannot be the zero address.
2811      * - `quantity` must be greater than 0.
2812      *
2813      * Emits a {ConsecutiveTransfer} event.
2814      */
2815     function _mintERC2309(address to, uint256 quantity) internal virtual {
2816         uint256 startTokenId = _currentIndex;
2817         if (to == address(0)) revert MintToZeroAddress();
2818         if (quantity == 0) revert MintZeroQuantity();
2819         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2820 
2821         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2822 
2823         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2824         unchecked {
2825             // Updates:
2826             // - `balance += quantity`.
2827             // - `numberMinted += quantity`.
2828             //
2829             // We can directly add to the `balance` and `numberMinted`.
2830             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2831 
2832             // Updates:
2833             // - `address` to the owner.
2834             // - `startTimestamp` to the timestamp of minting.
2835             // - `burned` to `false`.
2836             // - `nextInitialized` to `quantity == 1`.
2837             _packedOwnerships[startTokenId] = _packOwnershipData(
2838                 to,
2839                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2840             );
2841 
2842             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2843 
2844             _currentIndex = startTokenId + quantity;
2845         }
2846         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2847     }
2848 
2849     /**
2850      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2851      *
2852      * Requirements:
2853      *
2854      * - If `to` refers to a smart contract, it must implement
2855      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2856      * - `quantity` must be greater than 0.
2857      *
2858      * See {_mint}.
2859      *
2860      * Emits a {Transfer} event for each mint.
2861      */
2862     function _safeMint(
2863         address to,
2864         uint256 quantity,
2865         bytes memory _data
2866     ) internal virtual {
2867         _mint(to, quantity);
2868 
2869         unchecked {
2870             if (to.code.length != 0) {
2871                 uint256 end = _currentIndex;
2872                 uint256 index = end - quantity;
2873                 do {
2874                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2875                         revert TransferToNonERC721ReceiverImplementer();
2876                     }
2877                 } while (index < end);
2878                 // Reentrancy protection.
2879                 if (_currentIndex != end) revert();
2880             }
2881         }
2882     }
2883 
2884     /**
2885      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2886      */
2887     function _safeMint(address to, uint256 quantity) internal virtual {
2888         _safeMint(to, quantity, '');
2889     }
2890 
2891     // =============================================================
2892     //                        BURN OPERATIONS
2893     // =============================================================
2894 
2895     /**
2896      * @dev Equivalent to `_burn(tokenId, false)`.
2897      */
2898     function _burn(uint256 tokenId) internal virtual {
2899         _burn(tokenId, false);
2900     }
2901 
2902     /**
2903      * @dev Destroys `tokenId`.
2904      * The approval is cleared when the token is burned.
2905      *
2906      * Requirements:
2907      *
2908      * - `tokenId` must exist.
2909      *
2910      * Emits a {Transfer} event.
2911      */
2912     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2913         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2914 
2915         address from = address(uint160(prevOwnershipPacked));
2916 
2917         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2918 
2919         if (approvalCheck) {
2920             // The nested ifs save around 20+ gas over a compound boolean condition.
2921             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2922                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2923         }
2924 
2925         _beforeTokenTransfers(from, address(0), tokenId, 1);
2926 
2927         // Clear approvals from the previous owner.
2928         assembly {
2929             if approvedAddress {
2930                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2931                 sstore(approvedAddressSlot, 0)
2932             }
2933         }
2934 
2935         // Underflow of the sender's balance is impossible because we check for
2936         // ownership above and the recipient's balance can't realistically overflow.
2937         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2938         unchecked {
2939             // Updates:
2940             // - `balance -= 1`.
2941             // - `numberBurned += 1`.
2942             //
2943             // We can directly decrement the balance, and increment the number burned.
2944             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2945             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2946 
2947             // Updates:
2948             // - `address` to the last owner.
2949             // - `startTimestamp` to the timestamp of burning.
2950             // - `burned` to `true`.
2951             // - `nextInitialized` to `true`.
2952             _packedOwnerships[tokenId] = _packOwnershipData(
2953                 from,
2954                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2955             );
2956 
2957             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2958             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2959                 uint256 nextTokenId = tokenId + 1;
2960                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2961                 if (_packedOwnerships[nextTokenId] == 0) {
2962                     // If the next slot is within bounds.
2963                     if (nextTokenId != _currentIndex) {
2964                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2965                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2966                     }
2967                 }
2968             }
2969         }
2970 
2971         emit Transfer(from, address(0), tokenId);
2972         _afterTokenTransfers(from, address(0), tokenId, 1);
2973 
2974         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2975         unchecked {
2976             _burnCounter++;
2977         }
2978     }
2979 
2980     // =============================================================
2981     //                     EXTRA DATA OPERATIONS
2982     // =============================================================
2983 
2984     /**
2985      * @dev Directly sets the extra data for the ownership data `index`.
2986      */
2987     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2988         uint256 packed = _packedOwnerships[index];
2989         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2990         uint256 extraDataCasted;
2991         // Cast `extraData` with assembly to avoid redundant masking.
2992         assembly {
2993             extraDataCasted := extraData
2994         }
2995         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2996         _packedOwnerships[index] = packed;
2997     }
2998 
2999     /**
3000      * @dev Called during each token transfer to set the 24bit `extraData` field.
3001      * Intended to be overridden by the cosumer contract.
3002      *
3003      * `previousExtraData` - the value of `extraData` before transfer.
3004      *
3005      * Calling conditions:
3006      *
3007      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3008      * transferred to `to`.
3009      * - When `from` is zero, `tokenId` will be minted for `to`.
3010      * - When `to` is zero, `tokenId` will be burned by `from`.
3011      * - `from` and `to` are never both zero.
3012      */
3013     function _extraData(
3014         address from,
3015         address to,
3016         uint24 previousExtraData
3017     ) internal view virtual returns (uint24) {}
3018 
3019     /**
3020      * @dev Returns the next extra data for the packed ownership data.
3021      * The returned result is shifted into position.
3022      */
3023     function _nextExtraData(
3024         address from,
3025         address to,
3026         uint256 prevOwnershipPacked
3027     ) private view returns (uint256) {
3028         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
3029         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
3030     }
3031 
3032     // =============================================================
3033     //                       OTHER OPERATIONS
3034     // =============================================================
3035 
3036     /**
3037      * @dev Returns the message sender (defaults to `msg.sender`).
3038      *
3039      * If you are writing GSN compatible contracts, you need to override this function.
3040      */
3041     function _msgSenderERC721A() internal view virtual returns (address) {
3042         return msg.sender;
3043     }
3044 
3045     /**
3046      * @dev Converts a uint256 to its ASCII string decimal representation.
3047      */
3048     function _toString(uint256 value) internal pure virtual returns (string memory str) {
3049         assembly {
3050             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
3051             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
3052             // We will need 1 word for the trailing zeros padding, 1 word for the length,
3053             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
3054             let m := add(mload(0x40), 0xa0)
3055             // Update the free memory pointer to allocate.
3056             mstore(0x40, m)
3057             // Assign the `str` to the end.
3058             str := sub(m, 0x20)
3059             // Zeroize the slot after the string.
3060             mstore(str, 0)
3061 
3062             // Cache the end of the memory to calculate the length later.
3063             let end := str
3064 
3065             // We write the string from rightmost digit to leftmost digit.
3066             // The following is essentially a do-while loop that also handles the zero case.
3067             // prettier-ignore
3068             for { let temp := value } 1 {} {
3069                 str := sub(str, 1)
3070                 // Write the character to the pointer.
3071                 // The ASCII index of the '0' character is 48.
3072                 mstore8(str, add(48, mod(temp, 10)))
3073                 // Keep dividing `temp` until zero.
3074                 temp := div(temp, 10)
3075                 // prettier-ignore
3076                 if iszero(temp) { break }
3077             }
3078 
3079             let length := sub(end, str)
3080             // Move the pointer 32 bytes leftwards to make room for the length.
3081             str := sub(str, 0x20)
3082             // Store the length.
3083             mstore(str, length)
3084         }
3085     }
3086 }
3087 
3088 // File: contracts/Owls.sol
3089 
3090 
3091 pragma solidity ^0.8.9;
3092 
3093 
3094 
3095 
3096 
3097 
3098 
3099 
3100 contract Owls is ERC721A, Ownable, ReentrancyGuard, AccessControlEnumerable {
3101     
3102     uint256 public maxTotalSupply = 5555;
3103     uint256 public privateMintPrice = 0.008 ether;
3104     uint256 public publicMintPrice = 0.009 ether;
3105     uint8 private maxTokenPrivate = 2;
3106     
3107     string public baseExtension = ".json";
3108     string public notRevealedUri;
3109     
3110     bool public revealed = false;
3111     enum SaleState{ CLOSED, WL, PUBLIC }
3112     SaleState public saleState = SaleState.CLOSED;
3113 
3114 
3115 
3116     bytes32 private merkleRoot;
3117 
3118     mapping(address => uint256) public mintedPrivatePerAddress;
3119     mapping(address => uint256) public mintedPublicPerAddress;
3120 
3121     string _baseTokenURI;
3122 
3123     constructor() ERC721A("OwlsOfBushido", "OWLS") {
3124         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
3125     }
3126 
3127     function _startTokenId() internal view virtual override returns (uint256) {
3128         return 1;
3129     }
3130 
3131     function privateMint(uint256 amount, bytes32[] calldata proof) public payable {
3132         require (saleState == SaleState.WL, "Sale is not opened");
3133         require(mintedPrivatePerAddress[msg.sender] + amount <= maxTokenPrivate, "You can mint a maximum of 2 NFTs");
3134         require(totalSupply() + amount <= maxTotalSupply, "Max supply reached");
3135         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not in the valid whitelist");
3136         require(amount * privateMintPrice <= msg.value, "Provided not enough Ether for purchase");
3137         mintedPrivatePerAddress[msg.sender] += amount;
3138         _safeMint(_msgSender(), amount);
3139     }
3140 
3141     function publicSale(uint256 amount) public payable {
3142         require (saleState == SaleState.PUBLIC, "Sale state should be public");
3143         require(mintedPublicPerAddress[msg.sender] + amount <= maxTokenPrivate, "You can mint a maximum of 2 NFTs");
3144         require(totalSupply() + amount <= maxTotalSupply, "Max supply reached");
3145         require(amount * publicMintPrice <= msg.value, "Provided not enough Ether for purchase");
3146         mintedPublicPerAddress[msg.sender] += amount;
3147         _safeMint(_msgSender(), amount);
3148     }
3149 
3150     function withdraw() public onlyOwner {
3151         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot withdraw");
3152         payable(msg.sender).transfer(address(this).balance);
3153     }
3154 
3155     function setSaleState(SaleState newState) public {
3156         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot alter sale state");
3157         saleState = newState;
3158     }
3159 
3160     function _baseURI() internal view virtual override returns (string memory) {
3161         return _baseTokenURI;
3162     }
3163 
3164     function setMerkleRoot(bytes32 _merkleRoot) public {
3165         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set merkle root");
3166         merkleRoot = _merkleRoot;
3167     }
3168 
3169     function setBaseURI(string memory baseURI) public onlyOwner {
3170         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set Base URI");
3171         _baseTokenURI = baseURI;
3172     }
3173 
3174     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, AccessControlEnumerable) returns (bool) {
3175         return super.supportsInterface(interfaceId);
3176     }
3177 
3178     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
3179         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set Base Extension");
3180         baseExtension = _newBaseExtension;
3181     }
3182 
3183     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
3184         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set Not Reveal URI");
3185         notRevealedUri = _notRevealedURI;
3186     }
3187 
3188     function reveal() public onlyOwner {
3189         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot reveal");
3190         revealed = true;
3191     }
3192 
3193     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3194         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
3195         if(revealed == false) {
3196             return notRevealedUri;
3197         }
3198 
3199         string memory currentBaseURI = _baseURI();
3200         
3201         return bytes(currentBaseURI).length > 0
3202         ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), baseExtension))
3203         : "";
3204     }
3205 
3206 }