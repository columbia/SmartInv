1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Contract module that helps prevent reentrant calls to a function.
240  *
241  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
242  * available, which can be applied to functions to make sure there are no nested
243  * (reentrant) calls to them.
244  *
245  * Note that because there is a single `nonReentrant` guard, functions marked as
246  * `nonReentrant` may not call one another. This can be worked around by making
247  * those functions `private`, and then adding `external` `nonReentrant` entry
248  * points to them.
249  *
250  * TIP: If you would like to learn more about reentrancy and alternative ways
251  * to protect against it, check out our blog post
252  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
253  */
254 abstract contract ReentrancyGuard {
255     // Booleans are more expensive than uint256 or any type that takes up a full
256     // word because each write operation emits an extra SLOAD to first read the
257     // slot's contents, replace the bits taken up by the boolean, and then write
258     // back. This is the compiler's defense against contract upgrades and
259     // pointer aliasing, and it cannot be disabled.
260 
261     // The values being non-zero value makes deployment a bit more expensive,
262     // but in exchange the refund on every call to nonReentrant will be lower in
263     // amount. Since refunds are capped to a percentage of the total
264     // transaction's gas, it is best to keep them low in cases like this one, to
265     // increase the likelihood of the full refund coming into effect.
266     uint256 private constant _NOT_ENTERED = 1;
267     uint256 private constant _ENTERED = 2;
268 
269     uint256 private _status;
270 
271     constructor() {
272         _status = _NOT_ENTERED;
273     }
274 
275     /**
276      * @dev Prevents a contract from calling itself, directly or indirectly.
277      * Calling a `nonReentrant` function from another `nonReentrant`
278      * function is not supported. It is possible to prevent this from happening
279      * by making the `nonReentrant` function external, and making it call a
280      * `private` function that does the actual work.
281      */
282     modifier nonReentrant() {
283         // On the first call to nonReentrant, _notEntered will be true
284         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
285 
286         // Any calls to nonReentrant after this point will fail
287         _status = _ENTERED;
288 
289         _;
290 
291         // By storing the original value once again, a refund is triggered (see
292         // https://eips.ethereum.org/EIPS/eip-2200)
293         _status = _NOT_ENTERED;
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Strings.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev String operations.
306  */
307 library Strings {
308     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
309     uint8 private constant _ADDRESS_LENGTH = 20;
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
313      */
314     function toString(uint256 value) internal pure returns (string memory) {
315         // Inspired by OraclizeAPI's implementation - MIT licence
316         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
317 
318         if (value == 0) {
319             return "0";
320         }
321         uint256 temp = value;
322         uint256 digits;
323         while (temp != 0) {
324             digits++;
325             temp /= 10;
326         }
327         bytes memory buffer = new bytes(digits);
328         while (value != 0) {
329             digits -= 1;
330             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
331             value /= 10;
332         }
333         return string(buffer);
334     }
335 
336     /**
337      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
338      */
339     function toHexString(uint256 value) internal pure returns (string memory) {
340         if (value == 0) {
341             return "0x00";
342         }
343         uint256 temp = value;
344         uint256 length = 0;
345         while (temp != 0) {
346             length++;
347             temp >>= 8;
348         }
349         return toHexString(value, length);
350     }
351 
352     /**
353      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
354      */
355     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
356         bytes memory buffer = new bytes(2 * length + 2);
357         buffer[0] = "0";
358         buffer[1] = "x";
359         for (uint256 i = 2 * length + 1; i > 1; --i) {
360             buffer[i] = _HEX_SYMBOLS[value & 0xf];
361             value >>= 4;
362         }
363         require(value == 0, "Strings: hex length insufficient");
364         return string(buffer);
365     }
366 
367     /**
368      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
369      */
370     function toHexString(address addr) internal pure returns (string memory) {
371         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
372     }
373 }
374 
375 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
376 
377 
378 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev These functions deal with verification of Merkle Tree proofs.
384  *
385  * The proofs can be generated using the JavaScript library
386  * https://github.com/miguelmota/merkletreejs[merkletreejs].
387  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
388  *
389  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
390  *
391  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
392  * hashing, or use a hash function other than keccak256 for hashing leaves.
393  * This is because the concatenation of a sorted pair of internal nodes in
394  * the merkle tree could be reinterpreted as a leaf value.
395  */
396 library MerkleProof {
397     /**
398      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
399      * defined by `root`. For this, a `proof` must be provided, containing
400      * sibling hashes on the branch from the leaf to the root of the tree. Each
401      * pair of leaves and each pair of pre-images are assumed to be sorted.
402      */
403     function verify(
404         bytes32[] memory proof,
405         bytes32 root,
406         bytes32 leaf
407     ) internal pure returns (bool) {
408         return processProof(proof, leaf) == root;
409     }
410 
411     /**
412      * @dev Calldata version of {verify}
413      *
414      * _Available since v4.7._
415      */
416     function verifyCalldata(
417         bytes32[] calldata proof,
418         bytes32 root,
419         bytes32 leaf
420     ) internal pure returns (bool) {
421         return processProofCalldata(proof, leaf) == root;
422     }
423 
424     /**
425      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
426      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
427      * hash matches the root of the tree. When processing the proof, the pairs
428      * of leafs & pre-images are assumed to be sorted.
429      *
430      * _Available since v4.4._
431      */
432     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
433         bytes32 computedHash = leaf;
434         for (uint256 i = 0; i < proof.length; i++) {
435             computedHash = _hashPair(computedHash, proof[i]);
436         }
437         return computedHash;
438     }
439 
440     /**
441      * @dev Calldata version of {processProof}
442      *
443      * _Available since v4.7._
444      */
445     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
446         bytes32 computedHash = leaf;
447         for (uint256 i = 0; i < proof.length; i++) {
448             computedHash = _hashPair(computedHash, proof[i]);
449         }
450         return computedHash;
451     }
452 
453     /**
454      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
455      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
456      *
457      * _Available since v4.7._
458      */
459     function multiProofVerify(
460         bytes32[] memory proof,
461         bool[] memory proofFlags,
462         bytes32 root,
463         bytes32[] memory leaves
464     ) internal pure returns (bool) {
465         return processMultiProof(proof, proofFlags, leaves) == root;
466     }
467 
468     /**
469      * @dev Calldata version of {multiProofVerify}
470      *
471      * _Available since v4.7._
472      */
473     function multiProofVerifyCalldata(
474         bytes32[] calldata proof,
475         bool[] calldata proofFlags,
476         bytes32 root,
477         bytes32[] memory leaves
478     ) internal pure returns (bool) {
479         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
480     }
481 
482     /**
483      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
484      * consuming from one or the other at each step according to the instructions given by
485      * `proofFlags`.
486      *
487      * _Available since v4.7._
488      */
489     function processMultiProof(
490         bytes32[] memory proof,
491         bool[] memory proofFlags,
492         bytes32[] memory leaves
493     ) internal pure returns (bytes32 merkleRoot) {
494         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
495         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
496         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
497         // the merkle tree.
498         uint256 leavesLen = leaves.length;
499         uint256 totalHashes = proofFlags.length;
500 
501         // Check proof validity.
502         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
503 
504         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
505         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
506         bytes32[] memory hashes = new bytes32[](totalHashes);
507         uint256 leafPos = 0;
508         uint256 hashPos = 0;
509         uint256 proofPos = 0;
510         // At each step, we compute the next hash using two values:
511         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
512         //   get the next hash.
513         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
514         //   `proof` array.
515         for (uint256 i = 0; i < totalHashes; i++) {
516             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
517             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
518             hashes[i] = _hashPair(a, b);
519         }
520 
521         if (totalHashes > 0) {
522             return hashes[totalHashes - 1];
523         } else if (leavesLen > 0) {
524             return leaves[0];
525         } else {
526             return proof[0];
527         }
528     }
529 
530     /**
531      * @dev Calldata version of {processMultiProof}
532      *
533      * _Available since v4.7._
534      */
535     function processMultiProofCalldata(
536         bytes32[] calldata proof,
537         bool[] calldata proofFlags,
538         bytes32[] memory leaves
539     ) internal pure returns (bytes32 merkleRoot) {
540         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
541         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
542         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
543         // the merkle tree.
544         uint256 leavesLen = leaves.length;
545         uint256 totalHashes = proofFlags.length;
546 
547         // Check proof validity.
548         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
549 
550         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
551         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
552         bytes32[] memory hashes = new bytes32[](totalHashes);
553         uint256 leafPos = 0;
554         uint256 hashPos = 0;
555         uint256 proofPos = 0;
556         // At each step, we compute the next hash using two values:
557         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
558         //   get the next hash.
559         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
560         //   `proof` array.
561         for (uint256 i = 0; i < totalHashes; i++) {
562             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
563             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
564             hashes[i] = _hashPair(a, b);
565         }
566 
567         if (totalHashes > 0) {
568             return hashes[totalHashes - 1];
569         } else if (leavesLen > 0) {
570             return leaves[0];
571         } else {
572             return proof[0];
573         }
574     }
575 
576     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
577         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
578     }
579 
580     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
581         /// @solidity memory-safe-assembly
582         assembly {
583             mstore(0x00, a)
584             mstore(0x20, b)
585             value := keccak256(0x00, 0x40)
586         }
587     }
588 }
589 // File: IERC721A.sol
590 
591 
592 // ERC721A Contracts v4.2.2
593 // Creator: Chiru Labs
594 
595 pragma solidity ^0.8.4;
596 
597 /**
598  * @dev Interface of ERC721A.
599  */
600 interface IERC721A {
601     /**
602      * The caller must own the token or be an approved operator.
603      */
604     error ApprovalCallerNotOwnerNorApproved();
605 
606     /**
607      * The token does not exist.
608      */
609     error ApprovalQueryForNonexistentToken();
610 
611     /**
612      * The caller cannot approve to their own address.
613      */
614     error ApproveToCaller();
615 
616     /**
617      * Cannot query the balance for the zero address.
618      */
619     error BalanceQueryForZeroAddress();
620 
621     /**
622      * Cannot mint to the zero address.
623      */
624     error MintToZeroAddress();
625 
626     /**
627      * The quantity of tokens minted must be more than zero.
628      */
629     error MintZeroQuantity();
630 
631     /**
632      * The token does not exist.
633      */
634     error OwnerQueryForNonexistentToken();
635 
636     /**
637      * The caller must own the token or be an approved operator.
638      */
639     error TransferCallerNotOwnerNorApproved();
640 
641     /**
642      * The token must be owned by `from`.
643      */
644     error TransferFromIncorrectOwner();
645 
646     /**
647      * Cannot safely transfer to a contract that does not implement the
648      * ERC721Receiver interface.
649      */
650     error TransferToNonERC721ReceiverImplementer();
651 
652     /**
653      * Cannot transfer to the zero address.
654      */
655     error TransferToZeroAddress();
656 
657     /**
658      * The token does not exist.
659      */
660     error URIQueryForNonexistentToken();
661 
662     /**
663      * The `quantity` minted with ERC2309 exceeds the safety limit.
664      */
665     error MintERC2309QuantityExceedsLimit();
666 
667     /**
668      * The `extraData` cannot be set on an unintialized ownership slot.
669      */
670     error OwnershipNotInitializedForExtraData();
671 
672     // =============================================================
673     //                            STRUCTS
674     // =============================================================
675 
676     struct TokenOwnership {
677         // The address of the owner.
678         address addr;
679         // Stores the start time of ownership with minimal overhead for tokenomics.
680         uint64 startTimestamp;
681         // Whether the token has been burned.
682         bool burned;
683         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
684         uint24 extraData;
685     }
686 
687     // =============================================================
688     //                         TOKEN COUNTERS
689     // =============================================================
690 
691     /**
692      * @dev Returns the total number of tokens in existence.
693      * Burned tokens will reduce the count.
694      * To get the total number of tokens minted, please see {_totalMinted}.
695      */
696     function totalSupply() external view returns (uint256);
697 
698     // =============================================================
699     //                            IERC165
700     // =============================================================
701 
702     /**
703      * @dev Returns true if this contract implements the interface defined by
704      * `interfaceId`. See the corresponding
705      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
706      * to learn more about how these ids are created.
707      *
708      * This function call must use less than 30000 gas.
709      */
710     function supportsInterface(bytes4 interfaceId) external view returns (bool);
711 
712     // =============================================================
713     //                            IERC721
714     // =============================================================
715 
716     /**
717      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
718      */
719     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
720 
721     /**
722      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
723      */
724     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
725 
726     /**
727      * @dev Emitted when `owner` enables or disables
728      * (`approved`) `operator` to manage all of its assets.
729      */
730     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
731 
732     /**
733      * @dev Returns the number of tokens in `owner`'s account.
734      */
735     function balanceOf(address owner) external view returns (uint256 balance);
736 
737     /**
738      * @dev Returns the owner of the `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function ownerOf(uint256 tokenId) external view returns (address owner);
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`,
748      * checking first that contract recipients are aware of the ERC721 protocol
749      * to prevent tokens from being forever locked.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must exist and be owned by `from`.
756      * - If the caller is not `from`, it must be have been allowed to move
757      * this token by either {approve} or {setApprovalForAll}.
758      * - If `to` refers to a smart contract, it must implement
759      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes calldata data
768     ) external;
769 
770     /**
771      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) external;
778 
779     /**
780      * @dev Transfers `tokenId` from `from` to `to`.
781      *
782      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
783      * whenever possible.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must be owned by `from`.
790      * - If the caller is not `from`, it must be approved to move this token
791      * by either {approve} or {setApprovalForAll}.
792      *
793      * Emits a {Transfer} event.
794      */
795     function transferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
803      * The approval is cleared when the token is transferred.
804      *
805      * Only a single account can be approved at a time, so approving the
806      * zero address clears previous approvals.
807      *
808      * Requirements:
809      *
810      * - The caller must own the token or be an approved operator.
811      * - `tokenId` must exist.
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address to, uint256 tokenId) external;
816 
817     /**
818      * @dev Approve or remove `operator` as an operator for the caller.
819      * Operators can call {transferFrom} or {safeTransferFrom}
820      * for any token owned by the caller.
821      *
822      * Requirements:
823      *
824      * - The `operator` cannot be the caller.
825      *
826      * Emits an {ApprovalForAll} event.
827      */
828     function setApprovalForAll(address operator, bool _approved) external;
829 
830     /**
831      * @dev Returns the account approved for `tokenId` token.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function getApproved(uint256 tokenId) external view returns (address operator);
838 
839     /**
840      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
841      *
842      * See {setApprovalForAll}.
843      */
844     function isApprovedForAll(address owner, address operator) external view returns (bool);
845 
846     // =============================================================
847     //                        IERC721Metadata
848     // =============================================================
849 
850     /**
851      * @dev Returns the token collection name.
852      */
853     function name() external view returns (string memory);
854 
855     /**
856      * @dev Returns the token collection symbol.
857      */
858     function symbol() external view returns (string memory);
859 
860     /**
861      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
862      */
863     function tokenURI(uint256 tokenId) external view returns (string memory);
864 
865     // =============================================================
866     //                           IERC2309
867     // =============================================================
868 
869     /**
870      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
871      * (inclusive) is transferred from `from` to `to`, as defined in the
872      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
873      *
874      * See {_mintERC2309} for more details.
875      */
876     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
877 }
878 // File: @openzeppelin/contracts/utils/Context.sol
879 
880 
881 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 /**
886  * @dev Provides information about the current execution context, including the
887  * sender of the transaction and its data. While these are generally available
888  * via msg.sender and msg.data, they should not be accessed in such a direct
889  * manner, since when dealing with meta-transactions the account sending and
890  * paying for execution may not be the actual sender (as far as an application
891  * is concerned).
892  *
893  * This contract is only required for intermediate, library-like contracts.
894  */
895 abstract contract Context {
896     function _msgSender() internal view virtual returns (address) {
897         return msg.sender;
898     }
899 
900     function _msgData() internal view virtual returns (bytes calldata) {
901         return msg.data;
902     }
903 }
904 
905 // File: ERC721A.sol
906 
907 
908 // ERC721A Contracts v4.2.2
909 // Creator: Chiru Labs
910 
911 pragma solidity ^0.8.4;
912 
913 
914 
915 /**
916  * @dev Interface of ERC721 token receiver.
917  */
918 interface ERC721A__IERC721Receiver {
919     function onERC721Received(
920         address operator,
921         address from,
922         uint256 tokenId,
923         bytes calldata data
924     ) external returns (bytes4);
925 }
926 
927 /**
928  * @title ERC721A
929  *
930  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
931  * Non-Fungible Token Standard, including the Metadata extension.
932  * Optimized for lower gas during batch mints.
933  *
934  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
935  * starting from `_startTokenId()`.
936  *
937  * Assumptions:
938  *
939  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
940  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
941  */
942 contract ERC721A is IERC721A {
943     // Reference type for token approval.
944     struct TokenApprovalRef {
945         address value;
946     }
947 
948     // =============================================================
949     //                           CONSTANTS
950     // =============================================================
951 
952     // Mask of an entry in packed address data.
953     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
954 
955     // The bit position of `numberMinted` in packed address data.
956     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
957 
958     // The bit position of `numberBurned` in packed address data.
959     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
960 
961     // The bit position of `aux` in packed address data.
962     uint256 private constant _BITPOS_AUX = 192;
963 
964     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
965     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
966 
967     // The bit position of `startTimestamp` in packed ownership.
968     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
969 
970     // The bit mask of the `burned` bit in packed ownership.
971     uint256 private constant _BITMASK_BURNED = 1 << 224;
972 
973     // The bit position of the `nextInitialized` bit in packed ownership.
974     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
975 
976     // The bit mask of the `nextInitialized` bit in packed ownership.
977     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
978 
979     // The bit position of `extraData` in packed ownership.
980     uint256 private constant _BITPOS_EXTRA_DATA = 232;
981 
982     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
983     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
984 
985     // The mask of the lower 160 bits for addresses.
986     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
987 
988     // The maximum `quantity` that can be minted with {_mintERC2309}.
989     // This limit is to prevent overflows on the address data entries.
990     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
991     // is required to cause an overflow, which is unrealistic.
992     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
993 
994     // The `Transfer` event signature is given by:
995     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
996     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
997         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
998 
999     // =============================================================
1000     //                            STORAGE
1001     // =============================================================
1002 
1003     // The next token ID to be minted.
1004     uint256 private _currentIndex;
1005 
1006     // The number of tokens burned.
1007     uint256 private _burnCounter;
1008 
1009     // Token name
1010     string private _name;
1011 
1012     // Token symbol
1013     string private _symbol;
1014 
1015     // Mapping from token ID to ownership details
1016     // An empty struct value does not necessarily mean the token is unowned.
1017     // See {_packedOwnershipOf} implementation for details.
1018     //
1019     // Bits Layout:
1020     // - [0..159]   `addr`
1021     // - [160..223] `startTimestamp`
1022     // - [224]      `burned`
1023     // - [225]      `nextInitialized`
1024     // - [232..255] `extraData`
1025     mapping(uint256 => uint256) private _packedOwnerships;
1026 
1027     // Mapping owner address to address data.
1028     //
1029     // Bits Layout:
1030     // - [0..63]    `balance`
1031     // - [64..127]  `numberMinted`
1032     // - [128..191] `numberBurned`
1033     // - [192..255] `aux`
1034     mapping(address => uint256) private _packedAddressData;
1035 
1036     // Mapping from token ID to approved address.
1037     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1038 
1039     // Mapping from owner to operator approvals
1040     mapping(address => mapping(address => bool)) private _operatorApprovals;
1041 
1042     // =============================================================
1043     //                          CONSTRUCTOR
1044     // =============================================================
1045 
1046     constructor(string memory name_, string memory symbol_) {
1047         _name = name_;
1048         _symbol = symbol_;
1049         _currentIndex = _startTokenId();
1050     }
1051 
1052     // =============================================================
1053     //                   TOKEN COUNTING OPERATIONS
1054     // =============================================================
1055 
1056     /**
1057      * @dev Returns the starting token ID.
1058      * To change the starting token ID, please override this function.
1059      */
1060     function _startTokenId() internal view virtual returns (uint256) {
1061         return 1;
1062     }
1063 
1064     /**
1065      * @dev Returns the next token ID to be minted.
1066      */
1067     function _nextTokenId() internal view virtual returns (uint256) {
1068         return _currentIndex;
1069     }
1070 
1071     /**
1072      * @dev Returns the total number of tokens in existence.
1073      * Burned tokens will reduce the count.
1074      * To get the total number of tokens minted, please see {_totalMinted}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         // Counter underflow is impossible as _burnCounter cannot be incremented
1078         // more than `_currentIndex - _startTokenId()` times.
1079         unchecked {
1080             return _currentIndex - _burnCounter - _startTokenId();
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the total amount of tokens minted in the contract.
1086      */
1087     function _totalMinted() internal view virtual returns (uint256) {
1088         // Counter underflow is impossible as `_currentIndex` does not decrement,
1089         // and it is initialized to `_startTokenId()`.
1090         unchecked {
1091             return _currentIndex - _startTokenId();
1092         }
1093     }
1094 
1095     /**
1096      * @dev Returns the total number of tokens burned.
1097      */
1098     function _totalBurned() internal view virtual returns (uint256) {
1099         return _burnCounter;
1100     }
1101 
1102     // =============================================================
1103     //                    ADDRESS DATA OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Returns the number of tokens in `owner`'s account.
1108      */
1109     function balanceOf(address owner) public view virtual override returns (uint256) {
1110         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1111         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1112     }
1113 
1114     /**
1115      * Returns the number of tokens minted by `owner`.
1116      */
1117     function _numberMinted(address owner) internal view returns (uint256) {
1118         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1119     }
1120 
1121     /**
1122      * Returns the number of tokens burned by or on behalf of `owner`.
1123      */
1124     function _numberBurned(address owner) internal view returns (uint256) {
1125         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1126     }
1127 
1128     /**
1129      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1130      */
1131     function _getAux(address owner) internal view returns (uint64) {
1132         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1133     }
1134 
1135     /**
1136      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1137      * If there are multiple variables, please pack them into a uint64.
1138      */
1139     function _setAux(address owner, uint64 aux) internal virtual {
1140         uint256 packed = _packedAddressData[owner];
1141         uint256 auxCasted;
1142         // Cast `aux` with assembly to avoid redundant masking.
1143         assembly {
1144             auxCasted := aux
1145         }
1146         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1147         _packedAddressData[owner] = packed;
1148     }
1149 
1150     // =============================================================
1151     //                            IERC165
1152     // =============================================================
1153 
1154     /**
1155      * @dev Returns true if this contract implements the interface defined by
1156      * `interfaceId`. See the corresponding
1157      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1158      * to learn more about how these ids are created.
1159      *
1160      * This function call must use less than 30000 gas.
1161      */
1162     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1163         // The interface IDs are constants representing the first 4 bytes
1164         // of the XOR of all function selectors in the interface.
1165         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1166         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1167         return
1168             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1169             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1170             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1171     }
1172 
1173     // =============================================================
1174     //                        IERC721Metadata
1175     // =============================================================
1176 
1177     /**
1178      * @dev Returns the token collection name.
1179      */
1180     function name() public view virtual override returns (string memory) {
1181         return _name;
1182     }
1183 
1184     /**
1185      * @dev Returns the token collection symbol.
1186      */
1187     function symbol() public view virtual override returns (string memory) {
1188         return _symbol;
1189     }
1190 
1191     /**
1192      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1193      */
1194     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1195         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1196 
1197         string memory baseURI = _baseURI();
1198         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), '.json')) : '';
1199     }
1200 
1201     /**
1202      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1203      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1204      * by default, it can be overridden in child contracts.
1205      */
1206     function _baseURI() internal view virtual returns (string memory) {
1207         return '';
1208     }
1209 
1210     // =============================================================
1211     //                     OWNERSHIPS OPERATIONS
1212     // =============================================================
1213 
1214     /**
1215      * @dev Returns the owner of the `tokenId` token.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      */
1221     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1222         return address(uint160(_packedOwnershipOf(tokenId)));
1223     }
1224 
1225     /**
1226      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1227      * It gradually moves to O(1) as tokens get transferred around over time.
1228      */
1229     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1230         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1231     }
1232 
1233     /**
1234      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1235      */
1236     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1237         return _unpackedOwnership(_packedOwnerships[index]);
1238     }
1239 
1240     /**
1241      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1242      */
1243     function _initializeOwnershipAt(uint256 index) internal virtual {
1244         if (_packedOwnerships[index] == 0) {
1245             _packedOwnerships[index] = _packedOwnershipOf(index);
1246         }
1247     }
1248 
1249     /**
1250      * Returns the packed ownership data of `tokenId`.
1251      */
1252     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1253         uint256 curr = tokenId;
1254 
1255         unchecked {
1256             if (_startTokenId() <= curr)
1257                 if (curr < _currentIndex) {
1258                     uint256 packed = _packedOwnerships[curr];
1259                     // If not burned.
1260                     if (packed & _BITMASK_BURNED == 0) {
1261                         // Invariant:
1262                         // There will always be an initialized ownership slot
1263                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1264                         // before an unintialized ownership slot
1265                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1266                         // Hence, `curr` will not underflow.
1267                         //
1268                         // We can directly compare the packed value.
1269                         // If the address is zero, packed will be zero.
1270                         while (packed == 0) {
1271                             packed = _packedOwnerships[--curr];
1272                         }
1273                         return packed;
1274                     }
1275                 }
1276         }
1277         revert OwnerQueryForNonexistentToken();
1278     }
1279 
1280     /**
1281      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1282      */
1283     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1284         ownership.addr = address(uint160(packed));
1285         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1286         ownership.burned = packed & _BITMASK_BURNED != 0;
1287         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1288     }
1289 
1290     /**
1291      * @dev Packs ownership data into a single uint256.
1292      */
1293     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1294         assembly {
1295             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1296             owner := and(owner, _BITMASK_ADDRESS)
1297             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1298             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1299         }
1300     }
1301 
1302     /**
1303      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1304      */
1305     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1306         // For branchless setting of the `nextInitialized` flag.
1307         assembly {
1308             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1309             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1310         }
1311     }
1312 
1313     // =============================================================
1314     //                      APPROVAL OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1319      * The approval is cleared when the token is transferred.
1320      *
1321      * Only a single account can be approved at a time, so approving the
1322      * zero address clears previous approvals.
1323      *
1324      * Requirements:
1325      *
1326      * - The caller must own the token or be an approved operator.
1327      * - `tokenId` must exist.
1328      *
1329      * Emits an {Approval} event.
1330      */
1331     function approve(address to, uint256 tokenId) public virtual override {
1332         address owner = ownerOf(tokenId);
1333 
1334         if (_msgSenderERC721A() != owner)
1335             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1336                 revert ApprovalCallerNotOwnerNorApproved();
1337             }
1338 
1339         _tokenApprovals[tokenId].value = to;
1340         emit Approval(owner, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Returns the account approved for `tokenId` token.
1345      *
1346      * Requirements:
1347      *
1348      * - `tokenId` must exist.
1349      */
1350     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1351         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1352 
1353         return _tokenApprovals[tokenId].value;
1354     }
1355 
1356     /**
1357      * @dev Approve or remove `operator` as an operator for the caller.
1358      * Operators can call {transferFrom} or {safeTransferFrom}
1359      * for any token owned by the caller.
1360      *
1361      * Requirements:
1362      *
1363      * - The `operator` cannot be the caller.
1364      *
1365      * Emits an {ApprovalForAll} event.
1366      */
1367     function setApprovalForAll(address operator, bool approved) public virtual override {
1368         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1369 
1370         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1371         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1372     }
1373 
1374     /**
1375      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1376      *
1377      * See {setApprovalForAll}.
1378      */
1379     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1380         return _operatorApprovals[owner][operator];
1381     }
1382 
1383     /**
1384      * @dev Returns whether `tokenId` exists.
1385      *
1386      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1387      *
1388      * Tokens start existing when they are minted. See {_mint}.
1389      */
1390     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1391         return
1392             _startTokenId() <= tokenId &&
1393             tokenId < _currentIndex && // If within bounds,
1394             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1395     }
1396 
1397     /**
1398      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1399      */
1400     function _isSenderApprovedOrOwner(
1401         address approvedAddress,
1402         address owner,
1403         address msgSender
1404     ) private pure returns (bool result) {
1405         assembly {
1406             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1407             owner := and(owner, _BITMASK_ADDRESS)
1408             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1409             msgSender := and(msgSender, _BITMASK_ADDRESS)
1410             // `msgSender == owner || msgSender == approvedAddress`.
1411             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1412         }
1413     }
1414 
1415     /**
1416      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1417      */
1418     function _getApprovedSlotAndAddress(uint256 tokenId)
1419         private
1420         view
1421         returns (uint256 approvedAddressSlot, address approvedAddress)
1422     {
1423         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1424         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1425         assembly {
1426             approvedAddressSlot := tokenApproval.slot
1427             approvedAddress := sload(approvedAddressSlot)
1428         }
1429     }
1430 
1431     // =============================================================
1432     //                      TRANSFER OPERATIONS
1433     // =============================================================
1434 
1435     /**
1436      * @dev Transfers `tokenId` from `from` to `to`.
1437      *
1438      * Requirements:
1439      *
1440      * - `from` cannot be the zero address.
1441      * - `to` cannot be the zero address.
1442      * - `tokenId` token must be owned by `from`.
1443      * - If the caller is not `from`, it must be approved to move this token
1444      * by either {approve} or {setApprovalForAll}.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function transferFrom(
1449         address from,
1450         address to,
1451         uint256 tokenId
1452     ) public virtual override {
1453         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1454 
1455         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1456 
1457         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1458 
1459         // The nested ifs save around 20+ gas over a compound boolean condition.
1460         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1461             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1462 
1463         if (to == address(0)) revert TransferToZeroAddress();
1464 
1465         _beforeTokenTransfers(from, to, tokenId, 1);
1466 
1467         // Clear approvals from the previous owner.
1468         assembly {
1469             if approvedAddress {
1470                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1471                 sstore(approvedAddressSlot, 0)
1472             }
1473         }
1474 
1475         // Underflow of the sender's balance is impossible because we check for
1476         // ownership above and the recipient's balance can't realistically overflow.
1477         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1478         unchecked {
1479             // We can directly increment and decrement the balances.
1480             --_packedAddressData[from]; // Updates: `balance -= 1`.
1481             ++_packedAddressData[to]; // Updates: `balance += 1`.
1482 
1483             // Updates:
1484             // - `address` to the next owner.
1485             // - `startTimestamp` to the timestamp of transfering.
1486             // - `burned` to `false`.
1487             // - `nextInitialized` to `true`.
1488             _packedOwnerships[tokenId] = _packOwnershipData(
1489                 to,
1490                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1491             );
1492 
1493             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1494             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1495                 uint256 nextTokenId = tokenId + 1;
1496                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1497                 if (_packedOwnerships[nextTokenId] == 0) {
1498                     // If the next slot is within bounds.
1499                     if (nextTokenId != _currentIndex) {
1500                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1501                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1502                     }
1503                 }
1504             }
1505         }
1506 
1507         emit Transfer(from, to, tokenId);
1508         _afterTokenTransfers(from, to, tokenId, 1);
1509     }
1510 
1511     /**
1512      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1513      */
1514     function safeTransferFrom(
1515         address from,
1516         address to,
1517         uint256 tokenId
1518     ) public virtual override {
1519         safeTransferFrom(from, to, tokenId, '');
1520     }
1521 
1522     /**
1523      * @dev Safely transfers `tokenId` token from `from` to `to`.
1524      *
1525      * Requirements:
1526      *
1527      * - `from` cannot be the zero address.
1528      * - `to` cannot be the zero address.
1529      * - `tokenId` token must exist and be owned by `from`.
1530      * - If the caller is not `from`, it must be approved to move this token
1531      * by either {approve} or {setApprovalForAll}.
1532      * - If `to` refers to a smart contract, it must implement
1533      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1534      *
1535      * Emits a {Transfer} event.
1536      */
1537     function safeTransferFrom(
1538         address from,
1539         address to,
1540         uint256 tokenId,
1541         bytes memory _data
1542     ) public virtual override {
1543         transferFrom(from, to, tokenId);
1544         if (to.code.length != 0)
1545             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1546                 revert TransferToNonERC721ReceiverImplementer();
1547             }
1548     }
1549 
1550     /**
1551      * @dev Hook that is called before a set of serially-ordered token IDs
1552      * are about to be transferred. This includes minting.
1553      * And also called before burning one token.
1554      *
1555      * `startTokenId` - the first token ID to be transferred.
1556      * `quantity` - the amount to be transferred.
1557      *
1558      * Calling conditions:
1559      *
1560      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1561      * transferred to `to`.
1562      * - When `from` is zero, `tokenId` will be minted for `to`.
1563      * - When `to` is zero, `tokenId` will be burned by `from`.
1564      * - `from` and `to` are never both zero.
1565      */
1566     function _beforeTokenTransfers(
1567         address from,
1568         address to,
1569         uint256 startTokenId,
1570         uint256 quantity
1571     ) internal virtual {}
1572 
1573     /**
1574      * @dev Hook that is called after a set of serially-ordered token IDs
1575      * have been transferred. This includes minting.
1576      * And also called after one token has been burned.
1577      *
1578      * `startTokenId` - the first token ID to be transferred.
1579      * `quantity` - the amount to be transferred.
1580      *
1581      * Calling conditions:
1582      *
1583      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1584      * transferred to `to`.
1585      * - When `from` is zero, `tokenId` has been minted for `to`.
1586      * - When `to` is zero, `tokenId` has been burned by `from`.
1587      * - `from` and `to` are never both zero.
1588      */
1589     function _afterTokenTransfers(
1590         address from,
1591         address to,
1592         uint256 startTokenId,
1593         uint256 quantity
1594     ) internal virtual {}
1595 
1596     /**
1597      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1598      *
1599      * `from` - Previous owner of the given token ID.
1600      * `to` - Target address that will receive the token.
1601      * `tokenId` - Token ID to be transferred.
1602      * `_data` - Optional data to send along with the call.
1603      *
1604      * Returns whether the call correctly returned the expected magic value.
1605      */
1606     function _checkContractOnERC721Received(
1607         address from,
1608         address to,
1609         uint256 tokenId,
1610         bytes memory _data
1611     ) private returns (bool) {
1612         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1613             bytes4 retval
1614         ) {
1615             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1616         } catch (bytes memory reason) {
1617             if (reason.length == 0) {
1618                 revert TransferToNonERC721ReceiverImplementer();
1619             } else {
1620                 assembly {
1621                     revert(add(32, reason), mload(reason))
1622                 }
1623             }
1624         }
1625     }
1626 
1627     // =============================================================
1628     //                        MINT OPERATIONS
1629     // =============================================================
1630 
1631     /**
1632      * @dev Mints `quantity` tokens and transfers them to `to`.
1633      *
1634      * Requirements:
1635      *
1636      * - `to` cannot be the zero address.
1637      * - `quantity` must be greater than 0.
1638      *
1639      * Emits a {Transfer} event for each mint.
1640      */
1641     function _mint(address to, uint256 quantity) internal virtual {
1642         uint256 startTokenId = _currentIndex;
1643         if (quantity == 0) revert MintZeroQuantity();
1644 
1645         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1646 
1647         // Overflows are incredibly unrealistic.
1648         // `balance` and `numberMinted` have a maximum limit of 2**64.
1649         // `tokenId` has a maximum limit of 2**256.
1650         unchecked {
1651             // Updates:
1652             // - `balance += quantity`.
1653             // - `numberMinted += quantity`.
1654             //
1655             // We can directly add to the `balance` and `numberMinted`.
1656             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1657 
1658             // Updates:
1659             // - `address` to the owner.
1660             // - `startTimestamp` to the timestamp of minting.
1661             // - `burned` to `false`.
1662             // - `nextInitialized` to `quantity == 1`.
1663             _packedOwnerships[startTokenId] = _packOwnershipData(
1664                 to,
1665                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1666             );
1667 
1668             uint256 toMasked;
1669             uint256 end = startTokenId + quantity;
1670 
1671             // Use assembly to loop and emit the `Transfer` event for gas savings.
1672             assembly {
1673                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1674                 toMasked := and(to, _BITMASK_ADDRESS)
1675                 // Emit the `Transfer` event.
1676                 log4(
1677                     0, // Start of data (0, since no data).
1678                     0, // End of data (0, since no data).
1679                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1680                     0, // `address(0)`.
1681                     toMasked, // `to`.
1682                     startTokenId // `tokenId`.
1683                 )
1684 
1685                 for {
1686                     let tokenId := add(startTokenId, 1)
1687                 } iszero(eq(tokenId, end)) {
1688                     tokenId := add(tokenId, 1)
1689                 } {
1690                     // Emit the `Transfer` event. Similar to above.
1691                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1692                 }
1693             }
1694             if (toMasked == 0) revert MintToZeroAddress();
1695 
1696             _currentIndex = end;
1697         }
1698         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1699     }
1700 
1701     /**
1702      * @dev Mints `quantity` tokens and transfers them to `to`.
1703      *
1704      * This function is intended for efficient minting only during contract creation.
1705      *
1706      * It emits only one {ConsecutiveTransfer} as defined in
1707      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1708      * instead of a sequence of {Transfer} event(s).
1709      *
1710      * Calling this function outside of contract creation WILL make your contract
1711      * non-compliant with the ERC721 standard.
1712      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1713      * {ConsecutiveTransfer} event is only permissible during contract creation.
1714      *
1715      * Requirements:
1716      *
1717      * - `to` cannot be the zero address.
1718      * - `quantity` must be greater than 0.
1719      *
1720      * Emits a {ConsecutiveTransfer} event.
1721      */
1722     function _mintERC2309(address to, uint256 quantity) internal virtual {
1723         uint256 startTokenId = _currentIndex;
1724         if (to == address(0)) revert MintToZeroAddress();
1725         if (quantity == 0) revert MintZeroQuantity();
1726         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1727 
1728         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1729 
1730         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1731         unchecked {
1732             // Updates:
1733             // - `balance += quantity`.
1734             // - `numberMinted += quantity`.
1735             //
1736             // We can directly add to the `balance` and `numberMinted`.
1737             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1738 
1739             // Updates:
1740             // - `address` to the owner.
1741             // - `startTimestamp` to the timestamp of minting.
1742             // - `burned` to `false`.
1743             // - `nextInitialized` to `quantity == 1`.
1744             _packedOwnerships[startTokenId] = _packOwnershipData(
1745                 to,
1746                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1747             );
1748 
1749             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1750 
1751             _currentIndex = startTokenId + quantity;
1752         }
1753         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1754     }
1755 
1756     /**
1757      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1758      *
1759      * Requirements:
1760      *
1761      * - If `to` refers to a smart contract, it must implement
1762      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1763      * - `quantity` must be greater than 0.
1764      *
1765      * See {_mint}.
1766      *
1767      * Emits a {Transfer} event for each mint.
1768      */
1769     function _safeMint(
1770         address to,
1771         uint256 quantity,
1772         bytes memory _data
1773     ) internal virtual {
1774         _mint(to, quantity);
1775 
1776         unchecked {
1777             if (to.code.length != 0) {
1778                 uint256 end = _currentIndex;
1779                 uint256 index = end - quantity;
1780                 do {
1781                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1782                         revert TransferToNonERC721ReceiverImplementer();
1783                     }
1784                 } while (index < end);
1785                 // Reentrancy protection.
1786                 if (_currentIndex != end) revert();
1787             }
1788         }
1789     }
1790 
1791     /**
1792      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1793      */
1794     function _safeMint(address to, uint256 quantity) internal virtual {
1795         _safeMint(to, quantity, '');
1796     }
1797 
1798     // =============================================================
1799     //                        BURN OPERATIONS
1800     // =============================================================
1801 
1802     /**
1803      * @dev Equivalent to `_burn(tokenId, false)`.
1804      */
1805     function _burn(uint256 tokenId) internal virtual {
1806         _burn(tokenId, false);
1807     }
1808 
1809     /**
1810      * @dev Destroys `tokenId`.
1811      * The approval is cleared when the token is burned.
1812      *
1813      * Requirements:
1814      *
1815      * - `tokenId` must exist.
1816      *
1817      * Emits a {Transfer} event.
1818      */
1819     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1820         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1821 
1822         address from = address(uint160(prevOwnershipPacked));
1823 
1824         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1825 
1826         if (approvalCheck) {
1827             // The nested ifs save around 20+ gas over a compound boolean condition.
1828             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1829                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1830         }
1831 
1832         _beforeTokenTransfers(from, address(0), tokenId, 1);
1833 
1834         // Clear approvals from the previous owner.
1835         assembly {
1836             if approvedAddress {
1837                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1838                 sstore(approvedAddressSlot, 0)
1839             }
1840         }
1841 
1842         // Underflow of the sender's balance is impossible because we check for
1843         // ownership above and the recipient's balance can't realistically overflow.
1844         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1845         unchecked {
1846             // Updates:
1847             // - `balance -= 1`.
1848             // - `numberBurned += 1`.
1849             //
1850             // We can directly decrement the balance, and increment the number burned.
1851             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1852             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1853 
1854             // Updates:
1855             // - `address` to the last owner.
1856             // - `startTimestamp` to the timestamp of burning.
1857             // - `burned` to `true`.
1858             // - `nextInitialized` to `true`.
1859             _packedOwnerships[tokenId] = _packOwnershipData(
1860                 from,
1861                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1862             );
1863 
1864             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1865             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1866                 uint256 nextTokenId = tokenId + 1;
1867                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1868                 if (_packedOwnerships[nextTokenId] == 0) {
1869                     // If the next slot is within bounds.
1870                     if (nextTokenId != _currentIndex) {
1871                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1872                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1873                     }
1874                 }
1875             }
1876         }
1877 
1878         emit Transfer(from, address(0), tokenId);
1879         _afterTokenTransfers(from, address(0), tokenId, 1);
1880 
1881         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1882         unchecked {
1883             _burnCounter++;
1884         }
1885     }
1886 
1887     // =============================================================
1888     //                     EXTRA DATA OPERATIONS
1889     // =============================================================
1890 
1891     /**
1892      * @dev Directly sets the extra data for the ownership data `index`.
1893      */
1894     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1895         uint256 packed = _packedOwnerships[index];
1896         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1897         uint256 extraDataCasted;
1898         // Cast `extraData` with assembly to avoid redundant masking.
1899         assembly {
1900             extraDataCasted := extraData
1901         }
1902         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1903         _packedOwnerships[index] = packed;
1904     }
1905 
1906     /**
1907      * @dev Called during each token transfer to set the 24bit `extraData` field.
1908      * Intended to be overridden by the cosumer contract.
1909      *
1910      * `previousExtraData` - the value of `extraData` before transfer.
1911      *
1912      * Calling conditions:
1913      *
1914      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1915      * transferred to `to`.
1916      * - When `from` is zero, `tokenId` will be minted for `to`.
1917      * - When `to` is zero, `tokenId` will be burned by `from`.
1918      * - `from` and `to` are never both zero.
1919      */
1920     function _extraData(
1921         address from,
1922         address to,
1923         uint24 previousExtraData
1924     ) internal view virtual returns (uint24) {}
1925 
1926     /**
1927      * @dev Returns the next extra data for the packed ownership data.
1928      * The returned result is shifted into position.
1929      */
1930     function _nextExtraData(
1931         address from,
1932         address to,
1933         uint256 prevOwnershipPacked
1934     ) private view returns (uint256) {
1935         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1936         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1937     }
1938 
1939     // =============================================================
1940     //                       OTHER OPERATIONS
1941     // =============================================================
1942 
1943     /**
1944      * @dev Returns the message sender (defaults to `msg.sender`).
1945      *
1946      * If you are writing GSN compatible contracts, you need to override this function.
1947      */
1948     function _msgSenderERC721A() internal view virtual returns (address) {
1949         return msg.sender;
1950     }
1951 
1952     /**
1953      * @dev Converts a uint256 to its ASCII string decimal representation.
1954      */
1955     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1956         assembly {
1957             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1958             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1959             // We will need 1 32-byte word to store the length,
1960             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1961             str := add(mload(0x40), 0x80)
1962             // Update the free memory pointer to allocate.
1963             mstore(0x40, str)
1964 
1965             // Cache the end of the memory to calculate the length later.
1966             let end := str
1967 
1968             // We write the string from rightmost digit to leftmost digit.
1969             // The following is essentially a do-while loop that also handles the zero case.
1970             // prettier-ignore
1971             for { let temp := value } 1 {} {
1972                 str := sub(str, 1)
1973                 // Write the character to the pointer.
1974                 // The ASCII index of the '0' character is 48.
1975                 mstore8(str, add(48, mod(temp, 10)))
1976                 // Keep dividing `temp` until zero.
1977                 temp := div(temp, 10)
1978                 // prettier-ignore
1979                 if iszero(temp) { break }
1980             }
1981 
1982             let length := sub(end, str)
1983             // Move the pointer 32 bytes leftwards to make room for the length.
1984             str := sub(str, 0x20)
1985             // Store the length.
1986             mstore(str, length)
1987         }
1988     }
1989 }
1990 // File: @openzeppelin/contracts/access/Ownable.sol
1991 
1992 
1993 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1994 
1995 pragma solidity ^0.8.0;
1996 
1997 
1998 /**
1999  * @dev Contract module which provides a basic access control mechanism, where
2000  * there is an account (an owner) that can be granted exclusive access to
2001  * specific functions.
2002  *
2003  * By default, the owner account will be the one that deploys the contract. This
2004  * can later be changed with {transferOwnership}.
2005  *
2006  * This module is used through inheritance. It will make available the modifier
2007  * `onlyOwner`, which can be applied to your functions to restrict their use to
2008  * the owner.
2009  */
2010 abstract contract Ownable is Context {
2011     address private _owner;
2012 
2013     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2014 
2015     /**
2016      * @dev Initializes the contract setting the deployer as the initial owner.
2017      */
2018     constructor() {
2019         _transferOwnership(_msgSender());
2020     }
2021 
2022     /**
2023      * @dev Throws if called by any account other than the owner.
2024      */
2025     modifier onlyOwner() {
2026         _checkOwner();
2027         _;
2028     }
2029 
2030     /**
2031      * @dev Returns the address of the current owner.
2032      */
2033     function owner() public view virtual returns (address) {
2034         return _owner;
2035     }
2036 
2037     /**
2038      * @dev Throws if the sender is not the owner.
2039      */
2040     function _checkOwner() internal view virtual {
2041         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2042     }
2043 
2044     /**
2045      * @dev Leaves the contract without owner. It will not be possible to call
2046      * `onlyOwner` functions anymore. Can only be called by the current owner.
2047      *
2048      * NOTE: Renouncing ownership will leave the contract without an owner,
2049      * thereby removing any functionality that is only available to the owner.
2050      */
2051     function renounceOwnership() public virtual onlyOwner {
2052         _transferOwnership(address(0));
2053     }
2054 
2055     /**
2056      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2057      * Can only be called by the current owner.
2058      */
2059     function transferOwnership(address newOwner) public virtual onlyOwner {
2060         require(newOwner != address(0), "Ownable: new owner is the zero address");
2061         _transferOwnership(newOwner);
2062     }
2063 
2064     /**
2065      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2066      * Internal function without access restriction.
2067      */
2068     function _transferOwnership(address newOwner) internal virtual {
2069         address oldOwner = _owner;
2070         _owner = newOwner;
2071         emit OwnershipTransferred(oldOwner, newOwner);
2072     }
2073 }
2074 
2075 // File: Arlasoul.sol
2076 
2077 //SPDX-License-Identifier: MIT
2078 
2079 
2080 
2081 
2082 
2083 
2084 
2085 
2086 pragma solidity ^0.8.4;
2087 
2088 contract Arla is ERC721A, Ownable, ReentrancyGuard {
2089 
2090    uint256 public PUBLIC_PRICE = 0.0066 ether;
2091     uint256 public WL_COST = 0 ether;
2092     uint16 public maxSupply = 999;
2093     uint256 private WL_LIMIT = 222;
2094     uint256 private OG_LIMIT = 110;
2095     uint256 private WL_COUNTER = 0;
2096     uint256 private OG_COUNTER = 0;
2097 
2098     mapping (address => uint8) private WL_MINTED;
2099     mapping (address => uint8) private _minted;
2100 
2101 
2102     uint8 public maxMintAmount = 3;
2103 
2104     string private _baseTokenURI =
2105         "";
2106 
2107     bytes32 private WL_ROOT;
2108 
2109     bool public WL_SALE_ACTIVE;
2110     bool public PUBLIC_SALE_ACTIVE;
2111 
2112     constructor() ERC721A("Arla", "soul") {
2113       _mint(0x4af81154645967D7ab1Cb77A83080A0Bf5F86D8E, 1);
2114     }
2115 
2116     modifier callerIsUser() {
2117         if (msg.sender != tx.origin) revert ("no Contract!");
2118         _;
2119     }
2120 
2121     function SET_WL_ROOT(bytes32 _WL_ROOT)
2122         external
2123         onlyOwner
2124     {
2125         WL_ROOT = _WL_ROOT;
2126     }
2127 
2128     function WL_CONFIRMED(address _user, bytes32[] calldata WL_PROOF)
2129         external
2130         view
2131         returns (bool)
2132     {
2133         return
2134             MerkleProof.verify(
2135                 WL_PROOF,
2136                 WL_ROOT,
2137                 keccak256(abi.encodePacked(_user))
2138             );
2139     }
2140     
2141     function SET_WL_LIMIT(uint256 _WL_LIMIT)external onlyOwner{
2142         WL_LIMIT = _WL_LIMIT;
2143     }
2144 
2145     function reduceSupply(uint16 _newReducedSupply) external onlyOwner {
2146         if (_newReducedSupply > maxSupply) revert ("Can not Increase Max Supply!");
2147         maxSupply = _newReducedSupply;
2148     }
2149 
2150     function SET_PUBLIC_COST(uint256 _newPUBLIC_PRICE) external onlyOwner {
2151         if (_newPUBLIC_PRICE > PUBLIC_PRICE) revert ("Can not Increase Cost!");
2152         PUBLIC_PRICE = _newPUBLIC_PRICE;
2153     }
2154 
2155     function _startTokenId() internal view virtual override returns (uint256) {
2156         return 1;
2157     }
2158 
2159     function SET_WL_COST(uint256 _newWL_COST) external onlyOwner {
2160         if (_newWL_COST > WL_COST) revert ("Can not Increase Cost!");
2161         WL_COST = _newWL_COST;
2162     }
2163 
2164     function WL_MINT(bytes32[] calldata WL_PROOF)
2165         external
2166         payable
2167         callerIsUser
2168     {
2169         uint256 ts = totalSupply();
2170         if(WL_COUNTER > WL_LIMIT) revert ("WL Supply Sold Out!");
2171         if (!WL_SALE_ACTIVE) revert ("WL Sale is Not Active.");
2172         if (ts + 1 > maxSupply) revert ("Mint Would Exceed MaxSupply");
2173         if (msg.value != WL_COST * 1) revert ("Insufficient Fund!");
2174         if (
2175             !MerkleProof.verify(
2176                 WL_PROOF,
2177                 WL_ROOT,
2178                 keccak256(abi.encodePacked(msg.sender))
2179             )
2180         ) revert ("Only WL!");
2181         if (WL_MINTED[msg.sender] + 1 > 1)
2182             revert ("Already Minted!");
2183 
2184         WL_COUNTER += 1;
2185         WL_MINTED[msg.sender] += 1;
2186         _mint(msg.sender, 1);        
2187     }
2188 
2189     function PUBLIC_MINT(uint8 _amount) external payable callerIsUser {
2190         uint256 ts = totalSupply();
2191             if (!PUBLIC_SALE_ACTIVE) revert ("Public Sale is Not Active.");
2192             if (ts + _amount > maxSupply - WL_LIMIT) revert ("Max Supply Sold Out!");
2193             if (_minted[msg.sender] + _amount > maxMintAmount)
2194                 revert ("Already Minted!");
2195             if (msg.value != PUBLIC_PRICE * _amount) revert ("Insufficient Fund!");
2196 
2197             _minted[msg.sender] += _amount; 
2198 
2199             _mint(msg.sender, _amount);
2200         }
2201 
2202     function OG_DROP(address[] memory targets) external onlyOwner {
2203         if (targets.length + OG_COUNTER >= OG_LIMIT) revert ("Max Supply Sold Out!");
2204 
2205         OG_COUNTER += targets.length;
2206 
2207         for (uint256 i = 0; i < targets.length; i++) {
2208             _mint(targets[i], 2);
2209         }
2210     }
2211     
2212 
2213     function setMaxMintAmount(uint8 _maxMintAmount) external onlyOwner {
2214         maxMintAmount = _maxMintAmount;
2215     }
2216 
2217     function _baseURI() internal view virtual override returns (string memory) {
2218         return _baseTokenURI;
2219     }
2220 
2221     function setBaseURI(string calldata baseURI) external onlyOwner {
2222         _baseTokenURI = baseURI;
2223     }
2224 
2225     function Start() external onlyOwner {
2226         PUBLIC_SALE_ACTIVE = !PUBLIC_SALE_ACTIVE;
2227     }
2228 
2229     function Flip_Sale() external onlyOwner {
2230         PUBLIC_SALE_ACTIVE = !PUBLIC_SALE_ACTIVE;
2231         WL_SALE_ACTIVE = !WL_SALE_ACTIVE;
2232     }
2233 
2234     function Pause() external onlyOwner {
2235         PUBLIC_SALE_ACTIVE = false;
2236         WL_SALE_ACTIVE = false;
2237     }
2238 
2239     function withdraw() external onlyOwner nonReentrant {
2240         (bool hs, ) = payable(0xD59e4BF1e4499dF016C5353D867B51e0F9BeB9ce).call{value: address(this).balance * 70 / 100}('');
2241         require(hs);
2242         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2243         require(os);
2244     }
2245 }