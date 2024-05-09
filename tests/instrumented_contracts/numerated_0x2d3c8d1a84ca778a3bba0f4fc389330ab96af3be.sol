1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
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
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: contract-allow-list/contracts/proxy/interface/IContractAllowListProxy.sol
217 
218 
219 pragma solidity >=0.7.0 <0.9.0;
220 
221 interface IContractAllowListProxy {
222     function isAllowed(address _transferer, uint256 _level)
223         external
224         view
225         returns (bool);
226 }
227 
228 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
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
261  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
262  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
263  *
264  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
265  * ====
266  */
267 library EnumerableSet {
268     // To implement this library for multiple types with as little code
269     // repetition as possible, we write it in terms of a generic Set type with
270     // bytes32 values.
271     // The Set implementation uses private functions, and user-facing
272     // implementations (such as AddressSet) are just wrappers around the
273     // underlying Set.
274     // This means that we can only create new EnumerableSets for types that fit
275     // in bytes32.
276 
277     struct Set {
278         // Storage of set values
279         bytes32[] _values;
280         // Position of the value in the `values` array, plus 1 because index 0
281         // means a value is not in the set.
282         mapping(bytes32 => uint256) _indexes;
283     }
284 
285     /**
286      * @dev Add a value to a set. O(1).
287      *
288      * Returns true if the value was added to the set, that is if it was not
289      * already present.
290      */
291     function _add(Set storage set, bytes32 value) private returns (bool) {
292         if (!_contains(set, value)) {
293             set._values.push(value);
294             // The value is stored at length-1, but we add 1 to all indexes
295             // and use 0 as a sentinel value
296             set._indexes[value] = set._values.length;
297             return true;
298         } else {
299             return false;
300         }
301     }
302 
303     /**
304      * @dev Removes a value from a set. O(1).
305      *
306      * Returns true if the value was removed from the set, that is if it was
307      * present.
308      */
309     function _remove(Set storage set, bytes32 value) private returns (bool) {
310         // We read and store the value's index to prevent multiple reads from the same storage slot
311         uint256 valueIndex = set._indexes[value];
312 
313         if (valueIndex != 0) {
314             // Equivalent to contains(set, value)
315             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
316             // the array, and then remove the last element (sometimes called as 'swap and pop').
317             // This modifies the order of the array, as noted in {at}.
318 
319             uint256 toDeleteIndex = valueIndex - 1;
320             uint256 lastIndex = set._values.length - 1;
321 
322             if (lastIndex != toDeleteIndex) {
323                 bytes32 lastValue = set._values[lastIndex];
324 
325                 // Move the last value to the index where the value to delete is
326                 set._values[toDeleteIndex] = lastValue;
327                 // Update the index for the moved value
328                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
329             }
330 
331             // Delete the slot where the moved value was stored
332             set._values.pop();
333 
334             // Delete the index for the deleted slot
335             delete set._indexes[value];
336 
337             return true;
338         } else {
339             return false;
340         }
341     }
342 
343     /**
344      * @dev Returns true if the value is in the set. O(1).
345      */
346     function _contains(Set storage set, bytes32 value) private view returns (bool) {
347         return set._indexes[value] != 0;
348     }
349 
350     /**
351      * @dev Returns the number of values on the set. O(1).
352      */
353     function _length(Set storage set) private view returns (uint256) {
354         return set._values.length;
355     }
356 
357     /**
358      * @dev Returns the value stored at position `index` in the set. O(1).
359      *
360      * Note that there are no guarantees on the ordering of values inside the
361      * array, and it may change when more values are added or removed.
362      *
363      * Requirements:
364      *
365      * - `index` must be strictly less than {length}.
366      */
367     function _at(Set storage set, uint256 index) private view returns (bytes32) {
368         return set._values[index];
369     }
370 
371     /**
372      * @dev Return the entire set in an array
373      *
374      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
375      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
376      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
377      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
378      */
379     function _values(Set storage set) private view returns (bytes32[] memory) {
380         return set._values;
381     }
382 
383     // Bytes32Set
384 
385     struct Bytes32Set {
386         Set _inner;
387     }
388 
389     /**
390      * @dev Add a value to a set. O(1).
391      *
392      * Returns true if the value was added to the set, that is if it was not
393      * already present.
394      */
395     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
396         return _add(set._inner, value);
397     }
398 
399     /**
400      * @dev Removes a value from a set. O(1).
401      *
402      * Returns true if the value was removed from the set, that is if it was
403      * present.
404      */
405     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
406         return _remove(set._inner, value);
407     }
408 
409     /**
410      * @dev Returns true if the value is in the set. O(1).
411      */
412     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
413         return _contains(set._inner, value);
414     }
415 
416     /**
417      * @dev Returns the number of values in the set. O(1).
418      */
419     function length(Bytes32Set storage set) internal view returns (uint256) {
420         return _length(set._inner);
421     }
422 
423     /**
424      * @dev Returns the value stored at position `index` in the set. O(1).
425      *
426      * Note that there are no guarantees on the ordering of values inside the
427      * array, and it may change when more values are added or removed.
428      *
429      * Requirements:
430      *
431      * - `index` must be strictly less than {length}.
432      */
433     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
434         return _at(set._inner, index);
435     }
436 
437     /**
438      * @dev Return the entire set in an array
439      *
440      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
441      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
442      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
443      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
444      */
445     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
446         return _values(set._inner);
447     }
448 
449     // AddressSet
450 
451     struct AddressSet {
452         Set _inner;
453     }
454 
455     /**
456      * @dev Add a value to a set. O(1).
457      *
458      * Returns true if the value was added to the set, that is if it was not
459      * already present.
460      */
461     function add(AddressSet storage set, address value) internal returns (bool) {
462         return _add(set._inner, bytes32(uint256(uint160(value))));
463     }
464 
465     /**
466      * @dev Removes a value from a set. O(1).
467      *
468      * Returns true if the value was removed from the set, that is if it was
469      * present.
470      */
471     function remove(AddressSet storage set, address value) internal returns (bool) {
472         return _remove(set._inner, bytes32(uint256(uint160(value))));
473     }
474 
475     /**
476      * @dev Returns true if the value is in the set. O(1).
477      */
478     function contains(AddressSet storage set, address value) internal view returns (bool) {
479         return _contains(set._inner, bytes32(uint256(uint160(value))));
480     }
481 
482     /**
483      * @dev Returns the number of values in the set. O(1).
484      */
485     function length(AddressSet storage set) internal view returns (uint256) {
486         return _length(set._inner);
487     }
488 
489     /**
490      * @dev Returns the value stored at position `index` in the set. O(1).
491      *
492      * Note that there are no guarantees on the ordering of values inside the
493      * array, and it may change when more values are added or removed.
494      *
495      * Requirements:
496      *
497      * - `index` must be strictly less than {length}.
498      */
499     function at(AddressSet storage set, uint256 index) internal view returns (address) {
500         return address(uint160(uint256(_at(set._inner, index))));
501     }
502 
503     /**
504      * @dev Return the entire set in an array
505      *
506      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
507      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
508      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
509      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
510      */
511     function values(AddressSet storage set) internal view returns (address[] memory) {
512         bytes32[] memory store = _values(set._inner);
513         address[] memory result;
514 
515         /// @solidity memory-safe-assembly
516         assembly {
517             result := store
518         }
519 
520         return result;
521     }
522 
523     // UintSet
524 
525     struct UintSet {
526         Set _inner;
527     }
528 
529     /**
530      * @dev Add a value to a set. O(1).
531      *
532      * Returns true if the value was added to the set, that is if it was not
533      * already present.
534      */
535     function add(UintSet storage set, uint256 value) internal returns (bool) {
536         return _add(set._inner, bytes32(value));
537     }
538 
539     /**
540      * @dev Removes a value from a set. O(1).
541      *
542      * Returns true if the value was removed from the set, that is if it was
543      * present.
544      */
545     function remove(UintSet storage set, uint256 value) internal returns (bool) {
546         return _remove(set._inner, bytes32(value));
547     }
548 
549     /**
550      * @dev Returns true if the value is in the set. O(1).
551      */
552     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
553         return _contains(set._inner, bytes32(value));
554     }
555 
556     /**
557      * @dev Returns the number of values on the set. O(1).
558      */
559     function length(UintSet storage set) internal view returns (uint256) {
560         return _length(set._inner);
561     }
562 
563     /**
564      * @dev Returns the value stored at position `index` in the set. O(1).
565      *
566      * Note that there are no guarantees on the ordering of values inside the
567      * array, and it may change when more values are added or removed.
568      *
569      * Requirements:
570      *
571      * - `index` must be strictly less than {length}.
572      */
573     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
574         return uint256(_at(set._inner, index));
575     }
576 
577     /**
578      * @dev Return the entire set in an array
579      *
580      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
581      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
582      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
583      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
584      */
585     function values(UintSet storage set) internal view returns (uint256[] memory) {
586         bytes32[] memory store = _values(set._inner);
587         uint256[] memory result;
588 
589         /// @solidity memory-safe-assembly
590         assembly {
591             result := store
592         }
593 
594         return result;
595     }
596 }
597 
598 // File: @openzeppelin/contracts/utils/Context.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Provides information about the current execution context, including the
607  * sender of the transaction and its data. While these are generally available
608  * via msg.sender and msg.data, they should not be accessed in such a direct
609  * manner, since when dealing with meta-transactions the account sending and
610  * paying for execution may not be the actual sender (as far as an application
611  * is concerned).
612  *
613  * This contract is only required for intermediate, library-like contracts.
614  */
615 abstract contract Context {
616     function _msgSender() internal view virtual returns (address) {
617         return msg.sender;
618     }
619 
620     function _msgData() internal view virtual returns (bytes calldata) {
621         return msg.data;
622     }
623 }
624 
625 // File: @openzeppelin/contracts/access/Ownable.sol
626 
627 
628 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 
633 /**
634  * @dev Contract module which provides a basic access control mechanism, where
635  * there is an account (an owner) that can be granted exclusive access to
636  * specific functions.
637  *
638  * By default, the owner account will be the one that deploys the contract. This
639  * can later be changed with {transferOwnership}.
640  *
641  * This module is used through inheritance. It will make available the modifier
642  * `onlyOwner`, which can be applied to your functions to restrict their use to
643  * the owner.
644  */
645 abstract contract Ownable is Context {
646     address private _owner;
647 
648     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
649 
650     /**
651      * @dev Initializes the contract setting the deployer as the initial owner.
652      */
653     constructor() {
654         _transferOwnership(_msgSender());
655     }
656 
657     /**
658      * @dev Throws if called by any account other than the owner.
659      */
660     modifier onlyOwner() {
661         _checkOwner();
662         _;
663     }
664 
665     /**
666      * @dev Returns the address of the current owner.
667      */
668     function owner() public view virtual returns (address) {
669         return _owner;
670     }
671 
672     /**
673      * @dev Throws if the sender is not the owner.
674      */
675     function _checkOwner() internal view virtual {
676         require(owner() == _msgSender(), "Ownable: caller is not the owner");
677     }
678 
679     /**
680      * @dev Leaves the contract without owner. It will not be possible to call
681      * `onlyOwner` functions anymore. Can only be called by the current owner.
682      *
683      * NOTE: Renouncing ownership will leave the contract without an owner,
684      * thereby removing any functionality that is only available to the owner.
685      */
686     function renounceOwnership() public virtual onlyOwner {
687         _transferOwnership(address(0));
688     }
689 
690     /**
691      * @dev Transfers ownership of the contract to a new account (`newOwner`).
692      * Can only be called by the current owner.
693      */
694     function transferOwnership(address newOwner) public virtual onlyOwner {
695         require(newOwner != address(0), "Ownable: new owner is the zero address");
696         _transferOwnership(newOwner);
697     }
698 
699     /**
700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
701      * Internal function without access restriction.
702      */
703     function _transferOwnership(address newOwner) internal virtual {
704         address oldOwner = _owner;
705         _owner = newOwner;
706         emit OwnershipTransferred(oldOwner, newOwner);
707     }
708 }
709 
710 // File: contract-allow-list/contracts/ERC721AntiScam/IERC721AntiScam.sol
711 
712 
713 pragma solidity >=0.8.0;
714 
715 /// @title IERC721AntiScam
716 /// @dev 詐欺防止機能付きコントラクトのインターフェース
717 /// @author hayatti.eth
718 
719 interface IERC721AntiScam {
720 
721    enum LockStatus {
722       UnSet,
723       UnLock,
724       CalLock,
725       AllLock
726    }
727 
728     /**
729      * @dev 個別ロックが指定された場合のイベント
730      */
731     event TokenLock(address indexed owner, address indexed from, uint lockStatus, uint256 indexed tokenId);
732 
733     /**
734      * @dev 該当トークンIDにおけるロックレベルを return で返す。
735      */
736     function getLockStatus(uint256 tokenId) external view returns (LockStatus);
737 
738     /**
739      * @dev 該当トークンIDにおいて、該当コントラクトの転送が許可されているかを返す
740      */
741     function getTokenLocked(address to ,uint256 tokenId) external view returns (bool);
742     
743     /**
744      * @dev 該当コントラクトの転送が拒否されているトークンを全て返す
745      */
746     function getTokensUnderLock(address to) external view returns (uint256[] memory);
747 
748     /**
749      * @dev 該当コントラクトの転送が拒否されているstartからstopまでのトークンIDを返す
750      */
751     function getTokensUnderLock(address to, uint256 start, uint256 end) external view returns (uint256[] memory);
752 
753     
754     /**
755      * @dev holderが所有するトークンのうち、該当コントラクトの転送が拒否されているトークンを全て返す
756      */
757     function getTokensUnderLock(address holder, address to) external view returns (uint256[] memory);
758 
759     /**
760      * @dev holderが所有するトークンのうち、該当コントラクトの転送が拒否されているstartからstopまでのトークンIDを返す
761      */
762     function getTokensUnderLock(address holder, address to, uint256 start, uint256 end) external view returns (uint256[] memory);
763 
764     /**
765      * @dev 該当ウォレットアドレスにおいて、該当コントラクトの転送が許可されているかを返す
766      */
767     function getLocked(address to ,address holder) external view returns (bool);
768 
769     /**
770      * @dev CALのリストに無い独自の許可アドレスを追加する場合、こちらにアドレスを記載する。
771      */
772     function addLocalContractAllowList(address _contract) external;
773 
774     /**
775      * @dev CALのリストにある独自の許可アドレスを削除する場合、こちらにアドレスを記載する。
776      */
777     function removeLocalContractAllowList(address _contract) external;
778 
779 
780     /**
781      * @dev CALを利用する場合のCALのレベルを設定する。レベルが高いほど、許可されるコントラクトの範囲が狭い。
782      */
783     function setContractAllowListLevel(uint256 level) external;
784 
785     /**
786      * @dev デフォルトでのロックレベルを指定する。
787      */
788     function setContractLockStatus(LockStatus status) external;
789 
790 }
791 // File: erc721a/contracts/IERC721A.sol
792 
793 
794 // ERC721A Contracts v4.2.3
795 // Creator: Chiru Labs
796 
797 pragma solidity ^0.8.4;
798 
799 /**
800  * @dev Interface of ERC721A.
801  */
802 interface IERC721A {
803     /**
804      * The caller must own the token or be an approved operator.
805      */
806     error ApprovalCallerNotOwnerNorApproved();
807 
808     /**
809      * The token does not exist.
810      */
811     error ApprovalQueryForNonexistentToken();
812 
813     /**
814      * Cannot query the balance for the zero address.
815      */
816     error BalanceQueryForZeroAddress();
817 
818     /**
819      * Cannot mint to the zero address.
820      */
821     error MintToZeroAddress();
822 
823     /**
824      * The quantity of tokens minted must be more than zero.
825      */
826     error MintZeroQuantity();
827 
828     /**
829      * The token does not exist.
830      */
831     error OwnerQueryForNonexistentToken();
832 
833     /**
834      * The caller must own the token or be an approved operator.
835      */
836     error TransferCallerNotOwnerNorApproved();
837 
838     /**
839      * The token must be owned by `from`.
840      */
841     error TransferFromIncorrectOwner();
842 
843     /**
844      * Cannot safely transfer to a contract that does not implement the
845      * ERC721Receiver interface.
846      */
847     error TransferToNonERC721ReceiverImplementer();
848 
849     /**
850      * Cannot transfer to the zero address.
851      */
852     error TransferToZeroAddress();
853 
854     /**
855      * The token does not exist.
856      */
857     error URIQueryForNonexistentToken();
858 
859     /**
860      * The `quantity` minted with ERC2309 exceeds the safety limit.
861      */
862     error MintERC2309QuantityExceedsLimit();
863 
864     /**
865      * The `extraData` cannot be set on an unintialized ownership slot.
866      */
867     error OwnershipNotInitializedForExtraData();
868 
869     // =============================================================
870     //                            STRUCTS
871     // =============================================================
872 
873     struct TokenOwnership {
874         // The address of the owner.
875         address addr;
876         // Stores the start time of ownership with minimal overhead for tokenomics.
877         uint64 startTimestamp;
878         // Whether the token has been burned.
879         bool burned;
880         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
881         uint24 extraData;
882     }
883 
884     // =============================================================
885     //                         TOKEN COUNTERS
886     // =============================================================
887 
888     /**
889      * @dev Returns the total number of tokens in existence.
890      * Burned tokens will reduce the count.
891      * To get the total number of tokens minted, please see {_totalMinted}.
892      */
893     function totalSupply() external view returns (uint256);
894 
895     // =============================================================
896     //                            IERC165
897     // =============================================================
898 
899     /**
900      * @dev Returns true if this contract implements the interface defined by
901      * `interfaceId`. See the corresponding
902      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
903      * to learn more about how these ids are created.
904      *
905      * This function call must use less than 30000 gas.
906      */
907     function supportsInterface(bytes4 interfaceId) external view returns (bool);
908 
909     // =============================================================
910     //                            IERC721
911     // =============================================================
912 
913     /**
914      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
915      */
916     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
917 
918     /**
919      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
920      */
921     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
922 
923     /**
924      * @dev Emitted when `owner` enables or disables
925      * (`approved`) `operator` to manage all of its assets.
926      */
927     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
928 
929     /**
930      * @dev Returns the number of tokens in `owner`'s account.
931      */
932     function balanceOf(address owner) external view returns (uint256 balance);
933 
934     /**
935      * @dev Returns the owner of the `tokenId` token.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must exist.
940      */
941     function ownerOf(uint256 tokenId) external view returns (address owner);
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`,
945      * checking first that contract recipients are aware of the ERC721 protocol
946      * to prevent tokens from being forever locked.
947      *
948      * Requirements:
949      *
950      * - `from` cannot be the zero address.
951      * - `to` cannot be the zero address.
952      * - `tokenId` token must exist and be owned by `from`.
953      * - If the caller is not `from`, it must be have been allowed to move
954      * this token by either {approve} or {setApprovalForAll}.
955      * - If `to` refers to a smart contract, it must implement
956      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
957      *
958      * Emits a {Transfer} event.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes calldata data
965     ) external payable;
966 
967     /**
968      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId
974     ) external payable;
975 
976     /**
977      * @dev Transfers `tokenId` from `from` to `to`.
978      *
979      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
980      * whenever possible.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      * - If the caller is not `from`, it must be approved to move this token
988      * by either {approve} or {setApprovalForAll}.
989      *
990      * Emits a {Transfer} event.
991      */
992     function transferFrom(
993         address from,
994         address to,
995         uint256 tokenId
996     ) external payable;
997 
998     /**
999      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1000      * The approval is cleared when the token is transferred.
1001      *
1002      * Only a single account can be approved at a time, so approving the
1003      * zero address clears previous approvals.
1004      *
1005      * Requirements:
1006      *
1007      * - The caller must own the token or be an approved operator.
1008      * - `tokenId` must exist.
1009      *
1010      * Emits an {Approval} event.
1011      */
1012     function approve(address to, uint256 tokenId) external payable;
1013 
1014     /**
1015      * @dev Approve or remove `operator` as an operator for the caller.
1016      * Operators can call {transferFrom} or {safeTransferFrom}
1017      * for any token owned by the caller.
1018      *
1019      * Requirements:
1020      *
1021      * - The `operator` cannot be the caller.
1022      *
1023      * Emits an {ApprovalForAll} event.
1024      */
1025     function setApprovalForAll(address operator, bool _approved) external;
1026 
1027     /**
1028      * @dev Returns the account approved for `tokenId` token.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      */
1034     function getApproved(uint256 tokenId) external view returns (address operator);
1035 
1036     /**
1037      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1038      *
1039      * See {setApprovalForAll}.
1040      */
1041     function isApprovedForAll(address owner, address operator) external view returns (bool);
1042 
1043     // =============================================================
1044     //                        IERC721Metadata
1045     // =============================================================
1046 
1047     /**
1048      * @dev Returns the token collection name.
1049      */
1050     function name() external view returns (string memory);
1051 
1052     /**
1053      * @dev Returns the token collection symbol.
1054      */
1055     function symbol() external view returns (string memory);
1056 
1057     /**
1058      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1059      */
1060     function tokenURI(uint256 tokenId) external view returns (string memory);
1061 
1062     // =============================================================
1063     //                           IERC2309
1064     // =============================================================
1065 
1066     /**
1067      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1068      * (inclusive) is transferred from `from` to `to`, as defined in the
1069      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1070      *
1071      * See {_mintERC2309} for more details.
1072      */
1073     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1074 }
1075 
1076 // File: erc721a/contracts/ERC721A.sol
1077 
1078 
1079 // ERC721A Contracts v4.2.3
1080 // Creator: Chiru Labs
1081 
1082 pragma solidity ^0.8.4;
1083 
1084 
1085 /**
1086  * @dev Interface of ERC721 token receiver.
1087  */
1088 interface ERC721A__IERC721Receiver {
1089     function onERC721Received(
1090         address operator,
1091         address from,
1092         uint256 tokenId,
1093         bytes calldata data
1094     ) external returns (bytes4);
1095 }
1096 
1097 /**
1098  * @title ERC721A
1099  *
1100  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1101  * Non-Fungible Token Standard, including the Metadata extension.
1102  * Optimized for lower gas during batch mints.
1103  *
1104  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1105  * starting from `_startTokenId()`.
1106  *
1107  * Assumptions:
1108  *
1109  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1110  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1111  */
1112 contract ERC721A is IERC721A {
1113     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1114     struct TokenApprovalRef {
1115         address value;
1116     }
1117 
1118     // =============================================================
1119     //                           CONSTANTS
1120     // =============================================================
1121 
1122     // Mask of an entry in packed address data.
1123     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1124 
1125     // The bit position of `numberMinted` in packed address data.
1126     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1127 
1128     // The bit position of `numberBurned` in packed address data.
1129     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1130 
1131     // The bit position of `aux` in packed address data.
1132     uint256 private constant _BITPOS_AUX = 192;
1133 
1134     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1135     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1136 
1137     // The bit position of `startTimestamp` in packed ownership.
1138     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1139 
1140     // The bit mask of the `burned` bit in packed ownership.
1141     uint256 private constant _BITMASK_BURNED = 1 << 224;
1142 
1143     // The bit position of the `nextInitialized` bit in packed ownership.
1144     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1145 
1146     // The bit mask of the `nextInitialized` bit in packed ownership.
1147     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1148 
1149     // The bit position of `extraData` in packed ownership.
1150     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1151 
1152     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1153     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1154 
1155     // The mask of the lower 160 bits for addresses.
1156     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1157 
1158     // The maximum `quantity` that can be minted with {_mintERC2309}.
1159     // This limit is to prevent overflows on the address data entries.
1160     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1161     // is required to cause an overflow, which is unrealistic.
1162     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1163 
1164     // The `Transfer` event signature is given by:
1165     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1166     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1167         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1168 
1169     // =============================================================
1170     //                            STORAGE
1171     // =============================================================
1172 
1173     // The next token ID to be minted.
1174     uint256 private _currentIndex;
1175 
1176     // The number of tokens burned.
1177     uint256 private _burnCounter;
1178 
1179     // Token name
1180     string private _name;
1181 
1182     // Token symbol
1183     string private _symbol;
1184 
1185     // Mapping from token ID to ownership details
1186     // An empty struct value does not necessarily mean the token is unowned.
1187     // See {_packedOwnershipOf} implementation for details.
1188     //
1189     // Bits Layout:
1190     // - [0..159]   `addr`
1191     // - [160..223] `startTimestamp`
1192     // - [224]      `burned`
1193     // - [225]      `nextInitialized`
1194     // - [232..255] `extraData`
1195     mapping(uint256 => uint256) private _packedOwnerships;
1196 
1197     // Mapping owner address to address data.
1198     //
1199     // Bits Layout:
1200     // - [0..63]    `balance`
1201     // - [64..127]  `numberMinted`
1202     // - [128..191] `numberBurned`
1203     // - [192..255] `aux`
1204     mapping(address => uint256) private _packedAddressData;
1205 
1206     // Mapping from token ID to approved address.
1207     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1208 
1209     // Mapping from owner to operator approvals
1210     mapping(address => mapping(address => bool)) private _operatorApprovals;
1211 
1212     // =============================================================
1213     //                          CONSTRUCTOR
1214     // =============================================================
1215 
1216     constructor(string memory name_, string memory symbol_) {
1217         _name = name_;
1218         _symbol = symbol_;
1219         _currentIndex = _startTokenId();
1220     }
1221 
1222     // =============================================================
1223     //                   TOKEN COUNTING OPERATIONS
1224     // =============================================================
1225 
1226     /**
1227      * @dev Returns the starting token ID.
1228      * To change the starting token ID, please override this function.
1229      */
1230     function _startTokenId() internal view virtual returns (uint256) {
1231         return 0;
1232     }
1233 
1234     /**
1235      * @dev Returns the next token ID to be minted.
1236      */
1237     function _nextTokenId() internal view virtual returns (uint256) {
1238         return _currentIndex;
1239     }
1240 
1241     /**
1242      * @dev Returns the total number of tokens in existence.
1243      * Burned tokens will reduce the count.
1244      * To get the total number of tokens minted, please see {_totalMinted}.
1245      */
1246     function totalSupply() public view virtual override returns (uint256) {
1247         // Counter underflow is impossible as _burnCounter cannot be incremented
1248         // more than `_currentIndex - _startTokenId()` times.
1249         unchecked {
1250             return _currentIndex - _burnCounter - _startTokenId();
1251         }
1252     }
1253 
1254     /**
1255      * @dev Returns the total amount of tokens minted in the contract.
1256      */
1257     function _totalMinted() internal view virtual returns (uint256) {
1258         // Counter underflow is impossible as `_currentIndex` does not decrement,
1259         // and it is initialized to `_startTokenId()`.
1260         unchecked {
1261             return _currentIndex - _startTokenId();
1262         }
1263     }
1264 
1265     /**
1266      * @dev Returns the total number of tokens burned.
1267      */
1268     function _totalBurned() internal view virtual returns (uint256) {
1269         return _burnCounter;
1270     }
1271 
1272     // =============================================================
1273     //                    ADDRESS DATA OPERATIONS
1274     // =============================================================
1275 
1276     /**
1277      * @dev Returns the number of tokens in `owner`'s account.
1278      */
1279     function balanceOf(address owner) public view virtual override returns (uint256) {
1280         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1281         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1282     }
1283 
1284     /**
1285      * Returns the number of tokens minted by `owner`.
1286      */
1287     function _numberMinted(address owner) internal view returns (uint256) {
1288         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1289     }
1290 
1291     /**
1292      * Returns the number of tokens burned by or on behalf of `owner`.
1293      */
1294     function _numberBurned(address owner) internal view returns (uint256) {
1295         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1296     }
1297 
1298     /**
1299      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1300      */
1301     function _getAux(address owner) internal view returns (uint64) {
1302         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1303     }
1304 
1305     /**
1306      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1307      * If there are multiple variables, please pack them into a uint64.
1308      */
1309     function _setAux(address owner, uint64 aux) internal virtual {
1310         uint256 packed = _packedAddressData[owner];
1311         uint256 auxCasted;
1312         // Cast `aux` with assembly to avoid redundant masking.
1313         assembly {
1314             auxCasted := aux
1315         }
1316         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1317         _packedAddressData[owner] = packed;
1318     }
1319 
1320     // =============================================================
1321     //                            IERC165
1322     // =============================================================
1323 
1324     /**
1325      * @dev Returns true if this contract implements the interface defined by
1326      * `interfaceId`. See the corresponding
1327      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1328      * to learn more about how these ids are created.
1329      *
1330      * This function call must use less than 30000 gas.
1331      */
1332     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1333         // The interface IDs are constants representing the first 4 bytes
1334         // of the XOR of all function selectors in the interface.
1335         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1336         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1337         return
1338             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1339             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1340             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1341     }
1342 
1343     // =============================================================
1344     //                        IERC721Metadata
1345     // =============================================================
1346 
1347     /**
1348      * @dev Returns the token collection name.
1349      */
1350     function name() public view virtual override returns (string memory) {
1351         return _name;
1352     }
1353 
1354     /**
1355      * @dev Returns the token collection symbol.
1356      */
1357     function symbol() public view virtual override returns (string memory) {
1358         return _symbol;
1359     }
1360 
1361     /**
1362      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1363      */
1364     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1365         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1366 
1367         string memory baseURI = _baseURI();
1368         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1369     }
1370 
1371     /**
1372      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1373      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1374      * by default, it can be overridden in child contracts.
1375      */
1376     function _baseURI() internal view virtual returns (string memory) {
1377         return '';
1378     }
1379 
1380     // =============================================================
1381     //                     OWNERSHIPS OPERATIONS
1382     // =============================================================
1383 
1384     /**
1385      * @dev Returns the owner of the `tokenId` token.
1386      *
1387      * Requirements:
1388      *
1389      * - `tokenId` must exist.
1390      */
1391     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1392         return address(uint160(_packedOwnershipOf(tokenId)));
1393     }
1394 
1395     /**
1396      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1397      * It gradually moves to O(1) as tokens get transferred around over time.
1398      */
1399     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1400         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1401     }
1402 
1403     /**
1404      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1405      */
1406     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1407         return _unpackedOwnership(_packedOwnerships[index]);
1408     }
1409 
1410     /**
1411      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1412      */
1413     function _initializeOwnershipAt(uint256 index) internal virtual {
1414         if (_packedOwnerships[index] == 0) {
1415             _packedOwnerships[index] = _packedOwnershipOf(index);
1416         }
1417     }
1418 
1419     /**
1420      * Returns the packed ownership data of `tokenId`.
1421      */
1422     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1423         uint256 curr = tokenId;
1424 
1425         unchecked {
1426             if (_startTokenId() <= curr)
1427                 if (curr < _currentIndex) {
1428                     uint256 packed = _packedOwnerships[curr];
1429                     // If not burned.
1430                     if (packed & _BITMASK_BURNED == 0) {
1431                         // Invariant:
1432                         // There will always be an initialized ownership slot
1433                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1434                         // before an unintialized ownership slot
1435                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1436                         // Hence, `curr` will not underflow.
1437                         //
1438                         // We can directly compare the packed value.
1439                         // If the address is zero, packed will be zero.
1440                         while (packed == 0) {
1441                             packed = _packedOwnerships[--curr];
1442                         }
1443                         return packed;
1444                     }
1445                 }
1446         }
1447         revert OwnerQueryForNonexistentToken();
1448     }
1449 
1450     /**
1451      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1452      */
1453     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1454         ownership.addr = address(uint160(packed));
1455         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1456         ownership.burned = packed & _BITMASK_BURNED != 0;
1457         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1458     }
1459 
1460     /**
1461      * @dev Packs ownership data into a single uint256.
1462      */
1463     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1464         assembly {
1465             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1466             owner := and(owner, _BITMASK_ADDRESS)
1467             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1468             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1469         }
1470     }
1471 
1472     /**
1473      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1474      */
1475     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1476         // For branchless setting of the `nextInitialized` flag.
1477         assembly {
1478             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1479             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1480         }
1481     }
1482 
1483     // =============================================================
1484     //                      APPROVAL OPERATIONS
1485     // =============================================================
1486 
1487     /**
1488      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1489      * The approval is cleared when the token is transferred.
1490      *
1491      * Only a single account can be approved at a time, so approving the
1492      * zero address clears previous approvals.
1493      *
1494      * Requirements:
1495      *
1496      * - The caller must own the token or be an approved operator.
1497      * - `tokenId` must exist.
1498      *
1499      * Emits an {Approval} event.
1500      */
1501     function approve(address to, uint256 tokenId) public payable virtual override {
1502         address owner = ownerOf(tokenId);
1503 
1504         if (_msgSenderERC721A() != owner)
1505             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1506                 revert ApprovalCallerNotOwnerNorApproved();
1507             }
1508 
1509         _tokenApprovals[tokenId].value = to;
1510         emit Approval(owner, to, tokenId);
1511     }
1512 
1513     /**
1514      * @dev Returns the account approved for `tokenId` token.
1515      *
1516      * Requirements:
1517      *
1518      * - `tokenId` must exist.
1519      */
1520     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1521         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1522 
1523         return _tokenApprovals[tokenId].value;
1524     }
1525 
1526     /**
1527      * @dev Approve or remove `operator` as an operator for the caller.
1528      * Operators can call {transferFrom} or {safeTransferFrom}
1529      * for any token owned by the caller.
1530      *
1531      * Requirements:
1532      *
1533      * - The `operator` cannot be the caller.
1534      *
1535      * Emits an {ApprovalForAll} event.
1536      */
1537     function setApprovalForAll(address operator, bool approved) public virtual override {
1538         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1539         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1540     }
1541 
1542     /**
1543      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1544      *
1545      * See {setApprovalForAll}.
1546      */
1547     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1548         return _operatorApprovals[owner][operator];
1549     }
1550 
1551     /**
1552      * @dev Returns whether `tokenId` exists.
1553      *
1554      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1555      *
1556      * Tokens start existing when they are minted. See {_mint}.
1557      */
1558     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1559         return
1560             _startTokenId() <= tokenId &&
1561             tokenId < _currentIndex && // If within bounds,
1562             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1563     }
1564 
1565     /**
1566      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1567      */
1568     function _isSenderApprovedOrOwner(
1569         address approvedAddress,
1570         address owner,
1571         address msgSender
1572     ) private pure returns (bool result) {
1573         assembly {
1574             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1575             owner := and(owner, _BITMASK_ADDRESS)
1576             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1577             msgSender := and(msgSender, _BITMASK_ADDRESS)
1578             // `msgSender == owner || msgSender == approvedAddress`.
1579             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1580         }
1581     }
1582 
1583     /**
1584      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1585      */
1586     function _getApprovedSlotAndAddress(uint256 tokenId)
1587         private
1588         view
1589         returns (uint256 approvedAddressSlot, address approvedAddress)
1590     {
1591         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1592         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1593         assembly {
1594             approvedAddressSlot := tokenApproval.slot
1595             approvedAddress := sload(approvedAddressSlot)
1596         }
1597     }
1598 
1599     // =============================================================
1600     //                      TRANSFER OPERATIONS
1601     // =============================================================
1602 
1603     /**
1604      * @dev Transfers `tokenId` from `from` to `to`.
1605      *
1606      * Requirements:
1607      *
1608      * - `from` cannot be the zero address.
1609      * - `to` cannot be the zero address.
1610      * - `tokenId` token must be owned by `from`.
1611      * - If the caller is not `from`, it must be approved to move this token
1612      * by either {approve} or {setApprovalForAll}.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function transferFrom(
1617         address from,
1618         address to,
1619         uint256 tokenId
1620     ) public payable virtual override {
1621         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1622 
1623         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1624 
1625         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1626 
1627         // The nested ifs save around 20+ gas over a compound boolean condition.
1628         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1629             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1630 
1631         if (to == address(0)) revert TransferToZeroAddress();
1632 
1633         _beforeTokenTransfers(from, to, tokenId, 1);
1634 
1635         // Clear approvals from the previous owner.
1636         assembly {
1637             if approvedAddress {
1638                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1639                 sstore(approvedAddressSlot, 0)
1640             }
1641         }
1642 
1643         // Underflow of the sender's balance is impossible because we check for
1644         // ownership above and the recipient's balance can't realistically overflow.
1645         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1646         unchecked {
1647             // We can directly increment and decrement the balances.
1648             --_packedAddressData[from]; // Updates: `balance -= 1`.
1649             ++_packedAddressData[to]; // Updates: `balance += 1`.
1650 
1651             // Updates:
1652             // - `address` to the next owner.
1653             // - `startTimestamp` to the timestamp of transfering.
1654             // - `burned` to `false`.
1655             // - `nextInitialized` to `true`.
1656             _packedOwnerships[tokenId] = _packOwnershipData(
1657                 to,
1658                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1659             );
1660 
1661             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1662             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1663                 uint256 nextTokenId = tokenId + 1;
1664                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1665                 if (_packedOwnerships[nextTokenId] == 0) {
1666                     // If the next slot is within bounds.
1667                     if (nextTokenId != _currentIndex) {
1668                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1669                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1670                     }
1671                 }
1672             }
1673         }
1674 
1675         emit Transfer(from, to, tokenId);
1676         _afterTokenTransfers(from, to, tokenId, 1);
1677     }
1678 
1679     /**
1680      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1681      */
1682     function safeTransferFrom(
1683         address from,
1684         address to,
1685         uint256 tokenId
1686     ) public payable virtual override {
1687         safeTransferFrom(from, to, tokenId, '');
1688     }
1689 
1690     /**
1691      * @dev Safely transfers `tokenId` token from `from` to `to`.
1692      *
1693      * Requirements:
1694      *
1695      * - `from` cannot be the zero address.
1696      * - `to` cannot be the zero address.
1697      * - `tokenId` token must exist and be owned by `from`.
1698      * - If the caller is not `from`, it must be approved to move this token
1699      * by either {approve} or {setApprovalForAll}.
1700      * - If `to` refers to a smart contract, it must implement
1701      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1702      *
1703      * Emits a {Transfer} event.
1704      */
1705     function safeTransferFrom(
1706         address from,
1707         address to,
1708         uint256 tokenId,
1709         bytes memory _data
1710     ) public payable virtual override {
1711         transferFrom(from, to, tokenId);
1712         if (to.code.length != 0)
1713             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1714                 revert TransferToNonERC721ReceiverImplementer();
1715             }
1716     }
1717 
1718     /**
1719      * @dev Hook that is called before a set of serially-ordered token IDs
1720      * are about to be transferred. This includes minting.
1721      * And also called before burning one token.
1722      *
1723      * `startTokenId` - the first token ID to be transferred.
1724      * `quantity` - the amount to be transferred.
1725      *
1726      * Calling conditions:
1727      *
1728      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1729      * transferred to `to`.
1730      * - When `from` is zero, `tokenId` will be minted for `to`.
1731      * - When `to` is zero, `tokenId` will be burned by `from`.
1732      * - `from` and `to` are never both zero.
1733      */
1734     function _beforeTokenTransfers(
1735         address from,
1736         address to,
1737         uint256 startTokenId,
1738         uint256 quantity
1739     ) internal virtual {}
1740 
1741     /**
1742      * @dev Hook that is called after a set of serially-ordered token IDs
1743      * have been transferred. This includes minting.
1744      * And also called after one token has been burned.
1745      *
1746      * `startTokenId` - the first token ID to be transferred.
1747      * `quantity` - the amount to be transferred.
1748      *
1749      * Calling conditions:
1750      *
1751      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1752      * transferred to `to`.
1753      * - When `from` is zero, `tokenId` has been minted for `to`.
1754      * - When `to` is zero, `tokenId` has been burned by `from`.
1755      * - `from` and `to` are never both zero.
1756      */
1757     function _afterTokenTransfers(
1758         address from,
1759         address to,
1760         uint256 startTokenId,
1761         uint256 quantity
1762     ) internal virtual {}
1763 
1764     /**
1765      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1766      *
1767      * `from` - Previous owner of the given token ID.
1768      * `to` - Target address that will receive the token.
1769      * `tokenId` - Token ID to be transferred.
1770      * `_data` - Optional data to send along with the call.
1771      *
1772      * Returns whether the call correctly returned the expected magic value.
1773      */
1774     function _checkContractOnERC721Received(
1775         address from,
1776         address to,
1777         uint256 tokenId,
1778         bytes memory _data
1779     ) private returns (bool) {
1780         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1781             bytes4 retval
1782         ) {
1783             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1784         } catch (bytes memory reason) {
1785             if (reason.length == 0) {
1786                 revert TransferToNonERC721ReceiverImplementer();
1787             } else {
1788                 assembly {
1789                     revert(add(32, reason), mload(reason))
1790                 }
1791             }
1792         }
1793     }
1794 
1795     // =============================================================
1796     //                        MINT OPERATIONS
1797     // =============================================================
1798 
1799     /**
1800      * @dev Mints `quantity` tokens and transfers them to `to`.
1801      *
1802      * Requirements:
1803      *
1804      * - `to` cannot be the zero address.
1805      * - `quantity` must be greater than 0.
1806      *
1807      * Emits a {Transfer} event for each mint.
1808      */
1809     function _mint(address to, uint256 quantity) internal virtual {
1810         uint256 startTokenId = _currentIndex;
1811         if (quantity == 0) revert MintZeroQuantity();
1812 
1813         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1814 
1815         // Overflows are incredibly unrealistic.
1816         // `balance` and `numberMinted` have a maximum limit of 2**64.
1817         // `tokenId` has a maximum limit of 2**256.
1818         unchecked {
1819             // Updates:
1820             // - `balance += quantity`.
1821             // - `numberMinted += quantity`.
1822             //
1823             // We can directly add to the `balance` and `numberMinted`.
1824             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1825 
1826             // Updates:
1827             // - `address` to the owner.
1828             // - `startTimestamp` to the timestamp of minting.
1829             // - `burned` to `false`.
1830             // - `nextInitialized` to `quantity == 1`.
1831             _packedOwnerships[startTokenId] = _packOwnershipData(
1832                 to,
1833                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1834             );
1835 
1836             uint256 toMasked;
1837             uint256 end = startTokenId + quantity;
1838 
1839             // Use assembly to loop and emit the `Transfer` event for gas savings.
1840             // The duplicated `log4` removes an extra check and reduces stack juggling.
1841             // The assembly, together with the surrounding Solidity code, have been
1842             // delicately arranged to nudge the compiler into producing optimized opcodes.
1843             assembly {
1844                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1845                 toMasked := and(to, _BITMASK_ADDRESS)
1846                 // Emit the `Transfer` event.
1847                 log4(
1848                     0, // Start of data (0, since no data).
1849                     0, // End of data (0, since no data).
1850                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1851                     0, // `address(0)`.
1852                     toMasked, // `to`.
1853                     startTokenId // `tokenId`.
1854                 )
1855 
1856                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1857                 // that overflows uint256 will make the loop run out of gas.
1858                 // The compiler will optimize the `iszero` away for performance.
1859                 for {
1860                     let tokenId := add(startTokenId, 1)
1861                 } iszero(eq(tokenId, end)) {
1862                     tokenId := add(tokenId, 1)
1863                 } {
1864                     // Emit the `Transfer` event. Similar to above.
1865                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1866                 }
1867             }
1868             if (toMasked == 0) revert MintToZeroAddress();
1869 
1870             _currentIndex = end;
1871         }
1872         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1873     }
1874 
1875     /**
1876      * @dev Mints `quantity` tokens and transfers them to `to`.
1877      *
1878      * This function is intended for efficient minting only during contract creation.
1879      *
1880      * It emits only one {ConsecutiveTransfer} as defined in
1881      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1882      * instead of a sequence of {Transfer} event(s).
1883      *
1884      * Calling this function outside of contract creation WILL make your contract
1885      * non-compliant with the ERC721 standard.
1886      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1887      * {ConsecutiveTransfer} event is only permissible during contract creation.
1888      *
1889      * Requirements:
1890      *
1891      * - `to` cannot be the zero address.
1892      * - `quantity` must be greater than 0.
1893      *
1894      * Emits a {ConsecutiveTransfer} event.
1895      */
1896     function _mintERC2309(address to, uint256 quantity) internal virtual {
1897         uint256 startTokenId = _currentIndex;
1898         if (to == address(0)) revert MintToZeroAddress();
1899         if (quantity == 0) revert MintZeroQuantity();
1900         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1901 
1902         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1903 
1904         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1905         unchecked {
1906             // Updates:
1907             // - `balance += quantity`.
1908             // - `numberMinted += quantity`.
1909             //
1910             // We can directly add to the `balance` and `numberMinted`.
1911             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1912 
1913             // Updates:
1914             // - `address` to the owner.
1915             // - `startTimestamp` to the timestamp of minting.
1916             // - `burned` to `false`.
1917             // - `nextInitialized` to `quantity == 1`.
1918             _packedOwnerships[startTokenId] = _packOwnershipData(
1919                 to,
1920                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1921             );
1922 
1923             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1924 
1925             _currentIndex = startTokenId + quantity;
1926         }
1927         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1928     }
1929 
1930     /**
1931      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1932      *
1933      * Requirements:
1934      *
1935      * - If `to` refers to a smart contract, it must implement
1936      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1937      * - `quantity` must be greater than 0.
1938      *
1939      * See {_mint}.
1940      *
1941      * Emits a {Transfer} event for each mint.
1942      */
1943     function _safeMint(
1944         address to,
1945         uint256 quantity,
1946         bytes memory _data
1947     ) internal virtual {
1948         _mint(to, quantity);
1949 
1950         unchecked {
1951             if (to.code.length != 0) {
1952                 uint256 end = _currentIndex;
1953                 uint256 index = end - quantity;
1954                 do {
1955                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1956                         revert TransferToNonERC721ReceiverImplementer();
1957                     }
1958                 } while (index < end);
1959                 // Reentrancy protection.
1960                 if (_currentIndex != end) revert();
1961             }
1962         }
1963     }
1964 
1965     /**
1966      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1967      */
1968     function _safeMint(address to, uint256 quantity) internal virtual {
1969         _safeMint(to, quantity, '');
1970     }
1971 
1972     // =============================================================
1973     //                        BURN OPERATIONS
1974     // =============================================================
1975 
1976     /**
1977      * @dev Equivalent to `_burn(tokenId, false)`.
1978      */
1979     function _burn(uint256 tokenId) internal virtual {
1980         _burn(tokenId, false);
1981     }
1982 
1983     /**
1984      * @dev Destroys `tokenId`.
1985      * The approval is cleared when the token is burned.
1986      *
1987      * Requirements:
1988      *
1989      * - `tokenId` must exist.
1990      *
1991      * Emits a {Transfer} event.
1992      */
1993     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1994         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1995 
1996         address from = address(uint160(prevOwnershipPacked));
1997 
1998         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1999 
2000         if (approvalCheck) {
2001             // The nested ifs save around 20+ gas over a compound boolean condition.
2002             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2003                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2004         }
2005 
2006         _beforeTokenTransfers(from, address(0), tokenId, 1);
2007 
2008         // Clear approvals from the previous owner.
2009         assembly {
2010             if approvedAddress {
2011                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2012                 sstore(approvedAddressSlot, 0)
2013             }
2014         }
2015 
2016         // Underflow of the sender's balance is impossible because we check for
2017         // ownership above and the recipient's balance can't realistically overflow.
2018         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2019         unchecked {
2020             // Updates:
2021             // - `balance -= 1`.
2022             // - `numberBurned += 1`.
2023             //
2024             // We can directly decrement the balance, and increment the number burned.
2025             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2026             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2027 
2028             // Updates:
2029             // - `address` to the last owner.
2030             // - `startTimestamp` to the timestamp of burning.
2031             // - `burned` to `true`.
2032             // - `nextInitialized` to `true`.
2033             _packedOwnerships[tokenId] = _packOwnershipData(
2034                 from,
2035                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2036             );
2037 
2038             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2039             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2040                 uint256 nextTokenId = tokenId + 1;
2041                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2042                 if (_packedOwnerships[nextTokenId] == 0) {
2043                     // If the next slot is within bounds.
2044                     if (nextTokenId != _currentIndex) {
2045                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2046                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2047                     }
2048                 }
2049             }
2050         }
2051 
2052         emit Transfer(from, address(0), tokenId);
2053         _afterTokenTransfers(from, address(0), tokenId, 1);
2054 
2055         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2056         unchecked {
2057             _burnCounter++;
2058         }
2059     }
2060 
2061     // =============================================================
2062     //                     EXTRA DATA OPERATIONS
2063     // =============================================================
2064 
2065     /**
2066      * @dev Directly sets the extra data for the ownership data `index`.
2067      */
2068     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2069         uint256 packed = _packedOwnerships[index];
2070         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2071         uint256 extraDataCasted;
2072         // Cast `extraData` with assembly to avoid redundant masking.
2073         assembly {
2074             extraDataCasted := extraData
2075         }
2076         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2077         _packedOwnerships[index] = packed;
2078     }
2079 
2080     /**
2081      * @dev Called during each token transfer to set the 24bit `extraData` field.
2082      * Intended to be overridden by the cosumer contract.
2083      *
2084      * `previousExtraData` - the value of `extraData` before transfer.
2085      *
2086      * Calling conditions:
2087      *
2088      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2089      * transferred to `to`.
2090      * - When `from` is zero, `tokenId` will be minted for `to`.
2091      * - When `to` is zero, `tokenId` will be burned by `from`.
2092      * - `from` and `to` are never both zero.
2093      */
2094     function _extraData(
2095         address from,
2096         address to,
2097         uint24 previousExtraData
2098     ) internal view virtual returns (uint24) {}
2099 
2100     /**
2101      * @dev Returns the next extra data for the packed ownership data.
2102      * The returned result is shifted into position.
2103      */
2104     function _nextExtraData(
2105         address from,
2106         address to,
2107         uint256 prevOwnershipPacked
2108     ) private view returns (uint256) {
2109         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2110         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2111     }
2112 
2113     // =============================================================
2114     //                       OTHER OPERATIONS
2115     // =============================================================
2116 
2117     /**
2118      * @dev Returns the message sender (defaults to `msg.sender`).
2119      *
2120      * If you are writing GSN compatible contracts, you need to override this function.
2121      */
2122     function _msgSenderERC721A() internal view virtual returns (address) {
2123         return msg.sender;
2124     }
2125 
2126     /**
2127      * @dev Converts a uint256 to its ASCII string decimal representation.
2128      */
2129     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2130         assembly {
2131             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2132             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2133             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2134             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2135             let m := add(mload(0x40), 0xa0)
2136             // Update the free memory pointer to allocate.
2137             mstore(0x40, m)
2138             // Assign the `str` to the end.
2139             str := sub(m, 0x20)
2140             // Zeroize the slot after the string.
2141             mstore(str, 0)
2142 
2143             // Cache the end of the memory to calculate the length later.
2144             let end := str
2145 
2146             // We write the string from rightmost digit to leftmost digit.
2147             // The following is essentially a do-while loop that also handles the zero case.
2148             // prettier-ignore
2149             for { let temp := value } 1 {} {
2150                 str := sub(str, 1)
2151                 // Write the character to the pointer.
2152                 // The ASCII index of the '0' character is 48.
2153                 mstore8(str, add(48, mod(temp, 10)))
2154                 // Keep dividing `temp` until zero.
2155                 temp := div(temp, 10)
2156                 // prettier-ignore
2157                 if iszero(temp) { break }
2158             }
2159 
2160             let length := sub(end, str)
2161             // Move the pointer 32 bytes leftwards to make room for the length.
2162             str := sub(str, 0x20)
2163             // Store the length.
2164             mstore(str, length)
2165         }
2166     }
2167 }
2168 
2169 // File: contract-allow-list/contracts/ERC721AntiScam/ERC721AntiScam.sol
2170 
2171 
2172 pragma solidity >=0.8.0;
2173 
2174 
2175 
2176 
2177 
2178 
2179 /// @title AntiScam機能付きERC721A
2180 /// @dev Readmeを見てください。
2181 
2182 abstract contract ERC721AntiScam is ERC721A, IERC721AntiScam, Ownable {
2183     using EnumerableSet for EnumerableSet.AddressSet;
2184 
2185     IContractAllowListProxy public CAL;
2186     EnumerableSet.AddressSet localAllowedAddresses;
2187 
2188     /*//////////////////////////////////////////////////////////////
2189     ロック変数。トークンごとに個別ロック設定を行う
2190     //////////////////////////////////////////////////////////////*/
2191 
2192     // token lock
2193     mapping(uint256 => LockStatus) internal _tokenLockStatus;
2194     mapping(uint256 => uint256) internal _tokenCALLevel;
2195 
2196     // wallet lock
2197     mapping(address => LockStatus) internal _walletLockStatus;
2198     mapping(address => uint256) internal _walletCALLevel;
2199 
2200     // contract lock
2201     LockStatus public contractLockStatus = LockStatus.CalLock;
2202     uint256 public CALLevel = 1;
2203 
2204     /*///////////////////////////////////////////////////////////////
2205     ロック機能ロジック
2206     //////////////////////////////////////////////////////////////*/
2207 
2208     function getLockStatus(uint256 tokenId) public virtual view override returns (LockStatus) {
2209         require(_exists(tokenId), "AntiScam: locking query for nonexistent token");
2210         return _getLockStatus(ownerOf(tokenId), tokenId);
2211     }
2212 
2213     function getTokenLocked(address operator, uint256 tokenId) public virtual view override returns(bool isLocked) {
2214         address holder = ownerOf(tokenId);
2215         LockStatus status = _getLockStatus(holder, tokenId);
2216         uint256 level = _getCALLevel(holder, tokenId);
2217 
2218         if (status == LockStatus.CalLock) {
2219             if (ownerOf(tokenId) == msg.sender) {
2220                 return false;
2221             }
2222         } else {
2223             return _getLocked(operator, status, level);
2224         }
2225     }
2226     
2227     // TODO 標準実装
2228     function getTokensUnderLock(address to) external view override returns (uint256[] memory){
2229         return new uint256[](0);
2230     }
2231 
2232     // TODO 標準実装
2233     function getTokensUnderLock(address to, uint256 start, uint256 end) external view override returns (uint256[] memory){
2234         return new uint256[](0);
2235     }
2236     
2237     // TODO 標準実装
2238     function getTokensUnderLock(address holder, address to) external view override returns (uint256[] memory){
2239         return new uint256[](0);
2240     }
2241 
2242     // TODO 標準実装
2243     function getTokensUnderLock(address holder, address to, uint256 start, uint256 end) external view override returns (uint256[] memory){
2244         return new uint256[](0);
2245     }
2246 
2247     function getLocked(address operator, address holder) public virtual view override returns(bool) {
2248         LockStatus status = _getLockStatus(holder);
2249         uint256 level = _getCALLevel(holder);
2250         return _getLocked(operator, status, level);
2251     }
2252 
2253     function _getLocked(address operator, LockStatus status, uint256 level) internal virtual view returns(bool){
2254         if (status == LockStatus.UnLock) {
2255             return false;
2256         } else if (status == LockStatus.AllLock)  {
2257             return true;
2258         } else if (status == LockStatus.CalLock) {
2259             if (isLocalAllowed(operator)) {
2260                 return false;
2261             }
2262             if (address(CAL) == address(0)) {
2263                 return true;
2264             }
2265             if (CAL.isAllowed(operator, level)) {
2266                 return false;
2267             } else {
2268                 return true;
2269             }
2270         } else {
2271             revert("LockStatus is invalid");
2272         }
2273     }
2274 
2275     function addLocalContractAllowList(address _contract) external override onlyOwner {
2276         localAllowedAddresses.add(_contract);
2277     }
2278 
2279     function removeLocalContractAllowList(address _contract) external override onlyOwner {
2280         localAllowedAddresses.remove(_contract);
2281     }
2282 
2283     function isLocalAllowed(address _transferer)
2284         public
2285         view
2286         returns (bool)
2287     {
2288         bool Allowed = false;
2289         if(localAllowedAddresses.contains(_transferer) == true){
2290             Allowed = true;
2291         }
2292         return Allowed;
2293     }
2294 
2295     function _getLockStatus(address holder, uint256 tokenId) internal virtual view returns(LockStatus){
2296         if(_tokenLockStatus[tokenId] != LockStatus.UnSet) {
2297             return _tokenLockStatus[tokenId];
2298         }
2299 
2300         return _getLockStatus(holder);
2301     }
2302 
2303     function _getLockStatus(address holder) internal virtual view returns(LockStatus){
2304         if(_walletLockStatus[holder] != LockStatus.UnSet) {
2305             return _walletLockStatus[holder];
2306         }
2307 
2308         return contractLockStatus;
2309     }
2310 
2311     function _getCALLevel(address holder, uint256 tokenId) internal virtual view returns(uint256){
2312         if(_tokenCALLevel[tokenId] > 0) {
2313             return _tokenCALLevel[tokenId];
2314         }
2315 
2316         return _getCALLevel(holder);
2317     }
2318 
2319     function _getCALLevel(address holder) internal virtual view returns(uint256){
2320         if(_walletCALLevel[holder] > 0) {
2321             return _walletCALLevel[holder];
2322         }
2323 
2324         return CALLevel;
2325     }
2326 
2327     // For token lock
2328     function _lock(LockStatus status, uint256 id) internal virtual {
2329         _tokenLockStatus[id] = status;
2330         emit TokenLock(ownerOf(id), msg.sender, uint(status), id);
2331     }
2332 
2333     // For wallet lock
2334     function _setWalletLock(address to, LockStatus status) internal virtual {
2335         _walletLockStatus[to] = status;
2336     }
2337 
2338     function _setWalletCALLevel(address to ,uint256 level) internal virtual {
2339         _walletCALLevel[to] = level;
2340     }
2341 
2342     // For contract lock
2343     function setContractAllowListLevel(uint256 level) external override onlyOwner{
2344         CALLevel = level;
2345     }
2346 
2347     function setContractLockStatus(LockStatus status) external override onlyOwner {
2348        require(status != LockStatus.UnSet, "AntiScam: contract lock status can not set UNSET");
2349        contractLockStatus = status;
2350     }
2351 
2352     function setCAL(address _cal) external onlyOwner {
2353         CAL = IContractAllowListProxy(_cal);
2354     }
2355 
2356     /*///////////////////////////////////////////////////////////////
2357                               OVERRIDES
2358     //////////////////////////////////////////////////////////////*/
2359 
2360     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2361         if(getLocked(operator, owner)){
2362             return false;
2363         }
2364         return super.isApprovedForAll(owner, operator);
2365     }
2366 
2367     function setApprovalForAll(address operator, bool approved) public virtual override {
2368         require (getLocked(operator, msg.sender) == false || approved == false, "Can not approve locked token");
2369         super.setApprovalForAll(operator, approved);
2370     }
2371 
2372     function approve(address to, uint256 tokenId) public payable virtual override {
2373         if(to != address(0)){
2374             address holder = ownerOf(tokenId);
2375             LockStatus status = _tokenLockStatus[tokenId];
2376             require (status != LockStatus.AllLock, "Can not approve locked token");
2377             if (status == LockStatus.CalLock){
2378                 uint256 level = _getCALLevel(holder, tokenId);
2379                 require (_getLocked(to, status, level) == false, "Can not approve locked token");
2380             } else if (status == LockStatus.UnSet){
2381                 require (getLocked(to,holder) == false, "Can not approve locked token");
2382             }
2383         }
2384         super.approve(to, tokenId);
2385     }
2386 
2387     function _beforeTokenTransfers(
2388         address from,
2389         address to,
2390         uint256 startTokenId,
2391         uint256 /*quantity*/
2392     ) internal virtual override {
2393         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
2394         if (from != address(0)) {
2395             // トークンがロックされている場合、転送を許可しない
2396             require(getTokenLocked(to, startTokenId) == false , "LOCKED");
2397         }
2398     }
2399 
2400     function _afterTokenTransfers(
2401         address from,
2402         address /*to*/,
2403         uint256 startTokenId,
2404         uint256 /*quantity*/
2405     ) internal virtual override {
2406         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
2407         if (from != address(0)) {
2408             // ロックをデフォルトに戻す。（デフォルトは、 contractのLock status）
2409             delete _tokenLockStatus[startTokenId];
2410             delete _tokenCALLevel[startTokenId];
2411         }
2412     }
2413 
2414 
2415     function supportsInterface(bytes4 interfaceId)
2416         public
2417         view
2418         virtual
2419         override
2420         returns (bool)
2421     {
2422         return
2423             interfaceId == type(IERC721AntiScam).interfaceId ||
2424             super.supportsInterface(interfaceId);
2425     }
2426 
2427 }
2428 // File: halloweenNinjaGirls.sol
2429 
2430 
2431 // Copyright (c) 2022 Keisuke OHNO
2432 
2433 /*
2434 
2435 Permission is hereby granted, free of charge, to any person obtaining a copy
2436 of this software and associated documentation files (the "Software"), to deal
2437 in the Software without restriction, including without limitation the rights
2438 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2439 copies of the Software, and to permit persons to whom the Software is
2440 furnished to do so, subject to the following conditions:
2441 
2442 The above copyright notice and this permission notice shall be included in all
2443 copies or substantial portions of the Software.
2444 
2445 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2446 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2447 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2448 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2449 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2450 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2451 SOFTWARE.
2452 
2453 */
2454 
2455 pragma solidity >=0.7.0 <0.9.0;
2456 
2457 //import { Base64 } from 'base64-sol/base64.sol';
2458 //import "erc721a/contracts/ERC721A.sol";
2459 
2460 
2461 
2462 
2463 
2464 //tokenURI interface
2465 interface iTokenURI {
2466     function tokenURI(uint256 _tokenId) external view returns (string memory);
2467 }
2468 
2469 interface iNFTCollection {
2470     function balanceOf(address _address) external view returns (uint256);
2471 }
2472 
2473 abstract contract Minter is Ownable {
2474     mapping(address => bool) public minters;
2475     modifier onlyMinter { require(minters[msg.sender], "Not Minter!"); _; }
2476     function setMinter(address address_, bool bool_) external onlyOwner {
2477         minters[address_] = bool_;
2478     }
2479     function isMinter(address address_) internal view returns(bool) {
2480         return minters[address_];
2481     }
2482 }
2483 
2484 contract HalloweenNinjaGirls is Ownable , Minter , ERC721AntiScam{
2485 
2486     constructor(
2487     ) ERC721A("Halloween Ninja Girls", "HNG") {
2488         setBaseURI("https://data.ninja-dao.jp/halloween/metadata/");//sanuqn
2489 
2490         NFT1 = iNFTCollection(0x7b26a78C0A4928a69AD771d4600429845a577426);//mint pass
2491         CAL = IContractAllowListProxy(0xdbaa28cBe70aF04EbFB166b1A3E8F8034e5B9FC7);//CAL proxy main net
2492 
2493         _safeMint(0xdEcf4B112d4120B6998e5020a6B4819E490F7db6, 1);
2494     }
2495 
2496 
2497     iNFTCollection public NFT1;
2498 
2499     //
2500     //withdraw section
2501     //
2502 
2503     address public constant withdrawAddress = 0xdEcf4B112d4120B6998e5020a6B4819E490F7db6;
2504 
2505     function withdraw() public onlyOwner {
2506         (bool os, ) = payable(withdrawAddress).call{value: address(this).balance}('');
2507         require(os);
2508     }
2509 
2510 
2511     //
2512     //mint section
2513     //
2514 
2515     uint256 public cost = 0;
2516     uint256 public maxSupply = 5000;
2517     uint256 public maxMintAmountPerTransaction = 3;
2518     bool public paused = true;
2519     bytes32 public constant AIRDROP_ROLE = keccak256("AIRDROP_ROLE");
2520 
2521     modifier callerIsUser() {
2522         require(tx.origin == msg.sender, "The caller is another contract.");
2523         _;
2524     }
2525  
2526     // public
2527     function mint(uint256 _mintAmount ) public payable callerIsUser{
2528         require(!paused, "the contract is paused");
2529         require(0 < _mintAmount, "need to mint at least 1 NFT");
2530         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
2531         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2532         require(cost * _mintAmount <= msg.value, "insufficient funds");
2533         require(isWhitelisted(msg.sender) == true , "You are not whitelisted" );
2534 
2535         _safeMint(msg.sender, _mintAmount);
2536     }
2537 
2538     function setNFTCollection(address _address) public onlyOwner(){
2539         NFT1 = iNFTCollection(_address);
2540     }
2541 
2542     function isWhitelisted(address _address) public view returns(bool){
2543         if( 0 < NFT1.balanceOf(_address) ) {
2544             return true;
2545         }
2546         return false;
2547     }
2548 
2549 
2550     function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public onlyOwner{
2551         uint256 _mintAmount = 0;
2552         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
2553             _mintAmount += _UserMintAmount[i];
2554         }
2555         require(0 < _mintAmount , "need to mint at least 1 NFT");
2556         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2557         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
2558             _safeMint(_airdropAddresses[i], _UserMintAmount[i] );
2559         }
2560     }
2561 
2562     function setMaxSupply(uint256 _maxSupply) public onlyOwner() {
2563         maxSupply = _maxSupply;
2564     }
2565 
2566     function setCost(uint256 _newCost) public onlyOwner {
2567         cost = _newCost;
2568     }
2569 
2570     function setMaxMintAmountPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyOwner {
2571         maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
2572     }
2573   
2574     function pause(bool _state) public onlyOwner {
2575         paused = _state;
2576     }
2577 
2578  
2579 
2580 
2581     //
2582     //URI section
2583     //
2584 
2585     string public baseURI;
2586     string public baseExtension = ".json";
2587 
2588     function _baseURI() internal view virtual override returns (string memory) {
2589         return baseURI;        
2590     }
2591 
2592     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2593         baseURI = _newBaseURI;
2594     }
2595 
2596     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2597         baseExtension = _newBaseExtension;
2598     }
2599 
2600 
2601 
2602     //
2603     //interface metadata
2604     //
2605 
2606     iTokenURI public interfaceOfTokenURI;
2607     bool public useInterfaceMetadata = false;
2608 
2609     function setInterfaceOfTokenURI(address _address) public onlyOwner() {
2610         interfaceOfTokenURI = iTokenURI(_address);
2611     }
2612 
2613     function setUseInterfaceMetadata(bool _useInterfaceMetadata) public onlyOwner() {
2614         useInterfaceMetadata = _useInterfaceMetadata;
2615     }
2616 
2617 
2618 
2619     //
2620     //token URI
2621     //
2622 
2623     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2624         if (useInterfaceMetadata == true) {
2625             return interfaceOfTokenURI.tokenURI(tokenId);
2626         }
2627         return string(abi.encodePacked(ERC721A.tokenURI(tokenId), baseExtension));
2628     }
2629 
2630 
2631 
2632     //
2633     //burnin' section
2634     //
2635 
2636     function externalMint(address _address , uint256 _amount ) external payable onlyMinter{
2637         require(totalSupply() + _amount <= maxSupply, "max NFT limit exceeded");
2638         _safeMint( _address, _amount );
2639     }
2640 
2641 
2642     //
2643     //viewer section
2644     //
2645 
2646     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
2647         unchecked {
2648             uint256 tokenIdsIdx;
2649             address currOwnershipAddr;
2650             uint256 tokenIdsLength = balanceOf(owner);
2651             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2652             TokenOwnership memory ownership;
2653             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2654                 ownership = _ownershipAt(i);
2655                 if (ownership.burned) {
2656                     continue;
2657                 }
2658                 if (ownership.addr != address(0)) {
2659                     currOwnershipAddr = ownership.addr;
2660                 }
2661                 if (currOwnershipAddr == owner) {
2662                     tokenIds[tokenIdsIdx++] = i;
2663                 }
2664             }
2665             return tokenIds;
2666         }
2667     }
2668 
2669 
2670 
2671     //
2672     //sbt section
2673     //
2674 
2675     bool public isSBT = false;
2676 
2677     function setIsSBT(bool _state) public onlyOwner {
2678         isSBT = _state;
2679     }
2680 
2681     function _beforeTokenTransfers( address from, address to, uint256 startTokenId, uint256 quantity) internal virtual override{
2682         require( isSBT == false || from == address(0) || to == address(0x000000000000000000000000000000000000dEaD), "transfer is prohibited");
2683         super._beforeTokenTransfers(from, to, startTokenId, quantity);
2684     }
2685 
2686     function setApprovalForAll(address operator, bool approved) public virtual override {
2687         require( isSBT == false , "setApprovalForAll is prohibited");
2688         super.setApprovalForAll(operator, approved);
2689     }
2690 
2691     function approve(address to, uint256 tokenId) public payable virtual override {
2692         require( isSBT == false , "approve is prohibited");
2693         super.approve(to, tokenId);
2694     }
2695 
2696 
2697 
2698     //
2699     //override
2700     //
2701 
2702     function _startTokenId() internal view virtual override returns (uint256) {
2703         return 1;
2704     }
2705 
2706 
2707 }