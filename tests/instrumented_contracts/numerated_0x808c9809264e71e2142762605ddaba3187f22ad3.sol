1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Library for managing
88  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
89  * types.
90  *
91  * Sets have the following properties:
92  *
93  * - Elements are added, removed, and checked for existence in constant time
94  * (O(1)).
95  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
96  *
97  * ```
98  * contract Example {
99  *     // Add the library methods
100  *     using EnumerableSet for EnumerableSet.AddressSet;
101  *
102  *     // Declare a set state variable
103  *     EnumerableSet.AddressSet private mySet;
104  * }
105  * ```
106  *
107  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
108  * and `uint256` (`UintSet`) are supported.
109  *
110  * [WARNING]
111  * ====
112  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
113  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
114  *
115  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
116  * ====
117  */
118 library EnumerableSet {
119     // To implement this library for multiple types with as little code
120     // repetition as possible, we write it in terms of a generic Set type with
121     // bytes32 values.
122     // The Set implementation uses private functions, and user-facing
123     // implementations (such as AddressSet) are just wrappers around the
124     // underlying Set.
125     // This means that we can only create new EnumerableSets for types that fit
126     // in bytes32.
127 
128     struct Set {
129         // Storage of set values
130         bytes32[] _values;
131         // Position of the value in the `values` array, plus 1 because index 0
132         // means a value is not in the set.
133         mapping(bytes32 => uint256) _indexes;
134     }
135 
136     /**
137      * @dev Add a value to a set. O(1).
138      *
139      * Returns true if the value was added to the set, that is if it was not
140      * already present.
141      */
142     function _add(Set storage set, bytes32 value) private returns (bool) {
143         if (!_contains(set, value)) {
144             set._values.push(value);
145             // The value is stored at length-1, but we add 1 to all indexes
146             // and use 0 as a sentinel value
147             set._indexes[value] = set._values.length;
148             return true;
149         } else {
150             return false;
151         }
152     }
153 
154     /**
155      * @dev Removes a value from a set. O(1).
156      *
157      * Returns true if the value was removed from the set, that is if it was
158      * present.
159      */
160     function _remove(Set storage set, bytes32 value) private returns (bool) {
161         // We read and store the value's index to prevent multiple reads from the same storage slot
162         uint256 valueIndex = set._indexes[value];
163 
164         if (valueIndex != 0) {
165             // Equivalent to contains(set, value)
166             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
167             // the array, and then remove the last element (sometimes called as 'swap and pop').
168             // This modifies the order of the array, as noted in {at}.
169 
170             uint256 toDeleteIndex = valueIndex - 1;
171             uint256 lastIndex = set._values.length - 1;
172 
173             if (lastIndex != toDeleteIndex) {
174                 bytes32 lastValue = set._values[lastIndex];
175 
176                 // Move the last value to the index where the value to delete is
177                 set._values[toDeleteIndex] = lastValue;
178                 // Update the index for the moved value
179                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
180             }
181 
182             // Delete the slot where the moved value was stored
183             set._values.pop();
184 
185             // Delete the index for the deleted slot
186             delete set._indexes[value];
187 
188             return true;
189         } else {
190             return false;
191         }
192     }
193 
194     /**
195      * @dev Returns true if the value is in the set. O(1).
196      */
197     function _contains(Set storage set, bytes32 value) private view returns (bool) {
198         return set._indexes[value] != 0;
199     }
200 
201     /**
202      * @dev Returns the number of values on the set. O(1).
203      */
204     function _length(Set storage set) private view returns (uint256) {
205         return set._values.length;
206     }
207 
208     /**
209      * @dev Returns the value stored at position `index` in the set. O(1).
210      *
211      * Note that there are no guarantees on the ordering of values inside the
212      * array, and it may change when more values are added or removed.
213      *
214      * Requirements:
215      *
216      * - `index` must be strictly less than {length}.
217      */
218     function _at(Set storage set, uint256 index) private view returns (bytes32) {
219         return set._values[index];
220     }
221 
222     /**
223      * @dev Return the entire set in an array
224      *
225      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
226      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
227      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
228      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
229      */
230     function _values(Set storage set) private view returns (bytes32[] memory) {
231         return set._values;
232     }
233 
234     // Bytes32Set
235 
236     struct Bytes32Set {
237         Set _inner;
238     }
239 
240     /**
241      * @dev Add a value to a set. O(1).
242      *
243      * Returns true if the value was added to the set, that is if it was not
244      * already present.
245      */
246     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
247         return _add(set._inner, value);
248     }
249 
250     /**
251      * @dev Removes a value from a set. O(1).
252      *
253      * Returns true if the value was removed from the set, that is if it was
254      * present.
255      */
256     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
257         return _remove(set._inner, value);
258     }
259 
260     /**
261      * @dev Returns true if the value is in the set. O(1).
262      */
263     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
264         return _contains(set._inner, value);
265     }
266 
267     /**
268      * @dev Returns the number of values in the set. O(1).
269      */
270     function length(Bytes32Set storage set) internal view returns (uint256) {
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
284     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
285         return _at(set._inner, index);
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
296     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
297         return _values(set._inner);
298     }
299 
300     // AddressSet
301 
302     struct AddressSet {
303         Set _inner;
304     }
305 
306     /**
307      * @dev Add a value to a set. O(1).
308      *
309      * Returns true if the value was added to the set, that is if it was not
310      * already present.
311      */
312     function add(AddressSet storage set, address value) internal returns (bool) {
313         return _add(set._inner, bytes32(uint256(uint160(value))));
314     }
315 
316     /**
317      * @dev Removes a value from a set. O(1).
318      *
319      * Returns true if the value was removed from the set, that is if it was
320      * present.
321      */
322     function remove(AddressSet storage set, address value) internal returns (bool) {
323         return _remove(set._inner, bytes32(uint256(uint160(value))));
324     }
325 
326     /**
327      * @dev Returns true if the value is in the set. O(1).
328      */
329     function contains(AddressSet storage set, address value) internal view returns (bool) {
330         return _contains(set._inner, bytes32(uint256(uint160(value))));
331     }
332 
333     /**
334      * @dev Returns the number of values in the set. O(1).
335      */
336     function length(AddressSet storage set) internal view returns (uint256) {
337         return _length(set._inner);
338     }
339 
340     /**
341      * @dev Returns the value stored at position `index` in the set. O(1).
342      *
343      * Note that there are no guarantees on the ordering of values inside the
344      * array, and it may change when more values are added or removed.
345      *
346      * Requirements:
347      *
348      * - `index` must be strictly less than {length}.
349      */
350     function at(AddressSet storage set, uint256 index) internal view returns (address) {
351         return address(uint160(uint256(_at(set._inner, index))));
352     }
353 
354     /**
355      * @dev Return the entire set in an array
356      *
357      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
358      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
359      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
360      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
361      */
362     function values(AddressSet storage set) internal view returns (address[] memory) {
363         bytes32[] memory store = _values(set._inner);
364         address[] memory result;
365 
366         /// @solidity memory-safe-assembly
367         assembly {
368             result := store
369         }
370 
371         return result;
372     }
373 
374     // UintSet
375 
376     struct UintSet {
377         Set _inner;
378     }
379 
380     /**
381      * @dev Add a value to a set. O(1).
382      *
383      * Returns true if the value was added to the set, that is if it was not
384      * already present.
385      */
386     function add(UintSet storage set, uint256 value) internal returns (bool) {
387         return _add(set._inner, bytes32(value));
388     }
389 
390     /**
391      * @dev Removes a value from a set. O(1).
392      *
393      * Returns true if the value was removed from the set, that is if it was
394      * present.
395      */
396     function remove(UintSet storage set, uint256 value) internal returns (bool) {
397         return _remove(set._inner, bytes32(value));
398     }
399 
400     /**
401      * @dev Returns true if the value is in the set. O(1).
402      */
403     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
404         return _contains(set._inner, bytes32(value));
405     }
406 
407     /**
408      * @dev Returns the number of values on the set. O(1).
409      */
410     function length(UintSet storage set) internal view returns (uint256) {
411         return _length(set._inner);
412     }
413 
414     /**
415      * @dev Returns the value stored at position `index` in the set. O(1).
416      *
417      * Note that there are no guarantees on the ordering of values inside the
418      * array, and it may change when more values are added or removed.
419      *
420      * Requirements:
421      *
422      * - `index` must be strictly less than {length}.
423      */
424     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
425         return uint256(_at(set._inner, index));
426     }
427 
428     /**
429      * @dev Return the entire set in an array
430      *
431      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
432      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
433      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
434      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
435      */
436     function values(UintSet storage set) internal view returns (uint256[] memory) {
437         bytes32[] memory store = _values(set._inner);
438         uint256[] memory result;
439 
440         /// @solidity memory-safe-assembly
441         assembly {
442             result := store
443         }
444 
445         return result;
446     }
447 }
448 
449 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
450 
451 
452 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Contract module that helps prevent reentrant calls to a function.
458  *
459  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
460  * available, which can be applied to functions to make sure there are no nested
461  * (reentrant) calls to them.
462  *
463  * Note that because there is a single `nonReentrant` guard, functions marked as
464  * `nonReentrant` may not call one another. This can be worked around by making
465  * those functions `private`, and then adding `external` `nonReentrant` entry
466  * points to them.
467  *
468  * TIP: If you would like to learn more about reentrancy and alternative ways
469  * to protect against it, check out our blog post
470  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
471  */
472 abstract contract ReentrancyGuard {
473     // Booleans are more expensive than uint256 or any type that takes up a full
474     // word because each write operation emits an extra SLOAD to first read the
475     // slot's contents, replace the bits taken up by the boolean, and then write
476     // back. This is the compiler's defense against contract upgrades and
477     // pointer aliasing, and it cannot be disabled.
478 
479     // The values being non-zero value makes deployment a bit more expensive,
480     // but in exchange the refund on every call to nonReentrant will be lower in
481     // amount. Since refunds are capped to a percentage of the total
482     // transaction's gas, it is best to keep them low in cases like this one, to
483     // increase the likelihood of the full refund coming into effect.
484     uint256 private constant _NOT_ENTERED = 1;
485     uint256 private constant _ENTERED = 2;
486 
487     uint256 private _status;
488 
489     constructor() {
490         _status = _NOT_ENTERED;
491     }
492 
493     /**
494      * @dev Prevents a contract from calling itself, directly or indirectly.
495      * Calling a `nonReentrant` function from another `nonReentrant`
496      * function is not supported. It is possible to prevent this from happening
497      * by making the `nonReentrant` function external, and making it call a
498      * `private` function that does the actual work.
499      */
500     modifier nonReentrant() {
501         // On the first call to nonReentrant, _notEntered will be true
502         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
503 
504         // Any calls to nonReentrant after this point will fail
505         _status = _ENTERED;
506 
507         _;
508 
509         // By storing the original value once again, a refund is triggered (see
510         // https://eips.ethereum.org/EIPS/eip-2200)
511         _status = _NOT_ENTERED;
512     }
513 }
514 
515 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
516 
517 
518 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev These functions deal with verification of Merkle Tree proofs.
524  *
525  * The proofs can be generated using the JavaScript library
526  * https://github.com/miguelmota/merkletreejs[merkletreejs].
527  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
528  *
529  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
530  *
531  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
532  * hashing, or use a hash function other than keccak256 for hashing leaves.
533  * This is because the concatenation of a sorted pair of internal nodes in
534  * the merkle tree could be reinterpreted as a leaf value.
535  */
536 library MerkleProof {
537     /**
538      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
539      * defined by `root`. For this, a `proof` must be provided, containing
540      * sibling hashes on the branch from the leaf to the root of the tree. Each
541      * pair of leaves and each pair of pre-images are assumed to be sorted.
542      */
543     function verify(
544         bytes32[] memory proof,
545         bytes32 root,
546         bytes32 leaf
547     ) internal pure returns (bool) {
548         return processProof(proof, leaf) == root;
549     }
550 
551     /**
552      * @dev Calldata version of {verify}
553      *
554      * _Available since v4.7._
555      */
556     function verifyCalldata(
557         bytes32[] calldata proof,
558         bytes32 root,
559         bytes32 leaf
560     ) internal pure returns (bool) {
561         return processProofCalldata(proof, leaf) == root;
562     }
563 
564     /**
565      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
566      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
567      * hash matches the root of the tree. When processing the proof, the pairs
568      * of leafs & pre-images are assumed to be sorted.
569      *
570      * _Available since v4.4._
571      */
572     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
573         bytes32 computedHash = leaf;
574         for (uint256 i = 0; i < proof.length; i++) {
575             computedHash = _hashPair(computedHash, proof[i]);
576         }
577         return computedHash;
578     }
579 
580     /**
581      * @dev Calldata version of {processProof}
582      *
583      * _Available since v4.7._
584      */
585     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
586         bytes32 computedHash = leaf;
587         for (uint256 i = 0; i < proof.length; i++) {
588             computedHash = _hashPair(computedHash, proof[i]);
589         }
590         return computedHash;
591     }
592 
593     /**
594      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
595      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
596      *
597      * _Available since v4.7._
598      */
599     function multiProofVerify(
600         bytes32[] memory proof,
601         bool[] memory proofFlags,
602         bytes32 root,
603         bytes32[] memory leaves
604     ) internal pure returns (bool) {
605         return processMultiProof(proof, proofFlags, leaves) == root;
606     }
607 
608     /**
609      * @dev Calldata version of {multiProofVerify}
610      *
611      * _Available since v4.7._
612      */
613     function multiProofVerifyCalldata(
614         bytes32[] calldata proof,
615         bool[] calldata proofFlags,
616         bytes32 root,
617         bytes32[] memory leaves
618     ) internal pure returns (bool) {
619         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
620     }
621 
622     /**
623      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
624      * consuming from one or the other at each step according to the instructions given by
625      * `proofFlags`.
626      *
627      * _Available since v4.7._
628      */
629     function processMultiProof(
630         bytes32[] memory proof,
631         bool[] memory proofFlags,
632         bytes32[] memory leaves
633     ) internal pure returns (bytes32 merkleRoot) {
634         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
635         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
636         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
637         // the merkle tree.
638         uint256 leavesLen = leaves.length;
639         uint256 totalHashes = proofFlags.length;
640 
641         // Check proof validity.
642         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
643 
644         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
645         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
646         bytes32[] memory hashes = new bytes32[](totalHashes);
647         uint256 leafPos = 0;
648         uint256 hashPos = 0;
649         uint256 proofPos = 0;
650         // At each step, we compute the next hash using two values:
651         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
652         //   get the next hash.
653         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
654         //   `proof` array.
655         for (uint256 i = 0; i < totalHashes; i++) {
656             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
657             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
658             hashes[i] = _hashPair(a, b);
659         }
660 
661         if (totalHashes > 0) {
662             return hashes[totalHashes - 1];
663         } else if (leavesLen > 0) {
664             return leaves[0];
665         } else {
666             return proof[0];
667         }
668     }
669 
670     /**
671      * @dev Calldata version of {processMultiProof}
672      *
673      * _Available since v4.7._
674      */
675     function processMultiProofCalldata(
676         bytes32[] calldata proof,
677         bool[] calldata proofFlags,
678         bytes32[] memory leaves
679     ) internal pure returns (bytes32 merkleRoot) {
680         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
681         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
682         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
683         // the merkle tree.
684         uint256 leavesLen = leaves.length;
685         uint256 totalHashes = proofFlags.length;
686 
687         // Check proof validity.
688         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
689 
690         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
691         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
692         bytes32[] memory hashes = new bytes32[](totalHashes);
693         uint256 leafPos = 0;
694         uint256 hashPos = 0;
695         uint256 proofPos = 0;
696         // At each step, we compute the next hash using two values:
697         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
698         //   get the next hash.
699         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
700         //   `proof` array.
701         for (uint256 i = 0; i < totalHashes; i++) {
702             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
703             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
704             hashes[i] = _hashPair(a, b);
705         }
706 
707         if (totalHashes > 0) {
708             return hashes[totalHashes - 1];
709         } else if (leavesLen > 0) {
710             return leaves[0];
711         } else {
712             return proof[0];
713         }
714     }
715 
716     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
717         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
718     }
719 
720     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
721         /// @solidity memory-safe-assembly
722         assembly {
723             mstore(0x00, a)
724             mstore(0x20, b)
725             value := keccak256(0x00, 0x40)
726         }
727     }
728 }
729 
730 // File: @openzeppelin/contracts/utils/Context.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 /**
738  * @dev Provides information about the current execution context, including the
739  * sender of the transaction and its data. While these are generally available
740  * via msg.sender and msg.data, they should not be accessed in such a direct
741  * manner, since when dealing with meta-transactions the account sending and
742  * paying for execution may not be the actual sender (as far as an application
743  * is concerned).
744  *
745  * This contract is only required for intermediate, library-like contracts.
746  */
747 abstract contract Context {
748     function _msgSender() internal view virtual returns (address) {
749         return msg.sender;
750     }
751 
752     function _msgData() internal view virtual returns (bytes calldata) {
753         return msg.data;
754     }
755 }
756 
757 // File: @openzeppelin/contracts/access/Ownable.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @dev Contract module which provides a basic access control mechanism, where
767  * there is an account (an owner) that can be granted exclusive access to
768  * specific functions.
769  *
770  * By default, the owner account will be the one that deploys the contract. This
771  * can later be changed with {transferOwnership}.
772  *
773  * This module is used through inheritance. It will make available the modifier
774  * `onlyOwner`, which can be applied to your functions to restrict their use to
775  * the owner.
776  */
777 abstract contract Ownable is Context {
778     address private _owner;
779 
780     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
781 
782     /**
783      * @dev Initializes the contract setting the deployer as the initial owner.
784      */
785     constructor() {
786         _transferOwnership(_msgSender());
787     }
788 
789     /**
790      * @dev Throws if called by any account other than the owner.
791      */
792     modifier onlyOwner() {
793         _checkOwner();
794         _;
795     }
796 
797     /**
798      * @dev Returns the address of the current owner.
799      */
800     function owner() public view virtual returns (address) {
801         return _owner;
802     }
803 
804     /**
805      * @dev Throws if the sender is not the owner.
806      */
807     function _checkOwner() internal view virtual {
808         require(owner() == _msgSender(), "Ownable: caller is not the owner");
809     }
810 
811     /**
812      * @dev Leaves the contract without owner. It will not be possible to call
813      * `onlyOwner` functions anymore. Can only be called by the current owner.
814      *
815      * NOTE: Renouncing ownership will leave the contract without an owner,
816      * thereby removing any functionality that is only available to the owner.
817      */
818     function renounceOwnership() public virtual onlyOwner {
819         _transferOwnership(address(0));
820     }
821 
822     /**
823      * @dev Transfers ownership of the contract to a new account (`newOwner`).
824      * Can only be called by the current owner.
825      */
826     function transferOwnership(address newOwner) public virtual onlyOwner {
827         require(newOwner != address(0), "Ownable: new owner is the zero address");
828         _transferOwnership(newOwner);
829     }
830 
831     /**
832      * @dev Transfers ownership of the contract to a new account (`newOwner`).
833      * Internal function without access restriction.
834      */
835     function _transferOwnership(address newOwner) internal virtual {
836         address oldOwner = _owner;
837         _owner = newOwner;
838         emit OwnershipTransferred(oldOwner, newOwner);
839     }
840 }
841 
842 // File: erc721a/contracts/IERC721A.sol
843 
844 
845 // ERC721A Contracts v4.2.3
846 // Creator: Chiru Labs
847 
848 pragma solidity ^0.8.4;
849 
850 /**
851  * @dev Interface of ERC721A.
852  */
853 interface IERC721A {
854     /**
855      * The caller must own the token or be an approved operator.
856      */
857     error ApprovalCallerNotOwnerNorApproved();
858 
859     /**
860      * The token does not exist.
861      */
862     error ApprovalQueryForNonexistentToken();
863 
864     /**
865      * Cannot query the balance for the zero address.
866      */
867     error BalanceQueryForZeroAddress();
868 
869     /**
870      * Cannot mint to the zero address.
871      */
872     error MintToZeroAddress();
873 
874     /**
875      * The quantity of tokens minted must be more than zero.
876      */
877     error MintZeroQuantity();
878 
879     /**
880      * The token does not exist.
881      */
882     error OwnerQueryForNonexistentToken();
883 
884     /**
885      * The caller must own the token or be an approved operator.
886      */
887     error TransferCallerNotOwnerNorApproved();
888 
889     /**
890      * The token must be owned by `from`.
891      */
892     error TransferFromIncorrectOwner();
893 
894     /**
895      * Cannot safely transfer to a contract that does not implement the
896      * ERC721Receiver interface.
897      */
898     error TransferToNonERC721ReceiverImplementer();
899 
900     /**
901      * Cannot transfer to the zero address.
902      */
903     error TransferToZeroAddress();
904 
905     /**
906      * The token does not exist.
907      */
908     error URIQueryForNonexistentToken();
909 
910     /**
911      * The `quantity` minted with ERC2309 exceeds the safety limit.
912      */
913     error MintERC2309QuantityExceedsLimit();
914 
915     /**
916      * The `extraData` cannot be set on an unintialized ownership slot.
917      */
918     error OwnershipNotInitializedForExtraData();
919 
920     // =============================================================
921     //                            STRUCTS
922     // =============================================================
923 
924     struct TokenOwnership {
925         // The address of the owner.
926         address addr;
927         // Stores the start time of ownership with minimal overhead for tokenomics.
928         uint64 startTimestamp;
929         // Whether the token has been burned.
930         bool burned;
931         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
932         uint24 extraData;
933     }
934 
935     // =============================================================
936     //                         TOKEN COUNTERS
937     // =============================================================
938 
939     /**
940      * @dev Returns the total number of tokens in existence.
941      * Burned tokens will reduce the count.
942      * To get the total number of tokens minted, please see {_totalMinted}.
943      */
944     function totalSupply() external view returns (uint256);
945 
946     // =============================================================
947     //                            IERC165
948     // =============================================================
949 
950     /**
951      * @dev Returns true if this contract implements the interface defined by
952      * `interfaceId`. See the corresponding
953      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
954      * to learn more about how these ids are created.
955      *
956      * This function call must use less than 30000 gas.
957      */
958     function supportsInterface(bytes4 interfaceId) external view returns (bool);
959 
960     // =============================================================
961     //                            IERC721
962     // =============================================================
963 
964     /**
965      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
966      */
967     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
968 
969     /**
970      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
971      */
972     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
973 
974     /**
975      * @dev Emitted when `owner` enables or disables
976      * (`approved`) `operator` to manage all of its assets.
977      */
978     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
979 
980     /**
981      * @dev Returns the number of tokens in `owner`'s account.
982      */
983     function balanceOf(address owner) external view returns (uint256 balance);
984 
985     /**
986      * @dev Returns the owner of the `tokenId` token.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      */
992     function ownerOf(uint256 tokenId) external view returns (address owner);
993 
994     /**
995      * @dev Safely transfers `tokenId` token from `from` to `to`,
996      * checking first that contract recipients are aware of the ERC721 protocol
997      * to prevent tokens from being forever locked.
998      *
999      * Requirements:
1000      *
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must exist and be owned by `from`.
1004      * - If the caller is not `from`, it must be have been allowed to move
1005      * this token by either {approve} or {setApprovalForAll}.
1006      * - If `to` refers to a smart contract, it must implement
1007      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes calldata data
1016     ) external payable;
1017 
1018     /**
1019      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) external payable;
1026 
1027     /**
1028      * @dev Transfers `tokenId` from `from` to `to`.
1029      *
1030      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1031      * whenever possible.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must be owned by `from`.
1038      * - If the caller is not `from`, it must be approved to move this token
1039      * by either {approve} or {setApprovalForAll}.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function transferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) external payable;
1048 
1049     /**
1050      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1051      * The approval is cleared when the token is transferred.
1052      *
1053      * Only a single account can be approved at a time, so approving the
1054      * zero address clears previous approvals.
1055      *
1056      * Requirements:
1057      *
1058      * - The caller must own the token or be an approved operator.
1059      * - `tokenId` must exist.
1060      *
1061      * Emits an {Approval} event.
1062      */
1063     function approve(address to, uint256 tokenId) external payable;
1064 
1065     /**
1066      * @dev Approve or remove `operator` as an operator for the caller.
1067      * Operators can call {transferFrom} or {safeTransferFrom}
1068      * for any token owned by the caller.
1069      *
1070      * Requirements:
1071      *
1072      * - The `operator` cannot be the caller.
1073      *
1074      * Emits an {ApprovalForAll} event.
1075      */
1076     function setApprovalForAll(address operator, bool _approved) external;
1077 
1078     /**
1079      * @dev Returns the account approved for `tokenId` token.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      */
1085     function getApproved(uint256 tokenId) external view returns (address operator);
1086 
1087     /**
1088      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1089      *
1090      * See {setApprovalForAll}.
1091      */
1092     function isApprovedForAll(address owner, address operator) external view returns (bool);
1093 
1094     // =============================================================
1095     //                        IERC721Metadata
1096     // =============================================================
1097 
1098     /**
1099      * @dev Returns the token collection name.
1100      */
1101     function name() external view returns (string memory);
1102 
1103     /**
1104      * @dev Returns the token collection symbol.
1105      */
1106     function symbol() external view returns (string memory);
1107 
1108     /**
1109      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1110      */
1111     function tokenURI(uint256 tokenId) external view returns (string memory);
1112 
1113     // =============================================================
1114     //                           IERC2309
1115     // =============================================================
1116 
1117     /**
1118      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1119      * (inclusive) is transferred from `from` to `to`, as defined in the
1120      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1121      *
1122      * See {_mintERC2309} for more details.
1123      */
1124     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1125 }
1126 
1127 // File: erc721a/contracts/ERC721A.sol
1128 
1129 
1130 // ERC721A Contracts v4.2.3
1131 // Creator: Chiru Labs
1132 
1133 pragma solidity ^0.8.4;
1134 
1135 
1136 /**
1137  * @dev Interface of ERC721 token receiver.
1138  */
1139 interface ERC721A__IERC721Receiver {
1140     function onERC721Received(
1141         address operator,
1142         address from,
1143         uint256 tokenId,
1144         bytes calldata data
1145     ) external returns (bytes4);
1146 }
1147 
1148 /**
1149  * @title ERC721A
1150  *
1151  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1152  * Non-Fungible Token Standard, including the Metadata extension.
1153  * Optimized for lower gas during batch mints.
1154  *
1155  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1156  * starting from `_startTokenId()`.
1157  *
1158  * Assumptions:
1159  *
1160  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1161  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1162  */
1163 contract ERC721A is IERC721A {
1164     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1165     struct TokenApprovalRef {
1166         address value;
1167     }
1168 
1169     // =============================================================
1170     //                           CONSTANTS
1171     // =============================================================
1172 
1173     // Mask of an entry in packed address data.
1174     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1175 
1176     // The bit position of `numberMinted` in packed address data.
1177     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1178 
1179     // The bit position of `numberBurned` in packed address data.
1180     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1181 
1182     // The bit position of `aux` in packed address data.
1183     uint256 private constant _BITPOS_AUX = 192;
1184 
1185     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1186     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1187 
1188     // The bit position of `startTimestamp` in packed ownership.
1189     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1190 
1191     // The bit mask of the `burned` bit in packed ownership.
1192     uint256 private constant _BITMASK_BURNED = 1 << 224;
1193 
1194     // The bit position of the `nextInitialized` bit in packed ownership.
1195     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1196 
1197     // The bit mask of the `nextInitialized` bit in packed ownership.
1198     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1199 
1200     // The bit position of `extraData` in packed ownership.
1201     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1202 
1203     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1204     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1205 
1206     // The mask of the lower 160 bits for addresses.
1207     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1208 
1209     // The maximum `quantity` that can be minted with {_mintERC2309}.
1210     // This limit is to prevent overflows on the address data entries.
1211     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1212     // is required to cause an overflow, which is unrealistic.
1213     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1214 
1215     // The `Transfer` event signature is given by:
1216     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1217     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1218         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1219 
1220     // =============================================================
1221     //                            STORAGE
1222     // =============================================================
1223 
1224     // The next token ID to be minted.
1225     uint256 private _currentIndex;
1226 
1227     // The number of tokens burned.
1228     uint256 private _burnCounter;
1229 
1230     // Token name
1231     string private _name;
1232 
1233     // Token symbol
1234     string private _symbol;
1235 
1236     // Mapping from token ID to ownership details
1237     // An empty struct value does not necessarily mean the token is unowned.
1238     // See {_packedOwnershipOf} implementation for details.
1239     //
1240     // Bits Layout:
1241     // - [0..159]   `addr`
1242     // - [160..223] `startTimestamp`
1243     // - [224]      `burned`
1244     // - [225]      `nextInitialized`
1245     // - [232..255] `extraData`
1246     mapping(uint256 => uint256) private _packedOwnerships;
1247 
1248     // Mapping owner address to address data.
1249     //
1250     // Bits Layout:
1251     // - [0..63]    `balance`
1252     // - [64..127]  `numberMinted`
1253     // - [128..191] `numberBurned`
1254     // - [192..255] `aux`
1255     mapping(address => uint256) private _packedAddressData;
1256 
1257     // Mapping from token ID to approved address.
1258     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1259 
1260     // Mapping from owner to operator approvals
1261     mapping(address => mapping(address => bool)) private _operatorApprovals;
1262 
1263     // =============================================================
1264     //                          CONSTRUCTOR
1265     // =============================================================
1266 
1267     constructor(string memory name_, string memory symbol_) {
1268         _name = name_;
1269         _symbol = symbol_;
1270         _currentIndex = _startTokenId();
1271     }
1272 
1273     // =============================================================
1274     //                   TOKEN COUNTING OPERATIONS
1275     // =============================================================
1276 
1277     /**
1278      * @dev Returns the starting token ID.
1279      * To change the starting token ID, please override this function.
1280      */
1281     function _startTokenId() internal view virtual returns (uint256) {
1282         return 0;
1283     }
1284 
1285     /**
1286      * @dev Returns the next token ID to be minted.
1287      */
1288     function _nextTokenId() internal view virtual returns (uint256) {
1289         return _currentIndex;
1290     }
1291 
1292     /**
1293      * @dev Returns the total number of tokens in existence.
1294      * Burned tokens will reduce the count.
1295      * To get the total number of tokens minted, please see {_totalMinted}.
1296      */
1297     function totalSupply() public view virtual override returns (uint256) {
1298         // Counter underflow is impossible as _burnCounter cannot be incremented
1299         // more than `_currentIndex - _startTokenId()` times.
1300         unchecked {
1301             return _currentIndex - _burnCounter - _startTokenId();
1302         }
1303     }
1304 
1305     /**
1306      * @dev Returns the total amount of tokens minted in the contract.
1307      */
1308     function _totalMinted() internal view virtual returns (uint256) {
1309         // Counter underflow is impossible as `_currentIndex` does not decrement,
1310         // and it is initialized to `_startTokenId()`.
1311         unchecked {
1312             return _currentIndex - _startTokenId();
1313         }
1314     }
1315 
1316     /**
1317      * @dev Returns the total number of tokens burned.
1318      */
1319     function _totalBurned() internal view virtual returns (uint256) {
1320         return _burnCounter;
1321     }
1322 
1323     // =============================================================
1324     //                    ADDRESS DATA OPERATIONS
1325     // =============================================================
1326 
1327     /**
1328      * @dev Returns the number of tokens in `owner`'s account.
1329      */
1330     function balanceOf(address owner) public view virtual override returns (uint256) {
1331         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1332         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1333     }
1334 
1335     /**
1336      * Returns the number of tokens minted by `owner`.
1337      */
1338     function _numberMinted(address owner) internal view returns (uint256) {
1339         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1340     }
1341 
1342     /**
1343      * Returns the number of tokens burned by or on behalf of `owner`.
1344      */
1345     function _numberBurned(address owner) internal view returns (uint256) {
1346         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1347     }
1348 
1349     /**
1350      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1351      */
1352     function _getAux(address owner) internal view returns (uint64) {
1353         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1354     }
1355 
1356     /**
1357      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1358      * If there are multiple variables, please pack them into a uint64.
1359      */
1360     function _setAux(address owner, uint64 aux) internal virtual {
1361         uint256 packed = _packedAddressData[owner];
1362         uint256 auxCasted;
1363         // Cast `aux` with assembly to avoid redundant masking.
1364         assembly {
1365             auxCasted := aux
1366         }
1367         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1368         _packedAddressData[owner] = packed;
1369     }
1370 
1371     // =============================================================
1372     //                            IERC165
1373     // =============================================================
1374 
1375     /**
1376      * @dev Returns true if this contract implements the interface defined by
1377      * `interfaceId`. See the corresponding
1378      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1379      * to learn more about how these ids are created.
1380      *
1381      * This function call must use less than 30000 gas.
1382      */
1383     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1384         // The interface IDs are constants representing the first 4 bytes
1385         // of the XOR of all function selectors in the interface.
1386         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1387         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1388         return
1389             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1390             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1391             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1392     }
1393 
1394     // =============================================================
1395     //                        IERC721Metadata
1396     // =============================================================
1397 
1398     /**
1399      * @dev Returns the token collection name.
1400      */
1401     function name() public view virtual override returns (string memory) {
1402         return _name;
1403     }
1404 
1405     /**
1406      * @dev Returns the token collection symbol.
1407      */
1408     function symbol() public view virtual override returns (string memory) {
1409         return _symbol;
1410     }
1411 
1412     /**
1413      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1414      */
1415     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1416         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1417 
1418         string memory baseURI = _baseURI();
1419         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1420     }
1421 
1422     /**
1423      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1424      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1425      * by default, it can be overridden in child contracts.
1426      */
1427     function _baseURI() internal view virtual returns (string memory) {
1428         return '';
1429     }
1430 
1431     // =============================================================
1432     //                     OWNERSHIPS OPERATIONS
1433     // =============================================================
1434 
1435     /**
1436      * @dev Returns the owner of the `tokenId` token.
1437      *
1438      * Requirements:
1439      *
1440      * - `tokenId` must exist.
1441      */
1442     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1443         return address(uint160(_packedOwnershipOf(tokenId)));
1444     }
1445 
1446     /**
1447      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1448      * It gradually moves to O(1) as tokens get transferred around over time.
1449      */
1450     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1451         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1452     }
1453 
1454     /**
1455      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1456      */
1457     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1458         return _unpackedOwnership(_packedOwnerships[index]);
1459     }
1460 
1461     /**
1462      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1463      */
1464     function _initializeOwnershipAt(uint256 index) internal virtual {
1465         if (_packedOwnerships[index] == 0) {
1466             _packedOwnerships[index] = _packedOwnershipOf(index);
1467         }
1468     }
1469 
1470     /**
1471      * Returns the packed ownership data of `tokenId`.
1472      */
1473     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1474         uint256 curr = tokenId;
1475 
1476         unchecked {
1477             if (_startTokenId() <= curr)
1478                 if (curr < _currentIndex) {
1479                     uint256 packed = _packedOwnerships[curr];
1480                     // If not burned.
1481                     if (packed & _BITMASK_BURNED == 0) {
1482                         // Invariant:
1483                         // There will always be an initialized ownership slot
1484                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1485                         // before an unintialized ownership slot
1486                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1487                         // Hence, `curr` will not underflow.
1488                         //
1489                         // We can directly compare the packed value.
1490                         // If the address is zero, packed will be zero.
1491                         while (packed == 0) {
1492                             packed = _packedOwnerships[--curr];
1493                         }
1494                         return packed;
1495                     }
1496                 }
1497         }
1498         revert OwnerQueryForNonexistentToken();
1499     }
1500 
1501     /**
1502      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1503      */
1504     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1505         ownership.addr = address(uint160(packed));
1506         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1507         ownership.burned = packed & _BITMASK_BURNED != 0;
1508         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1509     }
1510 
1511     /**
1512      * @dev Packs ownership data into a single uint256.
1513      */
1514     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1515         assembly {
1516             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1517             owner := and(owner, _BITMASK_ADDRESS)
1518             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1519             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1520         }
1521     }
1522 
1523     /**
1524      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1525      */
1526     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1527         // For branchless setting of the `nextInitialized` flag.
1528         assembly {
1529             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1530             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1531         }
1532     }
1533 
1534     // =============================================================
1535     //                      APPROVAL OPERATIONS
1536     // =============================================================
1537 
1538     /**
1539      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1540      * The approval is cleared when the token is transferred.
1541      *
1542      * Only a single account can be approved at a time, so approving the
1543      * zero address clears previous approvals.
1544      *
1545      * Requirements:
1546      *
1547      * - The caller must own the token or be an approved operator.
1548      * - `tokenId` must exist.
1549      *
1550      * Emits an {Approval} event.
1551      */
1552     function approve(address to, uint256 tokenId) public payable virtual override {
1553         address owner = ownerOf(tokenId);
1554 
1555         if (_msgSenderERC721A() != owner)
1556             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1557                 revert ApprovalCallerNotOwnerNorApproved();
1558             }
1559 
1560         _tokenApprovals[tokenId].value = to;
1561         emit Approval(owner, to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev Returns the account approved for `tokenId` token.
1566      *
1567      * Requirements:
1568      *
1569      * - `tokenId` must exist.
1570      */
1571     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1572         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1573 
1574         return _tokenApprovals[tokenId].value;
1575     }
1576 
1577     /**
1578      * @dev Approve or remove `operator` as an operator for the caller.
1579      * Operators can call {transferFrom} or {safeTransferFrom}
1580      * for any token owned by the caller.
1581      *
1582      * Requirements:
1583      *
1584      * - The `operator` cannot be the caller.
1585      *
1586      * Emits an {ApprovalForAll} event.
1587      */
1588     function setApprovalForAll(address operator, bool approved) public virtual override {
1589         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1590         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1591     }
1592 
1593     /**
1594      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1595      *
1596      * See {setApprovalForAll}.
1597      */
1598     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1599         return _operatorApprovals[owner][operator];
1600     }
1601 
1602     /**
1603      * @dev Returns whether `tokenId` exists.
1604      *
1605      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1606      *
1607      * Tokens start existing when they are minted. See {_mint}.
1608      */
1609     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1610         return
1611             _startTokenId() <= tokenId &&
1612             tokenId < _currentIndex && // If within bounds,
1613             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1614     }
1615 
1616     /**
1617      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1618      */
1619     function _isSenderApprovedOrOwner(
1620         address approvedAddress,
1621         address owner,
1622         address msgSender
1623     ) private pure returns (bool result) {
1624         assembly {
1625             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1626             owner := and(owner, _BITMASK_ADDRESS)
1627             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1628             msgSender := and(msgSender, _BITMASK_ADDRESS)
1629             // `msgSender == owner || msgSender == approvedAddress`.
1630             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1631         }
1632     }
1633 
1634     /**
1635      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1636      */
1637     function _getApprovedSlotAndAddress(uint256 tokenId)
1638         private
1639         view
1640         returns (uint256 approvedAddressSlot, address approvedAddress)
1641     {
1642         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1643         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1644         assembly {
1645             approvedAddressSlot := tokenApproval.slot
1646             approvedAddress := sload(approvedAddressSlot)
1647         }
1648     }
1649 
1650     // =============================================================
1651     //                      TRANSFER OPERATIONS
1652     // =============================================================
1653 
1654     /**
1655      * @dev Transfers `tokenId` from `from` to `to`.
1656      *
1657      * Requirements:
1658      *
1659      * - `from` cannot be the zero address.
1660      * - `to` cannot be the zero address.
1661      * - `tokenId` token must be owned by `from`.
1662      * - If the caller is not `from`, it must be approved to move this token
1663      * by either {approve} or {setApprovalForAll}.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function transferFrom(
1668         address from,
1669         address to,
1670         uint256 tokenId
1671     ) public payable virtual override {
1672         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1673 
1674         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1675 
1676         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1677 
1678         // The nested ifs save around 20+ gas over a compound boolean condition.
1679         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1680             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1681 
1682         if (to == address(0)) revert TransferToZeroAddress();
1683 
1684         _beforeTokenTransfers(from, to, tokenId, 1);
1685 
1686         // Clear approvals from the previous owner.
1687         assembly {
1688             if approvedAddress {
1689                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1690                 sstore(approvedAddressSlot, 0)
1691             }
1692         }
1693 
1694         // Underflow of the sender's balance is impossible because we check for
1695         // ownership above and the recipient's balance can't realistically overflow.
1696         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1697         unchecked {
1698             // We can directly increment and decrement the balances.
1699             --_packedAddressData[from]; // Updates: `balance -= 1`.
1700             ++_packedAddressData[to]; // Updates: `balance += 1`.
1701 
1702             // Updates:
1703             // - `address` to the next owner.
1704             // - `startTimestamp` to the timestamp of transfering.
1705             // - `burned` to `false`.
1706             // - `nextInitialized` to `true`.
1707             _packedOwnerships[tokenId] = _packOwnershipData(
1708                 to,
1709                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1710             );
1711 
1712             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1713             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1714                 uint256 nextTokenId = tokenId + 1;
1715                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1716                 if (_packedOwnerships[nextTokenId] == 0) {
1717                     // If the next slot is within bounds.
1718                     if (nextTokenId != _currentIndex) {
1719                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1720                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1721                     }
1722                 }
1723             }
1724         }
1725 
1726         emit Transfer(from, to, tokenId);
1727         _afterTokenTransfers(from, to, tokenId, 1);
1728     }
1729 
1730     /**
1731      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1732      */
1733     function safeTransferFrom(
1734         address from,
1735         address to,
1736         uint256 tokenId
1737     ) public payable virtual override {
1738         safeTransferFrom(from, to, tokenId, '');
1739     }
1740 
1741     /**
1742      * @dev Safely transfers `tokenId` token from `from` to `to`.
1743      *
1744      * Requirements:
1745      *
1746      * - `from` cannot be the zero address.
1747      * - `to` cannot be the zero address.
1748      * - `tokenId` token must exist and be owned by `from`.
1749      * - If the caller is not `from`, it must be approved to move this token
1750      * by either {approve} or {setApprovalForAll}.
1751      * - If `to` refers to a smart contract, it must implement
1752      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1753      *
1754      * Emits a {Transfer} event.
1755      */
1756     function safeTransferFrom(
1757         address from,
1758         address to,
1759         uint256 tokenId,
1760         bytes memory _data
1761     ) public payable virtual override {
1762         transferFrom(from, to, tokenId);
1763         if (to.code.length != 0)
1764             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1765                 revert TransferToNonERC721ReceiverImplementer();
1766             }
1767     }
1768 
1769     /**
1770      * @dev Hook that is called before a set of serially-ordered token IDs
1771      * are about to be transferred. This includes minting.
1772      * And also called before burning one token.
1773      *
1774      * `startTokenId` - the first token ID to be transferred.
1775      * `quantity` - the amount to be transferred.
1776      *
1777      * Calling conditions:
1778      *
1779      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1780      * transferred to `to`.
1781      * - When `from` is zero, `tokenId` will be minted for `to`.
1782      * - When `to` is zero, `tokenId` will be burned by `from`.
1783      * - `from` and `to` are never both zero.
1784      */
1785     function _beforeTokenTransfers(
1786         address from,
1787         address to,
1788         uint256 startTokenId,
1789         uint256 quantity
1790     ) internal virtual {}
1791 
1792     /**
1793      * @dev Hook that is called after a set of serially-ordered token IDs
1794      * have been transferred. This includes minting.
1795      * And also called after one token has been burned.
1796      *
1797      * `startTokenId` - the first token ID to be transferred.
1798      * `quantity` - the amount to be transferred.
1799      *
1800      * Calling conditions:
1801      *
1802      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1803      * transferred to `to`.
1804      * - When `from` is zero, `tokenId` has been minted for `to`.
1805      * - When `to` is zero, `tokenId` has been burned by `from`.
1806      * - `from` and `to` are never both zero.
1807      */
1808     function _afterTokenTransfers(
1809         address from,
1810         address to,
1811         uint256 startTokenId,
1812         uint256 quantity
1813     ) internal virtual {}
1814 
1815     /**
1816      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1817      *
1818      * `from` - Previous owner of the given token ID.
1819      * `to` - Target address that will receive the token.
1820      * `tokenId` - Token ID to be transferred.
1821      * `_data` - Optional data to send along with the call.
1822      *
1823      * Returns whether the call correctly returned the expected magic value.
1824      */
1825     function _checkContractOnERC721Received(
1826         address from,
1827         address to,
1828         uint256 tokenId,
1829         bytes memory _data
1830     ) private returns (bool) {
1831         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1832             bytes4 retval
1833         ) {
1834             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1835         } catch (bytes memory reason) {
1836             if (reason.length == 0) {
1837                 revert TransferToNonERC721ReceiverImplementer();
1838             } else {
1839                 assembly {
1840                     revert(add(32, reason), mload(reason))
1841                 }
1842             }
1843         }
1844     }
1845 
1846     // =============================================================
1847     //                        MINT OPERATIONS
1848     // =============================================================
1849 
1850     /**
1851      * @dev Mints `quantity` tokens and transfers them to `to`.
1852      *
1853      * Requirements:
1854      *
1855      * - `to` cannot be the zero address.
1856      * - `quantity` must be greater than 0.
1857      *
1858      * Emits a {Transfer} event for each mint.
1859      */
1860     function _mint(address to, uint256 quantity) internal virtual {
1861         uint256 startTokenId = _currentIndex;
1862         if (quantity == 0) revert MintZeroQuantity();
1863 
1864         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1865 
1866         // Overflows are incredibly unrealistic.
1867         // `balance` and `numberMinted` have a maximum limit of 2**64.
1868         // `tokenId` has a maximum limit of 2**256.
1869         unchecked {
1870             // Updates:
1871             // - `balance += quantity`.
1872             // - `numberMinted += quantity`.
1873             //
1874             // We can directly add to the `balance` and `numberMinted`.
1875             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1876 
1877             // Updates:
1878             // - `address` to the owner.
1879             // - `startTimestamp` to the timestamp of minting.
1880             // - `burned` to `false`.
1881             // - `nextInitialized` to `quantity == 1`.
1882             _packedOwnerships[startTokenId] = _packOwnershipData(
1883                 to,
1884                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1885             );
1886 
1887             uint256 toMasked;
1888             uint256 end = startTokenId + quantity;
1889 
1890             // Use assembly to loop and emit the `Transfer` event for gas savings.
1891             // The duplicated `log4` removes an extra check and reduces stack juggling.
1892             // The assembly, together with the surrounding Solidity code, have been
1893             // delicately arranged to nudge the compiler into producing optimized opcodes.
1894             assembly {
1895                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1896                 toMasked := and(to, _BITMASK_ADDRESS)
1897                 // Emit the `Transfer` event.
1898                 log4(
1899                     0, // Start of data (0, since no data).
1900                     0, // End of data (0, since no data).
1901                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1902                     0, // `address(0)`.
1903                     toMasked, // `to`.
1904                     startTokenId // `tokenId`.
1905                 )
1906 
1907                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1908                 // that overflows uint256 will make the loop run out of gas.
1909                 // The compiler will optimize the `iszero` away for performance.
1910                 for {
1911                     let tokenId := add(startTokenId, 1)
1912                 } iszero(eq(tokenId, end)) {
1913                     tokenId := add(tokenId, 1)
1914                 } {
1915                     // Emit the `Transfer` event. Similar to above.
1916                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1917                 }
1918             }
1919             if (toMasked == 0) revert MintToZeroAddress();
1920 
1921             _currentIndex = end;
1922         }
1923         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1924     }
1925 
1926     /**
1927      * @dev Mints `quantity` tokens and transfers them to `to`.
1928      *
1929      * This function is intended for efficient minting only during contract creation.
1930      *
1931      * It emits only one {ConsecutiveTransfer} as defined in
1932      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1933      * instead of a sequence of {Transfer} event(s).
1934      *
1935      * Calling this function outside of contract creation WILL make your contract
1936      * non-compliant with the ERC721 standard.
1937      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1938      * {ConsecutiveTransfer} event is only permissible during contract creation.
1939      *
1940      * Requirements:
1941      *
1942      * - `to` cannot be the zero address.
1943      * - `quantity` must be greater than 0.
1944      *
1945      * Emits a {ConsecutiveTransfer} event.
1946      */
1947     function _mintERC2309(address to, uint256 quantity) internal virtual {
1948         uint256 startTokenId = _currentIndex;
1949         if (to == address(0)) revert MintToZeroAddress();
1950         if (quantity == 0) revert MintZeroQuantity();
1951         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1952 
1953         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1954 
1955         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1956         unchecked {
1957             // Updates:
1958             // - `balance += quantity`.
1959             // - `numberMinted += quantity`.
1960             //
1961             // We can directly add to the `balance` and `numberMinted`.
1962             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1963 
1964             // Updates:
1965             // - `address` to the owner.
1966             // - `startTimestamp` to the timestamp of minting.
1967             // - `burned` to `false`.
1968             // - `nextInitialized` to `quantity == 1`.
1969             _packedOwnerships[startTokenId] = _packOwnershipData(
1970                 to,
1971                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1972             );
1973 
1974             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1975 
1976             _currentIndex = startTokenId + quantity;
1977         }
1978         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1979     }
1980 
1981     /**
1982      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1983      *
1984      * Requirements:
1985      *
1986      * - If `to` refers to a smart contract, it must implement
1987      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1988      * - `quantity` must be greater than 0.
1989      *
1990      * See {_mint}.
1991      *
1992      * Emits a {Transfer} event for each mint.
1993      */
1994     function _safeMint(
1995         address to,
1996         uint256 quantity,
1997         bytes memory _data
1998     ) internal virtual {
1999         _mint(to, quantity);
2000 
2001         unchecked {
2002             if (to.code.length != 0) {
2003                 uint256 end = _currentIndex;
2004                 uint256 index = end - quantity;
2005                 do {
2006                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2007                         revert TransferToNonERC721ReceiverImplementer();
2008                     }
2009                 } while (index < end);
2010                 // Reentrancy protection.
2011                 if (_currentIndex != end) revert();
2012             }
2013         }
2014     }
2015 
2016     /**
2017      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2018      */
2019     function _safeMint(address to, uint256 quantity) internal virtual {
2020         _safeMint(to, quantity, '');
2021     }
2022 
2023     // =============================================================
2024     //                        BURN OPERATIONS
2025     // =============================================================
2026 
2027     /**
2028      * @dev Equivalent to `_burn(tokenId, false)`.
2029      */
2030     function _burn(uint256 tokenId) internal virtual {
2031         _burn(tokenId, false);
2032     }
2033 
2034     /**
2035      * @dev Destroys `tokenId`.
2036      * The approval is cleared when the token is burned.
2037      *
2038      * Requirements:
2039      *
2040      * - `tokenId` must exist.
2041      *
2042      * Emits a {Transfer} event.
2043      */
2044     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2045         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2046 
2047         address from = address(uint160(prevOwnershipPacked));
2048 
2049         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2050 
2051         if (approvalCheck) {
2052             // The nested ifs save around 20+ gas over a compound boolean condition.
2053             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2054                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2055         }
2056 
2057         _beforeTokenTransfers(from, address(0), tokenId, 1);
2058 
2059         // Clear approvals from the previous owner.
2060         assembly {
2061             if approvedAddress {
2062                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2063                 sstore(approvedAddressSlot, 0)
2064             }
2065         }
2066 
2067         // Underflow of the sender's balance is impossible because we check for
2068         // ownership above and the recipient's balance can't realistically overflow.
2069         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2070         unchecked {
2071             // Updates:
2072             // - `balance -= 1`.
2073             // - `numberBurned += 1`.
2074             //
2075             // We can directly decrement the balance, and increment the number burned.
2076             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2077             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2078 
2079             // Updates:
2080             // - `address` to the last owner.
2081             // - `startTimestamp` to the timestamp of burning.
2082             // - `burned` to `true`.
2083             // - `nextInitialized` to `true`.
2084             _packedOwnerships[tokenId] = _packOwnershipData(
2085                 from,
2086                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2087             );
2088 
2089             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2090             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2091                 uint256 nextTokenId = tokenId + 1;
2092                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2093                 if (_packedOwnerships[nextTokenId] == 0) {
2094                     // If the next slot is within bounds.
2095                     if (nextTokenId != _currentIndex) {
2096                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2097                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2098                     }
2099                 }
2100             }
2101         }
2102 
2103         emit Transfer(from, address(0), tokenId);
2104         _afterTokenTransfers(from, address(0), tokenId, 1);
2105 
2106         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2107         unchecked {
2108             _burnCounter++;
2109         }
2110     }
2111 
2112     // =============================================================
2113     //                     EXTRA DATA OPERATIONS
2114     // =============================================================
2115 
2116     /**
2117      * @dev Directly sets the extra data for the ownership data `index`.
2118      */
2119     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2120         uint256 packed = _packedOwnerships[index];
2121         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2122         uint256 extraDataCasted;
2123         // Cast `extraData` with assembly to avoid redundant masking.
2124         assembly {
2125             extraDataCasted := extraData
2126         }
2127         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2128         _packedOwnerships[index] = packed;
2129     }
2130 
2131     /**
2132      * @dev Called during each token transfer to set the 24bit `extraData` field.
2133      * Intended to be overridden by the cosumer contract.
2134      *
2135      * `previousExtraData` - the value of `extraData` before transfer.
2136      *
2137      * Calling conditions:
2138      *
2139      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2140      * transferred to `to`.
2141      * - When `from` is zero, `tokenId` will be minted for `to`.
2142      * - When `to` is zero, `tokenId` will be burned by `from`.
2143      * - `from` and `to` are never both zero.
2144      */
2145     function _extraData(
2146         address from,
2147         address to,
2148         uint24 previousExtraData
2149     ) internal view virtual returns (uint24) {}
2150 
2151     /**
2152      * @dev Returns the next extra data for the packed ownership data.
2153      * The returned result is shifted into position.
2154      */
2155     function _nextExtraData(
2156         address from,
2157         address to,
2158         uint256 prevOwnershipPacked
2159     ) private view returns (uint256) {
2160         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2161         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2162     }
2163 
2164     // =============================================================
2165     //                       OTHER OPERATIONS
2166     // =============================================================
2167 
2168     /**
2169      * @dev Returns the message sender (defaults to `msg.sender`).
2170      *
2171      * If you are writing GSN compatible contracts, you need to override this function.
2172      */
2173     function _msgSenderERC721A() internal view virtual returns (address) {
2174         return msg.sender;
2175     }
2176 
2177     /**
2178      * @dev Converts a uint256 to its ASCII string decimal representation.
2179      */
2180     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2181         assembly {
2182             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2183             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2184             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2185             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2186             let m := add(mload(0x40), 0xa0)
2187             // Update the free memory pointer to allocate.
2188             mstore(0x40, m)
2189             // Assign the `str` to the end.
2190             str := sub(m, 0x20)
2191             // Zeroize the slot after the string.
2192             mstore(str, 0)
2193 
2194             // Cache the end of the memory to calculate the length later.
2195             let end := str
2196 
2197             // We write the string from rightmost digit to leftmost digit.
2198             // The following is essentially a do-while loop that also handles the zero case.
2199             // prettier-ignore
2200             for { let temp := value } 1 {} {
2201                 str := sub(str, 1)
2202                 // Write the character to the pointer.
2203                 // The ASCII index of the '0' character is 48.
2204                 mstore8(str, add(48, mod(temp, 10)))
2205                 // Keep dividing `temp` until zero.
2206                 temp := div(temp, 10)
2207                 // prettier-ignore
2208                 if iszero(temp) { break }
2209             }
2210 
2211             let length := sub(end, str)
2212             // Move the pointer 32 bytes leftwards to make room for the length.
2213             str := sub(str, 0x20)
2214             // Store the length.
2215             mstore(str, length)
2216         }
2217     }
2218 }
2219 
2220 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
2221 
2222 
2223 // ERC721A Contracts v4.2.3
2224 // Creator: Chiru Labs
2225 
2226 pragma solidity ^0.8.4;
2227 
2228 
2229 /**
2230  * @dev Interface of ERC721AQueryable.
2231  */
2232 interface IERC721AQueryable is IERC721A {
2233     /**
2234      * Invalid query range (`start` >= `stop`).
2235      */
2236     error InvalidQueryRange();
2237 
2238     /**
2239      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2240      *
2241      * If the `tokenId` is out of bounds:
2242      *
2243      * - `addr = address(0)`
2244      * - `startTimestamp = 0`
2245      * - `burned = false`
2246      * - `extraData = 0`
2247      *
2248      * If the `tokenId` is burned:
2249      *
2250      * - `addr = <Address of owner before token was burned>`
2251      * - `startTimestamp = <Timestamp when token was burned>`
2252      * - `burned = true`
2253      * - `extraData = <Extra data when token was burned>`
2254      *
2255      * Otherwise:
2256      *
2257      * - `addr = <Address of owner>`
2258      * - `startTimestamp = <Timestamp of start of ownership>`
2259      * - `burned = false`
2260      * - `extraData = <Extra data at start of ownership>`
2261      */
2262     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2263 
2264     /**
2265      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2266      * See {ERC721AQueryable-explicitOwnershipOf}
2267      */
2268     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2269 
2270     /**
2271      * @dev Returns an array of token IDs owned by `owner`,
2272      * in the range [`start`, `stop`)
2273      * (i.e. `start <= tokenId < stop`).
2274      *
2275      * This function allows for tokens to be queried if the collection
2276      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2277      *
2278      * Requirements:
2279      *
2280      * - `start < stop`
2281      */
2282     function tokensOfOwnerIn(
2283         address owner,
2284         uint256 start,
2285         uint256 stop
2286     ) external view returns (uint256[] memory);
2287 
2288     /**
2289      * @dev Returns an array of token IDs owned by `owner`.
2290      *
2291      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2292      * It is meant to be called off-chain.
2293      *
2294      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2295      * multiple smaller scans if the collection is large enough to cause
2296      * an out-of-gas error (10K collections should be fine).
2297      */
2298     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2299 }
2300 
2301 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2302 
2303 
2304 // ERC721A Contracts v4.2.3
2305 // Creator: Chiru Labs
2306 
2307 pragma solidity ^0.8.4;
2308 
2309 
2310 
2311 /**
2312  * @title ERC721AQueryable.
2313  *
2314  * @dev ERC721A subclass with convenience query functions.
2315  */
2316 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2317     /**
2318      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2319      *
2320      * If the `tokenId` is out of bounds:
2321      *
2322      * - `addr = address(0)`
2323      * - `startTimestamp = 0`
2324      * - `burned = false`
2325      * - `extraData = 0`
2326      *
2327      * If the `tokenId` is burned:
2328      *
2329      * - `addr = <Address of owner before token was burned>`
2330      * - `startTimestamp = <Timestamp when token was burned>`
2331      * - `burned = true`
2332      * - `extraData = <Extra data when token was burned>`
2333      *
2334      * Otherwise:
2335      *
2336      * - `addr = <Address of owner>`
2337      * - `startTimestamp = <Timestamp of start of ownership>`
2338      * - `burned = false`
2339      * - `extraData = <Extra data at start of ownership>`
2340      */
2341     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2342         TokenOwnership memory ownership;
2343         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2344             return ownership;
2345         }
2346         ownership = _ownershipAt(tokenId);
2347         if (ownership.burned) {
2348             return ownership;
2349         }
2350         return _ownershipOf(tokenId);
2351     }
2352 
2353     /**
2354      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2355      * See {ERC721AQueryable-explicitOwnershipOf}
2356      */
2357     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2358         external
2359         view
2360         virtual
2361         override
2362         returns (TokenOwnership[] memory)
2363     {
2364         unchecked {
2365             uint256 tokenIdsLength = tokenIds.length;
2366             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2367             for (uint256 i; i != tokenIdsLength; ++i) {
2368                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2369             }
2370             return ownerships;
2371         }
2372     }
2373 
2374     /**
2375      * @dev Returns an array of token IDs owned by `owner`,
2376      * in the range [`start`, `stop`)
2377      * (i.e. `start <= tokenId < stop`).
2378      *
2379      * This function allows for tokens to be queried if the collection
2380      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2381      *
2382      * Requirements:
2383      *
2384      * - `start < stop`
2385      */
2386     function tokensOfOwnerIn(
2387         address owner,
2388         uint256 start,
2389         uint256 stop
2390     ) external view virtual override returns (uint256[] memory) {
2391         unchecked {
2392             if (start >= stop) revert InvalidQueryRange();
2393             uint256 tokenIdsIdx;
2394             uint256 stopLimit = _nextTokenId();
2395             // Set `start = max(start, _startTokenId())`.
2396             if (start < _startTokenId()) {
2397                 start = _startTokenId();
2398             }
2399             // Set `stop = min(stop, stopLimit)`.
2400             if (stop > stopLimit) {
2401                 stop = stopLimit;
2402             }
2403             uint256 tokenIdsMaxLength = balanceOf(owner);
2404             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2405             // to cater for cases where `balanceOf(owner)` is too big.
2406             if (start < stop) {
2407                 uint256 rangeLength = stop - start;
2408                 if (rangeLength < tokenIdsMaxLength) {
2409                     tokenIdsMaxLength = rangeLength;
2410                 }
2411             } else {
2412                 tokenIdsMaxLength = 0;
2413             }
2414             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2415             if (tokenIdsMaxLength == 0) {
2416                 return tokenIds;
2417             }
2418             // We need to call `explicitOwnershipOf(start)`,
2419             // because the slot at `start` may not be initialized.
2420             TokenOwnership memory ownership = explicitOwnershipOf(start);
2421             address currOwnershipAddr;
2422             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2423             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2424             if (!ownership.burned) {
2425                 currOwnershipAddr = ownership.addr;
2426             }
2427             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2428                 ownership = _ownershipAt(i);
2429                 if (ownership.burned) {
2430                     continue;
2431                 }
2432                 if (ownership.addr != address(0)) {
2433                     currOwnershipAddr = ownership.addr;
2434                 }
2435                 if (currOwnershipAddr == owner) {
2436                     tokenIds[tokenIdsIdx++] = i;
2437                 }
2438             }
2439             // Downsize the array to fit.
2440             assembly {
2441                 mstore(tokenIds, tokenIdsIdx)
2442             }
2443             return tokenIds;
2444         }
2445     }
2446 
2447     /**
2448      * @dev Returns an array of token IDs owned by `owner`.
2449      *
2450      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2451      * It is meant to be called off-chain.
2452      *
2453      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2454      * multiple smaller scans if the collection is large enough to cause
2455      * an out-of-gas error (10K collections should be fine).
2456      */
2457     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2458         unchecked {
2459             uint256 tokenIdsIdx;
2460             address currOwnershipAddr;
2461             uint256 tokenIdsLength = balanceOf(owner);
2462             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2463             TokenOwnership memory ownership;
2464             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2465                 ownership = _ownershipAt(i);
2466                 if (ownership.burned) {
2467                     continue;
2468                 }
2469                 if (ownership.addr != address(0)) {
2470                     currOwnershipAddr = ownership.addr;
2471                 }
2472                 if (currOwnershipAddr == owner) {
2473                     tokenIds[tokenIdsIdx++] = i;
2474                 }
2475             }
2476             return tokenIds;
2477         }
2478     }
2479 }
2480 
2481 // File: contracts/nft.sol
2482 
2483 
2484 
2485 pragma solidity >=0.8.9 <0.9.0;
2486 
2487 
2488 
2489 
2490 
2491 
2492 
2493 contract NFT is ERC721AQueryable, Ownable, ReentrancyGuard {
2494   string public uriPrefix = "";
2495   string public uriSuffix = "";
2496   string public uriOrigin = "";
2497   
2498   uint256 public cost;
2499   uint256 public maxSupply;
2500   uint256 public maxMintAmountPerTx;
2501   uint256 public publicSupply = 0;
2502   mapping(address => uint256) private mintCount;
2503 
2504   bool public paused = true;
2505 
2506   constructor(
2507   ) ERC721A("KUNLER", "KUNLER") {
2508     setCost(0);
2509     maxSupply = 10000;
2510     setMaxMintAmountPerTx(5);
2511     setUriOrigin("ipfs://bafybeifzc7a4qbfvtjojkop3v7mxzjru2uquk64o7zgzmqtzt5lshszk7i");
2512   }
2513   
2514   modifier mintCompliance(uint256 _mintAmount) {
2515     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
2516     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
2517     require(publicSupply + _mintAmount <= maxSupply - 1000, "Max supply exceeded!");
2518     _;
2519   }
2520 
2521   function mint(uint256 _mintAmount) public mintCompliance(_mintAmount) {
2522     require(!paused, "The contract is paused!");
2523     require(mintCount[_msgSender()] + _mintAmount <= 5, "Over minted!");
2524     _safeMint(_msgSender(), _mintAmount);
2525     mintCount[_msgSender()] += _mintAmount;
2526     publicSupply += _mintAmount;
2527   }
2528   
2529   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
2530     require(_mintAmount > 0, "Invalid mint amount!");
2531     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
2532     _safeMint(_receiver, _mintAmount);
2533   }
2534 
2535   function tokenURI(uint256 _tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2536     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2537 
2538     string memory currentBaseURI = _baseURI();
2539     return bytes(currentBaseURI).length > 0
2540         ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
2541         : string(uriOrigin);
2542   }
2543 
2544 
2545   function setCost(uint256 _cost) public onlyOwner {
2546     cost = _cost;
2547   }
2548 
2549   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2550     maxMintAmountPerTx = _maxMintAmountPerTx;
2551   }
2552 
2553   function setUriOrigin(string memory _uriOrigin) public onlyOwner {
2554     uriOrigin = _uriOrigin;
2555   }
2556 
2557   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2558     uriPrefix = _uriPrefix;
2559   }
2560 
2561   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2562     uriSuffix = _uriSuffix;
2563   }
2564 
2565   function setPaused(bool _state) public onlyOwner {
2566     paused = _state;
2567   }
2568 
2569   function withdraw() public onlyOwner nonReentrant {
2570     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2571     require(os);
2572   }
2573 
2574   function _baseURI() internal view virtual override returns (string memory) {
2575     return uriPrefix;
2576   }
2577 }