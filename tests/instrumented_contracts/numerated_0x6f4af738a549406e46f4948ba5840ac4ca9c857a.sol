1 // SPDX-License-Identifier: MIT
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
263 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
264 
265 
266 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 // CAUTION
271 // This version of SafeMath should only be used with Solidity 0.8 or later,
272 // because it relies on the compiler's built in overflow checks.
273 
274 /**
275  * @dev Wrappers over Solidity's arithmetic operations.
276  *
277  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
278  * now has built in overflow checking.
279  */
280 library SafeMath {
281     /**
282      * @dev Returns the addition of two unsigned integers, with an overflow flag.
283      *
284      * _Available since v3.4._
285      */
286     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             uint256 c = a + b;
289             if (c < a) return (false, 0);
290             return (true, c);
291         }
292     }
293 
294     /**
295      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
296      *
297      * _Available since v3.4._
298      */
299     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             if (b > a) return (false, 0);
302             return (true, a - b);
303         }
304     }
305 
306     /**
307      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
308      *
309      * _Available since v3.4._
310      */
311     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
312         unchecked {
313             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
314             // benefit is lost if 'b' is also tested.
315             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
316             if (a == 0) return (true, 0);
317             uint256 c = a * b;
318             if (c / a != b) return (false, 0);
319             return (true, c);
320         }
321     }
322 
323     /**
324      * @dev Returns the division of two unsigned integers, with a division by zero flag.
325      *
326      * _Available since v3.4._
327      */
328     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
329         unchecked {
330             if (b == 0) return (false, 0);
331             return (true, a / b);
332         }
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         unchecked {
342             if (b == 0) return (false, 0);
343             return (true, a % b);
344         }
345     }
346 
347     /**
348      * @dev Returns the addition of two unsigned integers, reverting on
349      * overflow.
350      *
351      * Counterpart to Solidity's `+` operator.
352      *
353      * Requirements:
354      *
355      * - Addition cannot overflow.
356      */
357     function add(uint256 a, uint256 b) internal pure returns (uint256) {
358         return a + b;
359     }
360 
361     /**
362      * @dev Returns the subtraction of two unsigned integers, reverting on
363      * overflow (when the result is negative).
364      *
365      * Counterpart to Solidity's `-` operator.
366      *
367      * Requirements:
368      *
369      * - Subtraction cannot overflow.
370      */
371     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
372         return a - b;
373     }
374 
375     /**
376      * @dev Returns the multiplication of two unsigned integers, reverting on
377      * overflow.
378      *
379      * Counterpart to Solidity's `*` operator.
380      *
381      * Requirements:
382      *
383      * - Multiplication cannot overflow.
384      */
385     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
386         return a * b;
387     }
388 
389     /**
390      * @dev Returns the integer division of two unsigned integers, reverting on
391      * division by zero. The result is rounded towards zero.
392      *
393      * Counterpart to Solidity's `/` operator.
394      *
395      * Requirements:
396      *
397      * - The divisor cannot be zero.
398      */
399     function div(uint256 a, uint256 b) internal pure returns (uint256) {
400         return a / b;
401     }
402 
403     /**
404      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
405      * reverting when dividing by zero.
406      *
407      * Counterpart to Solidity's `%` operator. This function uses a `revert`
408      * opcode (which leaves remaining gas untouched) while Solidity uses an
409      * invalid opcode to revert (consuming all remaining gas).
410      *
411      * Requirements:
412      *
413      * - The divisor cannot be zero.
414      */
415     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
416         return a % b;
417     }
418 
419     /**
420      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
421      * overflow (when the result is negative).
422      *
423      * CAUTION: This function is deprecated because it requires allocating memory for the error
424      * message unnecessarily. For custom revert reasons use {trySub}.
425      *
426      * Counterpart to Solidity's `-` operator.
427      *
428      * Requirements:
429      *
430      * - Subtraction cannot overflow.
431      */
432     function sub(
433         uint256 a,
434         uint256 b,
435         string memory errorMessage
436     ) internal pure returns (uint256) {
437         unchecked {
438             require(b <= a, errorMessage);
439             return a - b;
440         }
441     }
442 
443     /**
444      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
445      * division by zero. The result is rounded towards zero.
446      *
447      * Counterpart to Solidity's `/` operator. Note: this function uses a
448      * `revert` opcode (which leaves remaining gas untouched) while Solidity
449      * uses an invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function div(
456         uint256 a,
457         uint256 b,
458         string memory errorMessage
459     ) internal pure returns (uint256) {
460         unchecked {
461             require(b > 0, errorMessage);
462             return a / b;
463         }
464     }
465 
466     /**
467      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
468      * reverting with custom message when dividing by zero.
469      *
470      * CAUTION: This function is deprecated because it requires allocating memory for the error
471      * message unnecessarily. For custom revert reasons use {tryMod}.
472      *
473      * Counterpart to Solidity's `%` operator. This function uses a `revert`
474      * opcode (which leaves remaining gas untouched) while Solidity uses an
475      * invalid opcode to revert (consuming all remaining gas).
476      *
477      * Requirements:
478      *
479      * - The divisor cannot be zero.
480      */
481     function mod(
482         uint256 a,
483         uint256 b,
484         string memory errorMessage
485     ) internal pure returns (uint256) {
486         unchecked {
487             require(b > 0, errorMessage);
488             return a % b;
489         }
490     }
491 }
492 
493 // File: @openzeppelin/contracts/utils/Strings.sol
494 
495 
496 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev String operations.
502  */
503 library Strings {
504     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
505     uint8 private constant _ADDRESS_LENGTH = 20;
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
509      */
510     function toString(uint256 value) internal pure returns (string memory) {
511         // Inspired by OraclizeAPI's implementation - MIT licence
512         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
513 
514         if (value == 0) {
515             return "0";
516         }
517         uint256 temp = value;
518         uint256 digits;
519         while (temp != 0) {
520             digits++;
521             temp /= 10;
522         }
523         bytes memory buffer = new bytes(digits);
524         while (value != 0) {
525             digits -= 1;
526             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
527             value /= 10;
528         }
529         return string(buffer);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
534      */
535     function toHexString(uint256 value) internal pure returns (string memory) {
536         if (value == 0) {
537             return "0x00";
538         }
539         uint256 temp = value;
540         uint256 length = 0;
541         while (temp != 0) {
542             length++;
543             temp >>= 8;
544         }
545         return toHexString(value, length);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
550      */
551     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
552         bytes memory buffer = new bytes(2 * length + 2);
553         buffer[0] = "0";
554         buffer[1] = "x";
555         for (uint256 i = 2 * length + 1; i > 1; --i) {
556             buffer[i] = _HEX_SYMBOLS[value & 0xf];
557             value >>= 4;
558         }
559         require(value == 0, "Strings: hex length insufficient");
560         return string(buffer);
561     }
562 
563     /**
564      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
565      */
566     function toHexString(address addr) internal pure returns (string memory) {
567         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
568     }
569 }
570 
571 // File: @openzeppelin/contracts/utils/Context.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @dev Provides information about the current execution context, including the
580  * sender of the transaction and its data. While these are generally available
581  * via msg.sender and msg.data, they should not be accessed in such a direct
582  * manner, since when dealing with meta-transactions the account sending and
583  * paying for execution may not be the actual sender (as far as an application
584  * is concerned).
585  *
586  * This contract is only required for intermediate, library-like contracts.
587  */
588 abstract contract Context {
589     function _msgSender() internal view virtual returns (address) {
590         return msg.sender;
591     }
592 
593     function _msgData() internal view virtual returns (bytes calldata) {
594         return msg.data;
595     }
596 }
597 
598 // File: @openzeppelin/contracts/security/Pausable.sol
599 
600 
601 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @dev Contract module which allows children to implement an emergency stop
608  * mechanism that can be triggered by an authorized account.
609  *
610  * This module is used through inheritance. It will make available the
611  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
612  * the functions of your contract. Note that they will not be pausable by
613  * simply including this module, only once the modifiers are put in place.
614  */
615 abstract contract Pausable is Context {
616     /**
617      * @dev Emitted when the pause is triggered by `account`.
618      */
619     event Paused(address account);
620 
621     /**
622      * @dev Emitted when the pause is lifted by `account`.
623      */
624     event Unpaused(address account);
625 
626     bool private _paused;
627 
628     /**
629      * @dev Initializes the contract in unpaused state.
630      */
631     constructor() {
632         _paused = false;
633     }
634 
635     /**
636      * @dev Modifier to make a function callable only when the contract is not paused.
637      *
638      * Requirements:
639      *
640      * - The contract must not be paused.
641      */
642     modifier whenNotPaused() {
643         _requireNotPaused();
644         _;
645     }
646 
647     /**
648      * @dev Modifier to make a function callable only when the contract is paused.
649      *
650      * Requirements:
651      *
652      * - The contract must be paused.
653      */
654     modifier whenPaused() {
655         _requirePaused();
656         _;
657     }
658 
659     /**
660      * @dev Returns true if the contract is paused, and false otherwise.
661      */
662     function paused() public view virtual returns (bool) {
663         return _paused;
664     }
665 
666     /**
667      * @dev Throws if the contract is paused.
668      */
669     function _requireNotPaused() internal view virtual {
670         require(!paused(), "Pausable: paused");
671     }
672 
673     /**
674      * @dev Throws if the contract is not paused.
675      */
676     function _requirePaused() internal view virtual {
677         require(paused(), "Pausable: not paused");
678     }
679 
680     /**
681      * @dev Triggers stopped state.
682      *
683      * Requirements:
684      *
685      * - The contract must not be paused.
686      */
687     function _pause() internal virtual whenNotPaused {
688         _paused = true;
689         emit Paused(_msgSender());
690     }
691 
692     /**
693      * @dev Returns to normal state.
694      *
695      * Requirements:
696      *
697      * - The contract must be paused.
698      */
699     function _unpause() internal virtual whenPaused {
700         _paused = false;
701         emit Unpaused(_msgSender());
702     }
703 }
704 
705 // File: @openzeppelin/contracts/access/Ownable.sol
706 
707 
708 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @dev Contract module which provides a basic access control mechanism, where
715  * there is an account (an owner) that can be granted exclusive access to
716  * specific functions.
717  *
718  * By default, the owner account will be the one that deploys the contract. This
719  * can later be changed with {transferOwnership}.
720  *
721  * This module is used through inheritance. It will make available the modifier
722  * `onlyOwner`, which can be applied to your functions to restrict their use to
723  * the owner.
724  */
725 abstract contract Ownable is Context {
726     address private _owner;
727 
728     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
729 
730     /**
731      * @dev Initializes the contract setting the deployer as the initial owner.
732      */
733     constructor() {
734         _transferOwnership(_msgSender());
735     }
736 
737     /**
738      * @dev Throws if called by any account other than the owner.
739      */
740     modifier onlyOwner() {
741         _checkOwner();
742         _;
743     }
744 
745     /**
746      * @dev Returns the address of the current owner.
747      */
748     function owner() public view virtual returns (address) {
749         return _owner;
750     }
751 
752     /**
753      * @dev Throws if the sender is not the owner.
754      */
755     function _checkOwner() internal view virtual {
756         require(owner() == _msgSender(), "Ownable: caller is not the owner");
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * `onlyOwner` functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         _transferOwnership(address(0));
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
772      * Can only be called by the current owner.
773      */
774     function transferOwnership(address newOwner) public virtual onlyOwner {
775         require(newOwner != address(0), "Ownable: new owner is the zero address");
776         _transferOwnership(newOwner);
777     }
778 
779     /**
780      * @dev Transfers ownership of the contract to a new account (`newOwner`).
781      * Internal function without access restriction.
782      */
783     function _transferOwnership(address newOwner) internal virtual {
784         address oldOwner = _owner;
785         _owner = newOwner;
786         emit OwnershipTransferred(oldOwner, newOwner);
787     }
788 }
789 
790 // File: @openzeppelin/contracts/utils/Address.sol
791 
792 
793 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
794 
795 pragma solidity ^0.8.1;
796 
797 /**
798  * @dev Collection of functions related to the address type
799  */
800 library Address {
801     /**
802      * @dev Returns true if `account` is a contract.
803      *
804      * [IMPORTANT]
805      * ====
806      * It is unsafe to assume that an address for which this function returns
807      * false is an externally-owned account (EOA) and not a contract.
808      *
809      * Among others, `isContract` will return false for the following
810      * types of addresses:
811      *
812      *  - an externally-owned account
813      *  - a contract in construction
814      *  - an address where a contract will be created
815      *  - an address where a contract lived, but was destroyed
816      * ====
817      *
818      * [IMPORTANT]
819      * ====
820      * You shouldn't rely on `isContract` to protect against flash loan attacks!
821      *
822      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
823      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
824      * constructor.
825      * ====
826      */
827     function isContract(address account) internal view returns (bool) {
828         // This method relies on extcodesize/address.code.length, which returns 0
829         // for contracts in construction, since the code is only stored at the end
830         // of the constructor execution.
831 
832         return account.code.length > 0;
833     }
834 
835     /**
836      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
837      * `recipient`, forwarding all available gas and reverting on errors.
838      *
839      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
840      * of certain opcodes, possibly making contracts go over the 2300 gas limit
841      * imposed by `transfer`, making them unable to receive funds via
842      * `transfer`. {sendValue} removes this limitation.
843      *
844      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
845      *
846      * IMPORTANT: because control is transferred to `recipient`, care must be
847      * taken to not create reentrancy vulnerabilities. Consider using
848      * {ReentrancyGuard} or the
849      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
850      */
851     function sendValue(address payable recipient, uint256 amount) internal {
852         require(address(this).balance >= amount, "Address: insufficient balance");
853 
854         (bool success, ) = recipient.call{value: amount}("");
855         require(success, "Address: unable to send value, recipient may have reverted");
856     }
857 
858     /**
859      * @dev Performs a Solidity function call using a low level `call`. A
860      * plain `call` is an unsafe replacement for a function call: use this
861      * function instead.
862      *
863      * If `target` reverts with a revert reason, it is bubbled up by this
864      * function (like regular Solidity function calls).
865      *
866      * Returns the raw returned data. To convert to the expected return value,
867      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
868      *
869      * Requirements:
870      *
871      * - `target` must be a contract.
872      * - calling `target` with `data` must not revert.
873      *
874      * _Available since v3.1._
875      */
876     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
877         return functionCall(target, data, "Address: low-level call failed");
878     }
879 
880     /**
881      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
882      * `errorMessage` as a fallback revert reason when `target` reverts.
883      *
884      * _Available since v3.1._
885      */
886     function functionCall(
887         address target,
888         bytes memory data,
889         string memory errorMessage
890     ) internal returns (bytes memory) {
891         return functionCallWithValue(target, data, 0, errorMessage);
892     }
893 
894     /**
895      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
896      * but also transferring `value` wei to `target`.
897      *
898      * Requirements:
899      *
900      * - the calling contract must have an ETH balance of at least `value`.
901      * - the called Solidity function must be `payable`.
902      *
903      * _Available since v3.1._
904      */
905     function functionCallWithValue(
906         address target,
907         bytes memory data,
908         uint256 value
909     ) internal returns (bytes memory) {
910         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
911     }
912 
913     /**
914      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
915      * with `errorMessage` as a fallback revert reason when `target` reverts.
916      *
917      * _Available since v3.1._
918      */
919     function functionCallWithValue(
920         address target,
921         bytes memory data,
922         uint256 value,
923         string memory errorMessage
924     ) internal returns (bytes memory) {
925         require(address(this).balance >= value, "Address: insufficient balance for call");
926         require(isContract(target), "Address: call to non-contract");
927 
928         (bool success, bytes memory returndata) = target.call{value: value}(data);
929         return verifyCallResult(success, returndata, errorMessage);
930     }
931 
932     /**
933      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
934      * but performing a static call.
935      *
936      * _Available since v3.3._
937      */
938     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
939         return functionStaticCall(target, data, "Address: low-level static call failed");
940     }
941 
942     /**
943      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
944      * but performing a static call.
945      *
946      * _Available since v3.3._
947      */
948     function functionStaticCall(
949         address target,
950         bytes memory data,
951         string memory errorMessage
952     ) internal view returns (bytes memory) {
953         require(isContract(target), "Address: static call to non-contract");
954 
955         (bool success, bytes memory returndata) = target.staticcall(data);
956         return verifyCallResult(success, returndata, errorMessage);
957     }
958 
959     /**
960      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
961      * but performing a delegate call.
962      *
963      * _Available since v3.4._
964      */
965     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
966         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
967     }
968 
969     /**
970      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
971      * but performing a delegate call.
972      *
973      * _Available since v3.4._
974      */
975     function functionDelegateCall(
976         address target,
977         bytes memory data,
978         string memory errorMessage
979     ) internal returns (bytes memory) {
980         require(isContract(target), "Address: delegate call to non-contract");
981 
982         (bool success, bytes memory returndata) = target.delegatecall(data);
983         return verifyCallResult(success, returndata, errorMessage);
984     }
985 
986     /**
987      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
988      * revert reason using the provided one.
989      *
990      * _Available since v4.3._
991      */
992     function verifyCallResult(
993         bool success,
994         bytes memory returndata,
995         string memory errorMessage
996     ) internal pure returns (bytes memory) {
997         if (success) {
998             return returndata;
999         } else {
1000             // Look for revert reason and bubble it up if present
1001             if (returndata.length > 0) {
1002                 // The easiest way to bubble the revert reason is using memory via assembly
1003                 /// @solidity memory-safe-assembly
1004                 assembly {
1005                     let returndata_size := mload(returndata)
1006                     revert(add(32, returndata), returndata_size)
1007                 }
1008             } else {
1009                 revert(errorMessage);
1010             }
1011         }
1012     }
1013 }
1014 
1015 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1016 
1017 
1018 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 /**
1023  * @title ERC721 token receiver interface
1024  * @dev Interface for any contract that wants to support safeTransfers
1025  * from ERC721 asset contracts.
1026  */
1027 interface IERC721Receiver {
1028     /**
1029      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1030      * by `operator` from `from`, this function is called.
1031      *
1032      * It must return its Solidity selector to confirm the token transfer.
1033      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1034      *
1035      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1036      */
1037     function onERC721Received(
1038         address operator,
1039         address from,
1040         uint256 tokenId,
1041         bytes calldata data
1042     ) external returns (bytes4);
1043 }
1044 
1045 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1046 
1047 
1048 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 /**
1053  * @dev Interface of the ERC165 standard, as defined in the
1054  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1055  *
1056  * Implementers can declare support of contract interfaces, which can then be
1057  * queried by others ({ERC165Checker}).
1058  *
1059  * For an implementation, see {ERC165}.
1060  */
1061 interface IERC165 {
1062     /**
1063      * @dev Returns true if this contract implements the interface defined by
1064      * `interfaceId`. See the corresponding
1065      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1066      * to learn more about how these ids are created.
1067      *
1068      * This function call must use less than 30 000 gas.
1069      */
1070     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1071 }
1072 
1073 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1074 
1075 
1076 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 
1081 /**
1082  * @dev Implementation of the {IERC165} interface.
1083  *
1084  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1085  * for the additional interface id that will be supported. For example:
1086  *
1087  * ```solidity
1088  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1089  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1090  * }
1091  * ```
1092  *
1093  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1094  */
1095 abstract contract ERC165 is IERC165 {
1096     /**
1097      * @dev See {IERC165-supportsInterface}.
1098      */
1099     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1100         return interfaceId == type(IERC165).interfaceId;
1101     }
1102 }
1103 
1104 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1105 
1106 
1107 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 
1112 /**
1113  * @dev Required interface of an ERC721 compliant contract.
1114  */
1115 interface IERC721 is IERC165 {
1116     /**
1117      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1118      */
1119     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1120 
1121     /**
1122      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1123      */
1124     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1125 
1126     /**
1127      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1128      */
1129     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1130 
1131     /**
1132      * @dev Returns the number of tokens in ``owner``'s account.
1133      */
1134     function balanceOf(address owner) external view returns (uint256 balance);
1135 
1136     /**
1137      * @dev Returns the owner of the `tokenId` token.
1138      *
1139      * Requirements:
1140      *
1141      * - `tokenId` must exist.
1142      */
1143     function ownerOf(uint256 tokenId) external view returns (address owner);
1144 
1145     /**
1146      * @dev Safely transfers `tokenId` token from `from` to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `from` cannot be the zero address.
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must exist and be owned by `from`.
1153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function safeTransferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes calldata data
1163     ) external;
1164 
1165     /**
1166      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1167      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1168      *
1169      * Requirements:
1170      *
1171      * - `from` cannot be the zero address.
1172      * - `to` cannot be the zero address.
1173      * - `tokenId` token must exist and be owned by `from`.
1174      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function safeTransferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) external;
1184 
1185     /**
1186      * @dev Transfers `tokenId` token from `from` to `to`.
1187      *
1188      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1189      *
1190      * Requirements:
1191      *
1192      * - `from` cannot be the zero address.
1193      * - `to` cannot be the zero address.
1194      * - `tokenId` token must be owned by `from`.
1195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function transferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) external;
1204 
1205     /**
1206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1207      * The approval is cleared when the token is transferred.
1208      *
1209      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1210      *
1211      * Requirements:
1212      *
1213      * - The caller must own the token or be an approved operator.
1214      * - `tokenId` must exist.
1215      *
1216      * Emits an {Approval} event.
1217      */
1218     function approve(address to, uint256 tokenId) external;
1219 
1220     /**
1221      * @dev Approve or remove `operator` as an operator for the caller.
1222      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1223      *
1224      * Requirements:
1225      *
1226      * - The `operator` cannot be the caller.
1227      *
1228      * Emits an {ApprovalForAll} event.
1229      */
1230     function setApprovalForAll(address operator, bool _approved) external;
1231 
1232     /**
1233      * @dev Returns the account approved for `tokenId` token.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      */
1239     function getApproved(uint256 tokenId) external view returns (address operator);
1240 
1241     /**
1242      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1243      *
1244      * See {setApprovalForAll}
1245      */
1246     function isApprovedForAll(address owner, address operator) external view returns (bool);
1247 }
1248 
1249 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1250 
1251 
1252 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 
1257 /**
1258  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1259  * @dev See https://eips.ethereum.org/EIPS/eip-721
1260  */
1261 interface IERC721Enumerable is IERC721 {
1262     /**
1263      * @dev Returns the total amount of tokens stored by the contract.
1264      */
1265     function totalSupply() external view returns (uint256);
1266 
1267     /**
1268      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1269      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1270      */
1271     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1272 
1273     /**
1274      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1275      * Use along with {totalSupply} to enumerate all tokens.
1276      */
1277     function tokenByIndex(uint256 index) external view returns (uint256);
1278 }
1279 
1280 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1281 
1282 
1283 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 
1288 /**
1289  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1290  * @dev See https://eips.ethereum.org/EIPS/eip-721
1291  */
1292 interface IERC721Metadata is IERC721 {
1293     /**
1294      * @dev Returns the token collection name.
1295      */
1296     function name() external view returns (string memory);
1297 
1298     /**
1299      * @dev Returns the token collection symbol.
1300      */
1301     function symbol() external view returns (string memory);
1302 
1303     /**
1304      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1305      */
1306     function tokenURI(uint256 tokenId) external view returns (string memory);
1307 }
1308 
1309 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1310 
1311 
1312 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 
1323 /**
1324  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1325  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1326  * {ERC721Enumerable}.
1327  */
1328 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1329     using Address for address;
1330     using Strings for uint256;
1331 
1332     // Token name
1333     string private _name;
1334 
1335     // Token symbol
1336     string private _symbol;
1337 
1338     // Mapping from token ID to owner address
1339     mapping(uint256 => address) private _owners;
1340 
1341     // Mapping owner address to token count
1342     mapping(address => uint256) private _balances;
1343 
1344     // Mapping from token ID to approved address
1345     mapping(uint256 => address) private _tokenApprovals;
1346 
1347     // Mapping from owner to operator approvals
1348     mapping(address => mapping(address => bool)) private _operatorApprovals;
1349 
1350     /**
1351      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1352      */
1353     constructor(string memory name_, string memory symbol_) {
1354         _name = name_;
1355         _symbol = symbol_;
1356     }
1357 
1358     /**
1359      * @dev See {IERC165-supportsInterface}.
1360      */
1361     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1362         return
1363             interfaceId == type(IERC721).interfaceId ||
1364             interfaceId == type(IERC721Metadata).interfaceId ||
1365             super.supportsInterface(interfaceId);
1366     }
1367 
1368     /**
1369      * @dev See {IERC721-balanceOf}.
1370      */
1371     function balanceOf(address owner) public view virtual override returns (uint256) {
1372         require(owner != address(0), "ERC721: address zero is not a valid owner");
1373         return _balances[owner];
1374     }
1375 
1376     /**
1377      * @dev See {IERC721-ownerOf}.
1378      */
1379     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1380         address owner = _owners[tokenId];
1381         require(owner != address(0), "ERC721: invalid token ID");
1382         return owner;
1383     }
1384 
1385     /**
1386      * @dev See {IERC721Metadata-name}.
1387      */
1388     function name() public view virtual override returns (string memory) {
1389         return _name;
1390     }
1391 
1392     /**
1393      * @dev See {IERC721Metadata-symbol}.
1394      */
1395     function symbol() public view virtual override returns (string memory) {
1396         return _symbol;
1397     }
1398 
1399     /**
1400      * @dev See {IERC721Metadata-tokenURI}.
1401      */
1402     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1403         _requireMinted(tokenId);
1404 
1405         string memory baseURI = _baseURI();
1406         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1407     }
1408 
1409     /**
1410      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1411      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1412      * by default, can be overridden in child contracts.
1413      */
1414     function _baseURI() internal view virtual returns (string memory) {
1415         return "";
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-approve}.
1420      */
1421     function approve(address to, uint256 tokenId) public virtual override {
1422         address owner = ERC721.ownerOf(tokenId);
1423         require(to != owner, "ERC721: approval to current owner");
1424 
1425         require(
1426             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1427             "ERC721: approve caller is not token owner nor approved for all"
1428         );
1429 
1430         _approve(to, tokenId);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-getApproved}.
1435      */
1436     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1437         _requireMinted(tokenId);
1438 
1439         return _tokenApprovals[tokenId];
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-setApprovalForAll}.
1444      */
1445     function setApprovalForAll(address operator, bool approved) public virtual override {
1446         _setApprovalForAll(_msgSender(), operator, approved);
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-isApprovedForAll}.
1451      */
1452     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1453         return _operatorApprovals[owner][operator];
1454     }
1455 
1456     /**
1457      * @dev See {IERC721-transferFrom}.
1458      */
1459     function transferFrom(
1460         address from,
1461         address to,
1462         uint256 tokenId
1463     ) public virtual override {
1464         //solhint-disable-next-line max-line-length
1465         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1466 
1467         _transfer(from, to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-safeTransferFrom}.
1472      */
1473     function safeTransferFrom(
1474         address from,
1475         address to,
1476         uint256 tokenId
1477     ) public virtual override {
1478         safeTransferFrom(from, to, tokenId, "");
1479     }
1480 
1481     /**
1482      * @dev See {IERC721-safeTransferFrom}.
1483      */
1484     function safeTransferFrom(
1485         address from,
1486         address to,
1487         uint256 tokenId,
1488         bytes memory data
1489     ) public virtual override {
1490         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1491         _safeTransfer(from, to, tokenId, data);
1492     }
1493 
1494     /**
1495      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1496      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1497      *
1498      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1499      *
1500      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1501      * implement alternative mechanisms to perform token transfer, such as signature-based.
1502      *
1503      * Requirements:
1504      *
1505      * - `from` cannot be the zero address.
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must exist and be owned by `from`.
1508      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _safeTransfer(
1513         address from,
1514         address to,
1515         uint256 tokenId,
1516         bytes memory data
1517     ) internal virtual {
1518         _transfer(from, to, tokenId);
1519         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1520     }
1521 
1522     /**
1523      * @dev Returns whether `tokenId` exists.
1524      *
1525      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1526      *
1527      * Tokens start existing when they are minted (`_mint`),
1528      * and stop existing when they are burned (`_burn`).
1529      */
1530     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1531         return _owners[tokenId] != address(0);
1532     }
1533 
1534     /**
1535      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must exist.
1540      */
1541     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1542         address owner = ERC721.ownerOf(tokenId);
1543         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1544     }
1545 
1546     /**
1547      * @dev Safely mints `tokenId` and transfers it to `to`.
1548      *
1549      * Requirements:
1550      *
1551      * - `tokenId` must not exist.
1552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1553      *
1554      * Emits a {Transfer} event.
1555      */
1556     function _safeMint(address to, uint256 tokenId) internal virtual {
1557         _safeMint(to, tokenId, "");
1558     }
1559 
1560     /**
1561      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1562      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1563      */
1564     function _safeMint(
1565         address to,
1566         uint256 tokenId,
1567         bytes memory data
1568     ) internal virtual {
1569         _mint(to, tokenId);
1570         require(
1571             _checkOnERC721Received(address(0), to, tokenId, data),
1572             "ERC721: transfer to non ERC721Receiver implementer"
1573         );
1574     }
1575 
1576     /**
1577      * @dev Mints `tokenId` and transfers it to `to`.
1578      *
1579      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1580      *
1581      * Requirements:
1582      *
1583      * - `tokenId` must not exist.
1584      * - `to` cannot be the zero address.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function _mint(address to, uint256 tokenId) internal virtual {
1589         require(to != address(0), "ERC721: mint to the zero address");
1590         require(!_exists(tokenId), "ERC721: token already minted");
1591 
1592         _beforeTokenTransfer(address(0), to, tokenId);
1593 
1594         _balances[to] += 1;
1595         _owners[tokenId] = to;
1596 
1597         emit Transfer(address(0), to, tokenId);
1598 
1599         _afterTokenTransfer(address(0), to, tokenId);
1600     }
1601 
1602     /**
1603      * @dev Destroys `tokenId`.
1604      * The approval is cleared when the token is burned.
1605      *
1606      * Requirements:
1607      *
1608      * - `tokenId` must exist.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function _burn(uint256 tokenId) internal virtual {
1613         address owner = ERC721.ownerOf(tokenId);
1614 
1615         _beforeTokenTransfer(owner, address(0), tokenId);
1616 
1617         // Clear approvals
1618         _approve(address(0), tokenId);
1619 
1620         _balances[owner] -= 1;
1621         delete _owners[tokenId];
1622 
1623         emit Transfer(owner, address(0), tokenId);
1624 
1625         _afterTokenTransfer(owner, address(0), tokenId);
1626     }
1627 
1628     /**
1629      * @dev Transfers `tokenId` from `from` to `to`.
1630      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1631      *
1632      * Requirements:
1633      *
1634      * - `to` cannot be the zero address.
1635      * - `tokenId` token must be owned by `from`.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _transfer(
1640         address from,
1641         address to,
1642         uint256 tokenId
1643     ) internal virtual {
1644         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1645         require(to != address(0), "ERC721: transfer to the zero address");
1646 
1647         _beforeTokenTransfer(from, to, tokenId);
1648 
1649         // Clear approvals from the previous owner
1650         _approve(address(0), tokenId);
1651 
1652         _balances[from] -= 1;
1653         _balances[to] += 1;
1654         _owners[tokenId] = to;
1655 
1656         emit Transfer(from, to, tokenId);
1657 
1658         _afterTokenTransfer(from, to, tokenId);
1659     }
1660 
1661     /**
1662      * @dev Approve `to` to operate on `tokenId`
1663      *
1664      * Emits an {Approval} event.
1665      */
1666     function _approve(address to, uint256 tokenId) internal virtual {
1667         _tokenApprovals[tokenId] = to;
1668         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1669     }
1670 
1671     /**
1672      * @dev Approve `operator` to operate on all of `owner` tokens
1673      *
1674      * Emits an {ApprovalForAll} event.
1675      */
1676     function _setApprovalForAll(
1677         address owner,
1678         address operator,
1679         bool approved
1680     ) internal virtual {
1681         require(owner != operator, "ERC721: approve to caller");
1682         _operatorApprovals[owner][operator] = approved;
1683         emit ApprovalForAll(owner, operator, approved);
1684     }
1685 
1686     /**
1687      * @dev Reverts if the `tokenId` has not been minted yet.
1688      */
1689     function _requireMinted(uint256 tokenId) internal view virtual {
1690         require(_exists(tokenId), "ERC721: invalid token ID");
1691     }
1692 
1693     /**
1694      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1695      * The call is not executed if the target address is not a contract.
1696      *
1697      * @param from address representing the previous owner of the given token ID
1698      * @param to target address that will receive the tokens
1699      * @param tokenId uint256 ID of the token to be transferred
1700      * @param data bytes optional data to send along with the call
1701      * @return bool whether the call correctly returned the expected magic value
1702      */
1703     function _checkOnERC721Received(
1704         address from,
1705         address to,
1706         uint256 tokenId,
1707         bytes memory data
1708     ) private returns (bool) {
1709         if (to.isContract()) {
1710             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1711                 return retval == IERC721Receiver.onERC721Received.selector;
1712             } catch (bytes memory reason) {
1713                 if (reason.length == 0) {
1714                     revert("ERC721: transfer to non ERC721Receiver implementer");
1715                 } else {
1716                     /// @solidity memory-safe-assembly
1717                     assembly {
1718                         revert(add(32, reason), mload(reason))
1719                     }
1720                 }
1721             }
1722         } else {
1723             return true;
1724         }
1725     }
1726 
1727     /**
1728      * @dev Hook that is called before any token transfer. This includes minting
1729      * and burning.
1730      *
1731      * Calling conditions:
1732      *
1733      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1734      * transferred to `to`.
1735      * - When `from` is zero, `tokenId` will be minted for `to`.
1736      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1737      * - `from` and `to` are never both zero.
1738      *
1739      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1740      */
1741     function _beforeTokenTransfer(
1742         address from,
1743         address to,
1744         uint256 tokenId
1745     ) internal virtual {}
1746 
1747     /**
1748      * @dev Hook that is called after any transfer of tokens. This includes
1749      * minting and burning.
1750      *
1751      * Calling conditions:
1752      *
1753      * - when `from` and `to` are both non-zero.
1754      * - `from` and `to` are never both zero.
1755      *
1756      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1757      */
1758     function _afterTokenTransfer(
1759         address from,
1760         address to,
1761         uint256 tokenId
1762     ) internal virtual {}
1763 }
1764 
1765 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1766 
1767 
1768 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
1769 
1770 pragma solidity ^0.8.0;
1771 
1772 
1773 
1774 /**
1775  * @dev ERC721 token with pausable token transfers, minting and burning.
1776  *
1777  * Useful for scenarios such as preventing trades until the end of an evaluation
1778  * period, or having an emergency switch for freezing all token transfers in the
1779  * event of a large bug.
1780  */
1781 abstract contract ERC721Pausable is ERC721, Pausable {
1782     /**
1783      * @dev See {ERC721-_beforeTokenTransfer}.
1784      *
1785      * Requirements:
1786      *
1787      * - the contract must not be paused.
1788      */
1789     function _beforeTokenTransfer(
1790         address from,
1791         address to,
1792         uint256 tokenId
1793     ) internal virtual override {
1794         super._beforeTokenTransfer(from, to, tokenId);
1795 
1796         require(!paused(), "ERC721Pausable: token transfer while paused");
1797     }
1798 }
1799 
1800 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1801 
1802 
1803 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1804 
1805 pragma solidity ^0.8.0;
1806 
1807 
1808 
1809 /**
1810  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1811  * enumerability of all the token ids in the contract as well as all token ids owned by each
1812  * account.
1813  */
1814 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1815     // Mapping from owner to list of owned token IDs
1816     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1817 
1818     // Mapping from token ID to index of the owner tokens list
1819     mapping(uint256 => uint256) private _ownedTokensIndex;
1820 
1821     // Array with all token ids, used for enumeration
1822     uint256[] private _allTokens;
1823 
1824     // Mapping from token id to position in the allTokens array
1825     mapping(uint256 => uint256) private _allTokensIndex;
1826 
1827     /**
1828      * @dev See {IERC165-supportsInterface}.
1829      */
1830     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1831         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1832     }
1833 
1834     /**
1835      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1836      */
1837     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1838         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1839         return _ownedTokens[owner][index];
1840     }
1841 
1842     /**
1843      * @dev See {IERC721Enumerable-totalSupply}.
1844      */
1845     function totalSupply() public view virtual override returns (uint256) {
1846         return _allTokens.length;
1847     }
1848 
1849     /**
1850      * @dev See {IERC721Enumerable-tokenByIndex}.
1851      */
1852     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1853         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1854         return _allTokens[index];
1855     }
1856 
1857     /**
1858      * @dev Hook that is called before any token transfer. This includes minting
1859      * and burning.
1860      *
1861      * Calling conditions:
1862      *
1863      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1864      * transferred to `to`.
1865      * - When `from` is zero, `tokenId` will be minted for `to`.
1866      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1867      * - `from` cannot be the zero address.
1868      * - `to` cannot be the zero address.
1869      *
1870      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1871      */
1872     function _beforeTokenTransfer(
1873         address from,
1874         address to,
1875         uint256 tokenId
1876     ) internal virtual override {
1877         super._beforeTokenTransfer(from, to, tokenId);
1878 
1879         if (from == address(0)) {
1880             _addTokenToAllTokensEnumeration(tokenId);
1881         } else if (from != to) {
1882             _removeTokenFromOwnerEnumeration(from, tokenId);
1883         }
1884         if (to == address(0)) {
1885             _removeTokenFromAllTokensEnumeration(tokenId);
1886         } else if (to != from) {
1887             _addTokenToOwnerEnumeration(to, tokenId);
1888         }
1889     }
1890 
1891     /**
1892      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1893      * @param to address representing the new owner of the given token ID
1894      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1895      */
1896     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1897         uint256 length = ERC721.balanceOf(to);
1898         _ownedTokens[to][length] = tokenId;
1899         _ownedTokensIndex[tokenId] = length;
1900     }
1901 
1902     /**
1903      * @dev Private function to add a token to this extension's token tracking data structures.
1904      * @param tokenId uint256 ID of the token to be added to the tokens list
1905      */
1906     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1907         _allTokensIndex[tokenId] = _allTokens.length;
1908         _allTokens.push(tokenId);
1909     }
1910 
1911     /**
1912      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1913      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1914      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1915      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1916      * @param from address representing the previous owner of the given token ID
1917      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1918      */
1919     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1920         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1921         // then delete the last slot (swap and pop).
1922 
1923         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1924         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1925 
1926         // When the token to delete is the last token, the swap operation is unnecessary
1927         if (tokenIndex != lastTokenIndex) {
1928             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1929 
1930             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1931             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1932         }
1933 
1934         // This also deletes the contents at the last position of the array
1935         delete _ownedTokensIndex[tokenId];
1936         delete _ownedTokens[from][lastTokenIndex];
1937     }
1938 
1939     /**
1940      * @dev Private function to remove a token from this extension's token tracking data structures.
1941      * This has O(1) time complexity, but alters the order of the _allTokens array.
1942      * @param tokenId uint256 ID of the token to be removed from the tokens list
1943      */
1944     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1945         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1946         // then delete the last slot (swap and pop).
1947 
1948         uint256 lastTokenIndex = _allTokens.length - 1;
1949         uint256 tokenIndex = _allTokensIndex[tokenId];
1950 
1951         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1952         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1953         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1954         uint256 lastTokenId = _allTokens[lastTokenIndex];
1955 
1956         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1957         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1958 
1959         // This also deletes the contents at the last position of the array
1960         delete _allTokensIndex[tokenId];
1961         _allTokens.pop();
1962     }
1963 }
1964 
1965 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1966 
1967 
1968 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1969 
1970 pragma solidity ^0.8.0;
1971 
1972 
1973 /**
1974  * @dev ERC721 token with storage based token URI management.
1975  */
1976 abstract contract ERC721URIStorage is ERC721 {
1977     using Strings for uint256;
1978 
1979     // Optional mapping for token URIs
1980     mapping(uint256 => string) private _tokenURIs;
1981 
1982     /**
1983      * @dev See {IERC721Metadata-tokenURI}.
1984      */
1985     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1986         _requireMinted(tokenId);
1987 
1988         string memory _tokenURI = _tokenURIs[tokenId];
1989         string memory base = _baseURI();
1990 
1991         // If there is no base URI, return the token URI.
1992         if (bytes(base).length == 0) {
1993             return _tokenURI;
1994         }
1995         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1996         if (bytes(_tokenURI).length > 0) {
1997             return string(abi.encodePacked(base, _tokenURI));
1998         }
1999 
2000         return super.tokenURI(tokenId);
2001     }
2002 
2003     /**
2004      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2005      *
2006      * Requirements:
2007      *
2008      * - `tokenId` must exist.
2009      */
2010     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2011         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
2012         _tokenURIs[tokenId] = _tokenURI;
2013     }
2014 
2015     /**
2016      * @dev See {ERC721-_burn}. This override additionally checks to see if a
2017      * token-specific URI was set for the token, and if so, it deletes the token URI from
2018      * the storage mapping.
2019      */
2020     function _burn(uint256 tokenId) internal virtual override {
2021         super._burn(tokenId);
2022 
2023         if (bytes(_tokenURIs[tokenId]).length != 0) {
2024             delete _tokenURIs[tokenId];
2025         }
2026     }
2027 }
2028 
2029 // File: contracts/GiddysNFT.sol
2030 
2031 
2032 pragma solidity >=0.4.22 <0.9.0;
2033 
2034 
2035 
2036 
2037 
2038 
2039 
2040 
2041 
2042 contract GiddyNFT is
2043   ERC721URIStorage,
2044   ERC721Pausable,
2045   ERC721Enumerable,
2046   Ownable
2047 {
2048   using SafeMath for uint256;
2049   using Strings for uint256;
2050   using Counters for Counters.Counter;
2051 
2052   Counters.Counter private _tokenIdTracker;
2053 
2054   uint256 public MAX_GIDDYS = 1500;
2055   uint256 public PRICE = 0.00 ether;
2056   uint256 public MAX_BY_MINT = 1;
2057 
2058   string public baseTokenURI;
2059   string public placeholderTokenURI;
2060 
2061   bool public revealed = false;
2062   bool public whitelistActive = true;
2063 
2064   bytes32 public root;
2065 
2066   // Optional mapping for token URIs
2067   mapping(uint256 => string) private _tokenURIs;
2068 
2069   event CreateGiddy(uint256 indexed id);
2070 
2071   constructor(
2072     string memory _nftBaseURI,
2073     string memory _nftPlaceholderURI,
2074     bytes32 _root
2075   ) ERC721("The Giddys", "TG") {
2076     baseTokenURI = _nftBaseURI;
2077     placeholderTokenURI = _nftPlaceholderURI;
2078     root = _root;
2079   }
2080 
2081   function setMAX_GIDDYS(uint256 _maxGiddys) external onlyOwner {
2082     require(
2083       _maxGiddys < 6667,
2084       "You can't set the MAX ELEMENTS to be over 6666."
2085     );
2086     MAX_GIDDYS = _maxGiddys;
2087   }
2088 
2089   function setMAX_BY_MINT(uint256 _maxByMint) external onlyOwner {
2090     require(_maxByMint > 0, "You can't set the MAX BY MINT to be 0 or less.");
2091     MAX_BY_MINT = _maxByMint;
2092   }
2093 
2094   function setWhitelistActive(bool _active) external onlyOwner {
2095     whitelistActive = _active;
2096   }
2097 
2098   function setPRICE(uint256 _price) external onlyOwner {
2099     PRICE = _price;
2100   }
2101 
2102   function _totalSupply() internal view returns (uint256) {
2103     return _tokenIdTracker.current();
2104   }
2105 
2106   function totalMint() public view returns (uint256) {
2107     return _totalSupply();
2108   }
2109 
2110   function mint(uint256 _numTokensToMint, bytes32[] memory proof)
2111     public
2112     payable
2113   {
2114     if (whitelistActive == true) {
2115       require(
2116         isValid(proof, keccak256(abi.encodePacked(msg.sender))),
2117         "Not a part of Allowlist"
2118       );
2119     }
2120 
2121     uint256 total = _totalSupply();
2122     require(total + _numTokensToMint <= MAX_GIDDYS, "Max limit");
2123     require(
2124       balanceOf(msg.sender) + _numTokensToMint <= MAX_BY_MINT,
2125       "Can't mint more than MAX_BY_MINT NFTs to this address"
2126     );
2127     require(total <= MAX_GIDDYS, "This sale has ended");
2128     require(msg.value >= price(_numTokensToMint), "Value paid is below price");
2129 
2130     for (uint256 i = 0; i < _numTokensToMint; i++) {
2131       _mintGiddy(msg.sender);
2132     }
2133   }
2134 
2135   function _mintGiddy(address _to) private {
2136     uint256 id = _totalSupply() + 1;
2137     _tokenIdTracker.increment();
2138     _safeMint(_to, id);
2139     _setTokenURI(id, string(abi.encodePacked(baseTokenURI, id, ".json")));
2140     emit CreateGiddy(id);
2141   }
2142 
2143   function price(uint256 _count) public view returns (uint256) {
2144     return PRICE.mul(_count);
2145   }
2146 
2147   function _baseURI() internal view virtual override returns (string memory) {
2148     return baseTokenURI;
2149   }
2150 
2151   function setBaseURI(string memory baseURI) public onlyOwner {
2152     baseTokenURI = baseURI;
2153   }
2154 
2155   function setPlaceholderURI(string memory _placeholderURI) public onlyOwner {
2156     placeholderTokenURI = _placeholderURI;
2157   }
2158 
2159   function pause() public onlyOwner {
2160     _pause();
2161     return;
2162   }
2163 
2164   function unpause() public onlyOwner {
2165     _unpause();
2166     return;
2167   }
2168 
2169   function getContractBalance() public view returns (uint256) {
2170     return address(this).balance;
2171   }
2172 
2173   // function withdrawAll() public payable onlyOwner {
2174   function withdrawAll() public onlyOwner {
2175     uint256 balance = address(this).balance;
2176     require(balance > 0);
2177     _withdraw(owner(), balance);
2178   }
2179 
2180   function _withdraw(address _address, uint256 _amount) private {
2181     (bool success, ) = _address.call{ value: _amount }("");
2182     require(success, "Transfer failed.");
2183   }
2184 
2185   function supportsInterface(bytes4 interfaceId)
2186     public
2187     view
2188     virtual
2189     override(ERC721, ERC721Enumerable)
2190     returns (bool)
2191   {
2192     return super.supportsInterface(interfaceId);
2193   }
2194 
2195   function reveal() public onlyOwner {
2196     revealed = true;
2197   }
2198 
2199   function _beforeTokenTransfer(
2200     address from,
2201     address to,
2202     uint256 tokenId
2203   ) internal virtual override(ERC721, ERC721Pausable, ERC721Enumerable) {
2204     super._beforeTokenTransfer(from, to, tokenId);
2205   }
2206 
2207   function _burn(uint256 tokenId)
2208     internal
2209     virtual
2210     override(ERC721, ERC721URIStorage)
2211   {
2212     require(tokenId == 0);
2213     revert("Don't burn your Giddy");
2214   }
2215 
2216   function tokenURI(uint256 tokenId)
2217     public
2218     view
2219     virtual
2220     override(ERC721, ERC721URIStorage)
2221     returns (string memory)
2222   {
2223     require(
2224       _exists(tokenId),
2225       "ERC721URIStorage: URI query for nonexistent token"
2226     );
2227     string memory baseURIToUse;
2228     if (revealed == false) {
2229       baseURIToUse = placeholderTokenURI;
2230     } else {
2231       baseURIToUse = baseTokenURI;
2232     }
2233     return
2234       bytes(baseURIToUse).length > 0
2235         ? string(abi.encodePacked(baseURIToUse, tokenId.toString()))
2236         : "";
2237   }
2238 
2239   function isValid(bytes32[] memory proof, bytes32 leaf)
2240     public
2241     view
2242     returns (bool)
2243   {
2244     return MerkleProof.verify(proof, root, leaf);
2245   }
2246 }