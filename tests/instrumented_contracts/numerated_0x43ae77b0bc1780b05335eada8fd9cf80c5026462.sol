1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Library for managing
95  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
96  * types.
97  *
98  * Sets have the following properties:
99  *
100  * - Elements are added, removed, and checked for existence in constant time
101  * (O(1)).
102  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
103  *
104  * ```
105  * contract Example {
106  *     // Add the library methods
107  *     using EnumerableSet for EnumerableSet.AddressSet;
108  *
109  *     // Declare a set state variable
110  *     EnumerableSet.AddressSet private mySet;
111  * }
112  * ```
113  *
114  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
115  * and `uint256` (`UintSet`) are supported.
116  *
117  * [WARNING]
118  * ====
119  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
120  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
121  *
122  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
123  * ====
124  */
125 library EnumerableSet {
126     // To implement this library for multiple types with as little code
127     // repetition as possible, we write it in terms of a generic Set type with
128     // bytes32 values.
129     // The Set implementation uses private functions, and user-facing
130     // implementations (such as AddressSet) are just wrappers around the
131     // underlying Set.
132     // This means that we can only create new EnumerableSets for types that fit
133     // in bytes32.
134 
135     struct Set {
136         // Storage of set values
137         bytes32[] _values;
138         // Position of the value in the `values` array, plus 1 because index 0
139         // means a value is not in the set.
140         mapping(bytes32 => uint256) _indexes;
141     }
142 
143     /**
144      * @dev Add a value to a set. O(1).
145      *
146      * Returns true if the value was added to the set, that is if it was not
147      * already present.
148      */
149     function _add(Set storage set, bytes32 value) private returns (bool) {
150         if (!_contains(set, value)) {
151             set._values.push(value);
152             // The value is stored at length-1, but we add 1 to all indexes
153             // and use 0 as a sentinel value
154             set._indexes[value] = set._values.length;
155             return true;
156         } else {
157             return false;
158         }
159     }
160 
161     /**
162      * @dev Removes a value from a set. O(1).
163      *
164      * Returns true if the value was removed from the set, that is if it was
165      * present.
166      */
167     function _remove(Set storage set, bytes32 value) private returns (bool) {
168         // We read and store the value's index to prevent multiple reads from the same storage slot
169         uint256 valueIndex = set._indexes[value];
170 
171         if (valueIndex != 0) {
172             // Equivalent to contains(set, value)
173             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
174             // the array, and then remove the last element (sometimes called as 'swap and pop').
175             // This modifies the order of the array, as noted in {at}.
176 
177             uint256 toDeleteIndex = valueIndex - 1;
178             uint256 lastIndex = set._values.length - 1;
179 
180             if (lastIndex != toDeleteIndex) {
181                 bytes32 lastValue = set._values[lastIndex];
182 
183                 // Move the last value to the index where the value to delete is
184                 set._values[toDeleteIndex] = lastValue;
185                 // Update the index for the moved value
186                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
187             }
188 
189             // Delete the slot where the moved value was stored
190             set._values.pop();
191 
192             // Delete the index for the deleted slot
193             delete set._indexes[value];
194 
195             return true;
196         } else {
197             return false;
198         }
199     }
200 
201     /**
202      * @dev Returns true if the value is in the set. O(1).
203      */
204     function _contains(Set storage set, bytes32 value) private view returns (bool) {
205         return set._indexes[value] != 0;
206     }
207 
208     /**
209      * @dev Returns the number of values on the set. O(1).
210      */
211     function _length(Set storage set) private view returns (uint256) {
212         return set._values.length;
213     }
214 
215     /**
216      * @dev Returns the value stored at position `index` in the set. O(1).
217      *
218      * Note that there are no guarantees on the ordering of values inside the
219      * array, and it may change when more values are added or removed.
220      *
221      * Requirements:
222      *
223      * - `index` must be strictly less than {length}.
224      */
225     function _at(Set storage set, uint256 index) private view returns (bytes32) {
226         return set._values[index];
227     }
228 
229     /**
230      * @dev Return the entire set in an array
231      *
232      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
233      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
234      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
235      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
236      */
237     function _values(Set storage set) private view returns (bytes32[] memory) {
238         return set._values;
239     }
240 
241     // Bytes32Set
242 
243     struct Bytes32Set {
244         Set _inner;
245     }
246 
247     /**
248      * @dev Add a value to a set. O(1).
249      *
250      * Returns true if the value was added to the set, that is if it was not
251      * already present.
252      */
253     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
254         return _add(set._inner, value);
255     }
256 
257     /**
258      * @dev Removes a value from a set. O(1).
259      *
260      * Returns true if the value was removed from the set, that is if it was
261      * present.
262      */
263     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
264         return _remove(set._inner, value);
265     }
266 
267     /**
268      * @dev Returns true if the value is in the set. O(1).
269      */
270     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
271         return _contains(set._inner, value);
272     }
273 
274     /**
275      * @dev Returns the number of values in the set. O(1).
276      */
277     function length(Bytes32Set storage set) internal view returns (uint256) {
278         return _length(set._inner);
279     }
280 
281     /**
282      * @dev Returns the value stored at position `index` in the set. O(1).
283      *
284      * Note that there are no guarantees on the ordering of values inside the
285      * array, and it may change when more values are added or removed.
286      *
287      * Requirements:
288      *
289      * - `index` must be strictly less than {length}.
290      */
291     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
292         return _at(set._inner, index);
293     }
294 
295     /**
296      * @dev Return the entire set in an array
297      *
298      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
299      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
300      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
301      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
302      */
303     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
304         return _values(set._inner);
305     }
306 
307     // AddressSet
308 
309     struct AddressSet {
310         Set _inner;
311     }
312 
313     /**
314      * @dev Add a value to a set. O(1).
315      *
316      * Returns true if the value was added to the set, that is if it was not
317      * already present.
318      */
319     function add(AddressSet storage set, address value) internal returns (bool) {
320         return _add(set._inner, bytes32(uint256(uint160(value))));
321     }
322 
323     /**
324      * @dev Removes a value from a set. O(1).
325      *
326      * Returns true if the value was removed from the set, that is if it was
327      * present.
328      */
329     function remove(AddressSet storage set, address value) internal returns (bool) {
330         return _remove(set._inner, bytes32(uint256(uint160(value))));
331     }
332 
333     /**
334      * @dev Returns true if the value is in the set. O(1).
335      */
336     function contains(AddressSet storage set, address value) internal view returns (bool) {
337         return _contains(set._inner, bytes32(uint256(uint160(value))));
338     }
339 
340     /**
341      * @dev Returns the number of values in the set. O(1).
342      */
343     function length(AddressSet storage set) internal view returns (uint256) {
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
357     function at(AddressSet storage set, uint256 index) internal view returns (address) {
358         return address(uint160(uint256(_at(set._inner, index))));
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
369     function values(AddressSet storage set) internal view returns (address[] memory) {
370         bytes32[] memory store = _values(set._inner);
371         address[] memory result;
372 
373         /// @solidity memory-safe-assembly
374         assembly {
375             result := store
376         }
377 
378         return result;
379     }
380 
381     // UintSet
382 
383     struct UintSet {
384         Set _inner;
385     }
386 
387     /**
388      * @dev Add a value to a set. O(1).
389      *
390      * Returns true if the value was added to the set, that is if it was not
391      * already present.
392      */
393     function add(UintSet storage set, uint256 value) internal returns (bool) {
394         return _add(set._inner, bytes32(value));
395     }
396 
397     /**
398      * @dev Removes a value from a set. O(1).
399      *
400      * Returns true if the value was removed from the set, that is if it was
401      * present.
402      */
403     function remove(UintSet storage set, uint256 value) internal returns (bool) {
404         return _remove(set._inner, bytes32(value));
405     }
406 
407     /**
408      * @dev Returns true if the value is in the set. O(1).
409      */
410     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
411         return _contains(set._inner, bytes32(value));
412     }
413 
414     /**
415      * @dev Returns the number of values on the set. O(1).
416      */
417     function length(UintSet storage set) internal view returns (uint256) {
418         return _length(set._inner);
419     }
420 
421     /**
422      * @dev Returns the value stored at position `index` in the set. O(1).
423      *
424      * Note that there are no guarantees on the ordering of values inside the
425      * array, and it may change when more values are added or removed.
426      *
427      * Requirements:
428      *
429      * - `index` must be strictly less than {length}.
430      */
431     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
432         return uint256(_at(set._inner, index));
433     }
434 
435     /**
436      * @dev Return the entire set in an array
437      *
438      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
439      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
440      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
441      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
442      */
443     function values(UintSet storage set) internal view returns (uint256[] memory) {
444         bytes32[] memory store = _values(set._inner);
445         uint256[] memory result;
446 
447         /// @solidity memory-safe-assembly
448         assembly {
449             result := store
450         }
451 
452         return result;
453     }
454 }
455 
456 // File: @openzeppelin/contracts/utils/Counters.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @title Counters
465  * @author Matt Condon (@shrugs)
466  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
467  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
468  *
469  * Include with `using Counters for Counters.Counter;`
470  */
471 library Counters {
472     struct Counter {
473         // This variable should never be directly accessed by users of the library: interactions must be restricted to
474         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
475         // this feature: see https://github.com/ethereum/solidity/issues/4637
476         uint256 _value; // default: 0
477     }
478 
479     function current(Counter storage counter) internal view returns (uint256) {
480         return counter._value;
481     }
482 
483     function increment(Counter storage counter) internal {
484         unchecked {
485             counter._value += 1;
486         }
487     }
488 
489     function decrement(Counter storage counter) internal {
490         uint256 value = counter._value;
491         require(value > 0, "Counter: decrement overflow");
492         unchecked {
493             counter._value = value - 1;
494         }
495     }
496 
497     function reset(Counter storage counter) internal {
498         counter._value = 0;
499     }
500 }
501 
502 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
503 
504 
505 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev These functions deal with verification of Merkle Tree proofs.
511  *
512  * The proofs can be generated using the JavaScript library
513  * https://github.com/miguelmota/merkletreejs[merkletreejs].
514  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
515  *
516  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
517  *
518  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
519  * hashing, or use a hash function other than keccak256 for hashing leaves.
520  * This is because the concatenation of a sorted pair of internal nodes in
521  * the merkle tree could be reinterpreted as a leaf value.
522  */
523 library MerkleProof {
524     /**
525      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
526      * defined by `root`. For this, a `proof` must be provided, containing
527      * sibling hashes on the branch from the leaf to the root of the tree. Each
528      * pair of leaves and each pair of pre-images are assumed to be sorted.
529      */
530     function verify(
531         bytes32[] memory proof,
532         bytes32 root,
533         bytes32 leaf
534     ) internal pure returns (bool) {
535         return processProof(proof, leaf) == root;
536     }
537 
538     /**
539      * @dev Calldata version of {verify}
540      *
541      * _Available since v4.7._
542      */
543     function verifyCalldata(
544         bytes32[] calldata proof,
545         bytes32 root,
546         bytes32 leaf
547     ) internal pure returns (bool) {
548         return processProofCalldata(proof, leaf) == root;
549     }
550 
551     /**
552      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
553      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
554      * hash matches the root of the tree. When processing the proof, the pairs
555      * of leafs & pre-images are assumed to be sorted.
556      *
557      * _Available since v4.4._
558      */
559     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
560         bytes32 computedHash = leaf;
561         for (uint256 i = 0; i < proof.length; i++) {
562             computedHash = _hashPair(computedHash, proof[i]);
563         }
564         return computedHash;
565     }
566 
567     /**
568      * @dev Calldata version of {processProof}
569      *
570      * _Available since v4.7._
571      */
572     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
573         bytes32 computedHash = leaf;
574         for (uint256 i = 0; i < proof.length; i++) {
575             computedHash = _hashPair(computedHash, proof[i]);
576         }
577         return computedHash;
578     }
579 
580     /**
581      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
582      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
583      *
584      * _Available since v4.7._
585      */
586     function multiProofVerify(
587         bytes32[] memory proof,
588         bool[] memory proofFlags,
589         bytes32 root,
590         bytes32[] memory leaves
591     ) internal pure returns (bool) {
592         return processMultiProof(proof, proofFlags, leaves) == root;
593     }
594 
595     /**
596      * @dev Calldata version of {multiProofVerify}
597      *
598      * _Available since v4.7._
599      */
600     function multiProofVerifyCalldata(
601         bytes32[] calldata proof,
602         bool[] calldata proofFlags,
603         bytes32 root,
604         bytes32[] memory leaves
605     ) internal pure returns (bool) {
606         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
607     }
608 
609     /**
610      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
611      * consuming from one or the other at each step according to the instructions given by
612      * `proofFlags`.
613      *
614      * _Available since v4.7._
615      */
616     function processMultiProof(
617         bytes32[] memory proof,
618         bool[] memory proofFlags,
619         bytes32[] memory leaves
620     ) internal pure returns (bytes32 merkleRoot) {
621         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
622         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
623         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
624         // the merkle tree.
625         uint256 leavesLen = leaves.length;
626         uint256 totalHashes = proofFlags.length;
627 
628         // Check proof validity.
629         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
630 
631         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
632         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
633         bytes32[] memory hashes = new bytes32[](totalHashes);
634         uint256 leafPos = 0;
635         uint256 hashPos = 0;
636         uint256 proofPos = 0;
637         // At each step, we compute the next hash using two values:
638         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
639         //   get the next hash.
640         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
641         //   `proof` array.
642         for (uint256 i = 0; i < totalHashes; i++) {
643             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
644             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
645             hashes[i] = _hashPair(a, b);
646         }
647 
648         if (totalHashes > 0) {
649             return hashes[totalHashes - 1];
650         } else if (leavesLen > 0) {
651             return leaves[0];
652         } else {
653             return proof[0];
654         }
655     }
656 
657     /**
658      * @dev Calldata version of {processMultiProof}
659      *
660      * _Available since v4.7._
661      */
662     function processMultiProofCalldata(
663         bytes32[] calldata proof,
664         bool[] calldata proofFlags,
665         bytes32[] memory leaves
666     ) internal pure returns (bytes32 merkleRoot) {
667         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
668         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
669         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
670         // the merkle tree.
671         uint256 leavesLen = leaves.length;
672         uint256 totalHashes = proofFlags.length;
673 
674         // Check proof validity.
675         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
676 
677         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
678         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
679         bytes32[] memory hashes = new bytes32[](totalHashes);
680         uint256 leafPos = 0;
681         uint256 hashPos = 0;
682         uint256 proofPos = 0;
683         // At each step, we compute the next hash using two values:
684         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
685         //   get the next hash.
686         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
687         //   `proof` array.
688         for (uint256 i = 0; i < totalHashes; i++) {
689             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
690             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
691             hashes[i] = _hashPair(a, b);
692         }
693 
694         if (totalHashes > 0) {
695             return hashes[totalHashes - 1];
696         } else if (leavesLen > 0) {
697             return leaves[0];
698         } else {
699             return proof[0];
700         }
701     }
702 
703     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
704         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
705     }
706 
707     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
708         /// @solidity memory-safe-assembly
709         assembly {
710             mstore(0x00, a)
711             mstore(0x20, b)
712             value := keccak256(0x00, 0x40)
713         }
714     }
715 }
716 
717 // File: @openzeppelin/contracts/utils/Strings.sol
718 
719 
720 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev String operations.
726  */
727 library Strings {
728     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
729     uint8 private constant _ADDRESS_LENGTH = 20;
730 
731     /**
732      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
733      */
734     function toString(uint256 value) internal pure returns (string memory) {
735         // Inspired by OraclizeAPI's implementation - MIT licence
736         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
737 
738         if (value == 0) {
739             return "0";
740         }
741         uint256 temp = value;
742         uint256 digits;
743         while (temp != 0) {
744             digits++;
745             temp /= 10;
746         }
747         bytes memory buffer = new bytes(digits);
748         while (value != 0) {
749             digits -= 1;
750             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
751             value /= 10;
752         }
753         return string(buffer);
754     }
755 
756     /**
757      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
758      */
759     function toHexString(uint256 value) internal pure returns (string memory) {
760         if (value == 0) {
761             return "0x00";
762         }
763         uint256 temp = value;
764         uint256 length = 0;
765         while (temp != 0) {
766             length++;
767             temp >>= 8;
768         }
769         return toHexString(value, length);
770     }
771 
772     /**
773      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
774      */
775     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
776         bytes memory buffer = new bytes(2 * length + 2);
777         buffer[0] = "0";
778         buffer[1] = "x";
779         for (uint256 i = 2 * length + 1; i > 1; --i) {
780             buffer[i] = _HEX_SYMBOLS[value & 0xf];
781             value >>= 4;
782         }
783         require(value == 0, "Strings: hex length insufficient");
784         return string(buffer);
785     }
786 
787     /**
788      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
789      */
790     function toHexString(address addr) internal pure returns (string memory) {
791         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
792     }
793 }
794 
795 // File: @openzeppelin/contracts/utils/Address.sol
796 
797 
798 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
799 
800 pragma solidity ^0.8.1;
801 
802 /**
803  * @dev Collection of functions related to the address type
804  */
805 library Address {
806     /**
807      * @dev Returns true if `account` is a contract.
808      *
809      * [IMPORTANT]
810      * ====
811      * It is unsafe to assume that an address for which this function returns
812      * false is an externally-owned account (EOA) and not a contract.
813      *
814      * Among others, `isContract` will return false for the following
815      * types of addresses:
816      *
817      *  - an externally-owned account
818      *  - a contract in construction
819      *  - an address where a contract will be created
820      *  - an address where a contract lived, but was destroyed
821      * ====
822      *
823      * [IMPORTANT]
824      * ====
825      * You shouldn't rely on `isContract` to protect against flash loan attacks!
826      *
827      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
828      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
829      * constructor.
830      * ====
831      */
832     function isContract(address account) internal view returns (bool) {
833         // This method relies on extcodesize/address.code.length, which returns 0
834         // for contracts in construction, since the code is only stored at the end
835         // of the constructor execution.
836 
837         return account.code.length > 0;
838     }
839 
840     /**
841      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
842      * `recipient`, forwarding all available gas and reverting on errors.
843      *
844      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
845      * of certain opcodes, possibly making contracts go over the 2300 gas limit
846      * imposed by `transfer`, making them unable to receive funds via
847      * `transfer`. {sendValue} removes this limitation.
848      *
849      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
850      *
851      * IMPORTANT: because control is transferred to `recipient`, care must be
852      * taken to not create reentrancy vulnerabilities. Consider using
853      * {ReentrancyGuard} or the
854      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
855      */
856     function sendValue(address payable recipient, uint256 amount) internal {
857         require(address(this).balance >= amount, "Address: insufficient balance");
858 
859         (bool success, ) = recipient.call{value: amount}("");
860         require(success, "Address: unable to send value, recipient may have reverted");
861     }
862 
863     /**
864      * @dev Performs a Solidity function call using a low level `call`. A
865      * plain `call` is an unsafe replacement for a function call: use this
866      * function instead.
867      *
868      * If `target` reverts with a revert reason, it is bubbled up by this
869      * function (like regular Solidity function calls).
870      *
871      * Returns the raw returned data. To convert to the expected return value,
872      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
873      *
874      * Requirements:
875      *
876      * - `target` must be a contract.
877      * - calling `target` with `data` must not revert.
878      *
879      * _Available since v3.1._
880      */
881     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
882         return functionCall(target, data, "Address: low-level call failed");
883     }
884 
885     /**
886      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
887      * `errorMessage` as a fallback revert reason when `target` reverts.
888      *
889      * _Available since v3.1._
890      */
891     function functionCall(
892         address target,
893         bytes memory data,
894         string memory errorMessage
895     ) internal returns (bytes memory) {
896         return functionCallWithValue(target, data, 0, errorMessage);
897     }
898 
899     /**
900      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
901      * but also transferring `value` wei to `target`.
902      *
903      * Requirements:
904      *
905      * - the calling contract must have an ETH balance of at least `value`.
906      * - the called Solidity function must be `payable`.
907      *
908      * _Available since v3.1._
909      */
910     function functionCallWithValue(
911         address target,
912         bytes memory data,
913         uint256 value
914     ) internal returns (bytes memory) {
915         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
916     }
917 
918     /**
919      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
920      * with `errorMessage` as a fallback revert reason when `target` reverts.
921      *
922      * _Available since v3.1._
923      */
924     function functionCallWithValue(
925         address target,
926         bytes memory data,
927         uint256 value,
928         string memory errorMessage
929     ) internal returns (bytes memory) {
930         require(address(this).balance >= value, "Address: insufficient balance for call");
931         require(isContract(target), "Address: call to non-contract");
932 
933         (bool success, bytes memory returndata) = target.call{value: value}(data);
934         return verifyCallResult(success, returndata, errorMessage);
935     }
936 
937     /**
938      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
939      * but performing a static call.
940      *
941      * _Available since v3.3._
942      */
943     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
944         return functionStaticCall(target, data, "Address: low-level static call failed");
945     }
946 
947     /**
948      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
949      * but performing a static call.
950      *
951      * _Available since v3.3._
952      */
953     function functionStaticCall(
954         address target,
955         bytes memory data,
956         string memory errorMessage
957     ) internal view returns (bytes memory) {
958         require(isContract(target), "Address: static call to non-contract");
959 
960         (bool success, bytes memory returndata) = target.staticcall(data);
961         return verifyCallResult(success, returndata, errorMessage);
962     }
963 
964     /**
965      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
966      * but performing a delegate call.
967      *
968      * _Available since v3.4._
969      */
970     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
971         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
972     }
973 
974     /**
975      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
976      * but performing a delegate call.
977      *
978      * _Available since v3.4._
979      */
980     function functionDelegateCall(
981         address target,
982         bytes memory data,
983         string memory errorMessage
984     ) internal returns (bytes memory) {
985         require(isContract(target), "Address: delegate call to non-contract");
986 
987         (bool success, bytes memory returndata) = target.delegatecall(data);
988         return verifyCallResult(success, returndata, errorMessage);
989     }
990 
991     /**
992      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
993      * revert reason using the provided one.
994      *
995      * _Available since v4.3._
996      */
997     function verifyCallResult(
998         bool success,
999         bytes memory returndata,
1000         string memory errorMessage
1001     ) internal pure returns (bytes memory) {
1002         if (success) {
1003             return returndata;
1004         } else {
1005             // Look for revert reason and bubble it up if present
1006             if (returndata.length > 0) {
1007                 // The easiest way to bubble the revert reason is using memory via assembly
1008                 /// @solidity memory-safe-assembly
1009                 assembly {
1010                     let returndata_size := mload(returndata)
1011                     revert(add(32, returndata), returndata_size)
1012                 }
1013             } else {
1014                 revert(errorMessage);
1015             }
1016         }
1017     }
1018 }
1019 
1020 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1021 
1022 
1023 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 /**
1028  * @title ERC721 token receiver interface
1029  * @dev Interface for any contract that wants to support safeTransfers
1030  * from ERC721 asset contracts.
1031  */
1032 interface IERC721Receiver {
1033     /**
1034      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1035      * by `operator` from `from`, this function is called.
1036      *
1037      * It must return its Solidity selector to confirm the token transfer.
1038      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1039      *
1040      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1041      */
1042     function onERC721Received(
1043         address operator,
1044         address from,
1045         uint256 tokenId,
1046         bytes calldata data
1047     ) external returns (bytes4);
1048 }
1049 
1050 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1051 
1052 
1053 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1054 
1055 pragma solidity ^0.8.0;
1056 
1057 /**
1058  * @dev Interface of the ERC165 standard, as defined in the
1059  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1060  *
1061  * Implementers can declare support of contract interfaces, which can then be
1062  * queried by others ({ERC165Checker}).
1063  *
1064  * For an implementation, see {ERC165}.
1065  */
1066 interface IERC165 {
1067     /**
1068      * @dev Returns true if this contract implements the interface defined by
1069      * `interfaceId`. See the corresponding
1070      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1071      * to learn more about how these ids are created.
1072      *
1073      * This function call must use less than 30 000 gas.
1074      */
1075     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1076 }
1077 
1078 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1079 
1080 
1081 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 
1086 /**
1087  * @dev Implementation of the {IERC165} interface.
1088  *
1089  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1090  * for the additional interface id that will be supported. For example:
1091  *
1092  * ```solidity
1093  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1094  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1095  * }
1096  * ```
1097  *
1098  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1099  */
1100 abstract contract ERC165 is IERC165 {
1101     /**
1102      * @dev See {IERC165-supportsInterface}.
1103      */
1104     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1105         return interfaceId == type(IERC165).interfaceId;
1106     }
1107 }
1108 
1109 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1110 
1111 
1112 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1113 
1114 pragma solidity ^0.8.0;
1115 
1116 
1117 /**
1118  * @dev Required interface of an ERC721 compliant contract.
1119  */
1120 interface IERC721 is IERC165 {
1121     /**
1122      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1123      */
1124     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1125 
1126     /**
1127      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1128      */
1129     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1130 
1131     /**
1132      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1133      */
1134     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1135 
1136     /**
1137      * @dev Returns the number of tokens in ``owner``'s account.
1138      */
1139     function balanceOf(address owner) external view returns (uint256 balance);
1140 
1141     /**
1142      * @dev Returns the owner of the `tokenId` token.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      */
1148     function ownerOf(uint256 tokenId) external view returns (address owner);
1149 
1150     /**
1151      * @dev Safely transfers `tokenId` token from `from` to `to`.
1152      *
1153      * Requirements:
1154      *
1155      * - `from` cannot be the zero address.
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must exist and be owned by `from`.
1158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function safeTransferFrom(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes calldata data
1168     ) external;
1169 
1170     /**
1171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1173      *
1174      * Requirements:
1175      *
1176      * - `from` cannot be the zero address.
1177      * - `to` cannot be the zero address.
1178      * - `tokenId` token must exist and be owned by `from`.
1179      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function safeTransferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) external;
1189 
1190     /**
1191      * @dev Transfers `tokenId` token from `from` to `to`.
1192      *
1193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1194      *
1195      * Requirements:
1196      *
1197      * - `from` cannot be the zero address.
1198      * - `to` cannot be the zero address.
1199      * - `tokenId` token must be owned by `from`.
1200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function transferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) external;
1209 
1210     /**
1211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1212      * The approval is cleared when the token is transferred.
1213      *
1214      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1215      *
1216      * Requirements:
1217      *
1218      * - The caller must own the token or be an approved operator.
1219      * - `tokenId` must exist.
1220      *
1221      * Emits an {Approval} event.
1222      */
1223     function approve(address to, uint256 tokenId) external;
1224 
1225     /**
1226      * @dev Approve or remove `operator` as an operator for the caller.
1227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1228      *
1229      * Requirements:
1230      *
1231      * - The `operator` cannot be the caller.
1232      *
1233      * Emits an {ApprovalForAll} event.
1234      */
1235     function setApprovalForAll(address operator, bool _approved) external;
1236 
1237     /**
1238      * @dev Returns the account approved for `tokenId` token.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      */
1244     function getApproved(uint256 tokenId) external view returns (address operator);
1245 
1246     /**
1247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1248      *
1249      * See {setApprovalForAll}
1250      */
1251     function isApprovedForAll(address owner, address operator) external view returns (bool);
1252 }
1253 
1254 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1255 
1256 
1257 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 
1262 /**
1263  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1264  * @dev See https://eips.ethereum.org/EIPS/eip-721
1265  */
1266 interface IERC721Enumerable is IERC721 {
1267     /**
1268      * @dev Returns the total amount of tokens stored by the contract.
1269      */
1270     function totalSupply() external view returns (uint256);
1271 
1272     /**
1273      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1274      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1275      */
1276     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1277 
1278     /**
1279      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1280      * Use along with {totalSupply} to enumerate all tokens.
1281      */
1282     function tokenByIndex(uint256 index) external view returns (uint256);
1283 }
1284 
1285 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1286 
1287 
1288 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 
1293 /**
1294  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1295  * @dev See https://eips.ethereum.org/EIPS/eip-721
1296  */
1297 interface IERC721Metadata is IERC721 {
1298     /**
1299      * @dev Returns the token collection name.
1300      */
1301     function name() external view returns (string memory);
1302 
1303     /**
1304      * @dev Returns the token collection symbol.
1305      */
1306     function symbol() external view returns (string memory);
1307 
1308     /**
1309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1310      */
1311     function tokenURI(uint256 tokenId) external view returns (string memory);
1312 }
1313 
1314 // File: @openzeppelin/contracts/utils/Context.sol
1315 
1316 
1317 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 /**
1322  * @dev Provides information about the current execution context, including the
1323  * sender of the transaction and its data. While these are generally available
1324  * via msg.sender and msg.data, they should not be accessed in such a direct
1325  * manner, since when dealing with meta-transactions the account sending and
1326  * paying for execution may not be the actual sender (as far as an application
1327  * is concerned).
1328  *
1329  * This contract is only required for intermediate, library-like contracts.
1330  */
1331 abstract contract Context {
1332     function _msgSender() internal view virtual returns (address) {
1333         return msg.sender;
1334     }
1335 
1336     function _msgData() internal view virtual returns (bytes calldata) {
1337         return msg.data;
1338     }
1339 }
1340 
1341 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1342 
1343 
1344 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1345 
1346 pragma solidity ^0.8.0;
1347 
1348 
1349 
1350 
1351 
1352 
1353 
1354 
1355 /**
1356  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1357  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1358  * {ERC721Enumerable}.
1359  */
1360 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1361     using Address for address;
1362     using Strings for uint256;
1363 
1364     // Token name
1365     string private _name;
1366 
1367     // Token symbol
1368     string private _symbol;
1369 
1370     // Mapping from token ID to owner address
1371     mapping(uint256 => address) private _owners;
1372 
1373     // Mapping owner address to token count
1374     mapping(address => uint256) private _balances;
1375 
1376     // Mapping from token ID to approved address
1377     mapping(uint256 => address) private _tokenApprovals;
1378 
1379     // Mapping from owner to operator approvals
1380     mapping(address => mapping(address => bool)) private _operatorApprovals;
1381 
1382     /**
1383      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1384      */
1385     constructor(string memory name_, string memory symbol_) {
1386         _name = name_;
1387         _symbol = symbol_;
1388     }
1389 
1390     /**
1391      * @dev See {IERC165-supportsInterface}.
1392      */
1393     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1394         return
1395             interfaceId == type(IERC721).interfaceId ||
1396             interfaceId == type(IERC721Metadata).interfaceId ||
1397             super.supportsInterface(interfaceId);
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-balanceOf}.
1402      */
1403     function balanceOf(address owner) public view virtual override returns (uint256) {
1404         require(owner != address(0), "ERC721: address zero is not a valid owner");
1405         return _balances[owner];
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-ownerOf}.
1410      */
1411     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1412         address owner = _owners[tokenId];
1413         require(owner != address(0), "ERC721: invalid token ID");
1414         return owner;
1415     }
1416 
1417     /**
1418      * @dev See {IERC721Metadata-name}.
1419      */
1420     function name() public view virtual override returns (string memory) {
1421         return _name;
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Metadata-symbol}.
1426      */
1427     function symbol() public view virtual override returns (string memory) {
1428         return _symbol;
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Metadata-tokenURI}.
1433      */
1434     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1435         _requireMinted(tokenId);
1436 
1437         string memory baseURI = _baseURI();
1438         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1439     }
1440 
1441     /**
1442      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1443      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1444      * by default, can be overridden in child contracts.
1445      */
1446     function _baseURI() internal view virtual returns (string memory) {
1447         return "";
1448     }
1449 
1450     /**
1451      * @dev See {IERC721-approve}.
1452      */
1453     function approve(address to, uint256 tokenId) public virtual override {
1454         address owner = ERC721.ownerOf(tokenId);
1455         require(to != owner, "ERC721: approval to current owner");
1456 
1457         require(
1458             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1459             "ERC721: approve caller is not token owner nor approved for all"
1460         );
1461 
1462         _approve(to, tokenId);
1463     }
1464 
1465     /**
1466      * @dev See {IERC721-getApproved}.
1467      */
1468     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1469         _requireMinted(tokenId);
1470 
1471         return _tokenApprovals[tokenId];
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-setApprovalForAll}.
1476      */
1477     function setApprovalForAll(address operator, bool approved) public virtual override {
1478         _setApprovalForAll(_msgSender(), operator, approved);
1479     }
1480 
1481     /**
1482      * @dev See {IERC721-isApprovedForAll}.
1483      */
1484     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1485         return _operatorApprovals[owner][operator];
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-transferFrom}.
1490      */
1491     function transferFrom(
1492         address from,
1493         address to,
1494         uint256 tokenId
1495     ) public virtual override {
1496         //solhint-disable-next-line max-line-length
1497         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1498 
1499         _transfer(from, to, tokenId);
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-safeTransferFrom}.
1504      */
1505     function safeTransferFrom(
1506         address from,
1507         address to,
1508         uint256 tokenId
1509     ) public virtual override {
1510         safeTransferFrom(from, to, tokenId, "");
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-safeTransferFrom}.
1515      */
1516     function safeTransferFrom(
1517         address from,
1518         address to,
1519         uint256 tokenId,
1520         bytes memory data
1521     ) public virtual override {
1522         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1523         _safeTransfer(from, to, tokenId, data);
1524     }
1525 
1526     /**
1527      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1528      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1529      *
1530      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1531      *
1532      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1533      * implement alternative mechanisms to perform token transfer, such as signature-based.
1534      *
1535      * Requirements:
1536      *
1537      * - `from` cannot be the zero address.
1538      * - `to` cannot be the zero address.
1539      * - `tokenId` token must exist and be owned by `from`.
1540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1541      *
1542      * Emits a {Transfer} event.
1543      */
1544     function _safeTransfer(
1545         address from,
1546         address to,
1547         uint256 tokenId,
1548         bytes memory data
1549     ) internal virtual {
1550         _transfer(from, to, tokenId);
1551         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1552     }
1553 
1554     /**
1555      * @dev Returns whether `tokenId` exists.
1556      *
1557      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1558      *
1559      * Tokens start existing when they are minted (`_mint`),
1560      * and stop existing when they are burned (`_burn`).
1561      */
1562     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1563         return _owners[tokenId] != address(0);
1564     }
1565 
1566     /**
1567      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must exist.
1572      */
1573     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1574         address owner = ERC721.ownerOf(tokenId);
1575         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1576     }
1577 
1578     /**
1579      * @dev Safely mints `tokenId` and transfers it to `to`.
1580      *
1581      * Requirements:
1582      *
1583      * - `tokenId` must not exist.
1584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function _safeMint(address to, uint256 tokenId) internal virtual {
1589         _safeMint(to, tokenId, "");
1590     }
1591 
1592     /**
1593      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1594      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1595      */
1596     function _safeMint(
1597         address to,
1598         uint256 tokenId,
1599         bytes memory data
1600     ) internal virtual {
1601         _mint(to, tokenId);
1602         require(
1603             _checkOnERC721Received(address(0), to, tokenId, data),
1604             "ERC721: transfer to non ERC721Receiver implementer"
1605         );
1606     }
1607 
1608     /**
1609      * @dev Mints `tokenId` and transfers it to `to`.
1610      *
1611      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1612      *
1613      * Requirements:
1614      *
1615      * - `tokenId` must not exist.
1616      * - `to` cannot be the zero address.
1617      *
1618      * Emits a {Transfer} event.
1619      */
1620     function _mint(address to, uint256 tokenId) internal virtual {
1621         require(to != address(0), "ERC721: mint to the zero address");
1622         require(!_exists(tokenId), "ERC721: token already minted");
1623 
1624         _beforeTokenTransfer(address(0), to, tokenId);
1625 
1626         _balances[to] += 1;
1627         _owners[tokenId] = to;
1628 
1629         emit Transfer(address(0), to, tokenId);
1630 
1631         _afterTokenTransfer(address(0), to, tokenId);
1632     }
1633 
1634     /**
1635      * @dev Destroys `tokenId`.
1636      * The approval is cleared when the token is burned.
1637      *
1638      * Requirements:
1639      *
1640      * - `tokenId` must exist.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function _burn(uint256 tokenId) internal virtual {
1645         address owner = ERC721.ownerOf(tokenId);
1646 
1647         _beforeTokenTransfer(owner, address(0), tokenId);
1648 
1649         // Clear approvals
1650         _approve(address(0), tokenId);
1651 
1652         _balances[owner] -= 1;
1653         delete _owners[tokenId];
1654 
1655         emit Transfer(owner, address(0), tokenId);
1656 
1657         _afterTokenTransfer(owner, address(0), tokenId);
1658     }
1659 
1660     /**
1661      * @dev Transfers `tokenId` from `from` to `to`.
1662      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1663      *
1664      * Requirements:
1665      *
1666      * - `to` cannot be the zero address.
1667      * - `tokenId` token must be owned by `from`.
1668      *
1669      * Emits a {Transfer} event.
1670      */
1671     function _transfer(
1672         address from,
1673         address to,
1674         uint256 tokenId
1675     ) internal virtual {
1676         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1677         require(to != address(0), "ERC721: transfer to the zero address");
1678 
1679         _beforeTokenTransfer(from, to, tokenId);
1680 
1681         // Clear approvals from the previous owner
1682         _approve(address(0), tokenId);
1683 
1684         _balances[from] -= 1;
1685         _balances[to] += 1;
1686         _owners[tokenId] = to;
1687 
1688         emit Transfer(from, to, tokenId);
1689 
1690         _afterTokenTransfer(from, to, tokenId);
1691     }
1692 
1693     /**
1694      * @dev Approve `to` to operate on `tokenId`
1695      *
1696      * Emits an {Approval} event.
1697      */
1698     function _approve(address to, uint256 tokenId) internal virtual {
1699         _tokenApprovals[tokenId] = to;
1700         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev Approve `operator` to operate on all of `owner` tokens
1705      *
1706      * Emits an {ApprovalForAll} event.
1707      */
1708     function _setApprovalForAll(
1709         address owner,
1710         address operator,
1711         bool approved
1712     ) internal virtual {
1713         require(owner != operator, "ERC721: approve to caller");
1714         _operatorApprovals[owner][operator] = approved;
1715         emit ApprovalForAll(owner, operator, approved);
1716     }
1717 
1718     /**
1719      * @dev Reverts if the `tokenId` has not been minted yet.
1720      */
1721     function _requireMinted(uint256 tokenId) internal view virtual {
1722         require(_exists(tokenId), "ERC721: invalid token ID");
1723     }
1724 
1725     /**
1726      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1727      * The call is not executed if the target address is not a contract.
1728      *
1729      * @param from address representing the previous owner of the given token ID
1730      * @param to target address that will receive the tokens
1731      * @param tokenId uint256 ID of the token to be transferred
1732      * @param data bytes optional data to send along with the call
1733      * @return bool whether the call correctly returned the expected magic value
1734      */
1735     function _checkOnERC721Received(
1736         address from,
1737         address to,
1738         uint256 tokenId,
1739         bytes memory data
1740     ) private returns (bool) {
1741         if (to.isContract()) {
1742             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1743                 return retval == IERC721Receiver.onERC721Received.selector;
1744             } catch (bytes memory reason) {
1745                 if (reason.length == 0) {
1746                     revert("ERC721: transfer to non ERC721Receiver implementer");
1747                 } else {
1748                     /// @solidity memory-safe-assembly
1749                     assembly {
1750                         revert(add(32, reason), mload(reason))
1751                     }
1752                 }
1753             }
1754         } else {
1755             return true;
1756         }
1757     }
1758 
1759     /**
1760      * @dev Hook that is called before any token transfer. This includes minting
1761      * and burning.
1762      *
1763      * Calling conditions:
1764      *
1765      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1766      * transferred to `to`.
1767      * - When `from` is zero, `tokenId` will be minted for `to`.
1768      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1769      * - `from` and `to` are never both zero.
1770      *
1771      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1772      */
1773     function _beforeTokenTransfer(
1774         address from,
1775         address to,
1776         uint256 tokenId
1777     ) internal virtual {}
1778 
1779     /**
1780      * @dev Hook that is called after any transfer of tokens. This includes
1781      * minting and burning.
1782      *
1783      * Calling conditions:
1784      *
1785      * - when `from` and `to` are both non-zero.
1786      * - `from` and `to` are never both zero.
1787      *
1788      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1789      */
1790     function _afterTokenTransfer(
1791         address from,
1792         address to,
1793         uint256 tokenId
1794     ) internal virtual {}
1795 }
1796 
1797 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1798 
1799 
1800 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1801 
1802 pragma solidity ^0.8.0;
1803 
1804 
1805 
1806 /**
1807  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1808  * enumerability of all the token ids in the contract as well as all token ids owned by each
1809  * account.
1810  */
1811 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1812     // Mapping from owner to list of owned token IDs
1813     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1814 
1815     // Mapping from token ID to index of the owner tokens list
1816     mapping(uint256 => uint256) private _ownedTokensIndex;
1817 
1818     // Array with all token ids, used for enumeration
1819     uint256[] private _allTokens;
1820 
1821     // Mapping from token id to position in the allTokens array
1822     mapping(uint256 => uint256) private _allTokensIndex;
1823 
1824     /**
1825      * @dev See {IERC165-supportsInterface}.
1826      */
1827     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1828         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1829     }
1830 
1831     /**
1832      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1833      */
1834     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1835         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1836         return _ownedTokens[owner][index];
1837     }
1838 
1839     /**
1840      * @dev See {IERC721Enumerable-totalSupply}.
1841      */
1842     function totalSupply() public view virtual override returns (uint256) {
1843         return _allTokens.length;
1844     }
1845 
1846     /**
1847      * @dev See {IERC721Enumerable-tokenByIndex}.
1848      */
1849     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1850         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1851         return _allTokens[index];
1852     }
1853 
1854     /**
1855      * @dev Hook that is called before any token transfer. This includes minting
1856      * and burning.
1857      *
1858      * Calling conditions:
1859      *
1860      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1861      * transferred to `to`.
1862      * - When `from` is zero, `tokenId` will be minted for `to`.
1863      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1864      * - `from` cannot be the zero address.
1865      * - `to` cannot be the zero address.
1866      *
1867      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1868      */
1869     function _beforeTokenTransfer(
1870         address from,
1871         address to,
1872         uint256 tokenId
1873     ) internal virtual override {
1874         super._beforeTokenTransfer(from, to, tokenId);
1875 
1876         if (from == address(0)) {
1877             _addTokenToAllTokensEnumeration(tokenId);
1878         } else if (from != to) {
1879             _removeTokenFromOwnerEnumeration(from, tokenId);
1880         }
1881         if (to == address(0)) {
1882             _removeTokenFromAllTokensEnumeration(tokenId);
1883         } else if (to != from) {
1884             _addTokenToOwnerEnumeration(to, tokenId);
1885         }
1886     }
1887 
1888     /**
1889      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1890      * @param to address representing the new owner of the given token ID
1891      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1892      */
1893     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1894         uint256 length = ERC721.balanceOf(to);
1895         _ownedTokens[to][length] = tokenId;
1896         _ownedTokensIndex[tokenId] = length;
1897     }
1898 
1899     /**
1900      * @dev Private function to add a token to this extension's token tracking data structures.
1901      * @param tokenId uint256 ID of the token to be added to the tokens list
1902      */
1903     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1904         _allTokensIndex[tokenId] = _allTokens.length;
1905         _allTokens.push(tokenId);
1906     }
1907 
1908     /**
1909      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1910      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1911      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1912      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1913      * @param from address representing the previous owner of the given token ID
1914      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1915      */
1916     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1917         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1918         // then delete the last slot (swap and pop).
1919 
1920         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1921         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1922 
1923         // When the token to delete is the last token, the swap operation is unnecessary
1924         if (tokenIndex != lastTokenIndex) {
1925             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1926 
1927             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1928             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1929         }
1930 
1931         // This also deletes the contents at the last position of the array
1932         delete _ownedTokensIndex[tokenId];
1933         delete _ownedTokens[from][lastTokenIndex];
1934     }
1935 
1936     /**
1937      * @dev Private function to remove a token from this extension's token tracking data structures.
1938      * This has O(1) time complexity, but alters the order of the _allTokens array.
1939      * @param tokenId uint256 ID of the token to be removed from the tokens list
1940      */
1941     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1942         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1943         // then delete the last slot (swap and pop).
1944 
1945         uint256 lastTokenIndex = _allTokens.length - 1;
1946         uint256 tokenIndex = _allTokensIndex[tokenId];
1947 
1948         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1949         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1950         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1951         uint256 lastTokenId = _allTokens[lastTokenIndex];
1952 
1953         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1954         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1955 
1956         // This also deletes the contents at the last position of the array
1957         delete _allTokensIndex[tokenId];
1958         _allTokens.pop();
1959     }
1960 }
1961 
1962 // File: @openzeppelin/contracts/access/Ownable.sol
1963 
1964 
1965 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1966 
1967 pragma solidity ^0.8.0;
1968 
1969 
1970 /**
1971  * @dev Contract module which provides a basic access control mechanism, where
1972  * there is an account (an owner) that can be granted exclusive access to
1973  * specific functions.
1974  *
1975  * By default, the owner account will be the one that deploys the contract. This
1976  * can later be changed with {transferOwnership}.
1977  *
1978  * This module is used through inheritance. It will make available the modifier
1979  * `onlyOwner`, which can be applied to your functions to restrict their use to
1980  * the owner.
1981  */
1982 abstract contract Ownable is Context {
1983     address private _owner;
1984 
1985     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1986 
1987     /**
1988      * @dev Initializes the contract setting the deployer as the initial owner.
1989      */
1990     constructor() {
1991         _transferOwnership(_msgSender());
1992     }
1993 
1994     /**
1995      * @dev Throws if called by any account other than the owner.
1996      */
1997     modifier onlyOwner() {
1998         _checkOwner();
1999         _;
2000     }
2001 
2002     /**
2003      * @dev Returns the address of the current owner.
2004      */
2005     function owner() public view virtual returns (address) {
2006         return _owner;
2007     }
2008 
2009     /**
2010      * @dev Throws if the sender is not the owner.
2011      */
2012     function _checkOwner() internal view virtual {
2013         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2014     }
2015 
2016     /**
2017      * @dev Leaves the contract without owner. It will not be possible to call
2018      * `onlyOwner` functions anymore. Can only be called by the current owner.
2019      *
2020      * NOTE: Renouncing ownership will leave the contract without an owner,
2021      * thereby removing any functionality that is only available to the owner.
2022      */
2023     function renounceOwnership() public virtual onlyOwner {
2024         _transferOwnership(address(0));
2025     }
2026 
2027     /**
2028      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2029      * Can only be called by the current owner.
2030      */
2031     function transferOwnership(address newOwner) public virtual onlyOwner {
2032         require(newOwner != address(0), "Ownable: new owner is the zero address");
2033         _transferOwnership(newOwner);
2034     }
2035 
2036     /**
2037      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2038      * Internal function without access restriction.
2039      */
2040     function _transferOwnership(address newOwner) internal virtual {
2041         address oldOwner = _owner;
2042         _owner = newOwner;
2043         emit OwnershipTransferred(oldOwner, newOwner);
2044     }
2045 }
2046 
2047 // File: @openzeppelin/contracts/security/Pausable.sol
2048 
2049 
2050 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
2051 
2052 pragma solidity ^0.8.0;
2053 
2054 
2055 /**
2056  * @dev Contract module which allows children to implement an emergency stop
2057  * mechanism that can be triggered by an authorized account.
2058  *
2059  * This module is used through inheritance. It will make available the
2060  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2061  * the functions of your contract. Note that they will not be pausable by
2062  * simply including this module, only once the modifiers are put in place.
2063  */
2064 abstract contract Pausable is Context {
2065     /**
2066      * @dev Emitted when the pause is triggered by `account`.
2067      */
2068     event Paused(address account);
2069 
2070     /**
2071      * @dev Emitted when the pause is lifted by `account`.
2072      */
2073     event Unpaused(address account);
2074 
2075     bool private _paused;
2076 
2077     /**
2078      * @dev Initializes the contract in unpaused state.
2079      */
2080     constructor() {
2081         _paused = false;
2082     }
2083 
2084     /**
2085      * @dev Modifier to make a function callable only when the contract is not paused.
2086      *
2087      * Requirements:
2088      *
2089      * - The contract must not be paused.
2090      */
2091     modifier whenNotPaused() {
2092         _requireNotPaused();
2093         _;
2094     }
2095 
2096     /**
2097      * @dev Modifier to make a function callable only when the contract is paused.
2098      *
2099      * Requirements:
2100      *
2101      * - The contract must be paused.
2102      */
2103     modifier whenPaused() {
2104         _requirePaused();
2105         _;
2106     }
2107 
2108     /**
2109      * @dev Returns true if the contract is paused, and false otherwise.
2110      */
2111     function paused() public view virtual returns (bool) {
2112         return _paused;
2113     }
2114 
2115     /**
2116      * @dev Throws if the contract is paused.
2117      */
2118     function _requireNotPaused() internal view virtual {
2119         require(!paused(), "Pausable: paused");
2120     }
2121 
2122     /**
2123      * @dev Throws if the contract is not paused.
2124      */
2125     function _requirePaused() internal view virtual {
2126         require(paused(), "Pausable: not paused");
2127     }
2128 
2129     /**
2130      * @dev Triggers stopped state.
2131      *
2132      * Requirements:
2133      *
2134      * - The contract must not be paused.
2135      */
2136     function _pause() internal virtual whenNotPaused {
2137         _paused = true;
2138         emit Paused(_msgSender());
2139     }
2140 
2141     /**
2142      * @dev Returns to normal state.
2143      *
2144      * Requirements:
2145      *
2146      * - The contract must be paused.
2147      */
2148     function _unpause() internal virtual whenPaused {
2149         _paused = false;
2150         emit Unpaused(_msgSender());
2151     }
2152 }
2153 
2154 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2155 
2156 
2157 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2158 
2159 pragma solidity ^0.8.0;
2160 
2161 /**
2162  * @dev Contract module that helps prevent reentrant calls to a function.
2163  *
2164  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2165  * available, which can be applied to functions to make sure there are no nested
2166  * (reentrant) calls to them.
2167  *
2168  * Note that because there is a single `nonReentrant` guard, functions marked as
2169  * `nonReentrant` may not call one another. This can be worked around by making
2170  * those functions `private`, and then adding `external` `nonReentrant` entry
2171  * points to them.
2172  *
2173  * TIP: If you would like to learn more about reentrancy and alternative ways
2174  * to protect against it, check out our blog post
2175  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2176  */
2177 abstract contract ReentrancyGuard {
2178     // Booleans are more expensive than uint256 or any type that takes up a full
2179     // word because each write operation emits an extra SLOAD to first read the
2180     // slot's contents, replace the bits taken up by the boolean, and then write
2181     // back. This is the compiler's defense against contract upgrades and
2182     // pointer aliasing, and it cannot be disabled.
2183 
2184     // The values being non-zero value makes deployment a bit more expensive,
2185     // but in exchange the refund on every call to nonReentrant will be lower in
2186     // amount. Since refunds are capped to a percentage of the total
2187     // transaction's gas, it is best to keep them low in cases like this one, to
2188     // increase the likelihood of the full refund coming into effect.
2189     uint256 private constant _NOT_ENTERED = 1;
2190     uint256 private constant _ENTERED = 2;
2191 
2192     uint256 private _status;
2193 
2194     constructor() {
2195         _status = _NOT_ENTERED;
2196     }
2197 
2198     /**
2199      * @dev Prevents a contract from calling itself, directly or indirectly.
2200      * Calling a `nonReentrant` function from another `nonReentrant`
2201      * function is not supported. It is possible to prevent this from happening
2202      * by making the `nonReentrant` function external, and making it call a
2203      * `private` function that does the actual work.
2204      */
2205     modifier nonReentrant() {
2206         // On the first call to nonReentrant, _notEntered will be true
2207         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2208 
2209         // Any calls to nonReentrant after this point will fail
2210         _status = _ENTERED;
2211 
2212         _;
2213 
2214         // By storing the original value once again, a refund is triggered (see
2215         // https://eips.ethereum.org/EIPS/eip-2200)
2216         _status = _NOT_ENTERED;
2217     }
2218 }
2219 
2220 // File: contracts/OkayHuman/OkayHumanNFT.sol
2221 
2222 
2223 
2224 pragma solidity ^0.8.0;
2225 
2226 
2227 
2228 
2229 
2230 
2231 
2232 
2233 
2234 
2235 contract OkayHumans is ReentrancyGuard, Pausable, ERC721Enumerable, Ownable, IERC721Receiver {
2236     using Counters for Counters.Counter;
2237     using Strings for uint256;
2238     using EnumerableSet for EnumerableSet.UintSet;
2239 
2240     /* ------------------------ NFT Minting ------------------------- */
2241     address payable private _PaymentAddress;
2242     address payable private _DevAddress;
2243 
2244     uint256 public MAX_SUPPLY = 3333;
2245     uint256 public FREE_SUPPLY = 888;
2246     uint256 public PUBLIC_PRICE = 0.033 ether;
2247     
2248     uint256 public PRESALE_MINT_LIMIT = 1;
2249     uint256 public PUBLIC_MINT_LIMIT = 20;
2250     
2251     bytes32 public _whitelistRoot;
2252     mapping (address => bool) public MAP_WHITELIST;
2253     mapping(address => uint256) public MAP_PRESALE_MINT_COUNT;
2254     mapping(address => uint256) public MAP_PUBLIC_MINT_COUNT;
2255 
2256     uint256 public SALE_STEP = 0; // 0: NONE, 1: PRSALE, 2: PUBLIC
2257     bool public _revealEnabled = false;
2258     
2259     string private _tokenBaseURI = "";
2260     string private _unrevealURI = "";
2261     
2262     Counters.Counter internal _publicCounter;
2263 
2264     /* ------------------------ NFT Staking ------------------------- */
2265     struct UserInfo {
2266         uint256 balance;
2267         uint256 rewards;
2268         uint256 lastUpdated;
2269     }
2270     mapping(address => UserInfo) public userInfo;
2271     mapping(address => EnumerableSet.UintSet) private userBlanaces;
2272     address[] public stakerList;
2273 
2274     IERC20 public rewardToken;
2275     uint256 public dailyTokenRewards = 0.5 ether;
2276     uint256 public minterTokenRewards = 300 ether;
2277     /* --------------------------------------------------------------------------------- */
2278     
2279     constructor(address _rewardToken, address _paymentAddress) ERC721("Okay Humans NFT", "OKHM") {
2280         _PaymentAddress = payable(_paymentAddress);
2281         _DevAddress = payable(msg.sender);
2282         rewardToken = IERC20(_rewardToken);
2283     }
2284 
2285     function setPaymentAddress(address paymentAddress) external onlyOwner {
2286         _PaymentAddress = payable(paymentAddress);
2287     }
2288 
2289     function setRewardToken(address rewardTokenAddress) external onlyOwner {
2290         rewardToken = IERC20(rewardTokenAddress);
2291     }
2292 
2293     function setRewardsAmount(uint256 dailyRewards, uint256 minterRewards) external onlyOwner {
2294         dailyTokenRewards = dailyRewards;
2295         minterTokenRewards = minterRewards;
2296     }
2297 
2298     function setSaleStep(uint256 _saleStep) external onlyOwner {
2299         SALE_STEP = _saleStep;
2300     }
2301 
2302     function setRevealEnabled(bool bEnable) external onlyOwner {
2303         _revealEnabled = bEnable;
2304     }
2305 
2306     function setWhiteListRoot(bytes32 root) external onlyOwner {
2307         _whitelistRoot = root;
2308     }
2309 
2310     function setWhiteList(address[] memory airdropAddress, bool bFlag) external onlyOwner {
2311         for (uint256 k = 0; k < airdropAddress.length; k++) {
2312             MAP_WHITELIST[airdropAddress[k]] = bFlag;
2313         }
2314     }
2315 
2316     // Verify that a given leaf is in the tree.
2317     function isWhiteListed(bytes32 _leafNode, bytes32[] memory proof) internal view returns (bool) {
2318         return MerkleProof.verify(proof, _whitelistRoot, _leafNode);
2319     }
2320 
2321     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
2322     function toLeaf(address account, uint256 index, uint256 amount) internal pure returns (bytes32) {
2323         return keccak256(abi.encodePacked(index, account, amount));
2324     }
2325 
2326     function setMintPrice(uint256 publicMintPrice) external onlyOwner {
2327         PUBLIC_PRICE = publicMintPrice;
2328     }
2329 
2330     function setMaxSupply(uint256 maxSupply, uint256 freeSupply) external onlyOwner {
2331         MAX_SUPPLY = maxSupply;
2332         FREE_SUPPLY = freeSupply;
2333     }
2334 
2335     function setMintLimit(uint256 presaleMintLimit, uint256 publicMintLimit) external onlyOwner {
2336         PRESALE_MINT_LIMIT = presaleMintLimit;
2337         PUBLIC_MINT_LIMIT = publicMintLimit;
2338     }
2339 
2340     function setUnrevealURI(string memory unrevealURI) external onlyOwner {
2341         _unrevealURI = unrevealURI;
2342     }
2343 
2344     function setBaseURI(string memory baseURI) external onlyOwner {
2345         _tokenBaseURI = baseURI;
2346     }
2347 
2348     function airdrop(address[] memory airdropAddress, uint256 numberOfTokens) external onlyOwner {
2349         require(_publicCounter.current() + airdropAddress.length * numberOfTokens <= MAX_SUPPLY,"Purchase would exceed MAX_SUPPLY");
2350 
2351         for (uint256 k = 0; k < airdropAddress.length; k++) {
2352             for (uint256 i = 0; i < numberOfTokens; i++) {
2353                 uint256 tokenId = _publicCounter.current();
2354                 _publicCounter.increment();
2355                 if (!_exists(tokenId)) {
2356                     _safeMint(airdropAddress[k], tokenId);
2357                 }
2358             }
2359         }
2360     }
2361 
2362     function purchase(uint256 numberOfTokens) external payable {
2363         require(_publicCounter.current() + numberOfTokens <= MAX_SUPPLY,"Purchase would exceed MAX_SUPPLY");
2364 
2365         require(SALE_STEP == 2,"Public Mint is not activated.");
2366 
2367         require(PUBLIC_PRICE * numberOfTokens <= msg.value,"ETH amount is not sufficient");
2368 
2369         MAP_PUBLIC_MINT_COUNT[_msgSender()] = MAP_PUBLIC_MINT_COUNT[_msgSender()] + numberOfTokens;
2370         
2371         require(MAP_PUBLIC_MINT_COUNT[_msgSender()] <= PUBLIC_MINT_LIMIT,"Overflow for PUBLIC_MINT_LIMIT");
2372 
2373         uint256 devFee = msg.value / 20;
2374         _DevAddress.transfer(devFee);
2375         _PaymentAddress.transfer(msg.value - devFee);
2376         
2377         for (uint256 i = 0; i < numberOfTokens; i++) {
2378             uint256 tokenId = _publicCounter.current();
2379             _publicCounter.increment();
2380             if (!_exists(tokenId)) {
2381                 _safeMint(_msgSender(), tokenId);
2382             }
2383         }
2384 
2385         rewardToken.transfer(_msgSender(), numberOfTokens * minterTokenRewards);
2386     }
2387 
2388     function presale(uint256 numberOfTokens, uint256 index, uint256 amount, bytes32[] calldata proof) external {
2389         require(_publicCounter.current() + numberOfTokens <= FREE_SUPPLY,"Purchase would exceed FREE_SUPPLY");
2390 
2391         require(isWhiteListed(toLeaf(_msgSender(), index, amount), proof) || MAP_WHITELIST[_msgSender()], "Invalid proof");
2392 
2393         require(SALE_STEP == 1,"Presale Round is not activated.");
2394 
2395         MAP_PRESALE_MINT_COUNT[_msgSender()] = MAP_PRESALE_MINT_COUNT[_msgSender()] + numberOfTokens;
2396         
2397         require(MAP_PRESALE_MINT_COUNT[_msgSender()] <= PRESALE_MINT_LIMIT,"Overflow for PRESALE_MINT_LIMIT");
2398 
2399         for (uint256 i = 0; i < numberOfTokens; i++) {
2400             uint256 tokenId = _publicCounter.current();
2401             _publicCounter.increment();
2402             if (!_exists(tokenId)) {
2403                 _safeMint(_msgSender(), tokenId);
2404             }
2405         }
2406 
2407         rewardToken.transfer(_msgSender(), numberOfTokens * minterTokenRewards);
2408     }
2409 
2410     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
2411         require(_exists(tokenId), "Token does not exist");
2412 
2413         if (_revealEnabled) {
2414             return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
2415         }
2416 
2417         return _unrevealURI;
2418     }
2419 
2420     function withdraw() external onlyOwner {
2421         uint256 balance = address(this).balance;
2422         payable(_msgSender()).transfer(balance);
2423     }
2424 
2425     function withdrawToken() external onlyOwner {
2426         uint256 balance = rewardToken.balanceOf(address(this));
2427         rewardToken.transfer(_msgSender(), balance);
2428     }
2429 
2430     function userHoldNFTs(address _owner) public view returns(uint256[] memory){
2431         uint256 tokenCount = balanceOf(_owner);
2432         uint256[] memory result = new uint256[](tokenCount);
2433         for (uint256 index = 0; index < tokenCount; index++) {
2434             result[index] = tokenOfOwnerByIndex(_owner, index);
2435         }
2436         return result;
2437     }
2438 
2439     /* --------------------------------------------------------------------- */
2440     function addStakerList(address _user) internal{
2441         for (uint256 i = 0; i < stakerList.length; i++) {
2442             if (stakerList[i] == _user)
2443                 return;
2444         }
2445         stakerList.push(_user);
2446     }
2447 
2448     function userStakeInfo(address _owner) external view returns(UserInfo memory){
2449          return userInfo[_owner];
2450     }
2451     
2452     function userStakedNFTs(address _owner) public view returns(uint256[] memory){
2453         uint256 tokenCount = userBlanaces[_owner].length();
2454         uint256[] memory result = new uint256[](tokenCount);
2455         for (uint256 index = 0; index < tokenCount; index++) {
2456             result[index] = userBlanaces[_owner].at(index);
2457         }
2458         return result;
2459     }
2460 
2461     function userStakedNFTCount(address _owner) public view returns(uint256){
2462          return userBlanaces[_owner].length();
2463     }
2464 
2465     function isStaked( address account ,uint256 tokenId) public view returns (bool) {
2466         return userBlanaces[account].contains(tokenId);
2467     }
2468 
2469     function earned(address account) public view returns (uint256) {
2470         uint256 blockTime = block.timestamp;
2471 
2472         UserInfo memory user = userInfo[account];
2473 
2474         uint256 amount = (blockTime - user.lastUpdated) * userStakedNFTCount(account) * dailyTokenRewards / 1 days;
2475 
2476         return user.rewards + amount;
2477     }
2478 
2479     function totalEarned() public view returns (uint256) {
2480         uint256 totalEarning = 0;
2481         for (uint256 i = 0; i < stakerList.length; i++) {
2482             totalEarning += earned(stakerList[i]);
2483         }
2484         return totalEarning;
2485     }
2486 
2487     function totalStakedCount() public view returns (uint256) {
2488         uint256 totalCount = 0;
2489         for (uint256 i = 0; i < stakerList.length; i++) {
2490             totalCount += userStakedNFTCount(stakerList[i]);
2491         }
2492         return totalCount;
2493     }
2494 
2495     function totalStakedMembers() public view returns (uint256) {
2496         uint256 totalMembers = 0;
2497         for (uint256 i = 0; i < stakerList.length; i++) {
2498             if (userStakedNFTCount(stakerList[i]) > 0) totalMembers += 1;
2499         }
2500         return totalMembers;
2501     }
2502 
2503     function stake( uint256[] memory  tokenIdList) public nonReentrant whenNotPaused {
2504         UserInfo storage user = userInfo[_msgSender()];
2505         user.rewards = earned(_msgSender());
2506         user.lastUpdated = block.timestamp;
2507 
2508         addStakerList(_msgSender());
2509 
2510         for (uint256 i = 0; i < tokenIdList.length; i++) {
2511             safeTransferFrom(_msgSender(), address(this), tokenIdList[i]);
2512 
2513             userBlanaces[_msgSender()].add(tokenIdList[i]);
2514         }
2515     }
2516 
2517     function unstake( uint256[] memory  tokenIdList) public nonReentrant {
2518         UserInfo storage user = userInfo[_msgSender()];
2519         user.rewards = earned(_msgSender());
2520         user.lastUpdated = block.timestamp;
2521 
2522         for (uint256 i = 0; i < tokenIdList.length; i++) {
2523 
2524             require(isStaked(_msgSender(), tokenIdList[i]), "Not staked this nft");        
2525 
2526             _safeTransfer(address(this) , _msgSender(), tokenIdList[i], "");
2527 
2528             userBlanaces[_msgSender()].remove(tokenIdList[i]);
2529         }
2530     }
2531 
2532     function harvest() public nonReentrant {
2533         require(earned(_msgSender()) > 0, "Nothing Rewards");
2534         
2535         rewardToken.transfer(_msgSender(), earned(_msgSender()));
2536 
2537         UserInfo storage user = userInfo[_msgSender()];
2538         user.rewards = 0;
2539         user.lastUpdated = block.timestamp;
2540     }
2541 
2542     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
2543         return this.onERC721Received.selector;
2544     }
2545 
2546     receive() external payable {}
2547 }